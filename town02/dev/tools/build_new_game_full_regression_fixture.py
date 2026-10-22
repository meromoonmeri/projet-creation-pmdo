#!/usr/bin/env python3
"""Build an ignored fixture that drives the real title-screen New Game flow."""

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
BASE_PATH = ROOT / "tools/build_pmdred_eu_narrative_fixture.py"
SPEC = importlib.util.spec_from_file_location("narrative_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def service_script() -> str:
    return """-- Ignored true-title New Game validator using real FrameInput.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('NewGameFullRegressionValidator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function emit(s)
 PrintInfo('[NEW_GAME_FULL] '..s)
 local f=io.open('/tmp/new_game_full_regression.jsonl','a')
 if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self);self.enabled=os.getenv('PMDO_NEW_GAME_VALIDATOR')=='full_title_flow'
 self.sequence=0;self.frame=0;self.first_ground=nil;self.last_menu_identity=''
 self.relic_seen=false;self.pulse_count=0
end
function V:record(event,fields)
 self.sequence=self.sequence+1
 emit('{"event":"'..event..'","sequence":'..self.sequence..',"frame":'..self.frame..(fields or '')..'}')
end
function V:make_input(key)
 local FrameInput=luanet.import_type('RogueEssence.FrameInput')
 if key==nil then return FrameInput() end
 local GamePadState=luanet.import_type('Microsoft.Xna.Framework.Input.GamePadState')
 local KeyboardState=luanet.import_type('Microsoft.Xna.Framework.Input.KeyboardState')
 local MouseState=luanet.import_type('Microsoft.Xna.Framework.Input.MouseState')
 local Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
 local Loc=luanet.import_type('RogueElements.Loc')
 return FrameInput(GamePadState(),KeyboardState(LUA_ENGINE:MakeLuaArray(Keys,{key})),MouseState(),true,false,true,Loc(0,0))
end
function V:append_key(key,kind,delay)
 for _=1,delay do self.replay:Add(self:make_input(nil)) end
 self.replay:Add(self:make_input(key));self.replay:Add(self:make_input(nil))
 self.pulse_count=self.pulse_count+1
 self:record('FRAME_INPUT_QUEUED',',"kind":"'..kind..'","replay_count":'..self.replay.Count..',"replay_index":'..self.diag.DebugReplayIndex)
end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/new_game_full_regression.jsonl','w');if f then f:close() end
 local ListType=luanet.import_type('System.Collections.Generic.List`1')
 local FrameInput=luanet.import_type('RogueEssence.FrameInput')
 self.Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
 self.replay=LUA_ENGINE:MakeGenericType(ListType,{FrameInput},{})
 self.diag=luanet.import_type('RogueEssence.DiagManager').Instance
 for _=1,180 do self.replay:Add(FrameInput()) end
 self.replay:Add(self:make_input(self.Keys.Enter));self.replay:Add(FrameInput())
 self.diag.ActiveDebugReplay=self.replay;self.diag.DebugReplayIndex=0
 self:record('BOOTSTRAP',',"action":"physical_title_new_game","new_game_plus_direct":false,"enter_zone_override":false,"initial_replay_count":'..self.replay.Count)
end
function V:OnNewGame()
 if not self.enabled then return end
 local count=_DATA.Save.ActiveTeam.Players.Count
 local first=safe(function()return _DATA.Save.ActiveTeam.Players[0].BaseForm.Species end,'nil')
 self:record('NEW_GAME_EVENT',',"party_count":'..count..',"initial_species":"'..quote(first)..'","chapter":'..tostring(SV.ChapterProgression.Chapter)..',"pmdred_state_present":'..tostring(SV.PersonalityTest~=nil))
end
function V:OnGroundMapEnter()
 if not self.enabled then return end
 local map=GAME:GetCurrentGround();local asset=map and map.AssetName or 'nil'
 local count=safe(function()return _DATA.Save.ActiveTeam.Players.Count end,-1)
 local p0=safe(function()return _DATA.Save.ActiveTeam.Players[0].BaseForm.Species end,'nil')
 local p1=safe(function()return _DATA.Save.ActiveTeam.Players[1].BaseForm.Species end,'nil')
 if self.first_ground==nil then
  self.first_ground=asset
  self:record('FIRST_GROUND_ENTERED',',"asset":"'..quote(asset)..'","party_count":'..count..',"party_0":"'..quote(p0)..'","party_1":"'..quote(p1)..'","pmdred_state_present":'..tostring(SV.PersonalityTest~=nil))
 end
 if asset=='relic_forest' and not self.relic_seen then
  self.relic_seen=true
  TASK:BranchCoroutine(function()
   GAME:WaitFrames(12)
   local hero=CH('PLAYER');local mate=CH('Teammate1')
   local hs=safe(function()return hero.CurrentForm.Species end,'nil')
   local ms=safe(function()return mate.CurrentForm.Species end,'nil')
   local final_count=_DATA.Save.ActiveTeam.Players.Count
   local f0=safe(function()return _DATA.Save.ActiveTeam.Players[0].BaseForm.Species end,'nil')
   local f1=safe(function()return _DATA.Save.ActiveTeam.Players[1].BaseForm.Species end,'nil')
   self:record('NORMAL_STORY_GROUND_ENTERED',',"asset":"relic_forest","party_count":'..final_count..',"party_0":"'..quote(f0)..'","party_1":"'..quote(f1)..'","actor_player":"'..quote(hs)..'","actor_teammate":"'..quote(ms)..'","pmdred_state_present":'..tostring(SV.PersonalityTest~=nil)..',"chapter":'..tostring(SV.ChapterProgression.Chapter))
   if self.first_ground~='personality_test' then error('wrong first Ground: '..tostring(self.first_ground)) end
   if final_count~=2 or f0=='missingno' or f1=='missingno' or hs=='missingno' or ms=='missingno' then error('MissingNo or invalid final team') end
   if SV.PersonalityTest~=nil then error('premature PMD Red state') end
   _GROUND:Screenshot();GAME:WaitFrames(4)
   self:record('SCREENSHOT_COMPLETED',',"asset":"relic_forest"')
   self:record('STARTUP_ASSERTED',',"first_ground":"personality_test","story_ground":"relic_forest","missingno_visible":false,"pmdred_triggered":false')
   self:record('end',',"normal_unload_requested":true')
   RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
  end)
 end
end
function V:OnUpdate()
 if not self.enabled then return end;self.frame=self.frame+1
 if self.relic_seen then return end
 local manager=luanet.import_type('RogueEssence.Menu.MenuManager').Instance
 local menu_type='none';local menu_identity='none'
 if manager.MenuCount>0 then
  local menus=manager:SaveMenuState();local top=menus[menus.Count-1]
  menu_type=tostring(top:GetType().Name);menu_identity=tostring(top)
 end
 local changed=menu_identity~=self.last_menu_identity
 if changed then
  self.last_menu_identity=menu_identity
  self:record('MENU_OBSERVED',',"menu_type":"'..quote(menu_type)..'","menu_identity":"'..quote(menu_identity)..'"')
  -- Drop pulses intended for the previous menu before driving this one.
  local idx=self.diag.DebugReplayIndex
  if self.replay.Count>idx then self.replay:RemoveRange(idx,self.replay.Count-idx) end
 end
 local remaining=self.replay.Count-self.diag.DebugReplayIndex
 if menu_type=='none' or ((not changed) and remaining>=30) then return end
 local count=safe(function()return _DATA.Save.ActiveTeam.Players.Count end,-1)
 if string.find(menu_type,'ChooseMonsterMenu') and count==1 then
  self:append_key(self.Keys.Right,'partner_select_right',80)
  self:append_key(self.Keys.Enter,'partner_select_confirm',50)
 elseif string.find(menu_type,'TeamNameMenu') then
  self:append_key(self.Keys.A,'nickname_letter_a',80)
  self:append_key(self.Keys.Enter,'nickname_confirm',50)
 else
  self:append_key(self.Keys.Enter,'confirm_'..menu_type,80)
 end
 if self.pulse_count>60 then
  self:record('RUNTIME_FAIL',',"error":"input pulse safety limit"')
  self:record('end',',"normal_unload_requested":true')
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
 end
end
function V:Subscribe(med)
 med:Subscribe('NewGameFullRegressionValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('NewGameFullRegressionValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
 med:Subscribe('NewGameFullRegressionValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('NewGameFullRegressionValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('NewGameFullRegressionValidator',V:new())
return V
"""


def build(output: Path) -> Path:
    quest = BASE.build(output)
    service = quest / "Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    service.write_text(service_script(), encoding="utf-8")
    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    manifest.update({
        "schema": "new-era.new-game-full-regression-fixture.v1",
        "scope": "fresh appdata, physical title New Game, production StartParams/scripts, no direct NewGamePlus or EnterZone",
        "new_game_plus_direct": False,
        "enter_zone_override": False,
        "input_mode": "RogueEssence.DiagManager.ActiveDebugReplay with real Enter/Down FrameInput",
        "production_hashes": {
            path: sha256_file(ROOT / path)
            for path in (
                "Data/StartParams.xml",
                "Data/Zone/master_zone.json",
                "Data/Ground/personality_test.rsground",
                "Data/Script/halcyon/ground/personality_test/init.lua",
                "Data/Script/halcyon/scriptvars.lua",
                "Data/Script/halcyon/main.lua",
            )
        },
    })
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path(".runtime-cache/new-game-full-regression-fixture"))
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
