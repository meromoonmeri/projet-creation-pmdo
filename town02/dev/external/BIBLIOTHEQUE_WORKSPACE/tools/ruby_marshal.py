#!/usr/bin/env python3
"""Bounded, non-executing reader for Ruby Marshal 4.8 data.

This intentionally implements data decoding only. It never imports Ruby, calls
user hooks, evaluates scripts, or instantiates source classes. RPG Maker objects
are represented as inert dataclasses and Table payloads remain raw until an
explicit structural decoder is called.
"""

from __future__ import annotations

import struct
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

MAX_OBJECTS = 2_000_000
MAX_CONTAINER = 2_000_000
MAX_BYTES = 128 * 1024 * 1024


@dataclass
class RubyObject:
    class_name: str
    ivars: dict[str, Any] = field(default_factory=dict)


@dataclass
class RubyUserData:
    class_name: str
    data: bytes
    ivars: dict[str, Any] = field(default_factory=dict)


@dataclass
class RubyStruct:
    class_name: str
    members: dict[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class RubyTable:
    dimensions: int
    x_size: int
    y_size: int
    z_size: int
    values: tuple[int, ...]


class MarshalFormatError(ValueError):
    pass


class Reader:
    def __init__(self, data: bytes):
        if len(data) > MAX_BYTES:
            raise MarshalFormatError(f"Marshal stream exceeds {MAX_BYTES} bytes")
        self.data = data
        self.position = 0
        self.objects: list[Any] = []
        self.symbols: list[str] = []

    def _byte(self) -> int:
        if self.position >= len(self.data):
            raise MarshalFormatError("unexpected end of stream")
        value = self.data[self.position]
        self.position += 1
        return value

    def _raw(self, length: int) -> bytes:
        if length < 0 or length > MAX_BYTES or self.position + length > len(self.data):
            raise MarshalFormatError(f"invalid byte length {length}")
        value = self.data[self.position : self.position + length]
        self.position += length
        return value

    def _long(self) -> int:
        lead = struct.unpack("b", bytes([self._byte()]))[0]
        if lead == 0:
            return 0
        if 5 <= lead <= 127:
            return lead - 5
        if -128 <= lead <= -5:
            return lead + 5
        length = abs(lead)
        value = int.from_bytes(self._raw(length), "little", signed=False)
        if lead < 0:
            value -= 1 << (length * 8)
        return value

    def _length(self) -> int:
        length = self._long()
        if length < 0 or length > MAX_CONTAINER:
            raise MarshalFormatError(f"invalid container length {length}")
        return length

    def _register(self, value: Any) -> Any:
        if len(self.objects) >= MAX_OBJECTS:
            raise MarshalFormatError("object table limit exceeded")
        self.objects.append(value)
        return value

    def _symbol(self) -> str:
        marker = chr(self._byte())
        if marker == ":":
            value = decode_text(self._raw(self._length()))
            self.symbols.append(value)
            return value
        if marker == ";":
            index = self._long()
            try:
                return self.symbols[index]
            except IndexError as exc:
                raise MarshalFormatError(f"invalid symbol link {index}") from exc
        raise MarshalFormatError(f"expected symbol, got {marker!r}")

    def read(self) -> Any:
        offset = self.position
        marker = chr(self._byte())
        if marker == "0":
            return None
        if marker == "T":
            return True
        if marker == "F":
            return False
        if marker == "i":
            return self._long()
        if marker == ":":
            value = decode_text(self._raw(self._length()))
            self.symbols.append(value)
            return value
        if marker == ";":
            index = self._long()
            try:
                return self.symbols[index]
            except IndexError as exc:
                raise MarshalFormatError(f"invalid symbol link {index}") from exc
        if marker == "@":
            index = self._long()
            try:
                return self.objects[index]
            except IndexError as exc:
                raise MarshalFormatError(f"invalid object link {index}") from exc
        if marker == '"':
            return self._register(self._raw(self._length()))
        if marker == "[":
            result: list[Any] = []
            self._register(result)
            result.extend(self.read() for _ in range(self._length()))
            return result
        if marker in "{}":
            result: dict[Any, Any] = {}
            self._register(result)
            for _ in range(self._length()):
                key = self.read()
                value = self.read()
                result[key] = value
            if marker == "}":
                result["__default__"] = self.read()
            return result
        if marker == "o":
            result = RubyObject(self._symbol())
            self._register(result)
            for _ in range(self._length()):
                key = self._symbol()
                result.ivars[key] = self.read()
            return result
        if marker == "S":
            result = RubyStruct(self._symbol())
            self._register(result)
            for _ in range(self._length()):
                key = self._symbol()
                result.members[key] = self.read()
            return result
        if marker == "u":
            result = RubyUserData(self._symbol(), self._raw(self._length()))
            return self._register(result)
        if marker == "U":
            result = RubyObject(self._symbol())
            self._register(result)
            result.ivars["__marshal__"] = self.read()
            return result
        if marker == "I":
            result = self.read()
            ivars: dict[str, Any] = {}
            for _ in range(self._length()):
                key = self._symbol()
                ivars[key] = self.read()
            if hasattr(result, "ivars"):
                result.ivars.update(ivars)
            return result
        if marker == "f":
            result = float(self._raw(self._length()).decode("ascii"))
            return self._register(result)
        if marker == "l":
            sign = chr(self._byte())
            words = self._length()
            result = int.from_bytes(self._raw(words * 2), "little")
            if sign == "-":
                result = -result
            return self._register(result)
        if marker == "/":
            result = ("regexp", self._raw(self._length()), self._byte())
            return self._register(result)
        if marker in "cmM":
            result = (marker, decode_text(self._raw(self._length())))
            return self._register(result)
        if marker == "e":
            return ("extended", self._symbol(), self.read())
        if marker == "C":
            return ("userclass", self._symbol(), self.read())
        excerpt = self.data[offset : offset + 20]
        raise MarshalFormatError(f"unsupported marker {marker!r} at {offset}: {excerpt!r}")


def decode_text(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value
    if not isinstance(value, (bytes, bytearray)):
        return str(value)
    raw = bytes(value)
    for encoding in ("utf-8", "cp1252", "shift_jis"):
        try:
            return raw.decode(encoding)
        except UnicodeDecodeError:
            pass
    return raw.decode("utf-8", "replace")


def load_bytes(data: bytes) -> Any:
    if data[:2] != b"\x04\x08":
        raise MarshalFormatError("not a Ruby Marshal 4.8 stream")
    reader = Reader(data)
    reader.position = 2
    result = reader.read()
    if reader.position != len(data):
        raise MarshalFormatError(
            f"trailing data: parsed {reader.position} of {len(data)} bytes"
        )
    return result


def load(path: Path | str) -> Any:
    return load_bytes(Path(path).read_bytes())


def decode_table(value: RubyUserData) -> RubyTable:
    if not isinstance(value, RubyUserData) or value.class_name != "Table":
        raise MarshalFormatError("expected inert Table user data")
    if len(value.data) < 20:
        raise MarshalFormatError("Table payload is shorter than its header")
    dimensions, x_size, y_size, z_size, count = struct.unpack("<5I", value.data[:20])
    expected = 20 + count * 2
    if len(value.data) != expected:
        raise MarshalFormatError(
            f"Table size mismatch: header says {count}, payload={len(value.data)}"
        )
    if dimensions not in (1, 2, 3) or x_size * y_size * z_size != count:
        raise MarshalFormatError("inconsistent Table dimensions")
    values = struct.unpack(f"<{count}H", value.data[20:])
    return RubyTable(dimensions, x_size, y_size, z_size, values)


def ivar(value: RubyObject, name: str, default: Any = None) -> Any:
    if not isinstance(value, RubyObject):
        return default
    return value.ivars.get(name if name.startswith("@") else "@" + name, default)
