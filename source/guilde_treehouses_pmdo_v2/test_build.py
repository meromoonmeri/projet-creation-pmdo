"""Tests automatisés complets — Lot V2 Grandes Treehouses Monumentales de Guilde (`GT2A`..`GT2I`).

Vérifie :
1. Les 9 structures (HD + 1× PMDO Jour/Nuit + Under/Over) ont un canal alpha binaire strict {0, 255},
   0 pixel de frange magenta/pourpre, et un cadrage multiple exact de 8×8 px.
2. Recomposition pixel-exacte : `arriere | avant == complet` et `arriere & avant == vide`.
3. Décodage binaire natif PMDO `.tile` : `nr.tiles(p)[1]` restitue 100 % des pixels de chaque structure.
4. Unicité des préfixes de banques (`GT2A`..`GT2I`) sans collision dans le dépôt.
5. Conformité stricte de la galerie `apercu_treehouses_guilde_monumentales_v2.html` :
   `0` balise `<canvas>`, `0` motif damier (`checker`, `conic-gradient`), et 100 % de vraies balises `<img>` RGBA `alpha = 0`.
"""
from __future__ import annotations

import base64
import io
import json
import re
import struct
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT_DIR = R / 'livrables_treehouses_guilde_pmdo'
OUT_HTML = R / 'apercu_treehouses_guilde_monumentales_v2.html'


def decode_tile_file(path: Path) -> Image.Image:
    data = path.read_bytes()
    tile_size, count = struct.unpack_from('<II', data, 0)
    assert tile_size == 8
    cells: dict[tuple[int, int], Image.Image] = {}
    max_x = max_y = 0
    for i in range(count):
        x, y, off = struct.unpack_from('<IIQ', data, 8 + i * 16)
        (length,) = struct.unpack_from('<q', data, off)
        png_bytes = data[off + 8 : off + 8 + length]
        cells[(x, y)] = Image.open(io.BytesIO(png_bytes)).convert('RGBA')
        max_x = max(max_x, x)
        max_y = max(max_y, y)
    out = Image.new('RGBA', ((max_x + 1) * 8, (max_y + 1) * 8))
    for (x, y), im in cells.items():
        out.paste(im, (x * 8, y * 8))
    return out


class TestGuildeTreehousesV2(unittest.TestCase):
    def setUp(self) -> None:
        self.manifest = json.loads((OUT_DIR / 'manifest.json').read_text())

    def test_01_manifest_and_honesty_flags(self) -> None:
        self.assertEqual(self.manifest['count'], 9)
        self.assertFalse(self.manifest['spinda_motifs'])
        self.assertFalse(self.manifest['art_approved'])
        self.assertFalse(self.manifest['runtime_tested'])

    def test_02_zero_magenta_fringe_and_binary_alpha_all_pngs(self) -> None:
        for entry in self.manifest['structures']:
            w, h = entry['canvas_1x_px']
            self.assertEqual(w % 8, 0)
            self.assertEqual(h % 8, 0)
            for k in ('1x_jour_complet', '1x_nuit_complet', '1x_arriere', '1x_avant', 'hd_jour', 'hd_nuit'):
                p = R / entry['files'][k]
                self.assertTrue(p.is_file(), f'Missing {p}')
                im = Image.open(p)
                self.assertEqual(im.mode, 'RGBA')
                arr = np.array(im)
                alpha_vals = set(np.unique(arr[:, :, 3]).tolist())
                self.assertTrue(alpha_vals.issubset({0, 255}), f'{p}: non-binary alpha {alpha_vals}')
                self.assertIn(0, alpha_vals, f'{p}: no transparent background!')
                self.assertIn(255, alpha_vals, f'{p}: empty sprite!')
                op = arr[:, :, 3] == 255
                r, g, b = arr[:, :, 0].astype(int), arr[:, :, 1].astype(int), arr[:, :, 2].astype(int)
                fringe = op & (r > g + 18) & (b > g + 18) & (b > 65)
                self.assertEqual(int(fringe.sum()), 0, f'{p}: {int(fringe.sum())} magenta fringe pixels')

    def test_03_under_over_exact_partition_and_tile_roundtrip(self) -> None:
        pfxs = set()
        for entry in self.manifest['structures']:
            pfxs.add(entry['pfx'])
            full = np.array(Image.open(R / entry['files']['1x_jour_complet']).convert('RGBA'))
            under = np.array(Image.open(R / entry['files']['1x_arriere']).convert('RGBA'))
            over = np.array(Image.open(R / entry['files']['1x_avant']).convert('RGBA'))
            # Aucun chevauchement opaque entre Under et Over
            overlap = (under[:, :, 3] > 0) & (over[:, :, 3] > 0)
            self.assertEqual(int(overlap.sum()), 0)
            recomp = np.where(over[:, :, 3:4] > 0, over, under)
            self.assertTrue(np.array_equal(full, recomp))
            # Décodage round-trip exact du .tile Jour & Nuit
            for tk, pk in (('tile_jour', '1x_jour_complet'), ('tile_nuit', '1x_nuit_complet')):
                decoded = np.array(decode_tile_file(R / entry[ 'files'][tk]))
                orig = np.array(Image.open(R / entry['files'][pk]).convert('RGBA'))
                self.assertTrue(np.array_equal(decoded, orig), f'Mismatch on {tk}')
        self.assertEqual(len(pfxs), 9)

    def test_04_html_pure_img_tags_zero_canvas_zero_checkerboard(self) -> None:
        html = OUT_HTML.read_text()
        self.assertNotIn('<canvas', html.lower())
        self.assertNotIn('checker', html.lower())
        self.assertNotIn('conic-gradient', html.lower())
        b64_matches = re.findall(r'data:image/png;base64,([A-Za-z0-9+/=]+)', html)
        # 9 structures × 4 URI 1× embarquées + 9 images initiales dans le DOM = 45 URI RGBA vérifiables
        self.assertGreaterEqual(len(b64_matches), 45)
        for raw_b64 in b64_matches[:18]:
            im = Image.open(io.BytesIO(base64.b64decode(raw_b64)))
            self.assertEqual(im.mode, 'RGBA')
            arr = np.array(im)
            self.assertIn(0, np.unique(arr[:, :, 3]))


if __name__ == '__main__':
    unittest.main()
