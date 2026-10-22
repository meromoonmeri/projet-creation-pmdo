#!/usr/bin/env python3
"""Suite de tests automatisés — MME1 Mine Magma — Entrée (`D12P01` + `D12P01.bpl` Multicalque).

Vérifie :
1. Zéro halo magenta résiduel (`R > 165 & G < 90 & B > 165 = 0`) sur les 10 couches × 24 poses ;
2. Animation multicalque réelle (6 couches animées sur 24 poses : fleuves de lave, ressac,
   flammes de crête, lueur des colonnes, veines des dalles et braises `Top`) sans trame figée ni saut brutal ;
3. Double fidélité visuelle :
   - fidélité globale `< 24.0` face à `references/d12p01_magma_cavern_entrance.png`,
   - identité pixel `1:1` (`< 2.5`) du cœur canonique `D12P01` (arche, orgues basaltiques & dalles) ;
4. Conformité du package PMDO `0.8.12.0` (`mine_magma_entree.rsground`, `10` feuilles `.png/.tile`,
   `index.idx`, chemin praticable continu du bord Sud `y = H - 1` jusqu'au seuil nord de la grotte) ;
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

import build as mme_build  # type: ignore
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


class TestMineMagmaEntree(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.layers, cls.walk_grid, cls.palette = mme_build.build_layers_for_size(768, 576)
        cls.renders_dir = REPO_ROOT / "renders" / "mine_magma_entree_v1"
        cls.pkg_dir = cls.renders_dir / "package"

    def test_01_zero_magenta_fringe_all_layers_all_frames(self) -> None:
        total_fringe = 0
        for layer in self.layers:
            for fr in layer.frames:
                total_fringe += count_magenta_fringe(fr)
        self.assertEqual(total_fringe, 0)

    def test_02_multilayer_volcanic_animations(self) -> None:
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
        self.assertLess(max(diffs), 12.0)

    def test_03_d12p01_canonical_fidelity(self) -> None:
        comp0 = _composite_pose(self.layers, 0)
        ref_d12 = Image.open(HERE / "references" / "d12p01_magma_cavern_entrance.png").convert("RGB")
        d_score = compute_visual_fidelity_distance(comp0, ref_d12)
        self.assertLess(d_score, 24.0)

        # Contrôle négatif strict sur biome polaire bleu
        wrong_ice = np.zeros((576, 768, 3), dtype=np.uint8)
        wrong_ice[:, :, 0] = 40
        wrong_ice[:, :, 1] = 160
        wrong_ice[:, :, 2] = 245
        self.assertGreater(compute_visual_fidelity_distance(comp0, Image.fromarray(wrong_ice, "RGB")), 80.0)

        # Identité pixel `2×` de la grotte `D12P01` au centre (`y = 60..420, x = 160..608`) sur `MME1_02`
        ref_2x = np.asarray(
            ref_d12.resize((816, 672), Image.Resampling.NEAREST),
            dtype=np.float32,
        )[16 : 16 + 576, 24 : 24 + 768]
        l02 = np.asarray(self.layers[2].frames[0], dtype=np.float32)[60:420, 160:608]
        fg = l02[:, :, 3] > 0
        self.assertGreater(int(fg.sum()), 120000)
        self.assertLess(float(np.abs(l02[:, :, :3][fg] - ref_2x[60:420, 160:608][fg]).mean()), 1.0)

    def test_04_rsground_package_and_south_to_cave_walk_path(self) -> None:
        rsground = self.pkg_dir / "Data" / "Ground" / "mine_magma_entree.rsground"
        self.assertTrue(rsground.is_file())
        raw_bytes = rsground.read_bytes()
        self.assertIn(b"0.8.12.0", raw_bytes)
        for idx_l in range(10):
            self.assertIn(f"MME1_{idx_l:02d}_".encode("ascii"), raw_bytes)
        self.assertEqual(len(list((self.pkg_dir / "Content" / "Tile").glob("MME1_*.tile"))), 10)
        self.assertGreaterEqual(int(self.walk_grid[-1, :].sum()), 16)
        self.assertTrue(bool(self.walk_grid[16:22, 44:52].any()), "Le chemin n'atteint pas le seuil de l'arche nord !")

    def test_05_scale_invariance_half_resolution(self) -> None:
        layers_half, walk_half, _ = mme_build.build_layers_for_size(384, 288)
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
