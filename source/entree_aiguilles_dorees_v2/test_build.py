"""Contrôles de la correction immersive EAD2 : Python, pas le moteur PMDO."""
from pathlib import Path
import json
import shutil
import tempfile
import unittest

import numpy as np
from PIL import Image

from source.maps_suite_v1.pipeline import Map
from . import verify as V

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


class ImmersiveMap(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map = Map(HERE)
        cls.m = json.loads((cls.map.out / 'manifest.json').read_text())

    def test_ground_et_banques_reconstruits(self):
        report = V.verify()
        self.assertEqual(report['native_reconstructions'], 30)
        self.assertFalse(report['runtime_tested'])

    def test_premier_plan_large_et_acces(self):
        walk = np.array(Image.open(self.map.out / 'masques/EAD2_praticable.png')) > 0
        # L'ancien goulot sud est remplacé par plus de 380 px de sol au premier plan.
        self.assertGreater(int(walk[-8].sum()), 380)
        blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > .25
        marks = self.m['access']['markers']
        self.assertTrue(V.reachable(blocked, marks['entrance'], marks['donjon_seuil']))
        self.assertGreaterEqual(marks['entrance'][1], 552)
        self.assertLess(marks['donjon_seuil'][1], 288)
        self.assertFalse(self.m['access']['warp'])

    def test_profondeur_dessinee_non_aplat(self):
        layer = next(l for l in self.m['layers'] if l['name'] == 'profondeur')
        a = V.load(self.map.out / layer['file'])
        pixels = a[a[..., 3] > 0, :3]
        self.assertGreater(len(pixels), 10000)
        self.assertGreater(len(np.unique(pixels, axis=0)), 24)
        self.assertGreater(float(pixels.std()), 10)
        self.assertIsNone(self.m['depth_color'])
        self.assertEqual(self.map.config['depth_mode'], 'drawn')

    def test_fidelite_recalculee(self):
        ref = self.map.b.rgb(self.map.ref)
        for stage, a in [('brut', self.map.b.rgb(HERE / 'bruts/decor.png')),
                         ('sortie', np.array(Image.open(self.map.out / 'review/EAD2_scene_t000.png').convert('RGB')))]:
            measured = self.map.fidelity(a, ref)
            self.assertEqual(measured, self.m['fidelity'][stage])
            for stats in measured.values():
                self.assertLess(stats['distance'], 35)
                self.assertGreater(stats['pixels_lot'], a.shape[0] * a.shape[1] * .1)

    def test_animation_loi_et_boucle(self):
        d = self.m['dust']
        walk = np.array(Image.open(self.map.out / 'masques/EAD2_praticable.png')) > 0
        for t in range(24):
            actual = self.map.effect(t, d['emitters'], walk, d['colors'])
            exported = V.load(self.map.out / f'animation/EAD2_06_poussiere_f{t:02d}.png')
            np.testing.assert_array_equal(actual, exported)
            np.testing.assert_array_equal(actual, self.map.effect(t + 24, d['emitters'], walk, d['colors']))
        with Image.open(self.map.out / 'review/EAD2_scene_animee.webp') as im:
            duration = 0
            for t in range(im.n_frames):
                im.seek(t); im.load(); duration += im.info.get('duration', 0)
            self.assertEqual(duration, 2000)

    def mutation(self, change, message):
        with tempfile.TemporaryDirectory(dir=ROOT / '.cache') as tmp:
            out, stage = Path(tmp) / 'out', Path(tmp) / 'stage'
            shutil.copytree(self.map.out, out, ignore=shutil.ignore_patterns('*.zip', '*.html'))
            shutil.copytree(self.map.stage, stage)
            change(out, stage)
            with self.assertRaisesRegex((AssertionError, ValueError), message):
                V.verify(out, stage)

    def test_mutation_pixel(self):
        def change(out, stage):
            p = out / 'calques/EAD2_00_sol_complet.png'
            a = V.load(p); a[0, 0] = (255, 0, 0, 255); Image.fromarray(a).save(p)
        self.mutation(change, 'Reconstruction')

    def test_mutation_marqueur(self):
        def change(out, stage):
            p = stage / 'Data/Ground/ead2_entree_aiguilles_dorees.rsground'
            d = json.loads(p.read_text()); d['Object']['Entities'][0]['Markers'][0]['Collider']['X'] = 0
            p.write_text(json.dumps(d))
        self.mutation(change, 'Marqueurs')

    def test_mutation_animation(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/EAD2_06_poussiere_f00.png', out / 'animation/EAD2_06_poussiere_f01.png')
        self.mutation(change, 'Reconstruction')


if __name__ == '__main__':
    unittest.main()
