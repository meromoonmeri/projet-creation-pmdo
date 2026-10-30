#!/usr/bin/env python3
"""Build an installable overlay for the existing PMDO Destiny Quest.

The catalogue is not installed as a second Mod.xml. The output keeps only
Data/Content map assets and a safe installer that merges them into the user's
existing quest and refreshes its developer-only exploration zone.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import shutil
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[2]
CATALOGUE_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Catalogue_Exploration_0812.zip"
OUTPUT_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Quest_Overlay_0812.zip"
INSTALLER = Path(__file__).with_name("installer_destiny_overlay.py")
README = Path(__file__).with_name("DESTINY_QUEST_OVERLAY.md")
OVERLAY_ROOT = "PMD_Destiny_Quest_Overlay_0812"
ALLOWED_PREFIXES = (
    "destiny/Data/Ground/",
    "destiny/Data/Script/destiny/",
    "destiny/Content/Tile/",
    "destiny/Content/BG/",
)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def write_stream(out: zipfile.ZipFile, name: str, source, date_time=(2026, 10, 29, 0, 0, 0)) -> None:
    info = zipfile.ZipInfo(name, date_time=date_time)
    info.compress_type = zipfile.ZIP_DEFLATED
    info.external_attr = 0o644 << 16
    with out.open(info, "w", force_zip64=True) as destination:
        shutil.copyfileobj(source, destination, length=1024 * 1024)


def build(catalogue: Path, output: Path, inventory_path: Path | None = None) -> dict:
    catalogue = catalogue.resolve()
    output = output.resolve()
    inventory_path = inventory_path.resolve() if inventory_path else None
    if not catalogue.is_file():
        raise SystemExit(
            f"Catalogue ZIP absent : {catalogue}; lancer d'abord build_playable_catalogue_0812.py"
        )
    if catalogue == output:
        raise SystemExit("Le ZIP overlay ne peut pas remplacer le ZIP catalogue source.")
    if not INSTALLER.is_file() or not README.is_file():
        raise SystemExit("Sources installer/README manquantes.")
    output.parent.mkdir(parents=True, exist_ok=True)
    temp = output.with_suffix(output.suffix + ".tmp")
    counts = {"maps": 0, "tilesets": 0, "backgrounds": 0, "scripts": 0, "files": 0}
    try:
        with zipfile.ZipFile(catalogue, "r") as src:
            if src.testzip():
                raise ValueError("CRC invalide dans le catalogue source.")
            names = set(src.namelist())
            manifest_path = "destiny/manifest.json"
            if manifest_path not in names or "destiny/Mod.xml" not in names:
                raise ValueError("Mod.xml ou manifeste absent du catalogue source.")
            manifest = json.loads(src.read(manifest_path))
            maps = manifest.get("maps", [])
            if not isinstance(maps, list) or not maps:
                raise ValueError("Le catalogue source ne contient aucune map dans son manifeste.")
            source_files = manifest.get("files", {})
            if not isinstance(source_files, dict):
                raise ValueError("La table files du manifeste catalogue est invalide.")
            expected_assets = {
                "maps": sum(name.startswith("Data/Ground/") and name.endswith(".rsground") for name in source_files),
                "tilesets": sum(name.startswith("Content/Tile/") and name.endswith(".tile") for name in source_files),
                "backgrounds": sum(name.startswith("Content/BG/") and name.endswith(".dir") for name in source_files),
                "scripts": sum(name.startswith("Data/Script/destiny/") and name.endswith(".lua") for name in source_files),
            }
            if expected_assets["maps"] != len(maps):
                raise ValueError(
                    f"Manifeste incohérent : {len(maps)} maps décrites, "
                    f"{expected_assets['maps']} Ground(s) dans files."
                )
            mod = ET.fromstring(src.read("destiny/Mod.xml"))
            if (mod.findtext("Namespace") or "").strip() != "destiny":
                raise ValueError("Le catalogue source n'a pas le namespace destiny.")
            if (mod.findtext("ModType") or "").strip().casefold() != "quest":
                raise ValueError("Le catalogue source n'est pas une Quest PMDO.")
            if (mod.findtext("GameVersion") or "").strip() != "0.8.12.0":
                raise ValueError("Le catalogue source ne cible pas PMDO 0.8.12.0.")

            expected_ground: dict[str, str] = {}
            ground_version_counts: dict[str, int] = {}
            tex_size_counts: dict[str, int] = {}
            for row in maps:
                relative = row.get("groundFile")
                map_id = row.get("mapId")
                checksum = row.get("outputGroundSha256")
                if not all(isinstance(x, str) and x for x in (relative, map_id, checksum)):
                    raise ValueError("Entrée Ground incomplète dans le manifeste source.")
                safe = PurePosixPath(relative)
                if safe.is_absolute() or ".." in safe.parts or safe.parts[:2] != ("Data", "Ground"):
                    raise ValueError(f"Chemin Ground invalide dans le manifeste : {relative}")
                archive_path = "destiny/" + safe.as_posix()
                if archive_path not in names:
                    raise ValueError(f"Ground absent du catalogue source : {archive_path}")
                raw = src.read(archive_path)
                if sha256_bytes(raw) != checksum:
                    raise ValueError(f"SHA-256 Ground invalide dans le catalogue : {archive_path}")
                ground_doc = json.loads(raw)
                ground_obj = ground_doc.get("Object", {})
                ground_version = str(ground_doc.get("Version", ""))
                if not ground_version or ground_obj.get("AssetName") != map_id:
                    raise ValueError(f"Identité/Version Ground invalide : {archive_path}")
                expected_version = row.get("groundVersion", row.get("GroundVersion", row.get("Version")))
                if expected_version in (None, ""):
                    candidate_version = row.get("version")
                    if candidate_version not in (None, "") and str(candidate_version) != str(manifest.get("gameVersion", "")):
                        expected_version = candidate_version
                if expected_version not in (None, "") and str(expected_version) != ground_version:
                    raise ValueError(
                        f"Ground.Version différent du manifeste pour {archive_path}: "
                        f"{ground_version} != {expected_version}"
                    )
                tex_size = ground_obj.get("TexSize")
                if not isinstance(tex_size, int) or isinstance(tex_size, bool) or tex_size <= 0:
                    raise ValueError(f"TexSize Ground invalide : {archive_path}")
                expected_tex_size = row.get("texSize", row.get("TexSize"))
                if expected_tex_size is not None and int(expected_tex_size) != tex_size:
                    raise ValueError(
                        f"TexSize différent du manifeste pour {archive_path}: "
                        f"{tex_size} != {expected_tex_size}"
                    )
                ground_version_counts[ground_version] = ground_version_counts.get(ground_version, 0) + 1
                tex_size_counts[str(tex_size)] = tex_size_counts.get(str(tex_size), 0) + 1
                if safe.stem != map_id or relative in expected_ground:
                    raise ValueError(f"Map ID ou Ground dupliqué : {relative}")
                expected_ground[relative] = checksum

            # The overlay manifest is derived from the source package at build time.
            overlay_meta = {
                "name": "PMD Destiny — overlay de cartes 0.8.12",
                "targetQuest": {
                    "namespace": "destiny",
                    "gameVersion": "0.8.12.0",
                    "modType": "Quest",
                },
                "modXmlIncluded": False,
                "zoneId": "exploration_cartes",
                "zoneListsEveryGroundInTargetAfterInstall": True,
                "mapCount": len(maps),
                "groundVersionCounts": ground_version_counts,
                "texSizeCounts": tex_size_counts,
                "uniqueGroundContents": len({row["sourceGroundSha256"] for row in maps}),
                "sourceCatalogueSha256": sha256_file(catalogue),
                "sourceCataloguePath": catalogue.name,
                "storyTransitionsAdded": False,
                "runtimeTestForThisExactArchive": "NOT_RUN",
                "graphicsEditorTest": "NOT_RUN",
                "sourceInventoryIncluded": inventory_path is not None,
            }
            inventory_bytes = None
            if inventory_path is not None:
                if not inventory_path.is_file():
                    raise ValueError(f"Inventaire source absent : {inventory_path}")
                inventory_bytes = inventory_path.read_bytes()
                source_inventory = json.loads(inventory_bytes)
                source_summary = source_inventory.get("summary", {})
                inventory_entry_ids = {
                    str(row.get("entryId")) for row in source_inventory.get("entries", [])
                    if row.get("entryId")
                }
                mapped_entry_ids = {
                    str(row.get("sourceEntryId")) for row in maps if row.get("sourceEntryId")
                }
                unmapped_entry_ids = sorted(inventory_entry_ids - mapped_entry_ids)
                unexpected_entry_ids = sorted(mapped_entry_ids - inventory_entry_ids)
                if mapped_entry_ids:
                    package_mapping = (
                        f"MAPPED_BY_sourceEntryId; {len(mapped_entry_ids)} occurrences have a Ground row; "
                        f"{len(unmapped_entry_ids)} source occurrences have no Ground row."
                    )
                else:
                    package_mapping = (
                        "NOT_AUTOMATICALLY_RECONCILED; inventory is provenance documentation only"
                    )
                overlay_meta["sourceInventoryReference"] = {
                    "file": "Documentation/destiny_262_inventory.json",
                    "sha256": sha256_bytes(inventory_bytes),
                    "sourceEntries": source_summary.get("sourceEntries"),
                    "uniqueGroundContents": source_summary.get("uniqueExactGroundPayloadsAcrossAllSources"),
                    "duplicateOccurrencesBeyondFirst": source_summary.get("duplicateSourceOccurrencesBeyondFirst"),
                    "previewEligibleSourceEntries": source_summary.get("previewEligibleSourceEntries"),
                    "nonPreviewableSourceEntries": source_summary.get("nonPreviewableSourceEntries"),
                    "packageEntryMapping": package_mapping,
                    "mappedSourceEntryCount": len(mapped_entry_ids),
                    "unmappedSourceEntryIds": unmapped_entry_ids,
                    "unexpectedMappedSourceEntryIds": unexpected_entry_ids,
                }

            with zipfile.ZipFile(
                temp,
                "w",
                compression=zipfile.ZIP_DEFLATED,
                compresslevel=9,
                allowZip64=True,
            ) as out:
                with INSTALLER.open("rb") as installer_file:
                    write_stream(out, f"{OVERLAY_ROOT}/installer_destiny_overlay.py", installer_file)
                with README.open("rb") as readme_file:
                    write_stream(out, f"{OVERLAY_ROOT}/README.md", readme_file)
                write_stream(
                    out,
                    f"{OVERLAY_ROOT}/Documentation/catalogue_manifest.json",
                    io.BytesIO(src.read(manifest_path)),
                )
                if "destiny/CREDITS.md" in names:
                    write_stream(
                        out,
                        f"{OVERLAY_ROOT}/Documentation/CREDITS.md",
                        io.BytesIO(src.read("destiny/CREDITS.md")),
                    )
                if inventory_bytes is not None:
                    write_stream(
                        out,
                        f"{OVERLAY_ROOT}/Documentation/destiny_262_inventory.json",
                        io.BytesIO(inventory_bytes),
                    )
                source_runtime_report = "destiny/Documentation/runtime_ground_load_results.tsv"
                if source_runtime_report in names:
                    write_stream(
                        out,
                        f"{OVERLAY_ROOT}/Documentation/catalogue_ground_load_results.tsv",
                        io.BytesIO(src.read(source_runtime_report)),
                    )
                elif len(maps) == 208:
                    historical_report = ROOT / "source/pmdo_runtime/destiny_catalogue_208_ground_load_results.tsv"
                    if historical_report.is_file():
                        with historical_report.open("rb") as report_file:
                            write_stream(
                                out,
                                f"{OVERLAY_ROOT}/Documentation/historical_ground_load_results.tsv",
                                report_file,
                            )

                ground_paths_in_zip: set[str] = set()
                tile_names: set[str] = set()
                bg_names: set[str] = set()
                for info in src.infolist():
                    if info.is_dir() or not info.filename.startswith(ALLOWED_PREFIXES):
                        continue
                    rel = PurePosixPath(info.filename.removeprefix("destiny/")).as_posix()
                    if rel == "Content/Tile/index.idx":
                        continue  # merged with the target Quest's native index at installation
                    if rel.startswith("Content/Tile/") and not rel.casefold().endswith(".tile"):
                        continue
                    if rel.startswith("Content/BG/") and not rel.casefold().endswith(".dir"):
                        continue
                    if rel.startswith("Data/Ground/") and not rel.casefold().endswith(".rsground"):
                        continue
                    if rel.startswith("Data/Script/destiny/") and not rel.casefold().endswith(".lua"):
                        continue
                    if rel.startswith("Data/Zone/") or rel.endswith("Mod.xml"):
                        raise ValueError(f"Zone/Mod inattendu dans l'overlay : {rel}")
                    if rel.startswith("Data/Ground/"):
                        ground_paths_in_zip.add(rel)
                    elif rel.startswith("Content/Tile/"):
                        tile_names.add(PurePosixPath(rel).stem.casefold())
                    elif rel.startswith("Content/BG/"):
                        bg_names.add(PurePosixPath(rel).name.casefold())
                    with src.open(info, "r") as incoming:
                        write_stream(out, f"{OVERLAY_ROOT}/{rel}", incoming, info.date_time)
                    counts["files"] += 1
                    if rel.startswith("Data/Ground/"):
                        counts["maps"] += 1
                    elif rel.startswith("Content/Tile/"):
                        counts["tilesets"] += 1
                    elif rel.startswith("Content/BG/"):
                        counts["backgrounds"] += 1
                    elif rel.startswith("Data/Script/"):
                        counts["scripts"] += 1

                if ground_paths_in_zip != set(expected_ground):
                    raise ValueError(
                        "Le contenu Ground ne correspond pas exactement au manifeste "
                        f"({len(ground_paths_in_zip)} fichiers vs {len(expected_ground)} attendus)."
                    )
                for key in ("maps", "tilesets", "backgrounds", "scripts"):
                    if counts[key] != expected_assets[key]:
                        raise ValueError(
                            f"Assets incohérents pour {key} : {counts[key]} trouvés, "
                            f"{expected_assets[key]} attendus par le manifeste catalogue."
                        )
                if len(tile_names) != counts["tilesets"] or len(bg_names) != counts["backgrounds"]:
                    raise ValueError("Noms de tileset ou de fond dupliqués dans l'archive source.")

                overlay_meta.update(counts)
                write_stream(
                    out,
                    f"{OVERLAY_ROOT}/Documentation/overlay_manifest.json",
                    io.BytesIO((json.dumps(overlay_meta, ensure_ascii=False, indent=2) + "\n").encode("utf-8")),
                )

        with zipfile.ZipFile(temp, "r") as check:
            bad = check.testzip()
            if bad:
                raise ValueError(f"CRC invalide dans l'overlay : {bad}")
            names = check.namelist()
            if any(name.endswith("/Mod.xml") for name in names):
                raise ValueError("L'overlay ne doit pas remplacer le Mod.xml existant.")
            grounds = [
                name for name in names
                if name.startswith(f"{OVERLAY_ROOT}/Data/Ground/") and name.endswith(".rsground")
            ]
            tiles = [
                name for name in names
                if name.startswith(f"{OVERLAY_ROOT}/Content/Tile/") and name.endswith(".tile")
            ]
            if (len(grounds), len(tiles)) != (expected_assets["maps"], expected_assets["tilesets"]):
                raise ValueError(
                    f"Contrôle final : {len(grounds)} Grounds, {len(tiles)} tilesets; "
                    f"attendu {expected_assets['maps']}/{expected_assets['tilesets']}"
                )
        temp.replace(output)
    finally:
        if temp.exists():
            temp.unlink()
    return {
        "output": str(output),
        "bytes": output.stat().st_size,
        **counts,
        "crc": "PASS",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--catalogue", type=Path, default=CATALOGUE_DEFAULT)
    parser.add_argument("--output", type=Path, default=OUTPUT_DEFAULT)
    parser.add_argument("--inventory", type=Path, help="inclure le registre de provenance 262 en documentation (sans prétendre à une couverture carte-à-carte)")
    args = parser.parse_args()
    print(json.dumps(build(args.catalogue, args.output, args.inventory), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
