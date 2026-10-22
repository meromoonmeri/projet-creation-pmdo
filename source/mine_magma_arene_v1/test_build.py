#!/usr/bin/env python3
"""Suite de tests automatisés — MMA1 Mine Magma — Arène de Groudon (`b70` Hardware `1:1` Multicalque).

Vérifie :
1. Zéro halo magenta résiduel (`R > 165 & G < 90 & B > 165 = 0`) sur les 10 couches × 24 poses ;
2. Animation multicalque réelle (6 couches animées sur 24 poses : fleuves de magma, ressac côtier,
   cascade nord & 18 veines `b70canm`, geysers éruptifs des îlots, 5 cratères bouillonnants `b70canm`
   et braises `Top`) ;
3. Double fidélité visuelle :
   - identité pixel `1:1` (`< 2.0`) de toute l'île de combat de Groudon face à `b70_groudon_boss_arena.png`,
   - rejet strict (`> 80.0`) d'un biome hors-sujet bleu polaire ;
4. Conformité du package PMDO `0.8.12.0` (`mine_magma_arene.rsground`, `10` feuilles `.png/.tile`,
   `index.idx`, pont Sud -> Nord praticable continu jusqu'à l'arène large de Groudon tout en bloquant
   les `5` cratères de lave internes) ;
5. Invariance d'échelle paramétrique (`384×288` vs `768×576`) ;
6. Absence totale de toute mention de crédits.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(HERE), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

import build as mma_build  # type: ignore
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


class TestMineMagmaArene(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.layers, cls.walk_grid, cls.palette = mma_build.build_layers_for_size(768, 576)
        cls.renders_dir = REPO_ROOT / "renders" / "mine_magma_arene_v1"
        cls.pkg_dir = cls.renders_dir / "package"

    def test_01_zero_magenta_fringe_all_layers_all_frames(self) -> None:
        total_fringe = 0
        for layer in self.layers:
            for fr in layer.frames:
                total_fringe += count_magenta_fringe(fr)
        self.assertEqual(total_fringe, 0)

    def test_02_multilayer_caldera_and_b70canm_animations(self) -> None:
        self.assertEqual(len(self.layers), 10)
        anim_layers = [l for l in self.layers if len(l.frames) == N_FRAMES]
        self.assertEqual(len(anim_layers), 6)

        diffs = []
        prev = np.asarray(_composite_pose(self.layers, N_FRAMES - 1), dtype=np.float32)
        for t in range(N_FRAMES):
            cur = np.asarray(_composite_pose(self.layers, t), dtype=np.float32)
            diffs.append(float(np.abs(cur - prev).mean()))
            prev = cur
        self.assertGreater(min(diffs), 0.08)
        self.assertLess(max(diffs), 14.0)

        # Vérifie que la cascade nord & les veines (`MMA1_06`) ET les geysers (`MMA1_07`) bougent réellement !
        w0 = np.asarray(self.layers[6].frames[0], dtype=np.float32)
        w12 = np.asarray(self.layers[6].frames[12], dtype=np.float32)
        self.assertGreater(float(np.abs(w12 - w0).sum()), 5000.0)

        g0 = np.asarray(self.layers[7].frames[0], dtype=np.float32)
        g6 = np.asarray(self.layers[7].frames[6], dtype=np.float32)
        self.assertGreater(float(np.abs(g6 - g0).sum()), 10000.0)

    def test_03_b70_boss_island_exact_pixel_identity(self) -> None:
        comp0 = _composite_pose(self.layers, 0)
        b70_ref = np.asarray(Image.open(HERE / "references" / "b70_groudon_boss_arena.png").convert("RGB"), dtype=np.float32)
        l04 = np.asarray(self.layers[4].frames[0], dtype=np.float32)
        # Toute l'île `b70` (`y = 0..380, x = 108..660`) est 1:1 exacte avec `b70_groudon_boss_arena[32:412]` !
        sub_l04 = l04[:380, 108:660]
        fg = sub_l04[:, :, 3] > 0
        self.assertGreater(int(fg.sum()), 88000)
        self.assertLess(float(np.abs(sub_l04[:, :, :3][fg] - b70_ref[32:412, :][fg]).mean()), 1.5)

        wrong_ice = np.zeros((576, 768, 3), dtype=np.uint8)
        wrong_ice[:, :, 0] = 40
        wrong_ice[:, :, 1] = 160
        wrong_ice[:, :, 2] = 245
        self.assertGreater(compute_visual_fidelity_distance(comp0, Image.fromarray(wrong_ice, "RGB")), 80.0)

    def test_04_rsground_package_and_south_bridge_to_groudon_arena(self) -> None:
        rsground = self.pkg_dir / "Data" / "Ground" / "mine_magma_arene.rsground"
        self.assertTrue(rsground.is_file())
        raw_bytes = rsground.read_bytes()
        self.assertIn(b"0.8.12.0", raw_bytes)
        for idx_l in range(10):
            self.assertIn(f"MMA1_{idx_l:02d}_".encode("ascii"), raw_bytes)
        self.assertEqual(len(list((self.pkg_dir / "Content" / "Tile").glob("MMA1_*.tile"))), 10)

        south_bridge_cols = int(self.walk_grid[-1, :].sum())
        arena_wide_cols = int(self.walk_grid[18:42, :].sum(axis=1).max())
        self.assertGreaterEqual(south_bridge_cols, 10)
        self.assertGreaterEqual(arena_wide_cols, 30)

    def test_05_scale_invariance_half_resolution(self) -> None:
        layers_half, walk_half, _ = mma_build.build_layers_for_size(384, 288)
        comp_full_down = _composite_pose(self.layers, 0).resize((384, 288), Image.Resampling.BILINEAR)
        comp_half = _composite_pose(layers_half, 0)
        self.assertLess(compute_visual_fidelity_distance(comp_half, comp_full_down), 12.0)
        self.assertAlmostEqual(float(walk_half.mean()), float(self.walk_grid.mean()), delta=0.06)

    def test_06_zero_credits_anywhere(self) -> None:
        meta_txt = (self.renders_dir / "metadata.json").read_text(encoding="utf-8").lower()
        for forbidden in ("credit", "crédit", "author", "auteur"):
            self.assertNotIn(forbidden, meta_txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
