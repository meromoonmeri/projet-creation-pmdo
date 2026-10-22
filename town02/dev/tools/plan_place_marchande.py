#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""plan_place_marchande.py — place les entites de la confrontation sur la
GRANDE PLACE MARCHANDE de Metano (cote est), sous trois contraintes :

  1. la case doit etre marchable pour un corps de 20x20 (Tags == 0) ;
  2. l'entite ne doit EFFLEURER aucune boutique : distance minimale au
     collider de tout GroundObject non-passable ;
  3. l'entite ne doit pas etre sur la riviere : la riviere de Metano
     court a l'OUEST (x < 950) ; la fenetre retenue commence a x = 984,
     et on verifie en plus qu'aucune tuile de la couche 'River' du
     .rsground ne se trouve sous la position.

Sortie : un rapport par entite avec la boutique la plus proche et sa
distance, plus un plan ASCII de la place.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GROUND = os.path.join(ROOT, 'Data', 'Ground', 'metano_town.rsground')

MARGE_BOUTIQUE = 40   # px : en deca, on considere que l'entite « effleure »

with open(GROUND, encoding='utf-8-sig') as f:
    OBJ = json.load(f)['Object']
OB = OBJ['obstacles']
ENT = OBJ['Entities'][0]

# --- couche riviere : ou sont les tuiles d'eau ? --------------------
RIVER = set()
for lay in OBJ['Layers']:
    if 'River' not in lay['Name']:
        continue
    T = lay['Tiles']
    for x in range(len(T)):
        for y in range(len(T[0])):
            if T[x][y].get('Layers'):
                RIVER.add((x, y))          # cellules de 8 px

SHOPS = []
for o in ENT['GroundObjects']:
    c = o.get('Collider') or {}
    if c and not o.get('Passable', True):
        SHOPS.append((o['EntName'], c['X'], c['Y'], c['Width'], c['Height']))


def tag(x, y):
    gx, gy = int(x) // 8, int(y) // 8
    if gx < 0 or gy < 0 or gx >= len(OB) or gy >= len(OB[0]):
        return -1
    return OB[gx][gy].get('Tags', 0)


def libre(x, y, w=20, h=20):
    return all(tag(x + dx, y + dy) == 0
               for dx in range(-w // 2, w // 2 + 1, 4)
               for dy in range(-h // 2, h // 2 + 1, 4))


def sur_riviere(x, y, w=20, h=20):
    for dx in range(-w // 2, w // 2 + 1, 8):
        for dy in range(-h // 2, h // 2 + 1, 8):
            if ((x + dx) // 8, (y + dy) // 8) in RIVER:
                return True
    return False


def dist_boutique(x, y):
    best = (1e9, None)
    for n, sx, sy, w, h in SHOPS:
        dx = max(sx - x, 0, x - (sx + w))
        dy = max(sy - y, 0, y - (sy + h))
        d = (dx * dx + dy * dy) ** .5
        if d < best[0]:
            best = (d, n)
    return best


def valide(x, y):
    """(ok, motif)"""
    if not libre(x, y):
        return False, 'mur'
    if sur_riviere(x, y):
        return False, 'RIVIERE'
    d, n = dist_boutique(x, y)
    if d < MARGE_BOUTIQUE:
        return False, f'effleure {n} ({d:.0f}px)'
    return True, f'{n} a {d:.0f}px'


def caler(x, y, rayon=64):
    """Case valide la plus proche de (x,y), ou None."""
    if valide(x, y)[0]:
        return x, y
    best = None
    for dx in range(-rayon, rayon + 1, 8):
        for dy in range(-rayon, rayon + 1, 8):
            nx, ny = x + dx, y + dy
            if valide(nx, ny)[0]:
                d = abs(dx) + abs(dy)
                if best is None or d < best[0]:
                    best = (d, nx, ny)
    return (best[1], best[2]) if best else None


def plan(x0=992, x1=1320, y0=680, y1=1090, marks=None):
    marks = marks or {}
    inv = {}
    for k, (x, y) in marks.items():
        inv[(int(x) // 8 * 8, int(y) // 8 * 8)] = k[0].upper()
    xs = list(range(x0, x1, 8))
    print('        ' + ''.join(f'{x // 100 % 10}' for x in xs))
    print('        ' + ''.join(f'{x // 10 % 10}' for x in xs))
    for y in range(y0, y1, 8):
        row = ''
        for x in xs:
            ch = '.' if libre(x, y) else '#'
            if (x // 8 * 8, y // 8 * 8) in inv:
                ch = inv[(x // 8 * 8, y // 8 * 8)]
            row += ch
        print(f'  {y:5d} ' + row)


if __name__ == '__main__':
    print(f'{len(SHOPS)} boutiques/obstacles solides, '
          f'{len(RIVER)} cellules de riviere\n')
    if len(sys.argv) > 1 and sys.argv[1] == 'plan':
        plan()
