"""Fin Caverne Cristal V1 — Salle des Trois Cristaux (FKR1, format 4:3 vaste 768 x 576 px).

Référence canonique : capture ROM exacte `D16P31A.png` (600 x 480, *Pokémon Donjon Mystère :
Explorateurs du Ciel*, chambre aux trois cristaux de la Caverne Cristal, `pret/pmd-sky@c8073235`)
+ lois de palettes animées exactes extraites de `d16p31a.bpl` :
- Palette 3 : 19 poses x 4 ticks = 76 ticks (veines de cristal turquoise des parois et de l'autel) ;
- Palettes 4, 5, 6 : 29 poses x 4 ticks = 116 ticks (les trois grands cristaux facettés Ouest, Est et
  Centre passant par cyan -> indigo-violet -> vermillon -> chartreuse -> cyan).
Boucle globale de scène polymétrique exacte : PPCM(76, 116) = 2204 ticks (36,73 s à 60 i/s).

11 calques exportés + `Top` vide (`Layer = 4`) dans le Ground PMDO 0.8.12 :
- `00 sol_complet`, `01 sol`, `02 ombres`, `03 reflets`, `04 rochers`, `05 parois`,
  `06 autel_nord`, `07 cristaux_parois` ;
- `08 veines_cristal` (19 x 4 ticks : table RVB exacte Palette 3 de `d16p31a.bpl`) ;
- `09 trois_cristaux` (29 x 4 ticks : tables RVB exactes Palettes 4, 5, 6 de `d16p31a.bpl`) ;
- `10 eclats` (29 x 4 ticks : 4 poses d'éclats cristallins générées et purgées).

Lancer : .venv/bin/python source/fin_caverne_cristal_v1/build.py
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
REF_PNG = HERE / 'references/D16P31A.png'
REF_BPL_JSON = HERE / 'references/rom_bpl_palettes.json'
PARTS_PNG = R / 'source/entree_caverne_cristal_sud_nord_v1/bruts/particules_poses.png'
OUT = R / 'renders/fin_caverne_cristal_v1'
STAGE = R / '.cache/fin_caverne_cristal_v1/fin_caverne_cristal'

PFX = 'FKR1'
NAMESPACE = 'fin_caverne_cristal'
ASSET = 'fkr1_fin_caverne_cristal'
W, H = 768, 576
SRC = (1200, 896)
TICKS = 4
N_WALL = 19          # exact d16p31a.bpl Palette 3 : 19 x 4 = 76 ticks
N_PILLAR = 29        # exact d16p31a.bpl Palettes 4, 5, 6 : 29 x 4 = 116 ticks
SCENE_LOOP = math.lcm(N_WALL * TICKS, N_PILLAR * TICKS)  # 2204 ticks (36,73 s à 60 i/s)

STATIC = ['sol', 'ombres', 'reflets', 'rochers', 'parois', 'autel_nord', 'cristaux_parois']
ANIMS = ['veines_cristal', 'trois_cristaux', 'eclats']
PALETTE_GROUPS = {
    'ardoise': (['sol_complet', 'sol', 'ombres', 'rochers'], 64),
    'reflets': (['reflets'], 48),
    'abime': (['parois'], 48),
    'cristal': (['autel_nord', 'cristaux_parois'], 64),
}

# Boîtes mesurées sur le brut 1200 x 896 pour les 3 grands piliers facettés et l'autel nord
PILLAR_BOXES = {
    'ouest':  (330, 232, 436, 352),
    'est':    (764, 232, 870, 352),
    'centre': (524, 348, 676, 460),
}
SHRINE_BOX = (516, 134, 684, 244)


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_for_fkr1', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def dist_rgb(a, b) -> float:
    return round(float(np.linalg.norm(np.asarray(a, float) - np.asarray(b, float))), 2)


def materials(arr: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur matière identique appliqué des deux côtés (capture ROM D16P31A et décor FKR1)."""
    lum = lum_of(arr)
    return {
        'paroi_abyssale': lum <= 48.0,
        'pierre_ardoise': (lum > 48.0) & (lum <= 84.0),
        'cristal_turquoise': (lum > 84.0) & (lum <= 135.0),
        'cristal_lumineux': lum > 135.0,
    }


def classify_fullres(a: np.ndarray) -> tuple[dict[str, np.ndarray], dict[str, np.ndarray]]:
    """Segmente le brut 1200 x 896 AVANT réduction vers 768 x 576."""
    lum = lum_of(a)
    grad = np.hypot(nd.sobel(lum, axis=1), nd.sobel(lum, axis=0))
    hr, wr = lum.shape
    yy, xx = np.mgrid[0:hr, 0:wr]

    # 1. Extraction chirurgicale des 3 grands piliers de cristal facettés (Ouest, Est, Centre)
    pillars_full = {}
    for k, (x0, y0, x1, y1) in PILLAR_BOXES.items():
        box = (xx >= x0) & (xx < x1) & (yy >= y0) & (yy < y1)
        core = box & ((lum > 142.0) | ((grad > 55.0) & (lum > 95.0)))
        m = nd.binary_fill_holes(close_(core, 4))
        lab, n = nd.label(m)
        sz = [int((lab == i).sum()) for i in range(1, n + 1)]
        m = lab == (int(np.argmax(sz)) + 1)
        pillars_full[k] = nd.binary_dilation(m, iterations=2) & box
    all_pillars = pillars_full['ouest'] | pillars_full['est'] | pillars_full['centre']

    # 2. Autel cristallin sacré fermant le fond nord de l'alcôve
    sx0, sy0, sx1, sy1 = SHRINE_BOX
    sbox = (xx >= sx0) & (xx < sx1) & (yy >= sy0) & (yy < sy1)
    shrine = nd.binary_fill_holes(close_(sbox & ((lum > 80.0) | (grad > 45.0)), 4))

    # 3. Parois abyssales fermant intégralement le nord, l'ouest et l'est + cristaux de parois
    dark_wall = (lum <= 46.5) | (yy < 195) | (xx < 140) | (xx > 1060)
    wall_crys = (~all_pillars) & (~shrine) & (yy < 760) & (lum > 96.0) & ((grad > 58.0) | (yy < 245))
    wall_crys = keep_large(wall_crys & nd.binary_dilation(dark_wall, iterations=6), 60)

    # 4. Sol praticable connecté au couloir d'arrivée sud (arène + contour des 3 piliers jusqu'à l'autel nord)
    open_cand = (~all_pillars) & (~shrine) & (~wall_crys) & (~dark_wall)
    lab_o, _ = nd.label(open_cand)
    seeds = np.unique(lab_o[hr - 24:, 460:740])
    seeds = seeds[seeds > 0]
    floor = np.isin(lab_o, seeds)

    # 5. Rochers intérieurs (socles des 3 piliers + stalagmites isolées) vs parois périphériques
    solid_other = (~shrine) & (~wall_crys) & (~floor)
    border = np.zeros_like(solid_other)
    border[0, :] = border[-1, :] = border[:, 0] = border[:, -1] = True
    border[:195, :] = True
    lab_s, _ = nd.label(solid_other)
    wall_ids = np.unique(lab_s[solid_other & border])
    wall_ids = wall_ids[wall_ids > 0]
    parois = np.isin(lab_s, wall_ids)
    rochers = solid_other & (~parois)  # inclut les socles sombres des 3 grands piliers !

    classes = {
        'autel_nord': shrine,
        'cristaux_parois': wall_crys,
        'rochers': rochers,
        'parois': parois,
        'ombres': floor & (lum <= 58.0),
        'sol': floor & (lum > 58.0) & (lum <= 90.0),
        'reflets': floor & (lum > 90.0),
    }
    return classes, pillars_full


def extract_clean_sparkle_poses(sheet_a: np.ndarray) -> list[np.ndarray]:
    """Découpe les 4 poses d'éclats cristallins de la ligne haute de particules_poses.png sans aucun halo violet."""
    f = sheet_a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    # Purge stricte de tout pixel magenta ou frange r > g + 8
    valid = ~(((r - g > 20.0) & (b - g > 20.0)) | (r > g + 6.0))
    hs, ws = r.shape
    row1 = np.zeros_like(valid)
    row1[:hs // 2, :] = valid[:hs // 2, :]
    row1 = nd.binary_erosion(row1, iterations=1)
    lab, n = nd.label(close_(row1, 3))
    boxes = []
    for i in range(1, n + 1):
        if int((lab == i).sum()) > 1200:
            ys, xs = np.nonzero(lab == i)
            boxes.append((int(xs.mean()), int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1, lab == i))
    boxes.sort(key=lambda t: t[0])

    sizes = [(7, 7), (9, 9), (11, 11), (9, 9)]
    poses = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(boxes[:4]):
        sub = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
        mm = m[y0:y1, x0:x1] & valid[y0:y1, x0:x1]
        sub[mm, :3] = sheet_a[y0:y1, x0:x1][mm].astype(np.uint8)
        sub[mm, 3] = 255
        im = Image.fromarray(sub).resize(sizes[idx], Image.NEAREST)
        arr = np.array(im)
        arr[arr[..., 3] < 128] = 0
        arr[arr[..., 3] >= 128, 3] = 255
        # Vérification stricte : zéro pixel à dominante rouge/magenta après redimensionnement
        op = arr[..., 3] > 0
        bad = op & (arr[..., 0].astype(int) > arr[..., 1].astype(int) + 6)
        arr[bad] = 0
        poses.append(arr)
    return poses


def build_wall_vein_frames(crys_wall_layer: np.ndarray, shrine_layer: np.ndarray, ex: dict[str, np.ndarray], pal3: list[list[list[int]]]) -> tuple[list[np.ndarray], np.ndarray]:
    """Applique la table exacte Palette 3 (19 poses x 4 ticks = 76 ticks) de d16p31a.bpl aux veines cristallines."""
    comb = np.maximum(crys_wall_layer, shrine_layer)
    lum = lum_of(comb)
    base = ex['cristaux_parois'] | ex['autel_nord']
    thr = float(np.percentile(lum[base], 46))
    veins = keep_large(base & (lum > thr), 8)
    vals = lum[veins]
    qs = np.quantile(vals, [0.18, 0.36, 0.54, 0.72, 0.88])
    ranks = np.searchsorted(qs, vals)  # 0..5 sur les 6 paliers actifs de Palette 3
    frames = []
    for t in range(N_WALL):
        row = pal3[t]
        fr = np.zeros((H, W, 4), np.uint8)
        fr[veins, :3] = np.array([row[rk] for rk in ranks], dtype=np.uint8)
        fr[veins, 3] = 255
        frames.append(fr)
    return frames, veins


def build_three_crystals_frames(decor_768: np.ndarray, pillars_768: dict[str, np.ndarray], bpl_pals: dict) -> tuple[list[np.ndarray], dict[str, list[int]]]:
    """Anime les 3 grands piliers de cristal avec les tables exactes Palettes 4, 5 et 6 de d16p31a.bpl
    (29 poses x 4 ticks = 116 ticks, déphasages +0 / +10 / +19 poses : cyan -> violet -> vermillon -> chartreuse).
    Le contour sombre pixel-art de chaque cristal reste net sur le socle statique tandis que toutes les facettes
    intérieures suivent fidèlement l'ombrage spéculaire à 6 paliers de la ROM DS.
    """
    lum = lum_of(decor_768)
    spec = [
        ('ouest',  bpl_pals['4']['frames_rgb'], 0),
        ('est',    bpl_pals['5']['frames_rgb'], 10),
        ('centre', bpl_pals['6']['frames_rgb'], 19),
    ]
    pillar_facets = []
    pillar_bboxes = {}
    for name, pal_rows, phase_off in spec:
        hull = pillars_768[name]
        inner = nd.binary_erosion(hull, iterations=1) & (lum > 92.0)
        inner = keep_large(inner, 20)
        vals = lum[inner]
        qs = np.quantile(vals, [0.16, 0.34, 0.52, 0.70, 0.86])
        ranks = np.searchsorted(qs, vals)  # 0..5 -> 6 nuances par cristal dans d16p31a.bpl !
        ys, xs = np.nonzero(hull)
        pillar_bboxes[name] = [int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())]
        pillar_facets.append((inner, ranks, pal_rows, phase_off))

    frames = []
    for t in range(N_PILLAR):
        fr = np.zeros((H, W, 4), np.uint8)
        for inner, ranks, pal_rows, off in pillar_facets:
            row = pal_rows[(t + off) % N_PILLAR]
            fr[inner, :3] = np.array([row[rk] for rk in ranks], dtype=np.uint8)
            fr[inner, 3] = 255
        frames.append(fr)
    return frames, pillar_bboxes


def build_sparkle_frames(poses: list[np.ndarray], veins_mask: np.ndarray) -> tuple[list[np.ndarray], list[list[int]]]:
    """Place 8 éclats cristallins déphasés sur les amas de cristal des parois et de l'autel (boucle 29 poses)."""
    ys, xs = np.nonzero(veins_mask)
    anchors = [
        (170, 130), (590, 130), (260, 110), (505, 110),
        (384, 118), (130, 230), (635, 230), (384, 148),
    ]
    spots = []
    for ax, ay in anchors:
        d2 = (xs - ax) ** 2 + (ys - ay) ** 2
        idx = int(np.argmin(d2))
        spots.append([int(xs[idx]), int(ys[idx])])

    frames = []
    for t in range(N_PILLAR):
        canvas = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for si, (sx, sy) in enumerate(spots):
            k = (t - (si * 4) % N_PILLAR) % N_PILLAR
            if k < 4:
                sp = Image.fromarray(poses[k])
                canvas.alpha_composite(sp, (sx - sp.width // 2, sy - sp.height // 2))
        frames.append(np.array(canvas))
    return frames, spots


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
    with zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip') as z:
        tpl = json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
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
        Name={'DefaultText': 'Fin Caverne Cristal - Salle des Trois Cristaux (4:3)', 'LocalTexts': {'fr': 'Salle des Trois Cristaux'}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur D16P31A (Salle des Trois Cristaux) : '
                'cul-de-sac ferme au nord, veines Palette 3 (19x4) + trois cristaux Palettes 4-6 (29x4) exactes de d16p31a.bpl. '
                'Aucun test runtime PMDO.',
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
             f'-- {ASSET} : fin de donjon en cul-de-sac, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Caverne Cristal - Salle des Trois Cristaux (FKR1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon en cul-de-sac (D16P31A), arene centrale et trois grands cristaux chromatiques.</Description>
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


def build() -> None:
    gfx = loadmod('pmdo_codec_fkr1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_fkr1', R / 'source/pmdo_cote/INSTALLER.py')
    esn = loadmod('esn1_fkr1', R / 'source/entree_sud_nord_generee_v1/build.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF_PNG)
    parts = rgb(PARTS_PNG)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    bpl_meta = json.loads(REF_BPL_JSON.read_text())
    bpl_pals = bpl_meta['animated_palettes']

    # 1. Segmentation à pleine résolution avant réduction 768 x 576
    m_full, pillars_full = classify_fullres(a)
    order = ['autel_nord', 'cristaux_parois', 'rochers', 'parois', 'ombres', 'sol', 'reflets']
    ex, cols = down_class(a, m_full, order)
    pillars_768, _ = down_class(a, pillars_full, ['ouest', 'est', 'centre'])

    # Sertissage ardoise canonique D16P31A ([40, 66, 84]) sous les 3 grands cristaux pour un contour net et naturel
    all_p768 = pillars_768['ouest'] | pillars_768['est'] | pillars_768['centre']
    cols['rochers'][all_p768] = np.array([40, 66, 84])

    decor_768 = down_full(a)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for pk, pv in pillars_768.items():
        Image.fromarray((pv * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_cristal_{pk}.png')

    # 2. Grille 8 px fermée au nord, à l'ouest et à l'est + marqueurs 16x16 (entrance, boss, objectif)
    cand = ex['sol'] | ex['ombres'] | ex['reflets']
    cl, _ = nd.label(cand)
    ys_all = np.nonzero(cand.any(1))[0]
    seed = cl[ys_all.max()][cand[ys_all.max()]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    blocked = cell_grid(~walk)
    # Garantie explicite de fermeture intégrale du bord nord, ouest et est (cul-de-sac sans sortie)
    blocked[:14, :] = True
    blocked[:, :2] = True
    blocked[:, -2:] = True
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    def marker16(cx: int, cy: int) -> list[int]:
        best = None
        for dy in range(-64, 65, 8):
            for dx in range(-64, 65, 8):
                x, y = (cx // 8) * 8 + dx, (cy // 8) * 8 + dy
                if 16 <= x <= W - 32 and 16 <= y <= H - 32:
                    if not blocked[y // 8:y // 8 + 2, x // 8:x // 8 + 2].any():
                        d = dx * dx + dy * dy
                        if best is None or d < best[0]:
                            best = (d, [x, y])
        assert best is not None, (cx, cy)
        return best[1]

    wy, wx = np.nonzero(walk_grid_px)
    entry_px = marker16(int(np.median(wx[wy >= wy.max() - 8])) - 8, int(wy.max()) - 24)
    boss_px = marker16(W // 2 - 8, 344)       # grande arène centrale au sud du pilier central
    sh_ys, sh_xs = np.nonzero(ex['autel_nord'])
    objectif_px = marker16(int(round(sh_xs.mean())) - 8, int(sh_ys.max()) + 16)  # alcôve nord entre les cristaux 1 & 2

    ok_boss, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    ok_obj, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert ok_boss and ok_obj, f'Chemin 16x16 invalide: boss={ok_boss}, objectif={ok_obj}'

    # 3. Animations polymétriques exactes d16p31a.bpl : Palette 3 (19x4) + Palettes 4/5/6 (29x4) + éclats (29x4)
    vein_frames, veins_mask = build_wall_vein_frames(layers['cristaux_parois'], layers['autel_nord'], ex, bpl_pals['3']['frames_rgb'])
    Image.fromarray((veins_mask * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_veines_cristal.png')

    three_frames, pillar_bboxes = build_three_crystals_frames(decor_768, pillars_768, bpl_pals)
    spark_poses = extract_clean_sparkle_poses(parts)
    spark_frames, spark_spots = build_sparkle_frames(spark_poses, veins_mask)

    pose_files = []
    for i, sp in enumerate(spark_poses):
        fp = OUT / f'poses/{PFX}_eclat_{i:02d}.png'
        Image.fromarray(sp).save(fp); pose_files.append(fp)

    sw = max(sum(Image.open(p).width * 6 + 14 for p in pose_files) + 16, 220)
    sheet = Image.new('RGBA', (sw, 112), (24, 38, 48, 255))
    sx_p = 10
    for p in pose_files:
        im_p = Image.open(p).convert('RGBA')
        up = im_p.resize((im_p.width * 6, im_p.height * 6), Image.NEAREST)
        sheet.alpha_composite(up, (sx_p, (112 - up.height) // 2))
        sx_p += up.width + 14
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    # 4. Écriture des 11 calques + aperçus + ORA + Ground PMDO 0.8.12
    anim_map = {
        'veines_cristal': vein_frames,
        'trois_cristaux': three_frames,
        'eclats': spark_frames,
    }
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
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

    def render_at_tick(tk_val: int) -> Image.Image:
        im = Image.new('RGBA', (W, H))
        for _, frs, fl in stack_named:
            im.alpha_composite(Image.fromarray(frs[(tk_val // fl) % len(frs)]))
        return im

    scene_t0 = render_at_tick(0)
    scene_t0.save(OUT / 'review' / f'{PFX}_scene_t000.png')
    # Aperçu WebP léger sur un cycle complet de 116 ticks (29 poses x 4 ticks) montrant tout le spectre chromatique des 3 cristaux
    preview_frames = [render_at_tick(t * TICKS) for t in range(N_PILLAR)]
    preview_frames[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=preview_frames[1:],
                           duration=round(TICKS * 1000 / 60), loop=0, lossless=True)

    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 45, 45, 95))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 110, 90, 255)), (objectif_px, (80, 240, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    ov.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    write_ora(
        OUT / f'{PFX}_fin_caverne_cristal_calques.ora',
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
        comment='Fin Caverne Cristal (D16P31A — Salle des Trois Cristaux)',
    )
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, boss_px, objectif_px, gfx, tools,
    )

    # 5. Fidélité chromatique mesurée contre la capture ROM D16P31A (< 35 sur chaque matériau et calque)
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
    ref_targets = {
        'sol': ref[m_ref['pierre_ardoise']].mean(0),
        'ombres': ref[(rlum > 36.0) & (rlum <= 62.0)].mean(0),
        'reflets': ref[m_ref['cristal_turquoise']].mean(0),
        'rochers': ref[m_ref['pierre_ardoise']].mean(0),
        'parois': ref[m_ref['paroi_abyssale']].mean(0),
        'autel_nord': ref[(rlum > 62.0) & (rlum <= 135.0)].mean(0),
        'cristaux_parois': ref[rlum > 96.0].mean(0),
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
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), ref[(rlum > 52.0) & (rlum <= 115.0)].mean(0))

    manifest = {
        'id': 'fin_caverne_cristal_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'D16P31A',
            'dungeon_fr': 'Caverne Cristal — Salle des Trois Cristaux',
            'dungeon_en': 'Crystal Cave — Three Crystals Chamber',
            'pmd_sky_commit': bpl_meta['pmd_sky_commit'],
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palettes': {
                'palette_3_veines': {'frames': N_WALL, 'ticks': TICKS, 'loop_ticks': N_WALL * TICKS},
                'palettes_4_5_6_trois_cristaux': {'frames': N_PILLAR, 'ticks': TICKS, 'loop_ticks': N_PILLAR * TICKS, 'offsets': [0, 10, 19]},
            },
        },
        'nature': 'Décor généré référencé sur la capture ROM D16P31A (pas des tuiles natives certifiées) ; veines cristallines pilotées par Palette 3 (19x4) et les trois grands piliers de cristal pilotés par Palettes 4, 5, 6 (29x4) exactes de d16p31a.bpl.',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': (RAW / 'sol_complet.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'sol_complet.png').size),
             'sha256': sha(RAW / 'sol_complet.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': PARTS_PNG.relative_to(R).as_posix(), 'size': list(Image.open(PARTS_PNG).size),
             'sha256': sha(PARTS_PNG), 'images': [REF_PNG.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'three_crystals_bboxes_768': pillar_bboxes,
        'sparkle_points': spark_spots,
        'access': {
            'entry_px': entry_px,
            'boss_px': boss_px,
            'objectif_px': objectif_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(ok_boss and ok_obj),
            'closed_north_rows': 14,
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': raw_fid, 'calques_finaux': final_fid, 'sol_complet': sol_fid},
        'pmdo': {'target': '0.8.12', 'runtime_tested': False, 'asset_name': ASSET, 'namespace': NAMESPACE,
                 'tex_size': 1, 'tiles_per_bank': counts},
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, entry={entry_px}, boss={boss_px}, objectif={objectif_px}, sol_dist={sol_fid}')


if __name__ == '__main__':
    build()
