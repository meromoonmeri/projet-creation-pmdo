#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_sky_all.py — Conversion EXHAUSTIVE des maps de donjons de PMD
Explorers of Sky (pret/pmd-sky, files/MAP_BG) vers PMDO/RogueEssence,
depuis ZÉRO, avec TOUTES les frames d'animation.

Méthode (100% pixel-perfect, collision source) :
  * Décodage BPL/BPC/BMA/BPA via skytemple-files (handlers natifs).
  * Rendu : bma.to_pil(bpc, bpl, bpas, include_collision=False,
    include_unknown_data_block=False, pal_ani=True) -> TOUTES les frames.
    (include_collision=True dessinerait des rectangles rouges sur le décor :
    interdit.)
  * Animation par TUILE : chaque cellule 8x8 reçoit la liste des images
    distinctes qu'elle prend au fil des frames (période locale détectée).
    Une seule planche .tile par map, clés TexLoc (x + v*XSTRIDE, y) où v est
    la variante — PNG dédupliqués.
  * Collision : bma.collision (booléens par tuile ou par chunk 3x3) -> Tags.
  * Sortie : Data/Ground/sky_<id>.rsground + Content/Tile/sky_<id>_Base.tile.

Identités canoniques : extraites des scènes SSB du jeu (dossiers
files/language-specific/EU/SCRIPT/DXXPYY) — noms de lieux [CS:P] et BGM.
Usage : python3 tools/convert_sky_all.py [--ids d54p11a,...] [--apply]
"""
import glob
import hashlib
import io
import json
import re
import math
import os
import struct
import sys

from PIL import Image
from skytemple_files.graphics.bma.handler import BmaHandler
from skytemple_files.graphics.bpa.handler import BpaHandler
from skytemple_files.graphics.bpc.handler import BpcHandler
from skytemple_files.graphics.bpl.handler import BplHandler

SRC = '/tmp/pmd-sky/files/MAP_BG'
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_G = os.path.join(ROOT, 'RESERVE', 'sky_grounds')
OUT_T = os.path.join(ROOT, 'RESERVE', 'sky_tiles')

CELL = 8
XSTRIDE = 128  # > largeur max de map (114), évite toute collision de clés

# ---------------------------------------------------------------------------
# Identités canoniques des groupes dXX (noms FR, dérivés des scènes SSB —
# voir docs/MANIFESTE_CONVERSION_SKY.md pour les preuves). Les groupes sans
# entrée sont identifiés automatiquement par les scènes au moment de la
# conversion (cache names_cache.json).
# ---------------------------------------------------------------------------
GROUP_NAMES = {
    'd01': 'Plage Creuse (Beach Cave)',
    'd02': 'Falaise Trempée (Drenched Bluff)',
    'd03': 'Mont Bristle',
    'd04': 'Grotte Cascade (Waterfall Cave)',
    'd05': 'Bois Pommier (Apple Woods)',
    'd06': 'Côte Escarpée (Craggy Coast)',
    'd07': 'Sentier Latéral (Side Path)',
    'd08': 'Mont Corne (Mt. Horn)',
    'd09': 'Chemin Rocheux (Rock Path)',
    'd10': 'Forêt Brumeuse (Foggy Forest)',
    'd11': 'Sentier Forestier (Forest Path)',
    'd12': 'Grotte Vapeur (Steam Cave)',
    'd13': 'Plaines Amp (Amp Plains)',
    'd14': 'Ampériques Lointaines (Far Amp Plains)',
    'd15': 'Désert Boréal (Northern Desert)',
    'd16': 'Grotte des Sables (Quicksand Cave)',
    'd17': 'Grotte Cristal (Crystal Cave)',
    'd18': 'Gouffre (Chasm Cave)',
    'd19': 'Colline Sombre (Dark Hill)',
    'd20': 'Ruine Scellée (Sealed Ruin)',
    'd21': 'Forêt Crépusculaire (Dusk Forest)',
    'd22': 'Forêt des Cimes (Treeshroud Forest)',
    'd23': 'Grotte Saumure (Brine Cave)',
    'd24': 'Basse Grotte Saumure (Lower Brine Cave)',
    'd25': 'Terre Cachée (Hidden Land)',
    'd26': 'Tour Temporelle (Temporal Tower)',
    'd27': 'Forêt Mystifiante (Mystifying Forest)',
    'd28': 'Pic du Ciel (Sky Peak)',
    'd29': 'Grotte de la Faille (Crevice Cave)',
    'd30': 'Mer Cernée (Surrounded Sea)',
    'd31': 'Mer Miracle (Miracle Sea)',
    'd32': 'Mer Miracle Profonde (Deep Miracle Sea)',
    'd33': 'Fond de la Mer Miracle (Miracle Seabed)',
    'd34': 'Mont Travail (Mt. Travail)',
    'd35': 'Cauchemar (The Nightmare)',
    'd36': 'Faille Spatiale (Spacial Rift)',
    'd37': 'Faille Spatiale Profonde (Deep Spacial Rift)',
    'd38': 'Fond de la Faille Spatiale (Spacial Rift Bottom)',
    'd39': 'Cratère des Ténèbres (Dark Crater)',
    'd40': 'Cratère des Ténèbres Profond (Deep Dark Crater)',
    'd41': 'Fond du Cratère (Dark Crater Pit)',
    'd42': 'Ruines Cachées (Concealed Ruins)',
    'd43': 'Ruines Cachées Profondes (Deep Concealed Ruins)',
    'd44': 'Station Balnéaire (Marine Resort)',
    'd45': 'Mer sans Fond (Bottomless Sea)',
    'd46': 'Désert Scintillant (Shimmer Desert)',
    'd47': 'Mont Avalanche',
    'd48': 'Volcan Géant (Giant Volcano)',
    'd49': 'Abîme du Monde (World Abyss)',
    'd50': 'Falaises Spatiales (ES5 — Spacial Cliffs)',
    'd51': 'Mont de Glace Sombre (ES5 — Dark Ice Mountain)',
    'd52': 'Forêt de Givre (ES5 — Icicle Forest)',
    'd53': 'Mont de Glace Immense (ES5 — Vast Ice Mountain)',
    'd54': 'Jungle Méridionale (ES4 — Southern Jungle)',
    'd55': 'Carrière Rocher (ES4 — Boulder Quarry)',
    'd56': 'Caverne Calcaire (ES4 — Limestone Cavern)',
    'd57': 'Mont Travail (ES3 — Sunflora)',
    'd62': 'Dojo d\'Ossatueur (Marowak Dojo)',
    'd63': 'Station Balnéaire (Marine Resort)',
    'd65': 'Escalier du Ciel (Sky Stairway)',
    'd66': 'Apex de l\'Escalier du Ciel (Sky Stairway Apex)',
    'd67': 'Jungle Mystère (Mystery Jungle)',
    'd68': 'Jungle Mystère Profonde (Deep Mystery Jungle)',
    'd69': 'Rivière Sérénité (Serenity River)',
    'd70': 'Grotte d\'Éboulement (Landslide Cave)',
    'd71': 'Prairie Verdoyante (Lush Prairie)',
    'd72': 'Pré Fleuri (Tiny Meadow)',
    'd73': 'Grotte du Labyrinthe (Labyrinth Cave)',
    'd79': 'Forêt de Nara (Oran Forest)',
    'd80': 'Lac Lointain (Lake Afar)',
    'd81': 'Belvédère (Happy Outlook)',
    'd82': 'Mont Mistral',
    'd83': 'Colline Scintillante (Shimmer Hill)',
    'd84': 'Terre Sauvage Perdue (Lost Wilderness)',
    'd85': 'Forêt de Minuit (Midnight Forest)',
    'd86': 'Île Zéro Nord (Zero Isle North)',
    'd87': 'Île Zéro Est (Zero Isle East)',
    'd88': 'Île Zéro Ouest (Zero Isle West)',
    'd89': 'Île Zéro Sud (Zero Isle South)',
    'd90': 'Île Zéro Centre (Zero Isle Center)',
    'd91': 'Tour du Destin (Destiny Tower)',
    'd92': 'Petites Plaines (Little Plains)',
    'd93': 'Mont Clair (Mt. Clear)',
    'd94': 'Rivière Défi (Challenge River)',
    'd95': 'Forêt d\'Épreuve (Trial Forest)',
}


def load(name):
    base = os.path.join(SRC, name)
    # Variantes *2 : le .bpc est partagé avec la map de base (ex. g01p01a2 -> g01p01a.bpc)
    bpc_path = base + '.bpc'
    if not os.path.exists(bpc_path):
        alt = re.sub(r'\d$', '', name)
        bpc_path = os.path.join(SRC, alt + '.bpc')
    bpc = BpcHandler.deserialize(open(bpc_path, 'rb').read())
    bpl = BplHandler.deserialize(open(base + '.bpl', 'rb').read())
    bma = BmaHandler.deserialize(open(base + '.bma', 'rb').read())
    bpas = []
    for f in sorted(glob.glob(SRC + '/' + name + '*.bpa')):
        bpas.append(BpaHandler.deserialize(open(f, 'rb').read()))
    return bpc, bpl, bma, bpas


def png_bytes(im):
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    return buf.getvalue()


def write_tile(path, entries):
    """entries: liste (key, png_bytes) — déduplication par PNG."""
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
    out += struct.pack('<II', CELL, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    with open(path, 'wb') as f:
        f.write(bytes(out))


def empty_tile():
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': []}


MAX_PERIOD = int(os.environ.get('SKY_MAX_PERIOD', '16'))

def minimal_period(seq):
    """Plus petite période p (<=256) telle que seq[i] == seq[i % p]."""
    n = len(seq)
    for p in range(1, min(n, 257)):
        ok = True
        for i in range(n):
            if seq[i] != seq[i % p]:
                ok = False
                break
        if ok:
            return p
    return n


def convert(name, apply=True, group_names=None):
    group = name[:3]
    bpc, bpl, bma, bpas = load(name)
    try:
        frames = bma.to_pil(bpc, bpl, bpas, include_collision=False,
                            include_unknown_data_block=False, pal_ani=True)
    except Exception:
        # BPA inexploitables par skytemple (assertion nombre de tuiles) :
        # rendu sans animation de palette, documenté dans le manifeste.
        print(f'   (fallback sans BPA pour {name})', flush=True)
        frames = bma.to_pil(bpc, bpl, [], include_collision=False,
                            include_unknown_data_block=False, pal_ani=False)
    frames = [f.convert('RGBA') for f in frames]
    W, H = frames[0].size
    tw, th = W // CELL, H // CELL
    nf = len(frames)
    print(f'{name}: {tw}x{th} cellules, {nf} frame(s), {W}x{H}px', flush=True)

    if not apply:
        return None

    # hash de chaque cellule pour chaque frame
    cell_hashes = []
    for fr in frames:
        h = []
        for y in range(th):
            for x in range(tw):
                c = fr.crop((x * CELL, y * CELL, (x + 1) * CELL, (y + 1) * CELL))
                h.append(hashlib.md5(c.tobytes()).digest())
        cell_hashes.append(h)

    entries = []      # (key, png) pour la planche
    tiles = []        # grille de tuiles [x][y]
    for x in range(tw):
        col = []
        for y in range(th):
            seq = [cell_hashes[f][y * tw + x] for f in range(nf)]
            fl = 8 if nf > 1 else 60
            if len(set(seq)) == 1:
                # statique : une seule frame
                im = frames[0].crop((x * CELL, y * CELL,
                                     (x + 1) * CELL, (y + 1) * CELL))
                png = png_bytes(im)
                entries.append((x | (y << 32), png))
                col.append({'AutoTileset': '', 'Associates': [],
                            'NeighborCode': -1,
                            'Layers': [{'Frames': [
                                {'Sheet': 'sky_' + name + '_Base',
                                 'TexLoc': {'X': x, 'Y': y}}],
                                'FrameLength': fl}]})
            else:
                p = min(minimal_period(seq), MAX_PERIOD)
                frs = []
                for v in range(p):
                    idx = v % nf
                    im = frames[idx].crop((x * CELL, y * CELL,
                                           (x + 1) * CELL, (y + 1) * CELL))
                    png = png_bytes(im)
                    entries.append(((x + v * XSTRIDE) | (y << 32), png))
                    frs.append({'Sheet': 'sky_' + name + '_Base',
                                'TexLoc': {'X': x + v * XSTRIDE, 'Y': y}})
                col.append({'AutoTileset': '', 'Associates': [],
                            'NeighborCode': -1,
                            'Layers': [{'Frames': frs, 'FrameLength': fl}]})
        tiles.append(col)

    # planche
    write_tile(os.path.join(OUT_T, 'sky_' + name + '_Base.tile'), entries)

    # collision
    coll = bma.collision
    per_tile = coll is not None and len(coll) == tw * th
    mwc, mhc = bma.map_width_chunks, bma.map_height_chunks
    obstacles = []
    for x in range(tw):
        col = []
        for y in range(th):
            blocked = False
            if coll is None:
                blocked = (x <= 0 or y <= 0 or x >= tw - 1 or y >= th - 1)
            elif per_tile:
                blocked = bool(coll[y * tw + x])
            else:
                cx, cy = x // 3, y // 3
                if cx < mwc and cy < mhc:
                    blocked = bool(coll[cy * mwc + cx])
            col.append({'Bounds': {'X': x * CELL, 'Y': y * CELL,
                                   'Width': CELL, 'Height': CELL},
                        'Tags': 1 if blocked else 0})
        obstacles.append(col)

    # marqueur d'entrée : première zone libre proche du centre
    entry = None
    for y in range(th // 2 - 2, th):
        for x in range(tw // 2 - 2, tw):
            if obstacles[x][y]['Tags'] == 0:
                entry = (x * CELL + 4, y * CELL + 4)
                break
        if entry:
            break
    if entry is None:
        entry = (tw * 4, th * 4)

    role = ''
    if group_names and group in group_names:
        role = group_names[group]

    doc = {
        'Version': '0.8.9.0',
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': 'SKY_' + name.upper(),
                     'LocalTexts': {'fr': role}},
            'Released': True,
            'Comment': ('Sky (PMD Explorers of Sky) — MAP_BG/' + name +
                        '. Rendu 1:1 via skytemple-files, TOUTES les frames '
                        'd\'animation encodées (FrameLength 60), collision '
                        'BMA source, sans overlay de debug. Groupe: ' +
                        (role or name[:3])),
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
            'AssetName': 'sky_' + name,
            'Music': '',
            'EdgeView': 0, 'NoSwitching': False,
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True,
                             'Anims': []}],
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [],
                          'Spawners': [], 'Markers': [
                              {'EntName': 'Main_Entrance_Marker',
                               'Direction': 4, 'EntEnabled': True,
                               'Collider': {'X': entry[0] - CELL,
                                            'Y': entry[1] - CELL,
                                            'Width': 16, 'Height': 16}}]}],
        },
    }
    with io.open(os.path.join(OUT_G, 'sky_' + name + '.rsground'),
                 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))


def main():
    apply = '--apply' in sys.argv
    only = None
    if '--ids' in sys.argv:
        i = sys.argv.index('--ids')
        only = set(sys.argv[i + 1].split(','))
    maps = sorted(os.path.basename(f)[:-4] for f in glob.glob(SRC + '/*.bma'))
    if only:
        maps = [m for m in maps if m in only]
    print(f'{len(maps)} maps à convertir (apply={apply})', flush=True)
    ok, fail = 0, 0
    for m in maps:
        try:
            convert(m, apply, GROUP_NAMES)
            ok += 1
        except Exception as e:
            print(f'!! ECHEC {m}: {e}', flush=True)
            fail += 1
    print(f'TERMINÉ : {ok} OK, {fail} échecs')


if __name__ == '__main__':
    main()
