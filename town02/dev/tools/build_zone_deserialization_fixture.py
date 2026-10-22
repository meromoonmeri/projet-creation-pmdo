#!/usr/bin/env python3
"""Build an ignored full-Zone overlay for PMDO 0.8.12 deserialization."""

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
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_narrative_fixture.py"
SPEC = importlib.util.spec_from_file_location("narrative_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

MIGRATED_ZONES = (
    "chasm_cave", "dark_hill", "dusk_forest",
    "sealed_ruin", "sealed_ruin_pit", "spiritomb_room",
)
LEGACY = (
    "RogueElements.FloorStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],"
    "[RogueElements.TeamSpawner, RogueElements],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence]], RogueElements"
)
CURRENT = (
    "RogueElements.FloorStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"
)
LEGACY_DETECT = (
    "RogueElements.DetectIsolatedStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
    "[RogueEssence.Dungeon.StairsTile, RogueEssence]], RogueElements"
)
CURRENT_DETECT = (
    "RogueElements.DetectIsolatedStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"
)
LEGACY_WATER_STENCIL = "RogueElements.WaterTerrainStencil, RogueElements"
CURRENT_WATER_STENCIL = (
    '"$type": "RogueElements.MapTerrainStencil`1'
    '[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",\n'
    '          "Room": false,\n          "Wall": true,\n'
    '          "Blocked": false,\n          "Not": false'
)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def install_runtime_probe(quest: Path) -> None:
    """Install a fixture-local Init service that resolves all migrated Zones."""
    main_path = quest / "Data/Script/halcyon/main.lua"
    if main_path.is_symlink():
        main_path.unlink()
    main_text = (ROOT / "Data/Script/halcyon/main.lua").read_text()
    main_path.write_text(main_text + "\nrequire 'halcyon.services.zone_deserialization_probe'\n")
    probe_path = quest / "Data/Script/halcyon/services/zone_deserialization_probe/init.lua"
    probe_path.parent.mkdir(parents=True, exist_ok=True)
    zone_ids = ", ".join(f'"{zone}"' for zone in MIGRATED_ZONES)
    probe_path.write_text(f'''require 'origin.common'\n'''
        f'''require 'origin.services.baseservice'\n'''
        f'''local IDS = {{{zone_ids}}}\n'''
        f'''local ZoneProbe = Class('ZoneDeserializationProbe', BaseService)\n'''
        f'''function ZoneProbe:initialize()\n'''
        f'''  BaseService.initialize(self)\n'''
        f'''  self.enabled = os.getenv("PMDO_ZONE_DESERIALIZATION_PROBE") == "1"\n'''
        f'''end\n'''
        f'''function ZoneProbe:OnInit()\n'''
        f'''  if not self.enabled then return end\n'''
        f'''  for _, id in ipairs(IDS) do\n'''
        f'''    local zone = _DATA:GetZone(id)\n'''
        f'''    assert(zone ~= nil, "Zone absente apres indexation: " .. id)\n'''
        f'''    PrintInfo("[ZONE_DESERIALIZATION_PROBE] resolved " .. id)\n'''
        f'''  end\n'''
        f'''  PrintInfo("[ZONE_DESERIALIZATION_PROBE] PASS")\n'''
        f'''  local f=io.open("/tmp/pmdo_0812_zone_deserialization.jsonl", "w")\n'''
        f'''  if f then f:write('{{"event":"end","normal_unload_requested":true}}\\n');f:flush();f:close() end\n'''
        f'''  RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload\n'''
        f'''end\n'''
        f'''function ZoneProbe:Subscribe(med)\n'''
        f'''  med:Subscribe("ZoneDeserializationProbe", EngineServiceEvents.Init, function() self:OnInit() end)\n'''
        f'''end\n'''
        f'''function ZoneProbe:UnSubscribe(med) end\n'''
        f'''SCRIPT:AddService("ZoneDeserializationProbe", ZoneProbe:new())\n'''
        f'''return ZoneProbe\n''')


def build(output: Path) -> Path:
    quest = BASE.build(output)
    install_runtime_probe(quest)
    fixture_zone = quest / "Data/Zone"
    shutil.rmtree(fixture_zone)
    shutil.copytree(ROOT / "Data/Zone", fixture_zone)
    floor_legacy_count = 0
    floor_current_count = 0
    detect_legacy_count = 0
    detect_current_count = 0
    water_legacy_count = 0
    wall_stencil_count = 0
    migrated_hashes = {}
    for zone in MIGRATED_ZONES:
        path = ROOT / "Data/Zone" / f"{zone}.json"
        text = path.read_text(encoding="utf-8-sig")
        floor_legacy_count += text.count(LEGACY)
        floor_current_count += text.count(CURRENT)
        detect_legacy_count += text.count(LEGACY_DETECT)
        detect_current_count += text.count(CURRENT_DETECT)
        water_legacy_count += text.count(LEGACY_WATER_STENCIL)
        wall_stencil_count += text.count(CURRENT_WATER_STENCIL)
        migrated_hashes[str(path.relative_to(ROOT))] = sha256_file(path)
    counts = (
        floor_legacy_count, floor_current_count,
        detect_legacy_count, detect_current_count,
        water_legacy_count, wall_stencil_count,
    )
    if counts != (0, 46, 0, 46, 0, 37):
        raise ValueError(f"Zone type migration inventory differs: {counts}")
    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    manifest.update({
        "schema": "new-era.zone-deserialization-runtime-fixture.v1",
        "scope": "all tracked Zone JSON files copied fixture-locally for PMDO 0.8.12 indexing",
        "zone_file_count": len(list((ROOT / "Data/Zone").glob("*.json"))),
        "migrated_zones": list(MIGRATED_ZONES),
        "migrated_floor_stairs_step_count": floor_current_count,
        "legacy_floor_stairs_step_count": floor_legacy_count,
        "migrated_detect_isolated_stairs_step_count": detect_current_count,
        "legacy_detect_isolated_stairs_step_count": detect_legacy_count,
        "migrated_water_stencil_count": wall_stencil_count,
        "legacy_water_stencil_count": water_legacy_count,
        "migrated_hashes": migrated_hashes,
        "fixture_zone_symlinks": [
            str(path.relative_to(quest)) for path in fixture_zone.rglob("*") if path.is_symlink()
        ],
    })
    if manifest["fixture_zone_symlinks"]:
        raise ValueError("full-Zone fixture contains source symlinks")
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/zone-deserialization-fixture"),
    )
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
