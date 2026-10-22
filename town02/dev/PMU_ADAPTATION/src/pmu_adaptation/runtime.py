from __future__ import annotations

import json
import os
import shutil
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any

from build_pmdred_eu_runtime_fixture import (
    fixture_ground, overlay_children, overlay_data_root, read_json, read_tile_index,
    symlink, tile_node, write_json_bom, write_tile_index,
)
from pmdo_ground.ground_runtime import (
    EVENTS, capture_points, ground_script, runtime_env, sha256_file, validator_script,
)

from .composer import read_json as load_json, write_json


def _candidate_paths(adaptation_root: Path, map_id: str, manifest: dict[str, Any]) -> tuple[Path, Path]:
    ground = Path(manifest["outputs"]["ground"])
    tile = Path(manifest["outputs"]["tile"])
    if not ground.is_file() or not tile.is_file():
        raise ValueError(f"{map_id}: generated Ground/tile missing")
    if sha256_file(ground) != manifest["outputs"]["ground_sha256"]:
        raise ValueError(f"{map_id}: Ground hash changed")
    if sha256_file(tile) != manifest["outputs"]["tile_sha256"]:
        raise ValueError(f"{map_id}: tile hash changed")
    return ground, tile


def build_fixture(repo: Path, ground_path: Path, tile_path: Path, output: Path, ticks: list[int]) -> dict[str, Any]:
    payload = read_json(ground_path)
    ground = payload["Object"]
    asset = ground["AssetName"]
    sheet = tile_path.stem
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    quest = output / "quest"

    symlink(repo / "Mod.xml", quest / "Mod.xml")
    symlink(repo / "Strings", quest / "Strings")
    overlay_data_root(repo / "Data", quest / "Data", {"Ground", "Zone", "Script", "Misc"})
    shutil.copytree(repo / "Data/Misc", quest / "Data/Misc")
    overlay_children(repo / "Data/Ground", quest / "Data/Ground", {ground_path.name})
    (quest / "Data/Zone").mkdir(parents=True)
    overlay_children(repo / "Data/Script", quest / "Data/Script", {"halcyon"})
    overlay_children(repo / "Data/Script/halcyon", quest / "Data/Script/halcyon", {"ground", "services"})
    overlay_children(repo / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground", {asset})
    overlay_children(repo / "Data/Script/halcyon/services", quest / "Data/Script/halcyon/services", {"ground_gameplay_validator"})

    overlay_children(repo / "Content", quest / "Content", {"Tile"})
    overlay_children(repo / "Content/Tile", quest / "Content/Tile", {"index.idx", f"{sheet}.tile"})
    symlink(tile_path, quest / "Content/Tile" / f"{sheet}.tile")
    nodes = read_tile_index(repo / "Content/Tile/index.idx")
    raw = tile_path.read_bytes()
    node, end = tile_node(raw)
    if end + 8 > len(raw) or raw[end + 8:end + 16] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"{sheet}: invalid PMDO .tile content boundary")
    if sheet in nodes and nodes[sheet] != node:
        raise ValueError(f"fixture refuses conflicting tile node {sheet}")
    nodes[sheet] = node
    write_tile_index(quest / "Content/Tile/index.idx", nodes)
    if read_tile_index(quest / "Content/Tile/index.idx") != nodes:
        raise ValueError("fixture tile index round-trip failed")

    fixture_ground_path = quest / "Data/Ground" / ground_path.name
    spawn = fixture_ground(ground_path, fixture_ground_path)
    captures = capture_points(payload, None, spawn)
    zone = read_json(repo / "Data/Zone/master_zone.json")
    maps = zone["Object"]["GroundMaps"]
    if asset not in maps:
        maps.append(asset)
    zone_index = maps.index(asset)
    write_json_bom(quest / "Data/Zone/master_zone.json", zone)

    script_dir = quest / "Data/Script/halcyon/ground" / asset
    script_dir.mkdir(parents=True)
    (script_dir / "init.lua").write_text(ground_script(asset), encoding="utf-8", newline="\n")
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    (service_dir / "init.lua").write_text(
        validator_script(asset, zone_index, spawn["movement_probes"], captures, ticks),
        encoding="utf-8", newline="\n",
    )

    asset_root = output / "asset"
    overlay_children(repo / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    symlink(quest, appdata / "MODS/smart_ground_fixture")
    manifest = {
        "schema": "new-era.pmu-agent-a-runtime-fixture.v1",
        "kind": "ignored_agent_a_overlay_extension", "asset": asset,
        "ground_source": str(ground_path), "ground_sha256": sha256_file(ground_path),
        "tile_source": str(tile_path), "tile_sha256": sha256_file(tile_path),
        "sheet": sheet, "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep, "quest_name": "smart_ground_fixture",
        "zone_index": zone_index, "spawn": spawn, "captures": captures,
        "ticks": ticks, "events": str(EVENTS),
    }
    write_json(output / "fixture_manifest.json", manifest)
    return manifest


def validate_one(repo: Path, adaptation_root: Path, map_id: str, timeout: int = 300) -> dict[str, Any]:
    candidate = adaptation_root / "representative" / map_id
    manifest_path = candidate / "manifest.json"
    manifest = load_json(manifest_path)
    manifest["blockers"] = [
        blocker for blocker in manifest.get("blockers", [])
        if not blocker.startswith("PMDO runtime failure:")
    ]
    if manifest.get("status") != "GROUND_GENERATED":
        return {
            "map_id": map_id, "status": manifest.get("status", "BLOCKED"),
            "runtime_status": "NOT_RUN", "validation_status": manifest.get("validation_status", "BLOCKED"),
        }
    required = [
        repo / ".runtime-cache/pmdo-headless-bundle/PMDO",
        repo / ".runtime-cache/dotnet-headless",
        repo / ".runtime-cache/DumpAsset",
    ]
    missing = [str(path) for path in required if not path.exists()]
    if missing:
        raise ValueError("restore Agent A runtime first; missing: " + ", ".join(missing))
    ground, tile = _candidate_paths(adaptation_root, map_id, manifest)
    animated = any(manifest["animation"]["source_counts"].values())
    ticks = [0, 15] if animated else [0]
    fixture_root = adaptation_root / "runtime-fixtures" / map_id
    runtime_root = candidate / "runtime"
    if runtime_root.exists():
        shutil.rmtree(runtime_root)
    runtime_root.mkdir(parents=True)
    fixture = build_fixture(repo, ground, tile, fixture_root, ticks)
    env = runtime_env(repo)

    command = [
        str(repo / ".runtime-cache/pmdo-headless-bundle/PMDO"),
        "-asset", fixture["asset_root"], "-appdata", fixture["appdata"],
        "-quest", fixture["quest_name"], "-index", "zone",
    ]
    index = subprocess.run(command, cwd=repo, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300)
    (runtime_root / "index.log").write_bytes(index.stdout)
    signatures = (b"exception", b"failed to load", b"could not load", b"error loading")
    if index.returncode != 0 or any(token in index.stdout.lower() for token in signatures):
        raise ValueError(f"{map_id}: PMDO index/load signature failure")

    EVENTS.unlink(missing_ok=True)
    screenshots = Path(fixture["appdata"]) / "SCREENSHOT"
    shutil.rmtree(screenshots, ignore_errors=True)
    screenshots.mkdir(parents=True)
    gate_command = [
        str(repo / ".runtime-cache/pmu-venv/bin/python"),
        str(repo / "tools/run_pmdred_eu_pmdo_termination_gate.py"),
        "--pmdo", str(repo / ".runtime-cache/pmdo-headless-bundle/PMDO"),
        "--asset", fixture["asset_root"], "--appdata", fixture["appdata"],
        "--quest", fixture["quest_name"], "--events", str(EVENTS),
        "--runtime-log", str(runtime_root / "runtime.log"),
        "--event-copy", str(runtime_root / "events.jsonl"),
        "--status-json", str(runtime_root / "termination.json"),
        "--terminal-timeout", str(timeout), "--post-end-delay", "10.0", "--shutdown-signal", "INT", "--reset-events",
    ]
    gate = subprocess.run(gate_command, cwd=repo, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout + 60)
    (runtime_root / "termination.stdout.log").write_bytes(gate.stdout)
    if gate.returncode != 0:
        raise ValueError(f"{map_id}: exact PMDO termination gate failed: {gate.stdout.decode(errors='replace')[-800:]}")
    runtime_bytes = (runtime_root / "runtime.log").read_bytes().lower()
    runtime_error_signatures = (
        b"exception depth", b"failed to load", b"could not load",
        b"not present in the dictionary", b"unhandled exception",
    )
    hits = [token.decode() for token in runtime_error_signatures if token in runtime_bytes]
    if hits:
        raise ValueError(f"{map_id}: PMDO runtime log contains error signatures: {hits}")
    events = [json.loads(line) for line in (runtime_root / "events.jsonl").read_text().splitlines()]
    results = [row for row in events if row.get("event") == "result"]
    if len(results) != 1 or results[0].get("verdict") != "RUNTIME_PASS":
        raise ValueError(f"{map_id}: PMDO runtime probes failed: {results}")
    shots = sorted(screenshots.glob("*.png"), key=lambda path: path.stat().st_mtime_ns)
    labels = [(row["label"], tick) for row in fixture["captures"] for tick in ticks]
    if len(shots) != len(labels):
        raise ValueError(f"{map_id}: expected {len(labels)} runtime captures, found {len(shots)}")
    capture_rows = []
    for source, (label, tick) in zip(shots, labels, strict=True):
        destination = runtime_root / f"{label}_tick_{tick:03d}.png"
        shutil.copy2(source, destination)
        capture_rows.append({"label": label, "tick": tick, "file": str(destination), "sha256": sha256_file(destination), "bytes": destination.stat().st_size})
    if animated and all(row["sha256"] == capture_rows[0]["sha256"] for row in capture_rows[1:]):
        # Do not call the runtime broken: a camera sample can legitimately miss
        # distant animation. Retain this as a visual-coverage blocker.
        animation_capture = "UNVERIFIED_IDENTICAL_CAMERA_SAMPLES"
    else:
        animation_capture = "PASS" if animated else "NOT_APPLICABLE_STATIC"
    runtime_report = {
        "schema": "new-era.pmu-pmdo-runtime.v1", "map_id": map_id,
        "status": "RUNTIME_TESTED", "pmdo_version": "0.8.12",
        "method": "Agent A ignored overlay + patched SDL + SwiftShader/ANGLE + exact termination gate",
        "pmdo_sha256": sha256_file(repo / ".runtime-cache/pmdo-headless-bundle/PMDO"),
        "ground_sha256": sha256_file(ground), "tile_sha256": sha256_file(tile),
        "index": {"status": "PASS", "log": str(runtime_root / "index.log"), "sha256": sha256_file(runtime_root / "index.log")},
        "probes": results[0], "termination": load_json(runtime_root / "termination.json"),
        "captures": capture_rows, "animation_capture": animation_capture,
        "source_png_used_by_runtime": False,
    }
    write_json(runtime_root / "runtime_report.json", runtime_report)
    manifest["runtime_status"] = "RUNTIME_TESTED"
    manifest["outputs"]["runtime_report"] = str(runtime_root / "runtime_report.json")
    manifest["outputs"]["runtime_report_sha256"] = sha256_file(runtime_root / "runtime_report.json")
    manifest["outputs"]["pmdo_png"] = capture_rows[0]["file"] if capture_rows else None
    manifest["validation_status"] = (
        "VALIDATED"
        if not manifest["blockers"]
        and animation_capture in {"PASS", "NOT_APPLICABLE_STATIC"}
        and manifest.get("visual_review_status") == "PASS"
        else "RUNTIME_TESTED"
    )
    write_json(manifest_path, manifest)
    return {"map_id": map_id, "status": manifest["status"], "runtime_status": manifest["runtime_status"], "validation_status": manifest["validation_status"]}


def validate_representative(repo: Path, adaptation_root: Path, config_path: Path, timeout: int = 300) -> dict[str, Any]:
    config = load_json(config_path)
    results = []
    for map_id in config["maps"]:
        try:
            results.append(validate_one(repo, adaptation_root, map_id, timeout))
        except Exception as exc:
            candidate = adaptation_root / "representative" / map_id
            manifest_path = candidate / "manifest.json"
            manifest = load_json(manifest_path) if manifest_path.exists() else {"map_id": map_id}
            manifest["runtime_status"] = "BLOCKED"
            manifest["validation_status"] = "BLOCKED"
            manifest.setdefault("blockers", []).append(f"PMDO runtime failure: {type(exc).__name__}: {exc}")
            write_json(manifest_path, manifest)
            results.append({"map_id": map_id, "status": manifest.get("status", "BLOCKED"), "runtime_status": "BLOCKED", "validation_status": "BLOCKED"})
    counts = Counter(row["runtime_status"] for row in results)
    validations = Counter(row["validation_status"] for row in results)
    report_path = adaptation_root / "representative/report.json"
    report = load_json(report_path)
    report["runtime_status_counts"] = dict(counts)
    report["validation_status_counts"] = dict(validations)
    report["runtime_tested_count"] = counts["RUNTIME_TESTED"]
    report["validated_count"] = validations["VALIDATED"]
    report["maps_runtime"] = results
    report["status"] = "RUNTIME_PASS_WITH_BLOCKERS" if counts["RUNTIME_TESTED"] else "BLOCKED"
    write_json(report_path, report)
    return report
