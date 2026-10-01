"""Fin Star Cave (FST1) — zone de fin de donjon de la grotte de cristaux, format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « bon travail continue la suite ! » (29 septembre, après FSM1) : suite de la série des fins de donjon
dans l'ordre du mod, après Fin Sables mouvants. Biome de l'entrée ESC1 (Star Cave), référence `starcavepmdsky.png`
(deux vues 504 x 504). Biome et portée choisis par l'agent, à confirmer. Méthode « textures canoniques » = rendu
généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : arène de cristal ronde, couloir sud, alcôve de cristal au nord, sans étoiles ni bouche sombre ;
- sol_complet.png : édité depuis le décor (sol seul, cratères et fissures gardés), recalé (0, 0) ;
- poussiere_etoile_poses.png : planche de l'entrée ESC1, copiée sans nouvelle génération.
Calques : sol complet, sol, ombres, parois de cristal, blocs.
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks, avec les fonctions, sprites d'étoiles et couleurs
EXACTES du rip de l'entrée ESC1 (chargées par le module lui-même : reflets, étoiles, poussière d'étoile).
Scène : PPCM(120, 120, 120) = 120 ticks = 2 s.
Marqueurs : `entrance` (sud), `boss` (centre de l'arène), `objectif` (pied de l'alcôve au nord).
Aucune sortie, aucun warp, pas de `donjon_seuil`.
Lancer : .venv/bin/python source/fin_star_cave_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = R / 'starcavepmdsky.png'
OUT = R / 'renders/fin_star_cave_v1'
STAGE = R / '.cache/fin_star_cave_v1/fin_star_cave'
NAMESPACE = 'fin_star_cave'
ASSET = 'fst1_fin_star_cave'
PFX = 'FST1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5                     # les trois animations : 24 x 5 = 120 ticks
LOOP_TICKS = 120
GEN = [
    {'file': 'decor.png', 'images': ['starcavepmdsky.png'], 'prompt':
     "Use the reference image's exact pixel-art style, palette and textures (Pokemon Mystery Dungeon, Star Cave): "
     'smooth flat steel-blue cave floor with small round crater dents and faint cracks, darker floor band along the '
     'walls, dark blue crystal cave walls made of stacked faceted blue crystal boulders with cyan highlights, loose blue '
     'rock chunks. Create a NEW map, WIDE LANDSCAPE 4:3, zoomed out, top-down view. The player arrives from the SOUTH '
     'edge through a floor corridor between crystal walls, which opens into a large round crystal cavern, a boss arena '
     'with a wide open round floor. At the NORTH, inside the crystal wall, a tall alcove of stacked crystal boulders '
     'with the blue floor leading right up to its foot (no dark hole). Four small clusters of loose blue rocks on the '
     'floor, two on each side, away from the central path. Crystal walls fill all map edges, no empty dark void '
     'background. IMPORTANT: no sparkles, no stars, no glints, no characters, no text, no UI, no border.',
     'essais': 'deuxieme essai ; le premier (meme prompt plus long, « very large round cavern... boss fight ») a rendu '
               '1440 x 720 (2:1) au lieu de 4:3 : ecarte (non conserve) ; aucune etoile peinte'},
    {'file': 'sol_complet.png', 'images': ['source/fin_star_cave_v1/bruts/decor.png', 'starcavepmdsky.png'],
     'prompt':
     'Edit this pixel-art map, same framing and exact same pixel style: replace ALL the crystal walls, the loose blue '
     'rocks and the alcove with the same smooth steel-blue cave floor, so the whole image is floor only. '
     "Keep the floor's small round crater dents and faint cracks, and add more of the same scattered across the new "
     'floor areas. Keep the exact same floor blue colour and pixel texture. No walls, no rocks, no sparkles, no border.',
     'essais': 'premier essai'},
    {'file': 'poussiere_etoile_poses.png', 'images': ['starcavepmdsky.png'], 'prompt':
     'REUTILISEE sans nouvelle generation : planche de l\'entree ESC1 (source/entree_star_cave_sud_nord_v1/bruts/'
     'poussiere_etoile_poses.png, meme sha256), fenetres et reduction inchangees. Prompt d\'origine : Pixel-art sprite '
     'sheet on a flat pure magenta #FF00FF background, same pixel style and palette as the reference. Two rows of six '
     'separate small sprites: a tiny glowing star-dust mote rising (six poses), then a small cluster of floating star '
     'dust specks (six poses). Hard pixel edges, no text, no grid lines.',
     'essais': 'copie de la planche ESC1 (meme biome, memes poses) : aucune generation supplementaire'},
]
# ---- Étoiles : formes et couleurs EXACTES relevées sur le rip (254 étoiles : 96 croix blanches, 70 croix lavande,
# 48 étoiles lavande, 40 étoiles vertes).
C_W, C_ARM = (255, 255, 255), (79, 167, 207)
C_L, C_M, C_N = (111, 119, 167), (119, 127, 175), (119, 135, 175)
C_G = (55, 159, 143)


def _spr(rows, cmap):
    h, w = len(rows), len(rows[0]); a = np.zeros((h, w, 4), 'uint8')
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != '.':
                a[y, x] = (*cmap[ch], 255)
    return a


STAR_CMAP = {'W': C_W, 'a': C_ARM, 'l': C_L, 'm': C_M, 'n': C_N, 'g': C_G}
STAR_SPRITES = {
    'blanc_pt': ['W'],
    'croix_blanche': ['.a.', 'aWa', '.a.'],
    'etoile_verte': ['..g..', '.ggg.', 'ggWgg', '.ggg.', '..g..'],
    'lavande_pt': ['m'],
    'croix_lavande': ['.l.', 'lml', '.l.'],
    'etoile_lavande': ['..l..', '.lnl.', 'lnmnl', '.lnl.', '..l..'],
}
STAR_FAMILY = {'blanc': ('blanc_pt', 'croix_blanche', 'etoile_verte'),
               'lavande': ('lavande_pt', 'croix_lavande', 'etoile_lavande')}
# Cycles (24 phases) : 0 = éteinte, 1 = point, 2 = croix, 3 = étoile.
SEQ_VEILLE = [1] * 7 + [2] * 4 + [3] * 3 + [2] * 4 + [1] * 6
SEQ_ECLAT = [0] * 12 + [1, 2, 3, 3, 3, 2, 1] + [0] * 5
assert len(SEQ_VEILLE) == len(SEQ_ECLAT) == PHASES
STAR_N = {'parois': 150, 'sol': 60}       # rip : ~127 étoiles par vue, moitié près du sol
STAR_GAP = 14                             # écart minimal (Chebyshev) entre deux étoiles
# ---- Reflets : rampe cyan des cristaux du rip (couleurs claires, par luminance croissante).
RAMP = [(71, 151, 191), (87, 167, 199), (103, 191, 215), (135, 207, 215)]
GLINT_U = 480                              # période de la vague selon u = x + y (px)
GLINT_STEP = GLINT_U // PHASES             # 20 px par phase
GLINT_CORE, GLINT_HALO = 6, 16             # demi-largeurs : +2 crans au cœur, +1 cran dans le halo
FACET_Q = 0.88                             # facettes = pixels de cristal au-dessus de ce quantile de luminance
# ---- Poussière d'étoile : fenêtres (cy, cx, côté multiple de 8) mesurées par case de la planche 2 x 6.
POSE_K = 8
POSE_COV = 0.25
POSE_WIN = {'orbe_0': (257, 119, 24), 'orbe_1': (224, 362, 80), 'orbe_2': (209, 599, 120),
            'orbe_3': (179, 839, 144), 'orbe_4': (176, 1079, 112), 'orbe_5': (179, 1319, 24),
            'nuee_0': (533, 123, 64), 'nuee_1': (533, 359, 80), 'nuee_2': (536, 593, 144),
            'nuee_3': (528, 839, 200), 'nuee_4': (527, 1074, 192)}
# nuee_5 (527, 1310, 112) écartée : ses 416 pixels sont tous teintés de magenta (fondu du générateur dans le fond,
# ex. (220,105,243)), donc traités comme fond ; la nuée 4 perd 769 pixels teintés sur 1643.
POSES_ECARTEES = {'nuee_5': 'fenetre (527, 1310, 112) : 416 px sur 416 teintes de magenta (r-g > 60 et b-g > 60)'}
DUST_SEQ = (['orbe_0', 'orbe_0', 'orbe_1', 'orbe_1', 'orbe_2', 'orbe_2', 'orbe_3', 'orbe_3', 'orbe_3', 'orbe_4', 'orbe_4',
             'nuee_0', 'nuee_1', 'nuee_1', 'nuee_2', 'nuee_2', 'nuee_3', 'nuee_3', 'nuee_4', 'nuee_4']
            + [None] * 4)
DUST_RISE = 1                              # px vers le haut par phase
DUST_N = 5
assert len(DUST_SEQ) == PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, place, cell_grid, close_ = V1.keep_large, V1.place, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'terrain': (['sol_complet', 'sol', 'ombres'], 96),
                  'cristal': (['parois', 'blocs'], 96)}
STATIC = ['sol', 'ombres', 'parois', 'blocs']
ANIMS = ['reflets', 'etoiles', 'poussiere_etoile']


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
    """Sol bleu acier (rip (47,111,151)) et cristal (bleus plus sombres ou plus clairs). Le vide du rip (39,47,55,
    b-r = 16) et les étoiles sont exclus des deux matières."""
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    sol = (b - r > 85) & (g > 95) & (g < 125) & (b > 135) & (b < 162)
    star = np.zeros(a.shape[:2], bool)
    for c in (C_W, C_ARM, C_L, C_M, C_N, C_G):
        star |= (a[..., :3] == c).all(-1)
    cristal = (b - r > 30) & ~sol & (lum > 45) & ~star
    return {'sol': sol, 'cristal': cristal}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """a : décor. Seuils mesurés sur le brut (fenêtres de contrôle) :
    sol (49,109,146), écart-type local 0,9 ; bande sombre vers les parois sur 20-25 px (lum 95 -> 60), écart-type 4 ;
    parois : écart-type 7-11, b-r 41-66 ; coins sombres b-r 17 (parois)."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    m1 = nd.uniform_filter(lum, 7); sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - m1 ** 2, 0))
    # Sol : couleur du sol à ±8, fermé (cratères, fissures) puis ouvert, grande composante.
    pure = np.abs(a - [49, 109, 146]).max(-1) <= 8
    core = keep_large(open_(close_(pure, 3), 2), 50000)
    holes = nd.binary_fill_holes(core) & ~core; hl, hn = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hn + 1)) if hn else np.array([])
    blocs = np.isin(hl, [i + 1 for i, v in enumerate(hs) if v >= 150])          # rochers posés sur le sol
    core |= holes & ~blocs                                                        # cratères et fissures : sol
    # Ombres : sol assombri contigu au sol, peu texturé (écart-type < 7), à <= 28 px du sol.
    dcore = nd.distance_transform_edt(~core)
    shade = (dcore > 0) & (dcore <= 28) & (b - r > 55) & (sd < 7) & (lum > 55) & ~blocs
    shade = keep_large(close_(shade, 1), 200) & ~core & ~blocs
    walls = ~core & ~shade & ~blocs
    masks = dict(sol=core, ombres=shade, blocs=blocs, parois=walls)
    seg = {'blocs': int((hs >= 150).sum()), 'trous_rendus_au_sol': int((hs < 150).sum())}
    return masks, seg


# ---------------------------------------------------------------- animations
def star_frames(stars, ts=range(PHASES)):
    """stars : liste (x, y, famille, cycle, décalage). Sprites exacts du rip, centrés."""
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for x, y, fam, cyc, off in stars:
            lvl = (SEQ_VEILLE if cyc == 'veille' else SEQ_ECLAT)[(t + off) % PHASES]
            if lvl:
                paste(a, _spr(STAR_SPRITES[STAR_FAMILY[fam][lvl - 1]], STAR_CMAP), x, y)
        frames.append(a)
    return frames


def facets_of(crystal_layers):
    """Facettes claires des cristaux (parois + blocs) et leur cran dans la rampe du rip (0 à 3)."""
    rgba_ = np.zeros((H, W, 4), 'uint8')
    for l in crystal_layers:
        m = l[..., 3] == 255; rgba_[m] = l[m]
    op = rgba_[..., 3] == 255; lum = lum_of(rgba_)
    thr = np.quantile(lum[op], FACET_Q)
    fac = op & (lum >= thr)
    rl = np.array([lum_of(np.array(c, float)[None]) for c in RAMP])[:, 0]
    rank = np.abs(lum[..., None] - rl[None, None]).argmin(-1)
    return fac, rank, float(thr)


def glint_frames(fac, rank, ts=range(PHASES)):
    yy, xx = np.mgrid[:H, :W]; u = xx + yy
    frames = []
    for t in ts:
        d = np.abs(np.mod(u - GLINT_STEP * t + GLINT_U / 2, GLINT_U) - GLINT_U / 2)
        lvl = np.where(d <= GLINT_CORE, 2, np.where(d <= GLINT_HALO, 1, 0))
        a = np.zeros((H, W, 4), 'uint8'); sel = fac & (lvl > 0)
        idx = np.minimum(rank + lvl, len(RAMP) - 1)
        for i, c in enumerate(RAMP):
            a[sel & (idx == i)] = (*c, 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- poses générées (planche sur magenta)
def sheet_poses(path):
    """Fond = magenta pur (g < 90, r-g et b-g > 130) ET pixels teintés de magenta (r-g > 60 et b-g > 60) : le
    générateur a fondu les grains pâles dans le fond malgré la consigne (2377 pixels teintés). Ils ne sont ni gardés
    ni recolorés : ce sont des mélanges avec le fond, pas des couleurs du dessin."""
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((g < 90) & (r - g > 130) & (b - g > 130)) | ((r - g > 60) & (b - g > 60))
    px = np.concatenate([src[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2][~bg[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]]
                         for cy, cx, s in POSE_WIN.values()])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=8, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:24], float).reshape(-1, 3)
    return {name: reduce_pose(src, bg, cy, cx, s, POSE_K, pal, POSE_COV) for name, (cy, cx, s) in POSE_WIN.items()}, pal


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


def paste(frame, spr, cx, cy, clip=None):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    if clip is not None:
        m &= clip[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1]
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]



# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Star Cave V1 (FST1)')
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
    o.update(Name={'DefaultText': 'Fin Star Cave - arene de cristal (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Star Cave ; etoiles scintillantes (formes et couleurs '
                     'exactes du rip), reflets des cristaux aux couleurs du rip, poussiere d etoile generee. Collisions '
                     'de base a verifier. Aucune sortie ni warp. Biome et portee choisis par l agent.')
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
  <Name>Fin Star Cave 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : zone de fin de donjon dans une grotte de cristaux etoilee, generee au format 4:3 (ref. rip Star Cave), etoiles scintillantes, reflets des cristaux et poussiere d'etoile animes. Pas une aventure jouable.</Description>
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


def dust_frames(poses, emitters, ts=range(PHASES)):
    """Chaque émetteur (x, y, décalage) : une orbe naît au sol, monte de 1 px par phase, puis se disperse en nuée
    qui continue de monter. Non détourée : elle flotte en l'air."""
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for (cx, cy, off) in emitters:
        for i, t in enumerate(ts):
            k = (t + off) % PHASES; nm = DUST_SEQ[k]
            if nm:
                paste(frames[i], poses[nm], cx, cy - DUST_RISE * k)
    return frames


# ---------------------------------------------------------------- main
def recalage(a, f):
    """Écart moyen décor / sol complet sur le sol texturé (cratères, fissures) du centre de la caverne, à (0, 0) et
    au meilleur décalage de 1 px."""
    zone = np.zeros(a.shape[:2], bool); zone[300:620, 180:1020] = True
    zone &= np.abs(a - [49, 109, 146]).max(-1) <= 40
    zone &= nd.binary_dilation(np.abs(a - [49, 109, 146]).max(-1) > 8, iterations=3)   # autour des cratères
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(f, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen_sol': round(err[(0, 0)], 2),
            'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def spread(cand, n, gap, rng, taken=()):
    """Tirage de n points (y, x) espacés d'au moins gap (Chebyshev), entre eux et avec taken."""
    cand = cand.copy(); rng.shuffle(cand); out = list(taken)
    k0 = len(out)
    for y, x in cand:
        if all(max(abs(int(y) - py), abs(int(x) - px)) >= gap for py, px in out):
            out.append((int(y), int(x)))
        if len(out) - k0 == n:
            break
    return out[k0:]


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
    a = rgb(RAW / 'decor.png'); f = rgb(RAW / 'sol_complet.png'); ref = rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['sol', 'ombres', 'blocs', 'parois']
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
    walk = (layers['sol'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    crystal = (layers['parois'][..., 3] == 255) | (layers['blocs'][..., 3] == 255)
    # Reflets.
    fac, rank, fac_thr = facets_of([layers['parois'], layers['blocs']])
    Image.fromarray((fac * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_facettes.png')
    reflets = glint_frames(fac, rank)
    # Étoiles : sur les parois et sur le sol ; sprite entier dans l'image.
    rng = np.random.default_rng(31)
    inside = np.zeros((H, W), bool); inside[3:H - 3, 3:W - 3] = True
    c_wall = np.argwhere(crystal & inside & (nd.distance_transform_edt(crystal) > 2))
    c_floor = np.argwhere(walk & inside & (nd.distance_transform_edt(walk) > 3))
    pts_w = spread(c_wall, STAR_N['parois'], STAR_GAP, rng)
    pts_f = spread(c_floor, STAR_N['sol'], STAR_GAP, rng, taken=pts_w)
    stars = []
    for j, (y, x) in enumerate(pts_w + pts_f):
        fam = 'blanc' if rng.random() < 0.54 else 'lavande'           # rip : 136 blanches/vertes, 118 lavande
        cyc = 'veille' if rng.random() < 0.5 else 'eclat'
        stars.append((x, y, fam, cyc, int(rng.integers(PHASES))))
    etoiles = star_frames(stars)
    # Poussière d'étoile : émetteurs sur le sol dégagé, loin des parois, espacés.
    poses, pose_pal = sheet_poses(RAW / 'poussiere_etoile_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    ok = walk & (nd.distance_transform_edt(walk) > 30)
    ok[H - 120:, :] = False; ok[:, :60] = False; ok[:, W - 60:] = False
    ok &= np.roll(walk, 30, axis=0)                                            # 30 px de montée au-dessus : sol
    pts_d = spread(np.argwhere(ok), DUST_N, 110, np.random.default_rng(7))
    assert len(pts_d) == DUST_N
    emitters = [(x, y, (j * 24) // DUST_N) for j, (y, x) in enumerate(sorted(pts_d))]
    poussiere = dust_frames(poses, emitters)
    anim = {'reflets': reflets, 'etoiles': etoiles, 'poussiere_etoile': poussiere}
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
    # Collisions : sol et ombres praticables ; parois et blocs bloqués.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    free = lambda cx, cy: 0 <= cx < gw_ - 1 and 0 <= cy < gh_ - 1 and not blocked[cy:cy + 2, cx:cx + 2].any()
    # Boss : case 2 x 2 libre la plus proche du centre de gravité du sol praticable (centre de l'arène).
    wy, wx = np.nonzero(walk); tgt = (int(wx.mean()) // 8, int(wy.mean()) // 8)
    boss_c = min(((cx, cy) for cy in range(gh_) for cx in range(gw_) if free(cx, cy)),
                 key=lambda c: (c[0] - tgt[0]) ** 2 + (c[1] - tgt[1]) ** 2)
    boss_px = [boss_c[0] * 8, boss_c[1] * 8]
    # Objectif : au pied de l'alcôve du nord : case libre la plus haute dans la colonne centrale (+-64 px).
    mid = W // 16
    cands = [(cx, cy) for cy in range(gh_) for cx in range(mid - 8, mid + 8) if free(cx, cy)]
    top = min(cy for _, cy in cands)
    obj_c = min((c for c in cands if c[1] <= top + 1), key=lambda c: abs(c[0] - mid))
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
    names = list(POSE_WIN); cw = 25 * 4 + 8                               # même échelle x4 pour toutes les poses
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (39, 47, 55, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_star_cave_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objective_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sol', 'sol'), ('cristal', 'parois'), ('cristal', 'blocs')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_star_cave_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin de donjon', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 pour les utilitaires, ESC1 pour la planche de poussiere) ; aucun emprunt aux branches soeurs',
        'biome': 'fin de la grotte de cristaux etoilee (biome de ESC1), biome et portee choisis par l agent (« bon travail continue la suite ! »), a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet sans etoiles, '
                  'sol complet edite depuis le decor, planche poussiere d etoile sur magenta',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Star Cave (PMD Explorers of Sky d apres le nom du fichier) ; deux vues 504 x 504, la seconde avec la bouche'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/fin_star_cave_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'recalage_px': [0, 0], **recalage(a, f),
                        'note': 'cratères et fissures gardés et prolongés ; tout le sol sous les parois (caché)'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid,
                         'etoiles_et_reflets': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': 'sol = couleur du sol a +-8, ferme 3 px puis ouvert 2 px, grande composante, trous < 150 px '
                        '(crateres, fissures) rendus au sol ; blocs = trous du sol >= 150 px ; pas d entree sombre ; ombres = sol assombri contigu '
                        '(<= 28 px du sol, b-r > 55, ecart-type local < 7) ; parois = le reste',
        'layers': layer_list,
        'etoiles': {'phases': PHASES, 'frame_length_ticks': TICKS,
                    'sprites': {k: v for k, v in STAR_SPRITES.items()}, 'couleurs': {k: list(v) for k, v in STAR_CMAP.items()},
                    'familles': {k: list(v) for k, v in STAR_FAMILY.items()},
                    'cycles': {'veille': SEQ_VEILLE, 'eclat': SEQ_ECLAT},
                    'etoiles': [list(s) for s in stars], 'ecart_min_px': STAR_GAP, 'nombre': STAR_N,
                    'mesure_rip': '254 etoiles relevees : 96 croix blanches, 70 croix lavande, 48 etoiles lavande, 40 etoiles vertes',
                    'origine': 'formes et couleurs EXACTES du rip ; cycles, placement et scintillement crees par nous'},
        'reflets': {'phases': PHASES, 'frame_length_ticks': TICKS, 'rampe': [list(c) for c in RAMP],
                    'periode_u_px': GLINT_U, 'pas_px': GLINT_STEP, 'demi_largeurs': [GLINT_CORE, GLINT_HALO],
                    'facettes_quantile': FACET_Q, 'facettes_seuil_lum': round(fac_thr, 1), 'facettes_px': int(fac.sum()),
                    'origine': 'couleurs EXACTES du rip (rampe cyan des cristaux) ; vague creee par nous'},
        'poussiere_etoile': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'poses_ecartees': POSES_ECARTEES,
                             'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores', 'reduction': f'x1/{POSE_K} pour toutes les poses',
                             'palette': [[int(round(c)) for c in p] for p in pose_pal], 'emetteurs': [list(e) for e in emitters],
                             'sequence': DUST_SEQ, 'montee_px_par_phase': DUST_RISE, 'phases': PHASES, 'frame_length_ticks': TICKS,
                             'origine': 'dessin GENERE (8 couleurs tirees de la planche) ; chronologie, montee et placement crees par nous'},
        'shadows': 'calque ombres = sol assombri du rendu genere contre les parois (separe, pas invente)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objective_px': objective_px, 'path_found_16x16': reach,
                   'path_to_boss': reach_boss, 'path_to_objective': reach_obj, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors sol (ombres comprises)',
                   'boss': 'case 2 x 2 libre la plus proche du centre de gravite du sol praticable',
                   'objectif': 'case 2 x 2 libre la plus haute de la colonne centrale (+-64 px), au pied de l alcove',
                   'fin': 'aucune sortie, aucun warp, pas de donjon_seuil ; la bande nord est une paroi'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objective_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'emitters': emitters, 'seg': seg, 'stars': len(stars),
                      'facettes': int(fac.sum()), 'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
