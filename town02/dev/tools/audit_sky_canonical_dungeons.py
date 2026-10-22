#!/usr/bin/env python3
from pathlib import Path
import re,json
ROOT=Path(__file__).resolve().parents[1];p=ROOT/'Data/Script/halcyon/SkyCanonicalDungeons.lua';s=p.read_text();errors=[]
required={'dialga':'temporal_tower','palkia':'spacial_rift','giratina':'world_abyss','darkrai':'dark_crater','shaymin':'sky_peak','rayquaza':'sky_stairway','kyogre':'bottomless_sea','groudon':'shimmer_desert','heatran':'giant_volcano','mew':'mystery_jungle','arceus':'destiny_tower','regigigas':'aegis_cave'}
for mon,dungeon in required.items():
 block=re.search(rf'{dungeon}=\{{([^}}]+)\}}',s)
 if not block or mon not in block.group(1):errors.append(f'{mon}: donjon canonique {dungeon} absent')
# Aegis Cave is the first fully active package and must retain all internal rooms.
z=ROOT/'Data/Zone/cloven_ruins.json'
if not z.exists():errors.append('Aegis Cave/cloven_ruins ZoneData absent')
else:
 o=json.load(open(z))['Object'];raw=z.read_text();maps=set(re.findall(r'"MapID"\s*:\s*"([^"]+)"',raw));grounds=set(o.get('GroundMaps',[]));
 for token in ('regice','regirock','registeel','regigigas'):
  if token not in raw.lower() and not any(token in x.lower() for x in maps|grounds):errors.append(f'Aegis Cave: chambre {token} non référencée')
 if len(o.get('Segments',[]))<7:errors.append('Aegis Cave: moins de 7 segments internes')
print('AUDIT DONJONS CANONIQUES SKY')
print(f'{len(required)} légendaires contractualisés; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
