"""Fifth PMD Red story batch: Lapis Cave.

Lapis Cave has 14 procedural floors and no fixed room (all fixed_room=0 in
the ROM manifest). All floors use the same tileset 45 and layout 1 in ROM
— a large, single-biome cave dungeon. Reuses the shape of
silent_chasm/great_canyon/mt_thunder: procedural floors + canonical end
Ground scene.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_05"
CONFIG = {
    "lapis_cave": {
        "tileset": "lapis_cave", "music": "Lapis Cave.ogg",
        "profiles": ("lapis_branch", "lapis_lattice", "lapis_ring"),
        # source_entrance/source_end are the canonical Ground ASSET names
        # (not the ROM scene ids d08p01/d08p02 — those are the SCENE codes
        # inside the Ground scripts). This dungeon uses custom canonical
        # names for both entrance and end (grotte_lazuli_seuil /
        # grotte_lazuli_fond), matching the "no dXXpYY UI names" rule.
        "source_entrance": "grotte_lazuli_seuil",
        "source_end": "grotte_lazuli_fond",
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    # Lapis Cave: 14 procedural floors, deep-cave feel with branches,
    # loops and larger chambers to reflect the "cave gallery" biome.
    # Same tightened grid minima as silent_chasm.
    "lapis_branch": {"name": "branching", "weight": 22, "overrides": {
        "grid_x": [5, 8], "grid_y": [4, 6], "room_ratio": [60, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "lapis_lattice": {"name": "lattice", "weight": 18, "overrides": {
        "grid_x": [5, 8], "grid_y": [4, 6], "grid_room_ratio": 75,
        "grid_hall_ratio": 55, "connect_percent": 20, "combine_rate": 0,
    }},
    "lapis_ring": {"name": "looping", "weight": 16, "overrides": {
        "path": "circle", "grid_x": [5, 7], "grid_y": [4, 6],
        "circle_room_ratio": [55, 85], "circle_paths": [2, 4],
        "connect_percent": 20, "combine_rate": 0,
    }},
}


def _context():
    return engine.batch_context(BATCH_ID, CONFIG, PROFILE_SPECS)


def build(write: bool = False):
    with _context():
        return engine.build(write=write)


def record_runtime(jsonl_path: Path, report_path: Path | None = None):
    with _context():
        return engine.record_runtime(jsonl_path, report_path)


def record_routes(route_dir: Path, promote: bool = False):
    with _context():
        return engine.record_routes(route_dir, promote)
