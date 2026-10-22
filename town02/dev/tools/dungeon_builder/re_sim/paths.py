"""Grid path steps ported from RogueElements (and RogueEssence's grid steps).

Sources read for this port:
  RogueElements/MapGen/Grid/Paths/IGridPathBranch.cs   -> GridPathBranch
  RogueElements/MapGen/Grid/Paths/IGridPathCircle.cs   -> GridPathCircle
  RogueElements/MapGen/Grid/Paths/IGridPathGrid.cs     -> GridPathGrid
  RogueElements/MapGen/Grid/Paths/GridPathTwoSides.cs  -> GridPathTwoSides
  RogueElements/MapGen/Grid/Paths/GridPathCross.cs     -> GridPathCross
  RogueElements/MapGen/Grid/ConnectGridBranchStep.cs
  RogueElements/MapGen/Grid/SetGridDefaultsStep.cs
  RogueEssence.LevelGen.CombineGridRoomStep (observed usage in this repo's
  Data/Zone/*.json; merges adjacent cells into one large room)
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field
from typing import List, Sequence, Tuple

from .geometry import DIR_LOC, DOWN, LEFT, REVERSE, Rect, RIGHT, UP, VALID_DIR4
from .gridplan import GridPlan
from .rooms import RandRange, RoomGen


def rand_binomial(rand: random.Random, trials: int, percent: int) -> int:
    """RogueElements.RandBinomial."""
    total = 0
    for _ in range(trials):
        if rand.randrange(100) < percent:
            total += 1
    return total


def roll_ratio(rand: random.Random, open_left: int, max_left: int) -> Tuple[bool, int, int]:
    """RogueElements GridPathStartStep.RollRatio."""
    if max_left <= 0:
        return False, open_left, max_left
    hit = rand.randrange(max_left) < open_left
    return hit, open_left - (1 if hit else 0), max_left - 1


@dataclass
class RoomPicker:
    """Minimal SpawnList<RoomGen> equivalent."""

    entries: Sequence[Tuple[RoomGen, int]]

    def pick(self, rand: random.Random) -> RoomGen:
        total = sum(w for _, w in self.entries)
        roll = rand.randrange(total)
        for gen, weight in self.entries:
            roll -= weight
            if roll < 0:
                return gen.copy()
        return self.entries[-1][0].copy()


DEFAULT_HALL_GEN = RoomGen(RandRange(1), RandRange(1), kind="square")


@dataclass
class GridPathStep:
    rooms: RoomPicker
    room_components: Tuple[str, ...] = ()
    hall_components: Tuple[str, ...] = ("Connectivity.Main",)

    def default_gen(self) -> RoomGen:
        return RoomGen(RandRange(1), RandRange(1), kind="square")


# --------------------------------------------------------------------------
@dataclass
class GridPathBranch(GridPathStep):
    """Direct port of RogueElements.GridPathBranch<T>.ApplyToPath."""

    room_ratio: RandRange = field(default_factory=lambda: RandRange(60, 80))
    branch_ratio: RandRange = field(default_factory=lambda: RandRange(30, 60))
    no_forced_branches: bool = False
    name: str = "GridPathBranch"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        for _ in range(10):
            plan.clear()
            rooms_to_open = plan.grid_w * plan.grid_h * self.room_ratio.pick(rand) // 100
            rooms_to_open = max(1, rooms_to_open)
            add_branch = self.branch_ratio.pick(rand)
            rooms_left = rooms_to_open
            terminals: List[Tuple[int, int]] = []
            branchables: List[Tuple[int, int]] = []

            source = (rand.randrange(plan.grid_w), rand.randrange(plan.grid_h))
            plan.add_cell_room(source[0], source[1], self.rooms.pick(rand), components=self.room_components)
            terminals.append(source)
            terminals.append(source)
            rooms_left -= 1
            pending_branch = 0

            while rooms_left > 0:
                new_terminal = _pop_random(rand, terminals)
                if new_terminal is None:
                    rays = []
                else:
                    rays = _expand_dirs(plan, new_terminal)
                if rays:
                    direction = rays[rand.randrange(len(rays))]
                    self._expand(rand, plan, new_terminal, direction)
                    dx, dy = DIR_LOC[direction]
                    new_loc = (new_terminal[0] + dx, new_terminal[1] + dy)
                    rooms_left -= 1
                    terminals.append(new_loc)
                    if plan.room_count > 2:
                        if len(rays) > 1:
                            branchables.append(new_terminal)
                        pending_branch += add_branch
                elif not terminals:
                    if self.no_forced_branches:
                        break
                    pending_branch = 100

                while pending_branch >= 100 and rooms_left > 0 and branchables:
                    new_branch = _pop_random(rand, branchables)
                    branch_rays = _expand_dirs(plan, new_branch)
                    if branch_rays:
                        direction = branch_rays[rand.randrange(len(branch_rays))]
                        self._expand(rand, plan, new_branch, direction)
                        dx, dy = DIR_LOC[direction]
                        terminals.append((new_branch[0] + dx, new_branch[1] + dy))
                        rooms_left -= 1
                        if len(branch_rays) > 1:
                            branchables.append(new_branch)
                        pending_branch -= 100
                    else:
                        break

                if not terminals and not branchables:
                    break

            if rooms_left <= 0:
                break

    def _expand(self, rand: random.Random, plan: GridPlan, loc: Tuple[int, int], direction: str) -> None:
        plan.set_hall(loc[0], loc[1], direction, True)
        dx, dy = DIR_LOC[direction]
        plan.add_cell_room(loc[0] + dx, loc[1] + dy, self.rooms.pick(rand), components=self.room_components)


def _pop_random(rand: random.Random, locs: List[Tuple[int, int]]):
    if not locs:
        return None
    idx = rand.randrange(len(locs))
    return locs.pop(idx)


def _expand_dirs(plan: GridPlan, loc) -> List[str]:
    if loc is None:
        return []
    out = []
    for direction in VALID_DIR4:
        dx, dy = DIR_LOC[direction]
        nx, ny = loc[0] + dx, loc[1] + dy
        if plan.in_bounds(nx, ny) and plan.get_room_index(nx, ny) == -1:
            out.append(direction)
    return out


# --------------------------------------------------------------------------
@dataclass
class GridPathCircle(GridPathStep):
    """Direct port of RogueElements.GridPathCircle<T>."""

    circle_room_ratio: RandRange = field(default_factory=lambda: RandRange(50, 80))
    paths: RandRange = field(default_factory=lambda: RandRange(1, 3))
    name: str = "GridPathCircle"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        if plan.grid_w < 3 or plan.grid_h < 3:
            raise ValueError("Not enough room to create path.")
        plan.clear()
        max_rooms = 2 * plan.grid_w + 2 * plan.grid_h - 4
        room_open = max_rooms * self.circle_room_ratio.pick(rand) // 100
        paths = self.paths.pick(rand)
        if room_open < 1 and paths < 1:
            room_open = 1

        for xx in range(plan.grid_w):
            room_open, max_rooms = self._roll_open(rand, plan, xx, 0, room_open, max_rooms)
            room_open, max_rooms = self._roll_open(rand, plan, xx, plan.grid_h - 1, room_open, max_rooms)
            if xx > 0:
                plan.set_hall(xx, 0, LEFT, True)
                plan.set_hall(xx, plan.grid_h - 1, LEFT, True)
        for yy in range(plan.grid_h):
            if 0 < yy < plan.grid_h - 1:
                room_open, max_rooms = self._roll_open(rand, plan, 0, yy, room_open, max_rooms)
                room_open, max_rooms = self._roll_open(rand, plan, plan.grid_w - 1, yy, room_open, max_rooms)
            if yy > 0:
                plan.set_hall(0, yy, UP, True)
                plan.set_hall(plan.grid_w - 1, yy, UP, True)

        inner = Rect(1, 1, plan.grid_w - 2, plan.grid_h - 2)
        for _ in range(paths):
            self._inner_path(rand, plan, inner)

    def _roll_open(self, rand, plan, x, y, room_open, max_rooms):
        hit, room_open, max_rooms = roll_ratio(rand, room_open, max_rooms)
        if hit:
            plan.add_cell_room(x, y, self.rooms.pick(rand), components=self.room_components)
        else:
            plan.add_cell_room(x, y, self.default_gen(), prefer_hall=True, components=self.hall_components)
        return room_open, max_rooms

    def _inner_path(self, rand: random.Random, plan: GridPlan, inner: Rect) -> None:
        start_dir = VALID_DIR4[rand.randrange(4)]
        x = rand.randrange(inner.x, inner.end_x)
        y = rand.randrange(inner.y, inner.end_y)
        if start_dir == DOWN:
            y = 0
        elif start_dir == LEFT:
            x = plan.grid_w - 1
        elif start_dir == UP:
            y = plan.grid_h - 1
        elif start_dir == RIGHT:
            x = 0
        wanderer = (x, y)
        prev_dir = None
        path_len = inner.h if start_dir in (UP, DOWN) else inner.w
        for step in range(path_len):
            chosen = start_dir
            if step > 0:
                dirs = []
                for direction in VALID_DIR4:
                    if direction == prev_dir:
                        continue
                    dx, dy = DIR_LOC[direction]
                    if not inner.contains(wanderer[0] + dx, wanderer[1] + dy):
                        continue
                    dirs.append(direction)
                if not dirs:
                    return
                chosen = dirs[rand.randrange(len(dirs))]
            dx, dy = DIR_LOC[chosen]
            dest = (wanderer[0] + dx, wanderer[1] + dy)
            existing = plan.get_room_plan(*dest)
            if existing is None:
                if step == path_len - 1:
                    plan.add_cell_room(dest[0], dest[1], self.rooms.pick(rand), components=self.room_components)
                else:
                    plan.add_cell_room(dest[0], dest[1], self.default_gen(), prefer_hall=True,
                                       components=self.hall_components)
            elif existing.prefer_hall and step == path_len - 1:
                existing.gen = self.rooms.pick(rand)
                existing.prefer_hall = False
            plan.set_hall(wanderer[0], wanderer[1], chosen, True)
            wanderer = dest
            prev_dir = REVERSE[chosen]


# --------------------------------------------------------------------------
@dataclass
class GridPathTwoSides(GridPathStep):
    """Direct port of RogueElements.GridPathTwoSides<T> (horizontal gap axis)."""

    vertical: bool = False
    name: str = "GridPathTwoSides"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        plan.clear()
        scalar = plan.grid_h if self.vertical else plan.grid_w
        orth = plan.grid_w if self.vertical else plan.grid_h
        if scalar < 2 or orth < 1:
            raise ValueError("Not enough room to create path.")

        def loc(s: int, o: int) -> Tuple[int, int]:
            return (o, s) if self.vertical else (s, o)

        for ii in range(orth):
            a = loc(0, ii)
            b = loc(scalar - 1, ii)
            plan.add_cell_room(a[0], a[1], self.rooms.pick(rand), components=self.room_components)
            plan.add_cell_room(b[0], b[1], self.rooms.pick(rand), components=self.room_components)
            if scalar > 2:
                start = loc(1, ii)
                size = (1, scalar - 2) if self.vertical else (scalar - 2, 1)
                plan.add_room(Rect(start[0], start[1], size[0], size[1]), self.default_gen(),
                              prefer_hall=True, components=self.hall_components)

        connections = [[False, False] for _ in range(max(0, orth - 1))]
        for ii in range(orth - 1):
            connections[ii][rand.randrange(2)] = True

        side_dir = DOWN if not self.vertical else RIGHT
        gap_dir_fwd = RIGHT if not self.vertical else DOWN
        gap_dir_back = LEFT if not self.vertical else UP
        for ii in range(orth):
            if ii < orth - 1:
                if connections[ii][0]:
                    a = loc(0, ii)
                    plan.set_hall(a[0], a[1], side_dir, True)
                if connections[ii][1]:
                    b = loc(scalar - 1, ii)
                    plan.set_hall(b[0], b[1], side_dir, True)
            a = loc(0, ii)
            plan.set_hall(a[0], a[1], gap_dir_fwd, True)
            if scalar > 2:
                b = loc(scalar - 1, ii)
                plan.set_hall(b[0], b[1], gap_dir_back, True)


# --------------------------------------------------------------------------
@dataclass
class GridPathCross(GridPathStep):
    """Direct port of RogueElements.GridPathCross<T>."""

    name: str = "GridPathCross"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        plan.clear()
        mw = plan.grid_w // 2
        mh = plan.grid_h // 2
        plan.add_cell_room(mw, mh, self.rooms.pick(rand), components=self.room_components)
        plan.set_hall(mw, mh, LEFT, True)
        plan.set_hall(mw, mh, UP, True)
        for x in range(plan.grid_w):
            if x != mw:
                plan.add_cell_room(x, mh, self.rooms.pick(rand), components=self.room_components)
                if x != 0:
                    plan.set_hall(x, mh, LEFT, True)
        for y in range(plan.grid_h):
            if y != mh:
                plan.add_cell_room(mw, y, self.rooms.pick(rand), components=self.room_components)
                if y != 0:
                    plan.set_hall(mw, y, UP, True)


# --------------------------------------------------------------------------
@dataclass
class GridPathGrid(GridPathStep):
    """Direct port of RogueElements.GridPathGrid<T>."""

    room_ratio: int = 60
    hall_ratio: int = 40
    name: str = "GridPathGrid"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        if plan.grid_w < 3 or plan.grid_h < 3:
            raise ValueError("Not enough room to create path.")
        plan.clear()
        room_max = 2 * (plan.grid_w - 2) + 2 * (plan.grid_h - 2)
        room_open = max(1, room_max * self.room_ratio // 100)
        for x in range(1, plan.grid_w - 1):
            for y in range(1, plan.grid_h - 1):
                plan.add_cell_room(x, y, self.default_gen(), prefer_hall=True, components=self.hall_components)
                if x > 1:
                    plan.set_hall(x, y, LEFT, True)
                if y > 1:
                    plan.set_hall(x, y, UP, True)

        for x in range(1, plan.grid_w - 1):
            for y, direction in ((0, DOWN), (plan.grid_h - 1, UP)):
                hit, room_open, room_max = roll_ratio(rand, room_open, room_max)
                if hit:
                    plan.add_cell_room(x, y, self.rooms.pick(rand), components=self.room_components)
                    plan.set_hall(x, y, direction, True)
        for y in range(1, plan.grid_h - 1):
            for x, direction in ((0, RIGHT), (plan.grid_w - 1, LEFT)):
                hit, room_open, room_max = roll_ratio(rand, room_open, room_max)
                if hit:
                    plan.add_cell_room(x, y, self.rooms.pick(rand), components=self.room_components)
                    plan.set_hall(x, y, direction, True)

        h_sites, v_sites = [], []
        for x in range(1, plan.grid_w):
            if plan.get_room_plan(x, 0) or plan.get_room_plan(x - 1, 0):
                h_sites.append((x, 0))
            if plan.get_room_plan(x, plan.grid_h - 1) or plan.get_room_plan(x - 1, plan.grid_h - 1):
                h_sites.append((x, plan.grid_h - 1))
        for y in range(1, plan.grid_h):
            if plan.get_room_plan(0, y) or plan.get_room_plan(0, y - 1):
                v_sites.append((0, y))
            if plan.get_room_plan(plan.grid_w - 1, y) or plan.get_room_plan(plan.grid_w - 1, y - 1):
                v_sites.append((plan.grid_w - 1, y))

        halls = len(h_sites) + len(v_sites)
        placed = halls * self.hall_ratio // 100
        for site in h_sites:
            if halls > 0 and rand.randrange(halls) < placed:
                self._safe_hall(rand, plan, site, LEFT)
                placed -= 1
            halls -= 1
        for site in v_sites:
            if halls > 0 and rand.randrange(halls) < placed:
                self._safe_hall(rand, plan, site, UP)
                placed -= 1
            halls -= 1

    def _safe_hall(self, rand, plan: GridPlan, site, direction) -> None:
        dx, dy = DIR_LOC[direction]
        here = plan.get_room_plan(*site)
        there = plan.get_room_plan(site[0] + dx, site[1] + dy)
        if here is None:
            plan.add_cell_room(site[0], site[1], self.rooms.pick(rand), components=self.room_components)
        if there is None:
            plan.add_cell_room(site[0] + dx, site[1] + dy, self.rooms.pick(rand), components=self.room_components)
        plan.set_hall(site[0], site[1], direction, True)


# --------------------------------------------------------------------------
@dataclass
class GridPathTiered(GridPathStep):
    """Direct port of RogueEssence.LevelGen.GridPathTiered<T>.

    Source read: PMDC/RogueEssence/RogueEssence/LevelGen/Floors/GenSteps/
    FloorPlan/GridPathTiered.cs — tiers of rooms fully chained along one axis,
    then `TierConnections` bridges between consecutive tiers.
    """

    tier_connections: RandRange = field(default_factory=lambda: RandRange(1, 3))
    vertical: bool = False          # TierAxis: False = horizontal tiers
    name: str = "GridPathTiered"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        plan.clear()
        scalar = plan.grid_h if self.vertical else plan.grid_w
        orth = plan.grid_w if self.vertical else plan.grid_h

        def loc(s: int, o: int) -> Tuple[int, int]:
            return (o, s) if self.vertical else (s, o)

        axis_forward = DOWN if self.vertical else RIGHT
        orth_back = LEFT if self.vertical else UP

        for ii in range(scalar):
            for jj in range(orth):
                x, y = loc(ii, jj)
                plan.add_cell_room(x, y, self.rooms.pick(rand), components=self.room_components)
                if ii == scalar - 1:
                    continue
                plan.set_hall(x, y, axis_forward, True)

        for jj in range(1, orth):
            amount = max(1, self.tier_connections.pick(rand))
            possible = list(range(scalar))
            for _ in range(min(amount, len(possible))):
                chosen = possible.pop(rand.randrange(len(possible)))
                x, y = loc(chosen, jj)
                plan.set_hall(x, y, orth_back, True)


# --------------------------------------------------------------------------
@dataclass
class ConnectGridBranchStep:
    """Direct port of RogueElements.ConnectGridBranchStep<T> (creates loops)."""

    connect_percent: int = 50
    name: str = "ConnectGridBranchStep"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        end_branches = []
        for ii in range(plan.room_count):
            room = plan.array_rooms[ii]
            if room.bounds.w == 1 and room.bounds.h == 1:
                if len(plan.get_adjacent_rooms(ii)) == 1:
                    end_branches.append((room.start, None))

        cand_branch_points: List[List[Tuple[Tuple[int, int], str]]] = []
        for loc, came_from in end_branches:
            chosen_loc, chosen_dir = loc, came_from
            while chosen_loc is not None:
                connectors = []
                cand_bonds = []
                for direction in VALID_DIR4:
                    if direction == chosen_dir:
                        continue
                    if plan.get_hall(chosen_loc[0], chosen_loc[1], direction):
                        connectors.append((chosen_loc, direction))
                    else:
                        dx, dy = DIR_LOC[direction]
                        idx = plan.get_room_index(chosen_loc[0] + dx, chosen_loc[1] + dy)
                        if idx > -1:
                            cand_bonds.append((chosen_loc, direction))
                if len(connectors) == 1:
                    if cand_bonds:
                        cand_branch_points.append(cand_bonds)
                        chosen_loc = None
                    else:
                        cl, cd = connectors[0]
                        dx, dy = DIR_LOC[cd]
                        chosen_loc = (cl[0] + dx, cl[1] + dy)
                        chosen_dir = REVERSE[cd]
                else:
                    chosen_loc = None

        connections_left = rand_binomial(rand, len(cand_branch_points), self.connect_percent)
        while cand_branch_points and connections_left > 0:
            idx = rand.randrange(len(cand_branch_points))
            bonds = cand_branch_points[idx]
            loc, direction = bonds[rand.randrange(len(bonds))]
            plan.set_hall(loc[0], loc[1], direction, True)
            cand_branch_points.pop(idx)
            connections_left -= 1
            dx, dy = DIR_LOC[direction]
            target = (loc[0] + dx, loc[1] + dy)
            for jj in range(len(cand_branch_points) - 1, -1, -1):
                if cand_branch_points[jj][0][0] == target:
                    cand_branch_points.pop(jj)
                    connections_left -= 1


@dataclass
class SetGridDefaultsStep:
    """Direct port of RogueElements.SetGridDefaultsStep<T> (turns rooms into hall cells)."""

    default_ratio: RandRange = field(default_factory=lambda: RandRange(0, 20))
    name: str = "SetGridDefaultsStep"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        candidates = [ii for ii in range(plan.room_count) if len(plan.get_adjacent_rooms(ii)) > 1
                      and not plan.array_rooms[ii].prefer_hall]
        amount = self.default_ratio.pick(rand) * len(candidates) // 100
        for _ in range(amount):
            if not candidates:
                break
            idx = rand.randrange(len(candidates))
            plan_room = plan.array_rooms[candidates[idx]]
            plan_room.gen = RoomGen(RandRange(1), RandRange(1), kind="square")
            plan_room.prefer_hall = True
            candidates.pop(idx)


@dataclass
class CombineGridRoomStep:
    """RogueEssence.LevelGen.CombineGridRoomStep: merges adjacent cells into a large room."""

    merge_rate: int = 20
    combos: Sequence[Tuple[int, int]] = ((2, 1), (1, 2), (2, 2))
    name: str = "CombineGridRoomStep"

    def apply(self, rand: random.Random, plan: GridPlan) -> None:
        for _ in range(max(1, plan.grid_w * plan.grid_h // 4)):
            if rand.randrange(100) >= self.merge_rate:
                continue
            cw, ch = self.combos[rand.randrange(len(self.combos))]
            x = rand.randrange(max(1, plan.grid_w - cw + 1))
            y = rand.randrange(max(1, plan.grid_h - ch + 1))
            rect = Rect(x, y, cw, ch)
            indices = set()
            ok = True
            for xx, yy in rect.tiles():
                idx = plan.get_room_index(xx, yy)
                if idx < 0 or plan.array_rooms[idx].prefer_hall or plan.array_rooms[idx].bounds.area > 1:
                    ok = False
                    break
                indices.add(idx)
            if not ok or len(indices) != cw * ch:
                continue
            # all cells must be internally connected by halls
            connected = True
            for xx in range(rect.x, rect.end_x):
                for yy in range(rect.y, rect.end_y):
                    if xx + 1 < rect.end_x and not plan.get_hall(xx, yy, RIGHT):
                        connected = False
                    if yy + 1 < rect.end_y and not plan.get_hall(xx, yy, DOWN):
                        connected = False
            if not connected:
                continue
            gen = plan.array_rooms[min(indices)].gen.copy()
            gen.width = RandRange(max(4, plan.width_per_cell * cw - 2), plan.width_per_cell * cw + plan.cell_wall * (cw - 1) + 1)
            gen.height = RandRange(max(4, plan.height_per_cell * ch - 2), plan.height_per_cell * ch + plan.cell_wall * (ch - 1) + 1)
            _erase_rooms(plan, sorted(indices, reverse=True))
            # the halls interior to the merged block are absorbed by the room
            for xx in range(rect.x, rect.end_x):
                for yy in range(rect.y, rect.end_y):
                    if xx + 1 < rect.end_x:
                        plan.hhalls.pop((xx, yy), None)
                    if yy + 1 < rect.end_y:
                        plan.vhalls.pop((xx, yy), None)
            plan.add_room(rect, gen, components=("Immutable", "LargeRoom"))


def _erase_rooms(plan: GridPlan, indices: List[int]) -> None:
    for idx in indices:
        room = plan.array_rooms.pop(idx)
        for xx, yy in room.bounds.tiles():
            plan.rooms_at[xx][yy] = -1
        for xx in range(plan.grid_w):
            for yy in range(plan.grid_h):
                if plan.rooms_at[xx][yy] > idx:
                    plan.rooms_at[xx][yy] -= 1
