#!/usr/bin/env python3
"""Exact PMDO 0.8.12 runtime capture for one generated Smart Ground.

This module extends Agent A's ignored overlay, patched-SDL and SwiftShader/ANGLE
method.  It never writes to Data/, Content/ or the candidate Ground.
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

import hashlib
import json
import os
import shutil
import signal
import subprocess
import time
from pathlib import Path
from typing import Any

from .assets import load_png
from build_pmdred_eu_runtime_fixture import (
    fixture_ground,
    footprint_clear,
    overlay_children,
    overlay_data_root,
    read_json,
    read_tile_index,
    symlink,
    write_json_bom,
)

EVENTS = Path("/tmp/smart_ground_runtime_validator.jsonl")
BUNDLE_NAME = "pmdo-headless-bundle"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def _water_cells(obj: dict[str, Any]) -> set[tuple[int, int]]:
    result: set[tuple[int, int]] = set()
    for layer in obj.get("Layers", []):
        name = str(layer.get("Name", "")).casefold()
        if not any(word in name for word in ("river", "water", "lac", "rivière")):
            continue
        for x, column in enumerate(layer.get("Tiles", [])):
            for y, cell in enumerate(column):
                if cell.get("AutoTileset") or any(row.get("Frames") for row in cell.get("Layers", [])):
                    result.add((x, y))
    return result


def _components(points: set[tuple[int, int]]) -> list[set[tuple[int, int]]]:
    remaining = set(points)
    result = []
    while remaining:
        component = {remaining.pop()}
        queue = list(component)
        while queue:
            x, y = queue.pop()
            for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if point in remaining:
                    remaining.remove(point)
                    component.add(point)
                    queue.append(point)
        result.append(component)
    return sorted(result, key=lambda row: (-len(row), min(row)))


def _nearest_capture(obstacles, target_x: float, target_y: float) -> tuple[int, int]:
    choices = []
    for x in range(max(0, len(obstacles) - 1)):
        for y in range(max(0, len(obstacles[0]) - 1)):
            if footprint_clear(obstacles, x, y):
                choices.append(((x - target_x) ** 2 + (y - target_y) ** 2, x, y))
    if not choices:
        raise ValueError("generated Ground has no clear 16x16 capture position")
    _, x, y = min(choices)
    return x * 8, y * 8


def capture_points(ground: dict[str, Any], metadata: dict[str, Any] | None, spawn: dict[str, Any]) -> list[dict[str, Any]]:
    obj = ground["Object"]
    obstacles = obj["obstacles"]
    rows = [{"label": "spawn", "x": spawn["x"], "y": spawn["y"]}]
    anchors = ((metadata or {}).get("geometry") or {}).get("anchors", {})
    for label in ("entrance", "poi", "exit", "boss"):
        point = anchors.get(label)
        if isinstance(point, list) and len(point) == 2:
            x, y = _nearest_capture(obstacles, point[0], point[1])
            rows.append({"label": label, "x": x, "y": y})
    for index, component in enumerate(_components(_water_cells(obj)), 1):
        center_x = sum(x for x, _ in component) / len(component)
        center_y = sum(y for _, y in component) / len(component)
        x, y = _nearest_capture(obstacles, center_x, center_y)
        rows.append({"label": f"water_{index}", "x": x, "y": y})
    unique = []
    seen = set()
    for row in rows:
        key = (row["x"], row["y"])
        if key not in seen:
            seen.add(key)
            unique.append(row)
    return unique


def _lua_rows(rows: list[dict[str, Any]]) -> str:
    return ",\n".join(" {label='%s',x=%d,y=%d}" % (row["label"], row["x"], row["y"]) for row in rows)


def ground_script(asset: str) -> str:
    return f"""-- Fixture ignorée Smart Ground; candidat et quête source intacts.
require 'origin.common'
local M={{}}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map)
 if SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE then SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE:OnMapUpdate() end
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def validator_script(asset: str, zone_index: int, probes: dict[str, Any], captures: list[dict[str, Any]], ticks: list[int]) -> str:
    successful = probes["successful"]
    blocked = probes.get("blocked")

    def probe(value: dict[str, Any] | None) -> str:
        if value is None:
            return "nil"
        dx, dy = value["expected_delta"]
        return "{x=%d,y=%d,dir='%s',dx=%d,dy=%d}" % (value["x"], value["y"], value["direction"], dx, dy)

    return f"""-- Fixture runtime ignorée fondée sur la méthode Agent A.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('SmartGroundRuntimeValidator',BaseService)
local ITEM={{id='{asset}',zone='master_zone',idx={zone_index},success={probe(successful)},blocked={probe(blocked)}}}
local CAPTURES={{
{_lua_rows(captures)}
}}
local TICKS={{{','.join(str(tick) for tick in ticks)}}}
local DIR={{Up=Direction.Up,Right=Direction.Right,Down=Direction.Down,Left=Direction.Left}}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[SMART_GROUND_RUNTIME] '..s)
 local f=io.open('{EVENTS}','a');if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='smart_ground_fixture'
 self.started=false;self.pending=false;self.busy=false;self.capture_total=nil
end
function V:begin()
 if not self.enabled or self.started then return end
 local f=io.open('{EVENTS}','w');if f then f:close() end
 self.started=true
 emit('{{"event":"begin","ground":"{asset}","capture_count":{len(captures)},"tick_count":{len(ticks)}}}')
 GAME:EnterZone(ITEM.zone,-1,ITEM.idx,0)
end
local function movement(hero,p,blocked)
 if not p then return true,0,0 end
 GROUND:TeleportTo(hero,p.x,p.y,DIR[p.dir]);GAME:WaitFrames(1)
 local x=safe(function()return hero.Position.X end,-999999)
 local y=safe(function()return hero.Position.Y end,-999999)
 GROUND:MoveInDirection(hero,DIR[p.dir],8,false,1);GAME:WaitFrames(1)
 local nx=safe(function()return hero.Position.X end,-999998)
 local ny=safe(function()return hero.Position.Y end,-999998)
 local dx=nx-x;local dy=ny-y
 return (blocked and dx==0 and dy==0) or ((not blocked) and dx==p.dx and dy==p.dy),dx,dy
end
function V:screenshot(label,tick)
 self.capture_total=tick*120
 RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total
 emit(string.format('{{"event":"screenshot_requested","label":"%s","tick":%d}}',label,tick))
 _GROUND:Screenshot();GAME:WaitFrames(2)
 self.capture_total=nil
 emit(string.format('{{"event":"screenshot_completed","label":"%s","tick":%d}}',label,tick))
end
function V:validate_async()
 GAME:WaitFrames(8)
 local map=safe(function()return GAME:GetCurrentGround()end,nil)
 local hero=CH('PLAYER')
 if not map or not hero then error('map_or_hero_nil') end
 emit('{{"event":"ground_loaded","ground":"{asset}","load":"PASS"}}')
 local move_ok,mdx,mdy=movement(hero,ITEM.success,false)
 local block_ok,bdx,bdy=movement(hero,ITEM.blocked,true)
 for _,capture in ipairs(CAPTURES) do
  GROUND:TeleportTo(hero,capture.x,capture.y,Direction.Down);GAME:WaitFrames(2)
  for _,tick in ipairs(TICKS) do self:screenshot(capture.label,tick) end
 end
 RogueEssence.Content.GraphicsManager.TotalFrameTick=0
 local verdict=(move_ok and block_ok) and 'RUNTIME_PASS' or 'RUNTIME_FAIL'
 emit(string.format('{{"event":"result","load":"PASS","movement":"%s","blocked":"%s","move_delta":"%d,%d","blocked_delta":"%d,%d","verdict":"%s"}}',move_ok and 'PASS' or 'FAIL',block_ok and 'PASS' or 'FAIL',mdx,mdy,bdx,bdy,verdict))
 emit('{{"event":"end"}}')
 RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
end
function V:OnMapUpdate()
 if not self.enabled then return end
 if self.capture_total~=nil then RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total end
 if not self.pending or self.busy then return end
 self.pending=false;self.busy=true
 local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
 if not ok then emit('{{"event":"result","verdict":"RUNTIME_FAIL","error":"'..quote(err)..'"}}');emit('{{"event":"end"}}');RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload end
end
function V:OnUpdate()
 if self.enabled and self.capture_total~=nil then RogueEssence.Content.GraphicsManager.TotalFrameTick=self.capture_total end
end
function V:OnGroundMapEnter()if self.enabled and not self.busy then self.pending=true end end
function V:OnInit()if self.enabled then emit('{{"event":"bootstrap_new_game"}}');RogueEssence.GameManager.Instance:NewGamePlus(20260813) end end
function V:Subscribe(med)
 med:Subscribe('SmartGroundRuntimeValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
 med:Subscribe('SmartGroundRuntimeValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('SmartGroundRuntimeValidator',EngineServiceEvents.NewGame,function()self.begin(self)end)
 med:Subscribe('SmartGroundRuntimeValidator',EngineServiceEvents.LoadSavedData,function()self.begin(self)end)
 med:Subscribe('SmartGroundRuntimeValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
end
function V:UnSubscribe(med)end
SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE=V:new()
SCRIPT:AddService('SmartGroundRuntimeValidator',SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE)
return V
"""


def build_fixture(repo: Path, ground_path: Path, metadata_path: Path | None, output: Path, ticks: list[int]) -> dict[str, Any]:
    ground = read_json(ground_path)
    asset = ground["Object"]["AssetName"]
    metadata = read_json(metadata_path) if metadata_path and metadata_path.is_file() else None
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    quest = output / "quest"

    symlink(repo / "Mod.xml", quest / "Mod.xml")
    symlink(repo / "Strings", quest / "Strings")
    overlay_data_root(repo / "Data", quest / "Data", {"Ground", "Zone", "Script", "Misc"})
    shutil.copytree(repo / "Data/Misc", quest / "Data/Misc")
    overlay_children(repo / "Data/Ground", quest / "Data/Ground", {ground_path.name})
    (quest / "Data/Zone").mkdir(parents=True)
    overlay_children(repo / "Data/Script", quest / "Data/Script", {"halcyon"})
    overlay_children(repo / "Data/Script/halcyon", quest / "Data/Script/halcyon", {"ground", "services"})
    overlay_children(repo / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground", {asset})
    overlay_children(repo / "Data/Script/halcyon/services", quest / "Data/Script/halcyon/services", {"ground_gameplay_validator"})

    overlay_children(repo / "Content", quest / "Content", {"Tile"})
    overlay_children(repo / "Content/Tile", quest / "Content/Tile", {"index.idx"})
    shutil.copy2(repo / "Content/Tile/index.idx", quest / "Content/Tile/index.idx")

    fixture_ground_path = quest / "Data/Ground" / f"{asset}.rsground"
    spawn = fixture_ground(ground_path, fixture_ground_path)
    captures = capture_points(ground, metadata, spawn)
    sheets = {
        frame["Sheet"]
        for layer in ground["Object"].get("Layers", [])
        for column in layer.get("Tiles", [])
        for cell in column
        for tile_layer in cell.get("Layers", [])
        for frame in tile_layer.get("Frames", [])
        if frame.get("Sheet")
    }
    missing_files = sorted(sheet for sheet in sheets if not (repo / "Content/Tile" / f"{sheet}.tile").is_file())
    indexed = read_tile_index(repo / "Content/Tile/index.idx")
    missing_index = sorted(sheets - set(indexed))
    if missing_files or missing_index:
        raise ValueError(f"missing tile dependencies: files={missing_files}, index={missing_index}")

    zone = read_json(repo / "Data/Zone/master_zone.json")
    maps = zone["Object"]["GroundMaps"]
    if asset not in maps:
        maps.append(asset)
    zone_index = maps.index(asset)
    write_json_bom(quest / "Data/Zone/master_zone.json", zone)

    script_dir = quest / "Data/Script/halcyon/ground" / asset
    script_dir.mkdir(parents=True)
    (script_dir / "init.lua").write_text(ground_script(asset), encoding="utf-8")
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    (service_dir / "init.lua").write_text(validator_script(asset, zone_index, spawn["movement_probes"], captures, ticks), encoding="utf-8")

    asset_root = output / "asset"
    overlay_children(repo / ".runtime-cache/DumpAsset", asset_root, {"MODS"})
    appdata = output / "appdata"
    (appdata / "MODS").mkdir(parents=True)
    symlink(quest, appdata / "MODS/smart_ground_fixture")
    manifest = {
        "schema_version": "1.0.0",
        "kind": "ignored_agent_a_overlay_extension",
        "asset": asset,
        "ground_source": ground_path.as_posix(),
        "ground_sha256": sha256_file(ground_path),
        "metadata_source": metadata_path.as_posix() if metadata_path else None,
        "asset_root": str(asset_root) + os.sep,
        "appdata": str(appdata) + os.sep,
        "quest_name": "smart_ground_fixture",
        "zone_index": zone_index,
        "spawn": spawn,
        "captures": captures,
        "ticks": ticks,
        "referenced_sheets": sorted(sheets),
        "events": EVENTS.as_posix(),
    }
    (output / "fixture_manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def runtime_env(repo: Path) -> dict[str, str]:
    bundle = repo / ".runtime-cache" / BUNDLE_NAME
    result = dict(os.environ)
    result.update({
        "DOTNET_BUNDLE_EXTRACT_BASE_DIR": str(repo / ".runtime-cache/dotnet-headless"),
        "LD_LIBRARY_PATH": str(bundle),
        "SDL_VIDEODRIVER": "offscreen", "SDL_AUDIODRIVER": "dummy",
        "SDL_VIDEO_GL_DRIVER": str(bundle / "libGLESv2.so"),
        "SDL_VIDEO_EGL_DRIVER": str(bundle / "libEGL.so"),
        "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY": "1", "PMDO_HEADLESS_DISMISS_SPLASH": "1",
        "FNA3D_FORCE_DRIVER": "OpenGL", "FNA3D_OPENGL_FORCE_ES3": "1",
        "ANGLE_DEFAULT_PLATFORM": "vulkan",
        "VK_ICD_FILENAMES": str(bundle / "vk_swiftshader_icd.absolute.json"),
        "PMDO_GROUND_VALIDATOR": "smart_ground_fixture",
    })
    return result


def _command(repo: Path, manifest: dict[str, Any], *extra: str) -> list[str]:
    return [str(repo / ".runtime-cache" / BUNDLE_NAME / "PMDO"), "-asset", manifest["asset_root"], "-appdata", manifest["appdata"], "-quest", manifest["quest_name"], *extra]


def _stop(process: subprocess.Popen[bytes]) -> None:
    if process.poll() is None:
        os.killpg(process.pid, signal.SIGTERM)
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait(timeout=5)


def _dark_walkable_cells(path: Path, ground: dict[str, Any]) -> list[list[int]]:
    image = load_png(path)
    obstacles = ground["Object"]["obstacles"]
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    # PMDO captures the full Ground when it fits the render target. For larger
    # scrolling maps coordinates require camera transforms and stay review-only.
    if image.width != width * 8 or image.height != height * 8:
        return []
    base_layers = [
        layer for layer in ground["Object"].get("Layers", [])
        if any(word in str(layer.get("Name", "")).casefold() for word in ("base", "floor", "sol"))
        and "ceiling" not in str(layer.get("Name", "")).casefold()
    ]
    defects = []
    for cell_x in range(width):
        for cell_y in range(height):
            if obstacles[cell_x][cell_y].get("Tags", 0):
                continue
            base_visible = any(
                layer["Tiles"][cell_x][cell_y].get("AutoTileset")
                or any(row.get("Frames") for row in layer["Tiles"][cell_x][cell_y].get("Layers", []))
                for layer in base_layers
            )
            if base_visible:
                continue
            quadrants = []
            for offset_y in (0, 4):
                for offset_x in (0, 4):
                    dark = 0
                    for pixel_y in range(cell_y * 8 + offset_y, cell_y * 8 + offset_y + 4):
                        for pixel_x in range(cell_x * 8 + offset_x, cell_x * 8 + offset_x + 4):
                            offset = (pixel_y * image.width + pixel_x) * 4
                            if max(image.pixels[offset:offset + 3]) < 40:
                                dark += 1
                    quadrants.append(dark)
            if max(quadrants) >= 15:
                defects.append([cell_x, cell_y])
    return defects


def validate_runtime(repo: Path, ground_path: Path, metadata_path: Path | None, fixture_root: Path, output: Path, ticks: list[int] | None = None, timeout: int = 180) -> dict[str, Any]:
    ticks = ticks or [0, 15]
    required = [repo / ".runtime-cache/pmdo-headless-bundle/PMDO", repo / ".runtime-cache/dotnet-headless", repo / ".runtime-cache/DumpAsset"]
    missing = [str(path) for path in required if not path.exists()]
    if missing:
        raise ValueError("restore Agent A runtime first; missing: " + ", ".join(missing))
    manifest = build_fixture(repo, ground_path.resolve(), metadata_path.resolve() if metadata_path else None, fixture_root.resolve(), ticks)
    env = runtime_env(repo)
    index = subprocess.run(_command(repo, manifest, "-index", "zone"), cwd=repo, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300, check=True)
    if any(token in index.stdout.lower() for token in (b"exception", b"failed to load", b"could not load")):
        raise ValueError("PMDO index log contains an error signature")

    EVENTS.unlink(missing_ok=True)
    screenshots = Path(manifest["appdata"]) / "SCREENSHOT"
    shutil.rmtree(screenshots, ignore_errors=True)
    screenshots.mkdir(parents=True)
    runtime_log = fixture_root / "runtime.log"
    with runtime_log.open("wb") as stream:
        process = subprocess.Popen(_command(repo, manifest), cwd=repo, env=env, stdout=stream, stderr=subprocess.STDOUT, start_new_session=True)
        deadline = time.monotonic() + timeout
        try:
            while time.monotonic() < deadline:
                if EVENTS.is_file() and '"event":"end"' in EVENTS.read_text(encoding="utf-8"):
                    break
                if process.poll() is not None:
                    raise RuntimeError(f"PMDO exited before terminal event: {process.returncode}")
                time.sleep(.1)
            else:
                raise TimeoutError("Smart Ground runtime validator did not finish")
        finally:
            _stop(process)

    events = [json.loads(line) for line in EVENTS.read_text(encoding="utf-8").splitlines()]
    results = [row for row in events if row.get("event") == "result"]
    if len(results) != 1 or results[0].get("verdict") != "RUNTIME_PASS":
        raise ValueError(f"PMDO runtime verdict is not pass: {results}")
    paths = sorted(screenshots.glob("*.png"), key=lambda path: path.stat().st_mtime_ns)
    labels = [(row["label"], tick) for row in manifest["captures"] for tick in ticks]
    if len(paths) != len(labels):
        raise ValueError(f"expected {len(labels)} screenshots, found {len(paths)}")
    output.mkdir(parents=True, exist_ok=True)
    ground_payload = read_json(ground_path)
    samples = []
    for source, (label, tick) in zip(paths, labels, strict=True):
        destination = output / f"{label}_tick_{tick:03d}.png"
        shutil.copy2(source, destination)
        dark_walkable = _dark_walkable_cells(destination, ground_payload)
        samples.append({
            "label": label, "tick": tick, "file": destination.as_posix(),
            "sha256": sha256_file(destination),
            "uniform_dark_walkable_cells": dark_walkable,
        })
    defects = sorted({tuple(cell) for sample in samples for cell in sample["uniform_dark_walkable_cells"]})
    if defects:
        raise ValueError(f"runtime capture exposes dark walkable tile holes: {defects}")
    (output / "events.jsonl").write_text("\n".join(json.dumps(row, ensure_ascii=False, separators=(",", ":")) for row in events) + "\n", encoding="utf-8")
    (output / "index.log").write_bytes(index.stdout)
    report = {
        "schema_version": "1.0.0",
        "result": "SMART_GROUND_PMDO_RUNTIME_CAPTURE_PASS",
        "scope": "exact_engine_load_collision_animation_and_visual_capture_not_artistic_acceptance",
        "authority": {
            "pmdo_version": "0.8.12",
            "pmdo_sha256": sha256_file(repo / ".runtime-cache/pmdo-headless-bundle/PMDO"),
            "method": "Agent A ignored overlay + patched SDL + SwiftShader/ANGLE",
        },
        "candidate": {"asset": manifest["asset"], "ground_sha256": manifest["ground_sha256"]},
        "runtime_probes": results[0],
        "runtime_visual_gate": {
            "uniform_dark_walkable_cells": 0,
            "result": "PASS",
            "note": "runtime defect gate; not a substitute for human artistic acceptance",
        },
        "captures": samples,
        "fixture_manifest_sha256": sha256_file(fixture_root / "fixture_manifest.json"),
    }
    (output / "runtime_report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return report
