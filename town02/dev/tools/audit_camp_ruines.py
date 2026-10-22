#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_camp_ruines.py — collisions et coherence de mise en scene du camp.

Verifie, sur le ground cloven_ruins_entrance ET sur le script de la scene
du chapitre 5, tout ce qui peut faire qu'un personnage se retrouve DANS un
mur, SUR quelqu'un d'autre, ou tourne dans une direction absurde.

CE QUI EST CONTROLE
-------------------
1. SOLIDE      chaque position citee par le script tombe-t-elle sur une
               case marchable de la grille de collision ?
2. CHEVAUCHEMENT   deux personnages occupent-ils la meme case, ou des cases
               trop proches pour que leurs sprites ne se recouvrent pas ?
3. TRAJET      un deplacement MoveToPosition traverse-t-il un obstacle ?
4. ORIENTATION un personnage qui « regarde » quelqu'un est-il tourne dans
               la bonne direction geometrique ?
5. TRAVERSEE   un personnage marche-t-il A TRAVERS un autre personnage
               deja pose sur la carte ?

FORMAT DE LA GRILLE (mesure sur le fichier)
-------------------------------------------
obstacles est une grille [x][y] de 72x51 cellules. Chaque cellule porte
Tags : 1 = bloquant, 0 = libre. TexSize = 1, et la carte fait 576x408 px
pour 72x51 cellules, donc UNE CELLULE = 8 PIXELS.
Un personnage occupe environ 16x16 px, soit 2x2 cellules, ancre sur sa
position (le sprite est centre en X, pose par le bas en Y dans le moteur —
on prend une marge symetrique, ce qui est le cas defavorable).
"""
from __future__ import annotations

import json
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GROUND = ROOT / "Data/Ground/cloven_ruins_entrance.rsground"
SCENE = ROOT / "Data/Script/halcyon/ground/cloven_ruins_entrance/cloven_ruins_entrance_ch_5.lua"

CELL = 8          # pixels par cellule d'obstacle
RAYON = 8         # demi-largeur du sprite, en pixels
ECART_MIN = 20    # px : en deca, deux sprites se recouvrent visiblement


def charger_grille():
    o = json.loads(GROUND.read_text(encoding="utf-8-sig"))["Object"]
    ob = o["obstacles"]
    W, H = len(ob), len(ob[0])
    bloc = [[ob[x][y]["Tags"] == 1 for y in range(H)] for x in range(W)]
    return bloc, W, H


def libre(bloc, W, H, px, py, rayon=RAYON):
    """Le sprite tient-il entierement sur des cases marchables ?"""
    x0, x1 = (px - rayon) // CELL, (px + rayon - 1) // CELL
    y0, y1 = (py - rayon) // CELL, (py + rayon - 1) // CELL
    for cx in range(x0, x1 + 1):
        for cy in range(y0, y1 + 1):
            if not (0 <= cx < W and 0 <= cy < H):
                return False
            if bloc[cx][cy]:
                return False
    return True


def trajet_libre(bloc, W, H, a, b, pas=4):
    """Echantillonne le segment a->b ; rend la 1re position bloquee."""
    dx, dy = b[0] - a[0], b[1] - a[1]
    n = max(1, int(math.hypot(dx, dy) // pas))
    for i in range(n + 1):
        px = int(a[0] + dx * i / n)
        py = int(a[1] + dy * i / n)
        if not libre(bloc, W, H, px, py):
            return (px, py)
    return None


def lire_tables(src: str) -> dict:
    """Extrait PLACES, LITS et ARR du script."""
    out = {}
    for nom in ("PLACES", "LITS"):
        m = re.search(r"local %s = \{(.*?)\n\}" % nom, src, re.S)
        if not m:
            continue
        out[nom] = {
            k: (int(x), int(y))
            for k, x, y in re.findall(
                r"(\w+)\s*=\s*\{(-?\d+),\s*(-?\d+)\}", m.group(1)
            )
        }
    m = re.search(r"local ARR = \{(.*?)\n\}", src, re.S)
    if m:
        arr = {}
        for k, dx, dy, ax, ay in re.findall(
            r"(\w+)\s*=\s*\{ depart = \{(-?\d+), (-?\d+)\},\s*"
            r"attente = \{(-?\d+), (-?\d+)\} \}", m.group(1)
        ):
            arr[k] = {"depart": (int(dx), int(dy)),
                      "attente": (int(ax), int(ay))}
        out["ARR"] = arr
    return out


def main() -> int:
    bloc, W, H = charger_grille()
    src = SCENE.read_text(encoding="utf-8")
    tables = lire_tables(src)
    pbs = []

    print("=" * 78)
    print(" AUDIT DU CAMP DES RUINES — collisions, positions, orientations")
    print("=" * 78)
    print(f"\n  grille {W}x{H} cellules de {CELL} px "
          f"({W * CELL}x{H * CELL} px)")
    marchables = sum(1 for x in range(W) for y in range(H) if not bloc[x][y])
    print(f"  {marchables}/{W * H} cellules marchables "
          f"({100 * marchables // (W * H)} %)\n")

    # --- 1. positions des tables ------------------------------------------
    for nom in ("PLACES", "LITS", "ARR"):
        t = tables.get(nom)
        if not t:
            continue
        print(f"--- {nom} ---")
        for qui, v in sorted(t.items()):
            points = ([("", v)] if isinstance(v, tuple)
                      else [(f".{k}", p) for k, p in v.items()])
            for suffixe, p in points:
                if not libre(bloc, W, H, p[0], p[1]):
                    pbs.append(f"{nom}.{qui}{suffixe} {p} est DANS un obstacle")
                    print(f"  X  {qui}{suffixe:9s} {str(p):12s} DANS UN OBSTACLE")
        print(f"     {len(t)} entree(s) verifiee(s)")

    # --- 2. chevauchements deux a deux ------------------------------------
    print("\n--- CHEVAUCHEMENTS ---")
    for nom in ("PLACES", "LITS"):
        t = tables.get(nom)
        if not t:
            continue
        noms = sorted(t)
        for i in range(len(noms)):
            for j in range(i + 1, len(noms)):
                a, b = t[noms[i]], t[noms[j]]
                d = math.hypot(a[0] - b[0], a[1] - b[1])
                if d < ECART_MIN:
                    pbs.append(f"{nom}: {noms[i]} et {noms[j]} a {d:.0f} px")
                    print(f"  X  {nom}: {noms[i]} / {noms[j]} "
                          f"-> {d:.0f} px (mini {ECART_MIN})")
    arr = tables.get("ARR", {})
    att = {k: v["attente"] for k, v in arr.items()}
    noms = sorted(att)
    for i in range(len(noms)):
        for j in range(i + 1, len(noms)):
            a, b = att[noms[i]], att[noms[j]]
            d = math.hypot(a[0] - b[0], a[1] - b[1])
            if d < ECART_MIN:
                pbs.append(f"ARR: {noms[i]} et {noms[j]} a {d:.0f} px")
                print(f"  X  ARR: {noms[i]} / {noms[j]} -> {d:.0f} px")
    print("     ok" if not pbs else "")

    # --- 3. trajets d'arrivee ---------------------------------------------
    print("\n--- TRAJETS D'ARRIVEE (depart -> attente) ---")
    for qui, v in sorted(arr.items()):
        stop = trajet_libre(bloc, W, H, v["depart"], v["attente"])
        if stop:
            pbs.append(f"trajet {qui} bloque en {stop}")
            print(f"  X  {qui:10s} {v['depart']} -> {v['attente']} "
                  f"bloque en {stop}")
    print(f"     {len(arr)} trajet(s) verifie(s)")

    # --- 4. deplacements ecrits en dur dans le script ---------------------
    print("\n--- DEPLACEMENTS ET TELEPORTATIONS EN DUR ---")
    durs = []
    for m in re.finditer(
        r"GROUND:(MoveToPosition|TeleportTo)\((\w+),\s*(-?\d+),\s*(-?\d+)", src
    ):
        durs.append((m.group(1), m.group(2), int(m.group(3)), int(m.group(4)),
                     src[:m.start()].count("\n") + 1))
    for typ, qui, x, y, ligne in durs:
        if not libre(bloc, W, H, x, y):
            pbs.append(f"{typ}({qui}) ligne {ligne} vise ({x},{y}) bloque")
            print(f"  X  l.{ligne:5d} {typ}({qui}) -> ({x},{y}) DANS UN OBSTACLE")
    print(f"     {len(durs)} appel(s) verifie(s)")

    # --- 5. Plum doit etre DEVANT le groupe, pas derriere -----------------
    # Le duo entre par l'ouest (x ~24) et marche vers l'est. « Devant » veut
    # donc dire : a l'est du point ou le duo s'arrete. Une Plum posee a
    # l'ouest de cet arret serait DEPASSEE pendant la marche, puis vue de dos.
    #
    # ATTENTION : pendant les actes 1 a 5, Plum n'est PAS a PLACES.Plum (sa
    # place au diner, occupee seulement a l'acte 6) mais a PLUM_ACCUEIL.
    # Lire la mauvaise table donnait un faux positif permanent.
    print("\n--- PLUM : placement et orientation ---")
    m = re.search(r"local PLUM_ACCUEIL = \{(-?\d+), (-?\d+)\}", src)
    plum = (int(m.group(1)), int(m.group(2))) if m else None
    xs = [int(x) for x in
          re.findall(r"GROUND:MoveToPosition\(hero, (-?\d+),", src)]
    arret = (max(xs) if xs else 0)
    if plum is None:
        pbs.append("PLUM_ACCUEIL introuvable dans le script")
        print("  X  PLUM_ACCUEIL introuvable")
    else:
        if not libre(bloc, W, H, plum[0], plum[1]):
            pbs.append(f"PLUM_ACCUEIL {plum} est dans un obstacle")
            print(f"  X  PLUM_ACCUEIL {plum} DANS UN OBSTACLE")
        print(f"     le duo s'arrete a x={arret}, Plum attend a x={plum[0]}")
        if plum[0] <= arret:
            pbs.append(f"Plum (x={plum[0]}) est derriere l'arret (x={arret})")
            print("  X  Plum est DERRIERE le groupe")
        else:
            print(f"     ok : Plum est a l'est de l'arret (+{plum[0]-arret} px)")
        # Elle est a l'est : pour faire face au duo elle doit regarder Left.
        m2 = re.search(r"'Jigglypuff', PLUM_ACCUEIL\[1\], PLUM_ACCUEIL\[2\],"
                       r" Direction\.(\w+)", src)
        if m2:
            print(f"     orientation d'apparition : {m2.group(1)} (attendu Left)")
            if m2.group(1) != "Left":
                pbs.append(f"Plum apparait tournee {m2.group(1)}, attendu Left")
                print("  X  elle n'est pas tournee vers le duo")

    # --- 6. traversee de personnages pendant les arrivees -----------------
    # Chaque arrivant marche en LIGNE DROITE de depart vers attente. Il ne
    # doit croiser ni Plum, ni le duo arrete, ni personne DEJA arrive.
    # (L'ordre d'arrivee est celui de l'acte 4 : on ne compare qu'aux
    # precedents, pas a tout le monde.)
    print("\n--- TRAVERSEE DE PERSONNAGES (ordre d'arrivee reel) ---")
    ordre = ["Phileas", "Penticus", "Rin", "Coco", "Hyko", "Almotz",
             "Ganlon", "Shuca", "Kino", "Reinier"]
    poses = {}
    if plum:
        poses["Plum"] = plum
    if xs:
        poses["hero"] = (arret, 200)
        poses["partner"] = (arret, 224)
    for qui in ordre:
        v = arr.get(qui)
        if v is None:
            continue
        a, b = v["depart"], v["attente"]
        for autre, p in poses.items():
            dx, dy = b[0] - a[0], b[1] - a[1]
            L2 = dx * dx + dy * dy
            if L2 == 0:
                continue
            t = max(0, min(1, ((p[0]-a[0])*dx + (p[1]-a[1])*dy) / L2))
            d = math.hypot(p[0]-(a[0]+t*dx), p[1]-(a[1]+t*dy))
            if d < ECART_MIN and 0.05 < t < 0.95:
                pbs.append(f"{qui} traverse {autre} ({d:.0f} px)")
                print(f"  X  {qui:9s} passe a {d:3.0f} px de {autre} en {p}")
            elif math.hypot(b[0]-p[0], b[1]-p[1]) < ECART_MIN:
                pbs.append(f"{qui} s'arrete sur {autre}")
                print(f"  X  {qui:9s} s'arrete a "
                      f"{math.hypot(b[0]-p[0], b[1]-p[1]):.0f} px de {autre}")
        poses[qui] = b
    print(f"     {len(ordre)} arrivee(s) verifiee(s) dans l'ordre du script")

    print("\n" + "=" * 78)
    if pbs:
        print(f" {len(pbs)} PROBLEME(S)")
    else:
        print(" AUCUN PROBLEME DE COLLISION")
    print("=" * 78)
    return 1 if pbs else 0


if __name__ == "__main__":
    sys.exit(main())
