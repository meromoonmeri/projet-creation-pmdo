from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from .planner import build_plans
from .composer import compose_representative
from .runtime import validate_representative
from .review import apply_representative_visual_review
from .publish import publish_representative


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Strict PMU phase-2 PMDO adaptation pipeline")
    parser.add_argument("command", choices=("plan", "compose-representative", "validate-representative", "review-representative", "publish-representative"))
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--repo-root", default=os.getcwd())
    parser.add_argument("--source-root")
    parser.add_argument("--output-root")
    parser.add_argument("--seed", type=int, default=20260814)
    args = parser.parse_args(argv)
    repo = Path(args.repo_root).resolve()
    source = Path(args.source_root).resolve() if args.source_root else repo / ".runtime-cache/pmu-extraction"
    output = Path(args.output_root).resolve() if args.output_root else repo / ".runtime-cache/pmu-adaptation"
    if args.command == "plan":
        report = build_plans(repo, source, output, repo / "PMU_ADAPTATION/reports", args.seed)
        print(json.dumps({
            "step": "plan", "status": report["status"], "map_count": report["map_count"],
            "ground_count": report["ground_count"], "certified_count": report["certified_count"],
        }, sort_keys=True))
    elif args.command == "compose-representative":
        report = compose_representative(
            repo, source, output, repo / "PMU_ADAPTATION/config/representative-group.json"
        )
        print(json.dumps({
            "step": "compose-representative", "status": report["status"],
            "map_count": report["map_count"], "status_counts": report["status_counts"],
        }, sort_keys=True))
    elif args.command == "validate-representative":
        report = validate_representative(
            repo, output, repo / "PMU_ADAPTATION/config/representative-group.json", args.timeout
        )
        print(json.dumps({
            "step": "validate-representative", "status": report["status"],
            "runtime_status_counts": report["runtime_status_counts"],
            "validation_status_counts": report["validation_status_counts"],
        }, sort_keys=True))
    elif args.command == "review-representative":
        report = apply_representative_visual_review(
            output, repo / "PMU_ADAPTATION/config/representative-visual-review.json"
        )
        print(json.dumps({
            "step": "review-representative", "status": report["status"],
            "visual_review_status_counts": report["visual_review_status_counts"],
            "validation_status_counts": report["validation_status_counts"],
        }, sort_keys=True))
    elif args.command == "publish-representative":
        report = publish_representative(repo, output, repo / "PMU_ADAPTATION/reports")
        print(json.dumps({
            "step": "publish-representative", "status": report["status"],
            "map_count": report["map_count"], "validated_count": report["validated_count"],
            "generalization_authorized": report["generalization_authorized"],
        }, sort_keys=True))
    return 0
