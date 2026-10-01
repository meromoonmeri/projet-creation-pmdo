"""Fin Cratère (FCF1) — deuxième zone de fin de donjon de la série des entrées, 4:3 (768 x 576, 96 x 72 cases).

Demande : « passons à la suite » après FVS1 (une fin par biome, ordre du mod). Référence = la VRAIE fin du jeu :
Dark_Crater_Pit_TDS.png (fosse de Dark Crater). Layout de fin : arrivée au sud par la pointe du plateau, grande arène
de pierre (marqueur « boss »), emblème de feu sur le rebord nord = objectif (marqueur « embleme »), lave tout autour.
Aucune sortie, aucun warp.

Méthode (rendu généré RÉFÉRENCÉ) :
- décor complet généré avec le rip en images= (lave = magenta) ; le sol seul n'est pas revenu du générateur (deux
  réponses vides) : sol_complet = plage de sol propre du décor (SOL_PATCH) répétée en miroir ;
- segmentation pleine résolution, réduction x(576/896) PAR CLASSE, recadrage centré 768 ;
- animations, chacune sur son calque, fonctions de l'entrée Cratère (ECN1) :
  lave « façon rivière Métano » (même palette, 4 x 10 ticks), éclats Métano recolorés (4 x 10),
  bulles de lave (mêmes poses générées, 24 x 5) ; lueur de l'emblème et braises du rebord : rampe de lave pulsée
  6 x 10 ticks, comme les braises de ECN1.
Scène : PPCM 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_cratere_fosse_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_cratere_fosse_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_cratere_fosse'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fcf1_fin_cratere_fosse'
PFX = 'FCF1'
REF = 'Dark_Crater_Pit_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
LAVA_PHASES, LAVA_TICKS = 4, 10
BUBBLE_PHASES, BUBBLE_TICKS = 24, 5
GLOW_PHASES, GLOW_TICKS = 6, 10
LOOP_TICKS = 120
SOL_PATCH = (280, 600, 360, 840)          # plage de sol du décor répétée en miroir (écart-type 11 px <= 12,4)
# Seuils mesurés : sol gris (84, 79, 72) L11 80-87 ; rebord (56, 46, 41) L 45 ; pitons (43, 35, 31) ; emblème (233, 127, 0).
FLOOR_L, FLOOR_SAT = 62, 30
FIDELITY_MAX = 35
PULSE = [0, 1, 2, 2, 1, 0]                # pulsation des braises de ECN1


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
EC = loadmod('ecn1_lave', R / 'source/entree_cratere_sud_nord_v1/build.py')      # lave, éclats, bulles de l'entrée Cratère
EC.W, EC.H = W, H                                                                # ses fonctions lisent W/H à l'appel
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')             # Ground de fin (entrance / boss / objectif)
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- sol complet (miroir d'une plage du décor)
def make_sol(decor):
    y0, y1, x0, x1 = SOL_PATCH; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    lava = nd.binary_dilation(mag, iterations=2)
    sat = a.max(2) - a.min(2)
    L = nd.uniform_filter(lum, 11)
    core = (L > FLOOR_L) & (sat < FLOOR_SAT) & ~nd.binary_dilation(lava, iterations=3)
    core = nd.binary_opening(core, iterations=3)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = nd.binary_closing(lab == int(np.argmax(sizes)) + 1, iterations=4) & ~lava
    holes = nd.binary_fill_holes(floor) & ~floor
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    floor |= np.isin(hl, [i + 1 for i, s in enumerate(hs) if s < 2500])
    # emblème : tons de feu saturés dans le quart nord, fermés et remplis
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    fire = (r > 150) & (b < 90) & (r > g + 30) & ~mag & (yy < a.shape[0] // 4)
    fire = nd.binary_fill_holes(nd.binary_closing(fire, iterations=4))
    fl, fn = nd.label(fire); fs = nd.sum(fire, fl, range(1, fn + 1))
    emblem = fl == int(np.argmax(fs)) + 1
    land = ~lava
    ll, ln = nd.label(land)
    plateau_id = np.bincount(ll[floor]).argmax()
    plateau = ll == plateau_id
    rim = plateau & ~floor & ~emblem
    spires = land & ~plateau
    ember = (r > 170) & (g > 60) & (g < 200) & (b < 90) & (r > b + 100)            # seuil des braises de ECN1
    return dict(lava=lava, floor=floor, rim=rim, emblem=emblem, spires=spires, ember=ember & rim)


def snap_lava(layer):
    """Ramène un calque aux 8 tons de lave de ECN1 (plus proche voisin RGB)."""
    pal = np.array(list(EC.PAL.values()), int); o = layer.copy(); m = o[..., 3] == 255
    d = ((o[m][:, None, :3].astype(int) - pal[None]) ** 2).sum(-1)
    o[m, :3] = pal[d.argmin(1)]; o[~m] = 0
    return o


# ---------------------------------------------------------------- lueur pulsée (braises de ECN1)
def glow_frames(a, glow_full, glow):
    lum_e = JM.down_class(a, {'g': glow_full}, ['g'])[1]['g'].astype(float) @ [.299, .587, .114]
    rank = np.clip(np.digitize(lum_e, np.percentile(lum_e[glow], [33, 66])), 0, 2) if glow.any() else np.zeros((H, W), int)
    ramp = [EC.PAL['accent'], EC.PAL['surface'], EC.PAL['chaud'], EC.PAL['jaune'], EC.PAL['clair']]   # emblème vif : rampe décalée vers le chaud
    out = []
    for t in range(GLOW_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); idx = np.clip(rank + PULSE[t], 0, 4)
        for i, c in enumerate(ramp):
            e[glow & (idx == i)] = (*c, 255)
        out.append(e)
    return out, ramp


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    assert (f == make_sol(a)).all(), 'sol_complet.png doit être le miroir de SOL_PATCH'
    m = classify(a)
    order = ['lava', 'floor', 'rim', 'emblem', 'spires']
    ex, cols = JM.down_class(a, m, order)
    lava = ex['lava']
    names = {'floor': 'sol_plateau', 'rim': 'rebord', 'spires': 'pitons', 'emblem': 'embleme'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~lava)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    emb = layers.pop('embleme')
    layers = BM.quantize_layers(layers)
    layers['embleme'] = snap_lava(emb)            # emblème hors palette commune (le gris écrasait ses rouges)
    land = np.zeros((H, W), bool)
    for nm in names.values():
        land |= layers[nm][..., 3] == 255
    visible = lava & ~land
    lf, dist = EC.lava_phases(lava, visible)
    # bulles de lave de ECN1, puis éclats Métano recolorés de ECN1, sur la lave visible libre
    taken = np.zeros((H, W), bool)
    poses = EC.bubble_poses(); cell = EC.CELL
    emitters = EC.place(visible & (dist > 3), (cell, cell), 10, 11, taken, core=8)
    boffs = [(i * 5) % BUBBLE_PHASES for i in range(len(emitters))]
    bf = [np.zeros((H, W, 4), 'uint8') for _ in range(BUBBLE_PHASES)]
    for (y, x), off in zip(emitters, boffs):
        for t in range(BUBBLE_PHASES):
            k = (t - off) % BUBBLE_PHASES
            if k < len(EC.BUBBLE_TIMELINE):
                p = poses[EC.BUBBLE_TIMELINE[k]]; mm = p[..., 3] > 0
                bf[t][y:y + cell, x:x + cell][mm] = p[mm]
    for fr_ in bf:
        fr_[~visible] = 0
    fams = EC.sparkle_families(); sf = [np.zeros((H, W, 4), 'uint8') for _ in range(LAVA_PHASES)]; sparkles = []
    for fi, (name, frames) in enumerate(fams.items()):
        hh, ww = frames[0].shape[:2]
        for (y, x) in EC.place(visible & (dist > 4), (hh, ww), 8, 31 + fi, taken, core=8):
            sparkles.append({'famille': name, 'xy': [int(x), int(y)]})
            for t in range(LAVA_PHASES):
                mm = frames[t][..., 3] > 0; sf[t][y:y + hh, x:x + ww][mm] = frames[t][mm]
    for fr_ in sf:
        fr_[~visible] = 0
    # lueur : pixels chauds de l'emblème (hors pointes sombres) + braises du rebord
    r, g, b = a.transpose(2, 0, 1)
    hot = m['emblem'] & (r > 150) & (g > 110) & (b < 120)       # jaunes/oranges seulement : les anneaux rouges restent fixes
    glow_full = hot | m['ember']
    glow = JM.down_class(a, {'g': glow_full, 'n': ~glow_full}, ['g', 'n'])[0]['g'] & (ex['emblem'] | ex['rim'])
    gf, ramp = glow_frames(a, glow_full, glow)
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, lf=lf, bf=bf, sf=sf, gf=gf, ramp=ramp,
                emitters=emitters, boffs=boffs, sparkles=sparkles, poses=poses, glow=glow)


def fidelity(layers):
    rip = rgb(R / REF)
    ref = rip[180:360, 180:380].reshape(-1, 3).mean(0)                    # sol du plateau du rip
    ours = layers['sol_plateau'][layers['sol_plateau'][..., 3] == 255][:, :3].astype(float).mean(0)
    return {'rip_sol_rgb': [round(float(v), 1) for v in ref], 'sol_plateau_rgb': [round(float(v), 1) for v in ours],
            'distance': round(float(np.linalg.norm(ref - ours)), 2), 'seuil': FIDELITY_MAX}


def ground_project(stack, blocked, markers, gfx, tools):
    """Ground de fin de FVS1, avec les noms de ce lot."""
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['boss'],
                                                'source': markers['embleme']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Cratere - fosse de Dark Crater (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Dark Crater Pit) ; lave, eclats et bulles de l entree Cratere, '
                    'lueur de l embleme pulsee. Arrivee au sud, arene (boss), embleme au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        if mk['EntName'] == 'source':
            mk['EntName'] = 'embleme'
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text(); x0 = x
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Cratere (fosse de Dark Crater) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon generee au format 4:3 (ref. Dark Crater Pit), plateau sur la lave, embleme de feu qui pulse, lave, eclats et bulles animes")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_bulles']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/lave', 'animation/eclats', 'animation/bulles', 'animation/lueur', 'poses_bulles', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for k, p in D['poses'].items():
        Image.fromarray(p).save(OUT / 'poses_bulles' / f'{PFX}_bulle_{k}.png')
    static_order = ['sol_complet', 'sol_plateau', 'rebord', 'pitons', 'embleme']
    stack_named = [('lave', D['lf'], LAVA_TICKS), ('eclats', D['sf'], LAVA_TICKS), ('bulles', D['bf'], BUBBLE_TICKS)] + \
                  [(nm, [layers[nm]], 60) for nm in static_order] + [('lueur', D['gf'], GLOW_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = layers['sol_plateau'][..., 3] == 255
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
    fy, fx = np.nonzero(walk)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    ey, exx = np.nonzero(ex['emblem'])
    embleme = free_near(int(exx.mean()) - 8, int(ey.max()) + 8)
    markers = {'entrance': entrance, 'boss': boss, 'embleme': embleme}
    paths = {}
    for k in ('boss', 'embleme'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}
    per = {'lave': LAVA_TICKS, 'eclats': LAVA_TICKS, 'bulles': BUBBLE_TICKS, 'lueur': GLOW_TICKS}

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
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('embleme', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_cratere_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Cratere (Dark Crater)',
        'entree_correspondante': ['entree_cratere_sud_nord_v1'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi', 'passons a la suite'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Cratere apres Vapeur',
                        'layout': 'arrivee au sud (pointe du plateau), arene (boss), embleme de feu au nord (objectif), lave autour, aucune sortie',
                        'reference': 'vraie fin du jeu : ' + REF},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sur magenta (lave = magenta), rip en images= ; sol complet en miroir d une plage du decor',
        'reference_da': REF,
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC), 'images': [REF]},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [], 'origine': f'miroir de la plage {list(SOL_PATCH)} (y0, y1, x0, x1) du decor ; generateur vide deux fois'}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs ; embleme ramene aux 8 tons de lave de ECN1'},
        'segmentation': {'lave': 'magenta dilate 2 px', 'sol': f'moyenne 11 px > {FLOOR_L}, saturation < {FLOOR_SAT}, plus grande composante',
                         'embleme': 'tons de feu satures (r > 150, b < 90, r > g + 30) dans le quart nord, plus grande composante remplie',
                         'rebord': 'reste de la composante de terre du plateau', 'pitons': 'autres composantes de terre (dans la lave)',
                         'braises': 'seuil des braises de ECN1, sur le rebord'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'lave': {'phases': LAVA_PHASES, 'frame_length_ticks': LAVA_TICKS, 'couleurs': {k: list(v) for k, v in EC.PAL.items()},
                 'origine': 'fonction lava_phases de l entree Cratere (structure riviere Metano), recalculee ; pas de tuiles natives'},
        'eclats': {'phases': LAVA_PHASES, 'frame_length_ticks': LAVA_TICKS, 'placements': D['sparkles'],
                   'origine': 'pixels Metano_Town_River_Sparkles recolores en tons de lave (sparkle_families de ECN1)'},
        'bulles': {'poses': 'planche generee de l entree Cratere (bruts/bulles_lave_poses.png)', 'phases': BUBBLE_PHASES,
                   'frame_length_ticks': BUBBLE_TICKS, 'emetteurs': [{'xy': [int(x), int(y)], 'decalage': o} for (y, x), o in zip(D['emitters'], D['boffs'])]},
        'lueur': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'pulsation': PULSE, 'rampe': [list(c) for c in D['ramp']],
                  'pixels': int(D['glow'].sum()), 'origine': 'pixels chauds de l embleme et braises du rebord, rang de luminance + pulsation (methode des braises de ECN1)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol du plateau'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'glow': int(D['glow'].sum()), 'bulles': len(D['emitters']),
                      'eclats': len(D['sparkles']), 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
