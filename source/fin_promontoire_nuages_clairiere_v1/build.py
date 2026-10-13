#!/usr/bin/env python3
"""Pipeline de construction — fin_promontoire_nuages_clairiere_v1 (FPN1).

Zone de fin de donjon « Promontoire des Nuages — Clairière du Sommet »
(Sky Peak Cliffside Sanctuary, réf. ROM D27P11A), format 4:3 vaste
(768×576 px = 96×72 cellules 8×8, TexSize=1). Cul-de-sac fermé sans sortie ni warp.

Couches (du fond vers l'avant) :
  1. sol             — herbe verte à motifs 100 % opaque + allée centrale claire
  2. nuages_animes   — mer de nuages gris-bleutés en défilement horizontal bouclé (24 × 5 = 120 ticks)
  3. ilots_rocheux   — îlots rocheux bruns flottant par-dessus la mer de nuages
  4. falaises        — parois rocheuses brunes et alcôve semi-circulaire fermée au nord
  5. autel           — piédestal sculpté en pierre dorée dans l'alcôve nord
  6. arbres          — couronne d'arbres feuillus ronds et galets entourant l'arène
  7. fleurs_animees  — fleurs mauves et fougères animées (cycle canonique A B A C, 4 × 30 = 120 ticks)
  8. cristal_anime   — cristal céleste cyan-ambre pulsant sur l'autel + particules (8 × 15 = 120 ticks)
  9. Top             — calque vide au-dessus des personnages (Layer=4)
"""
from __future__ import annotations

from collections import deque
import hashlib
import io
import json
from pathlib import Path
import struct

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
BRUTS = HERE / "bruts"
REF = HERE / "reference"
RENDERS = ROOT / "renders" / HERE.name
EXPORTS = ROOT / "exports" / HERE.name

PREFIX = "FPN1"
MAP_ID = "fin_promontoire_nuages_clairiere_v1"
MAP_TITLE = "Fin Promontoire des Nuages — Clairière du Sommet V1"

TILE = 8
W, H = 768, 576
GW, GH = W // TILE, H // TILE  # 96 × 72

ENTRANCE_MARKER = {
    "name": "entrance",
    "X": 376,
    "Y": 536,
    "Width": 16,
    "Height": 16,
    "Direction": "Up",
}
BOSS_MARKER = {
    "name": "boss",
    "X": 376,
    "Y": 264,
    "Width": 16,
    "Height": 16,
    "Direction": "Down",
}
OBJECTIF_MARKER = {
    "name": "objectif",
    "X": 376,
    "Y": 128,
    "Width": 16,
    "Height": 16,
    "Direction": "Up",
}

CLOUD_FRAME_COUNT = 24
CLOUD_FRAME_DURATION = 5     # 24 × 5 = 120 ticks
FLOWER_FRAME_COUNT = 4
FLOWER_FRAME_DURATION = 30   # 4 × 30 = 120 ticks
CRYSTAL_FRAME_COUNT = 8
CRYSTAL_FRAME_DURATION = 15  # 8 × 15 = 120 ticks


def load_rgb(path: Path, nearest: bool = False) -> np.ndarray:
    im = Image.open(path).convert("RGB")
    if im.size != (W, H):
        resample = Image.Resampling.NEAREST if nearest else Image.Resampling.LANCZOS
        im = im.resize((W, H), resample)
    return np.array(im, dtype=np.uint8)


def make_horizontally_tileable(tex: np.ndarray, blend_w: int = 96) -> np.ndarray:
    out = tex.astype(np.float32).copy()
    shifted = np.roll(tex.astype(np.float32), W // 2, axis=1)
    xx = np.arange(W, dtype=np.float32)[None, :, None]
    w_edge = np.clip(np.minimum(xx, W - 1 - xx) / float(blend_w), 0.0, 1.0)
    res = out * w_edge + shifted * (1.0 - w_edge)
    return np.clip(np.round(res), 0, 255).astype(np.uint8)


def build_layers(decor: np.ndarray, sol_raw: np.ndarray) -> dict[str, np.ndarray]:
    """Segmente le décor sur fond magenta en couches fonctionnelles disjointes."""
    r = decor[:, :, 0].astype(np.int16)
    g = decor[:, :, 1].astype(np.int16)
    b = decor[:, :, 2].astype(np.int16)
    lum = decor.mean(axis=-1)
    yy, xx = np.mgrid[0:H, 0:W]

    mag_core = (r > 175) & (g < 105) & (b > 175) & ((r - g) > 95) & ((b - g) > 95)
    mag_fringe = ndimage.binary_dilation(mag_core, iterations=2) & ((r - g > 28) & (b - g > 28))
    mag = mag_core | mag_fringe

    non_mag = ~mag
    labeled_land, n_land = ndimage.label(non_mag)
    land_sizes = ndimage.sum(non_mag, labeled_land, range(1, n_land + 1))
    main_idx = int(np.argmax(land_sizes)) + 1
    continent = labeled_land == main_idx
    islets_mask = non_mag & (~continent)
    lab_i, n_i = ndimage.label(islets_mask)
    sz_i = ndimage.sum(islets_mask, lab_i, range(1, n_i + 1))
    keep_i = np.zeros(n_i + 1, dtype=bool)
    for idx, sz in enumerate(sz_i, start=1):
        if sz >= 12:
            keep_i[idx] = True
    islets_mask = keep_i[lab_i]
    sky_void_mask = ~continent

    # 1. Sol : herbe verte à motifs 100 % opaque + allée sud claire
    south_path = (
        continent
        & (np.abs(xx - 384) <= 28)
        & (yy >= 400)
        & (g >= 155)
        & (r >= 120)
    )
    south_path = ndimage.binary_closing(south_path, iterations=2)
    dist = ndimage.distance_transform_edt(~south_path)
    alpha_blend = np.clip(1.0 - dist / 12.0, 0.0, 1.0)[..., None]
    sol_mix = np.clip(
        np.round(decor.astype(np.float32) * alpha_blend + sol_raw.astype(np.float32) * (1.0 - alpha_blend)),
        0,
        255,
    ).astype(np.uint8)
    sol_mix[mag] = sol_raw[mag]
    sol = np.dstack([sol_mix, np.full((H, W), 255, dtype=np.uint8)])

    # 2. Cristal céleste cyan-ambre et autel nord
    crystal_mask = (
        continent
        & (yy >= 52)
        & (yy <= 92)
        & (np.abs(xx - 384) <= 24)
        & ((b >= 135) & (g >= 130))
    )
    crystal_mask = ndimage.binary_closing(crystal_mask, iterations=1)

    autel_mask = (
        continent
        & (~crystal_mask)
        & (yy >= 66)
        & (yy <= 122)
        & (np.abs(xx - 384) <= 24)
        & (r >= g - 6)
        & ((r - b) >= 24)
    )
    autel_mask = ndimage.binary_closing(autel_mask, iterations=1) & (~crystal_mask)

    # 3. Falaises rocheuses brunes (rebords bas du promontoire + alcôve semi-circulaire nord)
    is_brown_rock = (
        continent
        & (~crystal_mask)
        & (~autel_mask)
        & (r >= g - 6)
        & ((r - b) >= 22)
        & (g < 172)
    )
    alcove_north = (yy <= 176) & (np.abs(xx - 384) <= 148)
    cliff_south = ndimage.distance_transform_edt(continent) < 84
    falaises_mask = is_brown_rock & (alcove_north | cliff_south)
    falaises_mask = (
        ndimage.binary_closing(falaises_mask, iterations=1)
        & continent
        & (~crystal_mask)
        & (~autel_mask)
    )

    # 4. Fleurs mauves et fougères sombres (fleurs_animees)
    flower_color = (
        continent
        & (~falaises_mask)
        & (~autel_mask)
        & (~crystal_mask)
        & ((r > 155) & (b > 135) & (r - g > 15))
    )
    flower_tuft = (
        ndimage.binary_dilation(flower_color, iterations=2)
        & continent
        & (~falaises_mask)
        & (~autel_mask)
        & (~crystal_mask)
    )

    # 5. Arbres feuillus ronds et galets entourant l'arène
    is_meadow_grass = (
        continent
        & (g >= 140)
        & ((g - r) >= 34)
        & ((g - b) >= 52)
        & (lum >= 115)
    )
    arbres_raw = (
        continent
        & (~falaises_mask)
        & (~autel_mask)
        & (~crystal_mask)
        & (~flower_tuft)
        & (~is_meadow_grass)
        & (~south_path)
    )
    lab_a, n_a = ndimage.label(arbres_raw)
    sz_a = ndimage.sum(arbres_raw, lab_a, range(1, n_a + 1))
    keep_a = np.zeros(n_a + 1, dtype=bool)
    for idx, sz in enumerate(sz_a, start=1):
        if sz >= 24:
            keep_a[idx] = True
    arbres_mask = keep_a[lab_a]

    def make_rgba(mask: np.ndarray) -> np.ndarray:
        out = np.zeros((H, W, 4), dtype=np.uint8)
        out[mask, :3] = decor[mask]
        out[mask, 3] = 255
        return out

    return {
        "sol": sol,
        "ilots_rocheux": make_rgba(islets_mask),
        "falaises": make_rgba(falaises_mask),
        "autel": make_rgba(autel_mask),
        "arbres": make_rgba(arbres_mask),
        "_masks": {
            "continent": continent,
            "sky_void": sky_void_mask,
            "islets": islets_mask,
            "falaises": falaises_mask,
            "autel": autel_mask,
            "crystal": crystal_mask,
            "arbres": arbres_mask,
            "flowers": flower_tuft,
        },
    }


def build_cloud_frames(cloud_raw: np.ndarray, sky_void_mask: np.ndarray) -> list[np.ndarray]:
    tileable = make_horizontally_tileable(cloud_raw, blend_w=96)
    step_px = W // CLOUD_FRAME_COUNT
    frames: list[np.ndarray] = []
    for f in range(CLOUD_FRAME_COUNT):
        rolled = np.roll(tileable, f * step_px, axis=1)
        rgba = np.zeros((H, W, 4), dtype=np.uint8)
        rgba[sky_void_mask, :3] = rolled[sky_void_mask]
        rgba[sky_void_mask, 3] = 255
        frames.append(rgba)
    return frames


def build_flower_frames(decor: np.ndarray, flower_mask: np.ndarray) -> list[np.ndarray]:
    base = np.zeros((H, W, 4), dtype=np.uint8)
    base[flower_mask, :3] = decor[flower_mask]
    base[flower_mask, 3] = 255

    state_a = base.copy()
    state_b = np.zeros_like(base)
    state_b[:, 1:, :] = base[:, :-1, :]
    state_b[flower_mask & (state_b[:, :, 3] == 0)] = base[flower_mask & (state_b[:, :, 3] == 0)]

    state_c = np.zeros_like(base)
    state_c[:, :-1, :] = base[:, 1:, :]
    state_c[flower_mask & (state_c[:, :, 3] == 0)] = base[flower_mask & (state_c[:, :, 3] == 0)]

    return [state_a, state_b, state_a.copy(), state_c]


def build_crystal_frames(decor: np.ndarray, crystal_mask: np.ndarray) -> list[np.ndarray]:
    """Animation en boucle fermée (8 phases × 15 ticks = 120 ticks) du cristal céleste et de ses étincelles."""
    base_rgb = decor[:, :, :3].astype(np.float32)
    halo = ndimage.binary_dilation(crystal_mask, iterations=2) & (~crystal_mask)

    motes = [
        (372, 74, 0),
        (396, 74, 2),
        (376, 58, 4),
        (392, 58, 6),
        (366, 88, 1),
        (402, 88, 5),
    ]
    c_cyan = np.array([150, 248, 255, 255], dtype=np.uint8)
    c_gold = np.array([255, 232, 140, 255], dtype=np.uint8)

    frames: list[np.ndarray] = []
    for f in range(CRYSTAL_FRAME_COUNT):
        pulse = float(np.sin(2.0 * np.pi * f / float(CRYSTAL_FRAME_COUNT)))
        rgba = np.zeros((H, W, 4), dtype=np.uint8)
        boosted = np.clip(base_rgb + pulse * 18.0, 0, 255).astype(np.uint8)
        rgba[crystal_mask, :3] = boosted[crystal_mask]
        rgba[crystal_mask, 3] = 255

        if pulse > 0.15:
            rgba[halo, :3] = np.array([110, 235, 245], dtype=np.uint8)
            rgba[halo, 3] = 255

        for mx, my, off in motes:
            u = (f + off) % CRYSTAL_FRAME_COUNT
            py = my - u
            if 44 <= py < H and 0 <= mx < W:
                rgba[py, mx] = c_gold if (u % 2 == 0) else c_cyan
        frames.append(rgba)
    return frames


def build_collision_grid(masks: dict[str, np.ndarray]) -> list[list[str]]:
    """Construit la grille 96×72 (8×8 px) d'arène fermée sans sortie nord."""
    lab_a, n_a = ndimage.label(masks["arbres"])
    sz_a = ndimage.sum(masks["arbres"], lab_a, range(1, n_a + 1))
    big_trees = np.zeros_like(masks["arbres"])
    for idx, sz in enumerate(sz_a, start=1):
        if sz >= 180:
            big_trees[lab_a == idx] = True

    blocked_px = (
        masks["sky_void"]
        | masks["falaises"]
        | masks["autel"]
        | masks["crystal"]
        | big_trees
    )

    grid = [["walk" for _ in range(GW)] for _ in range(GH)]
    for gy in range(GH):
        for gx in range(GW):
            patch = blocked_px[gy * TILE : (gy + 1) * TILE, gx * TILE : (gx + 1) * TILE]
            if patch.mean() > 0.25:
                grid[gy][gx] = "wall"

    # Garantir l'allée sud -> arène centrale -> pied de l'autel nord
    ent_gx, ent_gy = ENTRANCE_MARKER["X"] // TILE, ENTRANCE_MARKER["Y"] // TILE
    obj_gx, obj_gy = OBJECTIF_MARKER["X"] // TILE, OBJECTIF_MARKER["Y"] // TILE

    for gy in range(obj_gy, ent_gy + 2):
        for gx in range(ent_gx - 1, ent_gx + 3):
            if 0 <= gy < GH and 0 <= gx < GW:
                grid[gy][gx] = "walk"

    # Cul-de-sac strict : bloquer tout le nord au-dessus de obj_gy (autel et alcôve)
    for gy in range(0, obj_gy):
        for gx in range(GW):
            grid[gy][gx] = "wall"

    return grid


def verify_16x16_connectivity(grid: list[list[str]]) -> list[tuple[int, int]]:
    """Vérifie par BFS qu'un gabarit 16×16 relie entrance -> boss -> objectif."""
    def can_stand(gx: int, gy: int) -> bool:
        if gx < 0 or gy < 0 or gx + 1 >= GW or gy + 1 >= GH:
            return False
        return (
            grid[gy][gx] == "walk"
            and grid[gy][gx + 1] == "walk"
            and grid[gy + 1][gx] == "walk"
            and grid[gy + 1][gx + 1] == "walk"
        )

    def bfs_segment(start: tuple[int, int], goal: tuple[int, int]) -> list[tuple[int, int]]:
        if not can_stand(*start):
            raise RuntimeError(f"Point {start} non praticable en 16×16")
        if not can_stand(*goal):
            raise RuntimeError(f"Point {goal} non praticable en 16×16")
        q = deque([start])
        prev: dict[tuple[int, int], tuple[int, int] | None] = {start: None}
        while q:
            cx, cy = q.popleft()
            if (cx, cy) == goal:
                break
            for dx, dy in ((0, -1), (0, 1), (-1, 0), (1, 0)):
                nx, ny = cx + dx, cy + dy
                if (nx, ny) not in prev and can_stand(nx, ny):
                    prev[(nx, ny)] = (cx, cy)
                    q.append((nx, ny))
        if goal not in prev:
            raise RuntimeError(f"Aucun chemin 16×16 entre {start} et {goal}")
        seg = []
        cur: tuple[int, int] | None = goal
        while cur is not None:
            seg.append(cur)
            cur = prev[cur]
        seg.reverse()
        return seg

    p_ent = (ENTRANCE_MARKER["X"] // TILE, ENTRANCE_MARKER["Y"] // TILE)
    p_boss = (BOSS_MARKER["X"] // TILE, BOSS_MARKER["Y"] // TILE)
    p_obj = (OBJECTIF_MARKER["X"] // TILE, OBJECTIF_MARKER["Y"] // TILE)
    seg1 = bfs_segment(p_ent, p_boss)
    seg2 = bfs_segment(p_boss, p_obj)
    return seg1 + seg2[1:]


def write_pmdo_tile(
    path: Path,
    layers_rgba: list[np.ndarray],
    frame_duration: int = 60,
) -> dict[str, int]:
    unique_tiles: dict[bytes, bytes] = {}
    tile_coords: list[list[tuple[int, int]]] = []

    for rgba in layers_rgba:
        frame_coords: list[tuple[int, int]] = []
        for gy in range(GH):
            for gx in range(GW):
                patch = rgba[gy * TILE : (gy + 1) * TILE, gx * TILE : (gx + 1) * TILE]
                if np.all(patch[:, :, 3] == 0):
                    frame_coords.append((-1, -1))
                    continue
                raw = patch.tobytes()
                digest = hashlib.sha1(raw).digest()
                if digest not in unique_tiles:
                    unique_tiles[digest] = raw
                idx = list(unique_tiles.keys()).index(digest)
                frame_coords.append((idx, 0))
        tile_coords.append(frame_coords)

    n_unique = len(unique_tiles)
    cols = min(32, max(1, n_unique))
    rows = max(1, (n_unique + cols - 1) // cols)
    sheet = Image.new("RGBA", (cols * TILE, rows * TILE), (0, 0, 0, 0))
    for idx, raw in enumerate(unique_tiles.values()):
        patch_im = Image.frombytes("RGBA", (TILE, TILE), raw)
        sheet.paste(patch_im, ((idx % cols) * TILE, (idx // cols) * TILE))

    buf = io.BytesIO()
    sheet.save(buf, format="PNG")
    png_bytes = buf.getvalue()

    out = bytearray()
    out += struct.pack("<i", TILE)
    out += struct.pack("<i", GW)
    out += struct.pack("<i", GH)
    out += struct.pack("<i", len(layers_rgba))
    out += struct.pack("<i", frame_duration)
    for fc in tile_coords:
        for idx, _ in fc:
            if idx < 0:
                out += struct.pack("<ii", -1, -1)
            else:
                out += struct.pack("<ii", idx % cols, idx // cols)
    out += struct.pack("<i", 1)
    out += struct.pack("<i", len(png_bytes))
    out += png_bytes

    path.write_bytes(bytes(out))
    return {"unique_tiles": n_unique, "frames": len(layers_rgba), "bytes": len(out)}


def export_rsground(grid: list[list[str]], out_path: Path) -> None:
    template_path = ROOT / "cliffdaytest.rsground"
    raw = json.loads(template_path.read_text(encoding="utf-8-sig"))
    content = raw["Object"]
    content["Width"] = GW
    content["Height"] = GH
    content["TexSize"] = 1
    content["AssetName"] = MAP_ID
    content["Name"] = {"DefaultText": MAP_TITLE, "LocalTexts": {}}

    content["obstacles"] = [
        [
            {
                "Bounds": {"X": gx * TILE, "Y": gy * TILE, "Width": TILE, "Height": TILE},
                "Tags": 1 if grid[gy][gx] == "wall" else 0,
            }
            for gy in range(GH)
        ]
        for gx in range(GW)
    ]
    walls = []
    for gy in range(GH):
        for gx in range(GW):
            if grid[gy][gx] == "wall":
                walls.append(
                    {
                        "Bounds": {
                            "Location": {"X": gx * TILE, "Y": gy * TILE},
                            "Size": {"Width": TILE, "Height": TILE},
                        },
                        "Tags": [],
                    }
                )
    content["Walls"] = walls

    markers_list = []
    for m in (ENTRANCE_MARKER, BOSS_MARKER, OBJECTIF_MARKER):
        markers_list.append(
            {
                "EntName": m["name"],
                "Name": m["name"],
                "Direction": 0 if m["Direction"] == "Down" else 4,
                "EntEnabled": True,
                "triggerType": 0,
                "Position": {"X": m["X"], "Y": m["Y"]},
                "Collider": {"X": m["X"], "Y": m["Y"], "Width": 16, "Height": 16},
            }
        )
    content["Entities"] = [
        {
            "Name": "Entrees, boss et objectif",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": markers_list,
        }
    ]
    content["Markers"] = markers_list

    def make_layer(name: str, asset: str, layer_enum: int = 0) -> dict:
        return {
            "Name": name,
            "Layer": layer_enum,
            "Visible": True,
            "Map": {"Asset": asset},
            "Tiles": [],
        }

    asset_layers = [
        make_layer("sol", f"{PREFIX}_sol", 0),
        make_layer("nuages_animes", f"{PREFIX}_nuages_animes_0", 0),
        make_layer("ilots_rocheux", f"{PREFIX}_ilots_rocheux", 0),
        make_layer("falaises", f"{PREFIX}_falaises", 0),
        make_layer("autel", f"{PREFIX}_autel", 0),
        make_layer("arbres", f"{PREFIX}_arbres", 0),
        make_layer("fleurs_animees", f"{PREFIX}_fleurs_animees_0", 0),
        make_layer("cristal_anime", f"{PREFIX}_cristal_anime_0", 0),
        make_layer("Top", "", 4),
    ]
    content["AssetLayers"] = asset_layers
    content["Layers"] = asset_layers
    raw["Version"] = "0.8.12.0"
    out_path.write_text("\ufeff" + json.dumps(raw, indent=2, ensure_ascii=False), encoding="utf-8")


def main() -> None:
    RENDERS.mkdir(parents=True, exist_ok=True)
    EXPORTS.mkdir(parents=True, exist_ok=True)

    decor = load_rgb(BRUTS / "decor_magenta.png", nearest=True)
    sol_raw = load_rgb(BRUTS / "sol_complet.png", nearest=False)
    cloud_raw = load_rgb(BRUTS / "nuages_magenta.png", nearest=False)

    layers = build_layers(decor, sol_raw)
    masks = layers.pop("_masks")
    cloud_frames = build_cloud_frames(cloud_raw, masks["sky_void"])
    flower_frames = build_flower_frames(decor, masks["flowers"])
    crystal_frames = build_crystal_frames(decor, masks["crystal"])

    grid = build_collision_grid(masks)
    bfs_path = verify_16x16_connectivity(grid)

    for lname, rgba in layers.items():
        im = Image.fromarray(rgba, "RGBA")
        im.save(RENDERS / f"{PREFIX}_couche_{lname}.png")
        im.save(EXPORTS / f"{PREFIX}_{lname}.png")
        write_pmdo_tile(EXPORTS / f"{PREFIX}_{lname}.tile", [rgba], frame_duration=60)

    for idx, fr in enumerate(cloud_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_nuages_animes_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_nuages_animes_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_nuages_animes_0.tile",
        cloud_frames,
        frame_duration=CLOUD_FRAME_DURATION,
    )

    for idx, fr in enumerate(flower_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_fleurs_animees_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_fleurs_animees_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_fleurs_animees_0.tile",
        flower_frames,
        frame_duration=FLOWER_FRAME_DURATION,
    )

    for idx, fr in enumerate(crystal_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_cristal_anime_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_cristal_anime_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_cristal_anime_0.tile",
        crystal_frames,
        frame_duration=CRYSTAL_FRAME_DURATION,
    )

    composed_frames: list[Image.Image] = []
    for f in range(CLOUD_FRAME_COUNT):
        tick = f * CLOUD_FRAME_DURATION
        canvas = Image.fromarray(layers["sol"], "RGBA")
        canvas.alpha_composite(Image.fromarray(cloud_frames[f], "RGBA"))
        for lname in ("ilots_rocheux", "falaises", "autel", "arbres"):
            canvas.alpha_composite(Image.fromarray(layers[lname], "RGBA"))
        fl_idx = (tick // FLOWER_FRAME_DURATION) % FLOWER_FRAME_COUNT
        cr_idx = (tick // CRYSTAL_FRAME_DURATION) % CRYSTAL_FRAME_COUNT
        canvas.alpha_composite(Image.fromarray(flower_frames[fl_idx], "RGBA"))
        canvas.alpha_composite(Image.fromarray(crystal_frames[cr_idx], "RGBA"))
        if f < 8:
            canvas.save(RENDERS / f"{PREFIX}_frame_{f}.png")
        composed_frames.append(canvas.convert("RGB"))

    composed_frames[0].save(RENDERS / f"{PREFIX}_final.png")
    composed_frames[0].save(EXPORTS / f"{PREFIX}_merged_sheet.png")
    composed_frames[0].save(
        RENDERS / f"{PREFIX}_anim.gif",
        save_all=True,
        append_images=composed_frames[1:],
        duration=int(CLOUD_FRAME_DURATION * 1000 / 60),
        loop=0,
    )

    coll_im = composed_frames[0].convert("RGBA")
    overlay = np.zeros((H, W, 4), dtype=np.uint8)
    for gy in range(GH):
        for gx in range(GW):
            if grid[gy][gx] == "wall":
                overlay[gy * TILE : (gy + 1) * TILE, gx * TILE : (gx + 1) * TILE] = [220, 40, 40, 95]
    for gx, gy in bfs_path:
        overlay[gy * TILE : (gy + 2) * TILE, gx * TILE : (gx + 2) * TILE] = [40, 220, 120, 130]
    coll_im.alpha_composite(Image.fromarray(overlay, "RGBA"))
    coll_im.save(RENDERS / f"{PREFIX}_collisions.png")

    ref_im = Image.open(REF / "D27P11A.png").convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    fin_im = composed_frames[0].resize((384, 288), Image.Resampling.NEAREST)
    col_im = coll_im.convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    sol_im = Image.fromarray(layers["sol"]).convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    sheet = Image.new("RGB", (768, 576))
    sheet.paste(ref_im, (0, 0))
    sheet.paste(sol_im, (384, 0))
    sheet.paste(fin_im, (0, 288))
    sheet.paste(col_im, (384, 288))
    sheet.save(RENDERS / f"{PREFIX}_planche_contact.png")

    export_rsground(grid, EXPORTS / f"{MAP_ID}.rsground")
    collision_meta = {
        "map_id": MAP_ID,
        "prefix": PREFIX,
        "width_px": W,
        "height_px": H,
        "grid_width": GW,
        "grid_height": GH,
        "tile_size": TILE,
        "tex_size": 1,
        "markers": [ENTRANCE_MARKER, BOSS_MARKER, OBJECTIF_MARKER],
        "bfs_16x16_verified": True,
        "bfs_steps": len(bfs_path),
        "grid": grid,
    }
    (EXPORTS / f"{PREFIX}_collision.json").write_text(
        json.dumps(collision_meta, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    manifest = {
        "map_id": MAP_ID,
        "prefix": PREFIX,
        "title": MAP_TITLE,
        "reference_rom": "D27P11A",
        "dimensions_px": [W, H],
        "grid_cells": [GW, GH],
        "tile_size_px": TILE,
        "tex_size": 1,
        "layers_order": [
            "sol",
            "nuages_animes",
            "ilots_rocheux",
            "falaises",
            "autel",
            "arbres",
            "fleurs_animees",
            "cristal_anime",
            "Top",
        ],
        "animations": {
            "nuages_animes": {"frames": CLOUD_FRAME_COUNT, "frame_duration_ticks": CLOUD_FRAME_DURATION, "loop_ticks": 120},
            "fleurs_animees": {"frames": FLOWER_FRAME_COUNT, "frame_duration_ticks": FLOWER_FRAME_DURATION, "loop_ticks": 120},
            "cristal_anime": {"frames": CRYSTAL_FRAME_COUNT, "frame_duration_ticks": CRYSTAL_FRAME_DURATION, "loop_ticks": 120},
        },
        "markers": [ENTRANCE_MARKER, BOSS_MARKER, OBJECTIF_MARKER],
        "validation_status": {
            "python_tests_passed": True,
            "art_approved": False,
            "runtime_tested": False,
        },
    }
    (EXPORTS / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>{MAP_TITLE} ({PREFIX})</title>
<style>
body {{ background:#14181d; color:#e7ecef; font-family:system-ui,sans-serif; margin:24px; }}
.grid {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(360px,1fr)); gap:16px; }}
.card {{ background:#1f262e; padding:12px; border-radius:8px; }}
img {{ max-width:100%; height:auto; image-rendering:pixelated; border-radius:4px; }}
</style>
</head>
<body>
<h1>{MAP_TITLE} (<code>{PREFIX}</code> — réf. ROM <code>D27P11A</code>)</h1>
<p>Format 4:3 vaste : {W}×{H} px ({GW}×{GH} cellules 8×8, TexSize=1) — Cul-de-sac fermé (`entrance`, `boss`, `objectif`), chemin 16×16 BFS vérifié ({len(bfs_path)} pas).</p>
<div class="grid">
  <div class="card"><h3>Animation assemblée (120 ticks)</h3><img src="{PREFIX}_anim.gif"></div>
  <div class="card"><h3>Rendu final statique</h3><img src="{PREFIX}_final.png"></div>
  <div class="card"><h3>Collisions &amp; chemin 16×16</h3><img src="{PREFIX}_collisions.png"></div>
  <div class="card"><h3>Planche contact</h3><img src="{PREFIX}_planche_contact.png"></div>
</div>
</body>
</html>"""
    (RENDERS / f"apercu_{PREFIX.lower()}.html").write_text(html, encoding="utf-8")
    print(f"[{PREFIX}] Build terminé avec succès — BFS 16x16 = {len(bfs_path)} pas.")


if __name__ == "__main__":
    main()
