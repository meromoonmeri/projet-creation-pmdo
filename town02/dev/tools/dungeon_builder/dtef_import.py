"""DTEF importer: PMDCollab `RawAsset/TileDtef` -> RogueEssence AutoTileData.

The Dungeon Tile Exchange Format packs, per dungeon tileset, three variation
sheets (`tileset_0/1/2.png`, 18x8 tiles of 24px) laid out as three 6x8 blocks:

    columns  0-5  -> WALL
    columns  6-11 -> WATER      (RogueEssence "secondary")
    columns 12-17 -> FLOOR

and the slot order inside a block is `skytemple_dtef.rules.REMAP_RULES`: 48
slots, one empty, 47 neighbour rules expressed with `DmaNeighbor` flags.

RogueEssence's `AutoTileAdjacent` stores the very same 47 cases as `TilexNN`
entries, with the bit layout Down=0x01, Left=0x02, Up=0x04, Right=0x08,
DownLeft=0x10, UpLeft=0x20, UpRight=0x40, DownRight=0x80.  The correspondence is
not assumed: `verify_rule_mapping()` recomputes the 47 codes from the DTEF rules
and compares them to the table already imported in this repository.

The importer therefore performs a real conversion — no hand-painted transition,
no invented tile — and writes:

* `Content/Tile/<Sheet>.tile` (RogueEssence tile sheet, deduplicated);
* `Data/AutoTile/<id>_floor|_wall|_secondary.json` (47 codes x 3 variations);
* the matching entries in `Data/AutoTile/index.idx`.

Requires Pillow for PNG decoding (authoring-time dependency only).
"""
from __future__ import annotations

import json
import struct
from dataclasses import dataclass, field
from io import BytesIO
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
AUTOTILE_DIR = ROOT / "Data" / "AutoTile"
TILE_DIR = ROOT / "Content" / "Tile"
TILE_SIZE = 24
SHEET_COLS = 6
SHEET_ROWS = 8
BLOCKS = ("wall", "secondary", "floor")     # DTEF column-block order
VERSION = "0.8.12.0"

#: RogueEssence AutoTileAdjacent bit layout, expressed in DTEF direction names
RE_BITS = {"SOUTH": 0x01, "WEST": 0x02, "NORTH": 0x04, "EAST": 0x08,
           "SOUTH_WEST": 0x10, "NORTH_WEST": 0x20, "NORTH_EAST": 0x40, "SOUTH_EAST": 0x80}

#: the 47 codes RogueEssence expects (same list as the repo's ROM importer)
EXPECTED_CODES = (
    0x00, 0x01, 0x02, 0x03, 0x13, 0x04, 0x05, 0x06, 0x26, 0x07, 0x17, 0x27, 0x37,
    0x08, 0x09, 0x89, 0x0A, 0x0B, 0x1B, 0x8B, 0x9B, 0x0C, 0x4C, 0x0D, 0x4D, 0x8D,
    0xCD, 0x0E, 0x2E, 0x4E, 0x6E, 0x0F, 0x1F, 0x2F, 0x3F, 0x4F, 0x5F, 0x6F, 0x7F,
    0x8F, 0x9F, 0xAF, 0xBF, 0xCF, 0xDF, 0xEF, 0xFF)


class DtefImportError(RuntimeError):
    pass


def slot_codes() -> List[Optional[int]]:
    """DTEF slot index -> RogueEssence neighbour code (None for the empty slot)."""
    try:
        from skytemple_dtef.rules import REMAP_RULES
        from skytemple_files.graphics.dma.protocol import DmaNeighbor
    except ImportError as exc:      # pragma: no cover - authoring dependency
        raise DtefImportError("skytemple-dtef is required to read the DTEF rule order "
                              f"({exc})") from exc
    flags = {name: getattr(DmaNeighbor, name) for name in RE_BITS}
    codes: List[Optional[int]] = []
    for rule in REMAP_RULES:
        if rule is None:
            codes.append(None)
            continue
        code = 0
        for name, bit in RE_BITS.items():
            if rule & flags[name]:
                code |= bit
        codes.append(code)
    return codes


def verify_rule_mapping() -> Tuple[bool, List[int]]:
    codes = [c for c in slot_codes() if c is not None]
    return sorted(set(codes)) == sorted(set(EXPECTED_CODES)), codes


# ---------------------------------------------------------------------------
def _load_image(path: Path):
    try:
        from PIL import Image
    except ImportError as exc:      # pragma: no cover - authoring dependency
        raise DtefImportError(f"Pillow is required to decode DTEF sheets ({exc})") from exc
    return Image.open(path).convert("RGBA")


@dataclass
class DtefImport:
    package: str
    sheet: str
    source: str = ""
    tiles_written: int = 0
    codes: int = 0
    variations: int = 0
    files: List[str] = field(default_factory=list)
    problems: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems


def _tile_png(image, col: int, row: int) -> bytes:
    box = (col * TILE_SIZE, row * TILE_SIZE, (col + 1) * TILE_SIZE, (row + 1) * TILE_SIZE)
    buffer = BytesIO()
    image.crop(box).save(buffer, format="PNG")
    return buffer.getvalue()


def write_tile_sheet(name: str, tiles: Dict[Tuple[int, int], bytes],
                     tile_dir: Optional[Path] = None) -> Path:
    """Write a RogueEssence `.tile` sheet (format read in tools/png2tileset.py)."""
    tile_dir = tile_dir or TILE_DIR
    tile_dir.mkdir(parents=True, exist_ok=True)
    path = tile_dir / f"{name}.tile"
    entries = sorted(tiles.items())
    header = struct.pack("<II", TILE_SIZE, len(entries))
    table_size = len(entries) * 16
    blob_start = len(header) + table_size
    table = b""
    blobs = b""
    offsets: Dict[bytes, int] = {}
    for (x, y), png in entries:
        if png in offsets:            # identical tiles share their offset (native dedup)
            offset = offsets[png]
        else:
            offset = blob_start + len(blobs)
            offsets[png] = offset
            blobs += struct.pack("<q", len(png)) + png
        table += struct.pack("<QQ", (x & 0xFFFFFFFF) | (y << 32), offset)
    path.write_bytes(header + table + blobs)
    return path


def _autotile_json(name: Dict[str, str], sheet: str, mapping: Dict[int, List[Tuple[int, int]]],
                   comment: str) -> Dict[str, Any]:
    tiles: Dict[str, Any] = {"$type": "RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence"}
    for code, variants in sorted(mapping.items()):
        tiles[f"Tilex{code:02X}"] = [
            [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}], "FrameLength": 999}]
            for x, y in variants]
    return {
        "Version": VERSION,
        "Object": {
            "$type": "RogueEssence.Data.AutoTileData, RogueEssence",
            "Name": {"DefaultText": name.get("en", sheet),
                     "LocalTexts": {k: v for k, v in name.items() if k != "en"}},
            "Comment": comment,
            "Tiles": tiles,
            "Layers": [],
        },
    }


def import_dtef(source_dir: Path, package: str, sheet: str, name: Dict[str, str],
                autotile_dir: Optional[Path] = None, tile_dir: Optional[Path] = None,
                dry_run: bool = False) -> DtefImport:
    """Convert one `TileDtef/<Dungeon>` folder into the mod's auto-tile triplet."""
    autotile_dir = autotile_dir or AUTOTILE_DIR
    result = DtefImport(package=package, sheet=sheet, source=str(source_dir))

    ok, _ = verify_rule_mapping()
    if not ok:
        result.problems.append("the DTEF rule order no longer matches RogueEssence's 47 codes")
        return result

    variation_files = [source_dir / f"tileset_{index}.png" for index in range(3)]
    available = [path for path in variation_files if path.exists()]
    if not available:
        result.problems.append(f"no tileset_N.png in {source_dir}")
        return result
    images = [_load_image(path) for path in available]
    result.variations = len(images)

    for image in images:
        if image.width < SHEET_COLS * 3 * TILE_SIZE or image.height < SHEET_ROWS * TILE_SIZE:
            result.problems.append(f"unexpected DTEF sheet size {image.width}x{image.height}")
            return result

    codes = slot_codes()
    tiles: Dict[Tuple[int, int], bytes] = {}
    mappings: Dict[str, Dict[int, List[Tuple[int, int]]]] = {role: {} for role in BLOCKS}

    for block_index, role in enumerate(BLOCKS):
        for slot, code in enumerate(codes):
            if code is None:
                continue
            col = slot % SHEET_COLS + SHEET_COLS * block_index
            row = slot // SHEET_COLS
            variants: List[Tuple[int, int]] = []
            for variation, image in enumerate(images):
                # one sheet cell per (role, code, variation)
                target = (col + SHEET_COLS * 3 * variation, row)
                tiles[target] = _tile_png(image, col, row)
                variants.append(target)
            mappings[role][code] = variants
        result.codes = len(mappings[role])

    if not dry_run:
        sheet_path = write_tile_sheet(sheet, tiles, tile_dir)
        result.files.append(str(sheet_path.relative_to(ROOT)))
    result.tiles_written = len(tiles)

    autotile_dir.mkdir(parents=True, exist_ok=True)
    for role in BLOCKS:
        tile_id = f"{package}_{role}"
        payload = _autotile_json(
            {"en": f"{name.get('en', package)} — {role}",
             "fr": f"{name.get('fr', package)} — {role}"},
            sheet, mappings[role],
            comment=(f"DTEF importé depuis PMDCollab/RawAsset/TileDtef/{source_dir.name} "
                     f"({result.variations} variations, 47 classes d'adjacence). "
                     "Conversion vérifiée contre la table d'adjacence RogueEssence."))
        path = autotile_dir / f"{tile_id}.json"
        if not dry_run:
            path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            _register(tile_id, payload["Object"], autotile_dir)
        result.files.append(str(path.relative_to(ROOT)))
    return result


def _register(tile_id: str, obj: Dict[str, Any], autotile_dir: Path) -> None:
    index_path = autotile_dir / "index.idx"
    if not index_path.exists():
        return
    data = json.loads(index_path.read_text(encoding="utf-8-sig"))
    entries = data["Object"]
    template = None
    for key, value in entries.items():
        if not key.startswith("$") and isinstance(value, dict):
            template = value
            break
    entry = dict(template) if template else {}
    entry["Name"] = obj["Name"]
    entry["Comment"] = obj["Comment"]
    entry["Released"] = True
    entries[tile_id] = entry
    index_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2),
                          encoding="utf-8")
