#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""inventaire_grounds — inventaire complet des grounds implementes.

METHODE
-------
On ne classe PAS par suffixe de nom : 187 des 277 grounds ne suivent
aucune convention lisible (abime_tempetes, altere_pond, gue_poulain_autel...).
On classe par SIGNATURE FONCTIONNELLE, relevee dans les scripts :

  ENTRANCE   le script appelle GAME:EnterDungeon      -> on entre en donjon
  ARENE      DefeatedBoss / Boss_Marker / BossTransition
  RELAIS     Kangaskhan_Rock (soin/stockage/sauvegarde) ou MidpointTemplate
  CINE       aucune des trois : ground de cinematique ou de ville

Un ground peut cumuler (une entrance a souvent un rocher). L'ordre de
priorite du classement est : ARENE > ENTRANCE > RELAIS > CINE, car c'est
la fonction la plus structurante qui nomme la carte.

Trois colonnes de controle complètent l'inventaire :
  zone       le ground est-il declare dans les Grounds d'une zone ?
             (sinon EnterGroundMap echoue : « Invalid Ground Map Name »)
  collision  la grille obstacles est-elle tracee ?
  entites    combien, et y en a-t-il hors des limites ?

Usage :
    python3 tools/inventaire_grounds.py <dir_scripts_ground> \\
            [--rsground DIR] [--zones index.idx] [--md sortie.md]
"""
import json
import os
import re
import sys


def signature(dossier):
    src = ''
    for f in sorted(os.listdir(dossier)):
        if f.endswith('.lua'):
            try:
                src += open(os.path.join(dossier, f), encoding='utf-8',
                            errors='replace').read() + '\n'
            except Exception:
                pass
    return {
        'entrance': bool(re.search(r'EnterDungeon', src)),
        'arene': bool(re.search(r'DefeatedBoss|Boss_Marker|BossTransition', src)),
        'relais': bool(re.search(r'Kangaskhan_Rock|MidpointTemplate|RelayScenes', src)),
        'zones': sorted(set(re.findall(r"EnterDungeon\(\s*[\"']([\w]+)[\"']", src))),
        'lignes': src.count('\n'),
    }


def classe(s):
    # Un RELAIS possede presque toujours une entrance vers la seconde
    # moitie du donjon : le tester AVANT l'entrance, sinon les 48 relais
    # du mod disparaissent dans la categorie ENTRANCE.
    if s['relais']:
        return 'RELAIS'
    if s['arene']:
        return 'ARENE'
    if s['entrance']:
        return 'ENTRANCE'
    return 'CINE'


def collisions(path):
    """(etat, W, H, nb_entites, nb_hors_carte) ou None si fichier absent."""
    if not path or not os.path.isfile(path):
        return None
    try:
        obj = json.load(open(path, encoding='utf-8-sig'))
        obj = obj.get('Object', obj)
    except Exception:
        return None
    ob = obj.get('obstacles') or []
    W = len(ob)
    H = len(ob[0]) if W else 0
    if not W or not H:
        return ('SANS GRILLE', 0, 0, 0, 0)
    libres = sum(1 for col in ob for c in col
                 if (c.get('Tags') if isinstance(c, dict) else c) == 0)
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
    hors = sum(1 for _, x, y in ents
               if not (0 <= x // 8 < W and 0 <= y // 8 < H))
    if libres == W * H:
        etat = 'NON TRACEE (tout libre)'
    elif libres == 0:
        etat = 'NON TRACEE (tout bloque)'
    else:
        etat = '%d%% libre' % (100 * libres // (W * H))
    return (etat, W, H, len(ents), hors)


def main():
    base = sys.argv[1]
    rsdir = None
    zpath = None
    md = None
    if '--rsground' in sys.argv:
        rsdir = sys.argv[sys.argv.index('--rsground') + 1]
    if '--zones' in sys.argv:
        zpath = sys.argv[sys.argv.index('--zones') + 1]
    if '--md' in sys.argv:
        md = sys.argv[sys.argv.index('--md') + 1]

    declare = set()
    if zpath and os.path.isfile(zpath):
        z = json.load(open(zpath, encoding='utf-8-sig'))
        z = z.get('Object', z)
        for k, v in z.items():
            if isinstance(v, dict):
                for n in (v.get('Grounds') or []):
                    declare.add(n)

    lignes = []
    for n in sorted(os.listdir(base)):
        d = os.path.join(base, n)
        if not os.path.isdir(d):
            continue
        s = signature(d)
        col = collisions(os.path.join(rsdir, n + '.rsground')) if rsdir else None
        lignes.append((n, classe(s), s, col, n in declare if declare else None))

    par = {}
    for l in lignes:
        par.setdefault(l[1], []).append(l)

    out = []
    w = out.append
    w('# Inventaire des grounds implementes\n')
    w('%d grounds scriptes.\n' % len(lignes))
    w('| Categorie | Nombre |')
    w('|---|---:|')
    for k in ('ENTRANCE', 'ARENE', 'RELAIS', 'CINE'):
        w('| %s | %d |' % (k, len(par.get(k, []))))
    w('')

    for k in ('ENTRANCE', 'ARENE', 'RELAIS', 'CINE'):
        grp = par.get(k, [])
        if not grp:
            continue
        w('\n## %s — %d\n' % (k, len(grp)))
        w('| ground | zone declaree | collision | entites | donjon cible |')
        w('|---|:-:|---|---:|---|')
        for n, _, s, col, dec in grp:
            z = '-' if dec is None else ('oui' if dec else '**NON**')
            if col is None:
                c, e = 'rsground absent', ''
            else:
                c = col[0]
                e = str(col[3]) + (' (%d hors)' % col[4] if col[4] else '')
            w('| `%s` | %s | %s | %s | %s |'
              % (n, z, c, e, ', '.join(s['zones'][:2]) or '-'))

    txt = '\n'.join(out)
    if md:
        open(md, 'w', encoding='utf-8').write(txt)
        print('ecrit :', md)
    else:
        print(txt)
    return 0


if __name__ == '__main__':
    sys.exit(main())
