"""Fin Mt. Thunder (FMT2) — zone de fin de donjon : sommet au milieu d'une mer de nuages électriques, 4:3 (768 x 576).

.venv/bin/python source/fin_mt_thunder_v1/build.py

Référence `reference/mt_thunder_gba.png` (salle du sommet de Red Rescue Team, GBA : plateau de sable jaune pâle,
falaises de roche brune, pics, mer de nuages d'orage ; en bas de la planche, 4 éclairs, l'arc « Flash » et les
couleurs « Normal » / « Fading »). Même fichier que l'entrée EMT1, réutilisé pour la fin.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=), comme les lots 4:3
de la série :
- decor.png : arène sommitale ronde au centre, crête d'arrivée au sud, piton à fente sombre au nord, mer de nuages
  électriques tout autour ; premier essai, conforme ;
- sol_complet.png : sable seul, premier essai.
Retouche documentée : deux pastilles noires de génération (42 x 71 px, coins haut gauche/droit) rebouchées dans
le build par miroir des colonnes voisines ; rien d'autre n'est repeint.
Calques : sol complet, sable, cailloux, pics, profondeur (fente du piton), falaise, ciel, nuages, lueurs (anim),
éclairs (anim). Les éclairs et l'arc Flash sont les pixels EXACTS de la planche du rip (couleurs Normal / Fading).
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
REF_NAME = 'mt_thunder_gba.png'
REF = HERE / 'reference' / REF_NAME
LOT = 'fin_mt_thunder_v1'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'fin_mt_thunder'
NAMESPACE = 'fin_mt_thunder'
ASSET = 'fmt2_fin_mt_thunder'
PFX = 'FMT2'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 48, 5
LOOP_TICKS = 240
REF_SCENE_H = 352                        # la scène s'arrête en y = 352 ; en dessous, planche des éclairs sur noir
FIDELITY_MAX = 35
GEN = [
    {'file': 'decor.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Use EXACTLY the same textures, palette and pixel-art style as the top part of the reference image '
     '(Pokemon Mystery Dungeon Mt. Thunder summit): same pale yellow sandy ground with tiny grey pebbles, same brown '
     'rocky cliff edges with cracks, same small pointed tan rock spikes, same scalloped storm clouds in grey-purple '
     'tones (darker purple-grey clouds higher up, light grey and white clouds lower down), same dark grey storm sky. '
     'Make a NEW, larger top-down dungeon-finale map. WIDE LANDSCAPE 4:3, target 1200 by 896 pixels, zoomed out so the '
     'summit feels vast. Layout: the player arrives at the SOUTH (bottom edge center) on a narrow sandy mountain ridge '
     'path rising out of the clouds; the path climbs north and opens onto a HUGE round sandy summit arena in the CENTER, '
     'ringed by brown rocky cliffs, with a few rock spikes and pebbles at its rim; the arena is fully surrounded by a sea '
     'of scalloped electric storm clouds on all sides; at the NORTH (top center) a small rocky crag of the same brown rock '
     'with a dark cleft, the sand leading right up to it. Dark storm sky in the top corners. No lightning bolts, no '
     'characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (distances au rip dans le manifeste)'},
    {'file': 'sol_complet.png', 'images': [f'source/{LOT}/reference/{REF_NAME}'],
     'prompt': 'Fill the ENTIRE image edge to edge, WIDE LANDSCAPE 4:3, target 1200 by 896 pixels, with only the pale '
     'yellow sandy ground texture from the reference image\'s summit plateau: same pale yellow sand colour, same subtle '
     'pixel-art speckle texture and faint darker patches, keep the texture detail. No pebbles, no rocks, no cliffs, no '
     'clouds, no dark areas, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; fond de sable plein'},
]
# ---- Planche du rip (sous la scène) : éclairs d'une seule couleur (240,240,0), arc Flash (240,240,128).
BOLTS = {1: (372, 443, 121, 129), 2: (372, 436, 169, 185), 3: (372, 498, 219, 243), 4: (372, 475, 284, 307)}  # y0,y1,x0,x1
FLASH_BOX = (393, 401, 15, 55)
SWATCH = {'normal': ((420, 55), (420, 72)), 'fading': ((437, 55), (437, 72))}   # (pâle, vif) : centres des pastilles
# ---- Éclairs : (éclair, miroir, x gauche, y haut, décalage de phase) en coordonnées finales 768 x 576, sur les nuages.
STRIKES = [(1, False, 80, 50, 0), (3, True, 648, 30, 8), (2, False, 60, 270, 16),
           (4, True, 662, 250, 24), (3, False, 140, 410, 32), (2, True, 580, 410, 40)]
NORMAL_PH, FADING_PH = 2, 2                # phases locales 0-1 : Normal, 2-3 : Fading, 4-47 : rien


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sable': (['sol_complet', 'sable'], 32), 'roche': (['cailloux', 'pics', 'falaise', 'profondeur'], 96),
                  'orage': (['ciel', 'nuages'], 32)}
STATIC = ['sable', 'cailloux', 'pics', 'profondeur', 'falaise', 'ciel', 'nuages']
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


# ---------------------------------------------------------------- retouche des coins + segmentation pleine résolution
def patch_corners(a):
    """Rebouche les deux pastilles noires de génération (coins hauts, 42 x 71 px) par miroir des colonnes voisines."""
    black = a.sum(-1) < 30
    lab, n = nd.label(black)
    assert n == 2, f'pastilles attendues : 2, trouvées : {n}'
    out = a.copy()
    out[0:71, 0:42] = a[0:71, 84:42:-1][:, :42]
    out[0:71, 1158:1200] = a[0:71, 1115:1157][:, ::-1]
    assert (out.sum(-1) < 30).sum() == 0
    return out


def classify(a):
    """Seuils mesurés sur le brut (1200 x 896) :
    fente = pixels sombres (lum < 70) dans le relief au haut-centre (y < 260, x 450-750), plus grande composante
    (506 px : y 126-175, x 588-611), trous bouchés ; sable = r > 195, g > 175, r-b > 45, fermé/ouvert 2 px,
    > 20000 px, trous bouchés ; relief = sable + roche brune (r > g >= b, r-b >= 25) + fente, fermé 3 px, trous
    bouchés, > 50000 px ; îlots = trous du sable qui ne sont pas du sable, ouverts 1 px, fermés 2 px et bouchés :
    >= 150 px = pics, 12 à 150 px = cailloux ; falaise = roche du relief hors sable et fente (anneau + piton nord) ;
    ciel = gris de lum < 90 hors relief, ouvert 3 px, relié au bord haut ; nuages = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    sandc = (r > 195) & (g > 175) & (r - b > 45)
    rockc = (r > g) & (g >= b) & (r - b >= 25) & ~sandc
    land0 = nd.binary_fill_holes(close_(sandc | rockc, 3))
    dark = (lum < 70) & land0 & (yy < 260) & (xx > 450) & (xx < 750)
    dl, dn = nd.label(dark)
    assert dn >= 1, 'fente du piton introuvable'
    ds = nd.sum(dark, dl, range(1, dn + 1))
    mouth = nd.binary_fill_holes(dl == int(np.argmax(ds)) + 1)
    assert mouth.sum() > 100, mouth.sum()
    sand = keep_large(open_(close_(sandc, 2), 2), 20000); sand = nd.binary_fill_holes(sand) & ~mouth
    land = close_(sand | rockc | mouth, 3)
    land = nd.binary_fill_holes(land)
    land = keep_large(land, 50000)
    isl = open_(sand & ~sandc, 1)
    isl = nd.binary_fill_holes(close_(isl, 2)) & sand
    il, inn = nd.label(isl); sz = nd.sum(isl, il, range(1, inn + 1))
    pics = np.isin(il, [i + 1 for i, v in enumerate(sz) if v >= 150])
    cail = np.isin(il, [i + 1 for i, v in enumerate(sz) if 12 <= v < 150])
    rock = land & ~sand & ~mouth
    sky = ~land
    ciel = keep_large(open_(sky & (lum < 90), 3), 2000)
    lab, _ = nd.label(ciel); t = np.unique(lab[0]); ciel = np.isin(lab, t[t > 0])
    masks = dict(profondeur=mouth, pics=pics, cailloux=cail, sable=sand & ~pics & ~cail, falaise=rock,
                 ciel=ciel, nuages=sky & ~ciel)
    ys_, xs_ = np.nonzero(mouth)
    seg = {'fente_y': [int(ys_.min()), int(ys_.max())], 'fente_x': [int(xs_.min()), int(xs_.max())],
           'pics': int(sum(v >= 150 for v in sz)), 'cailloux': int(sum(12 <= v < 150 for v in sz)),
           'relief_px': int(land.sum())}
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
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Mt. Thunder (FMT2)')
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
    o.update(Name={'DefaultText': 'Fin Mt. Thunder - sommet dans la mer de nuages (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Mt. Thunder (Red Rescue Team, GBA) ; '
                     'eclairs et lueurs animes (sprites et couleurs Normal / Fading exacts du rip). Sommet central, '
                     'arrivee sud sur la crete, objectif devant la fente du piton nord. Marqueurs d edition, sans warp.')
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
  <Name>Fin Mt. Thunder FMT2 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Sommet dans une mer de nuages electriques, arrivee sud sur la crete, arene centrale et piton nord. Projet de carte, sans warp.</Description>
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
    a = patch_corners(rgb(RAW / 'decor.png'))
    f, full = rgb(RAW / 'sol_complet.png'), rgb(REF)
    ref = full[:REF_SCENE_H]
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['profondeur', 'pics', 'cailloux', 'sable', 'falaise', 'ciel', 'nuages']
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
    cand = ex['sable'] | ex['cailloux']
    cl, _ = nd.label(cand)
    ys_south = np.nonzero(cand)[0].max()          # la crête émerge des nuages : elle ne touche pas le bord bas
    seed = cl[ys_south][cand[ys_south]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    bolts, flash, sw = rip_sheet(full)
    for k, bm in bolts.items():
        Image.fromarray(sprite(bm, sw['normal'][1])).save(OUT / 'poses' / f'{PFX}_eclair_{k}.png')
    Image.fromarray(sprite(flash, sw['normal'][0])).save(OUT / 'poses' / f'{PFX}_flash.png')
    lueurs, eclairs = anim_frames(bolts, flash, sw)
    anim = {'lueurs': lueurs, 'eclairs': eclairs}
    top = np.zeros((H, W, 4), 'uint8')
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks,
                               'name': f'{i:02d}_{nm}', 'order': i})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60,
                               'name': f'{i:02d}_{nm}', 'order': i})
        stack_named.append((nm, frames, ticks))
    Image.fromarray(top).save(OUT / 'calques' / f'{PFX}_{len(order_names):02d}_top.png')
    layer_list.append({'file': f'calques/{PFX}_{len(order_names):02d}_top.png', 'phases': 1, 'ticks': 60,
                       'name': f'{len(order_names):02d}_top', 'order': len(order_names)})
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape

    def free_near(x, y):
        for dy in range(0, 40):
            for dx in sorted(range(-16, 17), key=abs):
                for sy in (1, -1):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if footprint_free(blocked, gy, gx):
                        return [gx * 8, gy * 8]
    sy_south, sx_south = np.nonzero(walk)
    entry_px = free_near(int(sx_south[sy_south.argmax()]), int(sy_south.max()))
    arena = walk & (np.mgrid[:H, :W][0] < H - 150)
    fy, fx = np.nonzero(arena)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    dys, dxs = np.nonzero(mouth)
    objectif = free_near(int(round(dxs.mean())) - 8, int(dys.max()) + 16)
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
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
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
    # Planche : les 4 éclairs et l'arc, en Normal puis en Fading, x3, sur le gris des nuages sombres.
    sprites = [sprite(bolts[k], sw[s][1]) for s in ('normal', 'fading') for k in BOLTS] + \
              [sprite(flash, sw[s][0]) for s in ('normal', 'fading')]
    cw, chh = 3 * 42, 3 * 128
    sheet = Image.new('RGBA', (len(sprites) * cw + 8, chh + 16), (112, 104, 112, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr); im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    ora_layers = {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)}
    ora_layers[f'{len(stack_named):02d}_top'] = top
    write_ora(OUT / f'{PFX}_fin_mt_thunder_calques.ora', ora_layers)
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    fid = fidelity(a, ref)
    assert all(v['distance'] < FIDELITY_MAX for v in fid.values()), fid
    boxes = strike_boxes(bolts, flash)
    strike_cover = []
    for (m, x, y, fx, fy, off), (k, mirror, _, _, _) in zip(boxes, STRIKES):
        hh, ww = m.shape
        x0, y0 = max(0, x), max(0, y); x1, y1 = min(W, x + ww), min(H, y + hh)
        zone = walk[y0:y1, x0:x1]
        mm = m[y0 - y:y1 - y, x0 - x:x1 - x]
        strike_cover.append({'eclair': k, 'miroir': mirror, 'sur_sable': round(float((zone & mm).sum() / mm.sum()), 3)})
    manifest = {
        'lot': LOT, 'title': 'Fin Mt. Thunder — sommet dans la mer de nuages', 'prefix': PFX, 'namespace': NAMESPACE,
        'asset': ASSET, 'type': 'fin de donjon / arène naturelle', 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_px': 8, 'grid_cells': [W // 8, H // 8],
        'user_request': "layout de fin logique : sommet au milieu d'une mer de nuages électrique (Mt. Thunder)",
        'agent_choices': {
            'reference': 'même planche GBA que EMT1 (salle du sommet Red Rescue Team), aucun visuel de salle finale Sky ; matière + éclairs exacts',
            'layout': 'arrivée sud sur la pointe de la crête (qui émerge des nuages sans toucher le bord), grande arène sommitale centrale, piton à fente sombre au nord',
            'prefix': 'FMT2, car FMT1 est un repère posé sur la branche sœur 01a0eaca (non fusionnée) ; même logique que FCV2 face à FCV1',
            'biome': 'sommet orageux Mt. Thunder, continuité avec EMT1 ; intitulé de travail'},
        'generation': GEN,
        'inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size_px': list(SRC),
                    'role': 'composition FMT2 générée avec le rip en référence'},
                   {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size_px': list(SRC),
                    'role': 'sable seul, base d édition sous la composition opaque'},
                   {'file': f'source/{LOT}/reference/{REF_NAME}', 'sha256': sha(REF),
                    'size_px': list(Image.open(REF).size), 'role': 'planche GBA Mt. Thunder : matière + éclairs/arc exacts'}],
        'retouche_coins': 'deux pastilles noires 42x71 aux coins hauts, rebouchées par miroir des colonnes voisines (patch_corners) ; rien d autre n est repeint',
        'normalization': {'methode': 'moyenne pondérée par classe (BOX), facteur uniforme 0.642857 identique en X et Y, recadrage 1 px de chaque côté ; palettes par groupes (sable 32, roche 96, orage 32), sans tramage',
                          'scale': JM.SCALE, 'crop_x': JM.CROP_X},
        'segmentation': seg,
        'fidelite': {**fid, 'seuil': FIDELITY_MAX},
        'layers': layer_list,
        'eclairs': {'phases': PHASES, 'frame_length_ticks': TICKS, 'normales': NORMAL_PH, 'fading': FADING_PH,
                    'boites_rip': {str(k): list(v) for k, v in BOLTS.items()}, 'arc_flash': list(FLASH_BOX),
                    'couleurs': {k: [list(c) for c in v] for k, v in sw.items()},
                    'frappes': [{'eclair': k, 'miroir': mo, 'x': x, 'y': y, 'decalage': off}
                                for k, mo, x, y, off in STRIKES],
                    'part_sol': strike_cover,
                    'origine': 'pixels EXACTS de la planche du rip ; placement et cadence créés (pas l animation officielle)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss, 'objective_px': objectif,
                   'entry_cell_yx': [entry_px[1] // 8, entry_px[0] // 8],
                   'boss_cell_yx': [boss[1] // 8, boss[0] // 8],
                   'objective_cell_yx': [objectif[1] // 8, objectif[0] // 8],
                   'path_to_boss_16x16': True, 'path_to_objective_16x16': True, 'chemins_16x16': paths,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si > 25 % hors sable et cailloux (cell_grid) ; empreinte joueur 16x16 px',
                   'exit_and_warp': 'aucun'},
        'pmdo': {'target': '0.8.12.0', 'version': '0.8.12.0', 'tile_banks': counts, 'runtime_tested': False,
                 'markers': ['entrance', 'boss', 'objectif'], 'warp': 'aucun', 'exit': 'aucune'},
        'art_approved': False, 'runtime_tested': False,
        'notes': ['Composition générée référencée, pas de tuiles natives certifiées ; seuls éclairs, arc et couleurs Normal/Fading sont des pixels exacts du rip.',
                  'Les tests vérifient les artefacts locaux et l accessibilité géométrique 16x16 ; le runtime PMDO n a pas été lancé.'],
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items()}, 'markers': markers,
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
