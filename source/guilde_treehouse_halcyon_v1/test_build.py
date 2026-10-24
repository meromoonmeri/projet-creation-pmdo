#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests unitaires pour la compilation Halcyon des 12 salles × 6 ambiances de Guilde Treehouse."""
from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from source.consolidation_unifiee_town02.assembler_repo_unifie_town02 import (
    injecter_planches_dans_index,
    verifier_aucun_damier_mauve,
)
from source.guilde_treehouse_halcyon_v1.build import (
    AMBIANCES,
    CACHE_PKG,
    RENDERS_DIR,
    VZIP_PATH,
    build,
)


class TestGuildeTreehouseHalcyon(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not (RENDERS_DIR / "metadata.json").is_file() or not VZIP_PATH.is_file():
            build()
        cls.meta = json.loads((RENDERS_DIR / "metadata.json").read_text(encoding="utf-8"))

    def test_01_couverture_12_salles_et_6_ambiances(self) -> None:
        self.assertEqual(self.meta["rooms_count"], 12)
        self.assertEqual(tuple(self.meta["ambiances"]), AMBIANCES)
        # 12 canoniques + 12 * 6 ambiances = 84 .rsground
        self.assertEqual(self.meta["rsground_count"], 84)
        self.assertEqual(self.meta["tile_banks_count"], 35)
        self.assertLess(self.meta["max_tiles_per_bank"], 24000)
        self.assertTrue(VZIP_PATH.is_file())

    def test_02_conformite_halcyon_layers_obstacles_entities_et_lua(self) -> None:
        # Contrôle approfondi sur Hall des missions (02) jour/nuit/orageux + Accueil (01) + Salle du chef (12)
        for gid in (
            "guilde_th_01_accueil",
            "guilde_th_02_hall_missions",
            "guilde_th_02_hall_missions_nuit",
            "guilde_th_02_hall_missions_orageux",
            "guilde_th_12_salle_chef_crepuscule",
        ):
            gpath = CACHE_PKG / "Data" / "Ground" / f"{gid}.rsground"
            self.assertTrue(gpath.is_file(), f"Manquant: {gpath}")
            raw_bytes = gpath.read_bytes()
            self.assertTrue(raw_bytes.startswith(b"\xef\xbb\xbf"), "BOM UTF-8 requis comme Halcyon/town02")
            doc = json.loads(raw_bytes.decode("utf-8-sig"))
            self.assertEqual(doc["Version"], "0.8.12.0")
            obj = doc["Object"]
            self.assertEqual(obj["AssetName"], gid)
            self.assertEqual(len(obj["Layers"]), 11)
            # Le 11e calque (10_bordure_avant) doit être en avant-plan Top (Layer = 4)
            self.assertEqual(obj["Layers"][10]["Layer"], 4)
            # Collisions : présence à la fois de sol praticable (Tags=0) et de murs (Tags=1)
            tags = {cell["Tags"] for col in obj["obstacles"] for cell in col}
            self.assertEqual(tags, {0, 1})
            # Entités Halcyon : marqueur entrance + déclencheurs Touch (triggerType = 2)
            ent_layer = obj["Entities"][0]
            marker_names = {m["EntName"] for m in ent_layer["Markers"]}
            self.assertIn("entrance", marker_names)
            self.assertGreaterEqual(len(ent_layer["GroundObjects"]), 1)
            for gobj in ent_layer["GroundObjects"]:
                self.assertEqual(gobj["triggerType"], 2)

            # Script Lua placé sous Data/Script/halcyon/ground/<gid>/init.lua
            lua_path = CACHE_PKG / "Data" / "Script" / "halcyon" / "ground" / gid / "init.lua"
            self.assertTrue(lua_path.is_file())
            lua_txt = lua_path.read_text(encoding="utf-8")
            self.assertIn(f"local {gid} = {{}}", lua_txt)
            self.assertIn(f"return {gid}", lua_txt)
            for gobj in ent_layer["GroundObjects"]:
                cb_name = f"function {gid}.{gobj['EntName']}_Touch("
                self.assertIn(cb_name, lua_txt)

    def test_03_aucun_damier_mauve_sur_les_35_banques_tile(self) -> None:
        tile_dir = CACHE_PKG / "Content" / "Tile"
        all_tiles = sorted(tile_dir.glob("*.tile"))
        self.assertEqual(len(all_tiles), 35)

        sample_grounds = [
            CACHE_PKG / "Data" / "Ground" / "guilde_th_01_accueil.rsground",
            CACHE_PKG / "Data" / "Ground" / "guilde_th_02_hall_missions_aube.rsground",
            CACHE_PKG / "Data" / "Ground" / "guilde_th_02_hall_missions_nuit.rsground",
            CACHE_PKG / "Data" / "Ground" / "guilde_th_03_salle_commune_soir.rsground",
            CACHE_PKG / "Data" / "Ground" / "guilde_th_12_salle_chef_orageux.rsground",
        ]
        with tempfile.TemporaryDirectory() as tmp:
            idx_path = Path(tmp) / "index.idx"
            _, after, _ = injecter_planches_dans_index(idx_path, all_tiles)
            self.assertEqual(after, 35)
            checked, problems = verifier_aucun_damier_mauve(idx_path, tile_dir, sample_grounds)
            self.assertEqual(problems, [])
            self.assertGreater(checked, 10000)


if __name__ == "__main__":
    unittest.main()
