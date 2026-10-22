#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_build_postgame_arenas.py — arènes de boss POST-GAME Sky depuis
fixed.bin (généralisation de sky_build_d45_clearing, mêmes preuves).

Sources canoniques par arène :
  * BALANCE/fixed.bin ffNN : géométrie exacte, spawns LEADER/ATTENDANT,
    entités M (ordre des EntityRule) ;
  * arm9 ov29 entity/monster tables : rule -> md_idx -> espèce (entid%600) ;
  * niveaux/espèces contre-épreuve : table mappa du donjon (le boss y est
    listé en monster house/fixed spawn au même niveau) ;
  * tileset/musique : layout mappa du donjon parent (mêmes tables que les
    zones déjà construites).
HP=0 -> stats natives moteur (jamais l'approximation).
Musiques = MUSIC_MID_MAP.json (mid du 1er étage du donjon parent,
overlay10 EU prouvé) ; mid 999 = silence ROM (musique posée par la
scène boss).
"""
import copy
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TPL_MAP = os.path.join(REPO, 'Data', 'Map', 'magma_pit_groudon.rsmap')
TPL_ZONE = os.path.join(REPO, 'Data', 'Zone', 'magma_pit_groudon.json')

# (zone_id, ffk, nom EN, nom FR, autotile base, musique, cast:[(species,
#  level)]) — espèces = entid%600 ov29 (PROUVÉ), niveaux = table mappa du donjon parent (spawn du boss, poids 10000)
ARENAS = [
    ('regigigas_chamber_boss', 17, 'Regigigas Chamber',
     'Chambre de Regigigas', 'rock_aegis_cave', 'Aegis Cave.ogg',
     [('regigigas', 45), ('hitmonlee', 45), ('bronzong', 45)]),
    ('spacial_rift_bottom', 18, 'Spacial Rift Bottom',
     'Fond de la Faille Spatiale', 'spacial_rift_2',
     'Sealed Ruin.ogg', [('palkia', 53)]),
    ('dark_crater_pit', 19, 'Dark Crater Pit',
     'Puits du Cratère Obscur', 'dark_crater_2', '',
     [('darkrai', 53), ('arbok', 49), ('magmortar', 49),
      ('magcargo', 49), ('aggron', 49), ('camerupt', 49)]),
    ('giant_volcano_peak', 20, 'Giant Volcano Peak',
     'Sommet du Volcan Géant', 'giant_volcano',
     'Dark Crater.ogg', [('heatran', 46)]),
    ('shimmer_desert_pit', 21, 'Shimmer Desert Pit',
     'Puits du Désert Chatoyant', 'shimmer_desert',
     'Northern Desert.ogg', [('groudon', 44)]),
    ('mt_avalanche_peak', 22, 'Mt. Avalanche Peak',
     'Pic du Mont Avalanche', 'mt_avalanche',
     'Blizzard Island Rescue Team Medley.ogg', [('articuno', 46)]),
    ('bottomless_sea_depths', 23, 'Bottomless Sea Depths',
     'Profondeurs de la Mer sans Fond', 'bottomless_sea',
     'Lower Brine Cave.ogg', [('kyogre', 51)]),
    ('world_abyss_pit', 24, 'World Abyss Pit',
     'Puits du Gouffre du Monde', 'world_abyss_1',
     'Chasm Cave.ogg', [('giratina', 48)]),
    ('deep_mystery_jungle', 25, 'Deep Mystery Jungle',
     'Cœur de la Jungle Mystère', 'mystery_jungle_1',
     'Concealed Ruins.ogg', [('mew', 48)]),
    ('sky_stairway_apex', 26, 'Sky Stairway Apex',
     'Apogée de l\'Escalier Céleste', 'sky_stairway',
     'Crystal Cave.ogg', [('rayquaza', 50)]),
    # ---- Sky Peak + épisodes spéciaux (ff29-ff39, session 2026-08-27) —
    # espèces/niveaux = ov29 entity/monster tables × overlay10
    # FIXED_ROOM_MONSTER_SPAWN_STATS_TABLE (niveaux EXACTS ROM) ;
    # décors ts>=184 = MAP_BG images (précédent d45) -> autotile du donjon
    # parent, différence de décor documentée ; musiques = mid ROM.
    ('sky_peak_summit', 29, 'Sky Peak Summit', 'Sommet du Pic Céleste',
     'sky_peak_summit_pass_ts', 'Sky Peak Final Pass.ogg',
     [('muk', 44), ('grimer', 43), ('grimer', 43), ('muk', 44),
      ('muk', 44), ('mawile', 30, 'ally'), ('machoke', 55, 'ally'),
      ('breloom', 55, 'ally'), ('grimer', 43), ('grimer', 43),
      ('grimer', 43)]),
    ('deep_star_cave_team_rogue', 30, 'Deep Star Cave',
     'Grotte Étoile Profonde (Team Rogue)', 'deep_star_cave_ts',
     'Deep Star Cave.ogg',
     [('bagon', 8), ('gligar', 8), ('snover', 22)]),
    ('star_cave_pit', 31, 'Star Cave Pit', 'Puits de la Grotte Étoile',
     'deep_star_cave_ts', 'Deep Star Cave.ogg', [('jirachi', 16)]),
    ('fortune_ravine_pit', 32, 'Fortune Ravine Pit',
     'Puits du Ravin Fortune', 'ice_aegis_cave',
     'Fortune Ravine Depths.ogg',
     [('probopass', 10), ('vespiquen', 17), ('yanmega', 12),
      ('exploud', 9), ('claydol', 15), ('camerupt', 30)]),
    ('barren_valley_clearing', 33, 'Barren Valley Clearing',
     'Clairière de la Vallée Aride', 'sky_peak_summit_pass_ts',
     'Barren Valley.ogg',
     [('sableye', 38), ('sableye', 38), ('sableye', 38),
      ('sableye', 38)]),
    ('black_swamp', 34, 'Black Swamp', 'Marais Noir', 'dark_wasteland_ts',
     'Dusk Forest.ogg',
     [('sableye', 38), ('sableye', 38), ('sableye', 38), ('sableye', 38),
      ('sableye', 38), ('sableye', 38)]),
    ('dark_ice_mountain_pinnacle', 35, 'Dark Ice Mountain Pinnacle',
     'Cime du Mont Glace Obscur', 'dark_ice_mountain_peak_ts',
     'Dark Ice Mountain.ogg',
     [('mamoswine', 32), ('glalie', 32), ('glalie', 32), ('glalie', 32),
      ('glalie', 32)]),
    ('vast_ice_mountain_pinnacle', 36, 'Vast Ice Mountain Pinnacle',
     'Cime du Mont Glace Immense', 'vast_ice_mountain_peak_ts',
     'Vast Ice Mountain Peak.ogg', [('dialga', 48)]),
    ('boulder_quarry_clearing', 37, 'Boulder Quarry Clearing',
     'Clairière de la Carrière Rocheuse', 'deep_boulder_quarry_ts',
     'Boulder Quarry.ogg',
     [('aggron', 36), ('lairon', 28), ('lairon', 28), ('lairon', 28),
      ('lairon', 28), ('lairon', 28), ('lairon', 28)]),
    ('limestone_cavern_depths', 38, 'Limestone Cavern Depths',
     'Profondeurs de la Caverne Calcaire', 'deep_limestone_cavern_ts',
     'Deep Limestone Cavern.ogg',
     [('weavile', 33), ('arbok', 26), ('drapion', 29)]),
    ('upper_spring_cave_haunter', 39, 'Upper Spring Cave',
     'Grotte Source Supérieure (Haunter)', 'waterfall_cave',
     'Spring Cave.ogg', [('haunter', 25)]),
    ('middle_spring_cave', 40, 'Middle Spring Cave',
     'Grotte Source Médiane', 'side_path',
     'Lower Spring Cave.ogg', [('haunter', 27)]),
    ('spring_cave_pit', 41, 'Spring Cave Pit',
     'Puits de la Grotte Source', 'steam_cave',
     'Spring Cave Depths.ogg',
     [('haunter', 29), ('haunter', 29), ('haunter', 29)]),
]


def rows_from_ff(ff, EntityRule):
    W, H = ff.width, ff.height
    rows = []
    row = ''
    i = 0
    ent_i = 0
    for a in ff.actions:
        if isinstance(a, EntityRule):
            row += chr(ord('A') + ent_i)
            ent_i += 1
        else:
            n = a.tr_type.name
            if n == 'LEADER_SPAWN':
                row += 'P'
            elif n.startswith('ATTENDANT'):
                row += 'p'
            elif 'WALL' in n:
                row += '#'
            elif 'SECONDARY' in n or 'WATER' in n:
                row += '~'
            else:
                row += '.'
        i += 1
        if i % W == 0:
            rows.append(row)
            row = ''
    return rows


def main():
    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.util import get_ppmdu_config_for_rom
    from skytemple_files.common.types.file_types import FileType
    from skytemple_files.dungeon_data.fixed_bin.model import EntityRule
    rom = NintendoDSRom.fromFile(os.path.join(
        REPO, '.runtime-cache', 'sky-rom',
        'Pokemon Mystery Dungeon - Explorers of Sky (Europe) '
        '(En,Fr,De,Es,It).nds'))
    cfg = get_ppmdu_config_for_rom(rom)
    fixed = FileType.FIXED_BIN.deserialize(
        rom.getFileByName('BALANCE/fixed.bin'), static_data=cfg)

    idx_zone_p = os.path.join(REPO, 'Data', 'Zone', 'index.idx')
    idx_zone = json.load(open(idx_zone_p, encoding='utf-8-sig'))
    idx_map_p = os.path.join(REPO, 'Data', 'Map', 'index.idx')
    idx_map = json.load(open(idx_map_p, encoding='utf-8-sig')) \
        if os.path.exists(idx_map_p) else None

    for zone_id, ffk, en, fr, base, music, cast in ARENAS:
        ff = fixed.fixed_floors[ffk]
        rows = rows_from_ff(ff, EntityRule)
        W, H = len(rows[0]), len(rows)
        tpl = json.load(open(TPL_MAP, encoding='utf-8-sig'))
        obj = tpl['Object']
        model_team = copy.deepcopy(obj['MapTeams'][0])
        model_player = copy.deepcopy(model_team['Players'][0])
        comment = (f'PMD Sky EU fixed floor {ffk} — géométrie exacte '
                   f'fixed.bin {W}x{H}, cast ov29 (espèces entid%600 '
                   f'prouvées), niveaux mappa du donjon parent, HP=0 '
                   f'stats natives.')

        def tex(kind):
            suf = ('wall' if kind == '#'
                   else 'secondary' if kind == '~' else 'floor')
            return {'AutoTileset': f'{base}_{suf}', 'Associates': [],
                    'Layers': [], 'NeighborCode': -1}

        def tile(kind):
            tid = ('unbreakable' if kind == '#'
                   else 'floor')
            return {'Data': {'ID': tid, 'TileTex': tex(kind),
                             'StableTex': False},
                    'Effect': {'TileLoc': {'X': 0, 'Y': 0}, 'ID': '',
                               'Revealed': False, 'Owner': 0,
                               'TileStates': []}}
        obj['Name'] = {'DefaultText': en, 'LocalTexts': {'fr': fr}}
        obj['Comment'] = comment
        obj['AssetName'] = zone_id + '_map'
        obj['Music'] = music
        obj['Tiles'] = [[tile(rows[y][x]) for y in range(H)]
                        for x in range(W)]
        obj['DiscoveryArray'] = [[True] * H for _ in range(W)]
        obj['Layers'][0]['Tiles'] = [[tex(rows[y][x]) for y in range(H)]
                                     for x in range(W)]
        px = py = None
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if c == 'P':
                    px, py = x, y
        if px is None:  # certains ff n'ont pas de LEADER: centre
            px, py = W // 2, H - 2
        obj['EntryPoints'] = [{'Loc': {'X': px, 'Y': py}, 'Dir': 4}]
        teams = []
        allies = []
        ent_i = 0
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if 'A' <= c <= 'Z' and c != 'P':
                    entry = cast[min(ent_i, len(cast) - 1)]
                    sp, lv = entry[0], entry[1]
                    is_ally = len(entry) > 2 and entry[2] == 'ally'
                    ent_i += 1
                    team = copy.deepcopy(model_team)
                    pl = copy.deepcopy(model_player)
                    pl['BaseForm']['Species'] = sp
                    pl['Level'] = lv
                    pl['CharLoc'] = {'X': x, 'Y': y}
                    pl['MaxHPBonus'] = 0
                    if 'BaseSkills' in pl:
                        for s in pl['BaseSkills']:
                            s['SkillNum'] = ''
                    team['Players'] = [pl]
                    if is_ally:
                        # ALLY_HELP ov29 (ff29 guides Sky Peak) : équipe
                        # alliée native PMDO (ExplorerTeam AllyTeams)
                        team['$type'] = ('RogueEssence.Dungeon.'
                                         'ExplorerTeam, RogueEssence')
                        allies.append(team)
                    else:
                        teams.append(team)
        obj['MapTeams'] = teams
        obj['AllyTeams'] = allies
        out_map = os.path.join(REPO, 'Data', 'Map', zone_id + '_map.rsmap')
        json.dump(tpl, open(out_map, 'w', encoding='utf-8-sig'),
                  ensure_ascii=False, indent=1)
        # zone
        z = json.load(open(TPL_ZONE, encoding='utf-8-sig'))
        z['Object']['Name'] = {'DefaultText': en, 'LocalTexts': {'fr': fr}}
        z['Object']['Comment'] = comment
        zs = json.dumps(z, ensure_ascii=False, indent=1) \
            .replace('magma_pit_groudon', zone_id + '_map')
        json.dump(json.loads(zs), open(
            os.path.join(REPO, 'Data', 'Zone', zone_id + '.json'), 'w',
            encoding='utf-8-sig'), ensure_ascii=False, indent=1)
        # index
        o = idx_zone['Object']
        if zone_id not in o:
            e = json.loads(json.dumps(o['magma_pit_groudon'])
                           .replace('magma_pit_groudon', zone_id + '_map'))
            e['Name'] = {'DefaultText': en, 'LocalTexts': {}}
            o[zone_id] = e
        if idx_map is not None:
            mo = idx_map.get('Object', idx_map)
            if zone_id + '_map' not in mo and 'magma_pit_groudon' in mo:
                me = json.loads(json.dumps(mo['magma_pit_groudon']))
                if isinstance(me, dict) and 'Name' in me:
                    me['Name'] = {'DefaultText': en, 'LocalTexts': {}}
                mo[zone_id + '_map'] = me
        print(f'{zone_id}: ff{ffk} {W}x{H}, {len(teams)} combattants '
              f'({cast[0][0]} L{cast[0][1]}...)')
    json.dump(idx_zone, open(idx_zone_p, 'w', encoding='utf-8-sig'),
              ensure_ascii=False, indent=1)
    if idx_map is not None:
        json.dump(idx_map, open(idx_map_p, 'w', encoding='utf-8-sig'),
                  ensure_ascii=False, indent=1)
    print('index mis à jour')


if __name__ == '__main__':
    main()
