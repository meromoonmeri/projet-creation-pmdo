#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `foret_givree_entree_v1` (`FGE1`, Forêt Givrée — Entrée `D10P01` `1×`)."""

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

import source.foret_givree_entree_v1.build as fge_build  # type: ignore


class TestForetGivreeEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "foret_givree_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            fge_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(fge_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cutout_brut_and_zero_magenta_leak_in_renders(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw[:250, :].sum()), 80_000, "Le ciel d'hiver D10P01 doit être en #FF00FF sur le brut")
        self.assertGreater(int(mag_raw[300:, :].sum()), 15_000, "Les plaques de glace vive D10P01 doivent être en #FF00FF sur le brut")
        # ZÉRO rivière bleue factice inventée (`R < 40 & B > 220` absent de D10P01)
        fake_blue_river = (self.pose0[:, :, 0] < 40) & (self.pose0[:, :, 2] > 210)
        self.assertEqual(int(fake_blue_river.sum()), 0, "Zéro rivière bleue non canonique sur D10P01")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((np.minimum(r, b) - g) >= 40).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_native_fidelity_to_d10p01_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 4.0)

    def test_03_canonical_w03p03_snow_and_ice_glint_animation(self) -> None:
        ice_zone = (self.raw[300:, :, 0] == 255) & (self.raw[300:, :, 1] == 0) & (self.raw[300:, :, 2] == 255)
        diff = np.abs(self.pose0[300:, :, :3].astype(int) - self.pose12[300:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[ice_zone] > 12).sum()), 1_500, "Les plaques de glace vive & flocons W03P03 doivent s'animer")

    def test_04_continuous_south_to_north_snow_path(self) -> None:
        _, walk_grid, _ = fge_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[32:38, 38:58].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "Le sentier Sud-Nord doit relier y=71 au seuil Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = fge_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "foret_givree_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
