"""Tests automatisés — Entree Route de Glace Sud-Nord (4:3) (ERG1), 4:3 (768 x 576).
Contrôles d'images, de calques, de boucles d'animation, de grille 8x8 et de BFS 16x16 : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, json, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = "entree_route_glace_sud_nord_v1"
PFX = "ERG1"
KIND = "entree"
O = R / "renders" / LOT
S = R / ".cache" / LOT / "entree_route_glace_sud_nord"
M = json.loads((O / "manifest.json").read_text(encoding="utf-8"))
W, H = M["size_px"]


def load_rgba(p):
    return np.array(Image.open(p).convert("RGBA"))


class TestBuild(unittest.TestCase):
    def test_raw_inputs_and_flags(self):
        for r in M["raw_inputs"]:
            p = R / r["file"]
            self.assertTrue(p.exists(), r["file"])
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), r["sha256"])
        self.assertTrue(M["decor_pur_sans_artefact"])
        self.assertFalse(M["art_approved"])
        self.assertFalse(M["pmdo"]["runtime_tested"])
        self.assertEqual(M["pmdo"]["warp"], "aucun")

    def test_layers_dimensions_and_binary_alpha(self):
        self.assertEqual((W, H), (768, 576))
        order = M["layer_order_bottom_to_top"]
        self.assertEqual(len(order), 4)
        sol = load_rgba(O / order[0])
        relief = load_rgba(O / order[1])
        couronnes = load_rgba(O / order[2])
        for a in (sol, relief, couronnes):
            self.assertEqual(a.shape, (H, W, 4))
            self.assertTrue(set(np.unique(a[:, :, 3])) <= {0, 255})
        self.assertTrue((sol[:, :, 3] == 255).all())
        self.assertFalse(((relief[:, :, 3] == 255) & (couronnes[:, :, 3] == 255)).any())

    def test_animation_closed_loop(self):
        ph = M["animation"]["phases"]
        anim_pat = M["layer_order_bottom_to_top"][3]
        frames = [load_rgba(O / anim_pat.replace("fNN", f"f{i:02d}")) for i in range(ph)]
        for f in frames:
            self.assertEqual(f.shape, (H, W, 4))
            self.assertTrue(set(np.unique(f[:, :, 3])) <= {0, 255})
        diffs = [float((frames[i] != frames[(i + 1) % ph]).any(axis=-1).mean()) for i in range(ph)]
        self.assertGreater(min(diffs), 0.0001)

    def test_access_and_rsground(self):
        markers = M["access"]["markers"]
        if KIND == "entree":
            self.assertEqual(set(markers.keys()), {"entrance", "donjon_seuil"})
        else:
            self.assertEqual(set(markers.keys()), {"entrance", "boss", "objectif"})
            self.assertNotIn("donjon_seuil", markers)
        for k, v in M["access"]["chemins_16x16"].items():
            self.assertTrue(v["ok"], k)
            self.assertGreater(v["cases_explorees"], 30)

        doc_p = S / "Data/Ground/erg1_entree_route_glace_sud_nord.rsground"
        self.assertTrue(doc_p.exists())
        doc = json.loads(doc_p.read_text(encoding="utf-8-sig"))
        self.assertEqual(doc["Version"], "0.8.12.0")
        o = doc["Object"]
        self.assertEqual(o["TexSize"], 1)
        self.assertEqual(len(o["obstacles"]), 96)
        self.assertEqual(len(o["obstacles"][0]), 72)
        self.assertEqual(o["Layers"][-1]["Layer"], 4)


if __name__ == "__main__":
    unittest.main()
