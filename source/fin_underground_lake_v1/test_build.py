"""Tests dédiés — Fin Underground Lake : rive du lac souterrain V1 (FUL2, 4:3 vaste).
.venv/bin/python -m unittest source.fin_underground_lake_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_underground_lake_v1'
S = R / '.cache/fin_underground_lake_v1/fin_underground_lake'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sable', 'ombres', 'berge', 'roche', 'piliers')
REF = R / 'Underground_Lake_shore_TDS.png'


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
MASK = {k: np.array(Image.open(O / f'masques/FUL2_masque_{k}.png')) > 0 for k in ('water', 'sable', 'ombres', 'piliers', 'roche')}
B = loadmod('ful2_build', HERE / 'build.py')
EUL1 = loadmod('eul1_build', R / 'source/entree_underground_lake_sud_nord_v1/build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] == 255][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def visible():
    land = np.zeros((H, W), bool)
    for k in STATIC:
        land |= alpha(BY[k][0])
    return MASK['water'] & ~land


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


class Build(unittest.TestCase):
    def test_raw_hashes_reference_and_coherence_with_entry(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'gouttes_ronds_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images']); self.assertIn(REF.name, g[2]['images'])
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor_magenta.png'))
        self.assertEqual(B.WPAL, EUL1.WPAL); self.assertEqual(B.GLOW, EUL1.GLOW)
        self.assertEqual(B.POSE_WIN, EUL1.POSE_WIN); self.assertEqual(B.DROP_SEQ, EUL1.DROP_SEQ)
        self.assertEqual(
            (HERE / 'bruts/gouttes_ronds_poses.png').read_bytes(),
            (R / 'source/entree_underground_lake_sud_nord_v1/bruts/gouttes_ronds_poses.png').read_bytes()
        )
        self.assertIn('a confirmer', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sol_complet_recale_sur_le_decor(self):
        a, f = B.rgb(HERE / 'bruts/decor_magenta.png').astype(float), B.rgb(HERE / 'bruts/sol_complet.png').astype(float)
        zone = np.zeros(a.shape[:2], bool); zone[250:850, :80] = zone[250:850, 1120:] = True
        err = {(dy, dx): float(np.abs(a - np.roll(np.roll(f, dy, 0), dx, 1))[zone].mean())
               for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
        self.assertEqual(min(err, key=err.get), (0, 0))
        self.assertAlmostEqual(err[(0, 0)], M['sol_complet']['ecart_moyen_parois'], places=2)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FUL2_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for frames in STACK:
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)).sum()), 0)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['eau', 'lueur', 'scintillements', 'gouttes', 'sol_complet', *STATIC])
        cover = np.zeros((H, W), bool)
        for frames in STACK:
            cover |= alpha(frames[0])
        self.assertTrue(cover.all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertEqual(int(np.sum(fixed, 0).max()), 1)
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
        self.assertFalse((alpha(BY['sol_complet'][0]) & MASK['water']).any())

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY['roche'][0], BY['piliers'][0]])), 64)
        lum = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(float) @ [.299, .587, .114]
        sb = BY['sable'][0][alpha(BY['sable'][0])][:, :3].astype(float).mean(0)
        self.assertGreater(sb[0], sb[2] + 50)
        self.assertLess(lum('ombres').mean(), lum('sable').mean() - 8)
        ro = nd.distance_transform_edt(~(alpha(BY['roche'][0]) | alpha(BY['berge'][0]) | alpha(BY['piliers'][0])))
        self.assertLessEqual(float(ro[alpha(BY['ombres'][0])].max()), 14)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 20, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 20, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)

    def test_eau_couleurs_du_rip_sans_lisere(self):
        fr = BY['eau']; mask = alpha(fr[0]); rip = rip_colors()
        self.assertEqual((len(fr), M['water']['frame_length_ticks']), (4, 10))
        self.assertGreater(int(mask.sum()), 50000)
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        self.assertTrue(colors(fr) <= rip, colors(fr) - rip)
        for c in ((119, 127, 175), (167, 167, 223), (103, 103, 159), (79, 87, 143), (148, 230, 238)):
            self.assertNotIn(c, colors(fr))
        vis = visible(); rim = vis & nd.binary_dilation(~MASK['water'])
        bande = np.array(M['water']['couleurs']['bande'])
        for a in fr:
            self.assertTrue((a[rim][:, :3] == bande).all())
        d = steps(fr, vis)
        self.assertTrue(min(d) > 300 and max(d) < 2 * min(d), d)

    def test_lueur_couleurs_du_rip_et_respiration(self):
        fr = BY['lueur']; rip = rip_colors(); vis = visible()
        self.assertEqual((len(fr), M['lueur']['frame_length_ticks']), (12, 10))
        self.assertEqual(colors(fr), {tuple(c) for c in M['lueur']['couleurs']})
        self.assertTrue(colors(fr) <= rip)
        for a in fr:
            self.assertFalse((alpha(a) & ~vis).any())
        d = steps(fr)
        self.assertTrue(min(d) > 200 and max(d) < 4 * min(d), d)
        f12 = B.glow_frames(vis, [tuple(c) for c in M['lueur']['centres']], ts=[12])[0]
        self.assertTrue(np.array_equal(f12, fr[0]))

    def test_scintillements_natifs(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        native = {tuple(int(v) for v in px[:3]) for t in v2.decode_tile(R / M['sparkles']['source']).values()
                  for px in t.reshape(-1, 4) if px[3] == 255}
        vis = visible()
        for a in BY['scintillements']:
            cols = colors([a]); self.assertTrue(cols <= native); self.assertGreater(len(cols), 0)
            self.assertFalse((alpha(a) & ~vis).any())

    def test_gouttes_et_ronds_boucle_fermee(self):
        fr = BY['gouttes']; vis = visible()
        self.assertEqual((len(fr), M['gouttes']['frame_length_ticks']), (24, 5))
        pal = {tuple(c) for c in M['gouttes']['palette']}
        self.assertTrue(colors(fr) <= pal)
        for name in M['gouttes']['poses']:
            p = load(O / f'poses/FUL2_{name}.png')
            self.assertGreater(int(alpha(p).sum()), 3, name)
            self.assertTrue(colors([p]) <= pal, name)
        d = steps(fr)
        self.assertTrue(min(d) > 20 and max(d) < 4 * min(d), d)
        poses = {k: load(O / f'poses/FUL2_{k}.png') for k in M['gouttes']['poses']}
        f24 = B.drop_frames(poses, [tuple(e) for e in M['gouttes']['emetteurs']], vis, ts=[24])[0]
        self.assertTrue(np.array_equal(f24, fr[0]))

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FUL2_fin_underground_lake_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = load(O / 'review/FUL2_scene_t000.png')
        self.assertTrue(np.array_equal(merged, sc))

    def test_access_fin_sans_sortie(self):
        v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        self.assertNotIn('threshold_px', a)
        walk_px = alpha(BY['sable'][0]) | alpha(BY['ombres'][0])
        blocked = B.cell_grid(~walk_px)
        blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
        prat = np.array(Image.open(O / 'masques/FUL2_masque_praticable.png')) > 0
        self.assertTrue(np.array_equal(~blocked, prat))
        self.assertEqual(int(blocked.sum()), a['blocked_cells'])
        self.assertGreater(a['walkable_cells'], 500)
        self.assertTrue(blocked[0, :].all() and blocked[:, 0].all() and blocked[:, -1].all())
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objectif_px']
        self.assertGreaterEqual(ey, H - 32)
        self.assertLess(oy, by); self.assertLess(by, ey - 80)
        for qx, qy in ((ex, ey), (bx, by), (ox, oy)):
            self.assertFalse(blocked[qy // 8:qy // 8 + 2, qx // 8:qx // 8 + 2].any(), (qx, qy))
            self.assertFalse(MASK['water'][qy:qy + 16, qx:qx + 16].any(), (qx, qy))
        ok_eb, _ = v1.reachable(blocked, (ey // 8, ex // 8), (by // 8, bx // 8))
        ok_bo, _ = v1.reachable(blocked, (by // 8, bx // 8), (oy // 8, ox // 8))
        self.assertTrue(ok_eb and ok_bo)

    def test_ground_roundtrip(self):
        v2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        tools = loadmod('inst', R / 'source/pmdo_cote/INSTALLER.py')
        g = json.loads((S / 'Data/Ground/ful2_fin_underground_lake.rsground').read_text())['Object']
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
            self.assertNotEqual(d.get('prefix'), 'FUL2', p)
            self.assertNotEqual(d.get('pmdo', {}).get('namespace'), 'fin_underground_lake', p)


if __name__ == '__main__':
    unittest.main()
