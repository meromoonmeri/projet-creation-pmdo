from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from .audit import audit_sources
from .dat_maps import extract_dat_maps
from .render import make_contact_sheets, render_all
from .report import publish_reports
from .repository import build_canonical_repository
from .sql_dump import import_sql_dump
from .tilesets import audit_tilesets
from .inventories import build_inventories
from .validation import validate_and_certify


def paths(repo_root: Path, cache_override: str | None = None) -> dict[str, Path]:
    cache = Path(cache_override) if cache_override else repo_root / ".runtime-cache/pmu-extraction"
    pmu = repo_root / ".runtime-cache/pmu"
    return {
        "repo": repo_root, "cache": cache, "pmu": pmu,
        "client": pmu / "PMU-Client", "server": pmu / "PMU-Server",
        "sql_db": cache / "pmu-standard.sqlite3", "dat": cache / "dat-maps",
        "global": cache / "global-manifest.json",
    }


def run_step(name: str, p: dict[str, Path]):
    c = p["cache"]; c.mkdir(parents=True, exist_ok=True)
    if name == "audit":
        return audit_sources(p["pmu"], c / "source-audit.json")
    if name == "sql":
        return import_sql_dump(p["server"] / "Content_Data.zip", p["sql_db"], c / "sql-import-report.json")
    if name == "dat":
        return extract_dat_maps(p["client"] / "resources/MapData", p["dat"], c / "dat-extraction-report.json")
    if name == "tiles":
        atlas_dir = p["pmu"] / "pmdcp-PMD-Toolkit/Dependencies/Assets/Tile"
        return audit_tilesets(p["client"] / "resources/GFX/Tiles", c / "tileset-audit-report.json", atlas_dir if atlas_dir.exists() else None)
    if name == "canonical":
        return build_canonical_repository(p["sql_db"], p["dat"], c, p["global"])
    if name == "render":
        return render_all(p["global"], p["client"] / "resources/GFX/Tiles", c, c / "render-report.json")
    if name == "sheets":
        return make_contact_sheets(p["global"], c / "source/contact-sheets")
    if name == "inventory":
        return build_inventories(p["sql_db"], c, p["server"])
    if name == "validate":
        return validate_and_certify(c, p["repo"] / "PMU_EXTRACTION/reports")
    if name == "publish":
        return publish_reports(c, p["repo"] / "PMU_EXTRACTION/reports")
    raise ValueError(name)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="PMU canonical source extraction pipeline — phase 1 only")
    parser.add_argument("command", choices=("audit", "sql", "dat", "tiles", "canonical", "render", "sheets", "inventory", "validate", "publish", "all"))
    parser.add_argument("--repo-root", default=os.getcwd())
    parser.add_argument("--cache-root")
    args = parser.parse_args(argv)
    p = paths(Path(args.repo_root).resolve(), args.cache_root)
    sequence = ("audit", "sql", "dat", "tiles", "canonical", "render", "sheets", "inventory", "validate", "publish") if args.command == "all" else (args.command,)
    for step in sequence:
        result = run_step(step, p)
        print(json.dumps({"step": step, "status": result.get("status", "OK"), "map_count": result.get("map_count")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
