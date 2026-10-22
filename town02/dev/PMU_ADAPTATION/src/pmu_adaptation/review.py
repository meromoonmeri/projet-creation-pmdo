from __future__ import annotations

from collections import Counter
from pathlib import Path
from typing import Any

from .composer import read_json, sha256_file, write_json


def apply_representative_visual_review(adaptation_root: Path, review_path: Path) -> dict[str, Any]:
    review = read_json(review_path)
    results = []
    for map_id, row in review["maps"].items():
        manifest_path = adaptation_root / "representative" / map_id / "manifest.json"
        manifest = read_json(manifest_path)
        manifest["visual_review_status"] = row["status"]
        manifest["visual_review"] = {
            "status": row["status"], "reason": row["reason"],
            "authority": review["authority"], "review_date": review["review_date"],
        }
        if row["status"] == "FAIL":
            manifest.setdefault("blockers", []).append("visual review failed: " + row["reason"])
            manifest["validation_status"] = "BLOCKED"
        elif row["status"] == "PASS":
            manifest["validation_status"] = (
                "VALIDATED"
                if manifest.get("runtime_status") == "RUNTIME_TESTED" and not manifest.get("blockers")
                else manifest.get("validation_status", "RUNTIME_TESTED")
            )
        else:
            manifest["validation_status"] = "BLOCKED"
        manifest["blockers"] = sorted(set(manifest.get("blockers", [])))
        write_json(manifest_path, manifest)
        results.append({
            "map_id": map_id, "ground_status": manifest.get("status"),
            "runtime_status": manifest.get("runtime_status"),
            "visual_review_status": manifest["visual_review_status"],
            "validation_status": manifest["validation_status"],
        })
    report_path = adaptation_root / "representative/report.json"
    report = read_json(report_path)
    report["visual_review"] = {
        "file": str(review_path), "sha256": sha256_file(review_path),
        "authority": review["authority"], "decision": review["decision"],
    }
    report["maps_final"] = results
    report["visual_review_status_counts"] = dict(Counter(row["visual_review_status"] for row in results))
    report["validation_status_counts"] = dict(Counter(row["validation_status"] for row in results))
    report["validated_count"] = sum(row["validation_status"] == "VALIDATED" for row in results)
    report["status"] = "REPRESENTATIVE_REJECTED_NO_GENERALIZATION" if report["validated_count"] == 0 else "REPRESENTATIVE_PARTIAL"
    write_json(report_path, report)
    return report
