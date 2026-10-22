#!/usr/bin/env python3
"""Vague 2 — Import de 15 donjons secondaires (ch2-10), document maître Partie 3/9.

Source : PMDODump/DumpAsset (github.com/audinowho/DumpAsset), fichiers dans
/tmp/wave2/{zones,maps}. Même méthode que la vague 1 (tools/import_wave1_dungeons.py) :
- renommage complet zone + cartes internes (IDs New Era, noms FR originaux)
- purge des events scriptés des mods sources (SV inexistants chez nous)
- renivelage vers le barème (paliers ch2-10, option (a))
- OST importés (20 nouveaux .ogg), pièges/objets vérifiés (aucun manquant :
  les items réf. sont ceux du jeu de base, nos Data/Item ne sont que des overrides)
- "Fortune Ravine.ogg" absent de la source -> substitut "Boulder Quarry.ogg"

Substitutions vs plan initial (zones inexistantes dans DumpAsset) :
  muddy_valley  -> bramble_woods  (Bois des Ronces, ch3)
  royal_garden  -> royal_halls    (Halles Royales, ch4)
  glacial_path  -> barren_tundra  (Toundra Désolée, ch8)
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, io, re, os, copy

SRC = '/tmp/wave2/zones'
MAPS = '/tmp/wave2/maps'

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

BANNED_SCRIPTS = {'Tutorial', 'Mysteriosity', 'SpawnRandomTutor', 'ShopkeeperInteract',
                  'GeodeCreviceRevisit', 'HiddenLegend', 'PairTalk', 'RoamingLegend',
                  'CastawayCaveAltEnemies', 'CastawayCaveAltMusic',
                  'CastawayCaveRevisit', 'CastawayCaveShift'}

def purge_scripts(node):
    removed = 0
    if isinstance(node, dict):
        for k, v in list(node.items()):
            if isinstance(v, list):
                keep = []
                for it in v:
                    s = None
                    if isinstance(it, dict):
                        s = it.get('Script')
                        for _k in ('Value', 'Spawn'):
                            _v = it.get(_k)
                            if not s and isinstance(_v, dict):
                                s = _v.get('Script')
                    if s in BANNED_SCRIPTS:
                        removed += 1
                        continue
                    removed += purge_scripts(it)
                    keep.append(it)
                node[k] = keep
            else:
                removed += purge_scripts(v)
    elif isinstance(node, list):
        for it in node:
            removed += purge_scripts(it)
    return removed

def scale_levels(obj_text, factor, min_lv=3, max_lv=None):
    def rep(m):
        lo, hi = int(m.group(1)), int(m.group(2))
        nlo = max(min_lv, round(lo * factor))
        nhi = max(nlo, round(hi * factor))
        if max_lv:
            nlo, nhi = min(nlo, max_lv), min(nhi, max_lv)
        return f'"Level": {{\n"Min": {nlo},\n"Max": {nhi}\n}}'
    return re.sub(r'"Level":\s*\{\s*"Min":\s*(\d+),\s*"Max":\s*(\d+)\s*\}', rep, obj_text)

# (src, new_id, name_en, name_fr, factor, max_lv, level, chapter, comment, map_renames)
ZONES = [
    (f'{SRC}/cave_of_solace.json', 'grotte_repos', 'Cave of Solace', 'Grotte du Repos',
     1.0, None, 10, 2, 'Ch2 secondary. Level-reset rest cave (spawns are relative).',
     {}),
    (f'{SRC}/bramble_woods.json', 'bois_ronces', 'Bramble Woods', 'Bois des Ronces',
     0.7, 13, 12, 3, 'Ch3 secondary. Thorny woods missions (substitute for muddy_valley).',
     {'end_bramble_woods': 'bois_ronces_fond'}),
    (f'{SRC}/royal_halls.json', 'halles_royales', 'Royal Halls', 'Halles Royales',
     1.0, None, 14, 4, 'Ch4 secondary. Guild reception halls (substitute for royal_garden).',
     {}),
    (f'{SRC}/secret_garden.json', 'jardin_secret', 'Secret Garden', 'Jardin Secret',
     0.9, 30, 14, 4, 'Ch4 secondary (long challenge). Hidden living-Anima garden teaser.',
     {}),
    (f'{SRC}/ambush_forest.json', 'foret_embuscade', 'Ambush Forest', "Forêt de l'Embuscade",
     0.5, 18, 16, 5, 'Ch5 secondary. Bandits on the expedition road.',
     {'end_ambush_forest': 'foret_embuscade_fond', 'room_ambush_item': 'room_ambush_item'}),
    (f'{SRC}/trickster_woods.json', 'bois_filou', 'Trickster Woods', 'Bois du Filou',
     0.9, 18, 16, 5, 'Ch5 secondary. Camp item thief missions.',
     {}),
    (f'{SRC}/forsaken_desert.json', 'desert_oublies', 'Forsaken Desert', 'Désert des Oubliés',
     0.75, 20, 19, 6, 'Ch6 secondary. Trail of the dried-up Anima.',
     {'end_forsaken_desert': 'desert_oublies_fond',
      'secret_forsaken_desert': 'desert_oublies_secret'}),
    (f'{SRC}/geode_crevice.json', 'crevasse_geode', 'Geode Crevice', 'Crevasse de Géode',
     1.0, 21, 19, 6, 'Ch6 secondary. Ore resonating with the Hearts.',
     {'end_geode_crevice': 'crevasse_geode_fond'}),
    (f'{SRC}/energy_garden.json', 'jardin_energie', 'Energy Garden', "Jardin d'Énergie",
     1.0, None, 22, 7, 'Ch7 secondary. Living Anima concentration (relative spawns).',
     {}),
    (f'{SRC}/barren_tundra.json', 'toundra_desolee', 'Barren Tundra', 'Toundra Désolée',
     0.62, 24, 22, 8, 'Ch8 secondary. Frozen route to the Sanctuary (substitute for glacial_path).',
     {}),
    (f'{SRC}/depleted_basin.json', 'bassin_tari', 'Depleted Basin', 'Bassin Tari',
     0.85, 26, 25, 9, 'Ch9 secondary. A basin drained of its Anima.',
     {'end_depleted_basin': 'bassin_tari_fond'}),
    (f'{SRC}/wayward_wetlands.json', 'marais_errants', 'Wayward Wetlands', 'Marais Errants',
     1.0, 26, 25, 9, 'Ch9 secondary. Approach to the Forgotten Marsh.',
     {'end_wayward_wetlands': 'marais_errants_fond'}),
    (f'{SRC}/thunderstruck_pass.json', 'col_foudre', 'Thunderstruck Pass', 'Col de la Foudre',
     1.0, 28, 27, 10, 'Ch10 secondary. Fulgur squad territory.',
     {}),
    (f'{SRC}/flyaway_cliffs.json', 'falaises_envol', 'Flyaway Cliffs', "Falaises de l'Envol",
     1.0, 28, 27, 10, 'Ch10 secondary. Celestial Peak foothills.',
     {}),
    (f'{SRC}/snowbound_path.json', 'sentier_enneige', 'Snowbound Path', 'Sentier Enneigé',
     1.0, 28, 27, 10, 'Ch10 secondary. Snowy approach to the Peak.',
     {}),
]

GENERIC_MAPS = ['boss_artifact_water', 'boss_awd', 'boss_burmy_pair', 'boss_cattle_pair',
                'boss_ditto', 'boss_eclipse', 'boss_fossil_hoenn', 'boss_fossil_kanto',
                'boss_fossil_sinnoh', 'boss_lava_plume_water', 'boss_lycanroc',
                'boss_nido_pair', 'boss_plus_minus_1', 'boss_plus_minus_2',
                'boss_poli_pair', 'boss_sand_spirit', 'boss_sandstorm_2',
                'boss_skarmbliss', 'boss_slow_pair', 'boss_tanker', 'boss_thief',
                'pattern_blob', 'pattern_bubble', 'pattern_checker',
                'pattern_checker_large', 'pattern_slash', 'pattern_squiggle',
                'pattern_teeth', 'pattern_x_repeat', 'room_ambush_item',
                'room_fairy_ring', 'room_flying_item', 'room_garden_cross_water',
                'room_labyrinth_entrance', 'room_pyramid', 'special_grass_maze',
                'special_rby_bird']

MUSIC_SUBS = {'Fortune Ravine.ogg': 'Boulder Quarry.ogg'}

if __name__ == '__main__':
    # 1. musiques ------------------------------------------------------------
    import shutil
    n_mus = 0
    for f in sorted(os.listdir('/tmp/wave2/music')):
        dst = f'Content/Music/{f}'
        if not os.path.exists(dst):
            shutil.copy(f'/tmp/wave2/music/{f}', dst)
            n_mus += 1
    print(f'musiques importées : {n_mus}')

    # 2. cartes génériques + renommées ----------------------------------------
    RENAMES_ALL = {}
    for z in ZONES:
        RENAMES_ALL.update(z[9])
    n_maps = 0
    for m in GENERIC_MAPS:
        if os.path.exists(f'Data/Map/{m}.rsmap'):
            continue
        d = load(f'{MAPS}/{m}.rsmap')
        save(f'Data/Map/{m}.rsmap', d)
        n_maps += 1
    for old, new in RENAMES_ALL.items():
        if old == new:
            continue
        d = load(f'{MAPS}/{old}.rsmap')
        d['Object']['AssetName'] = new
        save(f'Data/Map/{new}.rsmap', d)
        n_maps += 1
    print(f'cartes importées : {n_maps}')

    # 3. zones ----------------------------------------------------------------
    summaries = {}
    for src, zid, nen, nfr, factor, max_lv, level, ch, comment, renames in ZONES:
        d = load(src)
        o = d['Object']
        o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
        o['Comment'] = f'New Era ch{ch} — {comment} Source rescaled per tier chart.'
        o['Released'] = True
        o['Level'] = level
        n_purged = purge_scripts(o)
        t = json.dumps(d, ensure_ascii=False, indent=2)
        if factor != 1.0 or max_lv:
            t = scale_levels(t, factor, max_lv=max_lv)
        for old, new in renames.items():
            if old != new:
                t = t.replace(f'"{old}"', f'"{new}"')
        for old, new in MUSIC_SUBS.items():
            t = t.replace(old, new)
        with io.open(f'Data/Zone/{zid}.json', 'w', encoding='utf-8-sig') as f:
            f.write(t)
        d2 = json.loads(t)
        o2 = d2['Object']
        maps_arr = []
        total = 0
        for s in o2['Segments']:
            ty = s.get('$type', '')
            if 'LayeredSegment' in ty:
                fl = s.get('Floors')
                n = len(fl['$values']) if isinstance(fl, dict) and '$values' in fl else len(fl)
                maps_arr.append(list(range(n))); total += n
            else:
                maps_arr.append([0]); total += 1
        summaries[zid] = {
            '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
            'ExpPercent': o2.get('ExpPercent', 100), 'Level': level,
            'LevelCap': o2.get('LevelCap', False), 'KeepSkills': o2.get('KeepSkills', False),
            'TeamRestrict': o2.get('TeamRestrict', False), 'TeamSize': o2.get('TeamSize', -1),
            'MoneyRestrict': o2.get('MoneyRestrict', False), 'BagRestrict': o2.get('BagRestrict', -1),
            'KeepTreasure': o2.get('KeepTreasure', False), 'BagSize': o2.get('BagSize', -1),
            'Rescues': o2.get('Rescues', 2), 'CountedFloors': total, 'Rogue': 0,
            'Grounds': [], 'Maps': maps_arr,
            'Name': {'DefaultText': nen, 'LocalTexts': {'fr': nfr}},
            'Released': True, 'SortOrder': 0,
        }
        print(f'{zid:18s} ch{ch} L{level} floors={total} purged={n_purged}')

    # 4. index.idx ------------------------------------------------------------
    p = 'Data/Zone/index.idx'
    idx = load(p)
    for zid, s in summaries.items():
        idx['Object'][zid] = s
    save(p, idx)
    print('index.idx : +', len(summaries), 'zones')
