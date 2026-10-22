#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
wire_ruines_bataille.py — pose le protocole d'arene sur les quatre etages.

CE QUI MANQUAIT
---------------
Les cartes generees par make_ruines_arenes.py etaient des salles avec des
ennemis dedans, mais PAS des arenes de boss. Il leur manquait le MapEffect
que toutes les arenes du mod portent (releve sur Data/Map/*_arene.rsmap) :

  OnMapStarts[-15]  PMDC.Dungeon.BattlePositionEvent
                    Place l'equipe en formation a l'entree, face au boss,
                    au lieu de la laisser au point de spawn brut.

  OnMapStarts[-5]   SingleCharScriptEvent LuaBeginBattleEvent
                    Active le mode Equipe et installe le verrou de victoire :
                    tant qu'un ennemi vit, le segment ne se termine pas.
                    Son parametre CustomClearEvent designe le script appele
                    quand le dernier ennemi tombe.

  OnMapStarts[0]    SingleCharScriptEvent ResetTurnCounter
  OnMapTurnEnds[0]  SingleCharScriptEvent IncrementTurnCounter

Sans LuaBeginBattleEvent, tuer le boss ne cloturait rien : le joueur restait
sur une carte vide a chercher un escalier qui n'existe pas.

LE POINT DELICAT : QUAND JOUER L'APRES-COMBAT
---------------------------------------------
LuaCheckBossClearEvent (event_single.lua:1735) fait, dans l'ordre : attendre
40 frames, couper la BGM, fondu au noir, puis EndSegment. Si on jouait la
scene de victoire APRES, elle se jouerait sur un ecran noir, hors du donjon.

On passe donc par CustomClearEvent : un script maison qui joue la scene
D'ABORD, sur la carte encore visible, avec le corps du gardien encore en
place — puis delegue la cloture au comportement standard. C'est exactement
l'usage prevu par LuaBeginBattleEvent, et c'est ce que fait deja LavaBossClear
pour le boss du Tunnel (event_single.lua:1801).

OnMapStarts[-5] passe donc :
    { CustomClearEvent = 'RuinesArenesClear', Segment = N }
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAPDIR = ROOT / "Data/Map"

sys.path.insert(0, str(ROOT))
from tools.make_ruines_arenes import BIOMES  # noqa: E402

CLEAR = "RuinesArenesClear"


def battle_position() -> dict:
    """Formation d'entree, relative au point d'apparition.

    Valeurs reprises telles quelles des arenes existantes du mod : deux rangs
    de deux, tournes vers le haut (Dir 4), donc face au choeur.
    """
    locs = [(0, 0), (-2, 0), (0, -1), (-2, -1)]
    return {
        "Key": {"str": [-15]},
        "Value": {
            "$type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
            "StartLocs": [
                {"Loc": {"X": x, "Y": y}, "Dir": 4} for x, y in locs
            ],
            "Positions": [{"X": x, "Y": y} for x, y in locs],
        },
    }


def script_event(prio: int, nom: str, args: str = "{}") -> dict:
    return {
        "Key": {"str": [prio]},
        "Value": {
            "$type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
            "Script": nom,
            "ArgTable": args,
        },
    }


def main() -> int:
    for nom, cfg in BIOMES.items():
        seg = cfg["seg"]
        dest = MAPDIR / f"{nom}.rsmap"
        doc = json.loads(dest.read_text(encoding="utf-8-sig"))
        o = doc["Object"]
        me = o.setdefault("MapEffect", {})

        me["OnMapStarts"] = [
            battle_position(),
            script_event(
                -5, "LuaBeginBattleEvent",
                "{ CustomClearEvent = '%s', Segment = %d }" % (CLEAR, seg),
            ),
            script_event(0, "ResetTurnCounter"),
        ]
        me["OnMapTurnEnds"] = [script_event(0, "IncrementTurnCounter")]

        # Une arene de boss ne se quitte pas par un escalier et ne tolere pas
        # qu'on aille chercher du renfort au milieu du combat.
        o["NoRescue"] = True
        o["NoSwitching"] = False

        dest.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
        print(f"OK     {dest.name:34s} segment {seg} — "
              f"BattlePosition + LuaBeginBattleEvent({CLEAR}) + compteurs")

    print("\nProtocole d'arene pose sur 4 cartes.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
