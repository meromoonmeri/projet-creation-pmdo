#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Assembleur clé-en-main du dépôt unique « PROJET PMD » basé sur `town02` / `Palikadude/Halcyon`.

Architecture de placement 100 % conforme à `Palikadude/Halcyon` & `meromoonmeri/town02`
(`PMDO 0.8.12.0`, `<Namespace>halcyon</Namespace>`) :

  1. `Mod.xml` à la racine : `<Name>PROJET PMD</Name>`, `<Namespace>halcyon</Namespace>`,
     `<GameVersion>0.8.12</GameVersion>`, `<ModType>Quest</ModType>`.
  2. `Content/Tile/<Sheet>.tile` + mise à jour atomique triée alphabétiquement de
     `Content/Tile/index.idx` (`RogueEssence.Content.TileGuide` binaire).
  3. `Data/Ground/<ground_id>.rsground` (JSON UTF-8 avec BOM `\ufeff` et synchronisation
     stricte `Object.AssetName == "<ground_id>"`, sans jamais écraser les grounds natifs
     de `town02` : alias `<nom>__custom_pmdo.rsground` en cas d'homonymie).
  4. `Data/Script/halcyon/ground/<ground_id>/init.lua` : relocalisation automatique des
     scripts issus des mini-mods autonomes (`Data/Script/<ns>/ground/<id>/init.lua` ou
     `Data/Script/ground/<id>/init.lua`) vers l'espace de noms `halcyon`, et génération
     d'un `init.lua` Halcyon `0.8.12` valide (`COMMON.RespawnAllies()`, `GAME:FadeIn(20)`)
     pour tout `.rsground` n'ayant pas encore de script dédié.
  5. `Data/Zone/master_zone.json` (`Object.GroundMaps`) + `Data/Zone/index.idx`
     (`Object["master_zone"]["Grounds"]`) : enregistrement de chaque nouveau `<ground_id>`
     à la suite des indices existants de `town02` (`0..390` intacts) pour accès immédiat
     via `GAME:EnterGroundMap(...)` et le menu Dev Warp de PMDO.
  6. `Halcyon Mods/sources_projet_pmd/` : archivage propre des générateurs Python, du kit
     Guilde Treehouse (`12` salles modulaires, `6` ambiances, `fenetres_exterieur/`,
     `calques/`) et du Studio HTML 60 FPS, selon la convention racine de `Palikadude/Halcyon`.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import struct
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Set, Tuple

PNG_SIG = b"\x89PNG\r\n\x1a\n"
LFS_POINTER_PREFIX = b"version https://git-lfs.github.com/spec/v1"

DEFAULT_OWNER = "meromoonmeri"
DEFAULT_BASE_REPO = "meromoonmeri/town02"
DEFAULT_PREFERRED_BRANCH = "arena/637b0828-projet-creation-pmdo"
DEFAULT_MOD_NAME = "PROJET PMD"

# Mode ciblé par défaut demandé par l'utilisateur :
#   town02 + projet-creation-pmdo@arena/637b0828-projet-creation-pmdo + guilde-treehouse-pmd
PROJET_PMD_TARGET_REPOS: List[Tuple[str, Optional[str], bool]] = [
    ("meromoonmeri/projet-creation-pmdo", DEFAULT_PREFERRED_BRANCH, True),
    ("meromoonmeri/guilde-treehouse-pmd", None, False),
]

# Mode élargi optionnel (--toutes-branches) couvrant les 36+ branches historiques
ALL_BRANCHES_SOURCE_REPOS: List[Tuple[str, Optional[str], bool]] = [
    ("meromoonmeri/projet-creation-pmdo", None, True),
    ("meromoonmeri/projet-pmdo", None, True),
    ("meromoonmeri/zone-pmdo", None, True),
    ("meromoonmeri/all-zone-PMDO-project", None, True),
    ("meromoonmeri/guilde-treehouse-pmd", None, False),
]

GUILDE_ROOT_DIRS: Tuple[str, ...] = (
    "salles",
    "fenetres_exterieur",
    "exterieur",
    "calques",
    "sprites",
    "exports",
    "tiled",
    "apercus",
    "OUTILS",
    "beachsky_v1",
    "col_eboulis_v1",
)

ROOT_DOC_FILES: Tuple[str, ...] = (
    "JOURNAL_GUILDE_TREEHOUSE.md",
    "GUIDE_CREATION_DE_MAP.md",
    "METHODE_MAGENTA_ET_GENERATEUR.md",
    "MANUEL_METHODE_PMDO.md",
    "INDEX_METHODES.md",
    "REPRISE_MAPS.md",
    "kit.json",
)


# ============================================================================
# Encodage / décodage binaire exact de Content/Tile/index.idx (PMDO 0.8.12.0)
# ============================================================================

def _read_7bit_int(buf: bytes, pos: int) -> Tuple[int, int]:
    """Lit un entier 7-bit LEB128 (.NET BinaryReader.Read7BitEncodedInt)."""
    result = 0
    shift = 0
    while True:
        if pos >= len(buf):
            raise ValueError("Fin de flux inattendue dans Read7BitEncodedInt")
        b = buf[pos]
        pos += 1
        result |= (b & 0x7F) << shift
        if (b & 0x80) == 0:
            return result, pos
        shift += 7
        if shift >= 35:
            raise ValueError("Entier 7-bit LEB128 invalide dans index.idx")


def _write_7bit_int(val: int) -> bytes:
    """Écrit un entier 7-bit LEB128 (.NET BinaryWriter.Write7BitEncodedInt)."""
    if val < 0:
        raise ValueError(f"Longueur négative invalide : {val}")
    out = bytearray()
    v = val
    while v >= 0x80:
        out.append((v & 0x7F) | 0x80)
        v >>= 7
    out.append(v & 0x7F)
    return bytes(out)


@dataclass
class TileIndexEntry:
    sheet: str
    tile_size: int
    tile_count: int
    table_bytes: bytes

    def positions_dict(self) -> Dict[Tuple[int, int], int]:
        pos: Dict[Tuple[int, int], int] = {}
        for i in range(self.tile_count):
            key, offset = struct.unpack_from("<QQ", self.table_bytes, i * 16)
            pos[(key & 0xFFFFFFFF, (key >> 32) & 0xFFFFFFFF)] = offset
        return pos


def lire_tile_index(idx_path: Path) -> List[TileIndexEntry]:
    """Lit Content/Tile/index.idx et retourne la liste ordonnée des planches."""
    data = idx_path.read_bytes()
    if len(data) < 4:
        raise ValueError(f"index.idx trop court ({len(data)} octets) : {idx_path}")
    count = struct.unpack_from("<I", data, 0)[0]
    pos = 4
    entries: List[TileIndexEntry] = []
    for _ in range(count):
        name_len, pos = _read_7bit_int(data, pos)
        sheet = data[pos : pos + name_len].decode("utf-8")
        pos += name_len
        tile_size, tile_count = struct.unpack_from("<II", data, pos)
        pos += 8
        table_len = tile_count * 16
        table = data[pos : pos + table_len]
        if len(table) != table_len:
            raise ValueError(f"Table tronquée pour la planche '{sheet}'")
        pos += table_len
        entries.append(TileIndexEntry(sheet, tile_size, tile_count, table))
    if pos != len(data):
        raise ValueError(
            f"Octets résiduels dans index.idx ({pos} lus sur {len(data)})"
        )
    return entries


def serialiser_tile_index(entries: Sequence[TileIndexEntry]) -> bytes:
    """Sérialise une liste d'entrées au format binaire exact TileGuide."""
    out = bytearray()
    out += struct.pack("<I", len(entries))
    for e in entries:
        enc = e.sheet.encode("utf-8")
        out += _write_7bit_int(len(enc))
        out += enc
        out += struct.pack("<II", e.tile_size, e.tile_count)
        if len(e.table_bytes) != e.tile_count * 16:
            raise ValueError(
                f"Taille de table incohérente pour '{e.sheet}': "
                f"{len(e.table_bytes)} != {e.tile_count * 16}"
            )
        out += e.table_bytes
    return bytes(out)


def extraire_entree_depuis_fichier_tile(tile_path: Path) -> TileIndexEntry:
    """Extrait l'entrée d'index directement depuis l'en-tête d'un fichier .tile."""
    raw = tile_path.read_bytes()
    if raw.startswith(LFS_POINTER_PREFIX):
        raise ValueError(
            f"Le fichier {tile_path.name} est un pointeur Git LFS non téléchargé "
            f"(exécutez `git lfs pull` avant l'indexation)."
        )
    if len(raw) < 8:
        raise ValueError(f"Fichier .tile invalide ou vide : {tile_path}")
    tile_size, tile_count = struct.unpack_from("<II", raw, 0)
    table_len = tile_count * 16
    table = raw[8 : 8 + table_len]
    if len(table) != table_len:
        raise ValueError(f"En-tête .tile tronqué : {tile_path}")
    return TileIndexEntry(tile_path.stem, tile_size, tile_count, table)


def injecter_planches_dans_index(
    idx_path: Path, tile_files: Iterable[Path]
) -> Tuple[int, int, int]:
    """Insère ou met à jour un lot de fichiers `.tile` dans `Content/Tile/index.idx`."""
    if idx_path.exists():
        original_bytes = idx_path.read_bytes()
        if original_bytes.startswith(LFS_POINTER_PREFIX):
            raise RuntimeError(
                f"{idx_path} est un pointeur Git LFS non matérialisé ; lancez `git lfs pull`."
            )
        existing = lire_tile_index(idx_path)
        if serialiser_tile_index(existing) != original_bytes:
            raise RuntimeError(
                "Abandon sécurité : la re-sérialisation de index.idx ne correspond pas "
                "octet pour octet à l'original."
            )
    else:
        existing = []

    nb_avant = len(existing)
    by_name: Dict[str, TileIndexEntry] = {e.sheet: e for e in existing}
    injected = 0
    for tp in sorted(tile_files, key=lambda p: p.stem):
        entry = extraire_entree_depuis_fichier_tile(tp)
        by_name[entry.sheet] = entry
        injected += 1

    merged = [by_name[k] for k in sorted(by_name.keys())]
    idx_path.parent.mkdir(parents=True, exist_ok=True)
    idx_path.write_bytes(serialiser_tile_index(merged))

    reloaded = lire_tile_index(idx_path)
    if len(reloaded) != len(merged):
        raise RuntimeError("Échec du contrôle après écriture de index.idx")
    return nb_avant, len(merged), injected


# ============================================================================
# Garde anti-damier mauve (.rsground et .rsmap)
# ============================================================================

def extraire_references_tuiles_rsground(map_path: Path) -> Optional[Set[Tuple[str, int, int]]]:
    """Retourne tous les triplets `(Sheet, X, Y)` d'un `.rsground` ou `.rsmap`."""
    with map_path.open("rb") as fh:
        head = fh.read(64)
    if head.startswith(LFS_POINTER_PREFIX):
        return None

    data = json.loads(map_path.read_text(encoding="utf-8-sig"))
    obj = data.get("Object", data)
    refs: Set[Tuple[str, int, int]] = set()

    def _walk_frames(frames: Optional[list]) -> None:
        for f in frames or []:
            if isinstance(f, dict) and "Sheet" in f and "TexLoc" in f:
                sheet = f["Sheet"]
                if sheet:
                    refs.add((sheet, int(f["TexLoc"]["X"]), int(f["TexLoc"]["Y"])))

    def _walk_cell(cell: Optional[dict]) -> None:
        if not isinstance(cell, dict):
            return
        _walk_frames(cell.get("Frames"))
        for sub in cell.get("Layers") or []:
            if isinstance(sub, dict):
                _walk_frames(sub.get("Frames"))

    for layer in obj.get("Layers") or []:
        for col in layer.get("Tiles") or []:
            for cell in col or []:
                _walk_cell(cell)

    for col in obj.get("Tiles") or []:
        for cell in col or []:
            if isinstance(cell, dict):
                tex = (cell.get("Data") or {}).get("TileTex")
                _walk_cell(tex)

    return refs


def verifier_aucun_damier_mauve(
    idx_path: Path, tile_dir: Path, map_paths: Sequence[Path]
) -> Tuple[int, List[str]]:
    """Vérifie que chaque tuile référencée pointe vers un PNG valide dans `.tile`."""
    entries = lire_tile_index(idx_path)
    idx_map: Dict[str, Dict[Tuple[int, int], int]] = {
        e.sheet: e.positions_dict() for e in entries
    }
    problems: List[str] = []
    checked_refs = 0
    checked_sheet_coords: Set[Tuple[str, int, int]] = set()

    for mp in map_paths:
        refs = extraire_references_tuiles_rsground(mp)
        if refs is None:
            continue
        for sheet, x, y in sorted(refs):
            checked_refs += 1
            if (sheet, x, y) in checked_sheet_coords:
                continue
            pos_table = idx_map.get(sheet)
            if pos_table is None:
                problems.append(
                    f"{mp.name}: planche '{sheet}' absente de Content/Tile/index.idx (damier A)"
                )
                continue
            off = pos_table.get((x, y))
            if off is None or off <= 0:
                problems.append(
                    f"{mp.name}: {sheet} TexLoc ({x},{y}) absent ou offset={off} dans index.idx (damier B)"
                )
                continue
            tp = tile_dir / f"{sheet}.tile"
            if not tp.exists():
                problems.append(f"{mp.name}: fichier Content/Tile/{sheet}.tile introuvable")
                continue
            size = tp.stat().st_size
            if off + 16 > size:
                problems.append(
                    f"{mp.name}: {sheet} ({x},{y}) offset {off} hors fichier ({size} octets)"
                )
                continue
            with tp.open("rb") as fh:
                fh.seek(off)
                png_len = struct.unpack("<q", fh.read(8))[0]
                sig = fh.read(8)
            if png_len <= 0 or off + 8 + png_len > size:
                problems.append(
                    f"{mp.name}: {sheet} ({x},{y}) longueur PNG invalide ({png_len})"
                )
                continue
            if sig != PNG_SIG:
                problems.append(
                    f"{mp.name}: {sheet} ({x},{y}) signature PNG invalide à l'offset {off}"
                )
                continue
            checked_sheet_coords.add((sheet, x, y))

    return checked_refs, problems


# ============================================================================
# Intégration Halcyon / town02 : Mod.xml, AssetName, Lua, master_zone & index.idx
# ============================================================================

def mettre_a_jour_mod_xml_halcyon(target_root: Path, nom_mod: str = DEFAULT_MOD_NAME) -> None:
    """Met à jour `<Name>` dans `Mod.xml` tout en préservant `<Namespace>halcyon</Namespace>`."""
    mod_xml = target_root / "Mod.xml"
    if not mod_xml.is_file():
        mod_xml.write_text(
            f"<Header>\n"
            f"  <Name>{nom_mod}</Name>\n"
            f"  <Author>Minori</Author>\n"
            f"  <Description>{nom_mod} — Mod unifié basé sur town02 / Halcyon.</Description>\n"
            f"  <Namespace>halcyon</Namespace>\n"
            f"  <UUID>CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF</UUID>\n"
            f"  <Version>0.6.0</Version>\n"
            f"  <GameVersion>0.8.12</GameVersion>\n"
            f"  <ModType>Quest</ModType>\n"
            f"</Header>\n",
            encoding="utf-8",
        )
        return

    txt = mod_xml.read_text(encoding="utf-8")
    if "<Name>" in txt:
        txt = re.sub(r"<Name>.*?</Name>", f"<Name>{nom_mod}</Name>", txt, count=1, flags=re.DOTALL)
    if "<Description>" in txt:
        txt = re.sub(
            r"<Description>.*?</Description>",
            f"<Description>{nom_mod} — Mod PMDO 0.8.12 unifié basé sur town02 / Halcyon incluant projet-creation-pmdo et Guilde Treehouse PMD.</Description>",
            txt,
            count=1,
            flags=re.DOTALL,
        )
    mod_xml.write_text(txt, encoding="utf-8")


def synchroniser_asset_name_rsground(rsground_path: Path, expected_ground_id: str) -> None:
    """Garantit que `Object.AssetName` correspond exactement au nom du fichier `<id>.rsground`."""
    with rsground_path.open("rb") as fh:
        if fh.read(64).startswith(LFS_POINTER_PREFIX):
            return
    raw_text = rsground_path.read_text(encoding="utf-8-sig")
    doc = json.loads(raw_text)
    obj = doc.get("Object")
    if isinstance(obj, dict) and obj.get("AssetName") != expected_ground_id:
        obj["AssetName"] = expected_ground_id
        out_bytes = ("\ufeff" + json.dumps(doc, ensure_ascii=False, separators=(",", ":"))).encode(
            "utf-8"
        )
        rsground_path.write_bytes(out_bytes)
    elif not rsground_path.read_bytes().startswith(b"\xef\xbb\xbf"):
        # Normalise le BOM UTF-8 comme Halcyon / town02
        rsground_path.write_bytes(b"\xef\xbb\xbf" + raw_text.encode("utf-8"))


def generer_stub_lua_halcyon(ground_id: str) -> str:
    """Génère un script `Data/Script/halcyon/ground/<ground_id>/init.lua` conforme PMDO 0.8.12."""
    var = ground_id if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", ground_id) else "ground_pkg"
    return (
        f"-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour {ground_id}\n"
        f"require 'origin.common'\n\n"
        f"local {var} = {{}}\n\n"
        f"function {var}.Init(map)\n"
        f"  DEBUG.EnableDbgCoro()\n"
        f"  COMMON.RespawnAllies()\n"
        f"end\n\n"
        f"function {var}.Enter(map)\n"
        f"  GAME:FadeIn(20)\n"
        f"end\n\n"
        f"function {var}.Exit(map) end\n"
        f"function {var}.Update(map) end\n"
        f"function {var}.GameSave(map) end\n\n"
        f"function {var}.GameLoad(map)\n"
        f"  GAME:FadeIn(20)\n"
        f"end\n\n"
        f"return {var}\n"
    )


def enregistrer_grounds_dans_master_zone_halcyon(
    target_root: Path, new_ground_ids: Sequence[str]
) -> Tuple[int, int]:
    """Ajoute chaque nouveau `<ground_id>` dans `Data/Zone/master_zone.json` et `Data/Zone/index.idx`.

    Les indices existants de `town02` (`0..390`) sont intégralement préservés dans leur ordre exact.
    Retourne `(nb_avant, nb_apres)` dans `master_zone`.
    """
    mz_path = target_root / "Data" / "Zone" / "master_zone.json"
    zidx_path = target_root / "Data" / "Zone" / "index.idx"
    before_count = 0
    after_count = 0

    if mz_path.is_file():
        with mz_path.open("rb") as fh:
            is_lfs = fh.read(64).startswith(LFS_POINTER_PREFIX)
        if not is_lfs:
            mz_doc = json.loads(mz_path.read_text(encoding="utf-8-sig"))
            gmaps: List[str] = list(mz_doc.get("Object", {}).get("GroundMaps", []))
            before_count = len(gmaps)
            existing_set = set(gmaps)
            for gid in sorted(set(new_ground_ids)):
                if gid not in existing_set:
                    gmaps.append(gid)
                    existing_set.add(gid)
            mz_doc["Object"]["GroundMaps"] = gmaps
            after_count = len(gmaps)
            mz_path.write_bytes(
                ("\ufeff" + json.dumps(mz_doc, indent=2, ensure_ascii=False)).encode("utf-8")
            )

    if zidx_path.is_file():
        with zidx_path.open("rb") as fh:
            is_lfs_idx = fh.read(64).startswith(LFS_POINTER_PREFIX)
        if not is_lfs_idx:
            zidx_doc = json.loads(zidx_path.read_text(encoding="utf-8-sig"))
            mz_entry = zidx_doc.get("Object", {}).get("master_zone")
            if isinstance(mz_entry, dict) and isinstance(mz_entry.get("Grounds"), list):
                grounds_list: List[str] = list(mz_entry["Grounds"])
                if before_count == 0:
                    before_count = len(grounds_list)
                existing_idx_set = set(grounds_list)
                for gid in sorted(set(new_ground_ids)):
                    if gid not in existing_idx_set:
                        grounds_list.append(gid)
                        existing_idx_set.add(gid)
                mz_entry["Grounds"] = grounds_list
                if after_count == 0:
                    after_count = len(grounds_list)
                zidx_path.write_bytes(
                    ("\ufeff" + json.dumps(zidx_doc, indent=1, ensure_ascii=False)).encode("utf-8")
                )

    return before_count, after_count


# ============================================================================
# Collecte multi-dépôts et multi-branches + fusion Halcyon dans `town02`
# ============================================================================

@dataclass
class BranchSnapshot:
    repo_label: str
    branch_name: str
    commit_sha: str
    commit_timestamp: int
    repo_git_dir: Path


@dataclass
class AssemblyReport:
    mod_name: str = DEFAULT_MOD_NAME
    workspace_rel_dir: str = "Halcyon Mods/sources_projet_pmd"
    base_town02_grounds: int = 0
    base_town02_tiles: int = 0
    branches_scanned: int = 0
    source_lots_merged: int = 0
    branch_variants_saved: int = 0
    renders_lots_merged: int = 0
    html_previews_merged: int = 0
    guilde_dirs_merged: List[str] = field(default_factory=list)
    builds_executed: int = 0
    builds_failed: List[str] = field(default_factory=list)
    custom_tiles_installed: int = 0
    custom_grounds_installed: int = 0
    custom_grounds_aliased: List[str] = field(default_factory=list)
    custom_scripts_installed: int = 0
    custom_scripts_autogenerated: int = 0
    master_zone_grounds_before: int = 0
    master_zone_grounds_after: int = 0
    tile_index_before: int = 0
    tile_index_after: int = 0
    verified_tile_refs: int = 0
    destiny_title_installed: bool = False


def _run(
    cmd: Sequence[str],
    cwd: Optional[Path] = None,
    check: bool = True,
    timeout: Optional[int] = None,
) -> subprocess.CompletedProcess:
    return subprocess.run(
        list(cmd),
        cwd=str(cwd) if cwd else None,
        check=check,
        text=True,
        capture_output=True,
        timeout=timeout,
    )


def _sanitize_slug(text: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", text).strip("_")


def lister_branches_git_local(
    repo_git_dir: Path,
    repo_label: str,
    only_branch: Optional[str] = None,
) -> List[BranchSnapshot]:
    """Liste les branches d'un dépôt Git local ou miroir bare."""
    res = _run(
        [
            "git",
            "for-each-ref",
            "--format=%(refname:short)\t%(objectname)\t%(committerdate:unix)",
            "refs/heads",
            "refs/remotes/origin",
        ],
        cwd=repo_git_dir,
    )
    seen: Dict[str, BranchSnapshot] = {}
    for line in res.stdout.splitlines():
        parts = line.strip().split("\t")
        if len(parts) != 3:
            continue
        ref, sha, ts_str = parts
        if ref == "origin/HEAD" or ref.endswith("/HEAD"):
            continue
        bname = ref[len("origin/") :] if ref.startswith("origin/") else ref
        if only_branch and bname != only_branch:
            continue
        ts = int(ts_str) if ts_str.isdigit() else 0
        prev = seen.get(bname)
        if prev is None or ts >= prev.commit_timestamp:
            seen[bname] = BranchSnapshot(
                repo_label=repo_label,
                branch_name=bname,
                commit_sha=sha,
                commit_timestamp=ts,
                repo_git_dir=repo_git_dir,
            )
    return list(seen.values())


def _priorite_branche(
    snap: BranchSnapshot, preferred_branch: str = DEFAULT_PREFERRED_BRANCH
) -> Tuple[int, int]:
    is_pref = int(
        snap.branch_name == preferred_branch
        and snap.repo_label.endswith("projet-creation-pmdo")
    )
    return (is_pref, snap.commit_timestamp)


def _lister_entrees_arbre_git(
    repo_git_dir: Path, commit_sha: str, subpath: str = ""
) -> List[Tuple[str, str, str]]:
    spec = f"{commit_sha}:{subpath}" if subpath else commit_sha
    res = _run(["git", "ls-tree", spec], cwd=repo_git_dir, check=False)
    if res.returncode != 0:
        return []
    out: List[Tuple[str, str, str]] = []
    for line in res.stdout.splitlines():
        if "\t" not in line:
            continue
        meta, name = line.split("\t", 1)
        pieces = meta.split()
        if len(pieces) >= 3:
            out.append((pieces[1], pieces[2], name))
    return out


def extraire_sous_arbre_git(
    repo_git_dir: Path, commit_sha: str, tree_sha: str, dest_dir: Path
) -> None:
    dest_dir.mkdir(parents=True, exist_ok=True)
    p_arch = subprocess.Popen(
        ["git", "archive", "--format=tar", tree_sha],
        cwd=str(repo_git_dir),
        stdout=subprocess.PIPE,
    )
    p_tar = subprocess.Popen(
        ["tar", "-xf", "-", "-C", str(dest_dir)],
        stdin=p_arch.stdout,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if p_arch.stdout:
        p_arch.stdout.close()
    _, err = p_tar.communicate()
    rc_arch = p_arch.wait()
    if rc_arch != 0 or p_tar.returncode != 0:
        raise RuntimeError(
            f"Échec extraction git archive ({tree_sha} depuis {commit_sha}): "
            f"{err.decode('utf-8', errors='replace')}"
        )


def extraire_blob_git(repo_git_dir: Path, blob_sha: str, dest_file: Path) -> None:
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    res = subprocess.run(
        ["git", "cat-file", "blob", blob_sha],
        cwd=str(repo_git_dir),
        check=True,
        capture_output=True,
    )
    dest_file.write_bytes(res.stdout)


def copier_fichier_dereference(src: Path, dst: Path) -> bool:
    try:
        resolved = src.resolve(strict=True)
    except OSError:
        return False
    if not resolved.is_file():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(resolved, dst, follow_symlinks=True)
    return True


def _extraire_scripts_ground_depuis_arborescence(
    maps_ws: Path,
) -> Dict[str, Tuple[Path, Optional[str]]]:
    """Récolte tous les dossiers `ground/<ground_id>` dans `maps_ws/**/Data/Script/**`.

    Retourne `{ground_id: (chemin_dossier_source, ancien_namespace_eventuel)}`.
    """
    collected: Dict[str, Tuple[Path, Optional[str]]] = {}
    for sp_root in sorted(maps_ws.rglob("Data/Script")):
        try:
            real_sp_root = sp_root.resolve(strict=True)
        except OSError:
            continue
        if not real_sp_root.is_dir():
            continue
        for child in sorted(real_sp_root.iterdir()):
            if not child.is_dir():
                continue
            if child.name == "ground":
                # Style Halcyon 0.7 : Data/Script/ground/<gid>/
                for gdir in sorted(child.iterdir()):
                    if gdir.is_dir() and gdir.name not in collected:
                        collected[gdir.name] = (gdir, None)
            else:
                # Style PMDO 0.8.12 namespacé : Data/Script/<ns>/ground/<gid>/
                ns = child.name
                g_parent = child / "ground"
                if g_parent.is_dir():
                    for gdir in sorted(g_parent.iterdir()):
                        if gdir.is_dir():
                            # Priorité explicite aux scripts déjà écrits pour `halcyon`
                            if gdir.name not in collected or ns == "halcyon":
                                collected[gdir.name] = (gdir, None if ns == "halcyon" else ns)
    return collected


def installer_ecran_titre_pmd_destiny(target_root: Path, maps_ws: Path) -> bool:
    """Installe l'écran-titre multicalque animé de **Pokémon Mystery Dungeon : Destiny** dans `target_root` :
      - `Content/BG/Title_Screen_Background.dir` (`320×240`, `24` poses Crépuscule ──▶ Nuit Étoilée sans logo)
      - `Content/UI/Title.png` (`320×240` RGBA style *Super Mystery Dungeon*) & `Content/UI/Enter.png` (`74×11`)
      - `Content/ContentParams.xml` (`<TitleBG>Title_Screen_Background</TitleBG>` si absent)
      - `Data/Script/halcyon/services/destiny_title_anim/init.lua` + `require 'halcyon.services.destiny_title_anim'`
        injecté proprement dans `Data/Script/halcyon/main.lua`."""
    fb = maps_ws / "renders" / "pmd_destiny_fangame_v1" / "fangame_base"
    build_py = maps_ws / "source" / "pmd_destiny_fangame_v1" / "build.py"
    if not (fb / "Content" / "BG" / "Title_Screen_Background.dir").is_file() and build_py.is_file():
        subprocess.run(
            [sys.executable, str(build_py)],
            cwd=str(maps_ws),
            text=True,
            capture_output=True,
            timeout=300,
            check=False,
        )
    if not (fb / "Content" / "BG" / "Title_Screen_Background.dir").is_file():
        return False

    for rel in (
        "Content/BG/Title_Screen_Background.dir",
        "Content/BG/Title_Screen_Background_Jour.dir",
        "Content/BG/Title_Screen_Background_Nuit.dir",
        "Content/Obj/Destiny_Logo_Anime_Opening.dir",
        "Content/UI/Title.png",
        "Content/UI/Enter.png",
        "Data/Script/halcyon/services/destiny_title_anim/init.lua",
    ):
        src = fb / rel
        if src.is_file():
            dst = target_root / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)

    cparams_dst = target_root / "Content" / "ContentParams.xml"
    cparams_src = fb / "Content" / "ContentParams.xml"
    if not cparams_dst.is_file() and cparams_src.is_file():
        cparams_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(cparams_src, cparams_dst)

    main_lua = target_root / "Data" / "Script" / "halcyon" / "main.lua"
    req_line = "require 'halcyon.services.destiny_title_anim'"
    main_lua.parent.mkdir(parents=True, exist_ok=True)
    if main_lua.is_file():
        txt = main_lua.read_text(encoding="utf-8", errors="replace")
        if req_line not in txt:
            anchor = "require 'halcyon.services.menu_tools'"
            if anchor in txt:
                txt = txt.replace(anchor, anchor + "\n" + req_line, 1)
            else:
                txt = txt.rstrip("\n") + "\n" + req_line + "\n"
            main_lua.write_text(txt, encoding="utf-8")
    else:
        main_lua.write_text(
            "function PrintInfo(msg)\n  print(tostring(msg))\nend\n" + req_line + "\n",
            encoding="utf-8",
        )
    return True


def fusionner_branches_dans_town02(
    target_root: Path,
    source_repos: Sequence[Tuple[str, Path, Optional[str]]] | Sequence[Tuple[str, Path]],
    garder_variantes: bool = True,
    compiler_builds: bool = False,
    remplacer_grounds_town02: bool = False,
    ecraser_tiles_town02: bool = False,
    preferred_branch: str = DEFAULT_PREFERRED_BRANCH,
    nom_mod: str = DEFAULT_MOD_NAME,
    dossier_sources_rel: str = "Halcyon Mods/sources_projet_pmd",
    installer_ecran_titre_destiny: Optional[bool] = None,
) -> AssemblyReport:
    """Fusionne les dépôts/branches sources dans une racine `town02` selon le standard Halcyon."""
    report = AssemblyReport(mod_name=nom_mod, workspace_rel_dir=dossier_sources_rel)
    mettre_a_jour_mod_xml_halcyon(target_root, nom_mod=nom_mod)

    tile_dir = target_root / "Content" / "Tile"
    ground_dir = target_root / "Data" / "Ground"
    halcyon_script_ground_dir = target_root / "Data" / "Script" / "halcyon" / "ground"
    idx_path = tile_dir / "index.idx"

    tile_dir.mkdir(parents=True, exist_ok=True)
    ground_dir.mkdir(parents=True, exist_ok=True)
    halcyon_script_ground_dir.mkdir(parents=True, exist_ok=True)

    existing_town02_grounds = {p.name.lower() for p in ground_dir.glob("*.rsground")}
    existing_town02_tiles = {p.name.lower() for p in tile_dir.glob("*.tile")}
    report.base_town02_grounds = len(existing_town02_grounds)
    report.base_town02_tiles = len(existing_town02_tiles)

    normalized_repos: List[Tuple[str, Path, Optional[str]]] = []
    for item in source_repos:
        if len(item) == 2:
            lbl, gdir = item  # type: ignore[misc]
            normalized_repos.append((lbl, gdir, None))
        else:
            lbl, gdir, bfilter = item  # type: ignore[misc]
            normalized_repos.append((lbl, gdir, bfilter))

    all_snapshots: List[BranchSnapshot] = []
    for label, git_dir, only_br in normalized_repos:
        snaps = lister_branches_git_local(git_dir, label, only_branch=only_br)
        all_snapshots.extend(snaps)
    all_snapshots.sort(
        key=lambda s: _priorite_branche(s, preferred_branch=preferred_branch),
        reverse=True,
    )
    report.branches_scanned = len(all_snapshots)

    maps_ws = target_root / dossier_sources_rel
    ws_source = maps_ws / "source"
    ws_variants = maps_ws / "variantes_branches"
    ws_renders = maps_ws / "renders"
    ws_guilde = maps_ws / "guilde_treehouse"
    ws_html = maps_ws / "apercus_html"
    for d in (ws_source, ws_renders, ws_guilde, ws_html):
        d.mkdir(parents=True, exist_ok=True)

    seen_source_canonical: Dict[str, str] = {}
    seen_source_trees: Set[Tuple[str, str]] = set()
    seen_source_files: Set[str] = set()
    seen_renders_canonical: Set[str] = set()
    seen_html: Set[str] = set()
    seen_guilde_dirs: Set[str] = set()
    seen_docs: Set[str] = set()
    seen_root_rsgrounds: Set[str] = set()

    for snap in all_snapshots:
        root_entries = _lister_entrees_arbre_git(snap.repo_git_dir, snap.commit_sha)
        for etype, esha, ename in root_entries:
            if etype == "blob" and ename in ROOT_DOC_FILES and ename not in seen_docs:
                extraire_blob_git(snap.repo_git_dir, esha, maps_ws / ename)
                seen_docs.add(ename)

            elif (
                etype == "blob"
                and (ename == "index.html" or (ename.startswith("apercu_") and ename.endswith(".html")))
                and ename not in seen_html
            ):
                extraire_blob_git(snap.repo_git_dir, esha, ws_html / ename)
                seen_html.add(ename)
                report.html_previews_merged += 1

            elif etype == "blob" and ename.endswith(".rsground") and ename not in seen_root_rsgrounds:
                extraire_blob_git(snap.repo_git_dir, esha, maps_ws / ename)
                seen_root_rsgrounds.add(ename)

            elif etype == "tree" and ename in GUILDE_ROOT_DIRS and ename not in seen_guilde_dirs:
                extraire_sous_arbre_git(
                    snap.repo_git_dir, snap.commit_sha, esha, ws_guilde / ename
                )
                link_at_ws = maps_ws / ename
                if not link_at_ws.exists() and not link_at_ws.is_symlink():
                    link_at_ws.symlink_to(Path("guilde_treehouse") / ename)
                seen_guilde_dirs.add(ename)
                report.guilde_dirs_merged.append(ename)

            elif etype == "tree" and ename == "source":
                for stype, ssha, sname in _lister_entrees_arbre_git(
                    snap.repo_git_dir, snap.commit_sha, "source"
                ):
                    if stype == "blob" and sname not in seen_source_files:
                        extraire_blob_git(snap.repo_git_dir, ssha, ws_source / sname)
                        seen_source_files.add(sname)
                    elif stype == "tree":
                        if sname not in seen_source_canonical:
                            extraire_sous_arbre_git(
                                snap.repo_git_dir, snap.commit_sha, ssha, ws_source / sname
                            )
                            seen_source_canonical[sname] = ssha
                            seen_source_trees.add((sname, ssha))
                            report.source_lots_merged += 1
                        elif garder_variantes and (sname, ssha) not in seen_source_trees:
                            var_slug = _sanitize_slug(
                                f"{sname}__{snap.repo_label.split('/')[-1]}__{snap.branch_name}"
                            )
                            extraire_sous_arbre_git(
                                snap.repo_git_dir, snap.commit_sha, ssha, ws_variants / var_slug
                            )
                            seen_source_trees.add((sname, ssha))
                            report.branch_variants_saved += 1

            elif etype == "tree" and ename == "renders":
                for rtype, rsha, rname in _lister_entrees_arbre_git(
                    snap.repo_git_dir, snap.commit_sha, "renders"
                ):
                    if rtype == "tree" and rname not in seen_renders_canonical:
                        extraire_sous_arbre_git(
                            snap.repo_git_dir, snap.commit_sha, rsha, ws_renders / rname
                        )
                        seen_renders_canonical.add(rname)
                        report.renders_lots_merged += 1

    # Compilation des générateurs `build.py` (Studio 33 maps + Guilde Treehouse Halcyon 84 maps + entrées/fins)
    if compiler_builds:
        for build_py in sorted(ws_source.glob("*/build.py")):
            res = subprocess.run(
                [sys.executable, str(build_py)],
                cwd=str(maps_ws),
                text=True,
                capture_output=True,
                timeout=300,
                check=False,
            )
            if res.returncode == 0:
                report.builds_executed += 1
            else:
                report.builds_failed.append(f"{build_py.parent.name}: rc={res.returncode}")

        # Génération complémentaire des grounds autonomes compat_town02 si présent
        compat_script = ws_source / "compat_town02" / "build_all_town02_grounds.py"
        if compat_script.is_file():
            res_c = subprocess.run(
                [sys.executable, str(compat_script)],
                cwd=str(maps_ws),
                text=True,
                capture_output=True,
                timeout=300,
                check=False,
            )
            if res_c.returncode == 0:
                report.builds_executed += 1

    use_destiny_title = (
        installer_ecran_titre_destiny
        if installer_ecran_titre_destiny is not None
        else ("destiny" in nom_mod.lower())
    )
    if use_destiny_title:
        report.destiny_title_installed = installer_ecran_titre_pmd_destiny(target_root, maps_ws)

    # Récolte des planches `.tile` et des cartes `.rsground` (en ignorant les références de test)
    harvested_tiles: Dict[str, Path] = {}
    harvested_grounds: Dict[str, Path] = {}

    for tp in sorted(maps_ws.rglob("*.tile")):
        if "references" in tp.parts:
            continue
        try:
            real_tp = tp.resolve(strict=True)
        except OSError:
            continue
        if real_tp.is_file() and tp.name not in harvested_tiles:
            harvested_tiles[tp.name] = real_tp

    for gp in sorted(maps_ws.rglob("*.rsground")):
        if "references" in gp.parts or gp.parent == maps_ws:
            continue
        try:
            real_gp = gp.resolve(strict=True)
        except OSError:
            continue
        if real_gp.is_file() and gp.name not in harvested_grounds:
            harvested_grounds[gp.name] = real_gp

    # 1) Placement Halcyon des `.tile` dans `Content/Tile/` + mise à jour de `Content/Tile/index.idx`
    tiles_to_index: List[Path] = []
    for tname, tsrc in sorted(harvested_tiles.items()):
        tdst = tile_dir / tname
        if tname.lower() in existing_town02_tiles and not ecraser_tiles_town02:
            continue
        if copier_fichier_dereference(tsrc, tdst):
            tiles_to_index.append(tdst)
            report.custom_tiles_installed += 1

    if tiles_to_index or not idx_path.exists():
        before, after, _ = injecter_planches_dans_index(idx_path, tiles_to_index)
        report.tile_index_before = before
        report.tile_index_after = after
    elif idx_path.exists():
        n_idx = len(lire_tile_index(idx_path))
        report.tile_index_before = n_idx
        report.tile_index_after = n_idx

    # 2) Placement Halcyon des `.rsground` dans `Data/Ground/` + synchronisation `Object.AssetName`
    installed_ground_paths: List[Path] = []
    installed_ground_ids: List[str] = []
    alias_origin_map: Dict[str, str] = {}  # new_ground_id -> original_ground_id

    for gname, gsrc in sorted(harvested_grounds.items()):
        orig_stem = Path(gname).stem
        if gname.lower() in existing_town02_grounds and not remplacer_grounds_town02:
            final_id = f"{orig_stem}__custom_pmdo"
            gdst = ground_dir / f"{final_id}.rsground"
            report.custom_grounds_aliased.append(f"{gname} -> {final_id}.rsground")
            alias_origin_map[final_id] = orig_stem
        else:
            final_id = orig_stem
            gdst = ground_dir / gname

        if copier_fichier_dereference(gsrc, gdst):
            synchroniser_asset_name_rsground(gdst, final_id)
            installed_ground_paths.append(gdst)
            installed_ground_ids.append(final_id)
            report.custom_grounds_installed += 1

    # 3) Placement Halcyon des scripts Lua sous `Data/Script/halcyon/ground/<ground_id>/init.lua`
    harvested_scripts = _extraire_scripts_ground_depuis_arborescence(maps_ws)
    for gid in installed_ground_ids:
        sdst_dir = halcyon_script_ground_dir / gid
        if sdst_dir.exists():
            continue
        lookup_key = gid if gid in harvested_scripts else alias_origin_map.get(gid, "")
        if lookup_key and lookup_key in harvested_scripts:
            ssrc_dir, old_ns = harvested_scripts[lookup_key]
            shutil.copytree(ssrc_dir, sdst_dir, symlinks=False)
            # Adapte les `require '<old_ns>.ground.` vers `require 'halcyon.ground.`
            for lua_f in sdst_dir.rglob("*.lua"):
                ltxt = lua_f.read_text(encoding="utf-8", errors="replace")
                if old_ns:
                    ltxt = ltxt.replace(f"require '{old_ns}.ground.", "require 'halcyon.ground.")
                    ltxt = ltxt.replace(f'require "{old_ns}.ground.', 'require "halcyon.ground.')
                lua_f.write_text(ltxt, encoding="utf-8")
            report.custom_scripts_installed += 1
        else:
            sdst_dir.mkdir(parents=True, exist_ok=True)
            (sdst_dir / "init.lua").write_text(generer_stub_lua_halcyon(gid), encoding="utf-8")
            report.custom_scripts_autogenerated += 1

    # Copie également tout script `halcyon/ground/<gid>` additionnel non encore présent
    for gid, (ssrc_dir, old_ns) in sorted(harvested_scripts.items()):
        sdst_dir = halcyon_script_ground_dir / gid
        if sdst_dir.exists():
            continue
        shutil.copytree(ssrc_dir, sdst_dir, symlinks=False)
        for lua_f in sdst_dir.rglob("*.lua"):
            ltxt = lua_f.read_text(encoding="utf-8", errors="replace")
            if old_ns:
                ltxt = ltxt.replace(f"require '{old_ns}.ground.", "require 'halcyon.ground.")
                ltxt = ltxt.replace(f'require "{old_ns}.ground.', 'require "halcyon.ground.')
            lua_f.write_text(ltxt, encoding="utf-8")
        report.custom_scripts_installed += 1

    # 4) Enregistrement Halcyon dans `Data/Zone/master_zone.json` & `Data/Zone/index.idx`
    mz_before, mz_after = enregistrer_grounds_dans_master_zone_halcyon(
        target_root, installed_ground_ids
    )
    report.master_zone_grounds_before = mz_before
    report.master_zone_grounds_after = mz_after

    # 5) Contrôle anti-damier mauve sur tous les `.rsground` installés dont les `.tile` sont matérialisés
    verifiable_grounds: List[Path] = []
    idx_entries_names = (
        {e.sheet for e in lire_tile_index(idx_path)} if idx_path.exists() else set()
    )
    for gp in installed_ground_paths:
        refs = extraire_references_tuiles_rsground(gp)
        if refs is None:
            continue
        all_materialized = True
        for sheet, _, _ in refs:
            tp = tile_dir / f"{sheet}.tile"
            if not tp.exists():
                if report.base_town02_tiles == 0:
                    all_materialized = False
                    break
            else:
                with tp.open("rb") as tfh:
                    if tfh.read(64).startswith(LFS_POINTER_PREFIX):
                        all_materialized = False
                        break
        if all_materialized and idx_entries_names:
            verifiable_grounds.append(gp)

    if verifiable_grounds and idx_path.exists():
        checked_refs, problems = verifier_aucun_damier_mauve(
            idx_path, tile_dir, verifiable_grounds
        )
        report.verified_tile_refs = checked_refs
        if problems:
            preview = "\n  - ".join(problems[:20])
            raise RuntimeError(
                f"Échec garde anti-damier mauve ({len(problems)} anomalies) :\n  - {preview}"
            )

    proteger_gros_fichiers_git_lfs(target_root, seuil_octets=90 * 1024 * 1024)
    ecrire_catalogue_racine(target_root, report, normalized_repos)
    return report


def proteger_gros_fichiers_git_lfs(root: Path, seuil_octets: int = 90 * 1024 * 1024) -> List[str]:
    gitattr = root / ".gitattributes"
    existing_text = gitattr.read_text(encoding="utf-8") if gitattr.exists() else ""
    added_rules: List[str] = []

    for p in root.rglob("*"):
        if ".git" in p.parts or not p.is_file():
            continue
        if p.stat().st_size > seuil_octets:
            rel = p.relative_to(root).as_posix()
            rule = f"{rel} filter=lfs diff=lfs merge=lfs -text"
            if rel not in existing_text:
                existing_text = existing_text.rstrip("\n") + "\n" + rule + "\n"
                added_rules.append(rel)

    if added_rules:
        gitattr.write_text(existing_text, encoding="utf-8")
    return added_rules


def ecrire_catalogue_racine(
    target_root: Path,
    report: AssemblyReport,
    source_repos: Sequence[Tuple[str, Path, Optional[str]]],
) -> Path:
    inv = {
        "mod_name": report.mod_name,
        "namespace": "halcyon",
        "workspace_rel_dir": report.workspace_rel_dir,
        "base_town02_grounds": report.base_town02_grounds,
        "base_town02_tiles": report.base_town02_tiles,
        "branches_scanned": report.branches_scanned,
        "source_repos": [
            f"{label}@{br}" if br else label for label, _, br in source_repos
        ],
        "source_lots_merged": report.source_lots_merged,
        "branch_variants_saved": report.branch_variants_saved,
        "renders_lots_merged": report.renders_lots_merged,
        "html_previews_merged": report.html_previews_merged,
        "guilde_dirs_merged": report.guilde_dirs_merged,
        "builds_executed": report.builds_executed,
        "builds_failed": report.builds_failed,
        "custom_tiles_installed": report.custom_tiles_installed,
        "custom_grounds_installed": report.custom_grounds_installed,
        "custom_grounds_aliased": report.custom_grounds_aliased,
        "custom_scripts_installed": report.custom_scripts_installed,
        "custom_scripts_autogenerated": report.custom_scripts_autogenerated,
        "master_zone_grounds_before": report.master_zone_grounds_before,
        "master_zone_grounds_after": report.master_zone_grounds_after,
        "tile_index_before": report.tile_index_before,
        "tile_index_after": report.tile_index_after,
        "verified_tile_refs": report.verified_tile_refs,
        "destiny_title_installed": report.destiny_title_installed,
    }
    (target_root / "inventaire_unifie_final.json").write_text(
        json.dumps(inv, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    md = [
        f"# {report.mod_name} — Dépôt Unifié (`town02` / `Palikadude/Halcyon` + `projet-creation-pmdo` + `Guilde Treehouse`)",
        "",
        "Ce dépôt est structuré **exactement comme `Palikadude/Halcyon` et `meromoonmeri/town02`** (`PMDO 0.8.12.0`, `<Namespace>halcyon</Namespace>`) afin que chaque carte soit immédiatement reconnue, ouvrable et jouable au même endroit :",
        "",
        "## Placement natif façon `Palikadude/Halcyon`",
        "",
        f"- **`Mod.xml`** : `<Name>{report.mod_name}</Name>`, `<Namespace>halcyon</Namespace>`, `<GameVersion>0.8.12</GameVersion>`.",
        f"- **`Content/Tile/*.tile` & `Content/Tile/index.idx`** : `{report.custom_tiles_installed}` nouvelles banques `.tile` ajoutées et indexées (`{report.tile_index_before}` -> `{report.tile_index_after}` planches).",
        f"- **`Data/Ground/*.rsground`** : `{report.base_town02_grounds}` cartes natives `town02` + `{report.custom_grounds_installed}` nouvelles cartes installées avec `Object.AssetName` synchronisé.",
        f"- **`Data/Script/halcyon/ground/<id>/init.lua`** : `{report.custom_scripts_installed}` scripts Ground importés/relocalisés sous `halcyon` + `{report.custom_scripts_autogenerated}` scripts d'entrée Halcyon auto-générés.",
        f"- **`Data/Zone/master_zone.json` & `Data/Zone/index.idx`** : `{report.master_zone_grounds_before}` -> `{report.master_zone_grounds_after}` GroundMaps déclarées dans `master_zone` (indices `town02` d'origine intégralement préservés).",
        f"- **`{report.workspace_rel_dir}/`** : sources Python (`{report.source_lots_merged}` lots), kit Guilde Treehouse (`12` salles modulaires × `6` ambiances) et `{report.html_previews_merged}` aperçus HTML.",
        f"- **Contrôle anti-damier mauve** : `{report.verified_tile_refs}` références de tuiles vérifiées (`0` erreur).",
        "",
    ]
    cat_path = target_root / "CATALOGUE_COMPLET_UNIFIE.md"
    cat_path.write_text("\n".join(md), encoding="utf-8")
    return cat_path


# ============================================================================
# Interface ligne de commande (clonage GitHub + assemblage + création/push)
# ============================================================================

def cloner_sources_github(
    work_cache: Path,
    repos_spec: Sequence[Tuple[str, Optional[str], bool]] = PROJET_PMD_TARGET_REPOS,
) -> List[Tuple[str, Path, Optional[str]]]:
    work_cache.mkdir(parents=True, exist_ok=True)
    cloned: List[Tuple[str, Path, Optional[str]]] = []
    for slug, only_branch, required in repos_spec:
        dest = work_cache / (_sanitize_slug(slug) + ".git")
        url = f"https://github.com/{slug}.git"
        if dest.exists():
            print(f"[fetch] Mise à jour du miroir {slug}...")
            _run(["git", "fetch", "--all", "--prune"], cwd=dest, check=required)
            cloned.append((slug, dest, only_branch))
            continue
        clone_cmd = ["git", "clone", "--bare", "--filter=blob:none"]
        if only_branch:
            clone_cmd.extend(["--branch", only_branch, "--single-branch"])
        clone_cmd.extend([url, str(dest)])
        print(
            f"[clone] Récupération de {slug}"
            + (f" ({only_branch})" if only_branch else " (toutes branches)")
            + "..."
        )
        res = _run(clone_cmd, check=False)
        if res.returncode == 0:
            cloned.append((slug, dest, only_branch))
        elif required:
            raise RuntimeError(
                f"Impossible de cloner le dépôt requis {slug} :\n{res.stderr}"
            )
        else:
            print(
                f"[info] Dépôt privé/optionnel {slug} non accessible directement "
                f"(ses 12 salles modulaires × 6 ambiances Halcyon sont déjà incluses via guilde_treehouse_halcyon_v1)."
            )
    return cloned


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        description="Construit le dépôt unique 'PROJET PMD' basé sur town02 / Palikadude/Halcyon."
    )
    parser.add_argument(
        "--sortie",
        required=True,
        help="Dossier cible du dépôt unifié (ex: ~/PROJET-PMD)",
    )
    parser.add_argument(
        "--nom-mod",
        default=DEFAULT_MOD_NAME,
        help="Nom affiché dans Mod.xml (défaut: 'PROJET PMD')",
    )
    parser.add_argument(
        "--toutes-branches",
        action="store_true",
        help="Fusionner aussi les 35 autres branches historiques (par défaut: town02 + projet-creation-pmdo@arena/637b0828-projet-creation-pmdo + guilde-treehouse-pmd)",
    )
    parser.add_argument(
        "--cache-clones",
        default="",
        help="Dossier temporaire pour les miroirs Git (défaut: <sortie>_git_cache)",
    )
    parser.add_argument(
        "--town02-local",
        default="",
        help="Utiliser une copie locale existante de town02 au lieu de cloner GitHub",
    )
    parser.add_argument(
        "--source-local",
        action="append",
        default=[],
        help="Dépôt source local sous la forme label=/chemin/vers/repo (répétable)",
    )
    parser.add_argument(
        "--compiler-builds",
        action="store_true",
        help="Exécuter les scripts source/<lot>/build.py pour matérialiser tous les .tile/.rsground",
    )
    parser.add_argument(
        "--sans-variantes",
        action="store_true",
        help="Ne garder que la version canonique de chaque dossier source/<lot>",
    )
    parser.add_argument(
        "--remplacer-grounds-town02",
        action="store_true",
        help="Remplacer les .rsground natifs de town02 en cas d'homonymie",
    )
    parser.add_argument(
        "--installer-ecran-titre-destiny",
        action="store_true",
        help="Installer l'écran-titre animé multicalque (Title_Screen_Background.dir 24p + Title.png + destiny_title_anim) de Pokémon Mystery Dungeon : Destiny",
    )
    parser.add_argument(
        "--creer-et-pousser",
        default="",
        help="Créer et pousser vers ce dépôt GitHub via `gh repo create` (ex: meromoonmeri/PROJET-PMD)",
    )
    parser.add_argument(
        "--visibilite",
        choices=["public", "private"],
        default="public",
        help="Visibilité du nouveau dépôt GitHub (défaut: public)",
    )

    args = parser.parse_args(argv)
    target_root = Path(args.sortie).expanduser().resolve()
    cache_dir = (
        Path(args.cache_clones).expanduser().resolve()
        if args.cache_clones
        else target_root.parent / f"{target_root.name}_git_cache"
    )

    if args.town02_local:
        src_t2 = Path(args.town02_local).expanduser().resolve()
        if target_root != src_t2:
            if target_root.exists():
                shutil.rmtree(target_root)
            shutil.copytree(src_t2, target_root, symlinks=True)
    else:
        _run(["git", "lfs", "install"], check=False)
        if not (target_root / ".git").exists():
            print(f"[1/4] Clonage complet de {DEFAULT_BASE_REPO} dans {target_root}...")
            target_root.parent.mkdir(parents=True, exist_ok=True)
            _run(
                [
                    "git",
                    "clone",
                    f"https://github.com/{DEFAULT_BASE_REPO}.git",
                    str(target_root),
                ]
            )
        print("[1/4] Récupération des objets Git LFS de town02...")
        _run(["git", "lfs", "pull"], cwd=target_root, check=False)

    if args.source_local:
        source_repos: List[Tuple[str, Path, Optional[str]]] = []
        for spec in args.source_local:
            if "=" in spec:
                lbl, p_str = spec.split("=", 1)
            else:
                p_str = spec
                lbl = Path(p_str).name
            source_repos.append((lbl, Path(p_str).expanduser().resolve(), None))
    else:
        spec_list = (
            ALL_BRANCHES_SOURCE_REPOS if args.toutes_branches else PROJET_PMD_TARGET_REPOS
        )
        print("[2/4] Récupération des dépôts sources pour PROJET PMD...")
        source_repos = cloner_sources_github(cache_dir, spec_list)

    print("[3/4] Placement Halcyon (Content/Tile, Data/Ground, Data/Script/halcyon/ground, Data/Zone/master_zone)...")
    report = fusionner_branches_dans_town02(
        target_root=target_root,
        source_repos=source_repos,
        garder_variantes=not args.sans_variantes,
        compiler_builds=args.compiler_builds,
        remplacer_grounds_town02=args.remplacer_grounds_town02,
        nom_mod=args.nom_mod,
        installer_ecran_titre_destiny=True if args.installer_ecran_titre_destiny else None,
    )

    print(
        f"[OK] Assemblage '{report.mod_name}' terminé (standard Halcyon / town02) :\n"
        f"  - Base town02                 : {report.base_town02_grounds} .rsground, {report.base_town02_tiles} .tile\n"
        f"  - Planches .tile ajoutées     : {report.custom_tiles_installed} (index.idx: {report.tile_index_before} -> {report.tile_index_after})\n"
        f"  - Grounds installés           : {report.custom_grounds_installed}\n"
        f"  - Scripts halcyon/ground/     : {report.custom_scripts_installed} importés + {report.custom_scripts_autogenerated} auto-générés\n"
        f"  - master_zone.json & index.idx: {report.master_zone_grounds_before} -> {report.master_zone_grounds_after} GroundMaps\n"
        f"  - Tuiles vérifiées OK         : {report.verified_tile_refs} (0 damier mauve)"
    )

    if args.creer_et_pousser:
        raw_slug = args.creer_et_pousser.strip()
        if "/" in raw_slug:
            owner_part, name_part = raw_slug.split("/", 1)
        else:
            owner_part, name_part = DEFAULT_OWNER, raw_slug
        # GitHub convertit les espaces en tirets dans l'URL du dépôt tout en gardant "PROJET PMD" dans Mod.xml
        clean_repo_name = re.sub(r"\s+", "-", name_part.strip())
        repo_slug = f"{owner_part}/{clean_repo_name}"

        print(f"[4/4] Validation Git et publication vers https://github.com/{repo_slug} ...")
        _run(["git", "lfs", "install"], cwd=target_root, check=False)
        _run(["git", "add", "-A"], cwd=target_root)
        status = _run(["git", "status", "--porcelain"], cwd=target_root).stdout.strip()
        if status:
            _run(
                [
                    "git",
                    "commit",
                    "-m",
                    f"{args.nom_mod} : intégration Halcyon complète (town02 + projet-creation-pmdo + Guilde Treehouse)",
                ],
                cwd=target_root,
            )

        chk = _run(["gh", "repo", "view", repo_slug], cwd=target_root, check=False)
        if chk.returncode != 0:
            vis_flag = f"--{args.visibilite}"
            _run(
                [
                    "gh",
                    "repo",
                    "create",
                    repo_slug,
                    vis_flag,
                    "--description",
                    f"{args.nom_mod} — Mod PMDO 0.8.12 unifié basé sur town02 / Halcyon incluant projet-creation-pmdo et Guilde Treehouse PMD",
                ],
                cwd=target_root,
            )

        remote_url = f"https://github.com/{repo_slug}.git"
        remotes = _run(["git", "remote"], cwd=target_root).stdout.splitlines()
        if "projet_pmd" in remotes:
            _run(["git", "remote", "set-url", "projet_pmd", remote_url], cwd=target_root)
        else:
            _run(["git", "remote", "add", "projet_pmd", remote_url], cwd=target_root)

        _run(["git", "lfs", "push", "--all", "projet_pmd", "HEAD:main"], cwd=target_root, check=False)
        _run(["git", "push", "-u", "projet_pmd", "HEAD:main"], cwd=target_root)
        print(f"[SUCCÈS] Dépôt '{args.nom_mod}' en ligne : https://github.com/{repo_slug}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
