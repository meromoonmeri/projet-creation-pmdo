#!/usr/bin/env python3
"""Package the validated 246-map staging as a clearly partial Destiny overlay.

The resulting overlay deliberately contains only the 246 available Ground
occurrences and their exact source/base dependencies. Its embedded 262-row
provenance manifest leaves 13 asset-blocked occurrences and three unavailable
generated Grounds marked as unavailable; it creates no placeholders. The
archive omits Mod.xml, does not replace the existing Quest, and cannot be
installed/verified against Destiny until the user supplies that local Quest.
"""
from __future__ import annotations

import json
from pathlib import Path
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
STAGE = ROOT / ".cache/destiny-recovery/candidate-246-tileguide"
INVENTORY = ROOT / "source/pmdo_cote/destiny_262_inventory.json"
CATALOGUE = ROOT / ".cache/destiny-recovery/PMD_Destiny_Catalogue_Candidate_246_0812.zip"
OVERLAY = ROOT / "exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip"


def main() -> None:
    manifest_path = STAGE / "manifest.json"
    if not manifest_path.is_file():
        raise SystemExit("Staging 246 + TileGuide absent; construire et tester d’abord.")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("mapCount") != 246 or manifest.get("sourceOccurrenceCount") != 262:
        raise ValueError("Le staging ne correspond pas à 246 Grounds / 262 occurrences.")
    if manifest.get("notAnInstallableOverlay") is not True:
        raise ValueError("Le staging de vérification doit rester marqué non installable.")
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    if len(inventory.get("entries", [])) != 262:
        raise ValueError("L’inventaire source n’a pas 262 occurrences.")

    # This source-only header is used solely by build_destiny_quest_overlay.py
    # to verify namespace/type/game target. It is not copied into the overlay.
    mod_xml = (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<Header><Namespace>destiny</Namespace><GameVersion>0.8.12.0</GameVersion>'
        '<ModType>Quest</ModType></Header>\n'
    ).encode("utf-8")
    CATALOGUE.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(CATALOGUE, "w", compression=zipfile.ZIP_STORED, allowZip64=True) as out:
        out.writestr("destiny/Mod.xml", mod_xml)
        out.write(manifest_path, "destiny/manifest.json")
        for relative in sorted(manifest["files"]):
            if relative == "manifest.json":
                continue
            source = STAGE / relative
            if not source.is_file():
                raise FileNotFoundError(source)
            out.write(source, f"destiny/{relative}")
    with zipfile.ZipFile(CATALOGUE) as check:
        if check.testzip():
            raise ValueError("CRC invalide dans le catalogue source candidat.")
        names = set(check.namelist())
        if "destiny/Mod.xml" not in names or "destiny/manifest.json" not in names:
            raise ValueError("Catalogue candidat incomplet.")

    from source.pmdo_cote.build_destiny_quest_overlay import build

    OVERLAY.parent.mkdir(parents=True, exist_ok=True)
    report_sources = [
        ROOT / "source/pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv",
        ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv",
        ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_summary.json",
    ]
    attached_reports: list[str] = []
    try:
        result = build(CATALOGUE, OVERLAY, INVENTORY)
        with zipfile.ZipFile(OVERLAY, "a", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as out:
            existing = set(out.namelist())
            for report in report_sources:
                if not report.is_file():
                    continue
                member = f"PMD_Destiny_Quest_Overlay_0812/Documentation/{report.name}"
                if member in existing:
                    raise ValueError(f"Rapport déjà présent dans l’overlay candidat: {member}")
                out.write(report, member)
                existing.add(member)
                attached_reports.append(report.name)
        with zipfile.ZipFile(OVERLAY) as check:
            bad = check.testzip()
            if bad:
                raise ValueError(f"CRC invalide après ajout des rapports: {bad}")
        CATALOGUE.unlink(missing_ok=True)
    finally:
        CATALOGUE.unlink(missing_ok=True)
    result["bytes"] = OVERLAY.stat().st_size
    print(json.dumps({
        **result,
        "validationReportsIncluded": attached_reports,
        "catalogueSource": str(CATALOGUE),
        "mapOccurrences": manifest["mapCount"],
        "sourceOccurrences": manifest["sourceOccurrenceCount"],
        "blockedOccurrences": manifest["blockedSourceAssetOccurrences"],
        "generatedGroundUnavailable": manifest["generatedGroundOutputUnavailableOccurrences"],
        "tileSheets": manifest["tileIndexNodeCount"],
        "backgrounds": sum(1 for path in manifest["files"] if path.startswith("Content/BG/") and path.endswith(".dir")),
        "modXmlIncludedInOverlay": False,
        "installTargetPresent": False,
        "installable262Overlay": False,
        "note": "Partial 246-Ground overlay candidate; 16 unresolved source occurrences remain in provenance documentation.",
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
