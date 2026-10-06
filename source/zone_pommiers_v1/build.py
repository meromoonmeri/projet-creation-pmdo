"""Zone Pommiers (ZPO1) — bois aux pommes D05P11A : verger, chemin de sable, arche de pierre au nord, 4:3 (768 x 576).

.venv/bin/python source/zone_pommiers_v1/build.py

Référence `reference/d05p11a_port.png` (552 x 408) : bois aux pommes du port PMD-SKY-PMDO-PORT (preview
D05P11A) : allée de sable, prairie verte, pommiers ronds à pommes rouges, rochers gris, arche de pierre.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ, comme les lots 4:3 de la série :
- decor.png : arrivée au sud sur le chemin de sable, clairière ronde au centre, pommiers chargés de pommes
  des deux côtés, arche de pierre au nord ; premier essai, conforme ;
- sol_complet.png : herbe de prairie seule (3 essais vides avec la référence, conforme sans référence) ;
- vfx.png : planche de pollen doré, pétales et brisures de feuilles générée sur fond noir ; le pollen
  découpe ses sprites dedans (échantillonnage au plus proche, alpha binaire), pas de pixels exacts : effet AGENT.
Pas de témoin : segmentation directe du décor (couleurs + géométrie).
Calques : sol complet, chemin, herbe, fleurs, rochers, pommiers, arche, pommes (anim), pollen (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- pommes : 8 pommes qui tombent des pommiers sur l'herbe en se balançant (2 poses 8 x 8 découpées dans le
  décor, couleurs exactes), se posent 6 phases puis s'effacent ; même chute à chaque boucle, exacte ;
- pollen : 12 grains de pollen doré (8 points + 4 pétales découpés dans vfx.png) qui dérivent au-dessus du
  verger, les points montent doucement, les pétales descendent en se balançant.
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
REF_NAME = 'd05p11a_port.png'
REF = HERE / 'reference' / REF_NAME
LOT = 'zone_pommiers_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'zone_pommiers'
NAMESPACE = 'zone_pommiers'
ASSET = 'zpo1_zone_pommiers'
PFX = 'ZPO1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery '
     'Dungeon apple woods): same sandy winding path, same green meadow grass with small tufts, same round apple trees '
     'with red apples, same grey rocks, same small bushes. Make a NEW, larger top-down zone map. WIDE LANDSCAPE 4:3, '
     'target 1200 by 896 pixels, zoomed out so the orchard feels vast. Layout: the player arrives at the SOUTH (bottom '
     'edge center) on the sandy path; the path winds north and opens onto a WIDE round grassy clearing in the CENTER; '
     'apple trees with red apples stand densely on both sides of the clearing; a few rocks and bushes dot the grass; '
     'at the NORTH (top center) the path continues to an old mossy stone arch between two big apple trees. No falling '
     'apples, no floating pollen, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (distances à la référence dans le manifeste)'},
    {'file': 'sol_complet.png', 'images': [],
     'prompt': 'A seamless green meadow grass pixel-art texture filling the whole image, 4:3 landscape, top-down retro '
     'game background: mid-green grass with small darker and lighter tufts and speckles, no objects, no characters, '
     'no text.',
     'essais': '3 essais vides avec la preview en référence (réponse sans image) ; conforme sans référence, tons herbacés'},
    {'file': 'vfx.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Pixel-art visual effects sheet on a PURE BLACK background, nothing else: about twenty small warm glowing '
     'pollen grains (yellow-white dots with soft halos), a few small pink-white apple blossom petals, and a few tiny '
     'green leaf flecks. Same warm spring palette as sunlight through an orchard. Scattered across the frame with black '
     'space between them, no ground, no trees, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; planche AGENT sur fond noir, sprites découpés au seuil somme >= 60'},
]
# ---- Fidélité : paires de pixels vérifiées (référence D05P11A 552 x 408, décor 1200 x 896).
FID_PAIRS = [('sable', (300, 60), (514, 598)), ('herbe_claire', (180, 60), (176, 840)),
             ('arbre_sombre', (60, 60), (146, 88)), ('herbe_vive', (60, 300), (4, 98))]
# ---- Pommes : 8 pommes, chute de 20 phases (2 px par phase), posées 6 phases, boucle exacte de 48 phases.
N_APPLES = 8
APPLE_FALL = 20
APPLE_REST = 6
APPLE_BOX = (270, 173, 294, 197)
APPLE_SIZE = (8, 8)
# ---- Pollen : 8 points qui montent + 4 pétales qui descendent, sprites découpés dans vfx.png.
DOT_BBOX = (474, 507, 507, 540)
DOT_SIZE = (6, 6)
PETAL_BBOX = (495, 56, 544, 102)
PETAL_SIZE = (9, 8)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'chemin', 'herbe'], 64), 'detail': (['fleurs', 'rochers'], 32),
                  'bois': (['pommiers', 'arche'], 96)}
STATIC = ['chemin', 'herbe', 'fleurs', 'rochers', 'pommiers', 'arche']
ANIMS = ['pommes', 'pollen']
DRAW_ORDER = ['sol_complet', 'chemin', 'herbe', 'fleurs', 'rochers', 'pommiers', 'arche', 'pommes', 'pollen']


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


# ---------------------------------------------------------------- fidélité (paires de pixels vérifiées)
def fidelity(decor, ref):
    out = {}
    for k, (rx, ry), (dx, dy) in FID_PAIRS:
        out[k] = {'rip_rgb': [int(v) for v in ref[ry, rx]], 'decor_rgb': [int(v) for v in decor[dy, dx]],
                  'rip_xy': [rx, ry], 'decor_xy': [dx, dy],
                  'distance': round(float(np.linalg.norm(ref[ry, rx].astype(float) - decor[dy, dx].astype(float))), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution (sans témoin)
def classify(a):
    """Seuils mesurés sur le brut 1200 x 896 : sable = r > 150, g < r, r - b > 50 (tient l'ombre de l'arche),
    relié au bord sud ; pierre = |r-g| < 30, lum 70-210, g-b < 60, hors brun (les troncs piégeaient la règle) ;
    arche = pierre dans le rectangle nord (y < 235, x 430-770), composantes >= 150 px ; canopée = vert
    (g > r + 20, g > b, lum > 45) sur les côtés et en haut (x < 440, x > 760 ou y < 265, hors abords de l'arche),
    coeur r > 1.6 b ou texture > 16 ou lum < 100, dilaté 3 x 12 px dans le vert, composantes >= 800 px ;
    pommiers = canopée + brun (troncs) et rouge (pommes, r-g > 90) adjacents ; rochers = pierre et brun isolés
    (composantes >= 25 px) hors arche et pommiers ; fleurs = rose et blanc hors sable, >= 3 px ;
    herbe = tout le reste (partition exacte)."""
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a); sd = sdev(lum, 9)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    sand = (r > 150) & (g < r) & (r - b > 50)
    lab, _ = nd.label(sand); e = np.unique(lab[-1][lab[-1] > 0]); chemin = np.isin(lab, e)
    brown = (r > 80) & (r - g > 15) & (r - b > 40) & (lum < 160) & ~sand
    red = (r > 150) & (r - g > 90) & (g < 120) & (b < 100)
    stone = (np.abs(r - g) < 30) & (lum > 70) & (lum < 210) & (g - b < 60) & ~sand & ~brown
    veg = (g > r + 20) & (g > b) & (lum > 45) & ~sand & ~red
    side = ((xx < 440) | (xx > 760) | (yy < 265)) & ~((xx > 470) & (xx < 730) & (yy < 240))
    core = keep_large(veg & side & ((r > b * 1.6) | (sd > 16) | (lum < 100)), 500)
    canopy = core
    for _ in range(3):
        canopy = canopy | (veg & side & nd.binary_dilation(canopy, iterations=12))
    canopy = keep_large(canopy, 800)
    pomm = canopy | (brown & nd.binary_dilation(canopy, iterations=12)) | \
        (red & nd.binary_dilation(canopy, iterations=10))
    arche = keep_large(stone & (yy < 235) & (xx > 430) & (xx < 770), 150)
    roch = keep_large(((stone & ~arche) | (brown & ~pomm)) & ~arche & ~pomm, 25)
    pink = (r > 195) & (b > 185) & (g < 160) & (r - g > 50) & ~sand
    white = (lum > 230) & (np.abs(r - g) < 30) & (g - b < 40) & ~sand
    fleur = keep_large((pink | white) & ~pomm & ~arche & ~chemin, 3)
    herbe = ~(chemin | arche | roch | pomm | fleur)
    ay, ax = np.nonzero(arche)
    masks = dict(chemin=chemin, herbe=herbe, fleurs=fleur, rochers=roch, pommiers=pomm, arche=arche)
    seg = {'chemin_pct': round(float(chemin.mean() * 100), 1), 'pommiers_composantes': int(nd.label(pomm)[1]),
           'pommes_statiques_px': int(red.sum()), 'rochers_composantes': int(nd.label(roch)[1]),
           'fleurs_composantes': int(nd.label(fleur)[1]), 'arche_y': [int(ay.min()), int(ay.max())],
           'arche_x': [int(ax.min()), int(ax.max())]}
    return masks, seg


# ---------------------------------------------------------------- sprites (pomme du décor, pollen de vfx.png)
def vfx_sprite(path, bbox, size):
    v = np.array(Image.open(path).convert('RGB')).astype(int)
    x0, y0, x1, y1 = bbox
    crop = v[y0:y1 + 1, x0:x1 + 1]
    m = crop.sum(-1) >= 60
    sp = np.zeros((*m.shape, 4), 'uint8'); sp[m, :3] = crop[m]; sp[m, 3] = 255
    return np.array(Image.fromarray(sp).resize(size, Image.Resampling.NEAREST))


def apple_sprites(decor):
    x0, y0, x1, y1 = APPLE_BOX
    crop = decor[y0:y1 + 1, x0:x1 + 1]
    r, g, b = crop[..., 0], crop[..., 1], crop[..., 2]
    m = (r > 150) & (r - g > 90) & (g < 120) & (b < 100)
    sp = np.zeros((*m.shape, 4), 'uint8'); sp[m, :3] = crop[m]; sp[m, 3] = 255
    im = Image.fromarray(sp).resize(APPLE_SIZE, Image.Resampling.NEAREST)
    return [np.array(im), np.array(im.transpose(Image.FLIP_LEFT_RIGHT))]


# ---------------------------------------------------------------- pommes qui tombent (couleurs exactes du décor)
def apple_frames(grass_vis, trees_m, spr, rng):
    fall_h = 2 * APPLE_FALL
    edge = grass_vis & nd.binary_dilation(trees_m, iterations=12) & ~nd.binary_dilation(~grass_vis, iterations=3)
    edge[H - 100:] = False
    ys, xs = np.nonzero(edge); apples = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x] or y + fall_h + 5 >= H or not (6 <= x < W - 12):
            continue
        if grass_vis[y:y + fall_h + 4, max(0, x - 4):x + 10].mean() < 0.95:
            continue
        apples.append({'depart': [x, y], 'phase': int(rng.integers(PHASES)), 'sens': int(rng.choice([-1, 1]))})
        taken[max(0, y - 30):y + 30, max(0, x - 30):x + 30] = True
        if len(apples) == N_APPLES:
            break
    assert len(apples) == N_APPLES, f'pommes placées : {len(apples)}'
    frames = []
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for ap in apples:
            k = (t - ap['phase']) % PHASES
            if k >= APPLE_FALL + APPLE_REST:
                continue
            kk = min(k, APPLE_FALL - 1)
            x = ap['depart'][0] + int(round(ap['sens'] * 4 * np.sin(2 * np.pi * kk / 10)))
            y = ap['depart'][1] + 2 * kk

            sp = spr[0] if k >= APPLE_FALL else spr[(kk // 3) % 2]      # se retourne en tombant, à plat au sol
            mm = sp[..., 3] > 0; e[y:y + 8, x:x + 8][mm] = sp[mm]
        e[~grass_vis] = 0
        frames.append(e)
    return frames, apples


# ---------------------------------------------------------------- pollen (sprites exacts de vfx.png)
def mote_state(g, t):
    """(x, y, pose) du grain g à la phase t ; les points montent, les pétales descendent."""
    u = (t + g['phase']) % PHASES
    if g['forme'] == 'point':
        x = g['x'] + int(round(g['ax'] * np.sin(2 * np.pi * u / 24))); y = g['y'] - u // 4
        return x, y, 0
    x = g['x'] + int(round(g['ax'] * np.sin(2 * np.pi * u / 16))); y = g['y'] + u // 3
    return x, y, (u // 12) % 2


def place_motes(grass_vis, rng):
    m = grass_vis.copy(); m[:10, :] = m[-40:, :] = False; m[:, :10] = m[:, -10:] = False
    ys, xs = np.nonzero(m); out = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[max(0, y - 22):y + 23, max(0, x - 22):x + 23].any():
            continue
        n = len(out)
        out.append({'x': x, 'y': y, 'forme': 'point' if n < 8 else 'petale',
                    'phase': (n * 6) % PHASES if n < 8 else (n * 12 + 3) % PHASES,
                    'ax': 2 + (n % 3)})
        taken[max(0, y - 22):y + 23, max(0, x - 22):x + 23] = True
        if len(out) == 12:
            break
    assert len(out) == 12, f'grains placés : {len(out)}'
    return out


def mote_frames(motes, dot, petals):
    frames = []
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for g in motes:
            x, y, pose = mote_state(g, t)
            sp = dot if g['forme'] == 'point' else petals[pose]
            h, w = sp.shape[:2]; x0, y0 = x - w // 2, y - h // 2
            if not (0 <= x0 and 0 <= y0 and x0 + w < W and y0 + h < H):
                continue
            mm = sp[..., 3] > 0; e[y0:y0 + h, x0:x0 + w][mm] = sp[mm]
        frames.append(e)
    return frames


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Zone Pommiers (ZPO1)')
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
    o.update(Name={'DefaultText': 'Zone Pommiers - verger D05P11A (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur la preview D05P11A (bois aux pommes) ; '
                     'pommes qui tombent (calculees, couleurs exactes du decor), pollen decoupe dans la planche '
     'VFX generee. Clairiere, pommiers, arche de pierre au nord. Marqueurs d edition, sans warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': "Arrivée, clairière et objectif (repères d'édition)", 'Visible': True, 'MapChars': [],
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
  <Name>Zone Pommiers ZPO1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Clairiere et pommiers, arche de pierre au nord, pommes et pollen animes. Projet de carte, sans warp.</Description>
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
    order = ['arche', 'pommiers', 'rochers', 'fleurs', 'herbe', 'chemin']
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
    cand = ex['chemin'] | ex['herbe'] | ex['fleurs']
    cl, _ = nd.label(close_(cand, 2)); seed = cl[H - 1][cand[H - 1]]   # liserés < 4 px franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    spr = apple_sprites(a)
    for i, sp in enumerate(spr):
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_pomme_{i}.png')
    dot = vfx_sprite(RAW / 'vfx.png', DOT_BBOX, DOT_SIZE)
    petal = vfx_sprite(RAW / 'vfx.png', PETAL_BBOX, PETAL_SIZE)
    petals = [petal, np.array(Image.fromarray(petal).transpose(Image.FLIP_LEFT_RIGHT))]
    Image.fromarray(dot).save(OUT / 'poses' / f'{PFX}_pollen_point.png')
    for i, sp in enumerate(petals):
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_pollen_petale_{i}.png')
    rng = np.random.default_rng(5)
    grass_vis = ex['chemin'] | ex['herbe'] | ex['fleurs']
    pommes, apples = apple_frames(grass_vis, ex['pommiers'], spr, rng)
    motes = place_motes(grass_vis, rng)
    pollen = mote_frames(motes, dot, petals)
    anim = {'pommes': pommes, 'pollen': pollen}
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
    okgrid = np.zeros((gh_, gw_), bool)          # objectif : case atteignable la plus proche de l'arche
    for ay in range(gh_ - 1):
        for ax in range(gw_ - 1):
            okgrid[ay, ax] = not blocked[ay:ay + 2, ax:ax + 2].any()
    seen = np.zeros((gh_, gw_), bool); queue = [(entry_px[1] // 8, entry_px[0] // 8)]; seen[queue[0]] = True
    for ay, ax in queue:
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = ay + dy, ax + dx
            if 0 <= ny < gh_ and 0 <= nx < gw_ and okgrid[ny, nx] and not seen[ny, nx]:
                seen[ny, nx] = True; queue.append((ny, nx))
    dys, dxs = np.nonzero(ex['arche'])
    ty, tx = int(dys.max()) // 8 + 1, int(round(dxs.mean())) // 8
    ry, rx = np.nonzero(seen)
    bi = int(np.argmin((ry - ty) ** 2 + (rx - tx) ** 2))
    objectif = [int(rx[bi]) * 8, int(ry[bi]) * 8]
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
    # Planche : poses des pommes et du pollen, sur vert sombre.
    sheet = Image.new('RGBA', (2 * 80 + 3 * 90 + 40, 110), (43, 87, 55, 255))
    sheet.alpha_composite(Image.fromarray(spr[0]).resize((64, 64), Image.Resampling.NEAREST), (10, 10))
    sheet.alpha_composite(Image.fromarray(spr[1]).resize((64, 64), Image.Resampling.NEAREST), (90, 10))
    sheet.alpha_composite(Image.fromarray(dot).resize((48, 48), Image.Resampling.NEAREST), (180, 18))
    for j, sp in enumerate(petals):
        sheet.alpha_composite(Image.fromarray(sp).resize((72, 64), Image.Resampling.NEAREST), (250 + j * 90, 14))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_zone_pommiers_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, ref)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': 'Zone Pommiers — verger D05P11A', 'prefix': PFX, 'namespace': NAMESPACE,
        'asset': ASSET, 'type': 'zone de donjon / verger', 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': 'poursuivre les zones (album 908) ; les VFX sont générés par l agent, pas en pixels exacts',
        'agent_choices': {
            'reference': 'preview D05P11A du port PMD-SKY-PMDO-PORT (bois aux pommes)',
            'layout': 'arrivée au sud sur le chemin de sable, clairière ronde au centre, arche de pierre au nord',
            'prefix': 'ZPO1 (zone pommiers 1), libre dans le dépôt',
            'vfx': 'pommes découpées dans le décor, pollen découpé dans la planche vfx.png générée',
            'biome': 'bois aux pommes D05P11A ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition ZPO1 générée avec la référence en images='},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
                    'size_px': list(SRC), 'role': 'herbe de prairie seule, base sous la composition opaque'},
                   {'file': f'source/{LOT}/bruts/vfx.png', 'sha256': sha(RAW / 'vfx.png'),
                    'size_px': list(Image.open(RAW / 'vfx.png').size),
                    'role': 'planche VFX générée sur fond noir (pollen, pétales)'},
                   {'file': f'source/{LOT}/reference/{REF_NAME}', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'preview D05P11A : matière de référence'}],
        'normalization': {'methode': 'BOX uniforme 0.642857 + recadrage 1 px ; palettes par groupes (sol 64, détail 32, bois 96), sans tramage ; pommes du décor, pollen de vfx.png',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'recalage': {'methode': 'sans témoin : segmentation directe (couleurs + géométrie), pas de recalage'},
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': 'paires de pixels vérifiées preview D05P11A / brut ; distance euclidienne ; seuil 35'},
        'layers': layer_list,
        'pommes': {'phases': PHASES, 'frame_length_ticks': TICKS, 'chute': APPLE_FALL, 'au_sol': APPLE_REST,
                   'nombre': len(apples), 'placements': apples,
                   'loi': 'k = (t - phase) mod 48 ; chute k < 20 : y = y0 + 2k, x = x0 + sens 4 sin(2 pi k / 10), pose alternee toutes les 3 phases ; posee 6 phases puis effacee ; meme trajet a chaque boucle',
                   'origine': 'calcule ; 2 poses 8x8 (originale + miroir), couleurs exactes de la pomme du decor'},
        'pollen': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(motes),
                   'placements': motes,
                   'loi': 'points : y = y0 - u//4, x = x0 + ax sin(2 pi u / 24) ; pétales : y = y0 + u//3, x = x0 + ax sin(2 pi u / 16), pose alternee toutes les 12 phases ; u = (t + phase) mod 48',
                   'origine': 'grains calcules, sprites exacts de vfx.png (point 6x6, pétale 9x8 + miroir)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors chemin, herbe et fleurs (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition générée référencée, pas de tuiles natives certifiées ; les pommes reprennent des couleurs exactes du décor, le pollen est découpé dans la planche VFX générée.',
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
