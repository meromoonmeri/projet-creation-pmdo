#!/usr/bin/env python3
"""Décor animé de l'arène (combat) : découpe le dais peint (fond blanc → alpha), le vortex de nuages,
les rochers flottants (pris sur la planche validée), repère les cristaux / le cercle magique, fabrique la brume.
Sorties dans combat_bruts/ : arDais.png, arVortex.jpg, arRocks.png, arMist.png, arena_meta.json."""
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage as ndi

ROOT = Path(__file__).resolve().parent.parent
P = ROOT / "source/pmd_destiny_fangame_v1"
OUT = P / "combat_bruts"
OUT.mkdir(parents=True, exist_ok=True)


def hsv(a):
    mx = a.max(2); mn = a.min(2)
    s = (mx - mn) / np.maximum(mx, 1e-5)
    return s, mx


def dais():
    im = Image.open(OUT / "src_peints/arene_dais_raw.png").convert("RGB")
    im = im.resize((1376, 768), Image.LANCZOS)
    a = np.asarray(im).astype(float) / 255
    s, v = hsv(a)
    white = (a.min(2) > 0.86) & (s < 0.12)
    lab, n = ndi.label(white)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    bg = np.isin(lab, list(border))
    bg = ndi.binary_dilation(bg, iterations=2)
    solid = ~bg
    solid = ndi.binary_opening(solid, iterations=1)
    # garde le plus grand bloc (le dais) sans les petits résidus
    lab2, n2 = ndi.label(solid)
    sizes = ndi.sum(solid, lab2, range(1, n2 + 1))
    solid = lab2 == (1 + int(np.argmax(sizes)))
    solid = ndi.binary_fill_holes(solid)
    alpha = ndi.gaussian_filter(solid.astype(float), 0.8)
    alpha = np.clip((alpha - 0.2) / 0.6, 0, 1)
    # décontamination du liseré : les pixels du bord prennent la couleur intérieure la plus proche
    inner = ndi.binary_erosion(solid, iterations=3)
    idx = ndi.distance_transform_edt(~inner, return_distances=False, return_indices=True)
    fix = a[idx[0], idx[1]]
    edge = (~inner)
    rgb = np.where(edge[..., None], fix, a)
    out = np.dstack([np.clip(rgb * 255, 0, 255).astype(np.uint8), (alpha * 255).astype(np.uint8)])
    Image.fromarray(out, "RGBA").save(OUT / "arDais.png", optimize=True)
    # --- repères
    s2, v2 = hsv(rgb)
    hh = np.arctan2(np.sqrt(3) * (rgb[..., 1] - rgb[..., 2]), 2 * rgb[..., 0] - rgb[..., 1] - rgb[..., 2])
    glow = (s2 > 0.45) & (v2 > 0.6) & (rgb[..., 2] > 0.7) & solid
    ys, xs = np.mgrid[0:768, 0:1376]
    cx0, cy0 = 690, 395
    rune = glow & (((xs - cx0) / 190) ** 2 + ((ys - cy0) / 100) ** 2 < 1)
    ry_, rx_ = np.where(rune)
    rune_meta = [float(rx_.mean()), float(ry_.mean()), float(np.percentile(np.abs(rx_ - rx_.mean()), 97)), float(np.percentile(np.abs(ry_ - ry_.mean()), 97))]
    cr = glow & ~(((xs - cx0) / 240) ** 2 + ((ys - cy0) / 130) ** 2 < 1)
    lab3, n3 = ndi.label(ndi.binary_dilation(cr, iterations=6))
    cry = []
    for i, sl in enumerate(ndi.find_objects(lab3)):
        m = cr[sl]
        if m.sum() < 40:
            continue
        yy, xx = np.where(m)
        cry.append([float(xx.mean() + sl[1].start), float(yy.mean() + sl[0].start), float(max(14, min(40, (m.sum()) ** 0.5 * 0.9)))])
    return rune_meta, cry


def vortex():
    im = Image.open(OUT / "src_peints/arene_vortex_raw.png").convert("RGB").resize((1376, 768), Image.LANCZOS)
    im.save(OUT / "arVortex.jpg", quality=90)


def rocks():
    im = Image.open(OUT / "src_peints/opmArena.png").convert("RGB")
    a = np.asarray(im).astype(float) / 255
    s, v = hsv(a)
    stone = ((s < 0.40) & (v > 0.25)) | ((v > 0.7) & (s < 0.5))
    stone = ndi.binary_fill_holes(ndi.binary_closing(ndi.binary_opening(stone, iterations=1), iterations=3))
    lab, n = ndi.label(stone)
    sizes = ndi.sum(stone, lab, range(1, n + 1))
    big = 1 + int(np.argmax(sizes))
    items = []
    for i, sl in enumerate(ndi.find_objects(lab), 1):
        if i == big or sizes[i - 1] < 350:
            continue
        h, w = sl[0].stop - sl[0].start, sl[1].stop - sl[1].start
        if sizes[i - 1] / (h * w) < 0.17 or max(w, h) < 24:
            continue
        # exclut les éléments collés au dais (piliers) : trop proche du grand bloc
        m = ndi.binary_dilation(lab == i, iterations=3)
        items.append((i, sl, m))
    W = sum((sl[1].stop - sl[1].start + 12) for _, sl, _ in items)
    Hh = max((sl[0].stop - sl[0].start + 12) for _, sl, _ in items)
    atlas = Image.new("RGBA", (W, Hh), (0, 0, 0, 0)); x = 0; meta = []
    for i, sl, m in items:
        y0, y1, x0, x1 = max(0, sl[0].start - 4), min(750, sl[0].stop + 4), max(0, sl[1].start - 4), min(1364, sl[1].stop + 4)
        mm = ndi.gaussian_filter(m[y0:y1, x0:x1].astype(float), 0.7)
        rgb = (a[y0:y1, x0:x1] * 255).astype(np.uint8)
        t = Image.fromarray(np.dstack([rgb, (np.clip(mm * 1.4, 0, 1) * 255).astype(np.uint8)]), "RGBA")
        atlas.alpha_composite(t, (x, 0))
        meta.append([x, 0, x1 - x0, y1 - y0])
        x += x1 - x0 + 12
    atlas.crop((0, 0, x, Hh)).save(OUT / "arRocks.png", optimize=True)
    return meta


def mist():
    rng = np.random.default_rng(7)
    W, H = 384, 192
    f = np.zeros((H, W))
    for sc, w in ((6, 1.0), (12, 0.6), (24, 0.35), (48, 0.2)):
        r = rng.random((H // sc + 2, W // sc + 2))
        f += w * np.asarray(Image.fromarray((r * 255).astype(np.uint8)).resize((W, H), Image.BICUBIC)).astype(float) / 255
    f = (f - f.min()) / (f.max() - f.min())
    ys, xs = np.mgrid[0:H, 0:W]
    fall = np.clip(1 - np.sqrt(((xs - W / 2) / (W / 2)) ** 2 + ((ys - H / 2) / (H / 2)) ** 2), 0, 1)
    al = np.clip((f - 0.35) * 2.2, 0, 1) * fall ** 0.8
    al = ndi.gaussian_filter(al, 1.2)
    rgb = np.zeros((H, W, 3), np.uint8); rgb[..., 0] = 16; rgb[..., 1] = 6; rgb[..., 2] = 30
    Image.fromarray(np.dstack([rgb, (al * 255).astype(np.uint8)]), "RGBA").save(OUT / "arMist.png", optimize=True)


if __name__ == "__main__":
    rune_meta, cry = dais()
    vortex(); mist()
    meta = {"dw": 1376, "dh": 768, "rune": rune_meta, "crystals": cry, "eye": [700, 372], "rocks": rocks(), "rw": 1364, "rh": 750}
    (OUT / "arena_meta.json").write_text(json.dumps(meta, indent=1))
    print(json.dumps({k: v for k, v in meta.items() if k != "crystals"}), len(cry), "cristaux")
