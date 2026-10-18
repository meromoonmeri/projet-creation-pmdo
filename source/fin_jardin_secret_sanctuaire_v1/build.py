#!/usr/bin/env python3
"""Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4), format 4:3 vaste (768 x 576 = 96 x 72 cases de 8 px).

Seconde carte du biome Jardin secret (appairée aux entrées EJS1 et EJS2) :
- Arrivée au sud (384, 560) par l'allée d'herbe claire entre les haies buissonneuses.
- Vaste clairière sanctuaire centrale (boss_center) entourée de 4 grands arbres feuillus, de rochers beiges et de fleurs.
- Au nord (goal), grande souche dorée à marches portant l'autel de pierre et l'emblème lumineux de Celebi sous le rayon vert.
- Animations sur la rampe EXACTE des 22 verts du rayon du rip (`secretgarden.png`) :
  - `12_embleme` (24 x 5 = 120 ticks) : pulsation symétrique de +3 crans sur la rampe du rip ;
  - `13_rayon` (24 x 5 = 120 ticks) : souffle sinusoidal de ±2 crans sur la rampe du rip ;
  - `14_lucioles` (24 x 5 = 120 ticks) : 10 lucioles montantes oscillantes aux couleurs exactes du rip.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import shutil
import zipfile
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
BRUTS = HERE / "bruts"
REF = HERE / "reference" / "secretgarden.png"
OUT = R / "renders" / "fin_jardin_secret_sanctuaire_v1"
STAGE = R / ".cache" / "fin_jardin_secret_sanctuaire_v1" / "fin_jardin_secret_sanctuaire"

PFX = "FJS4"
W, H = 768, 576
CELL = 8
GW, GH = W // CELL, H // CELL
RAW_W, RAW_H = 1200, 896
SCALE = H / RAW_H
SW = round(RAW_W * SCALE)
CROP_X = (SW - W) // 2

TICKS = 5
PHASES = 24
LOOP_TICKS = PHASES * TICKS  # 120 ticks (2,0 s à 60 fps)
STATIC_TICKS = 60
FIDELITY_MAX = 35.0

STATIC = (
    "prairie",
    "herbe",
    "ombres",
    "fleurs",
    "rochers",
    "arbres",
    "haies",
    "souche",
    "marches",
    "autel",
    "fond",
)
PALETTE_GROUPS = {
    "herbe": (["sol_complet", "prairie", "herbe", "ombres"], 64),
    "fleurs": (["fleurs"], 24),
    "rochers": (["rochers"], 32),
    "vegetation": (["arbres", "haies"], 96),
    "souche_autel": (["souche", "marches", "autel"], 64),
    "fond": (["fond"], 8),
}

# Rampe exacte des 22 verts du rayon relevée sur `secretgarden.png`
RAMP = [
    (47, 95, 55),
    (47, 103, 55),
    (55, 119, 55),
    (63, 135, 55),
    (63, 151, 55),
    (63, 167, 55),
    (71, 183, 63),
    (79, 199, 71),
    (79, 215, 71),
    (87, 223, 71),
    (95, 231, 71),
    (95, 239, 71),
    (103, 247, 79),
    (111, 255, 87),
    (127, 255, 95),
    (151, 255, 111),
    (175, 255, 127),
    (191, 255, 135),
    (207, 255, 151),
    (231, 255, 199),
    (239, 255, 223),
    (255, 255, 255),
]
BREATH = 2
EDGE_STEPS = 6
EMBLEM_GLOW = 3

# 10 lucioles : (x0, y0, décalage de phase, amplitude x)
MOTES = [
    (326, 136, 0, 2),
    (442, 138, 6, 2),
    (338, 92, 12, 3),
    (430, 88, 18, 3),
    (348, 58, 3, 2),
    (422, 54, 15, 2),
    (244, 248, 4, 3),
    (524, 244, 10, 3),
    (232, 384, 16, 3),
    (536, 380, 22, 3),
]
MOTE_RISE = 2
DOT, GLOW, CORE = (207, 255, 151), (231, 255, 199), (255, 255, 255)

PROMPTS = {
    "decor.png": (
        "Generate a top-down 2D pixel-art dungeon boss sanctuary map in wide 4:3 format (1200x896) using the exact same "
        "textures, palette, and pixel-art style as the reference image (Pokemon Mystery Dungeon Secret Garden): same "
        "light yellow-green central meadow grass with small grass tufts, same medium green surrounding grass, same "
        "rounded bushy green hedge borders, same round leafy green trees with brown trunks and soft dark green ground "
        "shadows, same tan-brown boulders, same small white, yellow, and pink 5-petal flowers, same big golden-brown "
        "tree stump with wooden steps at the front, same vertical bright green light beam falling from the top center "
        "onto the stump, and same dark green background outside the hedges. Layout: at the SOUTH (bottom center), a "
        "light yellow-green grass path between bushy hedges leads north into a wide circular-octagonal sanctuary meadow "
        "glade (boss arena) ringed by bushy hedges, 4 round leafy trees, several tan-brown boulders, and flower patches. "
        "At the NORTH center of the glade (around y 14% to 28%) stands the big golden tree stump with wooden front steps "
        "leading down to the meadow, and atop the flat golden stump stands a small carved stone shrine pedestal with a "
        "glowing light-green Celebi leaf-crest emblem, bathed in the vertical bright green light beam falling from the "
        "top edge. Crisp pixel art, no characters, no text, no UI."
    ),
    "sol_complet.png": (
        "Generate an image: fill the ENTIRE 4:3 (1200x896) canvas edge to edge with the medium green meadow grass "
        "texture from the reference image (the medium green grass around the flowers and trees, around RGB 118, 174, "
        "58, with its subtle pixel-art grass texture and small darker green tufts). Crisp pixel-art grass ground "
        "texture filling the whole canvas."
    ),
}


def load_mod(name: str, p: Path):
    sp = importlib.util.spec_from_file_location(name, p)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def sha256(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def save(a: np.ndarray, p: Path) -> None:
    p.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(a).save(p, optimize=True)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def sdev(l: np.ndarray, k: int) -> np.ndarray:
    return np.sqrt(np.maximum(nd.uniform_filter(l**2, k) - nd.uniform_filter(l, k) ** 2, 0))


def disk(r: int) -> np.ndarray:
    y, x = np.ogrid[-r : r + 1, -r : r + 1]
    return (x * x + y * y) <= r * r


def open_(m: np.ndarray, r: int) -> np.ndarray:
    if r <= 0:
        return m
    p = r + 1
    return nd.binary_opening(np.pad(m, p, mode="edge"), structure=disk(r))[p:-p, p:-p]


def close_(m: np.ndarray, r: int) -> np.ndarray:
    if r <= 0:
        return m
    p = r + 1
    return nd.binary_closing(np.pad(m, p, mode="edge"), structure=disk(r))[p:-p, p:-p]


def keep_large(m: np.ndarray, n: int) -> np.ndarray:
    lab, k = nd.label(m)
    if not k:
        return m
    s = nd.sum(m, lab, range(1, k + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n])


def down_rgb(rgb: np.ndarray) -> np.ndarray:
    im = Image.fromarray(rgb[..., :3]).resize((SW, H), Image.Resampling.BOX)
    return np.array(im.crop((CROP_X, 0, CROP_X + W, H)))


def down_class(rgb: np.ndarray, masks: dict[str, np.ndarray]) -> tuple[dict[str, np.ndarray], dict[str, np.ndarray]]:
    keys = list(masks)
    weights, premul = [], []
    for k in keys:
        m = masks[k].astype(np.float32)
        w = np.array(
            Image.fromarray((m * 255).astype("uint8")).resize((SW, H), Image.Resampling.BOX).crop((CROP_X, 0, CROP_X + W, H)),
            np.float32,
        ) / 255.0
        ch = []
        for c in range(3):
            p = (rgb[..., c].astype(np.float32) * m).astype("uint8")
            s = np.array(
                Image.fromarray(p).resize((SW, H), Image.Resampling.BOX).crop((CROP_X, 0, CROP_X + W, H)),
                np.float32,
            )
            ch.append(s / np.maximum(w, 1e-5))
        weights.append(w)
        premul.append(np.stack(ch, -1))
    win = np.argmax(np.stack(weights, 0), 0)
    fallback = down_rgb(rgb)
    out_m, out_c = {}, {}
    for i, k in enumerate(keys):
        mk = win == i
        out_m[k] = mk
        c = np.clip(np.round(premul[i]), 0, 255).astype("uint8")
        bad = mk & (weights[i] < 0.05)
        c[bad] = fallback[bad]
        rgba = np.zeros((H, W, 4), "uint8")
        rgba[mk, :3] = c[mk]
        rgba[mk, 3] = 255
        out_c[k] = rgba
    return out_m, out_c


def quantize_group(layers: dict[str, np.ndarray], keys: list[str], n_colors: int) -> None:
    pts = np.concatenate([layers[k][layers[k][..., 3] > 0][:, :3] for k in keys], 0)
    strip = Image.fromarray(pts.reshape(1, -1, 3)).quantize(colors=n_colors, method=Image.Quantize.MEDIANCUT, dither=0)
    raw = strip.getpalette()[: n_colors * 3]
    pal = np.array(raw, dtype=int).reshape(-1, 3)
    for k in keys:
        a = layers[k]
        m = a[..., 3] > 0
        px = a[m][:, :3].astype(int)
        d = ((px[:, None, :] - pal[None, :, :]) ** 2).sum(-1)
        a[m, :3] = pal[d.argmin(1)].astype("uint8")


def materials(a: np.ndarray) -> dict[str, np.ndarray]:
    a = a.astype(float)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)
    return {
        "fond": (lum < 85) & (g > r + 20) & (g > b + 15) & (lum > 55),
        "herbe_claire": (g > 185) & (r > 130) & (b < 120) & (g > r + 20),
        "herbe": (g > 140) & (g <= 185) & (g > r + 30) & (g > b + 60),
        "roche": (r >= g - 15) & (r - b > 25) & (lum > 90) & (lum < 200) & (np.abs(r - g) < 30),
    }


def fidelity(decor: np.ndarray, ref: np.ndarray) -> dict[str, dict]:
    fr, fd = materials(ref), materials(decor)
    out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {
            "rip_rgb": [round(float(v), 1) for v in mr],
            "decor_rgb": [round(float(v), 1) for v in md],
            "distance": round(float(np.linalg.norm(mr - md)), 1),
        }
    return out


def classify(a: np.ndarray) -> tuple[dict[str, np.ndarray], dict[str, object]]:
    """Segmentation pleine résolution (1200 x 896) en 13 classes disjointes :
    autel, embleme, marches, souche, fleurs, rochers, arbres, haies, fond, rayon, ombres, prairie, herbe."""
    a = a.astype(int)
    r, g, b = a.transpose(2, 0, 1)
    la = lum_of(a)
    sat = a.max(-1) - a.min(-1)
    hh, ww = la.shape
    yy, xx = np.mgrid[:hh, :ww]

    fond_raw = open_((nd.uniform_filter(la, 5) < 88) & (g > r + 15), 3)
    lab, _ = nd.label(fond_raw)
    edge_ids = np.unique(np.r_[lab[0], lab[:, 0], lab[:, -1], lab[-1, :480], lab[-1, 720:]])
    fond = np.isin(lab, edge_ids[edge_ids > 0])

    autel_box = (yy >= 170) & (yy <= 268) & (xx >= 564) & (xx <= 636)
    autel_seed = autel_box & ((sat < 65) | (la < 95)) & ~((g - r > 55) & (yy < 178))
    autel_all = nd.binary_fill_holes(close_(keep_large(autel_seed, 500), 2))
    emb_box = (yy >= 205) & (yy <= 245) & (xx >= 582) & (xx <= 618) & autel_all
    embleme = close_((g > r + 20) & (g > 110) & emb_box, 1)
    autel = autel_all & ~embleme

    stump_box = (yy >= 195) & (yy <= 340) & (xx >= 492) & (xx <= 708)
    gold = stump_box & (((r >= g - 15) & (r - b > 38)) | ((la < 95) & (r >= b))) & ~autel_all
    souche_all = nd.binary_fill_holes(close_(keep_large(gold, 2000), 3)) & ~autel_all
    ay, ax = np.nonzero(autel_all)
    marches = souche_all & (yy > int(ay.max()) - 2) & (xx >= int(ax.min()) + 6) & (xx <= int(ax.max()) - 6)
    souche = souche_all & ~marches

    tree_boxes = (
        ((yy >= 135) & (yy <= 365) & (xx >= 215) & (xx <= 405))
        | ((yy >= 130) & (yy <= 355) & (xx >= 800) & (xx <= 985))
        | ((yy >= 520) & (yy <= 745) & (xx >= 170) & (xx <= 355))
        | ((yy >= 520) & (yy <= 745) & (xx >= 845) & (xx <= 1030))
    )
    trunk_zone = tree_boxes & (
        ((xx > 230) & (xx < 360) & (yy > 260) & (yy < 365))
        | ((xx > 840) & (xx < 970) & (yy > 250) & (yy < 355))
        | ((xx > 190) & (xx < 330) & (yy > 640) & (yy < 745))
        | ((xx > 860) & (xx < 1000) & (yy > 640) & (yy < 745))
    )
    tan = (r >= g - 8) & (r - b > 26) & (la > 65) & (la < 220) & ~souche_all & ~autel_all & ~fond & ~trunk_zone
    roc_raw = nd.binary_fill_holes(close_(tan, 3)) & ~souche_all & ~autel_all & ~fond
    rl, rn = nd.label(roc_raw)
    rochers = np.zeros_like(roc_raw)
    for i, s in enumerate(nd.find_objects(rl)):
        m = rl[s] == i + 1
        if m.sum() >= 250 and la[s][m].mean() > 100:
            rochers[s] |= m

    bl = nd.uniform_filter(b.astype(float), 5)
    prairie_raw = (
        (bl < 60) & (g > 188) & (r > 138) & (g > r + 25) & ~autel_all & ~souche_all & ~fond & ~rochers & (yy > 280)
    )
    prairie = keep_large(nd.binary_fill_holes(close_(open_(prairie_raw, 2), 4)), 20000) & ~(
        autel_all | souche_all | fond | rochers
    )

    beam_box = (yy < 208) & (xx > 465) & (xx < 735) & ~fond & ~autel_all & ~souche_all & ~rochers
    beam = beam_box & ((g - r > 60) | (la > 200))
    rayon = nd.binary_fill_holes(close_(keep_large(beam, 2000), 2)) & ~fond & ~autel_all & ~souche_all & ~rochers

    fpx = (
        (((r > 195) & (g < 165)) | (la > 220) | ((r > 200) & (g > 180) & (b < 115)))
        & ~prairie
        & ~rayon
        & ~autel_all
        & ~souche_all
        & ~rochers
        & ~fond
    )
    fl_raw = nd.binary_fill_holes(close_(fpx, 1))
    fl_l, _ = nd.label(fl_raw)
    fleurs = np.zeros_like(fl_raw)
    for i, s in enumerate(nd.find_objects(fl_l)):
        m = fl_l[s] == i + 1
        if 12 <= m.sum() < 450:
            fleurs[s] |= nd.binary_dilation(m, iterations=1)
    fleurs &= ~(fond | rayon | autel_all | souche_all | rochers | prairie)

    flat_grass = (g > 155) & (r > 90) & (la > 140) & (sdev(la, 7) < 6.5)
    tree_cand = tree_boxes & ~flat_grass & ~fond & ~rochers & ~fleurs & ~prairie & ~souche_all & ~autel_all
    ombres = keep_large(
        tree_cand & (la < 78) & (sdev(la, 5) < 8) & (((yy > 285) & (yy < 368)) | ((yy > 670) & (yy < 748))),
        300,
    )
    arbres = keep_large(nd.binary_fill_holes(close_(tree_cand & ~ombres, 2)), 2000) & ~(
        ombres | fond | rochers | fleurs | prairie | souche_all | autel_all | rayon
    )

    rem = ~(fond | rayon | autel | embleme | souche | marches | rochers | fleurs | prairie | arbres | ombres)
    sy, sx = np.nonzero(souche_all)
    front = (yy > int(sy.max()) - 12) & (yy < int(sy.max()) + 45) & (xx > int(sx.min()) + 20) & (xx < int(sx.max()) - 20)
    inner_grass_seed = rem & (la > 135) & (sdev(la, 9) < 8.5) & (xx > 130) & (xx < 1070) & (yy > 160)
    inner_grass = keep_large(open_(inner_grass_seed, 3), 20000)
    herbe = (nd.binary_dilation(inner_grass, iterations=3) & rem & (la > 120)) | (rem & front)
    haies = rem & ~herbe

    masks = dict(
        autel=autel,
        embleme=embleme,
        marches=marches,
        souche=souche,
        fleurs=fleurs,
        rochers=rochers,
        arbres=arbres,
        haies=haies,
        fond=fond,
        rayon=rayon,
        ombres=ombres,
        prairie=prairie,
        herbe=herbe,
    )
    ys_a, xs_a = np.nonzero(autel_all)
    ys_s, _ = np.nonzero(souche_all)
    seg = {
        "autel_y": [int(ys_a.min()), int(ys_a.max())],
        "autel_x": [int(xs_a.min()), int(xs_a.max())],
        "souche_y": [int(ys_s.min()), int(ys_s.max())],
        "fleurs": int(nd.label(fleurs)[1]),
        "rochers": int(nd.label(rochers)[1]),
        "arbres": int(nd.label(arbres)[1]),
    }
    return masks, seg


def ramp_index(px: np.ndarray) -> np.ndarray:
    rp = np.array(RAMP, float)
    return ((px[..., None, :3].astype(float) - rp) ** 2).sum(-1).argmin(-1)


def breath(t: int) -> int:
    return int(round(BREATH * np.sin(2 * np.pi * t / PHASES)))


def beam_frames(base_idx: np.ndarray, mask: np.ndarray, ts=range(PHASES)) -> list[np.ndarray]:
    rp = np.array(RAMP, "uint8")
    frames = []
    w = np.minimum(1.0, base_idx / EDGE_STEPS)
    for t in ts:
        idx = np.clip(np.round(base_idx + breath(t) * w), 0, len(RAMP) - 1).astype(int)
        a = np.zeros((H, W, 4), "uint8")
        a[mask, :3] = rp[idx[mask]]
        a[mask, 3] = 255
        frames.append(a)
    return frames


def emblem_step(t: int) -> int:
    u = min(t % PHASES, PHASES - (t % PHASES))
    return int(round(EMBLEM_GLOW * (1 - np.cos(2 * np.pi * u / PHASES)) / 2))


def emblem_frames(base_idx: np.ndarray, mask: np.ndarray, ts=range(PHASES)) -> list[np.ndarray]:
    rp = np.array(RAMP, "uint8")
    frames = []
    for t in ts:
        idx = np.clip(base_idx + emblem_step(t), 0, len(RAMP) - 1)
        a = np.zeros((H, W, 4), "uint8")
        a[mask, :3] = rp[idx[mask]]
        a[mask, 3] = 255
        frames.append(a)
    return frames


def mote_sprite(kind: str) -> np.ndarray:
    if kind == "dot":
        a = np.zeros((2, 2, 4), "uint8")
        a[:, :] = (*DOT, 255)
        return a
    a = np.zeros((4, 4, 4), "uint8")
    if kind == "cross":
        for y, x in ((0, 1), (0, 2), (1, 0), (1, 3), (2, 0), (2, 3), (3, 1), (3, 2)):
            a[y, x] = (*GLOW, 255)
    else:
        a[1:3, :] = (*GLOW, 255)
        a[:, 1:3] = (*GLOW, 255)
    a[1:3, 1:3] = (*CORE, 255)
    return a


def mote_frames(ts=range(PHASES)) -> list[np.ndarray]:
    sp = {k: mote_sprite(k) for k in ("dot", "cross", "bright")}
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), "uint8")
        for x0, y0, off, amp in MOTES:
            u = (t + off) % PHASES
            if u in (0, PHASES - 1):
                continue
            kind = "dot" if u in (1, 2, PHASES - 3, PHASES - 2) else ("bright" if 9 <= u <= 14 else "cross")
            dx = int(round(amp * np.sin(2 * np.pi * u / 12)))
            x, y = x0 + dx, y0 - MOTE_RISE * u
            s = sp[kind]
            hh, ww = s.shape[:2]
            m = s[..., 3] > 0
            a[y : y + hh, x : x + ww][m] = s[m]
        frames.append(a)
    return frames


def bfs_16(walk: np.ndarray, start: tuple[int, int], goal: tuple[int, int]) -> bool:
    ok = lambda x, y: 0 <= x < GW - 1 and 0 <= y < GH - 1 and bool(walk[y : y + 2, x : x + 2].all())
    if not (ok(*start) and ok(*goal)):
        return False
    seen = {start}
    q = deque([start])
    while q:
        x, y = q.popleft()
        if (x, y) == goal:
            return True
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if (nx, ny) not in seen and ok(nx, ny):
                seen.add((nx, ny))
                q.append((nx, ny))
    return False


def write_ora(path: Path, layers: dict[str, np.ndarray]) -> None:
    import xml.etree.ElementTree as ET

    root = ET.Element("image", w=str(W), h=str(H), name="Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4)")
    stack = ET.SubElement(root, "stack")
    comp = Image.new("RGBA", (W, H))
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f"data/layer{i:02d}.png"
            ET.SubElement(
                stack,
                "layer",
                name=name,
                src=fn,
                x="0",
                y="0",
                opacity="1.0",
                visibility="visible",
                **{"composite-op": "svg:src-over"},
            )
            b = io.BytesIO()
            Image.fromarray(a).save(b, format="PNG")
            z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO()
        comp.save(b, format="PNG")
        z.writestr("mergedimage.png", b.getvalue())
        th = comp.copy()
        th.thumbnail((256, 256))
        b = io.BytesIO()
        th.save(b, format="PNG")
        z.writestr("Thumbnails/thumbnail.png", b.getvalue())
        z.writestr("stack.xml", ET.tostring(root, encoding="utf-8", xml_declaration=True))


def ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl_path = R / "source" / "cote_v5_expeditions" / "references" / "ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground"
    tpl = json.loads(tpl_path.read_text(encoding="utf-8-sig"))
    o = tpl["Object"]
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f"{PFX}_{i:02d}_{title.split()[0].upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8]), x, y)
                fs.append(f if f else {"Sheet": bank.name, "TexLoc": {"X": 0, "Y": 0}})
            if all(f["TexLoc"] == {"X": 0, "Y": 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(gfx.layer(f"{i:02d} {title}", GW, GH, cell, ticks))
        banks.append(bank)
    top = gfx.layer(f"{len(stack):02d} Top", GW, GH, lambda x, y: [], STATIC_TICKS)
    top["Layer"] = 4
    layers.append(top)

    o["AssetName"] = "fjs4_fin_jardin_secret_sanctuaire"
    o["Name"]["DefaultText"] = "Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4)"
    o["Name"]["LocalTexts"] = {"fr": "Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4)"}
    o["ScrollEdge"] = 1
    o["TexSize"] = 1
    o["WallLayers"] = [
        {
            "Name": "00 Collisions",
            "Visible": True,
            "Layer": 2,
            "Tiles": [[1 if blocked[y, x] else 0 for y in range(GH)] for x in range(GW)],
        }
    ]
    o["Decorations"] = []
    o["Layers"] = layers
    o["Entities"] = [
        {
            "Name": "Markers",
            "Elements": [
                {
                    "Name": "entrance",
                    "Position": {"X": int(entry_px[0]), "Y": int(entry_px[1])},
                    "Direction": 4,
                    "EntEnabled": True,
                },
                {
                    "Name": "boss_center",
                    "Position": {"X": int(boss_px[0]), "Y": int(boss_px[1])},
                    "Direction": 0,
                    "EntEnabled": True,
                },
                {
                    "Name": "autel_celebi",
                    "Position": {"X": int(goal_px[0]), "Y": int(goal_px[1])},
                    "Direction": 4,
                    "EntEnabled": True,
                },
            ],
        }
    ]

    tile_dir = STAGE / "Content" / "Tile"
    tile_dir.mkdir(parents=True, exist_ok=True)
    for b in banks:
        b.write(tile_dir / f"{b.name}.tile")
    nodes = {}
    for p in sorted(tile_dir.glob("*.tile")):
        with p.open("rb") as f:
            nodes[p.stem] = tools.read_node(f)
    (tile_dir / "index.idx").write_bytes(tools.encode_index(nodes))
    gdir = STAGE / "Data" / "Ground"
    gdir.mkdir(parents=True, exist_ok=True)
    (gdir / "fjs4_fin_jardin_secret_sanctuaire.rsground").write_bytes(
        b"\xef\xbb\xbf" + json.dumps(tpl, ensure_ascii=False, indent=2).encode("utf-8")
    )
    (STAGE / "Mod.xml").write_text(
        "<Header>\n  <Name>Fin du Jardin Secret — Sanctuaire de Celebi V1 (FJS4)</Name>\n"
        "  <Author>Per Aspera — lot autonome FJS4</Author>\n"
        "  <Description>Clairière sanctuaire de Celebi (Jardin secret), format 4:3 vaste (768x576, grille 8 px).</Description>\n"
        "  <Namespace>fin_jardin_secret_sanctuaire</Namespace>\n  <UUID>D9B84E21-6A43-4F18-8E52-3C709B1A4404</UUID>\n"
        "  <Version>1.0</Version>\n  <GameVersion>0.8.12.0</GameVersion>\n  <ModType>Mod</ModType>\n"
        "  <Relationships />\n</Header>\n",
        encoding="utf-8",
    )
    return {b.name: len(b.data) for b in banks}


def main() -> None:
    gfx = load_mod("pmdo_gfx", R / "source" / "pmdo_cote" / "build.py")
    tools = load_mod("pmdo_inst", R / "source" / "pmdo_cote" / "INSTALLER.py")
    if OUT.exists():
        shutil.rmtree(OUT)

    ref = np.array(Image.open(REF).convert("RGB"))
    decor = np.array(Image.open(BRUTS / "decor.png").convert("RGB"))
    sol_raw = np.array(Image.open(BRUTS / "sol_complet.png").convert("RGB"))
    assert decor.shape == (RAW_H, RAW_W, 3) and sol_raw.shape == (RAW_H, RAW_W, 3)

    fid = fidelity(decor, ref)
    for k, d in fid.items():
        assert d["distance"] < FIDELITY_MAX, (k, d)

    masks_full, seg_info = classify(decor)
    assert (np.sum(list(masks_full.values()), 0) == 1).all()
    masks, layers = down_class(decor, masks_full)
    assert (np.sum(list(masks.values()), 0) == 1).all()

    sol_c = np.zeros((H, W, 4), "uint8")
    sol_c[..., :3] = down_rgb(sol_raw)
    sol_c[..., 3] = 255
    layers["sol_complet"] = sol_c

    for _, (keys, ncol) in PALETTE_GROUPS.items():
        quantize_group(layers, keys, ncol)

    fr = materials(ref)
    final_fid = {}
    for lk, fk in (("prairie", "herbe_claire"), ("herbe", "herbe"), ("rochers", "roche"), ("fond", "fond")):
        px = layers[lk][masks[lk]][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[fk][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        m = px.mean(0)
        d = float(np.linalg.norm(m - ref[fr[fk]].mean(0)))
        assert d < FIDELITY_MAX, (lk, fk, d)
        final_fid[lk] = {
            "calque": lk,
            "matiere": fk,
            "rgb": [round(float(v), 1) for v in m],
            "distance_rip": round(d, 1),
        }

    # Fond continu sous l'emblème et le rayon (fond forestier pour le rayon, pierre de l'autel sous l'emblème)
    f_cols = layers["fond"][masks["fond"]][:, :3]
    f_med = np.median(f_cols, 0).astype("uint8")
    layers["fond"][masks["rayon"]] = (*f_med, 255)
    a_cols = layers["autel"][masks["autel"]][:, :3]
    a_med = np.median(a_cols, 0).astype("uint8")
    layers["autel"][masks["embleme"]] = (*a_med, 255)
    masks_static = {k: masks[k].copy() for k in STATIC}
    masks_static["fond"] = masks["fond"] | masks["rayon"]
    masks_static["autel"] = masks["autel"] | masks["embleme"]

    beam_idx = ramp_index(layers["rayon"])
    emb_idx = ramp_index(layers["embleme"])
    emb_frames = emblem_frames(emb_idx, masks["embleme"])
    ray_frames = beam_frames(beam_idx, masks["rayon"])
    mot_frames = mote_frames()

    save(layers["sol_complet"], OUT / "calques/FJS4_00_sol_complet.png")
    for i, k in enumerate(STATIC, 1):
        save(layers[k], OUT / f"calques/FJS4_{i:02d}_{k}.png")
    for t in range(PHASES):
        save(emb_frames[t], OUT / f"animation/embleme/FJS4_12_embleme_f{t:02d}.png")
        save(ray_frames[t], OUT / f"animation/rayon/FJS4_13_rayon_f{t:02d}.png")
        save(mot_frames[t], OUT / f"animation/lucioles/FJS4_14_lucioles_f{t:02d}.png")

    for k in ("dot", "cross", "bright"):
        save(mote_sprite(k), OUT / f"poses/luciole_{k}.png")

    walk_px = masks["prairie"] | masks["herbe"] | masks["ombres"] | masks["fleurs"] | masks["marches"]
    for k, m in {**masks_static, "embleme": masks["embleme"], "rayon": masks["rayon"], "praticable": walk_px}.items():
        save((m.astype("uint8") * 255), OUT / f"masques/FJS4_masque_{k}.png")

    walk = walk_px.reshape(GH, CELL, GW, CELL).mean((1, 3)) >= 0.75
    blocked = ~walk
    entry_cell = (GW // 2 - 1, GH - 3)
    boss_cell = (GW // 2 - 1, 44)
    ay_max = int(np.nonzero(masks_static["autel"])[0].max()) // CELL
    goal_cell = next(
        (GW // 2 - 1, gy)
        for gy in range(ay_max + 1, ay_max + 12)
        if walk[gy : gy + 2, GW // 2 - 1 : GW // 2 + 1].all()
    )
    assert bfs_16(walk, entry_cell, boss_cell), (entry_cell, boss_cell)
    assert bfs_16(walk, boss_cell, goal_cell), (boss_cell, goal_cell)
    entry_px = [(entry_cell[0] + 1) * CELL, (entry_cell[1] + 1) * CELL]
    boss_px = [(boss_cell[0] + 1) * CELL, (boss_cell[1] + 1) * CELL]
    goal_px = [(goal_cell[0] + 1) * CELL, (goal_cell[1] + 1) * CELL]

    (OUT / "review").mkdir(parents=True, exist_ok=True)
    base = Image.fromarray(layers["sol_complet"])
    for k in STATIC:
        base.alpha_composite(Image.fromarray(layers[k]))
    frames_comp = []
    for t in range(PHASES):
        im = base.copy()
        im.alpha_composite(Image.fromarray(emb_frames[t]))
        im.alpha_composite(Image.fromarray(ray_frames[t]))
        im.alpha_composite(Image.fromarray(mot_frames[t]))
        frames_comp.append(im)
        if t in (0, 6, 12, 18):
            im.save(OUT / f"review/FJS4_scene_t{t * TICKS:03d}.png", optimize=True)
    frames_comp[0].save(
        OUT / "review/FJS4_scene_animee.webp",
        save_all=True,
        append_images=frames_comp[1:],
        duration=int(round(TICKS * 1000 / 60)),
        loop=0,
        lossless=True,
    )

    ov = frames_comp[0].copy()
    red = np.zeros((H, W, 4), "uint8")
    for y in range(GH):
        for x in range(GW):
            if blocked[y, x]:
                red[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8] = (220, 40, 40, 90)
    ov.alpha_composite(Image.fromarray(red))
    dr = ImageDraw.Draw(ov)
    for px, col in ((entry_px, (60, 220, 255, 255)), (boss_px, (255, 80, 100, 255)), (goal_px, (255, 230, 40, 255))):
        dr.rectangle([px[0] - 8, px[1] - 8, px[0] + 7, px[1] + 7], outline=col, width=2)
    ov.save(OUT / "review/FJS4_collisions_marqueurs.png", optimize=True)

    sheet = Image.new("RGBA", (360, 120), (18, 28, 20, 255))
    for i, c in enumerate(RAMP):
        ImageDraw.Draw(sheet).rectangle([12 + i * 14, 16, 24 + i * 14, 44], fill=(*c, 255))
    for i, k in enumerate(("dot", "cross", "bright")):
        sp = Image.fromarray(mote_sprite(k)).resize((32, 32), Image.Resampling.NEAREST)
        sheet.alpha_composite(sp, (24 + i * 72, 64))
    sheet.save(OUT / "review/FJS4_planche_poses.png", optimize=True)

    write_ora(
        OUT / "FJS4_fin_jardin_secret_calques.ora",
        {
            "00_sol_complet": layers["sol_complet"],
            **{f"{i:02d}_{k}": layers[k] for i, k in enumerate(STATIC, 1)},
            "12_embleme_f00": emb_frames[0],
            "13_rayon_f00": ray_frames[0],
            "14_lucioles_f00": mot_frames[0],
        },
    )

    stack = [
        ("sol_complet", [layers["sol_complet"]], STATIC_TICKS),
        *[(k, [layers[k]], STATIC_TICKS) for k in STATIC],
        ("embleme", emb_frames, TICKS),
        ("rayon", ray_frames, TICKS),
        ("lucioles", mot_frames, TICKS),
    ]
    tiles_per_bank = ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools)

    manifest = {
        "lot": "fin_jardin_secret_sanctuaire_v1",
        "prefix": PFX,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_8px": [GW, GH],
        "biome": "jardin secret (clairière sanctuaire intérieure de Celebi, souche dorée et autel sous faisceau lumineux)",
        "method": "textures canoniques = rendu généré référencé sur secretgarden.png ; rayon, emblème et lucioles sur la rampe EXACTE des 22 verts du rip",
        "reference_da": {
            "file": "source/fin_jardin_secret_sanctuaire_v1/reference/secretgarden.png",
            "sha256": sha256(REF),
            "titre": "Jardin secret (Explorers of Sky, secretgarden.png)",
        },
        "generation": [
            {"file": fn, "images": ["source/fin_jardin_secret_sanctuaire_v1/reference/secretgarden.png"], "prompt": pr}
            for fn, pr in PROMPTS.items()
        ],
        "raw_inputs": [
            {
                "file": f"source/fin_jardin_secret_sanctuaire_v1/bruts/{fn}",
                "sha256": sha256(BRUTS / fn),
                "size": [RAW_W, RAW_H],
            }
            for fn in ("decor.png", "sol_complet.png")
        ],
        "segmentation_mesures": seg_info,
        "fidelite_rip": {
            "methode": "moyenne RGB par matière (fond, herbe_claire, herbe, roche), distance euclidienne < 35",
            "brut": fid,
            "calques_finaux": final_fid,
            "sol_complet": round(
                float(np.linalg.norm(layers["sol_complet"][..., :3].mean((0, 1)) - ref[fr["herbe"]].mean(0))), 1
            ),
            "seuil": FIDELITY_MAX,
        },
        "normalization": {
            "scale": SCALE,
            "scaled": [SW, H],
            "crop_x": [CROP_X, SW - W - CROP_X],
            "palettes": {g: {"calques": ks, "couleurs": nc} for g, (ks, nc) in PALETTE_GROUPS.items()},
        },
        "layers": [
            {"file": "calques/FJS4_00_sol_complet.png", "phases": 1, "ticks": STATIC_TICKS},
            *[
                {"file": f"calques/FJS4_{i:02d}_{k}.png", "phases": 1, "ticks": STATIC_TICKS}
                for i, k in enumerate(STATIC, 1)
            ],
            {"file": "animation/embleme/FJS4_12_embleme_fNN.png", "phases": PHASES, "ticks": TICKS},
            {"file": "animation/rayon/FJS4_13_rayon_fNN.png", "phases": PHASES, "ticks": TICKS},
            {"file": "animation/lucioles/FJS4_14_lucioles_fNN.png", "phases": PHASES, "ticks": TICKS},
        ],
        "animations": {
            "rampe_22_verts_rip": [list(c) for c in RAMP],
            "embleme_crans": EMBL_GLOW if "EMBL_GLOW" in globals() else EMBLEM_GLOW,
            "rayon_amplitude": BREATH,
            "lucioles": len(MOTES),
        },
        "scene_loop_ticks": LOOP_TICKS,
        "access": {
            "entry_px": entry_px,
            "boss_px": boss_px,
            "goal_px": goal_px,
            "walkable_cells": int(walk.sum()),
            "blocked_cells": int(blocked.sum()),
            "path_found_16x16": True,
        },
        "pmdo": {
            "target_version": "0.8.12.0",
            "ground": "fjs4_fin_jardin_secret_sanctuaire.rsground",
            "banks": list(tiles_per_bank),
            "tiles_per_bank": tiles_per_bank,
            "total_tiles": int(sum(tiles_per_bank.values())),
            "runtime_tested": False,
        },
        "art_approved": False,
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(
        json.dumps(
            {
                "entry": entry_px,
                "boss": boss_px,
                "goal": goal_px,
                "walkable": int(walk.sum()),
                "fidelite": {k: v["distance"] for k, v in fid.items()},
                "tiles": sum(tiles_per_bank.values()),
            },
            indent=1,
        )
    )


if __name__ == "__main__":
    main()
