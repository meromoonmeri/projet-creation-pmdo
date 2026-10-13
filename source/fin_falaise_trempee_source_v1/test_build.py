#!/usr/bin/env python3
"""Tests automatisés — fin_falaise_trempee_source_v1 (FFT1)."""
from __future__ import annotations

import json
import unittest

import numpy as np
from PIL import Image

from build import (
    BOSS_MARKER,
    ENTRANCE_MARKER,
    EXPORTS,
    GH,
    GW,
    H,
    MAP_ID,
    MOSS_FRAME_COUNT,
    OBJECTIF_MARKER,
    PREFIX,
    RENDERS,
    SPRING_FRAME_COUNT,
    SPRING_RAMP,
    TILE,
    W,
    main as run_build,
    verify_16x16_connectivity,
)


class TestFinFalaiseTrempeeSourceV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (EXPORTS / f"{MAP_ID}.rsground").exists():
            run_build()

    def test_dimensions_and_opaque_ground(self) -> None:
        sol = np.array(Image.open(RENDERS / f"{PREFIX}_couche_sol.png").convert("RGBA"))
        self.assertEqual(sol.shape, (H, W, 4))
        self.assertTrue(np.all(sol[:, :, 3] == 255))

    def test_static_layers_distinct(self) -> None:
        for lname in ("herbe", "rochers", "vasque_pierre"):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_couche_{lname}.png").convert("RGBA"))
            self.assertEqual(arr.shape, (H, W, 4))
            self.assertGreater(int((arr[:, :, 3] > 0).sum()), 500)

    def test_spring_animation_exact_rom_palette(self) -> None:
        allowed = {tuple(int(v) for v in c) for c in SPRING_RAMP}
        for idx in range(SPRING_FRAME_COUNT):
            arr = np.array(Image.open(RENDERS / f"{PREFIX}_source_animee_{idx}.png").convert("RGBA"))
            mask = arr[:, :, 3] > 0
            self.assertGreater(int(mask.sum()), 3000)
            used = {tuple(int(v) for v in c) for c in np.unique(arr[mask][:, :3], axis=0)}
            self.assertTrue(used.issubset(allowed), f"Couleurs hors rampe ROM D02P31A: {used - allowed}")
        f0 = np.array(Image.open(RENDERS / f"{PREFIX}_source_animee_0.png").convert("RGBA"))
        f1 = np.array(Image.open(RENDERS / f"{PREFIX}_source_animee_1.png").convert("RGBA"))
        self.assertGreater(int(np.any(f0 != f1, axis=-1).sum()), 500)

    def test_cul_de_sac_markers_and_bfs_16x16(self) -> None:
        meta = json.loads((EXPORTS / f"{PREFIX}_collision.json").read_text(encoding="utf-8"))
        marker_names = {m["name"] for m in meta["markers"]}
        self.assertEqual(marker_names, {"entrance", "boss", "objectif"})
        self.assertNotIn("donjon_seuil", marker_names)
        self.assertEqual(ENTRANCE_MARKER["Direction"], "Up")
        self.assertEqual(BOSS_MARKER["Direction"], "Down")
        self.assertEqual(OBJECTIF_MARKER["Direction"], "Up")

        path = verify_16x16_connectivity(meta["grid"])
        self.assertGreater(len(path), 30)
        # Cul-de-sac : bord nord intégralement bloqué
        self.assertTrue(all(c == "wall" for c in meta["grid"][0]))

    def test_rsground_and_manifest(self) -> None:
        rs = json.loads((EXPORTS / f"{MAP_ID}.rsground").read_text(encoding="utf-8-sig"))
        content = rs["Object"]
        self.assertEqual(content["Width"], GW)
        self.assertEqual(content["Height"], GH)
        self.assertEqual(content["TexSize"], 1)
        layer_names = [l["Name"] for l in content["AssetLayers"]]
        self.assertEqual(
            layer_names,
            ["sol", "herbe", "rochers", "vasque_pierre", "source_animee", "fleurs_mousse", "Top"],
        )
        manifest = json.loads((EXPORTS / "manifest.json").read_text(encoding="utf-8"))
        self.assertFalse(manifest["validation_status"]["art_approved"])
        self.assertFalse(manifest["validation_status"]["runtime_tested"])


if __name__ == "__main__":
    unittest.main()
