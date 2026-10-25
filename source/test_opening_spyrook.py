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
        for needle in ("D = 153.0", "smoothSnap(", "boxPass(", "renderTitleMode", "PMDDestinySpyrook"):
            self.assertIn(needle, e)

    def test_decors_repeints(self):
        b = (ROOT / "source" / "build_opening_peinture.py").read_text(encoding="utf-8")
        keys = re.search(r"KEYS = \[(.*?)\]", b).group(1)
        names = re.findall(r'"(\w+)"', keys)
        self.assertGreaterEqual(len(names), 8)
        for n in names:
            self.assertTrue((ROOT / "source" / "pmd_destiny_fangame_v1" / "decors_peints" / (n + ".png")).exists(), n)
        self.assertGreaterEqual(len(list((VIDEO.parent / "keyframes").glob("*.jpg"))), 4)

    def test_images_intermediaires_60fps(self):
        e = ENGINE.read_text(encoding="utf-8")
        u = (ROOT / "source" / "opening_ultime_engine.js").read_text(encoding="utf-8")
        self.assertIn("inbetween: true", e)
        for needle in ("const IBT", "frameNext(", "hold(", "respiration"):
            self.assertIn(needle, u)

    def test_hd_nette_et_camera_dessin_anime(self):
        e = ENGINE.read_text(encoding="utf-8")
        self.assertIn("W = 1920, H = 1080", e)  # vrai 1080p, dessiné directement (pas de réduction/agrandissement flou)
        for needle in ("camAt(", "BOUNDS", "tremblement", "bandes de cinéma", "HI.set("):
            self.assertIn(needle, e)
        for banni in ("kuwahara(", "gnoise", "bloom["):  # pas de grain ni de halo baveux
            self.assertNotIn(banni, e)

    def test_calques_hd_decors(self):
        from PIL import Image
        d = ROOT / "source" / "pmd_destiny_fangame_v1" / "decors_peints"
        for f in d.glob("*.png"):
            self.assertGreaterEqual(Image.open(f).width, 650, f.name)


if __name__ == "__main__":
    unittest.main()
