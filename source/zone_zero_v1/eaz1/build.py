"""Entrée Zone Zéro 1 (EAZ1) — grotte de cristal devant le donjon Zone Zéro (Pokémon Paradoxe), 4:3 (768 x 576).

.venv/bin/python source/zone_zero_v1/eaz1/build.py

Fin du réseau Zone Zéro : RAZ1 lèvre -> RAZ2 terrasses -> RAZ3 fond cristallin -> EAZ1 (cette map).

- Référence : D17P11A de PMD Explorers of Sky (entrée de la grotte de cristal), rendue directement depuis la ROM par
  source/outil_maps_pmdsky (recuperer_maps.py rom). Rendu généré référencé à partir d'une petite découpe de textures (sans le cristal géant,
  pour ne pas recopier la composition), nouveau layout asymétrique.
- Premier rendu (decor_v0_couleurs_derivees.png) : bon layout, couleurs trop claires et vertes. Édition 1 (« recolorer à la
  palette de la référence ») : encore trop claire. Une 2e édition plus sombre, terne, a été jetée. decor.png = édition de
  l'édition 1 (« baisser d'environ 20 % en gardant les lueurs »). Corrélation des contours avec v0 inscrite au manifeste.
- Fidélité : même règle d'extraction des matières (materials) appliquée à D17P11A et à la scène rendue.
- Loi d'animation relevée dans la ROM sur D17P11A : animation de palette des petits amas de cristal (le cristal géant est
  fixe). Chaque ton gagne 8 par canal et par niveau, plafonné à 231 ; niveaux 0-4 en 18 pas de 10 ticks :
  0 0 0 1 2 2 3 3 4 4 4 3 3 2 2 1 1 1 (180 ticks). Appliquée aux cristaux et, en phase, au souffle du tunnel.
- Calques : sol complet, sol, parois, cristaux (anim), géode, portail (anim), lucioles (anim), scintillements (anim).
- Marqueurs : entrance (brèche sud), donjon (devant le tunnel de la géode), cercle (plage lumineuse cerclée de rochers).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd
from scipy.spatial import ConvexHull

HERE = Path(__file__).resolve().parent
ZZ = HERE.parent
R = HERE.parents[2]
RAW = HERE / 'bruts'
LOT = 'zone_zero_v1/eaz1'
OUT = R / 'renders' / 'zone_zero_v1' / 'EAZ1'
NAMESPACE = 'entree_zone_zero'
STAGE = R / '.cache' / 'zone_zero_v1' / NAMESPACE
ASSET = 'eaz1_entree_zone_zero'
PFX = 'EAZ1'
REFS = {'D17P11A': ZZ / 'reference/D17P11A.png'}
STYLE = ['source/zone_zero_v1/reference/D17P11A_decoupe_style_x2.png']
W, H = 768, 576
SRC = (1200, 896)
GEODE_BOX = (20, 340, 640, 1000)            # zone de la géode dans le brut (y0, y1, x0, x1)
LOOP_TICKS = 180
FIDELITY_MAX = 35
GLOW_TICKS = 10
GLOW_SEQ = [0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1, 1]     # loi ROM de D17P11A, 18 pas de 10 ticks
GLOW_STEP, GLOW_CAP = 8, 231
MOTE_PHASES, MOTE_TICKS = 18, 10
SPARK_PHASES, SPARK_TICKS = 12, 5
SPARK_SEQ = [1, 2, 3, 3, 2, 1, 0, 0, 0, 0, 0, 0]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


C = loadmod('zone_zero_commun', ZZ / 'commun.py')
JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
ANIM = {'cristaux': GLOW_TICKS, 'portail': GLOW_TICKS, 'lucioles': MOTE_TICKS, 'scintillements': SPARK_TICKS}
PHASES = {'cristaux': len(GLOW_SEQ), 'portail': len(GLOW_SEQ), 'lucioles': MOTE_PHASES, 'scintillements': SPARK_PHASES}
assert all(LOOP_TICKS % (PHASES[k] * ANIM[k]) == 0 for k in ANIM)


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_big(m, n_min):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n_min])


def lstd_of(a, k=11):
    lum = a @ [.299, .587, .114]
    return np.sqrt(np.clip(nd.uniform_filter(lum ** 2, k) - nd.uniform_filter(lum, k) ** 2, 0, None))


def edge_corr(a, b):
    def ed(x):
        g = x.mean(2); return np.hypot(nd.sobel(g, 0), nd.sobel(g, 1))
    return float(np.corrcoef(ed(a).ravel(), ed(b).ravel())[0, 1])


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    Hs, Ws = a.shape[:2]
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; ls = lstd_of(a)
    y0, y1, x0, x1 = GEODE_BOX
    gb = np.zeros((Hs, Ws), bool); gb[y0:y1, x0:x1] = True
    strict = (g - r > 68) & (b - r > 70) & (lum > 70) & (lum < 215)                     # sol bleu-sarcelle et plages claires
    loose = (g - r > 52) & (b - r > 65) & (lum > 52) & (lum < 215)                      # + sol sombre des bords
    seed = np.where(gb, strict, loose)                                                   # stricte près de la géode
    fl = nd.uniform_filter(seed.astype(float), 9) > 0.6
    fl = keep_big(morph(nd.binary_opening, fl, 3), 5000)
    bright = ((lum > 150) & (ls > 16)) | ((lum > 110) & (g - r < 70) & (ls > 25))        # cristaux : clairs ET texturés
    cr = keep_big(morph(nd.binary_closing, bright & ~fl, 1), 40)
    cr = nd.binary_fill_holes(cr) & ~fl
    g0 = keep_big(cr & gb, 20000)                                                        # géode : plus gros amas du coin nord-est
    pts = np.argwhere(g0)[:, ::-1]; hv = pts[ConvexHull(pts).vertices]
    hm = Image.new('L', (Ws, Hs), 0); ImageDraw.Draw(hm).polygon([tuple(map(int, p)) for p in hv], fill=1)
    hull = np.array(hm) > 0
    lab_all, _ = nd.label(fl)
    lab, n = nd.label(fl & hull)                                                         # reflets des faces pris pour du sol
    for i in range(1, n + 1):
        c = lab == i
        cc = fl & (lab_all == np.bincount(lab_all[c]).argmax())
        if (cc & hull).sum() >= 0.9 * cc.sum():
            fl &= ~cc
    geode = hull & ~fl
    tunnel = keep_big(nd.binary_fill_holes(morph(nd.binary_closing, geode & (lum < 70) & (b - r > 30), 3)), 1500)
    geode &= ~tunnel
    cr &= ~(geode | tunnel)
    rest = ~(fl | cr | geode | tunnel)
    lab, _ = nd.label(rest); add = np.zeros((Hs, Ws), bool)                              # dalles sombres entourées de sol
    for i, sl in enumerate(nd.find_objects(lab), 1):
        mm = lab[sl] == i
        if mm.sum() > 9000:
            continue
        sl2 = tuple(slice(max(s.start - 4, 0), s.stop + 4) for s in sl)
        m2 = np.zeros((Hs, Ws), bool); m2[sl] = mm; m2 = m2[sl2]
        ring = nd.binary_dilation(m2, iterations=3) & ~m2
        if fl[sl2][ring].mean() > 0.45:
            add[sl2] |= m2
    floor = fl | add
    walls = ~(floor | cr | geode | tunnel)
    return dict(floor=floor, dalles=add, walls=walls, crystal=cr, geode=geode, tunnel=tunnel)


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


# ---------------------------------------------------------------- lois
def glow(rgb_arr, k):
    """Loi de palette de D17P11A : + 8 par canal et par niveau, plafonné à 231 (niveau 0 : inchangé)."""
    if k == 0:
        return rgb_arr.copy()
    return np.minimum(rgb_arr.astype(int) + GLOW_STEP * k, GLOW_CAP).astype('uint8')


def glow_frames(layer):
    m = layer[..., 3] == 255; frames = []
    for k in GLOW_SEQ:
        e = layer.copy(); e[m, :3] = glow(layer[m, :3], k); frames.append(e)
    return frames


def mote_frames(sources, seed=41, n=26):
    """Lucioles de Téra : montent de 2 px par pas depuis la plage cerclée et la bouche du tunnel, un tour en 18 pas."""
    rng = np.random.default_rng(seed); motes = []
    for i in range(n):
        (cx, cy), (ax, ay) = sources[i % len(sources)]
        motes.append({'x': float(cx + rng.uniform(-ax, ax)), 'y': float(cy + rng.uniform(-ay, ay)),
                      'phase': int(rng.integers(MOTE_PHASES)), 'amp': float(rng.uniform(1.5, 3.5)),
                      'teinte': list(C.GLINT_TINTS[i % len(C.GLINT_TINTS)])})
    frames = []
    for t in range(MOTE_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for m in motes:
            u = (t - m['phase']) % MOTE_PHASES
            x = int(round(m['x'] + m['amp'] * np.sin(2 * np.pi * u / MOTE_PHASES)))
            y = int(round(m['y'] - 2 * u))
            life = min(u, MOTE_PHASES - 1 - u)                                            # s'allume, puis s'éteint
            if life == 0 or not (1 <= x < W - 1 and 1 <= y < H - 1):
                continue
            e[y, x] = (*m['teinte'], 255)
            if life >= 3:                                                                 # halo en croix au milieu de la vie
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    e[y + dy, x + dx] = (*[int(v * 0.75) for v in m['teinte']], 255)
        frames.append(e)
    return frames, motes


def spark_frames(layer, mask, seed=29, n_max=40):
    rng = np.random.default_rng(seed)
    lum = layer[..., :3].astype(float) @ [.299, .587, .114]
    cand = np.argwhere(mask & (lum > np.percentile(lum[mask], 85)))
    rng.shuffle(cand); stars = []
    for y, x in cand:
        if len(stars) >= n_max:
            break
        if 3 <= x < W - 3 and 3 <= y < H - 3 and all(max(abs(x - s['xy'][0]), abs(y - s['xy'][1])) > 7 for s in stars):
            stars.append({'xy': [int(x), int(y)], 'phase': int(rng.integers(SPARK_PHASES)),
                          'teinte': list(C.GLINT_TINTS[len(stars) % len(C.GLINT_TINTS)])})
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
                    e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255)
        frames.append(e)
    return frames, stars


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor.png'); v0 = rgb(RAW / 'decor_v0_couleurs_derivees.png')
    assert a.shape[:2] == (SRC[1], SRC[0]) == v0.shape[:2]
    m = classify(a)
    ref = rgb(REFS['D17P11A'])
    patch = sol_patch(a, m['floor'] & ~m['dalles'], ref[materials(ref)['sol']].mean(0))
    f = make_sol(a, patch)
    order = ['floor', 'tunnel', 'geode', 'crystal', 'walls']
    ex, cols = JM.down_class(a, m, order)
    full = JM.down_full(a)
    layers = BM.quantize_layers({'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool)),
                                 'sol': JM.rgba(cols['floor'], ex['floor'])})
    for nm, key, nc in (('parois', 'walls', 32), ('cristaux', 'crystal', 32), ('geode', 'geode', 32), ('portail', 'tunnel', 16)):
        e = JM.rgba(cols[key], ex[key]); m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    cf = glow_frames(layers['cristaux']); pf = glow_frames(layers['portail'])
    ty, tx = np.nonzero(ex['tunnel'])
    ring_c = ring_centre(ex)
    sources = [((float(tx.mean()), float(ty.max()) - 6), (float((tx.max() - tx.min()) / 3), 6.0)),
               ((float(ring_c[0]), float(ring_c[1])), (40.0, 18.0))]
    mf, motes = mote_frames(sources)
    sf, stars = spark_frames(layers['geode'], layers['geode'][..., 3] == 255)
    return dict(a=a, v0=v0, m=m, ex=ex, layers=layers, cf=cf, pf=pf, mf=mf, motes=motes, sf=sf, stars=stars, patch=patch,
                mote_sources=sources, edge_corr=round(edge_corr(v0, a), 3), full=full)


def ring_centre(ex):
    """Centre de la plage lumineuse cerclée de rochers : le plus grand trou de sol dans la moitié est, sous la géode."""
    fl = ex['floor']; lum = JM.down_full(rgb(RAW / 'decor.png')).astype(float) @ [.299, .587, .114]
    box = np.zeros_like(fl); box[250:450, 480:700] = True
    ys, xs = np.nonzero(fl & box & (lum > np.percentile(lum[fl & box], 90)))
    return int(np.median(xs)), int(np.median(ys))


def materials(x):
    """Règle d'extraction identique pour la référence et le rendu : sol (bleu-sarcelle peu texturé), cristaux (clairs et
    texturés), parois (sombres, le reste)."""
    r, g, b = x.transpose(2, 0, 1); lum = x @ [.299, .587, .114]; ls = lstd_of(x)
    sol = nd.uniform_filter(((b - r > 60) & (g - r > 45) & (lum > 50) & (lum < 215) & (ls < 26)).astype(float), 9) > 0.6
    cr = (((lum > 150) & (ls > 16)) | ((lum > 110) & (g - r < 70) & (ls > 25))) & ~sol
    par = ~sol & ~cr & (lum < 110)
    return {'sol': sol, 'cristaux': cr, 'parois': par}


def fidelity(D, scene0):
    ref = rgb(REFS['D17P11A']); out = {}
    x = np.array(scene0.convert('RGB')).astype(int)
    mr, mx = materials(ref), materials(x)
    for nm in ('sol', 'cristaux', 'parois'):
        r_, o_ = ref[mr[nm]].mean(0), x[mx[nm]].mean(0)
        out[nm] = {'ref': 'D17P11A', 'part_ref': round(float(mr[nm].mean()), 3), 'part_rendu': round(float(mx[nm].mean()), 3),
                   'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                   'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    L = D['layers']['sol_complet']; o_ = L[..., :3].reshape(-1, 3).mean(0); r_ = ref[mr['sol']].mean(0)
    out['sol_complet'] = {'ref': 'D17P11A', 'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                          'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    out['methode'] = ('meme regle d extraction (materials) appliquee a D17P11A et a la scene rendue t000, moyennes comparees ; '
                      'les decoupes rectangulaires ont ete abandonnees : elles comparaient des melanges differents (sol de la '
                      'reference sans ses plages claires contre notre sol avec plages et corniche) et donnaient sol 55, cristaux 69')
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['sol', 'sol_complet', 'cristaux', 'parois']
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['donjon'],
                                                'source': markers['cercle']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Entree Zone Zero - grotte de cristal (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Entree de donjon generee 4:3 (ref. D17P11A) : grotte de cristal au fond du cratere de la Zone '
                    'Zero, geode fendue et tunnel du donjon au nord-est, corniche aux fleches de cristal, plage lumineuse cerclee '
                    'de rochers. Cristaux et tunnel pulsent a la loi de palette de D17P11A (18 x 10), lucioles et scintillements '
                    'tera. Arrivee au sud (depuis RAZ3). Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'donjon', 'source': 'cercle'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Entree Zone Zero (grotte de cristal) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "entree de donjon generee au format 4:3 (ref. D17P11A), grotte de cristal de la Zone Zero, geode, cristaux qui pulsent")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def reach_map(blocked, start):
    gh, gw = blocked.shape
    free = np.zeros((gh, gw), bool)
    free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free)
    return lab == lab[start]


def nearest_reach(reach, target, dy=8):
    gh, gw = reach.shape
    cand = [(abs(gx * 8 + 8 - target[0]) + abs(gy * 8 + dy - target[1]), gx, gy) for gy in range(gh - 1) for gx in range(gw - 1) if reach[gy, gx]]
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
    ex = dict(ex, dalles=ex['floor'] & (JM.resize_plane(D['m']['dalles'].astype(np.float32)) > 0.5))
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('sol', [layers['sol']], 60), ('parois', [layers['parois']], 60),
                   ('cristaux', D['cf'], GLOW_TICKS), ('geode', [layers['geode']], 60), ('portail', D['pf'], GLOW_TICKS),
                   ('lucioles', D['mf'], MOTE_TICKS), ('scintillements', D['sf'], SPARK_TICKS)]
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
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    ex_ = min(col_bottom, key=lambda c: abs(c - med)); entrance = [ex_ * 8, H - 16]
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    ty, tx = np.nonzero(ex['tunnel'])
    donjon = nearest_reach(reach, (int(tx.mean()), int(ty.max())), dy=0)
    cercle = nearest_reach(reach, ring_centre(ex))
    markers = {'entrance': entrance, 'donjon': donjon, 'cercle': cercle}
    paths = {}
    for k in ('donjon', 'cercle'):
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
    fid = fidelity(D, scenes[0])
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('donjon', (60, 220, 255, 255)), ('cercle', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    z = Image.new('RGB', (3 * 300, 300), (20, 20, 20))                                     # zoom géode et tunnel : niveaux 0, 2, 4
    gy, gx = np.nonzero(ex['geode'] | ex['tunnel'])
    cx0, cy0 = max(int(gx.mean()) - 75, 0), max(int(gy.mean()) - 60, 0)
    for j, t in enumerate((0, 40, 80)):
        im = scene(t).crop((cx0, cy0, cx0 + 150, cy0 + 150)).convert('RGB')
        z.paste(im.resize((300, 300), Image.NEAREST), (j * 300, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_geode.png')
    BM.write_ora(OUT / f'{PFX}_entree_zone_zero_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'reseau Zone Zero (routes RAZ, entree EAZ)', 'biome': 'grotte de cristal, entree du donjon Zone Zero',
        'demande': ["reseau de routes dans un abime facon Zone Zero avec des cascades jusqu'a la map d'entree du donjon Zone Zero "
                    "(Pokemon Paradoxe)",
                    "je choisis toutes les options recommandees + 3 routes, choisis les textures de reference pour composer cette zone inedite"],
        'choix_agent': {'reseau': 'RAZ1 levre -> RAZ2 terrasses -> RAZ3 fond cristallin -> EAZ1 entree (cette map)',
                        'references': 'D17P11A (entree de la grotte de cristal) : textures seulement, petite decoupe sans le cristal '
                                      'geant pour ne pas recopier sa composition',
                        'layout': 'grotte vaste ; breche au sud ; pas japonais sinueux vers une geode fendue au nord-est dont le '
                                  'coeur est le tunnel du donjon ; corniche aux fleches de cristal a l ouest (inaccessible) ; '
                                  'plage lumineuse cerclee de rochers a l est'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference (decoupe de style x2 de D17P11A), puis une edition de palette ; sol complet = plage de '
                  'sol du brut en miroir',
        'references_da': {k: {'fichier': str(p.relative_to(R)), 'sha256': sha(p)} for k, p in REFS.items()},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_v0_couleurs_derivees.png', 'sha256': sha(RAW / 'decor_v0_couleurs_derivees.png'),
                        'size': list(SRC), 'images': STYLE, 'utilise': False,
                        'rejet': 'bon layout, couleurs derivees : sol (55, 180, 167), trop clair et trop vert'},
                       {'file': f'source/{LOT}/bruts/decor_v1_edition1_trop_claire.png', 'sha256': sha(RAW / 'decor_v1_edition1_trop_claire.png'),
                        'size': list(SRC), 'images': [f'source/{LOT}/bruts/decor_v0_couleurs_derivees.png', 'source/zone_zero_v1/reference/D17P11A.png'],
                        'utilise': False, 'edition': 'un seul changement : recolorer a la palette de la reference, meme layout',
                        'rejet': 'encore trop claire (cristaux blanchatres) ; une 2e edition plus sombre a ete jetee sans etre gardee '
                                 '(terne, lueurs perdues, geode introuvable par la segmentation)'},
                       {'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/bruts/decor_v1_edition1_trop_claire.png', 'source/zone_zero_v1/reference/D17P11A.png'],
                        'utilise': True,
                        'edition': {'demande': 'un seul changement : baisser la luminosite d environ 20 % en gardant les lueurs, meme layout',
                                    'correlation_contours_avec_v0': D['edge_corr']}}],
        'sol_complet': {'methode': 'plage du brut en miroir (la plus proche du sol de la reference, peu contrastee)',
                        'plage_y0_y1_x0_x1': list(D['patch'])},
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe, palette commune 96 couleurs (sol complet, sol) ; palettes propres : '
                                     'parois 32, cristaux 32, geode 32, portail 16 ; animations calculees'},
        'segmentation': {'sol': 'G - R > 52, B - R > 65, 52 < lum < 215 (sol sombre des bords compris ; G - R > 68, B - R > 70, lum > 70 dans la boite de la geode), lisse 9 (> 0,6), ouvert 3, >= 5000 px',
                         'dalles': 'composantes non sol de moins de 9000 px dont l anneau de 3 px est a plus de 45 % du sol',
                         'cristaux': 'clairs et textures : (lum > 150 et ecart-type local > 16) ou (lum > 110, G - R < 70, ecart-type > 25), '
                                     'ferme 1, >= 40 px, rebouche',
                         'geode': f'plus gros amas de cristal (>= 20000 px) dans {list(GEODE_BOX)}, enveloppe convexe ; les composantes de sol '
                                  'a plus de 90 % dans l enveloppe lui reviennent (reflets des faces)',
                         'tunnel': 'sombre dans la geode (lum < 70, B - R > 30), ferme 3, rebouche, >= 1500 px',
                         'parois': 'le reste (rochers, stalactites, nuit de la grotte)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'cristaux': {'phases': len(GLOW_SEQ), 'frame_length_ticks': GLOW_TICKS, 'sequence_niveaux': GLOW_SEQ, 'pas_par_niveau': GLOW_STEP,
                     'plafond': GLOW_CAP,
                     'loi': 'ROM D17P11A : animation de palette des petits amas de cristal (cristal geant fixe) ; chaque ton + 8 par '
                            'canal et par niveau, plafonne a 231 ; 18 pas de 10 ticks'},
        'portail': {'phases': len(GLOW_SEQ), 'frame_length_ticks': GLOW_TICKS, 'sequence_niveaux': GLOW_SEQ,
                    'loi': 'meme loi que les cristaux, en phase : le tunnel du donjon respire'},
        'lucioles': {'phases': MOTE_PHASES, 'frame_length_ticks': MOTE_TICKS, 'montee_px_par_pas': 2, 'sources': D['mote_sources'],
                     'nombre': len(D['motes']), 'teintes': [list(c) for c in C.GLINT_TINTS]},
        'scintillements': {'phases': SPARK_PHASES, 'frame_length_ticks': SPARK_TICKS, 'sequence': SPARK_SEQ, 'etoiles': D['stars'],
                           'teintes': [list(c) for c in C.GLINT_TINTS], 'note': 'sur la geode, teintes tera du reseau'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; parois, cristaux, geode et tunnel bloquants',
                   'donjon': 'devant le tunnel de la geode (entree du donjon Zone Zero, a scripter)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccord RAZ3 -> EAZ1 et entree du donjon a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items() if isinstance(v, dict)}, 'markers': markers,
                      'patch': D['patch'], 'edge_corr': D['edge_corr'], 'etoiles': len(D['stars']),
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
