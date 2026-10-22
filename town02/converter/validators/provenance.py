"""Provenance validator.

Ensures every emitted artefact has an adjacent provenance manifest
whose rom_sha256 matches ROM_EXPECTED_HASH and whose status field is
present. Any emitted file without provenance is a hard failure at s06.
"""
from __future__ import annotations

import json
from pathlib import Path

from converter.stages.context import ROM_EXPECTED_HASH


def check_directory(staging_dir: Path) -> tuple[bool, list[dict]]:
    findings: list[dict] = []
    if not staging_dir.exists():
        return True, findings

    for artefact in sorted(staging_dir.rglob("*")):
        if not artefact.is_file():
            continue
        if artefact.suffix in {".json", ".md", ".log"}:
            continue
        prov = artefact.with_suffix(artefact.suffix + ".provenance.json")
        if not prov.exists():
            findings.append({
                "path": str(artefact),
                "level": "FAIL",
                "reason": "missing provenance sidecar",
            })
            continue
        try:
            data = json.loads(prov.read_text(encoding="utf-8"))
        except Exception as exc:  # noqa: BLE001
            findings.append({
                "path": str(prov),
                "level": "FAIL",
                "reason": f"malformed provenance JSON: {exc!r}",
            })
            continue
        if data.get("rom_sha256") != ROM_EXPECTED_HASH:
            findings.append({
                "path": str(prov),
                "level": "FAIL",
                "reason": (
                    f"rom_sha256 mismatch (got "
                    f"{data.get('rom_sha256', 'None')[:16]}...)"
                ),
            })
        if not data.get("status"):
            findings.append({
                "path": str(prov),
                "level": "FAIL",
                "reason": "missing status",
            })
    ok = not any(f["level"] == "FAIL" for f in findings)
    return ok, findings
