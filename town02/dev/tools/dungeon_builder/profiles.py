"""Architecture profiles: one description, two consumers.

A profile is a *pure description* of RogueElements parameters.  It is consumed
by:
  * `tools.dungeon_builder.re_sim` — the offline simulator (validation/preview);
  * `tools.dungeon_builder.zone_export` — the emitter that writes real
    RogueElements / RogueEssence gen steps into `Data/Zone/<id>.json`.

Every field maps to an actual property of an actual class that was read in the
RogueElements sources (see docs/dungeon_builder/AUDIT_ROGUEELEMENTS.md).
"""
from __future__ import annotations

import random
from dataclasses import dataclass, field, replace
from typing import Dict, List, Optional, Sequence, Tuple

from .re_sim.gridplan import GridPlan
from .re_sim.paths import (
    CombineGridRoomStep,
    GridPathTiered,
    ConnectGridBranchStep,
    GridPathBranch,
    GridPathCircle,
    GridPathCross,
    GridPathGrid,
    GridPathTwoSides,
    RoomPicker,
    SetGridDefaultsStep,
)
from .re_sim.pipeline import FloorResult, draw_floor, measure, place_stairs
from .re_sim.rooms import RandRange, RoomGen

Range = Tuple[int, int]


@dataclass
class RoomSpec:
    """A weighted entry of the GenericRooms SpawnList."""

    kind: str = "square"          # square | round | cross | cave
    width: Range = (4, 8)
    height: Range = (4, 8)
    weight: int = 10

    def to_sim(self) -> Tuple[RoomGen, int]:
        return RoomGen(RandRange(*self.width), RandRange(*self.height), kind=self.kind), self.weight


@dataclass
class ArchitectureProfile:
    """A complete grid-floor architecture built only from native steps."""

    name: str
    path: str = "branch"          # branch | circle | grid | twosides | cross
    grid_x: Range = (4, 7)
    grid_y: Range = (3, 5)
    cell_width: Range = (9, 13)
    cell_height: Range = (8, 11)
    cell_wall: int = 1
    room_ratio: Range = (60, 85)          # GridPathBranch.RoomRatio
    branch_ratio: Range = (30, 70)        # GridPathBranch.BranchRatio
    no_forced_branches: bool = False
    tier_connections: Range = (1, 3)      # GridPathTiered.TierConnections
    circle_room_ratio: Range = (50, 80)   # GridPathCircle.CircleRoomRatio
    circle_paths: Range = (1, 3)          # GridPathCircle.Paths
    grid_room_ratio: int = 60             # GridPathGrid.RoomRatio
    grid_hall_ratio: int = 40             # GridPathGrid.HallRatio
    connect_percent: int = 40             # ConnectGridBranchStep.ConnectPercent -> loops
    default_ratio: Range = (0, 15)        # SetGridDefaultsStep.DefaultRatio
    combine_rate: int = 0                 # CombineGridRoomStep.MergeRate -> large rooms
    hall_turn_bias: int = 50              # RoomGenAngledHall.HallTurnBias
    hall_width: Range = (1, 2)
    rooms: Sequence[RoomSpec] = field(default_factory=lambda: (RoomSpec(),))
    min_stair_distance: int = 20          # FloorStairsStep.MinDistance
    tags: Tuple[str, ...] = ()

    # -- simulator ----------------------------------------------------
    def build_plan(self, rand: random.Random) -> GridPlan:
        plan = GridPlan()
        gx = rand.randrange(*_r(self.grid_x))
        gy = rand.randrange(*_r(self.grid_y))
        if self.path in ("circle", "grid"):
            gx, gy = max(3, gx), max(3, gy)
        cw = rand.randrange(*_r(self.cell_width))
        ch = rand.randrange(*_r(self.cell_height))
        plan.init_size(gx, gy, cw, ch, self.cell_wall)
        return plan

    def picker(self) -> RoomPicker:
        return RoomPicker([spec.to_sim() for spec in self.rooms])

    def simulate(self, seed: int) -> FloorResult:
        rand = random.Random(seed)
        plan = self.build_plan(rand)
        picker = self.picker()
        step = self._path_step(picker)
        step.apply(rand, plan)
        if self.combine_rate > 0:
            CombineGridRoomStep(self.combine_rate).apply(rand, plan)
        if self.connect_percent > 0:
            ConnectGridBranchStep(self.connect_percent).apply(rand, plan)
        if self.default_ratio[1] > 0:
            SetGridDefaultsStep(RandRange(*_r(self.default_ratio))).apply(rand, plan)
        floor = plan.place_rooms_on_floor(rand)
        result = draw_floor(plan, floor, rand, self.hall_turn_bias, profile=self.name, seed=seed)
        place_stairs(result, rand, self.min_stair_distance)
        return result

    def _path_step(self, picker: RoomPicker):
        if self.path == "circle":
            return GridPathCircle(picker, circle_room_ratio=RandRange(*_r(self.circle_room_ratio)),
                                  paths=RandRange(*_r(self.circle_paths)))
        if self.path == "grid":
            return GridPathGrid(picker, room_ratio=self.grid_room_ratio, hall_ratio=self.grid_hall_ratio)
        if self.path == "twosides":
            return GridPathTwoSides(picker)
        if self.path == "cross":
            return GridPathCross(picker)
        if self.path == "tiered":
            return GridPathTiered(picker, tier_connections=RandRange(*_r(self.tier_connections)))
        return GridPathBranch(picker, room_ratio=RandRange(*_r(self.room_ratio)),
                              branch_ratio=RandRange(*_r(self.branch_ratio)),
                              no_forced_branches=self.no_forced_branches)


def _r(rng: Range) -> Range:
    lo, hi = rng
    return (lo, hi if hi > lo else lo + 1)


# ---------------------------------------------------------------------------
FOREST_ROOMS = (
    RoomSpec("square", (5, 10), (4, 8), 10),
    RoomSpec("round", (5, 9), (5, 9), 6),
    RoomSpec("cave", (6, 11), (5, 9), 5),
    RoomSpec("cross", (6, 10), (6, 10), 3),
)

BUILTIN_PROFILES: Dict[str, ArchitectureProfile] = {
    "branching": ArchitectureProfile(
        name="branching", path="branch",
        grid_x=(4, 7), grid_y=(3, 5), room_ratio=(55, 75), branch_ratio=(70, 120),
        connect_percent=15, default_ratio=(0, 10), combine_rate=0, hall_turn_bias=60,
        rooms=FOREST_ROOMS, tags=("branches", "dead_ends"),
    ),
    "looping": ArchitectureProfile(
        name="looping", path="branch",
        # Promoted only after the native PMDO prototype produced 16/16 valid,
        # distinct layouts.  The former 4x3-ish profile sometimes erased every
        # dead end; a larger graph with less aggressive reconnecting preserves
        # both branches and alternative paths.
        grid_x=(5, 7), grid_y=(4, 6), room_ratio=(75, 95), branch_ratio=(55, 95),
        connect_percent=65, default_ratio=(5, 20), combine_rate=0, hall_turn_bias=40,
        rooms=FOREST_ROOMS, tags=("loops", "alt_paths"),
    ),
    "large_rooms": ArchitectureProfile(
        name="large_rooms", path="branch",
        # The old 3x2 grid + 4-8 merge attempts collapsed to 2-3 rooms in the
        # actual engine.  These values yielded 11-17 rooms, branches, dead ends
        # and loops on 16/16 native runtime seeds.
        grid_x=(5, 7), grid_y=(4, 6), cell_width=(10, 14), cell_height=(9, 13),
        room_ratio=(80, 100), branch_ratio=(65, 105), connect_percent=45,
        combine_rate=20, hall_turn_bias=35,
        rooms=(RoomSpec("square", (8, 15), (7, 12), 10), RoomSpec("round", (8, 13), (7, 12), 6),
               RoomSpec("cave", (9, 15), (7, 12), 4)),
        tags=("large_rooms",),
    ),
    "dense": ArchitectureProfile(
        name="dense", path="branch",
        grid_x=(6, 9), grid_y=(4, 6), cell_width=(7, 10), cell_height=(6, 9),
        room_ratio=(80, 100), branch_ratio=(50, 90), connect_percent=45,
        default_ratio=(15, 35), combine_rate=10, hall_turn_bias=55,
        rooms=(RoomSpec("square", (3, 7), (3, 6), 10), RoomSpec("round", (4, 7), (4, 7), 5),
               RoomSpec("cave", (4, 8), (4, 7), 4)),
        tags=("dense", "many_rooms"),
    ),
    "ring": ArchitectureProfile(
        name="ring", path="circle",
        grid_x=(4, 6), grid_y=(3, 5), circle_room_ratio=(40, 70), circle_paths=(1, 4),
        connect_percent=25, combine_rate=10, hall_turn_bias=45,
        rooms=FOREST_ROOMS, tags=("loops", "ring"),
    ),
    "lattice": ArchitectureProfile(
        name="lattice", path="grid",
        grid_x=(4, 7), grid_y=(3, 6), grid_room_ratio=65, grid_hall_ratio=45,
        connect_percent=20, combine_rate=5, hall_turn_bias=30,
        rooms=FOREST_ROOMS, tags=("loops", "alt_paths"),
    ),
    "twosides": ArchitectureProfile(
        name="twosides", path="twosides",
        grid_x=(3, 5), grid_y=(3, 5), cell_width=(10, 14), cell_height=(8, 12),
        connect_percent=25, combine_rate=15, hall_turn_bias=50,
        rooms=FOREST_ROOMS, tags=("corridors",),
    ),
    "crossroads": ArchitectureProfile(
        name="crossroads", path="cross",
        grid_x=(5, 8), grid_y=(3, 6), cell_width=(9, 14), cell_height=(8, 12),
        connect_percent=30, combine_rate=20, hall_turn_bias=45,
        rooms=FOREST_ROOMS, tags=("hub",),
    ),
    "tiered": ArchitectureProfile(
        name="tiered", path="tiered",
        grid_x=(4, 7), grid_y=(3, 5), cell_width=(9, 13), cell_height=(8, 12),
        tier_connections=(1, 3), connect_percent=20, combine_rate=15, hall_turn_bias=35,
        default_ratio=(5, 20), rooms=FOREST_ROOMS, tags=("tiers", "alt_paths"),
    ),
    "mixed": ArchitectureProfile(
        name="mixed", path="branch",
        grid_x=(4, 8), grid_y=(3, 6), cell_width=(8, 15), cell_height=(7, 13),
        room_ratio=(60, 95), branch_ratio=(35, 95), connect_percent=55,
        default_ratio=(5, 25), combine_rate=25, hall_turn_bias=50,
        rooms=FOREST_ROOMS, tags=("mixed",),
    ),
}


def get_profile(name: str) -> ArchitectureProfile:
    if name not in BUILTIN_PROFILES:
        raise KeyError(f"unknown architecture profile '{name}' "
                       f"(available: {', '.join(sorted(BUILTIN_PROFILES))})")
    return BUILTIN_PROFILES[name]


def customize(name: str, overrides: Optional[dict]) -> ArchitectureProfile:
    """Return a profile copy with per-dungeon overrides applied."""
    base = get_profile(name)
    if not overrides:
        return base
    data = {}
    for key, value in overrides.items():
        if key == "rooms":
            data["rooms"] = tuple(RoomSpec(**spec) for spec in value)
        elif hasattr(base, key):
            data[key] = tuple(value) if isinstance(value, list) else value
        else:
            raise KeyError(f"unknown profile override '{key}' for profile '{name}'")
    return replace(base, **data)
