#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
arc = (ROOT / 'Data/Script/halcyon/FugitiveArc.lua').read_text()
ids = re.findall(r"scene = '([^']+)'", arc)
cin = (ROOT / 'Data/Script/halcyon/FugitiveCinematics.lua').read_text()
errors = []

if len(ids) != 27:
    errors.append(f'27 étapes attendues, {len(ids)}')

for i in ids:
    p = ROOT / f'Data/Script/halcyon/arc_fugitif/scene/{i}.lua'
    if not p.exists():
        errors.append(f'{i}: wrapper absent')
        continue
    s = p.read_text()
    if f"C.Play('{i}')" not in s:
        errors.append(f'{i}: wrapper non branché')
    if re.search(r'SCENE_[A-Z0-9_]+', s):
        errors.append(f'{i}: clé brute restante')
    if f'{i} =' not in cin and f'{i}=' not in cin:
        errors.append(f'{i}: beat narratif absent')

for boss in ('Moltres', 'Articuno', 'Ninetales', 'Groudon', 'Rayquaza'):
    if boss not in cin:
        errors.append(f'boss canonique absent: {boss}')

for token in ('Started = true', 'Completed = true'):
    if token not in arc:
        errors.append(f'état arc absent: {token}')

print('AUDIT ARC FUGITIF COMPLET')
print(f'{len(ids)}/27 étapes; 5/5 gardiens; {len(errors)} erreur(s)')
for e in errors:
    print('ERREUR:', e)

raise SystemExit(bool(errors))
