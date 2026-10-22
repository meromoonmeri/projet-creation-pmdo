#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Audit de la LOGIQUE SPATIALE des grounds.

Ce que l'outil verifie, et pourquoi
-----------------------------------
Le moteur RogueEssence stocke, a cote du decor, une grille d'obstacles
independante : GroundMap.obstacles[x][y].Tags, une case de 8 px (TEX_SIZE).

  Tags = 0  ->  libre        (GroundChar.basicCollision renvoie null)
  Tags = 1  ->  mur          (SlideResponse : le personnage glisse le long)
  Tags = 2  ->  declencheur  (TouchResponse)
  Tags = 3  ->  traversable  (CrossResponse)

Ref : ref/RogueEssence/RogueEssence/Ground/GroundChar.cs:341-352

Le decor (Layers/tuiles) et la grille d'obstacles sont DEUX choses
separees. Rien dans le moteur ne les met d'accord. Si on importe une image
en tuiles sans construire la grille en face, on obtient exactement ce que
decrit le rapport : une feuille. Le joueur traverse les falaises, et les
entites se posent dans la roche.

Trois defauts distincts sont donc mesures :

  A. GRILLE VIDE      -- aucune case bloquante : le relief dessine n'existe
                         pas pour le moteur.
  B. ENTITE DANS UN MUR -- la boite de collision d'une entite recouvre des
                         cases bloquantes. Au spawn, le personnage nait
                         encastre.
  C. ENTITE ISOLEE    -- l'entite est sur une case libre, mais dans une
                         poche de sol qui ne communique pas avec celle du
                         point d'entree. Injouable : on ne peut pas
                         l'atteindre.

Le defaut C ne se voit pas a l'oeil sur un rendu, et c'est celui qui
casse une arene de boss sans prevenir.
"""
import json
import pathlib
import sys
from collections import deque, Counter

TEX = 8  # GraphicsManager.TEX_SIZE

# Entites dont la position est un point de depart reel pour un personnage.
# Un marqueur sert de cible a une teleportation scriptee : il compte aussi.
CLES_ENTITES = ('MapChars', 'Spawners', 'GroundObjects', 'Markers')

# Marqueurs qui servent d'arrivee au joueur : ils fixent la poche de
# reference pour le test d'accessibilite.
NOMS_ENTREE = ('entrance', 'Main_Entrance_Marker')


def charger(chemin):
    return json.loads(pathlib.Path(chemin).read_text(encoding='utf-8-sig'))['Object']


def grille(obj):
    """Renvoie (bloque, W, H) ou bloque[x][y] est vrai si la case gene.

    Tags 2 et 3 ne bloquent pas le deplacement (Touch/Cross) : seul le
    tag 1 est un mur. On ne compte donc que celui-la.
    """
    obs = obj['obstacles']
    W = len(obs)
    H = len(obs[0]) if W else 0
    bloque = [[obs[x][y]['Tags'] == 1 for y in range(H)] for x in range(W)]
    return bloque, W, H


def entites(obj):
    """Aplatit toutes les entites en (categorie, nom, x, y, w, h) en pixels."""
    out = []
    for couche in obj.get('Entities', []):
        for cle in CLES_ENTITES:
            for e in couche.get(cle, []) or []:
                c = e.get('Collider') or {}
                out.append((cle, e.get('EntName', '?'),
                            c.get('X', 0), c.get('Y', 0),
                            c.get('Width', TEX), c.get('Height', TEX)))
    return out


def cases_couvertes(x, y, w, h, W, H):
    """Cases de la grille recouvertes par une boite en pixels."""
    x0, y0 = x // TEX, y // TEX
    x1, y1 = max(x0, (x + w - 1) // TEX), max(y0, (y + h - 1) // TEX)
    for cx in range(x0, x1 + 1):
        for cy in range(y0, y1 + 1):
            if 0 <= cx < W and 0 <= cy < H:
                yield cx, cy


def poches(bloque, W, H):
    """Etiquette les composantes connexes de sol libre (4-connexite).

    La 4-connexite est le bon choix : le moteur fait glisser le
    personnage le long des murs (SlideResponse), il ne le fait pas
    passer par un contact en diagonale entre deux murs.
    """
    lab = [[-1] * H for _ in range(W)]
    n = 0
    tailles = []
    for sx in range(W):
        for sy in range(H):
            if bloque[sx][sy] or lab[sx][sy] >= 0:
                continue
            q = deque([(sx, sy)])
            lab[sx][sy] = n
            t = 0
            while q:
                cx, cy = q.popleft()
                t += 1
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = cx + dx, cy + dy
                    if 0 <= nx < W and 0 <= ny < H and not bloque[nx][ny] \
                            and lab[nx][ny] < 0:
                        lab[nx][ny] = n
                        q.append((nx, ny))
            tailles.append(t)
            n += 1
    return lab, tailles


def auditer(chemin, verbeux=False):
    obj = charger(chemin)
    nom = pathlib.Path(chemin).stem
    bloque, W, H = grille(obj)
    total = W * H
    murs = sum(1 for x in range(W) for y in range(H) if bloque[x][y])
    ents = entites(obj)

    r = {'nom': nom, 'W': W, 'H': H, 'cases': total, 'murs': murs,
         'pct_murs': round(100 * murs / total, 1) if total else 0.0,
         'entites': len(ents), 'dans_mur': [], 'isolees': [],
         'hors_carte': [], 'grille_vide': murs == 0}

    for cat, en, x, y, w, h in ents:
        if not (0 <= x < W * TEX and 0 <= y < H * TEX):
            r['hors_carte'].append((cat, en, x, y))
            continue
        cs = list(cases_couvertes(x, y, w, h, W, H))
        nb = sum(1 for cx, cy in cs if bloque[cx][cy])
        if nb:
            r['dans_mur'].append((cat, en, x, y, nb, len(cs)))

    # Accessibilite : uniquement si la grille a un sens (des murs existent)
    if murs and ents:
        lab, tailles = poches(bloque, W, H)
        r['poches'] = len(tailles)
        r['plus_grande_poche'] = max(tailles) if tailles else 0

        def poche_de(x, y, w, h):
            for cx, cy in cases_couvertes(x, y, w, h, W, H):
                if not bloque[cx][cy]:
                    return lab[cx][cy]
            return None

        ref = None
        for cat, en, x, y, w, h in ents:
            if en in NOMS_ENTREE:
                ref = poche_de(x, y, w, h)
                if ref is not None:
                    break
        if ref is None and tailles:
            # pas de marqueur d'entree : on prend la plus grande poche
            ref = tailles.index(max(tailles))
        for cat, en, x, y, w, h in ents:
            p = poche_de(x, y, w, h)
            if p is not None and ref is not None and p != ref:
                r['isolees'].append((cat, en, x, y, tailles[p]))
    else:
        r['poches'] = 0
        r['plus_grande_poche'] = 0
    return r


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    racine = pathlib.Path(args[0]) if args else pathlib.Path('.')
    detail = '-v' in sys.argv[1:]
    cibles = sorted((racine / 'Data' / 'Ground').glob('*.rsground')) \
        if racine.is_dir() else [racine]

    res = []
    for c in cibles:
        try:
            res.append(auditer(c))
        except Exception as e:
            print(f"ERREUR {c.stem}: {e}")

    vides = [r for r in res if r['grille_vide']]
    murs_ent = [r for r in res if r['dans_mur']]
    isole = [r for r in res if r['isolees']]
    hors = [r for r in res if r['hors_carte']]

    print(f"grounds analyses            : {len(res)}")
    print(f"A. grille d'obstacles vide  : {len(vides)}")
    print(f"B. au moins 1 entite murée  : {len(murs_ent)}"
          f"  ({sum(len(r['dans_mur']) for r in murs_ent)} entites)")
    print(f"C. au moins 1 entite isolée : {len(isole)}"
          f"  ({sum(len(r['isolees']) for r in isole)} entites)")
    print(f"D. entite hors carte        : {len(hors)}"
          f"  ({sum(len(r['hors_carte']) for r in hors)} entites)")

    if detail:
        print("\n--- A. grille vide (le relief n'existe pas pour le moteur) ---")
        for r in vides:
            print(f"  {r['nom']:42s} {r['W']}x{r['H']}  {r['entites']} entites")
        print("\n--- B. entites encastrees dans un mur ---")
        for r in sorted(murs_ent, key=lambda r: -len(r['dans_mur'])):
            print(f"  {r['nom']:42s} murs {r['pct_murs']:5.1f}%")
            for cat, en, x, y, nb, tot in r['dans_mur']:
                print(f"        {en:32s} ({x:5d},{y:5d})  {nb}/{tot} cases bloquees")
        print("\n--- C. entites dans une poche inaccessible ---")
        for r in isole:
            print(f"  {r['nom']:42s} {r['poches']} poches")
            for cat, en, x, y, t in r['isolees']:
                print(f"        {en:32s} ({x:5d},{y:5d})  poche de {t} cases")
        print("\n--- D. entites hors carte ---")
        for r in hors:
            print(f"  {r['nom']:42s} {r['W']*TEX}x{r['H']*TEX} px")
            for cat, en, x, y in r['hors_carte']:
                print(f"        {en:32s} ({x},{y})")
    return 0


if __name__ == '__main__':
    sys.exit(main())
