#!/usr/bin/env python3
"""Build an ignored PMDO fixture for an isolated PMD Red EU narrative slice.

The fixture reuses Agent A's symlink-overlay and writable-index separation.  It
never converts or copies over a certified Ground.  Current Ground/tile assets
are exposed read-only, while only the fixture service and PMDO indexes are local.
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


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def service_script(zone_index: int) -> str:
    return f"""-- Generated ignored fixture service for PMD Red EU s01.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuNarrativeS01Validator',BaseService)
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_NARRATIVE] '..s)
 local f=io.open('/tmp/pmdred_eu_narrative_s01.jsonl','a')
 if f then f:write(s..'\\n');f:flush();f:close() end
end
local function payload_fields(payload)
 local fields=''
 if payload==nil then return fields end
 for _,key in ipairs({{'scene','scope','asset','key','page','page_key','page_count','cue','group','sector','actor_count','adaptation','id','source_opcode','complete','dependency','error'}}) do
  local value=payload[key]
  if value~=nil then
   if type(value)=='number' then fields=fields..',"'..key..'":'..tostring(value)
   elseif type(value)=='boolean' then fields=fields..',"'..key..'":'..tostring(value)
   else fields=fields..',"'..key..'":"'..quote(value)..'"' end
  end
 end
 return fields
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_NARRATIVE_VALIDATOR')=='pmdred_eu_s01'
 self.started=false;self.running=false;self.sequence=0;self.frame=0
end
function V:record(event,payload)
 self.sequence=self.sequence+1
 emit('{{"event":"'..quote(event)..'","sequence":'..self.sequence..',"frame":'..self.frame..payload_fields(payload)..'}}')
end
function V:OnUpdate(gtime)self.frame=self.frame+1 end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/pmdred_eu_narrative_s01.jsonl','w');if f then f:close() end
 self:record('BOOTSTRAP',{{fixture='pmdred_eu_s01'}})
 RogueEssence.GameManager.Instance:NewGamePlus(424242)
end
function V:begin()
 if not self.enabled or self.started then return end
 self.started=true
 self:record('ENTER_ZONE_REQUEST',{{asset='s01'}})
 GAME:EnterZone('master_zone',-1,{zone_index},0)
end
function V:OnGroundMapEnter()
 if not self.enabled or self.running then return end
 local map=GAME:GetCurrentGround()
 if map==nil or map.AssetName~='s01' then return end
 self.running=true
 TASK:BranchCoroutine(function()
  local ok,result=xpcall(function()
   local scene=require 'halcyon.pmdred_eu.scene.s01'
   return scene.ReplayPrelude({{
    auto_advance_frames=24,
    capture_delay_frames=6,
    validation_cleanup=true,
    on_action=function(event,payload) self:record(event,payload) end,
    on_page_present=function(key,page,page_key)
     self:record('SCREENSHOT_REQUESTED',{{key=key,page=page,page_key=page_key}})
     _GROUND:Screenshot()
     GAME:WaitFrames(4)
     self:record('SCREENSHOT_COMPLETED',{{key=key,page=page,page_key=page_key}})
    end,
   }})
  end,debug.traceback)
  if not ok then
   self:record('RUNTIME_FAIL',{{error=result}})
  else
   self:record('RUNTIME_RESULT',result)
  end
  self:record('end',{{normal_unload_requested=true}})
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
 end)
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuNarrativeS01Validator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuNarrativeS01Validator',EngineServiceEvents.Update,function(_,gtime)self.OnUpdate(self,gtime)end)
 med:Subscribe('PmdRedEuNarrativeS01Validator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuNarrativeS01Validator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuNarrativeS01Validator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuNarrativeS01Validator',V:new())
return V
"""


def build(output: Path) -> Path:
    root = ROOT
    guard = read_json(root / "docs/pmdred_eu/narrative_migration/protected_baseline.json")
    authority = read_json(root / "docs/pmdred_eu/narrative_migration/scenes/s01/authority.json")
    ground_path = root / authority["immutable_ground"]["ground"]
    tile_path = root / authority["immutable_ground"]["tile"]
    if sha256_file(ground_path) != authority["immutable_ground"]["ground_sha256"]:
        raise ValueError("immutable s01 Ground drift")
    if sha256_file(tile_path) != authority["immutable_ground"]["tile_sha256"]:
        raise ValueError("immutable s01 tile drift")

    if output.exists():
        shutil.rmtree(output)
    quest = output / "quest"
    output.mkdir(parents=True)

    GROUND_FIXTURE.symlink(root / "Mod.xml", quest / "Mod.xml")
    GROUND_FIXTURE.symlink(root / "Strings", quest / "Strings")

    # Every mutable PMDO index is copied. Asset payloads, including all
    # certified Grounds and tiles, remain symlinks to the read-only source.
    GROUND_FIXTURE.overlay_data_root(
        root / "Data", quest / "Data", {"Script", "Misc", "Zone"}
    )
    shutil.copytree(root / "Data/Misc", quest / "Data/Misc")
    # PMDO 0.8.12 cannot deserialize a few unrelated legacy zones while
    # indexing. Keep the fixture deliberately sparse, exactly like Agent A's
    # Ground fixture: only master_zone is required for the isolated replay.
    zone_dir = quest / "Data/Zone"
    zone_dir.mkdir(parents=True)
    GROUND_FIXTURE.symlink(root / "Data/Zone/master_zone.json", zone_dir / "master_zone.json")
    GROUND_FIXTURE.overlay_children(root / "Data/Script", quest / "Data/Script", {"halcyon"})
    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon", quest / "Data/Script/halcyon", {"services"}
    )
    GROUND_FIXTURE.overlay_children(
        root / "Data/Script/halcyon/services",
        quest / "Data/Script/halcyon/services",
        {"ground_gameplay_validator"},
    )
    # main.lua already requires this opt-in service slot. Override only inside
    # the ignored fixture; the tracked validator and main.lua remain untouched.
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)

    zone = read_json(root / "Data/Zone/master_zone.json")
    maps = zone["Object"]["GroundMaps"]
    if maps.count("s01") != 1:
        raise ValueError("master_zone must contain s01 exactly once")
    zone_index = maps.index("s01")
    (service_dir / "init.lua").write_text(service_script(zone_index), encoding="utf-8")

    GROUND_FIXTURE.overlay_data_tree(root / "Content", quest / "Content")

    asset_root = output / "asset"
    GROUND_FIXTURE.overlay_children(root / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    GROUND_FIXTURE.symlink(quest, appdata / "MODS/pmdred_eu_narrative_fixture")

    copied_indexes = sorted(path.relative_to(quest).as_posix() for path in quest.rglob("index.idx") if not path.is_symlink())
    exposed_indexes = sorted(path.relative_to(quest).as_posix() for path in quest.rglob("index.idx") if path.is_symlink())
    if exposed_indexes:
        raise ValueError(f"fixture exposes writable source indexes: {exposed_indexes}")

    manifest = {
        "schema": "new-era.pmdred-eu-narrative-runtime-fixture.v1",
        "scene": "s01",
        "scope": "isolated portal prelude; no route registration",
        "quest": str(quest),
        "quest_name": "pmdred_eu_narrative_fixture",
        "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep,
        "zone": "master_zone",
        "zone_index": zone_index,
        "immutable_ground": authority["immutable_ground"],
        "protected_baseline_sha256": sha256_file(root / "docs/pmdred_eu/narrative_migration/protected_baseline.json"),
        "authority_sha256": sha256_file(root / "docs/pmdred_eu/narrative_migration/scenes/s01/authority.json"),
        "scene_script_sha256": sha256_file(root / "Data/Script/halcyon/pmdred_eu/scene/s01.lua"),
        "scene_player_sha256": sha256_file(root / "Data/Script/halcyon/pmdred_eu/ScenePlayer.lua"),
        "french_strings_sha256": sha256_file(root / "Data/Script/halcyon/pmdred_eu/strings.fr.resx"),
        "french_runtime_texts_sha256": sha256_file(root / "Data/Script/halcyon/pmdred_eu/FrenchText.lua"),
        "fixture_local_indexes": copied_indexes,
        "source_index_symlinks": exposed_indexes,
    }
    (output / "fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(".runtime-cache/pmdred-eu-narrative-s01-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
