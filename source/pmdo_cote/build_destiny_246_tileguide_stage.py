#!/usr/bin/env python3
"""Assemble the 246-source Ground + exact asset staging for TileGuide.Load.

This is still a disposable validation input, not an installable 262-map Quest.
For every included source occurrence it resolves the exact referenced .tile and
background .dir from its source ZIP, branch commit, generated package, the five
source-grid reconstructions, or PMDO's base assets. When two source packages
reuse a tile name for different bytes, the staging aliases that sheet name in
that map's Frames and stores the original .tile bytes under a deterministic
unique name. No tile coordinates, geometry, collision, markers, or warps change.
The 13 source-asset-blocked occurrences and three unavailable generated Grounds
remain in the 262-row provenance register without substitutes.
"""
from __future__ import annotations

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

from source.pmdo_cote.installer_destiny_overlay import encode_index, tile_index_node  # noqa: E402


@dataclass(frozen=True)
class Asset:
    logical_name: str
    kind: str
    locator: str
    member: str
    sha256: str
    byte_count: int
    provenance: str


class AssetResolver:
    def __init__(self) -> None:
        self.zip_cache: dict[str, zipfile.ZipFile] = {}
        self.branch_trees: dict[str, list[dict[str, Any]]] = {}
        self.asset_cache: dict[tuple[str, str, str], Asset] = {}
        self.branch_tree_paths: dict[str, dict[str, Any]] = {}
        self.proto_archive: zipfile.ZipFile | None = None
        self.proto_members_by_hash: dict[str, str] = {}
        self.prototype_asset_names: set[str] = set()
        self.prototype_asset_members: dict[tuple[str, str], str] = {}
        self.blob_cache: dict[str, Path] = {}

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

        if asset is None:
            # The inventory marks base references explicitly where known. A
            # source package may also legitimately reuse a PMDO base asset.
            path = self._find_asset_in_dir(RUNTIME_BASE / "Content" / area, ref, extension)
            if path:
                asset = self._path_asset(ref, path, "PMDO-0.8.12-base-content")

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
                    "collisionAliasApplied": collision,
                })

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
