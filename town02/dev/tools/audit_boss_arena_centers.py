#!/usr/bin/env python3
import json,glob,math
from pathlib import Path
out=[]
for p in glob.glob('Data/Map/*.rsmap'):
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object']
 except:continue
 mons=[m for t in o.get('MapTeams',[]) for m in t.get('Players',[])]
 if not mons:continue
 T=o.get('Tiles',[]);floor=[]
 for x,col in enumerate(T):
  for y,t in enumerate(col):
   if t.get('Data',{}).get('ID')=='floor':floor.append((x,y))
 if floor:
  bounds={'min_x':min(x for x,y in floor),'max_x':max(x for x,y in floor),'min_y':min(y for x,y in floor),'max_y':max(y for x,y in floor)};center={'x':(bounds['min_x']+bounds['max_x'])/2,'y':(bounds['min_y']+bounds['max_y'])/2}
 else:bounds=None;center=None
 for m in mons:
  pos=m.get('serializationLoc',{});xy=(pos.get('X'),pos.get('Y'));walk=xy in floor;dist=None if not center else math.hypot(xy[0]-center['x'],xy[1]-center['y'])
  out.append({'Boss':m.get('BaseForm',{}).get('Species') or m.get('CurrentForm',{}).get('Species'),'Dungeon':'DISCOVER_FROM_ZONE_MAPPING','Arena':o.get('AssetName',Path(p).stem),'Arena_bounds':bounds,'Arena_center':center,'Boss_position':pos,'Distance_from_center':dist,'Player_entrance':o.get('EntryPoints',[None])[0],'Partner_entrance':o.get('EntryPoints',[None,None])[1] if len(o.get('EntryPoints',[]))>1 else None,'Boss_arrival':'STATIC_ONLY','Camera_target':{'ViewCenter':o.get('ViewCenter'),'ViewOffset':o.get('ViewOffset')},'Battle_position':'STATIC_ONLY','Collision':'PASS_STATIC' if walk else 'FAIL_STATIC','Cutscene':'NOT_TESTED','Pre_battle_movement':'NOT_TESTED','Post_battle_movement':'NOT_TESTED','Runtime_result':'NOT_TESTED','Status':'MANUAL_REVIEW' if dist is None or dist>2 else 'PASS_STATIC_CENTER'})
Path('docs/audit_global').mkdir(exist_ok=True);json.dump({'classification':'STATIC_ARENA_GEOMETRY_NOT_RUNTIME','total':len(out),'bosses':out},open('docs/audit_global/BOSS_ARENA_REPORT.json','w'),indent=2)
print(len(out),sum(x['Collision']=='FAIL_STATIC' for x in out),sum(x['Status']=='PASS_STATIC_CENTER' for x in out))
