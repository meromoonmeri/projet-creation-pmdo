#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mont_lointain_sommet_v1` (`MLS1`, Sommet du Mont Lointain `B72` `1:1`)."""

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
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(mls_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cutout_brut_and_pastel_zero_black_outline(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw.sum()), 180_000, "Le ciel, la mer de nuages & les arcs-en-ciel doivent être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((np.minimum(r, b) - g) >= 40).sum()), 0, f"Fuite magenta sur pose {idx}")
            self.assertEqual(int((pose[:, :, :3].max(axis=2) < 95).sum()), 0, "Zéro contour noir dur sur MLS1 B72")

    def test_02_ultra_high_fidelity_to_b72_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 9.5)

    def test_03_b72_cloud_sea_and_h05p02_rainbows_animated(self) -> None:
        mag_zone = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_zone] > 6).sum()), 3_000, "La mer de nuages & les arcs-en-ciel H05P02 doivent s'animer")

    def test_04_wide_hooh_boss_arena_walkgrid(self) -> None:
        _, walk_grid, _ = mls_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_300)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        center_ids = set(lbl[28:46, 40:56].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & center_ids), "L'escalier Sud doit relier y=71 au vaste plateau central de Ho-Oh")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mls_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "mont_lointain_sommet_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
