#!/usr/bin/env python3
"""Package converted NNV zone Grounds so they fit in Git without LFS.

Why: a converted 4992 px room produces a 33-72 MB `.rsground`, over GitHub's
50 MB advisory limit. Git LFS is not usable from this sandbox: the LFS batch
API answers, but every storage host it hands back
(`github-cloud.s3.amazonaws.com`, `github-cloud.githubusercontent.com`,
`release-assets.githubusercontent.com`) has its TLS handshake reset, and the
git-lfs client itself cannot be installed (no root, release assets blocked).

Rather than leave the zones out of version control - where a sandbox reset
already destroyed them once - each Ground is stored gzip-compressed. The
`.rsground` JSON compresses about 26x (33 MB -> 1.3 MB), far below the limit,
and the round trip is byte-identical, which this tool verifies per file.

Layout produced:
    <zone>/Data/Ground/<name>.rsground.gz   tracked, byte-exact
    <zone>/Content/Tile/<name>.tile         tracked as-is when under the limit
    zone-package.json                       manifest with both hashes

Restore with `--restore`, which re-expands every `.gz` and checks the hash.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import shutil
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
ZONES = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/zones"
LIMIT = 50 * 1024 * 1024


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def pack(source: Path, destination: Path) -> dict:
    """gzip a Ground and prove the round trip is lossless."""
    raw_sha = sha256(source)
    raw_size = source.stat().st_size
    destination.parent.mkdir(parents=True, exist_ok=True)
    with source.open("rb") as incoming, gzip.open(destination, "wb", compresslevel=6) as outgoing:
        shutil.copyfileobj(incoming, outgoing, length=1 << 20)

    verify = hashlib.sha256()
    with gzip.open(destination, "rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            verify.update(chunk)
    if verify.hexdigest() != raw_sha:
        raise SystemExit(f"ABORT: {source.name} round trip is not byte-identical")

    packed_size = destination.stat().st_size
    if packed_size >= LIMIT:
        raise SystemExit(f"ABORT: {destination.name} is {packed_size} bytes, still over the limit")
    return {
        "source_name": source.name,
        "packed_name": destination.name,
        "raw_bytes": raw_size,
        "packed_bytes": packed_size,
        "ratio": round(raw_size / packed_size, 1),
        "sha256_raw": raw_sha,
        "sha256_packed": sha256(destination),
        "lossless_verified": True,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--restore", action="store_true", help="expand .gz Grounds back in place")
    arguments = parser.parse_args()

    if not ZONES.is_dir():
        raise SystemExit(f"no zones directory at {ZONES}")

    if arguments.restore:
        restored = 0
        for packed in sorted(ZONES.rglob("*.rsground.gz")):
            target = packed.with_suffix("")
            with gzip.open(packed, "rb") as incoming, target.open("wb") as outgoing:
                shutil.copyfileobj(incoming, outgoing, length=1 << 20)
            manifest = json.loads((packed.parents[2] / "zone-package.json").read_text())
            expected = next(g["sha256_raw"] for g in manifest["grounds"]
                            if g["packed_name"] == packed.name)
            if sha256(target) != expected:
                raise SystemExit(f"ABORT: restored {target.name} does not match its recorded hash")
            restored += 1
            print(f"  restored {target.relative_to(ZONES)}")
        print(f"restored {restored} Grounds, all hash-verified")
        return 0

    total_raw = total_packed = 0
    for zone in sorted(p for p in ZONES.iterdir() if p.is_dir()):
        grounds = []
        for source in sorted((zone / "Data/Ground").glob("*.rsground")):
            entry = pack(source, source.with_suffix(".rsground.gz"))
            grounds.append(entry)
            total_raw += entry["raw_bytes"]
            total_packed += entry["packed_bytes"]
            source.unlink()
            print(f"  {zone.name}/{entry['source_name']}: "
                  f"{entry['raw_bytes']/1e6:.1f} MB -> {entry['packed_bytes']/1e6:.1f} MB "
                  f"({entry['ratio']}x)")
        oversized = [p.name for p in zone.rglob("*") if p.is_file() and p.stat().st_size >= LIMIT]
        (zone / "zone-package.json").write_text(json.dumps({
            "schema": "new-era.nnv-zone-package.v1",
            "zone": zone.name,
            "reason": "Git LFS unusable from this sandbox; every LFS storage host is TLS-blocked",
            "compression": "gzip level 6, byte-identical round trip verified per file",
            "grounds": grounds,
            "files_still_over_limit": oversized,
        }, indent=2, sort_keys=True) + "\n")
        if oversized:
            print(f"  WARNING {zone.name}: still over the limit: {oversized}")

    if total_packed:
        print(f"\ntotal {total_raw/1e6:.0f} MB -> {total_packed/1e6:.1f} MB "
              f"({total_raw/total_packed:.1f}x), all round trips verified lossless")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
