#!/usr/bin/env python3
"""Build an ignored PMDO 0.8.12 Ground-validation overlay.

The fixture supports both the 27 preserved direct candidates and the 219
archive-backed regenerated candidates.  It never edits the quest, RESERVE, or
candidate roots: untouched trees are symlinked while all Ground, tile-index,
zone, and script overrides remain fixture-local.  Deterministic walkable entry
markers, successful/blocked collision probes, and audit-only scripts are added
only to copied Grounds.
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
import copy
import hashlib
import json
import os
import shutil
import struct
from pathlib import Path
from typing import Any

DIRECT_CANDIDATES = (
    "d01p02", "d02p02", "d03p02", "d04p02", "d05p02", "d06p02", "d06p03",
    "d09p02", "d09p03", "d10p02", "d10p03", "d11p02", "d11p03", "d12p02",
    "d12p04", "d13p02", "d13p03", "d14p01", "d15p01", "d16p01", "d17p01",
    "d18p01", "d19p01", "d20p01", "d21p01", "d23p01", "d25p01",
)
DIRECT_SHEET_SUFFIX = "_DirectBase.tile"
REMAINING_SHEET_SUFFIX = "_Base.tile"
VALIDATION_SINK_ASSET = "pmdred_eu_validation_sink"
DIRECTION_DELTAS = (
    ("Up", 0, -1),
    ("Right", 1, 0),
    ("Down", 0, 1),
    ("Left", -1, 0),
)


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def write_json_bom(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\ufeff" + json.dumps(value, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


def validation_sink_payload(candidate: dict[str, Any]) -> dict[str, Any]:
    """Return an inert fixture sink without mutating or flattening its LocalText."""
    sink_payload = copy.deepcopy(candidate)
    sink_obj = sink_payload["Object"]
    sink_name = sink_obj.get("Name")
    if not isinstance(sink_name, dict) or not isinstance(sink_name.get("LocalTexts"), dict):
        raise ValueError("candidate Ground Name is not a serialized LocalText")
    sink_name["DefaultText"] = "PMD Red EU Runtime Validation Sink"
    sink_obj["AssetName"] = VALIDATION_SINK_ASSET
    sink_obj["Comment"] = "Fixture-local inert lifecycle sink; not a promotion candidate."
    return sink_payload


def verify_additive_entity_integration(
    integrated_path: Path,
    canonical_path: Path,
) -> dict[str, Any]:
    """Prove an integrated Ground only adds markers/spawners to a canonical one.

    Project scripts can depend on invisible markers or dormant spawn definitions.
    Such integration must survive canonical visual promotion, but the exception is
    deliberately narrow: every canonical byte-level value represented by JSON,
    including existing entities, must remain intact and in order.
    """
    integrated = read_json(integrated_path)
    canonical = read_json(canonical_path)
    integrated_layers = integrated.get("Object", {}).get("Entities")
    canonical_layers = canonical.get("Object", {}).get("Entities")
    if not isinstance(integrated_layers, list) or not isinstance(canonical_layers, list):
        raise ValueError("Ground entity integration requires serialized entity-layer lists")
    if len(integrated_layers) != len(canonical_layers):
        raise ValueError("Ground entity integration changed the entity-layer count")

    normalized = copy.deepcopy(integrated)
    normalized_layers = normalized["Object"]["Entities"]
    layer_evidence: list[dict[str, int]] = []
    added_total = 0
    for index, (candidate_layer, canonical_layer) in enumerate(
        zip(integrated_layers, canonical_layers, strict=True)
    ):
        for field in ("Markers", "Spawners"):
            candidate_entities = candidate_layer.get(field)
            canonical_entities = canonical_layer.get(field)
            if not isinstance(candidate_entities, list) or not isinstance(canonical_entities, list):
                raise ValueError(f"entity layer {index} has a non-list {field} value")
            if candidate_entities[:len(canonical_entities)] != canonical_entities:
                raise ValueError(
                    f"entity layer {index} changed or reordered canonical {field}"
                )
            normalized_layers[index][field] = copy.deepcopy(canonical_entities)
        added_markers = len(candidate_layer["Markers"]) - len(canonical_layer["Markers"])
        added_spawners = len(candidate_layer["Spawners"]) - len(canonical_layer["Spawners"])
        added_total += added_markers + added_spawners
        layer_evidence.append({
            "layer": index,
            "canonical_markers": len(canonical_layer["Markers"]),
            "integrated_markers": len(candidate_layer["Markers"]),
            "added_markers": added_markers,
            "canonical_spawners": len(canonical_layer["Spawners"]),
            "integrated_spawners": len(candidate_layer["Spawners"]),
            "added_spawners": added_spawners,
        })

    if normalized != canonical:
        raise ValueError(
            "Ground integration differs from canonical data outside additive Markers/Spawners"
        )
    if added_total == 0:
        raise ValueError("Ground entity-integration exception added no entities")
    return {
        "mode": "additive_markers_spawners_only",
        "canonical_ground": str(canonical_path),
        "canonical_ground_sha256": sha256_file(canonical_path),
        "integrated_ground_sha256": sha256_file(integrated_path),
        "layers": layer_evidence,
    }


def symlink(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    target.symlink_to(source.resolve(), target_is_directory=source.is_dir())


def overlay_children(source: Path, target: Path, excluded: set[str]) -> None:
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        if child.name not in excluded:
            symlink(child, target / child.name)


def overlay_data_tree(source: Path, target: Path) -> None:
    """Overlay one Data subtree while copying every recursively nested index."""
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        destination = target / child.name
        if child.is_file() and child.name == "index.idx":
            shutil.copy2(child, destination)
        elif child.is_dir() and any(child.rglob("index.idx")):
            overlay_data_tree(child, destination)
        else:
            symlink(child, destination)


def overlay_data_root(source: Path, target: Path, excluded: set[str]) -> None:
    """Overlay Data while keeping every writable type index fixture-local."""
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        if child.name in excluded:
            continue
        destination = target / child.name
        if child.is_dir():
            overlay_data_tree(child, destination)
        elif child.name == "index.idx":
            shutil.copy2(child, destination)
        else:
            symlink(child, destination)


def read_7bit_int(data: bytes, offset: int) -> tuple[int, int]:
    value = 0
    shift = 0
    while True:
        if offset >= len(data) or shift >= 35:
            raise ValueError("invalid .NET 7-bit integer")
        byte = data[offset]
        offset += 1
        value |= (byte & 0x7F) << shift
        if byte < 0x80:
            return value, offset
        shift += 7


def write_7bit_int(value: int) -> bytes:
    result = bytearray()
    while value >= 0x80:
        result.append((value & 0x7F) | 0x80)
        value >>= 7
    result.append(value)
    return bytes(result)


def tile_node(data: bytes, offset: int = 0) -> tuple[bytes, int]:
    if offset + 8 > len(data):
        raise ValueError("truncated PMDO tile node")
    _, count = struct.unpack_from("<ii", data, offset)
    end = offset + 8 + count * 16
    if count < 0 or end > len(data):
        raise ValueError("invalid PMDO tile node")
    return data[offset:end], end


def read_tile_index(path: Path) -> dict[str, bytes]:
    data = path.read_bytes()
    if len(data) < 4:
        raise ValueError("truncated PMDO tile index")
    count = struct.unpack_from("<i", data)[0]
    if count < 0:
        raise ValueError("negative PMDO tile-index count")
    offset = 4
    nodes: dict[str, bytes] = {}
    for _ in range(count):
        length, offset = read_7bit_int(data, offset)
        end = offset + length
        if end > len(data):
            raise ValueError("truncated PMDO tile-index name")
        name = data[offset:end].decode("utf-8")
        if not name or name in nodes:
            raise ValueError(f"empty or duplicate PMDO tile-index name: {name!r}")
        offset = end
        node, offset = tile_node(data, offset)
        nodes[name] = node
    if offset != len(data):
        raise ValueError("trailing bytes in PMDO tile index")
    return nodes


def write_tile_index(path: Path, nodes: dict[str, bytes]) -> None:
    output = bytearray(struct.pack("<i", len(nodes)))
    for name, node in nodes.items():
        encoded = name.encode("utf-8")
        output.extend(write_7bit_int(len(encoded)))
        output.extend(encoded)
        output.extend(node)
    path.write_bytes(output)


def footprint_clear(obstacles: list[list[dict[str, Any]]], x: int, y: int) -> bool:
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    if x < 0 or y < 0 or x + 1 >= width or y + 1 >= height:
        return False
    return all(obstacles[ix][iy]["Tags"] == 0 for ix in (x, x + 1) for iy in (y, y + 1))


def choose_spawn(obstacles: list[list[dict[str, Any]]]) -> tuple[int, int, int]:
    """Choose a 16px footprint, preferring four-way movement near map center."""
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    choices: list[tuple[int, float, int, int]] = []
    for x in range(width - 1):
        for y in range(height - 1):
            if not footprint_clear(obstacles, x, y):
                continue
            move_count = sum(
                footprint_clear(obstacles, x + dx, y + dy)
                for _, dx, dy in DIRECTION_DELTAS
            )
            distance = (x + 0.5 - width / 2) ** 2 + (y + 0.5 - height / 2) ** 2
            choices.append((-move_count, distance, x, y))
    if not choices:
        raise ValueError("no clear 16x16 collision footprint")
    neg_moves, _, x, y = min(choices)
    return x * 8, y * 8, -neg_moves


def choose_movement_probes(obstacles: list[list[dict[str, Any]]]) -> dict[str, Any]:
    """Choose deterministic aligned successful and BMA-solid movement probes."""
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    center_x = width / 2
    center_y = height / 2
    successful: list[tuple[float, int, int, str, int, int]] = []
    blocked: list[tuple[float, int, int, str, int, int]] = []
    for x in range(max(0, width - 1)):
        for y in range(max(0, height - 1)):
            if not footprint_clear(obstacles, x, y):
                continue
            distance = (x + 0.5 - center_x) ** 2 + (y + 0.5 - center_y) ** 2
            for direction, dx, dy in DIRECTION_DELTAS:
                target_x = x + dx
                target_y = y + dy
                if footprint_clear(obstacles, target_x, target_y):
                    successful.append((distance, x, y, direction, dx, dy))
                elif 0 <= target_x < width - 1 and 0 <= target_y < height - 1:
                    # The current 16x16 footprint is clear and the adjacent one
                    # is in-bounds but overlaps a source-derived solid cell.
                    blocked.append((distance, x, y, direction, dx, dy))
    if not successful:
        raise ValueError("no deterministic successful 8px movement probe")

    def record(value: tuple[float, int, int, str, int, int]) -> dict[str, Any]:
        _, x, y, direction, dx, dy = value
        return {
            "x": x * 8,
            "y": y * 8,
            "direction": direction,
            "expected_delta": [dx * 8, dy * 8],
        }

    solid_cells = sum(bool(obstacle.get("Tags", 0)) for column in obstacles for obstacle in column)
    if solid_cells and not blocked:
        raise ValueError("BMA has solids but no reachable aligned blocked movement probe")
    return {
        "successful": record(min(successful)),
        "blocked": record(min(blocked)) if blocked else None,
        "blocked_expectation": "BMA_SOLID_BLOCK" if blocked else "NO_BMA_COLLISION_LAYER_OR_SOLIDS",
        "solid_cells": solid_cells,
    }


def marker(x: int, y: int) -> dict[str, Any]:
    return {
        "EntName": "Main_Entrance_Marker",
        "Direction": 0,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 0,
        "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16},
    }


def fixture_ground(source: Path, target: Path) -> dict[str, Any]:
    payload = read_json(source)
    ground = payload["Object"]
    x, y, move_count = choose_spawn(ground["obstacles"])
    probes = choose_movement_probes(ground["obstacles"])
    layers = ground["Entities"]
    if not layers:
        layers.append({
            "Name": "Validation PMDO isolée", "Visible": True, "MapChars": [],
            "GroundObjects": [], "Spawners": [], "Markers": [],
        })
    for layer in layers:
        layer["Markers"] = [
            item for item in layer.get("Markers", [])
            if item.get("EntName") != "Main_Entrance_Marker"
        ]
    layers[0].setdefault("Markers", []).append(marker(x, y))
    ground["Comment"] = (
        ground.get("Comment", "")
        + " [FIXTURE IGNORÉE: marqueur déterministe injecté sur copie; source intacte.]"
    )
    write_json_bom(target, payload)
    return {
        "x": x,
        "y": y,
        "clear_move_directions": move_count,
        "movement_probes": probes,
    }


def ground_script(asset: str) -> str:
    return f"""-- Fixture PMDO ignorée; n'altère pas le script canonique ou le candidat source.
require 'origin.common'
local Adapter = require 'halcyon.ground.{asset}.animation_callbacks'
local M = {{}}
function M.Init(map)
  DEBUG.EnableDbgCoro()
  Adapter.Init(map)
end
function M.Enter(map) end
function M.Exit(map) Adapter.Exit(map) end
function M.Update(map) Adapter.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def native_ground_script(asset: str) -> str:
    return f"""-- Fixture PMDO ignorée pour {asset}; candidat et quête source intacts.
require 'origin.common'
local M = {{}}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map)
  if PMDRED_EU_NATIVE_VALIDATOR_INSTANCE then
    PMDRED_EU_NATIVE_VALIDATOR_INSTANCE:OnMapUpdate()
  end
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def validator_script(entries: list[dict[str, Any]]) -> str:
    rows = "\n".join(
        " {id='%s',zone='master_zone',idx=%d,ticks={%s}}," % (
            item["id"], item["zone_index"],
            ",".join(str(tick) for tick in item["preview_ticks"]),
        )
        for item in entries
    )
    return f"""-- Generated ignored fixture validator for all direct PMD Red EU Grounds.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuGroundValidator',BaseService)
local PILOT={{
{rows}
}}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_VALIDATOR] '..s)
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','a');if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='pmdred_eu_fixture'
 local only=os.getenv('PMDO_GROUND_VALIDATOR_ONLY')
 if only and only~='' then
  for _,item in ipairs(PILOT) do if item.id==only then PILOT={{item,item}};break end end
 end
 self.idx=0;self.busy=false;self.task=nil
end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','w');if f then f:close() end
 self.idx=1
 emit('{{"event":"begin","count":'..#PILOT..'}}')
 GAME:EnterZone(PILOT[1].zone,-1,PILOT[1].idx,0)
end
local function screenshot(id,phase)
 emit('{{"event":"screenshot_requested","ground":"'..id..'","phase":"'..phase..'"}}')
 _GROUND:Screenshot()
 GAME:WaitFrames(4)
 emit('{{"event":"screenshot_completed","ground":"'..id..'","phase":"'..phase..'"}}')
end
function V:validate_async()
 local item=PILOT[self.idx]
 local id=item.id
 local map=safe(function()return GAME:GetCurrentGround()end,nil)
 local hero=CH('PLAYER')
 if not map or not hero then error('map_or_hero_nil') end
 local Scheduler=require 'halcyon.RedDirectGroundAnimation'
 GAME:WaitFrames(8)
 local active0=safe(function()return Scheduler.ActiveAsset()end,'nil')
 local x=safe(function()return hero.Position.X end,-1)
 local y=safe(function()return hero.Position.Y end,-1)
 local moves={{}};local deltas={{}}
 for _,d in ipairs({{Direction.Up,Direction.Right,Direction.Down,Direction.Left}}) do
  GROUND:MoveInDirection(hero,d,8,false,2);GAME:WaitFrames(2)
  local nx=safe(function()return hero.Position.X end,x)
  local ny=safe(function()return hero.Position.Y end,y)
  moves[#moves+1]=(nx~=x or ny~=y) and 1 or 0
  deltas[#deltas+1]=string.format('"%d,%d"',nx-x,ny-y)
  GROUND:TeleportTo(hero,x,y,Direction.Down);GAME:WaitFrames(2)
 end
 local count=moves[1]+moves[2]+moves[3]+moves[4]
 -- Pause and seek exact canonical CANM ticks.  Keeping the actor outside the
 -- full-map target makes comparative PNGs contain map pixels only.
 local paused=Scheduler.Pause(map)
 GAME:WaitFrames(2)
 GROUND:TeleportTo(hero,-64,-64,Direction.Down);GAME:WaitFrames(1)
 local sampled={{}}
 local seek_ok=paused
 for _,tick in ipairs(item.ticks) do
  seek_ok=Scheduler.Seek(map,tick) and seek_ok
  sampled[#sampled+1]=tostring(safe(function()return Scheduler.CurrentTick()end,-1))
  screenshot(id,'tick_'..tostring(tick))
 end
 GROUND:TeleportTo(hero,x,y,Direction.Down)
 local resumed=Scheduler.Resume(map)
 GAME:WaitFrames(4)
 local active1=safe(function()return Scheduler.ActiveAsset()end,'nil')
 local animation=(active0==id and active1==id and seek_ok and resumed) and 'ANIMATION_SAMPLED_LIFECYCLE_PASS' or 'ANIMATION_LIFECYCLE_FAIL'
 local verdict=(count>0 and animation=='ANIMATION_SAMPLED_LIFECYCLE_PASS') and 'SAFE' or 'NEEDS_REPAIR'
 emit(string.format('{{"ground":"%s","load":"LOAD_PASS","spawn":{{"x":%d,"y":%d}},"move_dirs":[%d,%d,%d,%d],"move_deltas":[%s],"movement_probe":"%s","animation_probe":"%s","sampled_ticks":[%s],"verdict":"%s"}}',id,x,y,moves[1],moves[2],moves[3],moves[4],table.concat(deltas,','),count>0 and 'MOVEMENT_PASS' or 'SPAWN_ISOLATED',animation,table.concat(sampled,','),verdict))
end
function V:advance()
 local leaving=PILOT[self.idx]
 self.idx=self.idx+1
 if self.idx>#PILOT then
  local Scheduler=require 'halcyon.RedDirectGroundAnimation'
  local map=safe(function()return GAME:GetCurrentGround()end,nil)
  local cleaned=Scheduler.Cancel(map)
  local active=safe(function()return Scheduler.ActiveAsset()end,nil)
  emit('{{"event":"final_cleanup","cleanup":"'..((cleaned and active==nil) and 'PASS' or 'FAIL')..'"}}')
  emit('{{"event":"end"}}')
  -- Request the engine's own unload path. External TERM is retained only as a
  -- strict watchdog by the process runner; a qualifying run exits normally.
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
  self.busy=false;self.task=nil
 else
  self.exiting=leaving.id
  GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0);self.busy=false;self.task=nil
 end
end
function V:OnGroundMapExit()
 local Scheduler=require 'halcyon.RedDirectGroundAnimation'
 local active=safe(function()return Scheduler.ActiveAsset()end,nil)
 emit('{{"event":"ground_exit","ground":"'..quote(self.exiting or 'unknown')..'","cleanup":"'..(active==nil and 'PASS' or 'FAIL')..'"}}')
 self.exiting=nil
end
function V:OnGroundMapEnter()
 if not self.enabled or self.busy or self.idx<1 or self.idx>#PILOT then return end
 self.busy=true
 emit('{{"event":"ground_entered","ground":"'..PILOT[self.idx].id..'","scheduler":"TASK_BRANCH"}}')
 self.task=TASK:BranchCoroutine(function()
  local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
  if not ok then emit('{{"ground":"'..PILOT[self.idx].id..'","verdict":"RUNTIME_FAIL","error":"'..quote(err)..'"}}') end
  self:advance()
 end)
end
function V:OnInit()
 if self.enabled then
  emit('{{"event":"bootstrap_new_game"}}')
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
 end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.GroundMapExit,function()self.OnGroundMapExit(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuGroundValidator',V:new())
return V
"""


def native_validator_script(entries: list[dict[str, Any]], sink_index: int) -> str:
    def probe(value: dict[str, Any] | None) -> str:
        if value is None:
            return "nil"
        dx, dy = value["expected_delta"]
        return "{x=%d,y=%d,dir='%s',dx=%d,dy=%d}" % (
            value["x"], value["y"], value["direction"], dx, dy
        )

    rows = "\n".join(
        " {id='%s',zone='master_zone',idx=%d,ticks={%s},success=%s,blocked=%s,solid=%d}," % (
            item["id"],
            item["zone_index"],
            ",".join(str(tick) for tick in item["preview_ticks"]),
            probe(item["spawn"]["movement_probes"]["successful"]),
            probe(item["spawn"]["movement_probes"]["blocked"]),
            item["spawn"]["movement_probes"]["solid_cells"],
        )
        for item in entries
    )
    return f"""-- Generated ignored fixture validator for archive-backed PMD Red EU Grounds.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuNativeGroundValidator',BaseService)
local PILOT={{
{rows}
}}
local SINK={{zone='master_zone',idx={sink_index}}}
local DIR={{Up=Direction.Up,Right=Direction.Right,Down=Direction.Down,Left=Direction.Left}}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_NATIVE_VALIDATOR] '..s)
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','a');if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='pmdred_eu_native_fixture'
 local only=os.getenv('PMDO_GROUND_VALIDATOR_ONLY')
 if only and only~='' then
  for _,item in ipairs(PILOT) do if item.id==only then PILOT={{item}};break end end
 end
 self.idx=0;self.reload=false;self.busy=false;self.pending=false;self.finishing=false
 self.task=nil;self.capture_total=nil
end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','w');if f then f:close() end
 self.idx=1
 emit('{{"event":"begin","count":'..#PILOT..',"loads_per_ground":2}}')
 GAME:EnterZone(PILOT[1].zone,-1,PILOT[1].idx,0)
end
function V:screenshot(id,phase,tick,assigned)
 -- SwiftShader can make FNA's fixed timestep execute several Updates before
 -- the next Draw.  Pin the global animation clock on every intervening map
 -- update so the asynchronously saved PNG is the requested canonical tick.
 self.capture_total=tick*120
 RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total
 emit(string.format('{{"event":"screenshot_requested","ground":"%s","phase":"%s","source_tick":%d,"assigned_total_frame_tick":%.0f}}',id,phase,tick,assigned))
 _GROUND:Screenshot()
 GAME:WaitFrames(2)
 self.capture_total=nil
 emit(string.format('{{"event":"screenshot_completed","ground":"%s","phase":"%s","source_tick":%d}}',id,phase,tick))
end
local function movement(hero,p,blocked,id,phase)
 emit(string.format('{{"event":"movement_begin","ground":"%s","phase":"%s","kind":"%s"}}',id,phase,blocked and 'blocked' or 'successful'))
 GROUND:TeleportTo(hero,p.x,p.y,DIR[p.dir]);GAME:WaitFrames(1)
 local x=safe(function()return hero.Position.X end,-999999)
 local y=safe(function()return hero.Position.Y end,-999999)
 emit(string.format('{{"event":"movement_step","ground":"%s","phase":"%s","kind":"%s","step":"move"}}',id,phase,blocked and 'blocked' or 'successful'))
 GROUND:MoveInDirection(hero,DIR[p.dir],8,false,1);GAME:WaitFrames(1)
 local nx=safe(function()return hero.Position.X end,-999998)
 local ny=safe(function()return hero.Position.Y end,-999998)
 local dx=nx-x;local dy=ny-y
 local pass=(blocked and dx==0 and dy==0) or ((not blocked) and dx==p.dx and dy==p.dy)
 emit(string.format('{{"event":"movement_completed","ground":"%s","phase":"%s","kind":"%s","dx":%d,"dy":%d}}',id,phase,blocked and 'blocked' or 'successful',dx,dy))
 return pass,dx,dy
end
function V:validate_async()
 local item=PILOT[self.idx]
 local id=item.id
 local phase=self.reload and 'reload' or 'primary'
 local map=safe(function()return GAME:GetCurrentGround()end,nil)
 local hero=CH('PLAYER')
 if not map or not hero then error('map_or_hero_nil') end
 emit(string.format('{{"event":"settle_begin","ground":"%s","phase":"%s"}}',id,phase))
 GAME:WaitFrames(4)
 emit(string.format('{{"event":"settle_completed","ground":"%s","phase":"%s"}}',id,phase))
 local movement_ok=true;local blocked_ok=true;local move_dx=0;local move_dy=0;local block_dx=0;local block_dy=0
 if not self.reload then
  movement_ok,move_dx,move_dy=movement(hero,item.success,false,id,phase)
  if item.blocked then blocked_ok,block_dx,block_dy=movement(hero,item.blocked,true,id,phase) end
 end
 GROUND:TeleportTo(hero,-64,-64,Direction.Down);GAME:WaitFrames(1)
 local ticks=self.reload and {{0}} or item.ticks
 local clock_ok=true;local sampled={{}}
 for _,tick in ipairs(ticks) do
  emit(string.format('{{"event":"clock_write_begin","ground":"%s","phase":"%s","source_tick":%d}}',id,phase,tick))
  local assigned=safe(function()
   RogueEssence.Content.GraphicsManager.TotalFrameTick=tick*120
   return tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)
  end,-1)
  clock_ok=clock_ok and assigned==tick*120
  sampled[#sampled+1]=tostring(tick)
  self:screenshot(id,phase,tick,assigned)
 end
 local reset=safe(function()
  RogueEssence.Content.GraphicsManager.TotalFrameTick=0
  return tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)
 end,-1)
 clock_ok=clock_ok and reset==0
 local collision=(movement_ok and blocked_ok) and 'PASS' or 'FAIL'
 local verdict=(clock_ok and movement_ok and blocked_ok) and 'SAFE' or 'NEEDS_REPAIR'
 emit(string.format('{{"ground":"%s","phase":"%s","load":"LOAD_PASS","clock_write_read":"%s","movement_probe":"%s","blocked_probe":"%s","move_delta":"%d,%d","blocked_delta":"%d,%d","solid_cells":%d,"sampled_ticks":[%s],"verdict":"%s"}}',id,phase,clock_ok and 'PASS' or 'FAIL',movement_ok and 'PASS' or 'FAIL',item.blocked and (blocked_ok and 'PASS' or 'FAIL') or 'NOT_APPLICABLE_NO_BMA_SOLIDS',move_dx,move_dy,block_dx,block_dy,item.solid,table.concat(sampled,','),verdict))
end
function V:advance()
 local leaving=PILOT[self.idx]
 self.exiting=leaving.id
 self.exiting_phase=self.reload and 'reload' or 'primary'
 -- GroundMapEnter can fire before EnterZone returns.  Release busy first so
 -- that callback can queue the next validation on this service coroutine.
 self.busy=false
 if not self.reload then
  self.reload=true
  GAME:EnterZone(leaving.zone,-1,leaving.idx,0)
 elseif self.idx<#PILOT then
  self.idx=self.idx+1;self.reload=false
  GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0)
 else
  self.finishing=true
  GAME:EnterZone(SINK.zone,-1,SINK.idx,0)
 end
end
function V:OnGroundMapExit()
 if not self.enabled then return end
 emit('{{"event":"ground_exit","ground":"'..quote(self.exiting or 'unknown')..'","phase":"'..quote(self.exiting_phase or 'unknown')..'","cleanup":"PASS"}}')
 self.exiting=nil;self.exiting_phase=nil
end
function V:OnGroundMapEnter()
 if not self.enabled then return end
 if self.finishing then
  emit('{{"event":"sink_entered","cleanup":"PASS"}}')
  emit('{{"event":"final_cleanup","cleanup":"PASS"}}')
  emit('{{"event":"end"}}')
  -- Exit through PMDO/FNA's normal unload lifecycle. The strict runner waits
  -- for status 0 and uses TERM only as a diagnostic watchdog if this stalls.
  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
  return
 end
 if self.busy or self.idx<1 or self.idx>#PILOT then return end
 self.busy=true;self.pending=true
 local phase=self.reload and 'reload' or 'primary'
 emit('{{"event":"ground_entered","ground":"'..PILOT[self.idx].id..'","phase":"'..phase..'","scheduler":"MAP_UPDATE_INLINE"}}')
end
function V:OnMapUpdate()
 -- GroundMap.Update is itself advanced by the global CoroutineManager from
 -- GroundScene.ProcessInput.  Running inline here gives every WaitFrames call
 -- a managed parent and avoids adding a branch context while the manager is
 -- iterating its context list.  Keep the animation clock pinned until Draw
 -- consumes a pending screenshot; fixed-timestep catch-up may update more than
 -- once between the request and that Draw under software rendering.
 if not self.enabled then return end
 if self.capture_total~=nil then
  RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total
 end
 if not self.pending or self.task~=nil then return end
 self.pending=false
 self.task=true
 local item=PILOT[self.idx]
 local phase=self.reload and 'reload' or 'primary'
 emit('{{"event":"map_update","ground":"'..tostring(item and item.id or 'unknown')..'","phase":"'..phase..'"}}')
 local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
 if not ok then emit('{{"ground":"'..tostring(item and item.id or 'unknown')..'","phase":"'..phase..'","verdict":"RUNTIME_FAIL","error":"'..quote(err)..'"}}') end
 self.task=nil
 self:advance()
end
function V:OnUpdate()
 -- EngineServiceEvents.Update still runs while validate_async is suspended in
 -- WaitFrames, unlike the GroundMap.Update call that owns that coroutine.
 if self.enabled and self.capture_total~=nil then
  RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total
 end
end
function V:OnInit()
 if self.enabled then emit('{{"event":"bootstrap_new_game"}}');RogueEssence.GameManager.Instance:NewGamePlus(424242) end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('PmdRedEuNativeGroundValidator',EngineServiceEvents.GroundMapExit,function()self.OnGroundMapExit(self)end)
end
function V:UnSubscribe(med)end
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=V:new()
SCRIPT:AddService('PmdRedEuNativeGroundValidator',PMDRED_EU_NATIVE_VALIDATOR_INSTANCE)
return V
"""


def build(
    root: Path,
    output: Path,
    conversion_set: str = "direct",
    candidate_root: Path | None = None,
    plan_path: Path | None = None,
    ids: list[str] | None = None,
    pilot_ticks: list[int] | None = None,
    entity_integrated_ids: list[str] | None = None,
    canonical_baseline_root: Path | None = None,
) -> Path:
    if conversion_set not in {"direct", "remaining"}:
        raise ValueError(f"unsupported conversion set {conversion_set}")
    integrated_ids = set(entity_integrated_ids or [])
    if integrated_ids and (conversion_set != "remaining" or canonical_baseline_root is None):
        raise ValueError(
            "entity-integrated IDs require remaining conversion set and canonical baseline root"
        )
    if canonical_baseline_root is not None and not integrated_ids:
        raise ValueError("canonical baseline root requires explicit entity-integrated IDs")
    reference_plan: dict[str, Any] | None = None
    conversion_report: dict[str, Any] | None = None
    if conversion_set == "direct":
        candidate_root = root / "RESERVE/pmdred_direct"
        available = list(DIRECT_CANDIDATES)
        sheet_suffix = DIRECT_SHEET_SUFFIX
    else:
        if candidate_root is None or plan_path is None:
            raise ValueError("remaining fixture requires --candidate-root and --plan")
        reference_plan = read_json(plan_path)
        if reference_plan.get("schema") != "pmdred-eu-independent-rom-reference-v2":
            raise ValueError("remaining fixture requires independent reference plan v2")
        available = list(reference_plan.get("ground_order", []))
        if len(available) != 219 or set(available) != set(reference_plan.get("grounds", {})):
            raise ValueError("reference plan inventory is not exactly 219 Grounds")
        conversion_report_path = candidate_root / "conversion_report.json"
        conversion_report = read_json(conversion_report_path)
        if reference_plan["authority"].get("conversion_report_sha256") != sha256_file(conversion_report_path):
            raise ValueError("reference plan does not authenticate the candidate conversion report")
        if conversion_report.get("failure_count") != 0:
            raise ValueError("candidate conversion report contains failures")
        if {row["asset"] for row in conversion_report.get("results", [])} != set(available):
            raise ValueError("candidate conversion report inventory differs from reference plan")
        sheet_suffix = REMAINING_SHEET_SUFFIX

    candidates = available if ids is None else [asset for asset in available if asset in ids]
    unknown = sorted(set(ids or []) - set(available))
    if unknown:
        raise ValueError("unknown candidate ids: " + ", ".join(unknown))
    unknown_integrated = sorted(integrated_ids - set(candidates))
    if unknown_integrated:
        raise ValueError(
            "entity-integrated IDs are not selected candidates: "
            + ", ".join(unknown_integrated)
        )
    if not candidates:
        raise ValueError("fixture candidate selection is empty")
    if pilot_ticks is not None and len(candidates) != 1:
        raise ValueError("--pilot-ticks requires exactly one selected Ground")

    quest = output / "quest"
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)

    symlink(root / "Mod.xml", quest / "Mod.xml")
    symlink(root / "Strings", quest / "Strings")

    overlay_data_root(root / "Data", quest / "Data", {"Ground", "Zone", "Script", "Misc"})
    # Indexing writes Zone/index.idx and may rewrite triggered universal data.
    # Keep both destinations as real fixture files/directories, never symlinks.
    shutil.copytree(root / "Data/Misc", quest / "Data/Misc")
    overlay_children(
        root / "Data/Ground", quest / "Data/Ground",
        {f"{asset}.rsground" for asset in candidates}
        | ({f"{VALIDATION_SINK_ASSET}.rsground"} if conversion_set == "remaining" else set()),
    )
    # Deliberately sparse: PMDO 0.8.12's zone indexer cannot deserialize a few
    # unrelated legacy quest zones. Runtime fallback still supplies base zones;
    # this fixture only needs to override master_zone's routing summary.
    (quest / "Data/Zone").mkdir(parents=True, exist_ok=True)
    overlay_children(root / "Data/Script", quest / "Data/Script", {"halcyon"})
    overlay_children(
        root / "Data/Script/halcyon", quest / "Data/Script/halcyon",
        {"ground", "services"},
    )
    overlay_children(
        root / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground",
        set(candidates),
    )
    overlay_children(
        root / "Data/Script/halcyon/services", quest / "Data/Script/halcyon/services",
        {"ground_gameplay_validator"}
        | ({VALIDATION_SINK_ASSET} if conversion_set == "remaining" else set()),
    )

    overlay_children(root / "Content", quest / "Content", {"Tile"})
    tile_names = {asset + sheet_suffix for asset in candidates}
    # Content indexing writes Tile/index.idx.  Keep that destination fixture-local
    # rather than exposing the tracked index through a writable symlink.
    overlay_children(
        root / "Content/Tile", quest / "Content/Tile", tile_names | {"index.idx"}
    )

    tile_nodes = read_tile_index(root / "Content/Tile/index.idx")
    zone_payload = read_json(root / "Data/Zone/master_zone.json")
    ground_maps = zone_payload["Object"]["GroundMaps"]
    # The native validator exits through a dedicated inert Ground.  A real
    # story Ground is not a safe sink: its entry coroutine can legitimately
    # wait for dialogue/input and prevent deterministic final cleanup.
    sink_index = -1
    manifest_entries: list[dict[str, Any]] = []
    report_rows = {
        row["asset"]: row for row in (conversion_report or {}).get("results", [])
    }
    replaced_tile_index_nodes: list[str] = []

    def display_path(path: Path) -> str:
        try:
            return str(path.relative_to(root))
        except ValueError:
            return str(path)

    for asset in candidates:
        source_ground = candidate_root / "grounds" / f"{asset}.rsground"
        source_tile = candidate_root / "tiles" / f"{asset}{sheet_suffix}"
        if not source_ground.is_file() or not source_tile.is_file():
            raise ValueError(f"missing candidate files for {asset}")
        entity_integration: dict[str, Any] | None = None
        if conversion_set == "remaining":
            expected = report_rows[asset]["output_sha256"]
            actual = {"rsground": sha256_file(source_ground), "tile": sha256_file(source_tile)}
            if actual != expected:
                if asset not in integrated_ids:
                    raise ValueError(
                        f"{asset}: candidate files differ from authenticated conversion report"
                    )
                if actual["tile"] != expected["tile"]:
                    raise ValueError(f"{asset}: entity integration changed the canonical tile")
                assert canonical_baseline_root is not None
                baseline_ground = canonical_baseline_root / "grounds" / source_ground.name
                baseline_tile = canonical_baseline_root / "tiles" / source_tile.name
                baseline_actual = {
                    "rsground": sha256_file(baseline_ground),
                    "tile": sha256_file(baseline_tile),
                }
                if baseline_actual != expected:
                    raise ValueError(
                        f"{asset}: canonical integration baseline differs from authenticated report"
                    )
                entity_integration = verify_additive_entity_integration(
                    source_ground, baseline_ground
                )
            elif asset in integrated_ids:
                raise ValueError(
                    f"{asset}: declared entity integration is byte-identical to canonical candidate"
                )

        spawn = fixture_ground(source_ground, quest / "Data/Ground" / source_ground.name)
        symlink(source_tile, quest / "Content/Tile" / source_tile.name)
        tile_payload = source_tile.read_bytes()
        node, tile_end = tile_node(tile_payload)
        # A .tile content file continues after its indexable node with an
        # engine texture count/reserved pair and PNG payloads.  Verify that
        # boundary rather than mistaking the content body for index bytes.
        if tile_payload[tile_end + 8:tile_end + 16] != b"\x89PNG\r\n\x1a\n":
            raise ValueError(f"{source_tile}: missing PNG payload after tile index node")
        previous = tile_nodes.get(source_tile.stem)
        if previous is not None and previous != node:
            if conversion_set == "direct":
                raise ValueError(f"refusing to replace conflicting tile index node {source_tile.stem}")
            replaced_tile_index_nodes.append(source_tile.stem)
        tile_nodes[source_tile.stem] = node

        script_dir = quest / "Data/Script/halcyon/ground" / asset
        script_dir.mkdir(parents=True)
        script = ground_script(asset) if conversion_set == "direct" else native_ground_script(asset)
        (script_dir / "init.lua").write_text(script, encoding="utf-8")
        if conversion_set == "direct":
            for name in ("animation_metadata.lua", "animation_callbacks.lua"):
                symlink(candidate_root / "scripts" / asset / name, script_dir / name)

        if asset not in ground_maps:
            ground_maps.append(asset)
        if conversion_set == "direct":
            animation = read_json(
                root / "docs/pmdred_eu/dungeon_grounds" / asset / "animation.json"
            )
            preview_ticks = animation["preview"]["frame_start_ticks"]
        else:
            assert reference_plan is not None
            planned_ticks = reference_plan["grounds"][asset]["complete_two_local_cycle_boundary_ticks"]
            if pilot_ticks is not None:
                outside_plan = sorted(set(pilot_ticks) - set(planned_ticks))
                if outside_plan:
                    raise ValueError(f"pilot ticks outside authenticated plan: {outside_plan}")
                preview_ticks = pilot_ticks
            else:
                preview_ticks = planned_ticks
        manifest_entry = {
            "id": asset,
            "zone_index": ground_maps.index(asset),
            "spawn": spawn,
            "preview_ticks": preview_ticks,
            "source_ground": display_path(source_ground),
            "source_tile": display_path(source_tile),
            "source_ground_sha256": sha256_file(source_ground),
            "source_tile_sha256": sha256_file(source_tile),
        }
        if entity_integration is not None:
            entity_integration["canonical_ground"] = display_path(
                Path(entity_integration["canonical_ground"])
            )
            manifest_entry["entity_integration"] = entity_integration
        manifest_entries.append(manifest_entry)

    if conversion_set == "remaining":
        sink_path = quest / "Data/Ground" / f"{VALIDATION_SINK_ASSET}.rsground"
        sink_payload = validation_sink_payload(
            read_json(candidate_root / "grounds" / f"{candidates[0]}.rsground")
        )
        write_json_bom(sink_path, sink_payload)
        sink_script_dir = quest / "Data/Script/halcyon/ground" / VALIDATION_SINK_ASSET
        sink_script_dir.mkdir(parents=True)
        (sink_script_dir / "init.lua").write_text(
            "local M = {}\nfunction M.Init(map) end\nfunction M.Enter(map) end\n"
            "function M.Update(map) end\nfunction M.Exit(map) end\nreturn M\n",
            encoding="utf-8",
        )
        ground_maps.append(VALIDATION_SINK_ASSET)
        sink_index = ground_maps.index(VALIDATION_SINK_ASSET)

    fixture_tile_index = quest / "Content/Tile/index.idx"
    write_tile_index(fixture_tile_index, tile_nodes)
    reloaded_tile_nodes = read_tile_index(fixture_tile_index)
    if reloaded_tile_nodes != tile_nodes:
        raise ValueError("fixture tile index failed exact write/read verification")
    expected_sheet_nodes = {Path(name).stem for name in tile_names}
    missing_sheets = sorted(expected_sheet_nodes - set(reloaded_tile_nodes))
    if missing_sheets:
        raise ValueError(f"fixture tile index omitted candidate sheets: {missing_sheets}")

    source_indexes = sorted(root.glob("Data/**/index.idx"))
    exposed_indexes = [
        path for path in quest.glob("Data/**/index.idx")
        if path.is_symlink()
    ]
    if exposed_indexes:
        raise ValueError(f"writable Data indexes remain symlinked: {exposed_indexes}")
    copied_source_indexes = [
        path for path in source_indexes
        if path.relative_to(root / "Data").parts[0] not in {"Ground", "Zone", "Script", "Misc"}
    ]
    for source_index in copied_source_indexes:
        fixture_index = quest / "Data" / source_index.relative_to(root / "Data")
        if not fixture_index.is_file() or fixture_index.is_symlink():
            raise ValueError(f"Data index is not fixture-local: {fixture_index}")
        if fixture_index.read_bytes() != source_index.read_bytes():
            raise ValueError(f"Data index copy differs before indexing: {fixture_index}")

    write_json_bom(quest / "Data/Zone/master_zone.json", zone_payload)
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    service = (
        validator_script(manifest_entries)
        if conversion_set == "direct"
        else native_validator_script(manifest_entries, sink_index)
    )
    (service_dir / "init.lua").write_text(service, encoding="utf-8")

    # Build isolated asset/appdata roots instead of modifying either the
    # executable directory or the pinned DumpAsset checkout.  PMDO resolves
    # -quest beneath APP_PATH/MODS (not ASSET_PATH/MODS).
    asset_root = output / "asset"
    overlay_children(root / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    symlink(quest, appdata / "MODS/pmdred_eu_fixture")

    manifest = {
        "kind": "ignored_symlink_overlay",
        "quest": str(quest),
        "quest_name": "pmdred_eu_fixture",
        "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep,
        "conversion_set": conversion_set,
        "candidate_count": len(manifest_entries),
        "master_zone_ground_count": len(ground_maps),
        "replaced_fixture_local_tile_index_nodes": sorted(replaced_tile_index_nodes),
        "reference_plan": display_path(plan_path) if plan_path else None,
        "reference_plan_sha256": sha256_file(plan_path) if plan_path else None,
        "entity_integrated_ids": sorted(integrated_ids),
        "canonical_baseline_root": (
            display_path(canonical_baseline_root) if canonical_baseline_root else None
        ),
        "entries": manifest_entries,
    }
    (output / "fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return quest


def parse_csv(value: str | None) -> list[str] | None:
    if value is None:
        return None
    return [item.strip().lower() for item in value.split(",") if item.strip()]


def parse_ticks(value: str | None) -> list[int] | None:
    if value is None:
        return None
    ticks = sorted({int(item.strip()) for item in value.split(",") if item.strip()})
    if any(tick < 0 for tick in ticks):
        raise ValueError("pilot ticks must be nonnegative")
    return ticks


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--conversion-set", choices=("direct", "remaining"), default="direct")
    parser.add_argument("--candidate-root", type=Path)
    parser.add_argument("--plan", type=Path)
    parser.add_argument("--ids", help="comma-separated selected Ground IDs")
    parser.add_argument(
        "--entity-integrated-ids",
        help=(
            "comma-separated selected Grounds allowed to add Markers/Spawners; "
            "requires --canonical-baseline-root"
        ),
    )
    parser.add_argument(
        "--canonical-baseline-root", type=Path,
        help="authenticated unintegrated conversion root used to prove entity-only additions",
    )
    parser.add_argument(
        "--pilot-ticks",
        help="comma-separated authenticated tick subset; requires exactly one selected Ground",
    )
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/pmdred-eu-fixture"),
        help="ignored fixture output directory",
    )
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]

    def rooted(path: Path | None) -> Path | None:
        if path is None or path.is_absolute():
            return path
        return root / path

    output = rooted(args.output)
    assert output is not None
    quest = build(
        root,
        output,
        conversion_set=args.conversion_set,
        candidate_root=rooted(args.candidate_root),
        plan_path=rooted(args.plan),
        ids=parse_csv(args.ids),
        pilot_ticks=parse_ticks(args.pilot_ticks),
        entity_integrated_ids=parse_csv(args.entity_integrated_ids),
        canonical_baseline_root=rooted(args.canonical_baseline_root),
    )
    print(quest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
