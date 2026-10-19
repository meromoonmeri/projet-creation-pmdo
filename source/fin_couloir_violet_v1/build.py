"""Fin Couloir violet V1 (FCV5) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (cul-de-sac de boss et d'objectif, sans sortie) associée à l'entrée ECV1
(`entree_couloir_violet_sud_nord_v1`).
Référence `large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png` (312 x 720, 34 couleurs) : couloir rocheux violet
(sol mauve marbré, rochers empilés bleu-violet, falaises striées sombres, gravillons).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), premier essai, conforme (sol 7,6 ; roche 12,1 ; seuil 35) ;
- sol_complet.png : sol mauve seul (texture générée d'après le rip, partagée avec ECV1) ;
- poussiere_poses.png : nuages de poussière sur magenta (4 poses utiles, partagée avec ECV1).
Calques : sol complet, sol, ombres (sol assombri au pied des rochers, de l'autel et des blocs), gravillons (petits îlots
de roche dans le sol), blocs (6 amas de rochers posés dans l'arène), autel (monolithe rocheux à degrés au fond nord),
rochers (parois refermant la caverne), falaise (paroi striée), vide (noir hors carte).
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks :
- eboulis : 3 gravillons relevés pixel par pixel sur le rip (couleurs EXACTES) tombent du pied des parois et des blocs,
  rebondissent, roulent de 4 px puis restent au sol ; 4 chutes décalées de 6 phases ;
- poussiere : 4 poses générées (6 couleurs de la planche), un nuage à chaque impact.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_couloir_violet_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_couloir_violet_v1'
STAGE = R / '.cache/fin_couloir_violet_v1/fin_couloir_violet'
NAMESPACE = 'fin_couloir_violet'
ASSET = 'fcv5_fin_couloir_violet'
PFX = 'FCV5'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_couloir_violet_v1'
ENTRY_LOT = 'source/entree_couloir_violet_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon purple '
     'rocky corridor): same mottled mauve-purple cave floor, same stacked rounded blue-violet boulders with light lilac '
     'highlights forming the walls, same dark blue streaked rock cliffs along the outer edges, same small dark round '
     'pebbles on the floor near the walls, same very dark navy-black outer void along the top, left and right borders. '
     'Make a NEW, larger top-down dungeon ending map (boss and objective cul-de-sac). WIDE LANDSCAPE 4:3 (1200x896), '
     'zoomed out so the cave feels vast. Layout: the player arrives ONLY at the SOUTH (bottom edge center) through a '
     'narrow mauve floor corridor between stacked blue-violet boulder walls; the corridor opens into a vast central oval '
     'cave arena with a few small freestanding blue-violet boulder clusters and small dark pebbles resting on the mauve '
     'floor; at the NORTH (top center), the cave is a CLOSED cul-de-sac (NO tunnel opening, continuous thick stacked '
     'boulder wall and dark streaked cliffs closing the entire top edge), and standing on the mauve floor in the '
     'northern alcove is a large stepped blue-violet rock altar/monolith pedestal. Thick stacked blue-violet boulder '
     'walls, dark streaked cliffs and very dark navy-black outer void fill the top, left and right edges completely. '
     'No characters, no crystals, no glowing runes, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (sol 7.6, roche 12.1)'},
    {'file': 'sol_complet.png', 'images': [REF_NAME], 'prompt':
     'Fill the ENTIRE image edge to edge with only the mottled mauve-purple cave floor texture from the reference image: '
     'same pixel-art mottled pattern, same palette and contrast, keep the texture detail. No boulders, no rocks, no '
     'pebbles, no walls, no dark areas. Wide landscape 4:3.',
     'essais': 'planche partagee avec ECV1 (moyenne (95.3,80.3,113.3), distance 2.1 au sol du rip)'},
    {'file': 'poussiere_poses.png', 'images': [REF_NAME], 'prompt':
     'Pixel-art sprite sheet on a flat pure magenta (#FF00FF) background: 6 animation poses of a small dust puff cloud '
     'rising when a pebble hits a cave floor, in a single horizontal row, evenly spaced, from a tiny puff to a larger '
     'spreading puff to faint dispersing wisps. Colours: mauve-purple and lilac greys taken from the reference image '
     'floor and rock highlights. Same pixel-art style as the reference. No floor, no shadows, no text.',
     'essais': 'planche partagee avec ECV1 (4 fenetres mesurees, pixels mauves loin des rochers)'},
]
# ---- Gravillons relevés sur le rip (boîte y, x, h, w de la composante de roche entourée de sol).
PEBBLES = {'petit': (113, 136, 6, 7), 'moyen': (131, 78, 7, 10), 'gros': (130, 204, 12, 12)}
# ---- Poussière : fenêtres (cx, cy, côté) sur la planche, réduction 1/8.
PUFF_WIN = [(340, 410, 120), (335, 645, 200), (335, 890, 220), (335, 1130, 220)]
PUFF_K, PUFF_COV, PUFF_COLORS = 8, 0.35, 6
# ---- Chutes : (cible x, cible y, gravillon, décalage de phase, sens du roulement). La cible est ramenée au point
# de sol le plus proche qui a une paroi ou un bloc 8 à 20 px au-dessus, à >= 24 px de l'autel.
DROPS = [(210, 160, 'moyen', 0, 1), (555, 160, 'gros', 6, -1), (190, 265, 'petit', 12, 1), (575, 265, 'moyen', 18, -1)]
FALL = [-21, -16, -9, 0]            # phases 0..3 : chute (accélérée), impact en phase 3
BOUNCE = {4: -3, 5: -1}             # rebond
ROLL = [0, 0, 0, 0, 1, 2, 3, 4]     # roulement cumulé (px) phases 0..7, puis 4 px
VISIBLE = 20                        # gravillon visible phases 0..19, absent 20..23 (boucle fermée)
PUFF_AT = {3: 0, 4: 1, 5: 2, 6: 3}  # phase -> pose de poussière
AUTEL_UPPER = (152, 242, 542, 658)  # tour supérieure de l'autel à degrés (y0, y1, x0, x1)
AUTEL_LOWER = (218, 335, 504, 696)  # socle et degrés inférieurs de l'autel (y0, y1, x0, x1)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'sol', 'ombres'], 64),
                  'roche': (['gravillons', 'blocs', 'autel', 'rochers', 'falaise'], 96),
                  'sombre': (['vide'], 16)}
STATIC = ['sol', 'ombres', 'gravillons', 'blocs', 'autel', 'rochers', 'falaise', 'vide']
ANIMS = ['eboulis', 'poussiere']


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
    """Sol mauve (r > g, rip (93.4,79.5,113.7)) et roche bleu-violet (r = g, b >> r)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    return {'sol': ((r - g) >= 6) & (lum > 55), 'roche': ((r - g) < 6) & (b - r > 20) & (lum > 45)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """Seuils mesurés sur le brut (1200 x 896) :
    sol = r-g lissé 5 px >= 6 et lum lissée > 45, fermé/ouvert 2 px, plus grande composante (> 20000 px), trous bouchés ;
    îlots = trous du sol qui ne sont pas du sol (ouverts 1 px) : blocs >= 600 px (6 amas dans l'arène), gravillons 12 à
    600 px ; autel = monolithe rocheux à degrés en saillie au nord-centre (tour y 152..242, x 542..658 ; socle et degrés
    y 218..335, x 504..696), fermé 3 px, trous bouchés, > 5000 px ; ombres = sol à lum lissée < 62 à <= 30 px d'une
    paroi / de l'autel / d'un îlot ; vide = lum lissée < 24 hors sol et hors autel, ouvert 4 px, > 3000 px, relié au
    bord de l'image ; falaise = paroi striée (gradient horizontal / vertical lissé 21 px > 1,35), fermée 6 px, > 4000 px ;
    rochers = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    L = nd.uniform_filter(lum, 5); rg = nd.uniform_filter(r - g, 5)
    floorc = (rg >= 6) & (L > 45)
    floor = keep_large(open_(close_(floorc, 2), 2), 20000)
    floor = nd.binary_fill_holes(floor)
    isl = open_(floor & ~floorc, 1)
    il, inn = nd.label(isl); sz = nd.sum(isl, il, range(1, inn + 1))
    blocs = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 600])
    grav = np.isin(il, [i + 1 for i, v in enumerate(sz) if 12 <= v < 600])
    sol = floor & ~blocs & ~grav
    wall = ~floor
    uy0, uy1, ux0, ux1 = AUTEL_UPPER
    ly0, ly1, lx0, lx1 = AUTEL_LOWER
    box_u = (yy >= uy0) & (yy <= uy1) & (xx >= ux0) & (xx <= ux1) & (lum > 35)
    box_l = (yy >= ly0) & (yy <= ly1) & (xx >= lx0) & (xx <= lx1) & wall
    autel = keep_large(nd.binary_fill_holes(close_(box_u | box_l, 3)) & wall, 5000)
    db = nd.distance_transform_edt(~(wall | blocs | grav))
    omb = sol & (L < 62) & (db <= 30)
    omb = open_(close_(omb, 2), 1) & sol
    vide = keep_large(open_((L < 24) & wall & ~autel, 4), 3000)
    lab, _ = nd.label(vide); edge = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])
    vide = np.isin(lab, edge[edge > 0])
    gx, gy = np.abs(nd.sobel(lum, 1)), np.abs(nd.sobel(lum, 0))
    an = nd.uniform_filter(gx, 21) / (nd.uniform_filter(gy, 21) + 1)
    fal = keep_large(close_((an > 1.35) & wall & ~vide & ~autel, 6), 4000) & wall & ~vide & ~autel
    roc = wall & ~vide & ~fal & ~autel
    masks = dict(autel=autel, gravillons=grav, blocs=blocs, ombres=omb & ~grav & ~blocs, sol=sol & ~omb,
                 vide=vide, falaise=fal, rochers=roc)
    ys_, xs_ = np.nonzero(autel)
    seg = {'autel_y': [int(ys_.min()), int(ys_.max())], 'autel_x': [int(xs_.min()), int(xs_.max())],
           'blocs': int(sum(v >= 600 for v in sz)), 'gravillons': int(sum(12 <= v < 600 for v in sz)),
           'ombres_lum': round(float(lum[masks['ombres']].mean()), 1), 'sol_lum': round(float(lum[masks['sol']].mean()), 1)}
    return masks, seg


# ---------------------------------------------------------------- gravillons exacts du rip
def rip_pebbles(ref):
    """Composante de roche (r - g < 6, 8-connexe) entièrement entourée de sol, couleurs EXACTES, fond transparent."""
    floor = (ref[..., 0] - ref[..., 1]) >= 6
    lab, _ = nd.label(~floor, structure=np.ones((3, 3))); out = {}
    for name, (y, x, h, w) in PEBBLES.items():
        sl = (slice(y, y + h), slice(x, x + w)); ids = np.unique(lab[sl][~floor[sl]])
        assert len(ids) == 1, (name, ids)
        m = lab[sl] == ids[0]
        ring = nd.binary_dilation(lab == ids[0], structure=np.ones((3, 3))) & (lab != ids[0])
        assert floor[ring].all(), name
        spr = np.zeros((h, w, 4), 'uint8'); spr[..., :3] = ref[sl]; spr[..., 3] = m * 255; spr[~m] = 0
        out[name] = spr
    return out


# ---------------------------------------------------------------- poussière (poses générées)
def puff_poses(path):
    s = rgb(path); r, g, b = s.transpose(2, 0, 1)
    bg = (r - g > 60) & (b - g > 60)
    near_rock = nd.binary_dilation(~bg & ((b - r) >= 40), iterations=3)
    masks = []
    for cx, cy, side in PUFF_WIN:
        y0, x0 = cy - side // 2, cx - side // 2; sl = (slice(y0, y0 + side), slice(x0, x0 + side))
        w = s[sl]; m = ~bg[sl] & ((w[..., 0] - w[..., 1]) >= 10) & ((w[..., 2] - w[..., 0]) < 40) & ~near_rock[sl]
        m = nd.binary_opening(m, iterations=1)
        l, n = nd.label(nd.binary_dilation(m, iterations=2)); ss = nd.sum(m, l, range(1, n + 1))
        m &= np.isin(l, [k + 1 for k, v in enumerate(ss) if v >= 40])
        m = nd.binary_fill_holes(nd.binary_closing(m, iterations=2)) & ~bg[sl]      # reflets clairs rendus au nuage
        masks.append((sl, m))
    px = np.concatenate([s[sl][m] for sl, m in masks])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=PUFF_COLORS, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:PUFF_COLORS * 3], float).reshape(-1, 3)
    poses = []
    for sl, m in masks:
        w = s[sl].astype(float); side = m.shape[0]; n = side // PUFF_K; k = PUFF_K
        mm = m[:n * k, :n * k]; ww = w[:n * k, :n * k]
        blk = mm.reshape(n, k, n, k); cov = blk.mean((1, 3))
        col = (ww * mm[..., None]).reshape(n, k, n, k, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
        o = np.zeros((n, n, 4), 'uint8'); o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
        o[..., 3] = 255; o[cov < PUFF_COV] = 0
        ys, xs = np.nonzero(o[..., 3]); o = o[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
        poses.append(o)
    return poses, pal


def paste(frame, spr, x0, y0):
    hh, ww = spr.shape[:2]; x0, y0 = int(x0), int(y0)
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def landing_spots(ground, wall, autel):
    """Point de sol le plus proche de chaque cible : 6 x 3 px de sol autour, paroi en (x, y-8) et (x, y-20), >= 24 px de l'autel."""
    ok = nd.minimum_filter(ground.astype(np.uint8), size=(3, 13), origin=(-1, 0)) > 0      # sol en y..y+2, x-6..x+6
    ok &= np.roll(wall, 8, 0) & np.roll(wall, 20, 0)                                         # paroi en y-8 et y-20
    ok &= nd.distance_transform_edt(~autel) >= 24
    ok[:24] = False; ok[:, :8] = False; ok[:, -8:] = False; ok[-4:] = False
    ys, xs = np.nonzero(ok); spots = []
    for tx, ty, name, off, sens in DROPS:
        i = int(((xs - tx) ** 2 + (ys - ty) ** 2).argmin())
        spots.append((int(xs[i]), int(ys[i]), name, off, sens))
    return spots


def pebble_state(u, sens):
    """Position relative (dx, dy) du gravillon à la phase locale u, None si absent."""
    if u >= VISIBLE:
        return None
    dy = FALL[u] if u < len(FALL) else BOUNCE.get(u, 0)
    dx = sens * ROLL[min(u, len(ROLL) - 1)]
    return dx, dy


def anim_frames(pebbles, puffs, spots, ts=range(PHASES)):
    peb, dust = [], []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8'); d = np.zeros((H, W, 4), 'uint8')
        for x, y, name, off, sens in spots:
            u = (t - off) % PHASES; spr = pebbles[name]; st = pebble_state(u, sens)
            if u in PUFF_AT:
                p = puffs[PUFF_AT[u]]; ph, pw = p.shape[:2]
                paste(d, p, x - pw // 2, y + spr.shape[0] // 2 - ph + 2)
            if st:
                paste(a, spr, x - spr.shape[1] // 2 + st[0], y - spr.shape[0] // 2 + st[1])
        peb.append(a); dust.append(d)
    return peb, dust


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Couloir violet V1 (FCV5)')
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
    o.update(Name={'DefaultText': 'Fin Couloir violet - salle de boss/objectif (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur le rip Couloir rocheux violet (associee a ECV1) ; '
                     'eboulis animes (gravillons exacts du rip), poussiere generee. Sans sortie.')
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
  <Name>Fin Couloir violet 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon (cul-de-sac de boss et d'objectif) prolongeant l'entree ECV1, couloir rocheux violet, arene centrale et autel rocheux a degres au nord, eboulis et poussiere animes. Pas une aventure jouable.</Description>
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
    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['autel', 'gravillons', 'blocs', 'ombres', 'sol', 'vide', 'falaise', 'rochers']
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
    cand = ex['sol'] | ex['ombres'] | ex['gravillons']
    cl, _ = nd.label(cand); seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    pebbles = rip_pebbles(ref)
    puffs, puff_pal = puff_poses(RAW / 'poussiere_poses.png')
    for name, p in pebbles.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_gravillon_{name}.png')
    for i, p in enumerate(puffs):
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_poussiere_{i}.png')
    spots = landing_spots(ex['sol'] | ex['ombres'], ex['rochers'] | ex['blocs'] | ex['falaise'], ex['autel'])
    eboulis, poussiere = anim_frames(pebbles, puffs, spots)
    anim = {'eboulis': eboulis, 'poussiere': poussiere}
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
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    # Boss au centre de l'arène ; objectif au nord devant les degrés de l'autel rocheux.
    free2x2 = [(r, c) for r in range(4, gh_ - 4) for c in range(4, gw_ - 4)
               if not blocked[r:r + 2, c:c + 2].any() and walk[r*8:r*8+16, c*8:c*8+16].all()]
    br, bc = min(free2x2, key=lambda rc: (rc[0] - 46) ** 2 + (rc[1] - gw_ // 2) ** 2)
    boss_px = [bc * 8, br * 8]
    ays, axs = np.nonzero(ex['autel'])
    ac_target = int(round(axs.mean())) // 8 - 1
    ar_target = int(ays.max()) // 8 + 1
    or_, oc = min((rc for rc in free2x2 if rc[0] >= ar_target),
                  key=lambda rc: (rc[0] - ar_target) ** 2 * 4 + (rc[1] - ac_target) ** 2)
    objectif_px = [oc * 8, or_ * 8]
    reach_eb, exp_eb = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_bo, exp_bo = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_eb and reach_bo, 'pas de chemin 16x16'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)),
                        (boss_px, (255, 60, 220, 255)),
                        (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    for x, y, *_ in spots:
        dr.ellipse([x - 3, y - 3, x + 3, y + 3], outline=(255, 255, 255, 255))
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sprites = [pebbles[k] for k in PEBBLES] + puffs; cw = 26 * 6 + 8
    sheet = Image.new('RGBA', (len(sprites) * cw + 8, cw + 8), (94, 80, 114, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr); im = im.resize((im.width * 6, im.height * 6), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_couloir_violet_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sol', 'sol'), ('roche', 'rochers'), ('roche', 'blocs'), ('roche', 'autel')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_couloir_violet_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'type_carte': 'fin_donjon_cul_de_sac_boss_objectif_sans_sortie',
        'entree_associee': {'lot': ENTRY_LOT, 'prefix': 'ECV1', 'reference_da': REF_NAME},
        'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'fin du couloir rocheux violet : arene centrale semee de 6 blocs et autel rocheux a degres au fond nord (associee a ECV1)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet, sol complet '
                  'et planche de poussiere generes avec le rip en reference',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Couloir rocheux violet (titre de l audit zones_bg_audit_v1 ; jeu et scene non confirmes)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'sol_complet': round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid['sol']['rip_rgb']))), 1),
                         'eboulis': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'ombres': 'calque ombres = sol du rendu assombri au pied des parois, de l autel et des blocs (separe, pas invente)',
        'layers': layer_list,
        'eboulis': {'gravillons_rip': {k: list(v) for k, v in PEBBLES.items()},
                    'gravillons_source': 'rip, composante de roche 8-connexe entierement entouree de sol ; pixels et couleurs EXACTS',
                    'chutes': [list(s) for s in spots], 'cibles': [list(d) for d in DROPS], 'chute_dy': FALL,
                    'rebond_dy': {str(k): v for k, v in BOUNCE.items()}, 'roulement_px': ROLL, 'visible_phases': VISIBLE,
                    'phases': PHASES, 'frame_length_ticks': TICKS,
                    'origine': 'dessin EXACT du rip ; chute, rebond, roulement et placement crees par nous'},
        'poussiere': {'fenetres': [list(w) for w in PUFF_WIN], 'reduction': f'x1/{PUFF_K}', 'couverture_min': PUFF_COV,
                      'palette': [[int(round(c)) for c in p] for p in puff_pal], 'phase_vers_pose': {str(k): v for k, v in PUFF_AT.items()},
                      'fond': 'magenta pur et pixels teintes de magenta exclus ; rochers de la planche exclus (b-r >= 40, marge 3 px)',
                      'origine': 'dessin GENERE (6 couleurs tirees de la planche partagee avec ECV1) ; placement et cadence crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'sortie': 'aucune (cul-de-sac de fin de donjon)',
                   'path_found_16x16': bool(reach_eb and reach_bo),
                   'path_entry_to_boss_16x16': reach_eb, 'path_boss_to_objectif_16x16': reach_bo,
                   'cells_explored': max(exp_eb, exp_bo),
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (sol, ombres, gravillons relies au bord sud) ; bords nord, ouest et est fermes'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()), 'seg': seg, 'spots': spots,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
