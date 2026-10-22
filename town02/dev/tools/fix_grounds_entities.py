#!/usr/bin/env python3
"""Corrige le placement des entités (spawners, objets, triggers) dans les grounds
de relais et de boss — conforme PMDO Tutorial Lesson 7 (placement d'entités).
Modèle canonique : searing_tunnel_midpoint (fonctionnel en jeu)."""
import json, copy, io, os

G = 'Data/Ground'

def load(p):
    return json.load(open(p, encoding='utf-8-sig'))

def save(p, d):
    # BOM UTF-8 comme les fichiers d'origine
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

# ---- templates extraits du modèle canonique searing_tunnel_midpoint ----
model = load(f'{G}/searing_tunnel_midpoint.rsground')['Object']['Entities'][0]
SPAWNER_T = copy.deepcopy([s for s in model['Spawners'] if s.get('EntName') == 'TEAMMATE_1'][0])
EXIT_T    = copy.deepcopy([o for o in model['GroundObjects'] if o['EntName'] == 'North_Exit'][0])
ROCK_T    = copy.deepcopy([o for o in model['GroundObjects'] if o['EntName'] == 'Kangaskhan_Rock'][0])
vs_rock   = load(f'{G}/vast_steppe_entrance.rsground')['Object']['Entities'][0]
ROCK_FULL = copy.deepcopy([o for o in vs_rock['GroundObjects'] if o['EntName'] == 'Kangaskhan_Rock'][0])

def mk_spawner(name, x, y, w=16, h=16, direction=4):
    s = copy.deepcopy(SPAWNER_T)
    s['NPCName'] = 'Teammate' + name[-1]
    s['EntName'] = name
    s['Direction'] = direction
    s['Collider'] = {'X': x, 'Y': y, 'Width': w, 'Height': h}
    return s

def mk_exit(name, x, y, w, h):
    o = copy.deepcopy(EXIT_T)
    o['EntName'] = name
    o['triggerType'] = 2  # Touch
    o['Collider'] = {'X': x, 'Y': y, 'Width': w, 'Height': h}
    return o

def mk_rock(x, y):
    o = copy.deepcopy(ROCK_FULL)
    o['EntName'] = 'Kangaskhan_Rock'
    o['triggerType'] = 1  # Action
    o['Collider'] = {'X': x, 'Y': y, 'Width': 24, 'Height': 24}
    return o

def walkable(obj, px, py):
    ob = obj['obstacles']
    cx, cy = px // 8, py // 8
    if cx < 0 or cy < 0 or cx >= len(ob) or cy >= len(ob[0]):
        return False
    return ob[cx][cy]['Tags'] == 0

def assert_walk(obj, name, pts):
    for (x, y) in pts:
        assert walkable(obj, x, y), f'{name}: ({x},{y}) NON walkable'

# =====================================================================
# 1. Relais ch5/ch7 famille "30x40 clairière" :
#    vast_steppe_midpoint, mount_windswept_midpoint, cloven_ruins_midpoint
#    Ouverture nord : cellules 19-22 (rangées 1-2) ; sud : cellules 24-27 (r.36-37)
# =====================================================================
for name in ['vast_steppe_midpoint', 'mount_windswept_midpoint', 'cloven_ruins_midpoint']:
    p = f'{G}/{name}.rsground'
    d = load(p); o = d['Object']; ent = o['Entities'][0]
    ent['GroundObjects'] = [
        mk_exit('North_Exit', 152, 8, 32, 16),
        mk_exit('South_Exit', 192, 288, 32, 16),
        mk_rock(144, 104),
    ]
    ent['Spawners'] = [
        mk_spawner('TEAMMATE_1', 184, 144),
        mk_spawner('TEAMMATE_2', 120, 168),
        mk_spawner('TEAMMATE_3', 184, 176),
    ]
    # marker inchangé (152,144) — vérifications
    assert_walk(o, name, [(184,144),(120,168),(184,176),(152,144),(152,112),(144,104+28),(200,292)])
    save(p, d)
    print('OK', name)

# =====================================================================
# 2. searing_tunnel_miniboss : TEAMMATE_3 (304,472) est dans un mur.
#    On le déplace sur la cellule walkable la plus proche.
# =====================================================================
p = f'{G}/searing_tunnel_miniboss.rsground'
d = load(p); o = d['Object']; ent = o['Entities'][0]
sp3 = [s for s in ent['Spawners'] if s.get('EntName') == 'TEAMMATE_3'][0]
best = None
from itertools import product
for dx, dy in sorted(product(range(-6, 7), repeat=2), key=lambda t: abs(t[0])+abs(t[1])):
    x, y = 304 + dx*8, 472 + dy*8
    if walkable(o, x, y) and walkable(o, x+8, y) and walkable(o, x, y+8) and walkable(o, x+8, y+8):
        best = (x, y); break
assert best, 'aucune cellule walkable proche'
sp3['Collider']['X'], sp3['Collider']['Y'] = best
save(p, d)
print('OK searing_tunnel_miniboss TEAMMATE_3 ->', best)

# =====================================================================
# 3. cloven_ruins_boss : spawners vides -> 3 spawners nommés walkables
#    (marker d'entrée : 152,192)
# =====================================================================
p = f'{G}/cloven_ruins_boss.rsground'
d = load(p); o = d['Object']; ent = o['Entities'][0]
ent['Spawners'] = [
    mk_spawner('TEAMMATE_1', 184, 192),
    mk_spawner('TEAMMATE_2', 120, 216),
    mk_spawner('TEAMMATE_3', 184, 224),
]
assert_walk(o, 'cloven_ruins_boss', [(184,192),(120,216),(184,224),(152,192)])
save(p, d)
print('OK cloven_ruins_boss')

# =====================================================================
# 4. Relais ch8-10 : celestial_peak_relay, crystal_sanctuary_relay,
#    forgotten_marsh_relay — même géométrie de base (30x40 fermée).
#    - retrait du marker "Kangaskhan_Statue" (dans un mur, non interactif)
#    - vrai rocher Kangourex (objet + anim + Action)
#    - North_Exit / South_Exit + 3 spawners équipiers
# =====================================================================
for name in ['celestial_peak_relay', 'crystal_sanctuary_relay', 'forgotten_marsh_relay']:
    p = f'{G}/{name}.rsground'
    d = load(p); o = d['Object']; ent = o['Entities'][0]
    ent['Markers'] = [m for m in ent.get('Markers', []) if m['EntName'] != 'Kangaskhan_Statue']
    ent['GroundObjects'] = [
        mk_exit('North_Exit', 104, 24, 40, 16),
        mk_exit('South_Exit', 80, 280, 56, 16),
        mk_rock(112, 48),
    ]
    ent['Spawners'] = [
        mk_spawner('TEAMMATE_1', 156, 84),
        mk_spawner('TEAMMATE_2', 92, 108),
        mk_spawner('TEAMMATE_3', 164, 108),
    ]
    assert_walk(o, name, [(156,84),(92,108),(164,108),(124,84),(120,40),(100,292),(120,76)])
    save(p, d)
    print('OK', name)

# =====================================================================
# 5. Boss ch8-10 + Fulgur : ajout des spawners équipiers (aucun avant)
# =====================================================================
for name in ['celestial_peak_boss', 'celestial_peak_fulgur',
             'crystal_sanctuary_boss', 'forgotten_marsh_boss']:
    p = f'{G}/{name}.rsground'
    d = load(p); o = d['Object']; ent = o['Entities'][0]
    ent['Spawners'] = [
        mk_spawner('TEAMMATE_1', 156, 84),
        mk_spawner('TEAMMATE_2', 92, 108),
        mk_spawner('TEAMMATE_3', 164, 108),
    ]
    assert_walk(o, name, [(156,84),(92,108),(164,108),(124,84)])
    save(p, d)
    print('OK', name)

print('== fix_grounds_entities terminé ==')
