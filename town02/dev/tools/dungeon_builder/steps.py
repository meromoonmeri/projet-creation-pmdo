"""RogueElements / RogueEssence / PMDC step adapter.

Every helper here returns the exact JSON shape that RogueEssence 0.8.12
deserialises, cross-checked against the zones already shipped in this
repository (`Data/Zone/*.json`).  The builder never invents a class name: the
`$type` strings below all appear in existing, working zone data.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, Iterable, List, Sequence, Tuple

MAP_CTX = "RogueEssence.LevelGen.MapGenContext, RogueEssence"
LIST_CTX = "RogueEssence.LevelGen.ListMapGenContext, RogueEssence"


def priority(*parts: int) -> Dict[str, Any]:
    return {"str": list(parts)}


def rand_range(rng: Tuple[int, int]) -> Dict[str, int]:
    lo, hi = rng
    return {"Min": int(lo), "Max": int(hi)}


def _t(name: str, assembly: str, ctx: str | None = None) -> str:
    if ctx:
        return f"{name}`1[[{ctx}]], {assembly}"
    return f"{name}, {assembly}"


WALL_TILE = {
    "$type": "RogueEssence.Dungeon.Tile, RogueEssence",
    "Data": {"ID": "wall", "TileTex": {"AutoTileset": "", "Associates": [], "Layers": [],
                                       "NeighborCode": -1}, "StableTex": False},
    "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False, "Owner": 0, "TileStates": []},
}

CONNECTIVITY_MAIN = [{"$type": "PMDC.LevelGen.ConnectivityRoom, PMDC", "Connection": 1}]
FILTER_CONNECTIVITY_MAIN = {"$type": "PMDC.LevelGen.RoomFilterConnectivity, PMDC", "Connection": 1}
FILTER_NOT_BOSS = {"$type": "RogueElements.RoomFilterComponent, RogueElements", "Negate": True,
                   "Components": [{"$type": "PMDC.LevelGen.BossRoom, PMDC"}]}
FILTER_NOT_NOCONNECT = {"$type": "RogueElements.RoomFilterComponent, RogueElements", "Negate": True,
                        "Components": [{"$type": "PMDC.LevelGen.NoConnectRoom, PMDC"}]}
FILTER_NOT_IMMUTABLE = {"$type": "RogueElements.RoomFilterComponent, RogueElements", "Negate": True,
                        "Components": [{"$type": "RogueEssence.LevelGen.ImmutableRoom, RogueEssence"}]}
FILTER_NOT_DEFAULT_GEN = {"$type": "RogueElements.RoomFilterDefaultGen, RogueElements", "Negate": True}


# --- room generators -------------------------------------------------------
def room_gen(kind: str, width: Tuple[int, int], height: Tuple[int, int], ctx: str = MAP_CTX) -> Dict[str, Any]:
    kind = kind.lower()
    if kind == "round":
        return {"$type": _t("RogueElements.RoomGenRound", "RogueElements", ctx),
                "Width": rand_range(width), "Height": rand_range(height)}
    if kind == "cave":
        return {"$type": _t("RogueElements.RoomGenCave", "RogueElements", ctx),
                "Width": rand_range(width), "Height": rand_range(height)}
    if kind == "cross":
        return {"$type": _t("RogueElements.RoomGenCross", "RogueElements", ctx),
                "MajorWidth": rand_range(width), "MinorWidth": rand_range((max(2, width[0] // 2),
                                                                           max(3, width[1] // 2))),
                "MajorHeight": rand_range(height), "MinorHeight": rand_range((max(2, height[0] // 2),
                                                                              max(3, height[1] // 2)))}
    if kind == "blocked":
        return {"$type": _t("RogueElements.RoomGenBlocked", "RogueElements", ctx),
                "Width": rand_range(width), "Height": rand_range(height),
                "BlockWidth": rand_range((1, max(2, width[0] // 2))),
                "BlockHeight": rand_range((1, max(2, height[0] // 2))),
                "BlockTerrain": WALL_TILE}
    return {"$type": _t("RogueElements.RoomGenSquare", "RogueElements", ctx),
            "Width": rand_range(width), "Height": rand_range(height)}


def angled_hall(turn_bias: int, width: Tuple[int, int] = (0, 0), height: Tuple[int, int] = (0, 0),
                ctx: str = MAP_CTX) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.RoomGenAngledHall", "RogueElements", ctx),
            "HallTurnBias": int(turn_bias),
            "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"},
            "Width": rand_range(width), "Height": rand_range(height)}


def spawn_list(entries: Iterable[Tuple[Dict[str, Any], int]], element: str) -> Dict[str, Any]:
    return {"$type": f"RogueElements.SpawnList`1[[{element}]], RogueElements",
            "$values": [{"Spawn": spawn, "Rate": rate} for spawn, rate in entries]}


ROOM_ELEMENT = f"RogueElements.RoomGen`1[[{MAP_CTX}]], RogueElements"
HALL_ELEMENT = f"RogueElements.PermissiveRoomGen`1[[{MAP_CTX}]], RogueElements"


def preset_picker(spawn: Dict[str, Any], element: str) -> Dict[str, Any]:
    return {"$type": f"RogueElements.PresetPicker`1[[{element}]], RogueElements", "ToSpawn": spawn}


# --- floor gen steps -------------------------------------------------------
def init_grid_plan(cell_x: int, cell_y: int, cell_w: int, cell_h: int, cell_wall: int = 1) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.InitGridPlanStep", "RogueElements", MAP_CTX),
            "CellWidth": cell_w, "CellHeight": cell_h, "CellX": cell_x, "CellY": cell_y,
            "CellWall": cell_wall, "Wrap": False}


def grid_path_branch(room_ratio, branch_ratio, rooms, halls, no_forced: bool = False) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.GridPathBranch", "RogueElements", MAP_CTX),
            "RoomRatio": rand_range(room_ratio), "BranchRatio": rand_range(branch_ratio),
            "NoForcedBranches": bool(no_forced),
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def grid_path_circle(circle_ratio, paths, rooms, halls) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.GridPathCircle", "RogueElements", MAP_CTX),
            "CircleRoomRatio": rand_range(circle_ratio), "Paths": rand_range(paths),
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def grid_path_grid(room_ratio: int, hall_ratio: int, rooms, halls) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.GridPathGrid", "RogueElements", MAP_CTX),
            "RoomRatio": int(room_ratio), "HallRatio": int(hall_ratio),
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def grid_path_two_sides(vertical: bool, rooms, halls) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.GridPathTwoSides", "RogueElements", MAP_CTX),
            "GapAxis": 1 if vertical else 0,
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def grid_path_cross(rooms, halls) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.GridPathCross", "RogueElements", MAP_CTX),
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def grid_path_tiered(tier_connections: Tuple[int, int], vertical: bool, rooms, halls) -> Dict[str, Any]:
    """RogueEssence.LevelGen.GridPathTiered (native tiered grid)."""
    return {"$type": _t("RogueEssence.LevelGen.GridPathTiered", "RogueEssence", MAP_CTX),
            "TierAxis": 1 if vertical else 0,
            "TierConnections": rand_range(tier_connections),
            "GenericRooms": rooms, "RoomComponents": CONNECTIVITY_MAIN,
            "GenericHalls": halls, "HallComponents": CONNECTIVITY_MAIN}


def connect_grid_branch(percent: int, turn_bias: int = 50) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.ConnectGridBranchStep", "RogueElements", MAP_CTX),
            "ConnectPercent": int(percent), "Filters": [FILTER_NOT_NOCONNECT],
            "GenericHalls": preset_picker(angled_hall(turn_bias), HALL_ELEMENT),
            "HallComponents": CONNECTIVITY_MAIN}


def set_grid_defaults(ratio: Tuple[int, int]) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.SetGridDefaultsStep", "RogueElements", MAP_CTX),
            "DefaultRatio": rand_range(ratio),
            "Filters": [FILTER_CONNECTIVITY_MAIN]}


def combine_grid_room(merge_rate: Tuple[int, int], combos: Sequence[Dict[str, Any]]) -> Dict[str, Any]:
    return {"$type": _t("RogueEssence.LevelGen.CombineGridRoomStep", "RogueEssence", MAP_CTX),
            "MergeRate": rand_range(merge_rate),
            "Filters": [FILTER_NOT_IMMUTABLE, FILTER_CONNECTIVITY_MAIN, FILTER_NOT_DEFAULT_GEN],
            "RoomComponents": CONNECTIVITY_MAIN,
            "Combos": list(combos)}


def combo(size_x: int, size_y: int, giant: Dict[str, Any], rate: int = 10) -> Dict[str, Any]:
    return {"Spawn": {"Size": {"X": size_x, "Y": size_y}, "GiantRoom": giant}, "Rate": rate}


def draw_grid_to_floor() -> Dict[str, Any]:
    return {"$type": _t("RogueElements.DrawGridToFloorStep", "RogueElements", MAP_CTX)}


def draw_floor_to_tile(padding: int = 1) -> Dict[str, Any]:
    return {"$type": _t("RogueElements.DrawFloorToTileStep", "RogueElements", MAP_CTX), "Padding": padding}


def unbreakable_border(thickness: int = 1) -> Dict[str, Any]:
    return {"$type": _t("RogueEssence.LevelGen.UnbreakableBorderStep", "RogueEssence", MAP_CTX),
            "Thickness": thickness}


def mob_spawn_settings(max_foes: int, respawn_time: int) -> Dict[str, Any]:
    return {"$type": _t("PMDC.LevelGen.MobSpawnSettingsStep", "PMDC", MAP_CTX),
            "Priority": priority(15),
            "Respawn": {"$type": "PMDC.Dungeon.RespawnFromEligibleEvent, PMDC",
                        "MaxFoes": int(max_foes), "RespawnTime": int(respawn_time)},
            "MaxFoes": 0, "RespawnTime": 0}


def _stairs_payload(exit_tile: str) -> Dict[str, Any]:
    return {
        "Entrances": [{"Loc": {"X": 0, "Y": 0}, "Dir": 0}],
        "Exits": [{"Loc": {"X": 0, "Y": 0},
                   "Tile": {"TileLoc": {"X": 0, "Y": 0}, "ID": exit_tile, "Revealed": True,
                            "Owner": 0, "TileStates": []}}],
        "Filters": [FILTER_CONNECTIVITY_MAIN, FILTER_NOT_BOSS],
    }


def floor_stairs(min_distance: int, exit_tile: str = "stairs_go_up") -> Dict[str, Any]:
    return {
        "$type": ("RogueElements.FloorStairsStep`3[["
                  f"{MAP_CTX}],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
                  "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"),
        "MinDistance": int(min_distance),
        **_stairs_payload(exit_tile),
    }


def floor_stairs_distance(distance: Tuple[int, int], exit_tile: str = "stairs_go_up") -> Dict[str, Any]:
    """Native PMDC stair placement with an inclusive/exclusive tile range.

    ``FloorStairsDistanceStep`` measures Manhattan distance between candidate
    room origins.  Runtime validation still measures the actual traversable
    tile path after placement; this step is a fair-play bound, not a substitute
    for reachability validation.
    """
    return {
        "$type": ("PMDC.LevelGen.FloorStairsDistanceStep`3[["
                  f"{MAP_CTX}],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
                  "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], PMDC"),
        "Distance": {"Min": int(distance[0]), "Max": int(distance[1])},
        **_stairs_payload(exit_tile),
    }


def detect_isolated_stairs() -> Dict[str, Any]:
    return {"$type": ("RogueElements.DetectIsolatedStairsStep`3[["
                      f"{MAP_CTX}],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
                      "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements")}


def erase_isolated() -> Dict[str, Any]:
    return {"$type": _t("RogueElements.EraseIsolatedStep", "RogueElements", MAP_CTX),
            "Terrain": WALL_TILE}


def terrain_tile(terrain_id: str) -> Dict[str, Any]:
    return {"$type": "RogueEssence.Dungeon.Tile, RogueEssence",
            "Data": {"ID": terrain_id, "TileTex": {"AutoTileset": "", "Associates": [], "Layers": [],
                                                   "NeighborCode": -1}, "StableTex": False},
            "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False, "Owner": 0,
                       "TileStates": []}}


def perlin_water(percent: Tuple[int, int], terrain_id: str = "water", complexity: int = 3,
                 softness: int = 1, bowl: bool = True, protect_paths: bool = True) -> Dict[str, Any]:
    """RogueElements.PerlinWaterStep — native water/lava fields.

    `protect_paths` wraps the terrain stencil in NoChokepointTerrainStencil so the
    engine itself refuses to cut a mandatory path with terrain.
    """
    stencil: Dict[str, Any] = {"$type": _t("RogueElements.MapTerrainStencil", "RogueElements", MAP_CTX),
                               "Room": False, "Wall": True, "Blocked": False, "Not": False}
    if protect_paths:
        # exact shape used by the shipped zones (apricorn_grove): the stencil
        # refuses any terrain placement that would create a chokepoint.
        stencil = {"$type": _t("RogueElements.NoChokepointTerrainStencil", "RogueElements", MAP_CTX),
                   "TileStencil": {"$type": _t("RogueElements.MapTerrainStencil", "RogueElements",
                                               MAP_CTX),
                                   "Room": True, "Wall": False, "Blocked": False, "Not": False},
                   "Global": False, "Negate": True}
    return {"$type": _t("RogueElements.PerlinWaterStep", "RogueElements", MAP_CTX),
            "OrderComplexity": complexity, "OrderSoftness": softness,
            "WaterPercent": rand_range(percent), "Bowl": bowl,
            "Terrain": terrain_tile(terrain_id), "TerrainStencil": stencil}


def map_texture(floor_tileset: str, wall_tileset: str, secondary_tileset: str,
                element: str = "normal") -> Dict[str, Any]:
    return {"$type": _t("RogueEssence.LevelGen.MapTextureStep", "RogueEssence", MAP_CTX),
            "GroundTileset": floor_tileset, "BlockTileset": wall_tileset,
            "WaterTileset": secondary_tileset,
            "LayeredGround": False, "IndependentGround": False, "GroundElement": element,
            "Background": {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                           "MapLoc": {"X": 0, "Y": 0},
                           "BGAnim": {"AnimIndex": "", "FrameTime": 1, "StartFrame": -1,
                                      "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0},
                           "BGMovement": {"X": 0, "Y": 0}, "Parallax": "0, 0",
                           "RepeatX": False, "RepeatY": False}}


def map_data(music: str, time_limit: int = 1500) -> Dict[str, Any]:
    return {"$type": _t("PMDC.LevelGen.MapDataStep", "PMDC", MAP_CTX),
            "Music": music, "TimeLimit": time_limit, "TileSight": 0, "CharSight": 0,
            "ClampCamera": False}


def map_name_id(floor_index: int) -> Dict[str, Any]:
    return {"$type": _t("RogueEssence.LevelGen.MapNameIDStep", "RogueEssence", MAP_CTX),
            "MapID": floor_index}


def default_map_status(statuses: Sequence[str]) -> Dict[str, Any]:
    return {"$type": _t("PMDC.LevelGen.DefaultMapStatusStep", "PMDC", MAP_CTX),
            "SetterID": "default_weather", "DefaultMapStatus": list(statuses)}


def mapped_room(map_id: str) -> Dict[str, Any]:
    return {"$type": _t("RogueEssence.LevelGen.MappedRoomStep", "RogueEssence",
                        "RogueEssence.LevelGen.MapLoadContext, RogueEssence"),
            "MapID": map_id}


# --- zone steps ------------------------------------------------------------
def money_zone_step(start: Tuple[int, int], add: Tuple[int, int]) -> Dict[str, Any]:
    return {"$type": "RogueEssence.LevelGen.MoneySpawnZoneStep, RogueEssence",
            "Priority": priority(1),
            "StartAmount": rand_range(start), "AddAmount": rand_range(add),
            "ModStates": [{"assembly": "PMDC, Version=0.8.11.0, Culture=neutral, PublicKeyToken=null",
                           "type": "PMDC.Dungeon.CoinModGenState"}]}


def item_zone_step(tables: Dict[str, Dict[str, Any]]) -> Dict[str, Any]:
    return {"$type": "RogueEssence.LevelGen.ItemSpawnZoneStep, RogueEssence",
            "Priority": priority(1, 1), "Spawns": tables}


def item_table_json(entries: Sequence[Tuple[str, int, Tuple[int, int]]],
                    amount: Tuple[int, int], floor_range: Tuple[int, int]) -> Dict[str, Any]:
    spawns = []
    for item_id, rate, rng in entries:
        spawns.append({"Spawn": {"ID": item_id, "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0},
                       "Rate": rate, "Range": rand_range(rng)})
    avg = max(1, (amount[0] + amount[1]) // 2)
    return {"Spawns": spawns,
            "SpawnRates": {"nodes": [{"Item": avg, "Range": rand_range(floor_range)}]}}


def mob_json(species: str, level: Tuple[int, int], tactic: str, skills: Sequence[str],
             features: Sequence[str]) -> Dict[str, Any]:
    feature_map = {
        "weak": {"$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"},
        "moves_off": {"$type": "PMDC.LevelGen.MobSpawnMovesOff, PMDC", "StartAt": 2, "Remove": False},
        "unrecruitable": {"$type": "PMDC.LevelGen.MobSpawnUnrecruitable, PMDC"},
    }
    return {"BaseForm": {"Species": species, "Form": 0, "Skin": "", "Gender": -1},
            "Level": rand_range(level),
            "SpecifiedSkills": list(skills),
            "Intrinsic": "", "Tactic": tactic, "SpawnConditions": [],
            "SpawnFeatures": [feature_map[f] for f in features if f in feature_map]}


def team_zone_step(spawns: Sequence[Dict[str, Any]], team_sizes: Sequence[Tuple[int, int, Tuple[int, int]]]) -> Dict[str, Any]:
    """RogueEssence.LevelGen.TeamSpawnZoneStep (TeamSizes is a plain SpawnRangeList payload)."""
    return {"$type": "RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence",
            "Priority": priority(1, 2),
            "Spawns": list(spawns),
            "SpecificSpawns": [],
            "TeamSizes": [{"Spawn": size, "Rate": rate, "Range": rand_range(rng)}
                          for size, rate, rng in team_sizes]}


def team_spawn(mob: Dict[str, Any], rate: int, floor_range: Tuple[int, int]) -> Dict[str, Any]:
    return {"Spawn": {"Spawn": mob, "Role": 0}, "Rate": rate, "Range": rand_range(floor_range)}


def tile_zone_step(entries: Sequence[Tuple[str, int, Tuple[int, int], bool]]) -> Dict[str, Any]:
    """Native per-floor trap/tile spawn table."""
    spawns = []
    for tile_id, weight, floor_range, revealed in entries:
        spawns.append({
            "Spawn": {"TileLoc": {"X": 0, "Y": 0}, "ID": tile_id,
                      "Revealed": bool(revealed), "Owner": 0, "TileStates": []},
            "Rate": int(weight), "Range": rand_range(floor_range),
        })
    return {"$type": "RogueEssence.LevelGen.TileSpawnZoneStep, RogueEssence",
            "Priority": priority(1, 3), "Spawns": spawns}


def _context_spawner(spawnable: str, amount: Tuple[int, int]) -> Dict[str, Any]:
    return {
        "$type": ("RogueElements.ContextSpawner`2[["
                  f"{MAP_CTX}],[{spawnable}]], RogueElements"),
        "Amount": rand_range(amount),
    }


def trap_spawn_step(amount: Tuple[int, int]) -> Dict[str, Any]:
    """Place traps drawn from the map's native EffectTile spawn table."""
    effect = "RogueEssence.Dungeon.EffectTile, RogueEssence"
    return {
        "$type": ("RogueElements.RandomRoomSpawnStep`2[["
                  f"{MAP_CTX}],[{effect}]], RogueElements"),
        "SuccessPercent": 100, "IncludeHalls": False,
        "Filters": [FILTER_CONNECTIVITY_MAIN, FILTER_NOT_BOSS],
        "Spawn": _context_spawner(effect, amount),
    }


def item_spawn_step(amount: Tuple[int, int], success_percent: int = 25) -> Dict[str, Any]:
    """Native distance-weighted placement from ItemSpawnZoneStep's table."""
    item = "RogueEssence.Dungeon.InvItem, RogueEssence"
    entrance = "RogueEssence.LevelGen.MapGenEntrance, RogueEssence"
    return {
        "$type": ("RogueElements.DueSpawnStep`3[["
                  f"{MAP_CTX}],[{item}],[{entrance}]], RogueElements"),
        "SuccessPercent": int(success_percent), "IncludeHalls": False,
        "Filters": [FILTER_CONNECTIVITY_MAIN, FILTER_NOT_BOSS],
        "Spawn": _context_spawner(item, amount),
    }


def mob_placement_step(amount: Tuple[int, int], clump_factor: int = 20) -> Dict[str, Any]:
    return {
        "$type": _t("RogueEssence.LevelGen.PlaceRandomMobsStep", "RogueEssence", MAP_CTX),
        "Filters": [FILTER_CONNECTIVITY_MAIN, FILTER_NOT_BOSS],
        "IncludeHalls": False,
        "Spawn": {
            "$type": _t("RogueEssence.LevelGen.TeamContextSpawner", "RogueEssence", MAP_CTX),
            "Amount": rand_range(amount),
        },
        "Ally": False, "ClumpFactor": int(clump_factor),
    }


def money_placement_step(div_amount: Tuple[int, int] = (2, 4)) -> Dict[str, Any]:
    money = "RogueEssence.LevelGen.MoneySpawn, RogueEssence"
    return {
        "$type": ("RogueElements.TerminalSpawnStep`2[["
                  f"{MAP_CTX}],[{money}]], RogueElements"),
        "IncludeHalls": False,
        "Filters": [FILTER_CONNECTIVITY_MAIN, FILTER_NOT_BOSS],
        "Spawn": {
            "$type": _t("RogueEssence.LevelGen.MoneyDivSpawner", "RogueEssence", MAP_CTX),
            "DivAmount": rand_range(div_amount),
        },
    }


def _template(name: str) -> Dict[str, Any]:
    path = Path(__file__).resolve().parent / "templates" / f"{name}.json"
    return json.loads(path.read_text(encoding="utf-8"))


def shop_zone_step(items: Sequence[Tuple[str, int, int]], floor_range: Tuple[int, int],
                   trials: int = 2, percent: int = 70) -> Dict[str, Any]:
    """Native Kecleon shop: PMDC.LevelGen.ShopStep spread over a floor range.

    The shopkeeper roster, security status and filters come from the validated
    in-repo template (`templates/shop_kecleon.json`); only the stock is
    configured per dungeon.
    """
    shop = _template("shop_kecleon")
    shop["Items"] = [{"Spawn": {"IsMoney": False, "Cursed": False, "Value": item_id,
                                "HiddenValue": "", "Amount": 0, "Price": price,
                                "TileLoc": {"X": 0, "Y": 0}}, "Rate": rate}
                     for item_id, price, rate in items]
    return {"$type": "RogueEssence.LevelGen.SpreadStepRangeZoneStep, RogueEssence",
            "StepPriority": priority(4, 2),
            "Spawns": [{"Spawn": shop, "Rate": 10, "Range": rand_range(floor_range)}],
            "SpreadPlan": {"$type": "RogueEssence.LevelGen.SpreadPlanQuota, RogueEssence",
                           "Quota": {"$type": "RogueElements.RandBinomial, RogueElements",
                                     "Offset": 0, "Trials": trials, "Percent": percent},
                           "Replaceable": False, "FloorRange": rand_range(floor_range)},
            "ModStates": [{"assembly": "PMDC, Version=0.8.11.0, Culture=neutral, PublicKeyToken=null",
                           "type": "PMDC.Dungeon.ShopModGenState"}]}


def monster_house_zone_step(mobs: Sequence[Dict[str, Any]], items: Sequence[Tuple[str, int]],
                            floor_range: Tuple[int, int], trials: int = 2,
                            percent: int = 40) -> Dict[str, Any]:
    """Native monster house: PMDC.LevelGen.SpreadHouseZoneStep."""
    template = _template("monster_house")
    themes_items = template["ItemThemes"]
    themes_mobs = template["MobThemes"]
    for theme in themes_items + themes_mobs:
        theme["Range"] = rand_range(floor_range)
    return {"$type": "PMDC.LevelGen.SpreadHouseZoneStep, PMDC",
            "Priority": priority(4, 1),
            "HouseStepSpawns": template["HouseStepSpawns"],
            "Items": [{"Spawn": {"IsMoney": False, "Cursed": False, "Value": item_id, "HiddenValue": "",
                                 "Amount": 0, "Price": 0, "TileLoc": {"X": 0, "Y": 0}},
                       "Rate": rate, "Range": rand_range(floor_range)} for item_id, rate in items],
            "ItemThemes": themes_items,
            "Mobs": [{"Spawn": {"Spawn": mob, "Role": 0}, "Rate": 10, "Range": rand_range(floor_range)}
                     for mob in mobs],
            "MobThemes": themes_mobs,
            "SpreadPlan": {"$type": "RogueEssence.LevelGen.SpreadPlanQuota, RogueEssence",
                           "Quota": {"$type": "RogueElements.RandBinomial, RogueElements",
                                     "Offset": 0, "Trials": trials, "Percent": percent},
                           "Replaceable": False, "FloorRange": rand_range(floor_range)},
            "ModStates": template["ModStates"]}


def floor_name_zone_step(name: Dict[str, str]) -> Dict[str, Any]:
    return {"$type": "PMDC.LevelGen.FloorNameDropZoneStep, PMDC",
            "Priority": priority(0), "DropPriority": priority(-6),
            "Name": {"DefaultText": name.get("en", ""),
                     "LocalTexts": {k: v for k, v in name.items() if k != "en"}}}


def save_vars_zone_step() -> Dict[str, Any]:
    return {"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC", "Priority": priority(-6)}


def miniboss_step(mob: Dict[str, Any]) -> Dict[str, Any]:
    """A single reinforced foe on one floor (RogueEssence.LevelGen.MobSpawnStep +
    PlaceRandomMobsStep-compatible PoolTeamSpawner, as used by the shipped zones)."""
    return {"$type": _t("RogueEssence.LevelGen.MobSpawnStep", "RogueEssence", MAP_CTX),
            "Spawns": [{"Spawn": {"$type": "RogueEssence.LevelGen.PoolTeamSpawner, RogueEssence",
                                  "Explorer": False,
                                  "Spawns": [{"Spawn": {"Spawn": mob, "Role": 0}, "Rate": 10}],
                                  "TeamSizes": [{"Spawn": 1, "Rate": 10}]},
                        "Rate": 10}]}


def vault_zone_step(items: Sequence[Tuple[str, int]], floor_range: Tuple[int, int],
                    amount: Tuple[int, int] = (1, 3), trials: int = 3,
                    percent: int = 40) -> Dict[str, Any]:
    """Treasure/Key room: PMDC.LevelGen.SpreadVaultZoneStep (native).

    The vault machinery (ResizeFloorStep, AddConnectedRoomsRandStep, locked-door
    tiles, key placement) comes from the validated in-repo template; the builder
    only injects the dungeon's treasure list and floor range.
    """
    template = _template("vault_room")
    step = dict(template)
    step["Items"] = [{"Spawn": {"ID": item_id, "Cursed": False, "HiddenValue": "", "Amount": 0,
                                "Price": 0}, "Rate": rate, "Range": rand_range(floor_range)}
                     for item_id, rate in items]
    step["ItemAmount"] = {"nodes": [{"Item": rand_range(amount), "Range": rand_range(floor_range)}]}
    step["SpreadPlan"] = {"$type": "RogueEssence.LevelGen.SpreadPlanQuota, RogueEssence",
                          "Quota": {"$type": "RogueElements.RandBinomial, RogueElements",
                                    "Offset": 0, "Trials": trials, "Percent": percent},
                          "Replaceable": False, "FloorRange": rand_range(floor_range)}
    return step
