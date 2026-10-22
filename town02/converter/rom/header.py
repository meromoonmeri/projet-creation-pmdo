"""Parse the standard GBA cartridge header.

The GBA header layout is a well-known public specification (Nintendo
AGB Programming Manual). It occupies the first 192 bytes of the ROM
and identifies the cartridge (game code, maker code, version, entry
point, complement check).

We use it for two things:
  * Sanity-check that the file the user dropped in rom_input/ actually
    looks like a GBA cartridge (not e.g. a corrupted download).
  * Read the game_code / maker_code to allow the pipeline to refuse
    ROMs whose code is not the expected PMD Red EU cartridge, even
    before the SHA-256 check runs (fast reject path).
"""
from __future__ import annotations

import struct
from dataclasses import dataclass


# Byte range 0xA0..0xBD contains, in order:
#   12 bytes  game title (ASCII, padded with 0x00)
#   4  bytes  game code   (ASCII)
#   2  bytes  maker code  (ASCII)
#   1  byte   fixed value 0x96
#   1  byte   main unit code
#   1  byte   device type
#   7  bytes  reserved (0)
#   1  byte   software version
#   1  byte   complement check
#   2  bytes  reserved (0)
_TITLE_OFFSET = 0xA0
_HEADER_END = 0xC0
_LOGO_OFFSET = 0x04
_LOGO_LENGTH = 156     # bytes 0x004..0x09F: fixed Nintendo boot logo


@dataclass(frozen=True)
class GbaHeader:
    """Facts about a GBA cartridge header, none of which are game
    content: title / code / maker / version and header sanity flags."""

    game_title: str          # up to 12 ASCII chars, stripped of NULs
    game_code: str           # 4 chars, e.g. "AB7P" for a PAL EU game
    maker_code: str          # 2 chars, e.g. "01"
    fixed_96_ok: bool        # byte at 0xB2 must equal 0x96
    software_version: int    # byte at 0xBC
    complement_check: int    # byte at 0xBD
    header_looks_valid: bool # aggregate: all fixed fields match spec

    @property
    def region_hint(self) -> str:
        """4th char of game_code is the region hint used across the GBA
        library (P = Europe/PAL, E = USA, J = Japan). Purely
        informational."""
        if len(self.game_code) < 4:
            return "?"
        return {
            "P": "EU",
            "E": "US",
            "J": "JP",
            "F": "FR",
            "D": "DE",
            "S": "ES",
            "I": "IT",
        }.get(self.game_code[3], "?")


def _ascii_or_replace(raw: bytes) -> str:
    return raw.rstrip(b"\x00").decode("ascii", errors="replace")


def compute_complement_check(header_bytes: bytes) -> int:
    """Standard GBA header complement over bytes 0xA0..0xBC inclusive.

    Documented publicly. Formula:  chk = -(0x19 + sum(bytes[A0..BC])) & 0xFF
    """
    if len(header_bytes) < _HEADER_END:
        raise ValueError(
            f"need at least {_HEADER_END} bytes to compute the complement"
        )
    s = 0
    for b in header_bytes[_TITLE_OFFSET : _HEADER_END - 3]:
        s += b
    return (-(0x19 + s)) & 0xFF


def read_header(rom_bytes: bytes) -> GbaHeader:
    """Parse a GBA header out of the first bytes of a cartridge.

    Accepts a full ROM or just its first 192 bytes.
    """
    if len(rom_bytes) < _HEADER_END:
        raise ValueError(
            f"rom too short for a GBA header ({len(rom_bytes)} < {_HEADER_END})"
        )

    title = _ascii_or_replace(rom_bytes[_TITLE_OFFSET : _TITLE_OFFSET + 12])
    game_code = _ascii_or_replace(rom_bytes[_TITLE_OFFSET + 12 : _TITLE_OFFSET + 16])
    maker_code = _ascii_or_replace(rom_bytes[_TITLE_OFFSET + 16 : _TITLE_OFFSET + 18])
    fixed_96 = rom_bytes[_TITLE_OFFSET + 18]
    sw_version = rom_bytes[_TITLE_OFFSET + 28]
    complement = rom_bytes[_TITLE_OFFSET + 29]

    fixed_96_ok = fixed_96 == 0x96
    complement_ok = compute_complement_check(rom_bytes) == complement
    # We do NOT check the Nintendo boot logo bytes: reproducing them
    # here would ship copyrighted data. Their presence is not required
    # to identify a cartridge for our purposes.

    header_looks_valid = fixed_96_ok and complement_ok and len(game_code) == 4

    return GbaHeader(
        game_title=title,
        game_code=game_code,
        maker_code=maker_code,
        fixed_96_ok=fixed_96_ok,
        software_version=sw_version,
        complement_check=complement,
        header_looks_valid=header_looks_valid,
    )
