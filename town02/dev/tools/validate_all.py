#!/usr/bin/env python3
"""Validation complète des salles de boss avant intégration.

Couvre les 5 salles historiques du chapitre 5 et les 4 salles mini-boss
chapitres 6-9 (générées par tools/make_miniboss_arenas.py : salle 456x456 px,
ring de 2 tuiles de murs autotile -> plancher utilitaire (48,48)-(408,408)).
"""
import json, os, struct, collections
import numpy as np

P = os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
G = os.path.join(P, 'Data/Ground')
T = os.path.join(P, 'Content/Tile')

# Points cinématiques des salles ch6-9 : spawns équipe (sud), caméras,
# positions des deux gardiens (nord), marqueur d'entrée.
MB = [(220, 348), (252, 348), (188, 364), (284, 364),
      (236, 310), (248, 220), (196, 150), (300, 138), (228, 348)]

ROOMS = {
    'vast_steppe_miniboss':     [(240 - 40, 400), (168, 400), (200, 360), (200, 300),
                                 (184, 232), (152, 200), (184, 160)],
    'vast_steppe_guardian':     [(200, 400), (168, 400), (200, 360), (200, 300),
                                 (184, 200), (184, 160)],
    'searing_tunnel_miniboss':  [(240, 440), (272, 440), (240, 380), (240, 320),
                                 (220, 232), (292, 208), (256, 200)],
    'mount_windswept_miniboss': [(240, 440), (208, 440), (240, 380), (240, 340),
                                 (180, 240), (268, 192), (224, 180)],
    # regenerate 2026-08-05 (gen_tornadus_arene.py) : salle 54x54 cellules,
    # equipe au sud, perchoir Tornadus au nord — synchronise avec le ch_5.lua
    'mount_windswept_guardian': [(176, 248), (152, 248), (200, 248),
                                 (176, 136), (176, 260)],
    'gloomy_forest_miniboss':    list(MB),
    'cloven_ruins_miniboss':     list(MB),
}

# Les arènes Ch8/Ch9 sont des .rsmap intégrées au donjon et non des
# .rsground de cinématique. Leur existence/câblage est contrôlé par
# verify_zone_index.py et par le contrôle dédié ci-dessous.
MAP_ARENAS = {
    'crystal_sanctuary_relay',
    'crystal_sanctuary_miniboss',
    'crystal_sanctuary_boss',
    'forgotten_marsh_relay',
    'forgotten_marsh_miniboss',
    'forgotten_marsh_boss',
    'palier_celeste',
    'parvis_celeste',
    'tour_ciel_sommet',
}

def reachable(mask, start):
    W, H = mask.shape
    seen = np.zeros_like(mask)
    if mask[start]:
        return seen
    st = [start]; seen[start] = True
    while st:
        x, y = st.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and not seen[nx, ny] and not mask[nx, ny]:
                seen[nx, ny] = True; st.append((nx, ny))
    return seen

ok_all = True
for name, pts in ROOMS.items():
    p = os.path.join(G, name + '.rsground')
    if not os.path.exists(p):
        print('❌ %-26s FICHIER ABSENT' % name); ok_all = False; continue
    d = json.load(open(p, encoding='utf-8-sig'))['Object']
    ts = 8 * d.get('TexSize', 1)
    W = len(d['Layers'][0]['Tiles']); H = len(d['Layers'][0]['Tiles'][0])
    ob = d['obstacles']
    GW, GH = len(ob), len(ob[0])
    mask = np.array([[ob[x][y]['Tags'] != 0 for y in range(GH)] for x in range(GW)])

    problems = []
    # 1. grille obstacles cohérente avec la taille en pixels
    if GW != W * ts // 8 or GH != H * ts // 8:
        problems.append('grille obstacles %dx%d != attendu %dx%d'
                        % (GW, GH, W * ts // 8, H * ts // 8))
    # 2. tilesets présents
    sheets = set()
    for lay in d['Layers']:
        for col in lay['Tiles']:
            for t in col:
                for tl in t.get('Layers', []):
                    for f in tl.get('Frames', []):
                        if f.get('Sheet'):
                            sheets.add(f['Sheet'])
    miss = [s for s in sheets if not os.path.exists(os.path.join(T, s + '.tile'))]
    if miss:
        problems.append('tilesets manquants %s' % miss)
    # 3. tailles de tuile cohérentes avec TexSize
    for s in sheets:
        fp = os.path.join(T, s + '.tile')
        if os.path.exists(fp):
            tsz, _ = struct.unpack('<II', open(fp, 'rb').read(8))
            if tsz != ts:
                problems.append('%s ts=%d != carte %d' % (s, tsz, ts))
    # 4. entités
    ents = d['Entities'][0] if d.get('Entities') else {}
    sp = {s['NPCName'] for s in ents.get('Spawners', [])}
    mk = {m['EntName'] for m in ents.get('Markers', [])}
    if 'Teammate1' not in sp:
        problems.append('Teammate1 absent')
    if 'Main_Entrance_Marker' not in mk:
        problems.append('Main_Entrance_Marker absent')
    # 5. positions cinématique marchables
    blocked = []
    for (px, py) in pts:
        gx, gy = px // 8, py // 8
        if gx >= GW or gy >= GH:
            blocked.append('(%d,%d) hors carte' % (px, py))
        elif mask[gx, gy]:
            blocked.append('(%d,%d) bloqué' % (px, py))
    if blocked:
        problems.append('positions: %s' % blocked)
    # 6. connexité départ -> boss
    start = (pts[0][0] // 8, pts[0][1] // 8)
    goal = (pts[-2][0] // 8, pts[-2][1] // 8)
    seen = reachable(mask, start)
    if not seen[goal]:
        problems.append('boss NON atteignable depuis le départ')
    walk = int((~mask).sum())

    status = '✅' if not problems else '❌'
    if problems:
        ok_all = False
    print('%s %-26s %2dx%-2d ts=%2d  marchable %d/%d (%.0f%%)  %d calques'
          % (status, name, W, H, ts, walk, GW * GH, 100 * walk / (GW * GH),
             len(d['Layers'])))
    for pr in problems:
        print('      → %s' % pr)

# 7. Arènes .rsmap chargées par les segments Ch8-Ch10 : présence et JSON.
for name in sorted(MAP_ARENAS):
    path = os.path.join(P, 'Data/Map', name + '.rsmap')
    try:
        data = json.load(open(path, encoding='utf-8-sig'))['Object']
        if data.get('AssetName') != name:
            print('❌ %-26s AssetName incohérent dans .rsmap' % name)
            ok_all = False
        else:
            print('✅ %-26s .rsmap présent et lisible' % name)
    except (OSError, ValueError, KeyError) as exc:
        print('❌ %-26s .rsmap invalide/absent: %s' % (name, exc))
        ok_all = False

print()
print('RÉSULTAT GLOBAL :', '✅ toutes les salles sont valides' if ok_all else '❌ corrections nécessaires')
