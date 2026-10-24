#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `kyurem_sanctuaire_glace_v1` (`KYA1`, Sanctuaire Glace Noire & Blizzard 360°)."""
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

import source.kyurem_sanctuaire_glace_v1.build as kya_build  # type: ignore
from source.moteur_grotte_cyclopeenne_kyurem import split_sanctuary_outer_vortex_and_inner_moat


class TestKyuremSanctuaireGlaceV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "kyurem_sanctuaire_glace_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            kya_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(kya_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_dual_magenta_vortex_and_moat_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        outer_vortex, inner_moat = split_sanctuary_outer_vortex_and_inner_moat(mag_raw)
        self.assertGreater(int(outer_vortex.sum()), 70_000)
        self.assertGreater(int(inner_moat.sum()), 45_000)

        non_mag = self.raw[~mag_raw]
        uniq_cols = np.unique(non_mag.reshape(-1, 3), axis=0)
        self.assertLessEqual(len(uniq_cols), 96)

        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_distinct_geometry_from_zka1_and_ten_layers_under_tile_budget(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 25.0)
        for bank_tiles in self.metrics["unique_tiles_per_sheet"].values():
            self.assertLess(bank_tiles, 24000)

        zka_raw_p = REPO_ROOT / "source" / "zekrom_sommet_tornade_v1" / "bruts" / "base_zekrom_sommet_tornade.png"
        if zka_raw_p.is_file():
            zka_raw = np.asarray(Image.open(zka_raw_p).convert("RGB"), dtype=np.uint8)
            mag_k = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
            mag_z = (zka_raw[:, :, 0] >= 245) & (zka_raw[:, :, 1] <= 12) & (zka_raw[:, :, 2] >= 245)
            iou = float((mag_k & mag_z).sum()) / float((mag_k | mag_z).sum())
            self.assertLess(iou, 0.65, "KYA1 doit posséder une géométrie de sanctuaire inédite face à ZKA1")

    def test_03_blizzard_360_and_glacial_metano_moat_animated_and_terrain_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        outer_vortex, inner_moat = split_sanctuary_outer_vortex_and_inner_moat(mag_raw)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[outer_vortex] > 8).sum()), 20_000)
        self.assertGreater(int((diff[inner_moat] > 4).sum()), 3_000)

        for st_idx in (4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for w_idx in (2, 3):
            self.assertEqual(self.metrics["layers"][w_idx]["poses"], 4)
        for b_idx in (0, 1, 8, 9):
            self.assertEqual(self.metrics["layers"][b_idx]["poses"], 24)

    def test_04_continuous_south_causeway_to_bare_black_ice_arena_walkgrid(self) -> None:
        _, walk_grid = kya_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1000)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        arena_ids = set(lbl[28:38, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & arena_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = kya_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "kyurem_sanctuaire_glace_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
