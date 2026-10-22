"""Cinematic_IR: neutral representation of a scripted scene.

A cinematic in PMD Red is a timeline of engine events (music switch,
camera move, entity spawn/move/face/action, dialogue with portrait,
fade, wait, flag set, warp) triggered by an SSB script attached to a
ground. We model every event kind we can prove from the ROM (or from
pret/pmd-red macro decompilation) and preserve unknown opcodes verbatim
so nothing is silently dropped.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional, Union

from converter.ir.provenance import Provenance


# -----------------------------------------------------------------------------
# Triggers and conditions
# -----------------------------------------------------------------------------

@dataclass
class Trigger_IR:
    """When a scene fires. Multiple triggers OR together."""

    kind: str                        # "first_visit" | "step_on" | "interact"
                                     # | "on_ground_load" | "on_flag" | "always"
    payload: dict                    # kind-specific data (flag id, box coords…)


@dataclass
class Condition_IR:
    """A precondition on scene execution. All conditions AND together."""

    kind: str                        # "flag_eq" | "flag_neq" | "progress_gte"
    left: str
    op: str
    right: Union[int, str, bool]


# -----------------------------------------------------------------------------
# Timeline events — one dataclass per opcode family we understand.
# Every event carries an rom_offset field via provenance so we can point
# at the exact ROM byte range it came from.
# -----------------------------------------------------------------------------

@dataclass
class Event_IR:
    """Common base. Concrete subclasses set `kind` and specific fields."""

    kind: str                        # short opcode label
    provenance: Provenance
    # Optional label to allow other events to jump/wait on this one.
    label: Optional[str] = None


@dataclass
class PlayBGM(Event_IR):
    track_id: str = ""               # canonical ROM music constant
    loop: bool = True
    fade_ms: int = 0


@dataclass
class StopBGM(Event_IR):
    fade_ms: int = 0


@dataclass
class PlaySFX(Event_IR):
    sfx_id: str = ""


@dataclass
class CameraGoto(Event_IR):
    x_tiles: int = 0
    y_tiles: int = 0
    speed_tps: float = 0.0           # 0 = instant


@dataclass
class CameraFollow(Event_IR):
    entity_ref: str = ""


@dataclass
class EntitySpawn(Event_IR):
    entity_ref: str = ""
    x_tiles: int = 0
    y_tiles: int = 0
    facing: str = "S"


@dataclass
class EntityDespawn(Event_IR):
    entity_ref: str = ""


@dataclass
class EntityMove(Event_IR):
    entity_ref: str = ""
    waypoints: list[tuple[int, int]] = field(default_factory=list)
    speed_tps: float = 4.0
    animate: bool = True


@dataclass
class EntityFace(Event_IR):
    entity_ref: str = ""
    facing: str = "S"


@dataclass
class EntityAction(Event_IR):
    entity_ref: str = ""
    action_id: int = 0               # ROM animation index, preserved raw


@dataclass
class DialogueShow(Event_IR):
    string_key: str = ""             # e.g. "SCENE_D01P02_001"
    portrait_species: Optional[str] = None
    portrait_emote: Optional[str] = None
    wait_for_input: bool = True


@dataclass
class DialogueClose(Event_IR):
    pass


@dataclass
class FadeToColor(Event_IR):
    rgba: tuple[int, int, int, int] = (0, 0, 0, 255)
    ms: int = 500


@dataclass
class ScreenFlash(Event_IR):
    rgba: tuple[int, int, int, int] = (255, 255, 255, 255)
    ms: int = 120


@dataclass
class ScreenShake(Event_IR):
    ms: int = 300
    amplitude_px: int = 2


@dataclass
class Wait(Event_IR):
    ms: int = 0


@dataclass
class SetFlag(Event_IR):
    flag: str = ""
    value: int = 1


@dataclass
class WaitFlag(Event_IR):
    flag: str = ""
    value: int = 1


@dataclass
class WarpToGround(Event_IR):
    dest_ground: str = ""
    spawn_id: Optional[str] = None
    dest_x: Optional[int] = None
    dest_y: Optional[int] = None
    dest_facing: Optional[str] = None
    transition: str = "cut"          # "cut" | "fade_black" | "fade_white"


@dataclass
class UnknownOpcode(Event_IR):
    """We do not silently drop opcodes we cannot yet decode. We keep
    the raw bytes and the ROM offset so a later run of the converter
    can lift them."""

    opcode: int = 0
    raw: bytes = b""


# -----------------------------------------------------------------------------
# Cinematic container
# -----------------------------------------------------------------------------

@dataclass
class Cinematic_IR:
    scene_id: str                    # e.g. "d01p02_arrival"
    ground_id: str                   # e.g. "d01p02"
    triggers: list[Trigger_IR] = field(default_factory=list)
    preconditions: list[Condition_IR] = field(default_factory=list)
    timeline: list[Event_IR] = field(default_factory=list)
    post_effects: list[Event_IR] = field(default_factory=list)
    provenance: Optional[Provenance] = None
