"""Fin Jardin secret V1 (FJS5) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (sanctuaire intérieur du Jardin secret, cul-de-sac de boss et d'objectif, sans sortie)
associée aux entrées EJS1/EJS2 (`entree_jardin_secret_sud_nord_v2`).
Référence `secretgarden.png` (408 x 408) : Jardin secret (prairie claire, herbe moyenne, fleurs, rochers beiges, arbres
ronds, haies de bordure, souche dorée, rayon de lumière verte).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), premier essai, conforme (fond 3,4 ; herbe claire 10,2 ; herbe 14,1 ;
  roche 12,3 ; seuil 35) ;
- temoin_sans_objets.png : témoin généré d'après decor.png pour isoler les arbres, rochers et fleurs par différence ;
- sol_complet.png : herbe moyenne seule (fond plein partagé avec EJS1/EJS2, distance 11,0).
Calques : sol complet, prairie, herbe, ombres, fleurs, rochers, arbres, haies, souche, autel (stèle de pierre fermée
au sommet de la souche), marches, fond.
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks (2 s) :
- embleme : l'emblème de Celebi gravé sur la stèle de pierre, recoloré sur la rampe EXACTE du rayon du rip (il s'éclaire
  de 3 crans puis revient) ;
- rayon : faisceau de lumière verte, recoloré sur la rampe EXACTE du rip (22 crans), souffle de +-2 crans ;
- lucioles : 10 points lumineux qui montent et oscillent, couleurs EXACTES du rayon du rip.
Scène : 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_jardin_secret_v1/build.py
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
OUT = R / 'renders/fin_jardin_secret_v1'
STAGE = R / '.cache/fin_jardin_secret_v1/fin_jardin_secret'
NAMESPACE = 'fin_jardin_secret'
ASSET = 'fjs5_fin_jardin_secret'
PFX = 'FJS5'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_jardin_secret_v1'
ENTRY_LOT = 'source/entree_jardin_secret_sud_nord_v2'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon secret '
     'garden): same bright yellow-green central meadow grass, same medium green outer grass with small tufts, same '
     'rounded bushy hedge borders, same round leafy green trees with brown trunks and dark green cast shadows on the '
     'grass, same tan-brown boulders, same small white, yellow and pink 5-petal flowers, same big golden tree stump with '
     'wooden steps on its front, same vertical bright green-white light beam falling from the top edge, same flat dark '
     'green outer background. Make a NEW, larger top-down dungeon ending sanctuary map (closed cul-de-sac at the heart '
     'of the Secret Garden). WIDE LANDSCAPE 4:3 (1200x896), zoomed out so the garden feels vast. Layout: the player '
     'arrives ONLY at the SOUTH (bottom edge center) on a grass path between bushy hedges; the path opens into a wide '
     'oval bright yellow-green central meadow arena surrounded by medium green grass with several tan-brown boulders, '
     'round leafy trees and many small white, yellow and pink flowers; at the NORTH (top center), the garden is a CLOSED '
     'cul-de-sac crowned by the big golden tree stump with wooden steps on the front, and standing on the flat top of '
     'the golden stump (NO dark square hole, NO dark doorway) is a small closed pale-stone sanctuary pedestal with a '
     'bright green carved Celebi guardian emblem on its front face, bathed in the vertical bright green light beam '
     'falling from the top edge. Dark green background around the outer hedges on the left, right and top edges. No '
     'characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (fond 3.4, herbe_claire 10.2, herbe 14.1, roche 12.3)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Remove every round leafy tree (with its brown trunk and '
     'dark cast shadow), every tan-brown boulder and rock, and every small white, yellow and pink flower: replace them '
     'with the same medium green meadow grass or bright yellow-green central meadow grass around them. Keep the outer '
     'rounded bushy hedge borders, the big golden tree stump with its wooden steps and the pale stone sanctuary pedestal '
     'with its green emblem on top, the vertical green light beam, the bright yellow-green central meadow, the southern '
     'entrance grass path and the dark green outer background exactly as they are. No text, no border.',
     'essais': 'premier essai ; temoin de segmentation cale (0, 0), jamais exporte'},
    {'file': 'sol_complet.png', 'images': ['source/entree_jardin_secret_sud_nord_v1/bruts/temoin_sans_objets.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Replace the bushy hedges, the tree stump, the green light '
     'beam, the light central grass and the dark green background with the same medium green meadow grass that is between '
     'the hedges and the light path, with its small grass tufts, so that the whole image is only that medium meadow '
     'grass, edge to edge. No text, no border.',
     'essais': 'planche partagee avec EJS1/EJS2 (121.7,174.9,52.6), distance 11.0 a l herbe du rip'},
]
AUTEL_BOX = (124, 198, 572, 628)          # y0, y1, x0, x1 de la stèle de pierre au sommet de la souche
EMBLEM_BOX = (155, 188, 585, 615)         # y0, y1, x0, x1 de l'emblème vert sur la stèle
EMBLEM_GLOW = 3                           # l'emblème s'éclaire de 3 crans de rampe au milieu de la boucle
# ---- Rayon : rampe relevée sur le rip (zone y < 95, x 130-280, couleurs vertes du rayon, par luminance croissante).
RAMP = [(47, 95, 55), (47, 103, 55), (55, 119, 55), (63, 135, 55), (63, 151, 55), (63, 167, 55), (71, 183, 63),
        (79, 199, 71), (79, 215, 71), (87, 223, 71), (95, 231, 71), (95, 239, 71), (103, 247, 79), (111, 255, 87),
        (127, 255, 95), (151, 255, 111), (175, 255, 127), (191, 255, 135), (207, 255, 151), (231, 255, 199),
        (239, 255, 223), (255, 255, 255)]
BREATH = 2                     # amplitude du souffle, en crans de rampe
EDGE_STEPS = 6                 # les 6 premiers crans (bords sombres) sont atténués : pas d'arête contre le fond
# ---- Lucioles : (x0, y0, décalage de phase, amplitude x). Montée de 2 px par phase, oscillation sur 12 phases.
MOTES = [(336, 128, 0, 2), (434, 132, 6, 2), (344, 96, 12, 3), (428, 90, 18, 3), (346, 60, 3, 2), (428, 56, 15, 2),
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
                  'souche': (['souche', 'marches'], 48), 'autel': (['autel'], 48),
                  'fond': (['fond'], 8)}
STATIC = ['prairie', 'herbe', 'ombres', 'fleurs', 'rochers', 'arbres', 'haies', 'souche', 'autel', 'marches', 'fond']
ANIMS = ['embleme', 'rayon', 'lucioles']


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
    fond = lum lissée 5 px du témoin < 85, vert (g > r + 15), ouvert 3 px, relié au bord ; autel = stèle de pierre fermée
    posée au sommet de la souche (y 124..198, x 572..628), fermée 2 px, trous bouchés ; embleme = pixels verts (g > r + 12)
    gravés sur la face de la stèle (y 155..188, x 585..615), fermés 1 px ; rayon = pixels du témoin très verts (g - r > 70)
    ou très clairs (lum > 205), y < 165, x 470-730, hors fond et hors stèle, fermés 2 px, reliés au bord haut (les objets
    du décor posés sur le rayon sortent du rayon) ; souche = doré (r >= g - 12, r - b > 45) au haut-centre (y 140..265,
    x 520..680), fermé 4 px, > 2000 px, trous bouchés ; marches = escalier de bois de la souche sous la stèle, dans sa
    largeur (+- 6 px) ; haies = témoin texturé (écart-type 9 px > 6), fermé 3 px, > 3000 px, ouvert 5 px puis redilaté,
    petits trous (< 800 px) bouchés, rien dans la zone dégagée sous la souche ; objets = écart décor / témoin lissé 3 px
    > 28, fermé 3 px, trous bouchés, >= 30 px : fleurs = composantes < 400 px à >= 20 % de pixels de fleur ; rochers =
    beige (|r-g| < 30, r-b > 25) fermé 2 px, trous bouchés, >= 150 px, lum moyenne > 115 ; ombres portées = herbe plate
    sombre (écart-type < 6, lum < 155, g > r + 30) ; arbres = le reste des objets (>= 300 px) ; herbe hors objets :
    prairie = b lissé 5 px < 50 (jaune), ombres = lum lissée 5 px < 150, herbe = le reste."""
    lt, la = lum_of(t), lum_of(a); hh, ww = lt.shape; yy, xx = np.mgrid[:hh, :ww]
    r, g, b = t[..., 0], t[..., 1], t[..., 2]
    ra, ga, ba = a[..., 0], a[..., 1], a[..., 2]
    fond = open_((nd.uniform_filter(lt, 5) < 85) & (g > r + 15), 3)
    lab, _ = nd.label(fond); e = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]]); fond = np.isin(lab, e[e > 0])
    ay0, ay1, ax0, ax1 = AUTEL_BOX
    stone_box = (yy >= ay0) & (yy <= ay1) & (xx >= ax0) & (xx <= ax1)
    autel_raw = nd.binary_fill_holes(close_(stone_box & ((np.abs(ra - ga) < 35) | (ga > ra + 15)) & (la > 55), 2)) & stone_box
    ey0, ey1, ex0, ex1 = EMBLEM_BOX
    emb_box = autel_raw & (yy >= ey0) & (yy <= ey1) & (xx >= ex0) & (xx <= ex1)
    emblem = close_(emb_box & (ga > ra + 12), 1) & emb_box
    autel = autel_raw & ~emblem
    beam = ((g - r > 70) | (lt > 205)) & (yy < 165) & (xx > 470) & (xx < 730) & ~fond & ~autel_raw
    lab, _ = nd.label(close_(beam, 2)); rayon = np.isin(lab, np.unique(lab[0][lab[0] > 0])) & (yy < 165)
    rayon = nd.binary_fill_holes(rayon) & ~fond & ~autel_raw
    beam_a = (ga - ra > 70) | (la > 205)
    d0 = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    ol0, on0 = nd.label(nd.binary_fill_holes(close_(d0 > 28, 3)) & rayon)
    for i in range(on0):
        m = ol0 == i + 1
        if m.sum() >= 30 and beam_a[m].mean() < 0.3:
            rayon &= ~m
    gold = (r >= g - 12) & (r - b > 45) & (yy > 140) & (yy < 265) & (xx > 520) & (xx < 680)
    st = nd.binary_fill_holes(keep_large(close_(gold | autel_raw, 4), 2000)) & ~rayon
    sy, sx = np.nonzero(st); ay, ax = np.nonzero(autel_raw)
    steps = st & (yy > ay.max()) & (xx >= ax.min() + 6) & (xx <= ax.max() - 6) & ~autel_raw
    souche = st & ~autel_raw & ~steps
    outer_hedge = (nd.distance_transform_edt(~fond) <= 130) | ((yy > 640) & (xx > 450) & (xx < 750))
    front = (yy > sy.max() - 10) & (yy < sy.max() + 40) & (xx > sx.min() + 20) & (xx < sx.max() - 20) & ~st
    haie = keep_large(close_((sdev(lt, 9) > 6) & outer_hedge & ~fond & ~rayon & ~st & ~front, 3), 3000)
    haie &= nd.binary_dilation(open_(haie, 5), iterations=5)
    hol = nd.binary_fill_holes(haie) & ~haie; hl, hn = nd.label(hol); hs = nd.sum(hol, hl, range(1, hn + 1))
    haie = (haie | np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 800])) & ~fond & ~rayon & ~st & ~front
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    obj = keep_large(nd.binary_fill_holes(close_(diff > 28, 3)), 30) & ~st & ~rayon & ~fond
    ol, on = nd.label(obj); fpx = flower_px(a); fle = np.zeros_like(obj)
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if m.sum() < 400 and fpx[s][m].mean() >= 0.2:
            fle[s] |= m
    tan = (np.abs(ra - ga) < 30) & (ra - ba > 25) & (la > 80) & (la < 215) & obj & ~fle
    tl, tn = nd.label(nd.binary_fill_holes(close_(tan, 2)) & obj & ~fle); roc = np.zeros_like(obj); nroc = 0
    for i, s in enumerate(nd.find_objects(tl)):
        m = tl[s] == i + 1
        if m.sum() >= 150 and la[s][m].mean() > 115:
            roc[s] |= m; nroc += 1
    flat = (sdev(la, 9) < 6) & (la < 155) & (ga > ra + 30)
    shade = obj & ~fle & ~roc & flat
    arb = keep_large(obj & ~fle & ~roc & ~shade, 300)
    rest = obj & ~fle & ~roc & ~arb & ~shade
    haie = haie & ~fle & ~roc & ~arb
    grass = ~(fond | rayon | st | haie | fle | roc | arb)
    bl, ll = nd.uniform_filter(ba.astype(float), 5), nd.uniform_filter(la, 5)
    prairie = grass & ~shade & (bl < 50)
    omb = grass & ~prairie & ((ll < 150) | shade)
    herbe = grass & ~prairie & ~omb
    masks = dict(autel=autel, embleme=emblem, marches=steps, souche=souche, fleurs=fle, rochers=roc,
                 arbres=arb, haies=haie, fond=fond, rayon=rayon, ombres=omb, prairie=prairie, herbe=herbe)
    seg = {'objets': int(on), 'fleurs': int(nd.label(fle)[1]), 'rochers': nroc, 'arbres': int(nd.label(arb)[1]),
           'miettes_rendues_a_l_herbe_px': int(rest.sum()), 'autel_y': [int(ay.min()), int(ay.max())],
           'autel_x': [int(ax.min()), int(ax.max())], 'souche_y': [int(sy.min()), int(sy.max())],
           'ombres_lum': round(float(la[omb].mean()), 1), 'herbe_lum': round(float(la[herbe].mean()), 1),
           'prairie_b': round(float(ba[prairie].mean()), 1),
           'autel_px': int(autel.sum()), 'embleme_px': int(emblem.sum())}
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


def glow(t):
    """Crans ajoutés à l'emblème à la phase t : 0 à la phase 0, EMBLEM_GLOW à la phase 12. Calculé sur min(t, 24 - t)."""
    u = t % PHASES; u = min(u, PHASES - u)
    return int(round(EMBLEM_GLOW * (1 - np.cos(2 * np.pi * u / PHASES)) / 2))


def emblem_frames(base_idx, mask, ts=range(PHASES)):
    rp = np.array(RAMP, 'uint8'); frames = []
    for t in ts:
        idx = np.clip(base_idx + glow(t), 0, len(RAMP) - 1)
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
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Jardin secret V1 (FJS5)')
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
    o.update(Name={'DefaultText': 'Fin Jardin secret - sanctuaire de boss/objectif (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur le rip Jardin secret (associee a EJS1/EJS2) ; '
                     'stele de pierre de Celebi sur la souche, embleme, rayon et lucioles animes (rampe exacte du rip). Sans sortie.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : fin de donjon (cul-de-sac), aucune sortie, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Jardin secret 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon (sanctuaire interieur du Jardin secret, cul-de-sac de boss et d'objectif) prolongeant les entrees EJS1/EJS2, grande prairie fleurie, souche doree couronnee d'une stele de Celebi sous un rayon de lumiere au nord, embleme, rayon et lucioles animes. Pas une aventure jouable.</Description>
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
    order = ['embleme', 'marches', 'autel', 'souche', 'fleurs', 'rochers', 'arbres', 'rayon', 'haies', 'fond', 'ombres',
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
    cand = ex['prairie'] | ex['herbe'] | ex['ombres'] | ex['fleurs'] | ex['marches']
    cl, _ = nd.label(close_(cand, 2)); seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    base_idx = ramp_index(cols['rayon'])
    Image.fromarray(np.where(ex['rayon'], base_idx * 11, 0).astype('uint8')).save(OUT / 'masques' / f'{PFX}_rayon_crans.png')
    rayon = beam_frames(base_idx, ex['rayon'])
    emb_idx = ramp_index(cols['embleme'])
    Image.fromarray(np.where(ex['embleme'], emb_idx * 11, 0).astype('uint8')).save(OUT / 'masques' / f'{PFX}_embleme_crans.png')
    embleme = emblem_frames(emb_idx, ex['embleme'])
    lucioles = mote_frames(MOTES)
    anim = {'embleme': embleme, 'rayon': rayon, 'lucioles': lucioles}
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
    blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    # Boss au centre de la grande prairie ; objectif au nord sur/devant les marches de la souche-autel.
    free2x2 = [(r, c) for r in range(4, gh_ - 4) for c in range(4, gw_ - 4)
               if not blocked[r:r + 2, c:c + 2].any() and walk[r*8:r*8+16, c*8:c*8+16].all()]
    br, bc = min(free2x2, key=lambda rc: (rc[0] - 38) ** 2 + (rc[1] - gw_ // 2) ** 2)
    boss_px = [bc * 8, br * 8]
    ays, axs = np.nonzero(ex['autel'])
    tx = int(round(axs.mean())) // 8 * 8 - 8
    objectif_px = [tx, int(ays.max()) // 8 * 8]
    while blocked[objectif_px[1] // 8:objectif_px[1] // 8 + 2, objectif_px[0] // 8:objectif_px[0] // 8 + 2].any():
        objectif_px[1] += 8
    reach_eb, exp_eb = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_bo, exp_bo = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_eb and reach_bo, 'pas de chemin 16x16'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)),
                        (boss_px, (255, 60, 220, 255)),
                        (objectif_px, (60, 220, 255, 255))):
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
    write_ora(OUT / f'{PFX}_fin_jardin_secret_calques.ora',
              {f'{i:02d}_{tn}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (tn, fr, _) in enumerate(stack_named)})
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    counts = ground_project([(tn.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for tn, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)
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
        'lot': 'fin_jardin_secret_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'type_carte': 'fin_donjon_cul_de_sac_boss_objectif_sans_sortie',
        'entree_associee': {'lot': ENTRY_LOT, 'prefix': 'EJS2', 'reference_da': REF_NAME},
        'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'fin du Jardin secret : grande prairie fleurie et souche doree couronnee d une stele de Celebi sous un rayon de lumiere au nord (associee a EJS1/EJS2)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet et temoin '
                  'generes avec le rip en reference ; sol complet partage avec EJS1/EJS2',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Jardin secret (Explorers of Sky, nom de fichier ; scene non confirmee)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin : hors objets (ecart > 10), dilates de 4 px'},
        'autel_celebi': {'boite_pleine_resolution': list(AUTEL_BOX), 'embleme_boite': list(EMBLEM_BOX),
                         'embleme': {'loi': 'cran = clip(cran0 + round(3 (1 - cos(2 pi u / 24)) / 2)), u = min(t, 24 - t)',
                                     'crans_max': EMBLEM_GLOW, 'couleurs': 'rampe EXACTE du rayon du rip',
                                     'phases': PHASES, 'frame_length_ticks': TICKS}},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'sol_complet': round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid['herbe']['rip_rgb']))), 1),
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
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'sortie': 'aucune (cul-de-sac de fin de donjon)',
                   'path_found_16x16': bool(reach_eb and reach_bo),
                   'path_entry_to_boss_16x16': reach_eb, 'path_boss_to_objectif_16x16': reach_bo,
                   'cells_explored': max(exp_eb, exp_bo),
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (prairie, herbe, ombres, fleurs et marches relies au bord sud) ; bords nord, ouest et est fermes'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
