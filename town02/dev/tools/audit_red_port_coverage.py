#!/usr/bin/env python3
"""Vérifie la couverture locale des 245 Grounds de PMD-RED-PMDO-PORT."""
from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
gdir=ROOT/'RESERVE/red_grounds';tdir=ROOT/'RESERVE/red_tiles'
grounds=sorted(gdir.glob('*.rsground'));tiles={p.stem.lower():p for p in tdir.glob('*.tile')}
alias=json.load(open(ROOT/'docs/canonical/red/upstream_ground_aliases.json',encoding='utf-8-sig'))
errors=[];frames=0;animated=0
if len(grounds)!=245:errors.append(f'Grounds: 245 attendus, {len(grounds)} présents')
if len(list(tdir.glob('*.tile')))!=245:errors.append(f'Tilesets: 245 attendus, {len(list(tdir.glob("*.tile")))} présents')
if len(alias)!=33:errors.append(f'Alias nommés upstream: 33 attendus, {len(alias)} présents')
local_names={p.name for p in grounds}
for up,raw in alias.items():
 if raw not in local_names:errors.append(f'{up}: cible locale absente {raw}')
for p in grounds:
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object']
 except Exception as exc:errors.append(f'{p.name}: JSON invalide {exc}');continue
 maxf=0
 for layer in o.get('Layers',[]):
  for col in layer.get('Tiles',[]):
   for tile in col:
    for lay in tile.get('Layers',[]):
     fs=lay.get('Frames',[]);frames+=len(fs);maxf=max(maxf,len(fs))
     for fr in fs:
      sh=(fr.get('Sheet') or '').lower()
      if sh and sh not in tiles:errors.append(f'{p.name}: Sheet absent {fr.get("Sheet")}')
 if maxf>1:animated+=1
print('AUDIT COUVERTURE PMD-RED-PMDO-PORT')
print(f'{len(grounds)}/245 Grounds; {len(tiles)}/245 tilesets; {len(alias)}/33 alias nommés; {frames} frames référencées; {animated} Grounds multi-frame')
for e in errors[:100]:print('ERREUR:',e)
print(f'RESULTAT: {len(errors)} erreur(s)')
raise SystemExit(1 if errors else 0)
