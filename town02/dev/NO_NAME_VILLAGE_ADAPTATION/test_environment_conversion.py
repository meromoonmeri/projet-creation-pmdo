#!/usr/bin/env python3
from __future__ import annotations
import hashlib,json,struct,unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parent
CANDIDATES=("summer",)
VILLAGE=ROOT/"generated/rmvillage"
SYSTEMS=("halcyon.LivingWorld","halcyon.TownLife","halcyon.TownPlace","halcyon.Seasons","halcyon.Weather","halcyon.TownNight")

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

class EnvironmentConversionTests(unittest.TestCase):
 def test_candidates_are_native_but_not_falsely_promoted(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   self.assertEqual(m["status"],"GENERATED_CANDIDATE")
   self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
   self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS")
   self.assertFalse(m["promotion_allowed"])
   self.assertTrue(all(m["checks"].values()))
   for kind in ("ground","tile","script","source_render","candidate_render"):
    self.assertEqual(sha(root/m["outputs"][kind]),m["outputs"][kind+"_sha256"])

 def test_ground_geometry_and_native_tile_package(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   g=json.loads((root/m["outputs"]["ground"]).read_text(encoding="utf-8-sig"))["Object"]
   self.assertEqual(g["TexSize"],8);self.assertEqual(g["AssetName"],"nnv_rmvillage_"+room)
   self.assertTrue(all(len(layer["Tiles"])==78 and all(len(col)==78 for col in layer["Tiles"]) for layer in g["Layers"]))
   self.assertEqual((len(g["obstacles"]),len(g["obstacles"][0])),(624,624))
   self.assertEqual(m["transform"]["kind"],"identity_spatial_mapping")
   self.assertEqual(m["transform"]["source_dimensions_px"],m["transform"]["target_dimensions_px"])
   png=(root/m["outputs"]["candidate_render"]).read_bytes();self.assertEqual(struct.unpack_from(">II",png,16),(4992,4992))
   tile=(root/m["outputs"]["tile"]).read_bytes();size,count=struct.unpack_from("<II",tile,0)
   self.assertEqual(size,64);self.assertGreater(count,0)

 def test_four_canonical_season_bundles_exist_with_distinct_renders(self):
  render_hashes=set()
  for season in ("spring","summer","autumn","winter"):
   root=VILLAGE/season;m=json.loads((root/"manifest.json").read_text())
   self.assertEqual(m["season"],season);self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
   self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS" if season=="summer" else "NOT_RUN");self.assertFalse(m["promotion_allowed"])
   self.assertTrue(all(m["checks"].values()));render_hashes.add(m["outputs"]["candidate_render_sha256"])
   for kind in ("tile","script","source_render","candidate_render"):
    self.assertEqual(sha(root/m["outputs"][kind]),m["outputs"][kind+"_sha256"])
   if season=="summer": self.assertEqual(m["status"],"GENERATED_CANDIDATE")
   else:
    self.assertEqual(m["status"],"SEASON_LAYER_BUNDLE")
    bundle=root/m["outputs"]["season_layers"]
    self.assertEqual(sha(bundle),m["outputs"]["season_layers_sha256"])
    import gzip
    with gzip.open(bundle,"rt",encoding="utf-8") as stream:data=json.load(stream)
    self.assertEqual(data["dimensions_px"],[4992,4992]);self.assertEqual(data["tex_size"],8)
    self.assertTrue(data["layers"])
  self.assertEqual(len(render_hashes),4)
  summary=json.loads((VILLAGE/"seasons_summary.json").read_text())
  self.assertEqual(summary["visual_bundle_count"],4);self.assertTrue(summary["visual_bundles_generated"])
  self.assertFalse(summary["runtime_switch_validated"]);self.assertFalse(summary["canonical_particles_validated"])
  self.assertEqual(summary["conversion_status"],"UNIMPLEMENTED");self.assertFalse(summary["promotion_allowed"])
  self.assertEqual(sha(VILLAGE/summary["contact_sheet"]),summary["contact_sheet_sha256"])

 def test_canonical_winter_particle_graphics_are_compiled_without_false_completion(self):
  root=VILLAGE/"winter/particles";m=json.loads((root/"manifest.json").read_text())
  self.assertEqual(m["status"],"ASSETS_COMPILED");self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
  self.assertEqual(m["runtime_status"],"NOT_RUN");self.assertFalse(m["promotion_allowed"])
  self.assertEqual(len(m["assets"]),3)
  for row in m["assets"]:
   path=root/row["output"];self.assertEqual(sha(path),row["output_sha256"])
   data=path.read_bytes();png_size,zero=struct.unpack_from("<II",data,0);self.assertEqual(zero,0)
   width,height,loc_height,frames=struct.unpack_from("<IIII",data,8+png_size)
   self.assertEqual([width,height],row["source_dimensions"]);self.assertEqual(frames,row["frame_count"])
   self.assertEqual(loc_height,row["loc_height"]);self.assertEqual(row["pixel_transform"],"identity_1_to_1")
  self.assertTrue(m["blockers"]);self.assertEqual(m["footprint_audio"]["asset_status"],"MISSING_BINARY_OUTSIDE_TRACKED_EXTRACTION")

 def test_existing_new_era_living_systems_are_reused(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   script=(root/m["outputs"]["script"]).read_text()
   self.assertEqual(tuple(m["new_era_systems"]),SYSTEMS)
   for system in SYSTEMS:self.assertIn("require '"+system+"'",script)
   self.assertIn("LivingWorld.ApplyOutdoor(false)",script)
   self.assertNotIn("Seasons.Setup()",script);self.assertNotIn("Seasons.Apply()",script)
   self.assertEqual(m["source"]["repository_commit"],"d1245878861fc76dc5455dbad68bcb45c83f7e1f")
   self.assertFalse(m["canonical_environment_authority"]["generic_new_era_season_particles_allowed_as_substitute"])
   self.assertTrue(any("objwinter particle families" in blocker for blocker in m["blockers"]))
   self.assertTrue(any("wild exploration population" in blocker for blocker in m["blockers"]))
  village=json.loads((VILLAGE/"summer/manifest.json").read_text())
  self.assertTrue(any("native Pokemon living cast" in blocker for blocker in village["blockers"]))

 def test_source_animation_cycles_are_materialized_in_ground_cells(self):
  m=json.loads((VILLAGE/"summer/manifest.json").read_text())
  periods={row["layer"]:row["period_frames"] for row in m["source_animation_layers"]}
  self.assertEqual(periods["trees"],12);self.assertEqual(periods["plants"],12)
  self.assertEqual(periods["instances"],3);self.assertEqual(periods["HouseBelow"],2)
  self.assertTrue(m["checks"]["source_sprite_animation_cycles_compiled"])
  g=json.loads((VILLAGE/"summer"/m["outputs"]["ground"]).read_text(encoding="utf-8-sig"))["Object"]
  frame_counts=[len(tl["Frames"]) for layer in g["Layers"] for col in layer["Tiles"] for cell in col for tl in cell.get("Layers",[])]
  self.assertGreater(max(frame_counts),1);self.assertIn(12,frame_counts)

 def test_runtime_functional_probes_and_native_termination_pass_without_certification(self):
  root=VILLAGE/"summer";m=json.loads((root/"manifest.json").read_text());report=json.loads((root/m["outputs"]["runtime_report"]).read_text())
  self.assertEqual(sha(root/m["outputs"]["runtime_report"]),m["outputs"]["runtime_report_sha256"])
  self.assertEqual(report["functional_runtime_status"],"PASS");self.assertEqual(report["probes"]["load"],"PASS")
  self.assertEqual(report["probes"]["movement"],"PASS");self.assertEqual(report["probes"]["blocked"],"PASS")
  self.assertEqual(report["animation_capture"]["status"],"PASS");self.assertEqual(len(report["captures"]),12)
  for capture in report["captures"]:self.assertEqual(sha(root/"runtime"/capture["file"]),capture["sha256"])
  self.assertEqual(report["termination_status"],"PASS");self.assertEqual(report["runtime_status"],"RUNTIME_TESTED_PASS")
  self.assertTrue(report["termination"]["graceful_exit_observed"]);self.assertEqual(report["termination"]["termination"]["kind"],"NORMAL_EXIT")
  self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS");self.assertEqual(report["certification_status"],"NOT_CERTIFIED");self.assertFalse(report["promotion_allowed"])

 def test_visual_differential_is_bounded_by_pmdo_premultiplication(self):
  for room in CANDIDATES:
   m=json.loads((VILLAGE/room/"manifest.json").read_text());metrics=m["visual_metrics"]
   self.assertTrue(metrics["alpha_exact"]);self.assertLessEqual(metrics["max_channel_error"],1)
   self.assertIn(m["visual_status"],{"TICK0_PIXEL_EXACT","TICK0_PMDO_PREMULTIPLY_ROUNDTRIP_VALID"})

 def test_wildlife_evidence_survives_rejected_scaled_candidate(self):
  evidence=json.loads((ROOT/"reports/rm82-wildlife-source.json").read_text());wild=evidence["wildlife"]
  self.assertEqual(evidence["status"],"SOURCE_ANALYZED");self.assertEqual(evidence["conversion_status"],"UNIMPLEMENTED")
  self.assertIn("1/4 spatial normalization rejected",evidence["superseded_reason"])
  self.assertEqual(wild["source_count"],89);self.assertEqual(wild["native_pokemon_count"],0)
  self.assertTrue(all(row["semantics"]["behavior_class"]=="stationary_spawning_nest" for row in wild["source_placements"]))
  self.assertEqual({row["semantics"]["active_spawn_cap_in_rm82"] for row in wild["source_placements"]},{8})

 def test_pmd_red_certified_destinations_are_not_outputs(self):
  for room in CANDIDATES:
   m=json.loads((VILLAGE/room/"manifest.json").read_text())
   self.assertTrue(m["outputs"]["ground"].startswith("Data/Ground/nnv_"))
  self.assertFalse(any((ROOT/"generated").rglob("d*.rsground")))

if __name__=="__main__":unittest.main(verbosity=2)
