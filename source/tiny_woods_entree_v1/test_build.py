#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `tiny_woods_entree_v1` (`TWE1`, Petit Bois — Lisière & Entrée D01P01)."""
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

import source.tiny_woods_entree_v1.build as twe_build  # type: ignore


class TestTinyWoodsEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "tiny_woods_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            twe_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(twe_build.BRUT_PATH).convert("RGB"), dtype=np.uint8)

    def test_01_zero_sky_lisiere_stream_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        yy = np.arange(self.raw.shape[0])[:, None]
        # ZÉRO ciel visible en haut de Tiny Woods
        self.assertEqual(int((mag_raw & (yy < 240)).sum()), 0, "Aucun ciel ne doit apparaître en haut de Tiny Woods")
        self.assertGreater(int(mag_raw.sum()), 30_000)
        self.assertTrue((twe_build.HERE / "references" / "d01p01_tiny_woods_entry_native.png").is_file())
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_ultra_high_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 10.0)
        for sheet, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24_000, f"Banque trop lourde : {sheet}={count}")

    def test_03_native_metano_water_no_light_rays_and_static_terrain(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        # Vérifie l'eau 100 % Metano Town (surface exacte 131,218,230 + rives 4 phases + sparkles)
        surf_px = (self.pose0[mag_raw, 0] == 131) & (self.pose0[mag_raw, 1] == 218) & (self.pose0[mag_raw, 2] == 230)
        self.assertGreater(int(surf_px.sum()), 20_000)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 4).sum()), 4_000)
        # Vérifie que TOUTES les bûches/souches sont 100 % statiques (0 pixel animé entre pose0 et pose12)
        for x0, y0, x1, y1 in ((456, 250, 508, 292), (604, 308, 652, 346), (722, 272, 764, 310), (684, 458, 734, 500)):
            self.assertEqual(int((diff[y0:y1, x0:x1] > 0).sum()), 0, f"Bûche animée détectée dans ({x0},{y0})..({x1},{y1})")
        for st_idx in (0, 1, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for an_idx in (2, 3, 8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)
        u = self.metrics["unique_tiles_per_sheet"]
        self.assertGreater([v for k, v in u.items() if "_03_" in k][0], 10)
        self.assertGreater([v for k, v in u.items() if "_08_" in k][0], 30)

    def test_04_continuous_south_over_bridge_to_forest_entrance_walkgrid(self) -> None:
        _, walk_grid = twe_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 2000)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        portal_ids = set(lbl[18:26, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & portal_ids), "La prairie Sud doit franchir le pont jusqu'à l'entrée Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = twe_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "tiny_woods_entree_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
