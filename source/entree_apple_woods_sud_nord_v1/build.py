"""Entrée Apple Woods / Bois aux Pommes sud -> nord V1 (EAW1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « go la suite ! » (suite de la série : nouveaux biomes Explorateurs du Ciel — Apple Woods `Apple_Woods_entrance_TDS.png`).
Référence `Apple_Woods_entrance_TDS.png` (552 x 408) : entrée de Bois aux Pommes / Apple Woods (Pokémon Donjon Mystère :
Explorateurs du Temps / de l'Ombre / du Ciel), sentier sablonneux ocre chaud, bordure d'herbe vert-jaune clair,
prairie d'herbe vert émeraude, rochers ocre, touffes de fleurs mauves, arbres feuillus et pommiers chargés de pommes rouges.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), arrivée au sud sur le sentier sablonneux ocre, clairière centrale ovale
  bordée de 4 rochers ocre et de fleurs mauves, arbres feuillus sur les flancs sud et verger de pommiers chargés de
  pommes rouges encadrant le passage nord ;
- temoin_sans_objets.png : même scène sans les arbres, pommiers, rochers ni fleurs (recalé (0, 0)) ;
- pommes_feuilles_poses.png : planche de 18 poses style PMD (6 pommes dont une Pomme Parfaite dorée, 6 feuilles de
  verger voletantes, 6 pétales et éclats de pollen doré) générée sur fond magenta pur #FF00FF.
Calques : sol complet, herbe, herbe claire, chemin, fleurs, rochers, arbres, pommiers.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- chute_pommes : pommes rouges et Pomme Parfaite dorée qui se détachent des pommiers, tombent et rebondissent au sol ;
- feuilles_eclats : feuilles de pommier voletantes et éclats de pollen doré dérivant au-dessus du sentier.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_apple_woods_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Apple_Woods_entrance_TDS.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_apple_woods_sud_nord_v1'
STAGE = R / '.cache/entree_apple_woods_sud_nord_v1/entree_apple_woods_sud_nord'
NAMESPACE = 'entree_apple_woods_sud_nord'
ASSET = 'eaw1_entree_apple_woods'
PFX = 'EAW1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_apple_woods_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'WIDE LANDSCAPE 4:3 (1200x896), zoomed out, top-down 3/4 Nintendo DS Pokemon Mystery Dungeon Explorers of Sky '
     'pixel art environment map of Apple Woods entrance (South to North passage), strictly matching the exact colors, '
     'pixel art textures, and palette of the reference image Apple_Woods_entrance_TDS.png. A warm sandy-ochre dirt '
     'path (#F1BC74) enters at the bottom center (south), widens into an oval central clearing in the middle, and '
     'continues straight north to exit at the top center (north) between dense apple trees. Along both edges of the '
     'sandy path is a wavy border of light yellow-green grass (#78BB47) dotted with tiny pink-purple flower bushes '
     'and 4 small tan boulders (#C89858) at the clearing corners. Surrounding the path on the left and right flanks '
     'are deep emerald-green grassy meadows (#426F2C) with round green broadleaf trees in the lower half and dense '
     'orchard groves of apple trees loaded with bright red apples (#C53E1F) in the upper half framing the northern '
     'passage. Crisp DS pixel art, no characters, no UI, no text, no water.',
     'essais': 'premier essai ; conforme (chemin 18.3, herbe_claire 8.8, herbe_feuillage 7.3, pommes 11.0)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png', REF_NAME], 'prompt':
     'Exact same 1200x896 top-down Nintendo DS Pokemon Mystery Dungeon Apple Woods entrance map as the first '
     'reference image, keeping the exact same sandy-ochre dirt path (#F1BC74), wavy light yellow-green grass border '
     '(#78BB47), and deep emerald-green meadow grass (#426F2C) in the exact same pixel positions, but with ALL trees, '
     'apple trees, boulders, flower bushes, and tree shadows completely removed and replaced seamlessly by the '
     'underlying emerald-green meadow grass (#426F2C) and light yellow-green border grass (#78BB47). Flat clean '
     'ground-only witness image, no trees, no boulders, no flowers, no characters.',
     'essais': 'premier essai ; recalage (0, 0) ecart 3.26'},
    {'file': 'pommes_feuilles_poses.png', 'images': [REF_NAME], 'prompt':
     '2D Nintendo DS Pokemon Mystery Dungeon Explorers of Sky pixel-art sprite sheet on a solid, uniform, flat pure '
     'magenta #FF00FF background (RGB 255, 0, 255) with NO anti-aliasing against the magenta background and NO '
     'magenta inside the sprites. Contains 18 well-separated orchard animation sprites inspired by '
     'Apple_Woods_entrance_TDS.png arranged in 3 clean rows with generous #FF00FF spacing: Row 1 (6 poses): bright '
     'red PMD apples (#D83820, #F86040, highlight #F8C8A8, green leaf #68C840, dark brown stem #583820) — upright '
     'whole apple, tilted falling apple left, tilted falling apple right, slightly squashed landing apple, apple with '
     'small dust puff, and golden Perfect Apple (#F8C838, #D89818). Row 2 (6 poses): fluttering emerald and lime '
     'orchard leaves (#488830, #78C048, #A8E068) — horizontal leaf, tilted 45 deg left, vertical spinning leaf, '
     'tilted 45 deg right, curled leaf, and twin small leaves. Row 3 (6 poses): small pink-white blossom petals and '
     'golden pollen sparkles (#F8B8D8, #F8E898) from tiny dot to 4-point star sparkle. Crisp 1-pixel stepped edges, '
     'no text, no grid lines.',
     'essais': 'premier essai ; 18 poses extraites sur fond magenta (6 pommes, 6 feuilles, 6 petales/eclats)'},
]

# Fenêtres (y0, y1, x0, x1, facteur de réduction k) sur pommes_feuilles_poses.png (1191 x 880).
POSE_BOXES = {
    'pomme_0': (56, 224, 32, 168, 8),
    'pomme_1': (56, 224, 204, 364, 8),
    'pomme_2': (56, 224, 428, 572, 8),
    'pomme_3': (56, 224, 628, 764, 8),
    'pomme_4': (56, 224, 808, 1000, 8),
    'pomme_5': (56, 224, 1028, 1164, 8),
    'feuille_0': (360, 520, 16, 184, 10),
    'feuille_1': (360, 520, 224, 364, 10),
    'feuille_2': (360, 520, 456, 546, 10),
    'feuille_3': (360, 520, 628, 768, 10),
    'feuille_4': (360, 520, 844, 964, 10),
    'feuille_5': (360, 520, 1028, 1168, 10),
    'eclat_0': (650, 820, 72, 122, 10),
    'eclat_1': (650, 820, 256, 346, 10),
    'eclat_2': (650, 820, 444, 554, 10),
    'eclat_3': (650, 820, 624, 774, 10),
    'eclat_4': (650, 820, 820, 980, 10),
    'eclat_5': (650, 820, 1024, 1174, 10),
}

PALETTE_GROUPS = {
    'terrain': (['sol_complet', 'herbe', 'herbe_claire', 'chemin'], 96),
    'fleurs_rochers': (['fleurs', 'rochers'], 64),
    'arbres': (['arbres'], 64),
    'pommiers': (['pommiers'], 96),
}
STATIC = ['herbe', 'herbe_claire', 'chemin', 'fleurs', 'rochers', 'arbres', 'pommiers']
ANIMS = ['chute_pommes', 'feuilles_eclats']


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
    """Même classifieur pixel sur le rip Apple_Woods_entrance_TDS.png et sur le décor généré :
    chemin (terre sablonneuse ocre), herbe_claire (bordure vert-jaune), herbe_feuillage (prairie et feuillage vert émeraude),
    pommes (pommes rouges dans les pommiers)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]
    mag = (r - g > 60) & (b - g > 60)
    chemin = (r > 200) & (g > 150) & (b > 95) & (r - b > 70) & (r > g + 25) & ~mag
    herbe_claire = ~chemin & (g > 140) & (r > 100) & (r < 185) & (g > r + 15) & (b < 120) & ~mag
    herbe_feuillage = ~chemin & ~herbe_claire & (g > 70) & (g <= 145) & (g > r + 15) & (b < 90) & ~mag
    pommes = (r > 165) & (g < 85) & (b < 75) & (r - g > 90) & ~mag
    return {'chemin': chemin, 'herbe_claire': herbe_claire, 'herbe_feuillage': herbe_feuillage, 'pommes': pommes}


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


def classify(a, t):
    """Segmentation pleine résolution (1200 x 896) à partir de decor.png (a) et temoin_sans_objets.png (t) :
    - chemin : sentier sablonneux ocre chaud du témoin (hors rochers et fleurs) ;
    - herbe_claire : bordure d'herbe vert-jaune clair le long du sentier (hors objets) ;
    - rochers : les rochers ocre bordant la clairière centrale, bloqués ;
    - fleurs : touffes de fleurs mauves et roses en bordure de sentier, praticables ;
    - pommiers : verger de pommiers chargés de pommes rouges encadrant le nord, bloqués ;
    - arbres : arbres feuillus verts et buissons de la moitié sud, bloqués ;
    - herbe : prairie d'herbe vert émeraude praticable."""
    af = a.astype(int); tf = t.astype(int)
    H0, W0, _ = af.shape
    yy, xx = np.mgrid[:H0, :W0]
    r, g, b = af.transpose(2, 0, 1)
    rt, gt, bt = tf.transpose(2, 0, 1)
    diff = np.abs(af - tf).max(2)

    chemin_t = (rt > 195) & (gt > 145) & (bt > 85) & (rt - bt > 65)
    herbe_claire_t = ~chemin_t & (gt > 138) & (rt > 95) & (bt < 125)

    sdev = nd.uniform_filter(r.astype(float) ** 2, 9) - nd.uniform_filter(r.astype(float), 9) ** 2
    rock_cand = (diff > 22) & (r > 90) & (g > 65) & (b < 140) & (r > g + 12) & ~((r > 165) & (g < 85)) & (yy > 180) & (yy < 780)
    rock_on_sand = chemin_t & ((diff > 26) | (sdev > 280)) & (yy > 240) & (yy < 600) & ((xx < 530) | (xx > 660))
    rochers0 = nd.binary_fill_holes(nd.binary_closing(rock_cand | rock_on_sand, iterations=2))
    lbl, n = nd.label(rochers0)
    rochers = np.zeros_like(rochers0)
    nb_rochers = 0
    for i in range(1, n + 1):
        m = lbl == i
        sz = int(m.sum())
        ys, xs = np.where(m)
        if 400 <= sz <= 25000 and ys.min() > 220 and 50 < xs.mean() < 1150:
            rochers |= m
            nb_rochers += 1

    fl_cand = ~rochers & (b > 110) & (r > 110) & (b > g - 15) & (diff > 18) & (yy > 10)
    fl_cand = nd.binary_dilation(fl_cand, iterations=2) & (diff > 14) & ~rochers
    lbl, n = nd.label(fl_cand)
    fleurs = np.zeros_like(fl_cand)
    nb_fleurs = 0
    for i in range(1, n + 1):
        m = lbl == i
        if 40 <= int(m.sum()) <= 2500:
            fleurs |= m
            nb_fleurs += 1

    veg_cand = (diff > 18) & ~rochers & ~fleurs & ~chemin_t
    veg_cand = nd.binary_fill_holes(nd.binary_closing(veg_cand, iterations=2)) & ~rochers & ~fleurs
    red_apple = (r > 165) & (g < 85) & (b < 75) & (r - g > 90)
    lbl, n = nd.label(veg_cand)
    pommiers = np.zeros_like(veg_cand)
    arbres = np.zeros_like(veg_cand)
    nb_pommiers, nb_arbres = 0, 0
    for i in range(1, n + 1):
        m = lbl == i
        if int(m.sum()) < 300:
            continue
        if int((m & red_apple).sum()) > 20 or np.where(m)[0].min() < 260:
            pommiers |= m
            nb_pommiers += 1
        else:
            arbres |= m
            nb_arbres += 1

    objs = rochers | fleurs | arbres | pommiers
    chemin = chemin_t & ~objs
    herbe_claire = herbe_claire_t & ~objs & ~chemin
    herbe = ~objs & ~chemin & ~herbe_claire

    m = {
        'pommiers': pommiers,
        'arbres': arbres,
        'rochers': rochers,
        'fleurs': fleurs,
        'chemin': chemin,
        'herbe_claire': herbe_claire,
        'herbe': herbe,
    }
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in m.items()}
    seg.update({'nb_rochers': nb_rochers, 'nb_fleurs': nb_fleurs, 'nb_arbres': nb_arbres, 'nb_pommiers': nb_pommiers})
    return m, seg


FALLING_APPLES = [
    # (x0, y_start, y_ground, is_golden, phase_offset)
    (248, 142, 214, False, 0),
    (524, 138, 210, False, 6),
    (176, 172, 236, True, 12),
    (592, 168, 232, False, 18),
]

LEAVES_SPOTS = [
    # (x0, y0, dx_amp, dy_step, phase_offset)
    (216, 108, 6, 3, 0),
    (548, 114, -6, 3, 4),
    (312, 192, 5, 2, 8),
    (462, 206, -5, 2, 12),
    (228, 352, 6, 2, 16),
    (540, 362, -6, 2, 20),
    (376, 276, 4, 2, 2),
    (392, 432, -4, 2, 10),
]

SPARK_SPOTS = [
    (330, 88, 0),
    (442, 152, 4),
    (326, 296, 8),
    (446, 304, 12),
    (332, 412, 16),
    (438, 488, 20),
]


def sprite_mask(crop):
    """Masque des pixels d'objets sur fond magenta pur #FF00FF (exclut le fond magenta et les éventuels halos)."""
    r, g, b = crop.transpose(2, 0, 1)
    return ~((r > 195) & (g < 85) & (b > 195)) & ~((r - g > 65) & (b - g > 65))


def sheet_poses(path):
    """Extrait et réduit les 18 poses de pommes, feuilles et éclats depuis pommes_feuilles_poses.png, quantifiées sur 16 couleurs."""
    src = rgb(path)
    all_px = []
    for box in POSE_BOXES.values():
        y0, y1, x0, x1, k = box
        crop = src[y0:y1, x0:x1]
        m = sprite_mask(crop)
        all_px.append(crop[m])
    px = np.concatenate(all_px, axis=0)
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=16, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:48], float).reshape(-1, 3)
    poses = {}
    for name, (y0, y1, x0, x1, k) in POSE_BOXES.items():
        h = ((y1 - y0) // k) * k
        w = ((x1 - x0) // k) * k
        crop = src[y0:y0 + h, x0:x0 + w]
        fg = sprite_mask(crop)
        nh, nw = h // k, w // k
        cov = fg.reshape(nh, k, nw, k).mean((1, 3))
        cov_min = 0.08 if name.startswith('eclat') else 0.15
        keep = cov >= cov_min
        out = np.zeros((nh, nw, 4), 'uint8')
        for y in range(nh):
            for x in range(nw):
                if keep[y, x]:
                    sub_fg = fg[y * k:(y + 1) * k, x * k:(x + 1) * k]
                    sub_px = crop[y * k:(y + 1) * k, x * k:(x + 1) * k][sub_fg]
                    med = np.median(sub_px, axis=0)
                    idx = int(np.argmin(np.linalg.norm(pal - med, axis=1)))
                    out[y, x, :3] = pal[idx].round().astype('uint8')
                    out[y, x, 3] = 255
        poses[name] = out
    return poses, pal.round().astype(int)


def paste_center(dst, spr, cx, cy, mirror=False):
    s = spr[:, ::-1] if mirror else spr
    sh, sw = s.shape[:2]
    y0, x0 = int(cy) - sh // 2, int(cx) - sw // 2
    sy0, sx0 = max(0, -y0), max(0, -x0)
    sy1, sx1 = min(sh, H - y0), min(sw, W - x0)
    if sy0 >= sy1 or sx0 >= sx1:
        return
    sub = s[sy0:sy1, sx0:sx1]
    m = sub[..., 3] == 255
    reg = dst[y0 + sy0:y0 + sy1, x0 + sx0:x0 + sx1]
    reg[m] = sub[m]


def chute_pommes_frames(poses, ts=range(PHASES)):
    """Chute et rebond des pommes rouges et de la Pomme Parfaite dorée (24 x 5 ticks, boucle fermée)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for x0, ys, yg, is_gold, p0 in FALLING_APPLES:
            dt = (tm - p0) % PHASES
            base_pose = 'pomme_5' if is_gold else 'pomme_0'
            if dt < 4:
                paste_center(fr, poses[base_pose], x0 + (dt % 2), ys)
            elif dt < 12:
                u = (dt - 4) / 8.0
                cy = int(round(ys + (yg - ys) * (u ** 1.35)))
                p = 'pomme_5' if is_gold else ('pomme_1' if dt % 2 == 0 else 'pomme_2')
                paste_center(fr, poses[p], x0, cy)
            elif dt in (12, 13):
                paste_center(fr, poses['pomme_4' if dt == 12 else 'pomme_3'], x0, yg)
            elif dt in (14, 15, 16):
                by = yg - (4 if dt == 15 else 2)
                paste_center(fr, poses[base_pose], x0 + 2, by)
            elif dt < 22:
                paste_center(fr, poses[base_pose], x0 + 3, yg)
        frames.append(fr)
    return frames


def feuilles_eclats_frames(poses, ts=range(PHASES)):
    """Feuilles de pommier voletantes et éclats de pollen doré (24 x 5 ticks, boucle fermée)."""
    frames = []
    leaf_seq = ['feuille_0', 'feuille_1', 'feuille_2', 'feuille_3', 'feuille_4', 'feuille_5']
    spark_seq = ['eclat_0', 'eclat_1', 'eclat_2', 'eclat_3', 'eclat_4', 'eclat_5']
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for x0, y0, dx_amp, dy_step, p0 in LEAVES_SPOTS:
            dt = (tm - p0) % PHASES
            if dt < 18:
                cx = x0 + int(round(dx_amp * np.sin(dt * np.pi / 6.0)))
                cy = y0 + dt * dy_step
                lp = poses[leaf_seq[dt % len(leaf_seq)]]
                paste_center(fr, lp, cx, cy, mirror=(dt % 4 >= 2))
        for sx, sy, p0 in SPARK_SPOTS:
            dt = (tm - p0) % 12
            if dt < 6:
                paste_center(fr, poses[spark_seq[dt]], sx, sy)
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
    o.update(Name={'DefaultText': 'Entree Apple Woods (Bois aux Pommes) - sud vers nord (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur Apple_Woods_entrance_TDS.png ; chute de pommes et '
                     'feuilles voletantes animees. Collisions de base a verifier. Seuil non raccorde.')
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
  <Name>Entree Apple Woods (Bois aux Pommes) sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee au sud dans le Bois aux Pommes, clairiere centrale, rochers ocre et verger de pommiers au nord (ref. Apple_Woods_entrance_TDS.png). Pas une aventure jouable.</Description>
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

    a, tm, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(REF)
    assert a.shape[:2] == tm.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, tm)
    reg = {'temoin_sans_objets': recalage(a, tm, nd.binary_erosion(m['chemin'] | m['herbe'], iterations=6))}

    order = ['pommiers', 'arbres', 'rochers', 'fleurs', 'chemin', 'herbe_claire', 'herbe']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(tm), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    cand = ex['chemin'] | ex['herbe_claire'] | ex['herbe'] | ex['fleurs']
    cl, _ = nd.label(cand)
    seed = cl[H - 1, np.nonzero(cand[H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    poses, pose_pal = sheet_poses(RAW / 'pommes_feuilles_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    anim = {'chute_pommes': chute_pommes_frames(poses), 'feuilles_eclats': feuilles_eclats_frames(poses)}

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
    blocked[0, :] = True
    blocked[:, 0] = True
    blocked[:, -1] = True
    gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    threshold_px = [376, 16]
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

    names = list(POSE_BOXES)
    cw, ch = 96, 96
    sheet = Image.new('RGBA', (6 * cw + 8, 3 * ch + 8), (38, 56, 38, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm])
        im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * ch
        sheet.alpha_composite(im, (cx0 + max(0, (cw - 8 - im.width) // 2), cy0 + max(0, (ch - 8 - im.height) // 2)))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(OUT / f'{PFX}_entree_apple_woods_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('chemin', 'chemin'), ('herbe_claire', 'herbe_claire'), ('herbe_feuillage', 'herbe'), ('pommes', 'pommiers')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'entree_apple_woods_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Apple Woods / Bois aux Pommes (Explorateurs du Ciel), sentier sablonneux ocre, herbe emeraude et verger de pommiers',
        'method': 'textures canoniques = rendu genere REFERENCE : rip Apple_Woods_entrance_TDS.png passe au generateur ; '
                  'decor complet et temoin sans objets edites et recales (0, 0)',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Apple Woods / Bois aux Pommes (Pokemon Donjon Mystere : Explorateurs du Ciel, Apple_Woods_entrance_TDS.png)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': False} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin sans objets : chemin et herbe erodes de 6 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'chute_pommes': {'phases': PHASES, 'frame_length_ticks': TICKS,
                         'poses': {k: list(v) for k, v in POSE_BOXES.items() if k.startswith('pomme')},
                         'palette': [[int(v) for v in c] for c in pose_pal],
                         'chutes': [list(c) for c in FALLING_APPLES],
                         'origine': 'pommes rouges et Pomme Parfaite doree style PMD generees sur fond magenta (pommes_feuilles_poses.png)'},
        'feuilles_eclats': {'phases': PHASES, 'frame_length_ticks': TICKS,
                            'poses': {k: list(v) for k, v in POSE_BOXES.items() if not k.startswith('pomme')},
                            'palette': [[int(v) for v in c] for c in pose_pal],
                            'feuilles': [list(f) for f in LEAVES_SPOTS],
                            'eclats': [list(s) for s in SPARK_SPOTS],
                            'origine': 'feuilles de pommier voletantes et eclats de pollen dore generes sur fond magenta (pommes_feuilles_poses.png)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (chemin, herbe_claire, herbe, fleurs)',
                   'seuil': 'case 2 x 2 libre dans le sentier nord entre les pommiers'},
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
