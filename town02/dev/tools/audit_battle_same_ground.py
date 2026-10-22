#!/usr/bin/env python3
"""Vérifie que cinématique et combat utilisent la même salle visuelle."""
from __future__ import annotations
import json,os
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
# map de combat -> ground cinématique source
PAIRS={
 'gloomy_forest_boss':'sinister_woods_clearing',
 'gloomy_forest_miniboss':'gloomy_forest_miniboss',
 'mount_windswept_guardian':'mount_windswept_guardian',
 'magma_cavern_pit':'fosse_ardente',
 'mt_blaze_summit':'d09p03',
 'frosty_forest_summit':'d10p03',
 'vast_steppe_guardian':'vast_steppe_guardian',
 'searing_crucible':'searing_crucible',
 'tour_ciel_sommet':'tour_ciel_sommet',
 'palier_celeste':'palier_celeste',
 'parvis_celeste':'parvis_celeste',
}
errors=[]
for map_id,ground_id in PAIRS.items():
 gp=ROOT/f'Data/Ground/{ground_id}.rsground';mp=ROOT/f'Data/Map/{map_id}.rsmap'
 if not gp.exists() or not mp.exists():errors.append(f'{map_id}: paire absente {ground_id}');continue
 g=json.load(open(gp,encoding='utf-8-sig'))['Object'];m=json.load(open(mp,encoding='utf-8-sig'))['Object']
 tex=8*g.get('TexSize',1)
 if tex==24:expected=(len(g['Layers'][0]['Tiles']),len(g['Layers'][0]['Tiles'][0]))
 else:expected=((len(g['obstacles'])+2)//3,(len(g['obstacles'][0])+2)//3)
 actual=(len(m['Tiles']),len(m['Tiles'][0]))
 if actual!=expected:errors.append(f'{map_id}: combat {actual}, Ground {ground_id} exige {expected}')
 if not m.get('Layers'):errors.append(f'{map_id}: aucune couche visuelle')
 print(f'{map_id:28s} <- {ground_id:28s} {actual} / {expected}')
print(f'RESULTAT: {len(PAIRS)} confrontations, {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(1 if errors else 0)
