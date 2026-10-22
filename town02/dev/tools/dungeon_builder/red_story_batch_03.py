"""Third PMD Red story batch: Mt. Steel.

Mt. Steel has 8 procedural floors + 1 fixed floor (floor 9, fixed_room=1) which
is the canonical Skarmory boss chamber (FIXED_ROOM_MT_STEEL_SKARMORY in
pret/pmd-red include/constants/fixed_rooms.h). The fixed room is materialised
as `Data/Map/mt_steel_boss.rsmap`, a pixel-exact counterpart of the canonical
Ground `d03p02.rsground` produced by tools/make_ground_arena.py — geometry,
collision and rendering all mirror d03p02. Skarmory (level 10, PMD_RED_ROM) is
placed in the open chamber; moves and HP are INFERRED from PMDO 0.8.12 base.

The canonical post-battle cinematic "In The Depths Of The Pit" plays on
`d03p02.rsground` immediately after the boss segment is cleared. This mirrors
the sinister_woods precedent (procedural + boss LoadGen + canonical final
Ground) and preserves the invariant "no invented dedicated boss arena".
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_03"
CONFIG = {
    "mt_steel": {
        "tileset": "mt_steel_1", "music": "Mt Steel.ogg",
        "profiles": ("steel_branch", "steel_lattice"),
        "source_entrance": "d03p01", "source_end": "d03p02",
        # The ROM manifest declares floor 9 as fixed_room=1
        # (FIXED_ROOM_MT_STEEL_SKARMORY). Its canonical fight happens on the
        # pixel-exact counterpart of d03p02, rebuilt by
        # tools/make_ground_arena.py.
        "fixed_segments": [
            {
                "role": "canonical_final_boss",
                "map": "mt_steel_boss",
                "ground": "d03p02",
                "source_floor": 9,
                "provenance": "PMD_RED_ROM",
                "comment": ("PMD Red canonical FIXED_ROOM_MT_STEEL_SKARMORY on source "
                            "floor 9: exact .rsmap counterpart of d03p02.rsground "
                            "(via tools/make_ground_arena.py). Not an unrelated arena."),
                # Canonical boss species allow-list for the ROM fixed_room:
                # only these species from the source floor's Pokemon table are
                # treated as the fixed-room roster. Others (Diglett/Aron/etc.)
                # are dungeon-floor spawns, not the boss encounter.
                "boss_species": ["skarmory"],
            },
        ],
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    # Mt Steel: 8 procedural floors, steel-cavern feel with branching paths.
    # Tightened grid minima like silent_chasm to guarantee >20 cells so that
    # the room ratio prunes never leaves us with 3-rooms-no-branches floors.
    "steel_branch": {"name": "branching", "weight": 24, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "steel_lattice": {"name": "lattice", "weight": 18, "overrides": {
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
