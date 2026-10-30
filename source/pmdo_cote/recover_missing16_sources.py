#!/usr/bin/env python3
"""Récupère les 13 Grounds source de branche exacts et isole trois candidates non exactes.

Le script ne modifie ni la quête `destiny`, ni son inventaire de provenance, ni une
installation PMDO. Les payloads exacts sont vérifiés contre les Git blobs et les
SHA-256 inscrits dans destiny_262_inventory.json. Les trois Grounds générés sont
copiés seulement sous un bundle de candidates explicitement non exactes.
"""
from __future__ import annotations

import argparse
import base64
import gzip
import hashlib
import json
import shutil
import urllib.request
import zipfile
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
INVENTORY = ROOT / "source/pmdo_cote/destiny_262_inventory.json"
REPOSITORY = "meromoonmeri/projet-creation-pmdo"
EXACT_IDS = [
    "branch_002", "branch_003", "branch_010", "branch_011", "branch_018",
    "branch_019", "branch_026", "branch_027", "branch_028", "branch_029",
    "branch_030", "branch_031", "branch_036",
]
GENERATED_IDS = ["generated_002", "generated_007", "generated_029"]


def sha256(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def git_blob_sha(raw: bytes) -> str:
    return hashlib.sha1(b"blob " + str(len(raw)).encode("ascii") + b"\0" + raw).hexdigest()


def canonical_inventory_alias(value: str) -> str:
    """Map source Metano identifiers to the active Treasure inventory aliases.

    This is metadata-only validation for the user's confirmed rebrand. It is never
    applied to source Ground bytes or to paths in the provenance source repository.
    """
    return (
        value.replace("Metano_", "Treasure_")
        .replace("metano_", "treasure_")
        .replace("_metano_", "_treasure_")
    )


def fetch_blob(oid: str, cache_dir: Path) -> bytes:
    cache_dir.mkdir(parents=True, exist_ok=True)
    path = cache_dir / oid
    if path.is_file():
        raw = path.read_bytes()
        if git_blob_sha(raw) == oid:
            return raw
        path.unlink()
    url = f"https://api.github.com/repos/{REPOSITORY}/git/blobs/{oid}"
    request = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json", "User-Agent": "Arena-Destiny-Recovery"})
    with urllib.request.urlopen(request, timeout=120) as response:
        document = json.load(response)
    if document.get("encoding") != "base64":
        raise ValueError(f"GitHub blob {oid}: encoding inattendu {document.get('encoding')!r}")
    raw = base64.b64decode(document["content"])
    actual = git_blob_sha(raw)
    if actual != oid:
        raise ValueError(f"GitHub blob {oid}: Git SHA-1 {actual}")
    path.write_bytes(raw)
    return raw


def validate_ground(raw: bytes, row: dict[str, Any]) -> dict[str, Any]:
    actual = sha256(raw)
    expected = row.get("groundSha256")
    if actual != expected:
        raise ValueError(f"{row['entryId']}: Ground SHA-256 {actual} != inventaire {expected}")
    if len(raw) != row.get("groundBytes"):
        raise ValueError(f"{row['entryId']}: taille {len(raw)} != inventaire {row.get('groundBytes')}")
    data = json.loads(raw.decode("utf-8-sig"))
    obj = data.get("Object") or {}
    version = data.get("Version")
    tex_size = obj.get("TexSize")
    layers = obj.get("Layers") or []
    grid = row.get("grid")
    actual_grid = None
    for layer in layers:
        cells = layer.get("Tiles") if isinstance(layer, dict) else None
        if isinstance(cells, list) and cells:
            actual_grid = [len(cells), len(cells[0])]
            break
    if actual_grid is None and isinstance(obj.get("obstacles"), list):
        obstacles = obj["obstacles"]
        actual_grid = [len(obstacles) // tex_size, len(obstacles[0]) // tex_size]
    if version != row.get("groundVersion"):
        raise ValueError(f"{row['entryId']}: Ground.Version {version!r} != inventaire {row.get('groundVersion')!r}")
    if actual_grid != grid:
        raise ValueError(f"{row['entryId']}: grille {actual_grid!r} != inventaire {grid!r}")
    if len(layers) != row.get("layerCount"):
        raise ValueError(f"{row['entryId']}: calques {len(layers)} != inventaire {row.get('layerCount')}")

    source_asset_name = obj.get("AssetName")
    if not isinstance(source_asset_name, str) or not source_asset_name.strip():
        raise ValueError(f"{row['entryId']}: Object.AssetName source absent")
    if "/" in source_asset_name or "\\" in source_asset_name:
        raise ValueError(f"{row['entryId']}: Object.AssetName source non sûr pour un chemin")
    if canonical_inventory_alias(source_asset_name) != row.get("assetName"):
        raise ValueError(
            f"{row['entryId']}: alias source {source_asset_name!r} != inventaire canonique {row.get('assetName')!r}"
        )

    source_tile_refs: set[str] = set()
    source_autotilesets: set[str] = set()
    source_anim_indices: set[str] = set()

    def collect_source_refs(value: Any) -> None:
        if isinstance(value, dict):
            for key, child in value.items():
                if isinstance(child, str) and child:
                    if key == "Sheet":
                        source_tile_refs.add(child)
                    elif key == "AutoTileset":
                        source_autotilesets.add(child)
                    elif key == "AnimIndex":
                        source_anim_indices.add(child)
                collect_source_refs(child)
        elif isinstance(value, list):
            for child in value:
                collect_source_refs(child)

    collect_source_refs(obj)
    canonical_source_refs = {canonical_inventory_alias(value) for value in source_tile_refs}
    inventory_tile_refs = set(row.get("tileRefs", []))
    if canonical_source_refs != inventory_tile_refs:
        raise ValueError(
            f"{row['entryId']}: refs Tile source != refs canoniques de l’inventaire après alias explicite; "
            f"source-only={sorted(canonical_source_refs - inventory_tile_refs)[:5]}, "
            f"inventory-only={sorted(inventory_tile_refs - canonical_source_refs)[:5]}"
        )

    name_field = obj.get("Name")
    source_display_name = name_field.get("DefaultText", "") if isinstance(name_field, dict) else name_field
    return {
        "groundVersion": version,
        "texSize": tex_size,
        "grid": actual_grid,
        "layers": len(layers),
        "sourceAssetName": source_asset_name,
        "sourceDisplayName": source_display_name,
        "sourceTileRefs": sorted(source_tile_refs),
        "sourceAutoTilesetRefs": sorted(source_autotilesets),
        "sourceAnimIndices": sorted(source_anim_indices),
        "sourceToInventoryAliasVerified": True,
    }


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def display_path(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def archive_directory(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        destination.unlink()
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(source.rglob("*")):
            if path.is_file():
                archive.write(path, path.relative_to(source).as_posix())
    with zipfile.ZipFile(destination) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"CRC invalide {destination}: {bad}")


def inspect_candidate(raw: bytes) -> dict[str, Any]:
    data = json.loads(raw.decode("utf-8-sig"))
    obj = data["Object"]
    layers = obj["Layers"]
    grid = None
    for layer in layers:
        cells = layer.get("Tiles") if isinstance(layer, dict) else None
        if isinstance(cells, list) and cells:
            grid = [len(cells), len(cells[0])]
            break
    if grid is None:
        tex_size = obj["TexSize"]
        obstacles = obj["obstacles"]
        grid = [len(obstacles) // tex_size, len(obstacles[0]) // tex_size]
    return {
        "assetName": obj["AssetName"], "groundVersion": data["Version"],
        "texSize": obj["TexSize"], "grid": grid, "layers": len(layers),
        "groundSha256": sha256(raw), "bytes": len(raw),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--work-dir", type=Path, default=ROOT / ".cache/destiny-recovery/missing16-bundles")
    parser.add_argument("--output-dir", type=Path, default=ROOT / "exports/pmdo")
    parser.add_argument(
        "--exact-only", action="store_true",
        help="Créer seulement le bundle des 13 Grounds exacts, sans reconstruire les candidates non exactes.",
    )
    args = parser.parse_args()
    work = args.work_dir.resolve()
    output = args.output_dir.resolve()
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    rows = {row["entryId"]: row for row in inventory["entries"]}
    if not set(EXACT_IDS + GENERATED_IDS).issubset(rows):
        raise ValueError("L’inventaire ne contient pas les 16 IDs attendus.")

    exact_root = work / "exact_branch_13"
    candidate_root = work / "nonexact_generated_3"
    for folder in (exact_root, candidate_root):
        if folder.exists():
            shutil.rmtree(folder)
        folder.mkdir(parents=True)
    exact_occurrence_dir = exact_root / "recovered_exact" / "occurrences"
    provenance_dir = exact_root / "provenance" / "source_blobs"
    exact_occurrence_dir.mkdir(parents=True)
    provenance_dir.mkdir(parents=True)

    exact_manifest_rows = []
    distinct: dict[str, str] = {}  # Ground SHA-256 -> first occurrence ID
    duplicate_of: dict[str, str] = {}
    source_cache = work / "git-blob-cache"
    for entry_id in EXACT_IDS:
        row = rows[entry_id]
        locator = row["sourceLocator"]
        source_bytes = fetch_blob(locator["blobOid"], source_cache)
        if len(source_bytes) != locator["blobBytes"]:
            raise ValueError(f"{entry_id}: Git blob size {len(source_bytes)} != {locator['blobBytes']}")
        if locator["path"].endswith(".gz"):
            raw = gzip.decompress(source_bytes)
            source_name = f"{entry_id}_source.rsground.gz"
            (provenance_dir / source_name).write_bytes(source_bytes)
        else:
            raw = source_bytes
        stats = validate_ground(raw, row)
        digest = row["groundSha256"]
        if digest in distinct:
            duplicate_of[entry_id] = distinct[digest]
        else:
            distinct[digest] = entry_id
        source_asset_name = stats["sourceAssetName"]
        source_file = f"recovered_exact/occurrences/{entry_id}__{source_asset_name}.rsground"
        (exact_root / source_file).write_bytes(raw)
        canonical_missing = set(row.get("missingTileRefs", []))
        source_missing = sorted(
            source_ref for source_ref in stats["sourceTileRefs"]
            if canonical_inventory_alias(source_ref) in canonical_missing
        )
        source_ref_mappings = [
            {
                "sourceSheetName": source_ref,
                "canonicalInventorySheetName": canonical_inventory_alias(source_ref),
                "renamedForInventory": source_ref != canonical_inventory_alias(source_ref),
            }
            for source_ref in stats["sourceTileRefs"]
        ]
        exact_manifest_rows.append({
            "entryId": entry_id,
            "sourceEntryId": entry_id,
            "mapId": source_asset_name,
            "assetName": source_asset_name,
            "sourceAssetName": source_asset_name,
            "sourceDisplayName": stats["sourceDisplayName"],
            "canonicalInventoryAssetName": row["assetName"],
            "canonicalInventoryDisplayName": row.get("displayName"),
            "groundFile": source_file,
            "groundSha256": digest,
            "groundVersion": stats["groundVersion"],
            "texSize": stats["texSize"],
            "grid": stats["grid"],
            "layers": stats["layers"],
            "sourceLocator": locator,
            "tileRefs": stats["sourceTileRefs"],
            "missingTileRefs": source_missing,
            "sourceAutoTilesetRefs": stats["sourceAutoTilesetRefs"],
            "sourceAnimIndices": stats["sourceAnimIndices"],
            "sourceToInventoryTileRefMappings": source_ref_mappings,
            "canonicalInventoryTileRefs": row.get("tileRefs", []),
            "canonicalInventoryMissingTileRefs": row.get("missingTileRefs", []),
            "sourceToInventoryAliasVerified": stats["sourceToInventoryAliasVerified"],
            "duplicateOf": duplicate_of.get(entry_id),
            "assetStatus": row.get("assetStatus"),
            "previewEligible": row.get("previewEligible"),
            "playabilityCertified": row.get("playabilityCertified"),
        })

    inventory_sha = sha256(INVENTORY.read_bytes())
    exact_manifest = {
        "schemaVersion": 1,
        "title": "PMD Destiny — sources Ground exactes des 13 occurrences de branche",
        "packageType": "source-recovery-only-not-an-installable-quest",
        "targetRuntime": "PMDO 0.8.12.0",
        "sourceInventory": "source/pmdo_cote/destiny_262_inventory.json",
        "sourceInventorySha256": inventory_sha,
        "sourcePayloadIdentifiers": {
            "assetNameAndTileRefs": "read from each exact source Ground payload without rebranding",
            "inventoryAliases": {
                "Metano_": "Treasure_",
                "metano_": "treasure_",
                "_metano_": "_treasure_",
            },
            "aliasScope": "manifest comparison only; source Ground bytes and source refs are never rewritten",
            "mappingValidatedAgainstInventory": True,
        },
        "sourceOccurrenceCount": len(exact_manifest_rows),
        "distinctGroundSha256Count": len(distinct),
        "duplicateOccurrenceCount": len(exact_manifest_rows) - len(distinct),
        "questIntegration": False,
        "tileGuideProbe": "not_run; exact tile assets remain unresolved for these entries",
        "maps": exact_manifest_rows,
    }
    write_json(exact_root / "manifest.json", exact_manifest)
    (exact_root / "README.txt").write_text(
        "PMD DESTINY — 13 SOURCES GROUND EXACTES DE BRANCHE\n\n"
        "Ce ZIP est un bundle de récupération source, pas un MOD/Quest installable.\n"
        "Les 13 occurrences sont représentées séparément sous recovered_exact/occurrences/.\n"
        "Le SHA-256 et les octets de chaque payload correspondent aux Grounds sources attendus.\n"
        "`assetName`, `tileRefs` et `missingTileRefs` décrivent le payload source brut; les\n"
        "alias canoniques Treasure de l’inventaire sont consignés séparément et validés sans\n"
        "modifier les octets source. Les trois paires de doublons restent distinctes.\n\n"
        "Les 13 cartes restent bloquées par des références Tile non résolues. Aucun TileSheet,\n"
        "Ground, collision, sortie, warp ou transition n’a été substitué ou inventé. Le probe\n"
        "Ground natif ne valide pas TileGuide, le rendu, la navigation ou la jouabilité.\n\n"
        "Voir manifest.json pour les commits, paths, Git blob IDs et hashes d’origine.\n",
        encoding="utf-8",
    )
    exact_zip = output / "PMD_Destiny_13_Exact_Branch_Ground_Sources.zip"
    archive_directory(exact_root, exact_zip)
    if args.exact_only:
        raw = exact_zip.read_bytes()
        summary = {
            "exactBranchOccurrences": len(exact_manifest_rows),
            "exactBranchDistinctGrounds": len(distinct),
            "exactBranchDuplicateOccurrences": len(exact_manifest_rows) - len(distinct),
            "generatedExactOutputsRecovered": 0,
            "generatedNonExactCandidates": 0,
            "nativeProbePending": True,
            "exactGroundArchive": {
                "path": display_path(exact_zip),
                "bytes": len(raw),
                "sha256": sha256(raw),
            },
            "exactOnly": True,
        }
        write_json(work / "recovery_summary.json", summary)
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        return

    # Three explicit alternatives; the original inventory SHA is retained separately and is
    # never used as a checksum for these candidates.
    candidates = []
    candidate_specs = {
        "generated_002": {
            "path": ROOT / ".cache/destiny-recovery/new-16/agm2_upstream_variant.rsground",
            "source": {
                "repository": "meromoonmeri/projet-pmdo",
                "commit": "6f6921a1f014ddcfec7e56ae17543eb55caa2a80",
                "archive": "renders/arene_groudon_magma_v2/AGM2_projet_pmdo_0812.zip",
                "archiveGitBlob": "d245e10f0035b282612a3143559fffe828758693",
                "archiveMember": "arene_groudon_magma/Data/Ground/agm2_arene_groudon_magma.rsground",
            },
        },
        "generated_007": {
            "path": ROOT / ".cache/entree_caverne_cristal_sud_nord_v1/entree_caverne_cristal_sud_nord/Data/Ground/ekr1_entree_caverne_cristal.rsground",
            "source": {
                "rebuiltFromOriginalSources": True,
                "sourceCommit": "0b31ab7339646f9c803b516236d25c2e685a8f65",
                "comparisonManifestCommit": "0e691d647a661f3c2a79984eda2d39686d4f0dfc",
                "buildScript": "source/entree_caverne_cristal_sud_nord_v1/build.py",
                "templateArchiveSha256": "e41f6da9438d7129290cb59e796c8443bd40709d4e7d99e624fb5f62ef3bd177",
                "rawInputHashesMatchHistoricalManifest": True,
            },
        },
        "generated_029": {
            "path": ROOT / ".cache/fin_caverne_cristal_v1/fin_caverne_cristal/Data/Ground/fkr1_fin_caverne_cristal.rsground",
            "source": {
                "rebuiltFromOriginalSources": True,
                "sourceCommit": "d3710fd7f53dd307fa876ae68dfdde7af37d3c8a",
                "comparisonManifestCommit": "0e691d647a661f3c2a79984eda2d39686d4f0dfc",
                "buildScript": "source/fin_caverne_cristal_v1/build.py",
                "templateArchiveSha256": "e41f6da9438d7129290cb59e796c8443bd40709d4e7d99e624fb5f62ef3bd177",
                "rawInputHashesMatchHistoricalManifest": True,
            },
        },
    }
    candidate_maps = []
    for entry_id in GENERATED_IDS:
        expected = rows[entry_id]
        spec = candidate_specs[entry_id]
        source_path = spec["path"]
        if not source_path.is_file():
            raise FileNotFoundError(f"candidate source absent for {entry_id}: {source_path}")
        raw = source_path.read_bytes()
        actual = inspect_candidate(raw)
        exact = actual["groundSha256"] == expected["groundSha256"] and actual["bytes"] == expected["groundBytes"]
        if exact:
            raise ValueError(f"{entry_id}: candidate inesperadamente exact; vérifier le classement manuel")
        relative = f"candidates_nonexact/{entry_id}__HASH_MISMATCH.rsground"
        (candidate_root / relative).parent.mkdir(parents=True, exist_ok=True)
        (candidate_root / relative).write_bytes(raw)
        candidate = {
            "entryId": entry_id,
            "assetName": expected["assetName"],
            "candidateFile": relative,
            "candidateGroundSha256": actual["groundSha256"],
            "candidateBytes": actual["bytes"],
            "expectedOriginalGroundSha256": expected["groundSha256"],
            "expectedOriginalGroundBytes": expected["groundBytes"],
            "exactHashMatch": False,
            "groundVersion": actual["groundVersion"],
            "texSize": actual["texSize"],
            "grid": actual["grid"],
            "layers": actual["layers"],
            "source": spec["source"],
        }
        candidates.append(candidate)
        candidate_maps.append({
            "entryId": entry_id,
            "sourceEntryId": entry_id,
            "mapId": actual["assetName"],
            "assetName": actual["assetName"],
            "groundFile": relative,
            "groundSha256": actual["groundSha256"],
            "groundVersion": actual["groundVersion"],
            "texSize": actual["texSize"],
            "grid": actual["grid"],
            "layers": actual["layers"],
            "expectedOriginalGroundSha256": expected["groundSha256"],
            "expectedOriginalGroundBytes": expected["groundBytes"],
            "candidateOnly": True,
        })

    candidate_manifest = {
        "schemaVersion": 1,
        "title": "PMD Destiny — candidates générées non exactes",
        "packageType": "ground-probe-candidates-only-not-an-installable-quest",
        "targetRuntime": "PMDO 0.8.12.0",
        "questIntegration": False,
        "candidates": candidates,
        "maps": candidate_maps,
    }
    write_json(candidate_root / "manifest.json", candidate_manifest)
    (candidate_root / "README.txt").write_text(
        "PMD DESTINY — 3 CANDIDATES GROUND NON EXACTES\n\n"
        "Aucune de ces trois sorties n’a l’empreinte de l’occurrence originale. Elles sont\n"
        "fournies uniquement pour inspection/probe technique, jamais comme substituts.\n"
        "generated_007 et generated_029 sont des reconstructions avec inputs sources exacts,\n"
        "mais le Ground sérialisé diffère. generated_002 est une autre version publiée.\n"
        "Ce ZIP n’est pas un MOD/Quest installable et ne remplace aucune carte `destiny`.\n\n"
        "Les hashes attendus et actuels sont dans manifest.json.\n",
        encoding="utf-8",
    )
    candidates_zip = output / "PMD_Destiny_3_NonExact_Generated_Ground_Candidates.zip"
    archive_directory(candidate_root, candidates_zip)

    def archive_summary(path: Path) -> dict[str, Any]:
        raw = path.read_bytes()
        return {"path": display_path(path), "bytes": len(raw), "sha256": sha256(raw)}
    summary = {
        "exactBranchOccurrences": len(exact_manifest_rows),
        "exactBranchDistinctGrounds": len(distinct),
        "exactBranchDuplicateOccurrences": len(exact_manifest_rows) - len(distinct),
        "generatedExactOutputsRecovered": 0,
        "generatedNonExactCandidates": len(candidates),
        "nativeProbePending": True,
        "archives": [archive_summary(exact_zip), archive_summary(candidates_zip)],
    }
    write_json(work / "recovery_summary.json", summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
