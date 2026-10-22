"""Tests for the Cinematic_IR -> Lua mapper.

Feeds synthetic Event_IR objects (never any real game data) through
the mapper and asserts:
  * every event kind produces the expected PMDO API call,
  * generated Lua parses (via luac -p if available, else heuristic
    balance check),
  * UnknownOpcode events surface as `-- UNKNOWN` comments carrying
    the raw record hex so nothing is silently dropped,
  * the aggregate provenance status honestly reflects the mix
    (PORTED / PARTIAL / UNKNOWN) with a non-empty reason when
    downgraded.
"""
from __future__ import annotations

import shutil
import subprocess
from pathlib import Path

import pytest

from converter.ir.cinematic import (
    Cinematic_IR,
    DialogueClose,
    DialogueShow,
    FadeToColor,
    PlayBGM,
    PlaySFX,
    ScreenFlash,
    ScreenShake,
    SetFlag,
    StopBGM,
    UnknownOpcode,
    Wait,
    WaitFlag,
)
from converter.ir.provenance import Provenance, Status
from converter.mappers.cinematic_to_lua import map_cinematic
from converter.stages.context import ROM_EXPECTED_HASH
from converter.validators.lua_parse import check_file


ROM = ROM_EXPECTED_HASH


def _p(status: Status = Status.PORTED, reason: str = "") -> Provenance:
    if status in (Status.PORTED, Status.CANONICAL):
        return Provenance(rom_sha256=ROM, status=status)
    return Provenance(rom_sha256=ROM, status=status,
                      status_reason=reason or "test fixture")


def _cine(events: list) -> Cinematic_IR:
    return Cinematic_IR(
        scene_id="test_scene",
        ground_id="test_ground",
        timeline=events,
        provenance=Provenance(
            rom_sha256=ROM, status=Status.PARTIAL,
            status_reason="synthetic fixture for mapper test",
        ),
    )


# ---------------------------------------------------------------- shape


def test_mapper_emits_module_scaffold_and_ordering() -> None:
    events = [
        PlayBGM(kind="play_bgm", provenance=_p(Status.PARTIAL, "bgm"),
                track_id="BGM_0001", loop=True, fade_ms=0),
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "frames"), ms=500),
        DialogueShow(kind="dialogue_show", provenance=_p(Status.PARTIAL, "msg"),
                     string_key="MSG_002A"),
        DialogueClose(kind="dialogue_close", provenance=_p()),
    ]
    result = map_cinematic(_cine(events), scene_module_name="test_scene")
    text = result.lua_text

    assert "local test_scene = {}" in text
    assert "function test_scene.Cutscene()" in text
    assert "GAME:CutsceneMode(true)" in text
    assert "GAME:CutsceneMode(false)" in text
    assert "return test_scene" in text

    # Ordering: BGM before wait before dialogue
    idx_bgm  = text.index("GAME:PlayBGM")
    idx_wait = text.index("GAME:WaitFrames")
    idx_msg  = text.index("UI:WaitShowDialogue")
    assert idx_bgm < idx_wait < idx_msg


def test_mapper_translates_every_event_kind() -> None:
    events = [
        PlayBGM(kind="play_bgm", provenance=_p(Status.PARTIAL, "r"),
                track_id="BGM_00AA"),
        StopBGM(kind="stop_bgm", provenance=_p(), fade_ms=200),
        PlaySFX(kind="play_sfx", provenance=_p(Status.PARTIAL, "r"),
                sfx_id="SFX_00BB"),
        SetFlag(kind="set_flag", provenance=_p(Status.PARTIAL, "r"),
                flag="FLAG_0001", value=1),
        WaitFlag(kind="wait_flag", provenance=_p(Status.PARTIAL, "r"),
                 flag="FLAG_0001", value=1),
        DialogueShow(kind="dialogue_show", provenance=_p(Status.PARTIAL, "r"),
                     string_key="MSG_00CC"),
        DialogueClose(kind="dialogue_close", provenance=_p()),
        FadeToColor(kind="fade_to_black", provenance=_p(),
                    rgba=(0, 0, 0, 255), ms=1000),
        FadeToColor(kind="fade_to_white", provenance=_p(),
                    rgba=(255, 255, 255, 255), ms=500),
        FadeToColor(kind="fade_to_custom",
                    provenance=_p(Status.PARTIAL, "custom color"),
                    rgba=(128, 64, 32, 255), ms=250),
        ScreenFlash(kind="screen_flash",
                    provenance=_p(Status.PARTIAL, "approx"),
                    rgba=(255, 255, 255, 255), ms=100),
        ScreenShake(kind="screen_shake",
                    provenance=_p(Status.PARTIAL, "approx"),
                    ms=300, amplitude_px=3),
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "r"), ms=1000),
    ]
    result = map_cinematic(_cine(events))
    text = result.lua_text

    # A canonical PMDO call must appear for every event kind above.
    for token in (
        "GAME:PlayBGM",
        "GAME:FadeOutBGM",
        "SOUND:PlayBattleSE",
        "SV.new_era.flags",           # SetFlag path
        "while true do",              # WaitFlag polling loop
        "UI:WaitShowDialogue",
        "SCREEN:FadeOut(false,",      # fade to black
        "SCREEN:FadeIn(false,",       # fade to white / flash
        "SCREEN:Shake(",
        "GAME:WaitFrames(",
    ):
        assert token in text, f"missing PMDO API call in output: {token!r}"

    summary = result.summary()
    assert summary["total_events"] == len(events)
    # We produced no UNKNOWN; expect PARTIAL aggregate reason (contains
    # counts of documented losses).
    assert result.provenance.status is Status.PARTIAL
    assert result.provenance.status_reason


def test_mapper_preserves_unknown_opcodes_verbatim() -> None:
    raw = bytes(range(16))
    events = [
        UnknownOpcode(
            kind="unknown_opcode",
            provenance=_p(Status.UNKNOWN, "not in translation table"),
            opcode=0x99, raw=raw,
        ),
    ]
    result = map_cinematic(_cine(events))
    text = result.lua_text
    assert "-- UNKNOWN SSB opcode 0x99" in text
    # Every source byte appears as two hex digits in the generated
    # comment so a later run can lift the opcode without losing data.
    for b in raw:
        assert f"{b:02x}" in text
    assert result.provenance.status is Status.UNKNOWN
    assert result.provenance.status_reason


# ---------------------------------------------------------------- parse


def test_generated_lua_parses(tmp_path: Path) -> None:
    events = [
        PlayBGM(kind="play_bgm", provenance=_p(Status.PARTIAL, "r"),
                track_id="BGM_00AA"),
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "r"), ms=500),
        DialogueShow(kind="dialogue_show", provenance=_p(Status.PARTIAL, "r"),
                     string_key="MSG_00CC"),
        DialogueClose(kind="dialogue_close", provenance=_p()),
    ]
    result = map_cinematic(_cine(events), scene_module_name="test_scene")
    out = tmp_path / "test_scene.lua"
    out.write_text(result.lua_text, encoding="utf-8")

    ok, reason = check_file(out)
    if not ok and shutil.which("luac") is None:
        # Heuristic-only environment: at minimum, keyword balance must
        # hold. If even that fails, the mapper is broken.
        pytest.fail(f"Lua heuristic imbalance: {reason}")
    assert ok, f"Lua parse failed: {reason}"


def test_ms_to_frames_rounds_correctly() -> None:
    events = [
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "r"), ms=1000),   # 60
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "r"), ms=16),     # 1
        Wait(kind="wait", provenance=_p(Status.PARTIAL, "r"), ms=0),      # 0
    ]
    text = map_cinematic(_cine(events)).lua_text
    assert "GAME:WaitFrames(60)" in text
    assert "GAME:WaitFrames(1)" in text
    assert "GAME:WaitFrames(0)" in text
