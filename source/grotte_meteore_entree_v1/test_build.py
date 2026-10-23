#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `grotte_meteore_entree_v1` (`GME1`, Météorite Fissurée Deoxys)."""

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

import source.grotte_meteore_entree_v1.build as gme_build  # type: ignore


class TestGrotteMeteoreEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "grotte_meteore_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            gme_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose6 = np.asarray(Image.open(cls.renders / "frames" / "frame_06.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_deoxys_palette_zero_black_and_starry_sky(self) -> None:
        _, fg_mask = gme_build.load_clean_meteor_raw(gme_build.DECOR_RAW, 768, 576)
        lbl, n_c = ndimage.label(fg_mask)
        main_island = lbl == (int(np.argmax(ndimage.sum(fg_mask, lbl, range(1, n_c + 1)))) + 1)
        for idx, pose in enumerate((self.pose0, self.pose6, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            # Zéro résidu de fond vert `#00FF00`
            green_key_bleed = (g - np.maximum(r, b)) >= 60
            self.assertEqual(int(green_key_bleed.sum()), 0, f"Résidu vert `#00FF00` sur pose {idx}")
            # Zéro noir sur les roches (`max >= 75` partout sur `main_island`)
            black_on_rock = main_island & (pose[:, :, :3].max(axis=2) < 75)
            self.assertEqual(int(black_on_rock.sum()), 0, f"Pixels noirs sur roche pose {idx}: {int(black_on_rock.sum())}")
            # Présence forte des 3 pôles chromatiques identitaires de Deoxys : vermeil-corail, turquoise & violet-indigo
            deoxys_coral = main_island & (r >= 200) & (g >= 45) & (g <= 170) & (b <= 140)
            deoxys_teal = main_island & (g >= 150) & (b >= 150) & (r < 170)
            deoxys_violet = main_island & (b >= 145) & (r >= 45) & (g < 100)
            self.assertGreater(int(deoxys_coral.sum()), 12_000)
            self.assertGreater(int(deoxys_teal.sum()), 6_000)
            self.assertGreater(int(deoxys_violet.sum()), 25_000)
            # Voûte étoilée riche + étoiles filantes
            bright_sky = (~fg_mask) & (b >= 135)
            self.assertGreater(int(bright_sky.sum()), 250)

    def test_02_static_crystals_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        # Les cristaux (couche 08) doivent être 100 % STATIQUES (`poses == 1`) !
        self.assertEqual(self.metrics["layers"][8]["poses"], 1)

    def test_03_active_fissures_stars_and_levitating_shards(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose6[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 15).sum()), 2_000)

    def test_04_south_to_north_walkable_path_into_fissured_meteorite(self) -> None:
        _, walk_grid, _ = gme_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 450)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[21:28, 44:53].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "Le chemin doit mener du Sud jusqu'à la brèche caverneuse Nord")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = gme_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))
            self.assertEqual(res["layers"][8]["poses"], 1)

    def test_06_zero_credits(self) -> None:
        for p in (REPO_ROOT / "source" / "grotte_meteore_entree_v1" / "build.py", REPO_ROOT / "index.html"):
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
