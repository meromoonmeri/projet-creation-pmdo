#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mesurer_redondance.py — une carte est-elle un VRAI tileset ?

POURQUOI
========
Un .rsground n'est pas une image : c'est une grille de cases, chacune
pointant un couple (planche, coordonnee). Le format est fait pour que
plusieurs cases reutilisent la MEME tuile.

Mesures du 2026-08-04 :

    reference PMD fournie par l'auteur   265 tuiles /  2736 cases  90,3 %
    Aegis Cave Entrance (depot)         1981 tuiles /  3672 cases  46,1 %
    Metano Town (carte de l'auteur)    71079 tuiles / 79910 cases  11,1 %
    planche generee par decoupe d'image 3663 tuiles /  3672 cases   0,2 %

Une redondance quasi nulle signale qu'on a decoupe une image au lieu de
composer une carte : chaque case a sa propre tuile, rien n'est reutilise.
C'est ce qui donne l'aspect « peint » plutot que « pixel art », et ce
qui fait exploser le poids du .tile.

Attention : la redondance seule ne mesure pas la qualite. Metano Town
n'est qu'a 11 % parce que c'est une grande carte tres variee. Mais
descendre sous ~5 % est anormal quel que soit le contenu.

USAGE
    python3 tools/mesurer_redondance.py fichier [fichier ...]
        accepte des .rsground, des .rsmap et des .png
"""
import json
import os
import sys
from collections import Counter


def depuis_ground(chemin):
    """Compte les references (planche, x, y) d'un .rsground ou .rsmap."""
    doc = json.loads(open(chemin, 'rb').read().decode('utf-8-sig'))
    obj = doc.get('Object', doc)
    refs = Counter()
    planches = Counter()
    for couche in obj.get('Layers', []):
        for colonne in couche.get('Tiles', []):
            for case in colonne:
                for lay in (case.get('Layers') or []):
                    for fr in (lay.get('Frames') or []):
                        cle = (fr.get('Sheet', ''),
                               fr.get('TexLoc', {}).get('X', 0),
                               fr.get('TexLoc', {}).get('Y', 0))
                        refs[cle] += 1
                        planches[fr.get('Sheet', '')] += 1
    return refs, planches


def depuis_png(chemin, tuile=8):
    """Compte les blocs graphiquement distincts d'une image."""
    from PIL import Image
    import numpy as np
    a = np.asarray(Image.open(chemin).convert('RGB'))
    h, w, _ = a.shape
    refs = Counter()
    for y in range(0, h - h % tuile, tuile):
        for x in range(0, w - w % tuile, tuile):
            refs[a[y:y + tuile, x:x + tuile].tobytes()] += 1
    return refs, Counter()


def verdict(pct):
    if pct < 5:
        return "ANORMAL — image decoupee, pas un tileset"
    if pct < 25:
        return "faible — carte tres variee, ou decoupe partielle"
    if pct < 60:
        return "normal pour une carte riche"
    return "vrai tileset, tuiles largement reutilisees"


def traiter(chemin, tuile=8):
    if not os.path.exists(chemin):
        print("  introuvable :", chemin)
        return
    ext = os.path.splitext(chemin)[1].lower()
    if ext in ('.rsground', '.rsmap'):
        refs, planches = depuis_ground(chemin)
    elif ext == '.png':
        refs, planches = depuis_png(chemin, tuile)
    else:
        print("  format non gere :", chemin)
        return
    tot = sum(refs.values())
    if tot == 0:
        print("  %-44s aucune tuile" % os.path.basename(chemin))
        return
    pct = 100 * (1 - len(refs) / tot)
    print("  %-44s %6d uniques / %6d cases  -> %5.1f %%  %s"
          % (os.path.basename(chemin), len(refs), tot, pct, verdict(pct)))
    if planches and len(planches) > 1:
        top = ', '.join("%s(%d)" % (k or '<vide>', v)
                        for k, v in planches.most_common(4))
        print("       planches : %s" % top)
    if refs:
        n, c = refs.most_common(1)[0]
        print("       tuile la plus posee : %d fois (%.1f %% de la carte)"
              % (c, 100 * c / tot))


if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    tuile = 8
    if '--tuile' in sys.argv:
        tuile = int(sys.argv[sys.argv.index('--tuile') + 1])
    if not args:
        print(__doc__)
        sys.exit(1)
    print("REDONDANCE DES TUILES")
    for a in args:
        traiter(a, tuile)
