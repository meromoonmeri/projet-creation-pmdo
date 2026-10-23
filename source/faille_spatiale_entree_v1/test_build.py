#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `faille_spatiale_entree_v1` (`FSE1`, Canyon Rocheux -> Zarbis PMDO -> Cosmos)."""

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

import source.faille_spatiale_entree_v1.build as fse_build  # type: ignore


class TestFailleSpatialeEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "faille_spatiale_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            fse_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(fse_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cosmos_and_portal_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 80_000)
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((r >= 240) & (g <= 15) & (b >= 240)).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_ultra_high_fidelity_to_d46p41a_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 22.0)

    def test_03_rocky_canyon_to_zarbi_swarm_to_portal_and_starry_cosmos(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 15).sum()), 35_000)
        # Les calques structurels du sol, des falaises et des rochers restent 100 % statiques (`poses == 1`)
        self.assertEqual(self.metrics["layers"][3]["poses"], 1)
        self.assertEqual(self.metrics["layers"][4]["poses"], 1)
        self.assertEqual(self.metrics["layers"][5]["poses"], 1)
        # La nuée de Zarbis PMDO est bien active à la fois en BG (`layer 8`) et en Top (`layer 9`)
        layers, _ = fse_build.build_layers_for_size()
        bg_zarbi_px = int((np.asarray(layers[8].frames[10], dtype=np.uint8)[:, :, 3] == 255).sum())
        top_zarbi_px = int((np.asarray(layers[9].frames[12], dtype=np.uint8)[:, :, 3] == 255).sum())
        self.assertGreater(bg_zarbi_px, 4_000)
        self.assertGreater(top_zarbi_px, 3_500)
        # À `pose 16` (apogée cosmos + portail), le cœur Nord du portail est grand ouvert et lumineux
        acc16 = np.zeros((576, 768, 4), dtype=np.uint8)
        for le in layers:
            im_l = np.asarray(le.frames[16 % len(le.frames)], dtype=np.uint8)
            m_l = im_l[:, :, 3] > 0
            acc16[m_l] = im_l[m_l]
        north_core = acc16[30:130, 340:428, :3]
        bright = (north_core[:, :, 0] >= 220) & (north_core[:, :, 1] >= 175) & (north_core[:, :, 2] >= 230)
        self.assertGreater(int(bright.sum()), 1_200)

    def test_04_continuous_south_to_north_rift_portal_walkgrid(self) -> None:
        _, walk_grid = fse_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        portal_ids = set(lbl[16:22, 43:53].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & portal_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = fse_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "faille_spatiale_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
