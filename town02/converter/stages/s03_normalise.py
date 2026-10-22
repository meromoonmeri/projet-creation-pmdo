"""Stage 3 — normalise: bind scenes to grounds via the conversion table.

Reads:
  * converter/rom_output/s02_decode_ground/_summary.json   (grounds)
  * converter/rom_output/s02_decode/_summary.json          (scenes)

Runs the auto-resolver from converter.pmdred.conversion_table on the
ROM to locate ground_map_conversion_table, then extracts canonical
ground ids from its debug names, and produces:

  converter/rom_output/s03_normalise/bindings.json
    * per-ground: index -> canonical id (dXXpYY) when the debug name
      matches the ground_data_<id>_station convention, else None
    * summary counts of resolved vs unresolved bindings

  converter/rom_output/s03_normalise/scene_ground_map.json
    * per-scene: index -> canonical ground id chosen for the scene
      (currently based on containment heuristic: the ground whose
      script region encloses the scene's rom_offset)

This stage never touches Data/. All artefacts land under rom_output/.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Optional

from converter.pmdred.conversion_table import resolve as resolve_conversion
from converter.pmdred.scene_binding import (
    bindings_by_map_id,
    build_bindings,
)
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s03_normalise"


def _read_json(path: Path) -> Any:
    if not path.exists():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None


def _canonical_id_for_scene(
    scene_offset: int,
    ground_index_to_offset: dict[int, int],
    ground_index_to_canonical: dict[int, Optional[str]],
) -> Optional[str]:
    """Pick the ground whose entry offset is the largest one <= the
    scene's rom_offset. This is a purely structural heuristic that
    works whenever ground and scene data live in adjacent regions
    (typical for PMD Red's ground archive)."""
    best_idx: Optional[int] = None
    for idx, off in ground_index_to_offset.items():
        if off <= scene_offset and (
            best_idx is None or off > ground_index_to_offset[best_idx]
        ):
            best_idx = idx
    if best_idx is None:
        return None
    return ground_index_to_canonical.get(best_idx)


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.reason = (
            "No authenticated ROM. s03 needs the ROM to auto-resolve the "
            "ground_map_conversion_table."
        )
        return result

    grounds_sum = _read_json(
        ctx.rom_output_dir / "s02_decode_ground" / "_summary.json"
    )
    scenes_sum = _read_json(
        ctx.rom_output_dir / "s02_decode" / "_summary.json"
    )
    if grounds_sum is None and scenes_sum is None:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            "Neither s02_decode nor s02_decode_ground produced a summary; "
            "nothing to normalise."
        )
        return result

    with RomFile.open(ctx.rom_path) as rom:
        if rom.sha256() != ctx.rom_actual_hash:
            result.status = StageStatus.FAIL
            result.reason = "ROM hash changed between s02 and s03"
            return result
        table = resolve_conversion(rom, min_entries=20)

    if table.status != "RESOLVED":
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            "ground_map_conversion_table not auto-resolved by "
            "converter.pmdred.conversion_table: "
            f"{table.reason}"
        )
        # Still persist an empty bindings file so downstream tools
        # can rely on the path existing.
        ctx.write_json(out / "bindings.json", {
            "status": table.status,
            "reason": table.reason,
            "bindings": [],
        })
        return result

    bindings = build_bindings(table)
    by_map_id = bindings_by_map_id(bindings)

    # Per-index: canonical id (dXXpYY) when parsable, else None.
    # Priority 1: the stable ground id already derived by
    # s02_decode_ground from the EU archive's BPL resource name
    # (row["ground_id"], e.g. "d01p02"). Priority 2: the US-style
    # debug-name convention from the conversion table.
    ground_index_to_canonical: dict[int, Optional[str]] = {}
    ground_index_to_offset: dict[int, int] = {}
    canonical_resolved = 0
    for row in (grounds_sum or {}).get("per_ground", []):
        if row.get("status") != "DECODED":
            continue
        idx = int(row["index"])
        canon: Optional[str] = None
        gid = row.get("ground_id")
        if gid and not gid.startswith("ground_"):
            canon = gid
        if canon is None:
            b = by_map_id.get(idx)
            if b is not None:
                canon = b.canonical_ground_id
        ground_index_to_canonical[idx] = canon
        if canon is not None:
            canonical_resolved += 1
        try:
            ground_index_to_offset[idx] = int(row["rom_offset"], 16)
        except (KeyError, ValueError):
            pass

    ctx.write_json(out / "bindings.json", {
        "conversion_table_offset": f"{table.table_offset:#010x}"
            if table.table_offset else None,
        "conversion_table_entries": table.entry_count,
        "grounds_bound":            len(ground_index_to_canonical),
        "canonical_ids_resolved":   canonical_resolved,
        "per_index": [
            {
                "index":         idx,
                "map_file_id":   idx,
                "canonical_id":  ground_index_to_canonical.get(idx),
                "debug_text":    (by_map_id.get(idx).debug_text
                                  if by_map_id.get(idx) else None),
            }
            for idx in sorted(ground_index_to_canonical)
        ][:500],
    })
    result.artefacts.append(str(out / "bindings.json"))

    # Attach a canonical ground id to every decoded scene using the
    # offset-containment heuristic.
    per_scene_binding: list[dict[str, Any]] = []
    scene_resolved = 0
    for row in (scenes_sum or {}).get("per_scene", []):
        if row.get("status") != "DECODED":
            continue
        try:
            scene_off = int(row["rom_offset"], 16)
        except (KeyError, ValueError):
            continue
        canon = _canonical_id_for_scene(
            scene_off, ground_index_to_offset, ground_index_to_canonical,
        )
        if canon is not None:
            scene_resolved += 1
        per_scene_binding.append({
            "scene_index":    row["index"],
            "scene_offset":   row["rom_offset"],
            "ground_canonical_id": canon,
        })

    ctx.write_json(out / "scene_ground_map.json", {
        "scenes_bound_total":    len(per_scene_binding),
        "scenes_with_canonical": scene_resolved,
        "per_scene":             per_scene_binding[:500],
    })
    result.artefacts.append(str(out / "scene_ground_map.json"))

    result.metrics.update({
        "conversion_table_entries":  table.entry_count,
        "grounds_bound":             len(ground_index_to_canonical),
        "canonical_ids_resolved":    canonical_resolved,
        "scenes_bound_total":        len(per_scene_binding),
        "scenes_with_canonical":     scene_resolved,
    })
    result.status = StageStatus.PASS
    result.reason = (
        f"Auto-resolved ground_map_conversion_table ({table.entry_count} "
        f"records); {canonical_resolved} canonical ground ids extracted "
        f"from debug names; {scene_resolved}/{len(per_scene_binding)} "
        f"decoded scenes bound to a canonical ground."
    )
    return result
