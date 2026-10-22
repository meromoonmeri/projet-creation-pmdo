#!/usr/bin/env python3
import json,re
from pathlib import Path
R=Path(__file__).resolve().parents[1]
night=(R/'Data/Script/halcyon/TownNight.lua').read_text(); life=(R/'Data/Script/halcyon/TownLife.lua').read_text(); init=(R/'Data/Script/halcyon/ground/metano_town_nuit/init.lua').read_text()
o=json.loads((R/'Data/Ground/metano_town_nuit.rsground').read_text(encoding='utf-8-sig'))['Object'];ob=o['obstacles']
m=re.search(r"\{ 'Noctowl',\s*(\d+),\s*(\d+),",night);x,y=map(int,m.groups());cx=(x+8)//8;cy=(y+8)//8
# Le marqueur de la Guilde donne la référence spatiale, pas une coordonnée inventée.
guild=next(v['Collider'] for e in o['Entities'] for v in e.get('Markers',[]) if v['EntName']=='Guild_Entrance_Marker')
routines=re.findall(r'^\s{2}([A-Za-z0-9_]+) = \{\n\s+\{\s*\d+',life,re.M)
static=set(v['EntName'] for e in o['Entities'] for v in e.get('MapChars',[]))
checks={'phileas_spawn_defined':m is not None,'phileas_walkable':ob[cx][cy]['Tags']==0,'phileas_in_front_of_guild':abs(x-guild['X'])<=32 and 0<guild['Y']-y<=64,'phileas_night_dialogue':'TownNight.LINES.Noctowl' in night,'phileas_action_callback':'metano_town_nuit.Noctowl_Action' in init,'daily_rotation_uses_days_passed':'TownLife.Today() % #t' in life}
print(json.dumps({'npc_static_ground':len(static),'daily_routine_roster':len(routines),'daily_routine_names':routines,'phileas_position':[x,y],'guild_marker':[guild['X'],guild['Y']],'checks':checks,'runtime':'NOT_TESTED'},ensure_ascii=False,indent=2));raise SystemExit(0 if all(checks.values()) else 1)
