#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `sinister_woods_entree_v1` (`SWE1`, Bois Sinistre — Entrée D04P01)."""
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[2]
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

import source.sinister_woods_entree_v1.build as swe_build  # type: ignore


class TestSinisterWoodsEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "sinister_woods_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            swe_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(swe_build.BRUT_PATH).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_sky_and_creek_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 30_000)
        self.assertTrue((swe_build.HERE / "references" / "d04p01_sinister_woods_entry_native.png").is_file())
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 10.0)
        for sheet, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24_000, f"Banque trop lourde : {sheet}={count}")

    def test_03_wastewater_creek_low_opacity_toxic_mist_wisps_and_zero_spectral_mist(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        yy = np.arange(self.raw.shape[0])[:, None]
        wat_m = mag_raw & (yy >= 96)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[wat_m] > 4).sum()), 3_000)
        # Eau couleur "eau usée" trouble (olive-vase, 0 pixel cyan vif 131,218,230)
        cyan_px = (self.pose0[wat_m, 0] == 131) & (self.pose0[wat_m, 1] == 218) & (self.pose0[wat_m, 2] == 230)
        self.assertEqual(int(cyan_px.sum()), 0)
        r_w, g_w, b_w = self.pose0[wat_m, 0].astype(int), self.pose0[wat_m, 1].astype(int), self.pose0[wat_m, 2].astype(int)
        ww_px = (g_w >= r_w) & (r_w >= b_w + 18) & (g_w <= 145) & (b_w <= 80)
        self.assertGreater(int(ww_px.sum()), 18_000)
        # ZÉRO brume spectrale cyan dans les percées de ciel Nord (sky_m)
        sky_m = mag_raw & (yy < 96)
        r_n, g_n, b_n = self.pose0[sky_m, 0].astype(int), self.pose0[sky_m, 1].astype(int), self.pose0[sky_m, 2].astype(int)
        self.assertEqual(int(((b_n > r_n + 65) & (g_n >= 135)).sum()), 0)
        for st_idx in (0, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        self.assertEqual(self.metrics["layers"][1]["poses"], 48)
        for an_idx in (2, 3, 8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)
        u = self.metrics["unique_tiles_per_sheet"]
        self.assertGreater([v for k, v in u.items() if "_01_" in k][0], 40)
        self.assertGreater([v for k, v in u.items() if "_03_" in k][0], 6)
        self.assertGreater([v for k, v in u.items() if "_09_" in k][0], 80)

    def test_04_continuous_south_over_bridge_to_dark_portal_walkgrid(self) -> None:
        _, walk_grid = swe_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        portal_ids = set(lbl[18:24, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & portal_ids), "Le sentier mousseux Sud doit franchir le pont jusqu'au tunnel Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = swe_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "sinister_woods_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
