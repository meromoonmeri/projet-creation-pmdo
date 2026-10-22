#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_scroll_classification.py — classification EXHAUSTIVE du défilement
des 213 CINEMATIC_BACKGROUND Sky (généralisation du pilote s13p05a).

Méthode (canonique, jamais visuelle) : recensement de TOUTES les ops
back_SetBackScrollSpeed/Offset des 3760 SSB décompilés, rattachées au
décor actif (dernier back_SetGround avant l'op). Un background sans
aucune op de scroll dans toute la ROM est PROUVÉ statique.

Par background défilant : scènes, vitesses (px/frame NDS), offsets.
Le compilateur V5+ traduit ces ops en mouvement de caméra continu
(convention du pilote SCROLL_RUNTIME_PASS : durée = distance/vitesse).

Sortie : PMD_SKY_EXPLORERS/Docs/SCROLL_CLASSIFICATION.json
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict, defaultdict

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
OUT = os.path.join(CAMP, 'Docs', 'SCROLL_CLASSIFICATION.json')


def main():
    cl = json.load(open(os.path.join(
        CAMP, 'Docs', 'GROUND_CLASSIFICATION.json')))['grounds']
    backgrounds = sorted(g for g, e in cl.items()
                         if e['category'] == 'CINEMATIC_BACKGROUND')
    scroll = defaultdict(lambda: {'speed_ops': [], 'offset_ops': []})
    for f in sorted(glob.glob(os.path.join(RS, '*.json.gz'))):
        zone = os.path.basename(f).split('.')[0]
        z = json.load(gzip.open(f, 'rt'))
        for name, s in z['scripts'].items():
            src = s.get('explorerscript') or ''
            if 'SetBackScroll' not in src:
                continue
            cur = zone.lower()
            for m in re.finditer(
                    r'back_SetGround\(LEVEL_([A-Z0-9_]+)\)|'
                    r'back_SetBackScroll(Speed|Offset)\(([^)]*)\)', src):
                if m.group(1):
                    cur = m.group(1).lower()
                else:
                    kind = ('speed_ops' if m.group(2) == 'Speed'
                            else 'offset_ops')
                    scroll[cur][kind].append(
                        {'scene': f'{zone}/{name}',
                         'args': m.group(3).strip()})
    entries = OrderedDict()
    n_scrolling = n_static = 0
    for g in backgrounds:
        e = scroll.get(g)
        if e and any(not re.match(r'^\s*0[\s.,0]*$', o['args'])
                     for o in e['speed_ops']):
            entries[g] = OrderedDict(
                status='SCROLLING',
                speed_ops=e['speed_ops'], offset_ops=e['offset_ops'],
                pmdo=('back_SetBackScrollSpeed/Offset -> caméra continue '
                      '(compilateur V5, convention pilote '
                      'SCROLL_RUNTIME_PASS)'))
            n_scrolling += 1
        else:
            entries[g] = OrderedDict(
                status='STATIC_PROVEN',
                evidence=('aucune op back_SetBackScrollSpeed non nulle '
                          'sur ce décor dans les 3760 SSB ROM'))
            n_static += 1
    # décors défilants HORS catégorie background (autres catégories)
    extra = {g: dict(v) for g, v in scroll.items() if g not in entries}
    doc = OrderedDict(
        schema='sky-scroll-classification/1',
        authority='3760 SSB décompilés ROM Sky EU — ops de scroll '
                  'rattachées au décor actif (dernier back_SetGround)',
        totals={'backgrounds': len(backgrounds),
                'SCROLLING': n_scrolling, 'STATIC_PROVEN': n_static,
                'scrolling_outside_background_category': len(extra)},
        backgrounds=entries,
        scrolling_other_categories=extra)
    json.dump(doc, open(OUT, 'w', encoding='utf-8'), ensure_ascii=False,
              indent=1)
    print(f'backgrounds: {len(backgrounds)} — SCROLLING: {n_scrolling}, '
          f'STATIC_PROVEN: {n_static}, hors catégorie: {len(extra)}')
    print('écrit:', OUT)


if __name__ == '__main__':
    main()
