#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Suite de tests unitaires PMDO `0.8.12.0` pour **Pokémon Mystery Dungeon : Destiny** :
  - Fonds `.dir` **JOUR** et **NUIT** séparés (mer pixel-art générée, 24 poses sans logo)
  - Blason **Œuf + Deux Ailes de chaque côté** plus petit et centré (`Content/UI/Title.png`)
  - Séquence d'**Opening d'Anime en une seule fois** (`Destiny_Logo_Anime_Opening.dir`)
  - Cartes Ground 10 calques `DSTJ` (Jour) & `DSTN` (Nuit) (`< 24 000` tuiles/banque).
"""
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
from source.pmd_destiny_fangame_v1 import build as dstj_build
from source.pmd_destiny_nuit_v1 import build as dstn_build


class TestPMDDestinyDayNightAndAnimeOpening(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        meta_j = dstj_build.RENDERS_DIR / "metadata.json"
        if not meta_j.is_file() or not dstj_build.PACK_DESTINY_ZIP.is_file():
            cls.meta_j = dstj_build.build()
        else:
            cls.meta_j = json.loads(meta_j.read_text(encoding="utf-8"))

        meta_n = dstn_build.RENDERS_DIR / "metadata.json"
        if not meta_n.is_file() or not dstn_build.VIRTUAL_ZIP.is_file():
            cls.meta_n = dstn_build.build()
        else:
            cls.meta_n = json.loads(meta_n.read_text(encoding="utf-8"))

        cls.fb = dstj_build.RENDERS_DIR / "fangame_base"

    def test_01_separate_day_and_night_dirs_and_generated_seas(self) -> None:
        """Vérifie que `Title_Screen_Background_Jour.dir` et `Title_Screen_Background_Nuit.dir` sont séparés."""
        dir_j = self.fb / "Content" / "BG" / "Title_Screen_Background_Jour.dir"
        dir_n = self.fb / "Content" / "BG" / "Title_Screen_Background_Nuit.dir"
        self.assertTrue(dir_j.is_file() and dir_n.is_file())

        atlas_j, tr_j = decode_pmdo_dir_sheet(dir_j)
        atlas_n, tr_n = decode_pmdo_dir_sheet(dir_n)
        self.assertEqual(tr_j, (320, 240, 0, 24))
        self.assertEqual(tr_n, (320, 240, 0, 24))

        arr_j = np.asarray(atlas_j, dtype=np.uint8)
        arr_n = np.asarray(atlas_n, dtype=np.uint8)
        for nm, arr in (("Jour", arr_j), ("Nuit", arr_n)):
            self.assertTrue(np.all(arr[:, :, 3] == 255))
            r, g, b = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16)
            self.assertEqual(int((np.minimum(r, b) - g >= 38).sum()), 0, f"0 px magenta dans {nm}")

        p0_j = arr_j[0:240, 0:320, :3].astype(np.float32)
        p0_n = arr_n[0:240, 0:320, :3].astype(np.float32)
        # Ciel ET mer nettement plus clairs en Jour qu'en Nuit
        self.assertGreater(p0_j[:160].mean(), p0_n[:160].mean() + 70.0)
        self.assertGreater(p0_j[160:].mean(), p0_n[160:].mean() + 45.0)

        # La mer est bien animée sur 24 poses (non statique)
        p6_j = arr_j[240:480, 0:320, :3].astype(np.float32)
        self.assertGreater(float(np.abs(p0_j[160:] - p6_j[160:]).mean()), 0.5)

    def test_02_winged_egg_logo_smaller_centered_and_zero_magenta(self) -> None:
        """Vérifie que le logo façon Super Mystery Dungeon (Œuf+Ailes incrusté) `Title.png` est compact, centré et 0 px #FF00FF."""
        from scipy import ndimage

        title_p = self.fb / "Content" / "UI" / "Title.png"
        im = Image.open(title_p).convert("RGBA")
        self.assertEqual(im.size, (320, 240))
        arr = np.asarray(im, dtype=np.uint8)
        fg = arr[:, :, 3] >= 32
        ys, xs = np.where(fg)
        w_logo = int(xs.max() - xs.min() + 1)
        cx_logo = 0.5 * (float(xs.min()) + float(xs.max()))
        cy_logo = 0.5 * (float(ys.min()) + float(ys.max()))

        # Plus petit (~48 % de 320 px) et parfaitement centré !
        self.assertGreaterEqual(w_logo, 140)
        self.assertLessEqual(w_logo, 180)
        self.assertLess(abs(cx_logo - 160.0), 2.5, "Logo parfaitement centré horizontalement")
        self.assertGreaterEqual(int(ys.min()), 38, "Espace libre en haut pour le ciel et les nuages")
        self.assertLessEqual(int(ys.max()), 162, "Ne déborde pas sur la mer ni sur Enter.png")
        self.assertTrue(88.0 <= cy_logo <= 118.0)

        r, g, b = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16)
        # 0 px #FF00FF néon partout (tout en préservant le dégradé lavande intérieur de Mystery Dungeon)
        neon_mag = fg & (r >= 205) & (g <= 70) & (b >= 205)
        self.assertEqual(int(neon_mag.sum()), 0, "0 px #FF00FF néon")
        dist = ndimage.distance_transform_edt(fg)
        perim = fg & (dist <= 2.5)
        self.assertEqual(int((perim & ((np.minimum(r, b) - g) >= 32)).sum()), 0, "0 halo rose sur le contour")

    def test_03_one_shot_anime_opening_sequence(self) -> None:
        """Vérifie que `Destiny_Logo_Anime_Opening.dir` arrive en une seule fois et reste fixe à la fin."""
        open_p = self.fb / "Content" / "Obj" / "Destiny_Logo_Anime_Opening.dir"
        atlas_o, tr_o = decode_pmdo_dir_sheet(open_p)
        self.assertEqual(tr_o, (320, 240, 0, 24))
        arr_o = np.asarray(atlas_o, dtype=np.uint8)

        # Frame 0..2 : entièrement transparentes (anticipation mer & ciel)
        f0_alpha = arr_o[0:240, 0:320, 3]
        self.assertEqual(int(f0_alpha.max()), 0)

        # Frame 21, 22, 23 : logo stabilisé identique à la fin (ne repart jamais en boucle arrière !)
        f21 = arr_o[720:960, 960:1280]
        f22 = arr_o[720:960, 1280:1600]
        f23 = arr_o[720:960, 1600:1920]
        self.assertGreater(int((f23[:, :, 3] > 128).sum()), 4000)
        self.assertTrue(np.array_equal(f21, f22) and np.array_equal(f22, f23))

    def test_04_dstj_and_dstn_tile_budgets_and_zip_bundle(self) -> None:
        """Vérifie les budgets `< 24 000` tuiles/banque de `DSTJ` et `DSTN` et le contenu du `.zip`."""
        for label, meta in (("DSTJ", self.meta_j), ("DSTN", self.meta_n)):
            self.assertEqual(len(meta["layers"]), 10)
            for sheet, count in meta["unique_tiles_per_sheet"].items():
                self.assertLess(count, 24000, f"Dépassement tuiles {label}/{sheet}: {count}")

        mod_root = ET.fromstring((self.fb / "Mod.xml").read_text(encoding="utf-8"))
        self.assertEqual(mod_root.findtext("Name"), "Pokemon Mystery Dungeon: Destiny")
        self.assertEqual(mod_root.findtext("Namespace"), "halcyon")

        with zipfile.ZipFile(dstj_build.PACK_DESTINY_ZIP, "r") as zf:
            names = set(zf.namelist())
            for req in (
                "Pokemon_Mystery_Dungeon_Destiny/Mod.xml",
                "Pokemon_Mystery_Dungeon_Destiny/Content/BG/Title_Screen_Background_Jour.dir",
                "Pokemon_Mystery_Dungeon_Destiny/Content/BG/Title_Screen_Background_Nuit.dir",
                "Pokemon_Mystery_Dungeon_Destiny/Content/Obj/Destiny_Logo_Anime_Opening.dir",
                "Pokemon_Mystery_Dungeon_Destiny/Content/UI/Title.png",
                "Pokemon_Mystery_Dungeon_Destiny/Data/Script/halcyon/services/destiny_title_anim/init.lua",
            ):
                self.assertIn(req, names)


if __name__ == "__main__":
    unittest.main()
