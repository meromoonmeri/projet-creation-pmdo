#!/usr/bin/env python3
"""Build an ignored PMDO 0.8.12 runtime fixture for one BIBLIOTHEQUE pilot.

This is a narrow extension of Agent A's fixture architecture.  It imports the
same symlink overlays, local writable indexes, deterministic spawn/probe
selection and tile-index codec; it does not alter the protected PMD Red fixture,
Grounds, routes or validation evidence.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Any

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
sys.path.insert(0, str(REPO_ROOT / "tools"))

from build_pmdred_eu_runtime_fixture import (  # noqa: E402
    fixture_ground,
    overlay_children,
    overlay_data_root,
    read_json,
    read_tile_index,
    symlink,
    tile_node,
    write_json_bom,
    write_tile_index,
)

ASSET = "relict_map_012_pilot"
SHEET = ASSET + "_Base"
QUEST_NAME = "bibliotheque_relict_fixture"
EVENTS = "/tmp/bibliotheque_relict_map012_validator.jsonl"


def ground_script() -> str:
    return """-- Fixture ignorée; candidat BIBLIOTHEQUE et quête source intacts.
require 'origin.common'
local M = {}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def validator_script(zone_index: int, probes: dict[str, Any]) -> str:
    def lua_probe(value: dict[str, Any]) -> str:
        dx, dy = value["expected_delta"]
        return "{x=%d,y=%d,dir='%s',dx=%d,dy=%d}" % (
            value["x"], value["y"], value["direction"], dx, dy
        )

    successful = lua_probe(probes["successful"])
    blocked = lua_probe(probes["blocked"])
    return f"""-- Ignored BIBLIOTHEQUE PMDO runtime validator; no story integration.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('BibliothequeRelictValidator',BaseService)
local ITEM={{id='{ASSET}',zone='master_zone',idx={zone_index},success={successful},blocked={blocked}}}
local DIR={{Up=Direction.Up,Right=Direction.Right,Down=Direction.Down,Left=Direction.Left}}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[BIBLIOTHEQUE_RELICT_VALIDATOR] '..s)
 local f=io.open('{EVENTS}','a');if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='bibliotheque_relict_fixture'
 self.started=false;self.busy=false;self.capture_total=nil
end
function V:begin()
 if not self.enabled or self.started then return end
 local f=io.open('{EVENTS}','w');if f then f:close() end
 self.started=true
 emit('{{"event":"begin","count":1}}')
 GAME:EnterZone(ITEM.zone,-1,ITEM.idx,0)
end
local function movement(hero,p,blocked)
 GROUND:TeleportTo(hero,p.x,p.y,DIR[p.dir]);GAME:WaitFrames(1)
 local x=safe(function()return hero.Position.X end,-999999)
 local y=safe(function()return hero.Position.Y end,-999999)
 GROUND:MoveInDirection(hero,DIR[p.dir],8,false,1);GAME:WaitFrames(1)
 local nx=safe(function()return hero.Position.X end,-999998)
 local ny=safe(function()return hero.Position.Y end,-999998)
 local dx=nx-x;local dy=ny-y
 local pass=(blocked and dx==0 and dy==0) or ((not blocked) and dx==p.dx and dy==p.dy)
 emit(string.format('{{"event":"movement","kind":"%s","dx":%d,"dy":%d,"pass":%s}}',blocked and 'blocked' or 'successful',dx,dy,tostring(pass)))
 return pass
end
function V:screenshot(tick)
 self.capture_total=tick*120
 RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total
 emit(string.format('{{"event":"screenshot_requested","pmdo_tick":%d}}',tick))
 _GROUND:Screenshot();GAME:WaitFrames(2)
 self.capture_total=nil
 emit(string.format('{{"event":"screenshot_completed","pmdo_tick":%d}}',tick))
end
function V:validate_async()
 GAME:WaitFrames(8)
 local map=safe(function()return GAME:GetCurrentGround()end,nil)
 local hero=CH('PLAYER')
 if not map or not hero then error('map_or_hero_nil') end
 emit('{{"event":"ground_loaded","ground":"{ASSET}","load":"LOAD_PASS"}}')
 local success=movement(hero,ITEM.success,false)
 local blocked=movement(hero,ITEM.blocked,true)
 GROUND:TeleportTo(hero,ITEM.success.x,ITEM.success.y,Direction.Down);GAME:WaitFrames(2)
 self:screenshot(0);self:screenshot(15)
 local verdict=(success and blocked) and 'RUNTIME_PASS' or 'RUNTIME_FAIL'
 emit('{{"event":"result","load":"LOAD_PASS","movement":"'..((success and blocked) and 'PASS' or 'FAIL')..'","animation_samples":"PASS","verdict":"'..verdict..'"}}')
 emit('{{"event":"end"}}')
end
function V:OnUpdate()
 if self.capture_total~=nil then RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total end
end
function V:OnGroundMapEnter()
 if not self.enabled or self.busy then return end
 self.busy=true
 TASK:BranchCoroutine(function()
  local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
  if not ok then emit('{{"event":"result","verdict":"RUNTIME_FAIL","error":"'..quote(err)..'"}}');emit('{{"event":"end"}}') end
 end)
end
function V:OnInit()
 if self.enabled then
  emit('{{"event":"bootstrap_new_game"}}')
  RogueEssence.GameManager.Instance:NewGamePlus(12012)
 end
end
function V:Subscribe(med)
 med:Subscribe('BibliothequeRelictValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
 med:Subscribe('BibliothequeRelictValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('BibliothequeRelictValidator',EngineServiceEvents.NewGame,function()self.begin(self)end)
 med:Subscribe('BibliothequeRelictValidator',EngineServiceEvents.LoadSavedData,function()self.begin(self)end)
 med:Subscribe('BibliothequeRelictValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('BibliothequeRelictValidator',V:new())
return V
"""


def build(root: Path, candidate: Path, output: Path) -> dict[str, Any]:
    ground_source = candidate / f"Data/Ground/{ASSET}.rsground"
    tile_source = candidate / f"Content/Tile/{SHEET}.tile"
    if not ground_source.is_file() or not tile_source.is_file():
        raise ValueError("staged BIBLIOTHEQUE pilot candidate is incomplete")
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    quest = output / "quest"

    symlink(root / "Mod.xml", quest / "Mod.xml")
    symlink(root / "Strings", quest / "Strings")
    overlay_data_root(root / "Data", quest / "Data", {"Ground", "Zone", "Script", "Misc"})
    shutil.copytree(root / "Data/Misc", quest / "Data/Misc")
    overlay_children(root / "Data/Ground", quest / "Data/Ground", {f"{ASSET}.rsground"})
    (quest / "Data/Zone").mkdir(parents=True)
    overlay_children(root / "Data/Script", quest / "Data/Script", {"halcyon"})
    overlay_children(root / "Data/Script/halcyon", quest / "Data/Script/halcyon", {"ground", "services"})
    overlay_children(root / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground", {ASSET})
    overlay_children(
        root / "Data/Script/halcyon/services",
        quest / "Data/Script/halcyon/services",
        {"ground_gameplay_validator"},
    )

    overlay_children(root / "Content", quest / "Content", {"Tile"})
    overlay_children(root / "Content/Tile", quest / "Content/Tile", {f"{SHEET}.tile", "index.idx"})

    spawn = fixture_ground(ground_source, quest / "Data/Ground" / ground_source.name)
    symlink(tile_source, quest / "Content/Tile" / tile_source.name)
    tile_payload = tile_source.read_bytes()
    node, node_end = tile_node(tile_payload)
    if tile_payload[node_end + 8 : node_end + 16] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("pilot tile package has no PNG payload after index node")
    tile_nodes = read_tile_index(root / "Content/Tile/index.idx")
    tile_nodes[SHEET] = node
    write_tile_index(quest / "Content/Tile/index.idx", tile_nodes)
    if read_tile_index(quest / "Content/Tile/index.idx") != tile_nodes:
        raise ValueError("fixture tile index round-trip failed")

    zone = read_json(root / "Data/Zone/master_zone.json")
    ground_maps = zone["Object"]["GroundMaps"]
    if ASSET not in ground_maps:
        ground_maps.append(ASSET)
    zone_index = ground_maps.index(ASSET)
    write_json_bom(quest / "Data/Zone/master_zone.json", zone)

    script_dir = quest / f"Data/Script/halcyon/ground/{ASSET}"
    script_dir.mkdir(parents=True)
    (script_dir / "init.lua").write_text(ground_script(), encoding="utf-8")
    # halcyon/main.lua already requires this opt-in Agent A service slot.
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    (service_dir / "init.lua").write_text(
        validator_script(zone_index, spawn["movement_probes"]), encoding="utf-8"
    )

    asset_root = output / "asset"
    overlay_children(root / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    symlink(quest, appdata / f"MODS/{QUEST_NAME}")
    manifest = {
        "schema_version": "1.0.0",
        "kind": "ignored_agent_a_overlay_extension",
        "quest_name": QUEST_NAME,
        "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep,
        "candidate": str(candidate),
        "asset": ASSET,
        "sheet": SHEET,
        "zone_index": zone_index,
        "spawn": spawn,
        "events": EVENTS,
    }
    (output / "fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--candidate", type=Path,
        default=WORKSPACE / "games/relict/conversion/pmdo_pilot/map_012",
    )
    parser.add_argument(
        "--output", type=Path,
        default=REPO_ROOT / ".runtime-cache/bibliotheque-relict-map012-fixture",
    )
    args = parser.parse_args()
    manifest = build(REPO_ROOT, args.candidate.resolve(), args.output.resolve())
    print(json.dumps(manifest, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
