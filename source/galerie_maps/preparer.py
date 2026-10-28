#!/usr/bin/env python3
"""Prépare la galerie exhaustive des maps : une vignette PNG par unité de map.

Les rendus complets (4,6 Go) ne sont pas dans ce dépôt allégé : ce script repère, dans
l'arbre du dépôt source `meromoonmeri/projet-pmdo` au commit de référence, **une image
représentative par map** (composition statique `*_scene_t000.png`, sinon `composite`,
`composition`, planche, vue d'ensemble), la télécharge, la réduit à 640 px de large au
plus et la versionne dans `apercus/galerie_maps/`.

    .venv/bin/python source/galerie_maps/preparer.py             # tout
    .venv/bin/python source/galerie_maps/preparer.py --limite 5  # essai

Sortie : `source/galerie_maps/galerie.json` (recensement complet, y compris les lots
sans image) + les vignettes. Aucune image n'est modifiée dans le dépôt source.
"""
from __future__ import annotations

import argparse
import io
import json
import re
import subprocess
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT_THUMBS = ROOT / "apercus" / "galerie_maps"
GALERIE = HERE / "galerie.json"
ARBRE = HERE / "arbre_renders.json"

DEPOT = "meromoonmeri/projet-pmdo"
COMMIT = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
MAXI = 640          # largeur maximale d'une vignette
ECART_PALETTE = 2.5  # écart RVB moyen toléré pour la compression en palette 255

IMAGE = re.compile(r"\.(png|jpe?g)$", re.I)
# dossiers qui contiennent des calques, bruts ou frames : jamais une composition
EXCLUS = {"layers", "calques", "bruts", "animation", "poses", "frames", "tilesheets",
          "tileset", "atlas", "sprites", "frames_", "ecartes", "masques", "tiles"}


# --------------------------------------------------------------------------- catégories
CATEGORIES = [
    ("entree", "Entrées de donjon", r"^entree"),
    ("fin", "Fins de donjon", r"^fin_"),
    ("arene", "Arènes de boss", r"^arene_"),
    ("zone", "Zones & routes", r"^zone_|^zones_|^network_|^map_zones|^route_|^ruines_|^colonnes_"),
    ("guilde", "Guilde, café & intérieurs",
     r"guilde|maison|kiosque|tente|dojo|cafe|casino|spinda|halcyon|ledian|antre_"),
    ("monde", "Cartes du monde", r"world_map|continents|panorama"),
    ("cotes", "Côtes, Métano & falaises",
     r"cote|beach|caps_|metano|falaise|lisiere|northern|amp_plains|applewood|sky_peak|spring|soleil"),
    ("donjon", "Donjons générés & donjons PMD", r"donjon|dungeon|steam_cave|waterfall_lake|jungle_geysers|"
                                                 r"siphon|eau_|mont_horn|mont_|tours_|tour_|boreales|"
                                                 r"boreale|foret_|cendres|sky_grass"),
    ("divers", "Décors, animations & autres lots", r".*"),
]


def categorie(nom: str) -> tuple[str, str]:
    for cle, label, motif in CATEGORIES:
        if re.search(motif, nom, re.I):
            return cle, label
    return "divers", "Décors, animations & autres lots"


# --------------------------------------------------------------------------- recensement
def arbre() -> list[dict]:
    """Entrées de l'arbre du dépôt source (cache local, recréé au besoin)."""
    if ARBRE.exists():
        return json.loads(ARBRE.read_text())["tree"]
    print(f"→ lecture de l'arbre {DEPOT}@{COMMIT[:7]}…", file=sys.stderr)
    sortie = subprocess.run(
        ["gh", "api", f"repos/{DEPOT}/git/trees/{COMMIT}?recursive=1"],
        capture_output=True, text=True, check=True).stdout
    donnees = json.loads(sortie)
    if donnees.get("truncated"):
        raise SystemExit("arbre tronqué : relancer avec l'API par dossier")
    garde = [{"path": e["path"], "type": e["type"], "size": e.get("size", 0), "sha": e["sha"]}
             for e in donnees["tree"]
             if e["path"].startswith("renders/") and e["type"] == "blob"]
    ARBRE.write_text(json.dumps({"commit": COMMIT, "tree": garde}, ensure_ascii=False))
    return garde


def est_image(e: dict) -> bool:
    return IMAGE.search(e["path"]) is not None


def dans_dossier_exclu(chemin: str) -> bool:
    morceaux = [m.lower() for m in chemin.split("/")[2:-1]]
    return any(any(m.startswith(x) for x in EXCLUS) for m in morceaux)


def choix_par_lot(entrees: list[dict]) -> list[dict]:
    """Une unité par sous-map `*/review/*_scene_t000.png`, sinon une par lot."""
    lots: dict[str, list[dict]] = {}
    for e in entrees:
        if est_image(e) and e["path"].startswith("renders/"):
            lots.setdefault(e["path"].split("/")[1], []).append(e)

    unites = []
    for lot in sorted(lots):
        images = [e for e in lots[lot] if not e["path"].lower().endswith(".zip")]
        scenes: dict[str, dict] = {}
        for e in images:
            m = re.search(r"^(renders/[^/]+(?:/[^/]+)?)/review/[^/]*_scene_t0*0\.png$", e["path"])
            if m and (m.group(1) != f"renders/{lot}" or True):
                scenes[m.group(1)] = e  # la dernière trouvée gagne, une seule par sous-lot
        if scenes and len(scenes) > 1:
            for base in sorted(scenes):
                sous = base.split("/")[-1] if base != f"renders/{lot}" else ""
                unites.append({"lot": lot, "sous_map": sous, "image": scenes[base]})
            continue
        unites.append({"lot": lot, "sous_map": "", "image": choisir(images)})
    return unites


def choisir(images: list[dict]) -> dict | None:
    """Hiérarchie de préférence : composition statique > composite > planche > vue > racine."""
    if not images:
        return None

    def tiers(e: dict) -> tuple:
        p = e["path"]
        nom = p.rsplit("/", 1)[-1].lower()
        exclus = dans_dossier_exclu(p)
        t = 9
        if re.search(r"_scene_t0*0\.png$", nom):
            t = 0
        elif "composite" in nom:
            t = 1
        elif "composition" in nom:
            t = 2
        elif re.search(r"planche|vue_ensemble|apercu", nom) and p.count("/") == 2:
            t = 3
        elif p.count("/") == 2:                     # fichier à la racine du lot
            t = 4
        elif not exclus:
            t = 5
        elif not exclus:
            t = 6
        taille = e.get("size", 0)
        pen = 0
        if "collisions" in nom or "marqueur" in nom or "animee" in nom or nom.endswith(".webp"):
            pen += 4
        if taille > 14e6 or taille < 30e3:
            pen += 2
        return (t + pen + (1 if exclus else 0), -taille)

    return sorted(images, key=tiers)[0]


# --------------------------------------------------------------------------- téléchargement
def telecharger(sha: str) -> bytes:
    return subprocess.run(
        ["gh", "api", "-H", "Accept: application/vnd.github.raw",
         f"repos/{DEPOT}/git/blobs/{sha}"],
        capture_output=True, check=True).stdout


def vignette(brut: bytes, nom: Path) -> tuple[int, int, int, int, Path]:
    """Réduit à MAXI px et compresse : PNG palette si fidèle, sinon WebP haute qualité."""
    im = Image.open(io.BytesIO(brut))
    im.load()
    largeur, hauteur = im.size
    if im.mode not in ("RGB", "RGBA"):
        im = im.convert("RGBA")
    if largeur > MAXI:
        h = max(1, round(hauteur * MAXI / largeur))
        im = im.resize((MAXI, h), Image.LANCZOS)
    OUT_THUMBS.mkdir(parents=True, exist_ok=True)
    source = im.convert("RGBA")
    pal = source.quantize(colors=255, method=Image.FASTOCTREE)
    ecart = ecart_moyen(source, pal.convert("RGBA"))
    if ecart <= ECART_PALETTE:
        pal.save(nom, optimize=True)
        return largeur, hauteur, im.width, im.height, nom
    webp = nom.with_suffix(".webp")
    source.save(webp, "WEBP", quality=92, method=6)
    return largeur, hauteur, im.width, im.height, webp


def ecart_moyen(a: Image.Image, b: Image.Image) -> float:
    """Écart RVB moyen (0–255) entre deux images de même taille."""
    from PIL import ImageChops, ImageStat
    return sum(ImageStat.Stat(ImageChops.difference(a.convert("RGB"), b.convert("RGB"))).mean) / 3


def titre(cle: str) -> str:
    """`entree_caverne_cristal_sud_nord_v1` → « Entree caverne cristal sud nord v1 »."""
    return cle.replace("_", " ").strip().capitalize()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--limite", type=int, default=0)
    ap.add_argument("--force", action="store_true", help="retélécharger les vignettes existantes")
    args = ap.parse_args()

    entrees = arbre()
    unites = choix_par_lot(entrees)
    if args.limite:
        unites = unites[:args.limite]
    print(f"{len(unites)} unités de map recensées", file=sys.stderr)

    resultat = []
    for i, u in enumerate(unites, 1):
        lot, sous = u["lot"], u["sous_map"]
        etiquette = f"{lot}/{sous}" if sous else lot
        img = u["image"]
        fiche = {"lot": lot, "sous_map": sous, "etiquette": etiquette,
                 "titre": titre(sous or lot)}
        cle, label = categorie(lot)
        fiche["categorie"], fiche["categorie_label"] = cle, label
        if img is None:
            fiche.update(image=None, vignette=None, present=False)
            resultat.append(fiche)
            continue
        nom_fichier = re.sub(r"[^a-z0-9]+", "_", etiquette.lower()).strip("_") + ".png"
        sortie = OUT_THUMBS / nom_fichier
        fiche["source"] = img["path"]
        fiche["octets_source"] = img.get("size", 0)
        fiche["vignette"] = f"apercus/galerie_maps/{nom_fichier}"
        if sortie.exists() and not args.force:
            with Image.open(sortie) as vign:
                fiche["vignette_taille"] = list(vign.size)
            fiche["present"] = True
            print(f"[{i}/{len(unites)}] = {etiquette}", file=sys.stderr)
            resultat.append(fiche)
            continue
        try:
            brut = telecharger(img["sha"])
            l, h, vl, vh, sortie = vignette(brut, sortie)
            fiche["vignette"] = sortie.relative_to(ROOT).as_posix()
        except Exception as exc:                                # noqa: BLE001
            print(f"[{i}/{len(unites)}] ! {etiquette} : {exc}", file=sys.stderr)
            fiche.update(image=None, vignette=None, present=False, erreur=str(exc))
            resultat.append(fiche)
            continue
        fiche.update(present=True, source_taille=[l, h], vignette_taille=[vl, vh])
        print(f"[{i}/{len(unites)}] + {etiquette} {l}×{h} → {vl}×{vh}", file=sys.stderr)
        resultat.append(fiche)

    GALERIE.write_text(json.dumps({"commit": COMMIT, "unites": resultat}, ensure_ascii=False, indent=1))
    avec = sum(1 for f in resultat if f.get("present"))
    print(f"galerie.json : {len(resultat)} unités, {avec} avec vignette", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
