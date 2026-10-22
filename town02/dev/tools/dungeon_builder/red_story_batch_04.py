"""Fourth PMD Red story batch: Mt. Thunder.

Mt. Thunder has 10 procedural floors and no fixed room (all fixed_room=0 in
the ROM manifest). The Zapdos fight is on the next dungeon `mt_thunder_peak`
(a separate ROM dungeon), reached via the canonical relay Ground `d06p02`
(scene "Mt. Thunder" from PMD Red). Since there is no fixed_room in this
dungeon, the batch uses the same shape as silent_chasm/great_canyon:
procedural floors + transition to the canonical final Ground.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_04"
CONFIG = {
    "mt_thunder": {
        "tileset": "mt_thunder", "music": "Mt. Thunder.ogg",
        "profiles": ("thunder_branch", "thunder_lattice"),
        "source_entrance": "d06p01", "source_end": "d06p02",
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    # Mt Thunder: 10 procedural floors, mountain-storm feel with branches
    # and looping alternatives. Same tightened grid minima as silent_chasm
    # so the room-ratio pruning never leaves a 3-rooms-no-branches floor.
    "thunder_branch": {"name": "branching", "weight": 24, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "thunder_lattice": {"name": "lattice", "weight": 18, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "grid_room_ratio": 75,
        "grid_hall_ratio": 55, "connect_percent": 20, "combine_rate": 0,
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
