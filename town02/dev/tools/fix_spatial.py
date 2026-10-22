#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Replace les entites qui ignorent le relief, sans toucher au decor.

Perimetre volontairement etroit
-------------------------------
On ne corrige QUE des entites qui representent un personnage ou une cible
de teleportation : MapChars, Spawners, Markers.

Les GroundObjects sont EXCLUS par principe. Un arbre, une tente, une
barriere sont poses exactement sur les cases bloquantes : l'objet EST le
mur. Les "corriger" reviendrait a arracher le decor. Sur les 112 entites
entierement murees relevees par audit_spatial, 94 sont des GroundObjects,
donc des faux positifs.

Deux defauts traites :
  - hors carte : coordonnee negative ou au-dela des bornes ;
  - muree      : toutes les cases du collider sont bloquantes (Tags == 1).

Une entite seulement PARTIELLEMENT en contact avec un mur n'est pas
touchee : le moteur applique SlideResponse et la fait glisser, ce qui est
un comportement normal, pas un bug.

Regle de relogement
-------------------
On cherche la case libre la plus proche, en distance euclidienne, ET
appartenant a la poche de reference (celle du marqueur d'entree). Ce
second critere est le point important : deplacer une entite sur une case
libre mais dans une poche fermee la rendrait inatteignable — on
remplacerait un bug visible par un bug invisible.
"""
import json
import pathlib
import sys
from math import hypot

sys.path.insert(0, str(pathlib.Path(__file__).parent))
from audit_spatial import (charger, grille, cases_couvertes, poches,
                           TEX, NOMS_ENTREE)

CATS = ('MapChars', 'Spawners', 'Markers')


def poche_reference(obj, bloque, W, H, lab, tailles):
    """Poche ou le joueur arrive. A defaut, la plus vaste."""
    for couche in obj.get('Entities', []):
        for cat in CATS:
            for e in couche.get(cat, []) or []:
                if e.get('EntName') not in NOMS_ENTREE:
                    continue
                c = e.get('Collider') or {}
                for cx, cy in cases_couvertes(c.get('X', 0), c.get('Y', 0),
                                              c.get('Width', TEX),
                                              c.get('Height', TEX), W, H):
                    if not bloque[cx][cy]:
                        return lab[cx][cy]
    return tailles.index(max(tailles)) if tailles else None


def case_libre_proche(bloque, lab, W, H, ref, cx, cy, w, h):
    """Case libre la plus proche, dans la poche de reference.

    On verifie que le collider ENTIER tient sur des cases libres, pas
    seulement son coin haut-gauche : une entite 30x30 couvre 16 cases.
    """
    nw = max(1, (w + TEX - 1) // TEX)
    nh = max(1, (h + TEX - 1) // TEX)
    best = None
    for x in range(W - nw + 1):
        for y in range(H - nh + 1):
            if bloque[x][y] or (ref is not None and lab[x][y] != ref):
                continue
            libre = True
            for dx in range(nw):
                for dy in range(nh):
                    if bloque[x + dx][y + dy]:
                        libre = False
                        break
                if not libre:
                    break
            if not libre:
                continue
            d = hypot(x - cx, y - cy)
            if best is None or d < best[0]:
                best = (d, x, y)
    return best


def style_serialisation(octets, doc):
    """Retrouve l'indentation exacte du fichier d'origine.

    Les .rsground du depot n'ont pas tous ete ecrits par la meme version
    de l'editeur : on mesure 181 fichiers en indent=1, 69 en indent=0,
    14 en indent=2 et 12 non reproductibles. Reserialiser avec un style
    impose reecrirait le fichier entier et noierait la correction dans un
    diff de plusieurs milliers de lignes. On rend donc a chaque fichier
    son propre style, et on refuse d'ecrire si aucun ne colle.
    """
    for ind in (1, 0, 2, 4, None):
        sep = (', ', ': ') if ind is None else (',', ': ')
        cand = '\ufeff' + json.dumps(doc, ensure_ascii=False,
                                     indent=ind, separators=sep)
        if cand.encode('utf-8') == octets:
            return ind, sep
    return None, None


def traiter(chemin, appliquer=False):
    octets = pathlib.Path(chemin).read_bytes()
    doc = json.loads(octets.decode('utf-8-sig'))
    obj = doc['Object']
    bloque, W, H = grille(obj)
    if not any(any(col) for col in bloque):
        return []                      # grille vide : rien a aligner
    lab, tailles = poches(bloque, W, H)
    ref = poche_reference(obj, bloque, W, H, lab, tailles)

    modifs = []
    for couche in obj.get('Entities', []):
        for cat in CATS:
            for e in couche.get(cat, []) or []:
                c = e.get('Collider')
                if not c:
                    continue
                x, y = c.get('X', 0), c.get('Y', 0)
                w, h = c.get('Width', TEX), c.get('Height', TEX)
                nom = e.get('EntName', '?')

                hors = not (0 <= x < W * TEX and 0 <= y < H * TEX)
                if hors:
                    motif = 'hors carte'
                else:
                    cs = list(cases_couvertes(x, y, w, h, W, H))
                    if not cs or not all(bloque[a][b] for a, b in cs):
                        continue       # libre, ou glissement normal
                    motif = 'muree'

                cx = min(max(x // TEX, 0), W - 1)
                cy = min(max(y // TEX, 0), H - 1)
                trouve = case_libre_proche(bloque, lab, W, H, ref, cx, cy, w, h)
                if not trouve:
                    modifs.append((nom, cat, (x, y), None, motif + ' / SANS SOLUTION'))
                    continue
                _, nx, ny = trouve
                px, py = nx * TEX, ny * TEX
                modifs.append((nom, cat, (x, y), (px, py), motif))
                if appliquer:
                    c['X'], c['Y'] = px, py

    if appliquer and any(m[3] for m in modifs):
        # On repart des octets AVANT modification pour identifier le style,
        # puis on reecrit avec ce meme style : seul le couple X//Y bouge.
        avant = json.loads(octets.decode('utf-8-sig'))
        ind, sep = style_serialisation(octets, avant)
        if ind is None and sep is None:
            print(f"   !! {chemin} : style de serialisation non reproductible,"
                  f" fichier NON modifie")
            return [(n, c, a, None, m + ' / STYLE INCONNU')
                    for n, c, a, p, m in modifs]
        pathlib.Path(chemin).write_bytes(
            ('\ufeff' + json.dumps(doc, ensure_ascii=False,
                                   indent=ind, separators=sep)).encode('utf-8'))
    return modifs


def main():
    appliquer = '--appliquer' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    racine = pathlib.Path(args[0]) if args else pathlib.Path('.')
    cibles = sorted((racine / 'Data' / 'Ground').glob('*.rsground'))

    total = 0
    echecs = 0
    for c in cibles:
        m = traiter(c, appliquer)
        if not m:
            continue
        print(f"\n{c.stem}")
        for nom, cat, av, ap, motif in m:
            if ap is None:
                print(f"   !! {nom:28s} {cat:10s} {av}  {motif}")
                echecs += 1
            else:
                d = int(((ap[0]-av[0])**2 + (ap[1]-av[1])**2) ** .5)
                print(f"   -> {nom:28s} {cat:10s} {av} => {ap}  ({motif}, {d} px)")
                total += 1
    print(f"\n{total} entites replacees"
          f"{' (APPLIQUE)' if appliquer else ' (SIMULATION)'}, {echecs} sans solution")
    return 0


if __name__ == '__main__':
    sys.exit(main())
