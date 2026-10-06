"""Zone Mer lagon (ZME1) — île de sable au lagon, 4:3 (768 x 576).

.venv/bin/python source/zone_mer_lagon_v1/build.py

Référence canonique : S01P02A (clairière et mer, Explorers of Sky), via le port
`reference/s01p02a_port.png` (PMD-SKY-PMDO-PORT) et la vérité ROM pret/pmd-sky (boucle 1200 ticks :
BPL 2 x 10 crans x 10 + BPA 4 x 12) : bandes de vagues horizontales qui défilent latéralement.
Méthode « VFX générés » : l'eau est une texture générée par le modèle (pas des pixels du rip),
calibrée en palette sur la classe eau du port, puis animée par dérive latérale + onde progressive
(boucle exacte) ; reflets calculés qui scintillent sur le lagon.
- decor.png : plage d'arrivée au sud, île de sable ronde au centre, lagon magenta tout autour,
  arche de basalte et cercle de pierre au nord, jungle et falaises autour ; premier essai, conforme ;
- eau.png : lagon tropical turquoise à bandes de vagues et crêtes d'écume, plein cadre ; 2 essais (le
  premier contenait un îlot de sable, rejeté) ; teinte plage conservée, luminance canonique ;
- sol_complet.png : sable clair seul, plein cadre ; premier essai, conforme.
Calques : sol complet, sable, jungle, rochers (falaises + rochers + troncs + arche), eau (anim),
reflets (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- eau : dérive latérale de +-8 px + onde progressive (3 longueurs d'onde par boucle, 96 px),
  période 48 exacte, comme le défilement canonique ;
- reflets : 24 reflets calculés qui scintillent sur le lagon (cycle 16, boucle exacte).
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
REF = HERE / 'reference' / 's01p02a_port.png'
CANON = HERE / 'reference' / 'canon_stats.json'
LOT = 'zone_mer_lagon_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'zone_mer_lagon'
NAMESPACE = 'zone_mer_lagon'
ASSET = 'zme1_zone_mer_lagon'
PFX = 'ZME1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/s01p02a_port.png'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon '
     'Mystery Dungeon beach and sea cove): same light sandy beach sand, same blue sea water colours, same dark '
     'basalt rocks, same palm trees. Make a NEW, larger top-down lagoon zone map. WIDE LANDSCAPE 4:3, target 1200 '
     'by 896 pixels, zoomed out so the zone feels vast. Layout: the player arrives at the SOUTH (bottom edge '
     'center) on a sandy beach; the beach opens onto a round sandy island clearing in the CENTER with a few palm '
     'trees and dark rocks at its sides; a big lagoon wraps around the island on the LEFT, RIGHT and NORTH, with '
     'wavy sandy shores. IMPORTANT: fill the entire lagoon water FLAT with pure magenta (255, 0, 255), solid, no '
     'texture, no gradient, no waves inside the water. At the NORTH (top center) a dark basalt rock arch behind '
     'the water with a stone circle on a small sandy spit in front of it. A few palm trees on the island and the '
     'beach. No water texture anywhere (magenta only), no characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (lagon magenta d un seul tenant, arche et cercle au nord, jungle autour)'},
    {'file': 'eau.png', 'images': [f'source/{LOT}/reference/s01p02a_port.png'],
     'prompt': 'Same retro pixel-art style as the reference image cove water. Fill the ENTIRE image edge to '
     'edge, wide 4:3, with ONLY a pretty tropical beach lagoon water texture: luminous turquoise-aqua water with '
     'lighter horizontal wavy bands plus sparkling white foam crests and glints, uniform water everywhere, no land, '
     'no sand, no island, no shallows, no grass, no rocks, no magenta, no text.',
     'essais': '2 essais : le premier contenait un îlot de sable au milieu (rejeté) ; le second, sans île ni hauts-fonds, conforme'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/bruts/decor.png'],
     'prompt': 'Same pixel-art style and same light sand colours as the sandy island in the center of the '
     'reference image. Fill the ENTIRE image edge to edge, wide 4:3, with only that light warm sand texture: '
     'subtle speckles and ripples, uniform tiling texture, keep the texture detail. No water, no grass, no palms, '
     'no rocks, no magenta, no text.',
     'essais': 'premier essai ; sable clair seul, conforme'},
]
# ---- Eau : dérive latérale + onde progressive, période 48 (boucle exacte, façon S01).
EAU_DERIVE = 8
EAU_ONDE = 0.07
EAU_LONGUEUR = 96
EAU_TOURS = 3
# ---- Reflets : 24 reflets, cycle 16 (divise 48), boucle exacte.
N_REFLETS = 48 // 2
REFLET_CYCLE = 16
POINT, HALO, COEUR = (170, 215, 245), (205, 235, 250), (245, 252, 255)
_YY, _XX = np.mgrid[:H, :W].astype(float)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'sable'], 64), 'jungle': (['jungle'], 48), 'rochers': (['rochers'], 48)}
STATIC = ['sable', 'jungle', 'rochers']
ANIMS = ['eau', 'reflets']
DRAW_ORDER = ['sol_complet', 'sable', 'jungle', 'rochers', 'eau', 'reflets']


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
    """a : décor. eau = magenta (r > 200, g < 100, b > 200) fermé 2 px, trous bouchés, frange rose
    (r et b > 150, g < 150) à moins de 3 px rattachée, composantes >= 500 px (filtre les fleurs
    magenta de l'île) ; sable = clair et chaud (r > 200, g > 170, b < 200, r > b + 40) ; jungle =
    vert (g > r + 15, g > b + 10, g > 90), y compris les couronnes des palmiers ; rochers = le reste
    (falaises, rochers, troncs, arche, cercle de pierre, fleurs)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    mag = (r > 200) & (g < 100) & (b > 200)
    eau = nd.binary_fill_holes(keep_large(close_(mag, 2), 500))
    fringe = (r > 150) & (b > 150) & (g < 150) & nd.binary_dilation(eau, iterations=3)
    eau = keep_large(nd.binary_fill_holes(eau | fringe), 500)
    nlags = int(nd.label(eau)[1])
    assert nlags == 1, f'lagons : {nlags}'
    sable = ~eau & (r > 200) & (g > 170) & (b < 200) & (r > b + 40)
    jungle = ~eau & ~sable & (g > r + 15) & (g > b + 10) & (g > 90)
    rochers = ~(eau | sable | jungle)
    masks = dict(eau=eau, sable=sable, jungle=jungle, rochers=rochers)
    seg = {'lagons': nlags, 'eau_pct': round(100 * eau.mean(), 2), 'sable_pct': round(100 * sable.mean(), 2),
           'jungle_pct': round(100 * jungle.mean(), 2), 'rochers_pct': round(100 * rochers.mean(), 2),
           'sable_rgb': [round(float(v), 1) for v in a[sable].mean(0)],
           'jungle_rgb': [round(float(v), 1) for v in a[jungle].mean(0)]}
    return masks, seg


def palette_match(brut, mean_c):
    """Offset additif par canal vers la cible + épaule douce (monotone, teintes préservées) :
    y = x si x <= 200, 255 - 55 exp(-(x - 200) / 60) sinon."""
    x = brut.astype(float) + (np.array(mean_c, float) - brut.reshape(-1, 3).mean(0))
    return np.where(x > 200, 255 - 55 * np.exp(-(x - 200) / 60), x).round().astype('uint8')


def luminance_match(brut, lum_cible):
    """Mise à l'échelle UNIFORME (teinte strictement conservée) vers la luminance cible : l'eau
    garde son turquoise « style plage » (direction utilisateur) à la luminosité canonique."""
    m = brut.reshape(-1, 3).mean(0)
    return np.clip(brut.astype(float) * (lum_cible / (m @ [.299, .587, .114])), 0, 255).round().astype('uint8')


# ---------------------------------------------------------------- fidélité (cibles canoniques S01)
def fidelity(gmatch_eau, fmatch_sable, canon):
    """eau : brut turquoise mis à la luminance canonique, contre la cible lagon « style plage »
    (direction utilisateur, teinte conservée) ; sable : brut calibré contre le sable du décor
    (cohérence interne ; l'herbe et les rochers suivent la direction artistique du décor)."""
    out = {}
    for k, m, c in (('eau', gmatch_eau.reshape(-1, 3).mean(0), np.array(canon['cible_lagon_plage'], float)),
                    ('sable', fmatch_sable.reshape(-1, 3).mean(0), np.array(canon['cible_sable_decor'], float))):
        out[k] = {'rip_rgb': [round(float(v), 1) for v in c], 'decor_rgb': [round(float(v), 1) for v in m],
                  'distance': round(float(np.linalg.norm(m - c)), 1)}
    return out


# ---------------------------------------------------------------- eau animée (texture générée calibrée)
EAU_COLORS = 96


def eau_palette(base):
    """Palette partagée (MEDIANCUT, sans tramage) calculée sur la base calibrée."""
    return Image.fromarray(base).quantize(colors=EAU_COLORS, method=Image.MEDIANCUT, dither=Image.Dither.NONE)


def eau_frame(base, mask, t, pal=None):
    """Phase t (modulo 48) : dérive latérale de +-8 px + onde progressive (4 longueurs d'onde de
    96 px par boucle, vers la droite) + pulsation légère ; période 48 exacte, façon S01."""
    t %= PHASES
    ph = 2 * np.pi * t / PHASES
    dx = int(round(EAU_DERIVE * np.sin(ph)))
    rolled = np.roll(base, dx, 1).astype(float)
    onde = (1 + EAU_ONDE * np.sin(2 * np.pi * _XX / EAU_LONGUEUR - EAU_TOURS * ph) +
            0.02 * np.sin(ph))
    fr = np.zeros((H, W, 4), 'uint8')
    fr[mask, :3] = np.clip(rolled[mask] * onde[mask, None], 0, 255).round().astype('uint8')
    if pal is not None:
        q = np.asarray(Image.fromarray(fr[..., :3]).quantize(palette=pal, dither=Image.Dither.NONE).convert('RGB'))
        fr[..., :3] = 0; fr[mask, :3] = q[mask]
    fr[mask, 3] = 255
    return fr


def eau_frames(base, mask, pal=None):
    return [eau_frame(base, mask, t, pal) for t in range(PHASES)]


# ---------------------------------------------------------------- reflets qui scintillent
def reflet_state(e, t):
    """(x, y, forme) du reflet e à la phase t, ou None si éteint (cycle 16)."""
    u = (t + e['phase']) % REFLET_CYCLE
    if u >= 10:
        return None
    return e['x0'], e['y0'], 'croix' if u % 4 in (0, 1) else 'point'


def place_reflets(eau_m, rng):
    er = nd.binary_erosion(eau_m, iterations=3)
    er[:, :3] = False; er[:, -3:] = False; er[:3] = False; er[-3:] = False
    ys, xs = np.nonzero(er); reflets = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x]:
            continue
        reflets.append({'x0': x, 'y0': y, 'phase': int(rng.integers(REFLET_CYCLE))})
        taken[max(0, y - 16):y + 16, max(0, x - 16):x + 16] = True
        if len(reflets) == N_REFLETS:
            break
    assert len(reflets) == N_REFLETS, f'reflets placés : {len(reflets)}'
    return reflets


def reflet_frames(reflets):
    frames = []
    for t in range(PHASES):
        a = np.zeros((H, W, 4), 'uint8')
        for e in reflets:
            st = reflet_state(e, t)
            if st is None:
                continue
            x, y, shape = st
            if not (1 <= x < W - 1 and 1 <= y < H - 1):
                continue
            if shape == 'croix':
                for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    a[y + dy, x + dx] = (*HALO, 255)
                a[y, x] = (*COEUR, 255)
            else:
                a[y, x] = (*POINT, 255)
        frames.append(a)
    return frames


def reflet_sprites():
    out = {}
    for shape in ('point', 'croix'):
        sp = np.zeros((5, 5, 4), 'uint8')
        if shape == 'croix':
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                sp[2 + dy, 2 + dx] = (*HALO, 255)
            sp[2, 2] = (*COEUR, 255)
        else:
            sp[2, 2] = (*POINT, 255)
        out[shape] = sp
    return out


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Zone Mer lagon (ZME1)')
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
    o.update(Name={'DefaultText': 'Zone Mer lagon - île au lagon (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3, eau generee calibree sur S01P02A (Explorers of Sky) ; '
                     'eau animee (derive laterale + onde progressive), reflets calcules. Ile de sable au lagon, '
                     'arche de basalte au nord. Marqueurs d edition, sans warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': "Arrivée, île et objectif (repères d'édition)", 'Visible': True, 'MapChars': [],
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
  <Name>Zone Mer lagon ZME1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Ile de sable au lagon, arche de basalte au nord, eau et reflets animes. Projet de carte, sans warp.</Description>
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
    a, f, wtr, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(RAW / 'eau.png'), rgb(REF)
    canon = json.loads(CANON.read_text())
    assert a.shape[:2] == f.shape[:2] == wtr.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    gmatch = luminance_match(wtr, float(np.array(canon['port_eau_classe_mean'], float) @ [.299, .587, .114]))
    Image.fromarray(gmatch).save(OUT / 'review' / f'{PFX}_eau_calibree.png')
    fmatch = palette_match(f, np.array(seg['sable_rgb'], float))
    Image.fromarray(fmatch).save(OUT / 'review' / f'{PFX}_sable_calibre.png')
    canon = dict(canon, cible_sable_decor=seg['sable_rgb'])
    ex, cols = down_class(a, m, ['eau', 'sable', 'jungle', 'rochers'])
    layers = {'sol_complet': rgba(down_full(fmatch), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    assert ((ex['eau'].astype(int) + ex['sable'].astype(int) + ex['jungle'].astype(int) +
             ex['rochers'].astype(int)) == 1).all()
    cl, _ = nd.label(close_(ex['sable'], 2)); seed = cl[H - 1][ex['sable'][H - 1]]   # liserés < 4 px franchis
    walk = np.isin(cl, np.unique(seed[seed > 0])) & ex['sable']
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    assert walk.mean() > 0.05, 'zone praticable trop petite'
    base_eau = down_full(gmatch)
    eau_pal = eau_palette(base_eau)
    eau = eau_frames(base_eau, ex['eau'], eau_pal)
    reflets = place_reflets(ex['eau'], np.random.default_rng(11))
    reflet_an = reflet_frames(reflets)
    spr = reflet_sprites()
    for name, sp in spr.items():
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_reflet_{name}.png')
    anim = {'eau': eau, 'reflets': reflet_an}
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
    boss = free_near(W // 2, 320)
    objectif = free_near(W // 2, 211)
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
    # Planche : rampe de l'eau calibrée (16 quantiles de luminance) + formes des reflets, sur sable.
    flat = gmatch.reshape(-1, 3).astype(float); lum = flat @ [.299, .587, .114]; order = np.argsort(lum)
    ramp = [tuple(int(v) for v in flat[order[int(len(order) * (i + 0.5) / 16)]]) for i in range(16)]
    sheet = Image.new('RGBA', (16 * 24 + 16, 24 + 16 + 56), (248, 224, 154, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(ramp):
        d.rectangle([8 + i * 24, 8, 8 + i * 24 + 21, 31], fill=(*c, 255))
    for j, shape in enumerate(['point', 'croix']):
        sheet.alpha_composite(Image.fromarray(spr[shape]).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_zone_mer_lagon_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(gmatch, fmatch, canon)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': 'Zone Mer lagon — île de sable au lagon', 'prefix': PFX,
        'namespace': NAMESPACE, 'asset': ASSET, 'type': 'zone de donjon / lagon tropical', 'format': '4:3 vaste',
        'size_px': [W, H], 'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': 'poursuivre les zones ; VFX (lave, eau, etc.) GENERES, album 908 des fonds animés en référence ; eau animée canoniquement (S01)',
        'agent_choices': {
            'reference': 'S01P02A canonique (clairière et mer, Explorers of Sky) : port PMD-SKY-PMDO-PORT + vérité ROM pret/pmd-sky (boucle 1200 ticks, bandes de vagues en défilement latéral)',
            'methode_vfx': "texture d'eau lagon générée (pas de pixels du rip), teinte plage conservée à la luminance canonique, animée par dérive latérale + onde progressive (S01) ; reflets calculés",
            'layout': "plage d'arrivée au sud, île de sable ronde au centre, lagon tout autour, arche de basalte et cercle de pierre au nord (décor, isolés par l'eau)",
            'prefix': 'ZME1, série Z des zones (libre, pas de collision avec ZCR1/ZPO1/ZMA1)',
            'biome': 'mer lagon ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition ZME1 générée avec le port s01p02a en référence (lagon magenta)'},
                   {'file': f'source/{LOT}/bruts/eau.png', 'sha256': sha(RAW / 'eau.png'), 'size_px': list(SRC),
                    'role': "texture d'eau générée à bandes de vagues, calibrée en palette, animée"},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
                    'size_px': list(SRC), 'role': 'sable seul, calibré sur le décor, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/reference/s01p02a_port.png', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'port s01p02a : matière + cible palette de l eau'},
                   {'file': f'source/{LOT}/reference/canon_stats.json', 'sha256': sha(CANON), 'size_px': 'n/a',
                    'role': 'statistiques canoniques (classe eau du port), cible du calibrage'}],
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (sol 64, jungle 48, rochers 48), sans tramage ; eau calibrée quantifiée sur 96 couleurs partagées (MEDIANCUT, sans tramage), reflets calculés',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'calibrage_eau': {'cible': 'cible_lagon_plage de canon_stats.json (teinte plage, luminance canonique)',
                          'methode': 'mise à l échelle uniforme (teinte conservée) vers la luminance canonique',
                          'apres_moyenne': [round(float(v), 1) for v in gmatch.reshape(-1, 3).mean(0)]},
        'calibrage_sable': {'cible': 'sable du décor (moyenne RGB)',
                            'methode': 'offset additif par canal + épaule douce monotone (cohérence interne)',
                            'apres_moyenne': [round(float(v), 1) for v in fmatch.reshape(-1, 3).mean(0)]},
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': "eau : moyenne RGB du brut turquoise (luminance canonique) contre la cible lagon style plage ; sable : brut calibré contre le sable du décor (cohérence interne ; l'herbe et les rochers suivent la direction artistique du décor) ; distance euclidienne ; seuil 35"},
        'layers': layer_list,
        'eau': {'phases': PHASES, 'frame_length_ticks': TICKS, 'derive_px': EAU_DERIVE, 'onde': EAU_ONDE,
                'longueur_onde_px': EAU_LONGUEUR, 'tours_par_boucle': EAU_TOURS,
                'palette_partagee': EAU_COLORS,
                'rampe_calibree': [list(c) for c in ramp],
                'loi': 'dx = 8 sin(2 pi t / 48) ; onde 1 + 0.07 sin(2 pi x / 96 - 6 pi t / 48) + 0.02 sin(2 pi t / 48) ; boucle exacte de période 48 (3 tours, impair), défilement vers la droite façon S01',
                'origine': 'texture generee calibree sur S01P02A (ni pixels du rip ni pixels ROM)'},
        'reflets': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(reflets), 'cycle': REFLET_CYCLE,
                    'couleurs': {'point': list(POINT), 'halo': list(HALO), 'coeur': list(COEUR)},
                    'placements': reflets,
                    'loi': f'u = (t + phase) mod {REFLET_CYCLE} ; visible u < 10 (croix 3x3 si u mod 4 < 2, point sinon), éteint sinon ; boucle exacte',
                    'origine': 'reflets calcules sur le lagon'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors sable praticable (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ["Composition et eau générées, palette de l'eau calibrée sur S01P02A ; aucun pixel du rip ni de la ROM dans les calques.",
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
