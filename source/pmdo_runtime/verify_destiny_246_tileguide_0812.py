#!/usr/bin/env python3
"""Validate all 246 candidate Grounds against exact source TileGuide assets.

This is a separate headless native-runtime test from the Ground-only probe. It
loads Content/Tile/index.idx with RogueEssence.TileGuide.Load, gets every Ground
in batches of 20, and resolves every unique (sheet, TexLoc) used by its frames.
The stage is a disposable 246-map candidate, not the final/installed Quest.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
STAGE = ROOT / ".cache/destiny-recovery/candidate-246-tileguide"
RESULTS = ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv"
SUMMARY = ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_summary.json"
NAMESPACE = "destiny_246_tileguide_probe"
MOD = RUNTIME / "MODS" / NAMESPACE
STARTUP = RUNTIME / "Data/Script/origin/main.lua"
RESULT_IN_RUNTIME = RUNTIME / "destiny_246_tileguide_probe.tsv"
HOME = ROOT / ".cache/pmdo-runtime/home-destiny-246-tileguide"
BATCH_SIZE = 20


def lua_tests(rows: list[dict]) -> str:
    return "{" + ",".join(
        "{" + ",".join(
            f"{key}={json.dumps(row[key], ensure_ascii=False)}"
            for key in ("mapId", "width", "height", "texSize", "layers")
        ) + "}"
        for row in rows
    ) + "}"


def make_hook(rows: list[dict], index_path: Path, expected_nodes: int) -> bytes:
    source = """-- NATIVE_GROUND_AND_TILEGUIDE_TEST: headless PMDO 0.8.12
local env=luanet.import_type('System.Environment')
local gfx=luanet.import_type('RogueEssence.Content.GraphicsManager')
local dm=luanet.import_type('RogueEssence.Data.DataManager')
local file=luanet.import_type('System.IO.File')
local BinaryReader=luanet.import_type('System.IO.BinaryReader')
local TileGuide=luanet.import_type('RogueEssence.Content.TileGuide')
local output=assert(io.open('destiny_246_tileguide_probe.tsv','w'))
gfx.DungeonTexSize=3
local function len(v) if v==nil then return 0 end; if v.Count~=nil then return v.Count end; return v.Length end
local index_ok,guide=pcall(function()
 local stream=file.OpenRead(%s)
 local reader=BinaryReader(stream)
 local tileGuide=TileGuide.Load(reader)
 stream:Close()
 return tileGuide
end)
if not index_ok or guide==nil then
 output:write('INDEX\\tFAIL\\t'..tostring(guide)..'\\n')
 output:close(); print('NATIVE_GROUND_AND_TILEGUIDE_TEST FAIL'); env.Exit(1)
end
if guide.Nodes.Count~=%d then
 output:write('INDEX\\t'..tostring(guide.Nodes.Count)..'\\tFAIL_EXPECTED_%d\\n')
 output:close(); print('NATIVE_GROUND_AND_TILEGUIDE_TEST FAIL'); env.Exit(1)
end
output:write('INDEX\\t'..guide.Nodes.Count..'\\tPASS\\n'); output:flush()
local tests=%s
local any_fail=false
for _,test in ipairs(tests) do
 local asset=test.mapId
 local ok,map=pcall(function() return dm.Instance:GetGround(asset) end)
 if not ok or map==nil then
  output:write('GROUND\\t'..asset..'\\tFAIL\\t'..tostring(map)..'\\n')
  output:flush(); any_fail=true
 else
  local metadata_ok=map.Width==test.width and map.Height==test.height and map.TexSize==test.texSize and map.Layers.Count==test.layers
  if not metadata_ok then
   output:write('GROUND\\t'..asset..'\\tFAIL_METADATA\\t'..map.Width..'\\t'..map.Height..'\\t'..map.TexSize..'\\t'..map.Layers.Count..'\\n')
   output:flush(); any_fail=true
  else
   output:write('GROUND\\t'..asset..'\\t'..map.Width..'\\t'..map.Height..'\\t'..map.TexSize..'\\t'..map.Layers.Count..'\\tPASS\\n')
   output:flush()
  end
  local seen={}; local unique=0; local missing=0; local empty_sheet_frames=0; local bad={}
  for li=0,len(map.Layers)-1 do
   local layer=map.Layers[li]
   for x=0,len(layer.Tiles)-1 do
    for y=0,len(layer.Tiles[x])-1 do
     local cell=layer.Tiles[x][y]
     for ai=0,len(cell.Layers)-1 do
      local animation=cell.Layers[ai]
      for fi=0,len(animation.Frames)-1 do
       local frame=animation.Frames[fi]
       local sheet=frame.Sheet; local loc=frame.TexLoc
       if sheet==nil or tostring(sheet)=='' then
        -- Serialized blank frames are transparent/unused; they do not name a
        -- TileSheet and must not be treated as a missing TileGuide coordinate.
        empty_sheet_frames=empty_sheet_frames+1
       else
        local key=tostring(sheet)..':'..tostring(loc.X)..':'..tostring(loc.Y)
        if not seen[key] then
         seen[key]=true; unique=unique+1
         local pos_ok,position=pcall(function() return guide:GetPosition(sheet,loc) end)
         if not pos_ok or position<=0 then
          missing=missing+1
          if #bad<5 then bad[#bad+1]=key..'='..tostring(position) end
         end
        end
       end
      end
     end
    end
   end
  end
  local pass=missing==0
  output:write('TILEGUIDE\\t'..asset..'\\t'..unique..'\\t'..missing..'\\t'..tostring(pass)..'\\t'..table.concat(bad,';')..'\\t'..empty_sheet_frames..'\\n')
  output:flush()
  if not pass then any_fail=true end
 end
end
output:close()
if any_fail then print('NATIVE_GROUND_AND_TILEGUIDE_TEST FAIL'); env.Exit(1) end
print('NATIVE_GROUND_AND_TILEGUIDE_TEST PASS')
env.Exit(0)
""" % (json.dumps(str(index_path)), expected_nodes, expected_nodes, lua_tests(rows))
    return source.encode("utf-8")


def hardlink_or_copy(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    try:
        os.link(source, destination)
    except OSError:
        shutil.copy2(source, destination)


def prepare_mod(manifest: dict) -> None:
    if MOD.exists():
        shutil.rmtree(MOD)
    MOD.mkdir(parents=True)
    for relative in ("Data/Ground", "Content/Tile", "Content/BG"):
        (MOD / relative).mkdir(parents=True, exist_ok=True)
    for row in manifest["maps"]:
        hardlink_or_copy(STAGE / row["groundFile"], MOD / row["groundFile"])
    for relative in manifest["files"]:
        if relative.startswith("Content/Tile/") and relative.endswith(".tile"):
            hardlink_or_copy(STAGE / relative, MOD / relative)
        elif relative.startswith("Content/BG/") and relative.endswith(".dir"):
            hardlink_or_copy(STAGE / relative, MOD / relative)
    hardlink_or_copy(STAGE / "Content/Tile/index.idx", MOD / "Content/Tile/index.idx")
    (MOD / "Mod.xml").write_text(
        f'''<?xml version="1.0" encoding="utf-8"?>\n'''
        f'''<Header><Name>Temporary Destiny 246 TileGuide probe</Name><Author>Arena</Author>'''
        f'''<Description>Ground/TileGuide validation only, not an installable Quest.</Description>'''
        f'''<Namespace>{NAMESPACE}</Namespace>'''
        f'''<UUID>db82f64e-5ce6-54b8-9b2b-834c1c1d6e43</UUID>'''
        f'''<Version>1.0.0.0</Version><GameVersion>0.8.12.0</GameVersion>'''
        f'''<ModType>Quest</ModType><Relationships /></Header>\n''',
        encoding="utf-8",
    )


def validate_stage() -> tuple[dict, list[dict]]:
    manifest_path = STAGE / "manifest.json"
    if not manifest_path.is_file():
        raise SystemExit("Staging TileGuide 246 absent; lancer build_destiny_246_tileguide_stage.py d’abord.")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    maps = manifest.get("maps", [])
    if manifest.get("mapCount") != 246 or len(maps) != 246 or manifest.get("sourceOccurrenceCount") != 262:
        raise ValueError("Le staging TileGuide n’a pas exactement 246 Grounds/262 occurrences.")
    index = STAGE / "Content/Tile/index.idx"
    tile_files = list((STAGE / "Content/Tile").glob("*.tile"))
    if not index.is_file() or len(tile_files) != manifest.get("tileIndexNodeCount"):
        raise ValueError("index.idx ou nombre de .tile incohérent avec le manifeste.")
    for row in maps:
        if not row.get("groundVersion") or not row.get("texSize"):
            raise ValueError(f"Version/TexSize absents du Ground {row.get('mapId')}")
        if not (STAGE / row["groundFile"]).is_file():
            raise FileNotFoundError(STAGE / row["groundFile"])
    return manifest, maps


def main() -> None:
    executable = RUNTIME / "PMDO"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("Runtime PMDO absent dans .cache/pmdo-runtime.")
    if not STARTUP.is_file():
        raise SystemExit(f"Script startup runtime absent: {STARTUP}")
    manifest, maps = validate_stage()
    prepare_mod(manifest)
    original_startup = STARTUP.read_bytes()
    HOME.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["HOME"] = str(HOME)
    result_lines: list[str] = []
    process_rows: list[dict] = []
    started = time.time()
    try:
        for offset in range(0, len(maps), BATCH_SIZE):
            batch = [
                {
                    "mapId": row["mapId"],
                    "width": row["grid"][0],
                    "height": row["grid"][1],
                    "texSize": row["texSize"],
                    "layers": row["layers"],
                }
                for row in maps[offset:offset + BATCH_SIZE]
            ]
            batch_number = offset // BATCH_SIZE + 1
            batch_total = (len(maps) + BATCH_SIZE - 1) // BATCH_SIZE
            if RESULT_IN_RUNTIME.exists():
                RESULT_IN_RUNTIME.unlink()
            try:
                STARTUP.write_bytes(original_startup + b"\n" + make_hook(
                    batch, MOD / "Content/Tile/index.idx", manifest["tileIndexNodeCount"]
                ))
                process = subprocess.run(
                    ["./PMDO", "-guide", "-quest", NAMESPACE],
                    cwd=RUNTIME,
                    env=env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    timeout=300,
                )
            finally:
                STARTUP.write_bytes(original_startup)
            if STARTUP.read_bytes() != original_startup:
                raise RuntimeError("Le startup Lua du runtime n’a pas été restauré.")
            if not RESULT_IN_RUNTIME.is_file():
                tail = process.stdout.decode("utf-8", "replace")[-3000:]
                raise RuntimeError(
                    f"Lot {batch_number} sans rapport runtime (code {process.returncode}):\n{tail}"
                )
            lines = RESULT_IN_RUNTIME.read_text(encoding="utf-8").splitlines()
            result_lines.extend(lines)
            ground_rows = [line for line in lines if line.startswith("GROUND\t")]
            tile_rows = [line for line in lines if line.startswith("TILEGUIDE\t")]
            index_rows = [line for line in lines if line.startswith("INDEX\t")]
            if len(index_rows) != 1 or not index_rows[0].endswith("\tPASS"):
                raise RuntimeError(f"TileGuide.Load échoué au lot {batch_number}: {index_rows}")
            if len(ground_rows) != len(batch) or len(tile_rows) != len(batch):
                raise RuntimeError(
                    f"Rapport incomplet au lot {batch_number}: "
                    f"Ground {len(ground_rows)}/{len(batch)}, TileGuide {len(tile_rows)}/{len(batch)}"
                )
            # GROUND PASS rows end in PASS; TILEGUIDE rows encode true in column 5.
            failures = [row for row in ground_rows if not row.endswith("\tPASS")]
            failures += [row for row in tile_rows if row.split("\t")[4] != "true"]
            batch_summary = {
                "batch": batch_number,
                "maps": len(batch),
                "passed": len(batch) - len(failures),
                "failed": len(failures),
                "failures": failures,
                "processExitCode": process.returncode,
            }
            process_rows.append(batch_summary)
            if failures or process.returncode != 0:
                print(f"PMDO TileGuide : lot {batch_number}/{batch_total}, FAIL {len(failures)}")
            else:
                print(f"PMDO TileGuide : lot {batch_number}/{batch_total}, {len(batch)}/{len(batch)} PASS")
            if RESULT_IN_RUNTIME.exists():
                RESULT_IN_RUNTIME.unlink()

        RESULTS.write_text("\n".join(result_lines) + "\n", encoding="utf-8")
        ground_rows = [line for line in result_lines if line.startswith("GROUND\t")]
        tile_rows = [line for line in result_lines if line.startswith("TILEGUIDE\t")]
        coordinate_count = sum(int(row.split("\t")[2]) for row in tile_rows)
        missing_count = sum(int(row.split("\t")[3]) for row in tile_rows)
        empty_sheet_frames = sum(int(row.split("\t")[6]) for row in tile_rows)
        failed_maps = [row for row in tile_rows if row.split("\t")[4] != "true"]
        failed_ground = [row for row in ground_rows if not row.endswith("\tPASS")]
        summary = {
            "package": str(STAGE),
            "sourceOccurrences": 262,
            "groundOccurrencesTested": len(ground_rows),
            "tileGuideMapsPassed": len(tile_rows) - len(failed_maps),
            "tileGuideMapsFailed": len(failed_maps),
            "uniqueTileCoordinatesChecked": coordinate_count,
            "missingTileCoordinates": missing_count,
            "emptySheetFramesSkippedAsTransparent": empty_sheet_frames,
            "tileSheets": manifest["tileIndexNodeCount"],
            "batches": len(process_rows),
            "batchSizeMaximum": BATCH_SIZE,
            "elapsedSeconds": round(time.time() - started, 1),
            "results": str(RESULTS),
            "summary": str(SUMMARY),
            "rendering": "NOT_TESTED (headless; GraphicsManager GPU/TileIndex not initialized)",
            "playabilityCertified": False,
            "failedGroundMetadata": len(failed_ground),
        }
        SUMMARY.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        if missing_count or failed_maps or failed_ground:
            raise SystemExit(1)
    finally:
        STARTUP.write_bytes(original_startup)
        if RESULT_IN_RUNTIME.exists():
            RESULT_IN_RUNTIME.unlink()
        if MOD.exists():
            shutil.rmtree(MOD)


if __name__ == "__main__":
    main()
