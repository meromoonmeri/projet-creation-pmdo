#!/usr/bin/env python3
"""Load every Ground in the 208-map Destiny catalogue with real PMDO 0.8.12.

Runs bounded batches to avoid retaining hundreds of Ground objects at once.
Only touches .cache/pmdo-runtime; the original startup Lua is restored after
EVERY engine invocation. Successful results are written to the repo and stamped
into the generated ZIP manifest/README. This is native deserialization, not a
graphics/editor/warps test.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
PACKAGE = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
RESULTS = ROOT / "source/pmdo_runtime/destiny_catalogue_208_ground_load_results.tsv"
BATCH_SIZE = 20


def make_hook(rows: list[dict]) -> bytes:
    tests = []
    for row in rows:
        tests.append("{" + ",".join((
            json.dumps(row["mapId"], ensure_ascii=True),
            str(row["grid"][0]), str(row["grid"][1]), str(row["layers"]),
        )) + "}")
    source = """-- NATIVE_GROUND_TEST: PMDO 0.8.12.0 headless deserialization.
local env=luanet.import_type('System.Environment')
local gfx=luanet.import_type('RogueEssence.Content.GraphicsManager')
local dm=luanet.import_type('RogueEssence.Data.DataManager')
local output=assert(io.open('destiny_ground_test.tsv','w'))
local ok,err=pcall(function()
  gfx.DungeonTexSize=3 -- required by the headless collision-grid loader
  local tests={%s}
  for _,test in ipairs(tests) do
    local map=dm.Instance:GetGround(test[1])
    assert(map~=nil,'null Ground: '..test[1])
    assert(map.Width==test[2] and map.Height==test[3],
      'wrong dimensions: '..test[1]..' '..map.Width..'x'..map.Height)
    assert(map.TexSize==1,'wrong TexSize: '..test[1])
    assert(map.Layers.Count==test[4],'wrong layer count: '..test[1])
    output:write(test[1]..'\\t'..map.Width..'\\t'..map.Height..'\\t'..
      map.Layers.Count..'\\tPASS\\n')
    output:flush()
  end
end)
if not ok then output:write('FAIL\\t'..tostring(err)..'\\n') end
output:close()
print('NATIVE_GROUND_TEST '..(ok and 'PASS' or tostring(err)))
env.Exit(ok and 0 or 1)
""" % (",\n    ".join(tests))
    return source.encode("utf-8")


def install_mod() -> dict:
    if not PACKAGE.is_file():
        raise SystemExit(f"Package absent: {PACKAGE}; construire d’abord le catalogue.")
    mods = RUNTIME / "MODS"
    mods.mkdir(parents=True, exist_ok=True)
    destination = mods / "destiny"
    if destination.exists():
        shutil.rmtree(destination)
    with zipfile.ZipFile(PACKAGE) as archive:
        names = archive.namelist()
        for name in names:
            target = (mods / name).resolve()
            if not target.is_relative_to(mods.resolve()):
                raise ValueError(f"Chemin ZIP dangereux: {name}")
        manifest = json.loads(archive.read("destiny/manifest.json"))
        archive.extractall(mods)
    if len(manifest.get("maps", [])) != 208:
        raise ValueError(f"Manifeste non conforme: {len(manifest.get('maps', []))} maps")
    return manifest


def stamp_package(results_text: str, passed: int, batches: int) -> None:
    temp = PACKAGE.with_suffix(PACKAGE.suffix + ".verified.tmp")
    manifest_path = "destiny/manifest.json"
    readme_path = "destiny/README.md"
    result_path = "destiny/Documentation/runtime_ground_load_results.tsv"
    result_bytes = results_text.encode("utf-8")
    hashes: dict[str, dict[str, object]] = {}
    try:
        with zipfile.ZipFile(PACKAGE, "r") as source, zipfile.ZipFile(
            temp, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9, allowZip64=True
        ) as output:
            manifest = json.loads(source.read(manifest_path))
            readme = source.read(readme_path).decode("utf-8")
            old = (
                "Le chargeur natif PMDO 0.8.12 et le test de rendu graphique sont consignés après vérification; "
                "ce ZIP n’ajoute pas de connexion de scénario entre les cartes."
            )
            new = (
                f"Le chargeur natif PMDO 0.8.12.0 a chargé **{passed}/{passed} Ground (PASS)** "
                f"en {batches} lots headless. Dimensions, `TexSize=1` et nombre de calques vérifiés. "
                "Cela ne valide pas le rendu graphique, l’éditeur ni les transitions de quête. "
                "Le rapport est dans `Documentation/runtime_ground_load_results.tsv`."
            )
            if old in readme:
                readme = readme.replace(old, new)
            elif new not in readme:
                readme += "\n\n" + new + "\n"
            manifest.setdefault("validation", {})["runtimePMDOTested"] = True
            manifest["validation"]["nativeGroundDeserialization"] = "PASS"
            manifest["runtimeTest"] = {
                "engine": "PMDO 0.8.12.0 Linux x64",
                "method": "PMDO -guide -quest destiny; DataManager.Instance:GetGround",
                "mapsPassed": passed,
                "batches": batches,
                "batchSizeMaximum": BATCH_SIZE,
                "graphicsRenderingTested": False,
                "editorOpened": False,
                "gameplayTransitionsTested": False,
            }
            # Stream one member at a time so the 2+ GiB uncompressed Grounds do
            # not accumulate in memory while stamping the attested result.
            for info in source.infolist():
                if info.is_dir():
                    continue
                if info.filename == manifest_path:
                    continue
                if info.filename == readme_path:
                    data = readme.encode("utf-8")
                elif info.filename == result_path:
                    data = result_bytes
                else:
                    data = source.read(info.filename)
                if info.filename.startswith("destiny/"):
                    relative = info.filename.removeprefix("destiny/")
                    hashes[relative] = {"sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
                zi = zipfile.ZipInfo(info.filename, date_time=(2026, 10, 29, 0, 0, 0))
                zi.compress_type = zipfile.ZIP_DEFLATED
                zi.external_attr = 0o644 << 16
                output.writestr(zi, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
            if result_path not in source.namelist():
                hashes["Documentation/runtime_ground_load_results.tsv"] = {
                    "sha256": hashlib.sha256(result_bytes).hexdigest(), "bytes": len(result_bytes)
                }
                zi = zipfile.ZipInfo(result_path, date_time=(2026, 10, 29, 0, 0, 0))
                zi.compress_type = zipfile.ZIP_DEFLATED
                zi.external_attr = 0o644 << 16
                output.writestr(zi, result_bytes, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
            manifest["files"] = hashes
            data = (json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
            zi = zipfile.ZipInfo(manifest_path, date_time=(2026, 10, 29, 0, 0, 0))
            zi.compress_type = zipfile.ZIP_DEFLATED
            zi.external_attr = 0o644 << 16
            output.writestr(zi, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        with zipfile.ZipFile(temp, "r") as verified:
            if verified.testzip():
                raise ValueError("CRC ZIP invalide après estampillage runtime")
            final = json.loads(verified.read(manifest_path))
            if not final["validation"]["runtimePMDOTested"]:
                raise ValueError("Package non marqué comme testé")
        temp.replace(PACKAGE)
    finally:
        if temp.exists():
            temp.unlink()


def main() -> None:
    executable = RUNTIME / "PMDO"
    startup = RUNTIME / "Data/Script/origin/main.lua"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("Runtime PMDO absent dans .cache/pmdo-runtime; voir source/pmdo_runtime/README.md.")
    if not (RUNTIME / "Base/PathParams.xml").is_file() or not startup.is_file():
        raise SystemExit("Ressources PMDO de base absentes dans .cache/pmdo-runtime.")
    manifest = install_mod()
    maps = manifest["maps"]
    original = startup.read_bytes()
    result_path = RUNTIME / "destiny_ground_test.tsv"
    home = ROOT / ".cache/pmdo-runtime/home-destiny-catalogue"
    home.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["HOME"] = str(home)
    all_rows: list[str] = []
    batch_count = (len(maps) + BATCH_SIZE - 1) // BATCH_SIZE
    try:
        for number, start in enumerate(range(0, len(maps), BATCH_SIZE), 1):
            batch = maps[start:start + BATCH_SIZE]
            if result_path.exists():
                result_path.unlink()
            hook = make_hook(batch)
            try:
                startup.write_bytes(original + b"\n" + hook)
                process = subprocess.run(
                    ["./PMDO", "-guide", "-quest", "destiny"],
                    cwd=RUNTIME, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                    timeout=180,
                )
                (ROOT / ".cache/pmdo-runtime/destiny-catalogue.log").write_bytes(process.stdout)
            finally:
                startup.write_bytes(original)
            if process.returncode != 0 or not result_path.is_file():
                raise RuntimeError(
                    f"PMDO échoue au lot {number}/{batch_count}; voir .cache/pmdo-runtime/destiny-catalogue.log"
                )
            lines = [line for line in result_path.read_text(encoding="utf-8").splitlines() if line]
            if len(lines) != len(batch) or any(not line.endswith("\tPASS") for line in lines):
                raise RuntimeError(f"Résultat incomplet au lot {number}: {lines[:3]}")
            all_rows.extend(lines)
            print(f"PMDO native load: lot {number}/{batch_count}, {len(lines)} Ground PASS")
    finally:
        startup.write_bytes(original)
    if startup.read_bytes() != original:
        raise RuntimeError("Le script startup original n’a pas été restauré")
    if len(all_rows) != len(maps):
        raise RuntimeError(f"Ground chargés: {len(all_rows)} / {len(maps)}")
    text = "\n".join(all_rows) + "\n"
    RESULTS.write_text(text, encoding="utf-8")
    stamp_package(text, len(all_rows), batch_count)
    print(f"PASS — {len(all_rows)}/{len(maps)} Ground chargés par PMDO 0.8.12.0.")
    print(f"Rapport: {RESULTS.relative_to(ROOT)}")
    print(f"Package estampillé: {PACKAGE.relative_to(ROOT)} ({PACKAGE.stat().st_size} octets)")
    print("Limites: rendu graphique, éditeur et transitions de quête non testés.")


if __name__ == "__main__":
    main()
