#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
retile_all_boss_arenas.py — Harmonisation intégrale des arènes de boss
et mini-boss (Ch5 à Ch10) avec l'identité biômique de leur donjon.

Remplace les tilesets génériques ou copiés-collés (ex. treeshroud_forest
dans un volcan, concealed_ruins pour un sanctuaire de cristal) par les
tilesets natifs du biome de chaque donjon.
"""
import os, sys, json, glob

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

BIOME_MAPPING = {
    # Chapitre 5
    "searing_tunnel_miniboss":  ("magma_cavern_2_floor", "magma_cavern_2_wall", "magma_cavern_2_secondary"),
    "mount_windswept_miniboss": ("craggy_peak_floor",    "craggy_peak_wall",    "craggy_peak_secondary"),
    "mount_windswept_guardian": ("mt_horn_floor",        "mt_horn_wall",        "mt_horn_secondary"),
    # Chapitre 6
    "gloomy_forest_miniboss":   ("treeshroud_forest_1_floor", "treeshroud_forest_1_wall", "treeshroud_forest_1_secondary"),
    "gloomy_forest_boss":       ("treeshroud_forest_1_floor", "treeshroud_forest_1_wall", "treeshroud_forest_1_secondary"),
    # Chapitre 7
    "cloven_ruins_miniboss":    ("western_cave_1_floor", "western_cave_1_wall", "western_cave_1_secondary"),
    "cloven_ruins_boss":        ("western_cave_1_floor", "western_cave_1_wall", "western_cave_1_secondary"),
    # Chapitre 8 — Sanctuaire de Cristal (Diancie)
    "crystal_sanctuary_miniboss": ("crystal_cave_1_floor", "crystal_cave_1_wall", "crystal_cave_1_secondary"),
    "crystal_sanctuary_boss":     ("crystal_cave_1_floor", "crystal_cave_1_wall", "crystal_cave_1_secondary"),
    # Chapitre 9 — Marais de l'Oubli (Swampert / Laggron)
    "forgotten_marsh_miniboss": ("murky_cave_floor", "murky_cave_wall", "murky_cave_secondary"),
    "forgotten_marsh_boss":     ("murky_cave_floor", "murky_cave_wall", "murky_cave_secondary"),
    # Chapitre 10 — Pic Céleste (Lugia / Escouade Fulgur)
    "celestial_peak_fulgur":    ("sky_tower_floor", "sky_tower_wall", "sky_tower_secondary"),
    "celestial_peak_boss":      ("sky_tower_floor", "sky_tower_wall", "sky_tower_secondary"),
}

def retile_rsmap(map_name, floor_ts, wall_ts, sec_ts):
    path = os.path.join(MOD_ROOT, "Data", "Map", map_name + ".rsmap")
    if not os.path.exists(path):
        print(f"  [Ignore] Carte introuvable : {map_name}.rsmap")
        return False
    
    with open(path, "r", encoding="utf-8-sig") as f:
        data = json.load(f)
    
    obj = data["Object"]
    old_bg = obj.get("BlankBG", {}).get("AutoTileset", "vide")
    
    # 1. Mettre à jour BlankBG
    if "BlankBG" not in obj or not obj["BlankBG"]:
        obj["BlankBG"] = {"AutoTileset": wall_ts, "Associates": [], "Layers": [], "NeighborCode": -1}
    else:
        obj["BlankBG"]["AutoTileset"] = wall_ts
    
    # 2. Parcourir et mettre à jour toutes les tuiles selon leur ID (floor vs unbreakable/secondary)
    tiles_updated = 0
    for col in obj.get("Tiles", []):
        for t in col:
            tid = t.get("Data", {}).get("ID", "")
            tex = t.get("Data", {}).get("TileTex", {})
            if tid == "floor":
                tex["AutoTileset"] = floor_ts
            elif tid == "unbreakable" or tid == "wall":
                tex["AutoTileset"] = wall_ts
            elif tid == "secondary" or "water" in tid:
                tex["AutoTileset"] = sec_ts
            else:
                tex["AutoTileset"] = wall_ts
            tiles_updated += 1
            
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"  [OK] {map_name:28s} | BlankBG: {old_bg:25s} -> {wall_ts:25s} ({tiles_updated} tuiles adaptées)")
    return True

def main():
    print("==========================================================================")
    print("=== HARMONISATION BIÔMIQUE DES ARÈNES DE BOSS & MINI-BOSS (CH5 À CH10) ===")
    print("==========================================================================\n")
    
    total_retiled = 0
    for map_name, (floor_ts, wall_ts, sec_ts) in BIOME_MAPPING.items():
        if retile_rsmap(map_name, floor_ts, wall_ts, sec_ts):
            total_retiled += 1
            
    print("\n==========================================================================")
    print(f"=== {total_retiled} ARÈNES RECONFIGURÉES ET ADAPTÉES À LEUR BIOME ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
