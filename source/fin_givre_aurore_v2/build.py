"""Fin Givre V2 (FGG2) — fin de Frosty Grotto 4:3 sans cristal, ouverte au nord sur des aurores boréales.

.venv/bin/python source/fin_givre_aurore_v2/build.py

Demande : « Il faut pas de cristal stp et on aurait aimé voir les aurore boreal dans le design texture canonique
de la référence adapté a notre layout ».

- Layout de FGG1 gardé : couloir au sud, arène (boss), deux bassins d'eau glacée. FGG1 reste intact.
- Décor : le brut de FGG1 édité par le générateur (images = [brut FGG1, aurorepmdsky.png]) : cristal et monticule
  retirés, sol et rebord continués ; le nord s'ouvre sur un ciel VERT PUR (clé, le magenta étant déjà les bassins)
  derrière une rangée de pics sombres comme ceux du bas de la référence.
- Aurore : rendu généré RÉFÉRENCÉ (images = [toile marine 4:1, aurorepmdsky.png y 0-144 x3]) : panorama de rideaux
  en flammes, sommets vert menthe / cyan -> magenta -> franges cyan, sur le marine même du ciel de la référence.
  Extraction par distance au fond uni, réduction pondérée par le masque, palette propre de 48 couleurs.
- Calques séparés : ciel (dégradé aux couleurs de la référence), étoiles (scintillent), aurore (animée), terrain.
- Animation de l'aurore, UNE seule géométrie (pas de poses déphasées, pas de cycle de palette global, pas de défilement) :
  onde verticale des colonnes qui court le long du ruban (3 px, 256 px) + rayons qui s'allument en bande glissante
  (rang de luminance +1/+2 dans la rampe de la famille de couleur). 12 phases x 10 ticks, boucle exacte.
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_givre_aurore_v2'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_givre_aurore'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fgg2_fin_givre_aurore'
PFX = 'FGG2'
REF = 'pmdskyicearena.png'
REF_AUR = 'aurorepmdsky.png'
REF_AUR_CROP = (0, 0, 264, 144)            # zone des rideaux de la référence (les pics et nuages commencent à y 144)
REF_FIN = 'reference/Rescue_Team_-_Articuno_first_appearance_120px.png'
FGG1_RAW = 'source/fin_givre_grotte_v1/bruts/decor_magenta.png'

W, H = 768, 576
SRC = (1200, 896)
SOL_REF_CROP = (0, 222, 504, 282)
WATER_PHASES, WATER_TICKS = 4, 10
FLAKE_PHASES, FLAKE_TICKS = 48, 5
AUR_PHASES, AUR_TICKS = 12, 10
LOOP_TICKS = 240
N_FLAKES = 64
FLOOR_L, FLOOR_S = 195, 4
FLOOR_RGB, FLOOR_DIST = np.array([190, 214, 245]), 22
FIDELITY_MAX = 35
# Aurore
AUR_BG_DIST = 15                           # distance au marine uni du brut (fond mesuré (2, 3, 67))
AUR_COLORS = 48
AUR_Y0 = -24                               # le haut des rideaux sort du cadre comme dans la référence
UND_AMP, UND_LAMBDA = 3, 256               # onde des colonnes : amplitude px, longueur d'onde (768 / 3)
RAY_LAMBDA = 128                           # bande de rayons allumés (768 / 6)
RAY_JITTER, RAY_SEED = 0.35, 5             # seuil décalé par colonne (fixe dans le temps) -> la bande s'effiloche en rayons
AUR_FIDELITY_MAX = 30
# Ciel : couleurs relevées dans aurorepmdsky.png (fond (0, 0, 63), halo (0, 15, 79), bas du ciel (0, 36, 88))
SKY_BANDS = [(0, (0, 0, 63)), (78, (0, 15, 79)), (118, (0, 36, 88))]
N_STARS = 36
STAR_SEQ = [0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0]   # niveau de scintillement sur les 12 phases (décalé par étoile)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
EG = loadmod('egn1_givre', R / 'source/entree_givre_sud_nord_v1/build.py')
EG.W, EG.H = W, H
EG.cr.W, EG.cr.H = W, H
EG.N_FLAKES = N_FLAKES
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


# ---------------------------------------------------------------- décor
def sky_key(a):
    r, g, b = a.transpose(2, 0, 1)
    return (g > r + 60) & (g > b + 60)


def untint(a, sky):
    """Liseré vert des pics contre la clé : pixels verdâtres à moins de 4 px du ciel -> G et B échangés (marine des contours)."""
    a = a.copy(); r, g, b = a.transpose(2, 0, 1)
    near = nd.binary_dilation(sky, iterations=4) & ~sky & (g > b)
    a[near] = a[near][:, [0, 2, 1]]
    return a, int(near.sum())


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    sky = sky_key(a)
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    water = nd.binary_dilation(mag, iterations=2)
    L = nd.uniform_filter(lum, 11); Sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 11) - L ** 2, 0))
    near = np.sqrt(((a - FLOOR_RGB) ** 2).sum(-1)) < FLOOR_DIST
    core = ((L > FLOOR_L) & (Sd < FLOOR_S) | near) & ~nd.binary_dilation(water, iterations=3) & ~sky
    core = morph(nd.binary_opening, core, 2)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = morph(nd.binary_closing, lab == int(np.argmax(sizes)) + 1, 7)
    floor = nd.binary_fill_holes(floor | water) & ~water & ~sky
    floor = morph(nd.binary_opening, floor, 2)
    lab, n = nd.label(floor); sizes = nd.sum(floor, lab, range(1, n + 1)); floor = lab == int(np.argmax(sizes)) + 1
    walls = ~floor & ~water & ~sky
    return dict(sky=sky, water=water, floor=floor, walls=walls)


# ---------------------------------------------------------------- ciel, étoiles
def sky_layer(mask):
    yy, xx = np.mgrid[:H, :W]
    idx = np.zeros((H, W), int)
    for i, (y0, _) in enumerate(SKY_BANDS[1:], 1):
        idx[yy >= y0] = i
        band = (yy >= y0 - 4) & (yy < y0)                     # tramage 2 x 2 sur 4 px à chaque passage (façon DS)
        idx[band & ((xx + yy) % 2 == 0)] = i
    e = np.zeros((H, W, 4), 'uint8')
    for i, (_, c) in enumerate(SKY_BANDS):
        e[mask & (idx == i)] = (*c, 255)
    return e


def star_colors():
    """Étoiles de la référence : 1 px clair entouré d'un halo sombre -> couleur claire et couleur du halo (la plus fréquente)."""
    r = rgb(R / REF_AUR)
    x0, y0, x1, y1 = REF_AUR_CROP; r = r[y0:y1, x0:x1]
    lum = r @ [.299, .587, .114]
    bright = lum > 200
    lab, n = nd.label(bright); sizes = nd.sum(bright, lab, range(1, n + 1))
    hi_px, halo = [], []
    for i in range(n):
        if sizes[i] > 2:
            continue
        me = lab == i + 1; ring = nd.binary_dilation(me) & ~me
        if lum[ring].max() < 110:
            hi_px += [tuple(int(v) for v in c) for c in r[me]]; halo += [tuple(int(v) for v in c) for c in r[ring]]
    assert hi_px, 'aucune etoile isolee dans la reference'
    hi = max(set(hi_px), key=hi_px.count); lo = max(set(halo), key=halo.count)
    return hi, lo, len(hi_px)


def star_frames(visible, rng):
    hi, lo, n_ref = star_colors()
    ok = nd.binary_erosion(visible, iterations=3)
    ys, xs = np.nonzero(ok); stars = []; taken = np.zeros((H, W), bool)
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x]:
            continue
        stars.append({'xy': [x, y], 'phase': int(rng.integers(AUR_PHASES)), 'grande': bool(rng.random() < 0.35)})
        taken[max(0, y - 14):y + 15, max(0, x - 14):x + 15] = True
        if len(stars) == N_STARS:
            break
    frames = []
    for t in range(AUR_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for s in stars:
            x, y = s['xy']; lv = STAR_SEQ[(t + s['phase']) % AUR_PHASES] if s['grande'] else min(1, STAR_SEQ[(t + s['phase']) % AUR_PHASES])
            e[y, x] = (*(hi if lv else lo), 255)
            if lv == 2:
                for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    e[y + dy, x + dx] = (*lo, 255)
        e[~visible] = 0
        frames.append(e)
    return frames, stars, {'claire': list(hi), 'douce': list(lo), 'etoiles_isolees_dans_la_reference': n_ref}


# ---------------------------------------------------------------- aurore
def aurora_base():
    a = rgb(RAW / 'aurore_panorama_marine.png')
    vals, cnt = np.unique(a.reshape(-1, 3), axis=0, return_counts=True); bg = vals[np.argmax(cnt)]
    m = np.sqrt(((a - bg) ** 2).sum(-1)) > AUR_BG_DIST
    lab, n = nd.label(m); sizes = nd.sum(m, lab, range(1, n + 1))
    m = np.isin(lab, [i + 1 for i, s in enumerate(sizes) if s >= 30])     # poussière isolée écartée
    h = round(a.shape[0] * W / a.shape[1])
    mf = m.astype(float)
    ms = np.array(Image.fromarray((mf * 255).astype('uint8')).resize((W, h), Image.BOX)).astype(float) / 255
    ch = [np.array(Image.fromarray(np.clip(a[..., k] * mf, 0, 255).astype('uint8')).resize((W, h), Image.BOX)).astype(float) for k in range(3)]
    al = ms >= 0.5
    col = np.stack(ch, -1) / np.maximum(ms, 1e-6)[..., None]
    col = np.clip(np.round(col), 0, 255).astype('uint8'); col[~al] = 0
    q = Image.fromarray(col).quantize(colors=AUR_COLORS, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:AUR_COLORS * 3]).reshape(-1, 3)
    idx = np.array(q)
    used = sorted(set(np.unique(idx[al]).tolist()))
    return idx, al, pal, used, [int(v) for v in bg], tuple(a.shape[1::-1])


def ramps(pal, used):
    """Deux familles (vert-cyan : G >= R ; magenta-violet : R > G), triées par luminance -> rang par couleur."""
    lum = lambda c: c @ [.299, .587, .114]
    fam = {'vert_cyan': [i for i in used if pal[i][1] >= pal[i][0]], 'magenta': [i for i in used if pal[i][1] < pal[i][0]]}
    fam = {k: sorted(v, key=lambda i: lum(pal[i])) for k, v in fam.items()}
    up = {}
    for k, v in fam.items():
        for r_, i in enumerate(v):
            up[i] = [v[min(r_ + s, len(v) - 1)] for s in range(3)]
    return fam, up


def aurora_frames(idx, al, pal, used, sky_vis):
    fam, up = ramps(pal, used)
    lut = np.zeros((3, len(pal)), int)
    for i in range(len(pal)):
        lut[:, i] = up.get(i, [i, i, i])
    h = idx.shape[0]; xs = np.arange(W)
    jit = np.random.default_rng(RAY_SEED).uniform(-RAY_JITTER, RAY_JITTER, W)   # seuil propre à chaque colonne : bords en rayons
    frames = []
    for t in range(AUR_PHASES):
        dy = np.round(UND_AMP * np.sin(2 * np.pi * (xs / UND_LAMBDA - t / AUR_PHASES))).astype(int)
        w = np.cos(2 * np.pi * (xs / RAY_LAMBDA - t / AUR_PHASES))
        sh = np.where(w + jit > 0.85, 2, np.where(w + jit > 0.45, 1, 0))
        e = np.zeros((H, W, 4), 'uint8')
        for x in xs:
            col = lut[sh[x]][idx[:, x]]
            ys = np.arange(h) + AUR_Y0 + dy[x]
            ok = al[:, x] & (ys >= 0) & (ys < H)
            e[ys[ok], x, :3] = pal[col[ok]]; e[ys[ok], x, 3] = 255
        e[~sky_vis] = 0
        frames.append(e)
    return frames, fam


def aurora_fidelity(base, frame0):
    """Texture : aurore entière réduite (avant découpe par le ciel) contre les rideaux de la référence ; la part visible est notée."""
    r = rgb(R / REF_AUR); x0, y0, x1, y1 = REF_AUR_CROP; r = r[y0:y1, x0:x1]
    d = np.sqrt(((r - np.array([0, 0, 63])) ** 2).sum(-1)) > 40
    lab, n = nd.label(d); sizes = nd.sum(d, lab, range(1, n + 1))
    d = np.isin(lab, [i + 1 for i, s in enumerate(sizes) if s > 6])       # étoiles écartées
    ref = r[d].astype(float); ours = base.astype(float); vis = frame0[frame0[..., 3] == 255][:, :3].astype(float)
    share = lambda v: float((v[:, 1] >= v[:, 0]).mean())
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'ref_aurore_rgb': r1(ref.mean(0)), 'aurore_rgb': r1(ours.mean(0)),
            'distance': round(float(np.linalg.norm(ref.mean(0) - ours.mean(0))), 2),
            'part_vert_cyan_ref': round(share(ref), 3), 'part_vert_cyan': round(share(ours), 3), 'seuil': AUR_FIDELITY_MAX,
            'visible_dans_le_ciel': {'aurore_rgb': r1(vis.mean(0)), 'distance': round(float(np.linalg.norm(ref.mean(0) - vis.mean(0))), 2),
                                     'part_vert_cyan': round(share(vis), 3), 'pixels': int(len(vis))}}


# ---------------------------------------------------------------- calcul
def make_all():
    a0 = rgb(RAW / 'decor_magenta_ciel_vert.png'); f = rgb(RAW / 'sol_complet.png')
    assert a0.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    a, n_untint = untint(a0, sky_key(a0))
    m = classify(a)
    order = ['sky', 'water', 'floor', 'walls']
    ex, cols = JM.down_class(a, m, order)
    water, sky = ex['water'], ex['sky']
    names = {'floor': 'sol_glace', 'walls': 'parois'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~water)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    land = np.zeros((H, W), bool)
    for nm in ('sol_glace', 'parois'):
        land |= layers[nm][..., 3] == 255
    sky_vis = ~land & ~water                                              # ce que le terrain laisse voir au nord
    ys = np.nonzero(sky_vis)[0]; assert ys.max() < H // 3, ys.max()
    sky_cover = nd.binary_dilation(sky_vis, iterations=2) & ~water        # le ciel passe 2 px sous les pics
    layers['ciel'] = sky_layer(sky_cover)
    visible = water & ~land
    wf, dist = EG.water_phases(water, visible)
    fams = EG.sparkle_families(); sf = [np.zeros((H, W, 4), 'uint8') for _ in range(WATER_PHASES)]; sparkles = []
    taken = np.zeros((H, W), bool)
    for fi, (name, frames) in enumerate(fams.items()):
        hh, ww = frames[0].shape[:2]
        for (y, x) in EG.cr.place(visible & (dist > 2), (hh, ww), 2, 21 + fi, taken, core=8):
            sparkles.append({'famille': name, 'xy': [int(x), int(y)]})
            for t in range(WATER_PHASES):
                mm = frames[t][..., 3] > 0; sf[t][y:y + hh, x:x + ww][mm] = frames[t][mm]
    for fr_ in sf:
        fr_[~visible] = 0
    idx, al, pal, used, bg, raw_size = aurora_base()
    af, fam = aurora_frames(idx, al, pal, used, sky_cover)
    stf, stars, star_pal = star_frames(sky_vis, np.random.default_rng(11))
    poses = EG.flake_poses()
    ff, emitters = EG.flake_frames(poses, np.random.default_rng(7))
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, sky_vis=sky_vis, sky_cover=sky_cover,
                wf=wf, sf=sf, af=af, stf=stf, ff=ff, sparkles=sparkles, emitters=emitters, poses=poses, stars=stars,
                star_pal=star_pal, fam={k: [[int(c) for c in pal[i]] for i in v] for k, v in fam.items()}, aur_bg=bg,
                aur_raw=raw_size, aur_base=pal[idx[al]], aur_px=int(al.sum()), n_untint=n_untint)


def fidelity(layers):
    rip = rgb(R / REF)
    x0, y0, x1, y1 = SOL_REF_CROP
    ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0)
    ours = layers['sol_glace'][layers['sol_glace'][..., 3] == 255][:, :3].astype(float).mean(0)
    fin = rgb(HERE / REF_FIN)[40:80, 10:110].reshape(-1, 3).mean(0)
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'ref_sol_rgb': r1(ref), 'sol_glace_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'vignette_salle_articuno_rgb': r1(fin), 'distance_vignette': round(float(np.linalg.norm(fin - ours)), 2),
            'seuil': FIDELITY_MAX}


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['belvedere']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Givre V2 - Frosty Grotto, aurores (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (layout de FGG1 sans cristal) ; ciel du nord ouvert sur des aurores '
                    'boreales (texture de aurorepmdsky.png) animees sur leur calque, etoiles qui scintillent, eau glacee, flocons. '
                    'Arrivee au sud, arene (boss), belvedere au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'belvedere'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Givre V2 (Frosty Grotto, aurores) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (layout de Fin Givre sans cristal), aurores boreales animees au nord, etoiles, eau glacee, flocons")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_flocons']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/eau_glacee', 'animation/reflets', 'animation/etoiles', 'animation/aurore',
              'animation/flocons', 'poses_flocons', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    afid = aurora_fidelity(D['aur_base'], D['af'][0]); assert afid['distance'] < AUR_FIDELITY_MAX, afid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for k, p in D['poses'].items():
        Image.fromarray(p).save(OUT / 'poses_flocons' / f'{PFX}_{k}.png')
    stack_named = [('eau_glacee', D['wf'], WATER_TICKS), ('reflets', D['sf'], WATER_TICKS),
                   ('sol_complet', [layers['sol_complet']], 60), ('ciel', [layers['ciel']], 60),
                   ('etoiles', D['stf'], AUR_TICKS), ('aurore', D['af'], AUR_TICKS),
                   ('sol_glace', [layers['sol_glace']], 60), ('parois', [layers['parois']], 60),
                   ('flocons', D['ff'], FLAKE_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = layers['sol_glace'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]

    def free_near(x, y, down_first=True):
        for dy in range(0, 30):
            for dx in sorted(range(-12, 13), key=abs):
                for sy in ((1, -1) if down_first else (-1, 1)):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if 0 <= gy < gh_ - 1 and 0 <= gx < gw_ - 1 and not blocked[gy:gy + 2, gx:gx + 2].any():
                        return [gx * 8, gy * 8]
    arena = walk & (np.mgrid[:H, :W][0] < H - 150)
    fy, fx = np.nonzero(arena)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    col = walk[:, W // 2 - 24:W // 2 + 24].any(1)
    top = int(np.nonzero(col)[0].min())
    belvedere = free_near(W // 2 - 8, top)                                 # bord nord de l'arène, face aux aurores
    markers = {'entrance': entrance, 'boss': boss, 'belvedere': belvedere}
    paths = {}
    for k in ('boss', 'belvedere'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'eau_glacee': WATER_TICKS, 'reflets': WATER_TICKS, 'etoiles': AUR_TICKS, 'aurore': AUR_TICKS, 'flocons': FLAKE_TICKS}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // per[title]) % len(frames)] if title in per else frames[0]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    au = []
    for t in range(AUR_PHASES):                                             # aurore seule sur le ciel, 12 phases
        im = Image.fromarray(layers['ciel']); im.alpha_composite(Image.fromarray(D['stf'][t])); im.alpha_composite(Image.fromarray(D['af'][t]))
        au.append(im.crop((0, 0, W, 160)).resize((W * 2, 320), Image.NEAREST))
    au[0].save(OUT / 'review' / f'{PFX}_aurore_12phases_x2.webp', save_all=True, append_images=au[1:],
               duration=round(AUR_TICKS * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('belvedere', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_givre_aurore_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Givre (Frosty Forest -> Frosty Grotto)',
        'remplace_sans_supprimer': 'fin_givre_grotte_v1 (FGG1, gardé)',
        'demande': ['Il faut pas de cristal stp et on aurait aimé voir les aurore boreal dans le design texture canonique '
                    'de la référence adapté a notre layout'],
        'choix_agent': {'layout': 'celui de FGG1 : arrivee au sud, arene (boss), deux bassins ; cristal et monticule retires ; '
                                  'le nord s ouvre sur le ciel (belvedere face aux aurores), aucune sortie',
                        'aurore': 'rideaux de ' + REF_AUR + ' regeneres en panorama 768 px sur le marine de la reference, '
                                  'calque propre, une seule geometrie animee (onde + rayons), pas de defilement',
                        'terrain': 'couleurs de FGG1 gardees (pics clairs sous ciel de nuit, comme les pics de la reference)'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor = brut FGG1 edite (ciel = cle verte, bassins = magenta) ; aurore generee seule sur marine uni',
        'reference_da': [REF, REF_AUR, f'source/{LOT}/{REF_FIN}'],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta_ciel_vert.png', 'sha256': sha(RAW / 'decor_magenta_ciel_vert.png'),
                        'size': list(SRC), 'images': [FGG1_RAW, REF_AUR]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP))], 'origine': 'copie du brut FGG1'},
                       {'file': f'source/{LOT}/bruts/aurore_panorama_marine.png', 'sha256': sha(RAW / 'aurore_panorama_marine.png'),
                        'size': list(D['aur_raw']), 'images': ['toile marine unie 1536 x 384', f'source/{LOT}/reference/aurore_ref_y0_144_x3.png'],
                        'reference_decoupe': {'fichier': REF_AUR, 'zone': list(REF_AUR_CROP), 'agrandissement': 'x3 plus proche voisin'}}],
        'bruts_ecartes': [{'essai': 'meme panorama sur fond magenta', 'raison': 'le magenta des rideaux se confond avec la cle : extraction impossible'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'terrain : moyenne ponderee par classe (BOX), palette commune 96 couleurs ; '
                                     f'aurore : reduction {D["aur_raw"][0]} -> {W} ponderee par le masque, palette propre {AUR_COLORS} couleurs'},
        'segmentation': {'ciel': 'cle verte (G > R + 60 et G > B + 60) ; liseré verdâtre a moins de 4 px : G et B echanges '
                                 f'({D["n_untint"]} px du brut)',
                         'eau': 'magenta dilate 2 px',
                         'sol': f'(moyenne 11 px > {FLOOR_L} et ecart-type 11 px < {FLOOR_S}) ou couleur a moins de {FLOOR_DIST} de {FLOOR_RGB.tolist()}, hors ciel',
                         'parois': 'le reste'},
        'fidelite': fid, 'fidelite_aurore': afid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'ciel': {'bandes': [[y, list(c)] for y, c in SKY_BANDS], 'tramage': '2 x 2 sur 4 px a chaque passage',
                 'origine': 'couleurs relevees dans ' + REF_AUR, 'depasse_sous_les_pics_px': 2},
        'etoiles': {'phases': AUR_PHASES, 'frame_length_ticks': AUR_TICKS, 'nombre': len(D['stars']), 'sequence': STAR_SEQ,
                    'couleurs': D['star_pal'], 'placements': D['stars']},
        'aurore': {'phases': AUR_PHASES, 'frame_length_ticks': AUR_TICKS, 'pixels_base': D['aur_px'], 'y0': AUR_Y0,
                   'fond_du_brut': D['aur_bg'], 'seuil_fond': AUR_BG_DIST,
                   'onde': {'amplitude_px': UND_AMP, 'longueur_px': UND_LAMBDA, 'loi': 'dy(x,t) = round(A sin 2pi(x/L - t/12))'},
                   'rayons': {'longueur_px': RAY_LAMBDA, 'loi': 'w = cos 2pi(x/L - t/12) + j(x), j uniforme fixe par colonne ; rang +2 si > 0.85, +1 si > 0.45',
                              'jitter': RAY_JITTER, 'graine': RAY_SEED},
                   'familles': D['fam'],
                   'regles': 'une seule geometrie, pas de poses dephasees, pas de cycle de palette global, pas de defilement ; '
                             'visible seulement dans le ciel'},
        'eau_glacee': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'couleurs': {k: list(v) for k, v in EG.PAL.items()},
                       'origine': 'fonction water_phases de l entree Givre (structure riviere Metano), recalculee ; pas de tuiles natives'},
        'reflets': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'placements': D['sparkles'],
                    'origine': 'pixels Metano_Town_River_Sparkles recolores en blanc bleute (sparkle_families de EGN1)'},
        'flocons': {'phases': FLAKE_PHASES, 'frame_length_ticks': FLAKE_TICKS, 'emetteurs': D['emitters'],
                    'origine': 'planche generee de l entree Givre (bruts/flocons_poses.png), flake_poses et flake_frames de EGN1'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol de glace'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'aurore': afid, 'markers': markers, 'etoiles': len(D['stars']), 'reflets': len(D['sparkles']),
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
