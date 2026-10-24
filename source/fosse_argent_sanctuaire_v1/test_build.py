#!/usr/bin/env python3
"""Tests unitaires — `FAS1` (*Tourb'Îles — Arène de Lugia façon Pokémon SoulSilver*)."""

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
        fas_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.raw = np.asarray(Image.open(fas_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose12 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_magenta_water_and_chutes_on_brut_and_zero_magenta_leak_or_sky(self) -> None:
        mag_px = int(((self.raw[:, :, 0] >= 240) & (self.raw[:, :, 1] <= 18) & (self.raw[:, :, 2] >= 240)).sum())
        self.assertGreater(mag_px, 200_000, "Le bassin et les chutes doivent être masqués en #FF00FF sur le brut")
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

    def test_03_dark_metano_water_foggy_forest_waterfalls_and_offscreen_tce1_tornadoes(self) -> None:
        layers, _, _ = fas_build.build_layers_for_size(768, 576)

        # 1) Eau Metano Town sombre (4 poses @ 10 ticks sur 01_ondes + 02_sparkles)
        self.assertEqual((len(layers[1].frames), layers[1].frame_length), (4, 10))
        self.assertEqual((len(layers[2].frames), layers[2].frame_length), (4, 10))
        base_w = np.asarray(layers[0].frames[0], dtype=np.uint8)
        self.assertEqual(tuple(int(v) for v in base_w[500, 330, :3]), (22, 56, 134))
        w0 = np.asarray(layers[1].frames[0], dtype=np.uint8)
        w2 = np.asarray(layers[1].frames[2], dtype=np.uint8)
        self.assertGreater(int((np.abs(w0.astype(int) - w2.astype(int)).max(axis=2) > 6).sum()), 1_500)

        # 2) Cascades authentiques de Foggy Forest (`P03P01A`, 3 poses BPA @ 10 ticks sur 04)
        self.assertTrue((fas_build.REF_DIR / "foggy_forest_p03p01a_waterfalls.png").is_file())
        self.assertEqual((len(layers[4].frames), layers[4].frame_length), (3, 10))
        wf0 = np.asarray(layers[4].frames[0], dtype=np.uint8)
        wf1 = np.asarray(layers[4].frames[1], dtype=np.uint8)
        wf_diff = np.abs(wf0[:290, :, :3].astype(int) - wf1[:290, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((wf_diff > 8).sum()), 6_000, "Les 9 cascades Foggy Forest P03P01A doivent s'animer")

        # 3) 2 tornades d'eau géantes par côté SANS extrémité visible (touchent y=0 ET y=575 comme Sky Tower Entrance !)
        for idx_t in (7, 8):
            self.assertEqual((len(layers[idx_t].frames), layers[idx_t].frame_length), (8, 5))
            t0 = np.asarray(layers[idx_t].frames[0], dtype=np.uint8)
            t4 = np.asarray(layers[idx_t].frames[4], dtype=np.uint8)
            # Touche le bord supérieur hors-cadre y=0 à gauche ET à droite
            self.assertGreater(int((t0[0, :384, 3] == 255).sum()), 40, f"Calque {idx_t} doit dépasser y=0 à gauche")
            self.assertGreater(int((t0[0, 384:, 3] == 255).sum()), 40, f"Calque {idx_t} doit dépasser y=0 à droite")
            # Touche le bord inférieur hors-cadre y=575 à gauche ET à droite
            self.assertGreater(int((t0[575, :384, 3] == 255).sum()), 40, f"Calque {idx_t} doit dépasser y=575 à gauche")
            self.assertGreater(int((t0[575, 384:, 3] == 255).sum()), 40, f"Calque {idx_t} doit dépasser y=575 à droite")
            # Zéro empiètement sur le chemin de pierre Sud→Nord central
            self.assertEqual(int((t0[:, 348:420, 3] == 255).sum()), 0)
            self.assertGreater(int((np.abs(t0[:, :, :3].astype(int) - t4[:, :, :3].astype(int)).max(axis=2) > 8).sum()), 8_000)

        # Arène simple (`06`), chemin Sud→Nord (`05`), falaise (`03`) et eau profonde (`00`) 100 % statiques (`poses = 1`)
        for st_idx in (0, 3, 5, 6):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)

    def test_04_simple_uncluttered_oval_arena_and_south_to_north_path(self) -> None:
        _, wg, pal = fas_build.build_layers_for_size(768, 576)
        self.assertLessEqual(len(pal), 96)
        self.assertEqual(wg.shape, (72, 96))
        self.assertGreaterEqual(int(wg.sum()), 850)
        lbl, n_cc = ndimage.label(wg)
        self.assertEqual(n_cc, 1)
        self.assertTrue(bool(wg[71, 45:51].any()), "Chemin Sud→Nord ouvert au Sud")
        self.assertTrue(bool(np.all(wg[29:41, 36:60])), "L'arène centrale de Lugia doit être 100 % simple et dégagée sans objet")

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
