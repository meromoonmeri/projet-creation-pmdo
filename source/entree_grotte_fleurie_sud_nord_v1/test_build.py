"""Tests dédiés — Entrée Grotte Fleurie sud -> nord V1 (EGF1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_grotte_fleurie_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_grotte_fleurie_sud_nord_v1'
S = R / '.cache/entree_grotte_fleurie_sud_nord_v1/entree_grotte_fleurie_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
FP, TP = M['flowers']['phases'], M['butterflies']['phases']


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def expand(p):
    if 'fXX' in p:
        return [load(O / p.replace('fXX', f'f{t:02d}')) for t in range(TP)]
    if 'fX' in p:
        return [load(O / p.replace('fX', f'f{t}')) for t in range(FP)]
    return [load(O / p)]


STACK = [expand(p) for p in M['layer_order_bottom_to_top']]
TICKS = [60, 60, 60, M['flowers']['frame_length_ticks'], 60, 60, 60, 60, M['butterflies']['frame_length_ticks']]


class Build(unittest.TestCase):
    def test_raw_hashes(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])

    def test_sizes_names_alpha_no_magenta(self):
        names = [Path(p).name for p in M['layer_order_bottom_to_top']]
        self.assertEqual(len(names), len(set(names))); self.assertTrue(all(n.startswith('EGF1_') for n in names))
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
        self.assertIsNone(M['water'])                                # pas d'eau dans la référence
        self.assertFalse((O / 'animation/eau').exists())
        self.assertFalse((O / 'animation/scintillements').exists())

    def test_flowers_closed_loop_and_sway(self):
        fl = M['flowers']; self.assertEqual(FP, 8)
        self.assertEqual(len(fl['clusters']), len({tuple(c['base_xy']) for c in fl['clusters']}))
        counts = [int((a[..., 3] > 0).sum()) for a in STACK[3]]
        self.assertGreater(min(counts), 100)                          # fleurs visibles à chaque phase
        self.assertTrue((STACK[3][0] == STACK[3][FP % FP]).all())     # boucle fermée (phase 8 == phase 0)
        # cisaillement borné : le bbox de chaque phase ne bouge pas de plus de 2 px
        boxes = []
        for a in STACK[3]:
            ys, xs = np.nonzero(a[..., 3] > 0); boxes.append((ys.min(), ys.max(), xs.min(), xs.max()))
        b0 = boxes[0]
        for b in boxes:
            self.assertLessEqual(max(abs(b[i] - b0[i]) for i in range(4)), 2)

    def test_butterflies_closed_loop(self):
        bfly = M['butterflies']; self.assertEqual(TP, 48); self.assertEqual(TP % 6, 0)
        for tr in bfly['trajectoires']:
            p = np.array(tr['positions']); steps = np.abs(np.diff(np.vstack([p, p[:1]]), axis=0)).max(1)
            self.assertLessEqual(int(steps.max()), 14)   # pas de téléportation, y compris 47 -> 0
        n = [int((a[..., 3] > 0).sum()) for a in STACK[-1]]
        self.assertGreater(min(n), 4 * 20)                            # les 4 papillons visibles à chaque phase
        for nm in ('jaune', 'bleu'):
            for i in range(6):
                self.assertEqual(load(O / f'poses_papillons/EGF1_papillon_{nm}_{i}.png').shape, (24, 24, 4))

    def test_fidelity(self):
        self.assertGreaterEqual(len(M['fidelity']['mesures']), 6)
        for k, v in M['fidelity']['mesures'].items():
            self.assertLess(v['distance'], M['fidelity']['seuil'], (k, v))

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EGF1_entree_grotte_fleurie_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EGF1_scene_t000.png')).all())

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        self.assertGreater(a['entry_px'][1], H - 64); self.assertLess(a['threshold_px'][1], H // 2)

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'donjon_seuil'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertFalse(M['pmdo']['runtime_tested']); self.assertFalse(M['art_approved'])


if __name__ == '__main__':
    unittest.main()
