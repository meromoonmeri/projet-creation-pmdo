#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Suite de tests unitaires PMDO `0.8.12.0` pour l'écran-titre et le fangame
**Pokémon Mystery Dungeon : Destiny** (`DST1` + `.dir` animé + `Title.png` + service Lua)."""
from __future__ import annotations

import json
import sys
import unittest
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_pmd_destiny_fangame import decode_pmdo_dir_sheet
from source.pmd_destiny_fangame_v1 import build as dst_build


class TestPMDDestinyTitleAndFangame(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        meta_path = dst_build.RENDERS_DIR / "metadata.json"
        if not meta_path.is_file() or not dst_build.PACK_DESTINY_ZIP.is_file():
            cls.meta = dst_build.build()
        else:
            cls.meta = json.loads(meta_path.read_text(encoding="utf-8"))
        cls.fb = dst_build.RENDERS_DIR / "fangame_base"

    def test_01_dir_binary_spec_and_no_baked_logo(self) -> None:
        """Vérifie le binaire exact `Content/BG/Title_Screen_Background.dir` (`320×240`, `24` poses, sans logo)."""
        dir_path = self.fb / "Content" / "BG" / "Title_Screen_Background.dir"
        self.assertTrue(dir_path.is_file())
        atlas, trailer = decode_pmdo_dir_sheet(dir_path)
        self.assertEqual(trailer, (320, 240, 0, 24))
        self.assertEqual(atlas.size, (1920, 960))

        arr = np.asarray(atlas, dtype=np.uint8)
        self.assertTrue(np.all(arr[:, :, 3] == 255), "Toutes les poses du .dir doivent être opaques")
        r, g, b = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16)
        self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, "0 px magenta dans Title_Screen_Background.dir")

        # Pose 0 (0,0)..(320,240) = Crépuscule Doré (horizon chaud R > B), Pose 12 = Nuit Étoilée (B > R)
        pose0 = arr[0:240, 0:320, :3].astype(np.float32)
        pose12 = arr[480:720, 0:320, :3].astype(np.float32)
        pose23 = arr[720:960, 1600:1920, :3].astype(np.float32)
        pose1 = arr[0:240, 320:640, :3].astype(np.float32)

        # Ciel + mer nettement plus sombres la nuit qu'au crépuscule
        self.assertGreater(pose0.mean(), pose12.mean() + 35.0)
        # Mer (y=160..239) passe bien du saphir crépusculaire au bleu nuit profond
        self.assertGreater(pose0[160:, :, 1].mean(), pose12[160:, :, 1].mean() + 25.0)
        # Continuité parfaite de la boucle entre Pose 23 et Pose 0
        diff_loop = float(np.abs(pose23 - pose0).mean())
        diff_step = float(np.abs(pose1 - pose0).mean())
        self.assertLess(diff_loop, diff_step * 2.2 + 2.0, "La boucle pose 23 -> pose 0 doit être sans couture")

        # Vérifie que le logo jaune 'Pokémon' n'est PAS cuit dans le .dir (ouverture céleste haute à Pose 12 sombre)
        sky_top_p12 = pose12[12:55, 110:210]
        yellow_logo_px = (sky_top_p12[:, :, 0] > 220) & (sky_top_p12[:, :, 1] > 180) & (sky_top_p12[:, :, 2] < 60)
        self.assertLess(int(yellow_logo_px.sum()), 15, "Aucun texte/logo ne doit être cuit dans Title_Screen_Background.dir")

    def test_02_title_and_enter_ui_zero_magenta_leak(self) -> None:
        """Vérifie `Content/UI/Title.png` (`320×240`), `Enter.png` (`74×11`) et `Logo_PMD_Destiny_HD.png`."""
        title_p = self.fb / "Content" / "UI" / "Title.png"
        enter_p = self.fb / "Content" / "UI" / "Enter.png"
        hd_p = dst_build.RENDERS_DIR / "apercus_menu" / "Logo_PMD_Destiny_HD.png"
        for p, expected_sz in ((title_p, (320, 240)), (enter_p, (74, 11))):
            self.assertTrue(p.is_file())
            im = Image.open(p).convert("RGBA")
            self.assertEqual(im.size, expected_sz)
            arr = np.asarray(im, dtype=np.uint8)
            fg = arr[:, :, 3] > 0
            self.assertGreater(int(fg.sum()), 300)
            r, g, b = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16)
            neon_mag = fg & (r >= 220) & (g <= 40) & (b >= 220)
            self.assertEqual(int(neon_mag.sum()), 0, f"Fuite #FF00FF détectée dans {p.name}")

        hd = np.asarray(Image.open(hd_p).convert("RGBA"), dtype=np.uint8)
        fg_hd = hd[:, :, 3] == 255
        self.assertGreater(int(fg_hd.sum()), 200000)
        neon_hd = fg_hd & (hd[:, :, 0] >= 220) & (hd[:, :, 1] <= 40) & (hd[:, :, 2] >= 220)
        self.assertEqual(int(neon_hd.sum()), 0)

    def test_03_dst1_10_layers_tile_budgets_and_halcyon_quest_files(self) -> None:
        """Vérifie les 10 banques `.tile` (`< 24 000` tuiles/banque), `Mod.xml`, `Lua` et le `.zip`."""
        self.assertEqual(len(self.meta["layers"]), 10)
        for sheet, count in self.meta["unique_tiles_per_sheet"].items():
            self.assertLess(count, 24000, f"Dépassement de banque tuiles sur {sheet}: {count}")

        mod_root = ET.fromstring((self.fb / "Mod.xml").read_text(encoding="utf-8"))
        self.assertEqual(mod_root.findtext("Name"), "Pokemon Mystery Dungeon: Destiny")
        self.assertEqual(mod_root.findtext("Namespace"), "halcyon")
        self.assertEqual(mod_root.findtext("ModType"), "Quest")

        svc_lua = (
            self.fb / "Data" / "Script" / "halcyon" / "services" / "destiny_title_anim" / "init.lua"
        ).read_text(encoding="utf-8")
        self.assertIn("EngineServiceEvents.AddMenu", svc_lua)
        self.assertIn("MenuDirTex.TexType.BG", svc_lua)
        self.assertIn("Title_Screen_Background", svc_lua)

        with zipfile.ZipFile(dst_build.PACK_DESTINY_ZIP, "r") as zf:
            names = set(zf.namelist())
            self.assertIn("Pokemon_Mystery_Dungeon_Destiny/Mod.xml", names)
            self.assertIn("Pokemon_Mystery_Dungeon_Destiny/Content/BG/Title_Screen_Background.dir", names)
            self.assertIn("Pokemon_Mystery_Dungeon_Destiny/Content/UI/Title.png", names)
            self.assertIn("Pokemon_Mystery_Dungeon_Destiny/Content/UI/Enter.png", names)
            self.assertIn(
                "Pokemon_Mystery_Dungeon_Destiny/Data/Script/halcyon/services/destiny_title_anim/init.lua",
                names,
            )


if __name__ == "__main__":
    unittest.main()
