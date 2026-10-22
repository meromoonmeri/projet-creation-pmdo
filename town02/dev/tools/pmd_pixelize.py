#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""pmd_pixelize.py — force une image generee au format graphique PMD.

POURQUOI
========
Un modele d'image ne produit PAS de pixel art. Mesure faite le
2026-08-04 sur une generation demandant explicitement « 32-colour
palette, crisp hard-edged pixels, no anti-aliasing » :

    couleurs obtenues        149 698   (demande : 32)
    blocs 2x2 uniformes          2,8 % (un vrai pixel art x2 : 100 %)

Il imite l'APPARENCE du pixel art avec un rendu haute definition.
Colle a cote d'une planche du jeu, l'ecart saute aux yeux.

Mesures sur les vraies planches du depot (Content/Tile/) :

    Crystal Cave Entrance     42 couleurs, saturation 29 %, luminance 48 %
    Mystifying Forest Ent.    59 couleurs, saturation 31 %, luminance 39 %
    Northern Desert Entrance  15 couleurs, saturation 53 %, luminance 61 %

Autre constante relevee : les composantes RVB des vraies planches sont
presque toutes des multiples de 8 (39, 79, 87, 95, 103, 135, 143, 175,
199, 207, 223, 231, 239). C'est la signature d'une palette 5 bits par
canal heritee de la DS.

CE QUE FAIT L'OUTIL
===================
  1. sous-echantillonne au facteur reel du pixel art voulu (bloc NxN
     -> 1 pixel), ce qui detruit l'anti-aliasing du modele ;
  2. desature et assombrit vers les cibles mesurees ;
  3. aligne chaque composante sur la grille de 8 (palette DS) ;
  4. quantifie a N couleurs par median cut ;
  5. re-agrandit au plus proche voisin si demande.

Le resultat est un VRAI pixel art : blocs uniformes, palette courte,
tons doux. Verifiable par --verifier.

USAGE
    python3 tools/pmd_pixelize.py entree.png sortie.png [options]
      --bloc N       taille du bloc source a fusionner   (defaut 6)
      --couleurs N   taille de la palette finale         (defaut 48)
      --sat F        saturation cible 0..1               (defaut 0.30)
      --lum F        luminance cible 0..1                (defaut 0.46)
      --sortie-px N  largeur finale en pixels (multiple de 8)
      --verifier     affiche les mesures avant/apres
"""
import argparse
import colorsys
import sys

import numpy as np
from PIL import Image


def mesurer(im, titre):
    a = np.asarray(im.convert('RGB'))
    plat = a.reshape(-1, 3)
    n = len(set(map(tuple, plat)))
    ech = plat[::max(1, len(plat) // 4000)]
    hls = [colorsys.rgb_to_hls(*[v / 255 for v in c]) for c in ech]
    sat = float(np.mean([h[2] for h in hls]))
    lum = float(np.mean([h[1] for h in hls]))
    # part de composantes alignees sur 8
    mult8 = float((plat % 8 == 7).mean() + (plat % 8 == 0).mean())
    print("  %-10s %sx%s  couleurs=%-7d sat=%3.0f%% lum=%3.0f%% grille8=%3.0f%%"
          % (titre, im.size[0], im.size[1], n, 100 * sat, 100 * lum, 100 * mult8))
    return n, sat, lum


def blocs(im, n):
    """Fusionne chaque bloc n x n en UN pixel : tue l'anti-aliasing."""
    w, h = im.size
    w2, h2 = max(1, w // n), max(1, h // n)
    a = np.asarray(im.convert('RGB'), dtype=np.float32)[:h2 * n, :w2 * n]
    a = a.reshape(h2, n, w2, n, 3).mean(axis=(1, 3))
    return Image.fromarray(a.astype(np.uint8), 'RGB')


def tons(im, sat_cible, lum_cible):
    """Ramene saturation et luminance vers les valeurs du jeu."""
    a = np.asarray(im.convert('RGB'), dtype=np.float32) / 255.0
    mx = a.max(axis=2); mn = a.min(axis=2)
    l = (mx + mn) / 2
    d = mx - mn
    s = np.where(d == 0, 0, d / np.where(l < 0.5, mx + mn + 1e-9,
                                         2.0 - mx - mn + 1e-9))
    # CORRECTIF 2026-08-04 : ignorer le VIDE NOIR dans les moyennes.
    # Sur une arene deja composee, ~50 % de l'image est du noir pur
    # (le hors-carte). Il tirait la luminance moyenne vers 0.30, donc
    # kl = 0.46/0.30 = 1.5 : tout le sol etait ECLAIRCI de 50 % et la
    # saturation grimpait a 96 %. Resultat mesure : un cyan fluo, a
    # l'oppose des tons doux vises.
    utile = l > 0.06
    if utile.sum() < 16:
        utile = np.ones_like(l, dtype=bool)
    s_moy = max(float(s[utile].mean()), 1e-6)
    l_moy = max(float(l[utile].mean()), 1e-6)
    # Plafond releve de 1.6 a 3.0 : mesure du 2026-08-04, avec 1.6 la
    # saturation finale plafonnait a 24 % quelle que soit la cible
    # demandee, car la quantification ternit encore l'image ensuite.
    # ks est borne a 1.0 : cet outil ADOUCIT, il ne ravive jamais.
    # Avec un plafond > 1 il sursaturait les textures deja pales —
    # mesure : une glace a 14 % de saturation ressortait a 97 %,
    # cyan fluo. Si la source est trop terne, c'est la generation
    # qu'il faut refaire, pas la corriger ici.
    ks = min(sat_cible / s_moy, 1.0)
    # Idem pour la luminance : on borne l'eclaircissement a +25 %,
    # sinon une texture sombre part en surexposition.
    kl = min(lum_cible / l_moy, 1.25)
    gris = a.mean(axis=2, keepdims=True)
    a = gris + (a - gris) * ks          # desaturation
    a = a * kl                          # assombrissement
    return Image.fromarray(np.clip(a * 255, 0, 255).astype(np.uint8), 'RGB')


def grille8(im):
    """Aligne chaque composante sur un multiple de 8 (palette DS)."""
    a = np.asarray(im.convert('RGB')).astype(np.int16)
    a = (a // 8) * 8 + 7
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), 'RGB')


def traiter(src, dst, bloc=6, couleurs=48, sat=0.30, lum=0.46,
            sortie_px=None, verifier=False):
    im = Image.open(src).convert('RGB')
    if verifier:
        print("MESURES")
        mesurer(im, "avant")

    im = blocs(im, bloc)
    im = tons(im, sat, lum)
    im = grille8(im)
    im = im.quantize(colors=couleurs, method=Image.MEDIANCUT,
                     dither=Image.NONE).convert('RGB')

    if sortie_px:
        f = max(1, round(sortie_px / im.size[0]))
        if f > 1:
            im = im.resize((im.size[0] * f, im.size[1] * f), Image.NEAREST)
        # recadrage sur un multiple de 8 : la maille du moteur
        w = (im.size[0] // 8) * 8
        h = (im.size[1] // 8) * 8
        im = im.crop((0, 0, w, h))

    im.save(dst)
    if verifier:
        mesurer(im, "apres")
        a = np.asarray(im)
        for N in (2, 3, 4, 6, 8):
            hh, ww, _ = a.shape
            if hh % N or ww % N:
                continue
            b = a[:hh // N * N, :ww // N * N].reshape(hh // N, N, ww // N, N, 3)
            u = (b.max(axis=(1, 3)) == b.min(axis=(1, 3))).all(axis=-1).mean()
            if u > 0.9:
                print("  facteur de pixel reel : %dx (%.0f%% de blocs uniformes)"
                      % (N, 100 * u))
                break
    return im


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('entree')
    p.add_argument('sortie')
    p.add_argument('--bloc', type=int, default=6)
    p.add_argument('--couleurs', type=int, default=48)
    p.add_argument('--sat', type=float, default=0.30)
    p.add_argument('--lum', type=float, default=0.46)
    p.add_argument('--sortie-px', type=int, default=None)
    p.add_argument('--verifier', action='store_true')
    a = p.parse_args()
    traiter(a.entree, a.sortie, a.bloc, a.couleurs, a.sat, a.lum,
            a.sortie_px, a.verifier)
