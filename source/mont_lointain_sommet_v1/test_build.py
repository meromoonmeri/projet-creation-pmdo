#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mont_lointain_sommet_v1` (`MLS1`, Sommet de Ho-Oh `b72`)."""

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

import source.mont_lointain_sommet_v1.build as mls_build  # type: ignore


class TestMontLointainSommetV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mont_lointain_sommet_v1"
        if not (cls.renders / "metadata.json").is_file():
            mls_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose6 = np.asarray(Image.open(cls.renders / "frames" / "frame_06.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_zero_magenta_and_zero_black_all_frames(self) -> None:
        for idx, pose in enumerate((self.pose0, self.pose6, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            mag_bleed = (np.minimum(r, b) - g) >= 40
            self.assertEqual(int(mag_bleed.sum()), 0)
            pure_black = pose[:, :, :3].max(axis=2) < 95
            self.assertEqual(int(pure_black.sum()), 0, f"Pixels noirs sur pose {idx}: {int(pure_black.sum())}")

    def test_02_canonical_b72_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        # Très haute fidélité à la référence `b72_mt_faraway_hooh.png` !
        self.assertLess(self.metrics["fidelity_distance"], 22.0)

    def test_03_active_cloud_rainbow_and_feather_animations(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose6[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 6).sum()), 2_500)

    def test_04_south_stair_continuous_to_hooh_plateau(self) -> None:
        _, walk_grid, _ = mls_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        center_ids = set(lbl[30:40, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & center_ids), "L'escalier Sud doit rejoindre le plateau sacré de Ho-Oh")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mls_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        for p in (REPO_ROOT / "source" / "mont_lointain_sommet_v1" / "build.py", REPO_ROOT / "index.html"):
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
