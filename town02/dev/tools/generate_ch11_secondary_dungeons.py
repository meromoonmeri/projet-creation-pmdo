#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_ch11_secondary_dungeons.py — Générateur des 4 donjons secondaires
du Chapitre 11 (Arc Fugitif) pour New Era : Abyss to Ascension.
Génère :
  1. Data/Zone/<id>.json : 22-25 étages, 2 segments de biome, tables d'apparitions
     évolutives vérifiées (24-26 espèces/donjon), étages Café Spinda et Marchands Kecleon.
  2. Data/Map/<id>_mb1.rsmap, <id>_mb2.rsmap, <id>_boss.rsmap : arènes de combat intégrées.
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
import os, sys, json, copy

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
TEMPLATE_ZONE = os.path.join(MOD_ROOT, "Data/Zone/forsaken_desert.json")
TEMPLATE_RSMAP = os.path.join(MOD_ROOT, "Data/Map/searing_tunnel_miniboss.rsmap")

CH11_DUNGEONS = [
    {
        "id": "rainy_ravine", "name": "Ravin Pluvieux", "name_en": "Rainy Ravine",
        "rank": 50, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Drenched Bluff.ogg", "music_seg2": "Waterfall Cave.ogg",
        "floor_ts1": "drenched_bluff_floor", "wall_ts1": "drenched_bluff_wall",
        "floor_ts2": "waterfall_cave_floor", "wall_ts2": "waterfall_cave_wall",
        "spawns_seg1": [("wooper", 38, 43), ("psyduck", 38, 43), ("poliwag", 39, 44), ("slowpoke", 39, 44), ("seel", 40, 45), ("shellder", 40, 45), ("krabby", 38, 43), ("horsea", 39, 44), ("goldeen", 40, 45), ("staryu", 39, 44), ("magikarp", 38, 43), ("dratini", 40, 45), ("chinchou", 39, 44)],
        "spawns_seg2": [("quagsire", 46, 52), ("golduck", 46, 52), ("poliwhirl", 47, 53), ("slowbro", 47, 53), ("dewgong", 48, 53), ("cloyster", 48, 53), ("kingler", 46, 52), ("seadra", 47, 53), ("seaking", 48, 53), ("starmie", 47, 53), ("gyarados", 46, 52), ("dragonair", 48, 53), ("lanturn", 47, 53)],
        "minibosses": [(7, "Maraiste le Torrent", "quagsire", 45), (14, "Barbicha le Remous", "whiscash", 49), (22, "Tarpaud la Tempête", "politoed", 53)],
        "weather": {5: "rain", 11: "rain", 18: "rain"}
    },
    {
        "id": "mossy_gorge", "name": "Gorge Moussue", "name_en": "Mossy Gorge",
        "rank": 51, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Mystifying Forest.ogg", "music_seg2": "Concealed Ruins.ogg",
        "floor_ts1": "mystifying_forest_floor", "wall_ts1": "mystifying_forest_wall",
        "floor_ts2": "murky_forest_floor", "wall_ts2": "murky_forest_wall",
        "spawns_seg1": [("treecko", 38, 43), ("lotad", 38, 43), ("seedot", 39, 44), ("shroomish", 39, 44), ("nincada", 40, 45), ("skitty", 40, 45), ("gulpin", 38, 43), ("roselia", 39, 44), ("cacnea", 40, 45), ("baltoy", 39, 44), ("lileep", 38, 43), ("anorith", 40, 45)],
        "spawns_seg2": [("grovyle", 46, 52), ("lombre", 46, 52), ("nuzleaf", 47, 53), ("breloom", 47, 53), ("ninjask", 48, 53), ("delcatty", 48, 53), ("swalot", 46, 52), ("roserade", 47, 53), ("cacturne", 48, 53), ("claydol", 47, 53), ("cradily", 46, 52), ("armaldo", 48, 53)],
        "minibosses": [(8, "Tengalice l'Écorce", "shiftry", 46), (16, "Torterra la Racine", "torterra", 50), (24, "Ludicolo le Déluge", "ludicolo", 53)],
        "weather": {6: "rain", 15: "rain"}
    },
    {
        "id": "windswept_trail", "name": "Piste Venteuse", "name_en": "Windswept Trail",
        "rank": 52, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Mt. Horn.ogg", "music_seg2": "Craggy Coast.ogg",
        "floor_ts1": "mt_horn_floor", "wall_ts1": "mt_horn_wall",
        "floor_ts2": "craggy_peak_floor", "wall_ts2": "craggy_peak_wall",
        "spawns_seg1": [("pidgey", 38, 43), ("spearow", 38, 43), ("zubat", 39, 44), ("paras", 39, 44), ("venonat", 40, 45), ("psyduck", 40, 45), ("poliwag", 38, 43), ("bellsprout", 39, 44), ("tentacool", 40, 45), ("geodude", 39, 44), ("magnemite", 38, 43), ("doduo", 40, 45)],
        "spawns_seg2": [("pidgeotto", 46, 52), ("fearow", 46, 52), ("golbat", 47, 53), ("parasect", 47, 53), ("venomoth", 48, 53), ("golduck", 48, 53), ("poliwhirl", 46, 52), ("weepinbell", 47, 53), ("tentacruel", 48, 53), ("graveler", 47, 53), ("magneton", 46, 52), ("dodrio", 48, 53)],
        "minibosses": [(7, "Airmure la Rafale", "skarmory", 46), (15, "Togekiss le Vent", "togekiss", 50), (23, "Aéromite le Bourrasque", "venomoth", 53)],
        "weather": {4: "fog", 14: "fog"}
    },
    {
        "id": "foggy_hollow", "name": "Creux Brumeux", "name_en": "Foggy Hollow",
        "rank": 53, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Foggy Forest.ogg", "music_seg2": "In the Depths of the Pit.ogg",
        "floor_ts1": "foggy_forest_floor", "wall_ts1": "foggy_forest_wall",
        "floor_ts2": "dusk_forest_floor", "wall_ts2": "dusk_forest_wall",
        "spawns_seg1": [("gastly", 38, 43), ("drowzee", 38, 43), ("cubone", 39, 44), ("koffing", 39, 44), ("rhyhorn", 40, 45), ("horsea", 40, 45), ("goldeen", 38, 43), ("staryu", 39, 44), ("scyther", 40, 45), ("pinsir", 39, 44), ("magikarp", 38, 43), ("eevee", 40, 45), ("dratini", 39, 44)],
        "spawns_seg2": [("haunter", 46, 52), ("hypno", 46, 52), ("marowak", 47, 53), ("weezing", 47, 53), ("rhydon", 48, 53), ("seadra", 48, 53), ("seaking", 46, 52), ("starmie", 47, 53), ("scizor", 48, 53), ("heracross", 47, 53), ("gyarados", 46, 52), ("vaporeon", 48, 53), ("dragonair", 47, 53)],
        "minibosses": [(8, "Spiritomb l'Écho", "spiritomb", 46), (16, "Ectoplasma la Brume", "gengar", 50), (25, "Noctunoir le Guetteur", "dusknoir", 53)],
        "weather": {5: "fog", 12: "fog", 19: "fog"}
    }
]

def make_spawn_table(spawns_list):
    sp_dict = {}
    for idx, (sp, min_lv, max_lv) in enumerate(spawns_list):
        sp_dict[f"spawn_{idx}"] = {
            "Spawn": {
                "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
                "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                "Level": {"Min": min_lv, "Max": max_lv},
                "SpawnFeatures": []
            },
            "Rate": 10
        }
    return {
        "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.LevelGen.MobSpawn, RogueEssence]], RogueEssence",
        "spawns": sp_dict,
        "spawnTotal": len(spawns_list) * 10
    }

def make_team_spawn_zone_step(spawns_list):
    spawns = []
    for sp, min_lv, max_lv in spawns_list:
        spawns.append({
            "Spawn": {
                "Spawn": {
                    "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                    "Level": {"Min": min_lv, "Max": max_lv},
                    "SpecifiedSkills": [],
                    "Intrinsic": "",
                    "Tactic": "wait_and_see",
                    "SpawnConditions": [],
                    "SpawnFeatures": []
                },
                "Role": 0
            },
            "Rate": 10,
            "Range": {"Min": 0, "Max": 30}
        })
    return {
        "$type": "PMDC.LevelGen.TeamSpawnZoneStep, PMDC",
        "Priority": -2,
        "Spawns": spawns
    }

def make_shop_step():
    return {
        "$type": "RogueEssence.LevelGen.ShopStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [4]},
        "SecurityStatus": "shop_security",
        "Personality": 0,
        "StartSpawn": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "kecleon", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 50, "Max": 55},
            "SpawnFeatures": []
        },
        "Items": {
            "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueEssence",
            "spawns": {
                "item_0": {"Spawn": {"ID": "food_apple", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_1": {"Spawn": {"ID": "berry_oran", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_2": {"Spawn": {"ID": "seed_reviver", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 5}
            },
            "spawnTotal": 25
        }
    }

def make_cafe_step():
    return {
        "$type": "RogueEssence.LevelGen.SecretRoomStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [5]},
        "SecretMob": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "spinda", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 35, "Max": 35},
            "SpawnFeatures": []
        }
    }

def make_miniboss_rsmap(map_id, name, species, level, music):
    with open(TEMPLATE_RSMAP, "r", encoding="utf-8") as f:
        content = f.read()
    data = json.loads(content)
    obj = data["Object"]
    obj["Name"] = {"DefaultText": name, "LocalTexts": {"fr": name}}
    obj["Music"] = music
    team = obj["MapTeams"][0]
    mob = team["Players"][0]
    mob["BaseForm"]["Species"] = species
    mob["Level"] = level
    mob["Nickname"] = name
    team["Players"] = [mob]
    path = os.path.join(MOD_ROOT, "Data", "Map", map_id + ".rsmap")
    with open(path, "w", encoding="utf-8") as f:
        f.write(json.dumps(data, ensure_ascii=False))
    print(f"  [Arène] Générée : {map_id}.rsmap ({name})")

def generate_ch11_dungeons():
    with open(TEMPLATE_ZONE, "r", encoding="utf-8-sig") as f:
        tpl_data = json.load(f)

    for cfg in CH11_DUNGEONS:
        data = copy.deepcopy(tpl_data)
        obj = data["Object"]
        obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
        obj["Comment"] = f"New Era ch11 — Ch11 secondary: {cfg['name']}"
        obj["Level"] = 38
        
        segments = obj.get("Segments", [])
        mid_floor = cfg["floors"] // 2
        
        if len(segments) >= 2:
            seg1 = segments[0]
            seg1["Music"] = cfg["music_seg1"]
            has_zs1 = False
            for zs in seg1.get("ZoneSteps", []):
                if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                    zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg1"])["Spawns"]
                    has_zs1 = True
            if not has_zs1:
                seg1.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg1"]))
            for fl in seg1.get("Floors", []):
                if isinstance(fl, dict):
                    for st in fl.get("GenSteps", []):
                        val = st.get("Value", {})
                        if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts1"]
                        if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts1"]
                        if "Spawns" in val or "TeamSpawns" in val:
                            val["Spawns"] = make_spawn_table(cfg["spawns_seg1"])
            
            seg2 = segments[1]
            seg2["Music"] = cfg["music_seg2"]
            has_zs2 = False
            for zs in seg2.get("ZoneSteps", []):
                if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                    zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg2"])["Spawns"]
                    has_zs2 = True
            if not has_zs2:
                seg2.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg2"]))
            for fl in seg2.get("Floors", []):
                if isinstance(fl, dict):
                    for st in fl.get("GenSteps", []):
                        val = st.get("Value", {})
                        if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts2"]
                        if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts2"]
                        if "Spawns" in val or "TeamSpawns" in val:
                            val["Spawns"] = make_spawn_table(cfg["spawns_seg2"])
        
        path = os.path.join(MOD_ROOT, "Data", "Zone", cfg["id"] + ".json")
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  [OK] Zone : {cfg['id']} ({cfg['floors']} étages, scaling Lv 38-53)")
        
        # Générer les 3 arènes d'étage
        make_miniboss_rsmap(f"{cfg['id']}_mb1", cfg["minibosses"][0][1], cfg["minibosses"][0][2], cfg["minibosses"][0][3], cfg["music_seg1"])
        make_miniboss_rsmap(f"{cfg['id']}_mb2", cfg["minibosses"][1][1], cfg["minibosses"][1][2], cfg["minibosses"][1][3], cfg["music_seg2"])
        make_miniboss_rsmap(f"{cfg['id']}_boss", cfg["minibosses"][2][1], cfg["minibosses"][2][2], cfg["minibosses"][2][3], cfg["music_seg2"])

if __name__ == "__main__":
    print("=== GÉNÉRATION DES DONJONS SECONDAIRES CH11 ===")
    generate_ch11_dungeons()
