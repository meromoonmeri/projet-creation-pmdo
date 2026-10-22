#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
wire_ruines_casting.py — pose les combattants dans les quatre arenes des Ruines.

A executer APRES tools/make_ruines_arenes.py, qui dessine les salles et laisse
MapTeams vide.

POURQUOI UN SCRIPT SEPARE
-------------------------
La geometrie et le casting ont des raisons de changer differentes. On peut
vouloir redessiner une salle sans retoucher les niveaux, et l'inverse. Les
deux etapes valident aussi des choses differentes : la geometrie verifie la
connexite, le casting verifie que personne ne spawn dans un mur.

CE QUE CE SCRIPT CORRIGE
------------------------
1. Les huit gardes de Regigigas s'appelaient TOUS « Regigigas » (Nickname
   recopie du boss lors de la generation d'origine). En jeu, le journal de
   combat affichait huit lignes « Regigigas » pour des Hitmonlee et des
   Bronzong.
2. Les positions de l'ancienne carte 25x27 ne valent plus rien sur les
   nouvelles geometries. Elles sont toutes recalculees relativement au choeur
   et aux niches de chaque salle.
3. Unrecruitable etait false sur les Regi. L'utilisateur veut pouvoir les
   recruter PLUS TARD, pas au moment ou ils tombent en pleine cinematique
   scriptee : un recrutement ici couperait la scene d'apres-combat.

Chaque combattant herite du gabarit serialise d'un Regi existant (tous les
champs moteur : Tactic, StatusEffects, CharStates, ActionEvents...). Seuls
espece, niveau, position, attaques, talent, stats et nom sont reecrits.
"""
from __future__ import annotations

import argparse
import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAPDIR = ROOT / "Data/Map"
GABARIT_SRC = ROOT / "Data/Map/cloven_ruins_regice.rsmap"

sys.path.insert(0, str(ROOT))
from tools.make_ruines_arenes import BIOMES  # noqa: E402


# ---------------------------------------------------------------------------
# CASTING
# ---------------------------------------------------------------------------
# Niveaux : releve de progression du ch5 fait en amont — faune 17-25,
# Regice 30, Regirock 32, Registeel 34, Regigigas 36, gardes 31. La courbe
# monte avec l'ordre canonique d'Aegis Cave (Glace, Roche, Acier, Puits).
#
# Attaques : mouvements reels des Regi dans Explorers of Sky, verifies
# presents dans le depot (le gabarit d'origine utilisait deja ice_beam,
# icy_wind, ancient_power, curse).
#
# 'ancre' dit OU poser le combattant :
#   'boss'      : la case du gardien, sur le choeur
#   'choeur'    : reparti sur le parvis, autour du gardien
#   'niche_g/d' : dans les creux lateraux
#   'garde'     : en quinconce dans la nef, entre le choeur et l'entree
# ---------------------------------------------------------------------------
CASTING = {
    "cloven_ruins_regice": [
        {
            "espece": "regice", "nom": "Regice", "niveau": 30, "genre": 3,
            "el": ("ice", "none"), "pv": 190, "talent": "clear_body",
            "objet": "held_power_band", "ancre": "boss",
            "attaques": ["ice_beam", "icy_wind", "ancient_power", "curse"],
        },
    ],
    "cloven_ruins_regirock": [
        {
            "espece": "regirock", "nom": "Regirock", "niveau": 32, "genre": 3,
            "el": ("rock", "none"), "pv": 205, "talent": "clear_body",
            "objet": "held_power_band", "ancre": "boss",
            "attaques": ["rock_slide", "stomp", "ancient_power", "curse"],
        },
    ],
    "cloven_ruins_registeel": [
        {
            "espece": "registeel", "nom": "Registeel", "niveau": 34, "genre": 3,
            "el": ("steel", "none"), "pv": 200, "talent": "clear_body",
            "objet": "held_power_band", "ancre": "boss",
            "attaques": ["iron_head", "flash_cannon", "ancient_power", "curse"],
        },
    ],
    "sanctuaire_titans": [
        {
            "espece": "regigigas", "nom": "Regigigas", "niveau": 36, "genre": 3,
            "el": ("normal", "none"), "pv": 260, "talent": "slow_start",
            "objet": "held_power_band", "ancre": "boss",
            "attaques": ["crush_grip", "stomp", "rock_slide", "confuse_ray"],
        },
        # Les huit gardes. Dans EoS, Regigigas ne combat jamais seul : quatre
        # Hitmonlee et quatre Bronzong l'encadrent. Ils portent enfin leur
        # propre nom.
        *[
            {
                "espece": "hitmonlee", "nom": "Kicklee", "niveau": 31, "genre": 1,
                "el": ("fighting", "none"), "pv": 120, "talent": "limber",
                "objet": "", "ancre": f"garde{i}",
                "attaques": ["jump_kick", "double_kick", "meditate", "endure"],
            }
            for i in range(4)
        ],
        *[
            {
                "espece": "bronzong", "nom": "Archeodong", "niveau": 31, "genre": 3,
                "el": ("steel", "psychic"), "pv": 130, "talent": "levitate",
                "objet": "", "ancre": f"garde{4 + i}",
                "attaques": ["confuse_ray", "gyro_ball", "extrasensory", "block"],
            }
            for i in range(4)
        ],
    ],
}


def positions(nom: str, cfg: dict, n: int) -> list:
    """Calcule les cases de spawn, relativement a la geometrie de la salle."""
    cx0, cy0, cx1, cy1 = cfg["choeur"]
    bx, by = cfg["boss"]
    ex, ey = cfg["entree"]
    (ngx, ngy), (ndx, ndy) = cfg["niches"]

    pos = [(bx, by)]
    if n == 1:
        return pos

    # Les huit gardes du Puits : deux rangs symetriques entre le choeur et
    # l'entree, en quinconce pour qu'aucun ne masque le boss depuis l'axe.
    milieu = (cy1 + ey) // 2
    gardes = [
        (cx0 + 1, cy1 + 2), (cx1 - 1, cy1 + 2),      # avancés, au pied du choeur
        (bx - 4, milieu), (bx + 4, milieu),          # au centre, écartés
        (ngx, ngy), (ndx, ndy),                      # dans les niches
        (bx - 3, milieu + 4), (bx + 3, milieu + 4),  # arrière-garde
    ]
    return pos + gardes[: n - 1]


def fabriquer(gabarit: dict, fiche: dict, loc: tuple) -> dict:
    p = copy.deepcopy(gabarit)
    x, y = loc
    p["CurrentForm"] = {
        "Species": fiche["espece"], "Form": 0,
        "Skin": "normal", "Gender": fiche["genre"],
    }
    p["Element1"], p["Element2"] = fiche["el"]
    p["Level"] = fiche["niveau"]
    p["HP"] = fiche["pv"]
    p["MaxHPBonus"] = 0
    p["Nickname"] = fiche["nom"]
    p["serializationLoc"] = {"X": x, "Y": y}
    p["serializationDir"] = 0  # Down : face a l'equipe qui arrive du sud

    p["Skills"] = [
        {"Element": {"SkillNum": s, "Charges": 10, "Enabled": True,
                     "Sealed": False}, "BackRef": i}
        for i, s in enumerate(fiche["attaques"])
    ]
    p["BaseSkills"] = [
        {"SkillNum": s, "Charges": 10} for s in fiche["attaques"]
    ]
    p["Intrinsics"] = [{"Element": {"ID": fiche["talent"]}, "BackRef": 0}]
    p["BaseIntrinsics"] = [fiche["talent"]]

    if fiche["objet"]:
        p["EquippedItem"] = {"ID": fiche["objet"], "Cursed": False,
                             "HiddenValue": "", "Amount": 0, "Price": 0}
    else:
        p["EquippedItem"] = {"ID": "", "Cursed": False,
                             "HiddenValue": "", "Amount": 0, "Price": 0}

    # Pas de recrutement pendant la scene : l'utilisateur veut les Regi
    # recrutables PLUS TARD. Un recrutement ici couperait l'apres-combat.
    p["Unrecruitable"] = True
    p["dead"] = False
    p["Absentee"] = False
    return p


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--only")
    args = ap.parse_args()

    src = json.loads(GABARIT_SRC.read_text(encoding="utf-8-sig"))
    # Le gabarit de combattant : on prend celui de l'ancienne carte si elle
    # portait encore une equipe, sinon celui archive dans le depot git.
    modele = None
    if src["Object"].get("MapTeams"):
        modele = src["Object"]["MapTeams"][0]["Players"][0]
    if modele is None:
        arch = Path("/tmp/old_regice.rsmap")
        if not arch.exists():
            print("ERREUR : aucun gabarit de combattant disponible.")
            print("  Rejouer : git show f788211:Data/Map/cloven_ruins_regice.rsmap"
                  " > /tmp/old_regice.rsmap")
            return 1
        modele = json.loads(
            arch.read_text(encoding="utf-8-sig")
        )["Object"]["MapTeams"][0]["Players"][0]

    echecs = 0
    for nom, fiches in CASTING.items():
        if args.only and args.only != nom:
            continue
        cfg = BIOMES[nom]
        dest = MAPDIR / f"{nom}.rsmap"
        doc = json.loads(dest.read_text(encoding="utf-8-sig"))
        o = doc["Object"]
        T = o["Tiles"]

        locs = positions(nom, cfg, len(fiches))
        joueurs, defauts = [], []
        vus = set()
        for fiche, loc in zip(fiches, locs):
            x, y = loc
            if not (0 <= x < len(T) and 0 <= y < len(T[0])):
                defauts.append(f"{fiche['nom']} hors carte ({x},{y})")
                continue
            if T[x][y]["Data"]["ID"] != "floor":
                defauts.append(f"{fiche['nom']} spawn dans un mur ({x},{y})")
                continue
            if loc in vus:
                defauts.append(f"{fiche['nom']} superpose a un autre ({x},{y})")
                continue
            vus.add(loc)
            joueurs.append(fabriquer(modele, fiche, loc))

        if defauts:
            echecs += 1
            print(f"ECHEC  {dest.name} — casting refuse")
            for d in defauts:
                print(f"         · {d}")
            continue

        o["MapTeams"] = [{
            "$type": "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
            "Players": joueurs,
            "Guests": [],
            "inventory": [],
            "Name": "",
            "LeaderIndex": 0,
            "FoeConflict": 0,
        }]
        dest.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
        noms = ", ".join(f"{f['nom']} n{f['niveau']}" for f in fiches[:3])
        suite = f" (+{len(fiches) - 3})" if len(fiches) > 3 else ""
        print(f"OK     {dest.name:34s} {len(joueurs)} combattant(s) : {noms}{suite}")

    return 1 if echecs else 0


if __name__ == "__main__":
    sys.exit(main())
