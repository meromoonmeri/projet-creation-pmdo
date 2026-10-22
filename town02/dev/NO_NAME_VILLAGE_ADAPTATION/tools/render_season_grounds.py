#!/usr/bin/env python3
"""Rend en PNG un Ground rmvillage materialise, saison par saison.

Difference importante avec les rendus deja publies sous `reports/village-renders`
: ceux-la compositaient les batiments PMU par-dessus l'image de chaque saison au
moment du rendu. Les batiments paraissaient donc identiques partout meme quand
la donnee ne les contenait pas. Ici on lit UNIQUEMENT le Ground materialise :
si une saison n'a pas ses batiments dans ses `Decorations`, le PNG les perd.

Le rendu suit l'ordre natif : les 15 layers de tuiles dans l'ordre du Ground,
puis les `Decorations` par-dessus, chacune a `MapLoc` avec la frame indiquee
dans la planche PMU. Rien n'est redimensionne, tout est NEAREST par construction
(collage pixel a pixel, aucun rescale).
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
GEN = ROOT / "generated/rmvillage"
SEASONS = ("spring", "summer", "autumn", "winter")
CELL = 8  # cellule PMDO apres normalisation x0,125


def read_tile_sheet(path: Path) -> tuple[int, dict[int, Image.Image]]:
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<II", raw, 0)
    images: dict[int, Image.Image] = {}
    order: list[int] = []
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        payload = raw[offset + 8: offset + 8 + length]
        images[key] = Image.open(io.BytesIO(payload)).convert("RGBA")
        order.append(key)
    return tile_size, images, order


def unpremultiply(image: Image.Image) -> Image.Image:
    """La planche stocke l'alpha premultiplie ; on l'annule pour un rendu honnete."""
    src = image.load()
    out = Image.new("RGBA", image.size)
    dst = out.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = src[x, y]
            if a == 0:
                dst[x, y] = (0, 0, 0, 0)
            else:
                dst[x, y] = (min(255, r * 255 // a), min(255, g * 255 // a),
                             min(255, b * 255 // a), a)
    return out


def tex_key(x: int, y: int) -> int:
    return (y << 32) | x


def render(ground_path: Path, season: str) -> tuple[Image.Image, dict]:
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    grid = len(obj["obstacles"])
    world = grid * CELL

    sheets: dict[str, tuple[int, dict[int, Image.Image], list[int]]] = {}
    for tile_path in sorted((GEN / season / "Content/Tile").glob("*.tile")):
        size, images, order = read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {k: unpremultiply(v) for k, v in images.items()}, order)

    canvas = Image.new("RGBA", (world, world), (0, 0, 0, 255))

    tiles_drawn = 0
    for layer in obj["Layers"]:
        if not layer.get("Visible"):
            continue
        columns = len(layer["Tiles"])
        cell = world // columns
        for cx in range(columns):
            column = layer["Tiles"][cx]
            for cy in range(len(column)):
                stack = column[cy].get("Layers") or []
                if not stack:
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    continue
                frame = frames[0]
                entry = sheets.get(frame["Sheet"])
                if entry is None:
                    continue
                block = entry[1].get(tex_key(frame["TexLoc"]["X"], frame["TexLoc"]["Y"]))
                if block is None:
                    continue
                canvas.alpha_composite(block, (cx * cell, cy * cell))
                tiles_drawn += 1

    decorations = 0
    for group in obj["Decorations"]:
        if not group.get("Visible", True):
            continue
        for anim in group["Anims"]:
            entry = sheets.get(anim["Anim"]["AnimIndex"])
            if entry is None:
                raise SystemExit(
                    f"{season}: planche '{anim['Anim']['AnimIndex']}' absente de Content/Tile")
            _, images, order = entry
            frame_index = anim["Anim"]["StartFrame"]
            if frame_index >= len(order):
                raise SystemExit(f"{season}: frame {frame_index} hors planche")
            block = images[order[frame_index]]
            canvas.alpha_composite(block, (anim["MapLoc"]["X"], anim["MapLoc"]["Y"]))
            decorations += 1

    return canvas, {"world_px": world, "tiles_drawn": tiles_drawn,
                    "decorations_drawn": decorations}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--indir", type=Path,
                        default=REPO / ".runtime-cache/nnv-seasons-x0125")
    parser.add_argument("--out", type=Path,
                        default=ROOT / "reports/season-coherence")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    results = []
    images = {}
    for season in SEASONS:
        ground = args.indir / f"nnv_rmvillage_{season}.rsground"
        if not ground.is_file():
            raise SystemExit(f"Ground manquant : {ground}")
        image, stats = render(ground, season)
        target = args.out / f"ground_{season}.png"
        image.save(target)
        images[season] = image
        stats.update({"season": season, "png": target.name,
                      "sha256": hashlib.sha256(target.read_bytes()).hexdigest()})
        results.append(stats)
        print(f"  {season:7} {stats['world_px']}px  tuiles {stats['tiles_drawn']:>6}  "
              f"decorations {stats['decorations_drawn']}")

    zoom = 2
    world = results[0]["world_px"]
    sheet = Image.new("RGBA", (world * zoom * 2 + 24, world * zoom * 2 + 24), (18, 18, 18, 255))
    for index, season in enumerate(SEASONS):
        scaled = images[season].resize((world * zoom, world * zoom), Image.NEAREST)
        sheet.alpha_composite(scaled, (8 + (index % 2) * (world * zoom + 8),
                                       8 + (index // 2) * (world * zoom + 8)))
    contact = args.out / "GROUND_ALL_SEASONS.png"
    sheet.save(contact)

    summary = {
        "schema": "new-era.nnv-season-ground-render.v1",
        "source": "Grounds materialises, Decorations lues dans la donnee (rien de composite a la volee)",
        "seasons": results,
        "contact_sheet": contact.name,
        "contact_sheet_sha256": hashlib.sha256(contact.read_bytes()).hexdigest(),
    }
    (args.out / "season-coherence-render.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
