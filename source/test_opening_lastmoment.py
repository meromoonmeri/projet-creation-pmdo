#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de l'Opening « Last Moment » : autonomie, durée 96 s, décors = textures canoniques PMD Sky, sprites/portraits PMDO réels, plans attendus."""
from __future__ import annotations

import json
import re
import subprocess
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent
HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_last_moment.html"
META = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_last_moment" / "metadata.json"
ENGINE = HERE / "opening_lastmoment_engine.js"


def _assets() -> dict:
    txt = HTML.read_text(encoding="utf-8")
    i0 = txt.index("const ASSETS = ") + 15
    i1 = txt.index(";\n</script>", i0)
    return json.loads(txt[i0:i1])


class TestOpeningLastMoment(unittest.TestCase):
    def test_01_autonome_et_duree(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        self.assertLess(len(txt), 8_000_000)
        self.assertEqual(len(re.findall(r'src="/(?:renders|\.cache)/', txt)), 0)
        self.assertIn("PMDDestinyLastMoment", txt)
        self.assertIn("D = 96.0", txt)
        self.assertIn("cRdYidq7d8g", txt)
        self.assertEqual(json.loads(META.read_text(encoding="utf-8"))["duration_seconds"], 96.0)

    def test_02_decors_canoniques_pmd_sky(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        for k in ("laprasSky", "laprasSea", "moonBg", "moonFg", "plainsFar", "plainsTree", "skyPeak"):
            self.assertIn(f'"{k}":"data:image/webp', txt)
        self.assertFalse((HERE / "pmd_destiny_fangame_v1" / "lastmoment_bruts").exists(), "aucune plaque générée (village rejeté)")

    def test_03_acteurs_portraits_effets(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        meta = json.loads(META.read_text(encoding="utf-8"))
        for pid in ("0447", "0393", "0253", "0151", "0490", "0251", "0571", "0491", "0448", "0133", "0278", "0279"):
            self.assertIn(pid, meta["actors"])
        for k in ("pt_0447_Determined", "pt_0393_Determined", "pt_0253_Determined", "pt_0492_Sad", "fx_sparkle", "fx_petal", "fx_mat"):
            self.assertIn(f'"{k}":"data:image/webp', txt)

    def test_04_moteur_syntaxe_et_plans(self) -> None:
        r = subprocess.run(["node", "--check", str(ENGINE)], capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        eng = ENGINE.read_text(encoding="utf-8")
        for sid in ("LS", "OR", "NT", "DW"):
            self.assertIn(f"id: '{sid}'", eng)
        self.assertIn("TITLE_T = 91.0", eng)
        self.assertIn("D = 96.0", eng)
        self.assertIn("function still(", eng)
        self.assertNotIn("PMDDestinySprite", eng)
        self.assertIsNone(re.search(r"ichigo|rukia|zangetsu|seireitei|bankai", eng.lower()))  # aucun personnage / texte de la référence

    def test_05_animations_utilisees_existent(self) -> None:
        cat = _assets()["catalog"]["pokemon"]
        eng = ENGINE.read_text(encoding="utf-8")
        for m in re.finditer(r"spr\(ctx, '(\d{4})', '(\w+)'", eng):
            self.assertIn(m.group(2), cat[m.group(1)]["anims"], m.group(0))
        blk = eng[eng.index("const ALLIES = ["): eng.index("const DSPD")]
        allies = re.findall(r"\['(\d{4})', '(\w+)', \d, '[\d,]+', [\d.]+\]", blk)
        self.assertEqual(len(allies), 9)
        for pid, anim in allies:
            self.assertIn(anim, cat[pid]["anims"], (pid, anim))
        self.assertIn("Walk", cat["0447"]["anims"])
        self.assertIn("Idle", cat["0447"]["anims"])

    def test_06_chronologie(self) -> None:
        eng = ENGINE.read_text(encoding="utf-8")
        ts = [float(x) for x in re.findall(r"t0: ([\d.]+), t1: ([\d.]+), custom", eng)[0:0]]
        pairs = re.findall(r"id: '(\w+)', t0: (\d+), t1: (\d+)", eng)
        self.assertEqual([p[0] for p in pairs], ["LS", "OR", "NT", "DW"])
        self.assertEqual([(int(p[1]), int(p[2])) for p in pairs], [(0, 9), (9, 25), (25, 52), (52, 91)])
        self.assertEqual(ts, [])

    def test_07_liens_entre_versions(self) -> None:
        self.assertIn("apercu_fangame_pmd_destiny_last_moment.html", (HERE / "opening_voyage_template.html").read_text(encoding="utf-8"))
        self.assertIn("apercu_fangame_pmd_destiny_last_moment.html", (HERE / "opening_sprite_template.html").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
