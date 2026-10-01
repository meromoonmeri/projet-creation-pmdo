"""Fin Ruine (FRP1) — troisième zone de fin de donjon de la série des entrées, 4:3 (768 x 576, 96 x 72 cases).

Demande : « Choisis ! » après FCF1 -> l'agent poursuit la série dans l'ordre du mod : Ruine.
Référence = la VRAIE fin du jeu : Sealed_Ruin_pit_TDS.png (fosse de Sealed Ruin, grands blocs gris).
Dans le jeu, les héros y trouvent une Clé de voûte étrange (Odd Keystone) qui se révèle être Spiritomb.
Layout : arrivée au sud entre deux rochers plats (marqueur `entrance`), arène (marqueur `boss`), clé de voûte dans la
niche nord = objectif (marqueur `cle_de_voute`, devant la pierre). Aucune sortie, aucun warp.

Méthode (rendu généré RÉFÉRENCÉ) :
- décor : blocs générés avec le rip en images=, sol = magenta ;
- sol complet : généré à partir d'une découpe serrée du sol du rip (SOL_REF_CROP) — deux essais avec le rip entier
  sont revenus vides ;
- clé de voûte : objet généré sur magenta, réduit à CLE_W px, posée à l'embouchure de la niche nord ;
- animations, chacune sur son calque, boucles fermées :
  aura violette au sol autour de la pierre (6 x 10 ticks, pulsation des braises de ECN1) ;
  tourbillons de poussière de l'entrée Ruine (ERN1 : mêmes poses générées, 8 x 5 ticks) recolorés en gris ;
  fissure de la pierre qui pulse (6 x 10 ticks) ; feux follets violets qui montent de la pierre (24 x 5 ticks).
Scène : PPCM 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_ruine_puits_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_ruine_puits_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_ruine_puits'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'frp1_fin_ruine_puits'
PFX = 'FRP1'
REF = 'Sealed_Ruin_pit_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
SOL_REF_CROP = (220, 130, 440, 360)       # (x0, y0, x1, y1) du rip donnée au générateur pour le sol
GLOW_PHASES, GLOW_TICKS = 6, 10
DEVIL_PHASES, DEVIL_TICKS = 8, 5
WISP_PHASES, WISP_TICKS = 24, 5
LOOP_TICKS = 120
PULSE = [0, 1, 2, 2, 1, 0]                # pulsation des braises de ECN1
CLE_W = 36                                 # largeur de la clé de voûte sur la carte (px)
CLE_BASE_Y = 170                           # bas de la pierre (embouchure de la niche, mesurée : couloir y 129-170)
FIDELITY_MAX = 35
# Violets de la fissure / de l'aura / des feux follets (du plus sombre au plus clair).
VIO = [(58, 34, 78), (92, 52, 128), (136, 78, 188), (182, 124, 232), (226, 190, 255)]
AURA = [(70, 62, 84), (82, 66, 104), (98, 72, 130)]          # voile violet sur le sol gris (sombre -> vif)
DUST = [(76, 76, 80), (88, 88, 92), (102, 102, 106), (118, 118, 122), (136, 136, 140), (156, 156, 160)]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
ER = loadmod('ern1_ruine', R / 'source/entree_ruine_sud_nord_v1/build.py')       # tourbillons de l'entrée Ruine
ER.cr = loadmod('ecn1_utils', R / 'source/entree_cratere_sud_nord_v1/build.py')  # utilitaires attendus par ERN1
ER.cr.W, ER.cr.H = W, H
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')             # Ground de fin (entrance / boss / objectif)
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def is_magenta(a, strict=False):
    r, g, b = a.transpose(2, 0, 1)
    if strict:
        return (r > 200) & (g < 90) & (b > 200)
    return (r - g > 40) & (b - g > 40)       # magenta pur + franges mêlées au magenta


# ---------------------------------------------------------------- décor
def classify(a):
    floor = is_magenta(a)
    floor = nd.binary_opening(floor, iterations=1)
    lab, n = nd.label(floor); sizes = nd.sum(floor, lab, range(1, n + 1))
    floor = lab == int(np.argmax(sizes)) + 1
    floor = nd.binary_fill_holes(floor)
    return {'floor': floor, 'walls': ~floor}


def neutral(col):
    """Parois : retire la teinte violette laissée par le magenta (niche nord) ; le rip est gris neutre."""
    c = col.astype(int); lum = (c @ [.299, .587, .114])
    tint = (np.minimum(c[..., 0], c[..., 2]) - c[..., 1]) > 6
    c[tint] = np.stack([lum, lum, lum + 2], -1)[tint].round().astype(int)
    return np.clip(c, 0, 255).astype('uint8')


# ---------------------------------------------------------------- clé de voûte
def keystone():
    p = rgb(RAW / 'pierre_magenta.png'); r, g, b = p.transpose(2, 0, 1)
    obj = ~is_magenta(p, strict=True) & ~((r - g > 60) & (b - g > 60))
    lab, n = nd.label(obj); sizes = nd.sum(obj, lab, range(1, n + 1)); obj = lab == int(np.argmax(sizes)) + 1
    obj = nd.binary_fill_holes(obj)
    crack = obj & (r - g > 20) & (b - g > 30)
    ys, xs = np.nonzero(obj); y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    f = CLE_W / (x1 - x0); ch = int(round((y1 - y0) * f))
    sub = lambda m: m[y0:y1, x0:x1].astype(np.float32)
    def rs(pl):
        return np.array(Image.fromarray(pl).resize((CLE_W, ch), Image.Resampling.BOX))
    cov = rs(sub(obj)); cc = rs(sub(crack))
    col = np.stack([rs((p[y0:y1, x0:x1, k] * obj[y0:y1, x0:x1]).astype(np.float32)) for k in range(3)], -1) / np.maximum(cov, 1e-6)[..., None]
    m = cov >= 0.5
    cm = m & (cc >= 0.18)                    # la fissure est fine : seuil bas pour la garder continue
    o = np.zeros((ch, CLE_W, 4), 'uint8'); o[..., :3] = np.clip(col.round(), 0, 255); o[m, 3] = 255
    # palette propre à la pierre (16 gris), hors palette commune : la fissure violette survit
    q = Image.fromarray(o[..., :3]).quantize(colors=16, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    o[..., :3] = np.array(q.convert('RGB')); o[~m] = 0
    return o, cm, {'bbox_brut': [int(x0), int(y0), int(x1), int(y1)], 'facteur': round(f, 5), 'taille_px': [CLE_W, ch]}


def pulse_ramp(mask, lum, ramp, base=0):
    """Rang de luminance 0..2 + PULSE sur la rampe (méthode des braises de ECN1)."""
    rank = np.clip(np.digitize(lum, np.percentile(lum[mask], [33, 66])), 0, 2) if mask.any() else np.zeros(mask.shape, int)
    out = []
    for t in range(GLOW_PHASES):
        e = np.zeros((*mask.shape, 4), 'uint8'); idx = np.clip(rank + PULSE[t] + base, 0, len(ramp) - 1)
        for i, c in enumerate(ramp):
            e[mask & (idx == i)] = (*c, 255)
        out.append(e)
    return out


BAYER = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) / 16.0


def aura_frames(cx, cy, floor_free):
    """Voile violet tramé au sol, ellipse autour du pied de la pierre ; la densité suit PULSE."""
    yy, xx = np.mgrid[:H, :W]
    d = np.sqrt(((xx - cx) / 46.0) ** 2 + ((yy - cy) / 22.0) ** 2)
    th = np.tile(BAYER, (H // 4, W // 4))
    out = []
    for t in range(GLOW_PHASES):
        lvl = 0.45 + 0.25 * PULSE[t]
        fall = np.clip(1 - d, 0, 1) * lvl
        lit = floor_free & (th < fall)
        e = np.zeros((H, W, 4), 'uint8')
        tone = np.clip((fall * 5).astype(int), 0, 2)
        for i, c in enumerate(AURA):
            e[lit & (tone == i)] = (*c, 255)
        out.append(e)
    return out


def wisp_sprite(k):
    """Feu follet procédural : 4 tailles (grand 7 x 9 -> trait), cœur clair, bord violet."""
    shapes = {0: ['..oo...', '.oxxo..', 'oxwwxo.', 'oxwwxo.', 'oxwwxo.', '.oxxo..', '..oxo..', '...o...', '....o..'],
              1: ['.oo..', 'oxxo.', 'oxxo.', 'oxxo.', '.oo..', '..o..'],
              2: ['.o.', 'oxo', 'oxo', '.o.'],
              3: ['o', 'o']}
    rows = shapes[k]; s = np.zeros((len(rows), len(rows[0]), 4), 'uint8')
    col = {'w': VIO[4], 'x': VIO[4 if k < 2 else 3], 'o': VIO[3 if k < 2 else 2]}   # clairs : lisibles sur la pierre grise
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch in col:
                s[y, x] = (*col[ch], 255)
    return s


WISP_LIFE = 16                             # 16 phases de montée, 8 au repos
WISP_SIZES = [0] * 6 + [1] * 5 + [2] * 3 + [3] * 2


def wisp_frames(sources):
    out = [np.zeros((H, W, 4), 'uint8') for _ in range(WISP_PHASES)]
    track = []
    for j, (x0, y0, off) in enumerate(sources):
        for t in range(WISP_PHASES):
            k = (t - off) % WISP_PHASES
            if k >= WISP_LIFE:
                continue
            sp = wisp_sprite(WISP_SIZES[k])
            x = int(round(x0 + 4 * np.sin(2 * np.pi * k / 8 + j)))
            y = y0 - 2 * k
            h, w = sp.shape[:2]; mm = sp[..., 3] > 0
            out[t][y - h:y, x:x + w][mm] = sp[mm]
            track.append((j, t, x, y))
    return out, track


# ---------------------------------------------------------------- tourbillons de l'entrée Ruine, recolorés en gris
def devil_poses():
    thin = {p[0] for p in ER.DEVIL_PICKS}
    pal = np.array([ER.PAL['pale'], ER.PAL['clair'], ER.PAL['surface'], ER.PAL['accent'], ER.PAL['inter'], (246, 230, 190)], int)
    devils, _ = ER.extract_poses(ER.RAW / 'tourbillon_8_poses.png', 2, 4, ER.DEVIL_PICKS, 360, ER.DEVIL_CELL, thin, pal)
    ramp = np.array(DUST, int)
    allv = np.concatenate([p[p[..., 3] > 0][:, :3] @ [.299, .587, .114] for p in devils.values()])
    qs = np.percentile(allv, np.linspace(0, 100, len(ramp) + 1)[1:-1])
    for p in devils.values():
        mm = p[..., 3] > 0; lum = p[..., :3].astype(float) @ [.299, .587, .114]
        p[mm, :3] = ramp[np.digitize(lum[mm], qs)]
    return devils


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    ex, cols = JM.down_class(a, m, ['floor', 'walls'])
    floor = ex['floor']
    layers = {'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool)),
              'parois': JM.rgba(neutral(cols['walls']), ex['walls'])}
    # ombre au pied des parois : sol assombri sur 3 px, plus marqué sous les parois (lumière du haut)
    dw = nd.distance_transform_edt(floor)
    below = nd.binary_dilation(ex['walls'], structure=np.array([[0, 1, 0], [0, 1, 0], [0, 0, 0]], bool), iterations=5) & floor
    shade = floor & ((dw <= 3) | below)
    sh = layers['sol_complet'][..., :3].astype(float) * np.where(dw <= 1.5, 0.62, 0.78)[..., None]
    layers['ombre_parois'] = JM.rgba(np.clip(sh.round(), 0, 255).astype('uint8'), shade)
    layers = BM.quantize_layers(layers)
    # clé de voûte à l'embouchure de la niche nord
    stone, crack_m, cle_info = keystone()
    fy, fx = np.nonzero(floor[:CLE_BASE_Y])
    top_cols = fx[fy == fy.min() + 20] if (fy == fy.min() + 20).any() else fx
    cx = int(round(top_cols.mean()))
    sx, sy = cx - CLE_W // 2, CLE_BASE_Y - stone.shape[0]
    cle = np.zeros((H, W, 4), 'uint8'); cle[sy:CLE_BASE_Y, sx:sx + CLE_W] = stone
    cm = np.zeros((H, W), bool); cm[sy:CLE_BASE_Y, sx:sx + CLE_W] = crack_m
    layers['cle_de_voute'] = cle
    lum = cle[..., :3].astype(float) @ [.299, .587, .114]
    ff = pulse_ramp(cm, lum, VIO)                         # fissure : rampe violette pulsée
    stone_m = cle[..., 3] == 255
    floor_free = floor & ~stone_m
    af = aura_frames(cx, CLE_BASE_Y - 4, floor_free)
    wf, track = wisp_frames([(cx - 16, sy + 10, 0), (cx - 3, sy + 4, 8), (cx + 8, sy + 12, 16)])
    # tourbillons : 2 positions sur le sol dégagé de l'arène, hors aura et hors couloir d'arrivée
    devils = devil_poses(); dc = ER.DEVIL_CELL
    yy = np.mgrid[:H, :W][0]
    open_ = floor & ~nd.binary_dilation(~floor, iterations=10) & (yy > CLE_BASE_Y + 40) & (yy < H - 150)
    dtaken = np.zeros((H, W), bool)
    xx = np.mgrid[:H, :W][1]
    dpos = ER.cr.place(open_ & (xx < W // 2 - 40), (dc, dc), 1, 13, dtaken) + ER.cr.place(open_ & (xx > W // 2 + 40), (dc, dc), 1, 14, dtaken)
    df = [np.zeros((H, W, 4), 'uint8') for _ in range(DEVIL_PHASES)]
    for j, (y, x) in enumerate(dpos):
        for t in range(DEVIL_PHASES):
            p = devils[f'tourbillon_{(t + 3 * j) % DEVIL_PHASES}']; mm = p[..., 3] > 0
            df[t][y:y + dc, x:x + dc][mm] = p[mm]
    for fr_ in df:
        fr_[~floor_free] = 0
    return dict(a=a, m=m, ex=ex, layers=layers, floor=floor, stone_m=stone_m, crack=cm, ff=ff, af=af, wf=wf, track=track,
                df=df, dpos=dpos, devils=devils, cle_info=cle_info, cle_xy=[int(sx), int(sy)], cx=cx)


def fidelity(layers, floor, ex):
    rip = rgb(R / REF)
    ref = rip[150:350, 230:420].reshape(-1, 3).mean(0)                    # sol de la fosse du rip
    ours = layers['sol_complet'][floor][:, :3].astype(float).mean(0)
    refw = rip[400:520, 0:200].reshape(-1, 3).mean(0)                     # blocs du rip
    oursw = layers['parois'][ex['walls']][:, :3].astype(float).mean(0)
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'rip_sol_rgb': r1(ref), 'sol_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'rip_parois_rgb': r1(refw), 'parois_rgb': r1(oursw), 'distance_parois': round(float(np.linalg.norm(refw - oursw)), 2),
            'seuil': FIDELITY_MAX}


def ground_project(stack, blocked, markers, gfx, tools):
    """Ground de fin de FVS1, avec les noms de ce lot."""
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['cle_de_voute']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Ruine - fosse de Sealed Ruin (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Sealed Ruin Pit) ; cle de voute dans la niche nord, fissure, aura et '
                    'feux follets violets, tourbillons de l entree Ruine. Arrivee au sud, arene (boss), cle de voute au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'cle_de_voute'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Ruine (fosse de Sealed Ruin) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (ref. Sealed Ruin Pit), arene de blocs, cle de voute qui luit, feux follets et tourbillons animes")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    subs = ['calques', 'animation/aura', 'animation/tourbillons', 'animation/fissure', 'animation/feux_follets', 'poses_tourbillons', 'masques', 'review']
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_tourbillons']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in subs:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers, D['floor'], ex); assert fid['distance'] < FIDELITY_MAX and fid['distance_parois'] < FIDELITY_MAX, fid
    for k, v in {**ex, 'fissure': D['crack'], 'cle_de_voute': D['stone_m']}.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for k, p in D['devils'].items():
        Image.fromarray(p).save(OUT / 'poses_tourbillons' / f'{PFX}_{k}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('ombre_parois', [layers['ombre_parois']], 60),
                   ('aura', D['af'], GLOW_TICKS), ('tourbillons', D['df'], DEVIL_TICKS),
                   ('parois', [layers['parois']], 60), ('cle_de_voute', [layers['cle_de_voute']], 60),
                   ('fissure', D['ff'], GLOW_TICKS), ('feux_follets', D['wf'], WISP_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = D['floor'] & ~D['stone_m']
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
    arena = walk & (np.mgrid[:H, :W][0] < H - 160)
    fy, fx = np.nonzero(arena)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    cle = free_near(D['cx'] - 8, (CLE_BASE_Y + 7) // 8 * 8)          # première case entièrement sous la pierre
    markers = {'entrance': entrance, 'boss': boss, 'cle_de_voute': cle}
    paths = {}
    for k in ('boss', 'cle_de_voute'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'aura': GLOW_TICKS, 'tourbillons': DEVIL_TICKS, 'fissure': GLOW_TICKS, 'feux_follets': WISP_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('cle_de_voute', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_ruine_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Ruine (Sealed Ruin)',
        'entree_correspondante': ['entree_ruine_sud_nord_v1'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'passons a la suite', 'Choisis !'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Ruine apres Cratere',
                        'layout': 'arrivee au sud entre deux rochers plats, arene (boss), cle de voute dans la niche nord (objectif), aucune sortie',
                        'objectif': 'Cle de voute etrange (Odd Keystone) : dans le jeu, les heros la trouvent au fond de Sealed Ruin et elle se revele etre Spiritomb',
                        'reference': 'vraie fin du jeu : ' + REF},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : blocs sur sol magenta, sol complet genere depuis une decoupe du sol du rip, cle de voute generee sur magenta',
        'reference_da': REF,
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC), 'images': [REF]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP))],
                        'origine': 'generateur avec la decoupe (x0, y0, x1, y1) du sol du rip ; deux essais avec le rip entier revenus vides'},
                       {'file': f'source/{LOT}/bruts/pierre_magenta.png', 'sha256': sha(RAW / 'pierre_magenta.png'),
                        'size': list(Image.open(RAW / 'pierre_magenta.png').size), 'images': [REF]}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs ; parois neutralisees (teinte violette de la niche retiree) ; cle de voute : palette propre de 16 couleurs'},
        'segmentation': {'sol': 'r - g > 40 et b - g > 40 (magenta et franges), plus grande composante, trous rebouches', 'parois': 'le reste',
                         'ombre_parois': 'sol a moins de 3 px des parois ou sous une paroi (5 px), assombri x0,62 / x0,78'},
        'cle_de_voute': {**D['cle_info'], 'xy': D['cle_xy'], 'base_y': CLE_BASE_Y, 'fissure_px': int(D['crack'].sum())},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'aura': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'pulsation': PULSE, 'couleurs': [list(c) for c in AURA],
                 'origine': 'voile tramé (Bayer 4x4) en ellipse au pied de la pierre, densite selon la pulsation'},
        'tourbillons': {'phases': DEVIL_PHASES, 'frame_length_ticks': DEVIL_TICKS, 'positions': [[int(x), int(y)] for (y, x) in D['dpos']],
                        'decalages': [3 * j for j in range(len(D['dpos']))], 'couleurs': [list(c) for c in DUST],
                        'origine': 'poses generees de l entree Ruine (source/entree_ruine_sud_nord_v1/bruts/tourbillon_8_poses.png), extract_poses de ERN1, recolorees en gris par rang de luminance'},
        'fissure': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in VIO],
                    'origine': 'pixels de fissure de la pierre, rang de luminance + pulsation (methode des braises de ECN1)'},
        'feux_follets': {'phases': WISP_PHASES, 'frame_length_ticks': WISP_TICKS, 'vie_phases': WISP_LIFE, 'tailles': WISP_SIZES,
                         'decalages': [0, 8, 16], 'montee_px_par_phase': 2, 'couleurs': [list(c) for c in VIO],
                         'origine': 'sprites proceduraux (4 tailles, 7 x 9 au plus), trois emetteurs sur la pierre'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol (la cle de voute bloque)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'cle': manifest['cle_de_voute'], 'devils': D['dpos'],
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
