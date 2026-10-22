"""GBA compression signature detection and decompression.

The GBA BIOS exposes several standard decompression routines
(SWI 0x11 LZ77UnCompVram, SWI 0x14 RLUnCompVram, SWI 0x12 HuffUnComp)
that read a small header byte identifying the algorithm and payload
size. Any compressed asset stream in a GBA ROM begins with such a
header. We can therefore *detect* the encoding by inspecting the first
byte at a candidate offset without knowing anything about the game.

Reference: publicly documented GBA BIOS (Nintendo AGB SDK, GBATEK).
No proprietary content is reproduced here.
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum


class CompressionKind(str, Enum):
    LZ77 = "LZ77"           # BIOS SWI 0x11 / 0x12 header 0x10
    RLE = "RLE"             # BIOS SWI 0x14/0x15         header 0x30
    HUFFMAN = "HUFFMAN"     # BIOS SWI 0x13              header 0x24 / 0x28
    RAW = "RAW"             # no known signature
    UNKNOWN = "UNKNOWN"


@dataclass(frozen=True)
class CompressionHeader:
    kind: CompressionKind
    uncompressed_size: int   # 24-bit little-endian size field from the header
    header_byte: int         # the raw signature byte (informational)


def sniff_header(blob: bytes, offset: int = 0) -> CompressionHeader:
    """Inspect the 4 bytes at `blob[offset:offset+4]` and return the
    algorithm and declared decompressed size.

    The GBA compression header is always:
        byte 0    : type nibble in high 4 bits, unit nibble in low 4 bits
        bytes 1-3 : uncompressed size, little-endian (24-bit)
    """
    if offset + 4 > len(blob):
        return CompressionHeader(CompressionKind.UNKNOWN, 0, 0)
    hdr = blob[offset]
    size = blob[offset + 1] | (blob[offset + 2] << 8) | (blob[offset + 3] << 16)

    type_nibble = hdr & 0xF0
    if type_nibble == 0x10:
        kind = CompressionKind.LZ77
    elif type_nibble == 0x20:
        kind = CompressionKind.HUFFMAN  # 0x24 / 0x28 = huffman, 4-bit / 8-bit
    elif type_nibble == 0x30:
        kind = CompressionKind.RLE
    else:
        kind = CompressionKind.UNKNOWN

    return CompressionHeader(kind=kind, uncompressed_size=size, header_byte=hdr)


def decompress_lz77(blob: bytes, offset: int = 0) -> bytes:
    """Decompress a BIOS-format LZ77 stream (SWI 0x11/0x12).

    Format (public, GBA BIOS spec):
      * 4 header bytes: [0x10 | unit, size_lo, size_mid, size_hi]
      * Then blocks. Each block starts with an 8-bit flag byte, one bit
        per following token, MSB first:
          - 0 : the next 1 byte is a literal, output as-is
          - 1 : the next 2 bytes are a back-reference:
                  byte0 hi nibble = (length - 3), lo nibble = disp_hi
                  byte1 = disp_lo
                  displacement = (disp_hi:disp_lo) + 1 bytes back
                  copy `length` bytes from the already-decoded buffer.
    """
    header = sniff_header(blob, offset)
    if header.kind is not CompressionKind.LZ77:
        raise ValueError(
            f"not an LZ77 stream at offset {offset:#x} "
            f"(header byte={header.header_byte:#04x})"
        )

    out = bytearray()
    end_size = header.uncompressed_size
    pos = offset + 4
    n = len(blob)

    while len(out) < end_size:
        if pos >= n:
            raise ValueError("LZ77 stream truncated (flag byte)")
        flag = blob[pos]
        pos += 1
        for bit in range(7, -1, -1):
            if len(out) >= end_size:
                break
            if (flag >> bit) & 1:
                if pos + 2 > n:
                    raise ValueError("LZ77 stream truncated (back-ref)")
                b0 = blob[pos]
                b1 = blob[pos + 1]
                pos += 2
                length = (b0 >> 4) + 3
                disp = (((b0 & 0x0F) << 8) | b1) + 1
                if disp > len(out):
                    raise ValueError(
                        f"LZ77 back-reference underflow: disp={disp}, "
                        f"decoded={len(out)}"
                    )
                start = len(out) - disp
                for i in range(length):
                    out.append(out[start + i])
                    if len(out) >= end_size:
                        break
            else:
                if pos >= n:
                    raise ValueError("LZ77 stream truncated (literal)")
                out.append(blob[pos])
                pos += 1

    # Truncate to declared size in case the last back-reference overshot.
    return bytes(out[:end_size])


def decompress_rle(blob: bytes, offset: int = 0) -> bytes:
    """Decompress a BIOS-format RLE stream (SWI 0x14/0x15).

    Format (public, GBA BIOS spec):
      * 4 header bytes: [0x30, size_lo, size_mid, size_hi]
      * Then tokens. Each token is 1 flag byte:
          - top bit set (0x80..0xFF): compressed run of length
            (flag & 0x7F) + 3, followed by 1 literal byte to repeat.
          - top bit clear (0x00..0x7F): uncompressed run of length
            (flag & 0x7F) + 1, followed by that many literal bytes.
    """
    header = sniff_header(blob, offset)
    if header.kind is not CompressionKind.RLE:
        raise ValueError(
            f"not an RLE stream at offset {offset:#x} "
            f"(header byte={header.header_byte:#04x})"
        )

    out = bytearray()
    end_size = header.uncompressed_size
    pos = offset + 4
    n = len(blob)

    while len(out) < end_size:
        if pos >= n:
            raise ValueError("RLE stream truncated (flag)")
        flag = blob[pos]
        pos += 1
        if flag & 0x80:
            length = (flag & 0x7F) + 3
            if pos >= n:
                raise ValueError("RLE stream truncated (repeat byte)")
            b = blob[pos]
            pos += 1
            for _ in range(length):
                if len(out) >= end_size:
                    break
                out.append(b)
        else:
            length = (flag & 0x7F) + 1
            if pos + length > n:
                raise ValueError("RLE stream truncated (literal run)")
            for i in range(length):
                if len(out) >= end_size:
                    break
                out.append(blob[pos + i])
            pos += length

    return bytes(out[:end_size])
