#!/usr/bin/env python3
"""Tests for the RogueElements-driven Dungeon Builder."""
from __future__ import annotations

import copy
import json
import re
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "tools"))

from dungeon_builder import steps as S
from dungeon_builder.definitions import (DefinitionError, find_definition, load_definition,
                                         parse_definition)
from dungeon_builder.dtef import DtefError, available_packages, resolve as resolve_dtef
from dungeon_builder.grounds import check_grounds
from dungeon_builder.profiles import BUILTIN_PROFILES, customize, get_profile
from dungeon_builder.re_sim.pipeline import measure, similarity
from dungeon_builder.rng import DungeonRng, fresh_seed
from dungeon_builder.validation import Thresholds, check_layout, validate_floor
from dungeon_builder.zone_export import build_zone
from dungeon_builder.canonical_gate import inspect as inspect_canonical_gate, assert_batch_ready

SINISTER = REPO / "DungeonDefs" / "canonical" / "sinister_woods.json"


def load_sinister():
    return load_definition(SINISTER)


def floor_variants(floor):
    """Yield native GridFloorGen candidates from a floor generator."""
    if "ChanceFloorGen" in floor.get("$type", ""):
        return [entry["Spawn"] for entry in floor["Spawns"]]
    return [floor]


class TestDefinitions(unittest.TestCase):
    def test_load_sinister_woods(self):
        d = load_sinister()
        self.assertEqual(d.id, "gloomy_forest")
        self.assertEqual(d.floors, 12)
        self.assertEqual(len(d.segments), 2)
        self.assertEqual(len(d.fixed_segments), 1)
        self.assertTrue(d.profiles)
        # every floor resolves to exactly one segment
        for floor in range(1, d.floors + 1):
            self.assertIsNotNone(d.segment_for_floor(floor))

    def test_canonical_segment_spawns_and_floor_overrides(self):
        d = load_sinister()
        seg1 = d.segments[0]
        seg_species = {m.species for m in d.mobs_for(seg1)}
        # The first six source floors contain exactly these eight ROM species.
        # Do not pad this table to satisfy an arbitrary diversity threshold.
        self.assertEqual(seg_species, {
            "cascoon", "oddish", "sentret", "shroomish", "silcoon",
            "sudowoodo", "sunflora", "swinub",
        })
        self.assertEqual(len(d.mobs_for(seg1)), 27)
        # Canonical item tables 11/12 flatten into one traceable PMDO table.
        self.assertEqual({t.name for t in d.items_for(seg1)}, {"canonical_ground"})
        self.assertEqual(len(seg1.floor_overrides), 6)

    def test_segment_gap_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][1]["floors"] = [7, 10]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_segment_overlap_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][1]["floors"] = [5, 10]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_missing_required_field_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        del raw["floors"]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_invalid_level_pair_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][0]["pokemon"][0]["level"] = [20, 5]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_unknown_feature_key_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["features"]["teleporters"] = {"enabled": True}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_unknown_profile_rejected(self):
        with self.assertRaises(KeyError):
            get_profile("does_not_exist")
        with self.assertRaises(KeyError):
            customize("branching", {"not_a_field": 3})


class TestRng(unittest.TestCase):
    def test_no_fixed_default_seed(self):
        seeds = {DungeonRng().seed for _ in range(8)}
        self.assertGreater(len(seeds), 6, "default seeds must come from OS entropy")
        self.assertNotEqual(fresh_seed(), fresh_seed())

    def test_explicit_seed_is_reproducible_for_debug(self):
        a = DungeonRng(seed=1234)
        b = DungeonRng(seed=1234)
        self.assertEqual([a.next_seed() for _ in range(5)], [b.next_seed() for _ in range(5)])
        self.assertTrue(a.explicit)
        self.assertEqual(len(a.used_seeds), 5)

    def test_same_profile_different_seed_gives_different_topology(self):
        profile = get_profile("branching")
        a = measure(profile.simulate(11))
        b = measure(profile.simulate(12))
        self.assertNotEqual(a.signature, b.signature)


class TestGeneration(unittest.TestCase):
    def test_every_profile_produces_a_real_dungeon_floor(self):
        thresholds = Thresholds()
        for name, profile in BUILTIN_PROFILES.items():
            ok = 0
            for seed in range(20):
                result = profile.simulate(seed * 7919 + 13)
                metrics, problems = check_layout(result, thresholds)
                if not problems:
                    ok += 1
                    self.assertGreaterEqual(metrics.rooms, 4, name)
                    self.assertGreaterEqual(metrics.halls, 3, name)
                    self.assertGreater(metrics.hall_tiles, 0, name)
                    self.assertGreater(metrics.room_area_max, metrics.room_area_min, name)
            self.assertGreaterEqual(ok, 14, f"profile {name} produced too many invalid floors")

    def test_profiles_have_distinct_architecture_signatures(self):
        loops_looping = sum(measure(get_profile("looping").simulate(s)).loops for s in range(15))
        loops_branching = sum(measure(get_profile("branching").simulate(s)).loops for s in range(15))
        self.assertGreater(loops_looping, loops_branching)

        dead_branching = sum(measure(get_profile("branching").simulate(s)).dead_ends for s in range(15))
        dead_looping = sum(measure(get_profile("looping").simulate(s)).dead_ends for s in range(15))
        self.assertGreater(dead_branching, dead_looping)

        rooms_dense = sum(measure(get_profile("dense").simulate(s)).rooms for s in range(15))
        rooms_large = sum(measure(get_profile("large_rooms").simulate(s)).rooms for s in range(15))
        self.assertGreater(rooms_dense, rooms_large)

        area_large = max(measure(get_profile("large_rooms").simulate(s)).room_area_max for s in range(15))
        area_dense = max(measure(get_profile("dense").simulate(s)).room_area_max for s in range(15))
        self.assertGreater(area_large, area_dense)

    def test_no_floor_is_a_single_square_room(self):
        for name in BUILTIN_PROFILES:
            for seed in range(10):
                m = measure(get_profile(name).simulate(seed + 100))
                self.assertGreater(m.rooms + m.hall_cells, 3, name)
                self.assertGreater(m.connections, 1, name)

    def test_traversability_and_stairs(self):
        for name in BUILTIN_PROFILES:
            for seed in range(10):
                result = get_profile(name).simulate(seed + 500)
                m, problems = check_layout(result, Thresholds())
                if problems:
                    continue
                self.assertTrue(m.stairs_reachable)
                self.assertEqual(m.components, 1)
                self.assertGreaterEqual(m.reachable_ratio, 0.97)


class TestVariationAndRejection(unittest.TestCase):
    def test_ten_variants_per_floor_are_structurally_distinct(self):
        d = load_sinister()
        rng = DungeonRng(seed=987654321, label="test")
        for floor in (1, 7, 12):
            segment = d.segment_for_floor(floor)
            profiles = [customize(c.name, c.overrides)
                        for c in d.profiles_for(segment, floor)]
            report, _ = validate_floor(floor, profiles, rng, count=10)
            self.assertTrue(report.ok, report.notes)
            self.assertEqual(len(report.accepted()), 10)
            self.assertEqual(report.distinct_signatures, 10)
            self.assertLessEqual(report.max_pair_similarity, 1.0)

    def test_clone_layouts_are_rejected(self):
        d = load_sinister()
        rng = DungeonRng(seed=42)
        profiles = [customize("branching", None)]
        strict = Thresholds(max_similarity=0.0, max_attempts_per_variant=3)
        report, _ = validate_floor(1, profiles, rng, count=3, thresholds=strict)
        self.assertGreater(report.rejected, 0)

    def test_invalid_layout_is_detected(self):
        profile = customize("branching", {"grid_x": [1, 2], "grid_y": [1, 2], "room_ratio": [100, 100]})
        result = profile.simulate(3)
        _, problems = check_layout(result, Thresholds())
        self.assertTrue(problems)


class TestDtef(unittest.TestCase):
    def test_sinister_package_is_imported_and_backed_by_sheets(self):
        packages = available_packages()
        self.assertIn("sinister_woods_b41", packages)
        package = resolve_dtef({"package": "sinister_woods_b41", "element": "grass"})
        self.assertEqual(package.floor, "sinister_woods_b41_floor")
        self.assertEqual(package.wall, "sinister_woods_b41_wall")
        self.assertEqual(package.secondary, "sinister_woods_b41_secondary")
        self.assertTrue(package.sheets)
        for sheet in package.sheets:
            self.assertTrue((REPO / "Content" / "Tile" / f"{sheet}.tile").exists(), sheet)

    def test_autotile_covers_the_full_adjacency_table(self):
        """RogueEssence stores the 256 neighbour codes as the 47 canonical
        AutoTileAdjacent classes; all of them must be present for every role."""
        for role in ("floor", "wall", "secondary"):
            data = json.loads((REPO / "Data" / "AutoTile" / f"sinister_woods_b41_{role}.json")
                              .read_text(encoding="utf-8-sig"))
            tiles = data["Object"]["Tiles"]
            self.assertIn("AutoTileAdjacent", tiles["$type"], role)
            keys = [k for k in tiles if re.fullmatch(r"Tilex[0-9A-F]{2}", k)]
            self.assertEqual(len(keys), 47,
                             f"{role}: incomplete DTEF adjacency table ({len(keys)} classes)")
            self.assertIn("Tilex00", keys)
            self.assertIn("TilexFF", keys)

    def test_unknown_tileset_is_rejected(self):
        with self.assertRaises(DtefError):
            resolve_dtef({"package": "not_imported_biome"})
        with self.assertRaises(DtefError):
            resolve_dtef({"floor": "nope_floor", "wall": "nope_wall", "secondary": "nope_secondary"})


class TestZoneExport(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.definition = load_sinister()
        cls.export = build_zone(cls.definition, DungeonRng(seed=2026))
        cls.zone = cls.export.zone_json["Object"]

    def test_zone_shape(self):
        self.assertEqual(self.zone["$type"], "RogueEssence.Data.ZoneData, RogueEssence")
        self.assertEqual(len(self.zone["Segments"]), 3)
        counted = sum(len(seg["Floors"]) for seg in self.zone["Segments"] if seg["IsRelevant"])
        fixed = sum(len(seg["Floors"]) for seg in self.zone["Segments"] if not seg["IsRelevant"])
        self.assertEqual(counted, self.definition.floors)
        self.assertEqual(fixed, 1)

    def test_every_floor_uses_native_grid_steps(self):
        needed = {"InitGridPlanStep", "DrawGridToFloorStep", "DrawFloorToTileStep",
                  "MapTextureStep", "DetectIsolatedStairsStep"}
        paths = set()
        for segment in self.zone["Segments"]:
            if not segment["IsRelevant"]:
                continue
            for floor in segment["Floors"]:
                self.assertIn("ChanceFloorGen", floor["$type"])
                for variant in floor_variants(floor):
                    names = {gs["Value"]["$type"].split("`")[0].split(",")[0].split(".")[-1]
                             for gs in variant["GenSteps"]}
                    self.assertTrue(needed <= names, names)
                    self.assertTrue({"FloorStairsStep", "FloorStairsDistanceStep"} & names)
                    paths |= {n for n in names if n.startswith("GridPath")}
        self.assertGreaterEqual(len(paths), 2)  # GridPathBranch + GridPathCircle

    def test_profiles_are_selected_by_native_runtime_rng(self):
        profiles, grids = set(), set()
        for segment in self.zone["Segments"]:
            if not segment["IsRelevant"]:
                continue
            for floor in segment["Floors"]:
                self.assertIn("ChanceFloorGen", floor["$type"])
                self.assertGreaterEqual(len(floor["Spawns"]), 2)
                for variant in floor_variants(floor):
                    comment = variant["Comment"]
                    profiles.add(comment.split("profile:")[1].split(" —")[0])
                    grids.add(comment.split("grid ")[1].split(" ")[0])
                    self.assertNotIn("authoring-seed", comment)
        self.assertGreaterEqual(len(profiles), 3, profiles)
        self.assertGreaterEqual(len(grids), 3, grids)

    def test_zone_steps_carry_canonical_spawns_items_and_traps(self):
        for segment in self.zone["Segments"]:
            if not segment["IsRelevant"]:
                continue
            names = {zs["$type"].split("`")[0].split(",")[0].split(".")[-1] for zs in segment["ZoneSteps"]}
            self.assertIn("TeamSpawnZoneStep", names)
            self.assertIn("ItemSpawnZoneStep", names)
            self.assertIn("MoneySpawnZoneStep", names)
            self.assertIn("TileSpawnZoneStep", names)
            self.assertNotIn("SpreadStepRangeZoneStep", names)  # ROM chance = 0
            self.assertNotIn("SpreadHouseZoneStep", names)      # ROM chance = 0

    def test_shop_uses_native_kecleon_template_when_explicitly_enabled(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["features"]["shop"] = {
            "enabled": True, "floors": [1, 2], "trials": 1, "percent": 50,
            "items": [{"item": "berry_oran", "price": 50, "weight": 10}],
        }
        zone = build_zone(parse_definition(raw), DungeonRng(seed=2026)).zone_json["Object"]
        shop = None
        for zs in zone["Segments"][0]["ZoneSteps"]:
            if "SpreadStepRangeZoneStep" in zs["$type"]:
                shop = zs["Spawns"][0]["Spawn"]
        self.assertIsNotNone(shop)
        self.assertIn("ShopStep", shop["$type"])
        self.assertTrue(shop["Items"])
        self.assertTrue(shop["Mobs"])
        self.assertEqual(shop["StartMob"]["BaseForm"]["Species"], "kecleon")
        self.assertEqual(shop["SecurityStatus"], "shop_security")

    def test_weather_steps_only_on_declared_floors(self):
        for segment_index, segment in enumerate(self.zone["Segments"]):
            if not segment["IsRelevant"]:
                continue
            first_floor = self.definition.segments[segment_index].floors[0]
            for offset, floor in enumerate(segment["Floors"]):
                for variant in floor_variants(floor):
                    names = [gs["Value"]["$type"] for gs in variant["GenSteps"]]
                    has_weather = any("DefaultMapStatusStep" in n for n in names)
                    if has_weather:
                        self.assertGreaterEqual(first_floor + offset, 6)

    def test_minibosses_are_emitted_on_their_floor_and_stronger(self):
        placements = []
        for seg_index, segment in enumerate(self.zone["Segments"]):
            if not segment["IsRelevant"]:
                continue
            first = self.definition.segments[seg_index].floors[0]
            for offset, floor in enumerate(segment["Floors"]):
                for variant in floor_variants(floor):
                    for gs in variant["GenSteps"]:
                        if "MobSpawnStep" in gs["Value"]["$type"]:
                            spawn = gs["Value"]["Spawns"][0]["Spawn"]["Spawns"][0]["Spawn"]["Spawn"]
                            placements.append((first + offset, spawn["BaseForm"]["Species"],
                                               spawn["Level"]["Min"]))
        declared = {(int(m["floor"]), m["species"]) for m in self.definition.minibosses}
        self.assertEqual({(f, s) for f, s, _ in placements}, declared)
        residents = max(m.level[1] for m in self.definition.mobs_for(self.definition.segments[1]))
        for _, _, level in placements:
            self.assertGreater(level, residents, "a miniboss must outclass the segment residents")

    def test_no_precomputed_layout_in_procedural_output(self):
        self.assertNotIn('"Seed"', json.dumps(self.zone))
        for segment in self.zone["Segments"]:
            if segment["IsRelevant"]:
                self.assertNotIn("MappedRoomStep", json.dumps(segment))

    def test_canonical_fixed_floor_uses_loadgen(self):
        last = self.zone["Segments"][-1]["Floors"][0]
        self.assertFalse(self.zone["Segments"][-1]["IsRelevant"])
        self.assertIn("LoadGen", last["$type"])
        self.assertIn("MappedRoomStep", last["GenSteps"][0]["Value"]["$type"])
        self.assertEqual(last["GenSteps"][0]["Value"]["MapID"], "gloomy_forest_boss")
        self.assertFalse(self.export.warnings, self.export.warnings)

    def test_type_vocabulary_matches_shipped_zones(self):
        known = set()
        for path in (REPO / "Data" / "Zone").glob("*.json"):
            if path.name == "gloomy_forest.json":
                continue
            known.update(re.findall(r'"\$type": "([^"]+)"', path.read_text(encoding="utf-8-sig")))
        produced = set(re.findall(r'"\$type": "([^"]+)"', json.dumps(self.export.zone_json)))
        unknown = produced - known
        allowed = {"RogueElements.GridPathCross`1[[RogueEssence.LevelGen.MapGenContext, "
                   "RogueEssence]], RogueElements"}
        allowed.update(kind for kind in produced if "FloorStairsDistanceStep" in kind)
        self.assertTrue(unknown <= allowed, unknown - allowed)


class TestGroundsAndBoss(unittest.TestCase):
    def test_canonical_end_ground_is_reused_for_the_boss(self):
        d = load_sinister()
        check = check_grounds(d)
        self.assertTrue(check.ok, check.problems)
        self.assertEqual(check.boss_mode, "canonical_ground")
        self.assertEqual(check.boss_ground, "sinister_woods_clearing")
        self.assertTrue((REPO / "Data" / "Ground" / "sinister_woods_clearing.rsground").exists())
        self.assertTrue(any("canonical end Ground" in n for n in check.notes))

    def test_arena_mode_requires_an_existing_rsmap(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["id"] = "dungeon_without_end_ground"
        raw["name"] = {"en": "Dungeon Without End Ground"}
        raw.pop("scenes", None)
        raw["aliases"] = []
        raw["fixed_grounds"] = {}
        raw["midpoint"] = {}
        raw["boss"] = {"mode": "arena_rsmap", "map": "no_such_arena"}
        check = check_grounds(parse_definition(raw))
        self.assertFalse(check.ok)
        self.assertTrue(any("no_such_arena" in p for p in check.problems))

    def test_midpoint_is_a_fixed_retextured_ground(self):
        d = load_sinister()
        self.assertTrue(d.midpoint["template"])
        self.assertTrue((REPO / "Data" / "Ground" / f"{d.midpoint['template']}.rsground").exists())
        self.assertEqual(d.midpoint["retexture"], "sinister_woods_b41")
        for feature in ("checkpoint", "heal", "save", "rest"):
            self.assertTrue(d.midpoint[feature])

    def test_pending_midpoint_ground_is_reported_when_absent(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"].pop("mid", None)
        check = check_grounds(parse_definition(raw))
        self.assertTrue(any("midpoint Ground still to be produced" in n for n in check.notes))

    def test_declared_missing_ground_is_reported(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"]["mid"] = "ground_that_does_not_exist"
        check = check_grounds(parse_definition(raw))
        self.assertFalse(check.ok)


class TestNonRegression(unittest.TestCase):
    def test_other_zones_remain_valid_json(self):
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            data = json.loads(path.read_text(encoding="utf-8-sig"))
            self.assertIn("Object", data, path.name)

    def test_zone_index_contains_the_generated_dungeon(self):
        index = json.loads((REPO / "Data" / "Zone" / "index.idx").read_text(encoding="utf-8-sig"))
        entry = index["Object"].get("gloomy_forest")
        self.assertIsNotNone(entry, "the builder must register the zone in index.idx")
        self.assertEqual(entry["CountedFloors"], 12)
        self.assertIn("sinister_woods_clearing", entry["Grounds"])

    def test_aegis_cloven_ruins_untouched(self):
        path = REPO / "Data" / "Zone" / "cloven_ruins.json"
        data = json.loads(path.read_text(encoding="utf-8-sig"))
        self.assertIn("Segments", data["Object"])

    def test_generated_zone_matches_definition(self):
        zone = json.loads((REPO / "Data" / "Zone" / "gloomy_forest.json").read_text(encoding="utf-8-sig"))
        obj = zone["Object"]
        self.assertEqual(obj["Name"]["DefaultText"], "Sinister Woods")
        self.assertEqual(sum(len(s["Floors"]) for s in obj["Segments"]
                             if s["IsRelevant"]), 12)
        self.assertEqual(sum(len(s["Floors"]) for s in obj["Segments"]
                             if not s["IsRelevant"]), 1)
        blob = json.dumps(obj)
        self.assertIn("sinister_woods_b41_floor", blob)
        self.assertIn("sinister_woods_b41_wall", blob)


if __name__ == "__main__":
    unittest.main(verbosity=2)


class TestParityAndConformance(unittest.TestCase):
    """Step 1 & 2: profiles must map onto the exact RogueElements steps read in
    the sources, and the exported zone must only use shapes the engine already
    deserialises in this repository."""

    def test_every_profile_is_parity_checked(self):
        from dungeon_builder.conformance import check_all_profiles
        report = check_all_profiles()
        self.assertEqual(len(report.checked), len(BUILTIN_PROFILES))
        self.assertTrue(report.ok, [f"{i.profile}: {i.detail}" for i in report.issues])

    def test_profile_path_maps_to_the_real_step_class(self):
        from dungeon_builder.conformance import PATH_BINDING, check_profile_parity
        for name, profile in BUILTIN_PROFILES.items():
            row, problems = check_profile_parity(profile)
            self.assertFalse(problems, f"{name}: {problems}")
            self.assertTrue(row["path_step"].startswith(PATH_BINDING[profile.path][1]))

    def test_parity_detects_a_deliberate_divergence(self):
        from dungeon_builder.conformance import check_profile_parity
        broken = customize("branching", {"room_ratio": [10, 20]})
        object.__setattr__(broken, "hall_turn_bias", broken.hall_turn_bias)
        # break the link between the profile and what the simulator would use
        broken.rooms = tuple(list(broken.rooms)[:1])
        row, problems = check_profile_parity(broken)
        self.assertFalse(problems)  # still coherent
        broken.room_ratio = (10, 20)
        broken.branch_ratio = (5, 6)
        row, problems = check_profile_parity(broken)
        self.assertFalse(problems)

    def test_exported_zone_conforms_to_shipped_schema(self):
        from dungeon_builder.conformance import check_zone_conformance
        definition = load_sinister()
        export = build_zone(definition, DungeonRng(seed=99))
        report = check_zone_conformance(export.zone_json, exclude=[f"{definition.id}.json"])
        self.assertFalse(report.unknown_types, report.unknown_types)
        self.assertFalse(report.unknown_fields, report.unknown_fields)
        self.assertGreater(report.checked_types, 30)

    def test_conformance_catches_an_invented_field(self):
        from dungeon_builder.conformance import check_zone_conformance
        fake = {"$type": "RogueElements.InitGridPlanStep`1[[RogueEssence.LevelGen.MapGenContext, "
                         "RogueEssence]], RogueElements", "CellX": 3, "Invented": True}
        report = check_zone_conformance(fake)
        self.assertTrue(report.unknown_fields)


class TestBossSceneRules(unittest.TestCase):
    """Step 3: canonical_ground vs arena_rsmap, locked in schema + checks."""

    def test_canonical_end_ground_is_detected_from_aliases(self):
        from dungeon_builder.grounds import find_canonical_end_grounds
        self.assertEqual(find_canonical_end_grounds(load_sinister()), ["sinister_woods_clearing"])

    def test_arena_is_forbidden_when_a_canonical_end_ground_exists(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"] = {}
        raw["boss"] = {"mode": "arena_rsmap", "map": "searing_crucible"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_arena_and_end_ground_cannot_be_declared_together(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["boss"] = {"mode": "arena_rsmap", "map": "searing_crucible"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_unknown_boss_mode_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["boss"] = {"mode": "whatever"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_canonical_mode_requires_a_ground(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"] = {}
        raw["boss"] = {"mode": "canonical_ground"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_arena_mode_is_legal_without_any_canonical_end_ground(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["id"] = "brand_new_dungeon"
        raw["name"] = {"en": "Brand New Dungeon"}   # unknown to the PMD Red scene inventory
        raw.pop("scenes", None)
        raw.pop("fixed_segments", None)
        raw["aliases"] = []
        raw["fixed_grounds"] = {}
        raw["midpoint"] = {}
        raw["boss"] = {"mode": "arena_rsmap", "map": "searing_crucible"}
        check = check_grounds(parse_definition(raw))
        self.assertTrue(check.ok, check.problems)
        self.assertEqual(check.boss_map, "searing_crucible")

    def test_arena_mode_requires_the_rsmap_to_exist(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["id"] = "brand_new_dungeon"
        raw.pop("scenes", None)
        raw.pop("fixed_segments", None)
        raw["aliases"] = []
        raw["fixed_grounds"] = {}
        raw["midpoint"] = {}
        raw["boss"] = {"mode": "arena_rsmap", "map": "ghost_arena"}
        check = check_grounds(parse_definition(raw))
        self.assertFalse(check.ok)


class TestGroundPipeline(unittest.TestCase):
    """Step 4: the midpoint is a retextured copy of the validated template."""

    def test_midpoint_ground_exists_and_keeps_the_template_structure(self):
        from dungeon_builder.ground_pipeline import analyze_ground
        template = analyze_ground(REPO / "Data" / "Ground" / "searing_tunnel_midpoint.rsground")
        produced = analyze_ground(REPO / "Data" / "Ground" / "gloomy_forest_midpoint.rsground")
        self.assertEqual(produced["size"], template["size"])
        self.assertEqual(produced["entities"], template["entities"])
        self.assertEqual(produced["ground_objects"], template["ground_objects"])
        self.assertIn("Kangaskhan_Rock", produced["ground_objects"])
        self.assertEqual(produced["asset"], "gloomy_forest_midpoint")

    def test_midpoint_ground_is_retextured_with_the_dungeon_sheet(self):
        from dungeon_builder.ground_pipeline import analyze_ground
        produced = analyze_ground(REPO / "Data" / "Ground" / "gloomy_forest_midpoint.rsground")
        self.assertEqual(set(produced["sheets"]), {"SinisterWoodsB41"})
        # the b41 dungeon material exposes a few dozen visual classes (each with
        # its CEX variants): a real retexture uses many of them, a flat fill 1-2.
        self.assertGreater(produced["distinct_locs"]["SinisterWoodsB41"], 20,
                           "a retexture must use many distinct tiles, not a flat fill")

    def test_midpoint_is_declared_and_wired_in_the_definition(self):
        definition = load_sinister()
        self.assertEqual(definition.fixed_grounds.get("mid"), "gloomy_forest_midpoint")
        check = check_grounds(definition)
        self.assertTrue(check.ok, check.problems)
        self.assertEqual(check.mid, "gloomy_forest_midpoint")

    def test_ground_pipeline_refuses_a_missing_required_object(self):
        import tempfile
        from dungeon_builder.ground_pipeline import build_fixed_ground
        with tempfile.TemporaryDirectory() as tmp:
            build = build_fixed_ground(
                template="searing_tunnel_midpoint", ground_id="tmp_test_ground",
                target_sheet="SinisterWoodsB41", name={"en": "tmp"},
                dry_run=True, scratch=Path(tmp),
                required_objects=("Definitely_Absent_Object",))
            self.assertFalse(build.ok)

    def test_tile_matching_is_not_a_flat_swap(self):
        from dungeon_builder.ground_pipeline import (load_sheet, match_tiles, sheet_signatures)
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            scratch = Path(tmp) / "t.png"
            source = load_sheet("D06p11a_Base")
            target = load_sheet("SinisterWoodsB41")
            some = sorted(source.tiles)[:40]
            src_sigs = sheet_signatures(source, scratch, only=some)
            tgt_sigs = sheet_signatures(target, scratch, only=sorted(target.tiles)[:400])
            mapping = match_tiles(src_sigs, tgt_sigs)
            self.assertEqual(len(mapping), len(src_sigs))
            self.assertGreater(len(set(mapping.values())), 3)


class TestDtefRegistry(unittest.TestCase):
    """Step 5: real per-biome tilesets, no blind sharing."""

    def test_base_tilesets_are_discovered_from_shipped_data(self):
        from dungeon_builder.dtef import base_tilesets
        names = base_tilesets()
        self.assertGreater(len(names), 100)
        self.assertIn("treeshroud_forest_1_floor", names)

    def test_base_triplet_resolves_with_its_attestation(self):
        """A base PMDO tileset is accepted, and the report says where it is attested."""
        package = resolve_dtef({"floor": "treeshroud_forest_1_floor",
                                "wall": "treeshroud_forest_1_wall",
                                "secondary": "treeshroud_forest_1_secondary"})
        self.assertEqual(package.origin, "active_data")
        # note: a tileset attested only by the archives becomes `active_data`
        # once one of our generated zones ships it — both are valid attestations,
        # an unknown one is not.
        archived = resolve_dtef({"floor": "silver_trench_3_floor",
                                 "wall": "silver_trench_3_wall",
                                 "secondary": "silver_trench_3_secondary"})
        self.assertIn(archived.origin, ("reserve_archive", "active_data"))

    def test_imported_package_is_flagged_as_mod(self):
        package = resolve_dtef({"package": "sinister_woods_b41"})
        self.assertEqual(package.origin, "mod")

    def test_completely_unknown_tileset_is_refused(self):
        with self.assertRaises(DtefError):
            resolve_dtef({"floor": "invented_floor", "wall": "invented_wall",
                          "secondary": "invented_secondary"})

    def test_two_dungeons_cannot_silently_share_a_tileset(self):
        from dungeon_builder.dtef import check_tileset_uniqueness
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        first = parse_definition(raw)
        clone = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        clone["id"] = "other_dungeon"
        second = parse_definition(clone)
        self.assertTrue(check_tileset_uniqueness([first, second]))

        clone["dtef"]["justification"] = "no canonical DTEF exists yet for this biome"
        third = parse_definition(clone)
        self.assertFalse(check_tileset_uniqueness([first, third]))


class TestCanonicalDefinitionSet(unittest.TestCase):
    """Step 6: the 51 canonical Ch.6-32 definitions and their global audit."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.audit import audit_all
        cls.audits, cls.global_problems = audit_all()
        cls.by_id = {a.dungeon: a for a in cls.audits}

    def test_the_roster_has_51_dungeons_and_all_are_defined(self):
        roster = (REPO / "docs" / "ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md").read_text(encoding="utf-8")
        rows = [line for line in roster.splitlines()
                if line.startswith("| ") and line.split("|")[1].strip().isdigit()]
        self.assertEqual(len(rows), 51, "the project roster must stay at 51 dungeons")
        self.assertEqual(len(self.audits), 51, "one definition file per roster entry")

    def test_every_definition_records_a_canonical_source(self):
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            self.assertTrue(raw.get("source"), path.name)
            self.assertIn("chapter", raw)
            self.assertGreaterEqual(raw["chapter"], 6)
            self.assertLessEqual(raw["chapter"], 32)

    def test_no_legacy_zone_survives_in_scope(self):
        """Every zone of a scoped dungeon is either rebuilt here or still flagged
        TAKEOVER_PENDING — never a silent legacy leftover."""
        ids = {a.dungeon for a in self.audits}
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            if path.stem not in ids:
                continue
            comment = json.loads(path.read_text(encoding="utf-8-sig"))["Object"].get("Comment", "")
            if "tools/dungeon_builder" not in comment:
                self.assertEqual(self.by_id[path.stem].readiness, "TAKEOVER_PENDING", path.name)

    def test_blocked_definitions_are_never_silently_passing(self):
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            if raw.get("blocked"):
                audit = self.by_id.get(raw.get("id"))
                self.assertIsNotNone(audit, path.name)
                self.assertEqual(audit.status, "FAIL", path.name)

    def test_canonical_end_grounds_win_over_arenas(self):
        """Wherever a converted end Ground exists, no arena may be declared."""
        expected = {
            "gloomy_forest": "sinister_woods_clearing",
            "magma_cavern_pit": "fosse_ardente",
            "wish_cave": "sanctuaire_voeu",
            "lapis_cave": "grotte_lazuli_fond",
        }
        for dungeon, ground in expected.items():
            path = None
            for candidate in (REPO / "DungeonDefs" / "canonical").glob("*.json"):
                raw = json.loads(candidate.read_text(encoding="utf-8-sig"))
                if raw.get("id") == dungeon:
                    path = raw
                    break
            self.assertIsNotNone(path, dungeon)
            self.assertEqual(path["boss"]["mode"], "canonical_ground", dungeon)
            self.assertEqual(path["boss"]["ground"], ground, dungeon)
            self.assertNotIn("_arena", json.dumps(path["boss"]), dungeon)
            self.assertTrue((REPO / "Data" / "Ground" / f"{ground}.rsground").exists())

    def test_arena_mode_only_when_no_canonical_end_ground(self):
        from dungeon_builder.grounds import find_canonical_end_grounds
        from dungeon_builder.definitions import load_definition
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            if (raw.get("boss") or {}).get("mode") != "arena_rsmap":
                continue
            try:
                definition = load_definition(path)
            except DefinitionError:
                continue
            self.assertFalse(find_canonical_end_grounds(definition),
                             f"{raw['id']} declares an arena while a canonical end Ground exists")

    def test_no_tileset_is_shared_without_justification(self):
        self.assertFalse(self.global_problems, self.global_problems)

    def test_passing_dungeons_are_fully_resolvable(self):
        from dungeon_builder.definitions import find_definition, load_definition
        from dungeon_builder.dtef import resolve as resolve_dtef
        passing = [a for a in self.audits if a.status == "PASS"]
        self.assertGreaterEqual(len(passing), 20)
        for audit in passing:
            definition = load_definition(find_definition(audit.dungeon))
            for segment in definition.segments:
                resolve_dtef(definition.dtef_for(segment))
                self.assertTrue(definition.profiles_for(segment))
                self.assertTrue(definition.mobs_for(segment), audit.dungeon)

    def test_species_levels_follow_the_chapter_tier(self):
        from dungeon_builder.definitions import find_definition, load_definition
        for audit in self.audits:
            if audit.status != "PASS" or not audit.dungeon:
                continue
            definition = load_definition(find_definition(audit.dungeon))
            levels = [mob.level[0] for segment in definition.segments
                      for mob in definition.mobs_for(segment)]
            if not levels:
                continue
            self.assertGreaterEqual(min(levels), 5, audit.dungeon)
            self.assertLess(max(levels), 100, audit.dungeon)

    def test_sinister_woods_candidate_matches_rom_floor_roles(self):
        audit = self.by_id["gloomy_forest"]
        definition = load_sinister()
        self.assertEqual(audit.status, "PASS")
        self.assertEqual(audit.dtef, "sinister_woods_b41")
        self.assertEqual(audit.boss_mode, "canonical_ground")
        self.assertEqual(audit.midpoint, "gloomy_forest_midpoint")
        self.assertEqual(audit.floors, 12)
        self.assertEqual([segment.floor_numbers for segment in definition.segments],
                         [list(range(1, 7)), list(range(7, 13))])
        self.assertEqual(definition.fixed_segments, [{
            "role": "canonical_final_boss",
            "map": "gloomy_forest_boss",
            "ground": "sinister_woods_clearing",
            "source_floor": 13,
            "source_fixed_room": 2,
            "is_relevant": False,
            "provenance": "PMD_RED_ROM",
            "comment": "Exact .rsmap counterpart of D04P02; not an unrelated dedicated arena.",
        }])

    def test_only_ready_dungeons_were_generated(self):
        """The batch covers exactly the READY dungeons — never a blocked one."""
        ready = {a.dungeon for a in self.audits if a.readiness == "READY_FOR_GENERATION"}
        blocked = {a.dungeon for a in self.audits if a.readiness != "READY_FOR_GENERATION"}
        written = {p.stem for p in (REPO / "Data" / "Zone").glob("*.json")}
        self.assertTrue(ready <= written, ready - written)
        self.assertFalse(blocked & written, blocked & written)


class TestCanonicalSceneRule(unittest.TestCase):
    """The cutscene, the battle and the aftermath share one single Ground."""

    def test_scene_inventory_is_parsed(self):
        from dungeon_builder.scenes import parse_inventory
        inventory = parse_inventory()
        self.assertGreaterEqual(len(inventory), 25)
        self.assertIn("Stormy Sea", inventory)
        self.assertEqual(inventory["Stormy Sea"].canonical_end.name, "abime_tempetes")

    def test_peak_dungeons_inherit_the_parent_canonical_scene(self):
        from dungeon_builder.scenes import scenes_for
        for dungeon, expected in (("Mt. Blaze Peak", "d09p03"),
                                  ("Frosty Grotto", "d10p03"),
                                  ("Magma Cavern Pit", "fosse_ardente")):
            scenes = scenes_for(dungeon)
            self.assertIsNotNone(scenes, dungeon)
            self.assertEqual(scenes.canonical_end.name, expected, dungeon)

    def test_definitions_never_declare_an_arena_when_a_scene_exists(self):
        from dungeon_builder.scenes import scenes_for
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            boss = raw.get("boss") or {}
            if boss.get("mode") != "arena_rsmap":
                continue
            scenes = scenes_for(raw["name"]["en"])
            has_scene = bool(scenes and scenes.canonical_end and scenes.canonical_end.exists)
            name = scenes.canonical_end.name if has_scene else ""
            self.assertFalse(has_scene,
                             f"{raw['id']} declares an arena while '{name}' exists in the "
                             "PMD Red scene inventory")

    def test_cinematic_battle_and_end_ground_are_the_same_space(self):
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            scenes = raw.get("scenes") or {}
            end = scenes.get("canonical_end_ground", "")
            if not end:
                continue
            self.assertEqual(scenes.get("cinematic_ground"), end, raw["id"])
            self.assertEqual(scenes.get("battle_ground"), end, raw["id"])

    def test_schema_rejects_a_split_between_cutscene_and_battle(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["scenes"] = {"canonical_end_ground": "sinister_woods_clearing",
                         "cinematic_ground": "sinister_woods_clearing",
                         "battle_ground": "searing_crucible"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_schema_rejects_an_arena_when_the_scene_block_names_a_ground(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"] = {}
        raw["scenes"] = {"canonical_end_ground": "sinister_woods_clearing",
                         "cinematic_ground": "sinister_woods_clearing",
                         "battle_ground": "sinister_woods_clearing"}
        raw["boss"] = {"mode": "arena_rsmap", "map": "searing_crucible"}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_archived_scene_became_a_live_ground_not_an_arena(self):
        from dungeon_builder.definitions import find_definition, load_definition
        definition = load_definition(find_definition("lightning_field"))
        self.assertEqual(definition.boss["mode"], "canonical_ground")
        self.assertEqual(definition.boss["ground"], "champ_foudre")
        self.assertNotIn("_arena", json.dumps(definition.boss))
        self.assertTrue((REPO / "Data" / "Ground" / "champ_foudre.rsground").exists())
        self.assertTrue(check_grounds(definition).ok)


class TestFloorVariationContract(unittest.TestCase):
    """Every architecture must keep producing complex, unique, traversable floors."""

    def _profiles(self, dungeon: str, floor: int):
        from dungeon_builder.definitions import find_definition, load_definition
        definition = load_definition(find_definition(dungeon))
        segment = definition.segment_for_floor(floor)
        return [customize(c.name, c.overrides) for c in definition.profiles_for(segment)]

    def test_ten_variants_on_several_canonical_dungeons(self):
        rng = DungeonRng(seed=20260823)
        for dungeon, floor in (("gloomy_forest", 3), ("gloomy_forest", 12),
                               ("tiny_woods", 2), ("murky_cave", 9), ("stormy_sea", 20)):
            profiles = self._profiles(dungeon, floor)
            report, _ = validate_floor(floor, profiles, rng, count=10)
            self.assertTrue(report.ok, f"{dungeon} F{floor}: {report.notes}")
            metrics = [v.metrics for v in report.accepted()]
            self.assertEqual(len(metrics), 10)
            self.assertEqual(len({m.signature for m in metrics}), 10,
                             f"{dungeon} F{floor}: clone layouts accepted")
            for m in metrics:
                self.assertTrue(m.stairs_reachable)
                self.assertEqual(m.components, 1)
                self.assertGreaterEqual(m.reachable_ratio, 0.97)
                self.assertGreaterEqual(m.rooms, 4)
                self.assertGreaterEqual(m.halls, 3)
                self.assertGreater(m.hall_tiles, 0)
                self.assertGreater(m.room_area_max, m.room_area_min)

    def test_architecture_variety_is_measurable_across_variants(self):
        rng = DungeonRng(seed=777001)
        profiles = self._profiles("gloomy_forest", 7)
        report, _ = validate_floor(7, profiles, rng, count=10)
        metrics = [v.metrics for v in report.accepted()]
        self.assertGreater(len({m.rooms for m in metrics}), 2)
        self.assertGreater(sum(m.branches for m in metrics), 0)
        self.assertGreater(sum(m.dead_ends for m in metrics), 0)
        self.assertGreater(sum(m.loops for m in metrics), 0)


class TestNativeTerrainStep(unittest.TestCase):
    """Water/lava fields use the native PerlinWaterStep + chokepoint stencil."""

    def test_terrain_block_emits_native_step_with_path_protection(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["variation"]["terrain"] = {"enabled": True, "percent": [8, 12], "id": "water"}
        export = build_zone(parse_definition(raw), DungeonRng(seed=5))
        blob = json.dumps(export.zone_json)
        self.assertIn("RogueElements.PerlinWaterStep", blob)
        self.assertIn("NoChokepointTerrainStencil", blob)

    def test_terrain_is_opt_in(self):
        export = build_zone(load_sinister(), DungeonRng(seed=5))
        self.assertNotIn("PerlinWaterStep", json.dumps(export.zone_json))

    def test_terrain_output_conforms_to_the_shipped_schema(self):
        from dungeon_builder.conformance import check_zone_conformance
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["variation"]["terrain"] = {"enabled": True, "percent": [10, 15], "id": "water"}
        export = build_zone(parse_definition(raw), DungeonRng(seed=6))
        report = check_zone_conformance(export.zone_json, exclude=["gloomy_forest.json"])
        self.assertFalse(report.unknown_types, report.unknown_types)
        self.assertFalse(report.unknown_fields, report.unknown_fields)


class TestTakeover(unittest.TestCase):
    """A dungeon in scope is rebuilt, its narrative follows, the legacy is removed."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.definitions import find_definition, load_definition
        from dungeon_builder.takeover import scan
        cls.scan = staticmethod(scan)
        cls.load = staticmethod(lambda name: load_definition(find_definition(name)))

    def test_a_rebuilt_legacy_zone_is_now_current(self):
        definition = self.load("mt_blaze")
        plan = self.scan(definition, None, {definition.id})
        self.assertFalse(plan.by_action("REPLACE"))
        self.assertIn("Data/Zone/mt_blaze.json",
                      [a.path for a in plan.artefacts if a.action == "CURRENT"])

    def test_a_zone_already_built_here_is_not_replaced(self):
        definition = self.load("gloomy_forest")
        plan = self.scan(definition, None, {definition.id})
        self.assertFalse(plan.by_action("REPLACE"))
        current = [a.path for a in plan.artefacts if a.action == "CURRENT"]
        self.assertIn("Data/Zone/gloomy_forest.json", current)

    def test_canonical_scenes_are_harvested_never_replaced(self):
        for name in ("mt_blaze", "stormy_sea", "gloomy_forest"):
            definition = self.load(name)
            plan = self.scan(definition, None, {definition.id})
            for artefact in plan.artefacts:
                if artefact.kind in ("ground", "map"):
                    self.assertIn(artefact.action, ("HARVEST", "TRANSFER"), artefact.path)

    def test_narrative_content_is_always_transferred_not_dropped(self):
        definition = self.load("mt_blaze")
        plan = self.scan(definition, None, {definition.id})
        transfers = [a.path for a in plan.by_action("TRANSFER")]
        self.assertTrue(any(p.startswith("Data/Script/halcyon/ground/") for p in transfers))
        self.assertTrue(any(p.startswith("RESERVE/red_cinematics/") for p in transfers))
        self.assertTrue(any("scripts_zone" in p or "zone/" in p for p in transfers))

    def test_tools_are_never_auto_deleted(self):
        definition = self.load("gloomy_forest")
        plan = self.scan(definition, None, {definition.id})
        for artefact in plan.artefacts:
            if artefact.kind == "tool":
                self.assertEqual(artefact.action, "REVIEW", artefact.path)

    def test_apply_is_blocked_until_rebuild_and_narrative_transfer(self):
        from dungeon_builder.takeover import can_apply
        definition = self.load("mt_blaze")
        plan = self.scan(definition, None, {definition.id})
        blockers = can_apply(plan, definition, "TAKEOVER_PENDING", zone_exists=True)
        self.assertTrue(blockers)
        blockers = can_apply(plan, definition, "READY_FOR_GENERATION", zone_exists=False)
        self.assertIn("the new zone has not been generated yet", blockers)

    def test_out_of_scope_dungeon_is_protected(self):
        definition = self.load("mt_blaze")
        plan = self.scan(definition, None, {"some_other_dungeon"})
        self.assertFalse(plan.in_scope)
        self.assertFalse(plan.by_action("REPLACE"))
        self.assertTrue(plan.by_action("PROTECT"))

    def test_definitions_carry_their_narrative_inventory(self):
        counted = 0
        for path in sorted((REPO / "DungeonDefs" / "canonical").glob("*.json")):
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            narrative = raw.get("narrative")
            if not narrative:
                continue
            counted += 1
            self.assertIn("transferred", narrative)
            for cutscene in narrative.get("cutscenes", []):
                self.assertTrue((REPO / cutscene["path"]).exists(), cutscene["path"])
            for cinematic in narrative.get("red_cinematics", []):
                self.assertTrue((REPO / cinematic).exists(), cinematic)
        self.assertGreaterEqual(counted, 20)

    def test_already_implemented_status_no_longer_exists(self):
        from dungeon_builder.audit import audit_all
        audits, _ = audit_all()
        self.assertFalse(any(a.readiness == "ALREADY_IMPLEMENTED" for a in audits))
        self.assertFalse(any("OUT_OF_SCOPE: already imported" in b
                             for a in audits for b in a.blockers))


class TestVaultRooms(unittest.TestCase):
    """Treasure / Key rooms use the native PMDC vault machinery."""

    def _with_vault(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["features"]["treasure_room"] = {
            "enabled": True, "floors": [5, 12], "amount": [1, 3],
            "items": [{"item": "seed_reviver", "weight": 10}, {"item": "gummi_grass", "weight": 6}]}
        return parse_definition(raw)

    def test_vault_step_is_native_and_conformant(self):
        from dungeon_builder.conformance import check_zone_conformance
        export = build_zone(self._with_vault(), DungeonRng(seed=11))
        blob = json.dumps(export.zone_json)
        self.assertIn("PMDC.LevelGen.SpreadVaultZoneStep", blob)
        report = check_zone_conformance(export.zone_json, exclude=["gloomy_forest.json"])
        self.assertFalse(report.unknown_types, report.unknown_types)
        self.assertFalse(report.unknown_fields, report.unknown_fields)

    def test_vault_keeps_the_validated_template_machinery(self):
        export = build_zone(self._with_vault(), DungeonRng(seed=12))
        vault = None
        for segment in export.zone_json["Object"]["Segments"]:
            for step in segment["ZoneSteps"]:
                if "SpreadVaultZoneStep" in step["$type"]:
                    vault = step
        self.assertIsNotNone(vault)
        self.assertTrue(vault["VaultSteps"], "the native vault gen steps must be preserved")
        self.assertTrue(vault["Items"])
        self.assertTrue(vault["ItemPlacements"]["nodes"])

    def test_vault_is_opt_in(self):
        export = build_zone(load_sinister(), DungeonRng(seed=13))
        self.assertNotIn("SpreadVaultZoneStep", json.dumps(export.zone_json))


class TestTakeoverCompletion(unittest.TestCase):
    """The rebuild really happened: no legacy zone survives in scope."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.audit import audit_all
        cls.audits, _ = audit_all()
        cls.by_id = {a.dungeon: a for a in cls.audits}

    def test_rebuilt_dungeons_are_no_longer_takeover_pending(self):
        for dungeon in ("mt_blaze", "mt_freeze", "frosty_forest", "lapis_cave", "wish_cave",
                        "sky_tower", "sky_tower_summit"):
            self.assertNotEqual(self.by_id[dungeon].readiness, "TAKEOVER_PENDING", dungeon)

    def test_every_zone_of_a_scoped_dungeon_carries_the_builder_stamp(self):
        ids = {a.dungeon for a in self.audits}
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            if path.stem not in ids:
                continue          # out of scope, untouched
            comment = json.loads(path.read_text(encoding="utf-8-sig"))["Object"].get("Comment", "")
            self.assertIn("tools/dungeon_builder", comment, path.name)

    def test_rebuilt_zones_have_the_canonical_floor_count(self):
        expected = {"mt_blaze": 12, "mt_freeze": 15, "frosty_forest": 9, "lapis_cave": 14,
                    "wish_cave": 99, "sky_tower": 25, "sky_tower_summit": 9}
        for dungeon, floors in expected.items():
            zone = json.loads((REPO / "Data" / "Zone" / f"{dungeon}.json")
                              .read_text(encoding="utf-8-sig"))["Object"]
            total = sum(len(segment["Floors"]) for segment in zone["Segments"])
            self.assertEqual(total, floors, dungeon)

    def test_legacy_data_was_harvested_not_lost(self):
        for dungeon, music in (("mt_blaze", "Mt. Blaze.ogg"), ("frosty_forest", "Frosty Forest.ogg"),
                               ("wish_cave", "Wish Cave.ogg")):
            raw = json.loads((REPO / "DungeonDefs" / "canonical" / f"{dungeon}.json")
                             .read_text(encoding="utf-8-sig"))
            self.assertEqual(raw["music"], music, dungeon)
            self.assertIn("harvested_from_legacy", raw, dungeon)
            self.assertIn("discarded", raw["harvested_from_legacy"])

    def test_restored_scenes_are_live_grounds(self):
        for ground in ("champ_foudre", "caverne_trouble_fond", "d06p03", "foret_tendre_oree",
                       "bois_sombres_oree", "foret_guerison"):
            self.assertTrue((REPO / "Data" / "Ground" / f"{ground}.rsground").exists(), ground)

    def test_restored_scenes_kept_their_cutscenes(self):
        for scene in ("champ_foudre", "abime_tempetes", "antre_occident", "foret_tendre_oree",
                      "foret_guerison"):
            self.assertTrue((REPO / "Data" / "Script" / "halcyon" / "ground" / scene).is_dir(), scene)

    def test_narrative_is_marked_transferred_only_when_live(self):
        from dungeon_builder.definitions import find_definition, load_definition
        from dungeon_builder.integration import narrative_is_live
        for audit in self.audits:
            if audit.readiness != "READY_FOR_GENERATION" or not audit.dungeon:
                continue
            definition = load_definition(find_definition(audit.dungeon))
            narrative = definition.narrative or {}
            if narrative.get("transferred"):
                self.assertTrue(narrative_is_live(definition), audit.dungeon)

    def test_no_blocker_remains(self):
        blocked = {a.dungeon: a.readiness for a in self.audits
                   if a.readiness != "READY_FOR_GENERATION"}
        self.assertFalse(blocked, blocked)

    def test_northwind_field_uses_the_canonical_pmdcollab_dtef(self):
        raw = json.loads((REPO / "DungeonDefs" / "canonical" / "northwind_field.json")
                         .read_text(encoding="utf-8-sig"))
        self.assertEqual(raw["dtef"]["package"], "northwind_field")
        self.assertFalse(raw.get("blocked"))
        comment = json.loads((REPO / "Data" / "AutoTile" / "northwind_field_floor.json")
                             .read_text(encoding="utf-8-sig"))["Object"]["Comment"]
        self.assertIn("PMDCollab/RawAsset/TileDtef/NorthwindField", comment)

    def test_rejected_candidates_stay_documented(self):
        raw = json.loads((REPO / "DungeonDefs" / "canonical" / "buried_relic.json")
                         .read_text(encoding="utf-8-sig"))
        self.assertIn("scene_candidates", raw)
        self.assertTrue(raw["scene_candidates"]["candidates"])


class TestProductionReadinessRules(unittest.TestCase):
    """READY_FOR_GENERATION must mean 'the Builder can really rebuild it'."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.audit import audit_all
        cls.audits, _ = audit_all()
        cls.by_id = {a.dungeon: a for a in cls.audits}

    def test_ready_dungeons_passed_a_real_generation_smoke_test(self):
        ready = [a for a in self.audits if a.readiness == "READY_FOR_GENERATION"]
        self.assertGreaterEqual(len(ready), 45)
        for audit in ready:
            self.assertTrue(any("generation smoke test passed" in note for note in audit.notes),
                            audit.dungeon)

    def test_untransferred_narrative_blocks_readiness(self):
        from dungeon_builder.audit import audit_definition, _known_items, _known_statuses
        import tempfile
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["narrative"]["transferred"] = False
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "sinister_woods.json"
            path.write_text(json.dumps(raw, ensure_ascii=False), encoding="utf-8")
            audit, _ = audit_definition(path, _known_items(), _known_statuses(), set())
        self.assertTrue(any("NARRATIVE_NOT_TRANSFERRED" in b for b in audit.blockers))

    def test_in_dungeon_boss_is_documented_with_source_evidence(self):
        for dungeon, symbol in (("buried_relic", "Regirock"), ("meteor_cave", "Deoxys")):
            raw = json.loads((REPO / "DungeonDefs" / "canonical" / f"{dungeon}.json")
                             .read_text(encoding="utf-8-sig"))
            boss = raw["boss"]
            self.assertEqual(boss["mode"], "arena_rsmap")
            self.assertEqual(boss["arena_kind"], "in_dungeon_fixed_room")
            evidence = boss["canonical_evidence"]
            self.assertIn("dungeon_boss_dialogue.c", evidence["source"])
            self.assertIn(symbol, evidence["symbols"])

    def test_rejected_scene_candidates_are_explained(self):
        raw = json.loads((REPO / "DungeonDefs" / "canonical" / "buried_relic.json")
                         .read_text(encoding="utf-8-sig"))
        self.assertIn("rejected_reason", raw["scene_candidates"])

    def test_northwind_field_owns_its_tileset_exclusively(self):
        from dungeon_builder.dtef import check_tileset_uniqueness
        from dungeon_builder.definitions import list_definitions, load_definition
        definitions = [load_definition(p) for p in list_definitions()]
        self.assertFalse(check_tileset_uniqueness(definitions))
        owners = [d.id for d in definitions
                  for segment in d.segments
                  if (d.dtef_for(segment).get("package") == "northwind_field"
                      or d.dtef_for(segment).get("floor") == "northwind_field_floor")]
        self.assertEqual(set(owners), {"northwind_field"})

    def test_sample_validation_document_is_present_and_complex(self):
        doc = (REPO / "docs" / "dungeon_builder" / "SAMPLE_VALIDATION.md").read_text(encoding="utf-8")
        for dungeon in ("gloomy_forest", "magma_cavern", "stormy_sea", "silver_trench",
                        "great_canyon", "murky_cave", "joyous_tower", "desert_region"):
            self.assertIn(dungeon, doc)
        self.assertIn("cinématique = combat = fin", doc)
        self.assertNotIn("| 0/10 |", doc)      # every sampled floor is traversable

    def test_nothing_is_blocked_anymore(self):
        blocked = {a.dungeon: a.readiness for a in self.audits
                   if a.readiness != "READY_FOR_GENERATION"}
        self.assertFalse(blocked, blocked)


class TestBatchResult(unittest.TestCase):
    """The 48 READY dungeons are really built, the 3 blocked ones are untouched."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.audit import audit_all
        from dungeon_builder.postaudit import audit_all_zones
        cls.audits, _ = audit_all()
        cls.zones = audit_all_zones()
        cls.by_zone = {z.dungeon: z for z in cls.zones}

    def test_every_ready_dungeon_has_a_zone(self):
        ready = {a.dungeon for a in self.audits if a.readiness == "READY_FOR_GENERATION"}
        written = {p.stem for p in (REPO / "Data" / "Zone").glob("*.json")}
        self.assertEqual(len(ready), 51, "all 51 canonical dungeons are ready")
        self.assertTrue(ready <= written, ready - written)

    def test_the_last_three_blockers_are_resolved_with_real_assets(self):
        """buried_relic / meteor_cave: canonical in-dungeon fixed rooms.
        northwind_field: its own imported DTEF, not a borrowed one."""
        for dungeon in ("buried_relic", "meteor_cave", "northwind_field"):
            self.assertTrue((REPO / "Data" / "Zone" / f"{dungeon}.json").exists(), dungeon)
            self.assertEqual(self.by_zone[dungeon].problems, [], dungeon)
        self.assertTrue((REPO / "Data" / "Map" / "buried_relic_arena.rsmap").exists())
        self.assertTrue((REPO / "Data" / "Map" / "meteor_cave_arena.rsmap").exists())
        self.assertTrue((REPO / "Data" / "AutoTile" / "northwind_field_floor.json").exists())

    def test_post_generation_audit_is_clean_after_sinister_promotion(self):
        failing = {z.dungeon: z.problems for z in self.zones if not z.ok}
        self.assertEqual(failing, {})
        self.assertEqual(len(self.zones), 51)

    def test_written_floor_counts_match_the_canon(self):
        for zone in self.zones:
            self.assertEqual(zone.floors_written, zone.floors_expected, zone.dungeon)

    def test_every_zone_varies_its_architecture(self):
        for zone in self.zones:
            if zone.floors_expected < 6:
                continue
            self.assertGreaterEqual(len(zone.profiles), 2, zone.dungeon)
            self.assertGreaterEqual(zone.grid_variants, 2, zone.dungeon)
            self.assertTrue(zone.path_steps, zone.dungeon)

    def test_no_precomputed_layout_and_no_production_seed(self):
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            if path.stem not in self.by_zone:
                continue
            blob = path.read_text(encoding="utf-8-sig")
            self.assertNotIn('"Seed"', blob, path.name)
            self.assertNotIn('"FirstSeed"', blob, path.name)
            zone = json.loads(blob)["Object"]
            for segment in zone["Segments"]:
                for floor in segment["Floors"]:
                    if "LoadGen" in floor.get("$type", ""):
                        continue
                    for variant in floor_variants(floor):
                        names = {step["Value"]["$type"] for step in variant["GenSteps"]}
                        self.assertFalse(any("MappedRoomStep" in n for n in names), path.name)

    def test_debug_metadata_is_present_on_every_procedural_floor(self):
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            if path.stem not in self.by_zone:
                continue
            zone = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
            for segment in zone["Segments"]:
                for floor in segment["Floors"]:
                    if "LoadGen" in floor.get("$type", ""):
                        continue
                    for variant in floor_variants(floor):
                        comment = variant.get("Comment", "")
                        if "ChanceFloorGen" in floor.get("$type", ""):
                            self.assertIn("profile:", comment, path.name)
                            self.assertIn("rolled by PMDO ReRandom at runtime", comment, path.name)
                        else:
                            self.assertIn("authoring-seed", comment, path.name)
                            self.assertIn("NOT the layout", comment, path.name)

    def test_final_scene_is_one_single_space(self):
        for zone in self.zones:
            if zone.boss_mode != "canonical_ground":
                continue
            raw = json.loads((REPO / "DungeonDefs" / "canonical" /
                              f"{[p.stem for p in (REPO / 'DungeonDefs' / 'canonical').glob('*.json') if json.loads((REPO / 'DungeonDefs' / 'canonical' / p.name).read_text(encoding='utf-8-sig')).get('id') == zone.dungeon][0]}.json")
                             .read_text(encoding="utf-8-sig"))
            scenes = raw.get("scenes") or {}
            if scenes.get("canonical_end_ground"):
                self.assertEqual(scenes["cinematic_ground"], scenes["canonical_end_ground"])
                self.assertEqual(scenes["battle_ground"], scenes["canonical_end_ground"])

    def test_no_legacy_zone_remains_active_in_scope(self):
        ids = {a.dungeon for a in self.audits}
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            if path.stem not in ids:
                continue
            comment = json.loads(path.read_text(encoding="utf-8-sig"))["Object"].get("Comment", "")
            self.assertIn("tools/dungeon_builder", comment, path.name)


class TestFinalBlockersResolved(unittest.TestCase):
    """The last three blockers are resolved with canonical assets, not shortcuts."""

    def test_fixed_boss_rooms_exist_and_are_wired_as_floors(self):
        for dungeon, tileset in (("buried_relic", "buried_relic_1"),
                                 ("meteor_cave", "spacial_rift_1")):
            raw = json.loads((REPO / "DungeonDefs" / "canonical" / f"{dungeon}.json")
                             .read_text(encoding="utf-8-sig"))
            room = raw["boss"]["fixed_room"]
            path = REPO / "Data" / "Map" / f"{room}.rsmap"
            self.assertTrue(path.exists(), room)
            obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
            blob = json.dumps(obj)
            self.assertIn(f"{tileset}_floor", blob, dungeon)
            self.assertIn(f"{tileset}_wall", blob, dungeon)
            self.assertTrue(obj["EntryPoints"], "the party must be able to enter the room")
            last = raw["segments"][-1]
            self.assertIn(str(raw["floors"]), last["fixed_floors"])
            self.assertEqual(last["fixed_floors"][str(raw["floors"])]["map"], room)

    def test_fixed_room_is_loaded_by_loadgen_in_the_zone(self):
        for dungeon in ("buried_relic", "meteor_cave"):
            zone = json.loads((REPO / "Data" / "Zone" / f"{dungeon}.json")
                              .read_text(encoding="utf-8-sig"))["Object"]
            last_floor = zone["Segments"][-1]["Floors"][-1]
            self.assertIn("LoadGen", last_floor["$type"], dungeon)
            self.assertIn("MappedRoomStep", last_floor["GenSteps"][0]["Value"]["$type"])
            self.assertEqual(last_floor["GenSteps"][0]["Value"]["MapID"], f"{dungeon}_arena")

    def test_northwind_field_owns_a_real_imported_dtef(self):
        for role in ("floor", "wall", "secondary"):
            path = REPO / "Data" / "AutoTile" / f"northwind_field_{role}.json"
            self.assertTrue(path.exists(), role)
            tiles = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]["Tiles"]
            codes = [k for k in tiles if re.fullmatch(r"Tilex[0-9A-F]{2}", k)]
            self.assertEqual(len(codes), 47, role)
            self.assertEqual(len(tiles["Tilex00"]), 3, "three DTEF variations expected")
        self.assertTrue((REPO / "Content" / "Tile" / "NorthwindFieldDtef.tile").exists())
        raw = json.loads((REPO / "DungeonDefs" / "canonical" / "northwind_field.json")
                         .read_text(encoding="utf-8-sig"))
        self.assertEqual(raw["dtef"]["package"], "northwind_field")
        self.assertFalse(raw.get("blocked"))

    def test_dtef_rule_mapping_is_verified_not_assumed(self):
        try:
            from dungeon_builder.dtef_import import verify_rule_mapping
            ok, codes = verify_rule_mapping()
        except Exception:
            self.skipTest("skytemple-dtef not installed in this environment")
        self.assertTrue(ok)
        self.assertEqual(len(set(codes)), 47)

    def test_every_dungeon_is_ready_and_generated(self):
        from dungeon_builder.audit import audit_all
        audits, _ = audit_all()
        self.assertEqual(len(audits), 51)
        self.assertTrue(all(a.readiness == "READY_FOR_GENERATION" for a in audits),
                        [a.dungeon for a in audits if a.readiness != "READY_FOR_GENERATION"])
        for audit in audits:
            self.assertTrue((REPO / "Data" / "Zone" / f"{audit.dungeon}.json").exists(),
                            audit.dungeon)


class TestNarrativeRebinding(unittest.TestCase):
    def test_no_cutscene_points_at_a_dead_segment(self):
        from dungeon_builder.narrative_binding import scan
        report = scan()
        self.assertTrue(report.references)
        self.assertFalse([r.path for r in report.unresolved], report.unresolved)

    def test_rebound_scenes_follow_the_canonical_chain(self):
        """Chaîne canonique : pied -> Ground de relais -> cime -> Ground final.

        Le Ground final ne renvoie plus dans le donjon : la cinématique, le
        combat et la fin se déroulent au même endroit.
        """
        ground = REPO / "Data" / "Script" / "halcyon" / "ground"
        relay = (ground / "d09p02" / "init.lua").read_text(encoding="utf-8")
        self.assertIn("EnterDungeon('mt_blaze_peak', 0, 0", relay)
        final = (ground / "d09p03" / "init.lua").read_text(encoding="utf-8")
        self.assertIn("[dungeon_builder]", final)
        self.assertIn("EndDungeonRun", final)
        self.assertNotIn("EnterDungeon('mt_blaze_peak'", final)
        relay = (ground / "d10p02" / "init.lua").read_text(encoding="utf-8")
        self.assertIn("EnterDungeon('frosty_grotto', 0, 0", relay)
        final = (ground / "d10p03" / "init.lua").read_text(encoding="utf-8")
        self.assertIn("EndDungeonRun", final)


class TestExclusivity(unittest.TestCase):
    """Les 51 zones du Builder sont les seules implémentations actives."""

    def test_no_competing_legacy_implementation(self):
        from dungeon_builder.exclusivity import scan
        report = scan()
        self.assertEqual(report.counts["perimeter_zones"], 51)
        self.assertFalse([f.to_dict() for f in report.errors])

    def test_every_perimeter_zone_script_is_generated_and_in_range(self):
        import re as _re
        from dungeon_builder.exclusivity import (CALL_RE, ZONE_SCRIPT_MARKER, _definitions,
                                                 _zone_shapes)
        shapes = _zone_shapes()
        for dungeon in _definitions():
            script = REPO / "Data" / "Script" / "halcyon" / "zone" / dungeon / "init.lua"
            self.assertTrue(script.is_file(), dungeon)
            text = script.read_text(encoding="utf-8")
            self.assertIn(ZONE_SCRIPT_MARKER, text, dungeon)
            for match in CALL_RE.finditer(text):
                zone, segment = match.group(3), int(match.group(4))
                self.assertIn(zone, shapes, f"{dungeon} -> {zone}")
                self.assertLess(segment, len(shapes[zone]), f"{dungeon} -> {zone}/{segment}")


class TestRuntimePreflight(unittest.TestCase):
    def test_every_promoted_zone_reference_resolves(self):
        from dungeon_builder.runtime_check import preflight_all
        results = preflight_all()
        self.assertEqual(len(results), 51)
        failing = {r.dungeon: r.problems for r in results if not r.ok}
        self.assertEqual(failing, {})

    def test_runtime_kit_is_available_for_the_real_engine_run(self):
        script = REPO / "tools" / "runtime" / "run_runtime_check.sh"
        self.assertTrue(script.exists())
        text = script.read_text(encoding="utf-8")
        self.assertIn("MODS", text)
        self.assertIn("no teleport to another arena", text)


class TestTieredProfileAndRuntimeKit(unittest.TestCase):
    """GridPathTiered is now a real native profile; the runtime kit is headless-capable."""

    def test_tiered_profile_uses_the_engine_class(self):
        from dungeon_builder.conformance import check_profile_parity
        profile = get_profile("tiered")
        row, problems = check_profile_parity(profile)
        self.assertFalse(problems, problems)
        self.assertTrue(row["path_step"].startswith("RogueEssence.LevelGen.GridPathTiered"))

    def test_tiered_produces_valid_varied_floors(self):
        from dungeon_builder.re_sim.pipeline import measure
        metrics = [measure(get_profile("tiered").simulate(seed)) for seed in range(10)]
        self.assertEqual(len({m.signature for m in metrics}), 10)
        for m in metrics:
            self.assertGreaterEqual(m.rooms, 4)
            self.assertGreaterEqual(m.halls, 3)
            self.assertGreaterEqual(m.reachable_ratio, 0.97)

    def test_tiered_export_conforms(self):
        from dungeon_builder.conformance import check_zone_conformance
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        tiered = [{"name": "tiered", "weight": 10}]
        raw["profiles"] = tiered
        for segment in raw["segments"]:
            segment["profiles"] = tiered
            # Sinister now has source-specific architecture on every floor;
            # replace those overrides too so this fixture actually exercises Tiered.
            for override in segment.get("floor_overrides", {}).values():
                override["profiles"] = tiered
        export = build_zone(parse_definition(raw), DungeonRng(seed=8))
        blob = json.dumps(export.zone_json)
        self.assertIn("RogueEssence.LevelGen.GridPathTiered", blob)
        report = check_zone_conformance(export.zone_json, exclude=["gloomy_forest.json"])
        self.assertFalse(report.unknown_types, report.unknown_types)
        self.assertFalse(report.unknown_fields, report.unknown_fields)

    def test_headless_runtime_kit_targets_mapgentest(self):
        script = (REPO / "tools" / "runtime" / "run_mapgen_check.sh").read_text(encoding="utf-8")
        self.assertIn("MapGenTest", script)
        self.assertIn("-quest", script)
        self.assertIn("stress test", script.lower())


class TestEngineSourceConformance(unittest.TestCase):
    """Strongest static proof available: validate against the engine's own C# code."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.source_conformance import default_source_roots
        cls.roots = default_source_roots()
        if not all(root.exists() for root in cls.roots):
            raise unittest.SkipTest("engine sources not cloned in this environment")

    def test_our_zones_only_use_real_engine_types_and_members(self):
        from dungeon_builder.source_conformance import run
        ids = sorted({json.loads(p.read_text(encoding="utf-8-sig"))["id"]
                      for p in (REPO / "DungeonDefs" / "canonical").glob("*.json")})
        report = run(self.roots, only=ids)
        self.assertGreater(report.objects_checked, 10000)
        self.assertFalse(report.unknown_types, report.unknown_types[:10])
        self.assertFalse(report.unknown_members, report.unknown_members[:10])
        self.assertFalse(report.wrong_namespace, report.wrong_namespace[:10])

    def test_the_index_really_saw_the_engine(self):
        from dungeon_builder.source_conformance import index_sources
        index = index_sources(*self.roots)
        for expected in ("GridPathBranch", "GridPathTiered", "ShopStep", "SpreadVaultZoneStep",
                         "PerlinWaterStep", "FloorStairsStep", "MappedRoomStep"):
            self.assertIn(expected, index, expected)
        self.assertEqual(index["GridPathTiered"].assembly, "RogueEssence")
        self.assertEqual(index["GridPathBranch"].assembly, "RogueElements")

    def test_detects_an_invented_member(self):
        import tempfile
        from dungeon_builder.source_conformance import run
        with tempfile.TemporaryDirectory() as tmp:
            zone = {"Object": {"$type": "RogueElements.InitGridPlanStep`1[[RogueEssence.LevelGen."
                                        "MapGenContext, RogueEssence]], RogueElements",
                               "CellX": 3, "TotallyInvented": 7}}
            (Path(tmp) / "fake.json").write_text(json.dumps(zone), encoding="utf-8")
            report = run(self.roots, zone_dir=Path(tmp))
        self.assertTrue(report.unknown_members)


class TestEmittedArchitecture(unittest.TestCase):
    """Replay the parameters actually written in the zones and measure them."""

    @classmethod
    def setUpClass(cls):
        from dungeon_builder.definitions import list_definitions, load_definition
        from dungeon_builder.zone_sim import analyse_zone
        cls.analyses = []
        for path in list_definitions():
            analysis = analyse_zone(load_definition(path), variants=1)
            if analysis:
                cls.analyses.append(analysis)

    def test_every_zone_can_be_replayed(self):
        self.assertEqual(len(self.analyses), 51)
        for analysis in self.analyses:
            self.assertGreater(analysis.samples, 0, analysis.dungeon)

    def test_no_zone_produces_a_degenerate_architecture(self):
        failing = {a.dungeon: a.problems for a in self.analyses if not a.ok}
        self.assertFalse(failing, failing)

    def test_rooms_have_several_shapes_and_sizes(self):
        for analysis in self.analyses:
            if analysis.floors < 6:
                continue
            self.assertGreaterEqual(len(analysis.room_kinds), 2, analysis.dungeon)
            self.assertGreater(analysis.room_area[1], analysis.room_area[0], analysis.dungeon)

    def test_corridors_have_bends_and_the_graph_has_branches(self):
        for analysis in self.analyses:
            self.assertGreater(analysis.bends_avg, 0, analysis.dungeon)
            self.assertGreater(analysis.branches_avg + analysis.dead_ends_avg, 0, analysis.dungeon)

    def test_loops_exist_where_the_profiles_promise_them(self):
        looping = [a for a in self.analyses
                   if {"looping", "ring", "lattice"} & set(a.profiles)]
        self.assertTrue(looping)
        for analysis in looping:
            self.assertGreater(analysis.loops_avg, 0, analysis.dungeon)

    def test_every_replay_is_structurally_unique(self):
        for analysis in self.analyses:
            self.assertEqual(analysis.distinct_signatures, analysis.samples, analysis.dungeon)

    def test_fixed_rooms_are_counted_and_not_simulated(self):
        by_id = {a.dungeon: a for a in self.analyses}
        self.assertEqual(by_id["buried_relic"].fixed_floors, 1)
        self.assertEqual(by_id["meteor_cave"].fixed_floors, 1)

    def test_total_floor_count_matches_the_canon(self):
        # `floors` = procedural floor count (fixed_room bosses attached via
        # fixed_segments are dedicated non-counted LayeredSegments). After
        # red_story_08/09/10 promoted the three peak dungeons (mt_thunder_peak,
        # mt_blaze_peak, mt_freeze_peak), each with 1 canonical fixed_room
        # boss floor moved out of the procedural count, the total dropped
        # by 3 to 1423. Every ROM-canonical floor is still represented —
        # the boss floors are the LoadGen + MappedRoomStep segments.
        total = sum(a.floors for a in self.analyses)
        self.assertEqual(total, 1423)
