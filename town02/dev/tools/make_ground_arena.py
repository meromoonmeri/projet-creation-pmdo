#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
make_ground_arena.py — convertit un GROUND ENTIER en .rsmap 1:1 pixel-perfect.

Principe (même méthode que tools/make_metano_arene.py) :
  * GroundMap.Layers et Map.Layers sont les mêmes List<MapLayer> (AutoTile[][]).
  * Ground TexSize=1 -> cellules 8px ; donjon TileSize=24px.
  * Fusion de chaque bloc 3x3 de cellules 8px en UNE tuile 24px (mosaïque).
  * Collision : le .rsmap n'a pas de grille d'obstacles ; la marchabilité est
    portée par l'ID de tuile : `floor` (marchable) / `unbreakable` (mur) —
    exactement le patron du duel Metano (vérifié : floor 188, unbreakable 64).
  * TileTex = vide (le décor est dans les couches, comme le duel validé).

Usage :
    python3 tools/make_ground_arena.py --ground tour_ciel_sommet --apply
"""
import io
import json
import os
import struct
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
MAP_DIR = os.path.join(ROOT, 'Data', 'Map')
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')

GROUND_CELL = 8
DUNGEON_TILE = 24
BLOCK = DUNGEON_TILE // GROUND_CELL  # 3

_pkg_cache = {}


def load_package(sheet):
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
    keys = sorted(grid.keys(), key=lambda k: (k[1], k[0]))
    blobs = {}
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


def convert(ground, name, apply=False):
    gpath = os.path.join(GROUND_DIR, ground + '.rsground')
    with open(gpath, encoding='utf-8-sig') as f:
        gobj = json.load(f)['Object']
    glayers = gobj['Layers']
    ob = gobj['obstacles']

    # Un Ground TexSize=3 est DÉJÀ dessiné en tuiles 24 px. Le refusionner
    # par blocs 3x3 produisait une arène 3 fois trop petite (bug historique
    # gloomy_forest_miniboss 19x19 -> 7x7). On conserve directement ses
    # couches et on agrège seulement la grille d'obstacles 8 px.
    if gobj.get('TexSize', 1) == 3:
        import copy
        w = len(glayers[0]['Tiles'])
        h = len(glayers[0]['Tiles'][0])
        map_tiles = []
        for bx in range(w):
            col = []
            for by in range(h):
                blocked = sum(ob[bx * 3 + i][by * 3 + j].get('Tags', 0) != 0
                              for i in range(3) for j in range(3))
                tid = 'unbreakable' if blocked >= 5 else 'floor'
                col.append({
                    'Data': {'ID': tid, 'TileTex': empty_tile(), 'StableTex': False},
                    'Effect': {'TileLoc': {'X': bx, 'Y': by}, 'ID': '',
                               'Revealed': False, 'Owner': 0, 'TileStates': []},
                })
            map_tiles.append(col)
        print(f'{ground} : {w}x{h} tuiles 24px natives -> copie directe')
        return copy.deepcopy(glayers), map_tiles, []

    # dimensions en tuiles 24px : ceil(dim_cellules / 3)
    gw = len(glayers[0]['Tiles'])
    gh = len(glayers[0]['Tiles'][0])
    w = (gw + BLOCK - 1) // BLOCK
    h = (gh + BLOCK - 1) // BLOCK
    print(f'{ground} : {gw}x{gh} cellules 8px -> {w}x{h} tuiles 24px')

    out_layers = []
    sheets_written = []

    for gl in glayers:
        gname = gl['Name']
        gtiles = gl['Tiles']
        grid = {}
        for bx in range(w):
            for by in range(h):
                subs = []
                maxframes = 1
                flens = []
                for i in range(BLOCK):
                    for j in range(BLOCK):
                        gx = bx * BLOCK + i
                        gy = by * BLOCK + j
                        if gx >= gw or gy >= gh:
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
                grid[(bx, by, 'fl')] = min(flens) if flens else 60

        if not grid:
            continue

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
            'Name': gname, 'Layer': gl['Layer'], 'Visible': gl['Visible'],
            'Tiles': tiles,
        })
        print(f'  couche {gname!r} -> {len(grid)} tuiles, {nmax} frame(s)')

    # --- collision : ID floor / unbreakable (patron duel Metano) ---
    map_tiles = []
    for bx in range(w):
        col = []
        for by in range(h):
            # mur si TOUTES les 9 sous-cellules sont bloquées
            blocked = 0
            for i in range(BLOCK):
                for j in range(BLOCK):
                    gx = bx * BLOCK + i
                    gy = by * BLOCK + j
                    if gx < gw and gy < gh and ob[gx][gy].get('Tags', 0) != 0:
                        blocked += 1
            tid = 'unbreakable' if blocked >= 5 else 'floor'
            col.append({
                'Data': {'ID': tid,
                         'TileTex': {'AutoTileset': '', 'Associates': [],
                                     'Layers': [], 'NeighborCode': -1},
                         'StableTex': False},
                'Effect': {'TileLoc': {'X': bx, 'Y': by}, 'ID': '',
                           'Revealed': False, 'Owner': 0, 'TileStates': []},
            })
        map_tiles.append(col)
    return out_layers, map_tiles, sheets_written


if __name__ == '__main__':
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('--ground', required=True)
    ap.add_argument('--name', default=None)
    ap.add_argument('--apply', action='store_true')
    a = ap.parse_args()
    name = a.name or a.ground
    layers, tiles, sheets = convert(a.ground, name, a.apply)
    print(f'{len(layers)} couches, {len(sheets)} planches')
    if not a.apply:
        print('(dry-run — relancer avec --apply)')
        sys.exit(0)
    # gabarit .rsmap : on s'appuie sur metano_town_duel.rsmap (structure validée)
    with open(os.path.join(MAP_DIR, 'metano_town_duel.rsmap'), encoding='utf-8-sig') as f:
        gab = json.load(f)
    o = gab['Object']
    o['AssetName'] = name
    o['Name'] = {'DefaultText': name, 'LocalTexts': {}}
    o['Comment'] = ('Étage-arène 1:1 du ground %s (pixel-perfect, méthode '
                    'make_ground_arena.py). Aucune différence visuelle entre '
                    'l\'exploration et le combat.' % a.ground)
    o['Layers'] = layers
    o['Tiles'] = tiles
    # EntryPoints : chercher une zone libre 2x2 proche du centre
    w, h = len(tiles), len(tiles[0])
    best = None
    for by in range(h):
        for bx in range(w):
            if tiles[bx][by]['Data']['ID'] == 'floor' and \
               bx + 1 < w and by + 1 < h and \
               tiles[bx + 1][by]['Data']['ID'] == 'floor' and \
               tiles[bx][by + 1]['Data']['ID'] == 'floor' and \
               tiles[bx + 1][by + 1]['Data']['ID'] == 'floor':
                score = abs(bx - w // 2) + abs(by - h // 2)
                if best is None or score < best[0]:
                    best = (score, bx, by)
    if best:
        bx, by = best[1], best[2]
        o['EntryPoints'] = [
            {'Loc': {'X': bx, 'Y': by}, 'Dir': 4},
            {'Loc': {'X': bx + 1, 'Y': by}, 'Dir': 4},
        ]
        print(f'EntryPoints: ({bx},{by}) et ({bx+1},{by}) — zone libre vérifiée')
    else:
        o['EntryPoints'] = [{'Loc': {'X': w // 2, 'Y': h // 2}, 'Dir': 4}]
        print('WARN: aucune zone libre 2x2 trouvée, entry au centre')
    with open(os.path.join(MAP_DIR, name + '.rsmap'), 'w', encoding='utf-8-sig') as f:
        json.dump(gab, f, ensure_ascii=False, indent=2)
    # CRITIQUE : GraphicsManager ne lit pas les offsets dans le .tile au
    # runtime; il utilise Content/Tile/index.idx. Toute planche régénérée doit
    # donc remplacer son nœud d'index dans la même transaction, sinon PMDO lit
    # les anciens offsets et Texture2D.FromStream échoue sur des PNG pourtant
    # valides.
    from inject_tile_index import injecter
    for sheet_name in sheets:
        injecter(ROOT, sheet_name)
    print(f'écrit Data/Map/{name}.rsmap et indexé {len(sheets)} planche(s)')
