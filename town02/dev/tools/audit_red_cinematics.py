#!/usr/bin/env python3
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
cin = (ROOT/'Data/Script/halcyon/FugitiveCinematics.lua').read_text()
required={'d09p03':('Moltres','TeleportTo','WaitShowTitle'),'d10p03':('Articuno','TeleportTo','WaitShowTitle'),'d11p03':('Ninetales','TeleportTo','NinetalesTestimony')}
errors=[]
for sid,tokens in required.items():
 p=ROOT/f'Data/Script/halcyon/arc_fugitif/scene/{sid}.lua';s=p.read_text()
 if f"C.Play('{sid}')" not in s:errors.append(f'{sid}: wrapper absent')
 for t in tokens:
  if t not in cin:errors.append(f'{sid}: token narratif absent {t}')
 if 'SCENE_'+sid.upper() in s:errors.append(f'{sid}: ancien déversement de clés non adapté encore présent')
print('AUDIT CINEMATIQUES RED ENRICHIES')
print(f'{len(required)} scènes; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
