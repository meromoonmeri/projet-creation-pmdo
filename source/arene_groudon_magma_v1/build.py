"""Arène de Groudon magma (AGM1) — arène sur un lac de magma, symbole de Groudon qui pulse, colonnes de magma. 4:3.

Demande : « une arène avec des colonnes de lave magma qui jaillissent à côté de l'arène au centre avec le symbole de
groudon qui pulse sur l'arène » puis « arène avec le signe de groudon qui pulse et faut que le magma de la zone bouge de
manière visqueuse ». (Dans PMD Explorers of Sky, Groudon se combat au sommet de Steam Cave ; l'association avec le
magma de Dark Crater est un choix de l'utilisateur, textures de la fosse de Dark Crater.)
Layout : arrivée au sud par le chemin de pierre (marqueur `entrance`), grande arène de pierre sur le magma, dais rond au
centre gravé du Ω de Primo-Groudon (marqueur `boss` sur le dais, marqueur `heros` devant le dais), quatre colonnes de
magma qui jaillissent du lac de part et d'autre de l'arène, à hauteur du dais. Aucune sortie, aucun warp.

Méthode (rendu généré RÉFÉRENCÉ) :
- décor complet généré avec Dark_Crater_Pit_TDS.png en images= (lave = magenta), dais et Ω compris ;
- sol complet = plage de sol propre du décor répétée en miroir (méthode FCF1, SOL_PATCH) ;
- animations, chacune sur son calque, module partagé source/magma_visqueux/magma.py (les mêmes que l'entrée ECM1) :
  magma visqueux 32 x 15 ticks (rides autour des évents), colonnes 48 x 5 ; symbole de Groudon : les lignes du Ω et de
  l'anneau pulsent sur 12 x 10 ticks avec un halo sur la pierre au pic ; braises du rebord 6 x 10 (ECN1).
Scène : PPCM 480 ticks = 8 s.
Lancer : .venv/bin/python source/arene_groudon_magma_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'arene_groudon_magma_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'arene_groudon_magma'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'agm1_arene_groudon_magma'
PFX = 'AGM1'
REF = 'Dark_Crater_Pit_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
SOL_PATCH = (190, 280, 420, 780)          # (y0, y1, x0, x1) plage de sol du décor (saturation 11 px <= 13,8), en miroir
# Mesures sur le brut (fenêtre 11 px) : sol (89-94, 82-87, 78-83) S 10-11 ; rebord (70, 51, 32) S 36 ; pitons S 19 ;
# flanc du dais S 17 ; lignes du Ω (189-197, 65-84, 23-52) S 119-137.
FLOOR_L, FLOOR_SAT = 62, 16
DAIS_RAW = ((599, 418), (140, 130))       # dais relevé sur le brut 1200 x 896 : centre, demi-axes (lignes : x 494-704, y 305-489)
SIGN_PHASES, SIGN_TICKS = 12, 10
SIGN_PULSE = [0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0]
EMBER_PHASES, EMBER_TICKS = 6, 10
PULSE = [0, 1, 2, 2, 1, 0]
N_VENTS = 4
VENT_OFFSETS = [0, 24, 12, 36]            # gauche haut, gauche bas, droite haut, droite bas : en alternance
FIDELITY_MAX = 35
MAGMA_FIDELITY_MAX = 12


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
MG = loadmod('magma_visqueux', R / 'source/magma_visqueux/magma.py')
GR = loadmod('magma_ground', R / 'source/magma_visqueux/ground.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
LOOP_TICKS = int(np.lcm.reduce([MG.PHASES * MG.TICKS, MG.COL_PHASES * MG.COL_TICKS, SIGN_PHASES * SIGN_TICKS,
                                EMBER_PHASES * EMBER_TICKS]))
SIGN_RAMP = [MG.PAL[i] for i in (1, 2, 3, 4, 5, 7, 9, 11, 12)]   # croûte -> jaune vif du rip


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_large(mask, minimum):
    lab, n = nd.label(mask)
    if n == 0:
        return mask
    return np.isin(lab, 1 + np.flatnonzero(nd.sum(mask, lab, range(1, n + 1)) >= minimum))


def make_sol(decor):
    y0, y1, x0, x1 = SOL_PATCH; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    lava = morph(nd.binary_dilation, mag, 2)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    (cx, cy), (ax, ay) = DAIS_RAW
    dais = (((xx - cx) / ax) ** 2 + ((yy - cy) / ay) ** 2 <= 1) & ~lava
    L = nd.uniform_filter(lum, 11); Sm = nd.uniform_filter(sat.astype(float), 11)
    core = (L > FLOOR_L) & (Sm < FLOOR_SAT) & ~morph(nd.binary_dilation, lava, 3) & ~dais
    core = morph(nd.binary_opening, core, 3)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = morph(nd.binary_closing, lab == int(np.argmax(sizes)) + 1, 4) & ~lava & ~dais
    holes = nd.binary_fill_holes(floor | dais) & ~floor & ~dais
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    floor |= np.isin(hl, [i + 1 for i, s in enumerate(hs) if s < 2500])            # cailloux du sol rebouchés
    land = ~lava
    ll, _ = nd.label(land)
    plateau = ll == np.bincount(ll[floor]).argmax()
    rim = plateau & ~floor & ~dais
    spires = land & ~plateau
    sign = dais & (r > 120) & (r > g * 1.6) & (b < 90)                             # lignes rouges-orangées du Ω
    ember = (r > 170) & (g > 60) & (g < 200) & (b < 90) & (r > b + 100) & (rim | spires)   # seuil des braises de ECN1
    return dict(lava=lava, floor=floor, rim=rim, spires=spires, dais=dais), sign, ember


def ramp_rank(a, full, small):
    lum = JM.down_class(a, {'g': full}, ['g'])[1]['g'].astype(float) @ [.299, .587, .114]
    return np.clip(np.digitize(lum, np.percentile(lum[small], [33, 66])), 0, 2) if small.any() else np.zeros((H, W), int)


def sign_frames(a, sign_full, sign, dais):
    """Symbole de Groudon : rang de luminance des lignes + pulsation lente ; au pic, halo de 2 px sur la pierre du dais."""
    rank = ramp_rank(a, sign_full, sign)
    halo = morph(nd.binary_dilation, sign, 2) & ~sign & dais
    out = []
    for t in range(SIGN_PHASES):
        p = SIGN_PULSE[t]
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + p + 1, 0, len(SIGN_RAMP) - 1)
        for i, c in enumerate(SIGN_RAMP):
            e[sign & (idx == i)] = (*c, 255)
        if p >= 4:
            e[halo] = (*SIGN_RAMP[p - 3], 255)
        out.append(e)
    return out, halo


def ember_frames(a, ember_full, ember):
    rank = ramp_rank(a, ember_full, ember)
    ramp = [MG.PAL[i] for i in (3, 5, 7, 9, 11)]
    out = []
    for t in range(EMBER_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + PULSE[t], 0, 4)
        for i, c in enumerate(ramp):
            e[ember & (idx == i)] = (*c, 255)
        out.append(e)
    return out, ramp


def pick_vents(visible, dist, plateau, dais_c):
    """Quatre évents à côté de l'arène, à hauteur du dais : deux à gauche, deux à droite, dans le magma libre."""
    yy, xx = np.mgrid[:H, :W]
    px = np.nonzero(plateau.any(0))[0]; left, right = px.min(), px.max()
    vents = []
    for side, x_lim in (('g', left), ('d', right)):
        for yc, gap in ((dais_c[1] - 50, 18), (dais_c[1] + 60, 56)):   # le second plus au large : colonnes non superposées
            near = (xx < x_lim - gap) if side == 'g' else (xx > x_lim + gap)
            cand = visible & near & (dist > 18) & (np.abs(yy - yc) < 40) & (yy > 124) & (xx > 20) & (xx < W - 20)
            pts = np.argwhere(cand)
            # au plus près de la limite, sans coller aux pitons
            key = np.abs(np.abs(pts[:, 1] - x_lim) - gap) - 0.5 * np.minimum(dist[pts[:, 0], pts[:, 1]], 30) + 0.3 * np.abs(pts[:, 0] - yc)
            y, x = pts[int(np.argmin(key))]; vents.append((int(y), int(x)))
    return [{'x': x, 'y': y, 'h': int(min(112, y - 12)), 'decalage': VENT_OFFSETS[i]} for i, (y, x) in enumerate(vents)]


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    assert (f == make_sol(a)).all(), 'sol_complet.png doit être le miroir de SOL_PATCH'
    m, sign_full, ember_full = classify(a)
    order = ['lava', 'floor', 'rim', 'spires', 'dais']
    ex, cols = JM.down_class(a, m, order)
    lava = ex['lava']
    names = {'floor': 'sol_arene', 'rim': 'rebord', 'spires': 'pitons', 'dais': 'dais'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~lava)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    dais_l = layers.pop('dais')
    layers = BM.quantize_layers(layers)
    q = Image.fromarray(dais_l[..., :3]).quantize(colors=48, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    dais_l[..., :3] = np.array(q.convert('RGB')); dais_l[~ex['dais']] = 0                       # dais : palette propre (rouges du Ω)
    layers['dais'] = dais_l
    land = np.zeros((H, W), bool)
    for nm in names.values():
        land |= layers[nm][..., 3] == 255
    visible = lava & ~land
    dist = nd.distance_transform_edt(visible)
    plateau = ex['floor'] | ex['rim'] | ex['dais']
    dy, dx = np.nonzero(ex['dais']); dais_c = (int(dx.mean()), int(dy.mean()))
    vents = pick_vents(visible, dist, plateau, dais_c)
    mf, dist, midx = MG.magma_phases(lava, visible, feet=[(v['x'], v['y']) for v in vents], drift=(0, 1), seed=5)
    colf = MG.column_frames(H, W, vents)
    sign = JM.down_class(a, {'s': sign_full, 'n': ~sign_full}, ['s', 'n'])[0]['s'] & ex['dais']
    sf, halo = sign_frames(a, sign_full, sign, ex['dais'])
    ember = JM.down_class(a, {'e': ember_full, 'n': ~ember_full}, ['e', 'n'])[0]['e'] & (ex['rim'] | ex['spires'])
    ef, ramp = ember_frames(a, ember_full, ember)
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, mf=mf, midx=midx, colf=colf, vents=vents,
                sf=sf, sign=sign, halo=halo, ef=ef, ramp=ramp, ember=ember, dist=dist, dais_c=dais_c)


def fidelity(layers):
    rip = rgb(R / REF)
    ref = rip[180:360, 180:380].reshape(-1, 3).mean(0)                    # sol du plateau du rip (même fenêtre que FCF1)
    ours = layers['sol_arene'][layers['sol_arene'][..., 3] == 255][:, :3].astype(float).mean(0)
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'rip_sol_rgb': r1(ref), 'sol_arene_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'seuil': FIDELITY_MAX}


def magma_fidelity(frames, visible):
    pit = rgb(R / REF); r, g, b = pit.transpose(2, 0, 1)
    lava_ref = pit[(r > 180) & (b < 80) & (r - b > 120)].astype(float).mean(0)
    px = np.concatenate([f[visible][:, :3] for f in frames]).astype(float)
    hot = px[px[:, 0] > 240]; mean = hot.mean(0)
    return {'lave_rip_rgb': [round(float(v), 1) for v in lava_ref], 'magma_chaud_rgb': [round(float(v), 1) for v in mean],
            'distance': round(float(np.linalg.norm(lava_ref - mean)), 2), 'part_croute': round(float(1 - len(hot) / len(px)), 3),
            'seuil': MAGMA_FIDELITY_MAX}


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_colonne']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/magma', 'animation/symbole_groudon', 'animation/braises', 'animation/colonnes',
              'poses_colonne', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    mfid = magma_fidelity(D['mf'], D['visible']); assert mfid['distance'] < MAGMA_FIDELITY_MAX, mfid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['sign'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_symbole.png')
    for k, p in enumerate(MG.column_poses(110)):
        Image.fromarray(p).save(OUT / 'poses_colonne' / f'{PFX}_colonne_p{k:02d}.png')
    static_order = ['sol_complet', 'sol_arene', 'rebord', 'pitons', 'dais']
    stack_named = [('magma', D['mf'], MG.TICKS)] + [(nm, [layers[nm]], 60) for nm in static_order] + \
                  [('symbole_groudon', D['sf'], SIGN_TICKS), ('braises', D['ef'], EMBER_TICKS), ('colonnes', D['colf'], MG.COL_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    # ---- collisions : seul le sol de l'arène est praticable (le dais est surélevé)
    walk = layers['sol_arene'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]
    dy, dx = np.nonzero(ex['dais'])
    boss = [int(dx.mean()) // 8 * 8 - 8, int(dy.mean()) // 8 * 8 - 16]                    # sur le Ω
    heros = None
    for yy_ in range((int(dy.max()) + 8) // 8, gh_ - 1):
        for dx_ in sorted(range(-4, 5), key=abs):
            gx = int(dx.mean()) // 8 - 1 + dx_
            if heros is None and not blocked[yy_:yy_ + 2, gx:gx + 2].any():
                heros = [gx * 8, yy_ * 8]
    markers = {'entrance': entrance, 'boss': boss, 'heros': heros}
    ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (heros[1] // 8, heros[0] // 8))
    assert ok, 'pas de chemin 16x16'
    per = {nm: tk for nm, fr, tk in stack_named if len(fr) > 1}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // per[title]) % len(frames)] if title in per else frames[0]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('heros', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    for v in D['vents']:
        dr.ellipse([v['x'] - 4, v['y'] - 4, v['x'] + 4, v['y'] + 4], outline=(255, 255, 255, 255), width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    zoom = Image.new('RGBA', (6 * 240, 240))
    for i, t in enumerate(range(0, 12, 2)):
        im = Image.fromarray(layers['dais']).copy(); im.alpha_composite(Image.fromarray(D['sf'][t]))
        x0, y0 = D['dais_c'][0] - 100, D['dais_c'][1] - 100
        zoom.alpha_composite(im.crop((x0, y0, x0 + 200, y0 + 200)).resize((240, 240), Image.Resampling.NEAREST), (i * 240, 0))
    zoom.save(OUT / 'review' / f'{PFX}_pulsation_symbole.png')
    BM.write_ora(OUT / f'{PFX}_arene_groudon_magma_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    titles = {'magma': 'magma visqueux', 'symbole_groudon': 'symbole Groudon pulse', 'braises': 'braises pulsees',
              'colonnes': 'colonnes de magma'}
    counts = GR.ground_project([(titles.get(t, t.replace('_', ' ')) + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                                for t, fr, tk in stack_named], blocked, markers, gfx, tools,
                               stage=STAGE, pfx=PFX, asset=ASSET, namespace=NAMESPACE, here=HERE, W=W, H=H,
                               name='Arene de Groudon - lac de magma (4:3)',
                               comment=('PMDO 0.8.12. Arene generee 4:3 (textures de la fosse de Dark Crater) ; magma visqueux, '
                                        'colonnes de magma, symbole de Groudon qui pulse sur le dais, braises. Arrivee au sud, '
                                        'boss sur le dais, heros devant. Aucun warp.'),
                               mod_name='Arene de Groudon (lac de magma) 4:3',
                               mod_desc=("Projet d'edition : arene generee au format 4:3 (ref. fosse de Dark Crater), dais au "
                                         "symbole de Groudon qui pulse, colonnes de magma, magma visqueux."))
    manifest = {
        'lot': LOT, 'biome': 'Cratere (magma, textures de Dark Crater Pit)', 'entree_correspondante': ['entree_cratere_magma_v1'],
        'demande': ["une arene avec des colonne de lave magma qui jaillis a cote de l'arene au centre avec le symbole de groudon qui pulse sur l'arene",
                    "arene avec le signe de groudon qui pulse et faut que le magma de la sone bouge de maniere visqueuse"],
        'choix_agent': {'symbole': 'Omega de Primo-Groudon grave sur un dais rond au centre ; ses lignes pulsent',
                        'colonnes': '4 events dans le lac, deux de chaque cote de l arene a hauteur du dais, eruptions en alternance',
                        'layout': 'arrivee au sud par le chemin de pierre, arene sur le magma, dais au centre (boss), heros devant le dais',
                        'note': 'dans PMD Explorers of Sky, Groudon se combat au sommet de Steam Cave ; association avec Dark Crater choisie par l utilisateur'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sur magenta (lave), dais et symbole compris ; sol complet = plage du sol du decor en miroir',
        'reference_da': [REF],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC), 'images': [REF]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'origine': f'miroir de la plage {list(SOL_PATCH)} (y0, y1, x0, x1) du decor'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs ; dais : palette propre de 48 couleurs'},
        'segmentation': {'magma': 'magenta dilate 2 px', 'dais': f'ellipse relevee sur le brut {DAIS_RAW} (centre, demi-axes)',
                         'sol': f'moyenne 11 px > {FLOOR_L} et saturation 11 px < {FLOOR_SAT}, plus grande composante, cailloux rebouches',
                         'rebord': 'plateau hors sol et dais', 'pitons': 'terre hors plateau',
                         'symbole': 'pixels rouges-orangés du dais (r > 120, r > 1,6 g, b < 90)', 'braises': 'orange sur rebord et pitons (seuil ECN1)'},
        'fidelite': fid, 'fidelite_magma': mfid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'magma': {'phases': MG.PHASES, 'frame_length_ticks': MG.TICKS, 'palette': [list(c) for c in MG.PAL],
                  'periode_texture': list(MG.PERIOD), 'cellule': MG.CELL, 'derive': 'une periode (96 px) vers le sud par boucle',
                  'rides': 'autour des 4 events', 'origine': 'module source/magma_visqueux/magma.py, le meme que l entree ECM1 ; pixels calcules'},
        'colonnes': {'phases': MG.COL_PHASES, 'frame_length_ticks': MG.COL_TICKS, 'events': D['vents'],
                     'origine': 'jet procedural du module partage (memes poses que ECM1)'},
        'symbole_groudon': {'phases': SIGN_PHASES, 'frame_length_ticks': SIGN_TICKS, 'pulsation': SIGN_PULSE,
                            'rampe': [list(c) for c in SIGN_RAMP], 'pixels': int(D['sign'].sum()), 'halo_px': int(D['halo'].sum()),
                            'origine': 'lignes du Omega et de l anneau du decor genere ; rang de luminance + pulsation, halo de 2 px au pic'},
        'braises': {'phases': EMBER_PHASES, 'frame_length_ticks': EMBER_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in D['ramp']],
                    'pixels': int(D['ember'].sum()), 'origine': 'pixels orange du decor genere ; methode des braises de ECN1'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemin_16x16': {'ok': ok, 'cases_explorees': explored},
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol de l arene (dais surelevé bloquant)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'magma': mfid, 'markers': markers, 'vents': D['vents'], 'sign': int(D['sign'].sum()),
                      'embers': int(D['ember'].sum()), 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
