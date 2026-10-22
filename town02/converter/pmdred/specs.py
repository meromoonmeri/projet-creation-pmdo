"""Structural specs used by the PMD Red resolver.

Each spec describes ONLY the fingerprint of a table (expected entry
count from a pret enum, expected compression of the target payloads,
plausible payload-size range). No offsets, no game content.

The resolver picks the ROM candidate that best matches the fingerprint.
If nothing matches, the resolver returns UNRESOLVED with a reason.
"""
from __future__ import annotations

from converter.pmdred.table_resolver import TableSpec
from converter.rom.compression import CompressionKind


# These specs are intentionally permissive on numeric ranges so a small
# change in the pret enum layout does not break resolution. They express
# STRUCTURE, not values.
DEFAULT_SPECS: list[TableSpec] = [
    TableSpec(
        role="dungeon_info_table",
        pret_enum_for_count="DungeonID",
        notes=(
            "Pointer table whose length equals the number of DungeonID "
            "members in pret. Entries point to per-dungeon info records."
        ),
    ),
    TableSpec(
        role="ground_map_table",
        pret_enum_for_count="GroundMapID",
        notes=(
            "Pointer table whose length equals the number of GroundMapID "
            "members. Entries point to per-ground descriptors."
        ),
    ),
    TableSpec(
        role="cutscene_table",
        pret_enum_for_count="CutsceneKind",
        notes=(
            "Pointer table whose length matches the CutsceneKind enum "
            "(pret names the cutscene enum CutsceneKind, not CutsceneID). "
            "Entries point to scripted-sequence bytecode."
        ),
    ),
]
