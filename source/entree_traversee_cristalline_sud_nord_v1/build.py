"""Entrée Traversée Cristalline — Canyon Strié sud -> nord V1 (ETX1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique : `D16P11A` (Crystal Crossing, Pokémon Mystery Dungeon: Explorers of Sky, 600 x 408 px, 22 frames).
Scène :
- Arrivée au sud (`entrance`) par une passe de sable entre deux corniches de roche striée (`rebords`) ;
- Vaste esplanade de sable ocre-jaune (`sable`, `ombres`) semée de rochers stratifiés (`blocs`), de gravillons (`cailloux`)
  et de touffes d'herbe épineuse (`touffes`) ;
- Haute falaise de canyon striée horizontalement au nord (`falaises`), ouvrant sur une bouche de grotte sombre (`profondeur`,
  marqueur `donjon_seuil`).
Animations en boucles fermées (24 x 5 = 120 ticks = 2,0 s) :
- `lueurs_grotte` : pulsation lumineuse en boucle fermée des orbes cristallins cyan-bleu au fond de la bouche de grotte
  sur la rampe de couleurs exacte relevée dans `D16P11A` ;
- `scintillements` : particules cristallines cyan-blanc dérivant en boucle fermée devant l'entrée de la grotte et le long
  des parois du canyon.
Lancer : .venv/bin/python source/entree_traversee_cristalline_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = HERE / 'reference/D16P11A.png'
OUT = R / 'renders/entree_traversee_cristalline_sud_nord_v1'
STAGE = R / '.cache/entree_traversee_cristalline_sud_nord_v1/entree_traversee_cristalline_sud_nord'
NAMESPACE = 'entree_traversee_cristalline_sud_nord'
ASSET = 'etx1_entree_traversee_cristalline'
PFX = 'ETX1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_traversee_cristalline_sud_nord_v1'

GEN = [
    {'file': 'decor.png',
     'images': [f'{LOT}/reference/D16P11A.png'],
     'prompt': 'Top-down 2D pixel-art canyon dungeon entrance map (1200x896, wide 4:3) matching D16P11A (Crystal Crossing): '
               'south sandy pass between striated brown rock ledges; wide pale yellow-tan sandy canyon forecourt with layered '
               'brown boulder mounds, pebbles and spiky green desert bush tufts; north tall horizontally striated canyon cliff '
               'wall with dark arched cave entrance and 4 glowing cyan-blue light orbs inside.',
     'essais': 'premier essai ; conforme'},
    {'file': 'sol_complet.png',
     'images': [f'{LOT}/reference/D16P11A.png'],
     'prompt': 'Pale yellow-tan speckled sandy ground texture from D16P11A covering 100% of the canvas uniformly.',
     'essais': 'premier essai ; conforme'},
]

# Rampe exacte relevée dans la bouche de grotte de D16P11A (y 40..100, x 250..350) : du fond gris-bleu aux coeurs cyan
CAVE_BG = (52, 65, 76)
ORB_RAMP = [
    (52, 65, 76), (57, 74, 87), (64, 86, 102), (69, 98, 118),
    (77, 114, 138), (85, 130, 158), (94, 148, 178), (112, 168, 198),
    (138, 192, 218), (168, 216, 236), (204, 240, 250),
]

MOTES = [
    (360, 118, 0, 2), (384, 112, 4, 2), (408, 120, 8, 2),
    (342, 164, 12, 3), (426, 160, 16, 3), (372, 196, 20, 2),
    (220, 270, 3, 3), (548, 266, 9, 3), (260, 360, 15, 2), (508, 356, 21, 2),
]
MOTE_RISE = 1
DOT, GLOW, CORE = (94, 148, 178), (168, 216, 236), (224, 248, 255)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group

PALETTE_GROUPS = {
    'sable': (['sol_complet', 'sable', 'ombres', 'seuil'], 64),
    'roche': (['cailloux', 'blocs', 'rebords', 'falaises'], 96),
    'vegetation': (['touffes'], 32),
    'grotte': (['profondeur'], 24),
}
STATIC = ['sable', 'ombres', 'seuil', 'cailloux', 'blocs', 'touffes', 'rebords', 'falaises', 'profondeur']
ANIMS = ['lueurs_grotte', 'scintillements']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def load_ground_template():
    zpath = R / 'mod_metano_expeditions_pmdo_0812.zip'
    if zpath.exists():
        with zipfile.ZipFile(zpath) as z:
            return json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground').decode('utf-8-sig'))
    return json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))


def materials(a):
    a = a.astype(float)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)
    sable = (r > 195) & (g > 170) & (r - b > 45) & (g > b + 25)
    touffes = (g > r + 8) & (g - b > 25) & (g > 95)
    grotte = (b > r + 4) & (lum > 30) & (lum < 110)
    roche = (r > g) & (g >= b - 5) & (r - b >= 15) & (lum >= 55) & (lum <= 195) & ~sable & ~touffes
    return {'sable': sable, 'roche': roche, 'touffes': touffes, 'grotte': grotte}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor)
    out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {
            'rip_rgb': [round(float(v), 1) for v in mr],
            'decor_rgb': [round(float(v), 1) for v in md],
            'distance': round(float(np.linalg.norm(mr - md)), 1),
        }
    return out


def classify(a):
    """Segmentation pleine résolution (1200 x 896) :
    profondeur = bouche de grotte sombre au haut-centre (y 60-230, x 480-720) ;
    touffes = buissons verts épineux (g > r + 8, g - b > 25, >= 100 px) ;
    sable_plein = sable jaune-ocre (r > 180, g > 155, r - b > 40) fermé/ouvert 2 px, > 20000 px, trous bouchés ;
    îlots dans le sable hors touffes : blocs >= 500 px, cailloux 15 à 500 px ;
    seuil = transition sable/ombre sous la bouche de grotte entre les montants de l'arche ;
    ombres = sable assombri à <= 28 px des falaises, rebords ou blocs ;
    rebords = corniches rocheuses au sud (y > 660) ;
    falaises = parois striées du canyon au nord, à gauche et à droite."""
    r, g, b = a.transpose(2, 0, 1)
    lum = lum_of(a)
    hh, ww = lum.shape
    yy, xx = np.mgrid[:hh, :ww]

    dark_cave = ((lum < 85) | (b > r)) & (yy > 60) & (yy < 230) & (xx > 480) & (xx < 720)
    cl, _ = nd.label(open_(dark_cave, 2))
    mouth_id = cl[130, 600]
    mouth = nd.binary_fill_holes(nd.binary_dilation(cl == mouth_id, iterations=2) & (lum < 105))

    bush_c = (g > r + 8) & (g - b > 25) & (yy > 300)
    touffes = keep_large(nd.binary_fill_holes(close_(bush_c, 2)), 100) & ~mouth

    sand_c = (r > 180) & (g > 155) & (r - b > 40) & (yy > 150) & ~mouth & ~touffes
    sand = keep_large(open_(close_(sand_c, 2), 2), 20000)
    sand_full = nd.binary_fill_holes(sand | touffes) & ~mouth

    isl = open_(sand_full & ~sand & ~touffes, 1)
    isl = nd.binary_fill_holes(close_(isl, 2)) & sand_full & ~touffes
    il, inn = nd.label(isl)
    sz = nd.sum(isl, il, range(1, inn + 1))
    blocs = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 500])
    cailloux = np.isin(il, [i + 1 for i, v in enumerate(sz) if 15 <= v < 500])

    ys_m, xs_m = np.nonzero(mouth)
    my0, my1 = int(ys_m.min()), int(ys_m.max())
    ax0, ax1 = int(xs_m.min()), int(xs_m.max())
    seuil = (yy >= my1 - 4) & (yy <= my1 + 26) & (xx >= ax0 + 8) & (xx <= ax1 - 8) & sand_full & ~blocs & ~cailloux & ~touffes

    wall = ~sand_full & ~mouth
    rebords = wall & (yy > 660)
    falaises = wall & ~rebords

    sol_pur = sand_full & ~touffes & ~blocs & ~cailloux & ~seuil
    db = nd.distance_transform_edt(~(wall | blocs))
    Ls = nd.uniform_filter(lum, 5)
    ombres = sol_pur & (Ls < 185) & (db <= 28)
    sable = sol_pur & ~ombres

    masks = dict(
        profondeur=mouth, seuil=seuil, touffes=touffes, blocs=blocs, cailloux=cailloux,
        ombres=ombres, sable=sable, rebords=rebords, falaises=falaises,
    )
    seg = {
        'grotte_y': [my0, my1], 'grotte_x': [ax0, ax1],
        'touffes': int(nd.label(touffes)[1]),
        'blocs': int(sum(v >= 500 for v in sz)),
        'cailloux': int(sum(15 <= v < 500 for v in sz)),
    }
    return masks, seg


def cave_glow_frames(prof_rgba, prof_mask, ts=range(PHASES)):
    """Extrait les orbes lumineux cyan-bleu de la bouche de grotte et les fait respirer sur ORB_RAMP."""
    r, g, b = prof_rgba[..., 0].astype(int), prof_rgba[..., 1].astype(int), prof_rgba[..., 2].astype(int)
    lum = lum_of(prof_rgba)
    orbs = prof_mask & (b - r >= 16) & (lum > 60)
    orbs = nd.binary_dilation(orbs, iterations=1) & prof_mask
    rp = np.array(ORB_RAMP, float)
    base_idx = ((prof_rgba[..., :3].astype(float)[..., None, :] - rp) ** 2).sum(-1).argmin(-1)
    rp_u8 = np.array(ORB_RAMP, 'uint8')

    # Aplanit les orbes sur le calque statique profondeur pour que l'animation contrôle 100 % de la lueur
    prof_clean = prof_rgba.copy()
    prof_clean[orbs, :3] = CAVE_BG

    frames = []
    for t in ts:
        shift = int(round(2.5 * np.sin(2 * np.pi * t / PHASES)))
        idx = np.clip(base_idx + shift, 0, len(ORB_RAMP) - 1)
        fr = np.zeros((H, W, 4), 'uint8')
        fr[orbs, :3] = rp_u8[idx[orbs]]
        fr[orbs, 3] = 255
        frames.append(fr)
    return prof_clean, frames, orbs


def mote_frames(motes=MOTES, ts=range(PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for x0, y0, off, ax in motes:
            u = (t + off) % PHASES
            x = x0 + int(round(ax * np.sin(2 * np.pi * u / 12)))
            y = y0 - MOTE_RISE * int(round(6 * np.sin(2 * np.pi * u / PHASES)))
            if 3 <= u <= 20 and u % 4 in (0, 1):
                for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    if 0 <= y + dy < H and 0 <= x + dx < W:
                        a[y + dy, x + dx] = (*GLOW, 255)
                if 0 <= y < H and 0 <= x < W:
                    a[y, x] = (*CORE, 255)
            else:
                if 0 <= y < H and 0 <= x < W:
                    a[y, x] = (*DOT, 255)
        frames.append(a)
    return frames


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Traversee Cristalline sud-nord V1 (ETX1)')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO()
            Image.fromarray(a).save(b, format='PNG')
            z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO()
        comp.save(b, format='PNG')
        z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy()
        th.thumbnail((256, 256))
        b = io.BytesIO()
        th.save(b, format='PNG')
        z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = load_ground_template()
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
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
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
        Name={'DefaultText': 'Entree Traversee Cristalline - sud vers nord (4:3)', 'LocalTexts': {}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1,
        ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Entree 4:3 referencee sur D16P11A (Crystal Crossing) ; lueurs de grotte et scintillements '
                'en boucles fermees. Aucun warp.',
    )
    o['obstacles'] = [
        [{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])} for y in range(gh)]
        for x in range(gw)
    ]
    mk = lambda n, p: {
        'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
        'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16},
    }
    o['Entities'] = [{
        'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
        'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)],
    }]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(
        STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
        f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode(),
    )
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Traversee Cristalline sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Entree de donjon 4:3 referencee sur D16P11A (Crystal Crossing) : passe sud, esplanade de sable et rochers stratifies, falaise striee et bouche de grotte aux lueurs cristallines au nord.</Description>
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


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['profondeur', 'seuil', 'touffes', 'blocs', 'cailloux', 'ombres', 'sable', 'rebords', 'falaises']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    prof_clean, lueurs_grotte, orbs_mask = cave_glow_frames(layers['profondeur'], ex['profondeur'])
    layers['profondeur'] = prof_clean

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    mouth = ex['profondeur']
    cand = ex['sable'] | ex['ombres'] | ex['seuil'] | ex['cailloux']
    cl, _ = nd.label(cand)
    seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    scintillements = mote_frames()
    anim = {'lueurs_grotte': lueurs_grotte, 'scintillements': scintillements}

    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))

    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]
    med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]

    dys, dxs = np.nonzero(mouth)
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im

    step = 5
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)

    col = scenes[0].copy()
    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov)
    col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    sheet = Image.new('RGBA', (len(ORB_RAMP) * 28 + 16, 96), (*CAVE_BG, 255))
    dr_s = ImageDraw.Draw(sheet)
    for i, c in enumerate(ORB_RAMP):
        dr_s.rectangle([8 + i * 28, 8, 8 + i * 28 + 24, 32], fill=(*c, 255))
    for j, shape in enumerate(('point', 'croix')):
        spr = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                spr[2 + dy, 2 + dx] = (*GLOW, 255)
            spr[2, 2] = (*CORE, 255)
        else:
            spr[2, 2] = (*DOT, 255)
        sheet.alpha_composite(Image.fromarray(spr).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(
        OUT / f'{PFX}_entree_traversee_cristalline_calques.ora',
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
    )
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, threshold_px, gfx, tools,
    )
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'falaises'), ('roche', 'blocs'), ('touffes', 'touffes')):
        lay = layers[nm]
        px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[f'{nm}:{k}'] = {
            'calque': nm, 'matiere': k,
            'rgb': [round(float(v), 1) for v in px.mean(0)],
            'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1),
        }

    manifest = {
        'lot': 'entree_traversee_cristalline_sud_nord_v1',
        'prefix': PFX,
        'type_zone': 'entree_de_donjon',
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'code_rom': 'D16P11A', 'frames_rom': 22},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'segmentation_mesures': seg,
        'fidelite_rip': {'brut': fid, 'calques_finaux': final_fid},
        'layers': layer_list,
        'lueurs_grotte': {'rampe': [list(c) for c in ORB_RAMP], 'orbes_px': int(orbs_mask.sum()),
                          'phases': PHASES, 'frame_length_ticks': TICKS},
        'scintillements': {'motes': [list(m) for m in MOTES], 'phases': PHASES, 'frame_length_ticks': TICKS},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {
            'entry_px': entry_px, 'threshold_px': threshold_px,
            'path_found_16x16': reach, 'cells_explored': explored,
            'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
            'walkable_cells': int((~blocked).sum()),
        },
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts,
                 'banks': list(counts), 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()),
                      'fidelite': {k: v['distance'] for k, v in fid.items()}}, indent=2))


if __name__ == '__main__':
    build()
