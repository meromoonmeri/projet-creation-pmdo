#!/usr/bin/env python3
"""Tests automatisés — entree_promontoire_nuages_sud_nord_v1 (EPN1)."""
from __future__ import annotations

import json
import unittest

import numpy as np
from PIL import Image

from build import (
    CLOUD_FRAME_COUNT,
    ENTRANCE_MARKER,
    EXPORTS,
    FLOWER_FRAME_COUNT,
    GH,
    GW,
    H,
    MAP_ID,
    PREFIX,
    RENDERS,
    SEUIL_MARKER,
    TILE,
    W,
    main as run_build,
    verify_16x16_connectivity,
)


class TestEntreePromontoireNuagesV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (EXPORTS / f"{MAP_ID}.rsground").exists():
            run_build()

    def test_dimensions_and_opaque_ground(self) -> None:
        sol = np.array(Image.open(RENDERS / f"{PREFIX}_couche_sol.png").convert("RGBA"))
        self.assertEqual(sol.shape, (H, W, 4))
        self.assertTrue(np.all(sol[:, :, 3] == 255))

    def test_no_residual_magenta_on_any_layer_or_final(self) -> None:
        fin = np.array(Image.open(RENDERS / f"{PREFIX}_final.png").convert("RGB")).astype(int)
        mag = (fin[:, :, 0] > 210) & (fin[:, :, 1] < 45) & (fin[:, :, 2] > 210)
        self.assertEqual(int(mag.sum()), 0, f"Pixels magenta résiduels dans final.png: {mag.sum()}")
        for lname in ("ilots_rocheux", "falaises", "seuil_entree", "arbres"):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_couche_{lname}.png").convert("RGBA")).astype(int)
            m = (arr[:, :, 3] > 0) & (arr[:, :, 0] > 210) & (arr[:, :, 1] < 45) & (arr[:, :, 2] > 210)
            self.assertEqual(int(m.sum()), 0, f"Pixels magenta dans {lname}: {m.sum()}")

    def test_animations_closed_loop(self) -> None:
        c0 = np.array(Image.open(RENDERS / f"{PREFIX}_nuages_animes_0.png").convert("RGBA"))
        c1 = np.array(Image.open(RENDERS / f"{PREFIX}_nuages_animes_1.png").convert("RGBA"))
        self.assertGreater(int(np.any(c0 != c1, axis=-1).sum()), 10000)

        fl0 = np.array(Image.open(RENDERS / f"{PREFIX}_fleurs_animees_0.png").convert("RGBA"))
        fl1 = np.array(Image.open(RENDERS / f"{PREFIX}_fleurs_animees_1.png").convert("RGBA"))
        self.assertGreater(int(np.any(fl0 != fl1, axis=-1).sum()), 50)

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
            ["sol", "nuages_animes", "ilots_rocheux", "falaises", "seuil_entree", "arbres", "fleurs_animees", "Top"],
        )
        manifest = json.loads((EXPORTS / "manifest.json").read_text(encoding="utf-8"))
        self.assertFalse(manifest["validation_status"]["art_approved"])
        self.assertFalse(manifest["validation_status"]["runtime_tested"])


if __name__ == "__main__":
    unittest.main()
