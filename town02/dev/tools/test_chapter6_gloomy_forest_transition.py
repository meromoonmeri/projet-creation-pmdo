#!/usr/bin/env python3
"""Execute the chapter-6 relay duel transition through the real Lua module.

This is a focused logic/runtime regression for the existing New Era Gloomy
Forest route.  It does not promote the PMD Red dungeon chain: it only proves
that the Team Dazzling relay interaction enters its own segment and cannot
accidentally relaunch the Zeraora arena.
"""
from __future__ import annotations

import unittest
from pathlib import Path

from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "Data/Script/halcyon/ground/gloomy_forest_midpoint/gloomy_forest_midpoint_ch_6.lua"


class Chapter6RelayTransitionRuntime(unittest.TestCase):
    def test_dazzling_trial_enters_segment_7_not_zeraora_segment_4(self) -> None:
        lua = LuaRuntime(unpack_returned_tuples=True)
        calls: list[tuple[str, tuple[object, ...]]] = []

        def record(name: str, *args: object) -> None:
            calls.append((name, args))

        lua.globals().PYREC = record
        lua.execute(
            r'''
            function require(_) return true end
            local function namespace(name)
              return setmetatable({}, {__index=function(t, key)
                local f = function(_, ...) PYREC(name .. "." .. key, ...) end
                rawset(t, key, f)
                return f
              end})
            end
            GAME = namespace("GAME")
            SOUND = namespace("SOUND")
            GROUND = namespace("GROUND")
            UI = namespace("UI")
            AI = namespace("AI")
            DEBUG = namespace("DEBUG")
            UI.ChoiceResult = function(_) return true end
            TASK = {
              BranchCoroutine = function(_, f) if f then f() end return {} end,
              JoinCoroutines = function(_) end,
            }
            GeneralFunctions = {
              StartConversation = function(...) end,
              EndConversation = function(...) end,
              SetEmotion = function(...) end,
            }
            MidpointTemplate = {}
            CharacterEssentials = {}
            CH = function(name)
              return {EntName=name, Position={X=0, Y=0}}
            end
            Direction = {Up="Up", Down="Down", Left="Left", Right="Right"}
            SV = {Chapter6={DazzlingTrialCleared=false}}
            RogueEssence = {
              Data = {GameProgress = {DungeonStakes = {Risk="Risk"}}}
            }
            function PrintInfo(_) end
            '''
        )

        lua.execute(MODULE.read_text(encoding="utf-8"))
        lua.globals().gloomy_forest_midpoint_ch_6.Adagio_Action(
            lua.eval("{EntName='Adagio'}"), lua.eval("{}")
        )

        transitions = [args for name, args in calls if name == "GAME.ContinueDungeon"]
        self.assertEqual(len(transitions), 1)
        self.assertEqual(transitions[0][0], "gloomy_forest")
        self.assertEqual(transitions[0][1], 7)
        self.assertNotEqual(transitions[0][1], 4)


if __name__ == "__main__":
    unittest.main()
