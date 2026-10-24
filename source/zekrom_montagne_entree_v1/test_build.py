#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `zekrom_montagne_entree_v1` (`ZKE1`, Taïga d'Orage & Orgues Basaltiques sans ciel)."""
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

import source.zekrom_montagne_entree_v1.build as zke_build  # type: ignore


class TestZekromMontagneEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "zekrom_montagne_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            zke_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(zke_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_zero_sky_magenta_river_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        # ZÉRO pixel de ciel sur toute la moitié supérieure de la carte !
        self.assertEqual(int(mag_raw[:275, :].sum()), 0)
        self.assertGreater(int(mag_raw.sum()), 30_000)
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_distinct_biome_from_reshiram_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 10.0)
        for bank_tiles in self.metrics["unique_tiles_per_sheet"].values():
            self.assertLess(bank_tiles, 24000)
        # Vérifie que le biome ZKE1 est radicalement différent du biome RSE1 (géométrie d'eau ET palette roche/prairie)
        rse_raw_p = REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "base_reshiram_montagne_entree.png"
        if rse_raw_p.is_file():
            rse_raw = np.asarray(Image.open(rse_raw_p).convert("RGB"), dtype=np.uint8)
            mag_z = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
            mag_r = (rse_raw[:, :, 0] >= 245) & (rse_raw[:, :, 1] <= 12) & (rse_raw[:, :, 2] >= 245)
            iou = float((mag_z & mag_r).sum()) / float((mag_z | mag_r).sum())
            self.assertLess(iou, 0.72, "Les lits de rivière ZKE1 et RSE1 doivent avoir deux tracés distincts")
            mean_diff_cliff = float(np.abs(self.raw[:200].astype(float) - rse_raw[:200].astype(float)).mean())
            self.assertGreater(mean_diff_cliff, 80.0, "Les montagnes ZKE1 et RSE1 doivent être de biomes opposés")

    def test_03_metano_river_animated_and_terrain_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 4).sum()), 3_000)
        for st_idx in (0, 1, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for an_idx in (2, 3, 8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)

    def test_04_continuous_south_to_cave_walkgrid(self) -> None:
        _, walk_grid = zke_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        cave_ids = set(lbl[20:26, 45:51].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & cave_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = zke_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "zekrom_montagne_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
