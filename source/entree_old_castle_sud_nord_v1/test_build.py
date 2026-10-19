"""Tests dédiés — Entrée Old Castle / Chambre Dorée sud -> nord V1 (EOC2, 4:3 vaste).
.venv/bin/python -m unittest source.entree_old_castle_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_old_castle_sud_nord_v1'
S = R / '.cache/entree_old_castle_sud_nord_v1/entree_old_castle_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('dalles_claires', 'dalles', 'rosace', 'dalles_sombres', 'murs_bordure', 'colonnes_balustrades', 'arche_seuil', 'coffres')
REF = R / 'oldcastlepmd.png'


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
BY = {re.sub(r'^EOC2_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/EOC2_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('eoc2_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


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
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images'])
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor.png'))
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_recalage_sol_complet(self):
        a, f = B.rgb(HERE / 'bruts/decor.png'), B.rgb(HERE / 'bruts/sol_complet.png')
        m, _ = B.classify(a, f)
        rs = B.recalage(a, f, nd.binary_erosion(m['dalles'] | m['rosace'], iterations=6))
        self.assertEqual(rs, {k: M['recalage']['sol_complet'][k] for k in rs})
        self.assertLess(rs['ecart_moyen'], 8)
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[0], sol.mean(0)[2] + 50)
        self.assertGreater(len(colors(BY['sol_complet'])), 16)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('EOC2_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'lueur_portail', 'eclats_or'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 1000, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(float)
        self.assertGreater(lum(L('dalles_claires')).mean(), lum(L('dalles')).mean() + 30)
        self.assertGreater(lum(L('dalles')).mean(), lum(L('dalles_sombres')).mean() + 25)
        # 20 coffres détectés (10 à gauche, 10 à droite) :
        lab, n = nd.label(MASK['coffres']); self.assertEqual(n, 20)
        # Rosace centrale :
        ys, xs = np.nonzero(MASK['rosace'])
        self.assertAlmostEqual(float(xs.mean()), W / 2, delta=12)
        self.assertAlmostEqual(float(ys.mean()), H / 2, delta=24)

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

    def test_lueur_et_eclats_couleurs_du_rip_et_boucles(self):
        rc = rip_colors()
        for nm in ('lueur_portail', 'eclats_or'):
            fr = BY[nm]
            self.assertEqual(len(fr), 24)
            self.assertTrue(colors(fr) <= rc, nm)
            for t, a in enumerate(fr):
                self.assertGreater(int(alpha(a).sum()), 30, (nm, t))
        # Boucles fermées : phase 24 == phase 0
        lu24 = B.lueur_frames(MASK['arche_seuil'] | MASK['colonnes_balustrades'], ts=[24])[0]
        self.assertTrue((lu24 == BY['lueur_portail'][0]).all())
        spots = [tuple(s) for s in M['eclats_or']['spots']]
        ec24 = B.eclats_frames(spots, ts=[24])[0]
        self.assertTrue((ec24 == BY['eclats_or'][0]).all())

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EOC2_entree_old_castle_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'dalles_claires', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EOC2_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access_and_closed_borders(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 4)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 2000)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        self.assertTrue(blocked[0, :].all())
        self.assertTrue(blocked[:, 0].all())
        self.assertTrue(blocked[:, -1].all())
        for k in ('murs_bordure', 'colonnes_balustrades', 'arche_seuil', 'coffres'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        cells[0, :] = False; cells[:, 0] = False; cells[:, -1] = False
        self.assertFalse(blocked[cells].any())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'EOC2'", s, p); self.assertNotIn("'entree_old_castle_sud_nord'", s, p)

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'donjon_seuil'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
