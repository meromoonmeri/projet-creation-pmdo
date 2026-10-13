"""Entrée Tour Temporelle sud -> nord V2 (ETT2) — Noir & Or Prismatique, nuages rouge/noir et brèches de réalité (768 x 576 px).

.venv/bin/python source/entree_tour_temporelle_sud_nord_v2/build.py

Demande utilisateur :
« fait une autre version 2 j'aimerais que la tour soit prismatique dans un code couleur noir or (les veine sont or pas
rouge) et le cristal et legerement arc en ciel en reflet / la roche et dans des nuance de noir et au fond les nuage doit
être rouge / noir avec des des breche de réalité dans le vide qui s'ouvre et se ferme a diverse endroit (jamais sur le
chemin seulement sur les rocher et les nuage »

- V1 (entree_tour_temporelle_sud_nord_v1, ETT1) conservée intacte.
- Préfixe ETT2 libre sur main et sur toutes les branches sœurs.
- Bruts générés (1200 x 896) dans bruts/ :
  1. decor_magenta.png : tour gothique noire à ogives dorées/prismatiques, circuits de la muraille et veines des rochers
     en OR (zéro veine rouge), roches et chaussée en nuances de noir (basalte/obsidienne), dalles d'ardoise noire,
     portail de cristal clair irisé, mer de nuages en magenta pur (#FF00FF) ;
  2. sol_complet.png : dallage d'ardoise noire complet sous toute la plateforme ;
  3. nuages_magenta.png : 4 bandes horizontales de nuages rouge cramoisi et noir d'encre sur magenta pur (#FF00FF).
- Animations en boucle fermée (scène PPCM = 240 ticks = 4 s) :
  - 01_nuages (48 x 5 ticks = 240 ticks) : nuages rouge/noir périodiques (P = 384 px) dérivant de 8 px par phase ;
  - 08_reflets_arc_en_ciel (24 x 10 ticks = 240 ticks) : deux bandes spectrales pastel (12 teintes NDS mélangées à 38 %
    avec le cristal et 30 % avec les arêtes dorées des ogives de la tour) qui glissent sur le cristal et les ogives ;
  - 10_rochers_flottants (24 x 10 ticks = 240 ticks) : 5 îlots de roche noire en lévitation sinusoïdale ;
  - 11_circuits_or (16 x 5 ticks = 80 ticks, 3 cycles par boucle) : 3 rampes d'or (bronze -> ambre -> or solaire -> or
    blanc, 8 paliers NDS aller-retour = 16 crans) sur les circuits de la tour et les veines des rochers ;
  - 12_breches_realite (24 x 10 ticks = 240 ticks) : 10 brèches dimensionnelles (5 dans les nuages, 5 sur les massifs
    de roche noire, décalées en phase) qui s'ouvrent progressivement (fente -> losange déchiré à cœur de vide étoilé et
    lèvres dorées/prismatiques) puis se referment jusqu'à disparaître, JAMAIS sur le chemin praticable ;
  - 13_eclats_or_prisme (24 x 10 ticks = 240 ticks) : 16 éclats d'or et de prisme montant du portail et des veines.
"""
from pathlib import Path
import colorsys, hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'entree_tour_temporelle_sud_nord_v2'
OUT = R / 'renders' / LOT
NAMESPACE = 'entree_tour_temporelle_sud_nord_v2'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'ett2_entree_tour_temporelle_noire_or'
PFX = 'ETT2'
W, H = 768, 576
SRC = (1200, 896)
SCALE = H / SRC[1]
SCALED_W = round(SRC[0] * SCALE)
CROP_X = (SCALED_W - W) // 2
FIDELITY_MAX = 35

REF_D29 = HERE / 'reference/D29P11A.png'
REF_D30 = HERE / 'reference/D30P34A.png'
STYLE_IMAGES = [
    'source/entree_tour_temporelle_sud_nord_v1/bruts/decor_magenta.png',
    'source/entree_tour_temporelle_sud_nord_v1/reference/D29P11A.png',
]
STYLE_NUAGES = ['source/entree_tour_temporelle_sud_nord_v1/bruts/nuages_magenta.png']
STYLE_SOL = ['source/entree_tour_temporelle_sud_nord_v1/bruts/sol_complet.png']

# Ciel d'abîme noir-écarlate (assise sombre des nuages rouge/noir)
SKY_TONE = (28, 8, 13)

# Loi d'animation des circuits et veines d'OR (8 paliers NDS 5 bits aller-retour = 16 crans, 3 rampes de luminance) :
# structure temporelle identique à d29p11a.bpl (16 crans), transposée dans la gamme Or / Ambre / Or blanc demandée.
_GOLD_ALLER = {
    'sombre': [
        (119, 79, 15), (135, 95, 15), (151, 103, 23), (167, 119, 23),
        (175, 127, 31), (183, 135, 31), (191, 143, 39), (207, 159, 47),
    ],
    'moyen': [
        (167, 119, 23), (183, 135, 31), (199, 151, 39), (207, 159, 47),
        (215, 175, 55), (223, 183, 63), (231, 199, 71), (239, 215, 87),
    ],
    'vif': [
        (215, 167, 39), (223, 175, 47), (231, 191, 63), (239, 207, 79),
        (247, 215, 95), (247, 223, 111), (255, 239, 135), (255, 247, 159),
    ],
}
GOLD_RAMPS = {k: v + v[::-1] for k, v in _GOLD_ALLER.items()}
GOLD_CIRCUIT_TONES = sorted({c for r in GOLD_RAMPS.values() for c in r})

# Spectre pastel 5 bits NDS (12 teintes) pour le reflet légèrement arc-en-ciel du cristal et des ogives
def nds5(v):
    return int(min(255, max(7, 8 * round((v - 7) / 8) + 7)))

N_HUES = 12
RAINBOW_PASTEL = np.array([
    [nds5(255 * c) for c in colorsys.hsv_to_rgb(h / N_HUES, 0.46, 0.98)]
    for h in range(N_HUES)
], dtype='uint8')
PRISM_ARCH_TONES = np.array([
    [nds5(255 * c) for c in colorsys.hsv_to_rgb(h / N_HUES, 0.52, 0.72)]
    for h in range(N_HUES)
], dtype='uint8')

# Cibles de contrôle de fidélité de la palette Noir / Or / Nuages Rouge-Noir
TARGET_PALETTE_V2 = {
    'dalles_ardoise': [52.0, 56.0, 70.0],
    'muraille_noire': [28.0, 29.0, 38.0],
    'roche_noire': [32.0, 31.0, 36.0],
    'circuits_or': [165.0, 122.0, 50.0],
    'nuages_rouge_noir': [108.0, 18.0, 26.0],
    'sol_complet': [54.0, 60.0, 68.0],
}

CLOUD_PHASES, CLOUD_TICKS, CLOUD_STEP = 48, 5, 8
CLOUD_SCALE, CLOUD_SEAM = 0.37, 60
CLOUD_P = CLOUD_PHASES * CLOUD_STEP
CLOUD_ROWS = [(228, 0, 0), (288, 1, 96), (348, 2, 192), (408, 3, 288), (468, 0, 144), (520, 1, 240)]

REF_PHASES, REF_TICKS, REF_BW = 24, 10, 52
ROCK_PHASES, ROCK_TICKS = 24, 10
CIRCUIT_PHASES, CIRCUIT_TICKS = 16, 5
RIFT_PHASES, RIFT_TICKS = 24, 10
MOTE_PHASES, MOTE_TICKS, N_MOTES = 24, 10, 16
LOOP_TICKS = 240

# 10 brèches de réalité : 5 dans les nuages rouge/noir, 5 sur les massifs de roche noire (jamais sur le chemin !)
# (x, y, demi_longueur_px, demi_largeur_px, angle_deg, phase_offset, zone_cible)
RIFT_SPECS = [
    # 5 brèches dans les nuages (allowed_sky)
    (74, 384, 30, 8, -26, 0, 'nuages'),
    (118, 514, 32, 8, 22, 5, 'nuages'),
    (248, 526, 26, 7, -18, 10, 'nuages'),
    (690, 388, 28, 8, 24, 14, 'nuages'),
    (642, 512, 32, 8, -24, 19, 'nuages'),
    # 5 brèches sur les massifs de rochers noirs (parois_rocheuses + veines d'or des rochers)
    (116, 255, 28, 7, 30, 2, 'rochers'),
    (215, 424, 26, 7, -28, 7, 'rochers'),
    (655, 255, 28, 7, -30, 12, 'rochers'),
    (554, 424, 26, 7, 26, 17, 'rochers'),
    (244, 232, 24, 7, 20, 21, 'rochers'),
]
RIFT_VOID_TONES = [(10, 3, 16), (22, 5, 34), (44, 7, 62), (79, 0, 95)]
RIFT_RIM_INNER = [(255, 231, 111), (135, 231, 255), (239, 95, 167)]
RIFT_RIM_OUTER = [(215, 143, 31), (167, 23, 63), (111, 31, 135)]
RIFT_STAR_TONES = [(255, 247, 215), (183, 239, 255)]

STATIC = [
    'chaussee_noire',
    'parvis_dalles',
    'parois_rocheuses',
    'muraille_gothique',
    'portail_cristal',
    'profondeur',
]
ANIMS = {
    'nuages': (CLOUD_PHASES, CLOUD_TICKS),
    'reflets_arc_en_ciel': (REF_PHASES, REF_TICKS),
    'rochers_flottants': (ROCK_PHASES, ROCK_TICKS),
    'circuits_or': (CIRCUIT_PHASES, CIRCUIT_TICKS),
    'breches_realite': (RIFT_PHASES, RIFT_TICKS),
    'eclats_or_prisme': (MOTE_PHASES, MOTE_TICKS),
}
PALETTE_GROUPS = {
    'dalles': (['sol_complet', 'parvis_dalles'], 48),
    'roche_noire': (['chaussee_noire', 'parois_rocheuses'], 64),
    'muraille': (['muraille_gothique'], 48),
    'portail': (['portail_cristal'], 32),
    'sombre': (['profondeur'], 8),
}

GEN = [
    {
        'file': 'decor_magenta.png',
        'images': STYLE_IMAGES,
        'prompt': (
            'Keep the EXACT same top-down 4:3 map layout, geometry and pixel-art style as the first reference image, '
            'but change the color palette to a DARK PRISMATIC BLACK-AND-GOLD theme: 1) Tall gothic wall in deep '
            'obsidian black and dark charcoal-indigo with golden-prismatic arch rims. 2) ALL circuit lines on the '
            'wall and ALL branching energy veins inside the rocks in glowing MOLTEN GOLD (#F7C737, #FFE777, #B7871F), '
            'no red veins. 3) All rocky ledges, boulders, floating rocks and south causeway in shades of black basalt '
            'and obsidian. 4) Central paved platform and stairs in dark slate-obsidian slabs. 5) Spiky crystal portal '
            'arch in translucent prismatic white-cyan crystal with pastel rainbow iridescent facets. Pure #FF00FF '
            'magenta sky.'
        ),
        'essais': 'premier essai 1200x896 ; conforme (toutes distances < 35)',
    },
    {
        'file': 'sol_complet.png',
        'images': STYLE_SOL,
        'prompt': (
            'Keep the EXACT same top-down pixel-art rectangular stone brick floor pattern as the reference image, '
            'filling the entire image edge to edge, but recolored to dark slate-obsidian stone slabs (#3A3E4A, '
            '#4A505E, #2C303A mortar lines). Wide landscape 4:3 format.'
        ),
        'essais': 'premier essai 1200x896 ; conforme',
    },
    {
        'file': 'nuages_magenta.png',
        'images': STYLE_NUAGES,
        'prompt': (
            'Keep the EXACT same 4 horizontal bands of billowy scalloped pixel-art clouds on a flat pure solid '
            'magenta (#FF00FF) background, but recolor the clouds to a dramatic DARK CRIMSON RED AND INK BLACK storm '
            'cloud palette (#D72737, #7F1724, #280B12, #18080D). Wide landscape 4:3 format.'
        ),
        'essais': 'premier essai 1200x896 ; 4 bandes rouge/noir distinctes',
    },
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


JM = loadmod('ejn1_utils', R / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
BM.W, BM.H = W, H
cell_grid = BM.cell_grid
down_class, down_full, rgba = JM.down_class, JM.down_full, JM.rgba


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_big(m, n_min):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n_min])


def quantize_group(layers, n):
    opaque = np.concatenate([l[l[..., 3] == 255][:, :3] for l in layers.values()])
    q = Image.fromarray(opaque.reshape(-1, 1, 3)).quantize(colors=n, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:n * 3], 'uint8').reshape(-1, 3)
    out = {}
    for k, l in layers.items():
        a = l.copy()
        m = a[..., 3] == 255
        if m.any():
            a[..., :3] = pal[np.array(Image.fromarray(a[..., :3]).quantize(palette=q, dither=Image.Dither.NONE))]
        a[~m] = 0
        out[k] = a
    return out


# ---------------------------------------------------------------- segmentation pleine résolution (1200 x 896)
def classify(a):
    """Seuils mesurés sur bruts/decor_magenta.png (1200 x 896, thème Noir & Or Prismatique) :
    - void : magenta pur (R > 200, B > 200, G < 80) + liseré rosé relié aux bords, dilaté de 1 px ;
    - rochers_flottants : 5 îlots de roche noire séparés de la plateforme principale (>= 80 px) ;
    - profondeur : bouche sombre au nord-centre (lum < 22, y 180..330, x 545..655), dilatée de 2 px dans lum < 34 ;
    - circuits_or : tracés de circuits sur la muraille noire et veines d'or dans la roche noire (R > B + 55,
      G > B + 20, R > 105, composantes >= 6 px) — aucun pixel rouge ;
    - portail_cristal : arche à pointes de cristal clair/irisé autour de la bouche (lum > 105, B > 125 ou R > 135) ;
    - parvis_dalles : esplanade centrale, escaliers et terrasse haute en dalles d'ardoise sombre (lum > 41, B >= R + 4) ;
    - chaussee_noire : chaussée praticable de basalte noir au sud (y >= 665, x 485..715, lum > 46) ;
    - parois_rocheuses : flancs et corniches de roche d'obsidienne noire (y >= 245, B - R <= 7, fermé 3 px, >= 2000 px) ;
    - muraille_gothique : haute muraille gothique noire à colonnes et ogives dorées/prismatiques au nord.
    """
    Hs, Ws = a.shape[:2]
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)
    yy, xx = np.mgrid[:Hs, :Ws]

    mag_strict = (r > 200) & (b > 200) & (g < 80)
    pink = (r - g > 45) & (b - g > 35)
    mag = mag_strict | (pink & morph(nd.binary_dilation, mag_strict, 3))
    lab_m, _ = nd.label(mag)
    edge_m = set(np.unique(np.r_[lab_m[0], lab_m[-1], lab_m[:, 0], lab_m[:, -1]])) - {0}
    void = morph(nd.binary_dilation, np.isin(lab_m, sorted(edge_m)), 1)
    lab_nl, n_nl = nd.label(~void)
    sz_nl = nd.sum(~void, lab_nl, range(1, n_nl + 1))
    plat = lab_nl == (int(np.argmax(sz_nl)) + 1)
    rocks = keep_big(nd.binary_fill_holes(~void & ~plat) & ~plat, 80)
    void = ~plat & ~rocks

    dark = (lum < 22) & (yy > 180) & (yy < 330) & (xx > 545) & (xx < 655)
    lab_d, n_d = nd.label(dark)
    sz_d = nd.sum(dark, lab_d, range(1, n_d + 1))
    mouth = lab_d == (int(np.argmax(sz_d)) + 1)
    mouth = nd.binary_fill_holes(
        morph(nd.binary_dilation, mouth, 2) & (lum < 34) & (yy > 175) & (yy < 325) & (xx > 545) & (xx < 655)
    ) & plat

    circuits_or = plat & ~mouth & (r > b + 55) & (g > b + 20) & (r > 105)
    circuits_or = keep_big(circuits_or, 6)

    arch_zone = (
        plat & ~mouth & ~circuits_or
        & (((yy >= 80) & (yy <= 290) & (xx >= 500) & (xx <= 700)) | ((yy > 290) & (yy <= 360) & (xx >= 548) & (xx <= 652)))
    )
    portal = arch_zone & (lum > 105) & ((b > 125) | (r > 135))
    portal = keep_big(nd.binary_fill_holes(morph(nd.binary_closing, portal, 2)) & arch_zone, 150)

    in_paved_box = (
        ((yy >= 305) & (yy < 400) & (xx >= 515) & (xx <= 685))
        | ((yy >= 335) & (yy < 440) & (xx >= 445) & (xx <= 755))
        | ((yy >= 400) & (yy <= 695) & (xx >= 320) & (xx <= 880))
    )
    paved_seed = plat & ~mouth & ~circuits_or & ~portal & in_paved_box & (lum > 41) & (b >= r + 4)
    paved = keep_big(nd.binary_fill_holes(morph(nd.binary_closing, paved_seed, 4)), 15000) & plat & ~mouth & ~circuits_or & ~portal & in_paved_box

    causeway_zone = plat & ~mouth & ~paved & (yy >= 665) & (xx >= 485) & (xx <= 715)
    causeway_seed = causeway_zone & (lum > 46)
    causeway = keep_big(nd.binary_fill_holes(morph(nd.binary_closing, causeway_seed, 4)), 10000) & causeway_zone & ~circuits_or

    rem = plat & ~(mouth | circuits_or | portal | paved | causeway)
    rock_walls = rem & (yy >= 245) & (b - r <= 7)
    rock_walls = keep_big(nd.binary_fill_holes(morph(nd.binary_closing, rock_walls, 3)) & rem, 2000)
    gothic_wall = rem & ~rock_walls

    masks = {
        'void': void,
        'rochers_flottants': rocks,
        'profondeur': mouth,
        'circuits_or': circuits_or,
        'portail_cristal': portal,
        'parvis_dalles': paved,
        'chaussee_noire': causeway,
        'parois_rocheuses': rock_walls,
        'muraille_gothique': gothic_wall,
    }
    ys_, xs_ = np.nonzero(mouth)
    seg = {
        'bouche_y': [int(ys_.min()), int(ys_.max())],
        'bouche_x': [int(xs_.min()), int(xs_.max())],
        'rochers_flottants_nb': int(nd.label(rocks)[1]),
        'circuits_or_px_pleine_res': int(circuits_or.sum()),
    }
    return masks, seg


# ---------------------------------------------------------------- animations
def cloud_bands():
    """4 bandes du brut de nuages rouge/noir réduites (x 0,37) et rendues périodiques (P = 384 px, fondu 60 px)."""
    a = rgb(RAW / 'nuages_magenta.png')
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    mg = (r > 200) & (b > 200) & (g < 80)
    pink = (r - g > 45) & (b - g > 35)
    m = ~morph(nd.binary_dilation, mg | (pink & morph(nd.binary_dilation, mg, 3)), 1)
    rows = m.mean(1) > 0.05
    lab, n = nd.label(rows)
    spans = [(int(np.nonzero(lab == i)[0][0]), int(np.nonzero(lab == i)[0][-1]) + 1) for i in range(1, n + 1)]
    spans = [s for s in spans if s[1] - s[0] > 60]
    bands = []
    for y0, y1 in spans:
        c = a[y0:y1].astype(np.float32)
        al = m[y0:y1].astype(np.float32)
        h, w = al.shape
        nh, nw = int(round(h * CLOUD_SCALE)), int(round(w * CLOUD_SCALE))
        rs = lambda p: np.array(Image.fromarray(p, 'F').resize((nw, nh), Image.Resampling.BOX))
        A = rs(al)
        C = np.stack([rs(c[..., k] * al) for k in range(3)], -1) / np.maximum(A, 1e-6)[..., None]
        P = nw - CLOUD_SEAM
        assert P == CLOUD_P, (P, nw)
        wgt = (np.arange(CLOUD_SEAM) / CLOUD_SEAM)[None, :]
        a1, a2 = A[:, :CLOUD_SEAM], A[:, P:P + CLOUD_SEAM]
        am = wgt * a1 + (1 - wgt) * a2
        cm = (
            wgt[..., None] * a1[..., None] * C[:, :CLOUD_SEAM]
            + ((1 - wgt) * a2)[..., None] * C[:, P:P + CLOUD_SEAM]
        ) / np.maximum(am, 1e-6)[..., None]
        A2 = A[:, :P].copy()
        C2 = C[:, :P].copy()
        A2[:, :CLOUD_SEAM] = am
        C2[:, :CLOUD_SEAM] = cm
        # Prolonge l'assise noir-rouge sombre vers le bas sans rayure verticale afin que les crêtes cramoisies
        # de la bande suivante recouvrent l'assise sans coupure.
        pad_h = 28
        base_col = np.array(SKY_TONE, dtype=np.float32)[None, None, :]
        pad_c = np.repeat(base_col, pad_h, axis=0)
        pad_c = np.repeat(pad_c, P, axis=1)
        C2 = np.concatenate([C2, pad_c], axis=0)
        A2 = np.concatenate([A2, np.ones((pad_h, P), dtype=np.float32)], axis=0)
        bands.append((C2, A2 > 0.5))
    allpx = np.concatenate([c[m_] for c, m_ in bands]).clip(0, 255).astype('uint8')
    q = Image.fromarray(allpx[None]).quantize(colors=16, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:48]).reshape(16, 3)
    out = []
    for c, m_ in bands:
        d = ((c[..., None, :] - pal[None, None]) ** 2).sum(-1)
        idx = d.argmin(-1)
        out.append((pal[idx].astype('uint8'), m_))
    return out, spans, pal


def cloud_frames(allowed):
    bands, spans, pal = cloud_bands()
    frames = []
    for t in range(CLOUD_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for top, bi, dx in CLOUD_ROWS:
            c, m_ = bands[bi % len(bands)]
            h = c.shape[0]
            xs = (np.arange(W) + dx + CLOUD_STEP * t) % CLOUD_P
            for y in range(h):
                Y = top + y
                if not 0 <= Y < H:
                    continue
                ok = m_[y, xs] & allowed[Y]
                e[Y, ok, :3] = c[y, xs[ok]]
                e[Y, ok, 3] = 255
        frames.append(e)
    return frames, spans, pal, [b[0].shape[0] for b in bands]


def rainbow_reflection_frames(portal_layer, ex_portal, cols_wall, ex_wall):
    """Reflet légèrement arc-en-ciel sur les facettes du cristal et reflet prismatique sur les ogives dorées de la tour."""
    lum_p = lum_of(portal_layer)
    q50 = float(np.quantile(lum_p[ex_portal], 0.50))
    hi_portal = ex_portal & (lum_p >= q50)

    # Uniquement les arêtes dorées/bronze des ogives gothiques de la tour noire (R > B + 4 et lum > 42, y < 190),
    # jamais les colonnes verticales gris-indigo.
    yy, xx = np.mgrid[:H, :W]
    rw, gw, bw = cols_wall[..., 0].astype(int), cols_wall[..., 1].astype(int), cols_wall[..., 2].astype(int)
    lum_w = lum_of(cols_wall)
    hi_arch = ex_wall & (yy < 190) & (rw > bw + 3) & (gw >= bw) & (lum_w > 42)

    # Pré-calcul d'une table de 12 tons pastel mélangés à 30 % avec la teinte claire du cristal (reflet léger et subtil)
    base_p = portal_layer[hi_portal][:, :3].mean(0)
    crystal_rainbow_tones = np.array([
        [nds5(0.70 * base_p[k] + 0.30 * RAINBOW_PASTEL[h, k]) for k in range(3)]
        for h in range(N_HUES)
    ], dtype='uint8')
    s = xx + 0.65 * yy
    # Sur le portail de cristal : onde spectrale continue de longueur d'onde 96 px (toujours présente à chaque phase)
    w_portal = 96.0
    span = float(s.max()) + 2 * REF_BW
    D = span / 3.0

    frames = []
    for t in range(REF_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        phase_u = (s / w_portal - t / REF_PHASES) % 1.0
        shimmer_p = hi_portal & (np.sin(2 * np.pi * phase_u) > -0.35)
        h_p = np.clip((phase_u * N_HUES).astype(int), 0, N_HUES - 1)
        e[shimmer_p, :3] = crystal_rainbow_tones[h_p[shimmer_p]]
        e[shimmer_p, 3] = 255

        for j in range(3):
            p = -REF_BW + (t / REF_PHASES) * D + j * D
            band_w = hi_arch & (np.abs(s - p) < REF_BW)
            h_w = np.clip(((s - p + REF_BW) / (2 * REF_BW) * N_HUES).astype(int), 0, N_HUES - 1)
            e[band_w, :3] = PRISM_ARCH_TONES[h_w[band_w]]
            e[band_w, 3] = 255
        frames.append(e)
    info = {
        'portal_facet_px': int(hi_portal.sum()),
        'tower_arch_prism_px': int(hi_arch.sum()),
        'tones_cristal_arc_en_ciel': crystal_rainbow_tones.tolist(),
        'tones_ogives_prisme': PRISM_ARCH_TONES.tolist(),
    }
    return frames, info


def rock_frames(rock_rgba, ex_rocks):
    """5 îlots de roche noire en lévitation : oscillation sinusoïdale de +-1 ou 2 px sur 24 phases."""
    lab, n = nd.label(ex_rocks)
    offs = [0, 5, 10, 15, 20]
    amps = [2, 1, 2, 1, 2]
    info = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        info.append({
            'id': i,
            'phase': offs[(i - 1) % len(offs)],
            'amp': amps[(i - 1) % len(amps)],
            'centre_xy': [int(round(xs.mean())), int(round(ys.mean()))],
            'pixels': int(len(ys)),
        })
    frames = []
    for t in range(ROCK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for d in info:
            dy = int(round(d['amp'] * np.sin(2 * np.pi * (t - d['phase']) / ROCK_PHASES)))
            ys, xs = np.nonzero(lab == d['id'])
            ok = (ys + dy >= 0) & (ys + dy < H)
            e[ys[ok] + dy, xs[ok]] = rock_rgba[ys[ok], xs[ok]]
        frames.append(e)
    return frames, info


def gold_circuit_frames(cols_circuit, ex_circuit):
    """Circuits de la muraille noire et veines des rochers noirs : pulsation en OR sur 16 crans x 5 ticks."""
    lum = lum_of(cols_circuit)
    ys, xs = np.nonzero(ex_circuit)
    order = np.argsort(lum[ys, xs], kind='stable')
    n = len(order)
    g_dark = np.zeros_like(ex_circuit)
    g_mid = np.zeros_like(ex_circuit)
    g_bright = np.zeros_like(ex_circuit)
    g_dark[ys[order[:n // 3]], xs[order[:n // 3]]] = True
    g_mid[ys[order[n // 3:2 * n // 3]], xs[order[n // 3:2 * n // 3]]] = True
    g_bright[ys[order[2 * n // 3:]], xs[order[2 * n // 3:]]] = True
    frames = []
    for t in range(CIRCUIT_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        e[g_dark, :3] = GOLD_RAMPS['sombre'][t]
        e[g_mid, :3] = GOLD_RAMPS['moyen'][t]
        e[g_bright, :3] = GOLD_RAMPS['vif'][t]
        e[ex_circuit, 3] = 255
        frames.append(e)
    counts = {'sombre': int(g_dark.sum()), 'moyen': int(g_mid.sum()), 'vif': int(g_bright.sum())}
    return frames, counts


def reality_rift_frames(ex_rocks_wall, allowed_sky, forbidden_walk):
    """10 brèches de réalité qui s'ouvrent et se ferment à divers endroits (5 dans les nuages, 5 sur les rochers noirs),
    strictement exclues du chemin praticable (~forbidden_walk).
    Chaque brèche s'ouvre sur 16 phases (fente -> faille losangique déchirée -> fermeture) et reste fermée 8 phases.
    """
    yy, xx = np.mgrid[:H, :W].astype(float)
    allowed_zones = (ex_rocks_wall | allowed_sky) & ~forbidden_walk

    # Pré-calcul des coordonnées locales de chaque brèche
    rifts_meta = []
    for idx, (cx, cy, hl, hw, ang_deg, ph_off, zone_name) in enumerate(RIFT_SPECS):
        th = np.radians(ang_deg)
        cs, sn = float(np.cos(th)), float(np.sin(th))
        rifts_meta.append({
            'id': idx + 1,
            'centre_xy': [cx, cy],
            'demi_longueur_px': hl,
            'demi_largeur_px': hw,
            'angle_deg': ang_deg,
            'phase_offset': ph_off,
            'zone': zone_name,
            'cos': cs,
            'sin': sn,
        })

    frames = []
    for t in range(RIFT_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for rf in rifts_meta:
            age = (t - rf['phase_offset']) % RIFT_PHASES
            if age >= 16:
                continue  # brèche totalement fermée pendant 8 phases
            # Ouverture progressive 0 -> 1 -> 0 sur 16 phases
            open_u = float(np.sin(np.pi * (age + 0.5) / 16.0))
            cx, cy = rf['centre_xy']
            hl = rf['demi_longueur_px'] * (0.32 + 0.68 * open_u)
            hw = max(1.1, rf['demi_largeur_px'] * open_u)

            # Boîte englobante locale pour accélérer le calcul
            pad = int(rf['demi_longueur_px'] + 10)
            x0, x1 = max(0, cx - pad), min(W, cx + pad + 1)
            y0, y1 = max(0, cy - pad), min(H, cy + pad + 1)
            dx = xx[y0:y1, x0:x1] - cx
            dy = yy[y0:y1, x0:x1] - cy
            u = dx * rf['cos'] + dy * rf['sin']
            v = -dx * rf['sin'] + dy * rf['cos']

            # Ligne médiane brisée (zig-zag de déchirure dimensionnelle)
            zig = 1.6 * np.sin(0.38 * u + rf['id'] * 1.3) + 0.8 * np.cos(0.75 * u - rf['id'])
            v_rel = np.abs(v - zig)
            env = np.maximum(0.0, 1.0 - np.abs(u) / max(hl, 1e-3))
            half_w = hw * (env ** 0.75)

            # Éclairs de fracture secondaires aux extrémités et sur les flancs
            spur1 = (np.abs(u) < hl * 1.18) & (np.abs(v - zig - 0.32 * u) < 1.05) & (u * v > 0)
            spur2 = (np.abs(u) < hl * 1.12) & (np.abs(v - zig + 0.28 * u) < 0.95) & (u * v < 0)

            loc_ok = allowed_zones[y0:y1, x0:x1]
            core = loc_ok & (np.abs(u) <= hl) & (v_rel <= half_w * 0.58)
            inner_rim = loc_ok & (np.abs(u) <= hl * 1.04) & ~core & (v_rel <= half_w * 0.88 + 0.7)
            outer_rim = loc_ok & ~core & ~inner_rim & (
                ((np.abs(u) <= hl * 1.08) & (v_rel <= half_w * 1.15 + 1.3))
                | ((open_u > 0.35) & (spur1 | spur2))
            )

            sub = e[y0:y1, x0:x1]
            # Vide intérieur : bandes sombres distorsionnées + micro-étoiles
            if core.any():
                wave = 0.5 + 0.5 * np.sin(0.45 * u - 0.55 * v + 2 * np.pi * t / RIFT_PHASES)
                lvl = np.clip((wave * len(RIFT_VOID_TONES)).astype(int), 0, len(RIFT_VOID_TONES) - 1)
                sub[core, :3] = np.array(RIFT_VOID_TONES, 'uint8')[lvl[core]]
                sub[core, 3] = 255
                # Étoiles internes qui clignotent dans la brèche ouverte
                star_m = core & (((x0 + np.arange(x1 - x0))[None, :] * 7 + (y0 + np.arange(y1 - y0))[:, None] * 13 + t) % 29 == 0)
                sub[star_m, :3] = RIFT_STAR_TONES[t % 2]

            # Lèvre interne : éclat doré / cyan / magenta prismatique
            if inner_rim.any():
                rim_idx = ((u[inner_rim].astype(int) + t) % len(RIFT_RIM_INNER))
                sub[inner_rim, :3] = np.array(RIFT_RIM_INNER, 'uint8')[rim_idx]
                sub[inner_rim, 3] = 255

            # Lèvre externe et éclairs de fracture : ambre doré et cramoisi dimensionnel
            if outer_rim.any():
                out_idx = ((v[outer_rim].astype(int) + age) % len(RIFT_RIM_OUTER))
                sub[outer_rim, :3] = np.array(RIFT_RIM_OUTER, 'uint8')[out_idx]
                sub[outer_rim, 3] = 255

        frames.append(e)
    return frames, rifts_meta


MOTE_TONES_GOLD = [(255, 247, 159), (247, 207, 71), (215, 159, 39)]
MOTE_TONES_PRISM = [(183, 239, 255), (247, 183, 231), (183, 247, 207)]


def mote_frames(ex_portal, ex_circuit):
    """16 éclats d'or et de prisme (8 prismatiques autour du cristal, 8 dorés au-dessus des veines d'or)."""
    py, px = np.nonzero(ex_portal)
    cy, cx = np.nonzero(ex_circuit & (np.mgrid[:H, :W][0] > 180))
    rng = np.random.default_rng(292)
    motes = []
    for i in range(N_MOTES):
        is_prism = (i % 2 == 0)
        if is_prism:
            idx = int(rng.integers(len(px)))
            x0, y0 = int(px[idx]), int(py[idx])
        else:
            idx = int(rng.integers(len(cx)))
            x0, y0 = int(cx[idx]), int(cy[idx])
        motes.append({
            'x': int(np.clip(x0, 16, W - 16)),
            'y': int(np.clip(y0, 32, H - 32)),
            'phase': (i * 3) % MOTE_PHASES,
            'famille': 'prisme' if is_prism else 'or',
        })
    frames = []
    for t in range(MOTE_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for m in motes:
            k = (t - m['phase']) % MOTE_PHASES
            if k >= 18:
                continue
            u = k / 18.0
            x = int(round(m['x'] + 2 * np.sin(2 * np.pi * u)))
            y = int(round(m['y'] - 24 * u))
            tones = MOTE_TONES_PRISM if m['famille'] == 'prisme' else MOTE_TONES_GOLD
            tone = tones[min(2, int(u * 3))]
            shape = ((0, 0), (-1, 0), (1, 0), (0, -1), (0, 1)) if k < 6 else (((0, 0), (0, 1), (1, 0), (1, 1)) if k < 12 else ((0, 0),))
            for dy, dx in shape:
                if 0 <= y + dy < H and 0 <= x + dx < W:
                    e[y + dy, x + dx, :3] = tone
                    e[y + dy, x + dx, 3] = 255
        frames.append(e)
    return frames, motes


# ---------------------------------------------------------------- contrôle de fidélité de la palette Noir / Or / Rouge-Noir
def compute_fidelity(a_decor, a_sol, a_nuages, masks):
    """Vérifie que chaque matière du brut V2 respecte la cible Noir & Or / Nuages Rouge-Noir (< 35)
    et qu'aucun pixel de circuit rouge ne subsiste.
    """
    mapping = {
        'dalles_ardoise': a_decor[masks['parvis_dalles']].mean(0),
        'muraille_noire': a_decor[masks['muraille_gothique']].mean(0),
        'roche_noire': a_decor[masks['parois_rocheuses']].mean(0),
        'circuits_or': a_decor[masks['circuits_or']].mean(0),
        'sol_complet': a_sol.reshape(-1, 3).mean(0),
    }
    r_n, g_n, b_n = a_nuages[..., 0], a_nuages[..., 1], a_nuages[..., 2]
    m_nua = ~((r_n > 200) & (b_n > 200) & (g_n < 80)) & ~((r_n - g_n > 45) & (b_n - g_n > 35))
    mapping['nuages_rouge_noir'] = a_nuages[m_nua].mean(0)
    out = {}
    for k, target in TARGET_PALETTE_V2.items():
        md = mapping[k]
        t_arr = np.array(target, dtype=float)
        out[k] = {
            'cible_rgb': [round(float(v), 1) for v in t_arr],
            'decor_rgb': [round(float(v), 1) for v in md],
            'distance': round(float(np.linalg.norm(md - t_arr)), 1),
        }
    return out


# ---------------------------------------------------------------- ORA et Ground PMDO 0.8.12
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Tour Temporelle sud-nord V2 Noir-Or (ETT2)')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(
                stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                **{'composite-op': 'svg:src-over'}
            )
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


def load_ground_template():
    zip_path = R / 'mod_metano_expeditions_pmdo_0812.zip'
    if zip_path.exists():
        with zipfile.ZipFile(zip_path) as z:
            return json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    return json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))


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
                f = bank.add(Image.fromarray(a[y * 8:y * 8 + 8, x * 8:x * 8 + 8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Data/Ground/../Content/Tile/{bank.name}.tile' if False else STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(
        Name={'DefaultText': 'Entree Tour Temporelle V2 - Noir & Or Prismatique (4:3)', 'LocalTexts': {}},
        AssetName=ASSET,
        Released=False,
        TexSize=1,
        Music='',
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0},
        ActiveChar=None,
        Status={},
        Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment=(
            'PMDO 0.8.12. Version 2 Noir & Or Prismatique : circuits et veines en or animes (16 crans), cristal a '
            'reflets arc-en-ciel, roche noire, nuages rouge/noir en derive et breches de realite hors du chemin.'
        ),
    )
    o['obstacles'] = [
        [{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])} for y in range(gh)]
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
  <Name>Entree Tour Temporelle V2 Noir-Or 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition V2 : tour prismatique noir et or, veines d'or, cristal a reflets arc-en-ciel, roche noire, nuages rouge/noir et breches de realite hors du chemin. Pas une aventure jouable.</Description>
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
    if (HERE / 'README_PACK.md').exists():
        shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    return {b.name: len(b.data) for b in banks}


# ---------------------------------------------------------------- build principal
def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')

    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review'] + [f'animation/{k}' for k in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a = rgb(RAW / 'decor_magenta.png')
    f = rgb(RAW / 'sol_complet.png')
    nua = rgb(RAW / 'nuages_magenta.png')
    assert a.shape[:2] == f.shape[:2] == nua.shape[:2] == (SRC[1], SRC[0])

    m, seg = classify(a)
    fid = compute_fidelity(a, f, nua, m)
    for k, v in fid.items():
        assert v['distance'] < FIDELITY_MAX, (k, v)

    order = [
        'void', 'rochers_flottants', 'profondeur', 'circuits_or', 'portail_cristal',
        'parvis_dalles', 'chaussee_noire', 'parois_rocheuses', 'muraille_gothique',
    ]
    ex, cols = down_class(a, m, order)

    sky = np.zeros((H, W, 4), 'uint8')
    sky[..., :3] = SKY_TONE
    sky[..., 3] = 255
    layers = {'sol_complet': rgba(down_full(f), ~ex['void'])}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n_col in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n_col))
    layers = q
    layers['ciel'] = sky

    rock_rgba = quantize_group({'r': rgba(cols['rochers_flottants'], ex['rochers_flottants'])}, 24)['r']

    open_sky = ex['void'] | ex['rochers_flottants']
    cells = open_sky.reshape(H // 8, 8, W // 8, 8).any((1, 3))
    allowed_sky = np.repeat(np.repeat(cells, 8, 0), 8, 1)

    # Zone praticable : parvis_dalles + chaussee_noire (veines d'or incluses dans la chaussée)
    walk_raw = ex['parvis_dalles'] | ex['chaussee_noire']
    walk = nd.binary_fill_holes(morph(nd.binary_closing, walk_raw, 4)) & (
        ex['parvis_dalles'] | ex['chaussee_noire'] | ex['circuits_or']
    )
    # Zone strictement interdite aux brèches de réalité : chemin praticable + esplanade + portail + marge de 10 px
    forbidden_walk = morph(
        nd.binary_dilation,
        walk | ex['parvis_dalles'] | ex['chaussee_noire'] | ex['portail_cristal'] | ex['profondeur'],
        10,
    )

    cf, spans, cpal, heights = cloud_frames(allowed_sky)
    reff, ref_info = rainbow_reflection_frames(layers['portail_cristal'], ex['portail_cristal'], cols['muraille_gothique'], ex['muraille_gothique'])
    rkf, rocks_info = rock_frames(rock_rgba, ex['rochers_flottants'])
    cirf, cir_counts = gold_circuit_frames(cols['circuits_or'], ex['circuits_or'])
    rock_mass = ex['parois_rocheuses'] | (ex['circuits_or'] & (np.mgrid[:H, :W][0] >= 170))
    riftf, rifts_info = reality_rift_frames(rock_mass, allowed_sky, forbidden_walk)
    motf, motes_info = mote_frames(ex['portail_cristal'], ex['circuits_or'])

    # Masque union de toutes les brèches sur les 24 phases (pour prouver l'absence totale de brèche sur le chemin)
    rift_union = np.any([fr[..., 3] > 0 for fr in riftf], axis=0)
    assert not (rift_union & walk).any(), 'brèche de réalité détectée sur le chemin praticable !'

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((allowed_sky * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_ciel_visible.png')
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    Image.fromarray((rift_union * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_breches_union.png')

    stack_spec = [
        ('ciel', [layers['ciel']], 60),
        ('nuages', cf, CLOUD_TICKS),
        ('sol_complet', [layers['sol_complet']], 60),
        ('chaussee_noire', [layers['chaussee_noire']], 60),
        ('parvis_dalles', [layers['parvis_dalles']], 60),
        ('parois_rocheuses', [layers['parois_rocheuses']], 60),
        ('muraille_gothique', [layers['muraille_gothique']], 60),
        ('portail_cristal', [layers['portail_cristal']], 60),
        ('reflets_arc_en_ciel', reff, REF_TICKS),
        ('profondeur', [layers['profondeur']], 60),
        ('rochers_flottants', rkf, ROCK_TICKS),
        ('circuits_or', cirf, CIRCUIT_TICKS),
        ('breches_realite', riftf, RIFT_TICKS),
        ('eclats_or_prisme', motf, MOTE_TICKS),
    ]

    layer_files = []
    layer_list = []
    for i, (nm, frames, ticks) in enumerate(stack_spec):
        if len(frames) > 1:
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            rel = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            layer_files.append(rel)
            layer_list.append({'file': rel, 'phases': len(frames), 'ticks': ticks})
        else:
            rel = f'calques/{PFX}_{i:02d}_{nm}.png'
            Image.fromarray(frames[0]).save(OUT / rel)
            layer_files.append(rel)
            layer_list.append({'file': rel, 'phases': 1, 'ticks': 60})

    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]
    med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    dys, dxs = np.nonzero(ex['profondeur'])
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16 de entrance a donjon_seuil'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_spec:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im

    step = 5
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(
        OUT / 'review' / f'{PFX}_scene_animee.webp',
        save_all=True, append_images=scenes[1:], duration=round(step * 1000 / 60), loop=0, lossless=True,
    )
    col = scenes[0].copy()
    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov)
    col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    # Planche de contrôle x2 : cristal arc-en-ciel + circuits d'or + brèches qui s'ouvrent et se ferment (ticks 0, 50, 100, 150)
    z = Image.new('RGB', (4 * 320, 280), (16, 12, 20))
    for j, tk in enumerate((0, 50, 100, 150)):
        crop = scene(tk).crop((36, 210, 276, 420)).convert('RGB').resize((320, 280), Image.Resampling.NEAREST)
        z.paste(crop, (j * 320, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_portail_breches.png')

    write_ora(
        OUT / f'{PFX}_entree_tour_temporelle_v2_calques.ora',
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_spec)},
    )
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_spec],
        blocked, entry_px, threshold_px, gfx, tools,
    )

    manifest = {
        'lot': LOT,
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'base': 'main (b2c7112) ; V1 (ETT1) conservee intacte',
        'biome': (
            'entree de tour prismatique noir et or (veines et circuits en or), arche de cristal a reflets '
            'legerement arc-en-ciel, roche noire, mer de nuages rouge/noir et breches de realite hors du chemin'
        ),
        'method': (
            'rendu genere REFERENCE sur fond magenta d apres ETT1/D29P11A en palette Noir & Or Prismatique ; '
            'circuits d or animes sur 16 crans ; reflets arc-en-ciel pastel sur le cristal et les ogives ; '
            '10 breches de realite s ouvrant et se fermant sur les rochers et les nuages (0 px sur le chemin)'
        ),
        'reference_da': {
            'code_rom_geometrie': 'D29P11A',
            'code_rom_distorsion': 'D30P34A',
            'file': str(REF_D29.relative_to(R)),
            'sha256': sha(REF_D29),
            'file_distorsion': str(REF_D30.relative_to(R)),
            'sha256_distorsion': sha(REF_D30),
        },
        'generation': GEN,
        'raw_inputs': [
            {
                'file': f'source/{LOT}/bruts/{g["file"]}',
                'sha256': sha(RAW / g['file']),
                'size': list(Image.open(RAW / g['file']).size),
            }
            for g in GEN
        ],
        'segmentation_mesures': seg,
        'fidelite_rip': {
            'methode': 'distance euclidienne des moyennes RGB aux cibles Noir & Or / Nuages Rouge-Noir ; seuil 35',
            'seuil': FIDELITY_MAX,
            'mesures': fid,
        },
        'normalization': {
            'scale': SCALE,
            'scaled': [SCALED_W, H],
            'crop_x': [CROP_X, SCALED_W - W - CROP_X],
            'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
            'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()},
        },
        'segmentation': classify.__doc__.strip(),
        'layer_order_bottom_to_top': layer_files,
        'layers': layer_list,
        'ciel': {'ton': list(SKY_TONE), 'origine': 'ton rouge-noir d abime assorti a la base des nuages cramoisis'},
        'nuages': {
            'phases': CLOUD_PHASES,
            'frame_length_ticks': CLOUD_TICKS,
            'pas_px': CLOUD_STEP,
            'periode_px': CLOUD_P,
            'echelle_brut': CLOUD_SCALE,
            'fondu_px': CLOUD_SEAM,
            'bandes_brut_lignes': spans,
            'hauteurs': heights,
            'rangees': [{'haut': t, 'bande': b, 'decalage_x': d} for t, b, d in CLOUD_ROWS],
            'palette': cpal.tolist(),
        },
        'reflets_arc_en_ciel': {
            'phases': REF_PHASES,
            'frame_length_ticks': REF_TICKS,
            'largeur_bande': REF_BW,
            'details': ref_info,
        },
        'rochers_flottants': {
            'phases': ROCK_PHASES,
            'frame_length_ticks': ROCK_TICKS,
            'liste': rocks_info,
        },
        'circuits_or': {
            'phases': CIRCUIT_PHASES,
            'frame_length_ticks': CIRCUIT_TICKS,
            'rampes': {k: [list(c) for c in v] for k, v in GOLD_RAMPS.items()},
            'tons_or': [list(c) for c in GOLD_CIRCUIT_TONES],
            'pixels_par_rampe': cir_counts,
        },
        'breches_realite': {
            'phases': RIFT_PHASES,
            'frame_length_ticks': RIFT_TICKS,
            'phases_ouvertes_par_cycle': 16,
            'phases_fermees_par_cycle': 8,
            'pixels_union_totale': int(rift_union.sum()),
            'pixels_sur_chemin_praticable': int((rift_union & walk).sum()),
            'liste': rifts_info,
        },
        'eclats_or_prisme': {
            'phases': MOTE_PHASES,
            'frame_length_ticks': MOTE_TICKS,
            'liste': motes_info,
        },
        'scene_loop_ticks': LOOP_TICKS,
        'access': {
            'entry_px': entry_px,
            'threshold_px': threshold_px,
            'path_found_16x16': reach,
            'cells_explored': explored,
            'blocked_cells': int(blocked.sum()),
            'total_cells': int(blocked.size),
            'walkable_cells': int((~blocked).sum()),
        },
        'pmdo': {
            'target': '0.8.12',
            'asset': ASSET,
            'namespace': NAMESPACE,
            'tiles_per_bank': counts,
            'banks': list(counts),
            'runtime_tested': False,
            'warp': 'aucun',
        },
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({
        'entry': entry_px,
        'threshold': threshold_px,
        'blocked': int(blocked.sum()),
        'walkable': int((~blocked).sum()),
        'fidelite': {k: v['distance'] for k, v in fid.items()},
        'circuits_or_px': cir_counts,
        'breches_union_px': int(rift_union.sum()),
        'breches_sur_chemin_px': int((rift_union & walk).sum()),
        'tiles': counts,
    }, indent=2))


if __name__ == '__main__':
    build()
