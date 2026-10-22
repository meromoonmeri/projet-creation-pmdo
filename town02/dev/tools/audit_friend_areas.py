#!/usr/bin/env python3
"""Garantit que les Friend Areas PMD Red restent des habitats Grodoudou."""
from __future__ import annotations
import hashlib,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
errors=[]
reserve=[]
for p in (ROOT/'RESERVE/red_grounds').glob('h*.rsground'):
 try:
  if 'MAP_FILE_ID_FRIEND_AREA_' in (json.load(open(p,encoding='utf-8-sig'))['Object'].get('Comment') or ''):reserve.append(p)
 except Exception:pass
if len(reserve)!=57:errors.append(f'réserve Friend Areas: 57 attendues, {len(reserve)} trouvées')
# Empreintes des tilesets correspondant exactement aux 57 Grounds filtrés.
ids={re.search(r'(h\d\dp\d\d)',p.stem,re.I).group(1).lower() for p in reserve}
fh={hashlib.sha256(p.read_bytes()).hexdigest():p.stem for p in (ROOT/'RESERVE/red_tiles').glob('h*.tile') if any(p.stem.lower().startswith(i) for i in ids)}
active=[]
for p in (ROOT/'Content/Tile').glob('*.tile'):
 h=hashlib.sha256(p.read_bytes()).hexdigest()
 if h in fh:active.append((p.stem,fh[h]))
# Toute Friend Area active doit être explicitement un habitat, sans Boss marker.
for gp in (ROOT/'Data/Ground').glob('*.rsground'):
 try:o=json.load(open(gp,encoding='utf-8-sig'))['Object']
 except Exception:continue
 sheets=set()
 for layer in o.get('Layers',[]):
  for col in layer.get('Tiles',[]):
   for tile in col:
    for lay in tile.get('Layers',[]):
     for fr in lay.get('Frames',[]):
      if fr.get('Sheet'):sheets.add(fr['Sheet'])
 if not any(s==a for a,_ in active for s in sheets):continue
 comment=(o.get('Comment') or '').lower()
 if 'grodoudou' not in comment or 'accueil' not in comment:errors.append(f'{gp.name}: Friend Area active sans contrat Grodoudou')
 for e in o.get('Entities',[]):
  if any(m.get('EntName')=='Boss_Marker' for m in e.get('Markers',[])):errors.append(f'{gp.name}: Boss_Marker interdit')
# Aucun document/générateur actif ne doit encore proclamer le rôle d'arène.
gen=(ROOT/'tools/import_wave6_friendareas.py').read_text(errors='ignore')
if "raise SystemExit('INTERDIT:" not in gen:errors.append('ancien générateur Friend Areas -> boss encore exécutable')
print('AUDIT FRIEND AREAS RED')
print(f'57 imports réserve attendus; tilesets canoniques actifs: {active}')
for e in errors:print('ERREUR:',e)
print(f'RESULTAT: {len(errors)} erreur(s)')
raise SystemExit(1 if errors else 0)
