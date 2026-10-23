#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mer_houleuse_sanctuaire_v1` (`MHA1`, Sanctuaire de Kyogre)."""

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

import source.mer_houleuse_sanctuaire_v1.build as mha_build  # type: ignore


class TestMerHouleuseSanctuaireV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mer_houleuse_sanctuaire_v1"
        if not (cls.renders / "metadata.json").is_file():
            mha_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(mha_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_lagoon_cutout_on_brut_and_zero_ff00ff_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw.sum()), 25_000, "Le lagon abyssal de Kyogre doit être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0], pose[:, :, 1], pose[:, :, 2], pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            ff00ff_leak = (r >= 220) & (g <= 35) & (b >= 220)
            self.assertEqual(int(ff00ff_leak.sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_ultra_high_fidelity_to_h02p03_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 14.0)

    def test_03_water_and_runes_animated_and_crystals_strictly_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 10).sum()), 4_000, "Le lagon H10P02/H02P02W doit s'animer")
        # Les cristaux cyan du sanctuaire DOIVENT être 100 % statiques (`poses == 1`) !
        self.assertEqual(self.metrics["layers"][5]["poses"], 1)
        self.assertEqual(self.metrics["layers"][6]["poses"], 1)

    def test_04_continuous_south_to_kyogre_medallion_walkgrid(self) -> None:
        _, walk_grid, _ = mha_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        medallion_ids = set(lbl[20:26, 45:51].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & medallion_ids), "La chaussée runique doit rejoindre le Médaillon de Kyogre")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mha_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "mer_houleuse_sanctuaire_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
