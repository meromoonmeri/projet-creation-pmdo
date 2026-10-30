#!/usr/bin/env python3
"""Load the new Destiny cartotheque ZoneData in the real PMDO 0.8.12 runtime."""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
STARTUP = RUNTIME / "Data/Script/origin/main.lua"
MODS = RUNTIME / "MODS"
ZONE_ID = "exploration_cartes"
EXPECTED_GROUNDS = 246
DEFAULT_QUEST = ROOT / ".cache/destiny-recovery/destiny-map-quest-246/destiny"
DEFAULT_RESULTS = ROOT / "source/pmdo_runtime/destiny_map_quest_246_zone_runtime_results.tsv"


def make_hook(result_file: str) -> bytes:
    source = """-- DESTINY_CARTOTHEQUE_ZONE_PROBE
local env=luanet.import_type('System.Environment')
local output=assert(io.open('%s','w'))
local ok,err=pcall(function()
  local zone=_DATA:GetZone('%s')
  assert(zone~=nil,'GetZone returned nil')
  assert(zone.GroundMaps~=nil,'GroundMaps is nil')
  assert(zone.Segments~=nil,'Segments is nil')
  local groundCount=zone.GroundMaps.Count
  local segmentCount=zone.Segments.Count
  assert(groundCount==%d,'expected %d GroundMaps, got '..tostring(groundCount))
  assert(segmentCount==0,'expected 0 narrative segments, got '..tostring(segmentCount))
  output:write('zone\\t%s\\tPASS\\n')
  output:write('groundMaps\\t'..tostring(groundCount)..'\\tPASS\\n')
  output:write('segments\\t'..tostring(segmentCount)..'\\tPASS\\n')
end)
if not ok then
  output:write('zone\\t%s\\tFAIL\\t'..tostring(err):gsub('[\\r\\n\\t]',' ')..'\\n')
end
output:close()
print('DESTINY_CARTOTHEQUE_ZONE_PROBE '..(ok and 'PASS' or 'FAIL'))
env.Exit(ok and 0 or 1)
""" % (result_file, ZONE_ID, EXPECTED_GROUNDS, EXPECTED_GROUNDS, ZONE_ID, ZONE_ID)
    return source.encode("utf-8")


def verify(quest: Path, results: Path) -> dict:
    quest = quest.resolve()
    results = results.resolve()
    executable = RUNTIME / "PMDO"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("Runtime PMDO 0.8.12 absent; voir source/pmdo_runtime/README.md.")
    if not STARTUP.is_file() or not (RUNTIME / "Base/PathParams.xml").is_file():
        raise SystemExit("Fichiers DataManager/runtime de base absents.")
    mod_xml = quest / "Mod.xml"
    if not mod_xml.is_file():
        raise FileNotFoundError(mod_xml)
    header = ET.parse(mod_xml).getroot()
    if (header.findtext("Namespace") or "").strip() != "destiny":
        raise ValueError("La quête à tester ne porte pas le namespace destiny.")
    if (header.findtext("GameVersion") or "").strip() != "0.8.12.0":
        raise ValueError("La quête à tester ne vise pas PMDO 0.8.12.0.")

    mod_path = MODS / "destiny"
    if mod_path.exists() or mod_path.is_symlink():
        raise FileExistsError(f"Le runtime possède déjà un MODS/destiny; refus d'écraser : {mod_path}")
    mod_path.symlink_to(quest, target_is_directory=True)
    result_in_runtime = RUNTIME / "destiny_cartotheque_zone_probe.tsv"
    log_path = RUNTIME / "LOG/destiny_cartotheque_zone_probe.log"
    original = STARTUP.read_bytes()
    env = os.environ.copy()
    env["HOME"] = str(ROOT / ".cache/pmdo-runtime/home-destiny-cartotheque-zone")
    Path(env["HOME"]).mkdir(parents=True, exist_ok=True)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    try:
        result_in_runtime.unlink(missing_ok=True)
        STARTUP.write_bytes(original + b"\n" + make_hook(result_in_runtime.name))
        try:
            process = subprocess.run(
                ["./PMDO", "-guide", "-quest", "destiny"],
                cwd=RUNTIME,
                env=env,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=300,
            )
        finally:
            STARTUP.write_bytes(original)
        log_path.write_bytes(process.stdout)
        if STARTUP.read_bytes() != original:
            raise RuntimeError("Le main.lua original n'a pas été restauré.")
        if not result_in_runtime.is_file():
            tail = process.stdout.decode("utf-8", "replace")[-4000:]
            raise RuntimeError(f"Pas de résultat Zone PMDO (code {process.returncode}):\n{tail}")
        rows = [line.split("\t") for line in result_in_runtime.read_text(encoding="utf-8").splitlines()]
        if process.returncode != 0 or len(rows) != 3 or any(row[2] != "PASS" for row in rows):
            raise RuntimeError(f"Le probe Zone a échoué: {rows}; exit={process.returncode}")
        results.parent.mkdir(parents=True, exist_ok=True)
        results.write_text(
            "test\tvalue\tstatus\n" + "".join("\t".join(row) + "\n" for row in rows),
            encoding="utf-8",
        )
        return {"zone": ZONE_ID, "groundMaps": EXPECTED_GROUNDS, "segments": 0,
                "runtime": "PMDO 0.8.12.0", "status": "PASS", "results": str(results)}
    finally:
        STARTUP.write_bytes(original)
        result_in_runtime.unlink(missing_ok=True)
        if mod_path.is_symlink():
            mod_path.unlink()
        elif mod_path.exists():
            raise RuntimeError(f"La cible runtime n'est plus un symlink; refus de la supprimer : {mod_path}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--quest", type=Path, default=DEFAULT_QUEST)
    parser.add_argument("--results", type=Path, default=DEFAULT_RESULTS)
    args = parser.parse_args()
    print(verify(args.quest, args.results))


if __name__ == "__main__":
    main()
