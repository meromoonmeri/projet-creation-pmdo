"""Tests FTL1 : entrées, segmentation RGB, palette, accessibilité, ORA et codec PMDO.

Le moteur PMDO n'est pas lancé par ces tests.
Commande : .venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
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
OUT = ROOT / "renders/fin_clairiere_tropicale_v1"
STAGE = ROOT / ".cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale"
BUILD = HERE / "build.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Module introuvable: {path}")
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
        raise AssertionError(f"Taille de tuile native inattendue : {tile_size}")
    result, cache = {}, {}
    for i in range(count):
        x, y, offset = struct.unpack_from("<iiq", raw, 8 + 16 * i)
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
            raise AssertionError(f"Coordonnée tuile dupliquée : {(x, y)}")
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


class FTL1Build(unittest.TestCase):
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

    def test_inputs_and_generation_provenance(self):
        for source in self.manifest["inputs"]:
            path = ROOT / source["file"]
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source["sha256"])
            with Image.open(path) as image:
                self.assertEqual(list(image.size), source["size_px"])
        provenance = self.manifest["generation"]["reference_context"]
        self.assertFalse(provenance["raw_reference_available_in_checkout"])
        self.assertEqual(self.manifest["generation"]["images"][0]["selected_option"], None)
        self.assertFalse(self.manifest["art_approved"])
        self.assertFalse(self.manifest["runtime_tested"])

    def test_dimensions_layers_binary_alpha_and_normalization(self):
        self.assertEqual((self.width, self.height), (768, 576))
        self.assertEqual(self.manifest["grid_cells"], [96, 72])
        self.assertEqual((self.width % 8, self.height % 8), (0, 0))
        self.assertEqual(len(self.layers), 7)
        for name in ("decor", "sol_complet"):
            norm = self.manifest["normalization"][name]
            self.assertEqual(norm["source_px"], [1200, 896])
            self.assertEqual(norm["normalized_px"], [1200, 900])
            self.assertEqual(norm["scale_xy"], [0.64, 0.64])
        for item in self.layers:
            image = rgba(OUT / item["file"])
            self.assertEqual(image.shape, (self.height, self.width, 4), item["file"])
            self.assertTrue(set(np.unique(image[..., 3])) <= {0, 255}, item["file"])
        self.assertTrue(np.all(rgba(OUT / self.layers[0]["file"])[..., 3] == 255))
        self.assertFalse(np.any(rgba(OUT / "calques/FTL1_06_top.png")))

    def test_masks_are_exclusive_complete_and_floor_has_no_slabs(self):
        names = ("sol", "ombres", "jungle", "fleurs", "parois")
        masks = [np.asarray(Image.open(OUT / f"masques/FTL1_masque_{name}.png").convert("L")) > 0
                 for name in names]
        self.assertTrue(np.all(np.stack(masks).sum(axis=0) == 1))
        walkable = np.asarray(Image.open(OUT / "masques/FTL1_masque_praticable.png").convert("L")) > 0
        shadows = masks[names.index("ombres")]
        self.assertTrue(np.all(~shadows | walkable))
        scene = rgba(OUT / "review/FTL1_scene_t000.png")
        self.assertTrue(np.all(scene[..., 3] == 255))
        self.assertTrue(self.manifest["pmdo"]["warp"] == "aucun")
        self.assertTrue(self.manifest["pmdo"]["exit"] == "aucune")
        layer_names = [layer["name"].lower() for layer in self.layers]
        self.assertFalse(any("cristal" in name or "dalle" in name or "carrelage" in name for name in layer_names))
        self.assertIn("sans cristaux, dalles", " ".join(self.manifest["notes"]))

    def test_vegetation_and_flowers_are_detected_without_coordinates(self):
        veg = self.manifest["segmentation"]["vegetation_detection"]
        flowers = self.manifest["segmentation"]["flower_detection"]
        self.assertFalse(veg["manual_plant_coordinates"])
        self.assertFalse(flowers["manual_flower_coordinates"])
        self.assertIn("composantes connexes", veg["method"])
        self.assertIn("composantes connexes", flowers["method"])
        self.assertGreater(veg["kept_components"], 0)
        self.assertGreater(flowers["kept_components"], 0)
        veg_mask = np.asarray(Image.open(OUT / "masques/FTL1_masque_jungle.png").convert("L")) > 0
        flower_mask = np.asarray(Image.open(OUT / "masques/FTL1_masque_fleurs.png").convert("L")) > 0
        self.assertEqual(int(veg_mask.sum()), veg["vegetation_pixels_8px"])
        self.assertEqual(int(flower_mask.sum()), flowers["flower_pixels_8px"])
        self.assertFalse(np.any(veg_mask & flower_mask))

    def test_grass_color_is_near_recorded_ETC1_palette_guide(self):
        metric = self.manifest["normalization"]["grass_fidelity_estimate"]
        self.assertLess(metric["distance_to_recorded_rip_mean"], metric["threshold"])
        self.assertLess(metric["distance_to_recorded_rip_mean"], 10)
        self.assertIn("raw canonical image absent", metric["reference_source"])
        self.assertEqual(metric["target_rgb"], [182.6, 213.5, 96.7])

    def test_markers_south_centre_north_and_16px_access(self):
        access = self.manifest["access"]
        self.assertTrue(access["path_to_boss_16x16"])
        self.assertTrue(access["path_to_objective_16x16"])
        self.assertGreater(access["entry_px"][1], self.height - 64)
        self.assertGreater(access["boss_px"][1], access["objective_px"][1] + 80)
        self.assertGreater(access["entry_px"][1], access["boss_px"][1])
        self.assertLess(abs(access["boss_px"][0] - self.width // 2), 80)
        self.assertLess(abs(access["objective_px"][0] - self.width // 2), 80)
        build = load_module("ftl1_access_test", BUILD)
        walk = np.asarray(Image.open(OUT / "masques/FTL1_masque_praticable.png").convert("L")) > 0
        blocked = build.cell_grid(~walk)
        self.assertEqual(int(blocked.sum()), access["blocked_cells"])
        for point in (access["entry_px"], access["boss_px"], access["objective_px"]):
            self.assertTrue(build.footprint_free(blocked, point[1] // 8, point[0] // 8))
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["boss_cell_yx"]))[0])
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["objective_cell_yx"]))[0])
        self.assertTrue(blocked[:10].all())
        self.assertTrue(blocked[:, :14].all() and blocked[:, -14:].all())

    def test_ground_has_three_edit_markers_no_transition(self):
        self.assertEqual(self.doc["Version"], "0.8.12.0")
        self.assertEqual(self.obj["TexSize"], 1)
        self.assertEqual(self.obj["AssetName"], "ftl1_fin_clairiere_tropicale")
        self.assertEqual(len(self.obj["Layers"]), 7)
        self.assertEqual(len(self.obj["obstacles"]), 96)
        self.assertEqual(len(self.obj["obstacles"][0]), 72)
        entity = self.obj["Entities"][0]
        self.assertEqual([m["EntName"] for m in entity["Markers"]], ["entrance", "boss", "objectif"])
        self.assertFalse(entity["MapChars"])
        self.assertFalse(entity["GroundObjects"])
        self.assertFalse(entity["Spawners"])
        for marker in entity["Markers"]:
            self.assertEqual((marker["Collider"]["Width"], marker["Collider"]["Height"]), (16, 16))
        self.assertNotIn("Warp", self.obj)
        self.assertNotIn("warp", self.obj)

    def test_palette_groups_and_tile_banks_round_trip(self):
        palette_groups = self.manifest["normalization"]["palette_groups"]
        expected_layers = {
            "terrain": ["00_sol_complet", "01_sol", "02_ombres"],
            "jungle": ["03_jungle"], "racines": ["05_parois"], "fleurs": ["04_fleurs"],
        }
        for group, names in expected_layers.items():
            colors = set()
            for name in names:
                layer = next(item for item in self.layers if item["name"] == name)
                image = rgba(OUT / layer["file"])
                colors.update(map(tuple, np.unique(image[image[..., 3] == 255, :3], axis=0)))
            self.assertLessEqual(len(colors), palette_groups[group]["limit"], group)
        paths = sorted((STAGE / "Content/Tile").glob("FTL1_*.tile"))
        self.assertEqual(len(paths), 6)
        banks = {path.stem: read_tile_bank(path) for path in paths}
        for item in self.layers[:6]:
            restored = reconstruct_layer(self.obj, banks, item["order"])
            self.assertTrue(np.array_equal(restored, rgba(OUT / item["file"])), item["name"])
        index = (STAGE / "Content/Tile/index.idx").read_bytes()
        self.assertEqual(struct.unpack_from("<i", index, 0)[0], len(paths))

    def test_openraster_and_collision_preview(self):
        ora_path = ROOT / ".cache/fin_clairiere_tropicale_v1/FTL1_calques.ora"
        with zipfile.ZipFile(ora_path) as archive:
            self.assertEqual(archive.read("mimetype"), b"image/openraster")
            self.assertTrue({"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist()))
            merged = rgba_from_bytes(archive.read("mergedimage.png"))
        self.assertTrue(np.array_equal(merged, rgba(OUT / "review/FTL1_scene_t000.png")))
        collision = rgba(OUT / "review/FTL1_collisions_marqueurs.png")
        self.assertEqual(collision.shape, (self.height, self.width, 4))
        template = (HERE / "viewer_template.html").read_text(encoding="utf-8")
        self.assertIn("__DATA__", template)
        self.assertIn("FTL1", template)
        self.assertIn("sans dalles", template)


if __name__ == "__main__":
    unittest.main()
