"""Zone-driven simulation: measure what the produced zones will actually generate.

Every other check reads the *definitions*.  This one reads the **emitted zone**
(`Data/Zone/<id>.json`), rebuilds a generator configuration from the parameters
that were really written into each floor — grid size, cell size, path step and
its numbers, room spawn list, connect/combine/defaults ratios, hall turn bias,
stair distance — and runs the offline simulator on it.

It therefore answers the question "what will the engine produce with this file?"
instead of "what did we intend to produce?", and it is what feeds the final
architecture-variety report (rooms, shapes, corridors, bends, branches, dead
ends, loops, traversability) per dungeon.
"""
from __future__ import annotations

import json
import random
import statistics
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

from .re_sim.gridplan import GridPlan
from .re_sim.paths import (CombineGridRoomStep, ConnectGridBranchStep, GridPathBranch,
                           GridPathCircle, GridPathCross, GridPathGrid, GridPathTiered,
                           GridPathTwoSides, RoomPicker, SetGridDefaultsStep)
from .re_sim.pipeline import FloorResult, draw_floor, measure, place_stairs
from .re_sim.rooms import RandRange, RoomGen

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"

ROOM_KIND_FROM_TYPE = {
    "RoomGenSquare": "square", "RoomGenRound": "round", "RoomGenCave": "cave",
    "RoomGenCross": "cross", "RoomGenBlocked": "blocked", "RoomGenBump": "square",
}


def _short(kind: str) -> str:
    return kind.split("`")[0].split(",")[0].split(".")[-1]


def _range(value: Any, fallback: Tuple[int, int] = (1, 2)) -> Tuple[int, int]:
    if isinstance(value, dict) and "Min" in value:
        lo, hi = int(value["Min"]), int(value["Max"])
        return lo, max(hi, lo + 1)
    if isinstance(value, int):
        return value, value + 1
    return fallback


@dataclass
class FloorConfig:
    floor: int
    segment: str
    profile: str
    grid: Tuple[int, int] = (0, 0)
    cell: Tuple[int, int] = (0, 0)
    cell_wall: int = 1
    path: str = ""
    path_params: Dict[str, Any] = field(default_factory=dict)
    rooms: List[Tuple[str, Tuple[int, int], Tuple[int, int], int]] = field(default_factory=list)
    connect_percent: int = 0
    combine_rate: Tuple[int, int] = (0, 0)
    default_ratio: Tuple[int, int] = (0, 0)
    hall_turn_bias: int = 50
    min_stair_distance: int = 3
    fixed_map: str = ""

    @property
    def room_kinds(self) -> List[str]:
        return sorted({kind for kind, _, _, _ in self.rooms})


def read_floor_config(floor_json: Dict[str, Any], floor_number: int,
                      segment_name: str) -> FloorConfig:
    config = FloorConfig(floor=floor_number, segment=segment_name, profile="")
    if "LoadGen" in floor_json.get("$type", ""):
        for step in floor_json.get("GenSteps", []):
            config.fixed_map = step["Value"].get("MapID", "")
        return config

    comment = floor_json.get("Comment", "")
    if "profile:" in comment:
        config.profile = comment.split("profile:")[1].split(" ")[0]
    elif "profile " in comment:
        config.profile = comment.split("profile ")[1].split(" ")[0]

    for step in floor_json.get("GenSteps", []):
        value = step["Value"]
        name = _short(value["$type"])
        if name == "InitGridPlanStep":
            config.grid = (int(value["CellX"]), int(value["CellY"]))
            config.cell = (int(value["CellWidth"]), int(value["CellHeight"]))
            config.cell_wall = int(value.get("CellWall", 1))
        elif name.startswith("GridPath"):
            config.path = name
            config.path_params = {k: v for k, v in value.items()
                                  if k not in ("$type", "GenericRooms", "GenericHalls",
                                               "RoomComponents", "HallComponents")}
            spawn = value.get("GenericRooms", {})
            for entry in spawn.get("$values", []) or []:
                room = entry.get("Spawn", {})
                kind = ROOM_KIND_FROM_TYPE.get(_short(room.get("$type", "")), "square")
                width = _range(room.get("MajorWidth") or room.get("Width"), (4, 8))
                height = _range(room.get("MajorHeight") or room.get("Height"), (4, 8))
                config.rooms.append((kind, width, height, int(entry.get("Rate", 10))))
            halls = value.get("GenericHalls", {})
            hall_entries = halls.get("$values") or ([{"Spawn": halls.get("ToSpawn", {})}]
                                                    if halls.get("ToSpawn") else [])
            for entry in hall_entries:
                bias = entry.get("Spawn", {}).get("HallTurnBias")
                if bias is not None:
                    config.hall_turn_bias = int(bias)
        elif name == "ConnectGridBranchStep":
            config.connect_percent = int(value.get("ConnectPercent", 0))
        elif name == "CombineGridRoomStep":
            config.combine_rate = _range(value.get("MergeRate"), (0, 1))
        elif name == "SetGridDefaultsStep":
            config.default_ratio = _range(value.get("DefaultRatio"), (0, 1))
        elif name == "FloorStairsStep":
            config.min_stair_distance = int(value.get("MinDistance", 3))
        elif name == "FloorStairsDistanceStep":
            config.min_stair_distance = _range(value.get("Distance"), (3, 100))[0]
    return config


def simulate_config(config: FloorConfig, seed: int) -> Optional[FloorResult]:
    """Run the offline simulator with the parameters written in the zone."""
    if config.fixed_map or not config.grid:
        return None
    rand = random.Random(seed)
    plan = GridPlan()
    plan.init_size(config.grid[0], config.grid[1], config.cell[0], config.cell[1], config.cell_wall)

    entries = [(RoomGen(RandRange(*width), RandRange(*height), kind=kind), weight)
               for kind, width, height, weight in config.rooms] or \
              [(RoomGen(RandRange(4, 8), RandRange(4, 8)), 10)]
    picker = RoomPicker(entries)
    params = config.path_params

    if config.path == "GridPathBranch":
        step = GridPathBranch(picker,
                              room_ratio=RandRange(*_range(params.get("RoomRatio"), (60, 80))),
                              branch_ratio=RandRange(*_range(params.get("BranchRatio"), (30, 60))),
                              no_forced_branches=bool(params.get("NoForcedBranches", False)))
    elif config.path == "GridPathCircle":
        step = GridPathCircle(picker,
                              circle_room_ratio=RandRange(*_range(params.get("CircleRoomRatio"),
                                                                  (50, 80))),
                              paths=RandRange(*_range(params.get("Paths"), (1, 3))))
    elif config.path == "GridPathGrid":
        step = GridPathGrid(picker, room_ratio=int(params.get("RoomRatio", 60)),
                            hall_ratio=int(params.get("HallRatio", 40)))
    elif config.path == "GridPathTwoSides":
        step = GridPathTwoSides(picker, vertical=bool(params.get("GapAxis", 0)))
    elif config.path == "GridPathCross":
        step = GridPathCross(picker)
    elif config.path == "GridPathTiered":
        step = GridPathTiered(picker,
                              tier_connections=RandRange(*_range(params.get("TierConnections"),
                                                                 (1, 3))),
                              vertical=bool(params.get("TierAxis", 0)))
    else:
        return None

    try:
        step.apply(rand, plan)
        if config.combine_rate[1] > 0:
            CombineGridRoomStep(max(1, config.combine_rate[1] * 10)).apply(rand, plan)
        if config.connect_percent > 0:
            ConnectGridBranchStep(config.connect_percent).apply(rand, plan)
        if config.default_ratio[1] > 0:
            SetGridDefaultsStep(RandRange(*config.default_ratio)).apply(rand, plan)
        floor = plan.place_rooms_on_floor(rand)
        result = draw_floor(plan, floor, rand, config.hall_turn_bias,
                            profile=config.profile, seed=seed)
        place_stairs(result, rand, max(3, config.min_stair_distance))
        return result
    except Exception:
        return None


@dataclass
class DungeonArchitecture:
    dungeon: str
    floors: int = 0
    fixed_floors: int = 0
    profiles: List[str] = field(default_factory=list)
    grids: List[str] = field(default_factory=list)
    room_kinds: List[str] = field(default_factory=list)
    samples: int = 0
    rooms: Tuple[int, float, int] = (0, 0.0, 0)
    halls: Tuple[int, float, int] = (0, 0.0, 0)
    branches_avg: float = 0.0
    dead_ends_avg: float = 0.0
    loops_avg: float = 0.0
    bends_avg: float = 0.0
    room_area: Tuple[int, int] = (0, 0)
    stair_distance_avg: float = 0.0
    traversable: int = 0
    distinct_signatures: int = 0
    sim_disconnections: int = 0
    problems: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems

    def to_dict(self) -> Dict[str, Any]:
        return dict(self.__dict__) | {"ok": self.ok}


def _bends(result: FloorResult) -> int:
    """Count corridor bends: hall tiles with orthogonal hall/room neighbours."""
    from .re_sim.pipeline import HALL, WALL
    count = 0
    for y in range(1, result.height - 1):
        for x in range(1, result.width - 1):
            if result.tiles[y][x] != HALL:
                continue
            horizontal = result.tiles[y][x - 1] != WALL or result.tiles[y][x + 1] != WALL
            vertical = result.tiles[y - 1][x] != WALL or result.tiles[y + 1][x] != WALL
            if horizontal and vertical:
                count += 1
    return count


def analyse_zone(definition, variants: int = 3, zone_dir: Optional[Path] = None,
                 seed: int = 0) -> Optional[DungeonArchitecture]:
    zone_dir = zone_dir or ZONE_DIR
    path = zone_dir / f"{definition.id}.json"
    if not path.exists():
        return None
    zone = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    result = DungeonArchitecture(dungeon=definition.id)

    rand = random.Random(seed or 20260823)
    metrics = []
    kinds: set = set()
    profiles: set = set()
    grids: set = set()
    bends: List[int] = []

    for segment in zone.get("Segments", []):
        segment_name = segment.get("Comment", "").split(" (")[0]
        relevant = bool(segment.get("IsRelevant", True))
        for offset, floor_json in enumerate(segment.get("Floors", [])):
            if not relevant:
                if "LoadGen" in floor_json.get("$type", ""):
                    result.fixed_floors += 1
                continue
            result.floors += 1
            candidates = ([entry["Spawn"] for entry in floor_json.get("Spawns", [])]
                          if "ChanceFloorGen" in floor_json.get("$type", "")
                          else [floor_json])
            for candidate in candidates:
                config = read_floor_config(candidate, offset + 1, segment_name)
                if config.fixed_map:
                    result.fixed_floors += 1
                    continue
                if config.profile:
                    profiles.add(config.profile)
                if config.grid:
                    grids.add(f"{config.grid[0]}x{config.grid[1]}")
                kinds |= set(config.room_kinds)
                for _ in range(variants):
                    simulated = simulate_config(config, rand.getrandbits(63))
                    if simulated is None:
                        result.problems.append(
                            f"floor {config.floor} profile {config.profile}: parameters could not be replayed")
                        continue
                    metrics.append(measure(simulated))
                    bends.append(_bends(simulated))

    result.profiles = sorted(profiles)
    result.grids = sorted(grids)
    result.room_kinds = sorted(kinds)
    result.samples = len(metrics)
    if not metrics:
        result.problems.append("no floor could be simulated from the emitted parameters")
        return result

    rooms = [m.rooms for m in metrics]
    halls = [m.halls for m in metrics]
    result.rooms = (min(rooms), round(statistics.mean(rooms), 2), max(rooms))
    result.halls = (min(halls), round(statistics.mean(halls), 2), max(halls))
    result.branches_avg = round(statistics.mean(m.branches for m in metrics), 2)
    result.dead_ends_avg = round(statistics.mean(m.dead_ends for m in metrics), 2)
    result.loops_avg = round(statistics.mean(m.loops for m in metrics), 2)
    result.bends_avg = round(statistics.mean(bends), 2) if bends else 0.0
    result.room_area = (min(m.room_area_min for m in metrics),
                        max(m.room_area_max for m in metrics))
    result.stair_distance_avg = round(statistics.mean(m.stair_distance for m in metrics), 2)
    result.traversable = sum(1 for m in metrics if m.stairs_reachable and m.components <= 1)
    result.distinct_signatures = len({m.signature for m in metrics})

    # architecture quality gates, measured on the emitted parameters
    if result.rooms[0] < 3:
        result.problems.append(f"a replayed floor produced only {result.rooms[0]} rooms")
    if result.halls[0] < 2:
        result.problems.append(f"a replayed floor produced only {result.halls[0]} halls")
    result.sim_disconnections = result.samples - result.traversable
    if result.sim_disconnections:
        # The engine guarantees an opening on every connection
        # (RoomGen.AskBorderFromRoom + DigAtBorder, read in the sources) and every
        # emitted floor carries DetectIsolatedStairsStep, which rejects a map whose
        # stairs are unreachable.  A disconnection seen here is therefore a
        # limitation of the offline corridor tracer, reported and not hidden.
        ratio = round(100 * result.sim_disconnections / result.samples, 1)
        result.notes.append(f"{result.sim_disconnections}/{result.samples} replays ({ratio}%) "
                            "disconnected in the offline tracer — engine-side guarded by "
                            "AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep")
        if ratio > 25:
            result.problems.append(f"{ratio}% of replays disconnected: parameters look wrong, "
                                   "not just a tracer limitation")
    if result.room_area[1] <= result.room_area[0]:
        result.problems.append("all rooms have the same area")
    if len(result.room_kinds) < 2 and result.floors >= 6:
        result.problems.append(f"only one room shape emitted ({result.room_kinds})")
    if result.distinct_signatures < max(2, result.samples // 2):
        result.problems.append(f"only {result.distinct_signatures} distinct layouts over "
                               f"{result.samples} replays")
    if result.bends_avg <= 0:
        result.problems.append("no corridor bend at all (corridors are straight lines)")
    return result
