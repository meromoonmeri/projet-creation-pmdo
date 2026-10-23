#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mine_magma_arene_v1` (`MMA1`, PMDO 0.8.12.0).

Vérifie :
1. Zéro mini-volcan dans `bruts/`.
2. Découpes `#FF00FF` pures dans `decor_arene_veines_magenta.png` et zéro liseré violet/prune.
3. **Zéro lave à l'entrée Nord de Groudon** (arche & massif Nord `100 %` roche noire + gouffre noir `#050404`)
   et **mer de magma légèrement plus sombre** (`sea_darken=True` sur `d41p41a` `1×`, `R >= G > B`).
4. **Lames Pangéennes (*Precipice Blades*) jaillissant de la lave autour de l'arène** (`07_lames_pangeennes_groudon`,
   `24 × 5 = 120` ticks, `alpha ∈ {0, 255}`, `0` empiètement sur le plateau praticable), **4 colonnes géantes
   ascendantes (`dy == -8 px/pose`)** et **rive visqueuse limitée aux rives basses (`0` sur rochers hauts)**.
5. Animation cyclique `120` ticks et pont Sud -> plateau `Ω` de Groudon continu.
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

    def test_02_magenta_cutouts_and_zero_purple_bleed(self) -> None:
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

    def test_03_zero_lava_at_north_entrance_and_darker_magma_sea(self) -> None:
        # 1. Zéro lave / coulée sur tout le massif rocheux et l'entrée Nord de Groudon + cœur noir profond `#050404`
        raw768 = np.asarray(
            Image.open(arene_build.DECOR_MAGENTA_RAW).convert("RGB").resize((768, 576), Image.Resampling.NEAREST),
            dtype=np.uint8,
        )
        north_rock = ~((raw768[:, :, 0] == 255) & (raw768[:, :, 1] == 0) & (raw768[:, :, 2] == 255))
        north_arch_hot = ((self.pose0[:240, 180:588, 0] > 140) & north_rock[:240, 180:588]).sum()
        self.assertEqual(int(north_arch_hot), 0, f"Zéro lave tolérée à l'entrée Nord de Groudon ({int(north_arch_hot)} px)")
        cave_patch = self.pose0[150:195, 366:402, :3].astype(float)
        self.assertLess(float(cave_patch.mean()), 8.0, "L'entrée Nord-Sud de Groudon doit rester d'un noir profond")

        # 2. Mer de magma de la caldeira légèrement plus sombre que la référence brute `d41p41a`
        layers, _, _ = arene_build.build_layers_for_size()
        sea_entry = [l for l in layers if l.slug == "00_mer_caldeira_magma_dcp"][0]
        self.assertEqual(len(sea_entry.frames), 12)
        self.assertEqual(sea_entry.frame_length, 10)
        sea96 = np.asarray(sea_entry.frames[0], dtype=np.float32)[:96, :96, :3]
        ref96 = np.asarray(
            Image.open(
                REPO_ROOT / "source" / "mine_magma_arene_v1" / "references" / "dark_crater_pit" / "dark_crater_pit_lava_96x96_f00.png"
            ).convert("RGB"),
            dtype=np.float32,
        )
        lum_sea = float(0.299 * sea96[..., 0].mean() + 0.587 * sea96[..., 1].mean() + 0.114 * sea96[..., 2].mean())
        lum_ref = float(0.299 * ref96[..., 0].mean() + 0.587 * ref96[..., 1].mean() + 0.114 * ref96[..., 2].mean())
        self.assertLess(lum_sea, lum_ref - 20.0, f"La mer de magma doit être légèrement plus sombre ({lum_sea:.1f} vs {lum_ref:.1f})")
        self.assertGreater(lum_sea, 65.0, "La mer de magma doit rester une vraie lave incandescente")
        self.assertEqual(int((sea96[..., 2] > sea96[..., 1] + 2.0).sum()), 0)

    def test_04_erupting_precipice_blades_columns_and_low_shoreline(self) -> None:
        layers, _, _ = arene_build.build_layers_for_size()
        shore_entry = [l for l in layers if l.slug == "03_rive_magma_visqueux_bordure"][0]
        floor_entry = [l for l in layers if l.slug == "04_plateau_et_pont_arene"][0]
        blade_entry = [l for l in layers if l.slug == "07_lames_pangeennes_groudon"][0]
        col_entry = [l for l in layers if l.slug == "08_colonnes_geantes_magma_dcp"][0]

        # 1. Lames Pangéennes (`07_lames_pangeennes_groudon`) : 24 poses × 5 ticks = 120 ticks, jaillissement actif !
        self.assertEqual(len(blade_entry.frames), 24)
        self.assertEqual(blade_entry.frame_length, 5)
        b0 = np.asarray(blade_entry.frames[0], dtype=np.uint8)
        b6 = np.asarray(blade_entry.frames[6], dtype=np.uint8)
        self.assertEqual(int(((b0[:, :, 3] > 0) & (b0[:, :, 3] < 255)).sum()), 0)
        self.assertGreater(int((b0[:, :, 3] == 255).sum()), 12_000, "Couronne de Lames Pangéennes requise autour de l'arène")
        blade_motion = int((np.abs(b0.astype(int) - b6.astype(int)).max(axis=2) > 20).sum())
        self.assertGreater(blade_motion, 5_000, "Les Lames Pangéennes doivent jaillir dynamiquement de la lave")
        floor_opaque = np.asarray(floor_entry.frames[0], dtype=np.uint8)[:, :, 3] > 0
        self.assertEqual(int(((b0[:, :, 3] > 0) & floor_opaque).sum()), 0, "Zéro empiètement sur le plateau praticable")

        # 2. Rive visqueuse limitée aux rives basses (`0` sur rochers hauts `y < 305`)
        f0 = np.asarray(shore_entry.frames[0], dtype=np.uint8)
        f7 = np.asarray(shore_entry.frames[7], dtype=np.uint8)
        self.assertEqual(int((f0[:305, :, 3] > 0).sum()), 0)
        self.assertGreater(int((np.abs(f0.astype(int) - f7.astype(int)).max(axis=2) > 15).sum()), 1_500)

        # 3. 4 Colonnes géantes ascendantes (`dy == -8 px/pose` sur 24 poses)
        self.assertEqual(len(col_entry.frames), 24)
        self.assertEqual(col_entry.frame_length, 5)
        cols_np = [np.asarray(im, dtype=np.uint8) for im in col_entry.frames]
        self.assertGreater(int((cols_np[0][0, :, 3] > 0).sum()), 60)
        for t in range(24):
            c0 = cols_np[t][60:340, 48:116, :3].astype(float)
            c1 = cols_np[(t + 1) % 24][60:340, 48:116, :3].astype(float)
            best_dy = min(
                range(-16, 17),
                key=lambda dy: float(
                    np.abs(c1[max(0, -dy) + dy : min(c0.shape[0], c0.shape[0] - dy) + dy] - c0[max(0, -dy) : min(c0.shape[0], c0.shape[0] - dy)]).mean()
                ),
            )
            self.assertEqual(best_dy, -8, f"La colonne doit s'élever de -8 px/pose à t={t} (obtenu {best_dy})")

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
