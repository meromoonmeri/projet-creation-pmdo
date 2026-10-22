#!/usr/bin/env python3
import hashlib,json,unittest
from pathlib import Path
GAME=Path(__file__).resolve().parents[1]/"games/reminiscencia";VFX=GAME/"vfx";AN=GAME/"animations"
def load(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
class Test(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.m=load(VFX/"manifest.json");c.a=load(AN/"manifest.json")
 def test_01_audit(self):
  self.assertEqual(self.m["result"],"REMINISCENCIA_ENVIRONMENTAL_VFX_AUDIT_PASS");self.assertEqual(self.m["map_timeline_count"],552);self.assertEqual(self.m["common_event_timeline_count"],50);self.assertEqual(self.m["static_script_visual_audit_required_count"],0);self.assertEqual(self.m["unresolved_environment_count"],0);self.assertFalse(self.m["dialogue_contents_exported"]);self.assertFalse(self.m["script_bodies_exported"]);self.assertFalse(self.m["casting_pixels_exported"])
 def test_02_timelines(self):
  self.assertEqual({x["map_id"] for x in self.m["timelines"]},set(range(1,553)))
  for r in self.m["timelines"]:
   p=GAME/r["file"];self.assertEqual(sha(p),r["sha256"]);d=load(p);self.assertEqual(d["timing"]["nominal_frame_rate"],60);self.assertFalse(d["dialogue_contents_exported"]);self.assertFalse(d["script_bodies_exported"])
 def test_03_assets(self):
  self.assertEqual(len(self.m["environment_assets"]),77);self.assertEqual(self.m["included_environmental_picture_count"],31);self.assertEqual(self.m["animated_environment_asset_count"],8)
  for r in self.m["environment_assets"]:self.assertEqual(sha(GAME/r["output"]),r["output_sha256"])
  self.assertEqual(len(self.m["excluded_assets"]),52)
  for r in self.m["excluded_assets"]:self.assertFalse(r["pixels_exported"]);self.assertNotIn("output",r);self.assertNotIn("source_name",r)
  c=self.m["environment_contact_sheet"];self.assertEqual(sha(VFX/c["file"]),c["sha256"])
 def test_04_animations(self):
  self.assertEqual(self.a["animation_count"],49);self.assertEqual(self.a["total_frame_count"],902);total=0
  for r in self.a["animations"]:
   p=GAME/r["file"];self.assertEqual(sha(p),r["metadata_sha256"]);d=load(p);self.assertFalse(d["audio_exported"]);self.assertFalse(d["casting_sprites_exported"]);total+=d["frame_count"]
   for f in d["frames"]:self.assertEqual(sha(p.parent/f["file"]),f["sha256"]);self.assertTrue(all(c["blend_type"] in (0,1) and c["angle_degrees"]==0 for c in f["cells"]))
  self.assertEqual(total,902)
 def test_05_entities(self):
  self.assertEqual(self.m["environment_entity_sprite_sheet_count"],44);self.assertEqual(self.m["environment_entity_sprite_context_count"],205);self.assertEqual(self.m["excluded_character_sheet_count"],237);total=0
  for r in self.m["environment_entity_sprites"]:
   p=GAME/r["file"];self.assertEqual(sha(p),r["metadata_sha256"]);d=load(p);self.assertFalse(d["casting_pixels_exported"]);self.assertEqual(len(d["frames"]),16);total+=len(d["contexts"])
   for f in d["frames"]:self.assertEqual(sha(p.parent/f["file"]),f["sha256"])
  self.assertEqual(total,205)
 def test_06_catalog(self):
  c=load(GAME/"manifests/pmdo_catalog.json");self.assertEqual(c["result"],"REMINISCENCIA_ENCYCLOPEDIC_CATALOG_PASS");self.assertEqual(c["map_count"],552);self.assertEqual(c["tileset_count"],31);self.assertEqual(c["runtime_validated_map_ids"],[2,7,74,213])
  for r in c["zones"]:self.assertEqual(sha(GAME/r["file"]),r["sha256"])
  for r in c["tilesets"]:self.assertEqual(sha(GAME/r["file"]),r["sha256"])
if __name__=="__main__":unittest.main(verbosity=2)
