#!/usr/bin/env python3
"""Extract redacted visual timelines and environmental VFX used by Relict maps."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import struct
import subprocess
import tempfile
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from inventory_relict import (
    DEFAULT_OUTPUT,
    DEFAULT_SOURCE,
    EXCLUDED_COMMANDS,
    VISUAL_COMMANDS,
    condition_flags,
    ivar,
    movement_route,
    sha256_bytes,
    sha256_file,
    slug,
    write_json,
)
from png_rgba import load_png, save_png
from ruby_marshal import RubyObject, decode_text, load

WAIT_CODE = 106
CONTROL_CODES = {
    111: "conditional_branch", 112: "loop", 113: "break_loop", 115: "exit_event",
    117: "common_event_call", 118: "label_redacted", 119: "label_jump_redacted",
    411: "else", 412: "branch_end", 413: "repeat_above",
}
EXTRA_VISUAL_COMMANDS = {
    205: "fog_tone", 206: "fog_opacity", 208: "entity_transparency",
    210: "wait_for_move_completion",
}
ENVIRONMENT_SETTING_TYPES = {0: ("PANORAMA", "Panoramas"), 1: ("FOG", "Fogs")}
PICTURE_DIR = "Pictures"
TRANSITION_DIR = "Transitions"
# Manual pixel review, pinned by source hash so cast filenames never enter outputs.
PICTURE_REVIEW_DECISIONS = {
    "ce9caad932a047ecd83243b907a0cf01098a7bc36d2438d56f03420b94fcdeb9": "EXCLUDED_CHARACTER",
    "991ab657b1b9fb26a3128a69a474bf7e3da489e818025e75060f4c0647774501": "EXCLUDED_CHARACTER",
    "2b351a6b853f2762e37c8aa71da5f4811e9ef20f664be134ae5ac50d53247484": "EXCLUDED_CHARACTER",
    "dd16ee6a8d15539bb8b4d3347f0dddfd915343fbd88eec2568daf6e8653f97b6": "EXCLUDED_UI",
    "a1b36573aad184257d9c4b8329f412d85d97adef8ac47656d008cf3565a50686": "INCLUDED_ENVIRONMENTAL",
    "6dc7876f1f0c8cc407a74d902557e6b3a812eda4abd767cca91d8f48c6777b19": "INCLUDED_ENVIRONMENTAL",
    "991e68ad1d07b375faa43f3851cd4445f1b859c73f76d7134208521a0eaff2f9": "INCLUDED_ENVIRONMENTAL",
    "918406c1bcc2043309306aa87c5054166ac5d65f3f45878d5ce2d41c01b4d376": "INCLUDED_ENVIRONMENTAL",
    "9e82336999bfe1efff290d0aeaefe3526005bfa5613feb3e106969846c5554f1": "INCLUDED_ENVIRONMENTAL",
}


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def safe_value(value: Any) -> Any:
    if value is None or isinstance(value, (bool, int, float)):
        return value
    if isinstance(value, RubyObject):
        if value.class_name in ("Tone", "Color"):
            return {
                "type": value.class_name,
                "red": ivar(value, "red", 0),
                "green": ivar(value, "green", 0),
                "blue": ivar(value, "blue", 0),
                "gray": ivar(value, "gray", 0) if value.class_name == "Tone" else None,
                "alpha": ivar(value, "alpha", 255) if value.class_name == "Color" else None,
            }
        return {
            "redacted_object_type": value.class_name,
            "sha256": sha256_bytes(repr(sorted(value.ivars)).encode()),
        }
    if isinstance(value, list):
        return [safe_value(item) for item in value]
    text = decode_text(value)
    return {"redacted_string_sha256": sha256_bytes(text.encode())}


def command_record(command: RubyObject) -> tuple[dict[str, Any] | None, dict[str, str] | None]:
    code = int(ivar(command, "code", 0))
    indent = int(ivar(command, "indent", 0))
    parameters = ivar(command, "parameters", []) or []
    environment_reference = None
    if code == WAIT_CODE:
        frames = int(parameters[0]) if parameters else 0
        return {
            "code": code,
            "category": "wait",
            "indent": indent,
            "parameters": {"frames": frames, "nominal_ms_at_rgss_40fps": frames * 25},
        }, None
    if code == 204:
        setting = int(parameters[0]) if parameters else -1
        kind = ENVIRONMENT_SETTING_TYPES.get(setting)
        name = decode_text(parameters[1]) if len(parameters) > 1 else ""
        values = [safe_value(value) for value in parameters[2:]]
        payload = {
            "setting_type": setting,
            "environment_name": name if kind else None,
            "redacted_name_sha256": None if kind else sha256_bytes(name.encode()),
            "values": values,
        }
        if kind and name:
            environment_reference = {"kind": kind[0], "directory": kind[1], "name": name}
        return {"code": code, "category": "map_visual_settings", "indent": indent, "parameters": payload}, environment_reference
    if code == 209:
        target = int(parameters[0]) if parameters else 0
        repeat, skippable, route = movement_route(parameters[1] if len(parameters) > 1 else None)
        return {
            "code": code,
            "category": "forced_move_route",
            "indent": indent,
            "parameters": {
                "target_event_id": target,
                "repeat": repeat,
                "skippable": skippable,
                "commands": route,
            },
        }, None
    if code == 231:
        picture_name = decode_text(parameters[1]) if len(parameters) > 1 else ""
        numeric = [safe_value(value) for index, value in enumerate(parameters) if index != 1]
        return {
            "code": code,
            "category": "picture_show_review_required",
            "indent": indent,
            "parameters": {
                "source_identity_sha256": sha256_bytes(picture_name.encode()),
                "numeric_and_safe_parameters": numeric,
                "source_pixels_exported": False,
            },
        }, {"kind": "PICTURE_REVIEW", "directory": PICTURE_DIR, "name": picture_name}
    if code == 222:
        name = decode_text(parameters[0]) if parameters else ""
        return {
            "code": code,
            "category": "transition_execute_review_required",
            "indent": indent,
            "parameters": {
                "source_identity_sha256": sha256_bytes(name.encode()),
                "source_pixels_exported": False,
            },
        }, {"kind": "TRANSITION_REVIEW", "directory": TRANSITION_DIR, "name": name}
    category = VISUAL_COMMANDS.get(code) or EXTRA_VISUAL_COMMANDS.get(code)
    if category:
        return {
            "code": code,
            "category": category,
            "indent": indent,
            "parameters": [safe_value(value) for value in parameters],
        }, None
    if code in CONTROL_CODES:
        return {
            "code": code,
            "category": CONTROL_CODES[code],
            "indent": indent,
            "parameters": [safe_value(value) for value in parameters],
        }, None
    return None, None


def mkxp_timing_authority(source: Path) -> dict[str, Any]:
    path = source / "mkxp.json"
    active = "\n".join(
        line.split("//", 1)[0] for line in path.read_text(encoding="utf-8").splitlines()
    )
    if re.search(r'"fixedFramerate"\s*:', active):
        raise ValueError("active mkxp fixedFramerate requires explicit timing handling")
    return {
        "nominal_frame_rate": 40,
        "frame_duration_ms": 25,
        "source_path": "mkxp.json",
        "sha256": sha256_file(path),
        "fixed_framerate_override_active": False,
    }


def resolve_asset(source: Path, directory: str, name: str) -> Path | None:
    if not name:
        return None
    root = source / "Graphics" / directory
    matches = sorted(
        (path for path in root.rglob("*") if path.is_file() and path.stem.casefold() == name.casefold()),
        key=lambda path: ("backup" in {part.casefold() for part in path.parts}, len(path.parts), path.as_posix()),
    )
    return matches[0] if matches else None


def safe_script_expression(expression: str) -> Any:
    expression = expression.strip()
    if re.fullmatch(r"-?\d+", expression):
        return int(expression)
    if re.fullmatch(r"-?\d+\.\d+", expression):
        return float(expression)
    if expression in ("true", "false"):
        return expression == "true"
    match = re.fullmatch(r"rand\(\s*(-?\d+)\.\.(-?\d+)\s*\)", expression)
    if match:
        return {"random_integer_range": [int(match.group(1)), int(match.group(2))]}
    return {"redacted_expression_sha256": sha256_bytes(expression.encode())}


def split_script_arguments(arguments: str) -> list[Any]:
    # Recognized visual calls in this source use only flat arguments or rand(a..b).
    # Splitting commas outside parentheses keeps the random ranges intact.
    result = []
    start = depth = 0
    for index, char in enumerate(arguments):
        if char == "(":
            depth += 1
        elif char == ")":
            depth = max(0, depth - 1)
        elif char == "," and depth == 0:
            result.append(safe_script_expression(arguments[start:index]))
            start = index + 1
    if arguments[start:].strip():
        result.append(safe_script_expression(arguments[start:]))
    return result


def parse_script_visual_block(text: str) -> dict[str, Any] | None:
    calls = []
    tone_pattern = re.compile(
        r"pbToneChangeAll\s*\(\s*Tone\.new\(\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\)\s*,\s*([0-9.]+)\s*\)"
    )
    for match in tone_pattern.finditer(text):
        calls.append({
            "call": "tone_change_all",
            "tone": [int(match.group(index)) for index in range(1, 5)],
            "duration_rgss_frames": safe_script_expression(match.group(5)),
        })
    patterns = (
        (r"pbCameraScrollTo\s*\(([^)]*)\)", "camera_scroll_to"),
        (r"pbCameraToEvent\s*\(([^)]*)\)", "camera_to_event"),
        (r"pbCameraShake\s*\(([^)]*)\)", "camera_shake"),
        (r"pbWait\s*\(([^)]*)\)", "wait_seconds"),
        (r"addUserAnimation\s*\(([^)]*(?:rand\([^)]*\)[^)]*)?)\)", "user_animation"),
    )
    for pattern, call_name in patterns:
        for match in re.finditer(pattern, text):
            calls.append({"call": call_name, "arguments": split_script_arguments(match.group(1))})
    for pattern, call_name in (
        (r"\bpbCameraReset\b(?!\s*\()", "camera_reset"),
        (r"\bpbCameraShakeOff\b(?!\s*\()", "camera_shake_off"),
    ):
        calls.extend({"call": call_name, "arguments": []} for _ in re.finditer(pattern, text))
    source_hash = sha256_bytes(text.encode())
    repeat_counts = [int(value) for value in re.findall(r"\b(\d+)\.times\s+do\b", text)]
    if calls:
        return {
            "category": "script_visual_block",
            "source_block_sha256": source_hash,
            "source_text_exported": False,
            "line_count": len(text.splitlines()),
            "fixed_repeat_counts": repeat_counts,
            "calls": calls,
        }
    if re.search(r"(?i)\b(camera|tone|animation|shake|fog|weather|picture|panorama|fade|screen)\b", text):
        return {
            "category": "script_visual_candidate_review",
            "source_block_sha256": source_hash,
            "source_text_exported": False,
            "line_count": len(text.splitlines()),
            "fixed_repeat_counts": repeat_counts,
            "calls": [],
        }
    return None


def timeline_for_commands(commands: list[Any]) -> tuple[list[dict[str, Any]], list[dict[str, str]], Counter]:
    timeline = []
    references = []
    excluded = Counter()
    source_index = 0
    while source_index < len(commands):
        command = commands[source_index]
        if not isinstance(command, RubyObject):
            source_index += 1
            continue
        code = int(ivar(command, "code", 0))
        if code == 355:
            parts = [decode_text((ivar(command, "parameters", []) or [""])[0])]
            excluded[EXCLUDED_COMMANDS[355]] += 1
            next_index = source_index + 1
            while next_index < len(commands) and int(ivar(commands[next_index], "code", 0)) == 655:
                parts.append(decode_text((ivar(commands[next_index], "parameters", []) or [""])[0]))
                excluded[EXCLUDED_COMMANDS[655]] += 1
                next_index += 1
            visual_script = parse_script_visual_block("\n".join(parts))
            if visual_script:
                timeline.append({
                    "code": code,
                    "category": visual_script["category"],
                    "indent": int(ivar(command, "indent", 0)),
                    "parameters": visual_script,
                    "source_index": source_index,
                })
            source_index = next_index
            continue
        if code in EXCLUDED_COMMANDS:
            excluded[EXCLUDED_COMMANDS[code]] += 1
        record, reference = command_record(command)
        if record:
            record["source_index"] = source_index
            timeline.append(record)
        if reference and reference["name"]:
            reference = dict(reference)
            reference["source_index"] = source_index
            references.append(reference)
        source_index += 1
    return timeline, references, excluded


def map_timeline(map_id: int, map_obj: RubyObject, variant: str | None) -> tuple[dict[str, Any], list[dict[str, str]]]:
    sequences = []
    references = []
    totals = Counter()
    excluded_totals = Counter()
    events = ivar(map_obj, "events", {}) or {}
    for event_id, event in sorted(events.items(), key=lambda item: int(item[0])):
        for page_index, page in enumerate(ivar(event, "pages", []) or []):
            commands = ivar(page, "list", []) or []
            timeline, page_refs, excluded = timeline_for_commands(commands)
            if not timeline:
                continue
            for row in timeline:
                totals[row["category"]] += 1
            excluded_totals.update(excluded)
            for ref in page_refs:
                ref.update({"map_id": map_id, "event_id": int(event_id), "page_index": page_index})
            references.extend(page_refs)
            sequences.append({
                "source_event_id": int(event_id),
                "page_index": page_index,
                "trigger": int(ivar(page, "trigger", 0)),
                "condition_flags": condition_flags(ivar(page, "condition")),
                "timeline": timeline,
                "excluded_command_counts": dict(sorted(excluded.items())),
            })
    return {
        "schema_version": "1.0.0",
        "map_id": map_id,
        "variant": variant,
        "timing": {
            "source_unit": "RGSS frames",
            "nominal_frame_rate": 40,
            "nominal_frame_duration_ms": 25,
            "authority": "RGSS1 default; mkxp.json has no active fixedFramerate override",
            "branching_note": "wait durations are exact per command; do not sum across branches",
        },
        "sequence_count": len(sequences),
        "visual_command_counts": dict(sorted(totals.items())),
        "excluded_command_counts": dict(sorted(excluded_totals.items())),
        "dialogue_contents_exported": False,
        "script_bodies_exported": False,
        "sequences": sequences,
    }, references


def common_event_timelines(source: Path) -> tuple[dict[str, Any], list[dict[str, str]]]:
    payload = load(source / "Data/CommonEvents.rxdata")
    events = []
    references = []
    for event_id, event in enumerate(payload):
        if not isinstance(event, RubyObject):
            continue
        timeline, refs, excluded = timeline_for_commands(ivar(event, "list", []) or [])
        if not timeline:
            continue
        for ref in refs:
            ref.update({"common_event_id": event_id})
        references.extend(refs)
        source_name = decode_text(ivar(event, "name", ""))
        events.append({
            "common_event_id": event_id,
            "source_name_sha256": sha256_bytes(source_name.encode()) if source_name else None,
            "trigger": int(ivar(event, "trigger", 0)),
            "timeline": timeline,
            "excluded_command_counts": dict(sorted(excluded.items())),
        })
    return {
        "schema_version": "1.0.0",
        "source_names_redacted": True,
        "dialogue_contents_exported": False,
        "script_bodies_exported": False,
        "event_count": len(events),
        "events": events,
    }, references


def gif_control_metadata(path: Path) -> tuple[list[int], int | None]:
    data = path.read_bytes()
    if data[:6] not in (b"GIF87a", b"GIF89a"):
        raise ValueError(f"not GIF: {path}")
    packed = data[10]
    position = 13
    if packed & 0x80:
        position += 3 * (2 ** ((packed & 0x07) + 1))
    pending_delay = 0
    delays = []
    loop_count = None
    while position < len(data):
        marker = data[position]
        position += 1
        if marker == 0x3B:
            break
        if marker == 0x21:
            label = data[position]
            position += 1
            if label == 0xF9:
                size = data[position]
                position += 1
                block = data[position : position + size]
                position += size + 1
                if len(block) >= 3:
                    pending_delay = struct.unpack("<H", block[1:3])[0]
                continue
            first_size = data[position]
            position += 1
            first = data[position : position + first_size]
            position += first_size
            chunks = bytearray()
            while data[position] != 0:
                size = data[position]
                position += 1
                chunks.extend(data[position : position + size])
                position += size
            position += 1
            if label == 0xFF and first.startswith(b"NETSCAPE") and len(chunks) >= 3 and chunks[0] == 1:
                loop_count = struct.unpack("<H", chunks[1:3])[0]
            continue
        if marker == 0x2C:
            descriptor = data[position : position + 9]
            position += 9
            if descriptor[8] & 0x80:
                position += 3 * (2 ** ((descriptor[8] & 0x07) + 1))
            position += 1
            while data[position] != 0:
                size = data[position]
                position += 1 + size
            position += 1
            delays.append(pending_delay)
            pending_delay = 0
            continue
        raise ValueError(f"unsupported GIF marker 0x{marker:02x} at {position-1}")
    return delays, loop_count


def extract_gif_frames(source_path: Path, destination: Path) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    delays, loop_count = gif_control_metadata(source_path)
    with tempfile.TemporaryDirectory() as temp:
        pattern = str(Path(temp) / "frame_%03d.png")
        subprocess.run(
            [
                "convert", str(source_path), "-coalesce", "-depth", "8",
                "-define", "png:color-type=6", pattern,
            ],
            check=True,
        )
        generated = sorted(Path(temp).glob("frame_*.png"))
        if len(generated) != len(delays):
            raise ValueError("ImageMagick frame count differs from GIF control blocks")
        frames = []
        contact_images = []
        for index, generated_path in enumerate(generated):
            image = load_png(generated_path)
            frame_path = destination / "layers/layer_00" / f"frame_{index:03d}.png"
            save_png(image, frame_path)
            frames.append({
                "index": index,
                "file": frame_path.relative_to(destination).as_posix(),
                "duration_ms": delays[index] * 10,
                "sha256": sha256_file(frame_path),
            })
            contact_images.append(image)
    columns = min(12, len(contact_images))
    rows = (len(contact_images) + columns - 1) // columns
    cell_width = max(image.width for image in contact_images)
    cell_height = max(image.height for image in contact_images)
    width = columns * cell_width
    height = rows * cell_height
    from png_rgba import RGBAImage
    contact = RGBAImage.empty(width, height)
    for index, image in enumerate(contact_images):
        contact.alpha_over(image, (index % columns) * cell_width, (index // columns) * cell_height)
    contact_path = destination / "contact_sheet.png"
    save_png(contact, contact_path)
    return frames, {
        "loop": loop_count == 0,
        "loop_count": loop_count,
        "contact_sheet": contact_path,
        "width_px": contact.width,
        "height_px": contact.height,
    }


def build(source: Path, inventory_root: Path) -> dict[str, Any]:
    source = source.resolve()
    inventory_root = inventory_root.resolve()
    output = inventory_root / "vfx"
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    all_references = []
    timeline_rows = []
    timeline_counts = Counter()
    excluded_timeline_counts = Counter()
    script_visual_call_count = 0
    map_jobs = []
    data_root = source / "Data"
    for zone_path in sorted((inventory_root / "metadata/zones").glob("*.json")):
        zone = load_json(zone_path)
        map_jobs.append((zone["source_map_id"], None, data_root / f"Map{zone['source_map_id']:03d}.rxdata"))
        for variant in zone["variants"]:
            if not variant["byte_identical_to_canonical"]:
                map_jobs.append((zone["source_map_id"], variant["source_label"], source / variant["source_path"].removeprefix("Relict/Relict V1.2/Relict/")))
    for map_id, variant, map_path in map_jobs:
        map_obj = load(map_path)
        payload, references = map_timeline(map_id, map_obj, variant)
        prefix = f"map_{map_id:03d}" + (f"_variant_{slug(variant)}" if variant else "")
        path = output / "timelines/maps" / f"{prefix}.json"
        write_json(path, payload)
        all_references.extend(references)
        timeline_counts.update(payload["visual_command_counts"])
        excluded_timeline_counts.update(payload["excluded_command_counts"])
        script_visual_call_count += sum(
            len(command["parameters"]["calls"])
            for sequence in payload["sequences"]
            for command in sequence["timeline"]
            if command["category"] == "script_visual_block"
        )
        timeline_rows.append({
            "map_id": map_id,
            "variant": variant,
            "file": path.relative_to(inventory_root).as_posix(),
            "sha256": sha256_file(path),
            "sequence_count": payload["sequence_count"],
        })
    common_payload, common_refs = common_event_timelines(source)
    for event in common_payload["events"]:
        excluded_timeline_counts.update(event["excluded_command_counts"])
        for command in event["timeline"]:
            timeline_counts[command["category"]] += 1
            if command["category"] == "script_visual_block":
                script_visual_call_count += len(command["parameters"]["calls"])
    common_path = output / "timelines/common_events.json"
    write_json(common_path, common_payload)
    all_references.extend(common_refs)

    reference_usage: dict[tuple[str, str, str], list[dict[str, Any]]] = defaultdict(list)
    for reference in all_references:
        key = (reference["kind"], reference["directory"], reference["name"])
        context = {key: value for key, value in reference.items() if key not in ("kind", "directory", "name")}
        reference_usage[key].append(context)

    environment_assets = []
    picture_reviews = []
    excluded_assets = []
    animated_environment_count = 0
    image_magick = subprocess.check_output(["convert", "-version"], text=True).splitlines()[0]
    for (kind, directory, name), contexts in sorted(reference_usage.items()):
        source_path = resolve_asset(source, directory, name)
        source_hash = sha256_file(source_path) if source_path else None
        if kind.endswith("_REVIEW"):
            decision = PICTURE_REVIEW_DECISIONS.get(source_hash)
            if decision in ("EXCLUDED_CHARACTER", "EXCLUDED_UI"):
                excluded_assets.append({
                    "kind": kind,
                    "source_identity_sha256": sha256_bytes(name.encode()),
                    "source_sha256": source_hash,
                    "contexts": contexts,
                    "pixels_exported": False,
                    "status": decision,
                })
                continue
            if decision == "INCLUDED_ENVIRONMENTAL":
                kind = "ENVIRONMENT_OVERLAY"
            else:
                picture_reviews.append({
                    "kind": kind,
                    "source_identity_sha256": sha256_bytes(name.encode()),
                    "resolved": source_path is not None,
                    "source_sha256": source_hash,
                    "size_bytes": source_path.stat().st_size if source_path else None,
                    "contexts": contexts,
                    "pixels_exported": False,
                    "status": "REVIEW_REQUIRED",
                })
                continue
        if source_path is None:
            environment_assets.append({
                "kind": kind, "name": name, "resolved": False,
                "contexts": contexts, "status": "UNSUPPORTED",
            })
            continue
        asset_id = f"relict_{kind.casefold()}_{slug(name)}_{source_hash[:12]}"
        if source_path.suffix.casefold() == ".gif":
            animated_environment_count += 1
            destination = output / "animations" / asset_id
            frames, gif = extract_gif_frames(source_path, destination)
            metadata = {
                "schema_version": "1.0.0",
                "animation_id": asset_id,
                "game_id": "relict",
                "status": "SOURCE_DOCUMENTED",
                "frame_count": len(frames),
                "loop": gif["loop"],
                "loop_start": 0 if gif["loop"] else None,
                "timing_authority": "SOURCE_EXACT",
                "timing_provenance": {
                    "source_path": source_path.relative_to(source).as_posix(),
                    "sha256": source_hash,
                    "method": "GIF_GRAPHIC_CONTROL_EXTENSION",
                    "constant": None,
                    "units": "1/100 second",
                    "static_audit_only": False,
                },
                "source_frame_layout": "GIF_COALESCED_LOGICAL_SCREEN",
                "layers": [{"layer_id": "layer_00", "order": 0, "blend_mode": "SOURCE_ALPHA", "frames": frames}],
                "contexts": contexts,
                "dependencies": [],
                "pmdo_dtef_candidate": False,
                "provenance": {
                    "repository": "https://github.com/meromoonmeri/BIBLIOTHEQUE",
                    "commit": "6963878956ec4c53833c03f26aa6a9aafd17800f",
                    "source_path": source_path.relative_to(source.parents[2]).as_posix(),
                    "sha256": source_hash,
                    "size_bytes": source_path.stat().st_size,
                    "source_format": "GIF89a",
                    "extraction_method": "ImageMagick coalesce followed by deterministic RGBA PNG normalization",
                    "license_status": "UNKNOWN",
                },
                "contact_sheet": {
                    "file": gif["contact_sheet"].relative_to(destination).as_posix(),
                    "sha256": sha256_file(gif["contact_sheet"]),
                    "width_px": gif["width_px"],
                    "height_px": gif["height_px"],
                },
            }
            metadata_path = destination / "metadata.json"
            write_json(metadata_path, metadata)
            output_ref = metadata_path.relative_to(inventory_root).as_posix()
        else:
            image = load_png(source_path)
            destination = output / "assets" / kind.casefold() / f"{asset_id}.png"
            save_png(image, destination)
            output_ref = destination.relative_to(inventory_root).as_posix()
        environment_assets.append({
            "asset_id": asset_id,
            "kind": kind,
            "name": name,
            "resolved": True,
            "source_path": source_path.relative_to(source).as_posix(),
            "source_sha256": source_hash,
            "contexts": contexts,
            "output": output_ref,
            "output_sha256": sha256_file(inventory_root / output_ref),
            "status": "SOURCE_DOCUMENTED",
        })
    manifest = {
        "schema_version": "1.0.0",
        "result": "ENVIRONMENTAL_VFX_AUDIT_PASS",
        "map_timeline_count": len(timeline_rows),
        "common_event_timeline_count": common_payload["event_count"],
        "visual_command_counts": dict(sorted(timeline_counts.items())),
        "excluded_command_counts": dict(sorted(excluded_timeline_counts.items())),
        "redacted_script_command_count": (
            excluded_timeline_counts.get("script_commands_redacted", 0)
            + excluded_timeline_counts.get("script_continuation_commands_redacted", 0)
        ),
        "script_visual_block_count": timeline_counts.get("script_visual_block", 0),
        "script_visual_call_count": script_visual_call_count,
        "static_script_visual_audit_required_count": timeline_counts.get(
            "script_visual_candidate_review", 0
        ),
        "environment_asset_count": len(environment_assets),
        "animated_environment_count": animated_environment_count,
        "picture_transition_review_count": len(picture_reviews),
        "manual_picture_decision_count": len(excluded_assets) + sum(
            row["kind"] == "ENVIRONMENT_OVERLAY" for row in environment_assets
        ),
        "excluded_picture_count": len(excluded_assets),
        "included_environmental_picture_count": sum(
            row["kind"] == "ENVIRONMENT_OVERLAY" for row in environment_assets
        ),
        "unresolved_environment_count": sum(not row["resolved"] for row in environment_assets),
        "dialogue_contents_exported": False,
        "script_bodies_exported": False,
        "event_timing_authority": mkxp_timing_authority(source),
        "image_magick_authority": {
            "version": image_magick,
            "executable_sha256": sha256_file(Path(shutil.which("convert"))),
        },
        "timelines": timeline_rows,
        "common_events": {
            "file": common_path.relative_to(inventory_root).as_posix(),
            "sha256": sha256_file(common_path),
        },
        "environment_assets": environment_assets,
        "excluded_assets": excluded_assets,
        "review_queue": picture_reviews,
    }
    write_json(output / "manifest.json", manifest)
    (output / "README.md").write_text(
        "# VFX et timelines environnementales Relict\n\n"
        "Les commandes visuelles, attentes, routes forcées, branches, fogs, panoramas "
        "et effets de carte sont conservés sans dialogue ni corps de script. Les neuf "
        "Pictures utilisées ont une décision verrouillée par hash : cinq overlays "
        "environnementaux inclus et quatre images casting/UI exclues sans export de pixels.\n",
        encoding="utf-8",
    )
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--inventory-root", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = build(args.source, args.inventory_root)
    print(json.dumps({
        key: value for key, value in result.items()
        if key not in ("timelines", "environment_assets", "excluded_assets", "review_queue")
    }, sort_keys=True))
    return 0 if result["unresolved_environment_count"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
