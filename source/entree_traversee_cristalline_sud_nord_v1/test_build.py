"""Tests d'intégrité — Entrée Traversée Cristalline sud -> nord V1 (ETX1).

Lancer : .venv/bin/python source/entree_traversee_cristalline_sud_nord_v1/test_build.py
"""
from pathlib import Path
import json, unittest, xml.etree.ElementTree as ET, zipfile
import numpy as np
from PIL import Image

import build as B

OUT = B.OUT
STAGE = B.STAGE
PFX = B.PFX


class EntreeTraverseeCristallineTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((OUT / 'manifest.json').read_text())
        cls.ground = json.loads((STAGE / f'Data/Ground/{B.ASSET}.rsground').read_text(encoding='utf-8-sig'))['Object']

    def test_01_dimensions_and_prefix(self):
        self.assertEqual(self.manifest['prefix'], 'ETX1')
        self.assertEqual(self.manifest['size_px'], [768, 576])
        self.assertEqual(self.manifest['grid_8px'], [96, 72])
        with Image.open(OUT / 'review' / f'{PFX}_scene_t000.png') as im:
            self.assertEqual(im.size, (768, 576))

    def test_02_static_partition(self):
        masks = [np.array(Image.open(OUT / 'masques' / f'{PFX}_masque_{k}.png')) > 0 for k in B.STATIC]
        tot = sum(m.astype(int) for m in masks)
        self.assertTrue((tot == 1).all(), 'Les masques statiques doivent partitionner exactement 768x576')

    def test_03_fidelity_to_rip_d16p11a(self):
        for k, v in self.manifest['fidelite_rip']['brut'].items():
            self.assertLess(v['distance'], 35.0, f'Distance trop élevée pour {k}: {v}')

    def test_04_closed_loop_animations(self):
        lg = [np.array(Image.open(OUT / 'animation/lueurs_grotte' / f'{PFX}_10_lueurs_grotte_f{t:02d}.png')) for t in range(B.PHASES)]
        sc = [np.array(Image.open(OUT / 'animation/scintillements' / f'{PFX}_11_scintillements_f{t:02d}.png')) for t in range(B.PHASES)]
        self.assertTrue(any(not np.array_equal(lg[0], f) for f in lg[1:]))
        self.assertTrue(any(not np.array_equal(sc[0], f) for f in sc[1:]))

    def test_05_entrance_markers_and_16x16_bfs(self):
        mks = {m['EntName']: m for m in self.ground['Entities'][0]['Markers']}
        self.assertEqual(set(mks.keys()), {'entrance', 'donjon_seuil'})
        self.assertTrue(self.manifest['access']['path_found_16x16'])

    def test_06_pmdo_ground_and_ora_integrity(self):
        self.assertEqual(self.ground['TexSize'], 1)
        self.assertEqual(self.ground['Layers'][-1]['Layer'], 4)
        with zipfile.ZipFile(OUT / f'{PFX}_entree_traversee_cristalline_calques.ora') as z:
            self.assertEqual(z.read('mimetype').decode(), 'image/openraster')
            ET.fromstring(z.read('stack.xml'))
        self.assertFalse(self.manifest['art_approved'])
        self.assertFalse(self.manifest['pmdo']['runtime_tested'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
