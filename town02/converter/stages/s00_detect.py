"""Stage 0 — detect and authenticate the ROM.

Refuses any ROM whose size or SHA-256 does not match the expected PMD
Red EU multilingual dump. Never keeps the ROM bytes in memory beyond
what is strictly needed to compute the hash. Never copies the ROM out
of rom_input/.
"""
from __future__ import annotations

import hashlib
from pathlib import Path

from converter.stages.context import (
    Context,
    ROM_EXPECTED_HASH,
    ROM_EXPECTED_SIZE,
    StageResult,
    StageStatus,
)


STAGE = "s00_detect"


def _candidate_rom_files(rom_input_dir: Path) -> list[Path]:
    """Any file the user drops in rom_input/ that could be the ROM.

    We accept .gba / .rom / .bin extensions (case-insensitive) and, as a
    fallback, any file whose byte size matches ROM_EXPECTED_SIZE.
    """
    if not rom_input_dir.is_dir():
        return []
    accepted_ext = {".gba", ".rom", ".bin"}
    out: list[Path] = []
    for entry in sorted(rom_input_dir.iterdir()):
        if not entry.is_file():
            continue
        if entry.name.startswith("."):
            continue
        if entry.name.lower() == "readme.txt":
            continue
        if entry.suffix.lower() in accepted_ext:
            out.append(entry)
        elif entry.stat().st_size == ROM_EXPECTED_SIZE:
            out.append(entry)
    return out


def _sha256_of_file(path: Path, chunk: int = 1 << 20) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        while True:
            block = fh.read(chunk)
            if not block:
                break
            h.update(block)
    return h.hexdigest()


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)

    candidates = _candidate_rom_files(ctx.rom_input_dir)
    result.metrics["candidates_seen"] = len(candidates)

    if not candidates:
        result.status = StageStatus.SKIPPED
        result.reason = (
            f"No ROM in {ctx.rom_input_dir}. Drop your legal PMD Red EU "
            f"copy (32 MiB, sha256={ROM_EXPECTED_HASH[:12]}...) there. "
            f"The file is git-ignored and never leaves your machine."
        )
        return result

    # We only pick a ROM whose SIZE matches, then verify hash. This avoids
    # spending time hashing a wrong file.
    sized = [p for p in candidates if p.stat().st_size == ROM_EXPECTED_SIZE]
    if not sized:
        result.status = StageStatus.FAIL
        result.reason = (
            f"None of {len(candidates)} candidate file(s) in "
            f"{ctx.rom_input_dir} has the expected size "
            f"({ROM_EXPECTED_SIZE} bytes). Found sizes: "
            f"{[p.stat().st_size for p in candidates]}."
        )
        return result

    # Compute hashes deterministically in filename order and stop on the
    # first correct match. This makes the pipeline pick the right ROM
    # even if the user has an extra file in there by mistake.
    accepted: Path | None = None
    hashes: list[tuple[str, str]] = []
    for cand in sorted(sized, key=lambda p: p.name):
        h = _sha256_of_file(cand)
        hashes.append((cand.name, h))
        if h == ROM_EXPECTED_HASH:
            accepted = cand
            break

    result.metrics["candidates_hashed"] = len(hashes)
    result.metrics["hashes"] = [
        {"name": n, "sha256_head": h[:16]} for (n, h) in hashes
    ]

    if accepted is None:
        result.status = StageStatus.FAIL
        result.reason = (
            f"No candidate matches the expected ROM hash. "
            f"Expected sha256={ROM_EXPECTED_HASH}. "
            f"Saw {[(n, h[:16]) for (n, h) in hashes]}. "
            f"The converter only accepts the PMD Red EU multilingual dump."
        )
        return result

    ctx.rom_path = accepted
    ctx.rom_actual_hash = ROM_EXPECTED_HASH
    result.status = StageStatus.PASS
    result.reason = (
        f"Authenticated ROM: {accepted.name} "
        f"(sha256={ROM_EXPECTED_HASH[:16]}..., {ROM_EXPECTED_SIZE} bytes)."
    )
    result.metrics["rom_path_rel"] = str(accepted.relative_to(ctx.repo_root))

    # Persist a minimal detection record (no ROM bytes, just its fingerprint).
    ctx.write_json(
        ctx.stage_output_dir(STAGE) / "detect.json",
        {
            "rom_filename": accepted.name,
            "rom_size_bytes": ROM_EXPECTED_SIZE,
            "rom_sha256": ROM_EXPECTED_HASH,
        },
    )
    result.artefacts.append(str(ctx.stage_output_dir(STAGE) / "detect.json"))
    return result
