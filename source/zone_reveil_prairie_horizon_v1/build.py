"""Zone de réveil — grande prairie de Sky Peak face à l'océan (ZRV1), 4:3 vaste (768 x 576 px), jour / aube / nuit.

Demande (27 septembre) : « pour la premiere zone de depart la ou y'aura le réveil du pokemon je veux une grande prairie
style sky peak etc donnant sur un paysage avec cime nuage sur horizon mer en contre bas », puis, aux questions :
« une falaise sans relief mais une entrée immersive qui donne sur un paysage panoramique d'un océan comme la mer animée
dans pmd sky et des nuages qui passent jour/nuit », composition « promontoire », « les deux » ambiances (jour + aube),
format recommandé (768 x 576, réveil face à l'horizon, sortie au sud) « + un effet de bulle etc de la mer qui arrive en
contrebas ; le paysage doit être magnifique, c'est la première scène du jeu ». Trois ambiances : jour, aube, nuit.

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ :
- decor_jour.png : références GIF Sky Peak `2cwdrrs469f61.gif` (frame 0), `232233.png` (cimes), mer de s01p02a
  (rendu ROM de l'étude des animations) ; premier essai, conforme ;
- decor_nuit.png : édité depuis le jour, référence `bgnightbackgroundpmdskyda.png` (nuit native de PMD Ciel) ;
- decor_aube.png : édité depuis le jour ;
- nuages_sprites.png : six cumulus sur magenta, références la nuit native et `232233.png`.
MER : la mécanique et les couleurs du jeu. Les pixels de mer reçoivent un index 0-9 en bandes ondulées (profil
d'épaisseurs mesuré sur s01p02a, perspective vers l'horizon) et la palette 7 de s01p02a tourne : 10 crans x 10 ticks,
couleurs EXACTES (jour). ÉCUME : palette 8 de s01p02a (écume du rivage), mêmes 10 x 10 ticks. Aube et nuit : les
couleurs de chaque cran sont transposées pixel à pixel depuis le brut de l'ambiance (reflet de la lune / du soleil
compris). Nuages qui passent (192 phases x 8 ticks, deux rangées, parallaxe), bulles, scintillements : boucles fermées.
Lancer : .venv/bin/python source/zone_reveil_prairie_horizon_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, sys, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
sys.path.insert(0, str(HERE))
import seg  # noqa: E402

RAW = HERE / 'bruts'
LOT = 'source/zone_reveil_prairie_horizon_v1'
OUT = R / 'renders/zone_reveil_prairie_horizon_v1'
NAMESPACE = 'zone_reveil_prairie_horizon'
STAGE = R / '.cache/zone_reveil_prairie_horizon_v1' / NAMESPACE
PFX = 'ZRV1'
AMB = {'jour': 'J', 'aube': 'A', 'nuit': 'N'}
ASSET = {k: f'zrv1_zone_reveil_{k}' for k in AMB}
W, H = 768, 576
SRC = (1200, 896)
STUDY = R / 'renders/etude_animations_canoniques_sky_v1/rapport.json'
REFS = {'skypeak': '2cwdrrs469f61.gif', 'cimes': '232233.png', 'nuit': 'bgnightbackgroundpmdskyda.png',
        'mer': 'renders/etude_animations_canoniques_sky_v1/cartes/s01p02a_t000.png'}
GEN = [
    {'file': 'decor_jour.png', 'images': [f'{LOT}/references/skypeak_gif_frame0.png', REFS['cimes'], REFS['mer']], 'prompt':
     'Pokémon Mystery Dungeon Explorers of Sky ground map, pixel art, same textures, palette and pixel style as the '
     'reference images. Wide 4:3 top-down scene: the very first scene of the game, where the hero wakes up. Lower 60 '
     'percent: a vast flat meadow exactly like the Sky Peak reference (first image): bright green grass with small grass '
     'tufts, many clusters of small pink flowers, a few small grey rocks and round green bushes. A light dirt path enters '
     'from the middle of the bottom edge and fades into the grass. Flat ground everywhere: no cliffs, no ravines, no '
     'raised plateau. Around the middle of the image the meadow ends along a gently curved flat grass edge, like a '
     'promontory seen from above, with no rock wall and no relief. Beyond that edge, far below: the open ocean in Pokémon '
     'Mystery Dungeon Sky style (sea colours of the third image), deep blue with wavy lighter wave bands, and white foam '
     'with small bubbles where the waves reach the foot of the meadow edge. Upper 25 percent: a panoramic horizon where '
     'the ocean meets a sea of white clouds, distant snowy mountain peaks rising above the clouds (second image), clear '
     'blue sky at the very top. No characters, no buildings, no text, no frame.',
     'essais': 'premier essai ; conforme'},
    {'file': 'decor_nuit.png', 'images': [f'{LOT}/bruts/decor_jour.png', REFS['nuit']], 'prompt':
     'Edit the first image only: keep exactly the same layout, pixel positions, shapes, flowers, rocks, bushes, path, '
     'shoreline, waves, clouds and mountains. Change only the time of day to night, with the colours and pixel style of '
     'the second image (Pokémon Mystery Dungeon Explorers of Sky night background): deep navy blue sky with small '
     'twinkling stars, a big pale yellow full moon in the sky above the clouds, clouds and snowy peaks in moonlit '
     'blue-grey, dark blue ocean with a shimmering white moonlight reflection column on the water below the moon, meadow '
     'in cool dark blue-green night tones with muted flowers. No characters, no text.',
     'essais': 'premier essai ; conforme'},
    {'file': 'decor_aube.png', 'images': [f'{LOT}/bruts/decor_jour.png'], 'prompt':
     'Edit this image only: keep exactly the same layout, pixel positions, shapes, flowers, rocks, bushes, path, '
     'shoreline, waves, clouds and mountains. Change only the time of day to dawn, same Pokémon Mystery Dungeon Explorers '
     'of Sky pixel art style: sky shading from soft pink and peach at the horizon to light violet at the top, a rising '
     'golden sun just above the sea of clouds, clouds and snowy peaks lit in pink and gold, ocean with warm golden '
     'sparkles and a sun reflection on the water, meadow in soft warm morning light with long gentle tones. No '
     'characters, no text.',
     'essais': 'premier essai ; conforme'},
    {'file': 'nuages_sprites.png', 'images': [REFS['nuit'], REFS['cimes']], 'prompt':
     'Pixel art sprite sheet in Pokémon Mystery Dungeon Explorers of Sky style, like the clouds in the reference images: '
     'six separate puffy white cumulus clouds of different sizes (two large, two medium, two small), flat wide shapes '
     'with rounded tops and flat bottoms, soft light blue-grey shading underneath, crisp pixel edges. Each cloud fully '
     'isolated with wide empty space around it, arranged in two rows. Solid flat pure magenta background (#FF00FF) '
     'everywhere else. No sky, no text, no border.',
     'essais': 'premier essai ; conforme'},
]
# ---- Mer (s01p02a) : profil des bandes, du large vers le rivage, index 0 -> 9 (mesuré : pixels par index sur la carte,
# index 2 et 8 départagés au cran 1). La crête blanche (couleur de base 7) est à l'index 7 + cran : elle avance vers le rivage.
BAND = [7890, 7654, 7915, 7416, 4904, 3799, 3395, 2677, 2861, 3418]
P_HORIZON, P_SHORE, PERSP = 16.0, 44.0, 1.2       # période des bandes (px) à l'horizon et au rivage, courbure
WOBBLE, WOBBLE_L, WOBBLE_MIN = 0.12, 3.2, 60.0    # ondulation : amplitude (en période), longueur d'onde (en périodes, >= 60 px)
SEA_STEPS, SEA_TICKS = 10, 10
FOAM_IN, FOAM_MID, FOAM_OUT = 2.0, 4.0, 16.0       # écume : distance au bord de la prairie (px)
FOAM_SPECK = (4, 5, 6)                             # index de palette 8 des bulles du rendu (éclairs blancs)
PHASES, TICKS = 24, 5                              # bulles et scintillements : 120 ticks
CLOUD_PHASES, CLOUD_TICKS = 192, 8                 # nuages : 1536 ticks = 25,6 s
# (sprite, x0, y0) ; rangée haute : période 768 px, 4 px par phase ; rangée basse : période 384 px, 2 px par phase.
CLOUD_ROWS = {'haute': {'periode': 768, 'pas': 4, 'nuages': [(0, 10, 2), (4, 250, 16), (2, 420, 4), (5, 610, 20)]},
              'basse': {'periode': 384, 'pas': 2, 'nuages': [(1, 40, 52), (3, 250, 66)]}}
CLOUD_W = [118, 96, 80, 62, 50, 42]                # largeur finale des six nuages (ordre : grands -> petits)
BUBBLES = 16
DAY_GLINTS = 12
PALETTE_GROUPS = {'herbe': (['sol_complet', 'herbe', 'chemin'], 48), 'fleurs': (['fleurs'], 24),
                  'rochers': (['rochers'], 16), 'buissons': (['buissons'], 32), 'panorama': (['panorama'], 96)}
STATIC = ['herbe', 'chemin', 'fleurs', 'rochers', 'buissons', 'panorama']
ANIMS = ['mer', 'ecume', 'bulles', 'scintillements', 'nuages']
ORDER = ['sol_complet'] + STATIC + ANIMS


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM = V1.JM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
down_class, down_full, rgba, quantize_group, cell_grid = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group, V1.cell_grid
close_, keep_large, lum_of = seg.close_, seg.keep_large, seg.lum_of


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def down_mask(m):
    """Masque pleine résolution -> espace final (poids > 0,5)."""
    return V1.resize_plane(m.astype(np.float32)) > 0.5


def sea_palettes():
    rep = json.loads(STUDY.read_text())['cartes']['s01p02a']['palettes_animees']
    p7, p8 = (next(p for p in rep if p['palette'] == k) for k in (7, 8))
    assert (p7['crans'], p7['duree_frames'], p8['crans'], p8['duree_frames']) == (10, 10, 10, 10)
    return np.array(p7['couleurs'], 'uint8'), np.array(p8['couleurs'], 'uint8')      # (10 crans, 15, 3)


# ---------------------------------------------------------------- recalage des éditions (couleurs changées)
def norm_grad(a, zone):
    l = lum_of(a); l = (l - l[zone].mean()) / (l[zone].std() + 1e-6)
    return np.hypot(nd.sobel(l, 0), nd.sobel(l, 1))


def recalage(a, o, zone):
    """Écart moyen des gradients de luminance normalisée (les couleurs changent d'une ambiance à l'autre)."""
    ga, go = norm_grad(a, zone), norm_grad(o, zone)
    err = {(dy, dx): float(np.abs(ga - np.roll(np.roll(go, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen': round(err[(0, 0)], 3), 'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 3)}


# ---------------------------------------------------------------- mer : champ d'index (espace final)
def sea_phase(sea, yh):
    """Phase (en périodes) de chaque pixel : bandes horizontales en perspective, croissant vers le rivage. Toutes les
    lignes ondulent en phase (comme les vagues de s01p02a) : y' = y + A(y) sin(2 pi x / L(y)) (+ harmonique 0,35 A),
    A = 0,12 période, L = max(60, 3,2 périodes). La plus fine bande (index 7, 5 %) fait >= 0,8 px à l'horizon."""
    ys = np.nonzero(sea.any(1))[0]; y1 = int(ys.max())
    y = np.arange(H, dtype=float); v = np.clip((y - yh) / max(1, y1 - yh), 0, 1)
    p = P_HORIZON + (P_SHORE - P_HORIZON) * v ** PERSP
    phi = np.concatenate([[0.0], np.cumsum(1.0 / p)[:-1]]); phi -= phi[yh]
    xx = np.arange(W, dtype=float)[None, :]
    amp = (WOBBLE * p)[:, None]; lam = np.maximum(WOBBLE_MIN, WOBBLE_L * p)[:, None]
    yw = y[:, None] + amp * np.sin(2 * np.pi * xx / lam) + 0.35 * amp * np.sin(2 * np.pi * xx / (0.53 * lam) + 1.7)
    return np.interp(yw, y, phi)


def band_index(phase):
    cum = np.cumsum(BAND) / np.sum(BAND)
    return np.searchsorted(cum, np.mod(phase, 1.0), side='right').clip(0, 9)


def sea_fields(sea, meadow, yh, white):
    """Index de palette 7 (mer) et de palette 8 (écume) ; -1 hors calque."""
    dist = nd.distance_transform_edt(~meadow)
    idx7 = np.where(sea, band_index(sea_phase(sea, yh)), -1)
    foam = np.full((H, W), -1)
    inner = sea & (dist <= FOAM_IN); mid = sea & (dist > FOAM_IN) & (dist <= FOAM_MID)
    foam[mid] = 8; foam[inner] = 9                             # 8 puis 9 : la vague d'écume avance vers le bord
    speck = sea & white & (dist > FOAM_MID) & (dist <= FOAM_OUT)
    sl, _ = nd.label(speck, structure=np.ones((3, 3)))              # une bulle du rendu = un seul index
    foam[speck] = np.array(FOAM_SPECK)[(sl[speck] * 7) % 3]
    idx7[foam >= 0] = -1
    return idx7, foam, dist


def palette_frames(idx, pal, ramp_masks=None):
    """Frames RGBA : couleur(cran s, index k) = pal[s][k] (palette du jeu indexée par cran). ramp_masks : liste de
    (masque, pal) qui remplace pal sur une zone (reflet)."""
    frames = []
    for s in range(SEA_STEPS):
        a = np.zeros((H, W, 4), 'uint8'); m = idx >= 0
        a[m, :3] = pal[s][idx[m]]; a[m, 3] = 255
        for zm, zp in (ramp_masks or []):
            mm = m & zm; a[mm, :3] = zp[s][idx[mm]]
        frames.append(a)
    return frames


def transpose_palette(pal, day_l, amb_rgb, sel):
    """Couleur de chaque (cran, index) dans l'ambiance : médiane, dans le brut de l'ambiance, des pixels de mer dont
    la luminance dans le brut de jour est la plus proche de celle de la couleur du jeu (>= 150 pixels)."""
    dl = day_l[sel]; ac = amb_rgb[sel]; order = np.argsort(dl); dls = dl[order]
    out = np.zeros_like(pal); cache = {}
    for s in range(pal.shape[0]):
        for k in range(pal.shape[1]):
            c = tuple(int(v) for v in pal[s, k])
            if c not in cache:
                l = float(np.dot(c, [.299, .587, .114])); i = int(np.searchsorted(dls, l))
                lo, hi = max(0, i - 75), min(len(dls), i + 75)
                cache[c] = np.median(ac[order[lo:hi]], 0).round().astype('uint8')
            out[s, k] = cache[c]
    return out


def reflection_column(bright, sea):
    """Colonne du reflet : centre = médiane x des pixels clairs ; demi-largeur par rang = 90e centile de |x - centre|
    des pixels clairs du rang, lissée sur 15 rangs (0 si < 3 pixels clairs) ; zone = |x - centre| <= demi-largeur."""
    ys, xs = np.nonzero(bright)
    if len(xs) < 50:
        return np.zeros((H, W), bool)
    cx = float(np.median(xs)); hw = np.zeros(H)
    for y in np.unique(ys):
        d = np.abs(xs[ys == y] - cx)
        if len(d) >= 3:
            hw[y] = np.percentile(d, 90)
    hw = nd.uniform_filter1d(nd.maximum_filter1d(hw, 5), 15)
    zone = np.abs(np.arange(W)[None, :] - cx) <= hw[:, None]
    return zone & (hw[:, None] >= 2) & sea


# ---------------------------------------------------------------- scintillements, bulles
def sparkle_state(off, t):
    u = (t + off) % PHASES
    return 'plein' if 4 <= u <= 11 else ('coeur' if u in (2, 3, 12, 13) else 'eteint')


def sparkle_frames(sparks, ts=range(PHASES)):
    """sparks : liste de (pixels [(y, x, r, g, b)], coeur [(y, x, r, g, b)], décalage)."""
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for px, core, off in sparks:
            st = sparkle_state(off, t)
            for y, x, r, g, b in (px if st == 'plein' else core if st == 'coeur' else []):
                a[y, x] = (r, g, b, 255)
        frames.append(a)
    return frames


def bubble_shape(u):
    if u < 4 or u > 18:
        return []
    if u < 8:
        return [(0, 0)]
    if u < 13:
        return [(-1, 0), (1, 0), (0, -1), (0, 1)]
    if u < 18:
        return [(-2, -1), (-2, 0), (-2, 1), (2, -1), (2, 0), (2, 1), (-1, -2), (0, -2), (1, -2), (-1, 2), (0, 2), (1, 2)]
    return [(-2, -2), (-2, 2), (2, -2), (2, 2)]                # éclatement


def bubble_frames(bubbles, colors, ts=range(PHASES)):
    """bubbles : (x, y, dx, dy, décalage) ; la bulle glisse d'1 px vers le rivage toutes les 6 phases."""
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for x, y, dx, dy, off in bubbles:
            u = (t + off) % PHASES; k = u // 6; cx, cy = x + dx * k, y + dy * k
            col = colors[0] if u < 8 else colors[1] if u < 13 else colors[2]
            for ox, oy in bubble_shape(u):
                a[cy + oy, cx + ox] = (*col, 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- nuages
def cloud_sprites(sheet):
    """Six sprites (grands -> petits), réduits à leur largeur finale ; alpha binaire (majorité)."""
    s = sheet.astype(int); bg = (s[..., 0] - s[..., 1] > 50)
    lab, n = nd.label(nd.binary_fill_holes(~bg))
    sizes = nd.sum(~bg, lab, range(1, n + 1)); keep = [i + 1 for i in np.argsort(-sizes)[:6]]
    sl = nd.find_objects(lab)
    objs = sorted(keep, key=lambda i: -(sl[i - 1][1].stop - sl[i - 1][1].start))
    out = []
    for i, wf in zip(objs, CLOUD_W):
        ys, xs = sl[i - 1]; m = (lab[ys, xs] == i) & ~bg[ys, xs]; c = s[ys, xs]
        hf = max(1, round(m.shape[0] * wf / m.shape[1]))
        wgt = np.array(Image.fromarray((m * 255).astype('uint8')).resize((wf, hf), Image.Resampling.BOX)) / 255.0
        col = np.stack([np.array(Image.fromarray((c[..., ch] * m).astype('float32')).resize((wf, hf), Image.Resampling.BOX))
                        for ch in range(3)], -1) / np.maximum(wgt, 1e-6)[..., None]
        spr = np.zeros((hf, wf, 4), 'uint8'); mm = wgt > 0.5
        spr[mm, :3] = np.clip(col[mm].round(), 0, 255); spr[mm, 3] = 255
        out.append(spr)
    return out


def recolor_by_lum(spr, colors):
    """Recolore un sprite : rang de luminance -> couleur de même rang dans `colors` (triées par luminance)."""
    cols = np.array(sorted({tuple(int(v) for v in c) for c in colors}, key=lambda c: np.dot(c, [.299, .587, .114])), 'uint8')
    out = spr.copy(); m = spr[..., 3] == 255
    l = lum_of(spr[m].astype(float)); rk = np.argsort(np.argsort(l)) / max(1, len(l) - 1)
    out[m, :3] = cols[np.round(rk * (len(cols) - 1)).astype(int)]
    return out


def cloud_strip(sprites, row):
    per = row['periode']; hh = max(y0 + sprites[k].shape[0] for k, _, y0 in row['nuages']) + 1
    strip = np.zeros((hh, per, 4), 'uint8')
    for k, x0, y0 in row['nuages']:
        spr = sprites[k]; sh, sw = spr.shape[:2]
        for dx in range(sw):
            col = spr[:, dx]; m = col[:, 3] == 255; x = (x0 + dx) % per
            strip[y0:y0 + sh, x][m] = col[m]
    return strip


def cloud_frames(strips, ts=range(CLOUD_PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for name, row in CLOUD_ROWS.items():
            st = strips[name]; rolled = np.roll(st, row['pas'] * t, axis=1)
            full = np.tile(rolled, (1, W // row['periode'], 1)); m = full[..., 3] == 255
            reg = a[:full.shape[0]]; reg[m] = full[m]
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
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}{AMB[amb]}_{i:02d}_{title.split()[0].upper()}')
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
    o.update(Name={'DefaultText': f'Zone de reveil - prairie face a l ocean ({amb})', 'LocalTexts': {}},
             AssetName=ASSET[amb], Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment=f'PMDO 0.8.12. Zone de reveil ({amb}). Rendu genere reference (Sky Peak, 232233, s01p02a, nuit PMD '
                     'Ciel). Mer : rotation de palette de s01p02a (palette 7, ecume palette 8, 10 x 10 ticks). Nuages, '
                     'bulles, scintillements animes. Collisions de base a verifier. Aucun warp.')
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
             f'-- {ASSET[amb]} : zone de reveil ({amb}), base d edition, aucun warp.\n'
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
  <Name>Zone de reveil - prairie face a l ocean (jour, aube, nuit) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : premiere scene, grande prairie fleurie de Sky Peak au bord d'un promontoire plat, ocean en contrebas (rotation de palette de PMD Ciel), ecume et bulles, cimes et mer de nuages a l'horizon, nuages qui passent. Trois Grounds : jour, aube, nuit. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- fidélité
def skypeak_materials(a):
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return {'herbe': (g > 200) & (r < 150) & (b < 130) & (g - r > 90),
            'fleurs': (r > 200) & (g < 170) & (b > 120) & (r - g > 50)}


def mean_dist(x, y):
    return round(float(np.linalg.norm(x.mean(0) - y.mean(0))), 1)


# ---------------------------------------------------------------- main
def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    esn1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['masques', 'review'] + [f'calques/{k}' for k in AMB] + [f'animation/{k}/{x}' for k in AMB for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    if STAGE.exists():
        shutil.rmtree(STAGE)
    raws = {k: rgb(RAW / f'decor_{k}.png') for k in AMB}
    for v in raws.values():
        assert v.shape[:2] == (SRC[1], SRC[0])
    day = raws['jour']
    m, sg = seg.classify(day)
    order = ['panorama', 'mer', 'buissons', 'rochers', 'fleurs', 'chemin', 'herbe']
    ex, _ = down_class(day, m, order)
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    meadow = ex['herbe'] | ex['chemin'] | ex['fleurs'] | ex['rochers'] | ex['buissons']
    sea = ex['mer']
    yh = int(np.nonzero(sea.any(1))[0].min())
    assert not ex['panorama'][yh:].any() and not sea[:yh].any()
    zone_meadow = (np.mgrid[:SRC[1], :SRC[0]][0] > sg['horizon_y'] + 200) & ~m['buissons']
    reg = {k: recalage(day, raws[k], zone_meadow) for k in ('nuit', 'aube')}
    # ---- accès (commun aux trois ambiances)
    cand = ex['herbe'] | ex['fleurs'] | ex['chemin']
    cl, _ = nd.label(cand); seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    free2 = lambda cy, cx: not blocked[cy:cy + 2, cx:cx + 2].any()
    pxs = np.nonzero(ex['chemin'][H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if free2(gh_ - 2, c)), key=lambda c: abs(c - med))
    entry = [ecol * 8, H - 16]
    cx = gw_ // 2 - 1
    ry = next(y for y in range(gh_ - 1) if free2(y, cx) and free2(y, cx - 1) and free2(y, cx + 1))
    reveil = [cx * 8, (ry + 1) * 8]                  # une case sous le premier rang libre : au bord, face à l'océan
    reach, explored = esn1.reachable(blocked, (entry[1] // 8, entry[0] // 8), (reveil[1] // 8, reveil[0] // 8))
    assert reach, 'pas de chemin 16x16'
    markers = {'reveil': reveil, 'entrance': entry}
    # ---- mer : index
    p7, p8 = sea_palettes()
    white_day = lum_of(down_full(day).astype(float)) > 215
    idx7, foam, dist = sea_fields(sea, meadow, yh, white_day)
    Image.fromarray(np.where(idx7 >= 0, idx7 * 25, 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_mer_index.png')
    Image.fromarray(np.where(foam >= 0, foam * 25, 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_ecume_index.png')
    # ---- nuages
    sheet = rgb(RAW / 'nuages_sprites.png'); sprites_day = cloud_sprites(sheet)
    night_ref = rgb(R / REFS['nuit'])
    nr = night_ref[:250]; nl = lum_of(nr.astype(float))
    night_cloud_cols = np.unique(nr[(nl > 70) & (nr[..., 2] > nr[..., 0] + 20) & (nr[..., 1] > 60)
                                    & (nd.uniform_filter(nl, 5) > 80)], axis=0)
    # ---- fidélité (jour)
    gif = rgb(HERE / 'references/skypeak_gif_frame0.png')
    fm_g, fm_d = skypeak_materials(gif[150:]), skypeak_materials(day[sg['horizon_y'] + 250:])
    fid = {k: {'rip_rgb': [round(float(v), 1) for v in gif[150:][fm_g[k]].mean(0)],
               'brut_rgb': [round(float(v), 1) for v in day[sg['horizon_y'] + 250:][fm_d[k]].mean(0)],
               'distance': mean_dist(gif[150:][fm_g[k]], day[sg['horizon_y'] + 250:][fm_d[k]])} for k in fm_g}
    # ---- par ambiance
    report = {}; all_counts = {}
    tpl_zip = zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip')
    tpl = json.loads(tpl_zip.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    for amb in AMB:
        a = raws[amb]
        _, cols = down_class(a, m, order)
        layers = {'sol_complet': rgba(np.broadcast_to(np.median(cols['herbe'][ex['herbe']], 0).round().astype('uint8'), (H, W, 3)),
                                      np.ones((H, W), bool))}
        for k in STATIC:
            layers[k] = rgba(cols[k], ex[k])
        # étoiles (nuit) : retirées du panorama, animées
        af = down_full(a).astype(int); lf = lum_of(af.astype(float))
        sparks, spark_info = [], {}
        rng_hash = lambda y, x: int((x * 73856093) ^ (y * 19349663)) % PHASES
        if amb == 'nuit':
            dayf = down_full(day).astype(int)
            star = ex['panorama'] & (lf > 170) & (lf - nd.median_filter(lf, 7) > 45) & (dayf[..., 2] > dayf[..., 0] + 60)
            star = star & ~keep_large(star, 40)                   # la lune n'est pas une étoile
            sl, sn = nd.label(nd.binary_dilation(star, iterations=1) & ex['panorama'] & (lf > nd.median_filter(lf, 7) + 12))
            dark = nd.median_filter(lf, 9)
            for i, s in enumerate(nd.find_objects(sl)):
                mm = sl[s] == i + 1; ys, xs = np.nonzero(mm); ys += s[0].start; xs += s[1].start
                cy, cx_ = int(round(ys.mean())), int(round(xs.mean())); c = af[ys, xs].mean(0)
                if len(ys) > 30 or dark[cy, cx_] > 100 or c[2] < c[0] - 20:      # bord de lune (jaune), bord de nuage
                    continue
                px = [(int(y), int(x), *[int(v) for v in af[y, x]]) for y, x in zip(ys, xs)]
                lv = [lf[y, x] for y, x in zip(ys, xs)]; thr = np.percentile(lv, 70)
                core = [p for p, l in zip(px, lv) if l >= thr]
                sparks.append((px, core, rng_hash(int(ys.mean()), int(xs.mean()))))
            starmask = np.zeros((H, W), bool)
            for px, _, _ in sparks:
                for y, x, *_ in px:
                    starmask[y, x] = True
            pan = layers['panorama']; keep = ex['panorama'] & ~starmask
            _, (iy, ix) = nd.distance_transform_edt(~keep, return_indices=True)
            pan[starmask, :3] = pan[iy[starmask], ix[starmask], :3]
            spark_info = {'type': 'etoiles du brut de nuit', 'n': len(sparks)}
        layers.update(quantize_group({k: layers[k] for k in PALETTE_GROUPS['herbe'][0]}, PALETTE_GROUPS['herbe'][1]))
        for g, (keys, n) in PALETTE_GROUPS.items():
            if g != 'herbe':
                layers.update(quantize_group({k: layers[k] for k in keys}, n))
        # mer / écume : palettes du jeu (jour) ou transposées (aube, nuit)
        if amb == 'jour':
            pal7, pal8, zones7, zones8, refl = p7, p8, [], [], np.zeros((H, W), bool)
        else:
            day_l = lum_of(down_full(day).astype(float)); pred_sel = sea & (foam < 0)
            base7 = transpose_palette(p7, day_l, af, pred_sel)
            pred = lum_of(af.astype(float)); expect = np.zeros((H, W))
            del base7
            # reflet : pixels de mer nettement plus clairs que la transposition ne le prévoit, groupés en colonne
            dl = day_l[pred_sel]; al = pred[pred_sel]; o_ = np.argsort(dl)
            expect_s = nd.uniform_filter1d(al[o_], 301); expect[pred_sel] = expect_s[np.argsort(o_)]
            bright = keep_large(close_(pred_sel & (pred > expect + 45), 2), 20)
            refl = reflection_column(bright, sea)
            normal_sel = pred_sel & ~refl
            pal7 = transpose_palette(p7, day_l, af, normal_sel)
            pal8 = transpose_palette(p8, day_l, af, sea & ~refl)
            zones7 = [(refl, transpose_palette(p7, day_l, af, pred_sel & refl))] if refl.sum() > 200 else []
            zones8 = []
            if amb == 'aube':                                        # paillettes du brut sur la mer (hors reflet)
                sp = sea & ~refl & (lf > 225) & (lf - nd.median_filter(lf, 7) > 70) & (foam < 0)
                sl, sn = nd.label(nd.binary_dilation(sp, iterations=1) & sea & (lf > nd.median_filter(lf, 7) + 15))
                for i, s in enumerate(nd.find_objects(sl)):
                    mm = sl[s] == i + 1; ys, xs = np.nonzero(mm); ys += s[0].start; xs += s[1].start
                    if len(ys) > 40 or len(ys) < 3:
                        continue
                    px = [(int(y), int(x), *[int(v) for v in af[y, x]]) for y, x in zip(ys, xs)]
                    lv = [lf[y, x] for y, x in zip(ys, xs)]; thr = np.percentile(lv, 70)
                    sparks.append((px, [p for p, l in zip(px, lv) if l >= thr], rng_hash(int(ys.mean()), int(xs.mean()))))
                spark_info = {'type': 'paillettes du brut d aube sur la mer', 'n': len(sparks)}
            Image.fromarray((refl * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_{amb}_reflet.png')
        if amb == 'jour':                                            # reflets de soleil créés : couleurs de la palette 7
            cand_g = np.argwhere(sea & (foam < 0) & (dist > 30) & (np.arange(H)[:, None] > yh + 12))
            pick = cand_g[np.linspace(0, len(cand_g) - 1, DAY_GLINTS * 7).astype(int)][::7][:DAY_GLINTS]
            for y, x in pick:
                y, x = int(y), int(x); core = [(y, x, 231, 247, 255)]
                arms = [(y + dy, x + dx, 215, 231, 247) for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1))]
                sparks.append((core + arms, core, rng_hash(y, x)))
            spark_info = {'type': 'reflets de soleil crees (croix aux couleurs de la palette 7)', 'n': len(sparks)}
        mer = palette_frames(idx7, pal7, zones7)
        ecume = palette_frames(foam, pal8, zones8)
        # bulles : couleurs claires de la palette 8 (jour) / transposées
        bcols = [tuple(int(v) for v in pal8[3, 9]), tuple(int(v) for v in pal8[2, 8]), tuple(int(v) for v in pal8[1, 8])]
        bub = []
        band = sea & (dist > FOAM_MID + 2) & (dist < FOAM_OUT - 3)
        band[:, :4] = False; band[:, W - 4:] = False
        ys, xs = np.nonzero(band)
        gy, gx = np.gradient(-dist)
        order_x = np.argsort(xs); xs_s, ys_s = xs[order_x], ys[order_x]
        for j, i in enumerate(np.linspace(0, len(xs_s) - 1, BUBBLES).astype(int)):
            x, y = int(xs_s[i]), int(ys_s[i]); n_ = np.hypot(gx[y, x], gy[y, x]) + 1e-9
            dx, dy = int(round(-gx[y, x] / n_)), int(round(-gy[y, x] / n_))
            bub.append((x, y, dx, dy, (j * 7) % PHASES))
        bulles = bubble_frames(bub, bcols)
        scint = sparkle_frames(sparks)
        # nuages
        if amb == 'jour':
            sprites = sprites_day
        elif amb == 'nuit':
            sprites = [recolor_by_lum(s, night_cloud_cols) for s in sprites_day]
        else:
            pan_cols = layers['panorama'][ex['panorama'] & (np.arange(H)[:, None] > 60)][:, :3]
            light = pan_cols[lum_of(pan_cols.astype(float)) > np.percentile(lum_of(pan_cols.astype(float)), 40)]
            sprites = [recolor_by_lum(s, light) for s in sprites_day]
        strips = {n_: cloud_strip(sprites, row) for n_, row in CLOUD_ROWS.items()}
        nuages = cloud_frames(strips)
        for n_, st in strips.items():
            Image.fromarray(st).save(OUT / 'masques' / f'{PFX}_{amb}_nuages_bande_{n_}.png')
        anim = {'mer': (mer, SEA_TICKS), 'ecume': (ecume, SEA_TICKS), 'bulles': (bulles, TICKS),
                'scintillements': (scint, TICKS), 'nuages': (nuages, CLOUD_TICKS)}
        stack_named, layer_list = [], []
        for i, nm in enumerate(ORDER):
            if nm in anim:
                frames, ticks = anim[nm]
                for tt, fr in enumerate(frames):
                    Image.fromarray(fr).save(OUT / 'animation' / amb / nm / f'{PFX}{AMB[amb]}_{i:02d}_{nm}_f{tt:03d}.png')
                layer_list.append({'file': f'animation/{amb}/{nm}/{PFX}{AMB[amb]}_{i:02d}_{nm}_fNNN.png',
                                   'phases': len(frames), 'ticks': ticks})
            else:
                frames, ticks = [layers[nm]], 60
                Image.fromarray(layers[nm]).save(OUT / 'calques' / amb / f'{PFX}{AMB[amb]}_{i:02d}_{nm}.png')
                layer_list.append({'file': f'calques/{amb}/{PFX}{AMB[amb]}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
            stack_named.append((nm, frames, ticks))

        def scene(tick):
            im = Image.new('RGBA', (W, H))
            for _, frames, ticks in stack_named:
                im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
            return im
        step = 10
        scenes = [scene(tk) for tk in range(0, 600, step)]
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
                  {f'{i:02d}_{tn}' + ('_f000' if len(fr) > 1 else ''): fr[0] for i, (tn, fr, _) in enumerate(stack_named)},
                  f'Zone de reveil ZRV1 ({amb})')
        counts = ground(amb, [(tn.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                              for tn, fr, tk in stack_named], blocked, markers, gfx, tpl)
        all_counts.update(counts)
        report[amb] = {'layers': layer_list, 'mer_palette_7': pal7.tolist(), 'ecume_palette_8': pal8.tolist(),
                       'reflet_palette_7': zones7[0][1].tolist() if zones7 else None,
                       'reflet_px': int(refl.sum()), 'bulles': [list(b) for b in bub], 'bulles_couleurs': [list(c) for c in bcols],
                       'scintillements': {**spark_info, 'decalages': [s[2] for s in sparks],
                                          'pixels': [[list(p) for p in s[0]] for s in sparks],
                                          'coeurs': [[list(p) for p in s[1]] for s in sparks]},
                       'nuages_couleurs': sorted({tuple(int(v) for v in c) for s in sprites for c in s[s[..., 3] == 255][:, :3]}),
                       'final_rgb': {k: [round(float(v), 1) for v in layers[k][layers[k][..., 3] == 255][:, :3].mean(0)]
                                     for k in STATIC}}
    finish_stage(tools)
    # fidélité des calques finaux (jour) au GIF
    lay_day = {k: np.array(Image.open(OUT / 'calques/jour' / f'{PFX}J_{ORDER.index(k):02d}_{k}.png')) for k in ('herbe', 'fleurs')}
    final_fid = {}
    for k in ('herbe', 'fleurs'):
        px = lay_day[k][lay_day[k][..., 3] == 255][:, :3].astype(float)
        sel = skypeak_materials(px.reshape(-1, 1, 3))[k][:, 0]
        final_fid[k] = {'rgb': [round(float(v), 1) for v in px[sel].mean(0)],
                        'distance_rip': round(float(np.linalg.norm(px[sel].mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'zone_reveil_prairie_horizon_v1', 'prefix': PFX, 'prefixes_banques': {k: PFX + v for k, v in AMB.items()},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'demande': 'zone de depart ou le Pokemon se reveille : grande prairie style Sky Peak donnant sur un paysage, cimes et '
                   'nuages a l horizon, mer en contrebas ; falaise sans relief, entree immersive, ocean anime comme dans PMD '
                   'Sky, nuages qui passent, jour/nuit (et aube), effet de bulles de la mer, paysage magnifique : premiere scene',
        'choix': {'composition': 'promontoire (choix de l utilisateur)', 'ambiances': 'jour, aube, nuit (reponses : « les deux » '
                  'jour + aube, et « jour/nuit »)', 'acces': 'format recommande : reveil au bord face a l ocean, sortie au sud',
                  'ecume': 'demandee explicitement (« effet de bulle de la mer qui arrive en contrebas ») : ecume animee au pied '
                           'de la prairie, pas un liseré fixe'},
        'base': 'branche de session (EWC1, ESN1 pour les utilitaires ; etude des animations pour les palettes) ; aucun emprunt aux branches soeurs',
        'method': 'textures canoniques = rendu genere REFERENCE ; mer = mecanique et couleurs du jeu (rotation de palette de s01p02a)',
        'references': {k: {'file': v, 'sha256': sha(R / v)} for k, v in REFS.items()},
        'reference_gif_frame0': {'file': f'{LOT}/references/skypeak_gif_frame0.png', 'sha256': sha(HERE / 'references/skypeak_gif_frame0.png')},
        'etude_palettes': {'file': str(STUDY.relative_to(R)), 'sha256': sha(STUDY), 'carte': 's01p02a', 'palettes': [7, 8]},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']), 'size': list(Image.open(RAW / g['file']).size)}
                       for g in GEN],
        'recalage': {**reg, 'zones': 'prairie (200 px sous l horizon et plus bas), hors buissons ; gradients de luminance normalisee'},
        'segmentation_mesures': sg, 'segmentation': seg.classify.__doc__.split('\n', 1)[1].strip(),
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur sur la frame 0 du GIF Sky Peak (y >= 150) et sur '
                                    'le brut de jour (prairie) ; seuil 35', 'brut': fid, 'calques_finaux': final_fid},
        'mer': {'bandes_profil_s01p02a': BAND, 'periode_horizon_px': P_HORIZON, 'periode_rivage_px': P_SHORE, 'courbure': PERSP,
                'ondulation': {'amplitude_periodes': WOBBLE, 'longueur_onde_periodes': WOBBLE_L},
                'crans': SEA_STEPS, 'frame_length_ticks': SEA_TICKS, 'boucle_ticks': SEA_STEPS * SEA_TICKS,
                'loi': 'couleur(cran s, index k) = palette[s][k] ; index croissant vers le rivage : la crete (base 7) avance vers la prairie',
                'ecume': {'index_bord': 9, 'index_milieu': 8, 'index_bulles_du_rendu': list(FOAM_SPECK),
                          'distances_px': [FOAM_IN, FOAM_MID, FOAM_OUT]},
                'origine': 'jour : couleurs et cadence EXACTES de s01p02a (palettes 7 et 8) ; motif des bandes dessine par nous '
                           'sur le profil mesure ; aube et nuit : couleurs transposees depuis les bruts (mediane des pixels de mer '
                           'de meme luminance de jour), reflet a part'},
        'horizon_y_final': yh,
        'bulles': {'n': BUBBLES, 'phases': PHASES, 'frame_length_ticks': TICKS, 'origine': 'creees par nous ; couleurs de la palette 8 (ou transposees)'},
        'scintillements': {'phases': PHASES, 'frame_length_ticks': TICKS,
                           'loi': 'plein aux phases 4-11, coeur aux phases 2-3 et 12-13, eteint sinon ; decalage par position'},
        'nuages': {'phases': CLOUD_PHASES, 'frame_length_ticks': CLOUD_TICKS, 'boucle_ticks': CLOUD_PHASES * CLOUD_TICKS,
                   'rangees': CLOUD_ROWS, 'largeurs_finales': CLOUD_W,
                   'origine': 'sprites generes (nuages_sprites.png) ; nuit : recolores par rang de luminance sur les couleurs de nuages '
                              'de la nuit native ; aube : sur les couleurs claires du panorama d aube'},
        'ambiances': report,
        'access': {'entry_px': entry, 'reveil_px': reveil, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe, fleurs, chemin relies au bord sud)',
                   'reveil': 'une case sous le premier rang libre (2 x 2, colonnes centrales), face au nord'},
        'pmdo': {'target': '0.8.12', 'namespace': NAMESPACE, 'assets': ASSET, 'tiles_per_bank': all_counts,
                 'markers': markers, 'warps': 'aucun'},
        'art_approved': False, 'runtime_tested': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=1))
    print(json.dumps({k: manifest[k] for k in ('recalage', 'segmentation_mesures', 'fidelite_rip', 'access')}, indent=1))
    print({amb: (report[amb]['reflet_px'], report[amb]['scintillements']['n']) for amb in AMB})


if __name__ == '__main__':
    build()
