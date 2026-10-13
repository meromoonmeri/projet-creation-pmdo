#!/usr/bin/env python3
"""Tests automatisés — entree_falaise_trempee_sud_nord_v1 (EFT1)."""
from __future__ import annotations

import json
from pathlib import Path
import unittest

import numpy as np
from PIL import Image

from build import (
    DRIP_FRAME_COUNT,
    ENTRANCE_MARKER,
    EXPORTS,
    GH,
    GW,
    H,
    MAP_ID,
    MOSS_FRAME_COUNT,
    PREFIX,
    RENDERS,
    SEUIL_MARKER,
    TILE,
    W,
    main as run_build,
    verify_16x16_connectivity,
)


class TestEntreeFalaiseTrempeeV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (EXPORTS / f"{MAP_ID}.rsground").exists():
            run_build()

    def test_dimensions_and_opaque_ground(self) -> None:
        sol = np.array(Image.open(RENDERS / f"{PREFIX}_couche_sol.png").convert("RGBA"))
        self.assertEqual(sol.shape, (H, W, 4))
        self.assertTrue(np.all(sol[:, :, 3] == 255), "Le calque sol doit être 100 % opaque")

    def test_layers_distinct_and_non_empty(self) -> None:
        for lname in ("herbe_haute", "rochers", "seuil_entree"):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_couche_{lname}.png").convert("RGBA"))
            self.assertEqual(arr.shape, (H, W, 4))
            opaque = int((arr[:, :, 3] > 0).sum())
            self.assertGreater(opaque, 500, f"Couche {lname} vide ou presque vide ({opaque} px)")

    def test_animations_closed_loop_and_no_magenta(self) -> None:
        for idx in range(MOSS_FRAME_COUNT):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_fleurs_mousse_{idx}.png").convert("RGBA"))
            mag = (arr[:, :, 0] > 235) & (arr[:, :, 1] < 25) & (arr[:, :, 2] > 235) & (arr[:, :, 3] > 0)
            self.assertEqual(int(mag.sum()), 0)
        f0 = np.array(Image.open(RENDERS / f"{PREFIX}_fleurs_mousse_0.png").convert("RGBA"))
        f1 = np.array(Image.open(RENDERS / f"{PREFIX}_fleurs_mousse_1.png").convert("RGBA"))
        self.assertGreater(int(np.any(f0 != f1, axis=-1).sum()), 20)

        for idx in range(DRIP_FRAME_COUNT):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_embruns_{idx}.png").convert("RGBA"))
            self.assertGreater(int((arr[:, :, 3] > 0).sum()), 20)

    def test_collision_and_bfs_16x16(self) -> None:
        meta = json.loads((EXPORTS / f"{PREFIX}_collision.json").read_text(encoding="utf-8"))
        self.assertEqual(meta["grid_width"], GW)
        self.assertEqual(meta["grid_height"], GH)
        self.assertEqual(meta["tile_size"], TILE)
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
            ["sol", "herbe_haute", "rochers", "seuil_entree", "fleurs_mousse", "embruns", "Top"],
        )
        self.assertEqual(content["AssetLayers"][-1]["Layer"], 4)

        manifest = json.loads((EXPORTS / "manifest.json").read_text(encoding="utf-8"))
        self.assertFalse(manifest["validation_status"]["art_approved"])
        self.assertFalse(manifest["validation_status"]["runtime_tested"])


if __name__ == "__main__":
    unittest.main()
