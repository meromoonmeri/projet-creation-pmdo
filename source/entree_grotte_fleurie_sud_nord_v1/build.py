"""Entrée Grotte Fleurie sud -> nord V1 (EGF1) — recréation de la capture PMDO de l'utilisateur.

Référence : reference/capture_pmdo_source.png (637x471, Mudkip + Pokémon gris retirés).
Méthode rendu généré (GUIDE_CREATION_DE_MAP.md / METHODE_MAGENTA_ET_GENERATEUR.md) :
- decor_magenta.png 1200x896 généré d'après la capture (grotte = magenta) ;
- sol_complet_genere.png généré séparément, puis nettoyé par quilting d'herbe saine -> sol_complet.png ;
- étalonnage colorimétrique par matière vers la capture (distance cible < 35) ;
- normalisation uniforme x(576/896) -> 771x576, recadrage centré 768 (1 px / 2 px),
  réduction par moyenne pondérée PAR CLASSE, attribution exclusive, palette commune 96 couleurs.
Pas d'eau dans la référence : aucun calque eau/scintillements.
Animations : fleurs au vent (8 x 10 ticks, cisaillement ancré au pied) + papillons générés
(planche EJN1 réutilisée, 48 x 5 ticks = 4 s). Scène : PPCM 240 ticks = 4 s.
Lancer : .venv/bin/python source/entree_grotte_fleurie_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, math, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = HERE / 'reference/capture_pmdo_source.png'
OUT = R / 'renders/entree_grotte_fleurie_sud_nord_v1'
STAGE = R / '.cache/entree_grotte_fleurie_sud_nord_v1/entree_grotte_fleurie_sud_nord'
NAMESPACE = 'entree_grotte_fleurie_sud_nord'
ASSET = 'egf1_entree_grotte_fleurie'
PFX = 'EGF1'
W, H = 768, 576
SRC = (1200, 896)
SCALE = H / SRC[1]
SCALED_W = round(SRC[0] * SCALE)     # 771
CROP_X = (SCALED_W - W) // 2         # 1
FLOWER_PHASES, FLOWER_TICKS = 8, 10
FLY_PHASES, FLY_TICKS = 48, 5
LOOP_TICKS = math.lcm(FLOWER_PHASES * FLOWER_TICKS, FLY_PHASES * FLY_TICKS)  # 240
BCELL = 24
FIDELITY_MAX = 35

# Ordre de priorité du classifieur couleur commun (capture + décor + scène). Chaque pixel est
# attribué à UNE matière (exclusif), ce qui rend étalonnage et fidélité cohérents des deux côtés.
MATERIAL_ORDER = ['flower_r', 'flower_y', 'flower_b', 'bush', 'path', 'rock', 'grass']


def material_masks(a, valid=None, exclude_mag=False):
    """Classifieur couleur commun, masques mutuellement exclusifs par priorité.
    Conversion int obligatoire : en uint8, r+10 déborderait (wrap-around) et fausserait les masques."""
    a = np.asarray(a).astype(int)
    r, g, b = a.transpose(2, 0, 1)
    rules = {
        'grass': (g > r + 10) & (g > b + 10) & (g > 150),
        'path': (r > 200) & (b > 130) & (r > g + 20),
        'rock': (r > 140) & (b < 140) & (r > g + 15) & (g > b + 15),
        'bush': (g > r + 20) & (g > b + 20) & (g < 185) & (r < 110),
        'flower_r': (r > 175) & (g < 150) & (b < 110) & (r > g + 70),
        'flower_y': (r > 190) & (g > 165) & (b < 100) & (r > g - 25) & (r < g + 55) & (g > b + 70),
        'flower_b': (b > r + 20) & (b > 120) & (g > 120) & (r < 170),
    }
    taken = np.zeros(a.shape[:2], bool)
    if exclude_mag:
        taken |= (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    if valid is not None:
        taken |= ~valid
    out = {}
    for k in MATERIAL_ORDER:
        m = rules[k] & ~taken
        out[k] = m
        taken |= m
    return out


def reference_targets():
    """Cibles = moyennes par matière de la capture, Pokémon exclus (masque manuel)."""
    ref = rgb(REF)
    valid = np.ones(ref.shape[:2], bool)
    valid[215:255, 295:345] = False   # Mudkip
    valid[180:240, 390:455] = False   # Pokémon gris
    masks = material_masks(ref, valid=valid)
    return {k: tuple(int(round(v)) for v in ref[m].mean(0)) for k, m in masks.items() if m.sum() > 30}


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


BM = loadmod('egf1_utils', R / 'source/entree_bristle_sud_nord_v1/build.py')
BM.W, BM.H = W, H
keep_large, quantize_layers, place, cell_grid, write_ora = BM.keep_large, BM.quantize_layers, BM.place, BM.cell_grid, BM.write_ora


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- sol : quilting d'herbe saine
def quilt_sol(gen):
    """Retire les touffes parasites du sol généré en pavant des patchs d'herbe saine (recouvrement fondu)."""
    g, r, b = gen[..., 1], gen[..., 0], gen[..., 2]
    pure = (g > r + 15) & (g > b + 15) & (g > 150)
    pure = nd.binary_erosion(pure, iterations=12)
    ys, xs = np.nonzero(pure)
    assert len(ys) > 500, 'pas assez d herbe saine pour quilter'
    rng = np.random.default_rng(7)
    P, OV = 48, 8
    out = np.zeros((SRC[1], SRC[0], 3), float)
    wsum = np.zeros((SRC[1], SRC[0]), float)
    step = P - OV
    for y in range(0, SRC[1], step):
        for x in range(0, SRC[0], step):
            i = rng.integers(len(ys))
            sy = min(int(ys[i]), SRC[1] - P); sx = min(int(xs[i]), SRC[0] - P)
            patch = gen[sy:sy + P, sx:sx + P].astype(float)
            wy = np.minimum(np.arange(P), np.arange(P)[::-1]) / OV + 0.2
            wx = np.minimum(np.arange(P), np.arange(P)[::-1]) / OV + 0.2
            w = np.clip(wy[:, None] * wx[None, :], 0.05, 1.0)
            y1, x1 = min(y + P, SRC[1]), min(x + P, SRC[0])
            out[y:y1, x:x1] += patch[:y1 - y, :x1 - x] * w[:y1 - y, :x1 - x, None]
            wsum[y:y1, x:x1] += w[:y1 - y, :x1 - x]
    out /= np.maximum(wsum, 1e-6)[..., None]
    return np.clip(out, 0, 255).astype('uint8')


# ---------------------------------------------------------------- nettoyage mousse parasite
def clean_moss(a):
    """Le générateur a peint des taches vertes (mousse) dans les falaises ocre. La capture n'en a pas :
    on remplace ces îlots verts isolés (hors prairie) par la couleur ocre la plus proche (inpainting)."""
    r, g, b = a.transpose(2, 0, 1)
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    green = (g > r + 10) & (g > b + 10) & ~mag
    ochre = (r > 140) & (g > 90) & (b < 140) & (r > g + 15) & (g > b + 15) & ~mag
    # Mousse = vert dont le voisinage 17 px est majoritairement ocre (enchâssé dans la falaise),
    # qu'il soit connecté ou non à la prairie.
    frac = nd.uniform_filter(ochre.astype(float), 17)
    moss = green & (frac > 0.35)
    _, inds = nd.distance_transform_edt(~ochre, return_indices=True)
    out = a.copy()
    out[moss] = a[inds[0][moss], inds[1][moss]]
    return out, moss


def complete_masks(m, protect_cave=False):
    """Couverture totale : tout pixel non classé (fissures sombres, ombres) prend la matière
    classée la plus proche. Sans cela, le sol d'herbe transparaît dans les falaises.
    protect_cave=True (EGF2/FGF1) : la grotte reste strictement le magenta dilaté — sinon les
    roches sombres au-dessus de la bouche sont absorbées et les stalactites disparaissent."""
    keys = ['cave', 'path', 'rock', 'boulder', 'bush', 'flower', 'grass']
    labels = np.zeros(next(iter(m.values())).shape, np.int8)
    for i, k in enumerate(keys, 1):
        labels[m[k]] = i
    unc = labels == 0
    if unc.any():
        seed = unc | (labels == 1) if protect_cave else unc
        _, inds = nd.distance_transform_edt(seed, return_indices=True)
        filled = labels[inds[0], inds[1]]
        for i, k in enumerate(keys, 1):
            if protect_cave and k == 'cave':
                continue
            m[k] = m[k] | (unc & (filled == i))
    return m


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1)
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    cave = nd.binary_dilation(mag, iterations=2)
    # Sentier sable rosé : r élevé, g~180, b~160 (b > 130 le distingue de l'ocre).
    path = (r > 200) & (g > 140) & (b > 130) & (r > g + 20) & ~cave
    path = nd.binary_fill_holes(keep_large(nd.binary_closing(path, iterations=3), 3000))
    # Couleurs de fleurs d'abord : les pétales rouges satisfont aussi la règle ocre (r>g>b),
    # il faut les en retirer sinon ils sont reclassés en roche et décolorés. Seuils serrés
    # (bleu très bas, r≈g pour le jaune) + proximité de l'herbe pour ne pas mordre l'ocre.
    green0 = (g > r + 10) & (g > b + 10) & ~mag
    fr0 = (r > 185) & (g < 140) & (b < 100) & (r > g + 70)
    fy0 = (r > 195) & (g > 175) & (b < 80) & (r < g + 35)
    fb0 = (b > r + 20) & (b > 120) & (g > 120) & (r < 170)
    flower_color = (fr0 | fy0 | fb0) & nd.binary_dilation(green0, iterations=8)
    flower_color = nd.binary_dilation(flower_color, iterations=2)
    # Ocre (falaises + rochers) : b < 140, r > g > b, hors fleurs.
    ochre = (r > 140) & (g > 90) & (b < 140) & (r > g + 15) & (g > b + 15) & ~cave & ~path & ~flower_color
    ochre = nd.binary_closing(ochre, iterations=2)
    lab, n = nd.label(ochre)
    border = set(np.unique(np.concatenate([lab[:40].ravel(), lab[:, :20].ravel(), lab[:, -20:].ravel()]))) - {0}
    sizes = nd.sum(ochre, lab, range(1, n + 1))
    rock_ids = [i + 1 for i in range(n) if (i + 1) in border or sizes[i] > 20000]
    boulder_ids = [i + 1 for i in range(n) if (i + 1) not in border and 300 <= sizes[i] <= 20000]
    rock = np.isin(lab, rock_ids)
    boulder = np.isin(lab, boulder_ids)
    # Buissons : vert sombre saturé.
    bush = (g > r + 20) & (g > b + 20) & (g < 185) & (r < 110) & ~cave & ~path & ~ochre
    bush = keep_large(nd.binary_closing(bush, iterations=2), 400)
    # Fleurs R/J/B sur herbe (mêmes seuils serrés que ci-dessus).
    flower = (fr0 | fy0 | fb0) & ~cave & ~path & ~ochre & ~bush
    flower = nd.binary_dilation(keep_large(nd.binary_closing(flower, iterations=2), 25), iterations=1)
    grass = (g > r + 10) & (g > b + 10) & ~cave & ~path & ~ochre & ~bush & ~flower
    grass = nd.binary_fill_holes(keep_large(nd.binary_closing(grass, iterations=2), 200))
    # fill_holes rebouche les bouquets : exclusivité stricte finale (priorité cave>path>roche>buisson>fleur>herbe).
    grass &= ~(cave | path | rock | boulder | bush | flower)
    flower &= ~(cave | path | rock | boulder | bush)
    bush &= ~(cave | path | rock | boulder)
    return dict(cave=cave, path=path, rock=rock, boulder=boulder, bush=bush, flower=flower, grass=grass)


def color_correct(a, targets):
    """Étalonnage multiplicatif par matière (classifieur commun) vers les cibles de la capture."""
    out = a.astype(float).copy()
    masks = material_masks(a, exclude_mag=True)
    stats = {}
    for k, mask in masks.items():
        if mask.sum() < 50 or k not in targets:
            continue
        mean = a[mask].mean(0)
        target = np.array(targets[k], float)
        scale = target / np.maximum(mean, 1)
        out[mask] = np.clip(a[mask] * scale, 0, 255)
        stats[k] = {'avant': mean.round(1).tolist(), 'cible': target.tolist(), 'facteur': scale.round(3).tolist()}
    return np.clip(out, 0, 255).astype('uint8'), stats


# ---------------------------------------------------------------- réduction par classe
def resize_plane(p):
    return np.array(Image.fromarray(p.astype(np.float32), 'F').resize((SCALED_W, H), Image.Resampling.BOX))[:, CROP_X:CROP_X + W]


def down_class(a, masks, order):
    weights = {k: resize_plane(masks[k].astype(np.float32)) for k in order}
    stackw = np.stack([weights[k] for k in order]); win = stackw.argmax(0); has = stackw.max(0) > 0.05
    ex = {k: (win == i) & has for i, k in enumerate(order)}
    cols = {}
    for k in order:
        w = weights[k]; m = masks[k].astype(np.float32)
        c = np.stack([resize_plane(a[..., ch] * m) for ch in range(3)], -1) / np.maximum(w, 1e-6)[..., None]
        cols[k] = np.clip(np.round(c), 0, 255).astype('uint8')
    return ex, cols


def down_full(a):
    return np.clip(np.round(np.stack([resize_plane(a[..., ch].astype(np.float32)) for ch in range(3)], -1)), 0, 255).astype('uint8')


def rgba(colors, mask):
    out = np.zeros((H, W, 4), 'uint8'); out[..., :3] = colors; out[..., 3] = 255; out[~mask] = 0
    return out


# ---------------------------------------------------------------- entrée sombre (procédurale)
def cave_fill(mask):
    ys, xs = np.nonzero(mask)
    y0, y1 = ys.min(), ys.max()
    yy = np.mgrid[:H, :W][0]
    t = np.clip((yy - y0) / max(y1 - y0, 1), 0, 1)
    top = np.array([18, 12, 10], float); bot = np.array([132, 92, 60], float)
    col = top[None, None, :] * (1 - t[..., None]) + bot[None, None, :] * t[..., None]
    noise = nd.gaussian_filter(np.random.default_rng(11).random((H, W)), 1.2)
    col += (noise[..., None] - 0.5) * 10
    # Strates horizontales très discrètes du sol de grotte.
    col += (np.sin(yy * 0.55) * 2)[..., None]
    out = np.zeros((H, W, 4), 'uint8'); out[..., :3] = np.clip(col, 0, 255); out[..., 3] = 255
    out[~mask] = 0
    return out


# ---------------------------------------------------------------- fleurs au vent
def flower_phases(flower_layer, mask):
    """Cisaillement horizontal ancré au pied de chaque bouquet, 8 phases sinusoïdales fermées."""
    lab, n = nd.label(mask)
    frames = [np.zeros((H, W, 4), 'uint8') for _ in range(FLOWER_PHASES)]
    clusters = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        if len(ys) < 4:
            continue
        by = int(ys.max()); ty = int(ys.min())
        hgt = max(by - ty, 1)
        off = (int(xs.mean()) // 17) % FLOWER_PHASES
        clusters.append({'base_xy': [int(xs.mean()), by], 'hauteur_px': hgt, 'decalage': off})
        for t in range(FLOWER_PHASES):
            amp = 1.6 * math.sin(2 * math.pi * (t + off) / FLOWER_PHASES)
            for y in range(ty, by + 1):
                dx = int(round(amp * (by - y) / hgt))
                row = flower_layer[y, xs[ys == y]]
                nx = xs[ys == y] + dx
                ok = (nx >= 0) & (nx < W)
                frames[t][y, nx[ok]] = row[ok]
    return frames, clusters


# ---------------------------------------------------------------- papillons (planche EJN1 réutilisée)
def butterfly_poses():
    src = rgb(RAW / 'papillons_poses.png'); h, w = src.shape[:2]; r, g, b = src.transpose(2, 0, 1)
    mag = (r > 150) & (b > 110) & (g < 120) & (r > g * 1.5) & (b > g * 1.3)
    cw, ch = w / 6, h / 2; k = 11; win = BCELL * k
    poses = {}
    for ry, name in ((0, 'jaune'), (1, 'bleu')):
        seq = []
        for cx in range(6):
            cell = ~mag[int(ry * ch):int((ry + 1) * ch), int(cx * cw):int((cx + 1) * cw)]
            ys, xs = np.nonzero(nd.binary_opening(cell, iterations=1))
            cy0 = int(ry * ch) + int((ys.min() + ys.max()) / 2); cx0 = int(cx * cw) + int((xs.min() + xs.max()) / 2)
            y0, x0 = cy0 - win // 2, cx0 - win // 2
            pad = np.zeros((win, win, 3), int); pm = np.zeros((win, win), bool)
            sy0, sx0 = max(0, y0), max(0, x0); sy1, sx1 = min(h, y0 + win), min(w, x0 + win)
            pad[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = src[sy0:sy1, sx0:sx1]
            pm[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = ~mag[sy0:sy1, sx0:sx1]
            box = np.zeros_like(pm)
            box[max(0, int(ry * ch) - y0):max(0, int((ry + 1) * ch) - y0), max(0, int(cx * cw) - x0):max(0, int((cx + 1) * cw) - x0)] = True
            pm &= box
            cov = pm.reshape(BCELL, k, BCELL, k).mean((1, 3))
            col = (pad * pm[..., None]).reshape(BCELL, k, BCELL, k, 3).sum((1, 3)) / np.maximum(pm.reshape(BCELL, k, BCELL, k).sum((1, 3)), 1)[..., None]
            o = np.zeros((BCELL, BCELL, 4), 'uint8'); o[..., :3] = np.clip(col, 0, 255); o[..., 3] = 255; o[cov < 0.3] = 0
            seq.append(o)
        opq = np.concatenate([s[s[..., 3] > 0][:, :3] for s in seq])
        q = Image.fromarray(opq.reshape(-1, 1, 3)).quantize(7, method=Image.Quantize.MEDIANCUT)
        pal = np.array(q.getpalette()[:21], 'uint8').reshape(7, 3)
        for s in seq:
            m = s[..., 3] > 0
            if m.any():
                s[..., :3] = pal[np.array(Image.fromarray(s[..., :3]).quantize(palette=q, dither=Image.Dither.NONE))]
            s[~m] = 0
        poses[name] = seq
    return poses


# ---------------------------------------------------------------- Ground PMDO 0.8.12
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
    o.update(Name={'DefaultText': 'Entree Grotte Fleurie - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET, Released=False,
             TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={},
             Layers=layers, Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Recreation de la capture PMDO utilisateur (EGF1) : falaises ocre, grotte a dents, '
                     'sentier sable rose, prairie fleurie. Fleurs au vent + papillons generes. Collisions a verifier. Seuil non raccorde.')
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
  <Name>Entree Grotte Fleurie sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : recreation de la capture PMDO utilisateur (falaises ocre, grotte a dents, prairie fleurie, sentier sable rose). Fleurs au vent et papillons animes. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- fidélité vs capture (même classifieur des deux côtés)
def fidelity(decor):
    """Méthode du projet : même classifieur couleur sur la capture et sur le décor généré étalonné
    (pleine résolution, avant réduction/quantification). Les Pokémon de la capture sont masqués."""
    ref = rgb(REF)
    valid = np.ones(ref.shape[:2], bool)
    valid[215:255, 295:345] = False   # Mudkip
    valid[180:240, 390:455] = False   # Pokémon gris
    rm = material_masks(ref, valid=valid)
    sm = material_masks(decor, exclude_mag=True)
    out = {}
    for k in MATERIAL_ORDER:
        if rm[k].sum() < 30 or sm[k].sum() < 30:
            continue
        mr = ref[rm[k]].mean(0)
        md = decor[sm[k]].mean(0)
        out[k] = {'capture_rgb': mr.round(1).tolist(), 'decor_rgb': md.round(1).tolist(),
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- main
def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    for d in ['calques', 'animation/fleurs', 'animation/papillons', 'poses_papillons', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    a0 = rgb(RAW / 'decor_magenta.png')
    gen_sol = rgb(RAW / 'sol_complet_genere.png')
    assert a0.shape[:2] == gen_sol.shape[:2] == (SRC[1], SRC[0])
    targets = reference_targets()
    sol = quilt_sol(gen_sol)
    sol, _ = color_correct(sol, targets)          # sol étalonné lui aussi (sinon lime transparaît)
    Image.fromarray(sol).save(RAW / 'sol_complet.png')
    a_clean, moss = clean_moss(a0)
    Image.fromarray((moss * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_mousse_nettoyee.png')
    m = complete_masks(classify(a_clean))
    a, corr_stats = color_correct(a_clean, targets)
    Image.fromarray(a).save(OUT / 'review' / f'{PFX}_decor_etalo.png')
    order = ['cave', 'grass', 'path', 'boulder', 'bush', 'flower', 'rock']
    ex, cols = down_class(a, m, order)
    layers = {
        'sol_complet': rgba(down_full(sol), np.ones((H, W), bool)),
        'entree_sombre': cave_fill(ex['cave']),
        'herbe': rgba(cols['grass'], ex['grass']),
        'sentier': rgba(cols['path'], ex['path']),
        'rochers': rgba(cols['boulder'], ex['boulder']),
        'buissons': rgba(cols['bush'], ex['bush']),
        'falaises': rgba(cols['rock'], ex['rock']),
    }
    flower_static = rgba(cols['flower'], ex['flower'])
    layers = quantize_layers(layers)
    # Fleurs : palette DÉDIÉE 32 couleurs (petites zones, la palette commune 96 les écraserait).
    fm = flower_static[..., 3] == 255
    if fm.any():
        fq = Image.fromarray(flower_static[fm][:, :3].reshape(-1, 1, 3)).quantize(32, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        flower_static[..., :3] = np.array(fq.getpalette()[:96], 'uint8').reshape(-1, 3)[np.array(Image.fromarray(flower_static[..., :3]).quantize(palette=fq, dither=Image.Dither.NONE))]
    flower_static[~fm] = 0
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    ff, clusters = flower_phases(flower_static, ex['flower'])
    # Papillons : 4 boucles en huit au-dessus de la prairie.
    poses = butterfly_poses()
    for nm, seq in poses.items():
        for i, p in enumerate(seq):
            Image.fromarray(p).save(OUT / 'poses_papillons' / f'{PFX}_papillon_{nm}_{i}.png')
    flights = [((250, 380), (55, 32), 0, 'jaune'), ((520, 420), (60, 36), 17, 'bleu'),
               ((650, 340), (48, 28), 31, 'jaune'), ((390, 480), (52, 30), 8, 'bleu')]
    bf = [np.zeros((H, W, 4), 'uint8') for _ in range(FLY_PHASES)]; tracks = []
    for (cx, cy), (ax, ay), off, colr in flights:
        pts = []
        for t in range(FLY_PHASES):
            u = 2 * np.pi * (t + off) / FLY_PHASES
            x = int(round(cx + ax * np.sin(u))); y = int(round(cy + ay * np.sin(2 * u)))
            p = poses[colr][(t + off) % 6]; mm = p[..., 3] > 0
            x0, y0 = x - BCELL // 2, y - BCELL // 2
            assert 0 <= x0 and x0 + BCELL <= W and 0 <= y0 and y0 + BCELL <= H
            bf[t][y0:y0 + BCELL, x0:x0 + BCELL][mm] = p[mm]; pts.append([x, y])
        tracks.append({'centre': [cx, cy], 'amplitude': [ax, ay], 'decalage': off, 'couleur': colr, 'positions': pts})
    # Exports
    for t, fr in enumerate(ff):
        Image.fromarray(fr).save(OUT / 'animation/fleurs' / f'{PFX}_03_fleurs_vent_f{t}.png')
    for t, fr in enumerate(bf):
        Image.fromarray(fr).save(OUT / 'animation/papillons' / f'{PFX}_08_papillons_f{t:02d}.png')
    static_order = ['sol_complet', 'entree_sombre', 'herbe', 'sentier', 'rochers', 'buissons', 'falaises']
    numbers = {'sol_complet': 0, 'entree_sombre': 1, 'herbe': 2, 'sentier': 4, 'rochers': 5, 'buissons': 6, 'falaises': 7}
    files = {}
    for nm in static_order:
        fn = f'{PFX}_{numbers[nm]:02d}_{nm}.png'; Image.fromarray(layers[nm]).save(OUT / 'calques' / fn); files[nm] = fn
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('entree_sombre', [layers['entree_sombre']], 60),
                   ('herbe', [layers['herbe']], 60), ('fleurs_vent', ff, FLOWER_TICKS),
                   ('sentier', [layers['sentier']], 60), ('rochers', [layers['rochers']], 60),
                   ('buissons', [layers['buissons']], 60), ('falaises', [layers['falaises']], 60),
                   ('papillons', bf, FLY_TICKS)]
    # Collisions : herbe + sentier + emplacements des fleurs praticables ; reste bloque.
    walk = (layers['herbe'][..., 3] == 255) | (layers['sentier'][..., 3] == 255) | ex['flower']
    walk &= ~((layers['rochers'][..., 3] > 0) | (layers['buissons'][..., 3] > 0) | (layers['falaises'][..., 3] > 0) | ex['cave'])
    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    px = np.nonzero(layers['sentier'][H - 8, :, 3])[0]; med = int(np.median(px)) // 8
    cx = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [cx * 8, H - 16]
    gy, gx = np.nonzero(ex['cave']); threshold_px = [int(gx.mean()) // 8 * 8 - 8, (int(gy.max()) + 8) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    ok, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert ok, 'pas de chemin 16x16'

    def scene(tick):
        flp = (tick // FLOWER_TICKS) % FLOWER_PHASES; fp = (tick // FLY_TICKS) % FLY_PHASES
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[{'fleurs_vent': flp, 'papillons': fp}.get(title, 0)]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    fid = fidelity(a)                              # décor généré étalonné, pleine résolution (méthode projet)
    for k, v in fid.items():
        assert v['distance'] < FIDELITY_MAX, (k, v)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sheet = Image.new('RGBA', (6 * 100, 200), (48, 136, 64, 255))
    for r_, nm in enumerate(poses):
        for i, p in enumerate(poses[nm]):
            sheet.alpha_composite(Image.fromarray(p).resize((96, 96), Image.Resampling.NEAREST), (i * 100, r_ * 100))
    sheet.save(OUT / 'review' / f'{PFX}_planche_papillons_x4.png')
    write_ora(OUT / f'{PFX}_entree_grotte_fleurie_calques.ora',
              {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    order_files = [f'calques/{files["sol_complet"]}', f'calques/{files["entree_sombre"]}', f'calques/{files["herbe"]}',
                   f'animation/fleurs/{PFX}_03_fleurs_vent_fX.png', f'calques/{files["sentier"]}', f'calques/{files["rochers"]}',
                   f'calques/{files["buissons"]}', f'calques/{files["falaises"]}', f'animation/papillons/{PFX}_08_papillons_fXX.png']
    manifest = {
        'lot': 'entree_grotte_fleurie_sud_nord_v1', 'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'recreation capture PMDO utilisateur : rendu genere 4:3 (grotte=magenta) + sol genere quilte + etalonnage par matiere + reduction par classe',
        'reference_da': 'reference/capture_pmdo_source.png (capture PMDO utilisateur, 637x471)',
        'raw_inputs': [{'file': f'source/entree_grotte_fleurie_sud_nord_v1/bruts/{n}', 'sha256': sha(RAW / n),
                        'size': list(Image.open(RAW / n).size)} for n in ['decor_magenta.png', 'sol_complet_genere.png', 'sol_complet.png', 'papillons_poses.png']],
        'normalization': {'scale': SCALE, 'scaled': [SCALED_W, H], 'crop_x': [CROP_X, SCALED_W - W - CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal, palette commune 96 couleurs'},
        'etalonnage': {'cibles': {k: list(v) for k, v in targets.items()}, 'stats': corr_stats,
                       'note': 'correction multiplicative par matiere vers la capture ; texture preservee'},
        'segmentation': 'grotte=magenta dilate 2px ; sentier=rose (r>200,b>130) ; ocre=falaises/brochers (b<140,r>g>b), '
                        'falaises=components touchant bord, rochers=components isoles 300-20000px ; buissons=vert sombre ; '
                        'fleurs=R/J/B sur herbe ; herbe=reste vert',
        'layer_order_bottom_to_top': order_files,
        'flowers': {'phases': FLOWER_PHASES, 'frame_length_ticks': FLOWER_TICKS, 'clusters': clusters,
                    'modele': 'cisaillement horizontal ancre au pied, amplitude 1.6px, 8 phases sinusoidales fermees',
                    'origine': 'pixels des fleurs du decor genere, mouvement cree par nous'},
        'butterflies': {'brut': 'source/entree_grotte_fleurie_sud_nord_v1/bruts/papillons_poses.png (reutilise EJN1)',
                        'poses_par_couleur': 6, 'phases': FLY_PHASES, 'frame_length_ticks': FLY_TICKS,
                        'loop_s': FLY_PHASES * FLY_TICKS / 60, 'trajectoires': tracks,
                        'origine': 'dessin GENERE (planche EJN1), trajectoires creees ; pas une animation officielle'},
        'cave': {'modele': 'remplissage procedural degrade sombre (haut 18,12,10 -> bas 132,92,60) + strates',
                 'origine': 'genere, pas une tuile native'},
        'water': None,
        'scene_loop_ticks': LOOP_TICKS,
        'fidelity': {'seuil': FIDELITY_MAX, 'mesures': fid},
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': ok, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors herbe/sentier/fleurs'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'fleurs_clusters': len(clusters), 'entry': entry_px, 'threshold': threshold_px,
                      'blocked': int(blocked.sum()), 'cells': int(blocked.size), 'tiles': counts,
                      'fidelite': {k: v['distance'] for k, v in fid.items()}}, indent=1, ensure_ascii=False))


if __name__ == '__main__':
    build()
