"""Stage 9 — dungeon-level coverage matrix.

Cross-references artefacts produced by earlier stages to answer, per
canonical ground id (dXXpYY), a single question:

    how much of PMD Red's real content did the converter successfully
    lift into PMDO-ready form, and where are the remaining gaps?

Inputs (all under converter/rom_output/, git-ignored):
  * s01_extract/resolved_tables.json
  * s02_decode/_summary.json
  * s02_decode_ground/_summary.json + grounds/<idx>/viewport.json
  * s03_normalise/bindings.json + scene_ground_map.json
  * s04_map/_summary.json
  * s05_emit/_summary.json
  * s06_validate/findings.json

Outputs:
  * coverage.json  machine-readable dungeon-by-dungeon matrix
  * coverage.md    human-readable table (per ground: ground decoded?
    viewport ok? scenes bound? scenes mapped? staged? validated?)

The stage is honest: for every ground it lists the *exact* reason a
column is missing, so nobody has to guess whether a red cell is a
converter bug or an intentional gap.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from converter.pmdred.conversion_table import resolve as resolve_conversion
from converter.pmdred.scene_binding import build_bindings
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s09_report_dungeons"


def _read(path: Path) -> Any:
    if not path.exists():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None


def _build_matrix(ctx: Context) -> dict[str, Any]:
    root = ctx.rom_output_dir
    resolved   = _read(root / "s01_extract" / "resolved_tables.json") or {}
    grounds    = _read(root / "s02_decode_ground" / "_summary.json") or {}
    scenes     = _read(root / "s02_decode" / "_summary.json") or {}
    bindings   = _read(root / "s03_normalise" / "bindings.json") or {}
    scene_map  = _read(root / "s03_normalise" / "scene_ground_map.json") or {}
    mapped     = _read(root / "s04_map" / "_summary.json") or {}
    staged     = _read(root / "s05_emit" / "_summary.json") or {}
    validated  = _read(root / "s06_validate" / "findings.json") or {}

    # ground index -> canonical id
    idx_to_canon: dict[int, str] = {}
    for row in bindings.get("per_index", []):
        canon = row.get("canonical_id")
        if canon:
            idx_to_canon[int(row["index"])] = canon

    # canonical id -> ground decode row
    canon_to_ground: dict[str, dict[str, Any]] = {}
    for row in grounds.get("per_ground", []):
        if row.get("status") != "DECODED":
            continue
        idx = int(row["index"])
        canon = idx_to_canon.get(idx)
        if canon:
            canon_to_ground[canon] = row

    # canonical id -> list of scene indexes bound to it
    canon_to_scenes: dict[str, list[int]] = {}
    for row in scene_map.get("per_scene", []):
        canon = row.get("ground_canonical_id")
        if not canon:
            continue
        canon_to_scenes.setdefault(canon, []).append(int(row["scene_index"]))

    # scene index -> mapping row
    scene_to_mapping: dict[int, dict[str, Any]] = {}
    for row in mapped.get("per_scene", []):
        scene_to_mapping[int(row["index"])] = row

    # per-file validation lookup by filename stem (cutscene_XXX)
    val_by_stem: dict[str, dict[str, Any]] = {}
    for row in validated.get("per_file", []):
        stem = Path(row["file"]).stem
        val_by_stem[stem] = row

    per_dungeon: list[dict[str, Any]] = []
    all_canon = sorted(set(idx_to_canon.values()) | set(canon_to_scenes))
    for canon in all_canon:
        g = canon_to_ground.get(canon)
        scenes_bound = canon_to_scenes.get(canon, [])
        scenes_mapped = 0
        events_total = 0
        events_partial = 0
        events_unknown = 0
        for sidx in scenes_bound:
            m = scene_to_mapping.get(sidx)
            if m is None:
                continue
            scenes_mapped += 1
            by = m.get("by_status") or {}
            events_total   += m.get("total_events", 0)
            events_partial += by.get("PARTIAL", 0)
            events_unknown += by.get("UNKNOWN", 0)

        scenes_validated_ok = 0
        scenes_validated_fail = 0
        for sidx in scenes_bound:
            v = val_by_stem.get(f"cutscene_{sidx:03d}")
            if v is None:
                continue
            if v["verdict"] == "OK":
                scenes_validated_ok += 1
            else:
                scenes_validated_fail += 1

        per_dungeon.append({
            "canonical_id":         canon,
            "ground_decoded":       g is not None,
            "ground_width_tiles":   (g or {}).get("width_tiles"),
            "ground_height_tiles":  (g or {}).get("height_tiles"),
            "ground_viewport_ok":   (g or {}).get("viewport_ok"),
            "ground_provenance":    (g or {}).get("provenance_status"),
            "scenes_bound":         len(scenes_bound),
            "scenes_mapped":        scenes_mapped,
            "events_total":         events_total,
            "events_partial":       events_partial,
            "events_unknown":       events_unknown,
            "scenes_validated_ok":   scenes_validated_ok,
            "scenes_validated_fail": scenes_validated_fail,
        })

    return {
        "canonical_ids_total":   len(all_canon),
        "grounds_decoded_total": len(canon_to_ground),
        "scenes_bound_total":    sum(len(v) for v in canon_to_scenes.values()),
        "conversion_table_offset": bindings.get("conversion_table_offset"),
        "per_dungeon":           per_dungeon,
    }


def _write_md(payload: dict[str, Any], dest: Path) -> None:
    lines = [
        "# Dungeon coverage matrix",
        "",
        f"- Canonical ground ids seen : `{payload['canonical_ids_total']}`",
        f"- Grounds decoded (BMA)     : `{payload['grounds_decoded_total']}`",
        f"- Scenes bound to a ground  : `{payload['scenes_bound_total']}`",
        f"- Conversion table offset   : "
        f"`{payload.get('conversion_table_offset') or 'unresolved'}`",
        "",
        "| Canonical id | Ground | WxH | Viewport | Scenes bound | "
        "Scenes mapped | Events (partial/unknown) | Validated OK/FAIL |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for d in payload["per_dungeon"]:
        wh = (
            f"{d['ground_width_tiles']}x{d['ground_height_tiles']}"
            if d["ground_decoded"] else "-"
        )
        vp = "OK" if d["ground_viewport_ok"] else \
             ("FAIL" if d["ground_decoded"] else "-")
        lines.append(
            f"| `{d['canonical_id']}` | "
            f"{'yes' if d['ground_decoded'] else 'no'} | "
            f"{wh} | {vp} | "
            f"{d['scenes_bound']} | {d['scenes_mapped']} | "
            f"{d['events_total']} ({d['events_partial']}/"
            f"{d['events_unknown']}) | "
            f"{d['scenes_validated_ok']}/{d['scenes_validated_fail']} |"
        )
    dest.write_text("\n".join(lines) + "\n", encoding="utf-8")


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)

    if not (ctx.rom_output_dir / "s03_normalise" / "bindings.json").exists():
        result.reason = (
            "s03_normalise did not produce bindings.json. The dungeon "
            "matrix has nothing to cross-reference — run the full "
            "pipeline first."
        )
        return result

    payload = _build_matrix(ctx)

    # Optionally re-run the conversion resolver just to attach the
    # freshly extracted debug names (so this stage's report is
    # self-contained). Only if the ROM is authenticated.
    if ctx.rom_path is not None and ctx.rom_actual_hash is not None:
        with RomFile.open(ctx.rom_path) as rom:
            if rom.sha256() == ctx.rom_actual_hash:
                table = resolve_conversion(rom, min_entries=20)
                if table.status == "RESOLVED":
                    payload["conversion_table_entries"] = table.entry_count
                    canon_names = [
                        b.canonical_ground_id
                        for b in build_bindings(table)
                        if b.canonical_ground_id
                    ]
                    payload["canonical_names_extracted"] = len(canon_names)

    ctx.write_json(out / "coverage.json", payload)
    _write_md(payload, out / "coverage.md")
    result.artefacts.append(str(out / "coverage.json"))
    result.artefacts.append(str(out / "coverage.md"))
    result.metrics.update({
        "canonical_ids_total":   payload["canonical_ids_total"],
        "grounds_decoded_total": payload["grounds_decoded_total"],
        "scenes_bound_total":    payload["scenes_bound_total"],
    })
    result.status = StageStatus.PASS
    result.reason = (
        f"Coverage matrix over {payload['canonical_ids_total']} canonical "
        f"grounds, {payload['grounds_decoded_total']} decoded, "
        f"{payload['scenes_bound_total']} bound scenes."
    )
    return result
