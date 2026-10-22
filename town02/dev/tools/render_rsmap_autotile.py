#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""render_rsmap_autotile.py — rendu PNG de référence d'une carte .rsmap
dont les tuiles sont des AutoTileset non cuits (NeighborCode=-1).

VISUALISATION DE RÉFÉRENCE UNIQUEMENT : le rendu réel est effectué par
RogueEssence au runtime (CalculateAutotiles). Ici on résout le masque
d'adjacence 8 bits (cardinaux bits 0-3, diagonales bits 4-7, une diagonale
n'étant comptée que si ses deux cardinaux voisins sont présents) et on
choisit la variante Tilex{mask:02X} de Data/AutoTile/<name>.json, avec
repli sur le masque cardinal seul puis Tilex00.

Usage: render_rsmap_autotile.py <map.rsmap> <out.png> [--autotile-dir DIR]
"""
import argparse
import io
import json
import os
import struct

from PIL import Image

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TILE = 24

_sheet_cache = {}
_auto_cache = {}


def load_package(tiledirs, sheet):
    if sheet in _sheet_cache:
        return _sheet_cache[sheet]
    for d in tiledirs:
        p = os.path.join(d, sheet + '.tile')
        if os.path.exists(p):
            break
    else:
        raise FileNotFoundError(sheet + '.tile')
    with open(p, 'rb') as f:
        raw = f.read()
    _, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        cells[(x, y)] = Image.open(
            io.BytesIO(raw[off + 8: off + 8 + ln])).convert('RGBA')
    _sheet_cache[sheet] = cells
    return cells


def load_autotile(autodirs, name):
    if name in _auto_cache:
        return _auto_cache[name]
    for d in autodirs:
        p = os.path.join(d, name + '.json')
        if os.path.exists(p):
            break
    else:
        raise FileNotFoundError(name + '.json (AutoTile)')
    with open(p, encoding='utf-8-sig') as f:
        data = json.load(f)
    tiles = (data.get('Object') or data)['Tiles']
    variants = {}
    for k, v in tiles.items():
        if not k.startswith('Tilex'):
            continue
        mask = int(k[5:], 16)
        # v = liste de colonnes de listes d'anims ; on prend frame 0 de [0][0]
        try:
            anim = v[0][0]
            fr = anim['Frames'][0]
            variants[mask] = (fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'])
        except (KeyError, IndexError, TypeError):
            continue
    _auto_cache[name] = variants
    return variants


# bits cardinaux : 0=Down, 1=Left, 2=Up, 3=Right
# diagonales : 4=DownLeft(0&1), 5=UpLeft(1&2), 6=UpRight(2&3), 7=DownRight(3&0)
CARD = [(0, (0, 1)), (1, (-1, 0)), (2, (0, -1)), (3, (1, 0))]
DIAG = [(4, (-1, 1), (0, 1)), (5, (-1, -1), (1, 2)),
        (6, (1, -1), (2, 3)), (7, (1, 1), (3, 0))]


def neighbor_mask(names, x, y, W, H):
    me = names[x][y]

    def same(nx, ny):
        if nx < 0 or ny < 0 or nx >= W or ny >= H:
            return True  # hors carte = même texture (convention moteur)
        return names[nx][ny] == me

    mask = 0
    cards = {}
    for bit, (dx, dy) in CARD:
        if same(x + dx, y + dy):
            mask |= 1 << bit
            cards[bit] = True
    for bit, (dx, dy), (c1, c2) in DIAG:
        if cards.get(c1) and cards.get(c2) and same(x + dx, y + dy):
            mask |= 1 << bit
    return mask


def pick_variant(variants, mask):
    if mask in variants:
        return variants[mask]
    card = mask & 0x0F
    # repli : retirer les diagonales une à une (combinatoire simple)
    diag_bits = [b for b in (4, 5, 6, 7) if mask & (1 << b)]
    for drop in range(1, len(diag_bits) + 1):
        import itertools
        for combo in itertools.combinations(diag_bits, drop):
            m = mask
            for b in combo:
                m &= ~(1 << b)
            if m in variants:
                return variants[m]
    if card in variants:
        return variants[card]
    return variants.get(0)


def render(path, out, tiledirs, autodirs):
    with open(path, encoding='utf-8-sig') as f:
        obj = json.load(f)['Object']
    layers = obj['Layers']
    W = len(layers[0]['Tiles'])
    H = len(layers[0]['Tiles'][0])
    img = Image.new('RGBA', (W * TILE, H * TILE), (0, 0, 0, 255))
    for L in sorted(layers, key=lambda l: l.get('Layer', 0)):
        if not L.get('Visible', True):
            continue
        T = L['Tiles']
        names = [[(T[x][y].get('AutoTileset') or '') for y in range(H)]
                 for x in range(W)]
        for x in range(W):
            for y in range(H):
                cell = T[x][y]
                # frames cuits éventuels
                drawn = False
                for tl in cell.get('Layers', []):
                    frames = tl.get('Frames', [])
                    if not frames or not frames[0].get('Sheet'):
                        continue
                    fr = frames[0]
                    cells = load_package(tiledirs, fr['Sheet'])
                    src = cells.get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                    if src is not None:
                        img.alpha_composite(src, (x * TILE, y * TILE))
                        drawn = True
                if drawn:
                    continue
                name = names[x][y]
                if not name:
                    continue
                variants = load_autotile(autodirs, name)
                mask = neighbor_mask(names, x, y, W, H)
                v = pick_variant(variants, mask)
                if v is None:
                    continue
                sheet, tx, ty = v
                cells = load_package(tiledirs, sheet)
                src = cells.get((tx, ty))
                if src is not None:
                    img.alpha_composite(src, (x * TILE, y * TILE))
    img.save(out)
    print(out, img.size)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('rsmap')
    ap.add_argument('out')
    ap.add_argument('--tile-dir', action='append', default=[])
    ap.add_argument('--autotile-dir', action='append', default=[])
    a = ap.parse_args()
    tiledirs = a.tile_dir or [
        os.path.join(ROOT, 'Content', 'Tile'),
        os.path.join(ROOT, '.runtime-cache', 'DumpAsset', 'Content', 'Tile')]
    autodirs = a.autotile_dir or [
        os.path.join(ROOT, 'Data', 'AutoTile'),
        os.path.join(ROOT, '.runtime-cache', 'DumpAsset', 'Data', 'AutoTile')]
    render(a.rsmap, a.out, tiledirs, autodirs)
