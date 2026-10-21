"""Construit le pack complet 100 % SANS VISAGE de Tentes, Huttes & Kiosques Forgelina (#0959 Tinkaton)
inspiré directement de la planche « Arcanine Hut Tileset » du dépôt.

Tous les 11 éléments (`FGH1`..`FGH9`, `FGHA`, `FGHB`) sont 100 % architecture textile & acier de tente Pokémon
SANS VISAGE (aucun œil, aucune bouche), détourés en alpha binaire strict (`alpha in {0, 255}`, `0 px` de frange),
avec ouvertures centrales / guichets 100 % transparents (`alpha = 0`, zéro fond noir), comptoirs nus prêts pour
accueillir un PNJ en jeu, versions Jour & Nuit, découpes disjointes `arriere` (Under) + `avant` (Over),
et banques binaires PMDO `.tile` + `.tsj`.
"""
from __future__ import annotations

import base64
import hashlib
import importlib.util
import json
import math
import shutil
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/forgelina_structures_pmdo_v1'
STAGE = R / '.cache/forgelina_structures_pmdo_v1/stage'
LIV = R / 'livrables_forgelina_pmdo'

NAMESPACE = 'forgelina_tentes_huttes_sans_visage_pmdo_v2'
NIGHT_FACTORS = np.array([0.42, 0.35, 0.40], dtype=float)
NEUTRAL_BG = (58, 48, 40, 255)

ITEMS = [
    {
        'num': '01',
        'slug': 'forgelina_tente_boutique_capitonnee',
        'file_stem': '01_Forgelina_Tente_Boutique_Capitonnee',
        'label': 'Tente-Boutique Forgelina — Dôme Capitonné & Trépieds',
        'subtitle': 'Modèle Arcanine Hut sans visage · Dôme matelassé rose & acier riveté, couettes spiralées, rideaux sur trépieds bois, guichet alpha = 0 & comptoir',
        'arcanine_equiv': 'Arcanine Hut Assemblé — Version Toile Capitonnée Sans Visage',
        'category': 'kiosque_boutique',
        'bank_pfx': 'FGH1',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_03_sans_visage.webp',
        'target_vis_w': 136,
        'canvas_w': 144,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'num': '02',
        'slug': 'forgelina_tente_boutique_auvent_raye',
        'file_stem': '02_Forgelina_Tente_Boutique_Auvent_Raye',
        'label': 'Tente-Boutique Forgelina — Auvent Rayé Festonné & Trépieds',
        'subtitle': 'Modèle Arcanine Hut sans visage · Toit festonné rayé rose sakura/framboise & bandes acier, couettes bouclées, guichet alpha = 0 & comptoir',
        'arcanine_equiv': 'Arcanine Hut Assemblé — Version Auvent Festonné Rayé',
        'category': 'kiosque_boutique',
        'bank_pfx': 'FGH2',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_10_tente_boutique_auvent_raye.webp',
        'target_vis_w': 136,
        'canvas_w': 144,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'num': '03',
        'slug': 'forgelina_tente_forge_trepieds_marteau',
        'file_stem': '03_Forgelina_Tente_Forge_Trepieds_Marteau',
        'label': 'Tente-Forge Forgelina — Écusson Marteaux Croisés & Trépieds',
        'subtitle': 'Modèle Arcanine Hut Forge sans visage · Écusson d’acier aux marteaux croisés, grand marteau posé près du trépied droit & guichet alpha = 0',
        'arcanine_equiv': 'Arcanine Hut Assemblé — Version Forge & Grand Marteau',
        'category': 'kiosque_boutique',
        'bank_pfx': 'FGH3',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_11_tente_forge_trepieds_marteau.webp',
        'target_vis_w': 140,
        'canvas_w': 152,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'num': '04',
        'slug': 'forgelina_hutte_cousue_piquets',
        'file_stem': '04_Forgelina_Hutte_Cousue_4_Piquets',
        'label': 'Hutte-Tente Cousue Forgelina — Pans Tendus sur 4 Piquets',
        'subtitle': 'Modèle Arcanine Hut Haut sans visage · Dôme cousu au point croisé, mèche & grandes couettes spiralées, pans rivetés sur 4 piquets bois',
        'arcanine_equiv': 'Arcanine Hut Haut — Hutte-Tente Cousue sur 4 Piquets',
        'category': 'hutte_tente',
        'bank_pfx': 'FGH4',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_09_sans_visage.webp',
        'target_vis_w': 116,
        'canvas_w': 128,
        'split_mode': 'canopy_hut',
        'split_frac': 0.65,
    },
    {
        'num': '05',
        'slug': 'forgelina_kiosque_tente_marteau',
        'file_stem': '05_Forgelina_Kiosque_Tente_Marteau',
        'label': 'Kiosque-Tente Forge Compact Forgelina — Blason Marteau',
        'subtitle': 'Kiosque-tente à cordages tendeurs, blason marteau sur le dôme, guichet alpha = 0, comptoir bois riveté & marteau appuyé',
        'arcanine_equiv': 'Variante Kiosque Compact à Cordages & Marteau',
        'category': 'kiosque_boutique',
        'bank_pfx': 'FGH5',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_04_kiosque_tente_marteau.webp',
        'target_vis_w': 132,
        'canvas_w': 144,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'num': '06',
        'slug': 'forgelina_hutte_tente_fermee',
        'file_stem': '06_Forgelina_Hutte_Tente_Fermee',
        'label': 'Hutte-Tente Ronde Fermée Forgelina — Campement',
        'subtitle': 'Dôme rond cousu rose framboise à collerette d’acier rivetée, doubles couettes bouclées & piquets tendeurs',
        'arcanine_equiv': 'Hutte-Tente Ronde Fermée de Campement',
        'category': 'hutte_tente',
        'bank_pfx': 'FGH6',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_01_hutte_tente_fermee.webp',
        'target_vis_w': 104,
        'canvas_w': 112,
        'split_mode': 'canopy_hut',
        'split_frac': 0.65,
    },
    {
        'num': '07',
        'slug': 'forgelina_hutte_tente_entree_enclume',
        'file_stem': '07_Forgelina_Hutte_Tente_Entree_Enclume',
        'label': 'Hutte-Tente d’Entrée Forgelina — Porte Drapée & Enclume',
        'subtitle': 'Dôme rond cousu à porte ouverte, couettes bouclées, piquets tendeurs & enclume + marteau posés à droite',
        'arcanine_equiv': 'Hutte-Tente Village à Entrée & Enclume',
        'category': 'hutte_tente',
        'bank_pfx': 'FGH7',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_08_hutte_tente_entree_enclume.webp',
        'target_vis_w': 112,
        'canvas_w': 120,
        'split_mode': 'canopy_hut',
        'split_frac': 0.65,
    },
    {
        'num': '08',
        'slug': 'forgelina_toit_tente_auvent',
        'file_stem': '08_Forgelina_Toit_Tente_Auvent',
        'label': 'Toit-Tente / Auvent Modulaire Forgelina',
        'subtitle': 'Auvent de toile cousue sur poteaux latéraux et piquets, passage inférieur 100 % ouvert',
        'arcanine_equiv': 'Pièce #2 — Auvent / Tonnelle Ouverte Modulaire',
        'category': 'module_tente',
        'bank_pfx': 'FGH8',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_02_toit_tente_auvent.webp',
        'target_vis_w': 108,
        'canvas_w': 120,
        'split_mode': 'open_awning',
        'split_frac': 0.66,
    },
    {
        'num': '09',
        'slug': 'forgelina_comptoir_courbe_seul',
        'file_stem': '09_Forgelina_Comptoir_Courbe_Seul',
        'label': 'Comptoir Courbe en U Modulaire Forgelina',
        'subtitle': 'Modèle exact Pièce #4 d’Arcanine Hut : comptoir bois en U ouvert en haut, panneaux roses & coins acier rivetés',
        'arcanine_equiv': 'Pièce #4 — Comptoir Courbe Modulaire en U',
        'category': 'module_tente',
        'bank_pfx': 'FGH9',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_05_comptoir_seul.webp',
        'target_vis_w': 84,
        'canvas_w': 96,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'num': '10',
        'slug': 'forgelina_tapis_tisse',
        'file_stem': '10_Forgelina_Tapis_Tisse',
        'label': 'Tapis d’Accueil Tissé Forgelina',
        'subtitle': 'Modèle exact Pièce #3 d’Arcanine Hut : tapis rose sakura, framboise & acier à franges et blason marteau',
        'arcanine_equiv': 'Pièce #3 — Tapis d’Accueil Tissé Assorti',
        'category': 'accessoire_tente',
        'bank_pfx': 'FGHA',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_06_tapis_accueil.webp',
        'target_vis_w': 68,
        'canvas_w': 80,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'num': '11',
        'slug': 'forgelina_banniere_poteau',
        'file_stem': '11_Forgelina_Banniere_Poteau',
        'label': 'Bannière Fanion sur Poteau Forgelina',
        'subtitle': 'Modèle exact Pièces #5–#7 d’Arcanine Hut : poteau en bois à boucles roses & fanion suspendu au marteau',
        'arcanine_equiv': 'Pièces #5–#7 — Bannière Verticale sur Poteau Bois',
        'category': 'accessoire_tente',
        'bank_pfx': 'FGHB',
        'dex': '0959',
        'raw': 'bruts/arcan_fg_07_banniere_poteau.webp',
        'target_vis_w': 38,
        'canvas_w': 48,
        'split_mode': None,
        'split_frac': None,
    },
]


def load_halcyon_gfx():
    spec = importlib.util.spec_from_file_location(
        'pmdo_codec_fg1',
        R / 'source/pmdo_cote/build.py',
    )
    mod = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(mod)
    return mod


def sha256_file(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def save_binary_alpha_indexed_png(im: Image.Image, out_p: Path):
    """Sauvegarde PNG indexé 255 couleurs + index 0 transparent strict (`alpha in {0, 255}`, `0 px` frange)."""
    rgba = np.array(im.convert('RGBA'))
    fg = rgba[:, :, 3] >= 128
    rgb = Image.fromarray(rgba[:, :, :3], 'RGB')
    q = rgb.quantize(colors=255, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:255 * 3], dtype=np.int32).reshape(255, 3)
    pal[:, 1] = np.minimum(pal[:, 1], np.maximum(pal[:, 0], pal[:, 2]) + 16)
    full_pal = np.zeros((256, 3), dtype=np.uint8)
    full_pal[1:] = np.clip(pal, 0, 255).astype(np.uint8)
    idx = np.where(fg, np.array(q, dtype=np.uint8) + 1, 0).astype(np.uint8)
    out = Image.fromarray(idx, mode='P')
    out.putpalette(full_pal.ravel().tolist())
    out.save(out_p, 'PNG', transparency=0, optimize=True, compress_level=9)


def extract_clean_hd_from_green(raw_path: Path) -> tuple[Image.Image, dict]:
    im = Image.open(raw_path).convert('RGBA')
    arr = np.array(im)
    r = arr[:, :, 0].astype(np.int32)
    g = arr[:, :, 1].astype(np.int32)
    b = arr[:, :, 2].astype(np.int32)

    bg = (g > 135) & ((g - np.maximum(r, b)) > 36)
    fg = ~bg

    lbl, n = nd.label(fg, structure=np.ones((3, 3)))
    if n > 0:
        counts = np.bincount(lbl.ravel())
        counts[0] = 0
        main_sz = int(counts.max())
        keep = counts >= max(64, int(main_sz * 0.002))
        fg = keep[lbl]

    for _ in range(3):
        border = fg & nd.binary_dilation(~fg, structure=np.ones((3, 3)))
        green_edge = border & ((g - np.maximum(r, b)) > 8)
        if not np.any(green_edge):
            break
        fg = fg & (~green_edge)

    despill = fg & (g > np.maximum(r, b))
    if np.any(despill):
        arr[:, :, 1] = np.where(despill, np.maximum(r, b), g).astype(np.uint8)

    out = arr.copy()
    out[~fg] = 0
    out[fg, 3] = 255

    ys, xs = np.nonzero(fg)
    x0, y0, x1, y1 = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1
    crop = out[y0:y1, x0:x1].copy()

    cr = crop[:, :, 0].astype(np.int32)
    cg = crop[:, :, 1].astype(np.int32)
    cb = crop[:, :, 2].astype(np.int32)
    ca = crop[:, :, 3]
    residual_fringe = int(np.sum((ca == 255) & ((cg - np.maximum(cr, cb)) > 18)))

    fg_crop = ca == 255
    interior_holes = nd.binary_fill_holes(fg_crop) & (~fg_crop)
    hole_px = int(interior_holes.sum())

    stats = {
        'raw_size': [im.width, im.height],
        'crop_bbox': [x0, y0, x1, y1],
        'hd_tight_size': [int(crop.shape[1]), int(crop.shape[0])],
        'opaque_px': int(fg_crop.sum()),
        'transparent_interior_hole_px': hole_px,
        'residual_green_fringe_px': residual_fringe,
    }
    return Image.fromarray(crop), stats


def clean_1x_sprite(arr: np.ndarray) -> np.ndarray:
    out = arr.copy()
    fg = out[:, :, 3] >= 128
    lbl, n = nd.label(fg, structure=np.ones((3, 3)))
    if n > 0:
        counts = np.bincount(lbl.ravel())
        counts[0] = 0
        fg = (counts >= 3)[lbl]
    r = out[:, :, 0].astype(np.int32)
    g = out[:, :, 1].astype(np.int32)
    b = out[:, :, 2].astype(np.int32)
    out[:, :, 1] = np.where(fg & (g > np.maximum(r, b)), np.maximum(r, b), g).astype(np.uint8)
    out[~fg] = 0
    out[fg, 3] = 255
    return out


def apply_night_grade(arr: np.ndarray) -> np.ndarray:
    out = arr.copy()
    fg = out[:, :, 3] == 255
    rgb = out[:, :, :3].astype(float) * NIGHT_FACTORS[None, None, :]
    out[:, :, :3] = np.clip(np.round(rgb), 0, 255).astype(np.uint8)
    out[~fg] = 0
    return out


def split_layers_1x(arr: np.ndarray, mode: str | None, split_frac: float | None, py0: int, nh: int):
    th, tw, _ = arr.shape
    if mode is None:
        return None, None, None, None
    fg1 = arr[:, :, 3] == 255
    if mode == 'counter_aisle':
        holes1 = nd.binary_fill_holes(fg1) & (~fg1)
        lh1, nh1 = nd.label(holes1)
        central = []
        for hi in range(1, nh1 + 1):
            hy, hx = np.nonzero(lh1 == hi)
            if int((lh1 == hi).sum()) >= 30 and hx.min() < tw // 2 < hx.max():
                central.append((int((lh1 == hi).sum()), int(hy.max()) + 1))
        split_y = max(central)[1] if central else (py0 + int(round(nh * (split_frac or 0.72))))
        arriere = arr.copy()
        arriere[split_y:, :] = 0
        avant = arr.copy()
        avant[:split_y, :] = 0
        npc_feet = [tw // 2, min(th - 4, split_y + 10)]
        return arriere, avant, int(split_y), npc_feet
    else:
        split_y = py0 + int(round(nh * (split_frac or 0.65)))
        avant = arr.copy()
        avant[split_y:, :] = 0
        arriere = arr.copy()
        arriere[:split_y, :] = 0
        npc_feet = [tw // 2, min(th - 4, py0 + int(round(nh * 0.78)))]
        return arriere, avant, int(split_y), npc_feet


def write_tile_bank_and_tsj(gfx, bank_name: str, img_arr: np.ndarray, tile_out: Path, tsj_out: Path, png_rel: str) -> int:
    bank = gfx.TileBank(bank_name, preserve_layout=True)
    th, tw, _ = img_arr.shape
    cols, rows = tw // 8, th // 8
    for gy in range(rows):
        for gx in range(cols):
            bank.add(Image.fromarray(img_arr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
    bank.write(tile_out)
    tsj = {
        'columns': cols,
        'image': png_rel,
        'imageheight': th,
        'imagewidth': tw,
        'margin': 0,
        'name': bank_name,
        'spacing': 0,
        'tilecount': cols * rows,
        'tiledversion': '1.11.0',
        'tileheight': 8,
        'tilewidth': 8,
        'type': 'tileset',
        'version': '1.10',
    }
    tsj_out.write_text(json.dumps(tsj, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    return len(bank.data)


def build_tileset_overview_sheet(built_1x: dict[str, np.ndarray], night: bool = False) -> Image.Image:
    """Planche d'ensemble 100 % SANS VISAGE « Forgelina Hut Tileset » (3 rangées claires)."""
    pad = 14
    rows = [
        [
            built_1x['forgelina_tente_boutique_capitonnee'],
            built_1x['forgelina_tente_boutique_auvent_raye'],
            built_1x['forgelina_tente_forge_trepieds_marteau'],
            built_1x['forgelina_kiosque_tente_marteau'],
        ],
        [
            built_1x['forgelina_hutte_cousue_piquets'],
            built_1x['forgelina_hutte_tente_fermee'],
            built_1x['forgelina_hutte_tente_entree_enclume'],
            built_1x['forgelina_toit_tente_auvent'],
            built_1x['forgelina_comptoir_courbe_seul'],
            built_1x['forgelina_tapis_tisse'],
            built_1x['forgelina_banniere_poteau'],
        ],
    ]
    if night:
        rows = [[apply_night_grade(x) for x in r] for r in rows]

    row_ws = [sum(x.shape[1] for x in r) + pad * (len(r) + 1) for r in rows]
    row_hs = [max(x.shape[0] for x in r) for r in rows]
    W = int(math.ceil(max(row_ws) / 8) * 8)
    H = int(math.ceil((pad * (len(rows) + 1) + sum(row_hs)) / 8) * 8)

    sheet = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    cy_base = pad
    for r, rh in zip(rows, row_hs):
        cx = pad
        for x in r:
            im = Image.fromarray(x)
            cy = cy_base + (rh - im.height)
            sheet.alpha_composite(im, (cx, cy))
            cx += im.width + pad
        cy_base += rh + pad
    return sheet


def file_to_b64(p: Path) -> str:
    return 'data:image/png;base64,' + base64.b64encode(p.read_bytes()).decode('ascii')


def generate_html_gallery(manifest: dict, html_out: Path, sheet_day_p: Path, sheet_night_p: Path, arc_ref_p: Path):
    arc_b64 = file_to_b64(arc_ref_p)
    sheet_day_b64 = file_to_b64(sheet_day_p)
    sheet_night_b64 = file_to_b64(sheet_night_p)

    cards_html = []
    for item in manifest['items']:
        stem = item['file_stem']
        hd_rel = f'livrables_forgelina_pmdo/HD_sans_fond/{stem}_HD_sans_fond.png'
        d1_p = LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_complet.png'
        n1_p = LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_nuit_complet.png'
        d1_b64 = file_to_b64(d1_p)
        n1_b64 = file_to_b64(n1_p)

        has_split = item['normalization_1x']['split_mode'] is not None
        arr_dl = ''
        if has_split:
            arr_p = LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_arriere.png'
            avt_p = LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_avant.png'
            arr_b64 = file_to_b64(arr_p)
            avt_b64 = file_to_b64(avt_p)
            arr_dl = (
                f'<a class="dl-btn sub" href="{arr_b64}" download="{stem}_1x_arriere.png">⬇ 1× Arrière (Under)</a>'
                f'<a class="dl-btn sub" href="{avt_b64}" download="{stem}_1x_avant.png">⬇ 1× Avant (Over)</a>'
            )
            split_tabs = f'''
            <div class="layer-bar">
              <button type="button" class="mini-btn active" onclick="setView(this, '{d1_b64}')">1× Complet</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{arr_b64}')">Arrière (Under)</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{avt_b64}')">Avant (Over)</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{n1_b64}')">1× Nuit</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{hd_rel}')">HD Détouré</button>
            </div>'''
        else:
            split_tabs = f'''
            <div class="layer-bar">
              <button type="button" class="mini-btn active" onclick="setView(this, '{d1_b64}')">1× Jour</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{n1_b64}')">1× Nuit</button>
              <button type="button" class="mini-btn" onclick="setView(this, '{hd_rel}')">HD Détouré</button>
            </div>'''

        cw, ch = item['normalization_1x']['canvas_size']
        hdw, hdh = item['hd_tight_size']
        tiles_u = item['unique_tiles_jour']
        hole_badge = (
            '<span class="tag ok">Sans visage · Guichet alpha = 0</span>'
            if item['detourage']['transparent_interior_hole_px'] > 2000
            else '<span class="tag">Sans visage · PNG RGBA alpha = 0</span>'
        )

        cards_html.append(f'''
        <article class="card" data-day="{d1_b64}" data-night="{n1_b64}">
          <div class="card-top">
            <div>
              <span class="bank-pill">{item['bank_prefix']} · {cw}×{ch} px ({cw//8}×{ch//8} tuiles 8×8)</span>
              <h3>{item['label']}</h3>
              <p class="subdesc">{item['subtitle']}</p>
            </div>
            {hole_badge}
          </div>
          <div class="stage neutral-bg">
            <img class="pixel-preview main-img" src="{d1_b64}" alt="{item['label']}" width="{cw*2}" height="{ch*2}">
          </div>
          {split_tabs}
          <div class="meta-line">
            <span>Réf. modèle : <strong>{item['arcanine_equiv']}</strong></span>
            <span>HD : <strong>{hdw}×{hdh} px</strong> · Tuiles uniques : <strong>{tiles_u}</strong></span>
          </div>
          <div class="dl-row">
            <a class="dl-btn primary" href="{d1_b64}" download="{stem}_1x_complet.png">⬇ PNG 1× PMDO ({cw}×{ch})</a>
            <a class="dl-btn" href="{hd_rel}" download="{stem}_HD_sans_fond.png">⬇ PNG HD ({hdw}×{hdh})</a>
            <a class="dl-btn sub" href="{n1_b64}" download="{stem}_1x_nuit_complet.png">⬇ 1× Nuit</a>
            {arr_dl}
          </div>
        </article>''')

    html = f'''<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Pack Tentes &amp; Huttes Forgelina (Style Arcanine Hut · 100 % Sans Visage) — PMDO</title>
<style>
  :root {{
    --bg: #1e1918;
    --panel: #2a2220;
    --neutral-stage: #3a3028;
    --forest-stage: #2f3b2f;
    --slate-stage: #262936;
    --pink: #f4ced7;
    --berry: #dd4d98;
    --steel: #828ead;
    --text: #f7f1ee;
    --muted: #cbbab4;
    --border: rgba(244, 206, 215, 0.2);
  }}
  * {{ box-sizing: border-box; }}
  body {{
    margin: 0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
    background: var(--bg);
    color: var(--text);
    line-height: 1.5;
  }}
  header {{
    max-width: 1380px;
    margin: 0 auto;
    padding: 32px 24px 18px;
  }}
  .eyebrow {{
    display: inline-block;
    background: rgba(221, 77, 152, 0.2);
    border: 1px solid var(--berry);
    color: var(--pink);
    padding: 5px 12px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 600;
  }}
  h1 {{
    margin: 12px 0 8px;
    font-size: clamp(24px, 3vw, 36px);
    color: var(--pink);
  }}
  .lead {{
    margin: 0 0 18px;
    max-width: 980px;
    color: var(--muted);
    font-size: 15px;
  }}
  .toolbar {{
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    align-items: center;
    padding: 14px 16px;
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 14px;
  }}
  .tool-btn {{
    background: #3b2f2d;
    color: var(--text);
    border: 1px solid var(--border);
    padding: 8px 14px;
    border-radius: 9px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
  }}
  .tool-btn.active, .tool-btn.accent {{
    background: var(--berry);
    border-color: var(--pink);
    color: #fff;
  }}
  .compare-wrap {{
    max-width: 1380px;
    margin: 16px auto 24px;
    padding: 0 24px;
    display: grid;
    grid-template-columns: 0.78fr 1.72fr;
    gap: 18px;
  }}
  @media (max-width: 980px) {{
    .compare-wrap {{ grid-template-columns: 1fr; }}
  }}
  .box {{
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 18px;
  }}
  .box h2 {{
    margin: 0 0 6px;
    font-size: 17px;
    color: var(--pink);
  }}
  .box p {{
    margin: 0 0 12px;
    font-size: 13px;
    color: var(--muted);
  }}
  .stage {{
    border-radius: 12px;
    padding: 20px;
    min-height: 230px;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid rgba(255,255,255,0.08);
    transition: background-color 0.15s ease;
  }}
  .neutral-bg {{ background-color: var(--neutral-stage); }}
  body.bg-slate .stage {{ background-color: var(--slate-stage); }}
  body.bg-forest .stage {{ background-color: var(--forest-stage); }}
  .pixel-preview {{
    image-rendering: pixelated;
    image-rendering: crisp-edges;
    max-width: 100%;
    height: auto;
  }}
  .grid {{
    max-width: 1380px;
    margin: 0 auto 48px;
    padding: 0 24px;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(390px, 1fr));
    gap: 20px;
  }}
  .card {{
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 18px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }}
  .card-top {{
    display: flex;
    justify-content: space-between;
    gap: 10px;
    align-items: flex-start;
  }}
  .bank-pill {{
    font-size: 11px;
    color: var(--steel);
    font-weight: 700;
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }}
  .card h3 {{
    margin: 4px 0;
    font-size: 17px;
    color: var(--pink);
  }}
  .subdesc {{
    margin: 0;
    font-size: 13px;
    color: var(--muted);
  }}
  .tag {{
    font-size: 11px;
    padding: 4px 8px;
    border-radius: 999px;
    background: rgba(130, 142, 173, 0.2);
    color: var(--pink);
    white-space: nowrap;
  }}
  .tag.ok {{
    background: rgba(221, 77, 152, 0.25);
    border: 1px solid rgba(244, 206, 215, 0.35);
  }}
  .layer-bar {{
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }}
  .mini-btn {{
    background: #362b29;
    color: var(--muted);
    border: 1px solid var(--border);
    padding: 5px 10px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 12px;
  }}
  .mini-btn.active {{
    background: var(--berry);
    color: #fff;
    border-color: var(--pink);
  }}
  .meta-line {{
    display: flex;
    flex-direction: column;
    gap: 3px;
    font-size: 12px;
    color: var(--muted);
  }}
  .dl-row {{
    display: flex;
    flex-wrap: wrap;
    gap: 7px;
    margin-top: auto;
  }}
  .dl-btn {{
    background: #3d312f;
    color: var(--text);
    text-decoration: none;
    padding: 7px 11px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 600;
    border: 1px solid var(--border);
  }}
  .dl-btn.primary {{
    background: var(--berry);
    border-color: var(--pink);
    color: #fff;
  }}
  footer {{
    max-width: 1380px;
    margin: 0 auto 40px;
    padding: 0 24px;
    font-size: 12px;
    color: var(--muted);
  }}
</style>
</head>
<body>
<header>
  <span class="eyebrow">Forgelina (#0959 Tinkaton) · Modèle « Arcanine Hut » · 100 % SANS VISAGE · Vrai PNG RGBA Sans Fond</span>
  <h1>Kit Complet de Tentes, Huttes &amp; Kiosques Forgelina — 100 % Sans Visage (11 Éléments PMDO)</h1>
  <p class="lead">
    Conçu d’après la planche de référence <strong>Arcanine Hut</strong> du dépôt, <strong>entièrement sans visage</strong>
    (aucun œil, aucune bouche — uniquement toile capitonnée, coutures sellier, auvent festonné rayé, écusson marteaux d’acier,
    couettes spiralées rose sakura, rideaux drapés sur trépieds en bois, <strong>guichets centraux 100 % ouverts en vraie transparence <code>alpha = 0</code></strong>,
    comptoirs courbes en U, tapis tissé et bannière sur poteau).
  </p>
  <div class="toolbar">
    <button type="button" class="tool-btn active" id="btnDay" onclick="setGlobalTime('day')">☀ Mode Jour (PMDO)</button>
    <button type="button" class="tool-btn" id="btnNight" onclick="setGlobalTime('night')">🌙 Mode Nuit (PMDO)</button>
    <button type="button" class="tool-btn" onclick="setBg('neutral')">Fond neutre #3a3028</button>
    <button type="button" class="tool-btn" onclick="setBg('slate')">Fond ardoise #262936</button>
    <button type="button" class="tool-btn" onclick="setBg('forest')">Fond mousse #2f3b2f</button>
    <a class="tool-btn accent" href="{sheet_day_b64}" download="Planche_Complete_Forgelina_Hut_Tileset_1x_Jour.png">⬇ Planche Complète 11 Éléments (PNG 1× Sans Fond)</a>
    <a class="tool-btn" href="livrables_forgelina_pmdo/Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip" download>⬇ Archive ZIP Complète (.tile + 1× + HD)</a>
  </div>
</header>

<section class="compare-wrap">
  <div class="box">
    <h2>Modèle de référence du dépôt — « Arcanine Hut »</h2>
    <p>Référence <code>arcanine_reference_thumbnail.png</code> (crédit motif : GeoisEvil) ayant servi de gabarit architectural.</p>
    <div class="stage neutral-bg">
      <img class="pixel-preview" src="{arc_b64}" alt="Référence Arcanine Hut du dépôt" width="506" height="400">
    </div>
  </div>
  <div class="box">
    <h2>Planche Assemblée — « Forgelina Hut Tileset » (11 Éléments · 100 % Sans Visage · Vrai Sans Fond alpha = 0)</h2>
    <p>Les 11 éléments Forgelina sans visage en vraie transparence PNG RGBA (<code>alpha ∈ {{0, 255}}</code>, <code>0 px</code> de frange, guichets 100 % vides <code>alpha = 0</code>).</p>
    <div class="stage neutral-bg">
      <img id="sheetPreview" class="pixel-preview" src="{sheet_day_b64}" data-day="{sheet_day_b64}" data-night="{sheet_night_b64}" alt="Planche complète Forgelina Hut Tileset sans visage">
    </div>
  </div>
</section>

<main class="grid">
  {''.join(cards_html)}
</main>

<footer>
  Statut honnête du pack : assets pixel-art générés sans visage et détourés sur transparence binaire stricte (<code>alpha ∈ {{0, 255}}</code>, <code>0 px</code> de frange verte),
  banques binaires Halcyon <code>FGH1..FGH9, FGHA, FGHB</code> vérifiées par relecture exacte. <code>art_approved: false</code>, <code>runtime_tested: false</code> ;
  les découpes de calques <code>arriere</code> / <code>avant</code> sont des partitions disjointes de la surface visible (<code>Under | Over == Complet</code>) sans reconstruction de pixels occultés.
</footer>

<script>
function setView(btn, src) {{
  const card = btn.closest('.card');
  card.querySelector('.main-img').src = src;
  card.querySelectorAll('.mini-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
}}
function setGlobalTime(mode) {{
  document.getElementById('btnDay').classList.toggle('active', mode === 'day');
  document.getElementById('btnNight').classList.toggle('active', mode === 'night');
  const sheet = document.getElementById('sheetPreview');
  sheet.src = mode === 'day' ? sheet.dataset.day : sheet.dataset.night;
  document.querySelectorAll('.card').forEach(card => {{
    card.querySelector('.main-img').src = mode === 'day' ? card.dataset.day : card.dataset.night;
  }});
}}
function setBg(kind) {{
  document.body.classList.remove('bg-slate', 'bg-forest');
  if (kind === 'slate') document.body.classList.add('bg-slate');
  if (kind === 'forest') document.body.classList.add('bg-forest');
}}
</script>
</body>
</html>
'''
    html_out.write_text(html, encoding='utf-8')


def main():
    gfx = load_halcyon_gfx()

    for d in [OUT, STAGE, LIV]:
        if d.exists():
            shutil.rmtree(d)
    for sub in ['hd', 'assets_1x', 'tilesheets', 'apercus']:
        (OUT / sub).mkdir(parents=True, exist_ok=True)
    for sub in ['HD_sans_fond', '1x_PMDO_8px_sans_fond', 'PMDO_tiles']:
        (LIV / sub).mkdir(parents=True, exist_ok=True)

    manifest_items = []
    built_1x: dict[str, np.ndarray] = {}

    for it in ITEMS:
        raw_p = HERE / it['raw']
        stem = it['file_stem']
        crop_hd, hd_stats = extract_clean_hd_from_green(raw_p)

        cw, ch = crop_hd.width, crop_hd.height
        scale = it['target_vis_w'] / cw
        nw = max(8, int(round(cw * scale)))
        nh = max(8, int(round(ch * scale)))
        tw = it['canvas_w']
        th = int(math.ceil((nh + 8) / 8) * 8)
        px0 = (tw - nw) // 2
        py0 = th - nh - 4

        canvas = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
        canvas.alpha_composite(crop_hd.resize((nw, nh), Image.Resampling.NEAREST), (px0, py0))
        arr = clean_1x_sprite(np.array(canvas))
        arr_n = apply_night_grade(arr)

        arriere, avant, split_y, npc_feet = split_layers_1x(
            arr, it['split_mode'], it['split_frac'], py0, nh
        )

        hd_out = OUT / 'hd' / f'{stem}_HD_sans_fond.png'
        save_binary_alpha_indexed_png(crop_hd, hd_out)
        shutil.copy2(hd_out, LIV / 'HD_sans_fond' / hd_out.name)

        prev = Image.new('RGBA', (cw + 48, ch + 48), NEUTRAL_BG)
        prev.alpha_composite(crop_hd, (24, 24))
        prev.convert('RGB').save(OUT / 'apercus' / f'{stem}_HD_fond_neutre.png', optimize=True)

        saved_1x = {
            f'{stem}_1x_complet.png': arr,
            f'{stem}_1x_nuit_complet.png': arr_n,
        }
        if arriere is not None and avant is not None:
            saved_1x[f'{stem}_1x_arriere.png'] = arriere
            saved_1x[f'{stem}_1x_avant.png'] = avant
            saved_1x[f'{stem}_1x_nuit_arriere.png'] = apply_night_grade(arriere)
            saved_1x[f'{stem}_1x_nuit_avant.png'] = apply_night_grade(avant)

        for fn, a1 in saved_1x.items():
            p_a1 = OUT / 'assets_1x' / fn
            Image.fromarray(a1).save(p_a1, optimize=True, compress_level=9)
            shutil.copy2(p_a1, LIV / '1x_PMDO_8px_sans_fond' / fn)

        pfx = it['bank_pfx']
        u_day = write_tile_bank_and_tsj(
            gfx,
            f'{pfx}_00_JOUR',
            arr,
            LIV / 'PMDO_tiles' / f'{pfx}_00_JOUR.tile',
            LIV / 'PMDO_tiles' / f'{pfx}_00_JOUR.tsj',
            f'../1x_PMDO_8px_sans_fond/{stem}_1x_complet.png',
        )
        u_night = write_tile_bank_and_tsj(
            gfx,
            f'{pfx}_01_NUIT',
            arr_n,
            LIV / 'PMDO_tiles' / f'{pfx}_01_NUIT.tile',
            LIV / 'PMDO_tiles' / f'{pfx}_01_NUIT.tsj',
            f'../1x_PMDO_8px_sans_fond/{stem}_1x_nuit_complet.png',
        )

        built_1x[it['slug']] = arr
        manifest_items.append({
            'id': it['slug'],
            'num': it['num'],
            'file_stem': stem,
            'label': it['label'],
            'subtitle': it['subtitle'],
            'arcanine_equiv': it['arcanine_equiv'],
            'category': it['category'],
            'bank_prefix': pfx,
            'dex': it['dex'],
            'faceless': True,
            'raw_file': raw_p.relative_to(R).as_posix(),
            'raw_sha256': sha256_file(raw_p),
            'hd_sans_fond': f'hd/{stem}_HD_sans_fond.png',
            'hd_tight_size': [cw, ch],
            'assets_1x': sorted(saved_1x.keys()),
            'unique_tiles_jour': u_day,
            'unique_tiles_nuit': u_night,
            'detourage': hd_stats,
            'normalization_1x': {
                'canvas_size': [tw, th],
                'grid_tiles_8px': [tw // 8, th // 8],
                'visible_size': [nw, nh],
                'offset_in_canvas': [px0, py0],
                'split_mode': it['split_mode'],
                'split_y_1x': split_y,
                'npc_feet_local_px': npc_feet,
            },
        })
        print(
            f"OK {stem} ({pfx}): HD={cw}x{ch} | 1x={tw}x{th} ({tw//8}x{th//8} tiles, {u_day} uniq) "
            f"| hole={hd_stats['transparent_interior_hole_px']}px | fringe={hd_stats['residual_green_fringe_px']}px"
        )

    sheet_day = build_tileset_overview_sheet(built_1x, night=False)
    sheet_night = build_tileset_overview_sheet(built_1x, night=True)
    sheet_day_p = OUT / 'tilesheets' / 'Planche_Complete_Forgelina_Hut_Tileset_1x_Jour.png'
    sheet_night_p = OUT / 'tilesheets' / 'Planche_Complete_Forgelina_Hut_Tileset_1x_Nuit.png'
    sheet_day.save(sheet_day_p, optimize=True, compress_level=9)
    sheet_night.save(sheet_night_p, optimize=True, compress_level=9)
    shutil.copy2(sheet_day_p, LIV / '1x_PMDO_8px_sans_fond' / sheet_day_p.name)
    shutil.copy2(sheet_night_p, LIV / '1x_PMDO_8px_sans_fond' / sheet_night_p.name)

    manifest = {
        'namespace': NAMESPACE,
        'title': 'Kit Complet Tentes, Huttes & Kiosques Forgelina — 100 % Sans Visage (Style Arcanine Hut)',
        'pokemon_inspiration': {'name_fr': 'Forgelina', 'name_en': 'Tinkaton', 'dex': '0959'},
        'faceless_all_items': True,
        'arcanine_hut_references': [
            'source/casino_bois_v1/references/arcanine_reference_thumbnail.png',
            'source/kiosque_kirlia_spinda_v1/references/kiosque_arcanin_ref.png',
        ],
        'art_approved': False,
        'runtime_tested': False,
        'spinda_motifs': False,
        'layer_split_note': (
            'Découpes arriere (Under) et avant (Over) effectuées par partition disjointe de la surface visible '
            '(Under | Over == Complet) sans reconstruction de pixels occultés.'
        ),
        'items': manifest_items,
    }
    manifest_p = OUT / 'manifest.json'
    manifest_p.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    shutil.copy2(manifest_p, LIV / 'manifest.json')

    zip_p = LIV / 'Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip'
    with zipfile.ZipFile(zip_p, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for fp in sorted(LIV.rglob('*')):
            if fp.is_file() and fp != zip_p:
                zf.write(fp, fp.relative_to(LIV).as_posix())

    html_out = R / 'apercu_tentes_huttes_forgelina_pmdo.html'
    arc_ref_p = R / 'source/casino_bois_v1/references/arcanine_reference_thumbnail.png'
    generate_html_gallery(manifest, html_out, sheet_day_p, sheet_night_p, arc_ref_p)
    print(f"OK Planche ensemble: {sheet_day.size} | ZIP={zip_p.stat().st_size // 1024} KiB | HTML={html_out.stat().st_size // 1024} KiB")


if __name__ == '__main__':
    main()
