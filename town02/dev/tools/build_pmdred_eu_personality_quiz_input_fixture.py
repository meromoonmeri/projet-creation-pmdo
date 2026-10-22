#!/usr/bin/env python3
"""Build a PMDO fixture that drives real quiz menus via FrameInput replay."""

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
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_personality_quiz_flow_fixture.py"
SPEC = importlib.util.spec_from_file_location("pmdred_quiz_flow_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def service_script(zone_index: int) -> str:
    return f"""-- Generated ignored service: real PMDO menu input through debug replay.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuPersonalityQuizInputValidator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_PERSONALITY_INPUT] '..s)
 local f=io.open('/tmp/pmdred_eu_personality_quiz_input.jsonl','a')
 if f then f:write(s..'\\n');f:flush();f:close() end
end
local function fields(payload)
 local result='';if payload==nil then return result end
 for _,key in ipairs({{'context','purpose','value','maximum','question','answer','asked_index','choice','result','personality','tie_start','species','historical_gender_column','recommendation','frames','source_opcode','cue','segment','after','choice_count','input_kind','replay_count','replay_index'}}) do
  local value=payload[key]
  if value~=nil then
   if type(value)=='number' then result=result..',"'..key..'":'..tostring(value)
   elseif type(value)=='boolean' then result=result..',"'..key..'":'..tostring(value)
   else result=result..',"'..key..'":"'..quote(value)..'"' end
  end
 end
 return result
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_NARRATIVE_VALIDATOR')=='pmdred_eu_personality_quiz_input'
 self.started=false;self.running=false;self.sequence=0;self.frame=0;self.queued_inputs=0
end
function V:record(event,payload)
 self.sequence=self.sequence+1
 emit('{{"event":"'..quote(event)..'","sequence":'..self.sequence..',"frame":'..self.frame..fields(payload)..'}}')
end
function V:OnUpdate(gtime)self.frame=self.frame+1 end
function V:make_input(key)
 local FrameInput=luanet.import_type('RogueEssence.FrameInput')
 if key==nil then return FrameInput() end
 local GamePadState=luanet.import_type('Microsoft.Xna.Framework.Input.GamePadState')
 local KeyboardState=luanet.import_type('Microsoft.Xna.Framework.Input.KeyboardState')
 local MouseState=luanet.import_type('Microsoft.Xna.Framework.Input.MouseState')
 local Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
 local Loc=luanet.import_type('RogueElements.Loc')
 local arr=LUA_ENGINE:MakeLuaArray(Keys,{{key}})
 return FrameInput(GamePadState(),KeyboardState(arr),MouseState(),true,false,true,Loc(0,0))
end
function V:queue_key(key,kind)
 -- First pulse can finish a typewriter; a later pulse advances/selects.
 for _=1,60 do self.replay:Add(self:make_input(nil)) end
 self.replay:Add(self:make_input(key));self.replay:Add(self:make_input(nil))
 self.queued_inputs=self.queued_inputs+1
 self:record('PHYSICAL_INPUT_QUEUED',{{input_kind=kind,replay_count=self.replay.Count,replay_index=self.diag.DebugReplayIndex}})
end
function V:queue_confirm()self:queue_key(self.Keys.Enter,'confirm')end
function V:queue_down_confirm()
 self:queue_key(self.Keys.Down,'down')
 self:queue_key(self.Keys.Enter,'confirm_after_down')
end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/pmdred_eu_personality_quiz_input.jsonl','w');if f then f:close() end
 local ListType=luanet.import_type('System.Collections.Generic.List`1')
 local FrameInput=luanet.import_type('RogueEssence.FrameInput')
 self.Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
 self.replay=LUA_ENGINE:MakeGenericType(ListType,{{FrameInput}},{{}})
 self.diag=luanet.import_type('RogueEssence.DiagManager').Instance
 for _=1,60 do self.replay:Add(FrameInput()) end
 self.diag.ActiveDebugReplay=self.replay;self.diag.DebugReplayIndex=0
 self:record('BOOTSTRAP',{{context='physical_frame_input_replay',replay_count=self.replay.Count}})
 RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:begin()
 if not self.enabled or self.started then return end
 self.started=true;self:record('ENTER_ZONE_REQUEST',{{context='personality_test'}})
 GAME:EnterZone('master_zone',-1,{zone_index},0)
end
function V:validate()
 local map=GAME:GetCurrentGround();if map==nil or map.AssetName~='personality_test' then error('personality_test not loaded') end
 local hero=CH('PLAYER');if hero~=nil then GROUND:Hide(hero.EntName) end
 self:record('GROUND_ASSERTED',{{context='personality_test'}})
 local Flow=require 'halcyon.ground.personality_test.pmdred_quiz_flow'
 local draws={{0,4,8,12,16,20,24,28}};local draw_index=0
 local options={{
  next_int=function(maximum,purpose)
   if purpose=='question' then draw_index=draw_index+1;return draws[draw_index] end
   return 0
  end,
  resolve_species_name=function(species)return '<'..species..'>' end,
  present_segment=function(text,context)
   self:queue_confirm();self:queue_confirm()
   UI:WaitShowVoiceOver(STRINGS:Format(text),-1)
  end,
  on_action=function(event,payload)
   self:record(event,payload)
   if event=='QUIZ_CHOICE_BEGIN' then
    self:queue_confirm();self:queue_confirm()
   end
  end,
 }}
 Flow.PlayCanonicalPrelude(options)
 local result=Flow.Run(options)
 if result.personality~='naive' then error('physical input personality differs') end
 if result.gender_choice~=1 then error('physical confirm did not select male') end
 if result.recommendation~='totodile' then error('male naive recommendation differs') end
 if result.totals.hardy~=2 or result.totals.naive~=5 then error('physical answer scoring differs') end
 self:record('PHYSICAL_FLOW_RESULT_ASSERTED',{{personality=result.personality,choice=result.gender_choice,recommendation=result.recommendation}})
 Flow.ShowPartnerPrompt(options)
 Flow.ShowEndText(options)
 Flow.FadeOutCanonical(options)
 GAME:WaitFrames(8)
 self:record('REPLAY_STATE_ASSERTED',{{replay_count=self.replay.Count,replay_index=self.diag.DebugReplayIndex}})
 if self.diag.DebugReplayIndex<=60 or self.queued_inputs<1 then error('FrameInput replay was not consumed') end
 self:record('PHYSICAL_INPUT_TIMELINE_COMPLETE',{{context='real_begin_choice_menu'}})
end
function V:OnGroundMapEnter()
 if not self.enabled or self.running then return end
 local map=GAME:GetCurrentGround();if map==nil or map.AssetName~='personality_test' then return end
 self.running=true
 TASK:BranchCoroutine(function()
  local ok,err=xpcall(function()self:validate()end,debug.traceback)
  if not ok then self:record('RUNTIME_FAIL',{{context=err}})
  else self:record('RUNTIME_RESULT',{{result='PASS'}}) end
  self:record('end',{{context='normal_unload_requested'}})
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
 end)
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuPersonalityQuizInputValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizInputValidator',EngineServiceEvents.Update,function(_,gtime)self.OnUpdate(self,gtime)end)
 med:Subscribe('PmdRedEuPersonalityQuizInputValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizInputValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizInputValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuPersonalityQuizInputValidator',V:new())
return V
"""


def build(output: Path) -> Path:
    quest = BASE.build(output)
    zone = BASE.BASE.read_json(ROOT / "Data/Zone/master_zone.json")
    zone_index = zone["Object"]["GroundMaps"].index("personality_test")
    service = quest / "Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    service.write_text(service_script(zone_index), encoding="utf-8")
    manifest_path = output / "fixture_manifest.json"
    import json
    manifest = json.loads(manifest_path.read_text())
    manifest["schema"] = "new-era.pmdred-eu-personality-quiz-input-runtime-fixture.v1"
    manifest["scope"] = "real PMDO BeginChoiceMenu cursor input via FrameInput debug replay; production Enter inert fixture-locally"
    manifest["input_mode"] = "RogueEssence.DiagManager.ActiveDebugReplay with neutral/down/enter FrameInput objects"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/pmdred-eu-personality-quiz-input-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
