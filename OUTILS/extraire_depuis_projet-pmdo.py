#!/usr/bin/env python3
"""Extraction reproductible des méthodes de meromoonmeri/projet-pmdo.

Principe : clone *blobless* (--filter=blob:none) + sparse-checkout par chemins exacts.
Git ne télécharge QUE les blobs demandés : on obtient les méthodes (scripts, docs,
données PMDO natives, kits de salles) sans les 6 Go de rendus.

Exemples
--------
# les méthodes seules (≈ 169 Mo) vers ./projet-creation-pmdo
python3 extraire_depuis_projet-pmdo.py --out ../projet-creation-pmdo

# tout, média compris (≈ 6,2 Go) : déconseillé
python3 extraire_depuis_projet-pmdo.py --out ../tout --avec-media

# un seul chantier, médias compris
python3 extraire_depuis_projet-pmdo.py --out ../jungle --seulement source/entree_jungle_sud_nord_v1

# lister d'abord ce qui serait pris (aucun téléchargement)
python3 extraire_depuis_projet-pmdo.py --out /tmp/x --liste-seulement
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import subprocess
import sys
import urllib.request

REPO = "meromoonmeri/projet-pmdo"

TEXT = {".md", ".py", ".cjs", ".js", ".tsx", ".ts", ".lua", ".cs", ".json", ".txt", ".xml",
        ".yml", ".yaml", ".csv", ".npz", ".idx", ".resx", ".cfg", ".ini", ".toml", ".sh",
        ".bat", ".ps1", ".jsonpatch", ".gitignore", ".editorconfig"}
PMDO = {".rsground", ".tile", ".tmj", ".tsj", ".chara", ".dir", ".rsmap", ".rszone"}
MEDIA = {".png", ".webp", ".jpg", ".jpeg", ".gif"}
ASSETS_LEGERS = ("salles/", "calques/", "fenetres_exterieur/", "exterieur/", "apercus/",
                 "tiled/", "audits/", "image-search/", "guides/")


def extension(path: str) -> str:
    nom = path.rsplit("/", 1)[-1]
    return ("." + nom.rsplit(".", 1)[-1].lower()) if "." in nom else ""


def arbre(repo: str, ref: str, token: str | None) -> list[dict]:
    url = f"https://api.github.com/repos/{repo}/git/trees/{ref}?recursive=1"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req) as r:
        data = json.load(r)
    if data.get("truncated"):
        sys.exit("Arbre tronqué par l'API : utiliser un SHA de sous-arbre.")
    return data["tree"]


def selection(blobs: list[dict], avec_media: bool, seulement: str | None) -> list[str]:
    garde = []
    for e in blobs:
        p = e["path"]
        if seulement and not p.startswith(seulement):
            continue
        x = extension(p)
        if avec_media:
            garde.append(p)
            continue
        if x in TEXT or x in PMDO:
            garde.append(p)
        elif x == ".html":
            if p.startswith("source/") and e.get("size", 0) < 600_000:
                garde.append(p)                       # visionneuses de chantier
        elif x in MEDIA:
            if p.startswith(ASSETS_LEGERS) or (p.startswith("source/") and e.get("size", 0) < 120_000):
                garde.append(p)                       # kits de salles + gabarits légers
    return garde


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=REPO)
    ap.add_argument("--ref", default="main")
    ap.add_argument("--out", required=True, help="dossier de destination")
    ap.add_argument("--token", default=None, help="token GitHub (dépôt privé / quota API)")
    ap.add_argument("--avec-media", action="store_true", help="tout prendre, y compris les rendus")
    ap.add_argument("--seulement", default=None, help="ne prendre qu'un préfixe de chemin")
    ap.add_argument("--liste-seulement", action="store_true")
    a = ap.parse_args()

    arbre_git = arbre(a.repo, a.ref, a.token)
    blobs = [e for e in arbre_git if e["type"] == "blob"]
    chemins = sorted(selection(blobs, a.avec_media, a.seulement))
    taille = sum(e.get("size", 0) for e in blobs if e["path"] in set(chemins))
    print(f"{len(blobs)} fichiers dans {a.repo}@{a.ref}")
    print(f"{len(chemins)} retenus — {taille/1024**2:.1f} Mo")
    if a.liste_seulement:
        print("\n".join(chemins))
        return

    tmp = pathlib.Path(a.out).resolve().parent / f"._extraction_{a.repo.split('/')[-1]}"
    if tmp.exists():
        subprocess.run(["rm", "-rf", str(tmp)], check=True)
    subprocess.run(["git", "clone", "--filter=blob:none", "--no-checkout", "--depth", "1",
                    "-q", f"https://github.com/{a.repo}.git", str(tmp)], check=True)
    subprocess.run(["git", "-C", str(tmp), "sparse-checkout", "init", "--no-cone"], check=True)

    motifs = []
    for p in chemins:
        p = re.sub(r"([*?\[\]\\])", r"\\\1", p).replace("!", "\\!")
        motifs.append("/" + p)
    subprocess.run(["git", "-C", str(tmp), "sparse-checkout", "set", "--stdin"],
                   input="\n".join(motifs).encode(), check=True)
    subprocess.run(["git", "-C", str(tmp), "checkout", "-q"], check=True)

    dest = pathlib.Path(a.out).resolve()
    dest.mkdir(parents=True, exist_ok=True)
    subprocess.run(["bash", "-c",
                    f'cd "{tmp}" && find . -path ./.git -prune -o -type f -print | sed "s|^\\./||" | '
                    f'while IFS= read -r f; do mkdir -p "{dest}/$(dirname "$f")"; cp -p "$f" "{dest}/$f"; done'],
                   check=True)
    subprocess.run(["rm", "-rf", str(tmp)], check=True)
    n = sum(1 for _ in dest.rglob("*") if _.is_file())
    print(f"OK — {n} fichiers dans {dest}")


if __name__ == "__main__":
    main()
