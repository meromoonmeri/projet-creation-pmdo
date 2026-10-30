#!/usr/bin/env python3
"""Create a standalone PMDO 0.8.12 Destiny cartotheque Quest.

Unlike the overlay builder, this creates a new ``destiny`` Quest root. It reuses
its stable Mod.xml/UUID from the earlier 208-map prototype, keeps only the
246 verified Ground assets available today, makes an exploration_cartes zone,
and integrates the namespaced Destiny title-screen component. The 16 unavailable
source occurrences remain documented, never faked.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import stat
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from source.pmdo_cote.build_playable_catalogue_0812 import output_mod_xml  # noqa: E402
from source.pmdo_cote.installer_destiny_overlay import (  # noqa: E402
    EXPECTED_GAME_VERSION,
    MANIFEST_PATH,
    ZONE_COMMENT,
    ZONE_ID,
    ZONE_NAME,
    atomic_write,
    ground_ids_after_merge,
    load_json,
    merged_tile_index,
    read_index_bytes,
    safe_copy_plan,
    validate_overlay,
    zone_documents,
)
from source.pmdo_cote.integrate_destiny_title_screen import (  # noqa: E402
    QUEST_UUID as DESTINY_QUEST_UUID,
    integrate_destiny_title_screen,
    validate_installed_title_screen,
)

OVERLAY_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip"
OUTPUT_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip"
STAGING_DEFAULT = ROOT / ".cache/destiny-recovery/destiny-map-quest-246"
PMDO_ROOT_DEFAULT = ROOT / ".cache/pmdo-runtime/engine/PMDO"
OVERLAY_ROOT_NAME = "PMD_Destiny_Quest_Overlay_0812"
QUEST_NAMESPACE = "destiny"
PMDO_ZONE_TEMPLATE_SOURCE = {
    "repository": "audinowho/DumpAsset",
    "commit": "3e767571f9dd94270b848b3a73de9bec2553a2eb",
    "files": {
        "Data/Zone/debug_zone.json": {
            "gitBlobOid": "e1f42aef9074c2f87d0a115884c18197b8c1dae7",
            "sha256": "b0c4867213832c186065f4456b735aae09ecc85cc3143e4e9137fa379f493585",
            "bytes": 4501493,
        },
        "Data/Zone/index.idx": {
            "gitBlobOid": "a606489d7e11aafa52f188e3dfd6d2d7369f08be",
            "sha256": "2824c9c2fcd5f179bb41fd08eefa522ff51924979a6fb69e0cac23338cd9ea98",
            "bytes": 35586,
        },
    },
}
PMDO_ZONE_TEMPLATE_CACHE = ROOT / ".cache/destiny-recovery/pmdo-template-0.8.12"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def localized_name() -> dict:
    return {"DefaultText": ZONE_NAME, "LocalTexts": {"fr": ZONE_NAME}}


def seed_quest(target: Path, pmdo_root: Path) -> dict:
    """Make a clean Quest shell with one developer-only zone and no story data."""
    core_zone_dir = pmdo_root / "Data/Zone"
    core_index_path = core_zone_dir / "index.idx"
    debug_zone_path = core_zone_dir / "debug_zone.json"
    if not core_index_path.is_file() or not debug_zone_path.is_file():
        raise FileNotFoundError(
            f"Le template Zone PMDO 0.8.12 manque sous {core_zone_dir} "
            "(index.idx/debug_zone.json)."
        )
    actual_template_files = {}
    exact_pinned_template = True
    for relative, path in (
        ("Data/Zone/debug_zone.json", debug_zone_path),
        ("Data/Zone/index.idx", core_index_path),
    ):
        raw = path.read_bytes()
        expected = PMDO_ZONE_TEMPLATE_SOURCE["files"][relative]
        git_blob_oid = hashlib.sha1(
            b"blob " + str(len(raw)).encode("ascii") + b"\0" + raw
        ).hexdigest()
        actual = {
            "sha256": hashlib.sha256(raw).hexdigest(),
            "bytes": len(raw),
            "gitBlobOid": git_blob_oid,
        }
        actual_template_files[relative] = actual
        exact_pinned_template = exact_pinned_template and all(
            actual[key] == expected[key] for key in ("sha256", "bytes", "gitBlobOid")
        )
    zone_template_provenance = {
        "status": "PASS",
        "gameVersion": EXPECTED_GAME_VERSION,
        "source": "pinned_DumpAsset_PMDO_0.8.12_template" if exact_pinned_template else "provided_PMDO_0.8.12_template",
        "repository": PMDO_ZONE_TEMPLATE_SOURCE["repository"] if exact_pinned_template else None,
        "commit": PMDO_ZONE_TEMPLATE_SOURCE["commit"] if exact_pinned_template else None,
        "files": actual_template_files,
    }
    core_index = load_json(core_index_path)
    core_object = core_index.get("Object")
    if not isinstance(core_object, dict) or not isinstance(core_object.get("debug_zone"), dict):
        raise ValueError("L'index Zone du runtime n'a pas le modèle debug_zone attendu.")
    zone_template = load_json(debug_zone_path)
    zone_object = zone_template.get("Object")
    if not isinstance(zone_object, dict) or zone_object.get("$type") != "RogueEssence.Data.ZoneData, RogueEssence":
        raise ValueError("debug_zone.json n'est pas un ZoneData PMDO reconnu.")
    if str(zone_template.get("Version", "")) != EXPECTED_GAME_VERSION:
        raise ValueError(f"Le template Zone vise {zone_template.get('Version')!r}, pas {EXPECTED_GAME_VERSION}.")

    target.mkdir(parents=True, exist_ok=False)
    (target / "Mod.xml").write_bytes(output_mod_xml())
    zone_dir = target / "Data/Zone"
    zone_dir.mkdir(parents=True)

    # Keep only the native ZoneEntrySummary shape, not the 51 narrative/base zones.
    index_object = {
        "$type": core_object["$type"],
        ZONE_ID: copy.deepcopy(core_object["debug_zone"]),
    }
    index_entry = index_object[ZONE_ID]
    index_entry["Grounds"] = []
    index_entry["Maps"] = []
    index_entry["Name"] = localized_name()
    index_entry["Released"] = False
    index_entry["Comment"] = ZONE_COMMENT
    index_entry["SortOrder"] = 0
    index_document = {"Version": EXPECTED_GAME_VERSION, "Object": index_object}
    (zone_dir / "index.idx").write_text(
        "\ufeff" + json.dumps(index_document, ensure_ascii=False, indent=1) + "\n",
        encoding="utf-8",
    )

    zone_template["Version"] = EXPECTED_GAME_VERSION
    zone_object["Name"] = localized_name()
    zone_object["Released"] = False
    zone_object["Comment"] = ZONE_COMMENT
    zone_object["Segments"] = []
    zone_object["GroundMaps"] = []
    (zone_dir / f"{ZONE_ID}.json").write_text(
        json.dumps(zone_template, ensure_ascii=False, indent=1) + "\n",
        encoding="utf-8",
    )
    return zone_template_provenance


def extract_overlay(archive_path: Path, destination: Path) -> Path:
    prefix = OVERLAY_ROOT_NAME + "/"
    destination.mkdir(parents=True, exist_ok=False)
    with zipfile.ZipFile(archive_path) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"CRC invalide dans l'overlay source : {bad}")
        for info in archive.infolist():
            name = PurePosixPath(info.filename)
            if name.is_absolute() or ".." in name.parts or "\\" in info.filename:
                raise ValueError(f"Chemin ZIP dangereux : {info.filename}")
            if info.filename.rstrip("/") == OVERLAY_ROOT_NAME and info.is_dir():
                continue
            if not info.filename.startswith(prefix):
                raise ValueError(f"Membre hors racine attendue {OVERLAY_ROOT_NAME}: {info.filename}")
            mode = info.external_attr >> 16
            if stat.S_ISLNK(mode):
                raise ValueError(f"Lien symbolique interdit dans le ZIP : {info.filename}")
            relative = PurePosixPath(*name.parts[1:])
            target = destination.joinpath(*relative.parts)
            if not target.resolve().is_relative_to(destination.resolve()):
                raise ValueError(f"Extraction hors dossier interdite : {info.filename}")
            if info.is_dir():
                target.mkdir(parents=True, exist_ok=True)
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            with archive.open(info) as source, target.open("wb") as output:
                shutil.copyfileobj(source, output, length=1024 * 1024)
    overlay_root = destination
    if not (overlay_root / MANIFEST_PATH).is_file():
        raise ValueError("Manifeste catalogue absent de l'overlay candidat.")
    return overlay_root


def install_hardlinked(overlay: Path, quest: Path) -> dict:
    """Install a fresh Quest without doubling multi-gigabyte asset storage."""
    _, source_grounds = validate_overlay(overlay)
    plan = safe_copy_plan(overlay, quest)
    ground_ids = ground_ids_after_merge(quest, source_grounds)
    tile_index_data, tile_count = merged_tile_index(overlay, quest)
    zone_data, zone_index_data = zone_documents(quest, ground_ids)
    pending = {
        quest / "Data/Zone" / f"{ZONE_ID}.json": zone_data,
        quest / "Data/Zone/index.idx": zone_index_data,
        quest / "Content/Tile/index.idx": tile_index_data,
    }
    created: list[Path] = []
    old_metadata: list[tuple[Path, bytes | None]] = []
    try:
        for source, destination in plan:
            destination.parent.mkdir(parents=True, exist_ok=True)
            if source.stat().st_dev != destination.parent.stat().st_dev:
                raise OSError("Le staging et les assets source ne partagent pas le même volume pour hardlinks.")
            os.link(source, destination)
            created.append(destination)
        for path, data in pending.items():
            old = path.read_bytes() if path.exists() else None
            if old == data:
                continue
            old_metadata.append((path, old))
            atomic_write(path, data)
    except Exception:
        for path in reversed(created):
            path.unlink(missing_ok=True)
        for path, old in reversed(old_metadata):
            if old is None:
                path.unlink(missing_ok=True)
            else:
                atomic_write(path, old)
        raise
    print(f"Quest : PMD Destiny — Cartothèque ({QUEST_NAMESPACE})")
    print(f"Grounds copiés par hardlink : {len(source_grounds)}")
    print(f"Grounds visibles dans {ZONE_ID} : {len(ground_ids)}")
    print(f"Tilesets dans l’index fusionné : {tile_count}")
    print(f"Assets liés : {len(plan)}")
    return {"grounds": len(source_grounds), "groundMapsVisible": len(ground_ids),
            "tilesets": tile_count, "filesLinked": len(plan)}


def attach_documents(
    overlay: Path, quest: Path, zone_template_provenance: dict,
) -> tuple[dict, list[str]]:
    source_manifest = load_json(overlay / MANIFEST_PATH)
    occurrences = source_manifest.get("sourceOccurrences", [])
    unresolved = [
        str(row.get("entryId")) for row in occurrences
        if row.get("probeMapId") is None
    ]
    if len(source_manifest.get("maps", [])) != 246 or len(occurrences) != 262 or len(unresolved) != 16:
        raise ValueError("L'overlay n'est pas le périmètre documenté 246/262/16.")

    docs = quest / "Documentation"
    docs.mkdir(parents=True, exist_ok=True)
    source_docs = overlay / "Documentation"
    if source_docs.is_dir():
        for source in sorted(source_docs.rglob("*")):
            if not source.is_file():
                continue
            relative = source.relative_to(source_docs)
            if relative.as_posix() == "overlay_manifest.json":
                relative = Path("source_overlay_manifest.json")
            destination = docs / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)

    treasure_rebranding = source_manifest.get("sourcePayloadRebranding")
    if not isinstance(treasure_rebranding, dict):
        raise ValueError("Le manifeste source n’atteste pas le renommage Treasure approuvé.")
    rebrand_occurrences = treasure_rebranding.get("occurrences", [])
    archive_rebrands = [
        row for row in rebrand_occurrences
        if row.get("rebrandingSource") == "approved_package_archive_mapping"
    ]
    workspace_rebrands = [
        row for row in rebrand_occurrences
        if row.get("rebrandingSource") == "verified_workspace_sourceFileMapping"
    ]
    exact_branch_rebrands = [
        row for row in rebrand_occurrences
        if row.get("rebrandingSource") == "verified_exact_branch_string_transform"
    ]
    exact_generated_rebrands = [
        row for row in rebrand_occurrences
        if row.get("rebrandingSource") == "verified_exact_generated_string_transform"
    ]
    archive_source_hashes = {row.get("sourceGroundSha256") for row in archive_rebrands}
    workspace_source_hashes = {row.get("sourceGroundSha256") for row in workspace_rebrands}
    exact_branch_source_hashes = {row.get("sourceGroundSha256") for row in exact_branch_rebrands}
    exact_generated_source_hashes = {row.get("sourceGroundSha256") for row in exact_generated_rebrands}
    all_rebranded_source_hashes = (
        archive_source_hashes | workspace_source_hashes | exact_branch_source_hashes
        | exact_generated_source_hashes
    )
    expected_generated_transform_ids = {
        "generated_048", "generated_049", "generated_052", "generated_053",
        "generated_054", "generated_060", "generated_061", "generated_064",
        "generated_066", "generated_067", "generated_077", "generated_079",
        "generated_080", "generated_087", "generated_088", "generated_091",
    }
    if (treasure_rebranding.get("activeBrand") != "Treasure"
            or treasure_rebranding.get("registeredGroundPayloads") != 40
            or treasure_rebranding.get("packageArchiveOccurrenceCount") != 60
            or treasure_rebranding.get("packageArchiveUniqueSourcePayloads") != 40
            or treasure_rebranding.get("workspaceSourceOccurrenceCount") != 3
            or treasure_rebranding.get("workspaceSourceUniqueSourcePayloads") != 2
            or treasure_rebranding.get("exactBranchStringTransformOccurrenceCount") != 3
            or treasure_rebranding.get("exactBranchStringTransformUniqueSourcePayloads") != 2
            or treasure_rebranding.get("exactGeneratedStringTransformOccurrenceCount") != 16
            or treasure_rebranding.get("exactGeneratedStringTransformUniqueSourcePayloads") != 16
            or treasure_rebranding.get("appliedOccurrenceCount") != 82
            or treasure_rebranding.get("uniqueSourcePayloadsApplied") != 60
            or len(archive_rebrands) != 60 or len(archive_source_hashes) != 40
            or len(workspace_rebrands) != 3 or len(workspace_source_hashes) != 2
            or {row.get("sourceEntryId") for row in workspace_rebrands}
               != {"branch_001", "branch_017", "branch_032"}
            or len(exact_branch_rebrands) != 3 or len(exact_branch_source_hashes) != 2
            or {row.get("sourceEntryId") for row in exact_branch_rebrands}
               != {"branch_008", "branch_024", "branch_037"}
            or len(exact_generated_rebrands) != 16 or len(exact_generated_source_hashes) != 16
            or {row.get("sourceEntryId") for row in exact_generated_rebrands}
               != expected_generated_transform_ids
            or len(rebrand_occurrences) != 82 or len(all_rebranded_source_hashes) != 60):
        raise ValueError(
            "Le rebranding Treasure doit couvrir 60 occurrences d’archive/40 payloads, "
            "3/2 via mapping source/current, 3/2 de branche exacte et 16/16 de Grounds générés "
            "exacts, soit 82 occurrences/60 payloads, sans substitution approximative."
        )
    workspace_mapping_records = treasure_rebranding.get("workspaceSourceGroundMappingRecords", [])
    if (treasure_rebranding.get("workspaceSourceGroundMappings") != 4
            or len(workspace_mapping_records) != 4
            or set(treasure_rebranding.get("workspaceSourceGroundMappingsByHash", []))
               != {row.get("sourceGroundSha256") for row in workspace_mapping_records}):
        raise ValueError("Les quatre mappings Ground source/current du rapport Treasure sont incomplets.")
    exact_branch_mapping_records = treasure_rebranding.get("exactBranchStringTransformRecords", [])
    if (treasure_rebranding.get("exactBranchStringTransformPayloads") != 2
            or len(exact_branch_mapping_records) != 2
            or {row.get("sourceGroundSha256") for row in exact_branch_mapping_records}
               != exact_branch_source_hashes):
        raise ValueError("Les deux transformations textuelles de branche exactes ne sont pas suffisamment documentées.")
    exact_generated_mapping_records = treasure_rebranding.get("exactGeneratedStringTransformRecords", [])
    if (treasure_rebranding.get("exactGeneratedStringTransformPayloads") != 16
            or len(exact_generated_mapping_records) != 16
            or {row.get("sourceGroundSha256") for row in exact_generated_mapping_records}
               != exact_generated_source_hashes
            or {entry_id for row in exact_generated_mapping_records
                for entry_id in row.get("sourceEntryIds", [])}
               != expected_generated_transform_ids
            or any(row.get("sourceBuildCommit") != "f9c97fc0c0c359aa063b45aead947fb080962a9d"
                   or row.get("rebrandingSource") != "verified_exact_generated_string_transform"
                   for row in exact_generated_mapping_records)):
        raise ValueError("Les 16 transformations textuelles des Grounds générés ne sont pas suffisamment documentées.")
    maps_by_id = {row.get("mapId"): row for row in source_manifest.get("maps", [])}
    documented_rebranding = []
    for row in rebrand_occurrences:
        map_id = row.get("mapId")
        map_row = maps_by_id.get(map_id)
        if (row.get("status") != "PASS" or not map_row
                or map_row.get("sourceEntryId") != row.get("sourceEntryId")
                or map_row.get("sourceGroundSha256") != row.get("sourceGroundSha256")
                or map_row.get("sourcePayloadRebranding", {}).get("rebrandedGroundSha256")
                   != row.get("rebrandedGroundSha256")):
            raise ValueError(f"Provenance de rebranding Treasure incohérente : {row.get('sourceEntryId')}")
        documented_rebranding.append({
            **row,
            "finalGroundSha256": map_row.get("outputGroundSha256"),
            "finalGroundFile": map_row.get("groundFile"),
        })
    documented_workspace_mappings = []
    for mapping_row in workspace_mapping_records:
        matching = [
            row for row in documented_rebranding
            if row.get("rebrandingSource") == "verified_workspace_sourceFileMapping"
            and row.get("sourceGroundSha256") == mapping_row.get("sourceGroundSha256")
        ]
        documented_workspace_mappings.append({
            **mapping_row,
            "applied": bool(matching),
            "appliedEntryIds": sorted({row["sourceEntryId"] for row in matching}),
        })
    documented_exact_branch_mappings = []
    for mapping_row in exact_branch_mapping_records:
        matching = [
            row for row in documented_rebranding
            if row.get("rebrandingSource") == "verified_exact_branch_string_transform"
            and row.get("sourceGroundSha256") == mapping_row.get("sourceGroundSha256")
        ]
        documented_exact_branch_mappings.append({
            **mapping_row,
            "applied": bool(matching),
            "appliedEntryIds": sorted({row["sourceEntryId"] for row in matching}),
            "appliedRebrandedGroundSha256": sorted({row["rebrandedGroundSha256"] for row in matching}),
        })
    documented_exact_generated_mappings = []
    for mapping_row in exact_generated_mapping_records:
        matching = [
            row for row in documented_rebranding
            if row.get("rebrandingSource") == "verified_exact_generated_string_transform"
            and row.get("sourceGroundSha256") == mapping_row.get("sourceGroundSha256")
        ]
        documented_exact_generated_mappings.append({
            **mapping_row,
            "applied": bool(matching),
            "appliedEntryIds": sorted({row["sourceEntryId"] for row in matching}),
            "appliedRebrandedGroundSha256": sorted({row["rebrandedGroundSha256"] for row in matching}),
        })
    rebrand_document = {
        "schemaVersion": 1,
        "status": "PASS",
        "activeBrand": "Treasure",
        "migrationReport": treasure_rebranding.get("migrationReport"),
        "migrationReportSha256": treasure_rebranding.get("migrationReportSha256"),
        "sourceArchiveSha256": treasure_rebranding.get("sourceArchiveSha256"),
        "rebrandedArchive": treasure_rebranding.get("rebrandedArchive"),
        "rebrandedArchiveSha256": treasure_rebranding.get("rebrandedArchiveSha256"),
        "registeredGroundPayloads": 40,
        "packageArchiveOccurrenceCount": 60,
        "packageArchiveUniqueSourcePayloads": 40,
        "workspaceSourceOccurrenceCount": 3,
        "workspaceSourceUniqueSourcePayloads": 2,
        "workspaceSourceGroundMappings": 4,
        "exactBranchStringTransformOccurrenceCount": 3,
        "exactBranchStringTransformUniqueSourcePayloads": 2,
        "exactBranchStringTransformPayloads": 2,
        "exactGeneratedStringTransformOccurrenceCount": 16,
        "exactGeneratedStringTransformUniqueSourcePayloads": 16,
        "exactGeneratedStringTransformPayloads": 16,
        "appliedOccurrenceCount": 82,
        "uniqueSourcePayloadsApplied": 60,
        "rule": (
            "Archive Grounds: exact source SHA-256 lookup into the verified Treasure archive; "
            "only audited Comment/layer Name labels differ. Three workspace branch occurrences use "
            "exact source/current paths and hashes in sourceFileMappings; full parsed-Ground comparison "
            "permits only literal Metano→Treasure string substitutions, including tile-sheet names. "
            "Two duplicate cafe occurrences (008/024) have no exact sourceFileMapping target: their "
            "pinned 3df480b… Ground is transformed in memory by the same literal string rule, with a "
            "full parsed-Ground equivalence check and Object.EdgeView=1 preserved. The superficially "
            "related mapped cafe Ground is not substituted because its source hash differs and EdgeView=0. "
            "One normal-home occurrence (037) likewise uses its pinned exact Ground and the two co-committed "
            "Metano TileSheet blobs, whose bytes remain unchanged when staged under the Treasure names. "
            "Sixteen more exact generated Ground outputs from pinned build commit f9c97fc are transformed "
            "in memory only after the source hash/build metadata is verified; case-preserving METANO/Metano/metano "
            "renames are accepted only when resulting TileRefs exactly match the 262-row inventory. Every "
            "source hash, generated output/script, destination hash, and exact source refs are documented. "
            "The source Git blob IDs/SHA-256 values and exact paths are retained. No grid, geometry, collision, "
            "marker, exit, or warp data is inferred or altered."
        ),
        "workspaceSourceGroundMappingRecords": documented_workspace_mappings,
        "exactBranchStringTransformRecords": documented_exact_branch_mappings,
        "exactGeneratedStringTransformRecords": documented_exact_generated_mappings,
        "occurrences": documented_rebranding,
    }
    (docs / "TREASURE_REBRANDING.json").write_text(
        json.dumps(rebrand_document, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    mod_root = ET.fromstring((quest / "Mod.xml").read_bytes())
    mod_uuid = (mod_root.findtext("UUID") or "").strip()
    mod_name = (mod_root.findtext("Name") or "").strip()
    runtime_root = ROOT / ".cache/pmdo-runtime/engine/PMDO"
    runtime_available = (runtime_root / "PMDO").is_file() and (
        runtime_root / "Base/PathParams.xml"
    ).is_file()
    if (mod_root.findtext("Namespace") or "").strip() != QUEST_NAMESPACE:
        raise ValueError("Le Mod.xml généré ne porte pas le namespace destiny.")
    quest_build = {
        "name": mod_name,
        "namespace": QUEST_NAMESPACE,
        "uuid": mod_uuid,
        "gameVersion": EXPECTED_GAME_VERSION,
        "modType": "Quest",
        "identitySource": "Mod.xml déterministe du prototype Destiny 208-Ground (inchangé)",
        "groundMapsInQuest": len(source_manifest["maps"]),
        "sourceOccurrencesInInventory": len(occurrences),
        "sourceOccurrencesWithoutGround": len(unresolved),
        "unavailableSourceEntryIds": unresolved,
        "sourcePayloadRebranding": {
            "status": rebrand_document["status"],
            "activeBrand": rebrand_document["activeBrand"],
            "registeredGroundPayloads": rebrand_document["registeredGroundPayloads"],
            "packageArchiveOccurrenceCount": rebrand_document["packageArchiveOccurrenceCount"],
            "packageArchiveUniqueSourcePayloads": rebrand_document["packageArchiveUniqueSourcePayloads"],
            "workspaceSourceOccurrenceCount": rebrand_document["workspaceSourceOccurrenceCount"],
            "workspaceSourceUniqueSourcePayloads": rebrand_document["workspaceSourceUniqueSourcePayloads"],
            "exactBranchStringTransformOccurrenceCount": rebrand_document["exactBranchStringTransformOccurrenceCount"],
            "exactBranchStringTransformUniqueSourcePayloads": rebrand_document["exactBranchStringTransformUniqueSourcePayloads"],
            "exactGeneratedStringTransformOccurrenceCount": rebrand_document["exactGeneratedStringTransformOccurrenceCount"],
            "exactGeneratedStringTransformUniqueSourcePayloads": rebrand_document["exactGeneratedStringTransformUniqueSourcePayloads"],
            "appliedOccurrenceCount": rebrand_document["appliedOccurrenceCount"],
            "uniqueSourcePayloadsApplied": rebrand_document["uniqueSourcePayloadsApplied"],
            "documentation": "Documentation/TREASURE_REBRANDING.json",
            "migrationReportSha256": rebrand_document["migrationReportSha256"],
        },
        "developerZone": ZONE_ID,
        "developerZoneGroundCount": len(source_manifest["maps"]),
        "zoneTemplateProvenance": zone_template_provenance,
        "narrativeZonesAdded": False,
        "storyTransitionsAdded": False,
        "placeholderGroundsCreated": False,
        "runtimeValidation": {
            "statusAtBuild": "NOT_RUN",
            "testedDuringBuild": False,
            "runtimeAvailableDuringBuild": runtime_available,
            "runtimeRoot": ".cache/pmdo-runtime/engine/PMDO",
            "postBuildReport": "source/pmdo_runtime/destiny_final_quest_246_runtime_summary.json",
            "postBuildReportMustMatchPackageSha256": True,
            "historicalEvidence": {
                "groundProbe": "Documentation/destiny_candidate_246_ground_runtime_results.tsv",
                "tileGuideProbe": "Documentation/destiny_candidate_246_tileguide_runtime_results.tsv",
                "scope": "Ground-only/candidate staging; these reports do not validate this standalone Quest ZIP.",
                "appliesToThisArchive": False,
            },
        },
        "scope": "New standalone cartotheque Quest; not a narrative/gameplay certification.",
    }
    (docs / "QUEST_BUILD.json").write_text(
        json.dumps(quest_build, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (quest / "README.md").write_text(
        "# PMD Destiny — cartothèque PMDO 0.8.12\n\n"
        "Cette **nouvelle quête PMDO** réunit les Grounds disponibles dans une seule installation, "
        "sous le namespace `destiny`. Elle reprend exactement le `Mod.xml` et l’UUID stables du "
        "prototype Destiny 208, puis remplace son catalogue de cartes par les assets validés disponibles.\n\n"
        f"- **{len(source_manifest['maps'])} Grounds** déclarés dans la zone développeur `{ZONE_ID}`.\n"
        "- 1 059 TileSheets et 33 fonds de carte; l’écran-titre ajoute trois fonds Destiny. Aucun contenu de remplacement n’est inventé.\n"
        "- Le constructeur ne lance pas le runtime PMDO. `runtimeValidation.statusAtBuild` consigne l’état à la création; le compte-rendu post-build externe `source/pmdo_runtime/destiny_final_quest_246_runtime_summary.json` doit correspondre au SHA-256 du ZIP. Les TSV 246/246 inclus sont des probes Ground-only/TileGuide historiques, pas un test du ZIP complet.\n"
        "- Zone développeur issue du gabarit natif PMDO 0.8.12; version, Git blob IDs et SHA-256 du gabarit sont documentés dans `Documentation/QUEST_BUILD.json`.\n"
        f"- L’inventaire garde les **{len(occurrences)} occurrences source** et leur provenance. "
        f"Les {len(unresolved)} sans Ground sont listées dans `Documentation/QUEST_BUILD.json` et "
        "`Documentation/destiny_262_inventory.json`.\n"
        "- Rebranding Treasure vérifié : 40 payloads d’archive/60 occurrences, 2 payloads de branche/3 occurrences via mappings source/current, 2 payloads de branche exacts/3 occurrences et 16 Grounds générés exacts/16 payloads renommés par transformation littérale contrôlée; total 82 occurrences/60 payloads. Le café (008/024) conserve `EdgeView=1`; la maison (037) garde ses deux feuilles source co-commitées byte-identiques sous les noms Treasure. Les 16 sorties générées ont leurs hashes, scripts et refs exactes documentés; aucun payload de feuille n’est remplacé approximativement. SHA-256 et provenance dans `Documentation/TREASURE_REBRANDING.json`.\n\n"
        "Cette cartothèque ne contient pas de scénario, de transitions ou de zones narratives. "
        "Elle n’est pas une certification de rendu/jouabilité.\n\n"
        "## Installation\n\n"
        "Extraire le dossier `destiny` dans `PMDO/MODS/`, activer la quête "
        f"`PMD Destiny — Catalogue d’exploration 0.8.12`, puis ouvrir `{ZONE_ID}` en mode développeur.\n"
        "Le `Mod.xml` est inclus dans cette nouvelle quête; il n’écrase aucun dossier extérieur.\n",
        encoding="utf-8",
    )
    return quest_build, unresolved


def validate_treasure_rebranding(quest: Path, manifest: dict) -> dict:
    report_path = quest / "Documentation/TREASURE_REBRANDING.json"
    if not report_path.is_file():
        raise FileNotFoundError(f"Rapport Treasure absent : {report_path}")
    report = load_json(report_path)
    summary = manifest.get("sourcePayloadRebranding", {})
    rows = report.get("occurrences", [])
    archive_rows = [
        row for row in rows
        if row.get("rebrandingSource") == "approved_package_archive_mapping"
    ]
    workspace_rows = [
        row for row in rows
        if row.get("rebrandingSource") == "verified_workspace_sourceFileMapping"
    ]
    exact_branch_rows = [
        row for row in rows
        if row.get("rebrandingSource") == "verified_exact_branch_string_transform"
    ]
    exact_generated_rows = [
        row for row in rows
        if row.get("rebrandingSource") == "verified_exact_generated_string_transform"
    ]
    archive_hashes = {row.get("sourceGroundSha256") for row in archive_rows}
    workspace_hashes = {row.get("sourceGroundSha256") for row in workspace_rows}
    exact_branch_hashes = {row.get("sourceGroundSha256") for row in exact_branch_rows}
    exact_generated_hashes = {row.get("sourceGroundSha256") for row in exact_generated_rows}
    unique_source_hashes = archive_hashes | workspace_hashes | exact_branch_hashes | exact_generated_hashes
    mapping_records = report.get("workspaceSourceGroundMappingRecords", [])
    mapping_hashes = {row.get("sourceGroundSha256") for row in mapping_records}
    applied_mapping_hashes = {
        row.get("sourceGroundSha256") for row in mapping_records if row.get("applied") is True
    }
    exact_branch_records = report.get("exactBranchStringTransformRecords", [])
    exact_branch_record_hashes = {row.get("sourceGroundSha256") for row in exact_branch_records}
    applied_exact_branch_hashes = {
        row.get("sourceGroundSha256") for row in exact_branch_records if row.get("applied") is True
    }
    exact_generated_records = report.get("exactGeneratedStringTransformRecords", [])
    exact_generated_record_hashes = {row.get("sourceGroundSha256") for row in exact_generated_records}
    applied_exact_generated_hashes = {
        row.get("sourceGroundSha256") for row in exact_generated_records if row.get("applied") is True
    }
    expected_generated_transform_ids = {
        "generated_048", "generated_049", "generated_052", "generated_053",
        "generated_054", "generated_060", "generated_061", "generated_064",
        "generated_066", "generated_067", "generated_077", "generated_079",
        "generated_080", "generated_087", "generated_088", "generated_091",
    }
    if (report.get("status") != "PASS" or report.get("activeBrand") != "Treasure"
            or report.get("registeredGroundPayloads") != 40
            or report.get("packageArchiveOccurrenceCount") != 60
            or report.get("packageArchiveUniqueSourcePayloads") != 40
            or report.get("workspaceSourceOccurrenceCount") != 3
            or report.get("workspaceSourceUniqueSourcePayloads") != 2
            or report.get("exactBranchStringTransformOccurrenceCount") != 3
            or report.get("exactBranchStringTransformUniqueSourcePayloads") != 2
            or report.get("exactGeneratedStringTransformOccurrenceCount") != 16
            or report.get("exactGeneratedStringTransformUniqueSourcePayloads") != 16
            or report.get("appliedOccurrenceCount") != 82
            or report.get("uniqueSourcePayloadsApplied") != 60
            or len(archive_rows) != 60 or len(archive_hashes) != 40
            or len(workspace_rows) != 3 or len(workspace_hashes) != 2
            or {row.get("sourceEntryId") for row in workspace_rows}
               != {"branch_001", "branch_017", "branch_032"}
            or len(exact_branch_rows) != 3 or len(exact_branch_hashes) != 2
            or {row.get("sourceEntryId") for row in exact_branch_rows}
               != {"branch_008", "branch_024", "branch_037"}
            or len(exact_generated_rows) != 16 or len(exact_generated_hashes) != 16
            or {row.get("sourceEntryId") for row in exact_generated_rows} != expected_generated_transform_ids
            or len(rows) != 82 or len(unique_source_hashes) != 60
            or report.get("workspaceSourceGroundMappings") != 4
            or len(mapping_records) != 4 or len(mapping_hashes) != 4
            or len(applied_mapping_hashes) != 2 or applied_mapping_hashes != workspace_hashes
            or report.get("exactBranchStringTransformPayloads") != 2
            or len(exact_branch_records) != 2 or len(exact_branch_record_hashes) != 2
            or len(applied_exact_branch_hashes) != 2
            or applied_exact_branch_hashes != exact_branch_hashes
            or {entry for record in exact_branch_records for entry in record.get("appliedEntryIds", [])}
               != {"branch_008", "branch_024", "branch_037"}
            or report.get("exactGeneratedStringTransformPayloads") != 16
            or len(exact_generated_records) != 16 or len(exact_generated_record_hashes) != 16
            or exact_generated_record_hashes != exact_generated_hashes
            or len(applied_exact_generated_hashes) != 16
            or applied_exact_generated_hashes != exact_generated_hashes
            or {entry for record in exact_generated_records for entry in record.get("appliedEntryIds", [])}
               != expected_generated_transform_ids
            or any(record.get("sourceBuildCommit") != "f9c97fc0c0c359aa063b45aead947fb080962a9d"
                   or record.get("rebrandingSource") != "verified_exact_generated_string_transform"
                   for record in exact_generated_records)
            or report.get("packageArchiveOccurrenceCount") != summary.get("packageArchiveOccurrenceCount")
            or report.get("packageArchiveUniqueSourcePayloads") != summary.get("packageArchiveUniqueSourcePayloads")
            or report.get("workspaceSourceOccurrenceCount") != summary.get("workspaceSourceOccurrenceCount")
            or report.get("workspaceSourceUniqueSourcePayloads") != summary.get("workspaceSourceUniqueSourcePayloads")
            or report.get("exactBranchStringTransformOccurrenceCount")
               != summary.get("exactBranchStringTransformOccurrenceCount")
            or report.get("exactBranchStringTransformUniqueSourcePayloads")
               != summary.get("exactBranchStringTransformUniqueSourcePayloads")
            or report.get("exactGeneratedStringTransformOccurrenceCount")
               != summary.get("exactGeneratedStringTransformOccurrenceCount")
            or report.get("exactGeneratedStringTransformUniqueSourcePayloads")
               != summary.get("exactGeneratedStringTransformUniqueSourcePayloads")
            or report.get("appliedOccurrenceCount") != summary.get("appliedOccurrenceCount")
            or report.get("uniqueSourcePayloadsApplied") != summary.get("uniqueSourcePayloadsApplied")
            or report.get("migrationReportSha256") != summary.get("migrationReportSha256")):
        raise ValueError(
            "Le rapport Treasure doit attester 60/40 d’archive, 3/2 de mapping source/current, "
            "3/2 de branche exacte et 16/16 de génération exacte, soit 82 occurrences/60 payloads."
        )

    maps = {row.get("mapId"): row for row in manifest.get("maps", [])}
    seen_ids: set[str] = set()

    def collect_strings(value):
        if isinstance(value, dict):
            for child in value.values():
                yield from collect_strings(child)
        elif isinstance(value, list):
            for child in value:
                yield from collect_strings(child)
        elif isinstance(value, str):
            yield value

    for row in rows:
        map_id = row.get("mapId")
        map_row = maps.get(map_id)
        map_rebrand = (map_row or {}).get("sourcePayloadRebranding", {})
        if (not isinstance(map_id, str) or map_id in seen_ids or not map_row
                or map_row.get("sourceEntryId") != row.get("sourceEntryId")
                or map_row.get("sourceGroundSha256") != row.get("sourceGroundSha256")
                or map_row.get("outputGroundSha256") != row.get("finalGroundSha256")
                or map_row.get("groundFile") != row.get("finalGroundFile")
                or map_rebrand.get("rebrandingSource") != row.get("rebrandingSource")
                or map_rebrand.get("rebrandedGroundSha256") != row.get("rebrandedGroundSha256")):
            raise ValueError(f"Ground/documentation de rebranding désynchronisés : {map_id}")
        seen_ids.add(map_id)
        ground_path = quest / PurePosixPath(str(row["finalGroundFile"]))
        if not ground_path.is_file() or sha256_file(ground_path) != row.get("finalGroundSha256"):
            raise ValueError(f"SHA Ground final de rebranding incorrect : {map_id}")
        ground_doc = load_json(ground_path)
        if any("metano" in text.casefold() for text in collect_strings(ground_doc)):
            raise ValueError(f"Alias Metano restant dans le Ground Treasure : {map_id}")
    return {
        "status": "PASS",
        "activeBrand": "Treasure",
        "registeredGroundPayloads": 40,
        "packageArchiveOccurrenceCount": len(archive_rows),
        "packageArchiveUniqueSourcePayloads": len(archive_hashes),
        "workspaceSourceOccurrenceCount": len(workspace_rows),
        "workspaceSourceUniqueSourcePayloads": len(workspace_hashes),
        "workspaceSourceGroundMappings": len(mapping_records),
        "exactBranchStringTransformOccurrenceCount": len(exact_branch_rows),
        "exactBranchStringTransformUniqueSourcePayloads": len(exact_branch_hashes),
        "exactGeneratedStringTransformOccurrenceCount": len(exact_generated_rows),
        "exactGeneratedStringTransformUniqueSourcePayloads": len(exact_generated_hashes),
        "appliedOccurrenceCount": len(rows),
        "uniqueSourcePayloadsApplied": len(unique_source_hashes),
        "documentation": "Documentation/TREASURE_REBRANDING.json",
    }


def validate_quest(quest: Path, expected_maps: int = 246) -> dict:
    manifest, grounds = validate_overlay(quest)
    if len(grounds) != expected_maps:
        raise ValueError(f"Grounds dans la quête : {len(grounds)}, attendu {expected_maps}.")
    treasure_rebranding = validate_treasure_rebranding(quest, manifest)
    quest_build_doc = load_json(quest / "Documentation/QUEST_BUILD.json")
    zone_template = quest_build_doc.get("zoneTemplateProvenance", {})
    if (zone_template.get("status") != "PASS"
            or zone_template.get("gameVersion") != EXPECTED_GAME_VERSION
            or zone_template.get("source") != "pinned_DumpAsset_PMDO_0.8.12_template"
            or zone_template.get("repository") != PMDO_ZONE_TEMPLATE_SOURCE["repository"]
            or zone_template.get("commit") != PMDO_ZONE_TEMPLATE_SOURCE["commit"]):
        raise ValueError("Le ZIP ne conserve pas la provenance exacte du gabarit Zone PMDO 0.8.12.")
    for relative, expected in PMDO_ZONE_TEMPLATE_SOURCE["files"].items():
        actual = zone_template.get("files", {}).get(relative, {})
        if any(actual.get(key) != expected[key] for key in ("gitBlobOid", "sha256", "bytes")):
            raise ValueError(f"Provenance du gabarit Zone incorrecte pour {relative}")
    root = ET.parse(quest / "Mod.xml").getroot()
    if (root.findtext("Namespace") or "").strip() != QUEST_NAMESPACE:
        raise ValueError("Namespace de la quête incorrect.")
    if (root.findtext("ModType") or "").strip().casefold() != "quest":
        raise ValueError("ModType de la quête incorrect.")
    if (root.findtext("GameVersion") or "").strip() != EXPECTED_GAME_VERSION:
        raise ValueError("GameVersion de la quête incorrect.")
    uuid = (root.findtext("UUID") or "").strip().lower()
    if uuid != DESTINY_QUEST_UUID:
        raise ValueError(f"UUID stable Destiny incorrect : {uuid!r}.")
    title_screen = validate_installed_title_screen(quest)

    ids = sorted(path.stem for path in grounds)
    zone = load_json(quest / "Data/Zone" / f"{ZONE_ID}.json")["Object"]
    index_doc = load_json(quest / "Data/Zone/index.idx")
    index_entry = index_doc["Object"][ZONE_ID]
    if zone.get("GroundMaps") != ids or index_entry.get("Grounds") != ids:
        raise ValueError("La zone développeur n'énumère pas chacun des Grounds de la quête.")
    if zone.get("Segments") != [] or index_entry.get("Maps") != []:
        raise ValueError("La zone cartothèque ne doit ajouter aucun segment ou warp.")

    tile_index = read_index_bytes((quest / "Content/Tile/index.idx").read_bytes())
    tiles = list((quest / "Content/Tile").glob("*.tile"))
    backgrounds = list((quest / "Content/BG").glob("*.dir"))
    if len(tile_index) != 1059 or len(tiles) != 1059 or len(backgrounds) != 36:
        raise ValueError("Comptes d'assets de la quête différents du staging validé (33 fonds de carte + 3 Destiny).")
    return {
        "grounds": len(grounds),
        "tilesheets": len(tiles),
        "backgrounds": len(backgrounds),
        "mapBackgrounds": 33,
        "titleBackgrounds": 3,
        "titleScreen": title_screen,
        "treasureRebranding": treasure_rebranding,
        "zoneTemplateProvenance": zone_template,
        "zoneGrounds": len(zone["GroundMaps"]),
        "sourceOccurrences": len(manifest.get("sourceOccurrences", [])),
        "sourceEntryIdsWithoutGround": [
            row.get("entryId") for row in manifest.get("sourceOccurrences", [])
            if row.get("probeMapId") is None
        ],
        "uuid": (root.findtext("UUID") or "").strip(),
    }


def write_zip(quest: Path, output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(f".{output.name}.tmp")
    temporary.unlink(missing_ok=True)
    try:
        with zipfile.ZipFile(
            temporary, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9, allowZip64=True
        ) as archive:
            for path in sorted(quest.rglob("*"), key=lambda value: value.relative_to(quest).as_posix().casefold()):
                if not path.is_file():
                    continue
                relative = PurePosixPath("destiny", path.relative_to(quest).as_posix())
                info = zipfile.ZipInfo(str(relative), date_time=(2026, 10, 30, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o644 << 16
                with path.open("rb") as source, archive.open(info, "w", force_zip64=True) as destination:
                    shutil.copyfileobj(source, destination, length=1024 * 1024)
        with zipfile.ZipFile(temporary) as archive:
            bad = archive.testzip()
            if bad:
                raise ValueError(f"CRC invalide dans la quête assemblée : {bad}")
            names = set(archive.namelist())
            if "destiny/Mod.xml" not in names or f"destiny/Data/Zone/{ZONE_ID}.json" not in names:
                raise ValueError("Mod.xml ou zone développeur absent du ZIP final.")
            title_files = {
                "destiny/Content/ContentParams.xml",
                "destiny/Content/BG/Destiny_Title_Screen_Background.dir",
                "destiny/Content/BG/Destiny_Title_Screen_Background_Jour.dir",
                "destiny/Content/BG/Destiny_Title_Screen_Background_Nuit.dir",
                "destiny/Content/Obj/Destiny_Logo_Anime_Opening.dir",
                "destiny/Content/UI/Title.png",
                "destiny/Content/UI/Enter.png",
                "destiny/Data/Script/destiny/services/destiny_title_anim/init.lua",
                "destiny/Documentation/DESTINY_TITLE_SCREEN.json",
                "destiny/Documentation/destiny_title_screen_manifest.json",
                "destiny/Documentation/TREASURE_REBRANDING.json",
                "destiny/Documentation/QUEST_BUILD.json",
                "destiny/Documentation/destiny_262_inventory.json",
                "destiny/Documentation/source_overlay_manifest.json",
            }
            if not title_files.issubset(names):
                raise ValueError(f"Assets/rapport écran-titre absents du ZIP : {sorted(title_files - names)}")
            archive_mod = ET.fromstring(archive.read("destiny/Mod.xml"))
            if (archive_mod.findtext("Namespace") or "").strip() != QUEST_NAMESPACE or (
                archive_mod.findtext("UUID") or "").strip().lower() != DESTINY_QUEST_UUID:
                raise ValueError("L’identité stable de la Quest a changé dans le ZIP final.")
            archive_params = ET.fromstring(archive.read("destiny/Content/ContentParams.xml"))
            if (archive_params.findtext("TitleBG") or "").strip() != "Destiny_Title_Screen_Background":
                raise ValueError("Le ZIP final ne référence pas le fond d’écran-titre Destiny.")
            quest_build_doc = json.loads(archive.read("destiny/Documentation/QUEST_BUILD.json"))
            inventory_doc = json.loads(archive.read("destiny/Documentation/destiny_262_inventory.json"))
            quest_manifest = json.loads(archive.read("destiny/Documentation/catalogue_manifest.json"))
            source_occurrences = quest_manifest.get("sourceOccurrences", [])
            unavailable_ids = sorted(
                str(row.get("entryId")) for row in source_occurrences if row.get("probeMapId") is None
            )
            if (quest_manifest.get("mapCount") != 246 or len(source_occurrences) != 262
                    or len(inventory_doc.get("entries", [])) != 262
                    or quest_build_doc.get("sourceOccurrencesInInventory") != 262
                    or quest_build_doc.get("sourceOccurrencesWithoutGround") != 16
                    or sorted(quest_build_doc.get("unavailableSourceEntryIds", [])) != unavailable_ids
                    or len(unavailable_ids) != 16):
                raise ValueError("Le ZIP ne conserve pas l’inventaire 262 occurrences / 16 exclusions sans Ground.")
            zone_template = quest_build_doc.get("zoneTemplateProvenance", {})
            if (zone_template.get("status") != "PASS"
                    or zone_template.get("source") != "pinned_DumpAsset_PMDO_0.8.12_template"
                    or zone_template.get("commit") != PMDO_ZONE_TEMPLATE_SOURCE["commit"]):
                raise ValueError("Le ZIP final ne conserve pas la provenance du gabarit Zone PMDO.")
            ground_files = [name for name in names if name.startswith("destiny/Data/Ground/") and name.endswith(".rsground")]
            if len(ground_files) != 246 or len(quest_manifest.get("maps", [])) != 246:
                raise ValueError(f"Le ZIP contient {len(ground_files)} Grounds, attendu 246.")
            checked_ground_ids = set()
            for map_row in quest_manifest.get("maps", []):
                relative = PurePosixPath(str(map_row.get("groundFile") or ""))
                member = f"destiny/{relative.as_posix()}"
                if (relative.is_absolute() or ".." in relative.parts or member not in names
                        or member in checked_ground_ids):
                    raise ValueError(f"Ground final absent/ambigu dans le ZIP: {member}")
                digest = hashlib.sha256(archive.read(member)).hexdigest()
                if digest != map_row.get("outputGroundSha256"):
                    raise ValueError(f"SHA-256 Ground invalide dans le ZIP: {member}")
                checked_ground_ids.add(member)
            if checked_ground_ids != set(ground_files):
                raise ValueError("Les fichiers Ground du ZIP ne correspondent pas aux 246 lignes de manifeste.")
            tile_members = [
                name for name in names
                if name.startswith("destiny/Content/Tile/") and name.casefold().endswith(".tile")
            ]
            bg_members = [
                name for name in names
                if name.startswith("destiny/Content/BG/") and name.casefold().endswith(".dir")
            ]
            map_bg_files = [
                relative for relative in quest_manifest.get("files", {})
                if relative.startswith("Content/BG/") and relative.casefold().endswith(".dir")
            ]
            if (len(tile_members) != 1059 or len(bg_members) != 36 or len(map_bg_files) != 33
                    or quest_manifest.get("tileIndexNodeCount") != 1059):
                raise ValueError("TileSheets/fonds du ZIP diffèrent du staging vérifié (1059/33 + 3 écran-titre).")
            for relative, expected in quest_manifest.get("files", {}).items():
                path = PurePosixPath(str(relative))
                if path.is_absolute() or ".." in path.parts:
                    raise ValueError(f"Chemin d’asset dangereux dans le manifeste final: {relative}")
                member = f"destiny/{path.as_posix()}"
                if member not in names:
                    raise ValueError(f"Asset déclaré absent du ZIP final: {member}")
                raw = archive.read(member)
                if (hashlib.sha256(raw).hexdigest() != expected.get("sha256")
                        or len(raw) != expected.get("bytes")):
                    raise ValueError(f"SHA-256/taille d’asset incorrecte dans le ZIP final: {member}")
            expected_zone_ids = sorted(str(row["mapId"]) for row in quest_manifest.get("maps", []))
            zone_doc = json.loads(archive.read(f"destiny/Data/Zone/{ZONE_ID}.json").decode("utf-8-sig"))
            zone_index_doc = json.loads(archive.read("destiny/Data/Zone/index.idx").decode("utf-8-sig"))
            zone_object = zone_doc.get("Object", {})
            zone_index_object = zone_index_doc.get("Object", {})
            zone_index_entry = zone_index_object.get(ZONE_ID, {})
            if (zone_doc.get("Version") != EXPECTED_GAME_VERSION
                    or zone_object.get("GroundMaps") != expected_zone_ids
                    or zone_object.get("Segments") != []
                    or zone_index_doc.get("Version") != EXPECTED_GAME_VERSION
                    or zone_index_entry.get("Grounds") != expected_zone_ids
                    or zone_index_entry.get("Maps") != []):
                raise ValueError("Zone développeur du ZIP ne liste pas exactement 246 Grounds sans segment/warp.")
            rebrand_doc = json.loads(archive.read("destiny/Documentation/TREASURE_REBRANDING.json"))
            rebrand_rows = rebrand_doc.get("occurrences", [])
            archive_rebrand_rows = [
                row for row in rebrand_rows
                if row.get("rebrandingSource") == "approved_package_archive_mapping"
            ]
            workspace_rebrand_rows = [
                row for row in rebrand_rows
                if row.get("rebrandingSource") == "verified_workspace_sourceFileMapping"
            ]
            exact_branch_rebrand_rows = [
                row for row in rebrand_rows
                if row.get("rebrandingSource") == "verified_exact_branch_string_transform"
            ]
            exact_generated_rebrand_rows = [
                row for row in rebrand_rows
                if row.get("rebrandingSource") == "verified_exact_generated_string_transform"
            ]
            if (rebrand_doc.get("status") != "PASS"
                    or rebrand_doc.get("packageArchiveOccurrenceCount") != 60
                    or rebrand_doc.get("packageArchiveUniqueSourcePayloads") != 40
                    or rebrand_doc.get("workspaceSourceOccurrenceCount") != 3
                    or rebrand_doc.get("workspaceSourceUniqueSourcePayloads") != 2
                    or rebrand_doc.get("exactBranchStringTransformOccurrenceCount") != 3
                    or rebrand_doc.get("exactBranchStringTransformUniqueSourcePayloads") != 2
                    or rebrand_doc.get("exactGeneratedStringTransformOccurrenceCount") != 16
                    or rebrand_doc.get("exactGeneratedStringTransformUniqueSourcePayloads") != 16
                    or rebrand_doc.get("appliedOccurrenceCount") != 82
                    or rebrand_doc.get("uniqueSourcePayloadsApplied") != 60
                    or len(archive_rebrand_rows) != 60 or len(workspace_rebrand_rows) != 3
                    or len(exact_branch_rebrand_rows) != 3 or len(exact_generated_rebrand_rows) != 16
                    or len(rebrand_rows) != 82):
                raise ValueError("Le ZIP final ne conserve pas le manifeste de rebranding Treasure 82/60 (60/40 + 3/2 + 3/2 + 16/16).")
        os.replace(temporary, output)
    finally:
        temporary.unlink(missing_ok=True)


def finalize_validation(staging: Path, output: Path, ground_report: Path, zone_report: Path) -> dict:
    staging = staging.resolve()
    output = output.resolve()
    ground_report = ground_report.resolve()
    zone_report = zone_report.resolve()
    quest = staging / "destiny"
    if not (quest / "Documentation/QUEST_BUILD.json").is_file():
        raise FileNotFoundError(f"Quête cartothèque non assemblée : {quest}")
    if not ground_report.is_file() or not zone_report.is_file():
        raise FileNotFoundError("Les deux rapports runtime PMDO sont nécessaires à la finalisation.")
    title_integration = integrate_destiny_title_screen(quest)

    ground_lines = ground_report.read_text(encoding="utf-8").splitlines()
    ground_header = {}
    data_lines = []
    for line in ground_lines:
        if not line:
            continue
        if line.startswith("# "):
            key, _, value = line[2:].partition("\t")
            ground_header[key] = value
        else:
            data_lines.append(line.split("\t"))
    if not data_lines or data_lines[0][0] != "sourceRow":
        raise ValueError("En-tête TSV du rapport Ground invalide.")
    ground_rows = data_lines[1:]
    if (len(ground_rows) != 246 or any(len(row) < 11 or row[10] != "PASS" for row in ground_rows)
            or len({row[3].casefold() for row in ground_rows}) != 246
            or ground_header.get("batches") != "13"):
        raise ValueError("Le probe Ground final ne prouve pas 246/246 PASS en 13 lots.")

    zone_rows = [line.split("\t") for line in zone_report.read_text(encoding="utf-8").splitlines() if line]
    if (len(zone_rows) != 4 or zone_rows[0] != ["test", "value", "status"]
            or zone_rows[1] != ["zone", ZONE_ID, "PASS"]
            or zone_rows[2] != ["groundMaps", "246", "PASS"]
            or zone_rows[3] != ["segments", "0", "PASS"]):
        raise ValueError("Le probe runtime Zone n'atteste pas exploration_cartes=246/0 segments.")

    docs = quest / "Documentation"
    reports = docs / "Reports"
    reports.mkdir(parents=True, exist_ok=True)
    # The report's hash covers Ground paths and payloads, not documentation files.
    safe_ground_report = []
    for line in ground_lines:
        if line.startswith("# package\t"):
            safe_ground_report.append("# package\tdestiny/")
        else:
            safe_ground_report.append(line)
    (reports / "destiny_map_quest_246_ground_runtime_results.tsv").write_text(
        "\n".join(safe_ground_report) + "\n", encoding="utf-8"
    )
    shutil.copy2(zone_report, reports / "destiny_map_quest_246_zone_runtime_results.tsv")

    build_path = docs / "QUEST_BUILD.json"
    build = json.loads(build_path.read_text(encoding="utf-8"))
    build["runtimeGroundProbe"] = {
        "status": "PASS",
        "passed": len(ground_rows),
        "failed": 0,
        "batches": 13,
        "inputSha256": ground_header.get("input_sha256"),
        "report": "Documentation/Reports/destiny_map_quest_246_ground_runtime_results.tsv",
    }
    build["runtimeDeveloperZoneProbe"] = {
        "status": "PASS",
        "zone": ZONE_ID,
        "groundMaps": 246,
        "narrativeSegments": 0,
        "report": "Documentation/Reports/destiny_map_quest_246_zone_runtime_results.tsv",
    }
    build_path.write_text(json.dumps(build, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    readme = quest / "README.md"
    text = readme.read_text(encoding="utf-8")
    marker = "- 1 059 TileSheets et 33 fonds de carte; l’écran-titre ajoute trois fonds Destiny. Aucun contenu de remplacement n’est inventé.\n"
    legacy_marker = "- 1 059 TileSheets et 33 fonds; aucun contenu de remplacement n’est inventé.\n"
    addition = (
        marker
        + "- Runtime PMDO 0.8.12.0 : **Ground 246/246 PASS en 13 lots** et zone `exploration_cartes` chargée avec 246 Grounds, 0 segment narratif. Rapports dans `Documentation/Reports/`.\n"
    )
    if marker not in text and legacy_marker in text:
        text = text.replace(legacy_marker, marker, 1)
    if marker not in text:
        raise ValueError("Ligne de compte d'assets absente du README pour ajouter le statut runtime.")
    readme.write_text(text.replace(marker, addition, 1), encoding="utf-8")

    summary = validate_quest(quest)
    write_zip(quest, output)
    return {
        "output": str(output),
        "bytes": output.stat().st_size,
        "sha256": sha256_file(output),
        "crc": "PASS",
        "groundRuntime": "PASS 246/246, 13 batches",
        "zoneRuntime": "PASS exploration_cartes, 246 GroundMaps, 0 segments",
        "namespace": QUEST_NAMESPACE,
        "uuid": summary["uuid"],
        "backgrounds": summary["backgrounds"],
        "mapBackgrounds": summary["mapBackgrounds"],
        "titleScreen": summary["titleScreen"],
        "treasureRebranding": summary["treasureRebranding"],
        "titleScreenIntegration": title_integration,
    }


def build(overlay_zip: Path, output: Path, staging: Path, pmdo_root: Path, force: bool = False) -> dict:
    overlay_zip = overlay_zip.resolve()
    output = output.resolve()
    staging = staging.resolve()
    pmdo_root = pmdo_root.resolve()
    cache_root = (ROOT / ".cache/destiny-recovery").resolve()
    if not staging.is_relative_to(cache_root) or staging == cache_root:
        raise ValueError("Le staging doit rester sous .cache/destiny-recovery/.")
    if not overlay_zip.is_file():
        raise FileNotFoundError(overlay_zip)
    if output.exists() and not force:
        raise FileExistsError(f"La sortie existe déjà (utiliser --force) : {output}")
    if staging.exists():
        if not force:
            raise FileExistsError(f"Le staging existe déjà (utiliser --force) : {staging}")
        shutil.rmtree(staging)
    staging.mkdir(parents=True)
    overlay_extract = staging / "overlay_extract"
    overlay = extract_overlay(overlay_zip, overlay_extract)
    quest = staging / "destiny"
    zone_template_provenance = seed_quest(quest, pmdo_root)
    install_hardlinked(overlay, quest)
    quest_build, unresolved = attach_documents(overlay, quest, zone_template_provenance)
    title_integration = integrate_destiny_title_screen(quest)
    quest_build = load_json(quest / "Documentation/QUEST_BUILD.json")
    summary = validate_quest(quest)
    write_zip(quest, output)
    return {
        "questDirectory": str(quest),
        "output": str(output),
        "bytes": output.stat().st_size,
        "sha256": sha256_file(output),
        "crc": "PASS",
        "identity": {
            "namespace": QUEST_NAMESPACE,
            "uuid": quest_build["uuid"],
            "gameVersion": EXPECTED_GAME_VERSION,
            "modType": "Quest",
        },
        "maps": summary["grounds"],
        "visibleDeveloperZone": summary["zoneGrounds"],
        "tilesheets": summary["tilesheets"],
        "backgrounds": summary["backgrounds"],
        "mapBackgrounds": summary["mapBackgrounds"],
        "titleBackgrounds": summary["titleBackgrounds"],
        "titleScreen": summary["titleScreen"],
        "treasureRebranding": summary["treasureRebranding"],
        "zoneTemplateProvenance": summary["zoneTemplateProvenance"],
        "titleScreenIntegration": title_integration,
        "sourceOccurrences": summary["sourceOccurrences"],
        "sourceOccurrencesWithoutGround": len(unresolved),
        "unavailableSourceEntryIds": unresolved,
        "ModXmlIncluded": True,
        "narrativeZonesAdded": False,
        "storyTransitionsAdded": False,
        "runtimeGroundProbe": quest_build_doc["runtimeValidation"],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--overlay", type=Path, default=OVERLAY_DEFAULT)
    parser.add_argument("--output", type=Path, default=OUTPUT_DEFAULT)
    parser.add_argument("--staging", type=Path, default=STAGING_DEFAULT)
    parser.add_argument("--pmdo-root", type=Path, default=PMDO_ROOT_DEFAULT,
                        help="Racine du PMDO 0.8.12 installé, pour le modèle Zone natif")
    parser.add_argument("--force", action="store_true", help="remplacer uniquement sortie/staging de génération")
    parser.add_argument("--finalize-validation", action="store_true",
                        help="inclure les deux rapports runtime déjà produits et regénérer le ZIP")
    parser.add_argument("--ground-report", type=Path,
                        default=ROOT / "source/pmdo_runtime/destiny_map_quest_246_ground_runtime_results.tsv")
    parser.add_argument("--zone-report", type=Path,
                        default=ROOT / "source/pmdo_runtime/destiny_map_quest_246_zone_runtime_results.tsv")
    args = parser.parse_args()
    if args.finalize_validation:
        result = finalize_validation(args.staging, args.output, args.ground_report, args.zone_report)
    else:
        result = build(args.overlay, args.output, args.staging, args.pmdo_root, args.force)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
