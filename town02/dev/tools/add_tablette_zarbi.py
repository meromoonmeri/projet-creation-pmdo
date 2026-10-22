#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
add_tablette_zarbi.py — POSE L'OBJET STÈLE DE ZARBI SUR LE CAMP DES RUINES.

BUG CORRIGÉ (2026-08-09) : le script cloven_ruins_entrance/init.lua définit
`Tablette_Zarbi_Action` (-> RuinesZarbi.LireTablette), et l'asset NDS
Content/Object/Tablette_Zarbi.dir existe, MAIS l'objet interactif (triggerType 1)
n'a jamais été posé sur le .rsground (retiré le 2026-08-04). Résultat : la stèle
n'apparaît pas, le joueur ne peut pas lire les mots de Zarbi, le système Aegis
Cave est inaccessible.

Ce script ajoute l'objet `Tablette_Zarbi` dans Entities[0].GroundObjects du
ground d'entrée, à une position validée (case libre sur la grille d'obstacles,
2x2 cellules, écart minimal avec les autres objets/markers).
"""
import json, math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GROUND = ROOT / "Data/Ground/cloven_ruins_entrance.rsground"

CELL = 8
RAYON = 8
ECART_MIN = 24  # px entre la stèle et tout autre objet/marker/spawner

def charger_grille(o):
    ob = o["obstacles"]
    W, H = len(ob), len(ob[0])
    bloc = [[ob[x][y]["Tags"] == 1 for y in range(H)] for x in range(W)]
    return bloc, W, H

def libre(bloc, W, H, px, py, rayon=RAYON):
    x0, x1 = (px - rayon) // CELL, (px + rayon - 1) // CELL
    y0, y1 = (py - rayon) // CELL, (py + rayon - 1) // CELL
    if x0 < 0 or y0 < 0 or x1 >= W or y1 >= H:
        return False
    for cx in range(x0, x1 + 1):
        for cy in range(y0, y1 + 1):
            if bloc[cx][cy]:
                return False
    return True

def centre(c):
    return c.get("X", 0) + c.get("Width", 0) / 2, c.get("Y", 0) + c.get("Height", 0) / 2

def trop_proche(px, py, objets):
    for o in objets:
        cx, cy = centre(o.get("Collider", {}))
        if math.hypot(px - cx, py - cy) < ECART_MIN:
            return True
    return False

def main():
    d = json.loads(GROUND.read_text(encoding="utf-8-sig"))
    o = d["Object"]

    # déjà posée ?
    for e in o.get("Entities", []):
        for go in e.get("GroundObjects", []):
            if go.get("EntName") == "Tablette_Zarbi":
                print("Tablette_Zarbi DÉJÀ présente — rien à faire.")
                return 0

    bloc, W, H = charger_grille(o)
    # tous les objets/markers/spawners existants (à éviter)
    existants = []
    for e in o.get("Entities", []):
        existants += e.get("GroundObjects", [])
        existants += e.get("Markers", [])
        for s in e.get("Spawners", []):
            existants.append({"Collider": s.get("Collider", {})})

    # candidates : près du centre du camp (192,208), sur la bande praticable
    cands = []
    for dy in range(-48, 97, 8):
        for dx in range(-96, 97, 8):
            px, py = 192 + dx, 208 + dy
            if libre(bloc, W, H, px, py) and not trop_proche(px, py, existants):
                cands.append((px, py))
    if not cands:
        print("AUCUNE position libre trouvée pour la stèle.")
        return 1
    # préférer : au nord du foyer (visible à l'arrivée), sinon le plus proche du centre
    cands.sort(key=lambda c: (abs(c[1] - 176), abs(c[0] - 192)))
    px, py = cands[0]
    print(f"Position retenue : ({px}, {py})")

    # construction de l'objet (format identique à Assembly/metano_town)
    tablette = {
        "EntName": "Tablette_Zarbi",
        "Direction": 0,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 1,
        "ObjectAnim": {
            "$type": "RogueEssence.Content.ObjAnimData, RogueEssence",
            "AnimIndex": "Tablette_Zarbi",
            "FrameTime": 1,
            "StartFrame": 0,
            "EndFrame": 0,
            "AnimDir": -1,
            "Alpha": 255,
            "AnimFlip": 0
        },
        "Passable": False,
        "CurrentAnim": {
            "$type": "RogueEssence.Content.ObjAnimData, RogueEssence",
            "AnimIndex": "",
            "FrameTime": 1,
            "StartFrame": -1,
            "EndFrame": -1,
            "AnimDir": 0,
            "Alpha": 255,
            "AnimFlip": 0
        },
        "AnimTime": {"Ticks": 0},
        "Cycles": 0,
        "DrawOffset": {"X": 0, "Y": 8},
        "Collider": {"X": px - 12, "Y": py - 12, "Width": 24, "Height": 24}
    }

    ents = o.get("Entities", [])
    if not ents:
        print("Aucune entité dans le ground — impossible d'ajouter l'objet.")
        return 1
    ents[0].setdefault("GroundObjects", []).append(tablette)

    GROUND.write_text(json.dumps(d, ensure_ascii=False, indent=1), encoding="utf-8")
    print("Tablette_Zarbi posée à ({},{}) — triggerType 1, anim Tablette_Zarbi.".format(px, py))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
