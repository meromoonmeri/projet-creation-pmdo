#!/usr/bin/env python3
"""Build EOC1: Entrée du Canyon Cuivré, PMDO 0.8.12, 4:3 / 8 px.

The generated artwork is a referenced composition, not a native PMD tileset.
Run from the repository root with .venv/bin/python.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import math
import shutil
import uuid
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RAW = HERE / "bruts"
OUT = ROOT / "renders/entree_canyon_cuivre_sud_nord_v1"
STAGE = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/entree_canyon_cuivre"
ORA = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/EOC1_calques.ora"
REF = ROOT / ".cache/maps_pmdsky/rom/png/D55P11A.png"
PFX = "EOC1"
NAMESPACE = "entree_canyon_cuivre"
ASSET = "eoc1_entree_canyon_cuivre"
W, H = 768, 576
GRID = 8
GW, GH = W // GRID, H // GRID
RAW_DECOR_SIZE = (2304, 1728)  # 3 x (768 x 576), exact 4:3
RAW_FLOOR_SIZE = (1200, 896)   # image generator output; padded to 1200 x 900 before reduction
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS
PALETTE_SIZE = 96
REFERENCE_SHA256 = "8f59c745f3a40fc300e767a5eafc1d6bc8610d85c733b15809d4b0bd08b58213"

# Open playable canyon floor, measured from the selected composition at 1x.
FLOOR_POLYGON = [
    (350, 132), (415, 132), (428, 154), (452, 172), (489, 188),
    (526, 205), (557, 229), (580, 255), (602, 288), (625, 321),
    (650, 354), (678, 383), (704, 407), (704, 575), (64, 575),
    (64, 410), (82, 382), (98, 349), (114, 317), (132, 282),
    (158, 250), (186, 226), (220, 208), (256, 193), (291, 178),
    (320, 161), (338, 145),
]
CAVE_BOX = (316, 72, 454, 174)  # x0, y0, x1, y1 at game-pixel scale
# Local windows around the visible floor boulder groups. These refine layer and collision masks;
# pixels still remain from the source composition, never repainted or mirrored.
BLOCK_BOXES = [
    (142, 444, 224, 522),
    (198, 510, 322, 576),
    (458, 526, 514, 576),
    (510, 424, 622, 512),
    (600, 482, 672, 544),
]
DUST_BASES = [
    (256, 284), (496, 264), (213, 354), (560, 350),
    (315, 420), (448, 392), (285, 466), (535, 405),
    (365, 238), (414, 302),
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Impossible de charger {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rgb_image(path: Path) -> np.ndarray:
    return np.asarray(Image.open(path).convert("RGB"), dtype=np.uint8)


def polygon_mask(points, size=(W, H)) -> np.ndarray:
    image = Image.new("L", size, 0)
    ImageDraw.Draw(image).polygon(points, fill=255)
    return np.asarray(image, dtype=np.uint8) > 0


def scaled_poly(points, factor: int = 3) -> list[tuple[int, int]]:
    return [(int(x * factor), int(y * factor)) for x, y in points]


def keep_components(mask: np.ndarray, minimum: int) -> np.ndarray:
    labels, count = ndi.label(mask)
    if count == 0:
        return mask
    sizes = ndi.sum(mask, labels, range(1, count + 1))
    keep = 1 + np.flatnonzero(sizes >= minimum)
    return np.isin(labels, keep)


def magenta_key(rgb: np.ndarray) -> np.ndarray:
    """Reference key() ratio. The cave matte is painted pure magenta first; no hue guessing."""
    r, g, b = rgb.astype(np.int16).transpose(2, 0, 1)
    return (r > 200) & (b > 200) & (g < 90) & (np.abs(r - b) < 45) & (r > 1.45 * g) & (b > 1.45 * g)


def downsample_by_class(rgb: np.ndarray, classes: dict[str, np.ndarray]):
    """Uniform 3x reduction; each output pixel averages only the winning material class."""
    view = rgb.reshape(H, 3, W, 3, 3).astype(np.float32)
    names = list(classes)
    counts, means = [], []
    for name in names:
        weights = classes[name].reshape(H, 3, W, 3).astype(np.float32)
        count = weights.sum(axis=(1, 3))
        total = (view * weights[..., None]).sum(axis=(1, 3))
        means.append(np.rint(total / np.maximum(count[..., None], 1)).clip(0, 255).astype(np.uint8))
        counts.append(count)
    counts = np.stack(counts, axis=0)
    winner = counts.argmax(axis=0)
    out = np.zeros((H, W, 3), dtype=np.uint8)
    masks = {}
    for i, name in enumerate(names):
        m = winner == i
        out[m] = means[i][m]
        masks[name] = m
    return out, masks, counts


def downsample_floor(path: Path) -> tuple[np.ndarray, dict]:
    im = Image.open(path).convert("RGB")
    source_size = im.size
    # The generated companion is 1200x896 (ratio 1.339). Extend 2 edge rows at
    # top/bottom to make a 1200x900 4:3 canvas, then reduce uniformly by 0.64.
    if im.size == RAW_FLOOR_SIZE:
        a = np.asarray(im, dtype=np.uint8)
        a = np.pad(a, ((2, 2), (0, 0), (0, 0)), mode="edge")
        im = Image.fromarray(a)
    elif im.size != (1200, 900):
        raise ValueError(f"sol_complet attendu 1200x896 ou 1200x900, reçu {im.size}")
    floor = np.asarray(im.resize((W, H), Image.Resampling.BOX), dtype=np.uint8)
    return floor, {"source_px": list(source_size), "normalized_px": [1200, 900], "scale_xy": [0.64, 0.64],
                   "method": "edge-pad 2 px top/bottom, then uniform BOX reduction"}


def make_art_layers(raw_decor: np.ndarray):
    if raw_decor.shape != (H * 3, W * 3, 3):
        raise ValueError(f"decor attendu {W*3}x{H*3}, reçu {raw_decor.shape[1]}x{raw_decor.shape[0]}")

    floor_domain = polygon_mask(FLOOR_POLYGON)
    floor_full = np.repeat(np.repeat(floor_domain, 3, axis=0), 3, axis=1)

    # Detect the dark northern cavity in a bounded region, then run it through the
    # explicit magenta key path. The original dark pixels are kept for the Depth layer.
    cave_zone_low = polygon_mask([(CAVE_BOX[0], CAVE_BOX[1]), (CAVE_BOX[2], CAVE_BOX[1]),
                                  (CAVE_BOX[2], CAVE_BOX[3]), (CAVE_BOX[0], CAVE_BOX[3])])
    cave_zone = np.repeat(np.repeat(cave_zone_low, 3, axis=0), 3, axis=1)
    rr, gg, bb = raw_decor.astype(np.int16).transpose(2, 0, 1)
    lum_hi = raw_decor.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    dark_core = cave_zone & (lum_hi < 63) & (rr < 105) & (gg < 92) & (bb < 82)
    dark_core = ndi.binary_closing(dark_core, iterations=2)
    cave_raw = keep_components(dark_core, 500)
    cave_raw = ndi.binary_fill_holes(cave_raw)
    keyed = raw_decor.copy()
    keyed[cave_raw] = (255, 0, 255)
    keyed_pixels = magenta_key(keyed)
    if not np.array_equal(keyed_pixels, cave_raw):
        raise AssertionError("Le matte magenta de la bouche ne correspond pas au key() exact")

    # Green tufts are kept as a separate material; small isolated antialias flecks are ignored.
    vegetation_core = (gg > rr + 10) & (gg > bb + 10) & (gg > 42)
    vegetation_core = ndi.binary_closing(vegetation_core, iterations=1)
    vegetation_raw = keep_components(vegetation_core, 70)
    vegetation_raw = ndi.binary_dilation(vegetation_raw, iterations=2)

    # Exclusive classes make the high-resolution reduction auditable.
    cave_class = keyed_pixels
    vegetation_class = vegetation_raw & ~cave_class
    floor_class = floor_full & ~cave_class & ~vegetation_class
    wall_class = ~(cave_class | vegetation_class | floor_class)
    class_rgb, winner_masks, class_counts = downsample_by_class(
        raw_decor, {"profondeur": cave_class, "vegetation": vegetation_class,
                    "sol": floor_class, "parois": wall_class})

    floor_px = winner_masks["sol"]
    wall_px = winner_masks["parois"]
    cave_px = winner_masks["profondeur"]
    vegetation_px = winner_masks["vegetation"]

    # The low-resolution boulder windows isolate the obvious ground piles without
    # turning all ochre texture into collision. The measured local contrast rejects plain sand.
    yy, xx = np.mgrid[:H, :W]
    roi = np.zeros((H, W), dtype=bool)
    for x0, y0, x1, y1 in BLOCK_BOXES:
        roi[y0:y1, x0:x1] = True
    lum = class_rgb.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    local_mean = ndi.uniform_filter(lum, size=5, mode="nearest")
    local_second = ndi.uniform_filter(lum * lum, size=5, mode="nearest")
    local_sd = np.sqrt(np.maximum(local_second - local_mean * local_mean, 0))
    floor_rgb = np.array([215, 159, 95], dtype=np.float32)
    floor_delta = np.linalg.norm(class_rgb.astype(np.float32) - floor_rgb, axis=2)
    rock_candidates = roi & floor_px & ((local_sd >= 8.5) | (floor_delta >= 54))
    rock_candidates = ndi.binary_closing(rock_candidates, iterations=1)
    blocks = keep_components(rock_candidates, 6) & floor_px

    # Actual dark pixels already painted into the map are assigned to a separate opaque
    # shadow layer. This does not introduce a filter or alpha fringe.
    shadows = floor_px & ~blocks & ~vegetation_px & ~cave_px & (lum < 112) & (local_sd > 8)
    vegetation = vegetation_px & ~cave_px
    blocks &= ~vegetation & ~cave_px
    shadows &= ~vegetation & ~cave_px
    sol = floor_px & ~(blocks | shadows | vegetation | cave_px)
    parois = wall_px & ~(vegetation | cave_px)
    # Any class not represented by the precedence above is assigned to its geometric side.
    covered = sol | shadows | parois | blocks | vegetation | cave_px
    remainder = ~covered
    sol |= remainder & floor_px
    parois |= remainder & ~floor_px

    masks = {"sol": sol, "ombres": shadows, "parois": parois,
             "blocs": blocks, "vegetation": vegetation, "profondeur": cave_px}
    occupancy = np.stack(list(masks.values())).sum(0)
    if not np.all(occupancy == 1):
        raise AssertionError("Les calques statiques ne partitionnent pas exactement la scène")

    # Collision mask is deliberately more conservative than the artwork: walls, deep cave,
    # plants and stone piles are blocked; the broad floor corridor remains traversable.
    walk_px = floor_px & ~blocks & ~vegetation & ~cave_px
    walk_px = ndi.binary_erosion(walk_px, iterations=1, border_value=0)
    blocked = cell_grid(~walk_px)
    access = choose_markers(blocked)
    return class_rgb, masks, floor_px, walk_px, blocked, access, {
        "magenta_keyed_pixels_hi": int(keyed_pixels.sum()),
        "cave_pixels_8px": int(cave_px.sum()),
        "vegetation_pixels_8px": int(vegetation.sum()),
        "rock_pixels_8px": int(blocks.sum()),
        "shadow_pixels_8px": int(shadows.sum()),
        "class_pixel_counts": {name: int(mask.sum()) for name, mask in winner_masks.items()},
        "floor_polygon": [list(p) for p in FLOOR_POLYGON],
        "block_windows": [list(b) for b in BLOCK_BOXES],
        "key": "cave void selected by low-luminance source pixels, filled with #FF00FF, then extracted by channel-ratio key()",
        "vegetation_detection": "automatic raw-RGB mask g > r+10, g > b+10, g > 42; 1 px closing, components >=70 source pixels, then 2 px dilation",
    }


def cell_grid(nonwalk: np.ndarray) -> np.ndarray:
    """One PMDO cell is blocked when >=25% of its 8x8 pixels are non-walkable."""
    if nonwalk.shape != (H, W):
        raise ValueError(nonwalk.shape)
    blocked_fraction = nonwalk.reshape(GH, GRID, GW, GRID).mean(axis=(1, 3))
    return blocked_fraction >= 0.25


def footprint_free(blocked: np.ndarray, y: int, x: int) -> bool:
    return (0 <= y <= GH - 2 and 0 <= x <= GW - 2 and not blocked[y:y + 2, x:x + 2].any())


def reachable_2x2(blocked: np.ndarray, start: tuple[int, int], goal: tuple[int, int]):
    if not footprint_free(blocked, *start) or not footprint_free(blocked, *goal):
        return False, 0, []
    seen = np.zeros((GH, GW), dtype=bool)
    prev = {}
    queue = [start]
    seen[start] = True
    for y, x in queue:
        if (y, x) == goal:
            path = [(y, x)]
            while path[-1] != start:
                path.append(prev[path[-1]])
            path.reverse()
            return True, int(seen.sum()), path
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < GH and 0 <= nx < GW and not seen[ny, nx] and footprint_free(blocked, ny, nx):
                seen[ny, nx] = True
                prev[(ny, nx)] = (y, x)
                queue.append((ny, nx))
    return False, int(seen.sum()), []


def choose_markers(blocked: np.ndarray) -> dict:
    starts = [(y, x) for y in range(GH - 5, GH - 1) for x in range(GW // 2 - 6, GW // 2 + 6)
              if footprint_free(blocked, y, x)]
    # The cave threshold is near row 19 (152 px); keep the marker immediately
    # outside the dark opening instead of drifting south to the shortest path tile.
    goals = [(19, x) for x in range(GW // 2 - 10, GW // 2 + 11)
             if footprint_free(blocked, 19, x)]
    if not starts or not goals:
        raise AssertionError(f"Arrivée ou seuil introuvable : {len(starts)=}, {len(goals)=}")
    starts.sort(key=lambda p: (abs(p[1] - (GW // 2 - 1)) + abs(p[0] - (GH - 3)), p))
    goals.sort(key=lambda p: (abs(p[1] - (GW // 2 - 1)) + abs(p[0] - 20), p))
    best = None
    for start in starts:
        for goal in goals:
            ok, explored, path = reachable_2x2(blocked, start, goal)
            if ok:
                score = len(path) + 0.05 * abs(goal[1] - (GW // 2 - 1))
                if best is None or score < best[0]:
                    best = (score, start, goal, explored, path)
    if best is None:
        raise AssertionError("Aucun chemin 16x16 entre le sud et le seuil nord")
    _, start, goal, explored, path = best
    return {"entry_cell_yx": list(start), "threshold_cell_yx": list(goal),
            "entry_px": [start[1] * GRID, start[0] * GRID],
            "threshold_px": [goal[1] * GRID, goal[0] * GRID],
            "path_found_16x16": True, "path_cells": len(path),
            "cells_explored": explored, "blocked_cells": int(blocked.sum()),
            "walkable_cells": int((~blocked).sum()),
            "rule": "case bloquée si au moins 25 % des pixels hors sol ; empreinte joueur 16x16 px"}


def quantize_layers(layers: dict[str, np.ndarray], colors: int = PALETTE_SIZE):
    opaque = np.concatenate([arr[arr[..., 3] == 255, :3] for arr in layers.values() if np.any(arr[..., 3] == 255)], axis=0)
    sample = Image.fromarray(opaque.reshape(-1, 1, 3), "RGB")
    palette_image = sample.quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette = np.asarray(palette_image.getpalette()[:colors * 3], dtype=np.uint8).reshape(-1, 3)
    out = {}
    for name, arr in layers.items():
        result = arr.copy()
        mask = result[..., 3] == 255
        if np.any(mask):
            q = Image.fromarray(result[..., :3], "RGB").quantize(palette=palette_image, dither=Image.Dither.NONE)
            result[..., :3] = palette[np.asarray(q, dtype=np.uint8)]
        result[result[..., 3] == 0] = 0
        out[name] = result
    return out, palette


def rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((H, W, 4), dtype=np.uint8)
    out[..., :3] = rgb
    out[..., 3] = np.where(mask, 255, 0).astype(np.uint8)
    out[~mask] = 0
    return out


def dust_frames(floor_mask: np.ndarray, palette: np.ndarray) -> list[np.ndarray]:
    """Original warm dust specks; a 24-phase, 5-tick loop, not a recovered PMD animation."""
    luminance = palette.astype(float) @ np.array([0.299, 0.587, 0.114])
    # Warm light pixels from the common map palette, not an arbitrary new color ramp.
    warm = np.where((palette[:, 0] >= palette[:, 1]) & (palette[:, 1] > palette[:, 2]))[0]
    if len(warm) == 0:
        warm = np.arange(len(palette))
    order = warm[np.argsort(luminance[warm])]
    colors = [palette[int(order[-1])], palette[int(order[-2 if len(order) > 1 else -1])]]
    frames = []
    for t in range(PHASES):
        canvas = np.zeros((H, W, 4), dtype=np.uint8)
        for i, (bx, by) in enumerate(DUST_BASES):
            phase = (t + i * 3) % PHASES
            # Each mote rises for 12 phases, fades out, then respawns at its base.
            if phase >= 12:
                continue
            x = int(round(bx + 2.0 * math.sin((phase / 12.0) * math.pi * 2 + i)))
            y = by - phase
            if not (2 <= x < W - 2 and 2 <= y < H - 2 and floor_mask[y, x]):
                continue
            color = tuple(int(v) for v in colors[(phase // 4 + i) % len(colors)])
            # A tiny diamond with two staggered pixels; hard edges only.
            canvas[y, x] = (*color, 255)
            if phase in (3, 4, 5, 9, 10):
                canvas[y - 1, x] = (*color, 255)
                if i % 2 == 0:
                    canvas[y, x + 1] = (*color, 255)
        frames.append(canvas)
    return frames


def write_ora(path: Path, stack: list[tuple[str, np.ndarray]]):
    path.parent.mkdir(parents=True, exist_ok=True)
    image_root = ET.Element("image", w=str(W), h=str(H), name="EOC1 — Entrée du Canyon Cuivré")
    xml_stack = ET.SubElement(image_root, "stack")
    composite = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        archive.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for idx, (name, arr) in reversed(list(enumerate(stack))):
            source = f"data/layer{idx:02d}.png"
            ET.SubElement(xml_stack, "layer", name=name, src=source, x="0", y="0", opacity="1.0",
                          visibility="visible", **{"composite-op": "svg:src-over"})
            stream = io.BytesIO()
            Image.fromarray(arr, "RGBA").save(stream, format="PNG", compress_level=9)
            archive.writestr(source, stream.getvalue())
        for _, arr in stack:
            composite.alpha_composite(Image.fromarray(arr, "RGBA"))
        merged = io.BytesIO()
        composite.save(merged, format="PNG", compress_level=9)
        archive.writestr("mergedimage.png", merged.getvalue())
        thumb = composite.copy()
        thumb.thumbnail((256, 256), Image.Resampling.LANCZOS)
        thumb_stream = io.BytesIO()
        thumb.save(thumb_stream, format="PNG")
        archive.writestr("Thumbnails/thumbnail.png", thumb_stream.getvalue())
        archive.writestr("stack.xml", ET.tostring(image_root, encoding="utf-8", xml_declaration=True))


def save_png(path: Path, arr: np.ndarray):
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(arr).save(path, optimize=True)


def composite_stack(stack: list[tuple[str, list[np.ndarray], int]], tick: int = 0) -> Image.Image:
    result = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for _name, frames, ticks in stack:
        result.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)], "RGBA"))
    return result


def ground_project(stack: list[tuple[str, list[np.ndarray], int]], blocked: np.ndarray,
                   access: dict) -> dict[str, int]:
    gfx = load_module("pmdo_codec_eoc1", ROOT / "source/pmdo_cote/build.py")
    index_tools = load_module("pmdo_index_tools_eoc1", ROOT / "source/pmdo_cote/INSTALLER.py")
    template_path = ROOT / "cliffdaytest.rsground"
    if not template_path.exists():
        raise FileNotFoundError("Template Ground PMDO attendu: cliffdaytest.rsground")
    template = json.loads(template_path.read_text(encoding="utf-8-sig"))
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / "Content/Tile").mkdir(parents=True)
    (STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}").mkdir(parents=True)
    (STAGE / "Data/Ground").mkdir(parents=True)

    layers, banks = [], []
    for index, (title, frames, frame_ticks) in enumerate(stack):
        bank = gfx.TileBank(f"{PFX}_{index:02d}_{title.upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        if len(frames) == 1:
            image = frames[0]

            def cell(x, y, bank=bank, image=image):
                tile = bank.add(Image.fromarray(image[y * GRID:(y + 1) * GRID, x * GRID:(x + 1) * GRID], "RGBA"), x, y)
                return [tile] if tile else []

            layer = gfx.layer(f"{index:02d} {title.replace('_', ' ')}", GW, GH, cell)
        else:
            def cells(x, y, bank=bank, frames=frames):
                refs = [bank.add(Image.fromarray(frame[y * GRID:(y + 1) * GRID,
                                                         x * GRID:(x + 1) * GRID], "RGBA"), x, y)
                        for frame in frames]
                if all(ref is None for ref in refs):
                    return []
                blank = {"Sheet": bank.name, "TexLoc": {"X": 0, "Y": 0}}
                return [ref if ref is not None else blank for ref in refs]

            layer = gfx.layer(f"{index:02d} {title.replace('_', ' ')}", GW, GH, cells, frame_ticks)
        layers.append(layer)
        banks.append(bank)

    # Explicit empty top/front layer, Layer=4 as required by the project method.
    top_index = len(layers)
    layers.append(gfx.layer(f"{top_index:02d} Top (vide)", GW, GH, draw=4))
    for bank in banks:
        bank.write(STAGE / f"Content/Tile/{bank.name}.tile")

    obj = template["Object"]
    obj.update({
        "TexSize": 1,
        "Name": {"DefaultText": "Entrée du Canyon Cuivré — sud vers nord", "LocalTexts": {}},
        "AssetName": ASSET,
        "Released": False,
        "Comment": ("PMDO 0.8.12. Carte de travail 4:3, composition générée référencée à PMD Sky D55P11A. "
                    "Textures générées, pas des tuiles canoniques certifiées. Marqueur donjon_seuil sans warp ni destination. "
                    "Collisions de grille à vérifier dans PMDO en jeu."),
        "Music": "",
        "EdgeView": 1,
        "ViewCenter": None,
        "ViewOffset": {"X": 0, "Y": 0},
        "ActiveChar": None,
        "Status": {},
        "Background": {"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        "Layers": layers,
        "Decorations": [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}],
    })
    obj["obstacles"] = [[
        {"Bounds": {"X": x * GRID, "Y": y * GRID, "Width": GRID, "Height": GRID},
         "Tags": int(blocked[y, x])}
        for y in range(GH)] for x in range(GW)]
    marker = lambda name, px: {"EntName": name, "Direction": 4, "EntEnabled": True, "triggerType": 0,
                               "Collider": {"X": px[0], "Y": px[1], "Width": 16, "Height": 16}}
    obj["Entities"] = [{"Name": "Entrée et seuil de donjon", "Visible": True,
                         "MapChars": [], "GroundObjects": [], "Spawners": [],
                         "Markers": [marker("entrance", access["entry_px"]),
                                     marker("donjon_seuil", access["threshold_px"])]}]
    template["Version"] = "0.8.12.0"
    ground_path = STAGE / f"Data/Ground/{ASSET}.rsground"
    gfx.save(ground_path, json.dumps(template, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))
    gfx.save(STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua",
             (f"-- {ASSET}: marqueur de seuil seulement, aucun warp ni destination.\n"
              f"local {ASSET} = {{}}\nreturn {ASSET}\n").encode("utf-8"))

    nodes = {}
    for tile_path in sorted((STAGE / "Content/Tile").glob("*.tile")):
        with tile_path.open("rb") as stream:
            nodes[tile_path.stem] = index_tools.read_node(stream)
    (STAGE / "Content/Tile/index.idx").write_bytes(index_tools.encode_index(nodes))

    mod_uuid = uuid.uuid5(uuid.NAMESPACE_URL,
                          "https://github.com/meromoonmeri/projet-pmdo/" + NAMESPACE)
    (STAGE / "Mod.xml").write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree du Canyon Cuivre - EOC1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Entree de donjon 4:3 generee et referencee, arrivee sud, seuil de grotte nord. Projet de carte, sans warp.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{mod_uuid}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''', encoding="utf-8")

    installer = (ROOT / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle not in installer:
        raise RuntimeError("Le point d'extension de l'installeur a changé; relire la méthode avant patch")
    installer = installer.replace(needle, needle +
                                  "            if relative.as_posix() == 'Content/Tile/index.idx':\n"
                                  "                continue\n", 1)
    (STAGE / "INSTALLER.py").write_text(installer, encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")
    return {bank.name: len(bank.data) for bank in banks}


def reference_fidelity(scene: np.ndarray, floor_mask: np.ndarray) -> dict | None:
    if not REF.exists():
        return None
    if sha256(REF) != REFERENCE_SHA256:
        raise ValueError(f"SHA de référence D55P11A inattendu: {sha256(REF)}")
    ref = rgb_image(REF).astype(np.float32)
    ref_floor = np.max(np.abs(ref - np.array([215, 159, 95], np.float32)), axis=2) <= 28
    src_mean = ref[ref_floor].mean(axis=0)
    out_mean = scene[floor_mask].astype(np.float32).mean(axis=0)
    distance = float(np.linalg.norm(src_mean - out_mean))
    return {"metric": "distance euclidienne RGB des moyennes, plancher approx. autour de la couleur majoritaire du rip",
            "reference_floor_mean_rgb": [round(float(v), 1) for v in src_mean],
            "generated_walkable_mean_rgb": [round(float(v), 1) for v in out_mean],
            "distance": round(distance, 1),
            "threshold": 35,
            "interpretation": "mesure de matière indicative ; ne prouve ni pixels natifs ni validation artistique"}


def build() -> dict:
    decor_path = RAW / "decor.png"
    floor_path = RAW / "sol_complet.png"
    if not decor_path.exists() or not floor_path.exists():
        raise FileNotFoundError("Bruts requis : source/entree_canyon_cuivre_sud_nord_v1/bruts/decor.png et sol_complet.png")
    raw_decor = rgb_image(decor_path)
    if raw_decor.shape[:2] != (RAW_DECOR_SIZE[1], RAW_DECOR_SIZE[0]):
        raise ValueError(f"decor.png attendu {RAW_DECOR_SIZE}, reçu {(raw_decor.shape[1], raw_decor.shape[0])}")

    floor_full, floor_normalization = downsample_floor(floor_path)
    decor, masks, floor_px, walk_px, blocked, access, segmentation = make_art_layers(raw_decor)
    raw_floor = masks["sol"] | masks["ombres"]
    fidelity = reference_fidelity(decor, raw_floor)

    # Static layers share a single 96-color palette, no dithering.
    static_raw = {
        "00_sol_complet": rgba(floor_full, np.ones((H, W), dtype=bool)),
        "01_sol": rgba(decor, masks["sol"]),
        "02_ombres": rgba(decor, masks["ombres"]),
        "03_parois": rgba(decor, masks["parois"]),
        "04_rochers": rgba(decor, masks["blocs"]),
        "05_vegetation": rgba(decor, masks["vegetation"]),
        "06_profondeur": rgba(decor, masks["profondeur"]),
    }
    static, palette = quantize_layers(static_raw)
    dust = dust_frames(floor_px, palette)
    top = np.zeros((H, W, 4), dtype=np.uint8)

    # Save clean output directories without touching any prior map version.
    if OUT.exists():
        for sub in ("calques", "animation", "masques", "review"):
            shutil.rmtree(OUT / sub, ignore_errors=True)
    for sub in ("calques", "animation/poussiere", "masques", "review"):
        (OUT / sub).mkdir(parents=True, exist_ok=True)

    for name, array in static.items():
        save_png(OUT / "calques" / f"{PFX}_{name}.png", array)
    save_png(OUT / "calques" / f"{PFX}_08_top.png", top)
    for t, frame in enumerate(dust):
        save_png(OUT / "animation/poussiere" / f"{PFX}_07_poussiere_f{t:02d}.png", frame)
    for name, mask in masks.items():
        save_png(OUT / "masques" / f"{PFX}_masque_{name}.png", mask.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_praticable.png", walk_px.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_magenta_cavite.png", masks["profondeur"].astype(np.uint8) * 255)

    # Static layers are bottom-to-top; frame zero of the animation previews the phase-zero scene.
    stack = [(name, [arr], 60) for name, arr in static.items()]
    stack.append(("07_poussiere", dust, TICKS))
    stack.append(("08_top", [top], 60))
    scene0 = composite_stack(stack, 0)
    if not np.all(np.asarray(scene0)[..., 3] == 255):
        raise AssertionError("La scène composée n'est pas opaque partout")
    save_png(OUT / "review" / f"{PFX}_scene_t000.png", np.asarray(scene0))
    save_png(OUT / "review" / f"{PFX}_scene_x2.png",
             np.asarray(scene0.resize((W * 2, H * 2), Image.Resampling.NEAREST)))
    scenes = [composite_stack(stack, tick) for tick in range(0, LOOP_TICKS, TICKS)]
    webp_path = OUT / "review" / f"{PFX}_scene_animee.webp"
    scenes[0].save(webp_path, save_all=True, append_images=scenes[1:],
                   duration=round(TICKS * 1000 / 60), loop=0, lossless=True)

    # Overlay of the collision grid and the two editable 16x16 markers.
    collision_preview = scene0.copy()
    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for y, x in zip(*np.nonzero(blocked)):
        draw.rectangle((x * GRID, y * GRID, x * GRID + GRID - 1, y * GRID + GRID - 1),
                       fill=(225, 40, 45, 82))
    for point, color in ((access["entry_px"], (255, 235, 45, 255)),
                         (access["threshold_px"], (65, 220, 255, 255))):
        draw.rectangle((point[0], point[1], point[0] + 15, point[1] + 15), outline=color, width=2)
    collision_preview.alpha_composite(overlay)
    save_png(OUT / "review" / f"{PFX}_collisions_marqueurs.png", np.asarray(collision_preview))

    ora_stack = [(name.replace("_", " "), arr) for name, arr in static.items()]
    ora_stack += [("07 poussiere phase 00", dust[0]), ("08 Top vide", top)]
    write_ora(ORA, ora_stack)

    scene_arrays = [np.asarray(frame) for frame in dust]
    project_stack = [(name, [arr], 60) for name, arr in static.items()]
    project_stack.append(("07_poussiere", scene_arrays, TICKS))
    tile_counts = ground_project(project_stack, blocked, access)

    generation = json.loads((HERE / "generation.json").read_text(encoding="utf-8"))
    manifest = {
        "lot": "entree_canyon_cuivre_sud_nord_v1",
        "title": "Entrée du Canyon Cuivré",
        "prefix": PFX,
        "namespace": NAMESPACE,
        "asset": ASSET,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_px": GRID,
        "grid_cells": [GW, GH],
        "reference": generation["reference"],
        "reference_fidelity": fidelity,
        "generation": generation["images"],
        "inputs": [
            {"file": "source/entree_canyon_cuivre_sud_nord_v1/bruts/decor.png",
             "sha256": sha256(decor_path), "size_px": list(Image.open(decor_path).size)},
            {"file": "source/entree_canyon_cuivre_sud_nord_v1/bruts/sol_complet.png",
             "sha256": sha256(floor_path), "size_px": list(Image.open(floor_path).size)},
        ],
        "normalization": {"decor": {"source_px": list(RAW_DECOR_SIZE), "scale_xy": [1 / 3, 1 / 3],
                                      "method": "3x3 average by winning material class, no cross-class mixing"},
                          "sol_complet": floor_normalization,
                          "palette_colors": int(len(palette)), "dither": False},
        "magenta_key": segmentation["key"],
        "segmentation": segmentation,
        "layers": [
            {"name": name, "file": f"calques/{PFX}_{name}.png", "phases": 1,
             "frame_length_ticks": 60, "order": i}
            for i, name in enumerate(static)
        ] + [{"name": "07_poussiere", "file": f"animation/poussiere/{PFX}_07_poussiere_fNN.png",
              "phases": PHASES, "frame_length_ticks": TICKS, "order": 7},
             {"name": "08_top", "file": f"calques/{PFX}_08_top.png", "phases": 1,
              "frame_length_ticks": 60, "order": 8, "ground_layer": 4}],
        "animation": {"phases": PHASES, "frame_length_ticks": TICKS,
                      "loop_ticks": LOOP_TICKS, "loop_seconds_at_60hz": LOOP_TICKS / 60,
                      "origin": "animation originale de poussiere ; pas un cycle officiel recupere",
                      "emitters": [list(p) for p in DUST_BASES], "palette_rgb": [list(map(int, p)) for p in palette]},
        "access": access,
        "pmdo": {"target": "0.8.12.0", "version": "0.8.12.0", "tile_banks": tile_counts,
                 "runtime_tested": False, "warp": None},
        "art_approved": False,
        "runtime_tested": False,
        "notes": ["Generated artwork is a composition guide, not native source tiles.",
                  "The original D55P11A location is not inferred from its code prefix.",
                  "Marker donjon_seuil has no destination or warp."]
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    shutil.copyfile(OUT / "manifest.json", STAGE / "manifest.json")
    shutil.copyfile(HERE / "README_PACK.md", OUT / "README.md")
    shutil.copyfile(HERE / "preview.html", OUT / "review/index.html")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")

    summary = {"preview": str((OUT / "review" / f"{PFX}_scene_t000.png").relative_to(ROOT)),
               "layers": len(static) + 2, "dimensions": [W, H], "grid": [GW, GH],
               "entry_px": access["entry_px"], "threshold_px": access["threshold_px"],
               "reachable_16x16": access["path_found_16x16"], "tiles": sum(tile_counts.values()),
               "block_pixels": segmentation["rock_pixels_8px"], "reference_distance": None if fidelity is None else fidelity["distance"],
               "stage": str(STAGE.relative_to(ROOT))}
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return manifest


if __name__ == "__main__":
    build()
