"""Fin Waterfall Cave (FWC1) — septième zone de fin de donjon de la série des entrées : salle du joyau, 4:3 (768 x 576).

.venv/bin/python source/fin_waterfall_cave_v1/build.py

Vraie fin : Waterfall_Cave_gem_TDS.png (PMD Explorers). Après le 8e sous-sol, une grotte pleine de cristaux ; au fond, un
joyau géant. Quand on le pousse, une vague emporte les héros jusqu'aux sources chaudes. Il n'y a pas de boss.

- Décor : rendu généré référencé, eau en magenta, en deux étapes :
  1) décor 4:3 avec la capture (bruts/decor_magenta.png) : les bassins sortaient en galets ;
  2) édition à un seul changement : bassins gauche et droit en magenta (bruts/decor_magenta_v2.png).
- Sol complet : galets seuls générés depuis une découpe propre du sol de la capture.
- Calques : sol complet, eau (anim), sol, parois, cristaux, joyau, lueur du joyau (anim), scintillements (anim).
- Eau : réseau de reflets de la capture (cellules ovales sombres bordées de lignes cyan), calculé : cellules de Worley
  arrondies (q = F1 / F2) et étirées dans 9 tons exacts de l'eau de la capture ; chaque centre de cellule tourne sur un petit cercle, le réseau
  ondule sur place sans défiler, boucle fermée 24 x 10. Aucun liseré sur les rives.
- Joyau : rang de luminance des facettes + pulsation douce vers le rose clair, 24 x 10.
- Cristaux : étoiles de 1 à 3 px de bras qui naissent et s'éteignent sur chaque cristal, déphasées, 12 x 5.
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd
from scipy.spatial import cKDTree

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_waterfall_cave_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_waterfall_cave'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fwc1_fin_waterfall_cave'
PFX = 'FWC1'
REF = 'Waterfall_Cave_gem_TDS.png'
SOL_REF_CROP = (225, 270, 275, 300)        # galets propres de la capture, donnés x4 au générateur
WATER_REF_CROP = (10, 160, 150, 245)       # bassin gauche de la capture
PATH_REF_CROP = (225, 340, 275, 420)       # chemin sombre d'arrivée de la capture

W, H = 768, 576
SRC = (1200, 896)
WATER_PHASES, WATER_TICKS = 24, 10
GLOW_PHASES, GLOW_TICKS = 24, 10
SPARK_PHASES, SPARK_TICKS = 12, 5
SPARK_SEQ = [1, 2, 3, 3, 2, 1, 0, 0, 0, 0, 0, 0]   # longueur des bras (0 = éteinte)
LOOP_TICKS = 240
FIDELITY_MAX = 35
WATER_FIDELITY_MAX = 15
# Eau : cellules ~34 x 20 px comme la capture ; métrique étirée (y x 1,6) pour des ovales couchés.
CELL = (34, 20)
ASPECT = CELL[0] / CELL[1]
ORBIT = (1.5, 3.5)                          # rayon du petit cercle de chaque centre (px)
# Tons de l'eau de la capture (comptés sur WATER_REF_CROP), du trait au fond de la cellule.
W_JUNCTION = (95, 159, 207)
W_LINE = (63, 143, 199)
W_EDGE = (23, 135, 191)
W_HALO = (0, 111, 183)
W_NEAR = [(0, 95, 135), (0, 87, 143)]
W_DEEP = [(0, 79, 119), (0, 71, 127), (0, 63, 111)]
Q_LINE, Q_EDGE, Q_HALO, Q_NEAR, Q_JUNC = 0.93, 0.86, 0.77, 0.66, 0.8   # seuils sur q = F1 / F2 (cercles d'Apollonius : cellules rondes)
# Seuils (mesures sur le brut) : sol (61, 97, 132) B - G ~ 35 ; chemin sombre (60, 56, 77) ; rochers B - G < 20 ;
# joyau (217, 67, 167) ; magenta pur (> 200, < 90, > 200).
PULSE = [int(round(1 - np.cos(2 * np.pi * t / GLOW_PHASES))) for t in range(GLOW_PHASES)]   # 0 -> 2 -> 0


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
assert all(LOOP_TICKS % (p * t) == 0 for p, t in ((WATER_PHASES, WATER_TICKS), (GLOW_PHASES, GLOW_TICKS), (SPARK_PHASES, SPARK_TICKS)))


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sm(m, k):
    return nd.uniform_filter(m.astype(float), k)


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r > 200) & (b > 200) & (g < 90) & (np.abs(r - b) < 45)
    water = nd.binary_dilation(mag, iterations=2)                                  # franges comprises
    blue = (b - g > 22) & (b > 105) & (b < 170) & (r < 90)
    path = (np.abs(r - 60) < 14) & (np.abs(g - 56) < 14) & (np.abs(b - 76) < 14)
    cand = ((sm(blue, 7) > 0.55) | (sm(path, 7) > 0.6)) & ~nd.binary_dilation(water, iterations=3)
    fl = nd.binary_fill_holes(morph(nd.binary_closing, cand, 5))                   # cristaux du sol rebouchés
    fl = morph(nd.binary_opening, fl, 4)
    lab, _ = nd.label(fl); floor = np.isin(lab, [v for v in np.unique(lab[-3:]) if v])
    pink = (r > 170) & (b > 110) & (g < 150) & (r - g > 60) & ~water
    lab, n = nd.label(nd.binary_closing(pink, iterations=2)); s = nd.sum(pink, lab, range(1, n + 1))
    gem = nd.binary_dilation(nd.binary_fill_holes(lab == int(np.argmax(s)) + 1), iterations=2) & ~water   # contour sombre compris
    core = (sat > 70) & (lum > 80) & ~nd.binary_dilation(water, iterations=4) & ~nd.binary_dilation(gem, iterations=3)
    lab, n = nd.label(core); s = nd.sum(core, lab, range(1, n + 1))
    core = np.isin(lab, [i + 1 for i, v in enumerate(s) if 12 <= v <= 3000])
    crystal = nd.binary_dilation(core, iterations=2) & ~water & ~gem
    zone = floor & ~gem                                                            # sol praticable, cristaux du sol compris
    floor &= ~gem & ~crystal
    walls = ~(water | floor | crystal | gem)
    glow = gem & (lum > np.percentile(lum[gem], 25))                                # facettes (le contour reste fixe)
    return dict(water=water, floor=floor, crystal=crystal, gem=gem, walls=walls), glow, zone


# ---------------------------------------------------------------- eau : réseau de reflets
def water_sites(rng):
    ys, xs = np.mgrid[-CELL[1]:H + 2 * CELL[1]:CELL[1], -CELL[0]:W + 2 * CELL[0]:CELL[0]]
    xs = xs + (np.arange(xs.shape[0])[:, None] % 2) * CELL[0] / 2                  # rangées décalées
    p0 = np.stack([xs.ravel(), ys.ravel()], 1).astype(float)
    p0 += rng.uniform(-1, 1, p0.shape) * [CELL[0] * 0.35, CELL[1] * 0.35]
    rad = rng.uniform(*ORBIT, len(p0)); phi = rng.uniform(0, 2 * np.pi, len(p0))
    return p0, rad, phi


def water_noise(rng):
    n = nd.gaussian_filter(rng.standard_normal((H, W)), (0.8, 2.5))                # traînées horizontales du fond
    return n / n.std()


def water_frame(t, sites, noise, mask):
    p0, rad, phi = sites
    th = 2 * np.pi * t / WATER_PHASES + phi
    p = p0 + np.stack([rad * np.cos(th), 0.6 * rad * np.sin(th)], 1)
    tree = cKDTree(p * [1, ASPECT])
    yy, xx = np.nonzero(mask)
    d, _ = tree.query(np.stack([xx, yy * ASPECT], 1).astype(float), k=3)
    q = d[:, 0] / d[:, 1]; qj = d[:, 0] / d[:, 2]                                  # qj : coins arrondis aux jonctions
    nz = noise[yy, xx]
    col = np.zeros((len(yy), 3), int)
    deep = np.where(nz > 1.1, 1, np.where(nz < -1.3, 2, 0))
    col[:] = np.array(W_DEEP)[deep]
    near = q > Q_NEAR; col[near] = np.array(W_NEAR)[(nz[near] > 0).astype(int)]
    col[(q > Q_HALO) | (qj > Q_HALO - 0.06)] = W_HALO
    col[(q > Q_EDGE) | (qj > Q_EDGE - 0.05)] = W_EDGE
    col[q > Q_LINE] = W_LINE
    col[(q > Q_LINE) & (qj > Q_JUNC)] = W_JUNCTION
    e = np.zeros((H, W, 4), 'uint8'); e[yy, xx, :3] = col; e[yy, xx, 3] = 255
    return e


def water_palette():
    return {W_JUNCTION, W_LINE, W_EDGE, W_HALO, *W_NEAR, *W_DEEP}


# ---------------------------------------------------------------- joyau et cristaux
def glow_frames(gem_layer, glow):
    cols = gem_layer[glow][:, :3].astype(int)
    lum = cols @ [.299, .587, .114]
    q = np.percentile(lum, [20, 40, 60, 80])
    ramp = [tuple(int(v) for v in cols[np.argmin(np.abs(lum - np.percentile(lum, p)))]) for p in (10, 30, 50, 70, 92)]
    top = np.array(ramp[-1], float)
    ramp += [tuple(int(round(v)) for v in top + (255 - top) * k) for k in (0.3, 0.55)]   # rose clair, presque blanc
    rank = np.zeros((H, W), int); rank[glow] = np.digitize(lum, q)
    out = []
    for t in range(GLOW_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + PULSE[t], 0, len(ramp) - 1)
        for i, c in enumerate(ramp):
            e[glow & (idx == i)] = (*c, 255)
        out.append(e)
    return out, ramp


def spark_frames(cr_layer, crystal, rng):
    lab, n = nd.label(crystal); stars = []
    lum = cr_layer[..., :3].astype(float) @ [.299, .587, .114]
    for i in range(1, n + 1):
        m = lab == i
        if m.sum() < 6:
            continue
        ys, xs = np.nonzero(m); k = int(np.argmax(lum[ys, xs]))
        c = tuple(int(v) for v in cr_layer[ys[k], xs[k], :3])
        stars.append({'xy': [int(xs[k]), int(ys[k])], 'phase': int(rng.integers(SPARK_PHASES)), 'teinte': list(c)})
    frames = []
    for t in range(SPARK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for s in stars:
            L = SPARK_SEQ[(t - s['phase']) % SPARK_PHASES]
            if not L:
                continue
            x, y = s['xy']; tint = tuple(s['teinte'])
            for dd in range(1, L + 1):
                c = tint if dd == L and L > 1 else (236, 244, 255)
                for dx, dy in ((dd, 0), (-dd, 0), (0, dd), (0, -dd)):
                    if 0 <= x + dx < W and 0 <= y + dy < H:
                        e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255)
        frames.append(e)
    return frames, stars


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta_v2.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, glow_full, zone_full = classify(a)
    order = ['water', 'gem', 'crystal', 'floor', 'walls']
    ex, cols = JM.down_class(a, m, order)
    full = JM.down_full(a); n_speck = 0
    zone = JM.down_class(a, {'z': zone_full, 'n': ~zone_full}, ['z', 'n'])[0]['z'] & (ex['floor'] | ex['crystal'])
    lab, n = nd.label(zone); s = nd.sum(zone, lab, range(1, n + 1)); zone = lab == int(np.argmax(s)) + 1
    speck = ex['floor'] & ~zone                                                    # miettes de sol hors du chemin -> parois
    if speck.any():
        ex['floor'] &= ~speck; ex['walls'] |= speck; cols['walls'][speck] = full[speck]; n_speck = int(speck.sum())
    names = {'floor': 'sol', 'walls': 'parois'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool))}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    for k, nm, nc in (('crystal', 'cristaux', 32), ('gem', 'joyau', 24)):             # palettes propres (couleurs saturées)
        e = JM.rgba(cols[k], ex[k])
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~ex[k]] = 0; layers[nm] = e
    glow = JM.down_class(a, {'g': glow_full, 'n': ~glow_full}, ['g', 'n'])[0]['g'] & ex['gem']
    gf, ramp = glow_frames(layers['joyau'], glow)
    rng = np.random.default_rng(11)
    sites = water_sites(rng); noise = water_noise(rng)
    wf = [water_frame(t, sites, noise, ex['water']) for t in range(WATER_PHASES)]
    sf, stars = spark_frames(layers['cristaux'], ex['crystal'], np.random.default_rng(3))
    return dict(a=a, m=m, ex=ex, zone=zone, layers=layers, wf=wf, gf=gf, ramp=ramp, glow=glow, sf=sf, stars=stars, n_speck=n_speck)


def fidelity(layers, wf):
    rip = rgb(R / REF)
    out = {}
    sol = layers['sol'][layers['sol'][..., 3] == 255][:, :3].astype(int)
    blue = sol[:, 2] - sol[:, 1] > 18                                               # galets bleus / chemin sombre violacé
    parts = {'galets': (sol[blue], SOL_REF_CROP), 'chemin': (sol[~blue], PATH_REF_CROP),
             'sol_complet': (layers['sol_complet'][..., :3].reshape(-1, 3), SOL_REF_CROP)}
    for nm, (px, crop) in parts.items():
        x0, y0, x1, y1 = crop
        ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0); ours = px.astype(float).mean(0)
        out[nm] = {'ref_rgb': [round(float(v), 1) for v in ref], 'rgb': [round(float(v), 1) for v in ours], 'pixels': int(len(px)),
                   'distance': round(float(np.linalg.norm(ref - ours)), 2), 'decoupe_ref': list(crop)}
    x0, y0, x1, y1 = WATER_REF_CROP
    wr = rip[y0:y1, x0:x1].reshape(-1, 3); pal = np.array(sorted(water_palette()))
    keep = np.sqrt(((wr[:, None] - pal[None]) ** 2).sum(-1)).min(1) == 0              # tons d'eau seuls (pas les rochers)
    ref = wr[keep].mean(0)
    ours = np.concatenate([f[f[..., 3] == 255][:, :3] for f in wf]).astype(float).mean(0)
    out['eau'] = {'ref_rgb': [round(float(v), 1) for v in ref], 'rgb': [round(float(v), 1) for v in ours],
                  'distance': round(float(np.linalg.norm(ref - ours)), 2), 'decoupe_ref': list(WATER_REF_CROP),
                  'part_tons_capture': round(float(keep.mean()), 3)}
    out['seuil'] = FIDELITY_MAX; out['seuil_eau'] = WATER_FIDELITY_MAX
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['arene'],
                                                'source': markers['joyau']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Waterfall Cave - salle du joyau (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Waterfall_Cave_gem_TDS) ; chemin de galets et cristaux entre deux bassins, '
                    'joyau geant au nord ; eau a reseau de reflets, joyau qui pulse et cristaux qui scintillent. Arrivee au sud, arene, joyau. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'arene', 'source': 'joyau'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Waterfall Cave (salle du joyau) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (ref. Waterfall Cave, salle du joyau), eau a reseau de reflets, joyau qui pulse, cristaux qui scintillent")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/eau', 'animation/lueur_joyau', 'animation/scintillements', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers, D['wf'])
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in ('galets', 'chemin', 'sol_complet')), fid
    assert fid['eau']['distance'] < WATER_FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['zone'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('eau', D['wf'], WATER_TICKS), ('sol', [layers['sol']], 60),
                   ('parois', [layers['parois']], 60), ('cristaux', [layers['cristaux']], 60), ('joyau', [layers['joyau']], 60),
                   ('lueur_joyau', D['gf'], GLOW_TICKS), ('scintillements', D['sf'], SPARK_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = D['zone'].copy()                                                         # sol + cristaux du sol
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]

    def free_near(x, y):
        for dy in range(0, 30):
            for dx in sorted(range(-12, 13), key=abs):
                for sy in (1, -1):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if 0 <= gy < gh_ - 1 and 0 <= gx < gw_ - 1 and not blocked[gy:gy + 2, gx:gx + 2].any():
                        return [gx * 8, gy * 8]
    arena = walk & (np.mgrid[:H, :W][0] < H - 170)
    fy, fx = np.nonzero(arena)
    arene = free_near(int(fx.mean()), int(fy.mean()))
    gy_, gx_ = np.nonzero(ex['gem'])
    joyau = free_near(int(gx_.mean()) - 8, (int(gy_.max()) + 8) // 8 * 8)          # au pied du joyau, au sud
    markers = {'entrance': entrance, 'arene': arene, 'joyau': joyau}
    paths = {}
    for k in ('arene', 'joyau'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'eau': WATER_TICKS, 'lueur_joyau': GLOW_TICKS, 'scintillements': SPARK_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('arene', (255, 80, 200, 255)), ('joyau', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_waterfall_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Waterfall Cave',
        'entree_correspondante': ['entree_waterfall_cave_sud_nord_v1', 'entree_waterfall_cave_sud_nord_v2', 'entree_waterfall_cave_sud_nord_v3'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'poursuis !', 'continue !'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Waterfall Cave apres Jungle',
                        'layout': 'comme la vraie salle du joyau : chemin de galets seme de cristaux entre deux bassins, joyau geant au nord, '
                                  'stalactites sur fond bordeaux ; arrivee au sud, aucune sortie',
                        'boss': 'aucun dans le jeu : pousser le joyau declenche une vague qui emporte les heros (Bulbapedia, Explorers of Sky chapitre 5) ; '
                                'marqueur arene au centre, marqueur joyau au pied du joyau',
                        'animations': 'eau a reseau de reflets (calcul), pulsation du joyau, scintillement des cristaux'},
        'reference_fin': 'https://bulbapedia.bulbagarden.net/wiki/Walkthrough:Pok%C3%A9mon_Mystery_Dungeon:_Explorers_of_Sky/Chapter_5',
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet avec eau en magenta, en deux etapes avec la capture ; sol complet genere depuis une decoupe des galets',
        'reference_da': [REF],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': [REF], 'etape': 1, 'utilise': False, 'raison': 'bassins peints en galets, magenta seulement aux bords'},
                       {'file': f'source/{LOT}/bruts/decor_magenta_v2.png', 'sha256': sha(RAW / 'decor_magenta_v2.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/bruts/decor_magenta.png'], 'etape': 2, 'utilise': True,
                        'consigne': 'un seul changement : bassins gauche et droit en magenta pur, sans liseré'},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP)) + ' x4'], 'utilise': True}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs (sol complet, sol, parois) ; '
                                     'cristaux 32 et joyau 24 couleurs propres ; eau calculee dans les tons de la capture',
                          'miettes_vers_parois_px': D['n_speck']},
        'segmentation': {'eau': 'magenta pur (R, B > 200, G < 90), dilate 2 px',
                         'sol': 'galets bleus (B - G > 22, 105 < B < 170, R < 90) ou chemin sombre (60, 56, 76) +- 14, lisses 7 px, '
                                'fermes 5, trous rebouches, ouverts 4, composante reliee au bas',
                         'joyau': 'rose (R > 170, B > 110, G < 150, R - G > 60) hors eau, plus grande composante, dilate 2 px',
                         'cristaux': 'sat > 70 et lum > 80, 12 a 3000 px, dilates 2 px',
                         'parois': 'le reste',
                         'praticable': 'sol ferme et rebouche (cristaux du sol compris) moins le joyau, plus grande composante'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'eau': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'cellule_px': list(CELL), 'orbite_px': list(ORBIT),
                'seuils_q': {'trait': Q_LINE, 'bord': Q_EDGE, 'halo': Q_HALO, 'proche': Q_NEAR, 'jonction': Q_JUNC},
                'palette': [list(c) for c in sorted(water_palette())], 'graine': 11,
                'loi': 'centres p = p0 + r (cos, 0,6 sin)(2 pi t / 24 + phi) ; q = F1 / F2 et qj = F1 / F3 en metrique y x 1,7 (cellules rondes) ; '
                       'tons par seuils sur q (halo et bord aussi sur qj - 0,06 / - 0,05) ; fond de cellule : bruit fixe etire (traînees)',
                'origine': 'calcule ; tons exacts de l eau de la capture'},
        'lueur_joyau': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in D['ramp']],
                        'pixels': int(D['glow'].sum()), 'origine': 'facettes du joyau (lum > 25e centile), rang de luminance + pulsation'},
        'scintillements': {'phases': SPARK_PHASES, 'frame_length_ticks': SPARK_TICKS, 'bras': SPARK_SEQ, 'etoiles': D['stars'],
                           'origine': 'calcule : centre blanc, bras bleu tres clair, bout du bras dans la teinte du cristal'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol (cristaux du sol praticables)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    np.save(R / '.cache' / LOT / 'walk.npy', walk)
    print(json.dumps({'fidelite': fid, 'markers': markers, 'etoiles': len(D['stars']), 'glow': int(D['glow'].sum()),
                      'miettes': D['n_speck'], 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
