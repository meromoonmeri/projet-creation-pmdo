#!/usr/bin/env python3
"""Minimal deterministic PNG RGB/RGBA codec used by BIBLIOTHEQUE previews."""

from __future__ import annotations

import binascii
import struct
import zlib
from dataclasses import dataclass
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


@dataclass
class RGBAImage:
    width: int
    height: int
    pixels: bytearray

    @classmethod
    def empty(cls, width: int, height: int, color=(0, 0, 0, 0)) -> "RGBAImage":
        if width <= 0 or height <= 0:
            raise ValueError("image dimensions must be positive")
        return cls(width, height, bytearray(bytes(color) * (width * height)))

    def crop(self, x: int, y: int, width: int, height: int) -> "RGBAImage":
        if x < 0 or y < 0 or x + width > self.width or y + height > self.height:
            raise ValueError("crop outside image")
        result = self.empty(width, height)
        for row in range(height):
            src = ((y + row) * self.width + x) * 4
            dst = row * width * 4
            result.pixels[dst : dst + width * 4] = self.pixels[src : src + width * 4]
        return result

    def blit_replace(self, source: "RGBAImage", x: int, y: int) -> None:
        for row in range(source.height):
            if y + row < 0 or y + row >= self.height:
                continue
            left = max(0, -x)
            right = min(source.width, self.width - x)
            if left >= right:
                continue
            src = (row * source.width + left) * 4
            dst = ((y + row) * self.width + x + left) * 4
            self.pixels[dst : dst + (right - left) * 4] = source.pixels[
                src : src + (right - left) * 4
            ]

    def alpha_over(self, source: "RGBAImage", x: int = 0, y: int = 0) -> None:
        for sy in range(source.height):
            dy = y + sy
            if dy < 0 or dy >= self.height:
                continue
            for sx in range(source.width):
                dx = x + sx
                if dx < 0 or dx >= self.width:
                    continue
                si = (sy * source.width + sx) * 4
                sa = source.pixels[si + 3]
                if sa == 0:
                    continue
                di = (dy * self.width + dx) * 4
                if sa == 255:
                    self.pixels[di : di + 4] = source.pixels[si : si + 4]
                    continue
                da = self.pixels[di + 3]
                out_a = sa + (da * (255 - sa) + 127) // 255
                if out_a == 0:
                    self.pixels[di : di + 4] = b"\0\0\0\0"
                    continue
                for channel in range(3):
                    src_premul = source.pixels[si + channel] * sa
                    dst_premul = self.pixels[di + channel] * da
                    out_premul = src_premul + (dst_premul * (255 - sa) + 127) // 255
                    self.pixels[di + channel] = min(255, (out_premul + out_a // 2) // out_a)
                self.pixels[di + 3] = out_a

    def fill_rect(self, x: int, y: int, width: int, height: int, color) -> None:
        x0, y0 = max(0, x), max(0, y)
        x1, y1 = min(self.width, x + width), min(self.height, y + height)
        if x0 >= x1 or y0 >= y1:
            return
        row = bytes(color) * (x1 - x0)
        for py in range(y0, y1):
            start = (py * self.width + x0) * 4
            self.pixels[start : start + len(row)] = row

    def outline_rect(self, x: int, y: int, width: int, height: int, color, thickness=2) -> None:
        self.fill_rect(x, y, width, thickness, color)
        self.fill_rect(x, y + height - thickness, width, thickness, color)
        self.fill_rect(x, y, thickness, height, color)
        self.fill_rect(x + width - thickness, y, thickness, height, color)


def _paeth(left: int, up: int, upper_left: int) -> int:
    estimate = left + up - upper_left
    pa = abs(estimate - left)
    pb = abs(estimate - up)
    pc = abs(estimate - upper_left)
    if pa <= pb and pa <= pc:
        return left
    if pb <= pc:
        return up
    return upper_left


def load_png(path: Path | str) -> RGBAImage:
    data = Path(path).read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError(f"not PNG: {path}")
    position = len(PNG_SIGNATURE)
    idat = bytearray()
    palette = None
    palette_alpha = None
    transparent_rgb = None
    transparent_gray = None
    width = height = depth = color_type = interlace = None
    while position < len(data):
        length = struct.unpack(">I", data[position : position + 4])[0]
        kind = data[position + 4 : position + 8]
        payload = data[position + 8 : position + 8 + length]
        expected_crc = struct.unpack(">I", data[position + 8 + length : position + 12 + length])[0]
        actual_crc = binascii.crc32(kind + payload) & 0xFFFFFFFF
        if expected_crc != actual_crc:
            raise ValueError(f"PNG CRC mismatch in {path}: {kind!r}")
        position += 12 + length
        if kind == b"IHDR":
            width, height, depth, color_type, _, _, interlace = struct.unpack(">IIBBBBB", payload)
        elif kind == b"PLTE":
            palette = [tuple(payload[i : i + 3]) for i in range(0, len(payload), 3)]
        elif kind == b"tRNS":
            if color_type == 3:
                palette_alpha = payload
            elif color_type == 2 and len(payload) == 6:
                transparent_rgb = tuple(value >> 8 for value in struct.unpack(">HHH", payload))
            elif color_type == 0 and len(payload) == 2:
                transparent_gray = struct.unpack(">H", payload)[0] >> 8
        elif kind == b"IDAT":
            idat.extend(payload)
        elif kind == b"IEND":
            break
    supported_depth = depth == 8 or (color_type == 3 and depth in (1, 2, 4))
    if not supported_depth or interlace != 0 or color_type not in (0, 2, 3, 4, 6):
        raise ValueError(
            f"unsupported PNG format depth={depth} color={color_type} interlace={interlace}: {path}"
        )
    channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[color_type]
    # PNG filters operate on bytes. Packed indexed rows still use one byte as
    # the left-pixel distance even when each byte stores 2, 4, or 8 samples.
    bytes_per_pixel = max(1, (channels * depth + 7) // 8)
    packed = zlib.decompress(bytes(idat))
    stride = (width * channels * depth + 7) // 8
    if len(packed) != height * (stride + 1):
        raise ValueError(f"PNG scanline size mismatch: {path}")
    rows = []
    cursor = 0
    previous = bytearray(stride)
    for _ in range(height):
        filter_type = packed[cursor]
        cursor += 1
        raw = bytearray(packed[cursor : cursor + stride])
        cursor += stride
        decoded = bytearray(stride)
        for index, value in enumerate(raw):
            left = decoded[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
            up = previous[index]
            upper_left = previous[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
            if filter_type == 0:
                result = value
            elif filter_type == 1:
                result = value + left
            elif filter_type == 2:
                result = value + up
            elif filter_type == 3:
                result = value + ((left + up) // 2)
            elif filter_type == 4:
                result = value + _paeth(left, up, upper_left)
            else:
                raise ValueError(f"unsupported PNG filter {filter_type}: {path}")
            decoded[index] = result & 0xFF
        rows.append(decoded)
        previous = decoded
    rgba = bytearray(width * height * 4)
    output = 0
    for row in rows:
        if color_type == 6:
            rgba[output : output + width * 4] = row
            output += width * 4
        elif color_type == 2:
            for index in range(0, len(row), 3):
                rgb = tuple(row[index : index + 3])
                rgba[output : output + 3] = bytes(rgb)
                rgba[output + 3] = 0 if transparent_rgb == rgb else 255
                output += 4
        elif color_type == 4:
            for index in range(0, len(row), 2):
                gray, alpha = row[index : index + 2]
                rgba[output : output + 4] = bytes((gray, gray, gray, alpha))
                output += 4
        elif color_type == 0:
            for gray in row:
                alpha = 0 if transparent_gray == gray else 255
                rgba[output : output + 4] = bytes((gray, gray, gray, alpha))
                output += 4
        else:
            if palette is None:
                raise ValueError(f"indexed PNG has no palette: {path}")
            if depth == 8:
                palette_indices = list(row[:width])
            else:
                palette_indices = []
                mask = (1 << depth) - 1
                samples_per_byte = 8 // depth
                for value in row:
                    for sample in range(samples_per_byte):
                        shift = 8 - depth * (sample + 1)
                        palette_indices.append((value >> shift) & mask)
                        if len(palette_indices) == width:
                            break
                    if len(palette_indices) == width:
                        break
            if len(palette_indices) != width:
                raise ValueError(f"indexed PNG row is truncated: {path}")
            for palette_index in palette_indices:
                if palette_index >= len(palette):
                    raise ValueError(f"indexed PNG palette reference is outside PLTE: {path}")
                rgba[output : output + 3] = bytes(palette[palette_index])
                rgba[output + 3] = (
                    palette_alpha[palette_index]
                    if palette_alpha is not None and palette_index < len(palette_alpha)
                    else 255
                )
                output += 4
    return RGBAImage(width, height, rgba)


def _chunk(kind: bytes, payload: bytes) -> bytes:
    return (
        struct.pack(">I", len(payload))
        + kind
        + payload
        + struct.pack(">I", binascii.crc32(kind + payload) & 0xFFFFFFFF)
    )


def png_bytes(image: RGBAImage) -> bytes:
    """Encode an image as deterministic, non-interlaced RGBA PNG bytes."""

    raw = bytearray()
    stride = image.width * 4
    for y in range(image.height):
        raw.append(0)
        start = y * stride
        raw.extend(image.pixels[start : start + stride])
    return (
        PNG_SIGNATURE
        + _chunk(b"IHDR", struct.pack(">IIBBBBB", image.width, image.height, 8, 6, 0, 0, 0))
        + _chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + _chunk(b"IEND", b"")
    )


def save_png(image: RGBAImage, path: Path | str) -> None:
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png_bytes(image))
