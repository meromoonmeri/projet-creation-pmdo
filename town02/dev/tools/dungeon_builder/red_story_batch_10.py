"""Tenth PMD Red story batch: Mt. Freeze Peak.

Mt. Freeze Peak (ROM: 5 floors, fixed_room=6 on last floor = the FIXED_ROOM_
MT_FREEZE_PEAK_NINETALES script event; the actual PMD Red spawn table for
that floor lists MONSTER_GLALIE lvl 20 with probability 10000 — the ROM
Ninetales encounter is a story cutscene actor, the physical fixed_room
spawn is Glalie per data/dungeon/MtFreezePeak/pokemon_found.json). Reuses
the mt_steel generic boss-LoadGen infrastructure.
"""
from __future__ import annotations

from pathlib import Path
from typing import Any

from . import red_story_batch as engine

BATCH_ID = "red_story_10"
CONFIG = {
    "mt_freeze_peak": {
        # Peak shares tileset 47 with mt_freeze base
        "tileset": "mt_freeze", "music": "Mt Freeze.ogg",
        "profiles": ("freeze_peak_branch", "freeze_peak_lattice"),
        "source_entrance": "d11p02", "source_end": "d11p03",
        "fixed_segments": [
            {
                "role": "canonical_final_boss",
                "map": "mt_freeze_peak_boss",
                "ground": "d11p03",
                "source_floor": 5,
                "provenance": "PMD_RED_ROM",
                "boss_species": ["glalie"],
                "comment": ("PMD Red canonical FIXED_ROOM_MT_FREEZE_PEAK_NINETALES on "
                            "source floor 5: exact .rsmap counterpart of d11p03.rsground. "
                            "ROM spawn (pokemon_found.json MtFreezePeak_5F_Pokemon): "
                            "MONSTER_GLALIE lvl 20 prob=10000. Not an unrelated arena."),
            },
        ],
    },
}
PROFILE_SPECS: dict[str, dict[str, Any]] = {
    "freeze_peak_branch": {"name": "branching", "weight": 22, "overrides": {
        "grid_x": [5, 7], "grid_y": [4, 6], "room_ratio": [65, 90],
        "branch_ratio": [50, 85], "connect_percent": 15, "combine_rate": 0,
        "no_forced_branches": False,
    }},
    "freeze_peak_lattice": {"name": "lattice", "weight": 18, "overrides": {
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
