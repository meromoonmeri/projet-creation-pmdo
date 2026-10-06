"""Zone Rives de magma (ZMA1) — arène volcanique à lacs de lave, 4:3 (768 x 576).

.venv/bin/python source/zone_magma_rives_v1/build.py

Référence canonique : D41P41A (fin du donjon volcanique, Explorers of Sky), via le port
`reference/d41p41a_port.png` (PMD-SKY-PMDO-PORT : arène d'obsidienne bordée de lave) et la vérité
ROM pret/pmd-sky (boucle 130 ticks, 2 palettes x 13 crans) : cellules jaune-orange qui pulsent et
brassent sur fond rouge-orange. Méthode « VFX générés » : la lave est une texture générée par le
modèle (pas des pixels du rip), calibrée en palette sur la classe lave du port (cellules brillantes), puis animée par
dérive circulaire + pulsation (boucle exacte) ; braises calculées qui montent des lacs.
- decor.png : arrivée au sud, arène d'obsidienne au centre, TROIS lacs magenta (gauche, droite,
  nord-centre), arche de basalte à éventail incandescent au nord ; premier essai, conforme ;
- sol_complet.png : obsidienne fissurée seule, plein cadre ; 3 échecs API (réponse vide) avec le
  rip en référence, succès en référençant le décor (premier essai) ;
- lave.png : lave cellulaire jaune-orange sur rouge-orange, plein cadre ; 1 échec API avec le rip
  en référence, succès en référençant le décor (premier essai).
Calques : sol complet, sol, rochers (basalte + liserés incandescents + évent), lave (anim),
braises (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- lave : dérive circulaire de 6 px + pulsation +-4,5 % (plus harmonique spatiale), période 48 ;
- braises : 48 braises calculées qui montent de 32 px au-dessus des lacs en vacillant, 32 phases
  visibles puis 16 cachées, boucle exacte.
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
REF = HERE / 'reference' / 'd41p41a_port.png'
CANON = HERE / 'reference' / 'canon_stats.json'
LOT = 'zone_magma_rives_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'zone_magma_rives'
NAMESPACE = 'zone_magma_rives'
ASSET = 'zma1_zone_magma_rives'
PFX = 'ZMA1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/d41p41a_port.png'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon '
     'Mystery Dungeon dark crater lava arena): same very dark grey-brown cracked obsidian ground, same black '
     'jagged basalt rock walls with orange rim light, same dark volcanic background. Make a NEW, larger top-down '
     'volcanic zone map. WIDE LANDSCAPE 4:3, target 1200 by 896 pixels, zoomed out so the zone feels vast. Layout: '
     'the player arrives at the SOUTH (bottom edge center) on an obsidian path; the path opens onto a WIDE dark '
     'arena clearing in the CENTER; THREE rounded lava lakes with wavy shores: one large lake on the LEFT, one '
     'large lake on the RIGHT, one smaller lake at the NORTH-CENTER below a black basalt arch; dark rocky rim '
     'around each lake. IMPORTANT: fill every lava lake FLAT with pure magenta (255, 0, 255), solid, no texture, '
     'no gradient inside the lakes. At the NORTH (top center) the black basalt arch with a glowing vent behind it, '
     'obsidian ground leading up to it. No lava texture anywhere (magenta only), no characters, no text, no UI, '
     'no border.',
     'essais': 'premier essai ; conforme (3 lacs magenta, arche à évent au nord, distances dans le manifeste)'},
    {'file': 'lave.png', 'images': [f'source/{LOT}/reference/d41p41a_port.png'],
     'prompt': 'Use EXACTLY the same lava look as the reference image molten lava (Pokemon Mystery Dungeon '
     'volcanic dungeon): deep dark red-orange churning molten rock background with bright glowing yellow-orange '
     'cellular blobs and cracks, patches of dark cooling crust, same canonical lava colours and pixel-art style. '
     'Fill the ENTIRE image edge to edge, wide 4:3, with ONLY this canonical lava texture, keep the texture detail. '
     'No rocks, no ground, no walls, no magenta, no text.',
     'essais': 'v2 canonique (croûte sombre + fissures incandescentes, premier essai, avec le port en référence) ; v1 : 1 échec API avec le port, succès en référençant le décor'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/bruts/decor.png'],
     'prompt': 'Same pixel-art style and same dark ground colours as the dark arena floor in the center of the '
     'reference image. Fill the ENTIRE image edge to edge, wide 4:3, with only that dark grey-brown cracked '
     'volcanic ground texture: subtle cracks and speckles, uniform tiling texture, keep the texture detail. '
     'No rocks, no lava, no glow, no magenta, no text.',
     'essais': '3 échecs API (réponses vides) avec le rip d41 en référence, succès en référençant le décor'},
]
# ---- Lave : dérive circulaire + pulsation, période 48 (boucle exacte).
LAVA_DRIFT = 6
LAVA_PULSE = 0.045
# ---- Braises : 48 braises, montée de 32 px (1 px par phase), 16 phases cachées, boucle exacte de 48.
N_EMBERS = 48
EMBER_RISE = 32
DOT, GLOW, CORE = (255, 170, 60), (255, 215, 120), (255, 246, 205)
_YY, _XX = np.mgrid[:H, :W].astype(float)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'sol'], 64), 'rochers': (['rochers'], 48)}
STATIC = ['sol', 'rochers']
ANIMS = ['lave', 'braises']
DRAW_ORDER = ['sol_complet', 'sol', 'rochers', 'lave', 'braises']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


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


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """a : décor. lave = magenta (r > 200, g < 100, b > 200) fermé 2 px, trous bouchés, frange rose
    (r et b > 150, g < 150) à moins de 3 px rattachée ; glow = liserés orange (r > 140, 45 < g < 170,
    b < 100, r > b + 60) + coeurs chauds (lum > 140, r > b + 30), hors lave ; murs = lum < 44 hors
    lave et glow ; sol = le reste. rochers = glow + murs."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    mag = (r > 200) & (g < 100) & (b > 200)
    lava = nd.binary_fill_holes(keep_large(close_(mag, 2), 500))
    fringe = (r > 150) & (b > 150) & (g < 150) & nd.binary_dilation(lava, iterations=3)
    lava = keep_large(nd.binary_fill_holes(lava | fringe), 500)
    glow = (((r > 140) & (g > 45) & (g < 170) & (b < 100) & (r > b + 60)) |
            ((lum > 140) & (r > b + 30))) & ~lava
    walls = (lum < 44) & ~lava & ~glow
    sol = ~(lava | glow | walls)
    nlakes = int(nd.label(lava)[1])
    assert nlakes == 3, f'lacs de lave : {nlakes}'
    masks = dict(lave=lava, rochers=glow | walls, sol=sol)
    seg = {'lacs': nlakes, 'lave_pct': round(100 * lava.mean(), 2), 'glow_pct': round(100 * glow.mean(), 2),
           'murs_pct': round(100 * walls.mean(), 2), 'sol_pct': round(100 * sol.mean(), 2),
           'murs_lum': round(float(lum[walls].mean()), 1), 'sol_lum': round(float(lum[sol].mean()), 1)}
    return masks, seg


def palette_match(brut, mean_c):
    """Offset additif par canal vers la cible canonique + épaule douce (monotone, teintes
    préservées) : y = x si x <= 200, 255 - 55 exp(-(x - 200) / 60) sinon. Le recalage
    moyenne/écart-type par canal est PROSCRIT ici : il rendait les chenaux rouge sombre sarcelle."""
    x = brut.astype(float) + (np.array(mean_c, float) - brut.reshape(-1, 3).mean(0))
    return np.where(x > 200, 255 - 55 * np.exp(-(x - 200) / 60), x).round().astype('uint8')


# ---------------------------------------------------------------- fidélité (cibles canoniques D41P41A)
def fidelity(a, f, gmatch, ref, canon):
    """lave : brut calibré contre la classe lave du port (cellules brillantes) ; basalte : murs du décor contre murs du
    port ; sol : brut sol contre sol du décor (cohérence interne, zone sombre voulue)."""
    pm = np.array(canon['port_lave_classe_mean'], float)
    lave_m = gmatch.reshape(-1, 3).mean(0)
    pr = ref.astype(float); lum = lum_of(pr)
    pl = (pr[..., 0] > 140) & (pr[..., 1] > 45) & (pr[..., 1] < 170) & (pr[..., 2] < 100)
    pw = pr[(lum < 50) & ~pl].mean(0)
    ad = a.astype(float); lumd = lum_of(ad)
    mag = (ad[..., 0] > 200) & (ad[..., 1] < 100) & (ad[..., 2] > 200)
    glow = ((((ad[..., 0] > 140) & (ad[..., 1] > 45) & (ad[..., 1] < 170) & (ad[..., 2] < 100) &
              (ad[..., 0] > ad[..., 2] + 60)) | ((lumd > 140) & (ad[..., 0] > ad[..., 2] + 30))) & ~mag)
    dw = ad[(lumd < 44) & ~mag & ~glow].mean(0)
    ds = ad[~mag & ~glow & (lumd >= 44)].mean(0)
    fs = f.reshape(-1, 3).mean(0)
    out = {}
    for k, mr, md in (('lave', pm, lave_m), ('basalte', pw, dw), ('sol', ds, fs)):
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- lave animée (texture générée calibrée)
LAVA_COLORS = 96


def lava_palette(base):
    """Palette partagée (MEDIANCUT, sans tramage) calculée sur la base calibrée."""
    return Image.fromarray(base).quantize(colors=LAVA_COLORS, method=Image.MEDIANCUT, dither=Image.Dither.NONE)


def lava_frame(base, mask, t, pal=None):
    """Phase t (modulo 48) : dérive circulaire de 6 px + pulsation, période 48 exacte.
    Si pal (image P) est fournie, les couleurs sont projetées sur la palette partagée."""
    t %= PHASES
    ph = 2 * np.pi * t / PHASES
    dx, dy = int(round(LAVA_DRIFT * np.cos(ph))), int(round(LAVA_DRIFT * np.sin(ph)))
    rolled = np.roll(np.roll(base, dy, 0), dx, 1).astype(float)
    puls = 1 + LAVA_PULSE * np.sin(ph) + 0.03 * np.sin(2 * ph + 2 * np.pi * (_XX + _YY) / 192)
    fr = np.zeros((H, W, 4), 'uint8')
    fr[mask, :3] = np.clip(rolled[mask] * puls[mask, None], 0, 255).round().astype('uint8')
    if pal is not None:
        q = np.asarray(Image.fromarray(fr[..., :3]).quantize(palette=pal, dither=Image.Dither.NONE).convert('RGB'))
        fr[..., :3] = 0; fr[mask, :3] = q[mask]
    fr[mask, 3] = 255
    return fr


def lava_frames(base, mask, pal=None):
    return [lava_frame(base, mask, t, pal) for t in range(PHASES)]


# ---------------------------------------------------------------- braises qui montent
def ember_state(e, t):
    """(x, y, forme) de la braise e à la phase t, ou None si cachée."""
    u = (t + e['phase']) % PHASES
    if u >= EMBER_RISE:
        return None
    x = e['x0'] + int(round(2 * np.sin(2 * np.pi * u / 12 + e['wob'])))
    return x, e['y0'] - u, 'croix' if u < 24 and u % 4 in (0, 1) else 'point'


def place_embers(lava_m, rng):
    zone = nd.binary_dilation(lava_m, iterations=8)
    zone[:40] = False
    ys, xs = np.nonzero(zone); embers = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x] or y - EMBER_RISE - 2 < 0 or not (3 <= x < W - 3):
            continue
        if zone[y - EMBER_RISE - 1:y + 1, max(0, x - 2):x + 3].mean() < 0.9:
            continue
        embers.append({'x0': x, 'y0': y, 'phase': int(rng.integers(PHASES)),
                       'wob': round(float(rng.uniform(0, 2 * np.pi)), 3)})
        taken[max(0, y - 12):y + 12, max(0, x - 12):x + 12] = True
        if len(embers) == N_EMBERS:
            break
    assert len(embers) == N_EMBERS, f'braises placées : {len(embers)}'
    return embers


def ember_frames(embers):
    frames = []
    for t in range(PHASES):
        a = np.zeros((H, W, 4), 'uint8')
        for e in embers:
            st = ember_state(e, t)
            if st is None:
                continue
            x, y, shape = st
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


def ember_sprites():
    out = {}
    for shape in ('point', 'croix'):
        sp = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                sp[2 + dy, 2 + dx] = (*GLOW, 255)
            sp[2, 2] = (*CORE, 255)
        else:
            sp[2, 2] = (*DOT, 255)
        out[shape] = sp
    return out


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Zone Rives de magma (ZMA1)')
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
    o.update(Name={'DefaultText': 'Zone Rives de magma - lacs de lave (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3, lave generee calibree sur D41P41A (Explorers of Sky) ; '
                     'lave animee (derive + pulsation), braises calculees. Arene volcanique, arche a event au nord. '
                     'Marqueurs d edition, sans warp.')
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
  <Name>Zone Rives de magma ZMA1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Arene volcanique a lacs de lave, arche a event au nord, lave et braises animees. Projet de carte, sans warp.</Description>
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
    a, f, lav, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(RAW / 'lave.png'), rgb(REF)
    canon = json.loads(CANON.read_text())
    assert a.shape[:2] == f.shape[:2] == lav.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    gmatch = palette_match(lav, canon['port_lave_classe_mean'])
    gm = gmatch.astype(float)
    assert not (((gm[..., 1] > gm[..., 0] + 20) & (gm[..., 2] > gm[..., 0] + 20))).any(), 'teinte froide dans la lave'
    Image.fromarray(gmatch).save(OUT / 'review' / f'{PFX}_lave_calibree.png')
    ex, cols = down_class(a, m, ['lave', 'rochers', 'sol'])
    exl, colsl = down_class(gmatch, {'lave': m['lave']}, ['lave'])
    cols['lave'] = colsl['lave']   # couleurs du brut calibré ; masque = ex['lave'] (partition à 3 classes)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    assert ((ex['lave'].astype(int) + ex['rochers'].astype(int) + ex['sol'].astype(int)) == 1).all()
    cl, _ = nd.label(close_(ex['sol'], 2)); seed = cl[H - 1][ex['sol'][H - 1]]   # liserés < 4 px franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & ex['sol']
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    assert walk.mean() > 0.05, 'zone praticable trop petite'
    base_lave = down_full(gmatch)
    lave_pal = lava_palette(base_lave)
    lave = lava_frames(base_lave, ex['lave'], lave_pal)
    embers = place_embers(ex['lave'], np.random.default_rng(11))
    braises = ember_frames(embers)
    spr = ember_sprites()
    for name, sp in spr.items():
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_braise_{name}.png')
    anim = {'lave': lave, 'braises': braises}
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
    boss = free_near(W // 2, 300)
    objectif = free_near(W // 2, 110)
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
    assert not (((np.asarray(scenes[0])[..., 0] > 200) & (np.asarray(scenes[0])[..., 1] < 100) &
                (np.asarray(scenes[0])[..., 2] > 200))).any(), 'magenta résiduel dans la scène'
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('objectif', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    # Planche : rampe de la lave calibrée (16 quantiles de luminance) + formes des braises, sur obsidienne.
    flat = gmatch.reshape(-1, 3).astype(float); lum = flat @ [.299, .587, .114]; order = np.argsort(lum)
    ramp = [tuple(int(v) for v in flat[order[int(len(order) * (i + 0.5) / 16)]]) for i in range(16)]
    sheet = Image.new('RGBA', (16 * 24 + 16, 24 + 16 + 56), (35, 27, 27, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(ramp):
        d.rectangle([8 + i * 24, 8, 8 + i * 24 + 21, 31], fill=(*c, 255))
    for j, shape in enumerate(['point', 'croix']):
        sheet.alpha_composite(Image.fromarray(spr[shape]).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_zone_magma_rives_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, f, gmatch, ref, canon)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': 'Zone Rives de magma — arène volcanique à lacs de lave', 'prefix': PFX,
        'namespace': NAMESPACE, 'asset': ASSET, 'type': 'zone de donjon / arène volcanique', 'format': '4:3 vaste',
        'size_px': [W, H], 'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': 'poursuivre les zones ; VFX (lave, eau, etc.) GENERES, album 908 des fonds animés en référence',
        'agent_choices': {
            'reference': 'D41P41A canonique (fin volcanique, Explorers of Sky) : port PMD-SKY-PMDO-PORT + vérité ROM pret/pmd-sky (boucle 130 ticks, cellules jaune-orange pulsantes)',
            'methode_vfx': 'texture de lave générée (pas de pixels du rip), palette calibrée sur la classe lave du port (cellules brillantes), animée par dérive + pulsation ; braises calculées',
            'layout': "arrivée au sud, arène d'obsidienne au centre entre trois lacs de lave, arche de basalte à évent incandescent au nord",
            'prefix': 'ZMA1, série Z des zones (libre)',
            'biome': 'rives de magma ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition ZMA1 générée avec le port d41p41a en référence (lacs magenta)'},
                   {'file': f'source/{LOT}/bruts/lave.png', 'sha256': sha(RAW / 'lave.png'), 'size_px': list(SRC),
                    'role': 'texture de lave générée, calibrée en palette, animée'},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
                    'size_px': list(SRC), 'role': 'obsidienne seule, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/reference/d41p41a_port.png', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'port d41p41a : matière + cible palette de la lave'},
                   {'file': f'source/{LOT}/reference/canon_stats.json', 'sha256': sha(CANON), 'size_px': 'n/a',
                    'role': 'statistiques canoniques (région lave du port), cible du calibrage'}],
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (sol 64, rochers 48), sans tramage ; lave calibrée quantifiée sur 96 couleurs partagées (MEDIANCUT, sans tramage), braises calculées',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'calibrage_lave': {'cible': 'port_lave_classe_mean de canon_stats.json',
                           'methode': 'offset additif par canal + épaule douce monotone (recalage moyenne/écart-type proscrit : teintes froides interdites)', 'apres_moyenne': [round(float(v), 1) for v in gmatch.reshape(-1, 3).mean(0)],
                           'apres_ecart_type': [round(float(v), 1) for v in gmatch.reshape(-1, 3).std(0)]},
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': 'lave : moyenne RGB du brut calibré contre la classe lave du port (cellules brillantes) ; basalte : murs du décor contre murs du port (même classifieur) ; sol : brut sol contre sol du décor (cohérence interne) ; distance euclidienne ; seuil 35'},
        'layers': layer_list,
        'lave': {'phases': PHASES, 'frame_length_ticks': TICKS, 'derive_px': LAVA_DRIFT, 'pulsation': LAVA_PULSE,
                 'palette_partagee': LAVA_COLORS,
                 'rampe_calibree': [list(c) for c in ramp],
                 'loi': 'dx = 6 cos(2 pi t / 48), dy = 6 sin(2 pi t / 48) ; pulsation 1 + 0.045 sin(2 pi t / 48) + 0.03 sin(4 pi t / 48 + 2 pi (x + y) / 192) ; boucle exacte',
                 'origine': 'texture generee calibree sur D41P41A (ni pixels du rip ni pixels ROM)'},
        'braises': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(embers), 'montee_px': EMBER_RISE,
                    'couleurs': {'point': list(DOT), 'halo': list(GLOW), 'coeur': list(CORE)},
                    'placements': embers,
                    'loi': f'y = y0 - u, x = x0 + 2 sin(2 pi u / 12 + wob), u = (t + phase) mod {PHASES} ; visible u < {EMBER_RISE} (croix 3x3 jeune, point sinon), cachee sinon ; boucle exacte',
                    'origine': 'braises calculees au-dessus des lacs'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors sol praticable (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition et lave générées, palette de la lave calibrée sur D41P41A ; aucun pixel du rip ni de la ROM dans les calques.',
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
