#!/usr/bin/env python3
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json,re,glob,struct,os,collections
from pathlib import Path
R=Path('.'); OUT=R/'docs/audit_global';OUT.mkdir(parents=True,exist_ok=True)
def load(p): return json.load(open(p,encoding='utf-8-sig'))
def segfloors(s):
 t=s.get('$type','')
 if 'LayeredSegment' in t:return len(s.get('Floors') or [])
 if 'RangeDictSegment' in t:
  return sum(int(n['Range']['Max'])-int(n['Range']['Min']) for n in (s.get('Floors') or {}).get('nodes',[]))
 if 'DictionarySegment' in t:return len(s.get('Floors') or {})
 return 0
def walk(x):
 if isinstance(x,dict):
  yield x
  for v in x.values():yield from walk(v)
 elif isinstance(x,list):
  for v in x:yield from walk(v)
def tile_index(path):
 b=path.read_bytes(); size,n=struct.unpack_from('<II',b,0);keys=set();off=8
 for _ in range(n):k,p=struct.unpack_from('<QQ',b,off);off+=16;keys.add((k&0xffffffff,k>>32))
 return size,n,keys
# tiles
sheets={};tile_errors=[]
for p in (R/'Content/Tile').glob('*.tile'):
 try:sheets[p.stem]=tile_index(p)
 except Exception as e:tile_errors.append({'type':'INVALID_TILE_FILE','sheet':p.stem,'cause':str(e)})
# zones
zones={};structures=[];floors=0;problems=[];idx=load(R/'Data/Zone/index.idx')['Object'];groundowners=collections.defaultdict(list);floorlabels=collections.defaultdict(list)
for p in (R/'Data/Zone').glob('*.json'):
 try:z=load(p)['Object']
 except Exception as e:problems.append({'type':'ZONE_PARSE_FAIL','zone':p.stem,'cause':str(e)});continue
 zones[p.stem]=z
 for g in z.get('GroundMaps',[]):groundowners[g].append(p.stem)
 ent=idx.get(p.stem)
 if not ent:problems.append({'type':'ZONE_INDEX_MISSING','zone':p.stem})
 elif ent.get('Grounds')!=z.get('GroundMaps',[]):problems.append({'type':'ZONE_INDEX_GROUNDS_STALE','zone':p.stem})
 for si,s in enumerate(z.get('Segments',[])):
  nf=segfloors(s);floors+=nf; labels=[]
  for d in walk(s):
   if 'FloorNameDropZoneStep' in d.get('$type',''):
    lab=d.get('Name',{}).get('DefaultText','');labels.append(lab);floorlabels[lab].append((p.stem,si))
  structures.append({'zone':p.stem,'segment':si,'type':s.get('$type'),'floors':nf,'labels':labels,'comment':s.get('Comment','')})
for lab,owners in floorlabels.items():
 uz={x[0] for x in owners}
 if lab and len(uz)>1:
  for z,s in owners:problems.append({'type':'CROSS_DUNGEON_FLOOR_NAME','zone':z,'segment':s,'floor':lab,'cause':'same floor identity used by '+','.join(sorted(uz))})
# grounds exhaustive
grounds=[];refs=frames=markers=spawners=entities=0
for p in (R/'Data/Ground').glob('*.rsground'):
 rec={'ground':p.stem,'status':'PASS_STATIC','issues':[],'owners':groundowners.get(p.stem,[])}
 try:o=load(p)['Object']
 except Exception as e:rec['status']='FAIL_STATIC';rec['issues'].append('PARSE:'+str(e));grounds.append(rec);continue
 if not rec['owners']:rec['issues'].append('ORPHAN_GROUND')
 layers=o.get('Layers',[]);dims=[(len(l.get('Tiles',[])),len(l.get('Tiles',[[]])[0]) if l.get('Tiles') else 0) for l in layers];W=max([x for x,y in dims]+[len(o.get('obstacles',[]))]);H=max([y for x,y in dims]+[len(o.get('obstacles',[[]])[0]) if o.get('obstacles') else 0]);rec['dimensions']=[W,H]
 for d in walk(layers):
  if 'Frames' in d and isinstance(d['Frames'],list):
   for f in d['Frames']:
    if not isinstance(f,dict) or 'Sheet' not in f:continue
    sh=f['Sheet'];q=f.get('TexLoc',{});xy=(q.get('X'),q.get('Y'))
    if sh=='': continue
    refs+=1;frames+=1
    if sh not in sheets:rec['issues'].append('MISSING_SHEET:'+sh)
    elif xy not in sheets[sh][2]:rec['issues'].append(f'INVALID_TEXLOC:{sh}:{xy}')
 for el in o.get('Entities',[]):
  markers+=len(el.get('Markers',[]));spawners+=len(el.get('Spawners',[]));entities+=len(el.get('MapChars',[]))+len(el.get('GroundObjects',[]))
  for typ in ['Markers','Spawners']:
   for e in el.get(typ,[]):
    c=e.get('Collider',{});x,y,w,h=[c.get(k,0) for k in ['X','Y','Width','Height']]
    if x<0 or y<0 or x+w>W*8 or y+h>H*8:rec['issues'].append(f'{typ[:-1].upper()}_OUT_OF_BOUNDS:{e.get("EntName")}')
 if rec['issues']:rec['status']='FAIL_STATIC';problems.extend({'type':x.split(':')[0],'ground':p.stem,'cause':x} for x in sorted(set(rec['issues'])))
 grounds.append(rec)
# maps/bosses
bosses=[]
for p in (R/'Data/Map').glob('*.rsmap'):
 try:o=load(p)['Object']
 except Exception as e:problems.append({'type':'MAP_PARSE_FAIL','ground':p.stem,'cause':str(e)});continue
 if not isinstance(o.get('ID'),int):problems.append({'type':'INVALID_MAP_ID_TYPE','ground':p.stem,'cause':repr(o.get('ID'))})
 for t in o.get('MapTeams',[]):
  for m in t.get('Players',[]):bosses.append({'map':p.stem,'species':m.get('CurrentForm',{}).get('Species'),'position':m.get('serializationLoc'),'level':m.get('Level'),'runtime':'NOT_TESTED'})
# transitions
trans=[];lua_files=list((R/'Data/Script').rglob('*.lua'));groundset={p.stem for p in (R/'Data/Ground').glob('*.rsground')}
for p in lua_files:
 txt=p.read_text(errors='replace')
 for fn,arg in re.findall(r'GAME:(EnterGroundMap|EnterDungeon|ContinueDungeon)\s*\(\s*["\']([^"\']+)',txt):
  ok=arg in (groundset if fn=='EnterGroundMap' else zones);trans.append({'file':str(p),'call':fn,'target':arg,'valid':ok})
  if not ok:problems.append({'type':'INVALID_TRANSITION_TARGET','cause':f'{p}:{fn}:{arg}'})
# outputs
coverage={'zones':len(zones),'dungeons':sum(1 for z in zones.values() if z.get('Segments')),'structures':len(structures),'segments':len(structures),'floors':floors,'grounds':len(grounds),'tile_sheets':len(sheets),'frames':frames,'tile_references':refs,'markers':markers,'spawners':spawners,'entities':entities,'transitions':len(trans),'bosses':len(bosses),'lua_files':len(lua_files),'cinematic_candidate_files':sum(1 for p in lua_files if any(k in p.read_text(errors='ignore') for k in ['WaitShowDialogue','CutsceneMode','BossTransition']))}
summary={'TOTAL_DISCOVERED':sum(coverage.values()),'TOTAL_AUDITED':sum(coverage.values()),'TOTAL_FIXED':0,'TOTAL_RUNTIME_PASS':0,'TOTAL_RUNTIME_FAIL':0,'TOTAL_INCONCLUSIVE':0,'TOTAL_NOT_TESTED':len(grounds)+len(bosses),'problems':len(problems)}
integrity={'classification':'STATIC_GLOBAL_AUDIT; runtime statuses separate','coverage':coverage,'summary':summary,'problems':problems}
json.dump(integrity,open(OUT/'IMPORT_INTEGRITY.json','w'),indent=2)
json.dump({'classification':'STATIC_PAYLOAD_AUDIT_NOT_RUNTIME','sheets':len(sheets),'references':refs,'errors':tile_errors+[p for p in problems if p['type'] in ['MISSING_SHEET','INVALID_TEXLOC','INVALID_TILE_FILE']]},open(OUT/'TEXTURE_RUNTIME_REPORT.json','w'),indent=2)
json.dump({'structures':structures,'cross_dungeon_findings':[p for p in problems if 'CROSS_DUNGEON' in p['type']]},open(OUT/'STRUCTURE_MAPPING_REPORT.json','w'),indent=2)
json.dump({'coverage':coverage,'grounds':grounds},open(OUT/'GROUND_COVERAGE_REPORT.json','w'),indent=2)
json.dump({'classification':'STATIC_DISCOVERY; NOT runtime completion','candidate_files':coverage['cinematic_candidate_files'],'tornadus':{'TORNADUS_CUTSCENE_STATUS':'INCONCLUSIVE','TORNADUS_RUNTIME_TESTS':[],'TORNADUS_FREEZE_DETECTED':'REPORTED_NOT_REPRODUCED_THIS_BATCH','TORNADUS_ROOT_CAUSE':'previous BattlePosition offset fixed; current cutscene freeze location unproven','TORNADUS_FIX':'NOT_CLAIMED_COMPLETE','TORNADUS_REGRESSION_RESULT':'NOT_TESTED'},'bosses':bosses},open(OUT/'CUTSCENE_RUNTIME_REPORT.json','w'),indent=2)
md=['# Global PMDO Import Integrity Audit','',f'Classification: **static exhaustive discovery**. No runtime PASS inferred.','', '## Coverage']+[f'- {k}: {v}' for k,v in coverage.items()]+['','## Verdict counts']+[f'- {k}: {v}' for k,v in summary.items()]+['','## Findings by type']
for k,v in collections.Counter(p['type'] for p in problems).most_common():md.append(f'- {k}: {v}')
md+=['','## Tornadus','`CRITICAL_RUNTIME_BLOCKER — INCONCLUSIVE`. Full interactive cutscene repetition tests have not run in this batch.']
open(OUT/'IMPORT_INTEGRITY_REPORT.md','w').write('\n'.join(md)+'\n')
print(json.dumps({'coverage':coverage,'summary':summary,'finding_types':collections.Counter(p['type'] for p in problems)},indent=2))
