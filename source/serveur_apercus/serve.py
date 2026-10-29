#!/usr/bin/env python3
"""Serveur de prévisualisation des cartes PMDO et de leurs archives.

L'index combine deux dépôts épinglés : les pages et archives de `main` et les
instantanés Arena de 14 et 24 têtes distantes sont lus en lecture seule. Les
blobs médias sont récupérés à la demande depuis des clones Git partiels; aucun
contenu de branche n'est fusionné ou checkouté. Les pages d'origine restent
prioritaires; les ORA servent de secours statique seulement lorsque des rendus
ou animations référencés sont absents.

    python3 source/serveur_apercus/serve.py             # 0.0.0.0:8000
    python3 source/serveur_apercus/serve.py --port 8080

Les caches partiels sont dans `.cache/apercus-upstream/` et
`.cache/apercus-creation-upstream/` (ignorés par Git).
"""
from __future__ import annotations

import argparse
import base64
import difflib
import html
import json
import math
import mimetypes
import os
import posixpath
import re
import subprocess
import struct
import threading
import time
import unicodedata
import urllib.parse
import urllib.request
import zipfile
import zlib
from collections import OrderedDict
from dataclasses import dataclass
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from io import BytesIO
from pathlib import Path, PurePosixPath
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
UPSTREAM = "https://github.com/meromoonmeri/projet-pmdo.git"
UPSTREAM_NAME = "meromoonmeri/projet-pmdo"
UPSTREAM_COMMIT = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
UPSTREAM_CACHE = ROOT / ".cache" / "apercus-upstream"
CREATION_UPSTREAM = "https://github.com/meromoonmeri/projet-creation-pmdo.git"
CREATION_UPSTREAM_NAME = "meromoonmeri/projet-creation-pmdo"
CREATION_UPSTREAM_COMMIT = "8d2a5b8d9dadef254a0773bb36d633888148adcd"
CREATION_UPSTREAM_CACHE = ROOT / ".cache" / "apercus-creation-upstream"
MAX_REMOTE_BLOB = 150 * 1024 * 1024
MAX_ARCHIVE_CACHE = 96 * 1024 * 1024

# Published ZIP names sometimes predate or abbreviate the title of their
# standalone gallery. These aliases are from the project folders/manifests.
ARCHIVE_PREVIEW_ALIASES = {
    "cote_metano_v2": "cote_v2",
    "cote_metano_v2_wrap_palette": "cote_v2",
    "guild_structures_v1": "structures_guilde_v1",
    "ice_arena_aurora_v1": "arene_glace_aurores_animees_v1",
    "zones_south_north_v3": "entrees_sud_nord_v3",
    "arene_boreales_v4": "boreales_animees_v4",
    "beach_extension_v2": "extension_plage_v2",
    "beach_layers_v1": "beach_calques_v1",
    "beach_network_v1": "reseau_plage_v1",
    "beach_sky_gradient_v3": "plages_ciels_v3",
    "boreales_frames_generees_v5": "boreales_generees_palette_v5",
    "boreales_ondulation_glace_v8": "arene_ondulation_glace_v8",
    "boreales_pmdsky_v7": "ciel_boreal_pmdsky_v7",
    "casino_network_v1": "casino_reseau_v1",
    "layouts_magenta_v1": "variantes_magenta_v1",
    "metano_png_import_v3": "metano_pixel_perfect",
    "mod_cliff_nord_jour": "cliff_nord_jour_anime_v1",
    "entree_vallon_fleuri_sud_nord_v1": "vallons_fleuris_v1",
    "fin_vallon_fleuri_sanctuaire_v1": "vallons_fleuris_v1",
    "entree_tour_temporelle_roche_noire_or_v1": "tour_temporelle_roche_noire_or_complet",
    "fin_tour_temporelle_roche_noire_or_v1": "tour_temporelle_roche_noire_or_complet",
}
PREVIEW_TITLE_OVERRIDES = {
    "apercu_vallons_fleuris_v1.html": "Vallons Fleuris — FVF1 & EVF1",
    "apercu_tour_temporelle_roche_noire_or_complet.html": "Tour Temporelle — Roche Noire & Or (V1 · complet et animé)",
    "apercu_entree_tour_temporelle_sud_nord_v2.html": "Tour Temporelle — Entrée Noir & Or Prismatique (V2)",
    "apercu_fin_tour_temporelle_noire_or_v2.html": "Tour Temporelle — Sommet Noir & Or Prismatique (V2)",
    "apercu_faille_spatiale_palkia_pmdo.html": "Faille Spatiale — Palkia (FSE1, FSA0, FSA1)",
    "renders/zone_guilde_treehouse_v3/index.html": "ZGT3 — Village arboricole de guilde",
    "renders/zone_guilde_treehouse_v4/index.html": "Village arboricole — aperçu généré 8 px",
}
PREVIEW_NOTICES = {
    "apercu_vallons_fleuris_v1.html": "Secours OpenRaster : les calques et phases manquants reçoivent un rendu statique. Les médias animés présents dans la page source restent servis.",
    "apercu_entree_tour_temporelle_sud_nord_v2.html": "Secours OpenRaster : première frame et composite disponibles; les séquences animées complètes de la V2 sont absentes.",
    "apercu_fin_tour_temporelle_noire_or_v2.html": "Secours OpenRaster : les trois aperçus WebP manquants utilisent des calques/composites statiques; les animations complètes de la V2 sont absentes. La V1 est aussi dans la galerie.",
    "apercu_tour_temporelle_roche_noire_or_complet.html": "Les rendus WebP animés ETT1/FTT1 et leurs ORA restent disponibles. Deux images de revue associées à CLR1 manquent dans cet instantané.",
    "apercu_faille_spatiale_palkia_pmdo.html": "FSE1 et FSA1 ont un composite statique; leurs calques d’animation manquent. FSA0 n’a pas de composite vérifié dans l’instantané.",
}
ZONE_CODE_PREVIEWS = {
    "EAZ1": "entree_zone_zero",
    "RAZ1": "route_zone_zero_1",
    "RAZ2": "route_zone_zero_2",
    "RAZ3": "route_zone_zero_3",
    "EAF1": "entree_zone_zero_fleurie",
    "RAF1": "route_zone_zero_fleurie_1",
    "RAF2": "route_zone_zero_fleurie_2",
    "RAF3": "route_zone_zero_fleurie_3",
}

# GitHub's project archive omits the large PNG/ZIP/HTML blobs. Resolve them by
# blob id in a blobless clone, one request at a time, instead of copying 6+ GB.
@dataclass(frozen=True)
class Blob:
    path: str
    sha: str
    size: int
    commit: str = UPSTREAM_COMMIT
    source_ref: str = "main"
    source_date: str = ""
    source_repo: str = UPSTREAM_NAME


class UpstreamError(RuntimeError):
    pass


class UpstreamRepository:
    """Read-only, blobless views over the two repositories that contain maps."""

    def __init__(self, cache_dir: Path = UPSTREAM_CACHE) -> None:
        self.cache_dir = Path(cache_dir)
        self.source_specs: dict[str, dict[str, Any]] = {
            UPSTREAM_NAME: {
                "key": "pmdo",
                "short": "projet-pmdo",
                "url": UPSTREAM,
                "base_commit": UPSTREAM_COMMIT,
                "cache_dir": self.cache_dir,
                "catalog": "branch_catalog.json",
            },
            CREATION_UPSTREAM_NAME: {
                "key": "creation",
                "short": "projet-creation-pmdo",
                "url": CREATION_UPSTREAM,
                "base_commit": CREATION_UPSTREAM_COMMIT,
                "cache_dir": CREATION_UPSTREAM_CACHE,
                "catalog": "branch_catalog_creation.json",
            },
        }
        self.source_names = {spec["key"]: name for name, spec in self.source_specs.items()}
        self._source_cache_dirs: dict[str, Path] = {UPSTREAM_NAME: self.cache_dir}
        self._git_lock = threading.RLock()
        self.files: dict[str, Blob] = {}
        self.file_variants: dict[str, list[Blob]] = {}
        self.previews: list[Blob] = []
        self._preview_keys: set[tuple[str, str, str, str]] = set()
        self.archives: list[Blob] = []
        self._archive_keys: set[tuple[str, str, str]] = set()
        self.archive_by_id: dict[str, Blob] = {}
        self.archive_id_by_path: dict[str, str] = {}
        self.archive_id_by_source_path: dict[tuple[str, str], str] = {}
        self.archive_preview: dict[str, tuple[Blob | None, float]] = {}
        self.related_layer_archive: dict[str, str] = {}
        self.branch_sources: list[dict[str, Any]] = []
        self.branch_head_counts: dict[str, int] = {}
        self._known_commits: dict[str, set[str]] = {
            name: {str(spec["base_commit"])} for name, spec in self.source_specs.items()
        }
        self._commit_info: dict[tuple[str, str], tuple[str, str]] = {
            (UPSTREAM_NAME, UPSTREAM_COMMIT): ("main", ""),
            (CREATION_UPSTREAM_NAME, CREATION_UPSTREAM_COMMIT): ("main", ""),
        }
        self._fetched_commits: set[tuple[str, str]] = {(UPSTREAM_NAME, UPSTREAM_COMMIT)}
        self._dynamic_blob_cache: dict[tuple[str, str, str], Blob | None] = {}
        self._virtual_archive_cache: dict[tuple[str, str, str], LoadedArchive] = {}
        self._virtual_composite_cache: dict[tuple[str, str, str], bytes] = {}
        self.commit = UPSTREAM_COMMIT
        self.index_errors: list[str] = []

        # The remote main-tree index is an enhancement, not a prerequisite for
        # rendering the already-pinned Arena branch catalogs stored locally.
        # Keep those previews visible even when GitHub's API is unavailable.
        try:
            self._open_partial_clone()
        except (UpstreamError, OSError, subprocess.SubprocessError) as exc:
            self.index_errors.append(f"Clone partiel : {exc}")
            print(f"ATTENTION — clone partiel indisponible : {exc}", flush=True)
        try:
            self._load_index()
        except (UpstreamError, OSError, subprocess.SubprocessError) as exc:
            self.index_errors.append(f"Index principal : {exc}")
            print(
                "ATTENTION — index principal indisponible; poursuite avec les catalogues Arena locaux : "
                f"{exc}",
                flush=True,
            )
        self._load_branch_catalog()
        self._match_archive_previews()

    @staticmethod
    def _run_git_at(cache_dir: Path, args: list[str], timeout: int = 180) -> bytes:
        result = subprocess.run(
            ["git", "-C", str(cache_dir), *args],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
        )
        if result.returncode:
            message = result.stderr.decode("utf-8", "replace").strip()
            raise UpstreamError(message or f"git a échoué ({result.returncode})")
        return result.stdout

    def _run_git(self, args: list[str], timeout: int = 180) -> bytes:
        return self._run_git_at(self.cache_dir, args, timeout)

    def _ensure_source_cache(self, source_repo: str) -> Path:
        spec = self.source_specs.get(source_repo)
        if spec is None:
            raise UpstreamError(f"Dépôt source non catalogué : {source_repo}")
        cache_dir = Path(self._source_cache_dirs.get(source_repo, spec["cache_dir"]))
        cache_dir.parent.mkdir(parents=True, exist_ok=True)
        if not (cache_dir / ".git").exists():
            if cache_dir.exists() and any(cache_dir.iterdir()):
                raise UpstreamError(f"Le cache {cache_dir} existe mais n'est pas un clone Git.")
            result = subprocess.run(
                ["git", "clone", "--filter=blob:none", "--no-checkout", "--depth", "1",
                 "--quiet", str(spec["url"]), str(cache_dir)],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=180,
            )
            if result.returncode:
                message = result.stderr.decode("utf-8", "replace").strip()
                raise UpstreamError(f"Clone partiel de {source_repo} impossible : {message}")
        self._source_cache_dirs[source_repo] = cache_dir
        return cache_dir

    def _ensure_commit(self, source_repo: str, commit: str) -> Path:
        cache_dir = self._ensure_source_cache(source_repo)
        key = (source_repo, commit)
        if key in self._fetched_commits:
            return cache_dir
        with self._git_lock:
            check = subprocess.run(
                ["git", "-C", str(cache_dir), "cat-file", "-e", f"{commit}^{{commit}}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=30,
            )
            if check.returncode:
                result = subprocess.run(
                    ["git", "-C", str(cache_dir), "fetch", "--filter=blob:none", "--depth", "1",
                     "--quiet", "origin", commit],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=180,
                )
                if result.returncode:
                    message = result.stderr.decode("utf-8", "replace").strip()
                    raise UpstreamError(
                        f"Récupération de {source_repo}@{commit[:7]} impossible : {message}"
                    )
                check = subprocess.run(
                    ["git", "-C", str(cache_dir), "cat-file", "-e", f"{commit}^{{commit}}"],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=30,
                )
                if check.returncode:
                    raise UpstreamError(f"Commit source introuvable : {source_repo}@{commit[:7]}")
            self._fetched_commits.add(key)
        return cache_dir

    def _open_partial_clone(self) -> None:
        cache_dir = self._ensure_source_cache(UPSTREAM_NAME)
        check = subprocess.run(
            ["git", "-C", str(cache_dir), "cat-file", "-e", f"{UPSTREAM_COMMIT}^{{commit}}"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=30,
        )
        if check.returncode:
            result = subprocess.run(
                ["git", "-C", str(cache_dir), "fetch", "--filter=blob:none", "--depth", "1",
                 "--quiet", "origin", UPSTREAM_COMMIT],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=180,
            )
            if result.returncode:
                message = result.stderr.decode("utf-8", "replace").strip()
                raise UpstreamError(f"Impossible de récupérer le commit source {UPSTREAM_COMMIT[:7]} : {message}")
        self._run_git(["cat-file", "-e", f"{UPSTREAM_COMMIT}^{{commit}}"], timeout=30)
        self._fetched_commits.add((UPSTREAM_NAME, UPSTREAM_COMMIT))
        print(f"Source principale : {UPSTREAM_NAME}@{UPSTREAM_COMMIT[:7]} (clone partiel)", flush=True)

    def _register_blob(self, blob: Blob, prefer: bool = False) -> bool:
        variants = self.file_variants.setdefault(blob.path, [])
        key = (blob.source_repo, blob.commit, blob.sha)
        if any((item.source_repo, item.commit, item.sha) == key for item in variants):
            if prefer:
                self.files[blob.path] = blob
            return False
        variants.append(blob)
        if prefer or blob.path not in self.files:
            self.files[blob.path] = blob
        return True

    def _add_preview(self, blob: Blob) -> bool:
        key = (blob.path, blob.source_repo, blob.commit, blob.sha)
        if key in self._preview_keys:
            return False
        self._preview_keys.add(key)
        self.previews.append(blob)
        return True

    def _load_index(self) -> None:
        # GitHub's REST tree endpoint provides the pinned main tree without
        # downloading the source media into this repository.
        cache_file = self.cache_dir.parent / f"{UPSTREAM_COMMIT}.tree.json"
        data: dict[str, Any] | None = None
        if cache_file.is_file():
            try:
                cached = json.loads(cache_file.read_text(encoding="utf-8"))
                if cached.get("sha") == UPSTREAM_COMMIT and isinstance(cached.get("tree"), list):
                    data = cached
            except (OSError, ValueError):
                data = None
        if data is None:
            url = f"https://api.github.com/repos/{UPSTREAM_NAME}/git/trees/{UPSTREAM_COMMIT}?recursive=1"
            request = urllib.request.Request(
                url,
                headers={"Accept": "application/vnd.github+json", "User-Agent": "PMDO-map-preview"},
            )
            try:
                with urllib.request.urlopen(request, timeout=60) as response:
                    data = json.load(response)
            except Exception as exc:
                raise UpstreamError(f"Index GitHub indisponible : {exc}") from exc
            if data.get("truncated"):
                raise UpstreamError("GitHub a tronqué l’index source; aucun catalogue partiel ne sera affiché.")
            try:
                cache_file.write_text(json.dumps(data, separators=(",", ":")), encoding="utf-8")
            except OSError:
                pass

        for item in data.get("tree", []):
            if item.get("type") != "blob" or not item.get("path") or not item.get("sha"):
                continue
            path = str(item["path"])
            try:
                size = int(item.get("size", 0))
            except (TypeError, ValueError):
                size = 0
            blob = Blob(path=path, sha=str(item["sha"]), size=size, source_repo=UPSTREAM_NAME)
            self._register_blob(blob, prefer=True)
            if "/" not in path and path.startswith("apercu_") and path.lower().endswith(".html"):
                self._add_preview(blob)
            if path.lower().endswith(".zip"):
                self.archives.append(blob)
                self._register_archive(blob)

    def _register_archive(self, blob: Blob) -> str:
        source_path = (blob.source_repo, blob.path)
        existing = self.archive_id_by_source_path.get(source_path)
        if existing:
            current = self.archive_by_id.get(existing)
            if current and current.sha == blob.sha:
                return existing
        archive_id = blob.sha
        if archive_id in self.archive_by_id:
            source_key = str(self.source_specs.get(blob.source_repo, {}).get("key", "source"))
            archive_id = f"{blob.sha}-{source_key}-{blob.commit[:7]}-{len(self.archive_by_id):04d}"
            while archive_id in self.archive_by_id:
                archive_id += "x"
        self.archive_by_id[archive_id] = blob
        self.archive_id_by_source_path[source_path] = archive_id
        self.archive_id_by_path.setdefault(blob.path, archive_id)
        return archive_id

    def _load_branch_catalog(self) -> None:
        catalog_dir = ROOT / "source" / "serveur_apercus"
        for source_repo, spec in self.source_specs.items():
            catalog_path = catalog_dir / str(spec["catalog"])
            try:
                catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
            except (OSError, ValueError) as exc:
                print(f"Index Arena de {source_repo} ignoré : {exc}", flush=True)
                continue
            if catalog.get("sourceRepo") != source_repo or catalog.get("baseCommit") != spec["base_commit"]:
                print(f"Index Arena de {source_repo} ignoré : dépôt ou commit de base incohérent.", flush=True)
                continue
            branches = catalog.get("branches", [])
            if not isinstance(branches, list):
                continue
            try:
                self.branch_head_counts[source_repo] = int(catalog.get("headCount", len(branches)))
            except (TypeError, ValueError):
                self.branch_head_counts[source_repo] = len(branches)

            selected_preview_paths: set[str] = set()
            selected_archive_paths: set[str] = set()
            for branch in sorted(
                (item for item in branches if isinstance(item, dict)),
                key=lambda item: str(item.get("date", "")),
                reverse=True,
            ):
                if not isinstance(branch, dict):
                    continue
                commit = str(branch.get("commit", ""))
                ref = str(branch.get("ref", ""))
                if ref.startswith("refs/heads/arena/"):
                    ref = ref[len("refs/heads/"):]
                date = str(branch.get("date", ""))
                if not re.fullmatch(r"[0-9a-f]{40}", commit) or not ref.startswith("arena/"):
                    continue
                self._known_commits[source_repo].add(commit)
                self._commit_info[(source_repo, commit)] = (ref, date)
                preview_count = archive_count = asset_count = zip_count = ora_count = 0
                entries_by_kind = (
                    ("preview", branch.get("previews", [])),
                    ("extraPreview", branch.get("extraPreviews", [])),
                    ("archive", branch.get("archives", [])),
                    ("asset", branch.get("assets", [])),
                )
                for kind, entries in entries_by_kind:
                    if not isinstance(entries, list):
                        continue
                    for item in entries:
                        if not isinstance(item, dict):
                            continue
                        path, sha = item.get("path"), item.get("sha")
                        if not isinstance(path, str) or not isinstance(sha, str) or not re.fullmatch(r"[0-9a-f]{40}", sha):
                            continue
                        pure_path = PurePosixPath(path)
                        if (pure_path.is_absolute() or "\\" in path
                                or any(part in {"", ".", ".."} for part in path.split("/"))):
                            continue
                        if kind == "preview" and ("/" in path or not path.startswith("apercu_") or not path.casefold().endswith(".html")):
                            continue
                        if kind == "extraPreview" and (not path.startswith("renders/") or not path.casefold().endswith(".html")):
                            continue
                        if kind == "archive" and not path.casefold().endswith((".zip", ".ora")):
                            continue
                        if kind == "asset" and (
                            path.casefold().endswith(".zip")
                            or source_repo == CREATION_UPSTREAM_NAME and path.casefold().endswith(".ora")
                        ):
                            continue
                        try:
                            size = int(item.get("size", 0))
                        except (TypeError, ValueError):
                            continue
                        blob = Blob(
                            path=path,
                            sha=sha,
                            size=size,
                            commit=commit,
                            source_ref=ref,
                            source_date=date,
                            source_repo=source_repo,
                        )
                        is_new_variant = self._register_blob(blob)
                        if kind in {"preview", "extraPreview"}:
                            # The newest branch snapshot wins within each
                            # repository; equal bytes to that repository's main
                            # page do not need a duplicate gallery card.
                            if path not in selected_preview_paths:
                                selected_preview_paths.add(path)
                                identical = any(
                                    existing.path == path and existing.source_repo == source_repo and existing.sha == sha
                                    for existing in self.previews
                                )
                                if not identical and self._add_preview(blob):
                                    preview_count += 1
                        elif kind == "archive":
                            if path not in selected_archive_paths:
                                selected_archive_paths.add(path)
                                source_id = self.archive_id_by_source_path.get((source_repo, path))
                                current = self.archive_by_id.get(source_id) if source_id else None
                                archive_key = (source_repo, path, sha)
                                if archive_key not in self._archive_keys and (current is None or current.sha != sha):
                                    self._archive_keys.add(archive_key)
                                    self.archives.append(blob)
                                    self._register_archive(blob)
                                    archive_count += 1
                                    if path.casefold().endswith(".ora"):
                                        ora_count += 1
                                    else:
                                        zip_count += 1
                        elif is_new_variant:
                            asset_count += 1

                if preview_count or archive_count or asset_count:
                    self.branch_sources.append({
                        "sourceRepo": source_repo,
                        "repoLabel": spec["short"],
                        "ref": ref,
                        "commit": commit,
                        "date": date,
                        "previews": preview_count,
                        "archives": archive_count,
                        "zips": zip_count,
                        "oras": ora_count,
                        "assets": asset_count,
                    })

        self.previews.sort(key=lambda blob: (blob.path.casefold(), blob.source_repo, blob.commit))
        self.archives.sort(key=lambda blob: (blob.path.casefold(), blob.source_repo, blob.commit))
        for source_repo in self.source_specs:
            rows = [item for item in self.branch_sources if item["sourceRepo"] == source_repo]
            if rows:
                print(
                    f"Branches Arena ({source_repo}) : "
                    f"{sum(item['previews'] for item in rows)} aperçus, "
                    f"{sum(item['zips'] for item in rows)} ZIP, "
                    f"{sum(item['oras'] for item in rows)} ORA et "
                    f"{sum(item['assets'] for item in rows)} ressources référencées.",
                    flush=True,
                )

    def source_context(self, query: str = "", referer: str = "") -> tuple[str, str] | None:
        for candidate in (query, urllib.parse.urlsplit(referer).query if referer else ""):
            params = urllib.parse.parse_qs(candidate, keep_blank_values=False)
            source_key = next(iter(params.get("__repo", [])), "")
            commit = next(iter(params.get("__commit", [])), "").lower()
            source_repo = self.source_names.get(source_key)
            if (source_repo and re.fullmatch(r"[0-9a-f]{40}", commit)
                    and commit in self._known_commits.get(source_repo, set())):
                return source_repo, commit
        return None

    def _blob_for_context(self, path: str, context: tuple[str, str]) -> Blob | None:
        source_repo, commit = context
        for blob in self.file_variants.get(path, []):
            if blob.source_repo == source_repo and blob.commit == commit:
                return blob
        if source_repo not in self.source_specs or commit not in self._known_commits.get(source_repo, set()):
            return None
        if (not path or path.startswith(("/", ".cache/", ".git/")) or "\\" in path
                or ".git" in PurePosixPath(path).parts
                or any(part in {"", ".", ".."} for part in path.split("/"))):
            return None
        key = (source_repo, commit, path)
        if key in self._dynamic_blob_cache:
            return self._dynamic_blob_cache[key]
        cache_dir = self._ensure_commit(source_repo, commit)
        with self._git_lock:
            object_spec = f"{commit}:{path}"
            check = subprocess.run(
                ["git", "-C", str(cache_dir), "cat-file", "-e", object_spec],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=30,
            )
            if check.returncode:
                self._dynamic_blob_cache[key] = None
                return None
            object_type = subprocess.run(
                ["git", "-C", str(cache_dir), "cat-file", "-t", object_spec],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=30,
            )
            if object_type.returncode or object_type.stdout.strip() != b"blob":
                self._dynamic_blob_cache[key] = None
                return None
            sha_result = subprocess.run(
                ["git", "-C", str(cache_dir), "rev-parse", object_spec],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=30,
            )
            size_result = subprocess.run(
                ["git", "-C", str(cache_dir), "cat-file", "-s", object_spec],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=30,
            )
            if sha_result.returncode or size_result.returncode:
                self._dynamic_blob_cache[key] = None
                return None
            ref, date = self._commit_info.get((source_repo, commit), ("main", ""))
            blob = Blob(
                path=path,
                sha=sha_result.stdout.decode("ascii", "replace").strip(),
                size=int(size_result.stdout.strip() or b"0"),
                commit=commit,
                source_ref=ref,
                source_date=date,
                source_repo=source_repo,
            )
            self._register_blob(blob)
            self._dynamic_blob_cache[key] = blob
            return blob

    def resolve_blob(self, path: str, context: tuple[str, str] | None = None) -> Blob | None:
        if context:
            return self._blob_for_context(path, context)
        return self.files.get(path)

    def _ora_composite_fallback_for_path(
        self, path: str, context: tuple[str, str] | None = None,
    ) -> tuple[Blob, tuple[str, str]] | None:
        if context and context[0] != CREATION_UPSTREAM_NAME:
            return None
        target = "renders/fin_tour_temporelle_noire_or_v2/FTN2_trou_noir_spirale_10frames.webp"
        if path != target:
            return None
        archive_path = "renders/fin_tour_temporelle_noire_or_v2/FTN2_fin_tour_temporelle_noire_or_v2_calques.ora"
        blob = self.resolve_blob(archive_path, context)
        if blob is None and context is None:
            blob = self.files.get(archive_path)
        if blob is None:
            return None
        return blob, ("data/01_nuages_orage_rouges.png", "data/02_trou_noir_spirale.png")

    def _ora_fallback_for_path(
        self, path: str, context: tuple[str, str] | None = None,
    ) -> tuple[Blob, str] | None:
        if context and context[0] != CREATION_UPSTREAM_NAME:
            return None
        rules = (
            (
                "renders/fin_vallon_fleuri_sanctuaire_v1/",
                "renders/fin_vallon_fleuri_sanctuaire_v1/FVF1_fin_vallon_fleuri_sanctuaire_v1_calques.ora",
                "vallon",
            ),
            (
                "renders/entree_vallon_fleuri_sud_nord_v1/",
                "renders/entree_vallon_fleuri_sud_nord_v1/EVF1_entree_vallon_fleuri_sud_nord_v1_calques.ora",
                "vallon",
            ),
            (
                "renders/entree_tour_temporelle_sud_nord_v2/",
                "renders/entree_tour_temporelle_sud_nord_v2/ETT2_entree_tour_temporelle_v2_calques.ora",
                "ett2",
            ),
            (
                "renders/fin_tour_temporelle_noire_or_v2/",
                "renders/fin_tour_temporelle_noire_or_v2/FTN2_fin_tour_temporelle_noire_or_v2_calques.ora",
                "ftn2",
            ),
        )
        for prefix, archive_path, kind in rules:
            if not path.startswith(prefix):
                continue
            relative = path[len(prefix):]
            suffix = PurePosixPath(relative).suffix.casefold()
            member: str | None = None
            if kind == "vallon":
                if relative.startswith("layers/00_sol"):
                    member = "data/layer_00.png"
                elif relative.startswith("layers/01_decor"):
                    member = "data/layer_01.png"
                elif relative.startswith("animation/eau_metano_native/"):
                    member = "data/layer_02.png"
                elif relative.startswith("animation/rives_metano_native/"):
                    member = "data/layer_03.png"
                elif relative.startswith("animation/scintillements/"):
                    member = "data/layer_04.png"
                elif relative.startswith("review/") and suffix in {".png", ".webp", ".gif", ".jpg", ".jpeg"}:
                    member = "mergedimage.png"
            elif kind == "ett2":
                match = re.match(r"ETT2_(\d{2})_[a-z0-9_]+(?:_f\d+)?\.png$", PurePosixPath(relative).name, re.I)
                if match:
                    member = f"data/layer{int(match.group(1)):02d}.png"
                elif relative.startswith("review/") and suffix in {".png", ".webp", ".gif", ".jpg", ".jpeg"}:
                    member = "mergedimage.png"
            elif kind == "ftn2":
                static_layers = {
                    "ftn2_nuages_orage_rouges_10frames.webp": "data/01_nuages_orage_rouges.png",
                    "ftn2_trou_noir_seul_10frames.webp": "data/02_trou_noir_spirale.png",
                    "ftn2_trou_noir_spirale_10frames.webp": "mergedimage.png",
                }
                member = static_layers.get(PurePosixPath(relative).name.casefold())
                match = re.match(r"FTN2_(\d{2})_([a-z0-9_]+?)(?:_f\d+)?\.png$", PurePosixPath(relative).name, re.I)
                if member is None and match:
                    layer_index = int(match.group(1)) + 1
                    if 1 <= layer_index <= 14:
                        member = f"data/{layer_index:02d}_{match.group(2).lower()}.png"
                elif member is None and relative.startswith("review/") and suffix in {".png", ".webp", ".gif", ".jpg", ".jpeg"}:
                    member = "mergedimage.png"
            if member:
                blob = self.resolve_blob(archive_path, context)
                if blob is None and context is None:
                    blob = self.files.get(archive_path)
                if blob:
                    return blob, member
        return None

    def has(self, path: str, context: tuple[str, str] | None = None) -> bool:
        if self.resolve_blob(path, context) is not None:
            return True
        return (
            self._ora_composite_fallback_for_path(path, context) is not None
            or self._ora_fallback_for_path(path, context) is not None
        )

    def get_virtual_asset(
        self, path: str, context: tuple[str, str] | None = None,
    ) -> tuple[bytes, str] | None:
        composite = self._ora_composite_fallback_for_path(path, context)
        if composite is not None:
            blob, members = composite
            key = (blob.source_repo, blob.commit, blob.sha)
            cached = self._virtual_composite_cache.get(key)
            if cached is None:
                try:
                    archive = self.get_virtual_archive(blob)
                    cached = _compose_png_rgba(archive.read(members[0]), archive.read(members[1]))
                except (KeyError, ValueError, UpstreamError):
                    archive = self.get_virtual_archive(blob)
                    cached = archive.read("mergedimage.png", max_size=32 * 1024 * 1024)
                self._virtual_composite_cache[key] = cached
            return cached, "image/png"

        fallback = self._ora_fallback_for_path(path, context)
        if fallback is None:
            return None
        blob, member = fallback
        key = (blob.source_repo, blob.commit, blob.sha)
        with self._git_lock:
            archive = self._virtual_archive_cache.get(key)
            if archive is None:
                archive = LoadedArchive(blob, self.get_blob(blob))
                self._virtual_archive_cache[key] = archive
        try:
            return archive.read(member, max_size=32 * 1024 * 1024), mime_type(member)
        except KeyError:
            return None

    def get(self, path: str, context: tuple[str, str] | None = None) -> bytes:
        blob = self.resolve_blob(path, context)
        if blob is not None:
            return self.get_blob(blob)
        virtual = self.get_virtual_asset(path, context)
        if virtual is not None:
            return virtual[0]
        raise KeyError(path)

    def get_blob(self, blob: Blob) -> bytes:
        if blob.size > MAX_REMOTE_BLOB:
            raise UpstreamError(f"Fichier trop volumineux pour l'aperçu à la demande : {blob.path}")
        with self._git_lock:
            cache_dir = self._ensure_commit(blob.source_repo, blob.commit)
            result = subprocess.run(
                ["git", "-C", str(cache_dir), "show", f"{blob.commit}:{blob.path}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=300,
            )
        if result.returncode:
            message = result.stderr.decode("utf-8", "replace").strip()
            raise UpstreamError(f"Restauration de {blob.path} impossible : {message}")
        return result.stdout

    def get_virtual_archive(self, blob: Blob) -> LoadedArchive:
        key = (blob.source_repo, blob.commit, blob.sha)
        with self._git_lock:
            archive = self._virtual_archive_cache.get(key)
            if archive is None:
                archive = LoadedArchive(blob, self.get_blob(blob))
                self._virtual_archive_cache[key] = archive
            return archive

    def _match_archive_previews(self) -> None:
        root_previews = [
            item for item in self.previews
            if "/" not in item.path and item.path.startswith("apercu_") and item.path.casefold().endswith(".html")
        ]
        for archive_id, blob in self.archive_by_id.items():
            preferred = [item for item in root_previews if item.source_repo == blob.source_repo]
            candidates = preferred or root_previews
            preview_by_slug = {
                item.path[len("apercu_"):-len(".html")]: item.path for item in candidates
            }
            preview_slugs = list(preview_by_slug)
            preview_path, score = match_preview(blob.path, preview_by_slug, preview_slugs)

            if not preview_path:
                stem = Path(blob.path).stem
                alias_candidates = _strip_archive_suffix(stem) + list(reversed(PurePosixPath(blob.path).parts[:-1]))
                for candidate in alias_candidates:
                    alias = ARCHIVE_PREVIEW_ALIASES.get(candidate)
                    if alias and alias in preview_by_slug:
                        preview_path, score = preview_by_slug[alias], 0.98
                        break
            if not preview_path:
                for part in PurePosixPath(blob.path).parts:
                    alias = ZONE_CODE_PREVIEWS.get(part.upper())
                    if alias and alias in preview_by_slug:
                        preview_path, score = preview_by_slug[alias], 0.98
                        break

            preview_blob = None
            if preview_path:
                exact = [item for item in candidates if item.path == preview_path]
                preview_blob = next((item for item in exact if item.commit == blob.commit), None)
                if preview_blob is None:
                    preview_blob = next((item for item in exact if item.source_ref.startswith("arena/")), None)
                if preview_blob is None and exact:
                    preview_blob = exact[0]
            if preview_blob is None and preview_path and preferred:
                # A branch may contain the archive while its closest page was
                # catalogued in the other repository; retain the path only if
                # no same-repository page is available.
                other = [item for item in root_previews if item.path == preview_path]
                preview_blob = other[0] if other else None
            self.archive_preview[archive_id] = (preview_blob, score)

            # Pair PMDO Ground ZIPs with their lossless layer ZIP in the same
            # source snapshot, not merely another repository's similarly named file.
            stem = Path(blob.path).stem
            suffixes = ("_projet_pmdo_0812", "_projet_pmdo", "_pmdo_0812", "_PMDO")
            for suffix in suffixes:
                if stem.casefold().endswith(suffix.casefold()):
                    layer_path = str(PurePosixPath(blob.path).with_name(stem[:-len(suffix)] + "_calques_png_8px.zip"))
                    layer_id = self.archive_id_by_source_path.get((blob.source_repo, layer_path))
                    if layer_id and layer_id != archive_id:
                        self.related_layer_archive[archive_id] = layer_id
                    break


def _source_key(source_repo: str) -> str:
    if source_repo == CREATION_UPSTREAM_NAME:
        return "creation"
    return "pmdo"


def _source_label(blob: Blob) -> str:
    spec = {
        UPSTREAM_NAME: "projet-pmdo",
        CREATION_UPSTREAM_NAME: "projet-creation-pmdo",
    }.get(blob.source_repo, blob.source_repo)
    if blob.source_ref.startswith("arena/"):
        branch = blob.source_ref.rsplit("/", 1)[-1][:8]
        return f"Branche Arena · {spec} · {branch}"
    return f"Dépôt principal · {spec}"


def _preview_url(blob: Blob) -> str:
    url = "/" + urllib.parse.quote(blob.path, safe="/")
    if blob.source_ref.startswith("arena/"):
        query = urllib.parse.urlencode({"__repo": _source_key(blob.source_repo), "__commit": blob.commit})
        return f"{url}?{query}"
    return url

def _patch_palkia_static_composite(content: str) -> str:
    """Keep the source viewer usable when it has only pose0 composites, no layers."""
    pose_pattern = re.compile(
        r"if\s*\(pose0Preview\)\s*\{\s*ctx\.drawImage\(pose0Preview, 0, 0, m\.width, m\.height\);\s*\}"
    )
    content, pose_count = pose_pattern.subn(
        "if (pose0Preview) { m._pose0Preview = pose0Preview; ctx.drawImage(pose0Preview, 0, 0, m.width, m.height); }",
        content,
        count=1,
    )
    collision_marker = "if (showCollisions && m.walk_grid) {"
    fallback_draw = (
        "if (!m.layers.some((L) => layerEnabled.get(`${m.id}:${L.slug}`) && L._img) && m._pose0Preview) {\n"
        "        ctx.drawImage(m._pose0Preview, 0, 0, m.width, m.height);\n"
        "      }\n\n      " + collision_marker
    )
    if pose_count:
        content = content.replace(collision_marker, fallback_draw, 1)
    status_pattern = re.compile(
        r"statusEl\.textContent = `✓ \$\{m\.layers\.length\} / \$\{m\.layers\.length\} calques temps réel prêts \(échelle 1:1\)`;"
    )
    content, _ = status_pattern.subn(
        "const loadedLayerCount = m.layers.filter((L) => Boolean(L._img)).length;\n"
        "      statusEl.textContent = loadedLayerCount === m.layers.length\n"
        "        ? `✓ ${loadedLayerCount} / ${m.layers.length} calques temps réel prêts (échelle 1:1)`\n"
        "        : loadedLayerCount === 0 && m._pose0Preview\n"
        "          ? 'Composite pose 0 affiché · calques et animation détaillée indisponibles'\n"
        "          : `Calques récupérés : ${loadedLayerCount} / ${m.layers.length} · animation partielle`;",
        content,
        count=1,
    )
    return content


def _prepare_remote_preview(path: str, content: bytes, source_repo: str) -> bytes:
    """Add a clear fallback notice; originals are otherwise served unchanged."""
    notice = PREVIEW_NOTICES.get(path) if source_repo == CREATION_UPSTREAM_NAME else None
    if not notice and path != "apercu_faille_spatiale_palkia_pmdo.html":
        return content
    text = content.decode("utf-8", "replace")
    if path == "apercu_faille_spatiale_palkia_pmdo.html":
        text = _patch_palkia_static_composite(text)
    if notice:
        banner = (
            '<aside role="note" data-pmdo-fallback="true" '
            'style="margin:10px;padding:10px 14px;border-left:4px solid #e3c77d;'
            'border-radius:8px;background:#24291ff2;color:#f2ead3;'
            'font:600 13px/1.5 system-ui,sans-serif">'
            '<strong>Mode de secours —</strong> ' + html.escape(notice) + '</aside>'
        )
        if 'data-pmdo-fallback="true"' not in text:
            body_pattern = re.compile(r"<body\b[^>]*>", re.I)
            text, count = body_pattern.subn(lambda match: match.group(0) + banner, text, count=1)
            if not count:
                text = banner + text
    return text.encode("utf-8")


def _ascii(value: str) -> str:
    value = unicodedata.normalize("NFKD", value)
    return "".join(ch for ch in value if not unicodedata.combining(ch)).casefold()


def _slug_tokens(value: str) -> set[str]:
    value = _ascii(value)
    tokens = re.findall(r"[a-z]+|\d+", value)
    stop = {
        "apercu", "calques", "calque", "png", "pack", "archive", "zip", "projet",
        "pmdo", "pm d o", "complet", "candidate", "export", "fichiers", "pngs",
        "8px", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
    }
    return {t for t in tokens if t not in stop and len(t) > 1}


def _strip_archive_suffix(stem: str) -> list[str]:
    suffixes = (
        "_calques_png_8px", "_calques_png", "_calques", "_projet_pmdo_0812",
        "_projet_pmdo", "_pmdo_0812", "_pmdo", "_complet", "_candidate",
        "_gifs", "_tilesheets", "_pack", "_archive",
    )
    variants = [stem]
    current = stem
    changed = True
    while changed:
        changed = False
        for suffix in suffixes:
            if current.casefold().endswith(suffix):
                current = current[:-len(suffix)].rstrip("_- ")
                if current and current not in variants:
                    variants.append(current)
                changed = True
                break
    return variants


def match_preview(archive_path: str, preview_by_slug: dict[str, str], preview_slugs: list[str]) -> tuple[str | None, float]:
    """Find a same-project standalone page, avoiding weak/ambiguous matches."""
    parts = archive_path.split("/")
    candidates: list[str] = []
    stem = Path(parts[-1]).stem
    candidates.extend(_strip_archive_suffix(stem))
    for parent in reversed(parts[:-1]):
        if parent.casefold() not in {"renders", "exports", "source", "archive", "archives"}:
            candidates.append(parent)

    for candidate in candidates:
        if candidate in preview_by_slug:
            return preview_by_slug[candidate], 1.0
        # Some published names use accents or differ only in separators.
        n_candidate = _ascii(candidate).replace("-", "_").replace(" ", "_")
        for slug, path in preview_by_slug.items():
            if _ascii(slug).replace("-", "_").replace(" ", "_") == n_candidate:
                return path, 0.99

    archive_token_sets = [_slug_tokens(c) for c in candidates]
    if not archive_token_sets:
        archive_token_sets = [_slug_tokens(stem)]
    best_path: str | None = None
    best_score = 0.0
    for slug in preview_slugs:
        preview_tokens = _slug_tokens(slug)
        if not preview_tokens:
            continue
        for candidate, candidate_tokens in zip(candidates or [stem], archive_token_sets):
            if not candidate_tokens:
                continue
            union = candidate_tokens | preview_tokens
            jaccard = len(candidate_tokens & preview_tokens) / len(union) if union else 0.0
            sequence = difflib.SequenceMatcher(None, _ascii(candidate), _ascii(slug)).ratio()
            score = 0.72 * jaccard + 0.28 * sequence
            if score > best_score:
                best_score, best_path = score, preview_by_slug[slug]
    if best_score >= 0.70:
        return best_path, best_score
    return None, best_score


def human_title(value: str) -> str:
    stem = Path(value).stem
    stem = re.sub(r"^apercu_", "", stem, flags=re.I)
    stem = stem.replace("_", " ").replace("-", " ")
    stem = re.sub(r"\bsud nord\b", "sud → nord", stem, flags=re.I)
    text = " ".join(word[:1].upper() + word[1:] for word in stem.split())
    replacements = {
        "Pmdo": "PMDO", "Pmd": "PMD", "Dtef": "DTEF", "Gba": "GBA", "Dsi": "DSi",
        "Pmdsky": "PMD Sky", "Metano": "Métano", "Sky": "Sky", "V1": "V1", "V2": "V2",
        "V3": "V3", "V4": "V4", "V5": "V5", "V6": "V6", "V7": "V7", "V8": "V8",
        "V9": "V9", "V10": "V10", "V11": "V11", "V12": "V12", "V13": "V13",
        "V14": "V14", "V15": "V15", "V16": "V16",
    }
    for old, new in replacements.items():
        text = re.sub(rf"\b{re.escape(old)}\b", new, text)
    return text or "Aperçu de carte"


def preview_title(path: str) -> str:
    if path in PREVIEW_TITLE_OVERRIDES:
        return PREVIEW_TITLE_OVERRIDES[path]
    pure_path = PurePosixPath(path)
    if pure_path.name.casefold() == "index.html":
        return human_title(pure_path.parent.name)
    return human_title(path)


def category_for_preview(path: str) -> str:
    pure_path = PurePosixPath(path)
    name = f"{pure_path.parent.name}_{pure_path.stem}" if pure_path.parent != PurePosixPath(".") else pure_path.stem
    slug = _ascii(name)
    if "entree" in slug or "entrees" in slug or "entry" in slug:
        return "Entrées"
    if "fin_" in slug or slug.startswith("fin"):
        return "Fins de donjon"
    if "arene" in slug or "arena" in slug:
        return "Arènes"
    if any(k in slug for k in ("donjon", "dungeon", "tour", "tower", "temporal", "temporel", "palkia", "domaine", "domain")):
        return "Donjons"
    if any(k in slug for k in ("zone", "route", "panorama", "falaises", "cote", "plage", "beach", "waterfall", "metano", "vallon", "plains")):
        return "Zones & lieux"
    return "Autres aperçus"


def category_for_archive(path: str) -> str:
    slug = _ascii(path)
    if path.casefold().endswith(".ora"):
        return "Sources OpenRaster (ORA)"
    if "projet_pmdo" in slug or "_pmdo" in slug:
        return "Projets PMDO"
    if "calques" in slug or "_pack" in slug:
        return "Calques & packs"
    if slug.startswith("exports/"):
        return "Exports"
    if slug.startswith("renders/"):
        return "Rendus"
    return "Autres archives"


def _format_bytes(size: int) -> str:
    if size >= 1024 ** 2:
        return f"{size / 1024 ** 2:.1f} Mo"
    if size >= 1024:
        return f"{size / 1024:.0f} Ko"
    return f"{size} o"


def build_catalog(repo: UpstreamRepository | None) -> dict[str, Any]:
    local_previews = sorted(ROOT.glob("apercu_*.html"), key=lambda p: p.name.casefold())
    local_paths = {p.name for p in local_previews}
    previews: list[dict[str, Any]] = []
    archive_items: list[dict[str, Any]] = []

    if repo:
        for blob in repo.previews:
            is_local = blob.path in local_paths
            is_branch = blob.source_ref.startswith("arena/")
            previews.append({
                "id": f"{blob.source_repo}@{blob.commit[:7]}:{blob.path}" if is_branch else blob.path,
                "path": blob.path,
                "title": preview_title(blob.path),
                "category": category_for_preview(blob.path),
                "bytes": blob.size,
                "sizeLabel": _format_bytes(blob.size),
                "url": _preview_url(blob),
                "source": "local" if is_local else "branch" if is_branch else "archive",
                "sourceLabel": _source_label(blob),
                "notice": PREVIEW_NOTICES.get(blob.path) if blob.source_repo == CREATION_UPSTREAM_NAME else None,
                "sudNord": "_sud_nord_" in blob.path,
            })

        for archive_id, blob in repo.archive_by_id.items():
            preview_blob, score = repo.archive_preview.get(archive_id, (None, 0.0))
            preview_path = preview_blob.path if preview_blob else None
            archive_format = "ORA" if blob.path.casefold().endswith(".ora") else "ZIP"
            archive_items.append({
                "id": archive_id,
                "path": blob.path,
                "name": Path(blob.path).name,
                "title": human_title(Path(blob.path).name),
                "category": category_for_archive(blob.path),
                "format": archive_format,
                "bytes": blob.size,
                "sizeLabel": _format_bytes(blob.size),
                "previewPath": preview_path,
                "previewUrl": _preview_url(preview_blob) if preview_blob else f"/archive-preview/{archive_id}",
                "previewArchiveId": repo.related_layer_archive.get(archive_id),
                "previewScore": round(score, 2),
                "downloadUrl": f"/archive-download/{archive_id}",
                "source": "branch" if blob.source_ref.startswith("arena/") else "main",
                "sourceLabel": _source_label(blob),
            })

    for path in local_previews:
        if repo and path.name in {b.path for b in repo.previews}:
            # The local page wins at the URL; metadata remains in the same row.
            continue
        previews.append({
            "id": path.name,
            "path": path.name,
            "title": human_title(path.name),
            "category": category_for_preview(path.name),
            "bytes": path.stat().st_size,
            "sizeLabel": _format_bytes(path.stat().st_size),
            "url": "/" + urllib.parse.quote(path.name, safe="/"),
            "source": "local",
            "sourceLabel": "Fichier local",
            "sudNord": "_sud_nord_" in path.name,
        })

    category_order = {"Entrées": 0, "Fins de donjon": 1, "Arènes": 2, "Donjons": 3, "Zones & lieux": 4, "Autres aperçus": 5}
    previews.sort(key=lambda item: (category_order.get(item["category"], 9), item["title"].casefold(), item["sourceLabel"]))
    branch_previews = sum(1 for blob in repo.previews if blob.source_ref.startswith("arena/")) if repo else 0
    branch_archives = sum(1 for blob in repo.archives if blob.source_ref.startswith("arena/")) if repo else 0
    branch_zips = sum(
        1 for blob in repo.archives
        if blob.source_ref.startswith("arena/") and blob.path.casefold().endswith(".zip")
    ) if repo else 0
    branch_oras = sum(
        1 for blob in repo.archives
        if blob.source_ref.startswith("arena/") and blob.path.casefold().endswith(".ora")
    ) if repo else 0
    repositories = []
    if repo:
        source_specs = getattr(repo, "source_specs", {})
        branch_head_counts = getattr(repo, "branch_head_counts", {})
        branch_sources = getattr(repo, "branch_sources", [])
        repositories = [
            {
                "repo": source_repo,
                "label": str(spec["short"]),
                "commit": str(spec["base_commit"]),
                "arenaHeads": branch_head_counts.get(source_repo, 0),
                "indexedBranches": sum(1 for row in branch_sources if row.get("sourceRepo") == source_repo),
            }
            for source_repo, spec in source_specs.items()
        ]
    return {
        "source": {
            "repo": UPSTREAM_NAME,
            "commit": UPSTREAM_COMMIT,
            "commitLabel": " · ".join(item["commit"][:7] for item in repositories),
            "repositories": repositories,
            "available": repo is not None,
            "branchSources": repo.branch_sources if repo else [],
            "indexFallback": bool(getattr(repo, "index_errors", [])) if repo else False,
            "note": "Deux dépôts sont consultés en lecture seule. Les aperçus et archives proviennent des instantanés Arena catalogués; aucune branche n’est fusionnée ni changée. Les médias sont récupérés à la demande.",
        },
        "previews": previews,
        "archives": archive_items,
        "counts": {
            "previews": len(previews),
            "archives": len(archive_items),
            "archivesWithPreview": sum(1 for item in archive_items if item["previewPath"] or item["previewArchiveId"]),
            "branchPreviews": branch_previews,
            "branchArchives": branch_archives,
            "branchZips": branch_zips,
            "branchOras": branch_oras,
            "branchAssets": sum(item.get("assets", 0) for item in repo.branch_sources) if repo else 0,
        },
    }


class LoadedArchive:
    def __init__(self, blob: Blob, payload: bytes) -> None:
        self.blob = blob
        self.payload = payload
        try:
            self.zip = zipfile.ZipFile(BytesIO(payload))
        except zipfile.BadZipFile as exc:
            kind = "OpenRaster" if blob.path.casefold().endswith(".ora") else "ZIP"
            raise UpstreamError(f"L'archive {blob.path} n'est pas un {kind} valide.") from exc
        self.lock = threading.RLock()
        self.members: dict[str, zipfile.ZipInfo] = {}
        for info in self.zip.infolist():
            if info.is_dir():
                continue
            normalized = safe_member_name(info.filename)
            if normalized:
                self.members[normalized] = info

    def read(self, normalized_name: str, max_size: int = 80 * 1024 * 1024) -> bytes:
        info = self.members.get(normalized_name)
        if info is None:
            raise KeyError(normalized_name)
        if info.file_size > max_size:
            raise UpstreamError(f"Fichier décompressé trop volumineux : {normalized_name}")
        with self.lock:
            return self.zip.read(info)

    def names(self) -> list[str]:
        return sorted(self.members)


def safe_member_name(name: str) -> str | None:
    name = name.replace("\\", "/")
    if name.startswith("/") or "\x00" in name:
        return None
    raw_parts = name.split("/")
    if any(part == ".." for part in raw_parts):
        return None
    normalized = posixpath.normpath(name)
    if normalized in {"", ".", ".."} or normalized.startswith("../"):
        return None
    # Refuse archive symlinks; preview files are regular files only.
    return normalized


class ArchiveStore:
    def __init__(self, repo: UpstreamRepository, max_bytes: int = MAX_ARCHIVE_CACHE) -> None:
        self.repo = repo
        self.max_bytes = max_bytes
        self._cache: OrderedDict[str, LoadedArchive] = OrderedDict()
        self._bytes = 0
        self._lock = threading.RLock()

    def get(self, archive_id: str) -> LoadedArchive:
        blob = self.repo.archive_by_id.get(archive_id)
        if blob is None:
            raise KeyError(archive_id)
        key = blob.sha
        with self._lock:
            cached = self._cache.get(key)
            if cached:
                self._cache.move_to_end(key)
                return cached
            payload = self.repo.get_blob(blob)
            loaded = LoadedArchive(blob, payload)
            self._cache[key] = loaded
            self._bytes += len(payload)
            while self._bytes > self.max_bytes and len(self._cache) > 1:
                _, old = self._cache.popitem(last=False)
                self._bytes -= len(old.payload)
                old.zip.close()
            return loaded


def _url_for_archive_member(archive_id: str, member: str) -> str:
    return f"/archive-content/{archive_id}/{urllib.parse.quote(member, safe='/')}"


def _choose_embedded_viewer(names: list[str]) -> str | None:
    html_names = [n for n in names if n.lower().endswith((".html", ".htm"))]
    if not html_names:
        return None

    def score(name: str) -> tuple[int, int, str]:
        base = PurePosixPath(name).name.casefold()
        if base == "apercu.html":
            rank = 100
        elif base.startswith("apercu_"):
            rank = 96
        elif base in {"viewer.html", "preview.html", "map-viewer.html"}:
            rank = 92
        elif base == "index.html":
            rank = 84
        elif "viewer" in base or "preview" in base:
            rank = 76
        else:
            rank = 10
        # Prefer a top-level viewer when multiple files have the same role.
        depth = name.count("/")
        return rank, -depth, name.casefold()

    selected = max(html_names, key=score)
    return selected if score(selected)[0] >= 70 else None


def _manifest_from_archive(archive: LoadedArchive) -> tuple[dict[str, Any] | None, str | None]:
    manifest_paths = [n for n in archive.names() if PurePosixPath(n).name.casefold() == "manifest.json"]
    manifest_paths.sort(key=lambda n: (n.count("/"), len(n), n.casefold()))
    for name in manifest_paths[:8]:
        try:
            raw = archive.read(name, max_size=2 * 1024 * 1024)
            parsed = json.loads(raw.decode("utf-8-sig"))
        except (ValueError, UnicodeDecodeError, UpstreamError, KeyError):
            continue
        if isinstance(parsed, dict):
            return parsed, name
    return None, None


def _path_templates_from_manifest(manifest: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    output: list[tuple[str, dict[str, Any]]] = []
    # Formats used by the 8-pixel map layer packs.
    for key in ("layer_order_bottom_to_top", "render_order", "layer_order", "order"):
        value = manifest.get(key)
        if not isinstance(value, list):
            continue
        for item in value:
            if isinstance(item, str) and ("/" in item or item.lower().endswith((".png", ".webp", ".gif"))):
                output.append((item, {}))
            elif isinstance(item, dict):
                path = item.get("file") or item.get("path") or item.get("src")
                if isinstance(path, str):
                    output.append((path, item))
        if output:
            return output

    layers = manifest.get("layers")
    if isinstance(layers, list):
        for item in layers:
            if isinstance(item, str):
                output.append((item, {}))
            elif isinstance(item, dict):
                path = item.get("file") or item.get("path") or item.get("src")
                if isinstance(path, str):
                    output.append((path, item))
        if output:
            return output
    return output


def _metadata_records(obj: Any, trail: tuple[str, ...] = ()) -> list[tuple[tuple[str, ...], dict[str, Any]]]:
    records: list[tuple[tuple[str, ...], dict[str, Any]]] = []
    if isinstance(obj, dict):
        if any(k in obj for k in ("frame_length_ticks", "frame_ticks", "frame_ms", "ticks", "durations_ms", "duration_ms")):
            records.append((trail, obj))
        for key, value in obj.items():
            if isinstance(value, (dict, list)):
                records.extend(_metadata_records(value, trail + (str(key),)))
    elif isinstance(obj, list):
        for i, value in enumerate(obj):
            if isinstance(value, (dict, list)):
                records.extend(_metadata_records(value, trail + (str(i),)))
    return records


def _timing_for_layer(path: str, layer_info: dict[str, Any], manifest: dict[str, Any], frame_count: int) -> tuple[list[float], str]:
    def timing(obj: dict[str, Any]) -> tuple[list[float] | None, str | None]:
        durations = obj.get("durations_ms")
        if isinstance(durations, list) and durations:
            nums = [float(x) for x in durations if isinstance(x, (int, float)) and x > 0]
            if nums:
                if len(nums) == frame_count:
                    return nums, f"{sum(nums):g} ms"
                if len(nums) == 1:
                    return nums * frame_count, f"{nums[0]:g} ms/phase"
        milliseconds = obj.get("frame_ms", obj.get("duration_ms"))
        if isinstance(milliseconds, (int, float)) and milliseconds > 0:
            return [float(milliseconds)] * frame_count, f"{milliseconds:g} ms/phase"
        ticks = obj.get("frame_length_ticks", obj.get("frame_ticks", obj.get("ticks", obj.get("game_frames_per_pose"))))
        if isinstance(ticks, (int, float)) and ticks > 0:
            ms = float(ticks) * 1000 / 60
            return [ms] * frame_count, f"{ticks:g} ticks/phase"
        return None, None

    found, found_label = timing(layer_info)
    if found:
        return found, found_label or ""

    path_tokens = _slug_tokens(Path(path).stem)
    best: tuple[int, dict[str, Any]] | None = None
    for trail, record in _metadata_records(manifest):
        record_tokens = _slug_tokens(" ".join(trail))
        # If the manifest repeats the source `file`, include its basename.
        file_name = record.get("file") or record.get("path") or ""
        record_tokens |= _slug_tokens(str(file_name))
        phase_count = record.get("phases", record.get("frames"))
        phase_bonus = 1 if isinstance(phase_count, (int, float)) and int(phase_count) == frame_count else 0
        overlap = len(path_tokens & record_tokens)
        score = overlap * 2 + phase_bonus
        if score and (best is None or score > best[0]):
            best = (score, record)
    if best:
        found, found_label = timing(best[1])
        if found:
            return found, found_label or ""

    found, found_label = timing(manifest)
    if found:
        return found, found_label or ""
    default_ms = 100.0
    return [default_ms] * frame_count, "cadence non indiquée · 100 ms affichés"


def _resolve_template(template: str, names: list[str]) -> list[str]:
    template = safe_member_name(template)
    if not template:
        return []
    name_set = set(names)
    if template in name_set:
        return [template]
    # Layer manifests use fX/fXX and fN/fNN as frame placeholders.
    # Only treat X/N after an f as a placeholder (not ordinary filename text).
    placeholders = list(re.finditer(r"(?<=[fF])[XxNn]+", template))
    if not placeholders:
        return []
    parts: list[str] = []
    cursor = 0
    for match in placeholders:
        parts.append(re.escape(template[cursor:match.start()]))
        parts.append(rf"\d{{{len(match.group(0))}}}")
        cursor = match.end()
    parts.append(re.escape(template[cursor:]))
    try:
        pattern = re.compile("^" + "".join(parts) + "$", re.IGNORECASE)
    except re.error:
        return []
    matches = [n for n in names if pattern.fullmatch(n)]
    return sorted(matches, key=_natural_key)


def _natural_key(value: str) -> tuple[Any, ...]:
    return tuple(int(x) if x.isdigit() else x.casefold() for x in re.split(r"(\d+)", value))


def build_layer_plan(archive: LoadedArchive, manifest: dict[str, Any]) -> dict[str, Any] | None:
    templates = _path_templates_from_manifest(manifest)
    if not templates:
        return None
    names = archive.names()
    plan_layers: list[dict[str, Any]] = []
    total_frames = 0
    for template, layer_info in templates:
        frames = _resolve_template(template, names)
        if not frames:
            continue
        total_frames += len(frames)
        if total_frames > 768:
            return None
        timings, timing_label = _timing_for_layer(template, layer_info, manifest, len(frames))
        plan_layers.append({
            "name": human_title(re.sub(r"(?i)_?f[xn]+(?=\.[^.]+$)", "", PurePosixPath(template).name)),
            "files": frames,
            "durations": timings,
            "timing": timing_label,
            "origin": layer_info.get("origin", layer_info.get("xy", [0, 0])) if isinstance(layer_info, dict) else [0, 0],
        })
    if not plan_layers:
        return None
    size = manifest.get("size_px") or manifest.get("size") or manifest.get("canvas")
    if not (isinstance(size, (list, tuple)) and len(size) >= 2 and all(isinstance(x, (int, float)) and x > 0 for x in size[:2])):
        return None
    width, height = int(size[0]), int(size[1])
    if width > 8192 or height > 8192:
        return None

    durations = [d for layer in plan_layers for d in layer["durations"]]
    loop_ms = manifest.get("loop_ms")
    if not isinstance(loop_ms, (int, float)) or loop_ms <= 0:
        loop_ticks = manifest.get("scene_loop_ticks")
        if isinstance(loop_ticks, (int, float)) and loop_ticks > 0:
            loop_ms = loop_ticks * 1000 / 60
        else:
            # The longest independent layer cycle gives a sensible scrub range.
            loop_ms = max(sum(layer["durations"]) for layer in plan_layers)
    return {
        "width": width,
        "height": height,
        "loopMs": float(loop_ms),
        "manifest": manifest,
        "layers": plan_layers,
    }


def _ticks_to_ms(ticks: int | float) -> float:
    return float(ticks) * 1000 / 60


def _loop_for_layer(layer: dict[str, Any]) -> float:
    selector = layer.get("selector")
    if isinstance(selector, dict) and selector.get("periodTicks"):
        return _ticks_to_ms(selector["periodTicks"])
    return float(sum(layer.get("durations", [100.0])))


def _selector_from_manifest(info: dict[str, Any], frame_count: int) -> dict[str, Any] | None:
    expression = info.get("selection")
    if not isinstance(expression, str):
        return None
    cross = re.search(
        r"frames\[\(\(tick//(\d+)\)%(\d+)\)\s*\*\s*(\d+)\s*\+\s*\(\(tick//(\d+)\)%(\d+)\)\]",
        expression,
    )
    if cross:
        a_tick, a_count, stride, b_tick, b_count = map(int, cross.groups())
        return {
            "mode": "cross",
            "outerTicks": a_tick,
            "outerCount": a_count,
            "innerStride": stride,
            "innerTicks": b_tick,
            "innerCount": b_count,
            "periodTicks": int(info.get("period_ticks", math.lcm(a_tick * a_count, b_tick * b_count))),
        }
    simple = re.search(r"frames\[\(tick//(\d+)\)%(\d+)\]", expression)
    if simple:
        ticks, count = map(int, simple.groups())
        return {"mode": "cycle", "ticksPerFrame": ticks, "frameCount": count,
                "periodTicks": int(info.get("period_ticks", ticks * count))}
    return None


def _animation_layer(name: str, info: dict[str, Any], manifest: dict[str, Any], archive: LoadedArchive) -> dict[str, Any] | None:
    frame_paths = info.get("frames")
    if not isinstance(frame_paths, list) or not frame_paths or len(frame_paths) > 1024:
        return None
    files = [safe_member_name(str(p)) for p in frame_paths]
    if any(not p or p not in archive.members for p in files):
        return None
    selector = _selector_from_manifest(info, len(files))
    timings, timing_label = _timing_for_layer(name, info, manifest, len(files))
    if selector:
        loop_ms = _ticks_to_ms(selector["periodTicks"])
        durations = [1000 / 60] * len(files)
        timing_label = f"tick PMDO · période {selector['periodTicks']} ticks"
    else:
        durations = timings
        loop_ticks = info.get("period_ticks")
        loop_ms = _ticks_to_ms(loop_ticks) if isinstance(loop_ticks, (int, float)) and loop_ticks > 0 else sum(durations)
    blend = str(info.get("blend", "normal-over")).casefold()
    return {
        "name": human_title(name),
        "files": files,
        "durations": durations,
        "timing": timing_label,
        "origin": info.get("origin", [0, 0]),
        "blend": "lighter" if "add" in blend else "source-over",
        "blendLabel": str(info.get("blend", "normal-over")),
        "selector": selector,
        "loopMs": loop_ms,
        "placed": info.get("placed", True),
        "size": info.get("size"),
    }


def _map_layers_from_manifest(archive: LoadedArchive, manifest: dict[str, Any], map_info: dict[str, Any]) -> list[dict[str, Any]]:
    names = archive.names()
    output: list[dict[str, Any]] = []
    layers = map_info.get("layers")

    # Layer packs use explicit paths in `maps[].layers`.
    if isinstance(layers, list) and layers and all(isinstance(x, str) or isinstance(x, dict) and (x.get("file") or x.get("path")) for x in layers):
        for item in layers:
            if isinstance(item, str):
                template, info = item, {}
            else:
                info = item
                template = item.get("file") or item.get("path")
            frames = _resolve_template(str(template), names)
            if not frames:
                continue
            timings, timing_label = _timing_for_layer(str(template), info, manifest, len(frames))
            output.append({
                "name": str(info.get("title") or human_title(PurePosixPath(str(template).replace("X", "0").replace("N", "0")).name)),
                "files": frames,
                "durations": timings,
                "timing": timing_label,
                "origin": info.get("origin", [0, 0]),
                "blend": "source-over",
                "blendLabel": "normal-over",
            })
        if output:
            return output

    asset = map_info.get("asset")
    if not isinstance(asset, str):
        return output
    folder_prefix = f"PNG/{asset}/".casefold()
    pngs = [n for n in names if n.casefold().startswith(folder_prefix) and PurePosixPath(n).suffix.casefold() == ".png"]
    if not pngs:
        return output

    # D22 packaged layers use <asset>_<layer>_<frame>.png. The manifest gives
    # the exact stack order and each native frame duration.
    if isinstance(layers, list) and layers and all(isinstance(x, dict) for x in layers):
        first = next((n for n in pngs if re.search(r"_\d{2}_\d{3}\.png$", n, re.I)), None)
        if first:
            prefix = re.sub(r"_\d{2}_\d{3}\.png$", "", PurePosixPath(first).name, flags=re.I)
            files_by_layer: dict[int, list[tuple[int, str]]] = {}
            pattern = re.compile(rf"^{re.escape(prefix)}_(\d{{2}})_(\d{{3}})\.png$", re.I)
            for path in pngs:
                match = pattern.fullmatch(PurePosixPath(path).name)
                if match:
                    files_by_layer.setdefault(int(match.group(1)), []).append((int(match.group(2)), path))
            for index, info in enumerate(layers):
                frames = [path for _, path in sorted(files_by_layer.get(index, []))]
                if not frames:
                    continue
                expected = info.get("frames")
                if isinstance(expected, (int, float)) and int(expected) > 0:
                    frames = frames[:int(expected)]
                timings, timing_label = _timing_for_layer(f"{asset}_{index:02d}", info, manifest, len(frames))
                output.append({
                    "name": str(info.get("title") or f"Calque {index + 1}"),
                    "files": frames,
                    "durations": timings,
                    "timing": timing_label,
                    "origin": [0, 0],
                    "blend": "source-over",
                    "blendLabel": "normal-over",
                })

            # Night light is a separate compiled overlay, documented separately
            # from the five map layers in the D22 manifest.
            light = map_info.get("light")
            if isinstance(light, dict) and int(light.get("frames", 0) or 0) > 1:
                light_pattern = re.compile(rf"^{re.escape(prefix)}_lumiere_(\d{{3}})\.png$", re.I)
                light_files = sorted(
                    ((int(match.group(1)), path) for path in pngs
                     if (match := light_pattern.fullmatch(PurePosixPath(path).name))),
                    key=lambda pair: pair[0],
                )
                if light_files:
                    frames = [path for _, path in light_files[:int(light.get("frames", len(light_files)))]]
                    timings, timing_label = _timing_for_layer(f"{asset}_lumiere", light, manifest, len(frames))
                    output.append({
                        "name": "Lumière compilée (calque séparé)",
                        "files": frames,
                        "durations": timings,
                        "timing": timing_label,
                        "origin": [0, 0],
                        "blend": "lighter",
                        "blendLabel": "RGB555 additif, aperçu navigateur",
                    })
            if output:
                return output

    # VP1 tile-export packs store one full-map PNG per bank as 00.png, 01.png…
    banks = map_info.get("banks")
    if isinstance(banks, list) and banks:
        by_number = {PurePosixPath(path).stem: path for path in pngs}
        tracks = map_info.get("animation_tracks", [])
        for index, bank in enumerate(banks):
            path = by_number.get(f"{index:02d}") or by_number.get(str(index))
            if not path:
                continue
            info = tracks[index] if isinstance(tracks, list) and index < len(tracks) and isinstance(tracks[index], dict) else {}
            timings, timing_label = _timing_for_layer(str(bank), info, manifest, 1)
            output.append({
                "name": str(info.get("title") or bank),
                "files": [path],
                "durations": timings,
                "timing": timing_label,
                "origin": [0, 0],
                "blend": "source-over",
                "blendLabel": "normal-over",
            })
    return output


def build_manifest_map_plan(archive: LoadedArchive, manifest: dict[str, Any]) -> dict[str, Any] | None:
    maps = manifest.get("maps")
    if not isinstance(maps, list):
        return None
    scenes: list[dict[str, Any]] = []
    all_animation_info = manifest.get("animations", {})
    attached_animation_names: set[str] = set()
    for map_info in maps:
        if not isinstance(map_info, dict):
            continue
        size = map_info.get("size") or map_info.get("size_px")
        if not (isinstance(size, (list, tuple)) and len(size) >= 2 and all(isinstance(x, (int, float)) and x > 0 for x in size[:2])):
            continue
        width, height = int(size[0]), int(size[1])
        if width > 8192 or height > 8192:
            continue
        layer_specs = _map_layers_from_manifest(archive, manifest, map_info)
        if not layer_specs:
            continue
        scene_id = str(map_info.get("id") or map_info.get("asset") or f"Carte {len(scenes) + 1}")
        scene_tokens = _slug_tokens(scene_id)

        # Animations such as water, forest shimmer, island movement and volcanic
        # ash are stored as their own original full-map frames in some packs.
        if isinstance(all_animation_info, dict):
            for animation_name, animation_info in all_animation_info.items():
                if not isinstance(animation_info, dict):
                    continue
                animation_tokens = _slug_tokens(str(animation_name))
                if not animation_tokens.intersection(scene_tokens):
                    continue
                if animation_info.get("placed") is False:
                    continue
                anim_size = animation_info.get("size")
                if not (isinstance(anim_size, (list, tuple)) and len(anim_size) >= 2 and
                        (int(anim_size[0]), int(anim_size[1])) == (width, height)):
                    continue
                animation_layer = _animation_layer(str(animation_name), animation_info, manifest, archive)
                if animation_layer:
                    layer_specs.append(animation_layer)
                    attached_animation_names.add(str(animation_name))
        loop_ms = max((_loop_for_layer(layer) for layer in layer_specs), default=1000.0)
        scenes.append({
            "id": scene_id,
            "title": human_title(scene_id),
            "width": width,
            "height": height,
            "layers": layer_specs,
            "loopMs": loop_ms,
            "note": str(map_info.get("layer_scope") or map_info.get("notes", [""])[0] if map_info.get("notes") else map_info.get("layer_scope", "")),
            "viewport": map_info.get("viewport_at_x1", map_info.get("viewport")),
        })
    if not scenes:
        return None

    extra_animations: list[dict[str, Any]] = []
    if isinstance(all_animation_info, dict):
        for animation_name, animation_info in all_animation_info.items():
            if not isinstance(animation_info, dict) or animation_name in attached_animation_names:
                continue
            animation_layer = _animation_layer(str(animation_name), animation_info, manifest, archive)
            if animation_layer:
                extra_animations.append(animation_layer)
    return {
        "scenes": scenes,
        "extraAnimations": extra_animations,
        "loopMs": max(scene["loopMs"] for scene in scenes),
    }


def build_archive_plan(archive: LoadedArchive, manifest: dict[str, Any]) -> dict[str, Any] | None:
    multi = build_manifest_map_plan(archive, manifest)
    if multi:
        return multi
    single = build_layer_plan(archive, manifest)
    if single:
        single["scenes"] = [{
            "id": "scene",
            "title": human_title(archive.blob.path),
            "width": single["width"],
            "height": single["height"],
            "layers": single["layers"],
            "loopMs": single["loopMs"],
            "note": "",
        }]
        single["extraAnimations"] = []
    return single


def _layered_archive_page(archive_id: str, archive: LoadedArchive, plan: dict[str, Any], manifest_path: str) -> bytes:
    title = human_title(archive.blob.path)
    scenes = plan.get("scenes") or [{
        "id": "scene", "title": title, "width": plan["width"], "height": plan["height"],
        "layers": plan["layers"], "loopMs": plan["loopMs"], "note": "",
    }]
    image_exts = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".avif"}
    preview_files = [
        name for name in archive.names()
        if PurePosixPath(name).suffix.casefold() in image_exts
        and any(part.casefold() in {"apercus", "previews", "preview"} for part in PurePosixPath(name).parts[:-1])
    ]
    preview_files.sort(key=_natural_key)
    preview_files = preview_files[:24]
    payload_data = {"scenes": scenes, "extraAnimations": plan.get("extraAnimations", [])}
    payload = base64.b64encode(json.dumps(payload_data, ensure_ascii=False, separators=(",", ":")).encode("utf-8")).decode("ascii")
    escaped_title = html.escape(title)
    scene_options = "".join(
        f'<option value="{i}">{html.escape(scene["title"])}</option>' for i, scene in enumerate(scenes)
    )
    first_scene = scenes[0]
    fallback_parts = []
    for layer in first_scene.get("layers", []):
        if not layer.get("files"):
            continue
        blend_mode = "plus-lighter" if layer.get("blend") == "lighter" else "normal"
        image_url = _url_for_archive_member(archive_id, layer["files"][0])
        fallback_parts.append(
            f'<img src="{image_url}" alt="" aria-hidden="true" style="mix-blend-mode:{blend_mode}">'
        )
    fallback_images = "".join(fallback_parts)
    media_cards = "".join(
        f'<article class="media-card"><a href="{_url_for_archive_member(archive_id, name)}"><img loading="lazy" src="{_url_for_archive_member(archive_id, name)}" alt="{html.escape(PurePosixPath(name).name)}"></a><code>{html.escape(name)}</code></article>'
        for name in preview_files
    )
    extras_hidden = "hidden" if not plan.get("extraAnimations") else ""
    media_hidden = "hidden" if not preview_files else ""
    html_doc = f'''<!doctype html>
<html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{escaped_title} · aperçu des calques</title>
<style>
:root{{--bg:#101713;--panel:#19231d;--line:#314438;--text:#eef4e8;--muted:#aab9a9;--gold:#e5c776;--green:#b5d9ba}}
*{{box-sizing:border-box}}body{{margin:0;background:radial-gradient(ellipse at 12% 0%,#26362b 0,#101713 48rem);color:var(--text);font:15px/1.5 system-ui,sans-serif}}
main{{max-width:1440px;margin:auto;padding:24px}}a{{color:var(--gold)}}.back{{display:inline-block;margin-bottom:14px;text-decoration:none}}
header h1{{font-size:clamp(25px,3vw,38px);margin:4px 0}}header p{{color:var(--muted);max-width:90ch}}.tag{{color:var(--gold);font-size:12px;letter-spacing:.16em;text-transform:uppercase}}
.layout{{display:grid;grid-template-columns:minmax(0,1fr) 310px;gap:18px;margin-top:18px}}.panel{{background:#151e19;border:1px solid var(--line);border-radius:14px;padding:14px;box-shadow:0 18px 55px #0003}}
.stage{{overflow:auto;max-height:75vh;border-radius:8px;background-color:#1a241e;background-image:linear-gradient(45deg,#253229 25%,transparent 25%),linear-gradient(-45deg,#253229 25%,transparent 25%),linear-gradient(45deg,transparent 75%,#253229 75%),linear-gradient(-45deg,transparent 75%,#253229 75%);background-size:24px 24px;background-position:0 0,0 12px,12px -12px,-12px 0}}.scene-stage{{position:relative;isolation:isolate}}.fallback-stack{{position:absolute;inset:0;z-index:1}}.fallback-stack img{{position:absolute;inset:0;width:100%;height:100%;object-fit:fill;image-rendering:pixelated}}canvas#scene{{position:absolute;left:0;top:0;z-index:2;display:block;image-rendering:pixelated;max-width:none;visibility:hidden}}.controls{{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin-top:12px}}button{{border:0;border-radius:8px;background:var(--green);color:#15271c;padding:8px 12px;font-weight:700;cursor:pointer}}button.secondary{{background:#2a392f;color:var(--text);border:1px solid var(--line)}}input[type=range]{{accent-color:var(--gold);min-width:180px;flex:1}}select{{border:1px solid var(--line);border-radius:7px;background:#111914;color:var(--text);padding:6px}}.layers{{max-height:62vh;overflow:auto}}.layers label{{display:flex;gap:8px;align-items:flex-start;padding:6px 0;border-bottom:1px solid #ffffff0b;color:#dce8dc;font-size:13px}}.layers input{{accent-color:var(--gold);margin-top:3px}}.small{{font-size:12px;color:var(--muted)}}.note{{padding:10px 12px;border-left:3px solid var(--gold);background:#20291f;border-radius:5px;margin-top:14px;color:#d6decc;font-size:13px}}.extra-grid,.media-grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:12px}}.extra-card,.media-card{{background:#111813;border:1px solid var(--line);border-radius:10px;padding:10px;min-width:0}}.extra-card canvas,.media-card img{{width:100%;height:auto;max-height:300px;object-fit:contain;background:#0a0e0b;image-rendering:pixelated}}.extra-card canvas{{max-width:100%}}.extra-card code,.media-card code{{display:block;font-size:11px;overflow-wrap:anywhere;color:#dce8dc;margin-top:6px}}[hidden]{{display:none!important}}
@media(max-width:900px){{.layout{{grid-template-columns:1fr}}.layers{{max-height:36vh}}}}
</style></head><body><main>
<a class="back" href="/">← Retour à tous les aperçus</a>
<header><div class="tag">Visionneuse ZIP reconstruite depuis le manifeste</div><h1>{escaped_title}</h1>
<p>Composition construite à partir de l'ordre des calques et des PNG originaux du ZIP, sans rééchantillonnage. La cadence et les frames sont lues depuis le manifeste lorsqu'elles y sont décrites. Les aperçus natifs inclus dans le pack restent disponibles plus bas.</p></header>
<div class="layout"><section class="panel"><div class="controls" id="map-control" {'hidden' if len(scenes) <= 1 else ''}><label class="small">Carte / scène <select id="map-select">{scene_options}</select></label></div>
<div class="stage"><div class="scene-stage" id="scene-stage" style="width:{first_scene['width']}px;height:{first_scene['height']}px"><div class="fallback-stack" id="static-fallback">{fallback_images}</div><canvas id="scene"></canvas></div></div>
<div class="controls"><button id="play">Pause</button><button class="secondary" id="prev">◀ 1 tick</button><button class="secondary" id="next">1 tick ▶</button><label class="small">Zoom <select id="zoom"><option value="1">1× natif</option><option value="2">2×</option><option value="3">3×</option><option value="0.5">½×</option></select></label>
<input id="time" type="range" min="0" max="1000" value="0"><output id="clock">0.00 s</output><output class="small" id="load-status" aria-live="polite">Image fixe de secours chargée en attendant l’animation…</output></div>
<div class="note" id="scene-note">Calques joués selon leurs cycles indépendants. Le mode additif RGB555 du manifeste est simulé par le mélange additif Canvas du navigateur ; les frames sources restent les PNG originaux.</div>
</section><aside class="panel"><h2 id="layer-heading">Calques</h2><div class="layers" id="layers"></div><p class="small" id="dimensions"></p><a href="/archive-download/{archive_id}">Télécharger l’archive ZIP originale</a></aside></div>
<section class="panel" id="extra-panel" {extras_hidden}><h2>Animations non superposées à une carte</h2><p class="small">Ces séquences sont montrées séparément lorsque le manifeste ne donne pas un placement sûr sur une scène. Les séquences marquées « non placées » restent des références et ne sont pas injectées dans les cartes.</p><div class="extra-grid" id="extra-animations"></div></section>
<section class="panel" id="media-panel" {media_hidden}><h2>Aperçus natifs du pack</h2><div class="media-grid">{media_cards}</div></section>
<p class="small">Manifeste utilisé : <code>{html.escape(manifest_path)}</code></p>
</main><script>
const encoded='{payload}';const data=JSON.parse(new TextDecoder().decode(Uint8Array.from(atob(encoded),c=>c.charCodeAt(0))));
const archiveId={json.dumps(archive_id)};const canvas=document.getElementById('scene');const ctx=canvas.getContext('2d');ctx.imageSmoothingEnabled=false;
const stageRoot=document.getElementById('scene-stage'),fallbackRoot=document.getElementById('static-fallback'),loadStatus=document.getElementById('load-status');
const imageCache=new Map();function archiveUrl(path){{return '/archive-content/'+archiveId+'/'+String(path||'').split('/').map(encodeURIComponent).join('/')}}
function getImage(path){{if(!path)return null;if(!imageCache.has(path)){{const img=new Image();img.onerror=()=>{{loadStatus.textContent='Image introuvable dans le ZIP : '+path}};img.src=archiveUrl(path);imageCache.set(path,img)}}return imageCache.get(path)}}
function updateFallback(){{fallbackRoot.replaceChildren();for(const layer of layers){{if(!layer.visible||!layer.files||!layer.files.length)continue;const img=document.createElement('img');img.src=archiveUrl(layer.files[0]);img.alt='';img.setAttribute('aria-hidden','true');img.style.mixBlendMode=layer.blend==='lighter'?'plus-lighter':'normal';fallbackRoot.append(img)}}fallbackRoot.hidden=false;canvas.style.visibility='hidden';loadStatus.textContent='Image fixe de secours affichée; chargement des frames…'}}
let sceneIndex=0,scene=data.scenes[0],layers=[],running=true,baseTime=performance.now(),heldTime=0;const slider=document.getElementById('time'),clock=document.getElementById('clock'),play=document.getElementById('play');
function loopMs(){{return Math.max(1,Number(scene.loopMs)||1000)}}function nowMs(){{return running?(performance.now()-baseTime)%loopMs():heldTime%loopMs()}}
function frameAt(layer,t){{const selector=layer.selector;if(selector){{const tick=Math.floor(t/(1000/60));if(selector.mode==='cross')return (Math.floor(tick/selector.outerTicks)%selector.outerCount)*selector.innerStride+(Math.floor(tick/selector.innerTicks)%selector.innerCount);if(selector.mode==='cycle')return Math.floor(tick/selector.ticksPerFrame)%selector.frameCount}}const durations=layer.durations||[100];const cycle=durations.reduce((a,b)=>a+b,0)||100;let x=t%cycle;for(let i=0;i<durations.length;i++){{if(x<durations[i])return i;x-=durations[i]}}return 0}}
function makeLayers(){{layers=(scene.layers||[]).map((layer,index)=>({{...layer,index,visible:true}}));const ui=document.getElementById('layers');ui.replaceChildren();layers.forEach(layer=>{{const label=document.createElement('label');const input=document.createElement('input');input.type='checkbox';input.checked=true;input.addEventListener('change',()=>{{layer.visible=input.checked;updateFallback()}});const span=document.createElement('span');span.textContent=layer.name+' · '+layer.files.length+' phase(s) · '+layer.timing+(layer.blendLabel&&layer.blendLabel!=='normal-over'?' · '+layer.blendLabel:'');label.append(input,span);ui.append(label)}});document.getElementById('layer-heading').textContent='Calques ('+layers.length+')';document.getElementById('dimensions').textContent=scene.width+' × '+scene.height+' px · cycle de référence '+(loopMs()/1000).toFixed(2)+' s';document.getElementById('scene-note').textContent=scene.note||'Calques joués selon leurs cycles indépendants. Le mode additif RGB555 du manifeste est simulé par le mélange additif Canvas du navigateur ; les frames sources restent les PNG originaux.';canvas.width=scene.width;canvas.height=scene.height;ctx.imageSmoothingEnabled=false;const zoom=Number(document.getElementById('zoom').value);canvas.style.width=Math.round(canvas.width*zoom)+'px';canvas.style.height=Math.round(canvas.height*zoom)+'px';stageRoot.style.width=Math.round(canvas.width*zoom)+'px';stageRoot.style.height=Math.round(canvas.height*zoom)+'px';slider.max=String(Math.max(1,Math.floor(loopMs())));heldTime=0;baseTime=performance.now();updateFallback()}}
function selectScene(index){{sceneIndex=index;scene=data.scenes[sceneIndex];makeLayers()}}
document.getElementById('map-select').addEventListener('change',e=>selectScene(Number(e.target.value)));
function draw(){{const t=nowMs();let allReady=true;ctx.clearRect(0,0,canvas.width,canvas.height);for(const layer of layers){{if(!layer.visible)continue;const index=frameAt(layer,t),path=layer.files[index];if(!path){{allReady=false;loadStatus.textContent='Frame manquante dans les données du manifeste : '+layer.name;continue}}const img=getImage(path);if(img&&img.complete&&img.naturalWidth){{const origin=Array.isArray(layer.origin)?layer.origin:[0,0];ctx.globalCompositeOperation=layer.blend||'source-over';ctx.drawImage(img,Number(origin[0])||0,Number(origin[1])||0)}}else allReady=false}}ctx.globalCompositeOperation='source-over';if(allReady&&layers.some(layer=>layer.visible)){{if(canvas.style.visibility!=='visible')loadStatus.textContent='Carte affichée · animation active';canvas.style.visibility='visible';fallbackRoot.hidden=true}}slider.value=String(Math.round(t));clock.value=(t/1000).toFixed(2)+' s';requestAnimationFrame(draw)}}
play.addEventListener('click',()=>{{if(running){{heldTime=nowMs();running=false;play.textContent='Lire'}}else{{baseTime=performance.now()-heldTime;running=true;play.textContent='Pause'}}}});
slider.addEventListener('input',()=>{{heldTime=Number(slider.value);if(running)baseTime=performance.now()-heldTime}});
document.getElementById('prev').addEventListener('click',()=>{{heldTime=(nowMs()+loopMs()-1000/60)%loopMs();if(running)baseTime=performance.now()-heldTime}});
document.getElementById('next').addEventListener('click',()=>{{heldTime=(nowMs()+1000/60)%loopMs();if(running)baseTime=performance.now()-heldTime}});
document.getElementById('zoom').addEventListener('change',e=>{{const value=Number(e.target.value),width=Math.round(canvas.width*value),height=Math.round(canvas.height*value);canvas.style.width=width+'px';canvas.style.height=height+'px';stageRoot.style.width=width+'px';stageRoot.style.height=height+'px'}});
selectScene(0);
const extras=data.extraAnimations||[];const extraRoot=document.getElementById('extra-animations');for(const layer of extras){{const card=document.createElement('article');card.className='extra-card';const extraCanvas=document.createElement('canvas');const extraCtx=extraCanvas.getContext('2d');extraCtx.imageSmoothingEnabled=false;const size=Array.isArray(layer.size)?layer.size:[0,0];extraCanvas.width=Number(size[0])||320;extraCanvas.height=Number(size[1])||240;extraCanvas.style.width='100%';extraCanvas.style.height='auto';const label=document.createElement('code');label.textContent=layer.name+' · '+layer.files.length+' phase(s) · '+layer.timing+(layer.placed===false?' · référence non placée':'');card.append(extraCanvas,label);extraRoot.append(card);function paintExtra(time){{const path=layer.files[frameAt(layer,time)];const img=getImage(path);if(img&&img.complete&&img.naturalWidth){{if(!size[0]||!size[1]){{extraCanvas.width=img.naturalWidth;extraCanvas.height=img.naturalHeight}}extraCtx.clearRect(0,0,extraCanvas.width,extraCanvas.height);extraCtx.globalCompositeOperation=layer.blend||'source-over';extraCtx.drawImage(img,0,0);extraCtx.globalCompositeOperation='source-over'}}requestAnimationFrame(paintExtra)}}paintExtra(performance.now())}}
draw();
</script></body></html>'''
    return html_doc.encode("utf-8")

def _generic_archive_page(archive_id: str, archive: LoadedArchive, manifest: dict[str, Any] | None, manifest_path: str | None) -> bytes:
    names = archive.names()
    image_exts = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".avif"}
    images = [n for n in names if PurePosixPath(n).suffix.casefold() in image_exts]
    def priority(name: str) -> tuple[int, str]:
        low = name.casefold()
        if any(k in low for k in ("animation_complete", "animation.webp", "animation.gif", "scene.gif", "scene.webp")):
            rank = 0
        elif any(k in low for k in ("composition", "preview", "apercu", "review/scene", "vue_")):
            rank = 1
        elif PurePosixPath(name).suffix.casefold() in {".gif", ".webp"}:
            rank = 2
        else:
            rank = 3
        return rank, name.casefold()
    images.sort(key=priority)
    selected = images[:80]
    files = [{"name": name, "url": _url_for_archive_member(archive_id, name),
              "animated": PurePosixPath(name).suffix.casefold() in {".gif", ".webp", ".avif"}}
             for name in selected]
    summary = []
    if manifest:
        for key in ("size_px", "size", "frames", "intrinsic_frames", "frame_ms", "durations_ms", "loop_ms", "scene_loop_ticks", "runtime_validated", "art_approved"):
            if key in manifest:
                value = manifest[key]
                if isinstance(value, list) and len(value) > 12:
                    value = f"{len(value)} phases"
                summary.append(f"{key}: {value}")
    archive_name = html.escape(Path(archive.blob.path).name)
    archive_format = "OpenRaster (ORA)" if archive.blob.path.casefold().endswith(".ora") else "ZIP"
    title = html.escape(human_title(Path(archive.blob.path).name))
    files_b64 = base64.b64encode(json.dumps(files, ensure_ascii=False, separators=(",", ":")).encode()).decode("ascii")
    summary_html = "<br>".join(html.escape(line) for line in summary) or "Aucun manifeste de rendu reconnu."
    member_list = "".join(f"<li><code>{html.escape(n)}</code></li>" for n in names[:120])
    html_doc = f'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{title} · contenu {archive_format}</title>
<style>:root{{--bg:#111814;--panel:#1b251e;--line:#34463a;--text:#eef4e8;--muted:#a9b8aa;--gold:#e5c776}}*{{box-sizing:border-box}}body{{margin:0;background:radial-gradient(ellipse at 15% 0%,#27382b,#101713 50rem);color:var(--text);font:15px/1.5 system-ui,sans-serif}}main{{max-width:1280px;margin:auto;padding:24px}}a{{color:var(--gold)}}h1{{margin:4px 0 8px}}.muted{{color:var(--muted)}}.panel{{background:#151e19;border:1px solid var(--line);border-radius:14px;padding:16px;margin:14px 0}}.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:12px}}.asset{{background:#111813;border:1px solid var(--line);border-radius:10px;padding:10px;overflow:hidden}}.asset img,.asset video{{width:100%;height:220px;object-fit:contain;background:#0a0e0b;image-rendering:pixelated}}.asset code{{font-size:11px;overflow-wrap:anywhere}}details{{margin-top:12px}}.note{{border-left:3px solid var(--gold);padding:10px 12px;background:#20291f}}</style></head><body><main>
<a href="/">← Retour à tous les aperçus</a><p class="muted">ARCHIVE {archive_format} · {archive_name}</p><h1>{title}</h1>
<div class="note">Aucune visionneuse HTML intégrée ou page de carte associée n’a été trouvée dans ce ZIP. Les images et animations présentes sont affichées telles quelles ; les couches PNG sont proposées séparément, sans prétendre les recomposer si le manifeste ne décrit pas leur ordre.</div>
<section class="panel"><h2>Informations du manifeste</h2><p class="muted">{summary_html}</p><p>{len(names)} fichiers · {len(images)} images · <a href="/archive-download/{archive_id}">Télécharger l’archive {archive_format} originale</a></p></section>
<section class="panel"><h2>Rendus et animations du ZIP ({len(selected)} affichés)</h2><div class="grid" id="assets"></div></section>
<details class="panel"><summary>Contenu de l’archive (premiers {min(120, len(names))} fichiers)</summary><ul>{member_list}</ul></details>
</main><script>const rows=JSON.parse(new TextDecoder().decode(Uint8Array.from(atob('{files_b64}'),c=>c.charCodeAt(0))));const root=document.getElementById('assets');for(const row of rows){{const card=document.createElement('article');card.className='asset';const media=document.createElement('img');media.src=row.url;media.alt=row.name;media.loading='lazy';const name=document.createElement('code');name.textContent=row.name;card.append(media,name);root.append(card)}}</script></body></html>'''
    return html_doc.encode("utf-8")


class PreviewServer(ThreadingHTTPServer):
    daemon_threads = True
    request_queue_size = 64

    def __init__(self, address: tuple[str, int], handler: type[SimpleHTTPRequestHandler], repo: UpstreamRepository | None):
        self.repo = repo
        self.archive_store = ArchiveStore(repo) if repo else None
        super().__init__(address, handler)

    def handle_error(self, request: Any, client_address: Any) -> None:
        import sys
        if isinstance(sys.exc_info()[1], (BrokenPipeError, ConnectionResetError)):
            return
        super().handle_error(request, client_address)


class Handler(SimpleHTTPRequestHandler):
    def send_error(self, code: int, message: str | None = None, explain: str | None = None) -> None:
        # BaseHTTPRequestHandler writes the reason phrase as latin-1. Keep
        # French explanations readable where possible, and replace any smart
        # punctuation from archive names so a normal 404 cannot drop the socket.
        if message is not None:
            message = message.encode("latin-1", "replace").decode("latin-1")
        if explain is not None:
            explain = explain.encode("latin-1", "replace").decode("latin-1")
        super().send_error(code, message, explain)

    def do_GET(self) -> None:
        parsed = urllib.parse.urlsplit(self.path)
        path = urllib.parse.unquote(parsed.path)
        repo: UpstreamRepository | None = self.server.repo  # type: ignore[attr-defined]
        archives: ArchiveStore | None = self.server.archive_store  # type: ignore[attr-defined]
        context = repo.source_context(parsed.query, self.headers.get("Referer", "")) if repo else None

        if path in {"/", "/index.html"}:
            self._send_local(ROOT / "source" / "serveur_apercus" / "index.html", "text/html; charset=utf-8")
            return
        if path == "/api/catalog":
            body = json.dumps(build_catalog(repo), ensure_ascii=False, separators=(",", ":")).encode("utf-8")
            self._send(body, "application/json; charset=utf-8", cache="no-store")
            return

        if path.startswith("/upstream/"):
            remote_path = path[len("/upstream/"):]
            self._send_remote(repo, remote_path, context)
            return

        if path.startswith("/archive-preview/"):
            archive_id = path[len("/archive-preview/"):].strip("/")
            if not repo or not archives:
                self.send_error(503, "Les sources d’archives sont indisponibles.")
                return
            self._serve_archive_preview(repo, archives, archive_id)
            return

        if path.startswith("/archive-download/"):
            archive_id = path[len("/archive-download/"):].strip("/")
            if not repo or not archives:
                self.send_error(503, "Les sources d’archives sont indisponibles.")
                return
            self._serve_archive_download(archives, archive_id)
            return

        if path.startswith("/archive-content/"):
            tail = path[len("/archive-content/"):]
            archive_id, sep, member = tail.partition("/")
            if not repo or not archives or not sep:
                self.send_error(404)
                return
            self._serve_archive_member(archives, archive_id, member)
            return

        # Root preview HTML and relative media links from the original pages are
        # fetched from the pinned source only when they are absent in this clone.
        local_path = ROOT.joinpath(*PurePosixPath(path.lstrip("/")).parts)
        if repo and repo.has(path.lstrip("/"), context) and (context is not None or not local_path.is_file()):
            self._send_remote(repo, path.lstrip("/"), context)
            return
        if path.startswith("/.git") or path.startswith("/.cache") or path.startswith("/.venv"):
            self.send_error(404)
            return
        super().do_GET()

    def do_HEAD(self) -> None:
        parsed = urllib.parse.urlsplit(self.path)
        path = urllib.parse.unquote(parsed.path)
        repo: UpstreamRepository | None = self.server.repo  # type: ignore[attr-defined]
        context = repo.source_context(parsed.query, self.headers.get("Referer", "")) if repo else None
        if path.startswith("/upstream/") and repo:
            remote = path[len("/upstream/"):]
            try:
                virtual = repo.get_virtual_asset(remote, context)
                if virtual is not None:
                    content_type, size = virtual[1], len(virtual[0])
                else:
                    blob = repo.resolve_blob(remote, context)
                    if blob is None:
                        raise KeyError(remote)
                    content_type, size = mime_type(remote), blob.size
                self.send_response(200)
                self.send_header("Content-Type", content_type)
                self.send_header("Content-Length", str(size))
                self.send_header("X-Content-Type-Options", "nosniff")
                self.end_headers()
            except (KeyError, UpstreamError):
                self.send_error(404)
            return
        super().do_HEAD()

    def _serve_archive_preview(self, repo: UpstreamRepository, archives: ArchiveStore, archive_id: str) -> None:
        blob = repo.archive_by_id.get(archive_id)
        if blob is None:
            self.send_error(404, "Archive introuvable dans le catalogue.")
            return
        matched_blob, score = repo.archive_preview.get(archive_id, (None, 0.0))
        related_layers = repo.related_layer_archive.get(archive_id)
        # An exact sibling page is the authoritative full-fidelity preview for
        # this map (including its original animation UI); avoid downloading a
        # multi-megabyte ZIP just to rediscover the same page.
        if matched_blob and score >= 0.99:
            self._redirect(_preview_url(matched_blob))
            return
        if related_layers:
            self._redirect(f"/archive-preview/{related_layers}")
            return
        try:
            archive = archives.get(archive_id)
            viewer = _choose_embedded_viewer(archive.names())
            if viewer:
                self._redirect(_url_for_archive_member(archive_id, viewer))
                return
            if matched_blob and score >= 0.70:
                self._redirect(_preview_url(matched_blob))
                return
            manifest, manifest_path = _manifest_from_archive(archive)
            if manifest:
                plan = build_archive_plan(archive, manifest)
                if plan:
                    self._send(_layered_archive_page(archive_id, archive, plan, manifest_path or "manifest.json"),
                               "text/html; charset=utf-8", cache="no-store")
                    return
            self._send(_generic_archive_page(archive_id, archive, manifest, manifest_path),
                       "text/html; charset=utf-8", cache="no-store")
        except (KeyError, UpstreamError, zipfile.BadZipFile) as exc:
            self.send_error(502, html.escape(str(exc)))

    def _serve_archive_download(self, archives: ArchiveStore, archive_id: str) -> None:
        repo: UpstreamRepository = self.server.repo  # type: ignore[attr-defined]
        blob = repo.archive_by_id.get(archive_id)
        if blob is None:
            self.send_error(404)
            return
        try:
            archive = archives.get(archive_id)
            self._send(archive.payload, mime_type(blob.path), cache="private, max-age=3600", filename=Path(blob.path).name)
        except (KeyError, UpstreamError) as exc:
            self.send_error(502, html.escape(str(exc)))

    def _serve_archive_member(self, archives: ArchiveStore, archive_id: str, encoded_member: str) -> None:
        member = safe_member_name(encoded_member)
        if not member:
            self.send_error(400, "Chemin d’archive invalide.")
            return
        try:
            archive = archives.get(archive_id)
            content = archive.read(member)
            self._send(content, mime_type(member), cache="public, max-age=3600")
        except KeyError:
            self.send_error(404, "Fichier absent de l’archive.")
        except UpstreamError as exc:
            self.send_error(502, html.escape(str(exc)))

    def _send_remote(
        self, repo: UpstreamRepository | None, path: str,
        context: tuple[str, str] | None = None,
    ) -> None:
        if not repo:
            self.send_error(503, "Les dépôts source ne sont pas disponibles.")
            return
        path = path.lstrip("/")
        if not path or ".." in PurePosixPath(path).parts or ".git" in PurePosixPath(path).parts:
            self.send_error(400, "Chemin distant invalide.")
            return
        try:
            virtual = repo.get_virtual_asset(path, context)
            if virtual is not None:
                content, content_type = virtual
            else:
                blob = repo.resolve_blob(path, context)
                if blob is None:
                    raise KeyError(path)
                content = repo.get_blob(blob)
                content_type = mime_type(path)
                if content_type.startswith("text/html") or path.casefold().endswith((".html", ".htm")):
                    content = _prepare_remote_preview(path, content, blob.source_repo)
                    content_type = "text/html; charset=utf-8"
            self._send(content, content_type, cache="public, max-age=3600")
        except KeyError:
            self.send_error(404, f"Fichier source introuvable : {html.escape(path)}")
        except UpstreamError as exc:
            self.send_error(502, html.escape(str(exc)))

    def _send_local(self, path: Path, content_type: str) -> None:
        try:
            content = path.read_bytes()
        except OSError:
            self.send_error(500, "La page d’accueil de l’aperçu est absente.")
            return
        self._send(content, content_type, cache="no-store")

    def _redirect(self, location: str) -> None:
        self.send_response(302)
        self.send_header("Location", location)
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", "0")
        self.end_headers()

    def _send(self, data: bytes, content_type: str, cache: str = "no-store", filename: str | None = None) -> None:
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", cache)
        self.send_header("X-Content-Type-Options", "nosniff")
        if filename:
            quoted = urllib.parse.quote(filename, safe="")
            self.send_header("Content-Disposition", f"attachment; filename*=UTF-8''{quoted}")
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt: str, *args: Any) -> None:
        # Keep the live-preview process log useful rather than listing every
        # animation frame requested by the browser.
        if " 5" in fmt or "Error" in fmt:
            print(f"Aperçu HTTP: {fmt % args}", flush=True)


MIME_OVERRIDES = {
    ".rsground": "application/octet-stream", ".tile": "application/octet-stream",
    ".chara": "application/octet-stream", ".dir": "application/octet-stream",
    ".idx": "application/octet-stream", ".ora": "application/zip", ".npz": "application/octet-stream",
}


def mime_type(path: str) -> str:
    ext = PurePosixPath(path).suffix.casefold()
    return MIME_OVERRIDES.get(ext) or mimetypes.guess_type(path)[0] or "application/octet-stream"


_PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def _png_chunk(kind: bytes, payload: bytes) -> bytes:
    body = kind + payload
    return struct.pack(">I", len(payload)) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)


def _decode_rgba_png(data: bytes) -> tuple[bytes, bytes, bytearray]:
    if not data.startswith(_PNG_SIGNATURE):
        raise ValueError("Le calque OpenRaster n’est pas un PNG valide.")
    pos = len(_PNG_SIGNATURE)
    header = b""
    idat: list[bytes] = []
    ancillary: list[bytes] = []
    while pos + 12 <= len(data):
        size = struct.unpack(">I", data[pos:pos + 4])[0]
        kind = data[pos + 4:pos + 8]
        end = pos + 12 + size
        if end > len(data):
            raise ValueError("Chunk PNG tronqué.")
        payload = data[pos + 8:pos + 8 + size]
        if kind == b"IHDR":
            header = payload
        elif kind == b"IDAT":
            idat.append(payload)
        elif kind == b"IEND":
            break
        elif kind not in {b"acTL", b"fcTL", b"fdAT"} and kind[:1].islower():
            ancillary.append(data[pos:end])
        pos = end
    if len(header) != 13 or not idat:
        raise ValueError("Structure PNG invalide.")
    width, height, depth, color, compression, filtering, interlace = struct.unpack(">IIBBBBB", header)
    if (width < 1 or height < 1 or width * height > 64_000_000
            or depth != 8 or color != 6 or compression != 0 or filtering != 0 or interlace != 0):
        raise ValueError("Le composite OpenRaster attend des calques RGBA 8 bits non entrelacés.")
    stride = width * 4
    raw = zlib.decompress(b"".join(idat))
    if len(raw) != height * (stride + 1):
        raise ValueError("Données PNG de taille incohérente.")
    pixels = bytearray(height * stride)
    previous = bytearray(stride)
    cursor = 0
    for y in range(height):
        filter_type = raw[cursor]
        cursor += 1
        row = bytearray(raw[cursor:cursor + stride])
        cursor += stride
        for i, value in enumerate(row):
            left = row[i - 4] if i >= 4 else 0
            above = previous[i]
            upper_left = previous[i - 4] if i >= 4 else 0
            if filter_type == 1:
                predictor = left
            elif filter_type == 2:
                predictor = above
            elif filter_type == 3:
                predictor = (left + above) // 2
            elif filter_type == 4:
                p = left + above - upper_left
                pa, pb, pc = abs(p - left), abs(p - above), abs(p - upper_left)
                predictor = left if pa <= pb and pa <= pc else above if pb <= pc else upper_left
            elif filter_type == 0:
                predictor = 0
            else:
                raise ValueError("Filtre PNG inconnu.")
            row[i] = (value + predictor) & 0xFF
        start = y * stride
        pixels[start:start + stride] = row
        previous = row
    return header, b"".join(ancillary), pixels


def _compose_png_rgba(background: bytes, overlay: bytes) -> bytes:
    """Compose two same-sized RGBA PNG layers (overlay over background)."""
    bg_header, bg_ancillary, bg = _decode_rgba_png(background)
    fg_header, _, fg = _decode_rgba_png(overlay)
    if bg_header != fg_header:
        raise ValueError("Les calques OpenRaster n’ont pas les mêmes dimensions ou format.")
    for i in range(0, len(bg), 4):
        sa = fg[i + 3]
        if sa == 0:
            continue
        da = bg[i + 3]
        if sa == 255 or da == 0:
            bg[i:i + 4] = fg[i:i + 4]
            continue
        remaining = 255 - sa
        denominator = sa * 255 + da * remaining
        out_alpha = (denominator + 127) // 255
        for channel in range(3):
            numerator = fg[i + channel] * sa * 255 + bg[i + channel] * da * remaining
            bg[i + channel] = (numerator + denominator // 2) // denominator
        bg[i + 3] = out_alpha
    width, height = struct.unpack(">II", bg_header[:8])
    scanlines = bytearray()
    stride = width * 4
    for y in range(height):
        scanlines.append(0)
        scanlines.extend(bg[y * stride:(y + 1) * stride])
    output = bytearray(_PNG_SIGNATURE)
    output.extend(_png_chunk(b"IHDR", bg_header))
    output.extend(bg_ancillary)
    output.extend(_png_chunk(b"IDAT", zlib.compress(bytes(scanlines), 6)))
    output.extend(_png_chunk(b"IEND", b""))
    return bytes(output)


def main() -> None:
    parser = argparse.ArgumentParser(description="Galerie PMDO et archives ZIP/OpenRaster")
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--bind", default="0.0.0.0")
    args = parser.parse_args()
    repo: UpstreamRepository | None
    try:
        repo = UpstreamRepository()
        print(f"Catalogue : {len(repo.previews)} aperçus HTML, {len(repo.archives)} archives ZIP/ORA.", flush=True)
    except (UpstreamError, OSError, subprocess.SubprocessError) as exc:
        repo = None
        print(f"ATTENTION — dépôt source non restauré : {exc}", flush=True)
        print("Le serveur reste disponible pour les aperçus locaux.", flush=True)
    server = PreviewServer((args.bind, args.port), partial(Handler, directory=str(ROOT)), repo)
    print(f"Aperçus PMDO : http://{args.bind}:{args.port}/  (racine {ROOT})", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
