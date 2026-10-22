"""Ground_IR: neutral representation of a PMD Red ground/map.

A "ground" in PMD Red is a scripted overworld area (town, dungeon
entrance, dungeon story floor). The equivalent in PMDO is a `.rsground`
file loaded by RogueEssence GroundMap.

The IR captures the ROM-authoritative structural facts (geometry,
tileset id, layers, collisions, animated tile descriptors, entities,
warps, script hooks) without committing to any PMDO encoding choice.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from converter.ir.provenance import Provenance


@dataclass
class TileLayer_IR:
    """One background layer. `chunk_indices` are indices into the
    tileset's chunk table (BPC), in row-major order width*height."""

    layer_index: int                # 0..N-1, back to front
    width_chunks: int
    height_chunks: int
    chunk_indices: list[int]        # length = width_chunks * height_chunks
    provenance: Provenance


@dataclass
class CollisionLayer_IR:
    """Solid/walkable mask, one bit or one byte per tile depending on
    the ROM layer. Kept as raw bytes; interpretation is done at mapping
    time so we never lose information."""

    layer_index: int
    width_tiles: int
    height_tiles: int
    raw: bytes                       # BMA-collision layer bytes verbatim
    solid_cells: int                 # convenience count
    provenance: Provenance


@dataclass
class BPA_IR:
    """One animated-tile descriptor. Each frame is a chunk key that
    replaces `target_chunk_index` on `frame_ticks_gba[i]` GBA ticks."""

    descriptor_index: int
    target_chunk_index: int
    frames: list[int]                # chunk indices per frame
    frame_ticks_gba: list[int]       # ticks each frame stays visible
    provenance: Provenance


@dataclass
class BMA_IR:
    layers: list[TileLayer_IR]
    collisions: list[CollisionLayer_IR]
    animated: list[BPA_IR]
    unknown_data: Optional[bytes]    # BMA extra region we do not decode yet
    provenance: Provenance


@dataclass
class Entity_IR:
    """A ground entity (NPC, object, spawn marker) as declared by the
    ground's script table. `script_ref` is a label into the SSB script
    space, resolved at decode time."""

    slot: int                        # entity slot in the ground table
    kind: str                        # "npc" | "object" | "spawn" | "marker"
    species_hint: Optional[int]      # ROM species id when applicable
    tile_x: int
    tile_y: int
    facing: str                      # "N"|"S"|"E"|"W"|"NE"|"NW"|"SE"|"SW"
    script_ref: Optional[str]        # label into Script_IR
    provenance: Provenance


@dataclass
class Warp_IR:
    """A warp / transition trigger."""

    trigger_kind: str                # "step_on" | "interact" | "script"
    x: int
    y: int
    w: int = 1                        # box width in tiles
    h: int = 1
    dest_ground: Optional[str] = None
    dest_x: Optional[int] = None
    dest_y: Optional[int] = None
    dest_facing: Optional[str] = None
    provenance: Optional[Provenance] = None


@dataclass
class Ground_IR:
    id: str                          # canonical id, e.g. "d01p02"
    rom_map_file_id: str             # e.g. "MAP_FILE_ID_D01"
    width_tiles: int
    height_tiles: int
    pixel_width: int
    pixel_height: int
    tileset_id: int
    bma: BMA_IR
    entities: list[Entity_IR] = field(default_factory=list)
    warps: list[Warp_IR] = field(default_factory=list)
    script_refs: list[str] = field(default_factory=list)
    provenance: Provenance = field(default=None)  # type: ignore[assignment]
