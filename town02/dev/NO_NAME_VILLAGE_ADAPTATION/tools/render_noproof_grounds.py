#!/usr/bin/env python3
"""Rend les Grounds NO_PROOF normalises, avec la collision superposee.

Pourquoi la collision est superposee
------------------------------------
`CONVERSION.json` annonce des ratios de cellules bloquees allant de 5,2 %
(rmcave1_2) a 32,9 % (rm68). Un chiffre ne dit pas si la collision tombe au bon
endroit : 5 % peut etre correct pour une grotte dont l'essentiel est un vide
hors-cavite jamais tuile, ou etre un defaut grave si les parois sont
traversables. Seule l'image tranche.

Le rendu superpose donc un voile rouge sur chaque cellule 8x8 marquee bloquante.
Regarder l'image repond a la question ; le compteur, non.

Rend depuis le Ground normalise et sa planche `.tile` normalisee : ce qui est
affiche est ce que le moteur lira, pas une recomposition depuis la source.
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
CELL = 8


def read_tile_sheet(path: Path):
    raw = path.read_bytes()
    size, count = struct.unpack_from("<II", raw, 0)
    images = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        images[key] = Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).convert("RGBA")
    return size, images


def unpremultiply(image: Image.Image) -> Image.Image:
    source = image.load()
    out = Image.new("RGBA", image.size)
    target = out.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = source[x, y]
            target[x, y] = (0, 0, 0, 0) if a == 0 else (
                min(255, r * 255 // a), min(255, g * 255 // a), min(255, b * 255 // a), a)
    return out


def tex_key(x: int, y: int) -> int:
    return (y << 32) | x


def render(ground: Path, tiles_dir: Path):
    obj = json.loads(ground.read_text(encoding="utf-8-sig"))["Object"]
    grid = len(obj["obstacles"])
    world = grid * CELL

    sheets = {}
    for path in sorted(tiles_dir.glob("*.tile")):
        _, images = read_tile_sheet(path)
        sheets[path.stem] = {k: unpremultiply(v) for k, v in images.items()}

    # Fond TRANSPARENT, pas noir. Le sol des grottes NNV est noir : sur un fond
    # noir opaque il devient indiscernable du hors-cavite jamais tuile, et toute
    # mesure de remplissage fondee sur la couleur est fausse. Mesurer par
    # l'alpha repond a la vraie question : cette cellule a-t-elle recu une tuile ?
    canvas = Image.new("RGBA", (world, world), (0, 0, 0, 0))
    drawn = missing = 0
    for layer in obj["Layers"]:
        if not layer.get("Visible"):
            continue
        columns = len(layer["Tiles"])
        cell = world // columns
        for cx in range(columns):
            for cy in range(len(layer["Tiles"][cx])):
                stack = layer["Tiles"][cx][cy].get("Layers") or []
                if not stack:
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    continue
                frame = frames[0]
                sheet = sheets.get(frame["Sheet"])
                if sheet is None:
                    missing += 1
                    continue
                block = sheet.get(tex_key(frame["TexLoc"]["X"], frame["TexLoc"]["Y"]))
                if block is None:
                    missing += 1
                    continue
                canvas.alpha_composite(block, (cx * cell, cy * cell))
                drawn += 1

    alpha_channel = canvas.split()[3].histogram()
    covered = sum(alpha_channel) - alpha_channel[0]

    # Vue lisible : le hors-cavite non tuile devient gris fonce, ce qui permet
    # de le distinguer a l'oeil du sol de grotte, noir mais bien tuile.
    backdrop = Image.new("RGBA", (world, world), (32, 32, 38, 255))
    backdrop.alpha_composite(canvas)
    overlay = backdrop.copy()
    veil = Image.new("RGBA", (CELL, CELL), (255, 40, 40, 110))
    blocked = 0
    for cx in range(grid):
        for cy in range(grid):
            if obj["obstacles"][cx][cy]["Tags"]:
                overlay.alpha_composite(veil, (cx * CELL, cy * CELL))
                blocked += 1

    return canvas, overlay, {
        "world_px": world,
        "tiles_drawn": drawn,
        "tiles_unresolved": missing,
        "tile_coverage_ratio": round(covered / (world * world), 4),
        "coverage_note": "mesure par l'ALPHA (cellule tuilee ou non), jamais par la couleur : le sol des grottes NNV est noir",
        "blocked_cells": blocked,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--indir", type=Path, default=REPO / ".runtime-cache/nnv-noproof-grounds")
    parser.add_argument("--out", type=Path, default=ROOT / "reports/noproof-rooms/converted")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    results = []
    thumbs = []
    for room_dir in sorted(p for p in args.indir.iterdir() if p.is_dir()):
        room = room_dir.name
        # La saison fait partie du nom de fichier et varie d'une room a l'autre :
        # chaque room est peinte dans SA saison native. On ne la presuppose pas.
        candidates = sorted((room_dir / "Data/Ground").glob(f"nnv_{room}_*.rsground"))
        if not candidates:
            continue
        ground = candidates[0]
        plain, overlay, stats = render(ground, room_dir / "Content/Tile")
        plain_path = args.out / f"{room}.png"
        overlay_path = args.out / f"{room}_collision.png"
        backdrop_plain = Image.new("RGBA", plain.size, (32, 32, 38, 255))
        backdrop_plain.alpha_composite(plain)
        backdrop_plain.save(plain_path)
        overlay.save(overlay_path)
        stats.update({
            "room": room,
            "png": plain_path.name,
            "collision_png": overlay_path.name,
            "png_sha256": hashlib.sha256(plain_path.read_bytes()).hexdigest(),
        })
        results.append(stats)
        thumbs.append((room, overlay))
        print(f"{room:11} couverture={stats['tile_coverage_ratio']:.3f} "
              f"tuiles={stats['tiles_drawn']} non_resolues={stats['tiles_unresolved']} "
              f"bloquees={stats['blocked_cells']}", flush=True)

    if thumbs:
        columns = 4
        rows = (len(thumbs) + columns - 1) // columns
        size = thumbs[0][1].width
        sheet = Image.new("RGBA", (columns * (size + 8) + 8, rows * (size + 8) + 8), (18, 18, 18, 255))
        for index, (_, image) in enumerate(thumbs):
            sheet.alpha_composite(image, (8 + (index % columns) * (size + 8),
                                          8 + (index // columns) * (size + 8)))
        contact = args.out / "ALL_NOPROOF_COLLISION.png"
        sheet.save(contact)

    report = {
        "schema": "new-era.nnv-noproof-render.v1",
        "source": "Grounds normalises x0,125 lus tels quels, planches .tile normalisees",
        "collision_overlay": "voile rouge sur chaque cellule 8x8 bloquante",
        "rooms": results,
        "rooms_rendered": len(results),
        "total_unresolved_tiles": sum(r["tiles_unresolved"] for r in results),
        "not_proven": "le rendu et la collision sont visibles ; le chargement PMDO 0.8.12 ne l'est pas",
    }
    (args.out / "render.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
