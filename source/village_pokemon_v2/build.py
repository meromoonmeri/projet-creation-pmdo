"""Village Pokémon place du marché (VIL2) — second village style Treasure Town, 4:3 (768 x 576).

.venv/bin/python source/village_pokemon_v2/build.py

Références canoniques : T00P02/T00P03 (Treasure Town, Explorers of Sky), rendus de vérité depuis la
ROM pret/pmd-sky (`reference/t00p02_t00.png` 672x504, `reference/t00p03_t00.png` 552x504 ; quelques
tuiles invalides remplacées par du noir, exclues des mesures) : maisons de guilde colorées (toits
rouges, tentes roses et vertes, dômes gris, échoppes bois), place de sable, mare, arbres ronds,
falaises. L'eau de la mare est générée (pas de pixels ROM), calibrée sur l'eau T00.
- decor.png : arrivée au sud, place du marché à l'est, grande halle de guilde au nord-est, deux
  maisonnettes à l'ouest, tente de cirque, tipis, dôme et mare magenta à l'ouest ; premier essai ;
- sol_complet.png : herbe jaune-vert seule, plein cadre ; premier essai ;
- eau.png : eau de mare bleu clair à vaguelettes, plein cadre ; premier essai ;
- temoin_sans_maisons.png : le décor édité sans maisons, arbres ni mare (recalé (0, 0)) ; l'écart
  décor / témoin isole les bâtiments et les arbres ; jamais exporté.
Calques : sol complet, herbe, place, tapis, halle, maisons, tentes, arbres, structures (bois :
étals du marché, barrières, tonneaux), falaises, eau (anim), pétales (anim).
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks :
- eau : dérive latérale de +-4 px + onde progressive (3 longueurs d'onde par boucle), période 48 ;
- pétales : 12 pétales blancs et roses qui dérivent sur 40 phases puis s'effacent 8 phases.
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
REF2 = HERE / 'reference' / 't00p02_t00.png'
REF3 = HERE / 'reference' / 't00p03_t00.png'
CANON = HERE / 'reference' / 'canon_stats.json'
LOT = 'village_pokemon_v2'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'village_pokemon_v2'
NAMESPACE = 'village_pokemon_v2'
ASSET = 'vil2_village_pokemon'
PFX = 'VIL2'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/t00p02_t00.png', f'source/{LOT}/reference/t00p03_t00.png'],
     'prompt': 'Treasure Town village, same textures/palette/pixel-art as references. NEW wide 4:3 (1200x896) '
     'layout: arrival SOUTH on a sandy path; busy market square EAST with stalls and awnings; big yellow guild hall '
     'with red roof and red carpet NORTH-EAST; row of two small blue-grey-roof cottages WEST; small round pond WEST '
     'of center filled FLAT pure magenta (255,0,255); striped shop tent near the square, small tipi south-west; '
     'round trees, fences, stalls, barrels, flowers; cliffs and dense forest borders. Magenta pond only, no water '
     'texture, no characters, no text.',
     'essais': 'premier essai ; conforme (halle au nord-est, maisonnettes, tente de cirque, tipis, dôme, mare magenta)'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/reference/t00p02_t00.png', f'source/{LOT}/bruts/decor.png'],
     'prompt': 'Same meadow grass as references, full-frame 4:3 tiling texture with tufts; no paths, houses, trees, '
     'water, magenta or text.',
     'essais': 'premier essai ; herbe seule, conforme'},
    {'file': 'eau.png', 'images': [f'source/{LOT}/reference/t00p02_t00.png'],
     'prompt': "Same light-blue water as the reference's water, calm pond ripples full-frame 4:3; no sand, grass, "
     'houses, magenta or text.',
     'essais': 'premier essai ; eau de mare à vaguelettes, conforme'},
    {'file': 'temoin_sans_maisons.png', 'images': [f'source/{LOT}/bruts/decor.png'],
     'prompt': 'Same image: remove guild hall, cottages, circus tent, tipis, stone dome, market stalls, trees, hedge '
     'ring and magenta pond (grass / sandy ground instead); keep paths, square, cliffs, fences, barrels, flowers. '
     'No magenta. Segmentation witness, never exported.',
     'essais': 'premier essai ; témoin de segmentation recalé (0, 0), jamais exporté'},
]
# ---- Eau : dérive latérale + onde progressive, période 48 (boucle exacte).
EAU_DERIVE = 4
EAU_ONDE = 0.05
EAU_LONGUEUR = 64
EAU_TOURS = 3
# ---- Pétales : 12 pétales, dérive de 40 phases, 8 phases cachés, boucle exacte de 48.
N_PETALES = 12
PETAL_SPAN = 40
BLANC, ROSE = (250, 250, 248), (250, 200, 215)
_YY, _XX = np.mgrid[:H, :W].astype(float)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'herbe', 'place', 'tapis'], 96),
                  'batiments': (['halle', 'maisons', 'tentes'], 96),
                  'arbres': (['arbres'], 64), 'bois': (['structures', 'falaises'], 64)}
STATIC = ['herbe', 'place', 'tapis', 'halle', 'maisons', 'tentes', 'arbres', 'structures', 'falaises']
ANIMS = ['eau', 'petales']
DRAW_ORDER = ['sol_complet', 'herbe', 'place', 'tapis', 'halle', 'maisons', 'tentes', 'arbres',
              'structures', 'falaises', 'eau', 'petales']


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


# ---------------------------------------------------------------- fidélité au T00 (même classifieur des deux côtés)
def materials(a):
    """Herbe jaune-vert, sable des chemins, bois brun, toits rouges. Les tuiles glitchées noires
    des rendus ROM (lum <= 8) sont exclues des deux côtés, ainsi que le magenta de travail."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    v = (lum > 8) & ~((r > 200) & (g < 100) & (b > 200))
    return {'herbe': v & (r - g < -15) & (lum > 90) & (lum < 160),
            'sable': v & (r - g > 12) & (lum > 165),
            'bois': v & (r > g + 8) & (g > b + 15) & (lum > 100) & (lum < 175),
            'toit': v & (r - g > 70) & (lum > 90) & (lum < 160)}


def fidelity(decor, ref2, ref3):
    fr2, fr3, fd = materials(ref2), materials(ref3), materials(decor); out = {}
    for k in fr2:
        mr = np.concatenate([ref2[fr2[k]], ref3[fr3[k]]]).mean(0)
        md = decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def recalage(a, o, zone):
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(o, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen': round(err[(0, 0)], 2), 'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a, t):
    """a : décor, t : témoin sans maisons. eau = magenta fermé 2 px, trous bouchés, frange rose à
    moins de 3 px rattachée, composantes >= 500 px (1 mare ; filtre les fleurs magenta) ; objets =
    écart décor / témoin lissé 3 px > 28, trous bouchés, hors mare ; tapis = composantes rouges
    (r - g > 70) >= 200 px à plus de 60 % de voisins sable hors décor bâti, voisinage pleine
    image (tapis de la halle 0,68 ; toit 0,00, pans et tipi <= 0,29, auvent 14 voisins : les pans
    rouges des tentes et des tipis restent des murs) ;
    vert = g > r + 10 et g >= b (les toits bleus ne sont pas verts) ; arbres d'abord
    (composantes vertes > 50 %) ; puis les mixtes >= 3000 px sont découpées au pixel (vert vers
    arbres, chaque morceau non vert routé) ; routage : structures si bois > 45 % et rouge < 15 %
    (étals du marché ; la halle, plus grande composante, va direct aux maisons), tentes si rouge
    > 20 % et pans clairs > 20 % (cirque 0,26, tipis 0,30-0,31 ; halle 0,16 exclue deux fois),
    maisons sinon ; la plus grande devient la halle ;
    miettes adjacentes au bâti (dilaté 6 px) absorbées (bois vers structures, le reste vers
    maisons) ; arbres =
    composantes vertes (> 50 %) >= 300 px ; la rive (dilaté 10 px de la mare) est rendue à la
    place ; miettes rendues au sol. Sol (hors eau, maisons, arbres, tapis) : place =
    clair et chaud (r - g > 12, lum > 165) ; vert = r - g < -15 : herbe si lum >= 105, buissons
    (vers arbres) sinon ; falaises = brun (r - b > 40, 100 < lum < 175) relié au bord ; bois = brun
    intérieur en composantes >= 60 px (barrières, tonneaux, bancs, vers structures) ; reste (fleurs,
    cailloux, pierres grises) : vers l'herbe si g >= r, vers la place sinon (pas de couche
    rochers : les pierres sont menues et marchables, comme les fleurs)."""
    af = a.astype(float); r, g, b = af[..., 0], af[..., 1], af[..., 2]; lum = lum_of(af)
    mag = (r > 200) & (g < 100) & (b > 200)
    eau = nd.binary_fill_holes(keep_large(close_(mag, 2), 500))
    fringe = (r > 150) & (b > 150) & (g < 150) & nd.binary_dilation(eau, iterations=3)
    eau = keep_large(nd.binary_fill_holes(eau | fringe), 500)
    assert int(nd.label(eau)[1]) == 1, 'mare introuvable ou multiple'
    sand = (r - g > 12) & (lum > 165)
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    shore = nd.binary_dilation(eau, iterations=10) & ~eau
    obj = keep_large(nd.binary_fill_holes(close_(diff > 28, 3)), 30) & ~eau & ~shore
    rl, rn = nd.label((r - g > 70) & obj); tapis = np.zeros_like(obj)
    for i, s in enumerate(nd.find_objects(rl)):
        m = rl[s] == i + 1
        if m.sum() >= 200:
            rm = np.zeros_like(obj); rm[s] = m
            hors = nd.binary_dilation(rm, iterations=3) & ~rm & ~obj
            if hors.sum() >= 30 and sand[hors].mean() > 0.6:
                tapis[s] |= m
    obj &= ~tapis
    ol, on = nd.label(obj); maisons = np.zeros_like(obj); arbres = np.zeros_like(obj)
    structures = np.zeros_like(obj); tentes = np.zeros_like(obj); miettes = 0; mixtes = 0
    woodpx = (r - b > 40) & (lum > 100) & (lum < 175)
    greenpx = (g > r + 10) & (g >= b)
    rouge = r - g > 70; clair = (r > 180) & (g > 150) & (r - b > 40)

    big_id = max(range(1, on + 1), key=lambda i: (ol == i).sum())

    def route(pm, s, test_tente=True):
        wo = woodpx[s][pm].mean(); re = rouge[s][pm].mean()
        if wo > 0.45 and re < 0.15:
            structures[s] |= pm
        elif test_tente and re > 0.2 and clair[s][pm].mean() > 0.2:
            tentes[s] |= pm
        else:
            maisons[s] |= pm

    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        green = greenpx[s][m].mean()
        if green > 0.5 and m.sum() >= 300:
            arbres[s] |= m
        elif m.sum() >= 3000 and 0.25 < green < 0.75:
            gm = m & greenpx[s]
            arbres[s] |= gm; mixtes += 1
            pl = nd.label(m & ~gm)[0]
            for j in range(1, pl.max() + 1):
                route(pl == j, s)
        elif green <= 0.5 and m.sum() >= 1000:
            route(m, s, test_tente=(i + 1 != big_id))
        else:
            miettes += m.sum()
    add = obj & ~maisons & ~arbres & ~structures & ~tentes & nd.binary_dilation(
        maisons | structures | tentes, iterations=6)
    structures |= add & woodpx; maisons |= add & ~woodpx
    miettes = int((obj & ~maisons & ~arbres & ~structures & ~tentes).sum())
    ml = nd.label(maisons)[0]; sizes = sorted(((ml == i).sum(), i) for i in range(1, ml.max() + 1))
    halle = np.zeros_like(obj)
    if sizes:
        halle = ml == sizes[-1][1]
        maisons &= ~halle
    ground = ~(eau | maisons | arbres | tapis | halle | tentes | structures)
    place = ground & sand
    vert = ground & (r - g < -15)
    herbe = vert & (lum >= 105)
    buisson = keep_large(vert & (lum < 105), 150)
    arbres |= buisson
    herbe |= vert & (lum < 105) & ~buisson
    ground = ~(eau | maisons | arbres | tapis | halle | tentes | structures | place | herbe)
    brun = ground & (r - b > 40) & (lum > 100) & (lum < 175)
    lab, _ = nd.label(brun); e = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])
    falaises = np.isin(lab, e[e > 0])
    structures |= keep_large(brun & ~falaises, 60)
    rest = ground & ~falaises & ~structures
    herbe |= rest & (g >= r)
    place |= rest & (g < r)
    place |= shore & ~(eau | maisons | arbres | tapis | halle | tentes | structures | place | herbe | falaises)
    masks = dict(eau=eau, halle=halle, maisons=maisons, tentes=tentes, arbres=arbres,
                 structures=structures, falaises=falaises, place=place, tapis=tapis, herbe=herbe)
    cov = sum(v.astype(int) for v in masks.values())
    assert (cov == 1).all(), 'partition incomplète'
    seg = {'objets': int(on), 'halle': int(nd.label(halle)[1]), 'maisons': int(nd.label(maisons)[1]),
           'tentes': int(nd.label(tentes)[1]), 'arbres': int(nd.label(arbres)[1]),
           'mixtes_decoupes': int(mixtes), 'miettes_rendues_au_sol_px': int(miettes),
           'structures_pct': round(100 * structures.mean(), 2),
           'falaises_pct': round(100 * falaises.mean(), 2), 'place_pct': round(100 * place.mean(), 2),
           'tapis_px': int(tapis.sum()), 'herbe_pct': round(100 * herbe.mean(), 2)}
    return masks, seg


def palette_match(brut, mean_c):
    """Offset additif par canal vers la cible + épaule douce (monotone, teintes préservées)."""
    x = brut.astype(float) + (np.array(mean_c, float) - brut.reshape(-1, 3).mean(0))
    return np.where(x > 200, 255 - 55 * np.exp(-(x - 200) / 60), x).round().astype('uint8')


# ---------------------------------------------------------------- eau animée (texture générée calibrée)
EAU_COLORS = 64


def eau_palette(base):
    """Palette partagée (MEDIANCUT, sans tramage) calculée sur la base calibrée."""
    return Image.fromarray(base).quantize(colors=EAU_COLORS, method=Image.MEDIANCUT, dither=Image.Dither.NONE)


def eau_frame(base, mask, t, pal=None):
    """Phase t (modulo 48) : dérive latérale de +-4 px + onde progressive (3 longueurs d'onde de
    64 px par boucle) + pulsation légère ; période 48 exacte."""
    t %= PHASES
    ph = 2 * np.pi * t / PHASES
    dx = int(round(EAU_DERIVE * np.sin(ph)))
    rolled = np.roll(base, dx, 1).astype(float)
    onde = (1 + EAU_ONDE * np.sin(2 * np.pi * _XX / EAU_LONGUEUR - EAU_TOURS * ph) + 0.02 * np.sin(ph))
    fr = np.zeros((H, W, 4), 'uint8')
    fr[mask, :3] = np.clip(rolled[mask] * onde[mask, None], 0, 255).round().astype('uint8')
    if pal is not None:
        q = np.asarray(Image.fromarray(fr[..., :3]).quantize(palette=pal, dither=Image.Dither.NONE).convert('RGB'))
        fr[..., :3] = 0; fr[mask, :3] = q[mask]
    fr[mask, 3] = 255
    return fr


def eau_frames(base, mask, pal=None):
    return [eau_frame(base, mask, t, pal) for t in range(PHASES)]


# ---------------------------------------------------------------- pétales qui dérivent
def petal_sprites():
    """Losanges 3 x 3 blanc et rose + point de fin de course."""
    out = {}
    for name, c in (('blanc', BLANC), ('rose', ROSE)):
        sp = np.zeros((3, 3, 4), 'uint8')
        for y, x in ((0, 1), (1, 0), (1, 1), (1, 2), (2, 1)):
            sp[y, x] = (*c, 255)
        out[name] = sp
    dot = np.zeros((3, 3, 4), 'uint8'); dot[1, 1] = (*BLANC, 255); out['point'] = dot
    return out


def place_petales(walk, rng):
    ys, xs = np.nonzero(walk[60:520]); petales = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]) + 60, int(xs[i])
        if taken[y, x] or x + 26 >= W or y + 10 >= H:
            continue
        if not walk[y + 8, x + 22]:
            continue
        petales.append({'x0': x, 'y0': y, 'phase': int(rng.integers(PHASES)),
                        'ton': 'rose' if len(petales) % 3 == 2 else 'blanc'})
        taken[max(0, y - 40):y + 40, max(0, x - 40):x + 40] = True
        if len(petales) == N_PETALES:
            break
    assert len(petales) == N_PETALES, f'pétales placés : {len(petales)}'
    return petales


def petal_frames(petales, spr):
    frames = []
    for t in range(PHASES):
        a = np.zeros((H, W, 4), 'uint8')
        for p in petales:
            k = (t - p['phase']) % PHASES
            if k >= PETAL_SPAN:
                continue
            x = p['x0'] + int(round(20 * k / PETAL_SPAN)) + int(round(3 * np.sin(2 * np.pi * k / 10)))
            y = p['y0'] + int(round(6 * k / PETAL_SPAN))
            sp = spr[p['ton']] if k < PETAL_SPAN - 6 else spr['point']
            mm = sp[..., 3] > 0
            if 0 <= y < H - 3 and 0 <= x < W - 3:
                a[y:y + 3, x:x + 3][mm] = sp[mm]
        frames.append(a)
    return frames


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Village Pokémon (VIL1)')
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
    o.update(Name={'DefaultText': 'Village Pokémon - place du marché (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur T00P02/T00P03 (Treasure Town, Explorers of Sky) ; '
                     'eau de mare generee calibree, petales calcules. Place du marche a l est, halle au nord-est. '
                     'Marqueurs d edition, sans warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': "Arrivée, place et objectif (repères d'édition)", 'Visible': True, 'MapChars': [],
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
  <Name>Village Pokémon VIL1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Place a la mare, halle de guilde au nord, eau et petales animes. Projet de carte, sans warp.</Description>
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
    a, t, f, wtr = rgb(RAW / 'decor.png'), rgb(RAW / 'temoin_sans_maisons.png'), rgb(RAW / 'sol_complet.png'), rgb(RAW / 'eau.png')
    r2, r3 = rgb(REF2), rgb(REF3)
    canon = json.loads(CANON.read_text())
    assert a.shape[:2] == t.shape[:2] == f.shape[:2] == wtr.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, t)
    objs = m['maisons'] | m['arbres'] | m['tapis'] | (np.abs(a - t).mean(2) > 10)
    reg = {'temoin': recalage(a, t, ~nd.binary_dilation(objs, iterations=4))}
    gmatch = palette_match(wtr, canon['t00_eau_mean'])
    Image.fromarray(gmatch).save(OUT / 'review' / f'{PFX}_eau_calibree.png')
    ex, cols = down_class(a, m, ['eau', 'halle', 'maisons', 'tentes', 'arbres', 'structures',
                                 'falaises', 'place', 'tapis', 'herbe'])
    _, colse = down_class(gmatch, {'eau': m['eau']}, ['eau'])
    cols['eau'] = colse['eau']
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    cl, _ = nd.label(close_(ex['herbe'] | ex['place'] | ex['tapis'], 2))
    seed = cl[H - 1][(ex['herbe'] | ex['place'] | ex['tapis'])[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0])) & (ex['herbe'] | ex['place'] | ex['tapis'])
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    assert walk.mean() > 0.05, 'zone praticable trop petite'
    base_eau = down_full(gmatch)
    eau_pal = eau_palette(base_eau)
    eau = eau_frames(base_eau, ex['eau'], eau_pal)
    spr = petal_sprites()
    for name, sp in spr.items():
        Image.fromarray(sp).save(OUT / 'poses' / f'{PFX}_petale_{name}.png')
    petales = place_petales(walk, np.random.default_rng(11))
    pet_an = petal_frames(petales, spr)
    anim = {'eau': eau, 'petales': pet_an}
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
    boss = free_near(W // 2, 340)
    tl = nd.label(ex['tapis'])[0]; big = tl == (np.bincount(tl.ravel())[1:].argmax() + 1)
    yt, xt = np.nonzero(big)
    objectif = free_near(int(xt.mean()), int(yt.max()) + 8)
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
    # Planche : rampe de l'eau calibrée (16 quantiles) + sprites des pétales, sur sable.
    flat = gmatch.reshape(-1, 3).astype(float); lum = flat @ [.299, .587, .114]; order = np.argsort(lum)
    ramp = [tuple(int(v) for v in flat[order[int(len(order) * (i + 0.5) / 16)]]) for i in range(16)]
    sheet = Image.new('RGBA', (16 * 24 + 16, 24 + 16 + 56), (246, 202, 142, 255)); d = ImageDraw.Draw(sheet)
    for i, c in enumerate(ramp):
        d.rectangle([8 + i * 24, 8, 8 + i * 24 + 21, 31], fill=(*c, 255))
    for j, shape in enumerate(['blanc', 'rose', 'point']):
        sheet.alpha_composite(Image.fromarray(spr[shape]).resize((40, 40), Image.Resampling.NEAREST), (8 + j * 56, 44))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_village_pokemon_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, r2, r3)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    manifest = {
        'lot': LOT, 'title': 'Village Pokémon — place du marché (Treasure Town)', 'prefix': PFX,
        'namespace': NAMESPACE, 'asset': ASSET, 'type': 'village / place centrale', 'format': '4:3 vaste',
        'size_px': [W, H], 'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': "second village pokémon (nouveau layout), textures canoniques T00P02/T00P03, découpage fin : halle, maisons, tentes, structures",
        'agent_choices': {
            'reference': 'T00P02/T00P03 canoniques (Treasure Town, Explorers of Sky) : rendus de vérité ROM pret/pmd-sky (tuiles invalides exclues)',
            'methode_vfx': "eau de mare générée (pas de pixels ROM), calibrée sur l'eau T00 ; pétales calculés",
            'layout': "chemin d'arrivée au sud, place du marché à l'est, halle de guilde au nord-est, maisonnettes à l'ouest, tente de cirque, tipis, dôme, mare à l'ouest",
            'prefix': 'VIL2, série V des villages (libre)',
            'biome': 'village pokémon ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition VIL2 générée avec T00P02/T00P03 en référence (mare magenta)'},
                   {'file': f'source/{LOT}/bruts/temoin_sans_maisons.png', 'sha256': sha(RAW / 'temoin_sans_maisons.png'),
                    'size_px': list(SRC), 'role': 'témoin de segmentation recalé (0, 0), jamais exporté'},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
                    'size_px': list(SRC), 'role': 'herbe seule, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/bruts/eau.png', 'sha256': sha(RAW / 'eau.png'), 'size_px': list(SRC),
                    'role': "eau de mare générée à vaguelettes, calibrée sur l'eau T00, animée"},
                   {'file': f'source/{LOT}/reference/t00p02_t00.png', 'sha256': sha(REF2),
                    'size_px': list(Image.open(REF2).size), 'role': 'vérité ROM T00P02 : matière + fidélité'},
                   {'file': f'source/{LOT}/reference/t00p03_t00.png', 'sha256': sha(REF3),
                    'size_px': list(Image.open(REF3).size), 'role': 'vérité ROM T00P03 : matière + fidélité'},
                   {'file': f'source/{LOT}/reference/canon_stats.json', 'sha256': sha(CANON), 'size_px': 'n/a',
                    'role': 'statistiques canoniques (eau T00), cible du calibrage'}],
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (sol 96, maisons 96, arbres 64, bois 64), sans tramage ; eau calibrée quantifiée sur 64 couleurs partagées (MEDIANCUT, sans tramage), pétales calculés',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'recalage': reg,
        'calibrage_eau': {'cible': 't00_eau_mean de canon_stats.json',
                          'methode': 'offset additif par canal + épaule douce monotone',
                          'apres_moyenne': [round(float(v), 1) for v in gmatch.reshape(-1, 3).mean(0)]},
        'segmentation': seg,
        'fidelite_rip': {**fid, 'seuil': FIDELITY_MAX,
                         'methode': 'moyenne RGB par matière (herbe, sable, bois, toit), même classifieur pixel sur T00P02+T00P03 et sur le brut, tuiles glitchées exclues ; distance euclidienne ; seuil 35'},
        'layers': layer_list,
        'eau': {'phases': PHASES, 'frame_length_ticks': TICKS, 'derive_px': EAU_DERIVE, 'onde': EAU_ONDE,
                'longueur_onde_px': EAU_LONGUEUR, 'tours_par_boucle': EAU_TOURS,
                'palette_partagee': EAU_COLORS,
                'rampe_calibree': [list(c) for c in ramp],
                'loi': 'dx = 4 sin(2 pi t / 48) ; onde 1 + 0.05 sin(2 pi x / 64 - 6 pi t / 48) + 0.02 sin(2 pi t / 48) ; boucle exacte de période 48',
                'origine': 'texture generee calibree sur T00 (ni pixels du rip ni pixels ROM)'},
        'petales': {'phases': PHASES, 'frame_length_ticks': TICKS, 'nombre': len(petales), 'course': PETAL_SPAN,
                    'couleurs': {'blanc': list(BLANC), 'rose': list(ROSE)},
                    'placements': petales,
                    'loi': f'k = (t - phase) mod {PHASES} ; visible k < {PETAL_SPAN} : x = x0 + 20k/40 + 3 sin(2 pi k / 10), y = y0 + 6k/40, losange 3x3 puis point les 6 dernières phases ; caché sinon ; boucle exacte',
                    'origine': 'pétales calculés dérivant sur la place'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors herbe, place et tapis praticables (cell_grid, franchissement 4 px) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition et eau générées, eau calibrée sur T00P02/T00P03 ; aucun pixel ROM dans les calques.',
                  "Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé."],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'seg': seg, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
