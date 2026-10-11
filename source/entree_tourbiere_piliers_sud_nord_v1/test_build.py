#!/usr/bin/env python3
"""Tests automatisés — entree_tourbiere_piliers_sud_nord_v1 (ETB1)."""
from __future__ import annotations

import json
import unittest

import numpy as np
from PIL import Image

from build import (
    ENTRANCE_MARKER,
    EXPORTS,
    GH,
    GW,
    H,
    MAP_ID,
    MARSH_WATER_PALETTE,
    PREFIX,
    RENDERS,
    SEUIL_MARKER,
    TILE,
    W,
    WATER_FRAME_COUNT,
    main as run_build,
    verify_16x16_connectivity,
)


class TestEntreeTourbierePiliersV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (EXPORTS / f"{MAP_ID}.rsground").exists():
            run_build()

    def test_dimensions_and_opaque_ground(self) -> None:
        sol = np.array(Image.open(RENDERS / f"{PREFIX}_couche_sol.png").convert("RGBA"))
        self.assertEqual(sol.shape, (H, W, 4))
        self.assertTrue(np.all(sol[:, :, 3] == 255))

    def test_no_residual_magenta_and_exact_water_palette(self) -> None:
        fin = np.array(Image.open(RENDERS / f"{PREFIX}_final.png").convert("RGB")).astype(int)
        mag = (fin[:, :, 0] > 210) & (fin[:, :, 1] < 45) & (fin[:, :, 2] > 210)
        self.assertEqual(int(mag.sum()), 0, f"Pixels magenta dans final.png: {mag.sum()}")

        allowed = {tuple(int(v) for v in c) for c in MARSH_WATER_PALETTE}
        for idx in range(WATER_FRAME_COUNT):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_bassins_animes_{idx}.png").convert("RGBA"))
            mask = arr[:, :, 3] > 0
            self.assertGreater(int(mask.sum()), 40000)
            used = {tuple(int(v) for v in c) for c in np.unique(arr[mask][:, :3], axis=0)}
            self.assertTrue(used.issubset(allowed), f"Couleurs hors rampe D09P11A: {used - allowed}")

    def test_collision_and_bfs_16x16(self) -> None:
        meta = json.loads((EXPORTS / f"{PREFIX}_collision.json").read_text(encoding="utf-8"))
        path = verify_16x16_connectivity(meta["grid"])
        self.assertGreater(len(path), 30)
        marker_names = {m["name"] for m in meta["markers"]}
        self.assertEqual(marker_names, {"entrance", "donjon_seuil"})
        self.assertEqual(ENTRANCE_MARKER["Direction"], "Up")
        self.assertEqual(SEUIL_MARKER["Direction"], "Up")

    def test_rsground_and_manifest(self) -> None:
        rs = json.loads((EXPORTS / f"{MAP_ID}.rsground").read_text(encoding="utf-8-sig"))
        content = rs["Object"]
        self.assertEqual(content["Width"], GW)
        self.assertEqual(content["Height"], GH)
        self.assertEqual(content["TexSize"], 1)
        layer_names = [l["Name"] for l in content["AssetLayers"]]
        self.assertEqual(
            layer_names,
            ["sol", "bassins_animes", "piliers_rocheux", "seuil_entree", "buissons", "bulles_marais", "Top"],
        )
        manifest = json.loads((EXPORTS / "manifest.json").read_text(encoding="utf-8"))
        self.assertFalse(manifest["validation_status"]["art_approved"])
        self.assertFalse(manifest["validation_status"]["runtime_tested"])


if __name__ == "__main__":
    unittest.main()
