"""Tests dédiés — Fin Grotte aux vasques V1 (FGV1, 4:3 vaste).
.venv/bin/python -m unittest source.fin_grotte_vasques_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_grotte_vasques_v1'
S = R / '.cache/fin_grotte_vasques_v1/fin_grotte_vasques'
EGV = R / 'source/entree_grotte_vasques_sud_nord_v1'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sol', 'ombres', 'vasques', 'parois', 'fond')
REF = EGV / 'references/D56P41A.png'
PA = json.loads((EGV / 'references/palette_anim.json').read_text())['maps']['D56P41A']


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def expand(L):
    if L['phases'] == 1:
        return [load(O / L['file'])]
    return [load(O / L['file'].replace('fNN', f'f{t:02d}')) for t in range(L['phases'])]


STACK = [expand(L) for L in M['layers']]
BY = {re.sub(r'^FGV1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FGV1_masque_{k}.png')) > 0
        for k in ('sol', 'ombres', 'vasques', 'eau', 'rebords', 'parois', 'fond', 'reflets')}
B = loadmod('fgv1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames, mask=None):
    out = set()
    for a in frames:
        m = a[..., 3] > 0 if mask is None else (a[..., 3] > 0) & mask
        out |= {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}
    return out


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    out = {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}
    for s in PA['emplacements']:
        out |= {tuple(c) for c in s['couleurs_par_frame']}
    return out


def walk():
    return alpha(BY['sol'][0]) | alpha(BY['ombres'][0])


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        egv = json.loads((R / 'renders/entree_grotte_vasques_sud_nord_v1/manifest.json').read_text())
        planche = [r for r in egv['raw_inputs'] if r['file'].endswith('source_poses.png')][0]
        self.assertEqual(M['raw_inputs'][2]['sha256'], planche['sha256'])   # planche EGV1 réutilisée telle quelle
        ref = M['reference_da']
        self.assertEqual(ref['code_rom'], 'D56P41A')
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png', 'source_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 and x['essais'] for x in g))
        self.assertIn('references/D56P41A.png', g[0]['images'][0])
        self.assertTrue(g[1]['images'][0].endswith('fin_grotte_vasques_v1/bruts/decor.png'))
        self.assertIn('REUTILISEE', g[2]['prompt'])
        self.assertIn('no objects, no altar', g[0]['prompt'])                # fin : décor seul, aucune structure
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sol_complet_recale(self):
        a, f = B.rgb(HERE / 'bruts/decor.png'), B.rgb(HERE / 'bruts/sol_complet.png')
        rec = B.recalage(a, f)
        self.assertEqual(rec['ecart_moyen_sol'], M['sol_complet']['ecart_moyen_sol'])
        self.assertLess(rec['ecart_moyen_sol'], rec['ecart_decale_1px'])
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertLess(np.linalg.norm(sol.mean(0) - B.SAND), 12)
        self.assertGreater(len(colors(BY['sol_complet'])), 12)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FGV1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)).sum()), 0, name)

    def test_multicalque_partition(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'reflets_vasques', 'bulles_source'])
        self.assertNotIn('profondeur', BY)                                  # pas de bouche dans une fin
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 1000, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        self.assertTrue((MASK['vasques'] == (MASK['eau'] | MASK['rebords'])).all())

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['roche']['calques']])), 96)
        wpal = {tuple(c) for c in M['normalization']['eau']['couleurs_rip']}
        self.assertEqual(len(wpal), 14)
        self.assertTrue(wpal <= rip_colors())
        self.assertTrue(colors([BY['vasques'][0]], MASK['eau']) <= wpal)    # eau : couleurs EXACTES de D56P41A
        self.assertLessEqual(len(colors([BY['vasques'][0]], MASK['rebords'])), 64)
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertLess(L('ombres').mean(), L('sol').mean() - 8)
        self.assertLess(L('fond').mean(), 90)                               # fond sarcelle sombre
        self.assertTrue((np.nonzero(MASK['fond'])[0] < 120).all())          # seulement derrière les stalactites

    def test_marches_praticables_arene_d_un_seul_tenant(self):
        lab, n = nd.label(walk())
        sizes = nd.sum(walk(), lab, range(1, n + 1))
        main = lab == 1 + int(np.argmax(sizes))
        a = M['access']
        for px in (a['entry_px'], a['boss_px'], a['objective_px']):         # les trois marqueurs dans la même zone
            self.assertTrue(main[px[1] + 8, px[0] + 8], px)
        rows = np.nonzero(MASK['ombres'].sum(1) > 120)[0]                   # rangées des marches (traits sombres)
        self.assertTrue(len(rows) >= 6 and rows.min() < a['boss_px'][1] and rows.max() > a['objective_px'][1])

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)

    def test_reflets_animation_de_palette_exacte(self):
        Rf = M['reflets_vasques']; fr = BY['reflets_vasques']
        self.assertEqual((len(fr), Rf['frame_length_ticks']), (12, 8))      # cadence du BPL de D56P41A
        slots = [[tuple(c) for c in s] for s in Rf['emplacements']]
        self.assertEqual(slots, [[tuple(c) for c in s['couleurs_par_frame'][:12]] for s in PA['emplacements']])
        self.assertTrue(colors(fr) <= rip_colors())
        m = alpha(fr[0])
        self.assertEqual(int(m.sum()), Rf['pixels'])
        self.assertFalse((m & ~MASK['eau']).any())
        self.assertTrue((MASK['reflets'] == m).all())
        self.assertTrue((fr[0][m] == BY['vasques'][0][m]).all())            # frame 0 = calque fixe : pas de saut
        slot_map = np.full((H, W), -1, int)
        for k, s in enumerate(slots):
            slot_map[m & (fr[0][..., :3] == s[0]).all(-1)] = k
        self.assertTrue((slot_map[m] >= 0).all())
        self.assertEqual([int((slot_map == k).sum()) for k in range(6)], Rf['pixels_par_emplacement'])
        calc = B.reflet_frames(slot_map, slots)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
        self.assertTrue((B.reflet_frames(slot_map, slots, ts=[12])[0] == fr[0]).all())   # 12 = 0
        keys, seq = [], []
        for a in fr:
            k = a[m].tobytes()
            if k not in keys:
                keys.append(k)
            seq.append(keys.index(k))
        self.assertEqual(seq, PA['sequence_etats_distincts'][:12])

    def test_bulles_source(self):
        P = M['bulles_source']; fr = BY['bulles_source']
        poses = {k: load(O / f'poses/FGV1_{k}.png') for k in P['poses']}
        egv_poses = {k: load(R / f'renders/entree_grotte_vasques_sud_nord_v1/poses/EGV1_{k}.png') for k in P['poses']}
        for k in poses:                                                     # mêmes poses que l'entrée (mêmes masques)
            self.assertTrue((alpha(poses[k]) == alpha(egv_poses[k])).all(), k)
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 4))
        wpal = {tuple(c) for c in M['normalization']['eau']['couleurs_rip']}
        self.assertTrue(colors(fr) <= wpal)
        em = [tuple(e) for e in P['emetteurs']]; self.assertEqual(len(em), 10)
        calc = B.bubble_frames(poses, em, MASK['eau'], MASK['vasques'])
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertFalse((alpha(a) & ~MASK['vasques']).any(), t)
        self.assertTrue((B.bubble_frames(poses, em, MASK['eau'], MASK['vasques'], ts=[24])[0] == fr[0]).all())
        for x, y, _ in em:
            self.assertTrue(MASK['eau'][y, x])
        self.assertGreaterEqual(sum(y < M['access']['objective_px'][1] and abs(x - W // 2) < 140 for x, y, _ in em), 3)
        self.assertTrue(min(steps(fr)) > 0)

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FGV1_fin_grotte_vasques_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Grotte aux vasques', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FGV1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'] and a['path_to_boss'] and a['path_to_objective'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objective_px']
        self.assertGreater(ey, H - 64); self.assertLess(oy, H // 2)
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(walk()[by:by + 16, bx:bx + 16].mean() > 0.9)
        dn = nd.distance_transform_edt(walk())
        self.assertGreater(float(dn[by + 8, bx + 8]), 40)                    # boss au cœur de l'arène
        self.assertLess(abs(ox + 8 - W // 2), 72); self.assertLess(oy, by - 80)
        self.assertTrue(MASK['vasques'][max(0, oy - 24):oy, ox:ox + 16].any())   # objectif au pied de la cascade
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1000)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('vasques', 'parois', 'fond'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['boss_px'], a['objective_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:8].all()); self.assertTrue(blocked[:, :4].all() and blocked[:, -4:].all())
        self.assertTrue((blocked == B.cell_grid(~walk())).all())            # obstacles = calques (marches libres)
        v1 = loadmod('esn1_t', R / 'source/entree_sud_nord_generee_v1/build.py')   # chemins recalculés, pas lus
        start = (ey // 8, ex // 8)
        self.assertTrue(v1.reachable(blocked, start, (by // 8, bx // 8))[0])
        self.assertTrue(v1.reachable(blocked, start, (oy // 8, ox // 8))[0])

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FGV1'", s, p); self.assertNotIn("'fin_grotte_vasques'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, (frames, L) in enumerate(zip(STACK, M['layers'])):
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), L['ticks']))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (li, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        self.assertEqual(len(o['Entities'][0]['Markers']), 3)
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
