#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests unitaires PMDO `0.8.12.0` pour le Chapitre I de `PMD : Destiny` (`DSV1`, `DSR1`, `DSD1`, `DSB1`)."""
from __future__ import annotations

import json
import unittest
import zipfile
from pathlib import Path

import numpy as np

from source.destiny_donjon1_grotte_maree_boss_v1.build import build_layers_for_size as build_dsb1
from source.destiny_donjon1_grotte_maree_entree_v1.build import build_layers_for_size as build_dsd1
from source.destiny_route_passe_corail_v1.build import build_layers_for_size as build_dsr1
from source.destiny_village_port_aube_v1.build import build_layers_for_size as build_dsv1

REPO_ROOT = Path(__file__).resolve().parents[2]


class TestDestinyChapitre1Maps(unittest.TestCase):
    SPECS = [
        ("DSV1", "destiny_village_port_aube_v1", "destiny_bourg_ecume_port", build_dsv1),
        ("DSR1", "destiny_route_passe_corail_v1", "destiny_passe_rocheuse_ecumes", build_dsr1),
        ("DSD1", "destiny_donjon1_grotte_maree_entree_v1", "destiny_grotte_maree_entree", build_dsd1),
        ("DSB1", "destiny_donjon1_grotte_maree_boss_v1", "destiny_grotte_maree_boss", build_dsb1),
    ]

    def test_01_multilayer_dimensions_alpha_and_zero_magenta_leak(self) -> None:
        for mid, _folder, _asset, fn in self.SPECS:
            layers, walk_grid = fn(768, 576)
            self.assertEqual(len(layers), 10, f"{mid}: attendu 10 calques")
            self.assertEqual(walk_grid.shape, (72, 96), f"{mid}: walk_grid 96x72 attendu")
            self.assertGreater(int(walk_grid.sum()), 400, f"{mid}: walk_grid trop restreint")

            anim_layers = 0
            for idx, lay in enumerate(layers):
                self.assertIn(lay.layer_kind, ("BG", "Top"), f"{mid} L{idx}")
                if len(lay.frames) > 1:
                    anim_layers += 1
                for f_i, fr in enumerate(lay.frames):
                    self.assertEqual(fr.size, (768, 576), f"{mid} L{idx} F{f_i}")
                    arr = np.asarray(fr, dtype=np.uint8)
                    alphas = set(np.unique(arr[:, :, 3]).tolist())
                    self.assertTrue(alphas.issubset({0, 255}), f"{mid} L{idx} alpha non binaire: {alphas}")
                    vis = arr[:, :, 3] == 255
                    mag = vis & (arr[:, :, 0] >= 245) & (arr[:, :, 1] <= 12) & (arr[:, :, 2] >= 245)
                    self.assertEqual(int(mag.sum()), 0, f"{mid} L{idx} F{f_i} fuite magenta")
            self.assertGreaterEqual(anim_layers, 4, f"{mid}: au moins 4 calques animés attendus (liquides + VFX)")

    def test_02_tile_budget_fidelity_and_virtual_zips(self) -> None:
        for mid, folder, asset, _fn in self.SPECS:
            meta_p = REPO_ROOT / "renders" / folder / "metadata.json"
            self.assertTrue(meta_p.is_file(), f"metadata manquant: {meta_p}")
            meta = json.loads(meta_p.read_text(encoding="utf-8"))
            self.assertLess(int(meta["total_unique_tiles"]), 24000, f"{mid}: dépassement budget tuiles")
            self.assertLess(float(meta["fidelity_distance"]), 30.0, f"{mid}: fidélité hors seuil")

            zpath = REPO_ROOT / ".cache" / "virtual_zips" / f"{mid}_PMDO_0.8.12.zip"
            self.assertTrue(zpath.is_file(), f"ZIP manquant: {zpath}")
            with zipfile.ZipFile(zpath, "r") as zf:
                names = set(zf.namelist())
                self.assertIn("Mod.xml", names)
                self.assertIn("INSTALLER.py", names)
                self.assertIn("Content/Tile/index.idx", names)
                self.assertIn(f"Data/Ground/{asset}.rsground", names)
                tile_files = [n for n in names if n.endswith(".tile")]
                self.assertEqual(len(tile_files), 10, f"{mid}: attendu 10 fichiers .tile")


if __name__ == "__main__":
    unittest.main()
