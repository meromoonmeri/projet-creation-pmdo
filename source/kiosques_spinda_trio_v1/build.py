"""Construit le trio complet d'objets de café Spinda, Qulbutoké et Sucreine sans fond (KTR1, PMDO 0.8.12).

Demandes utilisateur :
- « fait le kiosque spinda qulbutoqué et sucreine faut que ce soit magnifique et ssan fond »
- « regarde metano café object pour le design de objet stp »

Pipeline :
1. Lecture des 3 bruts retenus par l'utilisateur (`offer_options=True`), générés d'après
   `Metano_Town_Cafe_Objects` + `Metano_Town_Cafe_Objects_Over` (Halcyon) sur fond #FF00FF pur.
2. Détourage par croissance de régions depuis toutes les plages #FF00FF pures (fond extérieur +
   tous les ajours internes entre feuillages, bocaux et espace barman -> alpha = 0), sans trouer
   les bocaux de jus de baies internes, suivi d'une triple passe d'élimination de frange pourpre
   sur tous les contours (0 px de #FF00FF et 0 px de frange pourpre en HD comme en 1x).
3. Export :
   - Masters HD 100 % sans fond (`*_HD_sans_fond.png` recadré serré + plein format + aperçus `#3a3028`) ;
   - Échelle Ground 1x `Nearest` alignée `8 px` à largeur de bar unifiée `144 px` (`18` tuiles,
     calibrée sur le bar `Metano_Town_Cafe_Objects` d'Halcyon `138 x 91 px`) :
     `Spinda` (`144 x 104`), `Qulbutoke` (`144 x 120`), `Sucreine` (`144 x 136`), chacun décliné en
     `complet`, `arriere` + `avant` (disjoints, `arriere U avant == complet`), et mode `nuit` V8 ;
   - Tilesheets `8 px` Jour & Nuit + banques `.tile` (`KSP1_*`, `KQB1_*`, `KSC1_*`) + `index.idx` + `Mod.xml`.

Usage : .venv/bin/python source/kiosques_spinda_trio_v1/build.py
"""
from __future__ import annotations

import hashlib, importlib.util, json, math, shutil, uuid
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/kiosques_spinda_trio_v1'
STAGE = R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio'

MOD_PFX = 'KTR1'
NAMESPACE = 'kiosques_cafe_spinda_trio'
NIGHT_FACTORS = np.array([0.42, 0.35, 0.40], dtype=float)
NEUTRAL_BG = (58, 48, 40, 255)

SPECS = [
    {
        'slug': 'spinda',
        'label': 'Spinda',
        'pfx': 'KSP1',
        'dex': '0327',
        'raw': 'bruts/objet_cafe_spinda.png',
        'portrait_ref': 'references/spinda_0327_portrait_1x.png',
        'target_vis_w': 138,
        'fallback_split_frac': 0.74,
    },
    {
        'slug': 'qulbutoke',
        'label': 'Qulbutoké',
        'pfx': 'KQB1',
        'dex': '0202',
        'raw': 'bruts/objet_cafe_qulbutoke.png',
        'portrait_ref': 'references/qulbutoke_0202_portrait_1x.png',
        'target_vis_w': 132,
        'fallback_split_frac': 0.71,
    },
    {
        'slug': 'sucreine',
        'label': 'Sucreine',
        'pfx': 'KSC1',
        'dex': '0763',
        'raw': 'bruts/objet_cafe_sucreine.png',
        'portrait_ref': 'references/sucreine_0763_portrait_1x.png',
        'target_vis_w': 130,
        'fallback_split_frac': 0.72,
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
    """Détecte tout pixel opaque teinté magenta/pourpre au contact direct de alpha == 0."""
    op = arr_rgba[..., 3] == 255
    inside = nd.distance_transform_edt(op)
    r = arr_rgba[..., 0].astype(int)
    g = arr_rgba[..., 1].astype(int)
    b = arr_rgba[..., 2].astype(int)
    mag_like = ((b - g > 38) & (r - g > 32) & (np.abs(r - b) < 110)) | ((b - g > 20) & (r - g > 20) & (b > 135))
    return op & (inside <= max_dist) & mag_like


def cutout_and_purge_hd(raw_rgb: np.ndarray) -> tuple[np.ndarray, dict]:
    """Détoure par croissance de régions toutes les plages #FF00FF (extérieur + ajours internes)
    sans trouer les jus de baies violettes internes, puis élimine 100 % de la frange de bordure."""
    r = raw_rgb[..., 0].astype(int)
    g = raw_rgb[..., 1].astype(int)
    b = raw_rgb[..., 2].astype(int)

    # 1. Graines strictes #FF00FF (extérieur + tous les vrais trous #FF00FF >= 35 px)
    seed_raw = (r > 215) & (b > 210) & (g < 65) & (r - g > 165) & (b - g > 160)
    lab_s, ns = nd.label(seed_raw)
    bg_seed = np.zeros_like(seed_raw)
    enclosed_seed_holes = 0
    for i in range(1, ns + 1):
        cnt = int((lab_s == i).sum())
        if cnt >= 35:
            bg_seed |= (lab_s == i)
            ys, xs = np.nonzero(lab_s == i)
            if not (ys.min() == 0 or ys.max() == raw_rgb.shape[0] - 1 or xs.min() == 0 or xs.max() == raw_rgb.shape[1] - 1):
                enclosed_seed_holes += 1

    # 2. Extension contrôlée (5 px autour des vraies graines #FF00FF) pour avaler tout le biseau #FF00FF
    near_bg = nd.binary_dilation(bg_seed, iterations=5)
    bg = bg_seed | (near_bg & (r > 155) & (b > 145) & (b - g > 85) & (r - g > 85))

    fg = ~bg
    lab_fg, nfg = nd.label(fg)
    keep = np.zeros_like(fg)
    for i in range(1, nfg + 1):
        if int((lab_fg == i).sum()) >= 80:
            keep |= (lab_fg == i)

    out = np.zeros((raw_rgb.shape[0], raw_rgb.shape[1], 4), dtype=np.uint8)
    out[keep, :3] = raw_rgb[keep]
    out[keep, 3] = 255

    # 3. Triple passe anti-frange autour de alpha == 0
    inside = nd.distance_transform_edt(keep)
    fringe = boundary_magenta_fringe(out, max_dist=6.0)
    clean_donor = keep & (inside > 4.5) & (~boundary_magenta_fringe(out, max_dist=99.0))
    recolored_px = 0
    if fringe.any() and clean_donor.any():
        idx = nd.distance_transform_edt(~clean_donor, return_distances=False, return_indices=True)
        out[fringe, :3] = out[tuple(idx[:, fringe])][:, :3]
        recolored_px += int(fringe.sum())

    ring = keep & (inside <= 2.2)
    donor_inner = keep & (inside >= 3.5) & (~boundary_magenta_fringe(out, max_dist=99.0))
    if ring.any() and donor_inner.any():
        idx2 = nd.distance_transform_edt(~donor_inner, return_distances=False, return_indices=True)
        out[ring, :3] = out[tuple(idx2[:, ring])][:, :3]
        recolored_px += int(ring.sum())

    stats = {
        'enclosed_transparent_holes_count': enclosed_seed_holes,
        'recolored_edge_pixels_hd': recolored_px,
        'residual_fringe_hd_px': int(boundary_magenta_fringe(out, max_dist=6.0).sum()),
    }
    return out, stats


def clean_1x_edges(arr_rgba: np.ndarray) -> np.ndarray:
    """Garantit 0 px de frange magenta/lavande après sous-échantillonnage Nearest à l'échelle 1x."""
    out = arr_rgba.copy()
    op = out[..., 3] == 255
    inside = nd.distance_transform_edt(op)
    fringe = boundary_magenta_fringe(out, max_dist=2.2)
    donor = op & (inside > 2.2) & (~boundary_magenta_fringe(out, max_dist=99.0))
    if fringe.any() and donor.any():
        idx = nd.distance_transform_edt(~donor, return_distances=False, return_indices=True)
        out[fringe, :3] = out[tuple(idx[:, fringe])][:, :3]
    return out


def normalize_object_1x(hd_rgba: np.ndarray, target_vis_w: int, fallback_split_frac: float) -> tuple[np.ndarray, Image.Image, dict]:
    """Recadre serré le master HD sans fond et produit le sprite Ground 1x sur canevas largeur 144 px (18 tuiles)."""
    op = hd_rgba[..., 3] == 255
    ys, xs = np.nonzero(op)
    x0, y0, x1, y1 = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1
    crop_hd = Image.fromarray(hd_rgba[y0:y1, x0:x1])

    cw, ch = crop_hd.size
    scale = target_vis_w / cw
    nw, nh = int(round(cw * scale)), int(round(ch * scale))
    small = crop_hd.resize((nw, nh), Image.NEAREST)

    tw = 144  # 18 tuiles de 8 px — largeur canonique Halcyon Metano_Town_Cafe_Objects
    th = int(math.ceil((nh + 8) / 8) * 8)
    px0 = (tw - nw) // 2
    py0 = th - nh - 4
    canvas = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
    canvas.alpha_composite(small, (px0, py0))
    arr = np.array(canvas)
    arr[arr[..., 3] < 128] = 0
    arr[arr[..., 3] >= 128, 3] = 255
    arr = clean_1x_edges(arr)

    # Détection automatique de la ligne de comptoir avant (bas de l'ajour central s'il existe, sinon fraction calibrée)
    fg1 = arr[..., 3] == 255
    holes1 = nd.binary_fill_holes(fg1) & (~fg1)
    lh1, nh1 = nd.label(holes1)
    central_holes = []
    for i in range(1, nh1 + 1):
        hy, hx = np.nonzero(lh1 == i)
        if int((lh1 == i).sum()) >= 35 and hx.min() < tw // 2 < hx.max():
            central_holes.append((int((lh1 == i).sum()), int(hy.max()) + 1))
    if central_holes:
        central_holes.sort(reverse=True)
        split_y = central_holes[0][1]
    else:
        split_y = py0 + int(round(nh * fallback_split_frac))

    info = {
        'canvas_size': [tw, th],
        'visible_size': [nw, nh],
        'offset_in_canvas': [px0, py0],
        'hd_tight_size': [cw, ch],
        'source_crop_hd': [x0, y0, x1, y1],
        'counter_split_y_1x': split_y,
        'npc_feet_local_px': [tw // 2, min(th - 6, split_y + 12)],
        'customer_marker_local_px': [tw // 2, th + 8],
    }
    return arr, crop_hd, info


def apply_v8_night(rgba_arr: np.ndarray) -> np.ndarray:
    out = rgba_arr.copy()
    op = out[..., 3] == 255
    out[op, :3] = np.clip(np.round(out[op, :3].astype(float) * NIGHT_FACTORS[None, :]), 0, 255).astype(np.uint8)
    return out


def make_tilesheet(items: list[tuple[str, np.ndarray]]) -> tuple[np.ndarray, list[dict]]:
    pad = 8
    total_w = ((pad + sum(a.shape[1] + pad for _, a in items) + 7) // 8) * 8
    max_h = ((max(a.shape[0] for _, a in items) + 2 * pad + 7) // 8) * 8
    sheet = np.zeros((max_h, total_w, 4), dtype=np.uint8)
    rects = []
    cx = pad
    for name, a in items:
        h, w = a.shape[:2]
        sheet[pad:pad + h, cx:cx + w] = a
        rects.append({'id': name, 'rect': [cx, pad, w, h]})
        cx += w + pad
    return sheet, rects


def build() -> None:
    gfx = loadmod('pmdo_codec_ktr1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_ktr1', R / 'source/pmdo_cote/INSTALLER.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for sub in ('hd', 'assets_1x', 'tilesheets', 'apercus'):
        (OUT / sub).mkdir(parents=True, exist_ok=True)
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / 'Content/Tile').mkdir(parents=True, exist_ok=True)

    day_sheet_items = []
    night_sheet_items = []
    tiles_per_bank = {}
    objects_manifest = []

    for sp in SPECS:
        slug = sp['slug']
        Cap = slug.capitalize()
        raw_p = HERE / sp['raw']
        raw_im = Image.open(raw_p).convert('RGB')
        hd_sq, hd_stats = cutout_and_purge_hd(np.array(raw_im))
        full_1x, crop_hd, norm_info = normalize_object_1x(hd_sq, sp['target_vis_w'], sp['fallback_split_frac'])

        # 1. Exports HD 100 % sans fond (recadré juste + carré d'origine + aperçu fond neutre #3a3028)
        crop_hd.save(OUT / f'hd/{Cap}_Comptoir_HD_sans_fond.png', optimize=True)
        Image.fromarray(hd_sq).save(OUT / f'hd/{Cap}_Comptoir_HD_{raw_im.width}_sans_fond.png', optimize=True)

        pad_n = 36
        prev = Image.new('RGBA', (crop_hd.width + 2 * pad_n, crop_hd.height + 2 * pad_n), NEUTRAL_BG)
        prev.alpha_composite(crop_hd, (pad_n, pad_n))
        prev.convert('RGB').save(OUT / f'apercus/{Cap}_Comptoir_HD_fond_neutre.png', optimize=True)

        # 2. Découpe éditeur 1x (complet + arriere + avant) + variantes Nuit V8
        split_y = norm_info['counter_split_y_1x']
        back_1x = full_1x.copy()
        back_1x[split_y:, :] = 0
        front_1x = full_1x.copy()
        front_1x[:split_y, :] = 0

        full_1x_n = apply_v8_night(full_1x)
        back_1x_n = apply_v8_night(back_1x)
        front_1x_n = apply_v8_night(front_1x)

        file_map = {
            f'{Cap}_Comptoir_1x_complet.png': full_1x,
            f'{Cap}_Comptoir_1x_arriere.png': back_1x,
            f'{Cap}_Comptoir_1x_avant.png': front_1x,
            f'{Cap}_Comptoir_1x_nuit_complet.png': full_1x_n,
            f'{Cap}_Comptoir_1x_nuit_arriere.png': back_1x_n,
            f'{Cap}_Comptoir_1x_nuit_avant.png': front_1x_n,
        }
        for fn, arr in file_map.items():
            Image.fromarray(arr).save(OUT / 'assets_1x' / fn, optimize=True)

        day_sheet_items.extend([
            (f'{slug}_complet', full_1x),
            (f'{slug}_arriere', back_1x),
            (f'{slug}_avant', front_1x),
        ])
        night_sheet_items.extend([
            (f'{slug}_nuit_complet', full_1x_n),
            (f'{slug}_nuit_arriere', back_1x_n),
            (f'{slug}_nuit_avant', front_1x_n),
        ])

        # 3. Banques .tile PMDO 0.8.12 individuelles par personnage (arriere, avant, complet, nuit)
        pfx = sp['pfx']
        for bname, barr in [
            (f'{pfx}_00_ARRIERE', back_1x),
            (f'{pfx}_01_AVANT', front_1x),
            (f'{pfx}_02_COMPLET', full_1x),
            (f'{pfx}_03_NUIT', full_1x_n),
        ]:
            bank = gfx.TileBank(bname, preserve_layout=True)
            hb, wb = barr.shape[:2]
            for gy in range(hb // 8):
                for gx in range(wb // 8):
                    bank.add(Image.fromarray(barr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
            bank.write(STAGE / f'Content/Tile/{bname}.tile')
            tiles_per_bank[bname] = len(bank.data)

        objects_manifest.append({
            'id': slug,
            'label': sp['label'],
            'prefix': pfx,
            'dex': sp['dex'],
            'raw_file': raw_p.relative_to(R).as_posix(),
            'raw_size': list(raw_im.size),
            'raw_sha256': sha(raw_p),
            'portrait_ref': (HERE / sp['portrait_ref']).relative_to(R).as_posix(),
            'portrait_ref_sha256': sha(HERE / sp['portrait_ref']),
            'hd_sans_fond': f'hd/{Cap}_Comptoir_HD_sans_fond.png',
            'assets_1x': sorted(file_map.keys()),
            'detourage': hd_stats,
            'normalization_1x': norm_info,
        })
        print(f'OK {pfx} ({sp["label"]}): HD tight={norm_info["hd_tight_size"]}, 1x={norm_info["visible_size"]} in {norm_info["canvas_size"]}, fringe={hd_stats["residual_fringe_hd_px"]} px')

    sheet_day, rects_day = make_tilesheet(day_sheet_items)
    sheet_night, rects_night = make_tilesheet(night_sheet_items)
    Image.fromarray(sheet_day).save(OUT / 'tilesheets/Tilesheet_Kiosques_Cafe_Jour_1x.png', optimize=True)
    Image.fromarray(sheet_night).save(OUT / 'tilesheets/Tilesheet_Kiosques_Cafe_Nuit_1x.png', optimize=True)

    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Comptoirs Cafe Spinda, Qulbutoke, Sucreine (KTR1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Trio d objets de comptoir de cafe sans fond (Spinda, Qulbutoke, Sucreine) dans le style Metano_Town_Cafe_Objects.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
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

    ecartes = [
        {'file': p.relative_to(R).as_posix(), 'sha256': sha(p)}
        for p in sorted((HERE / 'bruts/ecartes').glob('*.png'))
    ]
    manifest = {
        'id': 'kiosques_spinda_trio_v1',
        'prefix': MOD_PFX,
        'title': 'Kiosques / Comptoirs Café — Spinda, Qulbutoké & Sucreine (100 % sans fond, style Metano_Town_Cafe_Objects)',
        'nature': 'Trio d objets de comptoir de café générés d après Metano_Town_Cafe_Objects + Metano_Town_Cafe_Objects_Over (Halcyon) et détourés à 100 % sans fond (alpha = 0, 0 px magenta/pourpre). Pas des tuiles natives certifiées.',
        'art_approved': False,
        'style_reference': {
            'repo': 'Palikadude/Halcyon',
            'banks': [
                'source/cafe_multietage_v1/references/Metano_Town_Cafe_Objects.tile',
                'source/cafe_multietage_v1/references/Metano_Town_Cafe_Objects_Over.tile',
            ],
            'reference_card': 'source/kiosques_spinda_trio_v1/references/halcyon_metano_cafe/metano_cafe_bar_sq_magenta.png',
            'reference_card_sha256': sha(HERE / 'references/halcyon_metano_cafe/metano_cafe_bar_sq_magenta.png'),
        },
        'objects': objects_manifest,
        'archived_candidates': ecartes,
        'tilesheets': {
            'jour': {'file': 'tilesheets/Tilesheet_Kiosques_Cafe_Jour_1x.png', 'rects': rects_day},
            'nuit': {'file': 'tilesheets/Tilesheet_Kiosques_Cafe_Nuit_1x.png', 'rects': rects_night},
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
