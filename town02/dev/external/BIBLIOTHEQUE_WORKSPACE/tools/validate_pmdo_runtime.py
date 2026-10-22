#!/usr/bin/env python3
"""Run the exact PMDO 0.8.12 headless gate for the staged Relict pilot.

The ignored fixture extends Agent A's overlay/SDL method.  Runtime screenshots
are compared pixel-for-pixel with deterministic IR renders at PMDO ticks 0 and
15.  The fixture's native New Era player occupies 200 pixels; those pixels are
excluded and replaced before environmental evidence is exported, so no actor
sprite enters BIBLIOTHEQUE.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path
from typing import Any

from build_pmdo_runtime_fixture import ASSET, EVENTS, build
from inventory_relict import DEFAULT_OUTPUT, sha256_file, write_json
from png_rgba import RGBAImage, load_png, save_png

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
GAME_ROOT = DEFAULT_OUTPUT
PILOT_ROOT = GAME_ROOT / "conversion/pmdo_pilot/map_012"
FIXTURE_ROOT = REPO_ROOT / ".runtime-cache/bibliotheque-relict-map012-fixture"
BUNDLE = REPO_ROOT / ".runtime-cache/pmdo-headless-bundle"
PMDO = BUNDLE / "PMDO"
DOTNET_HEADLESS = REPO_ROOT / ".runtime-cache/dotnet-headless"
RUNTIME_OUTPUT = PILOT_ROOT / "runtime"


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def runtime_env(validator: bool) -> dict[str, str]:
    result = dict(os.environ)
    result.update({
        "DOTNET_BUNDLE_EXTRACT_BASE_DIR": str(DOTNET_HEADLESS),
        "LD_LIBRARY_PATH": str(BUNDLE),
        "SDL_VIDEODRIVER": "offscreen",
        "SDL_AUDIODRIVER": "dummy",
        "SDL_VIDEO_GL_DRIVER": str(BUNDLE / "libGLESv2.so"),
        "SDL_VIDEO_EGL_DRIVER": str(BUNDLE / "libEGL.so"),
        "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY": "1",
        "PMDO_HEADLESS_DISMISS_SPLASH": "1",
        "FNA3D_FORCE_DRIVER": "OpenGL",
        "FNA3D_OPENGL_FORCE_ES3": "1",
        "ANGLE_DEFAULT_PLATFORM": "vulkan",
        "VK_ICD_FILENAMES": str(BUNDLE / "vk_swiftshader_icd.absolute.json"),
    })
    if validator:
        result["PMDO_GROUND_VALIDATOR"] = "bibliotheque_relict_fixture"
    return result


def command(fixture: dict[str, Any], *extra: str) -> list[str]:
    return [
        str(PMDO),
        "-asset", fixture["asset_root"],
        "-appdata", fixture["appdata"],
        "-quest", fixture["quest_name"],
        *extra,
    ]


def wait_for_terminal(process: subprocess.Popen[bytes], events: Path, timeout: int) -> None:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if events.is_file() and '"event":"end"' in events.read_text(encoding="utf-8"):
            return
        if process.poll() is not None:
            raise RuntimeError(f"PMDO exited before terminal event: {process.returncode}")
        time.sleep(0.1)
    raise TimeoutError("PMDO runtime validator did not reach its terminal event")


def stop_group(process: subprocess.Popen[bytes]) -> None:
    if process.poll() is None:
        os.killpg(process.pid, signal.SIGTERM)
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait(timeout=5)


def compare_and_scrub(
    runtime_path: Path,
    expected_path: Path,
    output_path: Path,
    exclusion: tuple[int, int, int, int],
) -> dict[str, Any]:
    actual = load_png(runtime_path)
    expected = load_png(expected_path)
    if (actual.width, actual.height) != (expected.width, expected.height):
        raise ValueError("runtime screenshot dimensions differ from deterministic render")
    left, top, right, bottom = exclusion
    different_pixels = 0
    actor_pixels = 0
    outside_pixels = 0
    max_outside_delta = 0
    bounds: list[int] | None = None
    for pixel in range(actual.width * actual.height):
        offset = pixel * 4
        deltas = [abs(actual.pixels[offset + channel] - expected.pixels[offset + channel]) for channel in range(4)]
        if not any(deltas):
            continue
        different_pixels += 1
        x, y = pixel % actual.width, pixel // actual.width
        if bounds is None:
            bounds = [x, y, x, y]
        else:
            bounds = [min(bounds[0], x), min(bounds[1], y), max(bounds[2], x), max(bounds[3], y)]
        if left <= x < right and top <= y < bottom:
            actor_pixels += 1
        else:
            outside_pixels += 1
            max_outside_delta = max(max_outside_delta, *deltas)
    if outside_pixels:
        raise ValueError(f"runtime environment differs outside actor exclusion: {outside_pixels} pixels")

    scrubbed = RGBAImage(actual.width, actual.height, bytearray(actual.pixels))
    for y in range(top, bottom):
        start = (y * actual.width + left) * 4
        end = (y * actual.width + right) * 4
        scrubbed.pixels[start:end] = expected.pixels[start:end]
    if scrubbed.pixels != expected.pixels:
        raise ValueError("scrubbed environmental runtime image is not pixel-exact")
    save_png(scrubbed, output_path)
    return {
        "raw_runtime_sha256": sha256_file(runtime_path),
        "raw_runtime_pixels_exported": False,
        "expected_file": expected_path.relative_to(PILOT_ROOT).as_posix(),
        "expected_sha256": sha256_file(expected_path),
        "environment_evidence_file": output_path.relative_to(PILOT_ROOT).as_posix(),
        "environment_evidence_sha256": sha256_file(output_path),
        "dimensions_px": [actual.width, actual.height],
        "raw_different_pixel_count": different_pixels,
        "raw_difference_bounds_inclusive": bounds,
        "actor_excluded_pixel_count": actor_pixels,
        "environment_different_pixel_count": outside_pixels,
        "environment_max_channel_delta": max_outside_delta,
    }


def validate(candidate: Path, fixture_root: Path, output: Path, timeout: int) -> dict[str, Any]:
    required = [
        PMDO, DOTNET_HEADLESS, BUNDLE / "libGLESv2.so", BUNDLE / "libEGL.so",
        REPO_ROOT / ".runtime-cache/DumpAsset",
    ]
    missing = [str(path) for path in required if not path.exists()]
    if missing:
        raise ValueError("restore Agent A runtime first; missing: " + ", ".join(missing))

    fixture = build(REPO_ROOT, candidate.resolve(), fixture_root.resolve())
    index = subprocess.run(
        command(fixture, "-index", "zone"),
        cwd=REPO_ROOT,
        env=runtime_env(False),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
    )
    index_log = index.stdout
    forbidden_index = [b"ERROR", b"Exception", b"Failed to load", b"Could not load"]
    if any(token.lower() in index_log.lower() for token in forbidden_index):
        raise ValueError("PMDO index log contains an error signature")

    events_path = Path(EVENTS)
    events_path.unlink(missing_ok=True)
    screenshots = Path(fixture["appdata"]) / "SCREENSHOT"
    shutil.rmtree(screenshots, ignore_errors=True)
    screenshots.mkdir(parents=True)
    runtime_log_path = fixture_root / "runtime.log"
    with runtime_log_path.open("wb") as runtime_log:
        process = subprocess.Popen(
            command(fixture),
            cwd=REPO_ROOT,
            env=runtime_env(True),
            stdout=runtime_log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        try:
            wait_for_terminal(process, events_path, timeout)
        finally:
            stop_group(process)

    event_lines = [json.loads(line) for line in events_path.read_text(encoding="utf-8").splitlines()]
    results = [row for row in event_lines if row.get("event") == "result"]
    if len(results) != 1 or results[0].get("verdict") != "RUNTIME_PASS":
        raise ValueError(f"PMDO runtime verdict is not PASS: {results}")
    screenshot_paths = sorted(screenshots.glob("*.png"), key=lambda path: path.stat().st_mtime_ns)
    if len(screenshot_paths) != 2:
        raise ValueError(f"expected two PMDO screenshots, found {len(screenshot_paths)}")

    output.mkdir(parents=True, exist_ok=True)
    (output / "events.jsonl").write_text(
        "\n".join(json.dumps(row, ensure_ascii=False, separators=(",", ":")) for row in event_lines) + "\n",
        encoding="utf-8",
    )
    (output / "index.log").write_bytes(index_log)
    spawn = fixture["spawn"]["movement_probes"]["successful"]
    exclusion = (spawn["x"] - 16, spawn["y"] - 32, spawn["x"] + 32, spawn["y"] + 32)
    comparisons = []
    for tick, runtime_path in zip((0, 15), screenshot_paths, strict=True):
        comparisons.append({
            "pmdo_tick": tick,
            **compare_and_scrub(
                runtime_path,
                candidate / f"previews/composite_tick_{tick:03d}.png",
                output / f"environment_tick_{tick:03d}.png",
                exclusion,
            ),
        })
    if comparisons[0]["environment_evidence_sha256"] == comparisons[1]["environment_evidence_sha256"]:
        raise ValueError("runtime animation samples are byte-identical")

    report = {
        "schema_version": "1.0.0",
        "result": "PMDO_RUNTIME_VALIDATION_PASS",
        "validation_status": "PMDO_VALIDATED",
        "adaptation_status": "ADAPTATION_REQUIRED",
        "runtime_destination_written": False,
        "candidate": {
            "asset": ASSET,
            "ground_sha256": sha256_file(candidate / f"Data/Ground/{ASSET}.rsground"),
            "tile_sha256": sha256_file(candidate / f"Content/Tile/{ASSET}_Base.tile"),
        },
        "authority": {
            "pmdo_version": "0.8.12",
            "pmdo_sha256": sha256_file(PMDO),
            "headless_sdl_sha256": sha256_file(next(DOTNET_HEADLESS.rglob("libSDL2-2.0.so.0"))),
            "sdl_patch_sha256": sha256_file(REPO_ROOT / "tools/patches/pmdo-0.8.12-headless-sdl.patch"),
            "method": "Agent A ignored overlay + patched SDL + SwiftShader/ANGLE",
            "fixture_extension": "tools/build_pmdo_runtime_fixture.py",
        },
        "fixture": {
            "kind": fixture["kind"],
            "zone_index": fixture["zone_index"],
            "spawn": fixture["spawn"],
            "fixture_manifest_sha256": sha256_file(fixture_root / "fixture_manifest.json"),
            "events_file": (output / "events.jsonl").relative_to(PILOT_ROOT).as_posix(),
            "events_sha256": sha256_file(output / "events.jsonl"),
            "index_log_file": (output / "index.log").relative_to(PILOT_ROOT).as_posix(),
            "index_log_sha256": sha256_file(output / "index.log"),
            "index_error_signature_count": 0,
        },
        "runtime_probes": {
            "ground_load": "PASS",
            "successful_movement": "PASS",
            "blocked_movement": "PASS",
            "animation_samples": "PASS",
            "terminal_event": "PASS",
        },
        "visual_validation": {
            "actor_exclusion_rect": {
                "x": exclusion[0], "y": exclusion[1],
                "width": exclusion[2] - exclusion[0], "height": exclusion[3] - exclusion[1],
            },
            "actor_policy": (
                "Raw screenshots stay ignored and are not exported. Only the fixture-native actor "
                "rectangle is replaced by the deterministic environmental reference."
            ),
            "samples": comparisons,
        },
        "forbidden_content_check": {
            "source_actor_pixels_exported": False,
            "fixture_actor_pixels_exported": False,
            "dialogue_exported": False,
            "script_body_exported": False,
            "audio_binary_exported": False,
        },
    }
    write_json(output / "runtime_report.json", report)
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate", type=Path, default=PILOT_ROOT)
    parser.add_argument("--fixture-root", type=Path, default=FIXTURE_ROOT)
    parser.add_argument("--output", type=Path, default=RUNTIME_OUTPUT)
    parser.add_argument("--timeout", type=int, default=180)
    args = parser.parse_args()
    report = validate(args.candidate.resolve(), args.fixture_root.resolve(), args.output.resolve(), args.timeout)
    print(json.dumps({
        "result": report["result"],
        "validation_status": report["validation_status"],
        "ground_load": report["runtime_probes"]["ground_load"],
        "environment_samples": len(report["visual_validation"]["samples"]),
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
