"""Loader for a local pret/pmd-red checkout.

The pret project publishes a matching decompilation of PMD Red. When
the user has cloned it into `dev/external/pret_pmd_red/` (git-ignored),
this module lets the converter consult it for:

  * enum definitions used to validate table sizes (e.g. "we found a
    pointer table of length N; pret declares N dungeon ids, so this is
    plausibly the dungeon-info table"),
  * high-level opcode macros used to disambiguate SSB bytecode,
  * ROM section names (from ld_script.ld) used to bound scans.

Nothing from pret is copied into this repository. If the checkout is
absent, load_pret_checkout() returns None and the caller must degrade
its output to RECONSTRUCTED (or SKIPPED) with an explicit reason.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional


# Minimal C enum body: `NAME = value,` or `NAME,` (auto-increment).
# We only need the *names*, not their meanings, so a small regex is enough.
_ENUM_HEADER = re.compile(r"enum\s+(\w+)\s*\{([^}]*)\}", re.DOTALL)
_ENUM_MEMBER = re.compile(
    r"^\s*([A-Z_][A-Z0-9_]*)\s*(?:=\s*([^,\n/]+?))?\s*(?:,|$)",
    re.MULTILINE,
)
_HEX_OR_DEC = re.compile(r"^\s*(0x[0-9A-Fa-f]+|\d+)\s*$")


@dataclass
class PretEnum:
    """One C enum: name -> integer value.

    Values are resolved with a naive left-to-right auto-increment:
    unspecified members take (previous + 1), the first unspecified
    member takes 0. This mirrors the C standard and is what pret
    headers rely on.
    """

    name: str
    members: dict[str, int] = field(default_factory=dict)


@dataclass
class PretCheckout:
    """A view over a local pret/pmd-red checkout."""

    root: Path
    enums_by_name: dict[str, PretEnum] = field(default_factory=dict)

    def get_enum(self, name: str) -> Optional[PretEnum]:
        return self.enums_by_name.get(name)


def _parse_enum_body(name: str, body: str) -> PretEnum:
    e = PretEnum(name=name)
    counter = 0
    for m in _ENUM_MEMBER.finditer(body):
        mname = m.group(1)
        raw_val = m.group(2)
        if raw_val is not None:
            hd = _HEX_OR_DEC.match(raw_val)
            if hd:
                token = hd.group(1)
                counter = int(token, 16) if token.startswith("0x") \
                    else int(token, 10)
            # Non-literal expressions (references to another enum, math)
            # are left to the auto-increment above: they are rare in
            # pret headers and we don't need their exact values for
            # our validation purposes.
        e.members[mname] = counter
        counter += 1
    return e


def _parse_header_file(path: Path) -> list[PretEnum]:
    text = path.read_text(encoding="utf-8", errors="replace")
    # Strip block and line comments to avoid capturing enum-looking
    # comments; a minimal strip is enough (no need for a full C parser).
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    text = re.sub(r"//[^\n]*", "", text)
    out: list[PretEnum] = []
    for m in _ENUM_HEADER.finditer(text):
        out.append(_parse_enum_body(m.group(1), m.group(2)))
    return out


def load_pret_checkout(root: Path) -> Optional[PretCheckout]:
    """Load a pret/pmd-red checkout from `root` if present.

    Returns None if the checkout does not exist, so callers can degrade
    gracefully instead of raising. When present, this scans the
    include/constants/ directory only (small, well-typed enums), which
    is fast (<100 ms on a normal machine).
    """
    if not root.is_dir():
        return None
    constants_dir = root / "include" / "constants"
    if not constants_dir.is_dir():
        return None

    checkout = PretCheckout(root=root)
    for header in sorted(constants_dir.glob("*.h")):
        try:
            for enum in _parse_header_file(header):
                # First declaration wins on duplicates (there should be
                # none in a clean checkout).
                checkout.enums_by_name.setdefault(enum.name, enum)
        except Exception:  # pragma: no cover
            # A single header failing to parse should not brick the
            # whole checkout view; skip it silently and let the caller
            # notice missing enums.
            continue
    return checkout
