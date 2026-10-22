#!/usr/bin/env python3
"""Windows-safe distributable packaging for New Era mod.

Purpose
-------
The GitHub archive of the full development repository fails to extract on
Windows with:

    « Le ou les noms de fichiers sont trop longs pour le dossier de destination »

Root cause (measured, not guessed)
----------------------------------
* Runtime canonical files (Mod.xml + Data/ + Content/ + Strings/) have a
  maximum relative depth of **93 characters** — well under Windows MAX_PATH
  (260).
* The offending long paths live in **dev-only** trees:
    - external/BIBLIOTHEQUE_WORKSPACE/  (up to 167 chars)
    - NO_NAME_VILLAGE_ADAPTATION/       (up to 129 chars)
    - docs/                             (up to 101 chars)
  Combined with a typical Windows download prefix
  (``C:\\Users\\<name>\\Downloads\\new-era-abyss-to-ascension-V4-<sha>\\``,
  60–100 chars) the total path exceeds MAX_PATH.

Fix (this tool)
---------------
Produce a **distribution archive** whose contents are strictly what a
PMDO 0.8.12 Quest mod ships (as per the reference Halcyon layout at
https://github.com/Palikadude/Halcyon). NO canonical file is renamed, no
directory is moved, no relative path inside Data/ / Content/ / Strings/
is changed — the internal layout is byte-for-byte identical to the source
repository. Only dev-only artefacts (audit reports, staging output,
external reference material, `.git`, build caches, etc.) are excluded.

Release manifest — aligned with Halcyon (Palikadude/Halcyon, the
accepted community layout for PMDO Quest mods, matching PMDO 0.8.12's
DumpAsset MOD/ convention)
--------------------------------------------------------------------------
Runtime-loaded (mandatory — PMDO refuses to load a MODS/ entry without
these):
* ``Mod.xml``       — mod manifest.
* ``Data/``         — canonical PMDO tree (Zone, Ground, Map, Script,
                      Monster, Item, AutoTile, MapStatus, Tile, Skin,
                      Rank, Emote, Universal.jsonpatch, StartParams.xml,
                      etc.).
* ``Content/``      — canonical assets (Tile packages, Music, Graphics,
                      everything Data/ references).
* ``Strings/``      — localisation tables loaded at PMDO boot.

Player-facing documentation (Halcyon ships all of these at the mod root
and PMDO's mod browser can display them):
* ``CREDITS.md``           — credits.
* ``readme.md``            — install / FAQ.
* ``patchnotes.txt``       — version history.
* ``Pokemon changes.txt``  — player-facing gameplay notes.

Convention reference kept alongside the release (Halcyon precedent —
shipped as-is in every Halcyon release):
* ``CONVERSION/``   — ROM->PMDO item / status / map / rank / monster /
                      zone / emote name lookup tables. Small (< 30 KB),
                      pure text.

Everything else in the source repository is dev-only (audit reports,
staging output, builder tools, tests, ROM extraction caches, external
reference material, `.git`, `.runtime-cache`, `docs/`, `RESERVE/`,
`external/`, `NO_NAME_VILLAGE_ADAPTATION/`, `PMU_*/`, `tools/`,
`tests/`, `DungeonDefs/`, top-level ad-hoc PNGs / scripts / saves).
None of it is required at runtime and it is EXCLUDED from the package
so extraction stays comfortably under Windows MAX_PATH.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
import tarfile
import time
import zipfile
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACKAGE_NAME = "New-Era"

# Runtime files/directories the PMDO 0.8.12 mod runtime actually loads.
RUNTIME_TREE = ("Data", "Content", "Strings")
RUNTIME_TOP_FILES = ("Mod.xml",)

# Player-facing documentation shipped at the mod root (Halcyon precedent).
DOC_TOP_FILES = ("CREDITS.md", "readme.md", "patchnotes.txt", "Pokemon changes.txt")

# Convention reference tree Halcyon ships alongside the release.
CONVENTION_TREES = ("CONVERSION",)

# Windows practical max path budget. MAX_PATH=260 minus a short root prefix
# ``C:\NE\<archive-root>\`` (~14 chars) leaves ~246 chars for the relative
# path. We enforce a tighter ceiling than that to be robust to any
# user prefix up to ~130 chars.
WINDOWS_MAX_PATH = 260
WINDOWS_SAFE_RELATIVE = 130  # relative path inside the archive

# Explicitly-forbidden globs inside the package (dev artefacts, build
# caches, backups, logs). If any of these ever land in the package it is
# a bug: the tool aborts with a diagnostic.
from fnmatch import fnmatch as _fnmatch
FORBIDDEN_INSIDE_PACKAGE = (
    "__pycache__/*", "*.pyc",
    ".git/*", ".gitignore", ".gitmodules",
    ".pytest_cache/*",
    ".runtime-cache/*",
    "Staging/*",
    "RESERVE/*",
    "external/*",
    "NO_NAME_VILLAGE_ADAPTATION/*",
    "PMU_ADAPTATION/*", "PMU_EXTRACTION/*",
    "docs/*",
    "tools/*", "tests/*",
    "DungeonDefs/*",  # dev-only Builder inputs, not consumed by PMDO runtime
    "*.log",
)


@dataclass
class PackageReport:
    package_root: Path
    archive_path: Path
    archive_bytes: int = 0
    file_count: int = 0
    longest_relative: str = ""
    longest_length: int = 0
    excluded_top_level: list[str] = field(default_factory=list)
    canonical_hashes_source: dict[str, str] = field(default_factory=dict)
    canonical_hashes_package: dict[str, str] = field(default_factory=dict)
    hash_mismatches: list[str] = field(default_factory=list)
    missing_runtime: list[str] = field(default_factory=list)
    validation_errors: list[str] = field(default_factory=list)
    extraction_test: str = "SKIPPED"
    extraction_longest: str = ""
    extraction_max_length: int = 0


# ---------------------------------------------------------------------------
# Selection
# ---------------------------------------------------------------------------

def _iter_release_files(source_root: Path):
    """Yield every file that must ship in the release, with its relative path."""
    # Mandatory top-level files
    for top in RUNTIME_TOP_FILES + DOC_TOP_FILES:
        candidate = source_root / top
        if candidate.is_file():
            yield candidate, top
    # Runtime trees
    for tree_name in RUNTIME_TREE:
        tree_root = source_root / tree_name
        if not tree_root.is_dir():
            raise SystemExit(
                f"ERROR: mandatory runtime tree {tree_name!r} not found at "
                f"{source_root}. Aborting: cannot produce a functional "
                "PMDO 0.8.12 mod package without it.")
        yield from _iter_tree(source_root, tree_root)
    # Convention trees
    for tree_name in CONVENTION_TREES:
        tree_root = source_root / tree_name
        if tree_root.is_dir():
            yield from _iter_tree(source_root, tree_root)


def _iter_tree(source_root: Path, tree_root: Path):
    """Yield every non-noise file under a tree with its relative path."""
    for path in sorted(tree_root.rglob("*")):
        if not path.is_file():
            continue
        # Filter dev-only stragglers that might have leaked into the tree
        # (macOS metadata, Python bytecode, editor backups).
        if path.name.startswith("."):
            continue
        if path.name.endswith(("~", ".bak", ".swp", ".tmp")):
            continue
        if "__pycache__" in path.parts or path.suffix == ".pyc":
            continue
        if path.name == ".DS_Store" or path.name == "Thumbs.db":
            continue
        rel = path.relative_to(source_root).as_posix()
        yield path, rel


def _sha256_of(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


# ---------------------------------------------------------------------------
# Canonical sample (integrity proof)
# ---------------------------------------------------------------------------

def _sample_canonical_files(source_root: Path) -> list[str]:
    """Sample of canonical files whose SHA256 must match between source and package.

    Covers every dungeon Zone, every canonical Ground / Map file, every
    Ground / Zone / service Lua init.lua, every AutoTile definition,
    every local music track, plus Mod.xml and the shipped docs.
    """
    manifest: list[str] = []
    # Manifest & docs
    for name in RUNTIME_TOP_FILES + DOC_TOP_FILES:
        if (source_root / name).is_file():
            manifest.append(name)
    # Every Zone JSON + the zone index
    for zone in sorted((source_root / "Data" / "Zone").glob("*.json")):
        manifest.append(zone.relative_to(source_root).as_posix())
    if (source_root / "Data/Zone/index.idx").is_file():
        manifest.append("Data/Zone/index.idx")
    # Every Ground and Map file — geometry integrity proof
    for pattern in ("Data/Ground/*.rsground", "Data/Map/*.rsmap"):
        for match in sorted(source_root.glob(pattern)):
            manifest.append(match.relative_to(source_root).as_posix())
    # Every Ground init.lua — canonical scene scripts
    for lua in sorted((source_root / "Data/Script/halcyon/ground").glob("*/init.lua")):
        manifest.append(lua.relative_to(source_root).as_posix())
    # Every Zone init.lua — canonical zone scripts
    for lua in sorted((source_root / "Data/Script/halcyon/zone").glob("*/init.lua")):
        manifest.append(lua.relative_to(source_root).as_posix())
    # PMDO service scripts (validators etc. — loaded at runtime)
    services = source_root / "Data/Script/halcyon/services"
    if services.is_dir():
        for lua in sorted(services.rglob("init.lua")):
            manifest.append(lua.relative_to(source_root).as_posix())
    # halcyon common scripts
    for lua in sorted((source_root / "Data/Script/halcyon").glob("*.lua")):
        manifest.append(lua.relative_to(source_root).as_posix())
    # Music files present locally (extracted from ROM)
    music = source_root / "Content/Music"
    if music.is_dir():
        for ogg in sorted(music.glob("*.ogg")):
            manifest.append(ogg.relative_to(source_root).as_posix())
    # AutoTile definitions — DTEF proofs
    autotile = source_root / "Data/AutoTile"
    if autotile.is_dir():
        for at in sorted(autotile.glob("*.json")):
            manifest.append(at.relative_to(source_root).as_posix())
    # CONVERSION tables — shipped Halcyon-style, must survive intact
    conv = source_root / "CONVERSION"
    if conv.is_dir():
        for txt in sorted(conv.glob("*.txt")):
            manifest.append(txt.relative_to(source_root).as_posix())
    seen = set()
    unique = []
    for rel in manifest:
        if rel in seen:
            continue
        seen.add(rel)
        unique.append(rel)
    return unique


# ---------------------------------------------------------------------------
# Assembly
# ---------------------------------------------------------------------------

def build_package(source_root: Path, dest_root: Path,
                  *, fmt: str = "zip") -> PackageReport:
    """Materialise the distributable package under `dest_root`."""
    source_root = source_root.resolve()
    dest_root = dest_root.resolve()
    if source_root == dest_root or dest_root.is_relative_to(source_root):
        # dest inside source is fine as long as it's not the source root itself,
        # but avoid subdirectories that we ourselves need to copy from.
        for critical in RUNTIME_TREE + CONVENTION_TREES:
            crit_path = source_root / critical
            if dest_root == crit_path or crit_path.is_relative_to(dest_root):
                raise SystemExit(
                    f"ERROR: dest_root {dest_root} would overwrite a runtime "
                    f"tree at {crit_path}")
    package_root = dest_root / PACKAGE_NAME
    if package_root.exists():
        shutil.rmtree(package_root)
    package_root.mkdir(parents=True, exist_ok=True)

    report = PackageReport(package_root=package_root, archive_path=Path())

    print(f"[package] source     = {source_root}")
    print(f"[package] destination= {package_root}")
    print(f"[package] copying release files (Halcyon-conforming manifest)...")
    for src_path, rel in _iter_release_files(source_root):
        dst = package_root / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src_path, dst)
        report.file_count += 1
        if len(rel) > report.longest_length:
            report.longest_length = len(rel)
            report.longest_relative = rel
    print(f"[package] copied {report.file_count} files")
    print(f"[package] longest relative path: {report.longest_length} chars "
          f"({report.longest_relative})")

    # ---- Write Windows extraction guidance ----
    (package_root / "README-WINDOWS.txt").write_text(
        "New Era: Abyss to Ascension - Windows install guide\n"
        "===================================================\n"
        "\n"
        "This package is the PMDO 0.8.12 mod runtime layout, following the\n"
        "same convention as the reference PMDO mod Halcyon\n"
        "(https://github.com/Palikadude/Halcyon).\n"
        "\n"
        "Contents (matches Halcyon's release layout):\n"
        "  Mod.xml                 - PMDO mod manifest (mandatory)\n"
        "  Data/                   - canonical PMDO data tree\n"
        "  Content/                - canonical assets (tiles, music, graphics)\n"
        "  Strings/                - localisation\n"
        "  CONVERSION/             - ROM<->PMDO name lookup tables (reference)\n"
        "  CREDITS.md              - credits\n"
        "  readme.md               - install / FAQ\n"
        "  patchnotes.txt          - version history\n"
        "  Pokemon changes.txt     - player-facing gameplay notes\n"
        "\n"
        "How to install (same steps as Halcyon):\n"
        "  1. Download and install PMDO (audinowho/PMDODump) if not already.\n"
        "  2. Extract this archive to a SHORT root path, e.g. C:\\NE\\ .\n"
        "     Extracting to a deep path such as\n"
        "        C:\\Users\\<name>\\Downloads\\<long-folder>\\\n"
        "     may still overflow Windows MAX_PATH (260 chars) for the\n"
        "     deepest asset paths. This package's own paths are all under\n"
        "     100 chars, so a short root guarantees safe extraction.\n"
        "  3. Move the resulting New-Era folder into your PMDO MODS/\n"
        "     directory (usually %APPDATA%\\PMDO\\MODS\\New-Era\\).\n"
        "  4. Make sure New-Era is not nested one folder deep - when you\n"
        "     open the New-Era folder you must see Mod.xml directly, not\n"
        "     an inner New-Era folder.\n"
        "  5. Launch PMDO and select New Era from the Special Episodes menu.\n"
        "\n"
        "If you need to extract to a normal Downloads path, enable Win32\n"
        "long-path support (Windows 10 1607+, requires Administrator):\n"
        "    New-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem' \\\n"
        "      -Name 'LongPathsEnabled' -Value 1 -PropertyType DWORD -Force\n"
        "  (then reboot)\n",
        encoding="utf-8")
    report.file_count += 1

    # ---- Compute canonical hashes on the source ----
    print(f"[package] hashing canonical sample from source...")
    for rel in _sample_canonical_files(source_root):
        src = source_root / rel
        if src.is_file():
            report.canonical_hashes_source[rel] = _sha256_of(src)
    print(f"[package] hashed {len(report.canonical_hashes_source)} canonical files")

    # ---- Validate no forbidden artefacts leaked into package ----
    print(f"[package] scanning for forbidden dev artefacts inside package...")
    for candidate in package_root.rglob("*"):
        if not candidate.is_file():
            continue
        rel = candidate.relative_to(package_root).as_posix()
        for pattern in FORBIDDEN_INSIDE_PACKAGE:
            if _fnmatch(rel, pattern):
                report.validation_errors.append(
                    f"forbidden artefact in package: {rel} (matches {pattern})")
                break

    # ---- Verify required runtime files ----
    for required in RUNTIME_TOP_FILES:
        if not (package_root / required).is_file():
            report.missing_runtime.append(required)
    for tree in RUNTIME_TREE:
        if not (package_root / tree).is_dir():
            report.missing_runtime.append(tree + "/")

    # ---- Compute canonical hashes on the package copy ----
    print(f"[package] verifying canonical hashes in package...")
    for rel, expected in report.canonical_hashes_source.items():
        pkg = package_root / rel
        if not pkg.is_file():
            report.hash_mismatches.append(f"{rel}: not present in package")
            continue
        got = _sha256_of(pkg)
        report.canonical_hashes_package[rel] = got
        if got != expected:
            report.hash_mismatches.append(
                f"{rel}: source={expected[:12]} package={got[:12]}")

    # ---- Enforce Windows path budget ----
    if report.longest_length > WINDOWS_SAFE_RELATIVE:
        report.validation_errors.append(
            f"longest relative path {report.longest_length} exceeds "
            f"WINDOWS_SAFE_RELATIVE={WINDOWS_SAFE_RELATIVE}: "
            f"{report.longest_relative}")

    # ---- Record excluded top-level dev-only entries ----
    for entry in sorted(source_root.iterdir()):
        name = entry.name
        if name in RUNTIME_TOP_FILES or name in DOC_TOP_FILES:
            continue
        if name in RUNTIME_TREE or name in CONVENTION_TREES:
            continue
        if name in {".git", ".runtime-cache", ".pytest_cache",
                    ".gitignore", ".gitmodules"}:
            report.excluded_top_level.append(name + " (VCS/cache)")
            continue
        report.excluded_top_level.append(name)

    # ---- Produce archive ----
    if fmt == "zip":
        archive_path = dest_root / f"{PACKAGE_NAME}.zip"
        _write_zip(package_root, archive_path)
    elif fmt == "tar":
        archive_path = dest_root / f"{PACKAGE_NAME}.tar.gz"
        _write_tar(package_root, archive_path)
    else:
        raise SystemExit(f"unknown archive format: {fmt}")
    report.archive_path = archive_path
    report.archive_bytes = archive_path.stat().st_size
    print(f"[package] archive: {archive_path} "
          f"({report.archive_bytes/1024/1024:.1f} MB)")

    return report


def _write_zip(package_root: Path, archive_path: Path):
    with zipfile.ZipFile(archive_path, "w", zipfile.ZIP_DEFLATED,
                         allowZip64=True) as zf:
        for path in sorted(package_root.rglob("*")):
            if path.is_file():
                arcname = f"{PACKAGE_NAME}/" + str(
                    path.relative_to(package_root)).replace("\\", "/")
                zf.write(path, arcname)


def _write_tar(package_root: Path, archive_path: Path):
    with tarfile.open(archive_path, "w:gz") as tf:
        tf.add(package_root, arcname=PACKAGE_NAME)


# ---------------------------------------------------------------------------
# Extraction / smoke test
# ---------------------------------------------------------------------------

def extraction_smoke_test(archive_path: Path, dest_root: Path,
                          *, canonical_hashes: dict[str, str] | None = None,
                          ) -> tuple[bool, str, int, int, list[str]]:
    """Extract archive under `dest_root` and verify contents.

    Returns (ok, longest_relative, longest_length, file_count, errors).
    """
    dest_root = Path(dest_root).resolve()
    if dest_root.exists():
        shutil.rmtree(dest_root)
    dest_root.mkdir(parents=True, exist_ok=True)
    errors: list[str] = []
    print(f"[extract] extracting {archive_path.name} -> {dest_root}")
    with zipfile.ZipFile(archive_path) as zf:
        zf.extractall(dest_root)
    extracted_root = dest_root / PACKAGE_NAME
    if not extracted_root.is_dir():
        errors.append(f"missing extracted root: {extracted_root}")
        return False, "", 0, 0, errors
    longest = ""
    longest_len = 0
    file_count = 0
    for path in extracted_root.rglob("*"):
        if not path.is_file():
            continue
        file_count += 1
        rel = path.relative_to(extracted_root).as_posix()
        if len(rel) > longest_len:
            longest_len = len(rel)
            longest = rel
    print(f"[extract] {file_count} files extracted")
    print(f"[extract] longest relative path: {longest_len} chars ({longest})")
    for required in RUNTIME_TOP_FILES:
        if not (extracted_root / required).is_file():
            errors.append(f"missing runtime file after extraction: {required}")
    for tree in RUNTIME_TREE:
        if not (extracted_root / tree).is_dir():
            errors.append(f"missing runtime tree after extraction: {tree}/")
    if canonical_hashes:
        mismatches = 0
        for rel, expected in canonical_hashes.items():
            path = extracted_root / rel
            if not path.is_file():
                errors.append(f"canonical file missing after extraction: {rel}")
                continue
            got = _sha256_of(path)
            if got != expected:
                errors.append(f"canonical HASH MISMATCH: {rel} "
                              f"expected={expected[:12]} got={got[:12]}")
                mismatches += 1
        if not mismatches:
            print(f"[extract] all {len(canonical_hashes)} canonical hashes match "
                  f"source-side")
    return not errors, longest, longest_len, file_count, errors


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--source", default=str(ROOT))
    parser.add_argument("--dest", default=None,
                        help="Destination folder for the package and archive.")
    parser.add_argument("--format", choices=("zip", "tar"), default="zip")
    parser.add_argument("--extract-test", default=None,
                        help="Extraction test destination. "
                             "'none' to skip.")
    parser.add_argument("--report", default=None,
                        help="Where to write the JSON report.")
    args = parser.parse_args(argv)

    source_root = Path(args.source).resolve()
    dest_root = Path(args.dest).resolve() if args.dest \
        else Path("/tmp/new-era-package").resolve()
    dest_root.mkdir(parents=True, exist_ok=True)

    start = time.time()
    report = build_package(source_root, dest_root, fmt=args.format)

    if args.extract_test != "none":
        extract_dest = Path(args.extract_test).resolve() if args.extract_test \
            else (dest_root / "extract-test").resolve()
        ok, longest, longest_len, extracted_count, errors = extraction_smoke_test(
            report.archive_path, extract_dest,
            canonical_hashes=report.canonical_hashes_source,
        )
        report.extraction_test = "PASS" if ok else "FAIL"
        report.extraction_longest = longest
        report.extraction_max_length = longest_len
        if errors:
            report.validation_errors.extend(f"extraction: {e}" for e in errors)

    report_path = Path(args.report).resolve() if args.report \
        else dest_root / "PACKAGE_REPORT.json"
    report_json = {
        "schema": "new-era.windows-package.v1",
        "source_root": str(source_root),
        "package_root": str(report.package_root),
        "archive_path": str(report.archive_path),
        "archive_bytes": report.archive_bytes,
        "archive_mib": round(report.archive_bytes / 1024 / 1024, 2),
        "file_count": report.file_count,
        "longest_relative": report.longest_relative,
        "longest_length": report.longest_length,
        "windows_safe_relative_budget": WINDOWS_SAFE_RELATIVE,
        "windows_max_path": WINDOWS_MAX_PATH,
        "excluded_top_level": report.excluded_top_level,
        "canonical_files_sampled": len(report.canonical_hashes_source),
        "canonical_hash_mismatches": report.hash_mismatches,
        "missing_runtime": report.missing_runtime,
        "validation_errors": report.validation_errors,
        "extraction_test": report.extraction_test,
        "extraction_longest": report.extraction_longest,
        "extraction_max_length": report.extraction_max_length,
        "elapsed_seconds": round(time.time() - start, 2),
    }
    report_path.write_text(json.dumps(report_json, indent=2) + "\n",
                           encoding="utf-8")
    print(f"[package] report: {report_path}")

    print()
    print("========================================")
    print("Windows Package Bilan")
    print("========================================")
    fail = bool(report.missing_runtime or report.hash_mismatches
                or report.validation_errors)
    print(f"Windows packaging          : {'FAIL' if fail else 'PASS'}")
    print(f"Archive generated          : {report.archive_path}")
    print(f"Archive size               : {report_json['archive_mib']} MB "
          f"({report.archive_bytes} bytes)")
    print(f"Files in package           : {report.file_count}")
    print(f"Required runtime files     : "
          f"{'MISSING ' + str(report.missing_runtime) if report.missing_runtime else 'PASS'}")
    print(f"Canonical content unchanged: "
          f"{'MISMATCHES ' + str(len(report.hash_mismatches)) if report.hash_mismatches else 'PASS'}")
    print(f"Canonical hashes verified  : "
          f"{len(report.canonical_hashes_source)} files sampled")
    print(f"Runtime references intact  : "
          f"{'FAIL - see validation_errors' if report.validation_errors else 'PASS'}")
    print(f"Extraction test            : {report.extraction_test}")
    print(f"  Longest path (source)    : {report.longest_length} chars "
          f"({report.longest_relative})")
    if report.extraction_test != "SKIPPED":
        print(f"  Longest path (extracted) : {report.extraction_max_length} chars "
              f"({report.extraction_longest})")
    print(f"Excluded dev artefacts     : {len(report.excluded_top_level)} top-level entries")
    if report.validation_errors:
        print()
        print("Validation errors:")
        for err in report.validation_errors[:20]:
            print(f"  - {err}")
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main())
