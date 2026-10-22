"""Bind scenes (from s02_decode) to grounds (from s02_decode_ground).

PMD Red's global ground_map_conversion_table (12-byte records, one per
ground) exposes a `text` field that is a debug ASCII name such as
"../data/ground/ground_data_d01p02_station.c". The last path segment
uniquely identifies which ground the record refers to. We use that
naming convention to attach a canonical ground_id (e.g. "d01p02") to
each conversion entry, then propagate it to Ground_IR objects and to
any Cinematic_IR whose ROM offset falls inside the ground's script
region.

This binding is fully automatic: nothing is hand-fed. If the debug
name convention ever fails to yield a canonical id, we keep the raw
text so downstream stages can still cross-check.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Optional

from converter.pmdred.conversion_table import (
    ConversionEntry,
    ResolvedConversionTable,
)


# Match a canonical ground id inside a debug name like
# ".../ground_data_d01p02_station.c" or ".../ground_data_t01_station.c".
_GID = re.compile(r"ground_data_([a-z][a-z0-9_]{1,15})_station")


@dataclass
class GroundBinding:
    map_file_table_id: int
    canonical_ground_id: Optional[str]   # e.g. "d01p02" or None
    debug_text: str


def canonical_id_from_debug_text(text: str) -> Optional[str]:
    """Extract the canonical ground id from a debug name.

    Returns None if the text does not match the ground_data_<id>_station
    convention, so callers can fall back to the raw text or to an
    index-derived label.
    """
    m = _GID.search(text)
    if not m:
        return None
    return m.group(1)


def build_bindings(table: ResolvedConversionTable) -> list[GroundBinding]:
    """One GroundBinding per entry in the conversion table."""
    out: list[GroundBinding] = []
    for e in table.entries:
        out.append(GroundBinding(
            map_file_table_id=e.map_file_table_id,
            canonical_ground_id=canonical_id_from_debug_text(e.text),
            debug_text=e.text,
        ))
    return out


def bindings_by_map_id(
    bindings: list[GroundBinding],
) -> dict[int, GroundBinding]:
    """Map from map_file_table_id to the corresponding binding."""
    out: dict[int, GroundBinding] = {}
    for b in bindings:
        # Keep first-wins on duplicate map ids (rare, but pret has
        # trailer aliases like MT_FREEZE_PEAK_2 for compatibility).
        out.setdefault(b.map_file_table_id, b)
    return out


def bindings_by_canonical_id(
    bindings: list[GroundBinding],
) -> dict[str, GroundBinding]:
    out: dict[str, GroundBinding] = {}
    for b in bindings:
        if b.canonical_ground_id is not None:
            out.setdefault(b.canonical_ground_id, b)
    return out
