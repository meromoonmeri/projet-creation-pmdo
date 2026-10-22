#!/usr/bin/env python3
"""Package large runtime extraction results into deterministic tracked artifacts."""
from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
import shutil
import tarfile
from pathlib import Path


def gzip_copy(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    with source.open("rb") as incoming, target.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", compresslevel=9, mtime=0) as stream:
            while chunk := incoming.read(1 << 20):
                stream.write(chunk)


def archive_gml(source: Path, target: Path) -> None:
    with target.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", compresslevel=9, mtime=0) as zipped:
            with tarfile.open(fileobj=zipped, mode="w") as archive:
                for path in sorted(source.glob("*.gml")):
                    data = path.read_bytes()
                    info = tarfile.TarInfo(path.name)
                    info.size = len(data)
                    info.mtime = 0
                    info.mode = 0o644
                    info.uid = info.gid = 0
                    info.uname = info.gname = ""
                    archive.addfile(info, io.BytesIO(data))


def hash_frames(frames: Path, target: Path) -> None:
    result = {}
    for key, subdirectory in (("texture_page_items", "page-items"), ("collision_masks", "collision-masks")):
        rows = []
        for path in sorted((frames / subdirectory).glob("*.png")):
            data = path.read_bytes()
            rows.append({"file": path.name, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()})
        result[key] = rows
    value = {
        "schema": "no-name-village.frame-artifacts.v1",
        "counts": {key: len(rows) for key, rows in result.items()},
        **result,
    }
    payload = (json.dumps(value, sort_keys=True, separators=(",", ":")) + "\n").encode()
    with target.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", compresslevel=9, mtime=0) as stream:
            stream.write(payload)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--structured", type=Path, required=True)
    parser.add_argument("--gml", type=Path, required=True)
    parser.add_argument("--frames", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        shutil.rmtree(args.output)
    (args.output / "inventory").mkdir(parents=True)
    (args.output / "blobs").mkdir(parents=True)
    for source in sorted((args.structured / "inventory").glob("*.json")):
        gzip_copy(source, args.output / "inventory" / (source.name + ".gz"))
    for source in sorted((args.structured / "blobs").glob("*.bin")):
        shutil.copyfile(source, args.output / "blobs" / source.name)
    shutil.copyfile(args.structured / "manifest.json", args.output / "structured-manifest.json")
    archive_gml(args.gml / "CodeEntries", args.output / "decompiled-gml.tar.gz")
    gzip_copy(args.gml / "strings.txt", args.output / "strings.txt.gz")
    gzip_copy(args.frames / "manifest.json", args.output / "frames-manifest.json.gz")
    hash_frames(args.frames, args.output / "frame-artifacts.json.gz")
    print(json.dumps({"output": str(args.output), "inventories": len(list((args.output / 'inventory').glob('*.gz'))), "blobs": len(list((args.output / 'blobs').glob('*.bin')))}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
