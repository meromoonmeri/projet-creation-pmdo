#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
materialise_phantoms.py — matérialise les grounds FANTÔMES d'index.idx.

Problème : 50 noms de grounds sont déclarés dans index.idx (master_zone 40,
normal_maze 10) sans fichier .rsground correspondant. Ces entrées ne peuvent
pas être retirées : elles sont ENCASTREES dans la numérotation des index de
master_zone (index 10, 70-118) que des scripts ch1-6 utilisent en dur — les
retirer renuméroterait tout et casserait les chapitres 1 à 6 (règle absolue).

Conséquence : dans le menu de voyage du mode dev (DebugWarp), sélectionner
l'un de ces index charge un ground inexistant -> crash.

Solution : matérialiser chaque nom fantôme comme un minuscule ground de
débogage (16x12 cellules, une seule planche 8x8 partagée). Les index restent
stables, le warp ne peut plus crasher, et chaque carte fantôme est
explicitement identifiable (Comment) comme placeholder de débogage.

Usage : python3 tools/materialise_phantoms.py
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import io
import json
import os
import struct

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
TILE_DIR = os.path.join(ROOT, 'Content', 'Tile')

SHEET = 'debug_placeholder_Base'
W, H = 16, 12  # cellules 8px


def empty_tile():
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': []}


def build_ground(name):
    tiles = [[empty_tile() for _ in range(H)] for _ in range(W)]
    for x in range(W):
        for y in range(H):
            tiles[x][y]['Layers'] = [{'Frames': [
                {'Sheet': SHEET, 'TexLoc': {'X': 0, 'Y': 0}}],
                'FrameLength': 60}]
    obstacles = []
    for x in range(W):
        col = []
        for y in range(H):
            blocked = (x <= 0 or y <= 0 or x >= W - 1 or y >= H - 1)
            col.append({'Bounds': {'X': x * 8, 'Y': y * 8,
                                   'Width': 8, 'Height': 8},
                        'Tags': 1 if blocked else 0})
        obstacles.append(col)
    doc = {
        'Version': '0.8.9.0',
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': name, 'LocalTexts': {}},
            'Released': True,
            'Comment': ('PLACEHOLDER DE DÉBOGAGE (mode dev). Ground fantôme '
                        'déclaré dans index.idx sans fichier d\'origine : '
                        'matérialisé pour que le warp du mode dev ne crashe '
                        'pas, sans renuméroter les index des ch1-6.'),
            'obstacles': obstacles,
            'rand': {'$type': 'RogueElements.ReRandom, RogueElements',
                     's': [0, 0, 0, 0]},
            'Status': {},
            'Background': {'$type': 'RogueEssence.Dungeon.MapBG, RogueEssence',
                           'MapLoc': {'X': 0, 'Y': 0},
                           'BGAnim': {'AnimIndex': '', 'FrameTime': 1,
                                      'StartFrame': -1, 'EndFrame': -1,
                                      'AnimDir': -1, 'Alpha': 255,
                                      'AnimFlip': 0},
                           'BGMovement': {'X': 0, 'Y': 0},
                           'Parallax': '0, 0', 'RepeatX': False,
                           'RepeatY': False},
            'BlankBG': {'AutoTileset': '', 'Associates': [], 'Layers': [],
                        'NeighborCode': -1},
            'Layers': [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                        'Tiles': tiles}],
            'AssetName': name,
            'Music': '',
            'EdgeView': 0, 'NoSwitching': False,
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True,
                             'Anims': []}],
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [],
                          'Spawners': [], 'Markers': []}],
        },
    }
    path = os.path.join(GROUND_DIR, name + '.rsground')
    with io.open(path, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    return path


def build_sheet():
    from PIL import Image
    img = Image.new('RGBA', (8, 8), (90, 90, 110, 255))
    buf = io.BytesIO()
    img.save(buf, format='PNG')
    png = buf.getvalue()
    out = bytearray()
    out += struct.pack('<II', 8, 1)
    out += struct.pack('<QQ', 0, 8 + 8 + len(png))
    out += struct.pack('<q', len(png)) + png
    path = os.path.join(TILE_DIR, SHEET + '.tile')
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return path


def main():
    idx = json.load(open(os.path.join(ROOT, 'Data', 'Zone', 'index.idx'),
                         encoding='utf-8-sig'))
    phantoms = []
    for zone_name in ('master_zone', 'normal_maze'):
        summary = idx['Object'].get(zone_name)
        if not summary:
            continue
        for g in summary['Grounds']:
            if not os.path.exists(os.path.join(GROUND_DIR, g + '.rsground')):
                phantoms.append(g)
    phantoms = sorted(set(phantoms))
    print(f'{len(phantoms)} fantômes à matérialiser')
    sheet_path = build_sheet()
    print('planche:', sheet_path)
    for name in phantoms:
        p = build_ground(name)
        print('  ', os.path.basename(p))


if __name__ == '__main__':
    main()
