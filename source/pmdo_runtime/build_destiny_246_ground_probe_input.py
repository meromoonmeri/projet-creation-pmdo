#!/usr/bin/env python3
"""Stage a Ground-only, provenance-preserving 246-occurrence PMDO probe input.

This is NOT an overlay or installable Quest. It assembles disposable copies of
all 246 currently loadable Ground occurrences from the 262-source inventory so
the generic native-runtime verifier can exercise them in 13 batches. The 13
source entries blocked by unresolved assets and three generated entries with no
Ground output remain in the occurrence manifest without placeholders. Three
available generated outputs whose hashes differ from the inventory are included
as explicitly labelled rebuild variants; their expected and actual hashes are
both retained. Treasure archive Grounds use the approved label-only mapping;
workspace branch Grounds use exact source/current paths from the migration
report. Two pinned branch variants and sixteen exact generated outputs are
transformed in memory only after their source hashes and provenance are verified.
Every Metano→Treasure change is checked against the full parsed Ground; all
non-string map data is preserved. Existing TileSheet identifiers are only
renamed by that approved brand substitution and must match the inventory exactly;
no sheet payload is guessed or substituted.
Object.AssetName is then aliased only in the disposable probe copy.
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
TREASURE_MIGRATION_REPORT = ROOT / "exports/treasure_rename/migration_report.json"
TREASURE_REBRANDED_ARCHIVE = ROOT / "mod_treasure_expeditions_pmdo_0812.zip"
TREASURE_REBRAND_SOURCE_ARCHIVES = {
    "mod_treasure_expeditions_pmdo_0812.zip",
    "cotes_treasure_abyss_0812_pmdo.zip",
}
TREASURE_REBRAND_STATUS = "rebranded_treasure_source_from_verified_migration"
EXACT_BRANCH_STRING_REBRAND_RULES = {
    "9ff18bd9fa70c8eac2cf8011098ee849941977d9a258211b1bce61921b6d26dd": {
        "sourceGroundSha256": "9ff18bd9fa70c8eac2cf8011098ee849941977d9a258211b1bce61921b6d26dd",
        "rebrandedGroundSha256": "130c51c86d71ae4602a078384937d035936cbc1693c6e1ad80874024e6dcfd87",
        "sourceTextOccurrences": 3205,
        "sourceBytes": 1380320,
        "rebrandedBytes": 1386730,
        "sourceCommit": "ac58cc9a37ca8a5b5305419e82f44cf6ba646a5d",
        "sourceBlobOid": "3df480b75b5ba013b239f458033e0cd9fdf61180",
        "sourcePaths": [
            "BIBLIOTHEQUE_MAPS/grounds/treasure_cafe.rsground",
            "quest_pmdo_0812/Data/Ground/treasure_cafe.rsground",
        ],
        "sourceEntryIds": ["branch_008", "branch_024"],
        "preservedSourceField": {"path": "Object.EdgeView", "value": 1},
        "relatedMappedVariantNotUsed": {
            "sourceGroundSha256": "495fac3e8b198620295654b399731954e93568410a4a74b5bed4c4131c0f5cdb",
            "rebrandedGroundSha256": "31e4541c06ee59601ce42fc758f7bd4fa9dda16e73862cf2233c8d5bbabc3d08",
            "currentPath": "source/cafe_multietage_v1/references/treasure_cafe.rsground",
            "difference": "/Object/EdgeView is 1 in this exact branch source and 0 in the mapped variant; that mapped variant is not substituted.",
        },
        "rebrandingSource": "verified_exact_branch_string_transform",
    },
    "2b33ddaf10a5f486d612c88812b3721131f7b3e8e9906bab5476f76db4faeef8": {
        "sourceGroundSha256": "2b33ddaf10a5f486d612c88812b3721131f7b3e8e9906bab5476f76db4faeef8",
        "rebrandedGroundSha256": "80ddbe3e2b5ee56a550ed9c5a771ee97baaa801dcbf5b32ccf987b37d064f0ea",
        "sourceTextOccurrences": 2289,
        "sourceBytes": 615483,
        "rebrandedBytes": 620061,
        "sourceCommit": "f9c97fc0c0c359aa063b45aead947fb080962a9d",
        "sourceBlobOid": "06882c3cc955fb64e558ab74ee934c410cc379cf",
        "sourcePaths": ["source/reseau_treasure_normal_v1/references/treasure_normal_home.rsground"],
        "sourceEntryIds": ["branch_037"],
        "preservedSourceField": {"path": "Object.EdgeView", "value": 0},
        "rebrandingSource": "verified_exact_branch_string_transform",
    },
}
PINNED_GENERATED_BUILD_COMMIT = "f9c97fc0c0c359aa063b45aead947fb080962a9d"
EXPECTED_EXACT_GENERATED_STRING_TRANSFORM_ENTRY_IDS = {
    "generated_048", "generated_049", "generated_052", "generated_053",
    "generated_054", "generated_060", "generated_061", "generated_064",
    "generated_066", "generated_067", "generated_077", "generated_079",
    "generated_080", "generated_087", "generated_088", "generated_091",
}

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


def load_treasure_rebranding(
    entries: list[dict[str, Any]], rebuild_results: dict[str, dict[str, Any]],
) -> tuple[dict[str, dict[str, Any]], dict[str, Any]]:
    """Load exact migration mappings plus pinned branch/generated string transforms."""
    if not TREASURE_MIGRATION_REPORT.is_file():
        raise FileNotFoundError(f"Rapport de migration Treasure absent: {TREASURE_MIGRATION_REPORT}")
    if not TREASURE_REBRANDED_ARCHIVE.is_file():
        raise FileNotFoundError(f"Archive rebrandée Treasure absente: {TREASURE_REBRANDED_ARCHIVE}")
    report_bytes = TREASURE_MIGRATION_REPORT.read_bytes()
    report = json.loads(report_bytes)
    package = report.get("packageArchive", {})
    expected_archive_sha = str(package.get("rebrandedArchiveSha256") or "")
    actual_archive_sha = sha256_file(TREASURE_REBRANDED_ARCHIVE)
    if report.get("targetBrand") != "Treasure":
        raise ValueError("Le manifeste source de rebranding ne cible pas Treasure.")
    if (not expected_archive_sha or actual_archive_sha != expected_archive_sha
            or TREASURE_REBRANDED_ARCHIVE.stat().st_size != package.get("rebrandedArchiveBytes")):
        raise ValueError("L’archive Treasure locale diffère du manifeste de migration vérifié.")
    if package.get("archiveCrc") != "PASS" or not str(
        package.get("previousGroundsStructuralComparison", "")
    ).startswith("PASS"):
        raise ValueError("La migration Treasure n’a pas de preuve CRC/structure PASS.")

    rows = package.get("groundFiles", [])
    if len(rows) != 40:
        raise ValueError(f"Nombre de Grounds dans le manifeste Treasure inattendu: {len(rows)}")
    mapping: dict[str, dict[str, Any]] = {}
    with zipfile.ZipFile(TREASURE_REBRANDED_ARCHIVE) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"CRC invalide dans l’archive Treasure: {bad}")
        members = archive.namelist()
        for row in rows:
            source_sha = str(row.get("sourceSha256") or "").lower()
            target_sha = str(row.get("rebrandedSha256") or "").lower()
            relative = PurePosixPath(str(row.get("memberRelativePath") or ""))
            if (len(source_sha) != 64 or len(target_sha) != 64
                    or relative.is_absolute() or ".." in relative.parts):
                raise ValueError(f"Entrée Ground invalide dans le manifeste Treasure: {row}")
            candidates = [
                name for name in members
                if name == relative.as_posix() or name.endswith("/" + relative.as_posix())
            ]
            if len(candidates) != 1:
                raise ValueError(
                    f"Membre Ground Treasure absent/ambigu pour {relative}: {candidates}"
                )
            if source_sha in mapping:
                raise ValueError(f"Hash source Ground Treasure répété dans le manifeste: {source_sha}")
            mapping[source_sha] = {
                "sourceGroundSha256": source_sha,
                "rebrandedGroundSha256": target_sha,
                "rebrandedMember": candidates[0],
                "memberRelativePath": relative.as_posix(),
                "rebrandingSource": "approved_package_archive_mapping",
            }
    if len(mapping) != 40:
        raise ValueError(f"Mapping Treasure non unique: {len(mapping)} hashes source, attendu 40")

    # The same approved migration also records exact source/current hashes for
    # standalone Ground files in the workspace. Preserve those mappings instead
    # of reviving the old Metano tile-sheet names from pinned branch blobs.
    source_file_mappings: dict[str, dict[str, Any]] = {}
    for row in report.get("sourceFileMappings", []):
        current_path = str(row.get("currentPath") or "")
        if not current_path.casefold().endswith(".rsground"):
            continue
        source_sha = str(row.get("sourceSha256") or "").lower()
        target_sha = str(row.get("currentSha256") or "").lower()
        if (len(source_sha) != 64 or len(target_sha) != 64 or source_sha == target_sha
                or int(row.get("sourceTextOccurrences") or 0) <= 0
                or row.get("currentTextOccurrences") != 0):
            continue
        relative = PurePosixPath(current_path)
        if relative.is_absolute() or ".." in relative.parts:
            raise ValueError(f"Chemin Ground rebrandé invalide dans le rapport : {current_path}")
        target_path = ROOT.joinpath(*relative.parts)
        if (not target_path.is_file() or sha256_file(target_path) != target_sha
                or target_path.stat().st_size != row.get("currentBytes")):
            raise ValueError(f"Ground source actuel différent du rapport de migration : {current_path}")
        prior = source_file_mappings.get(source_sha)
        record = {
            "sourceGroundSha256": source_sha,
            "rebrandedGroundSha256": target_sha,
            "rebrandedSourcePath": relative.as_posix(),
            "sourceTextOccurrences": int(row["sourceTextOccurrences"]),
            "sourceBytes": row.get("sourceBytes"),
            "rebrandedBytes": row.get("currentBytes"),
            "rebrandingSource": "verified_workspace_sourceFileMapping",
        }
        if prior and (prior["rebrandedGroundSha256"] != target_sha
                      or prior["rebrandedSourcePath"] != relative.as_posix()):
            raise ValueError(f"Mapping Ground source ambigu pour {source_sha}")
        source_file_mappings[source_sha] = record

    for source_sha, row in source_file_mappings.items():
        prior = mapping.get(source_sha)
        if prior and prior["rebrandedGroundSha256"] != row["rebrandedGroundSha256"]:
            raise ValueError(f"Mapping Treasure source/Workspace divergent pour {source_sha}")
        if prior is None:
            mapping[source_sha] = row

    exact_branch_records: dict[str, dict[str, Any]] = {}
    for source_sha, rule in EXACT_BRANCH_STRING_REBRAND_RULES.items():
        if source_sha in mapping:
            raise ValueError(f"Mapping exact Ground de branche déjà défini : {source_sha}")
        record = dict(rule)
        record["rebrandingRule"] = (
            "Literal Metano→Treasure substitutions on the exact pinned branch payload; "
            "full JSON comparison requires every non-string value and map field to remain identical."
        )
        exact_branch_records[source_sha] = record
        mapping[source_sha] = record

    exact_generated_records = load_exact_generated_string_transforms(entries, rebuild_results)
    for source_sha, record in exact_generated_records.items():
        if source_sha in mapping:
            raise ValueError(f"Mapping exact Ground généré déjà défini : {source_sha}")
        mapping[source_sha] = record
    metadata = {
        "activeBrand": "Treasure",
        "migrationReport": TREASURE_MIGRATION_REPORT.relative_to(ROOT).as_posix(),
        "migrationReportSha256": sha256_bytes(report_bytes),
        "sourceArchiveSha256": package.get("sourceArchiveSha256"),
        "rebrandedArchive": TREASURE_REBRANDED_ARCHIVE.name,
        "rebrandedArchiveSha256": actual_archive_sha,
        "rebrandedArchiveBytes": TREASURE_REBRANDED_ARCHIVE.stat().st_size,
        "registeredGroundPayloads": 40,
        "workspaceSourceGroundMappings": len(source_file_mappings),
        "workspaceSourceGroundMappingsByHash": sorted(source_file_mappings),
        "workspaceSourceGroundMappingRecords": [
            source_file_mappings[source_sha] for source_sha in sorted(source_file_mappings)
        ],
        "exactBranchStringTransformPayloads": len(exact_branch_records),
        "exactBranchStringTransformRecords": [
            exact_branch_records[source_sha] for source_sha in sorted(exact_branch_records)
        ],
        "exactGeneratedStringTransformPayloads": len(exact_generated_records),
        "exactGeneratedStringTransformRecords": [
            exact_generated_records[source_sha] for source_sha in sorted(exact_generated_records)
        ],
        "scope": (
            "Exact source-hash mappings from the approved migration report. Archive Grounds use the verified label-only package map; "
            "workspace Grounds use exact reported paths/hashes; two pinned branch payloads use literal Metano-to-Treasure transforms; "
            "sixteen exact generated outputs from pinned build commit f9c97fc are transformed only when their renamed TileRefs exactly "
            "match the inventory. Every literal transform is checked against the full parsed Ground."
        ),
    }
    return mapping, metadata


def rebranding_for_entry(
    entry: dict[str, Any], mapping: dict[str, dict[str, Any]],
) -> dict[str, Any] | None:
    locator = entry.get("sourceLocator", {})
    category = entry.get("sourceCategory")
    source_sha = str(entry.get("groundSha256") or "").lower()
    if category == "zip_archive" and locator.get("archive") in TREASURE_REBRAND_SOURCE_ARCHIVES:
        return mapping.get(source_sha)
    if (category == "arena_branch" and entry.get("assetStatus") not in {
            "assets_blocked", "reconstructed_native_assets_from_source"}):
        result = mapping.get(source_sha)
        if result and result.get("rebrandingSource") == "verified_workspace_sourceFileMapping":
            return result
        if result and result.get("rebrandingSource") == "verified_exact_branch_string_transform":
            source_paths = set(result.get("sourcePaths", []))
            if (entry.get("entryId") in result.get("sourceEntryIds", [])
                    and locator.get("commit") == result.get("sourceCommit")
                    and locator.get("blobOid") == result.get("sourceBlobOid")
                    and locator.get("path") in source_paths):
                return result
            raise ValueError(f"Le Ground source ne correspond pas au mapping exact de {entry.get('entryId')}")
    if category == "generated_build":
        result = mapping.get(source_sha)
        if result and result.get("rebrandingSource") == "verified_exact_generated_string_transform":
            if (entry.get("entryId") in result.get("sourceEntryIds", [])
                    and locator.get("generatedOutput") == result.get("generatedOutput")
                    and locator.get("sourceBuildScript") == result.get("sourceBuildScript")
                    and locator.get("sourceLot") == result.get("sourceLot")):
                return result
            raise ValueError(f"Le Ground généré ne correspond pas à la règle exacte de {entry.get('entryId')}")
    return None


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


def replace_metano_strings_with_treasure(value: Any) -> Any:
    """Apply only literal, case-preserving Metano→Treasure string substitutions."""
    def rename(text: str) -> str:
        return text.replace("METANO", "TREASURE").replace("Metano", "Treasure").replace("metano", "treasure")

    if isinstance(value, dict):
        return {rename(key): replace_metano_strings_with_treasure(item) for key, item in value.items()}
    if isinstance(value, list):
        return [replace_metano_strings_with_treasure(item) for item in value]
    if isinstance(value, str):
        return rename(value)
    return value


def validate_exact_metano_to_treasure_rebrand(
    entry_id: str,
    source_raw: bytes,
    target_raw: bytes,
    mapping: dict[str, Any],
) -> None:
    """Prove a Ground differs only by the exact recorded Metano→Treasure string substitutions."""
    source_sha = sha256_bytes(source_raw)
    target_sha = sha256_bytes(target_raw)
    if source_sha != mapping.get("sourceGroundSha256"):
        raise ValueError(f"Ground source rebrandé inattendu pour {entry_id}: {source_sha}")
    if target_sha != mapping.get("rebrandedGroundSha256"):
        raise ValueError(f"Ground cible rebrandé inattendu pour {entry_id}: {target_sha}")
    if (len(source_raw) != mapping.get("sourceBytes")
            or len(target_raw) != mapping.get("rebrandedBytes")):
        raise ValueError(f"Taille source/cible du Ground rebrandé inattendue pour {entry_id}")
    source_text = source_raw.decode("utf-8-sig")
    target_text = target_raw.decode("utf-8-sig")
    source_occurrences = (
        source_text.count("METANO") + source_text.count("Metano") + source_text.count("metano")
    )
    target_occurrences = (
        target_text.count("METANO") + target_text.count("Metano") + target_text.count("metano")
    )
    if source_occurrences != mapping.get("sourceTextOccurrences") or target_occurrences != 0:
        raise ValueError(
            f"Comptage de chaînes Metano différent du rapport pour {entry_id}: "
            f"source {source_occurrences}, cible {target_occurrences}"
        )
    source_doc = json.loads(source_text)
    target_doc = json.loads(target_text)
    if replace_metano_strings_with_treasure(source_doc) != target_doc:
        raise ValueError(
            f"Le Ground rebrandé de {entry_id} contient une différence autre que la substitution "
            "Metano→Treasure attestée par la provenance exacte."
        )


def apply_metano_to_treasure_bytes(source_raw: bytes) -> bytes:
    bom = b"\xef\xbb\xbf" if source_raw.startswith(b"\xef\xbb\xbf") else b""
    source_text = source_raw.decode("utf-8-sig")
    target_text = (
        source_text.replace("METANO", "TREASURE")
        .replace("Metano", "Treasure")
        .replace("metano", "treasure")
    )
    return bom + target_text.encode("utf-8")


def ground_tile_refs(raw: bytes) -> set[str]:
    document = json.loads(raw.decode("utf-8-sig"))
    refs: set[str] = set()
    for layer in (document.get("Object") or {}).get("Layers", []) or []:
        for column in layer.get("Tiles", []) or []:
            for cell in column or []:
                for animation in cell.get("Layers", []) or []:
                    for frame in animation.get("Frames", []) or []:
                        if frame.get("Sheet"):
                            refs.add(str(frame["Sheet"]))
    return refs


def load_exact_generated_string_transforms(
    entries: list[dict[str, Any]], rebuild_results: dict[str, dict[str, Any]],
) -> dict[str, dict[str, Any]]:
    """Authorize only the listed exact outputs whose literal rename fixes TileRefs exactly."""
    records: dict[str, dict[str, Any]] = {}
    found_entry_ids: set[str] = set()
    for entry in entries:
        entry_id = str(entry.get("entryId") or "")
        if entry_id not in EXPECTED_EXACT_GENERATED_STRING_TRANSFORM_ENTRY_IDS:
            continue
        if entry.get("sourceCategory") != "generated_build":
            raise ValueError(f"Source générée attendue absente pour {entry_id}")
        locator = entry.get("sourceLocator", {})
        generated_rel_text = str(locator.get("generatedOutput") or "")
        generated_rel = PurePosixPath(generated_rel_text)
        script = str(locator.get("sourceBuildScript") or "")
        source_lot = str(locator.get("sourceLot") or "")
        expected_sha = str(entry.get("groundSha256") or "").lower()
        expected_bytes = entry.get("groundBytes")
        result = rebuild_results.get(entry_id, {})
        if (not generated_rel_text or generated_rel.is_absolute() or ".." in generated_rel.parts
                or not script or not source_lot or len(expected_sha) != 64):
            raise ValueError(f"Provenance de génération incomplète pour {entry_id}")
        path = WORKSPACE.joinpath(*generated_rel.parts)
        expected_actual_path = path.relative_to(ROOT).as_posix()
        if (not path.is_file() or result.get("sourceBuildCommit") != PINNED_GENERATED_BUILD_COMMIT
                or result.get("sourceBuildScript") != script
                or result.get("expectedOutputPath") != generated_rel.as_posix()
                or result.get("actualOutputPath") != expected_actual_path
                or result.get("expectedGroundSha256") != expected_sha
                or result.get("actualGroundSha256") != expected_sha
                or result.get("status") not in {"already_present_hash_match", "built_hash_match"}):
            raise ValueError(f"Build Ground exact non vérifié pour {entry_id}")
        source_raw = path.read_bytes()
        source_sha = sha256_bytes(source_raw)
        if (source_sha != expected_sha or len(source_raw) != expected_bytes
                or result.get("expectedGroundBytes") != len(source_raw)
                or result.get("actualGroundBytes") != len(source_raw)):
            raise ValueError(f"Payload généré source non exact pour {entry_id}")
        source_text = source_raw.decode("utf-8-sig")
        source_text_occurrences = (
            source_text.count("METANO") + source_text.count("Metano") + source_text.count("metano")
        )
        if source_text_occurrences <= 0:
            raise ValueError(f"Aucune chaîne Metano à rebrander dans {entry_id}")
        target_raw = apply_metano_to_treasure_bytes(source_raw)
        target_sha = sha256_bytes(target_raw)
        expected_tile_refs = set(map(str, entry.get("tileRefs", [])))
        source_tile_refs = ground_tile_refs(source_raw)
        target_tile_refs = ground_tile_refs(target_raw)
        if source_tile_refs == expected_tile_refs or target_tile_refs != expected_tile_refs:
            raise ValueError(
                f"Transformation générée non nécessaire ou TileRefs non exactes pour {entry_id}: "
                f"source={sorted(source_tile_refs)}, transformé={sorted(target_tile_refs)}, "
                f"inventaire={sorted(expected_tile_refs)}"
            )
        record = {
            "sourceGroundSha256": source_sha,
            "rebrandedGroundSha256": target_sha,
            "sourceTextOccurrences": source_text_occurrences,
            "sourceBytes": len(source_raw),
            "rebrandedBytes": len(target_raw),
            "sourceEntryIds": [entry_id],
            "sourceBuildCommit": PINNED_GENERATED_BUILD_COMMIT,
            "sourceBuildScript": script,
            "sourceLot": source_lot,
            "generatedOutput": generated_rel.as_posix(),
            "generatedBuildStatus": result.get("status"),
            "generatedOutputPath": expected_actual_path,
            "sourceTileRefs": sorted(source_tile_refs),
            "expectedTreasureTileRefs": sorted(expected_tile_refs),
            "rebrandingRule": (
                f"Literal case-preserving METANO/Metano/metano→TREASURE/Treasure/treasure substitutions "
                f"on the exact generated Ground output from commit {PINNED_GENERATED_BUILD_COMMIT}; "
                "full parsed-Ground comparison preserves all non-string content and renamed TileRefs "
                "must equal the inventory."
            ),
            "rebrandingSource": "verified_exact_generated_string_transform",
        }
        validate_exact_metano_to_treasure_rebrand(entry_id, source_raw, target_raw, record)
        prior = records.get(source_sha)
        if prior and prior["rebrandedGroundSha256"] != target_sha:
            raise ValueError(f"Transformations générées ambiguës pour {source_sha}")
        records[source_sha] = record
        found_entry_ids.add(entry_id)

    if found_entry_ids != EXPECTED_EXACT_GENERATED_STRING_TRANSFORM_ENTRY_IDS:
        raise ValueError(
            "Périmètre des transformations générées exactes inattendu: "
            f"{sorted(found_entry_ids)} != {sorted(EXPECTED_EXACT_GENERATED_STRING_TRANSFORM_ENTRY_IDS)}"
        )
    if len(records) != 16:
        raise ValueError(f"Payloads générés rebrandés uniques: {len(records)}, attendu 16")
    return records


def source_for_entry(
    entry: dict[str, Any],
    prototype_archive: zipfile.ZipFile,
    prototype_sources: dict[str, str],
    branch_sources: dict[str, Path],
    reconstruction_rows: dict[str, dict[str, Any]],
    reconstruction_paths: dict[str, Path],
    rebuild_results: dict[str, dict[str, Any]],
    treasure_rebrand_map: dict[str, dict[str, Any]],
    treasure_archive: zipfile.ZipFile,
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
        source_raw = path.read_bytes()
        source_digest = sha256_bytes(source_raw)
        if source_digest != expected:
            raise ValueError(f"ZIP Ground SHA différent pour {entry_id}: {source_digest} != {expected}")
        rebrand = rebranding_for_entry(entry, treasure_rebrand_map)
        if rebrand is not None:
            raw = treasure_archive.read(rebrand["rebrandedMember"])
            digest = sha256_bytes(raw)
            if digest != rebrand["rebrandedGroundSha256"]:
                raise ValueError(
                    f"Ground Treasure rebrandé différent pour {entry_id}: "
                    f"{digest} != {rebrand['rebrandedGroundSha256']}"
                )
            return (
                raw,
                TREASURE_REBRAND_STATUS,
                f"{path.relative_to(ROOT)} -> {TREASURE_REBRANDED_ARCHIVE.name}:{rebrand['rebrandedMember']}",
                digest,
                expected,
            )
        return source_raw, "recovered_exact_from_source_zip", str(path.relative_to(ROOT)), source_digest, expected

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
        rebrand = rebranding_for_entry(entry, treasure_rebrand_map)
        if rebrand is not None:
            rebrand_source = rebrand.get("rebrandingSource")
            if rebrand_source == "verified_workspace_sourceFileMapping":
                target_path = ROOT / PurePosixPath(rebrand["rebrandedSourcePath"])
                if not target_path.is_file():
                    raise FileNotFoundError(f"Ground Treasure actuel absent pour {entry_id}: {target_path}")
                rebranded_raw = target_path.read_bytes()
                source_locator = (
                    f"{path.relative_to(ROOT)} -> {rebrand['rebrandedSourcePath']}"
                )
            elif rebrand_source == "verified_exact_branch_string_transform":
                rebranded_raw = apply_metano_to_treasure_bytes(raw)
                source_locator = (
                    f"{path.relative_to(ROOT)} -> exact Metano→Treasure transform "
                    f"(not written to source tree; expected SHA-256 {rebrand['rebrandedGroundSha256']})"
                )
            else:
                raise ValueError(f"Source de rebranding Ground branche inattendue pour {entry_id}")
            validate_exact_metano_to_treasure_rebrand(entry_id, raw, rebranded_raw, rebrand)
            actual_tile_refs = ground_tile_refs(rebranded_raw)
            expected_tile_refs = set(map(str, entry.get("tileRefs", [])))
            if actual_tile_refs != expected_tile_refs:
                raise ValueError(
                    f"TileRefs du Ground rebrandé différents de l’inventaire pour {entry_id}: "
                    f"Ground={sorted(actual_tile_refs)}, inventaire={sorted(expected_tile_refs)}"
                )
            rebranded_sha = sha256_bytes(rebranded_raw)
            return (
                rebranded_raw,
                TREASURE_REBRAND_STATUS,
                source_locator,
                rebranded_sha,
                expected,
            )
        return raw, "recovered_exact_branch_ground", str(path.relative_to(ROOT)), digest, expected

    if category == "generated_build":
        generated_rel = locator.get("generatedOutput")
        path = WORKSPACE / generated_rel if generated_rel else None
        if path and path.is_file():
            raw = path.read_bytes()
            digest = sha256_bytes(raw)
            if digest == expected:
                rebrand = rebranding_for_entry(entry, treasure_rebrand_map)
                if rebrand is None:
                    return raw, "rebuilt_exact_from_source_script", str(path.relative_to(ROOT)), digest, expected
                if rebrand.get("rebrandingSource") != "verified_exact_generated_string_transform":
                    raise ValueError(f"Source de rebranding généré inattendue pour {entry_id}")
                rebranded_raw = apply_metano_to_treasure_bytes(raw)
                validate_exact_metano_to_treasure_rebrand(entry_id, raw, rebranded_raw, rebrand)
                actual_tile_refs = ground_tile_refs(rebranded_raw)
                expected_tile_refs = set(map(str, entry.get("tileRefs", [])))
                if actual_tile_refs != expected_tile_refs:
                    raise ValueError(
                        f"TileRefs du Ground généré rebrandé différentes de l’inventaire pour {entry_id}: "
                        f"Ground={sorted(actual_tile_refs)}, inventaire={sorted(expected_tile_refs)}"
                    )
                rebranded_sha = sha256_bytes(rebranded_raw)
                source_locator = (
                    f"{path.relative_to(ROOT)} -> exact generated Ground from {rebrand['sourceBuildCommit']} "
                    f"({rebrand['sourceBuildScript']}); literal Metano→Treasure transform "
                    f"(not written to source tree; expected SHA-256 {rebrand['rebrandedGroundSha256']})"
                )
                return (
                    rebranded_raw,
                    TREASURE_REBRAND_STATUS,
                    source_locator,
                    rebranded_sha,
                    expected,
                )
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
            return raw, "rebuilt_variant_hash_mismatch", str(path.relative_to(ROOT)), digest, expected
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
    treasure_rebrand_map, treasure_rebrand_metadata = load_treasure_rebranding(entries, rebuild_results)

    if OUTPUT.exists():
        shutil.rmtree(OUTPUT)
    ground_dir = OUTPUT / "Data/Ground"
    ground_dir.mkdir(parents=True, exist_ok=True)

    map_rows: list[dict[str, Any]] = []
    occurrence_rows: list[dict[str, Any]] = []
    files: dict[str, dict[str, Any]] = {}
    status_counts: dict[str, int] = {}
    treasure_rebrand_occurrences: list[dict[str, Any]] = []

    with zipfile.ZipFile(TREASURE_REBRANDED_ARCHIVE) as treasure_archive, zipfile.ZipFile(PROTOTYPE) as prototype_archive:
        prototype_sources = load_prototype_source_grounds(prototype_archive)
        for index, entry in enumerate(entries, 1):
            source_bytes, status, source_path, input_sha, expected_sha = source_for_entry(
                entry, prototype_archive, prototype_sources, branch_sources, reconstruction_rows,
                reconstruction_paths, rebuild_results, treasure_rebrand_map, treasure_archive,
            )
            status_counts[status] = status_counts.get(status, 0) + 1
            rebrand = rebranding_for_entry(entry, treasure_rebrand_map)
            if rebrand is not None and (source_bytes is None or status != TREASURE_REBRAND_STATUS):
                raise ValueError(f"Rebranding Treasure attendu mais non appliqué à {entry['entryId']}")
            if status == TREASURE_REBRAND_STATUS and rebrand is None:
                raise ValueError(f"Statut de rebranding Treasure sans mapping exact pour {entry['entryId']}")
            rebrand_record = None
            if rebrand is not None:
                rebranding_source = rebrand.get("rebrandingSource")
                if rebranding_source == "verified_workspace_sourceFileMapping":
                    transformation = "verified_Metano_to_Treasure_string_substitution"
                elif rebranding_source == "verified_exact_branch_string_transform":
                    transformation = "exact_branch_Metano_to_Treasure_string_transform"
                elif rebranding_source == "verified_exact_generated_string_transform":
                    transformation = "exact_generated_Metano_to_Treasure_string_transform"
                else:
                    transformation = "approved_Treasure_archive_label_only"
                rebrand_record = {
                    "status": "PASS",
                    "transformation": transformation,
                    "rebrandingSource": rebranding_source,
                    "migrationReport": treasure_rebrand_metadata["migrationReport"],
                    "migrationReportSha256": treasure_rebrand_metadata["migrationReportSha256"],
                    "sourceEntryId": entry["entryId"],
                    "sourceLocator": entry.get("sourceLocator"),
                    "sourceGroundSha256": expected_sha,
                    "rebrandedGroundSha256": rebrand["rebrandedGroundSha256"],
                    "rebrandedArchiveMember": rebrand.get("rebrandedMember"),
                    "rebrandedSourcePath": rebrand.get("rebrandedSourcePath"),
                    "sourceTextOccurrences": rebrand.get("sourceTextOccurrences"),
                    "rebrandingRule": rebrand.get("rebrandingRule"),
                    "sourceCommit": rebrand.get("sourceCommit"),
                    "sourceBlobOid": rebrand.get("sourceBlobOid"),
                    "sourcePaths": rebrand.get("sourcePaths"),
                    "sourceEntryIds": rebrand.get("sourceEntryIds"),
                    "preservedSourceField": rebrand.get("preservedSourceField"),
                    **({
                        "sourceBuildCommit": rebrand.get("sourceBuildCommit"),
                        "sourceBuildScript": rebrand.get("sourceBuildScript"),
                        "sourceLot": rebrand.get("sourceLot"),
                        "generatedOutput": rebrand.get("generatedOutput"),
                        "generatedBuildStatus": rebrand.get("generatedBuildStatus"),
                        "generatedOutputPath": rebrand.get("generatedOutputPath"),
                        "sourceTileRefs": rebrand.get("sourceTileRefs"),
                        "expectedTreasureTileRefs": rebrand.get("expectedTreasureTileRefs"),
                    } if rebranding_source == "verified_exact_generated_string_transform" else {}),
                }
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
            if rebrand_record is not None:
                occurrence["sourcePayloadRebranding"] = rebrand_record
            if source_bytes is None:
                occurrence_rows.append(occurrence)
                continue

            map_id = make_map_id(entry)
            if rebrand_record is not None:
                rebrand_record["mapId"] = map_id
                rebrand_record["probeOutputGroundSha256"] = None
            inspected = inspect_ground(source_bytes)
            patched = replace_object_asset_name(source_bytes, inspected["assetName"], map_id)
            output_sha = sha256_bytes(patched)
            if rebrand_record is not None:
                rebrand_record["probeOutputGroundSha256"] = output_sha
                treasure_rebrand_occurrences.append(dict(rebrand_record))
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
                **({"sourcePayloadRebranding": rebrand_record} if rebrand_record is not None else {}),
            }
            map_rows.append(row)
            occurrence["probeMapId"] = map_id
            occurrence_rows.append(occurrence)

    archive_rebrands = [
        row for row in treasure_rebrand_occurrences
        if row.get("rebrandingSource") == "approved_package_archive_mapping"
    ]
    workspace_rebrands = [
        row for row in treasure_rebrand_occurrences
        if row.get("rebrandingSource") == "verified_workspace_sourceFileMapping"
    ]
    exact_branch_rebrands = [
        row for row in treasure_rebrand_occurrences
        if row.get("rebrandingSource") == "verified_exact_branch_string_transform"
    ]
    exact_generated_rebrands = [
        row for row in treasure_rebrand_occurrences
        if row.get("rebrandingSource") == "verified_exact_generated_string_transform"
    ]
    archive_source_hashes = {row["sourceGroundSha256"] for row in archive_rebrands}
    workspace_source_hashes = {row["sourceGroundSha256"] for row in workspace_rebrands}
    exact_branch_source_hashes = {row["sourceGroundSha256"] for row in exact_branch_rebrands}
    exact_generated_source_hashes = {row["sourceGroundSha256"] for row in exact_generated_rebrands}
    all_source_hashes = (
        archive_source_hashes | workspace_source_hashes | exact_branch_source_hashes
        | exact_generated_source_hashes
    )
    if (len(archive_rebrands) != 60 or len(archive_source_hashes) != 40
            or len(workspace_rebrands) != 3 or len(workspace_source_hashes) != 2
            or len(exact_branch_rebrands) != 3 or len(exact_branch_source_hashes) != 2
            or {row["sourceEntryId"] for row in exact_branch_rebrands}
               != {"branch_008", "branch_024", "branch_037"}
            or len(exact_generated_rebrands) != 16 or len(exact_generated_source_hashes) != 16
            or {row["sourceEntryId"] for row in exact_generated_rebrands}
               != EXPECTED_EXACT_GENERATED_STRING_TRANSFORM_ENTRY_IDS
            or len(treasure_rebrand_occurrences) != 82 or len(all_source_hashes) != 60):
        raise ValueError(
            "Périmètre Treasure inattendu: attendu 60/40 d’archive, 3/2 de mapping source/current, "
            "3/2 de transformation de branche exacte et 16/16 de transformation générée exacte; obtenu "
            f"archive {len(archive_rebrands)}/{len(archive_source_hashes)}, "
            f"source/current {len(workspace_rebrands)}/{len(workspace_source_hashes)}, "
            f"branche exacte {len(exact_branch_rebrands)}/{len(exact_branch_source_hashes)}, "
            f"générée exacte {len(exact_generated_rebrands)}/{len(exact_generated_source_hashes)}."
        )
    treasure_rebrand_manifest = {
        **treasure_rebrand_metadata,
        "appliedOccurrenceCount": len(treasure_rebrand_occurrences),
        "uniqueSourcePayloadsApplied": len(all_source_hashes),
        "packageArchiveOccurrenceCount": len(archive_rebrands),
        "packageArchiveUniqueSourcePayloads": len(archive_source_hashes),
        "workspaceSourceOccurrenceCount": len(workspace_rebrands),
        "workspaceSourceUniqueSourcePayloads": len(workspace_source_hashes),
        "exactBranchStringTransformOccurrenceCount": len(exact_branch_rebrands),
        "exactBranchStringTransformUniqueSourcePayloads": len(exact_branch_source_hashes),
        "exactGeneratedStringTransformOccurrenceCount": len(exact_generated_rebrands),
        "exactGeneratedStringTransformUniqueSourcePayloads": len(exact_generated_source_hashes),
        "occurrences": treasure_rebrand_occurrences,
    }

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
        "sourcePayloadRebranding": treasure_rebrand_manifest,
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
        "sourcePayloadRebrandingAppliedOccurrences": len(treasure_rebrand_occurrences),
        "statusCounts": status_counts,
        "notAnInstallableOverlay": True,
    }
    (OUTPUT / "build_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
