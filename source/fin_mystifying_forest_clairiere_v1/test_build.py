"""Tests dédiés — Fin Mystifying Forest — Clairière Source Lumineuse V1 (FMF3, 4:3 vaste).
.venv/bin/python -m unittest source.fin_mystifying_forest_clairiere_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité aux rips D31P31A/D31P11A/D31P41A, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_mystifying_forest_clairiere_v1'
S = R / '.cache/fin_mystifying_forest_clairiere_v1/fin_mystifying_forest_clairiere'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'chemin', 'herbes_hautes', 'rochers', 'vasque', 'arbres')


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
MASK = {k: np.array(Image.open(O / f'masques/FMF3_masque_{k}.png')) > 0
        for k in ('water', 'source_lumineuse', 'vasque', 'chemin', 'herbe')}


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
        self.assertEqual(hashlib.sha256((R / ref['entry_file']).read_bytes()).hexdigest(), ref['entry_sha256'])
        self.assertEqual(hashlib.sha256((R / ref['spring_file']).read_bytes()).hexdigest(), ref['spring_sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'feuilles_lucioles_poses.png'])
        self.assertEqual(M['associated_entry'], 'EMF1')
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
        self.assertEqual(ORDER, ['eau', 'scintillements', 'source_lumineuse', 'sol_complet', *STATIC, 'feuilles', 'lucioles'])
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
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 80)
        self.assertLessEqual(len(colors(BY['chemin'])), 16)
        self.assertLessEqual(len(colors(BY['arbres'])), 40)
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['pierre']['calques']])), 24)
        ch = BY['chemin'][0]; px = ch[alpha(ch)][:, :3].astype(float).mean(0)
        self.assertGreater(px[0], px[2] + 10)

    def test_fidelite_rip(self):
        B = loadmod('fmf3_build', HERE / 'build.py')
        dec = B.rgb(HERE / 'bruts/decor_magenta.png')
        ref_c = B.rgb(HERE / 'reference/D31P31A.png')
        ref_e = B.rgb(HERE / 'reference/D31P11A.png')
        fid = B.fidelity(dec, ref_c, ref_e)
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
        self.assertGreater(int(mask.sum()), 6000)
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        self.assertTrue(colors(fr) <= native, colors(fr) - native)
        self.assertNotIn((148, 230, 238), colors(fr))
        d = [int((fr[t][mask] != fr[(t + 1) % 4][mask]).any(1).sum()) for t in range(4)]
        self.assertTrue(min(d) > 0 and max(d) < 2 * min(d), d)

    def test_source_lumineuse_couleurs_exactes_d31p41a(self):
        B = loadmod('fmf3_build', HERE / 'build.py')
        ref41 = B.rgb(HERE / 'reference/D31P41A.png')
        rip_cols = {tuple(int(v) for v in c) for c in np.unique(ref41.reshape(-1, 3), axis=0)}
        fr = BY['source_lumineuse']; mask = alpha(fr[0])
        self.assertEqual((len(fr), M['source_lumineuse']['frame_length_ticks']), (12, 20))
        self.assertGreater(int(mask.sum()), 2000)
        self.assertTrue(colors(fr) <= rip_cols, colors(fr) - rip_cols)
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        d = [int((fr[t][mask] != fr[(t + 1) % 12][mask]).any(1).sum()) for t in range(12)]
        self.assertGreater(min(d), 50, d)
        calc, _ = B.spring_frames(MASK['source_lumineuse'], mask, ts=[12])
        self.assertTrue((calc[0] == fr[0]).all())

    def test_sparkles_native_pixels(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        native = {tuple(int(v) for v in px[:3]) for t in v2.decode_tile(R / M['sparkles']['source']).values()
                  for px in t.reshape(-1, 4) if px[3] == 255}
        for a in BY['scintillements']:
            cols = colors([a]); self.assertTrue(cols <= native); self.assertGreater(len(cols), 0)
            self.assertFalse((alpha(a) & ~MASK['water']).any())

    def test_feuilles_boucle_fermee(self):
        f = M['feuilles']; B = loadmod('fmf3_build', HERE / 'build.py')
        poses = [load(O / f'poses/FMF3_feuille_{i}.png') for i in range(6)]
        self.assertTrue(all(p.shape == (10, 10, 4) for p in poses))
        fr = BY['feuilles']; self.assertEqual((len(fr), f['frame_length_ticks']), (48, 5))
        self.assertTrue(colors(fr) <= colors(BY['arbres']))
        full = np.ones((H, W), bool)
        calc = B.leaf_frames(poses, f['departs'], full)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 60)
        self.assertTrue((B.leaf_frames(poses, f['departs'], full, ts=[48])[0] == fr[0]).all())

    def test_lucioles_boucle_fermee(self):
        f = M['lucioles']; B = loadmod('fmf3_build', HERE / 'build.py')
        poses = [load(O / f'poses/FMF3_luciole_{i}.png') for i in range(6)]
        self.assertTrue(all(p.shape == (6, 6, 4) for p in poses))
        fr = BY['lucioles']; self.assertEqual((len(fr), f['frame_length_ticks']), (48, 5))
        self.assertLessEqual(len(colors(fr)), 8)
        self.assertEqual(48 % len(f['pulsation']), 0)
        calc = B.firefly_frames(poses, f['points'])
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 20)
        self.assertTrue((B.firefly_frames(poses, f['points'], ts=[48])[0] == fr[0]).all())

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FMF3_fin_mystifying_forest_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Mystifying Forest', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FMF3_scene_t000.png')).all())
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 2)
        self.assertTrue(MASK['chemin'][ey:ey + 16, ex:ex + 16].mean() > 0.5)
        self.assertTrue(MASK['herbe'][by:by + 16, bx:bx + 16].mean() > 0.8)
        dv = nd.distance_transform_edt(~MASK['vasque'])
        self.assertLess(float(dv[ty:ty + 16, tx:tx + 16].min()), 32)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FMF3'", s, p); self.assertNotIn("'fin_mystifying_forest_clairiere'", s, p)

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
