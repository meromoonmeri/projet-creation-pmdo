"""Fail-closed bulk extraction of PMD Red canonical manifests.

This is the first stage of mass production, not zone generation.  It writes no
DungeonDefinition and no Data/Zone output: every dungeon must still be
reconciled and runtime-validated independently before the production gate can
approve it.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from .definitions import list_definitions
from .red_source import extract

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT = ROOT / "docs" / "canonical" / "red"
REPORT_NAME = "PMD_RED_BATCH_EXTRACTION.json"


def _mapping() -> list[tuple[str, str, str]]:
    # This is the existing audited roster-to-pret folder table.  Keeping one
    # authority avoids guessing folder names from display strings.
    import build_canonical_definitions as canonical

    by_name: dict[str, str] = {}
    for path in list_definitions():
        raw = json.loads(path.read_text(encoding="utf-8-sig"))
        english = (raw.get("name") or {}).get("en")
        if english:
            by_name[str(english)] = path.stem
    rows = []
    for english, folder in canonical.PMDRED_FOLDER.items():
        stem = by_name.get(english)
        if stem is None:
            raise ValueError(f"PMD Red roster name has no canonical definition: {english}")
        rows.append((stem, english, folder))
    return rows


def extract_all(source_root: Path, output_dir: Path = DEFAULT_OUTPUT,
                write: bool = False) -> dict[str, Any]:
    source_root = source_root.resolve()
    rows: list[dict[str, Any]] = []
    payloads: dict[str, dict[str, Any]] = {}
    definitions = {
        path.stem: json.loads(path.read_text(encoding="utf-8-sig"))
        for path in list_definitions()
    }
    for stem, english, folder in _mapping():
        try:
            payload = extract(source_root, folder)
            encoded = (json.dumps(payload, ensure_ascii=False, indent=2) + "\n").encode()
            payloads[stem] = payload
            raw = definitions[stem]
            params = [floor["floor_properties"] for floor in payload["floors"]
                      if floor["classification"] == "procedural"]
            features = raw.get("features") or {}
            expected_floors = (len(payload["procedural_floors"])
                               if raw.get("fixed_segments") else payload["floor_count"])
            blockers: list[str] = []
            if int(raw.get("floors", 0)) != expected_floors:
                blockers.append(
                    f"FLOOR_COUNT definition={raw.get('floors')} source={expected_floors}")
            if (features.get("shop") or {}).get("enabled") and not any(
                    int(row.get("kecleonShopChance", 0)) > 0 for row in params):
                blockers.append("INVENTED_SHOP_SOURCE_CHANCE_ZERO")
            if (features.get("monster_house") or {}).get("enabled") and not any(
                    int(row.get("monsterHouseChance", 0)) > 0 for row in params):
                blockers.append("INVENTED_MONSTER_HOUSE_SOURCE_CHANCE_ZERO")
            if features.get("weather") and not any(
                    int(row.get("weather", 0)) > 0 for row in params):
                blockers.append("INVENTED_WEATHER_SOURCE_CLEAR")
            if (features.get("traps") or {}).get("enabled") and not any(
                    int(row.get("trapDensity", 0)) > 0 for row in params):
                blockers.append("INVENTED_TRAPS_SOURCE_DENSITY_ZERO")
            runtime = str(((raw.get("provenance") or {}).get("status") or {}).get("runtime") or "missing")
            rows.append({
                "definition": stem,
                "name": english,
                "folder": folder,
                "status": "EXTRACTED",
                "floors": payload["floor_count"],
                "procedural": len(payload["procedural_floors"]),
                "fixed": len(payload["fixed_floors"]),
                "tilesets": sorted({row["tileset"] for row in params}),
                "bytes": len(encoded),
                "reconciliation": {
                    "state": ("RUNTIME_VALIDATED" if runtime == "validated"
                              else "RECONCILIATION_REQUIRED"),
                    "runtime": runtime,
                    "source_conflicts": blockers,
                },
            })
        except Exception as exc:  # report every source failure before refusing writes
            rows.append({
                "definition": stem,
                "name": english,
                "folder": folder,
                "status": "ERROR",
                "error": str(exc),
            })

    errors = [row for row in rows if row["status"] == "ERROR"]
    report = {
        "schema": "new-era.red-batch-extraction.v1",
        "source": {
            "repository": "https://github.com/pret/pmd-red",
            "commit": next(iter(payloads.values()))["source"]["commit"] if payloads else "UNKNOWN",
        },
        "summary": {
            "requested": len(rows),
            "extracted": len(rows) - len(errors),
            "errors": len(errors),
            "bytes": sum(row.get("bytes", 0) for row in rows),
            "runtime_validated": sum(
                row.get("reconciliation", {}).get("state") == "RUNTIME_VALIDATED"
                for row in rows),
            "reconciliation_required": sum(
                row.get("reconciliation", {}).get("state") == "RECONCILIATION_REQUIRED"
                for row in rows),
            "source_conflicts": sum(
                len(row.get("reconciliation", {}).get("source_conflicts", []))
                for row in rows),
            "zones_generated": 0,
            "zones_promoted": 0,
        },
        "policy": {
            "stage": "CANONICAL_SOURCE_EXTRACTION_ONLY",
            "production_gate": "CLOSED_UNTIL_PER_DUNGEON_RECONCILIATION_AND_RUNTIME",
        },
        "entries": rows,
    }
    if errors:
        details = "; ".join(f"{row['definition']}: {row['error']}" for row in errors[:5])
        raise ValueError(f"PMD Red batch extraction blocked ({len(errors)} errors): {details}")
    if write:
        output_dir.mkdir(parents=True, exist_ok=True)
        for stem, payload in payloads.items():
            (output_dir / f"{stem}_rom_manifest.json").write_text(
                json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        (output_dir / REPORT_NAME).write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return report
