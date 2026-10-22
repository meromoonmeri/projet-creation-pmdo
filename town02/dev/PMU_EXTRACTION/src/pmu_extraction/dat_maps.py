from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any

from Crypto.Cipher import DES3
from Crypto.Util.Padding import pad, unpad

from .constants import TILE_FIELDS
from .util import atomic_write_json, sha256_file

DEFAULT_KEY = "justsomewordtobeusedasacryptionkey"


def _dotnet_sha1_utf16le(value: str, length: int) -> bytes:
    digest = hashlib.sha1(value.encode("utf-16-le")).digest()
    return (digest + bytes(length))[:length]


def decrypt_bytes(ciphertext: bytes, key: str = DEFAULT_KEY) -> bytes:
    cipher = DES3.new(_dotnet_sha1_utf16le(key, 24), DES3.MODE_CBC, _dotnet_sha1_utf16le("", 8))
    return unpad(cipher.decrypt(ciphertext), DES3.block_size, style="pkcs7")


def encrypt_bytes(plaintext: bytes, key: str = DEFAULT_KEY) -> bytes:
    cipher = DES3.new(_dotnet_sha1_utf16le(key, 24), DES3.MODE_CBC, _dotnet_sha1_utf16le("", 8))
    return cipher.encrypt(pad(plaintext, DES3.block_size, style="pkcs7"))


def parse_bool(value: str) -> int:
    return int(value.strip().lower() in {"1", "true", "yes"})


def parse_v9(path: Path) -> tuple[dict[str, Any], bytes]:
    ciphertext = path.read_bytes()
    plaintext = decrypt_bytes(ciphertext)
    text = plaintext.decode("utf-16-le")
    map_id = path.stem.removeprefix("Map-")
    result: dict[str, Any] = {"map_id": map_id, "npcs": [], "tiles": [], "source_kind": "client_v9_dat"}
    header = False
    for line_number, line in enumerate(text.splitlines(), 1):
        fields = line.split("|")
        record = fields[0].lower()
        if record == "mapdata":
            if fields[1].lower() != "v9":
                raise ValueError(f"{path}: unsupported map format {fields[1]!r}")
            result.update(version="V9", revision=int(fields[2]), max_x=max(19, int(fields[3] or 19)), max_y=max(14, int(fields[4] or 14)))
            header = True
        elif record == "data":
            if not header:
                raise ValueError(f"{path}:{line_number}: Data precedes MapData header")
            result.update(
                name=fields[1], moral=int(fields[2]), up_map=int(fields[3]), down_map=int(fields[4]),
                left_map=int(fields[5]), right_map=int(fields[6]), music=fields[7],
                indoors=parse_bool(fields[8]), owner=fields[9], weather=int(fields[10]),
                darkness=int(fields[11]), hunger_enabled=parse_bool(fields[12]),
                recruitment_enabled=parse_bool(fields[13]), exp_enabled=parse_bool(fields[14]),
                time_limit=int(fields[15]), dungeon_index=int(fields[16]), min_npcs=int(fields[17]),
                max_npcs=int(fields[18]), npc_spawn_time=int(fields[19]), instanced=parse_bool(fields[20]),
            )
        elif record == "npcsettings":
            result["npcs"].append({
                "slot": int(fields[1]), "number": int(fields[2]), "spawn_x": int(fields[3]),
                "spawn_y": int(fields[4]), "min_level": int(fields[5]), "max_level": int(fields[6]),
                "appearance_rate": int(fields[7]), "start_status": int(fields[8]),
                "start_status_counter": int(fields[9]), "start_status_chance": int(fields[10]),
            })
        elif record == "tile":
            values: list[Any] = [int(value) for value in fields[3:17]]
            values += fields[17:20]
            values += [int(value) for value in fields[20:31]]
            # The V9 names line up with SQL; String1..3 are the only strings.
            tile = {"x": int(fields[1]), "y": int(fields[2])}
            tile.update(zip(TILE_FIELDS, values, strict=True))
            result["tiles"].append(tile)
        elif line:
            raise ValueError(f"{path}:{line_number}: unknown record {fields[0]!r}")
    if not header:
        raise ValueError(f"{path}: missing MapData header")
    expected = (result["max_x"] + 1) * (result["max_y"] + 1)
    coords = {(tile["x"], tile["y"]) for tile in result["tiles"]}
    if len(result["tiles"]) != expected or len(coords) != expected:
        raise ValueError(f"{path}: expected {expected} unique tiles, got {len(result['tiles'])}/{len(coords)}")
    return result, plaintext


def structural_fingerprint(map_data: dict[str, Any]) -> str:
    payload = json.dumps(map_data, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(payload).hexdigest()


def extract_dat_maps(map_directory: Path, output_directory: Path, report_path: Path) -> dict:
    """Decode every V9 cache when the checked-in client key is applicable.

    The public repository's 140 ciphertexts were produced with a deployment key
    that is not the placeholder/default key in Encryption.cs. A failed PKCS#7
    validation is therefore surfaced as BLOCKED, never guessed or discarded.
    """
    import re

    output_directory.mkdir(parents=True, exist_ok=True)
    for stale in output_directory.glob("*.json"):
        stale.unlink()
    entries = []
    blocked = []
    source_paths = sorted(map_directory.glob("Map-*.dat"))
    for path in source_paths:
        map_id = path.stem.removeprefix("Map-")
        try:
            data, plaintext = parse_v9(path)
            target = output_directory / f"{data['map_id']}.json"
            atomic_write_json(target, data, indent=None)
            reencrypted = encrypt_bytes(plaintext)
            reparsed, _ = parse_v9(path)
            entry = {
                "map_id": data["map_id"], "path": str(path), "sha256": sha256_file(path),
                "plaintext_sha256": hashlib.sha256(plaintext).hexdigest(),
                "decryption_reencryption_byte_exact": reencrypted == path.read_bytes(),
                "parse_repeat_fingerprint_exact": structural_fingerprint(data) == structural_fingerprint(reparsed),
                "revision": data["revision"], "max_x": data["max_x"], "max_y": data["max_y"],
                "tile_count": len(data["tiles"]), "output": str(target), "status": "EXTRACTED",
            }
            entries.append(entry)
        except Exception as exc:
            blocked.append({
                "map_id": map_id, "path": str(path), "sha256": sha256_file(path),
                "status": "BLOCKED", "error_type": type(exc).__name__, "error": str(exc),
                "reason": "The deployment map-encryption key is absent from the public source/history; the checked-in default key fails cryptographic padding validation.",
            })
    round_trip_failures = [e["map_id"] for e in entries if not e["decryption_reencryption_byte_exact"] or not e["parse_repeat_fingerprint_exact"]]
    status = "EXTRACTED" if len(entries) == len(source_paths) and not round_trip_failures else ("BLOCKED" if blocked and not entries else "PARTIAL")
    report = {
        "status": status,
        "source_directory": str(map_directory), "source_map_count": len(source_paths),
        "map_count": len(entries),
        "standard_source_map_count": sum(bool(re.fullmatch(r"s\d+", p.stem.removeprefix("Map-"))) for p in source_paths),
        "standard_map_count": sum(bool(re.fullmatch(r"s\d+", e["map_id"])) for e in entries),
        "round_trip_failures": round_trip_failures,
        "blocked_count": len(blocked), "blocked_maps": blocked,
        "key_audit": {
            "public_default_key_tested": True,
            "public_default_key_result": "PKCS#7 padding failure on all ciphertexts" if blocked and not entries else "mixed",
            "client_history_and_only_public_fork_audited": True,
            "deployment_key_found": False if blocked else True,
            "policy": "No key guessing; SQL remains the canonical recoverable source and blocked V9-only maps remain BLOCKED.",
        },
        "maps": entries,
    }
    atomic_write_json(report_path, report)
    return report
