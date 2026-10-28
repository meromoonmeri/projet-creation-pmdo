#!/usr/bin/env python3
"""Rapatrie **physiquement** dans la branche les maps finales du dépôt source.

Chaque map recensée par la galerie existe comme composition PNG native dans
`meromoonmeri/projet-pmdo` (`renders/…`, 4,6 Go au total). Ce script en copie les
**octets exacts** dans `maps/<lot>/[<sous-map>/]<nom d'origine>.png` — aucune
ré-encodage, aucun redimensionnement — et tient à jour `maps/MANIFESTE_MAPS.json`.

Intégrité : chaque blob est vérifié par son **sha1 git** (`sha1("blob <taille>\\0" + octets)`),
donc le fichier écrit est bit pour bit celui du dépôt source. Le manifeste garde aussi le
sha256 de sortie.

    .venv/bin/python source/galerie_maps/rapatrier.py --categories entree,fin,arene,zone,guilde
    .venv/bin/python source/galerie_maps/rapatrier.py --tout
    .venv/bin/python source/galerie_maps/rapatrier.py --verifier        # relit le manifeste

Le cache de téléchargement vit dans `.cache/rapatriement/` (hors dépôt).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GALERIE = HERE / "galerie.json"
GALERIE_BRANCHE = HERE / "galerie_branche.json"
DEST = ROOT / "maps"
MANIFESTE = DEST / "MANIFESTE_MAPS.json"
CACHE = ROOT / ".cache" / "rapatriement"
DEPOT = "meromoonmeri/projet-pmdo"
COMMIT = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"


def sha1_git(donnees: bytes) -> str:
    return hashlib.sha1(b"blob %d\x00" % len(donnees) + donnees).hexdigest()


def telecharger(sha: str) -> bytes:
    CACHE.mkdir(parents=True, exist_ok=True)
    cache = CACHE / sha
    if cache.exists():
        return cache.read_bytes()
    brut = subprocess.run(
        ["gh", "api", "-H", "Accept: application/vnd.github.raw",
         f"repos/{DEPOT}/git/blobs/{sha}"],
        capture_output=True, check=True).stdout
    if sha1_git(brut) != sha:
        raise SystemExit(f"blob corrompu : {sha}")
    cache.write_bytes(brut)
    return brut


def charger_unites() -> list[dict]:
    """Unités illustrées et rapatriables (dépôt source), plus celles de la branche."""
    unites = []
    if GALERIE.exists():
        for u in json.loads(GALERIE.read_text())["unites"]:
            if u.get("present") and u.get("source", "").startswith("renders/"):
                u["_origine"] = "source"
                unites.append(u)
    if GALERIE_BRANCHE.exists():
        for u in json.loads(GALERIE_BRANCHE.read_text())["unites"]:
            u["_origine"] = "branche"
            unites.append(u)
    return unites


def chemin_local(u: dict) -> Path:
    """`maps/<lot>/[<sous-map>/]<nom d'origine>` — jamais deux fois le même nom."""
    nom = Path(u["source"]).name
    morceaux = [u["lot"]] + ([u["sous_map"]] if u.get("sous_map") else [])
    return DEST.joinpath(*morceaux, nom)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--categories", default="", help="liste séparée par des virgules")
    ap.add_argument("--tout", action="store_true", help="toutes les maps illustrées")
    ap.add_argument("--verifier", action="store_true", help="seulement relire le manifeste")
    args = ap.parse_args()

    unites = charger_unites()
    entrees = json.loads(MANIFESTE.read_text())["maps"] if MANIFESTE.exists() else []
    index = {(m["lot"], m.get("sous_map") or ""): m for m in entrees}

    if args.verifier:
        manquants, faux = [], []
        for m in entrees:
            f = ROOT / m["fichier"]
            if not f.exists():
                manquants.append(m["fichier"])
            elif hashlib.sha256(f.read_bytes()).hexdigest() != m["sha256"]:
                faux.append(m["fichier"])
        print(f"{len(entrees)} maps au manifeste — {len(manquants)} absentes, {len(faux)} altérées")
        return 0 if not (manquants or faux) else 1

    cats = [c.strip() for c in args.categories.split(",") if c.strip()]
    cibles = [u for u in unites
              if u.get("_origine") == "source"
              and (args.tout or not cats or u["categorie"] in cats)]
    if not cibles:
        print("rien à faire", file=sys.stderr)
        return 0

    faits = 0
    octets = 0
    for i, u in enumerate(cibles, 1):
        dest = chemin_local(u)
        if dest.exists():
            print(f"[{i}/{len(cibles)}] = {dest.relative_to(ROOT)}", file=sys.stderr)
            continue
        sha = u.get("blob") or None
        if not sha:
            # le sha du blob n'est pas dans galerie.json : on le retrouve par l'arbre
            sha = sha_de(u["source"])
        donnees = telecharger(sha)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(donnees)
        faits += 1
        octets += len(donnees)
        index[(u["lot"], u.get("sous_map") or "")] = {
            "lot": u["lot"], "sous_map": u.get("sous_map") or "", "etiquette": u["etiquette"],
            "titre": u["titre"], "categorie": u["categorie"], "categorie_label": u["categorie_label"],
            "fichier": dest.relative_to(ROOT).as_posix(), "octets": len(donnees),
            "sha256": hashlib.sha256(donnees).hexdigest(),
            "blob_git": sha, "source": u["source"], "commit_source": COMMIT,
            "source_taille": u.get("source_taille"),
            "_note": u.get("nature_label"),
        }
        print(f"[{i}/{len(cibles)}] + {dest.relative_to(ROOT)} {len(donnees) / 1e3:.0f} ko",
              file=sys.stderr)

    DEST.mkdir(parents=True, exist_ok=True)
    maps = sorted(index.values(), key=lambda m: m["fichier"])
    MANIFESTE.write_text(json.dumps({
        "commit_source": COMMIT, "depot_source": DEPOT,
        "integrite": "sha1 git du blob vérifié au téléchargement ; sha256 du fichier écrit",
        "maps": maps}, ensure_ascii=False, indent=1))
    total = sum(m["octets"] for m in maps)
    print(f"{len(maps)} maps au manifeste, {total / 1e6:.1f} Mo ; "
          f"{faits} rapatriées ce passage ({octets / 1e6:.1f} Mo)", file=sys.stderr)
    return 0


_ARBRE_CACHE: dict[str, str] = {}


def sha_de(chemin: str) -> str:
    """sha du blob pour un chemin du dépôt source (cache local de l'arbre)."""
    if not _ARBRE_CACHE:
        arbre = HERE / "arbre_renders.json"
        if not arbre.exists():
            brut = subprocess.run(
                ["gh", "api", f"repos/{DEPOT}/git/trees/{COMMIT}?recursive=1"],
                capture_output=True, check=True).stdout
            donnees = json.loads(brut)
            arbre.write_text(json.dumps({"tree": [
                {"path": e["path"], "type": e["type"], "size": e.get("size", 0), "sha": e["sha"]}
                for e in donnees["tree"] if e["type"] == "blob"]}, ensure_ascii=False))
        _ARBRE_CACHE.update({e["path"]: e["sha"] for e in json.loads(arbre.read_text())["tree"]})
    return _ARBRE_CACHE[chemin]


if __name__ == "__main__":
    raise SystemExit(main())
