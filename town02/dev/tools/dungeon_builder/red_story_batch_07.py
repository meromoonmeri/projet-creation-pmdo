"""Seventh PMD Red story batch: Mt. Blaze.

Mt. Blaze has 12 procedural floors and no fixed room (all fixed_room=0 in
the ROM manifest). The Moltres fight is on `mt_blaze_peak` (a separate ROM
dungeon), reached via the canonical relay Ground `d09p02` after this
dungeon ends. Reuses the shape of silent_chasm / mt_thunder / mt_freeze:
procedural floors + canonical end Ground.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_07"
CONFIG = {
    "mt_blaze": {
        "tileset": "mt_blaze", "music": "Mt. Blaze.ogg",
        "profiles": ("blaze_branch", "blaze_lattice", "blaze_ring"),
        "source_entrance": "mont_cendre_pied", "source_end": "d09p02",
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    # Mt Blaze: 12 procedural floors, volcanic feel with branching passages
    # and looping caverns. Same tightened grid minima.
    "blaze_branch": {"name": "branching", "weight": 22, "overrides": {
        "grid_x": [5, 8], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "blaze_lattice": {"name": "lattice", "weight": 18, "overrides": {
        "grid_x": [5, 8], "grid_y": [4, 6], "grid_room_ratio": 75,
        "grid_hall_ratio": 55, "connect_percent": 20, "combine_rate": 0,
    }},
    "blaze_ring": {"name": "looping", "weight": 14, "overrides": {
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
