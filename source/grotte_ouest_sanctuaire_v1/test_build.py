#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `grotte_ouest_sanctuaire_v1` (`MWA1`, Gouffre Stalagmitique H13P02 de Mewtwo)."""
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

import source.grotte_ouest_sanctuaire_v1.build as mwa_build  # type: ignore


class TestGrotteOuestSanctuaireV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "grotte_ouest_sanctuaire_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            mwa_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(mwa_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_zero_sky_cryptic_chasm_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertEqual(int(mag_raw[:160, :].sum()), 0)
        self.assertGreater(int(mag_raw.sum()), 60_000)
        non_mag = self.raw[~mag_raw]
        uniq_cols = np.unique(non_mag.reshape(-1, 3), axis=0)
        self.assertLessEqual(len(uniq_cols), 96)
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_non_cloned_chasm_ridge_and_ten_layers_budget(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 15.0)
        for bank_tiles in self.metrics["unique_tiles_per_sheet"].values():
            self.assertLess(bank_tiles, 24000)

        mag_m = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        for other_rel in (
            "source/kyurem_sanctuaire_arene_v1/bruts/base_kyurem_sanctuaire_arene.png",
            "source/reshiram_sanctuaire_arene_v1/bruts/base_reshiram_sanctuaire_arene.png",
            "source/ruines_enfouies_sanctuaire_v1/bruts/base_ruines_enfouies_sanctuaire.png",
        ):
            op = REPO_ROOT / other_rel
            if op.is_file():
                other = np.asarray(Image.open(op).convert("RGB"), dtype=np.uint8)
                mag_o = (other[:, :, 0] >= 245) & (other[:, :, 1] <= 12) & (other[:, :, 2] >= 245)
                iou = float((mag_m & mag_o).sum()) / float((mag_m | mag_o).sum())
                self.assertLess(iou, 0.35, f"MWA1 ne doit calquer aucun sanctuaire circulaire ({other_rel})")

    def test_03_bare_hexagonal_plateau_static_and_halcyon_script(self) -> None:
        for st_idx in (4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for w_idx in (2, 3):
            self.assertEqual(self.metrics["layers"][w_idx]["poses"], 4)
        for an_idx in (0, 1, 8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)
        # Vérifie que le centre du promontoire hexagonal de Mewtwo reste 100 % calme/nu
        diff_center = np.abs(
            self.pose0[165:225, 340:425, :3].astype(int) - self.pose12[165:225, 340:425, :3].astype(int)
        ).max()
        self.assertEqual(int(diff_center), 0)
        h_lua = self.renders / "package" / "Data" / "Script" / "halcyon" / "ground" / "grotte_ouest_sanctuaire_mewtwo" / "init.lua"
        self.assertTrue(h_lua.is_file())

    def test_04_continuous_south_ridge_to_hex_promontory_walkgrid(self) -> None:
        _, walk_grid = mwa_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 400)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        hex_ids = set(lbl[20:28, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & hex_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = mwa_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))


if __name__ == "__main__":
    unittest.main()
