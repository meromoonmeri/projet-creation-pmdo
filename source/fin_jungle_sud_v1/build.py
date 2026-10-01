"""Fin Jungle (FJS1) — sixième zone de fin de donjon de la série des entrées : fond de Southern Jungle, 4:3 (768 x 576).

.venv/bin/python source/fin_jungle_sud_v1/build.py

Vraie fin : Southern_Jungle_exit_S.png (PMD Sky, épisode spécial 4 « Here Comes Team Charm! ») : clairière de sable jaune
olive, pelouse verte à gauche, rocher gris au fond, fougères, palmes et troncs, canopée très sombre au premier plan.

- Décor : rendu généré référencé en trois étapes, toutes avec la référence :
  1) décor 4:3 (sable rose et pelouse fluo : couleurs refusées, image non gardée) ;
  2) recoloration vers le sable et l'herbe de la référence (bruts/decor_etape_recolore.png) ;
  3) bord gauche fermé par des buissons (la pelouse touchait le bord) -> bruts/decor.png.
- Sol complet : sable seul généré depuis une découpe propre du sable de la référence.
- Calques : sol complet, sable, pelouse, feuilles (anim), rocher, jungle, papillons (anim), canopée (premier plan).
- Animations : feuilles qui tombent de la jungle dans la clairière (48 x 5, chaque feuille refait sa chute : boucle exacte) ;
  papillons de l'entrée Jungle EJN1 (poses générées, boucles en huit fermées, 48 x 5).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_jungle_sud_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_jungle_sud'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fjs1_fin_jungle_sud'
PFX = 'FJS1'
REF = 'Southern_Jungle_exit_S.png'
SOL_REF_CROP = (300, 190, 400, 240)        # sable propre de la référence, donné x4 au générateur
LAWN_REF_CROP = (20, 220, 120, 260)        # pelouse de la référence

W, H = 768, 576
SRC = (1200, 896)
FLY_PHASES, FLY_TICKS = 48, 5
LEAF_PHASES, LEAF_TICKS = 48, 5
LEAF_FALL = 20                             # phases de chute visibles
LEAF_REST = 6                              # phases posée au sol avant de s'effacer
N_LEAVES = 14
LOOP_TICKS = 240
FIDELITY_MAX = 35
# Seuils (mesures sur le brut) : sable (172, 167, 96) écart-type 6 ; pelouse (97, 152, 79) ; buissons (44, 63, 34) ;
# canopée (1, 31, 24) ; rocher gris (124, 132, 116) très texturé ; palmes (12, 106, 29).
CANOPY_LUM = 42
ROCK_COLORS = 16
FLIGHTS = [((250, 300), (70, 40), 0, 'jaune'), ((520, 260), (80, 50), 17, 'bleu'), ((380, 390), (60, 36), 31, 'jaune'),
           ((600, 380), (55, 45), 8, 'bleu'), ((330, 180), (60, 30), 40, 'bleu'), ((540, 160), (70, 35), 24, 'jaune')]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba, butterfly_poses
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora, keep_large
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
BCELL = JM.BCELL
assert LOOP_TICKS % (FLY_PHASES * FLY_TICKS) == 0 and LOOP_TICKS % (LEAF_PHASES * LEAF_TICKS) == 0


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    sandc = (r > 120) & (g > 120) & (b < 140) & (r - b > 40) & (np.abs(r - g) < 35)
    sand = nd.uniform_filter(sandc.astype(float), 7) > 0.5
    lawnc = (g > r + 25) & (g > b + 40) & (lum > 105)
    lawn = nd.uniform_filter(lawnc.astype(float), 9) > 0.6
    greyc = (sat < 35) & (lum > 75) & (lum < 240)
    floor0 = morph(nd.binary_closing, sand | lawn, 4)
    floor0 = nd.binary_fill_holes(floor0)                                  # cailloux et rocher enclavés
    lab, _ = nd.label(morph(nd.binary_opening, floor0, 3)); bottom = [v for v in np.unique(lab[-3:]) if v]
    floor = np.isin(lab, bottom)
    # rocher gris : pixels gris du sol, plus grande composante (le rocher du fond), trous rebouchés
    rk = nd.binary_opening(nd.binary_closing(greyc, iterations=3), iterations=2)
    lab_r, n_r = nd.label(rk); near = nd.binary_dilation(floor, iterations=6)
    sizes = nd.sum(rk & near, lab_r, range(1, n_r + 1))                    # composante grise qui touche le sol
    rock = nd.binary_fill_holes(lab_r == int(np.argmax(sizes)) + 1)
    rock = nd.binary_dilation(rock, iterations=3)                          # contour sombre compris
    floor &= ~rock
    lawn_f = floor & morph(nd.binary_opening, lawn & ~sand | (lawn & (g > r + 25)), 1)
    lawn_f = BM.keep_large(lawn_f, 2000)
    sand_f = floor & ~lawn_f
    dark = nd.uniform_filter(lum, 5) < CANOPY_LUM
    lab_c, n_c = nd.label(dark & ~floor & ~rock)
    border = set(np.unique(np.concatenate([lab_c[0], lab_c[-1], lab_c[:, 0], lab_c[:, -1]]))) - {0}
    canopy = np.isin(lab_c, list(border)); canopy = BM.keep_large(canopy, 5000)
    jungle = ~(floor | rock | canopy)
    return dict(sand=sand_f, lawn=lawn_f, rock=rock, jungle=jungle, canopy=canopy)


# ---------------------------------------------------------------- feuilles qui tombent
def leaf_sprites(pal):
    """Deux poses 6 x 4 (feuille de face, feuille de biais) dans 3 tons de palmes du décor (clair, moyen, sombre)."""
    c, m, d = pal
    A = [[0, 0, c, c, 0, 0], [0, c, c, m, m, 0], [d, m, m, m, d, 0], [0, 0, d, d, 0, 0]]
    B = [[0, 0, 0, 0, c, 0], [0, 0, c, c, m, 0], [0, c, m, m, d, 0], [d, d, d, 0, 0, 0]]
    out = []
    for P in (A, B):
        e = np.zeros((4, 6, 4), 'uint8')
        for y in range(4):
            for x in range(6):
                if P[y][x]:
                    e[y, x] = (*P[y][x], 255)
        out.append(e)
    return out


def leaf_frames(decor, jungle_m, sand_vis, floor_vis, rng):
    lum = decor @ [.299, .587, .114]
    g = decor[..., 1].astype(int); r = decor[..., 0].astype(int)
    leafy = decor[jungle_m & (g > r + 50) & (lum > 60)]                     # palmes et fougères vertes du décor
    order = np.argsort(leafy @ [.299, .587, .114])
    pal = [tuple(int(v) for v in leafy[order[int(len(order) * q)]]) for q in (0.97, 0.7, 0.3)]
    spr = leaf_sprites(pal)
    edge = sand_vis & nd.binary_dilation(~floor_vis, iterations=10) & ~nd.binary_dilation(~sand_vis, iterations=3)
    edge[H - 170:] = False                                                  # elles tombent des arbres du fond et des côtés
    ys, xs = np.nonzero(edge); leaves = []; taken = np.zeros((H, W), bool)
    fall_h = 2 * LEAF_FALL
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if taken[y, x] or y + fall_h + 5 >= H or not (6 <= x < W - 12):
            continue
        path = sand_vis[y:y + fall_h + 4, max(0, x - 6):x + 12]
        if path.mean() < 0.95:
            continue
        leaves.append({'depart': [x, y], 'phase': int(rng.integers(LEAF_PHASES)), 'sens': int(rng.choice([-1, 1]))})
        taken[max(0, y - 30):y + 30, max(0, x - 30):x + 30] = True
        if len(leaves) == N_LEAVES:
            break
    frames = []
    for t in range(LEAF_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for lf in leaves:
            k = (t - lf['phase']) % LEAF_PHASES
            if k >= LEAF_FALL + LEAF_REST:
                continue
            kk = min(k, LEAF_FALL - 1)
            x0, y0 = lf['depart']
            x = x0 + int(round(lf['sens'] * 4 * np.sin(2 * np.pi * kk / 10)))      # balancier
            y = y0 + 2 * kk
            sp = spr[0] if k >= LEAF_FALL else spr[(kk // 3) % 2]                  # se retourne en tombant, à plat au sol
            mm = sp[..., 3] > 0; e[y:y + 4, x:x + 6][mm] = sp[mm]
        e[~sand_vis] = 0
        frames.append(e)
    return frames, leaves, [list(c) for c in pal]


# ---------------------------------------------------------------- papillons
def butterfly_frames():
    poses = JM.butterfly_poses()
    bf = [np.zeros((H, W, 4), 'uint8') for _ in range(FLY_PHASES)]; tracks = []
    for (cx, cy), (ax, ay), off, colr in FLIGHTS:
        pts = []
        for t in range(FLY_PHASES):
            u = 2 * np.pi * (t + off) / FLY_PHASES
            x = int(round(cx + ax * np.sin(u))); y = int(round(cy + ay * np.sin(2 * u)))
            p = poses[colr][(t + off) % 6]; mm = p[..., 3] > 0
            x0, y0 = x - BCELL // 2, y - BCELL // 2
            assert 0 <= x0 and x0 + BCELL <= W and 0 <= y0 and y0 + BCELL <= H
            bf[t][y0:y0 + BCELL, x0:x0 + BCELL][mm] = p[mm]; pts.append([x, y])
        tracks.append({'centre': [cx, cy], 'amplitude': [ax, ay], 'decalage': off, 'couleur': colr, 'positions': pts})
    return bf, tracks, poses


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    order = ['sand', 'lawn', 'rock', 'jungle', 'canopy']
    ex, cols = JM.down_class(a, m, order)
    full = JM.down_full(a); n_speck = 0
    for k in ('sand', 'lawn'):                                              # miettes de sol hors de la clairière -> jungle
        fl = ex['sand'] | ex['lawn']; lab, n = nd.label(fl); sizes = nd.sum(fl, lab, range(1, n + 1))
        speck = ex[k] & (lab != int(np.argmax(sizes)) + 1)
        if speck.any():
            ex[k] &= ~speck; ex['jungle'] |= speck; cols['jungle'][speck] = full[speck]; n_speck += int(speck.sum())
    names = {'sand': 'sable', 'lawn': 'pelouse', 'rock': 'rocher', 'jungle': 'jungle', 'canopy': 'canopee'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool))}
    for k, nm in names.items():
        if k != 'rock':
            layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    rk = JM.rgba(cols['rock'], ex['rock'])                                  # rocher : palette propre (les gris virent au sable sinon)
    q = Image.fromarray(rk[..., :3]).quantize(colors=ROCK_COLORS, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    rk[..., :3] = np.array(q.convert('RGB')); rk[~ex['rock']] = 0
    layers['rocher'] = rk
    floor_vis = (layers['sable'][..., 3] == 255) | (layers['pelouse'][..., 3] == 255)
    sand_vis = layers['sable'][..., 3] == 255                              # sur la pelouse, vert sur vert : invisibles
    lf, leaves, lpal = leaf_frames(a_small(a), ex['jungle'], sand_vis, floor_vis, np.random.default_rng(5))
    bf, tracks, poses = butterfly_frames()
    return dict(a=a, m=m, ex=ex, layers=layers, lf=lf, leaves=leaves, lpal=lpal, bf=bf, tracks=tracks, poses=poses,
                n_speck=n_speck)


def a_small(a):
    return JM.down_full(a).astype(int)


def fidelity(layers):
    rip = rgb(R / REF)
    out = {}
    for nm, crop in (('sable', SOL_REF_CROP), ('pelouse', LAWN_REF_CROP)):
        x0, y0, x1, y1 = crop
        ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0)
        ours = layers[nm][layers[nm][..., 3] == 255][:, :3].astype(float).mean(0)
        out[nm] = {'ref_rgb': [round(float(v), 1) for v in ref], 'rgb': [round(float(v), 1) for v in ours],
                   'distance': round(float(np.linalg.norm(ref - ours)), 2), 'decoupe_ref': list(crop)}
    out['seuil'] = FIDELITY_MAX
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['objectif']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Jungle - fond de Southern Jungle (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Southern_Jungle_exit_S) ; clairiere de sable et pelouse, rocher gris, '
                    'canopee au premier plan, feuilles qui tombent et papillons animes. Arrivee au sud, arene (boss), objectif au rocher. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'objectif'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Jungle (fond de Southern Jungle) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (ref. Southern Jungle exit), clairiere, canopee, feuilles qui tombent et papillons animes")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_papillons', 'poses_feuilles']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/feuilles', 'animation/papillons', 'poses_papillons', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers)
    assert fid['sable']['distance'] < FIDELITY_MAX and fid['pelouse']['distance'] < FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for nm, seq in D['poses'].items():
        for i, p in enumerate(seq):
            Image.fromarray(p).save(OUT / 'poses_papillons' / f'{PFX}_papillon_{nm}_{i}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('sable', [layers['sable']], 60), ('pelouse', [layers['pelouse']], 60),
                   ('feuilles', D['lf'], LEAF_TICKS), ('rocher', [layers['rocher']], 60), ('jungle', [layers['jungle']], 60),
                   ('papillons', D['bf'], FLY_TICKS), ('canopee', [layers['canopee']], 60)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = (layers['sable'][..., 3] == 255) | (layers['pelouse'][..., 3] == 255)
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
    arena = walk & (np.mgrid[:H, :W][0] < H - 150)
    fy, fx = np.nonzero(arena)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    ry, rx = np.nonzero(ex['rock'])
    objectif = free_near(int(rx.mean()) - 8, (int(ry.max()) + 8) // 8 * 8)     # devant le rocher gris, au sud
    markers = {'entrance': entrance, 'boss': boss, 'objectif': objectif}
    paths = {}
    for k in ('boss', 'objectif'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'feuilles': LEAF_TICKS, 'papillons': FLY_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('objectif', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_jungle_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Jungle (Southern Jungle)',
        'entree_correspondante': ['entree_jungle_sud_nord_v1'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'continue !', 'poursuis !'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Jungle apres Bristle',
                        'layout': 'comme la vraie sortie : clairiere de sable, pelouse a gauche, rocher gris au fond (objectif), '
                                  'jungle dense et canopee au premier plan ; arrivee au sud, arene (boss), aucune sortie',
                        'boss': 'non nomme : Southern Jungle est un donjon de l episode special 4 (Team Charm) ; les sources consultees '
                                'ne s accordent pas sur le combat de fin',
                        'animations': 'feuilles qui tombent (calcul) et papillons de EJN1'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sans cle (pas de liquide), en trois etapes avec la reference ; sol complet genere depuis une decoupe du sable',
        'reference_da': [REF],
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/bruts/decor_etape_recolore.png'], 'etape': 3, 'consigne': 'bord gauche ferme par des buissons'},
                       {'file': f'source/{LOT}/bruts/decor_etape_recolore.png', 'sha256': sha(RAW / 'decor_etape_recolore.png'), 'size': list(SRC),
                        'images': ['decor etape 1 (non garde)', REF], 'etape': 2, 'consigne': 'sable et herbe aux couleurs de la reference'},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP)) + ' x4']}],
        'bruts_ecartes': [{'essai': 'etape 1, decor au rip seul', 'raison': 'sable rose, pelouse vert fluo, pelouse ouverte a gauche ; '
                                                                           'image remplacee par sa recoloration'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'methode': f'moyenne ponderee par classe (BOX), palette commune 96 couleurs ; rocher : palette propre de {ROCK_COLORS} couleurs',
                          'miettes_vers_jungle_px': D['n_speck']},
        'segmentation': {'sable': 'R, G > 120, B < 140, R - B > 40, |R - G| < 35, lisse 7 px > 0,5',
                         'pelouse': 'G > R + 25, G > B + 40, lum > 105, lisse 9 px > 0,6, >= 2000 px',
                         'sol': 'sable + pelouse fermes 4 px, trous rebouches, composante reliee au bas',
                         'rocher': 'pixels gris (sat < 35, lum > 75) fermes 3 / ouverts 2, composante qui touche le plus le sol, trous rebouches, dilate 3 px (contour)',
                         'canopee': f'luminance lissee 5 px < {CANOPY_LUM}, composantes touchant le bord, >= 5000 px',
                         'jungle': 'le reste'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'feuilles': {'phases': LEAF_PHASES, 'frame_length_ticks': LEAF_TICKS, 'chute': LEAF_FALL, 'au_sol': LEAF_REST,
                     'nombre': len(D['leaves']), 'couleurs': D['lpal'], 'placements': D['leaves'],
                     'loi': 'k = (t - phase) mod 48 ; chute k < 20 : y = y0 + 2k, x = x0 + sens 4 sin(2 pi k / 10), pose alternee toutes les 3 phases ; '
                            'posee a plat 6 phases puis effacee ; meme trajet a chaque boucle',
                     'origine': 'calcule ; 3 tons des palmes vertes du decor'},
        'papillons': {'phases': FLY_PHASES, 'frame_length_ticks': FLY_TICKS, 'vols': D['tracks'],
                      'origine': 'poses generees de l entree Jungle (source/entree_jungle_sud_nord_v1/bruts/papillons_poses.png), butterfly_poses de EJN1 ; '
                                 'boucles en huit fermees'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sable et pelouse'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'feuilles': len(D['leaves']), 'miettes': D['n_speck'],
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
