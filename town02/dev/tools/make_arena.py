#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""make_arena.py — compose une arene de boss au format graphique PMD.

CE QUE « SILHOUETTE » VEUT DIRE
===============================
Rien a voir avec les sprites de Pokemon : ceux-la, le moteur les pose
lui-meme a partir de Data/Ground/*.rsground.

La silhouette, c'est le DECOUPAGE SOL / VIDE de la planche de decor.
Mesure sur la planche officielle Crystal Cave Entrance :

    pixels de sol   53 %
    pixels noirs    47 %   <- le vide, hors carte

C'est ce contour qui dit ou l'on marche. Une texture pleine, sans
decoupe, n'est pas une carte : c'est un carre de matiere.

Un modele d'image sait produire la MATIERE (roche, neige, lave), pas la
FORME (un plateau lisible, une bordure nette, des proportions jouables).
Cet outil apporte la forme, par programme, et va chercher la matiere
dans une texture — generee ou prise dans Content/Tile/.

METHODE
=======
  1. silhouette : disque deforme par du bruit basse frequence, donc
     organique et jamais deux fois la meme, mais toujours d'un seul
     tenant et centre ;
  2. la texture de sol est plaquee a l'interieur, en mosaique ;
  3. une bordure assombrie de quelques pixels ourle le contour — c'est
     ce qui fait lire le relief sur les vraies planches ;
  4. le vide est noir pur (0,0,0), convention du depot ;
  5. passage par pmd_pixelize : palette courte, tons doux, grille de 8.

La grille d'obstacles se deduit ensuite de la silhouette, exactement :
noir = bloquant, sol = libre. Aucune approximation.
"""
import argparse
import sys

import numpy as np
from PIL import Image, ImageFilter


def bruit(w, h, echelle, rng):
    """Bruit lisse basse frequence, pour deformer le contour."""
    pw, ph = max(2, w // echelle), max(2, h // echelle)
    petit = rng.random((ph, pw)).astype(np.float32)
    im = Image.fromarray((petit * 255).astype(np.uint8), 'L')
    im = im.resize((w, h), Image.BICUBIC).filter(ImageFilter.GaussianBlur(echelle / 2))
    a = np.asarray(im).astype(np.float32) / 255.0
    return (a - a.min()) / max(1e-6, float(np.ptp(a)))


def silhouette(w, h, graine, remplissage=0.55, rugosite=0.30):
    """Disque deforme : organique, d'un seul tenant, centre."""
    rng = np.random.default_rng(graine)
    yy, xx = np.mgrid[0:h, 0:w]
    cx, cy = w / 2, h / 2
    # distance normalisee au centre, en ellipse (les cartes sont larges)
    r = np.sqrt(((xx - cx) / (w / 2)) ** 2 + ((yy - cy) / (h / 2)) ** 2)
    d = bruit(w, h, max(8, w // 10), rng) - 0.5
    r = r + d * rugosite * 2.0
    seuil = np.quantile(r, remplissage)
    sol = r <= seuil
    # nettoyage : on ne garde que la composante centrale
    from collections import deque
    vis = np.zeros_like(sol)
    start = (int(cy), int(cx))
    if not sol[start]:
        ys, xs = np.nonzero(sol)
        i = np.argmin((ys - cy) ** 2 + (xs - cx) ** 2)
        start = (ys[i], xs[i])
    q = deque([start]); vis[start] = True
    while q:
        y, x = q.popleft()
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < h and 0 <= nx < w and sol[ny, nx] and not vis[ny, nx]:
                vis[ny, nx] = True
                q.append((ny, nx))
    return vis


def composer(texture, w, h, graine, remplissage, rugosite, bordure=3):
    tex = Image.open(texture).convert('RGB')
    # mosaique de la texture sur toute la surface
    tw, th = tex.size
    fond = Image.new('RGB', (w, h))
    for y in range(0, h, th):
        for x in range(0, w, tw):
            fond.paste(tex, (x, y))
    a = np.asarray(fond).astype(np.int16)

    sol = silhouette(w, h, graine, remplissage, rugosite)

    # bordure : on assombrit les pixels de sol proches du vide.
    # C'est ce liset sombre qui fait lire le relief sur les vraies
    # planches ; sans lui le sol a l'air decoupe aux ciseaux.
    m = Image.fromarray((sol * 255).astype(np.uint8), 'L')
    ero = m.filter(ImageFilter.MinFilter(bordure * 2 + 1))
    liseret = sol & (np.asarray(ero) == 0)
    a[liseret] = (a[liseret] * 0.72).astype(np.int16)
    ero2 = m.filter(ImageFilter.MinFilter(3))
    tout_bord = sol & (np.asarray(ero2) == 0)
    a[tout_bord] = (a[tout_bord] * 0.55).astype(np.int16)

    a[~sol] = 0                      # le vide : noir pur
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), 'RGB'), sol


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('texture')
    p.add_argument('sortie')
    p.add_argument('--w', type=int, default=456)
    p.add_argument('--h', type=int, default=456)
    p.add_argument('--graine', type=int, default=1)
    p.add_argument('--remplissage', type=float, default=0.55)
    p.add_argument('--rugosite', type=float, default=0.30)
    p.add_argument('--bordure', type=int, default=3)
    a = p.parse_args()
    # dimensions multiples de 8 : la maille du moteur
    w, h = (a.w // 8) * 8, (a.h // 8) * 8
    im, sol = composer(a.texture, w, h, a.graine, a.remplissage,
                       a.rugosite, a.bordure)
    im.save(a.sortie)
    print("%s  %dx%d  sol %.0f%%  vide %.0f%%"
          % (a.sortie, w, h, 100 * sol.mean(), 100 * (1 - sol.mean())))
