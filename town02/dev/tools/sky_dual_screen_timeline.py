#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_dual_screen_timeline.py — reconstitue la TIMELINE DE FOCUS des
scènes double écran NDS de PMD Sky EU, depuis les données CANONIQUES
(ExplorerScript décompilé de la ROM, jamais une approximation visuelle).

Modèle NDS (main_EnterGround → écran du bas = jeu ; back2_* → écran du
haut) :
  * back2_SetGround(LEVEL_X) charge le décor X sur l'écran SUB ;
  * screen2_FadeIn(mode, durée) le RÉVÈLE ; screen2_FadeOut le cache ;
  * l'écran MAIN suit screen_FadeIn/FadeOut. Les deux écrans étant
    physiquement visibles, le focus canonique à un instant t est :
      - BOTTOM_FOCUS : main visible, sub caché/noir ;
      - TOP_FOCUS    : sub visible, main caché/noir ;
      - BOTH_FOCUS   : les deux révélés (le joueur voit les deux) ;
      - NONE         : les deux noirs (transition).
  * Le curseur temporel avance avec Wait(n) et les durées de fondu.

Sortie : PMD_SKY_EXPLORERS/Docs/DUAL_SCREEN_TIMELINES.json
  { "ZONE/scene.ssb": {
      "sub_grounds": ["v01p03a", ...],
      "segments": [ {"from":0,"to":120,"focus":"BOTTOM_FOCUS"}, ... ],
      "transitions": [ {"at":120,"kind":"FOCUS_TRANSITION",
                        "fade_frames":120}, ...] } }

Chaque valeur de frame provient des arguments ROM (Wait/durées de fade).
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
OUT = os.path.join(CAMP, 'Docs', 'DUAL_SCREEN_TIMELINES.json')

# ops consommant du temps ou changeant l'état des écrans
RE_STMT = re.compile(
    r'\b(Wait|screen_FadeIn|screen_FadeOut|screen_FadeInAll|'
    r'screen_FadeOutAll|screen_FlushIn|screen_FlushOut|screen_WhiteOut|'
    r'screen_WhiteChange|screen2_FadeIn|screen2_FadeOut|screen2_FlushIn|'
    r'screen2_FlushOut|screen2_WhiteOut|screen2_FadeChange|'
    r'screen2_WhiteChange|back2_SetGround|back_SetGround|back2_SetMode|'
    r'WaitScreenFadeAll|WaitScreenFade|WaitScreen2Fade|WaitSubScreen|'
    r'WaitLockSupervision|main_EnterGround)\s*\(([^)]*)\)')


def last_int(args, default=0):
    nums = re.findall(r'-?\d+', args)
    return int(nums[-1]) if nums else default


def analyze(src):
    """Timeline de focus à partir du def 0 (routine principale)."""
    # isoler def 0
    m = re.search(r'def\s+0\s*\{', src)
    if not m:
        return None
    depth = 0
    i = m.end() - 1
    start = m.end()
    while i < len(src):
        if src[i] == '{':
            depth += 1
        elif src[i] == '}':
            depth -= 1
            if depth == 0:
                break
        i += 1
    body = src[start:i]
    # retirer littéraux (dialogues)
    body = re.sub(r'\{[^{}()]*english\s*=(?:[^{}]|\{[^{}]*\})*\}', '{}',
                  body)

    t = 0                      # curseur frames ROM
    main_on = False            # écran principal révélé
    sub_on = False             # écran sub révélé
    sub_ground = None
    sub_grounds = []
    segments = []
    transitions = []
    pending_sub_fade = 0
    seg_start = 0

    def focus():
        if main_on and sub_on:
            return 'BOTH_FOCUS'
        if sub_on:
            return 'TOP_FOCUS'
        if main_on:
            return 'BOTTOM_FOCUS'
        return 'NONE'

    cur = focus()

    def switch(new, fade):
        nonlocal cur, seg_start
        if new == cur:
            return
        segments.append({'from': seg_start, 'to': t, 'focus': cur})
        transitions.append({'at': t, 'kind': 'FOCUS_TRANSITION',
                            'to': new, 'fade_frames': fade})
        seg_start = t
        cur = new

    for mo in RE_STMT.finditer(body):
        op, args = mo.group(1), mo.group(2)
        if op == 'Wait':
            t += last_int(args)
        elif op in ('screen_FadeIn', 'screen_FadeInAll', 'screen_FlushIn'):
            main_on = True
            switch(focus(), last_int(args))
        elif op in ('screen_FadeOut', 'screen_FadeOutAll',
                    'screen_FlushOut', 'screen_WhiteOut'):
            main_on = False
            switch(focus(), last_int(args))
        elif op == 'screen_WhiteChange':
            main_on = True
            switch(focus(), last_int(args))
        elif op in ('screen2_FadeIn', 'screen2_FlushIn',
                    'screen2_FadeChange', 'screen2_WhiteChange'):
            sub_on = True
            switch(focus(), last_int(args))
        elif op in ('screen2_FadeOut', 'screen2_FlushOut',
                    'screen2_WhiteOut'):
            sub_on = False
            switch(focus(), last_int(args))
        elif op == 'back2_SetGround':
            g = re.search(r'LEVEL_([A-Z0-9_]+)', args)
            if g:
                sub_ground = g.group(1).lower()
                if sub_ground not in sub_grounds:
                    sub_grounds.append(sub_ground)
        elif op == 'main_EnterGround':
            main_on = True
            switch(focus(), 0)
    segments.append({'from': seg_start, 'to': t, 'focus': cur})
    # sub_ever_shown se déduit des TRANSITIONS (changements d'état ROM),
    # pas des segments : une scène sans Wait() explicite passe son temps
    # dans les dialogues (durée non scriptée) — les segments 0-frame
    # restent des révélations réelles du sub.
    ever = any(tr['to'] in ('TOP_FOCUS', 'BOTH_FOCUS')
               for tr in transitions)
    # compacter les segments vides (info timeline ; les transitions font
    # foi pour l'ordre)
    segments = [s for s in segments if s['to'] > s['from']
                or s is segments[-1]]
    return OrderedDict(
        sub_grounds=sub_grounds,
        total_frames=t,
        note=('durées = Wait()+fondus ROM ; le temps des boîtes de '
              'dialogue (non scripté) ne compte pas — l\'ordre des '
              'transitions fait foi'),
        segments=segments,
        transitions=transitions,
        sub_ever_shown=ever)


def main():
    ci = json.load(open(os.path.join(
        CAMP, 'Docs', 'CINEMATIC_INTEGRABILITY.json')))['scenes']
    targets = [k for k, v in ci.items()
               if v['classification'] == 'PARTIAL_FIDELITY']
    out = OrderedDict()
    stats = {'DUAL_TIMELINE': 0, 'SUB_PRELOAD_ONLY': 0, 'NO_DUAL_OPS': 0}
    zc = {}
    for key in sorted(targets):
        zone, name = key.split('/')
        if zone not in zc:
            zc[zone] = json.load(gzip.open(
                os.path.join(RS, zone + '.json.gz'), 'rt'))
        src = zc[zone]['scripts'][name].get('explorerscript') or ''
        has2 = bool(re.search(
            r'\b(back2_|screen2_|bgm2_|camera2_|WaitSubScreen|'
            r'WaitScreen2|WaitBgm2)', src))
        if not has2:
            stats['NO_DUAL_OPS'] += 1
            out[key] = {'kind': 'NO_DUAL_OPS'}
            continue
        tl = analyze(src)
        if tl is None:
            out[key] = {'kind': 'NO_DEF0'}
            continue
        if tl['sub_ever_shown']:
            stats['DUAL_TIMELINE'] += 1
            out[key] = OrderedDict(kind='DUAL_TIMELINE', **tl)
        else:
            stats['SUB_PRELOAD_ONLY'] += 1
            out[key] = OrderedDict(kind='SUB_PRELOAD_ONLY',
                                   sub_grounds=tl['sub_grounds'])
    doc = OrderedDict(
        schema='sky-dual-screen-timelines/1',
        authority='ExplorerScript décompilé ROM Sky EU (def 0) — curseur '
                  'temporel = Wait()+durées de fondu ROM ; focus = état '
                  'révélé des écrans main/sub (screen_/screen2_)',
        rule='TOP_FOCUS=sub seul révélé, BOTTOM_FOCUS=main seul, '
             'BOTH_FOCUS=les deux, NONE=noir ; FOCUS_TRANSITION porte la '
             'durée de fondu ROM',
        totals=stats,
        scenes=out)
    json.dump(doc, open(OUT, 'w', encoding='utf-8'), ensure_ascii=False,
              indent=1)
    print('totals:', stats)
    print('écrit:', OUT)


if __name__ == '__main__':
    main()
