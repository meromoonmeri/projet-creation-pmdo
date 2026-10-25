#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Redécoupe PROPRE du logo (ailes / corps) à partir du logo complet : segmentation par couleur des deux ailes
(intérieur crème + contour sombre), sans bords rectangulaires, pour que le battement d'ailes ne montre aucune coupure.
Sorties : logo_rig_{core_body,left_wing,right_wing}.png (même taille que le logo, mêmes pivots)."""
from pathlib import Path
import json
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

D = Path(__file__).resolve().parent.parent / "renders" / "pmd_destiny_fangame_v1" / "apercus_menu"


def build() -> dict:
    im = Image.open(D / "Logo_PMD_Destiny_Oeuf_Ailes_HD.png").convert("RGBA")
    a = np.asarray(im).astype(int)
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    H, W = al.shape
    cream = (al > 200) & (r > 232) & (g > 222) & (b > 130) & (b < 236) & (r - b > 22)
    cream = ndi.binary_closing(cream, iterations=2)
    lab, n = ndi.label(cream)
    areas = ndi.sum(cream, lab, range(1, n + 1))
    cm = ndi.center_of_mass(cream, lab, range(1, n + 1))
    mid = W / 2
    masks = {}
    for side in ("L", "R"):
        best, bi = 0, None
        for i in range(n):
            cx = cm[i][1]
            if (side == "L" and cx < mid - 120) or (side == "R" and cx > mid + 120):
                if areas[i] > best:
                    best, bi = areas[i], i + 1
        comp = lab == bi
        comp = ndi.binary_fill_holes(comp)
        mx, mn = a[..., :3].max(axis=2), a[..., :3].min(axis=2)
        dark = (al > 0) & (mx < 150) & ((mx - mn) < 60)           # contour sombre (même antialiasé)
        creamish = (al > 0) & (r > 200) & (b < 236) & (r - b > 18) & ((mx - mn) < 85)  # ombrages crème de l'aile
        ring = ndi.binary_dilation(comp, iterations=14) & ~comp & (dark | creamish)
        ring = ndi.binary_propagation(ring & ndi.binary_dilation(comp, iterations=3), mask=ring)
        m = comp | ring
        m = ndi.binary_closing(m, iterations=2) & (al > 0)
        masks[side] = m
    out = {}
    for side, name in (("L", "left_wing"), ("R", "right_wing")):
        m = masks[side]
        layer = np.zeros((H, W, 4), np.uint8)
        layer[m] = a[m].astype(np.uint8)
        out[name] = Image.fromarray(layer, "RGBA")
    core = np.asarray(im).copy()
    both = masks["L"] | masks["R"]
    core[both, 3] = 0
    out["core_body"] = Image.fromarray(core, "RGBA")
    # fond de rattrapage : l'éventail doré visible derrière l'aile quand elle se lève (ordre : fond, ailes, corps)
    gold = (al > 200) & (r > 150) & (g > 90) & (g < 215) & (b < 120) & ~both
    dist, (iy, ix) = ndi.distance_transform_edt(~gold, return_indices=True)
    hole = ndi.binary_dilation(both, iterations=1)
    fill = hole & (dist < 22)
    back = np.zeros((H, W, 4), np.uint8)
    src = np.asarray(im)
    back[fill] = src[iy[fill], ix[fill]]
    back[fill, 3] = 255
    out["back_fill"] = Image.fromarray(back, "RGBA")
    return out


if __name__ == "__main__":
    o = build()
    for k, v in o.items():
        v.save(D / f"logo_rig_{k}.png")
        print(k, v.size)
