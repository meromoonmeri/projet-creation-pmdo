#!/usr/bin/env python3
import hashlib,json,unittest,zipfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];GAME=ROOT/'games/relict';OUT=GAME/'conversion/pmdo_candidates';REPO=ROOT.parents[1]
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
class Test(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.r=load(OUT/'conversion_report.json');c.maps={x['map_id']:x for x in c.r['maps']}
 def test_01_contract(self):
  self.assertEqual(self.r['result'],'RELICT_PMDO_CONVERSION_PASS');self.assertEqual(self.r['map_count'],28);self.assertEqual(self.r['atlas_count'],8);self.assertEqual(self.r['status_counts'],{'ADAPTATION_REQUIRED':3,'PMDO_CONVERTED':25});self.assertEqual(self.r['default_viewport_exact_fit_count'],6);self.assertEqual(self.r['viewport_contract']['pmdo_viewport_px'],[320,240]);self.assertEqual(self.r['viewport_contract']['pmdo_tile_size_px'],16);self.assertEqual(self.r['viewport_contract']['pmdo_tex_size'],2);self.assertEqual(self.r['viewport_contract']['pmdo_collision_size_px'],8);self.assertEqual(self.r['autotile_timing']['frame_length_ticks'],15)
 def test_02_bundle_and_grounds(self):
  b=OUT/self.r['ground_storage']['file'];self.assertEqual(sha(b),self.r['ground_storage']['sha256'])
  with zipfile.ZipFile(b) as z:
   self.assertEqual(len(z.infolist()),28);self.assertTrue(all(i.date_time==(1980,1,1,0,0,0) for i in z.infolist()))
   for mid,row in self.maps.items():
    g=json.loads(z.read(f'relict_map_{mid:03d}.rsground').decode('utf-8-sig'));o=g['Object'];self.assertEqual(o['TexSize'],2);self.assertEqual(o['EdgeView'],1);self.assertEqual(row['pmdo_dimensions_px'],[len(o['Layers'][0]['Tiles'])*16,len(o['Layers'][0]['Tiles'][0])*16]);text=json.dumps(g);self.assertNotIn('NPCChar',text);self.assertNotIn('MissingNo',text)
 def test_03_atlases_and_sidecars(self):
  for a in self.r['atlases']:
   p=OUT/a['file'];self.assertEqual(sha(p),a['sha256']);self.assertEqual(int.from_bytes(p.read_bytes()[:4],'little'),16)
  for mid,row in self.maps.items():
   p=OUT/row['sidecar'];self.assertEqual(sha(p),row['sidecar_sha256']);d=load(p);self.assertEqual(d['map_id'],mid);self.assertEqual(d['pmdo_geometry']['tile_size_px'],16);self.assertEqual(d['pmdo_geometry']['viewport_px'],[320,240]);self.assertTrue(d['entities']['source_identities_redacted']);self.assertEqual(d['partial_direction_masks'],row['partial_direction_masks'])
 def test_04_previews(self):
  source=load(GAME/'conversion/pmdo_renders/manifest.json');dims={x['map_id']:[x['width_px']//2,x['height_px']//2] for x in source['renders'] if x['variant'] is None}
  for mid,row in self.maps.items():
   p=OUT/row['preview'];self.assertEqual(sha(p),row['preview_sha256']);raw=p.read_bytes();self.assertEqual(raw[:8],b'\x89PNG\r\n\x1a\n');self.assertEqual(row['pmdo_dimensions_px'],dims[mid])
  c=self.r['contact_sheet'];self.assertEqual(sha(OUT/c['file']),c['sha256'])
 def test_05_runtime(self):
  for mid in (2,12):
   d=load(OUT/f'runtime/map_{mid:03d}/runtime_report.json');self.assertEqual(d['result'],'RELICT_PMDO_RUNTIME_PASS');self.assertEqual(d['validation_status'],'PMDO_VALIDATED');self.assertEqual(d['viewport_px'],[320,240]);self.assertTrue(all(x=='PASS' for x in d['runtime_probes'].values()));self.assertLessEqual(d['visual_validation']['environment_max_channel_delta'],1);self.assertTrue(all(x is False for x in d['forbidden_content_check'].values()))
 def test_06_boundary(self):
  self.assertFalse(self.r['runtime_destination_written']);self.assertFalse(any((REPO/'Content/Tile').glob('relict_*.tile')));self.assertFalse(any((REPO/'Data/Ground').glob('relict_map_*.rsground')));self.assertTrue(all(x is False for x in self.r['forbidden_content_check'].values()))
if __name__=='__main__':unittest.main(verbosity=2)
