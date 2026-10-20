"""Fin de donjon Apple Woods / Bois aux Pommes V1 (FAW1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « go la suite ! » (suite de la série : fin de donjon Apple Woods `Apple_Woods_entrance_TDS.png`).
Référence `Apple_Woods_entrance_TDS.png` (552 x 408) : Bois aux Pommes / Apple Woods (Pokémon Donjon Mystère :
Explorateurs du Temps / de l'Ombre / du Ciel), sentier sablonneux ocre chaud, bordure d'herbe vert-jaune clair,
prairie d'herbe vert émeraude, rochers ocre, touffes de fleurs mauves, arbres feuillus et pommiers chargés de pommes.
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), arrivée au sud sur le sentier ocre, grande arène circulaire sablonneuse
  au centre (`boss`), fermée au nord et sur les flancs par un hémicycle de pommiers chargés de pommes rouges et au
  nord-centre par le Grand Pommier Ancestral à racines noueuses et socle de pierre moussue (`autel_pommier`, `objectif`) ;
- temoin_sans_objets.png : même scène sans les arbres, le Grand Pommier Ancestral, le socle, les rochers ni les fleurs (recalé (0, 0)) ;
- pommes_feuilles_poses.png : planche de 18 poses style PMD (6 pommes dont une Pomme Parfaite dorée, 6 feuilles de
  verger voletantes, 6 pétales et éclats de pollen doré) générée sur fond magenta pur #FF00FF.
Calques : sol complet, herbe, herbe claire, chemin, fleurs, rochers, arbres, pommiers, autel_pommier.
Animations, chacune sur son calque, boucles fermées, 24 x 5 = 120 ticks :
- chute_pommes : pommes rouges et Pommes Parfaites dorées qui se détachent du Grand Pommier Ancestral et des pommiers,
  tombent et rebondissent au sol ;
- feuilles_eclats : feuilles de pommier voletantes et éclats de pollen doré dérivant autour de l'arène et du socle.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_apple_woods_v1/build.py
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
OUT = R / 'renders/fin_apple_woods_v1'
STAGE = R / '.cache/fin_apple_woods_v1/fin_apple_woods'
NAMESPACE = 'fin_apple_woods'
ASSET = 'faw1_fin_apple_woods'
PFX = 'FAW1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_apple_woods_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'WIDE LANDSCAPE 4:3 (1200x896), zoomed out, top-down 3/4 Nintendo DS Pokemon Mystery Dungeon Explorers of Sky '
     'pixel art environment map of the deep Apple Woods sanctuary clearing (closed northern cul-de-sac), strictly '
     'matching the exact colors, pixel art textures, and palette of the reference image Apple_Woods_entrance_TDS.png. '
     'A warm sandy-ochre dirt path (#F1BC74) enters at the bottom center (south) between green trees and opens into '
     'a large circular sandy-ochre clearing in the center, bordered by wavy light yellow-green grass (#78BB47), small '
     'pink-purple flower bushes, and 6 tan boulders (#C89858). The entire top (north), left, and right sides are '
     'completely closed by a dense semicircle of lush emerald-green orchard trees (#426F2C) heavily laden with bright '
     'red apples (#C53E1F) — NO northern exit path, NO dark cave hole. At the north-center edge of the clearing, '
     'nestled directly in front of the closed northern wall of apple-laden trees, stands one grand ancient giant '
     'Apple Tree with thick gnarled roots, a mossy stone pedestal at its base, and clusters of golden and bright red '
     'Perfect Apples in its crown. Crisp DS pixel art, no characters, no UI, no text.',
     'essais': 'premier essai ; conforme (chemin 8.3, herbe_claire 4.5, herbe_feuillage 7.9, pommes 11.1)'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png', REF_NAME], 'prompt':
     'Exact same 1200x896 top-down Nintendo DS Pokemon Mystery Dungeon Apple Woods sanctuary clearing map as the '
     'first reference image, keeping the exact same sandy-ochre dirt path and circular central clearing (#F1BC74), '
     'wavy light yellow-green grass border (#78BB47), and deep emerald-green meadow grass (#426F2C) in the exact '
     'same pixel positions, with the northern edge completely covered in emerald-green meadow grass (#426F2C), and '
     'with ALL trees, the giant central apple tree, stone pedestal, boulders, bushes, and flowers completely removed '
     'and replaced seamlessly by the underlying emerald-green meadow grass (#426F2C) and sandy-ochre clearing '
     '(#F1BC74). Flat clean ground-only witness image, no trees, no pedestal, no boulders, no flowers.',
     'essais': 'premier essai ; recalage (0, 0) ecart 3.56'},
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

PALETTE_GROUPS = {
    'terrain': (['sol_complet', 'herbe', 'herbe_claire', 'chemin'], 96),
    'fleurs_rochers': (['fleurs', 'rochers'], 64),
    'arbres': (['arbres'], 64),
    'pommiers_autel': (['pommiers', 'autel_pommier'], 96),
}
STATIC = ['herbe', 'herbe_claire', 'chemin', 'fleurs', 'rochers', 'arbres', 'pommiers', 'autel_pommier']
ANIMS = ['chute_pommes', 'feuilles_eclats']


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


EAW1 = loadmod('eaw1_build', R / 'source/entree_apple_woods_sud_nord_v1/build.py')
V1 = EAW1.V1
JM = EAW1.JM
POSE_BOXES = EAW1.POSE_BOXES
sha, rgb, lum_of, materials, fidelity, recalage = EAW1.sha, EAW1.rgb, EAW1.lum_of, EAW1.materials, EAW1.fidelity, EAW1.recalage
sheet_poses, paste_center, write_ora = EAW1.sheet_poses, EAW1.paste_center, EAW1.write_ora
cell_grid, down_class, down_full, rgba, quantize_group = V1.cell_grid, V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def classify(a, t):
    """Segmentation pleine résolution (1200 x 896) à partir de decor.png (a) et temoin_sans_objets.png (t) :
    - autel_pommier : Grand Pommier Ancestral à pommes d'or et rouges et son socle de pierre moussue au nord-centre, bloqué ;
    - chemin : sentier sablonneux ocre et grande arène circulaire centrale du témoin (hors objets) ;
    - herbe_claire : bordure d'herbe vert-jaune clair autour de l'arène et du sentier (hors objets) ;
    - rochers : les rochers ocre bordant l'arène et la lisière, bloqués ;
    - fleurs : touffes de fleurs mauves et roses en bordure de sentier, praticables ;
    - pommiers : verger de pommiers chargés de pommes rouges fermant le nord, bloqués ;
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
    rock_cand = (diff > 22) & (r > 90) & (g > 65) & (b < 140) & (r > g + 12) & ~((r > 165) & (g < 85)) & (yy > 220) & (yy < 780)
    rock_on_sand = chemin_t & ((diff > 26) | (sdev > 280)) & (yy > 260) & (yy < 600) & ((xx < 520) | (xx > 680))
    rochers0 = nd.binary_fill_holes(nd.binary_closing(rock_cand | rock_on_sand, iterations=2))
    lbl, n = nd.label(rochers0)
    rochers = np.zeros_like(rochers0)
    nb_rochers = 0
    for i in range(1, n + 1):
        m = lbl == i
        sz = int(m.sum())
        ys, xs = np.where(m)
        if 400 <= sz <= 25000 and ys.min() > 220 and 50 < xs.mean() < 1150:
            if ys.max() < 410 and 450 < xs.mean() < 750:
                continue
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

    giant_box = (xx >= 410) & (xx <= 790) & (yy <= 395)
    autel_pommier = giant_box & (diff > 18) & ~rochers & ~fleurs
    autel_pommier = nd.binary_fill_holes(nd.binary_closing(autel_pommier, iterations=2)) & ~rochers & ~fleurs

    veg_cand = (diff > 18) & ~rochers & ~fleurs & ~autel_pommier & ~chemin_t
    veg_cand = nd.binary_fill_holes(nd.binary_closing(veg_cand, iterations=2)) & ~rochers & ~fleurs & ~autel_pommier
    # Enforce closed northern tree border at y < 48
    veg_cand[:48, :] = True
    veg_cand[:48, :][autel_pommier[:48, :]] = False

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

    objs = autel_pommier | pommiers | arbres | rochers | fleurs
    chemin = chemin_t & ~objs
    herbe_claire = herbe_claire_t & ~objs & ~chemin
    herbe = ~objs & ~chemin & ~herbe_claire

    m = {
        'autel_pommier': autel_pommier,
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
    (348, 128, 224, True, 0),
    (420, 124, 220, True, 8),
    (212, 148, 222, False, 4),
    (556, 144, 218, False, 16),
]

LEAVES_SPOTS = [
    # (x0, y0, dx_amp, dy_step, phase_offset)
    (332, 118, 6, 3, 0),
    (438, 122, -6, 3, 4),
    (216, 156, 5, 2, 8),
    (552, 164, -5, 2, 12),
    (286, 268, 6, 2, 16),
    (482, 276, -6, 2, 20),
    (376, 320, 4, 2, 2),
    (392, 438, -4, 2, 10),
]

SPARK_SPOTS = [
    (384, 216, 0),
    (342, 232, 4),
    (426, 232, 8),
    (326, 312, 12),
    (442, 316, 16),
    (384, 412, 20),
]


def chute_pommes_frames(poses, ts=range(PHASES)):
    """Chute et rebond de Pommes Parfaites dorées et pommes rouges (24 x 5 ticks, boucle fermée)."""
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
    """Feuilles de pommier voletantes et éclats de pollen doré autour du socle et de l'arène (24 x 5 ticks, boucle fermée)."""
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
    o.update(Name={'DefaultText': 'Fin Apple Woods (Bois aux Pommes) - Sanctuaire du Grand Pommier (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur Apple_Woods_entrance_TDS.png ; chute de Pommes '
                     'Parfaites et feuilles voletantes animees. Fin de donjon sans sortie.')
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
             f'-- {ASSET} : fin de donjon Apple Woods, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Apple Woods (Bois aux Pommes) 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : clairiere de boss au coeur du Bois aux Pommes, Grand Pommier Ancestral et socle moussu au nord (ref. Apple_Woods_entrance_TDS.png). Pas une aventure jouable.</Description>
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

    order = ['autel_pommier', 'pommiers', 'arbres', 'rochers', 'fleurs', 'chemin', 'herbe_claire', 'herbe']
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
    boss_px = [376, 304]
    objectif_px = [376, 224]
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

    names = list(POSE_BOXES)
    cw, ch = 96, 96
    sheet = Image.new('RGBA', (6 * cw + 8, 3 * ch + 8), (38, 56, 38, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm])
        im = im.resize((im.width * 3, im.height * 3), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * ch
        sheet.alpha_composite(im, (cx0 + max(0, (cw - 8 - im.width) // 2), cy0 + max(0, (ch - 8 - im.height) // 2)))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    write_ora(OUT / f'{PFX}_fin_apple_woods_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)

    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('chemin', 'chemin'), ('herbe_claire', 'herbe_claire'), ('herbe_feuillage', 'herbe'), ('pommes', 'pommiers')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}

    manifest = {
        'lot': 'fin_apple_woods_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin_de_donjon', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EAW1, EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'Apple Woods / Bois aux Pommes (Explorateurs du Ciel), sanctuaire du Grand Pommier Ancestral, Pommes Parfaites et clairiere ocre',
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
                         'origine': 'Pommes Parfaites dorees et pommes rouges style PMD generees sur fond magenta (pommes_feuilles_poses.png)'},
        'feuilles_eclats': {'phases': PHASES, 'frame_length_ticks': TICKS,
                            'poses': {k: list(v) for k, v in POSE_BOXES.items() if not k.startswith('pomme')},
                            'palette': [[int(v) for v in c] for c in pose_pal],
                            'feuilles': [list(f) for f in LEAVES_SPOTS],
                            'eclats': [list(s) for s in SPARK_SPOTS],
                            'origine': 'feuilles de pommier voletantes et eclats de pollen dore generes sur fond magenta (pommes_feuilles_poses.png)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'path_found_16x16': reach_boss and reach_obj, 'cells_explored': max(exp_boss, exp_obj),
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (chemin, herbe_claire, herbe, fleurs)',
                   'boss': 'case 2 x 2 libre au centre de la clairiere ocre',
                   'objectif': 'case 2 x 2 libre au pied du socle de pierre du Grand Pommier Ancestral au nord'},
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
