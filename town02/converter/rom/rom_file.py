"""RomFile: memory-mapped read-only view of the user's local ROM.

Never keeps the ROM contents in the repository. The RomFile object
exposes byte-range accessors and pointer resolution helpers so higher
stages can read the local file without re-implementing IO plumbing.
"""
from __future__ import annotations

import hashlib
import mmap
import os
import struct
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator, Optional


# GBA memory map: cartridge ROM is visible in three mirrored windows
# 0x08000000..0x0DFFFFFF. Any 32-bit word whose top byte is 0x08 or 0x09
# and whose bottom bits are word-aligned is a plausible ROM pointer.
GBA_ROM_BASE = 0x08000000
GBA_ROM_MAX  = 0x0A000000    # we accept 0x08 and 0x09 as ROM prefixes


class RomFile:
    """Read-only wrapper around a local GBA ROM.

    Usage:
        with RomFile.open(path) as rom:
            head = rom.read(0, 0xC0)
            ptr  = rom.read_pointer(0x1234)   # returns rom-relative offset
    """

    def __init__(self, path: Path, mm: mmap.mmap):
        self._path = path
        self._mm = mm
        self._size = len(mm)
        self._sha256: Optional[str] = None

    # -- lifecycle -----------------------------------------------------

    @classmethod
    @contextmanager
    def open(cls, path: Path) -> Iterator["RomFile"]:
        with path.open("rb") as fh:
            mm = mmap.mmap(fh.fileno(), 0, access=mmap.ACCESS_READ)
            try:
                yield cls(path, mm)
            finally:
                mm.close()

    @property
    def path(self) -> Path:
        return self._path

    @property
    def size(self) -> int:
        return self._size

    # -- content hash --------------------------------------------------

    def sha256(self) -> str:
        """Compute the ROM SHA-256 once and cache it."""
        if self._sha256 is None:
            h = hashlib.sha256()
            # mmap supports slicing, but hashing a slice would copy
            # everything into RAM; iterate in 1 MiB blocks instead.
            step = 1 << 20
            for start in range(0, self._size, step):
                h.update(self._mm[start : start + step])
            self._sha256 = h.hexdigest()
        return self._sha256

    # -- raw reads -----------------------------------------------------

    def read(self, offset: int, length: int) -> bytes:
        """Read `length` bytes starting at file-relative `offset`."""
        if offset < 0 or length < 0 or offset + length > self._size:
            raise IndexError(
                f"read out of range: offset={offset:#x} length={length} "
                f"size={self._size:#x}"
            )
        return bytes(self._mm[offset : offset + length])

    def read_u8(self, offset: int) -> int:
        return self._mm[offset]

    def read_u16(self, offset: int) -> int:
        return struct.unpack_from("<H", self._mm, offset)[0]

    def read_u32(self, offset: int) -> int:
        return struct.unpack_from("<I", self._mm, offset)[0]

    # -- ARM pointer helpers ------------------------------------------

    @staticmethod
    def looks_like_rom_pointer(word: int) -> bool:
        """True if `word` is a plausible ARM pointer into cartridge ROM."""
        return GBA_ROM_BASE <= word < GBA_ROM_MAX and (word & 0x3) == 0

    def pointer_to_offset(self, pointer: int) -> int:
        """Translate a GBA-address pointer to a file-relative offset."""
        if not self.looks_like_rom_pointer(pointer):
            raise ValueError(f"not a ROM pointer: {pointer:#010x}")
        off = pointer & 0x01FFFFFF
        if off >= self._size:
            raise IndexError(
                f"pointer {pointer:#010x} -> offset {off:#x} beyond "
                f"ROM size {self._size:#x}"
            )
        return off

    def read_pointer(self, offset: int) -> int:
        """Read a 32-bit little-endian word and return the file-relative
        offset it points to. Raises if the word is not a ROM pointer."""
        word = self.read_u32(offset)
        return self.pointer_to_offset(word)

    def maybe_read_pointer(self, offset: int) -> Optional[int]:
        """Same as read_pointer but returns None instead of raising when
        the word does not look like a ROM pointer."""
        word = self.read_u32(offset)
        if not self.looks_like_rom_pointer(word):
            return None
        off = word & 0x01FFFFFF
        if off >= self._size:
            return None
        return off

    # -- pattern search ------------------------------------------------

    def find(self, needle: bytes, *, start: int = 0, limit: int = -1) -> int:
        """Return the first offset >= start where `needle` appears, or -1."""
        end = self._size if limit < 0 else min(self._size, start + limit)
        idx = self._mm.find(needle, start, end)
        return idx

    def find_all(self, needle: bytes, *, start: int = 0,
                 limit: int = -1, max_hits: int = 10_000) -> list[int]:
        end = self._size if limit < 0 else min(self._size, start + limit)
        hits: list[int] = []
        pos = start
        while len(hits) < max_hits:
            idx = self._mm.find(needle, pos, end)
            if idx < 0:
                break
            hits.append(idx)
            pos = idx + 1
        return hits
