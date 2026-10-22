#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
music_converter.py — Pipeline automatisé de téléchargement, normalisation et
conversion Ogg Vorbis pour les musiques de fangame Pokémon Mystery Dungeon.

Fonctionnalités :
  - Parsing de fichier de configuration (music_config.json) liant donjon et source.
  - Téléchargement haute qualité depuis YouTube (yt-dlp) ou sources locales.
  - Normalisation EBU R128 (loudnorm via ffmpeg) pour un volume homogène.
  - Suppression automatique des silences de début et de fin (silenceremove).
  - Conversion Ogg Vorbis paramétrée pour RogueEssence / PMDO (-aq 5, 44100 Hz).
  - Gestion des balises OggVorbis (LOOPSTART, LOOPLENGTH, TITLE, ALBUM).
  - Exécution parallèle par Pool de threads (ThreadPoolExecutor).
  - Journalisation exhaustive dans `conversion.log` et reprise sur erreur.
"""
from __future__ import annotations

import argparse
import concurrent.futures
import json
import logging
import os
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any

# Configuration du journal d'exécution
MOD_ROOT = Path(__file__).resolve().parent.parent
LOG_PATH = MOD_ROOT / "conversion.log"
OUTPUT_DIR = MOD_ROOT / "Content" / "Music"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_PATH, encoding="utf-8"),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger("MusicConverter")


@dataclass
class TrackConfig:
    """Représente la configuration de traitement d'une piste audio."""
    dungeon_name: str
    source: str
    filename: str
    loop_start: int | None = None
    loop_length: int | None = None
    comment: str | None = None

    @classmethod
    def from_dict(cls, name: str, raw: dict[str, Any] | str) -> TrackConfig:
        if isinstance(raw, str):
            clean_name = "".join(x for x in name if x.isalnum() or x in ("_", "-"))
            return cls(dungeon_name=name, source=raw, filename=f"{clean_name}.ogg")
        return cls(
            dungeon_name=name,
            source=raw["source"],
            filename=raw.get("filename", f"{name.replace(' ', '')}.ogg"),
            loop_start=raw.get("loop_start"),
            loop_length=raw.get("loop_length"),
            comment=raw.get("comment")
        )


class BinaryChecker:
    """Vérifie la présence et la disponibilité des binaires externes requis."""
    @staticmethod
    def check_ffmpeg() -> bool:
        return shutil.which("ffmpeg") is not None

    @staticmethod
    def check_ytdlp() -> bool:
        return shutil.which("yt-dlp") is not None


class AudioDownloader:
    """Télécharge l'audio brut d'une vidéo YouTube via yt-dlp."""
    def __init__(self, temp_dir: Path):
        self.temp_dir = temp_dir
        self.temp_dir.mkdir(parents=True, exist_ok=True)

    def download(self, track: TrackConfig) -> Path:
        """Télécharge la piste audio et retourne le chemin du fichier temporaire."""
        target_stem = Path(track.filename).stem
        temp_out = self.temp_dir / f"{target_stem}_raw.flac"

        # Si ce n'est pas une URL YouTube, vérifier si c'est un fichier local
        if not track.source.startswith("http://") and not track.source.startswith("https://"):
            local_src = Path(track.source)
            if not local_src.exists():
                local_src = MOD_ROOT / track.source
            if local_src.exists():
                logger.info(f"[{track.dungeon_name}] Source locale détectée : {local_src}")
                return local_src
            raise FileNotFoundError(f"Fichier local introuvable : {track.source}")

        if not BinaryChecker.check_ytdlp():
            raise RuntimeError(
                "Le binaire `yt-dlp` n'est pas installé dans le PATH. "
                "Installez-le (`pip install yt-dlp`) ou fournissez un chemin de fichier local."
            )

        logger.info(f"[{track.dungeon_name}] Téléchargement YouTube : {track.source}")
        cmd = [
            "yt-dlp",
            "-f", "bestaudio",
            "-x", "--audio-format", "flac",
            "--audio-quality", "0",
            "-o", str(self.temp_dir / f"{target_stem}_raw.%(ext)s"),
            "--no-playlist",
            track.source
        ]
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0:
            raise RuntimeError(f"Échec yt-dlp pour {track.dungeon_name} : {res.stderr}")
        
        # Trouver le fichier extrait
        for ext in (".flac", ".wav", ".opus", ".m4a", ".mp3"):
            candidate = self.temp_dir / f"{target_stem}_raw{ext}"
            if candidate.exists():
                return candidate
        raise FileNotFoundError(f"Fichier audio téléchargé introuvable pour {track.dungeon_name}")


class AudioNormalizerAndConverter:
    """Gère le découpage de silence, la normalisation EBU R128 et l'encodage Ogg."""
    def __init__(self, output_dir: Path, temp_dir: Path):
        self.output_dir = output_dir
        self.temp_dir = temp_dir
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def process_and_convert(
        self,
        input_path: Path,
        track: TrackConfig,
        do_normalize: bool = True
    ) -> Path:
        """Applique les filtres audio ffmpeg et convertit en Ogg Vorbis."""
        if not BinaryChecker.check_ffmpeg():
            raise RuntimeError(
                "Le binaire `ffmpeg` n'est pas installé. L'encodage Ogg Vorbis "
                "et la normalisation nécessitent FFmpeg."
            )

        dest_path = self.output_dir / track.filename
        logger.info(f"[{track.dungeon_name}] Traitement audio -> {dest_path.name}")

        # Chaîne de filtres FFmpeg :
        # 1. silenceremove : supprime les silences > 0.5s au seuil -50dB en début et fin
        # 2. loudnorm (facultatif) : normalise selon la norme broadcast EBU R128 (-14 LUFS)
        filters = []
        filters.append(
            "silenceremove=start_periods=1:start_duration=0.1:start_threshold=-50dB:"
            "stop_periods=1:stop_duration=0.5:stop_threshold=-50dB"
        )
        if do_normalize:
            filters.append("loudnorm=I=-14:TP=-1.5:LRA=11")

        filter_chain = ",".join(filters)

        cmd = [
            "ffmpeg", "-y",
            "-i", str(input_path),
            "-af", filter_chain,
            "-c:a", "libvorbis",
            "-aq", "5",          # Qualité Vorbis optimale q=5 (~160 kbps variable)
            "-ar", "44100",      # Fréquence canonique PMDO
            "-metadata", f"TITLE={track.dungeon_name}",
            "-metadata", f"ALBUM=New Era: Abyss to Ascension",
            "-metadata", f"ARTIST=GlitchxCity / Exclusive PMD"
        ]

        if track.loop_start is not None:
            cmd.extend(["-metadata", f"LOOPSTART={track.loop_start}"])
        if track.loop_length is not None:
            cmd.extend(["-metadata", f"LOOPLENGTH={track.loop_length}"])
        if track.comment:
            cmd.extend(["-metadata", f"COMMENT={track.comment}"])

        cmd.append(str(dest_path))

        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0:
            raise RuntimeError(f"Échec ffmpeg pour {track.dungeon_name} : {res.stderr}")

        logger.info(f"[{track.dungeon_name}] ✅ Fichier Ogg écrit ({dest_path.stat().st_size // 1024} Ko).")
        return dest_path


class MusicConverterPipeline:
    """Orchestrateur du pipeline audio avec exécution multithreadée."""
    def __init__(self, config_path: Path, max_workers: int = 4):
        self.config_path = config_path
        self.max_workers = max_workers
        self.temp_dir = MOD_ROOT / "tools" / ".audio_tmp"
        self.downloader = AudioDownloader(self.temp_dir)
        self.converter = AudioNormalizerAndConverter(OUTPUT_DIR, self.temp_dir)

    def load_config(self) -> list[TrackConfig]:
        if not self.config_path.exists():
            raise FileNotFoundError(f"Fichier de configuration introuvable : {self.config_path}")
        with open(self.config_path, "r", encoding="utf-8") as f:
            raw_dict = json.load(f)
        return [TrackConfig.from_dict(name, val) for name, val in raw_dict.items()]

    def process_single_track(
        self,
        track: TrackConfig,
        do_download: bool,
        do_convert: bool,
        do_normalize: bool,
        force: bool
    ) -> bool:
        """Traite une seule piste et retourne True en cas de succès."""
        dest_path = OUTPUT_DIR / track.filename
        if dest_path.exists() and not force:
            logger.info(f"[{track.dungeon_name}] ⏭️ Ignoré (déjà existant) : {track.filename}")
            return True

        try:
            raw_audio: Path | None = None
            if do_download:
                try:
                    raw_audio = self.downloader.download(track)
                except RuntimeError as e:
                    # En environnement déconnecté ou sans yt-dlp, tenter un fichier local mocké
                    logger.warning(f"[{track.dungeon_name}] Téléchargement impossible : {e}")
                    return False
            else:
                # Chercher la source localement
                local_candidate = MOD_ROOT / track.source
                if local_candidate.exists():
                    raw_audio = local_candidate

            if raw_audio and do_convert:
                self.converter.process_and_convert(raw_audio, track, do_normalize=do_normalize)
                return True
            elif not raw_audio:
                logger.warning(f"[{track.dungeon_name}] Aucune source audio brute disponible pour la conversion.")
                return False
            return True
        except Exception as e:
            logger.error(f"[{track.dungeon_name}] ❌ Erreur critique : {e}", exc_info=True)
            return False

    def run(
        self,
        do_download: bool = True,
        do_convert: bool = True,
        do_normalize: bool = True,
        force: bool = False
    ) -> dict[str, int]:
        """Exécute le pipeline pour toutes les pistes en parallèle."""
        tracks = self.load_config()
        logger.info(f"=== Lancement du MusicConverterPipeline ({len(tracks)} pistes, {self.max_workers} threads) ===")
        start_time = time.time()

        success_count = 0
        failure_count = 0

        with concurrent.futures.ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            future_to_track = {
                executor.submit(
                    self.process_single_track,
                    t,
                    do_download,
                    do_convert,
                    do_normalize,
                    force
                ): t
                for t in tracks
            }
            for future in concurrent.futures.as_completed(future_to_track):
                t = future_to_track[future]
                try:
                    if future.result():
                        success_count += 1
                    else:
                        failure_count += 1
                except Exception as e:
                    logger.error(f"[{t.dungeon_name}] Exception dans le thread : {e}")
                    failure_count += 1

        elapsed = time.time() - start_time
        logger.info(
            f"=== Pipeline terminé en {elapsed:.2f}s : "
            f"{success_count} succès, {failure_count} échecs ==="
        )
        return {"success": success_count, "failure": failure_count}


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Outil de conversion audio automatique pour Pokémon Mystery Dungeon (New Era)."
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=MOD_ROOT / "tools" / "music_config.json",
        help="Chemin du fichier de configuration JSON/YAML"
    )
    parser.add_argument("--download", action="store_true", help="Télécharger uniquement depuis la config")
    parser.add_argument("--convert", action="store_true", help="Convertir en Ogg Vorbis (-aq 5, 44100 Hz)")
    parser.add_argument("--normalize", action="store_true", help="Normaliser le volume (EBU R128)")
    parser.add_argument("--all", action="store_true", help="Exécuter tout le pipeline (téléchargement + normalisation + Ogg)")
    parser.add_argument("--force", action="store_true", help="Forcer la reconversion même si le .ogg existe déjà")
    parser.add_argument("--workers", type=int, default=4, help="Nombre de threads parallèles (défaut: 4)")
    return parser.parse_args()


def main():
    args = parse_arguments()

    # Déterminer les actions à mener
    if args.all or (not args.download and not args.convert and not args.normalize):
        do_download = True
        do_convert = True
        do_normalize = True
    else:
        do_download = args.download
        do_convert = args.convert
        do_normalize = args.normalize

    pipeline = MusicConverterPipeline(args.config, max_workers=args.workers)
    try:
        results = pipeline.run(
            do_download=do_download,
            do_convert=do_convert,
            do_normalize=do_normalize,
            force=args.force
        )
        sys.exit(0 if results["failure"] == 0 else 1)
    except Exception as e:
        logger.critical(f"Erreur d'initialisation du pipeline : {e}", exc_info=True)
        sys.exit(2)


if __name__ == "__main__":
    main()
