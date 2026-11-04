"""Tests dédiés — Fin Grotte Fleurie V1 (FGF1, fond de donjon 4:3).
.venv/bin/python -m unittest source.fin_grotte_fleurie_v1.test_build -v
Contrôles d'images, de formats, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_grotte_fleurie_v1'
S = R / '.cache/fin_grotte_fleurie_v1/fin_grotte_fleurie'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
FP = M['flowers']['phases']
GP = M['glow']['phases']
PP = M['petals']['phases']


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def expand(p):
    if 'fXX' in p:
        n = GP if 'lueur' in p else PP
        return [load(O / p.replace('fXX', f'f{t:02d}')) for t in range(n)]
    if 'fX' in p:
        return [load(O / p.replace('fX', f'f{t}')) for t in range(FP)]
    return [load(O / p)]


STACK = [expand(p) for p in M['layer_order_bottom_to_top']]
TICKS = [60, 60, 60, M['flowers']['frame_length_ticks'], 60, 60, 60,
         M['glow']['frame_length_ticks'], 60, M['petals']['frame_length_ticks']]


class Build(unittest.TestCase):
    def test_raw_hashes(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])

    def test_sizes_names_alpha_no_magenta(self):
        names = [Path(p).name for p in M['layer_order_bottom_to_top']]
        self.assertEqual(len(names), len(set(names))); self.assertTrue(all(n.startswith('FGF1_') for n in names))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for frames in STACK:
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_full_coverage_and_no_water(self):
        self.assertTrue((STACK[0][0][..., 3] == 255).all())          # sol continu, aucun trou
        self.assertIsNone(M['water'])
        self.assertFalse((O / 'animation/eau').exists())
        self.assertFalse((O / 'animation/papillons').exists())       # fond de donjon : pas de papillons

    def test_salle_fermee(self):
        """Parois continues au nord et sur les deux flancs ; au sud, seul le sentier ouvre la salle."""
        walls = STACK[8][0][..., 3] > 0
        for edge in (walls[0, :], walls[:, 0], walls[:, -1]):
            self.assertGreater(float(edge.mean()), 0.90)
        south_wall = walls[-1, :]; south_path = STACK[4][0][-1, :, 3] > 0
        self.assertTrue((south_wall | south_path).all())              # pas de trou herbeux au sud
        self.assertGreater(float(south_path.mean()), 0.05)            # l'entrée existe
        self.assertLess(float(south_path.mean()), 0.35)               # mais c'est un couloir, pas un mur ouvert

    def test_flowers_closed_loop_and_sway(self):
        self.assertEqual(FP, 8)
        fl = M['flowers']
        self.assertEqual(len(fl['clusters']), len({tuple(c['base_xy']) for c in fl['clusters']}))
        counts = [int((a[..., 3] > 0).sum()) for a in STACK[3]]
        self.assertGreater(min(counts), 100)
        boxes = []
        for a in STACK[3]:
            ys, xs = np.nonzero(a[..., 3] > 0); boxes.append((ys.min(), ys.max(), xs.min(), xs.max()))
        for b in boxes:
            self.assertLessEqual(max(abs(b[i] - boxes[0][i]) for i in range(4)), 2)

    def test_autel_present_et_masque_dedie(self):
        aut = STACK[6][0]
        m = aut[..., 3] > 0
        self.assertGreater(int(m.sum()), 1500)                       # estrade + couronne visibles
        ys, xs = np.nonzero(m)
        self.assertLess(ys.mean(), H * 0.45)                         # au nord
        self.assertLess(abs(xs.mean() - W / 2), 60)                  # centré
        self.assertEqual(M['pmdo']['tiles_per_bank']['FGF1_06_AUTEL'] > 0, True)

    def test_glow_binaire_anime_et_local(self):
        self.assertEqual(GP, 12)
        altar = STACK[6][0][..., 3] > 0
        near = nd.distance_transform_edt(~altar) <= 14
        uniq = set()
        for a in STACK[7]:
            m = a[..., 3] > 0
            self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
            self.assertGreater(int(m.sum()), 50)                     # halo visible à chaque phase
            self.assertEqual(int((m & ~near).sum()), 0)              # le halo reste autour de l'autel
            uniq.add(a.tobytes())
        self.assertGreater(len(uniq), 6)                             # ça respire vraiment

    def test_petals_closed_loop(self):
        self.assertEqual(PP, 24)
        self.assertEqual(PP * M['petals']['step'], M['petals']['span'])   # boucle verticale fermée
        self.assertEqual(len(M['petals']['placements']), M['petals']['nombre'])
        counts = [int((a[..., 3] > 0).sum()) for a in STACK[9]]
        self.assertGreater(min(counts), 180)
        self.assertLessEqual(max(counts), M['petals']['nombre'] * 9)
        ys = [float(np.nonzero(a[..., 3] > 0)[0].mean()) for a in STACK[9]]
        self.assertGreater(sum(1 for i in range(PP - 1) if ys[i + 1] > ys[i]), PP * 0.6)   # ça tombe

    def test_fidelity(self):
        self.assertGreaterEqual(len(M['fidelity']['mesures']), 6)
        for k, v in M['fidelity']['mesures'].items():
            self.assertLess(v['distance'], M['fidelity']['seuil'], (k, v))

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FGF1_fin_grotte_fleurie_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FGF1_scene_t000.png')).all())

    def test_access(self):
        a = M['access']
        self.assertTrue(a['path_found_16x16']); self.assertTrue(a['arene_accessible'])
        self.assertGreater(a['entry_px'][1], H - 64)
        self.assertLess(a['objectif_px'][1], H // 2)
        self.assertLess(abs(a['boss_px'][0] - W // 2), 96)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, (frames, ticks) in enumerate(zip(STACK, TICKS)):
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), ticks))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (li, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertFalse(M['pmdo']['runtime_tested']); self.assertFalse(M['art_approved'])


if __name__ == '__main__':
    unittest.main()
