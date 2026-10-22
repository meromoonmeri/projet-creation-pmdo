#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_build_d45_clearing.py — d45 Mystifying Forest Clearing (épisode
spécial Sunflora) : FIXED FLOOR 11, pas un donjon procédural.

Sources canoniques :
  * BALANCE/fixed.bin ff11 : géométrie 18x16 exacte (murs/sol, spawns
    LEADER/ATTENDANT1, 9 entités M) ;
  * arm9 ov29 entity table (rules 35-43) -> monster_id -> md_idx -> espèce
    (entid, %600 pour variantes genrées) — contre-épreuve : les 9 espèces
    == les 9 monstres de la table mappa d45 (Wigglytuff/Diglett/Dugtrio/
    Sunflora/Loudred/Corphish/Chimecho/Chatot/Croagunk) ;
  * niveaux = table mappa d45 (44/14/44/44/44/18/50/51/49 — mêmes espèces,
    donc mêmes entrées) ;
  * tileset 180 = MAP_BG index 10 (bg_list.dat) = v00p03 : le décor de la
    clairière est le background v00p03 (rendu ROM) — l'arène rsmap utilise
    l'autotile mystifying_forest (le sol de la clairière), différence de
    décor pur documentée (v00p03 est une image, pas un tileset donjon).
Sortie : Data/Map/mystifying_clearing_d45.rsmap + Data/Zone/
mystifying_forest_clearing.json (LoadGen, modèle magma_pit_groudon).
"""
import copy
import json
import os

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# géométrie exacte ff11 (dump fixed.bin ci-dessus) — 18x16
ROWS = [
    "##################",
    "####.....#########",
    "###...A...########",
    "##..B...C..#######",
    "##.D.....E.#######",
    "##...p.P...#######",
    "##.F.....G.#######",
    "##...H.I...#######",
    "##.........#######",
    "###.......########",
    "####.....#########",
    "##################",
    "##################",
    "##################",
    "##################",
    "##################",
]
# lettres = ordre d'apparition des EntityRule dans ff11 (35,41,36,38,37,
# 42,43,40,39) -> espèces prouvées entid%600 + niveaux mappa d45
CAST = {
    'A': ('wigglytuff', 44), 'B': ('loudred', 44), 'C': ('chatot', 51),
    'D': ('corphish', 18), 'E': ('sunflora', 44), 'F': ('dugtrio', 44),
    'G': ('diglett', 14), 'H': ('croagunk', 49), 'I': ('chimecho', 50),
}

TPL_MAP = os.path.join(REPO, 'Data', 'Map', 'magma_pit_groudon.rsmap')
TPL_ZONE = os.path.join(REPO, 'Data', 'Zone', 'magma_pit_groudon.json')
OUT_MAP = os.path.join(REPO, 'Data', 'Map', 'mystifying_clearing_d45.rsmap')
OUT_ZONE = os.path.join(REPO, 'Data', 'Zone',
                        'mystifying_forest_clearing.json')


def main():
    tpl = json.load(open(TPL_MAP, encoding='utf-8-sig'))
    obj = tpl['Object']
    W, H = len(ROWS[0]), len(ROWS)
    # modèle d'une team (boss) à cloner
    model_team = copy.deepcopy(obj['MapTeams'][0])
    model_player = copy.deepcopy(model_team['Players'][0])

    floor_tex = {'AutoTileset': 'mystifying_forest_floor', 'Associates': [],
                 'Layers': [], 'NeighborCode': -1}
    wall_tex = {'AutoTileset': 'mystifying_forest_wall', 'Associates': [],
                'Layers': [], 'NeighborCode': -1}

    def tile(kind):
        tex = wall_tex if kind == '#' else floor_tex
        tid = 'unbreakable' if kind == '#' else 'floor'
        return {'Data': {'ID': tid, 'TileTex': copy.deepcopy(tex),
                         'StableTex': False},
                'Effect': {'TileLoc': {'X': 0, 'Y': 0}, 'ID': '',
                           'Revealed': False, 'Owner': 0,
                           'TileStates': []}}

    obj['Name'] = {'DefaultText': 'Mystifying Forest Clearing',
                   'LocalTexts': {'fr': 'Clairière de la Forêt Trompeuse'}}
    obj['Comment'] = ('PMD Sky EU d45 fixed floor 11 — géométrie exacte '
                      'fixed.bin 18x16, cast ov29 rules 35-43 == 9 '
                      'monstres mappa d45 (contre-épreuve espèces), '
                      'niveaux mappa. Décor: autotile mystifying_forest '
                      '(v00p03 est un MAP_BG image, différence '
                      'documentée). HP=0 stats natives.')
    obj['AssetName'] = 'mystifying_clearing_d45'
    obj['Music'] = 'Mystifying Forest.ogg'   # mid 32 prouvé overlay10
    obj['Tiles'] = [[tile(ROWS[y][x]) for y in range(H)] for x in range(W)]
    obj['DiscoveryArray'] = [[True] * H for _ in range(W)]
    L0 = obj['Layers'][0]
    L0['Tiles'] = [[{'AutoTileset':
                     ('mystifying_forest_wall' if ROWS[y][x] == '#'
                      else 'mystifying_forest_floor'),
                     'Associates': [], 'Layers': [], 'NeighborCode': -1}
                    for y in range(H)] for x in range(W)]
    # spawn joueur
    px = py = None
    for y, r in enumerate(ROWS):
        for x, c in enumerate(r):
            if c == 'P':
                px, py = x, y
    obj['EntryPoints'] = [{'Loc': {'X': px, 'Y': py}, 'Dir': 4}]
    # cast
    teams = []
    for y, r in enumerate(ROWS):
        for x, c in enumerate(r):
            if c in CAST:
                sp, lv = CAST[c]
                team = copy.deepcopy(model_team)
                pl = copy.deepcopy(model_player)
                pl['BaseForm']['Species'] = sp
                pl['Level'] = lv
                pl['CharLoc'] = {'X': x, 'Y': y}
                # stats natives (HP=0), pas de skills forcés
                pl['MaxHPBonus'] = 0
                if 'BaseSkills' in pl:
                    for s in pl['BaseSkills']:
                        s['SkillNum'] = ''
                team['Players'] = [pl]
                teams.append(team)
    obj['MapTeams'] = teams
    json.dump(tpl, open(OUT_MAP, 'w', encoding='utf-8-sig'),
              ensure_ascii=False, indent=1)
    print('écrit', OUT_MAP, f'({W}x{H}, {len(teams)} membres de la guilde)')

    z = json.load(open(TPL_ZONE, encoding='utf-8-sig'))
    zo = z['Object']
    zo['Name'] = {'DefaultText': 'Mystifying Forest Clearing',
                  'LocalTexts': {'fr': 'Clairière de la Forêt Trompeuse'}}
    zo['Comment'] = obj['Comment']
    s = json.dumps(z, ensure_ascii=False, indent=1)
    s = s.replace('magma_pit_groudon', 'mystifying_clearing_d45')
    json.dump(json.loads(s), open(OUT_ZONE, 'w', encoding='utf-8-sig'),
              ensure_ascii=False, indent=1)
    print('écrit', OUT_ZONE)
    # index zone
    idx_p = os.path.join(REPO, 'Data', 'Zone', 'index.idx')
    idx = json.load(open(idx_p, encoding='utf-8-sig'))
    o = idx['Object']
    if 'mystifying_forest_clearing' not in o:
        e = json.loads(json.dumps(o['magma_pit_groudon']))
        e['Name'] = {'DefaultText': 'Mystifying Forest Clearing',
                     'LocalTexts': {}}
        # remplacer refs de grounds/maps internes
        se = json.dumps(e).replace('magma_pit_groudon',
                                   'mystifying_clearing_d45')
        o['mystifying_forest_clearing'] = json.loads(se)
        json.dump(idx, open(idx_p, 'w', encoding='utf-8-sig'),
                  ensure_ascii=False, indent=1)
        print('index.idx: zone ajoutée')
    # index maps
    midx_p = os.path.join(REPO, 'Data', 'Map', 'index.idx')
    if os.path.exists(midx_p):
        midx = json.load(open(midx_p, encoding='utf-8-sig'))
        mo = midx.get('Object', midx)
        if 'mystifying_clearing_d45' not in mo and 'magma_pit_groudon' in mo:
            me = json.loads(json.dumps(mo['magma_pit_groudon']))
            if isinstance(me, dict) and 'Name' in me:
                me['Name'] = {'DefaultText': 'Mystifying Forest Clearing',
                              'LocalTexts': {}}
            mo['mystifying_clearing_d45'] = me
            json.dump(midx, open(midx_p, 'w', encoding='utf-8-sig'),
                      ensure_ascii=False, indent=1)
            print('Map/index.idx: carte ajoutée')


if __name__ == '__main__':
    main()
