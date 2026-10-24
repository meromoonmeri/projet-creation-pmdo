#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `ruines_enfouies_entree_v1` (`RUE1`, Ziggourat H22P01 à Double Escalier)."""
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

import source.ruines_enfouies_entree_v1.build as rue_build  # type: ignore


class TestRuinesEnfouiesEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "ruines_enfouies_entree_v1"
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            rue_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(rue_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_zero_sky_twin_basins_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        # ZÉRO pixel de ciel et deux bassins rectangulaires latéraux séparés par la chaussée centrale !
        self.assertEqual(int(mag_raw[:350, :].sum()), 0)
        self.assertEqual(int(mag_raw[:, 280:488].sum()), 0)
        self.assertGreater(int(mag_raw[:, :260].sum()), 15_000)
        self.assertGreater(int(mag_raw[:, 508:].sum()), 15_000)
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"Fuite magenta sur pose {idx}")

    def test_02_non_cloned_ziggurat_layout_and_ten_layers_budget(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 15.0)
        for bank_tiles in self.metrics["unique_tiles_per_sheet"].values():
            self.assertLess(bank_tiles, 24000)

        mag_r = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        for other_rel in (
            "source/kyurem_cratere_entree_v1/bruts/base_kyurem_cratere_entree.png",
            "source/reshiram_montagne_entree_v1/bruts/base_reshiram_montagne_entree.png",
            "source/grotte_ouest_entree_v1/bruts/base_grotte_ouest_entree.png",
        ):
            op = REPO_ROOT / other_rel
            if op.is_file():
                other = np.asarray(Image.open(op).convert("RGB"), dtype=np.uint8)
                mag_o = (other[:, :, 0] >= 245) & (other[:, :, 1] <= 12) & (other[:, :, 2] >= 245)
                iou = float((mag_r & mag_o).sum()) / float((mag_r | mag_o).sum())
                self.assertLess(iou, 0.30, f"RUE1 ne doit calquer aucune autre entrée ({other_rel})")

    def test_03_sacred_metano_basins_glyphs_and_halcyon_script(self) -> None:
        for st_idx in (0, 1, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)
        for w_idx in (2, 3):
            self.assertEqual(self.metrics["layers"][w_idx]["poses"], 4)
        for an_idx in (8, 9):
            self.assertEqual(self.metrics["layers"][an_idx]["poses"], 24)
        h_lua = self.renders / "package" / "Data" / "Script" / "halcyon" / "ground" / "ruines_enfouies_entree" / "init.lua"
        self.assertTrue(h_lua.is_file())

    def test_04_continuous_avenue_twin_stairs_to_doorway_walkgrid(self) -> None:
        _, walk_grid = rue_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1200)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, 44:52].ravel().tolist()) - {0}
        door_ids = set(lbl[21:24, 45:51].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & door_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = rue_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))


if __name__ == "__main__":
    unittest.main()
