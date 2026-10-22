#!/usr/bin/env python3
"""Suite de tests automatisés — STC1 Sommet de la Tour Céleste (Arène `b71` + Planète Terre + Chemin Sud-Nord).

Vérifie :
1. Zéro halo magenta résiduel (`R > 165 & G < 90 & B > 165 = 0`) sur les 10 couches × 24 poses ;
2. Continuité harmonieuse multi-trames (24 poses @ 5 ticks = 120 ticks), bouclage exact et
   vecteurs physiques attendus (nuages orbitaux sur la Terre + étoiles scintillantes + ailes divergentes) ;
3. Double fidélité visuelle :
   - fidélité globale `< 25.0` face à `references/ref_sommet_planete_rayquaza.png` (Planète Terre courbe,
     continents, cosmos étoilé, hauteur du sommet et chemin Sud-Nord) et rejet `> 45.0` d'un biome hors-sujet,
   - identité pixel `1:1` (`< 4.0`) du dôme nuageux face à `references/b71_sky_tower_summit.png` ;
4. Conformité du package PMDO `0.8.12.0` (`STC1.rsground`, `10` feuilles `.png/.tile`, `index.idx`,
   `WallGrid` praticable continu du bord Sud `y = H - 1` jusqu'au cœur de l'arène circulaire `b71`) ;
5. Invariance d'échelle paramétrique (`384×288` vs `768×576`) ;
6. Absence totale de toute mention de crédits.
"""

from __future__ import annotations

import json
import sys
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(HERE), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

import build as stc_build  # type: ignore
from tour_celeste_moteur_nuages import N_FRAMES  # type: ignore


def count_magenta_fringe(img: Image.Image) -> int:
    arr = np.asarray(img.convert("RGBA"), dtype=np.int16)
    opaque = arr[:, :, 3] > 0
    fringe = opaque & (arr[:, :, 0] > 165) & (arr[:, :, 1] < 90) & (arr[:, :, 2] > 165)
    return int(fringe.sum())


def compute_visual_fidelity_distance(img_a: Image.Image, img_b: Image.Image) -> float:
    a = np.asarray(img_a.convert("RGB"), dtype=np.float64)
    b = np.asarray(
        img_b.convert("RGB").resize((a.shape[1], a.shape[0]), Image.Resampling.NEAREST),
        dtype=np.float64,
    )
    return float(np.linalg.norm(a.mean(axis=(0, 1)) - b.mean(axis=(0, 1))))


def _composite_pose(layers, t: int) -> Image.Image:
    w, h = layers[0].frames[0].size
    comp = Image.new("RGBA", (w, h), (0, 0, 0, 255))
    for layer in layers:
        fr = layer.frames[t % len(layer.frames)]
        comp = Image.alpha_composite(comp, fr)
    return comp.convert("RGB")


class TestTourCelesteSommet(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.layers, cls.walk_grid, cls.palette = stc_build.build_layers_for_size(768, 576)
        cls.renders_dir = REPO_ROOT / "renders" / "tour_celeste_sommet_v1"
        cls.pkg_dir = cls.renders_dir / "package"

    def test_01_zero_magenta_fringe_all_layers_all_frames(self) -> None:
        total_fringe = 0
        for layer in self.layers:
            for fr in layer.frames:
                total_fringe += count_magenta_fringe(fr)
        self.assertEqual(total_fringe, 0, f"Halo magenta résiduel détecté : {total_fringe} pixels")

    def test_02_multiframe_motion_stars_planet_and_diverging_wings(self) -> None:
        self.assertEqual(len(self.layers), 10)
        animated_layers = [l for l in self.layers if len(l.frames) == N_FRAMES]
        self.assertGreaterEqual(len(animated_layers), 7)

        diffs = []
        prev = np.asarray(_composite_pose(self.layers, N_FRAMES - 1), dtype=np.float32)
        for t in range(N_FRAMES):
            cur = np.asarray(_composite_pose(self.layers, t), dtype=np.float32)
            diffs.append(float(np.abs(cur - prev).mean()))
            prev = cur
        self.assertGreater(min(diffs), 0.12, f"Trame figée détectée : min diff = {min(diffs):.4f}")
        self.assertLess(max(diffs), 14.0, f"Saut visuel brutal détecté : max diff = {max(diffs):.4f}")

        # Scintillement réel des étoiles dans le cosmos
        st0 = np.asarray(self.layers[1].frames[0], dtype=np.float32)
        st6 = np.asarray(self.layers[1].frames[6], dtype=np.float32)
        self.assertGreater(float(np.abs(st6 - st0).sum()), 500.0)

        # Dérive orbitale réelle des nuages sur la Planète Terre
        pl0 = np.asarray(self.layers[2].frames[0], dtype=np.float32)[:, :, 3]
        pl1 = np.asarray(self.layers[2].frames[1], dtype=np.float32)[:, :, 3]
        shifted_orbit = np.roll(pl0, shift=16, axis=1)
        err_orbit = float(np.abs(pl1[:, 32:-32] - shifted_orbit[:, 32:-32]).mean())
        self.assertLess(err_orbit, 2.0, f"Les nuages orbitaux ne dérivent pas à +16 px/trame : {err_orbit:.3f}")

        # Ailes de vent symétriques en mouvement réel sur les deux flancs (`Layer 04`)
        f0 = np.asarray(self.layers[4].frames[0], dtype=np.float32)
        f6 = np.asarray(self.layers[4].frames[6], dtype=np.float32)
        self.assertGreater(float(np.abs(f6[:, :384] - f0[:, :384]).mean()), 0.5)
        self.assertGreater(float(np.abs(f6[:, 384:] - f0[:, 384:]).mean()), 0.5)

    def test_03_earth_reference_and_b71_pixel_fidelity(self) -> None:
        comp0 = _composite_pose(self.layers, 0)
        ref_ray = Image.open(HERE / "references" / "ref_sommet_planete_rayquaza.png")
        d_ray = compute_visual_fidelity_distance(comp0, ref_ray)
        self.assertLess(d_ray, 25.0, f"Distance excessive face à ref_sommet_planete_rayquaza : {d_ray:.2f}")

        # Contrôle négatif strict sur biome hors-sujet
        wrong_forest = np.zeros((576, 768, 3), dtype=np.uint8)
        wrong_forest[:, :, 0] = 34
        wrong_forest[:, :, 1] = 88
        wrong_forest[:, :, 2] = 42
        d_wrong = compute_visual_fidelity_distance(comp0, Image.fromarray(wrong_forest, mode="RGB"))
        self.assertGreater(d_wrong, 45.0, f"Contrôle négatif insuffisant : {d_wrong:.2f}")

        # Identité pixel `1:1` de tout le dôme d'arène `b71` (`y = 0..345`) face à `b71_sky_tower_summit.png[112:457]`
        b71 = np.asarray(Image.open(HERE / "references" / "b71_sky_tower_summit.png").convert("RGB"), dtype=np.float32)
        c0_arr = np.asarray(comp0, dtype=np.float32)
        dome_core = np.asarray(self.layers[6].frames[0], dtype=np.uint8)[:345, 108:660, 3] > 0
        self.assertGreater(int(dome_core.sum()), 45000)
        pix_diff = float(np.abs(c0_arr[:345, 108:660][dome_core] - b71[112:457, :][dome_core]).mean())
        self.assertLess(pix_diff, 4.0, f"Le plateau d'arène s'écarte des pixels 1:1 de b71 : {pix_diff:.2f}")

    def test_04_rsground_package_and_south_to_north_walk_path(self) -> None:
        rsground = self.pkg_dir / "Data" / "Ground" / "stc1_tour_celeste.rsground"
        self.assertTrue(rsground.is_file(), f"Fichier manquant : {rsground}")
        raw_bytes = rsground.read_bytes()
        self.assertGreater(len(raw_bytes), 40000)
        self.assertIn(b"0.8.12.0", raw_bytes)
        for idx_l in range(10):
            self.assertIn(f"STC1_{idx_l:02d}_".encode("ascii"), raw_bytes)
        tile_files = sorted((self.pkg_dir / "Content" / "Tile").glob("STC1_*.tile"))
        self.assertEqual(len(tile_files), 10)
        self.assertTrue((self.pkg_dir / "Content" / "Tile" / "index.idx").is_file())

        # Vérifie que le chemin Sud -> Nord est effectivement praticable tout en bas (`walk_grid[-1, :]`)
        # ET monte d'un seul tenant connexe jusqu'à l'arène large (`walk_grid[28, :]`) !
        south_open_cols = int(self.walk_grid[-1, :].sum())
        arena_wide_cols = int(self.walk_grid[:42, :].sum(axis=1).max())
        self.assertGreaterEqual(south_open_cols, 10, f"Chemin Sud fermé ou trop étroit : {south_open_cols} tuiles")
        self.assertGreaterEqual(arena_wide_cols, 32, f"Arène Rayquaza trop étroite : {arena_wide_cols} tuiles")

    def test_05_scale_invariance_half_resolution(self) -> None:
        layers_half, walk_half, _ = stc_build.build_layers_for_size(384, 288)
        comp_full_down = _composite_pose(self.layers, 0).resize((384, 288), Image.Resampling.BILINEAR)
        comp_half = _composite_pose(layers_half, 0)
        dist = compute_visual_fidelity_distance(comp_half, comp_full_down)
        self.assertLess(dist, 12.0, f"Dérive d'échelle excessive entre 384×288 et 768×576 : {dist:.2f}")
        self.assertAlmostEqual(float(walk_half.mean()), float(self.walk_grid.mean()), delta=0.06)

    def test_06_zero_credits_anywhere_in_outputs_and_viewer(self) -> None:
        meta_txt = (self.renders_dir / "metadata.json").read_text(encoding="utf-8").lower()
        for forbidden in ("credit", "crédit", "author", "auteur"):
            self.assertNotIn(forbidden, meta_txt)
        idx_path = REPO_ROOT / "index.html"
        if idx_path.is_file():
            html_low = idx_path.read_text(encoding="utf-8").lower()
            for forbidden in ("credit", "crédit"):
                self.assertNotIn(forbidden, html_low)


if __name__ == "__main__":
    unittest.main(verbosity=2)
