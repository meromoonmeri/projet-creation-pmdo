#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_red_anim.py — Audit rigoureux des animations PMD Red en jeu.

Pour chaque ground Red utilisé dans le jeu (Data/Ground), compare les
animations NATIVES (pret/pmd-red) avec l'import actuel :
  - BPA (tuiles animées) : presence, frames, durees
  - BPL palette animation (eau/lave/braises/…) : hasPalAnimations, specs
  - frames actuellement encodées dans le .rsground (par tuile)
"""
import json
import os
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RED = '/tmp/pmd-red/data/map_bg'
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from convert_red_all import parse_bpl

GROUNDS = {
    'a02p01': ('A02P01', None), 'a02p02': ('A02P02', None),
    'a02p03': ('A02P03', None), 'a02p04': ('A02P04', None),
    'a04p01': ('A04P01', 'A04P011'),
    'a05p03': ('A05P03', None),
    'arc_palier_celeste': ('D13P02', None), 'arc_parvis_celeste': ('D13P01', None),
    'arc_tour_ciel_sommet': ('D13P03', None),
    'sinister_woods_clearing': ('D04P02', None), 'gloomy_forest_entrance': ('D04P01', None),
    'd09p02': ('D09P02', None), 'd09p03': ('D09P03', None),
    'd10p02': ('D10P02', None), 'd10p03': ('D10P03', None),
    'd11p02': ('D11P02', None), 'd11p03': ('D11P03', None),
    'foret_givree_oree': ('D10P01', None),
    'fosse_ardente': ('D12P04', None),
    'gloomy_forest_boss': ('D04P02', None), 'gloomy_forest_entrance': ('D04P01', None),
    'gorge_ardente_coeur': ('D12P02', None), 'gorge_ardente_porte': ('D12P01', None),
    'grotte_lazuli_fond': ('D08P02', None), 'grotte_lazuli_seuil': ('D08P01', None),
    'mont_cendre_pied': ('D09P01', None), 'mont_gele_pied': ('D11P01', None),
    'mount_windswept_guardian': ('D18P01', None),
    'palier_celeste': ('D13P02', None), 'parvis_celeste': ('D13P01', None),
    'tour_ciel_sommet': ('D13P03', None),
    'poisonous_forest_boss': ('H12P01', 'H12P011'),
    'pre_tonnerre': ('H17P01', None),
    'sanctuaire_voeu': ('D23P01', None),
    't01p01': ('T01P01', 'T01P011'),
}


def ground_frames(ground):
    p = os.path.join(ROOT, 'Data', 'Ground', ground + '.rsground')
    o = json.load(open(p, encoding='utf-8-sig'))['Object']
    nf = 0
    fls = set()
    n_animated_cells = 0
    for L in o.get('Layers', []):
        for col in L.get('Tiles', []):
            for t in col:
                if not isinstance(t, dict):
                    continue
                for tl in t.get('Layers', []):
                    frs = tl.get('Frames', [])
                    if len(frs) > 1:
                        n_animated_cells += 1
                    nf = max(nf, len(frs))
                    fls.add(tl.get('FrameLength', 60))
    return nf, n_animated_cells, sorted(fls)


def main():
    print('%-24s %-8s %-10s %-30s %-8s %-10s %s' % (
        'ground', 'bpa', 'palette anim', 'frames RS', 'FL', 'cell.anim', 'CONFORME'))
    n_ok = 0
    for ground in sorted(GROUNDS):
        bpl_id, bpa_id = GROUNDS[ground]
        bpl_path = os.path.join(RED, bpl_id + '.bpl')
        if not os.path.exists(bpl_path):
            print('%-24s FICHIER SOURCE ABSENT %s' % (ground, bpl_path))
            continue
        _, specs, anim_pals = parse_bpl(bpl_path)
        nf, ncells, fls = ground_frames(ground)
        anim_desc = ['P%d:%dx%d' % (i, d, n) for i, (d, n) in enumerate(specs) if n > 0]
        has_anim_source = bool(anim_desc) or bool(bpa_id)
        problems = []
        if has_anim_source and ncells == 0:
            problems.append('animation source mais 0 cellule animée')
        if nf > 1:
            if 1 not in fls:
                if anim_desc:
                    dur0 = specs[[i for i, s in enumerate(specs) if s[1] > 0][0]][0]
                    if dur0 not in fls:
                        problems.append('palette durée %d != FL %s' % (dur0, fls))
        ok = 'OK' if not problems else 'NON CONFORME: ' + '; '.join(problems)
        if not problems:
            n_ok += 1
        print('%-24s %-8s %-10s %-30s %-8s %-10s %s' % (
            ground, bpa_id or '—', '; '.join(anim_desc)[:28] or '—', str(nf), str(fls[:4]), str(ncells), ok))
    print('CONFORMES:', n_ok, '/', len(GROUNDS))


if __name__ == '__main__':
    main()
