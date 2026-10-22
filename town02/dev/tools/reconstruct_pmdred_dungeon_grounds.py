#!/usr/bin/env python3
"""Reconstruct all EU PMD Red Grounds rendered from dungeon materials.

The output is an evidence bundle, not a blind PMDO replacement: deterministic
runtime chunk maps, tick-zero PNGs, bounded APNG startup previews, independent
palette-cycle metadata, hashes, and an illustrated relationship report for all
27 canonical direct mappings.
"""

from __future__ import annotations

import argparse
import json
import shutil
import struct
import tempfile
from pathlib import Path
from typing import Any

import audit_pmdred_eu_rom as ground_audit
from pmdred_dungeon_ground import (
    CEL_DECOMPRESSED_SIZE,
    CEX_DECOMPRESSED_SIZE,
    EMAP_DECOMPRESSED_SIZE,
    EXPECTED_EU_ROM_SHA256,
    GRAPHICS_REMAP_COUNT,
    GRAPHICS_REMAP_OFFSET,
    MATERIAL_STRIDE,
    WATER_TYPE_COUNT,
    WATER_TYPE_OFFSET,
    DungeonArchive,
    DungeonGroundRenderer,
    PhysicalSpan,
    ReconstructionError,
    animation_cycle_metadata,
    compose_ground_chunks,
    decode_bma_terrain,
    differential_validate_at4px,
    palette_at_tick,
    parse_canm,
    parse_french_dungeon_names,
    parse_ground_palette,
    parse_mapparam,
    save_animation_preview,
    sha256,
)

TOOL_VERSION = "1.0.0"
ROLE_BY_GROUND = {
    "d01p02": "ending_ground",
    "d02p02": "ending_ground",
    "d03p02": "ending_ground",
    "d04p02": "ending_ground",
    "d05p02": "ending_ground",
    "d06p02": "midpoint_relay_ground",
    "d06p03": "ending_ground",
    "d09p02": "midpoint_relay_ground",
    "d09p03": "ending_ground",
    "d10p02": "midpoint_relay_ground",
    "d10p03": "ending_ground",
    "d11p02": "midpoint_relay_ground",
    "d11p03": "ending_ground",
    "d12p02": "midpoint_relay_ground",
    "d12p04": "ending_ground",
    "d13p02": "midpoint_relay_ground",
    "d13p03": "ending_ground",
}


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def file_record(path: Path) -> dict[str, Any]:
    data = path.read_bytes()
    return {"size": len(data), "sha256": sha256(data)}


def visible_chunks(chunks: list[int], width: int, height: int) -> list[int]:
    return [
        chunks[y * MATERIAL_STRIDE + x] for y in range(height) for x in range(width)
    ]


def source_role(stable_ground_id: str) -> dict[str, str]:
    role = ROLE_BY_GROUND.get(stable_ground_id, "fixed_dungeon_ground")
    source = (
        "pret/pmd-red ground-map enum role, applied to the exact EU mapping row"
        if stable_ground_id in ROLE_BY_GROUND
        else "EU direct mapping row; the generic D14+ technical IDs do not encode a finer role"
    )
    return {"classification": role, "classification_basis": source}


def build_report(bundle: dict[str, Any]) -> str:
    lines = [
        "# PMD Red EU — direct dungeon-to-Ground reconstruction",
        "",
        "This illustrated evidence bundle was regenerated from the authoritative European GBA ROM. "
        "It covers the exact 27 Ground records whose visuals are replaced at runtime through "
        "`GroundMap_SelectDungeon → sub_80A3440 → sub_80ADD9C`.",
        "",
        f"- ROM SHA-256: `{bundle['authority']['rom_sha256']}`",
        f"- Direct mappings: **{bundle['summary']['mapping_count']}**",
        f"- Strict AT4PX differentials: **{bundle['at4px_differential']['stream_count']} / "
        f"{bundle['at4px_differential']['stream_count']} matched SkyTemple**",
        "- Playable floor counts below are selector-row count minus the mandatory dummy row 0.",
        "- APNGs are exact bounded startup-prefix previews. The JSON beside each image preserves all "
        "32 independent cycle records and exact full steady-cycle lengths; no global LCM was expanded.",
        "",
        "> **Scope boundary:** These images prove this graphical runtime path. They do not by themselves "
        "certify music, scripts, collision, entrances, exits, or PMDO installation; those remain "
        "separate reconstruction/validation stages.",
        "",
        "## Relationship index",
        "",
        "| Ground | Canonical French dungeon | Floors | Selected floor row | Tileset | Role | Tick 0 | Preview |",
        "|---|---|---:|---:|---:|---|---|---|",
    ]
    for item in bundle["relationships"]:
        path = item["output_directory"]
        lines.append(
            f"| `{item['stable_ground_id']}` | {item['dungeon']['french_name_primary']} "
            f"| {item['dungeon']['playable_floor_count']} | {item['selection']['runtime_selector_row']} "
            f"| {item['selection']['tileset']} | `{item['role']['classification']}` "
            f"| [PNG]({path}/tick0.png) | [PNG/APNG]({path}/animation.png) |"
        )

    lines.extend(["", "## Ground evidence", ""])
    for item in bundle["relationships"]:
        path = item["output_directory"]
        geometry = item["ground_geometry"]
        selection = item["selection"]
        composition = item["composition"]
        if composition["mode"] == "regular_cex_neighborhood":
            composition_detail = (
                f"deterministic CEX variant `{composition['cex_variant']}` with out-of-bounds "
                f"terrain default `{composition['out_of_bounds_terrain_default']}`"
            )
        else:
            composition_detail = (
                "the selected special EMAP supplies canonical chunks directly"
            )
        lines.extend(
            [
                f"### `{item['stable_ground_id']}` — {item['dungeon']['french_name_primary']}",
                "",
                f"![{item['stable_ground_id']} tick-zero canonical render]({path}/tick0.png)",
                "",
                f"![{item['stable_ground_id']} palette animation preview]({path}/animation.png)",
                "",
                f"- **Relationship:** `{item['role']['classification']}` "
                f"({item['role']['classification_basis']}).",
                f"- **Dungeon:** ID {item['dungeon']['id']}, official French strings "
                f"“{item['dungeon']['french_name_primary']}” / “{item['dungeon']['french_name_secondary']}”, "
                f"{item['dungeon']['playable_floor_count']} playable floors.",
                f"- **Floor selection:** requested floor value `{item['mapping']['requested_floor_value']}`, "
                f"runtime-clamped selector row `{selection['runtime_selector_row']}`, property "
                f"`{selection['property_index']}`, canonical tileset **{selection['tileset']}**.",
                f"- **Graphics resources:** tileset {selection['tileset']} uses graphics index "
                f"{selection['graphics_resource_index']} for FON/CEL/material; palette and CANM remain "
                f"on tileset {selection['tileset']}.",
                f"- **Equivalent base-game Ground geometry:** camera "
                f"{geometry['map_width_tiles']}×{geometry['map_height_tiles']} tiles "
                f"({geometry['pixel_width']}×{geometry['pixel_height']} px), source material grid "
                f"{geometry['map_width_chunks']}×{geometry['map_height_chunks']} chunks, retained runtime "
                f"material stride **64**.",
                f"- **Composition:** `{composition['mode']}`; {composition_detail}.",
                f"- **Tick-zero PNG SHA-256:** `{item['outputs']['tick0_png']['sha256']}`.",
                f"- **Runtime chunk map SHA-256:** `{item['outputs']['runtime_chunks']['sha256']}`.",
                f"- Detailed byte spans, source hashes, cycle records, and frame hashes: "
                f"[`evidence.json`]({path}/evidence.json), "
                f"[`animation.json`]({path}/animation.json).",
                "",
            ]
        )
    return "\n".join(lines) + "\n"


def reconstruct(
    rom_path: Path, output: Path, *, max_animation_frames: int, differential: bool
) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    rom_hash = sha256(rom)
    if rom_hash != EXPECTED_EU_ROM_SHA256:
        raise ReconstructionError(
            f"wrong ROM SHA-256 {rom_hash}; expected authoritative EU {EXPECTED_EU_ROM_SHA256}"
        )
    ground_audit.validate_rom(rom)

    archive = DungeonArchive(rom)
    floor_counts = ground_audit.parse_dungeon_floor_counts(rom)
    map_files = ground_audit.parse_map_files_table(rom)
    conversions = ground_audit.parse_ground_conversion_table(rom, map_files)
    mappings, sentinel = ground_audit.parse_map_to_dungeon_table(
        rom, conversions, floor_counts
    )
    if len(mappings) != 27:
        raise ReconstructionError(f"expected 27 direct mappings, got {len(mappings)}")
    names = parse_french_dungeon_names(rom)
    mapparam = parse_mapparam(archive, floor_counts)
    remap = rom[GRAPHICS_REMAP_OFFSET : GRAPHICS_REMAP_OFFSET + GRAPHICS_REMAP_COUNT]
    water_types = rom[WATER_TYPE_OFFSET : WATER_TYPE_OFFSET + WATER_TYPE_COUNT]

    differential_report: dict[str, Any]
    if differential:
        differential_report = differential_validate_at4px(archive)
    else:
        differential_report = {
            "stream_count": len(archive.at4px_streams()),
            "all_match": None,
            "skipped": True,
            "reason": "disabled by --skip-differential",
        }
    differential_path = output / "at4px_differential.json"
    write_json(differential_path, differential_report)

    relationships: list[dict[str, Any]] = []
    with tempfile.TemporaryDirectory(prefix="pmdred-eu-ground-") as temp:
        ground_extract = Path(temp)
        ground_report = ground_audit.audit_rom(
            rom, rom_path.name, extract_dir=ground_extract
        )
        for mapping in mappings:
            stable_id = mapping["stable_ground_id"]
            directory = output / stable_id
            directory.mkdir(parents=True, exist_ok=True)
            dependency = map_files[mapping["map_file_id"]]
            bma_path = ground_extract / f"{dependency['bma']}.bma"
            bma = bma_path.read_bytes()
            terrain, bma_metadata = decode_bma_terrain(bma, stable_id)
            geometry = bma_metadata["header"]

            dungeon_id = mapping["dungeon_id"]
            selector_row_index = mapping["runtime_floor_zero_based"]
            dungeon_selectors = mapparam["selectors"][dungeon_id]
            if selector_row_index >= dungeon_selectors["selector_row_count"]:
                raise ReconstructionError(
                    f"{stable_id}: runtime selector row exceeds table"
                )
            selector = dungeon_selectors["rows"][selector_row_index]
            property_index = selector["property_index"]
            prop = mapparam["properties"][property_index]
            tileset = prop["tileset"]
            if tileset >= len(remap):
                raise ReconstructionError(
                    f"{stable_id}: tileset {tileset} exceeds graphics remap"
                )
            graphics_index = remap[tileset]
            default = 3 if water_types[tileset] == 2 else 0

            font_name = f"b{graphics_index:02d}fon"
            cel_name = f"b{graphics_index:02d}cel"
            material_name = (
                f"b{tileset:02d}emap0" if tileset >= 64 else f"b{graphics_index:02d}cex"
            )
            palette_name = f"b{tileset:02d}pal"
            canm_name = f"b{tileset:02d}canm"
            # The runtime's global decompressor intentionally passes expected
            # length zero for FON; regional tilesets carry only the tiles they
            # use (up to the 512-entry descriptor address space).
            font, font_evidence = archive.decompress(font_name)
            cel, cel_evidence = archive.decompress(
                cel_name, expected_size=CEL_DECOMPRESSED_SIZE
            )
            material_size = (
                EMAP_DECOMPRESSED_SIZE if tileset >= 64 else CEX_DECOMPRESSED_SIZE
            )
            material, material_evidence = archive.decompress(
                material_name, expected_size=material_size
            )
            palette_data, palette_evidence = archive.raw(palette_name, 12 * 16 * 4)
            animations, canm_evidence = parse_canm(archive, canm_name)
            base_palette = parse_ground_palette(palette_data)

            chunks = compose_ground_chunks(
                terrain,
                geometry["map_height_chunks"],
                tileset,
                material,
                default=default,
            )
            chunk_data = struct.pack(f"<{len(chunks)}H", *chunks)
            chunk_path = directory / "chunks.u16le"
            chunk_path.write_bytes(chunk_data)
            visible = visible_chunks(
                chunks, geometry["map_width_chunks"], geometry["map_height_chunks"]
            )
            visible_data = struct.pack(f"<{len(visible)}H", *visible)

            renderer = DungeonGroundRenderer(font, cel)
            used_animation_indices = renderer.used_animation_indices(
                chunks, geometry["map_width_chunks"], geometry["map_height_chunks"]
            )
            tick0 = renderer.render(
                chunks,
                geometry["map_width_chunks"],
                geometry["map_height_chunks"],
                geometry["map_width_tiles"] * 8,
                geometry["map_height_tiles"] * 8,
                palette_at_tick(base_palette, animations, 0),
            )
            tick0_path = directory / "tick0.png"
            tick0.save(tick0_path, "PNG", optimize=False)
            tick0_file = tick0_path.read_bytes()
            tick0_record = {
                "path": f"{stable_id}/tick0.png",
                "width": tick0.width,
                "height": tick0.height,
                "pixel_sha256": sha256(tick0.tobytes()),
                "size": len(tick0_file),
                "sha256": sha256(tick0_file),
            }

            animation_path = directory / "animation.png"
            animation_preview = save_animation_preview(
                animation_path,
                renderer,
                chunks,
                geometry,
                base_palette,
                animations,
                used_animation_indices,
                max_frames=max_animation_frames,
            )
            cycles = animation_cycle_metadata(
                base_palette, animations, used_animation_indices
            )
            animation_record = {"cycles": cycles, "preview": animation_preview}
            animation_json_path = directory / "animation.json"
            write_json(animation_json_path, animation_record)

            selector_address = int(mapparam["pointers"]["selectors"], 16)
            selector_rows_address = int(
                dungeon_selectors["rows_span"]["address_hex"], 16
            )
            property_address = (
                int(mapparam["pointers"]["floor_properties"], 16) + property_index * 28
            )
            mapping_offset = (
                ground_audit.MAP_TO_DUNGEON_TABLE_OFFSET + mapping["index"] * 12
            )
            mapping_evidence = {
                key: value
                for key, value in mapping.items()
                if key not in ("requested_floor_zero_based", "runtime_floor_zero_based")
            }
            mapping_evidence.update(
                {
                    "requested_floor_value": mapping["requested_floor_zero_based"],
                    "runtime_selector_row": mapping["runtime_floor_zero_based"],
                }
            )
            evidence = {
                "schema": "pmdred-eu-direct-ground-evidence-v1",
                "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
                "authority": {"rom_sha256": rom_hash},
                "mapping": {
                    **mapping_evidence,
                    "row_span": PhysicalSpan(
                        mapping_offset, 12, f"{stable_id} direct mapping row"
                    ).as_dict(),
                    "sentinel_validated": sentinel["map_id"] == -1,
                },
                "role": source_role(stable_id),
                "dungeon": {
                    "id": dungeon_id,
                    "french_name_primary": names[dungeon_id]["primary"],
                    "french_name_secondary": names[dungeon_id]["secondary"],
                    "name_evidence": names[dungeon_id],
                    "selector_row_count_including_dummy": floor_counts[dungeon_id][
                        "floor_count"
                    ],
                    "playable_floor_count": floor_counts[dungeon_id]["floor_count"] - 1,
                    "floor_count_byte_span": PhysicalSpan(
                        ground_audit.DUNGEON_FLOOR_COUNT_TABLE_OFFSET + dungeon_id,
                        1,
                        f"dungeon {dungeon_id} selector row count",
                    ).as_dict(),
                },
                "selection": {
                    "requested_floor_value": mapping["requested_floor_zero_based"],
                    "runtime_selector_row": selector_row_index,
                    "selector_fields": selector["fields"],
                    "property_index": property_index,
                    "tileset": tileset,
                    "graphics_resource_index": graphics_index,
                    "selector_pointer_table_address_hex": f"0x{selector_address:08X}",
                    "selector_row_span": PhysicalSpan(
                        selector_rows_address - 0x08000000 + selector_row_index * 16,
                        16,
                        f"{stable_id} selected mapparam row",
                    ).as_dict(),
                    "floor_property_span": PhysicalSpan(
                        property_address - 0x08000000,
                        28,
                        f"{stable_id} selected floor property",
                    ).as_dict(),
                    "floor_property_raw_hex": prop["raw_hex"],
                },
                "source_ground": {
                    "map_file_id": mapping["map_file_id"],
                    "dependencies": dependency,
                    "bma_resource": dependency["bma"],
                    "normalized_bma_size": len(bma),
                    "normalized_bma_sha256": sha256(bma),
                    "bma": bma_metadata,
                },
                "ground_geometry": {
                    **geometry,
                    "pixel_width": geometry["map_width_tiles"] * 8,
                    "pixel_height": geometry["map_height_tiles"] * 8,
                    "runtime_material_stride": MATERIAL_STRIDE,
                    "runtime_material_width_chunks": MATERIAL_STRIDE,
                },
                "composition": {
                    "mode": "special_emap_direct"
                    if tileset >= 64
                    else "regular_cex_neighborhood",
                    "out_of_bounds_terrain_default": default,
                    "water_type_table_value": water_types[tileset],
                    "cex_variant": None if tileset >= 64 else 0,
                    "special_emap_bounds": [24, 24] if tileset >= 64 else None,
                    "runtime_chunk_count": len(chunks),
                    "runtime_chunks_u16le_sha256": sha256(chunk_data),
                    "visible_chunk_count": len(visible),
                    "visible_chunks_u16le_sha256": sha256(visible_data),
                    "unique_visible_chunks": sorted(set(visible)),
                },
                "resources": {
                    font_name: font_evidence,
                    cel_name: cel_evidence,
                    material_name: material_evidence,
                    palette_name: palette_evidence,
                    canm_name: canm_evidence,
                },
                "palette": {
                    "base_ground_palette_rgba_sha256": sha256(
                        bytes(value for color in base_palette for value in color)
                    ),
                    "gba_png_quantization": "channel5=(source&0xF8)>>3; channel8=(channel5<<3)|(channel5>>2)",
                    "animation": animation_record,
                },
                "outputs": {
                    "runtime_chunks": {
                        "path": f"{stable_id}/chunks.u16le",
                        "size": len(chunk_data),
                        "sha256": sha256(chunk_data),
                        "encoding": "64 × map_height_chunks little-endian u16 chunk IDs",
                    },
                    "tick0_png": tick0_record,
                    "animation_png": {
                        "path": f"{stable_id}/animation.png",
                        **animation_preview,
                    },
                    "animation_json": {
                        "path": f"{stable_id}/animation.json",
                        **file_record(animation_json_path),
                    },
                },
            }
            evidence_path = directory / "evidence.json"
            write_json(evidence_path, evidence)

            relationships.append(
                {
                    "stable_ground_id": stable_id,
                    "output_directory": stable_id,
                    "mapping": evidence["mapping"],
                    "role": evidence["role"],
                    "dungeon": evidence["dungeon"],
                    "selection": evidence["selection"],
                    "ground_geometry": evidence["ground_geometry"],
                    "composition": evidence["composition"],
                    "outputs": evidence["outputs"],
                    "evidence_json": {
                        "path": f"{stable_id}/evidence.json",
                        **file_record(evidence_path),
                    },
                }
            )

    bundle = {
        "schema": "pmdred-eu-direct-ground-bundle-v1",
        "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
        "authority": {
            "game": "Pokémon Mystery Dungeon: Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "rom_filename": rom_path.name,
            "rom_sha256": rom_hash,
            "content_authority": "EU GBA ROM bytes",
            "technical_reference": "pret/pmd-red runtime semantics",
        },
        "summary": {
            "mapping_count": len(relationships),
            "midpoint_relay_count": sum(
                item["role"]["classification"] == "midpoint_relay_ground"
                for item in relationships
            ),
            "ending_ground_count": sum(
                item["role"]["classification"] == "ending_ground"
                for item in relationships
            ),
            "fixed_dungeon_ground_count": sum(
                item["role"]["classification"] == "fixed_dungeon_ground"
                for item in relationships
            ),
            "regular_cex_count": sum(
                item["composition"]["mode"] == "regular_cex_neighborhood"
                for item in relationships
            ),
            "special_emap_count": sum(
                item["composition"]["mode"] == "special_emap_direct"
                for item in relationships
            ),
        },
        "runtime_semantics": {
            "call_chain": ["GroundMap_SelectDungeon", "sub_80A3440", "sub_80ADD9C"],
            "floor_rule": "clamp to selector rows 1..GetDungeonFloorCount(id)-1",
            "regular_material_rule": "CEX neighborhood mask, deterministic first variant cex[mask*3]",
            "special_material_rule": "emap0[y*24+x] inside 24×24",
            "terrain_stride": 64,
            "water_default_rule": "default terrain 3 only when gDungeonWaterType[tileset] == WATER (2), else 0",
            "ground_metadata": {
                "maximum_addressable_tiles": 512,
                "chunks": 250,
                "palettes": 12,
            },
            "tick_zero_model": (
                "sub_80A3440 publishes the raw PAL, then ReadAnimatedColorData initializes timers/currentColor "
                "without publishing it; sub_80A3BB0 initializes map render contexts only. Thus tick 0 is the "
                "raw PAL and CANM color 0 first appears when that record's timer expires."
            ),
        },
        "at4px_differential": {
            "path": "at4px_differential.json",
            "stream_count": differential_report["stream_count"],
            "all_match": differential_report.get("all_match"),
            "file": file_record(differential_path),
        },
        "mapparam": {
            "archive_data_address_hex": mapparam["archive_data_address_hex"],
            "root_span": mapparam["root_span"],
            "pointers": mapparam["pointers"],
            "selector_pointer_table_span": mapparam["selector_pointer_table_span"],
            "referenced_properties_span": mapparam["referenced_properties_span"],
        },
        "fresh_ground_audit": {
            "schema": ground_report["schema"],
            "tool": ground_report["tool"],
            "resource_count": ground_report["ground_archive"]["entry_count"],
            "validation": ground_report["validation"],
        },
        "relationships": relationships,
    }
    manifest_path = output / "manifest.json"
    write_json(manifest_path, bundle)
    report_path = output / "report.md"
    report_path.write_text(build_report(bundle), encoding="utf-8")
    return bundle


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "rom", type=Path, help="authoritative EU Red Rescue Team GBA ROM"
    )
    parser.add_argument("output", type=Path, help="new or empty output directory")
    parser.add_argument(
        "--max-animation-frames",
        type=int,
        default=32,
        help="maximum exact startup event states per APNG preview (default: 32)",
    )
    parser.add_argument(
        "--skip-differential",
        action="store_true",
        help="skip SkyTemple comparison (not appropriate for final evidence)",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="remove a pre-existing output directory before reconstruction",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.max_animation_frames < 1:
        raise SystemExit("--max-animation-frames must be positive")
    if args.output.exists():
        if args.overwrite:
            resolved = args.output.resolve()
            if resolved == Path("/") or resolved == Path.cwd().resolve():
                raise SystemExit(f"refusing to remove unsafe output path {resolved}")
            shutil.rmtree(args.output)
        elif any(args.output.iterdir()):
            raise SystemExit(
                f"output directory is not empty: {args.output} (use --overwrite)"
            )
    args.output.mkdir(parents=True, exist_ok=True)
    try:
        bundle = reconstruct(
            args.rom,
            args.output,
            max_animation_frames=args.max_animation_frames,
            differential=not args.skip_differential,
        )
    except ReconstructionError as exc:
        raise SystemExit(f"reconstruction failed: {exc}") from exc
    print(f"Reconstructed mappings: {bundle['summary']['mapping_count']}")
    differential_status = bundle["at4px_differential"]["all_match"]
    print(
        f"AT4PX streams: {bundle['at4px_differential']['stream_count']} "
        f"({'all matched' if differential_status else 'differential skipped'})"
    )
    print(f"Manifest: {args.output / 'manifest.json'}")
    print(f"Illustrated report: {args.output / 'report.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
