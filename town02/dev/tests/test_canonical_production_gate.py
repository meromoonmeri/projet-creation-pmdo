#!/usr/bin/env python3
"""Fail-closed tests added after the engine/canonical corrective audit."""
from __future__ import annotations

import hashlib
import json
import re
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "tools"))

from dungeon_builder.canonical_gate import assert_batch_ready, inspect
from dungeon_builder.definitions import load_definition
from dungeon_builder.rng import DungeonRng
from dungeon_builder.zone_export import build_zone

SINISTER = REPO / "DungeonDefs" / "canonical" / "sinister_woods.json"
MANIFEST = REPO / "docs" / "canonical" / "red" / "sinister_woods_rom_manifest.json"
RED_BATCH_REPORT = REPO / "docs" / "canonical" / "red" / "PMD_RED_BATCH_EXTRACTION.json"
SCOPE_111 = REPO / "DungeonDefs" / "canonical_scope_111.json"
RED_STORY_01_REPORT = (REPO / "docs/dungeon_builder/batches/red_story_01/batch_report.json")
RED_STORY_01_JSONL = (REPO / "docs/dungeon_builder/batches/red_story_01/runtime/native_mapgen.jsonl")
RED_STORY_02_REPORT = (REPO / "docs/dungeon_builder/batches/red_story_02/batch_report.json")
RED_RESOLUTION_AUDIT = REPO / "docs/canonical/red/PMD_RED_RESOLUTION_AUDIT.json"
ENGINE_REPORT = REPO / "docs" / "dungeon_builder" / "ENGINE_PROTOTYPE_NATIVE.md"
ENGINE_JSONL = REPO / "docs" / "dungeon_builder" / "runtime" / "engine_prototype_native.jsonl"
SINISTER_SMOKE_JSONL = (REPO / "docs" / "dungeon_builder" / "runtime" /
                        "sinister_candidate_native_smoke.jsonl")
SINISTER_RUNTIME_JSONL = (REPO / "docs" / "dungeon_builder" / "runtime" /
                          "sinister_canonical_candidate_runtime.jsonl")
FINAL_STAGE_REPORT = REPO / "docs" / "dungeon_builder" / "SINISTER_FINAL_STAGE_REPORT.json"
ROUTE_REPORT = REPO / "docs" / "dungeon_builder" / "SINISTER_ROUTE_RUNTIME_PASS.json"
ROUTE_JSONL = (REPO / "docs" / "dungeon_builder" / "runtime" /
               "sinister_full_route_runtime.jsonl")
ACTIVE_RUNTIME_JSONL = (REPO / "docs" / "dungeon_builder" / "runtime" /
                        "sinister_active_native_runtime.jsonl")
FINAL_GROUND = REPO / "Data" / "Ground" / "sinister_woods_clearing.rsground"
FINAL_MAP = REPO / "Data" / "Map" / "gloomy_forest_boss.rsmap"
FINAL_TILE = REPO / "Content" / "Tile" / "gloomy_forest_boss_Canonical_Final_Render.tile"


class TestCanonicalGate(unittest.TestCase):
    def test_batch_is_blocked_until_every_definition_has_runtime_proof(self):
        with self.assertRaisesRegex(ValueError, "canonical batch gate blocked"):
            assert_batch_ready()

    def test_sinister_configuration_and_active_runtime_route_are_validated(self):
        result = inspect(SINISTER)
        self.assertTrue(result.config_ready, result.blockers)
        self.assertTrue(result.runtime_ready)
        self.assertEqual(result.runtime_state, "validated")
        # Runtime validation does not approve the other 50 scaffolds for batch.
        self.assertFalse(result.batch_approved)

    def test_native_trap_table_and_placement_are_both_emitted(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["features"] = {
            "traps": {
                "enabled": True,
                "floors": [1, raw["floors"]],
                "amount": [3, 4],
                "entries": [
                    {"source": "Wonder Tile", "tile": "tile_wonder",
                     "weight": 10000, "revealed": True}
                ],
            }
        }
        from dungeon_builder.definitions import parse_definition
        zone = build_zone(parse_definition(raw), DungeonRng(seed=1234)).zone_json["Object"]
        for segment in zone["Segments"]:
            if not segment["IsRelevant"]:
                continue
            zone_types = [step["$type"] for step in segment["ZoneSteps"]]
            self.assertTrue(any("TileSpawnZoneStep" in kind for kind in zone_types))
            for floor in segment["Floors"]:
                for candidate in floor["Spawns"]:
                    floor_types = [step["Value"]["$type"]
                                   for step in candidate["Spawn"]["GenSteps"]]
                    self.assertTrue(any("RandomRoomSpawnStep" in kind and "EffectTile" in kind
                                        for kind in floor_types))

    def test_polymorphic_gensteps_put_type_metadata_first(self):
        from dungeon_builder import steps
        for step in (steps.floor_stairs(4), steps.floor_stairs_distance((20, 120)),
                     steps.trap_spawn_step((3, 4))):
            self.assertEqual(next(iter(step)), "$type")

    def test_production_profiles_are_selected_by_native_chance_floor_gen(self):
        definition = load_definition(SINISTER)
        zone = build_zone(definition, DungeonRng(seed=1234)).zone_json["Object"]
        for segment in zone["Segments"]:
            if not segment["IsRelevant"]:
                continue
            for floor in segment["Floors"]:
                self.assertIn("ChanceFloorGen", floor["$type"])
                self.assertGreaterEqual(len(floor["Spawns"]), 2)
                for candidate in floor["Spawns"]:
                    grid = candidate["Spawn"]
                    comment = grid["Comment"]
                    self.assertIn("profile:", comment)
                    self.assertNotIn("authoring-seed", comment)
                    kinds = [step["Value"]["$type"] for step in grid["GenSteps"]]
                    self.assertTrue(any("DueSpawnStep" in kind for kind in kinds))
                    self.assertTrue(any("TerminalSpawnStep" in kind for kind in kinds))
                    self.assertTrue(any("PlaceRandomMobsStep" in kind for kind in kinds))


class TestItemMappingSafety(unittest.TestCase):
    def test_missing_orb_is_not_silently_changed_into_a_seed(self):
        import build_canonical_definitions as canonical_builder
        conversion = canonical_builder.load_item_conversion()
        prices = canonical_builder.known_items()
        self.assertIsNone(canonical_builder.convert_item("ITEM_WARP_ORB", conversion, prices))
        self.assertEqual(canonical_builder.convert_item("ITEM_LUMINOUS_ORB", conversion, prices),
                         "orb_luminous")


class TestRedSourceGlobalTables(unittest.TestCase):
    def test_global_main_data_rows_may_cross_assembler_lines(self):
        from dungeon_builder.red_source import FIELD_NAMES, parse_global_main_data
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "Early").mkdir()
            local = ", ".join(f"0x{value:02x}" for value in range(len(FIELD_NAMES)))
            (root / "Early/main_data.inc").write_text(f".byte {local}\n")
            values = list(range(len(FIELD_NAMES))) + list(range(40, 40 + len(FIELD_NAMES)))
            first = ", ".join(f"0x{value:02x}" for value in values[:36])
            second = ", ".join(f"0x{value:02x}" for value in values[36:])
            (root / "main_data.inc").write_text(
                '#include "Early/main_data.inc"\n' + f".byte {first}\n.byte {second}\n")
            offset, rows = parse_global_main_data(root / "main_data.inc")
        self.assertEqual(offset, 1)
        self.assertEqual(len(rows), 2)
        self.assertEqual(rows[0]["layout"], 0)
        self.assertEqual(rows[1]["layout"], 40)

    def test_borrowed_absolute_pokemon_table_is_resolved(self):
        from dungeon_builder.red_source import resolve_pokemon_table
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for folder, base, names in (("Local", 10, ["local"]),
                                        ("Owner", 20, ["owner-20", "owner-21"])):
                path = root / folder
                path.mkdir()
                (path / "floor_id.json").write_text(json.dumps({
                    "tables": [{"Pokemon": base}],
                }))
                (path / "pokemon_found.json").write_text(json.dumps({
                    "tables": [{"name": name, "pokemon": []} for name in names],
                }))
            table, source = resolve_pokemon_table(
                root, [{"name": "local", "pokemon": []}], 10, 21,
                root / "Local/pokemon_found.json")
        self.assertEqual(table["name"], "owner-21")
        self.assertEqual(source.parent.name, "Owner")


class TestRedBatchExtraction(unittest.TestCase):
    def test_all_51_red_sources_are_extracted_but_not_mass_promoted(self):
        report = json.loads(RED_BATCH_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["source"]["commit"],
                         "bf0092d0e34fd8e49b859a0b5f96f00740faa42d")
        self.assertEqual(report["summary"], {
            "requested": 51, "extracted": 51, "errors": 0, "bytes": 5191964,
            "runtime_validated": 1, "reconciliation_required": 50,
            "source_conflicts": 69, "zones_generated": 0, "zones_promoted": 0,
        })
        for row in report["entries"]:
            path = REPO / "docs/canonical/red" / f"{row['definition']}_rom_manifest.json"
            self.assertTrue(path.is_file(), row["definition"])

    def test_tiny_woods_scaffold_conflicts_are_fail_closed(self):
        report = json.loads(RED_BATCH_REPORT.read_text(encoding="utf-8"))
        tiny = next(row for row in report["entries"] if row["definition"] == "tiny_woods")
        self.assertEqual(tiny["reconciliation"]["state"], "RECONCILIATION_REQUIRED")
        self.assertEqual(set(tiny["reconciliation"]["source_conflicts"]), {
            "INVENTED_SHOP_SOURCE_CHANCE_ZERO",
            "INVENTED_MONSTER_HOUSE_SOURCE_CHANCE_ZERO",
            "INVENTED_TRAPS_SOURCE_DENSITY_ZERO",
        })


class TestPriorityScopeAndFirstBatch(unittest.TestCase):
    def test_machine_inventory_is_exactly_64_plus_47(self):
        scope = json.loads(SCOPE_111.read_text(encoding="utf-8"))
        self.assertEqual(scope["summary"]["total"], 111)
        self.assertEqual(scope["summary"]["pmd_red_eu"], 64)
        self.assertEqual(scope["summary"]["pmdodump"], 47)
        self.assertEqual(sum(row["source"] == "PMD_RED_ROM" for row in scope["entries"]), 64)
        self.assertEqual(sum(row["source"] == "PMDODUMP" for row in scope["entries"]), 47)
        self.assertTrue(all("blockers" in row for row in scope["entries"]))

    def test_missing_documented_pmdodump_entry_is_source_identified(self):
        scope = json.loads(SCOPE_111.read_text(encoding="utf-8"))
        glacial = next(row for row in scope["entries"]
                       if row.get("upstream_id") == "Glacial_Path")
        self.assertEqual(glacial["status"], "SOURCE_INVENTORIED_UNMAPPED")
        self.assertIn("PROJECT_MAPPING_MISSING", glacial["blockers"])
        self.assertEqual(glacial["source_assets"][0]["path"],
                         "DataAsset/Zone/Glacial_Path.out.txt")

    def test_resolution_audit_exhausts_current_exact_mappings(self):
        # After the PMDO_UNAVAILABLE_ITEMS whitelist (see
        # tools/dungeon_builder/red_story_batch.py) was introduced, dungeons
        # that only referenced Red-era orbs/TMs with no PMDO 0.8.9 equivalent
        # became SOURCE_RESOLVABLE. Real unmapped items are still hard blockers.
        audit = json.loads(RED_RESOLUTION_AUDIT.read_text(encoding="utf-8"))
        self.assertEqual(audit["summary"], {
            "manifests": 51, "source_resolvable": 8, "blocked": 43,
            "fixed_floor_blocked": 26, "item_mapping_blocked": 39,
            "any_items_skipped": 46,
        })
        resolvable = {row["definition"] for row in audit["entries"]
                      if row["state"] == "SOURCE_RESOLVABLE"}
        self.assertEqual(resolvable, {
            "tiny_woods", "thunderwave_cave",
            # Newly resolvable after the whitelist / legacy-override fix:
            "silent_chasm", "great_canyon",
            "mt_thunder", "mt_blaze", "mt_freeze", "lapis_cave",
        })
        # Mt Steel still requires a canonical fixed-room 1 counterpart on
        # floor 9 (Skarmory battle) — item skipping alone cannot unblock it.
        steel = next(row for row in audit["entries"] if row["definition"] == "mt_steel")
        self.assertEqual(steel["fixed_floors"], [9])
        # After the whitelist, mt_steel's four blocked orbs are documented as
        # skipped (NOT_IN_PMDO_0_8_9_BASE) rather than "missing".
        self.assertFalse(steel["missing_items"],
                         "mt_steel must not report any orb as unmapped after whitelist")
        self.assertTrue(steel["skipped_items"],
                        "mt_steel's Red-only orbs must be documented as skipped")

    def test_second_batch_produces_documented_skips_not_silent_drops(self):
        # Silent Chasm and Great Canyon are now staged. The batch must
        # (a) succeed at staging, (b) record every ROM item omitted from the
        # PMDO canonical_floor_items block in skipped_by_reason so the trace
        # from PMD Red ROM -> PMDO ZoneData remains explicit and auditable.
        report = json.loads(RED_STORY_02_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["summary"]["staged"], 2)
        self.assertEqual(report["summary"]["blocked"], 0)
        for stem in ("silent_chasm", "great_canyon"):
            path = REPO / "DungeonDefs/staging/red_story_02" / f"{stem}.json"
            self.assertTrue(path.is_file(), f"missing staged definition: {path}")
            defn = json.loads(path.read_text(encoding="utf-8"))
            block = defn["segments"][0]["items"]["canonical_floor_items"]
            self.assertGreater(len(block["entries"]), 20,
                               f"{stem} must keep a rich canonical item table")
            skipped = block.get("skipped_by_reason", {})
            self.assertIn("NOT_IN_PMDO_0_8_9_BASE", skipped,
                          f"{stem} must document at least one skip")
            for iid in skipped["NOT_IN_PMDO_0_8_9_BASE"]:
                self.assertTrue(iid.startswith("ITEM_"),
                                f"skipped id must stay as ROM constant: {iid}")

    def test_first_batch_has_80_of_80_native_generations(self):
        report = json.loads(RED_STORY_01_REPORT.read_text(encoding="utf-8"))
        # After ROM audio extraction (see docs/canonical/red/audio/
        # pmdred_eu_music_extraction.json) Tiny Woods.ogg and
        # Thunderwave Cave.ogg were rendered from the SHA-verified PMD Red EU
        # ROM and both dungeons were promoted.
        self.assertEqual(report["summary"], {
            "requested": 2, "staged": 2, "generated": 2,
            "runtime_pmdo_mapgen_validated": 2, "route_validated": 2,
            "promoted": 2, "blocked": 0,
        })
        self.assertEqual(report["runtime_evidence"]["end"], {
            "event": "end", "attempted": 80, "generated": 80,
            "failures": 0, "non_traversable": 0, "invalid": 0,
        })
        rows = [json.loads(line) for line in RED_STORY_01_JSONL.read_text().splitlines()]
        floors = [row for row in rows if row.get("event") == "floor"]
        self.assertEqual(len(floors), 80)
        self.assertTrue(all(row["valid"] and row["traversable"] and row["seed"]
                            for row in floors))
        self.assertEqual({row["zone"] for row in floors},
                         {"tiny_woods", "thunderwave_cave"})

    def test_first_batch_is_promoted_after_rom_audio_extraction(self):
        # Both first-batch dungeons are now promoted: the required PMDO music
        # assets are canonical .ogg renders derived from the SHA-verified
        # PMD Red EU ROM (see tools/dungeon_builder/rom_audio_extract.py).
        # The runtime state must reflect that, and the staged candidate zone
        # must be byte-for-byte identical to the active zone.
        for stem in ("tiny_woods", "thunderwave_cave"):
            staged = REPO / f"DungeonDefs/staging/red_story_01/{stem}.json"
            gate = inspect(staged)
            self.assertTrue(gate.config_ready, gate.blockers)
            self.assertEqual(gate.runtime_state, "validated")
            candidate = REPO / f"Staging/dungeon_builder/red_story_01/Data/Zone/{stem}.json"
            active = REPO / f"Data/Zone/{stem}.json"
            self.assertTrue(candidate.is_file())
            self.assertEqual(hashlib.sha256(candidate.read_bytes()).hexdigest(),
                             hashlib.sha256(active.read_bytes()).hexdigest())

    def test_first_batch_removes_rom_conflicts_and_keeps_floor_rules(self):
        tiny = json.loads((REPO / "DungeonDefs/staging/red_story_01/tiny_woods.json").read_text())
        wave = json.loads((REPO / "DungeonDefs/staging/red_story_01/thunderwave_cave.json").read_text())
        for raw in (tiny, wave):
            self.assertFalse(raw["features"]["shop"]["enabled"])
            self.assertFalse(raw["features"]["monster_house"]["enabled"])
            self.assertEqual(len(raw["segments"][0]["floor_overrides"]), raw["floors"])
            self.assertTrue(all(row["source_floor"]["kind"] == "PMD_RED_ROM"
                                for row in raw["segments"][0]["floor_overrides"].values()))
        self.assertFalse(tiny["features"]["traps"]["enabled"])
        self.assertTrue(wave["features"]["traps"]["enabled"])
        self.assertEqual(tiny["dtef"]["name"], "tiny_woods")
        self.assertEqual(wave["dtef"]["name"], "thunderwave_cave")
        tiny_items = tiny["segments"][0]["items"]["canonical_floor_items"]["entries"]
        self.assertEqual({tuple(row["floors"]) for row in tiny_items}, {(3, 3)})

    def test_first_batch_routes_pass_and_promotion_succeeds(self):
        # Post-audio-extraction: both entries must be fully promoted with no
        # blockers, but the route evidence itself (canonical_complete, zero
        # fatals) must remain intact so any future audit can still verify that
        # promotion did not skip the route gate.
        report = json.loads(RED_STORY_01_REPORT.read_text(encoding="utf-8"))
        for entry in report["entries"]:
            self.assertEqual(entry["status"], "PROMOTED_RUNTIME_VALIDATED")
            self.assertEqual(entry["blockers"], [])
            route = REPO / entry["route_runtime"]["jsonl"]
            rows = [json.loads(line) for line in route.read_text().splitlines()]
            self.assertTrue(rows[-1]["canonical_complete"])
            self.assertEqual([row for row in rows if row.get("event") == "fatal"], [])

    def test_first_batch_music_asset_gate_still_blocks_missing_audio(self):
        # Regression guard: even after Tiny Woods.ogg / Thunderwave Cave.ogg
        # were extracted from the ROM, the gate that refuses promotion when a
        # canonical music asset is missing must still be present in the batch
        # code path. This test does not run the batch; it enforces that the
        # blocker label and the promotion decision remain wired together.
        source = (REPO / "tools/dungeon_builder/red_story_batch.py").read_text(
            encoding="utf-8"
        )
        self.assertIn("CANONICAL_MUSIC_ASSET_MISSING", source)
        self.assertIn("asset_blockers", source)
        self.assertIn('local_music', source)
        # And the currently-required assets must exist as canonical .ogg files
        # on disk, otherwise the gate above would immediately re-open.
        for filename in ("Tiny Woods.ogg", "Thunderwave Cave.ogg"):
            path = REPO / "Content/Music" / filename
            self.assertTrue(path.is_file(), f"missing canonical asset: {path}")
            self.assertGreater(path.stat().st_size, 100_000, filename)


class TestRedCanonicalManifest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))

    def test_sinister_floor_classification_comes_from_source(self):
        floor_count = self.manifest["floor_count"]
        self.assertEqual(floor_count, 13)
        self.assertEqual(floor_count, len(self.manifest["floors"]))
        self.assertEqual(self.manifest["procedural_floors"], list(range(1, 13)))
        self.assertEqual(self.manifest["fixed_floors"], [13])
        final = self.manifest["floors"][-1]
        self.assertEqual(final["floor_properties"]["fixedRoomNumber"], 2)
        self.assertEqual(final["floor_properties"]["tileset"], 65)

    def test_source_feature_chances_are_not_inferred_from_table_ids(self):
        procedural = self.manifest["floors"][:12]
        self.assertTrue(all(row["floor_properties"]["tileset"] == 41 for row in procedural))
        self.assertTrue(all(row["floor_properties"]["kecleonShopChance"] == 0
                            for row in procedural))
        self.assertTrue(all(row["floor_properties"]["monsterHouseChance"] == 0
                            for row in procedural))
        self.assertTrue(all(row["floor_properties"]["weather"] == 0
                            for row in procedural))

    def test_manifest_keeps_raw_species_and_probabilities(self):
        species = {
            entry["species"]
            for floor in self.manifest["floors"][:12]
            for entry in floor["pokemon"]
            if entry["probability"] > 0
        }
        self.assertIn("MONSTER_WOOPER", species)
        self.assertNotIn("MONSTER_BONSLY", species)


class TestSinisterNativeSmokeEvidence(unittest.TestCase):
    def test_candidate_places_content_and_rejects_no_topology(self):
        rows = [json.loads(line) for line in SINISTER_SMOKE_JSONL.read_text(encoding="utf-8").splitlines()]
        floors = [row for row in rows if row.get("event") == "floor"]
        self.assertEqual(len(floors), 42)
        self.assertTrue(all(row["valid"] for row in floors))
        self.assertTrue(all(row["items"] > 0 and row["mobs"] > 0 for row in floors))
        offsets = {0: 0, 1: 5, 2: 10}
        canonical = [row for row in floors
                     if offsets[row["segment"]] + row["floor"] + 1 <= 12]
        self.assertEqual(len(canonical), 36)
        self.assertTrue(all(row["effect_ids"] == "tile_wonder:3" for row in canonical))
        self.assertEqual({row["profile"] for row in floors},
                         {"branching", "looping", "large_rooms"})


class TestNativeEnginePrototypeEvidence(unittest.TestCase):
    def test_engine_prototype_passed_with_three_profiles(self):
        text = ENGINE_REPORT.read_text(encoding="utf-8")
        self.assertIn("- générations tentées : **48**", text)
        self.assertIn("- réussies : **48**", text)
        self.assertIn("**Verdict prototype : PASS**", text)
        for profile in ("branching", "looping", "large_rooms"):
            self.assertIn(f"`{profile}`", text)

    def test_each_native_floor_records_seed_and_topology(self):
        rows = [json.loads(line) for line in ENGINE_JSONL.read_text(encoding="utf-8").splitlines()]
        floors = [row for row in rows if row.get("event") == "floor"]
        self.assertEqual(len(floors), 48)
        self.assertEqual({row["profile"] for row in floors},
                         {"branching", "looping", "large_rooms"})
        self.assertTrue(all(row["seed"] and row["topology"] for row in floors))
        self.assertTrue(all(row["traversable"] and row["isolated"] == 0 for row in floors))
        self.assertTrue(all(row.get("valid", True) for row in floors))
        self.assertTrue(all(row["rooms"] >= 4 and row["halls"] >= 3 for row in floors))


class TestSinisterCanonicalRuntimeEvidence(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = [json.loads(line) for line in
                    SINISTER_RUNTIME_JSONL.read_text(encoding="utf-8").splitlines()]
        cls.floors = [row for row in cls.rows if row.get("event") == "floor"]

    def test_native_candidate_completed_130_generations(self):
        self.assertEqual([row for row in self.rows if row.get("event") == "end"], [{
            "event": "end",
            "attempted": 130,
            "generated": 130,
            "failures": 0,
            "non_traversable": 0,
            "invalid": 0,
        }])
        self.assertEqual(len(self.floors), 130)
        self.assertEqual(sum(row["segment"] < 2 for row in self.floors), 120)
        self.assertEqual(sum(row["segment"] == 2 for row in self.floors), 10)
        self.assertTrue(all(row["valid"] and row["traversable"]
                            and row["isolated"] == 0 for row in self.floors))
        self.assertEqual(len({row["seed"] for row in self.floors}), 130)

    def test_procedural_floors_place_canonical_content_and_vary(self):
        procedural = [row for row in self.floors if row["segment"] < 2]
        self.assertEqual({row["profile"] for row in procedural},
                         {"branching", "looping", "large_rooms"})
        self.assertTrue(all(6 <= row["items"] <= 8 for row in procedural))
        self.assertTrue(all(2 <= row["mobs"] <= 7 for row in procedural))
        self.assertTrue(all(row["effect_ids"] == "tile_wonder:3" for row in procedural))
        for key in sorted({(row["segment"], row["floor"]) for row in procedural}):
            samples = [row for row in procedural
                       if (row["segment"], row["floor"]) == key]
            self.assertEqual(len(samples), 10, key)
            self.assertEqual(len({row["topology"] for row in samples}), 10, key)

    def test_fixed_d04p02_loads_with_three_bosses(self):
        fixed = [row for row in self.floors if row["segment"] == 2]
        self.assertEqual(len(fixed), 10)
        self.assertTrue(all(row["generator"] == "LoadGen" for row in fixed))
        self.assertTrue(all(row["mobs"] == 3 for row in fixed))


class TestSinisterActiveRouteEvidence(unittest.TestCase):
    def test_active_pmdo_route_covers_every_floor_ground_and_exit(self):
        rows = [json.loads(line) for line in ROUTE_JSONL.read_text(encoding="utf-8").splitlines()]
        maps = [(row["segment"], row["floor"]) for row in rows if row.get("event") == "map"]
        procedural = ([(0, floor) for floor in range(6)]
                      + [(1, floor) for floor in range(6)])
        self.assertEqual(maps, procedural + [(2, 0)])
        self.assertEqual([(row["segment"], row["floor"]) for row in rows
                          if row.get("event") == "stairs_located"], procedural)
        self.assertEqual([row["id"] for row in rows if row.get("event") == "ground"], [
            "bois_sombres_oree", "gloomy_forest_midpoint",
            "sinister_woods_clearing", "metano_town",
        ])
        map_rows = [row for row in rows if row.get("event") == "map"]
        self.assertTrue(all(row["map_seed"] and row["adventure_seed"] for row in map_rows))
        boss = next(row for row in rows if row.get("event") == "boss_outcome")
        self.assertEqual((boss["mobs"], boss["native_clear_hooks"]), (3, 1))
        self.assertEqual([row for row in rows if row.get("event") == "fatal"], [])
        self.assertEqual(rows[-1], {"event": "end", "mission_complete": True})

    def test_active_zone_native_map_generation_is_130_of_130_valid(self):
        rows = [json.loads(line) for line in
                ACTIVE_RUNTIME_JSONL.read_text(encoding="utf-8").splitlines()]
        floors = [row for row in rows if row.get("event") == "floor"]
        self.assertEqual(len(floors), 130)
        self.assertEqual([row for row in rows if row.get("event") == "end"], [{
            "event": "end", "attempted": 130, "generated": 130,
            "failures": 0, "non_traversable": 0, "invalid": 0,
        }])
        self.assertTrue(all(row["valid"] and row["traversable"]
                            and row["isolated"] == 0 for row in floors))

    def test_route_report_is_bound_to_the_promoted_zone(self):
        report = json.loads(ROUTE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["result"], "ACTIVE_ROUTE_HARNESS_PASS")
        self.assertTrue(report["production_zone_promoted"])
        zone_sha = hashlib.sha256((REPO / "Data/Zone/gloomy_forest.json").read_bytes()).hexdigest()
        event_sha = hashlib.sha256(ROUTE_JSONL.read_bytes()).hexdigest()
        self.assertEqual(report["artifacts"]["active_zone"]["sha256"], zone_sha)
        self.assertEqual(report["artifacts"]["events"]["sha256"], event_sha)
        self.assertIn("does not replay player combat inputs", report["strict_limitation"])


class TestSinisterCanonicalSceneAndBattle(unittest.TestCase):
    @staticmethod
    def _sha256(path: Path) -> str:
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def test_scene_registry_resolves_every_sinister_asset(self):
        from dungeon_builder.canonical_registry import check
        result = check("sinister_woods")
        self.assertTrue(result.ok, result.errors)
        self.assertEqual(result.entry["dungeon_id"], "gloomy_forest")
        self.assertEqual(result.entry["source"]["kind"], "PMD_RED_ROM")
        self.assertEqual(result.entry["status"], "ACTIVE_ROUTE_RUNTIME_VERIFIED")
        self.assertEqual(result.entry["runtime_evidence"],
                         "docs/dungeon_builder/SINISTER_ROUTE_RUNTIME_PASS.json")
        self.assertEqual(result.entry["final"]["battle_map_kind"],
                         "exact_canonical_ground_counterpart")

    def test_promoted_map_is_the_hash_bound_pixel_exact_stage(self):
        report = json.loads(FINAL_STAGE_REPORT.read_text(encoding="utf-8"))
        self.assertEqual(report["result"], "PIXEL_EXACT_STAGE_PASS")
        self.assertEqual(report["ground_render_size"], [480, 376])
        self.assertEqual(report["map_render_size"], [480, 384])
        self.assertEqual(report["different_pixels"], 0)
        self.assertEqual(report["extra_bottom_nonblack"], 0)
        self.assertEqual(self._sha256(FINAL_GROUND), report["ground_sha256"])
        self.assertEqual(self._sha256(FINAL_MAP), report["map_sha256"])
        self.assertEqual(self._sha256(FINAL_TILE), report["tile_sha256"])

    def test_boss_species_and_levels_are_the_rom_encounter(self):
        obj = json.loads(FINAL_MAP.read_text(encoding="utf-8-sig"))["Object"]
        bosses = [(player["CurrentForm"]["Species"], player["Level"])
                  for team in obj["MapTeams"] for player in team["Players"]]
        self.assertEqual(bosses, [("gengar", 15), ("medicham", 12), ("ekans", 15)])
        width, height = len(obj["Tiles"]), len(obj["Tiles"][0])
        self.assertEqual((width, height), (20, 16))
        self.assertEqual((len(obj["DiscoveryArray"]), len(obj["DiscoveryArray"][0])),
                         (width, height))
        starts = obj["MapEffect"]["OnMapStarts"]
        self.assertTrue(any(entry["Value"].get("Script") == "LuaBeginBattleEvent"
                            for entry in starts))
        self.assertIn("Boss species and source levels: PMD_RED_ROM", obj["Comment"])
        self.assertIn("Moves/HP are INFERRED", obj["Comment"])


class TestSmartDungeonRemoval(unittest.TestCase):
    def test_legacy_implementation_and_live_imports_are_absent(self):
        self.assertFalse((REPO / "tools" / "smart_dungeon").exists())
        self.assertFalse((REPO / "tools" / "smart_dungeon.py").exists())
        import_re = re.compile(
            r"^\s*(?:from|import)\s+(?:tools\.)?smart_dungeon(?:\b|\.)", re.MULTILINE)
        offenders = []
        for path in REPO.rglob("*.py"):
            text = path.read_text(encoding="utf-8", errors="ignore")
            if import_re.search(text):
                offenders.append(str(path.relative_to(REPO)))
        self.assertEqual(offenders, [])


if __name__ == "__main__":
    unittest.main(verbosity=2)
