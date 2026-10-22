"""Exhaustive resolution audit for all extracted PMD Red manifests."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import build_canonical_definitions as legacy_mapping

from .red_story_batch import BASE_ITEMS, PMDO_UNAVAILABLE_ITEMS, _item

ROOT = Path(__file__).resolve().parents[2]
BATCH = ROOT / "docs/canonical/red/PMD_RED_BATCH_EXTRACTION.json"
OUTPUT = ROOT / "docs/canonical/red/PMD_RED_RESOLUTION_AUDIT.json"


def _required_tables(manifest: dict[str, Any]) -> set[tuple[str, str]]:
    refs: set[tuple[str, str]] = set()
    for floor in manifest["floors"]:
        props, ids = floor["floor_properties"], floor["table_ids"]
        refs.add(("items", str(ids["Items"])))
        if int(props["kecleonShopChance"]) > 0:
            refs.add(("shops", str(ids["KecleonShop"])))
        if int(props["monsterHouseChance"]) > 0:
            refs.add(("monster_house_items", str(ids["MonsterRoomItems"])))
        if int(props["buriedItemDensity"]) > 0:
            refs.add(("buried_items", str(ids["BuriedItems"])))
    return refs


def missing_items(manifest: dict[str, Any]) -> list[str]:
    """Report only PMD Red items that are neither PMDO-resolvable nor listed
    in PMDO_UNAVAILABLE_ITEMS. Items in the unavailable set are intentionally
    absent from PMDO 0.8.9 base and are tracked separately via
    ``skipped_items(manifest)`` — they must not turn every referencing dungeon
    into a hard blocker.
    """
    conversion = legacy_mapping.load_item_conversion()
    available = BASE_ITEMS | set(legacy_mapping.known_items())
    missing = set()
    for kind, index in _required_tables(manifest):
        table = manifest["tables"][kind][index]
        for category in table.get("categories", []):
            for raw in category.get("items", []):
                source = raw["item"]
                if source in {"ITEM_NONE", "ITEM_POKE"}:
                    continue
                if source in PMDO_UNAVAILABLE_ITEMS:
                    continue
                if _item(source, conversion, available) is None:
                    missing.add(source)
    return sorted(missing)


def skipped_items(manifest: dict[str, Any]) -> list[str]:
    """PMD Red items intentionally skipped because PMDO 0.8.9 base does not
    ship a canonical equivalent (see PMDO_UNAVAILABLE_ITEMS)."""
    result: set[str] = set()
    for kind, index in _required_tables(manifest):
        table = manifest["tables"][kind][index]
        for category in table.get("categories", []):
            for raw in category.get("items", []):
                if raw["item"] in PMDO_UNAVAILABLE_ITEMS:
                    result.add(raw["item"])
    return sorted(result)


def build() -> dict[str, Any]:
    batch = json.loads(BATCH.read_text(encoding="utf-8"))
    rows = []
    for entry in batch["entries"]:
        stem = entry["definition"]
        manifest_path = ROOT / f"docs/canonical/red/{stem}_rom_manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        fixed = list(manifest["fixed_floors"])
        missing = missing_items(manifest)
        skipped = skipped_items(manifest)
        blockers = []
        if fixed:
            blockers.append({"code": "FIXED_FLOOR_COUNTERPART_REQUIRED", "floors": fixed})
        if missing:
            blockers.append({"code": "UNMAPPED_CANONICAL_ITEMS", "items": missing})
        # skipped_items alone is NOT a blocker (documented absence in
        # PMDO 0.8.9 base). It is reported so downstream audits can trace
        # every deviation from the raw ROM tables.
        state = "SOURCE_RESOLVABLE" if not blockers else "BLOCKED_SOURCE_RESOLUTION"
        rows.append({
            "definition": stem,
            "manifest": str(manifest_path.relative_to(ROOT)),
            "state": state,
            "fixed_floors": fixed,
            "missing_items": missing,
            "skipped_items": skipped,
            "blockers": blockers,
        })
    payload = {
        "schema": "new-era.red-resolution-audit.v1",
        "summary": {
            "manifests": len(rows),
            "source_resolvable": sum(row["state"] == "SOURCE_RESOLVABLE" for row in rows),
            "blocked": sum(row["state"] != "SOURCE_RESOLVABLE" for row in rows),
            "fixed_floor_blocked": sum(bool(row["fixed_floors"]) for row in rows),
            "item_mapping_blocked": sum(bool(row["missing_items"]) for row in rows),
            "any_items_skipped": sum(bool(row.get("skipped_items")) for row in rows),
        },
        "entries": rows,
    }
    return payload


def write(output: Path = OUTPUT) -> Path:
    payload = build()
    output.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")
    return output
