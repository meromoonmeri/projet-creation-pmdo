#!/usr/bin/env python3
"""Découpe les plaques générées (fond noir → alpha) de la Méga-Évolution : colonne arc-en-ciel opaque, emblème en flammes, explosion qui fracture la réalité.
Sorties dans combat_bruts/ : megaColumn.webp, megaSymbol.webp, megaShatter.webp (WebP avec alpha)."""
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "source/pmd_destiny_fangame_v1/combat_bruts"
SRC = OUT / "src_peints"


def keyed(im, lo, hi):
    a = np.asarray(im.convert("RGB")).astype(np.float32)
    m = a.max(2)
    al = np.clip((m - lo) / (hi - lo), 0, 1)
    al = al * al * (3 - 2 * al)
    # couleur « dé-prémultipliée » : le noir du fond ne ternit pas les bords
    rgb = np.clip(a / np.maximum(al[..., None], 0.05), 0, 255)
    rgb = np.where(al[..., None] > 0.05, rgb, a)
    return Image.fromarray(np.dstack([rgb.astype(np.uint8), (al * 255).astype(np.uint8)]), "RGBA")


def crop_bbox(im, thr=40, pad=8):
    al = np.asarray(im)[..., 3]
    ys, xs = np.where(al > thr)
    return im.crop((max(0, xs.min() - pad), max(0, ys.min() - pad), min(im.width, xs.max() + pad), min(im.height, ys.max() + pad)))


def main():
    col = crop_bbox(keyed(Image.open(SRC / "mega_colonne_raw.png"), 10, 70), 60, 10)
    col = col.resize((max(1, round(col.width * 1024 / col.height)), 1024), Image.LANCZOS)
    col.save(OUT / "megaColumn.webp", quality=84, method=6)
    sym = crop_bbox(keyed(Image.open(SRC / "mega_symbole_raw.png"), 8, 60), 50, 6)
    s = 420 / max(sym.size)
    sym.resize((round(sym.width * s), round(sym.height * s)), Image.LANCZOS).save(OUT / "megaSymbol.webp", quality=84, method=6)
    sh = keyed(Image.open(SRC / "explosion_realite_raw.png"), 8, 50)
    sh = sh.resize((1024, round(1024 * sh.height / sh.width)), Image.LANCZOS)
    arr = np.asarray(sh).copy()
    arr[..., 3] = (arr[..., 3] // 8) * (255 // 31)  # alpha quantifiée sur 32 niveaux : plaque additive, banding invisible, ~40 % plus léger
    Image.fromarray(arr, "RGBA").save(OUT / "megaShatter.webp", quality=58, method=6, exact=False)
    for f in ("megaColumn", "megaSymbol", "megaShatter"):
        im = Image.open(OUT / f"{f}.webp")
        print(f, im.size, (OUT / f"{f}.webp").stat().st_size // 1024, "Ko")


if __name__ == "__main__":
    main()
