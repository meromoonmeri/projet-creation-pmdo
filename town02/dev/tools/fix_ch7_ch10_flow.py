#!/usr/bin/env python3
"""Corrections de flux ch7-ch10 :
1. cloven_ruins_entrance : triggers inactifs (0) -> Touch(2)/Action(1) avec objets complets
2. Cartes de combat manquantes ch8-10 (.rsmap) générées depuis les modèles cloven validés
3. Reconstruction des 3 entrées ch8-10 (obstacles au mauvais format + entités hors bornes)
"""
import json, copy, io, os

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

# Templates d'objets sûrs (searing_tunnel_midpoint + vast_steppe_entrance, validés en jeu)
model = load('Data/Ground/searing_tunnel_midpoint.rsground')['Object']['Entities'][0]
EXIT_T = copy.deepcopy([o for o in model['GroundObjects'] if o['EntName'] == 'North_Exit'][0])
vs = load('Data/Ground/vast_steppe_entrance.rsground')['Object']['Entities'][0]
ROCK_FULL = copy.deepcopy([o for o in vs['GroundObjects'] if o['EntName'] == 'Kangaskhan_Rock'][0])
SPAWNER_T = copy.deepcopy([s for s in model['Spawners'] if s.get('EntName') == 'TEAMMATE_1'][0])

def mk_obj(name, x, y, w, h, trig):
    o = copy.deepcopy(EXIT_T)
    o['EntName'] = name; o['triggerType'] = trig
    o['Collider'] = {'X': x, 'Y': y, 'Width': w, 'Height': h}
    return o

def mk_rock(x, y):
    o = copy.deepcopy(ROCK_FULL)
    o['Collider'] = {'X': x, 'Y': y, 'Width': 24, 'Height': 24}
    return o

def mk_spawner(name, x, y):
    s = copy.deepcopy(SPAWNER_T)
    s['NPCName'] = 'Teammate' + name[-1]; s['EntName'] = name
    s['Collider'] = {'X': x, 'Y': y, 'Width': 16, 'Height': 16}
    return s

def mk_marker(name, x, y, direction=4):
    return {'EntName': name, 'Direction': direction, 'EntEnabled': True,
            'EntOrder': 0, 'InteractOrder': 0, 'triggerType': 0,
            'Collider': {'X': x, 'Y': y, 'Width': 16, 'Height': 16}}

# ============================================================
# 1. cloven_ruins_entrance : triggers 0 -> objets complets 2/1
# ============================================================
p = 'Data/Ground/cloven_ruins_entrance.rsground'
d = load(p); o = d['Object']; ent = o['Entities'][0]
ent['GroundObjects'] = [
    mk_obj('Dungeon_Entrance', 152, 16, 32, 16, 2),   # nord, ouverture walkable (cellules 19-22)
    mk_rock(144, 200),
]
ent['Spawners'] = [
    mk_spawner('TEAMMATE_1', 184, 192),
    mk_spawner('TEAMMATE_2', 120, 216),
    mk_spawner('TEAMMATE_3', 184, 224),
]
ob = o['obstacles']
def walk(px, py): return ob[px//8][py//8]['Tags'] == 0
assert walk(160, 24) and walk(152, 196+28) and walk(184,192) and walk(120,216) and walk(184,224)
save(p, d)
print('OK cloven_ruins_entrance (triggers + spawners)')

# ============================================================
# 2. Cartes .rsmap manquantes ch8-10
# ============================================================
RELAY_T = load('Data/Map/cloven_ruins_relay.rsmap')
BOSS_T  = load('Data/Map/cloven_ruins_boss.rsmap')

def gen_relay(asset, name_en, name_fr, music):
    d = copy.deepcopy(RELAY_T); o = d['Object']
    o['AssetName'] = asset
    o['Name'] = {'DefaultText': name_en, 'LocalTexts': {'fr': name_fr}}
    o['Music'] = music
    save(f'Data/Map/{asset}.rsmap', d)
    print('OK rsmap', asset)

def gen_boss(asset, name_en, name_fr, bosses, music='Boss Battle!.ogg'):
    """bosses: list of (species, nickname, level, hp, skills[4], loc(x,y))"""
    d = copy.deepcopy(BOSS_T); o = d['Object']
    o['AssetName'] = asset
    o['Name'] = {'DefaultText': name_en, 'LocalTexts': {'fr': name_fr}}
    o['Music'] = music
    base_player = copy.deepcopy(o['MapTeams'][0]['Players'][0])
    players = []
    for (sp, nick, lvl, hp, skills, (lx, ly)) in bosses:
        pl = copy.deepcopy(base_player)
        pl['CurrentForm']['Species'] = sp
        pl['BaseForm']['Species'] = sp
        pl['Nickname'] = nick
        pl['Level'] = lvl
        pl['HP'] = hp
        pl['MaxHPBonus'] = max(0, hp - 200)
        pl['serializationLoc'] = {'X': lx, 'Y': ly}
        for i, sk in enumerate(skills):
            pl['Skills'][i]['Element']['SkillNum'] = sk
            pl['BaseSkills'][i]['SkillNum'] = sk
        players.append(pl)
    o['MapTeams'][0]['Players'] = players
    save(f'Data/Map/{asset}.rsmap', d)
    print('OK rsmap', asset, [b[0] for b in bosses])

# Relais (aucun ennemi — salle sûre avec sortie)
gen_relay('crystal_sanctuary_relay', 'Crystal Sanctuary Relay', 'Relais du Sanctuaire de Cristal', 'Spring Cave.ogg')
gen_relay('forgotten_marsh_relay', 'Forgotten Marsh Relay', "Relais du Marais de l'Oubli", 'Spring Cave.ogg')
gen_relay('celestial_peak_relay', 'Celestial Peak Relay', 'Relais du Pic Céleste', 'Spring Cave.ogg')

# Boss — uniquement des skills déjà présents/validés dans les rsmaps du dépôt
gen_boss('crystal_sanctuary_boss', 'Diancie Chamber', 'Chambre de Diancie',
    [('diancie', 'Diancie', 40, 380, ['smack_down', 'iron_defense', 'zen_headbutt', 'hyper_beam'], (7, 5))])
gen_boss('forgotten_marsh_boss', 'Marsh Heart', 'Cœur du Marais',
    [('swampert', 'Laggron', 42, 420, ['body_slam', 'dig', 'take_down', 'protect'], (7, 5))])
gen_boss('celestial_peak_boss', 'Sky Altar', 'Autel des Cieux',
    [('lugia', 'Lugia', 48, 460, ['hyper_beam', 'zen_headbutt', 'agility', 'confuse_ray'], (7, 5))])
gen_boss('celestial_peak_fulgur', 'Fulgur Ridge', "Crête de l'Escouade Fulgur",
    [('luxray', 'Voltra', 38, 260, ['spark', 'bite', 'thunder_wave', 'quick_attack'], (5, 5)),
     ('lucario', 'Aegis', 38, 260, ['karate_chop', 'double_kick', 'iron_defense', 'quick_attack'], (7, 4)),
     ('heliolisk', 'Solaire', 38, 240, ['spark', 'thunder_wave', 'quick_attack', 'sand_attack'], (9, 5))])

# ============================================================
# 3. Reconstruction des 3 entrées ch8-10 (crop 30x40 de la carte source du biome)
# ============================================================
TEMPLATE = load('Data/Ground/cloven_ruins_entrance.rsground')

SOURCES = [
    ('crystal_sanctuary_entrance', 'first_core_location',
     'Crystal Sanctuary Entrance', 'Entrée du Sanctuaire de Cristal', 'Anima Core.ogg',
     'Chapter 8 — Crystal Sanctuary entrance (rebuilt: valid obstacle grid + in-bounds entities).'),
    ('forgotten_marsh_entrance', 'altere_pond',
     'Forgotten Marsh Entrance', "Entrée du Marais de l'Oubli", 'Deep Dark Crater.ogg',
     'Chapter 9 — Forgotten Marsh entrance (rebuilt: valid obstacle grid + in-bounds entities).'),
    ('celestial_peak_entrance', 'mount_windswept_entrance',
     'Celestial Peak Entrance', 'Entrée du Pic Céleste', 'Sky Peak Cave.ogg',
     'Chapter 10 — Celestial Peak entrance (rebuilt: valid obstacle grid + in-bounds entities).'),
]

CW, CH_ = 30, 40  # crop en tuiles 8px

def best_crop(src):
    ob = src['obstacles']
    SW, SH = len(ob), len(ob[0])
    best, bx, by = -1, 0, 0
    for x0 in range(0, SW - CW + 1, 2):
        for y0 in range(0, SH - CH_ + 1, 2):
            free = sum(1 for x in range(x0, x0+CW) for y in range(y0, y0+CH_) if ob[x][y]['Tags'] == 0)
            if free > best: best, bx, by = free, x0, y0
    return bx, by, best

def flood_mask(mask):
    GW, GH = len(mask), len(mask[0])
    seen = [[False]*GH for _ in range(GW)]
    # graine : première cellule walkable au centre
    import collections
    start = None
    for r in range(max(GW, GH)):
        for x in range(max(0, GW//2-r), min(GW, GW//2+r+1)):
            for y in range(max(0, GH//2-r), min(GH, GH//2+r+1)):
                if mask[x][y]: start = (x, y); break
            if start: break
        if start: break
    st = [start]; seen[start[0]][start[1]] = True
    while st:
        x, y = st.pop()
        for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
            nx, ny = x+dx, y+dy
            if 0 <= nx < GW and 0 <= ny < GH and not seen[nx][ny] and mask[nx][ny]:
                seen[nx][ny] = True; st.append((nx, ny))
    return seen

def nearest(seen, tx, ty):
    """cellule connectée la plus proche de (tx,ty), avec ses 4 voisines walkables si possible"""
    GW, GH = len(seen), len(seen[0])
    best, bd = None, 1e9
    for x in range(GW):
        for y in range(GH):
            if seen[x][y]:
                d = abs(x-tx) + abs(y-ty)
                if d < bd: bd, best = d, (x, y)
    return best

for asset, src_name, nen, nfr, music, comment in SOURCES:
    src = load(f'Data/Ground/{src_name}.rsground')['Object']
    assert src.get('TexSize', 1) == 1, src_name
    x0, y0, free = best_crop(src)
    d = copy.deepcopy(TEMPLATE); o = d['Object']
    o['AssetName'] = asset
    o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
    o['Music'] = music
    o['Comment'] = comment
    # layers croppés depuis la source (structure conservée)
    new_layers = []
    for lay in src['Layers']:
        nl = {k: v for k, v in lay.items() if k != 'Tiles'}
        nl['Tiles'] = [[copy.deepcopy(lay['Tiles'][x0+x][y0+y]) for y in range(CH_)] for x in range(CW)]
        new_layers.append(nl)
    o['Layers'] = new_layers
    # obstacles croppés
    sob = src['obstacles']
    o['obstacles'] = [[copy.deepcopy(sob[x0+x][y0+y]) for y in range(CH_)] for x in range(CW)]
    for x in range(CW):
        for y in range(CH_):
            o['obstacles'][x][y]['Bounds'] = {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}
    # bord de carte scellé (anti-sortie de map)
    for x in range(CW):
        o['obstacles'][x][0]['Tags'] = 1; o['obstacles'][x][CH_-1]['Tags'] = 1
    for y in range(CH_):
        o['obstacles'][0][y]['Tags'] = 1; o['obstacles'][CW-1][y]['Tags'] = 1
    mask = [[o['obstacles'][x][y]['Tags'] == 0 for y in range(CH_)] for x in range(CW)]
    seen = flood_mask(mask)
    # positions : entrée du donjon au nord, marker au sud, rocher au centre-ouest
    ex, ey = nearest(seen, CW//2, 3)
    mx, my = nearest(seen, CW//2, CH_-6)
    rx, ry = nearest(seen, CW//2 - 5, CH_//2)
    s1 = nearest(seen, mx+4, my); s2 = nearest(seen, mx-4, my+3); s3 = nearest(seen, mx+4, my+3)
    ent = o['Entities'][0]
    ent['GroundObjects'] = [
        mk_obj('Dungeon_Entrance', ex*8-8, ey*8, 32, 16, 2),
        mk_rock(rx*8, ry*8),
    ]
    ent['Markers'] = [mk_marker('Main_Entrance_Marker', mx*8, my*8)]
    ent['Spawners'] = [
        mk_spawner('TEAMMATE_1', s1[0]*8, s1[1]*8),
        mk_spawner('TEAMMATE_2', s2[0]*8, s2[1]*8),
        mk_spawner('TEAMMATE_3', s3[0]*8, s3[1]*8),
    ]
    save(f'Data/Ground/{asset}.rsground', d)
    print(f'OK {asset} (crop {src_name} @({x0},{y0}), walkable {free}/{CW*CH_}, entrée ({ex},{ey}), marker ({mx},{my}))')

print('== fix_ch7_ch10_flow terminé ==')
