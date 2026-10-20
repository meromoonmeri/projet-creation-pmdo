"""Fin Clairière tropicale V1 (FCT1) — fin de donjon de la clairière tropicale — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « continue ! » (27 septembre, après ESC1) : carte suivante de la série, biome choisi par l'agent.
Référence `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (456 x 456) : clairière tropicale, palmiers,
hibiscus, dalles de sable, rive de terre, ponton et mer à vagues. Nom du jeu / de la scène NON confirmé (l'audit
zones_bg_audit_v1 la titre « Clairière tropicale et rive », inspection visuelle). Jamais source d'un lot, sur aucune
des 72 branches ni sur main (seulement listée par l'inventaire zones_bg_audit ; relevé du 27 septembre).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor_magenta.png : décor complet 4:3 (1200 x 896), mer en magenta pur ; édité depuis un premier essai écarté
  (herbe acide, distance 69,8 > 35 ; gardé dans bruts/ecartes/) avec le rip en seconde référence ;
- sol_complet.png : herbe seule, éditée depuis le décor (recalée (0, 0)) ;
- temoin_sans_objets.png : décor sans palmiers, fleurs, touffes ni cailloux (recalé (0, 0)) ; la différence
  décor / témoin donne les objets ;
- papillons_poses.png : planche 2 x 6 sur magenta (papillon orange, papillon jaune, battements d'ailes).
Calques : sol complet, herbe, ombres (l'herbe s'assombrit au pied du tertre ; pas contre la jungle), dalles, touffes
et cailloux, fleurs, jungle, palmiers, tertre, seuil (sol de terre de la bouche), entrée sombre, rive, ponton.
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks :
- mer : vagues du rip (profil de 48 px et crête relevés pixel par pixel, couleurs EXACTES) qui montent de 2 px par
  phase vers la rive ; contre la terre, uniquement une bande sombre du rip (pas de liseré clair, retour EWC1) ;
- papillons : poses générées ; battement 8 phases, vol en huit fermé sur 24 phases.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_clairiere_tropicale_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_clairiere_tropicale_v1'
STAGE = R / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
NAMESPACE = 'fin_clairiere_tropicale'
ASSET = 'fct1_fin_clairiere_tropicale'
PFX = 'FCT1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5                     # les deux animations : 24 x 5 = 120 ticks
LOOP_TICKS = 120
LOT = 'source/fin_clairiere_tropicale_v1'
GEN = [
    {'file': 'decor_magenta.png', 'images': ['large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'], 'prompt':
     "Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon "
     'tropical clearing): same soft muted light yellow-green grass with fine blade texture, same dark green dense '
     'jungle bushes with leafy outlines, same coconut palm trees, same red, yellow, cyan and pink hibiscus flower '
     'clusters, same tan sandy stepping-stone slabs, same small grey pebbles, same brown earth bank cliff edge. Make '
     'a NEW, larger top-down map. WIDE LANDSCAPE 4:3, zoomed out so the area feels vast. Layout of a DUNGEON END '
     'arena: along the SOUTH edge a band of sea; a long wooden plank jetty starts at the bottom edge center and '
     'crosses the sea north to the brown earth bank. From the jetty a trail of tan stepping-stone slabs winds NORTH '
     'into a very large wide open round grass clearing in the CENTER (a boss arena, wide empty floor). At the NORTH '
     '(top center) a sacred mound of tan-brown earth and rock overgrown with jungle bushes and flower clusters, with '
     'a flat sandy slab platform at its foot; the stepping stones lead right up to that platform, dry. Dense jungle '
     'fills the left, right and top edges, completely closing the clearing. IMPORTANT: the whole sea surface is '
     'filled with flat pure magenta #FF00FF, no waves, no foam, no white lines. No characters, no signpost, no text, '
     'no UI, no border.',
     'essais': 'premier essai, conforme : arene centrale vide, plateforme de sable au pied du tertre, aucun trou sombre'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and pixel-art style, but only the plain light yellow-green clearing grass with its '
     'fine blade texture everywhere, covering the whole image, nothing else. Keep the ochre grass strokes and '
     'texture, no acid yellow. No objects, no text, no border.',
     'essais': 'premier essai'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Remove every palm tree, every flower cluster, every '
     'small bush tuft and every small grey pebble: replace them with what is around them (the same dense dark green '
     'jungle bushes, or the same light grass in the clearing). Keep the sacred earth mound at the north, its flat '
     'sandy slab platform, the stepping stones, the earth bank, the wooden jetty and the flat magenta sea exactly '
     'as they are. No text, no border.',
     'essais': 'premier essai'},
    {'file': 'papillons_poses.png', 'images': ['large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'], 'prompt':
     'REUTILISEE sans nouvelle generation : planche de l entree ETC1 (source/entree_clairiere_tropicale_sud_nord_v1/'
     'bruts/papillons_poses.png, meme sha256), fenetres et reduction inchangees. Prompt d origine : Pixel-art sprite '
     'sheet on a flat pure magenta #FF00FF background, same pixel style and bright colors as the reference. 2 rows of '
     '6 small separate sprites, evenly spaced. Row 1: a small orange-red butterfly seen from above flapping its '
     'wings, six poses from wings wide open to wings closed and back. Row 2: a small bright yellow butterfly seen '
     'from above, same six flapping poses. Dark outlines, hard pixel edges, no text.',
     'essais': 'copie de la planche ETC1 (meme biome, memes poses) : aucune generation supplementaire'},
]
USED = [g for g in GEN if not g.get('ecarte')]
# ---- Mer : profil vertical et crête relevés sur le rip (couleurs EXACTES, 9 couleurs d'eau).
WAVE_COL, WAVE_Y0 = 0, 404                 # colonne x = 0 : crête (215,231,247) en y = 404
WAVE_P = 48                                # période verticale du rip (crêtes en 356, 404, 452)
CREST_X = (0, 72)                          # tronçon de crête x = 0..71 : y(0) = y(72) = 404, boucle sans saut
WAVE_STEP = WAVE_P // PHASES               # 2 px vers le nord par phase
BANDE = (15, 95, 199)                      # la plus sombre du rip : seule couleur au contact de la terre
CALME = (63, 143, 215)                     # près de la rive, les couleurs claires deviennent ce bleu du rip
SHORE_BAND, SHORE_CALM = 2, 8              # px
# ---- Papillons : fenêtres (cy, cx, côté multiple de POSE_K) mesurées par composante sur la planche 2 x 6.
POSE_K = 12
POSE_COV = 0.3
_CX = (131, 326, 492, 625, 739, 896)
POSE_WIN = {**{f'orange_{i}': (372, cx, 180) for i, cx in enumerate(_CX)},
            **{f'jaune_{i}': (626, cx, 180) for i, cx in enumerate(_CX)}}
FLAP = [0, 1, 2, 3, 4, 3, 2, 1]            # battement : 8 phases, 3 battements par boucle ; pose 5 (= pose 0) inutilisée
FLIGHTS = [  # (couleur, cx, cy, ax, ay, décalage) : vol en huit x = cx + ax sin(2 pi t / 24), y = cy + ay sin(4 pi t / 24)
    ('orange', 190, 250, 44, 16, 0), ('jaune', 560, 245, 40, 18, 7),
    ('jaune', 240, 380, 36, 14, 13), ('orange', 520, 385, 46, 16, 19)]
assert PHASES % len(FLAP) == 0


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
# Groupes par matière : un groupe partagé herbe + dalles + touffes ramenait les dalles au vert (0 pixel de sable) et
# un groupe fleurs + jungle effaçait les hibiscus (0 pixel saturé) — la coupe médiane suit les matières dominantes.
PALETTE_GROUPS = {'herbe': (['sol_complet', 'herbe', 'ombres'], 96), 'dalles_touffes': (['dalles', 'touffes'], 64),
                  'fleurs': (['fleurs'], 48), 'vegetation': (['jungle', 'palmiers'], 96),
                  'terre_bois': (['tertre', 'seuil', 'rive', 'ponton'], 64)}
STATIC = ['herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers', 'tertre', 'seuil', 'rive', 'ponton']
ANIMS = ['mer', 'papillons']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    """Herbe claire de la clairière (rip (183,214,97)), jungle (verts sombres), dalles de sable."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    return {'herbe': (g > 190) & (r > 150) & (b < 140) & (g > r) & (g - b > 80),
            'jungle': (g > r + 10) & (g > b + 30) & (lum < 150) & (lum > 40),
            'dalles': (r > 200) & (r > g) & (g > b + 30) & (r - b > 60) & (r - b < 120)}


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
    r, g, b = a.transpose(2, 0, 1); sat = a.max(2) - a.min(2)
    return (sat > 120) & (((r > 200) & (g < 120)) | ((r > 200) & (g > 180) & (b < 90)) | ((b > 200) & (r < 120))
                          | ((r > 200) & (b > 150) & (g < 150)))


def classify(a, t):
    """a : décor, t : témoin sans objets. Seuils mesurés sur le brut :
    mer = magenta relié au bord sud (les hibiscus roses passent le test de teinte, mais pas reliés) + filet clair
    rose-blanc peint contre la rive ((233,186,214), 2484 px, b > g - 15, lum > 120, à <= 5 px du magenta) ;
    ponton = colonnes non-eau du bas de l'image, jusqu'à la première rangée d'herbe ; bouche = lum < 45 au haut-centre ;
    objets = écart décor / témoin lissé 3 px > 28, fermé, trous bouchés ; palmiers > 2500 px ; fleurs = >= 12 %
    de pixels de fleur saturés ; le reste = touffes et cailloux ; rive = brun à < 60 px de l'eau (y > 650) ;
    seuil = sol de terre de la bouche entre les montants de l'arche ; tertre = beige-brun au nord (y < 320), rien sous
    la bouche entre les montants ; dalles = beige dans la clairière (30 à 4000 px) ; herbe = lum lissée 9 px > 178 ;
    ombres = herbe assombrie au pied du tertre ; jungle = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    mag = (r - g > 60) & (b - g > 60)
    lab, _ = nd.label(mag); water = np.isin(lab, np.unique(lab[-1][lab[-1] > 0]))
    filet = (b > g - 15) & (lum > 120) & nd.binary_dilation(water, iterations=5) & ~water
    water |= filet
    xs = np.nonzero(~water[-4:].any(0))[0]; x0, x1 = int(xs.min()), int(xs.max())
    grassy = (g > r) & (g - b > 70) & (lum > 150)
    ytop = max(y for y in range(hh) if grassy[y, x0 + 4:x1 - 3].mean() > 0.5) + 1
    ponton = np.zeros_like(water); ponton[ytop:, x0:x1 + 1] = True; ponton &= ~water
    mouth = np.zeros_like(water)          # fin de donjon : aucune bouche ; l'objectif est la plateforme du tertre
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    obj = keep_large(nd.binary_fill_holes(close_(diff > 28, 3)), 60) & ~water & ~mouth & ~ponton
    ol, on = nd.label(obj); fpx = flower_px(a)
    pal, fle, tou = (np.zeros_like(obj) for _ in range(3)); kinds = {'palmiers': 0, 'fleurs': 0, 'touffes': 0}
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if m.sum() > 2500:
            pal[s] |= m; kinds['palmiers'] += 1
        elif fpx[s][m].mean() > 0.12:
            fle[s] |= m; kinds['fleurs'] += 1
        else:
            tou[s] |= m; kinds['touffes'] += 1
    dw = nd.distance_transform_edt(~water)
    bankc = (r > g + 10) & (r - b > 35) & ~water & ~ponton & (dw < 60) & (yy > 650)
    rive = keep_large(close_(bankc, 2), 3000)
    rive = nd.binary_fill_holes(rive | water) & ~water & ~ponton & (dw < 60) & (yy > 650) & ~grassy
    rive = keep_large(open_(rive, 1), 3000)
    # Seuil : sol de terre de la bouche (lum 45-110, y 238-256 sur le brut), entre les montants de l'arche (étendue
    # de la bouche dans son tiers bas), de mi-hauteur de la bouche jusqu'à 14 px sous elle.
    # Plateforme : grande dalle de sable au pied du tertre (beige, y < 340, plus grande composante centrale).
    platc = (r >= g) & (r - b > 55) & (lum > 140) & (yy < 340) & ~obj
    pl, pn = nd.label(close_(platc, 2)); ps = nd.sum(platc, pl, range(1, pn + 1)) if pn else []
    candp = [(i + 1, v) for i, v in enumerate(ps) if v >= 4000]
    pid = max(candp, key=lambda t: t[1])[0] if candp else 0
    seuil = nd.binary_fill_holes(pl == pid) if pid else np.zeros_like(water)
    pys, pxs_ = np.nonzero(seuil); my0, my1 = int(pys.min()), int(pys.max()); ax0, ax1 = int(pxs_.min()), int(pxs_.max())
    front = np.zeros_like(water)
    rockc = (r > g + 5) & (r - b > 45) & (yy < 320) & ~mouth & ~obj & ~front
    tertre = keep_large(close_(rockc, 3), 20000)
    tertre = nd.binary_fill_holes(tertre | mouth) & ~mouth & ~obj & (yy < 320) & ~front & ~seuil
    dal = (r >= g) & (r - b > 55) & (lum > 140) & ~tertre & ~obj & ~rive & ~ponton & ~water & ~seuil & ((yy > 240) | front)
    dal = nd.binary_fill_holes(close_(dal, 2)) & ~seuil & ~mouth; dl, dn = nd.label(dal); ds = nd.sum(dal, dl, range(1, dn + 1))
    dal = np.isin(dl, [i + 1 for i, v in enumerate(ds) if 30 <= v <= 4000])
    her = (nd.uniform_filter(lum, 9) > 178) & ~water & ~ponton & ~mouth & ~tertre & ~rive & ~seuil
    her = keep_large(open_(close_(her, 3), 3), 20000)
    her = nd.binary_fill_holes(her) & ~obj & ~dal & ~water & ~ponton & ~rive & ~tertre & ~mouth & ~seuil
    # Ombres : l'herbe s'assombrit au pied du tertre (lum 165-172 contre 202) : herbe (g > r, g-b > 55), lum lissée
    # 5 px entre 120 et 188, à <= 45 px du tertre / de la bouche / du seuil, peu texturée (écart-type 7 px < 14),
    # composantes qui touchent l'herbe ou le seuil. Contre la jungle, l'herbe ne s'assombrit pas (lum 199 à 0-3 px).
    sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - nd.uniform_filter(lum, 7) ** 2, 0))
    Ls = nd.uniform_filter(lum, 5); db = nd.distance_transform_edt(~(tertre | mouth | seuil))
    free = ~(obj | dal | her | mouth | seuil | water | ponton | rive | tertre)
    omb = (g > r) & (g - b > 55) & (Ls > 120) & (Ls < 188) & (db <= 45) & (sd < 14) & free
    omb = close_(omb, 2) & free
    ol2, _ = nd.label(omb); tch = np.unique(ol2[nd.binary_dilation(her | seuil, iterations=2) & omb])
    omb = np.isin(ol2, tch[tch > 0])
    # Devant la bouche, entre les montants et jusqu'à 40 px sous elle, la transition terre -> herbe (olive, texturée)
    # n'est ni terre ni herbe lisse : elle rejoint les ombres (sol assombri), jamais la jungle.
    omb |= front & (yy < my1 + 40) & free & ~omb
    jungle = ~(water | ponton | mouth | pal | fle | tou | rive | tertre | dal | her | seuil | omb)
    masks = dict(mer=water, plateforme=seuil, ponton=ponton, palmiers=pal, fleurs=fle, touffes=tou, rive=rive,
                 tertre=tertre, seuil=seuil, dalles=dal, ombres=omb, herbe=her, jungle=jungle)
    seg = {'objets': int(on), 'objets_par_type': kinds, 'filet_clair_rendu_a_l_eau_px': int(filet.sum()),
           'ponton_colonnes_px': [x0, x1], 'ponton_haut_y': int(ytop),
           'plateforme_y': [my0, my1], 'plateforme_x': [ax0, ax1], 'ombres_lum': round(float(lum[omb].mean()), 1),
           'herbe_lum': round(float(lum[her].mean()), 1)}
    return masks, seg


# ---------------------------------------------------------------- mer
def wave_model(ref):
    """Profil vertical (48 couleurs, colonne x = 0 à partir de la crête y = 404) et décalage de crête c(x) sur
    x = 0..71, relevés sur le rip."""
    prof = [tuple(int(v) for v in ref[WAVE_Y0 + k, WAVE_COL]) for k in range(WAVE_P)]
    white = (ref == prof[0]).all(-1)
    crest = [int(np.nonzero(white[WAVE_Y0 - 9:WAVE_Y0 + 26, x])[0][0]) + WAVE_Y0 - 9 - WAVE_Y0 for x in range(*CREST_X)]
    return prof, crest


def sea_frames(water, prof, crest, ts=range(PHASES)):
    """Vagues du rip qui montent de 2 px par phase (48 px en 24 phases : boucle fermée). Distance à la terre avec les
    bords de l'image comptés comme de l'eau. d <= 2 : BANDE ; d <= 8 : les couleurs claires deviennent CALME."""
    d = nd.distance_transform_edt(np.pad(water, 1, constant_values=True))[1:-1, 1:-1]
    yy, xx = np.mgrid[:H, :W]; c = np.array(crest)[xx % len(crest)]
    P = np.array(prof, 'uint8'); lums = lum_of(P.astype(float))
    light = lums >= lum_of(np.array([119, 183, 231], float))
    frames = []
    for t in ts:
        k = (yy - c + WAVE_STEP * t) % WAVE_P
        a = np.zeros((H, W, 4), 'uint8'); a[..., :3] = P[k]; a[..., 3] = 255
        a[(d <= SHORE_CALM) & light[k]] = (*CALME, 255)
        a[d <= SHORE_BAND] = (*BANDE, 255)
        a[~water] = 0
        frames.append(a)
    return frames, d


# ---------------------------------------------------------------- poses générées (planche sur magenta)
def sheet_poses(path):
    """Fond = magenta pur ET pixels teintés de magenta (r-g > 60 et b-g > 60), ni gardés ni recolorés."""
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((g < 90) & (r - g > 130) & (b - g > 130)) | ((r - g > 60) & (b - g > 60))
    # Les papillons étroits sont à 115-135 px de leurs voisins : une fenêtre de 180 px attrapait des bouts des
    # voisins. Chaque fenêtre ne garde que la composante (fermée 3 px) qui contient son centre.
    lab, _ = nd.label(nd.binary_closing(~bg, iterations=3))
    own = {}
    for name, (cy, cx, s) in POSE_WIN.items():
        win = lab[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]
        ids, cnt = np.unique(win[win > 0], return_counts=True)
        c = lab[cy, cx] if lab[cy, cx] else ids[cnt.argmax()]
        own[name] = bg | (lab != c)                       # fond propre à la fenêtre
    px = np.concatenate([src[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2][~own[nm][cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]]
                         for nm, (cy, cx, s) in POSE_WIN.items()])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=10, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:30], float).reshape(-1, 3)
    return {name: reduce_pose(src, own[name], cy, cx, s, POSE_K, pal, POSE_COV) for name, (cy, cx, s) in POSE_WIN.items()}, pal

def reduce_pose(src, bg, cy, cx, win, k, pal, cov_min):
    h, w = bg.shape; y0, x0 = int(cy) - win // 2, int(cx) - win // 2; n = win // k
    pad = np.zeros((win, win, 3)); pm = np.zeros((win, win), bool)
    sy0, sx0, sy1, sx1 = max(0, y0), max(0, x0), min(h, y0 + win), min(w, x0 + win)
    pad[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = src[sy0:sy1, sx0:sx1]
    pm[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = ~bg[sy0:sy1, sx0:sx1]
    blk = pm.reshape(n, k, n, k); cov = blk.mean((1, 3))
    col = (pad * pm[..., None]).reshape(n, k, n, k, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
    o = np.zeros((n, n, 4), 'uint8'); o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
    o[..., 3] = 255; o[cov < cov_min] = 0
    return o


def paste(frame, spr, cx, cy):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def flight_pos(fl, t):
    _, cx, cy, ax, ay, off = fl; u = 2 * np.pi * ((t + off) % PHASES) / PHASES
    return cx + ax * np.sin(u), cy + ay * np.sin(2 * u)


def butterfly_frames(poses, flights, ts=range(PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for fl in flights:
            x, y = flight_pos(fl, t)
            paste(a, poses[f'{fl[0]}_{FLAP[(t + fl[5]) % len(FLAP)]}'], x, y)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Clairiere tropicale V1 (FCT1)')
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
    o.update(Name={'DefaultText': 'Fin Clairiere tropicale - arene du tertre sacre (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon : arrivee par le ponton au sud, arene dans la clairiere, objectif sur la '
                     'plateforme au pied du tertre au nord. Rendu genere 4:3 reference sur le rip Clairiere tropicale ; '
                     'mer animee (profil et couleurs exacts du rip, bande sombre contre la rive), papillons generes. '
                     'Collisions de base a verifier. Aucun warp. Biome choisi par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
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
  <Name>Fin Clairiere tropicale 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon, arrivee par un ponton au sud, arene de clairiere tropicale, objectif sur la plateforme du tertre au nord, generee au format 4:3 (ref. rip Clairiere tropicale), mer et papillons animes. Pas une aventure jouable.</Description>
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
    a, f, tm, ref = rgb(RAW / 'decor_magenta.png'), rgb(RAW / 'sol_complet.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == tm.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, tm)
    clair = nd.binary_erosion(m['herbe'], iterations=6)
    reg = {'sol_complet': recalage(a, f, clair),
           'temoin': recalage(a, tm, np.pad(np.ones((700, SRC[0]), bool), ((0, SRC[1] - 700), (0, 0))) & ~m['mer'])}
    order = ['mer', 'ponton', 'palmiers', 'fleurs', 'touffes', 'rive', 'seuil', 'tertre', 'dalles', 'ombres', 'herbe', 'jungle']
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
    water = ex['mer']
    # Praticable : herbe, ombres, dalles, seuil, touffes reliées à la clairière, ponton.
    cand = ex['herbe'] | ex['ombres'] | ex['dalles'] | ex['touffes'] | ex['seuil'] | ex['ponton']
    cl, _ = nd.label(cand); seed = cl[H - 1, np.nonzero(ex['ponton'][H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    prof, crest = wave_model(ref)
    mer, dshore = sea_frames(water, prof, crest)
    poses, pose_pal = sheet_poses(RAW / 'papillons_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    papillons = butterfly_frames(poses, FLIGHTS)
    anim = {'mer': mer, 'papillons': papillons}
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
    # Collisions : case bloquée si > 25 % hors praticable.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    def free2(cx, cy):
        # case 2 x 2 libre la plus proche de (cx, cy), en cases
        cands = [(abs(c - cx) + abs(r - cy), c, r) for r in range(gh_ - 1) for c in range(gw_ - 1)
                 if not blocked[r:r + 2, c:c + 2].any()]
        _, c, r = min(cands); return [c * 8, r * 8]
    wys, wxs = np.nonzero(walk)
    boss_px = free2(int(wxs.mean()) // 8, int(wys.mean()) // 8)
    sys_, sxs = np.nonzero(ex['seuil'])
    # Objectif au pied de la plateforme : la dalle elle-meme est entouree de tertre (cases 2 x 2 libres isolees),
    # on prend donc la case libre reliee a l'arrivee la plus proche de son bord sud.
    free = np.array([[not blocked[r:r + 2, c:c + 2].any() for c in range(gw_ - 1)] for r in range(gh_ - 1)])
    flab, _ = nd.label(free); main = flab[entry_px[1] // 8, entry_px[0] // 8]
    oc = [(abs(c * 8 - int(sxs.mean())) + abs(r * 8 - int(sys_.max())), c, r)
          for r in range(gh_ - 1) for c in range(gw_ - 1) if flab[r, c] == main]
    _, oc_, or_ = min(oc); objectif_px = [oc_ * 8, or_ * 8]
    src = (entry_px[1] // 8, entry_px[0] // 8)
    reach, explored = v1.reachable(blocked, src, (boss_px[1] // 8, boss_px[0] // 8))
    assert reach, 'pas de chemin 16x16 entrance -> boss'
    reach_obj, explored_obj = v1.reachable(blocked, src, (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_obj, 'pas de chemin 16x16 entrance -> objectif'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 80, 80, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    names = list(POSE_WIN); cw = 15 * 6 + 8                                # même échelle x6 pour toutes les poses
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (191, 215, 103, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 6, im.height * 6), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_clairiere_tropicale_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('jungle', 'jungle'), ('dalles', 'dalles')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    ecarte = rgb(RAW / GEN[0]['file'])
    manifest = {
        'lot': 'fin_clairiere_tropicale_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'fin de donjon de la clairiere tropicale (arene au centre, tertre sacre au nord), choisie par l agent ; serie des fins, dans l ordre du mod apres FST1',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet mer en magenta, '
                  'herbe complete et temoin sans objets edites depuis le decor, planche papillons sur magenta',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Clairiere tropicale et rive (titre de l audit zones_bg_audit_v1 ; jeu et scene non confirmes)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': bool(g.get('ecarte'))} for g in GEN],
        'recalage': {**reg, 'zones': 'sol complet : herbe de la clairiere erodee de 6 px ; temoin : y < 700 hors mer'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'brut_ecarte': fidelity(ecarte, ref),
                         'mer': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'ombres': 'calque ombres = herbe du rendu assombrie au pied du tertre (separee, pas inventee) ; contre la jungle '
                  'l herbe ne s assombrit pas (lum 199 a 0-3 px, 202 au-dela) : pas d ombre la',
        'layers': layer_list,
        'mer': {'phases': PHASES, 'frame_length_ticks': TICKS, 'profil': [list(c) for c in prof], 'periode_px': WAVE_P,
                'profil_source': f'rip, colonne x = {WAVE_COL}, rangees {WAVE_Y0}..{WAVE_Y0 + WAVE_P - 1}',
                'crete': crest, 'crete_source': f'rip, premiere rangee (215,231,247) par colonne, x = {CREST_X[0]}..{CREST_X[1] - 1}',
                'pas_px': WAVE_STEP, 'sens': 'vers le nord (la rive)', 'bande_rive': list(BANDE), 'calme': list(CALME),
                'rive_px': {'bande': SHORE_BAND, 'calme': SHORE_CALM},
                'liseré': 'aucun : le filet clair du rip contre la rive (215,231,247 en y = 333-334) n est pas repris ; '
                          'bords de l image comptes comme de l eau',
                'origine': 'profil, crete et couleurs EXACTS du rip ; defilement et traitement de la rive crees par nous'},
        'papillons': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K}', 'couverture_min': POSE_COV,
                      'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores ; '
                              'chaque fenetre ne garde que la composante qui contient son centre (voisins exclus)',
                      'palette': [[int(round(c)) for c in p] for p in pose_pal], 'battement': FLAP,
                      'vols': [list(fl) for fl in FLIGHTS], 'phases': PHASES, 'frame_length_ticks': TICKS,
                      'origine': 'dessin GENERE (10 couleurs tirees de la planche) ; battement, vols et placement crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px, 'path_found_16x16': reach and reach_obj, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe, ombres, dalles, seuil, touffes reliees, ponton)',
                   'objectif': 'case 2 x 2 libre reliee a l arrivee, la plus proche du bord sud de la plateforme (au pied du tertre ; la dalle elle-meme est entouree de tertre en cases 2 x 2)', 'boss': 'case 2 x 2 libre la plus proche du centre de gravite du praticable (centre de l arene)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
