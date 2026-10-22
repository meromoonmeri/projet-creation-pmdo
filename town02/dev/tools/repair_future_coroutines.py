#!/usr/bin/env python3
"""Wrap direct TASK:JoinCoroutines callbacks in TASK:BranchCoroutine.

PMDO's JoinCoroutines accepts Coroutine objects, not raw Lua functions.  The
future-scene generator emitted one callback per line with a stable indentation
shape.  This repair is intentionally scoped to that generated corpus and is
idempotent; --check can be used by CI/static audits.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCENES = ROOT / "Data/Script/halcyon/future_arc/scene"
JOIN_START = "TASK:JoinCoroutines"
RAW_START = re.compile(r"^(?P<indent>\s*)function\s*\(\s*\)\s*$")
CALLBACK_END = re.compile(r"^(?P<indent>\s*)end(?P<comma>\s*,?\s*(?:--.*)?)$")


def repair_text(text: str) -> tuple[str, int, list[str]]:
    lines = text.splitlines(keepends=True)
    in_join = False
    callback_indent: str | None = None
    changes = 0
    errors: list[str] = []

    for index, original in enumerate(lines):
        newline = "\n" if original.endswith("\n") else ""
        line = original[:-1] if newline else original

        if JOIN_START in line:
            if in_join:
                errors.append(f"line {index + 1}: nested JoinCoroutines region")
            in_join = True

        if in_join and callback_indent is None:
            match = RAW_START.match(line)
            if match:
                callback_indent = match.group("indent")
                lines[index] = (
                    callback_indent + "TASK:BranchCoroutine(function()" + newline
                )
                changes += 1
                continue

        if in_join and callback_indent is not None:
            match = CALLBACK_END.match(line)
            if match and match.group("indent") == callback_indent:
                suffix = match.group("comma")
                lines[index] = callback_indent + "end)" + suffix + newline
                callback_indent = None
                continue

        # Generated joins all end with the table and call on one line.
        if in_join and callback_indent is None and re.match(r"^\s*}\)\s*;?\s*$", line):
            in_join = False

    if callback_indent is not None:
        errors.append("unterminated raw callback")
    if in_join:
        errors.append("unterminated JoinCoroutines region")
    return "".join(lines), changes, errors


def scan_raw_callbacks(text: str) -> int:
    """Count line-shaped raw callbacks inside generated join regions."""
    in_join = False
    count = 0
    for line in text.splitlines():
        if JOIN_START in line:
            in_join = True
        if in_join and RAW_START.match(line):
            count += 1
        if in_join and re.match(r"^\s*}\)\s*;?\s*$", line):
            in_join = False
    return count


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="do not modify files")
    args = parser.parse_args()

    total = 0
    problems: list[str] = []
    for path in sorted(SCENES.glob("*.lua")):
        text = path.read_text(encoding="utf-8")
        repaired, changes, errors = repair_text(text)
        if errors:
            problems.extend(f"{path.relative_to(ROOT)}: {item}" for item in errors)
        total += changes
        if changes and not args.check:
            path.write_text(repaired, encoding="utf-8")

    # Re-read the final state in write mode; check the proposed state otherwise.
    remaining = 0
    for path in sorted(SCENES.glob("*.lua")):
        text = path.read_text(encoding="utf-8")
        if args.check:
            text, _, _ = repair_text(text)
        remaining += scan_raw_callbacks(text)

    if problems:
        print("\n".join(problems))
        return 2
    if args.check and total:
        print(f"FAIL: {total} raw callback(s) still require BranchCoroutine")
        return 1
    if remaining:
        print(f"FAIL: {remaining} raw callback(s) remain after repair")
        return 1
    print(f"OK: {total} callback(s) repaired; no raw JoinCoroutines callback remains")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
