#!/usr/bin/env python3
"""Build an ignored real-PMDO fixture for the integrated quiz core.

The fixture loads the tracked ``personality_test`` Ground and its New Era
parallax without executing the production entry coroutine.  It overrides only
the fixture-local Ground lifecycle and Agent A service slot, then exercises the
tracked canonical data/scoring modules through PMDO's actual Lua runtime.
"""

from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import argparse
import hashlib
import importlib.util
import json
import os
import shutil
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FIXTURE_TOOL_PATH = ROOT / "tools/build_pmdred_eu_runtime_fixture.py"
SPEC = importlib.util.spec_from_file_location("pmdred_ground_fixture", FIXTURE_TOOL_PATH)
assert SPEC and SPEC.loader
GROUND_FIXTURE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GROUND_FIXTURE)

GROUND = "Data/Ground/personality_test.rsground"
QUIZ_DATA = "Data/Script/halcyon/ground/personality_test/pmdred_quiz_data.lua"
QUIZ_ENGINE = "Data/Script/halcyon/ground/personality_test/pmdred_quiz_engine.lua"
AUTHORITY = "docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json"
DREAM_BACK = "Content/BG/Dream_Back.dir"
DREAM_FRONT = "Content/BG/Dream_Front.dir"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def inert_ground_script() -> str:
    return """-- Ignored fixture lifecycle; tracked personality_test code remains untouched.
require 'origin.common'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def service_script(zone_index: int) -> str:
    return f"""-- Generated ignored fixture service for the integrated PMD Red EU quiz core.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuPersonalityQuizValidator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_PERSONALITY_QUIZ] '..s)
 local f=io.open('/tmp/pmdred_eu_personality_quiz.jsonl','a')
 if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_NARRATIVE_VALIDATOR')=='pmdred_eu_personality_quiz_core'
 self.started=false;self.running=false;self.sequence=0;self.frame=0
end
function V:record(event,fields)
 self.sequence=self.sequence+1
 emit('{{"event":"'..quote(event)..'","sequence":'..self.sequence..',"frame":'..self.frame..(fields or '')..'}}')
end
function V:OnUpdate(gtime)self.frame=self.frame+1 end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/pmdred_eu_personality_quiz.jsonl','w');if f then f:close() end
 self:record('BOOTSTRAP',',"fixture":"personality_quiz_core"')
 RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:begin()
 if not self.enabled or self.started then return end
 self.started=true
 self:record('ENTER_ZONE_REQUEST',',"asset":"personality_test"')
 GAME:EnterZone('master_zone',-1,{zone_index},0)
end
local function assert_equal(actual,expected,message)
 if actual~=expected then error(message..': expected '..tostring(expected)..', got '..tostring(actual)) end
end
local function selected_json(values)
 local result={{}}
 for _,value in ipairs(values) do result[#result+1]='"'..quote(value)..'"' end
 return '['..table.concat(result,',')..']'
end
function V:validate()
 local map=GAME:GetCurrentGround()
 if map==nil or map.AssetName~='personality_test' then error('immutable personality_test Ground not loaded') end
 self:record('GROUND_ASSERTED',',"asset":"personality_test"')
 local hero=CH('PLAYER')
 if hero~=nil then GROUND:Hide(hero.EntName) end
 self:record('PRESENTATION_ACTORS_HIDDEN',',"actor_count":'..(hero~=nil and '1' or '0'))

 local Engine=require 'halcyon.ground.personality_test.pmdred_quiz_engine'
 local Data=Engine.Data()
 assert_equal(Data.classification,'PMD_RED_EU_CANON','wrong data classification')
 assert_equal(#Data.personalities,13,'wrong personality count')
 assert_equal(#Data.selectable,55,'wrong selectable question count')
 assert_equal(Data.branch_question,'brave_2b','wrong branch question')
 assert_equal(Data.questions.hardy_1.text.segments[1].text,"Un contrôle va avoir lieu bientôt.\\nComment le préparez-vous?",'French EU question drift')
 assert_equal(Data.questions.hardy_1.answers[1].text.segments[1].text,"J'étudie beaucoup.",'French EU answer drift')
 self:record('DATA_ASSERTED',',"personalities":13,"selectable_questions":55,"branch_questions":1,"asked_questions":8')

 local draws={{0,1,4,8,12,16,20,24,28}}
 local draw_index=0
 local selected=Engine.SelectQuestions(function(maximum)
  assert_equal(maximum,55,'wrong selection RNG bound')
  draw_index=draw_index+1
  local value=draws[draw_index]
  if value==nil then error('selection consumed too many fixture draws') end
  self:record('RNG_DRAW',',"draw_index":'..draw_index..',"maximum":'..maximum..',"value":'..value)
  return value
 end)
 local expected={{'hardy_1','docile_1','brave_1','jolly_1','impish_1','naive_1','timid_1','hasty_1'}}
 assert_equal(#selected,8,'wrong selected question count')
 for index,value in ipairs(expected) do assert_equal(selected[index],value,'question order drift at '..index) end
 self:record('QUESTIONS_SELECTED',',"questions":'..selected_json(selected)..',"rejected_category_draws":1')

 local state=Engine.NewState()
 for index,question_id in ipairs(selected) do
  local branch=Engine.ApplyAnswer(state,question_id,1)
  assert_equal(branch,nil,'unexpected branch in deterministic scoring path')
  self:record('ANSWER_APPLIED',',"question":"'..question_id..'","answer":1')
 end
 assert_equal(state.totals.hardy,2,'hardy total drift')
 assert_equal(state.totals.docile,2,'docile total drift')
 assert_equal(state.totals.brave,3,'brave total drift')
 assert_equal(state.totals.jolly,2,'jolly total drift')
 assert_equal(state.totals.impish,4,'impish total drift')
 assert_equal(state.totals.naive,5,'naive total drift')
 assert_equal(state.totals.timid,2,'timid total drift')
 assert_equal(state.totals.hasty,2,'hasty total drift')
 assert_equal(state.totals.lonely,1,'lonely total drift')
 assert_equal(Engine.ResolvePersonality(state,0),'naive','strict-greater result drift')
 self:record('SCORING_ASSERTED',',"result":"naive","max_points":5,"history_count":8')

 local branch_state=Engine.NewState()
 local branch=Engine.ApplyAnswer(branch_state,'brave_2a',1)
 assert_equal(branch,'brave_2b','BraveQuest2B trigger drift')
 Engine.ApplyAnswer(branch_state,branch,2)
 assert_equal(branch_state.totals.brave,4,'BraveQuest2B effect drift')
 self:record('BRANCH_ASSERTED',',"source":"brave_2a","target":"brave_2b","result_points":4')
 local tie_state=Engine.NewState()
 assert_equal(Engine.ResolvePersonality(tie_state,5),'naive','canonical all-zero tie result drift')
 self:record('TIE_ASSERTED',',"tie_start":5,"result":"naive"')

 GAME:WaitFrames(6)
 self:record('SCREENSHOT_REQUESTED',',"phase":"parallax_early"')
 _GROUND:Screenshot();GAME:WaitFrames(4)
 self:record('SCREENSHOT_COMPLETED',',"phase":"parallax_early"')
 GAME:WaitFrames(120)
 self:record('SCREENSHOT_REQUESTED',',"phase":"parallax_late"')
 _GROUND:Screenshot();GAME:WaitFrames(4)
 self:record('SCREENSHOT_COMPLETED',',"phase":"parallax_late"')
 self:record('PARALLAX_TIMELINE_COMPLETED',',"elapsed_frames":120,"back_movement_x":30,"front_movement_x":-30')
end
function V:OnGroundMapEnter()
 if not self.enabled or self.running then return end
 local map=GAME:GetCurrentGround()
 if map==nil or map.AssetName~='personality_test' then return end
 self.running=true
 TASK:BranchCoroutine(function()
  local ok,err=xpcall(function()self:validate()end,debug.traceback)
  if not ok then self:record('RUNTIME_FAIL',',"error":"'..quote(err)..'"')
  else self:record('RUNTIME_RESULT',',"result":"PASS"') end
  self:record('end',',"normal_unload_requested":true')
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
 end)
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuPersonalityQuizValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizValidator',EngineServiceEvents.Update,function(_,gtime)self.OnUpdate(self,gtime)end)
 med:Subscribe('PmdRedEuPersonalityQuizValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuPersonalityQuizValidator',V:new())
return V
"""


def build(output: Path) -> Path:
    root = ROOT
    authority = read_json(root / AUTHORITY)
    if authority["authority"]["rom_sha256"] != "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd":
        raise ValueError("quiz authority ROM lock drift")
    if output.exists():
        shutil.rmtree(output)
    quest = output / "quest"
    output.mkdir(parents=True)

    GROUND_FIXTURE.symlink(root / "Mod.xml", quest / "Mod.xml")
    GROUND_FIXTURE.symlink(root / "Strings", quest / "Strings")
    GROUND_FIXTURE.overlay_data_root(root / "Data", quest / "Data", {"Script", "Misc", "Zone"})
    shutil.copytree(root / "Data/Misc", quest / "Data/Misc")
    zone_dir = quest / "Data/Zone"
    zone_dir.mkdir(parents=True)
    GROUND_FIXTURE.symlink(root / "Data/Zone/master_zone.json", zone_dir / "master_zone.json")

    GROUND_FIXTURE.overlay_children(root / "Data/Script", quest / "Data/Script", {"halcyon"})
    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon", quest / "Data/Script/halcyon", {"ground", "services"}
    )
    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground", {"personality_test"}
    )
    personality_dir = quest / "Data/Script/halcyon/ground/personality_test"
    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon/ground/personality_test", personality_dir, {"init.lua"}
    )
    (personality_dir / "init.lua").write_text(inert_ground_script(), encoding="utf-8")

    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon/services", quest / "Data/Script/halcyon/services",
        {"ground_gameplay_validator"},
    )
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    zone = read_json(root / "Data/Zone/master_zone.json")
    maps = zone["Object"]["GroundMaps"]
    if maps.count("personality_test") != 1:
        raise ValueError("master_zone must contain personality_test exactly once")
    zone_index = maps.index("personality_test")
    (service_dir / "init.lua").write_text(service_script(zone_index), encoding="utf-8")

    GROUND_FIXTURE.overlay_data_tree(root / "Content", quest / "Content")
    asset_root = output / "asset"
    GROUND_FIXTURE.overlay_children(root / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    GROUND_FIXTURE.symlink(quest, appdata / "MODS/pmdred_eu_personality_quiz_fixture")

    exposed_indexes = sorted(
        path.relative_to(quest).as_posix() for path in quest.rglob("index.idx") if path.is_symlink()
    )
    if exposed_indexes:
        raise ValueError(f"fixture exposes writable source indexes: {exposed_indexes}")
    manifest = {
        "schema": "new-era.pmdred-eu-personality-quiz-runtime-fixture.v1",
        "scope": "tracked personality_test Ground, parallax, quiz data, and pure scoring engine; no route registration",
        "quest_name": "pmdred_eu_personality_quiz_fixture",
        "quest": str(quest),
        "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep,
        "zone": "master_zone",
        "zone_index": zone_index,
        "tracked_hashes": {
            path: sha256_file(root / path)
            for path in (GROUND, DREAM_BACK, DREAM_FRONT, QUIZ_DATA, QUIZ_ENGINE, AUTHORITY)
        },
        "fixture_local_indexes": sorted(
            path.relative_to(quest).as_posix() for path in quest.rglob("index.idx") if not path.is_symlink()
        ),
        "source_index_symlinks": exposed_indexes,
    }
    (output / "fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/pmdred-eu-personality-quiz-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
