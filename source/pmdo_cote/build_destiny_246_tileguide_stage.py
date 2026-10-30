#!/usr/bin/env python3
"""Assemble the 246-source Ground + exact asset staging for TileGuide.Load.

This is still a disposable validation input, not an installable 262-map Quest.
For every included source occurrence it resolves the exact referenced .tile and
background .dir from its source ZIP, branch commit, generated package, the five
source-grid reconstructions, or PMDO's base assets. When local core assets are
absent, exact blobs are fetched from the pinned PMDCollab RawAsset commit and
Git-object hashes are checked. A branch-only fallback may use a current Treasure
.tile only when the migration report maps its exact current path and SHA-256 to
a byte-identical pre-rename Metano file. The one normal-home alias is restricted
to two exact TileSheet blobs co-committed with branch_037; bytes are untouched,
and source Git blob IDs/SHA-256 values are recorded. For sixteen pinned generated
Grounds, the original .tile bytes are taken from the same exact virtual ZIP whose
Ground member matches the source SHA; only the sheet filename/reference is
rebranded, with ZIP/member CRCs and hashes recorded. When two source packages
reuse a tile name for different bytes, the staging aliases that sheet name in
that map's Frames and stores the original .tile bytes under a deterministic
unique name. No tile coordinates, geometry, collision, markers, or warps change.
The 13 source-asset-blocked occurrences and three unavailable generated Grounds
remain in the 262-row provenance register without substitutes.
"""
from __future__ import annotations

import ast
import base64
from collections import defaultdict
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import zipfile
from dataclasses import dataclass
from typing import Any, BinaryIO

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
INVENTORY = ROOT / "source/pmdo_cote/destiny_262_inventory.json"
CANDIDATE = ROOT / ".cache/destiny-recovery/candidate-246-ground-probe"
RECOVERY = ROOT / ".cache/destiny-recovery"
ARCHIVES = RECOVERY / "projet-pmdo-archives"
BRANCH_TREES = RECOVERY / "branch-trees"
WORKSPACE = RECOVERY / "workspace-f9c97"
RECONSTRUCTION = RECOVERY / "empty_ground_reconstructed_native"
PROTOTYPE = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
RUNTIME_BASE = ROOT / ".cache/pmdo-runtime/engine/PMDO"
OUTPUT = RECOVERY / "candidate-246-tileguide"
BLOB_CACHE = RECOVERY / "tileguide-branch-blob-cache"
EXPECTED_SOURCE_OCCURRENCES = 262
EXPECTED_MAPS = 246
TREASURE_MIGRATION_REPORT = ROOT / "exports/treasure_rename/migration_report.json"
DUMPASSET_REPOSITORY = "audinowho/DumpAsset"
DUMPASSET_COMMIT = "3e767571f9dd94270b848b3a73de9bec2553a2eb"
DUMPASSET_CACHE = RECOVERY / "tileguide-dumpasset-cache"
PINNED_GENERATED_BUILD_COMMIT = "f9c97fc0c0c359aa063b45aead947fb080962a9d"
EXACT_BRANCH_TREASURE_TILE_ALIASES = {
    "branch_037": {
        "sourceGroundSha256": "2b33ddaf10a5f486d612c88812b3721131f7b3e8e9906bab5476f76db4faeef8",
        "groundCommit": "f9c97fc0c0c359aa063b45aead947fb080962a9d",
        "groundBlobOid": "06882c3cc955fb64e558ab74ee934c410cc379cf",
        "groundPath": "source/reseau_treasure_normal_v1/references/treasure_normal_home.rsground",
        "aliases": {
            "Treasure_Town_Normal_Home_Base": {
                "sourceName": "Metano_Town_Normal_Home_Base",
                "sourcePath": "source/reseau_metano_normal_v1/references/Metano_Town_Normal_Home_Base.tile",
                "sourceBlobOid": "dc294dc858e6d6279f825f747c4971eb81f96708",
                "sourceSha256": "e601263c7054e2ff8f3604b3c09ef0b32791af1c6b23628d18fc53c315a713a7",
                "sourceBytes": 204621,
            },
            "Treasure_Town_Normal_Home_Objects": {
                "sourceName": "Metano_Town_Normal_Home_Objects",
                "sourcePath": "source/reseau_metano_normal_v1/references/Metano_Town_Normal_Home_Objects.tile",
                "sourceBlobOid": "242a37501516a3848ec907fb87cdcd8ee2dc1dea",
                "sourceSha256": "09d654f49eced37e9ee2fea5d649239761dcc5f0ff0d391c775338a78dcce930",
                "sourceBytes": 19021,
            },
        },
    },
}

from source.pmdo_cote.installer_destiny_overlay import encode_index, tile_index_node  # noqa: E402


def gh_api_json(endpoint: str) -> dict[str, Any]:
    result = subprocess.run(
        ["gh", "api", endpoint], cwd=ROOT, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, text=True, check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(f"GitHub API {endpoint}: {result.stderr.strip()}")
    try:
        document = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise ValueError(f"GitHub API JSON invalide pour {endpoint}") from exc
    if not isinstance(document, dict):
        raise ValueError(f"GitHub API n’a pas renvoyé un objet JSON pour {endpoint}")
    return document


def load_migration_tile_rows() -> dict[str, list[dict[str, Any]]]:
    """Index only payload-identical .tile rows from the approved Treasure migration."""
    if not TREASURE_MIGRATION_REPORT.is_file():
        raise FileNotFoundError(f"Rapport de migration Treasure absent: {TREASURE_MIGRATION_REPORT}")
    report = json.loads(TREASURE_MIGRATION_REPORT.read_text(encoding="utf-8"))
    if report.get("targetBrand") != "Treasure":
        raise ValueError("Le rapport de migration de feuilles ne cible pas Treasure.")
    found: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in report.get("sourceFileMappings", []):
        current_path = PurePosixPath(str(row.get("currentPath") or ""))
        source_sha = str(row.get("sourceSha256") or "").lower()
        current_sha = str(row.get("currentSha256") or "").lower()
        if (current_path.suffix.casefold() != ".tile" or current_path.is_absolute()
                or ".." in current_path.parts or len(source_sha) != 64
                or source_sha != current_sha or row.get("sourceTextOccurrences") != 0
                or row.get("currentTextOccurrences") not in (None, 0)):
            continue
        found[current_path.name.casefold()].append(row)
    return dict(found)


@dataclass(frozen=True)
class Asset:
    logical_name: str
    kind: str
    locator: str
    member: str
    sha256: str
    byte_count: int
    provenance: str
    source_sheet_name: str | None = None
    source_ground_sha256: str | None = None
    source_build_commit: str | None = None
    source_build_script: str | None = None
    source_archive_path: str | None = None
    source_archive_sha256: str | None = None
    source_archive_member: str | None = None
    source_archive_member_crc: str | None = None
    source_archive_crc_check: str | None = None
    source_ground_member_crc: str | None = None


class AssetResolver:
    def __init__(self) -> None:
        self.zip_cache: dict[str, zipfile.ZipFile] = {}
        self.generated_tile_aliases: dict[str, dict[str, dict[str, Any]]] = {}
        self.generated_virtual_package_cache: dict[str, dict[str, Any]] = {}
        self.branch_trees: dict[str, list[dict[str, Any]]] = {}
        self.asset_cache: dict[tuple[str, str, str], Asset] = {}
        self.branch_tree_paths: dict[str, dict[str, Any]] = {}
        self.proto_archive: zipfile.ZipFile | None = None
        self.proto_members_by_hash: dict[str, str] = {}
        self.prototype_asset_names: set[str] = set()
        self.prototype_asset_members: dict[tuple[str, str], str] = {}
        self.blob_cache: dict[str, Path] = {}
        migration_bytes = TREASURE_MIGRATION_REPORT.read_bytes()
        self.migration_report_sha256 = hashlib.sha256(migration_bytes).hexdigest()
        self.migration_tile_rows = load_migration_tile_rows()
        self.dumpasset_rows: dict[tuple[str, str], list[dict[str, Any]]] | None = None

    def close(self) -> None:
        for archive in self.zip_cache.values():
            archive.close()
        if self.proto_archive is not None:
            self.proto_archive.close()

    def _sha_path(self, path: Path) -> tuple[str, int]:
        digest = hashlib.sha256()
        byte_count = 0
        with path.open("rb") as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b""):
                digest.update(block)
                byte_count += len(block)
        return digest.hexdigest(), byte_count

    def _zip(self, archive_name: str) -> zipfile.ZipFile:
        path = ARCHIVES / archive_name
        if not path.is_file():
            raise FileNotFoundError(f"ZIP source absent: {path}")
        key = str(path.resolve())
        if key not in self.zip_cache:
            self.zip_cache[key] = zipfile.ZipFile(path)
        return self.zip_cache[key]

    def _local_zip(self, path: Path) -> zipfile.ZipFile:
        if not path.is_file():
            raise FileNotFoundError(f"ZIP généré exact absent: {path}")
        key = str(path.resolve())
        if key not in self.zip_cache:
            self.zip_cache[key] = zipfile.ZipFile(path)
        return self.zip_cache[key]

    def _hash_zip_member(self, archive: zipfile.ZipFile, member: str) -> tuple[str, int]:
        digest = hashlib.sha256()
        byte_count = 0
        with archive.open(member) as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b""):
                digest.update(block)
                byte_count += len(block)
        return digest.hexdigest(), byte_count

    def _match_zip_member(self, archive: zipfile.ZipFile, name: str, extension: str,
                          area: str) -> str | None:
        wanted = (name + extension).casefold()
        candidates = [
            member for member in archive.namelist()
            if not member.endswith("/")
            and PurePosixPath(member).name.casefold() == wanted
            and f"/{area.casefold()}/" in ("/" + member.replace("\\", "/").casefold())
        ]
        if not candidates:
            return None
        hashes = {self._hash_zip_member(archive, member)[0] for member in candidates}
        if len(hashes) != 1:
            raise ValueError(f"Asset ZIP ambigu: {name}{extension}: {candidates}")
        return sorted(candidates, key=str.casefold)[0]

    def _path_asset(self, name: str, path: Path, provenance: str) -> Asset:
        key = ("path", str(path.resolve()), "")
        if key in self.asset_cache:
            return self.asset_cache[key]
        digest, byte_count = self._sha_path(path)
        asset = Asset(name, "path", str(path.resolve()), "", digest, byte_count, provenance)
        self.asset_cache[key] = asset
        return asset

    def _zip_asset(self, name: str, archive_name: str, member: str,
                   provenance: str) -> Asset:
        archive = self._zip(archive_name)
        key = ("zip", archive_name, member)
        if key in self.asset_cache:
            return self.asset_cache[key]
        digest, byte_count = self._hash_zip_member(archive, member)
        asset = Asset(name, "zip", archive_name, member, digest, byte_count, provenance)
        self.asset_cache[key] = asset
        return asset

    def _branch_tree(self, commit: str) -> list[dict[str, Any]]:
        if commit in self.branch_trees:
            return self.branch_trees[commit]
        path = BRANCH_TREES / f"{commit}.json"
        if not path.is_file():
            raise FileNotFoundError(f"Tree source de branche absent: {path}")
        tree = json.loads(path.read_text(encoding="utf-8")).get("tree", [])
        self.branch_trees[commit] = tree
        return tree

    def _branch_asset(self, name: str, commit: str, extension: str,
                      area: str, provenance: str) -> Asset | None:
        tree = self._branch_tree(commit)
        expected_filename = (name + extension).casefold()
        candidates = [
            row for row in tree
            if row.get("type") == "blob"
            and PurePosixPath(row.get("path", "")).name.casefold() == expected_filename
        ]
        if not candidates:
            return None
        blob_ids = {row["sha"] for row in candidates}
        if len(blob_ids) != 1:
            raise ValueError(
                f"Asset de branche ambigu dans le commit {commit}: {name}{extension}: "
                f"{[(row['path'], row['sha']) for row in candidates]}"
            )
        blob_id = next(iter(blob_ids))
        cache_key = ("git", blob_id, "")
        if cache_key in self.asset_cache:
            previous = self.asset_cache[cache_key]
            return Asset(name, previous.kind, previous.locator, previous.member,
                         previous.sha256, previous.byte_count, provenance)
        cached = self.blob_cache.get(blob_id)
        if cached is None or not cached.is_file():
            BLOB_CACHE.mkdir(parents=True, exist_ok=True)
            cached = BLOB_CACHE / f"{blob_id}{extension}"
            if not cached.is_file():
                result = subprocess.run(
                    ["git", "cat-file", "blob", blob_id], cwd=ROOT,
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False,
                )
                if result.returncode == 0:
                    cached.write_bytes(result.stdout)
                else:
                    response = subprocess.run(
                        ["gh", "api", f"repos/meromoonmeri/projet-creation-pmdo/git/blobs/{blob_id}",
                         "--jq", ".content"],
                        cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                        text=True, check=False,
                    )
                    if response.returncode != 0:
                        raise RuntimeError(
                            f"Blob de branche {blob_id} absent de git et GitHub: "
                            f"{response.stderr.strip()}"
                        )
                    cached.write_bytes(base64.b64decode(response.stdout.strip()))
            self.blob_cache[blob_id] = cached
        digest, byte_count = self._sha_path(cached)
        asset = Asset(name, "path", str(cached.resolve()), "", digest, byte_count,
                      f"branch:{commit}:{candidates[0]['path']}:{blob_id};{provenance}")
        self.asset_cache[cache_key] = asset
        return asset

    def _migration_workspace_asset(self, name: str, extension: str) -> Asset | None:
        """Resolve a branch sheet only through an exact source/current hash mapping."""
        rows = self.migration_tile_rows.get(f"{name}{extension}".casefold(), [])
        matches: list[tuple[str, Path, str, str]] = []
        for row in rows:
            current_relative = PurePosixPath(str(row["currentPath"]))
            current_path = ROOT.joinpath(*current_relative.parts)
            legacy_relative = PurePosixPath(
                current_relative.as_posix().replace("Treasure", "Metano").replace("treasure", "metano")
            )
            legacy_path = WORKSPACE.joinpath(*legacy_relative.parts)
            if not current_path.is_file() or not legacy_path.is_file():
                continue
            current_sha, current_bytes = self._sha_path(current_path)
            legacy_sha, legacy_bytes = self._sha_path(legacy_path)
            if (current_sha != row.get("currentSha256")
                    or current_sha != row.get("sourceSha256")
                    or current_bytes != row.get("currentBytes")
                    or legacy_sha != row.get("sourceSha256")
                    or legacy_bytes != row.get("sourceBytes")):
                continue
            matches.append((current_sha, current_path, legacy_relative.as_posix(), current_relative.as_posix()))
        if not matches:
            return None
        distinct_hashes = {row[0] for row in matches}
        if len(distinct_hashes) != 1:
            raise ValueError(
                f"Mappings Treasure ambigus pour la feuille {name}{extension}: "
                f"{[(row[2], row[3], row[0]) for row in matches]}"
            )
        digest, path, legacy_relative, current_relative = sorted(
            matches, key=lambda row: row[3].casefold()
        )[0]
        asset = self._path_asset(
            name,
            path,
            f"verified-Treasure-sourceFileMapping:{legacy_relative}->{current_relative}:sha256={digest}",
        )
        return asset

    def _exact_branch_treasure_tile_alias(
        self, entry: dict[str, Any], name: str, extension: str, area: str,
    ) -> Asset | None:
        rule = EXACT_BRANCH_TREASURE_TILE_ALIASES.get(str(entry.get("entryId")))
        if not rule or extension != ".tile" or area != "Tile":
            return None
        locator = entry.get("sourceLocator", {})
        if (entry.get("groundSha256") != rule["sourceGroundSha256"]
                or locator.get("commit") != rule["groundCommit"]
                or locator.get("blobOid") != rule["groundBlobOid"]
                or locator.get("path") != rule["groundPath"]):
            raise ValueError(f"Provenance source Ground non conforme à l’alias exact Treasure: {entry.get('entryId')}")
        mapping = rule["aliases"].get(name)
        if not mapping:
            return None
        commit = str(rule["groundCommit"])
        tree_rows = self._branch_tree(commit)
        exact_rows = [
            row for row in tree_rows
            if row.get("type") == "blob"
            and row.get("path") == mapping["sourcePath"]
            and row.get("sha") == mapping["sourceBlobOid"]
        ]
        if len(exact_rows) != 1:
            raise ValueError(
                f"Le blob TileSheet source exact manque pour {entry.get('entryId')}/{name}: "
                f"{mapping['sourcePath']} {mapping['sourceBlobOid']}"
            )
        source_asset = self._branch_asset(
            mapping["sourceName"], commit, extension, area,
            f"exact-ground-entry:{entry['entryId']}:{locator.get('blobOid')}",
        )
        if source_asset is None:
            raise FileNotFoundError(f"TileSheet source exact absent: {mapping['sourceName']}{extension}")
        source_bytes = Path(source_asset.locator).read_bytes()
        git_blob_oid = hashlib.sha1(
            b"blob " + str(len(source_bytes)).encode("ascii") + b"\0" + source_bytes
        ).hexdigest()
        if (git_blob_oid != mapping["sourceBlobOid"]
                or source_asset.sha256 != mapping["sourceSha256"]
                or source_asset.byte_count != mapping["sourceBytes"]):
            raise ValueError(f"Hash/tailles TileSheet source exacts différents: {mapping['sourceName']}")
        return Asset(
            name, source_asset.kind, source_asset.locator, source_asset.member,
            source_asset.sha256, source_asset.byte_count,
            f"approved-exact-Treasure-name-alias:{mapping['sourceName']}->{name};"
            f"branch:{commit}:{mapping['sourcePath']}:git_blob={git_blob_oid};"
            f"sha256={source_asset.sha256};bytes={source_asset.byte_count};GroundSourceSha256={rule['sourceGroundSha256']}",
            mapping["sourceName"], rule["sourceGroundSha256"],
        )

    def _generated_virtual_package_info(
        self, entry: dict[str, Any], rule: dict[str, Any],
    ) -> dict[str, Any]:
        entry_id = str(entry.get("entryId") or "")
        if entry_id in self.generated_virtual_package_cache:
            return self.generated_virtual_package_cache[entry_id]
        locator = entry.get("sourceLocator", {})
        generated_rel = PurePosixPath(str(locator.get("generatedOutput") or ""))
        script_rel = PurePosixPath(str(locator.get("sourceBuildScript") or ""))
        source_lot = str(locator.get("sourceLot") or "")
        if (entry.get("sourceCategory") != "generated_build"
                or entry.get("groundSha256") != rule.get("sourceGroundSha256")
                or rule.get("sourceBuildCommit") != PINNED_GENERATED_BUILD_COMMIT
                or locator.get("generatedOutput") != rule.get("generatedOutput")
                or locator.get("sourceBuildScript") != rule.get("sourceBuildScript")
                or locator.get("sourceLot") != rule.get("sourceLot")
                or not generated_rel.parts or generated_rel.is_absolute() or ".." in generated_rel.parts
                or not script_rel.parts or script_rel.is_absolute() or ".." in script_rel.parts):
            raise ValueError(f"Provenance générée incompatible pour l’alias Tile exact: {entry_id}")
        script_path = WORKSPACE.joinpath(*script_rel.parts)
        if not script_path.is_file():
            raise FileNotFoundError(f"Script générateur épinglé absent: {script_path}")
        parsed = ast.parse(script_path.read_text(encoding="utf-8"))
        map_ids = [
            ast.literal_eval(node.value)
            for node in parsed.body
            if isinstance(node, ast.Assign)
            and any(isinstance(target, ast.Name) and target.id == "MAP_ID" for target in node.targets)
            and isinstance(node.value, ast.Constant) and isinstance(node.value.value, str)
        ]
        if len(map_ids) != 1:
            raise ValueError(f"MAP_ID absent ou ambigu dans le script source de {entry_id}")
        virtual_zip = WORKSPACE / ".cache" / "virtual_zips" / f"{map_ids[0]}_PMDO_0.8.12.zip"
        generated_ground_path = WORKSPACE.joinpath(*generated_rel.parts)
        if not generated_ground_path.is_file():
            raise FileNotFoundError(f"Ground généré source absent pour {entry_id}: {generated_ground_path}")
        package_root = generated_ground_path.parents[2]
        expected_package_root = WORKSPACE / ".cache" / "tiles" / source_lot
        if package_root.resolve() != expected_package_root.resolve():
            raise ValueError(f"Ground généré hors de son lot source exact pour {entry_id}")
        try:
            data_index = generated_rel.parts.index("Data")
        except ValueError as exc:
            raise ValueError(f"Chemin Ground généré sans dossier Data pour {entry_id}") from exc
        ground_member = PurePosixPath(*generated_rel.parts[data_index:]).as_posix()
        if not ground_member.startswith("Data/Ground/"):
            raise ValueError(f"Membre Ground généré inattendu pour {entry_id}: {ground_member}")

        archive = self._local_zip(virtual_zip)
        bad_member = archive.testzip()
        if bad_member:
            raise ValueError(f"CRC source invalide dans {virtual_zip.name}: {bad_member}")
        ground_infos = [info for info in archive.infolist() if info.filename == ground_member]
        if len(ground_infos) != 1:
            raise ValueError(f"Ground source absent/ambigu dans {virtual_zip.name}: {ground_member}")
        ground_sha, ground_bytes = self._hash_zip_member(archive, ground_member)
        expected_ground_sha, expected_ground_bytes = self._sha_path(generated_ground_path)
        if (ground_sha != entry.get("groundSha256")
                or ground_sha != expected_ground_sha
                or ground_bytes != expected_ground_bytes
                or ground_bytes != entry.get("groundBytes")):
            raise ValueError(f"Ground du ZIP virtuel non identique à la sortie exacte pour {entry_id}")
        archive_sha, archive_bytes = self._sha_path(virtual_zip)
        info = {
            "archivePath": virtual_zip,
            "archiveRelativePath": virtual_zip.relative_to(ROOT).as_posix(),
            "archiveSha256": archive_sha,
            "archiveBytes": archive_bytes,
            "archiveCrcCheck": "PASS",
            "groundMember": ground_member,
            "groundMemberSha256": ground_sha,
            "groundMemberBytes": ground_bytes,
            "groundMemberCrc": f"{ground_infos[0].CRC:08x}",
        }
        self.generated_virtual_package_cache[entry_id] = info
        return info

    def _exact_generated_treasure_tile_alias(
        self, entry: dict[str, Any], name: str, extension: str, area: str,
    ) -> Asset | None:
        if extension != ".tile" or area != "Tile":
            return None
        entry_id = str(entry.get("entryId") or "")
        rule = self.generated_tile_aliases.get(entry_id, {}).get(name)
        if rule is None:
            return None
        source_name = str(rule["sourceSheetName"])
        source_tile_refs = set(map(str, rule.get("sourceTileRefs", [])))
        target_tile_refs = set(map(str, rule.get("expectedTreasureTileRefs", [])))
        renamed_source_name = (
            source_name.replace("METANO", "TREASURE")
            .replace("Metano", "Treasure").replace("metano", "treasure")
        )
        if (entry.get("groundSha256") != rule.get("sourceGroundSha256")
                or source_name not in source_tile_refs
                or name not in target_tile_refs
                or renamed_source_name != name
                or entry.get("sourceCategory") != "generated_build"):
            raise ValueError(f"Alias de TileSheet généré non exact pour {entry_id}/{name}")
        package = self._generated_virtual_package_info(entry, rule)
        archive = self._local_zip(package["archivePath"])
        member = f"Content/Tile/{source_name}.tile"
        infos = [info for info in archive.infolist() if info.filename == member]
        if len(infos) != 1:
            raise ValueError(f"TileSheet source absent/ambigu dans {package['archivePath'].name}: {member}")
        info = infos[0]
        digest, byte_count = self._hash_zip_member(archive, member)
        if byte_count != info.file_size:
            raise ValueError(f"Taille TileSheet source différente du ZIP virtuel: {member}")
        provenance = (
            f"approved-exact-generated-Treasure-name-alias:{source_name}->{name};"
            f"generatedGround:{entry_id}:{rule['sourceGroundSha256']};"
            f"build:{rule['sourceBuildCommit']}:{rule['sourceBuildScript']}:{rule['generatedOutput']};"
            f"virtualZip:{package['archiveRelativePath']}:sha256={package['archiveSha256']}:"
            f"bytes={package['archiveBytes']}:crc={package['archiveCrcCheck']};"
            f"groundMember={package['groundMember']}:sha256={package['groundMemberSha256']}:"
            f"crc={package['groundMemberCrc']};tileMember={member}:sha256={digest}:"
            f"bytes={byte_count}:crc={info.CRC:08x}"
        )
        return Asset(
            name, "virtual-zip", str(package["archivePath"]), member, digest, byte_count,
            provenance, source_name, rule["sourceGroundSha256"], rule["sourceBuildCommit"],
            rule["sourceBuildScript"], package["archiveRelativePath"], package["archiveSha256"],
            member, f"{info.CRC:08x}", package["archiveCrcCheck"], package["groundMemberCrc"],
        )

    def _load_dumpasset_index(self) -> dict[tuple[str, str], list[dict[str, Any]]]:
        if self.dumpasset_rows is not None:
            return self.dumpasset_rows
        DUMPASSET_CACHE.mkdir(parents=True, exist_ok=True)
        cache_path = DUMPASSET_CACHE / f"{DUMPASSET_COMMIT}-content-assets.json"
        if cache_path.is_file():
            cached = json.loads(cache_path.read_text(encoding="utf-8"))
            raw_areas = (
                cached["areas"] if cached.get("commit") == DUMPASSET_COMMIT
                and cached.get("areas") else None
            )
        else:
            raw_areas = None
        if raw_areas is None:
            commit = gh_api_json(f"repos/{DUMPASSET_REPOSITORY}/git/commits/{DUMPASSET_COMMIT}")
            root_tree_sha = str((commit.get("tree") or {}).get("sha") or "")
            if len(root_tree_sha) != 40:
                raise ValueError(f"Tree racine DumpAsset invalide pour {DUMPASSET_COMMIT}")
            root_tree = gh_api_json(f"repos/{DUMPASSET_REPOSITORY}/git/trees/{root_tree_sha}")
            content_row = next((row for row in root_tree.get("tree", [])
                                if row.get("path") == "Content" and row.get("type") == "tree"), None)
            if not content_row:
                raise ValueError("Le dump PMDO épinglé ne contient pas le dossier Content attendu.")
            content_tree = gh_api_json(
                f"repos/{DUMPASSET_REPOSITORY}/git/trees/{content_row['sha']}"
            )
            area_trees = {
                row["path"]: row["sha"] for row in content_tree.get("tree", [])
                if row.get("type") == "tree" and row.get("path") in {"Tile", "BG"}
            }
            if set(area_trees) != {"Tile", "BG"}:
                raise ValueError("Le dump PMDO épinglé ne contient pas Content/Tile et Content/BG.")
            raw_areas = {}
            for area_name, tree_sha in area_trees.items():
                area_tree = gh_api_json(f"repos/{DUMPASSET_REPOSITORY}/git/trees/{tree_sha}")
                raw_areas[area_name] = [
                    row for row in area_tree.get("tree", [])
                    if row.get("type") == "blob"
                ]
            cache_path.write_text(json.dumps({
                "commit": DUMPASSET_COMMIT,
                "rootTreeSha": root_tree_sha,
                "contentTreeSha": content_row["sha"],
                "areaTreeShas": area_trees,
                "areas": raw_areas,
            }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        found: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
        for area_name, rows in raw_areas.items():
            for row in rows:
                found[(area_name.casefold(), str(row.get("path", "")).casefold())].append(row)
        self.dumpasset_rows = dict(found)
        return self.dumpasset_rows

    def _dumpasset_asset(self, name: str, extension: str, area: str) -> Asset | None:
        indexed = self._load_dumpasset_index()
        key = (area.casefold(), f"{name}{extension}".casefold())
        candidates = indexed.get(key, [])
        if not candidates:
            return None
        blob_ids = {str(row.get("sha") or "") for row in candidates}
        if len(blob_ids) != 1:
            raise ValueError(f"Asset PMDO base ambigu dans le commit épinglé: {area}/{name}{extension}")
        row = candidates[0]
        blob_id = next(iter(blob_ids))
        byte_count = int(row.get("size") or 0)
        if len(blob_id) != 40 or byte_count <= 0:
            raise ValueError(f"Entrée Git invalide pour Content/{area}/{name}{extension}")
        DUMPASSET_CACHE.mkdir(parents=True, exist_ok=True)
        cached = DUMPASSET_CACHE / f"{blob_id}{extension}"
        if cached.is_file():
            raw = cached.read_bytes()
            actual_blob = hashlib.sha1(b"blob " + str(len(raw)).encode("ascii") + b"\0" + raw).hexdigest()
            if actual_blob != blob_id or len(raw) != byte_count:
                cached.unlink()
        if not cached.is_file():
            document = gh_api_json(f"repos/{DUMPASSET_REPOSITORY}/git/blobs/{blob_id}")
            if document.get("encoding") != "base64":
                raise ValueError(f"Encodage blob PMDO base inattendu: {blob_id}")
            raw = base64.b64decode(document.get("content", ""))
            actual_blob = hashlib.sha1(b"blob " + str(len(raw)).encode("ascii") + b"\0" + raw).hexdigest()
            if actual_blob != blob_id or len(raw) != byte_count:
                raise ValueError(
                    f"Blob PMDO base non vérifié {blob_id}: Git {actual_blob}, octets {len(raw)}"
                )
            cached.write_bytes(raw)
        digest, actual_bytes = self._sha_path(cached)
        if actual_bytes != byte_count:
            raise ValueError(f"Taille différente pour le blob PMDO de base {blob_id}")
        relative = f"Content/{area}/{row['path']}"
        return self._path_asset(
            name, cached,
            f"base:{DUMPASSET_REPOSITORY}@{DUMPASSET_COMMIT}:{relative}:git_blob={blob_id}:sha256={digest}",
        )

    def _prototype_index(self) -> None:
        if self.proto_archive is not None:
            return
        if not PROTOTYPE.is_file():
            raise FileNotFoundError(PROTOTYPE)
        self.proto_archive = zipfile.ZipFile(PROTOTYPE)
        manifest = json.loads(self.proto_archive.read("destiny/manifest.json"))
        for row in manifest.get("maps", []):
            source_sha = row.get("sourceGroundSha256")
            ground_file = row.get("groundFile")
            if source_sha and ground_file:
                self.proto_members_by_hash.setdefault(source_sha, f"destiny/{ground_file}")
        for member in self.proto_archive.namelist():
            if member.startswith("destiny/Content/Tile/") and member.casefold().endswith(".tile"):
                self.prototype_asset_members[("tile", PurePosixPath(member).stem.casefold())] = member
            elif member.startswith("destiny/Content/BG/") and member.casefold().endswith(".dir"):
                self.prototype_asset_members[("bg", PurePosixPath(member).name.casefold())] = member

    def _prototype_asset(self, name: str, extension: str, area: str,
                         provenance: str) -> Asset | None:
        self._prototype_index()
        assert self.proto_archive is not None
        kind = "tile" if extension == ".tile" else "bg"
        lookup_name = name.casefold() if kind == "tile" else (name + extension).casefold()
        member = self.prototype_asset_members.get((kind, lookup_name))
        if member is None:
            # Background references are normally directory names; accommodate an
            # explicit .dir suffix in either the reference or package member.
            member = next((item for item in self.proto_archive.namelist()
                          if item.startswith(f"destiny/Content/{area}/")
                          and PurePosixPath(item).name.casefold() == (name + extension).casefold()), None)
        if member is None:
            return None
        key = ("zip", PROTOTYPE.name, member)
        if key in self.asset_cache:
            prior = self.asset_cache[key]
            return Asset(name, prior.kind, prior.locator, prior.member,
                         prior.sha256, prior.byte_count, provenance)
        digest, byte_count = self._hash_zip_member(self.proto_archive, member)
        asset = Asset(name, "zip", PROTOTYPE.name, member, digest, byte_count, provenance)
        self.asset_cache[key] = asset
        return asset

    @staticmethod
    def _find_asset_in_dir(directory: Path, name: str, extension: str) -> Path | None:
        if not directory.is_dir():
            return None
        direct = directory / f"{name}{extension}"
        if direct.is_file():
            return direct
        folded = f"{name}{extension}".casefold()
        matches = [path for path in directory.iterdir()
                   if path.is_file() and path.name.casefold() == folded]
        if len(matches) > 1:
            hashes = {hashlib.sha256(path.read_bytes()).hexdigest() for path in matches}
            if len(hashes) > 1:
                raise ValueError(f"Assets locaux ambigus: {matches}")
        return sorted(matches, key=lambda path: path.name.casefold())[0] if matches else None

    @classmethod
    def _find_asset_recursive(cls, directory: Path, name: str, extension: str) -> Path | None:
        if not directory.is_dir():
            return None
        folded = f"{name}{extension}".casefold()
        matches = [path for path in directory.rglob("*")
                   if path.is_file() and path.name.casefold() == folded]
        if not matches:
            return None
        hashes = {cls._sha_for_check(path) for path in matches}
        if len(hashes) > 1:
            raise ValueError(f"Assets locaux récursifs ambigus pour {name}{extension}: {matches}")
        return sorted(matches, key=lambda path: path.as_posix().casefold())[0]

    @staticmethod
    def _sha_for_check(path: Path) -> str:
        digest = hashlib.sha256()
        with path.open("rb") as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b""):
                digest.update(block)
        return digest.hexdigest()

    def resolve(self, entry: dict[str, Any], ref: str, asset_kind: str) -> Asset:
        extension = ".tile" if asset_kind == "tile" else ".dir"
        area = "Tile" if asset_kind == "tile" else "BG"
        key = (entry["entryId"], asset_kind, ref)
        cache_key = ("resolved", *key)
        if cache_key in self.asset_cache:
            return self.asset_cache[cache_key]
        category = entry["sourceCategory"]
        locator = entry.get("sourceLocator", {})
        asset: Asset | None = None

        if category == "zip_archive":
            archive_name = str(locator["archive"])
            archive = self._zip(archive_name)
            member = self._match_zip_member(archive, ref, extension, area)
            if member:
                asset = self._zip_asset(ref, archive_name, member, f"zip:{archive_name}:{member}")

        elif category == "generated_build":
            generated_rel = locator.get("generatedOutput")
            if generated_rel:
                ground_path = WORKSPACE / generated_rel
                source_lot = str(locator.get("sourceLot") or "")
                roots: list[Path] = []
                if ground_path.is_file():
                    package_root = ground_path.parents[2]
                    roots.append(package_root)
                if source_lot:
                    roots.extend([
                        WORKSPACE / ".cache" / source_lot,
                        WORKSPACE / ".cache/tiles" / source_lot,
                        WORKSPACE / "renders" / source_lot,
                        WORKSPACE / "source" / source_lot,
                    ])
                seen_roots: set[Path] = set()
                for root in roots:
                    root = root.resolve()
                    if root in seen_roots:
                        continue
                    seen_roots.add(root)
                    path = self._find_asset_in_dir(root / "Content" / area, ref, extension)
                    if path is None:
                        path = self._find_asset_in_dir(root, ref, extension)
                    if path is None:
                        path = self._find_asset_recursive(root, ref, extension)
                    if path:
                        asset = self._path_asset(ref, path, f"generated:{generated_rel}")
                        break
            if asset is None and asset_kind == "tile":
                asset = self._exact_generated_treasure_tile_alias(entry, ref, extension, area)
            if asset is None:
                expected = str(entry.get("groundSha256") or "")
                self._prototype_index()
                if expected in self.proto_members_by_hash:
                    asset = self._prototype_asset(ref, extension, area,
                                                  f"prototype-sourceGround:{expected}")

        elif category == "arena_branch":
            if entry.get("assetStatus") == "reconstructed_native_assets_from_source":
                path = self._find_asset_in_dir(RECONSTRUCTION / "Content" / area, ref, extension)
                if path:
                    asset = self._path_asset(ref, path, f"reconstructed:{entry['entryId']}")
            if asset is None:
                commit = str(locator.get("commit") or "")
                asset = self._branch_asset(ref, commit, extension, area,
                                           f"branch-entry:{entry['entryId']}")
            if asset is None and asset_kind == "tile":
                asset = self._migration_workspace_asset(ref, extension)
            if asset is None and asset_kind == "tile":
                asset = self._exact_branch_treasure_tile_alias(entry, ref, extension, area)

        if asset is None:
            # The inventory marks base references explicitly where known. A
            # source package may also legitimately reuse a PMDO base asset.
            path = self._find_asset_in_dir(RUNTIME_BASE / "Content" / area, ref, extension)
            if path:
                asset = self._path_asset(ref, path, "PMDO-0.8.12-base-content")

        if asset is None:
            # Exact original PMDO 0.8.12 base payloads, indexed from the pinned
            # RawAsset commit because the local runtime tree may be incomplete.
            asset = self._dumpasset_asset(ref, extension, area)

        if asset is None and category in {"arena_branch", "generated_build"}:
            asset = self._prototype_asset(ref, extension, area,
                                          "prototype-shared-content-candidate")
        if asset is None:
            raise FileNotFoundError(
                f"Asset {ref}{extension} absent pour {entry['entryId']} "
                f"({category}, {locator})"
            )
        self.asset_cache[cache_key] = asset
        return asset

    def write_asset(self, asset: Asset, destination: Path) -> None:
        destination.parent.mkdir(parents=True, exist_ok=True)
        if asset.kind == "path":
            source = Path(asset.locator)
            try:
                os.link(source, destination)
                return
            except OSError:
                shutil.copy2(source, destination)
                return
        if asset.kind == "zip":
            archive_path = ARCHIVES / asset.locator if asset.locator != PROTOTYPE.name else PROTOTYPE
            with zipfile.ZipFile(archive_path) as archive, archive.open(asset.member) as incoming:
                with destination.open("wb") as outgoing:
                    shutil.copyfileobj(incoming, outgoing, length=1024 * 1024)
            return
        if asset.kind == "virtual-zip":
            with zipfile.ZipFile(asset.locator) as archive, archive.open(asset.member) as incoming:
                with destination.open("wb") as outgoing:
                    shutil.copyfileobj(incoming, outgoing, length=1024 * 1024)
            return
        raise ValueError(f"Type de source d’asset inconnu: {asset.kind}")


def safe_slug(value: str, limit: int = 35) -> str:
    slug = re.sub(r"[^A-Za-z0-9]+", "_", value).strip("_")
    return (slug or "sheet")[:limit].strip("_") or "sheet"


def bytes_hash(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sheet_refs_from_ground(document: dict[str, Any]) -> set[str]:
    result: set[str] = set()
    obj = document.get("Object", {})
    for layer in obj.get("Layers", []) or []:
        for column in layer.get("Tiles", []) or []:
            for cell in column or []:
                for animation in cell.get("Layers", []) or []:
                    for frame in animation.get("Frames", []) or []:
                        if frame.get("Sheet"):
                            result.add(str(frame["Sheet"]))
    return result


def apply_sheet_aliases(document: dict[str, Any], aliases: dict[str, str]) -> int:
    count = 0
    obj = document.get("Object", {})
    for layer in obj.get("Layers", []) or []:
        for column in layer.get("Tiles", []) or []:
            for cell in column or []:
                for animation in cell.get("Layers", []) or []:
                    for frame in animation.get("Frames", []) or []:
                        sheet = frame.get("Sheet")
                        if sheet in aliases:
                            frame["Sheet"] = aliases[sheet]
                            count += 1
    return count


def build_exact_generated_treasure_tile_aliases(
    candidate_rebranding: dict[str, Any], source_entries: dict[str, dict[str, Any]],
) -> dict[str, dict[str, dict[str, Any]]]:
    """Derive per-map aliases only from exact generated Ground transform records."""
    expected_ids = {
        "generated_048", "generated_049", "generated_052", "generated_053",
        "generated_054", "generated_060", "generated_061", "generated_064",
        "generated_066", "generated_067", "generated_077", "generated_079",
        "generated_080", "generated_087", "generated_088", "generated_091",
    }
    records = candidate_rebranding.get("exactGeneratedStringTransformRecords", [])
    aliases: dict[str, dict[str, dict[str, Any]]] = {}
    found_ids: set[str] = set()

    def rename(text: str) -> str:
        return text.replace("METANO", "TREASURE").replace("Metano", "Treasure").replace("metano", "treasure")

    for row in records:
        ids = list(map(str, row.get("sourceEntryIds", [])))
        if len(ids) != 1:
            raise ValueError(f"Une transformation générée doit viser une occurrence unique: {ids}")
        entry_id = ids[0]
        if entry_id not in expected_ids or entry_id in found_ids:
            raise ValueError(f"Occurrence générée inattendue/dupliquée pour alias de feuilles: {entry_id}")
        entry = source_entries.get(entry_id)
        locator = (entry or {}).get("sourceLocator", {})
        if (not entry or entry.get("sourceCategory") != "generated_build"
                or entry.get("groundSha256") != row.get("sourceGroundSha256")
                or row.get("rebrandingSource") != "verified_exact_generated_string_transform"
                or row.get("sourceBuildCommit") != PINNED_GENERATED_BUILD_COMMIT
                or row.get("sourceBuildScript") != locator.get("sourceBuildScript")
                or row.get("generatedOutput") != locator.get("generatedOutput")
                or row.get("sourceLot") != locator.get("sourceLot")):
            raise ValueError(f"Provenance de transformation générée incompatible pour {entry_id}")
        source_refs = set(map(str, row.get("sourceTileRefs", [])))
        target_refs = set(map(str, row.get("expectedTreasureTileRefs", [])))
        inventory_refs = set(map(str, entry.get("tileRefs", [])))
        if not source_refs or target_refs != inventory_refs or {rename(ref) for ref in source_refs} != target_refs:
            raise ValueError(f"Les TileRefs source/cible ne forment pas une transformation exacte pour {entry_id}")
        per_entry: dict[str, dict[str, Any]] = {}
        for source_name in sorted(source_refs, key=str.casefold):
            target_name = rename(source_name)
            if target_name == source_name:
                continue
            if target_name not in target_refs or target_name in per_entry:
                raise ValueError(f"Alias Treasure généré ambigu pour {entry_id}/{target_name}")
            per_entry[target_name] = {
                "sourceSheetName": source_name,
                "sourceGroundSha256": row["sourceGroundSha256"],
                "sourceBuildCommit": row["sourceBuildCommit"],
                "sourceBuildScript": row["sourceBuildScript"],
                "sourceLot": row["sourceLot"],
                "generatedOutput": row["generatedOutput"],
                "sourceTileRefs": sorted(source_refs),
                "expectedTreasureTileRefs": sorted(target_refs),
            }
        if not per_entry:
            raise ValueError(f"Aucun alias de feuille exact n’est requis par {entry_id}")
        aliases[entry_id] = per_entry
        found_ids.add(entry_id)

    if found_ids != expected_ids:
        raise ValueError(f"Périmètre de provenance pour alias de feuilles inattendu: {sorted(found_ids)}")
    return aliases


def main() -> None:
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    candidate = json.loads((CANDIDATE / "manifest.json").read_text(encoding="utf-8"))
    if candidate.get("mapCount") != EXPECTED_MAPS or candidate.get("sourceOccurrenceCount") != EXPECTED_SOURCE_OCCURRENCES:
        raise ValueError("Manifeste candidat inattendu.")
    source_entries = {row["entryId"]: row for row in inventory["entries"]}
    candidate_rows = {row["mapId"]: row for row in candidate["maps"]}
    occurrences = {row["entryId"]: row for row in candidate["sourceOccurrences"]}
    if len(candidate_rows) != EXPECTED_MAPS:
        raise ValueError(f"Map IDs candidats non uniques: {len(candidate_rows)}")

    if OUTPUT.exists():
        shutil.rmtree(OUTPUT)
    (OUTPUT / "Data/Ground").mkdir(parents=True)
    (OUTPUT / "Content/Tile").mkdir(parents=True)
    (OUTPUT / "Content/BG").mkdir(parents=True)

    resolver = AssetResolver()
    try:
        candidate_rebranding = candidate.get("sourcePayloadRebranding", {})
        if (not isinstance(candidate_rebranding, dict)
                or candidate_rebranding.get("migrationReportSha256") != resolver.migration_report_sha256):
            raise ValueError("Le rapport de migration utilisé par TileGuide diffère du Ground probe.")
        resolver.generated_tile_aliases = build_exact_generated_treasure_tile_aliases(
            candidate_rebranding, source_entries,
        )
        per_map_tile_assets: dict[str, dict[str, Asset]] = {}
        by_name: dict[str, dict[tuple[str, str], Asset]] = defaultdict(dict)
        per_map_background_assets: dict[str, dict[str, Asset]] = {}
        bg_by_name: dict[str, dict[str, Asset]] = defaultdict(dict)

        for map_id, map_row in candidate_rows.items():
            entry_id = map_row["sourceEntryId"]
            entry = source_entries[entry_id]
            raw_path = CANDIDATE / map_row["groundFile"]
            doc = json.loads(raw_path.read_text(encoding="utf-8-sig"))
            actual_refs = sheet_refs_from_ground(doc)
            if map_row.get("probeInputStatus") == "rebuilt_variant_hash_mismatch":
                # This is a separately labelled rebuild variant, not the Ground
                # represented by the source inventory's expected hash.
                declared_values = actual_refs
            elif entry.get("assetStatus") == "reconstructed_native_assets_from_source":
                declared_values = entry.get("reconstruction", {}).get("outputTileRefs", [])
            else:
                declared_values = entry.get("tileRefs", [])
            declared_refs = set(map(str, declared_values))
            if actual_refs != declared_refs:
                raise ValueError(
                    f"TileRefs de l’inventaire différents du Ground {entry_id}: "
                    f"dans Ground={sorted(actual_refs-declared_refs)}, "
                    f"dans inventaire={sorted(declared_refs-actual_refs)}"
                )
            per_map_tile_assets[map_id] = {}
            for ref in sorted(actual_refs, key=str.casefold):
                asset = resolver.resolve(entry, ref, "tile")
                per_map_tile_assets[map_id][ref] = asset
                by_name[ref.casefold()][(ref, asset.sha256)] = asset
            per_map_background_assets[map_id] = {}
            for ref in sorted(set(map(str, entry.get("backgroundRefs", []))), key=str.casefold):
                asset = resolver.resolve(entry, ref, "bg")
                per_map_background_assets[map_id][ref] = asset
                bg_by_name[ref.casefold()][asset.sha256] = asset

        alias_for_key: dict[tuple[str, str, str], str] = {}
        alias_rows: list[dict[str, Any]] = []
        for folded, variants in sorted(by_name.items()):
            original_names = {name for name, _ in variants}
            hashes = {digest for _, digest in variants}
            collision = len(original_names) > 1 or len(hashes) > 1
            for original, digest in sorted(variants):
                if collision:
                    name_fingerprint = hashlib.sha256(original.encode("utf-8")).hexdigest()[:4]
                    alias = f"{safe_slug(original.lower())}__v{digest[:8]}_n{name_fingerprint}"
                else:
                    alias = original
                alias_for_key[(folded, original, digest)] = alias
                asset = variants[(original, digest)]
                alias_rows.append({
                    "originalSheetName": original,
                    "sourceSha256": digest,
                    "aliasSheetName": alias,
                    "byteCount": asset.byte_count,
                    "source": asset.provenance,
                    "sourceSheetName": asset.source_sheet_name,
                    "sourceNameRebrandApplied": bool(asset.source_sheet_name and asset.source_sheet_name != original),
                    "sourceGroundSha256": asset.source_ground_sha256,
                    "sourceBuildCommit": asset.source_build_commit,
                    "sourceBuildScript": asset.source_build_script,
                    "sourceArchivePath": asset.source_archive_path,
                    "sourceArchiveSha256": asset.source_archive_sha256,
                    "sourceArchiveMember": asset.source_archive_member,
                    "sourceArchiveMemberCrc": asset.source_archive_member_crc,
                    "sourceArchiveCrcCheck": asset.source_archive_crc_check,
                    "sourceGroundMemberCrc": asset.source_ground_member_crc,
                    "collisionAliasApplied": collision,
                })

        generated_name_alias_rows = [
            row for row in alias_rows
            if row.get("source", "").startswith("approved-exact-generated-Treasure-name-alias:")
        ]
        branch_name_alias_rows = [
            row for row in alias_rows
            if row.get("source", "").startswith("approved-exact-Treasure-name-alias:")
        ]
        if (len(generated_name_alias_rows) != 40 or len(branch_name_alias_rows) != 2
                or any(row.get("sourceArchiveCrcCheck") != "PASS"
                       or row.get("sourceBuildCommit") != PINNED_GENERATED_BUILD_COMMIT
                       for row in generated_name_alias_rows)
                or any(not row.get("sourceNameRebrandApplied") for row in generated_name_alias_rows + branch_name_alias_rows)):
            raise ValueError(
                f"Aliases de noms Treasure exacts incomplets: générés={len(generated_name_alias_rows)}/40, "
                f"branche={len(branch_name_alias_rows)}/2"
            )

        for folded, variants in bg_by_name.items():
            if len(variants) > 1:
                raise ValueError(
                    f"Background .dir ambigu (contenu différent) pour {folded}: {sorted(variants)}"
                )

        tile_files: dict[str, dict[str, Any]] = {}
        bg_files: dict[str, dict[str, Any]] = {}
        for folded, variants in sorted(by_name.items()):
            for (original, digest), asset in sorted(variants.items()):
                alias = alias_for_key[(folded, original, digest)]
                relative = f"Content/Tile/{alias}.tile"
                destination = OUTPUT / relative
                if destination.exists():
                    if hashlib.sha256(destination.read_bytes()).hexdigest() != digest:
                        raise ValueError(f"Collision de sortie Tile: {relative}")
                else:
                    resolver.write_asset(asset, destination)
                actual_sha = hashlib.sha256(destination.read_bytes()).hexdigest()
                if actual_sha != digest:
                    raise ValueError(f"SHA .tile différent après copie: {relative}")
                tile_files[relative] = {"sha256": actual_sha, "bytes": destination.stat().st_size}

        for folded, variants in sorted(bg_by_name.items()):
            digest, asset = next(iter(variants.items()))
            name = asset.logical_name
            relative = f"Content/BG/{name}.dir"
            destination = OUTPUT / relative
            if destination.exists():
                if hashlib.sha256(destination.read_bytes()).hexdigest() != digest:
                    raise ValueError(f"Collision de sortie BG: {relative}")
            else:
                resolver.write_asset(asset, destination)
            actual_sha = hashlib.sha256(destination.read_bytes()).hexdigest()
            if actual_sha != digest:
                raise ValueError(f"SHA .dir différent après copie: {relative}")
            bg_files[relative] = {"sha256": actual_sha, "bytes": destination.stat().st_size}

        map_rows: list[dict[str, Any]] = []
        ground_files: dict[str, dict[str, Any]] = {}
        for map_id, map_row in sorted(candidate_rows.items()):
            source_entry = source_entries[map_row["sourceEntryId"]]
            source_path = CANDIDATE / map_row["groundFile"]
            document = json.loads(source_path.read_text(encoding="utf-8-sig"))
            aliases: dict[str, str] = {}
            for ref, asset in per_map_tile_assets[map_id].items():
                alias = alias_for_key[(ref.casefold(), ref, asset.sha256)]
                if alias != ref:
                    aliases[ref] = alias
            changed_frames = apply_sheet_aliases(document, aliases) if aliases else 0
            if aliases and changed_frames == 0:
                raise ValueError(f"Alias .tile non appliqué au Ground {map_id}")
            relative = f"Data/Ground/{map_id}.rsground"
            destination = OUTPUT / relative
            if aliases:
                raw = (json.dumps(document, ensure_ascii=False, separators=(",", ":")) + "\n").encode("utf-8")
                destination.write_bytes(raw)
            else:
                try:
                    os.link(source_path, destination)
                except OSError:
                    shutil.copy2(source_path, destination)
                raw = destination.read_bytes()
            output_sha = bytes_hash(raw)
            ground_files[relative] = {"sha256": output_sha, "bytes": len(raw)}
            object_doc = document.get("Object", {})
            version = str(document.get("Version", ""))
            tex_size = object_doc.get("TexSize")
            if not version or not isinstance(tex_size, int) or tex_size <= 0:
                raise ValueError(f"Version/TexSize invalide après assemblage: {map_id}")
            map_rows.append({
                **map_row,
                "groundFile": relative,
                "probeInputGroundSha256": map_row["outputGroundSha256"],
                "outputGroundSha256": output_sha,
                "groundVersion": version,
                "version": version,
                "texSize": tex_size,
                "tileRefs": sorted(sheet_refs_from_ground(document), key=str.casefold),
                "sourceTileRefs": sorted(per_map_tile_assets[map_id], key=str.casefold),
                "backgroundRefs": sorted(per_map_background_assets[map_id], key=str.casefold),
                "tileAliasChanges": aliases,
                "tileAliasFrameCount": changed_frames,
                "tileGuideValidation": "PENDING",
            })

        tile_nodes: dict[str, bytes] = {}
        for path in sorted((OUTPUT / "Content/Tile").glob("*.tile"), key=lambda p: p.stem.casefold()):
            folded = path.stem.casefold()
            if folded in {name.casefold() for name in tile_nodes}:
                raise ValueError(f"Collision casse dans l’index TileGuide: {path.stem}")
            tile_nodes[path.stem] = tile_index_node(path)
        index_bytes = encode_index(tile_nodes)
        (OUTPUT / "Content/Tile/index.idx").write_bytes(index_bytes)
        tile_index_sha = hashlib.sha256(index_bytes).hexdigest()

        files = {**ground_files, **tile_files, **bg_files,
                 "Content/Tile/index.idx": {"sha256": tile_index_sha, "bytes": len(index_bytes)}}
        status_counts = candidate.get("statusCounts", {})
        manifest = {
            "schemaVersion": 1,
            "name": "PMD Destiny — 246 Grounds / exact TileGuide dependency staging",
            "gameVersion": "0.8.12.0",
            "sourceOccurrenceCount": EXPECTED_SOURCE_OCCURRENCES,
            "mapCount": len(map_rows),
            "includedGroundOccurrences": len(map_rows),
            "blockedSourceAssetOccurrences": candidate.get("blockedSourceAssetOccurrences"),
            "generatedGroundOutputUnavailableOccurrences": candidate.get("generatedGroundOutputUnavailableOccurrences"),
            "unavailableGeneratedEntryIds": candidate.get("unavailableGeneratedEntryIds"),
            "statusCounts": status_counts,
            "sourcePayloadRebranding": candidate.get("sourcePayloadRebranding"),
            "notAnInstallableOverlay": True,
            "maps": map_rows,
            "sourceOccurrences": candidate["sourceOccurrences"],
            "assetAliases": alias_rows,
            "tileIndexNodeCount": len(tile_nodes),
            "tileIndexSha256": tile_index_sha,
            "files": files,
            "scope": "Ground + source TileSheet/background dependency validation; still no rendering or quest installation.",
        }
        (OUTPUT / "manifest.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
        print(json.dumps({
            "output": str(OUTPUT),
            "sourceOccurrences": EXPECTED_SOURCE_OCCURRENCES,
            "groundMaps": len(map_rows),
            "tileSheets": len(tile_files),
            "backgrounds": len(bg_files),
            "tileIndexNodes": len(tile_nodes),
            "mapsWithTileAliases": sum(bool(row["tileAliasChanges"]) for row in map_rows),
            "tileAliasNames": sum(row["collisionAliasApplied"] for row in alias_rows),
            "blockedOccurrences": candidate.get("blockedSourceAssetOccurrences"),
            "generatedGroundUnavailable": candidate.get("generatedGroundOutputUnavailableOccurrences"),
            "notAnInstallableOverlay": True,
        }, ensure_ascii=False, indent=2))
    finally:
        resolver.close()


if __name__ == "__main__":
    main()
