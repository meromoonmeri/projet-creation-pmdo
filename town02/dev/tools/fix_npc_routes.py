#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Recale les ROUTE_POINTS invalides de npc_routines.lua.

METHODE
-------
Pour chaque point casse, on cherche la case valide la PLUS PROCHE du
point d'origine : libre, accessible a pied depuis l'entree de la ville,
et assez large pour un PNJ de 16x16. On ne deplace donc pas le lieu, on
le pose la ou il aurait du etre — le marche reste au marche, le puits
reste au puits.

Le point d'ancrage de reference est l'ENTITE reelle du lieu quand elle
existe dans le .rsground (Well, Shop, Dojo_Entrance...) : c'est plus
fiable que la coordonnee approximative ecrite a la main.
"""
import io
import json
import os
import re
import sys
from collections import deque

ROOT = '.'
GROUND = os.path.join(ROOT, 'Data', 'Ground', 'metano_town.rsground')
ROUTES = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'npc_routines.lua')

# Ancrage : point de routine -> entite reelle de la carte, quand il y en
# a une qui designe le meme lieu. Releve dans metano_town.rsground.
# Coordonnee d'ancrage EXPLICITE, relevee sur l'entite reelle de la
# carte. On ne passe plus par un nom d'entite : plusieurs lieux
# (Market_Locale, Merchants_Locale, Well_Locale, North_Houses_Locale)
# existent en 2 a 5 exemplaires, et prendre le premier venu envoyait le
# PNJ a l'autre bout de la ville.
# Un decalage volontaire separe les points voisins (WELL/FOUNTAIN,
# CAFE_ENTRANCE/CAFE_TERRASSE) : deux PNJ ne doivent pas viser la meme
# case, sinon leurs sprites se superposent.
ANCRES = {
    'GUILD_BRIDGE':   (584, 1176),   # Guild_Bridge_Sign
    'MARKET_CENTER':  (952,  864),   # Market_Locale, etal central
    'WELL':           (688,  184),   # Well
    'FOUNTAIN':       (744,  432),   # Well_Locale, le bassin au sud du puits
    'CAFE_ENTRANCE':  (1144, 592),   # Cafe_Entrance
    'CAFE_TERRASSE':  (1112, 616),   # deux cases a l'ouest de la porte
    'POND_EDGE':      (992,  392),   # Well_Locale nord-est
    'HOUSES_NORTH':   (680,  584),   # North_Houses_Locale
    'TENT_AREA':      (784, 1120),   # Merchants_Locale, campement central
}


def main():
    doc = json.load(open(GROUND, encoding='utf-8-sig'))
    obj = doc['Object']
    ob = obj['obstacles']
    W, H = len(ob), len(ob[0])

    ents = {}
    depart = None

    def walk(x):
        nonlocal depart
        if isinstance(x, dict):
            n = x.get('EntName')
            c = x.get('Collider')
            if n and c:
                ents[n] = (c['X'], c['Y'])
                if n == 'entrance' and depart is None:
                    depart = (c['X'] // 8, c['Y'] // 8)
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj.get('Entities', []))

    def libre(t):
        return 0 <= t[0] < W and 0 <= t[1] < H and ob[t[0]][t[1]]['Tags'] == 0

    joignables = {depart}
    q = deque([depart])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if n not in joignables and libre(n):
                joignables.add(n)
                q.append(n)

    def valide(px, py):
        return all(((px + dx) // 8, (py + dy) // 8) in joignables
                   for dx in (0, 8) for dy in (0, 8))

    src = io.open(ROUTES, encoding='utf-8').read()
    bloc = re.search(r'local ROUTE_POINTS = \{(.*?)\n\}', src, re.S)
    pts = re.findall(r'(\w+)\s*=\s*\{\s*x\s*=\s*(\d+)\s*,\s*y\s*=\s*(\d+)',
                     bloc.group(1))

    corrections = {}
    for nom, sx, sy in pts:
        px, py = int(sx), int(sy)
        if valide(px, py):
            continue
        # on repart de l'entite du lieu si on en connait une
        anc = ANCRES.get(nom)
        cx, cy = anc if anc else (px, py)
        # recherche en spirale de la case valide la plus proche
        best = None
        for r in range(0, 40):
            for dx in range(-r, r + 1):
                for dy in (-r, r) if r else (0,):
                    for a, b in ((cx + dx * 8, cy + dy * 8),
                                 (cx + dy * 8, cy + dx * 8)):
                        if valide(a, b):
                            d = abs(a - px) + abs(b - py)
                            if best is None or d < best[0]:
                                best = (d, a, b)
            if best:
                break
        if best:
            corrections[nom] = (best[1], best[2])
            print('  %-16s (%4d,%4d) -> (%4d,%4d)%s'
                  % (nom, px, py, best[1], best[2],
                     '  [ancre %s]' % (anc,) if anc else ''))
        else:
            print('  %-16s (%4d,%4d) -> AUCUNE case valide trouvee'
                  % (nom, px, py))

    if '--apply' not in sys.argv:
        print('\n(essai a blanc ; --apply pour ecrire)')
        return 0

    for nom, (nx, ny) in corrections.items():
        src = re.sub(
            r'(%s\s*=\s*\{\s*x\s*=\s*)\d+(\s*,\s*y\s*=\s*)\d+' % nom,
            lambda m: '%s%d%s%d' % (m.group(1), nx, m.group(2), ny),
            src, count=1)
    io.open(ROUTES, 'w', encoding='utf-8').write(src)
    print('\n%d point(s) recale(s) dans npc_routines.lua' % len(corrections))
    return 0


if __name__ == '__main__':
    sys.exit(main())
