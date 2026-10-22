"""Stage 4 — map IR objects to PMDO staged artefacts.

Reads Cinematic_IR sidecars produced by s02 and, for each one, runs
the cinematic_to_lua mapper. The generated Lua text plus its aggregate
provenance are written to converter/rom_output/04_map/lua/<scene>.lua
(and .provenance.json alongside). Writing under Data/ happens later,
in s05_emit, with additional guards.

s04 does NOT rebuild Cinematic_IR from JSON: to avoid a lossy round-
trip we re-run the SSB decoder on the same ROM offsets that s02 chose,
which is deterministic. This keeps s04 idempotent.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from converter.aux_sources.pret import load_pret_checkout
from converter.decoders.ssb import decode as decode_ssb
from converter.mappers.cinematic_to_lua import map_cinematic
from converter.pmdred.symbolic import SymbolResolver
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s04_map"


def _read_s02_summary(ctx: Context) -> dict[str, Any] | None:
    src = ctx.rom_output_dir / "s02_decode" / "_summary.json"
    if not src.exists():
        return None
    try:
        return json.loads(src.read_text(encoding="utf-8"))
    except Exception:
        return None


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    lua_out = out / "lua"
    lua_out.mkdir(parents=True, exist_ok=True)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.reason = (
            "No authenticated ROM available. s04 needs the ROM to "
            "regenerate Cinematic_IR deterministically from the offsets "
            "s02 recorded."
        )
        return result

    summary = _read_s02_summary(ctx)
    if not summary:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = "No s02 _summary.json to consume."
        return result

    scenes = [s for s in summary.get("per_scene", [])
              if s.get("status") == "DECODED"]
    result.metrics["scenes_available"] = len(scenes)

    if not scenes:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = "s02 did not decode any scene; nothing to map."
        return result

    pret = load_pret_checkout(ctx.pret_checkout) if ctx.pret_checkout else None
    symbols = SymbolResolver(pret=pret)

    # Optionally pick up the scene->ground binding produced by s03 so
    # the generated Lua module carries the real canonical ground id
    # instead of "unknown".
    binding_path = (
        ctx.rom_output_dir / "s03_normalise" / "scene_ground_map.json"
    )
    scene_to_ground: dict[int, str] = {}
    if binding_path.exists():
        try:
            data = json.loads(binding_path.read_text(encoding="utf-8"))
            for row in data.get("per_scene", []):
                canon = row.get("ground_canonical_id")
                if canon:
                    scene_to_ground[int(row["scene_index"])] = canon
        except Exception:
            pass

    mapped_ok = 0
    partial_count = 0
    unknown_count = 0
    per_map: list[dict[str, Any]] = []

    with RomFile.open(ctx.rom_path) as rom:
        if rom.sha256() != ctx.rom_actual_hash:
            result.status = StageStatus.FAIL
            result.reason = "ROM hash changed between s02 and s04"
            return result

        for scene in scenes:
            idx = scene["index"]
            entry_offset = int(scene["rom_offset"], 16)
            max_read = min(4096, rom.size - entry_offset)
            blob = rom.read(entry_offset, max_read)
            gid = scene_to_ground.get(idx, "unknown")
            cine, _stats = decode_ssb(
                blob,
                scene_id=f"cutscene_{idx:03d}",
                ground_id=gid,
                rom_sha256=rom.sha256(),
                rom_offset=entry_offset,
                pret=pret,
            )
            mapping = map_cinematic(
                cine,
                scene_module_name=f"cutscene_{idx:03d}",
                symbols=symbols,
            )

            # Persist Lua + provenance sidecar (both under rom_output/).
            base = lua_out / f"cutscene_{idx:03d}"
            base.with_suffix(".lua").write_text(
                mapping.lua_text, encoding="utf-8", newline="\n",
            )
            base.with_suffix(".lua.provenance.json").write_text(
                json.dumps(mapping.provenance.to_json(),
                           indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
            )

            summary_row = mapping.summary()
            summary_row["index"] = idx
            summary_row["provenance_status"] = mapping.provenance.status.value
            summary_row["provenance_reason"] = mapping.provenance.status_reason
            per_map.append(summary_row)

            mapped_ok += 1
            by = summary_row["by_status"]
            partial_count += by.get("PARTIAL", 0)
            unknown_count += by.get("UNKNOWN", 0)

    ctx.write_json(out / "_summary.json", {
        "scenes_mapped":  mapped_ok,
        "events_partial": partial_count,
        "events_unknown": unknown_count,
        "per_scene":      per_map[:200],
    })
    result.artefacts.append(str(out / "_summary.json"))
    result.metrics.update({
        "scenes_mapped":  mapped_ok,
        "events_partial": partial_count,
        "events_unknown": unknown_count,
    })

    if mapped_ok == 0:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = "No Cinematic_IR could be mapped this run."
    else:
        result.status = StageStatus.PASS
        result.reason = (
            f"Mapped {mapped_ok} cinematics to Lua "
            f"({partial_count} PARTIAL, {unknown_count} UNKNOWN events). "
            f"Ground/Map/Tile mapping still pending (BMA/BPC decoders)."
        )
    return result
