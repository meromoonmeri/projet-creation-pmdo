#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests unitaires et d'intégration de bout en bout pour l'assembleur unifié `town02`."""
from __future__ import annotations

import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from source.consolidation_unifiee_town02.assembler_repo_unifie_town02 import (
    TileIndexEntry,
    extraire_entree_depuis_fichier_tile,
    extraire_references_tuiles_rsground,
    fusionner_branches_dans_town02,
    injecter_planches_dans_index,
    lire_tile_index,
    proteger_gros_fichiers_git_lfs,
    serialiser_tile_index,
    verifier_aucun_damier_mauve,
)

REPO_ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = Path(__file__).resolve().parent / "manifeste_complet_toutes_branches.json"


class TestConsolidationTown02(unittest.TestCase):
    def test_01_manifeste_complet_couvre_town02_et_toutes_branches(self) -> None:
        self.assertTrue(MANIFEST_PATH.is_file(), "Manifeste JSON introuvable")
        data = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))

        t2 = data["town02_summary"]
        self.assertGreaterEqual(t2["rsground_count"], 1620)
        self.assertGreaterEqual(t2["tile_count"], 2091)
        self.assertEqual(len(t2["all_rsground_names"]), t2["rsground_count"])

        # Vérifie que les 4 dépôts publics multi-branches ont bien été indexés
        for r in (
            "projet-creation-pmdo",
            "projet-pmdo",
            "zone-pmdo",
            "all-zone-PMDO-project",
        ):
            self.assertIn(r, data["repos_scanned"])

        self.assertGreaterEqual(
            data["repos_scanned"]["projet-creation-pmdo"]["branch_count"], 19
        )
        self.assertGreaterEqual(
            data["repos_scanned"]["projet-pmdo"]["branch_count"], 15
        )
        self.assertGreaterEqual(len(data["all_source_lots"]), 416)
        self.assertGreaterEqual(len(data["all_renders_lots"]), 354)
        self.assertGreaterEqual(len(data["all_html_previews"]), 331)

        # Les 12 salles & fenêtres Guilde Treehouse sont bien répertoriées
        for gd in ("salles", "fenetres_exterieur", "exterieur", "calques", "sprites"):
            self.assertIn(gd, data["root_special_dirs"])

        # Nos maps Studio récentes sur la branche active doivent être les gagnantes canoniques
        for studio_lot in (
            "kyurem_cratere_entree_v1",
            "kyurem_sanctuaire_glace_v1",
            "fosse_argent_entree_v1",
            "fosse_argent_sanctuaire_v1",
            "mont_lointain_entree_v1",
            "mont_lointain_sommet_v1",
            "zekrom_montagne_entree_v1",
            "zekrom_sommet_tornade_v1",
            "reshiram_montagne_entree_v1",
            "reshiram_sommet_flamme_v1",
        ):
            self.assertIn(studio_lot, data["all_source_lots"])
            self.assertEqual(
                data["all_source_lots"][studio_lot]["canonical"]["branch"],
                "arena/637b0828-projet-creation-pmdo",
            )

    def test_02_index_idx_binaire_et_garde_anti_damier_sur_kya1_reel(self) -> None:
        kya1_pkg = REPO_ROOT / "renders" / "kyurem_sanctuaire_glace_v1" / "package"
        kya1_tiles = sorted((kya1_pkg / "Content" / "Tile").glob("*.tile"))
        kya1_rsg = kya1_pkg / "Data" / "Ground" / "kyurem_sanctuaire_glace.rsground"

        # Si le cache .tile de KYA1 est absent, exécute build.py une fois
        if not kya1_rsg.exists() or len(kya1_tiles) < 10:
            subprocess.run(
                [".venv/bin/python", "source/kyurem_sanctuaire_glace_v1/build.py"],
                cwd=str(REPO_ROOT),
                check=True,
            )
            kya1_tiles = sorted((kya1_pkg / "Content" / "Tile").glob("*.tile"))

        self.assertEqual(len(kya1_tiles), 10)
        refs = extraire_references_tuiles_rsground(kya1_rsg)
        self.assertIsNotNone(refs)
        assert refs is not None
        self.assertGreater(len(refs), 20000)

        with tempfile.TemporaryDirectory() as tmp:
            tdir = Path(tmp) / "Content" / "Tile"
            tdir.mkdir(parents=True)
            idx_path = tdir / "index.idx"

            # Pré-remplit index.idx avec une planche factice '00_ciel' + une planche > 128 octets UTF-8
            long_name = "Z_" + ("planche_tres_longue_" * 7)
            seed_entries = [
                TileIndexEntry("00_ciel", 8, 0, b""),
                TileIndexEntry(long_name, 8, 0, b""),
            ]
            idx_path.write_bytes(serialiser_tile_index(seed_entries))

            copied_tiles = []
            for tp in kya1_tiles:
                dst = tdir / tp.resolve().name
                shutil.copy2(tp.resolve(), dst)
                copied_tiles.append(dst)

            before, after, injected = injecter_planches_dans_index(idx_path, copied_tiles)
            self.assertEqual(before, 2)
            self.assertEqual(injected, 10)
            self.assertEqual(after, 12)

            # Vérifie l'ordre strictement alphabétique et la relecture identique octet-pour-octet
            reloaded = lire_tile_index(idx_path)
            self.assertEqual([e.sheet for e in reloaded], sorted(e.sheet for e in reloaded))
            self.assertEqual(serialiser_tile_index(reloaded), idx_path.read_bytes())

            # Garde anti-damier sur les 25 066 références réelles de KYA1 : 0 problème !
            checked_count, problems = verifier_aucun_damier_mauve(
                idx_path, tdir, [kya1_rsg.resolve()]
            )
            self.assertEqual(problems, [])
            self.assertEqual(checked_count, len(refs))

            # Contre-épreuve : retire 1 planche de index.idx -> doit détecter le damier mauve !
            truncated = [e for e in reloaded if not e.sheet.startswith("KYA1_06_")]
            idx_path.write_bytes(serialiser_tile_index(truncated))
            _, bad_problems = verifier_aucun_damier_mauve(
                idx_path, tdir, [kya1_rsg.resolve()]
            )
            self.assertGreater(len(bad_problems), 0)
            self.assertIn("damier A", bad_problems[0])

    def test_03_assemblage_complet_multi_depots_multi_branches_dans_town02(self) -> None:
        kya1_pkg = REPO_ROOT / "renders" / "kyurem_sanctuaire_glace_v1" / "package"
        first_tile = sorted((kya1_pkg / "Content" / "Tile").glob("*.tile"))[0].resolve()
        sheet_name = first_tile.stem

        with tempfile.TemporaryDirectory() as tmp_str:
            tmp = Path(tmp_str)

            # 1) Crée un mini `town02` réaliste (Mod.xml, Content/Tile/index.idx, Data/Ground/a01p01.rsground)
            t2_root = tmp / "mock_town02"
            (t2_root / "Content" / "Tile").mkdir(parents=True)
            (t2_root / "Data" / "Ground").mkdir(parents=True)
            (t2_root / "Data" / "Script" / "ground").mkdir(parents=True)
            (t2_root / "Mod.xml").write_text("<Mod><Name>Town02</Name></Mod>", encoding="utf-8")
            (t2_root / ".gitattributes").write_text(
                "*.rsground filter=lfs diff=lfs merge=lfs -text\n", encoding="utf-8"
            )
            # Simule un .rsground town02 existant nommé `collision_map.rsground` (pointeur LFS)
            (t2_root / "Data" / "Ground" / "collision_map.rsground").write_bytes(
                b"version https://git-lfs.github.com/spec/v1\noid sha256:0000\nsize 123\n"
            )
            (t2_root / "Content" / "Tile" / "00_ciel.tile").write_bytes(
                b"\x08\x00\x00\x00\x00\x00\x00\x00"
            )
            (t2_root / "Content" / "Tile" / "index.idx").write_bytes(
                serialiser_tile_index([TileIndexEntry("00_ciel", 8, 0, b"")])
            )

            # 2) Crée un dépôt source multi-branches `projet-creation-pmdo` avec 2 branches divergentes
            repo_a = tmp / "meromoonmeri_projet-creation-pmdo"
            repo_a.mkdir()
            self._git_init(repo_a, "arena/ancienne-branche")
            (repo_a / "source" / "lot_commun").mkdir(parents=True)
            (repo_a / "source" / "lot_commun" / "note.txt").write_text("v1_ancienne", encoding="utf-8")
            (repo_a / "source" / "lot_branche_ancienne").mkdir(parents=True)
            (repo_a / "source" / "lot_branche_ancienne" / "info.txt").write_text("exclusif_b1", encoding="utf-8")
            (repo_a / "apercu_ancien.html").write_text("<html>b1</html>", encoding="utf-8")
            self._git_commit_all(repo_a, "Commit branche ancienne", "2026-09-01T12:00:00+00:00")

            # Seconde branche : branche active préférée avec variante de `lot_commun` + vrai .tile/.rsground
            subprocess.run(
                ["git", "checkout", "-b", "arena/637b0828-projet-creation-pmdo"],
                cwd=str(repo_a),
                check=True,
                capture_output=True,
            )
            (repo_a / "source" / "lot_commun" / "note.txt").write_text("v2_canonique", encoding="utf-8")
            pkg_dir = repo_a / "renders" / "lot_commun" / "package"
            (pkg_dir / "Content" / "Tile").mkdir(parents=True)
            (pkg_dir / "Data" / "Ground").mkdir(parents=True)
            (pkg_dir / "Data" / "Script" / "ground" / "lot_commun_map").mkdir(parents=True)
            shutil.copy2(first_tile, pkg_dir / "Content" / "Tile" / first_tile.name)

            # Crée un .rsground minimal référençant réellement (sheet_name, 0, 1) ou la 1re entrée de first_tile
            entry_real = extraire_entree_depuis_fichier_tile(first_tile)
            first_xy = next(iter(entry_real.positions_dict().keys()))
            mini_rsg = {
                "Version": "0.8.12.0",
                "Object": {
                    "Layers": [
                        {
                            "Tiles": [
                                [
                                    {
                                        "Frames": [
                                            {
                                                "Sheet": sheet_name,
                                                "TexLoc": {"X": first_xy[0], "Y": first_xy[1]},
                                            }
                                        ]
                                    }
                                ]
                            ]
                        }
                    ]
                },
            }
            (pkg_dir / "Data" / "Ground" / "lot_commun_map.rsground").write_text(
                json.dumps(mini_rsg), encoding="utf-8"
            )
            # Ajoute aussi un .rsground homonyme à `collision_map.rsground` pour vérifier le non-écrasement town02
            (pkg_dir / "Data" / "Ground" / "collision_map.rsground").write_text(
                json.dumps(mini_rsg), encoding="utf-8"
            )
            (pkg_dir / "Data" / "Script" / "ground" / "lot_commun_map" / "init.lua").write_text(
                "return {}", encoding="utf-8"
            )
            (repo_a / "index.html").write_text("<html>studio</html>", encoding="utf-8")
            self._git_commit_all(repo_a, "Commit branche active", "2026-10-24T12:00:00+00:00")

            # 3) Crée un dépôt source `guilde-treehouse` avec `salles/01_accueil` et `exterieur/jour.png`
            repo_b = tmp / "meromoonmeri_guilde-treehouse-pmd"
            repo_b.mkdir()
            self._git_init(repo_b, "main")
            (repo_b / "salles" / "01_accueil").mkdir(parents=True)
            (repo_b / "salles" / "01_accueil" / "room.json").write_text("{}", encoding="utf-8")
            (repo_b / "exterieur").mkdir(parents=True)
            (repo_b / "exterieur" / "jour.png").write_bytes(b"\x89PNG\r\n\x1a\n")
            (repo_b / "source" / "zone_guilde_treehouse_v2").mkdir(parents=True)
            (repo_b / "source" / "zone_guilde_treehouse_v2" / "readme.md").write_text("guilde", encoding="utf-8")
            self._git_commit_all(repo_b, "Commit guilde treehouse", "2026-10-20T12:00:00+00:00")

            # 4) Exécute la fusion complète dans `out_unified`
            out_unified = tmp / "unified_town02"
            shutil.copytree(t2_root, out_unified)
            report = fusionner_branches_dans_town02(
                target_root=out_unified,
                source_repos=[
                    ("meromoonmeri/projet-creation-pmdo", repo_a),
                    ("meromoonmeri/guilde-treehouse-pmd", repo_b),
                ],
                garder_variantes=True,
                compiler_builds=False,
            )

            # Vérifications exhaustives
            self.assertEqual(report.branches_scanned, 3)
            self.assertEqual(report.source_lots_merged, 3)  # lot_commun + lot_branche_ancienne + zone_guilde_treehouse_v2
            self.assertEqual(report.branch_variants_saved, 1)  # variante ancienne de lot_commun conservée !
            self.assertEqual(
                (out_unified / "maps_sources" / "source" / "lot_commun" / "note.txt").read_text(encoding="utf-8"),
                "v2_canonique",
            )
            self.assertTrue((out_unified / "maps_sources" / "source" / "lot_branche_ancienne" / "info.txt").is_file())
            self.assertTrue((out_unified / "maps_sources" / "source" / "zone_guilde_treehouse_v2" / "readme.md").is_file())
            self.assertTrue((out_unified / "maps_sources" / "guilde_treehouse" / "salles" / "01_accueil" / "room.json").is_file())
            self.assertTrue((out_unified / "maps_sources" / "salles").is_symlink())

            # collision_map.rsground de town02 est resté intact ET la version custom est aliasée proprement
            self.assertTrue(
                (out_unified / "Data" / "Ground" / "collision_map.rsground")
                .read_bytes()
                .startswith(b"version https://git-lfs")
            )
            self.assertTrue((out_unified / "Data" / "Ground" / "collision_map__custom_pmdo.rsground").is_file())
            self.assertTrue((out_unified / "Data" / "Ground" / "lot_commun_map.rsground").is_file())
            self.assertTrue((out_unified / "Data" / "Script" / "ground" / "lot_commun_map" / "init.lua").is_file())

            # index.idx contient 00_ciel + sheet_name et 0 damier mauve
            self.assertEqual(report.tile_index_before, 1)
            self.assertEqual(report.tile_index_after, 2)
            self.assertGreaterEqual(report.verified_tile_refs, 2)
            self.assertTrue((out_unified / "CATALOGUE_COMPLET_UNIFIE.md").is_file())

            # Test du garde Git LFS > seuil
            big_dummy = out_unified / "maps_sources" / "gros_test.bin"
            big_dummy.write_bytes(b"x" * 1024)
            added = proteger_gros_fichiers_git_lfs(out_unified, seuil_octets=512)
            self.assertIn("maps_sources/gros_test.bin", added)

    @staticmethod
    def _git_init(path: Path, branch: str) -> None:
        subprocess.run(["git", "init", "-b", branch], cwd=str(path), check=True, capture_output=True)
        subprocess.run(["git", "config", "user.email", "test@example.com"], cwd=str(path), check=True)
        subprocess.run(["git", "config", "user.name", "Test"], cwd=str(path), check=True)

    @staticmethod
    def _git_commit_all(path: Path, msg: str, iso_date: str) -> None:
        subprocess.run(["git", "add", "-A"], cwd=str(path), check=True)
        env = dict(**subprocess.os.environ)
        env["GIT_AUTHOR_DATE"] = iso_date
        env["GIT_COMMITTER_DATE"] = iso_date
        subprocess.run(["git", "commit", "-m", msg], cwd=str(path), check=True, env=env, capture_output=True)


if __name__ == "__main__":
    unittest.main()
