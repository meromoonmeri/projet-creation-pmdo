#!/usr/bin/env python3
import json,re
from pathlib import Path
R=Path(__file__).resolve().parents[1];z=json.loads((R/'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))['Object']
def n(i):return sum(x['Range']['Max']-x['Range']['Min'] for x in z['Segments'][i]['Floors']['nodes'])
a,b,c=n(0),n(1),n(3);raw=json.dumps(z);script='\n'.join(p.read_text(errors='ignore') for p in (R/'Data/Script/halcyon').rglob('*.lua'))
checks={'before_relay_15':a==15,'f16_f20_5':b==5,'deep_f21_f23_3':c==3,'total_23':a+b+c==23,'relay_ground_exists':(R/'Data/Ground/gloomy_forest_midpoint.rsground').exists(),'relay_after_seg0':"GROUND_IDX('gloomy_forest_midpoint')" in (R/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text(),'canonical_music':all('Sinister Woods.ogg' in json.dumps(z['Segments'][i]) for i in (0,1,3)),'deep_native_status':all(x in json.dumps(z['Segments'][3]) for x in ('darkness','dusk')),'team_meanies_runtime_refs':not bool(re.search(r'["\'](?:Team Meanies|Meanies)["\']',script,re.I))}
print(json.dumps({'floors':[a,b,c],'checks':checks,'runtime':'NOT_TESTED'},indent=2));raise SystemExit(0 if all(checks.values()) else 1)
