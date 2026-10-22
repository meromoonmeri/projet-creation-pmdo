#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_proof_duel.py — preuve pixel-perfect du duel Metano.

1. Rend Data/Map/metano_town_duel.rsmap (versions arbre de travail).
2. Cherche dans Data/Ground/metano_town.rsground la fenêtre source :
   glissement à pas de 24 px (alignement tuile), différence absolue moyenne.
3. Ecrit un PNG du duel avec marqueurs d'entrée et positions Dazzling,
   et un PNG comparatif map vs fenêtre ground.
"""
import io
import json
import os
import struct
import sys

import numpy as np
from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')
TILE = 24

_cache = {}


def load_package(sheet):
    if sheet in _cache:
        return _cache[sheet]
    with open(os.path.join(TILEDIR, sheet + '.tile'), 'rb') as f:
        raw = f.read()
    _ts, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln, = struct.unpack_from('<q', raw, off)
        cells[(x, y)] = Image.open(
            io.BytesIO(raw[off + 8: off + 8 + ln])).convert('RGBA')
    _cache[sheet] = cells
    return cells


def draw_layers(canvas, layers, pitch):
    """Dessine les couches visibles sur UN meme canvas (ordre donne)."""
    for L in layers:
        if not L.get('Visible', True):
            continue
        grid = L['Tiles']
        for x in range(len(grid)):
            for y in range(len(grid[0])):
                for tl in grid[x][y].get('Layers', []):
                    frames = tl.get('Frames', [])
                    if not frames:
                        continue
                    fr = frames[0]
                    sheet = fr.get('Sheet')
                    if not sheet:
                        continue
                    cells = load_package(sheet)
                    loc = fr['TexLoc']
                    src = cells.get((loc['X'], loc['Y']))
                    if src is not None:
                        canvas.alpha_composite(src, (x * pitch, y * pitch))


def main():
    # ---- 1 : rendu de la carte de duel ----
    with open(os.path.join(ROOT, 'Data', 'Map', 'metano_town_duel.rsmap'),
              encoding='utf-8-sig') as f:
        mobj = json.load(f)['Object']
    W = len(mobj['Tiles'])
    H = len(mobj['Tiles'][0])
    order = sorted(mobj['Layers'], key=lambda L: L['Layer'])
    map_layers_img = Image.new('RGBA', (W * TILE, H * TILE), (0, 0, 0, 255))
    draw_layers(map_layers_img, order, TILE)
    print(f'duel : {W}x{H} tuiles = {W * TILE}x{H * TILE} px')

    # ---- 2 : rendu integral du ground ----
    with open(os.path.join(ROOT, 'Data', 'Ground', 'metano_town.rsground'),
              encoding='utf-8-sig') as f:
        gobj = json.load(f)['Object']
    gw = len(gobj['Layers'][0]['Tiles'])
    gh = len(gobj['Layers'][0]['Tiles'][0])
    gpitch = 8 * gobj.get('TexSize', 1)
    print(f'ground : {gw}x{gh} cellules de {gpitch}px = '
          f'{gw * gpitch}x{gh * gpitch}px')
    ground_img = Image.new('RGBA', (gw * gpitch, gh * gpitch), (0, 0, 0, 255))
    draw_layers(ground_img, gobj['Layers'], gpitch)

    # ---- 3 : glissement a pas de 24 px ----
    g = np.asarray(ground_img, dtype=np.int16)
    m = np.asarray(map_layers_img, dtype=np.int16)
    best = None
    for oy in range(0, g.shape[0] - m.shape[0] + 1, TILE):
        for ox in range(0, g.shape[1] - m.shape[1] + 1, TILE):
            sub = g[oy:oy + m.shape[0], ox:ox + m.shape[1]]
            d = np.abs(sub - m).mean()
            if best is None or d < best[0]:
                best = (d, ox, oy)
    d, ox, oy = best
    print(f'fenetre trouvee : ground px ({ox},{oy}) = tuiles '
          f'({ox // TILE},{oy // TILE})  diff moyenne/px = {d:.6f}')

    sub = g[oy:oy + m.shape[0], ox:ox + m.shape[1]].astype(np.uint8)
    diff = np.abs(sub - m).sum()
    nz = int((np.abs(sub - m).sum(axis=2) > 0).sum())
    print(f'diff totale = {int(diff)} sur {m.shape[0] * m.shape[1]} px, '
          f'{nz} px differents')

    # ---- 4 : PNG comparatif + marqueurs ----
    outdir = os.path.join(ROOT, 'docs', 'renders')
    os.makedirs(outdir, exist_ok=True)
    ground_win = Image.fromarray(sub)
    scale = 2
    side = Image.new('RGBA', (m.shape[1] * scale * 2 + 24,
                              m.shape[0] * scale + 96), (24, 24, 32, 255))
    dr = ImageDraw.Draw(side)
    mp = map_layers_img.resize((m.shape[1] * scale, m.shape[0] * scale),
                               Image.NEAREST)
    gp = ground_win.resize((m.shape[1] * scale, m.shape[0] * scale),
                           Image.NEAREST)
    side.paste(mp, (0, 48))
    side.paste(gp, (m.shape[1] * scale + 24, 48))
    # marqueurs : entrees (vert), trio (rouge)
    for ep in mobj['EntryPoints']:
        x = ep['Loc']['X'] * TILE * scale
        y = ep['Loc']['Y'] * TILE * scale
        dr.rectangle([x, y, x + TILE * scale - 1, y + TILE * scale - 1],
                     outline=(80, 255, 80, 255), width=2)
        dr.rectangle([x + m.shape[1] * scale + 24, y,
                      x + m.shape[1] * scale + 24 + TILE * scale - 1,
                      y + TILE * scale - 1], outline=(80, 255, 80, 255),
                     width=2)
    for team in mobj.get('MapTeams', []):
        for p in team['Players']:
            loc = p['serializationLoc']
            x = loc['X'] * TILE * scale
            y = loc['Y'] * TILE * scale
            dr.rectangle([x, y, x + TILE * scale - 1, y + TILE * scale - 1],
                         outline=(255, 80, 80, 255), width=2)
            dr.rectangle([x + m.shape[1] * scale + 24, y,
                          x + m.shape[1] * scale + 24 + TILE * scale - 1,
                          y + TILE * scale - 1], outline=(255, 80, 80, 255),
                         width=2)
    side_path = os.path.join(outdir, 'duel_vs_ground_pixelmatch.png')
    side.save(side_path)
    print('comparison ->', side_path)

    spath = os.path.join(outdir, 'metano_town_duel_restaure.png')
    map_layers_img.resize((m.shape[1] * scale, m.shape[0] * scale),
                          Image.NEAREST).save(spath)
    print('duel ->', spath)

    # cadrage de la fenetre dans la ville
    city = ground_img.resize((gw * gpitch // 3, gh * gpitch // 3),
                             Image.LANCZOS)
    dc = ImageDraw.Draw(city)
    dc.rectangle([ox // 3, oy // 3, (ox + m.shape[1]) // 3,
                  (oy + m.shape[0]) // 3], outline=(255, 80, 80, 255),
                 width=3)
    cpath = os.path.join(outdir, 'duel_fenetre_dans_metano.png')
    city.save(cpath)
    print('ville + cadre ->', cpath)


if __name__ == '__main__':
    main()
