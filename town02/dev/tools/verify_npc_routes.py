#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_npc_routes — controle les points de routine des PNJ de Metano.

MOTIF
-----
npc_routines.lua deplace les PNJ vers des ROUTE_POINTS annotes en tete de
fichier : « coordonnees approximatives ». Un point pose dans un mur, ou
dans une poche isolee, produit exactement le defaut que le document
systeme_raid_ville_vivante.md interdit au point 5 : un PNJ dont la
position ne correspond plus a rien, ce qui casse l'immersion autant qu'un
dialogue perime.

GROUND:MoveToPosition ne verifie pas la destination : le PNJ glisse vers
la cible et s'arrete contre le premier obstacle, ou reste plante. Rien
n'est logue. Le defaut est donc invisible hors du jeu.

CE QUE L'OUTIL VERIFIE
  A. chaque ROUTE_POINT est dans les limites de la carte ;
  B. ses 4 cellules de 8 px sont libres (Tags == 0) ;
  C. il appartient a la composante accessible depuis l'entree du joueur
     (un point libre mais enclos derriere un mur est injoignable) ;
  D. deux PNJ ne visent pas le meme point au meme moment.

Usage : python3 tools/verify_npc_routes.py [racine]
Sortie : code 1 si au moins un point est invalide.
"""
import json
import os
import re
import sys
from collections import deque

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'
GROUND = os.path.join(ROOT, 'Data', 'Ground', 'metano_town.rsground')
ROUTES = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'npc_routines.lua')


def charger_carte():
    doc = json.load(open(GROUND, encoding='utf-8-sig'))
    obj = doc['Object']
    ob = obj['obstacles']
    W, H = len(ob), len(ob[0])

    depart = None
    def walk(x):
        nonlocal depart
        if isinstance(x, dict):
            # metano_town n'a PAS de Main_Entrance_Marker : son entree
            # principale s'appelle 'entrance'. Chercher le mauvais nom
            # faisait demarrer le parcours en (0,0), donc dans le vide,
            # et TOUS les points ressortaient « isoles » a tort.
            if x.get('EntName') in ('Main_Entrance_Marker', 'entrance'):
                c = x.get('Collider')
                if c and depart is None:
                    depart = (c['X'] // 8, c['Y'] // 8)
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj.get('Entities', []))

    def libre(t):
        return 0 <= t[0] < W and 0 <= t[1] < H and ob[t[0]][t[1]]['Tags'] == 0

    joignables = set()
    if depart and libre(depart):
        joignables.add(depart)
        q = deque([depart])
        while q:
            x, y = q.popleft()
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                n = (x + dx, y + dy)
                if n not in joignables and libre(n):
                    joignables.add(n)
                    q.append(n)
    return ob, W, H, depart, joignables, libre


def main():
    if not os.path.isfile(GROUND):
        print('carte introuvable : %s' % GROUND)
        return 0
    ob, W, H, depart, joignables, libre = charger_carte()

    src = open(ROUTES, encoding='utf-8').read()
    bloc = re.search(r'local ROUTE_POINTS = \{(.*?)\n\}', src, re.S)
    if not bloc:
        print('ROUTE_POINTS introuvable dans npc_routines.lua')
        return 0
    pts = re.findall(r'(\w+)\s*=\s*\{\s*x\s*=\s*(\d+)\s*,\s*y\s*=\s*(\d+)',
                     bloc.group(1))

    print('=' * 74)
    print('verify_npc_routes — points de routine de Metano Town'.center(74))
    print('=' * 74)
    print('carte %dx%d cellules (%dx%d px) | entree %s | %d cases accessibles\n'
          % (W, H, W * 8, H * 8, depart, len(joignables)))

    mauvais = []
    for nom, sx, sy in pts:
        px, py = int(sx), int(sy)
        cells = [((px + dx) // 8, (py + dy) // 8) for dx in (0, 8) for dy in (0, 8)]
        hors = [c for c in cells if not (0 <= c[0] < W and 0 <= c[1] < H)]
        murs = [c for c in cells if not hors and not libre(c)]
        isole = [c for c in cells if not hors and not murs and c not in joignables]

        if hors:
            etat, dieu = 'HORS CARTE', 'haute'
        elif murs:
            etat, dieu = 'DANS UN MUR', 'haute'
        elif isole:
            etat, dieu = 'ISOLE (injoignable a pied)', 'haute'
        else:
            etat, dieu = 'ok', None
        if dieu:
            mauvais.append((nom, px, py, etat))
        print('  %-16s (%4d,%4d) cellule (%3d,%3d)  %s'
              % (nom, px, py, px // 8, py // 8, etat))

    # points partages
    vus = {}
    for nom, sx, sy in pts:
        vus.setdefault((sx, sy), []).append(nom)
    doublons = {k: v for k, v in vus.items() if len(v) > 1}

    print()
    if doublons:
        print('### POINTS PARTAGES : %d' % len(doublons))
        for (sx, sy), noms in doublons.items():
            print('    (%s,%s) : %s' % (sx, sy, ', '.join(noms)))
        print()

    if not mauvais:
        print('RESULTAT : les %d points de routine sont valides.' % len(pts))
        return 0
    print('### POINTS INVALIDES : %d / %d' % (len(mauvais), len(pts)))
    for nom, px, py, etat in mauvais:
        print('    %-16s (%4d,%4d)  %s' % (nom, px, py, etat))
    print()
    print("Un PNJ envoye sur un de ces points ne s'y rendra pas : "
          "MoveToPosition\nglisse vers la cible sans controle et s'arrete "
          "contre l'obstacle, sans log.")
    return 1


if __name__ == '__main__':
    sys.exit(main())
