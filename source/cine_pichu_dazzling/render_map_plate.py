#!/usr/bin/env python3
"""Rend la carte native `cliffdaytest.rsground` (« CliffReverietownnordest », 123×99 tuiles)
en plaques PNG utilisables par la cinématique : calques « under » (Layer 0) et « over »
(Layer 4) séparés, textures 100 % natives (feuilles `.tile` town02), frame 0 des tuiles animées.

    .venv/bin/python source/cine_pichu_dazzling/render_map_plate.py
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "source"))

from source.cliff_nord_centre_v1.build import decode_tile_straight  # type: ignore

T02 = Path("/tmp/t02/Content/Tile")
OUT = Path(__file__).resolve().parent / "plates"
TILE = 8


def main() -> None:
    obj = json.loads((ROOT / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))["Object"]
    gw, gh = len(obj["obstacles"][0]), len(obj["obstacles"])
    W, H = gw * TILE, gh * TILE
    sheets = {}

    def sheet(name: str) -> np.ndarray:
        if name not in sheets:
            sheets[name] = np.asarray(decode_tile_straight(T02 / f"{name}.tile").convert("RGBA"))
        return sheets[name]

    under = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    over = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    n_tiles = 0
    for layer in obj["Layers"]:
        if not layer.get("Visible", True):
            continue
        dst = over if int(layer.get("Layer", 0)) == 4 else under
        for x, col in enumerate(layer["Tiles"]):
            for y, cell in enumerate(col):
                for seq in cell.get("Layers", []):
                    frames = seq.get("Frames") or []
                    if not frames:
                        continue
                    f = frames[0]
                    sh = sheet(f["Sheet"])
                    tx, ty = f["TexLoc"]["X"] * TILE, f["TexLoc"]["Y"] * TILE
                    if ty + TILE > sh.shape[0] or tx + TILE > sh.shape[1]:
                        continue
                    blk = Image.fromarray(sh[ty:ty + TILE, tx:tx + TILE], "RGBA")
                    dst.alpha_composite(blk, (x * TILE, y * TILE))
                    n_tiles += 1
    OUT.mkdir(parents=True, exist_ok=True)
    under.save(OUT / "cliffdaytest_jour_under.png", optimize=True)
    over.save(OUT / "cliffdaytest_jour_over.png", optimize=True)
    comp = under.copy()
    comp.alpha_composite(over)
    comp.save(OUT / "cliffdaytest_jour.png", optimize=True)
    print(f"cliffdaytest jour rendu : {W}x{H}, {n_tiles} tuiles, feuilles={len(sheets)}")


if __name__ == "__main__":
    main()
