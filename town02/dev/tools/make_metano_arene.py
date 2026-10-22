#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""make_metano_arene.py — transplante une fenetre de metano_town.rsground
dans une carte de combat .rsmap, au pixel pres.

Principe (verifie dans le moteur RogueEssence) :
  * GroundMap.Layers et Map.Layers sont TOUS DEUX des List<MapLayer>,
    dont Tiles est un AutoTile[][]. Le format serialise est identique.
  * Un ground a TexSize=1 -> pas de grille = 8 px.
    Un donjon a GraphicsManager.TileSize = 24 px.
    => il faut FUSIONNER chaque bloc de 3x3 cellules de 8 px du ground
       en UNE tuile de 24 px pour le donjon.
  * Les 9 sous-cellules d'un bloc occupent des zones DISJOINTES de 8x8 :
    aucun melange alpha, c'est une simple mosaique.
    (mesure : aucune cellule de metano_town n'a plus d'un TileLayer)
  * Map.DrawLoc dessine Tiles[x][y].Data.TileTex ENTRE les couches Under
    et Bottom. On laisse ce TileTex vide -> le terrain n'ajoute aucun
    pixel, seules nos couches transplantees s'affichent.
    (patron deja utilise par foret_embuscade_fond.rsmap du depot)

Format .tile (verifie octet par octet) :
    uint32 tileSize, uint32 tileCount,
    tileCount x (uint64 key = x | (y<<32), uint64 offset_absolu),
    a chaque offset : int64 len + octets PNG.
  Les tuiles identiques partagent le meme offset (deduplication).
"""
import io
import json
import os
import struct
import sys
from collections import Counter

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GROUND = os.path.join(ROOT, 'Data', 'Ground', 'metano_town.rsground')
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')

GROUND_CELL = 8      # px par cellule de ground
DUNGEON_TILE = 24    # px par tuile de donjon
BLOCK = DUNGEON_TILE // GROUND_CELL   # 3

_pkg_cache = {}


def load_package(sheet):
    """Retourne dict (x,y) -> Image RGBA de la planche `sheet`."""
    if sheet in _pkg_cache:
        return _pkg_cache[sheet]
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
    _pkg_cache[sheet] = (tile_size, cells)
    return _pkg_cache[sheet]


def write_package(path, grid):
    """grid : dict (x,y) -> Image RGBA de 24x24. Ecrit un .tile dedupe."""
    keys = sorted(grid.keys(), key=lambda k: (k[1], k[0]))
    blobs = {}          # png bytes -> offset
    order = []
    for k in keys:
        buf = io.BytesIO()
        grid[k].save(buf, format='PNG')
        png = buf.getvalue()
        if png not in blobs:
            blobs[png] = None
            order.append(png)
    header = 8 + len(keys) * 16
    off = header
    for png in order:
        blobs[png] = off
        off += 8 + len(png)
    out = bytearray()
    out += struct.pack('<II', DUNGEON_TILE, len(keys))
    for k in keys:
        buf = io.BytesIO()
        grid[k].save(buf, format='PNG')
        png = buf.getvalue()
        out += struct.pack('<QQ', k[0] | (k[1] << 32), blobs[png])
    for png in order:
        out += struct.pack('<q', len(png)) + png
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return len(keys), len(order), len(out)


def empty_tile():
    return {'AutoTileset': '', 'Associates': [], 'Layers': [],
            'NeighborCode': -1}


def build(x0, y0, w, h, name, apply=False):
    """x0,y0,w,h en TUILES de 24 px. Fenetre = [x0, x0+w) x [y0, y0+h)."""
    with open(GROUND, encoding='utf-8-sig') as f:
        gobj = json.load(f)['Object']
    glayers = gobj['Layers']
    ob = gobj['obstacles']

    print(f'fenetre : tuiles x {x0}..{x0 + w - 1}, y {y0}..{y0 + h - 1}'
          f'  ({w}x{h} tuiles = {w * 24}x{h * 24} px)')
    print(f'         px ground x {x0 * 24}..{(x0 + w) * 24}, '
          f'y {y0 * 24}..{(y0 + h) * 24}')

    out_layers = []
    sheets_written = []

    for gl in glayers:
        gname = gl['Name']
        gtiles = gl['Tiles']
        # 1er passage : le bloc contient-il quelque chose ?
        grid = {}
        used = 0
        for bx in range(w):
            for by in range(h):
                # collecte des sous-cellules
                subs = []
                maxframes = 1
                flens = []
                for i in range(BLOCK):
                    for j in range(BLOCK):
                        gx = (x0 + bx) * BLOCK + i
                        gy = (y0 + by) * BLOCK + j
                        if gx >= len(gtiles) or gy >= len(gtiles[0]):
                            continue
                        cell = gtiles[gx][gy]
                        for tl in cell.get('Layers', []):
                            frames = [fr for fr in tl.get('Frames', [])
                                      if fr.get('Sheet')]
                            if not frames:
                                continue
                            subs.append((i, j, frames, tl.get('FrameLength', 60)))
                            maxframes = max(maxframes, len(frames))
                            if len(frames) > 1:
                                flens.append(tl.get('FrameLength', 60))
                if not subs:
                    continue
                used += 1
                # rendu des N images de 24x24
                imgs = []
                for fi in range(maxframes):
                    im = Image.new('RGBA', (DUNGEON_TILE, DUNGEON_TILE),
                                   (0, 0, 0, 0))
                    for (i, j, frames, _fl) in subs:
                        fr = frames[fi % len(frames)]
                        _ts, cells = load_package(fr['Sheet'])
                        loc = fr['TexLoc']
                        src = cells.get((loc['X'], loc['Y']))
                        if src is None:
                            continue
                        im.paste(src, (i * GROUND_CELL, j * GROUND_CELL))
                    imgs.append(im)
                grid[(bx, by)] = imgs
                # FrameLength : le plus court des animes, sinon statique
                grid[(bx, by, 'fl')] = min(flens) if flens else 60

        if used == 0:
            continue

        # une planche par frame index
        nmax = max(len(v) for k, v in grid.items() if len(k) == 2)
        sheet_base = f'{name}_{gname.replace(" ", "_")}'
        for fi in range(nmax):
            page = {}
            for k, v in grid.items():
                if len(k) != 2:
                    continue
                page[k] = v[fi % len(v)]
            sn = sheet_base if nmax == 1 else f'{sheet_base}_{fi + 1}'
            path = os.path.join(TILEDIR, sn + '.tile')
            if apply:
                nk, nu, sz = write_package(path, page)
                print(f'   planche {sn}: {nk} tuiles ({nu} uniques), {sz} o')
            sheets_written.append(sn)

        # construction de la couche .rsmap
        tiles = [[empty_tile() for _ in range(h)] for _ in range(w)]
        for k, v in grid.items():
            if len(k) != 2:
                continue
            bx, by = k
            fl = grid[(bx, by, 'fl')]
            frames = []
            for fi in range(len(v)):
                sn = sheet_base if nmax == 1 else f'{sheet_base}_{fi + 1}'
                frames.append({'Sheet': sn, 'TexLoc': {'X': bx, 'Y': by}})
            tiles[bx][by] = {
                'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
                'Layers': [{'Frames': frames, 'FrameLength': fl}],
            }
        out_layers.append({
            'Name': gname,
            'Layer': gl['Layer'],
            'Visible': gl['Visible'],
            'Tiles': tiles,
        })
        print(f'  couche {gname!r} -> {used} tuiles, '
              f'{nmax} frame(s), Layer={gl["Layer"]}')

    # --- terrain : marchable d'apres les obstacles du ground ---
    walk = []
    for bx in range(w):
        col = []
        for by in range(h):
            free = 0
            for i in range(BLOCK):
                for j in range(BLOCK):
                    gx = (x0 + bx) * BLOCK + i
                    gy = (y0 + by) * BLOCK + j
                    if gx < len(ob) and gy < len(ob[0]) \
                            and ob[gx][gy].get('Tags', 0) == 0:
                        free += 1
            col.append(free)
        walk.append(col)
    return out_layers, walk, sheets_written


def dump_walk(walk, w, h, x0, y0):
    print('\n  carte de marche (. = 9/9 libre, o = partiel, # = mur)')
    for by in range(h):
        row = ''
        for bx in range(w):
            n = walk[bx][by]
            row += '.' if n == 9 else ('o' if n >= 5 else '#')
        print(f'   y={y0 + by:3d} {row}')
    print('        x=' + ''.join(str((x0 + i) % 10) for i in range(w)))


if __name__ == '__main__':
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('--x0', type=int, default=30)
    ap.add_argument('--y0', type=int, default=30)
    ap.add_argument('--w', type=int, default=19)
    ap.add_argument('--h', type=int, default=13)
    ap.add_argument('--name', default='Metano_Arene')
    ap.add_argument('--apply', action='store_true')
    a = ap.parse_args()
    layers, walk, sheets = build(a.x0, a.y0, a.w, a.h, a.name, a.apply)
    dump_walk(walk, a.w, a.h, a.x0, a.y0)
    print(f'\n{len(layers)} couches, {len(sheets)} planches')
