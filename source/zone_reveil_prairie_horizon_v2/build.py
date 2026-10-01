"""Zone de réveil V2 (ZRV2) — même prairie que ZRV1, mer et fond refaits. 768 x 576 px, jour / aube / nuit.

Demande (27 septembre), après ZRV1 : « regarde l'animation de la mer V24P04A et des nuages, c'est ce que je te demandais
pour la zone réveil (faut que la zone soit multicalque) : la mer a son propre calque, le ciel, les nuages ; l'idée de la
montagne est bien mais faut que ce soit raccordé logiquement à l'horizon ; animer les nuages, pas m'en rajouter ; les
fleurs animées comme Sky Peak ; génère le reflet de la lune sur la mer et ses animations logiques ». Réponses : mer
GÉNÉRÉE avec V24P04A en référence (pas de pixels natifs), nouvelle version (ZRV1 gardée). Puis : « je veux garder le
layout de la V1, juste corrige la mer et le background, laisse la montagne, mais les nuages derrière la montagne :
la mer => montagne => nuages ».

Profondeur (du plus proche au plus loin) : prairie, mer, montagne (posée sur l'horizon), nuages (posés sur l'horizon,
derrière la montagne, qui défilent), astre, ciel.

- Prairie : calques finaux de ZRV1 relus tels quels (herbe, chemin, fleurs, rochers, buissons, sol complet), mêmes
  collisions, mêmes marqueurs. Seules les FLEURS gagnent une animation (loi du GIF Sky Peak : A B A C, 12 ticks).
- Montagne : la montagne de ZRV1, éditée par le générateur (nuages retirés, pentes prolongées jusqu'à l'horizon),
  recalée à sa place de ZRV1.
- Ciel et mer : brut généré avec V24P04A en référence ; houle (crêtes qui roulent vers la prairie) animée par la loi de
  V24P04A (12 crans x 10 ticks) avec des crêtes générées ; scintillement de l'horizon (16 crans x 4 ticks, comme les
  4 palettes animées de V24P04A) ; écume au pied de la prairie, synchronisée sur la houle. Les lignes de houle fines et les
  plaques claires peintes par le générateur dans la plaque sont extraites dans le calque « ondes » (plaque rebouchée avec
  son propre grain) et décrivent l'orbite de l'eau au rythme de la houle (12 x 10 ticks).
- Nuages : trois bancs générés mis bout à bout en une bande de 768 px (aucune répétition à l'écran), qui défile derrière
  la montagne (384 phases de 2 px x 16 ticks).
- Aube et nuit : mêmes pixels recolorés par rang de luminance sur les couleurs des bruts d'aube et de nuit de ZRV1 ;
  lune (nuit) et soleil (aube) générés ; reflet de l'astre généré par nous, animé sur la houle (12 x 10 ticks).
Lancer : .venv/bin/python source/zone_reveil_prairie_horizon_v2/build.py [--apercu]
"""
from pathlib import Path
import hashlib, importlib.util, io, json, math, shutil, sys, uuid, warnings, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'source/zone_reveil_prairie_horizon_v2'
V1LOT = R / 'source/zone_reveil_prairie_horizon_v1'
V1OUT = R / 'renders/zone_reveil_prairie_horizon_v1'
OUT = R / 'renders/zone_reveil_prairie_horizon_v2'
NAMESPACE = 'zone_reveil_prairie_horizon_v2'
STAGE = R / '.cache/zone_reveil_prairie_horizon_v2' / NAMESPACE
PFX = 'ZRV2'
AMB = {'jour': 'J', 'aube': 'A', 'crepuscule': 'C', 'nuit': 'N'}
ASSET = {k: f'zrv2_zone_reveil_{k}' for k in AMB}
W, H = 768, 576
YH = 116                                           # horizon (ZRV1)
V1_SCALE, V1_CROP_X = 0.642857, 1                  # brut ZRV1 (1200 x 896) -> espace final
MOUNT_CROP = (380, 0, 820, 180)                    # zone du brut ZRV1 donnée au générateur (agrandie x 2)
REFS = {'v24p04a': f'{LOT}/references/v24p04a_t000.png', 'v24p02a': f'{LOT}/references/v24p02a_t000.png',
        'skypeak': f'{LOT}/references/skypeak_gif_frame0.png', 'nuit_native': 'bgnightbackgroundpmdskyda.png',
        'gif_skypeak': '2cwdrrs469f61.gif', 'banc_style': f'{LOT}/references/banc_nuages_style_x520_y250_x2.png'}
GEN = [
    {'file': 'ciel_mer_jour.png', 'images': [f'{LOT}/references/v24p04a_t000_x4.png'], 'essais': 'deuxieme generation (la premiere, '
     'identique et conforme, a ete perdue avant commit par une reinitialisation de l espace de travail) ; conforme',
     'prompt': 'Pokémon Mystery Dungeon Explorers of Sky background, pixel art, exactly the same colours, palette and pixel style as '
     'the reference image (the ocean horizon scene). Side view of the open ocean seen from a high place. The horizon is a perfectly '
     'straight horizontal line at 30 percent of the image height. Above the horizon: clear blue sky gradient only, darker blue at the '
     'top, pale near the horizon, absolutely no clouds, no mountains, no sun. Below the horizon: the ocean, a bright cyan band with '
     'many tiny white glitter sparkles right under the horizon, then horizontal bands getting deeper blue toward the bottom, with thin '
     'faint darker swell lines. No white wave crests, no foam, no land, no characters, no text.'},
    {'file': 'cretes_jour.png', 'images': [f'{LOT}/references/v24p04a_t000_x4.png'], 'essais': 'deuxieme generation (meme cas) ; '
     'conforme ; la 5e rangee (vague pleine, deferlante) n est pas utilisee',
     'prompt': 'Sprite sheet, pixel art, exactly the same colours and pixel style as the white foam wave crests in the reference image '
     '(Pokémon Mystery Dungeon Explorers of Sky ocean). On a solid flat magenta background (#FF00FF): isolated ocean wave crests seen '
     'from the side, each one a gentle double-hump wave line of white and pale cyan foam with a thin darker blue shadow under it. '
     'Arrange them in 5 rows from very small and thin (top row) to large (bottom row), 2 crests per row: left crest full foam, right '
     'crest thinner breaking foam. Well separated, nothing touching, no water background, no text.'},
    {'file': 'banc_nuages_jour.png', 'images': [f'{LOT}/references/v24p04a_t000_x4.png',
                                                f'{LOT}/bruts/ecartes/mer_de_nuages_jour_trois_bancs.png'],
     'essais': 'remplace mer_de_nuages_jour.png (trois bancs colles : la dalle du banc du milieu rognait les nuages du bas, '
               'ecarte dans bruts/ecartes/) ; deux bancs encore, seul celui du haut (ciel magenta au-dessus) est utilise ; '
               'un sommet plat de 70 px (x 217-286) est arrondi par le build',
     'prompt': 'Pixel art, same colours and pixel style as the clouds on the horizon in the first reference (Pokémon Mystery '
     'Dungeon Explorers of Sky) and the cloud style of the second reference. ONE single low horizontal bank of fluffy white and pale '
     'blue-grey cumulus clouds, spanning the full image width, seamlessly tileable left to right. The bank occupies only the lower '
     '40 percent of the image; its bottom edge is a perfectly straight horizontal line touching the bottom of the image; its top '
     'edge is round puffy billows of varying height, every billow complete and rounded. The whole upper 60 percent of the image is '
     'solid flat magenta (#FF00FF) with nothing in it. No second bank, no sky, no sea, no mountains, no text.'},
    {'file': 'banc_nuages_jour_c.png', 'images': [f'{LOT}/bruts/banc_nuages_jour.png'],
     'essais': 'correction des nuages (le banc de 256 px revenait 3 fois a l ecran) : banc de plus demande avec le banc A en reference ; '
               'le generateur a recopie x 375-1075 du banc A, seules les colonnes differentes comptent comme matiere neuve (le brut entier '
               'est enchaine au banc A limite a x < 360)',
     'prompt': 'Pixel art, exactly the same colours, palette and pixel style as the upper cloud bank of the reference image. ONE single '
     'low horizontal bank of fluffy white and pale blue-grey cumulus clouds spanning the full image width, with a different arrangement '
     'of billows than the reference. The bank occupies only the lower 40 percent of the image; its bottom edge is a perfectly straight '
     'horizontal line touching the bottom of the image; its top edge is round puffy billows of varying height, every billow complete and '
     'rounded, with a few low dips between cloud groups. The whole upper 60 percent of the image is solid flat magenta (#FF00FF). No '
     'second bank, no sky, no sea, no mountains, no text.'},
    {'file': 'banc_nuages_jour_b.png', 'images': [f'{LOT}/references/banc_nuages_style_x520_y250_x2.png'],
     'essais': 'deuxieme essai de banc de plus : recadrage du banc A seul en reference (le premier essai recopiait la composition) ; '
               'bosses de meme largeur que le banc A (105 px), sommets plus hauts : reduit a 0,62 pour garder la hauteur du banc A',
     'prompt': 'Pixel art, exactly the same cloud colours, shading and pixel style as the reference crop. A wide panorama: ONE single low '
     'horizontal bank of fluffy white and pale blue-grey cumulus clouds spanning the full image width, made of about eight separate '
     'rounded cloud groups of different heights with low dips between them. The bank occupies only the lower 35 percent of the image; '
     'its bottom is a solid pale blue-grey band ending in a perfectly straight horizontal line at the bottom of the image; every billow on '
     'top is complete and rounded, none cut. The whole upper 65 percent of the image is solid flat magenta (#FF00FF). Only one bank, no '
     'second row of clouds, no sky, no sea, no text.'},
    {'file': 'reflets_astres.png', 'images': [f'{LOT}/references/v24p04a_t000_x4.png', 'source/zone_reveil_prairie_horizon_v1/bruts/decor_nuit.png'],
     'essais': 'premiere generation ; conforme (demande : reflet de la lune et du crepuscule passes au generateur)',
     'prompt': 'Pixel art sprite sheet in the same pixel style as the reference images (Pokémon Mystery Dungeon Explorers of Sky '
     'ocean and moon). On a solid flat magenta background (#FF00FF): three separate vertical columns of light reflected on the sea '
     'surface, as seen under a low moon or sun on water. Each column is made only of short horizontal wavy dashes and glints of '
     'light stacked from top to bottom, very narrow and thin at the top, getting wider, longer and more spaced toward the bottom, '
     'with gaps of magenta between dashes. Left column: pale silver-yellow moonlight. Middle column: warm golden dawn light. Right '
     'column: deep orange and red sunset light. Tall columns, well separated, no water drawn, no moon, no sun, no text.'},
    {'file': 'decor_crepuscule_zrv1.png', 'images': ['source/zone_reveil_prairie_horizon_v1/bruts/decor_jour.png',
                                                     'source/zone_reveil_prairie_horizon_v1/bruts/decor_aube.png'],
     'essais': 'premiere generation ; recalee au pixel sur le jour de ZRV1 (meilleur decalage (0, 0)) : couleurs de la prairie, '
               'du ciel, de la mer, de la montagne, des nuages et du soleil du crepuscule',
     'prompt': 'Edit the first image into a sunset dusk scene, keeping exactly the same layout, framing, shapes and every object at '
     'the same pixel position (meadow, flowers, rocks, bushes, path, sea, mountain, clouds). Only change the lighting and colours: sky '
     'from deep violet at the top to orange and red near the horizon, a large low orange-red setting sun on the right side just above '
     'the clouds, clouds lit pink-orange from below, mountain warm rose and purple, sea deep purple-blue with orange glints, meadow '
     'grass warm olive-orange in the evening light with long soft shadows, flowers keep their pink. Same pixel art style as the second '
     'image (the dawn version).'},
    {'file': 'montagne_jour.png', 'images': [f'{LOT}/references/v1_montagne_x380_y0_x2.png'], 'essais': 'deuxieme essai : le premier '
     '(brut ZRV1 entier en entree) peignait une montagne geante plein cadre, ecarte (bruts/ecartes/) ; celui-ci garde le cadrage '
     '(rapport 2,444 identique a l entree)',
     'prompt': 'Edit this pixel art image, keeping the exact same framing, size and position. Keep the big snowy mountain and its lower '
     'blue ridges exactly as they are. Remove every cloud (the small clouds near the summit and the cloud band at the bottom): where '
     'the clouds covered the mountain, continue the mountain\'s slopes and ridges straight down with the same icy blue rock and snow '
     'until the very bottom edge of the image, widening naturally. Replace the sky and everything that is not mountain with solid flat '
     'magenta (#FF00FF).'},
    {'file': 'astres.png', 'images': ['source/zone_reveil_prairie_horizon_v1/bruts/decor_nuit.png',
                                      'source/zone_reveil_prairie_horizon_v1/bruts/decor_aube.png'],
     'essais': 'deuxieme generation (meme cas) ; conforme',
     'prompt': 'Pixel art sprite sheet, same pixel style and colours as the moon in the first reference image and the sun in the second '
     '(Pokémon Mystery Dungeon Explorers of Sky). On a solid flat magenta background (#FF00FF): on the left, a large round full moon, '
     'pale yellow with soft darker yellow craters and a thin light rim; on the right, a large round rising sun disk, warm golden '
     'yellow with a lighter centre. Both perfectly round, same size, well separated, no glow halo, no clouds, no text.'},
]
# ---- lois d'animation
SWELL_STEPS, SWELL_TICKS = 12, 10                  # V24P04A : BPA 12 crans x 10 ticks
SWELL_PASSES = 2                                   # V24P04A (12 images décodées) : une crête avance de 2 rangées par cycle, 5 à 8 px par cran
GLINT_STEPS, GLINT_TICKS = 16, 4                   # V24P04A : palettes animées 16 crans x 4 ticks
GLINT_LEVELS = [1, 1, 2, 2, 1, 1, 0, 0, 0, 0, 1, 1, 2, 1, 0, 0]   # 0 éteint, 1 couleur du brut, 2 blanc
CLOUD_PERIOD, CLOUD_PAS, CLOUD_TICKS = 768, 2, 16  # période = largeur de l'écran : plus aucun nuage répété (256 px = 3 fois le même banc)
CLOUD_PHASES = CLOUD_PERIOD // CLOUD_PAS           # 384 phases ; vitesse inchangée (1 px / 8 ticks)
CLOUD_TINT = 16                                    # raccord : fondu des teintes sur 16 colonnes
CLOUD_BLEND = 0                                    # pas de fondu (il laissait des colonnes isolées) : coupe raccordée
FLOWER_TICKS = 12                                  # GIF Sky Peak : 4 images de 200 ms (A B A C)
STAR_PHASES, STAR_TICKS = 24, 5
# houle : y(u) = YH + D0 + A u + B u^2 (profil de V24P04A : 65, 106, 153 px sous l'horizon, ramené à notre mer)
SWELL_D0, SWELL_A, SWELL_B = 40, 40, 4
SWELL_PERIOD_X = 96                                # V24P04A : motif de 96 px (768 = 8 x 96)
CREST_SCALE = 0.157
SWELL_LINE = 0.85
CREST_W = 78                                       # V24P04A : toutes les crêtes ont presque la largeur du motif (78 / 96)
REFLET_SPAN, REFLET_SX = 172, 0.42                 # reflets : hauteur couverte sous l'horizon, échelle horizontale
CLOUD_BASE_PX, CLOUD_FLAT_MIN, CLOUD_DOME = 17, 40, 30   # base pleine gardée (px finaux) ; sommets plats rognés -> arrondis (px du brut A)
CLOUD_S0, CLOUD_EDGE = 0.30, 0.15                  # échelle provisoire ; coupes cherchées dans les 15 % du début et de la fin de chaque banc
CLOUD_BANKS = [('banc_nuages_jour_c.png', 1.0, (0, 1200)),   # (brut, échelle relative, colonnes utilisables), mis bout à bout en boucle
               ('banc_nuages_jour.png', 1.0, (0, 360)),      # x 375-1075 : identique au brut c (copié par le générateur) -> non repris
               ('banc_nuages_jour_b.png', None, (0, 1584))]  # None : sommets ramenés à la hauteur de ceux du banc A
ONDES_Y0, ONDES_R, ONDES_T, ONDES_MIN = 146, 4, 1.0, 10   # lignes peintes dans la plaque : rangée de départ, demi-fenêtre, seuil, taille min
ONDES_LINE_W, ONDES_AH, ONDES_AV = 60, 60, 90      # ligne (>= 60 px de long) / plaque claire ; amplitudes : 1 + d/60 en x, 0,5 + d/90 en y
SIZE_BOUNDS = [0.4, 1.2, 2.0, 2.8]                 # u < 0.4 : houle sombre ; puis tailles 1..4
ASTRE = {'nuit': {'sprite': 0, 'd': 64, 'c': (384, 34)}, 'aube': {'sprite': 1, 'd': 40, 'c': (236, 32)},
         'crepuscule': {'sprite': 1, 'd': 48, 'c': (560, 44)}}     # soleil couchant : bas, à demi derrière le banc
AMB_RAW = {'nuit': V1LOT / 'bruts/decor_nuit.png', 'aube': V1LOT / 'bruts/decor_aube.png',
           'crepuscule': RAW / 'decor_crepuscule_zrv1.png'}         # bruts d'ambiance (même cadrage que le jour de ZRV1)
AMB_ASTRE = {'nuit': (600, 36, 62), 'aube': (480, 100, 48), 'crepuscule': (812, 65, 54)}   # disque de l'astre dans ces bruts
REFLET_COL = {'nuit': 0, 'aube': 1, 'crepuscule': 2}                # colonne de la planche de reflets générée
ORDER = ['sol_complet', 'ciel', 'etoiles', 'astre', 'nuages', 'montagne', 'mer', 'ondes', 'scintillement', 'houle', 'reflet', 'ecume', 'bulles',
         'herbe', 'chemin', 'fleurs', 'rochers', 'buissons']
V1_INDEX = {'sol_complet': 0, 'herbe': 1, 'chemin': 2, 'fleurs': 3, 'rochers': 4, 'buissons': 5}


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum(a):
    a = np.asarray(a, float)
    return 0.299 * a[..., 0] + 0.587 * a[..., 1] + 0.114 * a[..., 2]


def hsh(*v):
    h = 2166136261
    for x in v:
        h = ((h ^ (int(x) & 0xffffffff)) * 16777619) & 0xffffffff
    return h


def is_magenta(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (r - g > 40) & (b - g > 40)                 # fond magenta et bords teintés de magenta


def palette_of(px, n):
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=n, method=Image.Quantize.MEDIANCUT,
                                                                        dither=Image.Dither.NONE)
    return np.array(q.getpalette()[:n * 3], int).reshape(-1, 3)


def nearest(rgbs, pal):
    flat = rgbs.reshape(-1, 3).astype(int); out = np.empty_like(flat)
    for i in range(0, len(flat), 65536):
        d = ((flat[i:i + 65536, None, :] - pal[None]) ** 2).sum(2); out[i:i + 65536] = pal[d.argmin(1)]
    return out.reshape(rgbs.shape)


def down_rgba(a, fg, size, pal, thr=0.5):
    """Réduction pondérée par la couverture (fond magenta exclu) puis couleurs ramenées à la palette du brut."""
    w = Image.fromarray((fg * 255).astype('uint8')).resize(size, Image.BOX)
    wa = np.array(w, float) / 255
    ch = [np.array(Image.fromarray((a[..., c] * fg).astype(np.float32), 'F').resize(size, Image.BOX)) for c in range(3)]
    col = np.stack(ch, -1) / np.maximum(wa[..., None], 1e-6)
    out = np.zeros((size[1], size[0], 4), 'uint8'); m = wa > thr
    out[m, :3] = nearest(col[m], pal); out[m, 3] = 255
    return out


def save_png(a, path):
    """PNG indexé sans perte (transparence par couleur) quand le calque a au plus 256 couleurs RGBA, sinon RGBA :
    les 384 phases du banc de nuages pèsent 2,4 fois moins, relues identiques en RGBA."""
    a = np.ascontiguousarray(a, dtype='uint8'); key = a.view('<u4').reshape(a.shape[:2])
    cols, inv = np.unique(key, return_inverse=True)
    if len(cols) > 256:
        Image.fromarray(a).save(path); return
    rgba = cols.astype('<u4').view('uint8').reshape(-1, 4)
    im = Image.fromarray(inv.reshape(a.shape[:2]).astype('uint8'), 'P'); im.putpalette(rgba[:, :3].flatten().tolist())
    im.save(path, transparency=bytes(rgba[:, 3].tolist()))


def recolor_rank(layer, samples):
    """Chaque couleur du calque prend la couleur d'échantillon de même quantile de luminance (pixels pondérés)."""
    out = layer.copy(); m = layer[..., 3] == 255
    if not m.any():
        return out
    px = layer[m][:, :3].astype(int)
    cols, inv, cnt = np.unique(px, axis=0, return_inverse=True, return_counts=True)
    order = np.argsort(lum(cols), kind='stable'); cum = np.cumsum(cnt[order]); q = (cum - cnt[order] / 2) / cum[-1]
    s = samples[np.argsort(lum(samples), kind='stable')]
    tgt = np.empty_like(cols); tgt[order] = s[np.clip((q * len(s)).astype(int), 0, len(s) - 1)]
    out[m, :3] = tgt[inv.ravel()]
    return out


SKY_RAW_ROWS = {'nuit': 70, 'aube': 92, 'crepuscule': 86}          # rangées de ciel du brut ZRV1 étalées sur les rangées 0..SKY_SPAN du ciel final
SKY_SPAN = 84


def sky_gradient(layer, amb):
    """Ciel d'aube/nuit : couleur de rangée prise dans le ciel du brut ZRV1 (dégradé vertical), tramage du ciel de jour conservé."""
    a = rgb(AMB_RAW[amb]); l = lum(a)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    c = AMB_ASTRE[amb]
    ok = ((xx - c[0]) ** 2 + (yy - c[1]) ** 2 > c[2] ** 2) & (nd.median_filter(l, 5) > l - 25)   # sans astre ni étoiles
    prof = []
    for y in range(SKY_RAW_ROWS[amb] + 1):
        px = a[y][ok[y]]; ly = lum(px)
        prof.append(px[ly <= np.percentile(ly, 40)].mean(0))                   # bas percentile : écarte les nuages
    prof = np.array(prof)
    out = layer.copy(); m = layer[..., 3] == 255
    L = lum(layer[..., :3].astype(int)).astype(float)
    for y in range(layer.shape[0]):
        r = m[y]
        if not r.any():
            continue
        t = min(1.0, y / SKY_SPAN) * SKY_RAW_ROWS[amb]
        i = int(t); f = t - i; tgt = prof[i] * (1 - f) + prof[min(i + 1, len(prof) - 1)] * f
        d = (L[y, r] - L[y, r].mean()) * 0.6
        out[y, r, :3] = np.clip(np.round(tgt[None] + d[:, None]), 0, 255).astype('uint8')
    return out


def v1_frames(amb, name, idx, n):
    if amb == 'crepuscule':
        return [f.copy() for f in dusk_meadow()[name]]
    d = V1OUT / 'animation' / amb / name
    return [np.array(Image.open(d / f'ZRV1{AMB[amb]}_{idx:02d}_{name}_f{t:03d}.png').convert('RGBA')) for t in range(n)]


_ZRV1 = {}


def zrv1():
    """Module de construction de ZRV1 (segmentation, palettes de la mer du jeu, bulles) : pipeline du crépuscule."""
    if 'm' not in _ZRV1:
        _ZRV1['m'] = loadmod('zrv1_build', V1LOT / 'build.py')
    return _ZRV1['m']


def dusk_meadow():
    """Prairie du crépuscule : même recette que les calques d'aube et de nuit de ZRV1 (masques du jour, couleurs du brut
    de crépuscule recalé au pixel, mêmes groupes de palettes)."""
    if 'prairie' in _ZRV1:
        return _ZRV1['prairie']
    B1 = zrv1(); day = B1.rgb(B1.RAW / 'decor_jour.png'); du = B1.rgb(AMB_RAW['crepuscule'])
    m, sg = B1.seg.classify(day)
    zone = (np.mgrid[:day.shape[0], :day.shape[1]][0] > sg['horizon_y'] + 200) & ~m['buissons']
    reg = B1.recalage(day, du, zone)                                   # assert : (0, 0) est le meilleur décalage
    order = ['panorama', 'mer', 'buissons', 'rochers', 'fleurs', 'chemin', 'herbe']
    ex, _ = B1.down_class(day, m, order); _, cols = B1.down_class(du, m, order)
    lay = {'sol_complet': B1.rgba(np.broadcast_to(np.median(cols['herbe'][ex['herbe']], 0).round().astype('uint8'), (H, W, 3)),
                                  np.ones((H, W), bool))}
    for k in B1.STATIC:
        lay[k] = B1.rgba(cols[k], ex[k])
    for g, (keys, n) in B1.PALETTE_GROUPS.items():
        lay.update(B1.quantize_group({k: lay[k] for k in keys}, n))
    # écume et bulles : palette 8 de s01p02a transposée sur le brut (même méthode que l'aube et la nuit de ZRV1)
    af = B1.down_full(du).astype(int); day_l = B1.lum_of(B1.down_full(day).astype(float))
    sea = np.array(Image.open(V1OUT / 'masques/ZRV1_masque_mer.png')) > 127
    fi = np.array(Image.open(V1OUT / 'masques/ZRV1_ecume_index.png')).astype(int); foam = np.where(fi == 255, -1, fi // 25)
    pred_sel = sea & (foam < 0); pred = B1.lum_of(af.astype(float)); expect = np.zeros((H, W))
    dl = day_l[pred_sel]; al = pred[pred_sel]; o_ = np.argsort(dl)
    expect[pred_sel] = nd.uniform_filter1d(al[o_], 301)[np.argsort(o_)]
    refl = B1.reflection_column(B1.keep_large(B1.close_(pred_sel & (pred > expect + 45), 2), 20), sea)
    p7, p8 = B1.sea_palettes(); pal8 = B1.transpose_palette(p8, day_l, af, sea & ~refl)
    ecume = B1.palette_frames(foam, pal8)
    v1m = json.loads((V1OUT / 'manifest.json').read_text())
    bub = [tuple(b) for b in v1m['ambiances']['jour']['bulles']]
    bcols = [tuple(int(v) for v in pal8[3, 9]), tuple(int(v) for v in pal8[2, 8]), tuple(int(v) for v in pal8[1, 8])]
    _ZRV1['prairie'] = {'calques': {k: lay[k] for k in V1_INDEX}, 'ecume': ecume, 'bulles': B1.bubble_frames(bub, bcols),
                        'recalage': reg, 'ecume_palette_8': pal8.tolist(), 'bulles_couleurs': bcols}
    return _ZRV1['prairie']


def v1_layer(amb, name):
    if amb == 'crepuscule':
        return dusk_meadow()['calques'][name].copy()
    return np.array(Image.open(V1OUT / 'calques' / amb / f'ZRV1{AMB[amb]}_{V1_INDEX[name]:02d}_{name}.png').convert('RGBA'))


# ---------------------------------------------------------------- prairie (ZRV1)
def meadow_mask():
    u = np.zeros((H, W), bool)
    for k in ('herbe', 'chemin', 'fleurs', 'rochers', 'buissons'):
        u |= v1_layer('jour', k)[..., 3] == 255
    return nd.binary_fill_holes(u | (np.arange(H)[:, None] >= H - 16))


def flower_heads(fl):
    """Têtes de fleurs (pixels roses) du calque de jour : graines érodées, chaque pixel rose à la graine la plus proche."""
    a = fl[..., :3].astype(int); m = (fl[..., 3] == 255) & (a[..., 0] > 190) & (a[..., 0] > a[..., 1] + 30)
    seeds, n = nd.label(nd.binary_erosion(m, iterations=2))
    _, (iy, ix) = nd.distance_transform_edt(seeds == 0, return_indices=True)
    lab = np.where(m, seeds[iy, ix], 0)
    return lab, n


def flower_frames(fl, lab, n):
    """Loi du GIF Sky Peak : A B A C ; en B et C chaque tête descend de 1 px et penche de ±1 px (sens propre à la tête)."""
    head = lab > 0; leaf = (fl[..., 3] == 255) & ~head
    d, (iy, ix) = nd.distance_transform_edt(~leaf, return_indices=True)
    base = fl.copy(); fillable = head & (d <= 3)
    base[head] = 0; base[fillable] = fl[iy[fillable], ix[fillable]]
    sign = np.array([0] + [1 if hsh(i, 7) % 2 else -1 for i in range(1, n + 1)])
    ys, xs = np.nonzero(head); ids = lab[ys, xs]; order = np.argsort(ys, kind='stable')
    ys, xs, ids = ys[order], xs[order], ids[order]

    def shifted(k):
        f = base.copy(); dx = sign[ids] * k; dy = np.where(k != 0, 1, 0)
        ty, tx = np.clip(ys + dy, 0, H - 1), np.clip(xs + dx, 0, W - 1)
        f[ty, tx] = fl[ys, xs]
        return f
    A = fl.copy(); B = shifted(1); C = shifted(-1)
    return [A, B, A.copy(), C]


# ---------------------------------------------------------------- ciel et mer
def sky_sea(raw):
    """Horizon du brut = première rangée cyan sous le ciel pâle ; ciel -> [0, YH), mer -> [YH, H) au même facteur vertical."""
    hr = next(y for y in range(40, raw.shape[0] - 1)
              if raw[y, :, 0].mean() < 120 and raw[y - 1, :, 0].mean() >= 120)
    fy = YH / hr
    sky = np.array(Image.fromarray(raw[:hr].astype('uint8')).resize((W, YH), Image.NEAREST)).astype(int)
    n = int(math.ceil((H - YH) / fy)); src = raw[hr:hr + n]
    if len(src) < n:
        src = np.concatenate([src, np.repeat(src[-1:], n - len(src), 0)])
    sea = np.array(Image.fromarray(src.astype('uint8')).resize((W, H - YH), Image.NEAREST)).astype(int)
    return hr, fy, sky, sea


def glints(sea_full, sea_region):
    """Paillettes de la bande de l'horizon : pixels nettement plus clairs que leur voisinage, petits groupes."""
    l = lum(sea_full); zone = sea_region & (np.arange(H)[:, None] < YH + 40)
    sp = zone & (l > nd.median_filter(l, 7) + 22)
    lab, n = nd.label(sp); out = []
    for i, s in enumerate(nd.find_objects(lab)):
        ys, xs = np.nonzero(lab[s] == i + 1); ys += s[0].start; xs += s[1].start
        if len(ys) <= 8:
            out.append(([(int(y), int(x)) for y, x in zip(ys, xs)], hsh(int(ys.mean()), int(xs.mean()), 3) % GLINT_STEPS))
    return out


def glint_frames(gl, base_cols, white):
    frames = []
    for t in range(GLINT_STEPS):
        a = np.zeros((H, W, 4), 'uint8')
        for px, off in gl:
            lv = GLINT_LEVELS[(t + off) % GLINT_STEPS]
            for y, x in px:
                if lv:
                    a[y, x, :3] = base_cols[y, x] if lv == 1 else white; a[y, x, 3] = 255
        frames.append(a)
    return frames


# ---------------------------------------------------------------- houle (loi V24P04A)
def crest_sprites(sheet):
    fg = ~is_magenta(sheet)
    grp, n = nd.label(nd.binary_dilation(fg, iterations=14))
    boxes = []
    for i, s in enumerate(nd.find_objects(grp)):
        m = (grp[s] == i + 1) & fg[s]
        if m.sum() < 800:
            continue
        boxes.append((s, m))
    boxes.sort(key=lambda b: (b[0][0].start + b[0][0].stop) / 2)
    rows = []
    for b in boxes:
        cy = (b[0][0].start + b[0][0].stop) / 2
        if rows and abs(rows[-1][0] - cy) < 60:
            rows[-1][1].append(b)
        else:
            rows.append([cy, [b]])
    pal = palette_of(sheet[fg], 16)
    sprites = []
    for _, bs in rows[:4]:                           # 5e rangée (vague pleine) non utilisée
        bs.sort(key=lambda b: b[0][1].start)
        pair = []
        for s, m in bs[:2]:
            crop = sheet[s]; h_, w_ = m.shape
            size = (CREST_W, max(1, round(h_ * CREST_SCALE)))      # largeur de V24P04A, épaisseur selon la rangée
            pair.append(down_rgba(crop, m, size, pal))
        sprites.append(pair)
    return sprites


def swell_y(u):
    return YH + SWELL_D0 + SWELL_A * u + SWELL_B * u * u


def swell_rows():
    k = 0
    while swell_y(k) < H:
        k += 1
        if swell_y(k - 1) > 300:
            break
    return k


def swell_frames(sprites, sea_region, sea_rgb):
    """Crête k au cran s : profondeur u = k + (2s/12 mod 1) (V24P04A : 2 rangées par cycle), bas du sprite en y(u), colonnes tous les 96 px ; taille selon u,
    écume pleine / mince en alternance (cran + colonne), comme les deux états alternés de V24P04A. u = k + 2 au cran 12
    = crête k + 2 au cran 0 : la boucle est fermée par construction."""
    swell_sp = []
    for sp in sprites[0]:                             # houle naissante : ombre sombre seule
        s2 = sp.copy(); m = s2[..., 3] == 255; l = lum(s2[..., :3])
        thr = np.percentile(l[m], 35) if m.any() else 0; s2[m & (l > thr)] = 0; swell_sp.append(s2)
    K = swell_rows(); frames = []
    for s in range(SWELL_STEPS):
        a = np.zeros((H, W, 4), 'uint8')
        for k in range(K - 1, -1, -1):
            u = k + (SWELL_PASSES * s / SWELL_STEPS) % 1; y = int(round(swell_y(u)))   # une rangée neuve naît tous les 6 crans
            cls = sum(u >= b for b in SIZE_BOUNDS)      # 0 = houle, 1..4 = tailles
            for j in range(W // SWELL_PERIOD_X):
                v = (s + j) % 2
                sp = swell_sp[v] if cls == 0 else sprites[cls - 1][v]
                h_, w_ = sp.shape[:2]; x0 = j * SWELL_PERIOD_X + SWELL_PERIOD_X // 2 - w_ // 2
                ys, xs = np.nonzero(sp[..., 3] == 255)
                ty = ys + y - h_ + 1; tx = (xs + x0) % W; ok = (ty >= YH) & (ty < H)
                a[ty[ok], tx[ok]] = sp[ys[ok], xs[ok]]
            # ligne de houle continue sous les crêtes (V24P04A) : pas d'interstice entre deux crêtes d'une rangée
            row_sp = [swell_sp[0]] if cls == 0 else sprites[cls - 1]
            off = min(sp.shape[0] - 1 - int(np.nonzero((sp[..., 3] == 255).any(1))[0].max()) for sp in row_sp)
            yl = y - off
            if YH <= yl < H and u >= SIZE_BOUNDS[0]:                 # 1 px, la mer assombrie de 15 % (même teinte)
                xs_l = np.nonzero(a[yl, :, 3] == 0)[0]
                a[yl, xs_l, :3] = (sea_rgb[yl, xs_l] * SWELL_LINE).round().astype('uint8'); a[yl, xs_l, 3] = 255
        a[~sea_region] = 0
        frames.append(a)
    return frames


def reflet_dashes(sheet, idx):
    """Planche de reflets générée : colonne idx (0 lune, 1 aube, 2 crépuscule) -> traits (composantes) replacés sous l'astre.
    Hauteur de la colonne -> [YH + 1, YH + 1 + REFLET_SPAN] ; largeur x REFLET_SX ; épaisseur 1 px au loin, 2 px près ;
    les étincelles (composantes hautes) gardent leur forme au cinquième."""
    fg = ~is_magenta(sheet); cx_ = np.nonzero(fg.any(0))[0]
    groups = np.split(cx_, np.nonzero(np.diff(cx_) > 10)[0] + 1)
    g = groups[idx]; x0, x1 = int(g[0]), int(g[-1])
    sub, m = sheet[:, x0:x1 + 1], fg[:, x0:x1 + 1]
    rows = np.nonzero(m.any(1))[0]; ytop, ybot = int(rows.min()), int(rows.max()); axis = (x1 - x0) / 2
    pal = palette_of(sub[m], 16)
    lab, n = nd.label(m, structure=np.ones((3, 3)))
    dashes = []
    for i, sl in enumerate(nd.find_objects(lab)):
        mm = lab[sl] == i + 1
        if mm.sum() < 6:
            continue
        cy = (sl[0].start + sl[0].stop - 1) / 2; cx = (sl[1].start + sl[1].stop - 1) / 2
        v = (cy - ytop) / (ybot - ytop); h_, w_ = mm.shape
        if h_ > 18:                                   # étincelle en croix
            size = (max(3, round(w_ * 0.2)), max(3, round(h_ * 0.2))); thr = 0.3
        else:
            size = (max(1, round(w_ * REFLET_SX)), 1 if v < 0.45 else 2); thr = 0.35
        spr = down_rgba(sub[sl], mm, size, pal, thr)
        if not (spr[..., 3] == 255).any():
            continue
        dashes.append({'y': int(round(YH + 1 + v * REFLET_SPAN - size[1] / 2)), 'dx': (cx - axis) * REFLET_SX, 'spr': spr,
                       'ph': (hsh(idx, i, 11) % 1000) / 1000 * 2 * math.pi})
    return dashes, {'colonne_brut': [x0, x1], 'rangees_brut': [ytop, ybot], 'traits': len(dashes)}


def u_of_y(y):
    """Profondeur de houle u à la rangée y (inverse de swell_y ; prolongée en ligne droite au-dessus de u = 0)."""
    d = y - YH - SWELL_D0
    return d / SWELL_A if d < 0 else (-SWELL_A + math.sqrt(SWELL_A ** 2 + 4 * SWELL_B * d)) / (2 * SWELL_B)


def reflet_frames(dashes, xc, sea_region):
    """12 crans calés sur la houle : chaque trait oscille de A sin(phi), phi = 2 pi (2s/12 - u(y)) - la déformation descend
    vers le rivage avec les crêtes - et s'éteint brièvement quand sin(2 phi + phase propre) < -0,85. Boucle fermée."""
    frames = []
    for s in range(SWELL_STEPS):
        a = np.zeros((H, W, 4), 'uint8')
        for d in dashes:
            ph = 2 * math.pi * (SWELL_PASSES * s / SWELL_STEPS - u_of_y(d['y']))
            if math.sin(2 * ph + d['ph']) < -0.85:
                continue
            sp = d['spr']; h_, w_ = sp.shape[:2]; amp = 1 + (d['y'] - YH) / 45
            x0 = int(round(xc + d['dx'] + amp * math.sin(ph) - w_ / 2))
            ys, xs = np.nonzero(sp[..., 3] == 255); ty, tx = ys + d['y'], xs + x0
            ok = (ty >= YH) & (ty < H) & (tx >= 0) & (tx < W)
            a[ty[ok], tx[ok]] = sp[ys[ok], xs[ok]]
        a[~sea_region] = 0
        frames.append(a)
    return frames


def light_crests(frames, refl, cols):
    """Les crêtes qui passent dans la colonne de reflet prennent les couleurs de l'astre (cœur / milieu)."""
    u = np.zeros((H, W), bool)
    for f in refl:
        u |= f[..., 3] == 255
    inside = np.zeros((H, W), bool)
    for y in range(H):
        xs = np.nonzero(u[max(0, y - 3):y + 4].any(0))[0]
        if len(xs):
            inside[y, xs.min():xs.max() + 1] = True
    out = []
    for f in frames:
        g = f.copy(); m = (g[..., 3] == 255) & inside; l = lum(g[..., :3])
        g[m & (l > 200), :3] = cols[0]; g[m & (l > 140) & (l <= 200), :3] = cols[1]
        out.append(g)
    return out


# ---------------------------------------------------------------- ondes (lignes de houle peintes dans la plaque, animées)
def sea_lines(plate, sea_region, skip):
    """Motifs fins peints par le générateur dans la plaque (lignes de houle ondulées, plaques de reflets clairs) : écart de
    luminance à la médiane verticale sur 2 ONDES_R + 1 px (qui efface une ligne de 1 à 3 px mais garde les marches entre
    bandes et leur tramage), lissé en x ; seuil ONDES_T, sous la rangée ONDES_Y0 (au-dessus : bande de l'horizon et ses
    paillettes, animées à part). Chaque pixel retiré est remplacé par le pixel réel de sa colonne (hors motif) dont la
    luminance est la plus proche de la médiane locale de sa rangée : le grain de la plaque est gardé, sans tache."""
    l = lum(plate); R_ = ONDES_R
    ll = np.where(sea_region, l, np.nan); st = []
    for d in range(-R_, R_ + 1):
        r_ = np.full_like(ll, np.nan)
        if d >= 0:
            r_[d:] = ll[:H - d]
        else:
            r_[:d] = ll[-d:]
        st.append(r_)
    with warnings.catch_warnings():
        warnings.simplefilter('ignore'); med = np.nanmedian(np.stack(st), 0)
    hp = np.where(sea_region, l - np.nan_to_num(med), 0); hps = nd.gaussian_filter1d(hp, 3, axis=1)
    F = (np.abs(hps) > ONDES_T) & (np.abs(hp) > ONDES_T / 2) & sea_region & ~skip
    F[:ONDES_Y0] = False
    F = nd.binary_closing(F, structure=np.ones((1, 5))) & sea_region & ~skip; F[:ONDES_Y0] = False
    lab, n = nd.label(F, structure=np.ones((3, 3))); sizes = nd.sum(F, lab, range(1, n + 1))
    good = 1 + np.nonzero(sizes >= ONDES_MIN)[0]; keep = np.isin(lab, good)
    rowmed = np.zeros((H, W))
    for y in range(ONDES_Y0, H):
        ok = sea_region[y] & ~keep[y]
        if ok.sum() < 8:
            continue
        v = np.where(ok, l[y], np.nan); pad = np.pad(v, 48, constant_values=np.nan)
        win = np.lib.stride_tricks.sliding_window_view(pad, 97)
        with warnings.catch_warnings():
            warnings.simplefilter('ignore'); rowmed[y] = np.nan_to_num(np.nanmedian(win, 1), nan=np.nanmedian(v))
    clean = plate.copy()
    for y, x in zip(*np.nonzero(keep)):
        best = None
        for d in range(-R_ - 4, R_ + 5):
            yy = y + d
            if YH <= yy < H and sea_region[yy, x] and not keep[yy, x]:
                c = abs(l[yy, x] - rowmed[y, x]) + 0.3 * abs(d)
                if best is None or c < best[0]:
                    best = (c, yy)
        if best:
            clean[y, x] = plate[best[1], x]
    comps = []
    for i, sl in enumerate(nd.find_objects(np.where(keep, lab, 0))):
        if sl is None:
            continue
        ys, xs = np.nonzero(lab[sl] == i + 1); ys += sl[0].start; xs += sl[1].start
        cy = float(ys.mean()); w_ = int(xs.max() - xs.min() + 1)
        comps.append({'ys': ys, 'xs': xs, 'y': cy, 'u': u_of_y(cy), 'ligne': w_ >= ONDES_LINE_W,
                      'ph': (hsh(int(cy), int(xs.mean()), 17) % 1000) / 1000 * 2 * math.pi})
    return keep, clean, comps


def ondes_frames(comps, cols, sea_region):
    """12 crans calés sur la houle (V24P04A, 2 rangées par cycle) : chaque motif décrit l'orbite de l'eau sous la houle,
    dx = Ah cos(phi), dy = Av sin(phi), phi = 2 pi (2s/12 - u(y)) - l'ondulation descend vers le rivage avec les crêtes ;
    amplitude croissante vers le rivage (perspective). Les plaques claires (pas les lignes) s'éteignent brièvement comme
    les traits de reflet. Les lignes qui touchent les bords reviennent par l'autre bord (x mod 768). Boucle fermée : phi(12) = phi(0) + 4 pi."""
    frames = []
    for s in range(SWELL_STEPS):
        a = np.zeros((H, W, 4), 'uint8')
        for c in sorted(comps, key=lambda c: c['y']):
            ph = 2 * math.pi * (SWELL_PASSES * s / SWELL_STEPS - c['u'])
            if not c['ligne'] and math.sin(2 * ph + c['ph']) < -0.85:
                continue
            dd = c['y'] - YH; ah = 1 + dd / ONDES_AH; av = 0.5 + dd / ONDES_AV
            dx, dy = int(round(ah * math.cos(ph))), int(round(av * math.sin(ph)))
            ty, tx = c['ys'] + dy, (c['xs'] + dx) % W; ok = (ty >= YH) & (ty < H)
            a[ty[ok], tx[ok], :3] = cols[c['ys'][ok], c['xs'][ok]]; a[ty[ok], tx[ok], 3] = 255
        a[~sea_region] = 0
        frames.append(a)
    return frames



# ---------------------------------------------------------------- nuages
def round_flat(raw, r):
    """Sommet plat de plus de CLOUD_FLAT_MIN px du brut = nuage rogné par le générateur : ses colonnes descendent
    en dôme parabolique, le liseré clair du sommet descend avec elles."""
    raw = raw.copy(); fg = ~is_magenta(raw); Wr = raw.shape[1]
    tops = np.array([int(np.argmax(fg[:, x])) for x in range(Wr)])
    runs, s0 = [], 0
    for x in range(1, Wr + 1):
        if x == Wr or tops[x] != tops[s0]:
            if x - s0 >= CLOUD_FLAT_MIN:                   # en px du brut, pour tous les bancs (B, plus fin, est plus réduit)
                runs.append((s0, x - 1, int(tops[s0])))
            s0 = x
    for x0, x1, ty in runs:
        c = (x0 + x1) / 2; hw = (x1 - x0) / 2 + 6
        for x in range(max(0, int(c - hw)), min(Wr, int(c + hw) + 1)):
            d = int(round(CLOUD_DOME * ((x - c) / hw) ** 2))
            t = int(tops[x]); d = ty + d - t          # le sommet descend jusqu'au dôme, jamais plus bas
            if d <= 0:
                continue
            n = int(round(80 / r)); col, cm = raw[t:t + n, x].copy(), fg[t:t + n, x].copy(); n = len(col)
            raw[t:t + d, x] = (255, 0, 255); fg[t:t + d, x] = False
            raw[t + d:t + n, x] = col[:n - d]; fg[t + d:t + n, x] = cm[:n - d]
    return raw, fg, runs


def bank_band(raw, r):
    """Banc du haut d'un brut : du premier pixel de nuage jusqu'à CLOUD_BASE_PX (espace final) dans la base pleine."""
    raw, fg, runs = round_flat(raw, r)
    top = int(np.nonzero(fg.any(1))[0].min())
    full = next(y for y in range(top, raw.shape[0]) if fg[y].all())
    bottom = min(raw.shape[0] - 1, full + int(round(CLOUD_BASE_PX / (CLOUD_S0 * r))))
    return raw[top:bottom + 1], fg[top:bottom + 1], runs, (top, full, bottom)


def _piece(band, m, x0, x1, sc, pal, hh):
    """Colonnes [x0, x1) du banc réduites à l'échelle sc, posées en bas d'une bande de hauteur hh."""
    x0, x1 = max(0, int(round(x0))), min(band.shape[1], int(round(x1)))
    size = (max(1, int(round((x1 - x0) * sc))), max(1, int(round(band.shape[0] * sc))))
    p = down_rgba(band[:, x0:x1], m[:, x0:x1], size, pal)
    out = np.zeros((hh, p.shape[1], 4), 'uint8'); out[hh - p.shape[0]:] = p[-hh:]
    return out


def _tops(p):
    al = p[..., 3] == 255
    return np.where(al.any(0), al.argmax(0), p.shape[0]).astype(float)


def cloud_strip(raws):
    """Bande périodique de CLOUD_PERIOD px (= largeur de l'écran : aucun nuage répété à l'écran) faite de bancs générés
    différents mis bout à bout (CLOUD_BANKS, en boucle). Chaque banc : sommets plats arrondis, échelle relative (le banc B,
    plus haut, est ramené à la hauteur des sommets du banc A), colonnes utilisables (hors copie du générateur). Raccords :
    colonnes où la silhouette du banc suivant prolonge celle du banc précédent (écart des sommets sur 8 px + écart de
    teinte + marche entre les deux colonnes jointes), puis fondu des teintes seules sur CLOUD_TINT colonnes ; l'ensemble est remis à l'échelle pour faire 768 px."""
    bands, info = [], {'bancs': []}
    ref = bank_band(raws[CLOUD_BANKS[1][0]], 1.0)[3]
    for name, r, cols in CLOUD_BANKS:
        if r is None:                                 # sommets ramenés à la hauteur de ceux du banc A
            t0, f0, _ = bank_band(raws[name], 1.0)[3]
            r = (ref[1] - ref[0]) / (f0 - t0)
        band, m, runs, rows = bank_band(raws[name], r)
        bands.append((name, r, cols, band, m))
        info['bancs'].append({'brut': name, 'echelle_relative': round(r, 4), 'colonnes_utilisables': list(cols),
                              'rangees_brut': [rows[0], rows[2]], 'sommets_arrondis': [list(x) for x in runs]})
    pal = palette_of(np.concatenate([b[3][b[4]] for b in bands]), 24)
    hh0 = max(int(round(b[3].shape[0] * CLOUD_S0 * b[1])) for b in bands)
    pre = [_piece(b[3], b[4], 0, b[3].shape[1], CLOUD_S0 * b[1], pal, hh0) for b in bands]
    n = len(bands); K = 8; joints = []
    for i in range(n):
        j = (i + 1) % n; pi, pj = pre[i], pre[j]; si = CLOUD_S0 * bands[i][1]; sj = CLOUD_S0 * bands[j][1]
        ci, cj = bands[i][2], bands[j][2]; wi = int(ci[1] * si); wj0, wj1 = int(ci[0] * si), 0
        lo_i, hi_i = int(ci[0] * si + (1 - CLOUD_EDGE) * (ci[1] - ci[0]) * si), min(pi.shape[1], int(round(bands[i][3].shape[1] * si))) - CLOUD_TINT
        hi_i = min(hi_i, int(ci[1] * si))
        lo_j, hi_j = int((cj[0] + 8) * sj), int(cj[0] * sj + CLOUD_EDGE * (cj[1] - cj[0]) * sj)   # pas contre le bord du brut
        ti, tj = _tops(pi), _tops(pj); ai, aj = pi[..., :3].astype(int), pj[..., :3].astype(int)
        best = None
        for e in range(lo_i, hi_i):
            for s in range(lo_j, hi_j):
                c = (np.abs(ti[e:e + K] - tj[s:s + K]).mean() + np.abs(ai[:, e:e + K] - aj[:, s:s + K]).mean() / 20
                     + np.abs(ti[e - 1] - tj[s]) + np.abs(ai[:, e - 1] - aj[:, s]).mean() / 20)   # et la marche entre les deux colonnes jointes
                c += 10 * ((ti[e - 1] < min(ti[e - 2], tj[s]) - 1) + (tj[s] < min(ti[e - 1], tj[s + 1]) - 1))   # colonne isolée au raccord
                if best is None or c < best[0]:
                    best = (c, e, s)
        joints.append(best)
    lens = [joints[i][1] - joints[i - 1][2] for i in range(n)]      # début du banc i = raccord (i-1 -> i)
    f = CLOUD_PERIOD / sum(lens)
    widths = [int(round(L * f)) for L in lens]; widths[-1] += CLOUD_PERIOD - sum(widths)
    hh = max(int(round(b[3].shape[0] * CLOUD_S0 * b[1] * f)) for b in bands)
    parts = []
    for i, b in enumerate(bands):
        s0 = CLOUD_S0 * b[1]; x0 = joints[i - 1][2] / s0; x1 = joints[i][1] / s0; sc = widths[i] / (x1 - x0)
        p = _piece(b[3], b[4], x0, x1 + CLOUD_TINT / sc, sc, pal, hh)
        if p.shape[1] < widths[i] + CLOUD_TINT:
            p = np.concatenate([p, np.zeros((hh, widths[i] + CLOUD_TINT - p.shape[1], 4), 'uint8')], 1)
        parts.append(p[:, :widths[i] + CLOUD_TINT].astype(float))
        info['bancs'][i]['coupe_brut'] = [int(round(x0)), int(round(x1))]; info['bancs'][i]['largeur_px'] = widths[i]
        info['bancs'][i]['ecart_raccord_suivant'] = round(float(joints[i][0]), 2)
    out = np.concatenate([p[:, :w] for p, w in zip(parts, widths)], 1)
    x = 0
    for i in range(n):                                 # raccord (i-1 -> i) au début du banc i : teintes seules
        prev = parts[i - 1]; wp = widths[i - 1]
        for k in range(CLOUD_TINT):
            w = (k + 0.5) / CLOUD_TINT; cur = out[:, x + k]; o = prev[:, wp + k]
            both = (cur[:, 3] > 0) & (o[:, 3] > 0)
            cur[both, :3] = w * cur[both, :3] + (1 - w) * o[both, :3]
        x += widths[i]
    res = np.zeros(out.shape, 'uint8'); al = out[..., 3] > 127
    res[al, :3] = nearest(out[al, :3], pal); res[al, 3] = 255
    res[-1, :, :3] = np.where(res[-1, :, 3:] == 255, res[-1, :, :3], res[-2, :, :3]); res[-1, :, 3] = 255   # base pleine
    info.update({'taille_bande': list(res.shape[1::-1]), 'echelle': round(CLOUD_S0 * f, 4)})
    return res, pal, info


def cloud_frames(strip, hidden):
    h = strip.shape[0]; frames = []
    for t in range(CLOUD_PHASES):
        a = np.zeros((H, W, 4), 'uint8')
        a[YH - h:YH] = np.tile(np.roll(strip, t * CLOUD_PAS, axis=1), (1, W // CLOUD_PERIOD, 1))
        a[hidden] = 0
        frames.append(a)
    return frames


# ---------------------------------------------------------------- montagne
def mountain_layer(raw):
    fg = ~is_magenta(raw)
    fx = raw.shape[1] / ((MOUNT_CROP[2] - MOUNT_CROP[0]))            # brut généré -> brut ZRV1
    x0 = MOUNT_CROP[0] * V1_SCALE - V1_CROP_X; f = V1_SCALE / fx
    size = (round(raw.shape[1] * f), YH)
    pal = palette_of(raw[fg], 32)
    sp = down_rgba(raw, fg, size, pal)
    a = np.zeros((H, W, 4), 'uint8'); xi = int(round(x0))
    a[:YH, xi:xi + size[0]] = sp
    m = a[..., 3] == 255
    # pas de coupe verticale aux bords : on prolonge la pente de chaque flanc (droite ajustée sur la silhouette)
    rows = [y for y in range(YH) if m[y].any()]
    left = np.array([np.nonzero(m[y])[0].min() for y in rows]); right = np.array([np.nonzero(m[y])[0].max() for y in rows])
    ys = np.array(rows)
    for side, xsd, lim in (('g', left, xi), ('d', right, xi + size[0] - 1)):
        cut = np.nonzero(np.abs(xsd - lim) <= 1)[0]              # rangées où le brut touche le bord du cadre
        if not len(cut):
            continue
        c0 = cut.min(); fit = slice(max(0, c0 - 30), c0)
        pa = np.polyfit(ys[fit], xsd[fit], 1)
        src = a.copy()
        for y in ys[c0:]:
            xl = int(round(np.polyval(pa, y)))
            if side == 'g':                      # le flanc descend jusqu'à l'horizon : texture du pied recopiée en miroir
                for x in range(max(0, xl), lim):
                    a[y, x] = src[y, 2 * lim - x]
            else:
                for x in range(lim + 1, min(W, xl + 1)):
                    a[y, x] = src[y, 2 * lim - x]
    return a, {'origine_x': round(x0, 2), 'facteur': round(f, 5), 'taille': list(size)}


def astre_sprite(sheet, idx, d):
    fg = ~is_magenta(sheet); lab, n = nd.label(fg)
    objs = sorted([(s, i + 1) for i, s in enumerate(nd.find_objects(lab)) if (lab[s] == i + 1).sum() > 5000],
                  key=lambda o: o[0][1].start)
    s, i = objs[idx]; m = lab[s] == i
    return down_rgba(sheet[s], m, (d, d), palette_of(sheet[s][m], 16))


# ---------------------------------------------------------------- couleurs d'aube et de nuit (bruts ZRV1)
def amb_samples(amb):
    a = rgb(AMB_RAW[amb]); l = lum(a)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    col = AMB_ASTRE[amb][0]                           # colonne du reflet dans le brut ZRV1
    refl = np.abs(xx - col) < 130
    blue = (a[..., 2] > a[..., 0] + 25) if amb == 'nuit' else np.ones(l.shape, bool)       # ciel d'aube rose et violet
    astre = AMB_ASTRE[amb]                                                              # disque de l'astre exclu
    astre = (xx - astre[0]) ** 2 + (yy - astre[1]) ** 2 <= astre[2] ** 2
    sky = (yy < {'nuit': 60, 'aube': 78, 'crepuscule': 80}[amb]) & blue & ~astre & (l < 235) & (nd.median_filter(l, 5) > l - 25)
    sea = (yy > 190) & (yy < 420) & ~refl & (l < 150) & ((a[..., 2] > a[..., 0] + 40) if amb == 'nuit' else (a[..., 2] >= a[..., 1]))   # sans reflets dorés
    crest = (yy > 190) & (yy < 420) & ~refl & (l >= 150)
    cloud = (yy > 75) & (yy < 175) & ~((xx > 430) & (xx < 780)) & (l > 90)
    mount = (yy > 30) & (yy < 150) & (xx > 470) & (xx < 740) & ~astre & ((a[..., 2] >= a[..., 0]) if amb == 'nuit' else True)
    s = {k: a[v] for k, v in {'ciel': sky, 'mer': sea, 'cretes': crest, 'nuages': cloud, 'montagne': mount}.items()}
    if len(s['cretes']) < 300:
        s['cretes'] = a[(yy > 190) & (yy < 420) & ~refl][np.argsort(l[(yy > 190) & (yy < 420) & ~refl])[-3000:]]
    assert all(len(v) > 200 for v in s.values()), {k: len(v) for k, v in s.items()}
    return {k: v.astype(int) for k, v in s.items()}


# ---------------------------------------------------------------- étoiles (ZRV1)
def star_state(off, t):
    u = (t + off) % STAR_PHASES
    return 'plein' if 4 <= u <= 11 else ('coeur' if u in (2, 3, 12, 13) else 'eteint')


def star_frames(stars):
    frames = []
    for t in range(STAR_PHASES):
        a = np.zeros((H, W, 4), 'uint8')
        for px, core, off in stars:
            st = star_state(off, t)
            for y, x, r, g, b in (px if st == 'plein' else core if st == 'coeur' else []):
                a[y, x] = (r, g, b, 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- ORA, Ground
def write_ora(path, layers, title):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name=title)
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


def ground(amb, stack, blocked, markers, gfx, tpl):
    tpl = json.loads(json.dumps(tpl)); o = tpl['Object']; gw, gh = W // 8, H // 8; layers, banks = [], []
    for idx, title, frames, ticks in stack:
        bank = gfx.TileBank(f'{PFX}{AMB[amb]}_{idx:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0); bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs
        layers.append(gfx.layer(f'{idx:02d} {title}', gw, gh, cell, ticks)); banks.append(bank)
    layers.append(gfx.layer(f'{len(ORDER):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': f'Zone de reveil V2 - prairie face a l ocean ({amb})', 'LocalTexts': {}},
             AssetName=ASSET[amb], Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment=f'PMDO 0.8.12. Zone de reveil V2 ({amb}). Prairie de ZRV1 ; mer, montagne, nuages et ciel sur des calques '
                     'separes, rendu genere reference (V24P04A pour la mer). Houle 12 x 10 ticks et scintillement 16 x 4 ticks '
                     '(lois de V24P04A), nuages 256 x 8 ticks derriere la montagne, fleurs 4 x 12 ticks (GIF Sky Peak), reflet '
                     'de l astre 12 x 10 ticks. Collisions de ZRV1. Aucun warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk(n, p) for n, p in markers.items()]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET[amb]}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET[amb]}/init.lua',
             f'-- {ASSET[amb]} : zone de reveil V2 ({amb}), base d edition, aucun warp.\n'
             f'-- Marqueurs : reveil (au bord de la prairie, face a l ocean), entrance (sud).\n'
             f'local {ASSET[amb]} = {{}}\nreturn {ASSET[amb]}\n'.encode())
    return {b.name: len(b.data) for b in banks}


def finish_stage(tools):
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Zone de reveil V2 - prairie face a l ocean (jour, aube, nuit) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : premiere scene. Prairie fleurie de Sky Peak (fleurs animees) au bord d'un promontoire plat ; en contrebas l'ocean vu de cote, houle qui roule vers la prairie et horizon qui scintille (lois de V24P04A de PMD Ciel) ; la montagne posee sur l'horizon, les nuages qui defilent derriere elle ; reflet anime de la lune (nuit) et du soleil (aube). Trois Grounds : jour, aube, nuit. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- construction des calques
def make_all():
    """Calques et animations des trois ambiances (dictionnaires nom -> (images, ticks)) + mesures."""
    info = {}
    meadow = meadow_mask(); sea_region = (np.arange(H)[:, None] >= YH) & ~meadow
    v1_sea = np.array(Image.open(V1OUT / 'masques/ZRV1_masque_mer.png')) > 127
    info['mer_identique_zrv1'] = bool((v1_sea == sea_region).all())
    # ciel et mer
    raw_sm = rgb(RAW / 'ciel_mer_jour.png')
    hr, fy, sky, sea = sky_sea(raw_sm)
    info['ciel_mer'] = {'horizon_brut': int(hr), 'facteur_vertical': round(fy, 4), 'facteur_horizontal': round(W / raw_sm.shape[1], 4)}
    sea_full = np.zeros((H, W, 3), int); sea_full[YH:] = sea
    gl = glints(sea_full, sea_region)
    glmask = np.zeros((H, W), bool)
    for px, _ in gl:
        for y, x in px:
            glmask[y, x] = True
    plate_pal = np.unique(sea_full[sea_region & ~glmask], axis=0)
    med = np.stack([nd.median_filter(sea_full[..., c], 7) for c in range(3)], -1)
    plate = sea_full.copy(); plate[glmask] = nearest(med[glmask], plate_pal)
    plate_full = plate.copy()                                        # plaque avec ses lignes (sert au recoloriage des ambiances)
    okeep, plate, ocomps = sea_lines(plate_full, sea_region, glmask)
    info['ondes'] = {'pixels': int(okeep.sum()), 'motifs': len(ocomps), 'lignes': sum(c['ligne'] for c in ocomps),
                     'plaques_claires': sum(not c['ligne'] for c in ocomps),
                     'rangees': [int(np.nonzero(okeep.any(1))[0].min()), int(np.nonzero(okeep.any(1))[0].max())]}
    info['scintillement'] = {'paillettes': len(gl), 'pixels': int(glmask.sum())}
    day = {}
    day['ciel'] = np.concatenate([np.dstack([sky, np.full((YH, W), 255)]), np.zeros((H - YH, W, 4), int)]).astype('uint8')
    day['mer'] = np.zeros((H, W, 4), 'uint8'); day['mer'][sea_region, :3] = plate[sea_region]; day['mer'][sea_region, 3] = 255
    white = sea_full[glmask][np.argmax(lum(sea_full[glmask]))] if glmask.any() else np.array([255, 255, 255])
    # montagne (ZRV1), nuages derrière
    mnt, info['montagne'] = mountain_layer(rgb(RAW / 'montagne_jour.png'))
    day['montagne'] = mnt; mmask = mnt[..., 3] == 255
    info['montagne']['base_sur_horizon'] = bool(mmask[YH - 1].any())
    strip, cpal, info['nuages'] = cloud_strip({k: rgb(RAW / k) for k, _, _ in CLOUD_BANKS})
    # houle
    sprites = crest_sprites(rgb(RAW / 'cretes_jour.png'))
    info['cretes'] = {'tailles_px': [[list(s.shape[1::-1]) for s in pair] for pair in sprites]}
    # fleurs : têtes (jour)
    fl_day = v1_layer('jour', 'fleurs'); lab, nheads = flower_heads(fl_day)
    info['fleurs'] = {'tetes': int(nheads)}
    # étoiles de ZRV1 (nuit), gardées si elles restent dans le ciel visible
    v1m = json.loads((V1OUT / 'manifest.json').read_text())
    sc = v1m['ambiances']['nuit']['scintillements']
    ast = np.zeros((H, W), bool)
    yy, xx = np.mgrid[:H, :W]; cx, cy = ASTRE['nuit']['c']; ast = (xx - cx) ** 2 + (yy - cy) ** 2 <= (ASTRE['nuit']['d'] / 2 + 3) ** 2
    cloud_top = YH - strip.shape[0]
    stars = []
    for px, core, off in zip(sc['pixels'], sc['coeurs'], sc['decalages']):
        if all(y < cloud_top and not mmask[y, x] and not ast[y, x] for y, x, *_ in px):
            stars.append(([tuple(p) for p in px], [tuple(p) for p in core], off))
    info['etoiles'] = {'zrv1': len(sc['pixels']), 'gardees': len(stars)}
    astres = rgb(RAW / 'astres.png'); refl_sheet = rgb(RAW / 'reflets_astres.png')
    out = {}
    for amb in AMB:
        L = {}
        L['sol_complet'] = ([v1_layer(amb, 'sol_complet')], 60)
        for k in ('herbe', 'chemin', 'rochers', 'buissons'):
            L[k] = ([v1_layer(amb, k)], 60)
        L['fleurs'] = (flower_frames(v1_layer(amb, 'fleurs'), lab, nheads), FLOWER_TICKS)
        if amb == 'jour':
            ciel, merl, mont, strip_a, spr = day['ciel'], day['mer'], day['montagne'], strip, sprites
            ocols = plate_full
            gcols, gwhite = sea_full, white
        else:
            S = amb_samples(amb)
            ciel = sky_gradient(day['ciel'], amb)
            full = np.zeros((H, W, 4), 'uint8'); full[sea_region, :3] = plate_full[sea_region]; full[sea_region, 3] = 255
            full_r = recolor_rank(full, S['mer'])                    # rang calculé sur la plaque avec ses lignes, appliqué aux deux calques
            cmap = {tuple(k): tuple(v) for k, v in zip(full[sea_region, :3].tolist(), full_r[sea_region, :3].tolist())}
            merl = day['mer'].copy(); mm = merl[..., 3] == 255
            merl[mm, :3] = np.array([cmap[tuple(c)] for c in merl[mm, :3].tolist()], 'uint8')
            ocols = full_r[..., :3].astype(int)
            mont = recolor_rank(day['montagne'], S['montagne']); strip_a = recolor_rank(strip, S['nuages'])
            spr = [[recolor_rank(s, S['cretes']) for s in pair] for pair in sprites]
            glay = np.zeros((H, W, 4), 'uint8'); glay[glmask, :3] = sea_full[glmask]; glay[glmask, 3] = 255
            glay = recolor_rank(glay, S['cretes']); gcols = glay[..., :3].astype(int)
            gwhite = S['cretes'][np.argmax(lum(S['cretes']))]
        L['ciel'] = ([ciel], 60); L['mer'] = ([merl], 60); L['montagne'] = ([mont], 60)
        L['nuages'] = (cloud_frames(strip_a, mont[..., 3] == 255), CLOUD_TICKS)
        L['ondes'] = (ondes_frames(ocomps, ocols, sea_region), SWELL_TICKS)
        L['scintillement'] = (glint_frames(gl, gcols, gwhite), GLINT_TICKS)
        sw = swell_frames(spr, sea_region, merl[..., :3].astype(float))
        if amb in ASTRE:
            A = ASTRE[amb]; sp = astre_sprite(astres, A['sprite'], A['d'])
            if amb == 'crepuscule':                                  # soleil couchant : couleurs du soleil du brut
                ra = rgb(AMB_RAW[amb]); cxr, cyr, rr = AMB_ASTRE[amb]; yy_, xx_ = np.mgrid[:ra.shape[0], :ra.shape[1]]
                disc = ((xx_ - cxr) ** 2 + (yy_ - cyr) ** 2 <= (rr - 8) ** 2) & (ra[..., 0] > 200) & (ra[..., 2] < 150)
                smp = ra[disc]; smp = smp[np.argsort(lum(smp))]; r0 = A['d'] / 2 - 0.5
                yy2, xx2 = np.mgrid[:A['d'], :A['d']]; rn = np.hypot(yy2 - r0, xx2 - r0) / (A['d'] / 2)
                ring = np.clip((rn * 5).astype(int), 0, 4)             # 5 anneaux : cœur clair -> bord rouge
                qs = [0.72, 0.64, 0.55, 0.46, 0.36]
                m_ = sp[..., 3] == 255
                for k_ in range(5):
                    sp[m_ & (ring == k_), :3] = smp[int(qs[k_] * (len(smp) - 1))]
            al = np.zeros((H, W, 4), 'uint8'); x0, y0 = A['c'][0] - A['d'] // 2, A['c'][1] - A['d'] // 2
            al[y0:y0 + A['d'], x0:x0 + A['d']] = sp
            L['astre'] = ([al], 60)
            dashes, rinfo = reflet_dashes(refl_sheet, REFLET_COL[amb])
            rf = reflet_frames(dashes, A['c'][0], sea_region)
            L['reflet'] = (rf, SWELL_TICKS)
            rpx = np.concatenate([d['spr'][d['spr'][..., 3] == 255][:, :3] for d in dashes]).astype(int); lr = lum(rpx)
            core = rpx[np.argsort(lr)[int(len(lr) * 0.95)]]; mid = rpx[np.argsort(lr)[int(len(lr) * 0.6)]]
            sw = light_crests(sw, rf, (core, mid))
            info.setdefault('reflet', {})[amb] = {'x': A['c'][0], **rinfo, 'couleurs': [c.tolist() for c in (core, mid)]}
        if amb == 'nuit':
            L['etoiles'] = (star_frames(stars), STAR_TICKS)
        L['houle'] = (sw, SWELL_TICKS)
        L['ecume'] = (v1_frames(amb, 'ecume', 8, 10), 10)             # écume de ZRV1 (s01p02a palette 8, 10 x 10 ticks)
        L['bulles'] = (v1_frames(amb, 'bulles', 9, 24), 5)            # bulles de ZRV1 (24 x 5 ticks)
        out[amb] = L
    return out, info, meadow, sea_region, strip


def scene(L, tick):
    im = Image.new('RGBA', (W, H))
    for nm in ORDER:
        if nm in L:
            fr, tk = L[nm]; im.alpha_composite(Image.fromarray(fr[(tick // tk) % len(fr)]))
    return im


def build(apercu=False):
    out, info, meadow, sea_region, strip = make_all()
    if apercu:
        d = Path('/tmp/zrv2'); d.mkdir(exist_ok=True)
        for amb, L in out.items():
            for tk in (0, 30, 60):
                scene(L, tk).save(d / f'{amb}_t{tk:03d}.png')
        mont = Image.new('RGB', (384 * 3, 180 * 4))                # les 12 crans de la mer (moitié gauche), comme V24P04A
        for i in range(SWELL_STEPS):
            mont.paste(scene(out['jour'], i * SWELL_TICKS).crop((0, YH - 10, 384, YH + 170)), ((i % 3) * 384, (i // 3) * 180))
        mont.save(d / 'mer_12_crans.png')
        print(json.dumps(info, indent=1, ensure_ascii=False)[:3000]); return
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    esn1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    if STAGE.exists():
        shutil.rmtree(STAGE)
    # accès : celui de ZRV1
    v1m = json.loads((V1OUT / 'manifest.json').read_text())
    walk = np.array(Image.open(V1OUT / 'masques/ZRV1_masque_praticable.png')) > 127
    blocked = walk.reshape(H // 8, 8, W // 8, 8).__invert__().mean((1, 3)) > 0.25
    entry, reveil = v1m['access']['entry_px'], v1m['access']['reveil_px']
    reach, explored = esn1.reachable(blocked, (entry[1] // 8, entry[0] // 8), (reveil[1] // 8, reveil[0] // 8))
    assert reach
    markers = {'reveil': reveil, 'entrance': entry}
    for nm, m in (('prairie', meadow), ('mer', sea_region)):
        Image.fromarray((m * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{nm}.png')
    Image.fromarray(strip).save(OUT / 'masques' / f'{PFX}_jour_nuages_bande.png')
    tpl_zip = zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip')
    tpl = json.loads(tpl_zip.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    report, counts = {}, {}
    for amb, L in out.items():
        layer_list, stack = [], []
        for i, nm in enumerate(ORDER):
            if nm not in L:
                continue
            frames, ticks = L[nm]
            if len(frames) > 1:
                d = OUT / 'animation' / amb / nm; d.mkdir(parents=True, exist_ok=True)
                for t, fr in enumerate(frames):
                    save_png(fr, d / f'{PFX}{AMB[amb]}_{i:02d}_{nm}_f{t:03d}.png')
                layer_list.append({'index': i, 'nom': nm, 'file': f'animation/{amb}/{nm}/{PFX}{AMB[amb]}_{i:02d}_{nm}_fNNN.png',
                                   'phases': len(frames), 'ticks': ticks})
            else:
                d = OUT / 'calques' / amb; d.mkdir(parents=True, exist_ok=True)
                save_png(frames[0], d / f'{PFX}{AMB[amb]}_{i:02d}_{nm}.png')
                layer_list.append({'index': i, 'nom': nm, 'file': f'calques/{amb}/{PFX}{AMB[amb]}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
            stack.append((i, nm.replace('_', ' ') + (f' {len(frames)} phases' if len(frames) > 1 else ''), frames, ticks))
        step = 8
        scenes = [scene(L, tk) for tk in range(0, 480, step)]
        scenes[0].save(OUT / 'review' / f'{PFX}_{amb}_scene_t000.png')
        scenes[0].save(OUT / 'review' / f'{PFX}_{amb}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                       duration=round(step * 1000 / 60), loop=0, quality=90, method=4)
        if amb == 'jour':
            col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
            for y, x in zip(*np.nonzero(blocked)):
                dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
            for (qx, qy), c in ((entry, (255, 230, 40, 255)), (reveil, (60, 220, 255, 255))):
                dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
            col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
        write_ora(OUT / f'{PFX}_zone_reveil_{amb}_calques.ora',
                  {f'{i:02d}_{nm}' + ('_f000' if len(L[nm][0]) > 1 else ''): L[nm][0][0] for i, nm in enumerate(ORDER) if nm in L},
                  f'Zone de reveil ZRV2 ({amb})')
        counts.update(ground(amb, stack, blocked, markers, gfx, tpl))
        report[amb] = {'layers': layer_list}
    finish_stage(tools)
    manifest = {
        'lot': 'zone_reveil_prairie_horizon_v2', 'prefix': PFX, 'prefixes_banques': {k: PFX + v for k, v in AMB.items()},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8], 'horizon_y': YH,
        'demande': 'ZRV2 : mer comme V24P04A (houle qui roule, horizon qui scintille), zone multicalque (mer, ciel, nuages, '
                   'montagne separes), montagne raccordee a l horizon, nuages de la mer de nuages animes (pas de nuages ajoutes), '
                   'fleurs animees comme Sky Peak, reflet anime de la lune ; garder le layout de ZRV1, profondeur mer -> montagne -> nuages ; '
                   'puis (ensemble valide) : reflets de la lune et du crepuscule passes au generateur, nuages sans rognure, vagues '
                   'sans interstices, ajouter un crepuscule ; ecume et bulles de ZRV1 gardees ; puis : corriger les nuages (le banc de 256 px '
                   'revenait 3 fois a l ecran) et animer les mouvements deja peints dans la mer (lignes de houle statiques)',
        'choix': {'mer': 'generee avec V24P04A en reference (reponse de l utilisateur), animee par les lois de V24P04A',
                  'version': 'nouvelle version, ZRV1 gardee (reponse de l utilisateur)',
                  'layout': 'celui de ZRV1 (prairie, horizon, montagne, collisions, marqueurs) (demande de l utilisateur)',
                  'ecume_bulles': 'celles de ZRV1 (demande de l utilisateur) : jour, aube, nuit = calques de ZRV1 ; crepuscule = meme '
                                  'methode (palette 8 de s01p02a transposee sur le brut de crepuscule, memes bulles)',
                  'crepuscule': 'quatrieme ambiance ; prairie : recette des ambiances de ZRV1 sur un brut de crepuscule recale au pixel',
                  'vagues': 'cretes elargies a 78 px sur le motif de 96 (comme V24P04A) et ligne de houle continue de 1 px sous chaque rangee',
                  'petits_pics': 'les petits pics sombres de la mer de nuages de ZRV1 ne sont pas repris : la mer de nuages est '
                                 'remplacee par le banc qui passe derriere la montagne'},
        'base': 'branche de session : calques de ZRV1, utilitaires de ZRV1 et d ESN1 ; etude des animations pour le rendu ROM ; '
                'aucun emprunt aux branches soeurs',
        'method': 'textures canoniques = rendu genere REFERENCE ; aucun pixel natif',
        'references': {k: {'file': v, 'sha256': sha(R / v)} for k, v in REFS.items()},
        'reference_rom': {'depot': 'pret/pmd-sky', 'commit': 'c8073235b39746a7ee74e6cea16c730bd91a1e67', 'cartes': ['v24p04a', 'v24p02a'],
                          'v24p04a': {'bpa': '12 crans x 10 ticks (houle)', 'palettes_animees': '4 palettes, 16 crans x 4 ticks '
                                      '(dont une de 4 crans), scintillement de l horizon', 'motif_horizontal_px': 96,
                                      'cretes_px_sous_horizon': [65, 106, 153]}},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']), 'size': list(Image.open(RAW / g['file']).size)}
                       for g in GEN],
        'zrv1': {'calques': {k: sha(V1OUT / 'calques/jour' / f'ZRV1J_{i:02d}_{k}.png') for k, i in V1_INDEX.items()},
                 'manifest_sha256': sha(V1OUT / 'manifest.json')},
        'mesures': info,
        'houle': {'crans': SWELL_STEPS, 'frame_length_ticks': SWELL_TICKS, 'loi_y': f'y(u) = {YH} + {SWELL_D0} + {SWELL_A} u + {SWELL_B} u^2',
                  'u': 'k + 2 cran / 12', 'rangees_par_cycle': SWELL_PASSES, 'periode_x': SWELL_PERIOD_X, 'bornes_tailles': SIZE_BOUNDS, 'echelle_cretes': CREST_SCALE,
                  'largeur_cretes_px': CREST_W, 'ligne_de_houle': f'1 px continu, mer x {SWELL_LINE}, des u >= {SIZE_BOUNDS[0]}'},
        'scintillement': {'crans': GLINT_STEPS, 'frame_length_ticks': GLINT_TICKS, 'niveaux': GLINT_LEVELS},
        'ondes': {'crans': SWELL_STEPS, 'frame_length_ticks': SWELL_TICKS, 'rangee_depart': ONDES_Y0, 'seuil': ONDES_T,
                  'demi_fenetre_verticale': ONDES_R, 'taille_min_px': ONDES_MIN, 'ligne_min_px': ONDES_LINE_W,
                  'loi': 'orbite de l eau sous la houle : dx = (1 + d/60) cos phi, dy = (0,5 + d/90) sin phi, phi = 2 pi (2s/12 - u(y)), '
                         'd = y - horizon ; les plaques claires s eteignent quand sin(2 phi + phase propre) < -0,85',
                  'raison': 'demande : les mouvements deja peints dans la mer (lignes de houle, reflets clairs) restaient statiques'},
        'nuages': {'periode_px': CLOUD_PERIOD, 'pas_px': CLOUD_PAS, 'phases': CLOUD_PHASES, 'frame_length_ticks': CLOUD_TICKS,
                   'raccord': f'trois bancs generes differents mis bout a bout sur 768 px (aucun nuage repete a l ecran) ; coupes la ou la silhouette du banc suivant prolonge la precedente ; fondu des teintes seules sur {CLOUD_TINT} colonnes', 'hauteur_px': int(strip.shape[0])},
        'fleurs': {'phases': 4, 'frame_length_ticks': FLOWER_TICKS, 'loi': 'A B A C : en B et C chaque tete descend de 1 px et '
                   'penche de +1 / -1 px (sens propre a la tete) ; mesure sur le GIF Sky Peak (images 0 = 2, decalage (±1, +1))'},
        'etoiles': {'phases': STAR_PHASES, 'frame_length_ticks': STAR_TICKS},
        'astres': ASTRE,
        'ambiances': report,
        'crepuscule': {k: dusk_meadow()[k] for k in ('recalage', 'ecume_palette_8', 'bulles_couleurs')},
        'access': {'entry_px': entry, 'reveil_px': reveil, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'walkable_cells': int((~blocked).sum()), 'origine': 'masque praticable de ZRV1'},
        'pmdo': {'target': '0.8.12', 'namespace': NAMESPACE, 'assets': ASSET, 'tiles_per_bank': counts, 'markers': markers, 'warps': 'aucun'},
        'art_approved': False, 'runtime_tested': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=1))
    print(json.dumps(info, indent=1, ensure_ascii=False)[:4000])


if __name__ == '__main__':
    build(apercu='--apercu' in sys.argv)
