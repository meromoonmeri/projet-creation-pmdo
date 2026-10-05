"""Tests EOC1 : pixels, alpha, reachabilite, ORA et serialization PMDO.

Ces tests valident les artefacts et les codecs locaux ; ils ne lancent pas PMDO.
Commande : .venv/bin/python -m unittest source.entree_canyon_cuivre_sud_nord_v1.test_build -v
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
OUT = ROOT / "renders/entree_canyon_cuivre_sud_nord_v1"
STAGE = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/entree_canyon_cuivre"
BUILD = HERE / "build.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(module)
    return module


def rgba(path: Path) -> np.ndarray:
    with Image.open(path) as image:
        return np.asarray(image.convert("RGBA"), dtype=np.uint8)


def read_tile_bank(path: Path):
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<ii", raw, 0)
    if tile_size != 8:
        raise AssertionError(f"Taille de tuile native inattendue dans {path}: {tile_size}")
    result = {}
    cache = {}
    for i in range(count):
        x, y, offset = struct.unpack_from("<iiq", raw, 8 + 16 * i)
        length, = struct.unpack_from("<q", raw, offset)
        if offset < 8 + count * 16 or length < 1 or offset + 8 + length > len(raw):
            raise AssertionError(f"Offset .tile invalide dans {path}")
        if offset not in cache:
            with Image.open(io.BytesIO(raw[offset + 8:offset + 8 + length])) as image:
                tile = np.array(image.convert("RGBA"), dtype=np.uint32)
            # RogueEssence stores premultiplied alpha. Reverse it for a visual round-trip.
            alpha = tile[..., 3:4]
            tile[..., :3] = np.minimum(255, (tile[..., :3] * 255 + alpha // 2) // np.maximum(alpha, 1))
            tile[alpha[..., 0] == 0] = 0
            cache[offset] = tile.astype(np.uint8)
        if (x, y) in result:
            raise AssertionError(f"Coordonnee tuile dupliquee dans {path}: {(x, y)}")
        result[(x, y)] = cache[offset]
    return result


def reconstruct_layer(obj, banks, layer_index: int, phase: int = 0, width=96, height=72):
    out = np.zeros((height * 8, width * 8, 4), dtype=np.uint8)
    for x, col in enumerate(obj["Layers"][layer_index]["Tiles"]):
        for y, tile in enumerate(col):
            if not tile["Layers"]:
                continue
            for track in tile["Layers"]:
                frames = track["Frames"]
                frame = frames[phase % len(frames)]
                sheet = frame["Sheet"]
                pos = frame["TexLoc"]
                out[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8] = banks[sheet][(pos["X"], pos["Y"])]
    return out


class EOC1Build(unittest.TestCase):
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

    def test_input_hashes_and_generation_provenance(self):
        for source in self.manifest["inputs"]:
            path = ROOT / source["file"]
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source["sha256"])
            with Image.open(path) as image:
                self.assertEqual(list(image.size), source["size_px"])
        self.assertEqual(self.manifest["reference"]["code"], "D55P11A")
        self.assertIn("no dungeon name inferred", self.manifest["reference"]["identification"])
        self.assertEqual(self.manifest["generation"][0]["selected_option"], 1)
        self.assertFalse(self.manifest["art_approved"])
        self.assertFalse(self.manifest["runtime_tested"])

    def test_dimensions_layers_and_binary_alpha(self):
        self.assertEqual((self.width, self.height), (768, 576))
        self.assertEqual(self.manifest["grid_cells"], [96, 72])
        self.assertEqual((self.width % 8, self.height % 8), (0, 0))
        self.assertEqual(len(self.layers), 9)
        images = []
        for item in self.layers:
            if item["name"] == "07_poussiere":
                paths = sorted((OUT / "animation/poussiere").glob("EOC1_07_poussiere_f*.png"))
            else:
                paths = [OUT / item["file"]]
            for path in paths:
                image = rgba(path)
                self.assertEqual(image.shape, (self.height, self.width, 4), path)
                self.assertTrue(set(np.unique(image[..., 3])) <= {0, 255}, path)
                images.append(image)
            self.assertEqual(item["phases"], 24 if item["name"] == "07_poussiere" else 1)
        self.assertTrue(np.all(images[0][..., 3] == 255), "sol complet doit être opaque")
        top = rgba(OUT / "calques/EOC1_08_top.png")
        self.assertFalse(np.any(top))

    def test_scene_masks_partition_every_pixel_once(self):
        masks = []
        for name in ("sol", "ombres", "parois", "blocs", "vegetation", "profondeur"):
            path = OUT / "masques" / f"EOC1_masque_{name}.png"
            mask = np.asarray(Image.open(path).convert("L"), dtype=np.uint8) > 0
            self.assertEqual(mask.shape, (self.height, self.width))
            masks.append(mask)
        coverage = np.stack(masks).sum(axis=0)
        self.assertTrue(np.all(coverage == 1), "les six calques doivent former une partition sans trou ni chevauchement")
        visual_coverage = np.zeros((self.height, self.width), dtype=bool)
        for item in self.layers[1:7]:
            visual_coverage |= rgba(OUT / item["file"])[..., 3] == 255
        self.assertTrue(visual_coverage.all(), "les calques opaques doivent recouvrir le sol complet")
        for item in self.layers:
            path = (OUT / "animation/poussiere/EOC1_07_poussiere_f00.png"
                    if item["name"] == "07_poussiere" else OUT / item["file"])
            image = rgba(path)
            visible = image[image[..., 3] == 255, :3].astype(int)
            magenta = (visible[:, 0] > 200) & (visible[:, 2] > 200) & (visible[:, 1] < 90)
            self.assertEqual(int(magenta.sum()), 0, path)

    def test_plants_are_detected_from_color_not_manual_coordinates(self):
        segmentation = self.manifest["segmentation"]
        self.assertIn("automatic raw-RGB mask", segmentation["vegetation_detection"])
        self.assertGreater(segmentation["vegetation_pixels_8px"], 0)
        mask = np.asarray(Image.open(OUT / "masques/EOC1_masque_vegetation.png").convert("L")) > 0
        self.assertEqual(int(mask.sum()), segmentation["vegetation_pixels_8px"])
        self.assertGreater(segmentation["rock_pixels_8px"], 0)
        self.assertGreater(segmentation["cave_pixels_8px"], 0)

    def test_animation_is_a_bounded_24_phase_loop(self):
        data = self.manifest["animation"]
        self.assertEqual(data["phases"], 24)
        self.assertEqual(data["frame_length_ticks"], 5)
        self.assertEqual(data["loop_ticks"], 120)
        self.assertAlmostEqual(data["loop_seconds_at_60hz"], 2.0)
        files = sorted((OUT / "animation/poussiere").glob("EOC1_07_poussiere_f*.png"))
        self.assertEqual(len(files), 24)
        frames = [rgba(path) for path in files]
        expected_palette = {tuple(color) for color in data["palette_rgb"]}
        distinct = set()
        for frame in frames:
            self.assertEqual(frame.shape, (self.height, self.width, 4))
            self.assertTrue(set(np.unique(frame[..., 3])) <= {0, 255})
            self.assertEqual(int((frame[..., 3] == 255).sum()), int(np.count_nonzero(frame[..., 3])))
            colors = {tuple(v) for v in frame[frame[..., 3] == 255, :3]}
            self.assertTrue(colors <= expected_palette)
            distinct.add(frame.tobytes())
        self.assertGreaterEqual(len(distinct), 12, "la boucle de poussière doit avoir des phases visuellement distinctes")
        with Image.open(OUT / "review/EOC1_scene_animee.webp") as webp:
            self.assertEqual(webp.n_frames, 24)

    def test_composite_and_openraster_round_trip(self):
        ora_path = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/EOC1_calques.ora"
        self.assertTrue(ora_path.is_file())
        with zipfile.ZipFile(ora_path) as archive:
            self.assertEqual(archive.read("mimetype"), b"image/openraster")
            merged = rgba_from_bytes(archive.read("mergedimage.png"))
            stack = archive.read("stack.xml").decode("utf-8")
            self.assertIn("00 sol complet", stack)
            self.assertIn("07 poussiere phase 00", stack)
        scene = Image.new("RGBA", (self.width, self.height), (0, 0, 0, 0))
        for item in self.layers:
            path = (OUT / "animation/poussiere/EOC1_07_poussiere_f00.png"
                    if item["name"] == "07_poussiere" else OUT / item["file"])
            image = rgba(path)
            scene.alpha_composite(Image.fromarray(image, "RGBA"))
        rebuilt = np.asarray(scene)
        self.assertTrue(np.array_equal(rebuilt, merged))
        self.assertTrue(np.array_equal(rebuilt, rgba(OUT / "review/EOC1_scene_t000.png")))

    def test_markers_are_south_to_north_and_16px_reachable(self):
        access = self.manifest["access"]
        self.assertTrue(access["path_found_16x16"])
        self.assertGreater(access["entry_px"][1], self.height - 64)
        self.assertLess(access["threshold_px"][1], self.height // 2)
        self.assertEqual([access["entry_px"][0] % 8, access["entry_px"][1] % 8], [0, 0])
        self.assertEqual([access["threshold_px"][0] % 8, access["threshold_px"][1] % 8], [0, 0])
        self.assertIsNone(self.manifest["pmdo"]["warp"])
        markers = self.obj["Entities"][0]["Markers"]
        self.assertEqual({m["EntName"] for m in markers}, {"entrance", "donjon_seuil"})
        for marker in markers:
            self.assertEqual(marker["Collider"]["Width"], 16)
            self.assertEqual(marker["Collider"]["Height"], 16)
        self.assertEqual(markers[0]["Collider"]["X"], access["entry_px"][0])
        self.assertEqual(markers[0]["Collider"]["Y"], access["entry_px"][1])
        self.assertEqual(markers[1]["Collider"]["X"], access["threshold_px"][0])
        self.assertEqual(markers[1]["Collider"]["Y"], access["threshold_px"][1])
        self.assertNotIn("Warp", self.obj)
        self.assertNotIn("Destination", self.obj)
        init_script = (STAGE / f"Data/Script/{self.manifest['namespace']}/ground/{self.manifest['asset']}/init.lua").read_text()
        self.assertNotRegex(init_script.lower(), r"(?<!comment )warp\s*\(")

    def test_ground_and_tile_bank_round_trip(self):
        self.assertEqual(self.doc["Version"], "0.8.12.0")
        self.assertEqual(self.obj["TexSize"], 1)
        self.assertEqual(self.obj["AssetName"], self.manifest["asset"])
        self.assertFalse(self.obj["Released"])
        self.assertEqual(len(self.obj["Layers"]), 9)
        self.assertEqual((len(self.obj["Layers"][0]["Tiles"]),
                          len(self.obj["Layers"][0]["Tiles"][0])), (96, 72))
        self.assertEqual(self.obj["Layers"][-1]["Layer"], 4)
        self.assertEqual(len(self.obj["obstacles"]), 96)
        self.assertTrue(all(len(col) == 72 for col in self.obj["obstacles"]))
        tile_dir = STAGE / "Content/Tile"
        banks = {path.stem: read_tile_bank(path) for path in tile_dir.glob("*.tile")}
        self.assertEqual(set(banks), set(self.manifest["pmdo"]["tile_banks"]))
        for name, expected_count in self.manifest["pmdo"]["tile_banks"].items():
            self.assertEqual(len(banks[name]), expected_count, name)
        for i, item in enumerate(self.layers):
            expected = (rgba(OUT / "animation/poussiere/EOC1_07_poussiere_f00.png")
                        if item["name"] == "07_poussiere" else rgba(OUT / item["file"]))
            phases = [0, 7, 23] if item["name"] == "07_poussiere" else [0]
            for phase in phases:
                result = reconstruct_layer(self.obj, banks, i, phase, width=96, height=72)
                if item["name"] == "07_poussiere":
                    expected = rgba(OUT / f"animation/poussiere/EOC1_07_poussiere_f{phase:02d}.png")
                self.assertTrue(np.array_equal(result, expected), (item["name"], phase))
        blocked_count = sum(entry["Tags"] for column in self.obj["obstacles"] for entry in column)
        self.assertEqual(blocked_count, self.manifest["access"]["blocked_cells"])
        index_tools = load_module("index_tools_eoc1_test", ROOT / "source/pmdo_cote/INSTALLER.py")
        self.assertEqual(set(index_tools.read_index(tile_dir / "index.idx")), set(banks))
        self.assertIn("0.8.12.0", (STAGE / "Mod.xml").read_text(encoding="utf-8"))

    def test_collision_preview_and_grid_match(self):
        image = rgba(OUT / "review/EOC1_collisions_marqueurs.png")
        self.assertEqual(image.shape, (self.height, self.width, 4))
        raw_grid = np.asarray(Image.open(OUT / "masques/EOC1_masque_praticable.png").convert("L")) > 0
        build = load_module("eoc1_build_for_grid_test", BUILD)
        blocked = build.cell_grid(~raw_grid)
        self.assertEqual(int(blocked.sum()), self.manifest["access"]["blocked_cells"])
        self.assertTrue(build.reachable_2x2(blocked,
                        tuple(self.manifest["access"]["entry_cell_yx"]),
                        tuple(self.manifest["access"]["threshold_cell_yx"]))[0])


def rgba_from_bytes(raw: bytes) -> np.ndarray:
    return np.asarray(Image.open(io.BytesIO(raw)).convert("RGBA"), dtype=np.uint8)


if __name__ == "__main__":
    unittest.main()
