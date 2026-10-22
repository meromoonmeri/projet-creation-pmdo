#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
drop_ch6_ch10_boss_grounds.py — Purge des anciens grounds de boss obsolètes (.rsground)
des Chapitres 6 à 10 au profit de leurs arènes en donjon (.rsmap),
conformément à la Directive Absolue du Manifeste d'Identité.

Grounds retirés :
  - gloomy_forest_boss (Zarude, Ch6)
  - crystal_sanctuary_boss (Diancie, Ch8)
  - forgotten_marsh_boss (Laggron, Ch9)
  - celestial_peak_boss (Lugia, Ch10)

Les entrées dans master_zone.json sont préservées comme places mortes afin
d'éviter de décaler les indices des autres grounds ciblant un index codé en dur.
"""
import os, sys, shutil

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

OBSOLETE_BOSS_GROUNDS = [
    "gloomy_forest_boss",
    "crystal_sanctuary_boss",
    "forgotten_marsh_boss",
    "celestial_peak_boss"
]

def purge_obsolete_grounds():
    print("=== 1. Suppression des fichiers .rsground obsolètes ===")
    for bg in OBSOLETE_BOSS_GROUNDS:
        p_ground = os.path.join(MOD_ROOT, "Data", "Ground", bg + ".rsground")
        if os.path.exists(p_ground):
            os.remove(p_ground)
            print(f"  [Supprimé] {os.path.relpath(p_ground, MOD_ROOT)}")
        else:
            print(f"  [Absent]   {os.path.relpath(p_ground, MOD_ROOT)}")
        
        p_script = os.path.join(MOD_ROOT, "Data", "Script", "halcyon", "ground", bg)
        if os.path.exists(p_script) and os.path.isdir(p_script):
            shutil.rmtree(p_script)
            print(f"  [Supprimé] Répertoire script : {os.path.relpath(p_script, MOD_ROOT)}/")

def update_verify_new_era():
    print("=== 2. Mise à jour des seuils dans verify_new_era.sh (277 -> 273) ===")
    sh_path = os.path.join(MOD_ROOT, "verify_new_era.sh")
    if not os.path.exists(sh_path):
        return
    with open(sh_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    if "EXPECTED_GROUNDS=277" in content:
        content = content.replace("EXPECTED_GROUNDS=277", "EXPECTED_GROUNDS=273")
        with open(sh_path, "w", encoding="utf-8") as f:
            f.write(content)
        print("  -> verify_new_era.sh synchronisé à EXPECTED_GROUNDS=273.")
    elif "EXPECTED_GROUNDS=273" in content:
        print("  -> verify_new_era.sh déjà à EXPECTED_GROUNDS=273.")

def main():
    print("==========================================================================")
    print("=== PURGE DES GROUNDS INDÉPENDANTS DE BOSS (CH6 À CH10) ===")
    print("==========================================================================\n")
    purge_obsolete_grounds()
    update_verify_new_era()
    print("\n==========================================================================")
    print("=== PURGE TERMINÉE — RELANCE DE L'AUDIT DE CONFORMITÉ ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
