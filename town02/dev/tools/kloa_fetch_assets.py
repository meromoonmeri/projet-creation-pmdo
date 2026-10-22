#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Récupération authentifiée des assets Unity de Kloa - Child of the Forest.

Source : meromoonmeri/BIBLIOTHEQUE branche `bibliotheque`, dossier
`Kloa - Child of the Forest Demo/` (jeu Unity). Les fichiers sont stockés en
Git LFS : chaque blob git est un pointeur `oid sha256:… size …`.

Le script :
  1. lit l'arbre git de la branche (API GitHub, token gh) ;
  2. pour chaque fichier d'assets Unity (level*, sharedassets*, resS,
     resource, globalgamemanagers*), télécharge le blob ;
  3. si c'est un pointeur LFS, résout l'URL via l'API batch LFS puis
     télécharge le contenu réel ;
  4. vérifie le SHA-256 annoncé par le pointeur (hash-lock) ;
  5. écrit tout dans .runtime-cache/kloa/source/ (git-ignoré).

Aucun contenu n'est commité : c'est un cache d'extraction, comme
.runtime-cache/no-name-village pour NNV.
"""
from __future__ import annotations

import base64
import hashlib
import json
import subprocess
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / ".runtime-cache" / "kloa" / "source"
REPO = "meromoonmeri/BIBLIOTHEQUE"
BRANCH = "bibliotheque"
PREFIX = "Kloa - Child of the Forest Demo/Kloa - Child of the Forest_Data/"

USEFUL = ("level", "sharedassets", "globalgamemanagers", "resources.assets",
          ".resS", ".resource", "unity default resources")


def gh_token() -> str:
    return subprocess.run(["gh", "auth", "token"], capture_output=True,
                          text=True, check=True).stdout.strip()


def api(path: str) -> dict:
    r = subprocess.run(["gh", "api", path], capture_output=True, check=True)
    return json.loads(r.stdout)


def lfs_batch(objects: list[dict], token: str) -> dict:
    req = urllib.request.Request(
        f"https://github.com/{REPO}.git/info/lfs/objects/batch",
        data=json.dumps({"operation": "download", "transfers": ["basic"],
                         "objects": objects}).encode(),
        headers={
            "Accept": "application/vnd.git-lfs+json",
            "Content-Type": "application/vnd.git-lfs+json",
            "Authorization": "Basic " + base64.b64encode(
                f"x-access-token:{token}".encode()).decode(),
        })
    with urllib.request.urlopen(req) as f:
        return json.load(f)


def fetch_url(url: str, dest: Path, expected_oid: str, expected_size: int) -> None:
    h = hashlib.sha256()
    with urllib.request.urlopen(url) as r, open(dest, "wb") as w:
        while True:
            chunk = r.read(1 << 20)
            if not chunk:
                break
            h.update(chunk)
            w.write(chunk)
    if h.hexdigest() != expected_oid:
        dest.unlink(missing_ok=True)
        raise RuntimeError(f"SHA-256 mismatch pour {dest.name}")
    if dest.stat().st_size != expected_size:
        dest.unlink(missing_ok=True)
        raise RuntimeError(f"taille inattendue pour {dest.name}")


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    token = gh_token()
    tree = api(f"repos/{REPO}/git/trees/{BRANCH}?recursive=1")
    files = [e for e in tree["tree"]
             if e["type"] == "blob" and e["path"].startswith(PREFIX)
             and any(k in e["path"].lower() for k in USEFUL)]
    print(f"{len(files)} fichiers d'assets Unity à récupérer")
    manifest = {}
    pointers = []       # (name, oid, size)
    for e in files:
        name = e["path"][len(PREFIX):]
        if "/" in name:
            continue                     # sous-dossiers (Managed etc.) inutiles
        dest = OUT / name
        blob = api(f"repos/{REPO}/git/blobs/{e['sha']}")
        raw = base64.b64decode(blob["content"])
        if raw.startswith(b"version https://git-lfs.github.com/spec/v1"):
            text = raw.decode()
            oid = text.split("oid sha256:")[1].split()[0]
            size = int(text.split("size ")[1].split()[0])
            if dest.exists() and dest.stat().st_size == size:
                manifest[name] = {"oid": oid, "size": size, "cached": True}
                continue
            pointers.append((name, oid, size))
        else:
            dest.write_bytes(raw)
            manifest[name] = {"size": len(raw), "direct": True}
    print(f"{len(pointers)} pointeurs LFS à résoudre, "
          f"{sum(s for _, _, s in pointers)/1e6:.0f} MB")
    # batch par 50
    for i in range(0, len(pointers), 50):
        batch = pointers[i:i+50]
        resp = lfs_batch([{"oid": o, "size": s} for _, o, s in batch], token)
        by_oid = {o["oid"]: o for o in resp["objects"]}
        for name, oid, size in batch:
            obj = by_oid.get(oid)
            if not obj or "actions" not in obj:
                print(f"  !! pas d'URL pour {name}")
                continue
            url = obj["actions"]["download"]["href"]
            fetch_url(url, OUT / name, oid, size)
            manifest[name] = {"oid": oid, "size": size}
            print(f"  OK {name} ({size/1e6:.1f} MB)")
    (OUT.parent / "manifest.json").write_text(
        json.dumps({"repo": REPO, "branch": BRANCH, "prefix": PREFIX,
                    "files": manifest}, indent=1))
    total = sum(f.stat().st_size for f in OUT.iterdir())
    print(f"terminé: {len(manifest)} fichiers, {total/1e6:.0f} MB dans {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
