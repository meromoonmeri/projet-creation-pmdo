#!/usr/bin/env python3
"""Run the real PMDO 0.8.12 Ground loader on Destiny batch 01.

Only uses the disposable runtime in .cache/pmdo-runtime. The original
Data/Script/origin/main.lua is always restored. On success, records the native
Ground deserialization results and stamps the delivered ZIP manifest/README.
This is a headless load test, NOT a graphics/editor or gameplay test.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
PACKAGE = ROOT / "exports/pmdo/PMD_Destiny_Exploration_Lot01_0812.zip"
RESULTS = ROOT / "source/pmdo_runtime/destiny_batch01_ground_load_results.tsv"


def lua_hook(maps: list[dict]) -> bytes:
    tests = []
    for row in maps:
        tests.append(
            "{" + ",".join((
                json.dumps(row["assetName"], ensure_ascii=True),
                str(row["grid"][0]), str(row["grid"][1]),
                str(row["layerCount"]),
            )) + "}"
        )
    source = """-- NATIVE_GROUND_TEST: PMDO 0.8.12, headless Ground deserialization.
local env=luanet.import_type('System.Environment')
local gfx=luanet.import_type('RogueEssence.Content.GraphicsManager')
local dm=luanet.import_type('RogueEssence.Data.DataManager')
local output=assert(io.open('destiny_ground_test.tsv','w'))
local ok,err=pcall(function()
  gfx.DungeonTexSize=3 -- normally set during graphics initialization
  local tests={%s}
  for _,test in ipairs(tests) do
    local map=dm.Instance:GetGround(test[1])
    assert(map~=nil,'null ground: '..test[1])
    assert(map.Width==test[2] and map.Height==test[3],
      'wrong dimensions: '..test[1]..' got '..map.Width..'x'..map.Height)
    assert(map.TexSize==1,'wrong TexSize: '..test[1])
    assert(map.Layers.Count==test[4],'wrong layer count: '..test[1])
    assert(map.Entities.Count>0,'missing entity layer: '..test[1])
    output:write(test[1]..'\\t'..map.Width..'\\t'..map.Height..'\\t'..
      map.Layers.Count..'\\t'..map.Entities.Count..'\\tPASS\\n')
    output:flush()
  end
end)
if not ok then output:write('FAIL\\t'..tostring(err)..'\\n') end
output:close()
print('NATIVE_GROUND_TEST '..(ok and 'PASS' or tostring(err)))
env.Exit(ok and 0 or 1)
""" % (",\n    ".join(tests))
    return source.encode("utf-8")


def safe_extract(package: Path, mods: Path) -> dict:
    with zipfile.ZipFile(package) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"ZIP source corrompu: {bad}")
        members = archive.namelist()
        for name in members:
            target = (mods / name).resolve()
            if not target.is_relative_to(mods.resolve()):
                raise ValueError(f"Chemin ZIP interdit: {name}")
        archive.extractall(mods)
        return json.loads(archive.read("destiny/manifest.json"))


def stamp_package(package: Path, results_text: str, passed: int) -> None:
    with zipfile.ZipFile(package, "r") as archive:
        files = {name: archive.read(name) for name in archive.namelist() if not name.endswith("/")}
    manifest_path = "destiny/manifest.json"
    readme_path = "destiny/README.md"
    results_path = "destiny/Documentation/runtime_ground_load_results.tsv"
    manifest = json.loads(files[manifest_path])
    manifest.setdefault("validation", {})["runtimePMDOTested"] = True
    manifest["validation"]["nativeGroundDeserialization"] = "PASS"
    manifest["runtimeTest"] = {
        "engine": "PMDO 0.8.12.0 Linux x64",
        "method": "PMDO -guide -quest destiny; real DataManager.Instance:GetGround calls",
        "mapsPassed": passed,
        "graphicsInitializedForCollisionDeserialization": "GraphicsManager.DungeonTexSize=3",
        "graphicsRenderingTested": False,
        "editorOpened": False,
        "gameplayTransitionsTested": False,
    }
    files[results_path] = results_text.encode("utf-8")
    readme = files[readme_path].decode("utf-8")
    old = (
        "Le jeu PMDO n’a pas été lancé dans cet environnement: la validation est statique, "
        "pas un test runtime."
    )
    new = (
        "**Le chargeur natif PMDO 0.8.12 a chargé les neuf Ground (PASS).** Le test est "
        "headless et vérifie leur désérialisation, dimensions, calques et couche d’entités; "
        "il ne valide pas le rendu graphique, l’éditeur ni les transitions de quête."
    )
    if old in readme:
        readme = readme.replace(old, new)
    elif new not in readme:
        readme += "\n\n" + new + "\n"
    files[readme_path] = readme.encode("utf-8")
    manifest["files"] = {
        name.removeprefix("destiny/"): hashlib.sha256(data).hexdigest()
        for name, data in sorted(files.items())
        if name.startswith("destiny/") and name != manifest_path
    }
    files[manifest_path] = (json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
    temp = package.with_suffix(package.suffix + ".verified.tmp")
    try:
        with zipfile.ZipFile(temp, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as output:
            for name, data in sorted(files.items()):
                info = zipfile.ZipInfo(name, date_time=(2026, 10, 29, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o644 << 16
                output.writestr(info, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        with zipfile.ZipFile(temp) as output:
            if output.testzip():
                raise ValueError("CRC invalide après l’ajout du rapport runtime")
            checked = json.loads(output.read(manifest_path))
            if not checked["validation"]["runtimePMDOTested"]:
                raise ValueError("Le package n’a pas reçu son statut runtime")
        temp.replace(package)
    finally:
        if temp.exists():
            temp.unlink()


def main() -> None:
    executable = RUNTIME / "PMDO"
    startup = RUNTIME / "Data/Script/origin/main.lua"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("PMDO 0.8.12 runtime absent. Voir source/pmdo_runtime/README.md.")
    if not (RUNTIME / "Base/PathParams.xml").is_file() or not startup.is_file():
        raise SystemExit("Base/Script PMDO absent dans .cache/pmdo-runtime.")
    if not PACKAGE.is_file():
        raise SystemExit(f"Package absent: {PACKAGE}; construire d’abord le lot 01.")

    mods = RUNTIME / "MODS"
    mods.mkdir(parents=True, exist_ok=True)
    mod = mods / "destiny"
    if mod.exists():
        shutil.rmtree(mod)
    manifest = safe_extract(PACKAGE, mods)
    maps = manifest.get("maps", [])
    if len(maps) != 9:
        raise ValueError(f"Le manifeste annonce {len(maps)} cartes, attendu 9")

    original = startup.read_bytes()
    result_path = RUNTIME / "destiny_ground_test.tsv"
    if result_path.exists():
        result_path.unlink()
    hook = lua_hook(maps)
    log_path = ROOT / ".cache/pmdo-runtime/destiny-batch01.log"
    home = ROOT / ".cache/pmdo-runtime/home-destiny-batch01"
    home.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["HOME"] = str(home)
    try:
        startup.write_bytes(original + b"\n" + hook)
        process = subprocess.run(
            ["./PMDO", "-guide", "-quest", "destiny"],
            cwd=RUNTIME, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            timeout=180,
        )
        log_path.write_bytes(process.stdout)
    finally:
        startup.write_bytes(original)
    if startup.read_bytes() != original:
        raise RuntimeError("Le script de démarrage original n’a pas été restauré")
    if process.returncode != 0:
        raise RuntimeError(
            f"PMDO a échoué ({process.returncode}); voir {log_path}:\n"
            + process.stdout.decode("utf-8", "replace")[-4000:]
        )
    if not result_path.is_file():
        raise RuntimeError(f"PMDO n’a pas écrit le résultat: {result_path}")
    results_text = result_path.read_text(encoding="utf-8")
    rows = [line for line in results_text.splitlines() if line]
    if len(rows) != 9 or any(not line.endswith("\tPASS") for line in rows):
        raise RuntimeError(f"Résultat natif incomplet; voir {result_path}:\n{results_text}")
    RESULTS.write_text(results_text, encoding="utf-8")
    stamp_package(PACKAGE, results_text, len(rows))
    print(f"PASS — {len(rows)} Ground chargés par le vrai PMDO 0.8.12.")
    print(f"Résultats: {RESULTS.relative_to(ROOT)}")
    print(f"Package actualisé: {PACKAGE.relative_to(ROOT)} ({PACKAGE.stat().st_size} octets)")
    print("Limites: rendu graphique, éditeur et transitions de quête non testés.")


if __name__ == "__main__":
    main()
