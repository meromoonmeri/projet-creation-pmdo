#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_index_master_zone.py — index de master_zone ecrits en dur qui ont derive.

LE DEFAUT, ET POURQUOI IL REVIENT
---------------------------------
master_zone.GroundMaps est un TABLEAU INDEXE. Beaucoup de scripts de zone
ciblent une carte de sortie par son numero :

    GAME:EnterZone("master_zone", -1, 60, 0)

Des qu'un ground est insere ailleurs dans la liste, tout ce qui suit se
decale d'un cran — et le numero pointe silencieusement sur une AUTRE carte.
Rien ne plante : le joueur est simplement depose au mauvais endroit, souvent
dans un donjon de plusieurs chapitres d'ecart, avec un drapeau de scene pose
pour une carte qu'il n'atteindra jamais.

Cas reels trouves dans ce depot (quatre vagues successives) :
    cloven_ruins      65 -> vast_steppe_midpoint
    vast_steppe       62 -> mount_windswept_guardian
    celestial_peak    46 -> vast_steppe_entrance
                      75 -> crystal_sanctuary_boss
    crooked_cavern    60 -> searing_tunnel_miniboss
    gloomy_forest     61 -> mount_windswept_miniboss
    crystal_sanctuary 46 -> vast_steppe_entrance
    forgotten_marsh   46 -> vast_steppe_entrance
                      73 -> celestial_peak_entrance

LE REMEDE, applique a chaque fois
---------------------------------
Un helper GROUND_IDX(nom) qui resout l'index PAR NOM a l'execution, avec
repli sur metano_town si le nom disparait. Il ne peut plus rederiver.

CE QUE FAIT CET OUTIL
---------------------
Pour chaque Data/Script/halcyon/zone/<z>/init.lua, il releve les index
ecrits en dur et affiche la carte reellement visee. Il SIGNALE quand la
cible n'appartient ni a la famille de la zone, ni a la liste blanche des
destinations legitimes (la ville, la guilde, le dojo pour les mazes, et la
zone suivante d'une progression d'expedition).

Il ne corrige rien : une cible « etrangere » peut etre voulue (la Steppe
enchaine sur le Tunnel). Il donne la matiere pour trancher a la main.
"""
from __future__ import annotations

import glob
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Destinations legitimes quelle que soit la zone appelante.
BLANCHE = {
    "metano_town", "metano_town_nuit",
    "guild_dining_room", "guild_second_floor", "guild_third_floor_lobby",
    "guild_heros_room",          # reveil apres KO
    "ledian_dojo",               # sortie de tous les mazes d'entrainement
    "luminous_spring",           # evolution
    "relic_forest", "altere_pond",  # prologue
}

# Enchainements d'expedition volontaires : zone -> cibles admises en plus.
PROGRESSION = {
    "vast_steppe": {"searing_tunnel_entrance"},
    "searing_tunnel": {"mount_windswept_entrance", "searing_crucible"},
    "mount_windswept": {"cloven_ruins_entrance"},
    "crooked_cavern": {"crooked_den"},
}


def strip_lua(src: str) -> str:
    src = re.sub(r"--\[\[.*?\]\]",
                 lambda m: "\n" * m.group(0).count("\n"), src, flags=re.S)
    return "\n".join(re.sub(r"--.*$", "", l) for l in src.split("\n"))


def main() -> int:
    mz = json.loads(
        (ROOT / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig")
    )["Object"]["GroundMaps"]

    print("=" * 78)
    print(" INDEX master_zone ECRITS EN DUR — ont-ils derive ?")
    print("=" * 78)
    print(f"\n  master_zone : {len(mz)} grounds (index 0..{len(mz)-1})\n")

    suspects, total, par_nom = [], 0, 0
    for f in sorted(glob.glob(str(ROOT / "Data/Script/halcyon/zone/*/init.lua"))):
        z = Path(f).parent.name
        src = strip_lua(Path(f).read_text(encoding="utf-8", errors="ignore"))
        par_nom += src.count("GROUND_IDX(")
        vus = {}
        for l in src.split("\n"):
            for m in re.findall(
                r'"master_zone"\s*,\s*-?\d+\s*,\s*(\d+)', l
            ):
                vus[int(m)] = vus.get(int(m), 0) + 1
        for idx, n in sorted(vus.items()):
            total += n
            if idx >= len(mz):
                suspects.append((z, idx, "<HORS BORNES>", n))
                continue
            cible = mz[idx]
            famille = z.split("_")[0]
            ok = (famille in cible
                  or cible in BLANCHE
                  or cible in PROGRESSION.get(z, set()))
            if not ok:
                suspects.append((z, idx, cible, n))

    if suspects:
        print(f"### CIBLES SUSPECTES : {len(suspects)}")
        print("    (l'index vise une carte etrangere a la zone appelante)\n")
        for z, idx, cible, n in suspects:
            print(f"  {z:24s} idx {idx:3d} x{n:<2d} -> {cible}")
        print("\n    A verifier a la main : certaines peuvent etre voulues.")
        print("    Sinon, remplacer par GROUND_IDX('<nom_du_ground>').")
    else:
        print("  aucune cible suspecte")

    print(f"\n  {total} index en dur restants, "
          f"{par_nom} resolutions par nom (GROUND_IDX)")
    print("\n" + "=" * 78)
    print(f" {len(suspects)} SUSPECT(S)" if suspects
          else " AUCUN INDEX SUSPECT")
    print("=" * 78)
    return 1 if suspects else 0


if __name__ == "__main__":
    sys.exit(main())
