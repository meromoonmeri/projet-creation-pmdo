#!/usr/bin/env python3
"""Audit every current consumer of the shared Treeshroud material names.

A b41 candidate may be pixel-correct yet still be unsafe to promote under the
old ``treeshroud_forest_1_*`` names: Relic Forest blobs, arenas and Grounds
also resolve those names. This read-only audit makes that dependency explicit
and blocks a shared-name promotion until a unique Sinister Woods namespace or
an independently validated Relic Forest decoupling exists.
"""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import argparse
import hashlib
import json
from collections import defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
TOKENS = (
    "treeshroud_forest_1_floor",
    "treeshroud_forest_1_wall",
    "treeshroud_forest_1_secondary",
    "TreeshroudForest1",
    "sinister_woods_b41_floor",
    "sinister_woods_b41_wall",
    "sinister_woods_b41_secondary",
    "SinisterWoodsB41",
)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def classify(path: Path) -> str:
    rel = path.relative_to(ROOT).as_posix()
    if rel.startswith("Data/Zone/"):
        return "zone_runtime"
    if rel.startswith("Data/Map/"):
        return "map_runtime"
    if rel.startswith("Data/Ground/"):
        return "ground_runtime"
    if rel.startswith("Data/Script/"):
        return "script_runtime"
    if rel.startswith("tools/"):
        return "audit_tool"
    if rel.startswith("docs/"):
        return "documentation"
    return "other"


def audit() -> dict[str, Any]:
    refs: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for root in (ROOT / "Data", ROOT / "Content", ROOT / "tools", ROOT / "docs"):
        for path in root.rglob("*"):
            if not path.is_file() or ".runtime-cache" in path.parts:
                continue
            try:
                text = path.read_text(encoding="utf-8-sig")
            except (UnicodeDecodeError, OSError):
                continue
            matches = {token: text.count(token) for token in TOKENS if token in text}
            if matches:
                refs[classify(path)].append({
                    "path": path.relative_to(ROOT).as_posix(),
                    "matches": matches,
                    "total": sum(matches.values()),
                })
    for group in refs:
        refs[group].sort(key=lambda row: row["path"])

    runtime = [row for group in ("zone_runtime", "map_runtime", "ground_runtime") for row in refs.get(group, [])]
    sinister_zone = next((row for row in runtime if row["path"] == "Data/Zone/gloomy_forest.json"), None)
    relic_zone = next((row for row in runtime if row["path"] == "Data/Zone/relic_forest.json"), None)
    relic_maps = [row for row in runtime if row["path"].startswith("Data/Map/relic_forest_blob_")]
    non_sinister_runtime = [row for row in runtime if row["path"] != "Data/Zone/gloomy_forest.json"]
    sinister_shared_count = sum(
        value for token, value in (sinister_zone or {}).get("matches", {}).items()
        if token.startswith("treeshroud_") or token == "TreeshroudForest1"
    )
    sinister_unique_count = sum(
        value for token, value in (sinister_zone or {}).get("matches", {}).items()
        if token.startswith("sinister_woods_b41_") or token == "SinisterWoodsB41"
    )
    unique_namespace_route = sinister_shared_count == 0 and sinister_unique_count > 0
    blockers = []
    if sinister_zone is None:
        blockers.append("SINISTER_ZONE_CONSUMER_MISSING")
    if relic_zone is None:
        blockers.append("RELIC_FOREST_ZONE_CONSUMER_MISSING")
    if len(relic_maps) != 6:
        blockers.append("RELIC_BLOB_TRANSITIVE_CONSUMER_COUNT_MISMATCH")
    if non_sinister_runtime and not unique_namespace_route:
        blockers.append("SHARED_TREESHROUD_NAMES_HAVE_NON_SINISTER_RUNTIME_CONSUMERS")

    return {
        "schema": "new-era.pmdred-eu.sinister-woods-material-consumer-audit.v1",
        "tokens": list(TOKENS),
        "runtime_consumers": refs,
        "findings": {
            "sinister_woods_zone": sinister_zone,
            "relic_forest_zone": relic_zone,
            "relic_forest_blob_map_count": len(relic_maps),
            "non_sinister_runtime_consumers": non_sinister_runtime,
            "shared_name_promotion_is_unsafe": bool(non_sinister_runtime),
            "sinister_shared_reference_count": sinister_shared_count,
            "sinister_unique_namespace_reference_count": sinister_unique_count,
            "unique_namespace_route_proven": unique_namespace_route,
            "safe_route": "unique_sinister_woods_b41_namespace_or_independently_decouple_all_non_sinister_consumers",
            "relic_forest_assets_must_remain_untouched": True,
        },
        "production_route_written": False,
        "blockers": blockers,
        "result": "BLOCKED_WITH_EXACT_MISSING_COMPONENT" if blockers else "PASS_UNIQUE_NAMESPACE_SEPARATED",
        "exact_missing_component": "SHARED_TREESHROUD_CONSUMERS_REQUIRE_DECOUPLING_BEFORE_PROMOTION" if blockers else None,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", type=Path)
    args = parser.parse_args()
    result = audit()
    if args.write:
        path = args.write if args.write.is_absolute() else ROOT / args.write
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if not result["blockers"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
