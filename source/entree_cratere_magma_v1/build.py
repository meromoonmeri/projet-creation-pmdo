"""Entrée Cratère magma (ECM1) — Dark Crater V2 : cascades de lave, colonnes de magma, magma visqueux. 4:3 (768 x 576).

Demande : « Je veux un entrée de map avec magma dark crater des cascade de lave » puis « Des colonnes de magma etc et
cascade pour une version entrée crater pit entrée [...] faut que le magma de la zone bouge de manière visqueuse ».
L'entrée Cratère V1 (ECN1) reste intacte ; ce lot est une nouvelle version.
Layout : arrivée au sud sur le chemin de cendre, bouche de la grotte au nord (marqueur `donjon_seuil`) ; de chaque côté
de la grotte une cascade de lave tombe de la falaise et nourrit une mare de magma qui longe le chemin ; des colonnes de
magma jaillissent des mares, décalées. Aucun warp.

Méthode (rendu généré RÉFÉRENCÉ) :
- décor complet généré avec Dark_Crater_entrance_TDS.png en images= (mares = magenta, cascades = vert pur) ;
- sol complet = plage de cendre propre du décor répétée en miroir (méthode FCF1, SOL_PATCH) ;
- segmentation pleine résolution, réduction par classe (outils de l'entrée Jungle), palette commune 96 couleurs ;
- animations (module partagé source/magma_visqueux/magma.py), chacune sur son calque :
  magma visqueux 32 x 15 ticks, cascades 32 x 15, colonnes 48 x 5, braises des falaises pulsées 6 x 10 (ECN1).
Scène : PPCM 480 ticks = 8 s.
Lancer : .venv/bin/python source/entree_cratere_magma_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'entree_cratere_magma_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'entree_cratere_magma'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'ecm1_entree_cratere_magma'
PFX = 'ECM1'
REF = 'Dark_Crater_entrance_TDS.png'
REF_MAGMA = 'Dark_Crater_Pit_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
SOL_PATCH = (560, 800, 470, 720)          # (y0, y1, x0, x1) plage de cendre du décor, répétée en miroir
# Seuils mesurés sur le brut (fenêtre 11 px) : cendre (97, 88, 93) saturation 8,5-9 ; roche (63-78, 42-58, 57-68) 20-23.
ASH_SAT = 15
EMBER_PHASES, EMBER_TICKS = 6, 10
PULSE = [0, 1, 2, 2, 1, 0]
N_VENTS = 4
VENT_OFFSETS = [0, 13, 26, 37]
FIDELITY_MAX = 35
MAGMA_FIDELITY_MAX = 12                   # distance max entre la rampe du magma et la lave du rip (moyenne des tons)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
MG = loadmod('magma_visqueux', R / 'source/magma_visqueux/magma.py')
GR = loadmod('magma_ground', R / 'source/magma_visqueux/ground.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
LOOP_TICKS = int(np.lcm.reduce([MG.PHASES * MG.TICKS, MG.COL_PHASES * MG.COL_TICKS, EMBER_PHASES * EMBER_TICKS]))


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


# ---------------------------------------------------------------- sol complet (miroir d'une plage de cendre du décor)
def make_sol(decor):
    y0, y1, x0, x1 = SOL_PATCH; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    grn = (g > 160) & (g > r * 1.8) & (g > b * 1.8)
    cascade = morph(nd.binary_dilation, grn, 2)
    magma = morph(nd.binary_dilation, mag, 2) & ~cascade
    # bas des cascades posé dans la mare : rangées sous le haut de la mare voisine -> magma
    lab, n = nd.label(cascade)
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i); x0, x1 = xs.min(), xs.max()
        side = magma[:, max(0, x0 - 30):x0].any(1) | magma[:, x1 + 1:x1 + 31].any(1)
        rows = np.nonzero(side)[0]
        if len(rows):
            top = rows.min() + 8
            m = (lab == i); m[:top] = False; magma |= m; cascade &= ~m
    wet = magma | cascade
    Sm = nd.uniform_filter(sat.astype(float), 11)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    box = (yy > 120) & (yy < 250) & (xx > 520) & (xx < 680)
    mouth = nd.binary_fill_holes(morph(nd.binary_closing, box & (lum < 32), 2))
    mouth = keep_large(mouth, 800)
    ash = (Sm < ASH_SAT) & ~morph(nd.binary_dilation, wet, 3) & ~mouth
    ash = morph(nd.binary_opening, ash, 2)
    ash = keep_large(ash, 4000)
    ash = nd.binary_fill_holes(ash | wet | mouth) & ~wet & ~mouth
    holes = ~ash & ~wet & ~mouth
    small = holes & ~keep_large(holes, 900)                          # cailloux isolés dans la cendre -> cendre
    ash |= small
    rock = ~ash & ~wet & ~mouth
    ember = (r > 170) & (g > 60) & (g < 200) & (b < 90) & (r > b + 100) & rock   # seuil des braises de ECN1
    return dict(magma=magma, cascade=cascade, ash=ash, rock=rock, mouth=mouth), ember


def fill_behind_cascades(layers, cascade, names=('falaises', 'cendre')):
    """Décor derrière la lame : le rectangle vert du brut est regarni en miroir du décor voisin (falaise ou cendre
    générées), rangée par rangée, dans le calque des falaises (non praticable), seulement si les deux côtés sont du décor
    (pas de magma) ; la lame de la cascade serpente devant."""
    src = np.zeros((H, W), int) - 1
    for k, nm in enumerate(names):
        src[(layers[nm][..., 3] == 255) & (src < 0)] = k
    lab, n = nd.label(cascade)
    for i in range(1, n + 1):
        m = lab == i
        for y in np.nonzero(m.any(1))[0]:
            xs = np.nonzero(m[y])[0]; x0, x1 = xs.min(), xs.max(); w = x1 - x0 + 1; hl = (w + 1) // 2; hr = w - hl
            if x0 - hl < 0 or x1 + hr >= W or (src[y, x0 - hl:x0] < 0).any() or (src[y, x1 + 1:x1 + 1 + hr] < 0).any():
                continue
            pairs = [(x0 + j, x0 - 1 - j) for j in range(hl)] + [(x1 - j, x1 + 1 + j) for j in range(hr)]
            for dst, sx in pairs:
                layers[names[0]][y, dst] = layers[names[src[y, sx]]][y, sx]   # décor fixe non praticable


def ember_frames(a, ember_full, ember):
    lum_e = JM.down_class(a, {'e': ember_full}, ['e'])[1]['e'].astype(float) @ [.299, .587, .114]
    rank = np.clip(np.digitize(lum_e, np.percentile(lum_e[ember], [33, 66])), 0, 2) if ember.any() else np.zeros((H, W), int)
    ramp = [MG.PAL[i] for i in (3, 5, 7, 9, 11)]
    out = []
    for t in range(EMBER_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + PULSE[t], 0, 4)
        for i, c in enumerate(ramp):
            e[ember & (idx == i)] = (*c, 255)
        out.append(e)
    return out, ramp


def pick_vents(visible, dist, feet):
    """Évents : magma visible à > 20 px de la rive, loin des pieds de cascade et entre eux (tirage glouton)."""
    yy, xx = np.mgrid[:H, :W]
    cand = visible & (dist > 20) & (yy > 160) & (yy < H - 24) & (xx > 24) & (xx < W - 24) & (yy % 4 == 0) & (xx % 4 == 0)
    pts = np.argwhere(cand)
    chosen = []
    anchors = [(fy, fx) for fx, fy in feet]
    for _ in range(N_VENTS):
        ref = np.array(anchors + chosen, float)
        dmin = np.sqrt(((pts[:, None, :] - ref[None]) ** 2).sum(-1)).min(1)
        score = np.minimum(dmin, 150) + 0.15 * dist[pts[:, 0], pts[:, 1]]
        y, x = pts[int(np.argmax(score))]; chosen.append((int(y), int(x)))
    chosen.sort(key=lambda p: (p[1], p[0]))
    return [{'x': x, 'y': y, 'h': int(min(112, y - 30)), 'decalage': VENT_OFFSETS[i]} for i, (y, x) in enumerate(chosen)]


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    assert (f == make_sol(a)).all(), 'sol_complet.png doit être le miroir de SOL_PATCH'
    m, ember_full = classify(a)
    order = ['magma', 'cascade', 'ash', 'rock', 'mouth']
    ex, cols = JM.down_class(a, m, order)
    wet = ex['magma'] | ex['cascade']
    names = {'ash': 'cendre', 'rock': 'falaises', 'mouth': 'bouche_grotte'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~wet)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    fill_behind_cascades(layers, ex['cascade'])
    land = np.zeros((H, W), bool)
    for nm in names.values():
        land |= layers[nm][..., 3] == 255
    visible = ex['magma'] & ~land
    feet = MG.cascade_feet(ex['cascade'])
    under = visible | ex['cascade']                                   # sous la cascade : visible au pied déchiqueté
    mf, dist, midx = MG.magma_phases(ex['magma'] | ex['cascade'], under, feet=feet, drift=(0, 1), seed=3)
    cf, cidx = MG.cascade_phases(ex['cascade'], seed=11)
    vents = pick_vents(visible, dist, feet)
    colf = MG.column_frames(H, W, vents)
    ember = JM.down_class(a, {'e': ember_full, 'n': ~ember_full}, ['e', 'n'])[0]['e'] & ex['rock']
    ef, ramp = ember_frames(a, ember_full, ember)
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, mf=mf, midx=midx, cf=cf, cidx=cidx,
                colf=colf, vents=vents, feet=feet, ef=ef, ramp=ramp, ember=ember, dist=dist)


def fidelity(layers):
    rip = rgb(R / REF)
    ref = rip[300:440, 60:300].reshape(-1, 3).mean(0)                   # cendre du rip
    ours = layers['cendre'][layers['cendre'][..., 3] == 255][:, :3].astype(float).mean(0)
    pit = rgb(R / REF_MAGMA); r, g, b = pit.transpose(2, 0, 1)
    lava = (r > 180) & (b < 80) & (r - b > 120)
    lava_ref = pit[lava].astype(float).mean(0)
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'ref_cendre_rgb': r1(ref), 'cendre_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'seuil': FIDELITY_MAX, 'lave_rip_rgb': r1(lava_ref)}


def magma_fidelity(frames, visible):
    """Couleur moyenne du magma chaud (hors croûte) comparée à la lave du rip de la fosse."""
    pit = rgb(R / REF_MAGMA); r, g, b = pit.transpose(2, 0, 1)
    lava_ref = pit[(r > 180) & (b < 80) & (r - b > 120)].astype(float).mean(0)
    px = np.concatenate([f[visible][:, :3] for f in frames]).astype(float)
    hot = px[px[:, 0] > 240]
    mean = hot.mean(0)
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
    for d in ['calques', 'animation/magma', 'animation/cascades', 'animation/colonnes', 'animation/braises', 'poses_colonne',
              'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    mfid = magma_fidelity(D['mf'], D['visible']); assert mfid['distance'] < MAGMA_FIDELITY_MAX, mfid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for k, p in enumerate(MG.column_poses(110)):
        Image.fromarray(p).save(OUT / 'poses_colonne' / f'{PFX}_colonne_p{k:02d}.png')
    static_order = ['sol_complet', 'cendre', 'falaises', 'bouche_grotte']
    stack_named = [('magma', D['mf'], MG.TICKS)] + [(nm, [layers[nm]], 60) for nm in static_order] + \
                  [('cascades', D['cf'], MG.TICKS), ('braises', D['ef'], EMBER_TICKS), ('colonnes', D['colf'], MG.COL_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    # ---- collisions : seule la cendre visible est praticable
    walk = layers['cendre'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]
    my, mx = np.nonzero(ex['mouth'])
    gx0, gy0 = int(mx.mean()) // 8 - 1, (int(my.max()) + 8) // 8
    seuil = None
    for dy in range(0, 12):
        for dx in sorted(range(-6, 7), key=abs):
            gy, gx = gy0 + dy, gx0 + dx
            if seuil is None and not blocked[gy:gy + 2, gx:gx + 2].any():
                seuil = [gx * 8, gy * 8]
    markers = {'entrance': entrance, 'donjon_seuil': seuil}
    ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (seuil[1] // 8, seuil[0] // 8))
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
    for k, c in (('entrance', (255, 230, 40, 255)), ('donjon_seuil', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    for v in D['vents']:
        dr.ellipse([v['x'] - 4, v['y'] - 4, v['x'] + 4, v['y'] + 4], outline=(255, 255, 255, 255), width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sheet = Image.new('RGBA', (12 * (MG.COL_W * 2 + 4), 4 * MG.COL_H * 2), (40, 30, 36, 255))
    for k, p in enumerate(MG.column_poses(110)):
        sheet.alpha_composite(Image.fromarray(p).resize((MG.COL_W * 2, MG.COL_H * 2), Image.Resampling.NEAREST),
                              ((k % 12) * (MG.COL_W * 2 + 4), (k // 12) * MG.COL_H * 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_colonne_x2.png')
    BM.write_ora(OUT / f'{PFX}_entree_cratere_magma_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    titles = {'magma': 'magma visqueux', 'cascades': 'cascades de lave', 'braises': 'braises pulsees', 'colonnes': 'colonnes de magma'}
    counts = GR.ground_project([(titles.get(t, t.replace('_', ' ')) + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                                for t, fr, tk in stack_named], blocked, markers, gfx, tools,
                               stage=STAGE, pfx=PFX, asset=ASSET, namespace=NAMESPACE, here=HERE, W=W, H=H,
                               name='Entree Cratere magma - Dark Crater V2 (4:3)',
                               comment=('PMDO 0.8.12. Entree generee 4:3 (ref. Dark Crater) ; magma visqueux, cascades de lave, '
                                        'colonnes de magma, braises pulsees. Arrivee au sud, seuil de la grotte au nord. Aucun warp.'),
                               mod_name='Entree Cratere magma (Dark Crater V2) 4:3',
                               mod_desc=("Projet d'edition : entree de cratere generee au format 4:3 (ref. Dark Crater), "
                                         "magma visqueux, deux cascades de lave, colonnes de magma qui jaillissent."))
    manifest = {
        'lot': LOT, 'biome': 'Cratere (Dark Crater)', 'version_de': 'entree_cratere_sud_nord_v1 (ECN1, conservee)',
        'demande': ["Je veux un entree de map avec magma dark crater des cascade de lave",
                    "Des colonnes de magma etc et cascade pour une version entree crater pit entree [...] faut que le magma de la zone bouge de maniere visqueuse"],
        'choix_agent': {'layout': 'arrivee au sud sur le chemin de cendre, grotte au nord, cascade de chaque cote de la grotte qui nourrit une mare de magma le long du chemin',
                        'colonnes': f'{len(D["vents"])} events dans les mares, eruptions decalees facon geyser',
                        'magma': 'motif cellulaire de la lave du rip de la fosse, derive lente, pliage, gonflements, plaques de croute'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sur magenta (mares) et vert (cascades) ; sol complet = plage de cendre du decor en miroir',
        'reference_da': [REF, REF_MAGMA + ' (rampe de lave)'],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC), 'images': [REF]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'origine': f'miroir de la plage {list(SOL_PATCH)} (y0, y1, x0, x1) du decor'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs'},
        'segmentation': {'magma': 'magenta dilate 2 px (+ bas des cascades sous le haut de la mare)', 'cascades': 'vert pur dilate 2 px',
                         'cendre': f'saturation moyenne 11 px < {ASH_SAT}, plus grandes zones, cailloux isoles rebouches',
                         'bouche': 'pixels < 32 dans la cavite', 'falaises': 'le reste', 'braises': 'orange sur roche (seuil ECN1)'},
        'fidelite': fid, 'fidelite_magma': mfid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'magma': {'phases': MG.PHASES, 'frame_length_ticks': MG.TICKS, 'palette': [list(c) for c in MG.PAL],
                  'periode_texture': list(MG.PERIOD), 'cellule': MG.CELL, 'derive': 'une periode (96 px) vers le sud par boucle',
                  'pieds_cascade': [list(p) for p in D['feet']],
                  'origine': 'module source/magma_visqueux/magma.py (bruit de Worley periodique, rampe relevee sur la lave du rip de la fosse) ; pixels calcules'},
        'cascades': {'phases': MG.PHASES, 'frame_length_ticks': MG.TICKS, 'descente': '1 periode de matiere (96 x 2,5 = 240 px) par boucle, 7,5 px par phase',
                     'origine': 'meme matiere etiree verticalement, bords de croute ondulants, pied dechiquete'},
        'colonnes': {'phases': MG.COL_PHASES, 'frame_length_ticks': MG.COL_TICKS, 'events': D['vents'],
                     'chronologie': '0-11 bouche qui palpite, 12-15 gonflement, 16-21 jaillissement, 22-31 colonne, 32-35 retombee, 22-45 gouttes, 34-43 anneau',
                     'origine': 'jet procedural en tons du rip ; dessin cree, pas une animation officielle'},
        'braises': {'phases': EMBER_PHASES, 'frame_length_ticks': EMBER_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in D['ramp']],
                    'pixels': int(D['ember'].sum()), 'origine': 'pixels orange du decor genere ; methode des braises de ECN1'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemin_16x16': {'ok': ok, 'cases_explorees': explored},
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'rule': 'case bloquee si > 25 % hors cendre'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'magma': mfid, 'markers': markers, 'vents': D['vents'], 'feet': D['feet'],
                      'embers': int(D['ember'].sum()), 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
