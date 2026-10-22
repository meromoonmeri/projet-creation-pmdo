from __future__ import annotations

import gzip
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any

from PIL import Image

from .report import publish_reports
from .repository import manifest_markdown, read_gzip_json
from .util import atomic_write_json, sha256_file


def _failure(failures: list[dict[str, Any]], check: str, **details: Any) -> None:
    failures.append({"check": check, **details})


def validate_and_certify(cache_root: Path, reports_directory: Path) -> dict[str, Any]:
    global_path = cache_root / "global-manifest.json"
    global_manifest = json.loads(global_path.read_text(encoding="utf-8"))
    sql_report = json.loads((cache_root / "sql-import-report.json").read_text(encoding="utf-8"))
    tile_report = json.loads((cache_root / "tileset-audit-report.json").read_text(encoding="utf-8"))
    render_report = json.loads((cache_root / "render-report.json").read_text(encoding="utf-8"))
    inventory_report = json.loads((cache_root / "inventory-report.json").read_text(encoding="utf-8"))
    sheet_manifest = json.loads((cache_root / "source/contact-sheets/manifest.json").read_text(encoding="utf-8"))
    visual_path = cache_root / "source/contact-sheets/visual-review.json"
    visual_review = json.loads(visual_path.read_text(encoding="utf-8")) if visual_path.exists() else None

    failures: list[dict[str, Any]] = []
    checks = Counter()
    if len(global_manifest["maps"]) != 2000:
        _failure(failures, "global_map_count", expected=2000, actual=len(global_manifest["maps"]))
    if sql_report.get("integrity_check") != "ok":
        _failure(failures, "sqlite_integrity", actual=sql_report.get("integrity_check"))
    for field, expected in (("standard_map_count", 2000), ("expected_tile_count", 2120606), ("actual_tile_count", 2120606)):
        if sql_report.get(field) != expected:
            _failure(failures, f"sql_{field}", expected=expected, actual=sql_report.get(field))
    if sql_report.get("maps_with_tile_count_mismatch"):
        _failure(failures, "sql_tile_count_mismatches", values=sql_report["maps_with_tile_count_mismatch"])
    if tile_report.get("status") != "EXTRACTED" or tile_report.get("tileset_count") != 11 or tile_report.get("tile_count") != 52486:
        _failure(failures, "tileset_archive_audit", report_status=tile_report.get("status"), tilesets=tile_report.get("tileset_count"), tiles=tile_report.get("tile_count"))
    if render_report.get("status") != "RENDERED" or render_report.get("map_count") != 2000:
        _failure(failures, "render_report", status=render_report.get("status"), map_count=render_report.get("map_count"))

    render_by_map = {entry["map_id"]: entry for entry in render_report["maps"]}
    animated_count = 0
    distinct_count = 0
    canonical_ids = []
    for entry in global_manifest["maps"]:
        map_id = entry["map_id"]
        canonical_ids.append(map_id)
        canonical_path = Path(entry["canonical_source"])
        try:
            with gzip.open(canonical_path, "rb") as stream:
                canonical_payload = stream.read()
            if hashlib.sha256(canonical_payload).hexdigest() != entry["canonical_json_sha256"]:
                _failure(failures, "canonical_json_hash", map_id=map_id)
            map_data = json.loads(canonical_payload)
            width, height = map_data["max_x"] + 1, map_data["max_y"] + 1
            expected_tiles = width * height
            if len(map_data["tiles"]) != expected_tiles or len({(tile["x"], tile["y"]) for tile in map_data["tiles"]}) != expected_tiles:
                _failure(failures, "canonical_grid", map_id=map_id, expected=expected_tiles, actual=len(map_data["tiles"]))
            checks["canonical_ir"] += 1
        except Exception as exc:  # report the exact file without hiding later failures
            _failure(failures, "canonical_read", map_id=map_id, error=f"{type(exc).__name__}: {exc}")
            continue

        render = render_by_map.get(map_id)
        if not render:
            _failure(failures, "missing_render_entry", map_id=map_id)
            continue
        source_path = Path(render["source_png"])
        try:
            if sha256_file(source_path) != render["source_png_sha256"] or render["source_png_sha256"] != entry.get("source_png_sha256"):
                _failure(failures, "source_png_hash", map_id=map_id)
            with Image.open(source_path) as image:
                image.verify()
            with Image.open(source_path) as image:
                if list(image.size) != [width * 32, height * 32] or image.mode != "RGB":
                    _failure(failures, "source_png_geometry", map_id=map_id, expected=[width * 32, height * 32], actual=list(image.size), mode=image.mode)
            checks["source_png"] += 1
        except Exception as exc:
            _failure(failures, "source_png_read", map_id=map_id, error=f"{type(exc).__name__}: {exc}")
        if render["animated_references_present"]:
            animated_count += 1
            animated_path = Path(render["animated_png"])
            try:
                if sha256_file(animated_path) != render["animated_png_sha256"]:
                    _failure(failures, "animated_png_hash", map_id=map_id)
                with Image.open(animated_path) as image:
                    image.verify()
                with Image.open(animated_path) as image:
                    if list(image.size) != [width * 32, height * 32] or image.mode != "RGB":
                        _failure(failures, "animated_png_geometry", map_id=map_id)
                checks["animated_png"] += 1
                if render["animated_frame_distinct"]:
                    distinct_count += 1
            except Exception as exc:
                _failure(failures, "animated_png_read", map_id=map_id, error=f"{type(exc).__name__}: {exc}")

    expected_ids = [f"s{number}" for number in range(1, 2001)]
    if canonical_ids != expected_ids:
        _failure(failures, "canonical_id_sequence", expected="s1..s2000 in order")
    if animated_count != 962 or distinct_count != 917:
        _failure(failures, "animation_counts", expected_maps=962, actual_maps=animated_count, expected_distinct=917, actual_distinct=distinct_count)

    sheet_names = []
    for sheet in sheet_manifest.get("sheets", []):
        path = Path(sheet["path"])
        sheet_names.append(path.name)
        try:
            if sha256_file(path) != sheet["sha256"]:
                _failure(failures, "contact_sheet_hash", path=str(path))
            with Image.open(path) as image:
                image.verify()
            with Image.open(path) as image:
                expected_height = ((sheet["map_count"] + 7) // 8) * 160
                if image.size != (1536, expected_height) or image.mode != "RGB":
                    _failure(failures, "contact_sheet_geometry", path=str(path), actual=list(image.size), expected=[1536, expected_height])
            checks["contact_sheet"] += 1
        except Exception as exc:
            _failure(failures, "contact_sheet_read", path=str(path), error=f"{type(exc).__name__}: {exc}")
    if sheet_manifest.get("sheet_count") != 32 or sheet_manifest.get("map_count") != 2000:
        _failure(failures, "contact_sheet_coverage", expected_sheets=32, actual_sheets=sheet_manifest.get("sheet_count"), actual_maps=sheet_manifest.get("map_count"))
    if not visual_review:
        _failure(failures, "visual_review", reason="visual-review.json missing")
    else:
        reviewed_names = sorted(Path(value).name for value in visual_review.get("reviewed_contact_sheets", []))
        if visual_review.get("result") != "PASS" or reviewed_names != sorted(sheet_names):
            _failure(failures, "visual_review", result=visual_review.get("result"), reviewed_sheet_count=len(reviewed_names))

    if inventory_report.get("invalid_graphic_raw_count") != render_report.get("invalid_graphic_reference_count"):
        _failure(failures, "invalid_graphic_reconciliation", render=render_report.get("invalid_graphic_reference_count"), inventory=inventory_report.get("invalid_graphic_raw_count"))
    if inventory_report.get("unknown_tile_count") != 6:
        _failure(failures, "unknown_tile_count", expected=6, actual=inventory_report.get("unknown_tile_count"))

    passed = not failures
    status_counts = Counter()
    if passed:
        blocked_ids = {
            entry["map_id"] for entry in global_manifest["maps"] if entry.get("blocked_client_dat", {}).get("status") == "BLOCKED"
        }
        unknown_ids = {"s263", "s268"}
        markdown_dir = cache_root / "source/manifests-md"
        for entry in global_manifest["maps"]:
            map_id = entry["map_id"]
            manifest_path = Path(entry["manifest"])
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            partial_reasons = []
            if map_id in blocked_ids:
                partial_reasons.append("client V9 cache comparison BLOCKED by unpublished deployment key")
            if map_id in unknown_ids:
                partial_reasons.append("tile values 101/103 absent from public enum; semantics UNKNOWN")
            certification = {
                "canonical_sql_snapshot_raster": "SOURCE_CERTIFIED",
                "canonical_sql_snapshot_structure": "SOURCE_CERTIFIED" if map_id not in unknown_ids else "PARTIAL",
                "client_v9_cache_comparison": "BLOCKED" if map_id in blocked_ids else "NOT_PRESENT",
                "visual_review": "PASS",
                "source_runtime_logic": "PROVEN_FROM_PUBLIC_SOURCE",
                "pmdo_runtime": "NOT_STARTED",
                "partial_reasons": partial_reasons,
            }
            manifest["certification"] = certification
            manifest["status"] = "PARTIAL" if partial_reasons else "SOURCE_CERTIFIED"
            entry["certification"] = certification
            entry["status"] = manifest["status"]
            status_counts[entry["status"]] += 1
            atomic_write_json(manifest_path, manifest)
            (markdown_dir / f"{map_id}.md").write_text(manifest_markdown(manifest), encoding="utf-8", newline="\n")
        global_manifest["maps"] = global_manifest["maps"]
        global_manifest["status"] = "PARTIAL"
        global_manifest["canonical_sql_snapshot_status"] = "SOURCE_CERTIFIED"
        global_manifest["certification_status_counts"] = dict(status_counts)
        global_manifest["certification_scope"] = {
            "certified": "2,000-map public server SQL snapshot, canonical structured IR, source PNGs, animated states, hashes and dimensions",
            "partial": "137 encrypted client cache comparisons, blocked-only s3000, and six UNKNOWN tile semantics on s263/s268",
            "phase_2_pmdo": "AUTHORIZED only for the SOURCE_CERTIFIED 2,000-map public SQL snapshot; blocked for cache-only or unresolved alternate-source content",
        }
        global_manifest["phase_2_pmdo"] = "AUTHORIZED_FOR_CERTIFIED_SQL_SNAPSHOT_ONLY: use a separate adaptation pipeline; never overwrite phase-1 artifacts"
        atomic_write_json(global_path, global_manifest)

    report = {
        "status": "SOURCE_CERTIFIED" if passed else "PARTIAL",
        "global_status": "PARTIAL",
        "certification_scope": "canonical 2,000-map public SQL snapshot" if passed else "none",
        "map_count": len(global_manifest["maps"]), "canonical_ir_verified": checks["canonical_ir"],
        "source_png_verified": checks["source_png"], "animated_png_verified": checks["animated_png"],
        "contact_sheets_verified": checks["contact_sheet"], "animation_map_count": animated_count,
        "animation_distinct_map_count": distinct_count, "failure_count": len(failures), "failures": failures,
        "known_nonblocking_source_anomalies": {
            "deduplicated_invalid_graphics": inventory_report.get("invalid_graphic_deduplicated_count"),
            "behavior": "official tile-0 fallback preserved",
            "unknown_tile_semantics": 6,
        },
        "blocked_source_gaps": global_manifest.get("blocked_standard_client_caches"),
        "visual_review": visual_review,
    }
    atomic_write_json(cache_root / "certification-report.json", report)
    if passed:
        publish_reports(cache_root, reports_directory)
    return report
