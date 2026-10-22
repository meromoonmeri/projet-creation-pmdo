"""Ninth PMD Red story batch: Mt. Blaze Peak.

Mt. Blaze Peak (ROM: 3 floors, fixed_room=4 on last floor =
FIXED_ROOM_MT_BLAZE_PEAK_MOLTRES). Reuses the mt_steel generic boss-LoadGen
infrastructure: procedural floors 1-2 + 1 fixed LoadGen boss floor
(mt_blaze_peak_boss.rsmap = pixel-exact d09p03 counterpart, Moltres lvl 32).
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_09"
CONFIG = {
    "mt_blaze_peak": {
        # Peak shares tileset 46 with mt_blaze base; no separate _peak DTEF in PMDO
        "tileset": "mt_blaze", "music": "Mt. Blaze.ogg",
        "profiles": ("blaze_peak_branch", "blaze_peak_lattice"),
        "source_entrance": "d09p02", "source_end": "d09p03",
        "fixed_segments": [
            {
                "role": "canonical_final_boss",
                "map": "mt_blaze_peak_boss",
                "ground": "d09p03",
                "source_floor": 3,
                "provenance": "PMD_RED_ROM",
                "boss_species": ["moltres"],
                "comment": ("PMD Red canonical FIXED_ROOM_MT_BLAZE_PEAK_MOLTRES on "
                            "source floor 3: exact .rsmap counterpart of d09p03.rsground "
                            "(via tools/make_ground_arena.py). Not an unrelated arena."),
            },
        ],
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    "blaze_peak_branch": {"name": "branching", "weight": 22, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "blaze_peak_lattice": {"name": "lattice", "weight": 18, "overrides": {
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
