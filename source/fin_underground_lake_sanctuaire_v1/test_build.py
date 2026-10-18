"""Tests dédiés — Fin Underground Lake — Sanctuaire Bioluminescent V1 (FUL2, 4:3 vaste).
.venv/bin/python -m unittest source.fin_underground_lake_sanctuaire_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip D15P41A, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_underground_lake_sanctuaire_v1'
S = R / '.cache/fin_underground_lake_sanctuaire_v1/fin_underground_lake_sanctuaire'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sable', 'ombres', 'berge', 'roche', 'piliers')


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
BY = {re.sub(r'^FUL2_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FUL2_masque_{k}.png')) > 0 for k in ('water', *STATIC)}


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] == 255][:, :3], axis=0)}


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(hashlib.sha256((R / ref['file']).read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'gouttes_ronds_poses.png'])
        self.assertEqual(M['associated_entry'], 'EUL1')
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FUL2_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for frames in STACK:
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['eau', 'lueur', 'scintillements', 'gouttes', 'sol_complet', *STATIC])
        cover = np.zeros((H, W), bool)
        for frames in STACK:
            cover |= alpha(frames[0])
        self.assertTrue(cover.all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertEqual(int(np.sum(fixed, 0).max()), 1)
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 400, k)
        s = M['sol_complet']['ecarts_segmentation']
        self.assertLess(s['ecart_parois'], 6)
        self.assertGreater(s['ecart_piliers'], 50)

    def test_palettes_et_ombres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['roche']['calques']])), 64)
        sa = BY['sable'][0][alpha(BY['sable'][0])][:, :3] @ [.299, .587, .114]
        om = BY['ombres'][0][alpha(BY['ombres'][0])][:, :3] @ [.299, .587, .114]
        self.assertGreater(float(sa.mean() - om.mean()), 12)

    def test_fidelite_rip(self):
        B = loadmod('ful2_build', HERE / 'build.py')
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(HERE / 'reference/D15P41A.png')
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 15, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            k = v['matiere']; lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[k][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb'])))
            self.assertLess(d, 15, (nm, d))

    def test_eau_et_lueur_couleurs_exactes_du_rip(self):
        B = loadmod('ful2_build', HERE / 'build.py')
        ref = B.rgb(HERE / 'reference/D15P41A.png')
        rip_cols = {tuple(int(v) for v in c) for c in np.unique(ref.reshape(-1, 3), axis=0)}
        fr = BY['eau']; wmask = alpha(fr[0])
        self.assertEqual((len(fr), M['water']['frame_length_ticks']), (4, 10))
        self.assertGreater(int(wmask.sum()), 80000)
        self.assertEqual(colors(fr), {tuple(v) for v in M['water']['couleurs'].values()})
        self.assertTrue(colors(fr) <= rip_cols)
        self.assertFalse(colors(fr) & {(119, 127, 175), (167, 167, 223)})
        dw = [int((fr[t][wmask] != fr[(t + 1) % 4][wmask]).any(1).sum()) for t in range(4)]
        self.assertTrue(min(dw) > 0 and max(dw) < 2 * min(dw), dw)
        gl = BY['lueur']
        self.assertEqual((len(gl), M['lueur']['frame_length_ticks']), (12, 10))
        self.assertEqual(colors(gl), {tuple(c) for c in M['lueur']['couleurs']})
        self.assertTrue(colors(gl) <= rip_cols)
        land = np.zeros((H, W), bool)
        for k in STATIC:
            land |= alpha(BY[k][0])
        vis = MASK['water'] & ~land
        for a in gl:
            self.assertFalse((alpha(a) & ~vis).any())
        dg = [int((gl[t] != gl[(t + 1) % 12]).any(-1).sum()) for t in range(12)]
        self.assertTrue(min(dg) > 200, dg)
        self.assertTrue((B.glow_frames(vis, M['lueur']['centres'], ts=[12])[0] == gl[0]).all())

    def test_sparkles_native_sur_coeur_lueur(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        native = {tuple(int(v) for v in px[:3]) for t in v2.decode_tile(R / M['sparkles']['source']).values()
                  for px in t.reshape(-1, 4) if px[3] == 255}
        core = tuple(M['lueur']['couleurs'][0])
        common_core = np.ones((H, W), bool)
        for g in BY['lueur']:
            common_core &= alpha(g) & (g[..., :3] == core).all(-1)
        for a in BY['scintillements']:
            cols = colors([a]); self.assertTrue(cols <= native); self.assertGreater(len(cols), 0)
            self.assertFalse((alpha(a) & ~common_core).any())

    def test_gouttes_boucle_fermee(self):
        g = M['gouttes']; B = loadmod('ful2_build', HERE / 'build.py')
        poses = {k: load(O / f'poses/FUL2_{k}.png') for k in g['poses']}
        for k, (cy, cx, s) in g['poses'].items():
            self.assertEqual(poses[k].shape, (s // 8, s // 8, 4), k)
            self.assertGreater(int(alpha(poses[k]).sum()), 4, k)
        fr = BY['gouttes']; self.assertEqual((len(fr), g['frame_length_ticks']), (24, 5))
        self.assertLessEqual(len(colors(fr)), 8)
        land = np.zeros((H, W), bool)
        for k in STATIC:
            land |= alpha(BY[k][0])
        vis = MASK['water'] & ~land
        calc = B.drop_frames(poses, g['emetteurs'], vis)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 30, t)
            self.assertFalse((alpha(a) & ~vis).any(), t)
        self.assertTrue((B.drop_frames(poses, g['emetteurs'], vis, ts=[24])[0] == fr[0]).all())

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FUL2_fin_underground_lake_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Underground Lake', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FUL2_scene_t000.png')).all())
        self.assertEqual(M['scene_loop_ticks'], 120)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 2)
        walk = MASK['sable'] | MASK['ombres']
        self.assertEqual(float(walk[ey:ey + 16, ex:ex + 16].mean()), 1.0)
        self.assertEqual(float(walk[by:by + 16, bx:bx + 16].mean()), 1.0)
        self.assertEqual(float(walk[ty:ty + 16, tx:tx + 16].mean()), 1.0)
        self.assertFalse((walk & MASK['water']).any())
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 800)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FUL2'", s, p); self.assertNotIn("'fin_underground_lake_sanctuaire'", s, p)

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
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
