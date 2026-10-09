"""Tests dédiés — Bureau Pelipper V1 (PPO1, 4:3 vaste).
.venv/bin/python -m unittest source.bureau_pelipper_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/bureau_pelipper_v1'
S = R / '.cache/bureau_pelipper_v1/bureau_pelipper'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name for L in M['layers']]
STATIC = ('herbe', 'chemin', 'bois', 'murs', 'fond')
REF = HERE / 'bruts/planche_salle.png'


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


STACK = [load(O / L['file']) for L in M['layers']]
BY = {re.sub(r'^PPO1_\d\d_', '', Path(n).stem): [a] for n, a in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/PPO1_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('ppo1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], B.REF_NAME)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        self.assertIn('5416', ref['source'])
        g = {x['file']: x for x in M['generation']}
        self.assertEqual(g['decor.png']['images'], [B.REF_NAME])
        self.assertEqual(g['temoin_sans_objets.png']['images'], [f'{B.LOT}/bruts/decor.png'])
        self.assertEqual(g['sol_complet.png']['images'], [f'{B.LOT}/bruts/decor.png'])
        self.assertTrue(all(len(x['prompt']) > 100 for x in g.values()))
        self.assertIn('No Pelipper', g['decor.png']['prompt'])
        self.assertIn('SOUTH', g['decor.png']['prompt'])
        self.assertIn('spacious', g['decor.png']['prompt'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertEqual(M['prefix'], 'PPO1')
        rg = M['recalage']['temoin']
        self.assertLess(rg['ecart_moyen'], rg['ecart_decale_1px'])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('PPO1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                if name == 'fond':
                    self.assertGreater(int(((v[:, 0] > 200) & (v[:, 1] < 80) & (v[:, 2] > 180)).sum()), 100)
                    continue
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 200, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        sol = BY['sol_complet'][0][..., :3].astype(float).reshape(-1, 3)
        self.assertGreater(len(colors(BY['sol_complet'])), 8)
        m = sol.mean(0); self.assertGreater(m[1], m[0] + 30); self.assertGreater(m[1], m[2] + 80)

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        h = L('herbe').mean(0); self.assertGreater(h[1], h[0] + 15); self.assertGreater(h[1], h[2] + 40)
        c = L('chemin').mean(0); self.assertGreater(c[0], c[2] + 40)
        b = L('bois').mean(0); self.assertGreater(b[0], b[2] + 80); self.assertGreater(b[1], b[2] + 80)
        f = L('fond').mean(0); self.assertGreater(f[0], 200); self.assertLess(f[1], 80); self.assertGreater(f[2], 180)
        self.assertTrue(MASK['praticable'][-8:].any())
        self.assertFalse(MASK['praticable'][:40].any())
        ts = np.array(Image.open(HERE / 'bruts/PPO1_mobilier_tilesheet.png').convert('RGB'))
        mag = (ts[:, :, 0] > 240) & (ts[:, :, 1] < 20) & (ts[:, :, 2] > 240)
        self.assertGreater(int(mag.sum()), 1000)
        self.assertGreater(int((~mag).sum()), 2000)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        self.assertTrue({'herbe', 'chemin'} <= set(fid))
        for k, v in fid.items():
            if k == 'fond':
                continue
            lim = 70 if k == 'bois' else 35
            self.assertLess(v['distance'], lim, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            lim = 70 if nm in ('chemin', 'bois') else 35
            self.assertLess(d, lim, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        herbe = np.array(fid['herbe']['decor_rgb'])
        f = B.rgb(HERE / 'bruts/sol_complet.png').reshape(-1, 3).mean(0)
        d = float(np.linalg.norm(f - herbe)); self.assertLess(d, 35)
        self.assertAlmostEqual(d, M['fidelite_rip']['sol_complet'], places=1)

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'PPO1_bureau_pelipper_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Bureau Pelipper', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for a in STACK:
            sc.alpha_composite(Image.fromarray(a))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/PPO1_scene_t000.png')).all())
        self.assertEqual(M['scene_loop_ticks'], 60)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; cx, cy = a['counter_px']
        self.assertGreater(ey, H - 64); self.assertLess(cy, ey - 80)
        self.assertTrue(MASK['praticable'][ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(MASK['praticable'][cy:cy + 16, cx:cx + 16].mean() > 0.5)
        self.assertLess(abs(ex + 8 - W // 2), 40)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('murs', 'fond', 'bois'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['counter_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:3].mean() > 0.8)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'PPO1'", s, p)
                self.assertNotIn("'bureau_pelipper'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, (a, L) in enumerate(zip(STACK, M['layers'])):
            out = np.zeros((H, W, 4), 'uint8')
            for x, col in enumerate(o['Layers'][li]['Tiles']):
                for y, cell in enumerate(col):
                    for track in cell['Layers']:
                        f = track['Frames'][0]
                        out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
            self.assertTrue((out == a).all(), li)
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'comptoir'})
        self.assertEqual(len(o['Entities'][0]['Markers']), 2)
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
