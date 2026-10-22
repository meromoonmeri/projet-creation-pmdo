#!/usr/bin/env python3
"""Validate every artifact in a PMD Red direct dungeon-Ground evidence bundle."""

from __future__ import annotations

import argparse
import json
import re
import struct
import tempfile
from pathlib import Path
from typing import Any

import audit_pmdred_eu_rom as ground_audit
from PIL import Image
from pmdred_dungeon_ground import (
    CEL_DECOMPRESSED_SIZE,
    CEX_DECOMPRESSED_SIZE,
    EMAP_DECOMPRESSED_SIZE,
    EXPECTED_EU_ROM_SHA256,
    GRAPHICS_REMAP_COUNT,
    GRAPHICS_REMAP_OFFSET,
    WATER_TYPE_COUNT,
    WATER_TYPE_OFFSET,
    DungeonArchive,
    DungeonGroundRenderer,
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
    require,
    save_animation_preview,
    sha256,
)

EXPECTED_GROUNDS = {
    "d01p02",
    "d02p02",
    "d03p02",
    "d04p02",
    "d05p02",
    "d06p02",
    "d06p03",
    "d09p02",
    "d09p03",
    "d10p02",
    "d10p03",
    "d11p02",
    "d11p03",
    "d12p02",
    "d12p04",
    "d13p02",
    "d13p03",
    "d14p01",
    "d15p01",
    "d16p01",
    "d17p01",
    "d18p01",
    "d19p01",
    "d20p01",
    "d21p01",
    "d23p01",
    "d25p01",
}


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReconstructionError(f"cannot read valid JSON {path}: {exc}") from exc


def validate_file(root: Path, record: dict[str, Any], context: str) -> bytes:
    relative = record["path"]
    relative_path = Path(relative) if isinstance(relative, str) else Path("/")
    require(
        isinstance(relative, str)
        and not relative_path.is_absolute()
        and ".." not in relative_path.parts,
        f"{context}: unsafe path",
    )
    path = root / relative_path
    require(path.is_file(), f"{context}: missing {relative}")
    data = path.read_bytes()
    expected_size = record.get("size", record.get("file_size"))
    expected_hash = record.get("sha256", record.get("file_sha256"))
    require(len(data) == expected_size, f"{context}: size mismatch for {relative}")
    require(
        sha256(data) == expected_hash, f"{context}: SHA-256 mismatch for {relative}"
    )
    return data


def validate_bundle(root: Path, rom_path: Path) -> dict[str, int]:
    rom = rom_path.read_bytes()
    require(
        sha256(rom) == EXPECTED_EU_ROM_SHA256,
        "validator ROM is not the authoritative EU ROM",
    )
    manifest_path = root / "manifest.json"
    manifest = load_json(manifest_path)
    require(
        manifest["authority"]["rom_sha256"] == EXPECTED_EU_ROM_SHA256,
        "manifest ROM hash mismatch",
    )
    relationships = manifest["relationships"]
    require(len(relationships) == 27, "manifest must contain 27 relationships")
    require(
        {item["stable_ground_id"] for item in relationships} == EXPECTED_GROUNDS,
        "manifest Ground ID set mismatch",
    )
    require(
        manifest["summary"]["mapping_count"] == 27, "summary mapping count mismatch"
    )

    # Re-derive every relationship from the supplied ROM. Artifact hashes alone
    # only prove internal consistency; these independent reads tie the bundle
    # back to the authoritative bytes on every validation run.
    ground_audit.validate_rom(rom)
    archive = DungeonArchive(rom)
    floor_counts = ground_audit.parse_dungeon_floor_counts(rom)
    map_files = ground_audit.parse_map_files_table(rom)
    conversions = ground_audit.parse_ground_conversion_table(rom, map_files)
    mappings, sentinel = ground_audit.parse_map_to_dungeon_table(
        rom, conversions, floor_counts
    )
    require(
        len(mappings) == 27 and sentinel["map_id"] == -1,
        "ROM direct-mapping table mismatch",
    )
    mapping_by_id = {mapping["stable_ground_id"]: mapping for mapping in mappings}
    require(
        set(mapping_by_id) == EXPECTED_GROUNDS,
        "ROM direct-mapping Ground ID set mismatch",
    )
    names = parse_french_dungeon_names(rom)
    mapparam = parse_mapparam(archive, floor_counts)
    remap = rom[GRAPHICS_REMAP_OFFSET : GRAPHICS_REMAP_OFFSET + GRAPHICS_REMAP_COUNT]
    water_types = rom[WATER_TYPE_OFFSET : WATER_TYPE_OFFSET + WATER_TYPE_COUNT]
    extraction = tempfile.TemporaryDirectory(prefix="pmdred-eu-bundle-validation-")
    ground_extract = Path(extraction.name)
    ground_audit.audit_rom(rom, rom_path.name, extract_dir=ground_extract)

    differential_record = {
        "path": manifest["at4px_differential"]["path"],
        **manifest["at4px_differential"]["file"],
    }
    differential_data = validate_file(root, differential_record, "AT4PX differential")
    differential = json.loads(differential_data)
    require(
        differential.get("all_match") is True,
        "final bundle did not run the AT4PX differential",
    )
    require(
        differential.get("stream_count") == 204,
        "AT4PX differential does not contain 204 streams",
    )
    require(
        len(differential.get("entries", [])) == 204,
        "AT4PX differential entry count mismatch",
    )
    require(
        all(row.get("match") is True for row in differential["entries"]),
        "AT4PX mismatch recorded",
    )
    require(
        len({row["resource"] for row in differential["entries"]}) == 204,
        "AT4PX differential has duplicate resources",
    )
    require(
        differential == differential_validate_at4px(archive),
        "stored AT4PX differential does not match a fresh all-stream ROM comparison",
    )

    report_path = root / "report.md"
    require(report_path.is_file(), "missing illustrated report.md")
    report = report_path.read_text(encoding="utf-8")
    linked_files = re.findall(r"\]\(([^)]+)\)", report)
    for link in linked_files:
        link_path = Path(link)
        require(
            not link_path.is_absolute() and ".." not in link_path.parts,
            f"report has unsafe link {link}",
        )
        require((root / link_path).is_file(), f"report has broken link {link}")

    rendered_frames = 0
    for relationship in relationships:
        stable_id = relationship["stable_ground_id"]
        evidence_data = validate_file(
            root, relationship["evidence_json"], f"{stable_id} evidence"
        )
        evidence = json.loads(evidence_data)
        require(
            evidence["mapping"]["stable_ground_id"] == stable_id,
            f"{stable_id}: evidence ID mismatch",
        )
        require(
            evidence["authority"]["rom_sha256"] == EXPECTED_EU_ROM_SHA256,
            f"{stable_id}: ROM mismatch",
        )
        require(
            evidence["mapping"] == relationship["mapping"],
            f"{stable_id}: manifest mapping mismatch",
        )

        source_mapping = mapping_by_id[stable_id]
        for key in (
            "index",
            "map_id",
            "map_file_id",
            "conversion_type",
            "dungeon_id",
            "variant",
        ):
            require(
                evidence["mapping"][key] == source_mapping[key],
                f"{stable_id}: mapping field {key} differs from ROM",
            )
        require(
            evidence["mapping"]["requested_floor_value"]
            == source_mapping["requested_floor_zero_based"],
            f"{stable_id}: requested floor value differs from ROM",
        )
        require(
            evidence["mapping"]["runtime_selector_row"]
            == source_mapping["runtime_floor_zero_based"],
            f"{stable_id}: runtime selector row differs from ROM",
        )

        dungeon_id = source_mapping["dungeon_id"]
        dungeon_floor_count = floor_counts[dungeon_id]["floor_count"]
        require(
            evidence["dungeon"]["selector_row_count_including_dummy"]
            == dungeon_floor_count
            and evidence["dungeon"]["playable_floor_count"] == dungeon_floor_count - 1,
            f"{stable_id}: dungeon floor count differs from ROM",
        )
        require(
            evidence["dungeon"]["french_name_primary"] == names[dungeon_id]["primary"]
            and evidence["dungeon"]["french_name_secondary"]
            == names[dungeon_id]["secondary"],
            f"{stable_id}: French dungeon names differ from ROM",
        )

        dependency = map_files[source_mapping["map_file_id"]]
        source_ground = evidence["source_ground"]
        require(
            source_ground["dependencies"] == dependency,
            f"{stable_id}: Ground dependencies differ from ROM",
        )
        bma = (ground_extract / f"{dependency['bma']}.bma").read_bytes()
        terrain, bma_metadata = decode_bma_terrain(bma, stable_id)
        require(
            source_ground["normalized_bma_size"] == len(bma),
            f"{stable_id}: BMA size differs from ROM",
        )
        require(
            source_ground["normalized_bma_sha256"] == sha256(bma),
            f"{stable_id}: BMA hash differs from ROM",
        )
        require(
            source_ground["bma"] == bma_metadata,
            f"{stable_id}: BMA decode evidence differs from ROM",
        )

        selector_row = source_mapping["runtime_floor_zero_based"]
        selector = mapparam["selectors"][dungeon_id]["rows"][selector_row]
        property_index = selector["property_index"]
        prop = mapparam["properties"][property_index]
        tileset = prop["tileset"]
        graphics_index = remap[tileset]
        default = 3 if water_types[tileset] == 2 else 0
        selection = evidence["selection"]
        require(
            selection["runtime_selector_row"] == selector_row,
            f"{stable_id}: selector row differs from ROM",
        )
        require(
            selection["selector_fields"] == selector["fields"],
            f"{stable_id}: selector fields differ from ROM",
        )
        require(
            selection["property_index"] == property_index,
            f"{stable_id}: property index differs from ROM",
        )
        require(
            selection["floor_property_raw_hex"] == prop["raw_hex"],
            f"{stable_id}: property bytes differ from ROM",
        )
        require(
            selection["tileset"] == tileset, f"{stable_id}: tileset differs from ROM"
        )
        require(
            selection["graphics_resource_index"] == graphics_index,
            f"{stable_id}: graphics remap differs from ROM",
        )
        require(
            evidence["composition"]["out_of_bounds_terrain_default"] == default
            and evidence["composition"]["water_type_table_value"]
            == water_types[tileset],
            f"{stable_id}: water/default terrain evidence differs from ROM",
        )

        require(
            evidence["ground_geometry"] == relationship["ground_geometry"],
            f"{stable_id}: geometry mismatch",
        )
        geometry = evidence["ground_geometry"]
        require(
            all(
                geometry[key] == bma_metadata["header"][key]
                for key in bma_metadata["header"]
            ),
            f"{stable_id}: rendered geometry differs from decoded ROM BMA",
        )
        require(
            geometry["pixel_width"] == geometry["map_width_tiles"] * 8
            and geometry["pixel_height"] == geometry["map_height_tiles"] * 8,
            f"{stable_id}: pixel geometry mismatch",
        )
        require(
            geometry["runtime_material_stride"] == 64,
            f"{stable_id}: material stride mismatch",
        )

        font_name = f"b{graphics_index:02d}fon"
        cel_name = f"b{graphics_index:02d}cel"
        material_name = (
            f"b{tileset:02d}emap0" if tileset >= 64 else f"b{graphics_index:02d}cex"
        )
        palette_name = f"b{tileset:02d}pal"
        canm_name = f"b{tileset:02d}canm"
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
        for resource_name, fresh_evidence in (
            (font_name, font_evidence),
            (cel_name, cel_evidence),
            (material_name, material_evidence),
            (palette_name, palette_evidence),
            (canm_name, canm_evidence),
        ):
            require(
                evidence["resources"][resource_name] == fresh_evidence,
                f"{stable_id}: {resource_name} evidence differs from ROM",
            )

        source_chunks = compose_ground_chunks(
            terrain,
            geometry["map_height_chunks"],
            tileset,
            material,
            default=default,
        )
        source_chunk_data = struct.pack(f"<{len(source_chunks)}H", *source_chunks)
        chunk_data = validate_file(
            root, evidence["outputs"]["runtime_chunks"], f"{stable_id} chunks"
        )
        require(
            chunk_data == source_chunk_data,
            f"{stable_id}: chunk map differs from fresh ROM composition",
        )
        expected_chunks = (
            geometry["runtime_material_stride"] * geometry["map_height_chunks"]
        )
        require(
            len(chunk_data) == expected_chunks * 2,
            f"{stable_id}: chunk geometry mismatch",
        )
        chunks = struct.unpack(f"<{expected_chunks}H", chunk_data)
        require(
            all(chunk < 250 for chunk in chunks), f"{stable_id}: chunk ID outside CEL"
        )
        require(
            sha256(chunk_data)
            == evidence["composition"]["runtime_chunks_u16le_sha256"],
            f"{stable_id}: composition chunk hash mismatch",
        )

        renderer = DungeonGroundRenderer(font, cel)
        base_palette = parse_ground_palette(palette_data)
        used_animation_indices = renderer.used_animation_indices(
            source_chunks,
            geometry["map_width_chunks"],
            geometry["map_height_chunks"],
        )
        fresh_tick = renderer.render(
            source_chunks,
            geometry["map_width_chunks"],
            geometry["map_height_chunks"],
            geometry["pixel_width"],
            geometry["pixel_height"],
            palette_at_tick(base_palette, animations, 0),
        )

        tick_record = evidence["outputs"]["tick0_png"]
        tick_data = validate_file(root, tick_record, f"{stable_id} tick 0")
        with Image.open(root / tick_record["path"]) as tick_image:
            rgb = tick_image.convert("RGB")
            require(
                rgb.size == (geometry["pixel_width"], geometry["pixel_height"]),
                f"{stable_id}: PNG dimensions mismatch",
            )
            require(
                sha256(rgb.tobytes()) == tick_record["pixel_sha256"],
                f"{stable_id}: PNG pixel hash mismatch",
            )
            require(
                rgb.getbbox() is not None, f"{stable_id}: tick-zero PNG is fully black"
            )
        require(
            tick_data.startswith(b"\x89PNG\r\n\x1a\n"),
            f"{stable_id}: tick output is not PNG",
        )
        require(
            fresh_tick.tobytes() == rgb.tobytes(),
            f"{stable_id}: tick-zero pixels differ from fresh ROM reconstruction",
        )

        animation_json_data = validate_file(
            root,
            evidence["outputs"]["animation_json"],
            f"{stable_id} animation metadata",
        )
        animation_json = json.loads(animation_json_data)
        require(
            animation_json == evidence["palette"]["animation"],
            f"{stable_id}: animation JSON mismatch",
        )
        require(
            animation_json["cycles"]
            == animation_cycle_metadata(
                base_palette, animations, used_animation_indices
            ),
            f"{stable_id}: cycle metadata differs from fresh ROM reconstruction",
        )
        preview = evidence["outputs"]["animation_png"]
        preview_data = validate_file(root, preview, f"{stable_id} animation preview")
        fresh_preview_path = ground_extract / f"{stable_id}-validation-preview.png"
        fresh_preview = save_animation_preview(
            fresh_preview_path,
            renderer,
            source_chunks,
            geometry,
            base_palette,
            animations,
            used_animation_indices,
            max_frames=preview["requested_max_state_frames"],
        )
        require(
            all(preview.get(key) == value for key, value in fresh_preview.items()),
            f"{stable_id}: preview metadata differs from fresh ROM reconstruction",
        )
        require(
            preview_data == fresh_preview_path.read_bytes(),
            f"{stable_id}: preview file differs from fresh ROM reconstruction",
        )
        require(
            preview["stored_frame_count"]
            == len(preview["frame_pixel_sha256"])
            == len(preview["frame_start_ticks"])
            == len(preview["frame_duration_ticks"]),
            f"{stable_id}: preview frame metadata lengths mismatch",
        )
        with Image.open(root / preview["path"]) as animation_image:
            require(
                animation_image.n_frames == preview["stored_frame_count"],
                f"{stable_id}: APNG frame count mismatch",
            )
            for index, pixel_hash in enumerate(preview["frame_pixel_sha256"]):
                animation_image.seek(index)
                frame = animation_image.convert("RGB")
                require(
                    frame.size == (geometry["pixel_width"], geometry["pixel_height"]),
                    f"{stable_id}: APNG frame dimensions mismatch",
                )
                require(
                    sha256(frame.tobytes()) == pixel_hash,
                    f"{stable_id}: APNG frame {index} pixel mismatch",
                )
                require(
                    frame.getbbox() is not None,
                    f"{stable_id}: APNG frame {index} is fully black",
                )
                rendered_frames += 1

    expected_files = 3 + 27 * 5
    actual_files = sum(path.is_file() for path in root.rglob("*"))
    require(
        actual_files == expected_files,
        f"bundle has {actual_files} files, expected {expected_files}",
    )
    extraction.cleanup()
    return {
        "relationships": len(relationships),
        "at4px_streams": len(differential["entries"]),
        "rendered_frames": rendered_frames,
        "files": actual_files,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path, help="authoritative EU ROM")
    parser.add_argument("bundle", type=Path, help="generated evidence-bundle directory")
    args = parser.parse_args()
    try:
        result = validate_bundle(args.bundle, args.rom)
    except ReconstructionError as exc:
        raise SystemExit(f"validation failed: {exc}") from exc
    print(
        f"Validated {result['relationships']} relationships, {result['at4px_streams']} AT4PX streams, "
        f"{result['rendered_frames']} rendered frames, and {result['files']} files."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
