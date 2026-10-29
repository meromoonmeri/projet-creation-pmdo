#!/usr/bin/env python3
"""Assemble a first, statically verified PMDO exploration-map batch.

The input archives are pinned to a single upstream commit. This builder does
not infer map geometry, collision, exits, or scripts: it packages only maps
whose native Ground data already contains an entrance-to-sortie walkable path.
It changes the script-directory namespace to ``destiny`` and rebuilds the tile
index from the included native .tile files; Ground/tile bytes are preserved.

Usage:
    python3 source/pmdo_cote/build_exploration_batch01.py
    python3 source/pmdo_cote/build_exploration_batch01.py --output /path/to/maps.zip
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import re
import struct
import sys
import uuid
import xml.etree.ElementTree as ET
import zipfile
from collections import deque
from pathlib import Path, PurePosixPath
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from source.serveur_apercus.serve import UpstreamRepository  # noqa: E402

SOURCE_REPOSITORY = "meromoonmeri/projet-pmdo"
SOURCE_COMMIT = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
OUTPUT_NAMESPACE = "destiny"
OUTPUT_NAME = "PMD Destiny — Cartes d’exploration · Lot 01"
GAME_VERSION = "0.8.12.0"
DEFAULT_OUTPUT = ROOT / "exports/pmdo/PMD_Destiny_Exploration_Lot01_0812.zip"

# These nine packages are the only archived Ground maps in the catalogue that
# passed the conservative static screen used for this batch: valid 0.8.12 JSON,
# entry and sortie markers on walkable cells, complete tile references, and a
# four-neighbour walkable path between entry and sortie. Source paths and map
# filenames are pinned so a later upstream update cannot silently change input.
SOURCES = [
    {
        "code": "RAZ1",
        "archive": "renders/zone_zero_v1/RAZ1/RAZ1_projet_pmdo_0812.zip",
        "blobSha": "205cd015e4214bdff6f371210e99edf7d041d801",
        "ground": "raz1_levre_cratere.rsground",
    },
    {
        "code": "RAZ2",
        "archive": "renders/zone_zero_v1/RAZ2/RAZ2_projet_pmdo_0812.zip",
        "blobSha": "27ab753f59cdaf72c80a57969d60067f10eb46e0",
        "ground": "raz2_terrasses_cascades.rsground",
    },
    {
        "code": "RAZ3",
        "archive": "renders/zone_zero_v1/RAZ3/RAZ3_projet_pmdo_0812.zip",
        "blobSha": "7d1a89bb5b38e9f8cd82c5bc1c3b39ca05ab8f5e",
        "ground": "raz3_fond_cristallin.rsground",
    },
    {
        "code": "EAF1",
        "archive": "renders/zone_zero_v2/EAF1/EAF1_projet_pmdo_0812.zip",
        "blobSha": "640d54589c86408270744a751a22358600d2ad9d",
        "ground": "eaf1_entree_zone_zero_fleurie.rsground",
    },
    {
        "code": "RAF1",
        "archive": "renders/zone_zero_v2/RAF1/RAF1_projet_pmdo_0812.zip",
        "blobSha": "2912c17e1fd03f7f1f95ce911a22d31c8b76fd52",
        "ground": "raf1_levre_cratere_fleurie.rsground",
    },
    {
        "code": "RAF2",
        "archive": "renders/zone_zero_v2/RAF2/RAF2_projet_pmdo_0812.zip",
        "blobSha": "7cb189fa470e7fbe181db38ccb722f1d0ded606e",
        "ground": "raf2_terrasses_fleuries.rsground",
    },
    {
        "code": "RAF3",
        "archive": "renders/zone_zero_v2/RAF3/RAF3_projet_pmdo_0812.zip",
        "blobSha": "0f685a94674f67c4933e1a3d8a81be533dce4d67",
        "ground": "raf3_fond_fleuri.rsground",
    },
    {
        "code": "CPL1",
        "archive": "renders/defile_aiguilles_v1/CPL1_projet_pmdo_0812.zip",
        "blobSha": "18baf4eb1aac0a18598982a09bd3933f2e625592",
        "ground": "cpl1_passage_aiguilles.rsground",
    },
    {
        "code": "PVC1",
        "archive": "renders/passage_veines_cristal_v1/PVC1_projet_pmdo_0812.zip",
        "blobSha": "8f8c85a3b2a988160bf6b55a82b6770fc1bc92ae",
        "ground": "pvc1_passage_veines_cristallines.rsground",
    },
]


def decode_index(data: bytes) -> dict[str, bytes]:
    """Read the native PMDO tile index, retaining each opaque index node."""
    if len(data) < 4:
        raise ValueError("index.idx tronqué")
    count = struct.unpack_from("<i", data, 0)[0]
    if not 0 <= count <= 100_000:
        raise ValueError(f"Nombre de tilesets invalide dans index.idx: {count}")
    nodes: dict[str, bytes] = {}
    pos = 4
    for _ in range(count):
        length = 0
        for shift in range(0, 35, 7):
            if pos >= len(data):
                raise ValueError("Chaîne .NET tronquée dans index.idx")
            byte = data[pos]
            pos += 1
            length |= (byte & 127) << shift
            if byte < 128:
                break
        else:
            raise ValueError("Longueur de chaîne .NET invalide dans index.idx")
        if pos + length + 8 > len(data):
            raise ValueError("Entrée index.idx tronquée")
        name = data[pos:pos + length].decode("utf-8")
        pos += length
        _, tiles = struct.unpack_from("<ii", data, pos)
        if tiles < 0 or tiles > 10_000_000:
            raise ValueError(f"Nombre de tuiles invalide pour {name}: {tiles}")
        node_size = 8 + tiles * 16
        if pos + node_size > len(data):
            raise ValueError(f"Entrée index.idx tronquée pour {name}")
        if name in nodes:
            raise ValueError(f"Tileset dupliqué dans index.idx: {name}")
        nodes[name] = data[pos:pos + node_size]
        pos += node_size
    if pos != len(data):
        raise ValueError("Données surnuméraires après index.idx")
    return nodes


def encode_index(nodes: dict[str, bytes]) -> bytes:
    """Write the native PMDO index format (7-bit .NET string lengths)."""
    result = bytearray(struct.pack("<i", len(nodes)))
    for name in sorted(nodes):
        raw = name.encode("utf-8")
        size = len(raw)
        while size >= 128:
            result.append((size & 127) | 128)
            size >>= 7
        result.append(size)
        result.extend(raw)
        result.extend(nodes[name])
    return bytes(result)


def tile_header_and_coords(data: bytes, name: str) -> tuple[bytes, set[tuple[int, int]]]:
    """Validate the tile directory and return its native index node/coordinates."""
    if len(data) < 8:
        raise ValueError(f"Tileset tronqué: {name}")
    tile_size, count = struct.unpack_from("<ii", data, 0)
    if tile_size != 8 or not 0 < count <= 10_000_000:
        raise ValueError(f"En-tête .tile invalide pour {name}: taille={tile_size}, nombre={count}")
    node_end = 8 + count * 16
    if node_end > len(data):
        raise ValueError(f"Table .tile tronquée: {name}")
    coords: set[tuple[int, int]] = set()
    for index in range(count):
        x, y, address = struct.unpack_from("<iiq", data, 8 + index * 16)
        if x < 0 or y < 0 or address < node_end or address + 8 > len(data):
            raise ValueError(f"Référence de tile invalide dans {name} à l'entrée {index}")
        image_bytes = struct.unpack_from("<q", data, address)[0]
        if image_bytes <= 0 or address + 8 + image_bytes > len(data):
            raise ValueError(f"Image de tile tronquée dans {name} à l'entrée {index}")
        if (x, y) in coords:
            raise ValueError(f"Coordonnée tile dupliquée dans {name}: {(x, y)}")
        coords.add((x, y))
    return data[:node_end], coords


def safe_relative(member: str, root: str) -> PurePosixPath:
    path = PurePosixPath(member)
    if path.is_absolute() or any(part in {"", ".", ".."} for part in path.parts):
        raise ValueError(f"Chemin ZIP dangereux: {member}")
    root_path = PurePosixPath(root) if root else PurePosixPath()
    try:
        return path.relative_to(root_path) if root else path
    except ValueError as exc:
        raise ValueError(f"Fichier hors racine du mod: {member}") from exc


def rebase_script_path(relative: PurePosixPath) -> PurePosixPath:
    parts = relative.parts
    if len(parts) < 3 or parts[:2] != ("Data", "Script"):
        raise ValueError(f"Chemin de script inattendu: {relative}")
    tail = parts[2:]
    if tail[0].casefold() == "ground":
        suffix = tail
    else:
        # Source projects keep Lua files under their own namespace directory.
        # Replace that directory only; do not rewrite Lua source text.
        suffix = tail[1:]
    if not suffix:
        raise ValueError(f"Script sans sous-chemin de données: {relative}")
    return PurePosixPath("Data", "Script", OUTPUT_NAMESPACE, *suffix)


def add_file(files: dict[str, bytes], path: PurePosixPath | str, data: bytes) -> None:
    name = str(path)
    if name.startswith("/") or ".." in PurePosixPath(name).parts:
        raise ValueError(f"Chemin de sortie dangereux: {name}")
    previous = files.get(name)
    if previous is not None and previous != data:
        raise ValueError(f"Conflit de fichiers pendant l’assemblage: {name}")
    files[name] = data


def marker_cell(marker: dict[str, Any]) -> tuple[int, int]:
    collider = marker.get("Collider", {})
    x = int(collider.get("X", -1))
    y = int(collider.get("Y", -1))
    width = int(collider.get("Width", 0))
    height = int(collider.get("Height", 0))
    if x < 0 or y < 0 or width <= 0 or height <= 0:
        raise ValueError(f"Collider de marker invalide: {marker.get('EntName')}")
    return ((x + width // 2) // 8, (y + height // 2) // 8)


def validate_ground(
    raw: bytes,
    file_name: str,
    tile_coords: dict[str, set[tuple[int, int]]],
    bg_names: set[str],
) -> dict[str, Any]:
    doc = json.loads(raw)
    if doc.get("Version") != GAME_VERSION:
        raise ValueError(f"{file_name}: Version {doc.get('Version')}, attendu {GAME_VERSION}")
    obj = doc.get("Object", {})
    if obj.get("$type") != "RogueEssence.Ground.GroundMap, RogueEssence":
        raise ValueError(f"{file_name}: type GroundMap natif absent")
    obstacles = obj.get("obstacles")
    if not isinstance(obstacles, list) or not obstacles or not obstacles[0]:
        raise ValueError(f"{file_name}: grille de collisions vide")
    width = len(obstacles)
    height = len(obstacles[0])
    if any(not isinstance(col, list) or len(col) != height for col in obstacles):
        raise ValueError(f"{file_name}: grille de collisions irrégulière")
    for layer in obj.get("Layers", []):
        tiles = layer.get("Tiles", [])
        if len(tiles) != width or any(len(column) != height for column in tiles):
            raise ValueError(f"{file_name}: dimensions de calque incompatibles")
    tile_refs: set[str] = set()
    for layer in obj.get("Layers", []):
        for column in layer.get("Tiles", []):
            for cell in column:
                for animation in cell.get("Layers", []):
                    for frame in animation.get("Frames", []):
                        sheet = frame.get("Sheet")
                        if sheet:
                            tile_refs.add(str(sheet))
                            coords = tile_coords.get(str(sheet))
                            if coords is None:
                                raise ValueError(f"{file_name}: tileset absent: {sheet}")
                            loc = frame.get("TexLoc", {})
                            coord = (int(loc.get("X", -1)), int(loc.get("Y", -1)))
                            if coord not in coords:
                                raise ValueError(f"{file_name}: tile {sheet}{coord} absent")
    bg_refs: set[str] = set()
    background = obj.get("Background", {}) or {}
    for layer in background.get("Layers", []) or []:
        bg = layer.get("BG", {}) or {}
        anim = bg.get("BGAnim", {}) or {}
        name = anim.get("AnimIndex")
        if name:
            bg_refs.add(str(name))
            if str(name) not in bg_names:
                raise ValueError(f"{file_name}: fond absent: {name}")
    markers = [marker for entity in obj.get("Entities", []) or []
               for marker in entity.get("Markers", []) or []]
    by_name: dict[str, list[dict[str, Any]]] = {}
    for marker in markers:
        by_name.setdefault(str(marker.get("EntName", "")).casefold(), []).append(marker)
    entrances = by_name.get("entrance", [])
    exits = by_name.get("sortie", []) or by_name.get("exit", [])
    if not entrances or not exits:
        raise ValueError(f"{file_name}: marker entrance/sortie absent")
    walkable: set[tuple[int, int]] = set()
    for x, column in enumerate(obstacles):
        for y, wall in enumerate(column):
            if int(wall.get("Tags", 0)) == 0:
                walkable.add((x, y))
    starts = {marker_cell(marker) for marker in entrances}
    targets = {marker_cell(marker) for marker in exits}
    if not starts <= walkable:
        raise ValueError(f"{file_name}: entrée hors grille ou bloquée: {sorted(starts - walkable)}")
    if not targets <= walkable:
        raise ValueError(f"{file_name}: sortie hors grille ou bloquée: {sorted(targets - walkable)}")
    reached = set(starts)
    queue = deque(starts)
    while queue:
        x, y = queue.popleft()
        for neighbor in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if neighbor in walkable and neighbor not in reached:
                reached.add(neighbor)
                queue.append(neighbor)
    inaccessible = targets - reached
    if inaccessible:
        raise ValueError(f"{file_name}: sortie(s) non joignable(s): {sorted(inaccessible)}")
    return {
        "name": (obj.get("Name", {}) or {}).get("DefaultText", file_name),
        "assetName": obj.get("AssetName", ""),
        "version": doc["Version"],
        "grid": [width, height],
        "pixels": [width * 8, height * 8],
        "layerCount": len(obj.get("Layers", [])),
        "markers": [str(marker.get("EntName", "")) for marker in markers],
        "walkableCells": len(walkable),
        "entryToSortieReachable": True,
        "tileRefs": sorted(tile_refs),
        "backgroundRefs": sorted(bg_refs),
        "sha256": hashlib.sha256(raw).hexdigest(),
    }


def load_source_archive(repo: UpstreamRepository, source: dict[str, str]) -> tuple[Any, bytes]:
    archive_path = source["archive"]
    matches = [blob for blob in repo.archive_by_id.values()
               if blob.path == archive_path
               and blob.source_repo == SOURCE_REPOSITORY
               and blob.sha == source["blobSha"]]
    if len(matches) != 1:
        raise ValueError(f"Source épinglée absente ou ambiguë: {archive_path} ({len(matches)} résultat(s))")
    blob = matches[0]
    if not blob.path.casefold().endswith(".zip"):
        raise ValueError(f"Archive source non ZIP: {archive_path}")
    return blob, repo.get_blob(blob)


def mod_xml() -> bytes:
    header = ET.Element("Header")
    ET.SubElement(header, "Name").text = OUTPUT_NAME
    ET.SubElement(header, "Author").text = "PMD Destiny (assemblage)"
    ET.SubElement(header, "Description").text = (
        "Lot 01 de cartes d’exploration PMDO 0.8.12. Les Ground natifs et leurs "
        "ressources sont conservés; voir README.md et CREDITS.md. Les transitions "
        "de quête ne sont pas ajoutées dans ce lot."
    )
    ET.SubElement(header, "Namespace").text = OUTPUT_NAMESPACE
    stable_id = uuid.uuid5(
        uuid.NAMESPACE_URL,
        f"https://github.com/{SOURCE_REPOSITORY}/tree/{SOURCE_COMMIT}/destiny-exploration-batch-01",
    )
    ET.SubElement(header, "UUID").text = str(stable_id)
    ET.SubElement(header, "Version").text = "1.0.0.0"
    ET.SubElement(header, "GameVersion").text = GAME_VERSION
    ET.SubElement(header, "ModType").text = "Quest"
    ET.SubElement(header, "Relationships")
    return ET.tostring(header, encoding="utf-8", xml_declaration=True) + b"\n"


def documentation(records: list[dict[str, Any]]) -> tuple[bytes, bytes]:
    rows = [
        "# PMD Destiny — cartes d’exploration, lot 01",
        "",
        "Mod PMDO 0.8.12 contenant neuf cartes Ground natives, rassemblées sous le namespace technique `destiny`.",
        "",
        "## Cartes incluses",
        "",
        "| Code | Carte | Grille | Entrée → sortie | Cellules marchables |",
        "|---|---|---:|---|---:|",
    ]
    for record in records:
        rows.append(
            f"| {record['code']} | {record['name']} | "
            f"{record['grid'][0]}×{record['grid'][1]} | chemin vérifié | {record['walkableCells']} |"
        )
    rows += [
        "",
        "## Installation et limites",
        "",
        "1. Fermer PMDO et extraire le dossier `destiny` dans `PMDO/MODS/`.",
        "2. Activer `PMD Destiny — Cartes d’exploration · Lot 01` dans PMDO.",
        "3. Ouvrir les fichiers de `Data/Ground/` dans l’éditeur Ground, ou les charger depuis une quête.",
        "",
        "Les contrôles statiques confirment un marker `entrance`, un marker `sortie`/`exit`, "
        "des tilesets résolus et un chemin orthogonal praticable entre les deux dans chaque grille de collisions. "
        "Les fichiers Ground et `.tile` sont copiés sans retouche; les collisions n’ont pas été inventées.",
        "",
        "**Ce lot n’ajoute pas de warp, d’événement narratif, de PNJ ni d’ennemis.** Les README sources décrivent "
        "ces cartes comme des bases d’édition sans warp automatique; les raccords vers TOWN02 restent une étape "
        "d’intégration distincte. Le jeu PMDO n’a pas été lancé dans cet environnement: la validation est statique, "
        "pas un test runtime.",
        "",
        "Les README d’origine sont conservés dans `Documentation/Sources/`. Les attributions et chemins source "
        "complets sont dans `CREDITS.md` et `manifest.json`.",
        "",
    ]
    readme = "\n".join(rows).encode("utf-8")

    credits = [
        "# Provenance et crédits — lot 01",
        "",
        f"Sources épinglées dans `{SOURCE_REPOSITORY}` au commit `{SOURCE_COMMIT}`.",
        "Les Ground et les banques `.tile` inclus sont repris byte pour byte; aucun crédit source n’a été retiré.",
        "Le namespace `destiny` désigne uniquement l’assemblage PMD Destiny; les namespaces techniques d’origine sont consignés ci-dessous.",
        "",
        "| Code | Auteur source | Mod / namespace source | Archive source |",
        "|---|---|---|---|",
    ]
    for record in records:
        credits.append(
            f"| {record['code']} | {record['sourceAuthor']} | "
            f"{record['sourceModName']} / `{record['sourceNamespace']}` | "
            f"[`{record['sourceArchive']}`](https://github.com/{SOURCE_REPOSITORY}/blob/{SOURCE_COMMIT}/{record['sourceArchive']}) |"
        )
    credits += [
        "",
        "Les README de chaque projet, y compris leurs notes de conception, sont archivés dans `Documentation/Sources/`.",
        "",
    ]
    return readme, "\n".join(credits).encode("utf-8")


def build(output: Path) -> dict[str, Any]:
    repo = UpstreamRepository()
    if repo.commit != SOURCE_COMMIT:
        raise ValueError(f"Catalogue source inattendu: {repo.commit} != {SOURCE_COMMIT}")
    files: dict[str, bytes] = {}
    tile_data: dict[str, bytes] = {}
    tile_nodes: dict[str, bytes] = {}
    tile_coords: dict[str, set[tuple[int, int]]] = {}
    records: list[dict[str, Any]] = []
    seen_ground_names: set[str] = set()
    seen_assets: set[str] = set()

    for source in SOURCES:
        blob, archive_bytes = load_source_archive(repo, source)
        try:
            archive = zipfile.ZipFile(io.BytesIO(archive_bytes))
        except zipfile.BadZipFile as exc:
            raise ValueError(f"Archive source corrompue: {source['archive']}") from exc
        with archive:
            bad_member = archive.testzip()
            if bad_member:
                raise ValueError(f"CRC ZIP invalide dans {source['archive']}: {bad_member}")
            members = [name for name in archive.namelist() if not name.endswith("/")]
            mod_paths = [name for name in members if PurePosixPath(name).name == "Mod.xml"]
            if len(mod_paths) != 1:
                raise ValueError(f"Mod.xml absent ou ambigu dans {source['archive']}")
            mod_path = PurePosixPath(mod_paths[0])
            mod_root = str(mod_path.parent) if str(mod_path.parent) != "." else ""
            try:
                source_mod = ET.fromstring(archive.read(mod_paths[0]))
            except ET.ParseError as exc:
                raise ValueError(f"Mod.xml invalide dans {source['archive']}") from exc
            source_namespace = source_mod.findtext("Namespace") or ""
            source_mod_name = source_mod.findtext("Name") or source["code"]
            source_author = source_mod.findtext("Author") or "Non spécifié"
            if source_mod.findtext("GameVersion") != GAME_VERSION:
                raise ValueError(f"{source['archive']}: GameVersion source différent de {GAME_VERSION}")

            source_index_paths = [
                name for name in members
                if safe_relative(name, mod_root).as_posix().casefold() == "content/tile/index.idx"
            ]
            if len(source_index_paths) != 1:
                raise ValueError(f"index.idx absent ou ambigu dans {source['archive']}")
            source_index = decode_index(archive.read(source_index_paths[0]))
            ground_paths = [
                name for name in members
                if safe_relative(name, mod_root).parts[:2] == ("Data", "Ground")
                and name.casefold().endswith(".rsground")
            ]
            wanted = [name for name in ground_paths if PurePosixPath(name).name == source["ground"]]
            if len(wanted) != 1 or len(ground_paths) != 1:
                raise ValueError(
                    f"{source['archive']}: Ground attendu {source['ground']}, "
                    f"trouvés {[PurePosixPath(p).name for p in ground_paths]}"
                )

            local_tiles: dict[str, bytes] = {}
            local_nodes: dict[str, bytes] = {}
            local_coords: dict[str, set[tuple[int, int]]] = {}
            local_bg_names: set[str] = set()
            for name in members:
                relative = safe_relative(name, mod_root)
                lower = relative.as_posix().casefold()
                if lower.startswith("content/tile/") and lower.endswith(".tile"):
                    raw = archive.read(name)
                    stem = PurePosixPath(name).stem
                    node, coords = tile_header_and_coords(raw, stem)
                    if stem not in source_index or source_index[stem] != node:
                        raise ValueError(f"{source['archive']}: index.idx ne correspond pas à {stem}.tile")
                    if stem in local_tiles and local_tiles[stem] != raw:
                        raise ValueError(f"{source['archive']}: tileset dupliqué: {stem}")
                    local_tiles[stem] = raw
                    local_nodes[stem] = node
                    local_coords[stem] = coords
                elif lower.startswith("content/bg/") and lower.endswith(".dir"):
                    local_bg_names.add(PurePosixPath(name).stem)

            for stem, raw in local_tiles.items():
                if stem in tile_data and tile_data[stem] != raw:
                    raise ValueError(f"Collision de nom de tileset entre les sources: {stem}")
                tile_data[stem] = raw
                tile_nodes[stem] = local_nodes[stem]
                tile_coords[stem] = local_coords[stem]

            for name in members:
                relative = safe_relative(name, mod_root)
                rel_text = relative.as_posix()
                lower = rel_text.casefold()
                if lower == "content/tile/index.idx":
                    continue
                if relative.parts[0] in {"Content", "Data"}:
                    if lower.startswith("content/tile/") and lower.endswith(".tile"):
                        out_rel = relative
                    elif relative.parts[:2] == ("Data", "Script"):
                        out_rel = rebase_script_path(relative)
                        script = archive.read(name)
                        if re.search(rb"\b(?:require|dofile)\s*\(", script):
                            raise ValueError(f"{source['archive']}: dépendance Lua à migrer manuellement ({name})")
                        add_file(files, out_rel, script)
                        continue
                    else:
                        out_rel = relative
                    add_file(files, out_rel, archive.read(name))
                elif PurePosixPath(name).name.casefold() == "readme.md":
                    source_readme = archive.read(name)
                    doc_path = PurePosixPath("Documentation", "Sources", f"{source['code']}.md")
                    preface = (
                        f"<!-- Copié de {SOURCE_REPOSITORY}@{SOURCE_COMMIT}:{source['archive']} -->\n\n"
                    ).encode("utf-8")
                    add_file(files, doc_path, preface + source_readme)

            ground_raw = archive.read(wanted[0])
            ground_doc = json.loads(ground_raw)
            ground_obj = ground_doc["Object"]
            ground_rel = safe_relative(wanted[0], mod_root)
            ground_basename = PurePosixPath(wanted[0]).name
            asset = str(ground_obj.get("AssetName", ""))
            if not asset or asset.casefold() in seen_assets:
                raise ValueError(f"AssetName absent ou dupliqué dans {source['archive']}: {asset!r}")
            if ground_basename.casefold() in seen_ground_names:
                raise ValueError(f"Nom de Ground dupliqué: {ground_basename}")
            seen_assets.add(asset.casefold())
            seen_ground_names.add(ground_basename.casefold())
            map_report = validate_ground(ground_raw, ground_basename, local_coords, local_bg_names)
            add_file(files, ground_rel, ground_raw)

            records.append({
                "code": source["code"],
                "sourceArchive": source["archive"],
                "sourceArchiveGitBlob": blob.sha,
                "sourceFileCommit": blob.commit,
                "sourceTreeCommit": SOURCE_COMMIT,
                "sourceAuthor": source_author,
                "sourceModName": source_mod_name,
                "sourceNamespace": source_namespace,
                "groundFile": ground_rel.as_posix(),
                **map_report,
            })

    if not records or len(records) != len(SOURCES):
        raise ValueError(f"Lot incomplet: {len(records)} / {len(SOURCES)} cartes")
    missing_from_manifest = set().union(*(set(record["tileRefs"]) for record in records)) - set(tile_data)
    if missing_from_manifest:
        raise ValueError(f"Tilesets référencés non assemblés: {sorted(missing_from_manifest)}")

    add_file(files, "Content/Tile/index.idx", encode_index(tile_nodes))
    add_file(files, "Mod.xml", mod_xml())
    readme, credits = documentation(records)
    add_file(files, "README.md", readme)
    add_file(files, "CREDITS.md", credits)
    manifest = {
        "name": OUTPUT_NAME,
        "namespace": OUTPUT_NAMESPACE,
        "gameVersion": GAME_VERSION,
        "sourceRepository": SOURCE_REPOSITORY,
        "sourceCommit": SOURCE_COMMIT,
        "mapCount": len(records),
        "validation": {
            "groundJson": True,
            "nativeTileHeaders": True,
            "sourceTileIndexesMatched": True,
            "tileCoordinatesResolved": True,
            "entranceToSortieReachable": True,
            "runtimePMDOTested": False,
            "warpsOrStoryAdded": False,
            "geometryOrCollisionsEdited": False,
        },
        "maps": records,
        "files": {
            path: hashlib.sha256(data).hexdigest()
            for path, data in sorted(files.items())
        },
    }
    add_file(files, "manifest.json", (json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))

    output = output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    temp_path = output.with_suffix(output.suffix + ".tmp")
    try:
        with zipfile.ZipFile(temp_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as result:
            for relative, data in sorted(files.items()):
                zip_info = zipfile.ZipInfo(f"{OUTPUT_NAMESPACE}/{relative}", date_time=(2026, 10, 29, 0, 0, 0))
                zip_info.compress_type = zipfile.ZIP_DEFLATED
                zip_info.external_attr = 0o644 << 16
                result.writestr(zip_info, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        with zipfile.ZipFile(temp_path, "r") as result:
            bad_member = result.testzip()
            if bad_member:
                raise ValueError(f"CRC invalide dans le package produit: {bad_member}")
            names = set(result.namelist())
            if f"{OUTPUT_NAMESPACE}/Mod.xml" not in names:
                raise ValueError("Mod.xml absent du package produit")
            final_maps = [name for name in names if name.casefold().endswith(".rsground")]
            if len(final_maps) != len(SOURCES):
                raise ValueError(f"Nombre de Ground inattendu dans le package final: {len(final_maps)}")
        temp_path.replace(output)
    finally:
        if temp_path.exists():
            temp_path.unlink()

    return {
        "output": str(output),
        "bytes": output.stat().st_size,
        "maps": len(records),
        "tilesets": len(tile_data),
        "groundFiles": [record["groundFile"] for record in records],
        "runtimePMDOTested": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    try:
        print(json.dumps(build(args.output), ensure_ascii=False, indent=2))
    except (OSError, ValueError, zipfile.BadZipFile, json.JSONDecodeError, ET.ParseError) as exc:
        parser.exit(1, f"Assemblage arrêté sans package final: {exc}\n")


if __name__ == "__main__":
    main()
