"""Zone Cristal (ZCR1) — grotte de cristal D17P11A : arène de glace, Flaques lumineuses, grand cristal au nord, 4:3 (768 x 576).

.venv/bin/python source/zone_cristal_v1/build.py

Référence `reference/d17p11a_port.png` (600 x 480) : grotte de cristal du port PMD-SKY-PMDO-PORT (preview
D17P11A) : sol de glace bleue, Flaques lumineuses, grand cristal pâle au nord, murs de roche bleu-gris.
(NB : le fichier `output/Previews/d10p41a.png` du dépôt contient un couloir marron, pas la grotte ; la vraie
grotte de cristal est `d17p11a.png`. Le décor a été généré avec le bon visuel en tête et colle à D17P11A.)
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ, comme les lots 4:3 de la série :
- decor.png : arrivée au sud sur la glace, vaste arène de glace ronde au centre avec Flaques lumineuses,
  cristaux et rocailles sur les côtés, grand cristal pâle sur son autel au nord ; premier essai, conforme ;
- sol_complet.png : glace bleue seule ; premier essai, conforme ;
- vfx.png : planche d'étincelles et halos générée sur fond noir ; les scintillements découpent leurs sprites
  dedans (échantillonnage au plus proche, alpha binaire), pas de pixels exacts du rip : effet AGENT.
Pas de témoin : segmentation directe du décor (couleurs + géométrie).
Calques : sol complet, glace, flaques, murs, cristaux, grand cristal, scintillements (anim), lueurs (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- scintillements : 12 étincelles (sprites S/M découpés dans vfx.png) qui naissent, grandissent et meurent
  (16 phases visibles, décalage propre) sur le grand cristal, les cristaux et les flaques ; boucle exacte ;
- lueurs : halos autour des flaques et du grand cristal, rampe de 8 bleus EXACTS du décor, qui « respirent »
  (décalage de +-2 crans, sinusoïde de période 48).
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
REF_NAME = 'd17p11a_port.png'
REF = HERE / 'reference' / REF_NAME
LOT = 'zone_cristal_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'zone_cristal'
NAMESPACE = 'zone_cristal'
ASSET = 'zcr1_zone_cristal'
PFX = 'ZCR1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery '
     'Dungeon crystal grotto): same deep blue icy cave floor with lighter blue glowing puddles, same huge pale ice '
     'crystal with an altar at the north, same clusters of white and ice-blue crystals, same dark blue-grey rock '
     'walls with stalactites all around, same small rock pebbles. Make a NEW, larger top-down zone map. WIDE '
     'LANDSCAPE 4:3, target 1200 by 896 pixels, zoomed out so the grotto feels vast. Layout: the player arrives at '
     'the SOUTH (bottom edge center) on an icy path; the path opens onto a WIDE round icy arena in the CENTER with '
     'glowing blue puddles; crystal clusters and pebbles stand at the sides of the arena; at the NORTH (top center) '
     'the huge pale crystal with its altar, the ice leading right up to it; dark rock walls with stalactites close '
     'the map on all sides. No floating sparkles, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (distances à la référence dans le manifeste)'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Fill the ENTIRE image edge to edge, WIDE LANDSCAPE 4:3, target 1200 by 896 pixels, with only the deep '
     'blue icy cave floor texture from the reference image: same deep blue ice colour, same subtle frozen speckle and '
     'faint lighter streaks, keep the texture detail, nothing else. No puddles, no crystals, no rocks, no walls, no '
     'dark areas, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; glace bleue seule, conforme'},
    {'file': 'vfx.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Pixel-art visual effects sheet on a PURE BLACK background, nothing else: about twenty small white and '
     'ice-blue four-pointed sparkle crosses of various sizes (3 to 9 pixels), a few soft round pale-blue glow orbs, '
     'and a few tiny sharp crystal shard glints. Same ice-blue and white palette as the reference crystals. Scattered '
     'across the frame with black space between them, no ground, no walls, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; planche AGENT sur fond noir, sprites découpés au seuil somme >= 60'},
]
# ---- Fidélité : paires de pixels vérifiées (référence D17P11A 600 x 480, décor 1200 x 896).
FID_PAIRS = [('cristal_pale', (300, 60), (624, 186)), ('cristal_moyen', (300, 150), (682, 166)),
             ('mur', (100, 100), (38, 520)), ('glace', (300, 250), (478, 384)),
             ('glace_sombre', (300, 320), (472, 382))]
# ---- Lueurs : rampe de 8 bleus EXACTS du décor (du sombre au lumineux), halos autour des flaques et du cristal.
GLOW_RAMP = [(26, 145, 208), (32, 168, 224), (40, 174, 231), (41, 217, 235), (56, 227, 243), (86, 209, 245),
             (134, 243, 249), (216, 255, 255)]
BREATH = 2
# ---- Scintillements : 12 étincelles, 16 phases visibles (S 4 + M 8 + S 4), boucle exacte de 48 phases.
N_SPARK = 12
SPARK_VIS = 16
SPARK_BBOX_S = (11, 5, 82, 76)
SPARK_BBOX_M = (339, 158, 445, 263)
SPARK_SIZE_S = (12, 12)
SPARK_SIZE_M = (18, 18)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'glace': (['sol_complet', 'glace', 'flaques'], 64), 'roche': (['murs'], 48),
                  'cristal': (['cristaux', 'grand_cristal'], 64)}
STATIC = ['glace', 'flaques', 'murs', 'cristaux', 'grand_cristal']
ANIMS = ['scintillements', 'lueurs']
DRAW_ORDER = ['sol_complet', 'glace', 'flaques', 'murs', 'cristaux', 'grand_cristal', 'scintillements', 'lueurs']


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
        mr, md = ref[ry, rx].astype(float), decor[dy, dx].astype(float)
        out[k] = {'rip_rgb': [int(v) for v in ref[ry, rx]], 'decor_rgb': [int(v) for v in decor[dy, dx]],
                  'rip_xy': [rx, ry], 'decor_xy': [dx, dy],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution (sans témoin)
def classify(a):
    """Seuils mesurés sur le brut 1200 x 896 : pâle = g > 160, b > 190, lum > 115 (flaques + cristal) ;
    cristal moyen = lum > 90, b - r > 50, g - r > 30 ; sombre = lum < 135, b > r + 10 ;
    grand cristal = (pâle | moyen | sombre proche) dans le rectangle nord (y < 345, x 440-760), relié à la
    graine (600, 150) ; flaques = pâle dans la région d'arène (x 300-900, y 350-650), composantes >= 150 px ;
    glace = b - r > 70, b - g > 30, lum > 45, écart-type 9 px < 18 (lisse), hors monument et flaques,
    composantes >= 50 px ; cristaux = (pâle | moyen) restants ; murs = tout le reste (partition exacte)."""
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a); sd = sdev(lum, 9)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    pale = (g > 160) & (b > 190) & (lum > 115)
    crymid = (lum > 90) & (b - r > 50) & (g - r > 30)
    dark = (lum < 135) & (b > r + 10)
    rect = (yy < 345) & (xx > 440) & (xx < 760)
    seed = (xx - 600) ** 2 + (yy - 150) ** 2 < 40 ** 2
    lab, _ = nd.label((pale | crymid) & rect)
    core = np.isin(lab, np.unique(lab[seed][lab[seed] > 0]))
    lab2, _ = nd.label(core | (dark & rect & nd.binary_dilation(core, iterations=40)))
    grand = np.isin(lab2, np.unique(lab2[seed][lab2[seed] > 0]))
    flaq = keep_large(pale & (xx > 300) & (xx < 900) & (yy > 350) & (yy < 650), 150)
    glace = keep_large((b - r > 70) & (b - g > 30) & (lum > 45) & (sd < 18) & ~grand & ~flaq, 50)
    crist = (pale | crymid) & ~grand & ~flaq & ~glace
    murs = ~(grand | flaq | glace | crist)
    gy, gx = np.nonzero(grand)
    masks = dict(glace=glace, flaques=flaq, murs=murs, cristaux=crist, grand_cristal=grand)
    seg = {'flaques_composantes': int(nd.label(flaq)[1]), 'flaques_px': int(flaq.sum()),
           'cristaux_composantes': int(nd.label(crist)[1]), 'grand_y': [int(gy.min()), int(gy.max())],
           'grand_x': [int(gx.min()), int(gx.max())], 'glace_pct': round(float(glace.mean() * 100), 1),
           'murs_pct': round(float(murs.mean() * 100), 1)}
    return masks, seg


# ---------------------------------------------------------------- sprites VFX (découpés dans vfx.png généré)
def vfx_sprite(path, bbox, size):
    v = np.array(Image.open(path).convert('RGB')).astype(int)
    x0, y0, x1, y1 = bbox
    crop = v[y0:y1 + 1, x0:x1 + 1]
    m = crop.sum(-1) >= 60
    sp = np.zeros((*m.shape, 4), 'uint8'); sp[m, :3] = crop[m]; sp[m, 3] = 255
    return np.array(Image.fromarray(sp).resize(size, Image.Resampling.NEAREST))


# ---------------------------------------------------------------- scintillements
def spark_stage(u):
    """Taille du sprite à la phase relative u (0-47) : 'S', 'M' ou None (cachée)."""
    return 'S' if u < 4 or 12 <= u < SPARK_VIS else 'M' if u < 12 else None


def place_sparkles(ex, rng):
    out = []; taken = np.zeros((H, W), bool)
    for name, n in (('grand_cristal', 4), ('cristaux', 4), ('flaques', 4)):
        m = ex[name].copy(); m[:15, :] = m[-15:, :] = False; m[:, :15] = m[:, -15:] = False
        ys, xs = np.nonzero(m); got = 0
        for i in rng.permutation(len(ys)):
            y, x = int(ys[i]), int(xs[i])
            if taken[max(0, y - 30):y + 31, max(0, x - 30):x + 31].any():
                continue
            out.append({'x': x, 'y': y, 'zone': name, 'phase': (len(out) * 4) % PHASES})
            taken[max(0, y - 30):y + 31, max(0, x - 30):x + 31] = True
            got += 1
            if got == n:
                break
        assert got == n, f'étincelles placées sur {name} : {got}'
    return out


def spark_frames(sparks, spr):
    frames = []
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for s in sparks:
            st = spark_stage((t + s['phase']) % PHASES)
            if st is None:
                continue
            im = spr[st]; h, w = im.shape[:2]; x, y = s['x'] - w // 2, s['y'] - h // 2
            mm = im[..., 3] > 0; e[y:y + h, x:x + w][mm] = im[mm]
        frames.append(e)
    return frames


# ---------------------------------------------------------------- lueurs (rampe exacte du décor, respiration)
def breath(t):
    return int(round(BREATH * np.sin(2 * np.pi * t / PHASES)))


def glow_frames(ex):
    flaq, grand = ex['flaques'], ex['grand_cristal']
    floor = ex['glace'] | flaq
    foot = (nd.binary_dilation(flaq, iterations=10) & ~flaq & floor) | \
        (nd.binary_dilation(grand, iterations=12) & ~grand & (floor | ex['murs']))
    d = nd.distance_transform_edt(~(flaq | grand))
    base = np.clip(7 - (d // 2), 0, 7).astype(int)
    rp = np.array(GLOW_RAMP, 'uint8'); frames = []
    for t in range(PHASES):
        idx = np.clip(base + breath(t), 0, len(GLOW_RAMP) - 1)
        e = np.zeros((H, W, 4), 'uint8'); e[foot, :3] = rp[idx[foot]]; e[foot, 3] = 255
        frames.append(e)
    return frames, int(foot.sum())


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Zone Cristal (ZCR1)')
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
    o.update(Name={'DefaultText': 'Zone Cristal - grotte de cristal D17P11A (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur la preview D17P11A (grotte de cristal) ; '
                     'scintillements decoupes dans la planche VFX generee, lueurs animees (rampe exacte du decor). '
                     "Arene de glace, Flaques lumineuses, grand cristal au nord. Marqueurs d edition, sans warp.")
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
  <Name>Zone Cristal ZCR1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Arene de glace et Flaques lumineuses, grand cristal au nord, scintillements et lueurs animes. Projet de carte, sans warp.</Description>
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
    order = ['grand_cristal', 'cristaux', 'murs', 'flaques', 'glace']
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
    cand = ex['glace'] | ex['flaques']
    cl, _ = nd.label(close_(cand, 2)); seed = cl[H - 1][cand[H - 1]]   # liserés < 4 px franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    spr = {'S': vfx_sprite(RAW / 'vfx.png', SPARK_BBOX_S, SPARK_SIZE_S),
           'M': vfx_sprite(RAW / 'vfx.png', SPARK_BBOX_M, SPARK_SIZE_M)}
    for k, v in spr.items():
        Image.fromarray(v).save(OUT / 'poses' / f'{PFX}_etincelle_{k}.png')
    rng = np.random.default_rng(7)
    sparks = place_sparkles(ex, rng)
    scint = spark_frames(sparks, spr)
    lueurs, halo_px = glow_frames(ex)
    anim = {'scintillements': scint, 'lueurs': lueurs}
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
    okgrid = np.zeros((gh_, gw_), bool)          # objectif : case atteignable la plus proche du monument
    for ay in range(gh_ - 1):
        for ax in range(gw_ - 1):
            okgrid[ay, ax] = not blocked[ay:ay + 2, ax:ax + 2].any()
    seen = np.zeros((gh_, gw_), bool); queue = [(entry_px[1] // 8, entry_px[0] // 8)]; seen[queue[0]] = True
    for ay, ax in queue:
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = ay + dy, ax + dx
            if 0 <= ny < gh_ and 0 <= nx < gw_ and okgrid[ny, nx] and not seen[ny, nx]:
                seen[ny, nx] = True; queue.append((ny, nx))
    dys, dxs = np.nonzero(ex['grand_cristal'])
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
    # Planche : rampe des lueurs (8 crans) et sprites des étincelles S/M, sur glace sombre.
    sheet = Image.new('RGBA', (8 * 48 + 16 + 2 * 170, 48 + 16 + 160), (13, 52, 76, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(GLOW_RAMP):
        d.rectangle([8 + i * 48, 8, 8 + i * 48 + 45, 55], fill=(*c, 255))
    for j, k in enumerate(['S', 'M']):
        sp = spr[k]
        sheet.alpha_composite(Image.fromarray(sp).resize((sp.shape[1] * 8, sp.shape[0] * 8), Image.Resampling.NEAREST),
                              (8 + j * 170, 64))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_zone_cristal_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, ref)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': 'Zone Cristal — grotte de cristal D17P11A', 'prefix': PFX, 'namespace': NAMESPACE,
        'asset': ASSET, 'type': 'zone de donjon / grotte de cristal', 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': 'poursuivre les zones (album 908) ; les VFX sont générés par l agent, pas en pixels exacts',
        'agent_choices': {
            'reference': 'preview D17P11A du port PMD-SKY-PMDO-PORT (vraie grotte de cristal ; d10p41a.png contient un couloir marron)',
            'layout': 'arrivée au sud sur la glace, vaste arène de glace ronde au centre avec Flaques lumineuses, grand cristal sur son autel au nord',
            'prefix': 'ZCR1 (zone cristal 1), libre dans le dépôt',
            'vfx': 'planche vfx.png générée sur fond noir ; sprites découpés au seuil, halos calculés',
            'biome': 'grotte de cristal D17P11A ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition ZCR1 générée avec la référence en images='},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
                    'size_px': list(SRC), 'role': 'glace bleue seule, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/bruts/vfx.png', 'sha256': sha(RAW / 'vfx.png'),
                    'size_px': list(Image.open(RAW / 'vfx.png').size),
                    'role': 'planche VFX générée sur fond noir (étincelles, halos)'},
                   {'file': f'source/{LOT}/reference/{REF_NAME}', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'preview D17P11A : matière de référence'}],
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (glace 64, roche 48, cristal 64), sans tramage ; étincelles découpées dans vfx.png, lueurs calculées',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'recalage': {'methode': 'sans témoin : segmentation directe du décor (couleurs + géométrie), pas de recalage'},
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': 'paires de pixels vérifiées entre la preview D17P11A et le brut ; distance euclidienne ; seuil 35'},
        'layers': layer_list,
        'scintillements': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(sparks),
                           'sprites': {'S': {'bbox_vfx': list(SPARK_BBOX_S), 'taille': list(SPARK_SIZE_S)},
                                       'M': {'bbox_vfx': list(SPARK_BBOX_M), 'taille': list(SPARK_SIZE_M)}},
                           'placements': sparks,
                           'loi': 'u = (t + phase) mod 48 ; u < 4 : S, 4-11 : M, 12-15 : S, sinon cachée ; même cycle à chaque boucle',
                           'origine': 'sprites découpés dans vfx.png (seuil somme >= 60), échantillonnage au plus proche, alpha binaire'},
        'lueurs': {'phases': PHASES, 'frame_length_ticks': TICKS, 'halo_px': halo_px,
                   'rampe_exacte': [list(c) for c in GLOW_RAMP],
                   'respiration': f'décalage de +-{BREATH} crans, sinusoïde de période {PHASES}',
                   'origine': 'halos autour des flaques et du grand cristal, 8 bleus exacts du décor'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors glace et flaques (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition générée référencée, pas de tuiles natives certifiées ; la rampe des lueurs reprend des bleus exacts du décor, les étincelles sont découpées dans la planche VFX générée.',
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
