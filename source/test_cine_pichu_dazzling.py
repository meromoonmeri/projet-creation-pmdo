#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de la cinématique « Pichu & la Team Dazzling » (5 min, map native cliffdaytest) :
durée 300 s, 4 personnages, portraits PMDO par émotion, boîtes de dialogue, aucun chargement externe."""
from __future__ import annotations

import json
import re
import sys
import unittest
from pathlib import Path

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
        self.assertEqual(cat["0428"]["name"], "Loponny")
        self.assertEqual(cat["0763"]["name"], "Sucreine")
        self.assertEqual(cat["0303"]["name"], "Mystibul")
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
        for needle in ("dialogBox", "▼", "froussard"):
            self.assertIn(needle, self.txt if needle != "froussard" else json.dumps(lines, ensure_ascii=False))

    def test_05_plans_contigus_0_300(self) -> None:
        shots = self.A["catalog"]["script"]["shots"]
        self.assertEqual(shots[0]["t0"], 0)
        for a, b in zip(shots, shots[1:]):
            self.assertEqual(a["t1"], b["t0"], "plans contigus")
        self.assertEqual(shots[-1]["t1"], 300)

    def test_06_entree_team_et_poses(self) -> None:
        shots = {s["id"]: s for s in self.A["catalog"]["script"]["shots"]}
        s5 = json.dumps(shots["S5"], ensure_ascii=False)
        for needle in ("Appeal", "Kick", "Strike", "Walk"):
            self.assertIn(needle, s5)
        s10 = json.dumps(shots["S10"], ensure_ascii=False)
        for needle in ("Sit", "Cringe", "Pose", "LookUp"):
            self.assertIn(needle, s10)


if __name__ == "__main__":
    unittest.main()
