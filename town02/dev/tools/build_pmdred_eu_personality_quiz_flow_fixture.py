#!/usr/bin/env python3
"""Build the ignored PMDO fixture for the integrated quiz presentation flow."""

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
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_personality_quiz_fixture.py"
SPEC = importlib.util.spec_from_file_location("pmdred_quiz_core_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def service_script(zone_index: int) -> str:
    return f"""-- Generated ignored PMDO service for the integrated quiz presentation flow.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuPersonalityQuizFlowValidator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_PERSONALITY_FLOW] '..s)
 local f=io.open('/tmp/pmdred_eu_personality_quiz_flow.jsonl','a')
 if f then f:write(s..'\\n');f:flush();f:close() end
end
local function fields(payload)
 local result=''
 if payload==nil then return result end
 for _,key in ipairs({{'context','purpose','value','maximum','question','answer','asked_index','source','target','choice','result','personality','tie_start','species','historical_gender_column','recommendation','frames','source_opcode','cue','page_count','key','index','segment','after','choice_count','new_era_non_binding'}}) do
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
 self.enabled=os.getenv('PMDO_NARRATIVE_VALIDATOR')=='pmdred_eu_personality_quiz_flow'
 self.started=false;self.running=false;self.sequence=0;self.frame=0;self.attempt=1
end
function V:record(event,payload)
 self.sequence=self.sequence+1
 emit('{{"event":"'..quote(event)..'","sequence":'..self.sequence..',"frame":'..self.frame..fields(payload)..'}}')
end
function V:OnUpdate(gtime)self.frame=self.frame+1 end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/pmdred_eu_personality_quiz_flow.jsonl','w');if f then f:close() end
 self:record('BOOTSTRAP',{{context='personality_quiz_flow'}})
 RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:begin()
 if not self.enabled or self.started then return end
 self.started=true;self:record('ENTER_ZONE_REQUEST',{{context='personality_test'}})
 GAME:EnterZone('master_zone',-1,{zone_index},0)
end
function V:validate()
 local map=GAME:GetCurrentGround()
 if map==nil or map.AssetName~='personality_test' then error('personality_test Ground not loaded') end
 local hero=CH('PLAYER');if hero~=nil then GROUND:Hide(hero.EntName) end
 self:record('GROUND_ASSERTED',{{context='personality_test'}})
 local Flow=require 'halcyon.ground.personality_test.pmdred_quiz_flow'
 local question_draws={{0,4,9,12,16,20,24,28,3,7,11,15,19,23,27,31}}
 local tie_draws={{0,4}}
 local qidx=0;local tidx=0
 local function next_int(maximum,purpose)
  if purpose=='question' then qidx=qidx+1;return question_draws[qidx] end
  tidx=tidx+1;return tie_draws[tidx]
 end
 local function choose(prompt,choices,context)
  -- Exercise PMDO's real localized text renderer for every prompt and answer
  -- inventory while keeping the ignored fixture deterministic and inputless.
  UI:WaitShowVoiceOver(STRINGS:Format(prompt),8)
  for _,answer in ipairs(choices) do UI:WaitShowVoiceOver(STRINGS:Format(answer),4) end
  if context=='question:brave_2b' then return 2 end
  if context=='gender' then return self.attempt==1 and 3 or 2 end
  if context=='recommendation_confirmation' then
   if self.attempt==1 then self.attempt=2;return 2 end
   return 1
  end
  return 1
 end
 local options={{
  next_int=next_int,
  choose=choose,
  resolve_species_name=function(species)return '<'..species..'>' end,
  present_segment=function(text,context)
   UI:WaitShowVoiceOver(STRINGS:Format(text),8)
  end,
  on_action=function(event,payload)
   self:record(event,payload)
   if event=='QUIZ_RECOMMENDATION' then
    self:record('SCREENSHOT_REQUESTED',{{context='recommendation_'..tostring(self.attempt)}})
    _GROUND:Screenshot();GAME:WaitFrames(3)
    self:record('SCREENSHOT_COMPLETED',{{context='recommendation_'..tostring(self.attempt)}})
   end
  end,
 }}
 Flow.PlayCanonicalPrelude(options)
 local result=Flow.Run(options)
 if result.personality~='brave' then error('final restarted personality differs') end
 if result.gender_choice~=2 then error('final restarted gender differs') end
 if result.recommendation~='charmander' then error('final recommendation differs') end
 if qidx~=16 or tidx~=2 or self.attempt~=2 then error('restart timeline did not consume exact draws') end
 self:record('FLOW_RESULT_ASSERTED',{{personality=result.personality,choice=result.gender_choice,recommendation=result.recommendation}})
 local input={{'bulbasaur','charmander','squirtle'}}
 local output=Flow.PrioritizeRecommendation(input,'charmander')
 if #output~=#input or output[1]~='charmander' or output[2]~='bulbasaur' or output[3]~='squirtle' then
  error('New Era catalogue prioritization filtered or reordered incorrectly')
 end
 self:record('CATALOGUE_ASSERTED',{{context='move_never_filter',species=output[1]}})
 Flow.ShowPartnerPrompt(options)
 local nickname=Flow.PartnerNicknamePrompt()
 if nickname~='Quel sera le nom de votre\\npartenaire?' then error('partner nickname prompt drift') end
 self:record('PARTNER_NICKNAME_ASSERTED',{{context=nickname}})
 Flow.ShowEndText(options)
 Flow.FadeOutCanonical(options)
 self:record('FLOW_TIMELINE_COMPLETE',{{context='production_module_injected_choices'}})
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
 med:Subscribe('PmdRedEuPersonalityQuizFlowValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizFlowValidator',EngineServiceEvents.Update,function(_,gtime)self.OnUpdate(self,gtime)end)
 med:Subscribe('PmdRedEuPersonalityQuizFlowValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizFlowValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuPersonalityQuizFlowValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuPersonalityQuizFlowValidator',V:new())
return V
"""


def build(output: Path) -> Path:
    quest = BASE.build(output)
    # Parse/load the tracked production module in PMDO while suppressing only
    # its fixture-local automatic entry coroutine. The tracked file is never
    # edited by the builder.
    production_init_path = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"
    production_init = production_init_path.read_text(encoding="utf-8")
    entry = "function personality_test.Enter(map)\n\n\tpersonality_test.PlotScripting()\n\nend"
    inert_entry = "function personality_test.Enter(map)\n\n\t-- ignored fixture: service drives the tracked quiz flow\n\nend"
    if production_init.count(entry) != 1:
        raise ValueError("tracked personality_test Enter callback shape drift")
    fixture_init = quest / "Data/Script/halcyon/ground/personality_test/init.lua"
    fixture_init.write_text(production_init.replace(entry, inert_entry), encoding="utf-8")

    zone = BASE.read_json(ROOT / "Data/Zone/master_zone.json")
    zone_index = zone["Object"]["GroundMaps"].index("personality_test")
    service = quest / "Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    service.write_text(service_script(zone_index), encoding="utf-8")
    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    manifest["schema"] = "new-era.pmdred-eu-personality-quiz-flow-runtime-fixture.v1"
    manifest["scope"] = (
        "tracked personality_test Ground and production quiz flow with injected deterministic choices; no alternate route"
    )
    flow = "Data/Script/halcyon/ground/personality_test/pmdred_quiz_flow.lua"
    production_init = "Data/Script/halcyon/ground/personality_test/init.lua"
    manifest["tracked_hashes"][flow] = sha256_file(ROOT / flow)
    manifest["tracked_hashes"][production_init] = sha256_file(ROOT / production_init)
    manifest["production_init_fixture_adaptation"] = "exact tracked file with Enter callback made inert fixture-locally"
    manifest["choice_mode"] = "injected fixture choices; real PMDO text rendering; interactive menu input remains a separate gate"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/pmdred-eu-personality-quiz-flow-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
