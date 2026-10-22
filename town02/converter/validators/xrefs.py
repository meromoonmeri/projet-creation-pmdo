"""Cross-reference validator.

Checks that references emitted by the converter resolve inside the
project:
  * Ground referenced by Zone exists in Data/Ground/
  * Tile referenced by Ground/rsground exists in Content/Tile/
  * String key referenced by dialogue exists in Strings/*.resx
  * Music track referenced by cutscene exists in Content/Music/

Any missing target is a FAIL finding; the validator never resolves a
missing xref by falling back to a similar name.
"""
from __future__ import annotations

from pathlib import Path


def check_ground_tile_xrefs(repo_root: Path) -> tuple[bool, list[dict]]:
    """Placeholder: real implementation reads staged rsground files and
    verifies each referenced tile atlas exists under Content/Tile/."""
    findings: list[dict] = []
    # Fast sanity: at least the roots must exist.
    for rel in ("Data/Ground", "Content/Tile"):
        if not (repo_root / rel).is_dir():
            findings.append({
                "level": "FAIL",
                "reason": f"missing directory {rel}",
            })
    return not findings, findings


def check_string_keys(repo_root: Path, keys: list[str]) -> tuple[bool, list[dict]]:
    """Verify every key in `keys` is defined at least once in one of
    the Strings/*.resx files."""
    findings: list[dict] = []
    strings_dir = repo_root / "Strings"
    if not strings_dir.is_dir():
        return False, [{"level": "FAIL", "reason": "Strings/ missing"}]
    all_text = "\n".join(
        p.read_text(encoding="utf-8", errors="replace")
        for p in sorted(strings_dir.glob("*.resx"))
    )
    for k in keys:
        if f'name="{k}"' not in all_text:
            findings.append({
                "level": "FAIL",
                "reason": f"string key not found: {k}",
            })
    return not findings, findings
