#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Couches de décor de l'Opening « Voyage » : 10 plaques pixel-art GÉNÉRÉES (océan, surface, plage, prairie de roses,
nuages, forêt lointaine / médiane / route / premier plan), clés magenta ou bleu pur retirées, franges nettoyées,
alpha binaire {0,255}, réduction 2× (BOX pondérée par l'alpha) + palette limitée — prêtes pour la parallaxe multicalque."""
from __future__ import annotations

from pathlib import Path
from typing import Dict

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

SRC = Path(__file__).resolve().parent / "pmd_destiny_fangame_v1" / "voyage_bruts"
OUT = Path(__file__).resolve().parent.parent / "renders" / "pmd_destiny_fangame_v1" / "opening_voyage"

# nom : (fichier, clé, couleurs)
LAYERS = {
    "ocBg": ("oc_bg", None, 96), "surfaceSky": ("surface_sky", None, 96), "forestFar": ("forest_far", None, 96),
    "ocFloor": ("oc_floor", "magenta", 72), "beachFg": ("beach_fg", "magenta", 72), "meadow": ("rose_meadow", "blue", 80),
    "clouds": ("clouds_layer", "magenta", 56), "forestMid": ("forest_mid", "magenta", 80),
    "forestRoad": ("forest_road", "magenta", 72), "forestFg": ("forest_fg", "magenta", 56),
}


def _mask(a: np.ndarray, key: str) -> np.ndarray:
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    if key == "magenta":
        bg = (r > 190) & (b > 190) & (g < 130)
        like = (r - g > 70) & (b - g > 70)
    else:
        bg = (b > 200) & (r < 70) & (g < 70)
        like = (b - r > 90) & (b - g > 90)
    near = ndi.binary_dilation(bg, iterations=2) & ~bg & like
    bg = bg | near
    # supprime les pixels isolés de fond (trous) / de décor (poussières)
    lab, n = ndi.label(~bg)
    if n:
        sizes = ndi.sum(~bg, lab, range(1, n + 1))
        for i in np.where(sizes < 12)[0]:
            bg[lab == i + 1] = True
    return bg


def load_layer(name: str) -> Image.Image:
    f, key, colors = LAYERS[name]
    im = Image.open(SRC / f"{f}.png").convert("RGB")
    a = np.asarray(im).astype(np.float64)
    h, w = a.shape[:2]
    h2, w2 = h // 2, w // 2
    a = a[: h2 * 2, : w2 * 2]
    if key is None:
        small = Image.fromarray(a.astype(np.uint8), "RGB").resize((w2, h2), Image.Resampling.BOX)
        q = small.quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
        return q.convert("RGBA")
    bg = _mask(a.astype(int), key)
    al = (~bg).astype(np.float64)
    prem = a * al[..., None]
    prem = prem.reshape(h2, 2, w2, 2, 3).sum(axis=(1, 3))
    cnt = al.reshape(h2, 2, w2, 2).sum(axis=(1, 3))
    rgb = np.where(cnt[..., None] > 0, prem / np.maximum(cnt[..., None], 1), 0)
    alpha = cnt >= 2  # majorité de pixels opaques → opaque (alpha binaire)
    rgb8 = np.clip(rgb, 0, 255).astype(np.uint8)
    q = Image.fromarray(rgb8, "RGB").quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    out = np.dstack([np.asarray(q), alpha.astype(np.uint8) * 255]).astype(np.uint8)
    out[~alpha, :3] = 0
    return Image.fromarray(out, "RGBA")


def build_voyage_layers() -> Dict[str, Image.Image]:
    return {k: load_layer(k) for k in LAYERS}


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    L = build_voyage_layers()
    sh = Image.new("RGBA", (4 * 350, 3 * 200), (70, 70, 70, 255))
    for i, (k, im) in enumerate(L.items()):
        t = im.copy(); t.thumbnail((346, 196), Image.Resampling.NEAREST)
        sh.alpha_composite(t, ((i % 4) * 350, (i // 4) * 200))
        a = np.asarray(im)[..., 3]
        print(k, im.size, "alpha uniques", sorted(set(np.unique(a).tolist())), "transparent %", round(100 * (a == 0).mean(), 1))
    sh.save(OUT / "dbg_voyage_layers.png")
