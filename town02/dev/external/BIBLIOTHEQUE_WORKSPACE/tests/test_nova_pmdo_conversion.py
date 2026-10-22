#!/usr/bin/env python3
import hashlib,json,unittest,zipfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];GAME=ROOT/'games/nova';OUT=GAME/'conversion/pmdo_candidates';REPO=ROOT.parents[1]
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
class Test(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.r=load(OUT/'conversion_report.json');c.maps={x['map_id']:x for x in c.r['maps']};c.v=load(GAME/'vfx/manifest.json')
 def test_01_source_and_contract(self):
  s=load(GAME/'metadata/source_archive.json');self.assertEqual(s['verified_sha256'],'d564158bae3cf34dd7e0d00b0377ff7059f91d91bb374a23ece4eff7ddfa94cb');self.assertEqual(s['verified_size_bytes'],284771731);self.assertFalse(s['source_code_executed']);self.assertFalse(s['raw_archive_tracked_in_new_era']);self.assertEqual(s['source_viewport_px'],[960,540]);self.assertEqual(self.r['result'],'NOVA_PMDO_CONVERSION_PASS');self.assertEqual(self.r['map_count'],167);self.assertEqual(self.r['atlas_count'],21);self.assertEqual(self.r['status_counts'],{'ADAPTATION_REQUIRED':167});self.assertEqual(self.r['viewport_contract']['source_viewport_px'],[960,540]);self.assertEqual(self.r['viewport_contract']['pmdo_viewport_px'],[320,240]);self.assertEqual(self.r['viewport_contract']['pmdo_tex_size'],2)
 def test_02_source_renders(self):
  m=load(GAME/'conversion/pmdo_renders/manifest.json');self.assertEqual(m['map_count'],167);self.assertEqual(m['complete_render_count'],103);self.assertEqual(m['diagnostic_render_count'],64)
  for r in m['renders']:
   p=GAME/'conversion/pmdo_renders'/r['file'];self.assertEqual(sha(p),r['sha256']);self.assertFalse(r['actor_pixels_exported'])
 def test_03_bundle_and_atlases(self):
  b=OUT/self.r['ground_storage']['file'];self.assertEqual(sha(b),self.r['ground_storage']['sha256'])
  with zipfile.ZipFile(b) as z:
   self.assertEqual(len(z.infolist()),167);self.assertTrue(all(i.date_time==(1980,1,1,0,0,0) for i in z.infolist()))
   for mid,r in self.maps.items():
    g=json.loads(z.read(f'nova_map_{mid:03d}.rsground').decode('utf-8-sig'));o=g['Object'];self.assertEqual(o['TexSize'],2);self.assertEqual(o['EdgeView'],1);self.assertNotIn('NPCChar',json.dumps(g));self.assertNotIn('MissingNo',json.dumps(g))
  for a in self.r['atlases']:
   p=OUT/a['file'];self.assertEqual(sha(p),a['sha256']);self.assertEqual(int.from_bytes(p.read_bytes()[:4],'little'),16)
 def test_04_sidecars_previews_and_visual_coverage(self):
  self.assertEqual(self.r['default_viewport_exact_fit_count'],24);self.assertEqual(self.r['panorama_converted_map_count'],10);self.assertEqual(self.r['fog_materialized_map_count'],47);self.assertEqual(self.r['environment_sprite_entity_count'],329);self.assertEqual(self.r['environment_sprite_page_context_count'],387);self.assertEqual(self.r['environment_sprite_map_count'],84);self.assertEqual(sum(bool(x['partial_direction_masks']) for x in self.maps.values()),68);self.assertEqual(sum(bool(x['missing_tile_ids']) for x in self.maps.values()),64)
  for mid,r in self.maps.items():
   s=load(OUT/r['sidecar']);self.assertEqual(sha(OUT/r['sidecar']),r['sidecar_sha256']);self.assertEqual(s['source_geometry']['viewport_px'],[960,540]);self.assertEqual(s['pmdo_geometry']['viewport_px'],[320,240]);self.assertTrue(s['entities']['source_identities_redacted']);self.assertEqual(sha(OUT/r['preview']),r['preview_sha256'])
 def test_05_vfx_animation_and_cast_boundary(self):
  self.assertEqual(self.v['result'],'NOVA_ENVIRONMENTAL_VFX_AUDIT_PASS');self.assertEqual(self.v['map_timeline_count'],167);self.assertEqual(self.v['common_event_timeline_count'],9);self.assertEqual(self.v['environment_asset_count'],14);self.assertEqual(self.v['used_rgss_animation_count'],1);self.assertEqual(self.v['used_rgss_animation_frame_count'],24);self.assertEqual(self.v['environment_entity_sprite_sheet_count'],40);self.assertEqual(self.v['environment_entity_sprite_context_count'],387);self.assertEqual(self.v['excluded_character_sheet_count'],185);self.assertEqual(self.v['static_script_visual_audit_required_count'],0);self.assertEqual(self.v['unresolved_environment_count'],0);self.assertFalse(self.v['casting_pixels_exported'])
  a=load(GAME/'animations/manifest.json');self.assertEqual(a['animation_count'],1);self.assertEqual(a['total_frame_count'],24);self.assertEqual(a['frame_duration_ms'],50)
 def test_06_catalog_and_runtime(self):
  c=load(GAME/'manifests/pmdo_catalog.json');self.assertEqual(c['result'],'NOVA_ENCYCLOPEDIC_CATALOG_PASS');self.assertEqual(c['map_count'],167);self.assertEqual(c['tileset_count'],21);self.assertEqual(c['runtime_validated_map_ids'],[3,51]);self.assertEqual({x['map_id'] for x in c['zones']},set(range(1,168)))
  for r in c['zones']:self.assertEqual(sha(GAME/r['file']),r['sha256'])
  for mid in (3,51):
   d=load(OUT/f'runtime/map_{mid:03d}/runtime_report.json');self.assertEqual(d['result'],'NOVA_PMDO_RUNTIME_PASS');self.assertEqual(d['viewport_px'],[320,240]);self.assertTrue(all(x=='PASS' for x in d['runtime_probes'].values()));self.assertLessEqual(d['visual_validation']['environment_max_channel_delta'],1)
 def test_07_no_runtime_promotion(self):
  self.assertFalse(self.r['runtime_destination_written']);self.assertFalse(any((REPO/'Data/Ground').glob('nova_map_*.rsground')));self.assertFalse(any((REPO/'Content/Tile').glob('nova_*.tile')));self.assertTrue(all(x is False for x in self.r['forbidden_content_check'].values()))
if __name__=='__main__':unittest.main(verbosity=2)
