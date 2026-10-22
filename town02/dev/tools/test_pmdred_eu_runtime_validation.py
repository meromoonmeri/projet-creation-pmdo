#!/usr/bin/env python3
"""Focused regressions for the ignored PMDO runtime fixture and PNG comparator."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import struct
import sys
import tempfile
import unittest
from pathlib import Path

TOOLS = Path(__file__).parent
ROOT = TOOLS.parent


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, TOOLS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


FIXTURE = load("build_pmdred_eu_runtime_fixture")
COMPARE = load("compare_pmdred_eu_pmdo_renders")
REFERENCE = load("render_pmdred_eu_rom_reference")


class TileIndexTests(unittest.TestCase):
    @staticmethod
    def node(seed: int) -> bytes:
        return struct.pack("<ii", seed, 1) + bytes(range(16))

    def test_tile_index_round_trip_is_exact(self) -> None:
        nodes = {"alpha": self.node(7), "épreuve": self.node(9)}
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            FIXTURE.write_tile_index(path, nodes)
            self.assertEqual(FIXTURE.read_tile_index(path), nodes)

    def test_tile_index_rejects_duplicate_names(self) -> None:
        name = b"same"
        entry = FIXTURE.write_7bit_int(len(name)) + name + self.node(1)
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_bytes(struct.pack("<i", 2) + entry + entry)
            with self.assertRaisesRegex(ValueError, "duplicate"):
                FIXTURE.read_tile_index(path)

    def test_tile_node_rejects_truncation(self) -> None:
        with self.assertRaisesRegex(ValueError, "invalid PMDO tile node"):
            FIXTURE.tile_node(struct.pack("<ii", 0, 1) + b"short")


class IndependentReferencePlanTests(unittest.TestCase):
    def test_cell_dependency_schedule_covers_combined_cycle_twice(self) -> None:
        palette = tuple((0, 0, 0, 0) for _ in range(16))
        palette_animation = REFERENCE.PaletteAnimation(3, (palette, palette))
        bpa = REFERENCE.Bpa(
            tile_count=1,
            source_durations=(1, 2),
            durations=(2, 3),
            frames=((bytes(32),), (bytes([1]) * 32,)),
        )
        resources = REFERENCE.GroundResources(
            ground="test",
            names={},
            hashes={},
            palettes=REFERENCE.PaletteSet((palette,), (palette_animation,)),
            bpc=REFERENCE.Bpc(2, 2, (bytes(32),), (tuple([0] * 4), tuple([1] * 4))),
            bpa=(bpa,),
            bma=REFERENCE.Bma(2, 2, 1, 1, 1, ((1,),), None, (), 0),
        )
        channels = REFERENCE.used_animation_channels(resources)
        ticks, schedules = REFERENCE.complete_cell_cycle_boundary_plan(resources, channels)
        self.assertEqual(len(schedules), 1)
        self.assertEqual(schedules[0]["source_local_cycle"], 30)
        first = {tick for tick in ticks if tick < 30}
        second = {tick - 30 for tick in ticks if tick >= 30}
        self.assertEqual(first, second)
        self.assertIn(29, first)
        self.assertIn(30, ticks)
        self.assertLessEqual(max(ticks), 59)

    def test_cached_render_session_is_pixel_identical_for_complete_cycle(self) -> None:
        transparent = (0, 0, 0, 0)
        red = tuple([transparent] + [(255, 0, 0, 255)] * 15)
        blue = tuple([transparent] + [(0, 0, 255, 255)] * 15)
        palette_animation = REFERENCE.PaletteAnimation(3, (red, blue))
        bpa = REFERENCE.Bpa(
            tile_count=1,
            source_durations=(1, 2),
            durations=(2, 3),
            frames=((bytes([0x11]) * 32,), (bytes([0x11]) * 32,)),
        )
        resources = REFERENCE.GroundResources(
            ground="test",
            names={},
            hashes={},
            palettes=REFERENCE.PaletteSet((red,), (palette_animation,)),
            bpc=REFERENCE.Bpc(2, 2, (bytes(32),), (tuple([0] * 4), tuple([1] * 4))),
            bpa=(bpa,),
            bma=REFERENCE.Bma(2, 2, 1, 1, 1, ((1,),), None, (), 0),
        )
        session = REFERENCE.GroundRenderSession(resources)
        self.assertEqual(session.dynamic_cells, (0,))
        for tick in range(60):
            self.assertEqual(
                REFERENCE.render_ground(resources, tick),
                session.render(tick),
                f"cached render differs at source tick {tick}",
            )

    def test_raw_reference_multiprocessing_is_deterministic(self) -> None:
        """The bounded process path must equal serial output and preserve order."""
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            source = root / "source"
            screenshots = root / "screenshots"
            source.mkdir()
            screenshots.mkdir()

            # One opaque red 2x2-cell Ground, encoded through the real raw BPL,
            # BPC, and BMA parsers used to initialize every process worker.
            bpl = struct.pack("<hh", 1, 0) + bytes((255, 0, 0, 0)) * 15
            bpc_header = bytearray(16)
            struct.pack_into("<HHH", bpc_header, 0, 2, 2, 2)
            struct.pack_into("<H", bpc_header, 14, 2)
            bpc = bytes(bpc_header) + bytes((0x11,)) * 32 + struct.pack("<4H", 1, 1, 1, 1)
            bma = (
                bytes((2, 2, 2, 2, 1, 1))
                + struct.pack("<HHH", 1, 0, 0)
                + bytes((0xC0, 1, 0, 0))
            )
            resources = {"SYNTHPAL.bpl": bpl, "SYNTHBPC.bpc": bpc, "SYNTHBMA.bma": bma}
            for name, data in resources.items():
                (source / name).write_bytes(data)
            hashes = {
                name.rsplit(".", 1)[0]: hashlib.sha256(data).hexdigest()
                for name, data in resources.items()
            }
            row = {
                "asset": "synthetic",
                "resources": {
                    "bpl": "SYNTHPAL", "bpc": "SYNTHBPC", "bma": "SYNTHBMA", "bpa": [],
                },
                "source_normalized_sha256": hashes,
            }
            plan_path = root / "plan.json"
            plan_path.write_text(json.dumps({
                "authority": {"kind": "synthetic-regression"},
                "grounds": {
                    "synthetic": {"complete_two_local_cycle_boundary_ticks": [0, 1]},
                },
            }))
            conversion_path = root / "conversion.json"
            conversion_path.write_text(json.dumps({"results": [row]}))

            rgba = bytes((255, 0, 0, 255)) * (16 * 16)
            screenshot_paths = []
            for index, name in enumerate(("primary_0.png", "primary_1.png", "reload_0.png")):
                path = screenshots / name
                COMPARE.encode_rgba(path, 16, 16, rgba)
                timestamp = 1_700_000_000_000_000_000 + index * 1_000_000
                os.utime(path, ns=(timestamp, timestamp))
                screenshot_paths.append(path)

            events = [{"event": "begin", "count": 1, "loads_per_ground": 2}]
            events.extend([
                {"event": "ground_entered", "ground": "synthetic", "phase": "primary"},
                {"event": "screenshot_requested", "ground": "synthetic", "phase": "primary", "source_tick": 0},
                {"event": "screenshot_completed", "ground": "synthetic", "phase": "primary", "source_tick": 0},
                {"event": "screenshot_requested", "ground": "synthetic", "phase": "primary", "source_tick": 1},
                {"event": "screenshot_completed", "ground": "synthetic", "phase": "primary", "source_tick": 1},
                {
                    "ground": "synthetic", "phase": "primary", "load": "LOAD_PASS",
                    "clock_write_read": "PASS", "movement_probe": "PASS",
                    "blocked_probe": "NOT_APPLICABLE_NO_BMA_SOLIDS",
                    "sampled_ticks": [0, 1], "verdict": "SAFE",
                },
                {"event": "ground_exit", "ground": "synthetic", "phase": "primary", "cleanup": "PASS"},
                {"event": "ground_entered", "ground": "synthetic", "phase": "reload"},
                {"event": "screenshot_requested", "ground": "synthetic", "phase": "reload", "source_tick": 0},
                {"event": "screenshot_completed", "ground": "synthetic", "phase": "reload", "source_tick": 0},
                {
                    "ground": "synthetic", "phase": "reload", "load": "LOAD_PASS",
                    "clock_write_read": "PASS", "movement_probe": "PASS",
                    "blocked_probe": "NOT_APPLICABLE_NO_BMA_SOLIDS",
                    "sampled_ticks": [0], "verdict": "SAFE",
                },
                {"event": "ground_exit", "ground": "synthetic", "phase": "reload", "cleanup": "PASS"},
                {"event": "sink_entered", "cleanup": "PASS"},
                {"event": "final_cleanup", "cleanup": "PASS"},
                {"event": "end"},
            ])
            events_path = root / "events.jsonl"
            events_path.write_text("".join(json.dumps(event) + "\n" for event in events))

            reports = []
            for run_index, workers in enumerate((1, 2, 2)):
                report_path = root / f"report-{run_index}.json"
                status = COMPARE.run(argparse.Namespace(
                    events=events_path,
                    screenshots=screenshots,
                    references=None,
                    reference_plan=plan_path,
                    source_dir=source,
                    conversion_report=conversion_path,
                    output=None,
                    report=report_path,
                    workers=workers,
                    montage_all=False,
                ))
                self.assertEqual(status, 0)
                reports.append(json.loads(report_path.read_text()))

            self.assertEqual(reports[0], reports[1])
            self.assertEqual(reports[1], reports[2])
            self.assertEqual(
                [(sample["phase"], sample["tick"]) for sample in reports[2]["samples"]],
                [("primary", 0), ("primary", 1), ("reload", 0)],
            )
            self.assertTrue(reports[2]["all_exact"])


class RuntimeEvidenceTests(unittest.TestCase):
    def test_validation_sink_preserves_local_text_without_mutating_candidate(self) -> None:
        candidate = {
            "Object": {
                "Name": {"DefaultText": "Original", "LocalTexts": {"fr": "Officiel"}},
                "AssetName": "h26p01",
                "Comment": "candidate",
            }
        }
        sink = FIXTURE.validation_sink_payload(candidate)
        self.assertEqual(candidate["Object"]["Name"]["DefaultText"], "Original")
        self.assertEqual(candidate["Object"]["AssetName"], "h26p01")
        self.assertEqual(
            sink["Object"]["Name"],
            {"DefaultText": "PMD Red EU Runtime Validation Sink", "LocalTexts": {"fr": "Officiel"}},
        )
        self.assertEqual(sink["Object"]["AssetName"], "pmdred_eu_validation_sink")
        with self.assertRaisesRegex(ValueError, "serialized LocalText"):
            FIXTURE.validation_sink_payload({"Object": {"Name": "flattened"}})

    def test_entity_integration_proof_allows_only_ordered_additions(self) -> None:
        marker = {"EntName": "Canonical"}
        added_marker = {"EntName": "ProjectMarker"}
        added_spawner = {"EntName": "ProjectSpawner"}
        canonical = {
            "Version": "0.8.9.0",
            "Object": {
                "Comment": "canonical",
                "Entities": [{
                    "Name": "Entities", "Visible": True, "MapChars": [],
                    "GroundObjects": [], "Spawners": [], "Markers": [marker],
                }],
            },
        }
        integrated = json.loads(json.dumps(canonical))
        layer = integrated["Object"]["Entities"][0]
        layer["Markers"].append(added_marker)
        layer["Spawners"].append(added_spawner)
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            canonical_path = root / "canonical.rsground"
            integrated_path = root / "integrated.rsground"
            FIXTURE.write_json_bom(canonical_path, canonical)
            FIXTURE.write_json_bom(integrated_path, integrated)
            evidence = FIXTURE.verify_additive_entity_integration(
                integrated_path, canonical_path
            )
            self.assertEqual(evidence["mode"], "additive_markers_spawners_only")
            self.assertEqual(evidence["layers"][0]["added_markers"], 1)
            self.assertEqual(evidence["layers"][0]["added_spawners"], 1)

            integrated["Object"]["Comment"] = "not canonical"
            FIXTURE.write_json_bom(integrated_path, integrated)
            with self.assertRaisesRegex(ValueError, "outside additive"):
                FIXTURE.verify_additive_entity_integration(
                    integrated_path, canonical_path
                )

            integrated["Object"]["Comment"] = "canonical"
            integrated["Object"]["Entities"][0]["Markers"].reverse()
            FIXTURE.write_json_bom(integrated_path, integrated)
            with self.assertRaisesRegex(ValueError, "changed or reordered"):
                FIXTURE.verify_additive_entity_integration(
                    integrated_path, canonical_path
                )

    def test_native_fixture_uses_exact_movement_and_inert_sink_lifecycle(self) -> None:
        entry = {
            "id": "h26p01",
            "zone_index": 12,
            "preview_ticks": [0, 119],
            "spawn": {"movement_probes": {
                "successful": {
                    "x": 8, "y": 8, "direction": "Down", "expected_delta": [0, 8],
                },
                "blocked": None,
                "solid_cells": 0,
            }},
        }
        script = FIXTURE.native_validator_script([entry], 99)
        self.assertIn("MoveInDirection(hero,DIR[p.dir],8,false,1)", script)
        self.assertIn("local SINK={zone='master_zone',idx=99}", script)
        self.assertIn("{\"event\":\"final_cleanup\",\"cleanup\":\"PASS\"}", script)
        self.assertIn("self.capture_total=tick*120", script)
        self.assertIn("if self.capture_total~=nil then", script)
        self.assertIn("GraphicsManager.TotalFrameTick=self.capture_total", script)
        self.assertIn("self:screenshot(id,phase,tick,assigned)", script)
        self.assertIn("function V:OnUpdate()", script)
        self.assertIn("EngineServiceEvents.Update,function()self.OnUpdate(self)end", script)

    def test_native_lifecycle_order_rejects_unrequested_capture_and_missing_sink(self) -> None:
        events = [
            {"event": "begin", "count": 1, "loads_per_ground": 2},
            {"event": "ground_entered", "ground": "h26p01", "phase": "primary"},
            {"event": "screenshot_completed", "ground": "h26p01", "phase": "primary", "source_tick": 0},
            {"ground": "h26p01", "phase": "primary", "sampled_ticks": [0], "verdict": "SAFE"},
            {"event": "ground_exit", "ground": "h26p01", "phase": "primary", "cleanup": "PASS"},
            {"event": "ground_entered", "ground": "h26p01", "phase": "reload"},
            {"event": "screenshot_requested", "ground": "h26p01", "phase": "reload", "source_tick": 0},
            {"event": "screenshot_completed", "ground": "h26p01", "phase": "reload", "source_tick": 0},
            {"ground": "h26p01", "phase": "reload", "sampled_ticks": [0], "verdict": "SAFE"},
            {"event": "ground_exit", "ground": "h26p01", "phase": "reload", "cleanup": "PASS"},
            {"event": "final_cleanup", "cleanup": "PASS"},
            {"event": "end"},
        ]
        result = COMPARE.validate_native_lifecycle_order(events)
        self.assertTrue(result["applicable"])
        self.assertFalse(result["pass"])
        self.assertTrue(any("does not match pending request" in error for error in result["errors"]))
        self.assertTrue(any("sink_entered is missing" in error for error in result["errors"]))
        self.assertTrue(any("final_cleanup precedes sink_entered" in error for error in result["errors"]))

    def test_comparator_accepts_primary_and_reload_source_ticks(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            screenshots = root / "screenshots"
            reference = root / "references" / "h26p01"
            output = root / "output"
            screenshots.mkdir()
            reference.mkdir(parents=True)
            rgba = bytes((10, 20, 30, 255))
            COMPARE.encode_rgba(reference / "animation.png", 1, 1, rgba)
            (reference / "animation.json").write_text(json.dumps({
                "preview": {"frame_start_ticks": [0]},
            }))
            COMPARE.encode_rgba(screenshots / "a.png", 1, 1, rgba)
            COMPARE.encode_rgba(screenshots / "b.png", 1, 1, rgba)
            events = [
                {"event": "begin", "count": 1, "loads_per_ground": 2},
                {"event": "ground_entered", "ground": "h26p01", "phase": "primary"},
                {"event": "screenshot_requested", "ground": "h26p01", "phase": "primary", "source_tick": 0},
                {"event": "screenshot_completed", "ground": "h26p01", "phase": "primary", "source_tick": 0},
                {"ground": "h26p01", "phase": "primary", "load": "LOAD_PASS", "clock_write_read": "PASS", "movement_probe": "PASS", "blocked_probe": "NOT_APPLICABLE_NO_BMA_SOLIDS", "sampled_ticks": [0], "verdict": "SAFE"},
                {"event": "ground_exit", "ground": "h26p01", "phase": "primary", "cleanup": "PASS"},
                {"event": "ground_entered", "ground": "h26p01", "phase": "reload"},
                {"event": "screenshot_requested", "ground": "h26p01", "phase": "reload", "source_tick": 0},
                {"event": "screenshot_completed", "ground": "h26p01", "phase": "reload", "source_tick": 0},
                {"ground": "h26p01", "phase": "reload", "load": "LOAD_PASS", "clock_write_read": "PASS", "movement_probe": "PASS", "blocked_probe": "NOT_APPLICABLE_NO_BMA_SOLIDS", "sampled_ticks": [0], "verdict": "SAFE"},
                {"event": "ground_exit", "ground": "h26p01", "phase": "reload", "cleanup": "PASS"},
                {"event": "sink_entered", "cleanup": "PASS"},
                {"event": "final_cleanup", "cleanup": "PASS"},
                {"event": "end"},
            ]
            events_path = root / "events.jsonl"
            events_path.write_text("".join(json.dumps(event) + "\n" for event in events))
            report_path = root / "report.json"
            status = COMPARE.run(argparse.Namespace(
                events=events_path,
                screenshots=screenshots,
                references=root / "references",
                output=output,
                report=report_path,
            ))
            self.assertEqual(status, 0)
            report = json.loads(report_path.read_text())
            self.assertTrue(report["runtime"]["runtime_sequence_consistent"])
            self.assertTrue(report["runtime"]["native_lifecycle_order"]["pass"])
            self.assertEqual(report["runtime"]["cleanup_probe_count"], 4)
            self.assertEqual(
                [(row["phase"], row["tick"]) for row in report["samples"]],
                [("primary", 0), ("reload", 0)],
            )
            self.assertTrue((output / "h26p01/comparison_primary_tick0.png").is_file())
            self.assertTrue((output / "h26p01/comparison_reload_tick0.png").is_file())

    def test_canonical_apng_decodes_every_stored_state(self) -> None:
        frames = COMPARE.decode_png(
            ROOT / "docs/pmdred_eu/dungeon_grounds/d02p02/animation.png"
        )
        self.assertEqual(len(frames), 4)
        self.assertTrue(all(frame.width == 360 and frame.height == 336 for frame in frames))
        self.assertTrue(all(all(frame.rgba[i] == 255 for i in range(3, len(frame.rgba), 4)) for frame in frames))

    def test_rgba_encoder_round_trip(self) -> None:
        rgba = bytes((1, 2, 3, 255, 40, 50, 60, 127, 250, 0, 99, 0, 4, 5, 6, 255))
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "sample.png"
            COMPARE.encode_rgba(path, 2, 2, rgba)
            decoded = COMPARE.decode_png(path)[0]
            fast, source = COMPARE.decode_static_png_fast(path)
            self.assertEqual(decoded.rgba, rgba)
            self.assertEqual(fast, decoded)
            self.assertEqual(source, path.read_bytes())

    def test_targeted_report_proves_reentry_exit_and_final_cleanup(self) -> None:
        report = FIXTURE.read_json(
            ROOT / "docs/pmdred_eu/pmdo_validation/route193_reentry.json"
        )
        runtime = report["runtime"]
        self.assertEqual(runtime["validation_count"], 2)
        self.assertEqual(runtime["same_ground_reentry_count"], 1)
        self.assertEqual(runtime["observed_ground_exit_count"], 1)
        self.assertEqual(runtime["cleanup_probe_count"], 2)
        self.assertTrue(runtime["all_runtime_safe"])
        self.assertTrue(runtime["runtime_sequence_consistent"])
        self.assertTrue(runtime["all_cleanups_pass"])
        self.assertTrue(runtime["end_event_seen"])


if __name__ == "__main__":
    unittest.main()
