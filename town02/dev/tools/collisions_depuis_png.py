#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit la grille d'obstacles d'un ground A PARTIR DU PNG SOURCE d'origine.

Difference avec gen_collisions.py
---------------------------------
gen_collisions.py rend le ground depuis ses propres tuiles, puis classe les
pixels du rendu. C'est la bonne methode quand on n'a que le .rsground.

Ici on dispose des PNG SOURCES des jeux d'origine (fournis par l'auteur du
mod). Ils sont strictement plus fiables que le rendu :
  * aucune perte de fidelite due au decoupage en tuiles ;
  * les dimensions coincident au pixel pres avec la grille du ground, ce
    qui a ete verifie avant d'appeler cet outil (garde-fou A ci-dessous).

Methode
-------
Le sol praticable d'un decor PMD se distingue par sa PLANEITE : les zones
marchables sont des aplats de luminance homogene, les reliefs (roche,
cristaux, lave, vide) ont une variance locale forte et/ou une luminance
tres eloignee de celle du sol dominant.

  1. Conversion en luminance perceptuelle (Rec. 601).
  2. Recherche du mode de luminance sur la moitie basse de l'image : dans
     tous les decors d'entree de donjon PMD, le joueur arrive par le bas,
     donc le sol y est majoritaire.
  3. Une cellule de 8 px est LIBRE si sa luminance mediane est proche du
     mode ET si son ecart-type interne est faible (pas de relief).
  4. Nettoyage morphologique : suppression des ilots isoles de moins de
     `amas` cellules, dans les deux sens (murs parasites et trous).

Garde-fous — l'ecriture est REFUSEE si :
  A. les dimensions du PNG ne correspondent pas a la grille du ground ;
  B. moins de `mini` % du sol est praticable ;
  C. le point d'entree ne dessert pas au moins `min_couv` % du sol ;
  D. une entite existante (hors GroundObjects) se retrouverait muree.

Une grille fausse est PIRE qu'une grille vide : la grille vide laisse au
moins traverser. En cas de doute on n'ecrit rien.

Usage
    python3 tools/collisions_depuis_png.py <ground> <png> [--appliquer]
"""
import json
import pathlib
import sys
from collections import deque

import numpy as np
from PIL import Image

TEX = 8  # maille de la grille d'obstacles, fixe dans le moteur

CLES_ENTITES = ('MapChars', 'GroundObjects', 'Spawners', 'Markers')
NOMS_ENTREE = ('Main_Entrance_Marker', 'Entrance_Marker', 'Main_Entrance')


def luminance(img):
    a = np.asarray(img.convert('RGB'), dtype=np.float32)
    return 0.299 * a[:, :, 0] + 0.587 * a[:, :, 1] + 0.114 * a[:, :, 2]


def cellules(lum, W, H):
    """Decoupe la luminance en cellules de 8 px -> (mediane, ecart-type)."""
    med = np.zeros((W, H), dtype=np.float32)
    ect = np.zeros((W, H), dtype=np.float32)
    for x in range(W):
        for y in range(H):
            bloc = lum[y * TEX:(y + 1) * TEX, x * TEX:(x + 1) * TEX]
            med[x, y] = np.median(bloc)
            ect[x, y] = bloc.std()
    return med, ect


def mode_du_sol(med, W, H):
    """Luminance du sol la ou le joueur arrive reellement.

    Premiere version (rejetee) : mode de la moitie basse. Elle captait le
    FOND HORS-CARTE. Sur Crystal_Crossing (600x480) le PNG est borde de
    noir a lum~35 sur toute sa peripherie ; ce noir etait majoritaire dans
    la moitie basse et devenait la reference de « sol », si bien que le
    vrai sol (lum~59) passait pour du relief et se retrouvait bloquant.
    Le garde-fou C avait raison de refuser : 41 % de couverture.

    Version retenue : on echantillonne la BANDE CENTRALE BASSE, la ou tout
    decor d'entree de donjon PMD place le point d'arrivee du joueur, et on
    prend la mediane. Sur le meme decor : 59, valeur correcte.
    """
    x0, x1 = max(0, W // 2 - W // 8), min(W, W // 2 + W // 8)
    bande = med[x0:x1, max(0, H - 10):H]
    return float(np.median(bande))


def nettoyer(bloque, W, H, amas):
    """Supprime les ilots de moins de `amas` cellules, murs comme trous."""
    for cible in (True, False):
        vus = [[False] * H for _ in range(W)]
        for sx in range(W):
            for sy in range(H):
                if vus[sx][sy] or bloque[sx][sy] != cible:
                    continue
                paquet, q = [], deque([(sx, sy)])
                vus[sx][sy] = True
                while q:
                    cx, cy = q.popleft()
                    paquet.append((cx, cy))
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        nx, ny = cx + dx, cy + dy
                        if (0 <= nx < W and 0 <= ny < H and not vus[nx][ny]
                                and bloque[nx][ny] == cible):
                            vus[nx][ny] = True
                            q.append((nx, ny))
                if len(paquet) < amas:
                    for a, b in paquet:
                        bloque[a][b] = not cible
    return bloque


def cases_couvertes(x, y, w, h, W, H):
    for a in range(max(0, x // TEX), min(W, (x + max(w, 1) - 1) // TEX + 1)):
        for b in range(max(0, y // TEX), min(H, (y + max(h, 1) - 1) // TEX + 1)):
            yield a, b


def entites_de(obj):
    for couche in obj.get('Entities', []):
        for cle in CLES_ENTITES:
            for e in couche.get(cle, []) or []:
                c = e.get('Collider') or {}
                yield (cle, e.get('EntName') or e.get('NPCName', '?'),
                       c.get('X', 0), c.get('Y', 0),
                       c.get('Width', TEX), c.get('Height', TEX))


def accessible(bloque, W, H, depart):
    vus = [[False] * H for _ in range(W)]
    q = deque([depart])
    vus[depart[0]][depart[1]] = True
    n = 1
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < W and 0 <= ny < H and not bloque[nx][ny] and not vus[nx][ny]:
                vus[nx][ny] = True
                n += 1
                q.append((nx, ny))
    return vus, n


def traiter(nom, png, racine='.', appliquer=False,
            tol=26.0, relief=15.0, amas=4, mini=0.18, min_couv=0.55):
    chemin = pathlib.Path(racine) / 'Data/Ground' / (nom + '.rsground')
    octets = chemin.read_bytes()
    doc = json.loads(octets.decode('utf-8-sig'))
    obj = doc['Object']
    obs = obj['obstacles']
    W, H = len(obs), len(obs[0])
    deja = sum(1 for x in range(W) for y in range(H) if obs[x][y]['Tags'])

    img = Image.open(png)
    # GARDE-FOU A — dimensions
    if img.size != (W * TEX, H * TEX):
        return (nom, 'REFUS',
                f"PNG {img.size[0]}x{img.size[1]} != grille "
                f"{W*TEX}x{H*TEX} ({W}x{H} cases)")

    lum = luminance(img)
    med, ect = cellules(lum, W, H)
    sol = mode_du_sol(med, W, H)

    bloque = [[bool(abs(med[x, y] - sol) > tol or ect[x, y] > relief)
               for y in range(H)] for x in range(W)]
    bloque = nettoyer(bloque, W, H, amas)

    murs = sum(1 for x in range(W) for y in range(H) if bloque[x][y])
    libre = W * H - murs
    pct = libre / (W * H)
    # GARDE-FOU B — praticabilite
    if pct < mini:
        return (nom, 'REFUS', f"seulement {100*pct:.0f} % praticable "
                              f"(sol lum~{sol:.0f})")

    ents = list(entites_de(obj))

    # GARDE-FOU D — aucune entite muree
    mures = [en for cat, en, x, y, w, h in ents
             if cat != 'GroundObjects'
             and (cs := list(cases_couvertes(x, y, w, h, W, H)))
             and all(bloque[a][b] for a, b in cs)]
    if mures:
        return (nom, 'REFUS', f"murerait : {', '.join(mures[:4])}")

    # GARDE-FOU C — couverture depuis l'entree
    couv = None
    depart = None
    for cat, en, x, y, w, h in ents:
        if en in NOMS_ENTREE:
            for a, b in cases_couvertes(x, y, w, h, W, H):
                if not bloque[a][b]:
                    depart = (a, b)
                    break
        if depart:
            break
    if depart is None:  # pas de marqueur : on part de la case libre la plus basse
        for y in range(H - 1, -1, -1):
            for x in range(W):
                if not bloque[x][y]:
                    depart = (x, y)
                    break
            if depart:
                break
    if depart:
        _, n = accessible(bloque, W, H, depart)
        couv = n / libre if libre else 0
        if couv < min_couv:
            return (nom, 'REFUS',
                    f"depuis l'entree, {100*couv:.0f} % du sol seulement")

    detail = (f"{100*pct:.0f} % praticable, {murs} murs"
              + (f", couverture {100*couv:.0f} %" if couv is not None else "")
              + (f" (avait {deja})" if deja else " (grille etait VIDE)"))

    if appliquer:
        for x in range(W):
            for y in range(H):
                obs[x][y]['Tags'] = 1 if bloque[x][y] else 0
        # round-trip prouve : on retrouve le style exact du fichier d'origine
        avant = json.loads(octets.decode('utf-8-sig'))
        ind = None
        for bom in ('\ufeff', ''):
            for cand in (1, 0, 2, 4):
                t = bom + json.dumps(avant, ensure_ascii=False, indent=cand,
                                     separators=(',', ': '))
                if t.encode('utf-8') == octets:
                    ind, prefixe = cand, bom
                    break
            if ind is not None:
                break
        if ind is None:
            return (nom, 'REFUS', 'style de serialisation non reproductible')
        chemin.write_bytes((prefixe + json.dumps(
            doc, ensure_ascii=False, indent=ind,
            separators=(',', ': '))).encode('utf-8'))
    return (nom, 'OK', detail)


def apercu(nom, racine='.'):
    """Carte ASCII de la grille, pour controle visuel."""
    d = json.loads((pathlib.Path(racine) / 'Data/Ground' /
                    (nom + '.rsground')).read_bytes().decode('utf-8-sig'))['Object']
    ob = d['obstacles']
    W, H = len(ob), len(ob[0])
    pas = max(1, H // 40)
    for y in range(0, H, pas):
        print(''.join('#' if ob[x][y]['Tags'] == 1 else '.' for x in range(W)))


if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if len(args) < 2:
        print(__doc__)
        sys.exit(1)
    r = traiter(args[0], args[1], racine=args[2] if len(args) > 2 else '.',
                appliquer='--appliquer' in sys.argv)
    print(f"{r[0]:30} {r[1]:6} {r[2]}")
    if r[1] == 'OK' and '--appliquer' in sys.argv and '--apercu' in sys.argv:
        apercu(args[0], args[2] if len(args) > 2 else '.')
