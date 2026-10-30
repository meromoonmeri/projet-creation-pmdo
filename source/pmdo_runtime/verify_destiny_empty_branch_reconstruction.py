#!/usr/bin/env python3
"""Probe five source-derived Grounds and their native TileIndex in PMDO 0.8.12.

The test uses only the ignored staging payload created by
source/pmdo_cote/reconstruct_empty_branch_grounds.py. It runs a disposable Quest
in .cache/pmdo-runtime, calls DataManager.GetGround, parses Content/Tile/index.idx
with PMDO's TileGuide.Load, and resolves every distinct Ground frame coordinate.
It does not initialize GraphicsManager.TileIndex/GPU, render graphics, or certify
in-game movement/collisions. The original runtime startup script is restored in
all cases and the disposable MOD is removed.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
PAYLOAD = ROOT / ".cache/destiny-recovery/empty_ground_reconstructed_native"
RESULTS = ROOT / "source/pmdo_runtime/destiny_empty_branch_reconstruction_0812_results.tsv"
NAMESPACE = "destiny_empty_branch_reconstruction_probe"
MOD = RUNTIME / "MODS" / NAMESPACE
STARTUP = RUNTIME / "Data/Script/origin/main.lua"
RESULT_IN_RUNTIME = RUNTIME / "destiny_empty_branch_reconstruction_probe.tsv"
HOME = ROOT / ".cache/pmdo-runtime/home-destiny-branch-probe"


def lua_tests(map_ids: list[str]) -> str:
    return "{" + ",".join(json.dumps(map_id) for map_id in map_ids) + "}"


def make_hook(map_ids: list[str]) -> bytes:
    index_path = json.dumps(str(MOD / "Content/Tile/index.idx"))
    source = """-- NATIVE_GROUND_AND_TILEINDEX_TEST: headless, PMDO 0.8.12
local env=luanet.import_type('System.Environment')
local gfx=luanet.import_type('RogueEssence.Content.GraphicsManager')
local dm=luanet.import_type('RogueEssence.Data.DataManager')
local file=luanet.import_type('System.IO.File')
local BinaryReader=luanet.import_type('System.IO.BinaryReader')
local TileGuide=luanet.import_type('RogueEssence.Content.TileGuide')
local output=assert(io.open('destiny_empty_branch_reconstruction_probe.tsv','w'))
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
 output:close(); print('NATIVE_GROUND_AND_TILEINDEX_TEST FAIL'); env.Exit(1)
end
output:write('INDEX\\t'..guide.Nodes.Count..'\\tPASS\\n'); output:flush()
local tests=%s
for _,asset in ipairs(tests) do
 local ok,map=pcall(function() return dm.Instance:GetGround(asset) end)
 if not ok or map==nil then
  output:write('GROUND\\t'..asset..'\\tFAIL\\t'..tostring(map)..'\\n')
  output:flush()
 else
  assert(map.Width==96 and map.Height==72,'wrong dimensions: '..asset)
  assert(map.TexSize==1,'wrong TexSize: '..asset)
  assert(map.Layers.Count>=7 and map.Layers.Count<=9,'wrong layer count: '..asset)
  output:write('GROUND\\t'..asset..'\\t'..map.Width..'\\t'..map.Height..'\\t'..map.Layers.Count..'\\tPASS\\n')
  output:flush()
  local seen={}; local unique=0; local missing=0
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
       local key=sheet..':'..tostring(loc.X)..':'..tostring(loc.Y)
       if not seen[key] then
        seen[key]=true; unique=unique+1
        local position=guide:GetPosition(sheet,loc)
        if position<=0 then missing=missing+1 end
       end
      end
     end
    end
   end
  end
  output:write('TILEINDEX\\t'..asset..'\\t'..unique..'\\t'..missing..'\\t'..tostring(missing==0)..'\\n')
  output:flush()
  assert(missing==0,'TileIndex missing frame coordinate(s): '..asset)
 end
end
output:close(); print('NATIVE_GROUND_AND_TILEINDEX_TEST PASS'); env.Exit(0)
""" % (index_path, lua_tests(map_ids))
    return source.encode("utf-8")


def validate_payload() -> tuple[dict, list[str]]:
    manifest_path = PAYLOAD / "Documentation/reconstruction_manifest.json"
    if not manifest_path.is_file():
        raise SystemExit(
            "Payload reconstruit absent; lancer d’abord "
            "source/pmdo_cote/reconstruct_empty_branch_grounds.py avec Pillow."
        )
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    grounds = sorted((PAYLOAD / "Data/Ground").glob("*.rsground"))
    tiles = sorted((PAYLOAD / "Content/Tile").glob("*.tile"))
    if len(grounds) != 5 or len(tiles) != 33 or not (PAYLOAD / "Content/Tile/index.idx").is_file():
        raise ValueError(f"Payload incomplet : {len(grounds)} Grounds, {len(tiles)} tilesheets")
    map_ids = []
    for ground in grounds:
        data = json.loads(ground.read_text(encoding="utf-8-sig"))
        if data.get("Object", {}).get("AssetName") != ground.stem:
            raise ValueError(f"AssetName Ground différent du fichier : {ground.name}")
        map_ids.append(ground.stem)
    return manifest, map_ids


def main() -> None:
    executable = RUNTIME / "PMDO"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("Runtime PMDO absent dans .cache/pmdo-runtime.")
    if not STARTUP.is_file():
        raise SystemExit(f"Script startup runtime absent : {STARTUP}")
    manifest, map_ids = validate_payload()
    if manifest.get("sourceCommit") != "c2d77959d87bf334e9603b47df012bc4f1e3dd7a":
        raise ValueError("Commit source non conforme dans le manifeste de reconstruction.")

    if MOD.exists():
        shutil.rmtree(MOD)
    (MOD / "Data/Ground").mkdir(parents=True)
    (MOD / "Content/Tile").mkdir(parents=True)
    for source in (PAYLOAD / "Data/Ground").glob("*.rsground"):
        shutil.copy2(source, MOD / "Data/Ground" / source.name)
    for source in (PAYLOAD / "Content/Tile").glob("*.tile"):
        shutil.copy2(source, MOD / "Content/Tile" / source.name)
    shutil.copy2(PAYLOAD / "Content/Tile/index.idx", MOD / "Content/Tile/index.idx")
    (MOD / "Mod.xml").write_text(
        f'''<?xml version="1.0" encoding="utf-8"?>\n'''
        f'''<Header><Name>Temporary Destiny source-grid probe</Name><Author>Arena</Author>'''
        f'''<Description>PMDO 0.8.12 Ground/TileIndex test only.</Description>'''
        f'''<Namespace>{NAMESPACE}</Namespace>'''
        f'''<UUID>df9322c3-fc6b-4822-98b5-2c3fa99fc143</UUID>'''
        f'''<Version>1.0.0.0</Version><GameVersion>0.8.12.0</GameVersion>'''
        f'''<ModType>Quest</ModType><Relationships /></Header>\n''',
        encoding="utf-8",
    )

    original = STARTUP.read_bytes()
    HOME.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["HOME"] = str(HOME)
    try:
        if RESULT_IN_RUNTIME.exists():
            RESULT_IN_RUNTIME.unlink()
        try:
            STARTUP.write_bytes(original + b"\n" + make_hook(map_ids))
            process = subprocess.run(
                ["./PMDO", "-guide", "-quest", NAMESPACE],
                cwd=RUNTIME,
                env=env,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=180,
            )
        finally:
            STARTUP.write_bytes(original)
        if STARTUP.read_bytes() != original:
            raise RuntimeError("Le script startup original n'a pas été restauré.")
        if process.returncode != 0 or not RESULT_IN_RUNTIME.is_file():
            tail = process.stdout.decode("utf-8", "replace")[-4000:]
            raise RuntimeError(f"Probe PMDO en échec ({process.returncode}) :\n{tail}")
        lines = RESULT_IN_RUNTIME.read_text(encoding="utf-8").splitlines()
        if not lines or lines[0].split(chr(9)) != ["INDEX", "33", "PASS"]:
            raise RuntimeError(f"TileGuide natif non validé : {lines[:2]}")
        ground_rows = [line for line in lines if line.split(chr(9))[0] == "GROUND"]
        tile_rows = [line for line in lines if line.split(chr(9))[0] == "TILEINDEX"]
        if len(ground_rows) != 5 or any(line.split(chr(9))[-1] != "PASS" for line in ground_rows):
            raise RuntimeError(f"Grounds incomplets/échoués : {ground_rows}")
        if len(tile_rows) != 5 or any(line.split(chr(9))[-1] != "true" for line in tile_rows):
            raise RuntimeError(f"TileIndex incomplet/échoué : {tile_rows}")
        RESULTS.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print("PASS — PMDO 0.8.12 : 5/5 Grounds chargés, TileGuide 33 sheets, toutes les coordonnées résolues.")
        print(f"Rapport : {RESULTS.relative_to(ROOT)}")
        print("Limites : aucun rendu graphique ni parcours/collision en jeu n'a été testé.")
    finally:
        STARTUP.write_bytes(original)
        if RESULT_IN_RUNTIME.exists():
            RESULT_IN_RUNTIME.unlink()
        if MOD.exists():
            shutil.rmtree(MOD)


if __name__ == "__main__":
    main()
