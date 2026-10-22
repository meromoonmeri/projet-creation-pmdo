#!/usr/bin/env python3
"""Apply narrowly audited WASM-host compatibility patches to UTMT 0.6.1.

The distributed UndertaleModCli build uses synchronous Task waits in two places
that Mono's single-thread browser-WASM runtime cannot execute.  This patch:

* changes CLI Main's final Parser.Invoke call to Parser.InvokeAsync and changes
  Main's signature to Task<int>;
* replaces Decompiler.BuildSubFunctionCache's parallel Task.WaitAny body with
  deterministic initialization of an empty KnownSubFunctions dictionary.

No GameMaker parsing, instruction decoding, or decompile-flow code is changed.
Every source and output SHA-256 is pinned.  The second patch only reduces name
recovery for anonymous functions; all raw instructions remain exported and only
two Steam sample entries fail high-level decompilation in the audited game.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

CLI_SOURCE = "e07a259a4e1df27d4b6f758b72197c71b6dfee021f8e834a134dc0596c8c9b50"
CLI_OUTPUT = "2b46875c8cf2dd45e31e103d95df626857c4c353701e2363b923265392d88df4"
LIB_SOURCE = "d1a5c98f899a221a8a2d6c387b9ea0c7d942266a29cc67fd7a8cb6d8bdcbf32d"
LIB_OUTPUT = "86f67078b59e87ef1d1300730a51383501e0d437345a8d0640c4392739085417"

# (file offset, expected old bytes, replacement bytes)
CLI_PATCHES = (
    (2225, "3100", "7101"),
    (21622, "5510", "840b"),
    (27214, "fc01e123", "31035f11"),
    (34851, "7365745f5573655368656c6c", "496e766f6b654173796e6300"),
    (54980, "1010", "0a00"),
    (54983, "01151182d5010515", "151280f101081d0e"),
    (55006, "01", "03"),
    (55008, "11", "12"),
    (55010, "c9", "f1"),
    (55012, "1300151182d5011300", "081281951d0e12819d"),
)
LIB_PATCHES = (
    (218304, "73c10d0006", "0273f10500"),
    (218310, "06027d710800", "7d400000042a"),
)


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def patch(source: Path, output: Path, expected: str, result: str, patches) -> None:
    data = bytearray(source.read_bytes())
    actual = digest(data)
    if actual != expected:
        raise ValueError(f"{source}: SHA-256 {actual}, expected {expected}")
    for offset, old_hex, new_hex in patches:
        old, new = bytes.fromhex(old_hex), bytes.fromhex(new_hex)
        if len(old) != len(new):
            raise AssertionError("patch changes file length")
        if data[offset : offset + len(old)] != old:
            raise ValueError(f"{source}: unexpected bytes at {offset}")
        data[offset : offset + len(old)] = new
    actual = digest(data)
    if actual != result:
        raise AssertionError(f"patched SHA-256 {actual}, expected {result}")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(data)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("utmt_directory", type=Path)
    parser.add_argument("output_directory", type=Path)
    args = parser.parse_args()
    patch(
        args.utmt_directory / "UndertaleModCli.dll",
        args.output_directory / "UndertaleModCli.dll",
        CLI_SOURCE,
        CLI_OUTPUT,
        CLI_PATCHES,
    )
    patch(
        args.utmt_directory / "UndertaleModLib.dll",
        args.output_directory / "UndertaleModLib.dll",
        LIB_SOURCE,
        LIB_OUTPUT,
        LIB_PATCHES,
    )
    print(f"patched UndertaleModCli/UndertaleModLib into {args.output_directory}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
