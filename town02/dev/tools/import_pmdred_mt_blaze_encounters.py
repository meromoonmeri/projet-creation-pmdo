#!/usr/bin/env python3
"""Restore Mt. Blaze canonical encounters from pret/pmd-red and add biome pool."""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json,copy,math
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];SRC=Path('/home/user/pmd-red/data/dungeon')
def load(p):return json.load(open(p,encoding='utf-8-sig'))
def floors(name):
 f=load(SRC/name/'floor_id.json')['tables'];tabs=load(SRC/name/'pokemon_found.json')['tables'];base=min(x['Pokemon'] for x in f);return [tabs[x['Pokemon']-base]['pokemon'] for x in f]
def make(t,species,level,floor,rate,tag):
 e=copy.deepcopy(t);m=e['Spawn']['Spawn'];m['BaseForm']={'Species':species,'Form':0,'Skin':'','Gender':-1};m['Level']={'Min':level,'Max':level+1};m['Comment']=tag;e['Range']={'Min':floor,'Max':floor+1};e['Rate']=rate;return e
p=ROOT/'Data/Zone/mt_blaze.json';d=load(p);segs=d['Object']['Segments'];tmpl=segs[0]['ZoneSteps'][4]['Spawns'][0];rows=[]
for si,name in enumerate(['MtBlaze','MtBlazePeak']):
 out=[]
 for floor,mons in enumerate(floors(name)):
  pos=[m for m in mons if m['probability']>0 and m['species'] not in ('MONSTER_KECLEON','MONSTER_DECOY')];g=math.gcd(*[m['probability'] for m in pos]) if pos else 1
  for m in pos:
   sp=m['species'].removeprefix('MONSTER_').lower();out.append(make(tmpl,sp,m['level'],floor,max(1,m['probability']//g),'CANONICAL_PMD_RED'));rows.append([si,floor,sp,m['level'],m['probability']])
 segs[si]['ZoneSteps'][4]['Spawns']=out
pool=['slugma','numel','torkoal','magby','larvesta','salandit','rolycoly','carkol','charcadet','litleo','houndour','turtonator','heatmor','coalossal','magcargo']
for i,sp in enumerate(pool):
 si=0 if i<11 else 1;nf=12 if si==0 else 3;floor=(i*2)%nf;level=16+i//3+(3 if si else 0);segs[si]['ZoneSteps'][4]['Spawns'].append(make(tmpl,sp,level,floor,1,'NEW_ERA_ADDITIVE'))
d['Object']['Comment']=(d['Object'].get('Comment','')+' Canonical encounters: pret/pmd-red MtBlaze/MtBlazePeak; 15-species New Era additive pool.').strip();json.dump(d,open(p,'w'),ensure_ascii=False,indent=2);open(p,'a').write('\n')
json.dump({'source':'pret/pmd-red','canonical_rows':rows,'new_era_pool':pool,'policy':'canonical floor probabilities preserved; additive Rate=1'},open(ROOT/'docs/audit_global/MT_BLAZE_ENCOUNTERS.json','w'),indent=2);print(len(rows),len(pool))
