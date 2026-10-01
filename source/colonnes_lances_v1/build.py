"""Colonnes Lances, ruines (CLR1) — sommet en ruine façon Colonnes Lances, flottant dans une mer de nuages, 4:3 (768 x 576).

.venv/bin/python source/colonnes_lances_v1/build.py

Demande : « une map style colonne lance ruin etc avec les texture pmd ».
- Références rendues depuis la ROM (source/outil_maps_pmdsky, recuperer_maps.py rom --only D28,D29,D30) :
  D30P42A (sommet intact : dallage de briques, colonnes cannelées, autel à vitrail vert, rochers en lévitation, mer de nuages
  dorée) ; D28P33A (grand escalier à balustres). Les noms de lieu ne sont PAS affirmés (le préfixe dNN n'est pas le
  DUNGEON_ID) : seuls les codes comptent. RZD1 a déjà pris D30P34A (variante rouge fendue).
- Rendu généré référencé : deux découpes de style x2 (bruts/decor_magenta.png : plateforme, cercle de 8 colonnes dont
  plusieurs brisées, 3 colonnes couchées, autel à vitrail au nord, grand escalier au sud, ciel en magenta pur) ; une
  découpe x3 des nuages de D30P42A (bruts/nuages_magenta.png : 4 bandes de nuages festonnés sur magenta).
- Loi relevée dans la ROM sur D30P42A : seul le vitrail s'anime (animation de palette, 2 rampes de 12 tons vert -> cyan ->
  vert, 12 pas de 10 ticks). Appliquée telle quelle, tons ROM compris, au vitrail généré.
- Nuages : les nuages de la ROM sont fixes ; ici les bandes générées dérivent vers l'ouest (bande rendue périodique, 4 px par
  pas, 120 pas de 10 ticks : une période de 480 px par boucle de 20 s). Ciel : le ton uni de la ROM (183, 167, 87).
- Calques : ciel, nuages (anim), sol, ruines, rochers (anim), vitrail (anim), éclats (anim).
- Marqueurs : entrance (bas du grand escalier, sud), autel (devant les marches de l'autel), centre (milieu du cercle de
  colonnes).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'colonnes_lances_v1'
OUT = R / 'renders' / LOT / 'CLR1'
NAMESPACE = 'colonnes_lances'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'clr1_colonnes_lances'
PFX = 'CLR1'
REFS = {'D30P42A': HERE / 'reference/D30P42A.png', 'D28P33A': HERE / 'reference/D28P33A.png'}
STYLE = ['source/colonnes_lances_v1/reference/D30P42A_sommet_decoupe_x2.png',
         'source/colonnes_lances_v1/reference/D28P33A_escalier_decoupe_x2.png']
STYLE_NUAGES = ['source/colonnes_lances_v1/reference/D30P42A_nuages_decoupe_x3.png']
SRC = (1200, 896)
FIDELITY_MAX = 35
SKY = (183, 167, 87)                         # ciel uni de D30P42A (ton ROM)

# loi ROM du vitrail de D30P42A : 22 tons, 2 rampes de 12 pas (la 13e image = la 1re)
ROM_TONES = [(15, 191, 255), (15, 223, 255), (15, 231, 223), (15, 231, 231), (15, 239, 183), (15, 239, 191), (15, 239, 207),
             (15, 247, 135), (15, 247, 159), (15, 255, 87), (15, 255, 111), (15, 255, 127), (23, 199, 223), (23, 207, 191),
             (23, 207, 215), (23, 215, 159), (23, 215, 167), (31, 223, 127), (31, 231, 79), (31, 231, 95), (31, 239, 31),
             (31, 239, 63)]
RAMP = {'a': [20, 18, 17, 16, 14, 0, 12, 13, 15, 17, 19, 21], 'b': [9, 11, 8, 5, 2, 1, 3, 6, 4, 8, 7, 10]}
GLASS_PHASES, GLASS_TICKS = 12, 10
CLOUD_PHASES, CLOUD_TICKS, CLOUD_STEP = 120, 10, 4
CLOUD_SCALE, CLOUD_SEAM = 0.45, 60
CLOUD_P = CLOUD_PHASES * CLOUD_STEP           # 480 px : période de chaque bande
CLOUD_ROWS = [(4, 0, 0), (134, 1, 160), (264, 2, 320), (394, 3, 80), (510, 0, 240)]   # (haut, bande du brut, décalage x)
ROCK_PHASES, ROCK_TICKS = 30, 20
MOTE_PHASES, MOTE_TICKS, N_MOTES = 60, 10, 18
LOOP_TICKS = 1200
ANIM = {'nuages': CLOUD_TICKS, 'rochers': ROCK_TICKS, 'vitrail': GLASS_TICKS, 'eclats': MOTE_TICKS}
PHASES = {'nuages': CLOUD_PHASES, 'rochers': ROCK_PHASES, 'vitrail': GLASS_PHASES, 'eclats': MOTE_PHASES}

# obstacles mesurés à la main sur le brut (1200 x 896) : colonnes debout (fût x0, x1, haut ; socle x0, x1, y0, y1),
# colonnes couchées (capsule : extrémités, rayon), bloc de l'autel (x0, y0, x1, y1)
PILLARS = [(410, 460, 145, 400, 470, 270, 320), (730, 775, 195, 718, 785, 265, 318), (340, 385, 293, 328, 396, 415, 460),
           (818, 862, 322, 805, 872, 410, 460), (410, 455, 437, 398, 466, 515, 565), (742, 790, 383, 732, 802, 515, 565),
           (494, 542, 470, 484, 552, 590, 640), (660, 708, 470, 650, 718, 590, 640)]
FALLEN = [((230, 390), (285, 445), 24), ((262, 510), (330, 545), 26), ((818, 505), (885, 540), 26)]
ALTAR = (495, 0, 700, 252)
UPPER_Y = 205                                 # terrasse haute derrière l'autel (au nord de la corniche) : non praticable
STAIRS = (540, 690, 660, 896)                 # escalier central (x0, y0, x1, y1), praticable jusqu'au bord sud


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
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


def keep_big(m, n_min):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n_min])


def magenta(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (r > 200) & (b > 200) & (g < 80)


def magenta_fringe(a, strict, px=3):
    """Liseré antialiasé mêlé de magenta (rosé), cherché seulement à moins de px pixels du magenta pur."""
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    pink = (r - g > 45) & (b - g > 35)
    return strict | (pink & morph(nd.binary_dilation, strict, px))


# ---------------------------------------------------------------- segmentation pleine résolution
BRICK = ((180, 147, 133), 45)


def obstacles(shape):
    Hs, Ws = shape; yy, xx = np.mgrid[:Hs, :Ws]
    m = np.zeros(shape, bool); pil = np.zeros(shape, bool)
    for sx0, sx1, top, bx0, bx1, by0, by1 in PILLARS:
        pil |= (xx >= sx0) & (xx <= sx1) & (yy >= top) & (yy <= by1)
        pil |= (xx >= bx0) & (xx <= bx1) & (yy >= by0) & (yy <= by1)
    fal = np.zeros(shape, bool)
    for (x0, y0), (x1, y1), r in FALLEN:
        d = np.array([x1 - x0, y1 - y0], float); L = np.hypot(*d); u = d / L
        t = np.clip((xx - x0) * u[0] + (yy - y0) * u[1], 0, L)
        fal |= np.hypot(xx - (x0 + t * u[0]), yy - (y0 + t * u[1])) <= r
    x0, y0, x1, y1 = ALTAR
    alt = (xx >= x0) & (xx <= x1) & (yy >= y0) & (yy <= y1)
    return pil, fal, alt


def classify(a):
    Hs, Ws = a.shape[:2]
    mag = magenta_fringe(a, magenta(a))
    lab, n = nd.label(mag)
    edge = set(np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])) - {0}
    void = morph(nd.binary_dilation, np.isin(lab, sorted(edge)), 1)                         # liseré antialiasé compris
    nl, nn = nd.label(~void)
    ss = nd.sum(~void, nl, range(1, nn + 1))
    plat = nl == (int(np.argmax(ss)) + 1)
    rocks = keep_big(nd.binary_fill_holes(~void & ~plat) & ~plat, 60)                       # rochers en lévitation
    void &= ~rocks
    pil, fal, alt = obstacles((Hs, Ws))
    c, t = BRICK
    seed = np.sqrt(((a - np.array(c)) ** 2).sum(2)) < t
    fl = (nd.uniform_filter(seed.astype(float), 11) > 0.6) & plat
    fl = morph(nd.binary_opening, fl, 3)
    yy, xx = np.mgrid[:Hs, :Ws]
    fl &= yy >= UPPER_Y
    x0, y0, x1, y1 = STAIRS
    stairs = (xx >= x0) & (xx < x1) & (yy >= y0) & plat
    fl = (fl | stairs) & ~(pil | fal | alt)
    lab2, _ = nd.label(~fl & plat & ~(pil | fal | alt)); add = np.zeros((Hs, Ws), bool)      # fissures, joints (< 400 px)
    for i, sl in enumerate(nd.find_objects(lab2), 1):
        mm = lab2[sl] == i
        if mm.sum() < 400:
            add[sl] |= mm
    floor = keep_big((fl | add) & plat & (yy >= UPPER_Y), 20000)
    ruins = plat & ~floor
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    glass = alt & (g > r + 60) & (g > b + 20) & (g > 110)                                   # vitrail vert généré
    return dict(floor=floor, ruins=ruins, void=void, rocks=rocks, plat=plat, piliers=pil & plat, couchees=fal & plat,
                autel=alt & plat, glass=glass, stairs=stairs & floor)


# ---------------------------------------------------------------- nuages
def cloud_bands():
    """Bandes du brut de nuages, réduites (x 0,45) et rendues périodiques (P = 480 px, fondu de 60 px)."""
    a = rgb(RAW / 'nuages_magenta.png'); mg = magenta(a)
    m = ~morph(nd.binary_dilation, magenta_fringe(a, mg), 1)                                # sans le liseré rosé
    rows = m.mean(1) > 0.05
    lab, n = nd.label(rows)
    spans = [(int(np.nonzero(lab == i)[0][0]), int(np.nonzero(lab == i)[0][-1]) + 1) for i in range(1, n + 1)]
    spans = [s for s in spans if s[1] - s[0] > 60]
    bands = []
    for y0, y1 in spans:
        c = a[y0:y1].astype(np.float32); al = m[y0:y1].astype(np.float32)
        h, w = al.shape; nh, nw = int(round(h * CLOUD_SCALE)), int(round(w * CLOUD_SCALE))
        rs = lambda p: np.array(Image.fromarray(p, 'F').resize((nw, nh), Image.Resampling.BOX))
        A = rs(al); C = np.stack([rs(c[..., k] * al) for k in range(3)], -1) / np.maximum(A, 1e-6)[..., None]
        P = nw - CLOUD_SEAM
        assert P == CLOUD_P, (P, nw)
        wgt = (np.arange(CLOUD_SEAM) / CLOUD_SEAM)[None, :]
        a1, a2 = A[:, :CLOUD_SEAM], A[:, P:P + CLOUD_SEAM]
        am = wgt * a1 + (1 - wgt) * a2
        cm = (wgt[..., None] * a1[..., None] * C[:, :CLOUD_SEAM] + ((1 - wgt) * a2)[..., None] * C[:, P:P + CLOUD_SEAM]) \
            / np.maximum(am, 1e-6)[..., None]
        A2 = A[:, :P].copy(); C2 = C[:, :P].copy(); A2[:, :CLOUD_SEAM] = am; C2[:, :CLOUD_SEAM] = cm
        bands.append((C2, A2 > 0.5))
    allpx = np.concatenate([c[m_] for c, m_ in bands]).clip(0, 255).astype('uint8')
    q = Image.fromarray(allpx[None]).quantize(colors=16, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:48]).reshape(16, 3)
    out = []
    for c, m_ in bands:
        d = ((c[..., None, :] - pal[None, None]) ** 2).sum(-1); idx = d.argmin(-1)
        out.append((pal[idx].astype('uint8'), m_))
    return out, spans, pal


def cloud_frames(allowed):
    bands, spans, pal = cloud_bands()
    frames = []
    for t in range(CLOUD_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for top, bi, dx in CLOUD_ROWS:
            c, m_ = bands[bi]; h = c.shape[0]
            xs = (np.arange(W) + dx + CLOUD_STEP * t) % CLOUD_P                             # dérive vers l'ouest
            for y in range(h):
                Y = top + y
                if not 0 <= Y < H:
                    continue
                ok = m_[y, xs] & allowed[Y]
                e[Y, ok, :3] = c[y, xs[ok]]; e[Y, ok, 3] = 255
        frames.append(e)
    return frames, spans, pal, [b[0].shape[0] for b in bands]


# ---------------------------------------------------------------- autres lois animées
def rock_frames(layer, ex_rocks, seed=11):
    """Rochers en lévitation : chaque rocher monte et descend de 1 ou 2 px (sinus sur 30 pas, phase propre)."""
    lab, n = nd.label(ex_rocks)
    rng = np.random.default_rng(seed)
    info = [{'id': i, 'phase': int(rng.integers(ROCK_PHASES)), 'amp': int(rng.integers(1, 3))} for i in range(1, n + 1)]
    frames = []
    for t in range(ROCK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for d in info:
            dy = int(round(d['amp'] * np.sin(2 * np.pi * (t - d['phase']) / ROCK_PHASES)))
            ys, xs = np.nonzero(lab == d['id'])
            ok = (ys + dy >= 0) & (ys + dy < H)
            e[ys[ok] + dy, xs[ok]] = layer[ys[ok], xs[ok]]
        frames.append(e)
    return frames, info


def glass_frames(ruins_layer, glass):
    """Vitrail : loi de palette de D30P42A. Verts du rendu classés par rang de luminance : tiers sombre fixe, tiers moyen ->
    rampe a, tiers clair -> rampe b, 12 pas de 10 ticks, tous les pixels en phase comme dans la ROM."""
    lum = ruins_layer[..., :3].astype(float) @ [.299, .587, .114]
    ys, xs = np.nonzero(glass); order = np.argsort(lum[ys, xs], kind='stable'); n = len(order)   # tiers par rang
    ga = np.zeros_like(glass); gb = np.zeros_like(glass)
    ga[ys[order[n // 3:2 * n // 3]], xs[order[n // 3:2 * n // 3]]] = True
    gb[ys[order[2 * n // 3:]], xs[order[2 * n // 3:]]] = True
    frames = []
    for t in range(GLASS_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        e[ga, :3] = ROM_TONES[RAMP['a'][t]]; e[gb, :3] = ROM_TONES[RAMP['b'][t]]; e[ga | gb, 3] = 255
        frames.append(e)
    return frames, ga, gb


MOTE_TONES = [ROM_TONES[i] for i in (3, 1, 12, 0)]     # du plus pâle au plus sombre (tons ROM du vitrail)


def mote_frames(glass, walk_free, seed=7):
    """Éclats de lumière : 18 éclats montent du vitrail et de l'autel (42 px sur leur vie, oscillation 2 px), pâlissent
    puis s'éteignent ; 60 pas de 10 ticks, phases propres."""
    ys, xs = np.nonzero(glass)
    x0, x1, yb = int(xs.min()) - 10, int(xs.max()) + 10, int(ys.max()) + 6
    rng = np.random.default_rng(seed)
    motes = [{'x': int(rng.integers(x0, x1)), 'y': int(yb - rng.integers(0, 30)), 'phase': int(rng.integers(MOTE_PHASES)),
              'vie': int(rng.integers(36, 50)), 'w': float(rng.uniform(0, 2 * np.pi))} for _ in range(N_MOTES)]
    frames = []
    for t in range(MOTE_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for m in motes:
            k = (t - m['phase']) % MOTE_PHASES
            if k >= m['vie']:
                continue
            u = k / m['vie']
            x = int(round(m['x'] + 2 * np.sin(2 * np.pi * 2 * u + m['w']))); y = int(round(m['y'] - 42 * u))
            tone = MOTE_TONES[min(3, int(u * 4))]
            for dy, dx in ((0, 0), (0, 1), (1, 0), (1, 1)) if u < 0.5 else ((0, 0),):
                if 0 <= y + dy < H and 0 <= x + dx < W:
                    e[y + dy, x + dx, :3] = tone; e[y + dy, x + dx, 3] = 255
        frames.append(e)
    return frames, motes


def make_all():
    a = rgb(RAW / 'decor_magenta.png')
    assert a.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    order = ['floor', 'ruins', 'rocks', 'void']
    ex, cols = JM.down_class(a, m, order)
    layers = BM.quantize_layers({'sol': JM.rgba(cols['floor'], ex['floor'])})
    for nm, key, nc in (('ruines', 'ruins', 64), ('rochers', 'rocks', 24)):
        e = JM.rgba(cols[key], ex[key]); m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    sky = np.zeros((H, W, 4), 'uint8'); sky[..., :3] = SKY; sky[..., 3] = 255; layers['ciel'] = sky
    glass = (JM.resize_plane(m['glass'].astype(np.float32)) > 0.5) & ex['ruins']
    open_sky = ex['void'] | ex['rocks']
    cells = open_sky.reshape(H // 8, 8, W // 8, 8).any((1, 3))
    allowed = np.repeat(np.repeat(cells, 8, 0), 8, 1)                                      # cases où le ciel se voit
    cf, spans, cpal, heights = cloud_frames(allowed)
    rkf, rocks = rock_frames(layers['rochers'], ex['rocks'])
    gf, ga, gb = glass_frames(layers['ruines'], glass)
    mf, motes = mote_frames(glass, ex['floor'])
    sub = {k: JM.resize_plane(m[k].astype(np.float32)) > 0.5 for k in ('piliers', 'couchees', 'autel', 'stairs')}
    return dict(a=a, m=m, ex=ex, layers=layers, cf=cf, spans=spans, cpal=cpal, heights=heights, rkf=rkf, rocks=rocks,
                gf=gf, ga=ga, gb=gb, mf=mf, motes=motes, glass=glass, allowed=allowed, sub=sub)


# boîtes (y0, x0, y1, x1) de même matière, vérifiées dans la référence et dans le brut (brut ramené à la scène par l'échelle)
REF_BOXES = {'briques': ('D30P42A', (240, 250, 300, 330)), 'piliers': ('D30P42A', (150, 155, 215, 183)),
             'escalier': ('D28P33A', (280, 262, 420, 292))}
RAW_BOXES = {'briques': (330, 560, 380, 700), 'piliers': (160, 418, 260, 452), 'escalier': (720, 545, 880, 655)}


def cloud_rule(x):
    """Nuages clairs : même règle sur D30P42A entière et sur le calque des nuages."""
    r, g, b = x[..., 0], x[..., 1], x[..., 2]
    return (g > 172) & (r > 186) & (b < 150)


def fidelity(D, scene0):
    x = np.array(scene0.convert('RGB')).astype(int); out = {}
    for nm, (code, (y0, x0, y1, x1)) in REF_BOXES.items():
        r_ = rgb(REFS[code])[y0:y1, x0:x1].reshape(-1, 3).mean(0)
        b0, a0, b1, a1 = [int(round(v * S)) for v in RAW_BOXES[nm]]
        a0 -= JM.CROP_X; a1 -= JM.CROP_X
        o_ = x[b0:b1, a0:a1].reshape(-1, 3).mean(0)
        out[nm] = {'ref': code, 'boite_ref_y0x0y1x1': [y0, x0, y1, x1], 'boite_scene_y0x0y1x1': [b0, a0, b1, a1],
                   'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                   'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    ref = rgb(REFS['D30P42A']); c0 = D['cf'][0]; cl = c0[c0[..., 3] == 255][:, :3].astype(int)
    mr, mc = cloud_rule(ref), cloud_rule(cl)
    r_, o_ = ref[mr].mean(0), cl[mc].mean(0)
    out['nuages'] = {'ref': 'D30P42A', 'regle': '(G > 172) et (R > 186) et (B < 150), image entiere / calque des nuages',
                     'part_ref': round(float(mr.mean()), 3), 'part_calque': round(float(mc.mean()), 3),
                     'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                     'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    out['ciel'] = {'ref': 'D30P42A', 'ref_rgb': list(SKY), 'rgb': list(SKY), 'distance': 0.0, 'note': 'ton ROM repris tel quel'}
    out['methode'] = ('boites de meme matiere verifiees dans la reference et dans le brut (briques et piliers D30P42A, escalier '
                      'D28P33A) ; nuages : meme regle de couleur sur D30P42A entiere et sur le calque ; moyennes comparees')
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['briques', 'piliers', 'escalier', 'nuages']
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['autel'],
                                                'source': markers['centre']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Colonnes Lances - ruines (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Map generee 4:3 (ref. D30P42A + D28P33A) : sommet en ruine facon Colonnes Lances, cercle de '
                    'huit colonnes (plusieurs brisees, trois couchees), autel a vitrail au nord (loi de palette ROM 12 x 10), '
                    'grand escalier au sud, mer de nuages qui derive, rochers en levitation, eclats de lumiere. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'autel', 'source': 'centre'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Colonnes Lances (ruines) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "map generee au format 4:3 (ref. D30P42A + D28P33A), sommet en ruine facon Colonnes Lances, mer de nuages")
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
    masks = dict(ex, vitrail=D['glass'], ciel_visible=D['allowed'], **D['sub'])
    for k, v in masks.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    stack_named = [('ciel', [layers['ciel']], 60), ('nuages', D['cf'], CLOUD_TICKS), ('sol', [layers['sol']], 60),
                   ('ruines', [layers['ruines']], 60), ('rochers', D['rkf'], ROCK_TICKS), ('vitrail', D['gf'], GLASS_TICKS),
                   ('eclats', D['mf'], MOTE_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            w = 3 if len(frames) > 100 else 2
            fn = fn.replace('fNN', 'f' + 'N' * w)
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('N' * w, f'{t:0{w}d}'))
        files[nm] = fn
    walk = layers['sol'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    ex_ = min(col_bottom, key=lambda c: abs(c * 8 + 8 - W // 2)); entrance = [ex_ * 8, H - 16]
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    autel = nearest_reach(reach, (int(598 * S) - JM.CROP_X, int(262 * S)))                # devant les marches de l'autel
    centre = nearest_reach(reach, (int(598 * S) - JM.CROP_X, int(470 * S)))               # milieu du cercle de colonnes
    markers = {'entrance': entrance, 'autel': autel, 'centre': centre}
    paths = {}
    for k in ('autel', 'centre'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ANIM[title]) % len(frames)] if title in ANIM else frames[0]))
        return im
    scenes = [scene(t * 10) for t in range(LOOP_TICKS // 10)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    fid = fidelity(D, scenes[0])
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(10 * 1000 / 60), loop=0, quality=90, method=4)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('autel', (60, 220, 255, 255)), ('centre', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    ys, xs = np.nonzero(D['glass'])                                                        # zoom autel, 4 instants
    cx0, cy0 = max(int(xs.mean()) - 75, 0), max(int(ys.mean()) - 60, 0)
    z = Image.new('RGB', (4 * 300, 300), (20, 20, 20))
    for j, t in enumerate((0, 30, 60, 90)):
        z.paste(scene(t).crop((cx0, cy0, cx0 + 150, cy0 + 150)).convert('RGB').resize((300, 300), Image.NEAREST), (j * 300, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_autel.png')
    BM.write_ora(OUT / f'{PFX}_colonnes_lances_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'Colonnes Lances (ruines du sommet)', 'biome': 'sommet en ruine dans une mer de nuages',
        'demande': ["lance toi je veux que tu genere les colonne de magma etc et je veux une map style colonne lance ruin etc avec "
                    "les texture pmd"],
        'choix_agent': {'references': 'D30P42A (sommet intact : briques, colonnes cannelees, autel a vitrail, rochers, nuages dores) '
                                      '+ D28P33A (grand escalier a balustres) ; decoupes de style seulement, sans leurs compositions',
                        'layout': 'plateforme de briques flottante ; cercle de huit colonnes (brisees ou debout) et trois colonnes '
                                  'couchees autour de l esplanade ; autel a vitrail au nord sur une terrasse haute ; grand escalier '
                                  'a balustres au sud (arrivee) ; mer de nuages et rochers en levitation autour',
                        'animations': 'vitrail a la loi ROM ; nuages qui derivent ; rochers qui flottent ; eclats de lumiere '
                                      'qui montent de l autel',
                        'noms_de_lieux': 'non affirmes (prefixe dNN non fiable), seuls les codes ROM comptent'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendus generes references (decor : 2 decoupes de style x2 ; nuages : 1 decoupe x3), ciel en magenta pur '
                  'remplace par le ton ROM et des nuages animes ; obstacles mesures a la main sur le brut',
        'references_da': {k: {'fichier': str(p.relative_to(R)), 'sha256': sha(p), 'source': 'recuperer_maps.py rom (pret/pmd-sky c8073235)'}
                          for k, p in REFS.items()},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': STYLE, 'utilise': True, 'editions': 0, 'note': 'premier rendu garde tel quel'},
                       {'file': f'source/{LOT}/bruts/nuages_magenta.png', 'sha256': sha(RAW / 'nuages_magenta.png'), 'size': list(SRC),
                        'images': STYLE_NUAGES, 'utilise': True, 'editions': 0, 'note': '4 bandes de nuages festonnes sur magenta'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe ; palettes : sol commune 96, ruines 64, rochers 24, nuages 16 ; '
                                     'ciel, vitrail et eclats aux tons ROM'},
        'segmentation': {'magenta': 'R > 200, B > 200, G < 80',
                         'vide': 'composantes magenta touchant un bord (liseré rose R - G > 45 et B - G > 35 a moins de 3 px '
                                 'compris), dilatees 1',
                         'nuages': 'hors magenta, liseré rose compris, dilate 1',
                         'rochers': 'composantes hors magenta separees de la plateforme (>= 60 px)',
                         'sol': f'proche de {list(BRICK[0])} (< {BRICK[1]}), lisse 11 (> 0,6), ouvert 3, au sud de y = {UPPER_Y} '
                                f'(terrasse haute exclue), + escalier central {list(STAIRS)}, - obstacles, + trous de moins de 400 px',
                         'obstacles_mesures': {'colonnes_debout': PILLARS, 'colonnes_couchees': FALLEN, 'autel': list(ALTAR)},
                         'vitrail': 'bloc de l autel, G > R + 60, G > B + 20, G > 110',
                         'ruines': 'le reste de la plateforme (colonnes, autel, terrasse haute, balustres, bords rocheux, corbeaux)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'ciel': {'ton': list(SKY), 'source': 'D30P42A (ciel uni)'},
        'nuages': {'phases': CLOUD_PHASES, 'frame_length_ticks': CLOUD_TICKS, 'pas_px': CLOUD_STEP, 'periode_px': CLOUD_P,
                   'echelle_brut': CLOUD_SCALE, 'fondu_px': CLOUD_SEAM, 'bandes_brut_lignes': D['spans'], 'hauteurs': D['heights'],
                   'rangees': [{'haut': t, 'bande': b, 'decalage_x': d} for t, b, d in CLOUD_ROWS], 'palette': D['cpal'].tolist(),
                   'loi': 'x_source = (x + decalage + 4 t) mod 480 : derive vers l ouest, une periode par boucle (20 s) ; '
                          'dessines seulement dans les cases ou le ciel se voit'},
        'vitrail': {'phases': GLASS_PHASES, 'frame_length_ticks': GLASS_TICKS, 'source': 'D30P42A (seul element anime de la map)',
                    'tons_rom': [list(c) for c in ROM_TONES], 'rampes_indices': RAMP, 'pixels_a': int(D['ga'].sum()),
                    'pixels_b': int(D['gb'].sum()), 'loi': 'verts du rendu classes par rang de luminance : tiers sombre fixe, tiers moyen rampe a, tiers clair rampe b, en phase'},
        'rochers': {'phases': ROCK_PHASES, 'frame_length_ticks': ROCK_TICKS, 'liste': D['rocks'],
                    'loi': 'dy = round(amp sin(2 pi (t - phase) / 30)), amp 1 ou 2 px'},
        'eclats': {'phases': MOTE_PHASES, 'frame_length_ticks': MOTE_TICKS, 'liste': D['motes'], 'tons': [list(c) for c in MOTE_TONES],
                   'loi': 'montent de 42 px sur leur vie (36-49 pas), oscillent de 2 px, 2 x 2 puis 1 px, palissent (tons ROM du vitrail)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; colonnes, autel, terrasse haute, balustres, bords et ciel bloquants',
                   'autel': 'devant les marches de l autel (evenement a scripter)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items() if isinstance(v, dict)}, 'markers': markers,
                      'rochers': len(D['rocks']), 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
