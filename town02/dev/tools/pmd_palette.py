#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""pmd_palette.py — remappe une image sur la PALETTE EXACTE d'une planche du jeu.

POURQUOI CET OUTIL PLUTOT QU'UN REGLAGE A L'OEIL
================================================
Ajuster « un peu moins satures, un peu plus chauds » est un tatonnement
sans fin. La methode fiable consiste a EXTRAIRE la palette d'une planche
officielle et a y projeter l'image generee : les couleurs obtenues sont
alors, au sens strict, celles du jeu — pas des approximations.

Mesures sur Aegis Cave Entrance (l'entree du camp des Ruines) :

    105 couleurs
    teintes  0-45 deg (brun, ocre, sable) ......... 90 % des pixels
    3 couleurs portent a elles seules 38 % de l'image :
        (135, 95, 87)   16,5 %   la roche moyenne
        (207,159,127)   12,7 %   le sable eclaire
        ( 87, 63, 55)    9,4 %   l'ombre profonde
    toutes les composantes sont des multiples de 8 moins 1 (7, 15, ...,
    247) : signature de la palette 5 bits par canal heritee de la DS.

Un modele d'image ne produira jamais spontanement cette structure. En
revanche, projeter dessus est exact et reproductible.

METHODE
=======
  1. extraction de la palette source, ponderee par la surface reellement
     occupee (une couleur presente sur 3 pixels ne doit pas peser autant
     qu'une couleur qui couvre 16 % de l'image) ;
  2. conversion en CIE L*a*b* — la distance euclidienne y correspond a
     la difference percue, contrairement au RVB ou un ecart de 30 sur le
     bleu se voit beaucoup moins que sur le vert ;
  3. pour chaque pixel, recherche du plus proche voisin dans la palette ;
  4. le noir pur (0,0,0) est PRESERVE tel quel : c'est le vide hors
     carte, une convention du depot, pas une couleur de decor.

Le resultat partage exactement la palette de la planche de reference.
Pose a cote d'elle, il appartient au meme jeu.

USAGE
    python3 tools/pmd_palette.py source.png reference.png sortie.png
        [--max N]        ne garder que les N couleurs les plus presentes
        [--garder-noir]  laisser le noir pur intact (defaut : actif)
        [--verifier]     mesures avant / apres
"""
import argparse

import numpy as np
from PIL import Image


def rgb_vers_lab(rgb):
    """RVB 0-255 -> CIE L*a*b*, via sRGB lineaire et XYZ (illuminant D65)."""
    a = np.asarray(rgb, dtype=np.float64) / 255.0
    m = a > 0.04045
    a[m] = ((a[m] + 0.055) / 1.055) ** 2.4
    a[~m] = a[~m] / 12.92
    mat = np.array([[0.4124564, 0.3575761, 0.1804375],
                    [0.2126729, 0.7151522, 0.0721750],
                    [0.0193339, 0.1191920, 0.9503041]])
    xyz = a @ mat.T
    blanc = np.array([0.95047, 1.0, 1.08883])
    xyz = xyz / blanc
    e, k = 216 / 24389, 24389 / 27
    f = np.where(xyz > e, np.cbrt(xyz), (k * xyz + 16) / 116)
    return np.stack([116 * f[..., 1] - 16,
                     500 * (f[..., 0] - f[..., 1]),
                     200 * (f[..., 1] - f[..., 2])], axis=-1)


def palette_de(ref, maxi=None, seuil_noir=30, garder_verts=True):
    """Palette d'une image, triee par surface occupee.

    `garder_verts` : les teintes vegetales (70-170 deg) sont rares en
    surface — 3,1 % des pixels d'Aegis Cave Entrance pour 13 couleurs —
    et un simple tri par frequence les elimine des les premiers rangs.
    Or c'est precisement la mousse sur les rochers. On les force donc
    dans la palette retenue, quelle que soit leur surface.
    """
    a = np.asarray(Image.open(ref).convert('RGB')).reshape(-1, 3)
    a = a[a.sum(axis=1) > seuil_noir]          # on ecarte le vide
    cols, cnt = np.unique(a, axis=0, return_counts=True)
    ordre = np.argsort(-cnt)
    cols, cnt = cols[ordre], cnt[ordre]
    if maxi and len(cols) > maxi:
        garde = np.zeros(len(cols), dtype=bool)
        garde[:maxi] = True
        if garder_verts:
            import colorsys as _cs
            for i, c in enumerate(cols):
                h, l, sat = _cs.rgb_to_hls(*[v / 255 for v in c])
                if 70 <= h * 360 <= 170 and sat > 0.12:
                    garde[i] = True
        cols, cnt = cols[garde], cnt[garde]
    return cols.astype(np.uint8), cnt


def remapper(src, ref, dst, maxi=None, garder_noir=True, verifier=False):
    im = Image.open(src).convert('RGB')
    a = np.asarray(im)
    h, w, _ = a.shape

    pal, cnt = palette_de(ref, maxi)
    if verifier:
        tot = cnt.sum()
        print("PALETTE DE REFERENCE : %d couleurs" % len(pal))
        for c, n in list(zip(pal, cnt))[:5]:
            print("   RGB(%3d,%3d,%3d)  %5.2f %%" % (c[0], c[1], c[2], 100*n/tot))
        av = len(np.unique(a.reshape(-1, 3), axis=0))
        print("SOURCE : %d couleurs" % av)

    plat = a.reshape(-1, 3)
    noir = plat.sum(axis=1) <= 30

    # projection en Lab, par paquets pour tenir en memoire
    lab_pal = rgb_vers_lab(pal)
    sortie = np.empty_like(plat)
    PAS = 200000
    for i in range(0, len(plat), PAS):
        bloc = plat[i:i+PAS]
        lab = rgb_vers_lab(bloc)
        d = ((lab[:, None, :] - lab_pal[None, :, :]) ** 2).sum(axis=2)
        sortie[i:i+PAS] = pal[np.argmin(d, axis=1)]

    if garder_noir:
        sortie[noir] = plat[noir]

    out = Image.fromarray(sortie.reshape(h, w, 3), 'RGB')
    out.save(dst)

    if verifier:
        b = np.asarray(out).reshape(-1, 3)
        print("SORTIE : %d couleurs" % len(np.unique(b, axis=0)))
        # controle : toutes les couleurs sortent-elles de la palette ?
        ens = set(map(tuple, pal))
        hors = [tuple(c) for c in np.unique(b, axis=0)
                if tuple(c) not in ens and sum(c) > 30]
        print("couleurs hors palette : %s" % (hors[:4] if hors else "aucune"))
        mult8 = float(((b % 8 == 7) | (b % 8 == 0)).mean())
        print("composantes sur la grille de 8 : %.0f %%" % (100 * mult8))
    return out


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('source')
    p.add_argument('reference')
    p.add_argument('sortie')
    p.add_argument('--max', type=int, default=None)
    p.add_argument('--verifier', action='store_true')
    a = p.parse_args()
    remapper(a.source, a.reference, a.sortie, a.max, True, a.verifier)


def adoucir(src, dst, force=0.55, cible_moy=133.0, verifier=False):
    """Ramene une image bimodale vers la repartition tonale de PMD.

    DIAGNOSTIC QUI A MOTIVE CETTE FONCTION (2026-08-04)
    ===================================================
    La v3 de l'entree du camp avait le bon contraste LOCAL (12,3 contre
    14,8 pour l'officielle) et le bon nombre de sauts brutaux (3,6 %
    contre 3,5 %). Pourtant elle paraissait dure.

    La cause est la REPARTITION TONALE, pas le contraste :

                    tres sombre  sombre  moyen  clair  tres clair
        officielle       3,0 %   20,0 %  31,1 %  38,3 %    7,5 %
        ma v3           27,5 %   21,3 %  19,2 %   6,7 %   25,3 %

    L'officielle est CENTREE sur les tons moyens et clairs. La v3 est
    BIMODALE : un quart de l'image tres sombre, un quart tres clair,
    presque rien entre les deux. C'est ce creux au milieu que l'oeil
    lit comme « dur » — un rendu PMD respire dans les demi-teintes.

    METHODE
    -------
    Compression des extremes vers la moyenne cible par une courbe en S
    inversee : les valeurs eloignees de la moyenne sont ramenees vers
    elle, les valeurs proches bougent peu. On preserve la hierarchie
    sol clair / roche sombre, on supprime seulement les extremes.

    Le noir pur du vide est intouche.
    """
    im = Image.open(src).convert('RGB')
    a = np.asarray(im).astype(np.float64)
    g = a.mean(axis=2)
    sol = g > 30

    ecart = g - cible_moy
    # compression douce : plus on est loin de la cible, plus on revient
    facteur = 1.0 - force * (np.abs(ecart) / 128.0).clip(0, 1)
    neuf = cible_moy + ecart * facteur

    ratio = np.where(g > 1, neuf / np.maximum(g, 1), 1.0)[:, :, None]
    b = a * ratio
    b[~sol] = 0
    out = Image.fromarray(np.clip(b, 0, 255).astype(np.uint8), 'RGB')
    out.save(dst)

    if verifier:
        for nom, img in (('avant', im), ('apres', out)):
            x = np.asarray(img.convert('RGB')).astype(float).mean(axis=2)
            v = x[x > 30]
            r = [100 * np.mean((v >= lo) & (v < hi))
                 for lo, hi in ((0,60),(60,100),(100,150),(150,200),(200,256))]
            print("  %-6s moy %5.1f  |  %4.1f %4.1f %4.1f %4.1f %4.1f"
                  % (nom, v.mean(), *r))
    return out
