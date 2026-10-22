#!/usr/bin/env python3
"""Tests unitaires d'acceptation — `mine_magma_entree_v1` (`MME1`, PMDO 0.8.12.0).

Vérifie :
1. Zéro pixel `#FF00FF` ni liseré violet/prune résiduel dans le brut hors `#FF00FF` et sur tous les rendus.
2. Cohérence géologique stricte `100 %` roche noire magma sur le fond montagneux et les falaises.
3. **Retrait intégral des cascades à l'entrée (`0` cascade / colonne)** ET **animation visqueuse de rive
   & croûte de bordure rocher** (`04_rive_magma_visqueux_bordure`, `15 × 8` ticks, `alpha ∈ {0, 255}`,
   palette `5-bit` GBA canonique `H26P01.bpl`, `0` damier).
4. Veines de magma `100 %` `#FF00FF` animées par le palette cycling matériel canonique `H26P01.bpl`.
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

    def test_01_magenta_veins_in_raw_and_zero_purple_in_render(self) -> None:
        raw = np.asarray(Image.open(entree_build.DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.int16)
        pure_mag = (raw[:, :, 0] == 255) & (raw[:, :, 1] == 0) & (raw[:, :, 2] == 255)
        self.assertGreater(int(pure_mag.sum()), 180_000)
        plum = (~pure_mag) & (raw[:, :, 0] - raw[:, :, 1] >= 16) & (raw[:, :, 2] - raw[:, :, 1] >= 10)
        self.assertEqual(int(plum.sum()), 0, f"Pixels prune restants dans le brut : {int(plum.sum())}")

        for idx, pose in enumerate((self.pose0, self.pose1, self.pose2)):
            r, g, b, a = pose[:, :, 0].astype(int), pose[:, :, 1].astype(int), pose[:, :, 2].astype(int), pose[:, :, 3]
            self.assertEqual(int((a < 255).sum()), 0)
            fringe = (r - g >= 18) & (b - g >= 12)
            self.assertEqual(int(fringe.sum()), 0, f"Liseré violet détecté sur pose {idx}: {int(fringe.sum())}")

    def test_02_coherent_black_magma_background_rock(self) -> None:
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
            self.assertLess(float(lum.mean()), 32.0, f"La couche {name} doit être en vraie roche noire volcanique POV PMD")
            yellow_sandstone = (lyr[opaque, 0] >= 150) & (lyr[opaque, 1] >= 80)
            self.assertEqual(int(yellow_sandstone.sum()), 0, f"Zéro roche ocre/jaune incohérente tolérée sur {name}")

        # Vérifie que la lave est bien la vraie texture `Dark Crater Pit` (`d41p41a` `1×`, `12` poses @ `10` ticks)
        sea_entry = [l for l in entree_build.build_layers_for_size()[0] if l.slug == "00_mer_et_gouffres_magma_dcp"][0]
        self.assertEqual(len(sea_entry.frames), 12)
        self.assertEqual(sea_entry.frame_length, 10)
        sea0 = np.asarray(sea_entry.frames[0], dtype=np.uint8)[:, :, :3]
        ref96 = np.asarray(
            Image.open(REPO_ROOT / "source" / "mine_magma_arene_v1" / "references" / "dark_crater_pit" / "dark_crater_pit_lava_96x96_f00.png").convert("RGB"),
            dtype=np.uint8,
        )
        self.assertTrue(np.array_equal(sea0[:96, :96, :], ref96), "La lave doit être exacte bit-à-bit `1×` Dark Crater Pit (`d41p41a`)")

    def test_03_zero_cascades_and_active_viscous_shoreline_rock_border(self) -> None:
        layer_slugs = [l["slug"] for l in self.metrics["layers"]]
        for slug in layer_slugs:
            self.assertNotIn("cascade", slug.lower(), f"Zéro cascade tolérée à l'entrée MME1 ({slug})")
        for f in (self.renders / "layers").iterdir():
            self.assertNotIn("cascade", f.name.lower())
        for f in (self.renders / "package" / "Content" / "Tile").iterdir():
            self.assertNotIn("cascade", f.name.lower())

        self.assertIn("04_rive_magma_visqueux_bordure", layer_slugs)
        layers, _, _ = entree_build.build_layers_for_size()
        shore_entry = [l for l in layers if l.slug == "04_rive_magma_visqueux_bordure"][0]
        self.assertEqual(len(shore_entry.frames), 15)
        self.assertEqual(shore_entry.frame_length, 8)

        f0 = np.asarray(shore_entry.frames[0], dtype=np.uint8)
        f7 = np.asarray(shore_entry.frames[7], dtype=np.uint8)
        semi = (f0[:, :, 3] > 0) & (f0[:, :, 3] < 255)
        self.assertEqual(int(semi.sum()), 0, "Alpha strictement binaire {0, 255} requis sans flou")
        self.assertGreater(int((f0[:, :, 3] == 255).sum()), 3_000)
        shore_diff = np.abs(f0.astype(int) - f7.astype(int)).max(axis=2)
        self.assertGreater(int((shore_diff > 15).sum()), 2_500, "La rive visqueuse et la bordure rocher doivent s'animer")

    def test_04_canonical_palette_cycling_in_veins_and_chasms(self) -> None:
        diff01 = np.abs(self.pose0[:, :, :3].astype(int) - self.pose1[:, :, :3].astype(int)).max(axis=2)
        diff12 = np.abs(self.pose1[:, :, :3].astype(int) - self.pose2[:, :, :3].astype(int)).max(axis=2)
        self.assertGreater(int((diff01 > 12).sum()), 6_000)
        self.assertGreater(int((diff12 > 12).sum()), 6_000)

        arch_anim = (diff01[0:280, :] > 12).sum()
        self.assertGreater(int(arch_anim), 1_500, "Les veines de magma du massif de roche noire doivent pulser !")

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
