#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `silent_chasm_entree_v1` (`SCE1`, Gouffre Silencieux — Entrée D05P01)."""
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

import source.silent_chasm_entree_v1.build as sce_build  # type: ignore


class TestSilentChasmEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "silent_chasm_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            sce_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(sce_build.BRUT_PATH).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_sky_and_abyss_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 70_000)
        self.assertTrue((sce_build.HERE / "references" / "d05p01_silent_chasm_entry_native.png").is_file())
        self.assertTrue((sce_build.HERE / "references" / "d05p01_fog_parallax_native.png").is_file())
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 10.0)
        for sheet, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24_000, f"Banque trop lourde : {sheet}={count}")

    def test_03_sky_abyss_fog_animated_and_terrain_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 8).sum()), 25_000)
        for st_idx in (4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for an_idx in (0, 1, 2, 3, 8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)
        u = self.metrics["unique_tiles_per_sheet"]
        self.assertGreater([v for k, v in u.items() if "_03_" in k][0], 10)
        self.assertGreater([v for k, v in u.items() if "_08_" in k][0], 20)

    def test_04_continuous_south_ridge_to_cave_maw_walkgrid(self) -> None:
        _, walk_grid = sce_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        maw_ids = set(lbl[18:24, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & maw_ids), "L'éperon Sud doit rejoindre la gueule rocheuse Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = sce_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "silent_chasm_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
