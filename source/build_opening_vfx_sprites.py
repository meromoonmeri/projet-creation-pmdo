#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Fabrique les SPRITES D'EFFETS animés de l'Opening Destiny (pétales, scintillements, bulles, impacts,
flammes sombres, éclaboussures, éclats de cristal, traînées de coup) à partir de dessins pixel-art générés
(`source/pmd_destiny_fangame_v1/vfx_bruts/vfx_*.png`, fond magenta/vert pur), à la manière des intros PMD Sky :
chaque effet est une PLANCHE D'IMAGES pré-calculées (rotation 3D des pétales, échelle de zoom, flicker de flamme,
dissolution tramée…) jouée image par image. Alpha binaire {0,255}, 0 px de fond-clé résiduel, palette ≤ 24 couleurs.
"""
from __future__ import annotations

import math
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image, ImageDraw

SRC = Path(__file__).resolve().parent / "pmd_destiny_fangame_v1" / "vfx_bruts"
OUT = Path(__file__).resolve().parent.parent / "renders" / "pmd_destiny_fangame_v1" / "opening_vfx"

BAYER = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]], dtype=float) / 16.0


def load_sprite(name: str, max_dim: int, key: str = "magenta", colors: int = 20) -> Image.Image:
    im = Image.open(SRC / f"vfx_{name}.png").convert("RGB")
    a = np.asarray(im).astype(int)
    r, g, b = a[:, :, 0], a[:, :, 1], a[:, :, 2]
    if key == "magenta":
        bg = (r > 200) & (b > 200) & (g < 120)
    else:
        c0 = a[2, 2]
        bg = (np.abs(a - c0[None, None, :]).sum(axis=2) < 150)
    # franges anti-aliasées vers le fond-clé
    from scipy import ndimage as ndi
    near = ndi.binary_dilation(bg, iterations=2) & ~bg
    if key == "magenta":
        fringe = near & (np.minimum(r, b) - g > 70)
    else:
        fringe = near & (g - np.maximum(r, b) > 60)
    bg = bg | fringe
    rgba = np.dstack([a.astype(np.uint8), np.where(bg, 0, 255).astype(np.uint8)])
    img = Image.fromarray(rgba, "RGBA")
    bbox = img.getchannel("A").getbbox()
    img = img.crop(bbox)
    sc = max_dim / max(img.size)
    nw, nh = max(2, round(img.width * sc)), max(2, round(img.height * sc))
    # alpha pré-multiplié → BOX pour garder le pixel-art net, puis alpha binaire
    prem = np.asarray(img).astype(float)
    prem[:, :, :3] *= (prem[:, :, 3:4] / 255.0)
    pm = Image.fromarray(prem.astype(np.uint8), "RGBA").resize((nw, nh), Image.Resampling.BOX)
    arr = np.asarray(pm).astype(float)
    al = arr[:, :, 3]
    col = np.where(al[:, :, None] > 0, arr[:, :, :3] / np.maximum(al[:, :, None] / 255.0, 1e-3), 0).clip(0, 255)
    opaque = al >= 128
    rgb = Image.fromarray(col.astype(np.uint8), "RGB").quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    out = np.dstack([np.asarray(rgb), np.where(opaque, 255, 0).astype(np.uint8)])
    out[~opaque, :3] = 0
    return Image.fromarray(out, "RGBA")


def paste_center(frame: Image.Image, spr: Image.Image, cx: float, cy: float, anchor_bottom: bool = False) -> None:
    x = int(round(cx - spr.width / 2))
    y = int(round(cy - (spr.height if anchor_bottom else spr.height / 2)))
    frame.alpha_composite(spr, (x, y)) if (0 <= x and 0 <= y and x + spr.width <= frame.width and y + spr.height <= frame.height) else _clip_paste(frame, spr, x, y)


def _clip_paste(frame: Image.Image, spr: Image.Image, x: int, y: int) -> None:
    layer = Image.new("RGBA", frame.size, (0, 0, 0, 0))
    layer.paste(spr, (x, y))
    frame.alpha_composite(layer)


def nn_scale(spr: Image.Image, sx: float, sy: float) -> Image.Image:
    return spr.resize((max(1, round(spr.width * sx)), max(1, round(spr.height * sy))), Image.Resampling.NEAREST)


def dither_fade(frame: Image.Image, level: float) -> Image.Image:
    """Dissolution tramée Bayer 4×4 : alpha reste binaire."""
    if level <= 0:
        return frame
    a = np.asarray(frame).copy()
    h, w = a.shape[:2]
    thr = np.tile(BAYER, (h // 4 + 1, w // 4 + 1))[:h, :w]
    kill = thr < level
    a[kill, 3] = 0
    a[kill, :3] = 0
    return Image.fromarray(a, "RGBA")


def tint(spr: Image.Image, mul: float) -> Image.Image:
    a = np.asarray(spr).astype(float)
    a[:, :, :3] = (a[:, :, :3] * mul).clip(0, 255)
    return Image.fromarray(a.astype(np.uint8), "RGBA")


def strip(frames: List[Image.Image]) -> Image.Image:
    fw, fh = frames[0].size
    s = Image.new("RGBA", (fw * len(frames), fh), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        s.alpha_composite(f, (i * fw, 0))
    return s


def anim_petal() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("petal", 18)
    fw = fh = 24
    frames = []
    n = 16
    for k in range(n):
        th = 2 * math.pi * k / n
        sx = math.cos(th)
        flip = sx < 0
        w = max(0.22, abs(sx))
        spr = nn_scale(base, w, 1.0)
        if flip:
            spr = spr.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
            spr = tint(spr, 0.82)
        tilt = 28 * math.sin(th * 1.0 + 0.6)
        spr = spr.rotate(tilt, resample=Image.Resampling.NEAREST, expand=True)
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, spr, fw / 2, fh / 2)
        frames.append(f)
    return frames, {"fps": 12, "loop": True}


def anim_sparkle() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("sparkle", 30)
    fw = fh = 32
    sc = [0.18, 0.4, 0.7, 1.0, 0.85, 0.6, 0.38, 0.16]
    frames = []
    for s in sc:
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, nn_scale(base, s, s), fw / 2, fh / 2)
        frames.append(f)
    return frames, {"fps": 14, "loop": False}


def anim_bubble() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("bubble", 20)
    fw = fh = 28
    frames = []
    wob = [(1.0, 1.0), (1.08, 0.94), (1.0, 1.0), (0.94, 1.08), (1.0, 1.0), (1.06, 0.96)]
    for sx, sy in wob:
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, nn_scale(base, sx, sy), fw / 2, fh / 2)
        frames.append(f)
    pal = [tuple(int(v) for v in c) for c in np.asarray(base).reshape(-1, 4) if c[3] > 0]
    hi = max(pal, key=lambda c: sum(c[:3]))[:3]
    rim = min(pal, key=lambda c: sum(c[:3]))[:3]
    for k, rad in enumerate([8, 10.5, 12.5, 13.5]):  # éclatement : gouttelettes qui s'écartent
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        px = f.load()
        for j in range(8):
            ang = j * math.pi / 4 + 0.2
            x, y = int(round(fw / 2 + math.cos(ang) * rad)), int(round(fh / 2 + math.sin(ang) * rad))
            if 0 <= x < fw and 0 <= y < fh:
                px[x, y] = hi + (255,)
                if k < 2 and x + 1 < fw:
                    px[x + 1, y] = rim + (255,)
        frames.append(f)
    return frames, {"fps": 10, "loop": True, "wobble": 6, "pop": 4}


def anim_hit() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("hit", 48)
    fw = fh = 72
    sc = [0.3, 0.55, 0.8, 1.0, 1.1, 1.2, 1.3, 1.4]
    fade = [0, 0, 0, 0, 0.2, 0.45, 0.7, 0.9]
    frames = []
    for s, fd in zip(sc, fade):
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, nn_scale(base, s, s), fw / 2, fh / 2)
        frames.append(dither_fade(f, fd))
    return frames, {"fps": 20, "loop": False}


def anim_flame() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("flame", 44, key="green")
    fw, fh = 36, 52
    n = 8
    frames = []
    b = np.asarray(base)
    h, w = b.shape[:2]
    for k in range(n):
        ph = 2 * math.pi * k / n
        stretch = 1.0 + 0.07 * math.sin(ph * 2)
        sh = max(2, round(h * stretch))
        s = base.resize((w, sh), Image.Resampling.NEAREST)
        a = np.asarray(s)
        out = np.zeros_like(a)
        for y in range(sh):
            top = 1 - y / sh
            dx = int(round((1.6 * math.sin(y * 0.33 - ph) + 1.2 * math.sin(y * 0.15 + ph * 2)) * (0.3 + top)))
            row = a[y]
            xs = np.where(row[:, 3] > 0)[0]
            for x in xs:
                nx = x + dx
                if 0 <= nx < w:
                    out[y, nx] = row[x]
        spr = Image.fromarray(out, "RGBA")
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, spr, fw / 2, fh - 2, anchor_bottom=True)
        frames.append(f)
    return frames, {"fps": 12, "loop": True}


def anim_splash() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("splash", 56)
    fw, fh = 72, 56
    sc = [(0.25, 0.2), (0.45, 0.45), (0.7, 0.8), (0.9, 1.05), (1.0, 1.1), (1.05, 1.0), (1.1, 0.85), (1.15, 0.6)]
    fade = [0, 0, 0, 0, 0.1, 0.35, 0.6, 0.85]
    frames = []
    for (sx, sy), fd in zip(sc, fade):
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, nn_scale(base, sx, sy), fw / 2, fh - 4, anchor_bottom=True)
        frames.append(dither_fade(f, fd))
    return frames, {"fps": 14, "loop": False}


def anim_shard() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("shard", 24)
    fw = fh = 36
    frames = []
    for k in range(8):
        spr = base.rotate(k * 45, resample=Image.Resampling.NEAREST, expand=True)
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, spr, fw / 2, fh / 2)
        frames.append(f)
    return frames, {"fps": 16, "loop": True}


def anim_slash() -> Tuple[List[Image.Image], dict]:
    base = load_sprite("slash", 44)
    fw = fh = 52
    w, h = base.size
    a = np.asarray(base)
    frames = []
    cuts = [0.18, 0.42, 0.7, 1.0, 1.0, 1.0]
    fade = [0, 0, 0, 0, 0.35, 0.75]
    yy, xx = np.mgrid[:h, :w]
    diag = (xx / max(1, w - 1) * 0.5 + (1 - yy / max(1, h - 1)) * 0.5)  # balayage de la pointe haute vers la basse
    for c, fd in zip(cuts, fade):
        m = a.copy()
        m[diag > c, 3] = 0
        m[diag > c, :3] = 0
        f = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
        paste_center(f, Image.fromarray(m, "RGBA"), fw / 2, fh / 2)
        frames.append(dither_fade(f, fd))
    return frames, {"fps": 24, "loop": False}


EFFECTS = {
    "petal": anim_petal, "sparkle": anim_sparkle, "bubble": anim_bubble, "hit": anim_hit,
    "flame": anim_flame, "splash": anim_splash, "shard": anim_shard, "slash": anim_slash,
}


def build_vfx() -> Dict[str, dict]:
    """→ { nom: {'sheet': PIL, 'fw','fh','n','fps','loop', ...} }"""
    out: Dict[str, dict] = {}
    for name, fn in EFFECTS.items():
        frames, meta = fn()
        sheet = strip(frames)
        out[name] = {"sheet": sheet, "fw": frames[0].width, "fh": frames[0].height, "n": len(frames), **meta}
    return out


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    V = build_vfx()
    for k, v in V.items():
        v["sheet"].save(OUT / f"fx_{k}.png")
        print(k, v["fw"], v["fh"], v["n"], v["sheet"].size)
    # planche de contrôle
    H = sum(v["fh"] + 4 for v in V.values())
    Wd = max(v["sheet"].width for v in V.values())
    cs = Image.new("RGBA", (Wd, H), (60, 70, 110, 255))
    y = 0
    for v in V.values():
        cs.alpha_composite(v["sheet"], (0, y)); y += v["fh"] + 4
    cs = cs.resize((cs.width * 3, cs.height * 3), Image.Resampling.NEAREST)
    cs.save(OUT / "dbg_planche_vfx.png")
