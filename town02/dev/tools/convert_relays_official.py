#!/usr/bin/env python3
"""Remplace les grounds de relais par des grounds OFFICIELS PMDO.

Source documentée : https://github.com/audinowho/DumpAsset (submodule officiel de
https://github.com/audinowho/PMDODump, dump des assets du jeu de base PMDO).

Méthode (directive §§3, 6, 11) :
- ground officiel = matière première ; renommage complet (AssetName, Name fr/en, Comment) ;
- MapChars du jeu de base supprimés (aucun PNJ hérité) ;
- objets de gameplay du jeu de base (Assembly/Storage/menus...) remplacés par le
  patron New Era : Kangaskhan_Rock (Action) + North_Exit/South_Exit (Touch) ;
- objets décoratifs (tentes, feux, pots...) conservés mais neutralisés (trigger 0) ;
- spawners TEAMMATE_1..3 officiels conservés ou repositionnés sur cellules walkables ;
- collisions officielles conservées telles quelles (elles sont correctes par construction) ;
- chaque position vérifiée par is_cell_walkable + connexité (audit §11.2 rejoué ensuite).
"""
import json, copy, io, os

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

OFF = '/tmp/official'

# Templates New Era (objets déjà validés en jeu)
_model = load('Data/Ground/searing_tunnel_midpoint.rsground')['Object']['Entities'][0]
EXIT_T = copy.deepcopy([o for o in _model['GroundObjects'] if o['EntName'] == 'North_Exit'][0])
_vs = load('Data/Ground/vast_steppe_entrance.rsground')['Object']['Entities'][0]
ROCK_T = copy.deepcopy([o for o in _vs['GroundObjects'] if o['EntName'] == 'Kangaskhan_Rock'][0])
SPAWN_T = copy.deepcopy([s for s in _model['Spawners'] if s.get('EntName') == 'TEAMMATE_1'][0])

def mk_exit(name, x, y, w, h):
    o = copy.deepcopy(EXIT_T); o['EntName'] = name; o['triggerType'] = 2
    o['Collider'] = {'X': x, 'Y': y, 'Width': w, 'Height': h}
    return o

def mk_rock(x, y):
    o = copy.deepcopy(ROCK_T); o['EntName'] = 'Kangaskhan_Rock'; o['triggerType'] = 1
    o['Collider'] = {'X': x, 'Y': y, 'Width': 24, 'Height': 24}
    return o

def mk_spawner(name, x, y):
    s = copy.deepcopy(SPAWN_T)
    s['NPCName'] = 'Teammate' + name[-1]; s['EntName'] = name
    s['Collider'] = {'X': x, 'Y': y, 'Width': 16, 'Height': 16}
    return s

def mk_marker(name, x, y, direction=4):
    return {'EntName': name, 'Direction': direction, 'EntEnabled': True,
            'EntOrder': 0, 'InteractOrder': 0, 'triggerType': 0,
            'Collider': {'X': x, 'Y': y, 'Width': 16, 'Height': 16}}

def mask_of(o):
    ob = o['obstacles']; GW, GH = len(ob), len(ob[0])
    return [[ob[x][y]['Tags'] == 0 for y in range(GH)] for x in range(GW)], GW, GH

def walk(o, x, y):
    m, GW, GH = mask_of(o)
    cx, cy = int(x)//8, int(y)//8
    return 0 <= cx < GW and 0 <= cy < GH and m[cx][cy]

def nearest_walk(o, tx, ty):
    m, GW, GH = mask_of(o)
    best, bd = None, 1e18
    for x in range(GW):
        for y in range(GH):
            if m[x][y]:
                d = (x*8-tx)**2 + (y*8-ty)**2
                if d < bd: bd, best = d, (x*8, y*8)
    return best

DECOR_KEEP = ('Tent','Campfire','Pot','Tree_Town','Fence','Logs','Stump','Trunk',
              'Sign','Statue','LogPile','Berry','Block_Gate','Ferry','Gracidea')

def convert(src, dst, name_en, name_fr, music, keep_exits, new_objs, markers,
            spawners, comment, keep_decor=True):
    """keep_exits: {officiel: nouveau_nom} ; new_objs: objets à ajouter ;
    markers/spawners: listes à ajouter (les officiels TEAMMATE sont gardés si spawners=None)."""
    d = load(f'{OFF}/{src}.rsground'); o = d['Object']
    o['AssetName'] = dst
    o['Name'] = {'DefaultText': name_en, 'LocalTexts': {'fr': name_fr}}
    o['Music'] = music
    o['Comment'] = comment
    o['Released'] = False
    ent = o['Entities'][0]
    # 1. aucun PNJ hérité du jeu de base
    ent['MapChars'] = []
    # 2. objets
    kept = []
    for g in ent['GroundObjects']:
        nm = g['EntName']
        if nm in keep_exits:
            g = copy.deepcopy(g); g['EntName'] = keep_exits[nm]; g['triggerType'] = 2
            kept.append(g)
        elif keep_decor and any(nm.startswith(k) for k in DECOR_KEEP):
            g = copy.deepcopy(g); g['triggerType'] = 0  # décor pur, plus d'action
            kept.append(g)
        # Assembly/Storage/menus/boutiques/triggers scriptés du jeu de base : supprimés
    ent['GroundObjects'] = kept + new_objs
    # 3. markers : officiels conservés + les nôtres
    have = {m['EntName'] for m in ent['Markers']}
    for mk in markers:
        if mk['EntName'] not in have:
            ent['Markers'].append(mk)
    # 4. spawners
    if spawners is not None:
        ent['Spawners'] = spawners
    else:
        ent['Spawners'] = [s for s in ent['Spawners']
                           if s.get('EntName') in ('TEAMMATE_1','TEAMMATE_2','TEAMMATE_3')]
    # 5. contrôles
    for g in ent['GroundObjects']:
        c = g['Collider']
        assert c['X'] < len(o['obstacles'])*8 and c['Y'] < len(o['obstacles'][0])*8 + 8, \
            f"{dst}:{g['EntName']} hors carte"
    for s in ent['Spawners']:
        c = s['Collider']
        assert walk(o, c['X']+8, c['Y']+8), f"{dst}:{s['EntName']} non walkable"
    for mk in ent['Markers']:
        c = mk['Collider']
        assert walk(o, c['X']+8, c['Y']+8), f"{dst}:{mk['EntName']} non walkable"
    save(f'Data/Ground/{dst}.rsground', d)
    W = len(o['Layers'][0]['Tiles']); H = len(o['Layers'][0]['Tiles'][0]); ts = 8*o.get('TexSize',1)
    print(f'OK {dst:28s} <- {src:22s} {W*ts}x{H*ts}px music={music}')

SRC = 'Grounds officiels PMDO — source: github.com/audinowho/DumpAsset (PMDODump). '

# ============================================================
# 1. vast_steppe_midpoint <- cliff_camp (falaises herbeuses = steppe)
# ============================================================
convert('cliff_camp', 'vast_steppe_midpoint',
    'Vast Steppe Relay', 'Relais Grande Steppe', 'Cliff Camp.ogg',
    {'East_Exit': 'North_Exit', 'West_Exit': 'South_Exit'},
    [mk_rock(696, 216)],
    [mk_marker('Main_Entrance_Marker', 388, 268, 6)],
    None,
    SRC + 'cliff_camp -> relais ch5 Grande Steppe. Exits E/W -> continuer/retour.')

# ============================================================
# 2. mount_windswept_midpoint <- canyon_camp (canyon rocheux = montagne)
# ============================================================
convert('canyon_camp', 'mount_windswept_midpoint',
    'Mount Windswept Relay', 'Relais Mont Venteux', 'Canyon Camp.ogg',
    {'East_Exit': 'North_Exit', 'West_Exit': 'South_Exit'},
    [mk_rock(984, 352)],
    [mk_marker('Main_Entrance_Marker', 836, 384, 6)],
    None,
    SRC + 'canyon_camp -> relais ch5 Mont Venteux. Exits E/W -> continuer/retour.')

# ============================================================
# 3. crooked_cavern_midpoint <- rest_stop (halte caverne officielle)
# ============================================================
convert('rest_stop', 'crooked_cavern_midpoint',
    'Crooked Cavern Relay', 'Relais Caverne Tortueuse', 'Cave Camp.ogg',
    {'North_Exit': 'North_Exit', 'South_Exit': 'South_Exit'},
    [mk_rock(288, 144)],
    [mk_marker('Main_Entrance_Marker', 188, 272), mk_marker('entrance', 188, 272)],
    [mk_spawner('TEAMMATE_1', 220, 272), mk_spawner('TEAMMATE_2', 156, 300),
     mk_spawner('TEAMMATE_3', 220, 300)],
    SRC + 'rest_stop -> relais ch3 Caverne Tortueuse. Cinematiques ch3 conservees (coords verifiees).')

# ============================================================
# 4. gloomy_forest_midpoint <- forest_camp (clairiere forestiere officielle)
# ============================================================
convert('forest_camp', 'gloomy_forest_midpoint',
    'Gloomy Forest Relay', 'Relais Foret Lugubre', 'Mystifying Forest.ogg',
    {'North_Exit': 'North_Exit'},   # pas de retour arriere (spec ch6) ; Secret_Exit/gates supprimes
    [mk_rock(352, 112)],
    [mk_marker('Main_Entrance_Marker', 292, 270), mk_marker('entrance', 292, 270)],
    None,
    SRC + 'forest_camp -> relais ch6 Foret Lugubre. Sortie unique vers les profondeurs; zone secrete condamnee.')

# ============================================================
# 5. cloven_ruins_midpoint <- end_moonlit_temple (temple ancien = ruines)
# ============================================================
convert('end_moonlit_temple', 'cloven_ruins_midpoint',
    'Aegis Cave Relay', 'Relais Aegis Cave', 'In the Depths of the Pit.ogg',
    {'South_Exit': 'South_Exit', 'Cutscene_Trigger': 'North_Exit'},
    [mk_rock(188, 312)],
    [mk_marker('Main_Entrance_Marker', 196, 440)],
    [mk_spawner('TEAMMATE_1', 228, 440), mk_spawner('TEAMMATE_2', 160, 440),
     mk_spawner('TEAMMATE_3', 228, 416)],
    SRC + 'end_moonlit_temple -> relais ch7 Aegis Cave. Trigger cutscene reconverti en sortie nord.')

# ============================================================
# 6. crystal_sanctuary_relay <- final_stop (camp de neige = purete cristalline)
# ============================================================
d_fs = load(f'{OFF}/final_stop.rsground')['Object']
s1 = nearest_walk(d_fs, 324, 600); s2 = nearest_walk(d_fs, 260, 600); s3 = nearest_walk(d_fs, 292, 572)
convert('final_stop', 'crystal_sanctuary_relay',
    'Crystal Sanctuary Relay', 'Relais du Sanctuaire de Cristal', 'Snow Camp.ogg',
    {'North_Exit': 'North_Exit', 'South_Exit': 'South_Exit'},
    [mk_rock(424, 120)],
    [mk_marker('Main_Entrance_Marker', 292, 628)],
    [mk_spawner('TEAMMATE_1', *s1), mk_spawner('TEAMMATE_2', *s2), mk_spawner('TEAMMATE_3', *s3)],
    SRC + 'final_stop -> relais ch8 Sanctuaire de Cristal.')

# ============================================================
# 7. forgotten_marsh_relay <- end_ambush_forest (sous-bois dense = marais)
# ============================================================
convert('end_ambush_forest', 'forgotten_marsh_relay',
    'Forgotten Marsh Relay', "Relais du Marais de l'Oubli", 'Cave Camp.ogg',
    {},
    [mk_exit('North_Exit', 0, 28, 408, 8), mk_exit('South_Exit', 0, 424, 408, 8),
     mk_rock(152, 192)],
    [mk_marker('Main_Entrance_Marker', 196, 408)],
    [mk_spawner('TEAMMATE_1', 228, 380), mk_spawner('TEAMMATE_2', 160, 380),
     mk_spawner('TEAMMATE_3', 228, 408)],
    SRC + 'end_ambush_forest -> relais ch9 Marais de l Oubli. Exits nord/sud ajoutes.')

# ============================================================
# 8. celestial_peak_relay <- guildmaster_summit (sommet officiel)
#    Zone walkable réelle : bande y=176..312 (vérifiée sur le mask officiel).
# ============================================================
convert('guildmaster_summit', 'celestial_peak_relay',
    'Celestial Peak Relay', 'Relais du Pic Celeste', 'Summit.ogg',
    {'South_Exit': 'South_Exit'},
    [mk_exit('North_Exit', 144, 168, 120, 8), mk_rock(104, 240)],
    [mk_marker('Main_Entrance_Marker', 196, 304)],
    None,  # spawners officiels (160,176)/(232,176)/(196,208) : walkables, conservés
    SRC + 'guildmaster_summit -> relais ch10 Pic Celeste (corniche du sommet).')

print('== conversion terminée ==')
