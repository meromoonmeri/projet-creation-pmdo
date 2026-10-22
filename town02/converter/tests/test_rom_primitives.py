"""Tests for the generic GBA ROM primitives.

Uses synthetic byte blobs (never any real game content) to prove the
header parser, pointer scanner and BIOS compression decompressors work
against the public GBA spec.
"""
from __future__ import annotations

import io
import struct
from pathlib import Path

import pytest

from converter.rom.compression import (
    CompressionKind,
    decompress_lz77,
    decompress_rle,
    sniff_header,
)
from converter.rom.header import compute_complement_check, read_header
from converter.rom.pointer_scan import iter_pointer_tables
from converter.rom.rom_file import RomFile


# ------------------------------------------------------------------ helpers

def _build_synthetic_header(
    game_title: bytes = b"UNITTEST\x00\x00\x00\x00",
    game_code: bytes = b"UTST",
    maker_code: bytes = b"01",
) -> bytes:
    """Build a minimally valid GBA header. Fills the boot logo area
    with zeros (we never test the logo bytes — reproducing them would
    be inappropriate) and computes the complement check from spec."""
    hdr = bytearray(0xC0)
    # 0xA0..0xAB: 12 bytes game title
    hdr[0xA0:0xAC] = game_title[:12].ljust(12, b"\x00")
    # 0xAC..0xAF: 4 bytes game code
    hdr[0xAC:0xB0] = game_code[:4].ljust(4, b"\x00")
    # 0xB0..0xB1: 2 bytes maker code
    hdr[0xB0:0xB2] = maker_code[:2].ljust(2, b"\x00")
    # 0xB2: fixed 0x96
    hdr[0xB2] = 0x96
    # 0xB3..0xBC: unit / device / reserved / version — leave 0
    # 0xBD: complement check (computed)
    hdr[0xBD] = compute_complement_check(bytes(hdr))
    return bytes(hdr)


def _write_rom(tmp_path: Path, data: bytes) -> Path:
    p = tmp_path / "synthetic.gba"
    p.write_bytes(data)
    return p


# ---------------------------------------------------------------- header


def test_header_roundtrip_valid_complement() -> None:
    hdr = _build_synthetic_header(game_code=b"AB7P", maker_code=b"01")
    parsed = read_header(hdr)
    assert parsed.game_title == "UNITTEST"
    assert parsed.game_code == "AB7P"
    assert parsed.maker_code == "01"
    assert parsed.fixed_96_ok is True
    assert parsed.header_looks_valid is True
    assert parsed.region_hint == "EU"


def test_header_detects_broken_complement() -> None:
    hdr = bytearray(_build_synthetic_header())
    hdr[0xBD] ^= 0xFF                       # corrupt the check byte
    parsed = read_header(bytes(hdr))
    assert parsed.header_looks_valid is False


def test_header_short_rom_rejected() -> None:
    with pytest.raises(ValueError, match="too short"):
        read_header(b"\x00" * 100)


# ------------------------------------------------------------- RomFile


def test_romfile_pointer_translation(tmp_path: Path) -> None:
    # Build a ROM with a pointer at offset 0x1000 pointing to 0x2000
    # (i.e. GBA address 0x08002000).
    data = bytearray(0x4000)
    struct.pack_into("<I", data, 0x1000, 0x08002000)
    p = _write_rom(tmp_path, bytes(data))
    with RomFile.open(p) as rom:
        assert rom.size == 0x4000
        off = rom.read_pointer(0x1000)
        assert off == 0x2000
        # Non-pointer word returns None from the safe accessor.
        assert rom.maybe_read_pointer(0x100) is None


def test_romfile_rejects_out_of_range_pointer(tmp_path: Path) -> None:
    data = bytearray(0x2000)
    # Pointer points past the end of the ROM.
    struct.pack_into("<I", data, 0x100, 0x08FF0000)
    p = _write_rom(tmp_path, bytes(data))
    with RomFile.open(p) as rom:
        assert rom.maybe_read_pointer(0x100) is None
        with pytest.raises(IndexError):
            rom.read_pointer(0x100)


def test_romfile_find_all(tmp_path: Path) -> None:
    data = b"\x00" * 32 + b"MAGIC" + b"\x00" * 100 + b"MAGIC" + b"\x00" * 8
    p = _write_rom(tmp_path, data)
    with RomFile.open(p) as rom:
        hits = rom.find_all(b"MAGIC")
        assert hits == [32, 32 + 5 + 100]


# --------------------------------------------------------- pointer_scan


def test_pointer_scan_finds_synthetic_table(tmp_path: Path) -> None:
    # Build a ROM with one obvious pointer table of 10 entries at 0x1000.
    data = bytearray(0x10000)
    for i in range(10):
        target = 0x08000000 + 0x2000 + i * 0x40
        struct.pack_into("<I", data, 0x1000 + i * 4, target)
    p = _write_rom(tmp_path, bytes(data))
    with RomFile.open(p) as rom:
        tables = [t for t in iter_pointer_tables(rom, min_entries=8)]
        assert any(t.offset == 0x1000 and t.count == 10 for t in tables), (
            f"synthetic 10-pointer table not detected: got {tables}"
        )


# --------------------------------------------------------- compression


def test_compression_sniff_lz77() -> None:
    h = sniff_header(b"\x10\x08\x00\x00")   # LZ77 header, 8 bytes uncompressed
    assert h.kind is CompressionKind.LZ77
    assert h.uncompressed_size == 8


def test_compression_sniff_rle() -> None:
    h = sniff_header(b"\x30\x0A\x00\x00")
    assert h.kind is CompressionKind.RLE
    assert h.uncompressed_size == 10


def test_lz77_decompress_pure_literals() -> None:
    # 8-byte payload of literals only: flag=0x00 means 8 literal bytes.
    body = bytes(range(8))
    stream = b"\x10\x08\x00\x00" + b"\x00" + body
    got = decompress_lz77(stream)
    assert got == body


def test_lz77_decompress_backreference() -> None:
    # Build: emit 4 literal bytes (ABCD), then back-reference of length 4
    # displacement 4 (=> repeat ABCD). Total output = 8 bytes ABCDABCD.
    # Flag layout, MSB first: bits 7..4 = literals (0), bits 3 = back-ref (1),
    # bits 2..0 = ignored (output already reaches 8 bytes).
    flag = 0b0000_1000
    # back-ref: length=4 -> (length-3)=1 in high nibble; disp=4 -> (disp-1)=3
    # so b0 = (1<<4) | ((3 >> 8) & 0x0F) = 0x10, b1 = 3 & 0xFF = 0x03
    stream = (
        b"\x10\x08\x00\x00"
        + bytes([flag])
        + b"ABCD"
        + bytes([0x10, 0x03])
    )
    got = decompress_lz77(stream)
    assert got == b"ABCDABCD"


def test_rle_decompress_mixed() -> None:
    # RLE: 3 literals (AB C), then compressed run of 5 'Z', total 8 bytes.
    # Literal token flag: (len-1)=2 => 0x02, then 3 bytes.
    # Repeat token flag: high bit set + (len-3)=2 => 0x82, then 'Z'.
    stream = (
        b"\x30\x08\x00\x00"
        + bytes([0x02]) + b"ABC"
        + bytes([0x82]) + b"Z"
    )
    got = decompress_rle(stream)
    assert got == b"ABCZZZZZ"
