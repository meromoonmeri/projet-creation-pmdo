#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de la cinématique « Pichu & la Team Dazzling » (5 min, map native cliffdaytest) :
durée 300 s, 4 personnages, portraits PMDO par émotion, boîtes de dialogue, aucun chargement externe."""
from __future__ import annotations

import base64
import json
import re
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent
sys.path.insert(0, str(REPO_ROOT))

HTML = REPO_ROOT / "apercu_cine_pichu_team_dazzling.html"


class TestCinePichuDazzling(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.txt = HTML.read_text(encoding="utf-8")
        i0 = cls.txt.index("const ASSETS = ") + len("const ASSETS = ")
        i1 = cls.txt.index(";\n</script>", i0)
        cls.A = json.loads(cls.txt[i0:i1])

    def test_01_page_autonome_5_minutes(self) -> None:
        self.assertTrue(HTML.is_file())
        self.assertLess(len(self.txt), 12_000_000)
        self.assertEqual(len(re.findall(r'<(?:img|script|link)[^>]*src="http', self.txt)), 0, "aucune ressource externe au chargement")
        self.assertIn("youtube.com/embed/iV04Wl5DLJo", self.txt)  # OST optionnelle (Beta's Theme), activée au clic seulement
        self.assertIn("const W = 1280, H = 720, D = 300.0", self.txt)
        self.assertIn("PMDDestinyDazzling", self.txt)

    def test_02_map_native_cliffdaytest(self) -> None:
        for k in ("mapUnder", "mapOver"):
            self.assertTrue(self.A["imgs"][k].startswith("data:image/png;base64,"), k)

    def test_03_quatre_personnages_et_portraits_emotions(self) -> None:
        cat = self.A["catalog"]["pokemon"]
        self.assertEqual(sorted(cat), ["0172", "0303", "0428", "0763"])
        self.assertEqual(cat["0428"]["name"], "Sonata Loponny")
        self.assertEqual(cat["0763"]["name"], "Adagio Tsareen")
        self.assertEqual(cat["0303"]["name"], "Aria Mawile")
        pt = self.A["catalog"]["portraits"]
        for pid in cat:
            self.assertGreaterEqual(len(pt[pid]), 10, f"portraits {pid}")
            for emo in ("Normal", "Crying", "Teary-Eyed", "Worried", "Determined"):
                self.assertIn(emo, pt[pid])
            for an in ("Walk", "Idle"):
                self.assertIn(an, cat[pid]["anims"])
            self.assertTrue(self.A["imgs"][f"pt_{pid}_Crying"].startswith("data:image/png"))

    def test_04_dialogues_canoniques(self) -> None:
        lines = self.A["catalog"]["script"]["lines"]
        self.assertGreaterEqual(len(lines), 28)
        emos = set()
        for t0, t1, pid, emo, txt in lines:
            self.assertLess(t0, t1)
            self.assertIn(pid, self.A["catalog"]["pokemon"])
            self.assertTrue(15 <= len(txt) <= 140)
            emos.add(emo)
        for emo in ("Crying", "Teary-Eyed", "Worried", "Determined", "Joyous", "Angry", "Inspired", "Sigh", "Stunned", "Pain"):
            self.assertIn(emo, emos)
        self.assertIn("enfaite", json.dumps(lines, ensure_ascii=False))  # tic de langage de Sonata
        for needle in ("dialogBox", "▼", "froussard"):
            self.assertIn(needle, self.txt if needle != "froussard" else json.dumps(lines, ensure_ascii=False))

    def test_05_plans_contigus_0_300(self) -> None:
        shots = self.A["catalog"]["script"]["shots"]
        self.assertEqual(shots[0]["t0"], 0)
        for a, b in zip(shots, shots[1:]):
            self.assertEqual(a["t1"], b["t0"], "plans contigus")
        self.assertEqual(shots[-1]["t1"], 300)

    def test_06_emotes_et_viewport_pmdo(self) -> None:
        em = self.A["catalog"]["script"]["emotes"]
        self.assertGreaterEqual(len(em), 25)
        kinds = {e[3] for e in em}
        for k in ("sweat", "note", "anger", "heart", "exclaim", "cry", "dots", "question", "sparkle"):
            self.assertIn(k, kinds)
        self.assertIn("function emote(", self.txt)
        self.assertIn("opts.game", self.txt.replace("!!opts.game", "opts.game"))
        self.assertIn("Viewport PMDO (condition de jeu)", self.txt)
        self.assertIn("Rejouer la cinématique", self.txt)
        self.assertNotIn("sc.fade && t < sc.t0", self.txt, "plus de fondus noirs entre les plans")

    def test_07_entree_team_et_poses(self) -> None:
        shots = {s["id"]: s for s in self.A["catalog"]["script"]["shots"]}
        s5 = json.dumps(shots["S5"], ensure_ascii=False)
        for needle in ("Appeal", "Kick", "Strike", "Walk"):
            self.assertIn(needle, s5)
        s10 = json.dumps(shots["S10"], ensure_ascii=False)
        for needle in ("Sit", "Cringe", "Pose", "LookUp"):
            self.assertIn(needle, s10)

    # ------------------------------------------------------------------ page = viewer sûr
    def test_08_preload_images_et_controles_viewer(self) -> None:
        """Le BOOT doit décoder les data-URIs via new Image() AVANT create() : sans cela
        drawImage reçoit des chaînes => TypeError => canvas NOIR (régression de 10/26)."""
        boot = self.txt[self.txt.rindex("<script>"):]
        self.assertIn("new Image()", boot)
        self.assertIn("Promise.all(", boot)
        self.assertIn("im.onload", boot)
        self.assertLess(boot.index("Promise.all("), boot.index("function boot()"))
        for ctl in ('id="seek"', 'id="play"', 'id="plans"', 'id="replay"', 'id="mode"', 'id="ovl"'):
            self.assertIn(ctl, self.txt)
        self.assertIn("t = t % D", boot, "la lecture boucle au lieu de figer sur le fondu noir final")
        self.assertIn("document.hidden", boot, "pause onglet caché")
        self.assertIn("function paintBg(", self.txt, "fond de secours : jamais d'écran noir")

    # ------------------------------------------------------------------ map complète + animée
    def test_09_map_native_complete_et_animee(self) -> None:
        under = Image.open(HERE / "cine_pichu_dazzling" / "plates" / "cliffdaytest_jour_under.png")
        self.assertEqual(under.size, (984, 792), "grille réelle 123x99 cellules (l'ancien 792x984 rognait falaise+mer)")
        anim = json.loads((HERE / "cine_pichu_dazzling" / "plates" / "cliffdaytest_jour_anim.json").read_text(encoding="utf-8"))
        self.assertGreaterEqual(len(anim["seqs"]), 400, "tuiles animées (mer, eau, drapeaux…)")
        self.assertEqual(anim["fps"], 7.5)
        self.assertTrue((HERE / "cine_pichu_dazzling" / "plates" / "cliffdaytest_jour_anim_atlas.png").is_file())
        walk = json.loads((HERE / "cine_pichu_dazzling" / "plates" / "cliffdaytest_walk.json").read_text(encoding="utf-8"))
        self.assertEqual((walk["w"], walk["h"]), (123, 99))
        self.assertEqual(len(base64.b64decode(walk["b64"])), (123 * 99 + 7) // 8)
        self.assertEqual(self.A["catalog"]["map"], {"w": 984, "h": 792})
        self.assertIn("mapAnimAtlas", self.txt)
        self.assertIn("AN.seqs", self.txt)

    # ------------------------------------------------------------------ la team évite l'arbre
    def test_10_personnages_jamais_dans_les_arbres(self) -> None:
        over = np.asarray(Image.open(HERE / "cine_pichu_dazzling" / "plates" / "cliffdaytest_jour_over.png").convert("RGBA"))[:, :, 3]
        shots = self.A["catalog"]["script"]["shots"]

        def lerp(keys, t):
            if t <= keys[0][0]:
                return keys[0][1:]
            for i in range(len(keys) - 1):
                if keys[i][0] <= t < keys[i + 1][0]:
                    u = (t - keys[i][0]) / (keys[i + 1][0] - keys[i][0])
                    return [keys[i][1] + (keys[i + 1][1] - keys[i][1]) * u,
                            keys[i][2] + (keys[i + 1][2] - keys[i][2]) * u]
            return keys[-1][1:]

        bad = []
        for sc in shots:
            for a in sc.get("actors", []):
                t = sc["t0"]
                while t < sc["t1"]:
                    x, y = lerp(a["keys"], t)
                    hors = y > 792 and (t < 75 or t > 218)   # entrée/sortie par le bord sud
                    if not hors:
                        if not (0 <= x < 984 and 0 <= y < 792):
                            bad.append((sc["id"], a["id"], round(t, 1), "hors map"))
                        else:
                            cx, cy = int(x) // 8, int(y) // 8
                            zone = over[max(0, cy - 1) * 8:(cy + 1) * 8, cx * 8:(cx + 1) * 8]
                            if zone.size and zone.max() > 40:
                                bad.append((sc["id"], a["id"], round(t, 1), "dans un arbre"))
                    t += 0.25
        self.assertEqual(bad, [], "la team (et Pichu) ne traverse ni ne stationne dans les arbres/objets")

    # ------------------------------------------------------------------ cutscene in-game Halcyon
    def test_11_cutscene_lua_in_game(self) -> None:
        import importlib.util as ilu
        sp = ilu.spec_from_file_location("cine_cutscene_lua", HERE / "cine_pichu_dazzling" / "cutscene_lua.py")
        cl = ilu.module_from_spec(sp)
        sp.loader.exec_module(cl)
        lua = cl.generate_lua(self.A["catalog"]["script"]["shots"],
                              self.A["catalog"]["script"]["lines"],
                              self.A["catalog"]["script"]["emotes"])
        for tok in ("GAME:CutsceneMode(true)", "GAME:_MoveCamera(", "GROUND:MoveToPosition(",
                    "GAME:WaitFrames(", "GAME:FadeIn(40)", "GAME:FadeOut(false, 40)",
                    "UI:SetSpeakerEmotion(", "GROUND:CharSetAnim(", "CH(PICHU)",
                    "require 'common'", "require 'GeneralFunctions'"):
            self.assertIn(tok, lua)
        self.assertEqual(lua.count("UI:WaitShowDialogue("), len(self.A["catalog"]["script"]["lines"]))
        self.assertGreaterEqual(lua.count("GROUND:CharSetEmote("), len(self.A["catalog"]["script"]["emotes"]))
        self.assertIn("enfaite", lua)  # répliques de Sonata conservées in-game
        with tempfile.TemporaryDirectory() as td:
            dst = Path(td) / "cliffdaytest_cine.rsground"
            cl.inject_mapchars(REPO_ROOT / "cliffdaytest.rsground", dst)
            o = json.loads(dst.read_text(encoding="utf-8"))["Object"]
            chars = o["Entities"][0]["MapChars"]
            self.assertEqual([c["EntName"] for c in chars],
                             ["Pichu_Cine", "Lopunny_Cine", "Tsareena_Cine", "Mawile_Cine"])
            for c in chars:
                self.assertFalse(c["AIEnabled"])
                self.assertIn(c["Data"]["BaseForm"]["Species"], ("pichu", "lopunny", "tsareena", "mawile"))
        lua_pkg = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "fangame_base" / "Data" / "Script" / "halcyon" / "ground" / "cliffdaytest" / "init.lua"
        self.assertTrue(lua_pkg.is_file(), "cutscene livrée dans le fangame")


if __name__ == "__main__":
    unittest.main()
