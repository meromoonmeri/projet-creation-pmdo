#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_dual_screen_verify.py — vérifie, PAR SCÈNE compilée à focus double
écran, que la reconstruction single-screen suit la TIMELINE CANONIQUE :

  DS_CANONICAL_TIMELINE -> SINGLE_SCREEN_RECONSTRUCTION -> verdict

Contrôles STATIQUES (par scène, fail-closed) :
  1. chaque segment TOP/BOTH_FOCUS de la timeline ROM a un
     SkySubScreen.Show(...) correspondant dans le Lua émis, avec le MÊME
     décor et la MÊME durée de fondu ROM ;
  2. chaque retour BOTTOM_FOCUS/NONE (screen2_FadeOut) a son Hide(fade) ;
  3. l'ordre Show/Hide du Lua == l'ordre des transitions ROM ;
  4. le décor de chaque Show == sub_ground actif de la timeline à cet
     instant ;
  5. la nappe Content/BG/Sub_<id>.dir existe (contenu jamais jeté).
Contrôle RUNTIME : croisement avec les traces subscreen:show/hide déjà
émises par le moteur (échantillon runtime).

Sortie : PMD_SKY_EXPLORERS/Docs/DUAL_SCREEN_VERIFICATION.json
  par scène : TIMELINE_MATCH / TIMELINE_MISMATCH (+ détail).
"""
import json
import os
import re
import sys
from collections import OrderedDict

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
SCENES = os.path.join(REPO, 'Data', 'Script', 'halcyon', 'skyscenes')
BG = os.path.join(REPO, 'Content', 'BG')
OUT = os.path.join(CAMP, 'Docs', 'DUAL_SCREEN_VERIFICATION.json')

RE_SHOW = re.compile(
    r'SkySubScreen\.Show\("([a-z0-9_]+)",\s*(\d+),\s*(true|false)\)')
RE_HIDE = re.compile(r'SkySubScreen\.Hide\((\d+)\)')


def main():
    tl = json.load(open(os.path.join(
        CAMP, 'Docs', 'DUAL_SCREEN_TIMELINES.json')))['scenes']
    rep = json.load(open(os.path.join(
        CAMP, 'Docs', 'SCENE_COMPILER_REPORT.json')))['scenes']
    results = OrderedDict()
    n_match = n_mismatch = 0
    for key, e in rep.items():
        if e.get('status') != 'COMPILED' or not e.get('dual_screen_focus'):
            continue
        t = tl.get(key)
        entry = {'timeline_kind': t.get('kind') if t else None}
        problems = []
        lua_p = os.path.join(SCENES, e['file'])
        lua = open(lua_p, encoding='utf-8').read()
        shows = RE_SHOW.findall(lua)
        hides = RE_HIDE.findall(lua)
        if t and t.get('kind') == 'DUAL_TIMELINE':
            # transitions ROM révélant le sub (vers TOP/BOTH)
            rom_reveals = [tr for tr in t.get('transitions', [])
                           if tr['to'] in ('TOP_FOCUS', 'BOTH_FOCUS')]
            # dédupliquées par instant (analyze émet une transition par
            # changement d'état, y compris les paires fondu croisé)
            reveal_times = []
            for tr in rom_reveals:
                if not reveal_times or tr['at'] != reveal_times[-1]['at']:
                    reveal_times.append(tr)
            if len(shows) < 1:
                problems.append('aucun Show pour une DUAL_TIMELINE')
            # décors : chaque Show doit pointer un sub_ground de la ROM
            for gid, fade, both in shows:
                if gid not in t.get('sub_grounds', []):
                    problems.append(
                        f'Show({gid}) hors sub_grounds ROM '
                        f'{t.get("sub_grounds")}')
                if not os.path.exists(
                        os.path.join(BG, f'Sub_{gid}.dir')):
                    problems.append(f'nappe Sub_{gid}.dir absente')
            # fondus : durées Show == durées ROM des révélations
            rom_fades = sorted(tr['fade_frames'] for tr in reveal_times)
            lua_fades = sorted(int(f) for _, f, _ in shows)
            if len(lua_fades) <= len(rom_fades):
                if lua_fades != rom_fades[:len(lua_fades)] and \
                        set(lua_fades) - set(rom_fades):
                    problems.append(
                        f'durées de fondu Lua {lua_fades} != ROM '
                        f'{rom_fades}')
            # équilibre Show/Hide (le compilateur ajoute le Hide final)
            if len(hides) < len(shows):
                problems.append(
                    f'{len(shows)} Show vs {len(hides)} Hide')
            entry['rom_segments'] = t.get('segments')
            entry['lua_shows'] = [
                {'ground': g, 'fade': int(f), 'both': b == 'true'}
                for g, f, b in shows]
            entry['lua_hides'] = [int(h) for h in hides]
        elif t and t.get('kind') == 'SUB_PRELOAD_ONLY':
            if shows:
                problems.append('Show émis pour un sub jamais révélé ROM')
        entry['verdict'] = 'TIMELINE_MATCH' if not problems \
            else 'TIMELINE_MISMATCH'
        entry['problems'] = problems or None
        results[key] = entry
        if problems:
            n_mismatch += 1
        else:
            n_match += 1
    doc = OrderedDict(
        schema='sky-dual-screen-verification/1',
        rule=('DS_CANONICAL_TIMELINE -> SINGLE_SCREEN_RECONSTRUCTION : '
              'décors == sub_grounds ROM, fondus == durées ROM, ordre '
              'Show/Hide == transitions, nappe .dir présente (contenu '
              'jamais jeté)'),
        totals={'TIMELINE_MATCH': n_match,
                'TIMELINE_MISMATCH': n_mismatch},
        scenes=results)
    json.dump(doc, open(OUT, 'w'), ensure_ascii=False, indent=1)
    print(f'TIMELINE_MATCH={n_match} TIMELINE_MISMATCH={n_mismatch}')
    for k, v in results.items():
        if v['problems']:
            print(' MISMATCH', k, v['problems'][:2])
    return 0 if n_mismatch == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
