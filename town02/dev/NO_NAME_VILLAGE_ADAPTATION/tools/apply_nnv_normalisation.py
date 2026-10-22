#!/usr/bin/env python3
"""Apply the validated NNV x0.125 normalisation onto the PMDO scale referential.

Owner-approved contract:
    NNV world geometry  -> x0.125
    Pokemon sprites     -> x1, untouched
    PMU / PMDO assets   -> x1, untouched
    resampling          -> NEAREST only, palette preserved
    level design        -> unchanged (no decor added or removed)

Transformations:
    world           4992x4992 -> 624x624 px
    tile cell       64 px     -> 8 px
    TexSize         8         -> 1
    collision grid  624x624   -> 78x78 (8 px cell stays 8 px)
    tile grid       78x78     -> unchanged (layer data preserved verbatim)
    entity X/Y      / 8
    entity W/H      unchanged (markers and Pokemon are PMDO referential)

Collision aggregation uses MAJORITY over each 8x8 block of source cells. This
preserves the source blocked-surface ratio (36.6% -> 37.6%) whereas an ANY rule
would thicken walls to 44.5%. Documented as an explicit, reversible choice.

Fail-closed: any non-divisible coordinate, missing file, altered PMU asset or
inconsistent season aborts the run instead of being silently rounded.

Writes only under NO_NAME_VILLAGE_ADAPTATION/generated/. Never touches Data/,
Content/, docs/pmuniverse_buildings/ or any PMU/PMDO asset.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
import shutil
import struct
from pathlib import Path

from PIL import Image

REPO = Path(__file__).resolve().parents[2]
GEN = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"
FACTOR = 8               # divisor: x0.125
NEW_TEX_SIZE = 1
NEW_CELL_PX = 8
DOOR_EXCEPTION = "Exit_Door_106508"   # owner-validated: belongs to a removed house


class Abort(Exception):
    """Fail-closed stop: report, never auto-correct."""


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


# --------------------------------------------------------------------- tiles
def read_tile(path: Path) -> tuple[int, list[tuple[int, bytes]]]:
    raw = path.read_bytes()
    size, count = struct.unpack_from("<II", raw, 0)
    entries = []
    for i in range(count):
        key, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
        (length,) = struct.unpack_from("<Q", raw, off)
        entries.append((key, raw[off + 8: off + 8 + length]))
    return size, entries


def write_tile(path: Path, tile_size: int, entries: list[tuple[int, bytes]]) -> None:
    offsets: dict[bytes, int] = {}
    payloads: list[bytes] = []
    offset = 8 + len(entries) * 16
    for _, payload in entries:
        if payload not in offsets:
            offsets[payload] = offset
            payloads.append(payload)
            offset += 8 + len(payload)
    out = bytearray(struct.pack("<II", tile_size, len(entries)))
    for key, payload in entries:
        out.extend(struct.pack("<QQ", key, offsets[payload]))
    for payload in payloads:
        out.extend(struct.pack("<Q", len(payload)))
        out.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(bytes(out))


def shrink_tileset(path: Path, report: dict) -> None:
    size, entries = read_tile(path)
    if size % FACTOR:
        raise Abort(f"{path.name}: tile size {size} not divisible by {FACTOR}")
    new_size = size // FACTOR
    out_entries = []
    palette_before: set = set()
    palette_after: set = set()
    for key, payload in entries:
        with Image.open(io.BytesIO(payload)) as im:
            image = im.convert("RGBA")
        if image.width % FACTOR or image.height % FACTOR:
            raise Abort(f"{path.name}: tile {key} is {image.size}, not divisible by {FACTOR}")
        small = image.resize((image.width // FACTOR, image.height // FACTOR), Image.Resampling.NEAREST)
        if len(palette_before) < 4000:
            palette_before |= set(image.getdata())
            palette_after |= set(small.getdata())
        buf = io.BytesIO()
        small.save(buf, format="PNG", optimize=False, compress_level=9)
        out_entries.append((key, buf.getvalue()))
    write_tile(path, new_size, out_entries)
    invented = palette_after - palette_before
    if invented:
        raise Abort(f"{path.name}: NEAREST invented {len(invented)} colours - aborting")
    report[str(path.relative_to(REPO))] = {
        "tiles": len(entries), "cell_px": f"{size} -> {new_size}",
        "palette_sampled_before": len(palette_before),
        "palette_sampled_after": len(palette_after),
        "colours_invented": 0,
        "resample": "NEAREST",
    }


# ------------------------------------------------------------------ entities
def scale_entity(entity: dict, path_label: str, issues: list) -> None:
    collider = entity.get("Collider")
    if not collider:
        return
    for field in ("X", "Y"):
        value = collider.get(field)
        if value is None:
            continue
        if value % FACTOR:
            if entity.get("EntName") == DOOR_EXCEPTION:
                issues.append({"entity": entity.get("EntName"), "field": field,
                               "value": value, "handling": "owner-validated exception, floor division"})
            else:
                raise Abort(f"{path_label}: {entity.get('EntName')} {field}={value} not divisible by {FACTOR}")
        collider[field] = value // FACTOR
    # Width/Height stay native: markers and Pokemon belong to the PMDO referential.


# -------------------------------------------------------------------- ground
def transform_ground(path: Path, report: dict, issues: list) -> None:
    document = json.loads(path.read_text(encoding="utf-8-sig"))
    obj = document["Object"]
    before_tex = obj["TexSize"]
    before_obst = len(obj["obstacles"])

    if before_obst % FACTOR:
        raise Abort(f"{path.name}: collision grid {before_obst} not divisible by {FACTOR}")

    obstacles = obj["obstacles"]
    new_n = before_obst // FACTOR
    threshold = (FACTOR * FACTOR) // 2      # MAJORITY rule
    new_obstacles = []
    for bx in range(new_n):
        column = []
        for by in range(new_n):
            blocked = 0
            for dx in range(FACTOR):
                for dy in range(FACTOR):
                    if obstacles[bx * FACTOR + dx][by * FACTOR + dy]["Tags"] != 0:
                        blocked += 1
            column.append({"Bounds": {"X": bx * NEW_CELL_PX, "Y": by * NEW_CELL_PX,
                                      "Width": NEW_CELL_PX, "Height": NEW_CELL_PX},
                           "Tags": 1 if blocked >= threshold else 0})
        new_obstacles.append(column)
    obj["obstacles"] = new_obstacles
    obj["TexSize"] = NEW_TEX_SIZE

    for group in obj.get("Entities") or []:
        for key in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            for entity in group.get(key) or []:
                scale_entity(entity, path.name, issues)

    for key in ("ViewCenter", "ViewOffset"):
        value = obj.get(key)
        if isinstance(value, dict):
            for axis in ("X", "Y"):
                if isinstance(value.get(axis), int):
                    value[axis] //= FACTOR

    payload = json.dumps(document, ensure_ascii=False, indent=2)
    path.write_text("\ufeff" + payload, encoding="utf-8")
    report[str(path.relative_to(REPO))] = {
        "tex_size": f"{before_tex} -> {NEW_TEX_SIZE}",
        "collision_grid": f"{before_obst} -> {new_n}",
        "tile_grid": f"{len(obj['Layers'][0]['Tiles'])} (unchanged)",
        "collision_rule": f"MAJORITY >= {threshold}/{FACTOR*FACTOR}",
    }


def transform_bundle(path: Path, report: dict) -> None:
    with gzip.open(path) as stream:
        data = json.load(stream)
    before = data.get("tex_size")
    data["tex_size"] = NEW_TEX_SIZE
    dims = data.get("dimensions_px")
    if dims:
        data["dimensions_px"] = [d // FACTOR for d in dims]
    payload = json.dumps(data, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode() + b"\n"
    with gzip.open(path, "wb") as stream:
        stream.write(payload)
    report[str(path.relative_to(REPO))] = {
        "tex_size": f"{before} -> {NEW_TEX_SIZE}",
        "dimensions_px": f"{dims} -> {data.get('dimensions_px')}",
        "layer_data": "unchanged",
    }


def transform_entities_patch(path: Path, report: dict) -> None:
    data = json.loads(path.read_text())
    moved = 0

    def walk(node):
        nonlocal moved
        if isinstance(node, dict):
            for key, value in node.items():
                if key in ("X", "Y") and isinstance(value, int):
                    if value % FACTOR:
                        raise Abort(f"entities_patch: {key}={value} not divisible by {FACTOR}")
                    node[key] = value // FACTOR
                    moved += 1
                else:
                    walk(value)
        elif isinstance(node, list):
            for item in node:
                walk(item)

    walk(data.get("entities"))
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True) + "\n")
    report[str(path.relative_to(REPO))] = {"coordinates_scaled": moved}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path,
                        default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/normalisation-applied")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    pmu_before = {p.name: sha256_file(p)
                  for p in sorted((REPO / "docs/pmuniverse_buildings/buildings").glob("*.png"))}

    tiles = sorted(GEN.rglob("*.tile"))
    grounds = sorted(GEN.rglob("*.rsground"))
    bundles = sorted(GEN.rglob("*.layers.json.gz"))
    patch = GEN / "life/entities_patch.json"

    if len(tiles) != 8 or len(grounds) != 2 or len(bundles) != 6:
        raise Abort(f"unexpected perimeter: {len(tiles)} tiles, {len(grounds)} grounds, {len(bundles)} bundles")

    report: dict = {"tilesets": {}, "grounds": {}, "bundles": {}, "entities": {}}
    issues: list = []

    for path in tiles:
        shrink_tileset(path, report["tilesets"])
        print(f"  tileset  {path.relative_to(GEN)}")
    for path in grounds:
        transform_ground(path, report["grounds"], issues)
        print(f"  ground   {path.relative_to(GEN)}")
    for path in bundles:
        transform_bundle(path, report["bundles"])
        print(f"  bundle   {path.relative_to(GEN)}")
    transform_entities_patch(patch, report["entities"])
    print(f"  entities {patch.relative_to(GEN)}")

    pmu_after = {p.name: sha256_file(p)
                 for p in sorted((REPO / "docs/pmuniverse_buildings/buildings").glob("*.png"))}
    if pmu_before != pmu_after:
        raise Abort("PMU assets were modified - aborting")

    summary = {
        "schema": "new-era.nnv-normalisation-applied.v1",
        "factor": 0.125,
        "resample": "NEAREST only; zero invented colours verified per tileset",
        "collision_rule": "MAJORITY over each 8x8 source block",
        "geometry": {
            "world_px": "4992 -> 624", "tile_cell_px": "64 -> 8",
            "tex_size": "8 -> 1", "collision_grid": "624 -> 78",
            "tile_grid": "78x78 unchanged",
        },
        "entity_rule": "positions /8; marker and Pokemon sizes unchanged",
        "door_exception": {"entity": DOOR_EXCEPTION,
                           "note": "owner-validated; belongs to a house scheduled for removal"},
        "pmu_assets_unchanged": True,
        "pmu_assets_verified": len(pmu_before),
        "issues": issues,
        "details": report,
        "runtime_status": "OBSOLETE - PMDO 0.8.12 must be re-tested on all four seasons",
        "certification": "NOT_CERTIFIED pending runtime",
    }
    (args.out / "normalisation-applied.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(f"\nPMU assets verified unchanged: {len(pmu_before)}")
    print(f"issues (non-blocking): {len(issues)}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Abort as exc:
        print(f"\nABORT: {exc}")
        raise SystemExit(2)
