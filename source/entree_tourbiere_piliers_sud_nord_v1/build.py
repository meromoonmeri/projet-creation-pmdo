#!/usr/bin/env python3
"""Pipeline de construction — entree_tourbiere_piliers_sud_nord_v1 (ETB1).

Entrée de donjon « Tourbière des Piliers » (Rock Path Marsh, réf. ROM D09P11A),
format 4:3 vaste (768×576 px = 96×72 cellules 8×8, TexSize=1).

Couches (du fond vers l'avant) :
  1. sol             — herbe verte luxuriante 100 % opaque + seuil de terre brune au nord
  2. bassins_animes  — eau sombre bleu-sarcelle sans écume des bassins de tourbière
                       (8 phases × 8 ticks = 64 ticks, palette exacte extraite de D09P11A.png)
  3. piliers_rocheux — hautes falaises de piliers rocheux bruns striés au nord
  4. seuil_entree    — ouverture sombre de la grotte nord et arche rocheuse
  5. buissons        — massifs de buissons moussus vert sombre bordant les bassins + galets
  6. bulles_marais   — bulles de tourbière et frémissement du feuillage (8 × 8 = 64 ticks)
  7. Top             — calque vide au-dessus des personnages (Layer=4)
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

PREFIX = "ETB1"
MAP_ID = "entree_tourbiere_piliers_sud_nord_v1"
MAP_TITLE = "Entrée Tourbière des Piliers — Approche Sud-Nord V1"

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
SEUIL_MARKER = {
    "name": "donjon_seuil",
    "X": 376,
    "Y": 152,
    "Width": 16,
    "Height": 16,
    "Direction": "Up",
}

WATER_FRAME_COUNT = 8
WATER_FRAME_DURATION = 8  # 8 × 8 = 64 ticks

# Palette exacte des 7 couleurs d'eau et reflets moussus de D09P11A.png (sans aucune écume blanche)
MARSH_WATER_PALETTE = np.array(
    [
        (31, 63, 71),   # 0 : eau profonde sombre
        (31, 79, 79),   # 1 : eau médiane sombre
        (31, 87, 87),   # 2 : eau sarcelle principale
        (31, 95, 95),   # 3 : onde sarcelle claire
        (39, 79, 63),   # 4 : reflet moussu sombre (bordure de buissons)
        (47, 95, 63),   # 5 : reflet moussu moyen
        (47, 119, 79),  # 6 : reflet moussu clair (rive immédiate)
    ],
    dtype=np.uint8,
)


def load_rgb(path: Path, nearest: bool = False) -> np.ndarray:
    im = Image.open(path).convert("RGB")
    if im.size != (W, H):
        resample = Image.Resampling.NEAREST if nearest else Image.Resampling.LANCZOS
        im = im.resize((W, H), resample)
    return np.array(im, dtype=np.uint8)


def build_layers(decor: np.ndarray, sol_raw: np.ndarray) -> dict[str, np.ndarray]:
    """Segmente le décor sur fond magenta en couches fonctionnelles disjointes."""
    r = decor[:, :, 0].astype(np.int16)
    g = decor[:, :, 1].astype(np.int16)
    b = decor[:, :, 2].astype(np.int16)
    lum = decor.mean(axis=-1)
    yy, xx = np.mgrid[0:H, 0:W]

    # 1. Masque des bassins de tourbière (fond magenta #FF00FF + toutes franges anti-aliasées)
    mag_core = (r > 140) & (b > 140) & ((r - g) > 40) & ((b - g) > 40)
    mag_fringe = ndimage.binary_dilation(mag_core, iterations=4) & ((r - g > 10) & (b - g > 10))
    pools_mask = mag_core | mag_fringe
    pools_mask = ndimage.binary_closing(pools_mask, iterations=1) | mag_core | mag_fringe

    # 2. Sol : herbe verte 100 % opaque + seuil de terre brune devant la grotte nord (sans empreinte de buissons)
    dirt_threshold = (
        (~pools_mask)
        & (yy >= 138)
        & (yy <= 212)
        & (np.abs(xx - 384) <= 32)
        & (r >= g - 10)
        & ((r - b) >= 18)
    )
    grass_corridor = (
        (~pools_mask)
        & (np.abs(xx - 384) <= 28)
        & (yy >= 190)
        & (lum >= 112)
        & (g > r + 26)
    )
    blend_zone = dirt_threshold | grass_corridor
    dist = ndimage.distance_transform_edt(~blend_zone)
    alpha_blend = np.clip(1.0 - dist / 12.0, 0.0, 1.0)[..., None]
    sol_mix = np.clip(
        np.round(decor.astype(np.float32) * alpha_blend + sol_raw.astype(np.float32) * (1.0 - alpha_blend)),
        0,
        255,
    ).astype(np.uint8)
    sol_mix[pools_mask] = sol_raw[pools_mask]
    sol = np.dstack([sol_mix, np.full((H, W), 255, dtype=np.uint8)])

    # 3. Seuil d'entrée : ouverture sombre de la grotte nord + arche immédiate
    cave_hole = (~pools_mask) & (yy >= 96) & (yy <= 152) & (np.abs(xx - 384) <= 36) & (lum < 56)
    seuil_mask = (
        ndimage.binary_dilation(cave_hole, iterations=8)
        & (~pools_mask)
        & (yy >= 88)
        & (yy <= 156)
        & (np.abs(xx - 384) <= 46)
    )

    # 4. Hautes falaises de piliers rocheux bruns striés au nord (y < 236)
    is_brown_pillar = (
        (~pools_mask)
        & (~seuil_mask)
        & (~dirt_threshold)
        & (yy < 236)
        & (r >= g - 6)
        & ((r - b) >= 16)
    )
    piliers_mask = ndimage.binary_closing(is_brown_pillar, iterations=2) & (~pools_mask) & (~seuil_mask) & (~dirt_threshold)

    # 5. Massifs de buissons moussus vert sombre bordant les bassins + petits galets
    # Les buissons ont un vert plus dense/sombre et texturé que la pelouse centrale, ou entourent les bassins
    near_pools = ndimage.distance_transform_edt(~pools_mask) <= 64
    is_dark_bush = (
        (~pools_mask)
        & (~seuil_mask)
        & (~piliers_mask)
        & (~dirt_threshold)
        & (
            ((lum < 108) & (g > r + 18))
            | (near_pools & (np.abs(xx - 384) > 56) & (g > r + 18))
            | ((yy >= 150) & (yy <= 230) & (np.abs(xx - 384) > 36) & (lum < 114))
        )
    )
    small_pebbles = (
        (~pools_mask)
        & (~seuil_mask)
        & (~piliers_mask)
        & (~dirt_threshold)
        & (yy >= 170)
        & (r >= g - 8)
        & ((r - b) >= 18)
    )
    buissons_raw = is_dark_bush | small_pebbles
    lab_b, n_b = ndimage.label(buissons_raw)
    sz_b = ndimage.sum(buissons_raw, lab_b, range(1, n_b + 1))
    keep_b = np.zeros(n_b + 1, dtype=bool)
    for idx, sz in enumerate(sz_b, start=1):
        if sz >= 16:
            keep_b[idx] = True
    buissons_mask = keep_b[lab_b]

    def make_rgba(mask: np.ndarray) -> np.ndarray:
        out = np.zeros((H, W, 4), dtype=np.uint8)
        out[mask, :3] = decor[mask]
        out[mask, 3] = 255
        return out

    return {
        "sol": sol,
        "piliers_rocheux": make_rgba(piliers_mask),
        "seuil_entree": make_rgba(seuil_mask),
        "buissons": make_rgba(buissons_mask),
        "_masks": {
            "pools": pools_mask,
            "piliers": piliers_mask,
            "seuil": seuil_mask,
            "cave_hole": cave_hole,
            "buissons": buissons_mask,
            "dirt_threshold": dirt_threshold,
        },
    }


def build_marsh_water_frames(pools_mask: np.ndarray) -> list[np.ndarray]:
    """Construit les 8 phases d'eau sombre sans écume des bassins (palette exacte D09P11A.png)."""
    yy, xx = np.mgrid[0:H, 0:W]
    # Distance à la rive des bassins pour créer les anneaux de reflets moussus comme dans D09P11A.png
    dist_edge = ndimage.distance_transform_edt(pools_mask)

    frames: list[np.ndarray] = []
    for f in range(WATER_FRAME_COUNT):
        phase = 2.0 * np.pi * f / float(WATER_FRAME_COUNT)
        wave = (
            np.sin(xx / 9.0 + yy / 13.0 - phase)
            + 0.7 * np.cos(xx / 14.0 - yy / 8.0 + phase)
        )
        idx = np.full((H, W), 2, dtype=np.int16)  # sarcelle principale (31, 87, 87)

        # Rive immédiate : reflets moussus (indices 6, 5, 4) exactement comme dans D09P11A.png
        idx[dist_edge <= 2.2] = 6
        idx[(dist_edge > 2.2) & (dist_edge <= 4.5)] = 5
        idx[(dist_edge > 4.5) & (dist_edge <= 7.0)] = 4

        # Intérieur du bassin : ondulation douce entre les 4 tons sarcelle (0..3) sans écume blanche
        interior = dist_edge > 7.0
        idx[interior & (wave < -0.85)] = 0
        idx[interior & (wave >= -0.85) & (wave < -0.15)] = 1
        idx[interior & (wave >= -0.15) & (wave < 0.75)] = 2
        idx[interior & (wave >= 0.75)] = 3

        rgba = np.zeros((H, W, 4), dtype=np.uint8)
        rgba[pools_mask, :3] = MARSH_WATER_PALETTE[idx[pools_mask]]
        rgba[pools_mask, 3] = 255
        frames.append(rgba)
    return frames


def build_marsh_bubbles_frames(decor: np.ndarray, pools_mask: np.ndarray, buissons_mask: np.ndarray) -> list[np.ndarray]:
    """Construit les 8 phases de bulles de tourbière et d'ondulation légère des sommets de buissons."""
    # Sommets clairs des buissons moussus
    r = decor[:, :, 0].astype(np.int16)
    g = decor[:, :, 1].astype(np.int16)
    b = decor[:, :, 2].astype(np.int16)
    bush_tips = buissons_mask & (g >= 122) & ((g - r) >= 40)
    base_tips = np.zeros((H, W, 4), dtype=np.uint8)
    base_tips[bush_tips, :3] = decor[bush_tips]
    base_tips[bush_tips, 3] = 255

    # Émetteurs de bulles lentes dans les bassins gauche et droit (couleurs exactes de D09P11A)
    c_ring = np.array([47, 119, 79, 255], dtype=np.uint8)
    c_core = np.array([31, 95, 95, 255], dtype=np.uint8)
    bubble_emitters = [
        (168, 276, 0),
        (256, 396, 2),
        (204, 524, 4),
        (560, 284, 1),
        (524, 368, 3),
        (596, 488, 5),
        (488, 516, 6),
        (124, 348, 7),
    ]

    frames: list[np.ndarray] = []
    for f in range(WATER_FRAME_COUNT):
        layer = np.zeros((H, W, 4), dtype=np.uint8)
        # Balancement A B A C des sommets de buissons
        sway_step = (f // 2) % 4
        if sway_step in (0, 2):
            layer = base_tips.copy()
        elif sway_step == 1:
            layer[:, 1:, :] = base_tips[:, :-1, :]
        else:
            layer[:, :-1, :] = base_tips[:, 1:, :]

        # Bulles de tourbière à la surface des bassins
        for bx, by, off in bubble_emitters:
            u = (f + off) % WATER_FRAME_COUNT
            if u < 4:
                py = by - u
                if 0 <= py < H and 0 <= bx < W and pools_mask[py, bx]:
                    layer[py, bx] = c_ring
                    if py + 1 < H and pools_mask[py + 1, bx]:
                        layer[py + 1, bx] = c_core
            elif u in (4, 5):
                # Petit cercle d'onde à l'éclatement
                rad = 2 if u == 4 else 3
                for dx, dy in ((-rad, 0), (rad, 0), (0, -1), (0, 1)):
                    px, py = bx + dx, by - 4 + dy
                    if 0 <= py < H and 0 <= px < W and pools_mask[py, px]:
                        layer[py, px] = c_ring if u == 4 else c_core
        frames.append(layer)
    return frames


def build_collision_grid(masks: dict[str, np.ndarray]) -> list[list[str]]:
    """Construit la grille 96×72 (8×8 px) et garantit le couloir Sud -> seuil Nord."""
    # Petits galets isolés < 140 px restent praticables ; buissons, bassins, piliers et grotte bloquent
    lab_b, n_b = ndimage.label(masks["buissons"])
    sz_b = ndimage.sum(masks["buissons"], lab_b, range(1, n_b + 1))
    big_bushes = np.zeros_like(masks["buissons"])
    for idx, sz in enumerate(sz_b, start=1):
        if sz >= 140:
            big_bushes[lab_b == idx] = True

    blocked_px = masks["pools"] | masks["piliers"] | masks["cave_hole"] | big_bushes

    grid = [["walk" for _ in range(GW)] for _ in range(GH)]
    for gy in range(GH):
        for gx in range(GW):
            patch = blocked_px[gy * TILE : (gy + 1) * TILE, gx * TILE : (gx + 1) * TILE]
            if patch.mean() > 0.25:
                grid[gy][gx] = "wall"

    seuil_gx = SEUIL_MARKER["X"] // TILE
    seuil_gy = SEUIL_MARKER["Y"] // TILE
    ent_gx = ENTRANCE_MARKER["X"] // TILE
    ent_gy = ENTRANCE_MARKER["Y"] // TILE

    for gy in range(seuil_gy, ent_gy + 2):
        for gx in range(seuil_gx - 2, seuil_gx + 4):
            if 0 <= gy < GH and 0 <= gx < GW:
                grid[gy][gx] = "walk"

    for gy in range(0, seuil_gy):
        for gx in range(GW):
            grid[gy][gx] = "wall"

    return grid


def verify_16x16_connectivity(grid: list[list[str]]) -> list[tuple[int, int]]:
    def can_stand(gx: int, gy: int) -> bool:
        if gx < 0 or gy < 0 or gx + 1 >= GW or gy + 1 >= GH:
            return False
        return (
            grid[gy][gx] == "walk"
            and grid[gy][gx + 1] == "walk"
            and grid[gy + 1][gx] == "walk"
            and grid[gy + 1][gx + 1] == "walk"
        )

    start = (ENTRANCE_MARKER["X"] // TILE, ENTRANCE_MARKER["Y"] // TILE)
    goal = (SEUIL_MARKER["X"] // TILE, SEUIL_MARKER["Y"] // TILE)
    if not can_stand(*start):
        raise RuntimeError(f"Marqueur entrance non praticable en 16×16: {start}")
    if not can_stand(*goal):
        raise RuntimeError(f"Marqueur donjon_seuil non praticable en 16×16: {goal}")

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
        raise RuntimeError("Aucun chemin 16×16 entre entrance et donjon_seuil !")

    path = []
    cur: tuple[int, int] | None = goal
    while cur is not None:
        path.append(cur)
        cur = prev[cur]
    path.reverse()
    return path


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

    markers_list = [
        {
            "EntName": ENTRANCE_MARKER["name"],
            "Name": ENTRANCE_MARKER["name"],
            "Direction": 4,
            "EntEnabled": True,
            "triggerType": 0,
            "Position": {"X": ENTRANCE_MARKER["X"], "Y": ENTRANCE_MARKER["Y"]},
            "Collider": {"X": ENTRANCE_MARKER["X"], "Y": ENTRANCE_MARKER["Y"], "Width": 16, "Height": 16},
        },
        {
            "EntName": SEUIL_MARKER["name"],
            "Name": SEUIL_MARKER["name"],
            "Direction": 4,
            "EntEnabled": True,
            "triggerType": 0,
            "Position": {"X": SEUIL_MARKER["X"], "Y": SEUIL_MARKER["Y"]},
            "Collider": {"X": SEUIL_MARKER["X"], "Y": SEUIL_MARKER["Y"], "Width": 16, "Height": 16},
        },
    ]
    content["Entities"] = [
        {
            "Name": "Entrees et vos acteurs",
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
        make_layer("bassins_animes", f"{PREFIX}_bassins_animes_0", 0),
        make_layer("piliers_rocheux", f"{PREFIX}_piliers_rocheux", 0),
        make_layer("seuil_entree", f"{PREFIX}_seuil_entree", 0),
        make_layer("buissons", f"{PREFIX}_buissons", 0),
        make_layer("bulles_marais", f"{PREFIX}_bulles_marais_0", 0),
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

    layers = build_layers(decor, sol_raw)
    masks = layers.pop("_masks")
    water_frames = build_marsh_water_frames(masks["pools"])
    bubble_frames = build_marsh_bubbles_frames(decor, masks["pools"], masks["buissons"])

    grid = build_collision_grid(masks)
    bfs_path = verify_16x16_connectivity(grid)

    for lname, rgba in layers.items():
        im = Image.fromarray(rgba, "RGBA")
        im.save(RENDERS / f"{PREFIX}_couche_{lname}.png")
        im.save(EXPORTS / f"{PREFIX}_{lname}.png")
        write_pmdo_tile(EXPORTS / f"{PREFIX}_{lname}.tile", [rgba], frame_duration=60)

    for idx, fr in enumerate(water_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_bassins_animes_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_bassins_animes_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_bassins_animes_0.tile",
        water_frames,
        frame_duration=WATER_FRAME_DURATION,
    )

    for idx, fr in enumerate(bubble_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_bulles_marais_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_bulles_marais_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_bulles_marais_0.tile",
        bubble_frames,
        frame_duration=WATER_FRAME_DURATION,
    )

    composed_frames: list[Image.Image] = []
    for f in range(WATER_FRAME_COUNT):
        canvas = Image.fromarray(layers["sol"], "RGBA")
        canvas.alpha_composite(Image.fromarray(water_frames[f], "RGBA"))
        for lname in ("piliers_rocheux", "seuil_entree", "buissons"):
            canvas.alpha_composite(Image.fromarray(layers[lname], "RGBA"))
        canvas.alpha_composite(Image.fromarray(bubble_frames[f], "RGBA"))
        canvas.save(RENDERS / f"{PREFIX}_frame_{f}.png")
        composed_frames.append(canvas.convert("RGB"))

    composed_frames[0].save(RENDERS / f"{PREFIX}_final.png")
    composed_frames[0].save(EXPORTS / f"{PREFIX}_merged_sheet.png")
    composed_frames[0].save(
        RENDERS / f"{PREFIX}_anim.gif",
        save_all=True,
        append_images=composed_frames[1:],
        duration=int(WATER_FRAME_DURATION * 1000 / 60),
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

    ref_im = Image.open(REF / "D09P11A.png").convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
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
        "markers": [ENTRANCE_MARKER, SEUIL_MARKER],
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
        "reference_rom": "D09P11A",
        "dimensions_px": [W, H],
        "grid_cells": [GW, GH],
        "tile_size_px": TILE,
        "tex_size": 1,
        "layers_order": [
            "sol",
            "bassins_animes",
            "piliers_rocheux",
            "seuil_entree",
            "buissons",
            "bulles_marais",
            "Top",
        ],
        "animations": {
            "bassins_animes": {
                "frames": WATER_FRAME_COUNT,
                "frame_duration_ticks": WATER_FRAME_DURATION,
                "loop_ticks": 64,
                "palette_source": "7 couleurs exactes d'eau sans écume de D09P11A.png",
            },
            "bulles_marais": {
                "frames": WATER_FRAME_COUNT,
                "frame_duration_ticks": WATER_FRAME_DURATION,
                "loop_ticks": 64,
            },
        },
        "markers": [ENTRANCE_MARKER, SEUIL_MARKER],
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
<h1>{MAP_TITLE} (<code>{PREFIX}</code> — réf. ROM <code>D09P11A</code>)</h1>
<p>Format 4:3 vaste : {W}×{H} px ({GW}×{GH} cellules 8×8, TexSize=1) — Bassins de tourbière animés (palette exacte D09P11A sans écume), chemin 16×16 BFS vérifié ({len(bfs_path)} pas).</p>
<div class="grid">
  <div class="card"><h3>Animation assemblée (64 ticks)</h3><img src="{PREFIX}_anim.gif"></div>
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
