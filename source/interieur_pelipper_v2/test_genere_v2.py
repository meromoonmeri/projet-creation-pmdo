"""Tests du lot PPO2 (taille Halcyon 384 × 312). Sorties dans renders/ : lancer build_genere_v2.py d'abord.
.venv/bin/python -m unittest source.interieur_pelipper_v2.test_genere_v2 -v
"""
from pathlib import Path
import json, unittest

from PIL import Image
import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders' / 'interieur_pelipper_v2' / 'genere'
COUCHES = ['PPO2_00_base.png', 'PPO2_01_herbe.png', 'PPO2_02_contour_brun.png']


class Ppo2(unittest.TestCase):
    def setUp(self):
        if not (OUT / 'PPO2_assemblage.png').exists():
            self.skipTest('sorties absentes : lancer build_genere_v2.py')

    def test_taille_halcyon(self):
        for n in COUCHES + ['PPO2_assemblage.png', 'PPO2_Top_vide.png']:
            self.assertEqual(Image.open(OUT / n).size, (384, 312), n)
        self.assertEqual((384 % 8, 312 % 8), (0, 0))
        self.assertEqual((384 // 24, 312 // 24), (16, 13))

    def test_marges_transparentes_et_salle_pleine_largeur(self):
        a = np.array(Image.open(OUT / 'PPO2_assemblage.png').convert('RGBA'))[..., 3]
        rows = np.where(a.any(1))[0]
        self.assertEqual((rows[0], rows[-1]), (14, 297))
        self.assertFalse(a[:14].any() or a[298:].any())
        self.assertTrue(a[:, 0].any() and a[:, -1].any())

    def test_alpha_binaire(self):
        for n in COUCHES:
            self.assertTrue(np.isin(np.array(Image.open(OUT / n).convert('RGBA'))[..., 3], [0, 255]).all(), n)

    def test_couches_partitionnent_l_assemblage(self):
        asm = np.array(Image.open(OUT / 'PPO2_assemblage.png').convert('RGBA'))
        somme = np.zeros_like(asm)
        for n in COUCHES:
            c = np.array(Image.open(OUT / n).convert('RGBA'))
            m = c[..., 3] > 0
            self.assertFalse((somme[m, 3] > 0).any(), 'chevauchement ' + n)
            somme[m] = c[m]
        self.assertTrue((somme == asm).all())

    def test_palette_sans_magenta(self):
        asm = np.array(Image.open(OUT / 'PPO2_assemblage.png').convert('RGBA'))
        op = asm[asm[..., 3] > 0][:, :3]
        self.assertFalse(((op[:, 0] > 1.45 * op[:, 1]) & (op[:, 2] > 1.45 * op[:, 1])).any())
        self.assertLessEqual(len({tuple(c) for c in op}), 96)

    def test_top_vide_et_etats(self):
        self.assertEqual(Image.open(OUT / 'PPO2_Top_vide.png').convert('RGBA').getextrema()[3], (0, 0))
        man = json.loads((OUT / 'manifest.json').read_text())
        self.assertTrue(man['fidelite_herbe']['ok'])
        self.assertFalse(man['art_approved'])
        self.assertFalse(man['runtime_tested'])


if __name__ == '__main__':
    unittest.main()
