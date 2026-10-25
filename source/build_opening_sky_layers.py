#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Découpe les planches « PMD Explorers of Sky — intro » (références fournies, dossier
`source/pmd_destiny_fangame_v1/references_sky_intro/`) en vraies COUCHES de parallaxe :
fond / plans / avant-plan à clé chroma transparente, échelle de zoom du Shaymin, tunnel Time Travel,
nuages d'orage additifs… C'est la méthode d'intro de PMD Sky (plaques 256×192 superposées, défilement
indépendant par couche, boucles d'images) que l'Opening Destiny réutilise avec les sprites PMDO.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict, List

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

REF = Path(__file__).resolve().parent / "pmd_destiny_fangame_v1" / "references_sky_intro"


def _load(n: str) -> Image.Image:
    return Image.open(REF / n).convert("RGBA")


def _key(im: Image.Image, color, tol: int = 14) -> Image.Image:
    a = np.asarray(im).copy()
    d = np.abs(a[:, :, :3].astype(int) - np.array(color)[None, None, :]).sum(axis=2)
    a[d <= tol, 3] = 0
    return Image.fromarray(a, "RGBA")


def _components(im: Image.Image, min_area: int = 100, dil: int = 2, y_min: int = 0, y_max: int = 99999) -> List[Image.Image]:
    a = np.asarray(im)
    fg = a[:, :, 3] > 0
    fg[:y_min] = False
    fg[y_max:] = False
    lab, n = ndi.label(ndi.binary_dilation(fg, iterations=dil))
    out = []
    for sl in ndi.find_objects(lab):
        ys, xs = sl
        if (ys.stop - ys.start) * (xs.stop - xs.start) < min_area:
            continue
        c = im.crop((xs.start, ys.start, xs.stop, ys.stop))
        c.box = (xs.start, ys.start, xs.stop - xs.start, ys.stop - ys.start)
        out.append(c)
    return out


def build_layers() -> Dict[str, object]:
    L: Dict[str, object] = {}
    # --- Treasure Town (intro) : plaque verticale 256×576 + échelle de zoom du Shaymin
    tt = _load("Treasure_Town.png")
    L["ttSky"] = tt.crop((0, 0, 256, 576))
    sp = _key(tt.crop((258, 0, 608, 576)), (0, 0, 255), 30)
    comps = _components(sp, 300, 2, y_min=256, y_max=464)
    comps = [c for c in comps if c.width >= 15 and c.height >= 15 and c.width * c.height >= 600]
    comps.sort(key=lambda c: c.width * c.height)
    L["shaymin"] = comps
    # --- Moonlight : fond étoilé + halo / avant-plan lune+nuages+cimes (clé verte)
    mo = _load("Moonlight.png")
    L["moonBg"] = mo.crop((314, 0, 626, 240))
    L["moonFg"] = _key(mo.crop((0, 0, 312, 240)), (76, 255, 0), 40)
    # --- Plains : plan lointain + couche d'arbres (clé rouge)
    pl = _load("Plains.png")
    L["plainsFar"] = pl.crop((386, 0, 770, 216))
    L["plainsTree"] = _key(pl.crop((0, 0, 384, 216)), (255, 0, 0), 40)
    # --- Sky Peak Summit : composite + avant-plan de fleurs (clé magenta)
    sk = _load("Sky_Peak_Summit.png")
    L["skyPeak"] = sk.crop((0, 0, 256, 576))
    L["skyPeakFront"] = _key(sk.crop((518, 0, 774, 576)), (255, 0, 255), 40)
    # --- Lapras : ciel/horizon, 3 images de Lapras (clé verte), mer en tuile
    lp = _load("Lapras.png")
    L["laprasSky"] = lp.crop((0, 0, 288, 264))
    lsp = _key(lp.crop((290, 0, 500, 264)), (76, 255, 0), 40)
    lc = _components(lsp, 800, 6)[0]
    fh = lc.height // 3
    L["lapras"] = [lc.crop((0, i * fh, lc.width, (i + 1) * fh)) for i in range(3)]
    L["laprasSea"] = lp.crop((0, 266, 288, 458))
    # --- Antic Wall : mur + objets (clé bleue)
    aw = _load("Antic_Wall.png")
    L["anticWall"] = aw.crop((0, 0, 360, 384))
    items = _key(aw.crop((362, 0, 722, 384)), (0, 38, 255), 40)
    ic = _components(items, 500, 3)
    ic.sort(key=lambda c: -c.width * c.height)
    L["anticItems"] = ic[:6]
    L["anticPos"] = [list(c.box) for c in ic[:6]]
    # --- Time Travel : 13 images du tunnel (colonne gauche) ; blanc → transparent (fenêtres)
    tm = _load("Time_Travel.png")
    frames = []
    for i in range(13):
        fr = tm.crop((0, i * 243, 312, i * 243 + 240)).copy()
        a = np.asarray(fr).copy()
        wh = (a[:, :, :3].astype(int).min(axis=2) >= 246)
        wh = ndi.binary_dilation(wh, iterations=1)
        a[wh, 3] = 0
        frames.append(Image.fromarray(a, "RGBA"))
    L["timeTravel"] = frames
    # --- Thunderclouds : 7 images brutes sur noir (superposition additive)
    th = _load("Thunderclouds.png")
    L["thunder"] = [th.crop((x, 195, x + 335, 435)).convert("RGB") for x in (0, 338, 676, 1014, 1352, 1690, 2028)]
    return L


if __name__ == "__main__":
    L = build_layers()
    out = Path(__file__).resolve().parent.parent / "renders" / "pmd_destiny_fangame_v1" / "opening_sky_layers"
    out.mkdir(parents=True, exist_ok=True)
    for k, v in L.items():
        if k == "anticPos":
            print(k, v); continue
        if isinstance(v, list):
            print(k, [(c.width, c.height) for c in v])
            W = sum(c.width for c in v) + 4 * len(v)
            H = max(c.height for c in v)
            sheet = Image.new("RGBA", (W, H), (90, 90, 90, 255))
            x = 0
            for c in v:
                sheet.alpha_composite(c.convert("RGBA"), (x, 0)); x += c.width + 4
            sheet.save(out / f"dbg_{k}.png")
        else:
            print(k, v.size)
            bg = Image.new("RGBA", v.size, (90, 90, 90, 255)); bg.alpha_composite(v.convert("RGBA")); bg.save(out / f"dbg_{k}.png")
