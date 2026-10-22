#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_arena_textures.py — corrige les arènes dont le TileTex est VIDE et dont
les textures du ground sont dans les Layers de la map en 8x8 (invisibles dans
des cellules de combat 24px : le joueur voit un fond vide = "texture manquante").

Méthode (prouvée par round-trip byte-identique sur une sheet existante) :
  1. lit le ground source (couches graphiques, obstacles, TexSize) ;
  2. génère une sheet dédiée "Arena_<arène>_Base" : chaque texture du ground
     mise à 24px par échelle ENTIÈRE (upscale x3 NEAREST si 8x8, 1:1 si 24x24) ;
  3. réécrit le .rsmap : Tiles[x][y].Data.TileTex.Layers = textures 24x24
     (même composition multi-couches que le ground, ordre de dessin moteur),
     Layers de la map vidés (plus de double rendu 8x8) ;
  4. injecte la sheet dans Content/Tile/index.idx (sans toucher aux autres) ;
  5. re-lit la sheet comme le moteur (GetTile -> seek -> i64 len + PNG) et
     compare le rendu ground (x3) vs arène (24px) : doit être 0.

Usage :
  python3 tools/fix_arena_textures.py <arène> <ground> [--write]
"""
import argparse
import hashlib
import io
import json
import os
import struct
import subprocess
import sys

from PIL import Image
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAPDIR = os.path.join(ROOT, 'Data', 'Map')
GRODIR = os.path.join(ROOT, 'Data', 'Ground')
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')
TILE = 24
_sheet_cache = {}


def git_show(path):
    r = subprocess.run(['git', 'show', 'HEAD:' + path], capture_output=True, cwd=ROOT)
    return r.stdout if r.returncode == 0 else None


def load_package(sheet):
    if sheet in _sheet_cache:
        return _sheet_cache[sheet]
    local = os.path.join(TILEDIR, sheet + '.tile')
    raw = open(local, 'rb').read() if os.path.exists(local) else git_show('Content/Tile/' + sheet + '.tile')
    if raw is None:
        raise FileNotFoundError(sheet)
    ts, tc = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(tc):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        cells[(x, y)] = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert('RGBA')
    _sheet_cache[sheet] = (ts, cells)
    return _sheet_cache[sheet]


def upscale(img, k):
    return img if k == 1 else img.resize((img.width * k, img.height * k), Image.NEAREST)


def write_tile_package(path, cells):
    """cells: liste de (x, y, PNG bytes 24x24). Format identique aux sheets du
    repo : u32 tileSize, u32 count, table (u64 key=x|y<<32, u64 off), blobs
    (i64 len + PNG), dédup par contenu."""
    ts = TILE
    n = len(cells)
    cur = 8 + n * 16
    offsets = []
    prev = {}
    for x, y, png in cells:
        if png in prev:
            offsets.append(prev[png])
        else:
            offsets.append(cur)
            prev[png] = cur
            cur += 8 + len(png)
    table = b''.join(struct.pack('<QQ', x | (y << 32), off)
                     for (x, y, png), off in zip(cells, offsets))
    body = b''
    done = set()
    for (x, y, png), off in zip(cells, offsets):
        if off in done:
            continue
        done.add(off)
        body += struct.pack('<q', len(png)) + png
    with open(path, 'wb') as f:
        f.write(struct.pack('<II', ts, n) + table + body)
    return n


def read_index():
    local = os.path.join(TILEDIR, 'index.idx')
    if os.path.exists(local):
        return bytearray(open(local, 'rb').read())
    return bytearray(git_show('Content/Tile/index.idx'))


def inject_index(entry):
    """Ajoute une planche (nom, tileSize, tileCount, table_bytes) sans toucher
    aux autres ; ordre alphabétique conservé."""
    idx = read_index()
    n = struct.unpack_from('<I', idx, 0)[0]
    pos = 4
    parsed = []
    for i in range(n):
        nl = idx[pos]; pos += 1
        name = bytes(idx[pos:pos + nl]).decode('utf-8', errors='replace'); pos += nl
        ts = struct.unpack_from('<I', idx, pos)[0]
        tc = struct.unpack_from('<I', idx, pos + 4)[0]
        table = bytes(idx[pos + 8:pos + 8 + tc * 16])
        parsed.append((name, ts, tc, table))
        pos += 8 + tc * 16
    name, ts, tc, table = entry
    if name not in {p[0] for p in parsed}:
        parsed.append(entry)
    parsed.sort(key=lambda p: p[0])
    out = bytearray()
    out += struct.pack('<I', len(parsed))
    for nm, ts2, tc2, tbl in parsed:
        nb = nm.encode('utf-8')
        out += bytes([len(nb)]) + nb
        out += struct.pack('<II', ts2, tc2)
        out += tbl
    with open(os.path.join(TILEDIR, 'index.idx'), 'wb') as f:
        f.write(bytes(out))
    return len(parsed)


def ground_layers(gpath):
    with open(gpath, encoding='utf-8-sig') as f:
        o = json.load(f)['Object']
    tex = o.get('TexSize', 1)
    vis = [L for L in o.get('Layers', []) if L.get('Tiles')]
    return tex, vis


def build_sheet(arena, vis_layers):
    """Compose toutes les couches visibles ; retourne (nom_sheet, mapping
    {(Sheet, TexLoc, frame): (nx, ny)}, cells[(nx,ny,png)])."""
    seen = {}
    for L in vis_layers:
        T = L['Tiles']
        for x in range(len(T)):
            for y in range(len(T[0])):
                cell = T[x][y]
                if not isinstance(cell, dict):
                    continue
                for tl in cell.get('Layers', []):
                    for fi, fr in enumerate(tl.get('Frames', [])):
                        if fr.get('Sheet'):
                            key = (fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'], fi)
                            if key not in seen:
                                seen[key] = len(seen)
    pngs = {}
    meta = {}
    for key, idx in seen.items():
        sheet, tx, ty, fi = key
        ts, cells = load_package(sheet)
        src = cells.get((tx, ty))
        if src is None:
            src = Image.new('RGBA', (ts, ts), (0, 0, 0, 0))
        up = src if src.width >= TILE else upscale(src, TILE // src.width)
        buf = io.BytesIO()
        up.save(buf, 'PNG')
        pngs[idx] = buf.getvalue()
        meta[idx] = key
    n = len(pngs)
    gx = max(1, int(np.ceil(np.sqrt(n))))
    mapping = {}
    cells_out = []
    for idx, png in pngs.items():
        nx, ny = idx % gx, idx // gx
        mapping[meta[idx]] = (nx, ny)
        cells_out.append((nx, ny, png))
    return f'Arena_{arena}_Base', mapping, cells_out


def fix(arena, ground, write=False):
    arena_path = os.path.join(MAPDIR, arena + '.rsmap')
    gpath = os.path.join(GRODIR, ground + '.rsground')
    if not os.path.exists(arena_path) or not os.path.exists(gpath):
        print(f'ERREUR: {arena_path} ou {gpath} absent')
        return
    print(f'== {arena}  <-  {ground}')

    tex, vis_layers = ground_layers(gpath)
    main = vis_layers[0]
    T = main['Tiles']
    W, H = len(T), len(T[0])
    print(f'   ground: TexSize={tex} {W}x{H} cellules, {len(vis_layers)} couches')

    sheet_name, mapping, cells_out = build_sheet(arena, vis_layers)
    print(f'   sheet {sheet_name}: {len(cells_out)} textures {TILE}x{TILE}')

    with open(arena_path, encoding='utf-8-sig') as f:
        d = json.load(f)
    obj = d['Object'] if 'Object' in d else d
    tiles = obj['Tiles']
    aw, ah = len(tiles), len(tiles[0])
    if (aw, ah) != (W, H):
        print(f'   ATTENTION: arène {aw}x{ah} != ground {W}x{H} — arène non alignée, skip')
        return

    if not write:
        print('   [analyse seule — pas d’écriture]')
        return

    # construire les nouveaux TileTex (composition multi-couches)
    for x in range(W):
        for y in range(H):
            layers = []
            for L in vis_layers:
                gcell = L['Tiles'][x][y]
                if not isinstance(gcell, dict):
                    continue
                for tl in gcell.get('Layers', []):
                    frames = []
                    for fi, fr in enumerate(tl.get('Frames', [])):
                        if fr.get('Sheet'):
                            nx, ny = mapping[(fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'], fi)]
                            frames.append({'Sheet': sheet_name, 'TexLoc': {'X': nx, 'Y': ny}})
                    if frames:
                        layers.append({'Frames': frames, 'FrameLength': tl.get('FrameLength', 60)})
            tiles[x][y]['Data']['TileTex']['Layers'] = layers
            tiles[x][y]['Data']['TileTex']['AutoTileset'] = ''
            # conserver l'ID terrain (floor/unbreakable) existant
    # vider les Layers de la map (plus de double rendu 8x8)
    obj['Layers'] = []
    obj['DiscoveryArray'] = [[False] * H for _ in range(W)]

    with open(arena_path, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, separators=(',', ':'))

    # écrire la sheet + index
    os.makedirs(TILEDIR, exist_ok=True)
    sheet_path = os.path.join(TILEDIR, sheet_name + '.tile')
    n_cells = write_tile_package(sheet_path, cells_out)
    raw = open(sheet_path, 'rb').read()
    ts = struct.unpack_from('<I', raw, 0)[0]
    tc = struct.unpack_from('<I', raw, 4)[0]
    table = raw[8:8 + tc * 16]
    inject_index((sheet_name, ts, tc, table))
    print(f'   écrit: {arena_path} + {sheet_path} (tileSize={ts}, {tc} entrées) + index.idx')

    # validation : re-lecture moteur de la sheet
    errs = validate_sheet(sheet_path, mapping, vis_layers)
    print(f'   validation re-lecture moteur: {errs} erreurs')
    # comparaison pixel
    render_compare(arena, ground, vis_layers, tex)


def validate_sheet(sheet_path, mapping, vis_layers):
    raw = open(sheet_path, 'rb').read()
    _, tc = struct.unpack_from('<II', raw, 0)
    pos_map = {}
    for i in range(tc):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        pos_map[(key & 0xFFFFFFFF, key >> 32)] = off
    errs = 0
    for L in vis_layers:
        T = L['Tiles']
        for x in range(len(T)):
            for y in range(len(T[0])):
                cell = T[x][y]
                if not isinstance(cell, dict):
                    continue
                for tl in cell.get('Layers', []):
                    for fi, fr in enumerate(tl.get('Frames', [])):
                        if not fr.get('Sheet'):
                            continue
                        nx, ny = mapping[(fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'], fi)]
                        off = pos_map.get((nx, ny))
                        if off is None or off + 8 > len(raw):
                            errs += 1
                            continue
                        ln = struct.unpack_from('<q', raw, off)[0]
                        if ln <= 0 or off + 8 + ln > len(raw):
                            errs += 1
                            continue
                        try:
                            Image.open(io.BytesIO(raw[off + 8:off + 8 + ln]))
                        except Exception:
                            errs += 1
    return errs


def render_compare(arena, ground, vis_layers, tex):
    outdir = os.path.join(ROOT, 'docs', 'renders', 'pixelperfect')
    os.makedirs(outdir, exist_ok=True)
    # ground : composer toutes les couches
    T = vis_layers[0]['Tiles']
    W, H = len(T), len(T[0])
    pas = 8 * tex
    g = Image.new('RGBA', (W * pas, H * pas), (0, 0, 0, 0))
    for L in vis_layers:
        TT = L['Tiles']
        for x in range(W):
            for y in range(H):
                cell = TT[x][y]
                if not isinstance(cell, dict):
                    continue
                for tl in cell.get('Layers', []):
                    frs = tl.get('Frames', [])
                    if not frs:
                        continue
                    fr = frs[0]
                    if not fr.get('Sheet'):
                        continue
                    ts, cells = load_package(fr['Sheet'])
                    src = cells.get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                    if src is not None:
                        g.alpha_composite(src, (x * pas, y * pas))
    k = TILE // (8 * tex)
    expected = upscale(g, k) if k > 1 else g

    d = json.load(open(os.path.join(MAPDIR, arena + '.rsmap'), encoding='utf-8-sig'))
    o = d['Object'] if 'Object' in d else d
    tiles = o['Tiles']
    aw, ah = len(tiles), len(tiles[0])
    a = Image.new('RGBA', (aw * TILE, ah * TILE), (0, 0, 0, 255))
    for x in range(aw):
        for y in range(ah):
            tt = tiles[x][y]['Data']['TileTex']['Layers']
            for tl in tt:
                frs = tl.get('Frames', [])
                if not frs:
                    continue
                fr = frs[0]
                if not fr.get('Sheet'):
                    continue
                ts, cells = load_package(fr['Sheet'])
                src = cells.get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                if src is not None:
                    a.alpha_composite(src, (x * TILE, y * TILE))

    def black(im):
        base = Image.new('RGBA', im.size, (0, 0, 0, 255))
        base.alpha_composite(im)
        return base

    e = np.asarray(black(expected).convert('RGB'), dtype=np.int16)
    b = np.asarray(black(a).convert('RGB'), dtype=np.int16)
    diff = np.abs(e - b).sum(axis=2)
    total = e.shape[0] * e.shape[1]
    n_diff = int((diff > 0).sum())
    print(f'   comparaison: {a.width}x{a.height}px | pixels différents: {n_diff}/{total} ({100*n_diff/total:.2f}%) | diff max: {int(diff.max())}')

    pad = 12
    canvas = Image.new('RGBA', (expected.width * 2 + pad, expected.height), (30, 30, 40, 255))
    canvas.alpha_composite(black(expected), (0, 0))
    canvas.alpha_composite(a, (expected.width + pad, 0))
    out = os.path.join(outdir, f'{arena}__vs__{ground}.png')
    canvas.convert('RGB').save(out)
    print(f'   montage: {out}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('arena')
    ap.add_argument('ground')
    ap.add_argument('--write', action='store_true')
    args = ap.parse_args()
    fix(args.arena, args.ground, write=args.write)


if __name__ == '__main__':
    main()
