#!/usr/bin/env python3
"""Convertit une ground map pmd-red (GBA, .bpl/.bpc/.bma) vers New Era
(.tile + .rsground RogueEssence).

Source documentée : github.com/pret/pmd-red (décompilation PMD Red Rescue Team).
Décodeurs écrits d'après le code source C de référence (src/ground_bg.c) :
  - BPL : numPalettes en tête, 15 couleurs RGBA/palette (index 0 transparent)
  - BPC : header 16 o (chunkW/H, numTiles, 4 slots BPA, numChunks),
          tuiles 4bpp 32 o, chunks 3x3 de u16 (tile|hflip|vflip|palette)
  - BMA : header 12 o, couche(s) chunk-map compressée NRL/XOR ligne à ligne
          (BmaLayerNrlDecompressor transcrit 1:1), collision lue via
          skytemple-files (format identique NDS pour cette couche)

Règle absolue respectée : AUCUNE transformation de la disposition spatiale.
Le rendu est découpé en grille identity-mapped (le standard du projet :
la tuile (x,y) du .rsground référence TexLoc{X:x,Y:y} de sa feuille dédiée),
la collision est la couche collision d'origine cellule par cellule.
"""
import struct, sys, io, json, zlib, os
from PIL import Image

sys.path.insert(0, '/tmp/pmdred_extract')
from pmdred_lib import parse_bpl, parse_bpc, decode_bma, render, get_collision

BASE = '/tmp/pmd-red/data/map_bg'


def write_tile_file(img, out_path, tile_size=8):
    """Ecrit un .tile New Era : uint32 tileSize, uint32 tileCount,
    table (uint64 key=x|(y<<32), uint64 offset absolu), a chaque offset
    uint64 len + PNG. Deduplication par contenu (partage d'offsets)."""
    W, H = img.size
    cols, rows = W // tile_size, H // tile_size
    entries = []          # (key, png_bytes)
    for y in range(rows):
        for x in range(cols):
            t = img.crop((x*tile_size, y*tile_size, (x+1)*tile_size, (y+1)*tile_size))
            buf = io.BytesIO()
            t.save(buf, 'PNG', optimize=True)
            entries.append(((x | (y << 32)), buf.getvalue()))
    # dedup
    uniq = {}
    order = []
    for key, png in entries:
        h = png
        if h not in uniq:
            uniq[h] = None
            order.append(h)
    header_size = 8 + len(entries) * 16
    offsets = {}
    pos = header_size
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', tile_size, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    open(out_path, 'wb').write(bytes(out))
    return len(entries), len(order)


def make_rsground(name, name_en, name_fr, comment, music, sheet, W, H, collision,
                  ground_objects, markers, spawners_named, out_path):
    """Construit un .rsground identity-mapped avec la collision d'origine."""
    def tile(x, y):
        return {"AutoTileset": "", "Associates": [],
                "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}],
                             "FrameLength": 60}],
                "NeighborCode": -1}
    tiles = [[tile(x, y) for y in range(H)] for x in range(W)]
    obstacles = [[{"Bounds": {"X": x*8, "Y": y*8, "Width": 8, "Height": 8},
                   "Tags": 1 if collision[y*W + x] else 0}
                  for y in range(H)] for x in range(W)]
    d = {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": 1,
            "Name": {"DefaultText": name_en, "LocalTexts": {"fr": name_fr}},
            "Released": False,
            "Comment": comment,
            "obstacles": obstacles,
            "rand": {"$type": "RogueElements.ReRandom, RogueElements",
                     "FirstSeed": 0, "s": [16294208416658607535, 7960286522194355700,
                                            4876170194715417726, 12554865158188930543]},
            "Status": {},
            "Background": {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                            "MapLoc": {"X": 0, "Y": 0},
                            "BGAnim": {"AnimIndex": "Sky", "FrameTime": 4,
                                        "StartFrame": -1, "EndFrame": -1,
                                        "AnimDir": -1, "Alpha": 255, "AnimFlip": 0},
                            "BGMovement": {"X": -1, "Y": 0}, "RepeatX": True, "RepeatY": True},
            "BlankBG": {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1},
            "Layers": [{"Name": "Base", "Layer": 0, "Visible": True, "Tiles": tiles}],
            "AssetName": name,
            "Music": music,
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "Decorations": [{"Name": "New Deco", "Layer": 0, "Visible": True,
                              "Anims": []}],
            "Entities": [{
                "Name": "New EntLayer", "Visible": True,
                "MapChars": [],
                "GroundObjects": ground_objects,
                "Spawners": spawners_named,
                "Markers": markers,
            }],
        },
    }
    with io.open(out_path, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=1)


def mk_marker(nm, x, y, direction=4):
    return {"EntName": nm, "Direction": direction, "EntEnabled": True,
            "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
            "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16}}


def mk_spawner(nm, x, y):
    # squelette identique aux spawners TEAMMATE existants du projet
    tpl = json.load(open('Data/Ground/searing_tunnel_midpoint.rsground', encoding='utf-8-sig'))
    src = [s for s in tpl['Object']['Entities'][0]['Spawners'] if s.get('EntName') == 'TEAMMATE_1'][0]
    import copy
    s = copy.deepcopy(src)
    s['NPCName'] = 'Teammate' + nm[-1]
    s['EntName'] = nm
    s['Collider'] = {"X": x, "Y": y, "Width": 16, "Height": 16}
    return s


if __name__ == '__main__':
    # ---- Zone pilote : D13P03 = Sky Tower Summit (arene Rayquaza) ----
    # Devient : autel_celeste — « Autel des Cieux », arene Lugia du Pic Celeste (ch10).
    # Positions d'origine (GroundLivesData s_gs209_g1_s0_lives, en tuiles 8 px) :
    #   hero (37,37) ; partner (32,37) ; ally1 (34,42) ; ally2 (38,41) ; RAYQUAZA (34,34)
    # Trigger de cutscene (GroundEffectData) : (34,35).
    # AUCUNE de ces positions n'est modifiee — seul le casting change (Rayquaza -> Lugia).
    NAME = 'autel_celeste'
    img, W, H = render('D13P03', None)
    # applique le fond bleu nuit de la palette 0 (index 1) comme le GBA (couleur de fond BG)
    bg = Image.new('RGBA', img.size, (0, 0, 167, 255))
    bg.alpha_composite(img)
    img = bg
    coll, cw2, ch2 = get_collision(f'{BASE}/D13P03m.bma')
    assert (cw2, ch2) == (W, H)
    n_ent, n_uniq = write_tile_file(img, f'Content/Tile/Autel_Celeste_Base.tile')
    print(f'.tile : {n_ent} cells, {n_uniq} uniques ({100-100*n_uniq//n_ent}% dedup)')

    T = 8
    ground_objects = []
    markers = [
        # positions EXACTES du script gs209 (tuiles -> px, centre halftile ~ +4)
        mk_marker('Main_Entrance_Marker', 37*T, 37*T, 0),   # hero spawn
        mk_marker('Boss_Marker',          34*T, 34*T, 4),   # Rayquaza -> Lugia
        mk_marker('Cutscene_Marker',      34*T, 35*T, 4),   # GroundEffect d'origine
    ]
    spawners = [
        mk_spawner('TEAMMATE_1', 32*T, 37*T),  # partner
        mk_spawner('TEAMMATE_2', 34*T, 42*T),  # ally 1
        mk_spawner('TEAMMATE_3', 38*T, 41*T),  # ally 2
    ]
    make_rsground(
        NAME, 'Celestial Altar', 'Autel des Cieux',
        'New Era ch10 - Lugia boss arena. Imported 1:1 from pmd-red D13P03 '
        '(Sky Tower Summit, github.com/pret/pmd-red). Geometry, entity positions '
        'and trigger logic preserved from GroundLivesData s_gs209 ; only the cast '
        'changed (Rayquaza -> Lugia).',
        'Rainbow Peak.ogg', 'Autel_Celeste_Base', W, H, coll,
        ground_objects, markers, spawners,
        f'Data/Ground/{NAME}.rsground')
    print(f'.rsground : {W}x{H} tuiles ({W*8}x{H*8}px), collision {sum(1 for c in coll if not c)} walkables')
