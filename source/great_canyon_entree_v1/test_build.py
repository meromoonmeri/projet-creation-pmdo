#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `great_canyon_entree_v1` (`GCE1`, Grand Canyon — Entrée D07P01)."""
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

import source.great_canyon_entree_v1.build as gce_build  # type: ignore


class TestGreatCanyonEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "great_canyon_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            gce_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(gce_build.BRUT_PATH).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_sky_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 80_000)
        self.assertTrue((gce_build.HERE / "references" / "d07p01_great_canyon_entry_native.png").is_file())
        self.assertTrue((gce_build.HERE / "bruts" / "nuages_pmd_canyon_magenta.png").is_file())
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_fidelity_and_ten_non_empty_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 10.0)
        for sheet, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertGreaterEqual(count, 20, f"Calque vide ou quasi-vide : {sheet}={count}")
            self.assertLess(count, 24_000, f"Banque trop lourde : {sheet}={count}")

    def test_03_slow_pmd_clouds_canonical_sun_zero_cactus_and_static_terrain(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 4).sum()), 3_000)
        # Vérifie ZÉRO cactus vert sur le relief de l'entrée du Grand Canyon (y >= 260)
        r_g = self.pose0[260:, :, 0].astype(int)
        g_g = self.pose0[260:, :, 1].astype(int)
        b_g = self.pose0[260:, :, 2].astype(int)
        self.assertEqual(int(((g_g >= r_g - 8) & (g_g > b_g + 16)).sum()), 0, "Il reste des pixels de cactus vert sur GCE1")
        # Vérifie la présence du Soleil animé canonique (255, 207, 71) dans le col central (x=340..428, y=145..198)
        notch = self.pose0[145:198, 340:428, :3]
        sun_core = (notch[:, :, 0] == 255) & (notch[:, :, 1] == 207) & (notch[:, :, 2] == 71)
        self.assertGreater(int(sun_core.sum()), 1200)
        sun_diff = np.abs(self.pose0[142:202, 310:458, :3].astype(int) - self.pose12[142:202, 310:458, :3].astype(int)).max(axis=2)
        self.assertGreater(int((sun_diff > 4).sum()), 150)
        for st_idx in (0, 4, 5, 6, 7, 8):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        self.assertEqual(self.metrics["layers"][1]["poses"], 64)
        self.assertEqual(self.metrics["layers"][1]["frame_length"], 45)
        self.assertEqual(self.metrics["layers"][3]["poses"], 64)
        self.assertEqual(self.metrics["layers"][3]["frame_length"], 36)
        for an_idx in (2, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)

    def test_04_continuous_south_trail_to_slot_gorge_walkgrid(self) -> None:
        _, walk_grid = gce_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        gorge_ids = set(lbl[26:33, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & gorge_ids), "La piste Sud doit rejoindre directement le défilé Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = gce_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "great_canyon_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
