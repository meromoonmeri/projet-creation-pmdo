"""Tests FCV3 : provenance, palettes, masks, accès, ORA et codec Ground/.tile.

Ces tests ne lancent pas le moteur PMDO. Commande :
.venv/bin/python -m unittest source.fin_couloir_violet_v3.test_build -v
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import struct
import subprocess
import sys
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / "renders/fin_couloir_violet_v3"
STAGE = ROOT / ".cache/fin_couloir_violet_v3/fin_couloir_violet_v3"
BUILD = HERE / "build.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Module introuvable : {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rgba(path: Path) -> np.ndarray:
    with Image.open(path) as image:
        return np.asarray(image.convert("RGBA"), dtype=np.uint8)


def rgba_from_bytes(raw: bytes) -> np.ndarray:
    with Image.open(io.BytesIO(raw)) as image:
        return np.asarray(image.convert("RGBA"), dtype=np.uint8)


def read_tile_bank(path: Path):
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<ii", raw, 0)
    if tile_size != 8:
        raise AssertionError(f"Taille native de tuile inattendue dans {path} : {tile_size}")
    result, cache = {}, {}
    for index in range(count):
        x, y, offset = struct.unpack_from("<iiq", raw, 8 + 16 * index)
        length, = struct.unpack_from("<q", raw, offset)
        if offset < 8 + count * 16 or length < 1 or offset + 8 + length > len(raw):
            raise AssertionError(f"Offset .tile invalide dans {path}")
        if offset not in cache:
            tile = rgba_from_bytes(raw[offset + 8:offset + 8 + length]).astype(np.uint32)
            alpha = tile[..., 3:4]
            tile[..., :3] = np.minimum(255, (tile[..., :3] * 255 + alpha // 2) // np.maximum(alpha, 1))
            tile[alpha[..., 0] == 0] = 0
            cache[offset] = tile.astype(np.uint8)
        if (x, y) in result:
            raise AssertionError(f"Coordonnée de tuile dupliquée : {(x, y)}")
        result[(x, y)] = cache[offset]
    return result


def reconstruct_layer(obj, banks, layer_index: int, width=96, height=72):
    output = np.zeros((height * 8, width * 8, 4), dtype=np.uint8)
    for x, column in enumerate(obj["Layers"][layer_index]["Tiles"]):
        for y, tile in enumerate(column):
            if not tile["Layers"]:
                continue
            frame = tile["Layers"][0]["Frames"][0]
            output[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8] = banks[frame["Sheet"]][
                (frame["TexLoc"]["X"], frame["TexLoc"]["Y"])]
    return output


class FCV3Build(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (OUT / "manifest.json").exists() or not (STAGE / "Mod.xml").exists():
            subprocess.run([sys.executable, str(BUILD)], cwd=ROOT, check=True)
        cls.manifest = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))
        cls.width, cls.height = cls.manifest["size_px"]
        cls.layers = cls.manifest["layers"]
        cls.ground_path = STAGE / "Data/Ground" / f"{cls.manifest['asset']}.rsground"
        cls.doc = json.loads(cls.ground_path.read_text(encoding="utf-8"))
        cls.obj = cls.doc["Object"]

    def test_input_hashes_and_reference_provenance(self):
        for source in self.manifest["inputs"]:
            path = ROOT / source["file"]
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source["sha256"])
            with Image.open(path) as image:
                self.assertEqual(list(image.size), source["size_px"])
        generation = self.manifest["generation"]
        reference = generation["reference_context"]
        self.assertEqual(reference["map_code"], "S05P03A")
        self.assertEqual(reference["pinned_commit"], "c8073235b39746a7ee74e6cea16c730bd91a1e67")
        self.assertFalse(reference["final_room_capture_found"])
        self.assertEqual(generation["image_generation"]["selected_option"], None)
        self.assertFalse(generation["image_generation"]["user_selected"])
        self.assertEqual(reference["layout_reference"], "reference/FCV2_decor.png")
        self.assertEqual(reference["layout_reference_status"],
                         "Composition FCV2 réutilisée uniquement comme guide spatial; le nouveau décor est une génération distincte.")
        self.assertEqual(self.manifest["agent_choices"]["prefix"], "FCV3")
        self.assertIn("FCV1", self.manifest["agent_choices"]["prefix_status"])
        self.assertFalse(self.manifest["art_approved"])
        self.assertFalse(self.manifest["runtime_tested"])

    def test_dimensions_layers_alpha_and_normalization(self):
        self.assertEqual((self.width, self.height), (768, 576))
        self.assertEqual(self.manifest["grid_cells"], [96, 72])
        self.assertEqual((self.width % 8, self.height % 8), (0, 0))
        self.assertEqual(len(self.layers), 7)
        self.assertEqual([layer["name"] for layer in self.layers], [
            "00_sol_complet", "01_sol", "02_ombres", "03_gravure_lumineuse",
            "04_lueur_sigil", "05_parois", "06_top"
        ])
        self.assertEqual(self.layers[4]["alpha_mode"],
                         "graduée 3–48/255, halo prémultiplié par le codec Ground")
        self.assertEqual(self.layers[-1]["alpha_mode"], "transparent 0")
        for key in ("decor", "sol_complet"):
            normalized = self.manifest["normalization"][key]
            self.assertEqual(normalized["source_px"], [1200, 896])
            self.assertEqual(normalized["normalized_px"], [1200, 900])
            self.assertEqual(normalized["scale_xy"], [0.64, 0.64])
        for layer in self.layers:
            image = rgba(OUT / layer["file"])
            self.assertEqual(image.shape, (self.height, self.width, 4), layer["file"])
            alpha = set(np.unique(image[..., 3]))
            if layer["name"] == "04_lueur_sigil":
                self.assertIn(0, alpha)
                self.assertTrue(any(0 < value < 255 for value in alpha))
            else:
                self.assertTrue(alpha <= {0, 255}, layer["file"])
        self.assertTrue(np.all(rgba(OUT / self.layers[0]["file"])[..., 3] == 255))
        self.assertFalse(np.any(rgba(OUT / "calques/FCV3_06_top.png")))
        self.assertGreater(self.manifest["segmentation"]["sigil"]["pixels"], 1000)
        self.assertGreater(self.manifest["segmentation"]["sigil"]["glow_pixels"], 1000)
        scene = rgba(OUT / "review/FCV3_scene_t000.png")
        self.assertTrue(np.all(scene[..., 3] == 255))
        self.assertLessEqual(self.manifest["normalization"]["shared_palette_colors_used"], 96)

    def test_masks_are_exclusive_complete_and_walkable_region_is_real(self):
        visual_names = ("sol", "ombres", "gravure", "parois")
        visual_masks = [np.asarray(Image.open(OUT / f"masques/FCV3_masque_{name}.png").convert("L")) > 0
                        for name in visual_names]
        self.assertTrue(np.all(np.stack(visual_masks).sum(axis=0) == 1))
        walkable = np.asarray(Image.open(OUT / "masques/FCV3_masque_praticable.png").convert("L")) > 0
        shadows = visual_masks[visual_names.index("ombres")]
        gravure = visual_masks[visual_names.index("gravure")]
        self.assertTrue(np.all(~shadows | walkable))
        self.assertTrue(np.all(~gravure | walkable))
        glow = np.asarray(Image.open(OUT / "masques/FCV3_masque_lueur.png").convert("L")) > 0
        self.assertGreater(int(glow.sum()), 1000)
        blocked = np.asarray(Image.open(OUT / "masques/FCV3_masque_obstacles_visuels.png").convert("L")) > 0
        self.assertTrue(np.array_equal(blocked, ~walkable))
        access = self.manifest["access"]
        build = load_module("fcv3_masks_test", BUILD)
        grid = build.cell_grid(~walkable)
        self.assertEqual(int(grid.sum()), access["blocked_cells"])
        self.assertTrue(grid[:10].all(), "le mur nord doit rester fermé")
        self.assertTrue(grid[:, :6].all() and grid[:, -6:].all(), "les bords latéraux sont fermés")
        self.assertEqual(self.manifest["pmdo"]["warp"], "aucun")
        self.assertEqual(self.manifest["pmdo"]["exit"], "aucune")
        self.assertFalse(any("cristal" in item["name"].lower() or "dalle" in item["name"].lower()
                             for item in self.layers))

    def test_reference_floor_material_fidelity(self):
        fidelity = self.manifest["normalization"]["reference_fidelity"]
        self.assertTrue(fidelity["generated_floor_pass"])
        self.assertTrue(fidelity["full_floor_base_pass"])
        self.assertLess(fidelity["generated_floor_distance"], fidelity["threshold"])
        self.assertLess(fidelity["generated_floor_distance"], 10)
        source = np.asarray(fidelity["reference_floor_rgb"], dtype=float)
        generated = np.asarray(fidelity["generated_floor_rgb"], dtype=float)
        self.assertAlmostEqual(float(np.linalg.norm(generated - source)),
                               fidelity["generated_floor_distance"], delta=0.03)
        self.assertIn("pas une preuve", fidelity["note"])

    def test_south_centre_north_markers_and_16px_access(self):
        access = self.manifest["access"]
        self.assertTrue(access["path_to_boss_16x16"])
        self.assertTrue(access["path_to_objective_16x16"])
        self.assertGreater(access["entry_px"][1], self.height - 64)
        self.assertGreater(access["boss_px"][1], access["objective_px"][1] + 80)
        self.assertGreater(access["entry_px"][1], access["boss_px"][1])
        self.assertGreater(access["objective_px"][1], 128)
        self.assertLess(access["objective_px"][1], 208)
        self.assertLess(abs(access["objective_px"][0] - self.width // 2), 56)
        self.assertLess(abs(access["boss_px"][0] - self.width // 2), 80)
        self.assertEqual((access["boss_px"][0] + 8, access["boss_px"][1] + 8), (384, 304))
        build = load_module("fcv3_access_test", BUILD)
        walkable = np.asarray(Image.open(OUT / "masques/FCV3_masque_praticable.png").convert("L")) > 0
        blocked = build.cell_grid(~walkable)
        self.assertEqual(int(blocked.sum()), access["blocked_cells"])
        for point in (access["entry_px"], access["boss_px"], access["objective_px"]):
            self.assertTrue(build.footprint_free(blocked, point[1] // 8, point[0] // 8))
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["boss_cell_yx"]))[0])
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["objective_cell_yx"]))[0])

    def test_ground_has_three_edit_markers_no_transition(self):
        self.assertEqual(self.doc["Version"], "0.8.12.0")
        self.assertEqual(self.obj["TexSize"], 1)
        self.assertEqual(self.obj["AssetName"], "fcv3_fin_couloir_violet")
        self.assertEqual(len(self.obj["Layers"]), 7)
        self.assertEqual(len(self.obj["obstacles"]), 96)
        self.assertEqual(len(self.obj["obstacles"][0]), 72)
        entity = self.obj["Entities"][0]
        self.assertEqual([marker["EntName"] for marker in entity["Markers"]],
                         ["entrance", "boss", "objectif"])
        self.assertFalse(entity["MapChars"])
        self.assertFalse(entity["GroundObjects"])
        self.assertFalse(entity["Spawners"])
        for marker in entity["Markers"]:
            self.assertEqual((marker["Collider"]["Width"], marker["Collider"]["Height"]), (16, 16))
        self.assertNotIn("Warp", self.obj)
        self.assertNotIn("warp", self.obj)
        self.assertFalse((STAGE / "Data/Script/fin_couloir_violet_v3/ground/fcv3_fin_couloir_violet/warp.lua").exists())

    def test_tile_banks_round_trip_and_index(self):
        paths = sorted((STAGE / "Content/Tile").glob("FCV3_*.tile"))
        self.assertEqual(len(paths), 6)
        banks = {path.stem: read_tile_bank(path) for path in paths}
        for item in self.layers[:-1]:
            restored = reconstruct_layer(self.obj, banks, item["order"])
            expected = rgba(OUT / item["file"])
            if item["name"] == "04_lueur_sigil":
                # Ground tiles store premultiplied alpha; compare the rendered
                # signal rather than unstable straight RGB under low alpha.
                self.assertTrue(np.array_equal(restored[..., 3], expected[..., 3]))
                alpha = expected[..., 3:4].astype(np.uint16)
                restored_premult = restored[..., :3].astype(np.uint16) * alpha // 255
                expected_premult = expected[..., :3].astype(np.uint16) * alpha // 255
                self.assertLessEqual(int(np.abs(restored_premult.astype(int) -
                                                expected_premult.astype(int)).max()), 1)
            else:
                self.assertTrue(np.array_equal(restored, expected), item["name"])
        tools = load_module("fcv3_index_test", ROOT / "source/pmdo_cote/INSTALLER.py")
        decoded = {}
        for path in paths:
            with path.open("rb") as stream:
                decoded[path.stem] = tools.read_node(stream)
        self.assertEqual(decoded.keys(), banks.keys())
        index_data = (STAGE / "Content/Tile/index.idx").read_bytes()
        self.assertEqual(struct.unpack_from("<i", index_data, 0)[0], len(paths))

    def test_openraster_round_trip_and_viewer_template(self):
        ora_path = ROOT / ".cache/fin_couloir_violet_v3/FCV3_calques.ora"
        with zipfile.ZipFile(ora_path) as archive:
            self.assertEqual(archive.read("mimetype"), b"image/openraster")
            self.assertTrue({"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist()))
            merged = rgba_from_bytes(archive.read("mergedimage.png"))
            xml = archive.read("stack.xml").decode("utf-8")
            self.assertIn("00 sol complet", xml)
            self.assertIn("03 gravure lumineuse", xml)
            self.assertIn("05 parois", xml)
        self.assertTrue(np.array_equal(merged, rgba(OUT / "review/FCV3_scene_t000.png")))
        collision = rgba(OUT / "review/FCV3_collisions_marqueurs.png")
        self.assertEqual(collision.shape, (self.height, self.width, 4))
        self.assertGreater(int(np.count_nonzero(collision[..., 0] > collision[..., 1] + 40)), 0)
        template = (HERE / "viewer_template.html").read_text(encoding="utf-8")
        self.assertEqual(template.count("__DATA__"), 1)
        self.assertIn("FCV3", template)
        self.assertIn("S05P03A", template)


if __name__ == "__main__":
    unittest.main()
