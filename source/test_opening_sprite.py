#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de l'Opening « sprites PMDO image par image » : autonomie, durée 153 s, sprites réels embarqués."""
from __future__ import annotations

import json
import re
import subprocess
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent
HTML = REPO_ROOT / "apercu_fangame_pmd_destiny.html"
META = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_sprite_cine" / "metadata.json"


class TestOpeningSprite(unittest.TestCase):
    def test_01_autonome_sans_requete_externe(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        self.assertLess(len(txt), 8_000_000)
        self.assertEqual(len(re.findall(r'src="/(?:renders|\.cache)/', txt)), 0)
        self.assertIn("PMDDestinySprite", txt)
        self.assertGreaterEqual(txt.count("data:image/png;base64,"), 60)

    def test_02_duree_153s(self) -> None:
        meta = json.loads(META.read_text(encoding="utf-8"))
        self.assertEqual(meta["duration_seconds"], 153.0)
        self.assertIn("D = 153.0", HTML.read_text(encoding="utf-8"))

    def test_03_acteurs_pmdo(self) -> None:
        meta = json.loads(META.read_text(encoding="utf-8"))
        for pid in ("0447", "0133", "0393", "0448", "0491", "shadow_0447", "shadow_0393"):
            self.assertIn(pid, meta["actors"])
        self.assertGreaterEqual(meta["sheets"], 60)

    def test_04_moteur_js_syntaxe(self) -> None:
        r = subprocess.run(["node", "--check", str(HERE / "opening_sprite_engine.js")], capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)

    def test_05_page_aaa_conservee(self) -> None:
        self.assertTrue((REPO_ROOT / "apercu_fangame_pmd_destiny_aaa_illustre.html").is_file())
        self.assertTrue((REPO_ROOT / "apercu_fangame_pmd_destiny_pixel_opm.html").is_file())


if __name__ == "__main__":
    unittest.main()
