#!/usr/bin/env python3
"""Differentially validate all normalized EU Ground BMA auxiliary layers.

This audit covers camera dimensions, the optional unknown/data block, collision
layer 1, and collision layer 2.  The implementation is compared byte-for-byte
with SkyTemple for every BMA in the authoritative normalized extraction.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from pmdred_dungeon_ground import (
    EXPECTED_EU_ROM_SHA256,
    ReconstructionError,
    differential_validate_bma_auxiliary,
    sha256,
)

TOOL_VERSION = "1.0.0"


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def audit(source_dir: Path, authority_manifest: Path) -> dict[str, Any]:
    manifest = json.loads(authority_manifest.read_text(encoding="utf-8"))
    authority = manifest.get("authority", {}).get("rom", {})
    if authority.get("sha256") != EXPECTED_EU_ROM_SHA256:
        raise ReconstructionError("authority manifest is not the checked European ROM")
    if manifest.get("validation", {}).get("status") != "pass":
        raise ReconstructionError(
            "authority manifest does not record a passing extraction"
        )

    expected = {
        f"{resource['name']}.bma": resource
        for resource in manifest["ground_archive"]["resources"]
        if resource["type"] == "bma"
    }
    actual = {path.name: path for path in source_dir.glob("*.bma")}
    if set(actual) != set(expected):
        missing = sorted(set(expected) - set(actual))
        extra = sorted(set(actual) - set(expected))
        raise ReconstructionError(
            f"BMA extraction inventory mismatch; missing={missing}, extra={extra}"
        )

    resources: list[tuple[str, bytes]] = []
    for filename in sorted(actual):
        data = actual[filename].read_bytes()
        expected_hash = expected[filename]["normalized_sha256"]
        if sha256(data) != expected_hash:
            raise ReconstructionError(
                f"{filename}: normalized extraction hash mismatch"
            )
        resources.append((filename.removesuffix(".bma"), data))

    differential = differential_validate_bma_auxiliary(resources)
    if differential["resource_count"] != 201:
        raise ReconstructionError(
            f"expected 201 normalized BMAs, got {differential['resource_count']}"
        )
    return {
        "schema": "pmdred-eu-bma-auxiliary-differential-v1",
        "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
        "authority": {
            "rom_filename": manifest["authority"].get("source_filename"),
            "rom_sha256": authority["sha256"],
            "manifest": authority_manifest.as_posix(),
            "manifest_sha256": sha256(authority_manifest.read_bytes()),
            "source_directory": "external normalized EU Ground extraction (not committed)",
        },
        "scope": {
            "camera_dimensions": True,
            "unknown_data_block": True,
            "collision": True,
            "collision2": True,
            "note": (
                "The decoder supports collision2. The authoritative 201-file EU Ground "
                "corpus contains no BMA declaring two collision layers."
            ),
        },
        "differential": differential,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_dir", type=Path, help="normalized EU Ground extraction")
    parser.add_argument("output", type=Path, help="JSON report path")
    parser.add_argument(
        "--authority-manifest",
        type=Path,
        default=Path("docs/pmdred_eu/ground_manifest.json"),
        help="passing authoritative extraction manifest",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        report = audit(args.source_dir, args.authority_manifest)
    except (OSError, KeyError, json.JSONDecodeError, ReconstructionError) as exc:
        raise SystemExit(f"BMA auxiliary audit failed: {exc}") from exc
    write_json(args.output, report)
    diff = report["differential"]
    print(
        f"BMA auxiliary differential: {diff['resource_count']} resources, "
        f"{diff['unknown_data_resource_count']} data blocks, all matched"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
