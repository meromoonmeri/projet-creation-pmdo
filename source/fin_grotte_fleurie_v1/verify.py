"""Vérification aveugle des sorties FGF1 (ne réutilise pas le builder).
.venv/bin/python source/fin_grotte_fleurie_v1/verify.py
Contrôles indépendants : formats, couverture, salle fermée, boucles (fleurs/lueur/pétales),
recomposition, Ground/tuiles, accès 16x16, fidélité recalculée, installateur en simulation.
PAS un test du moteur PMDO.
"""
from pathlib import Path
import importlib.util, io, json, tempfile, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_grotte_fleurie_v1'
S = R / '.cache/fin_grotte_fleurie_v1/fin_grotte_fleurie'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
FP, GP, PP = M['flowers']['phases'], M['glow']['phases'], M['petals']['phases']
OK = []


def check(name, cond, detail=''):
    assert cond, (name, detail)
    OK.append(name)


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


# ---------------------------------------------------------------- formats & couverture
stack = []
for p in M['layer_order_bottom_to_top']:
    if 'fXX' in p:
        n = GP if 'lueur' in p else PP
        stack.append([load(O / p.replace('fXX', f'f{t:02d}')) for t in range(n)])
    elif 'fX' in p:
        stack.append([load(O / p.replace('fX', f'f{t}')) for t in range(FP)])
    else:
        stack.append([load(O / p)])
check('nb_calques', len(stack) == 10)
check('grille_4:3_8px', (W, H, W % 8, H % 8) == (768, 576, 0, 0) and W * 3 == H * 4)
for frames in stack:
    for a in frames:
        check('taille_alpha', a.shape[:2] == (H, W) and set(np.unique(a[..., 3])) <= {0, 255})
        v = a[a[..., 3] > 0].astype(int)
        check('sans_magenta', int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()) == 0)
check('sol_continu', (stack[0][0][..., 3] == 255).all())
check('pas_d_eau', M['water'] is None and not (O / 'animation/eau').exists())
check('pas_de_papillons', not (O / 'animation/papillons').exists())

# ---------------------------------------------------------------- salle fermée
walls = stack[8][0][..., 3] > 0
for nm, edge in (('nord', walls[0, :]), ('ouest', walls[:, 0]), ('est', walls[:, -1])):
    check(f'paroi_{nm}', float(edge.mean()) > 0.90, round(float(edge.mean()), 3))
south_path = stack[4][0][-1, :, 3] > 0
check('sud_couloir_unique', bool((walls[-1, :] | south_path).all()))
check('sud_entree_etroite', 0.05 < float(south_path.mean()) < 0.35, round(float(south_path.mean()), 3))

# ---------------------------------------------------------------- recomposition exacte
sc = Image.new('RGBA', (W, H))
for frames in stack:
    sc.alpha_composite(Image.fromarray(frames[0]))
check('scene_t000', (np.array(sc) == load(O / 'review/FGF1_scene_t000.png')).all())
with zipfile.ZipFile(O / 'FGF1_fin_grotte_fleurie_calques.ora') as z:
    merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
    check('ora_compose', (merged == np.array(sc)).all())
    check('ora_membres', len(z.namelist()) == len(stack) + 4)
with Image.open(O / 'review/FGF1_scene_animee.webp') as im:
    check('webp_phases', im.n_frames == M['scene_loop_ticks'] // 5)
check('boucle_scene_240', M['scene_loop_ticks'] == 240)

# ---------------------------------------------------------------- boucles animées
fl = stack[3]
check('fleurs_8_phases', len(fl) == 8)
boxes = []
for a in fl:
    ys, xs = np.nonzero(a[..., 3] > 0)
    check('fleurs_visibles', len(ys) > 100)
    boxes.append((ys.min(), ys.max(), xs.min(), xs.max()))
check('fleurs_cisaillement_borne', max(abs(b[i] - boxes[0][i]) for b in boxes for i in range(4)) <= 2)

altar = stack[6][0][..., 3] > 0
ys, xs = np.nonzero(altar)
check('autel_surface', len(ys) > 1500, len(ys))
check('autel_au_nord_centre', ys.mean() < H * 0.45 and abs(xs.mean() - W / 2) < 60)
near = nd.distance_transform_edt(~altar) <= 14
seen = set()
for a in stack[7]:
    m = a[..., 3] > 0
    check('lueur_binaire', set(np.unique(a[..., 3])) <= {0, 255})
    check('lueur_visible', int(m.sum()) > 50)
    check('lueur_locale', int((m & ~near).sum()) == 0)
    seen.add(a.tobytes())
check('lueur_12_phases', len(stack[7]) == GP == 12)
check('lueur_animee', len(seen) > 6, len(seen))

pet = stack[9]
check('petales_24_phases', len(pet) == PP == 24)
check('petales_boucle_fermee', PP * M['petals']['step'] == M['petals']['span'])
counts = [int((a[..., 3] > 0).sum()) for a in pet]
check('petales_visibles', min(counts) > 180 and max(counts) <= M['petals']['nombre'] * 9, (min(counts), max(counts)))
ymean = [float(np.nonzero(a[..., 3] > 0)[0].mean()) for a in pet]
check('petales_descendent', sum(1 for i in range(PP - 1) if ymean[i + 1] > ymean[i]) > PP * 0.6)
check('petales_dans_la_salle', all(230 <= np.nonzero(a[..., 3] > 0)[0].min() for a in pet))

# ---------------------------------------------------------------- Ground / tuiles / index
doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
o = doc['Object']
check('version_0812', doc['Version'] == '0.8.12.0')
check('calque_top_vide', o['Layers'][-1]['Layer'] == 4 and len(o['Layers']) == len(stack) + 1)
nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
check('banques_manifeste', set(banks) == set(M['pmdo']['banks']))
ticks = [60, 60, 60, M['flowers']['frame_length_ticks'], 60, 60, 60, M['glow']['frame_length_ticks'], 60,
         M['petals']['frame_length_ticks']]
for li, (frames, tk) in enumerate(zip(stack, ticks)):
    for t in sorted({0, len(frames) // 2, len(frames) - 1}):
        out = np.zeros((H, W, 4), 'uint8')
        for x, col in enumerate(o['Layers'][li]['Tiles']):
            for y, cell in enumerate(col):
                for track in cell['Layers']:
                    if len(track['Frames']) > 1:
                        check('cadence', (len(track['Frames']), track['FrameLength']) == (len(frames), tk))
                    f = track['Frames'][t % len(track['Frames'])]
                    out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
        check(f'roundtrip_calque_{li}_t{t}', (out == frames[t]).all())
check('obstacles_manifeste', sum(w['Tags'] for c in o['obstacles'] for w in c) == M['access']['blocked_cells'])
check('marqueurs', {m['EntName'] for m in o['Entities'][0]['Markers']} == {'entrance', 'boss', 'objectif'})
tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
check('index_coherent', set(tools.read_index(S / 'Content/Tile/index.idx')) == set(M['pmdo']['banks']))
lua = (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text()
lua_code = '\n'.join(l for l in lua.splitlines() if not l.strip().startswith('--'))
check('aucun_warp', 'warp' not in lua_code.lower())
check('aucune_sortie', M['pmdo']['warp'] == 'aucun')

# ---------------------------------------------------------------- accès 16x16
blocked = np.array([[w['Tags'] for w in col] for col in o['obstacles']]).T > 0
v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
e, obj, boss = M['access']['entry_px'], M['access']['objectif_px'], M['access']['boss_px']
ok, explored = v1.reachable(blocked, (e[1] // 8, e[0] // 8), (obj[1] // 8, obj[0] // 8))
check('chemin_16x16_autel', ok and explored == M['access']['cells_explored'])
okb, _ = v1.reachable(blocked, (e[1] // 8, e[0] // 8), (boss[1] // 8, boss[0] // 8))
check('chemin_16x16_arene', okb and okb == M['access']['arene_accessible'])
for nm, p in (('entree', e), ('arene', boss), ('objectif', obj)):
    check(f'marqueur_{nm}_libre', not blocked[p[1] // 8:p[1] // 8 + 2, p[0] // 8:p[0] // 8 + 2].any())
check('arene_32x32_libre', not blocked[boss[1] // 8:boss[1] // 8 + 4, boss[0] // 8:boss[0] // 8 + 4].any())

# ---------------------------------------------------------------- fidélité recalculée (classifieur indépendant)
ref = np.array(Image.open(R / 'source/entree_grotte_fleurie_sud_nord_v1/reference/capture_pmdo_source.png').convert('RGB')).astype(int)
dec = np.array(Image.open(O / 'review/FGF1_decor_etalo.png').convert('RGB')).astype(int)
valid = np.ones(ref.shape[:2], bool); valid[215:255, 295:345] = False; valid[180:240, 390:455] = False


def rules(a, exclude_mag=False):
    """Classifieur exclusif par priorité (identique au builder), magenta exclu côté décor."""
    r, g, b = a.transpose(2, 0, 1)
    raw = {'flower_r': (r > 175) & (g < 150) & (b < 110) & (r > g + 70),
           'flower_y': (r > 190) & (g > 165) & (b < 100) & (r > g - 25) & (r < g + 55) & (g > b + 70),
           'flower_b': (b > r + 20) & (b > 120) & (g > 120) & (r < 170),
           'bush': (g > r + 20) & (g > b + 20) & (g < 185) & (r < 110),
           'path': (r > 200) & (b > 130) & (r > g + 20),
           'rock': (r > 140) & (b < 140) & (r > g + 15) & (g > b + 15),
           'grass': (g > r + 10) & (g > b + 10) & (g > 150)}
    taken = np.zeros(a.shape[:2], bool)
    if exclude_mag:
        taken |= (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    out = {}
    for k, m in raw.items():
        out[k] = m & ~taken
        taken |= out[k]
    return out


rr, dr = rules(ref), rules(dec, exclude_mag=True)
for k in rr:
    mr = ref[rr[k] & valid].mean(0); md = dec[dr[k]].mean(0)
    d = float(np.linalg.norm(mr - md))
    check(f'fidelite_{k}', d < M['fidelity']['seuil'], round(d, 1))
    check(f'fidelite_manifeste_{k}', abs(d - M['fidelity']['mesures'][k]['distance']) < 1.0)

# ---------------------------------------------------------------- installateur en simulation
with tempfile.TemporaryDirectory() as td:
    tmp = Path(td) / 'mod_test'
    tmp.mkdir()
    (tmp / 'Mod.xml').write_text(f'<Header><Namespace>{M["pmdo"]["namespace"]}</Namespace></Header>')
    tools.install(S, tmp, dry_run=True)
    check('installateur_dry_run', not (tmp / 'Content').exists())

print(f'PASS.verify : {len(OK)} contrôles indépendants OK — aucune validation moteur PMDO.')
