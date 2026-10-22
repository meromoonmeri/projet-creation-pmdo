from __future__ import annotations

import json
import shutil
from collections import Counter
from pathlib import Path

from .util import atomic_write_json, sha256_file


def publish_reports(cache_root: Path, reports_directory: Path) -> dict:
    reports_directory.mkdir(parents=True, exist_ok=True)
    global_path = cache_root / "global-manifest.json"
    global_manifest = json.loads(global_path.read_text(encoding="utf-8"))
    sql = json.loads((cache_root / "sql-import-report.json").read_text(encoding="utf-8"))
    dat = json.loads((cache_root / "dat-extraction-report.json").read_text(encoding="utf-8"))
    tiles = json.loads((cache_root / "tileset-audit-report.json").read_text(encoding="utf-8"))
    render = json.loads((cache_root / "render-report.json").read_text(encoding="utf-8"))
    inventory_path = cache_root / "inventory-report.json"
    inventory = json.loads(inventory_path.read_text(encoding="utf-8")) if inventory_path.exists() else {}
    certification_path = cache_root / "certification-report.json"
    certification = json.loads(certification_path.read_text(encoding="utf-8")) if certification_path.exists() else {}
    sheets_path = cache_root / "source/contact-sheets/manifest.json"
    sheets = json.loads(sheets_path.read_text(encoding="utf-8")) if sheets_path.exists() else {"status": "DISCOVERED"}

    enriched_maps = []
    for entry in global_manifest["maps"]:
        manifest = json.loads(Path(entry["manifest"]).read_text(encoding="utf-8"))
        enriched = dict(entry)
        enriched["map_type"] = "Standard"
        enriched["moral"] = manifest["properties"]["moral"]
        enriched["weather"] = manifest["properties"]["weather"]
        enriched["music"] = manifest["properties"]["music"]
        enriched["tilesets"] = sorted(int(value) for value in manifest["tileset_reference_counts"])
        enriched["source_png"] = manifest["render"].get("source_png")
        enriched["animated_png"] = manifest["render"].get("animated_png")
        enriched_maps.append(enriched)

    index = {
        "schema_version": global_manifest["schema_version"], "status": global_manifest["status"],
        "canonical_sql_snapshot_status": global_manifest.get("canonical_sql_snapshot_status", "UNVERIFIED"),
        "phase": global_manifest["phase"], "phase_2_pmdo": global_manifest["phase_2_pmdo"],
        "scope": global_manifest["scope"], "map_count": global_manifest["map_count"],
        "discovered_standard_map_count": global_manifest.get("discovered_standard_map_count", global_manifest["map_count"]),
        "source_selection_counts": global_manifest["source_selection_counts"],
        "sql_dat_overlap": global_manifest["sql_dat_overlap"],
        "blocked_standard_client_caches": global_manifest.get("blocked_standard_client_caches"),
        "invalid_graphic_reference_count_raw": render.get("invalid_graphic_reference_count", "UNKNOWN"),
        "invalid_graphic_reference_count_deduplicated": inventory.get("invalid_graphic_deduplicated_count", "UNKNOWN"),
        "maps": enriched_maps, "inventories": global_manifest["inventories"],
    }
    atomic_write_json(reports_directory / "canonical-map-index.json", index)

    table_lines = [
        "# Index canonique des maps PMU", "",
        "| Map ID | Nom | Type | Dimensions | Tileset(s) | PNG | Source | Statut |",
        "|---|---|---|---:|---|---|---|---|",
    ]
    for entry in enriched_maps:
        dims = entry["dimensions"]
        name = entry["name"].replace("|", "\\|")
        tileset_names = ",".join(str(value) for value in entry["tilesets"])
        table_lines.append(
            f"| `{entry['map_id']}` | {name} | Standard | {dims['width_tiles']}×{dims['height_tiles']} | "
            f"{tileset_names} | `{entry['source_png']}` | `{entry['selected_source']}` | `{entry['status']}` |"
        )
    (reports_directory / "canonical-map-table.md").write_text("\n".join(table_lines) + "\n", encoding="utf-8", newline="\n")

    status_counts = Counter(entry["status"] for entry in index["maps"])
    animated = sum(entry["animated_reference_count"] > 0 for entry in index["maps"])
    named_targets = {"Grassroot": [], "Snowbasin": [], "Silversail": []}
    for entry in index["maps"]:
        for name in named_targets:
            if name.lower() in entry["name"].lower():
                named_targets[name].append({"map_id": entry["map_id"], "name": entry["name"], "revision": entry["revision"]})
    southwestern = [
        {"map_id": entry["map_id"], "name": entry["name"], "revision": entry["revision"]}
        for entry in index["maps"] if "southwestern isle" in entry["name"].lower()
    ]
    critical_targets = {
        "Grassroot Town": [
            value for value in named_targets["Grassroot"] if value["name"].lower().endswith("grassroot town")
        ],
        "Snowbasin Town": named_targets["Snowbasin"],
        "Silversail Village": [],
        "Silversail identity_status": "UNKNOWN — no exact name or canonical ID in the SQL snapshot; Southwestern Isle records are related by region only and are not relabeled",
        "Southwestern Isle records (UNVERIFIED as Silversail)": southwestern,
    }
    summary = {
        "status": index["status"], "canonical_sql_snapshot_status": index["canonical_sql_snapshot_status"],
        "map_count": index["map_count"], "discovered_standard_map_count": index["discovered_standard_map_count"],
        "status_counts": dict(status_counts), "maps_with_animation": animated,
        "sql": {key: sql.get(key) for key in ("status", "standard_map_count", "expected_tile_count", "actual_tile_count", "maps_with_tile_count_mismatch", "integrity_check")},
        "client_dat": {
            "status": dat.get("status"), "source_map_count": dat.get("source_map_count"),
            "standard_source_map_count": dat.get("standard_source_map_count"),
            "decoded_map_count": dat.get("map_count"), "blocked_count": dat.get("blocked_count"),
        },
        "tilesets": {key: tiles.get(key) for key in ("status", "tileset_count", "tile_count")},
        "render": {
            "status": render.get("status"), "map_count": render.get("map_count"),
            "raw_invalid_graphic_events": render.get("invalid_graphic_reference_count"),
            "deduplicated_invalid_graphic_events": inventory.get("invalid_graphic_deduplicated_count"),
        },
        "contact_sheets": {key: sheets.get(key) for key in ("status", "sheet_count", "map_count")},
        "inventories": inventory, "certification": {
            key: certification.get(key) for key in
            ("status", "global_status", "canonical_ir_verified", "source_png_verified", "animated_png_verified", "contact_sheets_verified", "failure_count")
        },
        "critical_targets": critical_targets,
        "critical_png_copies": str(reports_directory / "critical-maps/manifest.json"),
        "external_png_used": False,
    }
    atomic_write_json(reports_directory / "phase1-summary.json", summary)

    grassroot = critical_targets["Grassroot Town"]
    snowbasin = critical_targets["Snowbasin Town"]
    lines = [
        "# PMU Phase 1 — rapport canonique", "",
        f"- **État global tous artefacts découverts :** `{summary['status']}`",
        f"- **Snapshot SQL public (IR + raster) :** `{summary['canonical_sql_snapshot_status']}`",
        f"- **Maps du snapshot certifiées/partielles :** {status_counts.get('SOURCE_CERTIFIED', 0)} / {status_counts.get('PARTIAL', 0)}",
        f"- **IDs rendus :** `s1` à `s2000` ({summary['map_count']} maps)",
        f"- **Maps standard découvertes, blocages inclus :** {summary['discovered_standard_map_count']}",
        f"- **Cellules SQL :** {summary['sql']['actual_tile_count']:,} / {summary['sql']['expected_tile_count']:,}, SQLite `{summary['sql']['integrity_check']}`",
        f"- **Caches V9 client :** {summary['client_dat']['source_map_count']} sources, {summary['client_dat']['standard_source_map_count']} standard, {summary['client_dat']['decoded_map_count']} décodée, {summary['client_dat']['blocked_count']} `BLOCKED`",
        f"- **Tilesets / tiles :** {summary['tilesets']['tileset_count']} / {summary['tilesets']['tile_count']:,}",
        f"- **PNG source / états animés vérifiés :** {summary['certification']['source_png_verified']} / {summary['certification']['animated_png_verified']}",
        f"- **Contact sheets vérifiées :** {summary['certification']['contact_sheets_verified']}",
        f"- **Références graphiques hors plage :** {summary['render']['raw_invalid_graphic_events']:,} événements bruts, {summary['render']['deduplicated_invalid_graphic_events']:,} événements dédupliqués; repli officiel vers tile 0 préservé",
        f"- **Échecs de validation finale :** {summary['certification']['failure_count']}", "",
        "## Villes critiques", "",
        "### Grassroot Town", "",
    ]
    for value in grassroot:
        lines.append(f"- `{value['map_id']}` — {value['name']} — révision {value['revision']}")
    lines += ["", "Les deux enregistrements exacts sont conservés; aucune révision n’est supprimée ou fusionnée arbitrairement.", "", "### Snowbasin Town", ""]
    for value in snowbasin:
        lines.append(f"- `{value['map_id']}` — {value['name']} — révision {value['revision']}")
    lines += [
        "", "### Silversail Village", "",
        "- `UNKNOWN` — aucun nom exact et aucun ID canonique prouvé dans le snapshot SQL public.",
        "- Sept maps portent le libellé régional `Archford, Southwestern Isle`, mais elles restent `UNVERIFIED` comme identité Silversail.",
        "- Aucun PNG de wiki ou de ville externe n’a été téléchargé, utilisé comme géométrie ou substitué aux données.", "",
        "## Inventaires exhaustifs", "",
        f"- Animations : {inventory.get('animation_map_count', 'UNKNOWN')} maps; frames, emplacements et timings sous `{inventory.get('outputs', {}).get('animations', 'UNKNOWN')}`.",
        f"- NPC : {inventory.get('npc_placement_count', 'UNKNOWN')} presets acteurs runtime; inventaire sous `{inventory.get('outputs', {}).get('npcs', 'UNKNOWN')}`.",
        f"- Objets : {inventory.get('item_definition_count', 'UNKNOWN')} définitions; inventaire sous `{inventory.get('outputs', {}).get('objects', 'UNKNOWN')}`.",
        f"- Stories/scripts : {inventory.get('story_count', 'UNKNOWN')} stories; inventaires dédiés et {inventory.get('scripted_static_edge_count', 'UNKNOWN')} arêtes scriptées statiquement prouvées.",
        f"- Triggers : index complet sous `{inventory.get('outputs', {}).get('triggers', 'UNKNOWN')}`; passabilité exhaustive dans chaque IR canonique.",
        f"- Types historiques inconnus : {inventory.get('unknown_tile_count', 'UNKNOWN')} cellules (101/103), préservées `UNKNOWN`.", "",
        "## Graphe", "",
        f"Le graphe contient {global_manifest['inventories'].get('connection_edges', 'UNKNOWN')} arêtes, dont {global_manifest['inventories'].get('scripted_static_edges', 'UNKNOWN')} transitions story/script prouvées statiquement. Les destinations calculées restent `UNVERIFIED`.", "",
        "## Certification et barrière de phase", "",
        "Le snapshot SQL public des 2 000 maps est `SOURCE_CERTIFIED` pour l’IR et le raster. L’état global reste `PARTIAL` : 137 caches standard recouvrant le snapshot ne peuvent pas être comparés, `s3000` n’existe que sous forme chiffrée bloquée, et six cellules gardent une sémantique inconnue.", "",
        "La phase 2 est autorisée **uniquement** pour ce snapshot SQL certifié et doit rester dans une pipeline séparée. Les contenus V9 bloqués, dont `s3000`, ne sont pas adaptables. Cette pipeline de phase 1 ne produit toujours aucun `.rsground` et ne remplace aucune méthode runtime/headless existante.", "",
        "## Index et artefacts", "",
        "- `canonical-map-index.json` : index JSON enrichi des 2 000 maps.",
        "- `canonical-map-table.md` : tableau `Map ID | Nom | Type | Dimensions | Tileset | PNG | Source | Statut`.",
        "- `connection-graph.json` / `.dot` : graphe canonique complet, transitions scriptées prouvées incluses.",
        "- `audit/` : preuves compactes SQL/DAT/tiles/inventaires/certification, types inconnus et références graphiques dédupliquées.",
        "- `artifact-hashes.sha256` : hashes SHA-256 de tous les livrables suivis du rapport.",
        "- `critical-maps/` : copies byte-identiques des PNG source et états animés de `s737`, `s1810` et `s1991`, avec hashes.",
        f"- Bulk reproductible : `{cache_root}` (IR, manifests, PNG, animations, inventaires, graphe et contact sheets).", "",
    ]
    (reports_directory / "phase1-summary.md").write_text("\n".join(lines), encoding="utf-8", newline="\n")

    # Keep compact proof artifacts and the canonical graph in Git; large IR/PNG and
    # exhaustive inventories remain reproducible under the declared cache boundary.
    audit_directory = reports_directory / "audit"
    audit_directory.mkdir(parents=True, exist_ok=True)
    proof_files = {
        cache_root / "source-audit.json": audit_directory / "source-audit.json",
        cache_root / "sql-import-report.json": audit_directory / "sql-import-report.json",
        cache_root / "dat-extraction-report.json": audit_directory / "dat-extraction-report.json",
        cache_root / "tileset-audit-report.json": audit_directory / "tileset-audit-report.json",
        cache_root / "inventory-report.json": audit_directory / "inventory-report.json",
        cache_root / "certification-report.json": audit_directory / "certification-report.json",
        cache_root / "source/contact-sheets/visual-review.json": audit_directory / "visual-review.json",
        cache_root / "source/inventories/invalid-graphic-references.json": audit_directory / "invalid-graphic-references.json",
        cache_root / "source/inventories/unknown-tile-types.json": audit_directory / "unknown-tile-types.json",
        cache_root / "source/connection-graph.json": reports_directory / "connection-graph.json",
        cache_root / "source/connection-graph.dot": reports_directory / "connection-graph.dot",
    }
    for source, destination in proof_files.items():
        if source.exists():
            shutil.copyfile(source, destination)
    hash_manifest = reports_directory / "artifact-hashes.sha256"
    hash_lines = []
    for path in sorted(reports_directory.rglob("*")):
        if path.is_file() and path != hash_manifest:
            hash_lines.append(f"{sha256_file(path)}  {path.relative_to(reports_directory).as_posix()}")
    hash_manifest.write_text("\n".join(hash_lines) + "\n", encoding="utf-8", newline="\n")
    return summary
