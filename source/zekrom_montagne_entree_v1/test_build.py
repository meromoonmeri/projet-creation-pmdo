#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `zekrom_montagne_entree_v1` (`ZKE1`, Entrée Montagne & Grotte de Zekrom)."""

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
        if not (cls.renders / "metadata.json").is_file():
            zke_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(zke_build.RAW_BRUT_PNG).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_sky_and_river_on_brut_and_zero_magenta_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        self.assertGreater(int(mag_raw.sum()), 42_000)
        for idx, pose in enumerate((self.pose0, self.pose12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((r >= 240) & (g <= 15) & (b >= 240)).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_ultra_high_fidelity_to_p14p01a_and_ten_layers(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLess(self.metrics["fidelity_distance"], 30.0)

    def test_03_storm_vortex_and_river_animated_and_terrain_static(self) -> None:
        mag_raw = (self.raw[:, :, 0] >= 245) & (self.raw[:, :, 1] <= 12) & (self.raw[:, :, 2] >= 245)
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff[mag_raw] > 8).sum()), 12_000)
        for st_idx in (4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)

        # Vérifie l'eau Metano sans écume sur la rivière, l'écume Metano uniquement au pied des cascades,
        # et la fluidité continue pose-par-pose (0..23) des rideaux de cascades.
        layers, _ = zke_build.build_layers_for_size()
        riv_f = [np.asarray(im, dtype=np.uint8) for im in layers[2].frames]
        flw_f = [np.asarray(im, dtype=np.uint8) for im in layers[8].frames]
        # 1) Surface calme Metano (131, 218, 230) majoritaire et zéro écume blanche sur la rivière ouverte (y >= 198)
        riv0 = riv_f[0][198:265, :, :]
        open_riv = riv0[:, :, 3] == 255
        white_on_river = open_riv & (riv0[:, :, 0] >= 180) & (riv0[:, :, 1] >= 235) & (riv0[:, :, 2] >= 240)
        self.assertEqual(int(white_on_river.sum()), 0, "Aucune écume ne doit apparaître sur la rivière")
        # 2) Écume officielle Metano présente aux pieds des 2 cascades (x~172 & x~610, y=165..193) et nulle sur la rivière (y=198..264)
        self.assertGreater(int((flw_f[0][165:193, 146:198, 3] == 255).sum()), 600)
        self.assertGreater(int((flw_f[0][165:193, 584:636, 3] == 255).sum()), 600)
        self.assertEqual(int((flw_f[0][198:264, :, 3] == 255).sum()), 0)
        # 3) Cascades fluides : l'eau des gorges (y=80..162, x=158..185) avance à chaque pose consécutive t -> t+1
        for t in range(24):
            c_cur = riv_f[t][80:162, 158:185, :3]
            c_nxt = riv_f[(t + 1) % 24][80:162, 158:185, :3]
            self.assertGreater(int(np.abs(c_cur.astype(int) - c_nxt.astype(int)).max(axis=2).sum()), 500)
        # 4) Ciel orageux + éclairs ramifiés Friend Area PMD Red générés présents et animés (calques 00, 01, 09)
        self.assertTrue((zke_build.HERE / "bruts" / "ciel_orageux_pmd_red_genere.png").is_file())
        self.assertTrue((zke_build.HERE / "bruts" / "eclairs_friend_area_pmd_red_magenta.png").is_file())
        self.assertGreater(int((np.asarray(layers[1].frames[0], dtype=np.uint8)[:, :, 3] == 255).sum()), 200)
        self.assertGreater(int((np.asarray(layers[9].frames[0], dtype=np.uint8)[:100, :, 3] == 255).sum()), 400)

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
