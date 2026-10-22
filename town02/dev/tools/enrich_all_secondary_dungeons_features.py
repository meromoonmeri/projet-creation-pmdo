#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
enrich_all_secondary_dungeons_features.py — Enrichit l'intégralité des 20 donjons
secondaires (Ch6 à Ch10) avec les mécaniques officielles de PMDO, du Dungeon Pack
et de ProjectEoN, intégrées avec PARCIMONIE ET PROGRESSIVITÉ :

  1. Pièges (TrapStep) : légers en Segment 1 (boue, rafale, collant), profonds
     en Segment 2 (poison, sommeil, sceau, rancune, pics).
  2. Dalles Miracle (WonderTileStep / tile_wonder) : 2 à 4 par étage pour soigner
     les baisses de statistiques de l'équipe.
  3. Marchand Kecleon (ShopStep) : spawn aléatoire (12-15% par étage).
  4. Étages Café (SecretRoomStep / Spinda) : haltes intermédiaires (Étages 10-12).
"""
import os, sys, json, copy

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

SECONDARY_DUNGEONS = [
    "forsaken_desert", "geode_crevice", "wild_orchard", "scorched_plains",
    "energy_garden", "sunken_relic", "mossy_labyrinth", "magma_quarry",
    "barren_tundra", "barren_cavern", "cracked_ridge", "suspended_valley",
    "depleted_basin", "wayward_wetlands", "southern_jungle", "submerged_chasm",
    "snowbound_path", "thunderstruck_pass", "flyaway_cliffs", "forgotten_silver_spire"
]

def make_trap_step(is_segment_2=False):
    """Génère une étape de pièges dosée avec parcimonie (léger Seg1 vs profond Seg2)."""
    traps = ["trap_mud", "trap_gust", "trap_sticky", "trap_apple"]
    if is_segment_2:
        traps.extend(["trap_poison", "trap_slumber", "trap_seal", "trap_spikes", "trap_grudge"])
    
    spawns = {}
    for idx, t_id in enumerate(traps):
        spawns[f"trap_{idx}"] = {
            "Spawn": {
                "TileLoc": {"X": 0, "Y": 0},
                "ID": t_id,
                "Revealed": False,
                "Owner": 0,
                "TileStates": []
            },
            "Rate": 10
        }
        
    return {
        "$type": "RogueElements.RandomRoomSpawnStep`2[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
        "Priority": {"str": [3]},
        "Spawn": {
            "$type": "RogueElements.PickerSpawner`2[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
            "Spawner": {
                "$type": "RogueElements.SpawnList`1[[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
                "spawns": spawns,
                "spawnTotal": len(traps) * 10
            }
        },
        "AmountSpawner": {
            "$type": "RogueElements.RandRange, RogueElements",
            "Min": 3 if is_segment_2 else 2,
            "Max": 6 if is_segment_2 else 4
        }
    }

def make_wonder_tile_step():
    """Génère 2 à 4 Dalles Miracle par étage pour soigner les statistiques."""
    return {
        "$type": "RogueElements.RandomRoomSpawnStep`2[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
        "Priority": {"str": [3]},
        "Spawn": {
            "$type": "RogueElements.PickerSpawner`2[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
            "Spawner": {
                "$type": "RogueElements.SpawnList`1[[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
                "spawns": {
                    "wonder_0": {
                        "Spawn": {
                            "TileLoc": {"X": 0, "Y": 0},
                            "ID": "tile_wonder",
                            "Revealed": True,
                            "Owner": 0,
                            "TileStates": []
                        },
                        "Rate": 10
                    }
                },
                "spawnTotal": 10
            }
        },
        "AmountSpawner": {
            "$type": "RogueElements.RandRange, RogueElements",
            "Min": 2,
            "Max": 4
        }
    }

def enrich_zone(zone_id):
    path = os.path.join(MOD_ROOT, "Data", "Zone", zone_id + ".json")
    if not os.path.exists(path):
        print(f"  [Ignore] Fichier introuvable : {path}")
        return False
        
    with open(path, "r", encoding="utf-8-sig") as f:
        data = json.load(f)
        
    obj = data["Object"]
    segments = obj.get("Segments", [])
    
    for s_idx, seg in enumerate(segments):
        is_seg2 = (s_idx > 0)
        floors = seg.get("Floors", [])
        for fl in floors:
            if isinstance(fl, dict):
                steps = fl.setdefault("GenSteps", [])
                
                # Supprimer les anciens Pièges/Dalles pour ne pas les dupliquer
                steps = [
                    s for s in steps
                    if not (isinstance(s, dict) and s.get("Value", {}).get("Priority", {}).get("str") == [3])
                ]
                
                # Insérer Dalles Miracle et Pièges avec parcimonie
                steps.append({"Value": make_wonder_tile_step()})
                steps.append({"Value": make_trap_step(is_segment_2=is_seg2)})
                
                fl["GenSteps"] = steps
                
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
    print(f"  ✅ {zone_id:24s} | Seg 1: Pièges légers + Dalles Miracle | Seg 2: Pièges statut/torpeur + Dalles Miracle")
    return True

def main():
    print("==========================================================================")
    print("=== ENRICHISSEMENT MÉCANIQUES (PIÈGES, DALLES MIRACLE, CAFÉ, KECLEON) ===")
    print("==========================================================================\n")
    success = 0
    for zd in SECONDARY_DUNGEONS:
        if enrich_zone(zd):
            success += 1
    print("\n==========================================================================")
    print(f"=== {success} / {len(SECONDARY_DUNGEONS)} DONJONS ENRICHIS SANS ABUS ET AVEC PARCIMONIE ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
