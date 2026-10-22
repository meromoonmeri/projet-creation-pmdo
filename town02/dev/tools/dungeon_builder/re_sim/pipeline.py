"""Floor drawing + metrics for the offline RogueElements simulator.

Mirrors the tile-level result of:
  RogueElements.DrawGridToFloorStep -> GridPlan.PlaceRoomsOnFloor
  RogueElements.DrawFloorToTileStep -> RoomGen.DrawOnMap / RoomGenAngledHall
  RogueElements.FloorStairsStep     -> entrance / exit placement with MinDistance
  RogueElements.DetectIsolatedStairsStep / EraseIsolatedStep -> connectivity check

The output is used for parameter validation, previews and the structural
non-repetition test.  The shipped dungeons are still generated in-engine by the
real RogueElements steps emitted by the builder.
"""
from __future__ import annotations

import hashlib
import random
from collections import deque
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence, Tuple

from .geometry import Rect
from .gridplan import FloorPlan, GridPlan

WALL, ROOM, HALL = 0, 1, 2


@dataclass
class FloorResult:
    tiles: List[List[int]]
    rooms: List[Rect]
    room_is_hall: List[bool]
    hall_edges: List[Tuple[int, int]]
    entrance: Optional[Tuple[int, int]] = None
    exit: Optional[Tuple[int, int]] = None
    seed: int = 0
    profile: str = ""
    grid: Tuple[int, int] = (0, 0)

    @property
    def width(self) -> int:
        return len(self.tiles[0]) if self.tiles else 0

    @property
    def height(self) -> int:
        return len(self.tiles)

    def ascii_art(self) -> str:
        glyphs = {WALL: "#", ROOM: ".", HALL: ","}
        rows = ["".join(glyphs[c] for c in row) for row in self.tiles]
        if self.entrance:
            x, y = self.entrance
            rows[y] = rows[y][:x] + "E" + rows[y][x + 1:]
        if self.exit:
            x, y = self.exit
            rows[y] = rows[y][:x] + "X" + rows[y][x + 1:]
        return "\n".join(rows)


def draw_floor(plan: GridPlan, floor: FloorPlan, rand: random.Random, hall_turn_bias: int = 50,
               profile: str = "", seed: int = 0) -> FloorResult:
    tiles = [[WALL] * floor.width for _ in range(floor.height)]

    room_tiles: List[set] = []
    for idx, rect in enumerate(floor.rooms):
        gen = plan.array_rooms[idx].gen
        drawn = set()
        for x, y in gen.tiles():
            if 0 <= x < floor.width and 0 <= y < floor.height:
                tiles[y][x] = ROOM
                drawn.add((x, y))
        room_tiles.append(drawn)

    edges: List[Tuple[int, int]] = []
    for hall in floor.halls:
        a = floor.rooms[hall.from_room]
        b = floor.rooms[hall.to_room]
        vertical = hall.rect.h > 0 and a.end_y <= b.y
        _dig_hall(tiles, a, b, vertical, rand, hall_turn_bias,
                  room_tiles[hall.from_room], room_tiles[hall.to_room])
        edges.append((hall.from_room, hall.to_room))

    result = FloorResult(tiles, list(floor.rooms), list(floor.room_is_hall), edges,
                         profile=profile, seed=seed, grid=(plan.grid_w, plan.grid_h))
    return result


def _dig_hall(tiles, a: Rect, b: Rect, vertical: bool, rand: random.Random, turn_bias: int,
              a_tiles: Optional[set] = None, b_tiles: Optional[set] = None) -> None:
    """Connect two rooms the way RoomGenAngledHall does: the corridor always
    starts and ends on a tile that really belongs to each room.

    RogueElements guarantees this through `AskBorderFromRoom` + `DigAtBorder`;
    reproducing it here matters, because rooms are not always rectangles (round,
    cross, cave) and a corridor aimed at a bounding box corner would connect to
    nothing.
    """
    h, w = len(tiles), len(tiles[0])
    a_tiles = a_tiles if a_tiles is not None else set(a.tiles())
    b_tiles = b_tiles if b_tiles is not None else set(b.tiles())

    def carve(x: int, y: int) -> None:
        if 0 <= x < w and 0 <= y < h and tiles[y][x] == WALL:
            tiles[y][x] = HALL

    if vertical:
        # rows -> the room's lowest / highest real tile in that column
        a_cols = {}
        for x, y in a_tiles:
            a_cols[x] = max(a_cols.get(x, -1), y)
        b_cols = {}
        for x, y in b_tiles:
            b_cols[x] = min(b_cols.get(x, 1 << 30), y)
        if not a_cols or not b_cols:
            return
        shared = sorted(set(a_cols) & set(b_cols))
        straight = shared and rand.randrange(100) >= turn_bias
        if straight:
            col = shared[rand.randrange(len(shared))]
            xa = xb = col
        else:
            xa = sorted(a_cols)[rand.randrange(len(a_cols))]
            xb = sorted(b_cols)[rand.randrange(len(b_cols))]
        y0, y1 = a_cols[xa] + 1, b_cols[xb] - 1
        if y1 < y0:
            return
        turn_y = y0 if xa == xb else rand.randrange(y0, y1 + 1)
        for y in range(y0, turn_y + 1):
            carve(xa, y)
        for x in range(min(xa, xb), max(xa, xb) + 1):
            carve(x, turn_y)
        for y in range(turn_y, y1 + 1):
            carve(xb, y)
    else:
        a_rows = {}
        for x, y in a_tiles:
            a_rows[y] = max(a_rows.get(y, -1), x)
        b_rows = {}
        for x, y in b_tiles:
            b_rows[y] = min(b_rows.get(y, 1 << 30), x)
        if not a_rows or not b_rows:
            return
        shared = sorted(set(a_rows) & set(b_rows))
        straight = shared and rand.randrange(100) >= turn_bias
        if straight:
            row = shared[rand.randrange(len(shared))]
            ya = yb = row
        else:
            ya = sorted(a_rows)[rand.randrange(len(a_rows))]
            yb = sorted(b_rows)[rand.randrange(len(b_rows))]
        x0, x1 = a_rows[ya] + 1, b_rows[yb] - 1
        if x1 < x0:
            return
        turn_x = x0 if ya == yb else rand.randrange(x0, x1 + 1)
        for x in range(x0, turn_x + 1):
            carve(x, ya)
        for y in range(min(ya, yb), max(ya, yb) + 1):
            carve(turn_x, y)
        for x in range(turn_x, x1 + 1):
            carve(x, yb)


def _dig_border(tiles, room: Rect, scalar: int, direction: str) -> None:
    """Port of RoomGen.DigAtBorder: tunnel inward until an open tile is met."""
    h, w = len(tiles), len(tiles[0])
    if direction == "down":
        pos = [(scalar, room.end_y - 1 - k) for k in range(room.h)]
    elif direction == "up":
        pos = [(scalar, room.y + k) for k in range(room.h)]
    elif direction == "right":
        pos = [(room.end_x - 1 - k, scalar) for k in range(room.w)]
    else:
        pos = [(room.x + k, scalar) for k in range(room.w)]
    for x, y in pos:
        if not (0 <= x < w and 0 <= y < h):
            return
        if tiles[y][x] != WALL:
            return
        tiles[y][x] = HALL


def _overlap(a0: int, a1: int, b0: int, b1: int):
    lo, hi = max(a0, b0), min(a1, b1)
    return (lo, hi) if hi > lo else None


# ---------------------------------------------------------------------------
def place_stairs(result: FloorResult, rand: random.Random, min_distance: int = 20) -> None:
    """Mirror of RogueElements.FloorStairsStep: two spots in distinct rooms."""
    candidates = [i for i, is_hall in enumerate(result.room_is_hall) if not is_hall]
    if len(candidates) < 2:
        candidates = list(range(len(result.rooms)))
    best = None
    for _ in range(60):
        a, b = rand.sample(candidates, 2) if len(candidates) >= 2 else (candidates[0], candidates[0])
        pa = _random_floor_in(result, result.rooms[a], rand)
        pb = _random_floor_in(result, result.rooms[b], rand)
        if pa is None or pb is None:
            continue
        dist = max(abs(pa[0] - pb[0]), abs(pa[1] - pb[1]))
        if best is None or dist > best[0]:
            best = (dist, pa, pb)
        if dist >= min_distance:
            break
    if best:
        result.entrance = best[1]
        result.exit = best[2]


def _random_floor_in(result: FloorResult, rect: Rect, rand: random.Random):
    spots = [(x, y) for x, y in rect.tiles()
             if 0 <= y < result.height and 0 <= x < result.width and result.tiles[y][x] != WALL]
    if not spots:
        return None
    return spots[rand.randrange(len(spots))]


# ---------------------------------------------------------------------------
@dataclass
class FloorMetrics:
    rooms: int = 0
    hall_cells: int = 0
    room_area_min: int = 0
    room_area_max: int = 0
    room_area_avg: float = 0.0
    large_rooms: int = 0
    halls: int = 0
    hall_tiles: int = 0
    connections: int = 0
    branches: int = 0
    dead_ends: int = 0
    loops: int = 0
    components: int = 0
    width: int = 0
    height: int = 0
    floor_tiles: int = 0
    walkable_ratio: float = 0.0
    reachable_ratio: float = 0.0
    isolated_tiles: int = 0
    entrance: Optional[Tuple[int, int]] = None
    exit: Optional[Tuple[int, int]] = None
    stair_distance: int = 0
    stairs_reachable: bool = False
    signature: str = ""
    profile: str = ""
    seed: int = 0

    def to_dict(self) -> dict:
        return dict(self.__dict__)


def measure(result: FloorResult) -> FloorMetrics:
    m = FloorMetrics(profile=result.profile, seed=result.seed)
    real_rooms = [r for r, is_hall in zip(result.rooms, result.room_is_hall) if not is_hall]
    m.rooms = len(real_rooms)
    m.hall_cells = sum(1 for is_hall in result.room_is_hall if is_hall)
    areas = [r.area for r in real_rooms] or [0]
    m.room_area_min = min(areas)
    m.room_area_max = max(areas)
    m.room_area_avg = round(sum(areas) / len(areas), 2)
    m.large_rooms = sum(1 for r in real_rooms if r.area >= 60)
    m.halls = len(result.hall_edges)
    m.width, m.height = result.width, result.height

    # graph over all cells (rooms + hall cells)
    nodes = set()
    degree: Dict[int, int] = {}
    for a, b in result.hall_edges:
        nodes.add(a)
        nodes.add(b)
        degree[a] = degree.get(a, 0) + 1
        degree[b] = degree.get(b, 0) + 1
    m.connections = len(result.hall_edges)
    m.branches = sum(1 for d in degree.values() if d >= 3)
    m.dead_ends = sum(1 for d in degree.values() if d == 1)

    parent = {n: n for n in nodes}

    def find(n):
        while parent[n] != n:
            parent[n] = parent[parent[n]]
            n = parent[n]
        return n

    for a, b in result.hall_edges:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb
    comps = len({find(n) for n in nodes}) if nodes else 0
    m.components = comps
    m.loops = max(0, m.connections - len(nodes) + comps)

    floor_tiles = [(x, y) for y in range(result.height) for x in range(result.width)
                   if result.tiles[y][x] != WALL]
    m.floor_tiles = len(floor_tiles)
    m.hall_tiles = sum(1 for y in range(result.height) for x in range(result.width)
                       if result.tiles[y][x] == HALL)
    total = max(1, result.width * result.height)
    m.walkable_ratio = round(m.floor_tiles / total, 4)

    start = result.entrance or (floor_tiles[0] if floor_tiles else None)
    reachable = _flood(result, start) if start else set()
    m.reachable_ratio = round(len(reachable) / max(1, m.floor_tiles), 4)
    m.isolated_tiles = m.floor_tiles - len(reachable)
    m.entrance, m.exit = result.entrance, result.exit
    if result.entrance and result.exit:
        m.stair_distance = abs(result.entrance[0] - result.exit[0]) + abs(result.entrance[1] - result.exit[1])
        m.stairs_reachable = result.exit in reachable
    m.signature = signature(result)
    return m


def _flood(result: FloorResult, start) -> set:
    seen = {start}
    q = deque([start])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < result.width and 0 <= ny < result.height and (nx, ny) not in seen:
                if result.tiles[ny][nx] != WALL:
                    seen.add((nx, ny))
                    q.append((nx, ny))
    return seen


def signature(result: FloorResult) -> str:
    """Structural signature: topology + geometry, deliberately not tile-based."""
    parts = []
    for rect, is_hall in sorted(zip(result.rooms, result.room_is_hall), key=lambda t: (t[0].y, t[0].x)):
        parts.append(f"{'h' if is_hall else 'r'}{rect.x},{rect.y},{rect.w},{rect.h}")
    deg: Dict[int, int] = {}
    for a, b in result.hall_edges:
        deg[a] = deg.get(a, 0) + 1
        deg[b] = deg.get(b, 0) + 1
    parts.append("deg:" + ",".join(str(v) for v in sorted(deg.values())))
    parts.append(f"edges:{len(result.hall_edges)}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:16]


def similarity(a: FloorMetrics, b: FloorMetrics) -> float:
    """0..1 structural similarity between two generations."""
    if a.signature == b.signature:
        return 1.0
    fields = ("rooms", "halls", "connections", "branches", "dead_ends", "loops",
              "room_area_max", "room_area_min", "floor_tiles", "hall_tiles")
    score = 0.0
    for name in fields:
        va, vb = getattr(a, name), getattr(b, name)
        hi = max(abs(va), abs(vb), 1)
        score += 1.0 - (abs(va - vb) / hi)
    return round(score / len(fields), 4)
