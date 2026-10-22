#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_build_actor_table.py — table GLOBALE des acteurs de scène Sky EU.

Source : les 1884 SSA/SSE/SSS décompilés (placements ROM). Pour chaque
ACTOR_NAME : l'entid (espèce monster.md) — vérifié UNIQUE sur toute la ROM
(0 ambiguïté) — et, par zone, la PREMIÈRE position de placement SSA
(x = x_relative*8 + x_offset*4, idem y ; direction SSA).

Usage compilateur : quand une scène référence un acteur absent de son
propre SSA (chargé par une autre scène de la zone, convention NDS), le
cast est résolu par cette table : espèce via entid→PMDO_MAPPING, position
canonique de zone. FAIL-CLOSED : pas d'entrée zone = pas de spawn.

Sortie : PMD_SKY_EXPLORERS/Docs/ACTOR_GLOBAL_TABLE.json
"""
import glob
import gzip
import json
import os
from collections import Counter, defaultdict, OrderedDict

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
OUT = os.path.join(CAMP, 'Docs', 'ACTOR_GLOBAL_TABLE.json')


def main():
    ent = defaultdict(Counter)
    zonepos = {}
    for f in sorted(glob.glob(os.path.join(RS, '*.json.gz'))):
        zone = os.path.basename(f).split('.')[0]
        z = json.load(gzip.open(f, 'rt'))
        for name, s in sorted(z['scripts'].items()):
            ssa = s.get('ssa')
            if not ssa:
                continue
            for layer in ssa['layers']:
                for a in layer.get('actors', []):
                    nm = a['actor_name']
                    ent[nm][a['entid']] += 1
                    if (zone, nm) not in zonepos:
                        p = a['pos']
                        zonepos[(zone, nm)] = [
                            p['x_relative'] * 8 + p.get('x_offset', 0) * 4,
                            p['y_relative'] * 8 + p.get('y_offset', 0) * 4,
                            p.get('direction') or 'Down']
    table = {nm: c.most_common(1)[0][0] for nm, c in ent.items()}
    amb = {nm: dict(c) for nm, c in ent.items() if len(c) > 1}
    doc = OrderedDict(
        schema='sky-actor-global-table/1',
        authority='SSA/SSE/SSS décompilés ROM Sky EU (placements exacts)',
        rule=('entid UNIQUE par acteur sur toute la ROM (vérifié) ; '
              'position = premier placement SSA de la zone ; FAIL-CLOSED: '
              'pas de placement zone = pas de spawn'),
        totals={'actors': len(table), 'ambiguous': len(amb),
                'zone_positions': len(zonepos)},
        entid=OrderedDict(sorted(table.items())),
        ambiguous=amb,
        zone_first_pos=OrderedDict(
            (f'{z}|{n}', v) for (z, n), v in sorted(zonepos.items())))
    json.dump(doc, open(OUT, 'w', encoding='utf-8'), ensure_ascii=False,
              indent=1)
    print(f"acteurs: {len(table)}, ambigus: {len(amb)}, "
          f"positions zone: {len(zonepos)}")
    print('écrit:', OUT)


if __name__ == '__main__':
    main()
