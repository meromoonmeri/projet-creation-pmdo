#!/usr/bin/env python3
"""Create a standalone PMDO 0.8.12 Destiny cartotheque Quest.

Unlike the overlay builder, this creates a new ``destiny`` Quest root. It reuses
its stable Mod.xml/UUID from the earlier 208-map prototype, keeps only the
246 verified Ground assets available today, and makes an exploration_cartes
zone. The 16 unavailable source occurrences remain documented, never faked.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import stat
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from source.pmdo_cote.build_playable_catalogue_0812 import output_mod_xml  # noqa: E402
from source.pmdo_cote.installer_destiny_overlay import (  # noqa: E402
    EXPECTED_GAME_VERSION,
    MANIFEST_PATH,
    ZONE_COMMENT,
    ZONE_ID,
    ZONE_NAME,
    atomic_write,
    ground_ids_after_merge,
    load_json,
    merged_tile_index,
    read_index_bytes,
    safe_copy_plan,
    validate_overlay,
    zone_documents,
)

OVERLAY_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip"
OUTPUT_DEFAULT = ROOT / "exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip"
STAGING_DEFAULT = ROOT / ".cache/destiny-recovery/destiny-map-quest-246"
PMDO_ROOT_DEFAULT = ROOT / ".cache/pmdo-runtime/engine/PMDO"
OVERLAY_ROOT_NAME = "PMD_Destiny_Quest_Overlay_0812"
QUEST_NAMESPACE = "destiny"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def localized_name() -> dict:
    return {"DefaultText": ZONE_NAME, "LocalTexts": {"fr": ZONE_NAME}}


def seed_quest(target: Path, pmdo_root: Path) -> None:
    """Make a clean Quest shell with one developer-only zone and no story data."""
    core_zone_dir = pmdo_root / "Data/Zone"
    core_index_path = core_zone_dir / "index.idx"
    debug_zone_path = core_zone_dir / "debug_zone.json"
    if not core_index_path.is_file() or not debug_zone_path.is_file():
        raise FileNotFoundError(
            f"Le template Zone PMDO 0.8.12 manque sous {core_zone_dir} "
            "(index.idx/debug_zone.json)."
        )
    core_index = load_json(core_index_path)
    core_object = core_index.get("Object")
    if not isinstance(core_object, dict) or not isinstance(core_object.get("debug_zone"), dict):
        raise ValueError("L'index Zone du runtime n'a pas le modèle debug_zone attendu.")
    zone_template = load_json(debug_zone_path)
    zone_object = zone_template.get("Object")
    if not isinstance(zone_object, dict) or zone_object.get("$type") != "RogueEssence.Data.ZoneData, RogueEssence":
        raise ValueError("debug_zone.json n'est pas un ZoneData PMDO reconnu.")
    if str(zone_template.get("Version", "")) != EXPECTED_GAME_VERSION:
        raise ValueError(f"Le template Zone vise {zone_template.get('Version')!r}, pas {EXPECTED_GAME_VERSION}.")

    target.mkdir(parents=True, exist_ok=False)
    (target / "Mod.xml").write_bytes(output_mod_xml())
    zone_dir = target / "Data/Zone"
    zone_dir.mkdir(parents=True)

    # Keep only the native ZoneEntrySummary shape, not the 51 narrative/base zones.
    index_object = {
        "$type": core_object["$type"],
        ZONE_ID: copy.deepcopy(core_object["debug_zone"]),
    }
    index_entry = index_object[ZONE_ID]
    index_entry["Grounds"] = []
    index_entry["Maps"] = []
    index_entry["Name"] = localized_name()
    index_entry["Released"] = False
    index_entry["Comment"] = ZONE_COMMENT
    index_entry["SortOrder"] = 0
    index_document = {"Version": EXPECTED_GAME_VERSION, "Object": index_object}
    (zone_dir / "index.idx").write_text(
        "\ufeff" + json.dumps(index_document, ensure_ascii=False, indent=1) + "\n",
        encoding="utf-8",
    )

    zone_template["Version"] = EXPECTED_GAME_VERSION
    zone_object["Name"] = localized_name()
    zone_object["Released"] = False
    zone_object["Comment"] = ZONE_COMMENT
    zone_object["Segments"] = []
    zone_object["GroundMaps"] = []
    (zone_dir / f"{ZONE_ID}.json").write_text(
        json.dumps(zone_template, ensure_ascii=False, indent=1) + "\n",
        encoding="utf-8",
    )


def extract_overlay(archive_path: Path, destination: Path) -> Path:
    prefix = OVERLAY_ROOT_NAME + "/"
    destination.mkdir(parents=True, exist_ok=False)
    with zipfile.ZipFile(archive_path) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"CRC invalide dans l'overlay source : {bad}")
        for info in archive.infolist():
            name = PurePosixPath(info.filename)
            if name.is_absolute() or ".." in name.parts or "\\" in info.filename:
                raise ValueError(f"Chemin ZIP dangereux : {info.filename}")
            if info.filename.rstrip("/") == OVERLAY_ROOT_NAME and info.is_dir():
                continue
            if not info.filename.startswith(prefix):
                raise ValueError(f"Membre hors racine attendue {OVERLAY_ROOT_NAME}: {info.filename}")
            mode = info.external_attr >> 16
            if stat.S_ISLNK(mode):
                raise ValueError(f"Lien symbolique interdit dans le ZIP : {info.filename}")
            relative = PurePosixPath(*name.parts[1:])
            target = destination.joinpath(*relative.parts)
            if not target.resolve().is_relative_to(destination.resolve()):
                raise ValueError(f"Extraction hors dossier interdite : {info.filename}")
            if info.is_dir():
                target.mkdir(parents=True, exist_ok=True)
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            with archive.open(info) as source, target.open("wb") as output:
                shutil.copyfileobj(source, output, length=1024 * 1024)
    overlay_root = destination
    if not (overlay_root / MANIFEST_PATH).is_file():
        raise ValueError("Manifeste catalogue absent de l'overlay candidat.")
    return overlay_root


def install_hardlinked(overlay: Path, quest: Path) -> dict:
    """Install a fresh Quest without doubling multi-gigabyte asset storage."""
    _, source_grounds = validate_overlay(overlay)
    plan = safe_copy_plan(overlay, quest)
    ground_ids = ground_ids_after_merge(quest, source_grounds)
    tile_index_data, tile_count = merged_tile_index(overlay, quest)
    zone_data, zone_index_data = zone_documents(quest, ground_ids)
    pending = {
        quest / "Data/Zone" / f"{ZONE_ID}.json": zone_data,
        quest / "Data/Zone/index.idx": zone_index_data,
        quest / "Content/Tile/index.idx": tile_index_data,
    }
    created: list[Path] = []
    old_metadata: list[tuple[Path, bytes | None]] = []
    try:
        for source, destination in plan:
            destination.parent.mkdir(parents=True, exist_ok=True)
            if source.stat().st_dev != destination.parent.stat().st_dev:
                raise OSError("Le staging et les assets source ne partagent pas le même volume pour hardlinks.")
            os.link(source, destination)
            created.append(destination)
        for path, data in pending.items():
            old = path.read_bytes() if path.exists() else None
            if old == data:
                continue
            old_metadata.append((path, old))
            atomic_write(path, data)
    except Exception:
        for path in reversed(created):
            path.unlink(missing_ok=True)
        for path, old in reversed(old_metadata):
            if old is None:
                path.unlink(missing_ok=True)
            else:
                atomic_write(path, old)
        raise
    print(f"Quest : PMD Destiny — Cartothèque ({QUEST_NAMESPACE})")
    print(f"Grounds copiés par hardlink : {len(source_grounds)}")
    print(f"Grounds visibles dans {ZONE_ID} : {len(ground_ids)}")
    print(f"Tilesets dans l’index fusionné : {tile_count}")
    print(f"Assets liés : {len(plan)}")
    return {"grounds": len(source_grounds), "groundMapsVisible": len(ground_ids),
            "tilesets": tile_count, "filesLinked": len(plan)}


def attach_documents(overlay: Path, quest: Path) -> tuple[dict, list[str]]:
    source_manifest = load_json(overlay / MANIFEST_PATH)
    occurrences = source_manifest.get("sourceOccurrences", [])
    unresolved = [
        str(row.get("entryId")) for row in occurrences
        if row.get("probeMapId") is None
    ]
    if len(source_manifest.get("maps", [])) != 246 or len(occurrences) != 262 or len(unresolved) != 16:
        raise ValueError("L'overlay n'est pas le périmètre documenté 246/262/16.")

    docs = quest / "Documentation"
    docs.mkdir(parents=True, exist_ok=True)
    source_docs = overlay / "Documentation"
    if source_docs.is_dir():
        for source in sorted(source_docs.rglob("*")):
            if not source.is_file():
                continue
            relative = source.relative_to(source_docs)
            if relative.as_posix() == "overlay_manifest.json":
                relative = Path("source_overlay_manifest.json")
            destination = docs / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)

    mod_root = ET.fromstring((quest / "Mod.xml").read_bytes())
    mod_uuid = (mod_root.findtext("UUID") or "").strip()
    mod_name = (mod_root.findtext("Name") or "").strip()
    if (mod_root.findtext("Namespace") or "").strip() != QUEST_NAMESPACE:
        raise ValueError("Le Mod.xml généré ne porte pas le namespace destiny.")
    quest_build = {
        "name": mod_name,
        "namespace": QUEST_NAMESPACE,
        "uuid": mod_uuid,
        "gameVersion": EXPECTED_GAME_VERSION,
        "modType": "Quest",
        "identitySource": "Mod.xml déterministe du prototype Destiny 208-Ground (inchangé)",
        "groundMapsInQuest": len(source_manifest["maps"]),
        "sourceOccurrencesInInventory": len(occurrences),
        "sourceOccurrencesWithoutGround": len(unresolved),
        "unavailableSourceEntryIds": unresolved,
        "developerZone": ZONE_ID,
        "developerZoneGroundCount": len(source_manifest["maps"]),
        "narrativeZonesAdded": False,
        "storyTransitionsAdded": False,
        "placeholderGroundsCreated": False,
        "scope": "New standalone cartotheque Quest; not a narrative/gameplay certification.",
    }
    (docs / "QUEST_BUILD.json").write_text(
        json.dumps(quest_build, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (quest / "README.md").write_text(
        "# PMD Destiny — cartothèque PMDO 0.8.12\n\n"
        "Cette **nouvelle quête PMDO** réunit les Grounds disponibles dans une seule installation, "
        "sous le namespace `destiny`. Elle reprend exactement le `Mod.xml` et l’UUID stables du "
        "prototype Destiny 208, puis remplace son catalogue de cartes par les assets validés disponibles.\n\n"
        f"- **{len(source_manifest['maps'])} Grounds** déclarés dans la zone développeur `{ZONE_ID}`.\n"
        "- 1 059 TileSheets et 33 fonds; aucun contenu de remplacement n’est inventé.\n"
        f"- L’inventaire garde les **{len(occurrences)} occurrences source** et leur provenance. "
        f"Les {len(unresolved)} sans Ground sont listées dans `Documentation/QUEST_BUILD.json` et "
        "`Documentation/destiny_262_inventory.json`.\n\n"
        "Cette cartothèque ne contient pas de scénario, de transitions ou de zones narratives. "
        "Elle n’est pas une certification de rendu/jouabilité.\n\n"
        "## Installation\n\n"
        "Extraire le dossier `destiny` dans `PMDO/MODS/`, activer la quête "
        "`PMD Destiny — Catalogue d’exploration 0.8.12`, puis ouvrir `{ZONE_ID}` en mode développeur.\n"
        "Le `Mod.xml` est inclus dans cette nouvelle quête; il n’écrase aucun dossier extérieur.\n",
        encoding="utf-8",
    )
    return quest_build, unresolved


def validate_quest(quest: Path, expected_maps: int = 246) -> dict:
    manifest, grounds = validate_overlay(quest)
    if len(grounds) != expected_maps:
        raise ValueError(f"Grounds dans la quête : {len(grounds)}, attendu {expected_maps}.")
    root = ET.parse(quest / "Mod.xml").getroot()
    if (root.findtext("Namespace") or "").strip() != QUEST_NAMESPACE:
        raise ValueError("Namespace de la quête incorrect.")
    if (root.findtext("ModType") or "").strip().casefold() != "quest":
        raise ValueError("ModType de la quête incorrect.")
    if (root.findtext("GameVersion") or "").strip() != EXPECTED_GAME_VERSION:
        raise ValueError("GameVersion de la quête incorrect.")

    ids = sorted(path.stem for path in grounds)
    zone = load_json(quest / "Data/Zone" / f"{ZONE_ID}.json")["Object"]
    index_doc = load_json(quest / "Data/Zone/index.idx")
    index_entry = index_doc["Object"][ZONE_ID]
    if zone.get("GroundMaps") != ids or index_entry.get("Grounds") != ids:
        raise ValueError("La zone développeur n'énumère pas chacun des Grounds de la quête.")
    if zone.get("Segments") != [] or index_entry.get("Maps") != []:
        raise ValueError("La zone cartothèque ne doit ajouter aucun segment ou warp.")

    tile_index = read_index_bytes((quest / "Content/Tile/index.idx").read_bytes())
    tiles = list((quest / "Content/Tile").glob("*.tile"))
    backgrounds = list((quest / "Content/BG").glob("*.dir"))
    if len(tile_index) != 1059 or len(tiles) != 1059 or len(backgrounds) != 33:
        raise ValueError("Comptes d'assets de la quête différents du staging validé.")
    return {
        "grounds": len(grounds),
        "tilesheets": len(tiles),
        "backgrounds": len(backgrounds),
        "zoneGrounds": len(zone["GroundMaps"]),
        "sourceOccurrences": len(manifest.get("sourceOccurrences", [])),
        "sourceEntryIdsWithoutGround": [
            row.get("entryId") for row in manifest.get("sourceOccurrences", [])
            if row.get("probeMapId") is None
        ],
        "uuid": (root.findtext("UUID") or "").strip(),
    }


def write_zip(quest: Path, output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(f".{output.name}.tmp")
    temporary.unlink(missing_ok=True)
    try:
        with zipfile.ZipFile(
            temporary, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9, allowZip64=True
        ) as archive:
            for path in sorted(quest.rglob("*"), key=lambda value: value.relative_to(quest).as_posix().casefold()):
                if not path.is_file():
                    continue
                relative = PurePosixPath("destiny", path.relative_to(quest).as_posix())
                info = zipfile.ZipInfo(str(relative), date_time=(2026, 10, 30, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o644 << 16
                with path.open("rb") as source, archive.open(info, "w", force_zip64=True) as destination:
                    shutil.copyfileobj(source, destination, length=1024 * 1024)
        with zipfile.ZipFile(temporary) as archive:
            bad = archive.testzip()
            if bad:
                raise ValueError(f"CRC invalide dans la quête assemblée : {bad}")
            names = set(archive.namelist())
            if "destiny/Mod.xml" not in names or f"destiny/Data/Zone/{ZONE_ID}.json" not in names:
                raise ValueError("Mod.xml ou zone développeur absent du ZIP final.")
            ground_files = [name for name in names if name.startswith("destiny/Data/Ground/") and name.endswith(".rsground")]
            if len(ground_files) != 246:
                raise ValueError(f"Le ZIP contient {len(ground_files)} Grounds, attendu 246.")
        os.replace(temporary, output)
    finally:
        temporary.unlink(missing_ok=True)


def finalize_validation(staging: Path, output: Path, ground_report: Path, zone_report: Path) -> dict:
    staging = staging.resolve()
    output = output.resolve()
    ground_report = ground_report.resolve()
    zone_report = zone_report.resolve()
    quest = staging / "destiny"
    if not (quest / "Documentation/QUEST_BUILD.json").is_file():
        raise FileNotFoundError(f"Quête cartothèque non assemblée : {quest}")
    if not ground_report.is_file() or not zone_report.is_file():
        raise FileNotFoundError("Les deux rapports runtime PMDO sont nécessaires à la finalisation.")

    ground_lines = ground_report.read_text(encoding="utf-8").splitlines()
    ground_header = {}
    data_lines = []
    for line in ground_lines:
        if not line:
            continue
        if line.startswith("# "):
            key, _, value = line[2:].partition("\t")
            ground_header[key] = value
        else:
            data_lines.append(line.split("\t"))
    if not data_lines or data_lines[0][0] != "sourceRow":
        raise ValueError("En-tête TSV du rapport Ground invalide.")
    ground_rows = data_lines[1:]
    if (len(ground_rows) != 246 or any(len(row) < 11 or row[10] != "PASS" for row in ground_rows)
            or len({row[3].casefold() for row in ground_rows}) != 246
            or ground_header.get("batches") != "13"):
        raise ValueError("Le probe Ground final ne prouve pas 246/246 PASS en 13 lots.")

    zone_rows = [line.split("\t") for line in zone_report.read_text(encoding="utf-8").splitlines() if line]
    if (len(zone_rows) != 4 or zone_rows[0] != ["test", "value", "status"]
            or zone_rows[1] != ["zone", ZONE_ID, "PASS"]
            or zone_rows[2] != ["groundMaps", "246", "PASS"]
            or zone_rows[3] != ["segments", "0", "PASS"]):
        raise ValueError("Le probe runtime Zone n'atteste pas exploration_cartes=246/0 segments.")

    docs = quest / "Documentation"
    reports = docs / "Reports"
    reports.mkdir(parents=True, exist_ok=True)
    # The report's hash covers Ground paths and payloads, not documentation files.
    safe_ground_report = []
    for line in ground_lines:
        if line.startswith("# package\t"):
            safe_ground_report.append("# package\tdestiny/")
        else:
            safe_ground_report.append(line)
    (reports / "destiny_map_quest_246_ground_runtime_results.tsv").write_text(
        "\n".join(safe_ground_report) + "\n", encoding="utf-8"
    )
    shutil.copy2(zone_report, reports / "destiny_map_quest_246_zone_runtime_results.tsv")

    build_path = docs / "QUEST_BUILD.json"
    build = json.loads(build_path.read_text(encoding="utf-8"))
    build["runtimeGroundProbe"] = {
        "status": "PASS",
        "passed": len(ground_rows),
        "failed": 0,
        "batches": 13,
        "inputSha256": ground_header.get("input_sha256"),
        "report": "Documentation/Reports/destiny_map_quest_246_ground_runtime_results.tsv",
    }
    build["runtimeDeveloperZoneProbe"] = {
        "status": "PASS",
        "zone": ZONE_ID,
        "groundMaps": 246,
        "narrativeSegments": 0,
        "report": "Documentation/Reports/destiny_map_quest_246_zone_runtime_results.tsv",
    }
    build_path.write_text(json.dumps(build, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    readme = quest / "README.md"
    text = readme.read_text(encoding="utf-8")
    marker = "- 1 059 TileSheets et 33 fonds; aucun contenu de remplacement n’est inventé.\n"
    addition = (
        marker
        + "- Runtime PMDO 0.8.12.0 : **Ground 246/246 PASS en 13 lots** et zone `exploration_cartes` chargée avec 246 Grounds, 0 segment narratif. Rapports dans `Documentation/Reports/`.\n"
    )
    if marker not in text:
        raise ValueError("Ligne de compte d'assets absente du README pour ajouter le statut runtime.")
    readme.write_text(text.replace(marker, addition, 1), encoding="utf-8")

    summary = validate_quest(quest)
    write_zip(quest, output)
    return {
        "output": str(output),
        "bytes": output.stat().st_size,
        "sha256": sha256_file(output),
        "crc": "PASS",
        "groundRuntime": "PASS 246/246, 13 batches",
        "zoneRuntime": "PASS exploration_cartes, 246 GroundMaps, 0 segments",
        "namespace": QUEST_NAMESPACE,
        "uuid": summary["uuid"],
    }


def build(overlay_zip: Path, output: Path, staging: Path, pmdo_root: Path, force: bool = False) -> dict:
    overlay_zip = overlay_zip.resolve()
    output = output.resolve()
    staging = staging.resolve()
    pmdo_root = pmdo_root.resolve()
    cache_root = (ROOT / ".cache/destiny-recovery").resolve()
    if not staging.is_relative_to(cache_root) or staging == cache_root:
        raise ValueError("Le staging doit rester sous .cache/destiny-recovery/.")
    if not overlay_zip.is_file():
        raise FileNotFoundError(overlay_zip)
    if output.exists() and not force:
        raise FileExistsError(f"La sortie existe déjà (utiliser --force) : {output}")
    if staging.exists():
        if not force:
            raise FileExistsError(f"Le staging existe déjà (utiliser --force) : {staging}")
        shutil.rmtree(staging)
    staging.mkdir(parents=True)
    overlay_extract = staging / "overlay_extract"
    overlay = extract_overlay(overlay_zip, overlay_extract)
    quest = staging / "destiny"
    seed_quest(quest, pmdo_root)
    install_hardlinked(overlay, quest)
    quest_build, unresolved = attach_documents(overlay, quest)
    summary = validate_quest(quest)
    write_zip(quest, output)
    return {
        "questDirectory": str(quest),
        "output": str(output),
        "bytes": output.stat().st_size,
        "sha256": sha256_file(output),
        "crc": "PASS",
        "identity": {
            "namespace": QUEST_NAMESPACE,
            "uuid": quest_build["uuid"],
            "gameVersion": EXPECTED_GAME_VERSION,
            "modType": "Quest",
        },
        "maps": summary["grounds"],
        "visibleDeveloperZone": summary["zoneGrounds"],
        "tilesheets": summary["tilesheets"],
        "backgrounds": summary["backgrounds"],
        "sourceOccurrences": summary["sourceOccurrences"],
        "sourceOccurrencesWithoutGround": len(unresolved),
        "unavailableSourceEntryIds": unresolved,
        "ModXmlIncluded": True,
        "narrativeZonesAdded": False,
        "storyTransitionsAdded": False,
        "runtimeGroundProbe": "PENDING",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--overlay", type=Path, default=OVERLAY_DEFAULT)
    parser.add_argument("--output", type=Path, default=OUTPUT_DEFAULT)
    parser.add_argument("--staging", type=Path, default=STAGING_DEFAULT)
    parser.add_argument("--pmdo-root", type=Path, default=PMDO_ROOT_DEFAULT,
                        help="Racine du PMDO 0.8.12 installé, pour le modèle Zone natif")
    parser.add_argument("--force", action="store_true", help="remplacer uniquement sortie/staging de génération")
    parser.add_argument("--finalize-validation", action="store_true",
                        help="inclure les deux rapports runtime déjà produits et regénérer le ZIP")
    parser.add_argument("--ground-report", type=Path,
                        default=ROOT / "source/pmdo_runtime/destiny_map_quest_246_ground_runtime_results.tsv")
    parser.add_argument("--zone-report", type=Path,
                        default=ROOT / "source/pmdo_runtime/destiny_map_quest_246_zone_runtime_results.tsv")
    args = parser.parse_args()
    if args.finalize_validation:
        result = finalize_validation(args.staging, args.output, args.ground_report, args.zone_report)
    else:
        result = build(args.overlay, args.output, args.staging, args.pmdo_root, args.force)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
