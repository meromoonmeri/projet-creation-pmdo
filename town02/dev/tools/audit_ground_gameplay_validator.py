#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];svc=(ROOT/'Data/Script/halcyon/services/ground_gameplay_validator/init.lua').read_text();main=(ROOT/'Data/Script/halcyon/main.lua').read_text();errors=[]
for g in ('a02p01','mt_blaze_midpoint','mount_windswept_guardian','d11p03','champ_vent_boreal'):
 if "'"+g+"'" not in svc:errors.append('pilot absent '+g)
 p=ROOT/f'Data/Ground/{g}.rsground'
 if not p.exists():errors.append('Ground absent '+g)
for token in ('PMDO_GROUND_VALIDATOR','EngineServiceEvents.GroundMapEnter','MoveInDirection','ground_gameplay_validator.jsonl','MANUAL_REVIEW'):
 if token not in svc:errors.append('fonction absente '+token)
if "require 'halcyon.services.ground_gameplay_validator'" not in main:errors.append('service non chargé')
print(f'GROUND GAMEPLAY VALIDATOR: 5 pilotes, {len(errors)} erreur(s)')
for e in errors:print('ERROR',e)
raise SystemExit(bool(errors))
