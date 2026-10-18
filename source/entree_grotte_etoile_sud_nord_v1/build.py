#!/usr/bin/env python3
"""Entrée Grotte Étoile sud -> nord V1 (EGE1), format 4:3 vaste (768 x 576 px, 96 x 72 cases de 8 px).

Première carte du biome Grotte Étoile (*Star Cave*, Episode spécial 1 — Le Vœu de Keunotor,
Explorers of Sky, rip `D42P31A.png`, moitié droite = salle d'entrée) :
- Arrivée au sud (bord inférieur, centre) par le passage large dans le roc.
- Salle ovale de cristal saphir bleu scintillant (sparkles 4 branches), sol bleu lisse
  (#306494) avec anneaux de cratères et galets.
- Au nord, une bouche de tunnel sombre voûtée dans la paroi (seuil du donjon).

Méthode « textures canoniques » : rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), segmenté à pleine résolution, réduit par classe (moyenne
  pondérée 2x2 sans mélange inter-classes), quantifié par groupe de palettes ;
- sol_complet.png : sol bleu uni (texture générée d'après le rip, fond plein).
Calques (bas -> haut) : sol_complet, vide (marge sombre), parois_sombres (roc saphir profond),
cristaux (hautes lumières cristallines et sparkles), tunnel (bouche sombre au nord), sol (plancher
bleu + passage sud) + Top vide (Layer=4).
Aucun pixel généré n'est attribué aux tuiles natives : provenance « Généré (réf. rip D42P31A) ».
Lancer : .venv/bin/python source/entree_grotte_etoile_sud_nord_v1/build.py
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import shutil
import uuid
import zipfile
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
BRUTS = HERE / "bruts"
REF = HERE / "reference" / "D42P31A.png"
OUT = R / "renders" / "entree_grotte_etoile_sud_nord_v1"
STAGE = R / ".cache" / "entree_grotte_etoile_sud_nord_v1" / "entree_grotte_etoile"

PFX = "EGE1"
NAMESPACE = "entree_grotte_etoile"
ASSET = "ege1_entree_grotte_etoile"
ORA_NAME = f"{PFX}_entree_grotte_etoile_calques.ora"
TITLE = "Entrée Grotte Étoile sud-nord V1 (EGE1)"
W, H = 768, 576
CELL = 8
GW, GH = W // CELL, H // CELL
RAW_W, RAW_H = 1200, 896
SCALE = H / RAW_H
SW = round(RAW_W * SCALE)
CROP_X = (SW - W) // 2

STATIC_TICKS = 60
FIDELITY_MAX = 35.0

STATIC = ("vide", "parois_sombres", "cristaux", "tunnel", "sol")
PALETTE_GROUPS = {
    "sol": (["sol_complet", "sol"], 64),
    "paroi": (["vide", "parois_sombres", "cristaux", "tunnel"], 96),
}

PROMPTS = {
    "decor.png": (
        "Generate an image: fill the ENTIRE 4:3 (1200x896) canvas edge to edge with a top-down 2D pixel art starlight "
        "cavern entrance map in the exact style and palette of the reference image (Pokemon Mystery Dungeon Explorers "
        "of Sky, Star Cave D42P31A): a large oval ring of faceted sapphire-blue and cobalt-blue crystalline cavern rock "
        "with ice-blue highlights, studded with tiny glowing cyan-white and lavender four-pointed star sparkles, "
        "enclosing a WIDE smooth medium-blue stone floor (#306494) with small circular floor crater rings and a few "
        "scattered blue boulders; a clear DARK ARCHED TUNNEL DOORWAY carved in the north (top-center) rock wall with "
        "dark interior, and a WIDE open walkable stone passage at the bottom-center leading south out of the cavern to "
        "the bottom edge (south entrance), the passage as wide as about 1/5 of the canvas. Dark slate-navy void "
        "(#1c2430) outside the cavern ring only. Crisp pixel art, no characters, no UI."
    ),
    "sol_complet.png": (
        "Generate an image: fill the ENTIRE 4:3 (1200x896) canvas edge to edge with a plain top-down 2D pixel art "
        "cavern floor texture in the exact style and palette of the reference image (Pokemon Mystery Dungeon Explorers "
        "of Sky, Star Cave D42P31A): a smooth uniform medium-blue stone cavern floor (#306494) with subtle darker stone "
        "cracks, small circular floor crater rings and tiny faint star glints scattered evenly, no rock walls, no "
        "boulders, no characters, no UI. Crisp pixel art."
    ),
}

# Paires calque -> matiere pour la fidélité des calques finaux (seuil 35).
LAYER_MATERIALS = (("sol", "sol"), ("parois_sombres", "paroi"))


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
    """Matières de la Grotte Étoile, mêmes seuils sur le rip et sur le brut (mesurés sur D42P31A).
    Le plancher lisse est distingué de la voûte facetée/scintillante par sa LISSEUR (sdev 9 px)."""
    a = a.astype(float)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)
    flat = sdev(lum, 9) < 9
    sol = (b > g + 10) & (g > r + 15) & (lum > 68) & (lum < 155) & flat
    return {
        "sol": sol,
        "paroi": (b > r + 12) & (lum > 40) & (lum < 205) & ~sol,
        "fond": lum < 50,
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
    """Segmentation pleine résolution (1200 x 896) en 5 classes disjointes :
    vide (marge sombre, L5 < 50, ouvert 2 px, > 1500 px, reliée au bord),
    sol = plancher lisse bleu (b > g + 10, g > r + 15, 68 < lum < 155, sdev 9 px < 9) :
    ouvert 1 / fermé 2 px, dilatée 3 px pour pontuer le passage, plus grande composante TOUCHANT LE BORD
    INFÉRIEUR (le passage sud), rétractée sur le masque initial, fermée 2 px, trous bouchés ;
    tunnel = bouche sombre (L5 < 55) dans la boîte haut-centre (y < 320, 420 < x < 780),
    plus grande composante >= 600 px, trous bouchés ;
    parois = le reste (voûte facetée) ; cristaux = parois à L5 > 128 (hautes lumières et sparkles) ;
    parois_sombres = le reste."""
    a = a.astype(int)
    r, g, b = a.transpose(2, 0, 1)
    la = lum_of(a)
    hh, ww = la.shape
    yy, xx = np.mgrid[:hh, :ww]
    L5 = nd.uniform_filter(la, 5)

    vide = keep_large(open_((L5 < 50), 2), 1500)
    lab, _ = nd.label(vide)
    edge_ids = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])
    vide = np.isin(lab, edge_ids[edge_ids > 0])

    flat = sdev(la, 9) < 9
    floor_raw = (b > g + 10) & (g > r + 15) & (la > 68) & (la < 155) & flat & ~vide
    floor_raw = close_(open_(floor_raw, 1), 2)
    dil = nd.binary_dilation(floor_raw, iterations=3)
    lab, n = nd.label(dil)
    bottom = np.unique(lab[-1])
    bottom = bottom[bottom > 0]
    assert bottom.size, "aucun plancher lisse bleu touchant le bord inférieur (passage sud manquant)"
    sizes = nd.sum(dil, lab, range(1, n + 1))
    floor_id = int(bottom[np.argmax([sizes[i - 1] for i in bottom])])
    sol = nd.binary_fill_holes(close_((lab == floor_id) & floor_raw, 2))

    dark_box = (L5 < 55) & (yy < 320) & (xx > 420) & (xx < 780) & ~vide
    dlab, dn = nd.label(dark_box)
    assert dn, "aucune bouche de tunnel sombre trouvée en haut-centre"
    dsz = nd.sum(dark_box, dlab, range(1, dn + 1))
    tunnel = nd.binary_fill_holes(dlab == (int(np.argmax(dsz)) + 1))
    assert tunnel.sum() >= 600, f"tunnel trop petit : {int(tunnel.sum())} px"

    parois_all = ~vide & ~sol & ~tunnel
    cristaux = parois_all & (L5 > 128)
    parois_sombres = parois_all & ~cristaux

    masks = dict(vide=vide, parois_sombres=parois_sombres, cristaux=cristaux, tunnel=tunnel, sol=sol)
    seg = {
        "px": {k: int(v.sum()) for k, v in masks.items()},
        "tunnel_px": int(tunnel.sum()),
        "sol_touche_bord_sud": bool(sol[-1].any()),
    }
    return masks, seg


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


def nearest_walk_cell(walk: np.ndarray, tx: int, ty: int, y_min: int | None = None) -> tuple[int, int]:
    ok = lambda x, y: bool(walk[y : y + 2, x : x + 2].all())
    best, bd = None, None
    for y in range(0, GH - 1):
        if y_min is not None and y < y_min:
            continue
        for x in range(0, GW - 1):
            if not ok(x, y):
                continue
            d = (x * CELL + CELL - tx) ** 2 + (y * CELL + CELL - ty) ** 2
            if bd is None or d < bd:
                best, bd = (x, y), d
    assert best is not None, (tx, ty, y_min)
    return best


def write_ora(path: Path, layers: dict[str, np.ndarray], name: str) -> None:
    import xml.etree.ElementTree as ET

    root = ET.Element("image", w=str(W), h=str(H), name=name)
    stack = ET.SubElement(root, "stack")
    comp = Image.new("RGBA", (W, H))
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (nm, a) in reversed(list(enumerate(items))):
            fn = f"data/layer{i:02d}.png"
            ET.SubElement(
                stack,
                "layer",
                name=nm,
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


def ground_project(stack, blocked, entry_px, boss_px, goal_px, goal_name, gfx, tools) -> dict[str, int]:
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

    o["AssetName"] = ASSET
    o["Name"]["DefaultText"] = TITLE
    o["Name"]["LocalTexts"] = {"fr": TITLE}
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
                {"Name": "entrance", "Position": {"X": int(entry_px[0]), "Y": int(entry_px[1])}, "Direction": 4, "EntEnabled": True},
                {"Name": "boss_center", "Position": {"X": int(boss_px[0]), "Y": int(boss_px[1])}, "Direction": 0, "EntEnabled": True},
                {"Name": goal_name, "Position": {"X": int(goal_px[0]), "Y": int(goal_px[1])}, "Direction": 4, "EntEnabled": True},
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
    (gdir / f"{ASSET}.rsground").write_bytes(b"\xef\xbb\xbf" + json.dumps(tpl, ensure_ascii=False, indent=2).encode("utf-8"))
    ident = str(uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/" + NAMESPACE)).upper()
    (STAGE / "Mod.xml").write_text(
        "<Header>\n  <Name>Entrée Grotte Étoile sud-nord V1 (EGE1)</Name>\n"
        "  <Author>Per Aspera — lot autonome EGE1</Author>\n"
        "  <Description>Salle d'entrée de la Grotte Étoile (Star Cave), format 4:3 vaste (768x576, grille 8 px), générée sur le rip D42P31A.</Description>\n"
        f"  <Namespace>{NAMESPACE}</Namespace>\n  <UUID>{ident}</UUID>\n"
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
    for d in ("calques", "masques", "review"):
        (OUT / d).mkdir(parents=True)

    ref = np.array(Image.open(REF).convert("RGB"))
    decor = np.array(Image.open(BRUTS / "decor.png").convert("RGB"))
    sol_raw = np.array(Image.open(BRUTS / "sol_complet.png").convert("RGB"))
    assert decor.shape == (RAW_H, RAW_W, 3) and sol_raw.shape == (RAW_H, RAW_W, 3)

    fid = fidelity(decor, ref)
    for k, d in fid.items():
        assert d["distance"] < FIDELITY_MAX, (k, d)

    masks_full, seg = classify(decor)
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
    for lk, fk in LAYER_MATERIALS:
        px = layers[lk][masks[lk]][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[fk][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        m = px.mean(0)
        d = float(np.linalg.norm(m - ref[fr[fk]].mean(0)))
        assert d < FIDELITY_MAX, (lk, fk, d)
        final_fid[lk] = {"calque": lk, "matiere": fk, "rgb": [round(float(v), 1) for v in m], "distance_rip": round(d, 1)}
    sc_px = sol_c[..., :3][materials(sol_c[..., :3])["sol"]]
    sc_d = float(np.linalg.norm(sc_px.mean(0) - ref[fr["sol"]].mean(0))) if len(sc_px) > 50 else 0.0
    assert sc_d < FIDELITY_MAX, sc_d

    save(layers["sol_complet"], OUT / f"calques/{PFX}_00_sol_complet.png")
    for i, k in enumerate(STATIC, 1):
        save(layers[k], OUT / f"calques/{PFX}_{i:02d}_{k}.png")

    walk_px = masks["sol"]
    for k, m in {**masks, "praticable": walk_px}.items():
        save(m.astype("uint8") * 255, OUT / f"masques/{PFX}_masque_{k}.png")

    walk = walk_px.reshape(GH, CELL, GW, CELL).mean((1, 3)) >= 0.75
    blocked = ~walk
    assert int(walk[GH - 2:, GW // 2 - 4 : GW // 2 + 4].sum()) > 12, "pas de sol au bord sud (entrée manquante)"
    entry_cell = nearest_walk_cell(walk, W // 2, H - 8, y_min=GH - 4)
    boss_cell = nearest_walk_cell(walk, W // 2, H // 2)
    tunnel_bottom = int(np.nonzero(masks["tunnel"])[0].max())
    goal_cell = nearest_walk_cell(walk, W // 2, tunnel_bottom + 16)
    assert bfs_16(walk, entry_cell, boss_cell), (entry_cell, boss_cell)
    assert bfs_16(walk, boss_cell, goal_cell), (boss_cell, goal_cell)
    entry_px = [(entry_cell[0] + 1) * CELL, (entry_cell[1] + 1) * CELL]
    boss_px = [(boss_cell[0] + 1) * CELL, (boss_cell[1] + 1) * CELL]
    goal_px = [(goal_cell[0] + 1) * CELL, (goal_cell[1] + 1) * CELL]

    base = Image.fromarray(layers["sol_complet"])
    for k in STATIC:
        base.alpha_composite(Image.fromarray(layers[k]))
    base.save(OUT / f"review/{PFX}_scene_t000.png", optimize=True)
    ov = base.copy()
    red = np.zeros((H, W, 4), "uint8")
    for y in range(GH):
        for x in range(GW):
            if blocked[y, x]:
                red[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8] = (220, 40, 40, 90)
    ov.alpha_composite(Image.fromarray(red))
    dr = ImageDraw.Draw(ov)
    for px, col in ((entry_px, (60, 220, 255, 255)), (boss_px, (255, 80, 100, 255)), (goal_px, (255, 230, 40, 255))):
        dr.rectangle([px[0] - 8, px[1] - 8, px[0] + 7, px[1] + 7], outline=col, width=2)
    ov.save(OUT / f"review/{PFX}_collisions_marqueurs.png", optimize=True)

    write_ora(OUT / ORA_NAME, {"00_sol_complet": layers["sol_complet"], **{f"{i:02d}_{k}": layers[k] for i, k in enumerate(STATIC, 1)}}, TITLE)

    stack = [("sol_complet", [layers["sol_complet"]], STATIC_TICKS)] + [(k, [layers[k]], STATIC_TICKS) for k in STATIC]
    tiles_per_bank = ground_project(stack, blocked, entry_px, boss_px, goal_px, "seuil_tunnel", gfx, tools)

    manifest = {
        "lot": "entree_grotte_etoile_sud_nord_v1",
        "prefix": PFX,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "scene_loop_ticks": STATIC_TICKS,
        "grid_8px": [GW, GH],
        "biome": "grotte étoile (Star Cave, épisode spécial 1 — Le Vœu de Keunotor) — salle d'entrée sud vers nord, rip D42P31A",
        "method": "textures canoniques = rendu généré référencé (rip D42P31A passé au générateur en images=), segmenté à pleine résolution, réduit par classe, quantifié en palettes 64/96",
        "reference_da": {"file": str(REF.relative_to(R)), "sha256": sha256(REF), "titre": "Star Cave / Grotte Étoile — rip canonique D42P31A, moitié droite (pret/pmd-sky)"},
        "generation": [{"file": fn, "images": [str(REF.relative_to(R))], "prompt": pr} for fn, pr in PROMPTS.items()],
        "raw_inputs": [{"file": f"source/entree_grotte_etoile_sud_nord_v1/bruts/{fn}", "sha256": sha256(BRUTS / fn), "size": [RAW_W, RAW_H]} for fn in PROMPTS],
        "segmentation_mesures": seg,
        "fidelite_rip": {
            "methode": "moyenne RGB par matière (sol, paroi, fond), même classifieur sur le rip et sur le brut, distance euclidienne < 35",
            "brut": fid,
            "calques_finaux": final_fid,
            "sol_complet": round(sc_d, 1),
            "seuil": FIDELITY_MAX,
        },
        "normalization": {
            "scale": SCALE,
            "scaled": [SW, H],
            "crop_x": [CROP_X, SW - W - CROP_X],
            "methode": "moyenne pondérée par classe (BOX), attribution exclusive par poids maximal",
            "palettes": {g: {"calques": ks, "couleurs": nc} for g, (ks, nc) in PALETTE_GROUPS.items()},
        },
        "segmentation": classify.__doc__.split("\n", 1)[1].strip(),
        "layers": [{"file": f"calques/{PFX}_00_sol_complet.png", "phases": 1, "ticks": STATIC_TICKS}]
        + [{"file": f"calques/{PFX}_{i:02d}_{k}.png", "phases": 1, "ticks": STATIC_TICKS} for i, k in enumerate(STATIC, 1)],
        "provenance": "Généré (réf. rip D42P31A) — aucun pixel natif",
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
            "ground": f"{ASSET}.rsground",
            "banks": list(tiles_per_bank),
            "tiles_per_bank": tiles_per_bank,
            "total_tiles": int(sum(tiles_per_bank.values())),
            "runtime_tested": False,
        },
        "art_approved": False,
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    shutil.copyfile(OUT / "manifest.json", STAGE / "manifest.json")
    print(
        json.dumps(
            {
                "entry": entry_px,
                "boss": boss_px,
                "goal": goal_px,
                "walkable": int(walk.sum()),
                "fidelite": {k: v["distance"] for k, v in fid.items()},
                "sol_complet": round(sc_d, 1),
                "final": {k: v["distance_rip"] for k, v in final_fid.items()},
                "tiles": sum(tiles_per_bank.values()),
            },
            indent=1,
        )
    )


if __name__ == "__main__":
    main()
