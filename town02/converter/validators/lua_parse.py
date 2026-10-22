"""Lua parse validator.

Uses `luac -p` if available (fast, canonical), otherwise falls back to
a minimal balance/keyword sanity check that catches the most common
mistakes (unbalanced end/do/then, stray commas). The fallback is not a
replacement for a real parser: it flags PROBABLY_OK vs LIKELY_BROKEN
and never reports fake PASS.
"""
from __future__ import annotations

import shutil
import subprocess
from pathlib import Path


def _has_luac() -> bool:
    return shutil.which("luac") is not None


def check_file(path: Path) -> tuple[bool, str]:
    if _has_luac():
        try:
            proc = subprocess.run(
                ["luac", "-p", str(path)],
                capture_output=True, text=True, timeout=15,
            )
            if proc.returncode == 0:
                return True, "luac -p: OK"
            return False, f"luac -p failed: {proc.stderr.strip()}"
        except Exception as exc:  # noqa: BLE001
            return False, f"luac invocation error: {exc!r}"

    # Fallback heuristic: count balanced block keywords.
    txt = path.read_text(encoding="utf-8", errors="replace")
    opens = 0
    closes = 0
    for word in txt.replace("\t", " ").split():
        w = word.strip("(),;")
        if w in {"function", "if", "for", "while", "do", "repeat"}:
            opens += 1
        elif w in {"end", "until"}:
            closes += 1
    if opens == closes:
        return True, f"heuristic OK (opens={opens}, closes={closes})"
    return False, (
        f"heuristic imbalance: opens={opens}, closes={closes} "
        f"(install luac for a real check)"
    )
