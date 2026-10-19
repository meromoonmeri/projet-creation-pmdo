"""Fin Amp Plains / Plaine Électrik V1 (FAM1) — arène de boss au cœur de la Plaine Électrik — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « tous » (suite de la série : nouveaux biomes Explorateurs du Ciel — Amp Plains `Amp_Plains_entrance_TD.png`).
Référence `Amp_Plains_entrance_TD.png` (456 x 408) : Plaine Électrik / Amp Plains (Pokémon Donjon Mystère :
Explorateurs du Temps / de l'Ombre / du Ciel), herbe jaune-olive de savane à brins fins, falaises et rochers gris-ardoise
fracturés, et arbres morts noirs tortueux foudroyés.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), arrivée au sud par un goulet rocheux dans une vaste arène circulaire
  d'herbe jaune-olive entièrement ceinturée de falaises d'ardoise fracturées (nord, ouest, est et flancs sud fermés,
  aucune sortie), avec 2 arbres morts foudroyés et 11 rochers d'ardoise sur les bords, et un monolithe / autel de
  foudre à degrés au nord-centre contre la paroi rocheuse ;
- temoin_sans_objets.png : même scène sans les 2 arbres morts, sans les rochers et cailloux isolés de l'arène, et
  sans l'autel de foudre au nord-centre (recalé (0, 0)) ;
- electricite_poses.png : planche de poses d'électricité style PMD (éclairs fourchus, arches et couronnes électriques
  autour de l'autel, étoiles d'étincelles en 6 phases) générée sur fond magenta pur #FF00FF avec la planche d'éclairs
  de Mt. Thunder et Amp_Plains_entrance_TD.png en référence.
Calques : sol complet, herbe, herbe sombre, cailloux, rochers, arbres morts, autel de foudre, falaises claires,
falaises sombres.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- foudre_autel : éclairs fourchus, arches et couronnes électriques générés (poses de electricite_poses.png) qui
  frappent et enveloppent le monolithe de foudre au nord et les 2 arbres morts ;
- etincelles : étoiles d'étincelles statiques générées (6 poses de electricite_poses.png) qui éclatent au-dessus de l'arène.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Marqueurs : entrance (sud), boss (centre de l'arène), objectif (au pied de l'autel de foudre au nord). Aucun warp,
aucun donjon_seuil, aucune sortie.
Lancer : .venv/bin/python source/fin_amp_plains_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Amp_Plains_entrance_TD.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_amp_plains_v1'
STAGE = R / '.cache/fin_amp_plains_v1/fin_amp_plains'
NAMESPACE = 'fin_amp_plains'
ASSET = 'fam1_fin_amp_plains'
PFX = 'FAM1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_amp_plains_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon '
     'Explorers of Sky, Amp Plains / Plaine Electrik): same muted olive-yellow savanna grass (#8A916E) with fine '
     'vertical blade texture, same cool slate-grey fractured rock cliffs and boulders (#86939C highlights, #4F5359 '
     'shadows), same dark gnarled lightning-struck dead trees (#484B52). Make a NEW, larger top-down dungeon boss '
     'room map at the heart of Amp Plains. WIDE LANDSCAPE 4:3 (1200x896), zoomed out so the arena feels vast. Layout: '
     'the player arrives at the SOUTH (bottom edge center) through a narrow gorge between slate-grey rock cliffs; the '
     'gorge opens into a wide circular olive-yellow savanna grass boss arena completely enclosed on the LEFT, RIGHT, '
     'NORTH and bottom-sides by continuous massive fractured slate-grey rock cliff walls (NO northern canyon gap, NO '
     'exit at the top); on the left and right edges of the grass arena stand gnarled dark dead trees and slate-grey '
     'boulders (leaving the center of the grass arena completely open); at the north-center, against the solid '
     'slate-grey cliff wall, stands a prominent stepped slate-stone thunder monolith / altar platform. No characters, '
     'no text, no UI, no border.',
     'essais': 'premier essai ; conforme (herbe 1.6, roche_claire 8.1, roche_sombre 10.2)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Same image, same framing and pixel-art style (1200x896), but remove the 2 dark gnarled dead trees, all isolated '
     'slate-grey boulders and small pebbles inside the grass arena, and the stepped slate-stone thunder monolith '
     'altar at the top-center, replacing them seamlessly with the surrounding olive-yellow savanna grass (#8A916E) '
     'and the background northern cliff wall; keep the outer slate-grey rock cliff walls and the grass arena at the '
     'exact same pixel positions. No characters, no text, no UI, no border.',
     'essais': 'premier essai ; recalage (0, 0) ecart 3.04'},
    {'file': 'electricite_poses.png',
     'images': ['Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png', REF_NAME],
     'prompt':
     'Pixel-art sprite sheet on a flat solid pure magenta #FF00FF background, in the EXACT pixel-art style and palette '
     'of Pokemon Mystery Dungeon (Red Rescue Team Mt. Thunder lightning bolts and Explorers of Sky Amp Plains): crisp '
     'hard 1-pixel edges, no anti-aliasing, no soft glow, no magenta halos. Arrange 18 well-separated electric effect '
     'sprites in a clean 3 rows by 6 columns grid on pure #FF00FF magenta: Row 1 (top, 6 sprites): large dramatic '
     'forked yellow and white-yellow lightning bolts striking downward with jagged side branches (#F8F800 bright '
     'yellow, #F8F898 pale yellow-white, #989820 dark gold fading tone, like bolts 1-4 of the first reference). Row 2 '
     '(middle, 6 sprites): arched electric corona discharges, crescent ground flash arcs, and jagged electric rings '
     'that crackle around a stone monolith altar (#F8F800 and #F8F898). Row 3 (bottom, 6 sprites): small crackling '
     'electric spark stars and static electricity bursts in 6 animation poses from small pinpoint to star burst to '
     'scattered spark dots. Well spaced, nothing touching, no background scenery, no text, no numbers, no border.',
     'essais': 'premier essai ; 19 poses extraites sur fond magenta (6 eclairs fourchus, 3 arches d autel, 4 couronnes electriques, 6 poses d etincelles)'},
]

# Fenêtres (y0, y1, x0, x1, facteur de réduction k) sur electricite_poses.png (960 x 1107).
POSE_BOXES = {
    'eclair_0': (24, 432, 28, 136, 4),
    'eclair_1': (24, 432, 188, 296, 4),
    'eclair_2': (24, 432, 352, 460, 4),
    'eclair_3': (24, 432, 500, 608, 4),
    'eclair_4': (24, 432, 664, 772, 4),
    'eclair_5': (24, 432, 818, 926, 4),
    'arc_0': (440, 624, 20, 300, 4),
    'arc_1': (440, 624, 344, 624, 4),
    'arc_2': (480, 624, 680, 920, 4),
    'couronne_0': (696, 888, 16, 260, 4),
    'couronne_1': (704, 896, 272, 472, 4),
    'couronne_2': (696, 896, 488, 700, 4),
    'couronne_3': (676, 908, 712, 952, 4),
    'etincelle_0': (960, 1105, 15, 155, 5),
    'etincelle_1': (960, 1105, 170, 310, 5),
    'etincelle_2': (960, 1105, 330, 470, 5),
    'etincelle_3': (960, 1105, 490, 630, 5),
    'etincelle_4': (960, 1105, 655, 795, 5),
    'etincelle_5': (960, 1105, 810, 955, 5),
}

PALETTE_GROUPS = {
    'herbe': (['sol_complet', 'herbe', 'herbe_sombres'], 96),
    'rochers_autel': (['cailloux', 'rochers', 'autel_foudre'], 96),
    'arbres_morts': (['arbres_morts'], 48),
    'falaises': (['falaises_claires', 'falaises_sombres'], 96),
}
STATIC = ['herbe', 'herbe_sombres', 'cailloux', 'rochers', 'arbres_morts', 'autel_foudre', 'falaises_claires', 'falaises_sombres']
ANIMS = ['foudre_autel', 'etincelles']


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
    """Même classifieur pixel sur le rip Amp_Plains_entrance_TD.png et sur le décor généré :
    herbe (savane jaune-olive), roche_claire (faces d'ardoise éclairées), roche_sombre (ombres d'ardoise et bois mort)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    mag = (r - g > 60) & (b - g > 60)
    herbe = (g >= r - 2) & (r > b + 10) & (g > b + 16) & (lum >= 85) & (lum <= 190) & ~mag
    roche_claire = (b >= r - 6) & (b >= g - 6) & (lum >= 115) & (lum <= 195) & ~herbe & ~mag
    roche_sombre = (b >= r - 6) & (b >= g - 6) & (lum >= 45) & (lum < 115) & ~herbe & ~mag
    return {'herbe': herbe, 'roche_claire': roche_claire, 'roche_sombre': roche_sombre}


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
    - autel_foudre : monolithe / autel de pierre d'ardoise à degrés au nord-centre (20 <= y <= 278, 475 <= x <= 725) ;
    - objets de l'arène = écart décor / témoin > 22 dans la zone d'herbe du témoin (hors pixels restés herbe) :
      * cailloux : petites pierres (< 650 px), praticables ;
      * arbres_morts : les 2 arbres morts foudroyés sur les flancs (taux de remplissage < 0.42), bloqués ;
      * rochers : les 11 blocs rocheux gris-ardoise (>= 650 px, taux >= 0.42), bloqués ;
    - falaises_claires et falaises_sombres : parois rocheuses d'ardoise fermant le nord, l'ouest, l'est et les flancs
      sud, séparées à lum = 115 ;
    - herbe et herbe_sombres : arène de savane jaune-olive praticable, séparée à lum = 128."""
    af = a.astype(int); tf = t.astype(int)
    r, g, b = af.transpose(2, 0, 1); lum = lum_of(af)
    rt, gt, bt = tf.transpose(2, 0, 1); lumt = lum_of(tf)
    diff = np.abs(af - tf).max(2)
    yy, xx = np.mgrid[:af.shape[0], :af.shape[1]]

    herbe_t = (gt >= rt - 2) & (rt > bt + 8) & (gt > bt + 14) & (lumt >= 75) & (lumt <= 195)
    hl, _ = nd.label(herbe_t)
    main_id = hl[450, 600]
    herbe_zone = (hl == main_id)

    autel_box = (yy >= 20) & (yy <= 278) & (xx >= 475) & (xx <= 725)
    obj_raw = (diff > 22) & (herbe_zone | autel_box) & ~((g >= r - 1) & (r > b + 12) & (g > b + 18) & (lum >= 105))
    ol, _ = nd.label(obj_raw)
    autel_foudre = np.zeros_like(obj_raw)
    arbres_morts = np.zeros_like(obj_raw)
    rochers = np.zeros_like(obj_raw)
    cailloux = np.zeros_like(obj_raw)
    n_trees, n_boulders, n_pebbles = 0, 0, 0
    for i, sl in enumerate(nd.find_objects(ol), 1):
        comp = (ol == i)
        sz = int(comp.sum())
        if sz < 20:
            continue
        if sl[0].start < 150 and 450 < sl[1].start < 700 and sz > 5000:
            autel_foudre |= comp
        elif sz < 650:
            cailloux |= comp
            n_pebbles += 1
        else:
            h, w = sl[0].stop - sl[0].start, sl[1].stop - sl[1].start
            fill_ratio = sz / float(h * w)
            if fill_ratio < 0.42:
                arbres_morts |= comp
                n_trees += 1
            else:
                rochers |= comp
                n_boulders += 1

    falaises = ~herbe_zone & ~(autel_foudre | arbres_morts | rochers | cailloux)
    falaises_claires = falaises & (lum >= 115)
    falaises_sombres = falaises & ~falaises_claires

    rem_herbe = herbe_zone & ~(autel_foudre | arbres_morts | rochers | cailloux)
    herbe_sombres = rem_herbe & (lum < 128)
    herbe = rem_herbe & ~herbe_sombres

    m = {
        'autel_foudre': autel_foudre,
        'arbres_morts': arbres_morts,
        'rochers': rochers,
        'cailloux': cailloux,
        'falaises_claires': falaises_claires,
        'falaises_sombres': falaises_sombres,
        'herbe_sombres': herbe_sombres,
        'herbe': herbe,
    }
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in m.items()}
    seg.update({'nb_arbres_morts': n_trees, 'nb_rochers': n_boulders, 'nb_cailloux': n_pebbles})
    return m, seg


# Impacts de foudre sur l'autel nord (cx=383, cy=118) et les 2 arbres morts (cx=632, cy=253 ; cx=122, cy=346).
ALTAR_RING_SEQ = [
    'arc_0', 'arc_1', 'couronne_2', 'couronne_3', 'couronne_0', 'arc_2',
    'arc_0', 'arc_1', 'couronne_1', 'couronne_2', 'couronne_3', 'arc_2',
]
FOUDRE_STRIKES = [
    # (cx, cy_base, eclair_vif, eclair_fade, arc_pose, mirror, phase_offset)
    (383, 108, 'eclair_3', 'eclair_5', 'arc_0', False, 0),
    (632, 258, 'eclair_4', 'eclair_5', 'arc_2', True, 20),
    (342, 122, 'eclair_0', 'eclair_2', 'couronne_0', False, 8),
    (122, 352, 'eclair_3', 'eclair_5', 'arc_2', False, 22),
    (424, 122, 'eclair_1', 'eclair_2', 'couronne_1', True, 14),
    (383, 104, 'eclair_4', 'eclair_5', 'arc_1', True, 12),
]

SPARK_SITES = [
    # (cx, cy, phase_offset, mirror)
    (240, 210, 0, False),
    (528, 210, 2, True),
    (384, 290, 4, False),
    (230, 340, 6, True),
    (538, 340, 8, False),
    (384, 195, 10, True),
    (310, 250, 12, False),
    (458, 250, 14, True),
    (280, 395, 16, False),
    (488, 395, 18, True),
    (326, 152, 20, False),
    (442, 152, 22, True),
]


def elec_mask(crop):
    """Masque des pixels d'électricité jaune / blanc-doré / or-olive sur fond magenta (exclut le fond magenta et le
    monolithe gris au centre des vignettes d'arche)."""
    r, g, b = crop.transpose(2, 0, 1)
    return (r > 105) & (g > 95) & (b < g + 20) & ((r - b > 35) | ((r > 210) & (g > 210) & (b > 120)))


def sheet_poses(path):
    """Extrait et réduit les 19 poses d'électricité PMD depuis electricite_poses.png, quantifiées sur 12 couleurs."""
    src = rgb(path)
    all_px = []
    for box in POSE_BOXES.values():
        y0, y1, x0, x1, k = box
        crop = src[y0:y1, x0:x1]
        m = elec_mask(crop)
        all_px.append(crop[m])
    px = np.concatenate(all_px, axis=0)
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=12, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:36], float).reshape(-1, 3)
    poses = {}
    for name, (y0, y1, x0, x1, k) in POSE_BOXES.items():
        h = ((y1 - y0) // k) * k
        w = ((x1 - x0) // k) * k
        crop = src[y0:y0 + h, x0:x0 + w]
        fg = elec_mask(crop)
        nh, nw = h // k, w // k
        cov = fg.reshape(nh, k, nw, k).mean((1, 3))
        cov_min = 0.08 if name.startswith('etincelle') else 0.16
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


def foudre_frames(poses, ts=range(PHASES)):
    """Éclairs fourchus, arches et couronnes électriques générés sur le monolithe nord et les arbres morts (24 x 5 ticks)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        # Couronne / arche électrique permanente qui pulse autour de l'autel de foudre (cx=383, cy=118) :
        ring_pose = ALTAR_RING_SEQ[(tm // 2) % len(ALTAR_RING_SEQ)]
        paste_center(fr, poses[ring_pose], 383, 118, mirror=(tm % 4 >= 2))
        for cx, cy, b_vif, b_fade, a_pose, mir, p0 in FOUDRE_STRIKES:
            dt = (tm - p0) % PHASES
            if dt in (0, 1):
                paste_center(fr, poses[a_pose], cx, cy + 8, mir)
                paste_center(fr, poses[b_vif], cx, cy - poses[b_vif].shape[0] // 2 + 12, mir)
            elif dt in (2, 3):
                paste_center(fr, poses[a_pose], cx, cy + 8, not mir)
                paste_center(fr, poses[b_fade], cx, cy - poses[b_fade].shape[0] // 2 + 12, mir)
            elif dt in (4, 5):
                paste_center(fr, poses['arc_2'], cx, cy + 6, mir)
        frames.append(fr)
    return frames


def etincelles_frames(poses, ts=range(PHASES)):
    """Étoiles d'étincelles statiques générées en 6 poses (24 x 5 ticks, boucle fermée)."""
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        tm = t % PHASES
        for cx, cy, p0, mir in SPARK_SITES:
            dt = (tm - p0) % 12
            if dt < 6:
                paste_center(fr, poses[f'etincelle_{dt}'], cx, cy, mir)
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
    o.update(Name={'DefaultText': 'Fin Amp Plains (Plaine Electrik) - arene de foudre (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon Amp Plains / Plaine Electrik 4:3 referencee sur Amp_Plains_entrance_TD.png ; '
                     'foudre sur l autel et etincelles statiques animees. Marqueurs entrance, boss, objectif. Aucun warp, '
                     'aucune sortie.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : fin de donjon Amp Plains, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Amp Plains (Plaine Electrik) 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arene de boss au coeur d'Amp Plains (Plaine Electrik), monolithe de foudre au nord, rochers d'ardoise et arbres morts foudroyes (ref. Amp_Plains_entrance_TD.png). Pas une aventure jouable.</Description>
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
    reg = {'temoin_sans_objets': recalage(a, tm, nd.binary_erosion(m['herbe'], iterations=6))}

    order = ['autel_foudre', 'arbres_morts', 'rochers', 'cailloux', 'falaises_claires', 'falaises_sombres', 'herbe_sombres', 'herbe']
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

    cand = ex['herbe'] | ex['herbe_sombres'] | ex['cailloux']
    cl, _ = nd.label(cand)
    seed = cl[H - 1, np.nonzero(cand[H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    poses, pose_pal = sheet_poses(RAW / 'electricite_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    anim = {'foudre_autel': foudre_frames(poses), 'etincelles': etincelles_frames(poses)}

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
    boss_px = [376, 288]
    objectif_px = [376, 184]
    while blocked[objectif_px[1] // 8:objectif_px[1] // 8 + 2, objectif_px[0] // 8:objectif_px[0] // 8 + 2].any():
        objectif_px[1] += 8
    reach_boss, exp_boss = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_obj, exp_obj = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_boss and reach_obj, 'pas de chemin 16x16 vers boss ou objectif'

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 90, 90, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    # Planche de revue des poses d'électricité PMD générées :
    names = list(POSE_BOXES)
    cw, ch = 150, 215
    sheet = Image.new('RGBA', (7 * cw + 8, 3 * ch + 8), (62, 68, 76, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm])
        im = im.resize((im.width * 2, im.height * 2), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 7) * cw, 8 + (i // 7) * ch
        sheet.alpha_composite(im, (cx0 + max(0, (cw - 8 - im.width) // 2), cy0 + max(0, (ch - 8 - im.height) // 2)))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(OUT / f'{PFX}_fin_amp_plains_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('roche_claire', 'falaises_claires'), ('roche_sombre', 'falaises_sombres')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'fin_amp_plains_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Amp Plains / Plaine Electrik (Explorateurs du Ciel), arene de boss au coeur de la plaine, autel de foudre au nord',
        'method': 'textures canoniques = rendu genere REFERENCE : rip Amp_Plains_entrance_TD.png passe au generateur ; '
                  'decor complet et temoin sans objets edites et recales (0, 0)',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Amp Plains / Plaine Electrik (Pokemon Donjon Mystere : Explorateurs du Ciel, Amp_Plains_entrance_TD.png)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size), 'ecarte': False} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin sans objets : herbe de l arene erodee de 6 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list,
        'foudre_autel': {'phases': PHASES, 'frame_length_ticks': TICKS,
                         'poses': {k: list(v) for k, v in POSE_BOXES.items() if not k.startswith('etincelle')},
                         'palette': [[int(v) for v in c] for c in pose_pal],
                         'impacts': [list(c) for c in FOUDRE_STRIKES],
                         'couronne_sequence': ALTAR_RING_SEQ,
                         'origine': 'eclairs fourchus, arches et couronnes electriques style PMD generes sur fond magenta (electricite_poses.png, ref. Mt. Thunder et Amp Plains)'},
        'etincelles': {'phases': PHASES, 'frame_length_ticks': TICKS,
                       'poses': {k: list(v) for k, v in POSE_BOXES.items() if k.startswith('etincelle')},
                       'palette': [[int(v) for v in c] for c in pose_pal],
                       'sites': [list(f) for f in SPARK_SITES],
                       'origine': 'etoiles d etincelles statiques style PMD en 6 poses generees sur fond magenta (electricite_poses.png)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'path_found_16x16': bool(reach_boss and reach_obj), 'cells_explored': exp_boss,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe, herbe_sombres, cailloux)',
                   'sortie': 'aucune (fin de donjon, bords N/O/E/S fermes hors arrivee sud)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
