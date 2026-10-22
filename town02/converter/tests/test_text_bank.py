"""Tests for the text bank decoder.

Synthetic byte blobs only; never uses real game strings.
"""
from __future__ import annotations

from pathlib import Path

from converter.decoders.text_bank import decode_bank, decode_string_at
from converter.rom.rom_file import RomFile


def _synth_rom(tmp_path: Path, payload: bytes) -> Path:
    p = tmp_path / "synth.gba"
    data = bytearray(b"\x00" * 0x1000)
    data[0x100:0x100 + len(payload)] = payload
    p.write_bytes(bytes(data))
    return p


def test_decodes_simple_ascii_string(tmp_path: Path) -> None:
    # Bytes at 0x100: "hello world\0"
    payload = b"hello world\x00"
    p = _synth_rom(tmp_path, payload)
    with RomFile.open(p) as rom:
        d = decode_string_at(rom, 0x100)
    assert d is not None
    assert d.text == "hello world"
    assert d.length_bytes == len(payload)
    assert d.escape_count == 0


def test_decodes_newline_and_escape(tmp_path: Path) -> None:
    # Two lines separated by 0x0A, one 0x7E escape sequence "\7E 32 32"
    # for a double quote glyph. The escape body must be skipped.
    payload = b"one line\x0Aanother\x7E\x32\x32 word\x00"
    p = _synth_rom(tmp_path, payload)
    with RomFile.open(p) as rom:
        d = decode_string_at(rom, 0x100)
    assert d is not None
    assert d.escape_count == 1
    # Escape substituted with a single space marker
    assert "one line" in d.text and "another" in d.text and "word" in d.text


def test_rejects_when_no_terminator(tmp_path: Path) -> None:
    payload = b"no terminator here at all extremely long payload without null"
    p = _synth_rom(tmp_path, payload)
    with RomFile.open(p) as rom:
        d = decode_string_at(rom, 0x100, max_len=8)
    # Max length reached without \0
    assert d is None


def test_rejects_garbage_bytes(tmp_path: Path) -> None:
    payload = b"\xff\xfe\xfd\xfc\xfb\xfa\x00"
    p = _synth_rom(tmp_path, payload)
    with RomFile.open(p) as rom:
        d = decode_string_at(rom, 0x100)
    assert d is None


def test_decode_bank_batches_offsets(tmp_path: Path) -> None:
    # Three strings placed at known offsets.
    p = tmp_path / "synth.gba"
    data = bytearray(b"\x00" * 0x1000)
    data[0x100:0x110] = b"first string\x00\x00\x00\x00"
    data[0x200:0x210] = b"second one\x00\x00\x00\x00\x00\x00"
    data[0x300:0x310] = b"final\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    p.write_bytes(bytes(data))
    with RomFile.open(p) as rom:
        strings, stats = decode_bank(rom, entry_offsets=[0x100, 0x200, 0x300])
    assert stats.strings_decoded == 3
    assert stats.strings_failed == 0
    assert [s.text for s in strings] == ["first string", "second one", "final"]


def test_decode_bank_skips_bad_offsets(tmp_path: Path) -> None:
    p = tmp_path / "synth.gba"
    data = bytearray(b"\x00" * 0x1000)
    data[0x100:0x110] = b"valid\x00" + b"\x00" * 10
    # Offset 0x200 points at garbage.
    data[0x200:0x210] = b"\xff\xff\xff\xff\xff\xff\xff\x00" + b"\x00" * 8
    p.write_bytes(bytes(data))
    with RomFile.open(p) as rom:
        strings, stats = decode_bank(rom, entry_offsets=[0x100, 0x200])
    assert stats.strings_decoded == 1
    assert stats.strings_failed == 1
    assert strings[0].text == "valid"
