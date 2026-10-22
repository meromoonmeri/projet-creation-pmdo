#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_red_anim.py — anime les grounds PMD Red du dépôt qui possèdent un BPA
(animations de tuiles natives) dans pret/pmd-red.

Format BPA Red (struct BpaHeader, ground_bg.c) :
    u8  numTiles          (offset 0)
    u8  pad               (alignement ARM)
    s16 numFrames         (offset 2, LE)
    s32 durationPerFrame[numFrames]   (offset 4)
    u8  tiles[numFrames * numTiles * 32]  (tuiles 8x8 4bpp)

Mécanique (ground_bg.c sub_80A2FBC/3440) : les tuiles du BPC occupent les
indices 1..numTiles-1 en VRAM ; les tuiles BPA du slot 0 sont chargées à la
suite (indices numTiles..numTiles+N-1) et le tilemap les référence
directement. Pour chaque frame, on remplace les tuiles BPA par la frame
courante.

Le script RÉGÉNÈRE le .rsground existant : les Layers sont remplacés par la
version multi-frames (FrameLength = durée BPA), les planches .tile sont
écrites, et TOUT le reste (entités, obstacles, scripts, marqueurs) est
conservé à l'identique.

Usage : python3 tools/convert_red_anim.py --map t01p01 [--apply]
"""
import glob
import io
import json
import os
import struct
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RED_BASE = '/tmp/pmd-red/data/map_bg'
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
TILE_DIR = os.path.join(ROOT, 'Content', 'Tile')

XSTRIDE = 128

# Maps du dépôt -> fichiers Red (BMA/BPC/BPL/BPA)
MAPS = {
    't01p01': ('T01P01', 'T01P011'),           # Pokémon Square
    'a04p01': ('A04P01', 'A04P011'),           # Summit Sunset
    'poisonous_forest_boss': ('H12P01', 'H12P011'),  # Marais Poison
}


def parse_bpl(p):
    d = open(p, 'rb').read()
    n = d[0]
    pals = []
    off = 4
    for _ in range(n):
        cols = [(0, 0, 0, 0)]
        for c in range(15):
            cols.append((d[off], d[off + 1], d[off + 2], 255))
            off += 4
        pals.append(cols)
    return pals


def parse_bpc(p):
    d = open(p, 'rb').read()
    cw, chh, nt = struct.unpack_from('<HHH', d, 0)
    nc, = struct.unpack_from('<H', d, 14)
    tiles = [bytes(32)] + [d[16 + i * 32:16 + (i + 1) * 32] for i in range(nt - 1)]
    off = 16 + (nt - 1) * 32
    n = cw * chh
    chunks = [[0] * n]
    for i in range(nc - 1):
        chunks.append(list(struct.unpack_from('<%dH' % n, d, off)))
        off += n * 2
    return cw, chh, tiles, chunks


def parse_bpa(p):
    d = open(p, 'rb').read()
    num_tiles = d[0]
    num_frames = struct.unpack_from('<h', d, 2)[0]
    durations = list(struct.unpack_from('<%di' % num_frames, d, 4))
    off = 4 + num_frames * 4
    frames = []
    for f in range(num_frames):
        fr = []
        for k in range(num_tiles):
            fr.append(d[off + (f * num_tiles + k) * 32: off + (f * num_tiles + k + 1) * 32])
        frames.append(fr)
    return num_tiles, num_frames, durations, frames


def decode_bma(p):
    d = open(p, 'rb').read()
    Wt, Ht, tw, th, Wc, Hc = d[:6]
    nL, hD, hC = struct.unpack_from('<HhH', d, 6)
    src = 12
    STRIDE = 64
    layers = []
    for li in range(nL):
        dst = []
        for j in range(Hc):
            row = []
            prev = dst[(j - 1) * STRIDE:j * STRIDE] if j > 0 else [0] * STRIDE
            k = 0
            while k < Wc:
                cmd = d[src]
                src += 1
                if cmd >= 0xC0:
                    for l in range(cmd - 0xC0 + 1):
                        v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                        src += 3
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0xBF) * 2
                elif cmd >= 0x80:
                    v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                    src += 3
                    for l in range(cmd - 0x80 + 1):
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0x7F) * 2
                else:
                    for l in range(cmd + 1):
                        if j > 0 and len(row) < STRIDE:
                            row += [prev[len(row)], prev[len(row) + 1]]
                        else:
                            row += [0, 0]
                    k += (cmd + 1) * 2
            row = row[:STRIDE] + [0] * (STRIDE - len(row))
            dst += row
        layers.append(dst)
    return Wt, Ht, Wc, Hc, nL, layers


def render_frame(pals, bpc_tiles, chunks, layers, Wt, Ht, Wc, Hc, bpa_frame, nt):
    """bpa_frame : liste de tuiles 4bpp (frame courante) ajoutées après nt."""
    img = Image.new('RGBA', (Wt * 8, Ht * 8), (0, 0, 0, 0))
    tiles = list(bpc_tiles) + list(bpa_frame)
    for lay in reversed(layers):
        for cy in range(Hc):
            for cx in range(Wc):
                cid = lay[cy * 64 + cx]
                if cid <= 0 or cid >= len(chunks):
                    continue
                for i, ent in enumerate(chunks[cid]):
                    ti = ent & 0x3FF
                    hf = (ent >> 10) & 1
                    vf = (ent >> 11) & 1
                    pi = (ent >> 12) & 0xF
                    if ti == 0 or ti >= len(tiles):
                        continue
                    tx, ty = cx * 3 + i % 3, cy * 3 + i // 3
                    if tx * 8 + 8 > Wt * 8 or ty * 8 + 8 > Ht * 8:
                        continue
                    td = tiles[ti]
                    pal = pals[pi % len(pals)]
                    for y in range(8):
                        for x in range(4):
                            b = td[y * 4 + x]
                            for k2, ci in enumerate((b & 0xF, b >> 4)):
                                if ci == 0:
                                    continue
                                xx = x * 2 + k2
                                yy = y
                                if hf:
                                    xx = 7 - xx
                                if vf:
                                    yy = 7 - yy
                                img.putpixel((tx * 8 + xx, ty * 8 + yy), pal[ci])
    return img


def png_bytes(im):
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    return buf.getvalue()


def write_tile(path, entries):
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = None
            order.append(png)
    header = 8 + len(entries) * 16
    offsets, pos = {}, header
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', 8, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    open(path, 'wb').write(bytes(out))


def empty_tile():
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': []}


def convert(mapname, apply=True):
    red_id, bpa_id = MAPS[mapname]
    pals = parse_bpl(os.path.join(RED_BASE, red_id + '.bpl'))
    cw, chh, bpc_tiles, chunks = parse_bpc(os.path.join(RED_BASE, red_id + 'c.bpc'))
    Wt, Ht, Wc, Hc, nL, layers = decode_bma(os.path.join(RED_BASE, red_id + 'm.bma'))
    num_tiles_bpa, num_frames, durations, bpa_frames = parse_bpa(
        os.path.join(RED_BASE, bpa_id + '.bpa'))
    nt = len(bpc_tiles)

    print(f'{mapname}: {Wt}x{Ht} cellules, BPC {nt} tuiles, BPA {num_tiles_bpa} '
          f'tuiles x {num_frames} frames, durées {durations[:4]}', flush=True)

    frames = [render_frame(pals, bpc_tiles, chunks, layers, Wt, Ht, Wc, Hc,
                           bpa_frames[f], nt) for f in range(num_frames)]
    fl = durations[0] if durations[0] > 0 else 8

    # --- grille de tuiles multi-frames ---
    entries = []
    tiles = []
    for x in range(Wt):
        col = []
        for y in range(Ht):
            frs = []
            for f in range(num_frames):
                im = frames[f].crop((x * 8, y * 8, (x + 1) * 8, (y + 1) * 8))
                png = png_bytes(im)
                entries.append(((x + f * XSTRIDE) | (y << 32), png))
                frs.append({'Sheet': mapname + '_Base',
                            'TexLoc': {'X': x + f * XSTRIDE, 'Y': y}})
            col.append({'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
                        'Layers': [{'Frames': frs, 'FrameLength': fl}]})
        tiles.append(col)

    if not apply:
        return
    write_tile(os.path.join(TILE_DIR, mapname + '_Base.tile'), entries)

    # --- régénération du .rsground existant (entités/obstacles conservés) ---
    path = os.path.join(GROUND_DIR, mapname + '.rsground')
    doc = json.load(open(path, encoding='utf-8-sig'))
    o = doc['Object']
    o['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                    'Tiles': tiles}]
    o['Comment'] = (o.get('Comment', '') + ' | ANIMÉ : BPA Red ' + bpa_id +
                    ' (' + str(num_frames) + ' frames, FrameLength ' + str(fl) + ').')
    with io.open(path, 'w', encoding='utf-8-sig') as fh:
        json.dump(doc, fh, ensure_ascii=False, separators=(',', ':'))
    print(f'  -> Data/Ground/{mapname}.rsground + Content/Tile/{mapname}_Base.tile')


def main():
    apply = '--apply' in sys.argv
    only = None
    if '--map' in sys.argv:
        only = sys.argv[sys.argv.index('--map') + 1]
    for m in MAPS:
        if only and m != only:
            continue
        try:
            convert(m, apply)
        except Exception as e:
            import traceback
            print(f'!! ECHEC {m}: {e}')
            traceback.print_exc()


if __name__ == '__main__':
    main()
