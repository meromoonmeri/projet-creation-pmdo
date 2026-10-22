"""SSB (Scripted Sequence Bytecode) decoder for PMD Red.

Reads a raw byte blob laid out as a sequence of 16-byte ScriptCommand
records and returns a Cinematic_IR. The structural layout is public:

    struct ScriptCommand {          // 16 bytes total
        u8   op;                    // index into enum ScriptOpID
        u8   arg_byte;
        s16  arg_short;             // little-endian
        s32  arg1;                  // little-endian
        s32  arg2;                  // little-endian
        u32  arg_ptr;               // ARM ROM pointer or 0
    };

Opcode names are looked up **at run-time** in the local pret/pmd-red
checkout (dev/external/pret_pmd_red, git-ignored) via the ScriptOpID
enum. When pret is absent, opcodes are labelled OP_0x<hex>; when an
opcode name is present but unknown to our translation table, we still
emit a typed UnknownOpcode with the raw record bytes preserved.

Nothing here reads the ROM directly and nothing from pret is copied
into the repository.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field
from typing import Optional

from converter.aux_sources.pret import PretCheckout
from converter.ir.cinematic import (
    Cinematic_IR,
    DialogueClose,
    DialogueShow,
    Event_IR,
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


RECORD_SIZE = 16


# ---------------------------------------------------------------- record


@dataclass(frozen=True)
class ScriptRecord:
    """One decoded 16-byte ScriptCommand record.

    We keep the raw operand fields typed but not yet interpreted; the
    translation to Event_IR happens in a separate step so an unknown
    opcode never loses its operand bytes."""

    offset: int                 # blob-relative byte offset of this record
    op: int
    arg_byte: int
    arg_short: int
    arg1: int
    arg2: int
    arg_ptr: int
    op_name: str                # from pret enum, or "OP_0x<hex>" fallback


def _parse_records(
    blob: bytes,
    *,
    rom_offset_of_blob: int,
    op_names: dict[int, str],
) -> list[ScriptRecord]:
    """Slice `blob` into ScriptRecord instances until we hit an
    end-of-script marker or reach the end of the blob.

    We stop on:
      * end of blob,
      * an all-zero record (a common padding/terminator pattern used by
        many GBA script tables). Higher-level code can pre-slice the
        blob if a scene boundary is known externally.
    """
    out: list[ScriptRecord] = []
    n = len(blob)
    pos = 0
    while pos + RECORD_SIZE <= n:
        rec = blob[pos : pos + RECORD_SIZE]
        if rec == b"\x00" * RECORD_SIZE:
            # Zero record used as separator; stop here.
            break
        op, arg_byte, arg_short, arg1, arg2, arg_ptr = struct.unpack_from(
            "<BBhiiI", rec, 0
        )
        out.append(ScriptRecord(
            offset=rom_offset_of_blob + pos,
            op=op,
            arg_byte=arg_byte,
            arg_short=arg_short,
            arg1=arg1,
            arg2=arg2,
            arg_ptr=arg_ptr,
            op_name=op_names.get(op, f"OP_0x{op:02X}"),
        ))
        pos += RECORD_SIZE
    return out


# ---------------------------------------------------------------- events


def _prov(rom_sha256: str, offset: int, note: str,
          status: Status = Status.RECONSTRUCTED) -> Provenance:
    return Provenance(
        rom_sha256=rom_sha256,
        rom_offset=offset,
        rom_length=RECORD_SIZE,
        extractor_version="converter.decoders.ssb/0.1",
        status=status,
        status_reason=(
            ""
            if status in (Status.PORTED, Status.CANONICAL)
            else note
        ),
    )


# Mapping of pret ScriptOpID member NAMES to an event factory. We match
# on names, not on numeric ids, so that if pret ever reorders the enum
# our translator keeps working.
#
# Every factory receives the ScriptRecord and the ROM hash, and returns
# an Event_IR (or None if the operands look invalid and the caller
# should fall back to UnknownOpcode).
def _mk_wait(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    # arg_short = frame count on GBA (60 fps -> ms = frames * 1000 / 60)
    ms = int(round(rec.arg_short * 1000 / 60))
    return Wait(
        kind="wait", provenance=_prov(
            rom_sha256, rec.offset,
            f"frames->ms conversion (source frames={rec.arg_short})",
            status=Status.PARTIAL,
        ),
        ms=ms,
    )


def _mk_playbgm(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return PlayBGM(
        kind="play_bgm",
        provenance=_prov(rom_sha256, rec.offset,
                          "bgm id kept verbatim; asset resolution deferred",
                          status=Status.PARTIAL),
        track_id=f"BGM_{rec.arg_short:04X}",
        loop=True,
        fade_ms=0,
    )


def _mk_stopbgm(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return StopBGM(
        kind="stop_bgm",
        provenance=_prov(rom_sha256, rec.offset,
                          "fade time approximate from arg_byte",
                          status=Status.PARTIAL),
        fade_ms=int(round(rec.arg_byte * 1000 / 60)),
    )


def _mk_playsfx(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return PlaySFX(
        kind="play_sfx",
        provenance=_prov(rom_sha256, rec.offset,
                          "sfx id kept verbatim; asset resolution deferred",
                          status=Status.PARTIAL),
        sfx_id=f"SFX_{rec.arg_short:04X}",
    )


def _mk_setflag(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return SetFlag(
        kind="set_flag",
        provenance=_prov(rom_sha256, rec.offset,
                          "flag id numeric; symbolic name resolved later",
                          status=Status.PARTIAL),
        flag=f"FLAG_{rec.arg_short:04X}",
        value=rec.arg_byte,
    )


def _mk_waitflag(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return WaitFlag(
        kind="wait_flag",
        provenance=_prov(rom_sha256, rec.offset, "same as SetFlag",
                          status=Status.PARTIAL),
        flag=f"FLAG_{rec.arg_short:04X}",
        value=rec.arg_byte,
    )


def _mk_msg(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return DialogueShow(
        kind="dialogue_show",
        provenance=_prov(rom_sha256, rec.offset,
                          "string key derived from arg_short (numeric id); "
                          "portrait not yet resolved",
                          status=Status.PARTIAL),
        # ROM string ids are numeric; the emit stage maps them to
        # SCENE_<scene>_<n> keys in Strings/stringsEx.resx.
        string_key=f"MSG_{rec.arg_short:04X}",
        portrait_species=None,
        portrait_emote=None,
        wait_for_input=True,
    )


def _mk_msg_close(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return DialogueClose(
        kind="dialogue_close",
        provenance=_prov(rom_sha256, rec.offset, "trivial",
                          status=Status.PORTED),
    )


def _mk_fade_black(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    ms = int(round(rec.arg_short * 1000 / 60))
    return FadeToColor(
        kind="fade_to_black",
        provenance=_prov(rom_sha256, rec.offset,
                          f"fade duration frames={rec.arg_short}",
                          status=Status.PARTIAL),
        rgba=(0, 0, 0, 255),
        ms=ms,
    )


def _mk_fade_white(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    ms = int(round(rec.arg_short * 1000 / 60))
    return FadeToColor(
        kind="fade_to_white",
        provenance=_prov(rom_sha256, rec.offset,
                          f"fade duration frames={rec.arg_short}",
                          status=Status.PARTIAL),
        rgba=(255, 255, 255, 255),
        ms=ms,
    )


def _mk_flash(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return ScreenFlash(
        kind="screen_flash",
        provenance=_prov(rom_sha256, rec.offset,
                          "screen flash approximated as white burst",
                          status=Status.PARTIAL),
        rgba=(255, 255, 255, 255),
        ms=int(round(rec.arg_byte * 1000 / 60)),
    )


def _mk_shake(rec: ScriptRecord, rom_sha256: str) -> Event_IR:
    return ScreenShake(
        kind="screen_shake",
        provenance=_prov(rom_sha256, rec.offset,
                          "shake amplitude / duration from arg_byte / arg_short",
                          status=Status.PARTIAL),
        ms=int(round(rec.arg_short * 1000 / 60)),
        amplitude_px=max(1, rec.arg_byte),
    )


# Name-based translation table. Names come from pret's ScriptOpID enum
# (member NAMES only, which is public structural information — the
# names themselves are just identifiers of GBA script opcodes, not
# game content). If an opcode name is unknown to this table, the
# decoder emits UnknownOpcode with the raw record bytes.
_TRANSLATORS = {
    # Common name variants seen in the pret decompilation. Keeping a
    # loose set here means the decoder still works if pret renames a
    # member.
    "WAIT":              _mk_wait,
    "Wait":              _mk_wait,
    "PAUSE":             _mk_wait,
    "pause":             _mk_wait,

    "PLAY_MUSIC":        _mk_playbgm,
    "PlayMusic":         _mk_playbgm,
    "MUSIC_PLAY":        _mk_playbgm,

    "STOP_MUSIC":        _mk_stopbgm,
    "StopMusic":         _mk_stopbgm,

    "PLAY_SFX":          _mk_playsfx,
    "PlaySfx":           _mk_playsfx,
    "SE_PLAY":           _mk_playsfx,

    "SET_FLAG":          _mk_setflag,
    "SetFlag":           _mk_setflag,
    "setFlag":           _mk_setflag,
    "FLAG_SET":          _mk_setflag,

    "WAIT_FLAG":         _mk_waitflag,
    "WaitFlag":          _mk_waitflag,
    "waitFlag":          _mk_waitflag,

    "MSG":               _mk_msg,
    "MESSAGE":           _mk_msg,
    "MSG_INSTANT":       _mk_msg,
    "msgEnd":            _mk_msg,

    "MSG_CLOSE":         _mk_msg_close,
    "END_TALK":          _mk_msg_close,

    "FADE_IN":           _mk_fade_white,
    "FADE_OUT":          _mk_fade_black,
    "fadeColorIn":       _mk_fade_white,
    "fadeColorOut":      _mk_fade_black,

    "SCREEN_FLASH":      _mk_flash,
    "SCREEN_SHAKE":      _mk_shake,
}


# ---------------------------------------------------------------- API


@dataclass
class SsbDecodeStats:
    records_total: int = 0
    records_translated: int = 0
    records_unknown: int = 0
    unknown_opcode_ids: list[int] = field(default_factory=list)
    unknown_opcode_names: list[str] = field(default_factory=list)


def decode(
    blob: bytes,
    *,
    scene_id: str,
    ground_id: str,
    rom_sha256: str,
    rom_offset: int,
    pret: Optional[PretCheckout],
) -> tuple[Cinematic_IR, SsbDecodeStats]:
    """Decode a raw SSB blob into a Cinematic_IR + decode statistics.

    The caller is expected to have already sliced the blob to a single
    scene (e.g. up to the first zero record inside a per-scene payload).
    We still handle end-of-script markers defensively here.
    """
    # Build the id -> name map from the pret enum, if available.
    op_names: dict[int, str] = {}
    if pret is not None:
        e = pret.get_enum("ScriptOpID")
        if e is not None:
            op_names = {v: k for k, v in e.members.items()}

    records = _parse_records(
        blob, rom_offset_of_blob=rom_offset, op_names=op_names,
    )

    stats = SsbDecodeStats(records_total=len(records))
    timeline: list[Event_IR] = []
    for rec in records:
        translator = _TRANSLATORS.get(rec.op_name)
        if translator is None:
            timeline.append(UnknownOpcode(
                kind="unknown_opcode",
                provenance=_prov(
                    rom_sha256, rec.offset,
                    f"opcode name={rec.op_name!r} not in translation table",
                    status=Status.UNKNOWN,
                ),
                opcode=rec.op,
                raw=struct.pack(
                    "<BBhiiI",
                    rec.op, rec.arg_byte, rec.arg_short,
                    rec.arg1, rec.arg2, rec.arg_ptr,
                ),
            ))
            stats.records_unknown += 1
            if rec.op not in stats.unknown_opcode_ids:
                stats.unknown_opcode_ids.append(rec.op)
                stats.unknown_opcode_names.append(rec.op_name)
        else:
            try:
                timeline.append(translator(rec, rom_sha256))
                stats.records_translated += 1
            except Exception as exc:  # noqa: BLE001 -- never lose data
                timeline.append(UnknownOpcode(
                    kind="unknown_opcode",
                    provenance=_prov(
                        rom_sha256, rec.offset,
                        f"translator {rec.op_name} raised {exc!r}",
                        status=Status.UNKNOWN,
                    ),
                    opcode=rec.op,
                    raw=struct.pack(
                        "<BBhiiI",
                        rec.op, rec.arg_byte, rec.arg_short,
                        rec.arg1, rec.arg2, rec.arg_ptr,
                    ),
                ))
                stats.records_unknown += 1

    cine = Cinematic_IR(
        scene_id=scene_id,
        ground_id=ground_id,
        timeline=timeline,
        provenance=Provenance(
            rom_sha256=rom_sha256,
            rom_offset=rom_offset,
            rom_length=len(records) * RECORD_SIZE,
            extractor_version="converter.decoders.ssb/0.1",
            status=Status.PARTIAL,
            status_reason=(
                f"{stats.records_translated}/{stats.records_total} opcodes "
                f"translated; {stats.records_unknown} preserved as "
                f"UnknownOpcode records"
            ),
        ),
    )
    return cine, stats
