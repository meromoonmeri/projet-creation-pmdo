#!/usr/bin/env python3
"""Reconstruct five zero-grid Grounds from their pinned source map-sheet data.

The source exports contain full 96x72 collision grids, source-authored markers,
map-cell coordinates, animation frames, and atlas PNGs, but their serialized
GroundMap layer grids are empty. This converter translates those exact source
coordinates into native RogueEssence TileSheet assets and fills GroundMap.Tiles.
It does not infer geometry or alter collisions, entities, markers, exits, or warps.

The source files are read-only inputs extracted from the Arena branch commit
pinned below. Output is a temporary mod payload (Data/Ground + Content/Tile),
not a second PMDO quest; the Destiny overlay builder/installer must merge it into
the existing Quest without replacing Mod.xml or narrative zones.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import os
from pathlib import Path
import shutil
import struct
import tempfile
from collections import Counter, deque
from typing import Any

try:
    from PIL import Image
except ImportError as exc:  # pragma: no cover - depends on caller's Python env
    raise SystemExit("Pillow est requis; lancer avec l'environnement Python du dépôt.") from exc

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_SOURCE = ROOT / ".cache/destiny-recovery/empty_ground_audit/exports"
DEFAULT_OUTPUT = ROOT / ".cache/destiny-recovery/empty_ground_reconstructed_native"
SOURCE_REPOSITORY = "meromoonmeri/projet-creation-pmdo"
SOURCE_REF = "arena/52e6a9de-projet-creation-pmdo"
SOURCE_COMMIT = "c2d77959d87bf334e9603b47df012bc4f1e3dd7a"
TILE_SIZE = 8

MAPS = (
    {
        "entryId": "branch_012",
        "sourceDir": "entree_falaise_trempee_sud_nord_v1",
        "sourceGroundSha256": "91e2fb0c0e84e9189f155503929e8e2a1a2830de1e3860c11278ccdacd038f2f",
        "mapId": "d262_b012_91e2fb0c_entree_falaise",
    },
    {
        "entryId": "branch_013",
        "sourceDir": "entree_promontoire_nuages_sud_nord_v1",
        "sourceGroundSha256": "e96b022dc6c6fa3f059859a65b166eb5788d3101eb1e6069887231ab0a96cc33",
        "mapId": "d262_b013_e96b022d_entree_promontoire",
    },
    {
        "entryId": "branch_014",
        "sourceDir": "entree_tourbiere_piliers_sud_nord_v1",
        "sourceGroundSha256": "55e3e643ade4dc02f9c922fc222775d5e897ff362d75571019c6d0206c2997bb",
        "mapId": "d262_b014_55e3e643_entree_tourbiere",
    },
    {
        "entryId": "branch_015",
        "sourceDir": "fin_falaise_trempee_source_v1",
        "sourceGroundSha256": "46cbbfc03e4c3339274f76e5e52a31d4824def561649f9814dfadff9c3a3d1c3",
        "mapId": "d262_b015_46cbbfc0_fin_falaise",
    },
    {
        "entryId": "branch_016",
        "sourceDir": "fin_promontoire_nuages_clairiere_v1",
        "sourceGroundSha256": "698d2ab0bbdb45f31f72c3650a3219ddf8e56464f8a252fd8ac561667793f8ef",
        "mapId": "d262_b016_698d2ab0_fin_promontoire",
    },
)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def premultiply_alpha(image: Image.Image) -> Image.Image:
    raw = bytearray(image.convert("RGBA").tobytes())
    for pos in range(0, len(raw), 4):
        alpha = raw[pos + 3]
        raw[pos] = raw[pos] * alpha // 255
        raw[pos + 1] = raw[pos + 1] * alpha // 255
        raw[pos + 2] = raw[pos + 2] * alpha // 255
    return Image.frombytes("RGBA", image.size, bytes(raw))


def encode_native_tile(source_path: Path, output_path: Path, sheet_name: str) -> dict[str, Any]:
    """Convert the source map-sheet wrapper to the native Content/Tile format.

    Source wrapper layout: <tileSize, mapWidth, mapHeight, frameCount,
    frameDuration>, map-cell atlas coordinates per frame, then one atlas PNG.
    Native RogueEssence layout: a TileIndexNode followed by embedded per-tile
    PNGs. Atlas coordinates are preserved; a transparent tile is added only
    where a source animation explicitly has blank frames between visible ones.
    """
    raw = source_path.read_bytes()
    if len(raw) < 28:
        raise ValueError(f".tile source tronqué : {source_path}")
    tile_size, width, height, frame_count, frame_duration = struct.unpack_from("<iiiii", raw, 0)
    if tile_size != TILE_SIZE or width != 96 or height != 72:
        raise ValueError(f"Dimensions source .tile inattendues : {source_path} {(tile_size, width, height)}")
    if frame_count <= 0 or frame_duration <= 0:
        raise ValueError(f"Animation source invalide : {source_path}")

    cell_count = width * height
    pos = 20
    source_frames: list[list[tuple[int, int] | None]] = []
    for _ in range(frame_count):
        frame: list[tuple[int, int] | None] = []
        for cell in range(cell_count):
            x, y = struct.unpack_from("<ii", raw, pos + cell * 8)
            if (x, y) == (-1, -1):
                frame.append(None)
            elif x >= 0 and y >= 0:
                frame.append((x, y))
            else:
                raise ValueError(f"Coordonnée partielle invalide dans {source_path}: {(x, y)}")
        source_frames.append(frame)
        pos += cell_count * 8
    atlas_count, png_bytes = struct.unpack_from("<ii", raw, pos)
    pos += 8
    if atlas_count != 1 or png_bytes <= 0 or pos + png_bytes != len(raw):
        raise ValueError(f"Atlas source invalide ou tronqué : {source_path}")
    atlas = Image.open(io.BytesIO(raw[pos:pos + png_bytes])).convert("RGBA")
    if atlas.width % TILE_SIZE or atlas.height % TILE_SIZE:
        raise ValueError(f"Atlas non divisible par {TILE_SIZE} : {source_path}")

    used = sorted(
        {coord for frame in source_frames for coord in frame if coord is not None},
        key=lambda coord: (coord[1], coord[0]),
    )
    if not used:
        raise ValueError(f"Tilesheet source sans tuiles : {source_path}")
    for x, y in used:
        if x * TILE_SIZE + TILE_SIZE > atlas.width or y * TILE_SIZE + TILE_SIZE > atlas.height:
            raise ValueError(f"Coordonnée hors atlas dans {source_path}: {(x, y)}")

    mixed_blank = any(
        any(frame[i] is not None for frame in source_frames)
        and any(frame[i] is None for frame in source_frames)
        for i in range(cell_count)
    )
    transparent_coord: tuple[int, int] | None = None
    if mixed_blank:
        max_x = max(x for x, _ in used)
        max_y = max(y for _, y in used)
        transparent_coord = (max_x + 1, max_y) if max_x < 31 else (0, max_y + 1)
        if transparent_coord in used:
            raise ValueError(f"Coordonnée libre de transparence non trouvée : {source_path}")

    tiles: list[tuple[tuple[int, int], Image.Image]] = []
    for x, y in used:
        patch = atlas.crop((x * TILE_SIZE, y * TILE_SIZE, (x + 1) * TILE_SIZE, (y + 1) * TILE_SIZE))
        if patch.getchannel("A").getbbox() is None:
            raise ValueError(f"Coordonnée visible entièrement transparente : {source_path} {(x, y)}")
        tiles.append(((x, y), premultiply_alpha(patch)))
    if transparent_coord is not None:
        tiles.append((transparent_coord, Image.new("RGBA", (TILE_SIZE, TILE_SIZE), (0, 0, 0, 0))))

    entries: list[bytes] = []
    payload = bytearray()
    offsets_by_pixels: dict[bytes, int] = {}
    header_end = 8 + 16 * len(tiles)
    for (x, y), patch in tiles:
        pixels = patch.tobytes()
        offset = offsets_by_pixels.get(pixels)
        if offset is None:
            png = io.BytesIO()
            patch.save(png, format="PNG", compress_level=0)
            encoded = png.getvalue()
            offset = header_end + len(payload)
            offsets_by_pixels[pixels] = offset
            payload.extend(struct.pack("<q", len(encoded)))
            payload.extend(encoded)
        entries.append(struct.pack("<iiq", x, y, offset))
    native = struct.pack("<ii", TILE_SIZE, len(entries)) + b"".join(entries) + payload
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(native)
    return {
        "sourceFile": source_path.name,
        "sourceSha256": sha256(raw),
        "outputFile": f"Content/Tile/{output_path.name}",
        "outputSha256": sha256(native),
        "outputBytes": len(native),
        "sourceAssetName": source_path.stem,
        "outputAssetName": sheet_name,
        "grid": [width, height],
        "frameCount": frame_count,
        "frameDurationTicks": frame_duration,
        "atlasPixels": list(atlas.size),
        "nativeTileEntries": len(entries),
        "transparentFrameTileAdded": transparent_coord is not None,
        "_frames": source_frames,
        "_transparentCoord": transparent_coord,
        "_tileCoords": sorted(set(used) | ({transparent_coord} if transparent_coord else set())),
    }


def encode_index(nodes: dict[str, bytes]) -> bytes:
    def encode_string(text: str) -> bytes:
        raw = text.encode("utf-8")
        length = len(raw)
        prefix = bytearray()
        while length >= 128:
            prefix.append((length & 0x7F) | 0x80)
            length >>= 7
        prefix.append(length)
        return bytes(prefix) + raw
    return struct.pack("<i", len(nodes)) + b"".join(
        encode_string(name) + nodes[name] for name in sorted(nodes, key=str.casefold)
    )


def native_tile_coords(tile_path: Path) -> tuple[bytes, set[tuple[int, int]]]:
    data = tile_path.read_bytes()
    if len(data) < 8:
        raise ValueError(f"Tilesheet native trop court : {tile_path}")
    tile_size, count = struct.unpack_from("<ii", data, 0)
    if tile_size != TILE_SIZE or count <= 0:
        raise ValueError(f"En-tête natif invalide : {tile_path}")
    node_end = 8 + count * 16
    if node_end > len(data):
        raise ValueError(f"Table TileIndexNode tronquée : {tile_path}")
    coords: set[tuple[int, int]] = set()
    for index in range(count):
        x, y, offset = struct.unpack_from("<iiq", data, 8 + index * 16)
        if x < 0 or y < 0 or (x, y) in coords or offset < node_end or offset + 8 > len(data):
            raise ValueError(f"Entrée native invalide : {tile_path} #{index}")
        size = struct.unpack_from("<q", data, offset)[0]
        if size <= 0 or offset + 8 + size > len(data):
            raise ValueError(f"PNG tile tronqué : {tile_path} #{index}")
        image = Image.open(io.BytesIO(data[offset + 8:offset + 8 + size]))
        if image.size != (TILE_SIZE, TILE_SIZE):
            raise ValueError(f"PNG tile de dimensions inattendues : {tile_path} #{index} {image.size}")
        coords.add((x, y))
    return data[:node_end], coords


def empty_tile_cell() -> dict[str, Any]:
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def marker_cell(marker: dict[str, Any]) -> tuple[int, int]:
    collider = marker.get("Collider", {})
    x, y = int(collider.get("X", -1)), int(collider.get("Y", -1))
    w, h = int(collider.get("Width", 0)), int(collider.get("Height", 0))
    if x < 0 or y < 0 or w <= 0 or h <= 0:
        raise ValueError(f"Collider de marker invalide : {marker.get('EntName')}")
    return ((x + w // 2) // TILE_SIZE, (y + h // 2) // TILE_SIZE)


def collision_audit(obj: dict[str, Any]) -> dict[str, Any]:
    obstacles = obj.get("obstacles")
    width, height = int(obj.get("Width", 0)), int(obj.get("Height", 0))
    if not isinstance(obstacles, list) or len(obstacles) != width or width == 0:
        raise ValueError("Dimensions collision/ground non concordantes")
    if any(not isinstance(column, list) or len(column) != height for column in obstacles):
        raise ValueError("Grille d'obstacles vide ou irrégulière")
    tags = Counter(int(cell.get("Tags", 0)) for column in obstacles for cell in column)
    walkable = {
        (x, y)
        for x, column in enumerate(obstacles)
        for y, cell in enumerate(column)
        if int(cell.get("Tags", 0)) == 0
    }
    blocked = {
        (x, y)
        for x, column in enumerate(obstacles)
        for y, cell in enumerate(column)
        if int(cell.get("Tags", 0)) != 0
    }
    walls = {
        (int(wall["Bounds"]["Location"]["X"]) // TILE_SIZE,
         int(wall["Bounds"]["Location"]["Y"]) // TILE_SIZE)
        for wall in obj.get("Walls", [])
    }
    if walls != blocked:
        raise ValueError(f"Walls ne correspondent pas aux collisions : {len(walls ^ blocked)} écarts")

    markers = [marker for entity in obj.get("Entities", []) for marker in entity.get("Markers", [])]
    named: dict[str, list[tuple[int, int]]] = {}
    for marker in markers:
        cell = marker_cell(marker)
        if not (0 <= cell[0] < width and 0 <= cell[1] < height):
            raise ValueError(f"Marker hors grille : {marker.get('EntName')} {cell}")
        named.setdefault(str(marker.get("EntName", "")), []).append(cell)
    entrances = named.get("entrance", [])
    if not entrances:
        raise ValueError("Marker source entrance absent")
    if any(cell not in walkable for cell in entrances):
        raise ValueError("Spawn/entrée source sur cellule bloquée")

    reached = set(entrances)
    distance = {cell: 0 for cell in entrances}
    queue = deque(entrances)
    while queue:
        x, y = queue.popleft()
        for next_cell in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if next_cell in walkable and next_cell not in reached:
                reached.add(next_cell)
                distance[next_cell] = distance[(x, y)] + 1
                queue.append(next_cell)
    marker_distance: dict[str, list[int | None]] = {}
    for name, cells in named.items():
        marker_distance[name] = [distance.get(cell) for cell in cells]
    if any(value is None for name, values in marker_distance.items() if name != "entrance" for value in values):
        raise ValueError("Marker source non joignable depuis entrance selon le masque source")
    return {
        "grid": [width, height],
        "cellSizePx": TILE_SIZE,
        "collisionTags": {str(tag): count for tag, count in sorted(tags.items())},
        "walkableCells": len(walkable),
        "blockedCells": len(blocked),
        "wallsMatchBlockedCells": True,
        "markerCells": {name: [list(cell) for cell in cells] for name, cells in named.items()},
        "shortestPathEdgesFromEntrance": marker_distance,
        "allSourceMarkersReachableByFourNeighborBfs": True,
    }


def build_map(source_root: Path, stage: Path, spec: dict[str, str]) -> dict[str, Any]:
    source_dir = source_root / spec["sourceDir"]
    ground_paths = list(source_dir.glob("*.rsground"))
    manifests = list(source_dir.glob("manifest.json"))
    if len(ground_paths) != 1 or len(manifests) != 1:
        raise ValueError(f"Exports Ground/manifest absents ou ambigus : {source_dir}")
    source_path = ground_paths[0]
    original_bytes = source_path.read_bytes()
    original_hash = sha256(original_bytes)
    if original_hash != spec["sourceGroundSha256"]:
        raise ValueError(f"SHA-256 source modifié pour {spec['entryId']} : {original_hash}")
    source_doc = json.loads(original_bytes.decode("utf-8-sig"))
    source_obj = source_doc.get("Object", {})
    author_manifest = json.loads(manifests[0].read_text(encoding="utf-8-sig"))
    if author_manifest.get("map_id") != spec["sourceDir"]:
        raise ValueError(f"Manifest source ne correspond pas à {spec['entryId']}")
    if author_manifest.get("validation_status", {}).get("art_approved") is not False:
        raise ValueError(f"Statut art inattendu pour {spec['entryId']}")
    if author_manifest.get("validation_status", {}).get("runtime_tested") is not False:
        raise ValueError(f"Statut runtime inattendu pour {spec['entryId']}")
    if int(source_obj.get("Width", 0)) != 96 or int(source_obj.get("Height", 0)) != 72:
        raise ValueError(f"Dimensions source Ground inattendues pour {spec['entryId']}")
    if any(layer.get("Tiles") for layer in source_obj.get("Layers", [])):
        raise ValueError(f"Le Ground source n'est plus la version aux calques vides : {spec['entryId']}")

    map_id = spec["mapId"]
    layers = source_obj.get("Layers") or []
    rebuilt_layers: list[dict[str, Any]] = []
    output_tiles: list[dict[str, Any]] = []
    per_layer_frames: dict[str, dict[str, Any]] = {}
    for layer in layers:
        source_asset = str((layer.get("Map") or {}).get("Asset", ""))
        width, height = int(source_obj["Width"]), int(source_obj["Height"])
        if source_asset:
            sheet_name = f"D262_{source_asset}"
            tile_source = source_dir / f"{source_asset}.tile"
            if not tile_source.is_file():
                raise ValueError(f"Source tilesheet absente pour {spec['entryId']} : {source_asset}")
            tile_output = stage / "Content/Tile" / f"{sheet_name}.tile"
            tile_meta = encode_native_tile(tile_source, tile_output, sheet_name)
            width, height = tile_meta["grid"]
            per_layer_frames[source_asset] = tile_meta
            output_tiles.append({key: value for key, value in tile_meta.items() if not key.startswith("_")})
            frame_coords = tile_meta["_frames"]
            transparent_coord = tile_meta["_transparentCoord"]
            frame_length = tile_meta["frameDurationTicks"]
        else:
            sheet_name = ""
            frame_coords = []
            transparent_coord = None
            frame_length = 60

        grid = [[empty_tile_cell() for _ in range(height)] for _ in range(width)]
        if source_asset:
            for x in range(width):
                for y in range(height):
                    cell_index = y * width + x
                    locs = [frame[cell_index] for frame in frame_coords]
                    if all(loc is None for loc in locs):
                        continue
                    if any(loc is None for loc in locs):
                        if transparent_coord is None:
                            raise ValueError(f"Animation blank frame sans tuile transparente : {spec['entryId']} {source_asset}")
                        locs = [loc if loc is not None else transparent_coord for loc in locs]
                    frames = [
                        {"Sheet": sheet_name, "TexLoc": {"X": int(loc[0]), "Y": int(loc[1])}}
                        for loc in locs
                    ]
                    grid[x][y] = {
                        "AutoTileset": "",
                        "Associates": [],
                        "Layers": [{"Frames": frames, "FrameLength": frame_length}],
                        "NeighborCode": 0,
                    }
        new_layer = dict(layer)
        new_layer["Map"] = {"Asset": ""}
        new_layer["Tiles"] = grid
        rebuilt_layers.append(new_layer)

    source_obj["AssetName"] = map_id
    source_obj["Layers"] = rebuilt_layers
    if isinstance(source_obj.get("AssetLayers"), list):
        source_obj["AssetLayers"] = json.loads(json.dumps(rebuilt_layers, ensure_ascii=False))
    collision = collision_audit(source_obj)

    tile_coords: dict[str, set[tuple[int, int]]] = {}
    tile_nodes: dict[str, bytes] = {}
    for sheet in output_tiles:
        tile_path = stage / sheet["outputFile"]
        node, coords = native_tile_coords(tile_path)
        tile_coords[sheet["outputAssetName"]] = coords
        tile_nodes[sheet["outputAssetName"]] = node
    frame_ref_count = 0
    for layer in source_obj["Layers"]:
        width, height = len(layer["Tiles"]), len(layer["Tiles"][0])
        if (width, height) != (96, 72):
            raise ValueError(f"Grille de tuiles incorrecte dans {spec['entryId']}")
        for column in layer["Tiles"]:
            for cell in column:
                for animation in cell.get("Layers", []):
                    for frame in animation.get("Frames", []):
                        frame_ref_count += 1
                        sheet = frame["Sheet"]
                        coord = (int(frame["TexLoc"]["X"]), int(frame["TexLoc"]["Y"]))
                        if coord not in tile_coords.get(sheet, set()):
                            raise ValueError(f"Référence de tuile invalide dans {spec['entryId']}: {sheet} {coord}")

    # All author-authored gameplay geometry and markers must remain exactly equal.
    for field in ("obstacles", "Walls", "Entities"):
        if source_obj[field] != json.loads(original_bytes.decode("utf-8-sig"))["Object"][field]:
            raise ValueError(f"Champ source altéré pendant la reconstruction : {spec['entryId']} {field}")

    output_doc = dict(source_doc)
    output_doc["Object"] = source_obj
    output_path = stage / "Data/Ground" / f"{map_id}.rsground"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_bytes = json.dumps(output_doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    output_path.write_bytes(output_bytes)
    return {
        "entryId": spec["entryId"],
        "sourceRepository": SOURCE_REPOSITORY,
        "sourceRef": SOURCE_REF,
        "sourceCommit": SOURCE_COMMIT,
        "sourceGroundFile": str(Path("exports") / spec["sourceDir"] / source_path.name),
        "sourceGroundSha256": original_hash,
        "sourceGroundBytes": len(original_bytes),
        "sourceGrid": [0, 0],
        "sourceMapGrid": [96, 72],
        "mapId": map_id,
        "groundFile": f"Data/Ground/{map_id}.rsground",
        "outputGroundSha256": sha256(output_bytes),
        "outputGroundBytes": len(output_bytes),
        "outputGroundVersion": output_doc.get("Version"),
        "layerCount": len(rebuilt_layers),
        "sourceAssetNames": [
            {"name": name, "outputName": meta["outputAssetName"]}
            for name, meta in per_layer_frames.items()
        ],
        "sourceAssetsConverted": output_tiles,
        "collisionAudit": collision,
        "tileFrameReferenceCount": frame_ref_count,
        "artApproved": False,
        "groundRuntimeTestedByBuildScript": False,
        "playabilityCertified": False,
    }


def write_manifest(stage: Path, maps: list[dict[str, Any]]) -> dict[str, Any]:
    nodes: dict[str, bytes] = {}
    for tile_path in sorted((stage / "Content/Tile").glob("*.tile"), key=lambda path: path.stem.casefold()):
        node, _ = native_tile_coords(tile_path)
        key = tile_path.stem
        if key.casefold() in {name.casefold() for name in nodes}:
            raise ValueError(f"Collision de nom de tileset : {key}")
        nodes[key] = node
    index = encode_index(nodes)
    index_path = stage / "Content/Tile/index.idx"
    index_path.write_bytes(index)
    manifest = {
        "schemaVersion": 1,
        "name": "Cinq Grounds PMDO 0.8.12 reconstruits depuis les grilles source",
        "sourceRepository": SOURCE_REPOSITORY,
        "sourceRef": SOURCE_REF,
        "sourceCommit": SOURCE_COMMIT,
        "method": (
            "Conversion déterministe des coordonnées exactes des cellules de carte et des atlas PNG "
            "source en TileSheet RogueEssence natifs; remplissage de GroundMap.Layers[*].Tiles. "
            "Obstacles, Walls, Entities et Markers restent inchangés. Aucun warp ni sortie n'est ajouté."
        ),
        "targetRuntime": "PMDO 0.8.12.0",
        "mapCount": len(maps),
        "tileSheetCount": len(nodes),
        "tileIndexSha256": sha256(index),
        "maps": maps,
        "validation": {
            "sourceGroundHashesMatched": True,
            "sourceTileMapsParsed": True,
            "nativeTileSheetsParsed": True,
            "allGroundTileFramesResolved": True,
            "sourceCollisionWallsAndMarkersUnchanged": True,
            "entranceAndAllSourceMarkersStaticallyReachable": True,
            "pmdoGroundDeserialization": "NOT_RUN by this builder; separately runtime-probed",
            "graphicsRendering": "NOT_TESTED",
            "gameplayAndCollisionPlaythrough": "NOT_TESTED",
            "artApproved": False,
            "playabilityCertified": False,
        },
    }
    path = stage / "Documentation/reconstruction_manifest.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def build(source_root: Path, output_root: Path) -> dict[str, Any]:
    source_root = source_root.resolve()
    output_root = output_root.resolve()
    if not source_root.is_dir():
        raise SystemExit(f"Dossier source absent : {source_root}")
    if output_root.exists():
        raise SystemExit(f"La sortie existe déjà; choisir un autre --output : {output_root}")
    output_root.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f".{output_root.name}.", dir=output_root.parent) as tmp:
        stage = Path(tmp)
        maps = [build_map(source_root, stage, spec) for spec in MAPS]
        manifest = write_manifest(stage, maps)
        os.replace(stage, output_root)
    return {
        "output": str(output_root),
        "maps": len(maps),
        "tileSheets": manifest["tileSheetCount"],
        "groundBytes": sum(row["outputGroundBytes"] for row in maps),
        "tileBytes": sum(asset["outputBytes"] for row in maps for asset in row["sourceAssetsConverted"]),
        "artApproved": False,
        "playabilityCertified": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    print(json.dumps(build(args.source_root, args.output), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
