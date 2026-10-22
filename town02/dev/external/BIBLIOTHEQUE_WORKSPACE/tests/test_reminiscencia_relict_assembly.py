#!/usr/bin/env python3
import hashlib,json,unittest,zipfile
from collections import Counter
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
class Test(unittest.TestCase):
 def test_01_all_template_effective_extents(self):
  game=ROOT/'games/reminiscencia';m=load(game/'manifests/assembly_manifest.json');r=load(game/'conversion/pmdo_candidates/conversion_report.json');rows={x['map_id']:x for x in r['maps']};self.assertEqual(m['result'],'REMINISCENCIA_ASSEMBLY_MANIFEST_PASS');self.assertEqual(len(m['map_templates']),340);self.assertEqual(len({x['map_id'] for x in m['map_templates']}),339);self.assertEqual(len(m['generated_dungeons']),17)
  by={}
  for t in m['map_templates']:by.setdefault(t['map_id'],t)
  with zipfile.ZipFile(game/'conversion/pmdo_candidates'/r['ground_storage']['file']) as z:
   for mid,t in by.items():
    row=rows[mid];self.assertEqual(row['assembly_role'],'COMPONENT_TEMPLATE');self.assertEqual(row['pmdo_dimensions_px'],[t['effective_width_tiles']*16,t['effective_height_tiles']*16]);g=json.loads(z.read(f'reminiscencia_map_{mid:03d}.rsground').decode('utf-8-sig'))['Object'];self.assertEqual([len(g['Layers'][0]['Tiles']),len(g['Layers'][0]['Tiles'][0])],[t['effective_width_tiles'],t['effective_height_tiles']]);s=load(game/'conversion/pmdo_candidates'/row['sidecar']);self.assertEqual(s['effective_template_geometry']['authority'],'Data/MapTemplates.dat')
 def test_02_dungeon_composition_coverage(self):
  m=load(ROOT/'games/reminiscencia/manifests/assembly_manifest.json');d={x['map_id']:x for x in m['generated_dungeons']};self.assertEqual(set(d),{7,84,119,164,191,203,213,195,296,299,208,341,319,417,446,468,518});self.assertTrue(all(x['template_names'] for x in d.values()));self.assertTrue(all(x['composition']=='SOURCE_GENERATED_SNAPSHOT_PLUS_RUNTIME_TEMPLATE_RULES' for x in d.values()));assigned={n for x in d.values() for n in x['template_names']};unassigned={x['template_name'] for x in m['map_templates'] if x['template_name'] not in assigned};self.assertEqual(unassigned,{'QuemStone','CuFRoca'})
 def test_03_dynamic_layers_and_controllers(self):
  for game,expected in [('reminiscencia',95),('relict',13)]:
   root=ROOT/f'games/{game}';m=load(root/'manifests/assembly_manifest.json');r=load(root/'conversion/pmdo_candidates/conversion_report.json');self.assertEqual(r['assembly']['dynamic_environment_map_count'],expected);self.assertTrue(all(not(x['black_pixel_ratio']>=.999 and not x['intentional_or_nonvisual']) for x in m['black_audit']));roles=Counter(x['role'] for x in m['maps']);self.assertTrue(roles['LOGIC_CONTROLLER']>0);self.assertTrue(all(x['viewport']['zoom_change'] is False for x in m['maps']));self.assertTrue(all(x['viewport']['mode']!='GLOBAL_FIT' for x in m['maps']))
  rel=load(ROOT/'games/relict/manifests/assembly_manifest.json');roles={x['map_id']:x['role'] for x in rel['maps']};self.assertEqual({x for x,v in roles.items() if v=='LOGIC_CONTROLLER'},{3,4,10,15});self.assertEqual({x for x,v in roles.items() if v=='INTENTIONAL_SCENE_VOID'},{13,19,25,27});self.assertEqual(roles[1],'CINEMATIC_TRANSITION')
 def test_04_viewport_is_individual_and_metano_is_only_behavior_reference(self):
  rem=load(ROOT/'games/reminiscencia/manifests/assembly_manifest.json');modes=Counter(x['viewport']['mode'] for x in rem['maps']);self.assertGreaterEqual(len(modes),4);self.assertEqual(modes['INHERIT_GENERATED_DUNGEON'],339);self.assertGreater(modes['PLAYER_FOLLOW_CLAMP'],0);self.assertGreater(modes['ORIGINAL_ONE_SCREEN_CLAMP'],0);self.assertGreater(modes['FIXED_SCENE_320x240'],0)
 def test_05_runtime_proofs_after_assembly(self):
  rem=ROOT/'games/reminiscencia/conversion/pmdo_candidates/runtime';rel=ROOT/'games/relict/conversion/pmdo_candidates/runtime'
  for root,ids,result in [(rem,(2,7,74,213),'REMINISCENCIA_PMDO_RUNTIME_PASS'),(rel,(2,7,12),'RELICT_PMDO_RUNTIME_PASS')]:
   for mid in ids:
    d=load(root/f'map_{mid:03d}/runtime_report.json');self.assertEqual(d['result'],result);self.assertEqual(d['viewport_px'],[320,240]);self.assertTrue(all(x=='PASS' for x in d['runtime_probes'].values()));self.assertLessEqual(d['visual_validation']['environment_max_channel_delta'],1)
if __name__=='__main__':unittest.main(verbosity=2)
