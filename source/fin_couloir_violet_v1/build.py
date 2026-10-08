"""Fin Couloir violet (FVL1) — zone de fin de donjon, format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « bon travail continuons » (8 octobre 2026, après FCT1). Jumeau de l'entrée ECV1.
Référence `large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png`. Préfixe FVL1 (FCV1 pris sur une sœur).
Biome et portée choisis par l'agent, à confirmer. Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ.
- decor.png : arène fermée, couloir sud, alcôve de rochers au nord (pas de tunnel sombre) ;
- sol_complet.png : sol mauve plein, généré d'après le rip ;
- poussiere_poses.png : planche ECV1 copiée (même sha256).
Calques : sol complet, sol, ombres, gravillons, blocs, rochers, vide.
Animations : éboulis (gravillons EXACTS du rip) et poussière ECV1, 24 x 5 ticks. Scène 120 ticks.
Marqueurs : entrance (sud), boss (centre), objectif (pied de l'alcôve nord). Aucun warp.
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
ASSET = 'fvl1_fin_couloir_violet'
PFX = 'FVL1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_couloir_violet_v1'
ECV1_PUFF = 'source/entree_couloir_violet_sud_nord_v1/bruts/poussiere_poses.png'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon purple '
     'rocky corridor): same mottled mauve-purple cave floor, same stacked rounded blue-violet boulders with light lilac '
     'highlights forming the walls, same dark navy background, same small dark round pebbles. Make a NEW, larger top-down '
     'map. WIDE LANDSCAPE 4:3, zoomed out. Layout: SOUTH a narrow floor corridor between boulder walls at the bottom edge '
     'center, opening into a LARGE round cave chamber (boss arena) with a few boulder clusters on the floor left and right; '
     'NORTH an alcove of stacked boulders, mauve floor to its foot, NO dark hole, NO tunnel. Boulder walls fill all edges. '
     'No characters, no text, no UI, no border, no magenta.',
     'essais': 'premier essai 1200 x 896 ; fidélité sol 2,7 roche 11,9 (seuil 35)'},
    {'file': 'sol_complet.png', 'images': [REF_NAME], 'prompt':
     'Fill the ENTIRE image edge to edge with only the mottled mauve-purple cave floor texture from the reference image: '
     'same pixel-art mottled pattern, same palette and contrast, keep the texture detail. No boulders, no rocks, no '
     'pebbles, no walls, no dark areas. Wide landscape 4:3.',
     'essais': 'premier essai ; distance 3,5 au sol du rip'},
    {'file': 'poussiere_poses.png', 'images': [REF_NAME], 'prompt':
     'REUTILISEE sans nouvelle generation : planche de l\'entree ECV1 (source/entree_couloir_violet_sud_nord_v1/bruts/'
     'poussiere_poses.png, meme sha256), fenetres inchangees. Prompt d\'origine : Pixel-art sprite sheet on magenta, '
     'dust puff clouds, mauve-purple and lilac greys from the reference.',
     'essais': 'copie de la planche ECV1 : aucune generation supplementaire'},
]
PEBBLES = {'petit': (113, 136, 6, 7), 'moyen': (131, 78, 7, 10), 'gros': (130, 204, 12, 12)}
PUFF_WIN = [(340, 410, 120), (335, 645, 200), (335, 890, 220), (335, 1130, 220)]
PUFF_K, PUFF_COV, PUFF_COLORS = 8, 0.35, 6
DROPS = [(180, 200, 'moyen', 0, 1), (580, 200, 'gros', 6, -1), (220, 360, 'petit', 12, 1), (540, 350, 'moyen', 18, -1)]
FALL = [-21, -16, -9, 0]
BOUNCE = {4: -3, 5: -1}
ROLL = [0, 0, 0, 0, 1, 2, 3, 4]
VISIBLE = 20
PUFF_AT = {3: 0, 4: 1, 5: 2, 6: 3}


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'sol': (['sol_complet', 'sol', 'ombres'], 64), 'roche': (['gravillons', 'blocs', 'rochers'], 96),
                  'sombre': (['vide'], 16)}
STATIC = ['sol', 'ombres', 'gravillons', 'blocs', 'rochers', 'vide']
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


def materials(a):
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    return {'sol': ((r - g) >= 6) & (lum > 55), 'roche': ((r - g) < 6) & (b - r > 20) & (lum > 45)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def classify(a):
    """Seuils mesurés sur le brut (1200 x 896), fin sans bouche sombre :
    sol = r-g lissé 5 px >= 6 et lum lissée > 45, fermé/ouvert 2 px, plus grande composante (> 20000 px), trous bouchés ;
    îlots = trous du sol : blocs >= 600 px, gravillons 12 à 600 px ; ombres = sol à lum lissée < 62 à <= 30 px d'une paroi ;
    vide = lum lissée < 24 hors sol, ouvert 4 px, > 3000 px, relié au bord ; rochers = le reste. Pas de falaise striée
    (0 px sur ce brut), pas de profondeur."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
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
    db = nd.distance_transform_edt(~(wall | blocs | grav))
    omb = sol & (L < 62) & (db <= 30)
    omb = open_(close_(omb, 2), 1) & sol
    vide = keep_large(open_((L < 24) & wall, 4), 3000)
    lab, _ = nd.label(vide); edge = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])
    vide = np.isin(lab, edge[edge > 0])
    roc = wall & ~vide
    masks = dict(gravillons=grav, blocs=blocs, ombres=omb & ~grav & ~blocs, sol=sol & ~omb, vide=vide, rochers=roc)
    seg = {'blocs': int(sum(v >= 600 for v in sz)), 'gravillons': int(sum(12 <= v < 600 for v in sz)),
           'ombres_lum': round(float(lum[masks['ombres']].mean()), 1), 'sol_lum': round(float(lum[masks['sol']].mean()), 1)}
    return masks, seg


def rip_pebbles(ref):
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
        m = nd.binary_fill_holes(nd.binary_closing(m, iterations=2)) & ~bg[sl]
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


def landing_spots(ground, wall):
    ok = nd.minimum_filter(ground.astype(np.uint8), size=(3, 13), origin=(-1, 0)) > 0
    ok &= np.roll(wall, 8, 0) & np.roll(wall, 20, 0)
    ok[:24] = False; ok[:, :8] = False; ok[:, -8:] = False; ok[-4:] = False
    ys, xs = np.nonzero(ok); spots = []
    for tx, ty, name, off, sens in DROPS:
        i = int(((xs - tx) ** 2 + (ys - ty) ** 2).argmin())
        spots.append((int(xs[i]), int(ys[i]), name, off, sens))
    return spots


def pebble_state(u, sens):
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


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Couloir violet V1 (FVL1)')
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


def ground_project(stack, blocked, entry_px, boss_px, objective_px, gfx, tools):
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
    o.update(Name={'DefaultText': 'Fin Couloir violet - arene (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Couloir rocheux violet ; eboulis (gravillons '
                     'exacts du rip) et poussiere ECV1. Aucune sortie ni warp. Biome et portee choisis par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objective_px)]}]
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
  <Name>Fin Couloir violet 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : zone de fin de donjon dans une salle rocheuse violette, generee au format 4:3 (ref. rip Couloir rocheux violet), eboulis et poussiere animes. Pas une aventure jouable.</Description>
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
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)
    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    assert sha(RAW / 'poussiere_poses.png') == sha(R / ECV1_PUFF)
    m, seg = classify(a)
    order = ['gravillons', 'blocs', 'ombres', 'sol', 'vide', 'rochers']
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
    spots = landing_spots(ex['sol'] | ex['ombres'], ex['rochers'] | ex['blocs'])
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
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    free = lambda cx, cy: 0 <= cx < gw_ - 1 and 0 <= cy < gh_ - 1 and not blocked[cy:cy + 2, cx:cx + 2].any()
    wy, wx = np.nonzero(walk); tgt = (int(wx.mean()) // 8, int(wy.mean()) // 8)
    boss_c = min(((cx, cy) for cy in range(gh_) for cx in range(gw_) if free(cx, cy)),
                 key=lambda c: (c[0] - tgt[0]) ** 2 + (c[1] - tgt[1]) ** 2)
    boss_px = [boss_c[0] * 8, boss_c[1] * 8]
    mid = W // 16
    cands = [(cx, cy) for cy in range(gh_) for cx in range(mid - 10, mid + 10) if free(cx, cy)]
    top = min(cy for _, cy in cands)
    obj_c = min((c for c in cands if c[1] <= top + 2), key=lambda c: abs(c[0] - mid))
    objective_px = [obj_c[0] * 8, obj_c[1] * 8]
    reach_boss, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_c[1], boss_c[0]))
    reach_obj, _ = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (obj_c[1], obj_c[0]))
    assert reach_boss and reach_obj, 'pas de chemin 16x16'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 60, 220, 255)), (objective_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sprites = [pebbles[k] for k in PEBBLES] + puffs; cw = 26 * 6 + 8
    sheet = Image.new('RGBA', (len(sprites) * cw + 8, cw + 8), (94, 80, 114, 255))
    for i, spr in enumerate(sprites):
        im = Image.fromarray(spr); im = im.resize((im.width * 6, im.height * 6), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_couloir_violet_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objective_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sol', 'sol'), ('roche', 'rochers'), ('roche', 'blocs')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    manifest = {
        'lot': 'fin_couloir_violet_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin de donjon',
        'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (EWC1 pour les utilitaires, ECV1 pour la planche de poussiere) ; aucun emprunt aux branches soeurs',
        'biome': 'fin du couloir rocheux violet (biome de ECV1), biome et portee choisis par l agent (« bon travail continuons »), a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet sans tunnel, '
                  'sol complet genere au rip, planche poussiere ECV1 reutilisee',
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
        'layers': layer_list,
        'eboulis': {'gravillons_rip': {k: list(v) for k, v in PEBBLES.items()},
                    'gravillons_source': 'rip, composante de roche 8-connexe entierement entouree de sol ; pixels et couleurs EXACTS',
                    'chutes': [list(s) for s in spots], 'cibles': [list(d) for d in DROPS], 'chute_dy': FALL,
                    'rebond_dy': {str(k): v for k, v in BOUNCE.items()}, 'roulement_px': ROLL, 'visible_phases': VISIBLE,
                    'phases': PHASES, 'frame_length_ticks': TICKS,
                    'origine': 'dessin EXACT du rip ; chute, rebond, roulement et placement crees par nous'},
        'poussiere': {'fenetres': [list(w) for w in PUFF_WIN], 'planche': ECV1_PUFF,
                      'phases': PHASES, 'frame_length_ticks': TICKS,
                      'origine': 'dessin GENERE de ECV1 ; placement et cadence crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objective_px': objective_px, 'path_found_16x16': True,
                   'path_to_boss': bool(reach_boss), 'path_to_objective': bool(reach_obj), 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (sol, ombres, gravillons relies au sud)',
                   'fin': 'aucune sortie, aucun warp, pas de donjon_seuil'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objective_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'spots': spots,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
