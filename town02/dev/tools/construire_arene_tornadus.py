#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit l'étage d'arène de Tornadus (Mont Windswept, sommet).

Concept : une plateforme rocheuse d'altitude suspendue dans le ciel, au
sommet de la tour du vent. Le vide et les nuages sont en contrebas (bords
du terrain), des plateformes mènent au cœur rocheux où se déroule le
combat. Patron technique identique aux arènes de boss du ch5 (miniboss
du Mont Windswept) : grille simple, autotiles craggy_peak, boss + entrées.
"""
import json, copy, os

SRC = 'Data/Map/mount_windswept_miniboss.rsmap'
OUT = 'Data/Map/mount_windswept_guardian.rsmap'

# ---- charger le patron du miniboss
doc = json.loads(open(SRC, 'rb').read().decode('utf-8-sig'))
o = doc['Object']

W, H = 19, 19  # grille de l'arène

# ---- 1) grille de tiles (Layers) : vide partout, le terrain vient des textures
layer = {
    'Name': 'New Layer', 'Layer': 0, 'Visible': True,
    'Tiles': [[{"AutoTileset": "", "Associates": [], "Layers": [],
                "NeighborCode": -1} for _ in range(H)] for _ in range(W)]
}
o['Layers'] = [layer]

# ---- 2) textures par tuile : plateau central marchable (floor) + roche (wall)
#     Une grande plateforme rocheuse centrale, vide/nuages tout autour.
plat_x0, plat_y0, plat_x1, plat_y1 = 4, 4, 14, 14  # cœur de combat
textures = []
for y in range(H):
    row = []
    for x in range(W):
        is_plat = (plat_x0 <= x <= plat_x1) and (plat_y0 <= y <= plat_y1)
        # petit chemin de plateformes vers l'entrée (bas)
        is_path = (x in (9, 10)) and (plat_y1 < y <= H-2)
        tex = 'craggy_peak_floor' if (is_plat or is_path) else 'craggy_peak_wall'
        row.append({"Data": {"ID": "unbreakable",
                             "TileTex": {"AutoTileset": tex, "Associates": [],
                                         "Layers": [], "NeighborCode": -1},
                             "StableTex": False},
                    "Effect": {"TileLoc": {"X": x, "Y": y}, "ID": "",
                               "Revealed": False, "Owner": 0, "TileStates": []}})
    textures.append(row)
o['Tiles'] = textures

# ---- 3) boss Tornadus au centre de la plateforme
mt = o.get('MapTeams', []) or []
# nettoyer les anciens joueurs
for team in mt:
    team['Players'] = []
if not mt:
    # prendre le gabarit du miniboss (MapTeams[0])
    mt = [o['MapTeams'][0]]
o['MapTeams'] = mt
# cloner le premier boss du gabarit en Tornadus
if mt and mt[0].get('Players'):
    p = copy.deepcopy(mt[0]['Players'][0])
else:
    p = None
# construire Tornadus (le gabarit miniboss a gligar ; on change l'espèce)
import copy as _c
base_player = None
for team in [o['MapTeams'][0]]:
    if team.get('Players'):
        base_player = _c.deepcopy(team['Players'][0])
        break
# si le gabarit n'a pas de joueur, en construire un minimal
if base_player is None:
    base_player = {
        "CurrentForm": {"Species": "tornadus", "Form": 0, "Skin": "normal", "Gender": 1},
        "Level": 30, "HP": 300,
        "serializationLoc": {"X": 9, "Y": 5},
        "Skills": [], "Intrinsics": [],
    }
base_player['CurrentForm']['Species'] = 'tornadus'
base_player['CurrentForm']['Form'] = 0
base_player['CurrentForm']['Skin'] = 'normal'
base_player['CurrentForm']['Gender'] = 1
base_player['serializationLoc'] = {'X': 9, 'Y': 5}   # centre-haut de la plateforme
o['MapTeams'][0]['Players'] = [base_player]

# ---- 4) entrées (le duo) en bas, sur le chemin de plateformes
o['EntryPoints'] = [
    {'Loc': {'X': 9, 'Y': 16}, 'Dir': 4},
    {'Loc': {'X': 10, 'Y': 16}, 'Dir': 4},
]

# ---- 5) champs divers
o['AssetName'] = 'mount_windswept_guardian'
o['Name'] = {'DefaultText': 'Windscour Summit', 'LocalTexts': {'fr': 'Sommet du Mont Venteux'}}
o['Comment'] = 'Etage-arene de Tornadus (ch5). Plateforme rocheuse au sommet, nuages en contrebas. Patron des arenes de boss du ch5.'
o['Music'] = 'Boss Battle!.ogg'
o['Element'] = 'grass'

# ---- 6) écriture (sans BOM, indent 2, comme l'original)
data = json.dumps(doc, ensure_ascii=False, indent=2)
open(OUT, 'wb').write(data.encode('utf-8'))
print('Écrit', OUT, f'({W}x{H})')
print('  boss:', o['MapTeams'][0]['Players'][0]['CurrentForm']['Species'], o['MapTeams'][0]['Players'][0]['serializationLoc'])
print('  entrées:', o['EntryPoints'])
