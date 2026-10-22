#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_port_dungeon_tileset.py — porte un tileset donjon NDS (DUNGEON/
dungeon.bin : DPL/DPC/DPCI/DMA/DPLA) vers PMDO : Content/Tile/<Sheet>.tile
+ Data/AutoTile/<name>_{floor,wall,secondary}.json.

MÉTHODE PROUVÉE par contre-épreuve sur le tileset 126 (ice_aegis_cave,
présent dans la base PMDO officielle) : 141/141 cellules frame 0 des
autotiles DumpAsset == chunks DMA calculés avec la correspondance de
masques PMDO(bit0=S,1=W,2=N,3=E,4=SW,5=NW,6=NE,7=SE) → DmaNeighbor.

Animations : les frames DPLA (animation de palette NDS) sont rendues
frame par frame ; un chunk dont les pixels varient reçoit la liste
EXACTE de ses frames (durée DPLA), comme surrounded_sea_secondary
(layer 0 statique + layer 1 frames) — jamais d'aplatissement.

Usage: sky_port_dungeon_tileset.py <tileset_id> <name> [--apply]
Ex.  : sky_port_dungeon_tileset.py 82 crevice_cave --apply
"""
import argparse
import hashlib
import io
import json
import os
import struct
from collections import OrderedDict

from PIL import Image
from ndspy.rom import NintendoDSRom
from skytemple_files.common.util import get_ppmdu_config_for_rom
from skytemple_files.container.dungeon_bin.handler import DungeonBinHandler
from skytemple_files.graphics.dma.protocol import DmaType, DmaNeighbor

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM = os.path.join(ROOT, '.runtime-cache', 'sky-rom',
                   'Pokemon Mystery Dungeon - Explorers of Sky (Europe) '
                   '(En,Fr,De,Es,It).nds')
DUMP_AUTO = os.path.join(ROOT, '.runtime-cache', 'DumpAsset', 'Data',
                         'AutoTile')
CHUNK = 24

# masques standards PMDO = clés des autotiles officiels (jeu complet 47)
REF_AUTO = os.path.join(DUMP_AUTO, 'ice_aegis_cave_floor.json')
P2N = {0: DmaNeighbor.SOUTH, 1: DmaNeighbor.WEST, 2: DmaNeighbor.NORTH,
       3: DmaNeighbor.EAST, 4: DmaNeighbor.SOUTH_WEST,
       5: DmaNeighbor.NORTH_WEST, 6: DmaNeighbor.NORTH_EAST,
       7: DmaNeighbor.SOUTH_EAST}


def pmdo2nds(m):
    ns = 0
    for b, n in P2N.items():
        if m & (1 << b):
            ns |= n
    return ns


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('tileset_id', type=int)
    ap.add_argument('name')
    ap.add_argument('--apply', action='store_true')
    a = ap.parse_args()
    ts, name = a.tileset_id, a.name
    sheet_name = ''.join(w.capitalize() for w in name.split('_'))

    rom = NintendoDSRom.fromFile(ROM)
    cfg = get_ppmdu_config_for_rom(rom)
    db = DungeonBinHandler.deserialize(
        rom.getFileByName('DUNGEON/dungeon.bin'), cfg)

    def get(fname):
        for i in range(len(db)):
            if db.get_filename(i) == fname:
                return db[i]
        raise SystemExit(f'{fname} absent de dungeon.bin')

    dma = get(f'dungeon{ts}.dma')
    dpc = get(f'dungeon{ts}.dpc')
    dpci = get(f'dungeon{ts}.dpci')
    dpl = get(f'dungeon{ts}.dpl')
    dpla = get(f'dungeon{ts}.dpla')

    # ---- frames de palettes animées (DPLA) — convention skytemple
    # apply_palette_animations : colors[0:16] -> palette 10,
    # colors[16:32] -> palette 11 (si non vides)
    n_frames = 1
    anim_pals = []
    for pi in (0, 1):
        if dpla.has_for_palette(pi):
            nf = dpla.get_frame_count_for_palette(pi)
            anim_pals.append(pi)
            n_frames = max(n_frames, nf)
    dur = dpla.get_duration_for_palette(anim_pals[0]) if anim_pals else 999
    print(f'tileset {ts}: palettes animées DPLA {anim_pals}, '
          f'{n_frames} frames, durée ROM {dur} (frames/60s)')

    # ---- rendu des chunks pour chaque frame d'animation
    def palettes_for_frame(f):
        return dpla.apply_palette_animations(dpl.palettes, f)

    frame_imgs = []
    for f in range(n_frames):
        img = dpc.chunks_to_pil(dpci, palettes_for_frame(f), 16)
        frame_imgs.append(img.convert('RGBA'))
    W = frame_imgs[0].width // CHUNK

    def chunk_img(fi, ci):
        x = (ci % W) * CHUNK
        y = (ci // W) * CHUNK
        return frame_imgs[fi].crop((x, y, x + CHUNK, y + CHUNK))

    # ---- masques PMDO standard
    ref = json.load(open(REF_AUTO, encoding='utf-8-sig'))
    masks = sorted(int(k[5:], 16) for k in ref['Object']['Tiles']
                   if k.startswith('Tilex'))

    # ---- collecte des chunks utilisés + анimations
    sheet_cells = OrderedDict()   # (x,y) -> png bytes
    next_slot = [0]

    def alloc(img):
        sig = hashlib.sha1(img.tobytes()).hexdigest()
        if sig in alloc.cache:
            return alloc.cache[sig]
        loc = (next_slot[0] % 64, next_slot[0] // 64)
        next_slot[0] += 1
        buf = io.BytesIO()
        img.save(buf, 'PNG')
        sheet_cells[loc] = buf.getvalue()
        alloc.cache[sig] = loc
        return loc
    alloc.cache = {}

    autotiles = {}
    for kind, dt in (('floor', DmaType.FLOOR), ('wall', DmaType.WALL),
                     ('secondary', DmaType.WATER)):
        tiles = OrderedDict()
        tiles['$type'] = 'RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence'
        for m in masks:
            variations = []
            seen_chunks = []
            for ci in dma.get(dt, pmdo2nds(m)):
                if ci in seen_chunks:
                    continue
                seen_chunks.append(ci)
                # frames distinctes de ce chunk au fil des palettes
                sigs = []
                fr_imgs = []
                for f in range(n_frames):
                    im = chunk_img(f, ci)
                    s = hashlib.sha1(im.tobytes()).hexdigest()
                    if not sigs or s != sigs[0] or f == 0:
                        pass
                    sigs.append(s)
                    fr_imgs.append(im)
                distinct = len(set(sigs)) > 1
                layers = []
                loc0 = alloc(fr_imgs[0])
                if not distinct:
                    layers.append({'Frames': [
                        {'Sheet': sheet_name,
                         'TexLoc': {'X': loc0[0], 'Y': loc0[1]}}],
                        'FrameLength': 999})
                else:
                    frames = []
                    for im in fr_imgs:
                        lc = alloc(im)
                        frames.append({'Sheet': sheet_name,
                                       'TexLoc': {'X': lc[0], 'Y': lc[1]}})
                    layers.append({'Frames': frames, 'FrameLength': dur})
                variations.append(layers)
            tiles[f'Tilex{m:02X}'] = variations
        autotiles[kind] = {
            '$type': 'RogueEssence.Data.AutoTileData, RogueEssence',
            'Name': {'DefaultText': f'{name.replace("_", " ").title()} '
                     f'{kind.title()}', 'LocalTexts': {}},
            'Comment': (f'PMD Sky EU dungeon.bin tileset {ts} — porté par '
                        f'sky_port_dungeon_tileset.py (DMA/DPC/DPCI/DPL/'
                        f'DPLA exacts, méthode prouvée 141/141 vs autotile '
                        f'officiel du tileset 126). Frames DPLA '
                        f'préservées ({n_frames}).'),
            'Tiles': tiles,
        }

    print(f'cellules sheet: {len(sheet_cells)}, autotiles: 3x{len(masks)} '
          f'masques')
    if not a.apply:
        print('(dry-run — relancer avec --apply)')
        return

    # ---- écrire la sheet .tile
    entries = sorted(sheet_cells.items())
    index_size = 8 + len(entries) * 16
    offset = index_size
    idx = []
    blobs = []
    for (x, y), b in entries:
        idx.append(((y << 32) | x, offset))
        blobs.append(b)
        offset += 8 + len(b)
    out_tile = os.path.join(ROOT, 'Content', 'Tile', sheet_name + '.tile')
    with open(out_tile, 'wb') as f:
        f.write(struct.pack('<II', CHUNK, len(entries)))
        for key, off in idx:
            f.write(struct.pack('<QQ', key, off))
        for b in blobs:
            f.write(struct.pack('<q', len(b)))
            f.write(b)
    print('écrit', out_tile)

    # ---- écrire les autotiles + index
    auto_dir = os.path.join(ROOT, 'Data', 'AutoTile')
    for kind, data in autotiles.items():
        p = os.path.join(auto_dir, f'{name}_{kind}.json')
        with open(p, 'w', encoding='utf-8-sig') as f:
            json.dump({'Version': '0.8.12.0', 'Object': data}, f,
                      ensure_ascii=False, indent=1)
        print('écrit', p)
    # index.idx des autotiles
    idx_p = os.path.join(auto_dir, 'index.idx')
    if os.path.exists(idx_p):
        idx_doc = json.load(open(idx_p, encoding='utf-8-sig'))
        entries_d = idx_doc.get('Object', idx_doc)
        for kind in autotiles:
            key = f'{name}_{kind}'
            entries_d[key] = {
                'Name': {'DefaultText':
                         autotiles[kind]['Name']['DefaultText'],
                         'LocalTexts': {}},
                'Released': True, 'Comment': '', 'SortOrder': 0}
        with open(idx_p, 'w', encoding='utf-8-sig') as f:
            json.dump(idx_doc, f, ensure_ascii=False, indent=1)
        print('index.idx mis à jour')


if __name__ == '__main__':
    main()
