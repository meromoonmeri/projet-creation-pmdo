"""Entrée Traversée Cristal sud -> nord V1 (ETX1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique : capture ROM exacte `D17P11A.png` (600 x 480, `pret/pmd-sky@c8073235`) + tables BPL
exactes `d17p11a.bpl` (Palettes 8 et 9 : 19 poses x 4 ticks = 76 ticks).

10 calques exportés + `Top` vide (`Layer = 4`) dans le Ground PMDO 0.8.12 :
- `00 sol_complet`, `01 ardoise_sombre`, `02 pierre_turquoise`, `03 dalles_cristal`,
  `04 rochers`, `05 parois`, `06 cristaux`, `07 profondeur` ;
- `08 lueur_sanctuaire` (19 x 4 ticks : table RVB exacte Palette 8 de `d17p11a.bpl`) ;
- `09 reflets_et_poussiere` (19 x 4 ticks : table RVB exacte Palette 9 de `d17p11a.bpl` + poses générées purgées).
"""
from __future__ import annotations

import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_PNG = HERE / 'references/D17P11A.png'
REF_SOL_CROP = HERE / 'references/D17P11A_sol_crop.png'
REF_BPL_JSON = HERE / 'references/rom_bpl_palettes.json'
OUT = R / 'renders/entree_traversee_cristal_sud_nord_v1'
STAGE = R / '.cache/entree_traversee_cristal_sud_nord_v1/entree_traversee_cristal_sud_nord'

PFX = 'ETX1'
NAMESPACE = 'entree_traversee_cristal_sud_nord'
ASSET = 'etx1_entree_traversee_cristal'
W, H = 768, 576
SRC = (1200, 896)
N_PHASES = 19
TICKS = 4
SCENE_LOOP = N_PHASES * TICKS  # 76 ticks (exacte durée Palettes 8 & 9 de d17p11a.bpl)

STATIC = ['ardoise_sombre', 'pierre_turquoise', 'dalles_cristal', 'rochers', 'parois', 'cristaux', 'profondeur']
ANIMS = ['lueur_sanctuaire', 'reflets_et_poussiere']
PALETTE_GROUPS = {
    'sol_teal': (['sol_complet', 'ardoise_sombre', 'pierre_turquoise'], 64),
    'dalles': (['dalles_cristal'], 48),
    'roche': (['rochers', 'parois'], 64),
    'cristal': (['cristaux'], 64),
    'bouche': (['profondeur'], 24),
}


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_for_etx1', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def materials(arr: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur matière identique appliqué des deux côtés (capture ROM D17P11A et décor ETX1)."""
    f = arr[..., :3].astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    lum = lum_of(f)
    cyan = (g - r > 26.0) & (b - r > 32.0)
    return {
        'cristal_clair': cyan & (lum > 148.0),
        'sol_turquoise': cyan & (lum <= 148.0),
        'roche_claire': (~cyan) & (lum > 72.0),
        'paroi_sombre': (~cyan) & (lum <= 72.0),
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Segmentation sur le brut 1200 x 896 AVANT réduction vers 768 x 576."""
    f = a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    lum = lum_of(f)
    hr, wr = lum.shape
    yy, xx = np.mgrid[0:hr, 0:wr]

    # 1. Arche sombre du portail cristallin central (x=[515..685], y=[320..455])
    mouth_zone = (yy >= 320) & (yy <= 456) & (xx >= 515) & (xx <= 685)
    mouth_raw = close_(mouth_zone & (b - g > 16.0) & (lum < 56.0), 2)
    mouth = nd.binary_fill_holes(keep_large(mouth_raw, 1200))

    # 2. Uniquement les vrais piliers hexagonaux dressés et touffes latérales (0 pixel du halo plat au sol !)
    left_shaft = (xx >= 416) & (xx <= 496) & (yy >= 345) & (yy + 0.58 * np.abs(xx - 456) <= 534)
    right_shaft = (xx >= 704) & (xx <= 784) & (yy >= 345) & (yy + 0.58 * np.abs(xx - 744) <= 534)
    central_spires = (xx >= 385) & (xx <= 815) & (yy <= 458) & (((g - r > 18.0) & (lum > 118.0)) | (lum > 142.0))
    side_clusters = (np.abs(xx - 600) > 235) & (((g - r > 18.0) & (lum > 134.0)) | (lum > 152.0))
    stepping_stones = (yy >= 456) & (xx >= 520) & (xx <= 680) & (lum > 182.0)
    crystal = (~mouth) & keep_large(left_shaft | right_shaft | central_spires | side_clusters, 35)

    # 3. Sol praticable connecté au couloir sud (halo turquoise complet sans aucune coupure !)
    teal_floor = (yy >= 360) & (((g - r > 22.0) & (b - r > 40.0)) | ((yy >= 458) & (np.abs(xx - 600) <= 235) & (lum > 96.0)) | stepping_stones)
    walk_cand = (~mouth) & (~crystal) & teal_floor
    lab_w, _ = nd.label(walk_cand)
    south_seed = np.unique(lab_w[hr - 24:, 480:720])
    south_seed = south_seed[south_seed > 0]
    open_floor = np.isin(lab_w, south_seed)

    # 4. Parois périphériques vs rochers intérieurs
    solid_rock = (~mouth) & (~crystal) & (~open_floor)
    border = np.zeros_like(solid_rock)
    border[0, :] = border[-1, :] = border[:, 0] = border[:, -1] = True
    border[:220, :] = True
    lab_r, _ = nd.label(solid_rock)
    wall_ids = np.unique(lab_r[solid_rock & border])
    wall_ids = wall_ids[wall_ids > 0]
    parois = np.isin(lab_r, wall_ids)
    rochers = solid_rock & (~parois)

    return {
        'profondeur': mouth,
        'cristaux': crystal,
        'rochers': rochers,
        'parois': parois,
        'ardoise_sombre': open_floor & (lum <= 76.0),
        'pierre_turquoise': open_floor & (lum > 76.0) & (lum <= 180.0),
        'dalles_cristal': open_floor & (lum > 180.0),
    }


def extract_clean_poses(sheet_a: np.ndarray, pal9_row0: list[list[int]]) -> tuple[list[np.ndarray], list[np.ndarray]]:
    """Extrait 4 éclats cristallins (ligne haute) et 4 nuages minéraux (ligne basse) avec 0 px magenta/violet."""
    f = sheet_a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    # Purge stricte du fond #FF00FF et de toute frange à dominante rouge/magenta
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
            if int((lab == i).sum()) > 900:
                ys, xs = np.nonzero(lab == i)
                bxs.append((int(xs.mean()), int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1, lab == i))
        bxs.sort(key=lambda t: t[0])
        return bxs

    glints = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(row_boxes(0, hs // 2)[:4]):
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

    slate_tone = np.array(pal9_row0[4], dtype=float)
    puffs = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(row_boxes(hs // 2, hs)[:4]):
        sub = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
        mm = m[y0:y1, x0:x1] & valid[y0:y1, x0:x1]
        px = sheet_a[y0:y1, x0:x1][mm].astype(float)
        lum_n = np.clip((px @ [0.299, 0.587, 0.114]) / 145.0, 0.55, 1.35)
        sub[mm, :3] = np.clip(slate_tone[None, :] * lum_n[:, None], 28, 225).astype(np.uint8)
        sub[mm, 3] = 255
        sz = [(10, 8), (14, 11), (18, 14), (20, 15)][idx]
        arr = np.array(Image.fromarray(sub).resize(sz, Image.NEAREST))
        arr[arr[..., 3] < 128] = 0
        arr[arr[..., 3] >= 128, 3] = 255
        yy_s, xx_s = np.mgrid[0:arr.shape[0], 0:arr.shape[1]]
        if idx == 2:
            arr[((xx_s + yy_s) % 3) == 0] = 0
        elif idx == 3:
            arr[((xx_s + yy_s) % 2) == 0] = 0
        op = arr[..., 3] > 0
        arr[op & (arr[..., 0].astype(int) > arr[..., 1].astype(int) + 6)] = 0
        puffs.append(arr)
    return glints, puffs


def build_palette8_sanctuary_frames(crys_layer: np.ndarray, ex: dict[str, np.ndarray], pal8: list[list[list[int]]]) -> tuple[list[np.ndarray], np.ndarray]:
    """Applique la table exacte Palette 8 (19 poses x 4 ticks = 76 ticks) de d17p11a.bpl au sanctuaire cristallin."""
    lum = lum_of(crys_layer)
    crys = ex['cristaux']
    inner = nd.binary_erosion(crys, iterations=1) & (lum > float(np.percentile(lum[crys], 36)))
    facets = keep_large(inner, 8)
    n_cols = len(pal8[0])
    vals = lum[facets]
    qs = np.quantile(vals, np.linspace(0.08, 0.94, min(8, n_cols) - 1))
    ranks = np.clip(np.searchsorted(qs, vals), 0, n_cols - 1)
    frames = []
    for t in range(N_PHASES):
        row = pal8[t]
        fr = np.zeros((H, W, 4), np.uint8)
        fr[facets, :3] = np.array([row[rk] for rk in ranks], dtype=np.uint8)
        fr[facets, 3] = 255
        frames.append(fr)
    return frames, facets


def build_palette9_and_particles_frames(
    dalles_layer: np.ndarray,
    ex: dict[str, np.ndarray],
    pal9: list[list[list[int]]],
    glints: list[np.ndarray],
    puffs: list[np.ndarray],
    facets: np.ndarray,
    walk: np.ndarray,
) -> tuple[list[np.ndarray], list[list[int]]]:
    """Applique la table exacte Palette 9 (19 x 4 ticks) aux dalles cristallines + éclats et brumes purgés."""
    lum = lum_of(dalles_layer)
    slabs = ex['dalles_cristal']
    inner_slabs = keep_large(slabs & (lum > float(np.percentile(lum[slabs], 30))), 6)
    n_cols = len(pal9[0])
    vals = lum[inner_slabs]
    qs = np.quantile(vals, np.linspace(0.12, 0.90, min(6, n_cols) - 1))
    ranks = np.clip(np.searchsorted(qs, vals), 0, n_cols - 1)

    ys_f, xs_f = np.nonzero(facets)
    anchors = [(384, 108), (288, 260), (480, 260), (195, 250), (572, 250), (384, 178)]
    spots = []
    for ax, ay in anchors:
        idx = int(np.argmin((xs_f - ax) ** 2 + (ys_f - ay) ** 2))
        spots.append([int(xs_f[idx]), int(ys_f[idx])])

    ys_w, xs_w = np.nonzero(walk & (np.arange(H)[:, None] > 320))
    puff_spots = []
    for px0, py0 in [(310, 350), (458, 355)]:
        idx = int(np.argmin((xs_w - px0) ** 2 + (ys_w - py0) ** 2))
        puff_spots.append([int(xs_w[idx]), int(ys_w[idx])])

    frames = []
    for t in range(N_PHASES):
        row = pal9[t]
        base = np.zeros((H, W, 4), np.uint8)
        base[inner_slabs, :3] = np.array([row[rk] for rk in ranks], dtype=np.uint8)
        base[inner_slabs, 3] = 255
        canvas = Image.fromarray(base)
        for si, (sx, sy) in enumerate(spots):
            k = (t - (si * 3) % N_PHASES) % N_PHASES
            if k < len(glints):
                sp = Image.fromarray(glints[k])
                canvas.alpha_composite(sp, (sx - sp.width // 2, sy - sp.height // 2))
        for pi, (mx, my) in enumerate(puff_spots):
            k = (t - (pi * 9 + 4) % N_PHASES) % N_PHASES
            if k < len(puffs):
                pf = Image.fromarray(puffs[k])
                canvas.alpha_composite(pf, (mx - pf.width // 2, my - pf.height // 2))
        frames.append(np.array(canvas))
    return frames, spots


def write_ora(path: Path, layers: dict[str, np.ndarray]) -> None:
    root = ET.Element('image', version='0.0.5', w=str(W), h=str(H), xres='72', yres='72')
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


def ground_project(stack, blocked: np.ndarray, entry_px: list[int], threshold_px: list[int], gfx, tools) -> dict[str, int]:
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
        Name={'DefaultText': 'Entree Traversee Cristal - sud vers nord (4:3)', 'LocalTexts': {'fr': 'Entrée Traversée Cristal'}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur D17P11A ; Palettes 8 et 9 exactes de d17p11a.bpl (19 x 4 ticks). Aucun test runtime PMDO.',
    )
    o['obstacles'] = [[{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
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
  <Name>Entree Traversee Cristal sud-nord 4:3 (ETX1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee au sud, dalles cristallines turquoise et sanctuaire nord de la Traversee Cristal (ref. ROM D17P11A).</Description>
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
    gfx = loadmod('pmdo_codec_etx1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_etx1', R / 'source/pmdo_cote/INSTALLER.py')
    esn = loadmod('esn1_etx1', R / 'source/entree_sud_nord_generee_v1/build.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF_PNG)
    parts = rgb(RAW / 'particules_poses.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    bpl_meta = json.loads(REF_BPL_JSON.read_text())
    pal8 = bpl_meta['animated_palettes']['8']['frames_rgb']
    pal9 = bpl_meta['animated_palettes']['9']['frames_rgb']

    # 1. Segmentation à pleine résolution avant réduction 768 x 576
    m_full = classify_fullres(a)
    order = ['profondeur', 'cristaux', 'rochers', 'parois', 'ardoise_sombre', 'pierre_turquoise', 'dalles_cristal']
    ex, cols = down_class(a, m_full, order)

    mouth = ex['profondeur']
    dist_in = nd.distance_transform_edt(mouth)
    if dist_in.max() > 0:
        darken = np.clip(1.0 - 0.55 * (dist_in / float(dist_in.max())), 0.35, 1.0)
        cols['profondeur'][mouth] = np.clip(cols['profondeur'][mouth].astype(float) * darken[mouth, None], 14, 255).astype(int)

    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 2. Praticabilité 16x16 depuis l'entrée sud jusqu'au seuil nord devant l'arche du cristal
    cand = ex['ardoise_sombre'] | ex['pierre_turquoise'] | ex['dalles_cristal']
    cl, _ = nd.label(cand)
    ys_all = np.nonzero(cand.any(1))[0]
    seed = cl[ys_all.max()][cand[ys_all.max()]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    blocked = cell_grid(~walk)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    mouth_ys, mouth_xs = np.nonzero(ex['profondeur'])
    mouth_south_cell = int(mouth_ys.max() // 8) + 2
    mouth_cx_cell = int(round(mouth_xs.mean() / 8))
    entry_px = find_marker_16x16(blocked, (48, 67), range(62, 70))
    threshold_px = find_marker_16x16(blocked, (mouth_cx_cell, mouth_south_cell), range(mouth_south_cell, mouth_south_cell + 10))
    reach_ok, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach_ok, f'Chemin 16x16 introuvable entre {entry_px} et {threshold_px}'

    # 3. Poses purgées + animations exactes Palettes 8 & 9 de d17p11a.bpl (19 x 4 = 76 ticks)
    glints, puffs = extract_clean_poses(parts, pal9[0])
    all_poses = [('eclat', g) for g in glints] + [('brume', p) for p in puffs]
    pose_strip = Image.new('RGBA', (sum(p.shape[1] + 8 for _, p in all_poses) + 8, max(p.shape[0] for _, p in all_poses) + 8), (0, 0, 0, 0))
    ox = 4
    for idx_p, (kind, p_arr) in enumerate(all_poses):
        Image.fromarray(p_arr).save(OUT / 'poses' / f'{PFX}_pose_{idx_p:02d}_{kind}.png')
        pose_strip.alpha_composite(Image.fromarray(p_arr), (ox, 4))
        ox += p_arr.shape[1] + 8
    pose_strip.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    sanct_frames, facets = build_palette8_sanctuary_frames(layers['cristaux'], ex, pal8)
    slab_frames, glint_spots = build_palette9_and_particles_frames(
        layers['dalles_cristal'], ex, pal9, glints, puffs, facets, walk
    )
    anim_map = {
        'lueur_sanctuaire': sanct_frames,
        'reflets_et_poussiere': slab_frames,
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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    ov.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    write_ora(OUT / f'{PFX}_entree_traversee_cristal_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, threshold_px, gfx, tools,
    )

    # 5. Fidélité chromatique mesurée contre la capture ROM D17P11A (< 35 sur chaque matériau et calque)
    dist_rgb = lambda x, y: round(float(np.linalg.norm(np.asarray(x, float) - np.asarray(y, float))), 2)
    m_ref, m_raw = materials(ref), materials(a)
    raw_fid = {}
    for mk_name in m_ref:
        mr = ref[m_ref[mk_name]].mean(0)
        md = a[m_raw[mk_name]].mean(0)
        raw_fid[mk_name] = {
            'ref_rgb': [round(float(v), 1) for v in mr],
            'mean_rgb': [round(float(v), 1) for v in md],
            'distance': dist_rgb(md, mr),
        }

    rlum = lum_of(ref)
    rcyan = (ref[..., 1].astype(float) - ref[..., 0].astype(float) > 26.0)
    ref_targets = {
        'ardoise_sombre': ref[rcyan & (rlum <= 76.0)].mean(0),
        'pierre_turquoise': ref[rcyan & (rlum > 76.0) & (rlum <= 145.0)].mean(0),
        'dalles_cristal': ref[rcyan & (rlum > 180.0)].mean(0),
        'rochers': ref[(~rcyan) & (rlum > 42.0) & (rlum <= 96.0)].mean(0),
        'parois': ref[(~rcyan) & (rlum <= 62.0)].mean(0),
        'cristaux': ref[m_ref['cristal_clair']].mean(0),
        'profondeur': ref[rlum < 45.0].mean(0),
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
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), ref[rcyan & (rlum <= 115.0)].mean(0))

    manifest = {
        'id': 'entree_traversee_cristal_sud_nord_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'D17P11A',
            'dungeon_fr': 'Traversée Cristal (entrée)',
            'dungeon_en': 'Crystal Crossing Entrance',
            'pmd_sky_commit': bpl_meta['pmd_sky_commit'],
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palettes': {
                'palette_8_sanctuaire': {'palette_index': 8, 'frames': 19, 'duration_per_frame_ticks': 4, 'loop_ticks': 76},
                'palette_9_dalles': {'palette_index': 9, 'frames': 19, 'duration_per_frame_ticks': 4, 'loop_ticks': 76},
            },
        },
        'nature': 'Décor généré référencé sur la capture ROM D17P11A (pas des tuiles natives certifiées) ; lueur du sanctuaire cristallin pilotée par Palette 8 et reflets des dalles par Palette 9 exactes de d17p11a.bpl (19 x 4 = 76 ticks).',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': (RAW / 'sol_complet.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'sol_complet.png').size),
             'sha256': sha(RAW / 'sol_complet.png'), 'images': [REF_SOL_CROP.relative_to(R).as_posix()]},
            {'file': (RAW / 'particules_poses.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'particules_poses.png').size),
             'sha256': sha(RAW / 'particules_poses.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'glint_spots': glint_spots,
        'access': {
            'entry_px': entry_px,
            'threshold_px': threshold_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(reach_ok),
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': raw_fid, 'calques_finaux': final_fid, 'sol_complet': sol_fid},
        'pmdo': {'target': '0.8.12', 'runtime_tested': False, 'asset_name': ASSET, 'namespace': NAMESPACE,
                 'tex_size': 1, 'tiles_per_bank': counts},
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, entry={entry_px}, seuil={threshold_px}, sol_dist={sol_fid}')


if __name__ == '__main__':
    build()
