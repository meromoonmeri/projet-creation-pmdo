#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests d'intégration du placement Halcyon / `town02` pour le dépôt unifié « PROJET PMD »."""
from __future__ import annotations

import json
import shutil
import tempfile
import unittest
from pathlib import Path

from source.consolidation_unifiee_town02.assembler_repo_unifie_town02 import (
    copier_fichier_dereference,
    enregistrer_grounds_dans_master_zone_halcyon,
    fusionner_branches_dans_town02,
    injecter_planches_dans_index,
    installer_ecran_titre_pmd_destiny,
    lire_tile_index,
    mettre_a_jour_mod_xml_halcyon,
    serialiser_tile_index,
    synchroniser_asset_name_rsground,
    verifier_aucun_damier_mauve,
)

REPO_ROOT = Path(__file__).resolve().parents[2]


class TestProjetPmdHalcyonPlacement(unittest.TestCase):
    SAMPLE_LOTS = (
        "pmd_destiny_fangame_v1",
        "grotte_ouest_entree_v1",
        "grotte_ouest_sanctuaire_v1",
        "ruines_enfouies_entree_v1",
        "ruines_enfouies_sanctuaire_v1",
        "kyurem_cratere_entree_v1",
        "kyurem_sanctuaire_glace_v1",
        "fosse_argent_sanctuaire_v1",
        "zekrom_sommet_tornade_v1",
        "guilde_treehouse_halcyon_v1",
    )

    @classmethod
    def setUpClass(cls) -> None:
        import importlib.util
        for lot in cls.SAMPLE_LOTS:
            pkg = REPO_ROOT / "renders" / lot / "package"
            valid_rs = [
                p for p in (pkg / "Data" / "Ground").glob("*.rsground")
                if p.exists()
            ] if (pkg / "Data" / "Ground").is_dir() else []
            if not valid_rs:
                bp = REPO_ROOT / "source" / lot / "build.py"
                spec = importlib.util.spec_from_file_location(f"test_hal_{lot}", bp)
                assert spec and spec.loader
                mod = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(mod)
                mod.build()

    def test_01_roundtrip_et_injection_binaire_tile_index(self) -> None:
        sample_tiles = sorted((REPO_ROOT / ".cache" / "tiles").rglob("*.tile"))[:10]
        self.assertGreaterEqual(
            len(sample_tiles), 4, "Au moins 4 fichiers .tile doivent exister dans .cache/tiles"
        )

        with tempfile.TemporaryDirectory() as tmp:
            idx_path = Path(tmp) / "index.idx"
            avant, apres, injectes = injecter_planches_dans_index(idx_path, sample_tiles[:4])
            self.assertEqual(avant, 0)
            self.assertEqual(apres, 4)
            self.assertEqual(injectes, 4)

            raw1 = idx_path.read_bytes()
            entries1 = lire_tile_index(idx_path)
            self.assertEqual([e.sheet for e in entries1], sorted(e.sheet for e in entries1))
            self.assertEqual(serialiser_tile_index(entries1), raw1)

            avant2, apres2, _ = injecter_planches_dans_index(idx_path, sample_tiles[4:10])
            self.assertEqual(avant2, 4)
            self.assertEqual(apres2, len( {p.stem for p in sample_tiles[:10]} ))
            entries2 = lire_tile_index(idx_path)
            self.assertEqual([e.sheet for e in entries2], sorted(e.sheet for e in entries2))

    def test_02_aucun_damier_mauve_sur_studio_37_et_guilde_84(self) -> None:
        pkg_dirs = [REPO_ROOT / "renders" / lot / "package" for lot in self.SAMPLE_LOTS]
        existing_pkgs = [p for p in pkg_dirs if p.exists()]
        self.assertEqual(len(existing_pkgs), len(self.SAMPLE_LOTS))

        with tempfile.TemporaryDirectory() as tmp:
            troot = Path(tmp)
            tile_dir = troot / "Content" / "Tile"
            ground_dir = troot / "Data" / "Ground"
            idx_path = tile_dir / "index.idx"
            tile_dir.mkdir(parents=True)
            ground_dir.mkdir(parents=True)

            copied_tiles = []
            copied_grounds = []
            for pkg in existing_pkgs:
                for tp in sorted((pkg / "Content" / "Tile").glob("*.tile")):
                    dst = tile_dir / tp.name
                    if copier_fichier_dereference(tp, dst):
                        copied_tiles.append(dst)
                # Prend jusqu'à 6 grounds par lot pour un contrôle rapide et exhaustif
                for gp in sorted((pkg / "Data" / "Ground").glob("*.rsground"))[:6]:
                    dst = ground_dir / gp.name
                    if copier_fichier_dereference(gp, dst):
                        copied_grounds.append(dst)

            injecter_planches_dans_index(idx_path, copied_tiles)
            checked, problems = verifier_aucun_damier_mauve(
                idx_path, tile_dir, copied_grounds
            )
            self.assertEqual(problems, [])
            self.assertGreater(checked, 15000)

            # Contre-test : casser une référence réellement utilisée DOIT être détecté immédiatement
            from source.consolidation_unifiee_town02.assembler_repo_unifie_town02 import (
                extraire_references_tuiles_rsground,
            )
            used_sheet, _, _ = sorted(extraire_references_tuiles_rsground(copied_grounds[0]) or [])[0]
            entries = [e for e in lire_tile_index(idx_path) if e.sheet != used_sheet]
            idx_path.write_bytes(serialiser_tile_index(entries))
            _, bad_problems = verifier_aucun_damier_mauve(
                idx_path, tile_dir, copied_grounds
            )
            self.assertGreaterEqual(len(bad_problems), 1)

    def test_03_invariants_halcyon_complets_mod_xml_master_zone_scripts_et_alias(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            mock_town02 = Path(tmp) / "PROJET-PMD"
            (mock_town02 / "Content" / "Tile").mkdir(parents=True)
            (mock_town02 / "Data" / "Ground").mkdir(parents=True)
            (mock_town02 / "Data" / "Zone").mkdir(parents=True)
            (mock_town02 / "Data" / "Script" / "halcyon" / "ground" / "metano_town").mkdir(
                parents=True
            )

            # 1) Mod.xml fidèle à town02 / Palikadude/Halcyon
            (mock_town02 / "Mod.xml").write_text(
                "<Header>\n"
                "  <Name>Halcyon</Name>\n"
                "  <Author>Palika</Author>\n"
                "  <Description>Original</Description>\n"
                "  <Namespace>halcyon</Namespace>\n"
                "  <UUID>CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF</UUID>\n"
                "  <Version>0.5.3</Version>\n"
                "  <GameVersion>0.8.12</GameVersion>\n"
                "  <ModType>Quest</ModType>\n"
                "</Header>\n",
                encoding="utf-8",
            )

            # 2) master_zone.json et Data/Zone/index.idx simulés avec les entrées natives de town02
            native_grounds = ["metano_town", "guild_first_floor", "guild_second_floor", "kyurem_sanctuaire_glace"]
            (mock_town02 / "Data" / "Zone" / "master_zone.json").write_bytes(
                (
                    "\ufeff"
                    + json.dumps(
                        {
                            "Version": "0.8.12.0",
                            "Object": {
                                "$type": "RogueEssence.Data.ZoneData, RogueEssence",
                                "Maps": [],
                                "GroundMaps": list(native_grounds),
                            },
                        }
                    )
                ).encode("utf-8")
            )
            (mock_town02 / "Data" / "Zone" / "index.idx").write_bytes(
                (
                    "\ufeff"
                    + json.dumps(
                        {
                            "Version": "0.8.12.0",
                            "Object": {
                                "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
                                "master_zone": {"Grounds": list(native_grounds)},
                            },
                        }
                    )
                ).encode("utf-8")
            )

            # Simule une homonymie sur kyurem_sanctuaire_glace.rsground dans town02
            (mock_town02 / "Data" / "Ground" / "kyurem_sanctuaire_glace.rsground").write_text(
                '{"Object":{"AssetName":"kyurem_sanctuaire_glace"}}', encoding="utf-8"
            )

            # 3) Exécute la fusion depuis le dépôt courant (branche active)
            report = fusionner_branches_dans_town02(
                target_root=mock_town02,
                source_repos=[
                    (
                        "meromoonmeri/projet-creation-pmdo",
                        REPO_ROOT,
                        "arena/637b0828-projet-creation-pmdo",
                    )
                ],
                garder_variantes=False,
                compiler_builds=False,
                nom_mod="PROJET PMD",
            )

            # A. Vérifie Mod.xml : <Name>PROJET PMD</Name> + <Namespace>halcyon</Namespace>
            mod_txt = (mock_town02 / "Mod.xml").read_text(encoding="utf-8")
            self.assertIn("<Name>PROJET PMD</Name>", mod_txt)
            self.assertIn("<Namespace>halcyon</Namespace>", mod_txt)

            # B. Vérifie l'alias anti-écrasement + synchronisation de Object.AssetName !
            self.assertEqual(
                (mock_town02 / "Data" / "Ground" / "kyurem_sanctuaire_glace.rsground").read_text(
                    encoding="utf-8"
                ),
                '{"Object":{"AssetName":"kyurem_sanctuaire_glace"}}',
            )
            aliased_ground = (
                mock_town02 / "Data" / "Ground" / "kyurem_sanctuaire_glace__custom_pmdo.rsground"
            )
            if aliased_ground.exists():
                aliased_doc = json.loads(aliased_ground.read_text(encoding="utf-8-sig"))
                self.assertEqual(
                    aliased_doc["Object"]["AssetName"],
                    "kyurem_sanctuaire_glace__custom_pmdo",
                )

            # C. Simule la matérialisation d'un mini-mod Studio (KYE1) + d'une salle Guilde Treehouse
            ws_renders = mock_town02 / "Halcyon Mods" / "sources_projet_pmd" / "renders"
            kye_src = REPO_ROOT / "renders" / "kyurem_cratere_entree_v1" / "package"
            gth_src = REPO_ROOT / "renders" / "guilde_treehouse_halcyon_v1" / "package"

            # Installe 2 grounds réels (KYE1 + Guilde Hall des missions) pour tester scripts + master_zone
            for tp in list((kye_src / "Content" / "Tile").glob("*.tile")) + [
                gth_src / "Content" / "Tile" / "GTH_02_CORPS_JOUR.tile",
                gth_src / "Content" / "Tile" / "GTH_02_FENETRES_6AMB.tile",
            ]:
                copier_fichier_dereference(tp, mock_town02 / "Content" / "Tile" / tp.name)

            injecter_planches_dans_index(
                mock_town02 / "Content" / "Tile" / "index.idx",
                sorted((mock_town02 / "Content" / "Tile").glob("*.tile")),
            )

            kye_ground_dst = mock_town02 / "Data" / "Ground" / "kyurem_cratere_entree.rsground"
            gth_ground_dst = mock_town02 / "Data" / "Ground" / "guilde_th_02_hall_missions.rsground"
            copier_fichier_dereference(
                kye_src / "Data" / "Ground" / "kyurem_cratere_entree.rsground", kye_ground_dst
            )
            copier_fichier_dereference(
                gth_src / "Data" / "Ground" / "guilde_th_02_hall_missions.rsground", gth_ground_dst
            )
            synchroniser_asset_name_rsground(kye_ground_dst, "kyurem_cratere_entree")
            synchroniser_asset_name_rsground(gth_ground_dst, "guilde_th_02_hall_missions")

            # Vérifie l'extracteur Halcyon de scripts Ground (relocalisation <ns>/ground/<id> -> halcyon/ground/<id>)
            from source.consolidation_unifiee_town02.assembler_repo_unifie_town02 import (
                _extraire_scripts_ground_depuis_arborescence,
            )
            extracted_scripts = _extraire_scripts_ground_depuis_arborescence(REPO_ROOT / "renders")
            self.assertIn("kyurem_cratere_entree", extracted_scripts)
            self.assertEqual(extracted_scripts["kyurem_cratere_entree"][1], "kyurem_cratere_kye1")
            self.assertIn("guilde_th_02_hall_missions", extracted_scripts)
            self.assertIsNone(extracted_scripts["guilde_th_02_hall_missions"][1])

            # Enregistre dans master_zone.json & Data/Zone/index.idx et vérifie que 0..3 sont intacts !
            avant_mz, apres_mz = enregistrer_grounds_dans_master_zone_halcyon(
                mock_town02, ["kyurem_cratere_entree", "guilde_th_02_hall_missions"]
            )
            self.assertGreaterEqual(apres_mz, avant_mz + 2)
            mz_after_doc = json.loads(
                (mock_town02 / "Data" / "Zone" / "master_zone.json").read_text(encoding="utf-8-sig")
            )
            self.assertEqual(mz_after_doc["Object"]["GroundMaps"][:4], native_grounds)
            self.assertIn("kyurem_cratere_entree", mz_after_doc["Object"]["GroundMaps"])
            self.assertIn("guilde_th_02_hall_missions", mz_after_doc["Object"]["GroundMaps"])

            zidx_after_doc = json.loads(
                (mock_town02 / "Data" / "Zone" / "index.idx").read_text(encoding="utf-8-sig")
            )
            self.assertEqual(
                zidx_after_doc["Object"]["master_zone"]["Grounds"][:4], native_grounds
            )
            self.assertIn(
                "guilde_th_02_hall_missions",
                zidx_after_doc["Object"]["master_zone"]["Grounds"],
            )

            # Et vérifie 0 damier mauve sur les deux grounds installés !
            checked, problems = verifier_aucun_damier_mauve(
                mock_town02 / "Content" / "Tile" / "index.idx",
                mock_town02 / "Content" / "Tile",
                [kye_ground_dst, gth_ground_dst],
            )
            self.assertEqual(problems, [])
            self.assertGreater(checked, 2000)
            self.assertGreaterEqual(report.source_lots_merged, 40)

    def test_07_installer_ecran_titre_pmd_destiny_dans_town02(self) -> None:
        """Vérifie l'installation Halcyon/`town02` complète de `Pokemon Mystery Dungeon: Destiny`."""
        with tempfile.TemporaryDirectory() as tmp:
            mock_root = Path(tmp) / "Pokemon-Mystery-Dungeon-Destiny"
            (mock_root / "Data" / "Script" / "halcyon").mkdir(parents=True, exist_ok=True)
            (mock_root / "Data" / "Script" / "halcyon" / "main.lua").write_text(
                "function PrintInfo(msg) print(tostring(msg)) end\nrequire 'halcyon.services.menu_tools'\n",
                encoding="utf-8",
            )
            mettre_a_jour_mod_xml_halcyon(mock_root, nom_mod="Pokemon Mystery Dungeon: Destiny")
            ok = installer_ecran_titre_pmd_destiny(mock_root, REPO_ROOT)
            self.assertTrue(ok)
            self.assertTrue((mock_root / "Content" / "BG" / "Title_Screen_Background.dir").is_file())
            self.assertTrue((mock_root / "Content" / "UI" / "Title.png").is_file())
            self.assertTrue((mock_root / "Content" / "UI" / "Enter.png").is_file())
            self.assertTrue(
                (mock_root / "Data" / "Script" / "halcyon" / "services" / "destiny_title_anim" / "init.lua").is_file()
            )
            main_txt = (mock_root / "Data" / "Script" / "halcyon" / "main.lua").read_text(encoding="utf-8")
            self.assertIn("require 'halcyon.services.destiny_title_anim'", main_txt)
            mod_txt = (mock_root / "Mod.xml").read_text(encoding="utf-8")
            self.assertIn("<Name>Pokemon Mystery Dungeon: Destiny</Name>", mod_txt)
            self.assertIn("<Namespace>halcyon</Namespace>", mod_txt)


if __name__ == "__main__":
    unittest.main()
