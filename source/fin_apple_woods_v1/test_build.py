"""Tests dédiés — Fin Apple Woods / Bois aux Pommes V1 (FAW1, 4:3 vaste).
.venv/bin/python -m unittest source.fin_apple_woods_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_apple_woods_v1'
S = R / '.cache/fin_apple_woods_v1/fin_apple_woods'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'herbe_claire', 'chemin', 'fleurs', 'rochers', 'arbres', 'pommiers', 'autel_pommier')
REF = R / 'Apple_Woods_entrance_TDS.png'


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
BY = {re.sub(r'^FAW1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FAW1_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('faw1_build', HERE / 'build.py')


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
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'temoin_sans_objets.png', 'pommes_feuilles_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images'])
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor.png'))
        self.assertIn(REF.name, g[2]['images'])
        self.assertIn('pure magenta #FF00FF', g[2]['prompt'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_recalage_temoin(self):
        a, tm = B.rgb(HERE / 'bruts/decor.png'), B.rgb(HERE / 'bruts/temoin_sans_objets.png')
        m, _ = B.classify(a, tm)
        rs = B.recalage(a, tm, nd.binary_erosion(m['chemin'] | m['herbe'], iterations=6))
        self.assertEqual(rs, {k: M['recalage']['temoin_sans_objets'][k] for k in rs})
        self.assertLess(rs['ecart_moyen'], 8)
        self.assertGreater(len(colors(BY['sol_complet'])), 16)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FAW1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 140) & (v[:, 2] - v[:, 1] > 140)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'chute_pommes', 'feuilles_eclats'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(float)
        self.assertGreater(lum(L('chemin')).mean(), lum(L('herbe_claire')).mean() + 20)
        self.assertGreater(lum(L('herbe_claire')).mean(), lum(L('herbe')).mean() + 30)
        self.assertGreaterEqual(M['segmentation_mesures']['nb_rochers'], 6)
        self.assertGreaterEqual(M['segmentation_mesures']['nb_fleurs'], 10)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)

    def test_animations_boucles_fermees(self):
        ps = {k: load(O / f'poses/FAW1_{k}.png') for k in B.POSE_BOXES}
        for k, p in ps.items():
            self.assertGreater(int(alpha(p).sum()), 3, k)
            v = p[alpha(p)].astype(int)
            bad = (v[:, 0] - v[:, 1] > 140) & (v[:, 2] - v[:, 1] > 140)
            self.assertEqual(int(bad.sum()), 0, k)
        pal = {tuple(int(v) for v in c) for c in M['chute_pommes']['palette']}
        self.assertLessEqual(len(pal), 16)
        for nm in ('chute_pommes', 'feuilles_eclats'):
            fr = BY[nm]
            self.assertEqual(len(fr), 24)
            self.assertTrue(colors(fr) <= pal, nm)
            for t, a in enumerate(fr):
                self.assertGreater(int(alpha(a).sum()), 15, (nm, t))
        calc_p = B.chute_pommes_frames(ps)
        calc_f = B.feuilles_eclats_frames(ps)
        for t in range(24):
            self.assertTrue((BY['chute_pommes'][t] == calc_p[t]).all(), t)
            self.assertTrue((BY['feuilles_eclats'][t] == calc_f[t]).all(), t)
        self.assertTrue((B.chute_pommes_frames(ps, ts=[24])[0] == BY['chute_pommes'][0]).all())
        self.assertTrue((B.feuilles_eclats_frames(ps, ts=[24])[0] == BY['feuilles_eclats'][0]).all())

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FAW1_fin_apple_woods_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'autel_pommier', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FAW1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access_and_closed_borders(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objectif_px']
        self.assertGreater(ey, H - 64); self.assertLess(oy, by)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        mks = {m['EntName']: m['Collider'] for m in doc['Object']['Entities'][0]['Markers']}
        self.assertEqual(set(mks), {'entrance', 'boss', 'objectif'})
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for px, py in ((ex, ey), (bx, by), (ox, oy)):
            self.assertFalse(blocked[py // 8:py // 8 + 2, px // 8:px // 8 + 2].any(), (px, py))
        self.assertTrue(blocked[0, :].all())
        self.assertTrue(blocked[:, 0].all())
        self.assertTrue(blocked[:, -1].all())
        for k in ('rochers', 'arbres', 'pommiers', 'autel_pommier'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FAW1'", s, p); self.assertNotIn("'fin_apple_woods'", s, p)

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


if __name__ == '__main__':
    unittest.main()
