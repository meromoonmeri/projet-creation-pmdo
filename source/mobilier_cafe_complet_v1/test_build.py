"""Tests dédiés — Collection Complète Mobilier Café & Estrade Rideaux Rouges sans fond (KMC1)."""
import hashlib, importlib.util, json, unittest
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/mobilier_cafe_complet_v1'
STAGE = R / '.cache/mobilier_cafe_complet_v1/mobilier_cafe_complet'


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestMobilierCafeComplet(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.b = loadmod('kmc1_build', HERE / 'build.py')

    def test_manifest_and_hashes(self):
        m = self.m
        self.assertEqual(m['prefix'], 'KMC1')
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(len(m['objects']), 7)
        for o in m['objects']:
            self.assertEqual(hashlib.sha256((R / o['raw_file']).read_bytes()).hexdigest(), o['raw_sha256'])

    def test_all_7_hd_sans_fond_and_mutation(self):
        for o in self.m['objects']:
            hd = rgba(OUT / o['hd_sans_fond'])
            self.assertEqual(set(np.unique(hd[..., 3])), {0, 255}, o['id'])
            for cy, cx in [(0, 0), (0, -1), (-1, 0), (-1, -1)]:
                self.assertEqual(int(hd[cy, cx, 3]), 0, o['id'])
            self.assertEqual(int(self.b.boundary_magenta_fringe(hd, max_dist=6.0).sum()), 0, o['id'])

            mut = hd.copy()
            by, bx = np.argwhere((hd[..., 3] == 255) & (nd.distance_transform_edt(hd[..., 3] == 255) <= 2.0))[0]
            mut[by, bx] = [215, 95, 205, 255]
            self.assertGreater(int(self.b.boundary_magenta_fringe(mut, max_dist=6.0).sum()), 0)

    def test_all_1x_grids_splits_and_night_variants(self):
        for o in self.m['objects']:
            stem = o['file_stem']
            comp = rgba(OUT / f'assets_1x/{stem}_1x_complet.png')
            night = rgba(OUT / f'assets_1x/{stem}_1x_nuit_complet.png')
            self.assertEqual(comp.shape[0] % 8, 0)
            self.assertEqual(comp.shape[1] % 8, 0)
            self.assertEqual(int(self.b.boundary_magenta_fringe(comp, max_dist=2.2).sum()), 0, o['id'])
            self.assertTrue(np.array_equal(comp[..., 3], night[..., 3]))
            if o['normalization_1x']['split_mode'] is not None:
                back = rgba(OUT / f'assets_1x/{stem}_1x_arriere.png')
                front = rgba(OUT / f'assets_1x/{stem}_1x_avant.png')
                self.assertFalse(bool(((back[..., 3] > 0) & (front[..., 3] > 0)).any()))
                recomp = np.where(front[..., 3:4] > 0, front, back)
                self.assertTrue(np.array_equal(recomp, comp), o['id'])

    def test_binary_tile_roundtrip_all_14_banks(self):
        nr = loadmod('native_reader_kmc1', R / 'source/cote_v5_expeditions/audit_references.py')
        tools = loadmod('index_tools_kmc1_t', R / 'source/pmdo_cote/INSTALLER.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(len(banks), 14)
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(banks))

        for bname, fn in [
            ('KKB1_02_COMPLET', 'assets_1x/Kirlia_Comptoir_1x_complet.png'),
            ('KCM1_02_COMPLET', 'assets_1x/Charmilly_Comptoir_1x_complet.png'),
            ('EST1_02_COMPLET', 'assets_1x/Estrade_Rideaux_Rouges_1x_complet.png'),
            ('ACC1_00_JOUR', 'tilesheets/Tilesheet_Accessoires_Cabaret_Jour_1x.png'),
            ('ACC1_01_NUIT', 'tilesheets/Tilesheet_Accessoires_Cabaret_Nuit_1x.png'),
        ]:
            target = rgba(OUT / fn)
            rec = np.zeros_like(target)
            for (gx, gy), tile_im in banks[bname].items():
                rec[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8] = np.array(nr.straight(tile_im))
            self.assertTrue(np.array_equal(rec, target), bname)


if __name__ == '__main__':
    unittest.main()
