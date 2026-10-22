#!/usr/bin/env python3
"""Full static/behavioral audit of PMD Red imported Grounds only."""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
from pathlib import Path
from collections import deque,Counter
import json,struct,io,re,hashlib,sys
from PIL import Image
ROOT=Path(__file__).resolve().parents[1];GD=ROOT/'Data/Ground';TD=ROOT/'Content/Tile';RG=ROOT/'RESERVE/red_grounds';RT=ROOT/'RESERVE/red_tiles';OUT=ROOT/'docs/audit_pmdred_full';OUT.mkdir(parents=True,exist_ok=True)
sys.path.insert(0,str(ROOT/'tools'));import inject_tile_index as iti
alias=json.load(open(ROOT/'docs/canonical/red/upstream_ground_aliases.json'))
reserve={p.stem for p in RG.glob('*.rsground')};runtime=set()
for p in GD.glob('*.rsground'):
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object'];c=(o.get('Comment') or '').lower()
 except:continue
 if p.name in alias or p.stem in reserve or 'pmd red' in c or 'pret/pmd-red' in c or 'chunsoft' in c:runtime.add(p.stem)
idx={e[0]:e for e in iti.lire_index(TD/'index.idx')};sheet_cache={};issues=[];rows=[]
def issue(g,sev,cat,msg,**kw):issues.append({'ground':g,'severity':sev,'category':cat,'message':msg,**kw})
def tile_audit(sheet,runtime_mode):
 key=(sheet,runtime_mode)
 if key in sheet_cache:return sheet_cache[key]
 p=(TD if runtime_mode else RT)/(sheet+'.tile')
 if not p.exists():return {'error':'tile absent','coords':set()}
 b=p.read_bytes()
 try:ts,n=struct.unpack_from('<II',b);table=b[8:8+n*16]
 except Exception as e:return {'error':str(e),'coords':set()}
 if len(table)!=n*16:return {'error':'table tronquée','coords':set()}
 if runtime_mode:
  if sheet not in idx:return {'error':'sheet absente de Content/Tile/index.idx','coords':set()}
  _,its,inn,itab=idx[sheet]
  if (its,inn,itab)!=(ts,n,table):return {'error':'index.idx obsolète/différent du header .tile','coords':set()}
 coords=set();bad=[]
 for i in range(n):
  x,y,off=struct.unpack_from('<iiq',table,i*16);coords.add((x,y))
  try:
   ln=struct.unpack_from('<q',b,off)[0]
   if ln<=0 or off+8+ln>len(b):raise ValueError(f'offset/length {off}/{ln}')
   blob=b[off+8:off+8+ln]
   if not blob.startswith(b'\x89PNG\r\n\x1a\n'):raise ValueError('signature non PNG')
   im=Image.open(io.BytesIO(blob));im.verify()
   if im.size!=(ts,ts):raise ValueError(f'dimension {im.size} != {(ts,ts)}')
  except Exception as e:bad.append({'coord':[x,y],'entry':i,'error':str(e)})
 r={'error':None,'coords':coords,'bad_images':bad,'bytes':len(b),'entries':n,'tile_size':ts,'sha256':hashlib.sha256(b).hexdigest()};sheet_cache[key]=r;return r
def flood(ob,w,h,start):
 if not(0<=start[0]<w and 0<=start[1]<h) or ob[start[0]][start[1]].get('Tags',0)==1:return set()
 q=deque([start]);seen={start}
 while q:
  x,y=q.popleft()
  for z in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
   if 0<=z[0]<w and 0<=z[1]<h and z not in seen and ob[z[0]][z[1]].get('Tags',0)!=1:seen.add(z);q.append(z)
 return seen
def audit(path,runtime_mode):
 g=path.stem
 try:o=json.load(open(path,encoding='utf-8-sig'))['Object']
 except Exception as e:issue(g,'CRITICAL','JSON',str(e));return
 layers=o.get('Layers',[])
 if not layers or not layers[0].get('Tiles'):issue(g,'CRITICAL','GEOMETRY','aucune couche de tiles');return
 W=len(layers[0]['Tiles']);H=len(layers[0]['Tiles'][0]);px=8*int(o.get('TexSize',1));ob=o.get('obstacles',[]);ow=len(ob);oh=len(ob[0]) if ob else 0
 if (ow,oh)!=(W*int(o.get('TexSize',1)),H*int(o.get('TexSize',1))):issue(g,'HIGH','DIMENSIONS',f'layers {W}x{H} TexSize {o.get("TexSize",1)} vs obstacles {ow}x{oh}')
 refs=Counter();missing=[]
 for lay in layers:
  if len(lay.get('Tiles',[]))!=W:issue(g,'HIGH','LAYERS','largeur de couche divergente')
  for col in lay.get('Tiles',[]):
   if len(col)!=H:issue(g,'HIGH','LAYERS','hauteur de couche divergente')
   for cell in col:
    for sub in cell.get('Layers',[]):
     for fr in sub.get('Frames',[]):
      sh=fr.get('Sheet');loc=fr.get('TexLoc',{});refs[sh]+=1
      r=tile_audit(sh,runtime_mode)
      if r.get('error'):missing.append(f'{sh}: {r["error"]}')
      elif (loc.get('X'),loc.get('Y')) not in r['coords']:missing.append(f'{sh}: coord absente {loc}')
 for m in sorted(set(missing)):issue(g,'CRITICAL','TILES',m)
 for sh in refs:
  r=tile_audit(sh,runtime_mode)
  for b in r.get('bad_images',[]):issue(g,'CRITICAL','IMAGE',f'{sh} {b}')
 ents=[]
 for el in o.get('Entities',[]):
  for typ in ('Markers','Spawners','GroundObjects','MapChars'):
   for e in el.get(typ,[]):ents.append((typ,e))
 entrance=None
 for typ,e in ents:
  c=e.get('Collider') or e.get('Bounds');name=e.get('EntName') or e.get('Name') or '?'
  if not c:continue
  x,y,w,h=c.get('X',0),c.get('Y',0),c.get('Width',1),c.get('Height',1)
  if name=='Main_Entrance_Marker':entrance=(max(0,(x+w//2)//8),max(0,(y+h//2)//8))
  if x<0 or y<0 or x+w>ow*8 or y+h>oh*8:issue(g,'CRITICAL','COORDINATES',f'{typ}/{name} hors map {(x,y,w,h)}')
  elif typ in ('Markers','Spawners','MapChars') and ob:
   cells=[ob[xx][yy].get('Tags',0) for xx in range(x//8,min(ow,(x+w-1)//8+1)) for yy in range(y//8,min(oh,(y+h-1)//8+1))]
   if cells and all(v==1 for v in cells):issue(g,'CRITICAL','COLLISION',f'{typ}/{name} entièrement dans mur {(x,y)}')
 if ob and entrance:
  reach=flood(ob,ow,oh,entrance)
  for typ,e in ents:
   c=e.get('Collider') or e.get('Bounds');name=e.get('EntName') or e.get('Name') or '?'
   if c and typ in ('Markers','Spawners','MapChars'):
    footprint={(xx,yy) for xx in range(c['X']//8,min(ow,(c['X']+c.get('Width',1)-1)//8+1)) for yy in range(c['Y']//8,min(oh,(c['Y']+c.get('Height',1)-1)//8+1))}
    if footprint and not (footprint & reach):issue(g,'HIGH','REACHABILITY',f'{typ}/{name} inaccessible depuis entrée')
 markers={e.get('EntName') for t,e in ents if t=='Markers'}
 if runtime_mode:
  sd=ROOT/'Data/Script/halcyon/ground'/g;lua='\n'.join(p.read_text(errors='ignore') for p in sd.glob('*.lua')) if sd.exists() else ''
  for target,mark in re.findall(r"EnterGroundMap\s*\(\s*['\"]([^'\"]+)['\"]\s*,\s*['\"]([^'\"]+)['\"]",lua):
   tp=GD/(target+'.rsground')
   if not tp.exists():issue(g,'CRITICAL','TRANSITION',f'Lua cible Ground absent {target}')
   else:
    to=json.load(open(tp,encoding='utf-8-sig'))['Object'];tm={m.get('EntName') for el in to.get('Entities',[]) for m in el.get('Markers',[])}
    if mark not in tm:issue(g,'CRITICAL','MARKER',f'Lua cible marker absent {target}/{mark}')
 status='PASS_STATIC'
 gi=[z for z in issues if z['ground']==g]
 if any(z['severity']=='CRITICAL' for z in gi):status='CRITICAL'
 elif any(z['severity']=='HIGH' for z in gi):status='FAIL'
 elif gi:status='WARNING'
 rows.append({'ground':g,'path':str(path.relative_to(ROOT)),'runtime':runtime_mode,'width_cells':W,'height_cells':H,'pixel_size':[W*px,H*px],'sheets':dict(refs),'markers':sorted(x for x in markers if x),'entities':len(ents),'issues':len(gi),'status':status})
for p in sorted(RG.glob('*.rsground')):audit(p,False)
for g in sorted(runtime):audit(GD/(g+'.rsground'),True)
# Explicit relay regressions: canonical Red checkpoint packages expected in current zones.
relay_expected={'mt_blaze':'mt_blaze_midpoint','frosty_forest':'frosty_forest_midpoint','mt_freeze':'mt_freeze_midpoint','mt_thunder':'mt_thunder_midpoint'}
for zone,ground in relay_expected.items():
 zp=ROOT/'Data/Zone'/f'{zone}.json';gp=GD/(ground+'.rsground');sp=ROOT/'Data/Script/halcyon/ground'/ground/'init.lua'
 if not gp.exists():issue(ground,'CRITICAL','RELAY',f'relais attendu absent pour {zone}')
 if not sp.exists():issue(ground,'CRITICAL','RELAY',f'script relais absent pour {zone}')
 if zp.exists() and ground not in zp.read_text():issue(ground,'CRITICAL','RELAY',f'relais non référencé par ZoneData {zone}')
# Recompute statuses after relay checks.
for r in rows:
 gi=[z for z in issues if z['ground']==r['ground']];r['issues']=len(gi);r['status']='CRITICAL' if any(z['severity']=='CRITICAL' for z in gi) else ('FAIL' if any(z['severity']=='HIGH' for z in gi) else ('WARNING' if gi else 'PASS_STATIC'))
 cats={z['category'] for z in gi};r['checks']={k:('FAIL' if k in cats else 'PASS_STATIC') for k in ('TILES','IMAGE','DIMENSIONS','COLLISION','MARKER','RELAY','BOSS','SPAWNER','CAMERA','LUA','TRANSITION','REACHABILITY')};r['regressions']='FOUND' if 'RELAY' in cats else 'NONE'
counts=Counter(r['status'] for r in rows);sev=Counter(i['severity'] for i in issues);cats=Counter(i['category'] for i in issues)
report={'schema':1,'scope':'PMD Red imports only','summary':{'reserve_grounds':len(list(RG.glob('*.rsground'))),'runtime_imports':len(runtime),'total_records':len(rows),'status':dict(counts),'severity':dict(sev),'categories':dict(cats)},'grounds':rows,'issues':issues,'runtime_execution':'exact PMDO 0.8.12 evidence is documented in docs/pmdred_eu/pmdo_validation; PASS_STATIC is still not runtime PASS'}
(OUT/'FULL_AUDIT.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n')
for label,pred in [('FAIL',lambda r:r['status'] in ('FAIL','CRITICAL')),('PASS',lambda r:r['status']=='PASS_STATIC'),('REGRESSIONS',lambda r:any(i['ground']==r['ground'] and i['category']=='RELAY' for i in issues))]:
 (OUT/(label+'.txt')).write_text('\n'.join(r['ground'] for r in rows if pred(r))+'\n')
for cat in ('RELAY','IMAGE','TILES','COLLISION','MARKER','TRANSITION','COORDINATES','REACHABILITY','DIMENSIONS'):(OUT/(cat+'.json')).write_text(json.dumps([i for i in issues if i['category']==cat],indent=2,ensure_ascii=False)+'\n')
md=['# Full audit — imports PMD Red uniquement','',f"Réserve: {report['summary']['reserve_grounds']} | Runtime: {report['summary']['runtime_imports']} | Enregistrements: {len(rows)}",'',f"Statuts: `{dict(counts)}`",f"Sévérités: `{dict(sev)}`",f"Catégories: `{dict(cats)}`",'', '> PASS_STATIC ne signifie pas capture PMDO réussie. Les preuves PMDO 0.8.12 exactes sont séparées dans `docs/pmdred_eu/pmdo_validation`.','', '## Erreurs critiques']
for i in issues:
 if i['severity']=='CRITICAL':md.append(f"- **{i['ground']}** [{i['category']}] {i['message']}")
(OUT/'REPORT.md').write_text('\n'.join(md)+'\n');print(json.dumps(report['summary'],ensure_ascii=False))
