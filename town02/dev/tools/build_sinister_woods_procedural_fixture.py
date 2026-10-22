#!/usr/bin/env python3
"""Build an ignored PMDO fixture for the procedural Sinister Woods gate.

The fixture keeps production assets read-only.  It overlays only the current
Zone, the reconstructed ``deep_shadow`` MapStatus, the status index, the
Sinister Woods music, and an opt-in runtime probe.  No PNG, Ground, Relic
Forest blob, D04P01, or D04P02 asset is generated or replaced.
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
import importlib.util
import json
import os
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_runtime_fixture.py"
SPEC = importlib.util.spec_from_file_location("pmdred_runtime_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

SEGMENTS = (0, 1, 3)


def install_probe(quest: Path) -> None:
    main_path = quest / "Data/Script/halcyon/main.lua"
    if main_path.is_symlink():
        main_path.unlink()
    source_main = main_path if main_path.is_file() else ROOT / "Data/Script/halcyon/main.lua"
    main_path.write_text(
        source_main.read_text(encoding="utf-8")
        + "\nrequire 'halcyon.services.sinister_woods_procedural_probe'\n",
        encoding="utf-8",
    )
    probe_path = quest / "Data/Script/halcyon/services/sinister_woods_procedural_probe/init.lua"
    probe_path.parent.mkdir(parents=True, exist_ok=True)
    segments = ", ".join(str(segment) for segment in SEGMENTS)
    probe_path.write_text(
        f'''require 'origin.common'\n'''
        f'''require 'origin.services.baseservice'\n'''
        f'''local SEGMENTS={{ {segments} }}\n'''
        f'''local V=Class('SinisterWoodsProceduralProbe',BaseService)\n'''
        f'''local function emit(s)\n'''
        f'''  PrintInfo('[SINISTER_WOODS_PROBE] '..s)\n'''
        f'''  local f=io.open("/tmp/sinister_woods_procedural_probe.jsonl","a")\n'''
        f'''  if f then f:write(s.."\\n");f:flush();f:close() end\n'''
        f'''end\n'''
        f'''local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end\n'''
        f'''function V:initialize()\n'''
        f'''  BaseService.initialize(self)\n'''
        f'''  self.enabled=os.getenv("PMDO_SINISTER_WOODS_PROBE")=="1"\n'''
        f'''  self.startup_adapter=os.getenv("PMDO_SINISTER_WOODS_STARTUP_ADAPTER")=="1"\n'''
        f'''  self.index=0;self.entered=false;self.transitioning=false\n'''
        f'''end\n'''
        f'''function V:OnInit()\n'''
        f'''  if not self.enabled then return end\n'''
        f'''  local f=io.open("/tmp/sinister_woods_procedural_probe.jsonl","w");if f then f:close() end\n'''
        f'''  emit('{{"event":"bootstrap"}}')\n'''
        f'''  RogueEssence.GameManager.Instance:NewGamePlus(424242)\n'''
        f'''end\n'''
        f'''function V:enter_next()\n'''
        f'''  self.transitioning=false\n'''
        f'''  self.index=self.index+1\n'''
        f'''  if self.index>#SEGMENTS then\n'''
        f'''    emit('{{"event":"end","normal_unload_requested":true}}')\n'''
        f'''    RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload\n'''
        f'''  else\n'''
        f'''    local segment=SEGMENTS[self.index]\n'''
        f'''    emit('{{"event":"enter","segment":'..segment..'}}')\n'''
        f'''    GAME:EnterZone("gloomy_forest",segment,0,0)\n'''
        f'''  end\n'''
        f'''end\n'''
        f'''function V:inspect_map()\n'''
        f'''  GAME:WaitFrames(4)\n'''
        f'''  local map=_ZONE.CurrentMap\n'''
        f'''  assert(map~=nil,"CurrentMap absent")\n'''
        f'''  local hero=safe(function()return map.ActiveTeam.Leader end,nil)\n'''
        f'''  assert(hero~=nil,"ActiveTeam leader absent")\n'''
        f'''  local width=safe(function()return map.Width end,-1)\n'''
        f'''  local height=safe(function()return map.Height end,-1)\n'''
        f'''  local music=safe(function()return map.Music end,"")\n'''
        f'''  local setter=safe(function()return map.Status:ContainsKey("deep_shadow")end,false)\n'''
        f'''  local darkness=safe(function()return map.Status:ContainsKey("darkness")end,false)\n'''
        f'''  local dusk=safe(function()return map.Status:ContainsKey("dusk")end,false)\n'''
        f'''  local x=safe(function()return hero.CharLoc.X end,-1)\n'''
        f'''  local y=safe(function()return hero.CharLoc.Y end,-1)\n'''
        f'''  local free_probe=false;local blocked_probe=false\n'''
        f'''  for px=0,width-1,1 do\n'''
        f'''    for py=0,height-1,1 do\n'''
        f'''      local loc=RogueElements.Loc(px,py)\n'''
        f'''      local blocked=map:TileBlocked(loc)\n'''
        f'''      -- TileBlocked is the authoritative PMDO collision query.  PMDO may return an empty character proxy for an unoccupied generated tile, so GetCharAtLoc is not a second passability condition.\n'''
        f'''      if blocked then blocked_probe=true else free_probe=true end\n'''
        f'''      if free_probe and blocked_probe then break end\n'''
        f'''    end\n'''
        f'''    if free_probe and blocked_probe then break end\n'''
        f'''  end\n'''
        f'''  emit('{{"event":"map","segment":'..SEGMENTS[self.index]..',"width":'..width..',"height":'..height..',"music":"'..tostring(music)..'","deep_shadow_setter":'..tostring(setter)..',"darkness":'..tostring(darkness)..',"dusk":'..tostring(dusk)..',"free_collision_probe":'..tostring(free_probe)..',"blocked_collision_probe":'..tostring(blocked_probe)..'}}')\n'''
        f'''  _GROUND:Screenshot()\n'''
        f'''  GAME:WaitFrames(3)\n'''
        f'''  if self.startup_adapter then GAME:WaitFrames(18) end\n'''
        f'''  self.entered=false\n'''
        f'''  self:enter_next()\n'''
        f'''end\n'''
        f'''function V:OnNewGame()\n'''
        f'''  if self.enabled and not self.entered then self:enter_next() end\n'''
        f'''end\n'''
        f'''function V:OnDungeonMapInit()\n'''
        f'''  if not self.enabled or self.transitioning then return end\n'''
        f'''  if tostring(_ZONE.CurrentZoneID)~="gloomy_forest" then return end\n'''
        f'''  self.entered=true\n'''
        f'''  TASK:BranchCoroutine(function()\n'''
        f'''    local ok,err=xpcall(function()self:inspect_map()end,debug.traceback)\n'''
        f'''    if not ok then emit('{{"event":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\\\"')..'"}}');RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload end\n'''
        f'''  end)\n'''
        f'''end\n'''
        f'''function V:Subscribe(med)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.Init,function()self:OnInit()end)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.NewGame,function()self:OnNewGame()end)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)\n'''
        f'''end\n'''
        f'''function V:UnSubscribe(med)end\n'''
        f'''SCRIPT:AddService("SinisterWoodsProceduralProbe",V:new())\n'''
        f'''return V\n''',
        encoding="utf-8",
    )


def install_startup_adapter(quest: Path, sheet_name: str, categories: list[str]) -> None:
    """Install the fixture-local exact one-shot CANM frame rotation adapter."""
    adapter = quest / "Data/Script/halcyon/services/sinister_woods_b41_startup_adapter/init.lua"
    adapter.parent.mkdir(parents=True, exist_ok=True)
    cats_lua = ",".join("'" + value + "'" for value in categories)
    fields = ('Tilex00','Tilex01','Tilex02','Tilex03','Tilex13','Tilex04','Tilex05','Tilex06','Tilex26','Tilex07','Tilex17','Tilex27','Tilex37','Tilex08','Tilex09','Tilex89','Tilex0A','Tilex0B','Tilex1B','Tilex8B','Tilex9B','Tilex0C','Tilex4C','Tilex0D','Tilex4D','Tilex8D','TilexCD','Tilex0E','Tilex2E','Tilex4E','Tilex6E','Tilex0F','Tilex1F','Tilex2F','Tilex3F','Tilex4F','Tilex5F','Tilex6F','Tilex7F','Tilex8F','Tilex9F','TilexAF','TilexBF','TilexCF','TilexDF','TilexEF','TilexFF')
    fields_lua = ",".join("'" + value + "'" for value in fields)
    adapter.write_text(f'''require 'origin.common'
require 'origin.services.baseservice'
local V=Class('SinisterWoodsB41StartupAdapter',BaseService)
local CATS={{{cats_lua}}}
local FIELDS={{{fields_lua}}}
local function each_layer(fn)
  for _,cat in ipairs(CATS) do
    local auto=_DATA:GetAutoTile(cat)
    for _,field in ipairs(FIELDS) do
      local variants=auto.Tiles[field]
      for vi=0,variants.Count-1,1 do
        local layers=variants[vi]
        for li=0,layers.Count-1,1 do fn(layers[li]) end
      end
    end
  end
end
local function frame(x,y)return RogueEssence.Dungeon.TileFrame(RogueElements.Loc(x,y),'{sheet_name}')end
local function clock()return tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)end
local function restore_raw_startup()
  local count=0
  each_layer(function(layer)
    if layer.Frames.Count==16 and (layer.FrameLength==8 or layer.FrameLength==12) then
      local first=layer.Frames[0]
      local x=first.TexLoc.X;local y=first.TexLoc.Y;local row=y%16
      local group=math.floor(y/16)
      local record=math.floor((group-15)/16)-1
      if record>=0 and record<16 then
        layer.Frames:RemoveAt(0)
        layer.Frames:Add(frame(x,((1+record)*16+15)*16+row))
        layer.Frames:Insert(0,frame(x,(17*16+record)*16+row))
        count=count+1
      end
    end
  end)
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] raw_startup_restored='..tostring(count)..' tick='..tostring(clock()))
end
local function publish_record(duration,origin)
  local count=0
  each_layer(function(layer)
    if layer.Frames.Count==17 and layer.FrameLength==duration then
      layer.Frames:RemoveAt(0)
      local last=layer.Frames[layer.Frames.Count-1]
      layer.Frames:RemoveAt(layer.Frames.Count-1)
      layer.Frames:Insert(0,last)
      count=count+1
    end
  end)
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] published_duration='..tostring(duration)..' layers='..tostring(count)..' tick='..tostring(clock())..' delta='..tostring(clock()-(origin or clock())))
end
function V:initialize()BaseService.initialize(self);self.enabled=os.getenv('PMDO_SINISTER_WOODS_PROBE')=='1';self.running=false end
function V:OnDungeonMapInit()
  if not self.enabled or tostring(_ZONE.CurrentZoneID)~='gloomy_forest' or self.running then return end
  self.running=true
  local origin=clock()
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] map_start_tick='..tostring(origin))
  TASK:BranchCoroutine(function()
    local ok,err=xpcall(function()
      restore_raw_startup()
      GAME:WaitFrames(8);publish_record(8,origin)
      GAME:WaitFrames(4);publish_record(12,origin)
    end,debug.traceback)
    if not ok then PrintInfo('[SINISTER_WOODS_B41_ADAPTER] FAIL '..tostring(err)) end
    self.running=false
  end)
end
function V:Subscribe(med)med:Subscribe('SinisterWoodsB41StartupAdapter',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)end
function V:UnSubscribe(med)end
SCRIPT:AddService('SinisterWoodsB41StartupAdapter',V:new())
return V
''', encoding="utf-8")


def prepare_content_overlay(asset_root: Path, candidate: Path | None, sheet_name: str) -> None:
    """Make Content writable in the fixture without ever mutating DumpAsset."""
    content = asset_root / "Content"
    if content.is_symlink():
        content.unlink()
    elif content.exists():
        shutil.rmtree(content)
    content.mkdir(parents=True)
    source_content = ROOT / ".runtime-cache/DumpAsset/Content"
    for child in source_content.iterdir():
        if child.name not in {"Tile", "Music"}:
            (content / child.name).symlink_to(child.resolve(), target_is_directory=child.is_dir())
    tile = content / "Tile"
    tile.mkdir()
    source_tile = source_content / "Tile"
    for child in source_tile.iterdir():
        if child.name not in {"index.idx", "TreeshroudForest1.tile", f"{sheet_name}.tile"}:
            (tile / child.name).symlink_to(child.resolve(), target_is_directory=child.is_dir())
    # Sinister Woods music is a project asset, not a DumpAsset base asset.
    music = content / "Music"
    music.mkdir()
    shutil.copy2(ROOT / "Content/Music/Sinister Woods.ogg", music / "Sinister Woods.ogg")
    source_index = source_tile / "index.idx"
    nodes = BASE.read_tile_index(source_index)
    if candidate is not None:
        candidate_tile = candidate / "Content/Tile" / f"{sheet_name}.tile"
        candidate_node, _ = BASE.tile_node(candidate_tile.read_bytes())
        nodes[sheet_name] = candidate_node
        shutil.copy2(candidate_tile, tile / f"{sheet_name}.tile")
    else:
        require_sheet = source_tile / f"{sheet_name}.tile"
        if not require_sheet.is_file():
            raise FileNotFoundError(require_sheet)
        (tile / f"{sheet_name}.tile").symlink_to(require_sheet.resolve())
    BASE.write_tile_index(tile / "index.idx", nodes)


def install_material_candidate(quest: Path, candidate: Path | None, auto_files: dict[str, str]) -> None:
    if candidate is None:
        return
    target = quest / "Data/AutoTile"
    target.mkdir(parents=True, exist_ok=True)
    for name in auto_files.values():
        shutil.copy2(candidate / "Data/AutoTile" / name, target / name)
    index = json.loads((ROOT / ".runtime-cache/DumpAsset/Data/AutoTile/index.idx").read_text(encoding="utf-8-sig"))
    entries = index["Object"]
    for name in auto_files.values():
        payload = json.loads((target / name).read_text(encoding="utf-8"))["Object"]
        auto_id = Path(name).stem
        entries[auto_id] = {
            "Name": payload["Name"],
            "Released": True,
            "Comment": payload.get("Comment", ""),
            "SortOrder": 0,
        }
    (target / "index.idx").write_text(json.dumps(index, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def build(output: Path, candidate: Path | None = None) -> Path:
    if output.exists():
        shutil.rmtree(output)
    # One direct Ground keeps the fixture builder's authenticated base small;
    # the probe enters gloomy_forest directly and does not use that Ground.
    quest = BASE.build(ROOT, output, conversion_set="direct", ids=["d01p02"])
    zone_dir = quest / "Data/Zone"
    zone_source = ROOT / "Data/Zone/gloomy_forest.json"
    shutil.copy2(zone_source, zone_dir / "gloomy_forest.json")
    # A PMDO mod must ship a fixture-local Zone index for a zone that is not
    # present in the DumpAsset base index.  Without this, the engine accepts
    # the JSON file but rejects GAME:EnterZone("gloomy_forest", ...) as an
    # invalid zone name.  Keep the base summaries intact and replace only the
    # canonical entry with the current serialized identity/Ground routing.
    zone_index = BASE.read_json(ROOT / "Data/Zone/index.idx")
    zone_object = json.loads(zone_source.read_text(encoding="utf-8-sig"))["Object"]
    if "gloomy_forest" not in zone_index.get("Object", {}):
        raise ValueError("source Data/Zone/index.idx has no gloomy_forest summary")
    summary = zone_index["Object"]["gloomy_forest"]
    summary["Name"] = zone_object["Name"]
    summary["Comment"] = zone_object.get("Comment", summary.get("Comment", ""))
    summary["Released"] = zone_object.get("Released", True)
    summary["Grounds"] = list(zone_object.get("GroundMaps", []))
    summary["Maps"] = []
    for segment in zone_object.get("Segments", []):
        floors = segment.get("Floors")
        if isinstance(floors, dict):
            summary["Maps"].append(list(range(len(floors.get("nodes", [])))))
        elif isinstance(floors, list):
            summary["Maps"].append([0])
        else:
            summary["Maps"].append([])
    summary["CountedFloors"] = sum(len(values) for values in summary["Maps"])
    BASE.write_json_bom(zone_dir / "index.idx", zone_index)
    # The map-status index is already copied by the base fixture.  Replace the
    # generated setter with a fixture-local copy so the runtime tests the exact
    # staged file rather than a source symlink.
    deep = quest / "Data/MapStatus/deep_shadow.json"
    if deep.is_symlink():
        deep.unlink()
    shutil.copy2(ROOT / "Data/MapStatus/deep_shadow.json", deep)
    startup_adapter = False
    sheet_name = "TreeshroudForest1"
    auto_files = {
        "floor": "treeshroud_forest_1_floor.json",
        "wall": "treeshroud_forest_1_wall.json",
        "secondary": "treeshroud_forest_1_secondary.json",
    }
    if candidate is not None:
        candidate_manifest = json.loads((candidate / "manifest.json").read_text(encoding="utf-8"))
        namespace = candidate_manifest.get("namespace", {})
        sheet_name = namespace.get("sheet", sheet_name)
        auto_files = namespace.get("autotile_files", auto_files)
        startup_adapter = bool(candidate_manifest.get("animation_adapter", {}).get("one_shot_startup_adapter", False))
    install_material_candidate(quest, candidate, auto_files)
    install_probe(quest)
    if startup_adapter:
        install_startup_adapter(quest, sheet_name, [Path(name).stem for name in auto_files.values()])
    prepare_content_overlay(output / "asset", candidate, sheet_name)
    manifest = json.loads((output / "fixture_manifest.json").read_text(encoding="utf-8"))
    manifest.update({
        "schema": "new-era.pmdred-eu.sinister-woods-procedural-runtime-fixture.v1",
        "scope": "gloomy_forest procedural segments 0, 1 and 3 at floor 0",
        "zone_source": "Data/Zone/gloomy_forest.json",
        "zone_sha256": __import__('hashlib').sha256((ROOT / "Data/Zone/gloomy_forest.json").read_bytes()).hexdigest(),
        "map_status_source": "Data/MapStatus/deep_shadow.json",
        "map_status_sha256": __import__('hashlib').sha256((ROOT / "Data/MapStatus/deep_shadow.json").read_bytes()).hexdigest(),
        "material_candidate": str(candidate.relative_to(ROOT)) if candidate is not None and candidate.is_relative_to(ROOT) else (str(candidate) if candidate is not None else None),
        "material_candidate_manifest_sha256": __import__('hashlib').sha256((candidate / "manifest.json").read_bytes()).hexdigest() if candidate is not None else None,
        "startup_adapter": startup_adapter,
        "material_sheet": sheet_name,
        "material_autotile_files": auto_files,
        "segments": list(SEGMENTS),
        "production_assets_modified": False,
    })
    (output / "fixture_manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path(".runtime-cache/sinister-woods-procedural-fixture"))
    parser.add_argument("--candidate", type=Path, help="optional staged b41 candidate to overlay")
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    candidate = None if args.candidate is None else (args.candidate if args.candidate.is_absolute() else ROOT / args.candidate)
    print(build(output, candidate))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
