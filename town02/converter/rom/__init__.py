"""Generic GBA ROM inspection primitives.

Nothing here is PMD Red specific: this package implements the format
recipes for the GBA cartridge itself (header, memory map, pointer
encoding, common compression signatures). Every function reads bytes
the user provided locally and returns typed structures; no ROM content
is ever bundled with the repository.

Reference: publicly documented GBA cartridge format (Nintendo AGB
Programming Manual, GBATEK homebrew reference). No Nintendo assets or
game data are reproduced here.
"""
from converter.rom.header import GbaHeader, read_header
from converter.rom.rom_file import RomFile

__all__ = ["GbaHeader", "read_header", "RomFile"]
