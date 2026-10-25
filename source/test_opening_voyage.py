#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de l'Opening « Voyage » : autonomie, durée 153 s, calques générés, sprites PMDO réels, scènes attendues."""
from __future__ import annotations

import json
import re
import subprocess
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent
HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_voyage.html"
META = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_voyage" / "metadata.json"
ENGINE = HERE / "opening_voyage_engine.js"


class TestOpeningVoyage(unittest.TestCase):
    def test_01_autonome_et_duree(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        self.assertLess(len(txt), 8_000_000)
        self.assertEqual(len(re.findall(r'src="/(?:renders|\.cache)/', txt)), 0)
        self.assertIn("PMDDestinyVoyage", txt)
        self.assertIn("D = 153.0", txt)
        self.assertEqual(json.loads(META.read_text(encoding="utf-8"))["duration_seconds"], 153.0)

    def test_02_calques_generes_multicalques(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        for k in ("ocBg", "ocFloor", "surfaceSky", "beachFg", "meadow", "clouds", "forestFar", "forestMid", "forestRoad", "forestFg"):
            self.assertIn(f'"{k}":"data:image/webp', txt)

    def test_03_acteurs_et_effets(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        meta = json.loads(META.read_text(encoding="utf-8"))
        for pid in ("0447", "0133", "0393", "0151", "0251", "0490"):  # Riolu, Évoli, Tiplouf, Mew, Celebi, Manaphy
            self.assertIn(pid, meta["actors"])
        for k in ("petal", "sparkle", "bubble", "splash", "halo", "mat", "badge_cyan"):
            self.assertIn(f'"fx_{k}":"data:image/webp', txt)

    def test_04_moteur_syntaxe_et_scenes(self) -> None:
        r = subprocess.run(["node", "--check", str(ENGINE)], capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        eng = ENGINE.read_text(encoding="utf-8")
        for sid in ("OC1", "SF", "MD", "SK", "F1", "F2", "F3", "F4", "F5", "DW", "HL"):
            self.assertIn(f"id: '{sid}'", eng)
        self.assertIn("TITLE_T = 148.0", eng)
        self.assertNotIn("PMDDestinySprite", eng)

    def test_05_animations_utilisees_existent(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        i0 = txt.index("const ASSETS = ") + 15
        i1 = txt.index(";\n</script>", i0)
        cat = json.loads(txt[i0:i1])["catalog"]["pokemon"]
        eng = ENGINE.read_text(encoding="utf-8")
        for m in re.finditer(r"spr\(ctx, '(\d{4})', '(\w+)'", eng):
            self.assertIn(m.group(2), cat[m.group(1)]["anims"], m.group(0))
        for a in ("Walk", "Idle", "LookUp", "Pose", "Hop", "Float"):
            for pid in ("0393", "0447", "0133"):
                self.assertIn(a, cat[pid]["anims"])

    def test_06_liens_entre_versions(self) -> None:
        self.assertIn("apercu_fangame_pmd_destiny.html", HTML.read_text(encoding="utf-8"))
        self.assertIn("apercu_fangame_pmd_destiny_voyage.html", (HERE / "opening_sprite_template.html").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
