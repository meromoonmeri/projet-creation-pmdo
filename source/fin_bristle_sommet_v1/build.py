"""Fin Bristle (FBS1) — cinquième zone de fin de donjon de la série des entrées : sommet de Mt. Bristle, 4:3 (768 x 576).

.venv/bin/python source/fin_bristle_sommet_v1/build.py

Vraie fin : Mt. Bristle Peak, où les héros battent Drowzee pour sauver Azurill (Bulbapedia). La salle n'est disponible qu'en
vignette de 110 x 120 px (mysterydungeonwiki) : une clairière de sable carrée, fermée de rochers gris en pointes, ouverte
au sud. Elle sert de référence de composition ; les textures viennent de Mt_Bristle_entrance_TD.png.

- Décor : rendu généré référencé (images = [Mt_Bristle_entrance_TD.png]) ; la vignette agrandie, donnée au premier essai,
  rendait des rochers flous : essai écarté, composition décrite en texte.
- Sol complet : sable seul généré depuis une découpe propre du sable du rip.
- Animations : touffes au vent (poses et cycle de l'entrée Bristle EBN1, 12 x 10, rafale d'ouest) ; rafales de sable :
  traînées qui naissent, filent vers l'est et s'éteignent (24 x 5, chaque traînée refait le même trajet : boucle exacte).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_bristle_sommet_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_bristle_sommet'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fbs1_fin_bristle_sommet'
PFX = 'FBS1'
REF = 'Mt_Bristle_entrance_TD.png'
REF_FIN = 'reference/Explorers_TD_-_Mt._Bristle_Peak_110px.png'
REF_FIN_URL = 'https://mysterydungeonwiki.com/wiki/Explorers_TD:Mt._Bristle'
SOL_REF_CROP = (220, 190, 340, 262)        # sable propre du rip (x0, y0, x1, y1), donné x4 au générateur
ROCK_REF_CROP = (0, 0, 552, 150)           # falaises du rip (pixels gris seulement)

W, H = 768, 576
SRC = (1200, 896)
TUFT_TICKS = 10
RAF_PHASES, RAF_TICKS = 24, 5
RAF_VIS = 12                               # phases visibles sur 24 (le reste : éteinte, elle revient au départ sans être vue)
RAF_STEP = 8                               # px par phase vers l'est
N_RAF = 44
RAF_WHITE = (0.5, 0.25)                   # tête, queue : part de blanc ajoutée au ton le plus clair du sable (sinon invisibles)
LOOP_TICKS = 120
FIDELITY_MAX = 35
ROCK_FIDELITY_MAX = 25
# Seuils (mesures sur le brut) : roche sat ~5-30, sable sat ~80, blocs bruns sat > 95 et lum < 180.
GREY_SAT = 40
TUFT_DIL = 3                               # dilatation du masque des touffes (1 laissait un anneau de pixels de contour)
BOULDER_SAT, BOULDER_LUM = 95, 180


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
EB = loadmod('ebn1_bristle', R / 'source/entree_bristle_sud_nord_v1/build.py')   # tuft_poses, keep_large
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
TUFT_PHASES = EB.TUFT_PHASES
TCELL = EB.TCELL
assert LOOP_TICKS % (TUFT_PHASES * TUFT_TICKS) == 0 and LOOP_TICKS % (RAF_PHASES * RAF_TICKS) == 0


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
    green = (g > r + 10) & (g > b + 10)
    tuft = nd.binary_dilation(EB.keep_large(nd.binary_closing(green, iterations=2), 30), iterations=TUFT_DIL)
    grey = nd.uniform_filter((sat < GREY_SAT).astype(float), 7) > 0.5
    rock = EB.keep_large(morph(nd.binary_opening, grey, 2), 2500)
    sandish = ~(rock | tuft)
    boulder = (sat > BOULDER_SAT) & (lum < BOULDER_LUM) & sandish
    boulder = EB.keep_large(nd.binary_closing(boulder, iterations=2), 80)
    boulder = nd.binary_fill_holes(nd.binary_dilation(boulder, iterations=2)) & sandish
    s2 = sandish & ~boulder
    s2 = morph(nd.binary_opening, s2, 2)
    lab, _ = nd.label(s2); bottom = [v for v in np.unique(lab[-3:]) if v]
    sand = np.isin(lab, bottom)
    # touffes et blocs isolés dans la roche (hors de la clairière) -> falaises
    reach = nd.binary_dilation(sand, iterations=6)
    lab_t, n_t = nd.label(tuft); tuft = np.isin(lab_t, [i for i in range(1, n_t + 1) if (reach & (lab_t == i)).any()])
    lab_b, n_b = nd.label(boulder); boulder = np.isin(lab_b, [i for i in range(1, n_b + 1) if (reach & (lab_b == i)).any()])
    rock = ~(sand | tuft | boulder)                                        # replats bruns et roche : complément exact
    return dict(sand=sand, boulder=boulder, tuft=tuft, rock=rock)


# ---------------------------------------------------------------- rafales de sable
def gust_frames(sand_vis, sand_layer, rng):
    """Traînées de 1 px de haut : naissance (2 px), course (4-6 px, ton clair + queue), extinction ; 8 px/phase vers l'est."""
    px = sand_layer[sand_layer[..., 3] == 255][:, :3].astype(int)
    lum = px @ [.299, .587, .114]
    top = px[np.argsort(lum)[-max(1, len(px) // 200)]]                                     # ton le plus clair du sable (99,5 %)
    light = tuple(int(round(v + RAF_WHITE[0] * (255 - v))) for v in top)                 # poussière claire : vers le blanc
    mid = tuple(int(round(v + RAF_WHITE[1] * (255 - v))) for v in top)
    ok = nd.binary_erosion(sand_vis, iterations=3)
    ys, xs = np.nonzero(ok); gusts = []; taken = np.zeros((H, W), bool)
    span = RAF_STEP * RAF_VIS + 8
    for i in rng.permutation(len(ys)):
        y, x = int(ys[i]), int(xs[i])
        if x + span >= W or taken[y, x] or not ok[y, x:x + span].mean() > 0.9:
            continue
        gusts.append({'depart': [x, y], 'phase': int(rng.integers(RAF_PHASES)), 'longueur': int(rng.integers(4, 7)),
                      'ondulation': float(rng.uniform(0, 2 * np.pi))})
        taken[max(0, y - 10):y + 11, max(0, x - 40):x + span] = True
        if len(gusts) == N_RAF:
            break
    frames = []
    for t in range(RAF_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for gd in gusts:
            k = (t - gd['phase']) % RAF_PHASES
            if k >= RAF_VIS:
                continue
            x0, y0 = gd['depart']
            x = x0 + RAF_STEP * k; y = y0 + int(round(1.5 * np.sin(2 * np.pi * k / RAF_VIS + gd['ondulation'])))
            n = 2 if k in (0, RAF_VIS - 1) else (3 if k in (1, RAF_VIS - 2) else gd['longueur'])
            for j in range(n):
                c = mid if (j < n // 2 or n <= 2) else light                           # queue douce, tête claire
                e[y, x + j] = (*c, 255)
        e[~sand_vis] = 0
        frames.append(e)
    return frames, gusts, {'claire': list(light), 'douce': list(mid)}


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    order = ['sand', 'boulder', 'tuft', 'rock']
    ex, cols = JM.down_class(a, m, order)
    lab, n = nd.label(ex['sand']); sizes = nd.sum(ex['sand'], lab, range(1, n + 1))
    speck = ex['sand'] & (lab != int(np.argmax(sizes)) + 1)                # miettes de sable dans la roche (réduction)
    if speck.any():
        full = JM.down_full(a); ex['sand'] = ex['sand'] & ~speck; ex['rock'] = ex['rock'] | speck
        cols['rock'][speck] = full[speck]
    names = {'sand': 'sable', 'boulder': 'rochers', 'rock': 'falaises'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool))}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    sand_vis = layers['sable'][..., 3] == 255
    gf, gusts, gpal = gust_frames(sand_vis, layers['sable'], np.random.default_rng(3))
    poses, cycle, tpal = EB.tuft_poses(a, m['tuft'])
    lab, n = nd.label(m['tuft']); tufts = []
    tf = [np.zeros((H, W, 4), 'uint8') for _ in range(TUFT_PHASES)]
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        bx, by = int(round(xs.mean() * S)) - JM.CROP_X, int(round(ys.max() * S))
        x0, y0 = bx - TCELL // 2, by - TCELL + 1
        assert 0 <= x0 and x0 + TCELL <= W and 0 <= y0 and y0 + TCELL <= H
        off = (bx // 64) % TUFT_PHASES                                       # rafale d'ouest : la phase avance vers l'est
        tufts.append({'base_xy': [bx, by], 'decalage': off})
        for t in range(TUFT_PHASES):
            img = poses[cycle[(t - off) % TUFT_PHASES]]['img']; mm = img[..., 3] > 0
            tf[t][y0:y0 + TCELL, x0:x0 + TCELL][mm] = img[mm]
    return dict(n_speck=int(speck.sum()), a=a, m=m, ex=ex, layers=layers, gf=gf, gusts=gusts, gpal=gpal, tf=tf, tufts=tufts, poses=poses,
                cycle=cycle, tpal=[[int(v) for v in c] for c in tpal])


def fidelity(layers):
    rip = rgb(R / REF)
    x0, y0, x1, y1 = SOL_REF_CROP
    ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0)
    ours = layers['sable'][layers['sable'][..., 3] == 255][:, :3].astype(float).mean(0)
    fin = rgb(HERE / REF_FIN)
    fin_sand = fin[30:90, 25:85].reshape(-1, 3).mean(0)                     # sable de la vignette de la vraie salle
    x0, y0, x1, y1 = ROCK_REF_CROP; rr = rip[y0:y1, x0:x1].reshape(-1, 3)
    rr = rr[(rr.max(1) - rr.min(1)) < GREY_SAT].astype(float).mean(0)
    fal = layers['falaises'][layers['falaises'][..., 3] == 255][:, :3]
    fal = fal[(fal.max(1).astype(int) - fal.min(1)) < GREY_SAT].astype(float).mean(0)
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'ref_sable_rgb': r1(ref), 'sable_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'vignette_sommet_sable_rgb': r1(fin_sand), 'distance_vignette': round(float(np.linalg.norm(fin_sand - ours)), 2),
            'seuil': FIDELITY_MAX,
            'ref_roche_grise_rgb': r1(rr), 'falaises_grises_rgb': r1(fal), 'distance_roche': round(float(np.linalg.norm(rr - fal)), 2),
            'seuil_roche': ROCK_FIDELITY_MAX}


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['azurill']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Bristle - sommet de Mt. Bristle (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Mt. Bristle Peak, textures de l entree Mt. Bristle) ; clairiere de sable '
                    'fermee de rochers, touffes au vent et rafales de sable animees. Arrivee au sud, arene (boss), Azurill au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'azurill'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Bristle (sommet de Mt. Bristle) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (ref. Mt. Bristle Peak), clairiere de sable, touffes au vent, rafales de sable animees")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_touffes']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/rafales', 'animation/touffes', 'poses_touffes', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers)
    assert fid['distance'] < FIDELITY_MAX and fid['distance_roche'] < ROCK_FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for i, p in enumerate(D['poses']):
        Image.fromarray(p['img']).save(OUT / 'poses_touffes' / f'{PFX}_touffe_{i:02d}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('sable', [layers['sable']], 60),
                   ('rafales', D['gf'], RAF_TICKS), ('rochers', [layers['rochers']], 60),
                   ('touffes', D['tf'], TUFT_TICKS), ('falaises', [layers['falaises']], 60)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = (layers['sable'][..., 3] == 255) | ex['tuft']                    # les touffes se traversent
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
    col = walk[:, W // 2 - 24:W // 2 + 24].any(1)
    top = int(np.nonzero(col)[0].min())
    azurill = free_near(W // 2 - 8, top + 8)                                # fond nord de la clairière
    markers = {'entrance': entrance, 'boss': boss, 'azurill': azurill}
    paths = {}
    for k in ('boss', 'azurill'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'rafales': RAF_TICKS, 'touffes': TUFT_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('azurill', (60, 160, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_bristle_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Bristle (Mt. Bristle -> Mt. Bristle Peak)',
        'entree_correspondante': ['entree_bristle_sud_nord_v1'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'continue !'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Bristle apres Givre (reprise apres les lots magma et FGG2)',
                        'layout': 'comme la vraie salle : clairiere de sable carree fermee de rochers, arrivee au sud par un couloir, '
                                  'arene (boss : Drowzee), Azurill au fond nord ; aucune sortie',
                        'animations': 'touffes au vent de EBN1 et rafales de sable (sommet expose au vent)',
                        'reference': 'vraie fin en vignette 110 px -> composition et palette ; textures de ' + REF},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet (sans liquide, pas de magenta), sol complet genere depuis une decoupe du sable du rip',
        'reference_da': [REF, f'source/{LOT}/{REF_FIN}'], 'reference_fin_source': REF_FIN_URL,
        'reference_fin_boss': 'Bulbapedia, Mt. Bristle : a Mt. Bristle Peak, les heros battent Drowzee pour sauver Azurill',
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC), 'images': [REF]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP)) + ' x4']}],
        'bruts_ecartes': [{'essai': 'decor avec la vignette agrandie x4 en seconde image', 'raison': 'rochers flous (gros pixels de la vignette)'},
                          {'essai': 'decor au rip seul, premier prompt', 'raison': '1376 x 768 (pas 4:3) et chemin ouvert au nord'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs'},
        'segmentation': {'touffes': f'vert (G > R + 10 et G > B + 10), fermeture 2, >= 30 px, dilatation {TUFT_DIL}',
                         'roche': f'fraction de pixels de saturation < {GREY_SAT} lissee sur 7 px > 0,5, ouverture 2, >= 2500 px',
                         'rochers': f'saturation > {BOULDER_SAT} et lum < {BOULDER_LUM} sur le sable, >= 80 px, trous rebouches',
                         'sable': 'composante reliee au bas de l image ; touffes et blocs isoles dans la roche -> falaises',
                         'falaises': 'complement exact (roche grise et replats bruns)',
                         'miettes': f'{D["n_speck"]} px de sable isoles apres reduction -> falaises (couleur de l image reduite)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'rafales': {'phases': RAF_PHASES, 'frame_length_ticks': RAF_TICKS, 'visibles': RAF_VIS, 'pas_px': RAF_STEP,
                    'nombre': len(D['gusts']), 'couleurs': D['gpal'], 'placements': D['gusts'],
                    'loi': 'x = x0 + 8 k, y = y0 + round(1.5 sin(2 pi k / 12 + phi)), k = (t - phase) mod 24, visible si k < 12 ; '
                           'longueur 2, 3, L..., 3, 2', 'origine': 'calcule ; ton le plus clair du calque sable mele de blanc', 'part_de_blanc': list(RAF_WHITE)},
        'touffes': {'phases': TUFT_PHASES, 'frame_length_ticks': TUFT_TICKS, 'poses': len(D['poses']), 'cycle': D['cycle'],
                    'palette': D['tpal'], 'placements': D['tufts'],
                    'origine': 'planche generee de l entree Bristle (source/entree_bristle_sud_nord_v1/bruts/touffes_vent_poses.png), '
                               'tuft_poses de EBN1 ; palette des touffes de ce decor'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sable et touffes'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'touffes': len(D['tufts']), 'rafales': len(D['gusts']),
                      'cycle': D['cycle'], 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
