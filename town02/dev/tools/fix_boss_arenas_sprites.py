#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Corrige les arènes de combat :
1. Sprites de boss : aligne BaseForm = CurrentForm = espèce voulue
   (le moteur rend CurrentForm — un boss affiché Tsareena/Zeraora = bug).
2. Vide les AllyTeams fantômes (spectateurs Metano) dans les arènes de boss.
3. Repositionne les boss hors bornes (forgotten_marsh_miniboss).
"""
import json, os

MAPS = "Data/Map"

# espèce voulue par arène (d'après l'audit) : {arène: [espèces dans l'ordre des MapTeams]}
WANTED = {
    "tour_ciel_sommet": ["rayquaza"],
    "frosty_forest_summit": ["articuno"],
    "wish_cave_jirachi": ["jirachi"],
    "crystal_sanctuary_boss": ["diancie"],
    "crystal_sanctuary_miniboss": ["carbink", "froslass"],
    "forgotten_marsh_boss": ["swampert"],
    "forgotten_marsh_miniboss": ["swalot", "toxicroak"],
    "cloven_ruins_regice": ["regice"],
    "cloven_ruins_regirock": ["regirock"],
    "cloven_ruins_registeel": ["registeel"],
    "sanctuaire_titans": ["regigigas", "hitmonlee", "hitmonlee", "hitmonlee", "hitmonlee",
                          "bronzong", "bronzong", "bronzong", "bronzong"],
}

# arènes de boss isolées dont on VIDE les AllyTeams (spectateurs hérités du template)
CLEAR_ALLY = {"mount_windswept_guardian", "sanctuaire_voeu", "tour_ciel_sommet",
              "frosty_forest_summit", "magma_cavern_pit", "mt_blaze_summit",
              "wish_cave_jirachi", "cloven_ruins_regice", "cloven_ruins_regirock",
              "cloven_ruins_registeel", "crystal_sanctuary_boss",
              "crystal_sanctuary_miniboss", "forgotten_marsh_boss",
              "forgotten_marsh_miniboss", "gloomy_forest_boss", "gloomy_forest_miniboss",
              "sanctuaire_titans", "verdant_oath_arena", "vast_steppe_guardian",
              "searing_crucible", "marais_errants_fond", "chapter_3_boss_fight"}

def fix_species(mob, wanted_species):
    bf = mob.get("BaseForm", {})
    cf = mob.get("CurrentForm", {})
    if bf.get("Species") != wanted_species:
        bf["Species"] = wanted_species
    if cf.get("Species") != wanted_species:
        cf["Species"] = wanted_species
    # Form/Gender conservés si présents
    return mob

def walkable_center(tiles, W, H):
    """centre du sol walkable (ID == floor)"""
    floors = [(x, y) for x in range(W) for y in range(H)
              if tiles[x][y].get("Data", {}).get("ID") == "floor"]
    if not floors:
        return W // 2, H // 2
    xs = [p[0] for p in floors]; ys = [p[1] for p in floors]
    return (min(xs) + max(xs)) // 2, (min(ys) + max(ys)) // 2

def main():
    report = []
    for fname in sorted(os.listdir(MAPS)):
        if not fname.endswith(".rsmap"):
            continue
        path = os.path.join(MAPS, fname)
        arena = fname[:-6]
        with open(path, encoding="utf-8-sig") as f:
            d = json.load(f)
        obj = d["Object"]
        changed = False

        # --- 1. sprites : aligner sur l'espèce voulue ---
        if arena in WANTED:
            wanted = WANTED[arena]
            teams = obj.get("MapTeams", [])
            flat = [p for t in teams for p in t.get("Players", [])]
            if len(flat) != len(wanted):
                report.append(f"{arena}: {len(flat)} joueurs vs {len(wanted)} espèces voulues — on corrige quand même les espèces connues")
            for i, mob in enumerate(flat):
                sp = wanted[i] if i < len(wanted) else (mob.get("CurrentForm", {}).get("Species")
                                                        or mob.get("BaseForm", {}).get("Species"))
                before = mob.get("CurrentForm", {}).get("Species")
                fix_species(mob, sp)
                after = mob.get("CurrentForm", {}).get("Species")
                if before != after:
                    changed = True
                    report.append(f"{arena}: boss {before or '?'} -> {after}")

        # --- 3. repositionner les boss hors bornes (forgotten_marsh_miniboss) ---
        if arena == "forgotten_marsh_miniboss":
            T = obj.get("Tiles", [])
            if T:
                W = len(T); H = len(T[0])
                cx, cy = walkable_center(T, W, H)
                teams = obj.get("MapTeams", [])
                for ti, t in enumerate(teams):
                    for p in t.get("Players", []):
                        loc = p.get("serializationLoc", {})
                        nx, ny = cx + ti, cy
                        if nx >= W: nx = cx
                        if loc.get("X") != nx or loc.get("Y") != ny:
                            loc["X"] = nx; loc["Y"] = ny
                            changed = True
                            report.append(f"{arena}: boss repositionné @({nx},{ny})")

        # --- 2. vider les AllyTeams des arènes de boss isolées ---
        if arena in CLEAR_ALLY and obj.get("AllyTeams"):
            n = sum(len(t.get("Players", [])) for t in obj["AllyTeams"])
            obj["AllyTeams"] = []
            changed = True
            report.append(f"{arena}: {n} spectateurs retirés des AllyTeams")

        if changed:
            with open(path, "w", encoding="utf-8") as f:
                json.dump(d, f, ensure_ascii=False, indent=1)

    print(f"=== CORRECTION SPRITES + ALLYTEAMS ===")
    for r in report:
        print(" ", r)

if __name__ == "__main__":
    main()
