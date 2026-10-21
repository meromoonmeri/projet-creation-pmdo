#!/usr/bin/env python3
"""Suite de vérification complète du lot Guilde Réseau Vide + Cliff North (PMDO 0.8.12)."""
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
OUT = ROOT / 'livrables_guilde_reseau_vide_et_cliffnorth_pmdo'
HTML = ROOT / 'apercu_guilde_reseau_vide_et_cliffnorth.html'


class TestGuildeReseauEtCliffNorth(unittest.TestCase):
    def setUp(self) -> None:
        self.manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
        self.zip_path = OUT / 'PACK_GUILDE_RESEAU_VIDE_ET_CLIFFNORTH_PMDO.zip'

    def test_01_status_and_attribution_flags(self) -> None:
        self.assertIs(self.manifest['art_approved'], False)
        self.assertIs(self.manifest['runtime_tested'], False)
        self.assertEqual(self.manifest['runtime_PMDO'], 'NOT TESTED')
        self.assertIn('Halcyon', self.manifest['attribution'])
        self.assertEqual(self.manifest['guild_empty_network']['furniture_count_total'], 0)
        self.assertEqual(self.manifest['guild_empty_network']['spinda_spirals_total'], 0)

    def test_02_source_rsground_untouched(self) -> None:
        orig_cno = json.loads((ROOT / 'cliffnordouesttest1.rsground').read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual(len(orig_cno['Layers'][0]['Tiles']), 138)
        self.assertEqual(len(orig_cno['Layers'][0]['Tiles'][0]), 98)

    def test_03_all_13_empty_rooms_pngs_clean_rgba_and_grid_8px(self) -> None:
        rooms = self.manifest['guild_empty_network']['rooms']
        self.assertEqual(len(rooms), 13)
        for r in rooms:
            p = OUT / r['png_1x']
            self.assertTrue(p.is_file(), r['id'])
            im = Image.open(p).convert('RGBA')
            self.assertEqual(im.size, (r['width_px'], r['height_px']))
            self.assertEqual(im.width % 8, 0)
            self.assertEqual(im.height % 8, 0)
            arr = np.array(im)
            # Les 4 coins doivent être strictement transparents (alpha == 0, zéro cadre noir ni fond #FF00FF)
            for cy, cx in [(0, 0), (0, -1), (-1, 0), (-1, -1)]:
                self.assertEqual(int(arr[cy, cx, 3]), 0, f'Coin non transparent sur {r["id"]}')
            # Zéro pixel #FF00FF résiduel dans la zone opaque
            op = arr[..., 3] > 0
            mag = op & (arr[..., 0] > 200) & (arr[..., 1] < 60) & (arr[..., 2] > 200)
            self.assertEqual(int(mag.sum()), 0, f'Résidu magenta sur {r["id"]}')

    def test_04_cliff_north_1104x784_and_zip_integrity(self) -> None:
        c_im = Image.open(OUT / 'png_1x/cliff_north_metano.png').convert('RGBA')
        self.assertEqual(c_im.size, (1104, 784))
        with zipfile.ZipFile(self.zip_path, 'r') as zf:
            names = set(zf.namelist())
            self.assertIn('MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/Guilde_Reseau_Vide_Metano_8px.tile', names)
            self.assertIn('MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/Cliff_North_Metano_8px.tile', names)
            self.assertIn('MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/index.idx', names)
            self.assertIn('MOD_GUILDE_ET_CLIFFNORTH/Data/Ground/cliff_north_metano.rsground', names)
            self.assertEqual(len([n for n in names if n.endswith('.rsground')]), 14)

            # Vérifie que la grille obstacles 138x98 de cliffnordouesttest1.rsground est 100% préservée !
            orig_obs = json.loads((ROOT / 'cliffnordouesttest1.rsground').read_text(encoding='utf-8-sig'))['Object']['obstacles']
            new_cno = json.loads(zf.read('MOD_GUILDE_ET_CLIFFNORTH/Data/Ground/cliff_north_metano.rsground'))['Object']
            self.assertEqual(new_cno['obstacles'], orig_obs)

            # Vérifie la relecture binaire RogueEssence des deux banques .tile
            for tpath in [
                'MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/Guilde_Reseau_Vide_Metano_8px.tile',
                'MOD_GUILDE_ET_CLIFFNORTH/Content/Tile/Cliff_North_Metano_8px.tile',
            ]:
                raw = zf.read(tpath)
                tsize, cnt = struct.unpack_from('<ii', raw, 0)
                self.assertEqual(tsize, 8)
                self.assertGreater(cnt, 500)
                _, _, boff = struct.unpack_from('<iiq', raw, 8)
                blen = struct.unpack_from('<q', raw, boff)[0]
                t0 = Image.open(io.BytesIO(raw[boff + 8 : boff + 8 + blen])).convert('RGBA')
                self.assertEqual(t0.size, (8, 8))

    def test_05_gallery_no_canvas_no_checkerboard(self) -> None:
        self.assertTrue(HTML.is_file())
        txt = HTML.read_text(encoding='utf-8')
        self.assertNotIn('<canvas', txt.lower())
        self.assertIn('#161b26', txt.lower())
        self.assertIn('cliff_north_metano.png', txt)
        self.assertIn('reseau_complet_13_salles_guilde.png', txt)


if __name__ == '__main__':
    unittest.main(verbosity=2)
