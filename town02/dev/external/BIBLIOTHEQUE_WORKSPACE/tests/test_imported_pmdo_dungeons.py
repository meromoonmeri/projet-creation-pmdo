#!/usr/bin/env python3
import json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parents[1]
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def find(x,needle):
 out=[]
 def walk(v):
  if isinstance(v,dict):
   if needle in v.get('$type',''):out.append(v)
   for q in v.values():walk(q)
  elif isinstance(v,list):
   for q in v:walk(q)
 walk(x);return out
def species(x):
 out=[]
 def walk(v):
  if isinstance(v,dict):
   b=v.get('BaseForm')
   if isinstance(b,dict) and isinstance(b.get('Species'),str):out.append(b['Species'])
   for q in v.values():walk(q)
  elif isinstance(v,list):
   for q in v:walk(q)
 walk(x);return out
class Test(unittest.TestCase):
 def test_01_manifests_and_scale(self):
  rem=load(ROOT/'games/reminiscencia/conversion/pmdo_dungeons/manifest.json');rel=load(ROOT/'games/relict/conversion/pmdo_dungeons/manifest.json');self.assertEqual(rem['result'],'REMINISCENCIA_PMDO_DUNGEONS_PASS');self.assertEqual(rel['result'],'RELICT_PMDO_DUNGEONS_PASS');self.assertEqual(rem['dungeon_count'],17);self.assertEqual(rel['dungeon_count'],5);self.assertEqual(rem['total_floor_count'],402);self.assertEqual(rel['total_floor_count'],120);self.assertEqual(rem['roster_entry_count'],510);self.assertEqual(rel['roster_entry_count'],150);self.assertEqual(rem['stairs_authority'],'RogueElements.FloorStairsStep');self.assertFalse(rem['runtime_destination_written']);self.assertFalse(rel['runtime_destination_written'])
 def test_02_native_stairs_complexity_and_floor_coverage(self):
  for game in ('reminiscencia','relict'):
   root=ROOT/f'games/{game}';m=load(root/'conversion/pmdo_dungeons/manifest.json')
   for row in m['dungeons']:
    z=load(root/row['file'])['Object'];self.assertTrue(z['Released']);self.assertEqual(z['GroundMaps'],[]);self.assertEqual(len(z['Segments']),1);seg=z['Segments'][0];self.assertIn('RangeDictSegment',seg['$type']);nodes=seg['Floors']['nodes'];ranges=[n['Range'] for n in nodes];self.assertEqual(ranges[0]['Min'],0);self.assertEqual(ranges[-1]['Max'],row['floor_count']);self.assertTrue(all(ranges[i]['Max']==ranges[i+1]['Min'] for i in range(len(ranges)-1)))
    for n in nodes:
     floor=n['Item'];self.assertTrue(find(floor,'FloorStairsStep'));self.assertTrue(find(floor,'AddTunnelStep'));ids=[]
     def ids_walk(v):
      if isinstance(v,dict):
       if isinstance(v.get('ID'),str) and 'stairs' in v['ID']:ids.append(v['ID'])
       for q in v.values():ids_walk(q)
      elif isinstance(v,list):
       for q in v:ids_walk(q)
     ids_walk(floor);self.assertTrue(any(x in ('stairs_go_down','stairs_go_up') for x in ids))
    self.assertTrue(find(seg,'SpreadHouseZoneStep'));self.assertTrue(find(seg,'TeamSpawnZoneStep'));self.assertTrue(find(seg,'GridFloorGen'))
 def test_03_enormous_verified_rosters_and_pressure(self):
  for game in ('reminiscencia','relict'):
   root=ROOT/f'games/{game}';m=load(root/'conversion/pmdo_dungeons/manifest.json')
   for row in m['dungeons']:
    z=load(root/row['file']);teams=find(z,'TeamSpawnZoneStep');self.assertTrue(teams);spawned={x['Spawn']['Spawn']['BaseForm']['Species'] for x in teams[0]['Spawns']};self.assertEqual(len(spawned),30);self.assertEqual(spawned,set(row['species']));self.assertIn(3,{x['Spawn'] for x in teams[0]['TeamSizes']});self.assertIn(4,{x['Spawn'] for x in teams[0]['TeamSizes']});settings=find(z,'MobSpawnSettingsStep');self.assertTrue(settings);self.assertTrue(all(x['MaxFoes']==14 and x['RespawnTime']==20 for x in settings))
 def test_04_exact_pmdo_runtime_index(self):
  for game in ('reminiscencia','relict'):
   p=ROOT/f'games/{game}/conversion/pmdo_dungeons/runtime_index_report.json';d=load(p);self.assertEqual(d['result'],'IMPORTED_PMDO_DUNGEONS_RUNTIME_INDEX_PASS');self.assertEqual(d['zone_count'],22);self.assertEqual(d['missing_zone_ids'],[]);self.assertEqual(d['error_signatures'],[]);self.assertFalse(d['runtime_destination_written'])
 def test_05_no_promotion_or_certified_ground_change(self):
  ids=[]
  for game in ('reminiscencia','relict'):
   ids += [x['dungeon_id'] for x in load(ROOT/f'games/{game}/conversion/pmdo_dungeons/manifest.json')['dungeons']]
  self.assertTrue(all(not (REPO/f'Data/Zone/{x}.json').exists() for x in ids));self.assertFalse(any((REPO/'Data/Ground').glob('reminiscencia_*.rsground')));self.assertFalse(any((REPO/'Data/Ground').glob('relict_*.rsground')))
if __name__=='__main__':unittest.main(verbosity=2)
