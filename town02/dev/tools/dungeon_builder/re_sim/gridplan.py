"""GridPlan port (RogueElements/MapGen/Grid/GridPlan.cs).

Reproduces the grid layer that RogueElements uses for `GridFloorGen`:
cells, rooms occupying one or more cells, and halls between adjacent cells.
`place_rooms_on_floor` mirrors `GridPlan.PlaceRoomsOnFloor` +
`ChooseRoomBounds` + `ChooseHallBounds` closely enough to measure the
resulting topology (rooms, halls, branches, loops, dead ends).
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

from .geometry import DIR_LOC, LEFT, REVERSE, Rect, RIGHT, UP, DOWN, VALID_DIR4, is_vert
from .rooms import RoomGen


@dataclass
class GridRoomPlan:
    bounds: Rect  # in cell coordinates
    gen: RoomGen
    prefer_hall: bool = False
    components: Tuple[str, ...] = ()

    @property
    def start(self) -> Tuple[int, int]:
        return self.bounds.x, self.bounds.y


@dataclass
class HallPlan:
    rect: Rect
    from_room: int
    to_room: int


@dataclass
class FloorPlan:
    width: int
    height: int
    rooms: List[Rect] = field(default_factory=list)
    room_is_hall: List[bool] = field(default_factory=list)
    halls: List[HallPlan] = field(default_factory=list)


class GridPlan:
    def __init__(self) -> None:
        self.grid_w = 0
        self.grid_h = 0
        self.width_per_cell = 0
        self.height_per_cell = 0
        self.cell_wall = 1
        self.rooms_at: List[List[int]] = []
        self.vhalls: Dict[Tuple[int, int], bool] = {}
        self.hhalls: Dict[Tuple[int, int], bool] = {}
        self.array_rooms: List[GridRoomPlan] = []

    # -- init ---------------------------------------------------------
    def init_size(self, w: int, h: int, width_per_cell: int, height_per_cell: int, cell_wall: int = 1) -> None:
        if cell_wall < 1:
            raise ValueError("Cannot init a grid with cell wall < 1")
        self.grid_w, self.grid_h = w, h
        self.width_per_cell = width_per_cell
        self.height_per_cell = height_per_cell
        self.cell_wall = cell_wall
        self.clear()

    def clear(self) -> None:
        self.rooms_at = [[-1] * self.grid_h for _ in range(self.grid_w)]
        self.vhalls = {}
        self.hhalls = {}
        self.array_rooms = []

    @property
    def size(self) -> Tuple[int, int]:
        return (
            self.grid_w * (self.width_per_cell + self.cell_wall) - self.cell_wall,
            self.grid_h * (self.height_per_cell + self.cell_wall) - self.cell_wall,
        )

    @property
    def room_count(self) -> int:
        return len(self.array_rooms)

    # -- rooms --------------------------------------------------------
    def in_bounds(self, x: int, y: int) -> bool:
        return 0 <= x < self.grid_w and 0 <= y < self.grid_h

    def get_room_index(self, x: int, y: int) -> int:
        if not self.in_bounds(x, y):
            return -1
        return self.rooms_at[x][y]

    def get_room_plan(self, x: int, y: int) -> Optional[GridRoomPlan]:
        idx = self.get_room_index(x, y)
        return self.array_rooms[idx] if idx > -1 else None

    def can_add_room(self, rect: Rect) -> bool:
        if rect.x < 0 or rect.y < 0 or rect.end_x > self.grid_w or rect.end_y > self.grid_h:
            return False
        for xx, yy in rect.tiles():
            if self.rooms_at[xx][yy] != -1:
                return False
            if xx > rect.x and self.hhalls.get((xx - 1, yy)):
                return False
            if yy > rect.y and self.vhalls.get((xx, yy - 1)):
                return False
        return True

    def add_room(self, rect: Rect, gen: RoomGen, prefer_hall: bool = False, components: Tuple[str, ...] = ()) -> None:
        if not self.can_add_room(rect):
            raise ValueError("Tried to add on top of an existing room/hall!")
        plan = GridRoomPlan(rect, gen.copy(), prefer_hall, components)
        self.array_rooms.append(plan)
        idx = len(self.array_rooms) - 1
        for xx, yy in rect.tiles():
            self.rooms_at[xx][yy] = idx

    def add_cell_room(self, x: int, y: int, gen: RoomGen, prefer_hall: bool = False,
                      components: Tuple[str, ...] = ()) -> None:
        self.add_room(Rect(x, y, 1, 1), gen, prefer_hall, components)

    # -- halls --------------------------------------------------------
    def _hall_slot(self, x: int, y: int, direction: str):
        if direction == DOWN:
            return ("V", x, y)
        if direction == UP:
            return ("V", x, y - 1)
        if direction == RIGHT:
            return ("H", x, y)
        if direction == LEFT:
            return ("H", x - 1, y)
        raise ValueError(direction)

    def set_hall(self, x: int, y: int, direction: str, on: bool = True) -> bool:
        kind, hx, hy = self._hall_slot(x, y, direction)
        if kind == "V":
            if not (0 <= hx < self.grid_w and 0 <= hy < self.grid_h - 1):
                return False
            self.vhalls[(hx, hy)] = on
        else:
            if not (0 <= hx < self.grid_w - 1 and 0 <= hy < self.grid_h):
                return False
            self.hhalls[(hx, hy)] = on
        return True

    def get_hall(self, x: int, y: int, direction: str) -> bool:
        kind, hx, hy = self._hall_slot(x, y, direction)
        table = self.vhalls if kind == "V" else self.hhalls
        return bool(table.get((hx, hy)))

    def get_adjacent_rooms(self, room_index: int) -> List[int]:
        """Port of GridPlan.GetAdjacentRooms (rooms reachable through a hall)."""
        out: List[int] = []
        room = self.array_rooms[room_index]
        b = room.bounds
        for ii in range(b.w):
            for cell_y, direction in ((b.y, UP), (b.end_y - 1, DOWN)):
                idx = self.room_index_through_hall(b.x + ii, cell_y, direction)
                if idx > -1 and idx not in out:
                    out.append(idx)
        for ii in range(b.h):
            for cell_x, direction in ((b.x, LEFT), (b.end_x - 1, RIGHT)):
                idx = self.room_index_through_hall(cell_x, b.y + ii, direction)
                if idx > -1 and idx not in out:
                    out.append(idx)
        return out

    def room_index_through_hall(self, x: int, y: int, direction: str) -> int:
        if not self.get_hall(x, y, direction):
            return -1
        dx, dy = DIR_LOC[direction]
        return self.get_room_index(x + dx, y + dy)

    # -- bounds -------------------------------------------------------
    def cell_bounds(self, bounds: Rect) -> Rect:
        return Rect(
            bounds.x * (self.width_per_cell + self.cell_wall),
            bounds.y * (self.height_per_cell + self.cell_wall),
            bounds.w * (self.width_per_cell + self.cell_wall) - self.cell_wall,
            bounds.h * (self.height_per_cell + self.cell_wall) - self.cell_wall,
        )

    def choose_room_bounds(self, rand: random.Random, plan: GridRoomPlan) -> None:
        w, h = plan.gen.propose_size(rand)
        cell = self.cell_bounds(plan.bounds)
        w = min(w, cell.w)
        h = min(h, cell.h)
        if plan.prefer_hall:
            # RoomGenDefault occupies a single tile inside its cell.
            w, h = 1, 1
        x = cell.x + rand.randrange(cell.w - w + 1)
        y = cell.y + rand.randrange(cell.h - h + 1)
        plan.gen.prepare(x, y, w, h)

    def place_rooms_on_floor(self, rand: random.Random) -> FloorPlan:
        """Port of GridPlan.PlaceRoomsOnFloor: fixes every room/hall rectangle."""
        for plan in self.array_rooms:
            self.choose_room_bounds(rand, plan)

        w, h = self.size
        floor = FloorPlan(w, h)
        for plan in self.array_rooms:
            floor.rooms.append(plan.gen.draw)
            floor.room_is_hall.append(plan.prefer_hall)

        for (hx, hy), on in sorted(self.vhalls.items()):
            if not on:
                continue
            self._add_hall(floor, hx, hy, vertical=True)
        for (hx, hy), on in sorted(self.hhalls.items()):
            if not on:
                continue
            self._add_hall(floor, hx, hy, vertical=False)
        return floor

    def _add_hall(self, floor: FloorPlan, hx: int, hy: int, vertical: bool) -> None:
        if vertical:
            a = self.get_room_index(hx, hy)
            b = self.get_room_index(hx, hy + 1)
        else:
            a = self.get_room_index(hx, hy)
            b = self.get_room_index(hx + 1, hy)
        if a < 0 or b < 0 or a == b:
            return
        ra = self.array_rooms[a].gen.draw
        rb = self.array_rooms[b].gen.draw
        if vertical:
            rect = Rect(min(ra.x, rb.x), ra.end_y, max(ra.end_x, rb.end_x) - min(ra.x, rb.x), rb.y - ra.end_y)
        else:
            rect = Rect(ra.end_x, min(ra.y, rb.y), rb.x - ra.end_x, max(ra.end_y, rb.end_y) - min(ra.y, rb.y))
        floor.halls.append(HallPlan(rect, a, b))
