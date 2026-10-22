"""Provenance dataclass tests.

Verifies the core invariant: a status that is not PORTED/CANONICAL
requires an explicit status_reason. This is the guard that prevents a
future contributor from silently emitting a RECONSTRUCTED/PARTIAL
artefact without saying why.
"""
from __future__ import annotations

import pytest

from converter.ir.provenance import Provenance, Status
from converter.stages.context import ROM_EXPECTED_HASH


def test_ported_provenance_ok_without_reason() -> None:
    p = Provenance(rom_sha256=ROM_EXPECTED_HASH, status=Status.PORTED)
    assert p.status is Status.PORTED
    assert p.to_json()["status"] == "PORTED"


def test_canonical_provenance_ok_without_reason() -> None:
    p = Provenance(rom_sha256=ROM_EXPECTED_HASH, status=Status.CANONICAL)
    assert p.status is Status.CANONICAL


@pytest.mark.parametrize("bad_status", [
    Status.PARTIAL,
    Status.RECONSTRUCTED,
    Status.UNKNOWN,
    Status.BLOCKED,
])
def test_downgraded_status_requires_reason(bad_status: Status) -> None:
    with pytest.raises(ValueError, match="requires a non-empty status_reason"):
        Provenance(rom_sha256=ROM_EXPECTED_HASH, status=bad_status)


@pytest.mark.parametrize("bad_status", [
    Status.PARTIAL,
    Status.RECONSTRUCTED,
    Status.UNKNOWN,
    Status.BLOCKED,
])
def test_downgraded_status_accepts_reason(bad_status: Status) -> None:
    p = Provenance(
        rom_sha256=ROM_EXPECTED_HASH,
        status=bad_status,
        status_reason="documented gap: awaiting decoder",
    )
    assert p.status is bad_status


def test_provenance_json_roundtrip_keys() -> None:
    p = Provenance(
        rom_sha256=ROM_EXPECTED_HASH,
        status=Status.PORTED,
        rom_offset=0x1000,
        rom_length=42,
        extractor_version="0.1.0",
    )
    d = p.to_json()
    for k in ("rom_sha256", "status", "rom_offset", "rom_length",
              "extractor_version", "extracted_at_utc", "auxiliary"):
        assert k in d
