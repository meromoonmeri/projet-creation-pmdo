from __future__ import annotations

import hashlib
import io
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import BinaryIO

from PIL import Image

from .constants import TILE_SIZE
from .util import atomic_write_json, sha256_file


@dataclass(frozen=True)
class TileEntry:
    relative_offset: int
    size: int


class TileArchive:
    def __init__(self, path: Path, number: int):
        self.path = path
        self.number = number
        with path.open("rb") as stream:
            header = stream.read(8)
            if len(header) != 8:
                raise ValueError(f"{path}: truncated dimensions")
            self.width, self.height = struct.unpack("<ii", header)
            self.tile_count = (self.width // TILE_SIZE) * (self.height // TILE_SIZE)
            self.entries = []
            for _ in range(self.tile_count):
                raw = stream.read(12)
                if len(raw) != 12:
                    raise ValueError(f"{path}: truncated tile index")
                self.entries.append(TileEntry(*struct.unpack("<qi", raw)))
            self.header_size = stream.tell()
        self._stream: BinaryIO | None = None
        self._cache: dict[int, Image.Image] = {}

    def __enter__(self):
        self._stream = self.path.open("rb")
        return self

    def __exit__(self, *_):
        if self._stream:
            self._stream.close()
        self._stream = None
        self._cache.clear()

    def encoded_tile(self, tile_number: int) -> bytes:
        if not 0 <= tile_number < self.tile_count:
            tile_number = 0  # Exact Tileset.GetTileGraphic fallback.
        entry = self.entries[tile_number]
        stream = self._stream
        close = False
        if stream is None:
            stream = self.path.open("rb"); close = True
        try:
            stream.seek(self.header_size + entry.relative_offset)
            data = stream.read(entry.size)
        finally:
            if close:
                stream.close()
        if len(data) != entry.size:
            raise ValueError(f"{self.path}: tile {tile_number} truncated")
        return data

    def image(self, tile_number: int) -> Image.Image:
        if not 0 <= tile_number < self.tile_count:
            tile_number = 0
        cached = self._cache.get(tile_number)
        if cached is None:
            with Image.open(io.BytesIO(self.encoded_tile(tile_number))) as image:
                cached = image.convert("RGBA")
                cached.load()
            if cached.size != (TILE_SIZE, TILE_SIZE):
                raise ValueError(f"{self.path}: tile {tile_number} is {cached.size}, expected 32x32")
            self._cache[tile_number] = cached
        return cached


def audit_tilesets(directory: Path, report_path: Path, atlas_directory: Path | None = None) -> dict:
    entries = []
    total_tiles = 0
    for path in sorted(directory.glob("Tiles*.tile"), key=lambda value: int(value.stem.removeprefix("Tiles"))):
        number = int(path.stem.removeprefix("Tiles"))
        archive = TileArchive(path, number)
        position_errors = []
        image_errors = []
        previous_end = 0
        encodings: dict[str, int] = {}
        atlas_validation = None
        atlas_path = atlas_directory / f"Tiles{number}.png" if atlas_directory else None
        atlas = None
        if atlas_path and atlas_path.exists():
            atlas = Image.open(atlas_path).convert("RGBA")
            atlas_validation = {
                "path": str(atlas_path), "sha256": sha256_file(atlas_path),
                "dimensions": list(atlas.size), "matching_tiles_rgba": 0,
                "matching_tiles_composited_white": 0, "different_tile_ids": [],
                "role": "independent historical PMD-Toolkit validation only; .tile remains rendering authority",
            }
        with archive:
            for tile_number, entry in enumerate(archive.entries):
                if entry.relative_offset < previous_end:
                    position_errors.append(tile_number)
                previous_end = entry.relative_offset + entry.size
                try:
                    encoded = archive.encoded_tile(tile_number)
                    encoding = "PNG" if encoded.startswith(b"\x89PNG\r\n\x1a\n") else "other"
                    encodings[encoding] = encodings.get(encoding, 0) + 1
                    image = archive.image(tile_number)
                    if atlas is not None and atlas_validation is not None:
                        columns = archive.width // TILE_SIZE
                        x = (tile_number % columns) * TILE_SIZE
                        y = (tile_number // columns) * TILE_SIZE
                        reference = atlas.crop((x, y, x + TILE_SIZE, y + TILE_SIZE))
                        if image.tobytes() == reference.tobytes():
                            atlas_validation["matching_tiles_rgba"] += 1
                        left = Image.new("RGBA", (TILE_SIZE, TILE_SIZE), "white"); left.alpha_composite(image)
                        right = Image.new("RGBA", (TILE_SIZE, TILE_SIZE), "white"); right.alpha_composite(reference)
                        if left.tobytes() == right.tobytes():
                            atlas_validation["matching_tiles_composited_white"] += 1
                        else:
                            atlas_validation["different_tile_ids"].append(tile_number)
                except Exception as exc:  # audited and surfaced, never silently substituted
                    image_errors.append({"tile": tile_number, "error": str(exc)})
        if atlas is not None:
            atlas.close()
        payload_end = archive.header_size + max((e.relative_offset + e.size for e in archive.entries), default=0)
        entry = {
            "tileset": number, "path": str(path), "sha256": sha256_file(path),
            "width": archive.width, "height": archive.height, "tile_count": archive.tile_count,
            "header_size": archive.header_size, "file_size": path.stat().st_size,
            "indexed_payload_end": payload_end, "trailing_bytes": path.stat().st_size - payload_end,
            "position_errors": position_errors, "image_errors": image_errors,
            "encodings": encodings, "historical_atlas_validation": atlas_validation,
            "status": "EXTRACTED" if not position_errors and not image_errors and payload_end == path.stat().st_size else "PARTIAL",
        }
        entries.append(entry); total_tiles += archive.tile_count
    report = {
        "status": "EXTRACTED" if entries and all(e["status"] == "EXTRACTED" for e in entries) else "PARTIAL",
        "source_directory": str(directory), "tileset_count": len(entries), "tile_count": total_tiles,
        "tile_size": [TILE_SIZE, TILE_SIZE], "tilesets": entries,
    }
    atomic_write_json(report_path, report)
    return report
