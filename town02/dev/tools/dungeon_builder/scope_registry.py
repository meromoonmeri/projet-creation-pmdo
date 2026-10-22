"""Machine inventory for the priority 64 PMD Red EU + 47 PMDODump scope."""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
EU_AUDIT = ROOT / "docs/pmdred_eu/eu_rom_extraction_audit.json"
RED_MANIFEST_DIR = ROOT / "docs/canonical/red"
RED_BATCH = RED_MANIFEST_DIR / "PMD_RED_BATCH_EXTRACTION.json"
PMDODUMP_INVENTORY = ROOT / "docs/INVENTAIRE_PMDODUMP_ET_DUNGEON_PACK.md"
OUTPUT = ROOT / "DungeonDefs/canonical_scope_111.json"
REPORT_MD = ROOT / "docs/dungeon_builder/BATCH_SCOPE_111.md"
PMDODUMP_COMMIT = "21ec4abdddf4f705c6e75a0635358d597c884f8c"


def _sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _norm(value: str) -> str:
    return re.sub(r"[^a-z0-9]", "", value.lower())


def _red_manifests() -> tuple[dict[str, tuple[str, Path]], dict[str, dict[str, Any]]]:
    report = json.loads(RED_BATCH.read_text(encoding="utf-8"))
    by_folder: dict[str, tuple[str, Path]] = {}
    by_definition: dict[str, dict[str, Any]] = {}
    for row in report["entries"]:
        path = RED_MANIFEST_DIR / f"{row['definition']}_rom_manifest.json"
        by_folder[_norm(row["folder"])] = (row["definition"], path)
        by_definition[row["definition"]] = row
    return by_folder, by_definition


def _final_ground_by_dungeon(audit: dict[str, Any]) -> dict[int, dict[str, Any]]:
    result = {}
    for row in audit["map_to_dungeon_table"]["entries"]:
        result.setdefault(int(row["dungeon_id"]), row)
    return result


def build_red(pret_root: Path) -> list[dict[str, Any]]:
    audit = json.loads(EU_AUDIT.read_text(encoding="utf-8"))
    dungeon_data_path = pret_root / "data/dungeon/dungeon_data.json"
    if not dungeon_data_path.is_file():
        raise ValueError(f"pret dungeon_data.json missing: {dungeon_data_path}")
    dungeon_data = json.loads(dungeon_data_path.read_text(encoding="utf-8"))
    floors = audit["dungeon_floor_count_table"]["entries"]
    if len(floors) != 64 or len(dungeon_data) < 64:
        raise ValueError(f"priority Red inventory requires 64 rows, got {len(floors)}/{len(dungeon_data)}")
    manifests, batch_rows = _red_manifests()
    final_grounds = _final_ground_by_dungeon(audit)
    rows = []
    for floor_row in floors:
        dungeon_id = int(floor_row["dungeon_id"])
        mechanics = dungeon_data[dungeon_id]
        canonical_id = str(mechanics["name"])
        lookup = _norm(canonical_id.removeprefix("DUNGEON_"))
        manifest_match = next(
            ((definition, path) for folder, (definition, path) in manifests.items()
             if folder == lookup), None)
        definition = manifest_match[0] if manifest_match else None
        manifest_path = manifest_match[1] if manifest_match else None
        batch = batch_rows.get(definition or "", {})
        runtime = (batch.get("reconciliation") or {}).get("runtime", "missing")
        state = "RUNTIME_VALIDATED" if runtime == "validated" else (
            "SOURCE_EXTRACTED" if manifest_path else "ROM_FLOOR_COUNT_ONLY")
        blockers = []
        if manifest_path is None:
            blockers += ["SEMANTIC_MANIFEST_NOT_EXTRACTED", "CANONICAL_DEFINITION_MISSING"]
        elif runtime != "validated":
            blockers += ["DEFINITION_RECONCILIATION_REQUIRED", "RUNTIME_PMDO_NOT_VALIDATED"]
            blockers += (batch.get("reconciliation") or {}).get("source_conflicts", [])
        ground = final_grounds.get(dungeon_id)
        rows.append({
            "scope_key": f"red-eu:{dungeon_id:02d}",
            "source": "PMD_RED_ROM",
            "dungeon_id": dungeon_id,
            "canonical_id": canonical_id,
            "floor_count_runtime": int(floor_row["floor_count"]),
            "mechanics": mechanics,
            "definition": definition,
            "manifest": (str(manifest_path.relative_to(ROOT)) if manifest_path else None),
            "final_ground": (ground.get("stable_ground_id") if ground else None),
            "status": state,
            "generated": state == "RUNTIME_VALIDATED",
            "mapgen_validated": state == "RUNTIME_VALIDATED",
            "route_validated": state == "RUNTIME_VALIDATED",
            "runtime_validated": state == "RUNTIME_VALIDATED",
            "blockers": blockers,
        })
    return rows


def _clean_cell(value: str) -> str:
    value = value.strip()
    match = re.fullmatch(r"`([^`]+)`", value)
    return match.group(1) if match else value.replace("**", "")


def _pmdodump_assets(pmdodump_root: Path) -> dict[str, list[Path]]:
    zone_dir = pmdodump_root / "DataAsset/Zone"
    if not zone_dir.is_dir():
        raise ValueError(f"PMDODump DataAsset/Zone missing: {zone_dir}")
    assets = {
        path.name.removesuffix(".out.txt"): [path]
        for path in sorted(zone_dir.glob("*.out.txt"))
        if path.name not in {"FORBIDDEN.out.txt", "Scratchpad.out.txt"}
    }
    # The project treats cave + coast as one Eon Island route entry.
    coast = assets.pop("Eon_Island_Coast", None)
    if coast:
        assets.setdefault("Eon_Island_Cave", []).extend(coast)
    if len(assets) != 47:
        raise ValueError(f"PMDODump canonical source set must contain 47 entries, got {len(assets)}")
    return assets


def build_pmdodump(pmdodump_root: Path) -> list[dict[str, Any]]:
    text = PMDODUMP_INVENTORY.read_text(encoding="utf-8")
    assets = _pmdodump_assets(pmdodump_root.resolve())
    rows = []
    section = None
    for line in text.splitlines():
        if line.startswith("### A. Donjons déjà intégrés"):
            section = "INTEGRATED_LEGACY"
        elif line.startswith("### B. Réserve Stratégique PMDODump"):
            section = "STRATEGIC_RESERVE"
        elif line.startswith("## 2."):
            section = None
        if section is None or not line.startswith("| `"):
            continue
        cells = [_clean_cell(cell) for cell in line.strip().strip("|").split("|")]
        if len(cells) != 6:
            raise ValueError(f"unexpected PMDODump inventory row: {line}")
        upstream_id, french, tier, entrance, relay, boss = cells
        zone_id = upstream_id.lower()
        zone_path = ROOT / "Data/Zone" / f"{zone_id}.json"
        blockers = ["PMDODUMP_SOURCE_RULES_NOT_IMPORTED", "CANONICAL_DEFINITION_MISSING",
                    "RUNTIME_PMDO_NOT_VALIDATED"]
        if zone_path.is_file():
            blockers.insert(0, "LEGACY_ZONE_PRESENT_NOT_CANONICALLY_RECONCILED")
        source_paths = assets.get(upstream_id)
        if not source_paths:
            raise ValueError(f"documented PMDODump entry absent upstream: {upstream_id}")
        rows.append({
            "scope_key": f"pmdodump:{upstream_id}",
            "source": "PMDODUMP",
            "source_commit": PMDODUMP_COMMIT,
            "source_assets": [
                {"path": str(path.relative_to(pmdodump_root)), "sha256": _sha(path)}
                for path in source_paths
            ],
            "upstream_id": upstream_id,
            "name_fr": french,
            "tier_or_chapter": tier,
            "entrance": entrance,
            "relay": relay,
            "boss": boss,
            "legacy_zone": str(zone_path.relative_to(ROOT)) if zone_path.is_file() else None,
            "inventory_state": section,
            "status": "SOURCE_INVENTORIED",
            "generated": False,
            "mapgen_validated": False,
            "route_validated": False,
            "runtime_validated": False,
            "blockers": blockers,
        })
    documented = {row["upstream_id"] for row in rows}
    missing = sorted(set(assets) - documented)
    if missing != ["Glacial_Path"]:
        raise ValueError(f"unexpected PMDODump documentation delta: {missing}")
    for upstream_id in missing:
        source_paths = assets[upstream_id]
        rows.append({
            "scope_key": f"pmdodump:{upstream_id}",
            "source": "PMDODUMP",
            "source_commit": PMDODUMP_COMMIT,
            "source_assets": [
                {"path": str(path.relative_to(pmdodump_root)), "sha256": _sha(path)}
                for path in source_paths
            ],
            "upstream_id": upstream_id,
            "name_fr": None,
            "tier_or_chapter": None,
            "entrance": None,
            "relay": None,
            "boss": None,
            "legacy_zone": None,
            "inventory_state": "UPSTREAM_UNMAPPED",
            "status": "SOURCE_INVENTORIED_UNMAPPED",
            "generated": False,
            "mapgen_validated": False,
            "route_validated": False,
            "runtime_validated": False,
            "blockers": ["PROJECT_MAPPING_MISSING", "CANONICAL_DEFINITION_MISSING",
                         "RUNTIME_PMDO_NOT_VALIDATED"],
        })
    if len(rows) != 47:
        raise ValueError(f"PMDODump inventory must contain 47 rows, got {len(rows)}")
    return rows


def _apply_resolution_audit(red: list[dict[str, Any]]) -> None:
    path = ROOT / "docs/canonical/red/PMD_RED_RESOLUTION_AUDIT.json"
    if not path.is_file():
        return
    audit = json.loads(path.read_text(encoding="utf-8"))
    by_definition = {row["definition"]: row for row in audit["entries"]}
    for row in red:
        if row["runtime_validated"] or not row.get("definition"):
            continue
        resolution = by_definition.get(row["definition"])
        if not resolution or resolution["state"] == "SOURCE_RESOLVABLE":
            continue
        blockers = ["DEFINITION_RECONCILIATION_REQUIRED", "RUNTIME_PMDO_NOT_VALIDATED"]
        if resolution["fixed_floors"]:
            blockers.append("FIXED_FLOOR_COUNTERPART_REQUIRED:"
                            + ",".join(map(str, resolution["fixed_floors"])))
        if resolution["missing_items"]:
            blockers.append("UNMAPPED_CANONICAL_ITEMS:"
                            + ",".join(resolution["missing_items"]))
        row["status"] = "BLOCKED_SOURCE_RESOLUTION"
        row["blockers"] = blockers
        row["resolution_audit"] = str(path.relative_to(ROOT))


def _apply_batch_reports(red: list[dict[str, Any]]) -> None:
    by_definition = {row.get("definition"): row for row in red if row.get("definition")}
    for report_path in sorted((ROOT / "docs/dungeon_builder/batches").glob("*/batch_report.json")):
        report = json.loads(report_path.read_text(encoding="utf-8"))
        for entry in report.get("entries", []):
            row = by_definition.get(entry.get("definition"))
            status = entry.get("status")
            if row is None:
                continue
            if status == "BLOCKED_CONFIGURATION":
                row.update({
                    "status": status,
                    "generated": False,
                    "mapgen_validated": False,
                    "route_validated": False,
                    "runtime_validated": False,
                    "batch_report": str(report_path.relative_to(ROOT)),
                    "blockers": list(entry.get("blockers", [])),
                })
                continue
            if status == "ROUTE_VALIDATED_ASSET_BLOCKED":
                row.update({
                    "status": status, "generated": True, "mapgen_validated": True,
                    "route_validated": True, "runtime_validated": False,
                    "staging_definition": entry.get("definition_path"),
                    "staging_zone": entry.get("zone_path"),
                    "batch_report": str(report_path.relative_to(ROOT)),
                    "blockers": list(entry.get("blockers", [])),
                })
                continue
            if status not in {"NATIVE_MAPGEN_VALIDATED_ROUTE_PENDING",
                              "PROMOTED_RUNTIME_VALIDATED"}:
                continue
            promoted = status == "PROMOTED_RUNTIME_VALIDATED"
            row.update({
                "status": status,
                "generated": True,
                "mapgen_validated": True,
                "route_validated": promoted,
                "runtime_validated": promoted,
                "staging_definition": entry.get("definition_path"),
                "staging_zone": entry.get("zone_path"),
                "batch_report": str(report_path.relative_to(ROOT)),
                "blockers": list(entry.get("blockers", [])),
            })


def build(pret_root: Path, pmdodump_root: Path) -> dict[str, Any]:
    red = build_red(pret_root.resolve())
    _apply_resolution_audit(red)
    _apply_batch_reports(red)
    pmdodump = build_pmdodump(pmdodump_root.resolve())
    entries = red + pmdodump
    blocked_by_reason: dict[str, int] = {}
    for row in entries:
        for blocker in row["blockers"]:
            blocked_by_reason[blocker] = blocked_by_reason.get(blocker, 0) + 1
    payload = {
        "schema": "new-era.canonical-priority-scope.v1",
        "authority": {
            "pmd_red_eu_audit": str(EU_AUDIT.relative_to(ROOT)),
            "pmd_red_eu_audit_sha256": _sha(EU_AUDIT),
            "pret_commit": "bf0092d0e34fd8e49b859a0b5f96f00740faa42d",
            "pmdodump_commit": PMDODUMP_COMMIT,
            "pmdodump_inventory": str(PMDODUMP_INVENTORY.relative_to(ROOT)),
            "pmdodump_inventory_sha256": _sha(PMDODUMP_INVENTORY),
        },
        "summary": {
            "total": len(entries),
            "pmd_red_eu": len(red),
            "pmdodump": len(pmdodump),
            "generated": sum(row["generated"] for row in entries),
            "mapgen_validated": sum(row["mapgen_validated"] for row in entries),
            "route_validated": sum(row["route_validated"] for row in entries),
            "runtime_validated": sum(row["runtime_validated"] for row in entries),
            "blocked": sum(bool(row["blockers"]) for row in entries),
            "blocked_by_reason": dict(sorted(blocked_by_reason.items())),
        },
        "entries": entries,
    }
    if payload["summary"]["total"] != 111:
        raise ValueError("priority inventory is not 64+47")
    return payload


def render(payload: dict[str, Any]) -> str:
    summary = payload["summary"]
    lines = [
        "# Batch canonique prioritaire — registre 64 + 47", "",
        f"- inventoriés : **{summary['total']}** ;",
        f"- PMD Red EU : **{summary['pmd_red_eu']}** ;",
        f"- PMDODump : **{summary['pmdodump']}** ;",
        f"- candidates générées : **{summary['generated']}** ;",
        f"- mapgen PMDO validé : **{summary['mapgen_validated']}** ;",
        f"- route validée : **{summary['route_validated']}** ;",
        f"- runtime complet sans blocker asset validé : **{summary['runtime_validated']}** ;",
        f"- entrées bloquées : **{summary['blocked']}**.", "",
        "`generated` inclut les candidates de staging ; `runtime_validated` exige la route complète.", "",
        "| Clé | Source | Identité | Statut | Générée | Mapgen | Route | Blocages exacts |",
        "|---|---|---|---|---:|---:|---:|---|",
    ]
    for row in payload["entries"]:
        identity = row.get("canonical_id") or row.get("upstream_id") or "—"
        blockers = ", ".join(row["blockers"]) or "—"
        lines.append(
            f"| `{row['scope_key']}` | {row['source']} | `{identity}` | {row['status']} | "
            f"{'oui' if row['generated'] else 'non'} | "
            f"{'oui' if row['mapgen_validated'] else 'non'} | "
            f"{'oui' if row['route_validated'] else 'non'} | {blockers} |")
    lines += ["", "## Totaux par raison de blocage", ""]
    for reason, count in summary["blocked_by_reason"].items():
        lines.append(f"- `{reason}` : {count}")
    return "\n".join(lines) + "\n"


def write(pret_root: Path, pmdodump_root: Path, output: Path = OUTPUT) -> Path:
    payload = build(pret_root, pmdodump_root)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    REPORT_MD.parent.mkdir(parents=True, exist_ok=True)
    REPORT_MD.write_text(render(payload), encoding="utf-8")
    return output
