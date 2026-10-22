#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_red_anim_report.py — Rapport exhaustif des animations PMD Red (245 maps).

Source : RESERVE/red_manifest.json (généré par convert_red_all.py).
Pour chaque map : source, type d'animation, tuiles animées, frames, conformité.
Usage : python3 tools/gen_red_anim_report.py"""
import json
import os
import struct

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def cell_stats(asset):
    try:
        o = json.load(open(os.path.join(ROOT, 'RESERVE', 'red_grounds', asset + '.rsground'),
                           encoding='utf-8-sig'))['Object']
    except Exception:
        return 0, 0
    raw = open(os.path.join(ROOT, 'RESERVE', 'red_tiles', asset + '_Base.tile'), 'rb').read()
    ts, cnt = struct.unpack_from('<II', raw, 0)
    keys = {}
    for i in range(cnt):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        ln = struct.unpack_from('<q', raw, off)[0]
        keys[(key & 0xFFFFFFFF, key >> 32)] = raw[off + 8:off + 8 + ln]
    maxf = 0
    anim = 0
    for L in o.get('Layers', []):
        for col in L.get('Tiles', []):
            for t in col:
                if not isinstance(t, dict):
                    continue
                for tl in t.get('Layers', []):
                    frs = tl.get('Frames', [])
                    maxf = max(maxf, len(frs))
                    if len(frs) > 1:
                        pngs = {keys.get((fr['TexLoc']['X'], fr['TexLoc']['Y'])) for fr in frs}
                        if len(pngs) > 1:
                            anim += 1
    return maxf, anim


def main():
    man = json.load(open(os.path.join(ROOT, 'RESERVE', 'red_manifest.json'), encoding='utf-8'))
    lines = []
    lines.append('# AUDIT ANIMATIONS PMD RED — 245 MAPS (2026-08-07)')
    lines.append('')
    lines.append('Source : pret/pmd-red (data/map_bg) via `map_dependencies.json` du port')
    lines.append('officiel (triplets bpl/bpc/bma/bpa exacts). Rendu EXACT par tick :')
    lines.append('BPA (tuiles animées, slots multiples) + animation de palette BPL,')
    lines.append('couches BMA multiples, FrameLength = durée native (repli pgcd exact).')
    lines.append('')
    lines.append('| Map | Source (bpl) | Animation native | Période (ticks) | Frames max | Cellules animées | Conforme |')
    lines.append('|---|---|---|---|---|---|---|')
    n_anim = 0
    n_total = 0
    problems = []
    for r in sorted(man, key=lambda x: x['asset']):
        n_total += 1
        asset = r['asset']
        desc = '; '.join(r.get('desc', [])) if r.get('desc') else '—'
        maxf, cells = cell_stats(asset)
        conform = True
        if r.get('anim'):
            n_anim += 1
            if cells == 0:
                conform = False
                problems.append((asset, 'source animée mais 0 cellule animée'))
        lines.append('| %s | %s | %s | %d | %d | %d | %s |' % (
            asset, r.get('source', r['asset']), desc[:60] or '—', r.get('L', 1), maxf, cells,
            'OK' if conform else 'NON CONFORME'))
    lines.append('')
    lines.append('## Synthèse')
    lines.append('')
    lines.append('- Maps converties : %d' % n_total)
    lines.append('- Maps avec animation native (BPA et/ou palette) : %d' % n_anim)
    lines.append('- Maps sans animation native : %d (frame unique, conforme)' % (n_total - n_anim))
    lines.append('- Problèmes : %d' % len(problems))
    for p in problems:
        lines.append('  - %s : %s' % p)
    lines.append('')
    lines.append('## Types d\'animation détectés')
    lines.append('')
    lines.append('Les descriptions `P%d:%dx%d` = palette %d (durée %d ticks, %d frames) ;')
    lines.append('`BPA:%dfx%d` = tuiles BPA (%d frames, durée %d).')
    lines.append('')
    open(os.path.join(ROOT, 'docs', 'AUDIT_ANIMATIONS_PMD_RED_2026-08-07.md'), 'w',
         encoding='utf-8').write('\n'.join(lines))
    print('rapport écrit : %d maps, %d animées, %d problèmes' % (n_total, n_anim, len(problems)))


if __name__ == '__main__':
    main()
