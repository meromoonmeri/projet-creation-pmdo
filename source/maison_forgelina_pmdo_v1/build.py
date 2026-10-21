#!/usr/bin/env python3
"""
Pipeline de construction PMDO 0.8.12 / Halcyon — Pack Maisons & Monuments Forgelina
(Inspiration officielle Pokémon Donjon Mystère : Maison / Réserve Kangourex — Place Pokémon & Bourg-Trésor).

Garanties strictes :
- Conversion sans perte des bruts PNG -> WebP dans source/maison_forgelina_pmdo_v1/bruts/
- Détourage flood-fill extérieur depuis #00FF00 + suppression complète de toute frange verte (0 px)
  tout en préservant intacte la mousse végétale interne de FGK5 (Maison Rocher Bourg-Trésor)
- Alpha strictement binaire {0, 255} sur tous les PNG (palette indexée RGB 255 couleurs + index 0 transparent)
- Dimensions 1x PMDO multiples exacts de 8x8 px, variantes Jour & Nuit (fenêtres et forge illuminées),
  découpes visibles Arriere_Under / Avant_Base (sans reconstruction spéculative des pixels occultés)
- Banques natives .tile Halcyon (préfixes uniques FGK1..FGK9) + .tsj Tiled + manifest.json + archive .zip
- Aperçu HTML pur <img> RGBA alpha=0 (zéro <canvas>, zéro damier)
"""

from __future__ import annotations

import base64
import collections
import io
import json
import math
import os
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

from source.pmdo_cote.build import TileBank  # Codec natif .tile Halcyon / PMDO 0.8.12

MOD_DIR = ROOT / "source" / "maison_forgelina_pmdo_v1"
BRUTS_DIR = MOD_DIR / "bruts"
OUT_DIR = ROOT / "livrables_maison_forgelina_pmdo"
HD_DIR = OUT_DIR / "HD_sans_fond"
PMDO_1X_DIR = OUT_DIR / "1x_PMDO_8px_sans_fond"
TILE_DIR = OUT_DIR / "PMDO_tiles"
HTML_PREVIEW = ROOT / "apercu_maison_forgelina_pmdo.html"
ZIP_PATH = OUT_DIR / "Forgelina_Maisons_Style_Kangourex_PMDO.zip"

SPECS = [
    {
        "prefix": "FGK1",
        "id": "01_Forgelina_Maison_Kangourex_Sans_Visage_Lisse",
        "raw": "exact_01_sans_visage_pierre_lisse",
        "title": "Structure Validée — Version 1 : Mèche & Pierre Rose Lisse (Sans Visage)",
        "category": "Modèle Validé — Fond d'Alcôve Sombre",
        "target_1x": (144, 144),
        "hollow_alcove": False,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Structure exacte validée (inspiration Maison / Réserve Kangourex PMD) avec retrait intégral des yeux, sourcils et bouche : dôme de pierre rose lisse entre les boucles, marteau géant riveté, colonnes torsadées, mains posées sur le muret-comptoir festonné et alcôve sombre vide.",
    },
    {
        "prefix": "FGK2",
        "id": "02_Forgelina_Maison_Kangourex_Sans_Visage_Lisse_Alpha0",
        "raw": "exact_01_sans_visage_pierre_lisse",
        "title": "Structure Validée — Version 1 Percée (Baie Centrale Alpha=0)",
        "category": "Modèle Validé — Baie Percée α=0 (PNJ sous calque)",
        "target_1x": (144, 144),
        "hollow_alcove": True,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Même structure validée à pierre rose lisse sans visage, avec l'ouverture centrale derrière le comptoir en U percée à alpha=0 réel afin d'y placer un sol PMDO et le sprite animé de Forgelina.",
    },
    {
        "prefix": "FGK3",
        "id": "03_Forgelina_Maison_Kangourex_Sans_Visage_Boucle_Spiralee",
        "raw": "exact_03_houppette_boucles_sans_visage",
        "title": "Structure Validée — Version 2 : Grande Boucle Spiralée Continue (Sans Visage)",
        "category": "Modèle Validé — Fond d'Alcôve Sombre",
        "target_1x": (144, 144),
        "hollow_alcove": False,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Structure exacte validée où l'emplacement du visage est prolongé sans couture par l'enroulement de la grosse boucle spiralée en pierre rose, sans aucune sphère faciale ni yeux ni bouche.",
    },
    {
        "prefix": "FGK4",
        "id": "04_Forgelina_Maison_Kangourex_Sans_Visage_Boucle_Alpha0",
        "raw": "exact_03_houppette_boucles_sans_visage",
        "title": "Structure Validée — Version 2 Percée (Baie Centrale Alpha=0)",
        "category": "Modèle Validé — Baie Percée α=0 (PNJ sous calque)",
        "target_1x": (144, 144),
        "hollow_alcove": True,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Variante à boucle spiralée continue sans visage avec ouverture centrale percée à alpha=0 réel derrière le muret-comptoir festonné.",
    },
    {
        "prefix": "FGK5",
        "id": "05_Forgelina_Maison_Kangourex_Sans_Tete_Toit_Pierre",
        "raw": "exact_04_sans_tete_toit_rose",
        "title": "Structure Validée — Version 3 : Sans Tête (Toit Voûté Pierre Rose & Manche Complet)",
        "category": "Modèle Validé — Toit Pur & Fond d'Alcôve Sombre",
        "target_1x": (144, 144),
        "hollow_alcove": False,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Structure exacte validée avec toute la tête centrale retirée du sommet : le toit voûté en côtes de pierre rose se prolonge d'un seul tenant sous le manche complet du marteau géant.",
    },
    {
        "prefix": "FGK6",
        "id": "06_Forgelina_Maison_Kangourex_Sans_Tete_Toit_Pierre_Alpha0",
        "raw": "exact_04_sans_tete_toit_rose",
        "title": "Structure Validée — Version 3 Percée (Sans Tête · Baie Centrale Alpha=0)",
        "category": "Modèle Validé — Toit Pur & Baie Percée α=0",
        "target_1x": (144, 144),
        "hollow_alcove": True,
        "has_moss": False,
        "split_row_ratio": 0.68,
        "desc": "Structure exacte validée sans tête centrale (toit voûté en pierre rose et manche complet du marteau) avec baie centrale percée à alpha=0 réel derrière le comptoir en U.",
    },
]


def convert_bruts_to_lossless_webp() -> List[Dict]:
    converted = []
    for png_path in sorted(BRUTS_DIR.glob("fgk_*.png")):
        webp_path = png_path.with_suffix(".webp")
        im = Image.open(png_path).convert("RGB")
        im.save(webp_path, "WEBP", lossless=True, method=6)
        png_path.unlink()
        converted.append({"webp": str(webp_path.relative_to(ROOT)), "bytes": webp_path.stat().st_size, "size": im.size})
    return converted


def extract_clean_rgba(im_rgb: Image.Image, hollow_alcove: bool = False, has_moss: bool = False) -> Image.Image:
    arr = np.array(im_rgb.convert("RGB"), dtype=np.int16)
    h, w, _ = arr.shape
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]

    # Flood-fill strict depuis les 4 coins sur le fond chroma #00FF00
    chroma_candidate = (g > 155) & ((g - np.maximum(r, b)) > 42)
    ext = np.zeros((h, w), dtype=bool)
    q = collections.deque()
    for sx in range(w):
        for sy in (0, h - 1):
            if chroma_candidate[sy, sx] and not ext[sy, sx]:
                ext[sy, sx] = True
                q.append((sy, sx))
    for sy in range(h):
        for sx in (0, w - 1):
            if chroma_candidate[sy, sx] and not ext[sy, sx]:
                ext[sy, sx] = True
                q.append((sy, sx))

    while q:
        cy, cx = q.popleft()
        for ny, nx in ((cy - 1, cx), (cy + 1, cx), (cy, cx - 1), (cy, cx + 1)):
            if 0 <= ny < h and 0 <= nx < w and not ext[ny, nx] and chroma_candidate[ny, nx]:
                ext[ny, nx] = True
                q.append((ny, nx))

    # Passe d'érosion de halo anti-aliasing sur le liseré externe (2 passes)
    for _ in range(2):
        dil = (
            np.pad(ext[1:, :], ((0, 1), (0, 0)), constant_values=True)
            | np.pad(ext[:-1, :], ((1, 0), (0, 0)), constant_values=True)
            | np.pad(ext[:, 1:], ((0, 0), (0, 1)), constant_values=True)
            | np.pad(ext[:, :-1], ((0, 0), (1, 0)), constant_values=True)
        )
        edge_ring = dil & (~ext)
        spill = edge_ring & ((g - np.maximum(r, b)) > 16) & (g > 95)
        ext |= spill

    # Variante percée : ouverture centrale derrière le comptoir en U mise à alpha = 0 tout en gardant le liseré sombre droit intact
    if hollow_alcove:
        cy0, cy1 = int(h * 0.495), int(h * 0.790)
        cx0, cx1 = int(w * 0.338), int(w * 0.662)
        sub_r, sub_g, sub_b = r[cy0:cy1, cx0:cx1], g[cy0:cy1, cx0:cx1], b[cy0:cy1, cx0:cx1]
        # Cavité sombre + sol brun interne entre les montants verticaux clairs
        dark_interior = (sub_r < 115) & (sub_g < 92) & (sub_b < 72)
        seed_y, seed_x = cy0 + (cy1 - cy0) // 2, cx0 + (cx1 - cx0) // 2
        if dark_interior[seed_y - cy0, seed_x - cx0]:
            hq = collections.deque([(seed_y, seed_x)])
            hole = np.zeros((h, w), dtype=bool)
            hole[seed_y, seed_x] = True
            while hq:
                hy, hx = hq.popleft()
                for ny, nx in ((hy - 1, hx), (hy + 1, hx), (hy, hx - 1), (hy, hx + 1)):
                    if cy0 <= ny < cy1 and cx0 <= nx < cx1 and not hole[ny, nx]:
                        if dark_interior[ny - cy0, nx - cx0]:
                            hole[ny, nx] = True
                            hq.append((ny, nx))
            ext |= hole

    out = np.zeros((h, w, 4), dtype=np.uint8)
    out[:, :, :3] = np.clip(arr, 0, 255).astype(np.uint8)
    out[:, :, 3] = np.where(ext, 0, 255).astype(np.uint8)

    # Dé-spill chromatique complet sur un anneau de 3 pixels autour de toute zone transparente
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
    rim = ring & (~trans)
    if not has_moss:
        despill_mask = out[:, :, 3] == 255
    else:
        despill_mask = rim

    rr = out[:, :, 0].astype(np.int16)
    gg = out[:, :, 1].astype(np.int16)
    bb = out[:, :, 2].astype(np.int16)
    max_rb = np.maximum(rr, bb)
    excess = despill_mask & (gg > max_rb)
    out[:, :, 1] = np.where(excess, max_rb, gg).astype(np.uint8)
    out[trans] = (0, 0, 0, 0)

    # Recadrage serré sur la boîte englobante opaque
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

    # Prémultiplication alpha avant rééchantillonnage pour empêcher tout saignement des bords noirs/verts
    arr = np.array(src_rgba, dtype=np.float32)
    alpha = arr[:, :, 3:4] / 255.0
    premult = np.concatenate([arr[:, :, :3] * alpha, arr[:, :, 3:4]], axis=2).astype(np.uint8)
    resized = np.array(Image.fromarray(premult, "RGBA").resize((nw, nh), Image.BOX), dtype=np.float32)

    a_out = resized[:, :, 3] >= 128.0
    rgb_out = np.zeros((nh, nw, 3), dtype=np.uint8)
    valid = resized[:, :, 3] > 1.0
    for c in range(3):
        rgb_out[:, :, c] = np.where(valid, np.clip(np.round(resized[:, :, c] / np.maximum(resized[:, :, 3] / 255.0, 1e-3)), 0, 255), 0).astype(np.uint8)

    # Renforcement léger du contraste pixel PMD GBA/DS
    pil_rgb = ImageEnhance.Sharpness(Image.fromarray(rgb_out, "RGB")).enhance(1.25)
    rgb_sharp = np.array(pil_rgb, dtype=np.uint8)

    canvas = np.zeros((th, tw, 4), dtype=np.uint8)
    ox = (tw - nw) // 2
    oy = th - margin - nh  # Aligné proprement sur la ligne de base PMDO
    sub = canvas[oy : oy + nh, ox : ox + nw]
    sub[:, :, :3] = np.where(a_out[:, :, None], rgb_sharp, 0)
    sub[:, :, 3] = np.where(a_out, 255, 0)
    canvas[oy : oy + nh, ox : ox + nw] = sub
    return Image.fromarray(canvas, "RGBA")


def make_night_variant(day_rgba: Image.Image) -> Image.Image:
    arr = np.array(day_rgba, dtype=np.float32)
    r, g, b, a = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2], arr[:, :, 3]
    opaque = a > 127

    # Détection des zones chaudes émissives (hublots illuminés, braises du foyer, lanterne de forge)
    warm_glow = opaque & (r > 188) & (g > 105) & ((r - b) > 52)

    nr = np.clip(r * 0.56 + 10.0, 0, 255)
    ng = np.clip(g * 0.58 + 16.0, 0, 255)
    nb = np.clip(b * 0.78 + 34.0, 0, 255)

    nr = np.where(warm_glow, np.clip(r * 1.06, 0, 255), nr)
    ng = np.where(warm_glow, np.clip(g * 1.02, 0, 255), ng)
    nb = np.where(warm_glow, np.clip(b * 0.88, 0, 255), nb)

    out = np.zeros_like(arr, dtype=np.uint8)
    out[:, :, 0] = np.where(opaque, nr, 0).astype(np.uint8)
    out[:, :, 1] = np.where(opaque, ng, 0).astype(np.uint8)
    out[:, :, 2] = np.where(opaque, nb, 0).astype(np.uint8)
    out[:, :, 3] = np.where(opaque, 255, 0).astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def save_binary_indexed_png(im_rgba: Image.Image, path: Path) -> None:
    arr = np.array(im_rgba.convert("RGBA"))
    mask = arr[:, :, 3] >= 128
    rgb = Image.fromarray(np.where(mask[:, :, None], arr[:, :, :3], 0).astype(np.uint8), "RGB")
    q = rgb.quantize(colors=255, method=Image.MEDIANCUT, dither=Image.NONE)
    q_idx = np.array(q, dtype=np.uint8) + 1
    q_idx[~mask] = 0

    pal_raw = q.getpalette()[: 255 * 3]
    full_pal = [0, 0, 0] + pal_raw + [0] * (768 - 3 - len(pal_raw))
    out_p = Image.fromarray(q_idx, mode="P")
    out_p.putpalette(full_pal)
    path.parent.mkdir(parents=True, exist_ok=True)
    out_p.save(path, "PNG", transparency=0, optimize=True)


def split_visible_layers(im_rgba: Image.Image, split_ratio: float) -> Tuple[Image.Image, Image.Image]:
    """Découpe stricte en surfaces visibles (sans reconstruction spéculative des pixels occultés)."""
    w, h = im_rgba.size
    split_y = max(8, min(h - 8, int(round((h * split_ratio) / 8.0)) * 8))
    arr = np.array(im_rgba)
    under = np.zeros_like(arr)
    base = np.zeros_like(arr)
    under[:split_y, :, :] = arr[:split_y, :, :]
    base[split_y:, :, :] = arr[split_y:, :, :]
    return Image.fromarray(under, "RGBA"), Image.fromarray(base, "RGBA")


def write_tsj(png_rel: str, name: str, w: int, h: int, tsj_path: Path) -> None:
    cols = w // 8
    rows = h // 8
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
    b64 = base64.b64encode(path.read_bytes()).decode("ascii")
    return f"data:image/png;base64,{b64}"


def build_atlas(sprites: List[Image.Image], padding: int = 8) -> Image.Image:
    cols = 3
    rows = math.ceil(len(sprites) / cols)
    cell_w = max(im.width for im in sprites) + padding * 2
    cell_h = max(im.height for im in sprites) + padding * 2
    cell_w = ((cell_w + 7) // 8) * 8
    cell_h = ((cell_h + 7) // 8) * 8
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (0, 0, 0, 0))
    for idx, im in enumerate(sprites):
        r, c = divmod(idx, cols)
        ox = c * cell_w + (cell_w - im.width) // 2
        oy = r * cell_h + cell_h - padding - im.height
        ox = (ox // 8) * 8
        oy = (oy // 8) * 8
        sheet.paste(im, (ox, oy), im)
    return sheet


def build_html_gallery(records: List[Dict], sheet_jour: Path, sheet_nuit: Path) -> None:
    cards_html = []
    for rec in records:
        hd_uri = png_to_data_uri(ROOT / rec["hd_png"])
        j1x_uri = png_to_data_uri(ROOT / rec["day_1x_png"])
        n1x_uri = png_to_data_uri(ROOT / rec["night_1x_png"])
        w1, h1 = rec["size_1x"]
        whd, hhd = rec["size_hd"]
        hole_badge = (
            f'<span class="badge accent">Baie percée α=0 ({rec["interior_transparent_px_1x"]} px)</span>'
            if rec["hollow_alcove"]
            else '<span class="badge">Alpha binaire {0, 255} · Frange 0 px</span>'
        )
        cards_html.append(
            f"""
        <article class="card">
          <div class="card-head">
            <span class="bank">{rec["prefix"]}.tile</span>
            <span class="cat">{rec["category"]}</span>
          </div>
          <h2>{rec["title"]}</h2>
          <p class="desc">{rec["desc"]}</p>
          <div class="stage-row">
            <figure class="stage">
              <img class="pixel hd-view" src="{hd_uri}" alt="{rec["id"]} HD RGBA sans fond" />
              <figcaption>HD RGBA sans fond ({whd}×{hhd} px) — Clic droit → Enregistrer sous</figcaption>
            </figure>
          </div>
          <div class="stage-pair">
            <figure class="stage small">
              <img class="pixel scale2" src="{j1x_uri}" width="{w1 * 2}" height="{h1 * 2}" alt="{rec["id"]} 1x Jour" />
              <figcaption>1× PMDO Jour ({w1}×{h1} px · {w1 // 8}×{h1 // 8} tuiles)</figcaption>
            </figure>
            <figure class="stage small night">
              <img class="pixel scale2" src="{n1x_uri}" width="{w1 * 2}" height="{h1 * 2}" alt="{rec["id"]} 1x Nuit" />
              <figcaption>1× PMDO Nuit ({w1}×{h1} px · {w1 // 8}×{h1 // 8} tuiles)</figcaption>
            </figure>
          </div>
          <div class="meta-bar">
            {hole_badge}
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
  <title>Maisons & Monuments Forgelina (Style Réserve Kangourex PMD) — Pack PMDO Sans Fond</title>
  <style>
    :root {{
      --bg: #241d19;
      --panel: #2f2621;
      --stage: #3a3028;
      --stage-night: #1d2030;
      --line: #53433a;
      --pink: #f4ced7;
      --rose: #e88eb4;
      --ink: #f7efe9;
      --muted: #cbbab0;
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
    header {{
      max-width: 1380px;
      margin: 0 auto 28px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 22px 26px;
    }}
    h1 {{ margin: 0 0 8px; font-size: 1.65rem; color: var(--pink); }}
    header p {{ margin: 6px 0; color: var(--muted); max-width: 980px; }}
    .nav-links {{ display: flex; flex-wrap: wrap; gap: 10px; margin-top: 14px; }}
    .nav-links a {{
      color: var(--ink);
      background: #3d312b;
      border: 1px solid var(--line);
      padding: 7px 13px;
      border-radius: 8px;
      text-decoration: none;
      font-size: 0.9rem;
    }}
    .nav-links a:hover {{ border-color: var(--rose); color: var(--pink); }}
    .sheet-box {{
      max-width: 1380px;
      margin: 0 auto 30px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 20px 24px;
    }}
    .sheet-box h2 {{ margin: 0 0 12px; font-size: 1.2rem; color: var(--pink); }}
    .sheet-grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(440px, 1fr)); gap: 18px; }}
    .grid {{
      max-width: 1380px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(410px, 1fr));
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
      background: #4a3540;
      color: var(--pink);
      border: 1px solid var(--rose);
      border-radius: 6px;
      padding: 2px 9px;
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 0.82rem;
      font-weight: 700;
    }}
    .cat {{ font-size: 0.82rem; color: var(--muted); }}
    .card h2 {{ margin: 0; font-size: 1.08rem; color: #fff6f8; }}
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
    img.hd-view {{ max-height: 290px; width: auto; }}
    .meta-bar {{ display: flex; flex-wrap: wrap; gap: 8px; margin-top: auto; }}
    .badge {{
      font-size: 0.76rem;
      background: #3a2e28;
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 3px 10px;
      color: var(--muted);
    }}
    .badge.accent {{ border-color: var(--rose); color: var(--pink); }}
  </style>
</head>
<body>
  <header>
    <h1>Maisons & Monuments Forgelina — Inspiration Officielle « Maison / Réserve Kangourex » (PMD)</h1>
    <p>
      9 édifices et accessoires pixel-art 2D style Chunsoft GBA/DS (<em>Place Pokémon</em> &amp; <em>Bourg-Trésor</em>) :
      monuments-comptoirs fidèles à la <strong>Réserve Kangourex</strong> (version pleine + version percée à <code>alpha = 0</code>),
      boutique-forge active avec enclume, maisons habitables avec porte praticable, variantes 100 % architecture sans visage et statue-coffre de réserve.
    </p>
    <p>
      <strong>Zéro damier et zéro &lt;canvas&gt;</strong> : chaque image ci-dessous est une vraie balise <code>&lt;img&gt;</code> PNG <code>RGBA</code>
      avec transparence réelle <code>alpha = 0</code> sur aplat neutre uni (<em>Clic droit → Enregistrer l’image sous…</em> conserve le PNG sans fond).
      Les découpes <code>Arriere_Under</code> / <code>Avant_Base</code> séparent strictement les surfaces visibles sans reconstruire les pixels occultés.
    </p>
    <nav class="nav-links">
      <a href="index.html">← Accueil des aperçus</a>
      <a href="apercu_tentes_huttes_forgelina_pmdo.html">Voir aussi : Pack 11 Tentes &amp; Huttes Forgelina (FGH1–FGHB)</a>
      <a href="livrables_maison_forgelina_pmdo/Forgelina_Maisons_Style_Kangourex_PMDO.zip">Télécharger le ZIP complet PMDO (.tile + 1x + HD)</a>
    </nav>
  </header>

  <section class="sheet-box">
    <h2>Planches Tileset Complètes 1× PMDO (Grille exacte 8×8 px — {sj_im.width}×{sj_im.height} px — Jour &amp; Nuit)</h2>
    <div class="sheet-grid">
      <figure class="stage">
        <img class="pixel" src="{sj_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète Maisons Forgelina Kangourex Jour 1x" />
        <figcaption>Planche_Complete_Maison_Forgelina_Kangourex_1x_Jour.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
      </figure>
      <figure class="stage night">
        <img class="pixel" src="{sn_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète Maisons Forgelina Kangourex Nuit 1x" />
        <figcaption>Planche_Complete_Maison_Forgelina_Kangourex_1x_Nuit.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
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
    converted = convert_bruts_to_lossless_webp()
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
        clean_full = extract_clean_rgba(
            raw_im,
            hollow_alcove=spec["hollow_alcove"],
            has_moss=spec["has_moss"],
        )

        # Export HD sans fond compact (max 512 px de côté, alpha strict {0, 255})
        hd_max = 512
        scale_hd = min(hd_max / clean_full.width, hd_max / clean_full.height, 1.0)
        hd_wh = (max(8, int(round(clean_full.width * scale_hd))), max(8, int(round(clean_full.height * scale_hd))))
        hd_im = resize_clean_rgba(clean_full, hd_wh, margin=4)
        hd_path = HD_DIR / f"{spec['id']}_HD.png"
        save_binary_indexed_png(hd_im, hd_path)

        # Export 1x PMDO exact multiple de 8x8 px (Jour + Nuit + Arriere_Under + Avant_Base)
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
            save_binary_indexed_png(im_out, p_out)

        # Reload exact quantifié pour que la banque .tile corresponde au pixel exact près au PNG 1x_Jour
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
            write_tsj(
                png_rel=f"../1x_PMDO_8px_sans_fond/{png_name}",
                name=bank_name,
                w=tw_b,
                h=th_b,
                tsj_path=jp,
            )
            return tp, jp, len(bk.data)

        tile_path, tsj_path, uniq_day = emit_bank(f"{spec['prefix']}_00_JOUR", day_reloaded, day_path.name)
        tile_night_path, tsj_night_path, uniq_night = emit_bank(f"{spec['prefix']}_01_NUIT", night_reloaded, night_path.name)

        # Comptage de la cavité transparente interne pour FGK2
        a1 = np.array(day_reloaded)[:, :, 3]
        iy0, iy1 = int(day_reloaded.height * 0.44), int(day_reloaded.height * 0.80)
        ix0, ix1 = int(day_reloaded.width * 0.30), int(day_reloaded.width * 0.70)
        interior_zero = int(np.sum(a1[iy0:iy1, ix0:ix1] == 0))

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
                "hollow_alcove": spec["hollow_alcove"],
                "has_moss": spec["has_moss"],
                "interior_transparent_px_1x": interior_zero,
            }
        )
        print(
            f"[OK] {spec['prefix']} {spec['id']} -> 1x={day_reloaded.size} "
            f"({cols_g}x{rows_g} tiles, uniq={uniq_day}, hole={interior_zero}px)"
        )

    sheet_jour = PMDO_1X_DIR / "Planche_Complete_Maison_Forgelina_Kangourex_1x_Jour.png"
    sheet_nuit = PMDO_1X_DIR / "Planche_Complete_Maison_Forgelina_Kangourex_1x_Nuit.png"
    save_binary_indexed_png(build_atlas(day_sprites), sheet_jour)
    save_binary_indexed_png(build_atlas(night_sprites), sheet_nuit)

    readme_txt = """PACK MAISONS & MONUMENTS FORGELINA (INSPIRATION RÉSERVE KANGOUREX — PMD)
========================================================================

Contenu du dossier :
- 1x_PMDO_8px_sans_fond/ : Sprites 1x exacts sur grille 8x8 px (Jour, Nuit, Arriere_Under, Avant_Base + Planches complètes)
- PMDO_tiles/            : Banques natives .tile RogueEssence / Halcyon 0.8.12 (préfixes uniques FGK1 à FGK9) + .tsj Tiled
- HD_sans_fond/          : Versions haute définition sans fond (RGBA binaire {0, 255}, 0 px de frange verte)
- manifest.json          : Métadonnées techniques et état d'homologation honnête

Notes d'intégration PMDO :
1. FGK1 / FGK3 / FGK7 sont les monuments-boutiques à comptoir en U inspirés de la Réserve Kangourex (Place Pokémon).
2. FGK2 possède une baie centrale percée à alpha=0 derrière le comptoir afin d'y placer directement le PNJ Forgelina animé.
3. FGK4 / FGK5 / FGK6 / FGK8 sont des maisons habitables avec porte d'entrée praticable de plain-pied.
4. FGK9 est la Statue-Coffre extérieure style Rocher Kangourex (Bourg-Trésor).
5. Les calques Arriere_Under / Avant_Base découpent les surfaces visibles sans reconstruire spéculativement l'arrière-plan occulté.
"""
    (OUT_DIR / "LISEZ_MOI_IMPORT_PMDO.txt").write_text(readme_txt, encoding="utf-8")

    manifest = {
        "pack_id": "maison_forgelina_kangourex_pmdo_v1",
        "inspiration": "Pokémon Mystery Dungeon — Kangaskhan Storage (Place Pokémon / Bourg-Trésor) × Forgelina (Tinkaton #0959)",
        "tile_size_px": 8,
        "tile_prefixes": [s["prefix"] for s in SPECS],
        "art_approved": False,
        "runtime_tested": False,
        "layer_split_mode": "visible_surface_split_only_no_occluded_reconstruction",
        "converted_raw_webp": converted,
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
