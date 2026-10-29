#!/usr/bin/env python3
"""Build one PMDO 0.8.12 Destiny mod from catalogued, source-backed Grounds.

Selection is deliberately conservative: native 0.8.12 Ground JSON, a walkable
source-backed entrance, a non-empty source collision mask, and all referenced
tile/background assets present in the same archive. One reviewed map uses a
canonical `entrance` alias at the identical source collider; no topology,
collision, exit, warp, or story data is invented. Ground AssetName/file IDs and
the technical script namespace are made unique for the combined mod.

The remaining image-only/older/ambiguous maps are recorded in
source/pmdo_cote/catalogue_jouabilite.json and are not silently guessed.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import sys
import tempfile
import uuid
import xml.etree.ElementTree as ET
import zipfile
from collections import deque
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from source.serveur_apercus.serve import UpstreamRepository  # noqa: E402
from source.pmdo_cote.build_exploration_batch01 import (  # noqa: E402
    decode_index,
    encode_index,
    safe_relative,
    tile_header_and_coords,
)

GAME_VERSION = "0.8.12.0"
NAMESPACE = "destiny"
NAME = "PMD Destiny — Catalogue d’exploration 0.8.12"
INVENTORY = ROOT / "source/pmdo_cote/catalogue_jouabilite.json"
DEFAULT_OUTPUT = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
EXPECTED_MAPS = 208

# One additional 0.8.12 Ground is admitted by an explicit source-backed review:
# it has a named, walkable southern entrance and a designed northern exit, but
# the source uses descriptive marker names rather than PMDO's canonical names.
MANUAL_EXTRA_GROUNDS = {
    (
        "mod_zone_bassin_chauffant_pmdo_0812.zip",
        "zone_bassin_chauffant/Data/Ground/zbc1_zone_bassin_chauffant.rsground",
        "58397c52ff592c47367a6ad59d3d1b45282586c9c31e9f8bd7b73a6a11b9735d",
    ): "Marker entrance_sud and sortie_nord are source-authored, walkable, and connected.",
}
ENTRY_MARKER_ALIASES = {
    (
        "mod_zone_bassin_chauffant_pmdo_0812.zip",
        "zone_bassin_chauffant/Data/Ground/zbc1_zone_bassin_chauffant.rsground",
        "58397c52ff592c47367a6ad59d3d1b45282586c9c31e9f8bd7b73a6a11b9735d",
    ): {
        "sourceMarker": "entrance_sud",
        "rationale": "Alias PMDO entrance au même collider que l’entrée sud explicitement nommée par la source.",
    },
}


def safe_slug(value: str, limit: int = 24) -> str:
    value = re.sub(r"[^A-Za-z0-9_]+", "_", value).strip("_").lower()
    value = re.sub(r"_+", "_", value)
    return (value or "map")[:limit].strip("_") or "map"


def normalize_source_labels(value: Any) -> Any:
    """Remove the user-disallowed name from copied Ground text without changing data."""
    if isinstance(value, dict):
        return {key: normalize_source_labels(item) for key, item in value.items()}
    if isinstance(value, list):
        return [normalize_source_labels(item) for item in value]
    if isinstance(value, str):
        value = re.sub(r"(?i)\bfleurs\s+halcyon\s+natives\b", "fleurs natives du projet source", value)
        value = re.sub(r"(?i)\bfleurs\s+halcyon\b", "fleurs natives", value)
        return re.sub(r"(?i)\bhalcyon\b", "source native", value)
    return value


def output_mod_xml() -> bytes:
    header = ET.Element("Header")
    ET.SubElement(header, "Name").text = NAME
    ET.SubElement(header, "Author").text = "PMD Destiny (assemblage)"
    ET.SubElement(header, "Description").text = (
        "Catalogue de cartes d’exploration PMDO 0.8.12, assemblé sous le namespace "
        "technique destiny. Les données natives et collisions d’origine sont conservées; "
        "voir README.md, CREDITS.md et manifest.json."
    )
    ET.SubElement(header, "Namespace").text = NAMESPACE
    stable = uuid.uuid5(uuid.NAMESPACE_URL, "PMD Destiny catalogue maps PMDO 0.8.12")
    ET.SubElement(header, "UUID").text = str(stable)
    ET.SubElement(header, "Version").text = "1.0.0.0"
    ET.SubElement(header, "GameVersion").text = GAME_VERSION
    ET.SubElement(header, "ModType").text = "Quest"
    ET.SubElement(header, "Relationships")
    return ET.tostring(header, encoding="utf-8", xml_declaration=True) + b"\n"


def select_maps(inventory: dict) -> list[dict]:
    result = []
    for row in inventory["grounds"]:
        flags = set(row.get("flags", []))
        identity = (row.get("archive"), row.get("ground"), row.get("sha256"))
        manual_extra = identity in MANUAL_EXTRA_GROUNDS
        source_backed = (
            row.get("version") == GAME_VERSION
            and row.get("entry_walkable") is True
            and "all_walkable_collision" not in flags
            and "missing_tile_refs" not in flags
            and "missing_bg_refs" not in flags
            and "entry_blocked_or_outside" not in flags
            and "parse_error" not in flags
        )
        if source_backed or manual_extra:
            if row.get("version") != GAME_VERSION:
                raise ValueError(f"Version inattendue pour une inclusion explicite: {identity}")
            result.append(row)
    return sorted(result, key=lambda row: (
        row.get("repo", ""), row.get("archive", "").casefold(),
        row.get("commit", ""), row.get("ground", "").casefold(),
    ))


def stage_write(stage: Path, file_meta: dict[str, dict[str, Any]], relative: str, data: bytes) -> None:
    path = PurePosixPath(relative)
    if path.is_absolute() or ".." in path.parts:
        raise ValueError(f"Chemin de sortie invalide: {relative}")
    digest = hashlib.sha256(data).hexdigest()
    prior = file_meta.get(relative)
    if prior:
        if prior["sha256"] != digest:
            raise ValueError(f"Collision de contenu dans le package: {relative}")
        return
    destination = stage.joinpath(*path.parts)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
    file_meta[relative] = {"sha256": digest, "bytes": len(data)}


def get_source_blob(repo: UpstreamRepository, row: dict, archive_info: dict) -> Any:
    expected = (row["archive"], row["repo"], row["commit"], archive_info["sha"])
    matches = [blob for blob in repo.archive_by_id.values()
               if (blob.path, blob.source_repo, blob.commit, blob.sha) == expected]
    if len(matches) != 1:
        raise ValueError(f"Archive source absente/ambiguë: {expected} ({len(matches)})")
    return matches[0]


def marker_grid_cell(marker: dict) -> tuple[int, int]:
    box = marker.get("Collider", {})
    x, y = int(box.get("X", -1)), int(box.get("Y", -1))
    width, height = int(box.get("Width", 0)), int(box.get("Height", 0))
    if x < 0 or y < 0 or width <= 0 or height <= 0:
        raise ValueError(f"Collider invalide: {marker.get('EntName')}")
    return ((x + width // 2) // 8, (y + height // 2) // 8)


def apply_source_entry_alias(row: dict, obj: dict) -> dict[str, Any] | None:
    identity = (row.get("archive"), row.get("ground"), row.get("sha256"))
    rule = ENTRY_MARKER_ALIASES.get(identity)
    if not rule:
        return None
    markers = [marker for entity in obj.get("Entities", []) or []
               for marker in entity.get("Markers", []) or []]
    if any(str(marker.get("EntName", "")).casefold() == "entrance" for marker in markers):
        raise ValueError(f"Alias d’entrée redondant pour {row['ground']}")
    candidates = [marker for marker in markers
                  if str(marker.get("EntName", "")).casefold() == rule["sourceMarker"].casefold()]
    if len(candidates) != 1:
        raise ValueError(f"Marker source d’entrée absent/ambigu: {rule['sourceMarker']} ({row['ground']})")
    source_marker = candidates[0]
    source_cell = marker_grid_cell(source_marker)
    alias = copy.deepcopy(source_marker)
    alias["EntName"] = "entrance"
    orders = [int(marker.get("EntOrder", -1)) for marker in markers
              if isinstance(marker.get("EntOrder", -1), int)]
    if "EntOrder" in alias:
        alias["EntOrder"] = max(orders, default=-1) + 1
    owner = next(entity for entity in obj.get("Entities", []) or []
                 if any(marker is source_marker for marker in (entity.get("Markers", []) or [])))
    owner.setdefault("Markers", []).append(alias)
    if marker_grid_cell(alias) != source_cell:
        raise ValueError(f"Collider d’alias déplacé pour {row['ground']}")
    return {
        "canonicalMarker": "entrance",
        "sourceMarker": str(source_marker.get("EntName", "")),
        "sameCollider": True,
        "cell": list(source_cell),
        "rationale": rule["rationale"],
    }


def is_explicit_exit_name(name: str) -> bool:
    value = str(name).casefold()
    if value in {"sortie", "exit", "destination", "warp", "door"}:
        return True
    tokens = re.split(r"[^a-z0-9]+", value)
    return any(token in {"sortie", "exit", "destination", "warp"} for token in tokens)


def explicit_exit_markers(
    obj: dict, walkable: set[tuple[int, int]], reached: set[tuple[int, int]],
) -> list[dict[str, Any]]:
    found = []
    for entity in obj.get("Entities", []) or []:
        for marker in entity.get("Markers", []) or []:
            name = str(marker.get("EntName", ""))
            if not is_explicit_exit_name(name):
                continue
            cell = marker_grid_cell(marker)
            found.append({
                "name": name,
                "cell": list(cell),
                "walkable": cell in walkable,
                "reachableFromEntry": cell in reached,
            })
    return found


def collision_stats(obj: dict) -> tuple[int, int, int, set[tuple[int, int]], set[tuple[int, int]]]:
    grid = obj.get("obstacles")
    if not isinstance(grid, list) or not grid or not grid[0]:
        raise ValueError("grille de collisions vide")
    width, height = len(grid), len(grid[0])
    if any(not isinstance(column, list) or len(column) != height for column in grid):
        raise ValueError("grille de collisions irrégulière")
    walkable: set[tuple[int, int]] = set()
    blocked = 0
    for x, column in enumerate(grid):
        for y, cell in enumerate(column):
            if int(cell.get("Tags", 0)) == 0:
                walkable.add((x, y))
            else:
                blocked += 1
    if not blocked:
        raise ValueError("collision entièrement libre (non jouable sans conception)")
    for layer in obj.get("Layers", []) or []:
        tiles = layer.get("Tiles", []) or []
        if len(tiles) != width or any(len(column) != height for column in tiles):
            raise ValueError("dimensions de calque différentes de la grille")
    markers = [marker for entity in obj.get("Entities", []) or []
               for marker in entity.get("Markers", []) or []]
    entrances = [m for m in markers if str(m.get("EntName", "")).casefold() == "entrance"]
    if not entrances:
        raise ValueError("marker entrance absent")

    starts = {marker_grid_cell(marker) for marker in entrances}
    if not starts <= walkable:
        raise ValueError(f"entrée hors grille/bloquée: {sorted(starts - walkable)}")
    reached = set(starts)
    queue = deque(starts)
    while queue:
        x, y = queue.popleft()
        for neighbor in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if neighbor in walkable and neighbor not in reached:
                reached.add(neighbor)
                queue.append(neighbor)
    exits = {
        str(m.get("EntName", "")).casefold(): marker_grid_cell(m)
        for m in markers
        if str(m.get("EntName", "")).casefold() in {"sortie", "exit", "destination", "warp", "door"}
    }
    if any(p not in walkable for p in exits.values()):
        raise ValueError(f"marker de sortie bloqué/hors grille: {exits}")
    if any(p not in reached for p in exits.values()):
        raise ValueError(f"marker de sortie inatteignable depuis l’entrée: {exits}")
    return width, height, blocked, walkable, reached


def frame_references(obj: dict) -> tuple[set[str], set[str]]:
    tiles: set[str] = set()
    backgrounds: set[str] = set()
    for layer in obj.get("Layers", []) or []:
        for column in layer.get("Tiles", []) or []:
            for cell in column or []:
                if cell.get("AutoTileset") or cell.get("Associates"):
                    raise ValueError("AutoTileset/Associates non prévu dans ce lot")
                for animation in cell.get("Layers", []) or []:
                    for frame in animation.get("Frames", []) or []:
                        if frame.get("Sheet"):
                            tiles.add(str(frame["Sheet"]))
    blank = obj.get("BlankBG", {}) or {}
    if blank.get("AutoTileset") or blank.get("Associates"):
        raise ValueError("BlankBG AutoTileset/Associates non prévu dans ce lot")
    for layer in (obj.get("Background", {}) or {}).get("Layers", []) or []:
        bg = layer.get("BG", {}) or {}
        name = (bg.get("BGAnim", {}) or {}).get("AnimIndex")
        if name:
            backgrounds.add(str(name))
    for decoration in obj.get("Decorations", []) or []:
        if decoration.get("Anims"):
            raise ValueError("Animation de décoration non auditée")
    if obj.get("Music"):
        raise ValueError(f"Musique non empaquetée: {obj['Music']}")
    for entity in obj.get("Entities", []) or []:
        if entity.get("MapChars") or entity.get("Spawners") or entity.get("GroundObjects"):
            raise ValueError("Entités gameplay non empaquetées par ce lot")
    return tiles, backgrounds


def find_resource(paths: list[str], root: str, folder: str, stem: str, extension: str) -> str:
    expected = f"{folder}/{stem}{extension}".casefold()
    matches = []
    for name in paths:
        relative = safe_relative(name, root).as_posix().casefold()
        if relative == expected:
            matches.append(name)
    if len(matches) == 1:
        return matches[0]
    # Case-only mismatch: accept only one unambiguous resource and normalize
    # references to the actual stem in the copied Ground JSON.
    candidates = []
    for name in paths:
        relative = safe_relative(name, root)
        parts = relative.parts
        if len(parts) == 3 and parts[0].casefold() == folder.split("/")[0].casefold() \
                and parts[1].casefold() == folder.split("/")[1].casefold() \
                and parts[-1].casefold() == f"{stem}{extension}".casefold():
            candidates.append(name)
    if len(candidates) == 1:
        return candidates[0]
    raise ValueError(f"Ressource absente/ambiguë: {folder}/{stem}{extension} ({len(candidates)})")


def script_for_map(archive: zipfile.ZipFile, names: list[str], root: str, source_asset: str) -> bytes:
    candidates = []
    for name in names:
        relative = safe_relative(name, root)
        parts = tuple(part.casefold() for part in relative.parts)
        if (len(parts) >= 5 and parts[:2] == ("data", "script")
                and "ground" in parts[2:-2]
                and parts[-2] == source_asset.casefold()
                and parts[-1] == "init.lua"):
            candidates.append(name)
    if not candidates:
        raise ValueError(f"Script Ground absent pour {source_asset}")
    contents = {archive.read(name) for name in candidates}
    if len(contents) != 1:
        raise ValueError(f"Scripts Ground conflictuels pour {source_asset}")
    data = next(iter(contents))
    if re.search(rb"\b(?:require|dofile)\s*\(", data):
        raise ValueError(f"Dépendance Lua externe à migrer pour {source_asset}")
    return data


def make_readme(records: list[dict], tile_count: int, bg_count: int) -> bytes:
    no_exit = sum(not row["hasExplicitExitMarker"] for row in records)
    review_required = sum(bool(row.get("playabilityReviewRequired")) for row in records)
    lines = [
        "# PMD Destiny — catalogue d’exploration PMDO 0.8.12",
        "",
        f"**{len(records)} Ground** provenant d’archives PMDO 0.8.12 existantes, réunis dans un seul mod/namespace `destiny`.",
        f"Ressources locales incluses : **{tile_count} tilesets** et **{bg_count} fonds**.",
        "",
        "## Contenu et limites",
        "",
        "Les Ground natifs, calques, grilles de collision, markers, tiles et scripts source sont conservés. "
        "Seuls les identifiants `AssetName`/fichiers Ground sont rendus uniques et les chemins de scripts "
        "sont réunis sous `Data/Script/destiny/`. Un alias PMDO `entrance` est ajouté à `entrance_sud` "
        "pour le seul bassin chauffant, sans déplacer son collider; aucun obstacle, warp ou scénario n’est ajouté.",
        "Les points de sortie explicitement nommés sont conservés et audités (case marchable + accès depuis l’entrée). "
        "Un marker bloqué est signalé dans le manifeste sans être déplacé ni transformé en transition.",
        f"{no_exit} carte(s) n’ont pas de marker de sortie explicite reconnu; elles restent sans transition automatique, "
        "comme dans leurs sources. Les liens entre cartes restent à définir lors de l’intégration de TOWN02.",
        "",
        "Les cartes de ce lot satisfont les filtres du registre : version 0.8.12, entrée sur case marchable, "
        "au moins une collision bloquante et références d’assets présentes dans l’archive source. "
        "Les collisions n’ont pas été comparées visuellement au dessin.",
        f"{review_required} occurrences portent une note source explicite demandant une revue de jouabilité/collisions; voir `playabilityReviewReasons` dans `manifest.json`.",
        "",
        "## Installation",
        "",
        "1. Fermer PMDO.",
        "2. Extraire le dossier `destiny` dans `PMDO/MODS/`.",
        "3. Activer `PMD Destiny — Catalogue d’exploration 0.8.12` comme quête.",
        "4. Les Ground sont dans `Data/Ground/`; les crédits et chemins d’origine sont dans `CREDITS.md` et `manifest.json`.",
        "",
        "Le chargeur natif PMDO 0.8.12 et le test de rendu graphique sont consignés après vérification; "
        "ce ZIP n’ajoute pas de connexion de scénario entre les cartes.",
        "",
    ]
    return "\n".join(lines).encode("utf-8")


def make_credits(records: list[dict]) -> bytes:
    lines = [
        "# Sources et crédits",
        "",
        "Les auteurs et namespaces d’origine sont conservés comme provenance. Le namespace technique du mod assemblé est `destiny`.",
        "",
        "| Carte | Auteur source | Mod / namespace source | Archive / commit source |",
        "|---|---|---|---|",
    ]
    for row in records:
        repo = row["sourceArchiveRepo"]
        commit = row["sourceArchiveCommit"]
        path = row["sourceArchive"]
        url = f"https://github.com/{repo}/blob/{commit}/{path}"
        lines.append(
            f"| {row['name']} (`{row['sourceAssetName']}`) | {row['sourceAuthor']} | "
            f"{row['sourceModName']} / `{row['sourceNamespace']}` | [`{path}`]({url}) |"
        )
    lines += ["", "Références README source par archive : `Documentation/Sources/`. Certaines notices sont remplacées par un lien de provenance lorsque leur copie reproduirait une attribution externe.\n"]
    return "\n".join(lines).encode("utf-8")


def build(output: Path) -> dict[str, Any]:
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    maps = select_maps(inventory)
    if len(maps) != EXPECTED_MAPS:
        raise ValueError(f"Filtres d’entrée modifiés: {len(maps)} Ground, attendu {EXPECTED_MAPS}")
    archive_info = {
        (row["repo"], row["path"], row["commit"]): row
        for row in inventory["archives"]
    }
    repo = UpstreamRepository()
    files_meta: dict[str, dict[str, Any]] = {}
    tile_nodes: dict[str, bytes] = {}
    tile_hashes: dict[str, str] = {}
    tile_case: dict[str, str] = {}
    bg_hashes: dict[str, str] = {}
    bg_case: dict[str, str] = {}
    records: list[dict[str, Any]] = []
    archive_readmes: dict[str, bytes] = {}
    source_readme_attributions_not_mirrored: list[dict[str, str]] = []
    used_aliases: set[str] = set()
    output = output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    cache_root = ROOT / ".cache"
    cache_root.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="destiny-catalogue-0812-", dir=cache_root) as temp:
        stage = Path(temp)
        groups: dict[tuple[str, str, str], list[dict]] = {}
        for row in maps:
            key = (row["repo"], row["archive"], row["commit"])
            groups.setdefault(key, []).append(row)

        for group_number, (key, ground_rows) in enumerate(sorted(groups.items()), 1):
            source_repo, archive_path, source_commit = key
            archive_metadata = archive_info.get((source_repo, archive_path, source_commit))
            if not archive_metadata:
                raise ValueError(f"Archive absente du registre: {key}")
            blob = get_source_blob(repo, {
                "archive": archive_path, "repo": source_repo, "commit": source_commit,
            }, archive_metadata)
            archive_bytes = repo.get_blob(blob)
            with zipfile.ZipFile(io.BytesIO(archive_bytes)) as archive:
                names = [name for name in archive.namelist() if not name.endswith("/")]
                mod_paths = [name for name in names if PurePosixPath(name).name.casefold() == "mod.xml"]
                if len(mod_paths) != 1:
                    raise ValueError(f"Mod.xml source absent/ambigu: {archive_path}")
                mod_root = str(PurePosixPath(mod_paths[0]).parent)
                if mod_root == ".":
                    mod_root = ""
                source_mod = ET.fromstring(archive.read(mod_paths[0]))
                source_namespace = source_mod.findtext("Namespace") or ""
                source_mod_name = source_mod.findtext("Name") or archive_path
                source_author = source_mod.findtext("Author") or "Non spécifié"
                if source_mod.findtext("GameVersion") != GAME_VERSION:
                    raise ValueError(f"GameVersion source différente de {GAME_VERSION}: {archive_path}")
                index_paths = [name for name in names
                               if safe_relative(name, mod_root).as_posix().casefold() == "content/tile/index.idx"]
                if len(index_paths) != 1:
                    raise ValueError(f"Index source absent/ambigu: {archive_path}")
                source_index = decode_index(archive.read(index_paths[0]))
                local_tiles: dict[str, tuple[str, bytes, bytes, set[tuple[int, int]]]] = {}
                local_bgs: dict[str, tuple[str, bytes]] = {}
                map_pending: list[dict[str, Any]] = []

                for row in sorted(ground_rows, key=lambda r: r["ground"].casefold()):
                    if row["ground"] not in names:
                        raise ValueError(f"Ground absent de {archive_path}: {row['ground']}")
                    raw = archive.read(row["ground"])
                    if hashlib.sha256(raw).hexdigest() != row["sha256"]:
                        raise ValueError(f"Ground SHA différent du registre: {row['ground']}")
                    document = json.loads(raw)
                    if document.get("Version") != GAME_VERSION:
                        raise ValueError(f"Version Ground non 0.8.12: {row['ground']}")
                    obj = document.get("Object", {})
                    entry_alias = apply_source_entry_alias(row, obj)
                    source_comment = str(obj.get("Comment", ""))
                    source_text_normalized = (
                        "halcyon" in source_comment.casefold()
                        or any("halcyon" in str(layer.get("Name", "")).casefold()
                               for layer in obj.get("Layers", []) or [])
                    )
                    review_reasons: list[str] = []
                    if re.search(r"(?i)collisions?[^.]{0,80}(?:à vérifier|a verifier|à contrôler|a controler|review)", source_comment):
                        review_reasons.append("La note source demande une vérification des collisions.")
                    if re.search(r"(?i)(?:choisi|choisies|choisie)[^.]{0,80}par l['’ ]agent", source_comment):
                        review_reasons.append("La note source indique un choix de conception généré à confirmer.")
                    if obj.get("$type") != "RogueEssence.Ground.GroundMap, RogueEssence":
                        raise ValueError(f"Type GroundMap natif absent: {row['ground']}")
                    width, height, blocked, walkable, reached = collision_stats(obj)
                    exit_markers = explicit_exit_markers(obj, walkable, reached)
                    if any(not marker["walkable"] or not marker["reachableFromEntry"]
                           for marker in exit_markers):
                        review_reasons.append(
                            "Au moins un marker de sortie explicitement nommé est bloqué ou inatteignable; "
                            "sa position source est conservée sans transition ajoutée."
                        )
                    tile_refs, bg_refs = frame_references(obj)
                    source_asset = str(obj.get("AssetName", ""))
                    if not source_asset:
                        raise ValueError(f"AssetName absent: {row['ground']}")
                    starts = [m for e in obj.get("Entities", []) or []
                              for m in e.get("Markers", []) or []
                              if str(m.get("EntName", "")).casefold() == "entrance"]
                    markers = [m for e in obj.get("Entities", []) or []
                               for m in e.get("Markers", []) or []]
                    has_exit = bool(exit_markers)
                    if not starts:
                        raise ValueError(f"Marker entrance absent malgré filtre: {row['ground']}")
                    if obj.get("Music"):
                        raise ValueError(f"Musique non empaquetée: {row['ground']}")

                    actual_tiles: dict[str, tuple[str, bytes, bytes, set[tuple[int, int]]]] = {}
                    for reference in sorted(tile_refs):
                        tile_path = find_resource(names, mod_root, "Content/Tile", reference, ".tile")
                        tile_stem = PurePosixPath(tile_path).stem
                        tile_bytes = archive.read(tile_path)
                        node, coords = tile_header_and_coords(tile_bytes, tile_stem)
                        index_name = next((name for name in source_index
                                           if name.casefold() == tile_stem.casefold()), None)
                        if index_name is None or source_index[index_name] != node:
                            raise ValueError(f"index.idx source incohérent pour {tile_path}")
                        local_key = tile_stem.casefold()
                        if local_key in local_tiles and local_tiles[local_key][1] != tile_bytes:
                            raise ValueError(f"Tileset conflictuel dans la même archive: {tile_stem}")
                        local_tiles[local_key] = (tile_stem, tile_bytes, node, coords)
                        actual_tiles[reference] = (tile_stem, tile_bytes, node, coords)
                        for layer in obj.get("Layers", []) or []:
                            for column in layer.get("Tiles", []) or []:
                                for cell in column or []:
                                    for animation in cell.get("Layers", []) or []:
                                        for frame in animation.get("Frames", []) or []:
                                            if frame.get("Sheet") == reference:
                                                loc = frame.get("TexLoc", {})
                                                if (int(loc.get("X", -1)), int(loc.get("Y", -1))) not in coords:
                                                    raise ValueError(f"Tile {reference} non indexée: {row['ground']}")
                    for reference in sorted(bg_refs):
                        bg_path = find_resource(names, mod_root, "Content/BG", reference, ".dir")
                        bg_stem = PurePosixPath(bg_path).stem
                        bg_bytes = archive.read(bg_path)
                        bg_key = bg_stem.casefold()
                        prior = local_bgs.get(bg_key)
                        if prior and prior[1] != bg_bytes:
                            raise ValueError(f"Fond conflictuel dans l’archive: {bg_stem}")
                        local_bgs[bg_key] = (bg_stem, bg_bytes)

                    source_hash = hashlib.sha256(raw).hexdigest()
                    seed = hashlib.sha1(
                        f"{blob.sha}:{row['ground']}:{source_hash}".encode("utf-8")
                    ).hexdigest()[:10]
                    map_alias = f"d_{blob.sha[:8]}_{seed}_{safe_slug(source_asset, 22)}"
                    suffix = 1
                    unique_alias = map_alias
                    while unique_alias.casefold() in used_aliases:
                        suffix += 1
                        unique_alias = f"{map_alias}_{suffix}"
                    used_aliases.add(unique_alias.casefold())
                    obj["AssetName"] = unique_alias
                    for layer in obj.get("Layers", []) or []:
                        for column in layer.get("Tiles", []) or []:
                            for cell in column or []:
                                for animation in cell.get("Layers", []) or []:
                                    for frame in animation.get("Frames", []) or []:
                                        sheet = frame.get("Sheet")
                                        if sheet:
                                            actual = actual_tiles.get(str(sheet))
                                            if actual and str(sheet) != actual[0]:
                                                frame["Sheet"] = actual[0]
                    for layer in obj.get("Background", {}).get("Layers", []) or []:
                        bg = layer.get("BG", {}) or {}
                        anim = bg.get("BGAnim", {}) or {}
                        ref = anim.get("AnimIndex")
                        if ref:
                            actual = next((v[0] for v in local_bgs.values()
                                           if v[0].casefold() == str(ref).casefold()), None)
                            if actual and str(ref) != actual:
                                anim["AnimIndex"] = actual
                    script = script_for_map(archive, names, mod_root, source_asset)
                    document = normalize_source_labels(document)
                    obj = document["Object"]
                    ground_output = f"Data/Ground/{unique_alias}.rsground"
                    ground_bytes = json.dumps(document, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
                    stage_write(stage, files_meta, ground_output, ground_bytes)
                    stage_write(stage, files_meta,
                                f"Data/Script/{NAMESPACE}/ground/{unique_alias}/init.lua", script)
                    map_pending.append({
                        "mapId": unique_alias,
                        "name": (obj.get("Name", {}) or {}).get("DefaultText", source_asset),
                        "sourceAssetName": source_asset,
                        "groundFile": ground_output,
                        "sourceGroundPath": row["ground"],
                        "sourceGroundSha256": source_hash,
                        "outputGroundSha256": hashlib.sha256(ground_bytes).hexdigest(),
                        "sourceArchive": archive_path,
                        "sourceArchiveRepo": source_repo,
                        "sourceArchiveCommit": source_commit,
                        "sourceArchiveBlob": blob.sha,
                        "sourceAuthor": source_author,
                        "sourceModName": source_mod_name,
                        "sourceNamespace": source_namespace,
                        "version": GAME_VERSION,
                        "grid": [width, height],
                        "layers": len(obj.get("Layers", []) or []),
                        "markerNames": [str(m.get("EntName", "")) for m in markers],
                        "sourceEntryMarkerAlias": entry_alias,
                        "explicitExitMarkers": exit_markers,
                        "hasExplicitExitMarker": has_exit,
                        "playabilityReviewRequired": bool(review_reasons),
                        "playabilityReviewReasons": review_reasons,
                        "sourceTextNormalized": source_text_normalized,
                        "blockedCells": blocked,
                        "walkableCells": len(walkable),
                        "entryConnectedCells": len(reached),
                        "tileRefs": sorted(tile_refs),
                        "backgroundRefs": sorted(bg_refs),
                        "scriptSha256": hashlib.sha256(script).hexdigest(),
                    })

                for stem_folded, (stem, data, node, coords) in local_tiles.items():
                    prior_name = tile_case.get(stem_folded)
                    if prior_name and prior_name != stem:
                        raise ValueError(f"Tileset en conflit de casse: {prior_name} / {stem}")
                    tile_case[stem_folded] = stem
                    digest = hashlib.sha256(data).hexdigest()
                    previous = tile_hashes.get(stem)
                    if previous and previous != digest:
                        raise ValueError(f"Même nom de tileset, contenu différent: {stem}")
                    tile_hashes[stem] = digest
                    existing_node = tile_nodes.get(stem)
                    if existing_node and existing_node != node:
                        raise ValueError(f"Nœud d’index différent pour tileset partagé: {stem}")
                    tile_nodes[stem] = node
                    stage_write(stage, files_meta, f"Content/Tile/{stem}.tile", data)
                for stem_folded, (stem, data) in local_bgs.items():
                    prior_name = bg_case.get(stem_folded)
                    if prior_name and prior_name != stem:
                        raise ValueError(f"Fond en conflit de casse: {prior_name} / {stem}")
                    bg_case[stem_folded] = stem
                    digest = hashlib.sha256(data).hexdigest()
                    previous = bg_hashes.get(stem)
                    if previous and previous != digest:
                        raise ValueError(f"Même nom de fond, contenu différent: {stem}")
                    bg_hashes[stem] = digest
                    stage_write(stage, files_meta, f"Content/BG/{stem}.dir", data)

                readme_path = next((name for name in names
                                    if PurePosixPath(name).name.casefold() == "readme.md"), None)
                if readme_path:
                    doc = archive.read(readme_path)
                    doc_name = f"Documentation/Sources/{blob.sha[:12]}.md"
                    prefix = f"<!-- {source_repo}@{source_commit}:{archive_path} -->\n\n".encode("utf-8")
                    if re.search(rb"halcyon", doc, re.IGNORECASE):
                        source_readme_attributions_not_mirrored.append({
                            "archive": archive_path,
                            "repository": source_repo,
                            "commit": source_commit,
                            "readmePath": readme_path,
                            "reason": "La notice originale n’est pas recopiée; provenance et attribution restent accessibles via le lien source.",
                        })
                        doc = (
                            "# Notice source non reproduite\n\n"
                            "La notice originale de cette archive n’est pas dupliquée dans le mod assemblé. "
                            "La provenance, l’auteur et le commit source restent consignés dans `../../CREDITS.md` "
                            "et `../../manifest.json`.\n"
                        ).encode("utf-8")
                    archive_readmes[doc_name] = prefix + doc
                records.extend(map_pending)
            if group_number % 15 == 0:
                print(f"archives assemblées {group_number}/{len(groups)} — Ground {len(records)}/{len(maps)}")

        for doc_name, data in archive_readmes.items():
            stage_write(stage, files_meta, doc_name, data)
        stage_write(stage, files_meta, "Content/Tile/index.idx", encode_index(tile_nodes))
        stage_write(stage, files_meta, "Mod.xml", output_mod_xml())
        records.sort(key=lambda row: (row["sourceArchiveRepo"], row["sourceArchive"].casefold(), row["sourceGroundPath"].casefold()))
        stage_write(stage, files_meta, "README.md", make_readme(records, len(tile_nodes), len(bg_hashes)))
        stage_write(stage, files_meta, "CREDITS.md", make_credits(records))
        manifest = {
            "name": NAME,
            "namespace": NAMESPACE,
            "gameVersion": GAME_VERSION,
            "mapCount": len(records),
            "uniqueGroundContentCount": len({r["sourceGroundSha256"] for r in records}),
            "sourceArchiveCount": len(groups),
            "tileCount": len(tile_nodes),
            "backgroundCount": len(bg_hashes),
            "sourceReadmesWithExternalAttributionsNotMirrored": source_readme_attributions_not_mirrored,
            "manualExtraMapAdmissions": [
                {"sourceArchive": key[0], "sourceGroundPath": key[1], "sourceGroundSha256": key[2], "reason": reason}
                for key, reason in MANUAL_EXTRA_GROUNDS.items()
            ],
            "exitMarkerAudit": {
                "mapsWithExplicitExitMarker": sum(bool(row["explicitExitMarkers"]) for row in records),
                "markerCount": sum(len(row["explicitExitMarkers"]) for row in records),
                "blockedOrUnreachableMarkerCount": sum(
                    not marker["walkable"] or not marker["reachableFromEntry"]
                    for row in records for marker in row["explicitExitMarkers"]
                ),
            },
            "playabilityStatus": "native-load-tested candidates; visual collisions and gameplay navigation not certified",
            "validation": {
                "groundJson": True,
                "nativeTileHeaders": True,
                "sourceIndexesMatched": True,
                "tileCoordinatesResolved": True,
                "backgroundReferencesResolved": True,
                "entryWalkable": True,
                "entryAliasSameCollider": True,
                "explicitExitMarkersAuditedForWalkabilityAndConnectivity": True,
                "sourceCollisionMasksPreserved": True,
                "collisionVisualAgreementTested": False,
                "playerSpawnTested": False,
                "navigationGameplayTested": False,
                "runtimePMDOTested": False,
                "graphicsRenderingTested": False,
                "warpsOrStoryAdded": False,
            },
            "maps": records,
            "files": files_meta,
        }
        stage_write(stage, files_meta, "manifest.json", (json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))

        temp_output = output.with_suffix(output.suffix + ".tmp")
        try:
            with zipfile.ZipFile(temp_output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9, allowZip64=True) as package:
                paths = sorted(p for p in stage.rglob("*") if p.is_file())
                for path in paths:
                    relative = path.relative_to(stage).as_posix()
                    info = zipfile.ZipInfo(f"{NAMESPACE}/{relative}", date_time=(2026, 10, 29, 0, 0, 0))
                    info.compress_type = zipfile.ZIP_DEFLATED
                    info.external_attr = 0o644 << 16
                    with path.open("rb") as incoming, package.open(info, "w", force_zip64=True) as outgoing:
                        shutil.copyfileobj(incoming, outgoing, length=1024 * 1024)

            with zipfile.ZipFile(temp_output, "r") as package:
                if package.testzip():
                    raise ValueError("CRC ZIP produit invalide")
                final_maps = [name for name in package.namelist() if name.casefold().endswith(".rsground")]
                if len(final_maps) != len(records):
                    raise ValueError(f"Nombre de Ground final incorrect: {len(final_maps)} / {len(records)}")
                final_mod = ET.fromstring(package.read(f"{NAMESPACE}/Mod.xml"))
                if final_mod.findtext("Namespace") != NAMESPACE:
                    raise ValueError("Namespace final incorrect")
            temp_output.replace(output)
        finally:
            if temp_output.exists():
                temp_output.unlink()

    return {
        "output": str(output),
        "bytes": output.stat().st_size,
        "maps": len(records),
        "uniqueGroundContents": len({r["sourceGroundSha256"] for r in records}),
        "tilesets": len(tile_nodes),
        "backgrounds": len(bg_hashes),
        "sources": len({r["sourceArchive"] for r in records}),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    print(json.dumps(build(args.output), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
