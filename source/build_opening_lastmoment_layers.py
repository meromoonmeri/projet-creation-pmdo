#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Décors de l'Opening « Last Moment » : TEXTURES CANONIQUES des intros de PMD Explorers of Sky (références fournies dans
`source/pmd_destiny_fangame_v1/references_sky_intro/`), découpées par `build_opening_sky_layers.py` — aucune plaque générée :
Lapras (ciel + mer), Plains (montagnes + arbres/chemin), Moonlight (nuit étoilée + lune), Sky Peak Summit (prairie fleurie)."""
from __future__ import annotations

from typing import Dict

from PIL import Image

try:
    from source.build_opening_sky_layers import build_layers  # type: ignore
except ImportError:  # exécution directe
    from build_opening_sky_layers import build_layers  # type: ignore

# nom du calque dans le moteur : clé de build_layers()
CANON = {
    "laprasSky": "laprasSky", "laprasSea": "laprasSea", "moonBg": "moonBg", "moonFg": "moonFg",
    "plainsFar": "plainsFar", "plainsTree": "plainsTree", "skyPeak": "skyPeak",
}


def build_lastmoment_layers() -> Dict[str, Image.Image]:
    L = build_layers()
    return {k: L[v].convert("RGBA") for k, v in CANON.items()}


if __name__ == "__main__":
    for k, im in build_lastmoment_layers().items():
        print(k, im.size)
