"""Entrée Lac Cristal / Crystal Lake sud -> nord V1 (ELC1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « go la suite ! » (suite de la série : nouveaux biomes Explorateurs du Ciel — Crystal Lake `lakecrystalpmdsky.png`).
Référence `lakecrystalpmdsky.png` (696 x 600) : Lac Cristal / Crystal Lake (Pokémon Donjon Mystère :
Explorateurs du Temps / de l'Ombre / du Ciel), eau profonde bleu azur à réseau de caustiques, chaussée et esplanade
de dalles hexagonales de cristal cyan lumineux, amas de cristaux taillés et colonnes hexagonales de cristal bleu-glace.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), arrivée au sud sur la chaussée de cristal cyan au-dessus du lac,
  grande esplanade circulaire de dalles hexagonales au centre, bordée d'amas de cristaux et de colonnes hexagonales,
  îlots cristallins flottant sur le lac et arche de cristal au nord (`donjon_seuil`) ;
- temoin_sans_objets.png : même scène sans les colonnes, amas de cristaux, arche nord ni îlots (recalé (0, 0)) ;
- cristal_eclats_poses.png : planche de 18 poses style PMD (6 étoiles d'éclat cristallin, 6 anneaux hexagonaux de
  lumière cyan, 6 prismes de glace flottants) générée sur fond magenta pur #FF00FF.
Calques : sol complet, eau, ilots_cristal, dalles_cristal, dalles_claires, cristaux, piliers, arche_cristal.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- reflets_eau : ondulation des caustiques bleu azur sur l'eau du lac (strictement à l'intérieur de l'eau, sans liseré clair en berge) ;
- lueur_cristal : anneaux hexagonaux de lumière cyan (poses de cristal_eclats_poses.png) pulsant sur les dalles et l'arche ;
- eclats_cristal : étoiles cristallines et prismes de glace (poses de cristal_eclats_poses.png) scintillant sur les piliers et îlots.
Scène : PPCM(120, 120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_lac_cristal_sud_nord_v1/build.py
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
OUT = R / 'renders/entree_lac_cristal_sud_nord_v1'
STAGE = R / '.cache/entree_lac_cristal_sud_nord_v1/entree_lac_cristal_sud_nord'
NAMESPACE = 'entree_lac_cristal_sud_nord'
ASSET = 'elc1_entree_lac_cristal'
PFX = 'ELC1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_lac_cristal_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'WIDE LANDSCAPE 4:3 (1200x896), zoomed out, top-down 3/4 Nintendo DS Pokemon Mystery Dungeon Explorers of Sky '
     'pixel art environment map of Crystal Lake passage (South to North), strictly matching the exact colors, pixel '
     'art textures, and palette of the reference image lakecrystalpmdsky.png. Deep azure rippling lake water (#33739C '
     'with #245A80 and #4A8EB8 caustic net pattern) fills the left and right sides of the map. Running vertically from '
     'the bottom center (south entrance) to the top center (north exit) is a luminous cyan-blue hexagonal crystal '
     'causeway (#86E4F8 and #B8F4FF glowing crystal tiles) that widens in the middle into a grand circular crystal '
     'plaza before narrowing again into a crystal bridge exiting at the top center (north). Along the left and right '
     'edges of the crystal causeway and central plaza are clusters of sharp faceted ice-blue crystals (#59A6CB, '
     '#387898, #C8F8FF) and hexagonal crystal columns jutting out above the blue water, with a few small isolated '
     'crystal islets floating in the lake on the left and right. Crisp DS pixel art, no characters, no UI, no text.',
     'essais': 'premier essai ; conforme (eau 4.1, dalles_cristal 6.4, cristaux_piliers 13.9)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png', REF_NAME], 'prompt':
     'Exact same 1200x896 top-down Nintendo DS Pokemon Mystery Dungeon Crystal Lake passage map as the first reference '
     'image, keeping the exact same deep azure rippling lake water (#33739C) on the left and right and the exact same '
     'glowing cyan-blue hexagonal crystal floor causeway and central circular plaza (#86E4F8, #B8F4FF) in the exact '
     'same pixel positions, but with ALL raised crystal clusters, hexagonal crystal pillars, northern crystal arch, '
     'and floating lake crystal islets completely removed and replaced seamlessly by the flat glowing cyan-blue '
     'hexagonal crystal floor tiles (#86E4F8) on the causeway/plaza and deep azure lake water (#33739C) in the lake. '
     'Flat clean ground-and-water witness image, no pillars, no crystal clusters, no arch.',
     'essais': 'premier essai ; recalage (0, 0) ecart 3.44'},
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

# Fenêtres (y0, y1, x0, x1, facteur de réduction k) sur cristal_eclats_poses.png (1114 x 960).
POSE_BOXES = {
    'etoile_0': (16, 188, 60, 124, 6),
    'etoile_1': (16, 188, 232, 322, 6),
    'etoile_2': (16, 188, 412, 514, 6),
    'etoile_3': (16, 188, 564, 738, 6),
    'etoile_4': (16, 188, 776, 902, 6),
    'etoile_5': (56, 160, 976, 1072, 6),
    'anneau_0': (260, 368, 44, 140, 5),
    'anneau_1': (260, 368, 228, 330, 5),
    'anneau_2': (260, 368, 392, 538, 5),
    'anneau_3': (260, 368, 564, 740, 5),
    'anneau_4': (260, 368, 748, 930, 5),
    'anneau_5': (260, 368, 938, 1110, 5),
    'prisme_0': (476, 636, 66, 120, 7),
    'prisme_1': (476, 636, 246, 310, 7),
    'prisme_2': (476, 636, 418, 512, 7),
    'prisme_3': (456, 654, 610, 694, 7),
    'prisme_4': (476, 636, 802, 878, 7),
    'prisme_5': (476, 636, 992, 1060, 7),
}

PALETTE_GROUPS = {
    'eau': (['sol_complet', 'eau'], 96),
    'dalles': (['dalles_cristal', 'dalles_claires'], 96),
    'ilots_cristaux': (['ilots_cristal', 'cristaux'], 96),
    'piliers_arche': (['piliers', 'arche_cristal'], 96),
}
STATIC = ['eau', 'ilots_cristal', 'dalles_cristal', 'dalles_claires', 'cristaux', 'piliers', 'arche_cristal']
ANIMS = ['reflets_eau', 'lueur_cristal', 'eclats_cristal']

WATER_CAUSTIC_PAL = [
    (44, 108, 150),
    (56, 124, 166),
    (68, 140, 182),
    (82, 154, 194),
]

RING_SITES = [
    # (cx, cy, phase_offset)
    (384, 52, 0),
    (384, 196, 4),
    (332, 268, 8),
    (436, 268, 12),
    (384, 340, 16),
    (384, 468, 20),
]

SPARK_SITES = [
    # (cx, cy, phase_offset, use_prism)
    (338, 44, 0, False),
    (430, 44, 3, False),
    (264, 188, 6, True),
    (504, 188, 9, True),
    (232, 276, 12, False),
    (536, 276, 15, False),
    (292, 368, 18, True),
    (476, 368, 21, True),
    (112, 224, 2, False),
    (656, 232, 10, False),
    (336, 512, 14, False),
    (432, 512, 22, False),
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM = V1.JM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def materials(a):
    """Même classifieur pixel sur le rip lakecrystalpmdsky.png et sur le décor généré :
    eau (lac bleu azur à caustiques), dalles_cristal (sol hexagonal cyan), dalles_claires (cœurs hexagonaux cyan-blanc),
    cristaux_piliers (amas de cristaux et colonnes hexagonales bleu-glace)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]
    mag = (r - g > 60) & (b - g > 60)
    eau = (b > 110) & (b < 185) & (g > 75) & (g < 145) & (r < 75) & (b - r > 60) & ~mag
    dalles_claires = (b > 220) & (g > 200) & ((r + g + b) > 610) & ~mag
    dalles_cristal = (b > 205) & (g > 175) & (r >= 75) & ((r + g + b) <= 610) & ~dalles_claires & ~mag
    cristaux_piliers = (b > 140) & (b <= 230) & (g > 115) & (r >= 50) & (r < 165) & ~dalles_cristal & ~dalles_claires & ~eau & ~mag
    return {'eau': eau, 'dalles_cristal': dalles_cristal, 'dalles_claires': dalles_claires, 'cristaux_piliers': cristaux_piliers}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def recalage(a, o, zone):
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(o, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen': round(err[(0, 0)], 2), 'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def classify(a, t):
    """Segmentation pleine résolution (1200 x 896) à partir de decor.png (a) et temoin_sans_objets.png (t) :
    - eau : lac bleu azur entourant la chaussée et l'esplanade (hors îlots et cristaux de rive), bloqué ;
    - ilots_cristal : îlots de cristal détachés flottant sur le lac, bloqués ;
    - arche_cristal : arche et colonnes de cristal encadrant le seuil nord, bloquées ;
    - piliers : grandes colonnes hexagonales de cristal sur le pourtour nord/central, bloquées ;
    - cristaux : amas de cristaux taillés bordant la chaussée et l'esplanade, bloqués ;
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

    # Arche nord (y < 145, x in 430..770) en laissant le passage central (x in 568..632) ouvert :
    arche_box = (terre_zone | rim_from_water) & (yy < 145) & (xx >= 430) & (xx <= 770) & ((diff > 18) | rim_from_water)
    arche_cristal = nd.binary_fill_holes(nd.binary_closing(arche_box, iterations=2))
    doorway = (xx >= 568) & (xx <= 632) & (yy >= 0) & (yy <= 155)
    arche_cristal &= ~doorway

    near_water = nd.binary_dilation(eau_zone, iterations=36)
    bright_floor = terre_zone & (bt > 210) & (gt > 182) & (rt > 85) & (diff <= 22)
    rim_on_terre = terre_zone & ~arche_cristal & ~bright_floor & ((diff > 22) | (near_water & ((b < 205) | (r < 92))))
    rim_on_terre &= ~((xx >= 564) & (xx <= 636))
    rim_all = (rim_from_water | rim_on_terre) & ~arche_cristal & ~ilots_cristal
    rim_all = nd.binary_fill_holes(nd.binary_closing(rim_all, iterations=2)) & ~arche_cristal & ~ilots_cristal

    piliers = rim_all & (yy < 360)
    cristaux = rim_all & ~piliers
    _, nb_piliers = nd.label(piliers)
    _, nb_cristaux = nd.label(cristaux)

    eau = eau_zone & ~ilots_cristal & ~rim_all & ~arche_cristal
    sol_cristal = ~eau & ~ilots_cristal & ~arche_cristal & ~piliers & ~cristaux
    dalles_claires = sol_cristal & ((r + g + b) > 610)
    dalles_cristal = sol_cristal & ~dalles_claires

    m = {
        'arche_cristal': arche_cristal,
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


def sprite_mask(crop):
    """Masque des pixels cyan/blanc sur fond magenta pur #FF00FF."""
    r, g, b = crop.transpose(2, 0, 1)
    return (b > 175) & (g > 140) & ~((r > 185) & (g < 125) & (b > 185))


def sheet_poses(path):
    """Extrait et réduit les 18 poses de cristal (étoiles, anneaux hexagonaux, prismes) depuis cristal_eclats_poses.png, quantifiées sur 12 couleurs."""
    src = rgb(path)
    all_px = []
    for box in POSE_BOXES.values():
        y0, y1, x0, x1, k = box
        crop = src[y0:y1, x0:x1]
        m = sprite_mask(crop)
        all_px.append(crop[m])
    px = np.concatenate(all_px, axis=0)
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=12, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:36], float).reshape(-1, 3)
    poses = {}
    for name, (y0, y1, x0, x1, k) in POSE_BOXES.items():
        h = ((y1 - y0) // k) * k
        w = ((x1 - x0) // k) * k
        crop = src[y0:y0 + h, x0:x0 + w]
        fg = sprite_mask(crop)
        nh, nw = h // k, w // k
        cov = fg.reshape(nh, k, nw, k).mean((1, 3))
        cov_min = 0.08 if name.startswith('etoile') else 0.14
        keep = cov >= cov_min
        out = np.zeros((nh, nw, 4), 'uint8')
        for y in range(nh):
            for x in range(nw):
                if keep[y, x]:
                    sub_fg = fg[y * k:(y + 1) * k, x * k:(x + 1) * k]
                    sub_px = crop[y * k:(y + 1) * k, x * k:(x + 1) * k][sub_fg]
                    med = np.median(sub_px, axis=0)
                    idx = int(np.argmin(np.linalg.norm(pal - med, axis=1)))
                    out[y, x, :3] = pal[idx].round().astype('uint8')
                    out[y, x, 3] = 255
        poses[name] = out
    return poses, pal.round().astype(int)


def paste_center(dst, spr, cx, cy, mirror=False):
    s = spr[:, ::-1] if mirror else spr
    sh, sw = s.shape[:2]
    y0, x0 = int(cy) - sh // 2, int(cx) - sw // 2
    sy0, sx0 = max(0, -y0), max(0, -x0)
    sy1, sx1 = min(sh, H - y0), min(sw, W - x0)
    if sy0 >= sy1 or sx0 >= sx1:
        return
    sub = s[sy0:sy1, sx0:sx1]
    m = sub[..., 3] == 255
    reg = dst[y0 + sy0:y0 + sy1, x0 + sx0:x0 + sx1]
    reg[m] = sub[m]


def reflets_eau_frames(eau_layer, eau_mask, ts=range(PHASES)):
    """Ondulation des caustiques bleu azur sur l'eau du lac (24 x 5 ticks, boucle fermée, strictement à l'intérieur
    de l'eau érodée de 3 px pour ne jamais créer de liseré clair en berge)."""
    inner = nd.binary_erosion(eau_mask, iterations=3)
    b = eau_layer[..., 2].astype(int)
    yy, xx = np.mgrid[:H, :W]
    # Zones de caustiques scintillantes réparties sur le lac :
    grid_mask = ((xx // 24 + yy // 24) % 3 == 0)
    caustic = inner & (b >= 170) & grid_mask
    frames = []
    for t in ts:
        tm = t % PHASES
        fr = np.zeros((H, W, 4), 'uint8')
        phase_wave = (xx // 4 + yy // 4 + tm) % 12
        m0 = caustic & (phase_wave == 0)
        m1 = caustic & (phase_wave == 1)
        m2 = caustic & (phase_wave == 2)
        m3 = caustic & (phase_wave == 3)
        for m_sub, col in ((m0, WATER_CAUSTIC_PAL[0]), (m1, WATER_CAUSTIC_PAL[1]), (m2, WATER_CAUSTIC_PAL[2]), (m3, WATER_CAUSTIC_PAL[3])):
            fr[m_sub, :3] = col
            fr[m_sub, 3] = 255
        frames.append(fr)
    return frames


def lueur_cristal_frames(poses, ts=range(PHASES)):
    """Anneaux hexagonaux de lumière cyan pulsant sur les dalles de cristal et le seuil nord (24 x 5 ticks)."""
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
    """Étoiles cristallines et prismes de glace scintillant sur les piliers et îlots (24 x 5 ticks)."""
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


def write_ora(path, layers):
    root = ET.Element('image', w=str(W), h=str(H), version='0.0.5')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256)); b = io.BytesIO(); th.save(b, format='PNG')
        z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
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
    o.update(Name={'DefaultText': 'Entree Lac Cristal (Crystal Lake) - sud vers nord (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur lakecrystalpmdsky.png ; reflets d eau, lueur et '
                     'eclats de cristal animes. Collisions de base a verifier. Seuil non raccorde.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
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
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Lac Cristal (Crystal Lake) sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : chaussee et esplanade hexagonale de cristal cyan sur le Lac Cristal, piliers de glace et arche au nord (ref. lakecrystalpmdsky.png). Pas une aventure jouable.</Description>
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

    order = ['arche_cristal', 'piliers', 'cristaux', 'ilots_cristal', 'dalles_claires', 'dalles_cristal', 'eau']
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
    threshold_px = [376, 16]
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
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
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

    write_ora(OUT / f'{PFX}_entree_lac_cristal_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('eau', 'eau'), ('dalles_cristal', 'dalles_cristal'), ('dalles_claires', 'dalles_claires'), ('cristaux_piliers', 'cristaux')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'entree_lac_cristal_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Lac Cristal / Crystal Lake (Explorateurs du Ciel), chaussee et esplanade hexagonale de cristal cyan sur lac bleu azur',
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
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (dalles_cristal, dalles_claires)',
                   'seuil': 'case 2 x 2 libre sous l arche de cristal au nord'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
