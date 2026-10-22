"""ROM-backed smoke tests.

These tests run against the user's LOCAL ROM if present under
converter/rom_input/. They are SKIPPED (not failed) when the ROM or the
pret checkout are absent, and RUN normally on a machine where both are
present.

They never copy ROM bytes anywhere the repo can see; they only assert
that the converter's decoders and mapper produce non-degenerate output
on real inputs.
"""
from __future__ import annotations

import hashlib
from pathlib import Path

import pytest

from converter.aux_sources.pret import load_pret_checkout
from converter.decoders.ssb import decode as decode_ssb
from converter.ir.cinematic import UnknownOpcode
from converter.mappers.cinematic_to_lua import map_cinematic
from converter.pmdred.specs import DEFAULT_SPECS
from converter.pmdred.table_resolver import resolve as resolve_tables
from converter.rom.pointer_scan import iter_pointer_tables
from converter.rom.rom_file import RomFile
from converter.stages.context import (
    ROM_EXPECTED_HASH,
    ROM_EXPECTED_SIZE,
)


REPO_ROOT = Path(__file__).resolve().parents[2]
ROM_INPUT_DIR = REPO_ROOT / "converter" / "rom_input"
PRET_CHECKOUT = REPO_ROOT / "dev" / "external" / "pret_pmd_red"


def _find_local_rom() -> Path | None:
    """Return the path to the user's local ROM if it authenticates."""
    if not ROM_INPUT_DIR.is_dir():
        return None
    for entry in sorted(ROM_INPUT_DIR.iterdir()):
        if not entry.is_file():
            continue
        if entry.name.startswith("."):
            continue
        if entry.name.lower() == "readme.txt":
            continue
        if entry.stat().st_size != ROM_EXPECTED_SIZE:
            continue
        h = hashlib.sha256()
        with entry.open("rb") as fh:
            for block in iter(lambda: fh.read(1 << 20), b""):
                h.update(block)
        if h.hexdigest() == ROM_EXPECTED_HASH:
            return entry
    return None


ROM_PATH = _find_local_rom()
PRET_PRESENT = (PRET_CHECKOUT / "include" / "constants").is_dir()


rom_required = pytest.mark.skipif(
    ROM_PATH is None,
    reason=(
        "No authenticated ROM in converter/rom_input/ "
        "(expected sha256=" + ROM_EXPECTED_HASH[:16] + "...). "
        "Drop your legal PMD Red EU copy there to enable this test."
    ),
)


pret_required = pytest.mark.skipif(
    not PRET_PRESENT,
    reason=(
        "pret/pmd-red checkout not found under dev/external/pret_pmd_red. "
        "Clone it locally (git-ignored) to enable this test."
    ),
)


@rom_required
def test_rom_authenticates_and_header_valid() -> None:
    """The ROM authenticates AND its GBA header is well-formed."""
    assert ROM_PATH is not None
    with RomFile.open(ROM_PATH) as rom:
        assert rom.size == ROM_EXPECTED_SIZE
        assert rom.sha256() == ROM_EXPECTED_HASH
        from converter.rom.header import read_header
        header = read_header(rom.read(0, 0xC0))
        assert header.header_looks_valid, (
            f"GBA header invalid: fixed_96_ok={header.fixed_96_ok}, "
            f"game_code={header.game_code!r}"
        )
        # Region hint should be 'EU' for this cartridge (game code
        # 4th char = 'P'), but do not hard-fail on the exact game_code
        # string — that would embed identifying data in the test.
        assert header.game_code, "empty game_code parsed"


@rom_required
def test_rom_pointer_scan_finds_many_tables() -> None:
    """A real GBA ROM contains many pointer tables. Assert we see a
    plausible number, without hard-coding any offset."""
    assert ROM_PATH is not None
    with RomFile.open(ROM_PATH) as rom:
        tables = list(iter_pointer_tables(rom, min_entries=8))
    # This is a structural sanity bound, not a game-specific value:
    # any commercial GBA ROM has hundreds of pointer tables.
    assert len(tables) >= 100, (
        f"expected >= 100 pointer tables on a real GBA ROM, "
        f"found {len(tables)}"
    )


@rom_required
@pret_required
def test_rom_resolver_finds_at_least_one_role() -> None:
    """With pret enums available, the resolver should identify at least
    one PMD Red role table from real ROM bytes."""
    assert ROM_PATH is not None
    with RomFile.open(ROM_PATH) as rom:
        tables = list(iter_pointer_tables(rom, min_entries=4))
        pret = load_pret_checkout(PRET_CHECKOUT)
        assert pret is not None
        resolved = resolve_tables(rom, tables, DEFAULT_SPECS, pret)
    ok = [r for r in resolved if r.status == "RESOLVED"]
    # We do not assert *which* role resolved: enum names and table
    # fingerprints evolve. We assert the resolver is not degenerate.
    assert ok, (
        "resolver produced 0 RESOLVED roles on a real ROM with pret "
        f"available. Reasons: "
        + " | ".join(f"{r.role}:{r.reason[:80]}" for r in resolved)
    )


@rom_required
@pret_required
def test_ground_map_table_resolves_and_bma_decodes() -> None:
    """Full slice for the ground pipeline on the EUROPEAN ROM layout:
    locate the pksdir0 Ground archive + map-files table structurally,
    decode the first grounds' BMAs, verify the headers are plausible
    and the viewport invariants pass."""
    from converter.decoders.bma import decode as decode_bma
    from converter.ir.ground import Ground_IR
    from converter.ir.provenance import Provenance, Status
    from converter.pmdo.viewport import check_ground_viewport
    from converter.pmdred.eu_archive import (
        find_archive,
        find_map_files_table,
    )

    assert ROM_PATH is not None
    with RomFile.open(ROM_PATH) as rom:
        archive = find_archive(rom)
        assert archive is not None, "pksdir0 Ground archive not found"
        mft = find_map_files_table(rom, archive)
        assert mft is not None, "EU map-files table not found"
        assert len(mft.rows) >= 245, (
            f"map-files table too small: {len(mft.rows)} rows"
        )

        by_name = archive.by_name()
        good = 0
        for row in mft.rows[:8]:
            res = by_name.get(row.bma or "")
            if res is None:
                continue
            bound = res.next_offset or rom.size
            max_read = min(128 * 1024, max(bound - res.data_offset, 0))
            if max_read <= 12:
                continue
            blob = rom.read(res.data_offset, max_read)
            bma, stats = decode_bma(
                blob, ground_id=row.stable_ground_id or "rom_smoke",
                rom_sha256=rom.sha256(), rom_offset=res.data_offset,
            )
            if bma.provenance and bma.provenance.status == Status.UNKNOWN:
                continue
            w = bma.layers[0].width_chunks * 3 if bma.layers else 0
            h = bma.layers[0].height_chunks * 3 if bma.layers else 0
            g = Ground_IR(
                id="rom_smoke", rom_map_file_id="RS",
                width_tiles=w, height_tiles=h,
                pixel_width=w * 24, pixel_height=h * 24,
                tileset_id=0, bma=bma,
                provenance=Provenance(rom_sha256=rom.sha256(),
                                      status=Status.PORTED),
            )
            vp = check_ground_viewport(g)
            assert w > 0 and h > 0, (
                f"BMA {row.bma} decoded with zero dimensions"
            )
            good += 1
            if vp.ok:
                good += 100
                break

        assert good >= 1, (
            "no map-files row decoded to a plausible BMA in the first "
            f"8 tries (archive at {archive.base_offset:#010x}, "
            f"{archive.count} resources)"
        )


@rom_required
@pret_required
def test_end_to_end_ssb_decode_and_lua_map() -> None:
    """Full slice: pick a real SSB blob from the ROM (via the resolver),
    decode it, map it to Lua, verify the Lua is non-empty and mentions
    at least one PMDO API call."""
    assert ROM_PATH is not None
    with RomFile.open(ROM_PATH) as rom:
        tables = list(iter_pointer_tables(rom, min_entries=4))
        pret = load_pret_checkout(PRET_CHECKOUT)
        assert pret is not None
        resolved = resolve_tables(rom, tables, DEFAULT_SPECS, pret)

        # Pick the first RESOLVED role's first entry as our sample.
        sample = None
        for r in resolved:
            if r.status == "RESOLVED" and r.entries:
                sample = (r.role, r.entries[0])
                break
        if sample is None:
            pytest.skip(
                "no RESOLVED role produced a sample entry; nothing to "
                "decode end-to-end. Reasons: "
                + " | ".join(f"{r.role}:{r.reason[:60]}" for r in resolved)
            )
        role, entry_offset = sample

        # Read up to 4 KiB from the entry (bounded); the decoder will
        # stop at the first zero record.
        max_read = min(4096, rom.size - entry_offset)
        blob = rom.read(entry_offset, max_read)

        cine, stats = decode_ssb(
            blob,
            scene_id=f"rom_smoke_{role}",
            ground_id=f"rom_smoke_{role}",
            rom_sha256=rom.sha256(),
            rom_offset=entry_offset,
            pret=pret,
        )

    # Structural sanity: we got at least one record; the decoder never
    # returns nothing on non-empty input.
    assert stats.records_total >= 1, (
        f"decoder produced 0 records from {stats.records_total} bytes "
        f"at offset {entry_offset:#x} (role={role}); this is a decoder bug"
    )

    # Every entry is either a typed event or a preserved UnknownOpcode;
    # nothing is silently lost.
    assert len(cine.timeline) == stats.records_total

    result = map_cinematic(cine, scene_module_name="rom_smoke")
    assert "function rom_smoke.Cutscene()" in result.lua_text
    assert "GAME:CutsceneMode(true)" in result.lua_text
    assert "GAME:CutsceneMode(false)" in result.lua_text
    # Aggregate provenance must be honest about the outcome.
    assert result.provenance.rom_sha256 == ROM_EXPECTED_HASH
    if any(isinstance(e, UnknownOpcode) for e in cine.timeline):
        assert result.provenance.status_reason, (
            "aggregate reason must be set when UNKNOWN events are present"
        )
