"""Tests dédiés — Trio de comptoirs/kiosques Spinda, Qulbutoké & Sucreine sans fond (KTR1)."""
import hashlib, importlib.util, json, unittest
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/kiosques_spinda_trio_v1'
STAGE = R / '.cache/kiosques_spinda_trio_v1/kiosques_cafe_spinda_trio'


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestKiosquesSpindaTrio(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.b = loadmod('ktr1_build', HERE / 'build.py')

    def test_manifest_and_provenance_hashes(self):
        m = self.m
        self.assertEqual(m['prefix'], 'KTR1')
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual([o['id'] for o in m['objects']], ['spinda', 'qulbutoke', 'sucreine'])
        for o in m['objects']:
            self.assertEqual(hashlib.sha256((R / o['raw_file']).read_bytes()).hexdigest(), o['raw_sha256'])
            self.assertEqual(hashlib.sha256((R / o['portrait_ref']).read_bytes()).hexdigest(), o['portrait_ref_sha256'])

    def test_hd_sans_fond_zero_magenta_and_mutation(self):
        for o in self.m['objects']:
            hd = rgba(OUT / o['hd_sans_fond'])
            self.assertTrue(set(np.unique(hd[..., 3])) == {0, 255}, o['id'])
            # Aucun fond résiduel aux 4 coins et 0 px de frange magenta/pourpre sur tous les contours
            for cy, cx in [(0, 0), (0, -1), (-1, 0), (-1, -1)]:
                self.assertEqual(int(hd[cy, cx, 3]), 0, f"{o['id']} coin non transparent")
            self.assertEqual(int(self.b.boundary_magenta_fringe(hd, max_dist=6.0).sum()), 0, o['id'])

            # Contrôle réel par mutation : 1 pixel magenta/lavande sur le contour est détecté
            mut = hd.copy()
            by, bx = np.argwhere((hd[..., 3] == 255) & (nd.distance_transform_edt(hd[..., 3] == 255) <= 2.0))[0]
            mut[by, bx] = [215, 95, 205, 255]
            self.assertGreater(int(self.b.boundary_magenta_fringe(mut, max_dist=6.0).sum()), 0)

    def test_1x_split_night_and_8px_grid(self):
        for o in self.m['objects']:
            Cap = o['id'].capitalize()
            comp = rgba(OUT / f'assets_1x/{Cap}_Comptoir_1x_complet.png')
            back = rgba(OUT / f'assets_1x/{Cap}_Comptoir_1x_arriere.png')
            front = rgba(OUT / f'assets_1x/{Cap}_Comptoir_1x_avant.png')
            night = rgba(OUT / f'assets_1x/{Cap}_Comptoir_1x_nuit_complet.png')

            for arr in (comp, back, front, night):
                self.assertEqual(arr.shape[1], 144)
                self.assertEqual(arr.shape[0] % 8, 0)
                self.assertTrue(set(np.unique(arr[..., 3])) <= {0, 255})

            self.assertEqual(int(self.b.boundary_magenta_fringe(comp, max_dist=2.2).sum()), 0, o['id'])
            self.assertFalse(bool(((back[..., 3] > 0) & (front[..., 3] > 0)).any()))
            recomp = np.where(front[..., 3:4] > 0, front, back)
            self.assertTrue(np.array_equal(recomp, comp), o['id'])
            self.assertTrue(np.array_equal(comp[..., 3], night[..., 3]), o['id'])

    def test_binary_tile_roundtrip_all_12_banks(self):
        nr = loadmod('native_reader_ktr1', R / 'source/cote_v5_expeditions/audit_references.py')
        tools = loadmod('index_tools_ktr1_t', R / 'source/pmdo_cote/INSTALLER.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(len(banks), 12)
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(banks))

        for o in self.m['objects']:
            Cap = o['id'].capitalize()
            pfx = o['prefix']
            for bname, fn in [
                (f'{pfx}_00_ARRIERE', f'assets_1x/{Cap}_Comptoir_1x_arriere.png'),
                (f'{pfx}_01_AVANT', f'assets_1x/{Cap}_Comptoir_1x_avant.png'),
                (f'{pfx}_02_COMPLET', f'assets_1x/{Cap}_Comptoir_1x_complet.png'),
                (f'{pfx}_03_NUIT', f'assets_1x/{Cap}_Comptoir_1x_nuit_complet.png'),
            ]:
                target = rgba(OUT / fn)
                rec = np.zeros_like(target)
                for (gx, gy), tile_im in banks[bname].items():
                    rec[gy * 8:gy * 8 + 8, gx * 8:gx * 8 + 8] = np.array(nr.straight(tile_im))
                self.assertTrue(np.array_equal(rec, target), bname)


if __name__ == '__main__':
    unittest.main()
