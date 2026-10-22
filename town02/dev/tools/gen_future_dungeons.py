#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_future_dungeons.py — GÉNÉRATEUR DES 6 DONJONS DU FUTUR (NDS → PMDO natif).

Reconstruit, depuis mappa_s.bin / monster.md (données NDS), les 6 Zones PMDO
du parcours futur du main story (D27-D32), avec :
  - 46 floors (8+15+8+6+1+8) ;
  - tables Pokémon NDS par floor (md_index → espèce PMDO, niveau exact, poids) ;
  - tables de pièges NDS (TileSpawnZoneStep) ;
  - monster houses NDS (SpreadHouseZoneStep, 5% Sealed Ruin/Pit) ;
  - musiques, darkness, densités, tilesets par tranche de floors ;
  - UNIQUEMENT des types natifs PMDO 0.8.12.0 (jamais de $type inconnu).

Le crash MultiSpawner est corrigé : PlaceRandomMobsStep utilise désormais
TeamContextSpawner (type natif), et les tables d'ennemis passent par
MobSpawnStep + PoolTeamSpawner (même format que vallee_fertile/wish_cave).
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import json
import os
import collections

OUT = "/tmp/v4work/Data/Zone"
DOCS = "/home/user/V4/docs/ssb_ir"

# ---------------------------------------------------------------------------
# Données NDS (extraites dans _future_dungeons_mappa.json et _md2dex.json)
# ---------------------------------------------------------------------------
with open(os.path.join(DOCS, "_future_dungeons_mappa.json"), encoding="utf-8") as f:
    MAPPA = {int(k): v for k, v in json.load(f).items()}
with open(os.path.join(DOCS, "_md2dex.json"), encoding="utf-8") as f:
    MD2DEX = {int(k): v for k, v in json.load(f).items()}

# ---------------------------------------------------------------------------
# CORRECTION 2026-08-09 (audit maître NDS → PMDO) :
# Le champ monstre de mappa_s.bin est le MONSTER_ID (énumération pmdsky-debug,
# 1-based, identique au « species code » : Bulbasaur=1, ...). L'ancienne table
# DEX_SPECIES indexée par « npn+1 » (national_dex-1+1) donnait des espèces
# DÉCALÉES pour tous les ids après le bloc des formes (28 formes de Zarbi
# décalent tout) : Magnemite→Magneton, Ditto→Eevee, Skarmory→Houndour,
# Grumpig→Spinda, Drifloon→Drifblim, Onix→Drowzee, Muk→Shellder, etc.
# La table ci-dessous est l'identité DIRECTE raw mappa id → espèce PMDO,
# vérifiée espèce par espèce contre Bulbapedia (Sky) et pmdsky-debug
# (headers/types/common/enums.h, MONSTER_ID_GENDERED).
# ---------------------------------------------------------------------------
MID_SPECIES = {
    41: "zubat", 42: "golbat", 67: "machoke", 68: "machamp",
    81: "magnemite", 82: "magneton", 89: "muk", 92: "gastly",
    93: "haunter", 94: "gengar", 95: "onix", 132: "ditto",
    169: "crobat", 189: "jumpluff", 200: "misdreavus", 232: "forretress",
    254: "skarmory", 354: "grumpig", 372: "claydol", 386: "banette",
    388: "dusclops", 404: "shelgon", 407: "metang", 453: "mothim",
    467: "drifloon", 468: "drifblim", 471: "mismagius", 484: "spiritomb",
    486: "gabite", 507: "tangrowth", 514: "gliscor", 518: "probopass",
}

# ---------------------------------------------------------------------------
# Mapping traps NDS (MappaTrapType) -> trap PMDO (noms attestés dans le mod)
# ---------------------------------------------------------------------------
TRAP_MAP = {
    1: "trap_mud", 2: "trap_sticky", 3: "trap_grimy", 4: "trap_summon",
    7: "trap_gust", 8: "trap_spin", 9: "trap_slumber", 10: "trap_slow",
    11: "trap_seal", 12: "trap_poison", 13: "trap_self_destruct",
    14: "trap_explosion", 15: "trap_pp_leech", 16: "trap_chestnut",
    18: "trap_trigger", 22: "trap_trip", 24: "trap_grudge",
}
# traps NDS sans équivalent PMDO direct (documentés, non inventés)
TRAP_UNMAPPED = {5: "Pitfall", 6: "Warp", 17: "WonderTile", 19: "SpikedTile",
                 20: "StealthRock", 21: "ToxicSpikes", 23: "RandomTrap"}

# auto-tilesets PMDO par tileset NDS de donjon (noms vanilla EoS, résolus au
# runtime ; utilisés aussi par les grounds fixes D18-D22 importés)
TSET = {26: "chasm_cave", 27: "chasm_cave", 28: "dark_hill", 29: "dark_hill",
        30: "sealed_ruin", 31: "sealed_ruin_pit", 33: "dusk_forest",
        34: "dusk_forest", 176: "sealed_ruin_pit", 187: "sealed_ruin_pit"}

# musique NDS (music_id mappa_s) -> .ogg PMDO (fichiers vérifiés présents)
MUSIC = {19: "Chasm Cave.ogg", 20: "Dark Hill.ogg", 21: "Sealed Ruin.ogg",
         22: "Sealed Ruin Pit.ogg", 23: "Dusk Forest.ogg"}

# ---------------------------------------------------------------------------
# Helpers de construction (types NATIFS vérifiés dans le mod 0.8.12)
# ---------------------------------------------------------------------------
def tile(id_):
    return {"$type": "RogueEssence.Dungeon.Tile, RogueEssence",
            "Data": {"ID": id_, "TileTex": {"AutoTileset": "", "Associates": [],
                     "Layers": [], "NeighborCode": -1}, "StableTex": False},
            "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False,
                       "Owner": 0, "TileStates": []}}

def gs(key, value):
    return {"Key": {"str": key if isinstance(key, list) else [key]}, "Value": value}


def build_floor(fl, tset_name, music_ogg, floor_index):
    """Construit un GridFloorGen natif pour un floor procédural."""
    steps = []
    # [-6] MapDataStep : musique + vue (darkness)
    mapdata = {"$type": "PMDC.LevelGen.MapDataStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC",
               "Music": music_ogg, "TimeLimit": 1200,
               "TileSight": 0 if fl["darkness"] > 0 else 1,
               "CharSight": 1, "ClampCamera": False}
    steps.append(gs(-6, mapdata))
    # [-5] InitGridPlanStep
    steps.append(gs(-5, {"$type": "RogueElements.InitGridPlanStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                         "CellWidth": 10, "CellHeight": 10, "CellX": 4, "CellY": 4, "CellWall": 2, "Wrap": False}))
    # [-4] GridPathBranch + ConnectGridBranchStep
    steps.append(gs(-4, {"$type": "RogueElements.GridPathBranch`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                         "RoomRatio": {"Min": 45, "Max": 70}, "BranchRatio": {"Min": 70, "Max": 100},
                         "NoForcedBranches": False,
                         "GenericRooms": {"$type": "RogueElements.SpawnList`1[[RogueElements.RoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements",
                                          "$values": [{"Spawn": {"$type": "RogueElements.RoomGenSquare`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                                                                 "RoomTerrain": tile("floor"), "Size": {"Min": 5, "Max": 8}, "Resizable": False}, "Rate": 10}]},
                         "RoomComponents": [{"$type": "PMDC.LevelGen.ConnectivityRoom, PMDC", "Connection": 32},
                                            {"$type": "PMDC.LevelGen.NoConnectRoom, PMDC"}],
                         "GenericHalls": {"$type": "RogueElements.SpawnList`1[[RogueElements.PermissiveRoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements",
                                          "$values": [{"Spawn": {"$type": "RogueElements.RoomGenAngledHall`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                                                                 "HallTurnBias": 0, "Brush": {"$type": "RogueElements.TerrainHallBrush, RogueElements",
                                                                 "Terrain": tile("hall"), "Dims": {"X": 1, "Y": 1}},
                                                                 "Width": {"Min": 2, "Max": 4}, "Height": {"Min": 2, "Max": 4}}, "Rate": 10}]}}))
    steps.append(gs(-4, {"$type": "RogueElements.ConnectGridBranchStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                         "ConnectPercent": 40, "Filters": []}))
    steps.append(gs(-3, {"$type": "RogueElements.DrawGridToFloorStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements"}))
    steps.append(gs(-1, {"$type": "RogueElements.DrawFloorToTileStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                         "Padding": 1}))
    # [0,1] UnbreakableBorderStep
    steps.append(gs([0, 1], {"$type": "RogueEssence.LevelGen.UnbreakableBorderStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                             "Thickness": 1}))
    # [1,2] MobSpawnSettingsStep (respawn)
    steps.append(gs([1, 2], {"$type": "PMDC.LevelGen.MobSpawnSettingsStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC",
                             "Priority": {"str": [15]},
                             "Respawn": {"$type": "PMDC.Dungeon.RespawnFromEligibleEvent, PMDC",
                                         "MaxFoes": max(1, fl["enemy_density"]), "RespawnTime": 60},
                             "MaxFoes": 0, "RespawnTime": 0}))
    # [2] FloorStairsStep
    steps.append(gs(2, {"$type": "RogueElements.FloorStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements",
                        "MinDistance": 3, "Entrances": [{"Loc": {"X": 0, "Y": 0}, "Dir": 0}],
                        "Exits": [{"Loc": {"X": 0, "Y": 0}, "Tile": {"TileLoc": {"X": 0, "Y": 0}, "ID": "stairs_go_down", "Revealed": True, "Owner": 0, "TileStates": []}}],
                        "Filters": []}))
    # [3] PerlinWaterStep (si water_density > 0)
    if fl.get("water_density", 0) > 0:
        steps.append(gs(3, {"$type": "RogueElements.PerlinWaterStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                            "OrderComplexity": 3, "OrderSoftness": 1, "WaterPercent": {"Min": fl["water_density"], "Max": fl["water_density"]},
                            "Bowl": True, "Terrain": tile("water"),
                            "TerrainStencil": {"$type": "RogueElements.MapTerrainStencil`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",
                                               "Room": False, "Wall": True, "Blocked": False, "Not": False}}))
    # [4] MapTextureStep (tileset NDS -> auto-tileset)
    steps.append(gs(4, {"$type": "RogueEssence.LevelGen.MapTextureStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                        "GroundTileset": tset_name + "_floor",
                        "BlockTileset": tset_name + "_wall",
                        "WaterTileset": tset_name + "_secondary",
                        "LayeredGround": False, "IndependentGround": False, "GroundElement": "normal"}))
    # [5] SpacedRoomSpawnStep + RandomRoomSpawnStep (objets dans les salles)
    steps.append(gs(5, {"$type": "PMDC.LevelGen.SpacedRoomSpawnStep`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], PMDC",
                        "IncludeHalls": False, "Filters": [],
                        "Spawn": {"$type": "RogueElements.PickerSpawner`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
                                  "Spawns": {"$type": "RogueElements.SpawnList`1[[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
                                             "$values": [{"Spawn": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10}]}}}))
    steps.append(gs(5, {"$type": "RogueElements.RandomRoomSpawnStep`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
                        "SuccessPercent": 100, "IncludeHalls": False, "Filters": [],
                        "Spawn": {"$type": "RogueElements.ContextSpawner`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements"}}))
    # [6] TerminalSpawnStep (argent)
    steps.append(gs(6, {"$type": "RogueElements.TerminalSpawnStep`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.LevelGen.MoneySpawn, RogueEssence]], RogueElements",
                        "IncludeHalls": False, "Filters": [],
                        "Spawn": {"$type": "RogueEssence.LevelGen.MoneyDivSpawner`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                                  "Amount": {"Min": 1, "Max": 3}}}))
    # [6,1] DueSpawnStep (items au sol)
    steps.append(gs([6, 1], {"$type": "RogueElements.DueSpawnStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.InvItem, RogueEssence],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence]], RogueElements",
                             "SuccessPercent": fl["item_density"] * 20, "IncludeHalls": False, "Filters": [],
                             "Spawn": {"$type": "RogueElements.ContextSpawner`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueElements"},
                             "MaxToSpawn": {"Min": 1, "Max": 3}}))
    # [6,2] PlaceRandomMobsStep — TeamContextSpawner (type natif, FIX du crash)
    steps.append(gs([6, 2], {"$type": "RogueEssence.LevelGen.PlaceRandomMobsStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                             "Filters": [{"$type": "PMDC.LevelGen.RoomFilterConnectivity, PMDC", "Connection": 1}],
                             "IncludeHalls": False,
                             "Spawn": {"$type": "RogueEssence.LevelGen.TeamContextSpawner`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                                       "Amount": {"Min": 2, "Max": max(3, fl["enemy_density"] + 1)}},
                             "Ally": False, "ClumpFactor": 20}))
    # [7] DetectIsolatedStairsStep
    steps.append(gs(7, {"$type": "RogueElements.DetectIsolatedStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"}))
    # MobSpawnStep : TABLE ENNEMIS NDS du floor (PoolTeamSpawner)
    # (le champ 'md' de mappa_s.bin EST le MONSTER_ID — identité directe)
    mob_spawns = []
    for m in fl["monsters"]:
        sp = MID_SPECIES.get(m["md"])
        if not sp:
            continue
        rate = max(1, round(m["weight"] / 100.0))
        mob_spawns.append({
            "Spawn": {"$type": "RogueEssence.LevelGen.PoolTeamSpawner, RogueEssence",
                      "Explorer": False,
                      "Spawns": [{"Spawn": {"Spawn": {"BaseForm": {"Species": sp, "Form": 0, "Skin": "", "Gender": -1},
                                                      "Level": {"Min": m["level"], "Max": m["level"]},
                                                      "SpecifiedSkills": [], "Intrinsic": "",
                                                      "Tactic": "wander_normal",
                                                      "SpawnConditions": [], "SpawnFeatures": []},
                                             "Role": 0}, "Rate": 10}],
                      "TeamSizes": [{"Spawn": 1, "Rate": 12}]},
            "Rate": rate})
    if mob_spawns:
        steps.append(gs([1, 2], {"$type": "RogueEssence.LevelGen.MobSpawnStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                                 "Spawns": mob_spawns}))
    return {"$type": "RogueEssence.LevelGen.GridFloorGen, RogueEssence", "GenSteps": steps}


def build_zone(zone_id, display_name, n_floors, mappa_floors, trap_list=None,
               monster_house_pct=0, is_fixed_spiritomb=False):
    """Construit le JSON d'une Zone PMDO (LayeredSegment, floors procéduraux)."""
    seg_floors = []
    for i in range(n_floors):
        fl = mappa_floors[i]
        tset_name = TSET.get(fl["tileset"], "chasm_cave")
        music_ogg = MUSIC.get(fl["music"], "Chasm Cave.ogg")
        seg_floors.append(build_floor(fl, tset_name, music_ogg, i + 1))

    # ZoneSteps
    zone_steps = []
    zone_steps.append({"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC",
                       "Priority": {"str": [2, 1]}})
    zone_steps.append({"$type": "PMDC.LevelGen.FloorNameDropZoneStep, PMDC",
                       "DropPriority": {"str": [-15]},
                       "Name": {"DefaultText": display_name + "\\nB{0}F",
                                "LocalTexts": {"fr": display_name + "\\n{0}SS"}},
                       "Priority": {"str": [-6]}})
    zone_steps.append({"$type": "RogueEssence.LevelGen.MoneySpawnZoneStep, RogueEssence",
                       "Priority": {"str": [2]},
                       "StartAmount": {"Min": 1, "Max": 1}, "AddAmount": {"Min": 1, "Max": 1},
                       "ModStates": [{"assembly": "PMDC, Version=0.8.11.0, Culture=neutral, PublicKeyToken=null",
                                      "type": "PMDC.Dungeon.CoinModGenState"}]})
    zone_steps.append({"$type": "RogueEssence.LevelGen.ItemSpawnZoneStep, RogueEssence",
                       "Priority": {"str": [2, 1]}, "Spawns": {}})
    # Pièges NDS (TileSpawnZoneStep)
    if trap_list:
        trap_spawns = []
        for tid, tw in trap_list.items():
            pmdo = TRAP_MAP.get(int(tid))
            if not pmdo:
                continue
            rate = max(1, round(tw / 100.0))
            trap_spawns.append({"Spawn": {"TileLoc": {"X": 0, "Y": 0}, "ID": pmdo,
                                          "Revealed": True, "Owner": 0, "TileStates": []},
                                "Rate": rate, "Range": {"Min": 0, "Max": max(0, n_floors - 1)}})
        if trap_spawns:
            zone_steps.append({"$type": "RogueEssence.LevelGen.TileSpawnZoneStep, RogueEssence",
                               "Priority": {"str": [2, 3]}, "Spawns": trap_spawns})
    # Monster house NDS (SpreadHouseZoneStep, Chance = %)
    if monster_house_pct > 0:
        zone_steps.append({"$type": "PMDC.LevelGen.SpreadHouseZoneStep, PMDC",
                           "Priority": {"str": [4, 1]}, "Items": [], "ItemThemes": [],
                           "Mobs": [], "MobThemes": [],
                           "HouseStepSpawns": [{"Spawn": {"$type": "PMDC.LevelGen.MonsterHouseStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], PMDC",
                                                          "Filters": [{"$type": "RogueElements.RoomFilterComponent, RogueElements",
                                                                       "Negate": True,
                                                                       "Components": [{"$type": "RogueEssence.LevelGen.ImmutableRoom, RogueEssence"},
                                                                                      {"$type": "PMDC.LevelGen.NoEventRoom, PMDC"}]}],
                                                          "Items": [], "ItemThemes": [], "Mobs": [], "MobThemes": []},
                                                "Rate": 10}],
                           "SpreadPlan": {"$type": "RogueEssence.LevelGen.SpreadPlanChance, RogueEssence",
                                          "Chance": monster_house_pct,
                                          "FloorRange": {"Min": 0, "Max": max(0, n_floors - 1)}},
                           "ModStates": []})

    segment = {"$type": "RogueEssence.LevelGen.LayeredSegment, RogueEssence",
               "ZoneSteps": zone_steps,
               "Floors": seg_floors,
               "IsRelevant": True, "Comment": ""}

    zone = {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Data.ZoneData, RogueEssence",
            "Name": {"DefaultText": display_name, "LocalTexts": {"fr": display_name}},
            "Released": True, "Comment": "NDS Future Arc dungeon (data-driven mappa_s.bin)",
            "NoEXP": False, "ExpPercent": 100, "Level": 28, "LevelCap": True,
            "KeepSkills": False, "TeamRestrict": False, "TeamSize": -1,
            "MoneyRestrict": False, "BagRestrict": -1, "KeepTreasure": True,
            "BagSize": -1, "Persistent": False, "Rescues": 0, "Rogue": 0,
            "Segments": [segment], "GroundMaps": [],
        },
    }
    return zone


# ---------------------------------------------------------------------------
# Données de pièges par donjon (cumul des traps des floors)
# ---------------------------------------------------------------------------
def trap_list_for(mappa_floors):
    traps = {}
    for fl in mappa_floors:
        for tid, tw in fl.get("traps", {}).items():
            traps[int(tid)] = max(traps.get(int(tid), 0), tw)
    return traps


def main():
    DUNGEONS = [
        # (zone_id, display, n_floors, monster_house_pct)
        ("chasm_cave", "Chasm Cave", 8, 0),
        ("dark_hill", "Dark Hill", 15, 0),
        ("sealed_ruin", "Sealed Ruin", 8, 5),
        ("sealed_ruin_pit", "Sealed Ruin Pit", 6, 5),
        ("spiritomb_room", "Spiritomb Room", 1, 0),
        ("dusk_forest", "Dusk Forest", 8, 0),
    ]
    total_floors = 0
    DUNGEON_ID = {"chasm_cave": 27, "dark_hill": 28, "sealed_ruin": 29,
                  "sealed_ruin_pit": 30, "spiritomb_room": 31, "dusk_forest": 32}
    for zid, name, nf, mh in DUNGEONS:
        fls = MAPPA.get(DUNGEON_ID[zid])
        if zid == "spiritomb_room":
            # Salle FIXE : floor unique avec Spiritomb (md 484, L51, weight 10000)
            fls = [{"floor": 1, "structure": 0, "room_density": 8, "tileset": 176,
                    "music": 22, "weather": 0, "floor_connectivity": 40,
                    "enemy_density": 1, "kecleon_shop": 0, "monster_house": 0,
                    "sticky_item": 0, "dead_ends": True, "secondary_terrain": 0,
                    "item_density": 4, "trap_density": 6, "floor_number": 8,
                    "fixed_floor": 7, "extra_hallway": 0, "buried_item": 0,
                    "water_density": 0, "darkness": 0, "max_coin": 0,
                    "monsters": [{"md": 484, "level": 51, "weight": 10000}],
                    "traps": {}, "item_cats": {}, "n_items": 0}]
        trap_list = trap_list_for(fls)
        zone = build_zone(zid, name, nf, fls, trap_list, monster_house_pct=mh)
        with open(os.path.join(OUT, zid + ".json"), "w", encoding="utf-8") as f:
            json.dump(zone, f, ensure_ascii=False, indent=1)
        total_floors += nf
        n_mobs = sum(len(fl["monsters"]) for fl in fls)
        print(f"{zid}: {nf} floors, {n_mobs} entrées Pokémon, MH={mh}%")

    # index.idx
    idx_path = "/tmp/v4work/Data/Zone/index.idx"
    idx = json.load(open(idx_path, encoding="utf-8"))
    for zid, name, nf, mh in DUNGEONS:
        idx["Object"][zid] = {
            "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
            "ExpPercent": 100, "Level": 28, "LevelCap": True,
            "KeepSkills": False, "TeamRestrict": False, "TeamSize": -1,
            "MoneyRestrict": False, "BagRestrict": -1, "KeepTreasure": True,
            "BagSize": -1, "Rescues": 0, "CountedFloors": nf, "Rogue": 0,
            "Grounds": [], "Maps": [list(range(nf))],
            "Name": {"DefaultText": name, "LocalTexts": {"fr": name}},
            "Released": True, "SortOrder": 0,
        }
    json.dump(idx, open(idx_path, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("index.idx mis à jour :", len(idx["Object"]), "zones")
    print(f"TOTAL FLOORS : {total_floors} / 46")


if __name__ == "__main__":
    main()
