#!/usr/bin/env python3
from __future__ import annotations

import json
import unittest
from pathlib import Path

from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
LUA_PATH = ROOT / "Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua"
REGISTRY_PATH = ROOT / "docs/canonical_journeys/PMD_RED_OPCODE_REGISTRY.json"


class PrimitiveAdapterTests(unittest.TestCase):
    def runtime(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(
            """
            EVENTS = {}
            local function record(kind, a, b)
              table.insert(EVENTS, {kind = kind, a = a, b = b})
            end
            Direction = {
              Down = 'pmdo_down', DownRight = 'pmdo_down_right',
              Right = 'pmdo_right', UpRight = 'pmdo_up_right',
              Up = 'pmdo_up', UpLeft = 'pmdo_up_left',
              Left = 'pmdo_left', DownLeft = 'pmdo_down_left',
            }
            GAME = { WaitFrames = function(_, frames) record('wait', frames, nil) end }
            SOUND = { FadeOutBGM = function(_, frames) record('bgm_fadeout', frames, nil) end }
            GROUND = {
              EntTurn = function(_, actor, direction)
                if type(actor) == 'table' then actor.Direction = direction end
                record('turn', actor, direction)
              end,
              CharAnimateTurn = function(_, actor, direction, frames, ccw)
                actor.Direction = direction
                record('animate_turn', frames, ccw)
              end,
              CharAnimateTurnTo = function(_, actor, direction, frames)
                actor.Direction = direction
                record('animate_turn_to', frames, direction)
              end,
            }
            """
        )
        adapters = lua.execute(LUA_PATH.read_text(encoding="utf-8"))
        return lua, adapters

    def events(self, lua):
        table = lua.globals().EVENTS
        return [dict(table[index]) for index in range(1, len(table) + 1)]

    def test_only_registry_proven_primitives_are_exposed(self):
        registry = json.loads(REGISTRY_PATH.read_text(encoding="utf-8"))
        proved = {
            entry["kind"] for entry in registry["entries"]
            if entry["adapter_status"] == "ADAPTER_PROVEN"
        }
        lua, adapters = self.runtime()
        exposed = {key for key, value in adapters["PROVEN"].items() if value}
        self.assertEqual(proved, {"WAIT", "BGM_FADEOUT", "SET_DIR_WAIT", "ROTATE_TO", "CMD_UNK_92"})
        self.assertEqual(exposed, proved)

    def test_wait_and_bgm_fade_preserve_frame_operands(self):
        lua, adapters = self.runtime()
        adapters["WAIT"](30)
        adapters["BGM_FADEOUT"](120)
        self.assertEqual(
            self.events(lua),
            [
                {"kind": "wait", "a": 30},
                {"kind": "bgm_fadeout", "a": 120},
            ],
        )

    def test_direction_symbols_are_explicitly_remapped(self):
        lua, adapters = self.runtime()
        actor = "source_parent"
        expected = {
            "DIRECTION_SOUTH": "pmdo_down",
            "DIRECTION_SOUTHEAST": "pmdo_down_right",
            "DIRECTION_EAST": "pmdo_right",
            "DIRECTION_NORTHEAST": "pmdo_up_right",
            "DIRECTION_NORTH": "pmdo_up",
            "DIRECTION_NORTHWEST": "pmdo_up_left",
            "DIRECTION_WEST": "pmdo_left",
            "DIRECTION_SOUTHWEST": "pmdo_down_left",
        }
        for source, target in expected.items():
            adapters["SET_DIR_WAIT"](actor, source, 0)
            self.assertEqual(self.events(lua)[-1], {"kind": "turn", "a": actor, "b": target})
        before = len(self.events(lua))
        adapters["SET_DIR_WAIT"](actor, -1, 0)
        self.assertEqual(len(self.events(lua)), before)

    def test_rotation_policies_reach_the_symbolic_target(self):
        lua, adapters = self.runtime()
        cases = [
            ("DIR_TRANS_SPINRIGHT1", "DIRECTION_NORTH", "pmdo_up"),
            ("DIR_TRANS_SPINLEFT1", "DIRECTION_EAST", "pmdo_right"),
            ("DIR_TRANS_10", "DIRECTION_WEST", "pmdo_left"),
            ("DIR_TRANS_11", "DIRECTION_NORTHEAST", "pmdo_up_right"),
        ]
        for transition, source_target, pmdo_target in cases:
            actor = lua.table(Direction="pmdo_down")
            adapters["ROTATE_TO"](actor, 4, transition, source_target)
            self.assertEqual(actor["Direction"], pmdo_target)

    def test_relative_target_rotation_matches_all_corpus_forms(self):
        lua, adapters = self.runtime()
        cases = [
            (1, "DIR_TRANS_SPINRIGHT2", "pmdo_left"),
            (2, "DIR_TRANS_SPINLEFT2", "pmdo_right"),
            (2, "DIR_TRANS_FLIP", "pmdo_up"),
        ]
        for turn_step, transform, pmdo_target in cases:
            actor = lua.table(Direction="pmdo_down")
            adapters["CMD_UNK_92"](actor, 4, turn_step, transform)
            self.assertEqual(actor["Direction"], pmdo_target)

    def test_invalid_or_unmapped_inputs_fail_closed(self):
        lua, adapters = self.runtime()
        execute = adapters["Execute"]
        with self.assertRaises(Exception):
            adapters["WAIT"](-1)
        with self.assertRaises(Exception):
            adapters["SET_DIR_WAIT"]("actor", 2, 0)
        with self.assertRaises(Exception):
            adapters["SET_DIR_WAIT"](None, "DIRECTION_NORTH", 0)
        with self.assertRaises(Exception):
            adapters["ROTATE_TO"](lua.table(Direction="pmdo_down"), 4, "DIR_TRANS_RAND", "DIRECTION_NORTH")
        with self.assertRaises(Exception):
            adapters["CMD_UNK_92"](lua.table(Direction="pmdo_down"), 4, 1, "DIR_TRANS_RAND")
        with self.assertRaises(Exception):
            execute("RAW_OPCODE_0X62", lua.table(), lua.table())

    def test_module_contains_no_route_or_ground_mutation(self):
        source = LUA_PATH.read_text(encoding="utf-8")
        for forbidden in (
            "EnterGroundMap", "EnterDungeon", "ContinueDungeon", "EnterZone",
            "EndDungeonRun", "Data/Ground", "Data/Zone", "require '", 'require "',
        ):
            self.assertNotIn(forbidden, source)


if __name__ == "__main__":
    unittest.main(verbosity=2)
