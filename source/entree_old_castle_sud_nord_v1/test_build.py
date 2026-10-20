"""Tests EOC1 — Entrée Old Castle sud -> nord (rendu généré référencé, pas un test moteur)."""
import hashlib, importlib.util, json, unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/entree_old_castle_sud_nord_v1'
STAGE = R / '.cache/entree_old_castle_sud_nord_v1/entree_old_castle_sud_nord'
PFX = 'EOC1'
W, H = 768, 576


def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def rgba(p):
    return np.array(Image.open(p).convert('RGBA'))


class TestEOC1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.b = load('eoc1_build', HERE / 'build.py')

    def test_manifest_coherent(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertEqual(m['grid_8px'], [96, 72])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(m['pmdo']['target'], '0.8.12')

    def test_raw_inputs_hashes(self):
        for it in self.m['raw_inputs']:
            p = R / it['file']
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'], it['file'])
            self.assertEqual(list(Image.open(p).size), it['size'])

    def test_layers_files(self):
        self.assertEqual(len(self.m['layers']), 10)          # 9 statiques + scintillement (Top ajoute dans le Ground)
        for lay in self.m['layers']:
            if 'fNN' in lay['file']:
                files = [OUT / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
            else:
                files = [OUT / lay['file']]
            for f in files:
                self.assertTrue(f.exists(), f)
                self.assertEqual(Image.open(f).size, (W, H), f)

    def test_layers_nonempty_no_magenta(self):
        for lay in self.m['layers']:
            f = OUT / lay['file'].replace('fNN', 'f00')
            a = rgba(f)
            self.assertGreater(int((a[..., 3] > 0).sum()), 50, lay['file'])
            magenta = (a[..., 0] > 250) & (a[..., 1] < 10) & (a[..., 2] > 250) & (a[..., 3] > 0)
            self.assertFalse(bool(magenta.any()), lay['file'])

    def test_recomposition_equals_scene(self):
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            comp.alpha_composite(Image.open(OUT / lay['file'].replace('fNN', 'f00')).convert('RGBA'))
        scene = Image.open(OUT / 'review' / f'{PFX}_scene_t000.png').convert('RGBA')
        self.assertTrue(np.array_equal(np.array(comp), np.array(scene)))

    def test_access_path_and_markers(self):
        acc = self.m['access']
        self.assertTrue(acc['path_found_16x16'])
        self.assertGreater(acc['walkable_cells'], 1500)
        walk = np.array(Image.open(OUT / 'masques' / f'{PFX}_masque_praticable.png')) > 0
        for key in ('entry_px', 'threshold_px'):
            x, y = acc[key]
            self.assertTrue(bool(walk[y:y + 16, x:x + 16].all()), (key, x, y))

    def test_scintillement_loop(self):
        files = sorted((OUT / 'animation/scintillement').glob('*.png'))
        self.assertEqual(len(files), 24)
        frames = [rgba(f) for f in files]
        self.assertTrue(any((f[..., 3] > 0).any() for f in frames))
        self.assertFalse(np.array_equal(frames[0], frames[6]))
        allowed = {(*c, 255) for c in self.b.SPARK_COLS}
        seen = set()
        for f in frames:
            px = f[f[..., 3] > 0]
            seen |= {tuple(v) for v in px.tolist()}
        self.assertLessEqual(seen, allowed)
        gold = np.array(Image.open(OUT / 'masques' / f'{PFX}_masque_tresor.png')) > 0
        gold |= np.array(Image.open(OUT / 'masques' / f'{PFX}_masque_medaillon.png')) > 0
        for x, y in self.m['scintillement']['points']:
            self.assertTrue(bool(gold[y, x]), (x, y))   # centres des eclats sur l or (les bras peuvent deborder de 2 px)

    def test_fidelity_under_threshold(self):
        fid = self.m['fidelite_rip']
        for k, v in fid['brut'].items():
            self.assertLess(v['distance'], 35, k)
        for k, v in fid['calques_finaux'].items():
            self.assertLess(v['distance_rip'], 35, k)
        self.assertLess(fid['sol_complet'], 35)

    def test_ground_and_tilesets(self):
        g = STAGE / 'Data/Ground/eoc1_entree_old_castle.rsground'
        self.assertTrue(g.exists())
        self.assertTrue((STAGE / 'Content/Tile/index.idx').exists())
        obj = json.loads(g.read_text())['Object']
        self.assertEqual(obj['AssetName'], 'eoc1_entree_old_castle')
        self.assertEqual(len(obj['Layers']), 11)              # 10 + Top
        markers = obj['Entities'][0]['Markers']
        self.assertEqual([mk['EntName'] for mk in markers], ['entrance', 'donjon_seuil'])
        counts = self.m['pmdo']['tiles_per_bank']
        self.assertEqual(len(counts), 10)
        for name, n in counts.items():
            self.assertTrue((STAGE / f'Content/Tile/{name}.tile').exists(), name)
            self.assertGreater(n, 1, name)

    def test_no_warp_script(self):
        init = STAGE / 'Data/Script/entree_old_castle_sud_nord/ground/eoc1_entree_old_castle/init.lua'
        self.assertTrue(init.exists())
        self.assertNotIn('Warp', init.read_text())


if __name__ == '__main__':
    unittest.main()
