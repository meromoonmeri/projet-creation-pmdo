"""Fin Mt. Thunder V1 (FMT4) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (sommet d'orage de Mt. Thunder, cul-de-sac de boss et d'objectif, sans sortie) associée à
l'entrée EMT1 (`entree_mt_thunder_sud_nord_v1`).
Référence `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png`
(432 x 498) : planche de la salle du sommet de Mt. Thunder (Red Rescue Team) : plateau de sable, falaises de roche
brune, pics, mer de nuages d'orage (partie haute, y < 352) ; en bas, sur fond noir, 4 éclairs, l'arc « Flash » et
les couleurs « Normal » / « Fading » (note de la planche : « Taken from the left side. Beside the first lightning,
they all appear mirrored on the right side. »).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), 2e essai (1er essai écarté dans bruts/ecartes/ car roche trop sombre a
  68,3), conforme (sable 1,7 ; roche 10,2 ; ciel 6,6 ; nuages sombres 5,8 ; nuages clairs 15,0 ; seuil 35) ;
- sol_complet.png : sable seul (fond plein partagé avec EMT1, distance 3,7).
Calques : sol complet, sable, cailloux (petits cailloux au sol), pics (pics de roche et pierres moussues), falaise
(bords rocheux du plateau et de la crête), piton (massif rocheux de l'estrade nord), degres (escalier central de
l'estrade nord), esplanade (terrasse de sable au sommet de l'estrade nord), ciel, nuages.
Animations, chacune sur son calque, boucles fermées, 48 x 5 ticks (4 s) :
- lueurs : l'arc « Flash » du rip (pixels EXACTS) s'allume sur les nuages au pied de chaque éclair ;
- eclairs : les 4 éclairs du rip (pixels EXACTS) ; 6 éclairs par boucle, un toutes les 8 phases ; l'éclair 1 à gauche
  seulement, les éclairs 2 à 4 à gauche ou en miroir à droite ; « Normal » 2 phases puis « Fading » 2 phases.
Scène : 240 ticks = 4 s.
Lancer : .venv/bin/python source/fin_mt_thunder_v1/build.py
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
OUT = R / 'renders/fin_mt_thunder_v1'
STAGE = R / '.cache/fin_mt_thunder_v1/fin_mt_thunder'
NAMESPACE = 'fin_mt_thunder'
ASSET = 'fmt4_fin_mt_thunder'
PFX = 'FMT4'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
LOT = 'source/fin_mt_thunder_v1'
ENTRY_LOT = 'source/entree_mt_thunder_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the top part of the reference image (Pokemon Mystery '
     'Dungeon Mt. Thunder summit, y < 352): same pale yellow sandy ground with tiny grey pebbles, same LIGHT TAN-BROWN '
     'rocky cliff edges with pale cream-beige highlights (keep the rock cliffs light warm tan-beige RGB(166,141,116) '
     'with cream highlights RGB(216,200,168) exactly like the left and right cliff walls of the reference image — NO '
     'dark chocolate brown shadows), same small pointed tan rock spikes and flat grey-green stones on the sand, same '
     'clean flat scalloped storm clouds in grey-purple tones (darker purple-grey clouds higher up, light grey and white '
     'clouds lower down — NO white lightning wisps or streaks drawn inside the clouds), same dark grey storm sky at the '
     'very top. Make a NEW, larger top-down dungeon boss summit map (closed cul-de-sac at the mountain peak). WIDE '
     'LANDSCAPE 4:3 (1200x896), zoomed out so the summit feels vast. Layout: the player arrives ONLY at the SOUTH '
     '(bottom edge center) on a narrow sandy mountain ridge path rising out of the white storm clouds; the path opens '
     'onto a wide pale-yellow sandy summit plateau edged on the left and right by light tan-beige rocky cliffs, with '
     'several small pointed tan rock spikes, flat grey-green stones and tiny pebbles on the sand; at the NORTH (top '
     'center of the plateau), a light tan-beige stepped rocky summit altar/crag crowns the northern edge (closed '
     'cul-de-sac, no tunnel). Clean scalloped storm clouds fill the left, right and bottom corners; dark storm sky '
     'along the top edge. No lightning, no characters, no text, no UI, no border.',
     'essais': '2e essai retenu (sable 1.7, roche 10.2, ciel 6.6, nuages sombres 5.8, nuages clairs 15.0) ; 1er essai '
               'ecarte dans bruts/ecartes/decor_essai1_roche_trop_sombre.png (roche 68.3 > 35)'},
    {'file': 'sol_complet.png', 'images': [REF_NAME], 'prompt':
     "Fill the ENTIRE image edge to edge with only the pale yellow sandy ground texture from the reference image's "
     'summit plateau: same pale yellow sand colour, same subtle pixel-art speckle texture and faint darker patches, '
     'keep the texture detail. No pebbles, no rocks, no cliffs, no clouds, no dark areas. Wide landscape 4:3.',
     'essais': 'planche partagee avec EMT1 (moyenne (234.1,225.0,157.0), distance 3.7 au sable du rip)'},
]
# ---- Planche du rip (sous la scène) : éclairs d'une seule couleur (240,240,0), arc Flash (240,240,128).
BOLTS = {1: (372, 443, 121, 129), 2: (372, 436, 169, 185), 3: (372, 498, 219, 243), 4: (372, 475, 284, 307)}  # y0,y1,x0,x1
FLASH_BOX = (393, 401, 15, 55)
SWATCH = {'normal': ((420, 55), (420, 72)), 'fading': ((437, 55), (437, 72))}   # (pâle, vif) : centres des pastilles
# ---- Éclairs : (éclair, miroir, x gauche, y haut, décalage de phase) en coordonnées finales.
STRIKES = [(1, False, 48, 60, 0), (3, True, 690, 140, 8), (2, False, 36, 250, 16),
           (4, True, 696, 320, 24), (3, False, 28, 360, 32), (2, True, 712, 50, 40)]
NORMAL_PH, FADING_PH = 2, 2                # phases locales 0-1 : Normal, 2-3 : Fading, 4-47 : rien
DAIS_BOX = (255, 163, 462, 738)            # (y_max_roche, y_top_plateau, x0, x1) de l'estrade nord
DEGRES_BOX = (134, 566, 634)               # (y0, x0, x1) des degrés centraux de l'estrade nord


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sable': (['sol_complet', 'sable', 'esplanade'], 32),
                  'roche': (['cailloux', 'pics', 'falaise', 'piton', 'degres'], 96),
                  'orage': (['ciel', 'nuages'], 32)}
STATIC = ['sable', 'cailloux', 'pics', 'falaise', 'piton', 'degres', 'esplanade', 'ciel', 'nuages']
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
    """Sable jaune pâle, roche brune, et gris de l'orage PAR TON (ciel < 90 <= nuages sombres < 170 <= nuages clairs)."""
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
    sable = r > 195, g > 175, r-b > 45 ; relief = sable + roche brune (r > g >= b, r-b >= 25), fermé 3 px, trous bouchés,
    > 50000 px ; estrade nord = massif en saillie au nord-centre (y <= 255, x 462..738 : roche + calotte y < 163), fermé
    3 px, trous bouchés, > 5000 px, subdivisé en esplanade (terrasse de sable au sommet y < 152, > 1000 px), degres
    (escalier de pierre central x 566..634, y >= 134, > 500 px) et piton (massif rocheux de l'estrade) ; sable du plateau
    = sable hors estrade, fermé/ouvert 2 px, > 20000 px, trous bouchés ; îlots = trous du sable du plateau qui ne sont
    pas du sable, ouverts 1 px, fermés 2 px et bouchés : >= 150 px = pics (et pierres moussues), 12 à 150 px = cailloux ;
    falaise = reste de la roche du relief ; ciel = gris de lum < 90 hors relief, ouvert 3 px, relié au bord haut ;
    nuages = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    sandc = (r > 195) & (g > 175) & (r - b > 45)
    rockc = (r > g) & (g >= b) & (r - b >= 25) & ~sandc
    land = keep_large(nd.binary_fill_holes(close_(sandc | rockc, 3)), 50000)
    ymax_r, ytop_p, dx0, dx1 = DAIS_BOX
    dais_rock = (~sandc) & land & (yy <= ymax_r) & (xx >= dx0) & (xx <= dx1)
    dais = keep_large(nd.binary_fill_holes(close_(dais_rock | (land & (yy < ytop_p) & (xx >= dx0) & (xx <= dx1)), 3)) & land, 5000)
    esplanade = keep_large(open_(close_(sandc & dais & (yy < 152), 2), 1), 1000) & dais
    gy0, gx0, gx1 = DEGRES_BOX
    degres = keep_large(close_(dais & ~esplanade & (xx >= gx0) & (xx <= gx1) & (yy >= gy0), 2), 500) & dais & ~esplanade
    piton = dais & ~esplanade & ~degres
    sand_main = keep_large(open_(close_(sandc & ~dais, 2), 2), 20000)
    sand_main = nd.binary_fill_holes(sand_main) & ~dais
    isl = nd.binary_fill_holes(close_(open_(sand_main & ~sandc, 1), 2)) & sand_main
    il, inn = nd.label(isl); sz = nd.sum(isl, il, range(1, inn + 1))
    pics = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 150])
    cail = np.isin(il, [i + 1 for i, v in enumerate(sz) if 12 <= v < 150])
    sable = sand_main & ~pics & ~cail
    falaise = land & ~sand_main & ~dais
    sky = ~land
    ciel = keep_large(open_(sky & (lum < 90), 3), 2000)
    lab, _ = nd.label(ciel); t = np.unique(lab[0]); ciel = np.isin(lab, t[t > 0])
    nuages = sky & ~ciel
    masks = dict(esplanade=esplanade, degres=degres, piton=piton, pics=pics, cailloux=cail,
                 sable=sable, falaise=falaise, ciel=ciel, nuages=nuages)
    ys_, xs_ = np.nonzero(dais)
    seg = {'estrade_y': [int(ys_.min()), int(ys_.max())], 'estrade_x': [int(xs_.min()), int(xs_.max())],
           'pics': int(sum(v >= 150 for v in sz)), 'cailloux': int(sum(12 <= v < 150 for v in sz)),
           'degres_px': int(degres.sum()), 'esplanade_px': int(esplanade.sum())}
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
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Mt. Thunder V1 (FMT4)')
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
    o.update(Name={'DefaultText': 'Fin Mt. Thunder - sommet de boss/objectif (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur le rip Mt. Thunder (Red Rescue Team, associee a EMT1) ; '
                     'eclairs et lueurs animes (sprites et couleurs Normal / Fading exacts du rip). Sans sortie.')
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
  <Name>Fin Mt. Thunder 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon (sommet d'orage de Mt. Thunder, cul-de-sac de boss et d'objectif) prolongeant l'entree EMT1, plateau de sable au-dessus des nuages, estrade rocheuse a degres au nord, eclairs animes. Pas une aventure jouable.</Description>
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
    order = ['esplanade', 'degres', 'piton', 'pics', 'cailloux', 'sable', 'falaise', 'ciel', 'nuages']
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
    cand = ex['sable'] | ex['cailloux']
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
    blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    # Boss au centre du plateau ; objectif au nord devant les degrés de l'estrade sommitale.
    free2x2 = [(r, c) for r in range(4, gh_ - 4) for c in range(4, gw_ - 4)
               if not blocked[r:r + 2, c:c + 2].any() and walk[r*8:r*8+16, c*8:c*8+16].all()]
    br, bc = min(free2x2, key=lambda rc: (rc[0] - 36) ** 2 + (rc[1] - gw_ // 2) ** 2)
    boss_px = [bc * 8, br * 8]
    dys, dxs = np.nonzero(ex['degres'])
    dc_target = int(round(dxs.mean())) // 8 - 1
    dr_target = int(dys.max()) // 8 + 1
    or_, oc = min((rc for rc in free2x2 if rc[0] >= dr_target),
                  key=lambda rc: (rc[0] - dr_target) ** 2 * 4 + (rc[1] - dc_target) ** 2)
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
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sprites = [sprite(bolts[k], sw[s][1]) for s in ('normal', 'fading') for k in BOLTS] + \
              [sprite(flash, sw[s][0]) for s in ('normal', 'fading')]
    cw, chh = 3 * 42, 3 * 128
    sheet = Image.new('RGBA', (len(sprites) * cw + 8, chh + 16), (112, 104, 112, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr); im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_mt_thunder_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('sable', 'esplanade'), ('roche', 'falaise'), ('roche', 'piton'),
                  ('roche', 'degres'), ('ciel', 'ciel'), ('nuages_sombres', 'nuages'), ('nuages_clairs', 'nuages')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[f'{nm}:{k}'] = {'calque': nm, 'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                                  'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    boxes = strike_boxes(bolts, flash)
    disc_path = RAW / 'ecartes/decor_essai1_roche_trop_sombre.png'
    disc_fid = fidelity(rgb(disc_path), ref)
    manifest = {
        'lot': 'fin_mt_thunder_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'type_carte': 'fin_donjon_cul_de_sac_boss_objectif_sans_sortie',
        'entree_associee': {'lot': ENTRY_LOT, 'prefix': 'EMT1', 'reference_da': REF_NAME},
        'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'fin de Mt. Thunder : plateau sommital de sable au-dessus des nuages d orage et estrade rocheuse a degres au nord (associee a EMT1)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet et sol complet '
                  'generes avec le rip en reference ; eclairs et arc Flash copies de la planche du rip',
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'scene_rows': [0, REF_SCENE_H],
                         'titre': 'Mt. Thunder, salle du boss (Red Rescue Team, GBA) : nom de fichier de la planche'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'bruts_ecartes': [{'file': f'{LOT}/bruts/ecartes/{disc_path.name}', 'sha256': sha(disc_path),
                           'raison': f'roche brune d ombre trop sombre (distance {disc_fid["roche"]["distance"]} > 35)'}],
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
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'sortie': 'aucune (cul-de-sac de fin de donjon)',
                   'path_found_16x16': bool(reach_eb and reach_bo),
                   'path_entry_to_boss_16x16': reach_eb, 'path_boss_to_objectif_16x16': reach_bo,
                   'cells_explored': max(exp_eb, exp_bo),
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (sable et cailloux relies a la crete sud) ; bords nord, ouest et est fermes'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()), 'seg': seg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
