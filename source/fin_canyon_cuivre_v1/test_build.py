"""Tests FCC1 : provenance, calques, segmentation, accès, ORA et codec Ground/.tile.

Ces tests vérifient les artefacts locaux; ils ne lancent pas le moteur PMDO.
Commande : .venv/bin/python -m unittest source.fin_canyon_cuivre_v1.test_build -v
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
OUT = ROOT / "renders/fin_canyon_cuivre_v1"
STAGE = ROOT / ".cache/fin_canyon_cuivre_v1/fin_canyon_cuivre"
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
        raise AssertionError(f"Taille de tuile native inattendue dans {path}: {tile_size}")
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
            raise AssertionError(f"Coordonnée tuile dupliquée dans {path}: {(x, y)}")
        result[(x, y)] = cache[offset]
    return result


def reconstruct_layer(obj, banks, layer_index: int, width=96, height=72):
    output = np.zeros((height * 8, width * 8, 4), dtype=np.uint8)
    layer = obj["Layers"][layer_index]
    for x, column in enumerate(layer["Tiles"]):
        for y, tile in enumerate(column):
            if not tile["Layers"]:
                continue
            frame = tile["Layers"][0]["Frames"][0]
            image = banks[frame["Sheet"]][(frame["TexLoc"]["X"], frame["TexLoc"]["Y"])]
            output[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8] = image
    return output


class FCC1Build(unittest.TestCase):
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

    def test_input_hashes_and_selected_art_provenance(self):
        for source in self.manifest["inputs"]:
            path = ROOT / source["file"]
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source["sha256"])
            with Image.open(path) as image:
                self.assertEqual(list(image.size), source["size_px"])
        self.assertEqual(self.manifest["generation"]["images"][0]["selected_option"], 2)
        self.assertIn("sans cristal", self.manifest["user_constraints"]["source"])
        self.assertFalse(self.manifest["art_approved"])
        self.assertFalse(self.manifest["runtime_tested"])

    def test_dimensions_six_layers_and_binary_alpha(self):
        self.assertEqual((self.width, self.height), (768, 576))
        self.assertEqual(self.manifest["grid_cells"], [96, 72])
        self.assertEqual((self.width % 8, self.height % 8), (0, 0))
        self.assertEqual(len(self.layers), 6)
        self.assertEqual(self.manifest["normalization"]["decor"]["scale_xy"], [2 / 3, 2 / 3])
        self.assertEqual(self.manifest["normalization"]["decor"]["crop_px_ltrb"], [16, 0, 16, 0])
        for item in self.layers:
            image = rgba(OUT / item["file"])
            self.assertEqual(image.shape, (self.height, self.width, 4), item["file"])
            self.assertTrue(set(np.unique(image[..., 3])) <= {0, 255}, item["file"])
        base = rgba(OUT / self.layers[0]["file"])
        self.assertTrue(np.all(base[..., 3] == 255), "le sol complet doit rester une base opaque")
        top = rgba(OUT / "calques/FCC1_05_top.png")
        self.assertFalse(np.any(top), "le calque Top éditorial doit être vide")
        self.assertLessEqual(self.manifest["normalization"]["shared_palette_colors"], 96)

    def test_masks_partition_every_pixel_without_floor_tiles(self):
        masks = []
        for name in ("sol", "ombres", "parois", "vegetation"):
            path = OUT / "masques" / f"FCC1_masque_{name}.png"
            mask = np.asarray(Image.open(path).convert("L"), dtype=np.uint8) > 0
            self.assertEqual(mask.shape, (self.height, self.width))
            masks.append(mask)
        coverage = np.stack(masks).sum(axis=0)
        self.assertTrue(np.all(coverage == 1), "les quatre matières doivent couvrir la carte sans chevauchement")
        self.assertTrue(np.all(rgba(OUT / "review/FCC1_scene_t000.png")[..., 3] == 255))
        constraints = self.manifest["user_constraints"]
        self.assertTrue(constraints["arena_without_crystal"])
        self.assertTrue(constraints["natural_floor_without_tiles_or_slabs"])
        names = [item["name"].lower() for item in self.layers]
        self.assertFalse(any("cristal" in name or "dalle" in name or "carrelage" in name for name in names))
        self.assertEqual(self.manifest["pmdo"]["warp"], "aucun")
        self.assertEqual(self.manifest["pmdo"]["exit"], "aucune")

    def test_vegetation_uses_automatic_rgb_and_connected_components(self):
        detection = self.manifest["segmentation"]["vegetation_detection"]
        self.assertFalse(detection["manual_plant_coordinates"])
        self.assertIn("composantes connexes", detection["method"])
        self.assertGreater(detection["kept_components"], 0)
        self.assertGreater(detection["vegetation_pixels_8px"], 0)
        mask = np.asarray(Image.open(OUT / "masques/FCC1_masque_vegetation.png").convert("L")) > 0
        self.assertEqual(int(mask.sum()), detection["vegetation_pixels_8px"])
        decor, _ = load_module("fcc1_rgb_check", BUILD).normalize_decor(HERE / "bruts/decor.png")
        r, g, b = decor.astype(np.int16).transpose(2, 0, 1)
        self.assertTrue(np.all((g > r + 5) & (g > b + 5) & (g > 42) | ~mask))

    def test_copper_palette_has_no_crystal_blue_and_no_magenta_key(self):
        image = rgba(OUT / "review/FCC1_scene_t000.png")[..., :3].astype(np.int16)
        self.assertEqual(int(((image[..., 0] > 200) & (image[..., 2] > 200) & (image[..., 1] < 90)).sum()), 0)
        blue_crystal_like = (image[..., 2] > image[..., 0] + 18) & (image[..., 2] > image[..., 1] + 15)
        self.assertEqual(int(blue_crystal_like.sum()), 0)
        rgb = image.astype(np.uint8)
        unique = np.unique(rgb.reshape(-1, 3), axis=0)
        self.assertLessEqual(len(unique), 96)

    def test_markers_are_south_centre_north_and_16px_reachable(self):
        access = self.manifest["access"]
        self.assertTrue(access["path_to_boss_16x16"])
        self.assertTrue(access["path_to_objective_16x16"])
        self.assertGreater(access["entry_px"][1], self.height - 64)
        self.assertGreater(access["boss_px"][1], access["objective_px"][1] + 80)
        self.assertGreater(access["entry_px"][1], access["boss_px"][1])
        self.assertLess(abs(access["boss_px"][0] - self.width // 2), 80)
        self.assertLess(abs(access["objective_px"][0] - self.width // 2), 80)
        build = load_module("fcc1_build_for_access", BUILD)
        mask = np.asarray(Image.open(OUT / "masques/FCC1_masque_praticable.png").convert("L")) > 0
        blocked = build.cell_grid(~mask)
        self.assertEqual(int(blocked.sum()), access["blocked_cells"])
        for point in (access["entry_px"], access["boss_px"], access["objective_px"]):
            self.assertTrue(build.footprint_free(blocked, point[1] // 8, point[0] // 8))
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["boss_cell_yx"]))[0])
        self.assertTrue(build.reachable_2x2(blocked, tuple(access["entry_cell_yx"]),
                                            tuple(access["objective_cell_yx"]))[0])
        self.assertTrue(blocked[:10].all(), "la bande nord doit rester une paroi")
        self.assertTrue(blocked[:, :18].all() and blocked[:, -18:].all(), "les bords latéraux ne sont pas des sorties")

    def test_ground_has_only_three_edit_markers_and_no_exit_or_warp(self):
        self.assertEqual(self.doc["Version"], "0.8.12.0")
        self.assertEqual(self.obj["TexSize"], 1)
        self.assertEqual(self.obj["AssetName"], "fcc1_fin_canyon_cuivre")
        self.assertEqual(len(self.obj["Layers"]), 6)
        self.assertEqual(len(self.obj["obstacles"]), 96)
        self.assertEqual(len(self.obj["obstacles"][0]), 72)
        entities = self.obj["Entities"]
        self.assertEqual(len(entities), 1)
        self.assertEqual([m["EntName"] for m in entities[0]["Markers"]], ["entrance", "boss", "objectif"])
        self.assertFalse(entities[0]["MapChars"])
        self.assertFalse(entities[0]["GroundObjects"])
        self.assertFalse(entities[0]["Spawners"])
        for marker in entities[0]["Markers"]:
            self.assertEqual(marker["Collider"]["Width"], 16)
            self.assertEqual(marker["Collider"]["Height"], 16)
        self.assertNotIn("Warp", self.obj)
        self.assertNotIn("warp", self.obj)
        self.assertFalse((STAGE / "Data/Script/fin_canyon_cuivre/ground/fcc1_fin_canyon_cuivre/warp.lua").exists())

    def test_ground_tile_banks_round_trip_to_png_layers(self):
        paths = sorted((STAGE / "Content/Tile").glob("FCC1_*.tile"))
        self.assertEqual(len(paths), 5)
        banks = {path.stem: read_tile_bank(path) for path in paths}
        for item in self.layers[:5]:
            index = item["order"]
            restored = reconstruct_layer(self.obj, banks, index)
            expected = rgba(OUT / item["file"])
            self.assertTrue(np.array_equal(restored, expected), item["name"])
        tools = load_module("fcc1_index_verify", ROOT / "source/pmdo_cote/INSTALLER.py")
        decoded = {}
        for path in paths:
            with path.open("rb") as stream:
                decoded[path.stem] = tools.read_node(stream)
        self.assertEqual(decoded.keys(), banks.keys())
        index_data = (STAGE / "Content/Tile/index.idx").read_bytes()
        self.assertEqual(struct.unpack_from("<i", index_data, 0)[0], len(paths))

    def test_openraster_round_trip_matches_scene(self):
        ora_path = ROOT / ".cache/fin_canyon_cuivre_v1/FCC1_calques.ora"
        self.assertTrue(ora_path.is_file())
        with zipfile.ZipFile(ora_path) as archive:
            self.assertEqual(archive.read("mimetype"), b"image/openraster")
            self.assertTrue({"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist()))
            merged = rgba_from_bytes(archive.read("mergedimage.png"))
            stack_xml = archive.read("stack.xml").decode("utf-8")
            self.assertIn("00 sol complet", stack_xml)
            self.assertIn("03 parois", stack_xml)
        self.assertTrue(np.array_equal(merged, rgba(OUT / "review/FCC1_scene_t000.png")))

    def test_collision_overlay_and_static_preview(self):
        preview = rgba(OUT / "review/FCC1_collisions_marqueurs.png")
        self.assertEqual(preview.shape, (self.height, self.width, 4))
        self.assertGreater(int(np.count_nonzero(preview[..., 0] > preview[..., 1] + 40)), 0)
        template = (HERE / "viewer_template.html").read_text(encoding="utf-8")
        self.assertIn("__DATA__", template)
        self.assertIn("Afficher collisions", template)
        self.assertIn("sans cristal ni dalles", template)


if __name__ == "__main__":
    unittest.main()
