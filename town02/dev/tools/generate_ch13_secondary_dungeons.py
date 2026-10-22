#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_ch13_secondary_dungeons.py — Générateur des 4 donjons secondaires
du Chapitre 13 (Arc de la Brume du Nord) pour New Era : Abyss to Ascension.
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

CH13_DUNGEONS = [
    {
        "id": "shivering_cavern", "name": "Caverne Grelottante", "name_en": "Shivering Cavern",
        "rank": 58, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "glacial_rift_floor", "wall_ts1": "glacial_rift_wall",
        "floor_ts2": "ice_crystal_cave_floor", "wall_ts2": "ice_crystal_cave_wall",
        "spawns_seg1": [("snorunt", 42, 48), ("swinub", 42, 48), ("spheal", 43, 49), ("bergmite", 43, 49), ("cubchoo", 44, 50), ("smoochum", 44, 50), ("seel", 42, 48), ("shellder", 43, 49), ("sneasel", 44, 50), ("cryogonal", 43, 49), ("delibird", 42, 48), ("lapras", 44, 50)],
        "spawns_seg2": [("glalie", 50, 58), ("froslass", 50, 58), ("piloswine", 51, 58), ("sealeo", 51, 58), ("avalugg", 52, 58), ("beartic", 52, 58), ("jynx", 50, 58), ("dewgong", 51, 58), ("cloyster", 52, 58), ("weavile", 51, 58), ("walrein", 52, 58), ("mamoswine", 52, 58), ("glaceon", 51, 58)],
        "minibosses": [(7, "Momartik le Souffle", "froslass", 50), (14, "Blizzarroi le Givre", "abomasnow", 54), (22, "Blizzarroi le Gel Éternel", "abomasnow", 58)],
        "weather": {}
    },
    {
        "id": "tempest_ridge", "name": "Crête de la Tempête", "name_en": "Tempest Ridge",
        "rank": 59, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Amp Plains.ogg", "music_seg2": "Far Amp Plains.ogg",
        "floor_ts1": "amp_plains_floor", "wall_ts1": "amp_plains_wall",
        "floor_ts2": "far_amp_plains_floor", "wall_ts2": "far_amp_plains_wall",
        "spawns_seg1": [("mareep", 42, 48), ("electrike", 42, 48), ("shinx", 43, 49), ("pachirisu", 43, 49), ("emolga", 44, 50), ("magnemite", 42, 48), ("voltorb", 43, 49), ("joltik", 44, 50), ("blitzle", 42, 48), ("helioptile", 43, 49), ("dedenne", 44, 50), ("plusle", 42, 48)],
        "spawns_seg2": [("flaaffy", 50, 58), ("ampharos", 52, 58), ("manectric", 50, 58), ("luxio", 50, 58), ("luxray", 52, 58), ("magneton", 50, 58), ("magnezone", 52, 58), ("electrode", 50, 58), ("galvantula", 51, 58), ("zebstrika", 50, 58), ("heliolisk", 51, 58), ("raichu", 52, 58)],
        "minibosses": [(8, "Élekable l'Éclair", "electivire", 50), (16, "Magnézone le Flux", "magnezone", 54), (24, "Fulguris le Tonnerre", "electivire", 58)],
        "weather": {}
    },
    {
        "id": "hollow_thicket", "name": "Fourré Creux", "name_en": "Hollow Thicket",
        "rank": 60, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Apple Woods.ogg", "music_seg2": "Mystifying Forest.ogg",
        "floor_ts1": "apple_woods_floor", "wall_ts1": "apple_woods_wall",
        "floor_ts2": "orchard_path_floor", "wall_ts2": "orchard_path_wall",
        "spawns_seg1": [("phantump", 42, 48), ("pumpkaboo", 42, 48), ("morelull", 43, 49), ("paras", 43, 49), ("shroomish", 44, 50), ("oddish", 42, 48), ("bellsprout", 43, 49), ("seedot", 44, 50), ("ferroseed", 42, 48), ("nincada", 43, 49), ("burmy", 44, 50), ("cherubi", 42, 48)],
        "spawns_seg2": [("trevenant", 50, 58), ("gourgeist", 50, 58), ("shiinotic", 51, 58), ("parasect", 50, 58), ("breloom", 52, 58), ("gloom", 50, 58), ("vileplume", 52, 58), ("weepinbell", 50, 58), ("nuzleaf", 51, 58), ("shiftry", 52, 58), ("ferrothorn", 52, 58), ("ninjask", 51, 58)],
        "minibosses": [(7, "Desséliande l'Écorce", "trevenant", 50), (15, "Banshitrouye l'Ombre", "gourgeist", 54), (23, "Zarude le Rôdeur", "trevenant", 58)],
        "weather": {4: "fog", 14: "fog"}
    },
    {
        "id": "silent_marsh", "name": "Marais Silencieux", "name_en": "Silent Marsh",
        "rank": 61, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Mystifying Forest.ogg", "music_seg2": "Concealed Ruins.ogg",
        "floor_ts1": "dark_marsh_floor", "wall_ts1": "dark_marsh_wall",
        "floor_ts2": "peat_woods_floor", "wall_ts2": "peat_woods_wall",
        "spawns_seg1": [("goomy", 42, 48), ("croagunk", 42, 48), ("poliwag", 43, 49), ("wooper", 43, 49), ("barboach", 44, 50), ("shellos", 44, 50), ("tympole", 42, 48), ("skorupi", 43, 49), ("ekans", 44, 50), ("gulpin", 42, 48), ("grimer", 43, 49), ("yanma", 44, 50), ("tangela", 43, 49)],
        "spawns_seg2": [("sliggoo", 50, 58), ("goodra", 52, 58), ("toxicroak", 50, 58), ("poliwhirl", 50, 58), ("politoed", 52, 58), ("quagsire", 51, 58), ("whiscash", 51, 58), ("gastrodon", 52, 58), ("palpitoad", 50, 58), ("seismitoad", 52, 58), ("drapion", 51, 58), ("arbok", 50, 58), ("swalot", 51, 58)],
        "minibosses": [(8, "Muplodocus la Brume", "goodra", 50), (16, "Tarpaud le Silence", "politoed", 54), (25, "Muplodocus de Hisui l'Acier", "goodra", 58)],
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

def generate_ch13_dungeons():
    with open(TEMPLATE_ZONE, "r", encoding="utf-8-sig") as f:
        tpl_data = json.load(f)

    for cfg in CH13_DUNGEONS:
        data = copy.deepcopy(tpl_data)
        obj = data["Object"]
        obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
        obj["Comment"] = f"New Era ch13 — Ch13 secondary: {cfg['name']}"
        obj["Level"] = 42
        
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
        print(f"  [OK] Zone : {cfg['id']} ({cfg['floors']} étages, scaling Lv 42-58)")
        
        # Générer les 3 arènes d'étage
        make_miniboss_rsmap(f"{cfg['id']}_mb1", cfg["minibosses"][0][1], cfg["minibosses"][0][2], cfg["minibosses"][0][3], cfg["music_seg1"])
        make_miniboss_rsmap(f"{cfg['id']}_mb2", cfg["minibosses"][1][1], cfg["minibosses"][1][2], cfg["minibosses"][1][3], cfg["music_seg2"])
        make_miniboss_rsmap(f"{cfg['id']}_boss", cfg["minibosses"][2][1], cfg["minibosses"][2][2], cfg["minibosses"][2][3], cfg["music_seg2"])

if __name__ == "__main__":
    print("=== GÉNÉRATION DES DONJONS SECONDAIRES CH13 ===")
    generate_ch13_dungeons()
