"""Eighth PMD Red story batch: Mt. Thunder Peak.

Mt. Thunder Peak (ROM: 3 floors, fixed_room=3 on last floor =
FIXED_ROOM_MT_THUNDER_PEAK_ZAPDOS). Reuses the mt_steel generic boss-LoadGen
infrastructure: procedural floors 1-2 + 1 fixed LoadGen boss floor
(mt_thunder_peak_boss.rsmap = pixel-exact d06p03 counterpart, Zapdos lvl 25).

The player enters this dungeon canonically via `d06p02.Enter` after clearing
mt_thunder; the validator uses `d06p02` as its entrance Ground (which chains
directly into EnterDungeon('mt_thunder_peak', ...)) and reaches `d06p03` as
the canonical final Ground after the boss segment.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_08"
CONFIG = {
    "mt_thunder_peak": {
        "tileset": "mt_thunder_peak", "music": "Mt. Thunder.ogg",
        "profiles": ("thunder_peak_branch", "thunder_peak_lattice"),
        "source_entrance": "d06p02", "source_end": "d06p03",
        "fixed_segments": [
            {
                "role": "canonical_final_boss",
                "map": "mt_thunder_peak_boss",
                "ground": "d06p03",
                "source_floor": 3,
                "provenance": "PMD_RED_ROM",
                "boss_species": ["zapdos"],
                "comment": ("PMD Red canonical FIXED_ROOM_MT_THUNDER_PEAK_ZAPDOS on "
                            "source floor 3: exact .rsmap counterpart of d06p03.rsground "
                            "(via tools/make_ground_arena.py). Not an unrelated arena."),
            },
        ],
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    "thunder_peak_branch": {"name": "branching", "weight": 22, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "thunder_peak_lattice": {"name": "lattice", "weight": 18, "overrides": {
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
