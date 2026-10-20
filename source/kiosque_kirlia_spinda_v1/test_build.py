"""Tests dédiés — Kiosque Kirlia pour Café Spinda (KKR1)."""
import hashlib, importlib.util, json, unittest
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/kiosque_kirlia_spinda_v1'
STAGE = R / '.cache/kiosque_kirlia_spinda_v1/kiosque_kirlia_spinda'
PFX = 'KKR1'


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestKiosqueKirlia(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.b = loadmod('kkr1_build', HERE / 'build.py')

    def test_manifest_and_hashes(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        for it in m['raw_inputs'] + m['references']:
            p = R / it['file']
            self.assertTrue(p.exists(), p)
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'])

    def test_zero_magenta_zero_fringe_and_transparent_guichet_window(self):
        hd = rgba(OUT / 'hd/Kiosque_Kirlia_HD_sans_magenta.png')
        self.assertEqual(hd.shape[:2], (1024, 1024))
        self.assertTrue(set(np.unique(hd[..., 3])) <= {0, 255})
        # Zéro pixel #FF00FF et zéro frange pourpre/lavande jusqu'à 18 px des contours (extérieurs + guichet)
        self.assertEqual(int(self.b.is_purple_fringe(hd, max_dist=18.0).sum()), 0)

        # Contrôle par mutation : l'injection d'un seul pixel lavande ou #FF00FF au bord réel est détectée
        mutated = hd.copy()
        by, bx = np.argwhere((hd[..., 3] == 255) & (nd.distance_transform_edt(hd[..., 3] == 255) <= 2.0))[0]
        mutated[by, bx] = [184, 166, 208, 255]
        self.assertGreater(int(self.b.is_purple_fringe(mutated, max_dist=18.0).sum()), 0)

        # Le guichet central est 100 % transparent (alpha == 0) et sans bloc noir résiduel
        op = hd[..., 3] == 255
        holes = nd.binary_fill_holes(op) & (~op)
        lh, nh = nd.label(holes)
        areas = sorted([int((lh == i).sum()) for i in range(1, nh + 1)], reverse=True)
        self.assertGreater(areas[0], 60000, 'Le guichet central doit être entièrement transparent')

        # Le panneau avant du comptoir bois est uniforme (aucune feuille verte résiduelle au centre)
        counter_panel = hd[800:930, 380:645]
        op_c = counter_panel[..., 3] == 255
        self.assertGreater(int(op_c.sum()), 20000)
        green_leaf_px = op_c & (counter_panel[..., 1].astype(int) > counter_panel[..., 0].astype(int) + 12)
        self.assertEqual(int(green_leaf_px.sum()), 0, 'Feuille verte encore présente sur le comptoir')

    def test_1x_split_night_and_8px_alignment(self):
        comp = rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_complet.png')
        back = rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_arriere.png')
        front = rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_avant.png')
        night = rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_nuit_complet.png')

        for arr in (comp, back, front, night):
            self.assertEqual(arr.shape[:2], (120, 112))
            self.assertEqual(arr.shape[0] % 8, 0)
            self.assertEqual(arr.shape[1] % 8, 0)
            self.assertTrue(set(np.unique(arr[..., 3])) <= {0, 255})
            self.assertEqual(int(self.b.is_purple_fringe(arr, max_dist=2.0).sum()), 0)

        # Partition stricte : arriere et avant disjoints et leur union recompose exactement complet
        self.assertFalse(bool(((back[..., 3] > 0) & (front[..., 3] > 0)).any()))
        recomp = np.where(front[..., 3:4] > 0, front, back)
        self.assertTrue(np.array_equal(recomp, comp))

        # Ouverture transparente du guichet préservée à l'échelle 1x
        op1 = comp[..., 3] == 255
        holes1 = nd.binary_fill_holes(op1) & (~op1)
        self.assertGreater(int(holes1.sum()), 400)

        # Mode nuit V8 garde exactement la même silhouette alpha
        self.assertTrue(np.array_equal(comp[..., 3], night[..., 3]))

    def test_tilesheets_and_binary_tile_roundtrip(self):
        nr = loadmod('native_reader_kkr1', R / 'source/cote_v5_expeditions/audit_references.py')
        tools = loadmod('index_tools_kkr1_t', R / 'source/pmdo_cote/INSTALLER.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(self.m['pmdo']['tiles_per_bank']))
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(banks))

        checks = [
            ('KKR1_00_ARRIERE', rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_arriere.png')),
            ('KKR1_01_AVANT', rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_avant.png')),
            ('KKR1_02_COMPLET', rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_complet.png')),
            ('KKR1_03_NUIT', rgba(OUT / 'assets_1x/Kiosque_Kirlia_1x_nuit_complet.png')),
        ]
        for bname, target in checks:
            rec = np.zeros_like(target)
            for (gx, gy), tile_im in banks[bname].items():
                rec[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8] = np.array(nr.straight(tile_im))
            self.assertTrue(np.array_equal(rec, target), bname)


if __name__ == '__main__':
    unittest.main()
