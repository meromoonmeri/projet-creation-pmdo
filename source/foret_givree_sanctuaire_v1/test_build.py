#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `foret_givree_sanctuaire_v1` (`FGA1`, Sanctuaire d'Artikodin)."""

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

import source.foret_givree_sanctuaire_v1.build as fga_build  # type: ignore


class TestForetGivreeSanctuaireV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "foret_givree_sanctuaire_v1"
        if not (cls.renders / "metadata.json").is_file():
            fga_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(fga_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cutout_brut_and_zero_magenta_leak_in_renders(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw[340:, :].sum()), 6_000, "Les vasques & cascades doivent être en #FF00FF sur le brut")
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((np.minimum(r, b) - g) >= 40).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_fidelity_to_h24p01_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 12.0)

    def test_03_waterfalls_animated_and_ice_totems_strictly_static(self) -> None:
        water_zone = (self.raw[340:, :, 0] == 255) & (self.raw[340:, :, 1] == 0) & (self.raw[340:, :, 2] == 255)
        diff = np.abs(self.pose0[340:, :, :3].astype(int) - self.pose12[340:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[water_zone] > 12).sum()), 500, "Les vasques & cascades H10P02 doivent s'animer")
        # Vérifie que la couche 07 (Trône de Glace, totems-flocons & cristaux) est 100 % statique (`poses == 1`)
        layer_07 = self.metrics["layers"][7]
        self.assertEqual(layer_07["poses"], 1)

    def test_04_continuous_south_to_snowflake_medallion_walkgrid(self) -> None:
        _, walk_grid, _ = fga_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 2_000)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        medallion_ids = set(lbl[33:38, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & medallion_ids), "Le chemin Sud-Nord doit rejoindre le Médaillon Flocon central")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = fga_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "foret_givree_sanctuaire_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
