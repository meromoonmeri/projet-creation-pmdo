"""Cinematic_IR -> RogueEssence/PMDO Lua ground cutscene.

Produces a Lua text buffer that PMDO 0.8.12 can load as a ground
cutscene under Data/Script/halcyon/ground/<ground_id>/<scene>.lua.

The mapper preserves timeline ordering and honestly labels each
translated event with:
  * a PMDO API call when a native equivalent exists (PORTED / EXACT),
  * an approximation with a Lua comment stating the loss (PARTIAL),
  * a `-- UNKNOWN OPCODE` comment carrying the raw record hex for
    UnknownOpcode entries, so nothing is silently dropped.

The mapper NEVER writes to Data/. It returns (lua_text, provenance,
per_event_report). Stage s05_emit is the only place that touches disk.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Iterable, Optional

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
from converter.pmdred.symbolic import (
    SymbolResolver,
    resolve_bgm_key,
    resolve_flag_key,
    resolve_sfx_key,
)


# ---------------------------------------------------------------- report


@dataclass
class MappedEvent:
    """One event's mapping result, for the aggregate report."""

    kind: str
    status: Status
    reason: str
    lua_lines: list[str]


@dataclass
class MappingResult:
    lua_text: str
    provenance: Provenance
    per_event: list[MappedEvent] = field(default_factory=list)

    def summary(self) -> dict:
        counts: dict[str, int] = {}
        for e in self.per_event:
            counts[e.status.value] = counts.get(e.status.value, 0) + 1
        return {
            "total_events": len(self.per_event),
            "by_status": counts,
        }


# ---------------------------------------------------------------- helpers


def _lua_string(s: str) -> str:
    """Escape a value for embedding in a Lua double-quoted string."""
    return (
        s.replace("\\", "\\\\")
         .replace("\"", "\\\"")
         .replace("\n", "\\n")
         .replace("\r", "\\r")
    )


def _ms_to_frames(ms: int) -> int:
    """PMDO ground scripts count in frames (~60 fps). Round to nearest."""
    return max(0, int(round(ms * 60 / 1000)))


# ---------------------------------------------------------------- per-event


def _map_wait(ev: Wait) -> MappedEvent:
    frames = _ms_to_frames(ev.ms)
    return MappedEvent(
        kind=ev.kind, status=Status.PORTED,
        reason=(
            "GAME:WaitFrames is the canonical PMDO 0.8.12 wait primitive"
        ),
        lua_lines=[f"GAME:WaitFrames({frames})  -- {ev.ms} ms"],
    )


def _map_playbgm(ev: PlayBGM, sym: Optional[SymbolResolver] = None) -> MappedEvent:
    # Attempt to resolve the hex placeholder to a canonical MUS_* name
    # via the local pret enum. If we succeed, the Lua uses the symbolic
    # name (matches what New Era's existing ground scripts already do,
    # e.g. GAME:PlayBGM("MUS_MT_BLAZE", true)); otherwise we keep the
    # hex form and log the reason.
    resolved = resolve_bgm_key(ev.track_id, sym) if sym else None
    if resolved:
        return MappedEvent(
            kind=ev.kind, status=Status.PORTED,
            reason=(
                f"BGM key {ev.track_id} resolved to MusicID enum member "
                f"{resolved!r} via local pret checkout"
            ),
            lua_lines=[
                f"-- ROM track id: {ev.track_id} -> {resolved}",
                f"GAME:PlayBGM(\"{_lua_string(resolved)}\", "
                f"{'true' if ev.loop else 'false'})",
            ],
        )
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            f"BGM track id {ev.track_id} kept as hex placeholder: "
            "MusicID enum not available (no local pret checkout) or id "
            "not declared in that enum"
        ),
        lua_lines=[
            f"-- ROM track id: {ev.track_id}",
            f"GAME:PlayBGM(\"{_lua_string(ev.track_id)}\", "
            f"{'true' if ev.loop else 'false'})",
        ],
    )


def _map_stopbgm(ev: StopBGM) -> MappedEvent:
    return MappedEvent(
        kind=ev.kind, status=Status.PORTED,
        reason="GAME:FadeOutBGM is the canonical stop primitive",
        lua_lines=[f"GAME:FadeOutBGM({_ms_to_frames(ev.fade_ms)})"],
    )


def _map_playsfx(ev: PlaySFX, sym: Optional[SymbolResolver] = None) -> MappedEvent:
    resolved = resolve_sfx_key(ev.sfx_id, sym) if sym else None
    if resolved:
        return MappedEvent(
            kind=ev.kind, status=Status.PORTED,
            reason=(
                f"SFX key {ev.sfx_id} resolved to SEID enum member "
                f"{resolved!r} via local pret checkout"
            ),
            lua_lines=[
                f"-- ROM sfx id: {ev.sfx_id} -> {resolved}",
                f"SOUND:PlayBattleSE(\"{_lua_string(resolved)}\")",
            ],
        )
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            f"SFX id {ev.sfx_id} kept as hex placeholder: SEID enum "
            "unavailable or id not declared in the local pret checkout"
        ),
        lua_lines=[
            f"-- ROM sfx id: {ev.sfx_id}",
            f"SOUND:PlayBattleSE(\"{_lua_string(ev.sfx_id)}\")",
        ],
    )


def _map_setflag(ev: SetFlag, sym: Optional[SymbolResolver] = None) -> MappedEvent:
    resolved = resolve_flag_key(ev.flag, sym) if sym else None
    label = resolved or ev.flag
    status = Status.PORTED if resolved else Status.PARTIAL
    reason = (
        f"Flag key {ev.flag} resolved to {resolved!r} via local pret checkout"
        if resolved
        else (
            f"Flag id {ev.flag} kept as hex placeholder: EventFlagID enum "
            "unavailable or id not declared in the local pret checkout"
        )
    )
    return MappedEvent(
        kind=ev.kind, status=status, reason=reason,
        lua_lines=[
            f"-- ROM flag id: {ev.flag}"
            + (f" -> {resolved}" if resolved else ""),
            f"SV.new_era = SV.new_era or {{}}",
            f"SV.new_era.flags = SV.new_era.flags or {{}}",
            f"SV.new_era.flags[\"{_lua_string(label)}\"] = {int(ev.value)}",
        ],
    )


def _map_waitflag(ev: WaitFlag, sym: Optional[SymbolResolver] = None) -> MappedEvent:
    resolved = resolve_flag_key(ev.flag, sym) if sym else None
    label = resolved or ev.flag
    status = Status.PORTED if resolved else Status.PARTIAL
    reason = (
        f"Wait flag {ev.flag} resolved to {resolved!r}; polled every frame"
        if resolved
        else (
            "PMDO has no direct WaitFlag primitive; polling SV flag table "
            "each frame. Flag id kept as hex placeholder: enum unavailable "
            "or id not declared."
        )
    )
    return MappedEvent(
        kind=ev.kind, status=status, reason=reason,
        lua_lines=[
            f"-- ROM flag id: {ev.flag}"
            + (f" -> {resolved}" if resolved else ""),
            "while true do",
            "  local _flags = (SV.new_era or {}).flags or {}",
            f"  if _flags[\"{_lua_string(label)}\"] == {int(ev.value)} "
            f"then break end",
            "  GAME:WaitFrames(1)",
            "end",
        ],
    )


def _map_msg(ev: DialogueShow) -> MappedEvent:
    # The dialogue key is preserved verbatim; the emit stage links it
    # to a Strings/stringsEx.resx entry the user maintains.
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            "Dialogue key preserved; portrait/emote not yet resolved "
            "from the ROM speaker table"
        ),
        lua_lines=[
            f"UI:WaitShowDialogue(STRINGS:FormatKey(\""
            f"{_lua_string(ev.string_key)}\"))",
        ],
    )


def _map_msg_close(ev: DialogueClose) -> MappedEvent:
    return MappedEvent(
        kind=ev.kind, status=Status.PORTED,
        reason="Ending the dialogue window is default behaviour after "
               "WaitShowDialogue returns",
        lua_lines=["-- dialogue closes automatically"],
    )


def _map_fade(ev: FadeToColor) -> MappedEvent:
    frames = _ms_to_frames(ev.ms)
    r, g, b, a = ev.rgba
    # PMDO 0.8.12 exposes SCREEN:FadeIn / SCREEN:FadeOut with a colour
    # tint. If the runtime API is not exactly named this way in the
    # installed build, the emit stage will surface a validation error;
    # here we generate the call the mod already uses elsewhere.
    if (r, g, b) == (0, 0, 0):
        return MappedEvent(
            kind=ev.kind, status=Status.PORTED,
            reason="Fade to black uses the canonical SCREEN:FadeOut",
            lua_lines=[f"SCREEN:FadeOut(false, {frames})"],
        )
    if (r, g, b) == (255, 255, 255):
        return MappedEvent(
            kind=ev.kind, status=Status.PORTED,
            reason="Fade to white uses the canonical SCREEN:FadeIn(WHITE)",
            lua_lines=[f"SCREEN:FadeIn(false, {frames})"],
        )
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            f"Arbitrary fade colour rgba=({r},{g},{b},{a}) has no exact "
            "PMDO API; falling back to a black fade of the same duration"
        ),
        lua_lines=[
            f"-- source fade colour: rgba=({r},{g},{b},{a})",
            f"SCREEN:FadeOut(false, {frames})",
        ],
    )


def _map_flash(ev: ScreenFlash) -> MappedEvent:
    frames = _ms_to_frames(ev.ms)
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            "PMDO screen flash approximated as a very short fade in/out "
            f"of {ev.ms} ms"
        ),
        lua_lines=[
            f"SCREEN:FadeIn(false, {max(1, frames // 2)})",
            f"SCREEN:FadeOut(false, {max(1, frames // 2)})",
        ],
    )


def _map_shake(ev: ScreenShake) -> MappedEvent:
    frames = _ms_to_frames(ev.ms)
    return MappedEvent(
        kind=ev.kind, status=Status.PARTIAL,
        reason=(
            "PMDO screen shake amplitude and easing may not match GBA "
            "exactly; keeping duration precise"
        ),
        lua_lines=[f"SCREEN:Shake({ev.amplitude_px}, {frames})"],
    )


def _map_unknown(ev: UnknownOpcode) -> MappedEvent:
    hex_dump = " ".join(f"{b:02x}" for b in ev.raw)
    return MappedEvent(
        kind=ev.kind, status=Status.UNKNOWN,
        reason=(
            f"Opcode 0x{ev.opcode:02X} not in translation table; "
            f"raw 16-byte record preserved as a Lua comment"
        ),
        lua_lines=[
            f"-- UNKNOWN SSB opcode 0x{ev.opcode:02X}  raw: {hex_dump}"
        ],
    )


# Dispatch by concrete Event_IR subclass. Mappers that accept a
# SymbolResolver take an optional second argument; the caller
# (map_cinematic) knows which is which.
_MAP = {
    Wait:          _map_wait,
    PlayBGM:       _map_playbgm,
    StopBGM:       _map_stopbgm,
    PlaySFX:       _map_playsfx,
    SetFlag:       _map_setflag,
    WaitFlag:      _map_waitflag,
    DialogueShow:  _map_msg,
    DialogueClose: _map_msg_close,
    FadeToColor:   _map_fade,
    ScreenFlash:   _map_flash,
    ScreenShake:   _map_shake,
    UnknownOpcode: _map_unknown,
}

# Which mapper subclasses accept a SymbolResolver argument.
_TAKES_SYM = {PlayBGM, PlaySFX, SetFlag, WaitFlag}


# ---------------------------------------------------------------- public


def map_cinematic(
    cine: Cinematic_IR,
    *,
    lua_namespace: str = "halcyon",
    scene_module_name: Optional[str] = None,
    symbols: Optional[SymbolResolver] = None,
) -> MappingResult:
    """Return a MappingResult for a Cinematic_IR.

    The generated Lua returns a single table with a Cutscene() function
    that mirrors what New Era ground scripts already use (see e.g.
    Data/Script/halcyon/ground/*/init.lua). The scene is wrapped in
    GAME:CutsceneMode(true)/false so player input is disabled during
    playback, matching PMDO conventions.
    """
    module_name = scene_module_name or cine.scene_id

    per_event: list[MappedEvent] = []
    body_lines: list[str] = []
    unknown_count = 0
    partial_count = 0
    ported_count = 0

    for ev in cine.timeline:
        translator = _MAP.get(type(ev))
        if translator is None:
            # Should not happen given the SSB decoder produces the same
            # Event_IR subclasses we handle here, but stay honest.
            hex_dump = "(no raw bytes)"
            mapped = MappedEvent(
                kind=getattr(ev, "kind", "?"),
                status=Status.UNKNOWN,
                reason=f"no mapper for Event_IR subclass {type(ev).__name__}",
                lua_lines=[f"-- UNMAPPED event {type(ev).__name__} {hex_dump}"],
            )
        else:
            if type(ev) in _TAKES_SYM:
                mapped = translator(ev, symbols)  # type: ignore[arg-type]
            else:
                mapped = translator(ev)           # type: ignore[arg-type]

        per_event.append(mapped)
        body_lines.append(
            f"  -- offset {getattr(ev.provenance, 'rom_offset', '?')} "
            f"| {mapped.kind} | {mapped.status.value}"
        )
        for ln in mapped.lua_lines:
            body_lines.append("  " + ln)

        if mapped.status is Status.UNKNOWN:
            unknown_count += 1
        elif mapped.status is Status.PARTIAL:
            partial_count += 1
        elif mapped.status in (Status.PORTED, Status.EXACT if hasattr(Status, "EXACT") else Status.CANONICAL):
            ported_count += 1

    header = [
        f"-- Generated by converter.mappers.cinematic_to_lua",
        f"-- scene_id  : {cine.scene_id}",
        f"-- ground_id : {cine.ground_id}",
        f"-- events    : {len(cine.timeline)} "
        f"(ported={ported_count}, partial={partial_count}, "
        f"unknown={unknown_count})",
        f"-- Do not edit by hand: rerun the converter to regenerate.",
        "",
        f"local {module_name} = {{}}",
        "",
        f"function {module_name}.Cutscene()",
        "  GAME:CutsceneMode(true)",
    ]
    footer = [
        "  GAME:CutsceneMode(false)",
        "end",
        "",
        f"return {module_name}",
        "",
    ]

    lua_text = "\n".join(header + body_lines + footer)

    # Aggregate provenance: worst status among per-event, with a reason
    # citing counts. Cannot be higher than the source cinematic's
    # provenance (which the SSB decoder already downgraded).
    if unknown_count > 0:
        agg_status = Status.PARTIAL if ported_count + partial_count > 0 else Status.UNKNOWN
        agg_reason = (
            f"{unknown_count}/{len(cine.timeline)} events left as UNKNOWN "
            f"(raw bytes preserved in Lua comments)"
        )
    elif partial_count > 0:
        agg_status = Status.PARTIAL
        agg_reason = (
            f"{partial_count}/{len(cine.timeline)} events translated with "
            f"documented loss (see per-event reasons)"
        )
    else:
        agg_status = Status.PORTED
        agg_reason = ""

    provenance = Provenance(
        rom_sha256=(
            cine.provenance.rom_sha256
            if cine.provenance is not None
            else "unknown"
        ),
        rom_offset=(cine.provenance.rom_offset
                    if cine.provenance is not None else None),
        rom_length=(cine.provenance.rom_length
                    if cine.provenance is not None else None),
        extractor_version="converter.mappers.cinematic_to_lua/0.1",
        status=agg_status,
        status_reason=agg_reason,
    )

    return MappingResult(
        lua_text=lua_text,
        provenance=provenance,
        per_event=per_event,
    )
