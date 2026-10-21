"""Suite de tests de validation stricte du pack Tentes & Huttes Forgelina (Style Arcanine Hut)."""
from __future__ import annotations

import io
import json
import struct
import unittest
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/forgelina_structures_pmdo_v1'
LIV = R / 'livrables_forgelina_pmdo'
HTML = R / 'apercu_tentes_huttes_forgelina_pmdo.html'


def decode_tile_bank_rgba(tile_path: Path, width: int, height: int) -> np.ndarray:
    """Décode binaire complet d'un fichier PMDO `.tile` et reconstruit l'image RGBA exacte."""
    blob = tile_path.read_bytes()
    tile_size, count = struct.unpack_from('<ii', blob, 0)
    assert tile_size == 8
    out = np.zeros((height, width, 4), dtype=np.uint8)
    for idx in range(count):
        gx, gy, off = struct.unpack_from('<iiq', blob, 8 + idx * 16)
        (plen,) = struct.unpack_from('<q', blob, off)
        png_data = blob[off + 8: off + 8 + plen]
        tile_arr = np.array(Image.open(io.BytesIO(png_data)).convert('RGBA'))
        assert tile_arr.shape == (8, 8, 4)
        out[gy * 8: gy * 8 + 8, gx * 8: gx * 8 + 8] = tile_arr
    return out


class TestForgelinaArcanineHuts(unittest.TestCase):
    def setUp(self):
        self.manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))

    def test_01_alpha_binary_and_zero_green_fringe(self):
        pngs = list((LIV / 'HD_sans_fond').glob('*.png')) + list((LIV / '1x_PMDO_8px_sans_fond').glob('*.png'))
        self.assertEqual(len(pngs), 46)
        for p in pngs:
            arr = np.array(Image.open(p).convert('RGBA'))
            uniques = set(np.unique(arr[:, :, 3]).tolist())
            self.assertTrue(uniques.issubset({0, 255}), f"Semi-transparent alpha in {p.name}: {uniques}")
            r = arr[:, :, 0].astype(np.int32)
            g = arr[:, :, 1].astype(np.int32)
            b = arr[:, :, 2].astype(np.int32)
            fringe = int(np.sum((arr[:, :, 3] == 255) & ((g - np.maximum(r, b)) > 18)))
            self.assertEqual(fringe, 0, f"Residual green fringe ({fringe} px) in {p.name}")

    def test_02_transparent_window_openings_and_disjoint_layer_splits(self):
        for it in self.manifest['items']:
            stem = it['file_stem']
            comp = np.array(Image.open(LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_complet.png').convert('RGBA'))
            self.assertEqual(comp.shape[0] % 8, 0)
            self.assertEqual(comp.shape[1] % 8, 0)

            if it['category'] == 'kiosque_boutique':
                fg = comp[:, :, 3] == 255
                holes = nd.binary_fill_holes(fg) & (~fg)
                self.assertGreater(
                    int(holes.sum()), 80,
                    f"Shop window interior must be true transparent alpha=0 in {stem}",
                )

            if it['normalization_1x']['split_mode'] is not None:
                under = np.array(Image.open(LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_arriere.png').convert('RGBA'))
                over = np.array(Image.open(LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_1x_avant.png').convert('RGBA'))
                overlap = int(np.sum((under[:, :, 3] == 255) & (over[:, :, 3] == 255)))
                self.assertEqual(overlap, 0, f"Overlap between arriere and avant in {stem}")
                rebuilt = np.where(over[:, :, 3:] == 255, over, under)
                np.testing.assert_array_equal(rebuilt, comp)

    def test_03_halcyon_tile_banks_pixel_exact_roundtrip(self):
        prefixes = set()
        for it in self.manifest['items']:
            pfx = it['bank_prefix']
            stem = it['file_stem']
            tw, th = it['normalization_1x']['canvas_size']
            self.assertEqual(len(pfx), 4)
            prefixes.add(pfx)
            for suf, png_suf in [('00_JOUR', '1x_complet.png'), ('01_NUIT', '1x_nuit_complet.png')]:
                tp = LIV / 'PMDO_tiles' / f'{pfx}_{suf}.tile'
                png_p = LIV / '1x_PMDO_8px_sans_fond' / f'{stem}_{png_suf}'
                expected = np.array(Image.open(png_p).convert('RGBA'))
                decoded = decode_tile_bank_rgba(tp, tw, th)
                np.testing.assert_array_equal(decoded, expected)
        self.assertEqual(len(prefixes), 8)

    def test_04_html_gallery_pure_img_no_canvas_no_checkerboard_and_honest_flags(self):
        self.assertFalse(self.manifest['art_approved'])
        self.assertFalse(self.manifest['runtime_tested'])
        self.assertFalse(self.manifest['spinda_motifs'])
        txt = HTML.read_text(encoding='utf-8')
        self.assertNotIn('<canvas', txt.lower())
        self.assertNotIn('repeating-conic-gradient', txt.lower())
        self.assertIn('data:image/png;base64,', txt)
        self.assertTrue((LIV / 'Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip').exists())


if __name__ == '__main__':
    unittest.main(verbosity=2)
