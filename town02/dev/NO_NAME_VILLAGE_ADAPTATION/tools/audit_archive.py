#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import re
import stat
import struct
import zipfile
from collections import Counter
from pathlib import Path, PurePosixPath

EXPECTED_SHA256 = "a3c99eb1598167a9c01f57299f1a7003a5580d24cbce6504ec0e2343a9e76002"
EXPECTED_SIZE = 287481958


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def safe_name(name: str) -> bool:
    path = PurePosixPath(name.replace("\\", "/"))
    return not path.is_absolute() and ".." not in path.parts and not re.match(r"^[A-Za-z]:", name)


def png_size(prefix: bytes) -> list[int] | None:
    if len(prefix) >= 24 and prefix[:8] == b"\x89PNG\r\n\x1a\n":
        return list(struct.unpack(">II", prefix[16:24]))
    return None


def engine_evidence(names: list[str]) -> list[dict[str, object]]:
    lower = {name.casefold() for name in names}
    evidence = []
    rules = (
        ("RPG_MAKER_XP_RGSS", ["game.rxproj", "game.ini"], [r"^data/.+\.rxdata$", r"rgss\d+.*\.dll$"]),
        ("RPG_MAKER_VX", ["game.rvproj"], [r"^data/.+\.rvdata$"]),
        ("RPG_MAKER_VX_ACE", ["game.rvproj2"], [r"^data/.+\.rvdata2$"]),
        ("RPG_MAKER_MV_MZ", ["package.json"], [r"(^|/)www/data/.+\.json$", r"(^|/)js/rpg_.*\.js$"]),
        ("GODOT", ["project.godot"], [r"\.tscn$", r"\.tres$"]),
        ("UNITY", [], [r"_data/globalgamemanagers$", r"_data/resources\.assets$"]),
    )
    for engine, exact, patterns in rules:
        exact_hits = [name for name in names if PurePosixPath(name).name.casefold() in exact]
        regex_hits = [name for name in names if any(re.search(pattern, name.casefold()) for pattern in patterns)]
        if exact_hits or regex_hits:
            score = min(1.0, len(exact_hits) * .45 + min(5, len(regex_hits)) * .11)
            evidence.append({"engine": engine, "confidence": round(score, 3), "exact_markers": exact_hits[:20], "format_markers": regex_hits[:40]})
    return sorted(evidence, key=lambda row: (-row["confidence"], row["engine"]))


def audit(archive_path: Path, output_path: Path) -> dict[str, object]:
    actual_size = archive_path.stat().st_size
    actual_sha = sha256_file(archive_path)
    if actual_size != EXPECTED_SIZE or actual_sha != EXPECTED_SHA256:
        raise ValueError(f"archive authority mismatch size={actual_size} sha256={actual_sha}")
    entries = []
    extensions = Counter()
    roots = Counter()
    suspicious = []
    seasonal = []
    temporal = []
    maps = []
    scripts = []
    images = []
    nested = []
    with zipfile.ZipFile(archive_path) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"ZIP CRC failure: {bad}")
        for info in archive.infolist():
            normalized = info.filename.replace("\\", "/")
            path = PurePosixPath(normalized)
            mode = (info.external_attr >> 16) & 0xFFFF
            reasons = []
            if not safe_name(normalized): reasons.append("path_traversal_or_absolute")
            if stat.S_ISLNK(mode): reasons.append("symlink")
            if info.flag_bits & 1: reasons.append("encrypted")
            if reasons: suspicious.append({"path": normalized, "reasons": reasons})
            extension = path.suffix.casefold() or "<none>"
            extensions[extension] += 1
            if path.parts: roots[path.parts[0]] += 1
            prefix = b""
            if not info.is_dir() and info.file_size:
                with archive.open(info) as stream: prefix = stream.read(64)
            dimensions = png_size(prefix)
            row = {
                "path": normalized, "compressed_bytes": info.compress_size,
                "uncompressed_bytes": info.file_size, "crc32": f"{info.CRC:08x}",
                "extension": extension, "is_directory": info.is_dir(),
                "png_dimensions": dimensions,
            }
            entries.append(row)
            text = normalized.casefold()
            if re.search(r"spring|summer|autumn|fall|winter|season|printemps|été|ete|automne|hiver", text): seasonal.append(normalized)
            if re.search(r"day|night|dawn|dusk|morning|evening|jour|nuit|matin|soir", text): temporal.append(normalized)
            if re.search(r"(^|/)(map|maps|data|world|town|village)", text) or re.search(r"map\d+", text): maps.append(normalized)
            if extension in {".rb", ".lua", ".js", ".json", ".txt", ".ini", ".rxdata", ".rvdata", ".rvdata2"}: scripts.append(normalized)
            if extension in {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".webp"}: images.append(normalized)
            if extension in {".zip", ".7z", ".rar", ".tar", ".gz"}: nested.append(normalized)
    names = [row["path"] for row in entries]
    report = {
        "schema": "bibliotheque.no-name-village.source-audit.v1",
        "status": "SOURCE_ARCHIVE_AUDITED" if not suspicious else "BLOCKED_UNSAFE_ARCHIVE",
        "source": {
            "repository": "meromoonmeri/BIBLIOTHEQUE", "ref": "main",
            "commit": "7a213cb5f3c46840a14ddcd8e681206f34cd5a9c",
            "file": "No.Name.Village.zip", "git_blob_sha": "299a08687e8b67cf270d5a36714ffd2ecbc50ff7",
            "lfs_oid_sha256": EXPECTED_SHA256, "size_bytes": actual_size, "verified_sha256": actual_sha,
        },
        "zip": {
            "entry_count": len(entries), "file_count": sum(not row["is_directory"] for row in entries),
            "directory_count": sum(row["is_directory"] for row in entries),
            "compressed_payload_bytes": sum(row["compressed_bytes"] for row in entries),
            "uncompressed_payload_bytes": sum(row["uncompressed_bytes"] for row in entries),
            "unsafe_entries": suspicious, "nested_archives": nested,
        },
        "inventory": {
            "root_counts": dict(sorted(roots.items())), "extension_counts": dict(sorted(extensions.items())),
            "engine_evidence": engine_evidence(names), "seasonal_path_candidates": seasonal,
            "day_night_path_candidates": temporal, "map_data_candidates": maps,
            "script_data_candidates": scripts, "image_count": len(images), "image_paths": images,
        },
        "entries": entries,
        "next_gate": "ENGINE_AND_SEASON_LOGIC_AUDIT" if not suspicious else "STOP_UNSAFE_ARCHIVE",
        "source_executed": False,
    }
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("archive", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    report = audit(args.archive, args.output)
    print(json.dumps({
        "status": report["status"], "entries": report["zip"]["entry_count"],
        "engine_evidence": report["inventory"]["engine_evidence"],
        "seasonal_candidates": len(report["inventory"]["seasonal_path_candidates"]),
    }, ensure_ascii=False))
    return 0 if report["status"] == "SOURCE_ARCHIVE_AUDITED" else 2


if __name__ == "__main__":
    raise SystemExit(main())
