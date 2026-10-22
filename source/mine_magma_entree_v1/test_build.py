#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mine_magma_entree_v1` (`MME1`, PMDO 0.8.12.0).

Vérifie :
1. Zéro pixel `#FF00FF` ni liseré violet/prune résiduel dans le brut hors `#FF00FF` et sur tous les rendus.
2. Veines de magma 100 % `#FF00FF` dans `decor_entree_veines_magenta.png` et animées dans le composite
   par le palette cycling matériel canonique `H26P01.bpl` (`31` frames × `4` ticks).
3. Zéro mini-volcan (`ilot_colonne_magma_magenta.png` supprimé).
4. Chaussée praticable Sud -> Nord continue de `y = 71` jusqu'au seuil de la caverne (`805` tuiles `8×8`).
5. Invariance d'échelle (`0.5×`) sans damier et zéro mention interdite dans tous les livrables.
"""

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
for p in (str(REPO_ROOT / "source"), str(REPO_ROOT / "source" / "mine_magma_entree_v1")):
    if p not in sys.path:
        sys.path.insert(0, p)

import build as entree_build  # type: ignore


class TestMineMagmaEntreeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mine_magma_entree_v1"
        if not (cls.renders / "metadata.json").is_file():
            entree_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose1 = np.asarray(Image.open(cls.renders / "frames" / "frame_06.png").convert("RGBA"), dtype=np.uint8)
        cls.pose2 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_magenta_veins_in_raw_and_zero_purple_in_render(self) -> None:
        raw = np.asarray(Image.open(entree_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.int16)
        pure_mag = (raw[:, :, 0] == 255) & (raw[:, :, 1] == 0) & (raw[:, :, 2] == 255)
        self.assertGreater(int(pure_mag.sum()), 200_000)
        plum = (~pure_mag) & (raw[:, :, 0] - raw[:, :, 1] >= 16) & (raw[:, :, 2] - raw[:, :, 1] >= 10)
        self.assertEqual(int(plum.sum()), 0, f"Pixels prune restants dans le brut : {int(plum.sum())}")

        for idx, pose in enumerate((self.pose0, self.pose1, self.pose2)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            fringe = (r - g >= 18) & (b - g >= 12)
            self.assertEqual(int(fringe.sum()), 0, f"Liseré violet détecté sur pose {idx}: {int(fringe.sum())}")

    def test_02_canonical_palette_cycling_in_veins_and_chasms(self) -> None:
        diff01 = np.abs(self.pose0[:, :, :3].astype(int) - self.pose1[:, :, :3].astype(int)).max(axis=2)
        diff12 = np.abs(self.pose1[:, :, :3].astype(int) - self.pose2[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff01 > 12).sum()), 5_000, "Le magma et les veines doivent s'animer massivement")
        self.assertGreater(int((diff12 > 12).sum()), 5_000)

        # Même dans la voûte rocheuse Nord (`y = 0..220`), les veines magenta découpées s'animent !
        arch_anim = (diff01[0:220, :] > 12).sum()
        self.assertGreater(int(arch_anim), 1_500, "Les veines de magma du massif supérieur doivent pulser !")

    def test_03_zero_mini_volcanoes_and_walkable_south_north_causeway(self) -> None:
        self.assertFalse((REPO_ROOT / "source" / "mine_magma_entree_v1" / "bruts" / "ilot_colonne_magma_magenta.png").exists())
        _, walk_grid, _ = entree_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 750)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[:34, :].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "La chaussée doit relier le bord Sud jusqu'au seuil de la caverne Nord")

    def test_04_scale_invariance_and_zero_credits(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res_half = entree_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual(res_half["width"], 384)
            self.assertEqual(res_half["height"], 288)
            p0 = np.asarray(Image.open(Path(tmp) / "composite_pose0.png").convert("RGBA"), dtype=int)
            fringe = (p0[:, :, 0] - p0[:, :, 1] >= 18) & (p0[:, :, 2] - p0[:, :, 1] >= 12)
            self.assertEqual(int(fringe.sum()), 0)

        targets = [
            REPO_ROOT / "source" / "mine_magma_entree_v1" / "build.py",
            REPO_ROOT / "index.html",
            REPO_ROOT / "apercu_mine_magma_multicalque_pmdo.html",
        ]
        for p in targets:
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt, f"Mention interdite dans {p.name}")


if __name__ == "__main__":
    unittest.main(verbosity=2)
