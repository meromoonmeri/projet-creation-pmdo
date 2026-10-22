"""Stage 2 — decode formats extracted by s01 into IR objects.

For the current milestone we wire the SSB decoder against every entry
of the `cutscene_table` role resolved by s01. Each entry becomes one
Cinematic_IR persisted to converter/rom_output/02_decode/cinematics/.

Decode is bounded (max 4 KiB per entry, stops at first zero record)
and honest: unknown opcodes are preserved as UnknownOpcode with raw
bytes + rom_offset, never silently dropped.

BMA/BPC/BPA/Kao decoders are still stubs; s02 reports them as
UNIMPLEMENTED with their own reason and moves on. That is a partial
PASS: the SSB pipeline works, other decoders will follow.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from converter.aux_sources.pret import load_pret_checkout
from converter.decoders.ssb import decode as decode_ssb
from converter.ir.cinematic import UnknownOpcode
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s02_decode"
MAX_BYTES_PER_SCENE = 4096      # bounded; the decoder stops at first zero rec


def _read_resolved_tables(ctx: Context) -> list[dict[str, Any]]:
    """Reads the resolved_tables.json emitted by s01, if present."""
    src = ctx.rom_output_dir / "s01_extract" / "resolved_tables.json"
    if not src.exists():
        return []
    try:
        data = json.loads(src.read_text(encoding="utf-8"))
    except Exception:
        return []
    return list(data.get("results") or [])


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    (out / "cinematics").mkdir(parents=True, exist_ok=True)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.reason = (
            "No authenticated ROM (s00_detect did not PASS). "
            "Nothing to decode."
        )
        return result

    resolved = _read_resolved_tables(ctx)
    result.metrics["s01_resolved_roles"] = len(resolved)

    # Locate the cutscene_table role (single source of SSB entry points).
    cutscene_table = None
    for r in resolved:
        if r.get("role") == "cutscene_table" and r.get("status") == "RESOLVED":
            cutscene_table = r
            break

    pret = load_pret_checkout(ctx.pret_checkout) if ctx.pret_checkout else None
    result.metrics["pret_checkout_present"] = pret is not None

    if cutscene_table is None:
        # Honest partial: nothing to decode via SSB this run.
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            "s01 did not RESOLVE a `cutscene_table` role. Without a "
            "table of scene entry points, s02 has no SSB blobs to "
            "decode. Provide/update the pret checkout so the CutsceneID "
            "enum is available, or extend converter/pmdred/specs.py "
            "with a more permissive spec."
        )
        return result

    # We need the full entry list; s01's JSON preview only kept 8.
    # Re-open the ROM and re-derive entries deterministically from the
    # table offset+count we know.
    table_off = int(cutscene_table["offset"], 16)
    entry_count = int(cutscene_table["count"])
    scenes_decoded = 0
    scenes_failed = 0
    total_records = 0
    total_translated = 0
    total_unknown = 0
    per_scene_reports: list[dict[str, Any]] = []

    with RomFile.open(ctx.rom_path) as rom:
        if rom.sha256() != ctx.rom_actual_hash:
            result.status = StageStatus.FAIL
            result.reason = "ROM hash changed between s01 and s02"
            return result

        for i in range(entry_count):
            try:
                entry_offset = rom.pointer_to_offset(
                    rom.read_u32(table_off + i * 4)
                )
            except Exception as exc:  # noqa: BLE001
                scenes_failed += 1
                per_scene_reports.append({
                    "index": i,
                    "status": "SKIP",
                    "reason": f"pointer resolution failed: {exc!r}",
                })
                continue

            max_read = min(MAX_BYTES_PER_SCENE, rom.size - entry_offset)
            if max_read <= 16:
                scenes_failed += 1
                per_scene_reports.append({
                    "index": i,
                    "status": "SKIP",
                    "reason": f"entry too small ({max_read} bytes) at "
                              f"{entry_offset:#x}",
                })
                continue

            blob = rom.read(entry_offset, max_read)
            try:
                cine, stats = decode_ssb(
                    blob,
                    scene_id=f"cutscene_{i:03d}",
                    ground_id="unknown",
                    rom_sha256=rom.sha256(),
                    rom_offset=entry_offset,
                    pret=pret,
                )
            except Exception as exc:  # noqa: BLE001
                scenes_failed += 1
                per_scene_reports.append({
                    "index": i,
                    "status": "FAIL",
                    "reason": f"decoder raised: {exc!r}",
                })
                continue

            # Persist a compact per-scene report + a serialised IR
            # sidecar. Both live under rom_output/ (git-ignored).
            scene_dir = out / "cinematics" / f"{i:03d}"
            scene_dir.mkdir(parents=True, exist_ok=True)
            report = {
                "index": i,
                "rom_offset": f"{entry_offset:#x}",
                "records_total":      stats.records_total,
                "records_translated": stats.records_translated,
                "records_unknown":    stats.records_unknown,
                "unknown_opcode_ids": stats.unknown_opcode_ids,
                "unknown_opcode_names": stats.unknown_opcode_names,
                "provenance_status":  cine.provenance.status.value
                    if cine.provenance else "UNKNOWN",
                "provenance_reason":  cine.provenance.status_reason
                    if cine.provenance else "",
                "unknown_events_in_timeline": sum(
                    1 for e in cine.timeline if isinstance(e, UnknownOpcode)
                ),
            }
            (scene_dir / "report.json").write_text(
                json.dumps(report, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
            )

            scenes_decoded += 1
            total_records += stats.records_total
            total_translated += stats.records_translated
            total_unknown += stats.records_unknown
            per_scene_reports.append({**report, "status": "DECODED"})

    ctx.write_json(out / "_summary.json", {
        "scenes_decoded":   scenes_decoded,
        "scenes_failed":    scenes_failed,
        "records_total":    total_records,
        "records_translated": total_translated,
        "records_unknown":  total_unknown,
        "translation_ratio": (
            round(total_translated / total_records, 3) if total_records else 0.0
        ),
        "per_scene":        per_scene_reports[:200],   # cap for readability
    })
    result.artefacts.append(str(out / "_summary.json"))

    result.metrics.update({
        "scenes_decoded":     scenes_decoded,
        "scenes_failed":      scenes_failed,
        "records_total":      total_records,
        "records_translated": total_translated,
        "records_unknown":    total_unknown,
    })

    if scenes_decoded == 0:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            f"0/{entry_count} cutscene entries decoded successfully. "
            f"Failures: {scenes_failed}. See _summary.json for per-entry "
            f"reasons."
        )
    else:
        result.status = StageStatus.PASS
        ratio = (
            round(total_translated / total_records * 100, 1)
            if total_records else 0.0
        )
        result.reason = (
            f"Decoded {scenes_decoded}/{entry_count} cutscene entries; "
            f"{total_translated}/{total_records} opcodes translated "
            f"({ratio}%), {total_unknown} preserved as UnknownOpcode. "
            f"BMA/BPC/BPA/Kao decoders remain UNIMPLEMENTED (separate "
            f"work items)."
        )
    return result
