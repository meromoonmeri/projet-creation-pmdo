#!/usr/bin/env python3
"""Audit des appels GAME:UnlockDungeon et du déblocage automatique en mod Dev."""
from __future__ import annotations
import json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
idx=json.load(open(ROOT/'Data/Zone/index.idx',encoding='utf-8-sig'))['Object']
zones={k:v for k,v in idx.items() if isinstance(v,dict)}
errors=[]; warnings=[]; calls=[]
for p in (ROOT/'Data/Script').rglob('*.lua'):
 s=p.read_text(errors='ignore')
 for m in re.finditer(r'GAME:UnlockDungeon\(\s*[\'\"]([^\'\"]+)',s):
  z=m.group(1);calls.append((z,p,m.start()))
  if z not in zones: errors.append(f'{p.relative_to(ROOT)}: zone absente {z}')
for z,v in zones.items():
 if z=='master_zone': warnings.append('master_zone est un hub Ground, jamais un donjon déblocable')
 if v.get('CountedFloors',0)<=0: warnings.append(f'{z}: CountedFloors={v.get("CountedFloors")} — exclure du déblocage global')
# Le patron historique déverrouillait toutes les clés, y compris master_zone.
debug=(ROOT/'Data/Script/halcyon/services/debug_tools/init.lua').read_text()
if 'UnlockDungeon(dungeon_keys[ii])' in debug:
 errors.append('debug_tools.OnNewGame déverrouille toutes les clés sans filtrage')
print('AUDIT DEBLOCAGES DEV')
for x in errors:print('ERREUR:',x)
for x in warnings:print('AVERTISSEMENT:',x)
print(f'RESULTAT: {len(calls)} appels littéraux, {len(errors)} erreur(s), {len(warnings)} avertissement(s)')
raise SystemExit(1 if errors else 0)
