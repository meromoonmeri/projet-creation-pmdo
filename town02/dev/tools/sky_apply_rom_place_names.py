#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_apply_rom_place_names.py — applique les noms de lieux CANONIQUES ROM
(bloc ppmdu 'Ground Map Names' EU, extrait dans LEVEL_HUMAN_NAMES.json) aux
grounds du MANIFEST Sky.

Règles :
  * autorité = ROM ; le nom humain du manifest devient le nom ROM (EN/FR)
    quand le level lié au map_bg possède un nom de lieu dans le bloc.
  * l'ancien nom (ID brut ou libellé projet) est conservé dans
    'previous_human_name' quand il diffère — rien n'est perdu.
  * grounds sans nom ROM (variantes non référencées par un level, panoramas
    '???') : inchangés, marqués 'rom_place_name': None.
  * marquage NDS [M:D1]/[F:E]/[CS..] nettoyé pour lisibilité, original
    conservé dans rom_place_name_raw.
"""
import json
import os
import re

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
MAN_P = os.path.join(CAMP, 'MANIFEST.json')
NAMES_P = os.path.join(CAMP, 'Docs', 'LEVEL_HUMAN_NAMES.json')


def clean(s):
    if s is None:
        return None
    s = re.sub(r'\[[^\]]*\]', '', s).strip()
    return s or None


def main():
    with open(MAN_P, encoding='utf-8') as f:
        man = json.load(f)
    with open(NAMES_P, encoding='utf-8') as f:
        levels = json.load(f)['levels']

    bg2names = {}
    for lvl, e in levels.items():
        bg = e.get('map_bg')
        pn = e.get('place_name')
        if bg and pn:
            bg2names.setdefault(bg, []).append(
                {'level': lvl, 'en': pn['en'], 'fr': pn['fr']})

    n_applied = n_kept = n_none = 0
    for g in man['grounds']:
        src = g.get('source_comment') or ''
        mm = re.search(r'->\s*([a-z0-9_]+)', src)
        bg = mm.group(1) if mm else g['ground']
        cands = bg2names.get(bg)
        if not cands:
            g['rom_place_name'] = None
            n_none += 1
            continue
        # tous les levels d'un même bg partagent normalement le même nom ;
        # sinon on liste toutes les possibilités (ambiguïté documentée)
        uniq = {(c['en'], c['fr']) for c in cands}
        en_raw, fr_raw = sorted(uniq)[0]
        g['rom_place_name'] = {
            'en': clean(en_raw), 'fr': clean(fr_raw),
            'raw': {'en': en_raw, 'fr': fr_raw},
            'levels': sorted(c['level'] for c in cands),
            'ambiguous': sorted(f'{e}|{f}' for e, f in uniq)
            if len(uniq) > 1 else None,
        }
        en_c, fr_c = clean(en_raw), clean(fr_raw)
        if en_c and en_c not in ('???',):
            old_en, old_fr = g.get('human_name_en'), g.get('human_name_fr')
            if old_en != en_c or old_fr != fr_c:
                g['previous_human_name'] = {'en': old_en, 'fr': old_fr}
                g['human_name_en'] = en_c
                g['human_name_fr'] = fr_c
                n_applied += 1
            else:
                n_kept += 1
        else:
            n_kept += 1

    man['human_names_authority'] = (
        "bloc ROM 'Ground Map Names' EU (base 16256, preuve croisée "
        "G01P01A=Wigglytuff's Guild/Guilde de Grodoudou) via "
        "Docs/LEVEL_HUMAN_NAMES.json")
    with open(MAN_P, 'w', encoding='utf-8') as f:
        json.dump(man, f, ensure_ascii=False, indent=1)
    print(f'appliqués: {n_applied}, déjà exacts/sans nom lisible: {n_kept}, '
          f'sans nom ROM: {n_none}')


if __name__ == '__main__':
    main()
