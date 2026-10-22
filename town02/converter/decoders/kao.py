"""Kao (portrait) decoder — placeholder.

Portraits in PMD Red are packed in a shared Kao container: one record
per species, each record holding a small set of emotion frames encoded
with the standard GBA compression (AT4PX/AT4PN). The container layout
is public via SkyTemple documentation.

The decoder will:
  1. Read the Kao table (offset from registry).
  2. For each species we actually need (portrait references collected
     from decoded scripts), decompress the requested emotion frame(s).
  3. Return Asset_IR entries mapping (species_id, emotion) -> pixel
     grid + palette.

Current status: not implemented. Raises rather than returning stubs.
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str):
    raise NotImplementedError(
        "Kao decoder not implemented yet. Wire the AT4PX/AT4PN "
        "decompressor first (skytemple-files has an MIT reference)."
    )
