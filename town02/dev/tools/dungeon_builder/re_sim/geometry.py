"""Geometry primitives mirroring RogueElements' Loc / Rect / Dir4.

Ported from RogueElements (MIT, audinowho) sources:
  RogueElements/Structures/Loc.cs, Rect.cs, Dir4.cs

This module is part of the *offline structural simulator* used by the Dungeon
Builder to validate generation parameters before they are emitted as real
RogueElements gen steps.  It is never used at runtime by the game.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterator, Tuple

UP, DOWN, LEFT, RIGHT = "Up", "Down", "Left", "Right"
VALID_DIR4 = (DOWN, LEFT, UP, RIGHT)

DIR_LOC = {UP: (0, -1), DOWN: (0, 1), LEFT: (-1, 0), RIGHT: (1, 0)}
REVERSE = {UP: DOWN, DOWN: UP, LEFT: RIGHT, RIGHT: LEFT}
VERT = {UP, DOWN}


def is_vert(direction: str) -> bool:
    return direction in VERT


@dataclass(frozen=True)
class Rect:
    x: int
    y: int
    w: int
    h: int

    @property
    def end_x(self) -> int:
        return self.x + self.w

    @property
    def end_y(self) -> int:
        return self.y + self.h

    @property
    def area(self) -> int:
        return self.w * self.h

    @property
    def center(self) -> Tuple[int, int]:
        return (self.x + self.w // 2, self.y + self.h // 2)

    def contains(self, px: int, py: int) -> bool:
        return self.x <= px < self.end_x and self.y <= py < self.end_y

    def tiles(self) -> Iterator[Tuple[int, int]]:
        for yy in range(self.y, self.end_y):
            for xx in range(self.x, self.end_x):
                yield xx, yy

    def side(self, vertical: bool) -> Tuple[int, int]:
        """Range of the side orthogonal to the travel axis (RogueElements Rect.GetSide)."""
        if vertical:
            return self.x, self.end_x
        return self.y, self.end_y
