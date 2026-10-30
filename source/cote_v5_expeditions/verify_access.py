"""Verify entrance clearance and preserve the exact pre-migration source mapping."""
from pathlib import Path, PurePosixPath
from collections import deque
import hashlib
import io
import json
import shutil
import sys
import tempfile
import zipfile

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
WEB_OUTPUT = ROOT / "sprites/cote_v5_expeditions"
WEB = WEB_OUTPUT
PACK = Path.home() / ".cache/cote_v5_expeditions_pack"
BACKUP = ROOT / "exports/treasure_rename/source_payloads_before_rename_2026-10-30.zip"
MIGRATION_REPORT = ROOT / "exports/treasure_rename/migration_report.json"
ACTIVE_ARCHIVE = ROOT / "mod_treasure_expeditions_pmdo_0812.zip"
ACTIVE_ROOT = "treasure_expeditions"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def remove_descriptive_fields(document: dict) -> dict:
    """Ignore only comments/layer captions; compare the serialized map structure exactly."""
    document = json.loads(json.dumps(document, ensure_ascii=False))
    obj = document.get("Object", {})
    obj.pop("Comment", None)
    for layer in obj.get("Layers", []):
        layer.pop("Name", None)
    return document


def verify_previous_package_payloads() -> dict:
    report = json.loads(MIGRATION_REPORT.read_text(encoding="utf-8"))
    package = report["packageArchive"]
    if sha256(ACTIVE_ARCHIVE.read_bytes()) != package["rebrandedArchiveSha256"]:
        raise AssertionError("The rebranded package hash does not match the migration report")

    with zipfile.ZipFile(BACKUP) as snapshot:
        snapshot_manifest = json.loads(snapshot.read("PRESERVATION_MANIFEST.json"))
        source_row = next(row for row in snapshot_manifest["files"]
                          if row["rebrandedPath"] == ACTIVE_ARCHIVE.name)
        source_archive_bytes = snapshot.read(source_row["backupMember"])

    ground_records = {
        row["memberRelativePath"]: row for row in package["groundFiles"]
    }
    previous_ground_records = {
        path: row for path, row in ground_records.items()
        if Path(path).name.startswith("v40812_")
    }
    previous_resource_records = {
        row["memberRelativePath"]: row for row in package["previousResources"]
    }
    ground_count = resource_count = 0
    with zipfile.ZipFile(io.BytesIO(source_archive_bytes)) as source, zipfile.ZipFile(ACTIVE_ARCHIVE) as active:
        for name in source.namelist():
            relative = name.split("/", 1)[-1]
            if relative.startswith("Data/Ground/") and Path(relative).name.startswith("v40812_") and relative.endswith(".rsground"):
                original = source.read(name)
                current = active.read(f"{ACTIVE_ROOT}/{relative}")
                record = previous_ground_records[relative]
                if sha256(original) != record["sourceSha256"] or sha256(current) != record["rebrandedSha256"]:
                    raise AssertionError(f"Ground provenance hash mismatch: {relative}")
                if remove_descriptive_fields(json.loads(original)) != remove_descriptive_fields(json.loads(current)):
                    raise AssertionError(f"Non-descriptive Ground data changed: {relative}")
                ground_count += 1
            elif relative.startswith("Content/") and Path(relative).name.startswith("V40812_") and not relative.endswith("index.idx"):
                original = source.read(name)
                current = active.read(f"{ACTIVE_ROOT}/{relative}")
                record = previous_resource_records[relative]
                if original != current or sha256(original) != record["sha256"]:
                    raise AssertionError(f"Previous binary resource changed: {relative}")
                resource_count += 1
    if ground_count != 20 or resource_count != 10:
        raise AssertionError(f"Expected 20 prior Grounds and 10 resources; found {ground_count}/{resource_count}")
    return {"previousGroundsTextOnlyRebranded": ground_count,
            "previousResourcesByteIdentical": resource_count}


def verify_access(validation_inputs="prebuilt web layers and package directory"):
    manifest = json.loads((WEB / "manifest.json").read_text(encoding="utf-8"))
    results = []
    for zone in manifest["zones"]:
        grass = np.array(Image.open(WEB / zone["id"] / "MASQUE_HERBE.png")) > 0
        grass &= np.array(Image.open(WEB / zone["id"] / "05_ACCES_NATIF.png"))[:, :, 3] == 0
        free = np.array([[grass[y:y + 16, x:x + 16].all()
                          for x in range(0, grass.shape[1] - 15, 8)]
                         for y in range(0, grass.shape[0] - 15, 8)])
        sx, sy = (value // 8 for value in zone["entry"])
        assert free[sy, sx], zone["id"]
        for variants in zone["variants"].values():
            ground = json.loads((PACK / f'Data/Ground/{variants["asset"]}.rsground').read_text(encoding="utf-8"))["Object"]
            assert len(ground["Entities"][0]["Markers"]) == (2 if zone["door"] else 1)
        if not zone["door"]:
            continue
        tx, ty = (value // 8 for value in zone["door"]["threshold"])
        assert free[ty, tx]
        queue = deque([(sx, sy)])
        seen = {(sx, sy)}
        while queue:
            x, y = queue.popleft()
            for nx, ny in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                if (0 <= ny < free.shape[0] and 0 <= nx < free.shape[1]
                        and free[ny, nx] and (nx, ny) not in seen):
                    seen.add((nx, ny))
                    queue.append((nx, ny))
        assert (tx, ty) in seen, zone["id"]
        results.append({"id": zone["id"], "arrival": zone["entry"],
                        "threshold": zone["door"]["threshold"],
                        "clearance_px": [16, 16], "reachable": True,
                        "dungeon_destination": None})
    assert len(results) == 3
    preserved = verify_previous_package_payloads()
    report = {
        "entrances": results,
        "previous_files_byte_identical_before_rebrand": 30,
        "previous_ground_files_text_only_rebranded": preserved["previousGroundsTextOnlyRebranded"],
        "previous_resource_files_byte_identical_after_rebrand": preserved["previousResourcesByteIdentical"],
        "previous_ground_geometry_collision_cells_and_tile_references_unchanged": True,
        "exact_pre_migration_payloads_preserved_separately": True,
        "pre_migration_payload_backup": "exports/treasure_rename/source_payloads_before_rename_2026-10-30.zip",
        "current_rebranded_native_runtime_tested": False,
        "graphical_runtime_tested": False,
        "validation_inputs": validation_inputs,
    }
    for path in [WEB_OUTPUT / "access_verification.json", PACK / "access_verification.json", HERE / "access_verification.json"]:
        path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("PASS: 3 reachable 16px thresholds; exact source mapping and 20 text-only Ground changes verified.")
    return report


def main():
    """Recreate geometry inputs and extract the active package in an isolated cache."""
    cache_root = Path.home() / ".cache"
    cache_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="cote-v5-access-", dir=cache_root) as temp_dir:
        temp = Path(temp_dir)
        web = temp / "web"
        pack = temp / "pack"
        web.mkdir()
        pack.mkdir()

        if str(HERE) not in sys.path:
            sys.path.insert(0, str(HERE))
        import layouts
        import terrain

        old_layouts_out, old_terrain_out = layouts.OUT, terrain.OUT
        layouts.OUT = web
        terrain.OUT = web
        try:
            layouts.main()
            terrain.main()
        finally:
            layouts.OUT = old_layouts_out
            terrain.OUT = old_terrain_out

        shutil.copyfile(WEB_OUTPUT / "manifest.json", web / "manifest.json")
        prefix = f"{ACTIVE_ROOT}/Data/Ground/"
        extracted = 0
        with zipfile.ZipFile(ACTIVE_ARCHIVE) as archive:
            for info in archive.infolist():
                if not info.filename.startswith(prefix) or info.is_dir():
                    continue
                relative = PurePosixPath(info.filename[len(ACTIVE_ROOT) + 1:])
                if relative.is_absolute() or ".." in relative.parts:
                    raise ValueError(f"Unsafe package member path: {info.filename}")
                target = pack.joinpath(*relative.parts)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(archive.read(info))
                extracted += 1
        if extracted != 40:
            raise AssertionError(f"Expected 40 Grounds in the active package, extracted {extracted}")

        global WEB, PACK
        old_web, old_pack = WEB, PACK
        WEB, PACK = web, pack
        try:
            verify_access(
                "temporary layouts.py + terrain.py outputs; 40 Grounds extracted from the active ZIP"
            )
        finally:
            WEB, PACK = old_web, old_pack

    print("PASS — validation sans artefacts de génération persistants.")


if __name__ == "__main__":
    main()
