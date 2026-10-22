#!/usr/bin/env python3
"""Vague 1 — Import de 7 donjons secondaires (ch1-4).

Sources documentées :
- PMDODump/DumpAsset (github.com/audinowho/DumpAsset) : tiny_tunnel, fertile_valley,
  copper_quarry, castaway_cave
- RaoKurai/ZMDO (github.com/RaoKurai/ZMDO) : mystery_grove, mystery_cave, mystery_dungeon

Méthode (directive §§3/6) :
- renommage complet zone + cartes internes (IDs New Era, noms FR originaux)
- suppression des events scriptés propres aux mods sources (Tutorial/SV.charvars,
  Mysteriosity/SV.magnagate, SpawnRandomTutor/SV.adventure.Tutors,
  CastawayCave*/SV.castaway_cave) : nos scriptvars écrasent ceux du jeu de base,
  ces SV n'existent pas chez nous -> crash garanti sinon
- renivelage vers le barème option (a) : ch1-4 = palier 1
- cartes génériques (pattern_*, room_evo_altar_*) importées telles quelles
  (infrastructure, comme les autotiles)
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

SRC = '/tmp/wave1'
MAPS = '/tmp/wave1/maps'

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

# scripts des mods sources à purger (event refs par nom)
BANNED_SCRIPTS = {'Tutorial', 'Mysteriosity', 'SpawnRandomTutor',
                  'CastawayCaveAltEnemies', 'CastawayCaveAltMusic',
                  'CastawayCaveRevisit', 'CastawayCaveShift', 'ShopkeeperInteract'}

def purge_scripts(node):
    """Supprime récursivement tout event/step dont 'Script' est banni."""
    removed = 0
    if isinstance(node, dict):
        for k, v in list(node.items()):
            if isinstance(v, list):
                keep = []
                for it in v:
                    s = None
                    if isinstance(it, dict):
                        s = it.get('Script') or (it.get('Value') or {}).get('Script') if isinstance(it.get('Value'), dict) else it.get('Script')
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
    """Rescale tous les 'Level': {Min,Max} du texte JSON."""
    def rep(m):
        lo, hi = int(m.group(1)), int(m.group(2))
        nlo = max(min_lv, round(lo * factor))
        nhi = max(nlo, round(hi * factor))
        if max_lv: nlo, nhi = min(nlo, max_lv), min(nhi, max_lv)
        return f'"Level": {{\n"Min": {nlo},\n"Max": {nhi}\n}}'
    return re.sub(r'"Level":\s*\{\s*"Min":\s*(\d+),\s*"Max":\s*(\d+)\s*\}', rep, obj_text)

ZONES = [
    # (src_file, new_id, name_en, name_fr, factor, level, chapter, comment, map_renames)
    (f'{SRC}/tiny_tunnel.json', 'petit_tunnel', 'Tiny Tunnel', 'Petit Tunnel',
     1.0, 5, 1, 'Ch1 secondary dungeon. First job-board dungeon near Metano.',
     {'end_tiny_tunnel': 'petit_tunnel_fond'}),
    (f'{SRC}/zmdo_mystery_grove.json', 'bosquet_voile', 'Veiled Grove', 'Bosquet Voilé',
     0.35, 6, 1, 'Ch1 secondary dungeon. Training grove near Metano.',
     {}),
    (f'{SRC}/zmdo_mystery_cave.json', 'grotte_mystere', 'Mystery Cave', 'Grotte du Mystère',
     0.5, 10, 2, 'Ch2 secondary dungeon. Singing crystals — foreshadows the Crystal Sanctuary (ch8).',
     {}),
    (f'{SRC}/fertile_valley.json', 'vallee_fertile', 'Fertile Valley', 'Vallée Fertile',
     0.85, 12, 2, 'Ch2 secondary dungeon. Escort missions for the Zigzaton farmers.',
     {'room_muddy_valley_entrance': 'vallee_fertile_seuil'}),
    (f'{SRC}/zmdo_mystery_dungeon.json', 'antre_enigme', 'Enigma Den', "Antre de l'Énigme",
     0.65, 13, 3, 'Ch3 secondary dungeon. Guild investigation missions.',
     {}),
    (f'{SRC}/copper_quarry.json', 'carriere_cuivre', 'Copper Quarry', 'Carrière de Cuivre',
     0.55, 13, 3, 'Ch3 secondary dungeon. Ore deliveries for Metano.',
     {'end_copper_quarry': 'carriere_cuivre_fond'}),
    (f'{SRC}/castaway_cave.json', 'grotte_echoue', 'Castaway Cave', "Grotte de l'Échoué",
     0.6, 15, 4, 'Ch4 secondary dungeon. A castaway to rescue on the coast.',
     {'room_castaway_cave_altar': 'grotte_echoue_autel'}),
]

GENERIC_MAPS = ['pattern_blob_small', 'pattern_crosshair', 'pattern_dither_three_fourth',
                'pattern_plus', 'pattern_dither_fourth', 'pattern_x',
                'room_evo_altar_small', 'room_evo_altar_diamond', 'room_evo_altar_normal',
                'special_gsc_plant', 'special_rby_fossil']

# 1. cartes génériques + cartes renommées -----------------------------------
imported_maps = []
for m in GENERIC_MAPS:
    d = load(f'{MAPS}/{m}.rsmap')
    save(f'Data/Map/{m}.rsmap', d)
    imported_maps.append(m)

RENAMES_ALL = {}
for _, _, _, _, _, _, _, _, ren in ZONES:
    RENAMES_ALL.update(ren)
for old, new in RENAMES_ALL.items():
    d = load(f'{MAPS}/{old}.rsmap')
    d['Object']['AssetName'] = new
    save(f'Data/Map/{new}.rsmap', d)
    imported_maps.append(f'{old} -> {new}')
print('maps importées:', len(imported_maps))

# 2. zones -------------------------------------------------------------------
summaries = {}
for src, zid, nen, nfr, factor, level, ch, comment, renames in ZONES:
    d = load(src)
    o = d['Object']
    o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
    o['Comment'] = f'New Era ch{ch} — {comment}'
    o['Released'] = True
    o['Level'] = level
    n_purged = purge_scripts(o)
    t = json.dumps(d, ensure_ascii=False, indent=2)
    if factor != 1.0:
        t = scale_levels(t, factor)
    for old, new in renames.items():
        t = t.replace(f'"{old}"', f'"{new}"')
    with io.open(f'Data/Zone/{zid}.json', 'w', encoding='utf-8-sig') as f:
        f.write(t)
    # résumé pour index.idx
    d2 = json.loads(t)
    o2 = d2['Object']
    maps_arr = []
    total = 0
    for s in o2['Segments']:
        ty = s.get('$type','')
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
    lv = sorted(set(re.findall(r'"Min":\s*(\d+),\s*"Max":\s*(\d+)', re.sub(r'\s+', ' ', t))), key=lambda x: int(x[0]))
    print(f'{zid:18s} ch{ch} L~{level} floors={total} purged={n_purged}')

# 3. index.idx ----------------------------------------------------------------
p = 'Data/Zone/index.idx'
idx = load(p)
for zid, s in summaries.items():
    idx['Object'][zid] = s
save(p, idx)
print('index.idx: +', list(summaries))
