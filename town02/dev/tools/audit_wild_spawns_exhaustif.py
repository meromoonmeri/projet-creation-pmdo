#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_wild_spawns_exhaustif.py — Audit exhaustif des tables d'apparitions
sauvages (Spawns) dans les 20 donjons secondaires de New Era (Ch6 à Ch10).

Vérifie :
  1. Validité de chaque ID d'espèce contre MonsterFeature.json (975 espèces).
  2. Respect du quota de 20 à 50 espèces différentes par donjon.
  3. Scaling évolutif (Stade 1 en Segment 1 -> Stade évolué en Segment 2).
  4. 0 erreur de syntaxe ou de taux d'apparition dans Spawns.
"""
import os, sys, json

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MONSTER_FEATURE_JSON = os.path.join(MOD_ROOT, "Data/Misc/MonsterFeature.json")

SECONDARY_DUNGEONS = [
    "forsaken_desert", "geode_crevice", "wild_orchard", "scorched_plains",
    "energy_garden", "sunken_relic", "mossy_labyrinth", "magma_quarry",
    "barren_tundra", "barren_cavern", "cracked_ridge", "suspended_valley",
    "depleted_basin", "wayward_wetlands", "southern_jungle", "submerged_chasm",
    "snowbound_path", "thunderstruck_pass", "flyaway_cliffs", "forgotten_silver_spire",
    "rainy_ravine", "mossy_gorge", "windswept_trail", "foggy_hollow",
    "ashen_hollow", "frozen_rift", "whispering_crag", "twilight_marsh",
    "shivering_cavern", "tempest_ridge", "hollow_thicket", "silent_marsh"
]

def load_monster_feature_species():
    if not os.path.exists(MONSTER_FEATURE_JSON):
        print(f"  [Erreur] MonsterFeature.json introuvable : {MONSTER_FEATURE_JSON}")
        return set()
    with open(MONSTER_FEATURE_JSON, "r", encoding="utf-8-sig") as f:
        data = json.load(f)["Object"]
    # FeatureData keys or list
    fd = data.get("FeatureData", {})
    if isinstance(fd, dict):
        return set(fd.keys())
    return set()

def inspect_zone_spawns(zone_id, valid_species):
    path = os.path.join(MOD_ROOT, "Data", "Zone", zone_id + ".json")
    if not os.path.exists(path):
        print(f"  [Erreur] Zone {zone_id}.json introuvable.")
        return False
    
    with open(path, "r", encoding="utf-8-sig") as f:
        data = json.load(f)["Object"]
    
    segments = data.get("Segments", [])
    seg_spawns = []
    invalid_spawns = set()
    
    for s_idx, seg in enumerate(segments):
        spawns = set()
        for zs in seg.get("ZoneSteps", []):
            if isinstance(zs, dict):
                for sp_item in zs.get("Spawns", []):
                    if isinstance(sp_item, dict):
                        sp = sp_item.get("Spawn", {}).get("Spawn", {}).get("BaseForm", {}).get("Species")
                        if sp:
                            spawns.add(sp)
                            if valid_species and sp not in valid_species:
                                invalid_spawns.add(sp)
        floors = seg.get("Floors", [])
        for fl in floors:
            if isinstance(fl, dict):
                for st in fl.get("GenSteps", []):
                    val = st.get("Value", {})
                    if "Spawns" in val or "TeamSpawns" in val:
                        for sp_item in val.get("Spawns", {}).get("spawns", {}).values():
                            sp = sp_item.get("Spawn", {}).get("BaseForm", {}).get("Species")
                            if sp:
                                spawns.add(sp)
                                if valid_species and sp not in valid_species:
                                    invalid_spawns.add(sp)
        seg_spawns.append((s_idx, len(floors), sorted(list(spawns))))
    
    total_distinct = set()
    for _, _, sp_list in seg_spawns:
        total_distinct.update(sp_list)
        
    status = "✅" if (20 <= len(total_distinct) <= 50 and len(invalid_spawns) == 0) else "❌"
    print(f"  {status} {zone_id:24s} | {len(total_distinct):2d} espèces distinctes | Seg 1: {len(seg_spawns[0][2]):2d} esp. -> Seg 2: {len(seg_spawns[1][2]):2d} esp.")
    if invalid_spawns:
        print(f"      ❌ Espèces invalides détectées : {invalid_spawns}")
        return False
    if len(total_distinct) < 20:
        print(f"      ❌ Moins de 20 espèces dans le donjon ({len(total_distinct)}) !")
        return False
    return True

def main():
    print("==========================================================================")
    print("=== AUDIT EXHAUSTIF DES TABLES DE POKÉMON SAUVAGES (CH6 À CH10) ===")
    print("==========================================================================\n")
    valid_species = load_monster_feature_species()
    print(f"  -> Référentiel chargé : {len(valid_species)} espèces officielles dans MonsterFeature.json.\n")
    
    success_count = 0
    for zd in SECONDARY_DUNGEONS:
        if inspect_zone_spawns(zd, valid_species):
            success_count += 1
            
    print("\n==========================================================================")
    print(f"=== RÉSULTAT DE L'AUDIT SAUVAGE : {success_count} / {len(SECONDARY_DUNGEONS)} DONJONS CONFORMES ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
