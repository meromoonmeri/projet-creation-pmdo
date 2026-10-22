"""Fin Traversée Cristal V1 — Lac Cristallin (FTX1, format 4:3 vaste 768 x 576 px, 96 x 72 cases).

Références canoniques : captures ROM exactes `D17P33A.png` (pont sur le lac cristallin) et `D17P45A.png`
(arène sanctuaire cristalline) + tables BPA exactes `d17p33a1.bpa` (6 x 10 = 60 ticks) et `d17p33a5.bpa`
(4 x 10 = 40 ticks) issues de `pret/pmd-sky@c8073235` -> boucle polymétrique PPCM(60, 40) = 120 ticks (12 x 10 ticks).
"""
from __future__ import annotations

import hashlib, importlib.util, io, json, math, shutil, uuid, xml.etree.ElementTree as ET, zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_33 = HERE / 'references/D17P33A.png'
REF_45 = HERE / 'references/D17P45A.png'
REF_SOL_CROP = HERE / 'references/D17P45A_sol_crop.png'
REF_BPA_JSON = HERE / 'references/rom_bpa_palettes.json'
BPA_DIR = HERE / 'references/d17p33a_frames'
OUT = R / 'renders/fin_traversee_cristal_v1'
STAGE = R / '.cache/fin_traversee_cristal_v1/fin_traversee_cristal'

PFX = 'FTX1'
NAMESPACE = 'fin_traversee_cristal'
ASSET = 'ftx1_fin_traversee_cristal'
W, H = 768, 576
SRC = (1200, 896)
N_BPA1 = 6
N_BPA5 = 4
TICKS = 10
SCENE_LOOP = math.lcm(N_BPA1 * TICKS, N_BPA5 * TICKS)  # 120 ticks = 12 x 10 ticks
N_PHASES = SCENE_LOOP // TICKS  # 12 phases

STATIC = ['eau_lac', 'pont_cristal', 'dalles_sanctuaire', 'ilots_cristal', 'parois_cristal', 'piliers_nord', 'autel_cristal']
ANIMS = ['caustiques_lac', 'lueur_pont_et_eclats']
PALETTE_GROUPS = {
    'pont_et_sol': (['sol_complet', 'pont_cristal', 'dalles_sanctuaire'], 64),
    'eau': (['eau_lac'], 48),
    'cristaux': (['ilots_cristal', 'parois_cristal', 'piliers_nord', 'autel_cristal'], 64),
}


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_for_ftx1', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def materials_pair(ref33: np.ndarray, ref45: np.ndarray, raw_a: np.ndarray) -> dict[str, dict]:
    """Compare chaque famille de matériaux contre sa référence ROM canonique directe (< 35 RVB)."""
    dist_rgb = lambda x, y: round(float(np.linalg.norm(np.asarray(x, float) - np.asarray(y, float))), 2)
    l33, l45, la = lum_of(ref33), lum_of(ref45), lum_of(raw_a)
    yy_a, _ = np.mgrid[0:raw_a.shape[0], 0:raw_a.shape[1]]

    # 1. Eau profonde du lac (D17P33A canaux gauche/droite vs bas gauche/droite de decor.png)
    ref_water = ref33[:, :110][l33[:, :110] < 130.0].mean(0)
    raw_water = raw_a[(yy_a > 500) & (la < 126.0)].mean(0)

    # 2. Dalles luminescentes du pont & sanctuaire (D17P45A centre vs esplanade centrale de decor.png)
    ref_plaza = ref45[210:360, 210:485].reshape(-1, 3).mean(0)
    raw_plaza = raw_a[280:560, 380:820][la[280:560, 380:820] > 150.0].mean(0)

    # 3. Parois et grands piliers facettés du nord (D17P45A couronne haute vs haut de decor.png)
    ref_crown = ref45[:175, :].reshape(-1, 3).mean(0)
    raw_crown = raw_a[:235, :].reshape(-1, 3).mean(0)

    return {
        'eau_lac': {'ref_rgb': [round(float(v), 1) for v in ref_water], 'mean_rgb': [round(float(v), 1) for v in raw_water], 'distance': dist_rgb(raw_water, ref_water)},
        'dalles_cristal': {'ref_rgb': [round(float(v), 1) for v in ref_plaza], 'mean_rgb': [round(float(v), 1) for v in raw_plaza], 'distance': dist_rgb(raw_plaza, ref_plaza)},
        'couronne_cristal': {'ref_rgb': [round(float(v), 1) for v in ref_crown], 'mean_rgb': [round(float(v), 1) for v in raw_crown], 'distance': dist_rgb(raw_crown, ref_crown)},
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Segmentation haute résolution (1200 x 896) garantissant un cul-de-sac nord fermé >= 14 rangées 8px."""
    lum = lum_of(a)
    hr, wr = lum.shape
    yy, xx = np.mgrid[0:hr, 0:wr]

    # Couronne nord strictement fermée (y < 248 en 1200x896 => y < 158 en 768x576 => >= 19 rangées 8px fermées !)
    walk_cand = (yy >= 248) & (lum >= 134.0)
    # Exclure les grands piliers latéraux et amas du haut
    walk_cand &= ~((yy < 470) & ((xx < 250) | (xx > 950)))
    walk_cand &= ~((yy >= 470) & ((xx < 470) | (xx > 730)) & (yy > 560))
    lab_w, _ = nd.label(walk_cand)
    south_seed = np.unique(lab_w[hr - 24:, 500:700])
    south_seed = south_seed[south_seed > 0]
    floor = np.isin(lab_w, south_seed)

    # Eau saphir du lac dans la moitié sud hors pont central
    lake_zone = (~floor) & (yy >= 490) & ((xx < 525) | (xx > 675))
    eau_lac = keep_large(lake_zone & (lum < 132.0), 400)
    ilots_cristal = (~floor) & (~eau_lac) & (yy >= 500) & ((xx < 475) | (xx > 725))

    rem = (~floor) & (~eau_lac) & (~ilots_cristal)
    autel_cristal = rem & (yy >= 150) & (yy < 268) & (xx >= 470) & (xx <= 730)
    piliers_nord = rem & (~autel_cristal) & (lum > 168.0) & (yy < 450)
    parois_cristal = rem & (~autel_cristal) & (~piliers_nord)

    return {
        'eau_lac': eau_lac,
        'ilots_cristal': ilots_cristal,
        'autel_cristal': autel_cristal,
        'piliers_nord': piliers_nord,
        'parois_cristal': parois_cristal,
        'pont_cristal': floor & (yy >= 545),
        'dalles_sanctuaire': floor & (yy < 545),
    }


def extract_clean_poses(sheet_a: np.ndarray) -> tuple[list[np.ndarray], list[np.ndarray]]:
    """Extrait 4 éclats diamant (ligne haute) et 4 ondes d'eau turquoise (ligne basse) avec 0 px magenta."""
    f = sheet_a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    fringe = ((r - g > 14.0) & (b - g > 14.0)) | (r > g + 8.0)
    valid = ~fringe
    hs, ws = r.shape

    def row_boxes(y0: int, y1: int):
        band = np.zeros_like(valid)
        band[y0:y1, :] = valid[y0:y1, :]
        band = nd.binary_erosion(band, iterations=1)
        lab, n = nd.label(close_(band, 2))
        bxs = []
        for i in range(1, n + 1):
            if int((lab == i).sum()) > 700:
                ys, xs = np.nonzero(lab == i)
                bxs.append((int(xs.mean()), int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1, lab == i))
        bxs.sort(key=lambda t: t[0])
        return bxs

    glints = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(row_boxes(0, hs // 3 + 30)[:4]):
        sub = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
        mm = m[y0:y1, x0:x1] & valid[y0:y1, x0:x1]
        sub[mm, :3] = sheet_a[y0:y1, x0:x1][mm].astype(np.uint8)
        sub[mm, 3] = 255
        sz = [(9, 9), (11, 11), (11, 11), (9, 9)][idx]
        arr = np.array(Image.fromarray(sub).resize(sz, Image.NEAREST))
        arr[arr[..., 3] < 128] = 0
        arr[arr[..., 3] >= 128, 3] = 255
        op = arr[..., 3] > 0
        arr[op & (arr[..., 0].astype(int) > arr[..., 1].astype(int) + 6)] = 0
        glints.append(arr)

    ripples = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(row_boxes(hs // 3 + 30, hs)[:4]):
        sub = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
        mm = m[y0:y1, x0:x1] & valid[y0:y1, x0:x1]
        sub[mm, :3] = sheet_a[y0:y1, x0:x1][mm].astype(np.uint8)
        sub[mm, 3] = 255
        sz = [(12, 10), (16, 12), (20, 14), (22, 15)][idx]
        arr = np.array(Image.fromarray(sub).resize(sz, Image.NEAREST))
        arr[arr[..., 3] < 128] = 0
        arr[arr[..., 3] >= 128, 3] = 255
        op = arr[..., 3] > 0
        arr[op & (arr[..., 0].astype(int) > arr[..., 1].astype(int) + 6)] = 0
        ripples.append(arr)
    return glints, ripples


def build_rom_caustics_and_shimmer_frames(
    water_layer: np.ndarray,
    bridge_layer: np.ndarray,
    plaza_layer: np.ndarray,
    ex: dict[str, np.ndarray],
    bpa_frames_dir: Path,
    glints: list[np.ndarray],
    ripples: list[np.ndarray],
) -> tuple[list[np.ndarray], list[np.ndarray], list[list[int]]]:
    """Extrait les tables de couleurs réelles des 6 phases d'eau (d17p33a1.bpa, 60 ticks) et des 4 phases de
    pont cristallin (d17p33a5.bpa, 40 ticks) depuis les frames ROM exactes de D17P33A pour piloter le cycle
    polymétrique 12 x 10 = 120 ticks.
    """
    rom_frames = [np.array(Image.open(bpa_frames_dir / f'frame_{i:02d}.png').convert('RGB')) for i in range(N_PHASES)]

    # Palette caustique exacte sur les 6 premières poses (cycle 6 x 10 = 60 ticks de d17p33a1.bpa)
    water_pal6 = []
    for k in range(N_BPA1):
        rf = rom_frames[k][:, :108]
        wl = lum_of(rf)
        qs_w = np.quantile(wl, [0.22, 0.45, 0.68, 0.86, 0.96])
        bands = []
        for bi in range(6):
            lo = -1.0 if bi == 0 else qs_w[bi - 1]
            hi = 999.0 if bi == 5 else qs_w[bi]
            bands.append(rf[(wl > lo) & (wl <= hi)].mean(0).round().astype(np.uint8).tolist())
        water_pal6.append(bands)

    # Palette réfraction exacte sur les 4 premières poses (cycle 4 x 10 = 40 ticks de d17p33a5.bpa)
    bridge_pal4 = []
    for k in range(N_BPA5):
        rf = rom_frames[k][:, 192:264]
        bl = lum_of(rf)
        qs_b = np.quantile(bl, [0.20, 0.44, 0.68, 0.88])
        bands = []
        for bi in range(5):
            lo = -1.0 if bi == 0 else qs_b[bi - 1]
            hi = 999.0 if bi == 4 else qs_b[bi]
            bands.append(rf[(bl > lo) & (bl <= hi)].mean(0).round().astype(np.uint8).tolist())
        bridge_pal4.append(bands)

    # Réseau caustique du lac + ondes concentriques
    wlum = lum_of(water_layer)
    wmask = ex['eau_lac']
    w_thr = float(np.percentile(wlum[wmask], 58))
    caustic_veins = keep_large(wmask & (wlum >= w_thr), 6)
    w_vals = wlum[caustic_veins]
    w_qs = np.quantile(w_vals, [0.20, 0.40, 0.60, 0.80, 0.93])
    w_ranks = np.searchsorted(w_qs, w_vals)
    yy_g, xx_g = np.mgrid[0:H, 0:W]
    wave_phase = ((xx_g[caustic_veins] // 12 + yy_g[caustic_veins] // 10) % N_BPA1)

    ys_w, xs_w = np.nonzero(nd.binary_erosion(wmask, iterations=6))
    ripple_spots = []
    for rx0, ry0 in [(120, 430), (648, 435), (210, 505), (558, 500)]:
        idx = int(np.argmin((xs_w - rx0) ** 2 + (ys_w - ry0) ** 2))
        ripple_spots.append([int(xs_w[idx]), int(ys_w[idx])])

    water_frames = []
    for t in range(N_PHASES):
        pal_row = water_pal6[t % N_BPA1]
        shifted_rk = (w_ranks + ((t % N_BPA1) + wave_phase) % 2) % 6
        fr = np.zeros((H, W, 4), np.uint8)
        fr[caustic_veins, :3] = np.array([pal_row[rk] for rk in shifted_rk], dtype=np.uint8)
        fr[caustic_veins, 3] = 255
        canvas = Image.fromarray(fr)
        for ri, (rx, ry) in enumerate(ripple_spots):
            k = (t - (ri * 3) % N_PHASES) % N_PHASES
            if k < len(ripples):
                rp = Image.fromarray(ripples[k])
                canvas.alpha_composite(rp, (rx - rp.width // 2, ry - rp.height // 2))
        water_frames.append(np.array(canvas))

    # Lueur du pont et de l'esplanade (cycle 4 phases) + éclats diamant sur les piliers
    comb_floor = np.maximum(bridge_layer, plaza_layer)
    flum = lum_of(comb_floor)
    fmask = ex['pont_cristal'] | ex['dalles_sanctuaire']
    facets = keep_large(fmask & (flum >= float(np.percentile(flum[fmask], 64))), 8)
    f_vals = flum[facets]
    f_qs = np.quantile(f_vals, [0.25, 0.50, 0.75, 0.92])
    f_ranks = np.searchsorted(f_qs, f_vals)
    f_wave = ((yy_g[facets] // 16) % N_BPA5)

    ys_p, xs_p = np.nonzero(ex['piliers_nord'] | ex['autel_cristal'])
    sparkle_spots = []
    for sx0, sy0 in [(384, 128), (225, 118), (542, 118), (64, 210), (704, 210), (310, 145), (458, 145), (384, 96)]:
        idx = int(np.argmin((xs_p - sx0) ** 2 + (ys_p - sy0) ** 2))
        sparkle_spots.append([int(xs_p[idx]), int(ys_p[idx])])

    shimmer_frames = []
    for t in range(N_PHASES):
        prow = bridge_pal4[t % N_BPA5]
        prk = np.clip(f_ranks + (((t % N_BPA5) + f_wave) % 2) - 1, 0, 4)
        fr = np.zeros((H, W, 4), np.uint8)
        fr[facets, :3] = np.array([prow[rk] for rk in prk], dtype=np.uint8)
        fr[facets, 3] = 255
        canvas = Image.fromarray(fr)
        for si, (sx, sy) in enumerate(sparkle_spots):
            k = (t - (si * 3) % N_PHASES) % N_PHASES
            if k < len(glints):
                sp = Image.fromarray(glints[k])
                canvas.alpha_composite(sp, (sx - sp.width // 2, sy - sp.height // 2))
        shimmer_frames.append(np.array(canvas))

    return water_frames, shimmer_frames, sparkle_spots


def write_ora(path: Path, layers: dict[str, np.ndarray], comment: str) -> None:
    root = ET.Element('image', version='0.0.5', w=str(W), h=str(H), xres='72', yres='72')
    ET.SubElement(root, 'comment').text = comment
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0',
                          visibility='visible', **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256))
        b = io.BytesIO(); th.save(b, format='PNG'); z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked: np.ndarray, entry_px: list[int], boss_px: list[int], objectif_px: list[int], gfx, tools) -> dict[str, int]:
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text())
    o = tpl['Object']
    gw, gh = W // 8, H // 8
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y * 8:y * 8 + 8, x * 8:x * 8 + 8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(
        Name={'DefaultText': 'Fin Traversee Cristal - Lac Cristallin (4:3)', 'LocalTexts': {'fr': 'Fin Traversée Cristal — Lac Cristallin'}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur D17P33A + D17P45A ; cycle polymetrique exact BPA 60x40=120 ticks. Aucun test runtime PMDO.',
    )
    o['obstacles'] = [[{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Traversee Cristal - Lac Cristallin 4:3 (FTX1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : pont cristallin sur le lac caustique et sanctuaire nord ferme (ref. ROM D17P33A + D17P45A).</Description>
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
    return {b.name: len(b.data) for b in banks}


def find_marker_16x16(blocked: np.ndarray, target_xy_cell: tuple[int, int], y_range: range) -> list[int]:
    tx, ty = target_xy_cell
    best = None
    for y in y_range:
        for x in range(4, blocked.shape[1] - 6):
            if not blocked[y:y + 2, x:x + 2].any():
                d = (x - tx) ** 2 + (y - ty) ** 2
                if best is None or d < best[0]:
                    best = (d, x, y)
    assert best is not None, f'Aucune zone 16x16 praticable trouvée près de {target_xy_cell}'
    return [int(best[1] * 8), int(best[2] * 8)]


def build() -> None:
    gfx = loadmod('pmdo_codec_ftx1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_ftx1', R / 'source/pmdo_cote/INSTALLER.py')
    esn = loadmod('esn1_ftx1', R / 'source/entree_sud_nord_generee_v1/build.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref33, ref45 = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF_33), rgb(REF_45)
    parts = rgb(RAW / 'particules_poses.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    bpa_meta = json.loads(REF_BPA_JSON.read_text())

    # 1. Segmentation haute résolution -> 768 x 576
    m_full = classify_fullres(a)
    order = ['eau_lac', 'ilots_cristal', 'autel_cristal', 'piliers_nord', 'parois_cristal', 'pont_cristal', 'dalles_sanctuaire']
    ex, cols = down_class(a, m_full, order)

    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 2. Cul-de-sac fermé au nord (>= 18 rangées) + chemin 16x16 entrance -> boss -> objectif
    cand = ex['pont_cristal'] | ex['dalles_sanctuaire']
    cl, _ = nd.label(cand)
    ys_all = np.nonzero(cand.any(1))[0]
    seed = cl[ys_all.max()][cand[ys_all.max()]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    blocked = cell_grid(~walk)
    closed_north_rows = int(np.argmax((~blocked).any(axis=1)))
    assert closed_north_rows >= 14, f'Couronne nord insuffisamment fermée: {closed_north_rows}'
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    entry_px = find_marker_16x16(blocked, (48, 67), range(62, 70))
    boss_px = find_marker_16x16(blocked, (48, 30), range(26, 36))
    objectif_px = find_marker_16x16(blocked, (48, 22), range(19, 26))
    ok_boss, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    ok_obj, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert ok_boss and ok_obj, f'Chemin 16x16 introuvable: entry={entry_px} boss={boss_px} obj={objectif_px}'

    # 3. Poses purgées + animations polymétriques ROM D17P33A (60 x 40 = 120 ticks)
    glints, ripples = extract_clean_poses(parts)
    all_poses = [('eclat', g) for g in glints] + [('onde', r_) for r_ in ripples]
    pose_strip = Image.new('RGBA', (sum(p.shape[1] + 8 for _, p in all_poses) + 8, max(p.shape[0] for _, p in all_poses) + 8), (0, 0, 0, 0))
    ox = 4
    for idx_p, (kind, p_arr) in enumerate(all_poses):
        Image.fromarray(p_arr).save(OUT / 'poses' / f'{PFX}_pose_{idx_p:02d}_{kind}.png')
        pose_strip.alpha_composite(Image.fromarray(p_arr), (ox, 4))
        ox += p_arr.shape[1] + 8
    pose_strip.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    water_frames, shimmer_frames, sparkle_spots = build_rom_caustics_and_shimmer_frames(
        layers['eau_lac'], layers['pont_cristal'], layers['dalles_sanctuaire'], ex, BPA_DIR, glints, ripples
    )
    anim_map = {
        'caustiques_lac': water_frames,
        'lueur_pont_et_eclats': shimmer_frames,
    }

    order_names = ['sol_complet'] + STATIC + ANIMS
    layer_list = []
    stack_named = []
    for i, nm in enumerate(order_names):
        if nm in anim_map:
            frs = anim_map[nm]
            for t, fr in enumerate(frs):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'id': nm, 'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frs), 'ticks': TICKS})
            stack_named.append((nm, frs, TICKS))
        else:
            fr = layers[nm]
            Image.fromarray(fr).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'id': nm, 'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
            stack_named.append((nm, [fr], 60))

    scenes = []
    for t in range(N_PHASES):
        im = Image.new('RGBA', (W, H))
        for _, frs, _ in stack_named:
            im.alpha_composite(Image.fromarray(frs[t if len(frs) > 1 else 0]))
        scenes.append(im)
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(TICKS * 1000 / 60), loop=0, lossless=True)

    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 45, 45, 95))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 95, 160, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    ov.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    write_ora(
        OUT / f'{PFX}_fin_traversee_cristal_calques.ora',
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
        comment='Fin Traversee Cristal - Lac Cristallin (D17P33A + D17P45A)',
    )
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, boss_px, objectif_px, gfx, tools,
    )

    # 5. Fidélité chromatique mesurée contre les captures ROM D17P33A et D17P45A (< 35 sur chaque matériau)
    dist_rgb = lambda x, y: round(float(np.linalg.norm(np.asarray(x, float) - np.asarray(y, float))), 2)
    raw_fid = materials_pair(ref33, ref45, a)

    l33, l45 = lum_of(ref33), lum_of(ref45)
    ref_targets = {
        'eau_lac': ref33[:, :110][l33[:, :110] < 130.0].mean(0),
        'pont_cristal': ref33[:, 196:260].reshape(-1, 3).mean(0),
        'dalles_sanctuaire': ref45[210:360, 210:485].reshape(-1, 3).mean(0),
        'ilots_cristal': ref33[:, :160][l33[:, :160] >= 165.0].mean(0),
        'parois_cristal': ref45[:175, :][l45[:175, :] <= 185.0].mean(0),
        'piliers_nord': ref45[110:215, 130:565][l45[110:215, 130:565] > 180.0].mean(0),
        'autel_cristal': ref45[105:195, 290:406][l45[105:195, 290:406] <= 190.0].mean(0),
    }
    final_fid = {}
    for k in STATIC:
        fin_lay = layers[k]
        fin_px = fin_lay[fin_lay[..., 3] > 0][:, :3].mean(0)
        final_fid[k] = {
            'mean_rgb': [round(float(v), 1) for v in fin_px],
            'ref_rgb': [round(float(v), 1) for v in ref_targets[k]],
            'distance_rip': dist_rgb(fin_px, ref_targets[k]),
        }
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), ref45[210:360, 210:485].reshape(-1, 3).mean(0))

    manifest = {
        'id': 'fin_traversee_cristal_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_codes': ['D17P33A', 'D17P45A'],
            'dungeon_fr': 'Traversée Cristal — Lac Cristallin',
            'dungeon_en': 'Crystal Crossing — Crystal Lake Sanctuary',
            'pmd_sky_commit': bpa_meta['pmd_sky_commit'],
            'reference_png': REF_33.relative_to(R).as_posix(),
            'reference_boss_png': REF_45.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_33),
            'reference_boss_sha256': sha(REF_45),
            'rom_bpa_slots': {
                'd17p33a1_eau': {'frames': N_BPA1, 'ticks': TICKS, 'loop_ticks': N_BPA1 * TICKS},
                'd17p33a5_pont': {'frames': N_BPA5, 'ticks': TICKS, 'loop_ticks': N_BPA5 * TICKS},
                'polymetric_loop_ticks': SCENE_LOOP,
            },
        },
        'nature': 'Décor généré référencé sur les captures ROM D17P33A et D17P45A (pas des tuiles natives certifiées) ; caustiques du lac (6 x 10 = 60 ticks) et réfraction du pont cristallin (4 x 10 = 40 ticks) calées sur d17p33a1.bpa + d17p33a5.bpa (boucle 120 ticks).',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_33.relative_to(R).as_posix(), REF_45.relative_to(R).as_posix()]},
            {'file': (RAW / 'sol_complet.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'sol_complet.png').size),
             'sha256': sha(RAW / 'sol_complet.png'), 'images': [REF_SOL_CROP.relative_to(R).as_posix(), REF_33.relative_to(R).as_posix()]},
            {'file': (RAW / 'particules_poses.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'particules_poses.png').size),
             'sha256': sha(RAW / 'particules_poses.png'), 'images': [REF_33.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'sparkle_points': sparkle_spots,
        'access': {
            'entry_px': entry_px,
            'boss_px': boss_px,
            'objectif_px': objectif_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(ok_boss and ok_obj),
            'closed_north_rows': closed_north_rows,
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': raw_fid, 'calques_finaux': final_fid, 'sol_complet': sol_fid},
        'pmdo': {'target': '0.8.12', 'runtime_tested': False, 'asset_name': ASSET, 'namespace': NAMESPACE,
                 'tex_size': 1, 'tiles_per_bank': counts},
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, north_closed={closed_north_rows}, entry={entry_px}, boss={boss_px}, obj={objectif_px}, sol_dist={sol_fid}')


if __name__ == '__main__':
    build()
