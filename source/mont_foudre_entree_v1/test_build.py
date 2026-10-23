#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mont_foudre_entree_v1` (`MFE1`, Mont Foudre — Entrée)."""

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

import source.mont_foudre_entree_v1.build as mfe_build  # type: ignore


class TestMontFoudreEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mont_foudre_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            mfe_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(mfe_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cutouts_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw[:150, :].sum()), 12_000, "Le ciel d'orage Nord doit être en #FF00FF sur le brut")
        self.assertGreater(int(mag_raw[320:, :].sum()), 4_000, "Les vasques d'eau doivent être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((np.minimum(r, b) - g) >= 40).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_fidelity_to_d06p01_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 22.0)

    def test_03_storm_sky_and_pools_actively_animated(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 10).sum()), 1_500, "Le ciel d'orage et les vasques H10P02 doivent s'animer")
        self.assertEqual(self.metrics["layers"][6]["poses"], 1)
        self.assertEqual(self.metrics["layers"][7]["poses"], 1)

    def test_04_continuous_south_to_north_canyon_walkgrid(self) -> None:
        _, walk_grid, _ = mfe_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 2_200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[22:26, 42:54].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "Le sentier Sud-Nord doit rejoindre le seuil de la grotte Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mfe_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "mont_foudre_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
