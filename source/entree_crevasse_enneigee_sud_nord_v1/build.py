"""Entrée Crevasse enneigée sud -> nord V1 (ECE1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases de 8 px).

Demande (16 octobre 2026) : « Fait la zone de fin et passe enuite au prochaine map ! » : après la fin FGV1, nouvelle
entrée de la série sud -> nord sur une map ROM libre. Biome choisi par l'agent (à confirmer) : falaise de glace lavande
fendue d'une crevasse-grotte au nord, rip D79P11A (aucune branche des deux dépôts ne l'utilise). « Glace » figure parmi
les biomes demandés par l'utilisateur (« passer aux prochains biomes : Ruine Légendaire, Glace, Apple Woods, ... »).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ + pipeline natif :
- decor.png : générateur, images=[D79P11A], nouvelle disposition 4:3 (1200 x 896), premier essai ;
- sol complet : deux éditions du générateur écartées (bruit, taches bleues sur une neige presque blanche) ; construit
  par le pipeline : neige praticable du décor, complétée par le blanc du rip (couleur la plus fréquente de D79P11A) ;
- source_poses.png : planche générée sur magenta (6 flocons, 6 phases d'éclat de givre), images=[D79P11A].
TOUTES les couleurs de tous les calques sont des couleurs EXACTES du rip D79P11A (103 couleurs ; plus proche RGB ;
écart moyen du décor brut à cette palette : 3,5).
Calques : sol complet, neige, ombres (neige ombrée, boules de neige, sol de la grotte), corniches (rebords rocheux des
bancs de neige), falaises (parois de glace, cristaux, parois de la crevasse), profondeur (bouche de la crevasse).
Animations, créées par nous (le BPL de D79P11A n'anime rien) : scintillements 48 x 4 ticks (éclats de givre sur la glace
au pied des falaises), flocons 48 x 4 ticks (chute de neige). Scène : 192 ticks.
Marqueurs : `entrance` (sud), `donjon_seuil` (sous la bouche). Aucun warp.
Lancer : .venv/bin/python source/entree_crevasse_enneigee_sud_nord_v1/build.py
"""
from pathlib import Path
import io, json, shutil, uuid, zipfile, importlib.util

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd
from scipy.spatial import cKDTree

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REFDIR = HERE / 'references'
REF = REFDIR / 'D79P11A.png'
TEMPLATE = R / 'cliffdaytest.rsground'
OUT = R / 'renders/entree_crevasse_enneigee_sud_nord_v1'
STAGE = R / '.cache/entree_crevasse_enneigee_sud_nord_v1/entree_crevasse_enneigee_sud_nord'
NAMESPACE = 'entree_crevasse_enneigee_sud_nord'
ASSET = 'ece1_entree_crevasse_enneigee'
PFX = 'ECE1'
REF_CODE = 'D79P11A'
W, H = 768, 576
SRC = (1200, 896)
PH, TK = 48, 4                                  # flocons et scintillements : 48 phases x 4 ticks
LOOP_TICKS = PH * TK                            # 192
GEN = [
    {'file': 'decor.png', 'images': ['source/entree_crevasse_enneigee_sud_nord_v1/references/D79P11A.png'], 'prompt':
     "Use the reference image's exact pixel-art style, palette and textures (Pokemon Mystery Dungeon Explorers of Sky, "
     'snowy lavender ice cliff): soft white-lavender snow with pale blue-violet shading, round snowballs and snow mounds, '
     'low snow banks with dark lavender rocky edges, tall faceted lavender ice-rock cliffs with vertical cracks, clusters '
     'of pale ice crystals at the cliff foot, and a dark deep crevice cave in the cliff. Create a NEW map, WIDE LANDSCAPE '
     '4:3, zoomed out, top-down view (1200 x 896): the player arrives from the SOUTH edge on a wide flat snow path. The '
     'path winds gently northward between raised snow banks bordered by low rocky lavender ledges, with round snowballs '
     'and snow mounds scattered on the banks. The whole NORTH part of the map is a tall wall of lavender ice cliffs '
     'spanning the full width; in its middle a big dark crevice cave opens, and the flat snow path reaches right up to '
     'the cave opening, framed by two clusters of ice crystals. Wider snow clearings on the left and right of the path. '
     'No water, no river, no frozen lake, no trees, no characters, no objects, no text, no UI, no border.',
     'essais': 'premier essai, 1200 x 896 ; falaise de glace sur toute la largeur, crevasse au centre, chemin de neige '
               'central abaisse entre deux bancs a corniches, clairieres laterales, boules de neige ; aucune eau'},
    {'file': 'source_poses.png', 'images': ['source/entree_crevasse_enneigee_sud_nord_v1/references/D79P11A.png'], 'prompt':
     'Pixel-art sprite sheet on a flat pure magenta (#FF00FF) background, in the exact pixel-art style and colours of the '
     'reference image (Pokemon Mystery Dungeon Explorers of Sky snowy lavender cliff). Two rows of six well-separated '
     'sprites, each sprite isolated on magenta with plenty of empty space around it. Row 1: six snowflakes, from a tiny '
     'round snow dot to a small six-branched snowflake, white and very pale lavender with a thin light blue-violet '
     'outline. Row 2: six frames of a four-pointed ice sparkle: a tiny dot, then growing into a bright white '
     'four-pointed star with pale blue-violet tips, then shrinking back. Hard pixel edges, no anti-aliasing into the '
     'magenta, no shadows, no text, no grid lines, no border.',
     'essais': 'premier essai, 1124 x 944, 12 sprites bien separes (2 rangees x 6), tous retenus'},
]
SOL_COMPLET_ECARTES = [
    {'images': ['source/entree_crevasse_enneigee_sud_nord_v1/bruts/decor.png'], 'prompt':
     'Edit this pixel-art snowy map, same framing and same pixel style: remove everything except the flat snow floor. '
     'Fill the whole image, edge to edge, with exactly the same flat snow as on the open snow paths of this image [...] '
     'Keep the flat snow that is already visible exactly where it is. No cliffs, no rocks, [...]',
     'resultat': 'ecarte : moitie haute bruitee a taches sombres, moitie basse en aplats lavande, restes de corniches, '
                 'trou de serrure blanc pur ; ecart a la neige du decor 13,4'},
    {'images': ['source/entree_crevasse_enneigee_sud_nord_v1/bruts/decor.png'], 'prompt':
     'Edit this pixel-art snowy map, same framing and same pixel style. Cover the ENTIRE image with one continuous flat '
     'snow field [...] The snow must look exactly like the open snow path in the lower middle of this image [...]',
     'resultat': 'ecarte : grandes taches bleues et violettes, bruit ; ecart a la neige du decor 22,7'},
]
SNOW = (255, 255, 255)
# Planche : (cy, cx, hauteur, largeur) en px de la planche ; réduction (ky, kx). Mesurées sur les composantes.
POSE_WIN = {'flocon_0': (336, 96, 72, 72), 'flocon_1': (336, 282, 120, 120), 'flocon_2': (336, 472, 120, 120),
            'flocon_3': (335, 661, 144, 144), 'flocon_4': (336, 849, 192, 192), 'flocon_5': (336, 1040, 192, 192),
            'eclat_0': (669, 96, 45, 45), 'eclat_1': (669, 283, 90, 90), 'eclat_2': (669, 472, 135, 135),
            'eclat_3': (669, 660, 210, 210), 'eclat_4': (670, 850, 150, 150), 'eclat_5': (669, 1040, 105, 105)}
POSE_K = {k: ((24, 24) if k.startswith('flocon') else (15, 15)) for k in POSE_WIN}
POSE_COV = 0.2
N_FLAKES, FLAKE_LIFE, FLAKE_REST = 72, 40, 4
FLAKE_KINDS = ['flocon_0', 'flocon_2', 'flocon_1', 'flocon_0', 'flocon_3', 'flocon_2', 'flocon_0', 'flocon_1',
               'flocon_4', 'flocon_2', 'flocon_0', 'flocon_5']
FLAKE_FALL = {'flocon_0': 40, 'flocon_1': 48, 'flocon_2': 56, 'flocon_3': 64, 'flocon_4': 80, 'flocon_5': 80}
N_GLINTS = 16
GLINT_SEQ = ['eclat_0', 'eclat_1', 'eclat_2', 'eclat_3', 'eclat_3', 'eclat_4', 'eclat_5', 'eclat_0'] + [None] * 40
assert len(GLINT_SEQ) == PH


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


E = loadmod('egv1_build', R / 'source/entree_grotte_vasques_sud_nord_v1/build.py')    # utilitaires génériques 4:3
JM = E.JM
assert (E.W, E.H, E.SRC) == (W, H, SRC)
keep_large, cell_grid, down_class, down_full, rgba = E.keep_large, E.cell_grid, E.down_class, E.down_full, E.rgba
reduce_pose, paste, spread, sha, rgb, lum_of = E.reduce_pose, E.paste, E.spread, E.sha, E.rgb, E.lum_of
STATIC = ['neige', 'ombres', 'corniches', 'falaises', 'profondeur']
ANIMS = ['scintillements', 'flocons']


# ---------------------------------------------------------------- palette exacte du rip
def rip_palette():
    ref = rgb(REF)
    cols, cnt = np.unique(ref.reshape(-1, 3), axis=0, return_counts=True)
    o = np.argsort(lum_of(cols.astype(float)))
    return [tuple(int(v) for v in cols[i]) for i in o], [int(cnt[i]) for i in o]


def snap(colors, pal):
    """Chaque couleur prend la couleur du rip la plus proche (RGB). colors : (..., 3)."""
    p = np.array(pal, float); flat = colors.reshape(-1, 3).astype(float)
    uq, inv = np.unique(flat, axis=0, return_inverse=True)
    _, idx = cKDTree(p).query(uq)
    return np.array(pal, 'uint8')[idx][inv.ravel()].reshape(colors.shape)


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    """Neige blanche (lum >= 240, |b-r| <= 16) ; neige ombrée (lum 185-240, b-r 4-45) ; roche lavande (lum 50-185,
    b-r >= 30)."""
    a = a.astype(float); lum = lum_of(a); br = a[..., 2] - a[..., 0]
    return {'neige': (lum >= 240) & (np.abs(br) <= 16), 'ombre': (lum >= 185) & (lum < 240) & (br >= 4) & (br <= 45),
            'roche': (lum >= 50) & (lum < 185) & (br >= 30)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """Mesures sur le brut : neige (255,255,255), écart-type ~0 ; neige ombrée lavande (220,224,245), b-r ~ 25, lisse ;
    roche des falaises et des corniches lavande saturée (b-r 50-70), texturée ; bouche (32,38,65), lisse."""
    a = a.astype(float); Hs, Ws = a.shape[:2]; lum = lum_of(a); br = a[..., 2] - a[..., 0]
    m1 = nd.uniform_filter(lum, 5); sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 5) - m1 ** 2, 0))
    white = (lum >= 244) & (sd < 5)
    # Bouche : sombre et lisse, plus grande composante au centre (trous bouchés).
    dark = (lum < 62) & (sd < 8)
    lab, n = nd.label(dark); sizes = nd.sum(dark, lab, range(1, n + 1))
    cm = nd.center_of_mass(dark, lab, range(1, n + 1))
    ok = [i for i in range(n) if abs(cm[i][1] - Ws / 2) < 200 and cm[i][0] < 600]
    mouth = nd.binary_fill_holes(nd.binary_closing(lab == 1 + max(ok, key=lambda i: sizes[i]), iterations=3))
    # Neige praticable : blanc, lavande claire (même texturée) ou ombre lisse, b-r <= 45 (la roche est à 50-70) ;
    # composantes >= 3000 px dont le centre est sous la falaise (y >= 430).
    snowy = white | ((lum >= 185) & (br >= -2) & (br <= 45)) | ((lum >= 150) & (sd < 7) & (br >= 4) & (br <= 45))
    op = nd.binary_opening(snowy, iterations=2)
    lab, n = nd.label(op); sizes = nd.sum(op, lab, range(1, n + 1))
    cy_ = [c[0] for c in nd.center_of_mass(op, lab, range(1, n + 1))]
    keep = [i + 1 for i in range(n) if sizes[i] >= 3000 and cy_[i] >= 430]
    walk = nd.binary_dilation(np.isin(lab, keep), iterations=2) & snowy
    # Sol de la grotte : trapèze sous la bouche (s'élargit de 0,6 px par px de descente), assez lisse, relié à la neige.
    my, mx = np.nonzero(mouth); ymb = int(my.max())
    poly = np.zeros_like(mouth)
    for y in range(ymb - 6, min(Hs, ymb + 60)):
        d = max(0, y - ymb)
        poly[y, max(0, int(mx.min() - 6 - 0.6 * d)):min(Ws, int(mx.max() + 6 + 0.6 * d) + 1)] = True
    floor_c = poly & (sd < 22) & (lum >= 50) & ~mouth & ~walk
    lab, n = nd.label(floor_c | walk); floor_c &= np.isin(lab, np.unique(lab[walk]))
    walk |= floor_c
    holes = nd.binary_fill_holes(walk) & ~walk                     # mouchetures < 60 px rendues à la neige
    lab, n = nd.label(holes); hs = nd.sum(holes, lab, range(1, n + 1))
    walk |= np.isin(lab, 1 + np.flatnonzero(hs < 60))
    # Pied de falaise : premier pixel praticable de chaque colonne (médiane sur 15 colonnes).
    foot = np.array([int(np.argmax(walk[:, x])) if walk[:, x].any() else Hs for x in range(Ws)])
    foot = nd.median_filter(foot, 15, mode='nearest')
    yy = np.arange(Hs)[:, None]
    rock = ~walk & ~mouth
    fal = rock & (yy < foot[None, :] + 4)
    low = rock & ~fal
    # Contours sombres des boules de neige (petits arcs entourés de neige) : rendus aux ombres ; le reste = corniches.
    lab, n = nd.label(low); objs = nd.find_objects(lab); szs = nd.sum(low, lab, range(1, n + 1)); arcs = 0
    for i, s_ in enumerate(objs):
        h_, w_ = s_[0].stop - s_[0].start, s_[1].stop - s_[1].start
        if not (szs[i] <= 900 and w_ <= 100 and h_ <= 60):
            continue
        comp = np.pad(lab[s_] == i + 1, 5); ring = nd.binary_dilation(comp, iterations=4) & ~comp
        ys_, xs_ = np.nonzero(ring); ys_ += s_[0].start - 5; xs_ += s_[1].start - 5
        inb = (ys_ >= 0) & (ys_ < Hs) & (xs_ >= 0) & (xs_ < Ws)
        if inb.all() and walk[ys_, xs_].mean() >= 0.7:
            walk[s_] |= lab[s_] == i + 1; arcs += 1
    corn = low & ~walk
    m = {'neige': walk & white, 'ombres': walk & ~white, 'corniches': corn, 'falaises': fal, 'profondeur': mouth}
    seg = {'bouche_px': int(mouth.sum()), 'bas_de_bouche_y': ymb, 'sol_grotte_px': int(floor_c.sum()),
           'niveaux_de_neige': len(keep), 'contours_de_boules_rendus_aux_ombres': arcs,
           'pied_de_falaise_y': [int(foot.min()), int(foot.max())]}
    return m, walk, seg


# ---------------------------------------------------------------- poses générées (planche sur magenta)
def sheet_poses(path, pal):
    """Fond = magenta pur (g < 90, r-g et b-g > 130) ET pixels teintés de magenta (r-g > 60 et b-g > 60), ni gardés ni
    recolorés. Couleurs ramenées à la couleur du rip la plus proche (RGB)."""
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((g < 90) & (r - g > 130) & (b - g > 130)) | ((r - g > 60) & (b - g > 60))
    p = np.array(pal, float)
    poses = {name: reduce_pose(src, bg, cy, cx, hh, ww, *POSE_K[name], p, POSE_COV)
             for name, (cy, cx, hh, ww) in POSE_WIN.items()}
    for name, o in poses.items():                                  # rogner les bords transparents
        ys, xs = np.nonzero(o[..., 3])
        assert len(ys), name
        poses[name] = o[ys.min():ys.max() + 1, xs.min():xs.max() + 1].copy()
    return poses, int((((r - g > 60) & (b - g > 60)) & ~(g < 90)).sum())


def flake_frames(poses, flakes, walk, ts=range(PH)):
    """flakes : (x0, y0, sorte, décalage). Vie de FLAKE_LIFE phases : chute de FLAKE_FALL[sorte] px en ondulant
    (amplitude 3 px, période 24 phases), puis, posé sur la neige praticable, un point (flocon_0) pendant FLAKE_REST
    phases ; ailleurs il disparaît. Les gros flocons sont dessinés par-dessus les petits."""
    frames = []
    order = sorted(range(len(flakes)), key=lambda j: (FLAKE_FALL[flakes[j][2]], j))
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for j in order:
            x0, y0, kind, off = flakes[j]; age = (t - off) % PH
            if age < FLAKE_LIFE:
                y = y0 + FLAKE_FALL[kind] * age / FLAKE_LIFE
                x = x0 + 3 * np.sin(2 * np.pi * (age / 24 + x0 / 97))
                paste(a, poses[kind], x, y)
            elif age < FLAKE_LIFE + FLAKE_REST:
                y = y0 + FLAKE_FALL[kind]; x = x0 + 3 * np.sin(2 * np.pi * (FLAKE_LIFE / 24 + x0 / 97))
                yi, xi = int(round(y)), int(round(x))
                if 0 <= yi < H and 0 <= xi < W and walk[yi, xi]:
                    paste(a, poses['flocon_0'], x, y)
        frames.append(a)
    return frames


def glint_frames(poses, glints, ts=range(PH)):
    """glints : (x, y, décalage). Chaque éclat suit GLINT_SEQ (point, croissance, étoile, décroissance) puis s'éteint."""
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for x, y, off in glints:
            kind = GLINT_SEQ[(t - off) % PH]
            if kind:
                paste(a, poses[kind], x, y)
        frames.append(a)
    return frames


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Crevasse enneigee V1 (ECE1)')
    stack = ET.SubElement(root, 'stack'); comp = Image.new('RGBA', (W, H))

    def zi(n, method=zipfile.ZIP_DEFLATED):          # date fixe : ORA identique octet pour octet d'un build à l'autre
        info = zipfile.ZipInfo(n, date_time=(1980, 1, 1, 0, 0, 0)); info.compress_type = method; return info
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr(zi('mimetype', zipfile.ZIP_STORED), 'image/openraster')
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(zi(fn), b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr(zi('mergedimage.png'), b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256)); b = io.BytesIO(); th.save(b, format='PNG')
        z.writestr(zi('Thumbnails/thumbnail.png'), b.getvalue())
        z.writestr(zi('stack.xml'), ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
    """Gabarit : `cliffdaytest.rsground` (Ground PMDO 0.8.12 de l'utilisateur, racine du dépôt). Fond (MapBG vide),
    BlankBG, rand et NoSwitching du gabarit gardés."""
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads(TEMPLATE.read_text(encoding='utf-8-sig'))
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
    o.update(Name={'DefaultText': 'Entree Crevasse enneigee - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip PMD Sky D79P11A (falaise de glace et crevasse) ; '
                     'toutes les couleurs sont des couleurs exactes du rip ; scintillements et flocons generes, '
                     'chronologie creee par nous. Marqueur donjon_seuil sans warp ni destination. Collisions de base a '
                     'verifier. Biome et portee choisis par l agent.')
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
             f'-- {ASSET} : marqueur de seuil seulement, aucun warp ni destination.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Crevasse enneigee 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : entree de donjon sud vers nord au pied d'une falaise de glace fendue d'une crevasse, generee au format 4:3 (ref. rip PMD Sky D79P11A), couleurs exactes du rip, scintillements de givre et chute de neige. Pas une aventure jouable.</Description>
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
    a = rgb(RAW / 'decor.png'); ref = rgb(REF)
    assert a.shape[:2] == (SRC[1], SRC[0])
    pal, pcnt = rip_palette()
    assert SNOW in pal
    m, walk_full, seg = classify(a)
    order = ['profondeur', 'neige', 'ombres', 'corniches', 'falaises']
    ex, cols = down_class(a, m, order)
    # Sol complet : neige praticable du décor, blanc du rip ailleurs (les deux éditions du générateur sont écartées).
    sc = np.where(walk_full[..., None], a, np.array(SNOW)).astype(np.uint8)
    layers = {'sol_complet': rgba(snap(down_full(sc), pal), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(snap(cols[k], pal), ex[k])
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    walk = ex['neige'] | ex['ombres']
    # Poses générées, couleurs du rip.
    poses, tinted = sheet_poses(RAW / 'source_poses.png', pal)
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    # Scintillements : glace de ton moyen (lum 150-215 : une étoile blanche y ressort ; sur les facettes presque
    # blanches elle disparaissait) des falaises, dans les 70 px au-dessus du pied, loin de la bouche.
    mouth = ex['profondeur']
    foot = np.array([int(np.argmax(walk[:, x])) if walk[:, x].any() else H for x in range(W)])
    yy = np.arange(H)[:, None]
    fal = layers['falaises']
    lf = lum_of(fal[..., :3].astype(float))
    cand = ex['falaises'] & (lf >= 150) & (lf <= 215) & (yy >= foot[None, :] - 70) & (yy < foot[None, :] - 4)
    cand &= nd.distance_transform_edt(~mouth) > 24
    cand[:, :8] = False; cand[:, -8:] = False
    pick = spread(np.argwhere(cand), N_GLINTS, 36, np.random.default_rng(79))
    assert len(pick) == N_GLINTS, len(pick)
    offs = [(j * PH) // N_GLINTS for j in range(N_GLINTS)]
    np.random.default_rng(7).shuffle(offs)
    glints = [(int(x), int(y), int(o)) for (y, x), o in zip(sorted(pick, key=lambda p: (p[1], p[0])), offs)]
    scint = glint_frames(poses, glints)
    # Flocons : 72 émetteurs répartis sur toute la carte (graine fixe), décalages tirés.
    rng = np.random.default_rng(1979)
    flakes = []
    for j in range(N_FLAKES):
        kind = FLAKE_KINDS[j % len(FLAKE_KINDS)]
        flakes.append((int(rng.integers(6, W - 6)), int(rng.integers(-8, H - 56)), kind, int(rng.integers(0, PH))))
    floc = flake_frames(poses, flakes, walk)
    anim = {'scintillements': (scint, TK), 'flocons': (floc, TK)}
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm]
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    # Collisions : neige et ombres praticables ; corniches, falaises et profondeur bloquées.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    row = walk[H - 8]; runs, x = [], 0
    while x < W:
        if row[x]:
            x1 = x
            while x1 < W and row[x1]:
                x1 += 1
            runs.append((x, x1)); x = x1
        else:
            x += 1
    run = min(runs, key=lambda r: 0 if r[0] <= W // 2 < r[1] else min(abs(r[0] - W // 2), abs(r[1] - W // 2)))
    med = (run[0] + run[1]) // 2 // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    dys, dxs = np.nonzero(mouth)
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 4
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
    names = list(POSE_WIN); cw = 16 * 4 + 8                                # même échelle x4 pour toutes les poses
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (63, 71, 119, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_crevasse_enneigee_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('neige', 'neige'), ('ombre', 'ombres'), ('roche', 'falaises'), ('roche', 'corniches')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    dpal = cKDTree(np.array(pal, float)).query(a.reshape(-1, 3).astype(float))[0]
    manifest = {
        'lot': 'entree_crevasse_enneigee_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'entree de donjon sud -> nord',
        'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (utilitaires EGV1/EWC1/Jungle/Bristle, codec pmdo_cote) ; aucun emprunt aux branches soeurs',
        'biome': 'falaise de glace lavande et crevasse-grotte (rip D79P11A), biome NEUF choisi par l agent (« passe a la '
                 'prochaine map », 16 octobre ; « Glace » figure dans les biomes demandes), a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE (rip D79P11A passe au generateur) + pipeline natif : decor '
                  'complet et planche de poses generes ; reduction par classe, calques 8 px ; TOUTES les couleurs ramenees '
                  'aux couleurs exactes du rip (plus proche RGB)',
        'reference_da': {'file': f'references/{REF.name}', 'sha256': sha(REF), 'code_rom': REF_CODE,
                         'provenance': 'references/provenance.json (pret/pmd-sky, commit, blobs, sha256)',
                         'animation_palette': 'aucune (1 frame, palette_anim.json vide) : animations creees par nous',
                         'titre': 'falaise de glace lavande, crevasse au nord, neige et boules de neige ; nom du lieu non '
                                  'identifie par une capture'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/entree_crevasse_enneigee_sud_nord_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'methode': 'pipeline : neige praticable du decor (sol, ombres, sol de la grotte), blanc du rip '
                                   '(255,255,255) ailleurs ; reduit puis ramene a la palette du rip',
                        'editions_generateur_ecartees': SOL_COMPLET_ECARTES},
        'segmentation_mesures': seg,
        'palette_rip': {'couleurs': [list(c) for c in pal], 'pixels_rip': pcnt,
                        'ecart_decor_brut': {'moyenne': round(float(dpal.mean()), 2), 'q99': round(float(np.quantile(dpal, .99)), 1)},
                        'regle': 'chaque pixel de chaque calque (fixe ou anime) prend la couleur du rip la plus proche (RGB)'},
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal, puis '
                                     'couleur du rip la plus proche'},
        'segmentation': 'neige = blanc, lavande claire (lum >= 185) ou ombre lisse, b-r <= 45, composantes >= 3000 px sous '
                        'la falaise ; sol de la grotte = trapeze lisse sous la bouche relie a la neige ; bouche = sombre et '
                        'lisse (lum < 62) ; falaises = non praticable au-dessus du pied (premier pixel praticable par '
                        'colonne) ; corniches = non praticable en dessous ; contours de boules (petits arcs entoures de '
                        'neige) rendus aux ombres',
        'layers': layer_list,
        'scintillements': {'emetteurs': [list(g) for g in glints], 'sequence': GLINT_SEQ, 'phases': PH, 'frame_length_ticks': TK,
                           'placement': 'glace de ton moyen (lum 150-215) des falaises, 4 a 70 px au-dessus du pied, a plus de '
                                        '24 px de la bouche, espaces de 36 px',
                           'origine': 'dessin GENERE (planche) ; chronologie et placement crees par nous'},
        'flocons': {'emetteurs': [list(f) for f in flakes], 'vie_phases': FLAKE_LIFE, 'pose_phases': FLAKE_REST,
                    'chute_px': FLAKE_FALL, 'ondulation': 'amplitude 3 px, periode 24 phases', 'phases': PH,
                    'frame_length_ticks': TK, 'graine': 1979,
                    'origine': 'dessin GENERE (planche) ; chute, ondulation et pose creees par nous'},
        'poses': {'fenetres': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': {k: list(v) for k, v in POSE_K.items()},
                  'couverture_min': POSE_COV, 'pixels_teintes_ecartes': tinted,
                  'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores',
                  'couleurs': 'couleur du rip la plus proche (RGB)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors neige praticable (ombres comprises)',
                   'seuil': 'donjon_seuil = repere sous la bouche, sans warp ni destination'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'template': {'file': TEMPLATE.name, 'sha256': sha(TEMPLATE)}, 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({'entry': entry_px, 'seuil': threshold_px, 'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()),
                      'seg': seg, 'glints': len(glints), 'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()},
                      'ecart_palette': manifest['palette_rip']['ecart_decor_brut'], 'tiles': sum(counts.values())}, ensure_ascii=False))


if __name__ == '__main__':
    build()
