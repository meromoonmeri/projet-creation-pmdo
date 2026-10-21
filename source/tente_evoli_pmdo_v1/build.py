#!/usr/bin/env python3
"""
Pipeline de construction PMDO 0.8.12 / Halcyon — Pack Tentes & Boutique Évoli (#0133 Eevee)
Inspiration officielle Pokémon Donjon Mystère : Explorateurs du Ciel (Bourg-Trésor / Treasure Town & Arcanine Hut).

Contraintes artistiques et techniques vérifiées automatiquement :
- ZÉRO bouche et ZÉRO museau sur 100 % des structures
- Yeux-fenêtres à croisillons en bois (X / + / *) fidèles aux tentes de Bourg-Trésor (EVT1, EVT2, EVT3)
  + déclinaisons 100 % toile cousue sans yeux (EVT4, EVT5) + bannière sur poteau bois (EVT6)
- Détourage complet extérieur + percement automatique alpha=0 de la baie centrale des tentes-boutiques (EVT2, EVT5)
- Alpha strictement binaire {0, 255}, 0 px de frange verte résiduelle, dimensions multiples exacts de 8x8 px
- Banques natives .tile RogueEssence / Halcyon (préfixes uniques EVT1..EVT6, Jour & Nuit) + .tsj Tiled
- Galerie HTML pure <img> RGBA alpha=0 (zéro <canvas>, zéro damier)
"""

from __future__ import annotations

import base64
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

MOD_DIR = ROOT / "source" / "tente_evoli_pmdo_v1"
BRUTS_DIR = MOD_DIR / "bruts"
OUT_DIR = ROOT / "livrables_tente_evoli_pmdo"
HD_DIR = OUT_DIR / "HD_sans_fond"
PMDO_1X_DIR = OUT_DIR / "1x_PMDO_8px_sans_fond"
TILE_DIR = OUT_DIR / "PMDO_tiles"
HTML_PREVIEW = ROOT / "apercu_tente_evoli_pmdo.html"
ZIP_PATH = OUT_DIR / "Evoli_Tentes_BourgTresor_PMDO.zip"

SPECS = [
    {
        "prefix": "EVT1",
        "id": "01_Evoli_Tente_Ronde_Croisillons_Bourg_Tresor",
        "raw": "ev_01_tente_evoli_fermee_croisillons",
        "title": "Tente d'Habitation Évoli — Fenêtres à Croisillons (Style Bourg-Trésor)",
        "category": "Tente Habitable PMD Sky (Croisillons · Sans Bouche ni Museau)",
        "target_1x": (144, 136),
        "is_open_booth": False,
        "split_row_ratio": 0.65,
        "desc": "Dôme en toile cousue caramel-cannelle, grandes oreilles d'Évoli, houppette crème, deux hublots sombres à croisillons de bois (style Bourg-Trésor, zéro pupille, zéro bouche, zéro museau), collerette molletonnée crème, pans relevés, piquets bois et queue touffue.",
    },
    {
        "prefix": "EVT2",
        "id": "02_Evoli_Tente_Boutique_Croisillons_Comptoir_Alpha0",
        "raw": "ev_02_tente_boutique_evoli_comptoir_croisillons",
        "title": "Tente-Boutique Ouverte Évoli — Croisillons & Comptoir U (Baie α=0)",
        "category": "Kiosque-Boutique PMD Sky (Baie Percée α=0 · Sans Bouche ni Museau)",
        "target_1x": (144, 144),
        "is_open_booth": True,
        "split_row_ratio": 0.66,
        "desc": "Modèle exact des stands de Bourg-Trésor / Arcanine Hut : auvent Évoli à deux fenêtres ovales à croisillons X en bois (zéro bouche, zéro museau), collerette crème dentelée, trépieds en bois cordés, comptoir en U garni de baies sur tapis tissé et ouverture centrale percée à alpha=0.",
    },
    {
        "prefix": "EVT3",
        "id": "03_Evoli_Grande_Tente_Guilde_Croisillons_Porche",
        "raw": "ev_03_tente_guilde_evoli_treasure_town",
        "title": "Grande Tente Conique Évoli — Croisillons & Porche Bois (Style Guilde)",
        "category": "Grande Tente PMD Sky (Croisillons · Sans Bouche ni Museau)",
        "target_1x": (144, 144),
        "is_open_booth": False,
        "split_row_ratio": 0.65,
        "desc": "Tente haute conique dans la lignée de la Tente Grodoudou / Boutique Élekable de Bourg-Trésor : oreilles d'Évoli au sommet, deux hublots ronds à croisillons + en bois, large collerette crème, porche charpenté en rondins, cordages tendus et queue touffue.",
    },
    {
        "prefix": "EVT4",
        "id": "04_Evoli_Tente_Cousue_Sans_Yeux_Sans_Visage",
        "raw": "ev_04_tente_evoli_pure_sans_visage",
        "title": "Tente Cousue Évoli — Version Pure Toile Sans Yeux",
        "category": "Tente Habitable PMD Sky (100 % Sans Visage)",
        "target_1x": (144, 136),
        "is_open_booth": False,
        "split_row_ratio": 0.65,
        "desc": "Variante 100 % architecture textile sans yeux, sans museau et sans bouche : couture centrale apparente, oreilles d'Évoli, collerette capitonnée crème, rideaux noués, haubans et queue touffue.",
    },
    {
        "prefix": "EVT5",
        "id": "05_Evoli_Tente_Boutique_Pure_Sans_Visage_Alpha0",
        "raw": "ev_05_boutique_evoli_sans_visage",
        "title": "Tente-Boutique Ouverte Évoli — Version Pure Toile Sans Yeux (Baie α=0)",
        "category": "Kiosque-Boutique PMD Sky (100 % Sans Visage · Baie Percée α=0)",
        "target_1x": (144, 144),
        "is_open_booth": True,
        "split_row_ratio": 0.66,
        "desc": "Variante boutique-comptoir 100 % sans yeux, sans museau et sans bouche : auvent caramel lisse à collerette crème, trépieds en rondins, comptoir bois en U et baie centrale percée à alpha=0.",
    },
    {
        "prefix": "EVT6",
        "id": "06_Evoli_Banniere_Poteau_Bois_Bourg_Tresor",
        "raw": "ev_06_banniere_poteau_evoli_pmd",
        "title": "Bannière sur Poteau Bois Évoli (Accessoire Bourg-Trésor)",
        "category": "Accessoire de Campement / Signalétique PMDO",
        "target_1x": (64, 88),
        "is_open_booth": False,
        "split_row_ratio": 0.60,
        "desc": "Poteau directionnel / enseigne de tente en bois sculpté (sommet oreilles d'Évoli & collerette crème, fanion caramel bordé de fourrure crème à empreinte).",
    },
]


def convert_bruts_to_lossless_webp() -> List[Dict]:
    converted = []
    for png_path in sorted(BRUTS_DIR.glob("ev_*.png")):
        webp_path = png_path.with_suffix(".webp")
        im = Image.open(png_path).convert("RGB")
        im.save(webp_path, "WEBP", lossless=True, method=6)
        png_path.unlink()
        converted.append({"webp": str(webp_path.relative_to(ROOT)), "bytes": webp_path.stat().st_size, "size": im.size})
    return converted


def extract_clean_rgba(im_rgb: Image.Image) -> Image.Image:
    """Détourage complet du fond et des ouvertures internes #00FF00 (tentes caramel/crème sans aucun vert propre)."""
    arr = np.array(im_rgb.convert("RGB"), dtype=np.int16)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]

    # Sur la palette caramel/crème/chocolat d'Évoli, tout pixel vert #00FF00 (externe OU baie interne) vérifie G - max(R,B) > 36
    bg = (g > 135) & ((g - np.maximum(r, b)) > 36)

    # Érosion du halo d'anti-aliasing sur 2 passes autour des pixels transparents
    for _ in range(2):
        dil = (
            np.pad(bg[1:, :], ((0, 1), (0, 0)), constant_values=True)
            | np.pad(bg[:-1, :], ((1, 0), (0, 0)), constant_values=True)
            | np.pad(bg[:, 1:], ((0, 0), (0, 1)), constant_values=True)
            | np.pad(bg[:, :-1], ((0, 0), (1, 0)), constant_values=True)
        )
        bg |= dil & (~bg) & ((g - np.maximum(r, b)) > 14) & (g > 90)

    out = np.zeros((arr.shape[0], arr.shape[1], 4), dtype=np.uint8)
    max_rb = np.maximum(r, b)
    clean_g = np.where(g > max_rb, max_rb, g)
    out[:, :, 0] = np.clip(r, 0, 255).astype(np.uint8)
    out[:, :, 1] = np.clip(clean_g, 0, 255).astype(np.uint8)
    out[:, :, 2] = np.clip(b, 0, 255).astype(np.uint8)
    out[:, :, 3] = np.where(bg, 0, 255).astype(np.uint8)
    out[bg] = (0, 0, 0, 0)

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
    ng = np.clip(g * 0.59 + 16.0, 0, 255)
    nb = np.clip(b * 0.80 + 36.0, 0, 255)

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

    pal = np.array(q.getpalette()[: 255 * 3], dtype=np.int32).reshape(255, 3)
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
    cols = 3
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
        badge_extra = (
            f'<span class="badge accent">Baie percée α=0 ({rec["interior_transparent_px_1x"]} px)</span>'
            if rec["is_open_booth"]
            else '<span class="badge">Zéro bouche · Zéro museau · Frange 0 px</span>'
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
            {badge_extra}
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
  <title>Tentes &amp; Kiosques Évoli (#0133) — Style PMD Explorateurs du Ciel (Bourg-Trésor) — Pack PMDO Sans Fond</title>
  <style>
    :root {{
      --bg: #221c17;
      --panel: #2d251e;
      --stage: #3a3028;
      --stage-night: #1d2030;
      --line: #544437;
      --cream: #f6ecd6;
      --caramel: #d99f66;
      --ink: #f8f2e8;
      --muted: #cbbfae;
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
      max-width: 1380px;
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
      background: #3d3228;
      border: 1px solid var(--line);
      padding: 7px 13px;
      border-radius: 8px;
      text-decoration: none;
      font-size: 0.9rem;
    }}
    .nav-links a:hover {{ border-color: var(--caramel); color: var(--cream); }}
    .sheet-box h2 {{ margin: 0 0 12px; font-size: 1.2rem; color: var(--cream); }}
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
      background: #473628;
      color: var(--cream);
      border: 1px solid var(--caramel);
      border-radius: 6px;
      padding: 2px 9px;
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 0.82rem;
      font-weight: 700;
    }}
    .cat {{ font-size: 0.8rem; color: var(--muted); text-align: right; }}
    .card h2 {{ margin: 0; font-size: 1.06rem; color: #fffaf0; }}
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
    img.hd-view {{ max-height: 280px; width: auto; }}
    .meta-bar {{ display: flex; flex-wrap: wrap; gap: 8px; margin-top: auto; }}
    .badge {{
      font-size: 0.76rem;
      background: #3a2e25;
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 3px 10px;
      color: var(--muted);
    }}
    .badge.accent {{ border-color: var(--caramel); color: var(--cream); }}
  </style>
</head>
<body>
  <header>
    <h1>Tentes &amp; Kiosques Évoli (#0133) — Style PMD Explorateurs du Ciel (Bourg-Trésor)</h1>
    <p>
      6 structures et accessoires pixel-art 2D style Chunsoft DS : <strong>zéro bouche et zéro museau</strong> sur 100 % du pack,
      avec <strong>fenêtres-yeux à croisillons en bois</strong> comme les tentes officielles de <em>Bourg-Trésor</em> (<code>EVT1</code>–<code>EVT3</code>),
      variantes en toile cousue sans yeux (<code>EVT4</code>–<code>EVT5</code>) et poteau-bannière d’Évoli (<code>EVT6</code>).
    </p>
    <p>
      <strong>Zéro damier et zéro &lt;canvas&gt;</strong> : chaque visuel est une vraie balise <code>&lt;img&gt;</code> PNG <code>RGBA</code>
      à transparence réelle <code>alpha = 0</code> sur aplat neutre uni (<em>Clic droit → Enregistrer l’image sous…</em> conserve le PNG sans fond).
      Les découpes <code>Arriere_Under</code> / <code>Avant_Base</code> séparent uniquement les surfaces visibles sans reconstruire les pixels occultés.
    </p>
    <nav class="nav-links">
      <a href="/">← Accueil des aperçus</a>
      <a href="apercu_maison_forgelina_pmdo.html">Voir aussi : Maison / Monument Forgelina (Style Kangourex — FGK1–FGK6)</a>
      <a href="apercu_tentes_huttes_forgelina_pmdo.html">Voir aussi : Pack 11 Tentes &amp; Huttes Forgelina (FGH1–FGHB)</a>
      <a href="livrables_tente_evoli_pmdo/Evoli_Tentes_BourgTresor_PMDO.zip">Télécharger le ZIP complet PMDO (.tile + 1x + HD)</a>
    </nav>
  </header>

  <section class="sheet-box">
    <h2>Planches Tileset Complètes 1× PMDO (Grille exacte 8×8 px — {sj_im.width}×{sj_im.height} px — Jour &amp; Nuit)</h2>
    <div class="sheet-grid">
      <figure class="stage">
        <img class="pixel" src="{sj_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète Tentes Évoli Jour 1x" />
        <figcaption>Planche_Complete_Tentes_Evoli_PMDO_1x_Jour.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
      </figure>
      <figure class="stage night">
        <img class="pixel" src="{sn_uri}" width="{sj_im.width}" height="{sj_im.height}" alt="Planche complète Tentes Évoli Nuit 1x" />
        <figcaption>Planche_Complete_Tentes_Evoli_PMDO_1x_Nuit.png ({sj_im.width}×{sj_im.height} px — vrai RGBA alpha=0)</figcaption>
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
        clean_full = extract_clean_rgba(raw_im)

        hd_max = 448
        scale_hd = min(hd_max / clean_full.width, hd_max / clean_full.height, 1.0)
        hd_wh = (max(8, int(round(clean_full.width * scale_hd))), max(8, int(round(clean_full.height * scale_hd))))
        hd_im = resize_clean_rgba(clean_full, hd_wh, margin=4)
        hd_path = HD_DIR / f"{spec['id']}_HD.png"
        save_binary_indexed_png(hd_im, hd_path)

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

        a1 = np.array(day_reloaded)[:, :, 3]
        iy0, iy1 = int(day_reloaded.height * 0.56), int(day_reloaded.height * 0.76)
        ix0, ix1 = int(day_reloaded.width * 0.34), int(day_reloaded.width * 0.66)
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
                "is_open_booth": spec["is_open_booth"],
                "interior_transparent_px_1x": interior_zero,
            }
        )
        print(
            f"[OK] {spec['prefix']} {spec['id']} -> 1x={day_reloaded.size} "
            f"({cols_g}x{rows_g} tiles, uniq={uniq_day}, hole={interior_zero}px)"
        )

    sheet_jour = PMDO_1X_DIR / "Planche_Complete_Tentes_Evoli_PMDO_1x_Jour.png"
    sheet_nuit = PMDO_1X_DIR / "Planche_Complete_Tentes_Evoli_PMDO_1x_Nuit.png"
    save_binary_indexed_png(build_atlas(day_sprites), sheet_jour)
    save_binary_indexed_png(build_atlas(night_sprites), sheet_nuit)

    readme_txt = """PACK TENTES & KIOSQUES ÉVOLI (#0133) — STYLE PMD EXPLORATEURS DU CIEL (BOURG-TRÉSOR)
====================================================================================

Contenu :
- 1x_PMDO_8px_sans_fond/ : Sprites 1x exacts sur grille 8x8 px (Jour, Nuit, Arriere_Under, Avant_Base + Planches complètes)
- PMDO_tiles/            : Banques natives .tile RogueEssence / Halcyon 0.8.12 (EVT1 à EVT6, Jour & Nuit) + .tsj Tiled
- HD_sans_fond/          : PNG haute définition sans fond (alpha binaire strict {0, 255}, 0 px de frange verte)
- manifest.json          : Métadonnées techniques et état d'homologation honnête

Règles artistiques & techniques :
- Zéro bouche et zéro museau sur 100 % des tentes.
- EVT1 / EVT2 / EVT3 : fenêtres-yeux sombres à croisillons en bois (X / + / *) fidèles à Bourg-Trésor.
- EVT4 / EVT5 : variantes pure toile cousue sans yeux.
- EVT2 / EVT5 : baie centrale percée à alpha=0 derrière le comptoir en U pour y placer directement un PNJ Évoli.
- Arriere_Under / Avant_Base : séparation stricte des surfaces visibles sans reconstruction spéculative des pixels occultés.
"""
    (OUT_DIR / "LISEZ_MOI_IMPORT_PMDO.txt").write_text(readme_txt, encoding="utf-8")

    manifest = {
        "pack_id": "tente_evoli_bourg_tresor_pmdo_v1",
        "inspiration": "Pokémon Mystery Dungeon: Explorers of Sky (Treasure Town / Bourg-Trésor & Arcanine Hut) × Évoli (Eevee #0133)",
        "tile_size_px": 8,
        "tile_prefixes": [s["prefix"] for s in SPECS],
        "no_mouth": True,
        "no_snout": True,
        "lattice_crossbar_windows": ["EVT1", "EVT2", "EVT3"],
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
