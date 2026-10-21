#!/usr/bin/env python3
"""
Pipeline de construction PMDO 0.8.12 / Halcyon — Pack Complet des 8 Spinda Cafés (#0327 Spinda)
Inspiration officielle Pokémon Donjon Mystère (Équipe de Secours Rouge/Bleue — Dojo Makuhita).

8 architectures extérieures distinctes dans la même charte pixel-art Chunsoft GBA/DS :
- SPC1 : Dojo Classique Spinda Café (Dôme à gauche + Aile Dojo japonaise à droite — 224×96 px)
- SPC2 : Dojo Inversé & Grand Comptoir Bar à Jus Ouvert + Tabourets (Aile gauche + Dôme bar à droite — 224×120 px)
- SPC3 : Grande Maison de Thé à 2 Étages & Balustrade Bois (Pagode Dojo + Belvédère Spinda — 224×112 px)
- SPC4 : Grand Palais Triptyque Symétrique (Tour Rotonde Centrale Spinda + 2 Ailes Dojo — 224×136 px)
- SPC5 : Salon de Thé Dojo & Terrasse Engawa Extérieure (Tables Chabudai & Coussins Zabuton — 240×128 px)
- SPC6 : Grande Boutique Ronde / Kiosque à Jus & Recyclage (Volets Bois & Bouteilles — 192×120 px)
- SPC7 : Complexe Double Pavillon « Bar à Smoothies + Tour Rotonde Conique » (232×112 px)
- SPC8 : Petit Pavillon Compact Symétrique Portail Dojo (1 Aile — 160×128 px)

Contraintes validées sur 8/8 modèles :
- ZÉRO panneau posé devant la façade et ZÉRO lanterne suspendue
- ZÉRO visage / yeux / bouche vivants sur les murs
- Alpha binaire strict {0, 255}, 0 px de frange verte externe, grille exacte 8×8 px
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
        "id": "01_Spinda_Cafe_Dojo_Classique_Gauche",
        "raw": "spc_01_dojo_spinda_oreilles_pompons",
        "title": "1. Spinda Café — Modèle Classique « Dojo Makuhita » (Dôme à Gauche)",
        "category": "Dojo Classique 2 Ailes (28×12 tuiles)",
        "target_1x": (224, 96),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Adaptation fidèle 1:1 du Dojo Makuhita de PMD : pavillon gauche crépi crème à taches corail, 4 fenêtres à croisillons et dôme coiffé des oreilles spiralées à pompons de Spinda ; aile droite japonaise à toit incurvé corail, portail tourbillon et rideau noren.",
    },
    {
        "prefix": "SPC2",
        "id": "02_Spinda_Cafe_Dojo_Inverse_Comptoir_Bar_Jus",
        "raw": "spc_02_dojo_inverse_bar_jus",
        "title": "2. Spinda Café — Aile Dojo Inversée & Grand Comptoir Bar à Jus",
        "category": "Bar à Smoothies & Tabourets (28×15 tuiles)",
        "target_1x": (224, 120),
        "has_green_props": True,
        "split_row_ratio": 0.60,
        "desc": "Disposition asymétrique inversée : longue aile Dojo japonaise à corne relevée à gauche, et grand pavillon dôme Spinda à droite ouvert en comptoir de smoothies avec fioles multicolores sur étagères, 3 tabourets ronds en bois et tonneaux.",
    },
    {
        "prefix": "SPC3",
        "id": "03_Spinda_Cafe_Maison_The_2_Etages_Balustrade",
        "raw": "spc_03_maison_the_2_etages_balustrade",
        "title": "3. Spinda Café — Grande Maison de Thé à Étage & Balustrade Bois",
        "category": "Pagode Salon de Thé 2 Niveaux (28×14 tuiles)",
        "target_1x": (224, 112),
        "has_green_props": False,
        "split_row_ratio": 0.64,
        "desc": "Architecture japonaise à deux niveaux : rez-de-chaussée Dojo à doubles cornes de toit relevées, fenêtres shoji et portail tourbillon, surmonté d'un étage belvédère en dôme Spinda entouré d'une balustrade en bois sombre.",
    },
    {
        "prefix": "SPC4",
        "id": "04_Spinda_Cafe_Grand_Palais_Triptyque_Central",
        "raw": "spc_04_grand_palais_triptyque_dojo",
        "title": "4. Spinda Café — Grand Palais Triptyque Symétrique (Tour Centrale)",
        "category": "Édifice Monumental 3 Corps (28×17 tuiles)",
        "target_1x": (224, 136),
        "has_green_props": False,
        "split_row_ratio": 0.65,
        "desc": "Composition monumentale symétrique : haute rotonde centrale tachetée coiffée du dôme à oreilles spiralées avec portail d'honneur central à volutes tourbillon, encadrée de part et d'autre par deux ailes Dojo japonaises à toits courbés.",
    },
    {
        "prefix": "SPC5",
        "id": "05_Spinda_Cafe_Dojo_Terrasse_Engawa_Chabudai",
        "raw": "spc_05_dojo_terrasse_engawa_chabudai",
        "title": "5. Spinda Café — Salon Dojo & Terrasse Engawa Extérieure (Tables Chabudai)",
        "category": "Café avec Terrasse Bois & Coussins (30×16 tuiles)",
        "target_1x": (240, 128),
        "has_green_props": False,
        "split_row_ratio": 0.62,
        "desc": "Pavillon octogonal boisé à dôme Spinda à gauche et entrée Dojo à toit karahafu au centre, prolongés à droite par une terrasse japonaise sur pilotis (engawa) sous pergola avec tables basses rondes chabudai et coussins zabuton.",
    },
    {
        "prefix": "SPC6",
        "id": "06_Spinda_Cafe_Boutique_Ronde_Volets_Jus",
        "raw": "spc_06_kiosque_rond_boutique_baies",
        "title": "6. Spinda Café — Grande Boutique Ronde « Bar à Recyclage & Jus »",
        "category": "Kiosque Circulaire Bourg-Trésor × Dojo (24×15 tuiles)",
        "target_1x": (192, 120),
        "has_green_props": True,
        "split_row_ratio": 0.60,
        "desc": "Pavillon rond autonome entouré d'un auvent circulaire de tuiles rouges à cornes relevées sous dôme Spinda : guichet à volets bois battants exposant les fioles de jus de baies à gauche, portail tourbillon à rideau corail à droite et tonneaux.",
    },
    {
        "prefix": "SPC7",
        "id": "07_Spinda_Cafe_Complexe_Double_Pavillon_Rotonde",
        "raw": "spc_07_complexe_double_dome_rotonde",
        "title": "7. Spinda Café — Complexe Double Pavillon (Comptoir Jus + Tour Conique)",
        "category": "Complexe Taverne & Salon Rotonde (29×14 tuiles)",
        "target_1x": (232, 112),
        "has_green_props": True,
        "split_row_ratio": 0.62,
        "desc": "Complexe réunissant trois volumes : pavillon comptoir de jus sous store rayé et dôme Spinda à gauche, galerie Dojo centrale à portail tourbillon, et tour rotonde tachetée à toit conique de tuiles rouges et baie vitrée à droite.",
    },
    {
        "prefix": "SPC8",
        "id": "08_Spinda_Cafe_Petit_Pavillon_Compact_Dojo",
        "raw": "spc_08_petit_pavillon_compact_dojo",
        "title": "8. Spinda Café — Petit Pavillon Symétrique Compact (1 Aile)",
        "category": "Pavillon Compact Petits Terrains (20×16 tuiles)",
        "target_1x": (160, 128),
        "has_green_props": False,
        "split_row_ratio": 0.65,
        "desc": "Version compacte symétrique à 1 aile pour les petites parcelles de village PMDO : toit incurvé à double corne relevée, oreilles spiralées de Spinda, fronton tourbillon et rideau noren crème.",
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

    trans = out[:, :, 3] == 0
    ring = trans.copy()
    for _ in range(3):
        ring = (
            ring
            | np.pad(ring[1:, :], ((0, 1), (0, 0)), constant_values=True)
            | np.pad(ring[:-1, :], ((1, 0), (0, 0)), constant_values=True)
            | np.pad(ring[:, 1:], ((0, 0), (0, 1)), constant_values=True)
            | np.pad(ring[:, :-1], ((0, 0), (1, 0)), constant_values=True)
        )
    despill = (ring & (~trans)) if has_green_props else (~trans)
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

    # Extra rim despill right after resize so no subpixel green edge forms along transparent border
    trans_r = ~a_out
    ring_r = (
        np.pad(trans_r[1:, :], ((0, 1), (0, 0)), constant_values=True)
        | np.pad(trans_r[:-1, :], ((1, 0), (0, 0)), constant_values=True)
        | np.pad(trans_r[:, 1:], ((0, 0), (0, 1)), constant_values=True)
        | np.pad(trans_r[:, :-1], ((0, 0), (1, 0)), constant_values=True)
    ) & a_out
    max_rb_r = np.maximum(rgb_sharp[:, :, 0], rgb_sharp[:, :, 2])
    rgb_sharp[:, :, 1] = np.where(ring_r & (rgb_sharp[:, :, 1] > max_rb_r), max_rb_r, rgb_sharp[:, :, 1])

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


def save_binary_indexed_png(im_rgba: Image.Image, path: Path, clamp_green: bool = False) -> None:
    arr = np.array(im_rgba.convert("RGBA"))
    mask = arr[:, :, 3] >= 128
    rgb = Image.fromarray(np.where(mask[:, :, None], arr[:, :, :3], 0).astype(np.uint8), "RGB")
    q = rgb.quantize(colors=255, method=Image.MEDIANCUT, dither=Image.NONE)
    q_idx = np.array(q, dtype=np.uint8) + 1
    q_idx[~mask] = 0

    pal = np.array(q.getpalette()[: 255 * 3], dtype=np.int32).reshape(255, 3)
    if clamp_green:
        pal[:, 1] = np.minimum(pal[:, 1], np.maximum(pal[:, 0], pal[:, 2]))
    else:
        # Ensure palette indices that touch the 1px transparent contour never exceed max(R, B) + 6
        trans = ~mask
        ring = (
            np.pad(trans[1:, :], ((0, 1), (0, 0)), constant_values=True)
            | np.pad(trans[:-1, :], ((1, 0), (0, 0)), constant_values=True)
            | np.pad(trans[:, 1:], ((0, 0), (0, 1)), constant_values=True)
            | np.pad(trans[:, :-1], ((0, 0), (1, 0)), constant_values=True)
        ) & mask
        for idx_val in np.unique(q_idx[ring]):
            if idx_val > 0:
                p_i = idx_val - 1
                pal[p_i, 1] = min(pal[p_i, 1], max(pal[p_i, 0], pal[p_i, 2]))

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
            <span class="badge accent">Sans panneau devant · Sans lanterne · Sans visage</span>
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
  <title>Les 8 Spinda Cafés × Dojo Makuhita (#0327) — Pack Complet PMDO Sans Fond</title>
  <style>
    :root {{
      --bg: #221b19;
      --panel: #2e2421;
      --stage: #3a3028;
      --stage-night: #1d2030;
      --line: #56423c;
      --cream: #f5ead4;
      --coral: #d95d56;
      --ink: #faf2ea;
      --muted: #ccbcb2;
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
      background: #3e302c;
      border: 1px solid var(--line);
      padding: 7px 13px;
      border-radius: 8px;
      text-decoration: none;
      font-size: 0.9rem;
    }}
    .nav-links a:hover {{ border-color: var(--coral); color: var(--cream); }}
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
      background: #4d3230;
      color: var(--cream);
      border: 1px solid var(--coral);
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
    img.hd-view {{ max-height: 260px; width: auto; }}
    .meta-bar {{ display: flex; flex-wrap: wrap; gap: 8px; margin-top: auto; }}
    .badge {{
      font-size: 0.76rem;
      background: #3b2d29;
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 3px 10px;
      color: var(--muted);
    }}
    .badge.accent {{ border-color: var(--coral); color: var(--cream); }}
  </style>
</head>
<body>
  <header>
    <h1>Les 8 Spinda Cafés — Inspiration « Dojo Makuhita » (Pokémon Donjon Mystère)</h1>
    <p>
      <strong>8 architectures complètes et distinctes</strong> générées dans la même direction artistique pixel-art 2D Chunsoft GBA/DS :
      Dojo classique, Bar à Jus inversé à tabourets, Maison de Thé à étage avec balustrade, Grand Palais triptyque central,
      Salon Dojo avec terrasse <em>engawa</em> &amp; tables <em>chabudai</em>, Boutique ronde à volets, Complexe double pavillon &amp; tour conique,
      et Petit Pavillon compact — <strong>tous sans panneau devant la façade et sans aucune lanterne</strong>.
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
        clean_full = extract_clean_rgba(raw_im, has_green_props=spec["has_green_props"])
        clamp_g = not spec["has_green_props"]

        hd_max = 640
        scale_hd = min(hd_max / clean_full.width, hd_max / clean_full.height, 1.0)
        hd_wh = (max(8, int(round(clean_full.width * scale_hd))), max(8, int(round(clean_full.height * scale_hd))))
        hd_im = resize_clean_rgba(clean_full, hd_wh, margin=4)
        hd_path = HD_DIR / f"{spec['id']}_HD.png"
        save_binary_indexed_png(hd_im, hd_path, clamp_green=clamp_g)

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
            save_binary_indexed_png(im_out, p_out, clamp_green=clamp_g)

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
                "has_green_props": spec["has_green_props"],
            }
        )
        print(f"[OK] {spec['prefix']} {spec['id']} -> 1x={day_reloaded.size} ({cols_g}x{rows_g} tiles, uniq={uniq_day})")

    sheet_jour = PMDO_1X_DIR / "Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Jour.png"
    sheet_nuit = PMDO_1X_DIR / "Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Nuit.png"
    save_binary_indexed_png(build_atlas(day_sprites), sheet_jour, clamp_green=False)
    save_binary_indexed_png(build_atlas(night_sprites), sheet_nuit, clamp_green=False)

    readme_txt = """PACK DES 8 SPINDA CAFÉS — INSPIRATION DOJO MAKUHITA (POKÉMON DONJON MYSTÈRE)
===========================================================================

Contenu :
- 1x_PMDO_8px_sans_fond/ : 8 bâtiments complets 1x sur grille exacte 8x8 px (Jour, Nuit, Arriere_Under, Avant_Base + Planches complètes)
- PMDO_tiles/            : Banques natives .tile RogueEssence / Halcyon 0.8.12 (SPC1 à SPC8, Jour & Nuit) + .tsj Tiled
- HD_sans_fond/          : PNG haute définition sans fond (alpha binaire strict {0, 255}, 0 px de frange verte)
- manifest.json          : Métadonnées techniques et état d'homologation honnête

8 variantes architecturales incluses :
- SPC1 : Dojo Classique Spinda Café (224x96 px — 28x12 tuiles)
- SPC2 : Dojo Inversé & Grand Comptoir Bar à Jus + Tabourets (224x120 px — 28x15 tuiles)
- SPC3 : Grande Maison de Thé à 2 Étages & Balustrade Bois (224x112 px — 28x14 tuiles)
- SPC4 : Grand Palais Triptyque Symétrique Tour Centrale (224x136 px — 28x17 tuiles)
- SPC5 : Salon Dojo & Terrasse Engawa Extérieure Chabudai (240x128 px — 30x16 tuiles)
- SPC6 : Grande Boutique Ronde / Kiosque à Volets & Jus (192x120 px — 24x15 tuiles)
- SPC7 : Complexe Double Pavillon Comptoir + Rotonde Conique (232x112 px — 29x14 tuiles)
- SPC8 : Petit Pavillon Compact Symétrique Portail Dojo (160x128 px — 20x16 tuiles)

Aucun panneau devant la façade et aucune lanterne sur 8/8 modèles.
Arriere_Under / Avant_Base : découpe stricte des surfaces visibles sans reconstruction spéculative des zones occultées.
"""
    (OUT_DIR / "LISEZ_MOI_IMPORT_PMDO.txt").write_text(readme_txt, encoding="utf-8")

    manifest = {
        "pack_id": "spinda_cafe_dojo_makuhita_pmdo_v2_8_architectures",
        "inspiration": "Pokémon Mystery Dungeon (Red/Blue Rescue Team — Makuhita Dojo) × Spinda Café (#0327)",
        "tile_size_px": 8,
        "tile_prefixes": [s["prefix"] for s in SPECS],
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
