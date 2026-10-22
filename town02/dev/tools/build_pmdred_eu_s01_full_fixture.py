#!/usr/bin/env python3
"""Build an ignored PMDO fixture for the complete opt-in s01 continuation."""
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
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_narrative_fixture.py"
SPEC = importlib.util.spec_from_file_location("s01_base_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def service_script(zone_index: int) -> str:
    return f'''require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuS01FullValidator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(self,event,payload)
 self.sequence=self.sequence+1
 local value='{{"event":"'..event..'","sequence":'..self.sequence..',"frame":'..self.frame
 if payload~=nil then value=value..payload end
 value=value..'}}'
 PrintInfo('[PMDRED_EU_S01_FULL] '..value)
 local f=io.open('/tmp/pmdred_eu_s01_full.jsonl','a');if f then f:write(value..'\\n');f:flush();f:close()end
end
local function field(name,value)
 if type(value)=='number' then return ',"'..name..'":'..tostring(value) end
 if type(value)=='boolean' then return ',"'..name..'":'..tostring(value) end
 return ',"'..name..'":"'..quote(value)..'"'
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_S01_FULL_VALIDATOR')=='1'
 self.started=false;self.running=false;self.sequence=0;self.frame=0;self.attempt=1;self.qidx=0;self.tidx=0
end
function V:OnUpdate()self.frame=self.frame+1 end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/pmdred_eu_s01_full.jsonl','w');if f then f:close()end
 emit(self,'BOOTSTRAP',field('scene','s01_full'))
 RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:begin()
 if not self.enabled or self.started then return end
 self.started=true
 emit(self,'ENTER_ZONE_REQUEST',field('asset','s01'))
 GAME:EnterZone('master_zone',-1,{zone_index},0)
end
function V:OnGroundMapEnter()
 if not self.enabled or self.running then return end
 local map=GAME:GetCurrentGround();if map==nil or map.AssetName~='s01' then return end
 self.running=true
 TASK:BranchCoroutine(function()
  local ok,result=xpcall(function()
   local scene=require 'halcyon.pmdred_eu.scene.s01'
   local draws={{0,4,9,12,16,20,24,28}}
   local function next_int(maximum,purpose)
    if purpose=='question' then
     self.qidx=self.qidx+1
     local value=draws[self.qidx]
     if value==nil then error('question draw overflow') end
     emit(self,'QUIZ_RNG',field('purpose',purpose)..field('maximum',maximum)..field('value',value))
     return value
    end
    self.tidx=self.tidx+1
    local value=0
    emit(self,'QUIZ_RNG',field('purpose',purpose)..field('maximum',maximum)..field('value',value))
    return value
   end
   local function present_segment(text,context)
    emit(self,'QUIZ_TEXT',field('context',context))
    UI:WaitShowVoiceOver(STRINGS:Format(text),3)
   end
   local function choose(prompt,choices,context)
    emit(self,'QUIZ_CHOICE',field('context',context)..field('choice_count',#choices))
    for _,choice in ipairs(choices) do UI:WaitShowVoiceOver(STRINGS:Format(choice),1) end
    if context=='gender' then return 2 end
    if context=='recommendation_confirmation' then return 1 end
    if context=='question:brave_2b' then return 2 end
    return 1
   end
   local function on_action(event,payload)
    local extra=''
    if payload~=nil then
     if payload.personality~=nil then extra=extra..field('personality',payload.personality) end
     if payload.recommendation~=nil then extra=extra..field('recommendation',payload.recommendation) end
     if payload.source_opcode~=nil then extra=extra..field('source_opcode',payload.source_opcode) end
     if payload.frames~=nil then extra=extra..field('frames',payload.frames) end
     if payload.complete~=nil then extra=extra..field('complete',payload.complete) end
     if payload.dependency~=nil then extra=extra..field('dependency',payload.dependency) end
    end
    emit(self,event,extra)
   end
   return scene.ReplayPrelude({{
    execute_personality_quiz=true,
    auto_advance_frames=3,
    capture_delay_frames=1,
    suppress_engine_presentation=false,
    validation_cleanup=true,
    next_int=next_int,
    present_segment=present_segment,
    choose=choose,
    resolve_species_name=function(species)return '<'..species..'>'end,
    on_action=on_action,
   }})
  end,debug.traceback)
  if not ok then emit(self,'RUNTIME_FAIL',field('error',result))
  else
   if result==nil or result.complete~=true or result.quiz==nil then error('s01 full result incomplete') end
   emit(self,'FULL_RESULT',field('personality',result.quiz.personality)..field('recommendation',result.quiz.recommendation)..field('complete',result.complete))
  end
  emit(self,'end',field('normal_unload_requested',true))
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
 end)
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuS01FullValidator',EngineServiceEvents.Init,function()self:OnInit()end)
 med:Subscribe('PmdRedEuS01FullValidator',EngineServiceEvents.Update,function()self:OnUpdate()end)
 med:Subscribe('PmdRedEuS01FullValidator',EngineServiceEvents.NewGame,function()self:OnNewGame()end)
 med:Subscribe('PmdRedEuS01FullValidator',EngineServiceEvents.LoadSavedData,function()self:OnLoadSavedData()end)
 med:Subscribe('PmdRedEuS01FullValidator',EngineServiceEvents.GroundMapEnter,function()self:OnGroundMapEnter()end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuS01FullValidator',V:new())
return V
'''


def build(output: Path) -> Path:
    if output.exists():
        shutil.rmtree(output)
    quest = BASE.build(output)
    service = quest / "Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    # master_zone contains the immutable s01 Ground used by the existing fixture.
    zone = json.loads((ROOT / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig"))['Object']
    zone_index = zone['GroundMaps'].index('s01')
    service.write_text(service_script(zone_index), encoding="utf-8")
    manifest = json.loads((output / "fixture_manifest.json").read_text(encoding="utf-8"))
    manifest.update({
        "schema": "new-era.pmdred-eu.s01-full-runtime-fixture.v1",
        "scope": "s01 exact EU prelude + opt-in integrated personality quiz; no New Era route registration",
        "scene": "s01",
        "full_continuation_opt_in": True,
        "authority_sha256": sha(ROOT / "docs/pmdred_eu/narrative_migration/scenes/s01/authority.json"),
        "scene_script_sha256": sha(ROOT / "Data/Script/halcyon/pmdred_eu/scene/s01.lua"),
    })
    (output / "fixture_manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return quest


def main() -> int:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=Path('.runtime-cache/pmdred-eu-s01-full-fixture'))
    args=parser.parse_args()
    output=args.output if args.output.is_absolute() else ROOT/args.output
    print(build(output));return 0

if __name__=='__main__':raise SystemExit(main())
