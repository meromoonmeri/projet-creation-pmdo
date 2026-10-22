#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_rebuild_s13p05a_sheet.py — reconstruit Content/Tile/S13p05a_Base.tile
(panorama défilant de l'intro, MAP_BG/s13p05a) à partir de la ROM Sky EU.

Le .rsground commité (27e88ac3) référence des clés TexLoc mais la planche
.tile n'avait jamais été persistée (sandbox recyclé). On reconstruit la
planche par ASSOCIATION : pour chaque cellule (x,y) et frame f, le ground
donne la clé K(x,y,f) et la ROM donne l'image I(x,y,f) — donc sheet[K]=I.
FAIL-CLOSED : si une même clé reçoit deux images différentes, on s'arrête
(incohérence de reconstruction), on n'écrit rien.

Usage : .runtime-cache/sky-venv/bin/python dev/tools/sky_rebuild_s13p05a_sheet.py
"""
import hashlib
import io
import json
import os
import struct
import sys

from PIL import Image
from ndspy.rom import NintendoDSRom
from skytemple_files.graphics.bma.handler import BmaHandler
from skytemple_files.graphics.bpc.handler import BpcHandler
from skytemple_files.graphics.bpl.handler import BplHandler

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM = os.path.join(ROOT, '.runtime-cache', 'sky-rom',
                   'Pokemon Mystery Dungeon - Explorers of Sky (Europe) '
                   '(En,Fr,De,Es,It).nds')
GROUND = os.path.join(ROOT, 'Data', 'Ground', 's13p05a.rsground')
OUT = os.path.join(ROOT, 'Content', 'Tile', 'S13p05a_Base.tile')
CELL = 8

rom = NintendoDSRom.fromFile(ROM)
bma = BmaHandler.deserialize(rom.getFileByName('MAP_BG/s13p05a.bma'))
bpc = BpcHandler.deserialize(rom.getFileByName('MAP_BG/s13p05a.bpc'))
bpl = BplHandler.deserialize(rom.getFileByName('MAP_BG/s13p05a.bpl'))

frames = bma.to_pil(bpc, bpl, [], include_collision=False,
                    include_unknown_data_block=False, pal_ani=True)
frames = [f.convert('RGBA') for f in frames]
print(f'ROM frames: {len(frames)}, size {frames[0].size}')

with open(GROUND, encoding='utf-8-sig') as f:
    obj = json.load(f)['Object']
layer = obj['Layers'][0]['Tiles']
W, H = len(layer), len(layer[0])
print(f'ground grid {W}x{H} (attendu <= ROM {frames[0].size[0]//CELL}x'
      f'{frames[0].size[1]//CELL})')

# période d'animation totale (frames ROM), FrameLength en ticks de 1/60 —
# le générateur d'origine échantillonnait les frames ROM directement :
# pour une cellule à N frames listées, frame i <-> frame ROM
# round(i * len(frames) / N) (cycle local dédupliqué). Pour être exact on
# tente d'abord l'hypothèse simple : les listes de frames par cellule sont
# la séquence dédupliquée en ORDRE des frames ROM. On vérifie par cohérence.
sheet = {}


def img_at(fr, x, y):
    return frames[fr].crop((x * CELL, y * CELL, (x + 1) * CELL, (y + 1) * CELL))


def sig(im):
    return hashlib.sha1(im.tobytes()).hexdigest()


conflicts = 0
assigned = {}
for x in range(W):
    for y in range(H):
        cell = layer[x][y]
        for tl in cell.get('Layers', []):
            fl = tl.get('Frames', [])
            n = len(fl)
            if n == 0:
                continue
            if n == 1:
                rom_frames = [0]
            else:
                # convention convert_sky_all: liste des IMAGES DISTINCTES
                # en ordre de PREMIÈRE APPARITION au fil des frames ROM
                seen = {}
                seq = []
                for fr in range(len(frames)):
                    s = sig(img_at(fr, x, y))
                    if s not in seen:
                        seen[s] = fr
                        seq.append(fr)
                if len(seq) != n:
                    print(f'FAIL: cell ({x},{y}) ground {n} frames, '
                          f'ROM {len(seq)} images distinctes')
                    sys.exit(1)
                rom_frames = seq
            for i, fdef in enumerate(fl):
                loc = (fdef['TexLoc']['X'], fdef['TexLoc']['Y'])
                im = img_at(rom_frames[i], x, y)
                s = sig(im)
                if loc in assigned:
                    if assigned[loc] != s:
                        conflicts += 1
                        if conflicts <= 5:
                            print(f'CONFLIT clé {loc} cell ({x},{y}) frame {i}')
                else:
                    assigned[loc] = s
                    sheet[loc] = im

print(f'clés associées: {len(sheet)}, conflits: {conflicts}')
if conflicts:
    print('FAIL-CLOSED: reconstruction incohérente, rien écrit')
    sys.exit(1)

# écriture format .tile PMDO: header <II>(tile_size,count), index <QQ>*count,
# blobs <q len><png>
entries = sorted(sheet.items())
index_size = 8 + len(entries) * 16
blobs = []
offset = index_size
index = []
for (x, y), im in entries:
    buf = io.BytesIO()
    im.save(buf, 'PNG')
    b = buf.getvalue()
    index.append(((y << 32) | x, offset))
    blobs.append(b)
    offset += 8 + len(b)
with open(OUT, 'wb') as f:
    f.write(struct.pack('<II', CELL, len(entries)))
    for key, off in index:
        f.write(struct.pack('<QQ', key, off))
    for b in blobs:
        f.write(struct.pack('<q', len(b)))
        f.write(b)
print(f'OK {OUT} ({os.path.getsize(OUT)} bytes, {len(entries)} cellules)')
