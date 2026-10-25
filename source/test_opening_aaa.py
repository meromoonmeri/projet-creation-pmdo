#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de la cinématique d'Opening AAA : lancement autonome, durée 153 s, 0 px magenta, alpha binaire-propre."""
from __future__ import annotations

import json
import re
import subprocess
import sys
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent
HTML = REPO_ROOT / "apercu_fangame_pmd_destiny.html"
AAA = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_cinema_aaa"


class TestOpeningAAA(unittest.TestCase):
    def test_01_html_autonome_sans_requete_externe(self) -> None:
        txt = HTML.read_text(encoding="utf-8")
        self.assertLess(len(txt), 6_000_000)
        self.assertEqual(len(re.findall(r'src="/(?:renders|\.cache)/', txt)), 0)
        self.assertEqual(len(re.findall(r"url\(/(?:renders|\.cache)/", txt)), 0)
        self.assertGreaterEqual(txt.count("data:image/webp;base64,"), 15)
        self.assertIn("PMDDestinyCinema", txt)

    def test_02_duree_identique_a_la_video_de_reference(self) -> None:
        meta = json.loads((AAA / "metadata.json").read_text(encoding="utf-8"))
        self.assertEqual(meta["duration_seconds"], 153.0)
        txt = HTML.read_text(encoding="utf-8")
        self.assertIn("D = 153.0", txt)
        self.assertIn("02:33", txt)

    def test_03_cutouts_sans_magenta(self) -> None:
        for name in ("evoli_plunge_cutout", "stained_glass_disc", "wayfinder_crystal_star"):
            arr = np.asarray(Image.open(AAA / f"{name}.webp").convert("RGBA"), dtype=np.int16)
            vis = arr[:, :, 3] > 40
            r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
            mag = vis & ((np.minimum(r, b) - g) >= 120) & (r >= 200) & (b >= 190)
            self.assertEqual(int(mag.sum()), 0, f"magenta résiduel dans {name}")

    def test_04_moteur_js_syntaxe(self) -> None:
        r = subprocess.run(["node", "--check", str(HERE / "opening_aaa_engine.js")], capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)


if __name__ == "__main__":
    unittest.main()
