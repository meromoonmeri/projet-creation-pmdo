"""Tests dédiés — Fin Mystifying Forest : clairière de la source V1 (FMF3, 4:3 vaste).
.venv/bin/python -m unittest source.fin_mystifying_forest_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_mystifying_forest_v1'
S = R / '.cache/fin_mystifying_forest_v1/fin_mystifying_forest'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'chemin', 'herbes_hautes', 'rochers', 'arbres', 'stele')


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
BY = {re.sub(r'^FMF3_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FMF3_masque_{k}.png')) > 0 for k in ('water', 'stele', 'chemin', 'herbe')}
B = loadmod('fmf3_build', HERE / 'build.py')
EMF1 = loadmod('emf1_build', R / 'source/entree_mystifying_forest_sud_nord_v1/build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] == 255][:, :3], axis=0)}


def step_changes(frames):
    n = len(frames)
    return [int((frames[t] != frames[(t + 1) % n]).any(-1).sum()) for t in range(n)]


class Build(unittest.TestCase):
    def test_raw_hashes_reference_and_coherence_with_entry(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], 'Mystifying_Forest_entrance_TDS.png')
        self.assertEqual(hashlib.sha256((R / ref['file']).read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'feuilles_lucioles_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn('Mystifying_Forest_entrance_TDS.png', g[0]['images'])
        self.assertIn('Mystifying_Forest_entrance_TDS.png', g[2]['images'])
        self.assertEqual(B.LEAF_FALL, EMF1.LEAF_FALL); self.assertEqual(B.FLY_PULSE, EMF1.FLY_PULSE)
        self.assertEqual(
            (HERE / 'bruts/feuilles_lucioles_poses.png').read_bytes(),
            (R / 'source/entree_mystifying_forest_sud_nord_v1/bruts/feuilles_lucioles_poses.png').read_bytes()
        )
        self.assertIn('a confirmer', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FMF3_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for frames in STACK:
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['eau', 'scintillements', 'sol_complet', *STATIC, 'feuilles', 'lucioles'])
        cover = np.zeros((H, W), bool)
        for frames in STACK:
            cover |= alpha(frames[0])
        self.assertTrue(cover.all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertEqual(int(np.sum(fixed, 0).max()), 1)
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 200, k)

    def test_palettes_separees(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors(BY['arbres'])), 40)
        self.assertLessEqual(len(colors([BY['rochers'][0], BY['stele'][0]])), 24)
        ch = BY['chemin'][0]; px = ch[alpha(ch)][:, :3].astype(float).mean(0)
        self.assertGreater(px[0], px[2] + 12)
        sol = BY['sol_complet'][0]; ls = sol[alpha(sol)][:, :3] @ [.299, .587, .114]
        self.assertGreater(float(np.percentile(ls, 1)), 45)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(R / 'Mystifying_Forest_entrance_TDS.png')
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 20, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for k, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[v['calque']][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[k][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb'])))
            self.assertLess(d, 20, (k, d))

    def test_water_metano_sans_lisere(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        native = set()
        for i in range(1, 5):
            t = v2.decode_tile(R / f'source/eau_metano/natifs/Metano_Town_River_Animation_{i}.tile')
            native |= {tuple(int(v) for v in px[:3]) for a in t.values() for px in a.reshape(-1, 4) if px[3] == 255}
        fr = BY['eau']; mask = alpha(fr[0])
        self.assertEqual((len(fr), M['water']['frame_length_ticks']), (4, 10))
        self.assertGreater(int(mask.sum()), 3000)
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        self.assertTrue(colors(fr) <= native, colors(fr) - native)
        self.assertNotIn((148, 230, 238), colors(fr))
        land = np.zeros((H, W), bool)
        for k in STATIC:
            land |= alpha(BY[k][0])
        rim = mask & ~land & nd.binary_dilation(land)
        bande = np.array(M['water']['couleurs']['bande'])
        for a in fr:
            self.assertTrue((a[rim][:, :3] == bande).all())
        d = [int((fr[t][mask] != fr[(t + 1) % 4][mask]).any(1).sum()) for t in range(4)]
        self.assertTrue(min(d) > 0 and max(d) < 2 * min(d), d)

    def test_sparkles_native_pixels(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        native = {tuple(int(v) for v in px[:3]) for t in v2.decode_tile(R / M['sparkles']['source']).values()
                  for px in t.reshape(-1, 4) if px[3] == 255}
        for a in BY['scintillements']:
            cols = colors([a]); self.assertTrue(cols <= native); self.assertGreater(len(cols), 0)
            self.assertFalse((alpha(a) & ~MASK['water']).any())

    def test_feuilles_et_lucioles_boucles_fermees(self):
        tree_cols = colors(BY['arbres'])
        for name in ('feuilles', 'lucioles'):
            fr = BY[name]
            self.assertEqual((len(fr), M[name]['frame_length_ticks']), (48, 5))
            d = step_changes(fr)
            self.assertTrue(min(d) > 10 and max(d) < 3 * min(d), (name, min(d), max(d)))
            self.assertFalse((alpha(fr[0]) & MASK['water']).any())
        self.assertTrue(colors(BY['feuilles']) <= tree_cols)
        self.assertLessEqual(len(colors(BY['lucioles'])), 8)
        leaves = [load(O / f'poses/FMF3_feuille_{i}.png') for i in range(6)]
        flies = [load(O / f'poses/FMF3_luciole_{i}.png') for i in range(6)]
        for i, p in enumerate(leaves):
            self.assertGreater(int(alpha(p).sum()), 8, i); self.assertTrue(colors([p]) <= tree_cols)
        for i, p in enumerate(flies):
            self.assertGreater(int(alpha(p).sum()), 3, i)
        f48 = B.leaf_frames(leaves, [tuple(s) for s in M['feuilles']['departs']], np.ones((H, W), bool), ts=[48])[0]
        self.assertTrue(np.array_equal(f48, BY['feuilles'][0]))
        m48 = B.firefly_frames(flies, [tuple(s) for s in M['lucioles']['points']], ts=[48])[0]
        self.assertTrue(np.array_equal(m48, BY['lucioles'][0]))

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FMF3_fin_mystifying_forest_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = load(O / 'review/FMF3_scene_t000.png')
        self.assertTrue(np.array_equal(merged, sc))

    def test_access_fin_sans_sortie(self):
        v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        self.assertNotIn('threshold_px', a)
        walk_px = alpha(BY['herbe'][0]) | alpha(BY['chemin'][0])
        blocked = B.cell_grid(~walk_px)
        blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
        prat = np.array(Image.open(O / 'masques/FMF3_masque_praticable.png')) > 0
        self.assertTrue(np.array_equal(~blocked, prat))
        self.assertEqual(int(blocked.sum()), a['blocked_cells'])
        self.assertGreater(a['walkable_cells'], 1200)
        self.assertTrue(blocked[0, :].all() and blocked[:, 0].all() and blocked[:, -1].all())
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objectif_px']
        self.assertGreaterEqual(ey, H - 32)
        self.assertLess(oy, by); self.assertLess(by, ey - 100)
        for qx, qy in ((ex, ey), (bx, by), (ox, oy)):
            self.assertFalse(blocked[qy // 8:qy // 8 + 2, qx // 8:qx // 8 + 2].any(), (qx, qy))
            self.assertFalse(MASK['water'][qy:qy + 16, qx:qx + 16].any(), (qx, qy))
            self.assertFalse(MASK['stele'][qy:qy + 16, qx:qx + 16].any(), (qx, qy))
        ok_eb, _ = v1.reachable(blocked, (ey // 8, ex // 8), (by // 8, bx // 8))
        ok_bo, _ = v1.reachable(blocked, (by // 8, bx // 8), (oy // 8, ox // 8))
        self.assertTrue(ok_eb and ok_bo)

    def test_ground_roundtrip(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        tools = loadmod('inst', R / 'source/pmdo_cote/INSTALLER.py')
        g = json.loads((S / 'Data/Ground/fmf3_fin_mystifying_forest.rsground').read_text())['Object']
        self.assertEqual(g['TexSize'], 1); self.assertEqual(len(g['Layers']), len(STACK) + 1)
        self.assertEqual(g['Layers'][-1]['Layer'], 4)
        obs = np.array([[c['Tags'] for c in col] for col in g['obstacles']]).T
        self.assertEqual(int((obs != 0).sum()), M['access']['blocked_cells'])
        marks = {m['EntName']: (m['Collider']['X'], m['Collider']['Y']) for m in g['Entities'][0]['Markers']}
        self.assertEqual(marks, {'entrance': tuple(M['access']['entry_px']),
                                 'boss': tuple(M['access']['boss_px']),
                                 'objectif': tuple(M['access']['objectif_px'])})
        idx = tools.read_index(S / 'Content/Tile/index.idx')
        self.assertEqual(sorted(idx), M['pmdo']['banks'])
        banks = {k: v2.decode_tile(S / f'Content/Tile/{k}.tile') for k in idx}
        for L, frames in zip(g['Layers'][:-1], STACK):
            for t, exp in enumerate(frames):
                canvas = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(L['Tiles']):
                    for y, cell in enumerate(col):
                        if cell['Layers']:
                            fr = cell['Layers'][0]['Frames']
                            loc = fr[t % len(fr)]['TexLoc']
                            canvas[y*8:y*8+8, x*8:x*8+8] = banks[fr[0]['Sheet']][(loc['X'], loc['Y'])]
                self.assertTrue(np.array_equal(canvas, exp), L['Name'])

    def test_prefix_and_namespace_unique(self):
        other = [p for p in (R / 'renders').glob('*/manifest.json') if p.parent != O]
        for p in other:
            d = json.loads(p.read_text())
            if not isinstance(d, dict):
                continue
            self.assertNotEqual(d.get('prefix'), 'FMF3', p)
            self.assertNotEqual(d.get('pmdo', {}).get('namespace'), 'fin_mystifying_forest', p)


if __name__ == '__main__':
    unittest.main()
