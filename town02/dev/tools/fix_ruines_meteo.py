#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fix_ruines_meteo.py — supprime la meteo qui fait planter les Aegis Cave.

LE CRASH
--------
    System.NullReferenceException
      at PMDC.Dungeon.WeatherFillEvent.Apply(...)
      at RogueEssence.Dungeon.DungeonScene.ProcessMapTurnEnd(...)

Il se declenche a CHAQUE FIN DE TOUR, donc en boucle des qu'on marche.

LA CAUSE, mesuree
-----------------
Les quatre labyrinthes des Ruines portent un DefaultMapStatusStep :

    "DefaultMapStatus": ["clear", "clear", "clear", "sandstorm"]

soit une chance sur quatre de demarrer l'etage en « sandstorm ».

Or le mod DEFINIT son propre Data/MapStatus/sandstorm.json, et ce fichier
n'est PAS la meteo du jeu : c'est un statut purement DECORATIF (« Sable
pousse au ras du sol. Base falling_ash, teinte ocre par l'overlay »). Il ne
contient qu'un ScreenRainEmitter et un MapStatusRefreshEvent — aucun des
etats de jeu qu'une vraie meteo porte.

Comme il porte l'identifiant `sandstorm`, il ECRASE la meteo homonyme du
jeu de base. Le moteur, lui, traite `sandstorm` comme une meteo et lui
applique WeatherFillEvent en fin de tour ; l'evenement va lire des donnees
que le statut decoratif ne possede pas, et deref un null.

Verification faite : ce sandstorm decoratif n'est reference par AUCUN ground
ni AUCUN script du mod. Il n'existe que pour habiller des cartes, et le seul
effet observable de sa presence dans une table de meteo est ce crash.

LA CORRECTION
-------------
On retire `sandstorm` des tables de meteo des Ruines et on le remplace par
`clear`. Choix motive :

  * les Ruines sont un donjon SOUTERRAIN. Une tempete de sable sous plusieurs
    dizaines de metres de roche n'avait de toute facon aucun sens ;
  * Aegis Cave, l'original porte, n'a aucune meteo ;
  * `clear` est deja la valeur des trois autres tirages, donc le resultat est
    un etage a meteo neutre — exactement ce qu'on veut ici.

PERIMETRE
---------
Ce script ne touche QUE cloven_ruins.json. Le meme defaut existe dans
antre_enigme (x10), montagne_traitresse (x12) et celestial_peak
(falling_ash, x4) : ils sont signales en fin d'execution mais PAS modifies,
car ils sortent du perimetre demande et meritent leur propre verification.
"""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import glob
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ZONE = ROOT / "Data/Zone/cloven_ruins.json"

# Statuts du mod qui sont DECORATIFS (aucun effet de jeu) et ne doivent donc
# jamais etre injectes comme meteo par un DefaultMapStatusStep.
A_REMPLACER = "sandstorm"
REMPLACANT = "clear"


def statuts_decoratifs() -> set:
    """Un statut est decoratif s'il ne porte aucun evenement de jeu."""
    deco = set()
    for f in glob.glob(str(ROOT / "Data/MapStatus/*.json")):
        nom = Path(f).stem
        if nom == "index":
            continue
        s = Path(f).read_text(encoding="utf-8-sig")
        ev = set(re.findall(r"PMDC\.Dungeon\.(\w+Event)", s))
        if ev <= {"MapStatusRefreshEvent"}:
            deco.add(nom)
    return deco


def main() -> int:
    deco = statuts_decoratifs()
    if A_REMPLACER not in deco:
        print(f"ARRET : '{A_REMPLACER}' n'est plus un statut decoratif du mod.")
        print("        Le diagnostic de ce script ne tient plus, verifier a la main.")
        return 1
    print(f"'{A_REMPLACER}' confirme decoratif (aucun evenement de jeu) "
          f"-> inutilisable comme meteo\n")

    doc = json.loads(ZONE.read_text(encoding="utf-8-sig"))
    total = 0
    for i, seg in enumerate(doc["Object"]["Segments"]):
        def parcours(n):
            nonlocal total
            if isinstance(n, dict):
                if n.get("SetterID") == "default_weather":
                    lst = n.get("DefaultMapStatus") or []
                    if A_REMPLACER in lst:
                        avant = list(lst)
                        n["DefaultMapStatus"] = [
                            REMPLACANT if v == A_REMPLACER else v for v in lst
                        ]
                        total += 1
                        print(f"  seg{i} : {avant} -> {n['DefaultMapStatus']}")
                for v in n.values():
                    parcours(v)
            elif isinstance(n, list):
                for v in n:
                    parcours(v)
        parcours(seg)

    if total == 0:
        print("  rien a corriger (deja fait ?)")
        return 0

    ZONE.write_text(
        json.dumps(doc, ensure_ascii=False, indent=1), encoding="utf-8"
    )
    json.loads(ZONE.read_text(encoding="utf-8-sig"))
    print(f"\n{total} table(s) de meteo corrigee(s) dans {ZONE.name}")
    print("OK  le JSON de zone se relit sans erreur")

    # Signalement des autres zones atteintes, sans y toucher.
    autres = {}
    for f in glob.glob(str(ROOT / "Data/Zone/*.json")):
        if Path(f).name == ZONE.name:
            continue
        s = Path(f).read_text(encoding="utf-8-sig")
        for m in re.finditer(
            r'"SetterID": "default_weather",\s*"DefaultMapStatus": \[(.*?)\]',
            s, re.S
        ):
            for v in re.findall(r'"([a-z_]+)"', m.group(1)):
                if v in deco:
                    autres[(Path(f).name, v)] = autres.get((Path(f).name, v), 0) + 1
    if autres:
        print("\nMEME DEFAUT AILLEURS — signale, NON corrige (hors perimetre) :")
        for (z, v), n in sorted(autres.items()):
            print(f"    {z:28s} {v:14s} x{n}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
