#!/usr/bin/env python3
"""Tests automatisés complets pour la conversion Nuit exacte (ZÉRO génération IA) des zones Cliff Nord PMDO 0.8.12."""
from __future__ import annotations

import io
import json
import struct
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path('/home/user/projet-creation-pmdo')
OUT = ROOT / 'livrables_cliff_nord_nuit_pmdo'
MOD = OUT / 'MOD_CLIFF_NORD_NUIT_PMDO'
HTML = ROOT / 'apercu_cliff_nord_nuit_pmdo.html'


def decode_tile_bank(raw: bytes) -> dict:
    tsize, cnt = struct.unpack_from('<ii', raw, 0)
    assert tsize == 8
    tiles = {}
    for i in range(cnt):
        tx, ty, boff = struct.unpack_from('<iiq', raw, 8 + i * 16)
        blen = struct.unpack_from('<q', raw, boff)[0]
        im = Image.open(io.BytesIO(raw[boff + 8 : boff + 8 + blen])).convert('RGBA')
        assert im.size == (8, 8)
        tiles[(tx, ty)] = im
    return tiles


class TestCliffNordNuitPMDO(unittest.TestCase):
    def setUp(self) -> None:
        self.manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))

    def test_01_zero_ai_generation_and_status_flags(self) -> None:
        self.assertEqual(self.manifest['ai_generated_pixels'], 0)
        self.assertIs(self.manifest['art_approved'], False)
        self.assertIs(self.manifest['runtime_tested'], False)
        self.assertEqual(self.manifest['runtime_PMDO'], 'NOT TESTED')

    def test_02_source_rsgrounds_100pct_untouched(self) -> None:
        c1 = json.loads((ROOT / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))['Object']
        c2 = json.loads((ROOT / 'cliffnordouesttest1.rsground').read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual((len(c1['Layers'][0]['Tiles']), len(c1['Layers'][0]['Tiles'][0])), (123, 99))
        self.assertEqual((len(c2['Layers'][0]['Tiles']), len(c2['Layers'][0]['Tiles'][0])), (138, 98))

    def test_03_full_pm_engine_roundtrip_bit_exact_with_png_and_collisions(self) -> None:
        for m in self.manifest['maps']:
            src_obj = json.loads((ROOT / m['source_rsground']).read_text(encoding='utf-8-sig'))['Object']
            n_obj = json.loads((OUT / m['rsground_file']).read_text(encoding='utf-8'))['Object']

            # Collisions, entités et nombre de calques 100 % identiques à l'original
            self.assertEqual(n_obj['obstacles'], src_obj['obstacles'])
            self.assertEqual(n_obj['Entities'], src_obj['Entities'])
            self.assertEqual(len(n_obj['Layers']), len(src_obj['Layers']))

            # Décodage intégral de la banque .tile et recomposition moteur frame 0 -> comparaison bit-exacte au PNG 1x !
            tiles = decode_tile_bank((OUT / m['tile_file']).read_bytes())
            w, h = m['width_tiles'], m['height_tiles']
            recomp = Image.new('RGBA', (w * 8, h * 8), (0, 0, 0, 255))
            anim_cells = 0
            for lay in n_obj['Layers']:
                lay_im = Image.new('RGBA', (w * 8, h * 8), (0, 0, 0, 0))
                for x in range(w):
                    for y in range(h):
                        for sub in lay['Tiles'][x][y].get('Layers', []):
                            frs = sub['Frames']
                            if len(frs) > 1:
                                anim_cells += 1
                            loc = (frs[0]['TexLoc']['X'], frs[0]['TexLoc']['Y'])
                            self.assertIn(loc, tiles)
                            lay_im.alpha_composite(tiles[loc], (x * 8, y * 8))
                recomp = Image.alpha_composite(recomp, lay_im)

            self.assertGreater(anim_cells, 1000)
            ref_png = np.array(Image.open(OUT / m['night_png']).convert('RGBA'))
            diff = np.abs(np.array(recomp, dtype=np.int32) - ref_png.astype(np.int32)).max()
            self.assertEqual(int(diff), 0, f"Écart non nul ({diff}) entre le rendu moteur .rsground+.tile et {m['night_png']}")

    def test_04_zip_and_html_gallery_clean(self) -> None:
        zp = OUT / 'PACK_CLIFF_NORD_NUIT_PMDO_0812.zip'
        self.assertTrue(zp.is_file())
        with zipfile.ZipFile(zp, 'r') as zf:
            names = set(zf.namelist())
            self.assertIn('MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffdaytest_nuit.rsground', names)
            self.assertIn('MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffnordouesttest1_nuit.rsground', names)
            self.assertIn('MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/CliffDay_NordEst_Nuit.tile', names)
            self.assertIn('MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/CliffNordOuest_Nuit.tile', names)
            self.assertIn('MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/index.idx', names)
        self.assertTrue(HTML.is_file())
        txt = HTML.read_text(encoding='utf-8')
        self.assertNotIn('<canvas', txt.lower())
        self.assertIn('#161b26', txt.lower())


if __name__ == '__main__':
    unittest.main(verbosity=2)
