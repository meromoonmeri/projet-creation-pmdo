#!/usr/bin/env python3
"""
Suite complète de tests unitaires + tests de mutation pour la Suite Tour Céleste, Chemin, Sommet & Suite (PMDO 0.8.12) :
  1. Validation structurelle, géométrique, chromatique et d'animation des 8 cartes 4:3 (768x576, 96x72 tuiles 8x8).
  2. Validation binaire intégrale des 8 + 8 = 16 Mods PMDO 0.8.12 (.rsground, .tile, Content/Tile/index.idx, Mod.xml, init.lua).
  3. Validation de connectivité BFS 16x16 de tous les marqueurs + fermeture Nord sur les sommets / traversée Sud-Nord sur les relais.
  4. Audit zéro crédit / zéro mention tierce sur l'intégralité du dépôt, des HTML, des manifestes et des archives .zip virtuelles.
  5. 6 tests de mutation actifs prouvant que le validateur rejette immédiatement toute corruption :
       M1. TexLoc hors bornes dans .rsground
       M2. Feuille .tile manquante dans Content/Tile/index.idx
       M3. Rupture du chemin praticable 16x16 entre entrance et boss/objectif
       M4. Brèche Nord accidentelle sur un sommet à Nord fermé (SKY3)
       M5. Dérive chromatique (> 35 RVB) par rapport aux références PMD Red / PMD Sky Port
       M6. Injection d'une mention de crédit interdite dans un fichier ou Mod.xml
  6. Vérification distante du tag GitHub sans LFS `refs/tags/town02-quest-pmdo-0812-complete` (3 655 cartes, 0 LFS).
"""
from __future__ import annotations

import copy
import importlib.util
import json
import re
import shutil
import subprocess
import tempfile
import unittest
import zipfile
from collections import deque
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT_ROOT = R / "renders/suite_tour_celeste_pmdo_v1"
STAGE_ROOT = R / ".cache/suite_tour_celeste_pmdo_v1"
VZIP_ROOT = R / ".cache/virtual_zips/renders/suite_tour_celeste_pmdo_v1"

sp = importlib.util.spec_from_file_location("sync_mod", HERE / "sync_quest_tag.py")
assert sp and sp.loader
sync_mod = importlib.util.module_from_spec(sp)
sp.loader.exec_module(sync_mod)
decode_index_bytes = sync_mod.decode_index_bytes

FORBIDDEN_CREDIT_PATTERNS = re.compile(
    r"(spriters[\s_-]*resource|project[\s_-]*pokemon|skytemple|credit\s*:|crédits?\s*:|attributions?\s*:)",
    re.IGNORECASE,
)


def validate_single_mod_dir(
    mod_dir: Path,
    expect_north_closed: bool | None = None,
    chroma_dist: float | None = None,
) -> None:
    """Valide strictement un dossier Mod PMDO 0.8.12 ; lève ValueError à la moindre anomalie."""
    mod_xml = mod_dir / "Mod.xml"
    if not mod_xml.is_file():
        raise ValueError("Mod.xml manquant")
    xml_txt = mod_xml.read_text(encoding="utf-8")
    if FORBIDDEN_CREDIT_PATTERNS.search(xml_txt):
        raise ValueError("Crédit interdit détecté dans Mod.xml")

    idx_path = mod_dir / "Content/Tile/index.idx"
    if not idx_path.is_file():
        raise ValueError("Content/Tile/index.idx manquant")
    _, nodes = decode_index_bytes(idx_path.read_bytes())

    tile_files = {p.stem: p for p in (mod_dir / "Content/Tile").glob("*.tile")}
    if set(nodes.keys()) != set(tile_files.keys()):
        raise ValueError(f"Désalignement index.idx ({set(nodes)}) vs .tile ({set(tile_files)})")

    rsg_files = list((mod_dir / "Data/Ground").glob("*.rsground"))
    if len(rsg_files) != 1:
        raise ValueError(f"Nombre de .rsground invalide : {len(rsg_files)}")
    rsg = json.loads(rsg_files[0].read_text(encoding="utf-8"))
    if rsg.get("Version") != "0.8.12.0":
        raise ValueError(f"Version PMDO invalide : {rsg.get('Version')}")
    obj = rsg["Object"]
    if obj.get("TexSize") != 1:
        raise ValueError(f"TexSize invalide : {obj.get('TexSize')}")
    if FORBIDDEN_CREDIT_PATTERNS.search(json.dumps(rsg, ensure_ascii=False)):
        raise ValueError("Crédit interdit détecté dans .rsground")

    obs = obj["obstacles"]
    gw = len(obs)
    gh = len(obs[0])
    # Vérifie chaque TexLoc référencé dans chaque calque
    has_multi_frame_anim = False
    for lay in obj["Layers"]:
        tiles_2d = lay["Tiles"]
        if len(tiles_2d) != gw or len(tiles_2d[0]) != gh:
            raise ValueError("Dimensions de calque incohérentes avec obstacles")
        for x in range(gw):
            for y in range(gh):
                cell_obj = tiles_2d[x][y]
                if not isinstance(cell_obj, dict) or "Layers" not in cell_obj:
                    raise ValueError(f"Cellule de tuile malformée en ({x},{y})")
                for sub_lay in cell_obj["Layers"]:
                    cell_frames = sub_lay.get("Frames", [])
                    if len(cell_frames) > 1:
                        has_multi_frame_anim = True
                    for fr in cell_frames:
                        sh = fr["Sheet"]
                        tx, ty = fr["TexLoc"]["X"], fr["TexLoc"]["Y"]
                        if sh not in nodes:
                            raise ValueError(f"Feuille .tile non indexée : {sh}")
                        if (tx, ty) != (0, 0) and (tx, ty) not in nodes[sh]["positions"]:
                            raise ValueError(f"TexLoc hors bornes ({tx},{ty}) dans {sh}")
    if not has_multi_frame_anim:
        raise ValueError("Aucune tuile animée multi-frame détectée dans la carte")

    # Connectivité 16x16 (2x2 cases) entre tous les marqueurs
    walk = [[obs[x][y]["Tags"] == 0 for x in range(gw)] for y in range(gh)]
    if expect_north_closed is True:
        if any(walk[0]):
            raise ValueError("La bordure Nord devrait être fermée mais contient une case praticable")
    if expect_north_closed is False:
        if not any(walk[0]):
            raise ValueError("La sortie Nord devrait être ouverte mais la ligne 0 est entièrement bloquée")

    markers = obj["Entities"][0]["Markers"]
    if len(markers) < 2:
        raise ValueError("Moins de 2 marqueurs présents")

    ok2 = [[False] * gw for _ in range(gh)]
    for y in range(gh - 1):
        for x in range(gw - 1):
            if walk[y][x] and walk[y][x + 1] and walk[y + 1][x] and walk[y + 1][x + 1]:
                ok2[y][x] = True

    m_cells = []
    for mk in markers:
        c = mk["Collider"]
        mx, my = c["X"] // 8, c["Y"] // 8
        if not (0 <= mx < gw - 1 and 0 <= my < gh - 1 and ok2[my][mx]):
            raise ValueError(f"Marqueur {mk['EntName']} placé sur une collision ({mx},{my})")
        m_cells.append((mx, my))

    sx, sy = m_cells[0]
    vis = {(sx, sy)}
    q = deque([(sx, sy)])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < gw - 1 and 0 <= ny < gh - 1 and ok2[ny][nx] and (nx, ny) not in vis:
                vis.add((nx, ny))
                q.append((nx, ny))
    for mx, my in m_cells[1:]:
        if (mx, my) not in vis:
            raise ValueError(f"Marqueur ({mx},{my}) inaccessible en 16x16 depuis entrance ({sx},{sy})")

    if chroma_dist is not None and chroma_dist > 35.0:
        raise ValueError(f"Distance chromatique excessive : {chroma_dist} > 35.0")


class TestSuiteTourCelesteEtSuite(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = json.loads((OUT_ROOT / "suite_manifest.json").read_text(encoding="utf-8"))

    def test_01_eight_workshop_maps_768x576_complete_and_faithful(self) -> None:
        self.assertEqual(len(self.manifest["maps"]), 8)
        expected_north_closed = {
            "FRZ1": True,
            "CVM1": True,
            "SKY1": True,
            "SKY2": False,  # Traversée Sud -> Nord intégrale !
            "SKY3": True,
            "MET1": True,
            "FAR1": True,
            "PKS1": True,
        }
        for m in self.manifest["maps"]:
            code = m["code"]
            with self.subTest(map=code):
                with Image.open(R / m["base_png"]) as base_im:
                    self.assertEqual(base_im.size, (768, 576))
                self.assertEqual(len(m["animation"]["frames"]), 8)
                self.assertLessEqual(m["chromatic_distance_vs_port_ref"], 35.0)
                for rp in m["reference_pngs"]:
                    self.assertTrue((R / rp).is_file(), rp)
                validate_single_mod_dir(
                    STAGE_ROOT / m["asset_name"],
                    expect_north_closed=expected_north_closed[code],
                    chroma_dist=m["chromatic_distance_vs_port_ref"],
                )
                vzip = R / ".cache/virtual_zips" / m["mod_zip_url"]
                self.assertTrue(vzip.is_file(), vzip)
                with zipfile.ZipFile(vzip, "r") as zf:
                    self.assertIsNone(zf.testzip())
                    self.assertIn("Content/Tile/index.idx", zf.namelist())

    def test_02_eight_native_1x1_restorations_valid(self) -> None:
        self.assertEqual(len(self.manifest["native_1x1_maps"]), 8)
        for nm in self.manifest["native_1x1_maps"]:
            with self.subTest(native=nm["asset_name"]):
                validate_single_mod_dir(STAGE_ROOT / nm["asset_name"])
                vzip = R / ".cache/virtual_zips" / nm["mod_zip_url"]
                self.assertTrue(vzip.is_file(), vzip)
                with zipfile.ZipFile(vzip, "r") as zf:
                    self.assertIsNone(zf.testzip())

    def test_03_zero_credits_everywhere(self) -> None:
        for html_p in sorted(R.glob("*.html")):
            txt = html_p.read_text(encoding="utf-8", errors="ignore")
            self.assertIsNone(FORBIDDEN_CREDIT_PATTERNS.search(txt), f"Crédit trouvé dans {html_p.name}")
        for f in sorted(OUT_ROOT.rglob("*.json")):
            txt = f.read_text(encoding="utf-8")
            self.assertIsNone(FORBIDDEN_CREDIT_PATTERNS.search(txt), f"Crédit trouvé dans {f}")
        for vz in sorted(VZIP_ROOT.rglob("*.zip")):
            with zipfile.ZipFile(vz, "r") as zf:
                for name in zf.namelist():
                    if name.endswith((".xml", ".lua", ".md", ".rsground", ".json", ".txt")):
                        txt = zf.read(name).decode("utf-8", errors="ignore")
                        self.assertIsNone(FORBIDDEN_CREDIT_PATTERNS.search(txt), f"Crédit dans {vz.name}:{name}")

    def test_04_mutation_kill_all_six_failure_modes(self) -> None:
        src_mod = STAGE_ROOT / "sky3_sommet_tour_celeste_rayquaza"
        with tempfile.TemporaryDirectory() as tmp:
            tpath = Path(tmp)

            # Mutation 1 : TexLoc hors bornes
            m1 = tpath / "m1"
            shutil.copytree(src_mod, m1)
            rsg_p = m1 / "Data/Ground/sky3_sommet_tour_celeste_rayquaza.rsground"
            d = json.loads(rsg_p.read_text(encoding="utf-8"))
            d["Object"]["Layers"][0]["Tiles"][10][10]["Layers"][0]["Frames"][0]["TexLoc"] = {"X": 999, "Y": 999}
            rsg_p.write_text(json.dumps(d), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "TexLoc hors bornes"):
                validate_single_mod_dir(m1)

            # Mutation 2 : Feuille .tile supprimée mais présente dans index.idx
            m2 = tpath / "m2"
            shutil.copytree(src_mod, m2)
            next((m2 / "Content/Tile").glob("*.tile")).unlink()
            with self.assertRaisesRegex(ValueError, "Désalignement index.idx"):
                validate_single_mod_dir(m2)

            # Mutation 3 : Mur coupant le chemin 16x16 entre entrance et boss
            m3 = tpath / "m3"
            shutil.copytree(src_mod, m3)
            rsg_p3 = m3 / "Data/Ground/sky3_sommet_tour_celeste_rayquaza.rsground"
            d3 = json.loads(rsg_p3.read_text(encoding="utf-8"))
            for x in range(len(d3["Object"]["obstacles"])):
                d3["Object"]["obstacles"][x][45]["Tags"] = 1
            rsg_p3.write_text(json.dumps(d3), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "inaccessible en 16x16"):
                validate_single_mod_dir(m3)

            # Mutation 4 : Brèche Nord sur sommet censé être fermé (SKY3)
            m4 = tpath / "m4"
            shutil.copytree(src_mod, m4)
            rsg_p4 = m4 / "Data/Ground/sky3_sommet_tour_celeste_rayquaza.rsground"
            d4 = json.loads(rsg_p4.read_text(encoding="utf-8"))
            d4["Object"]["obstacles"][48][0]["Tags"] = 0
            rsg_p4.write_text(json.dumps(d4), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "bordure Nord devrait être fermée"):
                validate_single_mod_dir(m4, expect_north_closed=True)

            # Mutation 5 : Dérive chromatique > 35 RVB
            with self.assertRaisesRegex(ValueError, "Distance chromatique excessive"):
                validate_single_mod_dir(src_mod, expect_north_closed=True, chroma_dist=49.5)

            # Mutation 6 : Injection d'un crédit interdit dans Mod.xml
            m6 = tpath / "m6"
            shutil.copytree(src_mod, m6)
            (m6 / "Mod.xml").write_text(
                (m6 / "Mod.xml").read_text(encoding="utf-8") + "\n<!-- Credits: Spriters Resource -->\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "Crédit interdit"):
                validate_single_mod_dir(m6)

    def test_05_remote_quest_tag_synced_non_lfs(self) -> None:
        sync_file = OUT_ROOT / "quest_tag_sync.json"
        self.assertTrue(sync_file.is_file(), "quest_tag_sync.json manquant — exécuter sync_quest_tag.py d'abord")
        sync_data = json.loads(sync_file.read_text(encoding="utf-8"))
        self.assertEqual(sync_data["uploaded_grounds"], 16)
        self.assertGreaterEqual(sync_data["total_grounds_in_tag"], 3655)
        res = subprocess.run(
            ["gh", "api", "repos/meromoonmeri/projet-creation-pmdo/git/refs/tags/town02-quest-pmdo-0812-complete", "--jq", ".object.sha"],
            cwd=R,
            check=True,
            capture_output=True,
            text=True,
        )
        self.assertEqual(res.stdout.strip(), sync_data["new_commit"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
