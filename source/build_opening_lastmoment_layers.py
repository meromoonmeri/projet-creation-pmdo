#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Décors de l'Opening « Last Moment ».

• TEXTURES CANONIQUES des intros de PMD Explorers of Sky (références fournies dans
  `source/pmd_destiny_fangame_v1/references_sky_intro/`, découpées par `build_opening_sky_layers.py`) :
  Plains (montagnes + arbres/chemin), Moonlight (nuit étoilée + lune), Sky Peak Summit (prairie fleurie).
• Trois plaques GÉNÉRÉES dans le style PMD (`source/pmd_destiny_fangame_v1/lastmoment_bruts/`) :
  mer houleuse « Sharpedo Bluff » (référence de texture : Lapras), soleil de canyon (fond noir, composé en addition),
  parois de canyon rouge (clé magenta → alpha binaire).
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict

import numpy as np
from PIL import Image

try:
    from source.build_opening_sky_layers import build_layers  # type: ignore
    from source.build_opening_voyage_layers import _mask  # type: ignore
except ImportError:  # exécution directe
    from build_opening_sky_layers import build_layers  # type: ignore
    from build_opening_voyage_layers import _mask  # type: ignore

GEN = Path(__file__).resolve().parent / "pmd_destiny_fangame_v1" / "lastmoment_bruts"

# nom du calque dans le moteur : clé de build_layers()
CANON = {
    "moonBg": "moonBg", "moonFg": "moonFg", "plainsFar": "plainsFar", "plainsTree": "plainsTree", "skyPeak": "skyPeak",
}


def _half(im: Image.Image) -> Image.Image:
    w, h = im.size
    return im.crop((0, 0, w // 2 * 2, h // 2 * 2)).resize((w // 2, h // 2), Image.Resampling.BOX)


def build_sea() -> Image.Image:
    q = _half(Image.open(GEN / "sea_sharpedo.png").convert("RGB")).quantize(colors=112, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    return q.convert("RGBA")


def build_sun() -> Image.Image:
    q = _half(Image.open(GEN / "sun_canyon.png").convert("RGB")).quantize(colors=128, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    return q.convert("RGBA")


def build_canyon(colors: int = 72) -> Image.Image:
    a = np.asarray(Image.open(GEN / "canyon_rocks.png").convert("RGB")).astype(np.float64)
    h, w = a.shape[:2]
    h2, w2 = h // 2, w // 2
    a = a[: h2 * 2, : w2 * 2]
    bg = _mask(a.astype(int), "magenta")
    al = (~bg).astype(np.float64)
    prem = (a * al[..., None]).reshape(h2, 2, w2, 2, 3).sum(axis=(1, 3))
    cnt = al.reshape(h2, 2, w2, 2).sum(axis=(1, 3))
    rgb = np.where(cnt[..., None] > 0, prem / np.maximum(cnt[..., None], 1), 0)
    alpha = cnt >= 2
    q = Image.fromarray(np.clip(rgb, 0, 255).astype(np.uint8), "RGB").quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    out = np.dstack([np.asarray(q), alpha.astype(np.uint8) * 255]).astype(np.uint8)
    out[~alpha, :3] = 0
    return Image.fromarray(out, "RGBA")


def build_lastmoment_layers() -> Dict[str, Image.Image]:
    L = build_layers()
    out = {k: L[v].convert("RGBA") for k, v in CANON.items()}
    out["sea"], out["sun"], out["canyon"] = build_sea(), build_sun(), build_canyon()
    return out


if __name__ == "__main__":
    for k, im in build_lastmoment_layers().items():
        print(k, im.size)
