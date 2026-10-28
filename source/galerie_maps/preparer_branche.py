#!/usr/bin/env python3
"""Complète la galerie : tous les lots de **cette branche** qui ne sont pas dans le dépôt
source allégé (`renders/` du dépôt `projet-pmdo` @ `6cca4a0`).

Deux familles d'images, dans cet ordre de préférence :

1. **aperçu autonome local** — `apercu_<lot>.html` embarque son manifeste `const D={…}` avec
   les calques en data-URI : on recompose le calque 0 de chaque étage de `D.stack` ;
2. **calques versionnés** — `renders/<lot>/layers/*.png` réellement commités (mont_lointain,
   mont_foudre, mont_brasier, mine_magma, foret_givree, faille_spatiale, tour_celeste).

Les lots sans aucune image versionnée restent recensés avec `present = false` et la raison :
rien n'est inventé. Sortie : `galerie_branche.json` (+ vignettes dans `apercus/galerie_maps/`).

    .venv/bin/python source/galerie_maps/preparer_branche.py
"""
from __future__ import annotations

import base64
import io
import json
import re
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT_THUMBS = ROOT / "apercus" / "galerie_maps"
SORTIE = HERE / "galerie_branche.json"
GALERIE_SOURCE = HERE / "galerie.json"

sys.path.insert(0, str(HERE))
from preparer import MAXI, categorie, titre  # noqa: E402  (même règles de nommage)

# dossiers de `source/` et `renders/` qui ne sont pas des cartes
HORS_MAP = {
    "serveur_apercus", "pmdo_cote", "pmdo_runtime", "pokemon_custom", "sprite_audit_v2",
    "tera_v2", "transformations_v1", "guild_members_audit", "outil_maps_pmdsky",
    "outil_maps_pmdred", "pmd_character_pipeline", "assets_gba_pmd_red", "natives",
    "commit_d5_refs", "paysage_reference", "galerie_maps", "generator_v3", "zones_bg_audit_v1",
    "layouts_commit_3b185b", "layouts_commit_3bc185b", "cine_pichu_dazzling", "compat_town02",
    "guild_scene_animations_v1", "guild_scene_animations_v2", "guild_scene_recovery_v5",
    "guild_structures_v1", "vegetation_treehouse_v1", "ensemble", "commun",
}


def data_du_manifeste(page: Path) -> dict | None:
    """Extrait `const D={…}` d'un aperçu autonome (JSON brut, décodé par raw_decode)."""
    txt = page.read_text(encoding="utf-8", errors="ignore")
    m = re.search(r"const D\s*=\s*", txt)
    if not m:
        return None
    try:
        obj, _ = json.JSONDecoder().raw_decode(txt, m.end())
    except json.JSONDecodeError:
        return None
    return obj if isinstance(obj, dict) and obj.get("stack") else None


def uri_vers_image(uri: str) -> Image.Image | None:
    m = re.match(r"data:image/\w+;base64,(.+)$", uri, re.S)
    if not m:
        return None
    try:
        im = Image.open(io.BytesIO(base64.b64decode(m.group(1))))
        im.load()
        return im.convert("RGBA")
    except Exception:                                            # noqa: BLE001
        return None


def composer(images: list[Image.Image]) -> Image.Image:
    """Pose les images du bas vers le haut, alpha compris, sur le canevas du plus grand."""
    largeur = max(i.width for i in images)
    hauteur = max(i.height for i in images)
    fond = Image.new("RGBA", (largeur, hauteur), (0, 0, 0, 0))
    for im in images:
        fond.alpha_composite(im, (0, 0))
    return fond


def depuis_apercu(lot: str) -> tuple[Image.Image, str] | None:
    page = ROOT / f"apercu_{lot}.html"
    if not page.exists():
        return None
    manifeste = data_du_manifeste(page)
    if not manifeste:
        return None
    calques = []
    for etage in manifeste["stack"]:
        frames = etage.get("frames") or []
        if not frames:
            continue
        im = uri_vers_image(frames[0])
        if im is not None:
            calques.append(im)
    if not calques:
        return None
    return composer(calques), f"apercu_{lot}.html (manifeste embarqué, {len(calques)} calques)"


def depuis_calques(lot: str) -> tuple[Image.Image, str] | None:
    dossier = ROOT / "renders" / lot / "layers"
    if not dossier.is_dir():
        return None
    fichiers = sorted(dossier.glob("*.png"))
    if not fichiers:
        return None
    calques = []
    for f in fichiers:
        with Image.open(f) as im:
            im.load()
            calques.append(im.convert("RGBA"))
    return composer(calques), f"renders/{lot}/layers ({len(calques)} PNG versionnés)"


def part_magenta(im: Image.Image) -> float:
    """Fraction de pixels magenta/violet vif (fond à détourer) — un brut non final."""
    petit = im.convert("RGB").resize((min(160, im.width), max(1, round(im.height * min(160, im.width) / im.width))))
    pixels = list(petit.getdata())
    if not pixels:
        return 0.0
    n = sum(1 for r, g, b in pixels
            if r > 200 and b > 200 and g < 110)
    return n / len(pixels)


def depuis_bruts(lot: str) -> tuple[Image.Image, str, str] | None:
    """Rendus de base versionnés du lot : `source/<lot>/bruts/base_*.png` (composition
    générée référencée), puis `decor_*_magenta.png`, puis la référence canonique."""
    dossier = ROOT / "source" / lot
    for motif, nature, quoi in (
            ("bruts/base_*.png", "rendu", "rendu de base généré référencé"),
            ("bruts/decor_*.png", "rendu", "décor généré référencé"),
            ("references/ref_canon_*.png", "reference", "référence canonique PMD"),
    ):
        for fichier in sorted(dossier.glob(motif)):
            with Image.open(fichier) as im:
                im.load()
                image = im.convert("RGBA")
            if part_magenta(image) > 0.01:
                continue        # brut encore troué de magenta : jamais montré comme une map
            return image, f"source/{lot}/{fichier.name}", nature + "|" + quoi
    return None


def vignette(im: Image.Image, nom: Path) -> tuple[int, int, int, int, Path]:
    largeur, hauteur = im.size
    if largeur > MAXI:
        im = im.resize((MAXI, max(1, round(hauteur * MAXI / largeur))), Image.LANCZOS)
    OUT_THUMBS.mkdir(parents=True, exist_ok=True)
    source = im.convert("RGBA")
    pal = source.quantize(colors=255, method=Image.FASTOCTREE)
    from PIL import ImageChops, ImageStat
    ecart = sum(ImageStat.Stat(ImageChops.difference(source.convert("RGB"),
                                                    pal.convert("RGB"))).mean) / 3
    if ecart <= 2.5:
        pal.save(nom, optimize=True)
        return largeur, hauteur, im.width, im.height, nom
    webp = nom.with_suffix(".webp")
    source.save(webp, "WEBP", quality=92, method=6)
    return largeur, hauteur, im.width, im.height, webp


def lots_de_la_branche() -> list[str]:
    noms = set()
    for base in ("source", "renders"):
        d = ROOT / base
        if not d.is_dir():
            continue
        for p in d.iterdir():
            if p.is_dir() and p.name not in HORS_MAP and not p.name.startswith("."):
                noms.add(p.name)
    return sorted(noms)


def main() -> int:
    connus = {u["lot"] for u in json.loads(GALERIE_SOURCE.read_text())["unites"]}
    nouveaux = [l for l in lots_de_la_branche() if l not in connus]
    print(f"{len(nouveaux)} lots de la branche absents du dépôt source", file=sys.stderr)

    unites = []
    for i, lot in enumerate(nouveaux, 1):
        cle, label = categorie(lot)
        fiche = {"lot": lot, "sous_map": "", "etiquette": lot, "titre": titre(lot),
                 "categorie": cle, "categorie_label": label}
        trouve = depuis_apercu(lot) or depuis_calques(lot)
        nature = "rendu"
        if trouve is not None:
            im, provenance = trouve
        else:
            brut = depuis_bruts(lot)
            if brut is not None:
                im, provenance, marque = brut
                nature, quoi = marque.split("|")
                provenance = provenance + " — " + quoi
            else:
                im = None
        if im is None:
            fiche.update(present=False, image=None, vignette=None,
                         raison="aucune image versionnée sur la branche "
                                "(rendus dans le dépôt source projet-pmdo)")
            unites.append(fiche)
            print(f"[{i}/{len(nouveaux)}] – {lot} (pas d'image)", file=sys.stderr)
            continue
        nom = re.sub(r"[^a-z0-9]+", "_", lot.lower()).strip("_") + ".png"
        l, h, vl, vh, sortie = vignette(im, OUT_THUMBS / nom)
        fiche.update(present=True, image=None, nature=nature, source=provenance,
                     source_taille=[l, h], vignette_taille=[vl, vh],
                     vignette=sortie.relative_to(ROOT).as_posix())
        unites.append(fiche)
        print(f"[{i}/{len(nouveaux)}] + {lot} {l}×{h} ← {provenance}", file=sys.stderr)

    SORTIE.write_text(json.dumps({"unites": unites}, ensure_ascii=False, indent=1))
    avec = sum(1 for u in unites if u.get("present"))
    print(f"galerie_branche.json : {len(unites)} lots, {avec} avec vignette", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
