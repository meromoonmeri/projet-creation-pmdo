"""Entrée Jardin secret sud -> nord V1 (EJS1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « Lance la suite ! » (27 septembre, après EMT1) : carte suivante, biome laissé au choix de l'agent.
Référence `secretgarden.png` (408 x 408, 139 couleurs) : jardin secret (Explorers of Sky) : prairie jaune-vert, haies de
buissons, arbres ronds, rochers beiges, fleurs blanches, jaunes et roses, grande souche dorée creusée d'un trou carré
avec des marches, rayon de lumière verte qui tombe du ciel sur la souche, fond vert sombre. Jamais source d'une entrée
de la série ; utilisée seulement hors série sur deux anciennes branches (`jardin_secret_v1/v2` de 01a0d315,
`secretgarden_reseau_v1` de 01a0d4b6), dont rien n'est repris. Relevé git grep du 27 septembre sur les 72 têtes.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), premier essai, conforme ;
- temoin_sans_objets.png : le décor édité sans arbres, rochers ni fleurs (recalé (0, 0)) ; l'écart décor / témoin
  isole les objets ;
- sol_complet.png : herbe moyenne seule, éditée depuis le témoin (troisième essai ; deux essais écartés, gardés dans
  bruts/ecartes/ : touffes hautes acides 43,2 et plaques 45,7 > 35).
Calques : sol complet, prairie (herbe jaune du centre et de l'allée), herbe, ombres (herbe sombre au pied des haies,
des arbres et des rochers), fleurs, rochers, arbres, haies, souche, marches (praticables), profondeur (trou de la
souche), fond.
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks :
- rayon : le rayon du rendu, recoloré avec la rampe de 22 couleurs EXACTES du rayon du rip ; il « respire » (décalage
  de +-2 crans dans la rampe, atténué vers les bords) ;
- lucioles : étincelles aux couleurs EXACTES du rayon du rip, qui montent de la souche dans le rayon et flottent au-dessus
  des massifs de fleurs.
Scène : 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_jardin_secret_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'secretgarden.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_jardin_secret_sud_nord_v1'
STAGE = R / '.cache/entree_jardin_secret_sud_nord_v1/entree_jardin_secret_sud_nord'
NAMESPACE = 'entree_jardin_secret_sud_nord'
ASSET = 'ejs1_entree_jardin_secret'
PFX = 'EJS1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_jardin_secret_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon secret '
     'garden): same light yellow-green meadow grass with small tufts, same rounded bushy hedge borders, same round leafy '
     'trees, same tan-brown boulders, same small white, yellow and pink flowers, same big golden tree stump with a square '
     'dark hole and wooden steps, same vertical bright green light beam falling from the top edge, same dark green '
     'background. Make a NEW, larger top-down map. WIDE LANDSCAPE 4:3, zoomed out so the garden feels vast. Layout: the '
     'player arrives at the SOUTH (bottom edge center) on a grass path between bushy hedges; the path opens into a wide '
     'meadow with a few boulders, trees and flower patches; at the NORTH (top center) the big tree stump with its dark '
     'hole and steps, the green light beam falling from the top edge onto it, flowers around it, and the grass leads '
     'right up to the steps. Dark green background around the hedges. No characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Remove every round leafy tree (with its trunk and shadow), '
     'every boulder and rock, and every small flower: replace them with the same meadow grass around them. Keep the bushy '
     'hedge borders, the big golden tree stump with its dark hole and steps, the green light beam, the light grass path '
     'and the dark green background exactly as they are. No text, no border.',
     'essais': 'premier essai ; temoin de segmentation, jamais exporte'},
    {'file': 'ecartes/sol_complet_essai1_touffes.png', 'images': [f'{LOT}/bruts/decor.png'], 'ecarte': True, 'prompt':
     'Same image, same framing and pixel-art style, but only the plain medium yellow-green meadow grass with its small '
     'grass tufts everywhere, covering the whole image edge to edge, keep the texture detail, nothing else.',
     'essais': 'ECARTE : grosses touffes hautes, vert acide (148.5,178.3,28.6), distance 43.2 > 35 a l herbe du rip'},
    {'file': 'ecartes/sol_complet_essai2_plaques.png', 'images': [REF_NAME], 'ecarte': True, 'prompt':
     'Fill the ENTIRE image edge to edge with only the medium yellow-green meadow grass from the reference image (the '
     'grass around the flowers and trees, with its fine texture and a few tiny grass tufts), same pixel-art style, same '
     'palette and contrast. No tall grass clumps, no bushes, no trees, no rocks, no flowers, no path, no dark areas. '
     'Wide landscape 4:3.',
     'essais': 'ECARTE : plaques tramees, (151.2,193.5,48.3), distance 45.7 > 35 a l herbe du rip'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/temoin_sans_objets.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Replace the bushy hedges, the tree stump, the green light '
     'beam, the light central grass and the dark green background with the same medium green meadow grass that is between '
     'the hedges and the light path, with its small grass tufts, so that the whole image is only that medium meadow '
     'grass, edge to edge. No text, no border.',
     'essais': 'troisieme essai ; conforme (121.7,174.9,52.6), distance 11.0 a l herbe du rip'},
]
USED = [g for g in GEN if not g.get('ecarte')]
# ---- Rayon : rampe relevée sur le rip (zone y < 95, x 130-280, couleurs vertes du rayon, par luminance croissante ;
# les tons beiges des rochers de la même zone sont exclus).
RAMP = [(47, 95, 55), (47, 103, 55), (55, 119, 55), (63, 135, 55), (63, 151, 55), (63, 167, 55), (71, 183, 63),
        (79, 199, 71), (79, 215, 71), (87, 223, 71), (95, 231, 71), (95, 239, 71), (103, 247, 79), (111, 255, 87),
        (127, 255, 95), (151, 255, 111), (175, 255, 127), (191, 255, 135), (207, 255, 151), (231, 255, 199),
        (239, 255, 223), (255, 255, 255)]
BREATH = 2                     # amplitude du souffle, en crans de rampe
EDGE_STEPS = 6                 # les 6 premiers crans (bords sombres) sont atténués : pas d'arête contre le fond
# ---- Lucioles : (x0, y0, décalage de phase, amplitude x). Montée de 2 px par phase, oscillation sur 12 phases.
MOTES = [(336, 128, 0, 2), (434, 132, 6, 2), (360, 96, 12, 3), (414, 90, 18, 3), (346, 60, 3, 2), (428, 56, 15, 2),
         (196, 214, 4, 3), (566, 206, 10, 3), (170, 310, 16, 3), (610, 300, 22, 3)]
MOTE_RISE = 2
DOT, GLOW, CORE = (207, 255, 151), (231, 255, 199), (255, 255, 255)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'herbe': (['sol_complet', 'prairie', 'herbe', 'ombres'], 64), 'fleurs': (['fleurs'], 24),
                  'rochers': (['rochers'], 32), 'vegetation': (['arbres', 'haies'], 96),
                  'souche': (['souche', 'marches', 'profondeur'], 48), 'fond': (['fond'], 8)}
STATIC = ['prairie', 'herbe', 'ombres', 'fleurs', 'rochers', 'arbres', 'haies', 'souche', 'marches', 'profondeur', 'fond']
ANIMS = ['rayon', 'lucioles']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def sdev(l, k):
    return np.sqrt(np.maximum(nd.uniform_filter(l ** 2, k) - nd.uniform_filter(l, k) ** 2, 0))


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    """Fond vert sombre, herbe claire (prairie), herbe moyenne, roche beige."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    return {'fond': (lum < 85) & (g > r + 20) & (g > b + 15) & (lum > 55),
            'herbe_claire': (g > 185) & (r > 130) & (b < 120) & (g > r + 30),
            'herbe': (g > 140) & (g <= 185) & (g > r + 30) & (g > b + 60),
            'roche': (r >= g - 15) & (r - b > 25) & (lum > 90) & (lum < 200) & (np.abs(r - g) < 30)}


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


# ---------------------------------------------------------------- segmentation pleine résolution
def flower_px(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return ((r > 200) & (g < 160)) | (lum_of(a) > 225) | ((r > 200) & (g > 180) & (b < 110))


def classify(a, t):
    """a : décor, t : témoin sans objets. Seuils mesurés sur le brut (1200 x 896) :
    fond = lum lissée 5 px du témoin < 85, vert (g > r + 15), ouvert 3 px, relié au bord ; rayon = pixels du témoin
    très verts (g - r > 70) ou très clairs (lum > 205), y < 175, x 470-730, hors fond, fermés 2 px, reliés au bord haut ;
    souche = doré (r >= g - 12, r - b > 60) au haut-centre, fermé 4 px, > 3000 px, trous bouchés ; profondeur = lum < 75
    dans la souche, ouverte 1 px, plus grande composante ; marches = toute la souche sous le trou, dans
    sa largeur (+- 2 px), barreaux clairs et creux compris (sinon l'escalier ne rejoint pas l'herbe) ; haies = témoin texturé (écart-type 9 px > 6), fermé 3 px, > 3000 px, ouvert 5 px puis redilaté (les lisières
    fines, comme l'arc entre prairie et allée, ne sont pas des haies), petits trous (< 800 px) bouchés,
    rien dans la zone dégagée sous la souche ; objets = écart décor / témoin lissé 3 px > 28, fermé 3 px, trous bouchés,
    >= 30 px : fleurs = composantes < 400 px à >= 20 % de pixels de fleur ; rochers = beige (|r-g| < 30, r-b > 25) fermé
    2 px, trous bouchés, >= 150 px, lum moyenne > 115 (les troncs, plus sombres, restent aux arbres) ; ombres portées =
    herbe plate sombre (écart-type < 6, lum < 155, g > r + 30) ; arbres = le reste des objets (>= 300 px) ; herbe hors
    objets : prairie = b lissé 5 px < 50 (jaune), ombres = lum lissée 5 px < 150, herbe = le reste. Les composantes d'objets du décor (diff > 28) posées sur le rayon du témoin
    et dont moins de 30 % des pixels ont la couleur du rayon dans le décor (le rocher à gauche du faisceau) sortent du rayon."""
    lt, la = lum_of(t), lum_of(a); hh, ww = lt.shape; yy, xx = np.mgrid[:hh, :ww]
    r, g, b = t[..., 0], t[..., 1], t[..., 2]
    fond = open_((nd.uniform_filter(lt, 5) < 85) & (g > r + 15), 3)
    lab, _ = nd.label(fond); e = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]]); fond = np.isin(lab, e[e > 0])
    beam = ((g - r > 70) | (lt > 205)) & (yy < 175) & (xx > 470) & (xx < 730) & ~fond
    lab, _ = nd.label(close_(beam, 2)); rayon = np.isin(lab, np.unique(lab[0][lab[0] > 0])) & (yy < 175)
    rayon = nd.binary_fill_holes(rayon) & ~fond
    ra, ga = a[..., 0], a[..., 1]; beam_a = (ga - ra > 70) | (lum_of(a) > 205)
    d0 = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    ol0, on0 = nd.label(nd.binary_fill_holes(close_(d0 > 28, 3)) & rayon)
    for i in range(on0):                    # objets du décor posés sur le rayon du témoin (rocher) : hors rayon
        m = ol0 == i + 1
        if m.sum() >= 30 and beam_a[m].mean() < 0.3:
            rayon &= ~m
    gold = (r >= g - 12) & (r - b > 60) & (yy > 120) & (yy < 280) & (xx > 500) & (xx < 700)
    st = nd.binary_fill_holes(keep_large(close_(gold, 4), 3000)) & ~rayon
    hole = open_((lt < 75) & st, 1); hl, hn = nd.label(hole); hs = nd.sum(hole, hl, range(1, hn + 1))
    hole = nd.binary_fill_holes(close_(hl == int(np.argmax(hs)) + 1, 2)) & st
    hy, hx = np.nonzero(hole); sy, sx = np.nonzero(st)
    steps = st & (yy > hy.max()) & (xx >= hx.min() - 2) & (xx <= hx.max() + 2) & ~hole       # escalier entier
    front = (yy > sy.max() - 10) & (yy < sy.max() + 40) & (xx > sx.min() + 20) & (xx < sx.max() - 20) & ~st
    haie = keep_large(close_((sdev(lt, 9) > 6) & ~fond & ~rayon & ~st & ~front, 3), 3000)
    haie &= nd.binary_dilation(open_(haie, 5), iterations=5)     # lisières fines (arc prairie / allée) : pas des haies
    hol = nd.binary_fill_holes(haie) & ~haie; hl, hn = nd.label(hol); hs = nd.sum(hol, hl, range(1, hn + 1))
    haie = (haie | np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 800])) & ~fond & ~rayon & ~st & ~front
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    obj = keep_large(nd.binary_fill_holes(close_(diff > 28, 3)), 30) & ~st & ~rayon & ~fond
    ol, on = nd.label(obj); fpx = flower_px(a); fle = np.zeros_like(obj)
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if m.sum() < 400 and fpx[s][m].mean() >= 0.2:
            fle[s] |= m
    ra, ga, ba = a[..., 0], a[..., 1], a[..., 2]
    tan = (np.abs(ra - ga) < 30) & (ra - ba > 25) & (la > 80) & (la < 215) & obj & ~fle
    tl, tn = nd.label(nd.binary_fill_holes(close_(tan, 2)) & obj & ~fle); roc = np.zeros_like(obj); nroc = 0
    for i, s in enumerate(nd.find_objects(tl)):
        m = tl[s] == i + 1
        if m.sum() >= 150 and la[s][m].mean() > 115:
            roc[s] |= m; nroc += 1
    flat = (sdev(la, 9) < 6) & (la < 155) & (ga > ra + 30)
    shade = obj & ~fle & ~roc & flat
    arb = keep_large(obj & ~fle & ~roc & ~shade, 300)
    rest = obj & ~fle & ~roc & ~arb & ~shade                      # miettes : rendues à l'herbe
    grass = ~(fond | rayon | st | haie | fle | roc | arb)
    bl, ll = nd.uniform_filter(ba.astype(float), 5), nd.uniform_filter(la, 5)
    prairie = grass & ~shade & (bl < 50)
    omb = grass & ~prairie & ((ll < 150) | shade)
    herbe = grass & ~prairie & ~omb
    souche = st & ~hole & ~steps
    masks = dict(profondeur=hole, marches=steps, souche=souche, fleurs=fle, rochers=roc, arbres=arb, haies=haie,
                 fond=fond, rayon=rayon, ombres=omb, prairie=prairie, herbe=herbe)
    seg = {'objets': int(on), 'fleurs': int(nd.label(fle)[1]), 'rochers': nroc, 'arbres': int(nd.label(arb)[1]),
           'miettes_rendues_a_l_herbe_px': int(rest.sum()), 'trou_y': [int(hy.min()), int(hy.max())],
           'trou_x': [int(hx.min()), int(hx.max())], 'souche_y': [int(sy.min()), int(sy.max())],
           'ombres_lum': round(float(la[omb].mean()), 1), 'herbe_lum': round(float(la[herbe].mean()), 1),
           'prairie_b': round(float(ba[prairie].mean()), 1)}
    return masks, seg


# ---------------------------------------------------------------- rayon : rampe exacte du rip
def ramp_index(px):
    """Indice du cran de rampe le plus proche (distance RGB) pour chaque pixel."""
    rp = np.array(RAMP, float)
    return ((px[..., None, :3].astype(float) - rp) ** 2).sum(-1).argmin(-1)


def breath(t):
    return int(round(BREATH * np.sin(2 * np.pi * t / PHASES)))


def beam_frames(base_idx, mask, ts=range(PHASES)):
    rp = np.array(RAMP, 'uint8'); frames = []
    w = np.minimum(1.0, base_idx / EDGE_STEPS)
    for t in ts:
        idx = np.clip(np.round(base_idx + breath(t) * w), 0, len(RAMP) - 1).astype(int)
        a = np.zeros((H, W, 4), 'uint8'); a[mask, :3] = rp[idx[mask]]; a[mask, 3] = 255
        frames.append(a)
    return frames


# ---------------------------------------------------------------- lucioles
def mote_state(m, t):
    """(x, y, forme) de la luciole m à la phase t ; forme 'point' (1 px) ou 'croix' (croix de 3 x 3)."""
    x0, y0, off, ax = m; u = (t + off) % PHASES
    x = x0 + int(round(ax * np.sin(2 * np.pi * u / 12))); y = y0 - MOTE_RISE * u
    shape = 'croix' if 3 <= u <= 20 and u % 4 in (0, 1) else 'point'
    return x, y, shape


def mote_frames(motes, ts=range(PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for m in motes:
            x, y, shape = mote_state(m, t)
            if shape == 'croix':
                for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    a[y + dy, x + dx] = (*GLOW, 255)
                a[y, x] = (*CORE, 255)
            else:
                a[y, x] = (*DOT, 255)
        frames.append(a)
    return frames


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Jardin secret sud-nord V1 (EJS1)')
    stack = ET.SubElement(root, 'stack'); comp = Image.new('RGBA', (W, H))
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
    with zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip') as z:
        tpl = json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
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
    o.update(Name={'DefaultText': 'Entree Jardin secret - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Jardin secret ; rayon anime (rampe exacte '
                     'du rip), lucioles aux couleurs du rip. Collisions de base a verifier. Seuil non raccorde. '
                     'Biome choisi par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
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
  <Name>Entree Jardin secret sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee par une allee au sud, grande prairie fleurie, souche a marches sous un rayon de lumiere au nord, generee au format 4:3 (ref. rip Jardin secret), rayon et lucioles animes. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- main
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
    a, t, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == t.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, t)
    objs = m['fleurs'] | m['rochers'] | m['arbres'] | (np.abs(a - t).mean(2) > 10)
    reg = {'temoin': recalage(a, t, ~nd.binary_dilation(objs, iterations=4))}
    order = ['profondeur', 'marches', 'souche', 'fleurs', 'rochers', 'arbres', 'rayon', 'haies', 'fond', 'ombres',
             'prairie', 'herbe']
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
    mouth = ex['profondeur']
    cand = ex['prairie'] | ex['herbe'] | ex['ombres'] | ex['fleurs'] | ex['marches']
    cl, _ = nd.label(close_(cand, 2)); seed = cl[H - 1][cand[H - 1]]   # liserés < 4 px (contours d'arbres/haies) franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    base_idx = ramp_index(cols['rayon'])
    Image.fromarray(np.where(ex['rayon'], base_idx * 11, 0).astype('uint8')).save(OUT / 'masques' / f'{PFX}_rayon_crans.png')
    rayon = beam_frames(base_idx, ex['rayon'])
    lucioles = mote_frames(MOTES)
    anim = {'rayon': rayon, 'lucioles': lucioles}
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for tt, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{tt:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
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
    scenes = [scene(tk) for tk in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    # Planche : rampe du rayon (22 crans) et formes des lucioles, x8.
    sheet = Image.new('RGBA', (22 * 24 + 16, 24 + 16 + 56), (47, 87, 55, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(RAMP):
        d.rectangle([8 + i * 24, 8, 8 + i * 24 + 21, 31], fill=(*c, 255))
    for j, shape in enumerate(['point', 'croix']):
        spr = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                spr[2 + dy, 2 + dx] = (*GLOW, 255)
            spr[2, 2] = (*CORE, 255)
        else:
            spr[2, 2] = (*DOT, 255)
        sheet.alpha_composite(Image.fromarray(spr).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_jardin_secret_calques.ora',
              {f'{i:02d}_{tn}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (tn, fr, _) in enumerate(stack_named)})
    counts = ground_project([(tn.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for tn, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe_claire', 'prairie'), ('herbe', 'ombres'), ('herbe_claire', 'herbe'), ('roche', 'rochers'),
                  ('fond', 'fond')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'entree_jardin_secret_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'jardin secret (souche a marches sous un rayon de lumiere), choisi par l agent (« Lance la suite ! »)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet, temoin sans '
                  'objets edite depuis le decor, sol complet edite depuis le temoin',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Jardin secret (Explorers of Sky, nom de fichier ; scene non confirmee)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': bool(g.get('ecarte'))} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin : hors objets (ecart > 10) dilates de 4 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'sol_complet': round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid['herbe']['rip_rgb']))), 1),
                         'sol_complet_ecartes': {g['file']: round(float(np.linalg.norm(rgb(RAW / g['file']).reshape(-1, 3).mean(0)
                                                                                      - np.array(fid['herbe']['rip_rgb']))), 1)
                                                 for g in GEN if g.get('ecarte')},
                         'rayon_lucioles': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'ombres': 'calque ombres = herbe du rendu assombrie au pied des haies, des arbres et des rochers (separee, pas inventee)',
        'layers': layer_list,
        'rayon': {'rampe': [list(c) for c in RAMP], 'rampe_source': 'rip, zone y < 95, x 130-280, verts du rayon par luminance',
                  'souffle_crans': BREATH, 'bords_attenues_crans': EDGE_STEPS, 'phases': PHASES, 'frame_length_ticks': TICKS,
                  'loi': 'cran = clip(cran0 + round(2 sin(2 pi t / 24)) x min(1, cran0 / 6))',
                  'origine': 'forme du rayon GENEREE ; couleurs EXACTES du rip ; souffle cree par nous'},
        'lucioles': {'lucioles': [list(mo) for mo in MOTES], 'montee_px_par_phase': MOTE_RISE, 'couleurs': [list(DOT), list(GLOW), list(CORE)],
                     'formes': 'point 1 px (phases 0-2, 21-23 et 2 phases sur 4), croix 3 x 3 (2 phases sur 4)',
                     'phases': PHASES, 'frame_length_ticks': TICKS,
                     'origine': 'couleurs EXACTES du rayon du rip ; formes, trajets et cadence crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (prairie, herbe, ombres, fleurs, marches relies au bord sud)',
                   'seuil': 'premiere case 2 x 2 libre sous le trou de la souche'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
