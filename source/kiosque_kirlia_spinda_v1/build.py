"""Construit le pack complet du Kiosque Kirlia pour le Café Spinda (KKR1, PMDO 0.8.12).

Demande utilisateur :
- « genere moi le kiosque kirlia stp pour spinda café »
- « faudrait pas de noir mais majenta que tu le retire ensuite et tu retire la feuille et le café stp »

Pipeline :
1. Lecture de `bruts/kiosque_kirlia.png` (1024 x 1024 sur fond #FF00FF pur, intérieur du guichet en
   #FF00FF pur sans noir, comptoir en bois nu sans feuille ni café/tasse).
2. Détourage intégral (fond extérieur + ouverture du guichet central + ajours latéraux -> alpha = 0)
   puis triple passe d'élimination de toute frange magenta/pourpre au contact de la transparence
   (0 px de magenta pur et 0 px de frange pourpre mesurés sur tous les bords).
3. Export :
   - HD transparent (`Kiosque_Kirlia_HD_sans_magenta.png`) + aperçu fond neutre (`#3a3028`) ;
   - Normalisation `Nearest` (proportions conservées) dans un canevas Ground `112 x 120` divisible par 8
     (visible `106 x 112`, cohérent avec `SpindaV7_comptoir_spinda` `120 x 96` et `Casino_kiosque` `112 x 128`) :
     `complet`, `arriere` + `avant` (disjoints, union = `complet`), et variantes `nuit` V8 (`[0.42, 0.35, 0.40]`) ;
   - Tilesheets PNG (`jour` et `nuit`) + banques `.tile` + `index.idx` + `Mod.xml` + `INSTALLER.py` pour PMDO 0.8.12.

Usage : .venv/bin/python source/kiosque_kirlia_spinda_v1/build.py
"""
from __future__ import annotations

import hashlib, importlib.util, json, shutil, uuid
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts/kiosque_kirlia.png'
ECARTE_V1 = HERE / 'bruts/ecartes/kiosque_kirlia_v1_avec_noir_feuille_tasse.png'
REF_ARCANIN = HERE / 'references/kiosque_arcanin_ref.png'
REF_SPINDA = HERE / 'references/SpindaV7_comptoir_spinda_1x.png'
REF_KIRLIA = HERE / 'references/kirlia_0281_portrait_1x.png'
OUT = R / 'renders/kiosque_kirlia_spinda_v1'
STAGE = R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda'

PFX = 'KKR1'
NAMESPACE = 'kiosque_kirlia_spinda'
CANVAS_1X = (112, 120)          # 14 x 15 tuiles de 8 px
MAX_VIS_1X = (108, 112)         # enveloppe visible max conservant le ratio exact 863:912 -> 106 x 112
NIGHT_FACTORS = np.array([0.42, 0.35, 0.40], dtype=float)
NEUTRAL_BG = (58, 48, 40, 255)


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def is_purple_fringe(arr_rgba: np.ndarray, max_dist: float = 6.0) -> np.ndarray:
    """Détecte tout pixel opaque teinté magenta/violet près de la transparence (extérieur OU guichet).
    Les cornes rubis intérieures ont b - g <= 16 et le volant blanc pur a r >= b - 24 ; tout pixel de
    bordure avec b - g > 38 ou ((b - g > 14) & (r - g > 20) & (b > 95)) est un résidu d'anti-aliasing #FF00FF.
    """
    op = arr_rgba[..., 3] == 255
    inside = nd.distance_transform_edt(op)
    r = arr_rgba[..., 0].astype(int)
    g = arr_rgba[..., 1].astype(int)
    b = arr_rgba[..., 2].astype(int)
    magenta_like = (b - g > 38) | ((b - g > 14) & (r - g > 20) & (b > 90))
    return op & (inside <= max_dist) & magenta_like


def cutout_and_purge_magenta(raw_rgb: np.ndarray) -> tuple[np.ndarray, dict]:
    """Détoure le fond et l'ouverture du guichet en #FF00FF pur, puis élimine 100 % de la frange pourpre."""
    r = raw_rgb[..., 0].astype(int)
    g = raw_rgb[..., 1].astype(int)
    b = raw_rgb[..., 2].astype(int)

    # 1. Masque du fond magenta (extérieur + ouverture centrale du guichet + ajours latéraux)
    bg = (r > 165) & (b > 155) & (b - g > 95) & (r - g > 95)
    fg = ~bg
    lab, n = nd.label(fg)
    sizes = [int((lab == i).sum()) for i in range(1, n + 1)]
    main_id = int(np.argmax(sizes)) + 1
    fg = lab == main_id

    out = np.zeros((raw_rgb.shape[0], raw_rgb.shape[1], 4), dtype=np.uint8)
    out[fg, :3] = raw_rgb[fg]
    out[fg, 3] = 255

    # 2. Passe 1 & 2 : recoloration des pixels teintés magenta/lavande à <= 18 px de tout bord transparent
    #    (couvre aussi le liseré d'ombre du volant blanc juste au-dessus de l'ancien guichet #FF00FF)
    inside = nd.distance_transform_edt(fg)
    fringe = is_purple_fringe(out, max_dist=18.0)
    clean_donor = fg & (inside > 6.0) & (~is_purple_fringe(out, max_dist=99.0))
    recolored_px = 0
    if fringe.any() and clean_donor.any():
        idx = nd.distance_transform_edt(~clean_donor, return_distances=False, return_indices=True)
        out[fringe, :3] = out[tuple(idx[:, fringe])][:, :3]
        recolored_px += int(fringe.sum())

    # 3. Passe 3 : greffe d'anneau externe/interne (inside <= 2.2 px prend la couleur de son voisin propre à inside >= 3.5 px)
    ring = fg & (inside <= 2.2)
    donor_inner = fg & (inside >= 3.5) & (~is_purple_fringe(out, max_dist=99.0))
    if ring.any() and donor_inner.any():
        idx2 = nd.distance_transform_edt(~donor_inner, return_distances=False, return_indices=True)
        out[ring, :3] = out[tuple(idx2[:, ring])][:, :3]
        recolored_px += int(ring.sum())

    # 4. Vérification des trous transparents internes (ouverture du guichet vide sans noir !)
    filled = nd.binary_fill_holes(fg)
    holes = filled & (~fg)
    lab_h, nh = nd.label(holes)
    hole_areas = sorted([int((lab_h == i).sum()) for i in range(1, nh + 1)], reverse=True)
    main_hole_id = max(range(1, nh + 1), key=lambda i: int((lab_h == i).sum()))
    hy, hx = np.nonzero(lab_h == main_hole_id)
    stats = {
        'recolored_edge_pixels_hd': recolored_px,
        'residual_purple_fringe_hd': int(is_purple_fringe(out, max_dist=18.0).sum()),
        'window_hole_area_hd_px': hole_areas[0],
        'side_cutout_areas_hd_px': hole_areas[1:3],
        'window_bbox_hd': [int(hx.min()), int(hy.min()), int(hx.max()) + 1, int(hy.max()) + 1],
    }
    return out, stats


def normalize_1x(hd_rgba: np.ndarray) -> tuple[np.ndarray, dict]:
    """Réduit le kiosque détouré à l'échelle 1x PMD (Nearest pur, ratio exact conservé, canevas 112 x 120)."""
    op = hd_rgba[..., 3] == 255
    ys, xs = np.nonzero(op)
    x0, y0, x1, y1 = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1
    crop = Image.fromarray(hd_rgba[y0:y1, x0:x1])
    cw, ch = crop.size
    scale = min(MAX_VIS_1X[0] / cw, MAX_VIS_1X[1] / ch)
    nw, nh = int(round(cw * scale)), int(round(ch * scale))
    small = crop.resize((nw, nh), Image.NEAREST)

    tw, th = CANVAS_1X
    px0 = (tw - nw) // 2
    py0 = th - nh - 4  # base posée proprement à 4 px du bas du canevas 112x120
    canvas = Image.new('RGBA', (tw, th), (0, 0, 0, 0))
    canvas.alpha_composite(small, (px0, py0))
    arr = np.array(canvas)
    arr[arr[..., 3] < 128] = 0
    arr[arr[..., 3] >= 128, 3] = 255

    # Localisation exacte de l'ouverture du guichet à 1x pour couper proprement arriere / avant
    fg1 = arr[..., 3] == 255
    holes1 = nd.binary_fill_holes(fg1) & (~fg1)
    lh1, nh1 = nd.label(holes1)
    hid1 = max(range(1, nh1 + 1), key=lambda i: int((lh1 == i).sum()))
    hy1, hx1 = np.nonzero(lh1 == hid1)
    win_box_1x = [int(hx1.min()), int(hy1.min()), int(hx1.max()) + 1, int(hy1.max()) + 1]
    split_y = int(hy1.max()) + 1  # ligne exacte du rebord supérieur du comptoir avant !

    info = {
        'canvas_size': [tw, th],
        'visible_size': [nw, nh],
        'offset_in_canvas': [px0, py0],
        'source_crop_hd': [x0, y0, x1, y1],
        'window_open_bbox_1x': win_box_1x,
        'window_open_area_1x_px': int((lh1 == hid1).sum()),
        'counter_split_y_1x': split_y,
        'npc_feet_local_px': [tw // 2, split_y + 14],
        'customer_marker_local_px': [tw // 2, th + 8],
        'counter_collision_local_px': [px0 + 12, split_y, nw - 24, th - split_y - 4],
    }
    return arr, info


def apply_v8_night(rgba_arr: np.ndarray) -> np.ndarray:
    """Applique exactement la loi nocturne de Spinda V8 ([0.42, 0.35, 0.40], alpha strictement identique)."""
    out = rgba_arr.copy()
    op = out[..., 3] == 255
    out[op, :3] = np.clip(np.round(out[op, :3].astype(float) * NIGHT_FACTORS[None, :]), 0, 255).astype(np.uint8)
    return out


def make_tilesheet(items: list[tuple[str, np.ndarray]]) -> tuple[np.ndarray, list[dict]]:
    """Assemble une planche d'import 1x alignée sur la grille 8 px avec marge de 8 px entre modules."""
    pad = 8
    total_w = pad + sum(a.shape[1] + pad for _, a in items)
    total_w = ((total_w + 7) // 8) * 8
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
    gfx = loadmod('pmdo_codec_kkr1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_kkr1', R / 'source/pmdo_cote/INSTALLER.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for sub in ('hd', 'assets_1x', 'tilesheets', 'apercus'):
        (OUT / sub).mkdir(parents=True, exist_ok=True)
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / 'Content/Tile').mkdir(parents=True, exist_ok=True)

    raw_im = Image.open(RAW).convert('RGB')
    hd_clean, hd_stats = cutout_and_purge_magenta(np.array(raw_im))

    # 1. Exports HD (1024 x 1024 transparent + aperçu sur fond neutre chaud #3a3028 sans damier)
    Image.fromarray(hd_clean).save(OUT / 'hd/Kiosque_Kirlia_HD_sans_magenta.png', optimize=True)
    hd_neutral = Image.new('RGBA', raw_im.size, NEUTRAL_BG)
    hd_neutral.alpha_composite(Image.fromarray(hd_clean))
    hd_neutral.convert('RGB').save(OUT / 'apercus/Kiosque_Kirlia_HD_fond_neutre.png', optimize=True)

    # 2. Normalisation 1x Ground (112 x 120) + découpe disjointe arriere / avant + mode Nuit V8
    full_1x, norm_info = normalize_1x(hd_clean)
    split_y = norm_info['counter_split_y_1x']
    back_1x = full_1x.copy()
    back_1x[split_y:, :] = 0
    front_1x = full_1x.copy()
    front_1x[:split_y, :] = 0

    full_1x_night = apply_v8_night(full_1x)
    back_1x_night = apply_v8_night(back_1x)
    front_1x_night = apply_v8_night(front_1x)

    assets_1x = {
        'Kiosque_Kirlia_1x_complet.png': full_1x,
        'Kiosque_Kirlia_1x_arriere.png': back_1x,
        'Kiosque_Kirlia_1x_avant.png': front_1x,
        'Kiosque_Kirlia_1x_nuit_complet.png': full_1x_night,
        'Kiosque_Kirlia_1x_nuit_arriere.png': back_1x_night,
        'Kiosque_Kirlia_1x_nuit_avant.png': front_1x_night,
    }
    for fname, arr in assets_1x.items():
        Image.fromarray(arr).save(OUT / 'assets_1x' / fname, optimize=True)

    # Planche comparative 4x sur fond neutre chaud #3a3028 (complet, arrière, avant, nuit V8)
    sheet_day, rects_day = make_tilesheet([
        ('kirlia_kiosque_complet', full_1x),
        ('kirlia_kiosque_arriere', back_1x),
        ('kirlia_kiosque_avant', front_1x),
    ])
    sheet_night, rects_night = make_tilesheet([
        ('kirlia_kiosque_nuit_complet', full_1x_night),
        ('kirlia_kiosque_nuit_arriere', back_1x_night),
        ('kirlia_kiosque_nuit_avant', front_1x_night),
    ])
    Image.fromarray(sheet_day).save(OUT / 'tilesheets/Spinda_kirlia_kiosque_jour.png', optimize=True)
    Image.fromarray(sheet_night).save(OUT / 'tilesheets/Spinda_kirlia_kiosque_nuit.png', optimize=True)

    preview_strip = Image.new('RGBA', (sheet_day.shape[1] * 3, sheet_day.shape[0] * 3), NEUTRAL_BG)
    preview_strip.alpha_composite(
        Image.fromarray(sheet_day).resize((sheet_day.shape[1] * 3, sheet_day.shape[0] * 3), Image.NEAREST)
    )
    preview_strip.convert('RGB').save(OUT / 'apercus/Planche_Kiosque_Kirlia_3x_fond_neutre.png', optimize=True)

    # 3. Compilation des banques natives `.tile` + `index.idx` PMDO 0.8.12
    bank_specs = [
        (f'{PFX}_00_ARRIERE', back_1x),
        (f'{PFX}_01_AVANT', front_1x),
        (f'{PFX}_02_COMPLET', full_1x),
        (f'{PFX}_03_NUIT', full_1x_night),
    ]
    tiles_per_bank = {}
    for bname, barr in bank_specs:
        bank = gfx.TileBank(bname, preserve_layout=True)
        h_b, w_b = barr.shape[:2]
        for gy in range(h_b // 8):
            for gx in range(w_b // 8):
                bank.add(Image.fromarray(barr[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8]), gx, gy)
        bank.write(STAGE / f'Content/Tile/{bname}.tile')
        tiles_per_bank[bname] = len(bank.data)

    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Kiosque Kirlia - Cafe Spinda (KKR1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Kiosque Kirlia detoure sans magenta, guichet transparent sans noir, comptoir bois sans feuille ni cafe (jour/nuit, arriere/avant).</Description>
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

    manifest = {
        'id': 'kiosque_kirlia_spinda_v1',
        'prefix': PFX,
        'title': 'Kiosque Kirlia — Café Spinda (HD + Ground 1x jour/nuit + plans arrière/avant)',
        'nature': 'Objet généré référencé sur le prototype kiosque PMD, le comptoir natif Spinda EoSO et le portrait Kirlia #0281 ; détouré sans aucun magenta ni noir dans le guichet, comptoir nu sans feuille ni café/tasse. Pas un sprite natif certifié.',
        'art_approved': False,
        'raw_inputs': [
            {
                'file': RAW.relative_to(R).as_posix(),
                'size': list(raw_im.size),
                'sha256': sha(RAW),
                'role': 'Brut retenu édité : intérieur du guichet en #FF00FF pur (sans noir), comptoir bois nu (sans feuille ni café).',
            },
            {
                'file': ECARTE_V1.relative_to(R).as_posix(),
                'size': list(Image.open(ECARTE_V1).size),
                'sha256': sha(ECARTE_V1),
                'role': 'Essai V1 archivé (choisi par l utilisateur sur la silhouette, écarté car fond de guichet noir + feuille et tasse sur le comptoir).',
            },
        ],
        'references': [
            {'file': REF_ARCANIN.relative_to(R).as_posix(), 'sha256': sha(REF_ARCANIN)},
            {'file': REF_SPINDA.relative_to(R).as_posix(), 'sha256': sha(REF_SPINDA)},
            {'file': REF_KIRLIA.relative_to(R).as_posix(), 'sha256': sha(REF_KIRLIA)},
        ],
        'detourage': hd_stats,
        'normalization_1x': norm_info,
        'tilesheets': {
            'jour': {'file': 'tilesheets/Spinda_kirlia_kiosque_jour.png', 'rects': rects_day},
            'nuit': {'file': 'tilesheets/Spinda_kirlia_kiosque_nuit.png', 'rects': rects_night},
        },
        'pmdo': {
            'target': '0.8.12',
            'runtime_tested': False,
            'namespace': NAMESPACE,
            'tiles_per_bank': tiles_per_bank,
        },
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(f'OK {PFX}: HD hole={hd_stats["window_hole_area_hd_px"]} px, fringe={hd_stats["residual_purple_fringe_hd"]} px, 1x={norm_info["visible_size"]} in {norm_info["canvas_size"]}')


if __name__ == '__main__':
    build()
