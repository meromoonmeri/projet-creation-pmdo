#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_ch12_secondary_dungeons.py — Générateur des 4 donjons secondaires
du Chapitre 12 (Suite Arc Fugitif) pour New Era : Abyss to Ascension.
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

CH12_DUNGEONS = [
    {
        "id": "ashen_hollow", "name": "Creux Cendré", "name_en": "Ashen Hollow",
        "rank": 54, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Dark Crater.ogg", "music_seg2": "Giant Volcano.ogg",
        "floor_ts1": "cinder_cave_floor", "wall_ts1": "cinder_cave_wall",
        "floor_ts2": "scorched_earth_floor", "wall_ts2": "scorched_earth_wall",
        "spawns_seg1": [("numel", 40, 45), ("slugma", 40, 45), ("torkoal", 41, 46), ("grimer", 41, 46), ("koffing", 42, 47), ("magby", 42, 47), ("growlithe", 40, 45), ("ponyta", 41, 46), ("cubone", 42, 47), ("sandshrew", 41, 46), ("stunfisk", 40, 45), ("trapinch", 42, 47), ("diglett", 41, 46)],
        "spawns_seg2": [("camerupt", 48, 54), ("magcargo", 48, 54), ("muk", 49, 55), ("weezing", 49, 55), ("magmar", 50, 56), ("arcanine", 50, 56), ("rapidash", 48, 54), ("marowak", 49, 55), ("sandslash", 50, 56), ("vibrava", 49, 55), ("dugtrio", 48, 54), ("golem", 50, 56), ("steelix", 49, 55)],
        "minibosses": [(7, "Limonde le Piège", "stunfisk", 47), (14, "Grotadmorv le Boue", "muk", 51), (22, "Grotadmorv d'Alola le Toxique", "muk", 56)],
        "weather": {5: "sandstorm", 11: "sandstorm", 18: "sandstorm"}
    },
    {
        "id": "frozen_rift", "name": "Faille Gelée", "name_en": "Frozen Rift",
        "rank": 55, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "glacial_rift_floor", "wall_ts1": "glacial_rift_wall",
        "floor_ts2": "ice_crystal_cave_floor", "wall_ts2": "ice_crystal_cave_wall",
        "spawns_seg1": [("snorunt", 40, 45), ("swinub", 40, 45), ("spheal", 41, 46), ("bergmite", 41, 46), ("cubchoo", 42, 47), ("smoochum", 42, 47), ("seel", 40, 45), ("shellder", 41, 46), ("sneasel", 42, 47), ("cryogonal", 41, 46), ("delibird", 40, 45), ("lapras", 42, 47)],
        "spawns_seg2": [("glalie", 48, 54), ("froslass", 48, 54), ("piloswine", 49, 55), ("sealeo", 49, 55), ("avalugg", 50, 56), ("beartic", 50, 56), ("jynx", 48, 54), ("dewgong", 49, 55), ("cloyster", 50, 56), ("weavile", 49, 55), ("walrein", 50, 56), ("mamoswine", 50, 56), ("glaceon", 49, 55)],
        "minibosses": [(8, "Grelaçon le Gel", "bergmite", 47), (16, "Hexagel le Cristal", "cryogonal", 51), (24, "Séracrawl le Roc Glacé", "avalugg", 56)],
        "weather": {}
    },
    {
        "id": "whispering_crag", "name": "Crête Chuchotante", "name_en": "Whispering Crag",
        "rank": 56, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Mt. Horn.ogg", "music_seg2": "Craggy Coast.ogg",
        "floor_ts1": "rocky_crag_floor", "wall_ts1": "rocky_crag_wall",
        "floor_ts2": "windy_summit_floor", "wall_ts2": "windy_summit_wall",
        "spawns_seg1": [("pidgey", 40, 45), ("spearow", 40, 45), ("zubat", 41, 46), ("rufflet", 41, 46), ("vullaby", 42, 47), ("rookidee", 42, 47), ("doduo", 40, 45), ("skarmory", 41, 46), ("taillow", 42, 47), ("wingull", 41, 46), ("hoothoot", 40, 45), ("natu", 42, 47)],
        "spawns_seg2": [("pidgeotto", 48, 54), ("fearow", 48, 54), ("golbat", 49, 55), ("braviary", 49, 55), ("mandibuzz", 50, 56), ("corvisquire", 50, 56), ("corviknight", 50, 56), ("dodrio", 48, 54), ("swellow", 49, 55), ("pelipper", 50, 56), ("noctowl", 49, 55), ("xatu", 50, 56)],
        "minibosses": [(7, "Aéromite l'Écho", "venomoth", 47), (15, "Guériaigle le Vent", "braviary", 51), (23, "Corvaillus l'Acier", "corviknight", 56)],
        "weather": {4: "fog", 14: "fog"}
    },
    {
        "id": "twilight_marsh", "name": "Marais Crépusculaire", "name_en": "Twilight Marsh",
        "rank": 57, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Mystifying Forest.ogg", "music_seg2": "Concealed Ruins.ogg",
        "floor_ts1": "dark_marsh_floor", "wall_ts1": "dark_marsh_wall",
        "floor_ts2": "peat_woods_floor", "wall_ts2": "peat_woods_wall",
        "spawns_seg1": [("tympole", 40, 45), ("palpitoad", 40, 45), ("mudbray", 41, 46), ("wooper", 41, 46), ("barboach", 42, 47), ("shellos", 42, 47), ("croagunk", 40, 45), ("skorupi", 41, 46), ("ekans", 42, 47), ("gulpin", 41, 46), ("grimer", 40, 45), ("yanma", 42, 47), ("tangela", 41, 46)],
        "spawns_seg2": [("seismitoad", 48, 54), ("mudsdale", 48, 54), ("quagsire", 49, 55), ("whiscash", 49, 55), ("gastrodon", 50, 56), ("toxicroak", 50, 56), ("drapion", 48, 54), ("arbok", 49, 55), ("swalot", 50, 56), ("muk", 49, 55), ("yanmega", 50, 56), ("tangrowth", 50, 56), ("politoed", 49, 55)],
        "minibosses": [(8, "Crapustule la Tourbe", "seismitoad", 47), (16, "Bourrinos le Boue", "mudbray", 51), (25, "Bourrinos la Tourbe", "mudsdale", 56)],
        "weather": {5: "rain", 12: "rain", 19: "rain"}
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
            "Level": {"Min": 40, "Max": 40},
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

def generate_ch12_dungeons():
    with open(TEMPLATE_ZONE, "r", encoding="utf-8-sig") as f:
        tpl_data = json.load(f)

    for cfg in CH12_DUNGEONS:
        data = copy.deepcopy(tpl_data)
        obj = data["Object"]
        obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
        obj["Comment"] = f"New Era ch12 — Ch12 secondary: {cfg['name']}"
        obj["Level"] = 40
        
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
        print(f"  [OK] Zone : {cfg['id']} ({cfg['floors']} étages, scaling Lv 40-56)")
        
        # Générer les 3 arènes d'étage
        make_miniboss_rsmap(f"{cfg['id']}_mb1", cfg["minibosses"][0][1], cfg["minibosses"][0][2], cfg["minibosses"][0][3], cfg["music_seg1"])
        make_miniboss_rsmap(f"{cfg['id']}_mb2", cfg["minibosses"][1][1], cfg["minibosses"][1][2], cfg["minibosses"][1][3], cfg["music_seg2"])
        make_miniboss_rsmap(f"{cfg['id']}_boss", cfg["minibosses"][2][1], cfg["minibosses"][2][2], cfg["minibosses"][2][3], cfg["music_seg2"])

if __name__ == "__main__":
    print("=== GÉNÉRATION DES DONJONS SECONDAIRES CH12 ===")
    generate_ch12_dungeons()
