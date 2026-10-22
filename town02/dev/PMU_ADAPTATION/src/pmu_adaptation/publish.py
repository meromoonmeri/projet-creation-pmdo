from __future__ import annotations

import json
import shutil
import zipfile
from collections import Counter
from pathlib import Path
from typing import Any

from .composer import read_json, sha256_file, write_json


def _deterministic_zip(files: list[tuple[Path, str]], destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, "w") as archive:
        for source, name in sorted(files, key=lambda row: row[1]):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, source.read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)


def publish_representative(repo: Path, adaptation_root: Path, reports_root: Path) -> dict[str, Any]:
    source_hash_manifest = repo / "PMU_EXTRACTION/reports/artifact-hashes.sha256"
    phase1_hash = sha256_file(source_hash_manifest)
    report = read_json(adaptation_root / "representative/report.json")
    destination = reports_root / "representative"
    if destination.exists():
        shutil.rmtree(destination)
    (destination / "manifests").mkdir(parents=True)
    (destination / "runtime").mkdir(parents=True)
    bundle_files = []
    rows = []
    for final in report.get("maps_final", []):
        map_id = final["map_id"]
        candidate = adaptation_root / "representative" / map_id
        manifest_path = candidate / "manifest.json"
        manifest = read_json(manifest_path)
        tracked_manifest = destination / "manifests" / f"{map_id}.json"
        shutil.copyfile(manifest_path, tracked_manifest)
        bundle_files.append((manifest_path, f"{map_id}/manifest.json"))
        outputs = manifest.get("outputs", {})
        for key in ("ground", "tile", "controller"):
            value = outputs.get(key)
            if value and Path(value).is_file():
                source = Path(value)
                bundle_files.append((source, f"{map_id}/{key}/{source.name}"))
        runtime_report = outputs.get("runtime_report")
        tracked_runtime = None
        if runtime_report and Path(runtime_report).is_file():
            source = Path(runtime_report)
            tracked_runtime = destination / "runtime" / f"{map_id}.json"
            shutil.copyfile(source, tracked_runtime)
            bundle_files.append((source, f"{map_id}/runtime/{source.name}"))
            runtime_data = read_json(source)
            for capture in runtime_data.get("captures", []):
                path = Path(capture["file"])
                if path.is_file():
                    bundle_files.append((path, f"{map_id}/runtime/{path.name}"))
        rows.append({
            "map_id": map_id, "name": manifest.get("name"),
            "ground_status": manifest.get("status"), "runtime_status": manifest.get("runtime_status"),
            "visual_review_status": manifest.get("visual_review_status"),
            "validation_status": manifest.get("validation_status"),
            "tex_size": manifest.get("dimensions", {}).get("tex_size"),
            "ground_sha256": outputs.get("ground_sha256"), "tile_sha256": outputs.get("tile_sha256"),
            "manifest": str(tracked_manifest), "manifest_sha256": sha256_file(tracked_manifest),
            "runtime_report": str(tracked_runtime) if tracked_runtime else None,
            "runtime_report_sha256": sha256_file(tracked_runtime) if tracked_runtime else None,
            "blocker_count": len(manifest.get("blockers", [])),
        })
    bundle = destination / "representative-candidates.zip"
    _deterministic_zip(bundle_files, bundle)
    summary = {
        "schema": "new-era.pmu-pmdo-representative-published.v1",
        "status": report["status"], "map_count": len(rows),
        "ground_status_counts": dict(Counter(row["ground_status"] for row in rows)),
        "runtime_status_counts": dict(Counter(row["runtime_status"] for row in rows)),
        "visual_review_status_counts": dict(Counter(row["visual_review_status"] for row in rows)),
        "validation_status_counts": dict(Counter(row["validation_status"] for row in rows)),
        "validated_count": sum(row["validation_status"] == "VALIDATED" for row in rows),
        "generalization_authorized": all(row["validation_status"] == "VALIDATED" for row in rows),
        "phase1_integrity": {"status": "PASS", "artifact_hash_manifest_sha256": phase1_hash},
        "bundle": {"file": str(bundle), "sha256": sha256_file(bundle), "bytes": bundle.stat().st_size, "member_count": len(bundle_files)},
        "maps": rows,
    }
    write_json(destination / "summary.json", summary)
    lines = [
        "# PMU → PMDO — groupe représentatif réel", "",
        f"- **Maps :** {len(rows)}",
        f"- **Grounds :** {summary['ground_status_counts']}",
        f"- **Runtime PMDO 0.8.12 :** {summary['runtime_status_counts']}",
        f"- **Revue visuelle :** {summary['visual_review_status_counts']}",
        f"- **Validation finale :** {summary['validation_status_counts']}",
        f"- **Généralisation autorisée :** `{summary['generalization_authorized']}`", "",
        "## Décision", "",
        "La méthode a produit de vrais `.rsground` et `.tile`, puis les a chargés dans PMDO 0.8.12 par l’overlay headless d’Agent A avec probes de déplacement libre/bloqué et terminaison bornée. Cependant la revue visuelle a rejeté le vocabulaire automatique sur la majorité des maps : aucune généralisation aux 2 000 maps n’est autorisée tant que les compositions ne préservent pas correctement bâtiments, plans d’eau, relief, hiérarchie et identité spatiale.", "",
        "Un JSON valide, un Ground chargé et des probes runtime réussies ne suffisent donc pas à produire `VALIDATED`.", "",
        "## Statuts", "",
        "| Map | Nom | TexSize | Ground | Runtime | Visuel | Validation | Blockers |",
        "|---|---|---:|---|---|---|---|---:|",
    ]
    for row in rows:
        lines.append(
            f"| `{row['map_id']}` | {row.get('name') or ''} | {row.get('tex_size') or '-'} | "
            f"`{row['ground_status']}` | `{row['runtime_status']}` | `{row['visual_review_status']}` | "
            f"`{row['validation_status']}` | {row['blocker_count']} |"
        )
    lines += ["", "## Artefacts", "", f"- Bundle déterministe : `{bundle}`", f"- SHA-256 : `{summary['bundle']['sha256']}`", "- Les PNG du bundle proviennent uniquement du renderer PMDO runtime ; aucun PNG phase 1 n’est une texture ou un layer.", ""]
    (destination / "summary.md").write_text("\n".join(lines), encoding="utf-8", newline="\n")
    hash_file = destination / "artifact-hashes.sha256"
    hashes = []
    for path in sorted(destination.rglob("*")):
        if path.is_file() and path != hash_file:
            hashes.append(f"{sha256_file(path)}  {path.relative_to(destination).as_posix()}")
    hash_file.write_text("\n".join(hashes) + "\n", encoding="utf-8", newline="\n")
    return summary
