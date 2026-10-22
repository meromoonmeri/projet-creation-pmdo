#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""composer_carte.py — construit une carte en REUTILISANT les tuiles du jeu.

LA METHODE CORRECTE, ENFIN
==========================
Les planches produites jusqu'ici etaient des images entieres decoupees :
3672 tuiles distinctes pour 3672 cases, redondance 0,2 %. Un vrai
decor PMD tourne entre 45 et 90 % (mesures dans
docs/FORMAT_TILESET_ROGUEESSENCE_2026-08-04.md).

Ici on inverse la production :

  1. on OUVRE un tileset officiel du depot et on classe ses tuiles
     (herbe sombre, herbe claire, terre, vide) d'apres leur contenu ;
  2. on dessine un PLAN de la carte : ou est le sol, ou est la foret,
     ou passe le chemin, ou est l'entree ;
  3. on POSE les tuiles selon ce plan, en les repetant.

Le resultat emploie quelques dizaines de tuiles pour des milliers de
cases. C'est ce qui donne le rythme visuel du pixel art d'epoque : le
motif se reconnait parce qu'il revient.

CHOIX DE LA TUILE SELON LE VOISINAGE
------------------------------------
Une tuile de bord ne convient pas au milieu d'une clairiere. On calcule
donc pour chaque case un CODE DE VOISINAGE (quelles cases adjacentes
sont du meme type) et on choisit une tuile compatible. C'est le principe
des autotiles du moteur, applique ici a la main faute d'autotiles
prets pour ce biome.

Faute de mieux, quand aucune tuile de bord n'est identifiable, on
prend une tuile pleine du bon type : le raccord est alors franc, ce qui
reste conforme au rendu DS (les vrais decors ont des bords nets).
"""
import argparse
import io
import struct
from collections import Counter

import numpy as np
from PIL import Image


def charger_tile(chemin):
    """Lit un .tile -> (taille, {(x,y): Image})."""
    d = open(chemin, 'rb').read()
    ts, tc = struct.unpack_from('<II', d, 0)
    cells = {}
    for i in range(tc):
        k, off = struct.unpack_from('<QQ', d, 8 + i * 16)
        x = k & 0xFFFFFFFF
        y = k >> 32
        ln = struct.unpack_from('<q', d, off)[0]
        cells[(x, y)] = Image.open(io.BytesIO(d[off + 8:off + 8 + ln])).convert('RGBA')
    return ts, cells


def est_pleine(im):
    """La tuile est-elle homogene, donc posable en masse ?

    Une tuile de BORD porte une transition (herbe vers terre par ex.) :
    posee au milieu d'une zone unie, elle produit un raccord absurde.
    C'est le defaut de la premiere composition : des lisieres au centre
    de la clairiere.

    Critere : les quatre bords de la tuile doivent ressembler a sa
    moyenne generale (ecart < 12), et la tuile ne doit pas etre trop
    contrastee (ecart-type < 26). Mesure sur Mystifying Forest Layer 1 :
    71 tuiles pleines sur 525.
    """
    a = np.asarray(im).astype(float)[:, :, :3]
    bords = [a[0, :].mean(axis=0), a[-1, :].mean(axis=0),
             a[:, 0].mean(axis=0), a[:, -1].mean(axis=0)]
    centre = a.reshape(-1, 3).mean(axis=0)
    return max(float(np.abs(v - centre).mean()) for v in bords) < 12 \
        and float(a.std()) < 26


def classer(cells):
    """Range les tuiles par nature, d'apres leur couleur moyenne."""
    cat = {}
    for pos, im in cells.items():
        a = np.asarray(im).astype(float)
        if a.shape[2] == 4 and a[:, :, 3].mean() < 10:
            cat.setdefault('vide', []).append(pos)
            continue
        if est_pleine(im):
            cat.setdefault('pleine', []).append(pos)
        masque = a[:, :, 3] > 128 if a.shape[2] == 4 else np.ones(a.shape[:2], bool)
        rgb = a[:, :, :3][masque]
        if len(rgb) == 0:
            continue
        r, g, b = rgb.mean(axis=0)
        lum = rgb.mean()
        ecart = float(rgb.std())
        vert = g > r + 12 and g > b + 12
        if vert and lum < 70:
            cat.setdefault('herbe_sombre', []).append(pos)
        elif vert:
            cat.setdefault('herbe_claire', []).append(pos)
        elif lum > 140:
            cat.setdefault('terre', []).append(pos)
        else:
            cat.setdefault('autre', []).append(pos)
        # les tuiles tres uniformes servent de remplissage
        if ecart < 14:
            cat.setdefault('uni', []).append(pos)
    return cat


def plan_clairiere(W, H, rng):
    """Plan de la carte : 0 = foret (mur), 1 = sol, 2 = chemin.

    Composition voulue, la meme que la reference PMD : un chemin entre
    par le BAS, s'elargit en clairiere, et une ouverture au NORD mene
    plus loin. Les bords laterals sont de la foret dense.
    """
    grille = np.zeros((W, H), dtype=int)
    cx = W // 2
    # chemin vertical, largeur variable
    for y in range(H):
        t = y / max(1, H - 1)
        larg = 2 + int(3 * (1 - abs(t - 0.55) * 2))
        larg = max(2, larg)
        dec = int(round(1.5 * np.sin(t * 5)))
        for x in range(cx - larg + dec, cx + larg + dec + 1):
            if 0 <= x < W:
                grille[x, y] = 2
    # clairiere centrale : ellipse
    ey, ex = H * 0.58, cx
    ra, rb = W * 0.30, H * 0.22
    for x in range(W):
        for y in range(H):
            if ((x - ex) / ra) ** 2 + ((y - ey) / rb) ** 2 <= 1.0:
                if grille[x, y] == 0:
                    grille[x, y] = 1
    # bord irregulier : on grignote au hasard
    for _ in range(int(W * H * 0.05)):
        x, y = rng.integers(0, W), rng.integers(0, H)
        if grille[x, y] == 1:
            vois = [(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
            if any(0 <= a < W and 0 <= b < H and grille[a, b] == 0 for a, b in vois):
                grille[x, y] = 0
    # l'ouverture du haut reste toujours praticable
    for y in range(0, max(2, H // 8)):
        for x in range(cx - 2, cx + 3):
            if 0 <= x < W:
                grille[x, y] = 2
    return grille


def composer(tile_sol, tile_objets, W, H, sortie, graine=1):
    rng = np.random.default_rng(graine)
    ts, sol_cells = charger_tile(tile_sol)
    cat = classer(sol_cells)
    for k in ('herbe_sombre', 'herbe_claire', 'terre'):
        if not cat.get(k):
            raise SystemExit("categorie absente du tileset : " + k)

    # on retient un PETIT jeu de tuiles : c'est tout l'objet de l'exercice
    def choisir(nom, n):
        # on ne garde QUE des tuiles pleines : une tuile de bord posee
        # au milieu d'une zone unie donne un raccord absurde.
        pleines = set(cat.get('pleine', []))
        src = [p for p in cat[nom] if p in pleines] or cat[nom]
        idx = rng.choice(len(src), size=min(n, len(src)), replace=False)
        return [src[i] for i in idx]

    jeu = {
        'foret': choisir('herbe_sombre', 4),
        'sol': choisir('herbe_claire', 4),
        'chemin': choisir('terre', 3),
    }
    print("jeu de tuiles retenu :",
          {k: len(v) for k, v in jeu.items()},
          "soit", sum(len(v) for v in jeu.values()), "tuiles")

    grille = plan_clairiere(W, H, rng)
    im = Image.new('RGBA', (W * ts, H * ts), (0, 0, 0, 255))
    poses = Counter()
    for x in range(W):
        for y in range(H):
            t = grille[x, y]
            nom = 'foret' if t == 0 else ('sol' if t == 1 else 'chemin')
            # variation stable : depend de la position, pas du hasard pur,
            # pour que le motif se repete de facon lisible
            choix = jeu[nom][(x * 7 + y * 13) % len(jeu[nom])]
            im.paste(sol_cells[choix], (x * ts, y * ts))
            poses[choix] += 1

    # ------------------------------------------------------------------
    # COUCHE 2 — LES ARBRES, POSES EN BLOCS
    # ------------------------------------------------------------------
    # Premiere version : une tuile d'arbre isolee par case. Resultat, un
    # damier : un arbre de la planche occupe 3x3 ou 4x4 cases, le
    # decouper case par case detruit sa silhouette.
    # On repere donc les BLOCS d'arbre dans la planche source (groupes de
    # cases opaques adjacentes) et on les repose ENTIERS.
    if tile_objets:
        ts2, obj_cells = charger_tile(tile_objets)
        opaque = {p for p, i in obj_cells.items()
                  if np.asarray(i)[:, :, 3].mean() > 60}
        # regroupement en blocs connexes
        vus = set()
        blocs = []
        for p in sorted(opaque):
            if p in vus:
                continue
            pile, grp = [p], []
            vus.add(p)
            while pile:
                c = pile.pop()
                grp.append(c)
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if n in opaque and n not in vus:
                        vus.add(n)
                        pile.append(n)
            if 2 <= len(grp) <= 140:
                blocs.append(grp)
        blocs.sort(key=len, reverse=True)
        print("blocs d'arbre reperes :", len(blocs),
              "tailles", [len(b) for b in blocs[:6]])
        if blocs:
            occupe = set()
            for x in range(0, W, 3):
                for y in range(0, H, 3):
                    if grille[x, y] != 0 or (x, y) in occupe:
                        continue
                    if rng.random() > 0.55:
                        continue
                    b = blocs[(x * 5 + y * 11) % len(blocs)]
                    ox = min(c[0] for c in b)
                    oy = min(c[1] for c in b)
                    # on ne pose que si tout le bloc tombe sur de la foret
                    cases = [(x + c[0] - ox, y + c[1] - oy) for c in b]
                    if any(not (0 <= a < W and 0 <= d2 < H) or grille[a, d2] != 0
                           or (a, d2) in occupe for a, d2 in cases):
                        continue
                    for c, (a, d2) in zip(b, cases):
                        t = obj_cells[c]
                        im.paste(t, (a * ts, d2 * ts), t)
                        occupe.add((a, d2))
                        poses[('obj',) + c] += 1

    im.convert('RGB').save(sortie)
    tot = W * H
    print("carte %dx%d px | %d cases | %d tuiles distinctes -> redondance %.1f %%"
          % (W * ts, H * ts, tot, len(poses), 100 * (1 - len(poses) / max(1, sum(poses.values())))))
    return im


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('tile_sol')
    p.add_argument('sortie')
    p.add_argument('--objets', default=None)
    p.add_argument('--w', type=int, default=25)
    p.add_argument('--h', type=int, default=21)
    p.add_argument('--graine', type=int, default=1)
    a = p.parse_args()
    composer(a.tile_sol, a.objets, a.w, a.h, a.sortie, a.graine)
