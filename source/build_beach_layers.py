#!/usr/bin/env python3
"""Décompose la texture canonique de plage (mer au soleil couchant, `beach_sea_sunset_pmdsky.png`) en calques :
  - `beach_sea_clean.png`  : ciel + mer SANS les bulles (trous comblés par interpolation du décor voisin) ;
  - `beach_bubbles.png`    : les bulles seules (RGBA, alpha binaire) → animées en boucle (remontée + balancement + wrap).
Les bulles sont repérées par leur écart au décor (médiane glissante par rangée) puis filtrées par forme (cercles compacts)."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
from scipy.interpolate import griddata

B = Path(__file__).resolve().parent / "pmd_destiny_fangame_v1" / "ultime_bruts"


# bulles de la texture (centre x, centre y, rayon approximatif) — repérées sur la texture 496×750
BUBBLES = [(66, 30, 15), (252, 62, 32), (462, 50, 21), (198, 115, 15), (248, 230, 22), (95, 350, 16), (472, 330, 15), (85, 440, 38),
           (404, 428, 31), (295, 485, 16), (160, 555, 49), (323, 603, 37), (4, 587, 14), (418, 542, 16), (188, 718, 22), (355, 705, 16)]


def build() -> dict:
    im = np.asarray(Image.open(B / "beach_sea_sunset_pmdsky.png").convert("RGB")).astype(np.float32)
    H, W, _ = im.shape
    clean = im.copy()
    keep = np.zeros((H, W), bool)
    for cx, cy, r in BUBBLES:
        R = r + 9
        y0, y1, x0, x1 = max(0, cy - R), min(H, cy + R + 1), max(0, cx - R), min(W, cx + R + 1)
        sub = im[y0:y1, x0:x1]
        ref = np.zeros_like(sub)
        xa, xb = max(0, cx - R - 4), min(W - 1, cx + R + 4)
        for k, y in enumerate(range(y0, y1)):  # référence de décor : interpolation entre les deux bords de la rangée
            a = im[y, max(0, xa - 2):xa + 1].mean(axis=0) if xa > 2 else im[y, xb - 2:xb + 1].mean(axis=0)
            b = im[y, xb:min(W, xb + 3)].mean(axis=0) if xb < W - 3 else a
            if cx - R - 4 < 0:
                a = b
            if cx + R + 4 >= W:
                b = a
            ref[k] = np.linspace(a, b, x1 - x0)
        yy, xx = np.mgrid[y0:y1, x0:x1]
        disc = (yy - cy) ** 2 + (xx - cx) ** 2 <= (r + 5) ** 2
        m = (np.abs(sub - ref).max(axis=2) > 18) & disc
        m = ndi.binary_closing(m, structure=np.ones((3, 3)), iterations=2)
        m = ndi.binary_fill_holes(m)
        lab, n = ndi.label(m)
        if n > 1:
            sizes = ndi.sum(m, lab, range(1, n + 1)); m = lab == (1 + int(np.argmax(sizes)))
        m = ndi.binary_dilation(m, structure=np.ones((3, 3)), iterations=1) & ((yy - cy) ** 2 + (xx - cx) ** 2 <= (r + 2) ** 2)
        keep[y0:y1, x0:x1] |= m
        sc = clean[y0:y1, x0:x1]; sc[m] = ref[m]
    out = np.dstack([im.astype(np.uint8), np.where(keep, 255, 0).astype(np.uint8)])
    Image.fromarray(clean.astype(np.uint8), "RGB").save(B / "beach_sea_clean.png")
    Image.fromarray(out, "RGBA").save(B / "beach_bubbles.png")
    return {"bubbles": len(BUBBLES), "pixels": int(keep.sum())}


if __name__ == "__main__":
    print(build())


def logo(width: int = 520, fname: str = "logo_destiny_super_gen.png") -> dict:
    """Logo « Pokémon Mystery Dungeon : DESTINY » généré (ruban doré) : clé magenta retirée, réduit en pixel-art (alpha binaire, palette 96 couleurs)."""
    src = Image.open(B / fname).convert("RGB")
    a = np.asarray(src).astype(np.int32)
    key = (a[..., 0] > 190) & (a[..., 2] > 190) & (a[..., 1] < 140) & (a[..., 0] - a[..., 1] > 90) & (a[..., 2] - a[..., 1] > 90)
    key = ndi.binary_dilation(key, iterations=1)  # retire la frange rose
    alpha = np.where(key, 0, 255).astype(np.uint8)
    ys, xs = np.where(alpha > 0)
    box = (max(0, xs.min() - 6), max(0, ys.min() - 6), min(src.width, xs.max() + 7), min(src.height, ys.max() + 7))
    rgba = Image.fromarray(np.dstack([a.astype(np.uint8), alpha]), "RGBA").crop(box)
    h = round(rgba.height * width / rgba.width)
    r, g, b, al = [np.asarray(c.resize((width, h), Image.BOX)) for c in rgba.split()]
    op = al >= 128
    rgb = Image.fromarray(np.dstack([r, g, b]).astype(np.uint8), "RGB").quantize(colors=96, method=Image.MEDIANCUT, dither=Image.NONE).convert("RGB")
    out = np.dstack([np.asarray(rgb), np.where(op, 255, 0).astype(np.uint8)])
    lk = (out[..., 0] > 200) & (out[..., 2] > 200) & (out[..., 1] < 90)
    out[..., 3] = np.where(lk, 0, out[..., 3])  # retire les rares pixels résiduels de la clé
    leak = ((out[..., 0] > 200) & (out[..., 2] > 200) & (out[..., 1] < 90) & (out[..., 3] == 255)).sum()
    assert leak == 0, f"{leak} px magenta"
    Image.fromarray(out, "RGBA").save(B / "pmd_logo_destiny.png")
    return {"size": (width, h), "leak": int(leak)}


def skyfall(scale: float = 0.5) -> dict:
    """Calque de nuages (générés) pour la chute dans le ciel : clé magenta retirée, alpha binaire, palette limitée."""
    src = Image.open(B / "skyfall_clouds.png").convert("RGB")
    a = np.asarray(src).astype(np.int32)
    key = (a[..., 0] > 190) & (a[..., 2] > 190) & (a[..., 1] < 150) & (a[..., 0] - a[..., 1] > 70) & (a[..., 2] - a[..., 1] > 70)
    key = ndi.binary_dilation(key, iterations=1)
    w, h = round(src.width * scale), round(src.height * scale)
    al = np.asarray(Image.fromarray(np.where(key, 0, 255).astype(np.uint8)).resize((w, h), Image.BOX)) >= 160
    rgb = Image.fromarray(a.astype(np.uint8), "RGB").resize((w, h), Image.BOX).quantize(colors=48, method=Image.MEDIANCUT, dither=Image.NONE).convert("RGB")
    out = np.dstack([np.asarray(rgb), np.where(al, 255, 0).astype(np.uint8)])
    leak = ((out[..., 0] > 200) & (out[..., 2] > 200) & (out[..., 1] < 120) & al).sum()
    assert leak == 0, f"{leak} px magenta"
    Image.fromarray(out, "RGBA").save(B / "skyfall_clouds_layer.png")
    return {"size": (w, h), "leak": int(leak)}
