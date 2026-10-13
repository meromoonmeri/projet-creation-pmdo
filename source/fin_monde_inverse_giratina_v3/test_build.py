"""Tests automatisés de structure, géométrie 4:3, chemin BFS 16x16 et intégrité PMDO (FMI3)."""
from pathlib import Path
import json, unittest
from PIL import Image

R = Path(__file__).resolve().parents[2]
LOT = "fin_monde_inverse_giratina_v3"
PFX = "FMI3"
KIND = "fin"
OUT = R / "renders" / LOT
CACHE_OUT = R / ".cache" / LOT / "renders"


class TestBuildFMI3(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))

    def test_dimensions_4_3_and_grid_8px(self):
        self.assertEqual(self.manifest["size_px"], [768, 576])
        self.assertEqual(self.manifest["grid_cells_8px"], [96, 72])
        self.assertEqual(self.manifest["tex_size"], 1)
        for p in (CACHE_OUT / "calques").glob("*.png"):
            with Image.open(p) as im:
                self.assertEqual(im.size, (768, 576), p.name)

    def test_animation_closed_loop(self):
        anim = self.manifest["animation"]
        self.assertTrue(anim["loop_closed"])
        self.assertEqual(anim["phases"], 16)
        frames = sorted((CACHE_OUT / "animation/animation").glob(f"{PFX}_03_ANIMATION_f*.png"))
        self.assertEqual(len(frames), 16)

    def test_bfs_16x16_paths_and_markers(self):
        acc = self.manifest["access"]
        self.assertEqual(acc["hitbox_px"], [16, 16])
        self.assertEqual(acc["warps"], [])
        markers = acc["markers"]
        self.assertIn("entrance", markers)
        if KIND == "entree":
            self.assertIn("donjon_seuil", markers)
            self.assertTrue(acc["paths_from_entrance"]["donjon_seuil"]["ok"])
        else:
            self.assertIn("boss", markers)
            self.assertIn("objectif", markers)
            self.assertNotIn("donjon_seuil", markers)
            self.assertTrue(acc["paths_from_entrance"]["boss"]["ok"])
            self.assertTrue(acc["paths_from_entrance"]["objectif"]["ok"])

    def test_honest_validation_flags(self):
        val = self.manifest["validation"]
        self.assertFalse(val["art_approved"])
        self.assertFalse(val["runtime_tested"])


if __name__ == "__main__":
    unittest.main()
