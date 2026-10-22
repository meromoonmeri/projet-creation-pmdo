#!/usr/bin/env python3
from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[1];p=ROOT/'docs/canonical/MASTER_TIMELINE_CH5_CH32.json';x=json.load(open(p));rows=x['chapters'];errors=[]
if [r['chapter'] for r in rows]!=list(range(5,33)):errors.append('chapitres 5..32 non continus')
expected={5:('cloven_ruins','regigigas'),6:('gloomy_forest','zeraora'),7:('magma_cavern','groudon'),8:('waterfall_pond','diancie'),9:('bottomless_sea','kyogre'),10:('sky_tower','rayquaza'),19:('temporal_tower','dialga'),25:('spacial_rift','palkia'),26:('world_abyss','giratina')}
for ch,(zone,boss) in expected.items():
 r=next(q for q in rows if q['chapter']==ch)
 if (r['main'],r['boss'])!=(zone,boss):errors.append(f'ch{ch}: attendu {zone}/{boss}')
if 'not Primal' not in next(q['continuity'] for q in rows if q['chapter']==19):errors.append('Dialga restauré non contractualisé')
end=next(q for q in rows if q['chapter']==32)
if end['boss']!='necrozma_eternatus_arceus':errors.append('finale trois actes absente')
ch6=(ROOT/'Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua').read_text()
if 'DazzlingAegisAftermath' not in ch6 or 'Les Aegis Cave' not in ch6:errors.append('retrouvailles Team Dazzling ch6 non branchées')
print('AUDIT LOGIQUE NARRATIVE CH5-32')
print(f'{len(rows)}/28 chapitres; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
