#!/usr/bin/env python3
"""Stage a Ground-only, provenance-preserving 246-occurrence PMDO probe input.

This is NOT an overlay or installable Quest. It assembles disposable copies of
all 246 currently loadable Ground occurrences from the 262-source inventory so
the generic native-runtime verifier can exercise them in 13 batches. The 13
source entries blocked by unresolved assets and three generated entries with no
Ground output remain in the occurrence manifest without placeholders. Three
available generated outputs whose hashes differ from the inventory are included
as explicitly labelled rebuild variants; their expected and actual hashes are
both retained. No source Ground geometry, collision, marker, or tile references
are changed: only Object.AssetName is aliased in the disposable probe copy.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import zipfile
from typing import Any
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
INVENTORY = ROOT / "source/pmdo_cote/destiny_262_inventory.json"
RECOVERY = ROOT / ".cache/destiny-recovery"
WORKSPACE = RECOVERY / "workspace-f9c97"
ZIP_GROUNDS = RECOVERY / "zip-candidates/Ground"
RECONSTRUCTION = RECOVERY / "empty_ground_reconstructed_native"
PROTOTYPE = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
OUTPUT = RECOVERY / "candidate-246-ground-probe"
EXPECTED_OCCURRENCES = 262
EXPECTED_MAPS = 246
EXPECTED_BLOCKED = 13
EXPECTED_UNAVAILABLE_GENERATED = {"generated_002", "generated_007", "generated_029"}

from source.pmdo_runtime.verify_destiny_ground_archive_0812 import (  # noqa: E402
    inspect_ground,
    replace_object_asset_name,
)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def safe_slug(value: str, limit: int = 30) -> str:
    slug = re.sub(r"[^A-Za-z0-9]+", "_", value).strip("_").lower()
    return (slug or "map")[:limit].strip("_") or "map"


def make_map_id(entry: dict[str, Any]) -> str:
    return f"d262_{entry['entryId']}_{safe_slug(entry.get('assetName', 'map'))}"


def load_prototype_source_grounds(archive: zipfile.ZipFile) -> dict[str, str]:
    manifest = json.loads(archive.read("destiny/manifest.json"))
    found: dict[str, str] = {}
    for row in manifest.get("maps", []):
        source_hash = row.get("sourceGroundSha256")
        ground_file = row.get("groundFile")
        if not source_hash or not ground_file:
            continue
        member = f"destiny/{ground_file}"
        found.setdefault(source_hash, member)
    return found


def find_branch_ground_sources(entries: list[dict[str, Any]]) -> dict[str, Path]:
    wanted: dict[str, int] = {}
    for entry in entries:
        if entry.get("sourceCategory") != "arena_branch":
            continue
        if entry.get("assetStatus") in {"assets_blocked", "reconstructed_native_assets_from_source"}:
            continue
        wanted[str(entry["groundSha256"])] = int(entry["groundBytes"])
    wanted_sizes = set(wanted.values())
    roots = [
        ROOT / "source",
        ROOT / "renders",
        RECOVERY / "branch-candidates/source",
        RECOVERY / "branch-source-f9c97/source",
        WORKSPACE,
    ]
    found: dict[str, Path] = {}
    seen_paths: set[Path] = set()
    for root in roots:
        if not root.is_dir():
            continue
        for path in root.rglob("*.rsground"):
            try:
                resolved = path.resolve()
                if resolved in seen_paths or not resolved.is_file():
                    continue
                seen_paths.add(resolved)
                if resolved.stat().st_size not in wanted_sizes:
                    continue
                digest = sha256_file(resolved)
            except OSError:
                continue
            if digest in wanted:
                found.setdefault(digest, resolved)
        if len(found) == len(wanted):
            break
    missing = sorted(set(wanted) - set(found))
    if missing:
        raise ValueError(f"Grounds de branche exacts introuvables: {missing}")
    return found


def load_reconstruction_map_paths() -> tuple[dict[str, dict[str, Any]], dict[str, Path]]:
    manifest_path = RECONSTRUCTION / "Documentation/reconstruction_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    maps = {row["entryId"]: row for row in manifest.get("maps", [])}
    paths = {
        entry_id: RECONSTRUCTION / PurePosixPath(row["groundFile"])
        for entry_id, row in maps.items()
    }
    return maps, paths


def source_for_entry(
    entry: dict[str, Any],
    prototype_archive: zipfile.ZipFile,
    prototype_sources: dict[str, str],
    branch_sources: dict[str, Path],
    reconstruction_rows: dict[str, dict[str, Any]],
    reconstruction_paths: dict[str, Path],
    rebuild_results: dict[str, dict[str, Any]],
) -> tuple[bytes | None, str, str, str | None, str | None]:
    """Return source bytes/status/locator/input hash/expected hash for one row."""
    entry_id = entry["entryId"]
    category = entry["sourceCategory"]
    expected = str(entry.get("groundSha256") or "")
    locator = entry.get("sourceLocator", {})

    if category == "zip_archive":
        path = ZIP_GROUNDS / f"{entry_id}.rsground"
        if not path.is_file():
            raise FileNotFoundError(path)
        raw = path.read_bytes()
        digest = sha256_bytes(raw)
        if digest != expected:
            raise ValueError(f"ZIP Ground SHA différent pour {entry_id}: {digest} != {expected}")
        return raw, "recovered_exact_from_source_zip", str(path.relative_to(ROOT)), digest, expected

    if category == "arena_branch":
        if entry.get("assetStatus") == "assets_blocked":
            return None, "blocked_unresolved_source_assets", "", None, expected
        if entry.get("assetStatus") == "reconstructed_native_assets_from_source":
            row = reconstruction_rows.get(entry_id)
            path = reconstruction_paths.get(entry_id)
            if not row or not path or not path.is_file():
                raise FileNotFoundError(f"reconstruction absente pour {entry_id}")
            if row.get("sourceGroundSha256") != expected:
                raise ValueError(f"SHA Ground source de reconstruction différent pour {entry_id}")
            raw = path.read_bytes()
            digest = sha256_bytes(raw)
            if digest != row.get("outputGroundSha256"):
                raise ValueError(f"SHA de Ground reconstruit différent pour {entry_id}")
            return raw, "reconstructed_native_from_exact_source_grid", str(path.relative_to(ROOT)), digest, expected
        path = branch_sources.get(expected)
        if path is None:
            raise FileNotFoundError(f"Ground de branche absent pour {entry_id}: {expected}")
        raw = path.read_bytes()
        digest = sha256_bytes(raw)
        if digest != expected:
            raise ValueError(f"Ground de branche modifié pour {entry_id}")
        return raw, "recovered_exact_branch_ground", str(path.relative_to(ROOT)), digest, expected

    if category == "generated_build":
        generated_rel = locator.get("generatedOutput")
        path = WORKSPACE / generated_rel if generated_rel else None
        if path and path.is_file():
            raw = path.read_bytes()
            digest = sha256_bytes(raw)
            if digest == expected:
                status = "rebuilt_exact_from_source_script"
            else:
                result = rebuild_results.get(entry_id, {})
                if result.get("status") not in {
                    "build_failed_after_dependency_recovery",
                    "rebuilt_hash_mismatch",
                    "already_present_hash_mismatch",
                }:
                    raise ValueError(
                        f"Ground généré non exact inattendu pour {entry_id}: "
                        f"{digest} != {expected} ({result.get('status')})"
                    )
                status = "rebuilt_variant_hash_mismatch"
            return raw, status, str(path.relative_to(ROOT)), digest, expected
        if expected in prototype_sources:
            source_path = prototype_sources[expected]
            raw = prototype_archive.read(source_path)
            return raw, "catalogue_normalized_from_exact_source_ground", source_path, sha256_bytes(raw), expected
        result = rebuild_results.get(entry_id, {})
        return None, "generated_ground_output_unavailable", str(result.get("status") or ""), None, expected

    raise ValueError(f"Catégorie source inconnue: {category}")


def main() -> None:
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    entries = inventory.get("entries", [])
    if len(entries) != EXPECTED_OCCURRENCES:
        raise ValueError(f"Inventaire: {len(entries)} entrées, attendu {EXPECTED_OCCURRENCES}")
    if not PROTOTYPE.is_file():
        raise SystemExit(f"Catalogue prototype absent: {PROTOTYPE}")
    branch_sources = find_branch_ground_sources(entries)
    reconstruction_rows, reconstruction_paths = load_reconstruction_map_paths()
    recovery_path = RECOVERY / "generated-build-recovery/results.json"
    rebuild_results = {row["entryId"]: row for row in json.loads(recovery_path.read_text(encoding="utf-8"))}

    if OUTPUT.exists():
        shutil.rmtree(OUTPUT)
    ground_dir = OUTPUT / "Data/Ground"
    ground_dir.mkdir(parents=True, exist_ok=True)

    map_rows: list[dict[str, Any]] = []
    occurrence_rows: list[dict[str, Any]] = []
    files: dict[str, dict[str, Any]] = {}
    status_counts: dict[str, int] = {}

    with zipfile.ZipFile(PROTOTYPE) as prototype_archive:
        prototype_sources = load_prototype_source_grounds(prototype_archive)
        for index, entry in enumerate(entries, 1):
            source_bytes, status, source_path, input_sha, expected_sha = source_for_entry(
                entry, prototype_archive, prototype_sources, branch_sources, reconstruction_rows,
                reconstruction_paths, rebuild_results,
            )
            status_counts[status] = status_counts.get(status, 0) + 1
            occurrence = {
                "sourceRow": index,
                "entryId": entry["entryId"],
                "sourceCategory": entry["sourceCategory"],
                "assetName": entry.get("assetName"),
                "sourceLocator": entry.get("sourceLocator"),
                "expectedSourceGroundSha256": expected_sha,
                "inputGroundSha256": input_sha,
                "status": status,
                "probeMapId": None,
            }
            if source_bytes is None:
                occurrence_rows.append(occurrence)
                continue

            map_id = make_map_id(entry)
            inspected = inspect_ground(source_bytes)
            patched = replace_object_asset_name(source_bytes, inspected["assetName"], map_id)
            output_sha = sha256_bytes(patched)
            relative = f"Data/Ground/{map_id}.rsground"
            destination = OUTPUT / relative
            destination.write_bytes(patched)
            files[relative] = {"sha256": output_sha, "bytes": len(patched)}
            row = {
                "mapId": map_id,
                "sourceEntryId": entry["entryId"],
                "name": entry.get("displayName") or entry.get("assetName") or map_id,
                "sourceAssetName": entry.get("assetName"),
                "groundFile": relative,
                "sourceGroundSha256": expected_sha,
                "sourceGroundBytes": entry.get("groundBytes"),
                "probeInputGroundSha256": input_sha,
                "outputGroundSha256": output_sha,
                "version": inspected["version"],
                "groundVersion": inspected["version"],
                "texSize": inspected["texSize"],
                "grid": inspected["grid"],
                "layers": inspected["layers"],
                "sourceCategory": entry["sourceCategory"],
                "sourceLocator": entry.get("sourceLocator"),
                "probeInputStatus": status,
                "probeAssetNameAliased": True,
            }
            map_rows.append(row)
            occurrence["probeMapId"] = map_id
            occurrence_rows.append(occurrence)

    unavailable_generated = {
        row["entryId"] for row in occurrence_rows
        if row["sourceCategory"] == "generated_build" and row["probeMapId"] is None
    }
    blocked_count = sum(row["status"] == "blocked_unresolved_source_assets" for row in occurrence_rows)
    if len(map_rows) != EXPECTED_MAPS:
        raise ValueError(f"Ground staged: {len(map_rows)}, attendu {EXPECTED_MAPS}")
    if blocked_count != EXPECTED_BLOCKED:
        raise ValueError(f"Entrées bloquées: {blocked_count}, attendu {EXPECTED_BLOCKED}")
    if unavailable_generated != EXPECTED_UNAVAILABLE_GENERATED:
        raise ValueError(
            f"Sorties générées indisponibles inattendues: {sorted(unavailable_generated)} "
            f"(attendu {sorted(EXPECTED_UNAVAILABLE_GENERATED)})"
        )
    if len({row["mapId"] for row in map_rows}) != len(map_rows):
        raise ValueError("MapId non unique dans le probe Ground")

    manifest = {
        "schemaVersion": 1,
        "name": "PMD Destiny — Ground-only candidate runtime probe input",
        "gameVersion": "0.8.12.0",
        "mapCount": len(map_rows),
        "sourceOccurrenceCount": len(entries),
        "includedGroundOccurrences": len(map_rows),
        "blockedSourceAssetOccurrences": blocked_count,
        "generatedGroundOutputUnavailableOccurrences": len(unavailable_generated),
        "duplicateOccurrencesPreserved": inventory.get("summary", {}).get("duplicateSourceOccurrencesBeyondFirst"),
        "notAnInstallableOverlay": True,
        "mapRowsIncludeDuplicateOccurrencesAsUniqueProbeIds": True,
        "statusCounts": status_counts,
        "unavailableGeneratedEntryIds": sorted(unavailable_generated),
        "maps": map_rows,
        "sourceOccurrences": occurrence_rows,
        "files": files,
        "scope": "Ground-only native deserialization probe; no tile/background/script packaging or graphics test.",
    }
    (OUTPUT / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    summary = {
        "output": str(OUTPUT),
        "sourceOccurrences": len(occurrence_rows),
        "groundMaps": len(map_rows),
        "uniqueMapIds": len({row["mapId"] for row in map_rows}),
        "blockedSourceOccurrences": blocked_count,
        "generatedGroundUnavailable": len(unavailable_generated),
        "statusCounts": status_counts,
        "notAnInstallableOverlay": True,
    }
    (OUTPUT / "build_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
