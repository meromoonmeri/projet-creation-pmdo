#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mine_magma_entree_v1` (`MME1`, PMDO 0.8.12.0).

Vérifie :
1. Gouffres latéraux découpés en `#FF00FF` pur dans `decor_entree_veines_magenta.png` et zéro liseré prune.
2. **Mer et lacs de magma & lave restaurés dans les gouffres latéraux `#FF00FF` (`sea_darken=True`)** tout en
   maintenant **ZÉRO lave sur le massif rocheux et l'arche de l'entrée Nord** + basalte noir sculpté bien visible.
3. **Rive de magma visqueux strictement limitée aux berges basses (`0` sur les pitons pointus en hauteur)**.
4. Animation active de la mer de magma, des courants en ébullition et des braises `W04`.
5. Zéro mini-volcan et chaussée praticable Sud -> Nord continue de `y = 71` jusqu'au seuil de la grotte.
6. Invariance d'échelle (`0.5×`) sans damier et zéro mention interdite dans tous les livrables.
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
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

import source.mine_magma_entree_v1.build as entree_build  # type: ignore


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

    def test_01_magenta_chasms_in_raw_and_zero_purple_in_render(self) -> None:
        raw = np.asarray(Image.open(entree_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.int16)
        pure_mag = (raw[:, :, 0] == 255) & (raw[:, :, 1] == 0) & (raw[:, :, 2] == 255)
        self.assertGreater(int(pure_mag.sum()), 170_000)
        plum = (~pure_mag) & (raw[:, :, 0] - raw[:, :, 1] >= 16) & (raw[:, :, 2] - raw[:, :, 1] >= 10)
        self.assertEqual(int(plum.sum()), 0, f"Pixels prune restants dans le brut : {int(plum.sum())}")

        for idx, pose in enumerate((self.pose0, self.pose1, self.pose2)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            fringe = (r - g >= 18) & (b - g >= 12)
            self.assertEqual(int(fringe.sum()), 0, f"Liseré violet détecté sur pose {idx}: {int(fringe.sum())}")

    def test_02_lateral_magma_lakes_restored_zero_arch_lava_and_sculpted_black_rock(self) -> None:
        # 1. Les deux lacs latéraux contiennent bien le magma et la lave ardente assombrie (`R > 130` & `R > G + 40`)
        for idx, pose in enumerate((self.pose0, self.pose1, self.pose2)):
            hot_lava = (pose[:, :, 0].astype(int) > 130) & (pose[:, :, 0].astype(int) - pose[:, :, 1].astype(int) > 40)
            self.assertGreater(int(hot_lava.sum()), 40_000, f"Les lacs de magma & lave doivent être présents dans MME1 (pose {idx})")
            # 2. ZÉRO lave sur le massif rocheux et l'arche de l'entrée Nord (`[90:240, 290:478]`)
            arch_box = pose[90:240, 290:478, :3]
            arch_hot = (arch_box[:, :, 0] > 110).sum()
            self.assertEqual(int(arch_hot), 0, f"Zéro lave sur le rocher de l'arche d'entrée Nord ({int(arch_hot)} px)")

        arch_layer = np.asarray(
            Image.open(self.renders / "layers" / "06_massif_et_arche_roche_noire.png").convert("RGBA"),
            dtype=np.float32,
        )
        cliff_layer = np.asarray(
            Image.open(self.renders / "layers" / "05_falaises_roche_noire_magma.png").convert("RGBA"),
            dtype=np.float32,
        )
        for name, lyr in (("06_massif", arch_layer), ("05_falaises", cliff_layer)):
            opaque = lyr[:, :, 3] > 0
            self.assertGreater(int(opaque.sum()), 40_000)
            lum = 0.299 * lyr[opaque, 0] + 0.587 * lyr[opaque, 1] + 0.114 * lyr[opaque, 2]
            self.assertGreater(float(lum.mean()), 24.0, f"La couche {name} doit rester bien visible et sculptée")
            self.assertLess(float(lum.mean()), 46.0, f"La couche {name} doit rester en basalte noir volcanique POV PMD")

    def test_03_viscous_shoreline_on_low_rims_only_not_tall_spires(self) -> None:
        layer_slugs = [l["slug"] for l in self.metrics["layers"]]
        self.assertIn("04_rive_magma_visqueux_bordure", layer_slugs)

        layers, _, _ = entree_build.build_layers_for_size()
        shore_entry = [l for l in layers if l.slug == "04_rive_magma_visqueux_bordure"][0]
        self.assertEqual(len(shore_entry.frames), 15)
        self.assertEqual(shore_entry.frame_length, 8)

        f0 = np.asarray(shore_entry.frames[0], dtype=np.uint8)
        f7 = np.asarray(shore_entry.frames[7], dtype=np.uint8)
        self.assertEqual(int(((f0[:, :, 3] > 0) & (f0[:, :, 3] < 255)).sum()), 0)
        self.assertGreater(int((f0[:, :, 3] == 255).sum()), 1_500)
        shore_diff = np.abs(f0[:, :, :3].astype(int) - f7[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((shore_diff > 0).sum()), 600, "La rive visqueuse doit s'animer sur les berges basses")
        self.assertEqual(int((f0[275:305, 80:95, 3] > 0).sum()), 0, "Zéro animation de rive sur les pitons en hauteur")

    def test_04_boiling_magma_sea_animation(self) -> None:
        diff01 = np.abs(self.pose0[:, :, :3].astype(int) - self.pose1[:, :, :3].astype(int)).max(axis=2)
        diff12 = np.abs(self.pose1[:, :, :3].astype(int) - self.pose2[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff01 >= 6).sum()), 25_000)
        self.assertGreater(int((diff12 >= 6).sum()), 25_000)

    def test_05_zero_mini_volcanoes_and_walkable_south_north_causeway(self) -> None:
        self.assertFalse((REPO_ROOT / "source" / "mine_magma_entree_v1" / "bruts" / "ilot_colonne_magma_magenta.png").exists())
        _, walk_grid, _ = entree_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 550)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        north_ids = set(lbl[:38, :].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & north_ids), "La chaussée doit relier le bord Sud jusqu'au seuil de la caverne Nord")

    def test_06_scale_invariance_and_zero_credits(self) -> None:
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
