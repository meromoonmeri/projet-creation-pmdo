#!/usr/bin/env python3
import json,re
from pathlib import Path
R=Path(__file__).resolve().parents[1]
m=json.loads((R/'Data/Map/metano_town_duel.rsmap').read_text())['Object']
g=json.loads((R/'Data/Ground/metano_town.rsground').read_text(encoding='utf-8-sig'))['Object']
p=(R/'Data/Script/halcyon/DazzlingPlaza.lua').read_text();c=(R/'Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua').read_text();z=(R/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
entry=[(x['Loc']['X'],x['Loc']['Y']) for x in m['EntryPoints']];foes=[(x['serializationLoc']['X'],x['serializationLoc']['Y']) for t in m['MapTeams'] for x in t['Players']]
def floor(x,y):return m['Tiles'][x][y]['Data']['ID']=='floor'
indexed=(R/'Content/Tile/index.idx').read_bytes().decode('latin1',errors='ignore')
sheets=set(f.get('Sheet','') for l in m['Layers'] for c in l['Tiles'] for z in c for q in z.get('Layers',[]) for f in q.get('Frames',[]))
checks={'full_city_1512':len(m['Tiles'])==63 and len(m['Tiles'][0])==63 and len(g['obstacles'])==189 and len(g['obstacles'][0])==189,'runtime_indexed_tiles':all(x in indexed for x in sheets),'entries_on_plaza':entry==[(47,42),(46,42)] and all(floor(*x) for x in entry),'foes_on_plaza':foes==[(48,38),(47,39),(49,39)] and all(floor(*x) for x in foes),'flash_transition_same_camera':'BossFX.Flash(1152, 928' in p and "PlazaTransitionStage = 'to_battle'" in p,'return_same_plaza':'TeleportTo(hero, 1128, 984' in c and 'TeleportTo(partner, 1104, 984' in c,'victory_branch':"PlazaPending = 'win'" in z and 'DazzlingPlaza.Victoire()' in c,'defeat_branch':"PlazaPending = 'loss'" in z and 'DazzlingPlaza.Defaite()' in c and 'PlazaBedsidePending = true' in c,'no_legacy_camera_centers':not any(x in p for x in ('MoveCamera(912, 864','MoveCamera(928, 856','MoveCamera(880, 872','MoveCamera(880, 880'))}
print(json.dumps({'checks':checks,'entry':entry,'foes':foes,'runtime':'NOT_TESTED'},indent=2));raise SystemExit(0 if all(checks.values()) else 1)
