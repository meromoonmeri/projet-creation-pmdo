#!/usr/bin/env python3
"""Checks the New Era Rescue Team story/postgame campaign contract."""
from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[1]
def norm(s):return re.sub('[^a-z0-9]','',s.lower())
matrix=json.load(open(ROOT/'docs/canonical/red/dungeon_floor_reference.json'))['dungeons']
technical={'Autopilot','Boss3','Boss4','Boss9','D50','D51','D54','D61','D63','DojoRegistration','FantasyStraitAlt','MtFreezePeakAlt'}
# Peak/grotto/pit/summit are subsegments of their parent zone, not separate destinations.
subsegments={'FrostyGrotto','MagmaCavernPit','MtBlazePeak','MtFreezePeak','MtThunderPeak','SkyTowerSummit'}
expected={norm(x['source_directory']) for x in matrix if x['source_directory'] not in technical|subsegments}
lua=(ROOT/'Data/Script/halcyon/RedCanonicalCampaign.lua').read_text()
registered={norm(x) for x in re.findall(r"'([a-z][a-z0-9_]+)'",lua)}
# Remove state/wave identifiers which are not dungeon IDs.
registered -= {norm(x) for x in ('chapter_11_complete','sea_guardian','buried_legacy','southern_skies','legendary_beasts','western_shadow','wish_and_purity','ocean_routes','guild_requests','survey_routes','sky_tower_legacy','crystal_sanctuary')}
missing=sorted(expected-registered)
zones={p.stem for p in (ROOT/'Data/Zone').glob('*.json')}
zone_ids=set(re.findall(r"zones=\{([^}]+)\}",lua)); referenced=set()
for block in zone_ids:referenced.update(re.findall(r"'([^']+)'",block))
errors=[f'missing campaign destination: {x}' for x in missing]+[f'missing existing-story ZoneData: {x}' for x in sorted(referenced-zones)]
print('AUDIT RED CANONICAL CAMPAIGN')
print(f'{len(expected)} destinations officielles; {len(expected)-len(missing)} enregistrées; {len(referenced)} zones scénario existantes vérifiées')
for e in errors:print('ERREUR:',e)
print(f'RESULTAT: {len(errors)} erreur(s)')
raise SystemExit(bool(errors))
