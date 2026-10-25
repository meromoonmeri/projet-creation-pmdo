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
        self.assertLess(len(txt), 10_600_000)
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

    def test_04b_couches_pmd_sky(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        for k in ("ttSky", "moonBg", "plainsFar", "plainsTree", "skyPeak", "laprasSky", "anticWall", "tm12", "th6", "lap2", "it5"):
            self.assertIn(f'"{k}":"data:image/webp', txt)
        self.assertIn("A1", txt)

    def test_04c_sprites_effets_et_shaymin(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        for k in ("petal", "sparkle", "bubble", "hit", "flame", "splash", "shard", "slash", "shadowball", "aurasphere", "swiftstar", "halo", "mat", "badge_cyan", "badge_emerald", "badge_amber"):
            self.assertIn(f'"fx_{k}":"data:image/webp', txt)
            self.assertRegex(txt, r'"%s":\{"fw":\d+,"fh":\d+,"n":\d+' % k)
        self.assertIn('"0492"', txt)  # vrai sprite PMDO de Shaymin
        self.assertNotIn('"sh12"', txt)  # plus de Shaymin « ripé »
        eng = (HERE / "opening_sprite_engine.js").read_text(encoding="utf-8")
        for fn in ("function petals(", "function flames(", "function shardsW("):
            self.assertIn("fx(ctx", eng[eng.index(fn):eng.index(fn) + 700])  # effets = sprites, plus de dessin procédural
        for k in ("cloudPortal", "rigBack", "wfCyan", "wfEmerald", "wfAmber"):
            self.assertIn(f'"{k}":"data:image/', txt)
        for fn in ("function bolt(", "function drawFall(", "function matBurst("):
            self.assertIn(fn, eng)  # attaques Pokémon matérialisées, chute en vue plongeante
        for kind in ("shadowball", "aurasphere", "swift", "bubble"):
            self.assertIn(f"kind: '{kind}'", eng)
        self.assertNotIn("introCard(ctx, t); caption(ctx, t)", eng)  # plus de texte de description dans l'image
        self.assertIn("attach:", eng)  # chutes : sprite suivi par la caméra, décor qui défile

    def test_05_page_aaa_conservee(self) -> None:
        self.assertTrue((REPO_ROOT / "apercu_fangame_pmd_destiny_aaa_illustre.html").is_file())
        self.assertTrue((REPO_ROOT / "apercu_fangame_pmd_destiny_pixel_opm.html").is_file())


if __name__ == "__main__":
    unittest.main()
