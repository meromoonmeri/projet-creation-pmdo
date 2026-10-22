#!/usr/bin/env python3
import json,re
from pathlib import Path
R=Path(__file__).resolve().parents[1]
z=json.loads((R/'Data/Zone/waterfall_pond.json').read_text(encoding='utf-8-sig'))['Object']
def count(i):
 return sum(n['Range']['Max']-n['Range']['Min'] for n in z['Segments'][i]['Floors']['nodes'])
pre=count(0);post=count(2)+count(4)
relay=[v['Value'].get('MapID') for f in z['Segments'][1]['Floors'] for v in f['GenSteps'] if v['Value'].get('MapID')]
boss=[v['Value'].get('MapID') for f in z['Segments'][5]['Floors'] for v in f['GenSteps'] if v['Value'].get('MapID')]
script=(R/'Data/Script/halcyon/zone/waterfall_pond/init.lua').read_text()
scene=(R/'Data/Script/halcyon/Ch6_10Scenes.lua').read_text()
m=json.loads((R/'Data/Map/crystal_sanctuary_boss.rsmap').read_text(encoding='utf-8-sig'))['Object']
species=[p['BaseForm']['Species'] for t in m['MapTeams'] for p in t['Players']]
checks={'pre_midpoint_15':pre==15,'post_midpoint_5':post==5,'total_20':pre+post==20,'relay_segment_1':relay==['crystal_sanctuary_relay'],'boss_after_segment_4':boss==['crystal_sanctuary_boss'],'respawn_to_midpoint':"SanctuaryMidState = 'TerapagosRespawn'" in script and "ContinueDungeon('waterfall_pond', 1" in script,'first_and_repeat_respawn_scene':"tries == 1" in scene and 'TerapagosDefeats' in scene,'no_missing_species_reference':all(x!='terapagos' for x in species),'boss_named_terapagos':all(p['Nickname']=='Terapagos' for t in m['MapTeams'] for p in t['Players'])}
print(json.dumps({'floors_before':pre,'floors_after':post,'checks':checks,'runtime':'NOT_TESTED'},ensure_ascii=False,indent=2));raise SystemExit(0 if all(checks.values()) else 1)
