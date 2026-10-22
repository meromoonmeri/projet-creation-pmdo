"""Text bank decoder for PMD Red.

PMD Red stores its user-facing strings in region tables where each
entry is a small header pointing at a null-terminated payload encoded
against the charmap documented in the pret decompilation.

The encoding is largely ASCII-transparent (0x20..0x7E map to themselves
one-to-one, 0x00 terminates, 0x0A is newline), with a small set of
multi-byte escape sequences that begin with 0x7E for characters not
representable directly. We accept both direct ASCII byte runs and 0x7E
escape sequences (skipping the escape body so the decoded string keeps
a readable core even when we cannot yet name the escape).

This decoder never reads game bytes from the repository. It consumes a
byte slice fetched by s01 from the user's local ROM.
"""
from __future__ import annotations

import string
from dataclasses import dataclass, field
from typing import Optional

from converter.rom.rom_file import RomFile


# Byte marker used by pret's charmap for multi-byte escape sequences
# (e.g. quotes, comma variants, and various special glyphs).
_ESC = 0x7E
# Newline byte per charmap
_NL = 0x0A
# Terminator
_END = 0x00


_ASCII_ALLOWED = frozenset(
    ord(c) for c in
    string.ascii_letters + string.digits + string.punctuation + " "
)


@dataclass
class DecodedString:
    rom_offset: int              # file-relative start of the payload
    length_bytes: int            # bytes consumed including terminator
    text: str                    # best-effort ASCII decoding
    escape_count: int            # number of 0x7E escape sequences skipped


def decode_string_at(
    rom: RomFile, offset: int, *,
    max_len: int = 512,
) -> Optional[DecodedString]:
    """Decode one string at `offset` in the ROM.

    Returns None if the bytes there do not look like a plausible
    PMD-Red-encoded string (no terminator inside `max_len`, too many
    non-printable non-escape bytes, empty payload, etc.).
    """
    if offset < 0 or offset >= rom.size:
        return None
    end = min(rom.size, offset + max_len)
    data = rom.read(offset, end - offset)

    out = bytearray()
    esc_count = 0
    printable = 0
    non_printable = 0
    i = 0
    consumed = 0
    while i < len(data):
        b = data[i]
        if b == _END:
            consumed = i + 1
            break
        if b == _ESC:
            # Escape: byte 0x7E followed by up to 2 bytes describing
            # a special glyph. We skip them from the decoded text to
            # keep the ASCII core clean; the raw bytes are still
            # counted so callers can decide if the string is trusted.
            esc_count += 1
            i += 1
            # Peek up to 2 continuation bytes; stop at 0x00 or 0x0A.
            for _ in range(2):
                if i >= len(data):
                    break
                cb = data[i]
                if cb == _END or cb == _NL:
                    break
                i += 1
            out.append(ord(" "))
            continue
        if b == _NL:
            out.append(ord("\n"))
            i += 1
            continue
        if b in _ASCII_ALLOWED:
            out.append(b)
            printable += 1
            i += 1
            continue
        # Anything else is a non-printable in this bank: bail out so
        # we do not misclassify garbage bytes as a string.
        non_printable += 1
        if non_printable > 2:
            return None
        i += 1

    if not consumed:
        return None
    if printable < 3:
        return None
    try:
        text = out.decode("ascii")
    except UnicodeDecodeError:
        return None
    return DecodedString(
        rom_offset=offset,
        length_bytes=consumed,
        text=text.strip(),
        escape_count=esc_count,
    )


@dataclass
class TextBankStats:
    strings_decoded: int = 0
    strings_failed: int = 0
    bytes_consumed: int = 0


def decode_bank(
    rom: RomFile, *,
    entry_offsets: list[int],
    per_entry_max_len: int = 512,
) -> tuple[list[DecodedString], TextBankStats]:
    """Decode a batch of strings whose starting offsets are known.

    Callers provide `entry_offsets` (typically the pointer targets of
    a text-pointer table). The decoder returns one DecodedString per
    entry, in the same order; entries that fail decoding are omitted
    from the result but counted in stats.strings_failed.
    """
    out: list[DecodedString] = []
    stats = TextBankStats()
    for off in entry_offsets:
        d = decode_string_at(rom, off, max_len=per_entry_max_len)
        if d is None:
            stats.strings_failed += 1
            continue
        out.append(d)
        stats.strings_decoded += 1
        stats.bytes_consumed += d.length_bytes
    return out, stats
