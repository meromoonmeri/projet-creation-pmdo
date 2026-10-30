#!/usr/bin/env python3
"""Recover five pinned, read-only Arena exports into ignored staging for conversion.

Only reads the source commit via GitHub's public REST API; it never checks out,
merges, or writes to an Arena branch. All files are stored under .cache. The
converter verifies the source Ground hashes and per-export manifests afterward.
"""
from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import tempfile
import time
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
REPOSITORY = "meromoonmeri/projet-creation-pmdo"
COMMIT = "c2d77959d87bf334e9603b47df012bc4f1e3dd7a"
DEFAULT_OUTPUT = ROOT / ".cache/destiny-recovery/empty_ground_audit/exports"
SOURCE_DIRS = (
    "entree_falaise_trempee_sud_nord_v1",
    "entree_promontoire_nuages_sud_nord_v1",
    "entree_tourbiere_piliers_sud_nord_v1",
    "fin_falaise_trempee_source_v1",
    "fin_promontoire_nuages_clairiere_v1",
)
USER_AGENT = "PMDO-Destiny-source-recovery/1.0"


def request_json(url: str) -> dict:
    request = urllib.request.Request(
        url,
        headers={"Accept": "application/vnd.github+json", "User-Agent": USER_AGENT},
    )
    last_error: Exception | None = None
    for attempt in range(4):
        try:
            with urllib.request.urlopen(request, timeout=90) as response:
                return json.load(response)
        except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as exc:
            last_error = exc
            if attempt < 3:
                time.sleep(1.5 * (attempt + 1))
    raise RuntimeError(f"GitHub API JSON failure: {url}: {last_error}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    output = args.output.resolve()
    commit_doc = request_json(f"https://api.github.com/repos/{REPOSITORY}/commits/{COMMIT}")
    if commit_doc.get("sha") != COMMIT:
        raise SystemExit("Commit source différent; aucun export extrait.")
    tree_sha = commit_doc.get("commit", {}).get("tree", {}).get("sha")
    if not isinstance(tree_sha, str) or len(tree_sha) != 40:
        raise SystemExit("SHA de l'arbre source absent; aucun export extrait.")
    tree = request_json(
        f"https://api.github.com/repos/{REPOSITORY}/git/trees/{tree_sha}?recursive=1"
    )
    if tree.get("sha") != tree_sha or tree.get("truncated"):
        raise SystemExit("Arbre source incomplet ou commit différent; aucun export extrait.")

    prefixes = tuple(f"exports/{source_dir}/" for source_dir in SOURCE_DIRS)
    blobs = [
        entry for entry in tree.get("tree", [])
        if entry.get("type") == "blob"
        and isinstance(entry.get("path"), str)
        and entry["path"].startswith(prefixes)
    ]
    found_dirs = {
        prefix.removeprefix("exports/").rstrip("/")
        for prefix in prefixes
        if any(item["path"].startswith(prefix) for item in blobs)
    }
    missing_dirs = sorted(set(SOURCE_DIRS) - found_dirs)
    if missing_dirs:
        raise SystemExit(f"Exports absents au commit source : {missing_dirs}")
    if not blobs:
        raise SystemExit("Aucun blob source trouvé.")

    output.mkdir(parents=True, exist_ok=True)
    rows = []
    for number, entry in enumerate(sorted(blobs, key=lambda item: item["path"]), 1):
        path = PurePosixPath(entry["path"])
        if path.is_absolute() or ".." in path.parts:
            raise ValueError(f"Chemin source invalide : {path}")
        target = output.joinpath(*path.parts[1:])
        target.parent.mkdir(parents=True, exist_ok=True)
        blob = request_json(
            f"https://api.github.com/repos/{REPOSITORY}/git/blobs/{entry['sha']}"
        )
        if blob.get("sha") != entry["sha"] or blob.get("encoding") != "base64":
            raise ValueError(f"Réponse blob inattendue pour {path}")
        raw = base64.b64decode(blob.get("content", ""), validate=False)
        if len(raw) != int(entry.get("size", -1)):
            raise ValueError(f"Taille source incorrecte pour {path}: {len(raw)}")
        temporary = target.with_name(target.name + ".download.tmp")
        temporary.write_bytes(raw)
        os.replace(temporary, target)
        rows.append({
            "path": entry["path"],
            "gitBlobSha": entry["sha"],
            "bytes": len(raw),
            "sha256": hashlib.sha256(raw).hexdigest(),
        })
        if number % 10 == 0 or number == len(blobs):
            print(f"Fichiers source récupérés : {number}/{len(blobs)}")

    manifest = {
        "repository": REPOSITORY,
        "commit": COMMIT,
        "readOnly": True,
        "fileCount": len(rows),
        "bytes": sum(row["bytes"] for row in rows),
        "files": rows,
    }
    manifest_path = output.parent / "source_export_recovery_manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"PASS — {len(rows)} fichiers ({manifest['bytes']} octets) dans {output}")
    print(f"Provenance : {manifest_path.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
