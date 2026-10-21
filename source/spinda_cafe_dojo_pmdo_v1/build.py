#!/usr/bin/env python3
"""
Pipeline de construction PMDO 0.8.12 / Halcyon — Les 8 Spinda Cafés Monumentaux (#0327 Spinda)
Inspiration officielle Pokémon Donjon Mystère (Dojo Makuhita) — Architecture Pure SANS DEVANTURE.

Règles artistiques & techniques strictes (8/8 bâtiments) :
- 100 % architecture pure et noble style Chunsoft GBA/DS Explorateurs du Ciel (sculptures pierre/bois,
  colonnes gravées de spirales, tuiles vernissées vermillon courbées, cornes faîtières dorées, dômes écaillés Spinda)
- ZÉRO devanture commerciale : zéro comptoir, zéro guichet, zéro bouteilles, zéro rideau noren dans l'entrée,
  zéro store, zéro tables/tabourets/tonneaux, zéro panneau devant, zéro lanterne, zéro visage/bouche/yeux
- Entrée pure en arche noire profonde style Dojo Makuhita officiel PMD
- Alpha binaire strict {0, 255}, 0 px de frange verte sur 100 % des pixels, grille exacte 8×8 px
- Galerie HTML pure <img> RGBA alpha=0 (zéro <canvas>, zéro damier)
"""

from __future__ import annotations

import base64
import collections
import json
import math
import shutil
import sys
import zipfile
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image, ImageEnhance

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from source.pmdo_cote.build import TileBank

MOD_DIR = ROOT / "source" / "spinda_cafe_dojo_pmdo_v1"
BRUTS_DIR = MOD_DIR / "bruts"
OUT_DIR = ROOT / "livrables_spinda_cafe_dojo_pmdo"
HD_DIR = OUT_DIR / "HD_sans_fond"
PMDO_1X_DIR = OUT_DIR / "1x_PMDO_8px_sans_fond"
TILE_DIR = OUT_DIR / "PMDO_tiles"
HTML_PREVIEW = ROOT / "apercu_spinda_cafe_dojo_pmdo.html"
ZIP_PATH = OUT_DIR / "Spinda_Cafe_Style_DojoMakuhita_PMDO.zip"

SPECS = [
    {
        "prefix": "SPC1",
        "id": "01_Spinda_Dojo_Classique_Dome_Ecaille",
        "raw": "spc_01_dojo_spinda_ecaille_classique",
        "title": "1. Grand Dojo Spinda Classique — Dôme Écaillé Sculpté & Pavillon Octogonal",
        "category": "Modèle Maître 2 Ailes (28×15 tuiles)",
        "target_1x": (224, 120),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Interprétation monumentale fidèle du Dojo Makuhita : pavillon octogonal à colonnes de pierre taillée, fenêtres closes à barreaux bois et dôme écaillé crème à grande tache asymétrique vermillon sur l’oreille spirale gauche ; aile Dojo à tuiles vernissées rouges, corne dorée relevée et arche noire pure sous doubles volutes sculptées (zéro devanture).",
    },
    {
        "prefix": "SPC2",
        "id": "02_Spinda_Dojo_Classique_Corniche_Or",
        "raw": "spc_02_dojo_spinda_corniche_or_classique",
        "title": "2. Dojo Spinda Classique — Corniche Ondulée d’Or & Volutes Tourbillon",
        "category": "Fidèle 1:1 GBA Dojo Makuhita (29×12 tuiles)",
        "target_1x": (232, 96),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Fidélité directe au sprite GBA du Dojo Makuhita : pavillon gauche à corniche ondulée dorée, 4 fenêtres sombres en retrait et dôme tacheté à oreilles spiralées ; aile droite à corne dorée et grand encadrement de portail en doubles tourbillons dorés sur entrée noire pure (zéro devanture).",
    },
    {
        "prefix": "SPC3",
        "id": "03_Spinda_Dojo_Inverse_Tour_Droite",
        "raw": "spc_03_dojo_spinda_inverse_tour_droite",
        "title": "3. Grand Dojo Spinda Inversé — Aile Tuilée à Corne Gauche & Tour Écaillée Droite",
        "category": "Architecture 2 Ailes Inversée (28×12 tuiles)",
        "target_1x": (224, 96),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Composition asymétrique inversée 100 % architecturale : longue aile Dojo à grande corne faîtière dorée à gauche et portique de pierre taillée sur entrée noire pure, reliée à droite à une haute tour octogonale à deux niveaux de fenêtres closes et dôme écaillé Spinda (zéro devanture).",
    },
    {
        "prefix": "SPC4",
        "id": "04_Spinda_Pagode_Imperiale_Balustrade",
        "raw": "spc_04_pagode_dojo_spinda_balustrade",
        "title": "4. Grande Pagode Impériale « Spinda Café » à Galerie & Doubles Cornes",
        "category": "Pagode Monumentale 2 Niveaux (30×12 tuiles)",
        "target_1x": (240, 96),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Édifice symétrique de prestige à deux niveaux : rez-de-chaussée à colonnes gravées de spirales, ailes à doubles cornes dorées et arche centrale sculptée en volutes sur entrée noire pure, surmonté d’une coupole Spinda à cornes pourpres ceinturée d’une balustrade en bois ciselé (zéro devanture).",
    },
    {
        "prefix": "SPC5",
        "id": "05_Spinda_Rotonde_Cour_Ronde_Imperiale",
        "raw": "spc_05_rotonde_imperiale_cour_dojo_spinda",
        "title": "5. Grande Rotonde Impériale en Cour Circulaire « Temple Dojo Spinda »",
        "category": "Enceinte Circulaire Monumentale (28×16 tuiles)",
        "target_1x": (224, 128),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Vaste enceinte circulaire en colonnade de pierre gravée de spirales et fenêtres closes en bois sombre, coiffée d’un anneau continu de tuiles rouges à cornes dorées entourant le grand dôme central écaillé Spinda, avec portail tourbillon à arche noire pure (zéro devanture).",
    },
    {
        "prefix": "SPC6",
        "id": "06_Spinda_Sanctuaire_Double_Dome_Jumeau",
        "raw": "spc_06_sanctuaire_double_dome_jumeau_spinda",
        "title": "6. Sanctuaire Double-Dôme « Motifs Asymétriques Jumeaux de Spinda »",
        "category": "Complexe Monumental 2 Tours Dômes (30×12 tuiles)",
        "target_1x": (240, 96),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Clin d’œil architectural aux motifs de taches uniques de chaque Spinda : deux tours en pierre taillée coiffées chacune d’un dôme écaillé aux taches asymétriques distinctes (gauche vs droite), réunies par le hall Dojo central à portail tourbillon et entrée noire pure (zéro devanture).",
    },
    {
        "prefix": "SPC7",
        "id": "07_Spinda_Palais_Triptyque_Tour_Centrale",
        "raw": "spc_07_palais_triptyque_tour_centrale_spinda",
        "title": "7. Palais Triptyque à Haute Tour Cylindrique Centrale Spinda",
        "category": "Triptyque Symétrique Tour Centrale (28×16 tuiles)",
        "target_1x": (224, 128),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Haute tour cylindrique centrale tachetée à double corniche ondulée d’or, oreilles spiralées et grand portail sculpté en volutes sur arche noire pure, flanquée symétriquement de deux ailes Dojo à colonnes gravées et toits courbés (zéro devanture).",
    },
    {
        "prefix": "SPC8",
        "id": "08_Spinda_Pavillon_Compact_Noble_1_Aile",
        "raw": "spc_08_pavillon_compact_noble_dojo_spinda",
        "title": "8. Pavillon Dojo Spinda Compact Noble (1 Aile Symétrique à Double Corne)",
        "category": "Pavillon Compact Pur (24×9 tuiles)",
        "target_1x": (192, 72),
        "has_green_props": False,
        "split_row_ratio": 0.60,
        "desc": "Pavillon compact 100 % architectural pour emplacements de taille moyenne : soubassement de pierre taillée, colonnes d’angle gravées de spirales, fenêtres closes à barreaux, toit rouge à double corne dorée, crêtes spiralées Spinda et portail doré à entrée noire pure (zéro devanture).",
    },
]


def extract_clean_rgba(im_rgb: Image.Image, has_green_props: bool = False) -> Image.Image:
    arr = np.array(im_rgb.convert("RGB"), dtype=np.int16)
    h, w, _ = arr.shape
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]

    chroma = (g > 155) & ((g - np.maximum(r, b)) > 42)
    ext = np.zeros((h, w), dtype=bool)
    q = collections.deque()
    for sx in range(w):
        for sy in (0, h - 1):
            if chroma[sy, sx] and not ext[sy, sx]:
                ext[sy, sx] = True
                q.append((sy, sx))
    for sy in range(h):
        for sx in (0, w - 1):
            if chroma[sy, sx] and not ext[sy, sx]:
                ext[sy, sx] = True
                q.append((sy, sx))

    while q:
        cy, cx = q.popleft()
        for ny, nx in ((cy - 1, cx), (cy + 1, cx), (cy, cx - 1), (cy, cx + 1)):
            if 0 <= ny < h and 0 <= nx < w and not ext[ny, nx] and chroma[ny, nx]:
                ext[ny, nx] = True
                q.append((ny, nx))

    for _ in range(2):
        dil = (
            np.pad(ext[1:, :], ((0, 1), (0, 0)), constant_values=True)
            | np.pad(ext[:-1, :], ((1, 0), (0, 0)), constant_values=True)
            | np.pad(ext[:, 1:], ((0, 0), (0, 1)), constant_values=True)
            | np.pad(ext[:, :-1], ((0, 0), (1, 0)), constant_values=True)
        )
        ext |= dil & (~ext) & ((g - np.maximum(r, b)) > 15) & (g > 95)

    out = np.zeros((h, w, 4), dtype=np.uint8)
    out[:, :, :3] = np.clip(arr, 0, 255).astype(np.uint8)
    out[:, :, 3] = np.where(ext, 0, 255).astype(np.uint8)

    # Straighten bottom row of central pure-black arched doorway so 0 micro-notches appear
    pure_dark = (out[:, :, 3] == 255) & (out[:, :, 0] < 16) & (out[:, :, 1] < 16) & (out[:, :, 2] < 20)
    pure_dark[: h // 2, :] = False
    dy, dx = np.where(pure_dark)
    if len(dx) > 250:
        x_med = int(np.median(dx))
        in_door = pure_dark & (np.abs(np.arange(w)[None, :] - x_med) < 105)
        ddy, ddx = np.where(in_door)
        if len(ddx) > 200:
            x0, x1 = int(ddx.min()), int(ddx.max())
            y_flat = int(np.percentile(ddy, 96))
            fill_mask = (out[y_flat - 12 : y_flat + 1, x0:x1, 3] == 0)
            out[y_flat - 12 : y_flat + 1, x0:x1][fill_mask] = (4, 4, 6, 255)
            trim_mask = pure_dark[y_flat + 1 :, x0:x1]
            out[y_flat + 1 :, x0:x1][trim_mask] = (0, 0, 0, 0)

    trans = out[:, :, 3] == 0
    despill = ~trans
    rr, gg, bb = out[:, :, 0].astype(np.int16), out[:, :, 1].astype(np.int16), out[:, :, 2].astype(np.int16)
    max_rb = np.maximum(rr, bb)
    out[:, :, 1] = np.where(despill & (gg > max_rb), max_rb, gg).astype(np.uint8)
    out[trans] = (0, 0, 0, 0)

    ys, xs = np.where(out[:, :, 3] == 255)
    cropped = out[ys.min() : ys.max() + 1, xs.min() : xs.max() + 1]
    return Image.fromarray(cropped, "RGBA")


def resize_clean_rgba(src_rgba: Image.Image, target_wh: Tuple[int, int], margin: int = 2) -> Image.Image:
    tw, th = target_wh
    avail_w, avail_h = tw - 2 * margin, th - 2 * margin
    sw, sh = src_rgba.size
    scale = min(avail_w / sw, avail_h / sh)
    nw = max(1, int(round(sw * scale)))
    nh = max(1, int(round(sh * scale)))

    arr = np.array(src_rgba, dtype=np.float32)
    alpha = arr[:, :, 3:4] / 255.0
    premult = np.concatenate([arr[:, :, :3] * alpha, arr[:, :, 3:4]], axis=2).astype(np.uint8)
    resized = np.array(Image.fromarray(premult, "RGBA").resize((nw, nh), Image.BOX), dtype=np.float32)

    a_out = resized[:, :, 3] >= 128.0
    rgb_out = np.zeros((nh, nw, 3), dtype=np.uint8)
    valid = resized[:, :, 3] > 1.0
    for c in range(3):
        rgb_out[:, :, c] = np.where(
            valid,
            np.clip(np.round(resized[:, :, c] / np.maximum(resized[:, :, 3] / 255.0, 1e-3)), 0, 255),
            0,
        ).astype(np.uint8)

    rgb_sharp = np.array(ImageEnhance.Sharpness(Image.fromarray(rgb_out, "RGB")).enhance(1.25), dtype=np.uint8)
    max_rb_r = np.maximum(rgb_sharp[:, :, 0], rgb_sharp[:, :, 2])
    rgb_sharp[:, :, 1] = np.minimum(rgb_sharp[:, :, 1], max_rb_r)

    canvas = np.zeros((th, tw, 4), dtype=np.uint8)
    ox = (tw - nw) // 2
    oy = th - margin - nh
    sub = canvas[oy : oy + nh, ox : ox + nw]
    sub[:, :, :3] = np.where(a_out[:, :, None], rgb_sharp, 0)
    sub[:, :, 3] = np.where(a_out, 255, 0)
    canvas[oy : oy + nh, ox : ox + nw] = sub
    return Image.fromarray(canvas, "RGBA")


def make_night_variant(day_rgba: Image.Image) -> Image.Image:
    arr = np.array(day_rgba, dtype=np.float32)
    r, g, b, a = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2], arr[:, :, 3]
    opaque = a > 127
    nr = np.clip(r * 0.56 + 10.0, 0, 255)
    ng = np.clip(g * 0.58 + 16.0, 0, 255)
    nb = np.clip(b * 0.80 + 36.0, 0, 255)

    out = np.zeros_like(arr, dtype=np.uint8)
    out[:, :, 0] = np.where(opaque, nr, 0).astype(np.uint8)
    out[:, :, 1] = np.where(opaque, ng, 0).astype(np.uint8)
    out[:, :, 2] = np.where(opaque, nb, 0).astype(np.uint8)
    out[:, :, 3] = np.where(opaque, 255, 0).astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def save_binary_indexed_png(im_rgba: Image.Image, path: Path, clamp_green: bool = True) -> None:
    arr = np.array(im_rgba.convert("RGBA"))
    mask = arr[:, :, 3] >= 128
    rgb = Image.fromarray(np.where(mask[:, :, None], arr[:, :, :3], 0).astype(np.uint8), "RGB")
    q = rgb.quantize(colors=255, method=Image.MEDIANCUT, dither=Image.NONE)
    q_idx = np.array(q, dtype=np.uint8) + 1
    q_idx[~mask] = 0

    pal = np.array(q.getpalette()[: 255 * 3], dtype=np.int32).reshape(255, 3)
    if clamp_green:
        pal[:, 1] = np.minimum(pal[:, 1], np.maximum(pal[:, 0], pal[:, 2]))
    full_pal = [0, 0, 0] + np.clip(pal, 0, 255).astype(np.uint8).ravel().tolist()
    out_p = Image.fromarray(q_idx, mode="P")
    out_p.putpalette(full_pal)
    path.parent.mkdir(parents=True, exist_ok=True)
    out_p.save(path, "PNG", transparency=0, optimize=True)


def split_visible_layers(im_rgba: Image.Image, split_ratio: float) -> Tuple[Image.Image, Image.Image]:
    """Découpe stricte en surfaces visibles sans reconstruction spéculative des pixels occultés."""
    w, h = im_rgba.size
    split_y = max(8, min(h - 8, int(round((h * split_ratio) / 8.0)) * 8))
    arr = np.array(im_rgba)
    under = np.zeros_like(arr)
    base = np.zeros_like(arr)
    under[:split_y, :, :] = arr[:split_y, :, :]
    base[split_y:, :, :] = arr[split_y:, :, :]
    return Image.fromarray(under, "RGBA"), Image.fromarray(base, "RGBA")


def write_tsj(png_rel: str, name: str, w: int, h: int, tsj_path: Path) -> None:
    cols, rows = w // 8, h // 8
    data = {
        "columns": cols,
        "image": png_rel,
        "imageheight": h,
        "imagewidth": w,
        "margin": 0,
        "name": name,
        "spacing": 0,
        "tilecount": cols * rows,
        "tiledversion": "1.10.2",
        "tileheight": 8,
        "tilewidth": 8,
        "type": "tileset",
        "version": "1.10",
    }
    tsj_path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")


def png_to_data_uri(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def build_atlas(sprites: List[Image.Image], padding: int = 8) -> Image.Image:
    cols = 2
    rows = math.ceil(len(sprites) / cols)
    cell_w = ((max(im.width for im in sprites) + padding * 2 + 7) // 8) * 8
    cell_h = ((max(im.height for im in sprites) + padding * 2 + 7) // 8) * 8
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (0, 0, 0, 0))
    for idx, im in enumerate(sprites):
        r, c = divmod(idx, cols)
        ox = ((c * cell_w + (cell_w - im.width) // 2) // 8) * 8
        oy = ((r * cell_h + cell_h - padding - im.height) // 8) * 8
        sheet.paste(im, (ox, oy), im)
    return sheet


def build_html_gallery(records: List[Dict], sheet_jour: Path, sheet_nuit: Path) -> None:
    cards_html = []
    for rec in records:
        hd_rel = rec["hd_png"]
        j1x_uri = png_to_data_uri(ROOT / rec["day_1x_png"])
        n1x_uri = png_to_data_uri(ROOT / rec["night_1x_png"])
        w1, h1 = rec["size_1x"]
        whd, hhd = rec["size_hd"]
        cards_html.append(
            f"""
        <article class="card">
          <div class="card-head">
            <span class="bank">{rec["prefix"]}.tile</span>
            <span class="cat">{rec["category"]}</span>
          </div>
          <h2>{rec["title"]}</h2>
          <p class="desc">{rec["desc"]}</p>
          <figure class="stage">
            <img class="pixel hd-view" src="{hd_rel}" alt="{rec["id"]} HD RGBA sans fond" />
            <figcaption>HD RGBA sans fond ({whd}×{hhd} px) — Clic droit → Enregistrer l’image sous…</figcaption>
          </figure>
          <div class="stage-pair">
            <figure class="stage small">
              <img class="pixel" src="{j1x_uri}" width="{w1 * 2}" height="{h1 * 2}" alt="{rec["id"]} 1x Jour" />
              <figcaption>1× PMDO Jour ({w1}×{h1} px · {w1 // 8}×{h1 // 8} tuiles)</figcaption>
            </figure>
            <figure class="stage small night">
              <img class="pixel" src="{n1x_uri}" width="{w1 * 2}" height="{h1 * 2}" alt="{rec["id"]} 1x Nuit" />
              <figcaption>1× PMDO Nuit ({w1}×{h1} px · {w1 // 8}×{h1 // 8} tuiles)</figcaption>
            </figure>
          </div>
          <div class="meta-bar">
            <span class="badge accent">Zéro devanture · Zéro panneau · Zéro lanterne</span>
            <span class="badge">Tuiles uniques : {rec["unique_tiles"]} / {rec["total_tiles"]}</span>
          </div>
        </article>"""
        )

    sj_uri = png_to_data_uri(sheet_jour)
    sn_uri = png_to_data_uri(sheet_nuit)
    sj_im = Image.open(sheet_jour)

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Les 8 Spinda Cafés Monumentaux — Architecture Pure Style Dojo Makuhita (Sans Devanture)</title>
  <style>
    :root {{
      --bg: #201a18;
      --panel: #2c2320;
      --stage: #382f28;
      --stage-night: #1c2030;
      --line: #58453d;
      --cream: #f7ebd2;
      --gold: #e4b659;
      --coral: #d95d56;
      --ink: #faf2ea;
      --muted: #cfc0b4;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      padding: 28px 24px 64px;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
      background: var(--bg);
      color: var(--ink);
      line-height: 1.5;
    }}
    header, .sheet-box {{
      max-width: 1420px;
      margin: 0 auto 28px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 22px 26px;
    }}
    h1 {{ margin: 0 0 8px; font-size: 1.65rem; color: var(--cream); }}
    header p {{ margin: 6px 0; color: var(--muted); max-width: 980px; }}
    .nav-links {{ display: flex; flex-wrap: wrap; gap: 10px; margin-top: 14px; }}
    .nav-links a {{
      color: var(--ink);
      background: #3d302b;
      border: 1px solid var(--line);
      padding: 7px 13px;
      border-radius: 8px;
      text-decoration: none;
      font-size: 0.9rem;
    }}
    .nav-links a:hover {{ border-color: var(--gold); color: var(--cream); }}
    .sheet-box h2 {{ margin: 0 0 12px; font-size: 1.2rem; color: var(--cream); }}
    .sheet-grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(460px, 1fr)); gap: 18px; }}
    .grid {{
      max-width: 1420px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(560px, 1fr));
      gap: 20px;
    }}
    .card {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 18px;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }}
    .card-head {{ display: flex; justify-content: space-between; align-items: center; gap: 8px; }}
    .bank {{
      background: #4a3328;
      color: var(--cream);
      border: 1px solid var(--gold);
      border-radius: 6px;
      padding: 2px 9px;
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 0.82rem;
      font-weight: 700;
    }}
    .cat {{ font-size: 0.8rem; color: var(--muted); text-align: right; }}
    .card h2 {{ margin: 0; font-size: 1.08rem; color: #fff8f2; }}
    .desc {{ margin: 0; font-size: 0.88rem; color: var(--muted); }}
    .stage {{
      margin: 0;
      background: var(--stage);
      border: 1px solid var(--line);
      border-radius: 10px;
      padding: 16px 12px 10px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 10px;
    }}
    .stage.night {{ background: var(--stage-night); }}
    .stage figcaption {{ font-size: 0.78rem; color: var(--muted); text-align: center; }}
    .stage-pair {{ display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }}
    img.pixel {{
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      display: block;
      max-width: 100%;
      height: auto;
    }}
    img.hd-view {{ max-height: 270px; width: auto; }}
    .meta-bar {{ display: flex; flex-wrap: wrap; gap: 8px; margin-top: auto; }}
    .badge {{
      font-size: 0.76rem;
      background: #3a2d28;
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 3px 10px;
      color: var(--muted);
    }}
    .badge.accent {{ border-color: var(--gold); color: var(--cream); }}
  </style>
</head>
<body>
  <header>
    <h1>Les 8 Spinda Cafés Monumentaux — Style Officiel « Dojo Makuhita » (100 % Sans Devanture)</h1>
    <p>
      <strong>8 architectures monumentales pures</strong> ciselées en pixel-art 2D style Chunsoft GBA/DS (colonnes de pierre gravées de spirales,
      dômes écaillés crème &amp; vermillon aux taches asymétriques uniques de Spinda, toitures courbées à cornes faîtières dorées) :
      <strong>zéro devanture de magasin, zéro comptoir, zéro bouteilles, zéro rideau noren, zéro panneau devant et zéro lanterne</strong>
      — uniquement une arche d’entrée noire profonde et noble comme sur le vrai Dojo Makuhita de PMD.
    </p>
    <p>
      <strong>Zéro damier et zéro &lt;canvas&gt;</strong> : chaque image est une vraie balise <code>&lt;img&gt;</code> PNG <code>RGBA</code>
      avec transparence réelle <code>alpha = 0</code> sur aplat neutre uni (<em>Clic droit → Enregistrer l’image sous…</em> conserve le PNG sans fond).
      Les calques <code>Arriere_Under</code> / <code>Avant_Base</code> séparent strictement les surfaces visibles sans reconstruire les zones occultées.
    </p>
    <nav class="nav-links">
      <a href="/">← Accueil des aperçus</a>
      <a href="apercu_tente_evoli_pmdo.html">Voir aussi : Tentes &amp; Kiosques Évoli (EVT1–EVT6)</a>
      <a href="apercu_maison_forgelina_pmdo.html">Voir aussi : Maison / Monument Forgelina Style Kangourex (FGK1–FGK6)</a>
      <a href="livrables_spinda_cafe_dojo_pmdo/Spinda_Cafe_Style_DojoMakuhita_PMDO.zip">Télécharger le ZIP complet des 8 Spinda Cafés (.tile + 1x + HD)</a>
    </nav>
  </header>

  <section class="sheet-box">
    <h2>Planches Tileset Complètes des 8 Spinda Cafés 1× PMDO (Grille exacte 8×8 px — {sj_im.width}×{sj_im.height} px — Jour &amp; Nuit)</h2>
    <div class="sheet-grid">
      <figure class="stage">
        <img class="pixel" src="{sj_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète des 8 Spinda Cafés Jour 1x" />
        <figcaption>Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Jour.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
      </figure>
      <figure class="stage night">
        <img class="pixel" src="{sn_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète des 8 Spinda Cafés Nuit 1x" />
        <figcaption>Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Nuit.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
      </figure>
    </div>
  </section>

  <main class="grid">
    {"".join(cards_html)}
  </main>
</body>
</html>
"""
    HTML_PREVIEW.write_text(html, encoding="utf-8")


def main() -> None:
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    for d in (HD_DIR, PMDO_1X_DIR, TILE_DIR):
        d.mkdir(parents=True, exist_ok=True)

    records: List[Dict] = []
    day_sprites: List[Image.Image] = []
    night_sprites: List[Image.Image] = []

    for spec in SPECS:
        webp_path = BRUTS_DIR / f"{spec['raw']}.webp"
        raw_im = Image.open(webp_path).convert("RGB")
        clean_full = extract_clean_rgba(raw_im, has_green_props=False)

        hd_max = 640
        scale_hd = min(hd_max / clean_full.width, hd_max / clean_full.height, 1.0)
        hd_wh = (max(8, int(round(clean_full.width * scale_hd))), max(8, int(round(clean_full.height * scale_hd))))
        hd_im = resize_clean_rgba(clean_full, hd_wh, margin=4)
        hd_path = HD_DIR / f"{spec['id']}_HD.png"
        save_binary_indexed_png(hd_im, hd_path, clamp_green=True)

        day_1x = resize_clean_rgba(clean_full, spec["target_1x"], margin=2)
        night_1x = make_night_variant(day_1x)
        under_1x, base_1x = split_visible_layers(day_1x, spec["split_row_ratio"])

        day_path = PMDO_1X_DIR / f"{spec['id']}_1x_Jour.png"
        night_path = PMDO_1X_DIR / f"{spec['id']}_1x_Nuit.png"
        under_path = PMDO_1X_DIR / f"{spec['id']}_1x_Arriere_Under.png"
        base_path = PMDO_1X_DIR / f"{spec['id']}_1x_Avant_Base.png"

        for im_out, p_out in (
            (day_1x, day_path),
            (night_1x, night_path),
            (under_1x, under_path),
            (base_1x, base_path),
        ):
            save_binary_indexed_png(im_out, p_out, clamp_green=True)

        day_reloaded = Image.open(day_path).convert("RGBA")
        night_reloaded = Image.open(night_path).convert("RGBA")
        day_sprites.append(day_reloaded)
        night_sprites.append(night_reloaded)

        def emit_bank(bank_name: str, im_rgba: Image.Image, png_name: str) -> Tuple[Path, Path, int]:
            arr_b = np.array(im_rgba, dtype=np.uint8)
            th_b, tw_b, _ = arr_b.shape
            cols_b, rows_b = tw_b // 8, th_b // 8
            bk = TileBank(bank_name, preserve_layout=True)
            for gy in range(rows_b):
                for gx in range(cols_b):
                    bk.add(Image.fromarray(arr_b[gy * 8 : (gy + 1) * 8, gx * 8 : (gx + 1) * 8]), gx, gy)
            tp = TILE_DIR / f"{bank_name}.tile"
            jp = TILE_DIR / f"{bank_name}.tsj"
            bk.write(tp)
            write_tsj(f"../1x_PMDO_8px_sans_fond/{png_name}", bank_name, tw_b, th_b, jp)
            return tp, jp, len(bk.data)

        tile_path, tsj_path, uniq_day = emit_bank(f"{spec['prefix']}_00_JOUR", day_reloaded, day_path.name)
        tile_night_path, tsj_night_path, uniq_night = emit_bank(f"{spec['prefix']}_01_NUIT", night_reloaded, night_path.name)

        cols_g, rows_g = day_reloaded.width // 8, day_reloaded.height // 8
        records.append(
            {
                "prefix": spec["prefix"],
                "id": spec["id"],
                "title": spec["title"],
                "category": spec["category"],
                "desc": spec["desc"],
                "source_webp": str(webp_path.relative_to(ROOT)),
                "hd_png": str(hd_path.relative_to(ROOT)),
                "day_1x_png": str(day_path.relative_to(ROOT)),
                "night_1x_png": str(night_path.relative_to(ROOT)),
                "under_1x_png": str(under_path.relative_to(ROOT)),
                "base_1x_png": str(base_path.relative_to(ROOT)),
                "tile_bank": str(tile_path.relative_to(ROOT)),
                "tile_bank_nuit": str(tile_night_path.relative_to(ROOT)),
                "tsj_file": str(tsj_path.relative_to(ROOT)),
                "tsj_file_nuit": str(tsj_night_path.relative_to(ROOT)),
                "size_hd": list(hd_im.size),
                "size_1x": list(day_reloaded.size),
                "grid_tiles": [cols_g, rows_g],
                "unique_tiles": uniq_day,
                "unique_tiles_nuit": uniq_night,
                "total_tiles": cols_g * rows_g,
                "has_green_props": False,
            }
        )
        print(f"[OK] {spec['prefix']} {spec['id']} -> 1x={day_reloaded.size} ({cols_g}x{rows_g} tiles, uniq={uniq_day})")

    sheet_jour = PMDO_1X_DIR / "Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Jour.png"
    sheet_nuit = PMDO_1X_DIR / "Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Nuit.png"
    save_binary_indexed_png(build_atlas(day_sprites), sheet_jour, clamp_green=True)
    save_binary_indexed_png(build_atlas(night_sprites), sheet_nuit, clamp_green=True)

    readme_txt = """PACK DES 8 SPINDA CAFÉS MONUMENTAUX — ARCHITECTURE PURE SANS DEVANTURE (PMDO)
=============================================================================

Contenu :
- 1x_PMDO_8px_sans_fond/ : 8 bâtiments monumentaux 1x sur grille exacte 8x8 px (Jour, Nuit, Arriere_Under, Avant_Base + Planches)
- PMDO_tiles/            : Banques natives .tile RogueEssence / Halcyon 0.8.12 (SPC1 à SPC8, Jour & Nuit) + .tsj Tiled
- HD_sans_fond/          : PNG haute définition sans fond (alpha binaire strict {0, 255}, 0 px de frange verte)
- manifest.json          : Métadonnées techniques et état d'homologation honnête

8 architectures pures (ZÉRO devanture, ZÉRO comptoir, ZÉRO rideau noren, ZÉRO panneau, ZÉRO lanterne) :
- SPC1 : Grand Dojo Spinda Classique — Dôme Écaillé Sculpté (224x120 px — 28x15 tuiles)
- SPC2 : Dojo Spinda Classique — Corniche Ondulée d'Or & Volutes (232x96 px — 29x12 tuiles)
- SPC3 : Grand Dojo Spinda Inversé — Aile Gauche & Tour Écaillée Droite (224x96 px — 28x12 tuiles)
- SPC4 : Grande Pagode Impériale à Galerie Balustrade & Doubles Cornes (240x96 px — 30x12 tuiles)
- SPC5 : Grande Rotonde Impériale en Cour Circulaire « Temple Dojo Spinda » (224x128 px — 28x16 tuiles)
- SPC6 : Sanctuaire Double-Dôme Jumeau « Motifs Asymétriques Spinda » (240x96 px — 30x12 tuiles)
- SPC7 : Palais Triptyque à Haute Tour Cylindrique Centrale Spinda (224x128 px — 28x16 tuiles)
- SPC8 : Pavillon Dojo Spinda Compact Noble 1 Aile (192x72 px — 24x9 tuiles)

Arriere_Under / Avant_Base : découpe stricte des surfaces visibles sans reconstruction spéculative des zones occultées.
"""
    (OUT_DIR / "LISEZ_MOI_IMPORT_PMDO.txt").write_text(readme_txt, encoding="utf-8")

    manifest = {
        "pack_id": "spinda_cafe_dojo_makuhita_pmdo_v3_monumental_sans_devanture",
        "inspiration": "Pokémon Mystery Dungeon (Makuhita Dojo) × Spinda (#0327) — Pure Architecture Without Shopfront",
        "tile_size_px": 8,
        "tile_prefixes": [s["prefix"] for s in SPECS],
        "no_shopfront_devanture": True,
        "no_front_signboard": True,
        "no_entrance_lantern": True,
        "art_approved": False,
        "runtime_tested": False,
        "layer_split_mode": "visible_surface_split_only_no_occluded_reconstruction",
        "sheets_1x": {
            "jour": str(sheet_jour.relative_to(ROOT)),
            "nuit": str(sheet_nuit.relative_to(ROOT)),
        },
        "assets": records,
    }
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")

    with zipfile.ZipFile(ZIP_PATH, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for p in sorted(OUT_DIR.rglob("*")):
            if p.is_file() and p.resolve() != ZIP_PATH.resolve():
                zf.write(p, arcname=str(p.relative_to(OUT_DIR)))

    build_html_gallery(records, sheet_jour, sheet_nuit)
    print(f"[DONE] ZIP: {ZIP_PATH.stat().st_size / 1024:.1f} KiB | HTML: {HTML_PREVIEW.stat().st_size / 1024:.1f} KiB")


if __name__ == "__main__":
    main()
