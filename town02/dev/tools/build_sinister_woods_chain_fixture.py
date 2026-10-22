#!/usr/bin/env python3
"""Build an ignored PMDO fixture for the Sinister Woods chapter-6 chain.

This fixture exercises the actual New Era Grounds and the PMDO zone/map route
without touching protected chapters 1-5, the direct D04P01/D04P02 assets, or
production indexes.  It is a staging/runtime probe: it enters the chapter-6
entry Ground, the procedural segments, the mini-boss map, the D04P02 clearing
Ground and the boss map in order.  It does not mark the narrative chain
complete; the probe records every transition and forbidden runtime diagnostic.
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

import importlib.util
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_sinister_woods_procedural_fixture.py"
SPEC = importlib.util.spec_from_file_location("sinister_procedural_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)
RUNTIME = BASE.BASE

GROUND_IDS = (
    "gloomy_forest_entrance",
    "gloomy_forest_midpoint",
    "gloomy_forest_miniboss",
    "sinister_woods_clearing",
)
MAP_IDS = (
    "gloomy_forest_miniboss",
    "gloomy_forest_boss",
)
TILE_SHEETS = (
    "gloomy_forest_boss_Base",
    "Arena_gloomy_forest_boss_Base",
    "gloomy_forest_boss_Canonical_Final_Render",
    # Midpoint/miniboss New Era Grounds intentionally keep the shared
    # Treeshroud material.  The procedural fixture excludes it by default to
    # prove Sinister Woods does not consume it, so this narrative fixture adds
    # the authenticated DumpAsset sheet only for those protected Grounds.
    "TreeshroudForest1",
)


def copy_tree_file(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.is_symlink() or target.exists():
        target.unlink()
    shutil.copy2(source, target)


def copy_ground_scripts(quest: Path) -> None:
    target_root = quest / "Data/Script/halcyon/ground"
    for ground_id in GROUND_IDS:
        source = ROOT / "Data/Script/halcyon/ground" / ground_id
        target = target_root / ground_id
        if target.is_symlink() or target.exists():
            shutil.rmtree(target) if target.is_dir() and not target.is_symlink() else target.unlink()
        shutil.copytree(source, target)


def install_custom_assets(quest: Path) -> None:
    for ground_id in GROUND_IDS:
        copy_tree_file(ROOT / "Data/Ground" / f"{ground_id}.rsground", quest / "Data/Ground" / f"{ground_id}.rsground")
    for map_id in MAP_IDS:
        copy_tree_file(ROOT / "Data/Map" / f"{map_id}.rsmap", quest / "Data/Map" / f"{map_id}.rsmap")

    tile_index = RUNTIME.read_tile_index(quest / "Content/Tile/index.idx")
    source_tile_index = RUNTIME.read_tile_index(ROOT / "Content/Tile/index.idx")
    for sheet in TILE_SHEETS:
        source = (
            ROOT / ".runtime-cache/DumpAsset/Content/Tile" / f"{sheet}.tile"
            if sheet == "TreeshroudForest1"
            else ROOT / "Content/Tile" / f"{sheet}.tile"
        )
        if not source.is_file():
            raise FileNotFoundError(source)
        copy_tree_file(source, quest / "Content/Tile" / source.name)
        tile_node, _ = RUNTIME.tile_node(source.read_bytes())
        tile_index[sheet] = tile_node
    RUNTIME.write_tile_index(quest / "Content/Tile/index.idx", tile_index)

    # The fixture-local Zone index already contains gloomy_forest.  The custom
    # map files are resolved by filename; no tracked production index is edited.
    copy_tree_file(ROOT / "Data/Zone/master_zone.json", quest / "Data/Zone/master_zone.json")


def install_probe(quest: Path) -> None:
    main_path = quest / "Data/Script/halcyon/main.lua"
    if main_path.is_symlink():
        main_path.unlink()
    source_main = ROOT / "Data/Script/halcyon/main.lua"
    main_path.write_text(source_main.read_text(encoding="utf-8") + "\nrequire 'halcyon.services.sinister_woods_chain_probe'\n", encoding="utf-8")
    service_path = quest / "Data/Script/halcyon/services/sinister_woods_chain_probe/init.lua"
    service_path.parent.mkdir(parents=True, exist_ok=True)
    service_path.write_text(
        r'''require 'origin.common'
require 'origin.services.baseservice'

local V=Class('SinisterWoodsChainProbe',BaseService)
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function emit(s)
  PrintInfo('[SINISTER_WOODS_CHAIN] '..s)
  local f=io.open('/tmp/sinister_woods_chain_probe.jsonl','a')
  if f then f:write(s.."\n");f:flush();f:close() end
end
local function quote(s)return tostring(s):gsub('\\','\\\\'):gsub('"','\\"') end
local function ground_name()
  return safe(function()return GAME:GetCurrentGround().AssetName end,'')
end
local function segment()
  return safe(function()return _ZONE.CurrentMapID.Segment end,-1)
end
local function map_id()
  return safe(function()return _ZONE.CurrentMapID.ID end,-1)
end
local GROUND_INDEX={
  gloomy_forest_entrance=45,
  gloomy_forest_midpoint=53,
  gloomy_forest_miniboss=61,
  sinister_woods_clearing=345,
}
local ORDER={
  {kind='ground',id='gloomy_forest_entrance'},
  {kind='dungeon',segment=0},
  {kind='ground',id='gloomy_forest_midpoint'},
  {kind='dungeon',segment=1},
  {kind='ground',id='gloomy_forest_miniboss'},
  {kind='dungeon',segment=2},
  {kind='ground',id='gloomy_forest_miniboss'},
  {kind='dungeon',segment=3},
  {kind='ground',id='sinister_woods_clearing'},
  {kind='dungeon',segment=4},
}
function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_SINISTER_WOODS_CHAIN_PROBE')=='1'
  self.index=0;self.busy=false;self.ground_seen={}
end
function V:install_input_replay()
  -- Chapter-6 scenes use real PMDO dialogue/choice waits.  Feed the engine
  -- physical Enter pulses through DiagManager so the fixture tests the real
  -- UI coroutine instead of replacing it with a stub.
  local ListType=luanet.import_type('System.Collections.Generic.List`1')
  local FrameInput=luanet.import_type('RogueEssence.FrameInput')
  local GamePadState=luanet.import_type('Microsoft.Xna.Framework.Input.GamePadState')
  local KeyboardState=luanet.import_type('Microsoft.Xna.Framework.Input.KeyboardState')
  local MouseState=luanet.import_type('Microsoft.Xna.Framework.Input.MouseState')
  local Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
  local Loc=luanet.import_type('RogueElements.Loc')
  local arr=LUA_ENGINE:MakeLuaArray(Keys,{Keys.Enter})
  local function confirm()
    return FrameInput(GamePadState(),KeyboardState(arr),MouseState(),true,false,true,Loc(0,0))
  end
  self.diag=luanet.import_type('RogueEssence.DiagManager').Instance
  self.replay=LUA_ENGINE:MakeGenericType(ListType,{FrameInput},{})
  for frame=1,12000 do
    if frame%90==0 then self.replay:Add(confirm()) else self.replay:Add(FrameInput()) end
  end
  self.diag.ActiveDebugReplay=self.replay
  self.diag.DebugReplayIndex=0
  emit('{"event":"input_replay","frames":'..self.replay.Count..',"pulse":"Enter/90"}')
end
function V:seed()
  SV.ChapterProgression.Chapter=6
  SV.Chapter6.MissionAccepted=true
  SV.Chapter6.MissionComplete=false
  SV.Chapter6.SinisterApproachSeen=true
  SV.Chapter6.DazzlingEntranceSeen=true
  SV.Chapter6.GloomyPlayedMidpointIntro=true
  SV.Chapter6.ChenipentFound=true
  SV.Chapter6.GloomyMiniBossSeen=true
  SV.Chapter6.GloomyMiniBossDefeated=true
  SV.Chapter6.FinishedGloomyForestIntro=true
  SV.GloomyForest.DiedPastCheckpoint=false
  emit('{"event":"bootstrap","chapter":6}')
end
function V:enter_next()
  self.index=self.index+1
  local item=ORDER[self.index]
  if not item then
    emit('{"event":"end","normal_unload_requested":true}')
    RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
    return
  end
  if item.kind=='ground' then
    emit('{"event":"enter_ground","id":"'..item.id..'"}')
    GAME:EnterZone('master_zone',-1,GROUND_INDEX[item.id],0)
  else
    emit('{"event":"enter_segment","segment":'..item.segment..'}')
    GAME:EnterZone('gloomy_forest',item.segment,0,0)
  end
end
function V:inspect_ground()
  local id=ground_name()
  local map=GAME:GetCurrentGround()
  local ok,err=xpcall(function()
    local w=safe(function()return map.Width end,-1);local h=safe(function()return map.Height end,-1)
    local hero=safe(function()return CH('PLAYER') end,nil)
    local x=safe(function()return hero.CharLoc.X end,-1);local y=safe(function()return hero.CharLoc.Y end,-1)
    emit('{"event":"ground","id":"'..quote(id)..'","width":'..w..',"height":'..h..',"hero_x":'..x..',"hero_y":'..y..'}')
  end,debug.traceback)
  if not ok then emit('{"event":"RUNTIME_FAIL","phase":"ground","error":"'..quote(err)..'"}') end
end
function V:inspect_map()
  local map=_ZONE.CurrentMap
  local w=safe(function()return map.Width end,-1);local h=safe(function()return map.Height end,-1)
  local music=safe(function()return map.Music end,'')
  local free=false;local blocked=false
  for x=0,w-1,1 do
    for y=0,h-1,1 do
      local b=map:TileBlocked(RogueElements.Loc(x,y))
      if b then blocked=true else free=true end
      if free and blocked then break end
    end
    if free and blocked then break end
  end
  emit('{"event":"map","segment":'..segment()..',"map_id":'..map_id()..',"width":'..w..',"height":'..h..',"music":"'..quote(music)..'","free_collision":'..tostring(free)..',"blocked_collision":'..tostring(blocked)..'}')
end
function V:advance()
  self.busy=false
  GAME:WaitFrames(10)
  self:enter_next()
end
function V:OnInit()
  if not self.enabled then return end
  local f=io.open('/tmp/sinister_woods_chain_probe.jsonl','w');if f then f:close() end
  self:install_input_replay()
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:OnNewGame()
  if not self.enabled then return end
  self:seed();self:enter_next()
end
function V:OnGroundMapEnter()
  if not self.enabled or self.busy then return end
  self.busy=true
  TASK:BranchCoroutine(function()
    local ok,err=xpcall(function()
      GAME:WaitFrames(40);self:inspect_ground();self:advance()
    end,debug.traceback)
    if not ok then emit('{"event":"RUNTIME_FAIL","phase":"ground_enter","error":"'..quote(err)..'"}');self.busy=false;self:enter_next() end
  end)
end
function V:OnDungeonMapInit()
  if not self.enabled or self.busy then return end
  self.busy=true
  TASK:BranchCoroutine(function()
    local ok,err=xpcall(function()
      GAME:WaitFrames(25);self:inspect_map();self:advance()
    end,debug.traceback)
    if not ok then emit('{"event":"RUNTIME_FAIL","phase":"dungeon_map","error":"'..quote(err)..'"}');self.busy=false;self:enter_next() end
  end)
end
function V:Subscribe(med)
  med:Subscribe('SinisterWoodsChainProbe',EngineServiceEvents.Init,function()self:OnInit()end)
  med:Subscribe('SinisterWoodsChainProbe',EngineServiceEvents.NewGame,function()self:OnNewGame()end)
  med:Subscribe('SinisterWoodsChainProbe',EngineServiceEvents.GroundMapEnter,function()self:OnGroundMapEnter()end)
  med:Subscribe('SinisterWoodsChainProbe',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('SinisterWoodsChainProbe',V:new())
return V
''', encoding="utf-8")


def build(output: Path, candidate: Path) -> Path:
    if output.exists():
        shutil.rmtree(output)
    quest = BASE.build(output, candidate)
    install_custom_assets(quest)
    copy_ground_scripts(quest)
    install_probe(quest)
    manifest = RUNTIME.read_json(output / "fixture_manifest.json")
    manifest.update({
        "schema":"new-era.pmdred-eu.sinister-woods-chain-runtime-fixture.v1",
        "scope":"entry Ground -> procedural segments 0/1/3 -> mini-boss map -> D04P02 clearing -> boss map",
        "ground_ids":list(GROUND_IDS),
        "map_ids":list(MAP_IDS),
        "production_assets_modified":False,
    })
    (output / "fixture_manifest.json").write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return quest


def main() -> int:
    import argparse
    parser=argparse.ArgumentParser()
    parser.add_argument('--candidate',type=Path,default=ROOT/'.runtime-cache/sinister-woods-b41-unique-candidate')
    parser.add_argument('--output',type=Path,default=ROOT/'.runtime-cache/sinister-woods-chain-fixture')
    args=parser.parse_args()
    candidate=args.candidate if args.candidate.is_absolute() else ROOT/args.candidate
    output=args.output if args.output.is_absolute() else ROOT/args.output
    print(build(output,candidate))
    return 0
if __name__=='__main__':raise SystemExit(main())
