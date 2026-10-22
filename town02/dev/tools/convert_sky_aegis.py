#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_sky_aegis.py — ⚠️ NON CANONIQUE — NE PAS UTILISER POUR cloven_ruins.

RÉVISION 2026-08-07 : les maps files/MAP_BG/d54…d61 de pret/pmd-sky ne sont
PAS les cartes d'Aegis Cave. Vérifié sur les scènes SSB du jeu (voir
RESERVE/aegis_non_canonique/README.md) : d54=Jungle Méridionale (ES4),
d55=Carrière Rocher (ES4), d56=Caverne Calcaire (ES4), d57=Mont Travail (ES3),
d58-d61=un seul template dupliqué. La table (donjon, étage) → (groupe de
cartes, map) vit dans DUNGEON/dungeon.bin, absent du dépôt pret/pmd-sky :
les vrais étages fixes d'Aegis Cave ne sont pas extractibles ici.
Les 19 grounds produits par ce script ont été purgés vers
RESERVE/aegis_non_canonique/. Ce script est conservé uniquement comme
documentation de la méthode (décodage BPL/BPC/BMA via skytemple-files).

Méthode (100% pixel-perfect, collision source) :
  * Décodage BPL/BPC/BMA via skytemple-files (BpcHandler/BplHandler/BmaHandler)
    — le BPC NDS est compressé, décompressé par le handler natif.
  * Rendu : bma.to_pil(bpc, bpl, bpas) -> frames d'images RGBA 8px/tuile.
  * Collision : bma.collision (booléens par chunk 3x3) -> grille obstacles
    Tags 1 (bloqué) / 0 (libre).
  * Sortie : .rsground (TexSize=1, cellules 8px) + .tile (planche RGBA) + markers.

Couvre les 8 donjons d'Aegis Cave (d54-d61) : 19 maps MAP_BG.
"""
import io
import json
import os
import struct
import sys

from PIL import Image
from skytemple_files.graphics.bpc.handler import BpcHandler
from skytemple_files.graphics.bpl.handler import BplHandler
from skytemple_files.graphics.bma.handler import BmaHandler

SRC = '/tmp/pmd-sky/files/MAP_BG'
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'Data')
OUT_G = os.path.join(OUT, 'Ground')
OUT_T = os.path.join(OUT, '..', 'Content', 'Tile')

# Les 19 maps d'Aegis Cave : (map, nom FR proposé, rôle)
AEGIS = [
    ('d54p11a', 'aegis_glace_entree', 'Entrée Aegis Glace (Ice Aegis Cave)'),
    ('d54p31a', 'aegis_glace_salle_zarbi', 'Salle des plaques Unown (Glace)'),
    ('d54p32a', 'aegis_glace_antechambre', 'Antichambre de Regice'),
    ('d55p11a', 'aegis_regice_entree', 'Entrée de la Chambre de Regice'),
    ('d55p21a', 'aegis_regice_autel', 'Autel de Regice'),
    ('d55p41a', 'aegis_regice_arene', 'Arène de Regice'),
    ('d56p11a', 'aegis_roche_entree', 'Entrée Aegis Roche (Rock Aegis Cave)'),
    ('d56p12a', 'aegis_roche_salle_zarbi', 'Salle des plaques Unown (Roche)'),
    ('d56p21a', 'aegis_roche_antechambre', 'Antichambre de Regirock'),
    ('d56p41a', 'aegis_regirock_arene', 'Arène de Regirock'),
    ('d57p21a', 'aegis_regirock_autel', 'Autel de Regirock'),
    ('d57p41a', 'aegis_roche_couloir_1', 'Couloir Roche 1'),
    ('d57p42a', 'aegis_roche_couloir_2', 'Couloir Roche 2'),
    ('d57p43a', 'aegis_roche_couloir_3', 'Couloir Roche 3'),
    ('d57p44a', 'aegis_roche_couloir_4', 'Couloir Roche 4'),
    ('d58p41a', 'aegis_acier_salle_zarbi', 'Salle des plaques Unown (Acier)'),
    ('d59p41a', 'aegis_registeel_arene', 'Arène de Registeel'),
    ('d60p41a', 'aegis_puits_fond', 'Puits d\'Aegis (fond)'),
    ('d61p41a', 'aegis_regigigas_arene', 'Arène de Regigigas'),
]


def load_bma(name):
    base = os.path.join(SRC, name)
    bpc = BpcHandler.deserialize(open(base + '.bpc', 'rb').read())
    bpl = BplHandler.deserialize(open(base + '.bpl', 'rb').read())
    bma = BmaHandler.deserialize(open(base + '.bma', 'rb').read())
    # BPA associés
    import glob
    bpas = []
    for f in sorted(glob.glob(SRC + '/' + name + '*.bpa')):
        bpas.append(__import__('skytemple_files.graphics.bpa.handler', fromlist=['BpaHandler']).BpaHandler.deserialize(open(f, 'rb').read()))
    return bpc, bpl, bma, bpas


def write_tile(path, img):
    """Planche .tile : tuiles 8x8 RGBA dédupliquées."""
    W, H = img.size
    cols, rows = W // 8, H // 8
    entries = []
    for y in range(rows):
        for x in range(cols):
            t = img.crop((x*8, y*8, (x+1)*8, (y+1)*8))
            buf = io.BytesIO()
            t.save(buf, 'PNG', optimize=True)
            entries.append(((x | (y << 32)), buf.getvalue()))
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = None
            order.append(png)
    header_size = 8 + len(entries) * 16
    offsets, pos = {}, header_size
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', 8, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    with open(path, 'wb') as f:
        f.write(bytes(out))


def empty_tile():
    return {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}


def convert(name, fr_name, role, apply=True):
    bpc, bpl, bma, bpas = load_bma(name)
    frames = bma.to_pil(bpc, bpl, bpas)
    img = frames[0]  # frame 0 (les anims seront ajoutées en frames multiples)
    W, H = img.size
    tw, th = W // 8, H // 8
    print(f'{name} -> {fr_name}: {tw}x{th} tuiles 8px, {len(frames)} frame(s), {W}x{H} px')

    if not apply:
        return

    # Collision : booléens par chunk (3x3 tuiles) OU par tuile selon la map.
    coll = bma.collision
    mwc, mhc = bma.map_width_chunks, bma.map_height_chunks
    no_collision = coll is None
    if not no_collision:
        # skytemple peut retourner la collision par chunk (mwc*mhc) ou
        # étendue par tuile (tw*th) selon la map — on s'adapte.
        per_tile = (len(coll) == tw * th)
        print('   collision: %d valeurs (%s)' % (len(coll), 'par tuile' if per_tile else 'par chunk'))
    obstacles = []
    for x in range(tw):
        col = []
        for y in range(th):
            blocked = False
            if no_collision:
                # Cas B documenté (port) : le BMA n'a pas de couche collision.
                # Aucune collision artificielle : seule la BORDURE est bloquée
                # (règle projet « lisibilité caméra », outil_generation_maps.md).
                blocked = (x <= 0 or y <= 0 or x >= tw - 1 or y >= th - 1)
            elif per_tile:
                blocked = coll[y * tw + x]
            else:
                cx, cy = x // 3, y // 3
                if cx < mwc and cy < mhc:
                    blocked = coll[cy * mwc + cx]
            col.append({'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8},
                        'Tags': 1 if blocked else 0})
        obstacles.append(col)
    if no_collision:
        print('   (collision BMA absente -> bordure bloquée, intérieur libre)')

    # Planche .tile
    sheet = fr_name + '_Base'
    write_tile(os.path.join(OUT_T, sheet + '.tile'), img)

    # Tuiles du ground : chaque cellule référence sa tuile dans la planche
    tiles = []
    for x in range(tw):
        col = []
        for y in range(th):
            col.append({'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
                        'Layers': [{'Frames': [{'Sheet': sheet, 'TexLoc': {'X': x, 'Y': y}}],
                                    'FrameLength': 60}]})
        tiles.append(col)

    # Marqueurs : entrée sur la première zone libre proche du centre
    entry = None
    for y in range(th // 2 - 2, th):
        for x in range(tw // 2 - 2, tw):
            if obstacles[x][y]['Tags'] == 0:
                entry = (x * 8 + 4, y * 8 + 4)
                break
        if entry:
            break
    if entry is None:
        entry = (tw * 4, th * 4)
    markers = [
        {'EntName': 'Main_Entrance_Marker', 'Direction': 4, 'EntEnabled': True,
         'Collider': {'X': entry[0] - 8, 'Y': entry[1] - 8, 'Width': 16, 'Height': 16}},
    ]

    doc = {
        'Version': '0.8.9.0',
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': fr_name, 'LocalTexts': {'fr': role}},
            'Released': True,
            'Comment': f'Aegis Cave (PMD Explorers of Sky) — {name} ({role}). '
                       'Conversion depuis pret/pmd-sky via skytemple-files : rendu '
                       'pixel-perfect, collision BMA source (0=libre, 1=bloqué).',
            'obstacles': obstacles,
            'rand': {'$type': 'RogueElements.ReRandom, RogueElements', 's': [0, 0, 0, 0]},
            'Status': {},
            'Background': {'$type': 'RogueEssence.Dungeon.MapBG, RogueEssence',
                           'MapLoc': {'X': 0, 'Y': 0},
                           'BGAnim': {'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1,
                                      'EndFrame': -1, 'AnimDir': -1, 'Alpha': 255, 'AnimFlip': 0},
                           'BGMovement': {'X': 0, 'Y': 0}, 'Parallax': '0, 0',
                           'RepeatX': False, 'RepeatY': False},
            'BlankBG': {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1},
            'Layers': [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': tiles}],
            'AssetName': fr_name,
            'Music': 'In the Depths of the Pit.ogg',
            'EdgeView': 0, 'NoSwitching': False,
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True, 'Anims': []}],
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [], 'Spawners': [], 'Markers': markers}],
        }
    }
    with io.open(os.path.join(OUT_G, fr_name + '.rsground'), 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print(f'   -> Data/Ground/{fr_name}.rsground + Content/Tile/{sheet}.tile (entrée {entry})')


if __name__ == '__main__':
    apply = '--apply' in sys.argv
    for name, fr, role in AEGIS:
        try:
            convert(name, fr, role, apply)
        except Exception as e:
            print(f'!! ECHEC {name}: {e}')
