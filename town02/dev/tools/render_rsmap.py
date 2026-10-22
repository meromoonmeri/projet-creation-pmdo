#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""render_rsmap.py — rendu PNG d'une carte de combat .rsmap.

Dessine dans l'ordre du moteur (BaseMap.DrawLoc) :
  couches Layer < 4, puis les couches Layer == 4 (Top/Fringe).
Tuiles de 24 px.
"""
import io
import json
import os
import struct
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')
TILE = 24

_cache = {}


def load_package(sheet):
    if sheet in _cache:
        return _cache[sheet]
    with open(os.path.join(TILEDIR, sheet + '.tile'), 'rb') as f:
        raw = f.read()
    tile_size, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        cells[(x, y)] = Image.open(
            io.BytesIO(raw[off + 8: off + 8 + ln])).convert('RGBA')
    _cache[sheet] = (tile_size, cells)
    return _cache[sheet]


def render(path, out, frame=0):
    with open(path, encoding='utf-8-sig') as f:
        obj = json.load(f)['Object']
    W = len(obj['Tiles'])
    H = len(obj['Tiles'][0])
    img = Image.new('RGBA', (W * TILE, H * TILE), (0, 0, 0, 255))
    order = sorted(obj['Layers'], key=lambda L: L['Layer'])
    for L in order:
        if not L.get('Visible', True):
            continue
        T = L['Tiles']
        for x in range(W):
            for y in range(H):
                cell = T[x][y]
                for tl in cell.get('Layers', []):
                    frames = tl.get('Frames', [])
                    if not frames:
                        continue
                    fr = frames[frame % len(frames)]
                    if not fr.get('Sheet'):
                        continue
                    _ts, cells = load_package(fr['Sheet'])
                    loc = fr['TexLoc']
                    src = cells.get((loc['X'], loc['Y']))
                    if src is None:
                        continue
                    img.alpha_composite(src, (x * TILE, y * TILE))
    img.save(out)
    print(out, img.size)
    return img


if __name__ == '__main__':
    render(sys.argv[1], sys.argv[2],
           int(sys.argv[3]) if len(sys.argv) > 3 else 0)
