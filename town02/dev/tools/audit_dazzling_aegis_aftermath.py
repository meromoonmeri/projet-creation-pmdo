#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];errors=[]
mod=(ROOT/'Data/Script/halcyon/TeamDazzlingAegis.lua').read_text();init=(ROOT/'Data/Script/halcyon/ground/cloven_ruins_entrance/init.lua').read_text();sv=(ROOT/'Data/Script/halcyon/scriptvars.lua').read_text()
for x in ('Adagio','Aria','Sonata','Sinister Woods','MissionAvailable'): 
 if x not in mod:errors.append(f'beat absent: {x}')
if 'TeamCharm' in mod or 'TeamCharm' in init:errors.append('Team Charm encore utilisée dans Aegis Cave')
win=init.find('VaincuRegigigas');call=init.find('TeamDazzlingAegis.Aftermath()')
if win<0 or call<win:errors.append('after-scene non placée après victoire Regigigas')
if 'DazzlingAegisAftermath = false' not in sv:errors.append('flag sauvegarde absent')
print('AUDIT FIN AEGIS CAVE / TEAM DAZZLING')
print(f'cast 3/3; après Regigigas; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
