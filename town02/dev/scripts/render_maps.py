#!/usr/bin/env python3
"""Rendu PNG des maps .rsground depuis l'atlas .tile."""
import json, struct, io, os
from PIL import Image

def decode_tile(path):
    with open(path, 'rb') as f:
        data = f.read()
    tile_size = struct.unpack_from('<I', data, 0)[0]
    tile_count = struct.unpack_from('<I', data, 4)[0]
    index = []
    pos = 8
    for _ in range(tile_count):
        key = struct.unpack_from('<Q', data, pos)[0]
        offset = struct.unpack_from('<Q', data, pos + 8)[0]
        x = key & 0xFFFFFFFF
        y = key >> 32
        index.append(((x, y), offset))
        pos += 16
    tiles = {}
    for (x, y), offset in index:
        if offset not in tiles:
            png_len = struct.unpack_from('<Q', data, offset)[0]
            png_data = data[offset + 8: offset + 8 + png_len]
            tiles[(x, y)] = Image.open(io.BytesIO(png_data))
    return tiles, tile_size

def render_map(rsground_path, output_png, label=""):
    with open(rsground_path, encoding='utf-8-sig') as f:
        d = json.load(f)
    tiles = d['Object']['Layers'][0]['Tiles']
    h, w = len(tiles), len(tiles[0])
    sheet_name = None
    for y in range(h):
        for x in range(w):
            for ly in tiles[y][x].get('Layers', []):
                for fr in ly.get('Frames', []):
                    s = fr.get('Sheet', '')
                    if s: sheet_name = s; break
            if sheet_name: break
        if sheet_name: break
    if not sheet_name:
        print(f"  {label}: PAS DE SHEET")
        return None
    tile_path = f'Content/Tile/{sheet_name}.tile'
    if not os.path.exists(tile_path):
        print(f"  {label}: MANQUANT {tile_path}")
        return None
    atlas, ts = decode_tile(tile_path)
    img = Image.new('RGBA', (w * 8, h * 8), (0, 0, 0, 0))
    for y in range(h):
        for x in range(w):
            t = tiles[y][x]
            texloc = (0, 0)
            for ly in t.get('Layers', []):
                for fr in ly.get('Frames', []):
                    tl = fr.get('TexLoc', {})
                    texloc = (tl.get('X', 0), tl.get('Y', 0))
                    break
                break
            tile_img = atlas.get(texloc)
            if tile_img:
                img.paste(tile_img, (x * 8, y * 8))
    img.save(output_png)
    print(f"  {label}: {w}x{h} tiles -> {w*8}x{h*8}px, {sheet_name} -> {output_png}")
    return img

print("=== RENDU PNG ===\n")
maps = [
    ('vast_steppe_midpoint', 'Relais Steppe'),
    ('mount_windswept_midpoint', 'Relais Mont'),
    ('cloven_ruins_entrance', 'Entree Ruines'),
    ('cloven_ruins_midpoint', 'Relais Ruines'),
    ('cloven_ruins_boss', 'Boss Ruines'),
]
for name, label in maps:
    render_map(f'Data/Ground/{name}.rsground', f'{name}.png', label)
print("\nOK")
