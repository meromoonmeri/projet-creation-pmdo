#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
drop_ruines_grounds.py — retire les grounds de boss des Aegis Cave.

Demande explicite : « pas de ground », les cinematiques se jouent sur les
etages-arenes de la zone. Quatre grounds n'ont donc plus lieu d'exister :

  cloven_ruins_regice     cinematique d'eveil de Regice     (ajoutee au lot 3)
  cloven_ruins_regirock   idem Regirock                     (ajoutee au lot 3)
  cloven_ruins_registeel  idem Registeel                    (ajoutee au lot 3)
  cloven_ruins_boss       arene Regigigas, ground preexistant

Pour chacun on retire :
  1. Data/Ground/<nom>.rsground
  2. Data/Script/halcyon/ground/<nom>/         (init.lua, scenes, strings)
  3. l'entree dans la liste Grounds de Data/Zone/master_zone.json

DANGER MESURE, ET POURQUOI ON NE SUPPRIME PAS TOUTES LES ENTREES
----------------------------------------------------------------
master_zone.GroundMaps est un tableau INDEXE, et une bonne partie du depot
cible encore des cartes par un index ECRIT EN DUR. Releve effectif :

  cloven_ruins_boss est a l'index 70 ;
  26 appels du type EnterZone("master_zone", -1, N, 0) visent N >= 71
  (N=71 crystal_sanctuary_entrance, 73 celestial_peak_entrance,
   75 crystal_sanctuary_boss).

Retirer l'entree 70 decalerait ces 117 cartes d'un cran : zone/celestial_peak
deposerait le joueur devant l'arene du Sanctuaire de Cristal, et ainsi de
suite. C'est exactement la classe de bug deja corrigee deux fois dans ce
depot (cf. l'entete de zone/cloven_ruins/init.lua).

On distingue donc deux cas :

  * les trois grounds AJOUTES en fin de liste (indices 185-187) : personne ne
    peut les cibler par index puisqu'ils sont les derniers. On les retire
    vraiment, aucun decalage.

  * cloven_ruins_boss (index 70, au milieu) : le fichier .rsground et ses
    scripts sont supprimes, mais l'ENTREE DU TABLEAU EST CONSERVEE pour ne
    rien decaler. Elle devient une place morte, que plus aucun script ne
    cible. C'est un compromis assume : nettoyer l'index demanderait de
    convertir les 26 appels en dur en resolution par nom, ce qui deborde
    largement du perimetre demande et risquerait des regressions dans quatre
    autres donjons.

Le script verifie apres coup qu'aucun ground restant n'a change d'index.

Les textes de ces grounds ont deja ete portes vers Strings/stringsEx*.resx
(tools/port_ruines_strings.py) : leur suppression ne perd aucune replique.
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

import argparse
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MASTER = ROOT / "Data/Zone/master_zone.json"

# nom -> retirer aussi l'entree de master_zone.GroundMaps ?
CIBLES = {
    "cloven_ruins_regice": True,     # index 185, en fin de liste : sans risque
    "cloven_ruins_regirock": True,   # index 186
    "cloven_ruins_registeel": True,  # index 187
    "cloven_ruins_boss": False,      # index 70 : entree gardee (voir entete)
}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    doc = json.loads(MASTER.read_text(encoding="utf-8-sig"))
    grounds = doc["Object"]["GroundMaps"]

    # Photo AVANT : nom -> index, pour mesurer les decalages.
    avant = {n: i for i, n in enumerate(grounds)}

    for nom, retirer_entree in CIBLES.items():
        rsg = ROOT / f"Data/Ground/{nom}.rsground"
        scr = ROOT / f"Data/Script/halcyon/ground/{nom}"

        if rsg.exists():
            print(f"{'[dry] ' if args.dry_run else ''}rm   {rsg.relative_to(ROOT)}")
            if not args.dry_run:
                rsg.unlink()
        else:
            print(f"      (absent) {rsg.relative_to(ROOT)}")

        if scr.exists():
            n = len(list(scr.rglob("*")))
            print(f"{'[dry] ' if args.dry_run else ''}rm   "
                  f"{scr.relative_to(ROOT)}/  ({n} fichier(s))")
            if not args.dry_run:
                shutil.rmtree(scr)
        else:
            print(f"      (absent) {scr.relative_to(ROOT)}/")

        if nom in grounds:
            idx = grounds.index(nom)
            if retirer_entree:
                print(f"{'[dry] ' if args.dry_run else ''}del  "
                      f"master_zone.GroundMaps[{idx}] = {nom}")
                if not args.dry_run:
                    grounds.remove(nom)
            else:
                print(f"      GARDE master_zone.GroundMaps[{idx}] = {nom} "
                      f"(place morte : la retirer decalerait 117 cartes)")

    if args.dry_run:
        return 0

    MASTER.write_text(
        json.dumps(doc, ensure_ascii=False, indent=1), encoding="utf-8"
    )
    print(f"\nmaster_zone : {len(avant)} -> {len(grounds)} grounds")

    # Controle des decalages d'index.
    apres = {n: i for i, n in enumerate(grounds)}
    bouges = [
        (n, avant[n], apres[n])
        for n in apres if avant.get(n) != apres[n]
    ]
    if bouges:
        print(f"\nATTENTION : {len(bouges)} ground(s) ont change d'index.")
        print("  Tout script qui les cible par un index ECRIT EN DUR est a")
        print("  reverifier. Les Ruines passent par GROUND_IDX (resolution")
        print("  par nom) et ne sont donc pas concernees.")
        for n, a, b in bouges[:6]:
            print(f"    {n}: {a} -> {b}")
        if len(bouges) > 6:
            print(f"    ... et {len(bouges) - 6} autre(s)")
    else:
        print("Aucun ground restant n'a change d'index.")

    json.loads(MASTER.read_text(encoding="utf-8-sig"))
    print("OK    master_zone.json se relit sans erreur")
    return 0


if __name__ == "__main__":
    sys.exit(main())
