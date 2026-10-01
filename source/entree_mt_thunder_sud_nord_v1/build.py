"""Entrée Mt. Thunder sud -> nord V1 (EMT1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « Continue ! Très bon travail » (27 septembre, après ECV1) : carte suivante, biome choisi par l'agent.
Référence `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png`
(432 x 498) : planche de la salle du sommet de Mt. Thunder (Red Rescue Team) : plateau de sable, falaises de roche
brune, pics, mer de nuages d'orage (partie haute, y < 352) ; en bas, sur fond noir, 4 éclairs, l'arc « Flash » et
les couleurs « Normal » / « Fading » (note de la planche : « Taken from the left side. Beside the first lightning,
they all appear mirrored on the right side. »). Jamais source d'une entrée de la série ; déjà utilisée hors série
par `mt_thunder_orage_v1` sur trois anciennes branches (01a0d8a8, 01a0d9b3, 01a0d9f7), dont rien n'est repris.
Toutes les autres captures de la racine sont déjà prises, sauf oldcastlepmd (un intérieur) ; relevé du 27 septembre.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), premier essai, conforme (sable 4,0 ; roche 6,8 ; ciel 7,4 ; nuages
  sombres 19,5 ; nuages clairs 13,5 ; seuil 35) ;
- sol_complet.png : sable seul (fond plein, distance 3,7).
Calques : sol complet, sable, cailloux (petits cailloux au sol), pics (pics de roche et pierres moussues), falaise
(bords et gradins du plateau), piton (roche autour de la grotte), seuil (sol de terre de la grotte, praticable),
profondeur (grotte), ciel, nuages.
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks (4 s) :
- lueurs : l'arc « Flash » du rip (pixels EXACTS) s'allume sur les nuages au pied de chaque éclair ;
- eclairs : les 4 éclairs du rip (pixels EXACTS) ; 6 éclairs par boucle, un toutes les 8 phases ; l'éclair 1 à gauche
  seulement, les éclairs 2 à 4 à gauche ou en miroir à droite (note de la planche) ; « Normal » 2 phases puis
  « Fading » 2 phases (couleurs EXACTES de la planche), puis rien.
Scène : 240 ticks = 4 s.
Lancer : .venv/bin/python source/entree_mt_thunder_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png'
REF = R / REF_NAME
REF_SCENE_H = 352                          # la scène s'arrête en y = 352 ; en dessous, planche des éclairs sur noir
OUT = R / 'renders/entree_mt_thunder_sud_nord_v1'
STAGE = R / '.cache/entree_mt_thunder_sud_nord_v1/entree_mt_thunder_sud_nord'
NAMESPACE = 'entree_mt_thunder_sud_nord'
ASSET = 'emt1_entree_mt_thunder'
PFX = 'EMT1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
LOT = 'source/entree_mt_thunder_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the top part of the reference image (Pokemon Mystery '
     'Dungeon Mt. Thunder summit): same pale yellow sandy ground with tiny grey pebbles, same brown rocky cliff edges '
     'with cracks, same small pointed tan rock spikes, same scalloped storm clouds in grey-purple tones (darker '
     'purple-grey clouds higher up, light grey and white clouds lower down), same dark grey storm sky. Make a NEW, '
     'larger top-down map. WIDE LANDSCAPE 4:3, zoomed out so the summit feels vast. Layout: the player arrives at the '
     'SOUTH (bottom edge center) on a narrow sandy mountain ridge path rising out of the clouds; the path climbs north '
     'and opens onto a wide irregular sandy summit plateau edged by brown rocky cliffs, with a few rock spikes and '
     'pebbles; at the NORTH (top center) a rocky crag of the same brown rock with a dark cave entrance, the sand leading '
     'right up to the dark opening. A sea of scalloped storm clouds fills the left and right sides and the bottom '
     'corners; dark storm sky at the top corners. No lightning, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (sable 4.0, roche 6.8, ciel 7.4, nuages sombres 19.5, nuages clairs 13.5)'},
    {'file': 'sol_complet.png', 'images': [REF_NAME], 'prompt':
     "Fill the ENTIRE image edge to edge with only the pale yellow sandy ground texture from the reference image's "
     'summit plateau: same pale yellow sand colour, same subtle pixel-art speckle texture and faint darker patches, '
     'keep the texture detail. No pebbles, no rocks, no cliffs, no clouds, no dark areas. Wide landscape 4:3.',
     'essais': 'premier essai ; moyenne (234.1,225.0,157.0), distance 3.7 au sable du rip'},
]
# ---- Planche du rip (sous la scène) : éclairs d'une seule couleur (240,240,0), arc Flash (240,240,128).
BOLTS = {1: (372, 443, 121, 129), 2: (372, 436, 169, 185), 3: (372, 498, 219, 243), 4: (372, 475, 284, 307)}  # y0,y1,x0,x1
FLASH_BOX = (393, 401, 15, 55)
SWATCH = {'normal': ((420, 55), (420, 72)), 'fading': ((437, 55), (437, 72))}   # (pâle, vif) : centres des pastilles
# ---- Éclairs : (éclair, miroir, x gauche, y haut, décalage de phase) en coordonnées finales.
STRIKES = [(1, False, 64, 70, 0), (3, True, 676, 150, 8), (2, False, 118, 250, 16),
           (4, True, 650, 330, 24), (3, False, 40, 360, 32), (2, True, 712, 50, 40)]
NORMAL_PH, FADING_PH = 2, 2                # phases locales 0-1 : Normal, 2-3 : Fading, 4-47 : rien


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sable': (['sol_complet', 'sable'], 32), 'roche': (['cailloux', 'pics', 'falaise', 'piton', 'seuil'], 96),
                  'orage': (['ciel', 'nuages'], 32), 'grotte': (['profondeur'], 12)}
STATIC = ['sable', 'cailloux', 'pics', 'falaise', 'piton', 'seuil', 'profondeur', 'ciel', 'nuages']
ANIMS = ['lueurs', 'eclairs']


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
    """Sable jaune pâle, roche brune, et gris de l'orage PAR TON (ciel < 90 <= nuages sombres < 170 <= nuages clairs) :
    les nuages sont des tons discrets (64,56,64) ... (240,240,240) et une moyenne unique dépend des proportions."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a); sat = a.max(-1) - a.min(-1)
    sable = (r > 200) & (g > 180) & (r - b > 60)
    grey = (sat < 30) & (lum > 20)
    return {'sable': sable, 'roche': (r > g) & (g > b) & (r - b > 25) & (lum < 185) & (lum > 60) & ~sable,
            'ciel': grey & (lum < 90), 'nuages_sombres': grey & (lum >= 90) & (lum < 170), 'nuages_clairs': grey & (lum >= 170)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def fidelity_clouds_one_group(decor, ref):
    """Mesure écartée, gardée pour mémoire : tous les gris de l'orage en un seul groupe."""
    f = lambda a: ((a.max(-1) - a.min(-1)) < 30) & (lum_of(a) > 40)
    return round(float(np.linalg.norm(ref[f(ref)].mean(0) - decor[f(decor)].mean(0))), 1)


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """Seuils mesurés sur le brut (1200 x 896) :
    grotte = lum < 55 au haut-centre (x 520-690, y < 200), ouverte 3 px, composante qui touche (580-620, 110-160),
    dilatée 2 px dans lum < 70, trous bouchés ; sable = r > 195, g > 175, r-b > 45, fermé/ouvert 2 px, > 20000 px, trous
    bouchés ; relief = sable + roche brune (r > g >= b, r-b >= 25) + grotte, fermé 3 px, trous bouchés en comptant la
    rangée du haut comme relief au-dessus du piton (son sommet gris touche le bord), > 50000 px ; îlots = trous du sable
    qui ne sont pas du sable, ouverts 1 px, fermés 2 px et bouchés (pics creux) : >= 150 px = pics (et pierres
    moussues), 12 à 150 px = cailloux ; seuil = roche sous la bouche entre les montants de l'arche (étendue de la
    bouche dans son tiers bas, marge 4 px), colonne par colonne jusqu'au premier sable (<= 30 px) ; piton = roche du
    relief à y < 190 et 430 < x < 780 ; falaise = le reste de la roche ; ciel = gris de lum < 90 hors relief, ouvert 3 px, relié au bord haut ; nuages = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    sandc = (r > 195) & (g > 175) & (r - b > 45)
    rockc = (r > g) & (g >= b) & (r - b >= 25) & ~sandc
    dark = (lum < 55) & (yy < 200) & (xx > 520) & (xx < 690)
    cl, _ = nd.label(open_(dark, 3)); ids = [i for i in np.unique(cl[110:160, 580:620]) if i]
    assert len(ids) == 1, ids
    mouth = nd.binary_fill_holes(nd.binary_dilation(cl == ids[0], iterations=2) & (lum < 70))
    sand = keep_large(open_(close_(sandc, 2), 2), 20000); sand = nd.binary_fill_holes(sand) & ~mouth
    land = close_(sand | rockc | mouth, 3)
    top = np.zeros((1, ww), bool); xs0 = np.nonzero(land[0] & (xx[0] > 430) & (xx[0] < 780))[0]
    top[0, xs0.min():xs0.max() + 1] = True
    land = nd.binary_fill_holes(np.vstack([top, land]))[1:]
    land = keep_large(land, 50000)
    isl = open_(sand & ~sandc, 1)
    isl = nd.binary_fill_holes(close_(isl, 2)) & sand
    il, inn = nd.label(isl); sz = nd.sum(isl, il, range(1, inn + 1))
    pics = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 150])
    cail = np.isin(il, [i + 1 for i, v in enumerate(sz) if 12 <= v < 150])
    rock = land & ~sand & ~mouth
    # Seuil : sol de terre de la grotte (dégradé sombre -> sable) entre les montants de l'arche (étendue de la bouche
    # dans son tiers bas, 4 px de marge), colonne par colonne, de la bouche jusqu'au premier sable (30 px au plus).
    ys_, _ = np.nonzero(mouth); my0, my1 = int(ys_.min()), int(ys_.max())
    low = mouth & (yy >= my0 + (my1 - my0) * 2 // 3); ax = np.nonzero(low.any(0))[0]; ax0, ax1 = int(ax[0]) + 4, int(ax[-1]) - 4
    seuil = np.zeros_like(mouth)
    for x in range(ax0, ax1 + 1):
        yb = int(np.nonzero(mouth[:, x])[0].max()) + 1 if mouth[:, x].any() else my1 + 1
        for y in range(yb, min(yb + 30, hh)):
            if sand[y, x]:
                break
            seuil[y, x] = True
    seuil &= rock
    piton = rock & (yy < 190) & (xx > 430) & (xx < 780) & ~seuil
    fal = rock & ~piton & ~seuil
    sky = ~land
    ciel = keep_large(open_(sky & (lum < 90), 3), 2000)
    lab, _ = nd.label(ciel); t = np.unique(lab[0]); ciel = np.isin(lab, t[t > 0])
    masks = dict(profondeur=mouth, pics=pics, cailloux=cail, sable=sand & ~pics & ~cail, seuil=seuil, piton=piton, falaise=fal,
                 ciel=ciel, nuages=sky & ~ciel)
    ys_, xs_ = np.nonzero(mouth)
    seg = {'grotte_y': [int(ys_.min()), int(ys_.max())], 'grotte_x': [int(xs_.min()), int(xs_.max())],
           'pics': int(sum(v >= 150 for v in sz)), 'cailloux': int(sum(12 <= v < 150 for v in sz)),
           'arche_x': [ax0, ax1], 'seuil_px': int(seuil.sum())}
    return masks, seg


# ---------------------------------------------------------------- sprites exacts de la planche
def rip_sheet(ref):
    """Éclairs (composante de (240,240,0) dans la boîte), arc Flash ((240,240,128)) et couleurs des pastilles."""
    sw = {k: tuple(tuple(int(v) for v in ref[y, x]) for y, x in pts) for k, pts in SWATCH.items()}
    bolts = {}
    for k, (y0, y1, x0, x1) in BOLTS.items():
        m = (ref[y0:y1, x0:x1] == sw['normal'][1]).all(-1)
        lab, n = nd.label(m, structure=np.ones((3, 3))); assert n == 1, (k, n)
        bolts[k] = m
    y0, y1, x0, x1 = FLASH_BOX
    flash = (ref[y0:y1, x0:x1] == sw['normal'][0]).all(-1)
    return bolts, flash, sw


def sprite(mask, color):
    s = np.zeros((*mask.shape, 4), 'uint8'); s[mask] = (*color, 255); return s


def strike_state(u):
    """Phase locale -> 'normal', 'fading' ou None."""
    return 'normal' if u < NORMAL_PH else 'fading' if u < NORMAL_PH + FADING_PH else None


def strike_boxes(bolts, flash, strikes=STRIKES):
    """Boîtes (x0, y0) de l'éclair et de l'arc pour chaque éclair : l'arc est centré sous le bas de l'éclair."""
    out = []
    for k, mirror, x, y, off in strikes:
        m = bolts[k][:, ::-1] if mirror else bolts[k]
        ys, xs = np.nonzero(m); yb = ys.max(); xb = int(round(xs[ys == yb].mean()))
        out.append((m, x, y, x + xb - flash.shape[1] // 2, y + yb - flash.shape[0] // 2 + 2, off))
    return out


def anim_frames(bolts, flash, sw, ts=range(PHASES), strikes=STRIKES):
    lue, ecl = [], []
    boxes = strike_boxes(bolts, flash, strikes)
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8'); f = np.zeros((H, W, 4), 'uint8')
        for m, x, y, fx, fy, off in boxes:
            st = strike_state((t - off) % PHASES)
            if st:
                paste(a, sprite(m, sw[st][1]), x, y)
                paste(f, sprite(flash, sw[st][0]), fx, fy)
        lue.append(f); ecl.append(a)
    return lue, ecl


def paste(frame, spr, x0, y0):
    hh, ww = spr.shape[:2]; x0, y0 = int(x0), int(y0)
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Mt. Thunder sud-nord V1 (EMT1)')
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


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
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
    o.update(Name={'DefaultText': 'Entree Mt. Thunder - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Mt. Thunder (Red Rescue Team) ; eclairs et '
                     'lueurs animes (sprites et couleurs Normal / Fading exacts du rip). Collisions de base a '
                     'verifier. Seuil non raccorde. Biome choisi par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
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
  <Name>Entree Mt. Thunder sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee par une crete de sable au sud, plateau sommital au-dessus des nuages d'orage, grotte dans un piton au nord, generee au format 4:3 (ref. rip Mt. Thunder), eclairs animes. Pas une aventure jouable.</Description>
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
    a, f, full = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    ref = full[:REF_SCENE_H]
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['profondeur', 'seuil', 'pics', 'cailloux', 'sable', 'piton', 'falaise', 'ciel', 'nuages']
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
    mouth = ex['profondeur']
    cand = ex['sable'] | ex['cailloux'] | ex['seuil']
    cl, _ = nd.label(cand); seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    bolts, flash, sw = rip_sheet(full)
    for k, bm in bolts.items():
        Image.fromarray(sprite(bm, sw['normal'][1])).save(OUT / 'poses' / f'{PFX}_eclair_{k}.png')
    Image.fromarray(sprite(flash, sw['normal'][0])).save(OUT / 'poses' / f'{PFX}_flash.png')
    lueurs, eclairs = anim_frames(bolts, flash, sw)
    anim = {'lueurs': lueurs, 'eclairs': eclairs}
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
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    dys, dxs = np.nonzero(mouth)
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    # Planche : les 4 éclairs et l'arc, en Normal puis en Fading, x3, sur le gris des nuages sombres.
    sprites = [sprite(bolts[k], sw[s][1]) for s in ('normal', 'fading') for k in BOLTS] + \
              [sprite(flash, sw[s][0]) for s in ('normal', 'fading')]
    cw, chh = 3 * 42, 3 * 128
    sheet = Image.new('RGBA', (len(sprites) * cw + 8, chh + 16), (112, 104, 112, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr); im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_mt_thunder_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'falaise'), ('roche', 'piton'), ('ciel', 'ciel'),
                  ('nuages_sombres', 'nuages'), ('nuages_clairs', 'nuages')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[f'{nm}:{k}'] = {'calque': nm, 'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                                  'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    boxes = strike_boxes(bolts, flash)
    manifest = {
        'lot': 'entree_mt_thunder_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'sommet d orage au-dessus des nuages (plateau de sable, grotte dans un piton), choisi par l agent (« Continue ! »)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet et sol complet '
                  'generes avec le rip en reference ; eclairs et arc Flash copies de la planche du rip',
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'scene_rows': [0, REF_SCENE_H],
                         'titre': 'Mt. Thunder, salle du boss (Red Rescue Team, GBA) : nom de fichier de la planche',
                         'deja_utilise_hors_serie': 'mt_thunder_orage_v1 sur 01a0d8a8, 01a0d9b3, 01a0d9f7 (rien repris)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur la scene du rip (y < 352) et sur '
                                    'le brut ; distance euclidienne ; seuil 35 ; gris de l orage mesures PAR TON',
                         'brut': fid, 'calques_finaux': final_fid,
                         'nuages_un_seul_groupe_ecarte': {'distance': fidelity_clouds_one_group(a, ref),
                                                          'raison': 'moyenne de tons discrets ponderee par leurs proportions '
                                                                    '(ciel sombre abondant dans le rip, bas de carte blanc dans le brut) : '
                                                                    'mesure la composition, pas la couleur ; remplacee par la mesure par ton'},
                         'sol_complet': round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid['sable']['rip_rgb']))), 1),
                         'eclairs': 'pixels et couleurs EXACTS de la planche du rip'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'eclairs': {'boites_rip': {str(k): list(v) for k, v in BOLTS.items()}, 'flash_rip': list(FLASH_BOX),
                    'pastilles': {k: [list(c) for c in v] for k, v in sw.items()},
                    'couleurs': 'eclair = pastille vive (240,240,0) puis (160,152,32) ; arc = pastille pale (240,240,128) '
                                'puis (184,176,120) : interpretation des pastilles Normal / Fading (paire pale, paire vive)',
                    'frappes': [list(s) for s in STRIKES],
                    'arcs': [[int(b[3]), int(b[4])] for b in boxes],
                    'normal_phases': NORMAL_PH, 'fading_phases': FADING_PH, 'phases': PHASES, 'frame_length_ticks': TICKS,
                    'miroir': 'eclair 1 a gauche seulement ; 2 a 4 a gauche ou en miroir a droite (note de la planche)',
                    'limite': 'l eclair 3 touche le bas de la planche (y = 498) : il est peut-etre tronque',
                    'origine': 'dessin et couleurs EXACTS de la planche ; placement, cadence et arc au pied de l eclair crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (sable, cailloux et seuil relies au bord sud)',
                   'seuil': 'premiere case 2 x 2 libre sous la grotte'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
