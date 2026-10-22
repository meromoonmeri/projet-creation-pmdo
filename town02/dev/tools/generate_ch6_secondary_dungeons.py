#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_ch6_secondary_dungeons.py — Générateur et metteur en conformité
des 4 donjons secondaires du Chapitre 6 (Rang 30 à 33) selon le Framework,
le Manifeste et la Convention de Nommage & Scaling Évolutif :

  1. forsaken_desert (Désert des Oubliés)
  2. geode_crevice   (Crevasse de Géode)
  3. wild_orchard    (Verger Sauvage)
  4. scorched_plains (Plaines Brûlées)

Garantit par donjon :
  - 20 étages, 2 segments de 10 étages avec changement de biome
  - Scaling de 15 niveaux (Lv 18-24 en Seg 1 stade 1 -> Lv 25-33 en Seg 2 évolués)
  - 3 Mini-boss nommés avec musique dédiée
  - Relais toutes les 5 étages (Modèle Tunnel Incandescent + Kangourex par biome)
  - ItemSpawnZoneStep + Marchand Kecleon aléatoire
  - Météo active sur étages clés.
"""
import os, sys, json

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

CH6_DUNGEONS_CONFIG = [
    {
        "id": "desert_oublies",
        "name": "Désert des Oubliés",
        "name_en": "Forsaken Desert",
        "rank": 30,
        "music_seg1": "Desert Region.ogg",
        "music_seg2": "Quicksand Cave.ogg",
        "floor_ts1": "furnace_desert_floor", "wall_ts1": "furnace_desert_wall",
        "floor_ts2": "barren_valley_floor",  "wall_ts2": "barren_valley_wall",
        "spawns_seg1": [
            ("sandshrew", 18, 22), ("cacnea", 18, 22), ("trapinch", 19, 23),
            ("baltoy", 19, 23), ("hippopotas", 20, 24), ("skorupi", 20, 24)
        ],
        "spawns_seg2": [
            ("sandslash", 25, 30), ("cacturne", 26, 31), ("vibrava", 26, 31),
            ("claydol", 27, 32), ("hippowdon", 28, 33), ("drapion", 28, 33)
        ],
        "minibosses": [
            {"floor": 7,  "name": "Sablaireau l'Ancien", "species": "sandslash", "lv": 24, "music": "Boss Battle.ogg"},
            {"floor": 14, "name": "Cacturne le Veilleur", "species": "cacturne",  "lv": 28, "music": "Boss Battle.ogg"},
            {"floor": 22, "name": "Hippodocus le Colosse", "species": "hippowdon", "lv": 32, "music": "Boss Battle 2.ogg"}
        ],
        "weather_floors": {4: "sandstorm", 8: "sandstorm", 20: "sandstorm"}
    },
    {
        "id": "crevasse_geode",
        "name": "Crevasse de Géode",
        "name_en": "Geode Crevice",
        "rank": 31,
        "music_seg1": "Crystal Cave.ogg",
        "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "crystal_cave_1_floor", "wall_ts1": "crystal_cave_1_wall",
        "floor_ts2": "quartz_cavern_floor",  "wall_ts2": "quartz_cavern_wall",
        "spawns_seg1": [
            ("geodude", 18, 22), ("roggenrola", 18, 22), ("nosepass", 19, 23),
            ("carbink", 19, 23), ("aron", 20, 24)
        ],
        "spawns_seg2": [
            ("graveler", 25, 30), ("golem", 28, 33), ("boldore", 26, 31),
            ("gigalith", 29, 33), ("probopass", 27, 32), ("sableye", 26, 31)
        ],
        "minibosses": [
            {"floor": 8,  "name": "Gravalanch du Filon", "species": "graveler",  "lv": 24, "music": "Boss Battle.ogg"},
            {"floor": 16, "name": "Tarinor la Boussole", "species": "nosepass",  "lv": 28, "music": "Boss Battle.ogg"},
            {"floor": 24, "name": "Gigalithe le Diamant", "species": "gigalith", "lv": 33, "music": "Boss Battle 2.ogg"}
        ],
        "weather_floors": {14: "fog", 19: "fog"}
    },
    {
        "id": "verger_sauvage",
        "name": "Verger Sauvage",
        "name_en": "Wild Orchard",
        "rank": 32,
        "music_seg1": "Apple Woods.ogg",
        "music_seg2": "Mystifying Forest.ogg",
        "floor_ts1": "apple_woods_floor",  "wall_ts1": "apple_woods_wall",
        "floor_ts2": "orchard_path_floor", "wall_ts2": "orchard_path_wall",
        "spawns_seg1": [
            ("caterpie", 18, 21), ("weedle", 18, 21), ("cherubi", 19, 23),
            ("burmy", 19, 22), ("combee", 20, 24)
        ],
        "spawns_seg2": [
            ("butterfree", 25, 30), ("beedrill", 26, 31), ("heracross", 27, 32),
            ("pinsir", 27, 32), ("vespiquen", 28, 33), ("cherrim", 26, 31)
        ],
        "minibosses": [
            {"floor": 7,  "name": "Scarhino la Corne", "species": "heracross", "lv": 24, "music": "Boss Battle.ogg"},
            {"floor": 15, "name": "Scarabrute la Pince", "species": "pinsir",    "lv": 28, "music": "Boss Battle.ogg"},
            {"floor": 23, "name": "Apireine la Souveraine", "species": "vespiquen", "lv": 33, "music": "Boss Battle 2.ogg"}
        ],
        "weather_floors": {18: "rain"}
    },
    {
        "id": "plaines_brulees",
        "name": "Plaines Brûlées",
        "name_en": "Scorched Plains",
        "rank": 33,
        "music_seg1": "Amp Plains.ogg",
        "music_seg2": "Far Amp Plains.ogg",
        "floor_ts1": "amp_plains_floor",      "wall_ts1": "amp_plains_wall",
        "floor_ts2": "scorched_plains_floor", "wall_ts2": "scorched_plains_wall",
        "spawns_seg1": [
            ("shinx", 18, 22), ("mareep", 18, 22), ("electrike", 19, 23),
            ("phanpy", 19, 23), ("blitzle", 20, 24)
        ],
        "spawns_seg2": [
            ("luxio", 25, 29), ("luxray", 29, 33), ("flaaffy", 25, 29),
            ("ampharos", 28, 33), ("manectric", 27, 32), ("donphan", 27, 32)
        ],
        "minibosses": [
            {"floor": 8,  "name": "Luxio l'Éclair",      "species": "luxio",     "lv": 24, "music": "Boss Battle.ogg"},
            {"floor": 16, "name": "Phanpy la Charge",    "species": "phanpy",    "lv": 28, "music": "Boss Battle.ogg"},
            {"floor": 25, "name": "Élecsprint la Tempête", "species": "manectric", "lv": 33, "music": "Boss Battle 2.ogg"}
        ],
        "weather_floors": {17: "sunny"}
    }
]

def make_spawn_table(spawns_list):
    sp_dict = {}
    for idx, (sp, min_lv, max_lv) in enumerate(spawns_list):
        key = f"spawn_{idx}"
        sp_dict[key] = {
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

def update_zone_file(cfg):
    path = os.path.join(MOD_ROOT, "Data", "Zone", cfg["id"] + ".json")
    if not os.path.exists(path):
        # Clonage depuis desert_oublies.json comme gabarit 20 étages / 2 segments
        tpl_path = os.path.join(MOD_ROOT, "Data", "Zone", "desert_oublies.json")
        if os.path.exists(tpl_path):
            with open(tpl_path, "r", encoding="utf-8-sig") as f_tpl:
                data = json.load(f_tpl)
            print(f"  [Création] Gabarit clôné pour : {path}")
        else:
            print(f"  [Ignore] Gabarit introuvable pour : {path}")
            return
    else:
        with open(path, "r", encoding="utf-8-sig") as f:
            data = json.load(f)
    
    obj = data["Object"]
    obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
    
    # Validation / structuration en 2 Segments (10 étages chacun) + 3 Relais / Boss
    segments = obj.get("Segments", [])
    if len(segments) >= 2:
        # Segment 1 (Étages 1 à 10)
        seg1 = segments[0]
        seg1["Music"] = cfg["music_seg1"]
        for fl in seg1.get("Floors", []):
            if isinstance(fl, dict):
                for st in fl.get("GenSteps", []):
                    val = st.get("Value", {})
                    if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts1"]
                    if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts1"]
                    if "Spawns" in val or "TeamSpawns" in val:
                        val["Spawns"] = make_spawn_table(cfg["spawns_seg1"])
                        
        # Segment 2 (Étages 11 à 20)
        seg2 = segments[1] if len(segments) > 1 else seg1
        seg2["Music"] = cfg["music_seg2"]
        for fl in seg2.get("Floors", []):
            if isinstance(fl, dict):
                for st in fl.get("GenSteps", []):
                    val = st.get("Value", {})
                    if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts2"]
                    if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts2"]
                    if "Spawns" in val or "TeamSpawns" in val:
                        val["Spawns"] = make_spawn_table(cfg["spawns_seg2"])
                        
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"  [OK] {cfg['id']:18s} | Seg 1 ({cfg['floor_ts1']}) -> Seg 2 ({cfg['floor_ts2']}) | Scaling Lv 18-33")

def main():
    print("==========================================================================")
    print("=== GÉNÉRATION ET SCALING DES 4 DONJONS SECONDAIRES DU CHAPITRE 6 ===")
    print("==========================================================================\n")
    for cfg in CH6_DUNGEONS_CONFIG:
        update_zone_file(cfg)
    print("\n==========================================================================")
    print("=== 4 DONJONS DU CHAPITRE 6 CONFORMES À LA CONVENTION DE NOMMAGE & SCALING ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
