"""Tests de la Fin Tour Temporelle (FTT1). Lancer : .venv/bin/python -m unittest source.fin_tour_temporelle_v1.test_build -v"""
import importlib.util, json, unittest, zipfile
from pathlib import Path
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders' / 'fin_tour_temporelle_v1'


def _load():
    sp = importlib.util.spec_from_file_location('ftt1_build', HERE / 'build.py')
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


class FinTourTemporelleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.b = _load()
        cls.manifest = cls.b.build()

    def test_format_4_3(self):
        im = Image.open(OUT / 'calques' / 'FTT1_sol_complet.png')
        self.assertEqual(im.size, (768, 576))

    def test_layers_present_and_ordered(self):
        self.assertEqual(self.manifest['calques'], ['sol_complet', 'sol', 'murs_rochers', 'circuits_or'])
        for n in ['sol_complet', 'sol', 'murs_rochers']:
            self.assertTrue((OUT / 'calques' / f'FTT1_{n}.png').exists())

    def test_sol_layer_transparent_on_magenta(self):
        a = np.array(Image.open(OUT / 'calques' / 'FTT1_sol.png'))
        self.assertGreater(a.shape[0], 0)
        self.assertEqual(a[..., 3].max(), 255)
        # le sol ne contient pas le fond magenta
        mag = (a[..., 3] == 255) & (a[..., 0] > 200) & (a[..., 1] < 80) & (a[..., 2] > 200)
        self.assertEqual(int(mag.sum()), 0)

    def test_gold_animation_four_phases_loop(self):
        frames = sorted((OUT / 'animation').glob('FTT1_circuits_or_*.png'))
        self.assertEqual(len(frames), 4)
        base = np.array(Image.open(frames[0]))
        last = np.array(Image.open(frames[-1]))
        mask = base[..., 3] == 255
        self.assertEqual(mask.sum(), last[..., 3].astype(bool).sum())   # même motif
        self.assertEqual(self.manifest['boucle_ticks'], 4 * self.b.TICKS)

    def test_markers_on_walkable_cells(self):
        walk = self.b.walk_grid(self.b.walk_mask(self.b.classify(self.b.load_decor())['sol']))
        for name in ['entrance', 'boss', 'objectif']:
            x, y = self.b.MARK[name]
            self.assertTrue(walk[y // 8, x // 8], name)

    def test_path_entrance_to_objectif(self):
        self.assertIsNotNone(self.manifest['chemin_16_px'])
        self.assertLessEqual(self.manifest['chemin_16_px'], 60)

    def test_ora_opens_and_has_all_layers(self):
        with zipfile.ZipFile(OUT / 'FTT1_fin_tour_temporelle.ora') as z:
            self.assertIn('stack.xml', z.namelist())
            self.assertIn('mergedimage.png', z.namelist())
            xml = z.read('stack.xml').decode()
        for n in ['sol_complet', 'sol', 'murs_rochers', 'circuits_or']:
            self.assertIn(f'name="{n}"', xml)

    def test_flags_honest(self):
        self.assertFalse(self.manifest['art_approved'])
        self.assertFalse(self.manifest['runtime_tested'])


if __name__ == '__main__':
    unittest.main()
