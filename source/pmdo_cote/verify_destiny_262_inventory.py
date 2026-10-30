#!/usr/bin/env python3
"""Check the tracked 262-occurrence Destiny inventory and reconstruction report.

This validation uses only tracked JSON/TSV. It does not infer unique maps by
collapsing duplicates, inspect ignored staging, or certify graphical/gameplay
behavior.
"""
from __future__ import annotations

import hashlib
import io
import json
from pathlib import Path
import zipfile
import xml.etree.ElementTree as ET
from collections import Counter

ROOT = Path(__file__).resolve().parents[2]
INVENTORY = ROOT / "source/pmdo_cote/destiny_262_inventory.json"
RUNTIME_RESULTS = ROOT / "source/pmdo_runtime/destiny_empty_branch_reconstruction_0812_results.tsv"
GROUND_CANDIDATE_RESULTS = ROOT / "source/pmdo_runtime/destiny_candidate_246_ground_runtime_results.tsv"
TILEGUIDE_RESULTS = ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_runtime_results.tsv"
TILEGUIDE_SUMMARY = ROOT / "source/pmdo_runtime/destiny_candidate_246_tileguide_summary.json"
OVERLAY_GROUND_RESULTS = ROOT / "source/pmdo_runtime/destiny_candidate_246_overlay_ground_runtime_results.tsv"
OVERLAY_CANDIDATE = ROOT / "exports/pmdo/PMD_Destiny_Quest_Overlay_Candidate_246_0812.zip"
STANDALONE_QUEST = ROOT / "exports/pmdo/PMD_Destiny_Map_Quest_246_0812.zip"
REBRANDED_EXPEDITIONS_ARCHIVE = ROOT / "mod_treasure_expeditions_pmdo_0812.zip"
SOURCE_PAYLOAD_BACKUP = ROOT / "exports/treasure_rename/source_payloads_before_rename_2026-10-30.zip"
MIGRATION_REPORT = ROOT / "exports/treasure_rename/migration_report.json"
QUEST_GROUND_RESULTS = ROOT / "source/pmdo_runtime/destiny_map_quest_246_zip_ground_runtime_results.tsv"
QUEST_ZONE_RESULTS = ROOT / "source/pmdo_runtime/destiny_map_quest_246_zone_runtime_results.tsv"
EXPECTED_CATEGORY_COUNTS = {"zip_archive": 126, "arena_branch": 39, "generated_build": 97}
RECONSTRUCTED_IDS = {"branch_012", "branch_013", "branch_014", "branch_015", "branch_016"}


def fail(message: str) -> None:
    raise SystemExit(f"FAIL — {message}")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def data_rows(path: Path) -> list[list[str]]:
    return [line.split("\t") for line in path.read_text(encoding="utf-8").splitlines()
            if line and not line.startswith("#")]


def main() -> None:
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    entries = inventory.get("entries")
    if not isinstance(entries, list) or len(entries) != 262:
        fail(f"occurrences source = {len(entries) if isinstance(entries, list) else 'invalid'}, attendu 262")
    ids = [entry.get("entryId") for entry in entries]
    if len(set(ids)) != 262 or any(not item for item in ids):
        fail("entryId absent ou en double; les occurrences doivent rester distinctes")

    categories = Counter(entry.get("sourceCategory") for entry in entries)
    if dict(categories) != EXPECTED_CATEGORY_COUNTS:
        fail(f"comptes catégories non conformes : {dict(categories)}")
    hashes = [entry.get("groundSha256") for entry in entries]
    if any(not isinstance(digest, str) or len(digest) != 64 for digest in hashes):
        fail("hash Ground absent/invalide")
    unique_hashes = len(set(hashes))
    duplicate_occurrences = len(hashes) - unique_hashes
    if (unique_hashes, duplicate_occurrences) != (229, 33):
        fail(f"réconciliation hashes incorrecte : {unique_hashes} uniques, {duplicate_occurrences} doublons")

    # Keep the exact source hash and the active rebranded-payload hash distinct.
    migration = inventory.get("sourcePayloadRebranding", {})
    if (migration.get("sourcePayloadsPreservedByteForByte") is not True
            or migration.get("activeArchive") != REBRANDED_EXPEDITIONS_ARCHIVE.name):
        fail("provenance de la migration de marque absente ou incohérente")
    rebranded_entries = [entry for entry in entries if entry.get("rebrandedGroundSha256")]
    if len(rebranded_entries) != 40 or not REBRANDED_EXPEDITIONS_ARCHIVE.is_file() or not SOURCE_PAYLOAD_BACKUP.is_file():
        fail("les 40 hashes rebrandés ou leur sauvegarde exacte sont absents")
    migration_report = json.loads(MIGRATION_REPORT.read_text(encoding="utf-8"))
    if sha256_file(REBRANDED_EXPEDITIONS_ARCHIVE) != migration_report.get("packageArchive", {}).get("rebrandedArchiveSha256"):
        fail("SHA-256 du paquet rebrandé différent du rapport de migration")
    with zipfile.ZipFile(REBRANDED_EXPEDITIONS_ARCHIVE) as current_zip, zipfile.ZipFile(SOURCE_PAYLOAD_BACKUP) as snapshot:
        if current_zip.testzip() is not None:
            fail("CRC du paquet rebrandé incorrect")
        current_ground_hashes = json.loads(current_zip.read("treasure_expeditions/ground_sha256.json"))
        snapshot_manifest = json.loads(snapshot.read("PRESERVATION_MANIFEST.json"))
        source_archive_row = next((row for row in snapshot_manifest["files"]
                                   if row.get("rebrandedPath") == REBRANDED_EXPEDITIONS_ARCHIVE.name), None)
        if source_archive_row is None:
            fail("archive source exacte absente de la sauvegarde")
        original_archive_bytes = snapshot.read(source_archive_row["backupMember"])
        if sha256_file(SOURCE_PAYLOAD_BACKUP) != migration.get("preMigrationPayloadBackupSha256"):
            fail("SHA-256 de la sauvegarde source incohérent")
        with zipfile.ZipFile(io.BytesIO(original_archive_bytes)) as original_zip:
            source_hash_member = next(name for name in original_zip.namelist() if name.endswith("/ground_sha256.json"))
            source_ground_hashes = json.loads(original_zip.read(source_hash_member))
            for entry in rebranded_entries:
                locator = entry.get("sourceLocator", {})
                member = locator.get("member", "")
                basename = Path(member).name
                if (locator.get("archive") != REBRANDED_EXPEDITIONS_ARCHIVE.name
                        or not member.startswith("treasure_expeditions/Data/Ground/")
                        or entry.get("groundSha256") != source_ground_hashes.get(basename)
                        or entry.get("rebrandedGroundSha256") != current_ground_hashes.get(basename)):
                    fail(f"hash source/rebrand incohérent pour {entry.get('entryId')}")

    preview = sum(bool(entry.get("previewEligible")) for entry in entries)
    blocked = len(entries) - preview
    if (preview, blocked) != (249, 13):
        fail(f"statuts aperçu incorrects : {preview} candidats, {blocked} bloqués")
    blocked_entries = [entry for entry in entries if not entry.get("previewEligible")]
    if any(entry.get("sourceCategory") != "arena_branch" or entry.get("assetStatus") != "assets_blocked"
           for entry in blocked_entries):
        fail("une occurrence non prévisualisable n'est pas explicitement bloquée par ses assets")

    branch = [entry for entry in entries if entry.get("sourceCategory") == "arena_branch"]
    status_counts = Counter(entry.get("assetStatus") for entry in branch)
    if status_counts != Counter({"assets_ok": 21, "assets_blocked": 13,
                                 "reconstructed_native_assets_from_source": 5}):
        fail(f"statuts branche incorrects : {dict(status_counts)}")
    reconstructed = {entry.get("entryId"): entry for entry in branch if entry.get("reconstruction")}
    if set(reconstructed) != RECONSTRUCTED_IDS:
        fail(f"IDs reconstruits incorrects : {sorted(reconstructed)}")

    audit = inventory.get("branchEmptyGridReconstructionAudit", {})
    audit_maps = {row.get("entryId"): row for row in audit.get("maps", [])}
    if set(audit_maps) != RECONSTRUCTED_IDS:
        fail("les cinq occurrences reconstruites manquent dans l'audit de provenance")
    if audit.get("reconstructedOutputGroundRuntimeTested") is not True:
        fail("l'audit ne distingue pas le probe natif de sortie du Ground source vide")
    if audit.get("results", {}).get("playabilityCertified") is not False:
        fail("la sortie reconstruite ne doit pas être marquée jouable")

    rows = [line.split("\t") for line in RUNTIME_RESULTS.read_text(encoding="utf-8").splitlines() if line]
    if not rows or rows[0] != ["INDEX", "33", "PASS"]:
        fail(f"résultat TileGuide absent/invalide : {rows[:1]}")
    ground_rows = [row for row in rows if row[0] == "GROUND"]
    tile_rows = [row for row in rows if row[0] == "TILEINDEX"]
    if len(ground_rows) != 5 or any(row[-1] != "PASS" for row in ground_rows):
        fail("le probe runtime n'atteste pas 5/5 Ground reconstruit")
    if len(tile_rows) != 5 or any(row[-1] != "true" or row[-2] != "0" for row in tile_rows):
        fail("le probe runtime n'atteste pas la résolution des cinq TileIndex")
    runtime_coords = sum(int(row[2]) for row in tile_rows)
    if runtime_coords != 89875 or runtime_coords != inventory["summary"]["branchReconstructedUniqueTileCoordinatesResolved"]:
        fail(f"compte des coordonnées natives incohérent : {runtime_coords}")
    runtime_ids = {row[1] for row in ground_rows}
    if runtime_ids != {row["reconstruction"]["outputMapId"] for row in reconstructed.values() }:
        fail("les identifiants Ground du probe ne correspondent pas aux cinq reconstructions")

    summary = inventory["summary"]
    probes = summary["nativeRuntimeProbeCallsBySource"]
    if sum(probes.values()) != 249 or summary["sourceOccurrencesCoveredByPassingProbes"] != 262:
        fail("les compteurs de probes source ne réconcilient pas les occurrences")
    if summary["sourceOccurrencesNotPassingOrNotTested"] != 0:
        fail("compteur d'occurrences couvertes incohérent")
    if inventory.get("status") != "INCOMPLETE_NOT_PLAYABILITY_CERTIFIED":
        fail("le statut global ne doit pas prétendre à l'achèvement ou à la jouabilité")
    overlay = inventory.get("overlayIntegration", {})
    if overlay.get("final262OverlayBuilt") is not False:
        fail("l'état overlay 262 n'est pas honnêtement déclaré incomplet")
    if overlay.get("partial246OverlayBuilt") is not True or overlay.get("actualDestinyOverlayInstalled") is not False:
        fail("l'état partiel 246 ou l'absence d'installation réelle est mal consigné")
    partial = overlay.get("partial246OverlayCandidate", {})
    if (partial.get("groundOccurrences"), partial.get("tileSheets"), partial.get("backgrounds")) != (246, 1059, 33):
        fail("les comptes de l'overlay candidat 246 sont incohérents")
    if partial.get("crc") != "PASS" or partial.get("modXmlIncluded") is not False:
        fail("CRC ou règle de préservation du Mod.xml incorrecte")
    if set(overlay.get("generatedGroundOutputUnavailable", [])) != {"generated_002", "generated_007", "generated_029"}:
        fail("les trois Grounds générés sans sortie ne sont pas correctement consignés")
    if set(overlay.get("generatedRebuildHashMismatchVariants", [])) != {"generated_030", "generated_031", "generated_035"}:
        fail("les trois variantes de build divergentes ne sont pas explicitement signalées")

    ground_candidate_rows = data_rows(GROUND_CANDIDATE_RESULTS)
    ground_candidate_data = [row for row in ground_candidate_rows if row[0] != "sourceRow"]
    if len(ground_candidate_data) != 246 or any(row[10] != "PASS" for row in ground_candidate_data):
        fail("le probe Ground-only candidat ne valide pas 246/246 occurrences")
    if len({row[3].casefold() for row in ground_candidate_data}) != 246:
        fail("les doublons candidats ne disposent pas d'IDs runtime distincts")

    tile_summary = json.loads(TILEGUIDE_SUMMARY.read_text(encoding="utf-8"))
    if (tile_summary.get("groundOccurrencesTested"), tile_summary.get("tileGuideMapsPassed"),
            tile_summary.get("missingTileCoordinates"), tile_summary.get("uniqueTileCoordinatesChecked"),
            tile_summary.get("tileSheets"), tile_summary.get("batches")) != (246, 246, 0, 2773093, 1059, 13):
        fail("le résumé TileGuide candidat ne valide pas les 246 Grounds/coordonnées")
    tile_rows_all = [line.split("\t") for line in TILEGUIDE_RESULTS.read_text(encoding="utf-8").splitlines() if line]
    index_rows_246 = [row for row in tile_rows_all if row[0] == "INDEX"]
    ground_rows_246 = [row for row in tile_rows_all if row[0] == "GROUND"]
    tile_rows_246 = [row for row in tile_rows_all if row[0] == "TILEGUIDE"]
    if len(index_rows_246) != 13 or any(row[1:] != ["1059", "PASS"] for row in index_rows_246):
        fail("TileGuide.Load n'a pas réussi dans les 13 lots")
    if len(ground_rows_246) != 246 or any(row[-1] != "PASS" for row in ground_rows_246):
        fail("le probe TileGuide n'atteste pas le Ground pour les 246 cartes")
    if len(tile_rows_246) != 246 or any(row[3] != "0" or row[4] != "true" for row in tile_rows_246):
        fail("des coordonnées TileGuide restent manquantes")

    overlay_ground_rows = data_rows(OVERLAY_GROUND_RESULTS)
    overlay_ground_data = [row for row in overlay_ground_rows if row[0] != "sourceRow"]
    if len(overlay_ground_data) != 246 or any(row[10] != "PASS" for row in overlay_ground_data):
        fail("l'archive overlay exacte ne passe pas 246/246 Grounds")
    report_hash = next((line.split("\t", 1)[1] for line in OVERLAY_GROUND_RESULTS.read_text(encoding="utf-8").splitlines()
                        if line.startswith("# input_sha256\t")), None)
    if report_hash != summary.get("candidateOverlayGroundRuntimeProbe", {}).get("inputSha256"):
        fail("le hash du rapport runtime overlay diffère du manifeste de livraison")

    archive_present = OVERLAY_CANDIDATE.is_file()
    if archive_present:
        recorded = partial
        if OVERLAY_CANDIDATE.stat().st_size != recorded.get("bytes") or sha256_file(OVERLAY_CANDIDATE) != recorded.get("sha256"):
            fail("l'archive overlay candidate diffère de son SHA/compte enregistré")
        with zipfile.ZipFile(OVERLAY_CANDIDATE) as archive:
            if archive.testzip() is not None:
                fail("CRC de l'archive overlay candidat incorrect")
            names = archive.namelist()
            prefix = "PMD_Destiny_Quest_Overlay_0812/"
            grounds = [name for name in names if name.startswith(prefix + "Data/Ground/") and name.endswith(".rsground")]
            tiles = [name for name in names if name.startswith(prefix + "Content/Tile/") and name.endswith(".tile")]
            backgrounds = [name for name in names if name.startswith(prefix + "Content/BG/") and name.endswith(".dir")]
            if (len(grounds), len(tiles), len(backgrounds)) != (246, 1059, 33):
                fail("les comptes d'assets dans l'archive finale diffèrent de l'inventaire")
            if any(name.endswith("/Mod.xml") for name in names):
                fail("le ZIP d'overlay ne doit pas embarquer un Mod.xml de remplacement")
            manifest_member = prefix + "Documentation/catalogue_manifest.json"
            packaged_manifest = json.loads(archive.read(manifest_member))
            if len(packaged_manifest.get("maps", [])) != 246 or len(packaged_manifest.get("sourceOccurrences", [])) != 262:
                fail("le manifeste embarqué ne conserve pas les 262 occurrences")
            unresolved = [row for row in packaged_manifest["sourceOccurrences"] if row.get("probeMapId") is None]
            if len(unresolved) != 16:
                fail(f"le manifeste embarqué devrait conserver 16 occurrences sans Ground, trouvé {len(unresolved)}")

    standalone = summary.get("standaloneQuestCartotheque", {})
    quest_package_present = STANDALONE_QUEST.is_file()
    if quest_package_present:
        if STANDALONE_QUEST.stat().st_size != standalone.get("bytes") or sha256_file(STANDALONE_QUEST) != standalone.get("sha256"):
            fail("le ZIP de la nouvelle quête Destiny diffère de son SHA/compte enregistré")
        with zipfile.ZipFile(STANDALONE_QUEST) as archive:
            if archive.testzip() is not None:
                fail("CRC de la nouvelle quête-cartothèque incorrect")
            names = set(archive.namelist())
            prefix = "destiny/"
            grounds = [name for name in names if name.startswith(prefix + "Data/Ground/") and name.endswith(".rsground")]
            tiles = [name for name in names if name.startswith(prefix + "Content/Tile/") and name.endswith(".tile")]
            backgrounds = [name for name in names if name.startswith(prefix + "Content/BG/") and name.endswith(".dir")]
            if (len(grounds), len(tiles), len(backgrounds)) != (246, 1059, 33):
                fail("les comptes d'assets de la nouvelle quête sont incorrects")
            if not {"destiny/Mod.xml", "destiny/Data/Zone/exploration_cartes.json",
                    "destiny/Data/Zone/index.idx", "destiny/Documentation/QUEST_BUILD.json"}.issubset(names):
                fail("la nouvelle quête manque Mod.xml, exploration_cartes ou son dossier build")
            header = ET.fromstring(archive.read("destiny/Mod.xml"))
            if ((header.findtext("Namespace") or "").strip(), (header.findtext("UUID") or "").strip(),
                    (header.findtext("GameVersion") or "").strip(), (header.findtext("ModType") or "").strip().casefold()) != (
                    "destiny", "1da28568-6363-5c51-8caa-9430b42862f0", "0.8.12.0", "quest"):
                fail("identité du Mod.xml standalone différente du namespace/UUID attendu")
            zone = json.loads(archive.read("destiny/Data/Zone/exploration_cartes.json"))["Object"]
            if len(zone.get("GroundMaps", [])) != 246 or zone.get("Segments") != []:
                fail("la zone `exploration_cartes` ne liste pas 246 Grounds sans segments narratifs")
            quest_manifest = json.loads(archive.read("destiny/Documentation/catalogue_manifest.json"))
            if len(quest_manifest.get("maps", [])) != 246 or len(quest_manifest.get("sourceOccurrences", [])) != 262:
                fail("le manifeste de la quête standalone ne conserve pas les 262 occurrences")
            quest_build = json.loads(archive.read("destiny/Documentation/QUEST_BUILD.json"))
            if (quest_build.get("runtimeGroundProbe", {}).get("status"),
                    quest_build.get("runtimeDeveloperZoneProbe", {}).get("status")) != ("PASS", "PASS"):
                fail("les probes natifs de la nouvelle quête ne sont pas consignés PASS")
        quest_ground_rows = data_rows(QUEST_GROUND_RESULTS)
        quest_ground_data = [row for row in quest_ground_rows if row[0] != "sourceRow"]
        quest_report_hash = next((line.split("\t", 1)[1] for line in QUEST_GROUND_RESULTS.read_text(encoding="utf-8").splitlines()
                                  if line.startswith("# input_sha256\t")), None)
        if len(quest_ground_data) != 246 or any(row[10] != "PASS" for row in quest_ground_data):
            fail("le probe natif de l'archive Quest exacte n'est pas 246/246 PASS")
        if quest_report_hash != standalone.get("groundRuntimeProbe", {}).get("inputSha256"):
            fail("hash du rapport Ground de la quête différent du registre")
        zone_report_rows = data_rows(QUEST_ZONE_RESULTS)
        if zone_report_rows != [["test", "value", "status"], ["zone", "exploration_cartes", "PASS"],
                                ["groundMaps", "246", "PASS"], ["segments", "0", "PASS"]]:
            fail("le probe natif de zone standalone ne confirme pas 246 Grounds/0 segment")

    print("PASS — 262 occurrences, 229 hashes Ground source distincts, 33 doublons préservés.")
    print("PASS — 40 payloads sources conservés avec hash d’origine et hash courant rebrandé séparés.")
    print("PASS — 249 sources éligibles; le candidat 246 conserve les 13 blocages et 3 sorties générées absentes.")
    print("PASS — Ground natif overlay 246/246; TileGuide 246/246, 1 059 feuilles, 2 773 093 coordonnées résolues.")
    print("PASS — overlay candidat CRC/assets/provenance vérifiés; aucun Mod.xml de remplacement dans l'overlay.")
    if quest_package_present:
        print("PASS — nouvelle Quest standalone CRC/Mod.xml; exploration_cartes et Ground 246/246 confirmés en runtime PMDO.")
    else:
        print("NOTE — ZIP standalone généré absent localement; les scripts et rapports permettent de le reconstruire.")
    print("Limite — la 262e carte complète, le rendu graphique, le spawn/collision gameplay et l'installation dans le PMDO utilisateur ne sont pas certifiés.")


if __name__ == "__main__":
    main()
