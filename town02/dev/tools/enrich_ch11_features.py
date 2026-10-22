#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys, json

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

CH11_DUNGEONS = [
    ("rainy_ravine", 10),
    ("mossy_gorge", 12),
    ("windswept_trail", 11),
    ("foggy_hollow", 12)
]

def make_wonder_tile_step():
    return {
        "$type": "RogueEssence.LevelGen.WonderTileStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [3]},
        "Tile": {"ID": "tile_wonder", "Revealed": True, "Owner": 0, "TileStates": []},
        "Count": 3
    }

def make_trap_step_seg1():
    return {
        "$type": "RogueEssence.LevelGen.TrapStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [3]},
        "Traps": {
            "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.LevelGen.EffectTile, RogueEssence]], RogueEssence",
            "spawns": {
                "trap_0": {"Spawn": {"ID": "trap_trip", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10},
                "trap_1": {"Spawn": {"ID": "trap_mud", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10},
                "trap_2": {"Spawn": {"ID": "trap_hunger", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 5}
            },
            "spawnTotal": 25
        }
    }

def make_trap_step_seg2():
    return {
        "$type": "RogueEssence.LevelGen.TrapStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [3]},
        "Traps": {
            "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.LevelGen.EffectTile, RogueEssence]], RogueEssence",
            "spawns": {
                "trap_0": {"Spawn": {"ID": "trap_seal", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10},
                "trap_1": {"Spawn": {"ID": "trap_slumber", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10},
                "trap_2": {"Spawn": {"ID": "trap_spikes", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 10},
                "trap_3": {"Spawn": {"ID": "trap_hunger", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 5}
            },
            "spawnTotal": 35
        }
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

def enrich_dungeon(zone_id, cafe_fl):
    path = os.path.join(MOD_ROOT, "Data", "Zone", zone_id + ".json")
    if not os.path.exists(path):
        print(f"  [Erreur] {path} introuvable.")
        return
    with open(path, "r", encoding="utf-8-sig") as f:
        data = json.load(f)
    segments = data["Object"].get("Segments", [])
    if len(segments) >= 2:
        # Seg 1
        for fl_idx, fl in enumerate(segments[0].get("Floors", [])):
            if isinstance(fl, dict):
                steps = fl.setdefault("GenSteps", [])
                steps.append(make_wonder_tile_step())
                steps.append(make_trap_step_seg1())
                steps.append(make_shop_step())
                if fl_idx + 1 == cafe_fl:
                    steps.append(make_cafe_step())
        # Seg 2
        for fl_idx, fl in enumerate(segments[1].get("Floors", [])):
            if isinstance(fl, dict):
                steps = fl.setdefault("GenSteps", [])
                steps.append(make_wonder_tile_step())
                steps.append(make_trap_step_seg2())
                steps.append(make_shop_step())
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"  ✅ {zone_id:22s} | Pièges, Dalles Miracle, Kecleon + Café (Ét.{cafe_fl})")

if __name__ == "__main__":
    print("=== ENRICHISSEMENT CH11 ===")
    for z_id, cafe_fl in CH11_DUNGEONS:
        enrich_dungeon(z_id, cafe_fl)
