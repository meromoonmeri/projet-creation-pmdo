"""Construit le pack complet Mobilier Café & Scène Spinda Troubadour sans fond (KMC1).

Inclut :
- La Scène / Estrade Spinda Troubadour cohérente à la POV 3/4 de dessus des salles existantes (SpindaV7) :
  * `Estrade_Spinda_Troubadour` (scène complète à centre 100 % ouvert `alpha = 0` : plateau bois miel au médaillon spirale Spinda en `arriere` [Under] + grande arche ouverte à motifs Spinda Troubadour en `avant` [Over]),
  * `Estrade_Plateau_Spinda` (plateau bois miel seul en POV 3/4 de dessus + escalier central + spirale Spinda),
  * `Rideau_Gauche_Spinda_Troubadour` (rideau gauche drapé indépendant aux spirales/pois Spinda & fanions troubadour),
  * `Rideau_Droit_Spinda_Troubadour` (rideau droit drapé asymétrique indépendant aux spirales/pois Spinda & fanions troubadour),
  * `Lambrequin_Arche_Spinda_Troubadour` (grande arche horizontale supérieure ouverte `Over` seule),
  * `Estrade_Fond_Ferme_Spinda_Troubadour` (variante scène avec fond rideau rouge drapé complet),
- Les comptoirs `Kirlia_Comptoir`, `Charmilly_Comptoir` et accessoires `Piano_Cafe_Bois`, `Jukebox_Cafe`, `Table_Cabaret_Rouge`, `Banquette_Velours_Rouge`.

Usage : .venv/bin/python source/mobilier_cafe_complet_v1/build.py
"""
from __future__ import annotations

import hashlib, importlib.util, json, math, shutil, uuid
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/mobilier_cafe_complet_v1'
STAGE = R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet'

MOD_PFX = 'KMC1'
NAMESPACE = 'mobilier_cafe_complet'
NIGHT_FACTORS = np.array([0.42, 0.35, 0.40], dtype=float)
NEUTRAL_BG = (58, 48, 40, 255)

ITEMS = [
    {
        'slug': 'estrade',
        'file_stem': 'Estrade_Spinda_Troubadour',
        'label': 'Estrade Ouverte & Rideaux Spinda Troubadour (POV Salles)',
        'category': 'stage',
        'bank_pfx': 'EST1',
        'dex': '0327',
        'raw': 'bruts/estrade_plateau_spinda_seul.png',
        'raw_over': 'bruts/lambrequin_arche_spinda_troubadour.png',
        'target_vis_w': 200,
        'canvas_w': 208,
        'split_mode': 'stage_open_arch',
        'split_frac': None,
    },
    {
        'slug': 'estrade_plateau',
        'file_stem': 'Estrade_Plateau_Spinda',
        'label': 'Plateau Estrade Bois Spirale Spinda (Seul · POV 3/4)',
        'category': 'stage_part',
        'bank_pfx': 'STR1',
        'dex': '0327',
        'raw': 'bruts/estrade_plateau_spinda_seul.png',
        'target_vis_w': 184,
        'canvas_w': 192,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'rideau_gauche_spinda',
        'file_stem': 'Rideau_Gauche_Spinda_Troubadour',
        'label': 'Rideau de Scène Gauche — Motif Spinda Troubadour',
        'category': 'stage_part',
        'bank_pfx': 'STR1',
        'dex': '0327',
        'raw': 'bruts/rideau_gauche_spinda_troubadour.png',
        'target_vis_w': 96,
        'canvas_w': 104,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'rideau_droit_spinda',
        'file_stem': 'Rideau_Droit_Spinda_Troubadour',
        'label': 'Rideau de Scène Droit — Motif Spinda Troubadour',
        'category': 'stage_part',
        'bank_pfx': 'STR1',
        'dex': '0327',
        'raw': 'bruts/rideau_droit_spinda_troubadour.png',
        'target_vis_w': 96,
        'canvas_w': 104,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'lambrequin_spinda',
        'file_stem': 'Lambrequin_Arche_Spinda_Troubadour',
        'label': 'Arche Supérieure Rideaux Ouverts — Spinda Troubadour (Over)',
        'category': 'stage_part',
        'bank_pfx': 'STR1',
        'dex': '0327',
        'raw': 'bruts/lambrequin_arche_spinda_troubadour.png',
        'target_vis_w': 200,
        'canvas_w': 208,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'estrade_fond_ferme',
        'file_stem': 'Estrade_Fond_Ferme_Spinda_Troubadour',
        'label': 'Scène Fond Rideau Complet — Spinda Troubadour',
        'category': 'stage',
        'bank_pfx': 'EST2',
        'dex': '0327',
        'raw': 'bruts/estrade_spinda_troubadour_pov.png',
        'target_vis_w': 200,
        'canvas_w': 208,
        'split_mode': 'stage_canopy',
        'split_frac': 0.25,
    },
    {
        'slug': 'kirlia',
        'file_stem': 'Kirlia_Comptoir',
        'label': 'Comptoir Kirlia',
        'category': 'counter',
        'bank_pfx': 'KKB1',
        'dex': '0281',
        'raw': 'bruts/objet_cafe_kirlia.png',
        'target_vis_w': 132,
        'canvas_w': 144,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'slug': 'charmilly',
        'file_stem': 'Charmilly_Comptoir',
        'label': 'Comptoir Charmilly',
        'category': 'counter',
        'bank_pfx': 'KCM1',
        'dex': '0869',
        'raw': 'bruts/objet_cafe_charmilly.png',
        'target_vis_w': 132,
        'canvas_w': 144,
        'split_mode': 'counter_aisle',
        'split_frac': 0.72,
    },
    {
        'slug': 'piano',
        'file_stem': 'Piano_Cafe_Bois',
        'label': 'Piano Droit du Café',
        'category': 'prop',
        'bank_pfx': 'ACC1',
        'dex': None,
        'raw': 'bruts/piano_cafe_bois.png',
        'target_vis_w': 66,
        'canvas_w': 72,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'jukebox',
        'file_stem': 'Jukebox_Cafe',
        'label': 'Jukebox / Phonographe',
        'category': 'prop',
        'bank_pfx': 'ACC1',
        'dex': None,
        'raw': 'bruts/jukebox_cafe.png',
        'target_vis_w': 42,
        'canvas_w': 48,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'table_cabaret',
        'file_stem': 'Table_Cabaret_Rouge',
        'label': 'Table Ronde Cabaret Rouge',
        'category': 'prop',
        'bank_pfx': 'ACC1',
        'dex': None,
        'raw': 'bruts/table_cabaret_rouge.png',
        'target_vis_w': 44,
        'canvas_w': 48,
        'split_mode': None,
        'split_frac': None,
    },
    {
        'slug': 'banquette_velours',
        'file_stem': 'Banquette_Velours_Rouge',
        'label': 'Banquette Velours Rouge',
        'category': 'prop',
        'bank_pfx': 'ACC1',
        'dex': None,
        'raw': 'bruts/banquette_velours_rouge.png',
        'target_vis_w': 82,
        'canvas_w': 88,
        'split_mode': None,
        'split_frac': None,
    },
]


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def boundary_magenta_fringe(arr_rgba: np.ndarray, max_dist: float = 4.0) -> np.ndarray:
    op = arr_rgba[..., 3] == 255
    inside = nd.distance_transform_edt(op)
    r = arr_rgba[..., 0].astype(int)
    g = arr_rgba[..., 1].astype(int)
    b = arr_rgba[..., 2].astype(int)
    mag_like = ((b - g > 38) & (r - g > 32) & (np.abs(r - b) < 110)) | ((b - g > 20) & (r - g > 20) & (b > 135))
    return op & (inside <= max_dist) & mag_like


def cutout_and_purge_hd(raw_rgb: np.ndarray) -> tuple[np.ndarray, dict]:
    r = raw_rgb[..., 0].astype(int)
    g = raw_rgb[..., 1].astype(int)
    b = raw_rgb[..., 2].astype(int)

    seed_raw = (r > 215) & (b > 210) & (g < 65) & (r - g > 165) & (b - g > 160)
    lab_s, ns = nd.label(seed_raw)
    bg_seed = np.zeros_like(seed_raw)
    enclosed = 0
    for i in range(1, ns + 1):
        c = int((lab_s == i).sum())
        if c >= 35:
            bg_seed |= (lab_s == i)
            ys, xs = np.nonzero(lab_s == i)
            if not (ys.min() == 0 or ys.max() == raw_rgb.shape[0] - 1 or xs.min() == 0 or xs.max() == raw_rgb.shape[1] - 1):
                enclosed += 1

    near_bg = nd.binary_dilation(bg_seed, iterations=6)
    bg = bg_seed | (near_bg & (r > 155) & (b > 145) & (b - g > 85) & (r - g > 85))

    fg = ~bg
    lf, nf = nd.label(fg)
    keep = np.zeros_like(fg)
    for i in range(1, nf + 1):
        if int((lf == i).sum()) >= 80:
            keep |= (lf == i)

    out = np.zeros((raw_rgb.shape[0], raw_rgb.shape[1], 4), dtype=np.uint8)
    out[keep, :3] = raw_rgb[keep]
    out[keep, 3] = 255

    inside = nd.distance_transform_edt(keep)
    fringe = boundary_magenta_fringe(out, max_dist=7.0)
    donor = keep & (inside > 5.0) & (~boundary_magenta_fringe(out, max_dist=99.0))
    rec_px = 0
    if fringe.any() and donor.any():
        idx = nd.distance_transform_edt(~donor, return_distances=False, return_indices=True)
        out[fringe, :3] = out[tuple(idx[:, fringe])][:, :3]
        rec_px += int(fringe.sum())

    ring = keep & (inside <= 2.4)
    donor2 = keep & (inside >= 3.8) & (~boundary_magenta_fringe(out, max_dist=99.0))
    if fringe.any() or (ring.any() and donor2.any()):
        idx2 = nd.distance_transform_edt(~donor2, return_distances=False, return_indices=True)
        out[ring, :3] = out[tuple(idx2[:, ring])][:, :3]
        rec_px += int(ring.sum())

    return out, {
        'enclosed_transparent_holes_count': enclosed,
        'recolored_edge_pixels_hd': rec_px,
        'residual_fringe_hd_px': int(boundary_magenta_fringe(out, max_dist=6.0).sum()),
    }


def tight_crop_hd(raw_p: Path) -> tuple[Image.Image, list[int], dict]:
    raw_im = Image.open(raw_p).convert('RGB')
    hd_sq, hd_stats = cutout_and_purge_hd(np.array(raw_im))
    op = hd_sq[..., 3] == 255
    ys, xs = np.nonzero(op)
    x0, y0, x1, y1 = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1
    return Image.fromarray(hd_sq[y0:y1, x0:x1]), list(raw_im.size), hd_stats


def clean_1x_edges(arr_rgba: np.ndarray) -> np.ndarray:
    out = arr_rgba.copy()
    op = out[..., 3] == 255
    inside = nd.distance_transform_edt(op)
    fringe = boundary_magenta_fringe(out, max_dist=2.2)
    donor = op & (inside > 2.2) & (~boundary_magenta_fringe(out, max_dist=99.0))
    if fringe.any() and donor.any():
        idx = nd.distance_transform_edt(~donor, return_distances=False, return_indices=True)
        out[fringe, :3] = out[tuple(idx[:, fringe])][:, :3]
    return out


def apply_v8_night(rgba_arr: np.ndarray) -> np.ndarray:
    out = rgba_arr.copy()
    op = out[..., 3] == 255
    out[op, :3] = np.clip(np.round(out[op, :3].astype(float) * NIGHT_FACTORS[None, :]), 0, 255).astype(np.uint8)
    return out


def make_tilesheet(items: list[tuple[str, np.ndarray]], max_row_w: int = 640) -> tuple[np.ndarray, list[dict]]:
    pad = 8
    x, y, row_h = pad, pad, 0
    placed = []
    used_w = 0
    for name, a in items:
        h, w = a.shape[:2]
        if x + w + pad > max_row_w and x > pad:
            x = pad
            y += row_h + pad
            row_h = 0
        placed.append((name, a, x, y))
        used_w = max(used_w, x + w + pad)
        x += w + pad
        row_h = max(row_h, h)
    tw = ((used_w + 7) // 8) * 8
    th = ((y + row_h + pad + 7) // 8) * 8
    sheet = np.zeros((th, tw, 4), dtype=np.uint8)
    rects = []
    for name, a, px, py in placed:
        h, w = a.shape[:2]
        sheet[py:py + h, px:px + w] = a
        rects.append({'id': name, 'rect': [px, py, w, h]})
    return sheet, rects


def build() -> None:
    gfx = loadmod('pmdo_codec_kmc1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_kmc1', R / 'source/pmdo_cote/INSTALLER.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for sub in ('hd', 'assets_1x', 'tilesheets', 'apercus'):
        (OUT / sub).mkdir(parents=True, exist_ok=True)
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / 'Content/Tile').mkdir(parents=True, exist_ok=True)

    day_sheet_items = []
    night_sheet_items = []
    acc_day_items = []
    acc_night_items = []
    str_day_items = []
    str_night_items = []
    tiles_per_bank = {}
    manifest_items = []
    built_1x = {}

    for it in ITEMS:
        stem = it['file_stem']
        raw_p = HERE / it['raw']

        if it['split_mode'] == 'stage_open_arch':
            # Assemblage cohérent POV 3/4 de dessus :
            # - `arriere` (Under) = Plateau d'estrade bois miel au médaillon spirale Spinda (POV 3/4 des salles SpindaV7)
            # - `avant` (Over)    = Grande arche ouverte de rideaux à motifs Spinda Troubadour (centre 100 % alpha = 0 !)
            plat_hd, raw_sz, st_plat = tight_crop_hd(raw_p)
            arch_hd, _, st_arch = tight_crop_hd(HERE / it['raw_over'])

            # Assemblage HD sans fond (les pans latéraux reposent sur les coins arrière de l'estrade,
            # laissant une grande arche centrale ouverte de ~250 px de haut en HD / ~48 px en 1x !)
            hd_w = arch_hd.width
            plat_w_hd = int(round(hd_w * (184.0 / 200.0)))
            plat_h_hd = int(round(plat_hd.height * (plat_w_hd / plat_hd.width)))
            plat_resized = plat_hd.resize((plat_w_hd, plat_h_hd), Image.NEAREST)
            plat_y_hd = int(round(arch_hd.height * 0.64))
            hd_h = max(arch_hd.height, plat_y_hd + plat_h_hd)
            comp_hd = Image.new('RGBA', (hd_w, hd_h), (0, 0, 0, 0))
            comp_hd.alpha_composite(plat_resized, ((hd_w - plat_w_hd) // 2, plat_y_hd))
            comp_hd.alpha_composite(arch_hd, (0, 0))
            crop_hd = comp_hd
            hd_stats = {
                'enclosed_transparent_holes_count': st_arch['enclosed_transparent_holes_count'] + 1,
                'recolored_edge_pixels_hd': st_plat['recolored_edge_pixels_hd'] + st_arch['recolored_edge_pixels_hd'],
                'residual_fringe_hd_px': int(boundary_magenta_fringe(np.array(crop_hd), max_dist=6.0).sum()),
            }

            # Assemblage 1x PMDO exact (208 x 216 px = 26 x 27 tuiles de 8 px) :
            # - `avant` (Over)   : arche ouverte à y = 4..134 (pans latéraux ancrés sur l'estrade à y = 88..134)
            # - `arriere` (Under): plateau d'estrade bois miel spirale Spinda à y = 88..212 (100 % praticable)
            tw, th = 208, 216
            nw_arch = 200
            nh_arch = int(round(arch_hd.height * (nw_arch / arch_hd.width)))  # ~130 px
            nw_plat = 184
            nh_plat = int(round(plat_hd.height * (nw_plat / plat_hd.width)))  # ~124 px

            under_im = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
            under_im.alpha_composite(plat_hd.resize((nw_plat, nh_plat), Image.NEAREST), ((tw - nw_plat) // 2, th - nh_plat - 4))
            over_im = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
            over_im.alpha_composite(arch_hd.resize((nw_arch, nh_arch), Image.NEAREST), ((tw - nw_arch) // 2, 4))

            under_a = clean_1x_edges(np.array(under_im))
            over_a = clean_1x_edges(np.array(over_im))
            under_a[under_a[..., 3] < 128] = 0; under_a[under_a[..., 3] >= 128, 3] = 255
            over_a[over_a[..., 3] < 128] = 0; over_a[over_a[..., 3] >= 128, 3] = 255

            # `Over` prime sur `Under` ; découpe disjointe pour `arriere` | `avant` == `complet` bit-exact
            front = over_a
            back = under_a.copy()
            back[front[..., 3] > 0] = 0
            arr = np.where(front[..., 3:4] > 0, front, back)
            arr_n = apply_v8_night(arr)
            cw, ch = crop_hd.size
            nw, nh, px0, py0 = 200, th - 8, 4, 4
            split_y = 4 + nh_arch
            npc_feet = [tw // 2, th - 58]
        else:
            crop_hd, raw_sz, hd_stats = tight_crop_hd(raw_p)
            cw, ch = crop_hd.size
            scale = it['target_vis_w'] / cw
            nw, nh = int(round(cw * scale)), int(round(ch * scale))
            tw = it['canvas_w']
            th = int(math.ceil((nh + 8) / 8) * 8)
            px0 = (tw - nw) // 2
            py0 = th - nh - 4
            canvas = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
            canvas.alpha_composite(crop_hd.resize((nw, nh), Image.NEAREST), (px0, py0))
            arr = np.array(canvas)
            arr[arr[..., 3] < 128] = 0
            arr[arr[..., 3] >= 128, 3] = 255
            arr = clean_1x_edges(arr)
            arr_n = apply_v8_night(arr)

            split_y = None
            npc_feet = None
            if it['split_mode'] == 'counter_aisle':
                fg1 = arr[..., 3] == 255
                holes1 = nd.binary_fill_holes(fg1) & (~fg1)
                lh1, nh1 = nd.label(holes1)
                central = []
                for hi in range(1, nh1 + 1):
                    hy, hx = np.nonzero(lh1 == hi)
                    if int((lh1 == hi).sum()) >= 35 and hx.min() < tw // 2 < hx.max():
                        central.append((int((lh1 == hi).sum()), int(hy.max()) + 1))
                split_y = max(central)[1] if central else (py0 + int(round(nh * it['split_frac'])))
                back = arr.copy(); back[split_y:, :] = 0
                front = arr.copy(); front[:split_y, :] = 0
                npc_feet = [tw // 2, min(th - 6, split_y + 12)]
            elif it['split_mode'] == 'stage_canopy':
                split_y = py0 + int(round(nh * it['split_frac']))
                front = arr.copy(); front[split_y:, :] = 0
                back = arr.copy(); back[:split_y, :] = 0
                npc_feet = [tw // 2, py0 + int(round(nh * 0.72))]

        crop_hd.save(OUT / f'hd/{stem}_HD_sans_fond.png', optimize=True)
        pad_n = 32
        prev = Image.new('RGBA', (crop_hd.width + 2 * pad_n, crop_hd.height + 2 * pad_n), NEUTRAL_BG)
        prev.alpha_composite(crop_hd, (pad_n, pad_n))
        prev.convert('RGB').save(OUT / f'apercus/{stem}_HD_fond_neutre.png', optimize=True)

        saved_1x = {
            f'{stem}_1x_complet.png': arr,
            f'{stem}_1x_nuit_complet.png': arr_n,
        }
        built_1x[it['slug']] = arr
        day_sheet_items.append((f'{it["slug"]}_complet', arr))
        night_sheet_items.append((f'{it["slug"]}_nuit_complet', arr_n))

        if split_y is not None:
            back_n = apply_v8_night(back)
            front_n = apply_v8_night(front)
            saved_1x.update({
                f'{stem}_1x_arriere.png': back,
                f'{stem}_1x_avant.png': front,
                f'{stem}_1x_nuit_arriere.png': back_n,
                f'{stem}_1x_nuit_avant.png': front_n,
            })
            pfx = it['bank_pfx']
            for bname, barr in [
                (f'{pfx}_00_ARRIERE', back),
                (f'{pfx}_01_AVANT', front),
                (f'{pfx}_02_COMPLET', arr),
                (f'{pfx}_03_NUIT', arr_n),
            ]:
                bank = gfx.TileBank(bname, preserve_layout=True)
                for gy in range(barr.shape[0] // 8):
                    for gx in range(barr.shape[1] // 8):
                        bank.add(Image.fromarray(barr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
                bank.write(STAGE / f'Content/Tile/{bname}.tile')
                tiles_per_bank[bname] = len(bank.data)
        elif it['bank_pfx'] == 'STR1':
            str_day_items.append((it['slug'], arr))
            str_night_items.append((it['slug'] + '_nuit', arr_n))
        else:
            acc_day_items.append((it['slug'], arr))
            acc_night_items.append((it['slug'] + '_nuit', arr_n))

        for fn, a1 in saved_1x.items():
            Image.fromarray(a1).save(OUT / 'assets_1x' / fn, optimize=True)

        manifest_items.append({
            'id': it['slug'],
            'file_stem': stem,
            'label': it['label'],
            'category': it['category'],
            'bank_prefix': it['bank_pfx'],
            'dex': it['dex'],
            'raw_file': raw_p.relative_to(R).as_posix(),
            'raw_size': raw_sz,
            'raw_sha256': sha(raw_p),
            'hd_sans_fond': f'hd/{stem}_HD_sans_fond.png',
            'hd_tight_size': [cw, ch],
            'assets_1x': sorted(saved_1x.keys()),
            'detourage': hd_stats,
            'normalization_1x': {
                'canvas_size': [tw, th],
                'visible_size': [nw, nh],
                'offset_in_canvas': [px0, py0],
                'split_mode': it['split_mode'],
                'split_y_1x': split_y,
                'npc_feet_local_px': npc_feet,
            },
        })
        print(f'OK {stem}: HD={cw}x{ch}, 1x={nw}x{nh} in {tw}x{th}, fringe={hd_stats["residual_fringe_hd_px"]} px')

    # Banques .tile dédiées aux modules indépendants Scène Spinda Troubadour (STR1) et Accessoires Cabaret (ACC1)
    str_sheet_d, str_rects_d = make_tilesheet(str_day_items, max_row_w=432)
    str_sheet_n, str_rects_n = make_tilesheet(str_night_items, max_row_w=432)
    for bname, barr in [('STR1_00_MODULES_JOUR', str_sheet_d), ('STR1_01_MODULES_NUIT', str_sheet_n)]:
        bank = gfx.TileBank(bname, preserve_layout=True)
        for gy in range(barr.shape[0] // 8):
            for gx in range(barr.shape[1] // 8):
                bank.add(Image.fromarray(barr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
        bank.write(STAGE / f'Content/Tile/{bname}.tile')
        tiles_per_bank[bname] = len(bank.data)

    acc_sheet_d, acc_rects_d = make_tilesheet(acc_day_items, max_row_w=384)
    acc_sheet_n, acc_rects_n = make_tilesheet(acc_night_items, max_row_w=384)
    for bname, barr in [('ACC1_00_JOUR', acc_sheet_d), ('ACC1_01_NUIT', acc_sheet_n)]:
        bank = gfx.TileBank(bname, preserve_layout=True)
        for gy in range(barr.shape[0] // 8):
            for gx in range(barr.shape[1] // 8):
                bank.add(Image.fromarray(barr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
        bank.write(STAGE / f'Content/Tile/{bname}.tile')
        tiles_per_bank[bname] = len(bank.data)

    sheet_day, rects_day = make_tilesheet(day_sheet_items, max_row_w=640)
    sheet_night, rects_night = make_tilesheet(night_sheet_items, max_row_w=640)
    Image.fromarray(str_sheet_d).save(OUT / 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Jour_1x.png', optimize=True)
    Image.fromarray(str_sheet_n).save(OUT / 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Nuit_1x.png', optimize=True)
    Image.fromarray(sheet_day).save(OUT / 'tilesheets/Tilesheet_Mobilier_Cafe_Jour_1x.png', optimize=True)
    Image.fromarray(sheet_night).save(OUT / 'tilesheets/Tilesheet_Mobilier_Cafe_Nuit_1x.png', optimize=True)
    Image.fromarray(acc_sheet_d).save(OUT / 'tilesheets/Tilesheet_Accessoires_Cabaret_Jour_1x.png', optimize=True)
    Image.fromarray(acc_sheet_n).save(OUT / 'tilesheets/Tilesheet_Accessoires_Cabaret_Nuit_1x.png', optimize=True)

    # Aperçus de démonstration 1x directement dans les salles existantes SpindaV7 (sans modifier les maps !)
    for room_file, out_demo, mode_demo in [
        ('renders/cafe_spinda_revisite_v7/salles/SpindaV7_cafe_sans_magenta.png', 'Demo_POV_Salle_Cafe_SpindaV7_Arche_Ouverte.png', 'arch'),
        ('renders/cafe_spinda_revisite_v7/salles/SpindaV7_salon_haut_sans_magenta.png', 'Demo_POV_Salle_Salon_Haut_SpindaV7_2_Rideaux.png', 'curtains'),
    ]:
        rp = R / room_file
        if rp.exists():
            rm = Image.open(rp).convert('RGBA')
            bg_demo = Image.new('RGBA', rm.size, NEUTRAL_BG)
            bg_demo.alpha_composite(rm)
            if mode_demo == 'arch':
                bg_demo.alpha_composite(Image.fromarray(built_1x['estrade']), (200, 96))
            else:
                bg_demo.alpha_composite(Image.fromarray(built_1x['estrade_plateau']), (184, 140))
                bg_demo.alpha_composite(Image.fromarray(built_1x['rideau_gauche_spinda']), (168, 92))
                bg_demo.alpha_composite(Image.fromarray(built_1x['rideau_droit_spinda']), (288, 92))
            bg_demo.convert('RGB').save(OUT / f'apercus/{out_demo}', optimize=True)

    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Mobilier Complet Cafe &amp; Scene Spinda Troubadour (KMC1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Scene Spinda Troubadour coherente a la POV 3/4 des salles SpindaV7 (estrade bois spirale Spinda + rideaux gauche/droit + arche ouverte), comptoirs Kirlia &amp; Charmilly et accessoires sans fond.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.1.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    script = (R / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    assert needle in script
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(script)
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')

    manifest = {
        'id': 'mobilier_cafe_complet_v1',
        'prefix': MOD_PFX,
        'title': 'Collection Complète Café & Scène Spinda Troubadour (POV Salles Existantes, sans fond)',
        'nature': 'Objets générés référencés (SpindaV7 + Metano_Town_Cafe_Objects), détourés à 100 % sans fond (alpha = 0, 0 px magenta/pourpre). Estrade en bois miel au médaillon spirale Spinda et rideaux à motifs Spinda Troubadour cohérents à la POV 3/4 de dessus des salles existantes. Pas des tuiles natives certifiées.',
        'art_approved': False,
        'objects': manifest_items,
        'archived_candidates': [
            {'file': p.relative_to(R).as_posix(), 'sha256': sha(p)}
            for p in sorted((HERE / 'bruts/ecartes').glob('*.png'))
        ],
        'tilesheets': {
            'scene_spinda_jour': {'file': 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Jour_1x.png', 'rects': str_rects_d},
            'scene_spinda_nuit': {'file': 'tilesheets/Tilesheet_Scene_Spinda_Troubadour_Modules_Nuit_1x.png', 'rects': str_rects_n},
            'jour': {'file': 'tilesheets/Tilesheet_Mobilier_Cafe_Jour_1x.png', 'rects': rects_day},
            'nuit': {'file': 'tilesheets/Tilesheet_Mobilier_Cafe_Nuit_1x.png', 'rects': rects_night},
            'accessoires_jour': {'file': 'tilesheets/Tilesheet_Accessoires_Cabaret_Jour_1x.png', 'rects': acc_rects_d},
            'accessoires_nuit': {'file': 'tilesheets/Tilesheet_Accessoires_Cabaret_Nuit_1x.png', 'rects': acc_rects_n},
        },
        'pmdo': {
            'target': '0.8.12',
            'runtime_tested': False,
            'namespace': NAMESPACE,
            'tiles_per_bank': tiles_per_bank,
        },
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    build()
