"""Tests dédiés — Fin Clairière tropicale V1 (FCT1, 4:3 vaste).
.venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_clairiere_tropicale_v1'
S = R / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers')
REF = R / 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'


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
BY = {re.sub(r'^FCT1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FCT1_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('fct1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def walk():
    return MASK['praticable']


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png', 'temoin_sans_objets.png', 'papillons_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images'])
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor.png'))
        self.assertTrue(g[2]['images'][0].endswith('bruts/decor.png'))
        self.assertIn('No sea', g[0]['prompt'] + g[0]['prompt'])
        self.assertIn('no cave', g[0]['prompt'].lower())
        poses_etc = R / 'source/entree_clairiere_tropicale_sud_nord_v1/bruts/papillons_poses.png'
        self.assertEqual(hashlib.sha256((HERE / 'bruts/papillons_poses.png').read_bytes()).hexdigest(),
                         hashlib.sha256(poses_etc.read_bytes()).hexdigest())
        self.assertIn('choisis par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertNotIn('profondeur', BY); self.assertNotIn('mer', BY); self.assertNotIn('ponton', BY)

    def test_recalages(self):
        a, f, t = (B.rgb(HERE / f'bruts/{n}.png') for n in ('decor', 'sol_complet', 'temoin_sans_objets'))
        m, _ = B.classify(a, t)
        rs = B.recalage(a, f, nd.binary_erosion(m['herbe'], iterations=6))
        self.assertEqual(rs, {k: M['recalage']['sol_complet'][k] for k in rs})
        self.assertLess(rs['ecart_moyen'], 8)
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[1], sol.mean(0)[2] + 90)
        self.assertGreater(len(colors(BY['sol_complet'])), 12)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FCT1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                if name == 'fleurs':
                    self.assertLess(int(bad.sum()), 60, name)
                else:
                    self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'papillons'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 200, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['herbe']['calques']])), 96)
        self.assertLessEqual(len(colors([BY['jungle'][0], BY['palmiers'][0]])), 96)
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertLess(L('ombres').mean(), L('herbe').mean() - 8)
        self.assertGreater(int(MASK['palmiers'].sum()), 1000)
        self.assertGreater(int(MASK['fleurs'].sum()), 200)
        lab, n = nd.label(MASK['dalles']); self.assertGreaterEqual(n, 8)

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

    def test_papillons_boucle_fermee(self):
        P = M['papillons']; fr = BY['papillons']
        poses = {k: load(O / f'poses/FCT1_{k}.png') for k in P['poses']}
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 5))
        calc = B.butterfly_frames(poses, [tuple(fl) for fl in P['vols']])
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 10, t)
        self.assertTrue((B.butterfly_frames(poses, [tuple(fl) for fl in P['vols']], ts=[24])[0] == fr[0]).all())
        d = [int((fr[t] != fr[(t + 1) % 24]).any(-1).sum()) for t in range(24)]
        self.assertTrue(min(d) > 0, d)

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FCT1_fin_clairiere_tropicale_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Clairiere', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FCT1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'] and a['path_to_boss'] and a['path_to_objective'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objective_px']
        self.assertGreater(ey, H - 64); self.assertLess(oy, by - 40)
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(walk()[by:by + 16, bx:bx + 16].mean() > 0.9)
        dn = nd.distance_transform_edt(walk())
        self.assertGreater(float(dn[by + 8, bx + 8]), 30)
        self.assertLess(abs(ox + 8 - W // 2), 90)
        self.assertGreater(by, H // 4); self.assertLess(by, 3 * H // 4)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('jungle', 'palmiers'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['boss_px'], a['objective_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:3].mean() > 0.8)
        self.assertTrue(blocked[:, :3].mean() > 0.7 and blocked[:, -3:].mean() > 0.7)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FCT1'", s, p)
                self.assertNotIn("'fin_clairiere_tropicale'", s, p)

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
