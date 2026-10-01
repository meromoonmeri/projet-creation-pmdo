"""Arène de Terapagos, cristal prismatique (ATP1) — caverne de cristal de verre aux reflets du spectre, emblème Téracristal
et runes qui pulsent, 4:3 (768 x 576).

.venv/bin/python source/arene_terapagos_v1/build.py

Demande : « Fait une zone de crystal de verre qui reflette les spectre de couleur une arene pour terragos tu vois ce que je
veux dire ? avec des rune et signe qui pulse etc ». Lecture de l'agent : arène de Terapagos (le Pokémon Stellaire), au bout
du réseau Zone Zéro (après EAZ1).
- Références rendues depuis la ROM (source/outil_maps_pmdsky, recuperer_maps.py rom --only D17,D42) : D17P45A (champ de
  cristaux denses autour d'un sol lumineux à dalles hexagonales) pour les matières ; D42P42A (arène ronde, étoile au sol,
  étoiles qui scintillent) pour l'idée de l'emblème central et la loi des scintillements. Noms de lieu non affirmés.
- Rendu généré référencé : deux découpes x2. Les lignes gravées de l'emblème (étoile à 12 branches en facettes hexagonales,
  anneau) et des 14 runes (le prompt en demandait 12, le générateur en a peint 14) sont peintes en VERT PUR dans le brut, puis remplacées par des calques calculés.
- Lois : emblème = pulsation qui part du centre, couleur du spectre qui tourne autour de l'étoile ; runes = allumées l'une
  après l'autre dans le sens horaire, chacune de sa couleur ; reflets = deux bandes arc-en-ciel qui balaient les facettes
  claires des cristaux ; scintillements = loi de D42P42A (allumage d'un coup puis décroissance linéaire, grande étoile de
  17 px et petite croix de 5 px, formes relevées dans la ROM) aux tons du spectre.
- Tons du spectre : 12 teintes x 5 niveaux, arrondis aux tons 5 bits de la NDS (8 k + 7).
"""
from pathlib import Path
import colorsys, hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw, ImageSequence
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'arene_terapagos_v1'
OUT = R / 'renders' / LOT / 'ATP1'
NAMESPACE = 'arene_terapagos'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'atp1_arene_terapagos'
PFX = 'ATP1'
REFS = {'D17P45A': HERE / 'reference/D17P45A.png', 'D42P42A': HERE / 'reference/D42P42A.png'}
ROM_ANIM = HERE / 'reference/D42P42A_anim.webp'
STYLE = ['source/arene_terapagos_v1/reference/D17P45A_decoupe_x2.png',
         'source/arene_terapagos_v1/reference/D42P42A_etoile_decoupe_x2.png']
SRC = (1200, 896)
FIDELITY_MAX = 35
N_HUES, N_LEVELS = 12, 5
SAT = [0.78, 0.7, 0.58, 0.42, 0.24]
VAL = [0.5, 0.64, 0.78, 0.9, 1.0]
EMB_PHASES, EMB_TICKS = 36, 5
REF_PHASES, REF_TICKS, REF_BW = 54, 10, 60
SPK_PHASES, SPK_TICKS, N_SPARKS = 54, 10, 44
SPK_PERIODS = {'grande': 18, 'petite': 9}    # ROM : 16 et 11 images ; arrondies à des diviseurs de 54 pour boucler
LOOP_TICKS = 540
ANIM = {'reflets': REF_TICKS, 'embleme': EMB_TICKS, 'runes': EMB_TICKS, 'scintillements': SPK_TICKS}
PHASES = {'reflets': REF_PHASES, 'embleme': EMB_PHASES, 'runes': EMB_PHASES, 'scintillements': SPK_PHASES}


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
W, H = JM.W, JM.H
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def biggest(m):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return lab == (int(np.argmax(s)) + 1)


def nds(v):
    """Ton 5 bits de la NDS : 8 k + 7."""
    return int(min(255, max(7, 8 * round((v - 7) / 8) + 7)))


def spectrum():
    return np.array([[[nds(255 * c) for c in colorsys.hsv_to_rgb(h / N_HUES, SAT[l], VAL[l])] for l in range(N_LEVELS)]
                     for h in range(N_HUES)], 'uint8')


SPEC = spectrum()


# ---------------------------------------------------------------- segmentation pleine résolution
def green_lines(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    gr = (g - np.maximum(r, b) > 80) & (g > 150)
    return gr | ((g - np.maximum(r, b) > 30) & morph(nd.binary_dilation, gr, 2))           # liseré antialiasé compris


def classify(a):
    gr = green_lines(a)
    lum = a @ [.299, .587, .114]
    sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 9) - nd.uniform_filter(lum, 9) ** 2, 0))
    f = nd.binary_fill_holes(biggest(((sd < 16) & (lum > 110)) | gr))
    floor = nd.binary_fill_holes(biggest(morph(nd.binary_opening, f, 6)))
    lab, n = nd.label(gr, structure=np.ones((3, 3)))
    ys, xs = np.nonzero(gr); cy, cx = float(ys.mean()), float(xs.mean())
    comps = []
    for i, sl in enumerate(nd.find_objects(lab), 1):
        m = lab[sl] == i; yy, xx = np.nonzero(m)
        comps.append({'id': i, 'n': int(m.sum()), 'cy': float(yy.mean() + sl[0].start), 'cx': float(xx.mean() + sl[1].start),
                      'h': sl[0].stop - sl[0].start, 'w': sl[1].stop - sl[1].start})
    big = [c for c in comps if max(c['h'], c['w']) > 200]                                 # anneau et étoile
    emb = np.isin(lab, [c['id'] for c in big])
    ring_r = max(max(c['h'], c['w']) for c in big) / 2
    runes = [c for c in comps if c['n'] >= 60 and c not in big and np.hypot(c['cy'] - cy, c['cx'] - cx) > ring_r]
    for c in runes:                                                                         # sens horaire depuis le nord
        c['angle'] = float((np.degrees(np.arctan2(c['cx'] - cx, -(c['cy'] - cy))) + 360) % 360)
    runes.sort(key=lambda c: c['angle'])
    rune_lab = np.zeros(gr.shape, int)
    for k, c in enumerate(runes, 1):
        rune_lab[lab == c['id']] = k
    small = gr & ~emb & (rune_lab == 0)
    return dict(floor=floor, walls=~floor, green=gr, emb=emb, rune_lab=rune_lab, small=small, centre=(cy, cx),
                ring_r=ring_r, runes=runes)


def inpaint_green(a, gr, floor):
    """Sol sous les gravures : ton du pixel de sol non gravé le plus proche."""
    src = floor & ~morph(nd.binary_dilation, gr, 1)
    _, (iy, ix) = nd.distance_transform_edt(~src, return_indices=True)
    out = a.copy(); m = gr | (morph(nd.binary_dilation, gr, 1) & floor)
    out[m] = a[iy[m], ix[m]]
    return out


def sol_patch(a, floor, target):
    best = None; ii = nd.uniform_filter(floor.astype(float), 96)
    for y0 in range(0, SRC[1] - 96, 8):
        for x0 in range(0, SRC[0] - 96, 8):
            if ii[y0 + 48, x0 + 48] < 0.999:
                continue
            p = a[y0:y0 + 96, x0:x0 + 96].reshape(-1, 3)
            sc = float(np.abs(p.mean(0) - target).sum()) + float(p.std(0).mean())
            if best is None or sc < best[0]:
                best = (sc, y0, x0)
    return (best[1], best[1] + 96, best[2], best[2] + 96)


def make_sol(decor, patch):
    y0, y1, x0, x1 = patch; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- lois animées
def pulse_level(i):
    return int(np.clip(np.round(4 * i), 0, 4))


def emblem_frames(emb, floor, centre, radius):
    cy, cx = centre; yy, xx = np.mgrid[:H, :W]
    ang = (np.arctan2(yy - cy, xx - cx) / (2 * np.pi)) % 1; rad = np.hypot(yy - cy, xx - cx) / radius
    d1 = morph(nd.binary_dilation, emb, 1) & floor & ~emb
    d2 = morph(nd.binary_dilation, emb, 2) & floor & ~emb & ~d1
    frames = []
    for t in range(EMB_PHASES):
        I = 0.5 - 0.5 * np.cos(2 * np.pi * (t / EMB_PHASES - 0.5 * rad))                 # onde qui part du centre
        L = np.clip(np.round(4 * I), 0, 4).astype(int)
        hue = (np.floor(N_HUES * (ang + t / EMB_PHASES)) % N_HUES).astype(int)           # le spectre tourne
        e = np.zeros((H, W, 4), 'uint8')
        e[emb, :3] = SPEC[hue[emb], L[emb]]; e[emb, 3] = 255
        Ld = nd.grey_dilation(np.where(emb, L, 0), size=3)
        h1 = d1 & (Ld >= 3); e[h1, :3] = SPEC[hue[h1], np.maximum(Ld[h1] - 3, 0)]; e[h1, 3] = 255
        Ld2 = nd.grey_dilation(np.where(emb, L, 0), size=5)
        h2 = d2 & (Ld2 >= 4); e[h2, :3] = SPEC[hue[h2], 0]; e[h2, 3] = 255
        frames.append(e)
    return frames


def rune_frames(rune_lab, floor, n):
    d1 = {}
    frames = []
    for k in range(1, n + 1):
        m = rune_lab == k
        d1[k] = (m, morph(nd.binary_dilation, m, 1) & floor & ~(rune_lab > 0))
    for t in range(EMB_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for k in range(1, n + 1):
            m, halo = d1[k]
            age = (t - round((k - 1) * EMB_PHASES / n)) % EMB_PHASES
            I = max(0.25, 1 - age / 12)                                                    # s'allume puis s'éteint
            L = pulse_level(I); h = (k - 1) % N_HUES
            e[m, :3] = SPEC[h, L]; e[m, 3] = 255
            if L >= 3:
                e[halo, :3] = SPEC[h, L - 3]; e[halo, 3] = 255
        frames.append(e)
    return frames


def reflect_frames(walls_layer, walls):
    lum = walls_layer[..., :3].astype(float) @ [.299, .587, .114]
    q75, q90, q97 = np.quantile(lum[walls], [0.75, 0.9, 0.97])
    hi = walls & (lum >= q75)
    lev = np.where(lum >= q97, 4, np.where(lum >= q90, 3, 2))
    yy, xx = np.mgrid[:H, :W]; s = xx + 0.6 * yy
    span = float(s.max()) + 2 * REF_BW; D = span / 2
    frames = []
    for t in range(REF_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for j in range(2):
            p = -REF_BW + (t / REF_PHASES) * D + j * D
            band = hi & (np.abs(s - p) < REF_BW)
            h = np.clip(((s - p + REF_BW) / (2 * REF_BW) * N_HUES).astype(int), 0, N_HUES - 1)
            e[band, :3] = SPEC[h[band], lev[band]]; e[band, 3] = 255
        frames.append(e)
    return frames, {'q75': float(q75), 'q90': float(q90), 'q97': float(q97), 'D': D, 'span': span}


def rom_sparkle_shapes():
    """Formes des scintillements de D42P42A : pixels et luminance relative à l'allumage (grande étoile, petite croix)."""
    im = Image.open(ROM_ANIM)
    fr = np.array([np.array(f.convert('RGB')) for f in ImageSequence.Iterator(im)]).astype(int)
    ch = (fr != fr[0]).any(3).any(0)
    lab, n = nd.label(ch, structure=np.ones((3, 3)))
    lum = fr @ [.299, .587, .114]
    shapes = {}; periods = {'grande': [], 'petite': []}
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        kind = {17: 'grande', 5: 'petite'}.get(len(ys))
        if kind is None:
            continue
        L = lum[:, ys, xs]; seq = L[:, int(np.argmax(L.max(0)))]
        jumps = [k for k in range(1, len(seq)) if seq[k] - seq[k - 1] > 40]              # allumages
        if len(jumps) >= 2:
            periods[kind].append(int(jumps[1] - jumps[0]))
        if kind in shapes:
            continue
        tf = int(np.argmax(L.max(1)))
        rel = (L[tf] - L[tf].min()) / max(1e-6, L[tf].max() - L[tf].min())
        cy, cx = int(round(ys.mean())), int(round(xs.mean()))
        shapes[kind] = {'px': [(int(y - cy), int(x - cx), float(r)) for y, x, r in zip(ys, xs, rel)]}
    for k in shapes:
        shapes[k]['periodes_rom'] = dict(sorted(__import__('collections').Counter(periods[k]).items()))
    return shapes


def sparkle_frames(walls, walls_layer, seed=19):
    shapes = rom_sparkle_shapes()
    lum = walls_layer[..., :3].astype(float) @ [.299, .587, .114]
    cand = walls & (lum >= np.quantile(lum[walls], 0.85)) & morph(nd.binary_erosion, walls, 4)
    ys, xs = np.nonzero(cand)
    rng = np.random.default_rng(seed)
    pick = []
    for k in rng.permutation(len(ys)):
        y, x = int(ys[k]), int(xs[k])
        if all(abs(y - p['y']) + abs(x - p['x']) > 40 for p in pick):
            kind = 'grande' if len(pick) % 3 == 0 else 'petite'
            pick.append({'y': y, 'x': x, 'forme': kind, 'teinte': int(rng.integers(N_HUES)),
                         'phase': int(rng.integers(SPK_PHASES))})
        if len(pick) == N_SPARKS:
            break
    frames = []
    for t in range(SPK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for p in pick:
            P = SPK_PERIODS[p['forme']]; age = (t - p['phase']) % P
            A = 1 - age / P                                                                  # allumage puis décroissance
            for dy, dx, rel in shapes[p['forme']]['px']:
                lv = int(np.floor(4 * A * (0.35 + 0.65 * rel) + 0.5))
                Y, X = p['y'] + dy, p['x'] + dx
                if lv >= 1 and 0 <= Y < H and 0 <= X < W and walls[Y, X]:
                    e[Y, X, :3] = SPEC[p['teinte'], lv]; e[Y, X, 3] = 255
        frames.append(e)
    return frames, pick, {k: {'pixels': len(v['px']), 'periodes_rom': v['periodes_rom'], 'periode_ici': SPK_PERIODS[k]}
                          for k, v in shapes.items()}


def make_all():
    a = rgb(RAW / 'decor_vert.png')
    assert a.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    clean = inpaint_green(a, m['green'], m['floor'])
    ref = rgb(REFS['D17P45A']); y0, x0, y1, x1 = REF_BOXES['sol'][1]
    patch = sol_patch(clean, m['floor'] & ~morph(nd.binary_dilation, m['green'], 20), ref[y0:y1, x0:x1].reshape(-1, 3).mean(0))
    f = make_sol(clean, patch)
    ex, cols = JM.down_class(clean, {'floor': m['floor'], 'walls': m['walls']}, ['floor', 'walls'])
    layers = BM.quantize_layers({'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool)),
                                 'sol': JM.rgba(cols['floor'], ex['floor'])})
    e = JM.rgba(cols['walls'], ex['walls']); mm = e[..., 3] == 255
    q = Image.fromarray(e[..., :3]).quantize(colors=64, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    e[..., :3] = np.array(q.convert('RGB')); e[~mm] = 0; layers['cristaux'] = e
    sc = lambda k: JM.resize_plane(k.astype(np.float32))
    emb = (sc(m['emb']) > 0.3) & ex['floor']
    rl = np.zeros((H, W), int)
    for k in range(1, len(m['runes']) + 1):
        rl[(sc(m['rune_lab'] == k) > 0.3) & ex['floor'] & ~emb] = k
    cy, cx = m['centre']; centre = (cy * S, cx * S - JM.CROP_X); radius = m['ring_r'] * S
    ef = emblem_frames(emb, ex['floor'] & ~(rl > 0), centre, radius)
    rf = rune_frames(rl, ex['floor'] & ~emb, len(m['runes']))
    reff, refinfo = reflect_frames(layers['cristaux'], ex['walls'])
    sf, sparks, shapes = sparkle_frames(ex['walls'], layers['cristaux'])
    return dict(a=a, m=m, ex=ex, layers=layers, ef=ef, rf=rf, reff=reff, refinfo=refinfo, sf=sf, sparks=sparks, shapes=shapes,
                emb=emb, rl=rl, centre=centre, radius=radius, patch=patch)


REF_BOXES = {'sol': ('D17P45A', (185, 275, 285, 425))}                  # boîte de référence pour la plage du sol complet


def floor_rule(x):
    """Même règle sur D17P45A entière et sur la scène : plus grande zone lisse (écart-type local 9 x 9 < 16) et claire."""
    lum = x @ [.299, .587, .114]
    sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 9) - nd.uniform_filter(lum, 9) ** 2, 0))
    return biggest((sd < 16) & (lum > 110))


def fidelity(scene0, glow):
    x = np.array(scene0.convert('RGB')).astype(int); ref = rgb(REFS['D17P45A']); out = {}
    fr, fx = floor_rule(ref), floor_rule(x) & ~glow
    cr = ~morph(nd.binary_dilation, fr, 4); cx = ~morph(nd.binary_dilation, floor_rule(x), 4) & ~glow
    for nm, mr, mx in (('sol', fr, fx), ('cristaux', cr, cx)):
        r_, o_ = ref[mr].mean(0), x[mx].mean(0)
        out[nm] = {'ref': 'D17P45A', 'part_ref': round(float(mr.mean()), 3), 'part_scene': round(float(mx.mean()), 3),
                   'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                   'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    out['methode'] = ('meme regle sur D17P45A entiere et sur la scene t000 : sol = plus grande zone lisse (ecart-type local '
                      '9 x 9 < 16) et claire (lum > 110), sans les gravures qui pulsent ; cristaux = le reste a plus de 4 px du sol')
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['sol', 'cristaux']
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['heros']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Arene de Terapagos - cristal prismatique (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Arene generee 4:3 (ref. D17P45A + D42P42A) : caverne de cristal de verre aux reflets du '
                    'spectre, embleme Teracristal grave au sol qui pulse, 14 runes qui s allument tour a tour, scintillements '
                    '(loi ROM de D42P42A). Arrivee au sud, boss sur l embleme, heros au sud de l anneau. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'source': 'heros'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Arene de Terapagos (cristal prismatique) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "arene generee au format 4:3 (ref. D17P45A + D42P42A), cristal aux reflets du spectre, embleme et runes qui pulsent")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def reach_map(blocked, start):
    gh, gw = blocked.shape
    free = np.zeros((gh, gw), bool)
    free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free)
    return lab == lab[start]


def nearest_reach(reach, target):
    gh, gw = reach.shape
    cand = [(abs(gx * 8 + 8 - target[0]) + abs(gy * 8 + 8 - target[1]), gx, gy) for gy in range(gh - 1) for gx in range(gw - 1) if reach[gy, gx]]
    _, gx, gy = min(cand); return [gx * 8, gy * 8]


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review'] + [f'animation/{k}' for k in ANIM]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    masks = dict(sol=ex['floor'], cristaux=ex['walls'], embleme=D['emb'], runes=D['rl'] > 0)
    for k, v in masks.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    assert D['rl'].max() * 18 <= 255                                                       # 14 x 18 = 252
    Image.fromarray((D['rl'] * 18).astype('uint8')).save(OUT / 'masques' / f'{PFX}_etiquettes_runes.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('sol', [layers['sol']], 60), ('cristaux', [layers['cristaux']], 60),
                   ('reflets', D['reff'], REF_TICKS), ('embleme', D['ef'], EMB_TICKS), ('runes', D['rf'], EMB_TICKS),
                   ('scintillements', D['sf'], SPK_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = layers['sol'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    ex_ = min(col_bottom, key=lambda c: abs(c * 8 + 8 - W // 2)); entrance = [ex_ * 8, H - 16]
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    cy, cx = D['centre']
    boss = nearest_reach(reach, (int(cx), int(cy)))
    heros = nearest_reach(reach, (int(cx), int(cy + D['radius'] + 14)))
    markers = {'entrance': entrance, 'boss': boss, 'heros': heros}
    paths = {}
    for k in ('boss', 'heros'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ANIM[title]) % len(frames)] if title in ANIM else frames[0]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    fid = fidelity(scenes[0], morph(nd.binary_dilation, D['emb'] | (D['rl'] > 0), 3))
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, quality=90, method=4)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('heros', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    z = Image.new('RGB', (6 * 240, 240), (20, 20, 20))                                      # pulsation, 6 instants
    x0, y0 = int(cx - D['radius'] - 16), int(cy - D['radius'] - 16); sz = int(2 * D['radius'] + 32)
    for j, t in enumerate(range(0, 180, 30)):
        z.paste(scene(t).crop((x0, y0, x0 + sz, y0 + sz)).convert('RGB').resize((240, 240), Image.NEAREST), (j * 240, 0))
    z.save(OUT / 'review' / f'{PFX}_pulsation_embleme.png')
    sw = Image.new('RGB', (N_HUES * 24, N_LEVELS * 24))
    dr2 = ImageDraw.Draw(sw)
    for h in range(N_HUES):
        for l in range(N_LEVELS):
            dr2.rectangle([h * 24, l * 24, h * 24 + 23, l * 24 + 23], fill=tuple(int(v) for v in SPEC[h, l]))
    sw.save(OUT / 'review' / f'{PFX}_tons_spectre.png')
    BM.write_ora(OUT / f'{PFX}_arene_terapagos_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'arene de Terapagos (fin du reseau Zone Zero)', 'biome': 'caverne de cristal de verre prismatique',
        'demande': ["Fait une zone de crystal de verre qui reflette les spectre de couleur une arene pour terragos tu vois ce que "
                    "je veux dire ? avec des rune et signe qui pulse etc"],
        'choix_agent': {'lecture': 'Terapagos (Pokemon Stellaire) ; arene au bout du reseau Zone Zero, apres EAZ1',
                        'references': 'D17P45A (champ de cristaux, sol lumineux a dalles hexagonales) + D42P42A (arene ronde, '
                                      'etoile au sol, scintillements) ; decoupes de style x2 seulement',
                        'layout': 'caverne ronde fermee par des amas de cristaux ; sol lumineux en coeur ; embleme Teracristal '
                                  '(etoile a 12 branches en facettes hexagonales dans un anneau) grave a plat au centre ; 14 runes (12 demandees, '
                                  '14 peintes) autour ; couloir de cristal depuis le bord sud',
                        'spectre': '12 teintes x 5 niveaux calcules (tons 5 bits NDS) : ce ne sont pas des tons de la ROM',
                        'noms_de_lieux': 'non affirmes (prefixe dNN non fiable), seuls les codes ROM comptent'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference (2 decoupes x2), gravures en vert pur remplacees par des calques calcules ; sol sous '
                  'les gravures = pixel de sol non grave le plus proche ; sol complet = plage de sol en miroir',
        'references_da': {k: {'fichier': str(p.relative_to(R)), 'sha256': sha(p), 'source': 'recuperer_maps.py rom (pret/pmd-sky c8073235)'}
                          for k, p in REFS.items()},
        'reference_animation': {'fichier': str(ROM_ANIM.relative_to(R)), 'sha256': sha(ROM_ANIM), 'images': 27},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_vert.png', 'sha256': sha(RAW / 'decor_vert.png'), 'size': list(SRC),
                        'images': STYLE, 'utilise': True, 'editions': 0, 'note': 'premier rendu garde tel quel'}],
        'sol_complet': {'methode': 'plage de sol du brut (sans gravure) en miroir', 'plage_y0_y1_x0_x1': list(D['patch'])},
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe ; palette commune 96 couleurs (sol complet, sol) ; cristaux 64 ; '
                                     'embleme, runes, reflets et scintillements aux tons du spectre'},
        'segmentation': {'vert': 'G - max(R, B) > 80 et G > 150, + liseré G - max(R, B) > 30 a moins de 2 px',
                         'sol': 'plus grande zone lisse (ecart-type local 9 x 9 < 16) et claire (lum > 110), gravures comprises, '
                                'trous rebouches, ouverte 6',
                         'embleme': 'composantes vertes de plus de 200 px de cote (etoile et anneau)',
                         'runes': 'autres composantes vertes de 60 px ou plus hors de l anneau, triees dans le sens horaire depuis le nord',
                         'cristaux': 'tout le reste'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'spectre': {'teintes': N_HUES, 'niveaux': N_LEVELS, 'saturation': SAT, 'valeur': VAL, 'tons': SPEC.tolist(),
                    'arrondi': '8 k + 7 (tons 5 bits NDS)'},
        'embleme': {'phases': EMB_PHASES, 'frame_length_ticks': EMB_TICKS, 'centre_xy': [float(D['centre'][1]), float(D['centre'][0])],
                    'rayon_anneau': float(D['radius']), 'pixels': int(D['emb'].sum()),
                    'loi': 'I = 0,5 - 0,5 cos(2 pi (t/36 - 0,5 r/R)) : onde qui part du centre ; niveau = round(4 I) ; teinte = '
                           'floor(12 (angle/2pi + t/36)) : le spectre fait un tour par boucle ; halo 1 px au niveau 3+, 2 px au niveau 4'},
        'runes': {'phases': EMB_PHASES, 'frame_length_ticks': EMB_TICKS, 'nombre': len(D['m']['runes']),
                  'angles_deg': [round(c['angle'], 1) for c in D['m']['runes']],
                  'loi': 'rune k (sens horaire depuis le nord) allumee au pas round(36 (k - 1) / n), puis s eteint en 12 pas (niveau plancher 1) ; '
                         'teinte k ; halo 1 px au niveau 3+'},
        'reflets': {'phases': REF_PHASES, 'frame_length_ticks': REF_TICKS, 'demi_largeur': REF_BW,
                    'seuils_luminance': {k: round(v, 1) for k, v in D['refinfo'].items() if k.startswith('q')},
                    'loi': 'deux bandes arc-en-ciel sur s = x + 0,6 y, ecart D = moitie du parcours, avancent de D par boucle ; '
                           'seulement les facettes claires des cristaux (quartile haut), niveau selon la luminance'},
        'scintillements': {'phases': SPK_PHASES, 'frame_length_ticks': SPK_TICKS, 'formes_rom': D['shapes'], 'liste': D['sparks'],
                           'loi': 'loi de D42P42A : allumage d un coup puis decroissance lineaire sur la periode ; formes relevees '
                                  'dans la ROM ; tons du spectre (une teinte par scintillement)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; amas de cristaux bloquants', 'boss': 'sur l embleme (Terapagos)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items() if isinstance(v, dict)}, 'markers': markers,
                      'runes': len(D['m']['runes']), 'blocked': int(blocked.sum()), 'formes': D['shapes'], 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
