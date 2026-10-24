#!/usr/bin/env python3
"""Tests unitaires — `FAE1` (*Fosse d'Argent — Entrée Engloutie / Silver Trench Entrance*)."""

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
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.fosse_argent_entree_v1 import build as fae_build


class TestFosseArgentEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = fae_build.RENDERS_DIR
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            fae_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.raw = np.asarray(Image.open(fae_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_magenta_basin_on_brut_and_zero_magenta_leak_or_sky(self) -> None:
        self.assertEqual(self.raw.shape, (576, 768, 3))
        mag_px = int(((self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)).sum())
        self.assertGreater(mag_px, 60_000, "Le bassin englouti doit être masqué en #FF00FF sur le brut")
        for arr in (self.pose0, self.pose12):
            r = arr[:, :, 0].astype(int)
            g = arr[:, :, 1].astype(int)
            b = arr[:, :, 2].astype(int)
            leak = int(((np.minimum(r, b) - g) >= 34).sum())
            self.assertEqual(leak, 0, "Zéro fuite ou frange magenta sur les rendus finaux")
            self.assertTrue(np.all(arr[:, :, 3] == 255), "0 px transparent ou de ciel à découvert")

    def test_02_fidelity_ten_layers_and_tilebank_budget(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLessEqual(self.metrics["fidelity_distance"], 4.5)
        for bank, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24_000, f"Banque {bank} dépasse 24 000 tuiles : {count}")

    def test_03_underwater_currents_and_h02p02w_rays_animated_ruins_static(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 4).sum()), 1_000, "Courants Metano & rayons sous-marins H02P02W doivent s'animer")
        for st_idx in (0, 3, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)

    def test_04_continuous_corridor_south_to_north_sunken_portal(self) -> None:
        _, wg, _ = fae_build.build_layers_for_size(768, 576)
        self.assertEqual(wg.shape, (72, 96))
        self.assertGreaterEqual(int(wg.sum()), 900)
        lbl, n_cc = ndimage.label(wg)
        self.assertEqual(n_cc, 1)
        self.assertTrue(bool(wg[71, :].any()), "Entrée Sud accessible")
        self.assertTrue(bool(wg[8:16, 43:53].any()), "Portail englouti Nord accessible")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            m_half = fae_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((m_half["width"], m_half["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = Path(fae_build.__file__).read_text(encoding="utf-8").lower()
        for banned in ("crédit", "credit", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
