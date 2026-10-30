#!/usr/bin/env python3
"""Probe every Ground in a PMDO archive with the real 0.8.12 runtime.

Unlike the historical 208-map verifier, this probe reads each Ground's own
serialized Version and Object.TexSize (or the corresponding per-map manifest
fields). It supports older Ground versions and non-1 TexSize values, and runs
at most 20 distinct runtime map IDs per PMDO process. The temporary Quest is
created only in .cache/pmdo-runtime; no installed Destiny files are modified.

The test certifies native deserialization, dimensions, layer count and
TexSize only. It does not initialize graphics, resolve tile images, validate
collision fidelity, gameplay, warps or quest transitions.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import zipfile
from dataclasses import dataclass
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".cache/pmdo-runtime/engine/PMDO"
DEFAULT_PACKAGE = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
DEFAULT_RESULTS = ROOT / "source/pmdo_runtime/destiny_ground_archive_runtime_results.tsv"
BATCH_SIZE = 20
NAMESPACE = "destiny_ground_archive_probe"
MOD = RUNTIME / "MODS" / NAMESPACE
STARTUP = RUNTIME / "Data/Script/origin/main.lua"
RESULT_IN_RUNTIME = RUNTIME / f"{NAMESPACE}.tsv"
LOG_DIR = ROOT / ".cache/pmdo-runtime/ground-archive-probe"
HOME = ROOT / ".cache/pmdo-runtime/home-ground-archive-probe"


@dataclass
class GroundRecord:
    source_row: int
    source_entry_id: str
    map_id: str
    runtime_id: str
    source_path: str
    version: str
    tex_size: int
    width: int
    height: int
    layers: int
    sha256: str
    alias_applied: bool


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _manifest_version(row: dict[str, Any], manifest: dict[str, Any], ground_version: str) -> None:
    """Check explicit serialized-version fields without confusing gameVersion.

    New manifests should use groundVersion. `Version` is accepted for manifests
    mirroring the .rsground wrapper. Legacy `version` is treated as the Ground
    version unless it exactly repeats the manifest's target gameVersion; that
    legacy form is ambiguous and the serialized wrapper remains authoritative.
    """
    for key in ("groundVersion", "GroundVersion", "Version"):
        expected = row.get(key)
        if expected not in (None, ""):
            if str(expected) != ground_version:
                raise ValueError(
                    f"manifest {key}={expected!r} ne correspond pas à Ground.Version={ground_version!r}"
                )
            return
    expected = row.get("version")
    target_version = manifest.get("gameVersion") or manifest.get("targetGameVersion")
    if expected not in (None, "") and not (
        target_version not in (None, "")
        and str(expected) == str(target_version)
        and str(expected) != ground_version
    ):
        if str(expected) != ground_version:
            raise ValueError(
                f"manifest version={expected!r} ne correspond pas à Ground.Version={ground_version!r}"
            )


def inspect_ground(raw: bytes, row: dict[str, Any] | None = None,
                   manifest: dict[str, Any] | None = None) -> dict[str, Any]:
    document = json.loads(raw.decode("utf-8-sig"))
    if not isinstance(document, dict) or not isinstance(document.get("Object"), dict):
        raise ValueError("Ground JSON doit contenir un objet Object")
    obj = document["Object"]
    version = document.get("Version")
    if not isinstance(version, str) or not version.strip():
        raise ValueError(f"Ground.Version invalide: {version!r}")
    _manifest_version(row or {}, manifest or {}, version)

    tex_size = obj.get("TexSize")
    if not isinstance(tex_size, int) or isinstance(tex_size, bool) or tex_size <= 0:
        raise ValueError(f"Object.TexSize invalide: {tex_size!r}")
    layers = obj.get("Layers")
    if not isinstance(layers, list) or not layers:
        raise ValueError("Ground sans calques")

    # GroundMap.Width/Height follow the logical tile grid, not the raw
    # collision raster. Older Grounds can store three obstacle cells per tile
    # (`TexSize=3`), while Layers[*].Tiles is already expressed in map cells.
    tile_columns = None
    for layer in layers:
        if isinstance(layer, dict) and isinstance(layer.get("Tiles"), list) and layer["Tiles"]:
            tile_columns = layer["Tiles"]
            break
    if tile_columns is not None:
        width = len(tile_columns)
        height = len(tile_columns[0]) if isinstance(tile_columns[0], list) else 0
        if height <= 0 or any(not isinstance(column, list) or len(column) != height
                              for column in tile_columns):
            raise ValueError("grille Layers.Tiles irrégulière")
    else:
        obstacles = obj.get("obstacles")
        if not isinstance(obstacles, list) or not obstacles or not isinstance(obstacles[0], list):
            raise ValueError("dimensions Ground introuvables (Layers.Tiles/obstacles)")
        raw_width, raw_height = len(obstacles), len(obstacles[0])
        if any(not isinstance(column, list) or len(column) != raw_height for column in obstacles):
            raise ValueError("grille obstacles irrégulière")
        if raw_width % tex_size or raw_height % tex_size:
            raise ValueError(
                f"grille obstacles {raw_width}x{raw_height} non divisible par TexSize={tex_size}"
            )
        width, height = raw_width // tex_size, raw_height // tex_size
    if width <= 0 or height <= 0:
        raise ValueError(f"dimensions Ground invalides: {width}x{height}")

    obstacles = obj.get("obstacles")
    if isinstance(obstacles, list) and obstacles and isinstance(obstacles[0], list):
        raw_width, raw_height = len(obstacles), len(obstacles[0])
        if raw_width % tex_size == 0 and raw_height % tex_size == 0:
            collision_grid = [raw_width // tex_size, raw_height // tex_size]
            if collision_grid != [width, height]:
                raise ValueError(
                    f"Ground collision grid/Tiles incohérents: {collision_grid} vs {[width, height]}"
                )

    if row:
        expected_grid = row.get("grid")
        if expected_grid is not None and list(expected_grid) != [width, height]:
            raise ValueError(f"manifest grid={expected_grid!r}, Ground={width}x{height}")
        expected_layers = row.get("layers", row.get("layerCount"))
        if expected_layers is not None and int(expected_layers) != len(layers):
            raise ValueError(f"manifest layers={expected_layers!r}, Ground={len(layers)}")
        expected_tex = row.get("texSize", row.get("TexSize"))
        if expected_tex is not None and int(expected_tex) != tex_size:
            raise ValueError(f"manifest texSize={expected_tex!r}, Ground.TexSize={tex_size}")

    asset_name = obj.get("AssetName")
    if not isinstance(asset_name, str) or not asset_name.strip():
        raise ValueError("Object.AssetName absent")
    return {
        "assetName": asset_name,
        "version": version,
        "texSize": tex_size,
        "grid": [width, height],
        "layers": len(layers),
        "sha256": sha256_bytes(raw),
    }


def replace_object_asset_name(raw: bytes, previous_name: str, replacement: str) -> bytes:
    """Rewrite only GroundMap.AssetName in a temporary probe copy, byte-preserving otherwise."""
    object_match = re.search(rb'"Object"\s*:\s*\{', raw)
    if not object_match:
        raise ValueError("Ground JSON sans objet Object")
    depth = 1
    index = object_match.end()
    size = len(raw)
    while index < size and depth:
        char = raw[index]
        if char == 0x22:  # JSON string; braces inside strings do not affect depth.
            token_start = index
            index += 1
            escaped = False
            while index < size:
                current = raw[index]
                if escaped:
                    escaped = False
                elif current == 0x5C:
                    escaped = True
                elif current == 0x22:
                    break
                index += 1
            if index >= size:
                raise ValueError("Chaîne JSON tronquée lors de l’alias Ground")
            token = raw[token_start + 1:index]
            string_end = index + 1
            if depth == 1 and token == b"AssetName":
                value_start = string_end
                while value_start < size and raw[value_start] in b" \t\r\n":
                    value_start += 1
                if value_start >= size or raw[value_start] != 0x3A:
                    raise ValueError("Séparateur AssetName absent")
                value_start += 1
                while value_start < size and raw[value_start] in b" \t\r\n":
                    value_start += 1
                if value_start >= size or raw[value_start] != 0x22:
                    raise ValueError("Valeur AssetName non textuelle")
                value_end = value_start + 1
                escaped = False
                while value_end < size:
                    current = raw[value_end]
                    if escaped:
                        escaped = False
                    elif current == 0x5C:
                        escaped = True
                    elif current == 0x22:
                        break
                    value_end += 1
                actual = json.loads(raw[value_start:value_end + 1].decode("utf-8"))
                if actual != previous_name:
                    raise ValueError(f"AssetName Ground inattendu: {actual!r} != {previous_name!r}")
                replacement_json = json.dumps(replacement, ensure_ascii=False).encode("utf-8")
                return raw[:value_start] + replacement_json + raw[value_end + 1:]
            index = string_end
            continue
        if char in (0x7B, 0x5B):  # { or [
            depth += 1
        elif char in (0x7D, 0x5D):  # } or ]
            depth -= 1
        index += 1
    raise ValueError("GroundMap.AssetName de premier niveau introuvable")


def _safe_asset_name(value: str) -> bool:
    return bool(re.fullmatch(r"[A-Za-z0-9_.-]+", value)) and value not in {".", ".."} \
        and not value.startswith(".")


def _choose_runtime_id(map_id: str, digest: str, used: dict[str, tuple[str, str]],
                       source_row: int) -> tuple[str, bool]:
    candidate = map_id if _safe_asset_name(map_id) else f"probe_{digest[:12]}_{source_row:04d}"
    prior = used.get(candidate.casefold())
    if prior is None:
        used[candidate.casefold()] = (digest, candidate)
        return candidate, candidate != map_id
    prior_digest, prior_id = prior
    if prior_digest == digest:
        return prior_id, prior_id != map_id
    candidate = f"probe_{digest[:16]}_{source_row:04d}"
    while candidate.casefold() in used:
        candidate += "x"
    used[candidate.casefold()] = (digest, candidate)
    return candidate, True


def _stage_record(mod_ground_dir: Path, raw: bytes, inspected: dict[str, Any],
                  map_id: str, runtime_id: str) -> None:
    destination = mod_ground_dir / f"{runtime_id}.rsground"
    if destination.exists():
        return
    if runtime_id == inspected["assetName"]:
        destination.write_bytes(raw)
        return
    # Conflicting source IDs or unsafe names are isolated by changing only the
    # test-copy AssetName; the original Ground bytes and all other fields remain.
    patched = replace_object_asset_name(raw, inspected["assetName"], runtime_id)
    destination.write_bytes(patched)


def _candidate_manifest_names(names: list[str]) -> list[str]:
    preferred = [
        "destiny/manifest.json",
        "manifest.json",
        "Documentation/catalogue_manifest.json",
        "PMD_Destiny_Quest_Overlay_0812/Documentation/catalogue_manifest.json",
    ]
    ordered = [name for name in preferred if name in names]
    ordered += [name for name in names if name not in ordered and
                PurePosixPath(name).name.casefold() in {"manifest.json", "catalogue_manifest.json"}]
    return ordered


def find_zip_manifest(archive: zipfile.ZipFile) -> tuple[str | None, dict[str, Any]]:
    names = archive.namelist()
    for name in _candidate_manifest_names(names):
        try:
            document = json.loads(archive.read(name).decode("utf-8-sig"))
        except (UnicodeDecodeError, json.JSONDecodeError, KeyError):
            continue
        if isinstance(document, dict) and isinstance(document.get("maps"), list):
            return name, document
    return None, {}


def _member_for_ground(info_name: str | None, row: dict[str, Any],
                       names: set[str]) -> str:
    relative = row.get("groundFile") or row.get("ground") or row.get("path")
    if not isinstance(relative, str) or not relative:
        raise ValueError(f"ligne manifeste sans groundFile: {row!r}")
    path = PurePosixPath(relative)
    if path.is_absolute() or ".." in path.parts or "\\" in relative:
        raise ValueError(f"chemin Ground dangereux: {relative}")
    relative = path.as_posix()
    candidates = [relative]
    if info_name:
        manifest_parent = PurePosixPath(info_name).parent
        base = manifest_parent.parent if manifest_parent.name == "Documentation" else manifest_parent
        candidates.insert(0, (base / relative).as_posix())
    if relative.startswith("destiny/"):
        candidates.append(relative.removeprefix("destiny/"))
    for candidate in candidates:
        if candidate in names:
            return candidate
    suffix = "/" + relative.lstrip("/")
    matches = [name for name in names if name.endswith(suffix)]
    if len(matches) == 1:
        return matches[0]
    if len(matches) > 1:
        raise ValueError(f"chemin Ground ambigu dans le ZIP: {relative} ({matches[:3]})")
    # A few manifests store just a basename. Resolve it only when unique.
    basenames = [name for name in names if PurePosixPath(name).name == path.name]
    if len(basenames) == 1:
        return basenames[0]
    raise ValueError(f"Ground absent du ZIP: {relative}")


def _find_directory_manifest(root: Path) -> Path | None:
    candidates = [
        root / "manifest.json",
        root / "destiny" / "manifest.json",
        root / "Documentation" / "catalogue_manifest.json",
        root / "PMD_Destiny_Quest_Overlay_0812" / "Documentation" / "catalogue_manifest.json",
    ]
    for candidate in candidates:
        if candidate.is_file():
            try:
                data = json.loads(candidate.read_text(encoding="utf-8-sig"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                continue
            if isinstance(data, dict) and isinstance(data.get("maps"), list):
                return candidate
    return None


def _path_for_ground(root: Path, manifest_path: Path | None,
                     row: dict[str, Any]) -> Path:
    relative = row.get("groundFile") or row.get("ground") or row.get("path")
    if not isinstance(relative, str) or not relative:
        raise ValueError(f"ligne manifeste sans groundFile: {row!r}")
    rel = PurePosixPath(relative)
    if rel.is_absolute() or ".." in rel.parts or "\\" in relative:
        raise ValueError(f"chemin Ground dangereux: {relative}")
    base = root
    if manifest_path:
        parent = manifest_path.parent
        base = parent.parent if parent.name == "Documentation" else parent
    candidates = [base.joinpath(*rel.parts), root.joinpath(*rel.parts)]
    if rel.parts and rel.parts[0] == "destiny":
        candidates.append(root.joinpath(*rel.parts[1:]))
    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved.is_relative_to(root.resolve()) and resolved.is_file():
            return resolved
    matches = [
        p for p in root.rglob(rel.name)
        if p.is_file() and p.resolve().is_relative_to(root.resolve())
    ]
    if len(matches) == 1:
        return matches[0]
    if len(matches) > 1:
        raise ValueError(f"Ground ambigu dans le dossier: {relative}")
    raise ValueError(f"Ground absent du dossier: {relative}")


def _map_rows_from_directory(root: Path, manifest_path: Path | None) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    manifest: dict[str, Any] = {}
    if manifest_path:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8-sig"))
        return manifest, list(manifest["maps"])
    paths = sorted(p for p in root.rglob("*.rsground") if p.is_file())
    if not paths:
        raise ValueError(f"aucun .rsground dans {root}")
    return manifest, [{"groundFile": p.relative_to(root).as_posix()} for p in paths]


def load_and_stage(package: Path, mod_ground_dir: Path) -> tuple[list[GroundRecord], list[GroundRecord], dict[str, Any], str]:
    """Return occurrence rows, distinct runtime rows, manifest, and input hash."""
    records: list[GroundRecord] = []
    unique: list[GroundRecord] = []
    used_runtime_ids: dict[str, tuple[str, str]] = {}
    tested_ids: dict[str, GroundRecord] = {}
    source_hash = hashlib.sha256()

    def consume(raw: bytes, source_path: str, row: dict[str, Any], manifest: dict[str, Any], index: int) -> None:
        inspected = inspect_ground(raw, row, manifest)
        expected_sha = row.get("outputGroundSha256") or row.get("groundSha256")
        file_table = manifest.get("files", {}) if isinstance(manifest, dict) else {}
        if expected_sha is None and isinstance(file_table, dict):
            relative = row.get("groundFile") or row.get("ground") or row.get("path")
            metadata = file_table.get(relative) if isinstance(relative, str) else None
            if isinstance(metadata, dict):
                expected_sha = metadata.get("sha256")
        if expected_sha and str(expected_sha).lower() != inspected["sha256"]:
            raise ValueError(
                f"SHA-256 Ground différent du manifeste pour {source_path}: "
                f"{inspected['sha256']} != {expected_sha}"
            )
        map_id = str(row.get("mapId") or row.get("assetName") or inspected["assetName"])
        if not map_id.strip():
            raise ValueError(f"mapId absent pour {source_path}")
        runtime_id, alias = _choose_runtime_id(map_id, inspected["sha256"], used_runtime_ids, index)
        record = GroundRecord(
            source_row=index,
            source_entry_id=str(row.get("sourceEntryId") or row.get("entryId") or ""),
            map_id=map_id,
            runtime_id=runtime_id,
            source_path=source_path,
            version=inspected["version"],
            tex_size=inspected["texSize"],
            width=inspected["grid"][0],
            height=inspected["grid"][1],
            layers=inspected["layers"],
            sha256=inspected["sha256"],
            alias_applied=alias or runtime_id != inspected["assetName"],
        )
        records.append(record)
        source_hash.update(source_path.encode("utf-8"))
        source_hash.update(b"\0")
        source_hash.update(bytes.fromhex(record.sha256))
        existing = tested_ids.get(runtime_id.casefold())
        if existing is None:
            _stage_record(mod_ground_dir, raw, inspected, map_id, runtime_id)
            tested_ids[runtime_id.casefold()] = record
            unique.append(record)
        elif existing.sha256 != record.sha256:
            raise AssertionError("runtime map ID collision after aliasing")

    if package.is_dir():
        manifest_path = _find_directory_manifest(package)
        manifest, rows = _map_rows_from_directory(package, manifest_path)
        for index, row in enumerate(rows, 1):
            path = _path_for_ground(package, manifest_path, row)
            raw = path.read_bytes()
            consume(raw, path.relative_to(package).as_posix(), row, manifest, index)
    else:
        with zipfile.ZipFile(package, "r") as archive:
            bad = archive.testzip()
            if bad:
                raise ValueError(f"CRC invalide dans le ZIP: {bad}")
            names_list = archive.namelist()
            names = set(names_list)
            manifest_member, manifest = find_zip_manifest(archive)
            if manifest_member:
                rows = list(manifest["maps"])
                for index, row in enumerate(rows, 1):
                    member = _member_for_ground(manifest_member, row, names)
                    raw = archive.read(member)
                    consume(raw, member, row, manifest, index)
            else:
                members = [name for name in names_list if name.casefold().endswith(".rsground")]
                if not members:
                    raise ValueError("aucun Ground ni manifeste avec une liste maps dans le ZIP")
                for index, member in enumerate(members, 1):
                    raw = archive.read(member)
                    consume(raw, member, {}, {}, index)
        if package.is_file():
            file_digest = hashlib.sha256()
            with package.open("rb") as stream:
                for chunk in iter(lambda: stream.read(1024 * 1024), b""):
                    file_digest.update(chunk)
            source_hash.update(file_digest.digest())

    if not records:
        raise ValueError("aucun Ground décrit par le package")
    return records, unique, manifest if "manifest" in locals() else {}, source_hash.hexdigest()


def _lua_string(value: str) -> str:
    # Asset IDs and versions are constrained to ASCII before entering the hook.
    return json.dumps(value, ensure_ascii=True)


def make_hook(batch: list[GroundRecord], output_file: str) -> bytes:
    tests = []
    for row in batch:
        tests.append(
            "{mapId=%s,width=%d,height=%d,layers=%d,texSize=%d,version=%s}"
            % (
                _lua_string(row.runtime_id), row.width, row.height,
                row.layers, row.tex_size, _lua_string(row.version),
            )
        )
    source = """-- NATIVE_GROUND_ARCHIVE_PROBE: PMDO 0.8.12.0
local env=luanet.import_type('System.Environment')
local gfx=luanet.import_type('RogueEssence.Content.GraphicsManager')
local dm=luanet.import_type('RogueEssence.Data.DataManager')
local output=assert(io.open('%s','w'))
gfx.DungeonTexSize=3 -- required by the headless collision-grid loader
local tests={%s}
local failed=0
for _,test in ipairs(tests) do
  local ok,err=pcall(function()
    local map=dm.Instance:GetGround(test.mapId)
    assert(map~=nil,'null Ground')
    assert(map.Width==test.width and map.Height==test.height,
      'wrong dimensions: '..tostring(map.Width)..'x'..tostring(map.Height))
    assert(map.TexSize==test.texSize,
      'wrong TexSize: expected '..test.texSize..', got '..tostring(map.TexSize))
    assert(map.Layers.Count==test.layers,
      'wrong layer count: expected '..test.layers..', got '..tostring(map.Layers.Count))
  end)
  local status=ok and 'PASS' or 'FAIL'
  if not ok then failed=failed+1 end
  local message=ok and '' or tostring(err):gsub('[\\r\\n\\t]',' ')
  output:write(test.mapId..'\\t'..test.version..'\\t'..test.texSize..'\\t'..
    test.width..'\\t'..test.height..'\\t'..test.layers..'\\t'..status..'\\t'..message..'\\n')
  output:flush()
end
output:close()
print('NATIVE_GROUND_ARCHIVE_PROBE '..(failed==0 and 'PASS' or ('FAIL '..failed)))
env.Exit(failed==0 and 0 or 1)
""" % (output_file, ",\n  ".join(tests))
    return source.encode("utf-8")


def _write_probe_mod() -> None:
    if MOD.exists():
        shutil.rmtree(MOD)
    (MOD / "Data/Ground").mkdir(parents=True)
    (MOD / "Mod.xml").write_text(
        f'''<?xml version="1.0" encoding="utf-8"?>\n'''
        f'''<Header><Name>Temporary Ground archive probe</Name><Author>Arena</Author>'''
        f'''<Description>Disposable PMDO 0.8.12 headless Ground test.</Description>'''
        f'''<Namespace>{NAMESPACE}</Namespace>'''
        f'''<UUID>c76ca73e-e320-4b5d-a0e5-852a0e355761</UUID>'''
        f'''<Version>1.0.0.0</Version><GameVersion>0.8.12.0</GameVersion>'''
        f'''<ModType>Quest</ModType><Relationships /></Header>\n''',
        encoding="utf-8",
    )


def _parse_batch_output(lines: list[str]) -> dict[str, dict[str, str]]:
    parsed: dict[str, dict[str, str]] = {}
    for line in lines:
        fields = line.split("\t", 7)
        if len(fields) != 8:
            continue
        map_id, version, tex_size, width, height, layers, status, message = fields
        parsed[map_id.casefold()] = {
            "version": version,
            "texSize": tex_size,
            "width": width,
            "height": height,
            "layers": layers,
            "status": status,
            "message": message,
        }
    return parsed


def run_probe(package: Path, results_path: Path, expected_count: int | None,
              batch_size: int) -> dict[str, Any]:
    if batch_size < 1 or batch_size > BATCH_SIZE:
        raise ValueError(f"--batch-size doit être entre 1 et {BATCH_SIZE}")
    executable = RUNTIME / "PMDO"
    if not executable.is_file() or not os.access(executable, os.X_OK):
        raise SystemExit("Runtime PMDO absent dans .cache/pmdo-runtime; voir source/pmdo_runtime/README.md.")
    if not (RUNTIME / "Base/PathParams.xml").is_file() or not STARTUP.is_file():
        raise SystemExit("Ressources PMDO de base absentes dans .cache/pmdo-runtime.")
    if not package.exists():
        raise SystemExit(f"Package Ground absent: {package}")

    _write_probe_mod()
    try:
        records, unique, manifest, input_sha256 = load_and_stage(package, MOD / "Data/Ground")
        if expected_count is not None and len(records) != expected_count:
            raise ValueError(
                f"Nombre d’entrées Ground: {len(records)}, attendu {expected_count}. "
                "Le compte porte sur les lignes du manifeste/occurrences, doublons inclus."
            )
        original = STARTUP.read_bytes()
        HOME.mkdir(parents=True, exist_ok=True)
        LOG_DIR.mkdir(parents=True, exist_ok=True)
        env = os.environ.copy()
        env["HOME"] = str(HOME)
        result_rows: dict[str, dict[str, str]] = {}
        batch_count = (len(unique) + batch_size - 1) // batch_size
        try:
            for number, start in enumerate(range(0, len(unique), batch_size), 1):
                batch = unique[start:start + batch_size]
                if RESULT_IN_RUNTIME.exists():
                    RESULT_IN_RUNTIME.unlink()
                log_path = LOG_DIR / f"batch_{number:03d}.log"
                process = None
                try:
                    STARTUP.write_bytes(original + b"\n" + make_hook(batch, RESULT_IN_RUNTIME.name))
                    process = subprocess.run(
                        ["./PMDO", "-guide", "-quest", NAMESPACE],
                        cwd=RUNTIME,
                        env=env,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT,
                        timeout=180,
                    )
                    log_path.write_bytes(process.stdout)
                except subprocess.TimeoutExpired as error:
                    output = error.stdout or b""
                    if isinstance(output, str):
                        output = output.encode("utf-8", "replace")
                    log_path.write_bytes(output + b"\n[TIMEOUT]\n")
                finally:
                    STARTUP.write_bytes(original)

                if RESULT_IN_RUNTIME.is_file():
                    parsed = _parse_batch_output(RESULT_IN_RUNTIME.read_text(encoding="utf-8").splitlines())
                    result_rows.update(parsed)
                else:
                    parsed = {}
                batch_failed = [row.runtime_id for row in batch if row.runtime_id.casefold() not in parsed]
                status_count = sum(
                    parsed.get(row.runtime_id.casefold(), {}).get("status") == "PASS"
                    for row in batch
                )
                print(
                    f"PMDO Ground probe: lot {number}/{batch_count}, "
                    f"{status_count}/{len(batch)} PASS"
                    + (f", sans résultat: {len(batch_failed)}" if batch_failed else ""),
                    flush=True,
                )
        finally:
            STARTUP.write_bytes(original)
            if STARTUP.read_bytes() != original:
                raise RuntimeError("Le script startup original n’a pas été restauré")
            if RESULT_IN_RUNTIME.exists():
                RESULT_IN_RUNTIME.unlink()

        output_lines: list[list[str]] = []
        output_lines.append(["# package", str(package.resolve())])
        output_lines.append(["# input_sha256", input_sha256])
        output_lines.append(["# manifest_rows_including_duplicates", str(len(records))])
        output_lines.append(["# unique_runtime_ground_ids", str(len(unique))])
        output_lines.append(["# batch_size_maximum", str(batch_size)])
        output_lines.append(["# batches", str(batch_count)])
        output_lines.append(["sourceRow", "sourceEntryId", "mapId", "runtimeId", "Ground.Version", "TexSize",
                             "width", "height", "layers", "groundSha256", "runtimeStatus",
                             "runtimeMessage", "sourcePath", "testAliasApplied"])
        passed_occurrences = 0
        failed_occurrences = 0
        for record in records:
            result = result_rows.get(record.runtime_id.casefold(), {})
            status = result.get("status", "NO_RESULT")
            if status == "PASS":
                passed_occurrences += 1
            else:
                failed_occurrences += 1
            output_lines.append([
                str(record.source_row), record.source_entry_id, record.map_id, record.runtime_id, record.version,
                str(record.tex_size), str(record.width), str(record.height), str(record.layers),
                record.sha256, status, result.get("message", ""), record.source_path,
                str(record.alias_applied).lower(),
            ])
        results_path.parent.mkdir(parents=True, exist_ok=True)
        with results_path.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.writer(stream, delimiter="\t", lineterminator="\n")
            writer.writerows(output_lines)

        summary = {
            "package": str(package.resolve()),
            "inputSha256": input_sha256,
            "manifestGroundRowsIncludingDuplicates": len(records),
            "uniqueRuntimeGroundIds": len(unique),
            "passedOccurrences": passed_occurrences,
            "failedOccurrences": failed_occurrences,
            "batches": batch_count,
            "batchSizeMaximum": batch_size,
            "results": str(results_path.resolve()),
            "targetGameVersion": manifest.get("gameVersion", "0.8.12.0"),
        }
        if failed_occurrences:
            raise RuntimeError(json.dumps(summary, ensure_ascii=False))
        return summary
    finally:
        if MOD.exists():
            shutil.rmtree(MOD)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package", type=Path, default=DEFAULT_PACKAGE,
                        help="ZIP PMDO ou dossier extrait contenant Data/Ground et, si possible, manifest.json")
    parser.add_argument("--results", type=Path, default=DEFAULT_RESULTS,
                        help="rapport TSV de sortie")
    parser.add_argument("--expected-count", type=int,
                        help="nombre de lignes Ground attendu dans le manifeste (doublons inclus)")
    parser.add_argument("--batch-size", type=int, default=BATCH_SIZE,
                        help="maps distinctes par processus PMDO, maximum 20")
    args = parser.parse_args()
    try:
        summary = run_probe(args.package.resolve(), args.results.resolve(), args.expected_count, args.batch_size)
    except Exception as error:
        print(f"FAIL — {error}")
        raise SystemExit(1) from error
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    print("Limites : aucun rendu graphique, validation de TileIndex, gameplay, collision visuelle ou transitions.")


if __name__ == "__main__":
    main()
