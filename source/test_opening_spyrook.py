"""Tests de l'Opening « Peinture » (traitement picturalement lissé de l'Ultime, vidéo 60 fps pré-rendue)."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PAGE = ROOT / "apercu_fangame_pmd_destiny_spyrook.html"
ENGINE = ROOT / "source" / "opening_spyrook_engine.js"
VIDEO = ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_spyrook" / "opening_spyrook_60fps.mp4"


class TestOpeningSpyrook(unittest.TestCase):
    def test_page_relative_et_musique(self):
        h = PAGE.read_text(encoding="utf-8")
        self.assertIn('src="./renders/pmd_destiny_fangame_v1/opening_spyrook/opening_spyrook_60fps.mp4"', h)
        self.assertIsNone(re.search(r"""(src|href)=["']/renders""", h))
        self.assertIn("2aafI3XvKxo", h)

    def test_video_generee(self):
        self.assertTrue(VIDEO.exists(), "la vidéo pré-rendue doit être livrée")
        data = VIDEO.read_bytes()
        self.assertEqual(data[4:8], b"ftyp")
        self.assertLess(len(data), 40 * 1024 * 1024)
        self.assertGreater(len(data), 5 * 1024 * 1024)

    def test_traitement_pictural(self):
        e = ENGINE.read_text(encoding="utf-8")
        for needle in ("D = 153.0", "smoothSnap(", "boxPass(", "bloom", "renderTitleMode", "PMDDestinySpyrook"):
            self.assertIn(needle, e)


if __name__ == "__main__":
    unittest.main()
