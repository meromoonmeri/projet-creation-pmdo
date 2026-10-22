#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_fix_zone_trap_ranges.py — corrige le TileSpawnZoneStep des zones Sky
existantes dont les poids de pièges ROM VARIENT PAR ÉTAGE (défaut du
builder v1 : la table de l'étage 1 était généralisée à tout le donjon).

Patch minimal et ciblé : SEUL le TileSpawnZoneStep est réécrit, à partir
des tables ROM exactes (mappa_s.bin), avec un groupe de spawns par
signature de pièges et les plages d'étages EXACTES. Aucune autre clé de la
zone n'est modifiée.

Usage: sky_fix_zone_trap_ranges.py <dungeon> <zone_id> [--check]
"""
import argparse
import copy
import glob
import gzip
import json
import os
from collections import OrderedDict

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS',
                      'Tables')


def decumulate(pairs):
    out, prev = [], 0
    for k, w in pairs:
        out.append((k, w - prev))
        prev = w
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dungeon')
    ap.add_argument('zone_id')
    a = ap.parse_args()

    t = None
    for f in glob.glob(os.path.join(TABLES, 'dungeons',
                                    f'{a.dungeon}_*.json.gz')):
        t = json.load(gzip.open(f, 'rt'))
    if t is None:
        raise SystemExit(f'table {a.dungeon} absente')
    mapping = json.load(open(os.path.join(TABLES, 'PMDO_MAPPING.json')))
    tr_map = {k: v.get('pmdo_tile')
              for k, v in mapping['traps']['entries'].items()}

    zp = os.path.join(ROOT, 'Data', 'Zone', a.zone_id + '.json')
    doc = json.load(open(zp, encoding='utf-8-sig'))
    z = doc['Object']
    floors_rom = t['floors']

    n_patched = 0
    for s in z['Segments']:
        for st in s.get('ZoneSteps', []):
            if not st.get('$type', '').startswith(
                    'RogueEssence.LevelGen.TileSpawnZoneStep'):
                continue
            spawns = []
            tsigs = OrderedDict()
            for fi, rf in enumerate(floors_rom):
                sig = json.dumps(rf['traps'], sort_keys=True)
                tsigs.setdefault(sig, []).append(fi)
            for sig, fls in tsigs.items():
                rom_traps = decumulate(
                    list(floors_rom[fls[0]]['traps'].items()))
                ranges = []
                start = prev = fls[0]
                for fi in fls[1:]:
                    if fi == prev + 1:
                        prev = fi
                    else:
                        ranges.append((start, prev))
                        start = prev = fi
                ranges.append((start, prev))
                for (lo, hi) in ranges:
                    spawns.extend({
                        'Spawn': {'TileLoc': {'X': 0, 'Y': 0},
                                  'ID': tr_map[tr], 'Revealed': True,
                                  'Owner': 0, 'TileStates': []},
                        'Rate': w,
                        'Range': {'Min': lo, 'Max': hi + 1}}
                        for tr, w in rom_traps
                        if w > 0 and tr_map.get(tr)
                        and tr_map[tr] != 'tile_wonder')
            st['Spawns'] = spawns
            n_patched += 1
    if not n_patched:
        raise SystemExit('aucun TileSpawnZoneStep trouvé — rien à corriger')
    with open(zp, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, indent=1)
    nsig = len({json.dumps(rf['traps'], sort_keys=True)
                for rf in floors_rom})
    print(f'{a.zone_id}: TileSpawnZoneStep réécrit '
          f'({nsig} signature(s) de pièges ROM, plages par étage exactes)')


if __name__ == '__main__':
    main()
