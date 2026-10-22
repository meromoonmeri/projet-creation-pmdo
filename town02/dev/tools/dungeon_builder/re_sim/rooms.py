"""Room generators mirroring RogueElements' RoomGen family.

Ported behaviour from:
  RogueElements/MapGen/Rooms/RoomGen.cs      (ProposeSize / PrepareSize / DrawMapDefault)
  RogueElements/MapGen/Rooms/RoomGenSquare.cs
  RogueElements/MapGen/Rooms/RoomGenRound.cs (IsTileWithinRoom ellipse test)
  RogueElements/MapGen/Rooms/RoomGenCross.cs
  RogueElements/MapGen/Rooms/RoomGenCave.cs  (blob approximation)

Only the *structural* result (which tiles become floor) is reproduced; the
tile-terrain objects, stencils and border bookkeeping stay in the real engine.
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field
from typing import List, Tuple

from .geometry import Rect


@dataclass
class RandRange:
    """RogueElements.RandRange: inclusive Min, exclusive Max."""

    min: int
    max: int | None = None

    def __post_init__(self) -> None:
        if self.max is None:
            self.max = self.min + 1
        if self.max <= self.min:
            self.max = self.min + 1

    def pick(self, rand: random.Random) -> int:
        return rand.randrange(self.min, self.max)

    def to_json(self) -> dict:
        return {"Min": self.min, "Max": self.max}


@dataclass
class RoomGen:
    """Base structural room generator."""

    width: RandRange
    height: RandRange
    kind: str = "square"
    draw: Rect = field(default_factory=lambda: Rect(-1, -1, -1, -1))

    def copy(self) -> "RoomGen":
        return RoomGen(self.width, self.height, self.kind)

    def propose_size(self, rand: random.Random) -> Tuple[int, int]:
        return self.width.pick(rand), self.height.pick(rand)

    def prepare(self, x: int, y: int, w: int, h: int) -> None:
        self.draw = Rect(x, y, max(1, w), max(1, h))

    # --- drawing -----------------------------------------------------
    def tiles(self) -> List[Tuple[int, int]]:
        if self.kind == "round":
            return self._round_tiles()
        if self.kind == "cross":
            return self._cross_tiles()
        if self.kind == "cave":
            return self._cave_tiles()
        return list(self.draw.tiles())

    def _round_tiles(self) -> List[Tuple[int, int]]:
        d = self.draw
        diameter = min(d.w, d.h)
        out = []
        for jj in range(d.h):
            for ii in range(d.w):
                if _within_round(ii, jj, diameter, d.w, d.h):
                    out.append((d.x + ii, d.y + jj))
        return out or list(d.tiles())

    def _cross_tiles(self) -> List[Tuple[int, int]]:
        d = self.draw
        cut_x = max(1, d.w // 4)
        cut_y = max(1, d.h // 4)
        out = []
        for jj in range(d.h):
            for ii in range(d.w):
                in_v = cut_x <= ii < d.w - cut_x
                in_h = cut_y <= jj < d.h - cut_y
                if in_v or in_h:
                    out.append((d.x + ii, d.y + jj))
        return out or list(d.tiles())

    def _cave_tiles(self) -> List[Tuple[int, int]]:
        """RoomGenCave-like blob: erode random corners while keeping the core."""
        d = self.draw
        rand = random.Random((d.x * 7919) ^ (d.y * 104729) ^ (d.w * 31) ^ d.h)
        keep = {(d.x + ii, d.y + jj) for jj in range(d.h) for ii in range(d.w)}
        margin_x = max(1, d.w // 3)
        margin_y = max(1, d.h // 3)
        for _ in range((d.w * d.h) // 4):
            ii = rand.randrange(d.w)
            jj = rand.randrange(d.h)
            if margin_x <= ii < d.w - margin_x and margin_y <= jj < d.h - margin_y:
                continue
            edge = ii in (0, d.w - 1) or jj in (0, d.h - 1)
            if edge and rand.random() < 0.55:
                keep.discard((d.x + ii, d.y + jj))
        core = {
            (d.x + ii, d.y + jj)
            for jj in range(margin_y, max(margin_y + 1, d.h - margin_y))
            for ii in range(margin_x, max(margin_x + 1, d.w - margin_x))
        }
        blob = keep | core
        # RoomGenCave draws one contiguous blob: drop anything detached from the
        # core, otherwise a corridor could land on an island inside the room.
        stack = list(core)
        connected = set(core)
        while stack:
            x, y = stack.pop()
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nxt = (x + dx, y + dy)
                if nxt in blob and nxt not in connected:
                    connected.add(nxt)
                    stack.append(nxt)
        return sorted(connected)


def _within_round(base_x: int, base_y: int, diameter: int, w: int, h: int) -> bool:
    """Direct port of RoomGenRound.IsTileWithinRoom."""
    size_x2 = (w * 2, h * 2)
    x = (base_x * 2) + 1
    y = (base_y * 2) + 1
    if x < diameter:
        xdiff = diameter - x
        if y < diameter:
            ydiff = diameter - y
            return (xdiff * xdiff) + (ydiff * ydiff) < diameter * diameter
        if y > size_x2[1] - diameter:
            ydiff = y - (size_x2[1] - diameter)
            return (xdiff * xdiff) + (ydiff * ydiff) < diameter * diameter
        return True
    if x > size_x2[0] - diameter:
        xdiff = x - (size_x2[0] - diameter)
        if y < diameter:
            ydiff = diameter - y
            return (xdiff * xdiff) + (ydiff * ydiff) < diameter * diameter
        if y > size_x2[1] - diameter:
            ydiff = y - (size_x2[1] - diameter)
            return (xdiff * xdiff) + (ydiff * ydiff) < diameter * diameter
        return True
    return True
