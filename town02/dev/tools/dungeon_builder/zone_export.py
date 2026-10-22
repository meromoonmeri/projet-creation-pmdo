"""Runtime exporter: DungeonDefinition -> RogueEssence ZoneData JSON.

The exporter is the only place that writes into `Data/Zone`.  It emits real
RogueElements / RogueEssence / PMDC gen steps (see `steps.py`); no layout is
ever pre-computed or cached here — the engine runs those steps with its own
RNG on every dungeon entry.
"""
from __future__ import annotations

import json
import random
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

from . import steps as S
from .definitions import DungeonDefinition, ItemTable, MobEntry, Segment
from .dtef import DtefPackage, resolve as resolve_dtef
from .profiles import ArchitectureProfile, customize
from .rng import DungeonRng

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
VERSION = "0.8.12.0"


@dataclass
class FloorPlanEntry:
    floor: int
    segment: str
    profile: str
    authoring_seed: int = 0
    kind: str = "procedural"          # procedural | fixed
    grid: Tuple[int, int] = (0, 0)
    cell: Tuple[int, int] = (0, 0)
    map_id: str = ""
    weather: Sequence[str] = ()
    dtef: str = ""


@dataclass
class ExportResult:
    zone_path: Path
    floors: List[FloorPlanEntry] = field(default_factory=list)
    segments: List[Dict[str, Any]] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)
    zone_json: Dict[str, Any] = field(default_factory=dict)


# ---------------------------------------------------------------------------
def pick_profile(definition: DungeonDefinition, segment: Segment, rand: random.Random) -> ArchitectureProfile:
    choices = definition.profiles_for(segment)
    weights = [max(1, c.weight) for c in choices]
    choice = rand.choices(choices, weights=weights, k=1)[0]
    return customize(choice.name, choice.overrides)


def rooms_spawn_list(profile: ArchitectureProfile) -> Dict[str, Any]:
    entries = [(S.room_gen(spec.kind, spec.width, spec.height), spec.weight) for spec in profile.rooms]
    return S.spawn_list(entries, S.ROOM_ELEMENT)


def halls_spawn_list(profile: ArchitectureProfile) -> Dict[str, Any]:
    return S.spawn_list([(S.angled_hall(profile.hall_turn_bias), 10)], S.HALL_ELEMENT)


def path_step(profile: ArchitectureProfile, rand: random.Random) -> Dict[str, Any]:
    rooms = rooms_spawn_list(profile)
    halls = halls_spawn_list(profile)
    if profile.path == "circle":
        return S.grid_path_circle(profile.circle_room_ratio, profile.circle_paths, rooms, halls)
    if profile.path == "grid":
        return S.grid_path_grid(profile.grid_room_ratio, profile.grid_hall_ratio, rooms, halls)
    if profile.path == "twosides":
        return S.grid_path_two_sides(rand.random() < 0.5, rooms, halls)
    if profile.path == "cross":
        return S.grid_path_cross(rooms, halls)
    if profile.path == "tiered":
        return S.grid_path_tiered(profile.tier_connections, rand.random() < 0.5, rooms, halls)
    return S.grid_path_branch(profile.room_ratio, profile.branch_ratio, rooms, halls,
                              profile.no_forced_branches)


def combine_step(profile: ArchitectureProfile) -> Optional[Dict[str, Any]]:
    if profile.combine_rate <= 0:
        return None
    big_w = (profile.cell_width[0] + 2, profile.cell_width[1] + 6)
    big_h = (profile.cell_height[0] + 2, profile.cell_height[1] + 6)
    combos = [
        S.combo(2, 1, S.room_gen("round", big_w, profile.cell_height), 10),
        S.combo(1, 2, S.room_gen("round", profile.cell_width, big_h), 10),
        S.combo(2, 1, S.room_gen("blocked", big_w, profile.cell_height), 6),
        S.combo(2, 2, S.room_gen("square", big_w, big_h), 4),
    ]
    rate = (max(1, profile.combine_rate // 10), max(2, profile.combine_rate // 5))
    return S.combine_grid_room(rate, combos)


def floor_gen_steps(definition: DungeonDefinition, segment: Segment, profile: ArchitectureProfile,
                    package: DtefPackage, floor: int, rand: random.Random,
                    weather: Sequence[str] = (),
                    authoring_seed: Optional[int] = None) -> Tuple[Dict[str, Any], FloorPlanEntry]:
    grid_x = rand.randrange(*_span(profile.grid_x))
    grid_y = rand.randrange(*_span(profile.grid_y))
    if profile.path in ("circle", "grid"):
        grid_x, grid_y = max(3, grid_x), max(3, grid_y)
    cell_w = rand.randrange(*_span(profile.cell_width))
    cell_h = rand.randrange(*_span(profile.cell_height))

    stairs = definition.stairs_for(segment, floor)
    min_distance = int(stairs.get("min_distance", max(3, profile.min_stair_distance // 4)))
    music = segment.music or definition.music
    max_foes = segment.max_foes or int(definition.variation.get("max_foes", 6))
    respawn = segment.respawn_time or int(definition.variation.get("respawn_time", 100))

    entries: List[Tuple[Dict[str, Any], Dict[str, Any]]] = [
        (S.priority(-6), S.map_data(music, int(definition.variation.get("time_limit", 1500)))),
        (S.priority(-5), S.init_grid_plan(grid_x, grid_y, cell_w, cell_h, profile.cell_wall)),
        (S.priority(-4), path_step(profile, rand)),
    ]
    # PMDO contains both orderings.  This Builder combines first, then
    # reconnects surviving terminals: that exact sequence is the one exercised
    # by ENGINE_PROTOTYPE_NATIVE (48 real engine floors).  Reconnecting first
    # can create a loop that a later merge immediately erases.
    combined = combine_step(profile)
    if combined:
        entries.append((S.priority(-4), combined))
    if profile.connect_percent > 0:
        entries.append((S.priority(-4), S.connect_grid_branch(profile.connect_percent, profile.hall_turn_bias)))
    if profile.default_ratio[1] > 0:
        entries.append((S.priority(-4), S.set_grid_defaults(profile.default_ratio)))
    stair_distance = stairs.get("distance")
    stair_step = (S.floor_stairs_distance(tuple(stair_distance), stairs.get("exit_tile", "stairs_go_up"))
                  if stair_distance else
                  S.floor_stairs(min_distance, stairs.get("exit_tile", "stairs_go_up")))
    entries.extend([
        (S.priority(-3), S.draw_grid_to_floor()),
        (S.priority(-1), S.draw_floor_to_tile(1)),
        (S.priority(0, 1), S.unbreakable_border(1)),
        (S.priority(1, 2), S.mob_spawn_settings(max_foes, respawn)),
        (S.priority(2), stair_step),
        (S.priority(4), S.map_texture(*package.as_texture_args())),
    ])
    terrain = dict(definition.variation.get("terrain", {}))
    terrain.update(segment.stairs.get("terrain", {}) if segment.stairs else {})
    if terrain.get("enabled"):
        entries.append((S.priority(-1, 2),
                        S.perlin_water(tuple(terrain.get("percent", (8, 14))),
                                       terrain.get("id", "water"),
                                       int(terrain.get("complexity", 3)),
                                       int(terrain.get("softness", 1)),
                                       bool(terrain.get("bowl", True)),
                                       bool(terrain.get("protect_paths", True)))))
    if weather:
        entries.append((S.priority(4, 2), S.default_map_status(list(weather))))
    floor_override = segment.floor_overrides.get(floor, {})
    traps = (definition.features_for(segment).traps or {})
    trap_floors = traps.get("floors")
    trap_enabled_here = (traps.get("enabled") and
                         (not trap_floors or trap_floors[0] <= floor <= trap_floors[1]))
    if trap_enabled_here:
        trap_amount = floor_override.get("trap_amount") or tuple(traps.get("amount", (2, 5)))
        entries.append((S.priority(5), S.trap_spawn_step(tuple(trap_amount))))

    if definition.money != (0, 0) or segment.money != (0, 0):
        entries.append((S.priority(6), S.money_placement_step(
            tuple(definition.variation.get("money_piles", (2, 4))))))
    item_tables = definition.items_for(segment)
    if item_tables:
        default_item_amount = (
            min(table.amount[0] for table in item_tables),
            max(table.amount[1] for table in item_tables),
        )
        item_amount = (floor_override.get("item_amount")
                       or tuple(definition.variation.get("item_amount", default_item_amount)))
        entries.append((S.priority(6, 1), S.item_spawn_step(
            tuple(item_amount), int(definition.variation.get("item_success_percent", 25)))))
    if definition.mobs_for(segment):
        initial_mobs = floor_override.get("initial_mobs") or tuple(definition.variation.get(
            "initial_mobs", (2, max(3, min(max_foes + 1, 8)))))
        entries.append((S.priority(6, 2), S.mob_placement_step(
            tuple(initial_mobs), int(definition.variation.get("mob_clump_factor", 20)))))

    for miniboss in definition.minibosses or []:
        if int(miniboss.get("floor", -1)) != floor:
            continue
        mob = S.mob_json(miniboss["species"], tuple(miniboss.get("level", (1, 1))),
                         miniboss.get("tactic", "wander_smart"),
                         miniboss.get("skills", ()),
                         tuple(miniboss.get("features", ("unrecruitable",))))
        entries.append((S.priority(6, 3), S.miniboss_step(mob)))
    entries.append((S.priority(7), S.detect_isolated_stairs()))

    gen = {"$type": "RogueEssence.LevelGen.GridFloorGen, RogueEssence",
           "GenSteps": [{"Key": key, "Value": value} for key, value in entries],
           "Comment": (f"{segment.name} — profile:{profile.name} — grid {grid_x}x{grid_y} "
                       f"cells {cell_w}x{cell_h} — layout rolled by PMDO ReRandom at runtime")}
    plan = FloorPlanEntry(floor, segment.name, profile.name, 0, "procedural",
                          (grid_x, grid_y), (cell_w, cell_h), weather=tuple(weather),
                          dtef=package.name)
    return gen, plan


def chance_floor_gen(definition: DungeonDefinition, segment: Segment, package: DtefPackage,
                     floor: int, rand: random.Random, weather: Sequence[str] = ()) -> Tuple[Dict[str, Any], FloorPlanEntry]:
    """Build a native runtime-weighted set of architecture profiles.

    ``ChanceFloorGen`` uses ``ReRandom(zoneContext.Seed)`` in RogueEssence, so
    profile selection and the selected GridFloorGen both derive from PMDO's
    real map seed.  The Builder no longer freezes one profile per floor during
    authoring.
    """
    choices = definition.profiles_for(segment, floor)
    spawns: List[Dict[str, Any]] = []
    grids: List[Tuple[int, int]] = []
    cells: List[Tuple[int, int]] = []
    names: List[str] = []
    for choice in choices:
        profile = customize(choice.name, choice.overrides)
        gen, plan = floor_gen_steps(
            definition, segment, profile, package, floor, rand, weather,
            authoring_seed=None,
        )
        spawns.append({"Spawn": gen, "Rate": max(1, int(choice.weight))})
        grids.append(plan.grid)
        cells.append(plan.cell)
        names.append(profile.name)
    if not spawns:
        raise ValueError(f"floor {floor} of {definition.id} has no generation profile")
    wrapper = {
        "$type": "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence",
        "Spawns": spawns,
    }
    plan = FloorPlanEntry(
        floor=floor,
        segment=segment.name,
        profile="|".join(names),
        authoring_seed=0,
        kind="procedural",
        grid=grids[0],
        cell=cells[0],
        weather=tuple(weather),
        dtef=package.name,
    )
    return wrapper, plan


def fixed_floor(map_id: str, comment: str) -> Dict[str, Any]:
    return {"$type": "RogueEssence.LevelGen.LoadGen, RogueEssence",
            "GenSteps": [{"Key": S.priority(-6), "Value": S.mapped_room(map_id)}],
            "Comment": comment}


def _span(rng: Tuple[int, int]) -> Tuple[int, int]:
    lo, hi = rng
    return lo, hi if hi > lo else lo + 1


# ---------------------------------------------------------------------------
def mob_spawns(mobs: Sequence[MobEntry], segment: Segment) -> List[Dict[str, Any]]:
    out = []
    lo, hi = segment.floors
    span = (0, hi - lo + 1)
    for mob in mobs:
        floor_range = span
        if mob.floors:
            floor_range = (max(0, mob.floors[0] - lo), min(hi - lo + 1, mob.floors[1] - lo + 1))
            if floor_range[1] <= floor_range[0]:
                continue
        out.append(S.team_spawn(S.mob_json(mob.species, mob.level, mob.tactic, mob.skills, mob.features),
                                mob.weight, floor_range))
    return out


def item_tables_json(tables: Sequence[ItemTable], segment: Segment) -> Dict[str, Any]:
    lo, hi = segment.floors
    span = (0, hi - lo + 1)
    out = {}
    for table in tables:
        entries = []
        for entry in table.entries:
            floor_range = span
            if entry.floors:
                floor_range = (max(0, entry.floors[0] - lo),
                               min(hi - lo + 1, entry.floors[1] - lo + 1))
                if floor_range[1] <= floor_range[0]:
                    continue
            entries.append((entry.item, entry.weight, floor_range))
        out[table.name] = S.item_table_json(entries, table.amount, span)
    return out


def zone_steps(definition: DungeonDefinition, segment: Segment) -> List[Dict[str, Any]]:
    lo, hi = segment.floors
    span = (0, hi - lo + 1)
    steps: List[Dict[str, Any]] = [S.save_vars_zone_step(), S.floor_name_zone_step(definition.name)]

    money = segment.money if segment.money != (0, 0) else definition.money
    steps.append(S.money_zone_step(money, (max(1, money[0] // 12), max(2, money[1] // 10))))

    tables = definition.items_for(segment)
    if tables:
        steps.append(S.item_zone_step(item_tables_json(tables, segment)))

    mobs = definition.mobs_for(segment)
    if mobs:
        steps.append(S.team_zone_step(mob_spawns(mobs, segment),
                                      [(1, 12, span), (2, 4, span)]))

    features = definition.features_for(segment)

    traps = features.traps or {}
    if traps.get("enabled"):
        trap_entries = []
        for entry in traps.get("entries", []):
            floors = entry.get("floors") or traps.get("floors")
            rng = span if not floors else (
                max(0, int(floors[0]) - lo), min(span[1], int(floors[1]) - lo + 1))
            if rng[1] <= rng[0]:
                continue
            tile_id = entry.get("tile") or entry.get("id")
            if tile_id:
                trap_entries.append((str(tile_id), int(entry.get("weight", 10)), rng,
                                     bool(entry.get("revealed", False))))
        if trap_entries:
            steps.append(S.tile_zone_step(trap_entries))

    shop = features.shop or {}
    if shop.get("enabled"):
        items = [(entry["item"], int(entry.get("price", 0)), int(entry.get("weight", 10)))
                 for entry in shop.get("items", [])]
        if items:
            floors = shop.get("floors")
            rng = span if not floors else (max(0, floors[0] - lo), min(span[1], floors[1] - lo + 1))
            steps.append(S.shop_zone_step(items, rng, int(shop.get("trials", 2)),
                                          int(shop.get("percent", 60))))

    house = features.monster_house or {}
    if house.get("enabled"):
        mob_pool = [S.mob_json(m.species, (m.level[0] + int(house.get("level_boost", 2)),
                                           m.level[1] + int(house.get("level_boost", 2))),
                               m.tactic, m.skills, ("weak",)) for m in mobs[: int(house.get("species", 8))]]
        items = [(entry["item"], int(entry.get("weight", 10))) for entry in house.get("items", [])]
        if mob_pool:
            floors = house.get("floors")
            rng = span if not floors else (max(0, floors[0] - lo), min(span[1], floors[1] - lo + 1))
            steps.append(S.monster_house_zone_step(mob_pool, items, rng,
                                                   int(house.get("trials", 2)),
                                                   int(house.get("percent", 35))))
    vault = features.treasure_room or features.key_room or {}
    if vault.get("enabled"):
        items = [(entry["item"], int(entry.get("weight", 10))) for entry in vault.get("items", [])]
        if not items:
            tables = definition.items_for(segment)
            items = [(entry.item, entry.weight) for table in tables for entry in table.entries][:8]
        if items:
            floors = vault.get("floors")
            rng = span if not floors else (max(0, floors[0] - lo), min(span[1], floors[1] - lo + 1))
            steps.append(S.vault_zone_step(items, rng,
                                           tuple(vault.get("amount", (1, 3))),
                                           int(vault.get("trials", 3)),
                                           int(vault.get("percent", 35))))
    return steps


# ---------------------------------------------------------------------------
def build_zone(definition: DungeonDefinition, rng: Optional[DungeonRng] = None,
               strict_dtef: bool = True) -> ExportResult:
    rng = rng or DungeonRng(label=f"authoring:{definition.id}")
    rand = rng.rand
    result = ExportResult(zone_path=ZONE_DIR / f"{definition.id}.json")

    segments_json: List[Dict[str, Any]] = []
    for segment in definition.segments:
        package = resolve_dtef(definition.dtef_for(segment), strict=strict_dtef)
        floors_json: List[Dict[str, Any]] = []
        for floor in segment.floor_numbers:
            fixed = segment.fixed_floors.get(floor)
            if fixed:
                map_id = fixed.get("map", "")
                if not (MAP_DIR / f"{map_id}.rsmap").exists():
                    result.warnings.append(f"floor {floor}: fixed map '{map_id}' not found in Data/Map")
                floors_json.append(fixed_floor(map_id, fixed.get("comment", "")))
                result.floors.append(FloorPlanEntry(floor, segment.name, "-", 0, "fixed",
                                                    map_id=map_id))
                continue
            weather = _weather_for(definition, segment, floor, rand)
            gen, plan = chance_floor_gen(definition, segment, package, floor, rand, weather)
            floors_json.append(gen)
            result.floors.append(plan)

        segments_json.append({
            "$type": "RogueEssence.LevelGen.LayeredSegment, RogueEssence",
            "Floors": floors_json,
            "ZoneSteps": zone_steps(definition, segment),
            "IsRelevant": True,
            "Comment": f"{segment.name} ({segment.floors[0]}-{segment.floors[1]}) biome={segment.biome}",
        })
        result.segments.append({"name": segment.name, "floors": list(segment.floors),
                                "biome": segment.biome, "dtef": package.name,
                                "kind": "procedural"})

    # Fixed/event/boss floors are runtime segments but do not contribute to the
    # canonical procedural floor count.  This is how PMDO can enter an exact
    # .rsmap counterpart of a canonical Ground without inventing a new biome.
    for fixed_index, fixed_segment in enumerate(definition.fixed_segments):
        map_id = str(fixed_segment["map"])
        if not (MAP_DIR / f"{map_id}.rsmap").exists():
            result.warnings.append(
                f"fixed segment {fixed_index}: map '{map_id}' not found in Data/Map")
        source_floor = int(fixed_segment.get("source_floor", definition.floors + fixed_index + 1))
        floor_json = fixed_floor(map_id, str(fixed_segment.get("comment", "")))
        segments_json.append({
            "$type": "RogueEssence.LevelGen.LayeredSegment, RogueEssence",
            "Floors": [floor_json],
            "ZoneSteps": [S.save_vars_zone_step()],
            "IsRelevant": False,
            "Comment": (f"fixed {fixed_segment.get('role')} source_floor={source_floor} "
                        f"ground={fixed_segment.get('ground', '')}"),
        })
        result.floors.append(FloorPlanEntry(
            source_floor, str(fixed_segment.get("role", "fixed")), "-", 0,
            "fixed", map_id=map_id,
        ))
        result.segments.append({
            "name": str(fixed_segment.get("role", "fixed")),
            "floors": [source_floor, source_floor],
            "biome": str(fixed_segment.get("biome", definition.biome)),
            "dtef": str(fixed_segment.get("dtef", "canonical_ground_layers")),
            "kind": "fixed",
            "map": map_id,
            "ground": str(fixed_segment.get("ground", "")),
        })

    zone = {
        "Version": VERSION,
        "Object": {
            "$type": "RogueEssence.Data.ZoneData, RogueEssence",
            "Name": {"DefaultText": definition.name.get("en", definition.id),
                     "LocalTexts": {k: v for k, v in definition.name.items() if k != "en"}},
            "Released": definition.released,
            "Comment": ((definition.comment + " ") if definition.comment else "")
                       + (f"[built by tools/dungeon_builder from "
                          f"{definition.path.name if definition.path else 'definition'}]"),
            "NoEXP": False, "ExpPercent": 100, "Level": definition.level, "LevelCap": False,
            "KeepSkills": False, "TeamRestrict": False, "TeamSize": -1, "MoneyRestrict": False,
            "BagRestrict": -1, "KeepTreasure": False, "BagSize": -1, "Persistent": False,
            "Rescues": definition.rescues, "Rogue": 0,
            "Segments": segments_json,
            "GroundMaps": list(definition.fixed_grounds.values()),
        },
    }
    result.zone_json = zone
    return result


def _weather_for(definition: DungeonDefinition, segment: Segment, floor: int,
                 rand: random.Random) -> List[str]:
    features = definition.features_for(segment)
    for entry in features.weather or []:
        floors = entry.get("floors")
        if floors and not (floors[0] <= floor <= floors[1]):
            continue
        chance = int(entry.get("chance", 100))
        if rand.randrange(100) < chance:
            status = entry.get("status", "clear")
            return [status] * 4
    return []


def write_zone(result: ExportResult, update_index: bool = True,
               definition: Optional[DungeonDefinition] = None) -> Path:
    result.zone_path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(result.zone_json, ensure_ascii=False, indent=2)
    result.zone_path.write_text("\ufeff" + text, encoding="utf-8")
    if update_index and definition is not None:
        update_zone_index(definition, result)
    return result.zone_path


def update_zone_index(definition: DungeonDefinition, result: ExportResult,
                      index_path: Optional[Path] = None) -> None:
    index_path = index_path or (ZONE_DIR / "index.idx")
    if not index_path.exists():
        return
    data = json.loads(index_path.read_text(encoding="utf-8-sig"))
    obj = data["Object"]
    maps = []
    for segment in definition.segments:
        maps.append(list(range(segment.length)))
    maps.extend([[0] for _ in definition.fixed_segments])
    obj[definition.id] = {
        "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
        "ExpPercent": 100, "Level": definition.level, "LevelCap": False, "KeepSkills": False,
        "TeamRestrict": False, "TeamSize": -1, "MoneyRestrict": False, "BagRestrict": -1,
        "KeepTreasure": False, "BagSize": -1, "Rescues": definition.rescues,
        "CountedFloors": definition.floors, "Rogue": 0,
        "Grounds": list(definition.fixed_grounds.values()),
        "Maps": maps,
        "Name": {"DefaultText": definition.name.get("en", definition.id),
                 "LocalTexts": {k: v for k, v in definition.name.items() if k != "en"}},
        "Released": definition.released,
        "Comment": definition.comment,
        "SortOrder": definition.chapter,
    }
    index_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
