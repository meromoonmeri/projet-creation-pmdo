"""Fin Givre (FGG1) — quatrième zone de fin de donjon de la série des entrées, 4:3 (768 x 576, 96 x 72 cases).

Demande : « Parfait lance toi ! » après FRP1 -> l'agent poursuit la série dans l'ordre du mod : Givre (Frosty Forest).
Vraie fin : Articuno attend les héros à l'étage 5 de Frosty Grotto, la grotte dont l'entrée Givre (EGN1) montre la
bouche au nord. Cette salle n'existe ici qu'en vignette de 120 px (reference/), trop petite pour les textures :
elle sert à la palette (sol de glace bleu pâle). Textures : pmdskyicearena.png (arène de glace de PMD Sky, racine).
Layout : arrivée au sud par le couloir de glace (marqueur `entrance`), arène (marqueur `boss`), deux bassins d'eau
glacée sur les côtés, grand cristal de glace au nord = objectif (marqueur `cristal`, devant le monticule).
Aucune sortie, aucun warp.

Méthode (rendu généré RÉFÉRENCÉ) :
- décor complet généré avec les deux références en images= (bassins = magenta) ;
- sol complet : généré à partir d'une découpe du sol de pmdskyicearena.png (SOL_REF_CROP) ;
- animations, chacune sur son calque, fonctions de l'entrée Givre (EGN1) :
  eau glacée « façon rivière Métano » (même palette, 4 x 10 ticks), scintillements Métano recolorés (4 x 10),
  flocons générés de l'entrée (48 x 5 ticks) ; lueur du cristal : rampe glacée pulsée 6 x 10 ticks
  (méthode des braises de ECN1).
Scène : PPCM 240 ticks = 4 s.
Lancer : .venv/bin/python source/fin_givre_grotte_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_givre_grotte_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_givre_grotte'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fgg1_fin_givre_grotte'
PFX = 'FGG1'
REF = 'pmdskyicearena.png'
REF_FIN = 'reference/Rescue_Team_-_Articuno_first_appearance_120px.png'
REF_FIN_URL = 'https://mysterydungeonwiki.com/wiki/File:Rescue_Team_-_Articuno_first_appearance.png'
W, H = 768, 576
SRC = (1200, 896)
SOL_REF_CROP = (0, 222, 504, 282)          # (x0, y0, x1, y1) de pmdskyicearena.png donnée au générateur pour le sol
WATER_PHASES, WATER_TICKS = 4, 10
FLAKE_PHASES, FLAKE_TICKS = 48, 5
GLOW_PHASES, GLOW_TICKS = 6, 10
LOOP_TICKS = 240
N_FLAKES = 64                              # 40 sur l'entrée (424 x 632), à densité égale sur 768 x 576
PULSE = [0, 1, 2, 2, 1, 0]
# Seuils mesurés : sol (190, 214, 245) L11 210, écart-type 11 px 0,3 ; flèches L 160 / 32 ; ciel L 145 / 0,7.
FLOOR_L, FLOOR_S = 195, 4
FLOOR_RGB, FLOOR_DIST = np.array([190, 214, 245]), 22
# Cristal + monticule relevés à la main sur le brut 1200 x 896 : centre, demi-axes.
CRYSTAL_RAW = ((600, 262), (118, 98))
FIDELITY_MAX = 35
GLOW_RAMP = [(120, 160, 210), (150, 186, 222), (170, 212, 244), (206, 232, 246), (244, 250, 255)]   # ICE de EGN1 + reflet


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
EG = loadmod('egn1_givre', R / 'source/entree_givre_sud_nord_v1/build.py')       # eau glacée, scintillements, flocons
EG.W, EG.H = W, H                                                                # ses fonctions lisent W/H à l'appel
EG.cr.W, EG.cr.H = W, H                                                          # hash_noise, place
EG.N_FLAKES = N_FLAKES
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')             # Ground de fin (entrance / boss / objectif)
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def to_map(p):
    return int(round(p[0] * S)) - JM.CROP_X, int(round(p[1] * S))


# ---------------------------------------------------------------- segmentation pleine résolution
def morph(fn, m, it):
    """Morphologie sur un masque étendu par répétition du bord : le couloir qui touche le bas n'est pas rongé."""
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    water = nd.binary_dilation(mag, iterations=2)
    L = nd.uniform_filter(lum, 11); Sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 11) - L ** 2, 0))
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    (cx, cy), (ax, ay) = CRYSTAL_RAW
    ell = ((xx - cx) / ax) ** 2 + ((yy - cy) / ay) ** 2 <= 1
    near = np.sqrt(((a - FLOOR_RGB) ** 2).sum(-1)) < FLOOR_DIST                # couleur du sol (flèches : > 60)
    core = ((L > FLOOR_L) & (Sd < FLOOR_S) | near) & ~nd.binary_dilation(water, iterations=3)
    core = morph(nd.binary_opening, core, 2)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = morph(nd.binary_closing, lab == int(np.argmax(sizes)) + 1, 7)    # fissures du couloir avalées
    floor = nd.binary_fill_holes(floor | water) & ~water                 # fissures et rives rebouchées
    floor = morph(nd.binary_opening, floor, 2)
    lab, n = nd.label(floor); sizes = nd.sum(floor, lab, range(1, n + 1)); floor = lab == int(np.argmax(sizes)) + 1
    crystal = ell & ~floor & ~water
    walls = ~floor & ~water & ~crystal
    glow = crystal & (g > 205) & (b > 230) & (r < 215)                   # facettes cyan (la neige blanche reste fixe)
    return dict(water=water, floor=floor, walls=walls, crystal=crystal), glow


def glow_frames(a, glow_full, glow):
    lum_e = JM.down_class(a, {'g': glow_full}, ['g'])[1]['g'].astype(float) @ [.299, .587, .114]
    rank = np.clip(np.digitize(lum_e, np.percentile(lum_e[glow], [33, 66])), 0, 2) if glow.any() else np.zeros((H, W), int)
    out = []
    for t in range(GLOW_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + PULSE[t], 0, 4)
        for i, c in enumerate(GLOW_RAMP):
            e[glow & (idx == i)] = (*c, 255)
        out.append(e)
    return out


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, glow_full = classify(a)
    order = ['water', 'floor', 'walls', 'crystal']
    ex, cols = JM.down_class(a, m, order)
    water = ex['water']
    names = {'floor': 'sol_glace', 'walls': 'parois'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~water)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    cr = JM.rgba(cols['crystal'], ex['crystal'])                         # cristal : palette propre (cyans lumineux)
    q = Image.fromarray(cr[..., :3]).quantize(colors=32, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    cr[..., :3] = np.array(q.convert('RGB')); cr[~ex['crystal']] = 0
    layers['cristal'] = cr
    land = np.zeros((H, W), bool)
    for nm in ('sol_glace', 'parois', 'cristal'):
        land |= layers[nm][..., 3] == 255
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
    glow = JM.down_class(a, {'g': glow_full, 'n': ~glow_full}, ['g', 'n'])[0]['g'] & ex['crystal']
    gf = glow_frames(a, glow_full, glow)
    poses = EG.flake_poses()
    ff, emitters = EG.flake_frames(poses, np.random.default_rng(7))
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, wf=wf, sf=sf, gf=gf, ff=ff,
                sparkles=sparkles, emitters=emitters, poses=poses, glow=glow)


def fidelity(layers):
    rip = rgb(R / REF)
    x0, y0, x1, y1 = SOL_REF_CROP
    ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0)                        # sol de l'arène de glace
    ours = layers['sol_glace'][layers['sol_glace'][..., 3] == 255][:, :3].astype(float).mean(0)
    fin = rgb(HERE / REF_FIN)[40:80, 10:110].reshape(-1, 3).mean(0)      # sol de la vignette de la vraie salle
    r1 = lambda v: [round(float(x), 1) for x in v]
    return {'ref_sol_rgb': r1(ref), 'sol_glace_rgb': r1(ours), 'distance': round(float(np.linalg.norm(ref - ours)), 2),
            'vignette_salle_articuno_rgb': r1(fin), 'distance_vignette': round(float(np.linalg.norm(fin - ours)), 2),
            'seuil': FIDELITY_MAX}


def ground_project(stack, blocked, markers, gfx, tools):
    """Ground de fin de FVS1, avec les noms de ce lot."""
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['cristal']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Givre - Frosty Grotto (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (salle d Articuno, textures de l arene de glace de PMD Sky) ; eau glacee, '
                    'scintillements et flocons de l entree Givre, cristal qui luit. Arrivee au sud, arene (boss), cristal au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'cristal'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Givre (Frosty Grotto) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (salle d Articuno, arene de glace de PMD Sky), bassins d eau glacee, cristal qui luit, flocons animes")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_flocons']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/eau_glacee', 'animation/reflets', 'animation/lueur_cristal', 'animation/flocons', 'poses_flocons', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for k, p in D['poses'].items():
        Image.fromarray(p).save(OUT / 'poses_flocons' / f'{PFX}_{k}.png')
    static_order = ['sol_complet', 'sol_glace', 'parois', 'cristal']
    stack_named = [('eau_glacee', D['wf'], WATER_TICKS), ('reflets', D['sf'], WATER_TICKS)] + \
                  [(nm, [layers[nm]], 60) for nm in static_order] + \
                  [('lueur_cristal', D['gf'], GLOW_TICKS), ('flocons', D['ff'], FLAKE_TICKS)]
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
    cy_, cxs = np.nonzero(ex['crystal'])
    cristal = free_near(int(cxs.mean()) - 8, (int(cy_.max()) + 8) // 8 * 8)
    markers = {'entrance': entrance, 'boss': boss, 'cristal': cristal}
    paths = {}
    for k in ('boss', 'cristal'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'eau_glacee': WATER_TICKS, 'reflets': WATER_TICKS, 'lueur_cristal': GLOW_TICKS, 'flocons': FLAKE_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('cristal', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_givre_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Givre (Frosty Forest -> Frosty Grotto)',
        'entree_correspondante': ['entree_givre_sud_nord_v1'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'passons a la suite',
                    'Choisis !', 'Parfait lance toi !'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Givre apres Ruine',
                        'layout': 'arrivee au sud par le couloir de glace, arene (boss), bassins d eau glacee sur les cotes, cristal de glace au nord (objectif), aucune sortie',
                        'reference': 'vraie fin (salle d Articuno, etage 5 de Frosty Grotto) seulement en vignette 120 px -> palette ; textures de ' + REF},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sur magenta (bassins = magenta), sol complet genere depuis une decoupe du sol de la reference',
        'reference_da': [REF, f'source/{LOT}/{REF_FIN}'], 'reference_fin_source': REF_FIN_URL,
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': [REF, REF_FIN]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [REF + ' decoupe ' + str(list(SOL_REF_CROP))]}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs ; cristal : palette propre de 32 couleurs'},
        'segmentation': {'eau': 'magenta dilate 2 px', 'sol': f'(moyenne 11 px > {FLOOR_L} et ecart-type 11 px < {FLOOR_S}) ou couleur a moins de {FLOOR_DIST} de {FLOOR_RGB.tolist()}, plus grande composante, fermeture 7 px (fissures), trous rebouches',
                         'cristal': f'ellipse relevee sur le brut {CRYSTAL_RAW} (centre, demi-axes), hors sol et eau', 'parois': 'le reste'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'eau_glacee': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'couleurs': {k: list(v) for k, v in EG.PAL.items()},
                       'origine': 'fonction water_phases de l entree Givre (structure riviere Metano), recalculee ; pas de tuiles natives'},
        'reflets': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'placements': D['sparkles'],
                    'origine': 'pixels Metano_Town_River_Sparkles recolores en blanc bleute (sparkle_families de EGN1)'},
        'lueur_cristal': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in GLOW_RAMP],
                          'pixels': int(D['glow'].sum()), 'origine': 'facettes cyan du cristal, rang de luminance + pulsation (methode des braises de ECN1)'},
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
    print(json.dumps({'fidelite': fid, 'markers': markers, 'glow': int(D['glow'].sum()), 'reflets': len(D['sparkles']),
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
