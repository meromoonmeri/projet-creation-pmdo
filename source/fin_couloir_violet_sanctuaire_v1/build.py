#!/usr/bin/env python3
"""Fin du Couloir violet — Sanctuaire de la Stèle V1 (FCV4) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Fin de donjon appairée à l'entrée `entree_couloir_violet_sud_nord_v1` (`ECV1`).
Préfixe `.tile` : `FCV4` (unique sur `main`, sur la branche courante et sur toutes les branches sœurs `arena/*`
où `FCV1..3` sont déjà pris).
Référence canonique ROM : `reference/S05P03A.png` (312 x 720, 34 couleurs NDS 5 bits exactes, extraite de `pret/pmd-sky`).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (`images=[S05P03A.png]`) :
- `bruts/decor_magenta.png` : décor complet 4:3 (1200 x 896) de la salle de fin en cul-de-sac avec stèle sculptée au nord ;
- `bruts/sol_complet.png` : sol mauve marbré seul (1200 x 896) ;
- `bruts/poussiere_poses.png` : 4 poses de nuages de poussière mauve sur fond magenta `#FF00FF`.

Calques statiques disjoints : `sol_complet` (fond plein) + partition exacte (`sol`, `ombres`, `gravillons`, `blocs`,
`rochers`, `falaise`, `vide`, `stele`).
Animations en boucles fermées sur `120` ticks (`24 x 5` ticks = `2.0 s`) :
- `lueurs_stele` : onde lumineuse lilas-violet sur les reliefs sculptés de la stèle nord, utilisant exclusivement
  les tons clairs lilas-violet exacts de `S05P03A.png` ;
- `eboulis` : les 3 gravillons (`petit`, `moyen`, `gros`) relevés pixel par pixel sur `S05P03A.png` (couleurs EXACTES
  du rip) tombent du pied des parois en 4 chutes décalées de 6 phases, rebondissent et roulent de 4 px ;
- `poussiere` : 4 poses générées (6 couleurs mauves de la planche) à chaque impact.

Lancer : .venv/bin/python source/fin_couloir_violet_sanctuaire_v1/build.py
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import math
import shutil
import uuid
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / "bruts"
REF_DIR = HERE / "reference"
REF_NAME = "S05P03A.png"
REF = REF_DIR / REF_NAME
OUT = R / "renders" / "fin_couloir_violet_sanctuaire_v1"
STAGE = R / ".cache" / "fin_couloir_violet_sanctuaire_v1" / "fin_couloir_violet_sanctuaire"
NAMESPACE = "fin_couloir_violet_sanctuaire"
ASSET = "fcv4_fin_couloir_violet"
PFX = "FCV4"
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = "source/fin_couloir_violet_sanctuaire_v1"

GEN = [
    {
        "file": "decor_magenta.png",
        "images": [f"{LOT}/reference/{REF_NAME}"],
        "prompt": (
            "Generate an image: use EXACTLY the same textures, palette and Nintendo DS 16-bit pixel-art style as the "
            "reference image S05P03A.png (Pokemon Mystery Dungeon Explorers of Sky purple rocky corridor cul-de-sac): "
            "same mottled mauve-purple stone floor, same stacked rounded blue-violet boulders with pale lilac highlights "
            "forming the walls, same dark blue-indigo striated outer rock cliffs along the outer edges, same small dark "
            "round pebbles on the floor near the walls, and same very dark navy-black outer void at the extreme corners. "
            "Make a NEW, larger top-down dungeon-end boss chamber map in WIDE LANDSCAPE 4:3 (1200x896), zoomed out so "
            "the sanctuary feels vast: narrow mauve-purple floor corridor at SOUTH, wide semicircular/octagonal boss "
            "chamber in CENTER, and closed semicircular sanctuary alcove of tall stacked blue-violet boulders framing a "
            "carved monolith boulder at NORTH."
        ),
        "essais": "premier essai ; conforme (sol < 10, roche < 10 ; seuil 35)",
    },
    {
        "file": "sol_complet.png",
        "images": [f"{LOT}/reference/{REF_NAME}"],
        "prompt": (
            "Generate an image: fill the ENTIRE 4:3 (1200x896) image edge to edge with the mottled mauve-purple cave "
            "stone floor texture from the central corridor of the reference image S05P03A.png: same pixel-art mottled "
            "mauve-purple stone pattern, same palette and contrast, keeping the crisp pixel-art texture detail across "
            "the whole canvas. Wide landscape 4:3."
        ),
        "essais": "premier essai nettoyé des gravillons isolés ; distance < 10 au sol du rip",
    },
    {
        "file": "poussiere_poses.png",
        "images": [f"{LOT}/reference/{REF_NAME}"],
        "prompt": (
            "Generate an image: a 4:3 (1200x896) pixel-art sprite sheet on a flat pure magenta (#FF00FF) background "
            "showing 4 animation poses of a small cave dust puff cloud rising when a pebble hits a stone floor, arranged "
            "in 4 separate quadrants with wide pure #FF00FF magenta margins around each puff: from a small compact puff "
            "to a medium expanding puff to a wider ring puff to faint dispersing wisps. Use ONLY mauve-purple and pale "
            "lilac-grey colors taken from the reference image floor and rock highlights."
        ),
        "essais": "premier essai ; 4 quadrants nets sur fond #FF00FF",
    },
]

# Gravillons relevés pixel par pixel sur S05P03A.png (boîte y, x, h, w de la composante de roche entourée de sol)
PEBBLES = {"petit": (113, 136, 6, 7), "moyen": (131, 78, 7, 10), "gros": (130, 204, 12, 12)}

# Fenêtres (cx, cy, côté) des 4 poses de poussière dans bruts/poussiere_poses.png (1200x896), réduction 1/12
PUFF_WIN = [(296, 222, 192), (896, 228, 312), (300, 676, 384), (896, 660, 384)]
PUFF_K, PUFF_COV, PUFF_COLORS = 12, 0.30, 6

# Chutes : (cible x, cible y, gravillon, décalage de phase, sens du roulement)
DROPS = [
    (210, 156, "moyen", 0, 1),
    (556, 156, "gros", 6, -1),
    (156, 260, "petit", 12, 1),
    (610, 260, "moyen", 18, -1),
]
FALL = [-21, -16, -9, 0]
BOUNCE = {4: -3, 5: -1}
ROLL = [0, 0, 0, 0, 1, 2, 3, 4]
VISIBLE = 20
PUFF_AT = {3: 0, 4: 1, 5: 2, 6: 3}


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod("ewc1_build", R / "source/entree_waterfall_cave_sud_nord_v1/build.py")
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group

PALETTE_GROUPS = {
    "sol": (["sol_complet", "sol", "ombres"], 64),
    "roche": (["gravillons", "blocs", "rochers", "falaise", "stele"], 96),
    "sombre": (["vide"], 16),
}
STATIC = ["sol", "ombres", "gravillons", "blocs", "rochers", "falaise", "vide", "stele"]
ANIMS = ["lueurs_stele", "eboulis", "poussiere"]


def open_(m: np.ndarray, it: int) -> np.ndarray:
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode="edge"), iterations=it)[p:-p, p:-p]


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert("RGB")).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def materials(a: np.ndarray) -> dict[str, np.ndarray]:
    """Sol mauve (r > g, lum > 55) et roche bleu-violet (r ~ g, b >> r)."""
    a = a.astype(float)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)
    return {
        "sol": ((r - g) >= 6) & (lum > 55),
        "roche": ((r - g) < 6) & (b - r > 20) & (lum > 45),
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


def classify(a: np.ndarray) -> tuple[dict[str, np.ndarray], dict]:
    """Segmentation pleine résolution (1200 x 896) en 8 classes statiques disjointes :
    - `sol` : sol mauve marbré principal (`r - g >= 6` et `L > 45`), plus grande composante bouchée ;
    - `gravillons` : petits îlots rocheux dans le sol (`12 <= aire < 600`) ;
    - `blocs` : amas rocheux posés dans la salle (`aire >= 600` + amas de bordure interne) ;
    - `ombres` : sol assombri (`L < 63`) à `<= 32 px` des parois, blocs et gravillons ;
    - `stele` : monolithe / stèle sculptée au centre de l'alcôve nord (`y = 92..222, x = 548..648`) ;
    - `vide` : abîme sombre externe (`L < 25`) relié au bord de l'image ;
    - `falaise` : parois rocheuses externes striées verticalement (`anisotropie > 1.35`) ;
    - `rochers` : rochers bleu-violet empilés formant l'enceinte et l'alcôve nord."""
    r, g, b = a.transpose(2, 0, 1)
    lum = lum_of(a)
    hh, ww = lum.shape
    yy, xx = np.mgrid[:hh, :ww]
    L = nd.uniform_filter(lum, 5)
    rg = nd.uniform_filter((r - g).astype(float), 5)

    floorc = (rg >= 6) & (L > 45)
    floor = keep_large(open_(close_(floorc, 2), 2), 20000)
    floor_filled = nd.binary_fill_holes(floor)
    isl = open_(floor_filled & ~floorc, 1)
    il, inn = nd.label(isl)
    sz = nd.sum(isl, il, range(1, inn + 1))
    blocs = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 600])
    grav = np.isin(il, [i + 1 for i, v in enumerate(sz) if 12 <= v < 600])

    sol_raw = floor_filled & ~blocs & ~grav
    wall = ~floor_filled

    stele_box = (yy >= 92) & (yy <= 222) & (xx >= 548) & (xx <= 648) & wall & (L > 22)
    stele = close_(open_(stele_box, 2), 2) & wall

    db = nd.distance_transform_edt(~(wall | blocs | grav))
    omb = sol_raw & (L < 63) & (db <= 32)
    omb = open_(close_(omb, 2), 1) & sol_raw
    sol = sol_raw & ~omb

    vide = keep_large(open_((L < 25) & wall & ~stele, 4), 3000)
    lab, _ = nd.label(vide)
    edge = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])
    vide = np.isin(lab, edge[edge > 0])

    gx, gy = np.abs(nd.sobel(lum, 1)), np.abs(nd.sobel(lum, 0))
    an = nd.uniform_filter(gx, 21) / (nd.uniform_filter(gy, 21) + 1)
    fal = keep_large(close_((an > 1.35) & wall & ~vide & ~stele, 6), 4000) & wall & ~vide & ~stele
    roc = wall & ~vide & ~fal & ~stele

    rim_boulders = roc & (nd.distance_transform_edt(~sol_raw) <= 28) & (
        ((yy >= 580) & (yy <= 780) & ((xx <= 310) | (xx >= 890)))
        | ((yy >= 150) & (yy <= 290) & (((xx >= 210) & (xx <= 310)) | ((xx >= 890) & (xx <= 990))))
    )
    blocs = blocs | open_(rim_boulders, 2)
    roc = roc & ~blocs

    masks = dict(
        stele=stele,
        gravillons=grav,
        blocs=blocs,
        ombres=omb & ~grav & ~blocs,
        sol=sol & ~omb,
        vide=vide,
        falaise=fal,
        rochers=roc,
    )
    ys_, xs_ = np.nonzero(stele)
    _, n_blocs = nd.label(blocs)
    _, n_grav = nd.label(grav)
    seg = {
        "stele_y": [int(ys_.min()), int(ys_.max())],
        "stele_x": [int(xs_.min()), int(xs_.max())],
        "blocs": int(n_blocs),
        "gravillons": int(n_grav),
        "ombres_lum": round(float(lum[masks["ombres"]].mean()), 1),
        "sol_lum": round(float(lum[masks["sol"]].mean()), 1),
    }
    return masks, seg


def rip_pebbles(ref: np.ndarray) -> dict[str, np.ndarray]:
    """Composante de roche (r - g < 6, 8-connexe) entièrement entourée de sol, couleurs EXACTES de S05P03A.png."""
    floor = (ref[..., 0] - ref[..., 1]) >= 6
    lab, _ = nd.label(~floor, structure=np.ones((3, 3)))
    out = {}
    for name, (y, x, h, w) in PEBBLES.items():
        sl = (slice(y, y + h), slice(x, x + w))
        ids = np.unique(lab[sl][~floor[sl]])
        assert len(ids) == 1, (name, ids)
        m = lab[sl] == ids[0]
        ring = nd.binary_dilation(lab == ids[0], structure=np.ones((3, 3))) & (lab != ids[0])
        assert floor[ring].all(), name
        spr = np.zeros((h, w, 4), "uint8")
        spr[..., :3] = ref[sl]
        spr[..., 3] = m * 255
        spr[~m] = 0
        out[name] = spr
    return out


def puff_poses(path: Path) -> tuple[list[np.ndarray], np.ndarray]:
    s = rgb(path)
    r, g, b = s.transpose(2, 0, 1)
    bg = (r - g > 60) & (b - g > 60)
    masks = []
    for cx, cy, side in PUFF_WIN:
        y0, x0 = max(0, cy - side // 2), max(0, cx - side // 2)
        sl = (slice(y0, min(s.shape[0], y0 + side)), slice(x0, min(s.shape[1], x0 + side)))
        m = ~bg[sl]
        m = nd.binary_opening(m, iterations=1)
        m = nd.binary_fill_holes(nd.binary_closing(m, iterations=1)) & ~bg[sl]
        masks.append((sl, m))
    px = np.concatenate([s[sl][m] for sl, m in masks])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype("uint8")).quantize(colors=PUFF_COLORS, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[: PUFF_COLORS * 3], float).reshape(-1, 3)
    poses = []
    for sl, m in masks:
        w = s[sl].astype(float)
        h_s, w_s = m.shape
        nh, nw = h_s // PUFF_K, w_s // PUFF_K
        k = PUFF_K
        mm = m[: nh * k, : nw * k]
        ww = w[: nh * k, : nw * k]
        blk = mm.reshape(nh, k, nw, k)
        cov = blk.mean((1, 3))
        col = (ww * mm[..., None]).reshape(nh, k, nw, k, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
        o = np.zeros((nh, nw, 4), "uint8")
        o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
        o[..., 3] = 255
        o[cov < PUFF_COV] = 0
        ys, xs = np.nonzero(o[..., 3])
        o = o[ys.min() : ys.max() + 1, xs.min() : xs.max() + 1]
        poses.append(o)
    return poses, pal


def build_lueurs_stele_frames(stele_rgba: np.ndarray, stele_mask: np.ndarray, ref: np.ndarray) -> tuple[list[np.ndarray], list[list[int]]]:
    """Construit les 24 frames (24 x 5 = 120 ticks) de lueur mystique sur la stèle nord aux couleurs exactes du rip."""
    ref_unique = np.unique(ref.reshape(-1, 3), axis=0)
    # Rampe des 6 tons lilas-violet les plus lumineux de S05P03A.png (b > r, luminance croissante)
    lilac_sel = ref_unique[(ref_unique[:, 2] >= ref_unique[:, 0] + 16) & (lum_of(ref_unique) >= 72.0)]
    order_l = np.argsort(lum_of(lilac_sel))
    ramp = lilac_sel[order_l][-6:].astype(np.uint8)

    lum_s = lum_of(stele_rgba[..., :3])
    # Reliefs sculptés et arêtes claires de la stèle
    carved = stele_mask & ((lum_s >= np.percentile(lum_s[stele_mask], 64.0)) | (lum_s <= np.percentile(lum_s[stele_mask], 22.0)))
    yy, xx = np.mgrid[:H, :W].astype(np.float32)
    ys, xs = np.nonzero(stele_mask)
    cy, cx = float(ys.mean()), float(xs.mean())
    r_dist = np.hypot(xx - cx, yy - cy)

    frames = []
    for p in range(PHASES):
        phase_ang = 2.0 * math.pi * (p / float(PHASES))
        wave = np.cos(r_dist / 9.5 - phase_ang)
        active = carved & (wave > -0.15)
        idx = np.clip(np.floor(((wave[active] + 0.15) / 1.15) * len(ramp)).astype(int), 0, len(ramp) - 1)
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        fr[active, :3] = ramp[idx]
        fr[active, 3] = 255
        frames.append(fr)
    return frames, [[int(c) for c in row] for row in ramp]


def paste(frame: np.ndarray, spr: np.ndarray, x0: int, y0: int) -> None:
    hh, ww = spr.shape[:2]
    x0, y0 = int(x0), int(y0)
    ys0, xs0 = max(0, -y0), max(0, -x0)
    ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]
    m = s[..., 3] > 0
    frame[y0 + ys0 : y0 + ys1, x0 + xs0 : x0 + xs1][m] = s[m]


def landing_spots(ground: np.ndarray, wall: np.ndarray) -> list[tuple[int, int, str, int, int]]:
    """Point de sol le plus proche de chaque cible : 6 x 3 px de sol autour, paroi en (x, y-8) et (x, y-20)."""
    ok = nd.minimum_filter(ground.astype(np.uint8), size=(3, 13), origin=(-1, 0)) > 0
    ok &= np.roll(wall, 8, 0) & np.roll(wall, 20, 0)
    ok[:24] = False
    ok[:, :8] = False
    ok[:, -8:] = False
    ok[-4:] = False
    ys, xs = np.nonzero(ok)
    spots = []
    for tx, ty, name, off, sens in DROPS:
        i = int(((xs - tx) ** 2 + (ys - ty) ** 2).argmin())
        spots.append((int(xs[i]), int(ys[i]), name, off, sens))
    return spots


def pebble_state(u: int, sens: int) -> tuple[int, int] | None:
    if u >= VISIBLE:
        return None
    dy = FALL[u] if u < len(FALL) else BOUNCE.get(u, 0)
    dx = sens * ROLL[min(u, len(ROLL) - 1)]
    return dx, dy


def anim_frames(pebbles: dict[str, np.ndarray], puffs: list[np.ndarray], spots: list, ts=range(PHASES)):
    peb, dust = [], []
    for t in ts:
        a = np.zeros((H, W, 4), "uint8")
        d = np.zeros((H, W, 4), "uint8")
        for x, y, name, off, sens in spots:
            u = (t - off) % PHASES
            spr = pebbles[name]
            st = pebble_state(u, sens)
            if u in PUFF_AT:
                p = puffs[PUFF_AT[u]]
                ph, pw = p.shape[:2]
                paste(d, p, x - pw // 2, y + spr.shape[0] // 2 - ph + 2)
            if st:
                paste(a, spr, x - spr.shape[1] // 2 + st[0], y - spr.shape[0] // 2 + st[1])
        peb.append(a)
        dust.append(d)
    return peb, dust


def write_ora(path: Path, layers: dict[str, np.ndarray]) -> None:
    import xml.etree.ElementTree as ET

    root = ET.Element("image", w=str(W), h=str(H), name="Fin Couloir violet — Sanctuaire V1 (FCV4)")
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


def load_ground_template() -> dict:
    p = R / "source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground"
    return json.loads(p.read_text(encoding="utf-8-sig"))


def ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = load_ground_template()
    o = tpl["Object"]
    gw, gh = W // 8, H // 8
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

        layers.append(gfx.layer(f"{i:02d} {title}", gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(gfx.layer(f"{len(layers):02d} Vos elements avant-plan (Top)", gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f"Content/Tile/{bank.name}.tile")
    o.update(
        Name={"DefaultText": "Fin Couloir violet - Sanctuaire de la Stele (4:3)", "LocalTexts": {}},
        AssetName=ASSET,
        Released=False,
        TexSize=1,
        Music="",
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={"X": 0, "Y": 0},
        ActiveChar=None,
        Status={},
        Layers=layers,
        Background={"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        Comment=(
            "PMDO 0.8.12. Fin du Couloir violet (FCV4, appairee a ECV1), rendu genere 4:3 reference sur S05P03A.png : "
            "eboulis animes aux gravillons exacts du rip, poussiere generee et lueur mystique sur la stele nord."
        ),
    )
    o["obstacles"] = [
        [{"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": int(blocked[y, x])} for y in range(gh)]
        for x in range(gw)
    ]
    mk = lambda n, p: {
        "EntName": n,
        "Direction": 4,
        "EntEnabled": True,
        "triggerType": 0,
        "Collider": {"X": p[0], "Y": p[1], "Width": 16, "Height": 16},
    }
    o["Entities"] = [
        {
            "Name": "Entrees et vos acteurs",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": [mk("entrance", entry_px), mk("boss", boss_px), mk("objectif", goal_px)],
        }
    ]
    o["Decorations"] = [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}]
    tpl["Version"] = "0.8.12.0"
    gfx.save(STAGE / f"Data/Ground/{ASSET}.rsground", json.dumps(tpl, ensure_ascii=False, separators=(",", ":")).encode())
    gfx.save(
        STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua",
        f"-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n".encode(),
    )
    nodes = {}
    for p in sorted((STAGE / "Content/Tile").glob("*.tile")):
        with p.open("rb") as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / "Content/Tile/index.idx").write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/guilde-treehouse-pmd/" + NAMESPACE)
    (STAGE / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Couloir violet Sanctuaire 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin du Couloir violet (FCV4, appairee a ECV1), grande salle rocheuse violette et stele nord (ref. S05P03A.png), eboulis, poussiere et lueurs animes. Pas une aventure jouable.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )
    script = (R / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    assert needle in script
    script = script.replace(
        needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n"
    )
    (STAGE / "INSTALLER.py").write_text(script, encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")
    return {b.name: len(b.data) for b in banks}


def build() -> None:
    gfx = loadmod("pmdo_codec", R / "source/pmdo_cote/build.py")
    tools = loadmod("index_tools", R / "source/pmdo_cote/INSTALLER.py")
    v1 = loadmod("esn1", R / "source/entree_sud_nord_generee_v1/build.py")
    if OUT.exists():
        for d in ["calques", "animation", "poses", "masques", "review"]:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ["calques", "poses", "masques", "review"] + [f"animation/{x}" for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / "decor_magenta.png"), rgb(RAW / "sol_complet.png"), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ["stele", "gravillons", "blocs", "ombres", "sol", "vide", "falaise", "rochers"]
    ex, cols = down_class(a, m, order)
    layers = {"sol_complet": rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype("uint8")).save(OUT / "masques" / f"{PFX}_masque_{k}.png")

    cand = ex["sol"] | ex["ombres"] | ex["gravillons"]
    cl, _ = nd.label(cand)
    seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype("uint8")).save(OUT / "masques" / f"{PFX}_masque_praticable.png")

    pebbles = rip_pebbles(ref)
    puffs, puff_pal = puff_poses(RAW / "poussiere_poses.png")
    for name, p in pebbles.items():
        Image.fromarray(p).save(OUT / "poses" / f"{PFX}_gravillon_{name}.png")
    for i, p in enumerate(puffs):
        Image.fromarray(p).save(OUT / "poses" / f"{PFX}_poussiere_{i}.png")

    spots = landing_spots(ex["sol"] | ex["ombres"], ex["rochers"] | ex["blocs"])
    eboulis, poussiere = anim_frames(pebbles, puffs, spots)
    lueurs_stele, stele_ramp = build_lueurs_stele_frames(layers["stele"], ex["stele"], ref)
    anim = {"lueurs_stele": lueurs_stele, "eboulis": eboulis, "poussiere": poussiere}

    order_names = ["sol_complet"] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / "animation" / nm / f"{PFX}_{i:02d}_{nm}_f{t:02d}.png")
            layer_list.append({"file": f"animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png", "phases": len(frames), "ticks": ticks})
        else:
            frames, ticks = [layers[nm]], LOOP_TICKS
            Image.fromarray(layers[nm]).save(OUT / "calques" / f"{PFX}_{i:02d}_{nm}.png")
            layer_list.append({"file": f"calques/{PFX}_{i:02d}_{nm}.png", "phases": 1, "ticks": LOOP_TICKS})
        stack_named.append((nm, frames, ticks))

    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]
    med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2 :, c : c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]

    # Marqueur boss au centre de l'arène ouverte
    boss_px = [376, 312]
    while blocked[boss_px[1] // 8 : boss_px[1] // 8 + 2, boss_px[0] // 8 : boss_px[0] // 8 + 2].any():
        boss_px[1] += 8

    # Marqueur objectif juste devant la stèle nord
    sys_, sxs_ = np.nonzero(ex["stele"])
    gx = int(round(sxs_.mean())) // 8 * 8 - 8
    goal_px = [gx, int(sys_.max() + 8) // 8 * 8]
    while blocked[goal_px[1] // 8 : goal_px[1] // 8 + 2, goal_px[0] // 8 : goal_px[0] // 8 + 2].any():
        goal_px[1] += 8

    reach_boss, exp_boss = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_goal, exp_goal = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (goal_px[1] // 8, goal_px[0] // 8))
    assert reach_boss and reach_goal, "pas de chemin 16x16"

    def scene(tick: int) -> Image.Image:
        im = Image.new("RGBA", (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im

    step = 5
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / "review" / f"{PFX}_scene_t000.png")
    scenes[0].save(
        OUT / "review" / f"{PFX}_scene_animee.webp",
        save_all=True,
        append_images=scenes[1:],
        duration=round(step * 1000 / 60),
        loop=0,
        lossless=True,
    )

    col = scenes[0].copy()
    ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 40, 40, 90))
    for (qx, qy), c in (
        (entry_px, (60, 220, 255, 255)),
        (boss_px, (255, 72, 96, 255)),
        (goal_px, (255, 230, 40, 255)),
    ):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    for x, y, *_ in spots:
        dr.ellipse([x - 3, y - 3, x + 3, y + 3], outline=(255, 255, 255, 255))
    col.alpha_composite(ov)
    col.save(OUT / "review" / f"{PFX}_collisions_marqueurs.png")

    sprites = [pebbles[k] for k in PEBBLES] + puffs
    cw = 32 * 5 + 8
    sheet = Image.new("RGBA", (len(sprites) * cw + 8, cw + 8), (94, 80, 114, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr)
        scale_f = min(5, max(1, (cw - 16) // max(im.width, im.height)))
        im = im.resize((im.width * scale_f, im.height * scale_f), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / "review" / f"{PFX}_planche_poses.png")

    write_ora(
        OUT / f"{PFX}_fin_couloir_violet_calques.ora",
        {f"{i:02d}_{t}" + ("_f00" if len(fr) > 1 else ""): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
    )
    counts = ground_project(
        [(t.replace("_", " ") + (f" {len(fr)} phases" if len(fr) > 1 else ""), fr, tk) for t, fr, tk in stack_named],
        blocked,
        entry_px,
        boss_px,
        goal_px,
        gfx,
        tools,
    )
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (("sol", "sol"), ("roche", "rochers"), ("roche", "blocs"), ("roche", "stele")):
        lay = layers[nm]
        px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {
            "matiere": k,
            "rgb": [round(float(v), 1) for v in px.mean(0)],
            "distance_rip": round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]["rip_rgb"]))), 1),
        }

    manifest = {
        "lot": "fin_couloir_violet_sanctuaire_v1",
        "prefix": PFX,
        "paired_entrance": "entree_couloir_violet_sud_nord_v1 (ECV1)",
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_8px": [W // 8, H // 8],
        "biome": "sanctuaire et salle de fin du couloir rocheux violet avec stele sculptee au nord, appaire a ECV1",
        "method": (
            "textures canoniques = rendu genere REFERENCE : rip S05P03A.png passe au generateur ; decor complet, "
            "sol complet et planche de poussiere generes avec le rip en reference"
        ),
        "reference_da": {
            "file": f"{LOT}/reference/{REF_NAME}",
            "sha256": sha(REF),
            "titre": "S05P03A.png — Couloir rocheux violet cul-de-sac (extrait de pret/pmd-sky)",
        },
        "generation": GEN,
        "raw_inputs": [
            {"file": f'{LOT}/bruts/{g["file"]}', "sha256": sha(RAW / g["file"]), "size": list(Image.open(RAW / g["file"]).size)}
            for g in GEN
        ],
        "segmentation_mesures": seg,
        "fidelite_rip": {
            "methode": "moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35",
            "seuil": 35.0,
            "brut": fid,
            "calques_finaux": final_fid,
            "sol_complet": round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid["sol"]["rip_rgb"]))), 1),
            "eboulis": "couleurs EXACTES de S05P03A.png",
            "lueurs_stele": "6 couleurs lilas-violet EXACTES de S05P03A.png",
        },
        "normalization": {
            "scale": JM.SCALE,
            "scaled": [JM.SCALED_W, H],
            "crop_x": [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
            "methode": "moyenne ponderee par classe (BOX), attribution exclusive par poids maximal",
            "palettes": {g: {"calques": k, "couleurs": n} for g, (k, n) in PALETTE_GROUPS.items()},
        },
        "layers": layer_list,
        "lueurs_stele": {
            "palette_rip_exacte": stele_ramp,
            "phases": PHASES,
            "frame_length_ticks": TICKS,
        },
        "eboulis": {
            "gravillons_rip": {k: list(v) for k, v in PEBBLES.items()},
            "gravillons_source": "S05P03A.png, composante de roche 8-connexe entierement entouree de sol ; pixels et couleurs EXACTS",
            "chutes": [list(s) for s in spots],
            "cibles": [list(d) for d in DROPS],
            "chute_dy": FALL,
            "rebond_dy": {str(k): v for k, v in BOUNCE.items()},
            "roulement_px": ROLL,
            "visible_phases": VISIBLE,
            "phases": PHASES,
            "frame_length_ticks": TICKS,
        },
        "poussiere": {
            "fenetres": [list(w) for w in PUFF_WIN],
            "reduction": f"x1/{PUFF_K}",
            "couverture_min": PUFF_COV,
            "palette": [[int(round(c)) for c in p] for p in puff_pal],
            "phase_vers_pose": {str(k): v for k, v in PUFF_AT.items()},
        },
        "scene_loop_ticks": LOOP_TICKS,
        "access": {
            "entry_px": entry_px,
            "boss_px": boss_px,
            "goal_px": goal_px,
            "threshold_px": goal_px,
            "path_found_16x16": bool(reach_boss and reach_goal),
            "cells_explored": int(exp_goal),
            "blocked_cells": int(blocked.sum()),
            "total_cells": int(blocked.size),
            "walkable_cells": int((~blocked).sum()),
        },
        "pmdo": {
            "target": "0.8.12",
            "asset": ASSET,
            "namespace": NAMESPACE,
            "tiles_per_bank": counts,
            "banks": list(counts),
            "runtime_tested": False,
            "warp": "aucun",
        },
        "art_approved": False,
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    shutil.copyfile(OUT / "manifest.json", STAGE / "manifest.json")
    print(
        json.dumps(
            {
                "entry": entry_px,
                "boss": boss_px,
                "goal": goal_px,
                "blocked": int(blocked.sum()),
                "walkable": int((~blocked).sum()),
                "seg": seg,
                "fidelite": {k: v["distance"] for k, v in fid.items()},
                "final": {k: v["distance_rip"] for k, v in final_fid.items()},
                "tiles": sum(counts.values()),
            },
            indent=1,
        )
    )


if __name__ == "__main__":
    build()
