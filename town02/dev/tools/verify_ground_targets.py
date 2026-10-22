#!/usr/bin/env python3
"""verify_ground_targets — controle les index de ground ecrits en dur.

MOTIF
-----
Le Camp des Ruines ne jouait jamais sa cinematique d'arrivee : la zone
cloven_ruins renvoyait le joueur sur master_zone ground 65, en croyant
viser cloven_ruins_entrance. Or 65 = vast_steppe_midpoint ; le vrai index
etait 67. Les flags etaient bons, la carte d'arrivee non.

Ce defaut est invisible a la compilation, invisible a audit_bugs, et se
reproduit des qu'une carte est inseree dans master_zone.GroundMaps : tous
les index suivants glissent d'un cran.

METHODE
-------
Pour chaque zone/<nom>/init.lua, on releve les appels
    EnterZone / EndDungeonRun / EndSession / EndDungeonDay ("<zone>", -1, N, ...)
et on rapproche l'index N du nom de ground reellement present a cette
position dans Data/Zone/index.idx. On signale quand le nom obtenu n'a
aucun rapport avec la zone appelante — heuristique volontairement prudente
pour ne pas crier au loup sur les retours en ville, qui sont legitimes.

Usage : python3 tools/verify_ground_targets.py .
"""
import json
import os
import re
import sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'
IDX = os.path.join(ROOT, 'Data', 'Zone', 'index.idx')
ZDIR = os.path.join(ROOT, 'Data', 'Script')

# Retours volontaires vers un hub : jamais suspects.
HUBS = {'metano_town', 'metano_town_nuit', 'guild_heros_room', 'metano_cafe',
        'guild_main_hall', 'metano_inn'}

CALLS = r'(?:EnterZone|EndDungeonRun|EndSession|EndDungeonDay)\('


def main():
    idx = json.load(open(IDX, encoding='utf-8-sig'))
    idx = idx.get('Object', idx)

    suspects = []
    checked = 0

    for ns in sorted(os.listdir(ZDIR)):
        zdir = os.path.join(ZDIR, ns, 'zone')
        if not os.path.isdir(zdir):
            continue
        for zname in sorted(os.listdir(zdir)):
            f = os.path.join(zdir, zname, 'init.lua')
            if not os.path.isfile(f):
                continue
            src = open(f, encoding='utf-8', errors='replace').read()
            src = re.sub(r'--\[(=*)\[.*?\]\1\]', '', src, flags=re.S)
            src = '\n'.join(re.sub(r'--.*$', '', l) for l in src.split('\n'))

            for m in re.finditer(
                    CALLS + r'[^)]*?["\'](\w+)["\']\s*,\s*-1\s*,\s*(\d+)\s*,', src):
                target_zone, n = m.group(1), int(m.group(2))
                entry = idx.get(target_zone)
                if not isinstance(entry, dict):
                    continue
                grounds = entry.get('Grounds') or []
                checked += 1
                if n >= len(grounds):
                    suspects.append((zname, target_zone, n, 'INDEX HORS BORNES',
                                     '%d grounds' % len(grounds)))
                    continue
                got = grounds[n]
                if got in HUBS:
                    continue
                # heuristique : le ground vise devrait partager la racine du
                # nom de la zone appelante (cloven_ruins -> cloven_ruins_*).
                root = zname.split('_')[0]
                if not got.startswith(zname) and not got.startswith(root):
                    suspects.append((zname, target_zone, n,
                                     'ground etranger a la zone', got))

    print('=' * 78)
    print('verify_ground_targets — index de ground ecrits en dur'.center(78))
    print('=' * 78)
    print('%d cible(s) examinee(s)\n' % checked)

    if not suspects:
        print('RESULTAT : aucune cible suspecte.')
        return 0

    print('### CIBLES SUSPECTES : %d\n' % len(suspects))
    for z, tz, n, why, got in suspects:
        print('    zone/%-22s -> %s[%d] : %s' % (z, tz, n, why))
        print('        %s' % got)
    print()
    print('Verifier chaque cas : un retour deliberé vers une autre zone est')
    print('legitime, un index qui a glisse ne l est pas.')
    return 1


if __name__ == '__main__':
    sys.exit(main())
