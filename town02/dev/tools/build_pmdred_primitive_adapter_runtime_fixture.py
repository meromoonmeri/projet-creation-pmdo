#!/usr/bin/env python3
"""Build an ignored exact-PMDO fixture for canonical primitive adapters.

The fixture reuses Agent A's PMDO 0.8.12 overlay builder and enters only its
synthetic validation sink.  It never loads or revalidates a certified Ground.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
ROGUE_COMMIT = "4961b2271bb0cace74f40f6a85e799e8e4848ace"

SERVICE = r'''-- Ignored exact-PMDO fixture; does not route or mutate production content.
require 'origin.common'
require 'origin.services.baseservice'
local A=require 'halcyon.pmdred_eu.CanonicalPrimitiveAdapters'
local V=Class('PmdRedPrimitiveAdapterValidator',BaseService)
local EVENTS='/tmp/pmdred_primitive_adapter_validator.jsonl'
local SINK={zone='master_zone',idx=232}
local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n',' | ')end
local function emit(s)
  PrintInfo('[PMDRED_PRIMITIVE_ADAPTER] '..s)
  local f=io.open(EVENTS,'a');if f then f:write(s..'\n');f:flush();f:close() end
end
function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_PRIMITIVE_ADAPTER_VALIDATOR')=='pmdred_eu_exact_0812'
  self.pending=false
  self.busy=false
  self.update_count=0
  if self.enabled then local f=io.open(EVENTS,'w');if f then f:close() end end
end
function V:validate_async()
  emit('{"event":"module_loaded","pret_commit":"'..A.AUTHORITY.pret_commit..'","rogue_essence_commit":"'..A.AUTHORITY.rogue_essence_commit..'"}')
  assert(A.AUTHORITY.pret_commit=='bf0092d0e34fd8e49b859a0b5f96f00740faa42d')
  assert(A.AUTHORITY.rogue_essence_commit=='4961b2271bb0cace74f40f6a85e799e8e4848ace')
  local tick_before=tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)
  local updates_before=self.update_count
  A.Execute('WAIT',{frames=3},{})
  local tick_after=tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)
  local update_delta=self.update_count-updates_before
  emit(string.format('{"event":"wait_pass","frames":3,"service_update_delta":%d,"tick_delta":%.0f}',update_delta,tick_after-tick_before))
  A.Execute('BGM_FADEOUT',{frames=5},{})
  emit('{"event":"bgm_fadeout_pass","frames":5}')
  local actor=RogueEssence.Ground.GroundChar(false)
  local dirs={
    {'DIRECTION_SOUTH',Direction.Down},
    {'DIRECTION_SOUTHEAST',Direction.DownRight},
    {'DIRECTION_EAST',Direction.Right},
    {'DIRECTION_NORTHEAST',Direction.UpRight},
    {'DIRECTION_NORTH',Direction.Up},
    {'DIRECTION_NORTHWEST',Direction.UpLeft},
    {'DIRECTION_WEST',Direction.Left},
    {'DIRECTION_SOUTHWEST',Direction.DownLeft},
  }
  for _,pair in ipairs(dirs) do
    A.Execute('SET_DIR_WAIT',{direction=pair[1],frames=0},{actor=actor})
    assert(actor.Direction==pair[2])
    emit('{"event":"direction_pass","source":"'..pair[1]..'","pmdo":"'..tostring(pair[2])..'"}')
  end
  local preserved=actor.Direction
  A.Execute('SET_DIR_WAIT',{direction=-1,frames=0},{actor=actor})
  assert(actor.Direction==preserved)
  local rotations={
    {'DIR_TRANS_SPINRIGHT1','DIRECTION_NORTH',Direction.Up},
    {'DIR_TRANS_SPINLEFT1','DIRECTION_EAST',Direction.Right},
    {'DIR_TRANS_10','DIRECTION_WEST',Direction.Left},
    {'DIR_TRANS_11','DIRECTION_NORTHEAST',Direction.UpRight},
  }
  for _,item in ipairs(rotations) do
    GROUND:EntTurn(actor,Direction.Down)
    A.Execute('ROTATE_TO',{step_frames=2,transition=item[1],direction=item[2]},{actor=actor})
    assert(actor.Direction==item[3])
    emit('{"event":"rotation_pass","transition":"'..item[1]..'","target":"'..item[2]..'"}')
  end
  local relative_rotations={
    {1,'DIR_TRANS_SPINRIGHT2',Direction.Left},
    {2,'DIR_TRANS_SPINLEFT2',Direction.Right},
    {2,'DIR_TRANS_FLIP',Direction.Up},
  }
  for _,item in ipairs(relative_rotations) do
    GROUND:EntTurn(actor,Direction.Down)
    A.Execute('CMD_UNK_92',{step_frames=2,turn_step=item[1],target_transform=item[2]},{actor=actor})
    assert(actor.Direction==item[3])
    emit('{"event":"relative_rotation_pass","turn_step":'..item[1]..',"target_transform":"'..item[2]..'"}')
  end
  local numeric_ok=pcall(function()A.ResolveDirection(2)end)
  local unknown_ok=pcall(function()A.Execute('RAW_OPCODE_0X62',{}, {})end)
  local missing_actor_ok=pcall(function()A.Execute('SET_DIR_WAIT',{direction='DIRECTION_NORTH',frames=0},{})end)
  local rotation_ok=pcall(function()A.Execute('ROTATE_TO',{step_frames=2,transition='DIR_TRANS_RAND',direction='DIRECTION_NORTH'},{actor=actor})end)
  local relative_ok=pcall(function()A.Execute('CMD_UNK_92',{step_frames=2,turn_step=1,target_transform='DIR_TRANS_RAND'},{actor=actor})end)
  assert(not numeric_ok and not unknown_ok and not missing_actor_ok and not rotation_ok and not relative_ok)
  emit('{"event":"fail_closed_pass","numeric_direction":true,"unknown_opcode":true,"missing_actor":true,"unsupported_rotation":true,"unsupported_relative_rotation":true}')
end
function V:begin()
  if not self.enabled or self.started then return end
  self.started=true
  emit('{"event":"begin","runtime":"PMDO 0.8.12","ground_loaded":"fixture_sink_only"}')
  GAME:EnterZone(SINK.zone,-1,SINK.idx,0)
end
function V:OnInit()
  if self.enabled then RogueEssence.GameManager.Instance:NewGamePlus(424242) end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:OnGroundMapEnter()
  if self.enabled and not self.busy then self.pending=true end
end
function V:OnUpdate()
  if self.enabled then self.update_count=self.update_count+1 end
end
function V:OnMapUpdate()
  if not self.enabled or not self.pending or self.busy then return end
  self.pending=false;self.busy=true
  local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
  if ok then
    emit('{"event":"end","verdict":"PASS","ground_loaded":"fixture_sink_only","production_route_written":false}')
  else
    emit('{"event":"end","verdict":"FAIL","error":"'..quote(err)..'"}')
  end
end
function V:Subscribe(med)
  med:Subscribe('PmdRedPrimitiveAdapterValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
  med:Subscribe('PmdRedPrimitiveAdapterValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('PmdRedPrimitiveAdapterValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('PmdRedPrimitiveAdapterValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
  med:Subscribe('PmdRedPrimitiveAdapterValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
PMDRED_PRIMITIVE_ADAPTER_VALIDATOR_INSTANCE=V:new()
SCRIPT:AddService('PmdRedPrimitiveAdapterValidator',PMDRED_PRIMITIVE_ADAPTER_VALIDATOR_INSTANCE)
return V
'''

SINK = r'''-- Ignored fixture sink used only to provide a managed Ground map coroutine.
local M = {}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map) end
function M.Update(map)
  if PMDRED_PRIMITIVE_ADAPTER_VALIDATOR_INSTANCE then
    PMDRED_PRIMITIVE_ADAPTER_VALIDATOR_INSTANCE:OnMapUpdate()
  end
end
function M.Exit(map) end
return M
'''


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--plan", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise FileExistsError(f"create-only fixture already exists: {args.output}")
    if not MODULE.is_file():
        raise FileNotFoundError(MODULE)
    subprocess.run([
        sys.executable, str(ROOT / "tools/build_pmdred_eu_runtime_fixture.py"),
        "--conversion-set", "remaining",
        "--candidate-root", str(args.candidate_root),
        "--plan", str(args.plan),
        "--ids", "t01p07",
        "--output", str(args.output),
    ], cwd=ROOT, check=True)

    service_path = args.output / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    sink_path = args.output / "quest/Data/Script/halcyon/ground/pmdred_eu_validation_sink/init.lua"
    service_path.write_text(SERVICE, encoding="utf-8")
    sink_path.write_text(SINK, encoding="utf-8")
    manifest = {
        "schema": "new-era.pmdred-eu-primitive-adapter-runtime-fixture.v1",
        "runtime": "PMDO 0.8.12",
        "production_module": "Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua",
        "production_module_sha256": digest(MODULE.read_bytes()),
        "pret_commit": PRET_COMMIT,
        "rogue_essence_commit": ROGUE_COMMIT,
        "base_fixture_builder": "tools/build_pmdred_eu_runtime_fixture.py",
        "base_fixture_candidate": "t01p07",
        "base_fixture_candidate_loaded": False,
        "executed_ground": "pmdred_eu_validation_sink",
        "executed_ground_kind": "IGNORED_SYNTHETIC_FIXTURE_ONLY",
        "certified_ground_revalidated": False,
        "production_route_written": False,
        "validator_service_sha256": digest(SERVICE.encode()),
        "sink_script_sha256": digest(SINK.encode()),
    }
    (args.output / "primitive_adapter_fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(manifest, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
