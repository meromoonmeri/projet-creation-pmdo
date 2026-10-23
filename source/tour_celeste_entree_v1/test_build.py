#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `tour_celeste_entree_v1` (`TCE1`, Tour Céleste — Entrée)."""

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

import source.tour_celeste_entree_v1.build as tce_build  # type: ignore


class TestTourCelesteEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "tour_celeste_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            tce_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(tce_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_sky_corridors_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 90_000, "Les couloirs de tornades doivent être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((r >= 240) & (g <= 15) & (b >= 240)).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_ultra_high_fidelity_to_reference_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 14.0)

    def test_03_both_left_and_right_tornadoes_spin_smoothly_and_clouds_static(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[:, :220] > 16).sum()), 12_000, "La tornade gauche doit tourner activement sur son axe")
        self.assertGreater(int((diff[:, 548:] > 16).sum()), 12_000, "La tornade droite doit tourner activement sur son axe")
        self.assertEqual(self.metrics["layers"][2]["poses"], 1)
        self.assertEqual(self.metrics["layers"][5]["poses"], 1)
        self.assertEqual(self.metrics["layers"][7]["poses"], 1)

    def test_04_continuous_south_to_north_cloud_path_walkgrid(self) -> None:
        _, walk_grid = tce_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        portal_ids = set(lbl[14:22, 43:53].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & portal_ids), "Le chemin de nuage Sud-Nord doit rejoindre le portail Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = tce_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "tour_celeste_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
