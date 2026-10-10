"""Tests du lot PPO1 : fidélité au pixel près, grille 8 px, aucune couleur inventée, manifeste cohérent.
.venv/bin/python -m unittest source.interieur_pelipper_v1.test_build -v
"""
from pathlib import Path
import hashlib, json, unittest

from PIL import Image
import numpy as np

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
SRC = HERE / 'reference' / 'pelipper_post_office_interior_gba.png'
OUT = R / 'renders' / 'interieur_pelipper_v1'
SALLE = OUT / 'PPO1_00_salle_complete.png'
BOITE = (8, 8, 376, 304)


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


class Pelipper(unittest.TestCase):
    def setUp(self):
        if not SALLE.exists():
            self.skipTest('sortie absente : lancer build.py')

    def test_source_intacte(self):
        man = json.loads((OUT / 'manifest.json').read_text())
        self.assertEqual(sha(SRC), man['source']['sha256'])

    def test_dimensions_grille_8px(self):
        w, h = Image.open(SALLE).size
        self.assertEqual((w % 8, h % 8), (0, 0))
        self.assertEqual((w, h), (368, 296))

    def test_pixels_identiques_a_la_capture(self):
        a = np.array(Image.open(SALLE).convert('RGBA'))
        b = np.array(Image.open(SRC).convert('RGBA').crop(BOITE))
        self.assertTrue((a == b).all())

    def test_aucune_couleur_inventee(self):
        src = np.array(Image.open(SRC).convert('RGB')).reshape(-1, 3)
        out = np.array(Image.open(SALLE).convert('RGB')).reshape(-1, 3)
        src_set = {tuple(c) for c in np.unique(src, axis=0)}
        self.assertTrue(all(tuple(c) in src_set for c in np.unique(out, axis=0)))

    def test_pas_de_bande_de_sprites(self):
        # la bande (y ≥ 304) n'est pas dans la sortie : sa hauteur est le bas de la boîte
        self.assertEqual(Image.open(SALLE).size[1], BOITE[3] - BOITE[1])

    def test_manifeste_etats(self):
        man = json.loads((OUT / 'manifest.json').read_text())
        self.assertFalse(man['art_approved'])
        self.assertFalse(man['runtime_tested'])
        self.assertFalse(man['calques']['separes'])
        self.assertEqual(man['sorties']['PPO1_00_salle_complete.png']['sha256'], sha(SALLE))


if __name__ == '__main__':
    unittest.main()
