#!/usr/bin/env python3
import hashlib,json,unittest,zipfile
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]/"games/reminiscencia/conversion/pmdo_candidates";REPO=Path(__file__).resolve().parents[3];sys.path.insert(0,str(Path(__file__).resolve().parents[1]/"tools"))
from convert_map_ir_to_pmdo import read_tile
from png_rgba import load_png
def load(p):return json.loads(p.read_text(encoding="utf-8-sig"))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
class Test(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.r=load(ROOT/"conversion_report.json")
 def test_01_contract(self):
  self.assertEqual(self.r["map_count"],552);self.assertEqual(self.r["default_viewport_exact_fit_count"],121);self.assertEqual(self.r["viewport_contract"]["pmdo_viewport_px"],[320,240]);self.assertEqual(self.r["viewport_contract"]["pmdo_tile_size_px"],16);self.assertEqual(self.r["viewport_contract"]["pmdo_collision_size_px"],8);self.assertEqual(self.r["viewport_contract"]["pmdo_tex_size"],2);self.assertEqual(self.r["assembly"]["viewport_policy"],"PER_MAP_NO_GLOBAL_ZOOM")
 def test_02_bundle(self):
  b=ROOT/self.r["ground_storage"]["file"];self.assertEqual(sha(b),self.r["ground_storage"]["sha256"])
  with zipfile.ZipFile(b) as z:
   self.assertEqual(len(z.namelist()),552)
   for row in self.r["maps"]:
    raw=z.read(Path(row["ground"]).name);self.assertEqual(hashlib.sha256(raw).hexdigest(),row["ground_sha256"]);g=json.loads(raw.decode("utf-8-sig"));self.assertEqual(g["Object"]["TexSize"],2);self.assertEqual(g["Object"]["EdgeView"],1);self.assertFalse(g["Object"]["Released"])
 def test_03_atlases(self):
  self.assertEqual(self.r["atlas_count"],31)
  for a in self.r["atlases"]:
   p=ROOT/a["file"];self.assertEqual(sha(p),a["sha256"]);size,nodes=read_tile(p);self.assertEqual(size,16);self.assertTrue(nodes)
 def test_04_sidecars(self):
  for row in self.r["maps"]:
   p=ROOT/row["sidecar"];self.assertEqual(sha(p),row["sidecar_sha256"]);s=load(p);self.assertEqual(s["partial_collision_policy"],"CONSERVATIVE_FULL_BLOCK_IN_GROUND_EXACT_MASK_IN_SIDECAR");self.assertTrue(s["entities"]["source_identities_redacted"]);self.assertEqual(len(s["collision"]["allowed_direction_masks"]),s["source_geometry"]["height_tiles"])
   for e in s["entities"]["placements"]:
    self.assertNotIn("name",e);self.assertNotIn("dialogue",e);self.assertNotIn("script",e)
 def test_05_status_and_visual_coverage(self):
  self.assertEqual(self.r["status_counts"],{"ADAPTATION_REQUIRED":139,"PMDO_CONVERTED":412,"UNSUPPORTED":1});self.assertEqual(self.r["panorama_converted_map_count"],14);self.assertEqual(self.r["fog_materialized_map_count"],56);self.assertEqual(self.r["environment_sprite_entity_count"],171);self.assertEqual(self.r["environment_sprite_page_context_count"],205);self.assertEqual(self.r["environment_sprite_map_count"],31)
 def test_06_previews_contacts(self):
  for row in self.r["maps"]:
   p=ROOT/row["preview"];self.assertEqual(sha(p),row["preview_sha256"]);im=load_png(p);self.assertEqual([im.width,im.height],row["pmdo_dimensions_px"])
  self.assertEqual(sha(ROOT/self.r["contact_sheet"]["file"]),self.r["contact_sheet"]["sha256"]);self.assertEqual(len(self.r["contact_pages"]),12)
 def test_07_runtime(self):
  dims={2:[480,640],7:[320,240],74:[320,240],213:[320,240]}
  for mid,dim in dims.items():
   d=load(ROOT/f"runtime/map_{mid:03d}/runtime_report.json");self.assertEqual(d["result"],"REMINISCENCIA_PMDO_RUNTIME_PASS");self.assertEqual(d["viewport_px"],[320,240]);self.assertEqual(d["visual_validation"]["dimensions_px"],dim);self.assertLessEqual(d["visual_validation"]["environment_max_channel_delta"],1);self.assertTrue(all(x=="PASS" for x in d["runtime_probes"].values()))
 def test_08_boundary(self):
  self.assertFalse(self.r["runtime_destination_written"]);self.assertFalse((REPO/"Data/Ground/reminiscencia_map_074.rsground").exists());self.assertFalse(any((REPO/"Content/Tile").glob("reminiscencia_*.tile")));self.assertTrue(all(v is False for v in self.r["forbidden_content_check"].values()))
if __name__=="__main__":unittest.main(verbosity=2)
