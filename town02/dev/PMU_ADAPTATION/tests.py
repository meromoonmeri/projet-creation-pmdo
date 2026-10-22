#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent
sys.path.insert(0, str(ROOT / "src"))

from pmu_adaptation.planner import choose_tex_size, source_category, tags_for


def main() -> None:
    sample = {
        "max_x": 50, "max_y": 50, "name": "Exbel, Grassroot Town", "indoors": 0,
        "npcs": [{}, {}, {}], "tiles": [{"type": 2}],
        "up_map": 0, "down_map": 0, "left_map": 0, "right_map": 0,
    }
    tags = tags_for(sample["name"])
    assert {"settlement", "forest"} <= tags
    category, _ = source_category(sample, tags)
    assert category == "settlement"
    tex_size, reasons = choose_tex_size(sample, category, 12, 20, 8)
    assert tex_size == 1 and reasons

    summary = REPO / "PMU_ADAPTATION/reports/adaptation-plan-summary.json"
    index = REPO / "PMU_ADAPTATION/reports/adaptation-plan-index.json"
    if summary.exists() and index.exists():
        report = json.loads(summary.read_text(encoding="utf-8"))
        plans = json.loads(index.read_text(encoding="utf-8"))
        assert report["phase1_gate"] == "PASS"
        assert report["map_count"] == 2000
        assert report["ground_count"] == 0
        assert report["pmdo_runtime_validated_count"] == 0
        assert report["certified_count"] == 0
        assert sum(report["tex_size_counts"].values()) == 2000
        assert [row["map_id"] for row in plans["maps"]] == [f"s{value}" for value in range(1, 2001)]
        assert all(row["ground_status"] == "NOT_GENERATED" for row in plans["maps"])
        by_id = {row["map_id"]: row for row in plans["maps"]}
        assert by_id["s737"]["pmdo_tex_size"] == 1
        assert by_id["s1810"]["pmdo_tex_size"] == 2  # source marks this record indoors
        assert by_id["s1991"]["pmdo_tex_size"] == 1
        # A generic town grammar is not enough to certify a snowy town.
        assert by_id["s1991"]["status"] == "ADAPTATION_REQUIRED"

    representative = REPO / ".runtime-cache/pmu-adaptation/representative/report.json"
    if representative.exists():
        result = json.loads(representative.read_text(encoding="utf-8"))
        assert result["phase1_integrity"] == "PASS"
        assert result["validated_count"] == 0
        assert result["status"] == "REPRESENTATIVE_REJECTED_NO_GENERALIZATION"
        assert result["visual_review_status_counts"]["FAIL"] >= 1
        assert all(row["validation_status"] != "VALIDATED" for row in result["maps_final"])
        for row in result["maps_final"]:
            manifest = json.loads((REPO / f".runtime-cache/pmu-adaptation/representative/{row['map_id']}/manifest.json").read_text(encoding="utf-8"))
            if manifest.get("runtime_status") == "RUNTIME_TESTED":
                runtime = json.loads(Path(manifest["outputs"]["runtime_report"]).read_text(encoding="utf-8"))
                assert runtime["pmdo_version"] == "0.8.12"
                assert runtime["probes"]["verdict"] == "RUNTIME_PASS"
                assert runtime["source_png_used_by_runtime"] is False
    print("PMU adaptation tests: OK")


if __name__ == "__main__":
    main()
