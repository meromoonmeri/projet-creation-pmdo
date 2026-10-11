"""Fin Traversée Cristalline — Sanctuaire des Trois Cristaux V1 (FTX1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique : `D16P31A` (Crystal Lake, Pokémon Mystery Dungeon: Explorers of Sky, 600 x 480 px, 19/29 frames).
Scène :
- Arrivée au sud (`entrance`) par une passe entre deux corniches rocheuses sombres (`rebords`) ;
- Vaste arène souterraine de sable bleu-sarcelle (`sable`, `ombres`, `halos_sol`), centrée sur le marqueur `boss` ;
- Dalles runiques lumineuses cyan (`dalles`, praticables) et amas de rochers stratifiés (`rochers`, `cailloux`) ;
- Trois grands massifs de cristaux cyan-bleu disposés en triangle au nord-centre (`cristaux_iliens`), parois caverneuses
  serties de cristaux (`parois`, `cristaux_paroi`), et marqueur `objectif` au sanctuaire nord (aucune sortie, aucun warp,
  aucun `donjon_seuil`).
Animations en boucles fermées (24 x 5 = 120 ticks = 2,0 s) :
- `lueur_cristaux` : chatoiement déphasé (`2π/3`) des facettes des 3 massifs cristallins (`cristaux_iliens`) et des
  cristaux de paroi (`cristaux_paroi`), reproduisant le déphasage multi-palettes (palettes 4, 5, 6) de `D16P31A` ;
- `lueur_dalles` : pulsation lumineuse en boucle fermée des dalles runiques au sol (`dalles`) et de leurs halos ;
- `scintillements` : particules cristallines cyan-blanc dérivant en boucle fermée autour des trois massifs de cristal.
Lancer : .venv/bin/python source/fin_traversee_cristalline_lac_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = HERE / 'reference/D16P31A.png'
OUT = R / 'renders/fin_traversee_cristalline_lac_v1'
STAGE = R / '.cache/fin_traversee_cristalline_lac_v1/fin_traversee_cristalline_lac'
NAMESPACE = 'fin_traversee_cristalline_lac'
ASSET = 'ftx1_fin_traversee_cristalline'
PFX = 'FTX1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_traversee_cristalline_lac_v1'

GEN = [
    {'file': 'decor.png',
     'images': [f'{LOT}/reference/D16P31A.png'],
     'prompt': 'Top-down 2D pixel-art crystal sanctuary boss room map (1200x896, wide 4:3) matching D16P31A (Crystal Lake): '
               'south entry pass between dark rock ledges; wide teal-lit sandy cavern arena with glowing cyan floor rune '
               'slabs and stratified rock boulders; 3 giant glowing cyan-blue crystal cluster mounds arranged in a triangle '
               'at the north-center surrounded by soft cyan floor halos; upper cavern rock walls embedded with glowing '
               'cyan crystal outcrops; closed north wall with no exit.',
     'essais': 'premier essai ; conforme'},
    {'file': 'sol_complet.png',
     'images': [f'{LOT}/reference/D16P31A.png'],
     'prompt': 'Teal-lit sandy cavern ground texture from D16P31A covering 100% of the canvas uniformly.',
     'essais': 'premier essai ; conforme'},
]

CRYST_RAMP = [
    (36, 76, 102), (46, 98, 126), (58, 120, 148), (72, 144, 168),
    (90, 168, 188), (114, 192, 208), (144, 214, 226), (178, 234, 242),
    (212, 248, 252), (242, 255, 255),
]
SLAB_RAMP = [
    (52, 108, 134), (66, 128, 152), (82, 148, 170), (102, 170, 188),
    (128, 194, 208), (158, 216, 226), (192, 236, 244), (224, 250, 255),
]

MOTES = [
    (360, 172, 0, 2), (408, 170, 6, 2), (384, 210, 12, 2),
    (272, 268, 3, 3), (330, 290, 9, 2), (438, 288, 15, 2), (496, 266, 21, 3),
    (348, 344, 4, 2), (420, 342, 16, 2), (384, 396, 10, 2),
]
MOTE_RISE = 1
DOT, GLOW, CORE = (90, 168, 188), (178, 234, 242), (242, 255, 255)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
cell_grid, close_ = V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group

PALETTE_GROUPS = {
    'sable': (['sol_complet', 'sable', 'ombres', 'halos_sol'], 64),
    'roche': (['cailloux', 'rochers', 'rebords', 'parois'], 80),
    'cristaux': (['dalles', 'cristaux_iliens', 'cristaux_paroi'], 64),
}
STATIC = ['sable', 'ombres', 'halos_sol', 'dalles', 'cailloux', 'rochers', 'cristaux_iliens', 'cristaux_paroi', 'rebords', 'parois']
ANIMS = ['lueur_dalles', 'lueur_cristaux', 'scintillements']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_large(m, mn):
    l, n = nd.label(m)
    if not n:
        return m
    s = np.bincount(l.ravel())
    s[0] = 0
    return (s >= mn)[l]


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
    sable = (g - r > 32) & (b - r > 48) & (lum >= 60) & (lum < 120)
    roche = (g - r <= 32) & (lum >= 25) & (lum < 75)
    cristal = (b >= 150) & (b - r > 70)
    halo = (g - r > 32) & (b - r > 55) & (lum >= 120) & (b < 195)
    return {'sable': sable, 'roche': roche, 'cristal': cristal, 'halo': halo}


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
    - fc_full : enveloppe de l'arène de sable sarcelle (g - r > 32, b - r > 48, > 30000 px, trous bouchés) ;
    - îlots dans l'arène :
      * cristaux_iliens : les 3 grands massifs de cristaux (>= 5000 px et min_lum < 55) ;
      * dalles : dalles runiques lumineuses au sol (>= 250 px et min_lum >= 60) ;
      * rochers : blocs rocheux (250..5000 px et min_lum < 60) ;
      * cailloux : petits gravillons (20..250 px) ;
    - cristaux_paroi : affleurements de cristal cyan dans les parois hors arène (b > 135, b - r > 55, y < 680) ;
    - rebords : corniches rocheuses au sud (y > 680 hors arène) ;
    - parois : parois rocheuses caverneuses au nord, à gauche et à droite ;
    - halos_sol, ombres, sable : partition du sol praticable selon la luminance et la distance aux parois/massifs."""
    r, g, b = a.transpose(2, 0, 1).astype(float)
    lum = lum_of(a)
    hh, ww = lum.shape
    yy, xx = np.mgrid[:hh, :ww]

    fc = keep_large(open_(close_((g - r > 32) & (b - r > 48), 3), 2), 30000)
    fc_full = nd.binary_fill_holes(fc)
    boulders_raw = open_(fc_full & ~fc, 2)
    boulders_raw = nd.binary_fill_holes(close_(boulders_raw, 2)) & fc_full

    mean_l = nd.uniform_filter(lum, 7)
    std_l = np.sqrt(np.maximum(0, nd.uniform_filter(lum ** 2, 7) - mean_l ** 2))
    smooth_sand = (g - r > 32) & (b - r > 48) & (std_l < 11.0) & (lum > 62) & (lum < 172)
    sand_main = keep_large(open_(close_(smooth_sand, 2), 2), 20000)
    sand_full = nd.binary_fill_holes(sand_main)

    isl = open_((sand_full & ~sand_main) | boulders_raw, 2)
    isl = nd.binary_fill_holes(close_(isl, 2)) & fc_full
    il, inn = nd.label(isl)
    s = np.bincount(il.ravel())
    s[0] = 0

    cryst_ids, slab_ids, rock_ids, peb_ids = [], [], [], []
    for i in np.nonzero(s >= 20)[0]:
        m = il == i
        min_l = float(lum[m].min())
        if s[i] >= 5000 and min_l < 55:
            cryst_ids.append(i)
        elif s[i] >= 250 and min_l >= 60:
            slab_ids.append(i)
        elif s[i] >= 250:
            rock_ids.append(i)
        else:
            peb_ids.append(i)

    cristaux_iliens = np.isin(il, cryst_ids)
    dalles = np.isin(il, slab_ids)
    rochers = np.isin(il, rock_ids)
    cailloux = np.isin(il, peb_ids)

    wall = ~fc_full
    # Les dalles plates sont uniquement dans l'axe central (entre les 3 massifs et sur le sentier sud) ;
    # les touffes cristallines épineuses en périphérie ou sur la paroi appartiennent à cristaux_paroi (bloquées).
    central_slab_zone = ((yy >= 345) & (yy <= 570) & (xx >= 470) & (xx <= 730)) | ((yy > 570) & (yy <= 740) & (xx >= 560) & (xx <= 640))
    halo_guard = nd.binary_dilation(cristaux_iliens, iterations=46)
    spiky_perim = (dalles & ~central_slab_zone) | (fc_full & ~cristaux_iliens & ~halo_guard & ~central_slab_zone & (b >= 148) & (std_l >= 10.0))
    dalles = dalles & central_slab_zone & ~spiky_perim

    wc_seed = ((wall & (yy < 680) & (b > 130) & (b - r > 52)) | spiky_perim)
    cristaux_paroi = keep_large(nd.binary_fill_holes(close_(nd.binary_dilation(wc_seed, iterations=2) & ~cristaux_iliens, 2)), 60)
    rochers = rochers & ~cristaux_paroi
    cailloux = cailloux & ~cristaux_paroi
    rebords = wall & ~cristaux_paroi & (yy > 680)
    parois = wall & ~cristaux_paroi & ~rebords

    sol_pur = fc_full & ~cristaux_iliens & ~cristaux_paroi & ~dalles & ~rochers & ~cailloux
    halos_sol = sol_pur & (b >= 132) & (lum >= 102)
    db = nd.distance_transform_edt(~(wall | cristaux_iliens | cristaux_paroi | rochers))
    Ls = nd.uniform_filter(lum, 5)
    ombres = sol_pur & ~halos_sol & ((Ls < 78) | (db <= 20))
    sable = sol_pur & ~halos_sol & ~ombres

    masks = dict(
        cristaux_iliens=cristaux_iliens, cristaux_paroi=cristaux_paroi, dalles=dalles,
        rochers=rochers, cailloux=cailloux, halos_sol=halos_sol, ombres=ombres, sable=sable,
        rebords=rebords, parois=parois,
    )
    seg = {
        'cristaux_iliens': len(cryst_ids),
        'dalles': len(slab_ids),
        'rochers': len(rock_ids),
        'cailloux': len(peb_ids),
        'cristaux_paroi_px': int(cristaux_paroi.sum()),
    }
    return masks, seg


def crystal_frames(ci_rgba, ci_mask, cp_rgba, cp_mask, ts=range(PHASES)):
    """Chatoiement déphasé (2π/3) des 3 massifs cristallins + cristaux de paroi sur CRYST_RAMP."""
    rp = np.array(CRYST_RAMP, float)
    rp_u8 = np.array(CRYST_RAMP, 'uint8')

    # Identifie les facettes cristallines lumineuses (b >= 152 et b - r > 65) dans cristaux_iliens et cristaux_paroi
    ci_b, ci_r = ci_rgba[..., 2].astype(int), ci_rgba[..., 0].astype(int)
    cp_b, cp_r = cp_rgba[..., 2].astype(int), cp_rgba[..., 0].astype(int)
    f_ci = ci_mask & (ci_b >= 152) & (ci_b - ci_r > 65)
    f_cp = cp_mask & (cp_b >= 152) & (cp_b - cp_r > 65)

    # Labellise les 3 massifs de cristaux pour leur donner les déphasages 0, 8, 16 (cycles de 24 phases)
    cl, cn = nd.label(ci_mask)
    phase_map = np.zeros((H, W), int)
    comp_sizes = [(int((cl == i).sum()), i) for i in range(1, cn + 1)]
    comp_sizes.sort(reverse=True)
    for k, (_, comp_id) in enumerate(comp_sizes[:3]):
        phase_map[cl == comp_id] = (k * (PHASES // 3)) % PHASES
    phase_map[f_cp] = 4

    comb_rgb = np.where(f_ci[..., None], ci_rgba[..., :3], cp_rgba[..., :3]).astype(float)
    base_idx = ((comb_rgb[..., None, :] - rp) ** 2).sum(-1).argmin(-1)
    active = f_ci | f_cp

    frames = []
    for t in ts:
        u = (t + phase_map) % PHASES
        shift = np.round(1.35 * np.sin(2 * np.pi * u / PHASES)).astype(int)
        idx = np.clip(base_idx + shift, 0, len(CRYST_RAMP) - 1)
        fr = np.zeros((H, W, 4), 'uint8')
        fr[active, :3] = rp_u8[idx[active]]
        fr[active, 3] = 255
        frames.append(fr)
    return frames, int(active.sum())


def slab_frames(dalles_rgba, dalles_mask, ts=range(PHASES)):
    """Pulsation lumineuse en boucle fermée des dalles runiques au sol sur SLAB_RAMP."""
    rp = np.array(SLAB_RAMP, float)
    rp_u8 = np.array(SLAB_RAMP, 'uint8')
    db = dalles_rgba[..., 2].astype(int)
    active = dalles_mask & (db >= 138)
    base_idx = ((dalles_rgba[..., :3].astype(float)[..., None, :] - rp) ** 2).sum(-1).argmin(-1)

    frames = []
    for t in ts:
        shift = int(round(2.0 * np.sin(2 * np.pi * t / PHASES)))
        idx = np.clip(base_idx + shift, 0, len(SLAB_RAMP) - 1)
        fr = np.zeros((H, W, 4), 'uint8')
        fr[active, :3] = rp_u8[idx[active]]
        fr[active, 3] = 255
        frames.append(fr)
    return frames, int(active.sum())


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
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Traversee Cristalline Lac V1 (FTX1)')
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


def ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools):
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
        Name={'DefaultText': 'Fin Traversee Cristalline - Sanctuaire des Trois Cristaux (4:3)', 'LocalTexts': {}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1,
        ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur D16P31A (Crystal Lake) ; cristaux, dalles et scintillements '
                'en boucles fermees. Aucune sortie, aucun warp.',
    )
    o['obstacles'] = [
        [{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])} for y in range(gh)]
        for x in range(gw)
    ]
    mk = lambda n, p, d=4: {
        'EntName': n, 'Direction': d, 'EntEnabled': True, 'triggerType': 0,
        'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16},
    }
    o['Entities'] = [{
        'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
        'Markers': [mk('entrance', entry_px, 4), mk('boss', boss_px, 0), mk('objectif', goal_px, 4)],
    }]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(
        STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
        f'-- {ASSET} : fin de donjon, aucune sortie, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode(),
    )
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Traversee Cristalline Lac 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Fin de donjon 4:3 referencee sur D16P31A (Crystal Lake) : passe sud (entrance), arene sarcelle et dalles lumineuses (boss), sanctuaire des trois massifs de cristal cyan au nord (objectif, sans sortie).</Description>
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
    order = ['cristaux_iliens', 'cristaux_paroi', 'dalles', 'rochers', 'cailloux', 'halos_sol', 'ombres', 'sable', 'rebords', 'parois']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    cand = ex['sable'] | ex['ombres'] | ex['halos_sol'] | ex['dalles'] | ex['cailloux']
    cl, _ = nd.label(cand)
    seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    lueur_dalles, slab_px = slab_frames(layers['dalles'], ex['dalles'])
    lueur_cristaux, cryst_px = crystal_frames(layers['cristaux_iliens'], ex['cristaux_iliens'],
                                             layers['cristaux_paroi'], ex['cristaux_paroi'])
    scintillements = mote_frames()
    anim = {'lueur_dalles': lueur_dalles, 'lueur_cristaux': lueur_cristaux, 'scintillements': scintillements}

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

    def snap_free(tx, ty):
        cx, cy = tx // 8, ty // 8
        for rad in range(0, 20):
            for dy in range(-rad, rad + 1):
                for dx in range(-rad, rad + 1):
                    nx, ny = cx + dx, cy + dy
                    if 0 <= nx < gw_ - 1 and 0 <= ny < gh_ - 1 and not blocked[ny:ny + 2, nx:nx + 2].any():
                        return [nx * 8, ny * 8]
        raise RuntimeError('no free 16x16 cell')

    boss_px = snap_free(W // 2 - 8, 368)
    goal_px = snap_free(W // 2 - 8, 248)
    r_eb, exp_eb = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    r_bg, exp_bg = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (goal_px[1] // 8, goal_px[0] // 8))
    assert r_eb and r_bg, f'chemin 16x16 invalide: eb={r_eb}, bg={r_bg}'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 80, 200, 255)), (goal_px, (60, 240, 160, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov)
    col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    sheet = Image.new('RGBA', (len(CRYST_RAMP) * 28 + 16, 128), (18, 36, 48, 255))
    dr_s = ImageDraw.Draw(sheet)
    for i, c in enumerate(CRYST_RAMP):
        dr_s.rectangle([8 + i * 28, 8, 8 + i * 28 + 24, 32], fill=(*c, 255))
    for i, c in enumerate(SLAB_RAMP):
        dr_s.rectangle([8 + i * 28, 40, 8 + i * 28 + 24, 64], fill=(*c, 255))
    for j, shape in enumerate(('point', 'croix')):
        spr = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                spr[2 + dy, 2 + dx] = (*GLOW, 255)
            spr[2, 2] = (*CORE, 255)
        else:
            spr[2, 2] = (*DOT, 255)
        sheet.alpha_composite(Image.fromarray(spr).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 76))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(
        OUT / f'{PFX}_fin_traversee_cristalline_lac_calques.ora',
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
    )
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, boss_px, goal_px, gfx, tools,
    )
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'parois'), ('cristal', 'cristaux_iliens'), ('halo', 'halos_sol')):
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
        'lot': 'fin_traversee_cristalline_lac_v1',
        'prefix': PFX,
        'type_zone': 'fin_de_donjon',
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'code_rom': 'D16P31A', 'frames_rom': 29},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'segmentation_mesures': seg,
        'fidelite_rip': {'brut': fid, 'calques_finaux': final_fid},
        'layers': layer_list,
        'lueur_cristaux': {'rampe': [list(c) for c in CRYST_RAMP], 'facettes_px': cryst_px,
                           'phases': PHASES, 'frame_length_ticks': TICKS, 'dephasage_massifs': [0, 8, 16]},
        'lueur_dalles': {'rampe': [list(c) for c in SLAB_RAMP], 'dalles_px': slab_px,
                         'phases': PHASES, 'frame_length_ticks': TICKS},
        'scintillements': {'motes': [list(m) for m in MOTES], 'phases': PHASES, 'frame_length_ticks': TICKS},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {
            'entry_px': entry_px, 'boss_px': boss_px, 'goal_px': goal_px,
            'path_entry_to_boss_16x16': r_eb, 'path_boss_to_goal_16x16': r_bg,
            'cells_explored': exp_eb, 'blocked_cells': int(blocked.sum()),
            'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
        },
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts,
                 'banks': list(counts), 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'goal': goal_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()),
                      'fidelite': {k: v['distance'] for k, v in fid.items()}}, indent=2))


if __name__ == '__main__':
    build()
