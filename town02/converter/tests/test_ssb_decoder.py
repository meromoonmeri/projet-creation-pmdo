"""Tests for the SSB decoder.

Uses synthetic 16-byte records built to the public ScriptCommand
layout. Never touches real game content.
"""
from __future__ import annotations

import struct
from pathlib import Path

from converter.aux_sources.pret import PretCheckout, PretEnum
from converter.decoders.ssb import RECORD_SIZE, decode
from converter.ir.cinematic import (
    DialogueShow,
    FadeToColor,
    PlayBGM,
    SetFlag,
    UnknownOpcode,
    Wait,
)
from converter.stages.context import ROM_EXPECTED_HASH


def _record(op: int, arg_byte: int = 0, arg_short: int = 0,
            arg1: int = 0, arg2: int = 0, arg_ptr: int = 0) -> bytes:
    return struct.pack("<BBhiiI", op, arg_byte, arg_short, arg1, arg2, arg_ptr)


def _pret_with_ops(mapping: dict[str, int]) -> PretCheckout:
    e = PretEnum(name="ScriptOpID", members=dict(mapping))
    return PretCheckout(root=Path("/nonexistent"),
                        enums_by_name={e.name: e})


def test_decoder_translates_known_opcodes() -> None:
    """Build a synthetic blob using operation *names* mapped to
    arbitrary numeric ids; the decoder must translate them via the
    pret enum, not via a hard-coded id table."""
    pret = _pret_with_ops({
        "PLAY_MUSIC": 0x0A,
        "MSG":        0x0B,
        "WAIT":       0x0C,
        "SET_FLAG":   0x0D,
        "FADE_OUT":   0x0E,
    })

    blob = b"".join([
        _record(0x0A, arg_short=0x0123),       # PLAY_MUSIC id 0x0123
        _record(0x0B, arg_short=0x0045),       # MSG id 0x0045
        _record(0x0C, arg_short=30),           # WAIT 30 frames -> 500 ms
        _record(0x0D, arg_byte=1, arg_short=0x0007),  # SET_FLAG(7) = 1
        _record(0x0E, arg_short=60),           # FADE_OUT 60 frames -> 1000 ms
    ])

    cine, stats = decode(
        blob,
        scene_id="synth_scene",
        ground_id="synth_ground",
        rom_sha256=ROM_EXPECTED_HASH,
        rom_offset=0x1000,
        pret=pret,
    )

    assert stats.records_total == 5
    assert stats.records_translated == 5
    assert stats.records_unknown == 0

    types = [type(e).__name__ for e in cine.timeline]
    assert types == ["PlayBGM", "DialogueShow", "Wait", "SetFlag", "FadeToColor"]

    # Type-specific sanity
    bgm = cine.timeline[0]
    assert isinstance(bgm, PlayBGM)
    assert bgm.track_id == "BGM_0123"

    msg = cine.timeline[1]
    assert isinstance(msg, DialogueShow)
    assert msg.string_key == "MSG_0045"

    wait = cine.timeline[2]
    assert isinstance(wait, Wait)
    assert wait.ms == 500                     # 30 frames @ 60 fps

    flag = cine.timeline[3]
    assert isinstance(flag, SetFlag)
    assert flag.flag == "FLAG_0007"
    assert flag.value == 1

    fade = cine.timeline[4]
    assert isinstance(fade, FadeToColor)
    assert fade.rgba == (0, 0, 0, 255)
    assert fade.ms == 1000


def test_decoder_preserves_unknown_opcodes_verbatim() -> None:
    pret = _pret_with_ops({"WAIT": 0x0C})     # only WAIT is known
    blob = b"".join([
        _record(0x0C, arg_short=6),           # WAIT
        _record(0x99, arg_byte=0xAA, arg_short=0x1234, arg1=0x1111,
                arg2=0x2222, arg_ptr=0x08123456),
    ])
    cine, stats = decode(
        blob, scene_id="s", ground_id="g",
        rom_sha256=ROM_EXPECTED_HASH, rom_offset=0x2000, pret=pret,
    )
    assert stats.records_total == 2
    assert stats.records_translated == 1
    assert stats.records_unknown == 1
    assert stats.unknown_opcode_ids == [0x99]

    unk = cine.timeline[1]
    assert isinstance(unk, UnknownOpcode)
    assert unk.opcode == 0x99
    assert len(unk.raw) == RECORD_SIZE
    # Same bytes we fed in, byte-for-byte.
    expected = _record(0x99, arg_byte=0xAA, arg_short=0x1234, arg1=0x1111,
                       arg2=0x2222, arg_ptr=0x08123456)
    assert unk.raw == expected


def test_decoder_falls_back_when_pret_absent() -> None:
    """Without pret, opcode names are OP_0x<hex> and everything ends
    up as UnknownOpcode — but the raw bytes are preserved."""
    blob = _record(0x10) + _record(0x11)
    cine, stats = decode(
        blob, scene_id="s", ground_id="g",
        rom_sha256=ROM_EXPECTED_HASH, rom_offset=0, pret=None,
    )
    assert stats.records_translated == 0
    assert stats.records_unknown == 2
    assert all(isinstance(e, UnknownOpcode) for e in cine.timeline)


def test_decoder_stops_on_zero_terminator() -> None:
    pret = _pret_with_ops({"WAIT": 0x0C})
    blob = _record(0x0C, arg_short=5) + b"\x00" * RECORD_SIZE + _record(0x0C)
    cine, stats = decode(
        blob, scene_id="s", ground_id="g",
        rom_sha256=ROM_EXPECTED_HASH, rom_offset=0, pret=pret,
    )
    assert stats.records_total == 1           # stopped at the zero record
