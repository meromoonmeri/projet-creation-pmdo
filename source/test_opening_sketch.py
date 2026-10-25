"""Tests de l'Opening STUDIO SKETCH (même montage que l'ULTIME, redessiné au crayon : traits qui bouillonnent, on twos, hachures, papier)."""
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
HTML = ROOT / "apercu_fangame_pmd_destiny_sketch.html"
ENGINE = ROOT / "source" / "opening_sketch_engine.js"
META = ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_sketch" / "metadata.json"


class TestOpeningSketch(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.html = HTML.read_text(encoding="utf-8")
        cls.eng = ENGINE.read_text(encoding="utf-8")
        i0 = cls.html.index("const ASSETS = ") + len("const ASSETS = ")
        i1 = cls.html.index(";\n</script>", i0)
        cls.assets = json.loads(cls.html[i0:i1])

    def test_autonome_sans_requete_externe(self):
        self.assertIsNone(re.search(r"""(src|href)=["']/renders""", self.html))
        self.assertIsNone(re.search(r"""["']/renders/""", self.html))
        self.assertTrue(all(v.startswith("data:") for v in self.assets["imgs"].values()))

    def test_duree_et_musique(self):
        self.assertIn("D = 153.0", self.eng)
        self.assertIn("2aafI3XvKxo", self.html)
        self.assertEqual(json.loads(META.read_text(encoding="utf-8"))["duration_seconds"], 153.0)

    def test_moteurs_assembles_et_page_sketch(self):
        for g in ("PMDDestinyVoyage", "PMDDestinySprite", "PMDDestinyUltime", "PMDDestinySketch"):
            self.assertIn("root." + g + " =", self.html)
        self.assertIn("PMDDestinySketch.create", self.html)
        self.assertNotIn("PMDDestinyUltime.create({", self.html)
        self.assertIn("STUDIO SKETCH", self.html)

    def test_technique_de_dessin(self):
        for needle in ("FPS = 12", "boil", "blur3(", "sobelInto(", "paper[", "hachures", "% 3", "DX[v]"):
            self.assertIn(needle, self.eng)
        self.assertIn("root.PMDDestinyUltime.create(EV)", self.eng)  # il redessine l'ULTIME, il ne le remplace pas

    def test_api_compatible_avec_le_lecteur(self):
        for member in ("render, renderTitleMode", "CHAPTERS: U.CHAPTERS", "TITLE_T: U.TITLE_T", "IMPACTS: U.IMPACTS"):
            self.assertIn(member, self.eng)

    def test_lien_depuis_le_studio(self):
        idx = (ROOT / "index.html").read_text(encoding="utf-8")
        self.assertIn("apercu_fangame_pmd_destiny_sketch.html", idx)


if __name__ == "__main__":
    unittest.main()
