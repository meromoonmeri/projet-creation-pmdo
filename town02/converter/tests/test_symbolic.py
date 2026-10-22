"""Tests for the symbolic name resolver.

Uses synthetic PretCheckout instances (never any real game data) to
prove music/sfx/flag/cutscene id -> name resolution behaves correctly
and returns None when the pret checkout is absent.
"""
from __future__ import annotations

from pathlib import Path

from converter.aux_sources.pret import PretCheckout, PretEnum
from converter.pmdred.symbolic import (
    SymbolResolver,
    resolve_bgm_key,
    resolve_flag_key,
    resolve_sfx_key,
)


def _pret_with(enums: dict[str, dict[str, int]]) -> PretCheckout:
    checkout = PretCheckout(root=Path("/nonexistent"))
    for name, members in enums.items():
        checkout.enums_by_name[name] = PretEnum(name=name, members=dict(members))
    return checkout


def test_music_resolution_hits_and_misses() -> None:
    r = SymbolResolver(pret=_pret_with({
        "MusicID": {"MUS_SYNTHONE": 0x0A, "MUS_SYNTHTWO": 0x0B},
    }))
    assert r.music(0x0A) == "MUS_SYNTHONE"
    assert r.music(0x0B) == "MUS_SYNTHTWO"
    assert r.music(0x99) is None


def test_none_pret_returns_none_and_never_crashes() -> None:
    r = SymbolResolver(pret=None)
    assert r.music(0) is None
    assert r.sfx(0) is None
    assert r.flag(0) is None
    assert r.cutscene(0) is None


def test_key_resolvers_from_hex_placeholders() -> None:
    r = SymbolResolver(pret=_pret_with({
        "MusicID":     {"MUS_X": 0x0A},
        "SEID":        {"SE_X": 0x0B},
        "EventFlagID": {"FLAG_X": 7},
    }))
    assert resolve_bgm_key("BGM_000A", r) == "MUS_X"
    assert resolve_sfx_key("SFX_000B", r) == "SE_X"
    assert resolve_flag_key("FLAG_0007", r) == "FLAG_X"

    # Bad key shape -> None, no crash
    assert resolve_bgm_key("not a key", r) is None
    assert resolve_bgm_key("BGM_zzzz", r) is None


def test_resolver_caches_inversion() -> None:
    pret = _pret_with({"MusicID": {"MUS_A": 1, "MUS_B": 2}})
    r = SymbolResolver(pret=pret)
    r.music(1)
    r.music(2)
    # Cache populated after first call
    assert "MusicID" in r._cache
    # Wipe underlying enum; cache should still serve
    pret.enums_by_name.clear()
    assert r.music(1) == "MUS_A"


def test_first_declaration_wins_on_duplicate_id() -> None:
    # PMD Red has a trailer alias MT_FREEZE_PEAK_2 with the same
    # numeric value as MT_FREEZE_PEAK. Our resolver must keep the
    # first name (the canonical one) rather than a later alias.
    r = SymbolResolver(pret=_pret_with({
        "MusicID": {"MUS_CANON": 5, "MUS_ALIAS": 5},
    }))
    assert r.music(5) == "MUS_CANON"
