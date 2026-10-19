"""Entrée Old Castle / Chambre Dorée sud -> nord V1 (EOC2) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « tous » (suite de la série : Old Castle `oldcastlepmd.png`, entrée + fin de donjon).
Référence `oldcastlepmd.png` (408 x 408) : Chambre Dorée / Old Castle (Pokémon Donjon Mystère : Explorateurs du Ciel),
dalles de brique dorées avec gradient lumineux crème-or vers le nord, rosace circulaire sculptée au centre,
balustrades à volutes dorées, colonnes à sphère d'or et coffres au trésor verts et argentés.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), allée sud encadrée par deux balustrades à volutes et quatre colonnes à
  sphère d'or, vaste salle aux dalles dorées avec rosace centrale sculptée, deux ailes courbes de coffres verts et
  argentés sur les côtés, et arche dorée au nord encadrée de deux colonnes dans la lueur crème-or ;
- sol_complet.png : dalles dorées et rosace centrale sans coffres, sans colonnes, sans balustrades ni arche (recalé
  (0, 0)).
Calques : sol complet, dalles claires, dalles dorées, rosace centrale, dalles sombres, murs de bordure, colonnes et
balustrades, arche du seuil, coffres.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- lueur_portail : halo lumineux crème-or respirant dans et autour de l'arche nord (couleurs EXACTES du rip) ;
- eclats_or : scintillements dorés sur les coffres et les sphères d'or des colonnes (couleurs EXACTES du rip).
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_old_castle_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'oldcastlepmd.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_old_castle_sud_nord_v1'
STAGE = R / '.cache/entree_old_castle_sud_nord_v1/entree_old_castle_sud_nord'
NAMESPACE = 'entree_old_castle_sud_nord'
ASSET = 'eoc2_entree_old_castle'
PFX = 'EOC2'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_old_castle_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon '
     'Explorers of Sky, Old Castle / Golden Chamber): same golden-beige brick flagstones (#B4A468) with darker aged '
     'bronze-gold bricks at the bottom (#8A7846) and bright radiant cream-gold bricks at the top (#EFEFBF), same '
     'ornate carved circular sandstone rosette medallion in the center of the floor, same ornate scrolled golden '
     'balustrades and golden orb-topped pillars with soft drop shadows, same green-and-silver treasure chests with '
     'gold trim. Make a NEW, larger top-down dungeon entrance map. WIDE LANDSCAPE 4:3 (1200x896), zoomed out so the '
     'hall feels vast. Layout: the player arrives at the SOUTH (bottom edge center) on a wide golden-brick walkway '
     'flanked by two ornate scrolled golden balustrades and four golden orb-topped pillars (two on the left, two on '
     'the right); the walkway opens into a grand golden-brick hall with a large ornate carved circular rosette '
     'medallion in the center; on the LEFT and RIGHT flanks of the central medallion (away from the central '
     'south-to-north path), two neat curved wings of green-and-silver treasure chests rest on the flagstones, leaving '
     'the central south-to-north path completely open and clear of chests; at the NORTH top center, the walkway '
     'reaches a grand ornate golden-stone archway / portal framed by two more golden orb pillars, bathed in a bright '
     'cream-gold light gradient at the top edge. No characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme (dalles_claires 3.2, dalles 4.2, bronze 9.5, coffres 8.2)'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Same image, same framing and pixel-art style (1200x896), but remove all 18 green-and-silver treasure chests, '
     'all 6 golden orb-topped pillars, both scrolled golden balustrades at the bottom, the golden archway at the top, '
     'and their drop shadows, replacing them seamlessly with the surrounding golden-beige brick flagstones; keep the '
     'golden-beige brick flagstone floor (from darker bronze bricks at the bottom to bright cream-gold bricks at the '
     'top) and the central circular carved rosette medallion at the exact same pixel positions. No characters, no '
     'text, no UI, no border.',
     'essais': 'premier essai ; recalage (0, 0) ecart 3.24'},
]

# Couleurs EXACTES du rip oldcastlepmd.png pour la lueur du portail et les éclats d'or :
LUEUR_RAMP = [
    (239, 239, 183),
    (239, 239, 199),
    (247, 247, 199),
    (247, 247, 215),
    (247, 247, 223),
    (255, 255, 239),
    (255, 255, 255),
]
ECLAT_RAMP = [
    (239, 231, 159),
    (239, 231, 167),
    (247, 247, 207),
    (255, 255, 239),
    (255, 255, 255),
]

PALETTE_GROUPS = {
    'dalles_claires': (['sol_complet', 'dalles_claires'], 64),
    'dalles_rosace': (['dalles', 'rosace'], 96),
    'bronze_murs': (['dalles_sombres', 'murs_bordure'], 96),
    'or_sculpte': (['colonnes_balustrades', 'arche_seuil'], 96),
    'coffres': (['coffres'], 64),
}
STATIC = ['dalles_claires', 'dalles', 'rosace', 'dalles_sombres', 'murs_bordure', 'colonnes_balustrades', 'arche_seuil', 'coffres']
ANIMS = ['lueur_portail', 'eclats_or']


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM = V1.JM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def materials(a):
    """Même classifieur pixel sur le rip oldcastlepmd.png et sur le décor généré :
    dalles_claires (halo crème-or nord), dalles (briques dorées et rosace), bronze (colonnes, balustrades et briques
    sombres sud), coffres (vert et métal argenté)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    sat = np.maximum(np.maximum(r, g), b) - np.minimum(np.minimum(r, g), b)
    mag = (r - g > 60) & (b - g > 60)
    coffres = ((g > r + 10) | ((sat < 22) & (lum > 35) & (lum < 210))) & ~mag
    dalles_claires = (lum >= 210) & (r >= g - 3) & (r - b > 25) & ~coffres & ~mag
    dalles = (lum >= 145) & (lum < 210) & (r >= g - 5) & (r - b > 35) & ~coffres & ~mag
    bronze = (lum >= 65) & (lum < 145) & (r >= g - 5) & (r - b > 25) & ~coffres & ~mag
    return {'dalles_claires': dalles_claires, 'dalles': dalles, 'bronze': bronze, 'coffres': coffres}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def recalage(a, o, zone):
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(o, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen': round(err[(0, 0)], 2), 'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def classify(a, f):
    """Segmentation pleine résolution (1200 x 896) à partir de decor.png (a) et sol_complet.png (f) :
    - coffres : 20 coffres verts et argentés dans les deux ailes latérales (écart décor/sol > 14 autour des graines
      vert/argent) ;
    - arche_seuil : montants et linteau sculptés de la grande arche dorée au nord-centre (hors l'ouverture centrale
      du portail, praticable pour donjon_seuil) ;
    - colonnes_balustrades : les 6 colonnes à sphère d'or et les 2 balustrades à volutes du couloir sud ;
    - murs_bordure : enceinte de pierre dorée fermant le bord nord (y < 130 hors l'ouverture du portail et y < 56
      derrière l'arche), les bords ouest/est (x < 68 ou x >= 1132) et les terrasses sud (y >= 736 hors le couloir
      central d'arrivée 525 <= x <= 675) ;
    - rosace : médaillon circulaire sculpté au centre de la salle ((x - 600)^2 + (y - 442)^2 <= 135^2) ;
    - dalles_claires : dalles crème-or baignées de lumière au nord (lum >= 205) ;
    - dalles_sombres : dalles bronze doré patinées au sud (lum < 150) ;
    - dalles : dalles de brique dorées principales de la salle."""
    af = a.astype(int); ff = f.astype(int)
    r, g, b = af.transpose(2, 0, 1); lum = lum_of(af); sat = af.max(2) - af.min(2)
    diff = np.abs(af - ff).max(2)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]

    # 1. Coffres (20 coffres latéraux)
    chest_seed = ((g > r + 8) | ((sat < 24) & (lum < 210))) & (diff > 18) & (yy > 240) & (yy < 640) & ((xx < 300) | (xx > 900))
    cl, _ = nd.label(nd.binary_closing(nd.binary_dilation(chest_seed, iterations=4) & (diff > 14), iterations=2))
    coffres = np.zeros_like(chest_seed)
    chest_boxes = []
    for i, sl in enumerate(nd.find_objects(cl), 1):
        if (cl == i).sum() >= 300:
            coffres[sl] = True
            chest_boxes.append([int(sl[0].start), int(sl[0].stop), int(sl[1].start), int(sl[1].stop)])

    # 2. Arche nord, colonnes à sphère d'or et balustrades à volutes
    obj_diff = (diff > 22) & ~coffres
    ol, _ = nd.label(nd.binary_closing(obj_diff, iterations=2))
    objs = np.zeros_like(obj_diff)
    for i, sl in enumerate(nd.find_objects(ol), 1):
        comp = (ol == i)
        if comp.sum() >= 600:
            objs |= comp
    arche_zone = (yy < 220) & (xx > 470) & (xx < 730) & ~((xx < 505) & (yy > 95)) & ~((xx > 695) & (yy > 95))
    door_open = (xx >= 554) & (xx <= 646) & (yy >= 84) & (yy <= 225)
    arche_seuil = (objs & arche_zone) & ~door_open
    colonnes_balustrades = (objs & ~arche_zone) & ~coffres

    # 3. Murs de bordure (fermeture N, S, O, E hors arrivée sud et portail nord)
    bord_nord = (yy < 56) | ((yy < 130) & ~door_open)
    bord_cotes = (xx < 68) | (xx >= 1132)
    bord_sud = (yy >= 736) & ~((xx >= 525) & (xx <= 675))
    murs_bordure = (bord_nord | bord_cotes | bord_sud) & ~coffres & ~arche_seuil & ~colonnes_balustrades

    # 4. Sol praticable : rosace centrale, dalles claires, dalles sombres, dalles principales
    rem = ~(coffres | arche_seuil | colonnes_balustrades | murs_bordure)
    rosace = rem & (((xx - 600) ** 2 + (yy - 442) ** 2) <= 135 ** 2)
    rem &= ~rosace
    dalles_claires = rem & ((lum >= 205) | door_open)
    rem &= ~dalles_claires
    dalles_sombres = rem & (lum < 150)
    dalles = rem & ~dalles_sombres

    m = {
        'coffres': coffres,
        'arche_seuil': arche_seuil,
        'colonnes_balustrades': colonnes_balustrades,
        'murs_bordure': murs_bordure,
        'rosace': rosace,
        'dalles_claires': dalles_claires,
        'dalles_sombres': dalles_sombres,
        'dalles': dalles,
    }
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in m.items()}
    seg['nb_coffres'] = len(chest_boxes)
    return m, seg


def lueur_frames(arche_mask, ts=range(PHASES)):
    """Halo lumineux crème-or respirant dans et autour de l'ouverture de l'arche nord (24 x 5 ticks).
    Couleurs EXACTES du rip oldcastlepmd.png (LUEUR_RAMP)."""
    yy, xx = np.mgrid[:H, :W]
    cx, cy = 384.0, 92.0
    dist = np.hypot((xx - cx) / 1.15, (yy - cy) / 0.95)
    zone = (dist <= 62.0) & (yy >= 28) & (yy <= 160) & ~arche_mask
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        wave = 0.5 + 0.5 * np.sin(2 * np.pi * (t % PHASES) / PHASES - dist / 14.0)
        # Anneaux concentriques respirants + rayons doux sur la grille 2x2 :
        r_max = 36.0 + 18.0 * (0.5 + 0.5 * np.sin(2 * np.pi * (t % PHASES) / PHASES))
        checker = ((xx // 2 + yy // 2 + (t % PHASES) // 3) % 2 == 0)
        active = zone & ((dist <= r_max * 0.68) | ((dist <= r_max) & checker))
        idx = np.clip(((1.0 - dist / 62.0) * 0.65 + wave * 0.35) * (len(LUEUR_RAMP) - 1), 0, len(LUEUR_RAMP) - 1).round().astype(int)
        for ci, col in enumerate(LUEUR_RAMP):
            sel = active & (idx == ci)
            fr[sel, :3] = col
            fr[sel, 3] = 255
        frames.append(fr)
    return frames


def sparkle_spots(coffres_mask, colonnes_mask):
    """Positions déterministes des éclats d'or sur les coffres et les sphères d'or des colonnes."""
    spots = []
    cl, n = nd.label(coffres_mask)
    for idx, i in enumerate(range(1, n + 1)):
        ys, xs = np.nonzero(cl == i)
        if len(ys) < 20:
            continue
        cy = int(np.percentile(ys, 35))
        cx = int(np.median(xs))
        spots.append((cx, cy, (idx * 5) % PHASES))
    # Sphères d'or au sommet des 6 colonnes :
    for idx, (cx, cy) in enumerate([(143, 462), (249, 466), (519, 466), (625, 462), (288, 92), (480, 92)]):
        spots.append((cx, cy, (idx * 4 + 2) % PHASES))
    return spots


def eclats_frames(spots, ts=range(PHASES)):
    """Scintillements dorés en étoile (24 x 5 ticks) utilisant uniquement les couleurs exactes du rip (ECLAT_RAMP)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for cx, cy, p0 in spots:
            dt = (tm - p0) % PHASES
            if dt >= 10:
                continue
            # Cycle d'ouverture/fermeture de l'éclat sur 10 phases :
            stage = dt if dt <= 5 else 10 - dt
            c_center = ECLAT_RAMP[min(stage, len(ECLAT_RAMP) - 1)]
            c_arm = ECLAT_RAMP[max(0, min(stage - 1, len(ECLAT_RAMP) - 2))]
            if 0 <= cy < H and 0 <= cx < W:
                fr[cy, cx] = (*c_center, 255)
            if stage >= 2:
                for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < H and 0 <= nx < W:
                        fr[ny, nx] = (*c_arm, 255)
            if stage >= 4:
                for dy, dx in ((-2, 0), (2, 0), (0, -2), (0, 2)):
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < H and 0 <= nx < W:
                        fr[ny, nx] = (*ECLAT_RAMP[1], 255)
                for dy, dx in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < H and 0 <= nx < W:
                        fr[ny, nx] = (*ECLAT_RAMP[0], 255)
        frames.append(fr)
    return frames


def write_ora(path, layers):
    root = ET.Element('image', w=str(W), h=str(H), version='0.0.5')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
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
    o.update(Name={'DefaultText': 'Entree Old Castle (Chambre Doree) - sud vers nord (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Old Castle (oldcastlepmd.png) ; lueur du '
                     'portail et eclats d or animes (couleurs exactes du rip). Collisions de base a verifier. Seuil '
                     'non raccorde.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
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
  <Name>Entree Old Castle (Chambre Doree) sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee au sud entre les balustrades et colonnes d'or, salle aux dalles dorees, rosace centrale et ailes de coffres, arche du seuil au nord (ref. oldcastlepmd.png). Pas une aventure jouable.</Description>
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


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, f)
    reg = {'sol_complet': recalage(a, f, nd.binary_erosion(m['dalles'] | m['rosace'], iterations=6))}

    order = ['coffres', 'arche_seuil', 'colonnes_balustrades', 'murs_bordure', 'rosace', 'dalles_claires', 'dalles_sombres', 'dalles']
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

    # Praticable : dalles_claires, dalles, rosace, dalles_sombres reliées à l'arrivée sud
    cand = ex['dalles_claires'] | ex['dalles'] | ex['rosace'] | ex['dalles_sombres']
    cl, _ = nd.label(cand)
    seed = cl[H - 1, np.nonzero(cand[H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    lueur = lueur_frames(ex['arche_seuil'] | ex['colonnes_balustrades'])
    spots = sparkle_spots(ex['coffres'], ex['colonnes_balustrades'])
    eclats = eclats_frames(spots)
    anim = {'lueur_portail': lueur, 'eclats_or': eclats}

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

    blocked = cell_grid(~walk)
    # Garantie de fermeture stricte N, O, E et S hors l'allée d'arrivée :
    blocked[0, :] = True
    blocked[:, 0] = True
    blocked[:, -1] = True
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    # Seuil au pied de l'ouverture de l'arche nord :
    threshold_px = [376, 80]
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

    write_ora(OUT / f'{PFX}_entree_old_castle_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('dalles_claires', 'dalles_claires'), ('dalles', 'dalles'), ('bronze', 'dalles_sombres'), ('coffres', 'coffres')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'entree_old_castle_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Old Castle / Chambre Doree (Explorateurs du Ciel), arrivee sud entre balustrades et colonnes d or, arche nord',
        'method': 'textures canoniques = rendu genere REFERENCE : rip oldcastlepmd.png passe au generateur ; decor complet '
                  'et sol complet sans objets edites et recales (0, 0)',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Old Castle / Chambre Doree (Pokemon Donjon Mystere : Explorateurs du Ciel, oldcastlepmd.png)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': False} for g in GEN],
        'recalage': {**reg, 'zones': 'sol complet : dalles et rosace centrale erodees de 6 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'lueur_portail': {'phases': PHASES, 'frame_length_ticks': TICKS, 'palette': [list(c) for c in LUEUR_RAMP],
                          'origine': 'halo respirant cree par nous avec uniquement des couleurs exactes du rip oldcastlepmd.png'},
        'eclats_or': {'phases': PHASES, 'frame_length_ticks': TICKS, 'palette': [list(c) for c in ECLAT_RAMP],
                      'spots': [list(s) for s in spots],
                      'origine': 'scintillements crees par nous sur les coffres et spheres d or avec uniquement des couleurs exactes du rip'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (dalles_claires, dalles, rosace, dalles_sombres)',
                   'seuil': 'case 2 x 2 libre dans l ouverture de l arche dorée au nord'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
