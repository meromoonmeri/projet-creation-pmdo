#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Crée une zone de PRÉVISUALISATION « exploration_cartes » qui déclare TOUTES les maps Ground
présentes dans quest_pmd_destiny/Data/Ground/, pour les explorer en mode développeur PMDO
(sans transitions, sans modifier les zones existantes).

Ajouts uniquement :
- quest_pmd_destiny/Data/Zone/exploration_cartes.json (ZoneData 0.8.12.0, « Segments »: [],
  « GroundMaps » = noms d'AssetName, même schéma que les zones conteneurs de construire_quest_destiny.py) ;
- une entrée « exploration_cartes » ajoutée à Data/Zone/index.idx (les autres entrées ne sont pas touchées).

Aucune transition, aucun script de map n'est créé ici.

Usage : python3 OUTILS/creer_zone_exploration_cartes.py [--dry-run]
"""
from __future__ import annotations

import argparse
import copy
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUEST = ROOT / "quest_pmd_destiny"
ZONE_ID = "exploration_cartes"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()

    grounds = sorted(p.name[:-len(".rsground")] for p in (QUEST / "Data" / "Ground").glob("*.rsground"))
    non_ascii = [g for g in grounds if not g.isascii()]
    if non_ascii:
        raise SystemExit(f"noms non ASCII (cassent CleanMapScript) : {non_ascii}")
    manquants = [g for g in grounds if not (QUEST / "Data" / "Script" / "ground" / g / "init.lua").exists()]

    base = json.loads((QUEST / "Data" / "Zone" / "personality_test.json").read_text(encoding="utf-8-sig"))
    zj = copy.deepcopy(base)
    obj = zj["Object"]
    obj["Name"]["DefaultText"] = "Exploration des cartes (dev)"
    obj["Name"]["LocalTexts"]["fr"] = "Exploration des cartes (dev)"
    obj["Comment"] = ("Zone de prévisualisation : toutes les maps Data/Ground déclarées pour l'exploration "
                      "en mode développeur. Aucune transition ; ne fait pas partie de la progression.")
    obj["Segments"] = []
    obj["GroundMaps"] = grounds

    idx_path = QUEST / "Data" / "Zone" / "index.idx"
    idx = json.loads(idx_path.read_text(encoding="utf-8-sig"))
    entrees = [v for k, v in idx["Object"].items() if isinstance(v, dict) and "Grounds" in v]
    modele = copy.deepcopy(entrees[0])
    modele["Grounds"] = grounds
    modele["Name"]["DefaultText"] = "Exploration des cartes (dev)"
    modele["Name"]["LocalTexts"]["fr"] = "Exploration des cartes (dev)"
    modele["Comment"] = obj["Comment"]
    modele["SortOrder"] = max(int(v.get("SortOrder", 0)) for v in entrees) + 1
    idx["Object"][ZONE_ID] = modele

    print(f"maps déclarées : {len(grounds)} ; sans init.lua : {len(manquants)} ; ASCII : oui")
    if not a.dry_run:
        (QUEST / "Data" / "Zone" / f"{ZONE_ID}.json").write_text(
            json.dumps(zj, ensure_ascii=False, indent=1), encoding="utf-8")
        idx_path.write_text(json.dumps(idx, ensure_ascii=False, indent=1), encoding="utf-8-sig")
        print("écrit : Data/Zone/exploration_cartes.json et entrée index.idx")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
