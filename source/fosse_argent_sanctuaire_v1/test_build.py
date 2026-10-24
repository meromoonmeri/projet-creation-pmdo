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

    def test_03_nine_back_waterfalls_and_two_water_tornadoes_per_side_animated(self) -> None:
        layers, _, _ = fas_build.build_layers_for_size(768, 576)
        # Vérifie que la couche 02 anime bien les nombreuses cascades à l'arrière (`y < 260`)
        wf0 = np.asarray(layers[2].frames[0], dtype=np.uint8)
        wf4 = np.asarray(layers[2].frames[4], dtype=np.uint8)
        wf_diff = np.abs(wf0[:260, :, :3].astype(int) - wf4[:260, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((wf_diff > 8).sum()), 3_000, "Les cascades arrière H10P02 doivent s'animer franchement")

        # Vérifie les 2 tornades d'eau 3D à Gauche (`07`) et les 2 tornades d'eau 3D à Droite (`08`) du chemin Sud→Nord
        tl0 = np.asarray(layers[7].frames[0], dtype=np.uint8)
        tl12 = np.asarray(layers[7].frames[12], dtype=np.uint8)
        tr0 = np.asarray(layers[8].frames[0], dtype=np.uint8)
        tr12 = np.asarray(layers[8].frames[12], dtype=np.uint8)
        self.assertGreater(int((tl0[:, :345, 3] == 255).sum()), 12_000)
        self.assertGreater(int((tr0[:, 423:, 3] == 255).sum()), 12_000)
        self.assertEqual(int((tl0[:, 346:422, 3] == 255).sum()), 0, "Aucune tornade ne doit empiéter sur le chemin Sud→Nord")
        self.assertEqual(int((tr0[:, 346:422, 3] == 255).sum()), 0, "Aucune tornade ne doit empiéter sur le chemin Sud→Nord")
        self.assertGreater(int((np.abs(tl0[:, :, :3].astype(int) - tl12[:, :, :3].astype(int)).max(axis=2) > 8).sum()), 4_000)
        self.assertGreater(int((np.abs(tr0[:, :, :3].astype(int) - tr12[:, :, :3].astype(int)).max(axis=2) > 8).sum()), 4_000)

        # Arène simple (`06`), chemin Sud→Nord (`05`), falaise (`04`) et eau profonde (`00`) 100 % statiques (`poses = 1`)
        for st_idx in (0, 4, 5, 6):
            self.assertEqual(self.metrics["layers"][st_idx]["poses"], 1)

    def test_04_simple_uncluttered_oval_arena_and_south_to_north_path(self) -> None:
        _, wg, pal = fas_build.build_layers_for_size(768, 576)
        self.assertLessEqual(len(pal), 96)
        self.assertEqual(wg.shape, (72, 96))
        self.assertGreaterEqual(int(wg.sum()), 1_000)
        lbl, n_cc = ndimage.label(wg)
        self.assertEqual(n_cc, 1)
        # Chemin Sud→Nord praticable dès le bord Sud (`y = 71`)
        self.assertTrue(bool(wg[71, 45:51].any()), "Chemin Sud→Nord ouvert au Sud")
        # Intérieur de l'arène simple 100 % dégagé sans le moindre objet/trou de collision
        self.assertTrue(bool(np.all(wg[28:42, 34:62])), "L'arène centrale de Lugia doit être 100 % simple et dégagée sans objet")

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
