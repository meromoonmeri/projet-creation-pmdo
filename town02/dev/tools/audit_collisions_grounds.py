#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_collisions_grounds — verifie la grille de collision de chaque ground.

MOTIF
-----
Le prompt maitre annonce « 63 grounds ont une grille de collision
entierement vide, dont 15 portent un Boss_Marker ». Cette affirmation
doit etre verifiee sur les fichiers reels avant d'engager un tracage
manuel arene par arene, qui serait tres couteux.

CE QUE L'OUTIL MESURE, par ground
  A. grille absente ou de taille nulle
  B. grille 100 % LIBRE   (Tags == 0 partout) : aucun mur, on marche
     dans le decor
  C. grille 100 % BLOQUEE (Tags != 0 partout) : rien n'est praticable
  D. entites hors des limites de la carte
  E. presence d'un Boss_Marker

B et C sont les deux formes de « grille vide » : dans les deux cas la
collision n'a jamais ete tracee. Les distinguer importe, car une carte
100 % bloquee empeche tout deplacement alors qu'une carte 100 % libre
laisse traverser les murs.

Usage :
    python3 tools/audit_collisions_grounds.py <dossier_grounds> [--json out]
Le dossier peut ne contenir qu'un echantillon : l'outil dit sur combien
de fichiers il a reellement travaille.
"""
import json
import os
import sys

def analyser(path):
    try:
        doc = json.load(open(path, encoding='utf-8-sig'))
    except Exception as e:
        return {'erreur': str(e)[:60]}
    obj = doc.get('Object', doc)
    ob = obj.get('obstacles') or []
    W = len(ob)
    H = len(ob[0]) if W else 0
    if W == 0 or H == 0:
        return {'W': W, 'H': H, 'etat': 'GRILLE ABSENTE'}

    libres = 0
    for col in ob:
        for c in col:
            t = c.get('Tags') if isinstance(c, dict) else c
            if t == 0:
                libres += 1
    tot = W * H

    ents = []
    def walk(x):
        if isinstance(x, dict):
            n, c = x.get('EntName'), x.get('Collider')
            if n and c:
                ents.append((n, c.get('X', 0), c.get('Y', 0)))
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj.get('Entities', []))

    hors = [n for n, x, y in ents
            if not (0 <= x // 8 < W and 0 <= y // 8 < H)]
    boss = [n for n, _, _ in ents if 'Boss' in n]

    if libres == tot:
        etat = '100% LIBRE (aucun mur)'
    elif libres == 0:
        etat = '100% BLOQUE (rien de praticable)'
    else:
        etat = 'ok'
    return {'W': W, 'H': H, 'libres': libres, 'total': tot,
            'etat': etat, 'hors': hors, 'boss': boss}


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 0
    d = sys.argv[1]
    fichiers = sorted(f for f in os.listdir(d) if f.endswith('.rsground'))
    res = {}
    for f in fichiers:
        res[f[:-9]] = analyser(os.path.join(d, f))

    vides = {k: v for k, v in res.items()
             if v.get('etat', '').startswith(('100%', 'GRILLE'))}
    horsl = {k: v for k, v in res.items() if v.get('hors')}
    bosses = {k: v for k, v in vides.items() if v.get('boss')}

    print('=' * 74)
    print('audit_collisions_grounds'.center(74))
    print('=' * 74)
    print('%d ground(s) analyse(s)\n' % len(res))

    print('### GRILLES NON TRACEES : %d' % len(vides))
    for k, v in sorted(vides.items()):
        marque = '  [BOSS]' if v.get('boss') else ''
        print('    %-34s %s%s' % (k, v['etat'], marque))
    print()
    print('### ARENES DE BOSS CONCERNEES : %d' % len(bosses))
    print('### GROUNDS AVEC ENTITE HORS CARTE : %d' % len(horsl))
    for k, v in sorted(horsl.items())[:20]:
        print('    %-34s %s' % (k, ', '.join(v['hors'][:4])))

    if '--json' in sys.argv:
        out = sys.argv[sys.argv.index('--json') + 1]
        json.dump(res, open(out, 'w'), indent=1)
        print('\ndetail ecrit : %s' % out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
