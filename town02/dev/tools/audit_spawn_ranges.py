#!/usr/bin/env python3
"""Détecte les SpawnRangeList impossibles à désérialiser par RogueElements."""
from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
# Propriétés confirmées par les classes C# RogueEssence/PMDC.
RULES={
 'TeamSpawnZoneStep':('Spawns','TeamSizes','SpecificSpawns'),
 'ItemSpawnZoneStep':('Spawns',),
 'TileSpawnZoneStep':('Spawns',),
 'SpreadStepRangeZoneStep':('Spawns',),
 'SpreadBossZoneStep':('Items','BossSteps'),
 'SpreadHouseZoneStep':('Items','ItemThemes','Mobs','MobThemes'),
 'SpreadVaultZoneStep':('Items','Mobs'),
}
errors=[];checked=0
for path in sorted((ROOT/'Data/Zone').glob('*.json')):
 try:root=json.load(open(path,encoding='utf-8-sig'))
 except Exception as exc:errors.append(f'{path.name}: JSON invalide: {exc}');continue
 def walk(v,p=''):
  global checked
  if isinstance(v,dict):
   typ=v.get('$type','')
   for needle,props in RULES.items():
    if needle not in typ:continue
    for prop in props:
     data=v.get(prop)
     if not isinstance(data,list):continue
     for i,item in enumerate(data):
      checked+=1
      if not isinstance(item,dict):errors.append(f'{path.name}{p}/{prop}/{i}: entrée non objet');continue
      rng=item.get('Range')
      if not isinstance(rng,dict):errors.append(f'{path.name}{p}/{prop}/{i}: Range absent');continue
      lo,hi=rng.get('Min'),rng.get('Max')
      if not isinstance(lo,int) or not isinstance(hi,int) or hi<=lo:
       errors.append(f'{path.name}{p}/{prop}/{i}: Range invalide {rng}')
   for k,x in v.items():walk(x,p+'/'+k)
  elif isinstance(v,list):
   for i,x in enumerate(v):walk(x,p+f'/{i}')
 walk(root)
print('AUDIT SPAWN RANGE LISTS')
for e in errors:print('ERREUR:',e)
print(f'RESULTAT: {checked} entrées contrôlées, {len(errors)} erreur(s)')
raise SystemExit(1 if errors else 0)
