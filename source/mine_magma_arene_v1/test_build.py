#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mine_magma_arene_v1` (`MMA1`, PMDO 0.8.12.0).

Vérifie :
1. Suppression stricte à `100 %` des petits volcans (`0` fichier volcan, `0` îlot volcanique).
2. Veines & mer de magma `100 %` `#FF00FF` dans `decor_arene_veines_magenta.png` et zéro liseré prune.
3. Cohérence géologique `100 %` roche noire magma avec l'entrée `MME1` (`mean luminance < 36`, `0` grès ocre).
4. **Animation visqueuse de rive & croûte de bordure rocher** (`03_rive_magma_visqueux_bordure`,
   `15 × 8` ticks, `alpha ∈ {0, 255}`) + **cascade Nord strictement contenue sous l'arche rocheuse**.
5. Animation canonique matérielle `H26P01.bpl` dans la mer et les veines + pont Sud -> plateau de Groudon continu.
6. Invariance d'échelle (`0.5×`) et zéro mention interdite partout.
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

import source.mine_magma_arene_v1.build as arene_build  # type: ignore


class TestMineMagmaAreneV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders = REPO_ROOT / "renders" / "mine_magma_arene_v1"
        if not (cls.renders / "metadata.json").is_file():
            arene_build.build()
        cls.metrics = json.loads((cls.renders / "metadata.json").read_text(encoding="utf-8"))
        cls.pose0 = np.asarray(Image.open(cls.renders / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.pose1 = np.asarray(Image.open(cls.renders / "frames" / "frame_06.png").convert("RGBA"), dtype=np.uint8)
        cls.pose2 = np.asarray(Image.open(cls.renders / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)

    def test_01_zero_mini_volcanoes_anywhere(self) -> None:
        bruts = REPO_ROOT / "source" / "mine_magma_arene_v1" / "bruts"
        self.assertFalse((bruts / "ilot_colonne_magma_magenta.png").exists())
        for f in bruts.iterdir():
            self.assertNotIn("volcan", f.name.lower())
            self.assertNotIn("ilot_colonne", f.name.lower())

    def test_02_magenta_veins_and_zero_purple_bleed(self) -> None:
        raw = np.asarray(Image.open(arene_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.int16)
        pure_mag = (raw[:, :, 0] == 255) & (raw[:, :, 1] == 0) & (raw[:, :, 2] == 255)
        self.assertGreater(int(pure_mag.sum()), 400_000)
        plum = (~pure_mag) & (raw[:, :, 0] - raw[:, :, 1] >= 16) & (raw[:, :, 2] - raw[:, :, 1] >= 10)
        self.assertEqual(int(plum.sum()), 0, f"Pixels prune restants dans le brut : {int(plum.sum())}")

        for idx, pose in enumerate((self.pose0, self.pose1, self.pose2)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            fringe = (r - g >= 18) & (b - g >= 12)
            self.assertEqual(int(fringe.sum()), 0, f"Liseré violet détecté sur pose {idx}: {int(fringe.sum())}")

    def test_03_coherent_black_magma_rock_matching_entrance(self) -> None:
        cliff_layer = np.asarray(
            Image.open(self.renders / "layers" / "06_falaises_roche_noire_magma.png").convert("RGBA"),
            dtype=np.float32,
        )
        opaque = cliff_layer[:, :, 3] > 0
        self.assertGreater(int(opaque.sum()), 20_000)
        lum = 0.299 * cliff_layer[opaque, 0] + 0.587 * cliff_layer[opaque, 1] + 0.114 * cliff_layer[opaque, 2]
        self.assertLess(float(lum.mean()), 36.0, "Les falaises de l'arène doivent être en roche noire magma cohérente avec MME1")
        yellow_sandstone = (cliff_layer[opaque, 0] >= 150) & (cliff_layer[opaque, 1] >= 80)
        self.assertEqual(int(yellow_sandstone.sum()), 0)

    def test_04_viscous_shoreline_rock_border_and_dark_crater_columns(self) -> None:
        layers, _, _ = arene_build.build_layers_for_size()
        sea_entry = [l for l in layers if l.slug == "00_mer_caldeira_magma_dcp"][0]
        shore_entry = [l for l in layers if l.slug == "03_rive_magma_visqueux_bordure"][0]
        fall_entry = [l for l in layers if l.slug == "08_cascade_et_colonnes_geantes"][0]
        self.assertEqual(len(sea_entry.frames), 12)
        self.assertEqual(sea_entry.frame_length, 10)
        ref96 = np.asarray(
            Image.open(REPO_ROOT / "source" / "mine_magma_arene_v1" / "references" / "dark_crater_pit" / "dark_crater_pit_lava_96x96_f00.png").convert("RGB"),
            dtype=np.uint8,
        )
        self.assertTrue(np.array_equal(np.asarray(sea_entry.frames[0], dtype=np.uint8)[:96, :96, :3], ref96))

        self.assertEqual(len(shore_entry.frames), 15)
        self.assertEqual(shore_entry.frame_length, 8)
        f0 = np.asarray(shore_entry.frames[0], dtype=np.uint8)
        f7 = np.asarray(shore_entry.frames[7], dtype=np.uint8)
        self.assertEqual(int(((f0[:, :, 3] > 0) & (f0[:, :, 3] < 255)).sum()), 0)
        self.assertGreater(int((np.abs(f0.astype(int) - f7.astype(int)).max(axis=2) > 15).sum()), 2_500)

        # Les 4 colonnes géantes `Dark Crater Pit` : 24 poses × 5 ticks (`120` ticks),
        # montée verticale pure `dy == -8 px/pose` sans étirement, bouche bouillonnante active,
        # zéro écume de rive sur les pitons/falaises en hauteur, et entrée noire Nord-Sud de Groudon entre 2 fentes !
        self.assertEqual(len(fall_entry.frames), 24)
        self.assertEqual(fall_entry.frame_length, 5)
        cols_np = [np.asarray(im, dtype=np.uint8) for im in fall_entry.frames]
        fall0 = cols_np[0]
        self.assertGreater(int((fall0[0, :, 3] > 0).sum()), 60, "Les 4 colonnes géantes doivent sortir par le bord haut y = 0")
        self.assertEqual(int((fall0[:40, 260:508, 3] > 0).sum()), 0, "Zéro débordement de cascade centrale au-dessus des cornes Nord")

        # Vérifie mathématiquement que chaque transition `t -> t+1` MONTE réellement vers le haut (`dy == -8 px`)
        for t in range(24):
            c0 = cols_np[t][60:340, 62:118, :3].astype(float)
            c1 = cols_np[(t + 1) % 24][60:340, 62:118, :3].astype(float)
            best_dy = min(
                range(-16, 17),
                key=lambda dy: float(
                    np.abs(c1[max(0, -dy) + dy : min(c0.shape[0], c0.shape[0] - dy) + dy] - c0[max(0, -dy) : min(c0.shape[0], c0.shape[0] - dy)]).mean()
                ),
            )
            self.assertEqual(best_dy, -8, f"La colonne doit s'élever de -8 px/pose à t={t} (obtenu {best_dy})")

        # Zéro animation de rive sur la couronne haute Nord (`y < 305`) et sur les pitons hauts isolés (`(56, 110)`, `(712, 110)`)
        self.assertEqual(int((f0[:305, :, 3] > 0).sum()), 0, "Zéro animation de rive sur les rochers hauts du Nord et pitons hauts")

        # Entrée Nord-Sud de Groudon : noir profond au centre (`x ∈ [366..402], y ∈ [150..195]`) encadré par 2 fentes de magma distinctes !
        cave_patch = self.pose0[150:195, 366:402, :3].astype(float)
        self.assertLess(float(cave_patch.mean()), 8.0, "L'entrée Nord-Sud de Groudon doit laisser du noir profond au centre")
        left_cleft_hot = (self.pose0[95:210, 310:348, 0] > 180).sum()
        right_cleft_hot = (self.pose0[95:210, 420:458, 0] > 180).sum()
        self.assertGreater(int(left_cleft_hot), 800, "Fente de coulée de magma gauche requise")
        self.assertGreater(int(right_cleft_hot), 800, "Fente de coulée de magma droite requise")

    def test_05_canonical_palette_cycling_and_walkable_arena(self) -> None:
        diff01 = np.abs(self.pose0[:, :, :3].astype(int) - self.pose1[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff01 > 12).sum()), 20_000)

        _, walk_grid, _ = arene_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 750, f"Plateau d'arène trop étroit : {int(walk_grid.sum())} tuiles")
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        center_ids = set(lbl[36:46, 42:54].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & center_ids), "Le pont Sud doit rejoindre continûment le centre de l'arène")

    def test_06_scale_invariance_and_zero_credits(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res_half = arene_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual(res_half["width"], 384)
            self.assertEqual(res_half["height"], 288)
            p0 = np.asarray(Image.open(Path(tmp) / "composite_pose0.png").convert("RGBA"), dtype=int)
            fringe = (p0[:, :, 0] - p0[:, :, 1] >= 18) & (p0[:, :, 2] - p0[:, :, 1] >= 12)
            self.assertEqual(int(fringe.sum()), 0)

        targets = [
            REPO_ROOT / "source" / "mine_magma_arene_v1" / "build.py",
            REPO_ROOT / "index.html",
            REPO_ROOT / "apercu_mine_magma_multicalque_pmdo.html",
        ]
        for p in targets:
            txt = p.read_text(encoding="utf-8").lower()
            for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
                self.assertNotIn(banned, txt, f"Mention interdite dans {p.name}")


if __name__ == "__main__":
    unittest.main(verbosity=2)
