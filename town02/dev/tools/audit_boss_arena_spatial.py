#!/usr/bin/env python3
"""Static preflight for fixed PMDO arenas. Never reports runtime PASS."""
import json,glob,os
rows=[]
for p in glob.glob('Data/Map/*.rsmap'):
 try:d=json.load(open(p,encoding='utf-8-sig'))['Object']
 except Exception as e: rows.append({'map':os.path.basename(p),'status':'PARSE_FAIL','error':str(e)});continue
 teams=d.get('MapTeams',[])
 if not teams: continue
 layers=d.get('Layers',[]); w=len(layers[0].get('Tiles',[])) if layers else 0; h=len(layers[0]['Tiles'][0]) if w else 0
 ents=[]; issues=[]; seen={}
 for ti,t in enumerate(teams):
  for pi,m in enumerate(t.get('Players',[])):
   q=m.get('serializationLoc',{});x=q.get('X');y=q.get('Y');sp=m.get('CurrentForm',{}).get('Species','?')
   valid=isinstance(x,int) and isinstance(y,int) and 0<=x<w and 0<=y<h
   if not valid:issues.append(f'{sp}:OUT_OF_BOUNDS:{x},{y}')
   if (x,y) in seen:issues.append(f'{sp}:OVERLAP:{x},{y}:{seen[x,y]}')
   seen[x,y]=sp;ents.append({'species':sp,'x':x,'y':y,'in_bounds':valid})
 entries=[]
 for e in d.get('EntryPoints',[]):
  q=e.get('Loc',{});x=q.get('X');y=q.get('Y');valid=isinstance(x,int) and isinstance(y,int) and 0<=x<w and 0<=y<h
  if not valid:issues.append(f'ENTRY_OUT_OF_BOUNDS:{x},{y}')
  entries.append({'x':x,'y':y,'in_bounds':valid})
 rows.append({'map':d.get('AssetName',os.path.basename(p)),'width':w,'height':h,'entities':ents,'entries':entries,'status':'PASS_STATIC' if not issues else 'FAIL_STATIC','issues':issues})
os.makedirs('docs/audit_pmdred_runtime',exist_ok=True)
out={'scope':'fixed maps containing MapTeams','classification':'STATIC_PREFLIGHT_NOT_RUNTIME','total':len(rows),'pass_static':sum(r['status']=='PASS_STATIC' for r in rows),'fail_static':sum(r['status']!='PASS_STATIC' for r in rows),'maps':rows}
json.dump(out,open('docs/audit_pmdred_runtime/BOSS_ARENA_SPATIAL_STATIC.json','w'),indent=2)
print(json.dumps({k:out[k] for k in ('total','pass_static','fail_static')},indent=2))
