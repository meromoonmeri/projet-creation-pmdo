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


class FinTourTemporelleGroundTests(unittest.TestCase):
    """Ground natif : fonds de nébuleuse défilants, calques, marqueurs, collisions. Lance le packaging."""
    @classmethod
    def setUpClass(cls):
        cls.b = _load()
        cls.manifest = cls.b.build()
        sp = importlib.util.spec_from_file_location('ftt1_pkg', HERE / 'package_pmdo.py')
        cls.pkg = importlib.util.module_from_spec(sp); sp.loader.exec_module(cls.pkg)
        cls.zip = cls.pkg.build()
        cls.stage = cls.pkg.STAGE
        cls.obj = json.loads((cls.stage / 'Data/Ground/ftt1_fin_tour_temporelle.rsground').read_text())['Object']

    def test_two_scrolling_nebula_backgrounds(self):
        bgs = self.obj['Background']['Layers']
        self.assertEqual(len(bgs), 2)
        for layer in bgs:
            self.assertTrue(layer['BG']['RepeatX'])
            self.assertFalse(layer['BG']['RepeatY'])
            self.assertNotEqual(layer['BG']['BGMovement']['X'], 0)
        self.assertNotEqual(bgs[0]['BG']['BGMovement']['X'], bgs[1]['BG']['BGMovement']['X'])
        for name in [self.pkg.NEB_LOIN, self.pkg.NEB_PROCHE]:
            self.assertTrue((self.stage / f'Content/BG/{name}.dir').exists())

    def test_nebula_is_horizontally_periodic(self):
        img = self.pkg.nebula_images()[self.pkg.NEB_LOIN].astype(float)
        self.assertEqual(img.shape[:2], (576, 768))
        seam = np.abs(img[:, 0] - img[:, -1]).mean()
        cols = np.abs(img[:, 1:] - img[:, :-1]).mean(axis=(0, 2))
        self.assertLess(seam, np.percentile(cols, 99.5) + 1)

    def test_layers_and_gold_animation(self):
        names = [l['Name'] for l in self.obj['Layers']]
        self.assertEqual(len(names), 6)
        gold = self.obj['Layers'][3]['Tiles']
        frames = [len(t['Layers'][0]['Frames']) for col in gold for t in col if t['Layers']]
        self.assertTrue(frames)
        self.assertEqual(set(frames), {4})

    def test_markers_and_collisions(self):
        names = [m['EntName'] for m in self.obj['Entities'][0]['Markers']]
        self.assertEqual(names, ['entrance', 'boss', 'objectif'])
        blocked = sum(c['Tags'] for col in self.obj['obstacles'] for c in col)
        self.assertEqual(blocked, self.manifest['cases_bloquees'])

    def test_pack_zip_contents(self):
        with zipfile.ZipFile(self.zip) as z:
            names = z.namelist()
        for n in ['Data/Ground/ftt1_fin_tour_temporelle.rsground', 'Content/Tile/index.idx', 'Mod.xml',
                  'Content/BG/FTT1_NEBULEUSE_LOIN.dir', 'Content/BG/FTT1_NEBULEUSE_PROCHE.dir']:
            self.assertIn(n, names)


if __name__ == '__main__':
    unittest.main()
