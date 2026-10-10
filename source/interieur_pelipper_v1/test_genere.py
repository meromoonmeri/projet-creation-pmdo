"""Tests du lot PPO1 généré. Les sorties sont dans renders/ (non versionnées) : lancer build_genere.py d'abord.
.venv/bin/python -m unittest source.interieur_pelipper_v1.test_genere -v
"""
from pathlib import Path
import json, unittest

from PIL import Image
import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders' / 'interieur_pelipper_v1' / 'genere'
COUCHES = ['PPO1_00_base.png', 'PPO1_01_herbe.png', 'PPO1_02_contour_brun.png']


class Genere(unittest.TestCase):
    def setUp(self):
        if not (OUT / 'PPO1_assemblage.png').exists():
            self.skipTest('sorties absentes : lancer build_genere.py')

    def test_dimensions_et_grille(self):
        for n in COUCHES + ['PPO1_assemblage.png', 'PPO1_Top_vide.png']:
            self.assertEqual(Image.open(OUT / n).size, (368, 296), n)
        self.assertEqual((368 % 8, 296 % 8), (0, 0))

    def test_alpha_binaire(self):
        for n in COUCHES:
            a = np.array(Image.open(OUT / n).convert('RGBA'))[..., 3]
            self.assertTrue(np.isin(a, [0, 255]).all(), n)

    def test_couches_partitionnent_l_assemblage(self):
        asm = np.array(Image.open(OUT / 'PPO1_assemblage.png').convert('RGBA'))
        somme = np.zeros_like(asm)
        for n in COUCHES:
            c = np.array(Image.open(OUT / n).convert('RGBA'))
            m = c[..., 3] > 0
            self.assertFalse((somme[m, 3] > 0).any(), 'chevauchement ' + n)
            somme[m] = c[m]
        self.assertTrue((somme == asm).all())

    def test_pas_de_magenta_ni_de_couleur_hors_palette(self):
        asm = np.array(Image.open(OUT / 'PPO1_assemblage.png').convert('RGBA'))
        op = asm[asm[..., 3] > 0][:, :3]
        self.assertFalse(((op[:, 0] > 1.45 * op[:, 1]) & (op[:, 2] > 1.45 * op[:, 1])).any())
        self.assertLessEqual(len({tuple(c) for c in op}), 96)

    def test_top_vide(self):
        self.assertEqual(Image.open(OUT / 'PPO1_Top_vide.png').convert('RGBA').getextrema()[3], (0, 0))

    def test_fidelite_et_etats(self):
        man = json.loads((OUT / 'manifest.json').read_text())
        self.assertTrue(man['fidelite_herbe']['ok'])
        self.assertFalse(man['art_approved'])
        self.assertFalse(man['runtime_tested'])


if __name__ == '__main__':
    unittest.main()
