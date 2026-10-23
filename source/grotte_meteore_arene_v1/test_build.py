#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `grotte_meteore_arene_v1` (`GMA1`, PMDO 0.8.12.0)."""

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

import source.grotte_meteore_arene_v1.build as gma_build  # type: ignore


class TestGrotteMeteoreAreneV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "grotte_meteore_arene_v1"
        if not (cls.renders / "metadata.json").is_file():
            gma_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose6 = np.asarray(Image.open(cls.renders / "frames" / "frame_06.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_zero_green_and_zero_black_rock_all_frames(self) -> None:
        _, fg_mask = gma_build.load_clean_meteor_raw(gma_build.DECOR_RAW, 768, 576)
        lbl, n_c = ndimage.label(fg_mask)
        main_island = lbl == (int(np.argmax(ndimage.sum(fg_mask, lbl, range(1, n_c + 1)))) + 1)
        for idx, pose in enumerate((self.pose0, self.pose6, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            green_bleed = (g >= 35) & (g > b - 4)
            self.assertEqual(int(green_bleed.sum()), 0, f"Résidu vert détecté sur pose {idx}: {int(green_bleed.sum())}")
            black_on_rock = main_island & (pose[:, :, :3].max(axis=2) < 90)
            self.assertEqual(int(black_on_rock.sum()), 0, f"Pixels noirs sur roche pose {idx}: {int(black_on_rock.sum())}")
            bright_sky = (~fg_mask) & (b >= 135)
            self.assertGreater(int(bright_sky.sum()), 250, f"Pas assez d'étoiles / étoiles filantes sur pose {idx}")

    def test_02_canonical_b74_fidelity_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 33.0)

    def test_03_active_psychic_wave_and_levitating_whole_meteorites(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose6[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 15).sum()), 3_000)

    def test_04_south_bridge_continuous_to_deoxys_chamber_center(self) -> None:
        _, walk_grid, _ = gma_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 900)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        center_ids = set(lbl[30:38, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & center_ids), "Le pont Sud doit rejoindre le cœur de l'arène de Deoxys")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = gma_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))
            p0 = np.asarray(Image.open(Path(tmp) / "composite_pose0.png").convert("RGBA"), dtype=int)
            self.assertEqual(int(((p0[:, :, 1] >= 35) & (p0[:, :, 1] > p0[:, :, 2] - 4)).sum()), 0)

    def test_06_zero_credits(self) -> None:
        for p in (REPO_ROOT / "source" / "grotte_meteore_arene_v1" / "build.py", REPO_ROOT / "index.html"):
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
