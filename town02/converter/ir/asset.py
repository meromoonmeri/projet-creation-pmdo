"""Asset_IR: neutral representation of extracted graphical/audio assets.

Kept deliberately minimal: the IR describes *what* the asset is
(tileset chunk, animated tile frame, portrait sprite, music track) and
where it came from in the ROM. Actual pixel/PCM bytes live in
converter/rom_output/ (git-ignored). The IR references them by relative
path + sha256 so mappers can build PMDO assets without loading heavy
buffers into memory unnecessarily.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from converter.ir.provenance import Provenance


@dataclass
class TilesetChunk_IR:
    chunk_index: int
    width_px: int                    # typically 8
    height_px: int                   # typically 8
    palette_index: int
    bytes_ref: str                   # relative path under rom_output/
    bytes_sha256: str
    provenance: Provenance


@dataclass
class Palette_IR:
    palette_index: int
    colour_count: int                # 16 for GBA 4bpp
    bytes_ref: str
    bytes_sha256: str
    provenance: Provenance


@dataclass
class PortraitFrame_IR:
    species_id: int
    emotion: str
    width_px: int
    height_px: int
    bytes_ref: str
    bytes_sha256: str
    provenance: Provenance


@dataclass
class MusicTrack_IR:
    track_key: str                   # canonical name, e.g. from pret constants
    format: str                      # "mp2k" (GBA sound engine)
    bytes_ref: Optional[str] = None  # None if we only reference the track id
    bytes_sha256: Optional[str] = None
    provenance: Optional[Provenance] = None
