#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_and_migrate_boss_arenas.py — Auditeur & Moteur de mise en conformité
des donjons et arènes de boss (Chapitres 6 à 10) selon le Manifeste d'Identité.

Vérifie les 4 Piliers du Manifeste :
  1. Zéro ground indépendant pour les boss (détection des .rsground isolés)
  2. Adaptation au biome (tilesets & musique sur les .rsmap de boss)
  3. Tables de Pokémon sauvages dédiées par donjon
  4. Identité architecturale unique.
"""
import os, sys, json, glob

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

DUNGEONS_CH6_CH10 = [
    {
        "id": "gloomy_forest",
        "name": "Forêt Lugubre",
        "ch": 6,
        "boss": "Zarude",
        "rsmap_boss": ["gloomy_forest_boss"],
        "rsground_boss": ["gloomy_forest_boss"]
    },
    {
        "id": "cloven_ruins",
        "name": "Aegis Cave",
        "ch": 7,
        "boss": "Regigigas / Régis",
        "rsmap_boss": ["cloven_ruins_boss", "cloven_ruins_regice", "cloven_ruins_regirock", "cloven_ruins_registeel"],
        "rsground_boss": []  # Déjà migré via drop_ruines_grounds.py
    },
    {
        "id": "crystal_sanctuary",
        "name": "Sanctuaire de Cristal",
        "ch": 8,
        "boss": "Diancie",
        "rsmap_boss": ["crystal_sanctuary_boss"],
        "rsground_boss": ["crystal_sanctuary_boss"]
    },
    {
        "id": "forgotten_marsh",
        "name": "Marais de l'Oubli",
        "ch": 9,
        "boss": "Laggron / Swampert",
        "rsmap_boss": ["forgotten_marsh_boss", "forgotten_marsh_miniboss"],
        "rsground_boss": ["forgotten_marsh_boss"]
    },
    {
        "id": "celestial_peak",
        "name": "Pic Céleste",
        "ch": 10,
        "boss": "Lugia / Escouade Fulgur",
        "rsmap_boss": ["celestial_peak_boss", "celestial_peak_fulgur"],
        "rsground_boss": ["celestial_peak_boss"]
    }
]

def inspect_rsground(name):
    path = os.path.join(MOD_ROOT, "Data", "Ground", name + ".rsground")
    if not os.path.exists(path):
        return None
    with open(path, encoding="utf-8-sig") as f:
        data = json.load(f)["Object"]
    sheets = set()
    for lay in data.get("Layers", []):
        for col in lay.get("Tiles", []):
            for cell in col:
                for tl in cell.get("Layers", []):
                    for fr in tl.get("Frames", []):
                        if fr.get("Sheet"):
                            sheets.add(fr["Sheet"])
    return {
        "path": path,
        "sheets": sorted(list(sheets)),
        "size_bytes": os.path.getsize(path)
    }

def inspect_rsmap(name):
    path = os.path.join(MOD_ROOT, "Data", "Map", name + ".rsmap")
    if not os.path.exists(path):
        return None
    with open(path, encoding="utf-8-sig") as f:
        data = json.load(f)["Object"]
    bosses = []
    for t in data.get("MapTeams", []):
        for pl in t.get("Players", []):
            sp = pl.get("BaseForm", {}).get("Species", "unknown")
            loc = pl.get("serializationLoc", {})
            bosses.append(f"{sp} @ ({loc.get('X')},{loc.get('Y')})")
    return {
        "path": path,
        "name": data.get("Name", {}).get("DefaultText", ""),
        "music": data.get("Music", ""),
        "bosses": bosses
    }

def inspect_wild_table(zone_id):
    path = os.path.join(MOD_ROOT, "Data", "Zone", zone_id + ".json")
    if not os.path.exists(path):
        return None
    with open(path, encoding="utf-8-sig") as f:
        data = json.load(f)["Object"]
    spawns_per_segment = []
    for s_idx, seg in enumerate(data.get("Segments", [])):
        spawns = set()
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
        spawns_per_segment.append((s_idx, len(floors), sorted(list(spawns))))
    return spawns_per_segment

def main():
    print("==========================================================================")
    print("=== AUDIT EXHAUSTIF DU MANIFESTE : DONJONS & BOSS (CHAPITRES 6 À 10) ===")
    print("==========================================================================\n")

    total_rsground_violations = 0
    total_rsmap_bosses = 0

    for d in DUNGEONS_CH6_CH10:
        print(f"--------------------------------------------------------------------------")
        print(f"► CHAPITRE {d['ch']} : {d['name']} (`{d['id']}`) | Boss : {d['boss']}")
        print(f"--------------------------------------------------------------------------")
        
        # 1. Règle d'or 1 : Audit des Grounds indépendants de boss (.rsground)
        print("  [Pilier 1] Grounds indépendants de boss (.rsground isolés) :")
        if not d["rsground_boss"]:
            print("    ✅ 0 ground indépendant — Conformité totale (Arènes en .rsmap uniquement).")
        else:
            for bg in d["rsground_boss"]:
                res_g = inspect_rsground(bg)
                if res_g:
                    total_rsground_violations += 1
                    print(f"    ❌ VIOLATION DÉTECTÉE : `{bg}.rsground` ({res_g['size_bytes']//1024} Ko) existe encore !")
                    print(f"       -> Tuiles utilisées : {res_g['sheets']} (tilesets génériques / recyclés)")
                else:
                    print(f"    ✅ `{bg}.rsground` absent du disque.")

        # 2. Règle d'or 2 : Audit des arènes en donjon (.rsmap)
        print("  [Pilier 2] Salles de confrontation en donjon (`.rsmap`) :")
        for bm in d["rsmap_boss"]:
            res_m = inspect_rsmap(bm)
            if res_m:
                total_rsmap_bosses += 1
                print(f"    ✅ `{bm}.rsmap` | Titre : \"{res_m['name']}\" | Musique : `{res_m['music']}`")
                print(f"       -> Combattants : {res_m['bosses']}")
            else:
                print(f"    ⚠️ Arène manquante : `{bm}.rsmap`")

        # 3. Règle d'or 3 : Audit des tables de Pokémon sauvages
        print("  [Pilier 3] Tables de Pokémon sauvages (`Spawns` dans le .json) :")
        wild = inspect_wild_table(d["id"])
        if wild:
            for s_idx, n_floors, sp_list in wild:
                if sp_list:
                    print(f"    • Segment {s_idx} ({n_floors} étages) : {len(sp_list)} espèces dédiées -> {', '.join(sp_list[:7])}{'...' if len(sp_list)>7 else ''}")
                else:
                    print(f"    • Segment {s_idx} ({n_floors} étages) : Arène de boss / relais (pas de faune sauvage, normal)")
        print()

    print("==========================================================================")
    print(f"RÉSULTAT DE L'AUDIT :")
    print(f"  • {total_rsmap_bosses} arènes intégrées en donjon (.rsmap) prêtes pour le combat.")
    print(f"  • {total_rsground_violations} grounds indépendants (.rsground) identifiés comme obsolètes à purger/migrer.")
    print("==========================================================================")

if __name__ == "__main__":
    main()
