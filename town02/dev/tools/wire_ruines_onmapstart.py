#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
wire_ruines_onmapstart.py — branche l'eveil des gardiens sur les etages-arenes.

La cinematique d'eveil ne se joue plus sur un ground : elle se joue DANS
l'etage, au moment ou la carte demarre. Le moteur offre pour cela le crochet
OnMapStarts d'un ActiveEffect, pose par un MapEffectStep dans les GenSteps du
plancher.

PATRON DE REFERENCE (atteste, Data/Zone/beginner_lesson.json) :

    { "Key": {"str":[0]},
      "Value": { "$type": "RogueEssence.LevelGen.MapEffectStep`1[[
                            RogueEssence.LevelGen.MapLoadContext,
                            RogueEssence]], RogueEssence",
                 "Effect": { ... "OnMapStarts": [
                    { "Key": {"str":[0]},
                      "Value": { "$type": "RogueEssence.Dungeon.
                                           SingleCharScriptEvent, RogueEssence",
                                 "Script": "BeginnerLessonSpeech",
                                 "ArgTable": "{ Speech = 1}" }}]}}}

On reproduit exactement cette forme, avec Script = RuinesArenesEveil et
ArgTable portant le numero de segment. Le segment est passe explicitement
plutot que devine a l'execution : plus lisible dans les logs, et robuste si
_ZONE.CurrentMapID.Segment n'est pas encore a jour au demarrage de la carte.

Les arenes sont des LayeredSegment / LoadGen : leur MapEffectStep prend un
MapLoadContext (et non un MapGenContext, reserve aux etages procéduraux).
C'est la difference que beginner_lesson documente et qu'il faut respecter,
sinon le moteur refuse de deserialiser l'etape.
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

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ZONE = ROOT / "Data/Zone/cloven_ruins.json"

# segment -> nom lisible, pour le rapport
ARENES = {1: "Regice", 3: "Regirock", 5: "Registeel", 7: "Regigigas"}

SCRIPT = "RuinesArenesEveil"

EFFET_VIDE = {
    "UniversalStates": [], "BeforeTryActions": [], "BeforeActions": [],
    "OnActions": [], "BeforeExplosions": [], "BeforeHits": [], "OnHits": [],
    "OnHitTiles": [], "AfterActions": [], "ElementEffects": [], "OnEquips": [],
    "OnPickups": [], "BeforeStatusAdds": [], "OnStatusAdds": [],
    "OnStatusRemoves": [], "OnMapStatusAdds": [], "OnMapStatusRemoves": [],
    "OnMapStarts": [], "OnTurnStarts": [], "OnTurnEnds": [], "OnMapTurnEnds": [],
    "OnWalks": [], "OnDeaths": [], "OnRefresh": [], "OnMapRefresh": [],
    "ModifyHPs": [], "RestoreHPs": [],
}


def etape(segment: int) -> dict:
    effet = json.loads(json.dumps(EFFET_VIDE))
    effet["OnMapStarts"] = [{
        "Key": {"str": [0]},
        "Value": {
            "$type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
            "Script": SCRIPT,
            "ArgTable": "{ Segment = %d }" % segment,
        },
    }]
    return {
        "Key": {"str": [0]},
        "Value": {
            "$type": (
                "RogueEssence.LevelGen.MapEffectStep`1"
                "[[RogueEssence.LevelGen.MapLoadContext, RogueEssence]], "
                "RogueEssence"
            ),
            "Effect": effet,
        },
    }


def main() -> int:
    doc = json.loads(ZONE.read_text(encoding="utf-8-sig"))
    segments = doc["Object"]["Segments"]
    modifies = 0

    for seg, nom in ARENES.items():
        if seg >= len(segments):
            print(f"ECHEC  segment {seg} absent de la zone")
            return 1
        s = segments[seg]
        planchers = s.get("Floors")
        if not isinstance(planchers, list) or not planchers:
            print(f"ECHEC  segment {seg} ({nom}) n'est pas un LayeredSegment")
            return 1

        etapes = planchers[0].setdefault("GenSteps", [])
        # Idempotence : on retire un eventuel branchement precedent avant
        # d'ajouter, pour que rejouer le script ne cree pas de doublon (qui
        # ferait jouer la scene deux fois).
        avant = len(etapes)
        etapes[:] = [
            e for e in etapes
            if json.dumps(e).find(SCRIPT) < 0
        ]
        retires = avant - len(etapes)
        etapes.append(etape(seg))
        modifies += 1
        suffixe = f" (remplace {retires} branchement)" if retires else ""
        print(f"OK     segment {seg} ({nom}) -> {SCRIPT}"
              f" ArgTable Segment={seg}{suffixe}")

    ZONE.write_text(
        json.dumps(doc, ensure_ascii=False, indent=1), encoding="utf-8"
    )
    print(f"\n{modifies} segment(s) branche(s) dans {ZONE.name}")

    # Relecture : le fichier doit rester deserialisable.
    json.loads(ZONE.read_text(encoding="utf-8-sig"))
    print("OK     le JSON de zone se relit sans erreur")
    return 0


if __name__ == "__main__":
    sys.exit(main())
