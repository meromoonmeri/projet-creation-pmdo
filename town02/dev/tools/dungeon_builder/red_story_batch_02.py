"""Second PMD Red story batch: Silent Chasm and Great Canyon.

Mt. Steel is deliberately excluded: its source floor 9 is fixed room 1 and
requires an exact Ground-to-rsmap counterpart before reconciliation.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_02"
CONFIG = {
    "silent_chasm": {
        "tileset": "silent_chasm", "music": "Silent Chasm.ogg",
        "profiles": ("silent_ring", "silent_lattice"),
        "source_entrance": "d05p01", "source_end": "d05p02",
    },
    "great_canyon": {
        "tileset": "great_canyon", "music": "Great Canyon.ogg",
        "profiles": ("canyon_ring", "canyon_lattice"),
        "source_entrance": "d07p01", "source_end": "d07p02",
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    # Silent Chasm: 9 procedural floors, tight rock/cave feel with alt paths.
    # Grid width raised to [5, 7] and height to [4, 6] so every seed lands on
    # >=20 cells before the room ratio prunes any of them (65% -> 13+ rooms),
    # which eliminates the low-count "3 rooms 4 halls no branch" invalid floors
    # observed on the initial runtime pass.
    "silent_ring": {"name": "ring", "weight": 24, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "circle_room_ratio": [65, 90],
        "circle_paths": [2, 4], "connect_percent": 25, "combine_rate": 0,
    }},
    "silent_lattice": {"name": "lattice", "weight": 18, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "grid_room_ratio": 80,
        "grid_hall_ratio": 55, "connect_percent": 25, "combine_rate": 0,
    }},
    # Great Canyon: 12 procedural floors, wider corridors and tiered layout.
    # Same tightening on the grid minima. combine_rate lowered to 0 so
    # RogueElements never merges two neighbor rooms into a single cell
    # (that was the direct cause of "3 rooms, 0 branches" great_canyon floors).
    "canyon_ring": {"name": "ring", "weight": 22, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "cell_width": [10, 14],
        "cell_height": [8, 12], "circle_room_ratio": [60, 90],
        "circle_paths": [2, 4], "connect_percent": 25, "combine_rate": 0,
    }},
    "canyon_lattice": {"name": "lattice", "weight": 18, "overrides": {
        "grid_x": [5, 8], "grid_y": [4, 6], "cell_width": [10, 15],
        "cell_height": [8, 13], "grid_room_ratio": 75,
        "grid_hall_ratio": 55, "connect_percent": 25, "combine_rate": 0,
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
