#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

EXPECTED_SHA256 = "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
EXPECTED_SIZE = 301037316


def assemble(source: Path, output: Path) -> str:
    parts = sorted(source.glob("data.win.part-*"))
    if not parts:
        raise FileNotFoundError(f"no ordinary Git chunks under {source}")
    output.parent.mkdir(parents=True, exist_ok=True)
    digest = hashlib.sha256()
    size = 0
    temporary = output.with_suffix(output.suffix + ".tmp")
    with temporary.open("wb") as target:
        for part in parts:
            with part.open("rb") as stream:
                for chunk in iter(lambda: stream.read(1 << 20), b""):
                    target.write(chunk); digest.update(chunk); size += len(chunk)
    actual = digest.hexdigest()
    if size != EXPECTED_SIZE or actual != EXPECTED_SHA256:
        temporary.unlink(missing_ok=True)
        raise ValueError(f"data.win authority mismatch size={size} sha256={actual}")
    temporary.replace(output)
    return actual


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    digest = assemble(args.source, args.output)
    print(f"DATA_WIN_ASSEMBLY_PASS sha256={digest} bytes={EXPECTED_SIZE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
