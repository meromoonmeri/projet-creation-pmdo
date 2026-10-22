#!/usr/bin/env python3
from __future__ import annotations

import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "NO_NAME_VILLAGE_ADAPTATION/reports"


def png_dimensions(path: Path) -> tuple[int, int]:
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    assert data[12:16] == b"IHDR"
    return struct.unpack_from(">II", data, 16)


source = json.loads((REPORTS / "source-access.json").read_text())
assert source["status"] == "SOURCE_ACQUIRED_AND_OFFICIALLY_EXTRACTED"
assert source["transport_resolution"]["result"] == "PASS"
assert source["transport_resolution"]["assembled_data_win_sha256"] == "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"

official = json.loads((REPORTS / "official-extraction.json").read_text())
assert official["status"] == "OFFICIAL_MODEL_EXTRACTED_EXHAUSTIVELY"
assert official["resource_counts"]["Rooms"] == 98
assert official["resource_counts"]["GameObjects"] == 727
assert official["resource_counts"]["Sprites"] == 2775
assert official["resource_counts"]["Sounds"] == 388
assert official["raw_vm"]["code_entries"] == 2188
assert official["graphics"]["sprite_frames"] == 9084

room_index = json.loads((REPORTS / "room-index.json").read_text())
assert len(room_index) == 98
village = next(row for row in room_index if row["name"] == "rmvillage")
assert village["dimensions_px"] == [4992, 4992]
assert village["layer_count"] == 18
assert village["transition_count"] == 8
assert village["spawn_count"] == 6
assert village["house_instance_count"] == 4
assert village["solid_collision_instance_count"] == 259

season = json.loads((REPORTS / "season-system.json").read_text())
assert season["states"] == ["spring", "summer", "autumn", "winter"]
assert season["status"] == "SOURCE_PROVEN_EXACT_VM_LOGIC"
assert season["limitations"] == []

for name in ("spring", "summer", "autumn", "winter"):
    preview = REPORTS / "source-previews" / f"rmvillage-{name}.png"
    assert png_dimensions(preview) == (4992, 4992)

print("No Name Village source tests: OK")
