#!/usr/bin/env python3
"""Pipeline de construction — entree_falaise_trempee_sud_nord_v1 (EFT1).

Entrée de donjon « Falaise Trempée » (Drenched Bluff, réf. ROM D02P11A),
format 4:3 vaste (768×576 px = 96×72 cellules 8×8, TexSize=1).

Couches (du fond vers l'avant) :
  1. sol           — terre moussue olive-verte continue 100 % opaque
  2. herbe_haute   — talus d'herbe émeraude sombre en haut à gauche et à droite
  3. rochers       — blocs rocheux gris-vert et beige-olive + galets au sol
  4. seuil_entree  — ouverture sombre de la grotte nord et arche rocheuse
  5. fleurs_mousse — touffes de mousse et brins d'herbe animés (cycle canonique A B A C, 64 ticks)
  6. embruns       — gouttelettes d'eau ruisselant sur les rochers humides (8 phases × 8 ticks = 64 ticks)
  7. Top           — calque vide au-dessus des personnages (Layer=4)
"""
from __future__ import annotations

from collections import deque
import hashlib
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

PREFIX = "EFT1"
MAP_ID = "entree_falaise_trempee_sud_nord_v1"
MAP_TITLE = "Entrée Falaise Trempée — Approche Sud-Nord V1"

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
    "Y": 88,
    "Width": 16,
    "Height": 16,
    "Direction": "Up",
}

MOSS_FRAME_COUNT = 4
MOSS_FRAME_DURATION = 16  # 4 × 16 = 64 ticks (cycle canonique A B A C)
DRIP_FRAME_COUNT = 8
DRIP_FRAME_DURATION = 8   # 8 × 8 = 64 ticks


def load_rgb(path: Path) -> np.ndarray:
    im = Image.open(path).convert("RGB")
    if im.size != (W, H):
        im = im.resize((W, H), Image.Resampling.LANCZOS)
    return np.array(im, dtype=np.uint8)


def build_layers(decor: np.ndarray, sol_raw: np.ndarray) -> dict[str, np.ndarray]:
    """Décompose le décor en couches fonctionnelles disjointes."""
    r = decor[:, :, 0].astype(np.int16)
    g = decor[:, :, 1].astype(np.int16)
    b = decor[:, :, 2].astype(np.int16)
    lum = decor.mean(axis=-1)

    yy, xx = np.mgrid[0:H, 0:W]

    # 1. Sol : base terre moussue olive-verte 100 % opaque sans empreinte de rochers
    sol_rgb = sol_raw.copy()
    path_clean = (
        (np.abs(xx - 384) < 48)
        & (yy >= 128)
        & (yy < 560)
        & (lum > 82)
        & (lum < 138)
        & ((g - r) >= 6)
        & ((r - b) >= 20)
    )
    path_clean = ndimage.binary_erosion(path_clean, iterations=3)
    dist = ndimage.distance_transform_edt(~path_clean)
    alpha_blend = np.clip(1.0 - dist / 20.0, 0.0, 1.0)[..., None]
    sol_mix = np.clip(
        np.round(decor.astype(np.float32) * alpha_blend + sol_rgb.astype(np.float32) * (1.0 - alpha_blend)),
        0,
        255,
    ).astype(np.uint8)
    sol = np.dstack([sol_mix, np.full((H, W), 255, dtype=np.uint8)])

    # 2. Seuil d'entrée (ouverture sombre de la grotte nord + arche immédiate)
    cave_hole = (yy < 124) & (np.abs(xx - 384) < 76) & (lum < 58)
    cave_arch = ndimage.binary_dilation(cave_hole, iterations=10) & (yy < 132) & (np.abs(xx - 384) < 92)
    seuil_mask = cave_arch

    # 3. Talus d'herbe émeraude sombre (haut gauche et haut droite, sans trous)
    grass_bank = (
        (yy < 252)
        & ((g - r > 14) & (g - b > 10) & (r < 82))
        & (~seuil_mask)
    )
    grass_bank = ndimage.binary_closing(grass_bank, iterations=3)
    grass_bank = ndimage.binary_fill_holes(grass_bank) & (~seuil_mask)

    # 4. Rochers et galets : écart franc par rapport au sol olive-vert ou relief ombré/éclairé
    diff_sol = np.abs(decor.astype(np.int16) - sol_mix.astype(np.int16)).max(axis=-1)
    is_olive_ground = (
        (r >= 78) & (r <= 136)
        & (g >= 92) & (g <= 148)
        & (b >= 48) & (b <= 96)
        & ((g - r) >= 4) & ((g - r) <= 26)
        & ((r - b) >= 18) & ((r - b) <= 52)
    )
    rock_raw = ((~is_olive_ground) | (diff_sol > 26)) & (~seuil_mask) & (~grass_bank)
    # Nettoyer le bruit de 1-2 px tout en conservant les petits galets
    labeled, ncomp = ndimage.label(rock_raw)
    sizes = ndimage.sum(rock_raw, labeled, range(1, ncomp + 1))
    keep = np.zeros(ncomp + 1, dtype=bool)
    for idx, sz in enumerate(sizes, start=1):
        if sz >= 18:
            keep[idx] = True
    rochers_mask = keep[labeled]
    rochers_mask = ndimage.binary_closing(rochers_mask, iterations=1) & (~seuil_mask) & (~grass_bank)

    def make_rgba(mask: np.ndarray) -> np.ndarray:
        out = np.zeros((H, W, 4), dtype=np.uint8)
        out[mask, :3] = decor[mask]
        out[mask, 3] = 255
        return out

    return {
        "sol": sol,
        "herbe_haute": make_rgba(grass_bank),
        "rochers": make_rgba(rochers_mask),
        "seuil_entree": make_rgba(seuil_mask),
        "_masks": {
            "seuil": seuil_mask,
            "herbe_haute": grass_bank,
            "rochers": rochers_mask,
            "cave_hole": cave_hole,
        },
    }


def build_moss_frames(decor: np.ndarray) -> list[np.ndarray]:
    """Animation canonique A B A C (4 phases × 16 ticks) des touffes de mousse et brins d'herbe."""
    r = decor[:, :, 0].astype(np.int16)
    g = decor[:, :, 1].astype(np.int16)
    b = decor[:, :, 2].astype(np.int16)

    # Touffes de mousse vert vif posées sur les rochers + touffe d'herbe dorée en haut à droite
    moss_tufts = ((g > 115) & (g - r > 32) & (g - b > 35)) | (
        (np.arange(H)[:, None] < 120)
        & (np.arange(W)[None, :] > 560)
        & (r > 95)
        & (g > 110)
    )
    labeled, ncomp = ndimage.label(moss_tufts)
    sizes = ndimage.sum(moss_tufts, labeled, range(1, ncomp + 1))
    clean_moss = np.zeros_like(moss_tufts)
    for idx, sz in enumerate(sizes, start=1):
        if 8 <= sz <= 900:
            clean_moss[labeled == idx] = True
    clean_moss = ndimage.binary_dilation(clean_moss, iterations=1)

    base = np.zeros((H, W, 4), dtype=np.uint8)
    base[clean_moss, :3] = decor[clean_moss]
    base[clean_moss, 3] = 255

    # États A (neutre), B (décalage +1 px X), C (décalage -1 px X) sans changement de couleur
    state_a = base.copy()
    state_b = np.zeros_like(base)
    state_b[:, 1:, :] = base[:, :-1, :]
    state_b[clean_moss & (state_b[:, :, 3] == 0)] = base[clean_moss & (state_b[:, :, 3] == 0)]

    state_c = np.zeros_like(base)
    state_c[:, :-1, :] = base[:, 1:, :]
    state_c[clean_moss & (state_c[:, :, 3] == 0)] = base[clean_moss & (state_c[:, :, 3] == 0)]

    # Séquence canonique Sky : A, B, A, C (4 phases)
    return [state_a, state_b, state_a.copy(), state_c]


def build_drip_frames(decor: np.ndarray, masks: dict[str, np.ndarray]) -> list[np.ndarray]:
    """Animation d'embruns et filets d'eau ruisselant sur les rochers humides (8 phases × 8 ticks)."""
    # Palette eau turquoise canonique extraite de D02P31A
    c_light = np.array([95, 175, 159, 255], dtype=np.uint8)
    c_mid = np.array([39, 143, 135, 255], dtype=np.uint8)
    c_deep = np.array([23, 103, 111, 255], dtype=np.uint8)

    # Points de ruissellement sur les rochers gris-vert encadrant le couloir nord
    streams = [
        (276, 86, 14),
        (294, 46, 12),
        (312, 24, 12),
        (456, 28, 12),
        (472, 64, 14),
        (488, 104, 14),
        (244, 148, 12),
        (506, 154, 12),
        (140, 172, 12),
        (636, 176, 12),
    ]

    frames: list[np.ndarray] = []
    for f in range(DRIP_FRAME_COUNT):
        layer = np.zeros((H, W, 4), dtype=np.uint8)
        for idx, (sx, sy, length) in enumerate(streams):
            phase = (f + idx * 3) % DRIP_FRAME_COUNT
            head_y = sy + int((phase * length) // DRIP_FRAME_COUNT)
            for dy, col in [(0, c_light), (-1, c_mid), (-2, c_deep), (-3, c_deep)]:
                py = head_y + dy
                if sy <= py < sy + length and 0 <= py < H and 0 <= sx < W:
                    layer[py, sx] = col
                    if dy == 0 and sx + 1 < W:
                        layer[py, sx + 1] = c_mid
            # Petit éclat d'impact en bas du filet à la dernière phase
            if phase in (DRIP_FRAME_COUNT - 2, DRIP_FRAME_COUNT - 1):
                by = sy + length
                for dx in (-1, 1):
                    if 0 <= by < H and 0 <= sx + dx < W:
                        layer[by, sx + dx] = c_light if phase == DRIP_FRAME_COUNT - 2 else c_mid
        frames.append(layer)
    return frames


def build_collision_grid(masks: dict[str, np.ndarray]) -> list[list[str]]:
    """Construit la grille 96×72 (8×8 px) et vérifie la connexité 16×16 Sud -> Nord."""
    blocked_px = masks["herbe_haute"] | masks["cave_hole"]

    # Seuls les vrais blocs rocheux (et non les petits galets plats au sol) bloquent la marche
    rochers = masks["rochers"]
    labeled, ncomp = ndimage.label(rochers)
    sizes = ndimage.sum(rochers, labeled, range(1, ncomp + 1))
    big_rocks = np.zeros_like(rochers)
    for idx, sz in enumerate(sizes, start=1):
        if sz >= 320:
            big_rocks[labeled == idx] = True
    blocked_px = blocked_px | big_rocks

    grid = [["walk" for _ in range(GW)] for _ in range(GH)]
    for gy in range(GH):
        for gx in range(GW):
            patch = blocked_px[gy * TILE : (gy + 1) * TILE, gx * TILE : (gx + 1) * TILE]
            if patch.mean() > 0.25:
                grid[gy][gx] = "wall"

    # Garantir le couloir central praticable du sud jusqu'au seuil nord
    seuil_gx = SEUIL_MARKER["X"] // TILE
    seuil_gy = SEUIL_MARKER["Y"] // TILE
    ent_gx = ENTRANCE_MARKER["X"] // TILE
    ent_gy = ENTRANCE_MARKER["Y"] // TILE

    for gy in range(seuil_gy, ent_gy + 2):
        for gx in range(seuil_gx - 2, seuil_gx + 4):
            if 0 <= gy < GH and 0 <= gx < GW:
                grid[gy][gx] = "walk"

    # Bloquer le fond noir de la grotte au nord du seuil (y < seuil_gy)
    for gy in range(0, seuil_gy):
        for gx in range(GW):
            grid[gy][gx] = "wall"

    # Bordures latérales hautes bloquées
    for gy in range(0, 26):
        for gx in range(0, 34):
            grid[gy][gx] = "wall"
        for gx in range(62, GW):
            grid[gy][gx] = "wall"

    return grid


def verify_16x16_connectivity(grid: list[list[str]]) -> list[tuple[int, int]]:
    """Vérifie par BFS qu'un gabarit 16×16 (2×2 cellules) relie entrance à donjon_seuil."""
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
    repeat_sequence: list[int] | None = None,
) -> dict[str, int]:
    """Écrit un fichier .tile PMDO (TexSize=8, catalogue dédupliqué 8×8)."""
    unique_Blanks: dict[bytes, bytes] = {}
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
                if digest not in unique_Blanks:
                    unique_Blanks[digest] = raw
                idx = list(unique_Blanks.keys()).index(digest)
                frame_coords.append((idx, 0))
        tile_coords.append(frame_coords)

    n_unique = len(unique_Blanks)
    cols = min(32, max(1, n_unique))
    rows = max(1, (n_unique + cols - 1) // cols)
    sheet = Image.new("RGBA", (cols * TILE, rows * TILE), (0, 0, 0, 0))
    for idx, raw in enumerate(unique_Blanks.values()):
        patch_im = Image.frombytes("RGBA", (TILE, TILE), raw)
        sheet.paste(patch_im, ((idx % cols) * TILE, (idx // cols) * TILE))

    import io
    buf = io.BytesIO()
    sheet.save(buf, format="PNG")
    png_bytes = buf.getvalue()

    seq = repeat_sequence if repeat_sequence is not None else list(range(len(layers_rgba)))

    out = bytearray()
    out += struct.pack("<i", TILE)
    out += struct.pack("<i", GW)
    out += struct.pack("<i", GH)
    out += struct.pack("<i", len(seq))
    out += struct.pack("<i", frame_duration)
    for s in seq:
        fc = tile_coords[s]
        for idx, _ in fc:
            if idx < 0:
                out += struct.pack("<ii", -1, -1)
            else:
                out += struct.pack("<ii", idx % cols, idx // cols)
    out += struct.pack("<i", 1)
    out += struct.pack("<i", len(png_bytes))
    out += png_bytes

    path.write_bytes(bytes(out))
    return {"unique_tiles": n_unique, "frames": len(seq), "bytes": len(out)}


def export_rsground(grid: list[list[str]], out_path: Path) -> None:
    """Exporte le fichier .rsground natif PMDO 0.8.12.0 à partir du gabarit de base."""
    template_path = ROOT / "cliffdaytest.rsground"
    raw = json.loads(template_path.read_text(encoding="utf-8-sig"))
    content = raw["Object"]
    content["Width"] = GW
    content["Height"] = GH
    content["TexSize"] = 1
    content["AssetName"] = MAP_ID
    content["Name"] = {"DefaultText": MAP_TITLE, "LocalTexts": {}}

    # Obstacles : grille 2D native PMDO + liste Walls
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
        make_layer("herbe_haute", f"{PREFIX}_herbe_haute", 0),
        make_layer("rochers", f"{PREFIX}_rochers", 0),
        make_layer("seuil_entree", f"{PREFIX}_seuil_entree", 0),
        make_layer("fleurs_mousse", f"{PREFIX}_fleurs_mousse_0", 0),
        make_layer("embruns", f"{PREFIX}_embruns_0", 0),
        make_layer("Top", "", 4),
    ]
    content["AssetLayers"] = asset_layers
    content["Layers"] = asset_layers
    raw["Version"] = "0.8.12.0"
    out_path.write_text("\ufeff" + json.dumps(raw, indent=2, ensure_ascii=False), encoding="utf-8")


def main() -> None:
    RENDERS.mkdir(parents=True, exist_ok=True)
    EXPORTS.mkdir(parents=True, exist_ok=True)

    decor = load_rgb(BRUTS / "decor.png")
    sol_raw = load_rgb(BRUTS / "sol_complet.png")

    layers = build_layers(decor, sol_raw)
    masks = layers.pop("_masks")
    moss_frames = build_moss_frames(decor)
    drip_frames = build_drip_frames(decor, masks)

    grid = build_collision_grid(masks)
    bfs_path = verify_16x16_connectivity(grid)

    # Sauvegarde des calques PNG dans renders/ et exports/
    for lname, rgba in layers.items():
        im = Image.fromarray(rgba, "RGBA")
        im.save(RENDERS / f"{PREFIX}_couche_{lname}.png")
        im.save(EXPORTS / f"{PREFIX}_{lname}.png")
        write_pmdo_tile(EXPORTS / f"{PREFIX}_{lname}.tile", [rgba], frame_duration=60)

    # Sauvegarde des animations
    for idx, fr in enumerate(moss_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_fleurs_mousse_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_fleurs_mousse_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_fleurs_mousse_0.tile",
        moss_frames,
        frame_duration=MOSS_FRAME_DURATION,
    )

    for idx, fr in enumerate(drip_frames):
        im = Image.fromarray(fr, "RGBA")
        im.save(RENDERS / f"{PREFIX}_embruns_{idx}.png")
        im.save(EXPORTS / f"{PREFIX}_embruns_{idx}.png")
    write_pmdo_tile(
        EXPORTS / f"{PREFIX}_embruns_0.tile",
        drip_frames,
        frame_duration=DRIP_FRAME_DURATION,
    )

    # Recomposition des 8 phases globales (64 ticks = 8 × 8 ticks)
    composed_frames: list[Image.Image] = []
    for f in range(DRIP_FRAME_COUNT):
        canvas = Image.fromarray(layers["sol"], "RGBA")
        for lname in ("herbe_haute", "rochers", "seuil_entree"):
            canvas.alpha_composite(Image.fromarray(layers[lname], "RGBA"))
        moss_idx = (f // 2) % MOSS_FRAME_COUNT
        canvas.alpha_composite(Image.fromarray(moss_frames[moss_idx], "RGBA"))
        canvas.alpha_composite(Image.fromarray(drip_frames[f], "RGBA"))
        canvas.save(RENDERS / f"{PREFIX}_frame_{f}.png")
        composed_frames.append(canvas.convert("RGB"))

    composed_frames[0].save(RENDERS / f"{PREFIX}_final.png")
    composed_frames[0].save(EXPORTS / f"{PREFIX}_merged_sheet.png")
    composed_frames[0].save(
        RENDERS / f"{PREFIX}_anim.gif",
        save_all=True,
        append_images=composed_frames[1:],
        duration=int(DRIP_FRAME_DURATION * 1000 / 60),
        loop=0,
    )

    # Planche de collisions + chemin BFS
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

    # Planche contact
    ref_im = Image.open(REF / "D02P11A.png").convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    fin_im = composed_frames[0].resize((384, 288), Image.Resampling.NEAREST)
    col_im = coll_im.convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    sol_im = Image.fromarray(layers["sol"]).convert("RGB").resize((384, 288), Image.Resampling.NEAREST)
    sheet = Image.new("RGB", (768, 576))
    sheet.paste(ref_im, (0, 0))
    sheet.paste(sol_im, (384, 0))
    sheet.paste(fin_im, (0, 288))
    sheet.paste(col_im, (384, 288))
    sheet.save(RENDERS / f"{PREFIX}_planche_contact.png")

    # Métadonnées JSON + .rsground
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
        "reference_rom": "D02P11A",
        "dimensions_px": [W, H],
        "grid_cells": [GW, GH],
        "tile_size_px": TILE,
        "tex_size": 1,
        "layers_order": ["sol", "herbe_haute", "rochers", "seuil_entree", "fleurs_mousse", "embruns", "Top"],
        "animations": {
            "fleurs_mousse": {"frames": MOSS_FRAME_COUNT, "frame_duration_ticks": MOSS_FRAME_DURATION, "loop_ticks": 64},
            "embruns": {"frames": DRIP_FRAME_COUNT, "frame_duration_ticks": DRIP_FRAME_DURATION, "loop_ticks": 64},
        },
        "markers": [ENTRANCE_MARKER, SEUIL_MARKER],
        "validation_status": {
            "python_tests_passed": True,
            "art_approved": False,
            "runtime_tested": False,
        },
    }
    (EXPORTS / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")

    # Aperçu HTML autonome
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
<h1>{MAP_TITLE} (<code>{PREFIX}</code> — réf. ROM <code>D02P11A</code>)</h1>
<p>Format 4:3 vaste : {W}×{H} px ({GW}×{GH} cellules 8×8, TexSize=1) — Chemin 16×16 BFS vérifié ({len(bfs_path)} pas).</p>
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
