#!/usr/bin/env python3
"""Suite de validation automatisée (4 tests) — Pack Spinda Café × Dojo Makuhita PMDO."""

from __future__ import annotations

import io
import json
import struct
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUT_DIR = ROOT / "livrables_spinda_cafe_dojo_pmdo"
MANIFEST = OUT_DIR / "manifest.json"
HTML_PREVIEW = ROOT / "apercu_spinda_cafe_dojo_pmdo.html"


def decode_halcyon_tile_bank(path: Path, size_wh: tuple[int, int]) -> np.ndarray:
    blob = path.read_bytes()
    tile_size, count = struct.unpack_from("<ii", blob, 0)
    assert tile_size == 8, f"tile_size inattendu: {tile_size}"
    w, h = size_wh
    canvas = np.zeros((h, w, 4), dtype=np.uint8)
    for idx in range(count):
        gx, gy, off = struct.unpack_from("<iiq", blob, 8 + idx * 16)
        (plen,) = struct.unpack_from("<q", blob, off)
        png_data = blob[off + 8 : off + 8 + plen]
        tile_arr = np.array(Image.open(io.BytesIO(png_data)).convert("RGBA"), dtype=np.uint8)
        assert tile_arr.shape == (8, 8, 4)
        canvas[gy * 8 : gy * 8 + 8, gx * 8 : gx * 8 + 8] = tile_arr
    return canvas


class TestSpindaCafeDojoPMDO(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))

    def test_01_alpha_strictement_binaire_et_dimensions_8px(self) -> None:
        self.assertEqual(len(self.manifest["assets"]), 6)
        self.assertTrue(self.manifest["no_front_signboard"])
        self.assertTrue(self.manifest["no_entrance_lantern"])
        self.assertFalse(self.manifest["art_approved"])
        self.assertFalse(self.manifest["runtime_tested"])
        for asset in self.manifest["assets"]:
            for key in ("hd_png", "day_1x_png", "night_1x_png", "under_1x_png", "base_1x_png"):
                im = Image.open(ROOT / asset[key]).convert("RGBA")
                alphas = set(np.unique(np.array(im)[:, :, 3]).tolist())
                self.assertTrue(alphas.issubset({0, 255}), f"Alpha non binaire {alphas} dans {asset[key]}")
                if key != "hd_png":
                    self.assertEqual(im.width % 8, 0, asset[key])
                    self.assertEqual(im.height % 8, 0, asset[key])

    def test_02_zero_frange_verte_sur_tous_les_exports(self) -> None:
        for asset in self.manifest["assets"]:
            for key in ("hd_png", "day_1x_png", "night_1x_png"):
                arr = np.array(Image.open(ROOT / asset[key]).convert("RGBA"), dtype=np.int16)
                opaque = arr[:, :, 3] == 255
                r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
                trans = ~opaque
                ring = (
                    np.pad(trans[1:, :], ((0, 1), (0, 0)), constant_values=True)
                    | np.pad(trans[:-1, :], ((1, 0), (0, 0)), constant_values=True)
                    | np.pad(trans[:, 1:], ((0, 0), (0, 1)), constant_values=True)
                    | np.pad(trans[:, :-1], ((0, 0), (1, 0)), constant_values=True)
                ) & opaque
                rim_fringe = int(np.sum(ring & ((g - np.maximum(r, b)) > 8)))
                self.assertEqual(rim_fringe, 0, f"Frange verte sur contour détectée ({rim_fringe} px) dans {asset[key]}")
                if not asset["has_green_props"]:
                    global_green = int(np.sum(opaque & ((g - np.maximum(r, b)) > 8)))
                    self.assertEqual(global_green, 0, f"Pixel vert résiduel ({global_green} px) dans {asset[key]}")

    def test_03_exactitude_binaire_tile_halcyon_et_unicite_prefixes(self) -> None:
        prefixes = [a["prefix"] for a in self.manifest["assets"]]
        self.assertEqual(len(prefixes), len(set(prefixes)))
        for p in prefixes:
            self.assertEqual(len(p), 4)
            self.assertTrue(p.startswith("SPC"))
        for asset in self.manifest["assets"]:
            for b_key, p_key in (("tile_bank", "day_1x_png"), ("tile_bank_nuit", "night_1x_png")):
                ref_arr = np.array(Image.open(ROOT / asset[p_key]).convert("RGBA"), dtype=np.uint8)
                rebuilt = decode_halcyon_tile_bank(ROOT / asset[b_key], (ref_arr.shape[1], ref_arr.shape[0]))
                self.assertTrue(np.array_equal(ref_arr, rebuilt), f"Écart pixel PNG vs .tile sur {asset['prefix']}")

    def test_04_galerie_html_sans_canvas_ni_damier(self) -> None:
        html = HTML_PREVIEW.read_text(encoding="utf-8")
        self.assertNotIn("<canvas", html.lower())
        self.assertNotIn("repeating-conic-gradient", html.lower())
        self.assertGreaterEqual(html.count('src="data:image/png;base64,'), 14)


if __name__ == "__main__":
    unittest.main(verbosity=2)
