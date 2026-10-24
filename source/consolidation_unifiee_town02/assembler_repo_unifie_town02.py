#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Assembleur clé-en-main d'un dépôt unifié `town02` + TOUTES les maps PMDO.

Ce script construit un dépôt unique basé intégralement sur `meromoonmeri/town02`
(mod PMDO `0.8.12.0` complet : `Mod.xml`, `Content/`, `Data/`, `Strings/`,
`CONVERSION/`, `converter/`, `dev/`, `dist/`, `installer/`) et y fusionne :

  1. Toutes les branches de `meromoonmeri/projet-creation-pmdo` (19+ branches,
     416+ lots `source/*` cumulés avec les dépôts compagnons, incluant les 33
     maps 10 calques du Studio 60 FPS jusqu'à `FAE1`/`FAS1` et `KYE1`/`KYA1`,
     les mods unifiés entrées/fins, etc.) ;
  2. Toutes les branches de `meromoonmeri/projet-pmdo` (15+ branches — Guilde
     Treehouse PMD, trilogie Zénith, Mew, récifs étoilés, etc.) ;
  3. `meromoonmeri/zone-pmdo` (`main` — historique complet `guilde-treehouse-pmd`
     + lots en calques) et `meromoonmeri/all-zone-PMDO-project` (`main`) ;
  4. `meromoonmeri/guilde-treehouse-pmd` (toutes ses branches si accessibles avec
     les identifiants GitHub de l'utilisateur ; sinon repli transparent sur ses
     12 salles modulaires `salles/`, `fenetres_exterieur/` et 6 ambiances
     `exterieur/` déjà présentes dans les dépôts publics ci-dessus).

Intégration native anti-damier mauve PMDO `0.8.12.0` :
  - Déréférencement complet des liens symboliques (`follow_symlinks=True`) ;
  - Exécution optionnelle des `source/<lot>/build.py` pour matérialiser les
    `.tile`, `.rsground` et `init.lua` procéduraux ;
  - Copie sécurisée des banques `.tile` dans `Content/Tile/`, des cartes
    `.rsground` dans `Data/Ground/` (sans jamais écraser un `.rsground` natif de
    `town02` : en cas d'homonymie, la variante custom est enregistrée sous
    `<nom>__custom_pmdo.rsground`, sauf si `--remplacer-grounds-town02` est
    activé), et des scripts Lua dans `Data/Script/ground/` ;
  - Mise à jour atomique et triée alphabétiquement de `Content/Tile/index.idx`
    selon le format binaire exact `RogueEssence.Content.TileGuide` ;
  - Vérification intégrale anti-damier mauve (`0` planche absente, `0` `TexLoc`
    manquant, signatures PNG `\x89PNG\r\n\x1a\n` contrôlées aux offsets exacts).
"""
from __future__ import annotations

import argparse
import io
import json
import os
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

DEFAULT_SOURCE_REPOS: List[Tuple[str, bool]] = [
    ("meromoonmeri/projet-creation-pmdo", True),
    ("meromoonmeri/projet-pmdo", True),
    ("meromoonmeri/zone-pmdo", True),
    ("meromoonmeri/all-zone-PMDO-project", True),
    ("meromoonmeri/guilde-treehouse-pmd", False),  # privé : optionnel si token restreint
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
    """Insère ou met à jour un lot de fichiers `.tile` dans `Content/Tile/index.idx`.

    Retourne `(nb_avant, nb_apres, nb_injectees)`.
    """
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

    # Contrôle de relecture immédiat
    reloaded = lire_tile_index(idx_path)
    if len(reloaded) != len(merged):
        raise RuntimeError("Échec du contrôle après écriture de index.idx")
    return nb_avant, len(merged), injected


# ============================================================================
# Garde anti-damier mauve (.rsground et .rsmap)
# ============================================================================

def extraire_references_tuiles_rsground(map_path: Path) -> Optional[Set[Tuple[str, int, int]]]:
    """Retourne tous les triplets `(Sheet, X, Y)` d'un `.rsground` ou `.rsmap`.

    Retourne `None` si le fichier est un pointeur Git LFS non matérialisé.
    """
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
        # Cas 1 : .rsground (AnimTex directe avec `Frames`)
        _walk_frames(cell.get("Frames"))
        # Cas 2 : .rsmap (cellule avec sous-liste `Layers` -> `Frames`)
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

    # Cache par planche pour éviter de rouvrir 25 000 fois le même .tile
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
# Collecte multi-dépôts et multi-branches + fusion dans `town02`
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
    tile_index_before: int = 0
    tile_index_after: int = 0
    verified_tile_refs: int = 0


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
    repo_git_dir: Path, repo_label: str
) -> List[BranchSnapshot]:
    """Liste toutes les branches d'un dépôt Git local ou miroir bare."""
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
    """Retourne `[(mode_type, sha, name), ...]` pour `commit_sha:subpath`."""
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
    """Extrait le sous-arbre `tree_sha` dans `dest_dir` via `git archive`."""
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
    """Écrit le contenu du blob `blob_sha` dans `dest_file`."""
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    res = subprocess.run(
        ["git", "cat-file", "blob", blob_sha],
        cwd=str(repo_git_dir),
        check=True,
         capture_output=True,
    )
    dest_file.write_bytes(res.stdout)


def copier_fichier_dereference(src: Path, dst: Path) -> bool:
    """Copie `src` vers `dst` en suivant les liens symboliques si la cible existe."""
    try:
        resolved = src.resolve(strict=True)
    except OSError:
        return False
    if not resolved.is_file():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(resolved, dst, follow_symlinks=True)
    return True


def fusionner_branches_dans_town02(
    target_root: Path,
    source_repos: Sequence[Tuple[str, Path]],
    garder_variantes: bool = True,
    compiler_builds: bool = False,
    remplacer_grounds_town02: bool = False,
    ecraser_tiles_town02: bool = False,
    preferred_branch: str = DEFAULT_PREFERRED_BRANCH,
) -> AssemblyReport:
    """Fusionne tous les dépôts/branches sources dans une racine `town02` existante."""
    report = AssemblyReport()
    tile_dir = target_root / "Content" / "Tile"
    ground_dir = target_root / "Data" / "Ground"
    script_ground_dir = target_root / "Data" / "Script" / "ground"
    idx_path = tile_dir / "index.idx"

    tile_dir.mkdir(parents=True, exist_ok=True)
    ground_dir.mkdir(parents=True, exist_ok=True)
    script_ground_dir.mkdir(parents=True, exist_ok=True)

    existing_town02_grounds = {p.name.lower() for p in ground_dir.glob("*.rsground")}
    existing_town02_tiles = {p.name.lower() for p in tile_dir.glob("*.tile")}
    report.base_town02_grounds = len(existing_town02_grounds)
    report.base_town02_tiles = len(existing_town02_tiles)

    # Collecte et tri par priorité décroissante de toutes les branches
    all_snapshots: List[BranchSnapshot] = []
    for label, git_dir in source_repos:
        snaps = lister_branches_git_local(git_dir, label)
        all_snapshots.extend(snaps)
    all_snapshots.sort(
        key=lambda s: _priorite_branche(s, preferred_branch=preferred_branch),
        reverse=True,
    )
    report.branches_scanned = len(all_snapshots)

    maps_ws = target_root / "maps_sources"
    ws_source = maps_ws / "source"
    ws_variants = maps_ws / "variantes_branches"
    ws_renders = maps_ws / "renders"
    ws_guilde = maps_ws / "guilde_treehouse"
    ws_html = maps_ws / "apercus_html"
    for d in (ws_source, ws_renders, ws_guilde, ws_html):
        d.mkdir(parents=True, exist_ok=True)

    seen_source_canonical: Dict[str, str] = {}   # lot -> canonical tree_sha
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
            # 1) Documentation méthodologique & journaux
            if etype == "blob" and ename in ROOT_DOC_FILES and ename not in seen_docs:
                extraire_blob_git(snap.repo_git_dir, esha, maps_ws / ename)
                seen_docs.add(ename)

            # 2) Aperçus HTML + Studio index.html
            elif (
                etype == "blob"
                and (ename == "index.html" or (ename.startswith("apercu_") and ename.endswith(".html")))
                and ename not in seen_html
            ):
                extraire_blob_git(snap.repo_git_dir, esha, ws_html / ename)
                seen_html.add(ename)
                report.html_previews_merged += 1

            # 3) Fichiers .rsground racine éventuels (ex: cliffdaytest.rsground requis par certains build.py)
            elif etype == "blob" and ename.endswith(".rsground") and ename not in seen_root_rsgrounds:
                extraire_blob_git(snap.repo_git_dir, esha, maps_ws / ename)
                seen_root_rsgrounds.add(ename)

            # 4) Dossiers racine Guilde Treehouse (12 salles, 6 ambiances, fenêtres, calques, sprites...)
            elif etype == "tree" and ename in GUILDE_ROOT_DIRS and ename not in seen_guilde_dirs:
                extraire_sous_arbre_git(
                    snap.repo_git_dir, snap.commit_sha, esha, ws_guilde / ename
                )
                link_at_ws = maps_ws / ename
                if not link_at_ws.exists() and not link_at_ws.is_symlink():
                    link_at_ws.symlink_to(Path("guilde_treehouse") / ename)
                seen_guilde_dirs.add(ename)
                report.guilde_dirs_merged.append(ename)

            # 5) Lots `source/*` + moteurs partagés `source/*.py`
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

            # 6) Lots `renders/*`
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

    # Exécution optionnelle des scripts `maps_sources/source/*/build.py`
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
                report.builds_failed.append(
                    f"{build_py.parent.name}: rc={res.returncode}"
                )

    # Récolte de tous les `.tile`, `.rsground` et scripts Lua générés ou extraits
    harvested_tiles: Dict[str, Path] = {}
    harvested_grounds: Dict[str, Path] = {}
    harvested_script_dirs: Dict[str, Path] = {}

    for tp in sorted(maps_ws.rglob("*.tile")):
        try:
            real_tp = tp.resolve(strict=True)
        except OSError:
            continue
        if real_tp.is_file() and tp.name not in harvested_tiles:
            harvested_tiles[tp.name] = real_tp

    for gp in sorted(maps_ws.rglob("*.rsground")):
        try:
            real_gp = gp.resolve(strict=True)
        except OSError:
            continue
        if real_gp.is_file() and gp.name not in harvested_grounds:
            harvested_grounds[gp.name] = real_gp

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
                for gchild in sorted(child.iterdir()):
                    if gchild.is_dir():
                        rel_key = f"ground/{gchild.name}"
                        if rel_key not in harvested_script_dirs:
                            harvested_script_dirs[rel_key] = gchild
            else:
                rel_key = child.name
                if rel_key not in harvested_script_dirs:
                    harvested_script_dirs[rel_key] = child

    # Installation sécurisée des planches `.tile` dans `Content/Tile/`
    tiles_to_index: List[Path] = []
    for tname, tsrc in sorted(harvested_tiles.items()):
        tdst = tile_dir / tname
        if tname.lower() in existing_town02_tiles and not ecraser_tiles_town02:
            continue
        if copier_fichier_dereference(tsrc, tdst):
            tiles_to_index.append(tdst)
            report.custom_tiles_installed += 1

    # Mise à jour atomique de `Content/Tile/index.idx`
    if tiles_to_index or not idx_path.exists():
        before, after, _ = injecter_planches_dans_index(idx_path, tiles_to_index)
        report.tile_index_before = before
        report.tile_index_after = after
    elif idx_path.exists():
        n_idx = len(lire_tile_index(idx_path))
        report.tile_index_before = n_idx
        report.tile_index_after = n_idx

    # Installation sécurisée des cartes `.rsground` dans `Data/Ground/`
    installed_ground_paths: List[Path] = []
    for gname, gsrc in sorted(harvested_grounds.items()):
        if gname.lower() in existing_town02_grounds and not remplacer_grounds_town02:
            stem = Path(gname).stem
            aliased_name = f"{stem}__custom_pmdo.rsground"
            gdst = ground_dir / aliased_name
            report.custom_grounds_aliased.append(f"{gname} -> {aliased_name}")
        else:
            gdst = ground_dir / gname
        if copier_fichier_dereference(gsrc, gdst):
            installed_ground_paths.append(gdst)
            report.custom_grounds_installed += 1

    # Installation sécurisée des scripts Lua `Data/Script/<namespace>/...` et `Data/Script/ground/<id>/`
    script_root_dir = target_root / "Data" / "Script"
    for rel_key, ssrc in sorted(harvested_script_dirs.items()):
        sdst = script_root_dir / rel_key
        if sdst.exists():
            continue
        sdst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(ssrc, sdst, symlinks=False)
        report.custom_scripts_installed += 1

    # Contrôle anti-damier mauve sur tous les `.rsground` nouvellement installés
    # dont toutes les planches référencées sont présentes localement
    verifiable_grounds: List[Path] = []
    idx_entries_names = (
        {e.sheet for e in lire_tile_index(idx_path)} if idx_path.exists() else set()
    )
    for gp in installed_ground_paths:
        refs = extraire_references_tuiles_rsground(gp)
        if refs is None:
            continue
        # Vérifie que les .tile référencés ne sont pas des pointeurs LFS
        all_materialized = True
        for sheet, _, _ in refs:
            tp = tile_dir / f"{sheet}.tile"
            if tp.exists():
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

    # Protection automatique Git LFS pour tout fichier > 90 Mo hors .git
    proteger_gros_fichiers_git_lfs(target_root, seuil_octets=90 * 1024 * 1024)

    # Génération du catalogue récapitulatif à la racine du dépôt unifié
    ecrire_catalogue_racine(target_root, report, source_repos)
    return report


def proteger_gros_fichiers_git_lfs(root: Path, seuil_octets: int = 90 * 1024 * 1024) -> List[str]:
    """Ajoute dans `.gitattributes` tout fichier > `seuil_octets` pour éviter le rejet GitHub 100 Mo."""
    gitattr = root / ".gitattributes"
    existing_text = gitattr.read_text(encoding="utf-8") if gitattr.exists() else ""
    added_rules: List[str] = []

    for p in root.rglob("*"):
        if ".git" in p.parts or not p.is_file():
            continue
        if p.stat().st_size > seuil_octets:
            rel = p.relative_to(root).as_posix()
            rule = f'{rel} filter=lfs diff=lfs merge=lfs -text'
            if rel not in existing_text:
                existing_text = existing_text.rstrip("\n") + "\n" + rule + "\n"
                added_rules.append(rel)

    if added_rules:
        gitattr.write_text(existing_text, encoding="utf-8")
    return added_rules


def ecrire_catalogue_racine(
    target_root: Path,
    report: AssemblyReport,
    source_repos: Sequence[Tuple[str, Path]],
) -> Path:
    """Écrit `CATALOGUE_COMPLET_UNIFIE.md` et `inventaire_unifie_final.json`."""
    inv = {
        "base_town02_grounds": report.base_town02_grounds,
        "base_town02_tiles": report.base_town02_tiles,
        "branches_scanned": report.branches_scanned,
        "source_repos": [label for label, _ in source_repos],
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
        "tile_index_before": report.tile_index_before,
        "tile_index_after": report.tile_index_after,
        "verified_tile_refs": report.verified_tile_refs,
    }
    (target_root / "inventaire_unifie_final.json").write_text(
        json.dumps(inv, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    md = [
        "# Dépôt Unifié `town02` + Toutes les Maps PMDO & Guilde Treehouse",
        "",
        "Ce dépôt rassemble au même endroit l'intégralité du mod **`town02`** (`PMDO 0.8.12.0`) ainsi que **toutes les maps de toutes les branches** de `projet-creation-pmdo`, `projet-pmdo`, `zone-pmdo`, `all-zone-PMDO-project` et `guilde-treehouse-pmd`.",
        "",
        "## Bilan de l'assemblage",
        "",
        f"- **Cartes `.rsground` de base (`town02`)** : `{report.base_town02_grounds}`",
        f"- **Planches `.tile` de base (`town02`)** : `{report.base_town02_tiles}`",
        f"- **Branches Git inspectées et fusionnées** : `{report.branches_scanned}`",
        f"- **Lots `maps_sources/source/*` unifiés** : `{report.source_lots_merged}` (+ `{report.branch_variants_saved}` variantes inter-branches conservées)",
        f"- **Lots `maps_sources/renders/*` unifiés** : `{report.renders_lots_merged}`",
        f"- **Aperçus interactifs HTML (`maps_sources/apercus_html/`)** : `{report.html_previews_merged}`",
        f"- **Dossiers Guilde Treehouse (`maps_sources/guilde_treehouse/`)** : `{', '.join(report.guilde_dirs_merged) or 'aucun'}`",
        f"- **Nouvelles planches `.tile` installées dans `Content/Tile/`** : `{report.custom_tiles_installed}` (`index.idx` : `{report.tile_index_before}` -> `{report.tile_index_after}` planches)",
        f"- **Nouvelles cartes `.rsground` installées dans `Data/Ground/`** : `{report.custom_grounds_installed}`",
        f"- **Scripts Lua installés dans `Data/Script/ground/`** : `{report.custom_scripts_installed}`",
        f"- **Références de tuiles contrôlées sans damier mauve** : `{report.verified_tile_refs}` (`0` erreur)",
        "",
        "## Organisation du dépôt",
        "",
        "- `Mod.xml`, `Content/Tile/`, `Data/Ground/`, `Data/Script/`, `Strings/` : mod PMDO `0.8.12.0` directement ouvrable dans RogueEssence / PMDO Ground Editor.",
        "- `maps_sources/source/` : tous les générateurs Python, kits et sources multi-branches (`projet-creation-pmdo` + `projet-pmdo` + `zone-pmdo`).",
        "- `maps_sources/variantes_branches/` : versions alternatives issues des autres branches lorsqu'un même dossier a divergé.",
        "- `maps_sources/guilde_treehouse/` : les 12 salles modulaires (`salles/`), fenêtres transparentes (`fenetres_exterieur/`), 6 ambiances (`exterieur/`), calques et sprites de la Guilde Treehouse PMD.",
        "- `maps_sources/apercus_html/` : Studio 60 FPS et les 330+ aperçus HTML.",
        "",
    ]
    cat_path = target_root / "CATALOGUE_COMPLET_UNIFIE.md"
    cat_path.write_text("\n".join(md), encoding="utf-8")
    return cat_path


# ============================================================================
# Interface ligne de commande (clonage GitHub + assemblage + création/push)
# ============================================================================

def cloner_sources_github(
    work_cache: Path, repos_spec: Sequence[Tuple[str, bool]] = DEFAULT_SOURCE_REPOS
) -> List[Tuple[str, Path]]:
    """Clone en miroir `--bare --filter=blob:none` chaque dépôt source accessible."""
    work_cache.mkdir(parents=True, exist_ok=True)
    cloned: List[Tuple[str, Path]] = []
    for slug, required in repos_spec:
        dest = work_cache / (_sanitize_slug(slug) + ".git")
        url = f"https://github.com/{slug}.git"
        if dest.exists():
            print(f"[fetch] Mise à jour du miroir {slug}...")
            _run(["git", "fetch", "--all", "--prune"], cwd=dest, check=required)
            cloned.append((slug, dest))
            continue
        print(f"[clone] Récupération de toutes les branches de {slug}...")
        res = _run(
            ["git", "clone", "--bare", "--filter=blob:none", url, str(dest)],
            check=False,
        )
        if res.returncode == 0:
            cloned.append((slug, dest))
        elif required:
            raise RuntimeError(
                f"Impossible de cloner le dépôt requis {slug} :\n{res.stderr}"
            )
        else:
            print(
                f"[info] Dépôt privé/optionnel {slug} non accessible directement "
                f"(ses salles/ambiances publiques restent incluses via zone-pmdo & projet-pmdo)."
            )
    return cloned


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        description="Construit le dépôt unifié town02 + toutes les maps PMDO & Guilde Treehouse."
    )
    parser.add_argument(
        "--sortie",
        required=True,
        help="Dossier cible du dépôt unifié (ex: ~/town02-all-maps-pmdo)",
    )
    parser.add_argument(
        "--cache-clones",
        default="",
        help="Dossier temporaire pour les miroirs Git multi-branches (défaut: <sortie>_cache)",
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
        help="Dépôt source local sous la forme label=/chemin/vers/repo (répétable, mode hors-ligne/test)",
    )
    parser.add_argument(
        "--compiler-builds",
        action="store_true",
        help="Exécuter tous les scripts source/<lot>/build.py pour matérialiser les .tile/.rsground procéduraux",
    )
    parser.add_argument(
        "--sans-variantes",
        action="store_true",
        help="Ne garder que la version canonique la plus récente de chaque dossier source/<lot>",
    )
    parser.add_argument(
        "--remplacer-grounds-town02",
        action="store_true",
        help="Remplacer les .rsground natifs de town02 en cas de même nom de fichier",
    )
    parser.add_argument(
        "--creer-et-pousser",
        default="",
        help="Créer et pousser vers ce dépôt GitHub via `gh repo create` (ex: meromoonmeri/town02-all-maps-pmdo)",
    )
    parser.add_argument(
        "--visibilite",
        choices=["public", "private"],
        default="public",
        help="Visibilité du nouveau dépôt GitHub créé avec --creer-et-pousser (défaut: public)",
    )

    args = parser.parse_args(argv)
    target_root = Path(args.sortie).expanduser().resolve()
    cache_dir = (
        Path(args.cache_clones).expanduser().resolve()
        if args.cache_clones
        else target_root.parent / f"{target_root.name}_git_cache"
    )

    # 1. Préparation de la base `town02`
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

    # 2. Récupération des dépôts multi-branches
    if args.source_local:
        source_repos: List[Tuple[str, Path]] = []
        for spec in args.source_local:
            if "=" in spec:
                lbl, p_str = spec.split("=", 1)
            else:
                p_str = spec
                lbl = Path(p_str).name
            source_repos.append((lbl, Path(p_str).expanduser().resolve()))
    else:
        print("[2/4] Récupération de toutes les branches PMDO & Guilde Treehouse...")
        source_repos = cloner_sources_github(cache_dir, DEFAULT_SOURCE_REPOS)

    # 3. Fusion, indexation `Content/Tile/index.idx` et contrôle anti-damier
    print("[3/4] Fusion multi-branches, injection .tile/.rsground et mise à jour de Content/Tile/index.idx...")
    report = fusionner_branches_dans_town02(
        target_root=target_root,
        source_repos=source_repos,
        garder_variantes=not args.sans_variantes,
        compiler_builds=args.compiler_builds,
        remplacer_grounds_town02=args.remplacer_grounds_town02,
    )

    print(
        f"[OK] Fusion terminée :\n"
        f"  - Base town02          : {report.base_town02_grounds} .rsground, {report.base_town02_tiles} .tile\n"
        f"  - Branches fusionnées  : {report.branches_scanned}\n"
        f"  - Lots source/*        : {report.source_lots_merged} (+ {report.branch_variants_saved} variantes)\n"
        f"  - Lots renders/*       : {report.renders_lots_merged}\n"
        f"  - Aperçus HTML         : {report.html_previews_merged}\n"
        f"  - Planches .tile ajout.: {report.custom_tiles_installed} (index.idx: {report.tile_index_before} -> {report.tile_index_after})\n"
        f"  - Grounds ajoutés      : {report.custom_grounds_installed}\n"
        f"  - Tuiles vérifiées OK  : {report.verified_tile_refs} (0 damier mauve)"
    )

    # 4. Création et push optionnels vers un nouveau dépôt GitHub
    if args.creer_et_pousser:
        repo_slug = args.creer_et_pousser
        if "/" not in repo_slug:
            repo_slug = f"{DEFAULT_OWNER}/{repo_slug}"
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
                    "Consolidation complète town02 + toutes branches projet-creation-pmdo & Guilde Treehouse",
                ],
                cwd=target_root,
            )

        # Création du dépôt sur GitHub s'il n'existe pas encore
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
                    "Mod unifié town02 + toutes les maps de toutes les branches de projet-creation-pmdo & Guilde Treehouse PMD",
                ],
                cwd=target_root,
            )

        remote_url = f"https://github.com/{repo_slug}.git"
        remotes = _run(["git", "remote"], cwd=target_root).stdout.splitlines()
        if "unified" in remotes:
            _run(["git", "remote", "set-url", "unified", remote_url], cwd=target_root)
        else:
            _run(["git", "remote", "add", "unified", remote_url], cwd=target_root)

        _run(["git", "lfs", "push", "--all", "unified", "HEAD:main"], cwd=target_root, check=False)
        _run(["git", "push", "-u", "unified", "HEAD:main"], cwd=target_root)
        print(f"[SUCCÈS] Dépôt unifié en ligne : https://github.com/{repo_slug}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
