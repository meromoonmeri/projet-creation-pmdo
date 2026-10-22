#!/usr/bin/env python3
"""Build an ignored PMDO fixture for Relic Forest blob dependencies."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_zone_deserialization_fixture.py"
SPEC = importlib.util.spec_from_file_location("zone_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

MAP_IDS = (
    "relic_forest_blob_broken_pillar",
    "relic_forest_blob_fallen_left",
    "relic_forest_blob_fallen_right",
    "relic_forest_blob_pillar",
    "relic_forest_blob_rubble",
    "relic_forest_blob_ruins",
)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def install_probe(quest: Path) -> None:
    main_path = quest / "Data/Script/halcyon/main.lua"
    main_path.write_text(
        main_path.read_text() + "\nrequire 'halcyon.services.relic_forest_blob_probe'\n"
    )
    probe_path = quest / "Data/Script/halcyon/services/relic_forest_blob_probe/init.lua"
    probe_path.parent.mkdir(parents=True, exist_ok=True)
    ids = ", ".join(f'"{map_id}"' for map_id in MAP_IDS)
    probe_path.write_text(f'''require 'origin.common'\n'''
        f'''require 'origin.services.baseservice'\n'''
        f'''local IDS={{{ids}}}\n'''
        f'''local V=Class('RelicForestBlobProbe',BaseService)\n'''
        f'''function V:initialize()\n'''
        f'''  BaseService.initialize(self)\n'''
        f'''  self.enabled=os.getenv("PMDO_RELIC_FOREST_BLOB_PROBE")=="1"\n'''
        f'''  self.started=false\n'''
        f'''end\n'''
        f'''function V:OnInit()\n'''
        f'''  if not self.enabled then return end\n'''
        f'''  for _,id in ipairs(IDS) do\n'''
        f'''    local map=_DATA:GetMap(id)\n'''
        f'''    assert(map~=nil and map.Width>0 and map.Height>0,"Map blob absente: "..id)\n'''
        f'''    PrintInfo("[RELIC_FOREST_BLOB_PROBE] resolved "..id.." "..map.Width.."x"..map.Height)\n'''
        f'''  end\n'''
        f'''  RogueEssence.GameManager.Instance:NewGamePlus(812)\n'''
        f'''end\n'''
        f'''function V:OnNewGame()\n'''
        f'''  if not self.enabled or self.started then return end\n'''
        f'''  self.started=true\n'''
        f'''  PrintInfo("[RELIC_FOREST_BLOB_PROBE] entering relic_forest segment=0 floor=0")\n'''
        f'''  GAME:EnterZone("relic_forest",0,0,0)\n'''
        f'''end\n'''
        f'''function V:OnDungeonMapInit()\n'''
        f'''  if not self.enabled or not self.started then return end\n'''
        f'''  assert(tostring(_ZONE.CurrentZoneID)=="relic_forest","Zone runtime inattendue")\n'''
        f'''  local map=_ZONE.CurrentMap\n'''
        f'''  assert(map~=nil and map.ActiveTeam~=nil,"Carte ou equipe runtime absente")\n'''
        f'''  PrintInfo("[RELIC_FOREST_BLOB_PROBE] floor generated "..map.Width.."x"..map.Height)\n'''
        f'''  PrintInfo("[RELIC_FOREST_BLOB_PROBE] PASS")\n'''
        f'''  local f=io.open("/tmp/relic_forest_blob_probe.jsonl","w")\n'''
        f'''  if f then f:write('{{"event":"end","normal_unload_requested":true}}\\n');f:flush();f:close() end\n'''
        f'''  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload\n'''
        f'''end\n'''
        f'''function V:Subscribe(med)\n'''
        f'''  med:Subscribe("RelicForestBlobProbe",EngineServiceEvents.Init,function()self:OnInit()end)\n'''
        f'''  med:Subscribe("RelicForestBlobProbe",EngineServiceEvents.NewGame,function()self:OnNewGame()end)\n'''
        f'''  med:Subscribe("RelicForestBlobProbe",EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)\n'''
        f'''end\n'''
        f'''function V:UnSubscribe(med)end\n'''
        f'''SCRIPT:AddService("RelicForestBlobProbe",V:new())\n'''
        f'''return V\n''')


def build(output: Path) -> Path:
    quest = BASE.build(output)
    install_probe(quest)
    map_hashes = {}
    for map_id in MAP_IDS:
        source = ROOT / "Data/Map" / f"{map_id}.rsmap"
        exposed = quest / "Data/Map" / source.name
        if not source.is_file() or not exposed.is_symlink() or exposed.resolve() != source.resolve():
            raise ValueError(f"fixture Map dependency is not a source symlink: {map_id}")
        map_hashes[str(source.relative_to(ROOT))] = sha256_file(source)
    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    manifest.update({
        "schema": "new-era.relic-forest-blob-runtime-fixture.v1",
        "scope": "resolve six LoadBlobStep Maps and generate Relic Forest B1F",
        "blob_map_ids": list(MAP_IDS),
        "blob_map_hashes": map_hashes,
    })
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/relic-forest-blob-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
