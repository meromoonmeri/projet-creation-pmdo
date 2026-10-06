"""Fin Jardin secret (FJR1) — zone de fin de donjon : prairie d'arène, souche dorée sous le rayon, 4:3 (768 x 576).

.venv/bin/python source/fin_jardin_secret_v1/build.py

Référence `reference/secretgarden.png` (408 x 408) : jardin secret (Explorers of Sky) : prairie jaune-vert, haies de
buissons, arbres ronds, rochers beiges, fleurs blanches, jaunes et roses, grande souche dorée creusée d'un trou carré
avec des marches, rayon de lumière verte qui tombe du ciel sur la souche, fond vert sombre. Même fichier que les
entrées EJS1/EJS2, réutilisé pour la fin (la souche garde ici sa forme classique, sans le temple miniature d'EJS2
qui appartient à l'entrée).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=), comme les lots 4:3
de la série :
- decor.png : allée d'arrivée au sud, vaste prairie d'arène ronde au centre, souche à marches sous le rayon au nord ;
  premier essai, conforme ;
- temoin_sans_objets.png : le décor édité sans arbres, rochers ni fleurs (recalé (0, 0)) ; l'écart décor / témoin
  isole les objets ; jamais exporté ;
- sol_complet.png : herbe moyenne seule ; premier essai, conforme.
Calques : sol complet, prairie, herbe, ombres, fleurs, feuilles (anim), rochers, arbres, souche, marches, profondeur
(trou), haies, fond, rayon (anim), lucioles (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- feuilles : 14 feuilles tombent des arbres et des haies sur la prairie en se balançant, se posent 6 phases puis
  s'effacent ; chaque feuille refait la même chute, donc la boucle est exacte (tons du feuillage du décor) ;
- rayon : le rayon du rendu, recoloré avec la rampe de 22 couleurs EXACTES du rayon du rip ; il « respire »
  (décalage de +-2 crans dans la rampe, atténué vers les bords) ;
- lucioles : étincelles aux couleurs EXACTES du rayon du rip, qui montent de la souche dans le rayon et flottent
  au-dessus des massifs de fleurs.
Scène : 240 ticks = 4 s. Lancer : voir README_PACK.md.
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
REF = HERE / 'reference' / REF_NAME
LOT = 'fin_jardin_secret_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'fin_jardin_secret'
NAMESPACE = 'fin_jardin_secret'
ASSET = 'fjr1_fin_jardin_secret'
PFX = 'FJR1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery '
     'Dungeon secret garden): same light yellow-green meadow grass with small tufts, same rounded bushy hedge borders, '
     'same round leafy trees, same tan-brown boulders, same small white, yellow and pink flowers, same big golden tree '
     'stump with a square dark hole and wooden steps, same vertical bright green light beam falling from the top edge, '
     'same dark green background. Make a NEW, larger top-down dungeon-finale map. WIDE LANDSCAPE 4:3, target 1200 by 896 '
     'pixels, zoomed out so the garden feels vast. Layout: the player arrives at the SOUTH (bottom edge center) on a grass '
     'path between bushy hedges; the path opens into a WIDE round meadow arena in the CENTER with flower patches; a few '
     'boulders and round leafy trees stand at the sides of the arena; at the NORTH (top center) the big golden tree stump '
     'with its square dark hole and wooden steps, the green light beam falling from the top edge onto it, flowers around it, '
     'and the grass leads right up to the steps. Dark green background around the hedges. No falling leaves, no characters, '
     'no text, no UI, no border.',
     'essais': 'premier essai ; conforme (distances au rip dans le manifeste)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'source/{LOT}/bruts/decor.png'],
     'prompt': 'Same image, same framing and exact same pixel-art style. Remove every round leafy tree (with its trunk and '
     'shadow), every boulder and rock, and every small flower: replace them with the same meadow grass around them. Keep the '
     'bushy hedge borders, the big golden tree stump with its dark hole and steps, the green light beam, the light grass path '
     'and the dark green background exactly as they are. No text, no border.',
     'essais': 'premier essai ; témoin de segmentation recalé (0, 0), jamais exporté'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Fill the ENTIRE image edge to edge, WIDE LANDSCAPE 4:3, target 1200 by 896 pixels, with only the plain medium '
     'yellow-green meadow grass texture from the reference image: same yellow-green grass colour, same small grass tufts and '
     'subtle pixel-art speckle, keep the texture detail, nothing else. No hedges, no trees, no rocks, no flowers, no stump, no '
     'light beam, no dark areas, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; herbe moyenne seule, conforme'},
]
# ---- Rayon : rampe relevée sur le rip (zone y < 95, x 130-280, couleurs vertes du rayon, par luminance croissante ;
# les tons beiges des rochers de la même zone sont exclus). Reprise d'EJS1 : même rip, même rampe exacte.
RAMP = [(47, 95, 55), (47, 103, 55), (55, 119, 55), (63, 135, 55), (63, 151, 55), (63, 167, 55), (71, 183, 63),
        (79, 199, 71), (79, 215, 71), (87, 223, 71), (95, 231, 71), (95, 239, 71), (103, 247, 79), (111, 255, 87),
        (127, 255, 95), (151, 255, 111), (175, 255, 127), (191, 255, 135), (207, 255, 151), (231, 255, 199),
        (239, 255, 223), (255, 255, 255)]
BREATH = 2                     # amplitude du souffle, en crans de rampe
EDGE_STEPS = 6                 # les 6 premiers crans (bords sombres) sont atténués : pas d'arête contre le fond
# ---- Lucioles : (x0, y0, décalage de phase, amplitude x) en coordonnées finales. Montée de 1 px par phase,
# oscillation sur 12 phases ; 6 montent de la souche dans le rayon, 4 flottent au-dessus des massifs de fleurs.
MOTES = [(352, 120, 0, 2), (408, 124, 6, 2), (368, 94, 12, 3), (398, 88, 18, 3), (360, 62, 3, 2), (404, 58, 15, 2),
         (180, 260, 4, 3), (580, 254, 10, 3), (170, 340, 16, 3), (590, 334, 22, 3)]
MOTE_RISE = 1
DOT, GLOW, CORE = (207, 255, 151), (231, 255, 199), (255, 255, 255)
# ---- Feuilles : 14 feuilles, chute de 20 phases (2 px par phase), posées 6 phases, boucle exacte de 48 phases.
N_LEAVES = 14
LEAF_FALL = 20
LEAF_REST = 6


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
STATIC = ['prairie', 'herbe', 'ombres', 'fleurs', 'rochers', 'arbres', 'souche', 'marches', 'profondeur', 'haies', 'fond']
ANIMS = ['feuilles', 'rayon', 'lucioles']
DRAW_ORDER = ['sol_complet', 'prairie', 'herbe', 'ombres', 'fleurs', 'feuilles', 'rochers', 'arbres', 'souche',
              'marches', 'profondeur', 'haies', 'fond', 'rayon', 'lucioles']


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


def footprint_free(blocked, y, x):
    gh, gw = blocked.shape
    return 0 <= y <= gh - 2 and 0 <= x <= gw - 2 and not blocked[y:y + 2, x:x + 2].any()


def reachable_2x2(blocked, start, goal):
    gh, gw = blocked.shape
    if not footprint_free(blocked, *start) or not footprint_free(blocked, *goal):
        return False, 0
    seen = np.zeros((gh, gw), bool); queue = [start]; seen[start] = True
    for y, x in queue:
        if (y, x) == goal:
            return True, int(seen.sum())
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < gh and 0 <= nx < gw and not seen[ny, nx] and footprint_free(blocked, ny, nx):
                seen[ny, nx] = True; queue.append((ny, nx))
    return False, int(seen.sum())


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
    """a : décor, t : témoin sans objets. Mêmes règles qu'EJS1 (seuils mesurés sur le brut 1200 x 896) :
    fond = lum lissée 5 px du témoin < 85, vert (g > r + 15), ouvert 3 px, relié au bord ; rayon = pixels du témoin
    très verts (g - r > 70) ou très clairs (lum > 205), y < 175, x 470-730, hors fond, fermés 2 px, reliés au bord haut
    (faisceau mesuré : y 0-130, x 520-681) ; souche = doré (r >= g - 12, r - b > 60) au haut-centre (mesurée :
    y 147-229, x 536-664), fermé 4 px, > 3000 px, trous bouchés ; profondeur = lum < 90 dans la souche (trou
    plus clair qu'EJS1 : lum ~85), ouverte 1 px, plus grande composante ; marches = toute la souche sous le trou, dans
    sa largeur (+- 2 px) ; haies = témoin
    texturé (écart-type 9 px > 6), fermé 3 px, > 3000 px, ouvert 5 px puis redilaté, petits trous (< 800 px) bouchés,
    rien dans la zone dégagée sous la souche ; objets = écart décor / témoin lissé 3 px > 28, fermé 3 px, trous
    bouchés, >= 30 px : fleurs = composantes < 400 px à >= 20 % de pixels de fleur ; rochers = beige (|r-g| < 30,
    r-b > 25) fermé 2 px, trous bouchés, >= 150 px, lum moyenne > 115 ; ombres portées = herbe plate sombre ;
    arbres = le reste des objets (>= 300 px) ; herbe hors objets : prairie = b lissé 5 px < 50 (jaune),
    ombres = lum lissée 5 px < 150, herbe = le reste."""
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
    for i in range(on0):                    # objets du décor posés sur le rayon du témoin : hors rayon
        m = ol0 == i + 1
        if m.sum() >= 30 and beam_a[m].mean() < 0.3:
            rayon &= ~m
    gold = (r >= g - 12) & (r - b > 60) & (yy > 120) & (yy < 280) & (xx > 500) & (xx < 700)
    st = nd.binary_fill_holes(keep_large(close_(gold, 4), 3000)) & ~rayon
    hole = open_((lt < 90) & st, 1); hl, hn = nd.label(hole); hs = nd.sum(hole, hl, range(1, hn + 1))
    assert hn >= 1, "trou de la souche introuvable"
    hole = nd.binary_fill_holes(close_(hl == int(np.argmax(hs)) + 1, 2)) & st
    hy, hx = np.nonzero(hole); sy, sx = np.nonzero(st)
    steps = st & (yy > hy.max()) & (xx >= hx.min() - 2) & (xx <= hx.max() + 2) & ~hole       # escalier entier
    front = (yy > sy.max() - 10) & (yy < sy.max() + 40) & (xx > sx.min() + 20) & (xx < sx.max() - 20) & ~st
    haie = keep_large(close_((sdev(lt, 9) > 6) & ~fond & ~rayon & ~st & ~front, 3), 3000)
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
    v = u % 24
    shape = 'croix' if 3 <= v <= 20 and v % 4 in (0, 1) else 'point'
    return x, y, shape


def mote_frames(motes, ts=range(PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for m in motes:
            x, y, shape = mote_state(m, t)
            if not (1 <= x < W - 1 and 1 <= y < H - 1):
                continue
            if shape == 'croix':
                for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    a[y + dy, x + dx] = (*GLOW, 255)
                a[y, x] = (*CORE, 255)
            else:
                a[y, x] = (*DOT, 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- feuilles qui tombent (tons du feuillage du décor)
def leaf_sprites(pal):
    """Deux poses 6 x 4 (feuille de face, feuille de biais) dans 3 tons du feuillage (clair, moyen, sombre)."""
    c, m, d = pal
    A = [[0, 0, c, c, 0, 0], [0, c, c, m, m, 0], [d, m, m, m, d, 0], [0, 0, d, d, 0, 0]]
    B = [[0, 0, 0, 0, c, 0], [0, 0, c, c, m, 0], [0, c, m, m, d, 0], [d, d, d, 0, 0, 0]]
    out = []
    for P in (A, B):
        e = np.zeros((4, 6, 4), 'uint8')
        for y in range(4):
            for x in range(6):
                if P[y][x]:
                    e[y, x] = (*P[y][x], 255)
        out.append(e)
    return out


def leaf_frames(decor_small, trees_m, grass_vis, rng):
    lum = decor_small @ [.299, .587, .114]
    g = decor_small[..., 1].astype(int); r = decor_small[..., 0].astype(int)
    leafy = decor_small[trees_m & (g > r + 50) & (lum > 60)]                  # feuillage vert des arbres du décor
    order = np.argsort(leafy @ [.299, .587, .114])
    pal = [tuple(int(v) for v in leafy[order[int(len(order) * q)]]) for q in (0.97, 0.7, 0.3)]
    spr = leaf_sprites(pal)
    edge = grass_vis & nd.binary_dilation(trees_m, iterations=12) & ~nd.binary_dilation(~grass_vis, iterations=3)
    edge[H - 100:] = False                                                    # pas sur l'allée d'arrivée au sud
    ys, xs = np.nonzero(edge); leaves = []; taken = np.zeros((H, W), bool)
    fall_h = 2 * LEAF_FALL
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x] or y + fall_h + 5 >= H or not (6 <= x < W - 12):
            continue
        path = grass_vis[y:y + fall_h + 4, max(0, x - 4):x + 10]  # couloir balayé réel (pose 6 px + balancier +-4 px)
        if path.mean() < 0.95:
            continue
        leaves.append({'depart': [x, y], 'phase': int(rng.integers(PHASES)), 'sens': int(rng.choice([-1, 1]))})
        taken[max(0, y - 30):y + 30, max(0, x - 30):x + 30] = True
        if len(leaves) == N_LEAVES:
            break
    assert len(leaves) == N_LEAVES, f'feuilles placées : {len(leaves)}'
    frames = []
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for lf in leaves:
            k = (t - lf['phase']) % PHASES
            if k >= LEAF_FALL + LEAF_REST:
                continue
            kk = min(k, LEAF_FALL - 1)
            x0, y0 = lf['depart']
            x = x0 + int(round(lf['sens'] * 4 * np.sin(2 * np.pi * kk / 10)))      # balancier
            y = y0 + 2 * kk
            sp = spr[0] if k >= LEAF_FALL else spr[(kk // 3) % 2]                  # se retourne en tombant, à plat au sol
            mm = sp[..., 3] > 0; e[y:y + 4, x:x + 6][mm] = sp[mm]
        e[~grass_vis] = 0
        frames.append(e)
    return frames, leaves, [list(c) for c in pal], spr


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Jardin secret (FJR1)')
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


def ground_project(stack, blocked, markers, gfx, tools):
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
    layers.append(gfx.layer(f'{len(layers):02d} Top (vide)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': 'Fin Jardin secret - prairie sous le rayon (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Jardin secret (Explorers of Sky) ; '
                     'feuilles qui tombent (calculees), rayon anime (rampe exacte du rip), lucioles aux couleurs du rip. '
                     "Prairie d'arene, souche a marches au nord. Marqueurs d edition, sans warp.")
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': "Arrivée, arène et objectif (repères d'édition)", 'Visible': True, 'MapChars': [],
                      'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', markers['entrance']), mk('boss', markers['boss']),
                                mk('objectif', markers['objectif'])]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : reperes d edition seulement, aucun warp ni destination.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Jardin secret FJR1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Prairie d'arene sous le rayon, souche a marches au nord, feuilles et lucioles animees. Projet de carte, sans warp.</Description>
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
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
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
    cl, _ = nd.label(close_(cand, 2)); seed = cl[H - 1][cand[H - 1]]   # liserés < 4 px franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    base_idx = ramp_index(cols['rayon'])
    Image.fromarray(np.where(ex['rayon'], base_idx * 11, 0).astype('uint8')).save(OUT / 'masques' / f'{PFX}_rayon_crans.png')
    rayon = beam_frames(base_idx, ex['rayon'])
    lucioles = mote_frames(MOTES)
    grass_vis = ex['prairie'] | ex['herbe'] | ex['ombres'] | ex['fleurs']
    feuilles, leaves, lpal, spr = leaf_frames(down_full(a).astype(int), ex['arbres'] | ex['haies'], grass_vis,
                                              np.random.default_rng(11))
    for i, sp in enumerate(spr):
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_feuille_{i}.png')
    anim = {'feuilles': feuilles, 'rayon': rayon, 'lucioles': lucioles}
    top = np.zeros((H, W, 4), 'uint8')
    stack_named, layer_list = [], []
    for i, nm in enumerate(DRAW_ORDER):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for tt, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{tt:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks,
                               'name': f'{i:02d}_{nm}', 'order': i})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60,
                               'name': f'{i:02d}_{nm}', 'order': i})
        stack_named.append((nm, frames, ticks))
    Image.fromarray(top).save(OUT / 'calques' / f'{PFX}_{len(DRAW_ORDER):02d}_top.png')
    layer_list.append({'file': f'calques/{PFX}_{len(DRAW_ORDER):02d}_top.png', 'phases': 1, 'ticks': 60,
                       'name': f'{len(DRAW_ORDER):02d}_top', 'order': len(DRAW_ORDER)})
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]

    def free_near(x, y):
        for dy in range(0, 40):
            for dx in sorted(range(-16, 17), key=abs):
                for sy in (1, -1):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if footprint_free(blocked, gy, gx):
                        return [gx * 8, gy * 8]
    arena = walk & (np.mgrid[:H, :W][0] < H - 150)
    fy, fx = np.nonzero(arena)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    dys, dxs = np.nonzero(ex['marches'] | mouth)
    objectif = free_near(int(round(dxs.mean())) - 8, int(dys.max()) + 8)
    markers = {'entrance': entry_px, 'boss': boss, 'objectif': objectif}
    paths = {}
    for k in ('boss', 'objectif'):
        ok, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8),
                                    (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 5
    scenes = [scene(tk) for tk in range(0, LOOP_TICKS, step)]
    assert (np.asarray(scenes[0])[..., 3] == 255).all(), 'la scène comporte des pixels transparents'
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('objectif', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    # Planche : rampe du rayon (22 crans), formes des lucioles et poses des feuilles, sur fond vert sombre.
    sheet = Image.new('RGBA', (22 * 24 + 16, 24 + 16 + 56), (47, 87, 55, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(RAMP):
        d.rectangle([8 + i * 24, 8, 8 + i * 24 + 21, 31], fill=(*c, 255))
    for j, shape in enumerate(['point', 'croix']):
        sp = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                sp[2 + dy, 2 + dx] = (*GLOW, 255)
            sp[2, 2] = (*CORE, 255)
        else:
            sp[2, 2] = (*DOT, 255)
        sheet.alpha_composite(Image.fromarray(sp).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    for j, sp in enumerate(spr):
        sheet.alpha_composite(Image.fromarray(sp).resize((sp.shape[1] * 8, sp.shape[0] * 8), Image.Resampling.NEAREST),
                              (8 + 128 + j * 64, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_fin_jardin_secret_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, ref)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': "Fin Jardin secret — prairie d'arène sous le rayon", 'prefix': PFX, 'namespace': NAMESPACE,
        'asset': ASSET, 'type': 'fin de donjon / arène naturelle', 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': 'layout de fin logique : fin jardin avec des feuilles qui tombent etc',
        'agent_choices': {
            'reference': 'même rip secretgarden.png que EJS1/EJS2 ; matière + rampe exacte du rayon + couleurs des lucioles',
            'layout': 'allée d arrivée au sud, vaste prairie d arène ronde au centre, souche dorée à marches sous le rayon au nord',
            'prefix': 'FJR1, car FJS est pris par Fin Jungle Sud (FJS1) et FJS3 est un repère de la branche sœur 01a0eaca (non fusionnée)',
            'souche': 'forme classique sans le temple miniature de Celebi (EJS2), qui appartient à l entrée ; à confirmer',
            'biome': 'jardin secret, continuité avec EJS1/EJS2 ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition FJR1 générée avec le rip en référence'},
                   {'file': f'source/{LOT}/bruts/temoin_sans_objets.png', 'sha256': sha(RAW / 'temoin_sans_objets.png'),
                    'size_px': list(SRC), 'role': 'témoin de segmentation recalé (0, 0), jamais exporté'},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size_px': list(SRC),
                    'role': 'herbe moyenne seule, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/reference/{REF_NAME}', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'rip jardin secret : matière + rampe du rayon + lucioles'}],
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (herbe 64, fleurs 24, rochers 32, végétation 96, souche 48, fond 8), sans tramage ; rayon recoloré rampe exacte, feuilles et lucioles calculées',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'recalage': reg,
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': 'moyenne RGB par matière, même classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35'},
        'layers': layer_list,
        'feuilles': {'phases': PHASES, 'frame_length_ticks': TICKS, 'chute': LEAF_FALL, 'au_sol': LEAF_REST,
                     'nombre': len(leaves), 'couleurs': lpal, 'placements': leaves,
                     'loi': 'k = (t - phase) mod 48 ; chute k < 20 : y = y0 + 2k, x = x0 + sens 4 sin(2 pi k / 10), pose alternee toutes les 3 phases ; posee a plat 6 phases puis effacee ; meme trajet a chaque boucle',
                     'origine': 'calcule ; 2 poses 6x4, 3 tons du feuillage vert des arbres et des haies du decor'},
        'rayon': {'phases': PHASES, 'frame_length_ticks': TICKS, 'rampe_exacte': [list(c) for c in RAMP],
                  'respiration': f'decalage de +-{BREATH} crans, sinusoide de periode {PHASES}, attenue sur les {EDGE_STEPS} premiers crans',
                  'origine': 'recoloration du rayon du rendu avec la rampe exacte du rip'},
        'lucioles': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(MOTES),
                     'couleurs': {'point': list(DOT), 'halo': list(GLOW), 'coeur': list(CORE)},
                     'placements': [{'x0': x, 'y0': y, 'decalage': off, 'amplitude_x': ax} for x, y, off, ax in MOTES],
                     'loi': f'y = y0 - {MOTE_RISE} u, x = x0 + ax sin(2 pi u / 12), u = (t + off) mod {PHASES} ; croix 3x3 ou point 1 px',
                     'origine': 'etincelles calculees aux couleurs exactes du rayon du rip'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors prairie, herbe, ombres, fleurs et marches (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition générée référencée, pas de tuiles natives certifiées ; seules la rampe du rayon et les couleurs des lucioles sont exactes du rip, les feuilles sont calculées.',
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
