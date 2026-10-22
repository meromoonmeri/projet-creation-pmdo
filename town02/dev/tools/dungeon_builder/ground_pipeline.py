"""Fixed-Ground pipeline: midpoint and boss arenas.

`entrance`, `mid` and the end scene are never procedural.  This module takes a
**validated template Ground** (`Data/Ground/<template>.rsground`, plain JSON in
RogueEssence 0.8.x) and produces the dungeon's own Ground by:

* keeping the template's geometry, collisions, markers, spawners and ground
  objects (Kangaskhan statue, exits, checkpoint triggers) untouched;
* **retexturing** every tile onto the dungeon's biome sheet, tile by tile, by
  visual nearest-neighbour matching between the two `.tile` sheets — no blind
  sheet swap, no manual transition painting;
* renaming the asset and registering it in `Data/Ground/index.idx`.

A PNG preview of the result can be rendered for visual verification.
"""
from __future__ import annotations

import hashlib
import json
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
GROUND_DIR = ROOT / "Data" / "Ground"
TILE_DIR = ROOT / "Content" / "Tile"
# reuse the repository's existing PNG codec instead of duplicating one
sys.path.insert(0, str(ROOT / "external" / "BIBLIOTHEQUE_WORKSPACE" / "tools"))
try:  # pragma: no cover - exercised implicitly
    from png_rgba import RGBAImage, load_png, save_png  # type: ignore
except Exception:  # pragma: no cover
    RGBAImage = None  # type: ignore
    load_png = save_png = None  # type: ignore


class GroundPipelineError(RuntimeError):
    pass


# --------------------------------------------------------------------------
# .tile sheets  (format read in tools/png2tileset.py and RogueEssence TileSheet)
# --------------------------------------------------------------------------
@dataclass
class TileSheet:
    name: str
    tile_size: int
    tiles: Dict[Tuple[int, int], bytes]        # (x, y) -> PNG bytes

    @property
    def locations(self) -> List[Tuple[int, int]]:
        return sorted(self.tiles)


def load_sheet(name: str, tile_dir: Optional[Path] = None) -> TileSheet:
    path = (tile_dir or TILE_DIR) / f"{name}.tile"
    if not path.exists():
        raise GroundPipelineError(f"tile sheet '{name}.tile' not found in {tile_dir or TILE_DIR}")
    raw = path.read_bytes()
    tile_size, tile_count = struct.unpack_from("<II", raw, 0)
    offset = 8
    tiles: Dict[Tuple[int, int], bytes] = {}
    for _ in range(tile_count):
        key, blob_offset = struct.unpack_from("<QQ", raw, offset)
        offset += 16
        x, y = key & 0xFFFFFFFF, key >> 32
        length = struct.unpack_from("<q", raw, blob_offset)[0]
        tiles[(x, y)] = raw[blob_offset + 8: blob_offset + 8 + length]
    return TileSheet(name, tile_size, tiles)


def _decode(png_bytes: bytes, scratch: Path):
    if load_png is None:
        raise GroundPipelineError("PNG codec unavailable (external/BIBLIOTHEQUE_WORKSPACE missing)")
    scratch.write_bytes(png_bytes)
    return load_png(scratch)


GRID = 4  # 4x4 cells -> 64-dimension structural signature


def tile_signature(image) -> Tuple[float, ...]:
    """Structural colour signature: global mean + a GRIDxGRID mosaic of means.

    A flat mean alone collapses hundreds of distinct source tiles onto a handful
    of targets; the mosaic keeps the internal structure (edges, highlights) so a
    wall tile matches a wall tile and a floor tile matches a floor tile.
    """
    width, height = image.width, image.height
    pixels = image.pixels
    cells = [[0.0, 0.0, 0.0, 0.0, 0] for _ in range(GRID * GRID + 1)]
    for y in range(height):
        row = min(GRID - 1, y * GRID // max(1, height))
        for x in range(width):
            index = (y * width + x) * 4
            r, g, b, a = pixels[index:index + 4]
            col = min(GRID - 1, x * GRID // max(1, width))
            alpha = a / 255.0
            for slot in (0, 1 + row * GRID + col):
                cell = cells[slot]
                cell[0] += r * alpha
                cell[1] += g * alpha
                cell[2] += b * alpha
                cell[3] += a
                cell[4] += 1
    out: List[float] = []
    for cell in cells:
        count = max(1, cell[4])
        out.extend([cell[0] / count, cell[1] / count, cell[2] / count, cell[3] / count])
    return tuple(out)


def sheet_signatures(sheet: TileSheet, scratch: Path,
                     only: Optional[Iterable[Tuple[int, int]]] = None) -> Dict[Tuple[int, int], Tuple[float, ...]]:
    """Signature per tile location; identical PNG blobs are decoded once."""
    wanted = set(only) if only is not None else set(sheet.tiles)
    signatures: Dict[Tuple[int, int], Tuple[float, ...]] = {}
    cache: Dict[bytes, Tuple[float, ...]] = {}
    for loc in sorted(wanted):
        blob = sheet.tiles.get(loc)
        if blob is None:
            continue
        digest = hashlib.sha1(blob).digest()
        if digest not in cache:
            cache[digest] = tile_signature(_decode(blob, scratch))
        signatures[loc] = cache[digest]
    return signatures


def match_tiles(source: Dict[Tuple[int, int], Tuple[float, ...]],
                target: Dict[Tuple[int, int], Tuple[float, ...]]) -> Dict[Tuple[int, int], Tuple[int, int]]:
    """Nearest-neighbour retexture mapping, source tile -> target tile.

    Identical signatures are resolved once, so a sheet with many duplicated
    tiles costs a fraction of the naive product.
    """
    if not target:
        raise GroundPipelineError("target sheet has no decodable tile")
    # one representative target location per distinct signature
    unique_targets: Dict[Tuple[float, ...], Tuple[int, int]] = {}
    for loc, sig in target.items():
        unique_targets.setdefault(sig, loc)
    target_items = list(unique_targets.items())
    # stage 1 index: global mean only (first 4 components)
    coarse = [(sig[:4], sig, loc) for sig, loc in target_items]

    resolved: Dict[Tuple[float, ...], Tuple[int, int]] = {}
    mapping: Dict[Tuple[int, int], Tuple[int, int]] = {}
    shortlist_size = min(48, len(coarse))
    for src_loc, src_sig in source.items():
        best = resolved.get(src_sig)
        if best is None:
            head = src_sig[:4]
            shortlist = sorted(
                coarse,
                key=lambda item: sum((a - b) ** 2 for a, b in zip(head, item[0])))[:shortlist_size]
            best_score = None
            for _, tgt_sig, tgt_loc in shortlist:
                score = 0.0
                for a, b in zip(src_sig, tgt_sig):
                    diff = a - b
                    score += diff * diff
                if best_score is None or score < best_score:
                    best, best_score = tgt_loc, score
            resolved[src_sig] = best  # type: ignore[assignment]
        mapping[src_loc] = best  # type: ignore[assignment]
    return mapping


# --------------------------------------------------------------------------
@dataclass
class GroundBuild:
    ground_id: str
    template: str
    source_sheets: List[str] = field(default_factory=list)
    target_sheet: str = ""
    distinct_tiles: int = 0
    remapped_tiles: int = 0
    entities: Dict[str, int] = field(default_factory=dict)
    path: Optional[Path] = None
    problems: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems


def analyze_ground(path: Path) -> Dict[str, object]:
    data = json.loads(Path(path).read_text(encoding="utf-8-sig"))["Object"]
    sheets: Dict[str, int] = {}
    locs: Dict[str, set] = {}

    def walk(node):
        if isinstance(node, dict):
            sheet = node.get("Sheet")
            if isinstance(sheet, str) and sheet:
                sheets[sheet] = sheets.get(sheet, 0) + 1
                tex = node.get("TexLoc") or {}
                locs.setdefault(sheet, set()).add((tex.get("X", 0), tex.get("Y", 0)))
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    walk(data)
    entities = {}
    for group in data.get("Entities", []):
        for key in ("Markers", "Spawners", "GroundObjects", "MapChars"):
            entities[key] = entities.get(key, 0) + len(group.get(key, []))
    return {
        "name": data.get("Name", {}).get("DefaultText", ""),
        "asset": data.get("AssetName", ""),
        "music": data.get("Music", ""),
        "size": (len(data["Layers"][0]["Tiles"]), len(data["Layers"][0]["Tiles"][0]))
        if data.get("Layers") else (0, 0),
        "sheets": sheets,
        "distinct_locs": {k: len(v) for k, v in locs.items()},
        "locs": locs,
        "entities": entities,
        "ground_objects": [obj.get("EntName", "") for group in data.get("Entities", [])
                           for obj in group.get("GroundObjects", [])],
    }


def build_fixed_ground(template: str, ground_id: str, target_sheet: str,
                       name: Dict[str, str], music: str = "", comment: str = "",
                       ground_dir: Optional[Path] = None, tile_dir: Optional[Path] = None,
                       scratch: Optional[Path] = None, dry_run: bool = False,
                       required_objects: Sequence[str] = ()) -> GroundBuild:
    ground_dir = ground_dir or GROUND_DIR
    tile_dir = tile_dir or TILE_DIR
    scratch = scratch or (ROOT / ".runtime-cache")
    scratch.mkdir(parents=True, exist_ok=True)
    scratch_file = scratch / "_tile.png"

    template_path = ground_dir / f"{template}.rsground"
    if not template_path.exists():
        raise GroundPipelineError(f"template Ground '{template}.rsground' not found")

    info = analyze_ground(template_path)
    build = GroundBuild(ground_id=ground_id, template=template,
                        source_sheets=sorted(info["sheets"]), target_sheet=target_sheet)
    build.entities = dict(info["entities"])

    for required in required_objects:
        if required not in info["ground_objects"]:
            build.problems.append(f"template lacks the required ground object '{required}'")

    target = load_sheet(target_sheet, tile_dir)
    target_sigs = sheet_signatures(target, scratch_file)

    mapping: Dict[str, Dict[Tuple[int, int], Tuple[int, int]]] = {}
    for sheet_name, used in info["locs"].items():
        if sheet_name == target_sheet:
            continue
        source = load_sheet(sheet_name, tile_dir)
        source_sigs = sheet_signatures(source, scratch_file, only=used)
        missing = set(used) - set(source_sigs)
        if missing:
            build.notes.append(f"{sheet_name}: {len(missing)} tiles absent from the sheet, kept blank")
        mapping[sheet_name] = match_tiles(source_sigs, target_sigs)
        build.distinct_tiles += len(source_sigs)

    data = json.loads(template_path.read_text(encoding="utf-8-sig"))
    obj = data["Object"]

    def retexture(node):
        if isinstance(node, dict):
            sheet = node.get("Sheet")
            if isinstance(sheet, str) and sheet in mapping:
                tex = node.get("TexLoc") or {"X": 0, "Y": 0}
                key = (tex.get("X", 0), tex.get("Y", 0))
                new_loc = mapping[sheet].get(key)
                if new_loc is not None:
                    node["Sheet"] = target_sheet
                    node["TexLoc"] = {"X": new_loc[0], "Y": new_loc[1]}
                    build.remapped_tiles += 1
            for value in node.values():
                retexture(value)
        elif isinstance(node, list):
            for value in node:
                retexture(value)

    retexture(obj)
    obj["AssetName"] = ground_id
    obj["Name"] = {"DefaultText": name.get("en", ground_id),
                   "LocalTexts": {k: v for k, v in name.items() if k != "en"}}
    if music:
        obj["Music"] = music
    obj["Comment"] = comment or (f"Fixed Ground derived from the validated template "
                                 f"'{template}', retextured with '{target_sheet}'.")

    build.path = ground_dir / f"{ground_id}.rsground"
    if not dry_run:
        build.path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2),
                              encoding="utf-8")
        update_ground_index(ground_id, obj, ground_dir)
    return build


def update_ground_index(ground_id: str, obj: Dict[str, object],
                        ground_dir: Optional[Path] = None) -> None:
    index_path = (ground_dir or GROUND_DIR) / "index.idx"
    if not index_path.exists():
        return
    data = json.loads(index_path.read_text(encoding="utf-8-sig"))
    entries = data["Object"]
    template_entry = None
    for key, value in entries.items():
        if key.startswith("$"):
            continue
        template_entry = value
        break
    entry = dict(template_entry) if isinstance(template_entry, dict) else {}
    entry.update({
        "Name": obj.get("Name", {"DefaultText": ground_id, "LocalTexts": {}}),
        "Comment": obj.get("Comment", ""),
        "Released": True,
    })
    entries[ground_id] = entry
    index_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


# --------------------------------------------------------------------------
def render_preview(ground_path: Path, out_png: Path, scale: int = 1,
                   tile_dir: Optional[Path] = None, scratch: Optional[Path] = None) -> Path:
    """Render the ground's first layer to a PNG so the retexture can be eyeballed."""
    if load_png is None or save_png is None:
        raise GroundPipelineError("PNG codec unavailable")
    tile_dir = tile_dir or TILE_DIR
    scratch = scratch or (ROOT / ".runtime-cache")
    scratch.mkdir(parents=True, exist_ok=True)
    scratch_file = scratch / "_render.png"

    data = json.loads(Path(ground_path).read_text(encoding="utf-8-sig"))["Object"]
    tiles = data["Layers"][0]["Tiles"]
    cols, rows = len(tiles), len(tiles[0])
    sheets: Dict[str, TileSheet] = {}
    cache: Dict[Tuple[str, int, int], object] = {}
    size = 0
    for column in tiles:
        for tile in column:
            for layer in tile.get("Layers", []):
                for frame in layer.get("Frames", []):
                    name = frame.get("Sheet")
                    if name and name not in sheets:
                        sheets[name] = load_sheet(name, tile_dir)
                        size = sheets[name].tile_size
    if not size:
        raise GroundPipelineError("no tile sheet referenced by this ground")

    step = max(1, size // scale) if scale > 1 else size
    out = RGBAImage(cols * step, rows * step, bytearray(cols * step * rows * step * 4))
    for cx, column in enumerate(tiles):
        for cy, tile in enumerate(column):
            layers = tile.get("Layers", [])
            if not layers or not layers[0].get("Frames"):
                continue
            frame = layers[0]["Frames"][0]
            name = frame.get("Sheet")
            loc = frame.get("TexLoc", {"X": 0, "Y": 0})
            key = (name, loc.get("X", 0), loc.get("Y", 0))
            if key not in cache:
                blob = sheets[name].tiles.get((loc.get("X", 0), loc.get("Y", 0)))
                cache[key] = _decode(blob, scratch_file) if blob else None
            image = cache[key]
            if image is None:
                continue
            for y in range(step):
                sy = y * size // step
                for x in range(step):
                    sx = x * size // step
                    src = (sy * image.width + sx) * 4
                    dst = ((cy * step + y) * out.width + cx * step + x) * 4
                    out.pixels[dst:dst + 4] = image.pixels[src:src + 4]
    out_png.parent.mkdir(parents=True, exist_ok=True)
    save_png(out, out_png)
    return out_png
