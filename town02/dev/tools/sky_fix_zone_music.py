#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_fix_zone_music.py — réaligne la musique par étage des zones Sky
sur MUSIC_MID_MAP.json (autorité overlay10 EU × BackgroundMusicIDs
skytemple, contre-épreuves ROM — voir sky_music_mid_map.py).

Corrige la classe d'erreurs de la session précédente :
 - enum pmdsky-debug décalé de +1 au-delà de music_id 138 (identités
   fausses : spacial_rift「I Saw Something Again」→ vraie piste ROM
   B_DUN_KUUKAN_01 partagée avec Chasm Cave, etc.) ;
 - groupes RANDOM réduits à « Random Dungeon Theme 1 » alors que la ROM
   tire parmi 4 pistes canoniques NOMMÉES par groupe → on fixe la
   PREMIÈRE piste du groupe ROM (PMDO ne tire pas de piste par visite ;
   adaptation technique documentée, la piste reste dans le groupe canon).

Fail-closed : zone sans table ROM ou mid sans ogg -> rapport, pas de
modification silencieuse.
"""
import glob
import gzip
import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS', 'Tables')


def zone_to_dungeon():
    src = open(os.path.join(REPO, 'dev', 'tools',
                            'sky_compare_zones_to_rom.py')).read()
    m = re.search(r'ZONE_TO_DUNGEON = \{(.*?)\}', src, re.S)
    return dict(re.findall(r'"(\w+)":\s*"(d\d+)"', m.group(1)))


def main():
    mm = json.load(open(os.path.join(TABLES, 'MUSIC_MID_MAP.json')))['mids']

    def expected(mid):
        e = mm[str(mid)]
        if 'random_group' in e:
            return e['tracks'][0]['ogg']
        return e['ogg']

    report = {}
    for zone, dk in sorted(zone_to_dungeon().items()):
        zp = os.path.join(REPO, 'Data', 'Zone', f'{zone}.json')
        if not os.path.exists(zp):
            continue
        fs = glob.glob(os.path.join(TABLES, 'dungeons', f'{dk}_*.json.gz'))
        if not fs:
            report[zone] = {'status': 'NO_ROM_TABLE'}
            continue
        rom = json.load(gzip.open(fs[0], 'rt'))
        want = [expected(f['layout']['music_id']) for f in rom['floors']]
        if any(w is None for w in want):
            report[zone] = {'status': 'MISSING_OGG_MAPPING',
                            'mids': sorted({f['layout']['music_id']
                                            for f in rom['floors']})}
            continue
        z = json.load(open(zp, encoding='utf-8-sig'))
        idx = 0
        changed = 0
        for seg in z['Object']['Segments']:
            for fl in seg['Floors']:
                for st in fl.get('GenSteps', []):
                    v = st.get('Value', {})
                    if 'MapDataStep' in v.get('$type', ''):
                        if idx < len(want) and v.get('Music') != want[idx]:
                            v['Music'] = want[idx]
                            changed += 1
                        idx += 1
        if changed:
            json.dump(z, open(zp, 'w', encoding='utf-8'),
                      indent=2, ensure_ascii=False)
            report[zone] = {'status': 'FIXED', 'floors_changed': changed}
    fixed = sum(1 for r in report.values() if r['status'] == 'FIXED')
    out = os.path.join(TABLES, 'MUSIC_ZONE_FIX_REPORT.json')
    json.dump({'schema': 'sky-music-zone-fix/1',
               'authority': 'MUSIC_MID_MAP.json (sky_music_mid_map.py)',
               'zones': report}, open(out, 'w'), indent=1)
    print(f'zones corrigées: {fixed} — rapport {out}')
    for zone, r in report.items():
        if r['status'] != 'FIXED':
            print('ATTENTION', zone, r)


if __name__ == '__main__':
    main()
