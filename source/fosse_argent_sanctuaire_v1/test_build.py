#!/usr/bin/env python3
"""Tests unitaires — `FAS1` (*Fosse d'Argent — Sanctuaire Abyssal de Lugia / Silver Trench 99F*)."""

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

from source.fosse_argent_sanctuaire_v1 import build as fas_build


class TestFosseArgentSanctuaireV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = fas_build.RENDERS_DIR
        if not (cls.renders / "metadata.json").is_file() or not (cls.renders / "composite_pose0.png").is_file():
            fas_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.raw = np.asarray(Image.open(fas_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_magenta_trench_on_brut_and_zero_magenta_leak_or_sky(self) -> None:
        mag_px = int(((self.raw[:, :, 0] >= 240) & (self.raw[:, :, 1] <= 18) & (self.raw[:, :, 2] >= 240)).sum())
        self.assertGreater(mag_px, 200_000, "La fosse abyssale entourant le sanctuaire doit être en #FF00FF sur le brut")
        for arr in (self.pose0, self.pose12):
            self.assertEqual(arr.shape, (576, 768, 4))
            r = arr[:, :, 0].astype(int)
            g = arr[:, :, 1].astype(int)
            b = arr[:, :, 2].astype(int)
            leak = int(((np.minimum(r, b) - g) >= 34).sum())
            self.assertEqual(leak, 0, "Zéro fuite ou halo magenta sur les rendus finaux")
            self.assertTrue(np.all(arr[:, :, 3] == 255), "0 px de ciel ou de transparence finale")

    def test_02_ten_layers_96_palette_and_tilebank_budget(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        self.assertLessEqual(self.metrics["fidelity_distance"], 4.0)
        for bank, count in self.metrics["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24_000, f"Banque {bank} dépasse 24 000 tuiles : {count}")

    def test_03_h02p02_vortex_and_h02p02w_rays_animated_altar_static(self) -> None:
        diff = np.abs(self.pose0[:, :, :3].astype(int) - self.pose12[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff > 4).sum()), 3_000, "Le vortex H02P02 & les 5 rayons H02P02W doivent s'animer")
        for st_idx in (0, 3, 4, 5, 6, 7):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)

    def test_04_contiguous_boss_arena_and_lugia_altar_walkgrid(self) -> None:
        _, wg, pal = fas_build.build_layers_for_size(768, 576)
        self.assertLessEqual(len(pal), 96)
        self.assertEqual(wg.shape, (72, 96))
        self.assertGreaterEqual(int(wg.sum()), 900)
        lbl, n_cc = ndimage.label(wg)
        self.assertEqual(n_cc, 1)
        self.assertTrue(bool(wg[71, 44:52].any()), "Grand escalier Sud ouvert")
        self.assertTrue(bool(wg[15:22, 45:51].any()), "Autel concentrique Nord de Lugia accessible")

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            m_half = fas_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((m_half["width"], m_half["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = Path(fas_build.__file__).read_text(encoding="utf-8").lower()
        for banned in ("crédit", "credit", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
