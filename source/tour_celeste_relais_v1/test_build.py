#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `tour_celeste_relais_v1` (`TCM1`, Relais Céleste `D13P02`)."""

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

import source.tour_celeste_relais_v1.build as tcm_build  # type: ignore


class TestTourCelesteRelaisV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "tour_celeste_relais_v1"
        if not (cls.renders / "metadata.json").is_file():
            tcm_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_opaque_and_zero_magenta_all_frames(self) -> None:
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            mag_bleed = (np.minimum(r, b) - g) >= 40
            self.assertEqual(int(mag_bleed.sum()), 0)

    def test_02_canonical_d13p02_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 35.0)

    def test_03_active_side_tornadoes_and_jet_streams(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 15).sum()), 5_000)

    def test_04_full_south_to_north_crossing_cloud_bridge(self) -> None:
        _, walk_grid, _ = tcm_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[0, :].tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "Le pont céleste D13P02 doit traverser tout l'axe Sud -> Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = tcm_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        for p in (REPO_ROOT / "source" / "tour_celeste_relais_v1" / "build.py", REPO_ROOT / "index.html"):
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
