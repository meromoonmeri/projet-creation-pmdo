#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mont_foudre_sommet_v1` (`MFA1`, Sommet — Cœur de la Tornade Noire Électrique de Zekrom)."""

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

import source.mont_foudre_sommet_v1.build as mfa_build  # type: ignore


class TestMontFoudreSommetV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mont_foudre_sommet_v1"
        if not (cls.renders / "metadata.json").is_file():
            mfa_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(mfa_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_360_tornado_surround_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 180_000, "Toute la zone cyclonique 360° autour du pic central doit être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((r >= 240) & (g <= 15) & (b >= 240)).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_ultra_high_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 12.0)

    def test_03_black_electric_tornado_rotates_360_and_spires_strictly_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 12).sum()), 5_000, "La tornade de nuages noirs électriques de Zekrom doit tourner sur 360°")
        self.assertEqual(self.metrics["layers"][4]["poses"], 1)
        self.assertEqual(self.metrics["layers"][5]["poses"], 1)
        self.assertEqual(self.metrics["layers"][6]["poses"], 1)

    def test_04_continuous_south_exit_to_central_zekrom_peak_walkgrid(self) -> None:
        _, walk_grid = mfa_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_000)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        center_ids = set(lbl[20:28, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & center_ids), "La crête Sud-Nord issue de la grotte doit rejoindre l'autel central de Zekrom")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mfa_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "mont_foudre_sommet_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
