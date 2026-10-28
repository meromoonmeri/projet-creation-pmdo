#!/usr/bin/env python3
"""Ajoute les 12 salles de la guilde Treehouse (`kit.json`) à la galerie.

Chaque salle existe en PNG jour et nuit, versionnés à la racine (`salles/<dossier>/`).
La galerie garde la vignette **jour** ; la nuit est signalée dans la fiche.

    .venv/bin/python source/galerie_maps/preparer_salles.py
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT_THUMBS = ROOT / "apercus" / "galerie_maps"
SORTIE = HERE / "galerie_salles.json"
MAXI = 640

sys.path.insert(0, str(HERE))
from preparer_branche import vignette  # noqa: E402  (mêmes règles de compression)


def main() -> int:
    kit = json.loads((ROOT / "kit.json").read_text())
    unites = []
    for salle in kit["salles"]:
        nom = salle["nom"]
        fichier = ROOT / salle["fichiers"]["jour"]["png"]
        if not fichier.exists():
            print(f"! salle absente : {fichier}", file=sys.stderr)
            continue
        nuit = ROOT / salle["fichiers"]["nuit"]["png"]
        with Image.open(fichier) as im:
            im.load()
            etiquette = f"guilde_{salle['id']}"
            nomfichier = re.sub(r"[^a-z0-9]+", "_", f"guilde_{salle['id']}_{nom}".lower()).strip("_") + ".png"
            l, h, vl, vh, sortie = vignette(im, OUT_THUMBS / nomfichier)
        unites.append({
            "lot": f"guilde/{salle['dossier']}", "sous_map": "", "etiquette": etiquette,
            "titre": f"{salle['id']} · {nom}",
            "categorie": "guilde", "categorie_label": "Guilde, café & intérieurs",
            "nature": "rendu", "present": True,
            "source": salle["fichiers"]["jour"]["png"] + (" + variante nuit" if nuit.exists() else ""),
            "source_taille": [l, h], "vignette_taille": [vl, vh],
            "vignette": sortie.relative_to(ROOT).as_posix(),
            "dimensions": salle.get("dimensions"), "cellules": salle.get("cellules"),
            "acces": salle.get("acces"),
        })
        print(f"+ {salle['id']} {nom} {l}×{h}", file=sys.stderr)
    SORTIE.write_text(json.dumps({"unites": unites}, ensure_ascii=False, indent=1))
    print(f"galerie_salles.json : {len(unites)} salles", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
