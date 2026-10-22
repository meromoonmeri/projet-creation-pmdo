#!/usr/bin/env python3
"""Restore Mt. Freeze canonical encounters from pret/pmd-red, then append New Era pool."""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json,copy,math,argparse
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SRC=Path('/home/user/pmd-red/data/dungeon')
def load(p):return json.load(open(p,encoding='utf-8-sig'))
def source_floors(name):
 fid=load(SRC/name/'floor_id.json')['tables'];tabs=load(SRC/name/'pokemon_found.json')['tables'];base=min(x['Pokemon'] for x in fid);out=[]
 for f,row in enumerate(fid):out.append(tabs[row['Pokemon']-base]['pokemon'])
 return out
def make(template,species,level,floor,rate,tag):
 e=copy.deepcopy(template);mob=e['Spawn']['Spawn'];mob['BaseForm']={'Species':species,'Form':0,'Skin':'','Gender':-1};mob['Level']={'Min':level,'Max':level+1};e['Range']={'Min':floor,'Max':floor+1};e['Rate']=rate;mob['Comment']=tag;return e
p=ROOT/'Data/Zone/mt_freeze.json';d=load(p);segs=d['Object']['Segments'];tmpl=segs[0]['ZoneSteps'][4]['Spawns'][0]
canon=[]
for si,name in enumerate(['MtFreeze','MtFreezePeak']):
 sp=[]
 for floor,mons in enumerate(source_floors(name)):
  positive=[m for m in mons if m['probability']>0 and m['species'] not in ('MONSTER_KECLEON','MONSTER_DECOY')];g=math.gcd(*[m['probability'] for m in positive]) if positive else 1
  for m in positive:
   species=m['species'].removeprefix('MONSTER_').lower();sp.append(make(tmpl,species,m['level'],floor,max(1,m['probability']//g),'CANONICAL_PMD_RED'));canon.append((si,floor,species,m['level'],m['probability']))
 segs[si]['ZoneSteps'][4]['Spawns']=sp
# exactly 15 additive species, low weights, distributed across both structures
pool=['snover','snorunt','vanillite','cubchoo','bergmite','amaura','cryogonal','delibird','swinub','sneasel','glaceon','froslass','beartic','avalugg','abomasnow']
for i,species in enumerate(pool):
 si=0 if i<10 else 1;nf=15 if si==0 else 5;start=(i*3)%nf;level=(18+i//3) if si==0 else 22+i-10
 segs[si]['ZoneSteps'][4]['Spawns'].append(make(tmpl,species,level,start,1,'NEW_ERA_ADDITIVE'))
d['Object']['Comment']=(d['Object'].get('Comment','')+' Canonical encounters: pret/pmd-red MtFreeze/MtFreezePeak; 15-species New Era additive pool.').strip()
json.dump(d,open(p,'w'),ensure_ascii=False,indent=2);open(p,'a').write('\n')
out={'source':'pret/pmd-red','canonical_rows':len(canon),'canonical':canon,'new_era_pool':pool,'policy':'canonical weights preserved per floor; additive species use separate low Rate=1 entries'}
Path(ROOT/'docs/audit_global').mkdir(exist_ok=True);json.dump(out,open(ROOT/'docs/audit_global/MT_FREEZE_ENCOUNTERS.json','w'),indent=2)
print('canonical rows',len(canon),'new era',len(pool))
