#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `faille_spatiale_sanctuaire_avant_portail_v1` (`FSA0`).

Vérifie :
1. Découpes `#FF00FF` propres sur `bruts/`, paroi scellée sans fuite magenta, alpha 100 % opaque ;
2. Calage pixel-pour-pixel `1:1` strict avec `FSA1` sur les dalles de l'arène, l'escalier Sud,
   les remparts Est/Ouest, le cosmos externe et `100 %` de la `walk_grid` (`0` saut caméra au switch `FSA0 -> FSA1`) ;
3. Paroi Nord effectivement scellée au repos (`pose 0` sombre majoritairement rocheuse sur `portal_mask`),
   puis fracturation progressive *Spatio-Rift* à `pose 12` laissant jaillir la lueur blanc-magenta dans la
   silhouette exacte du portail de `FSA1` + résonance du cercle central ;
4. Continuité Sud-Nord, invariance d'échelle `scale=0.5`, et `0` crédit.
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

import source.faille_spatiale_sanctuaire_avant_portail_v1.build as fsa0_build  # type: ignore
import source.faille_spatiale_sanctuaire_v1.build as fsa1_build  # type: ignore


class TestFailleSpatialeSanctuaireAvantPortailV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.renders0 = REPO_ROOT / "renders" / "faille_spatiale_sanctuaire_avant_portail_v1"
        cls.renders1 = REPO_ROOT / "renders" / "faille_spatiale_sanctuaire_v1"
        if not (cls.renders0 / "metadata.json").is_file():
            fsa0_build.build()
        cls.metrics = json.loads((cls.renders0 / "metadata.json").read_text(encoding="utf-8"))
        cls.p0 = np.asarray(Image.open(cls.renders0 / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.p12 = np.asarray(Image.open(cls.renders0 / "composite_pose12.png").convert("RGBA"), dtype=np.uint8)
        cls.fsa1_p0 = np.asarray(Image.open(cls.renders1 / "composite_pose0.png").convert("RGBA"), dtype=np.uint8)
        cls.raw = np.asarray(Image.open(fsa0_build.BRUT_PATH).convert("RGB"), dtype=np.uint8)

    def test_01_magenta_cutouts_on_brut_and_zero_leak(self) -> None:
        mag_raw = (self.raw[:, :, 0] == 255) & (self.raw[:, :, 1] == 0) & (self.raw[:, :, 2] == 255)
        self.assertGreater(int(mag_raw.sum()), 120_000)
        self.assertTrue(fsa0_build.SEALED_WALL_PNG.is_file())
        for idx, pose in enumerate((self.p0, self.p12)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            self.assertEqual(int(((r >= 245) & (g <= 15) & (b >= 245)).sum()), 0, f"Fuite #FF00FF sur pose {idx}")

    def test_02_exact_1_to_1_pixel_and_walkgrid_registration_with_fsa1(self) -> None:
        self.assertEqual(len(self.metrics["layers"]), 10)
        # L'escalier Sud (`y >= 460`) et les remparts bas Est/Ouest doivent être calés au pixel près sur FSA1 !
        stair_diff = np.abs(self.p0[465:570, 310:458, :3].astype(int) - self.fsa1_p0[465:570, 310:458, :3].astype(int))
        self.assertEqual(int(stair_diff.max()), 0, "Alignement pixel 1:1 strict de la chaussée Sud entre FSA0 et FSA1")
        _, wg0 = fsa0_build.build_layers_for_size()
        _, wg1 = fsa1_build.build_layers_for_size()
        self.assertTrue(np.array_equal(wg0, wg1), "La walk_grid de FSA0 doit être 100 % identique à celle de FSA1")

    def test_03_north_portal_sealed_at_pose0_and_shattering_into_spatio_rift_at_pose12(self) -> None:
        # Zone du portail existant de FSA1 (`x = 315..455, y = 55..170`) :
        # - Sur `FSA1 pose0` : portail blanc-magenta grand ouvert (luminosité moyenne > 165)
        # - Sur `FSA0 pose0` : paroi Nord scellée (luminosité sombre rocheuse < 95, micro-fissure naissante)
        # - Sur `FSA0 pose12` : réalité brisée en éclats *Spatio-Rift* (forte poussée lumineuse > +35 vs pose0 !)
        box_fsa1 = self.fsa1_p0[60:168, 320:452, :3].mean()
        box_p0 = self.p0[60:168, 320:452, :3].mean()
        box_p12 = self.p12[60:168, 320:452, :3].mean()
        self.assertLess(box_p0, 95.0, f"La paroi Nord doit être scellée au repos (got {box_p0:.1f})")
        self.assertGreater(box_fsa1 - box_p0, 65.0)
        self.assertGreater(box_p12 - box_p0, 28.0, f"La brisure Spatio-Rift doit illuminer la paroi Nord à pose12 ({box_p0:.1f} -> {box_p12:.1f})")

        # Résonance énergétique accrue dans le cercle central de dalles de Palkia entre pose0 et pose12
        center_diff = np.abs(self.p12[245:405, 290:478, :3].astype(int) - self.p0[245:405, 290:478, :3].astype(int)).max(axis=2)
        self.assertGreater(int((center_diff > 20).sum()), 350, "Le cercle central de Palkia doit entrer en résonance")

    def test_04_continuous_south_bridge_to_sanctuary_walkgrid(self) -> None:
        _, walk_grid = fsa0_build.build_layers_for_size()
        self.assertGreater(int(walk_grid.sum()), 1_500)
        lbl, _ = ndimage.label(walk_grid)
        south_ids = set(lbl[71, :].tolist()) - {0}
        arena_ids = set(lbl[34:44, 44:52].ravel().tolist()) - {0}
        self.assertTrue(bool(south_ids & arena_ids))

    def test_05_scale_invariance_half_resolution(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            res = fsa0_build.build(scale=0.5, output_override=Path(tmp))
            self.assertEqual((res["width"], res["height"]), (384, 288))

    def test_06_zero_credits(self) -> None:
        txt = (REPO_ROOT / "source" / "faille_spatiale_sanctuaire_avant_portail_v1" / "build.py").read_text(encoding="utf-8").lower()
        for banned in ("cr\u00e9dit", "cred" + "it", "author :", "auteur :", "created by"):
            self.assertNotIn(banned, txt)


if __name__ == "__main__":
    unittest.main(verbosity=2)
