"""Fin Clairière tropicale (FCT1) — zone de fin de donjon, format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « Vasy genere la prochaine map » (8 octobre 2026, après ouverture de la méthode FCT1).
Jumeau de l'entrée ETC1. Référence `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png`.
Biome et portée choisis par l'agent, à confirmer. Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ.
- decor.png : arène fermée (jungle sur les 4 bords), sentier de dalles au sud, tertre de fleurs + palmier au nord ;
  pas de mer, pas de ponton, pas de bouche sombre ;
- sol_complet.png : herbe seule, éditée depuis le décor, recalé (0, 0) ;
- temoin_sans_objets.png : décor sans palmiers, fleurs, touffes ni cailloux ;
- papillons_poses.png : planche ETC1 copiée (même sha256).
Calques : sol complet, herbe, ombres, dalles, touffes, fleurs, jungle, palmiers.
Animations : papillons (planche ETC1, vols en huit, 24 x 5 ticks). Scène : 120 ticks = 2 s.
Marqueurs : entrance (sud), boss (centre), objectif (pied du tertre nord). Aucun warp, pas de donjon_seuil.
Lancer : .venv/bin/python source/fin_clairiere_tropicale_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_clairiere_tropicale_v1'
STAGE = R / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
NAMESPACE = 'fin_clairiere_tropicale'
ASSET = 'fct1_fin_clairiere_tropicale'
PFX = 'FCT1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_clairiere_tropicale_v1'
ETC1_POSES = 'source/entree_clairiere_tropicale_sud_nord_v1/bruts/papillons_poses.png'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Pokemon Mystery Dungeon Explorers of Sky pixel-art top-down map, WIDE LANDSCAPE 4:3, zoomed out. Use EXACTLY the '
     'same textures, palette and pixel style as the reference: soft muted light yellow-green grass with fine blade '
     'texture (NOT acid neon yellow), dark green dense jungle bushes with leafy pixel outlines, coconut palm trees, '
     'hibiscus clusters in red, yellow, cyan and pink, tan sandy stepping-stone slabs, small grey pebbles. NEW closed '
     'boss-arena clearing: dense jungle fills ALL four map edges. SOUTH: trail of tan stepping stones from the bottom '
     'edge center into a LARGE round open grass clearing. CENTER: vast empty grass. NORTH: hibiscus mound and one tall '
     'coconut palm (objective), grass to its foot. No sea, no water, no jetty, no cave, no dark hole, no signpost, no '
     'characters, no text, no UI, no border, no magenta.',
     'essais': 'premier essai 1200 x 896, fidélité herbe 9,5 jungle 29,7 dalles 15,6 (seuil 35) ; cadre vert plat '
               'conservé (édition « remplir le vide » quasi identique, non écartée)'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Edit this Pokemon Mystery Dungeon pixel-art map. Same framing, same size, exact same pixel style. Replace '
     'EVERYTHING (jungle bushes, palm trees, flowers, pebbles, stepping stones, flower mound) with the same plain light '
     'muted yellow-green clearing grass with its fine blade texture, so the whole image is grass floor only. Keep the '
     'exact same grass colour and pixel texture as the clearing in this image. No trees, no flowers, no rocks, no path, '
     'no water, no border, no text.',
     'essais': 'premier essai ; recalage (0, 0), écart moyen 4,33'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Edit this Pokemon Mystery Dungeon pixel-art map. Same framing, exact same pixel style and layout of the clearing '
     'and jungle. Remove every palm tree, every flower cluster, every small bush tuft and every small grey pebble: '
     'replace them with what is around them (the same dense dark green jungle bushes, or the same light yellow-green '
     'grass in the clearing). Keep the stepping-stone path, the shape of the grass clearing, and the jungle ring exactly '
     'as they are. No characters, no text, no border, no water, no cave.',
     'essais': 'premier essai ; témoin de segmentation, jamais exporté ; recalage (0, 0), écart moyen 7,22'},
    {'file': 'papillons_poses.png', 'images': [REF_NAME], 'prompt':
     'REUTILISEE sans nouvelle generation : planche de l\'entree ETC1 (source/entree_clairiere_tropicale_sud_nord_v1/'
     'bruts/papillons_poses.png, meme sha256), fenetres et reduction inchangees. Prompt d\'origine : Pixel-art sprite '
     'sheet on a flat pure magenta #FF00FF background, same pixel style and bright colors as the reference. 2 rows of 6 '
     'small separate sprites: orange-red butterfly, yellow butterfly, six flapping poses each.',
     'essais': 'copie de la planche ETC1 (meme biome, memes poses) : aucune generation supplementaire'},
]
POSE_K = 12
POSE_COV = 0.3
_CX = (131, 326, 492, 625, 739, 896)
POSE_WIN = {**{f'orange_{i}': (372, cx, 180) for i, cx in enumerate(_CX)},
            **{f'jaune_{i}': (626, cx, 180) for i, cx in enumerate(_CX)}}
FLAP = [0, 1, 2, 3, 4, 3, 2, 1]
FLIGHTS = [
    ('orange', 280, 270, 50, 18, 0), ('jaune', 500, 260, 44, 16, 7),
    ('jaune', 300, 390, 40, 14, 13), ('orange', 490, 385, 48, 16, 19),
]
assert PHASES % len(FLAP) == 0
FIDELITY_MAX = 35


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'herbe': (['sol_complet', 'herbe', 'ombres'], 96), 'dalles_touffes': (['dalles', 'touffes'], 64),
                  'fleurs': (['fleurs'], 48), 'vegetation': (['jungle', 'palmiers'], 96)}
STATIC = ['herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers']
ANIMS = ['papillons']


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
    """Herbe claire de la clairière (rip (183,214,97)), jungle (verts sombres), dalles de sable."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    return {'herbe': (g > 190) & (r > 150) & (b < 140) & (g > r) & (g - b > 80),
            'jungle': (g > r + 10) & (g > b + 30) & (lum < 150) & (lum > 40),
            'dalles': (r > 200) & (r > g) & (g > b + 30) & (r - b > 60) & (r - b < 120)}


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


def flower_px(a):
    r, g, b = a.transpose(2, 0, 1); sat = a.max(2) - a.min(2)
    return (sat > 120) & (((r > 200) & (g < 120)) | ((r > 200) & (g > 180) & (b < 90)) | ((b > 200) & (r < 120))
                          | ((r > 200) & (b > 150) & (g < 150)))


def classify(a, t):
    """a : décor, t : témoin sans objets. Seuils mesurés sur le brut :
    objets = écart décor / témoin lissé 3 px > 28, fermé, trous bouchés, >= 60 px ;
    palmiers = composantes > 2500 px (hors pixels de fleur, rattachés aux fleurs) ;
    fleurs = composantes avec >= 8 % de pixels saturés, ou pixels de fleur des palmiers ;
    touffes = le reste des objets ; dalles = beige 30 à 4000 px ;
    herbe = lum lissée 9 px > 178, grande composante ; ombres = herbe assombrie à <= 28 px de la jungle
    (lum lissée 140-190) ; jungle = le reste. Pas de mer, pas de bouche, pas de ponton."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    obj = keep_large(nd.binary_fill_holes(close_(diff > 28, 3)), 60)
    ol, on = nd.label(obj); fpx = flower_px(a)
    pal = np.zeros_like(obj); fle = np.zeros_like(obj); tou = np.zeros_like(obj)
    kinds = {'palmiers': 0, 'fleurs': 0, 'touffes': 0}
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if m.sum() > 2500:
            fp = m & fpx[s]; pal[s] |= m & ~fpx[s]; fle[s] |= fp; kinds['palmiers'] += 1
            if fp.any():
                kinds['fleurs'] += 1
        elif fpx[s][m].mean() > 0.08:
            fle[s] |= m; kinds['fleurs'] += 1
        else:
            tou[s] |= m; kinds['touffes'] += 1
    dal = (r >= g) & (r - b > 55) & (lum > 140) & ~obj
    dal = nd.binary_fill_holes(close_(dal, 2)); dl, dn = nd.label(dal); ds = nd.sum(dal, dl, range(1, dn + 1))
    dal = np.isin(dl, [i + 1 for i, v in enumerate(ds) if 30 <= v <= 4000])
    her = (nd.uniform_filter(lum, 9) > 178) & ~obj
    her = keep_large(open_(close_(her, 3), 3), 20000)
    her = nd.binary_fill_holes(her) & ~obj & ~dal
    rest = ~(pal | fle | tou | dal | her)
    jung_seed = keep_large(close_(rest & (nd.uniform_filter(lum, 9) < 170), 2), 5000)
    sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - nd.uniform_filter(lum, 7) ** 2, 0))
    Ls = nd.uniform_filter(lum, 5)
    db = nd.distance_transform_edt(~jung_seed)
    omb = (g > r) & (g - b > 40) & (Ls > 140) & (Ls < 190) & (db <= 28) & (sd < 16) & rest
    omb = close_(omb, 2) & rest
    used = pal | fle | tou | dal | her | omb
    jungle = ~used
    masks = dict(palmiers=pal, fleurs=fle, touffes=tou, dalles=dal, ombres=omb, herbe=her, jungle=jungle)
    seg = {'objets': int(on), 'objets_par_type': kinds, 'overlap_corrige': True,
           'ombres_lum': round(float(lum[omb].mean()), 1) if omb.any() else None,
           'herbe_lum': round(float(lum[her].mean()), 1)}
    return masks, seg


def sheet_poses(path):
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((g < 90) & (r - g > 130) & (b - g > 130)) | ((r - g > 60) & (b - g > 60))
    lab, _ = nd.label(nd.binary_closing(~bg, iterations=3))
    own = {}
    for name, (cy, cx, s) in POSE_WIN.items():
        win = lab[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]
        ids, cnt = np.unique(win[win > 0], return_counts=True)
        c = lab[cy, cx] if lab[cy, cx] else ids[cnt.argmax()]
        own[name] = bg | (lab != c)
    px = np.concatenate([src[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2][~own[nm][cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]]
                         for nm, (cy, cx, s) in POSE_WIN.items()])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=10, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:30], float).reshape(-1, 3)
    return {name: reduce_pose(src, own[name], cy, cx, s, POSE_K, pal, POSE_COV) for name, (cy, cx, s) in POSE_WIN.items()}, pal


def reduce_pose(src, bg, cy, cx, win, k, pal, cov_min):
    h, w = bg.shape; y0, x0 = int(cy) - win // 2, int(cx) - win // 2; n = win // k
    pad = np.zeros((win, win, 3)); pm = np.zeros((win, win), bool)
    sy0, sx0, sy1, sx1 = max(0, y0), max(0, x0), min(h, y0 + win), min(w, x0 + win)
    pad[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = src[sy0:sy1, sx0:sx1]
    pm[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = ~bg[sy0:sy1, sx0:sx1]
    blk = pm.reshape(n, k, n, k); cov = blk.mean((1, 3))
    col = (pad * pm[..., None]).reshape(n, k, n, k, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
    o = np.zeros((n, n, 4), 'uint8'); o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
    o[..., 3] = 255; o[cov < cov_min] = 0
    return o


def paste(frame, spr, cx, cy):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def flight_pos(fl, t):
    _, cx, cy, ax, ay, off = fl; u = 2 * np.pi * ((t + off) % PHASES) / PHASES
    return cx + ax * np.sin(u), cy + ay * np.sin(2 * u)


def butterfly_frames(poses, flights, ts=range(PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for fl in flights:
            x, y = flight_pos(fl, t)
            paste(a, poses[f'{fl[0]}_{FLAP[(t + fl[5]) % len(FLAP)]}'], x, y)
        frames.append(a)
    return frames


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Clairiere tropicale V1 (FCT1)')
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
    zip_path = R / 'mod_metano_expeditions_pmdo_0812.zip'
    with zipfile.ZipFile(zip_path) as z:
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
    o.update(Name={'DefaultText': 'Fin Clairiere tropicale - arene (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Clairiere tropicale ; papillons generes '
                     '(planche ETC1). Collisions de base a verifier. Aucune sortie ni warp. Biome et portee choisis par l agent.')
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
             f'-- {ASSET} : base d edition, aucun warp.\\nlocal {ASSET} = {{}}\\nreturn {ASSET}\\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Clairiere tropicale 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : zone de fin de donjon dans une clairiere tropicale fermee, generee au format 4:3 (ref. rip Clairiere tropicale), papillons animes. Pas une aventure jouable.</Description>
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
    a, f, tm, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == tm.shape[:2] == (SRC[1], SRC[0])
    assert sha(RAW / 'papillons_poses.png') == sha(R / ETC1_POSES)
    m, seg = classify(a, tm)
    clair = nd.binary_erosion(m['herbe'], iterations=6)
    reg = {'sol_complet': recalage(a, f, clair), 'temoin': recalage(a, tm, m['herbe'] | m['jungle'])}
    order = ['palmiers', 'fleurs', 'touffes', 'dalles', 'ombres', 'herbe', 'jungle']
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
    cand = ex['herbe'] | ex['ombres'] | ex['dalles'] | ex['touffes']
    cl, _ = nd.label(cand); seed = cl[H - 1]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    poses, pose_pal = sheet_poses(RAW / 'papillons_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    papillons = butterfly_frames(poses, FLIGHTS)
    anim = {'papillons': papillons}
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
    # Objectif : case libre la plus haute dans la colonne centrale (pied du tertre de fleurs).
    mid = W // 16
    cands = [(cx, cy) for cy in range(gh_) for cx in range(mid - 10, mid + 10) if free(cx, cy)]
    top = min(cy for _, cy in cands)
    obj_c = min((c for c in cands if c[1] <= top + 2), key=lambda c: abs(c[0] - mid))
    objective_px = [obj_c[0] * 8, obj_c[1] * 8]
    reach_boss, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_c[1], boss_c[0]))
    reach_obj, explored_o = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (obj_c[1], obj_c[0]))
    assert reach_boss and reach_obj, 'pas de chemin 16x16'
    reach = bool(reach_boss and reach_obj)

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
    names = list(POSE_WIN); cw = 15 * 6 + 8
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (191, 215, 103, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 6, im.height * 6), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_clairiere_tropicale_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objective_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('jungle', 'jungle'), ('dalles', 'dalles')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    manifest = {
        'lot': 'fin_clairiere_tropicale_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin de donjon',
        'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (EWC1 pour les utilitaires, ETC1 pour la planche de papillons) ; aucun emprunt aux branches soeurs',
        'biome': 'fin de la clairiere tropicale (biome de ETC1), biome et portee choisis par l agent (« Vasy genere la prochaine map »), a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet sans mer ni bouche, '
                  'sol complet et temoin sans objets edites depuis le decor, planche papillons ETC1 reutilisee',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Clairiere tropicale et rive (titre de l audit zones_bg_audit_v1 ; jeu et scene non confirmes)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'recalage': {**reg, 'zones': 'sol complet : herbe de la clairiere erodee de 6 px ; temoin : herbe | jungle'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid, 'seuil': FIDELITY_MAX},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'papillons': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K}', 'couverture_min': POSE_COV,
                      'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores ; '
                              'chaque fenetre ne garde que la composante qui contient son centre (voisins exclus)',
                      'palette': [[int(round(c)) for c in p] for p in pose_pal], 'battement': FLAP,
                      'vols': [list(fl) for fl in FLIGHTS], 'phases': PHASES, 'frame_length_ticks': TICKS,
                      'planche': ETC1_POSES, 'origine': 'dessin GENERE de ETC1 (10 couleurs) ; battement, vols et placement crees par nous'},
        'shadows': 'calque ombres = herbe du rendu assombrie au pied de la jungle (separee, pas inventee)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objective_px': objective_px, 'path_found_16x16': reach,
                   'path_to_boss': reach_boss, 'path_to_objective': reach_obj, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe, ombres, dalles, touffes reliees au sud)',
                   'boss': 'case 2 x 2 libre la plus proche du centre de gravite du sol praticable',
                   'objectif': 'case 2 x 2 libre la plus haute de la colonne centrale (+-80 px), pied du tertre de fleurs',
                   'fin': 'aucune sortie, aucun warp, pas de donjon_seuil ; bords nord et flancs = jungle'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objective_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
