#!/usr/bin/env python3
"""Fin de Mt. Thunder — Sommet Foudroyant V1 (FMT3), format 4:3 vaste (768 x 576 = 96 x 72 cases de 8 px).

Seconde carte du biome Mt. Thunder (appairée à l'entrée EMT1) :
- Arrivée au sud (384, 560) par la crête de sable émergeant des nuages blancs.
- Vaste arène centrale de sable jaune pâle (boss_center) bordée de falaises brunes fissurées, de pics coniques et de cailloux.
- Au nord (goal), couronne monumentale de pitons rocheux foudroyés (piton_foudre) au bord du précipice nuageux.
- Éclairs (1..4 + miroirs à droite) et arcs Flash EXACTS de la planche GBA (Normal / Fading) + lueur électrique sur les crêtes du piton nord aux couleurs exactes de la planche.
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
REF = HERE / "reference" / "mt_thunder.png"
OUT = R / "renders" / "fin_mt_thunder_sommet_v1"
STAGE = R / ".cache" / "fin_mt_thunder_sommet_v1" / "fin_mt_thunder_sommet"

PFX = "FMT3"
W, H = 768, 576
CELL = 8
GW, GH = W // CELL, H // CELL
RAW_W, RAW_H = 1200, 896
SCALE = H / RAW_H
SW = round(RAW_W * SCALE)
CROP_X = (SW - W) // 2

TICKS = 5
PHASES = 48
LOOP_TICKS = PHASES * TICKS  # 240 ticks (4,0 s à 60 fps)
STATIC_TICKS = 60
FIDELITY_MAX = 35.0
SCENE_Y = 352

STATIC = ("sable", "cailloux", "pics", "falaise", "piton_foudre", "ciel", "nuages")
PALETTE_GROUPS = {
    "sable": (["sol_complet", "sable"], 32),
    "roche": (["cailloux", "pics", "falaise", "piton_foudre"], 96),
    "orage": (["ciel", "nuages"], 32),
}

# Planche d'animation du rip (y >= 352) : boîtes des 4 éclairs, boîte de l'arc Flash, et pastilles Normal / Fading
BOLTS = {1: (372, 443, 121, 129), 2: (372, 436, 169, 185), 3: (372, 498, 219, 243), 4: (372, 475, 284, 307)}
FLASH_BOX = (393, 401, 15, 55)
SWATCH = {"normal": ((420, 55), (420, 72)), "fading": ((437, 55), (437, 72))}
# 6 frappes par boucle de 48 phases (une toutes les 8 phases) : (éclair, miroir_droite, x, y, phase_début)
STRIKES = (
    (1, False, 48, 78, 0),
    (3, True, 676, 52, 8),
    (2, False, 82, 174, 16),
    (4, True, 696, 132, 24),
    (3, False, 24, 42, 32),
    (2, True, 684, 182, 40),
)
NORMAL_PH, FADING_PH = 2, 2

PROMPTS = {
    "decor.png": (
        "Generate a top-down 2D pixel-art dungeon boss summit map in wide 4:3 format (1200x896) using the exact same "
        "textures, palette, and pixel-art style as the top part of the reference image (Pokemon Mystery Dungeon Mt. "
        "Thunder Peak): same pale yellow sandy summit ground with tiny grey pebbles and small mossy green-grey stones, "
        "same brown rocky cliff edges with cracks, same pointed tan rock spikes, same scalloped storm clouds in "
        "grey-purple tones (darker purple-grey clouds higher up, light grey and white scalloped clouds along the "
        "bottom edge), and same dark grey storm sky at the top. Layout: at the SOUTH (bottom center), a sandy ridge "
        "path emerges from the white lower clouds and opens into a wide rounded-trapezoid sandy summit boss arena "
        "plateau in the center, bordered on the left and right by brown rocky cliff walls and a few pointed tan rock "
        "spikes and pebbles. At the NORTH edge of the sandy plateau (top center, y around 15% to 24%), instead of a "
        "dark cave hole, place an imposing cluster of tall pointed tan-and-brown rocky thunder spires/monoliths "
        "resting on the northern cliff rim, with open pale yellow sand right in front of the spires so the player can "
        "walk up to them. Sea of scalloped grey-purple storm clouds on the left, right, and behind the northern cliff; "
        "dark grey storm sky at the top. Crisp pixel art, no lightning bolts, no characters, no text, no UI."
    ),
    "sol_complet.png": (
        "Generate an image: fill the ENTIRE 4:3 (1200x896) canvas edge to edge with the pale yellow sandy ground "
        "texture from the reference image's summit plateau: same pale yellow sand color (around RGB 231, 222, 156), "
        "same subtle pixel-art speckle texture and faint darker sand patches across the entire frame. Crisp pixel-art "
        "ground texture filling the whole canvas."
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
    sat = a.max(-1) - a.min(-1)
    sable = (r > 200) & (g > 180) & (r - b > 60)
    grey = (sat < 30) & (lum > 20)
    return {
        "sable": sable,
        "roche": (r > g) & (g > b) & (r - b > 25) & (lum < 185) & (lum > 60) & ~sable,
        "ciel": grey & (lum < 90),
        "nuages_sombres": grey & (lum >= 90) & (lum < 170),
        "nuages_clairs": grey & (lum >= 170),
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
    """Segmentation pleine résolution (1200 x 896) en 7 classes disjointes :
    sable, cailloux, pics, falaise, piton_foudre, ciel, nuages."""
    a = a.astype(int)
    r, g, b = a.transpose(2, 0, 1)
    lum = lum_of(a)
    sat = a.max(-1) - a.min(-1)
    hh, ww = lum.shape
    yy, xx = np.mgrid[:hh, :ww]

    sandc = (r > 195) & (g > 175) & (r - b > 45)
    rockc = ((r > g) & (g >= b - 4) & (r - b >= 18) & ~sandc) | (
        (sat >= 18) & (r >= b) & (yy < 360) & (xx > 360) & (xx < 860) & ~sandc
    )
    sand = keep_large(open_(close_(sandc, 2), 2), 20000)
    sand[880:, 540:658] |= r[880:, 540:658] > 180
    sand_filled = nd.binary_fill_holes(sand)

    spire_zone = (yy < 340) & (xx > 390) & (xx < 840)
    spire_non_grey = spire_zone & ((sat > 14) | ((lum < 52) & nd.binary_dilation(rockc & spire_zone, iterations=3)))
    land = keep_large(nd.binary_fill_holes(close_(sand_filled | rockc | spire_non_grey, 3)), 50000)
    sand_filled &= land

    isl = open_(sand_filled & ~sandc, 1)
    isl = nd.binary_fill_holes(close_(isl, 2)) & sand_filled
    il, inn = nd.label(isl)
    sz = nd.sum(isl, il, range(1, inn + 1)) if inn else []
    pics = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 150])
    cail = np.isin(il, [i + 1 for i, v in enumerate(sz) if 8 <= v < 150])

    rock = land & ~sand_filled
    piton_foudre = keep_large(rock & (yy < 340) & (xx > 380) & (xx < 840), 1000)
    falaise = rock & ~piton_foudre
    sable = sand_filled & ~pics & ~cail

    sky = ~land
    ciel = keep_large(open_(sky & (lum < 90), 3), 2000)
    lab, _ = nd.label(ciel)
    t = np.unique(lab[0])
    ciel = np.isin(lab, t[t > 0])
    nuages = sky & ~ciel

    masks = dict(
        piton_foudre=piton_foudre,
        pics=pics,
        cailloux=cail,
        sable=sable,
        falaise=falaise,
        ciel=ciel,
        nuages=nuages,
    )
    ys_p, xs_p = np.nonzero(piton_foudre)
    seg = {
        "piton_foudre_y": [int(ys_p.min()), int(ys_p.max())],
        "piton_foudre_x": [int(xs_p.min()), int(xs_p.max())],
        "pics": int(sum(v >= 150 for v in sz)),
        "cailloux": int(sum(8 <= v < 150 for v in sz)),
    }
    return masks, seg


def rip_sheet(ref: np.ndarray):
    sw = {k: tuple(tuple(int(v) for v in ref[y, x]) for y, x in pts) for k, pts in SWATCH.items()}
    bolts = {}
    for k, (y0, y1, x0, x1) in BOLTS.items():
        m = (ref[y0:y1, x0:x1] == sw["normal"][1]).all(-1)
        lab, n = nd.label(m, structure=np.ones((3, 3)))
        assert n == 1, (k, n)
        bolts[k] = m
    y0, y1, x0, x1 = FLASH_BOX
    flash = (ref[y0:y1, x0:x1] == sw["normal"][0]).all(-1)
    return bolts, flash, sw


def sprite(mask: np.ndarray, color: tuple[int, int, int]) -> np.ndarray:
    s = np.zeros((*mask.shape, 4), "uint8")
    s[mask] = (*color, 255)
    return s


def strike_state(u: int) -> str | None:
    return "normal" if u < NORMAL_PH else "fading" if u < NORMAL_PH + FADING_PH else None


def strike_boxes(bolts: dict[int, np.ndarray], flash: np.ndarray, strikes=STRIKES):
    out = []
    for k, mirror, x, y, off in strikes:
        m = bolts[k][:, ::-1] if mirror else bolts[k]
        ys, xs = np.nonzero(m)
        yb = int(ys.max())
        xb = int(round(xs[ys == yb].mean()))
        out.append((m, x, y, x + xb - flash.shape[1] // 2, y + yb - flash.shape[0] // 2 + 2, off))
    return out


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


def anim_frames(
    bolts: dict[int, np.ndarray],
    flash: np.ndarray,
    sw: dict[str, tuple[tuple[int, int, int], tuple[int, int, int]]],
    piton_rgba: np.ndarray,
    piton_mask: np.ndarray,
    ts=range(PHASES),
    strikes=STRIKES,
) -> tuple[list[np.ndarray], list[np.ndarray], list[np.ndarray]]:
    lue, ecl, lue_piton = [], [], []
    boxes = strike_boxes(bolts, flash, strikes)
    # Arêtes claires du piton nord (lueur électrique synchronisée avec les frappes d'orage)
    pl = lum_of(piton_rgba)
    edge_hi = piton_mask & (pl > 175)
    edge_mid = piton_mask & (pl > 152) & (pl <= 175)
    for t in ts:
        a = np.zeros((H, W, 4), "uint8")
        f = np.zeros((H, W, 4), "uint8")
        p = np.zeros((H, W, 4), "uint8")
        active_state = None
        for m, x, y, fx, fy, off in boxes:
            st = strike_state((t - off) % PHASES)
            if st:
                active_state = st
                paste(a, sprite(m, sw[st][1]), x, y)
                paste(f, sprite(flash, sw[st][0]), fx, fy)
        if active_state == "normal":
            p[edge_hi] = (*sw["normal"][0], 255)
            p[edge_mid] = (*sw["fading"][0], 255)
        elif active_state == "fading":
            p[edge_hi] = (*sw["fading"][0], 255)
        lue.append(f)
        ecl.append(a)
        lue_piton.append(p)
    return lue, ecl, lue_piton


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

    root = ET.Element("image", w=str(W), h=str(H), name="Fin Mt. Thunder — Sommet Foudroyant V1 (FMT3)")
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

    o["AssetName"] = "fmt3_fin_mt_thunder_sommet"
    o["Name"]["DefaultText"] = "Fin de Mt. Thunder — Sommet Foudroyant V1 (FMT3)"
    o["Name"]["LocalTexts"] = {"fr": "Fin de Mt. Thunder — Sommet Foudroyant V1 (FMT3)"}
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
                    "Name": "piton_foudre",
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
    (gdir / "fmt3_fin_mt_thunder_sommet.rsground").write_bytes(
        b"\xef\xbb\xbf" + json.dumps(tpl, ensure_ascii=False, indent=2).encode("utf-8")
    )
    (STAGE / "Mod.xml").write_text(
        "<Header>\n  <Name>Fin de Mt. Thunder — Sommet Foudroyant V1 (FMT3)</Name>\n"
        "  <Author>Per Aspera — lot autonome FMT3</Author>\n"
        "  <Description>Arène finale du sommet de Mt. Thunder, format 4:3 vaste (768x576, grille 8 px).</Description>\n"
        "  <Namespace>fin_mt_thunder_sommet</Namespace>\n  <UUID>E7A49D12-5C8B-4E19-9A36-8F204D7C1103</UUID>\n"
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

    ref_full = np.array(Image.open(REF).convert("RGB"))
    ref_scene = ref_full[:SCENE_Y]
    decor = np.array(Image.open(BRUTS / "decor.png").convert("RGB"))
    sol_raw = np.array(Image.open(BRUTS / "sol_complet.png").convert("RGB"))
    assert decor.shape == (RAW_H, RAW_W, 3) and sol_raw.shape == (RAW_H, RAW_W, 3)

    fid = fidelity(decor, ref_scene)
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

    fr = materials(ref_scene)
    final_fid = {}
    for lk, fk in (
        ("sable", "sable"),
        ("falaise", "roche"),
        ("piton_foudre", "roche"),
        ("ciel", "ciel"),
        ("nuages", "nuages_sombres"),
        ("nuages", "nuages_clairs"),
    ):
        sel = (masks[lk] & materials(layers[lk][..., :3])[fk]) if lk == "nuages" else masks[lk]
        px = layers[lk][sel][:, :3]
        m = px.mean(0)
        d = float(np.linalg.norm(m - ref_scene[fr[fk]].mean(0)))
        assert d < FIDELITY_MAX, (lk, fk, d)
        final_fid[f"{lk}:{fk}"] = {
            "calque": lk,
            "matiere": fk,
            "rgb": [round(float(v), 1) for v in m],
            "distance_rip": round(d, 1),
        }

    bolts, flash, sw = rip_sheet(ref_full)
    lue_frames, ecl_frames, lue_piton_frames = anim_frames(
        bolts, flash, sw, layers["piton_foudre"], masks["piton_foudre"]
    )

    save(layers["sol_complet"], OUT / "calques/FMT3_00_sol_complet.png")
    for i, k in enumerate(STATIC, 1):
        save(layers[k], OUT / f"calques/FMT3_{i:02d}_{k}.png")
    for t in range(PHASES):
        save(lue_frames[t], OUT / f"animation/lueurs/FMT3_08_lueurs_f{t:02d}.png")
        save(ecl_frames[t], OUT / f"animation/eclairs/FMT3_09_eclairs_f{t:02d}.png")
        save(lue_piton_frames[t], OUT / f"animation/lueur_piton/FMT3_10_lueur_piton_f{t:02d}.png")

    for k, m in bolts.items():
        save(sprite(m, sw["normal"][1]), OUT / f"poses/eclair_{k}_normal.png")
        save(sprite(m, sw["fading"][1]), OUT / f"poses/eclair_{k}_fading.png")
    save(sprite(flash, sw["normal"][0]), OUT / "poses/arc_flash_normal.png")
    save(sprite(flash, sw["fading"][0]), OUT / "poses/arc_flash_fading.png")

    walk_px = masks["sable"] & ~masks["cailloux"]
    for k, m in {**masks, "praticable": walk_px}.items():
        save((m.astype("uint8") * 255), OUT / f"masques/FMT3_masque_{k}.png")

    walk = walk_px.reshape(GH, CELL, GW, CELL).mean((1, 3)) >= 0.75
    blocked = ~walk
    entry_cell = (GW // 2 - 1, GH - 3)
    boss_cell = (GW // 2 - 1, 42)
    py_max = int(np.nonzero(masks["piton_foudre"][:, W // 2 - 16 : W // 2 + 16])[0].max()) // CELL
    goal_cell = next((GW // 2 - 1, gy) for gy in range(py_max + 1, py_max + 10) if walk[gy : gy + 2, GW // 2 - 1 : GW // 2 + 1].all())
    assert bfs_16(walk, entry_cell, boss_cell), (entry_cell, boss_cell)
    assert bfs_16(walk, boss_cell, goal_cell), (boss_cell, goal_cell)
    entry_px = [(entry_cell[0] + 1) * CELL, (entry_cell[1] + 1) * CELL]
    boss_px = [(boss_cell[0] + 1) * CELL, (boss_cell[1] + 1) * CELL]
    goal_px = [(goal_cell[0] + 1) * CELL, (goal_cell[1] + 1) * CELL]

    base = Image.fromarray(layers["sol_complet"])
    for k in STATIC:
        base.alpha_composite(Image.fromarray(layers[k]))
    (OUT / "review").mkdir(parents=True, exist_ok=True)
    frames_comp = []
    for t in range(PHASES):
        im = base.copy()
        im.alpha_composite(Image.fromarray(lue_frames[t]))
        im.alpha_composite(Image.fromarray(ecl_frames[t]))
        im.alpha_composite(Image.fromarray(lue_piton_frames[t]))
        frames_comp.append(im)
        if t in (0, 1, 2, 8, 16, 24, 32, 40):
            im.save(OUT / f"review/FMT3_scene_t{t * TICKS:03d}.png", optimize=True)
    frames_comp[0].save(
        OUT / "review/FMT3_scene_animee.webp",
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
    ov.save(OUT / "review/FMT3_collisions_marqueurs.png", optimize=True)

    sheet = Image.new("RGBA", (360, 180), (16, 16, 22, 255))
    x0 = 16
    for k in sorted(bolts):
        for st, dy in (("normal", 16), ("fading", 96)):
            sp = Image.fromarray(sprite(bolts[k], sw[st][1]))
            sheet.alpha_composite(sp, (x0, dy))
        x0 += bolts[k].shape[1] + 24
    for st, dy in (("normal", 40), ("fading", 120)):
        sheet.alpha_composite(Image.fromarray(sprite(flash, sw[st][0])), (x0 + 16, dy))
    sheet.save(OUT / "review/FMT3_planche_poses.png", optimize=True)

    write_ora(
        OUT / "FMT3_fin_mt_thunder_calques.ora",
        {
            "00_sol_complet": layers["sol_complet"],
            **{f"{i:02d}_{k}": layers[k] for i, k in enumerate(STATIC, 1)},
            "08_lueurs_f00": lue_frames[0],
            "09_eclairs_f00": ecl_frames[0],
            "10_lueur_piton_f00": lue_piton_frames[0],
        },
    )

    stack = [
        ("sol_complet", [layers["sol_complet"]], STATIC_TICKS),
        *[(k, [layers[k]], STATIC_TICKS) for k in STATIC],
        ("lueurs", lue_frames, TICKS),
        ("eclairs", ecl_frames, TICKS),
        ("lueur_piton", lue_piton_frames, TICKS),
    ]
    tiles_per_bank = ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools)

    manifest = {
        "lot": "fin_mt_thunder_sommet_v1",
        "prefix": PFX,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_8px": [GW, GH],
        "biome": "sommet d'orage au-dessus des nuages (arène finale du boss couronnée par les pitons rocheux foudroyés)",
        "method": "textures canoniques = rendu généré référencé sur mt_thunder.png ; éclairs et arc Flash copiés au pixel près de la planche GBA",
        "reference_da": {
            "file": "source/fin_mt_thunder_sommet_v1/reference/mt_thunder.png",
            "sha256": sha256(REF),
            "scene_rows": [0, SCENE_Y],
            "titre": "Mt. Thunder Peak, salle du boss (Red Rescue Team, GBA)",
        },
        "generation": [
            {"file": fn, "images": ["source/fin_mt_thunder_sommet_v1/reference/mt_thunder.png"], "prompt": pr}
            for fn, pr in PROMPTS.items()
        ],
        "raw_inputs": [
            {
                "file": f"source/fin_mt_thunder_sommet_v1/bruts/{fn}",
                "sha256": sha256(BRUTS / fn),
                "size": [RAW_W, RAW_H],
            }
            for fn in ("decor.png", "sol_complet.png")
        ],
        "segmentation_mesures": seg_info,
        "fidelite_rip": {
            "methode": "moyenne RGB par matière (sable, roche, ciel, nuages_sombres, nuages_clairs), distance euclidienne < 35",
            "brut": fid,
            "calques_finaux": final_fid,
            "sol_complet": round(
                float(np.linalg.norm(layers["sol_complet"][..., :3].mean((0, 1)) - ref_scene[fr["sable"]].mean(0))), 1
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
            {"file": "calques/FMT3_00_sol_complet.png", "phases": 1, "ticks": STATIC_TICKS},
            *[
                {"file": f"calques/FMT3_{i:02d}_{k}.png", "phases": 1, "ticks": STATIC_TICKS}
                for i, k in enumerate(STATIC, 1)
            ],
            {"file": "animation/lueurs/FMT3_08_lueurs_fNN.png", "phases": PHASES, "ticks": TICKS},
            {"file": "animation/eclairs/FMT3_09_eclairs_fNN.png", "phases": PHASES, "ticks": TICKS},
            {"file": "animation/lueur_piton/FMT3_10_lueur_piton_fNN.png", "phases": PHASES, "ticks": TICKS},
        ],
        "eclairs": {
            "boites_rip": {str(k): list(v) for k, v in BOLTS.items()},
            "flash_rip": list(FLASH_BOX),
            "pastilles": {k: [list(c) for c in v] for k, v in sw.items()},
            "durees_phases": {"normal": NORMAL_PH, "fading": FADING_PH},
            "frappes": [
                {
                    "eclair": k,
                    "miroir": m,
                    "x": x,
                    "y": y,
                    "flash_x": fx,
                    "flash_y": fy,
                    "phase_debut": off,
                }
                for (k, m, _, _, _), (_, x, y, fx, fy, off) in zip(STRIKES, strike_boxes(bolts, flash))
            ],
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
            "ground": "fmt3_fin_mt_thunder_sommet.rsground",
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
