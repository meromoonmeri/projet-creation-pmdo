"""Fin de donjon Lac Cristal / Crystal Lake V1 (FLC1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « go la suite ! » (suite de la série : fin de donjon Crystal Lake `lakecrystalpmdsky.png`).
Référence `lakecrystalpmdsky.png` (696 x 600) : Lac Cristal / Crystal Lake (Pokémon Donjon Mystère :
Explorateurs du Temps / de l'Ombre / du Ciel), eau profonde bleu azur à réseau de caustiques, chaussée et péninsule
de dalles hexagonales de cristal cyan lumineux, amas de cristaux taillés et colonnes hexagonales de cristal bleu-glace.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), arrivée au sud sur la chaussée de cristal cyan au-dessus du lac,
  grande péninsule circulaire de dalles hexagonales au centre (`boss`), fermée au nord par une couronne de colonnes
  hexagonales de cristal et par l'Autel de Cristal / Prisme Souverain à degrés au nord-centre (`autel_cristal`, `objectif`),
  sans aucune sortie nord ;
- temoin_sans_objets.png : même scène sans l'autel de cristal, les colonnes, les amas de cristaux ni les îlots (recalé (0, 0)) ;
- cristal_eclats_poses.png : planche de 18 poses style PMD (6 étoiles d'éclat cristallin, 6 anneaux hexagonaux de
  lumière cyan, 6 prismes de glace flottants) générée sur fond magenta pur #FF00FF.
Calques : sol complet, eau, ilots_cristal, dalles_cristal, dalles_claires, cristaux, piliers, autel_cristal.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- reflets_eau : ondulation des caustiques bleu azur sur l'eau du lac (strictement à l'intérieur de l'eau, sans liseré clair en berge) ;
- lueur_cristal : anneaux hexagonaux de lumière cyan (poses de cristal_eclats_poses.png) pulsant autour de l'autel et sur la péninsule ;
- eclats_cristal : étoiles cristallines et prismes de glace (poses de cristal_eclats_poses.png) scintillant sur l'autel, les piliers et les îlots.
Scène : PPCM(120, 120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_lac_cristal_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'lakecrystalpmdsky.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_lac_cristal_v1'
STAGE = R / '.cache/fin_lac_cristal_v1/fin_lac_cristal'
NAMESPACE = 'fin_lac_cristal'
ASSET = 'flc1_fin_lac_cristal'
PFX = 'FLC1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_lac_cristal_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'WIDE LANDSCAPE 4:3 (1200x896), zoomed out, top-down 3/4 Nintendo DS Pokemon Mystery Dungeon Explorers of Sky '
     'pixel art environment map of the Crystal Lake Sanctuary peninsula (closed northern cul-de-sac), strictly '
     'matching the exact colors, pixel art textures, and palette of the reference image lakecrystalpmdsky.png. Deep '
     'azure rippling lake water (#33739C with #245A80 and #4A8EB8 caustic net pattern) surrounds the entire northern, '
     'eastern, and western sides of the map — NO northern exit bridge. A luminous cyan-blue hexagonal crystal causeway '
     '(#86E4F8 and #B8F4FF glowing crystal tiles) enters from the bottom center (south) between sharp ice-blue crystal '
     'clusters (#59A6CB) and opens into a large circular glowing cyan-blue crystal peninsula in the center. The '
     'northern rim of the peninsula is completely closed by a grand crescent crown of tall hexagonal ice-blue crystal '
     'pillars (#59A6CB, #C8F8FF) and a central raised hexagonal Crystal Altar / Sovereign Prism at the north-center '
     'edge overlooking the deep blue lake, with small detached crystal islets floating in the water beyond the '
     'northern rim. Crisp DS pixel art, no characters, no UI, no text.',
     'essais': 'premier essai ; conforme (eau 4.4, dalles_cristal 8.4, dalles_claires 6.1, cristaux_piliers 8.8)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png', REF_NAME], 'prompt':
     'Exact same 1200x896 top-down Nintendo DS Pokemon Mystery Dungeon Crystal Lake sanctuary peninsula map as the '
     'first reference image, keeping the exact same deep azure rippling lake water (#33739C) and the exact same '
     'glowing cyan-blue hexagonal crystal floor causeway and central circular peninsula (#86E4F8, #B8F4FF) in the '
     'exact same pixel positions, but with ALL raised crystal clusters, northern hexagonal crystal pillars, central '
     'stepped crystal altar, and floating lake crystal islets completely removed and replaced seamlessly by the flat '
     'glowing cyan-blue hexagonal crystal floor tiles (#86E4F8) on the peninsula and deep azure lake water (#33739C) '
     'in the lake. Flat clean ground-and-water witness image, no altar, no pillars, no crystal clusters.',
     'essais': 'premier essai ; recalage (0, 0) ecart 4.10'},
    {'file': 'cristal_eclats_poses.png', 'images': [REF_NAME], 'prompt':
     '2D Nintendo DS Pokemon Mystery Dungeon Explorers of Sky pixel-art sprite sheet on a solid, uniform, flat pure '
     'magenta #FF00FF background (RGB 255, 0, 255) with NO anti-aliasing against the magenta background and NO '
     'magenta inside the sprites. Contains 18 well-separated cyan-blue and ice-white crystal light & sparkle '
     'animation sprites inspired by lakecrystalpmdsky.png arranged in 3 clean rows with generous #FF00FF spacing: '
     'Row 1 (6 poses): 4-point and 8-point PMD crystal star sparkles growing from a tiny cyan-white diamond dot '
     '(#78E0F8, #C8F8FF, #FFFFFF) to a bright 8-point crystal star burst and dissipating into 4 tiny ice motes. '
     'Row 2 (6 poses): hexagonal cyan-blue crystal floor light rings / energy ripples (#58C8F0, #98ECF8, #E0FFFF) '
     'expanding from a small hexagon to a wide thin hexagonal light crown. Row 3 (6 poses): floating vertical crystal '
     'shards / ice prisms glinting in cyan and white. Crisp 1-pixel stepped edges, no text, no grid lines.',
     'essais': 'premier essai ; 18 poses extraites sur fond magenta (6 etoiles, 6 anneaux hexagonaux, 6 prismes)'},
]

PALETTE_GROUPS = {
    'eau': (['sol_complet', 'eau'], 96),
    'dalles': (['dalles_cristal', 'dalles_claires'], 96),
    'ilots_cristaux': (['ilots_cristal', 'cristaux'], 96),
    'piliers_autel': (['piliers', 'autel_cristal'], 96),
}
STATIC = ['eau', 'ilots_cristal', 'dalles_cristal', 'dalles_claires', 'cristaux', 'piliers', 'autel_cristal']
ANIMS = ['reflets_eau', 'lueur_cristal', 'eclats_cristal']

RING_SITES = [
    # (cx, cy, phase_offset)
    (384, 156, 0),
    (384, 212, 4),
    (326, 268, 8),
    (442, 268, 12),
    (384, 336, 16),
    (384, 464, 20),
]

SPARK_SITES = [
    # (cx, cy, phase_offset, use_prism)
    (384, 96, 0, False),
    (352, 136, 2, True),
    (416, 136, 4, True),
    (268, 176, 6, False),
    (500, 176, 8, False),
    (216, 264, 10, True),
    (552, 264, 12, True),
    (264, 356, 14, False),
    (504, 356, 16, False),
    (112, 208, 18, False),
    (656, 208, 20, False),
    (384, 248, 22, False),
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


ELC1 = loadmod('elc1_build', R / 'source/entree_lac_cristal_sud_nord_v1/build.py')
V1 = ELC1.V1
JM = ELC1.JM
POSE_BOXES = ELC1.POSE_BOXES
WATER_CAUSTIC_PAL = ELC1.WATER_CAUSTIC_PAL
sha, rgb, lum_of, materials, fidelity, recalage = ELC1.sha, ELC1.rgb, ELC1.lum_of, ELC1.materials, ELC1.fidelity, ELC1.recalage
sheet_poses, paste_center, reflets_eau_frames, write_ora = ELC1.sheet_poses, ELC1.paste_center, ELC1.reflets_eau_frames, ELC1.write_ora
cell_grid, down_class, down_full, rgba, quantize_group = V1.cell_grid, V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def classify(a, t):
    """Segmentation pleine résolution (1200 x 896) à partir de decor.png (a) et temoin_sans_objets.png (t) :
    - eau : lac bleu azur entourant la chaussée et la péninsule (hors îlots et cristaux de rive), bloqué ;
    - ilots_cristal : îlots de cristal détachés flottant sur le lac au nord et sur les flancs, bloqués ;
    - autel_cristal : Autel de Cristal hexagonal à degrés et Prisme Souverain au nord-centre, bloqué ;
    - piliers : couronne nord de colonnes hexagonales de cristal bleu-glace, bloquées ;
    - cristaux : amas de cristaux taillés bordant la chaussée et la péninsule, bloqués ;
    - dalles_claires : cœurs hexagonaux cyan-blanc très lumineux du sol de cristal, praticables ;
    - dalles_cristal : dalles hexagonales cyan du sol de cristal, praticables."""
    af = a.astype(int); tf = t.astype(int)
    H0, W0, _ = af.shape
    yy, xx = np.mgrid[:H0, :W0]
    r, g, b = af.transpose(2, 0, 1)
    rt, gt, bt = tf.transpose(2, 0, 1)
    diff = np.abs(af - tf).max(2)

    eau_t = nd.binary_fill_holes((rt < 95) & (gt < 165) & (bt < 200))
    wl, _ = nd.label(eau_t)
    eau_zone = (wl == wl[100, 50]) | (wl == wl[100, 1150])
    terre_zone = ~eau_zone
    near_terre = nd.binary_dilation(terre_zone, iterations=6)

    in_water_obj = eau_zone & (diff > 25)
    in_water_obj = nd.binary_fill_holes(nd.binary_closing(in_water_obj, iterations=2)) & eau_zone
    lbl, n = nd.label(in_water_obj)
    ilots_cristal = np.zeros_like(in_water_obj)
    rim_from_water = np.zeros_like(in_water_obj)
    nb_ilots = 0
    for i in range(1, n + 1):
        comp = lbl == i
        if int(comp.sum()) < 150:
            continue
        if (comp & near_terre).any():
            rim_from_water |= comp
        else:
            ilots_cristal |= comp
            nb_ilots += 1

    # Autel de cristal à degrés et Prisme Souverain au nord-centre (y in 55..296, x in 495..705) :
    autel_box = (terre_zone | rim_from_water) & (yy >= 55) & (yy <= 296) & (xx >= 495) & (xx <= 705) & ((diff > 16) | rim_from_water)
    autel_cristal = nd.binary_fill_holes(nd.binary_closing(autel_box, iterations=2))

    near_water = nd.binary_dilation(eau_zone, iterations=36)
    bright_floor = terre_zone & (bt > 210) & (gt > 182) & (rt > 85) & (diff <= 22)
    rim_on_terre = terre_zone & ~autel_cristal & ~bright_floor & ((diff > 22) | (near_water & ((b < 205) | (r < 92))))
    rim_on_terre &= ~((xx >= 540) & (xx <= 660) & (yy > 296))
    rim_all = (rim_from_water | rim_on_terre) & ~autel_cristal & ~ilots_cristal
    rim_all = nd.binary_fill_holes(nd.binary_closing(rim_all, iterations=2)) & ~autel_cristal & ~ilots_cristal

    piliers = rim_all & (yy < 340)
    cristaux = rim_all & ~piliers
    _, nb_piliers = nd.label(piliers)
    _, nb_cristaux = nd.label(cristaux)

    eau = eau_zone & ~ilots_cristal & ~rim_all & ~autel_cristal
    sol_cristal = ~eau & ~ilots_cristal & ~autel_cristal & ~piliers & ~cristaux
    dalles_claires = sol_cristal & ((r + g + b) > 610)
    dalles_cristal = sol_cristal & ~dalles_claires

    m = {
        'autel_cristal': autel_cristal,
        'piliers': piliers,
        'cristaux': cristaux,
        'ilots_cristal': ilots_cristal,
        'dalles_claires': dalles_claires,
        'dalles_cristal': dalles_cristal,
        'eau': eau,
    }
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in m.items()}
    seg.update({'nb_ilots': nb_ilots, 'nb_piliers': int(nb_piliers), 'nb_cristaux': int(nb_cristaux)})
    return m, seg


def lueur_cristal_frames(poses, ts=range(PHASES)):
    """Anneaux hexagonaux de lumière cyan pulsant autour de l'autel et sur la péninsule (24 x 5 ticks)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for cx, cy, p0 in RING_SITES:
            dt = (tm - p0) % 12
            if dt < 6:
                paste_center(fr, poses[f'anneau_{dt}'], cx, cy)
        frames.append(fr)
    return frames


def eclats_cristal_frames(poses, ts=range(PHASES)):
    """Étoiles cristallines et prismes de glace scintillant sur l'autel, les piliers et les îlots (24 x 5 ticks)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for cx, cy, p0, use_prism in SPARK_SITES:
            dt = (tm - p0) % 12
            if dt < 6:
                kind = 'prisme' if use_prism else 'etoile'
                paste_center(fr, poses[f'{kind}_{dt}'], cx, cy, mirror=(dt % 2 == 1))
        frames.append(fr)
    return frames


def ground_project(stack, blocked, entry_px, boss_px, objectif_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))
    o = tpl['Object']; gw, gh = W // 8, H // 8; layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0); bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs
        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks)); banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': 'Fin Lac Cristal (Crystal Lake) - Sanctuaire du Prisme (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur lakecrystalpmdsky.png ; reflets d eau, lueur et '
                     'eclats de cristal animes. Fin de donjon sans sortie.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : fin de donjon Lac Cristal, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Lac Cristal (Crystal Lake) 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : peninsule de boss au coeur du Lac Cristal, Autel de Cristal et Prisme Souverain au nord (ref. lakecrystalpmdsky.png). Pas une aventure jouable.</Description>
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
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, tm, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(REF)
    assert a.shape[:2] == tm.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, tm)
    reg = {'temoin_sans_objets': recalage(a, tm, nd.binary_erosion(m['eau'] | m['dalles_cristal'], iterations=6))}

    order = ['autel_cristal', 'piliers', 'cristaux', 'ilots_cristal', 'dalles_claires', 'dalles_cristal', 'eau']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(tm), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    cand = ex['dalles_cristal'] | ex['dalles_claires']
    cl, _ = nd.label(cand)
    seed = cl[H - 1, np.nonzero(cand[H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    poses, pose_pal = sheet_poses(RAW / 'cristal_eclats_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    anim = {
        'reflets_eau': reflets_eau_frames(layers['eau'], ex['eau']),
        'lueur_cristal': lueur_cristal_frames(poses),
        'eclats_cristal': eclats_cristal_frames(poses),
    }

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
    blocked[0, :] = True
    blocked[:, 0] = True
    blocked[:, -1] = True
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    boss_px = [376, 288]
    objectif_px = [376, 200]
    while blocked[objectif_px[1] // 8:objectif_px[1] // 8 + 2, objectif_px[0] // 8:objectif_px[0] // 8 + 2].any():
        objectif_px[1] += 8
    reach_boss, exp_boss = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_obj, exp_obj = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_boss and reach_obj, 'pas de chemin 16x16 vers boss ou objectif'

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
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 90, 90, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    names = list(POSE_BOXES)
    cw, ch = 110, 110
    sheet = Image.new('RGBA', (6 * cw + 8, 3 * ch + 8), (28, 58, 84, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm])
        im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * ch
        sheet.alpha_composite(im, (cx0 + max(0, (cw - 8 - im.width) // 2), cy0 + max(0, (ch - 8 - im.height) // 2)))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(OUT / f'{PFX}_fin_lac_cristal_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('eau', 'eau'), ('dalles_cristal', 'dalles_cristal'), ('dalles_claires', 'dalles_claires'), ('cristaux_piliers', 'cristaux')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'fin_lac_cristal_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin_de_donjon', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (ELC1, EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Lac Cristal / Crystal Lake (Explorateurs du Ciel), peninsule de cristal cyan, Autel de Cristal et Prisme Souverain sur lac bleu azur',
        'method': 'textures canoniques = rendu genere REFERENCE : rip lakecrystalpmdsky.png passe au generateur ; '
                  'decor complet et temoin sans objets edites et recales (0, 0)',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Lac Cristal / Crystal Lake (Pokemon Donjon Mystere : Explorateurs du Ciel, lakecrystalpmdsky.png)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': False} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin sans objets : eau et dalles_cristal erodees de 6 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'reflets_eau': {'phases': PHASES, 'frame_length_ticks': TICKS,
                        'palette': [list(c) for c in WATER_CAUSTIC_PAL],
                        'origine': 'ondulation des caustiques bleu azur a l interieur de l eau (sans lisere clair en berge)'},
        'lueur_cristal': {'phases': PHASES, 'frame_length_ticks': TICKS,
                          'poses': {k: list(v) for k, v in POSE_BOXES.items() if k.startswith('anneau')},
                          'palette': [[int(v) for v in c] for c in pose_pal],
                          'sites': [list(s) for s in RING_SITES],
                          'origine': 'anneaux hexagonaux de lumiere cyan style PMD generes sur fond magenta (cristal_eclats_poses.png)'},
        'eclats_cristal': {'phases': PHASES, 'frame_length_ticks': TICKS,
                           'poses': {k: list(v) for k, v in POSE_BOXES.items() if not k.startswith('anneau')},
                           'palette': [[int(v) for v in c] for c in pose_pal],
                           'sites': [list(s) for s in SPARK_SITES],
                           'origine': 'etoiles cristallines et prismes de glace style PMD generes sur fond magenta (cristal_eclats_poses.png)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'path_found_16x16': reach_boss and reach_obj, 'cells_explored': max(exp_boss, exp_obj),
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (dalles_cristal, dalles_claires)',
                   'boss': 'case 2 x 2 libre au centre de la peninsule de cristal cyan',
                   'objectif': 'case 2 x 2 libre au pied de l Autel de Cristal et du Prisme Souverain au nord'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
