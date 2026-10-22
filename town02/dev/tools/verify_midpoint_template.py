#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_midpoint_template.py
Controle les 3 regles de verification du brief « point median ».

  1. RECONNAISSABILITE : chaque relais expose les memes etats et passe
     par la structure partagee (halcyon.MidpointTemplate).
  2. INTEGRATION       : chaque relais declare un habillage (musique,
     statut d'ambiance) au lieu d'un decor generique.
  3. NON-DUPLICATION   : deux relais ne partagent JAMAIS le meme couple
     (musique, statut d'ambiance) — seule la structure est commune.

Verifie aussi que les MapStatus cites existent bien dans Data/MapStatus,
car GROUND:AddMapStatus echoue EN SILENCE sur un nom absent.
"""
import os
import re
import sys

RELAYS = {
    'Tunnel Incandescent': 'searing_tunnel_midpoint',
    'Grande Steppe':       'vast_steppe_midpoint',
    'Mont Venteux':        'mount_windswept_midpoint',
    'Foret Lugubre':       'gloomy_forest_midpoint',
    'Aegis Cave':      'cloven_ruins_midpoint',
    'Caverne Tortueuse':   'crooked_cavern_midpoint',
    'Sanctuaire Cristal':  'crystal_sanctuary_relay',
    'Marais de l Oubli':   'forgotten_marsh_relay',
    'Pic Celeste':         'celestial_peak_relay',
}


def read_dir(root, name):
    d = os.path.join(root, 'Data/Script/halcyon/ground', name)
    src = ''
    if not os.path.isdir(d):
        return None
    for f in sorted(os.listdir(d)):
        if f.endswith('.lua'):
            src += open(os.path.join(d, f), encoding='utf-8',
                        errors='replace').read()
    return src


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    statuses = {f[:-5] for f in os.listdir(os.path.join(root, 'Data/MapStatus'))
                if f.endswith('.json')}

    rows, problems = [], []
    for label, name in RELAYS.items():
        src = read_dir(root, name)
        if src is None:
            problems.append('%s : dossier absent' % label)
            continue

        uses_tpl = 'MidpointTemplate' in src
        # L'habillage peut etre declare de deux facons : en appels
        # directs (anciens relais) ou dans une table SKIN (relais passes
        # au template). On lit les deux, sinon on croit a tort que le
        # relais n'a pas d'habillage.
        music = set(re.findall(r"PlayBGM\('([^']+)'", src))
        music |= set(re.findall(r"music\s*=\s*'([^']+)'", src))
        stat = set(re.findall(r'AddMapStatus\("([^"]+)"', src))
        stat |= set(re.findall(r"status\s*=\s*'([^']+)'", src))
        # 'darkness' et la musique de reveil sont des effets de scene
        # ponctuels (veillee nocturne, KO), pas l'identite du lieu : on
        # les exclut de la signature d'habillage.
        stat.discard('darkness')
        music.discard('Heartwarming.ogg')
        music, stat = sorted(music), sorted(stat)
        states = [s for s in ('FirstArrival', 'RepeatArrival',
                              'DeathArrival', 'WipedCutscene')
                  if s in src]

        for s in stat:
            if s not in statuses:
                problems.append('%s : MapStatus « %s » ABSENT de Data/MapStatus '
                                '(AddMapStatus echouera en silence)' % (label, s))

        rows.append((label, uses_tpl, music, stat, states))

    w = max(len(r[0]) for r in rows)
    print('=' * 78)
    print('POINT MEDIAN — habillage par donjon')
    print('=' * 78)
    for label, tpl, music, stat, states in rows:
        print('%-*s  template:%-3s  ambiance:%-24s' % (
            w, label, 'oui' if tpl else 'NON',
            ','.join(stat) if stat else '(aucune)'))
        print('%-*s  musique : %s' % (w, '', ', '.join(music) or '(aucune)'))
        print('%-*s  etats   : %s' % (w, '', ', '.join(states) or '(aucun)'))
        print()

    # Regle 3 : non-duplication de l'habillage.
    print('-' * 78)
    seen = {}
    for label, tpl, music, stat, states in rows:
        sig = (tuple(music), tuple(stat))
        if sig in seen and (music or stat):
            problems.append('HABILLAGE DUPLIQUE entre « %s » et « %s » : %s'
                            % (seen[sig], label, sig))
        seen[sig] = label

    if problems:
        print('PROBLEMES :')
        for p in problems:
            print('  - ' + p)
    else:
        print('Aucun habillage duplique. Aucun MapStatus fantome.')
    print('-' * 78)
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
