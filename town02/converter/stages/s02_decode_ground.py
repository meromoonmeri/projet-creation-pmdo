"""Stage 2 (ground) — decode BMA blobs into Ground_IR objects.

Reads the resolved `ground_map_table` from s01 (when available) and,
for each entry, runs the BMA decoder on the entry offset. Persists one
Ground_IR sidecar per ground under
converter/rom_output/02_decode/grounds/<idx>/ with:

  header.json      — decoded BMA header fields
  ground_ir.json   — a compact IR summary (dimensions, layer counts,
                     collision counts, first-N chunk indices per layer)
  report.json      — decode statistics + provenance
  viewport.json    — PMDO viewport invariants (dimensions vs 320x240
                     viewport, camera bounds, findings)

BMA does not carry ground_id names, so we index by table position. A
later pass will cross-reference with the ROM's gGroundMapConversionTable
(when the pret loader can find it) to attach canonical names.

Unlike full BPC/BPA (still pending), the BMA layer alone is enough to
know the ground's dimensions, layout, collision, and to feed the
viewport validator — which was the missing piece for the `Ground_IR`
half of the pipeline.
"""
from __future__ import annotations

import json
from dataclasses import asdict
from pathlib import Path
from typing import Any

from converter.decoders.bma import decode as decode_bma
from converter.ir.ground import BMA_IR, Ground_IR
from converter.ir.provenance import Provenance, Status
from converter.pmdo.viewport import check_ground_viewport
from converter.pmdred.eu_archive import find_archive, find_map_files_table
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s02_decode_ground"
MAX_BMA_BYTES = 128 * 1024      # generous bound; header determines real length


def _read_resolved_tables(ctx: Context) -> list[dict[str, Any]]:
    src = ctx.rom_output_dir / "s01_extract" / "resolved_tables.json"
    if not src.exists():
        return []
    try:
        return list(json.loads(src.read_text(encoding="utf-8"))
                    .get("results") or [])
    except Exception:
        return []


def _ground_ir_summary(g: Ground_IR) -> dict[str, Any]:
    return {
        "id":            g.id,
        "rom_map_file_id": g.rom_map_file_id,
        "width_tiles":   g.width_tiles,
        "height_tiles":  g.height_tiles,
        "pixel_width":   g.pixel_width,
        "pixel_height":  g.pixel_height,
        "tileset_id":    g.tileset_id,
        "bma_layers":    len(g.bma.layers),
        "bma_collisions": len(g.bma.collisions),
        "bma_animated":  len(g.bma.animated),
        "bma_provenance_status": (
            g.bma.provenance.status.value if g.bma.provenance else "UNKNOWN"
        ),
        "bma_layer_chunk_previews": [
            layer.chunk_indices[:16] for layer in g.bma.layers
        ],
        "bma_collision_solid_cells": [
            c.solid_cells for c in g.bma.collisions
        ],
        "provenance_status": (
            g.provenance.status.value if g.provenance else "UNKNOWN"
        ),
        "provenance_reason": (
            g.provenance.status_reason if g.provenance else ""
        ),
    }


def _viewport_report(g: Ground_IR) -> dict[str, Any]:
    v = check_ground_viewport(g)
    return {
        "ok": v.ok,
        "ground_px_w": v.ground_px_w,
        "ground_px_h": v.ground_px_h,
        "tile_px": v.tile_px,
        "camera_bounds_px": list(v.camera_bounds_px),
        "findings": v.findings,
        "summary": v.summary(),
    }


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    (out / "grounds").mkdir(parents=True, exist_ok=True)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.reason = (
            "No authenticated ROM (s00_detect did not PASS). "
            "Nothing to decode."
        )
        return result

    grounds_decoded = 0
    grounds_failed = 0
    grounds_bogus_header = 0
    total_tile_layers = 0
    total_collision_layers = 0
    viewport_ok = 0
    viewport_fail = 0
    per_ground_reports: list[dict[str, Any]] = []

    with RomFile.open(ctx.rom_path) as rom:
        if rom.sha256() != ctx.rom_actual_hash:
            result.status = StageStatus.FAIL
            result.reason = "ROM hash changed between s01 and s02"
            return result

        # The European ROM stores all Ground resources in a pksdir0
        # archive; the 262-row map-files table names each ground's
        # BPL/BPC/BMA/BPA dependencies. Both are located structurally
        # (magic signature + pointer/string fingerprints), never by a
        # hand-fed offset.
        archive = find_archive(rom)
        if archive is None:
            result.status = StageStatus.UNIMPLEMENTED
            result.reason = (
                "No pksdir0 Ground archive found in the ROM. This decoder "
                "supports the European PMD Red layout; the authenticated "
                "ROM should contain the archive. Aborting honestly."
            )
            return result

        mft = find_map_files_table(rom, archive)
        if mft is None:
            result.status = StageStatus.UNIMPLEMENTED
            result.reason = (
                "pksdir0 archive found but the 7-pointer map-files "
                "dependency table could not be located structurally."
            )
            return result

        by_name = archive.by_name()
        result.metrics["archive_offset"] = f"{archive.base_offset:#x}"
        result.metrics["archive_resources"] = archive.count
        result.metrics["map_files_rows"] = len(mft.rows)
        entry_count = len(mft.rows)

        for i, row in enumerate(mft.rows):
            gid = row.stable_ground_id or f"ground_{i:03d}"
            res = by_name.get(row.bma or "")
            if res is None:
                grounds_failed += 1
                per_ground_reports.append({
                    "index": i, "status": "SKIP", "ground_id": gid,
                    "reason": f"BMA resource {row.bma!r} not in archive",
                })
                continue
            entry_offset = res.data_offset
            bound = res.next_offset or rom.size
            max_read = min(max(bound - entry_offset, 0), MAX_BMA_BYTES)
            if max_read <= 12:
                grounds_failed += 1
                per_ground_reports.append({
                    "index": i, "status": "SKIP", "ground_id": gid,
                    "reason": f"entry too small at {entry_offset:#x}",
                })
                continue

            blob = rom.read(entry_offset, max_read)
            try:
                bma, stats = decode_bma(
                    blob, ground_id=gid,
                    rom_sha256=rom.sha256(), rom_offset=entry_offset,
                )
            except Exception as exc:  # noqa: BLE001
                grounds_failed += 1
                per_ground_reports.append({
                    "index": i, "status": "FAIL", "ground_id": gid,
                    "reason": f"BMA decoder crashed: {exc!r}",
                })
                continue

            # If the header itself was rejected, don't count this as a
            # decoded ground. We keep the record for the report so the
            # user knows which candidate offsets look wrong.
            if bma.provenance and bma.provenance.status == Status.UNKNOWN:
                grounds_bogus_header += 1
                per_ground_reports.append({
                    "index": i, "status": "BOGUS_HEADER", "ground_id": gid,
                    "rom_offset": f"{entry_offset:#x}",
                    "warnings": stats.header_warnings,
                })
                continue

            # Wrap the BMA in a minimal Ground_IR for the viewport
            # check. We fill only the geometry fields; BPC/entities/
            # warps are still pending, but the geometry is enough to
            # run the viewport invariants.
            width_tiles = bma.layers[0].width_chunks * 3 if bma.layers else 0
            height_tiles = bma.layers[0].height_chunks * 3 if bma.layers else 0
            g = Ground_IR(
                id=gid,
                rom_map_file_id=f"MAP_{i:03d}",
                width_tiles=width_tiles,
                height_tiles=height_tiles,
                pixel_width=width_tiles * 24,     # PMDO tile
                pixel_height=height_tiles * 24,
                tileset_id=0,
                bma=bma,
                entities=[],
                warps=[],
                provenance=Provenance(
                    rom_sha256=rom.sha256(),
                    rom_offset=entry_offset,
                    rom_length=stats.bytes_consumed,
                    extractor_version="converter.stages.s02_decode_ground/0.1",
                    status=(
                        Status.PARTIAL
                        if stats.header_warnings else Status.PORTED
                    ),
                    status_reason=(
                        "; ".join(stats.header_warnings)
                        if stats.header_warnings else ""
                    ),
                ),
            )

            g_dir = out / "grounds" / f"{i:03d}"
            g_dir.mkdir(parents=True, exist_ok=True)
            (g_dir / "ground_ir.json").write_text(
                json.dumps(_ground_ir_summary(g), indent=2, sort_keys=True)
                + "\n",
                encoding="utf-8",
            )
            vp = _viewport_report(g)
            (g_dir / "viewport.json").write_text(
                json.dumps(vp, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
            )
            (g_dir / "report.json").write_text(
                json.dumps({
                    "index": i,
                    "rom_offset": f"{entry_offset:#x}",
                    "bytes_consumed": stats.bytes_consumed,
                    "layers_decoded": stats.layers_decoded,
                    "collision_layers_decoded": stats.collision_layers_decoded,
                    "data_layer_present": stats.data_layer_present,
                    "solid_cells_per_layer": stats.solid_cells_per_layer,
                    "header_warnings": stats.header_warnings,
                    "provenance_status": g.provenance.status.value,
                }, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
            )

            grounds_decoded += 1
            total_tile_layers += stats.layers_decoded
            total_collision_layers += stats.collision_layers_decoded
            if vp["ok"]:
                viewport_ok += 1
            else:
                viewport_fail += 1
            per_ground_reports.append({
                "index": i,
                "status": "DECODED",
                "ground_id": gid,
                "bma_resource": row.bma,
                "bpl_resource": row.bpl,
                "bpc_resource": row.bpc,
                "bpa_resources": [b for b in row.bpas if b],
                "rom_offset": f"{entry_offset:#x}",
                "width_tiles": width_tiles,
                "height_tiles": height_tiles,
                "viewport_ok": vp["ok"],
                "provenance_status": g.provenance.status.value,
            })

    ctx.write_json(out / "_summary.json", {
        "grounds_decoded":      grounds_decoded,
        "grounds_failed":       grounds_failed,
        "grounds_bogus_header": grounds_bogus_header,
        "total_tile_layers":    total_tile_layers,
        "total_collision_layers": total_collision_layers,
        "viewport_ok":          viewport_ok,
        "viewport_fail":        viewport_fail,
        "per_ground":           per_ground_reports,
    })
    result.artefacts.append(str(out / "_summary.json"))
    result.metrics.update({
        "grounds_decoded":      grounds_decoded,
        "grounds_failed":       grounds_failed,
        "grounds_bogus_header": grounds_bogus_header,
        "viewport_ok":          viewport_ok,
        "viewport_fail":        viewport_fail,
    })

    if grounds_decoded == 0:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            f"0/{entry_count} ground_map_table entries decoded to a valid "
            f"BMA (bogus_headers={grounds_bogus_header}, "
            f"failures={grounds_failed}). Either the resolver picked "
            f"the wrong table or the entries are not BMA blobs. "
            f"See _summary.json for per-entry diagnostics."
        )
    else:
        result.status = StageStatus.PASS
        result.reason = (
            f"Decoded {grounds_decoded}/{entry_count} grounds; "
            f"{total_tile_layers} tile layers, {total_collision_layers} "
            f"collision layers total. Viewport invariants: {viewport_ok} "
            f"ok, {viewport_fail} fail. BPC/BPA and entity/warp decoding "
            f"still pending (separate work items)."
        )
    return result
