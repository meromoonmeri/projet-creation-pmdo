"""Arène de Groudon magma V2 (AGM2) — signe de Groudon qui pulse À MÊME LE SOL de l'arène, colonnes de magma géantes. 4:3.

Demande : « On continue pour groudon le signe doit pulser directement sur le sol de l'arene pas sur un estrade genere de
nouvelle colonne de magma elle doit etre plus grande qu'on en voit pas le bout sur la map et plus impressionnante etc ».
AGM1 est gardée telle quelle.

- Décor : le brut d'AGM1 édité avec UN seul changement : le dais rond disparaît, le Ω de Primo-Groudon et son anneau sont
  gravés à plat dans la pierre du sol, un peu plus grands. Le reste du brut est inchangé (écart mesuré dans le manifeste).
- Sol complet : celui d'AGM1 (miroir d'une plage de sol propre du brut d'AGM1 ; le sol est le même).
- Le signe est praticable : le boss se tient sur le Ω, les héros au sud du signe.
- Colonnes : 4 colonnes géantes (source/magma_visqueux/colonnes_geantes.py), deux de chaque côté de l'arène ; chacune part
  d'une bouche dans le lac et sort par le haut de la carte (sommet jamais visible). Matière du lac qui monte, poussées
  claires, couronne bouillonnante, pluie de gouttes et ondes sur le lac. 48 x 5 ticks.
- Signe : lignes du Ω et de l'anneau qui pulsent du rouge au jaune vif (12 x 10) avec un halo qui s'étend sur la pierre au pic.
- Magma visqueux et braises : module partagé, comme AGM1 et ECM1.
Lancer : .venv/bin/python source/arene_groudon_magma_v2/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'arene_groudon_magma_v2'
OUT = R / 'renders' / LOT
NAMESPACE = 'arene_groudon_magma_v2'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'agm2_arene_groudon_magma'
PFX = 'AGM2'
REF = 'Dark_Crater_Pit_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
SOL_PATCH = (190, 280, 420, 780)          # (y0, y1, x0, x1) plage de sol du décor (saturation 11 px <= 13,8), en miroir
# Mesures sur le brut (fenêtre 11 px) : sol (89-94, 82-87, 78-83) S 10-11 ; rebord (70, 51, 32) S 36 ; pitons S 19 ;
# flanc du dais S 17 ; lignes du Ω (189-197, 65-84, 23-52) S 119-137.
FLOOR_L, FLOOR_SAT = 62, 16
SIGN_RAW = ((600, 425), (212, 196))       # zone du signe gravé sur le brut 1200 x 896 : centre, demi-axes (lignes : x 403-797, y 245-604)
V1_RAW = R / 'source/arene_groudon_magma_v1/bruts/decor_magenta.png'
SIGN_PHASES, SIGN_TICKS = 12, 10
SIGN_PULSE = [0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0]
EMBER_PHASES, EMBER_TICKS = 6, 10
PULSE = [0, 1, 2, 2, 1, 0]
COLS = [  # colonnes géantes (coordonnées 768 x 576) : bouche, demi-largeur ; celles du fond plus étroites (perspective)
    {'nom': 'gauche_fond', 'x': 40, 'y': 206, 'demi': 20, 'decalage': 0, 'graine': 1},
    {'nom': 'gauche_devant', 'x': 82, 'y': 432, 'demi': 28, 'decalage': 17, 'graine': 2},
    {'nom': 'droite_fond', 'x': 672, 'y': 202, 'demi': 20, 'decalage': 29, 'graine': 3},
    {'nom': 'droite_devant', 'x': 724, 'y': 434, 'demi': 28, 'decalage': 8, 'graine': 4}]
FIDELITY_MAX = 35
MAGMA_FIDELITY_MAX = 12


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
MG = loadmod('magma_visqueux', R / 'source/magma_visqueux/magma.py')
GR = loadmod('magma_ground', R / 'source/magma_visqueux/ground.py')
CG = loadmod('colonnes_geantes', R / 'source/magma_visqueux/colonnes_geantes.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
LOOP_TICKS = int(np.lcm.reduce([MG.PHASES * MG.TICKS, CG.PHASES * CG.TICKS, SIGN_PHASES * SIGN_TICKS,
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
    (cx, cy), (ax, ay) = SIGN_RAW
    zone = (((xx - cx) / ax) ** 2 + ((yy - cy) / ay) ** 2 <= 1) & ~lava            # signe gravé à plat : c'est du sol
    dais = np.zeros_like(zone)
    L = nd.uniform_filter(lum, 11); Sm = nd.uniform_filter(sat.astype(float), 11)
    core = (L > FLOOR_L) & (Sm < FLOOR_SAT) & ~morph(nd.binary_dilation, lava, 3) & ~dais
    core = morph(nd.binary_opening, core, 3)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = morph(nd.binary_closing, lab == int(np.argmax(sizes)) + 1, 4) & ~lava & ~dais
    holes = nd.binary_fill_holes(floor | dais) & ~floor & ~dais
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    floor |= np.isin(hl, [i + 1 for i, s in enumerate(hs) if s < 2500])            # cailloux du sol rebouchés
    floor |= zone
    land = ~lava
    ll, _ = nd.label(land)
    plateau = ll == np.bincount(ll[floor]).argmax()
    rim = plateau & ~floor & ~dais
    spires = land & ~plateau
    sign = zone & (r > 120) & (r > g * 1.6) & (b < 90)                             # lignes rouges-orangées du Ω
    ember = (r > 170) & (g > 60) & (g < 200) & (b < 90) & (r > b + 100) & (rim | spires)   # seuil des braises de ECN1
    return dict(lava=lava, floor=floor, rim=rim, spires=spires), sign, ember


def ramp_rank(a, full, small):
    lum = JM.down_class(a, {'g': full}, ['g'])[1]['g'].astype(float) @ [.299, .587, .114]
    return np.clip(np.digitize(lum, np.percentile(lum[small], [33, 66])), 0, 2) if small.any() else np.zeros((H, W), int)


def sign_frames(a, sign_full, sign, floor):
    """Signe de Groudon à même le sol : rang de luminance des lignes + pulsation lente ; halo qui s'étend sur la pierre."""
    rank = ramp_rank(a, sign_full, sign)
    halo1 = morph(nd.binary_dilation, sign, 1) & ~sign & floor
    halo2 = morph(nd.binary_dilation, sign, 3) & ~sign & ~halo1 & floor
    out = []
    for t in range(SIGN_PHASES):
        p = SIGN_PULSE[t]
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + p + 1, 0, len(SIGN_RAMP) - 1)
        for i, c in enumerate(SIGN_RAMP):
            e[sign & (idx == i)] = (*c, 255)
        if p >= 3:
            e[halo1] = (*SIGN_RAMP[p - 2], 255)
        if p >= 5:
            e[halo2] = (*SIGN_RAMP[1], 255)
        out.append(e)
    return out, halo1 | halo2


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


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    assert (f == make_sol(rgb(V1_RAW))).all(), 'sol_complet.png = miroir de SOL_PATCH du brut AGM1'
    m, sign_full, ember_full = classify(a)
    order = ['lava', 'floor', 'rim', 'spires']
    ex, cols = JM.down_class(a, m, order)
    lava = ex['lava']
    names = {'floor': 'sol_arene', 'rim': 'rebord', 'spires': 'pitons'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~lava)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    land = np.zeros((H, W), bool)
    for nm in names.values():
        land |= layers[nm][..., 3] == 255
    visible = lava & ~land
    dist = nd.distance_transform_edt(visible)
    vents = [dict(c) for c in COLS]
    for v in vents:
        assert visible[v['y'], v['x']] and dist[v['y'], v['x']] > 12, v                  # bouche dans le lac libre
    mf, dist, midx = MG.magma_phases(lava, visible, feet=[(v['x'], v['y']) for v in vents], drift=(0, 1), seed=5)
    colf = CG.column_frames(H, W, vents, visible)
    sign = JM.down_class(a, {'s': sign_full, 'n': ~sign_full}, ['s', 'n'])[0]['s'] & ex['floor']
    sf, halo = sign_frames(a, sign_full, sign, ex['floor'])
    sy, sx = np.nonzero(sign); dais_c = (int(round(sx.mean())), int(round(sy.mean())))       # centre du signe
    v1r = rgb(V1_RAW); yy, xx = np.mgrid[:SRC[1], :SRC[0]]
    (cx, cy), (ax, ay) = SIGN_RAW
    out_z = ((xx - cx) / (ax + 20)) ** 2 + ((yy - cy) / (ay + 20)) ** 2 > 1
    dd = np.abs(v1r - a).sum(2)[out_z]
    ecart_v1 = {'somme_rvb_moyenne': round(float(dd.mean()), 2), 'part_pixels_ecart_60': round(float((dd > 60).mean()), 4)}
    ember = JM.down_class(a, {'e': ember_full, 'n': ~ember_full}, ['e', 'n'])[0]['e'] & (ex['rim'] | ex['spires'])
    ef, ramp = ember_frames(a, ember_full, ember)
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, mf=mf, midx=midx, colf=colf, vents=vents,
                sf=sf, sign=sign, halo=halo, ef=ef, ramp=ramp, ember=ember, dist=dist, dais_c=dais_c, ecart_v1=ecart_v1)


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
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/magma', 'animation/symbole_groudon', 'animation/braises', 'animation/colonnes',
              'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    mfid = magma_fidelity(D['mf'], D['visible']); assert mfid['distance'] < MAGMA_FIDELITY_MAX, mfid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['sign'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_symbole.png')
    static_order = ['sol_complet', 'sol_arene', 'rebord', 'pitons']
    stack_named = [('magma', D['mf'], MG.TICKS)] + [(nm, [layers[nm]], 60) for nm in static_order] + \
                  [('symbole_groudon', D['sf'], SIGN_TICKS), ('braises', D['ef'], EMBER_TICKS), ('colonnes', D['colf'], CG.TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    # ---- collisions : le sol de l'arène est praticable, signe compris (gravé à plat)
    walk = layers['sol_arene'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]
    dy, dx = np.nonzero(D['sign'])
    boss = [int(round(dx.mean())) // 8 * 8 - 8, int(round(dy.mean())) // 8 * 8 - 8]        # au centre du Ω, sur le sol
    heros = None
    for yy_ in range((int(dy.max()) + 16) // 8, gh_ - 1):                                  # au sud de l'anneau
        for dx_ in sorted(range(-4, 5), key=abs):
            gx = int(dx.mean()) // 8 - 1 + dx_
            if heros is None and not blocked[yy_:yy_ + 2, gx:gx + 2].any():
                heros = [gx * 8, yy_ * 8]
    markers = {'entrance': entrance, 'boss': boss, 'heros': heros}
    ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (heros[1] // 8, heros[0] // 8))
    assert ok, 'pas de chemin 16x16'
    ok_b, explored_b = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (boss[1] // 8, boss[0] // 8))
    assert ok_b, 'boss hors d atteinte : le signe doit etre praticable'
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
    zoom = Image.new('RGBA', (6 * 280, 280))
    for i, t in enumerate(range(0, 12, 2)):
        im = Image.fromarray(layers['sol_arene']).copy(); im.alpha_composite(Image.fromarray(D['sf'][t]))
        x0, y0 = D['dais_c'][0] - 140, D['dais_c'][1] - 140
        zoom.alpha_composite(im.crop((x0, y0, x0 + 280, y0 + 280)), (i * 280, 0))
    zoom.save(OUT / 'review' / f'{PFX}_pulsation_symbole.png')
    BM.write_ora(OUT / f'{PFX}_arene_groudon_magma_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    titles = {'magma': 'magma visqueux', 'symbole_groudon': 'symbole Groudon pulse', 'braises': 'braises pulsees',
              'colonnes': 'colonnes de magma'}
    counts = GR.ground_project([(titles.get(t, t.replace('_', ' ')) + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                                for t, fr, tk in stack_named], blocked, markers, gfx, tools,
                               stage=STAGE, pfx=PFX, asset=ASSET, namespace=NAMESPACE, here=HERE, W=W, H=H,
                               name='Arene de Groudon V2 - signe au sol, colonnes geantes (4:3)',
                               comment=('PMDO 0.8.12. Arene generee 4:3 (textures de la fosse de Dark Crater) ; magma visqueux, '
                                        '4 colonnes de magma geantes qui sortent par le haut de la carte, symbole de Groudon grave a '
                                        'plat qui pulse sur le sol, braises. Arrivee au sud, boss sur le signe, heros au sud. Aucun warp.'),
                               mod_name='Arene de Groudon V2 (signe au sol, colonnes geantes) 4:3',
                               mod_desc=("Projet d'edition : arene generee au format 4:3 (ref. fosse de Dark Crater), symbole de "
                                         "Groudon qui pulse a meme le sol, colonnes de magma geantes, magma visqueux."))
    manifest = {
        'lot': LOT, 'biome': 'Cratere (magma, textures de Dark Crater Pit)', 'entree_correspondante': ['entree_cratere_magma_v1'],
        'remplace_sans_supprimer': 'arene_groudon_magma_v1',
        'demande': ["On continue pour groudon le signe doit pulser directement sur le sol de l'arene pas sur un estrade genere de nouvelle "
                    "colonne de magma elle doit etre plus grande qu'on en voit pas le bout sur la map et plus impressionnante etc","une arene avec des colonne de lave magma qui jaillis a cote de l'arene au centre avec le symbole de groudon qui pulse sur l'arene",
                    "arene avec le signe de groudon qui pulse et faut que le magma de la sone bouge de maniere visqueuse"],
        'choix_agent': {'symbole': 'Omega de Primo-Groudon et son anneau graves a plat dans le sol (plus de dais) ; lignes qui pulsent, '
                                   'halo qui s etend sur la pierre au pic ; praticable',
                        'colonnes': '4 colonnes geantes en jaillissement continu, deux de chaque cote (fond plus etroit : perspective) ; '
                                    'elles sortent par le haut de la carte ; decalees',
                        'layout': 'celui d AGM1 sans le dais : arrivee au sud, boss sur le Omega, heros au sud de l anneau',
                        'note': 'dans PMD Explorers of Sky, Groudon se combat au sommet de Steam Cave ; association avec Dark Crater choisie par l utilisateur'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : brut AGM1 (genere avec la fosse de Dark Crater) edite en un seul changement (dais retire, '
                  'signe grave a plat) ; sol complet d AGM1',
        'reference_da': [REF],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': ['source/arene_groudon_magma_v1/bruts/decor_magenta.png'],
                        'consigne': 'un seul changement : retirer le dais rond ; le Omega et son anneau graves a plat dans le sol, un peu plus grands',
                        'ecart_hors_signe': D['ecart_v1']},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'origine': f'copie du sol complet AGM1 : miroir de la plage {list(SOL_PATCH)} (y0, y1, x0, x1) du brut AGM1'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs'},
        'segmentation': {'magma': 'magenta dilate 2 px', 'zone_signe': f'ellipse relevee sur le brut {SIGN_RAW} (centre, demi-axes), comptee en sol',
                         'sol': f'moyenne 11 px > {FLOOR_L} et saturation 11 px < {FLOOR_SAT}, plus grande composante, cailloux rebouches',
                         'rebord': 'plateau hors sol', 'pitons': 'terre hors plateau',
                         'symbole': 'pixels rouges-orangés de la zone du signe (r > 120, r > 1,6 g, b < 90)', 'braises': 'orange sur rebord et pitons (seuil ECN1)'},
        'fidelite': fid, 'fidelite_magma': mfid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'magma': {'phases': MG.PHASES, 'frame_length_ticks': MG.TICKS, 'palette': [list(c) for c in MG.PAL],
                  'periode_texture': list(MG.PERIOD), 'cellule': MG.CELL, 'derive': 'une periode (96 px) vers le sud par boucle',
                  'rides': 'autour des 4 bouches de colonnes', 'origine': 'module source/magma_visqueux/magma.py, le meme que l entree ECM1 ; pixels calcules'},
        'colonnes': {'phases': CG.PHASES, 'frame_length_ticks': CG.TICKS, 'colonnes': D['vents'],
                     'montee_px_par_phase': CG.RISE_PERIODS * MG.PERIOD[1] * CG.STRETCH / CG.PHASES, 'poussees_par_boucle': CG.SURGES,
                     'gouttes_par_colonne': CG.N_DROPS, 'ondes': CG.RIPPLES,
                     'loi': 'axe x0 + 2,2 sin(y/41 + phi + g) + 1,1 sin(y/15 - 2 phi + 2g) ; demi-largeur d (1 + 0,07 sin(y/17 - 3 phi + g)) '
                            '+ 11 exp(-(yb - y)/13) + 4,5 poussees ; matiere du lac etiree x2 qui monte de 3 periodes par boucle ; '
                            'profil coeur jaune (niveau >= 11,3), lisiere rouge, croute 2 px, contour sombre ; couronne, gouttes, ondes',
                     'sommet': 'hors cadre : chaque colonne touche le bord haut (y = 0) a toutes les phases',
                     'origine': 'source/magma_visqueux/colonnes_geantes.py ; pixels calcules, rampe relevee sur la lave du rip'},
        'symbole_groudon': {'phases': SIGN_PHASES, 'frame_length_ticks': SIGN_TICKS, 'pulsation': SIGN_PULSE,
                            'rampe': [list(c) for c in SIGN_RAMP], 'pixels': int(D['sign'].sum()), 'halo_px': int(D['halo'].sum()),
                            'origine': 'lignes du Omega et de l anneau graves a plat ; rang de luminance + pulsation ; halo 1 px des '
                                       'le niveau 3, puis 3 px au pic, sur la pierre du sol'},
        'braises': {'phases': EMBER_PHASES, 'frame_length_ticks': EMBER_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in D['ramp']],
                    'pixels': int(D['ember'].sum()), 'origine': 'pixels orange du decor genere ; methode des braises de ECN1'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemin_16x16': {'ok': ok, 'cases_explorees': explored},
                   'chemin_boss_16x16': {'ok': ok_b, 'cases_explorees': explored_b},
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol de l arene ; le signe grave est du sol'},
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
