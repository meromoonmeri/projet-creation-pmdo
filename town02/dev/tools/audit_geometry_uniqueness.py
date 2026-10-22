#!/usr/bin/env python3
"""Compare les structures RogueElements des zones, indépendamment des assets/spawns."""
from __future__ import annotations
import collections,hashlib,json,math
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
GEOM_WORDS=('InitGrid','GridPath','DrawGrid','FloorPath','RoomGen','HallGen','Connect','ClampFloor','AddDisconnected','DetectIsolated','EraseIsolated','Blob','Perlin','LoadGen','MappedRoom')
IGNORE={'Priority','Music','Name','Comment','GroundTileset','BlockTileset','WaterTileset','Element','TimeLimit','TileSight','CharSight','ClampCamera','Spawn','Items','Mobs','TeamSpawns','ItemSpawns'}

def short_type(t):
 # Le premier backtick termine le nom de la classe générique; couper sur la
 # première virgule est faux car les arguments génériques en contiennent.
 head=t.split('`',1)[0]
 return head.split('.')[-1]
def scalar_params(obj):
 out=[]
 for k,v in obj.items():
  if k in IGNORE or k=='$type':continue
  if isinstance(v,(int,float,bool,str)) and k not in {'ID','Value','Script'}:out.append((k,v))
  elif isinstance(v,dict) and set(v)<= {'Min','Max'} and 'Min' in v:out.append((k,(v.get('Min'),v.get('Max'))))
 return tuple(sorted(out))
def geom_tokens(v,out):
 if isinstance(v,dict):
  typ=v.get('$type','')
  if any(w in typ for w in GEOM_WORDS):out.append((short_type(typ),scalar_params(v)))
  if 'ChanceFloorGen' in typ:
   for choice in v.get('Spawns',[]):
    if isinstance(choice,dict):geom_tokens(choice.get('Spawn'),out)
  for k,x in v.items():
   if k not in IGNORE and not ('ChanceFloorGen' in typ and k=='Spawns'):geom_tokens(x,out)
 elif isinstance(v,list):
  for x in v:geom_tokens(x,out)
def floors(zone):
 result=[]
 for si,seg in enumerate(zone.get('Segments',[])):
  ft=seg.get('Floors')
  candidates=[]
  if isinstance(ft,dict):candidates=[n.get('Item') for n in ft.get('nodes',[]) if isinstance(n,dict)]
  elif isinstance(ft,list):candidates=ft
  for fi,f in enumerate(candidates):
   tok=[];geom_tokens(f,tok)
   if tok:result.append((si,fi,tuple(tok)))
 return result
zones={}
for p in sorted((ROOT/'Data/Zone').glob('*.json')):
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object']
 except Exception:continue
 fs=floors(o)
 if fs:zones[p.stem]=fs
# Fingerprints exacts et types Jaccard.
groups=collections.defaultdict(list)
for z,fs in zones.items():
 for si,fi,t in fs:groups[hashlib.sha256(repr(t).encode()).hexdigest()].append((z,si,fi))
exact=[g for g in groups.values() if len({x[0] for x in g})>1]
# signature zone = ensemble des couples type+param de tous ses générateurs
sigs={z:set(tok for _,_,t in fs for tok in t) for z,fs in zones.items()}
pairs=[]
keys=sorted(sigs)
for i,a in enumerate(keys):
 for b in keys[i+1:]:
  u=sigs[a]|sigs[b]; score=len(sigs[a]&sigs[b])/len(u) if u else 0
  if score>=0.70:pairs.append((score,a,b,len(sigs[a]),len(sigs[b])))
print('AUDIT GEOMETRIE ROGUEELEMENTS')
print(f'{len(zones)} zones procédurales; {sum(len(v) for v in zones.values())} patrons de plancher')
print(f'Patrons exacts partagés entre zones: {len(exact)}')
for g in sorted(exact,key=lambda x:(-len(x),x))[:100]:print('EXACT:',g)
print('Similarité structurelle >=70%:')
for score,a,b,na,nb in sorted(pairs,reverse=True):print(f'  {score:5.1%} {a} <-> {b} ({na}/{nb} tokens)')
# Focus imports canoniques réellement branchés.
focus=['cloven_ruins','gloomy_forest','sky_tower','mt_blaze','frosty_forest','mt_freeze','lapis_cave','magma_cavern','wish_cave','waterfall_pond','poisonous_forest']
print('FOCUS IMPORTS CANONIQUES:')
for z in focus:
 if z not in sigs:print(' ',z,'aucun générateur procédural');continue
 nearest=[]
 for b in keys:
  if b==z:continue
  u=sigs[z]|sigs[b];nearest.append((len(sigs[z]&sigs[b])/len(u) if u else 0,b))
 print(' ',z,'->',', '.join(f'{b} {s:.1%}' for s,b in sorted(nearest,reverse=True)[:5]))
