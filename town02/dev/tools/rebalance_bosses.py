#!/usr/bin/env python3
"""Renivelage des boss ch6-10 vers le barème multi-sources (option a).

Barème : P2 (ch5-8) boss ~25 ; P3 (ch9-12) boss ~35.
Progression retenue : ch6 Zarude 27 -> ch7 Regigigas 28 -> ch8 Diancie 30
-> ch9 Laggron 32 -> ch10 Fulgur 33 / Lugia 35 (légendaire de fin d'arc).
Revanche Zarude (verdant_oath, post-ch6) : 30, légèrement au-dessus du boss d'histoire.

Les HP absolus sont recalés proportionnellement (référence : Magcargo L18 HP 150,
gardiens ch5 L20-22 bonus 190-210)."""
import json, io

PLAN = {
    'gloomy_forest_boss':     [('zarude',    27, 200,  80)],
    'verdant_oath_arena':     [('zarude',    30, 220,  90)],
    'cloven_ruins_boss':      [('regigigas', 28, 260, 120)],
    'crystal_sanctuary_boss': [('diancie',   30, 240, 100)],
    'forgotten_marsh_boss':   [('swampert',  32, 280, 120)],
    'celestial_peak_fulgur':  [('luxray',    33, 190,  40),
                               ('lucario',   33, 190,  40),
                               ('heliolisk', 33, 180,  30)],
    'celestial_peak_boss':    [('lugia',     35, 320, 150)],
}

for asset, plan in PLAN.items():
    p = f'Data/Map/{asset}.rsmap'
    d = json.load(open(p, encoding='utf-8-sig'))
    o = d['Object']
    by_species = {sp: (lvl, hp, bonus) for sp, lvl, hp, bonus in plan}
    changed = []
    for team in o['MapTeams']:
        for pl in team['Players']:
            sp = pl['CurrentForm']['Species']
            if sp in by_species:
                lvl, hp, bonus = by_species[sp]
                old = pl['Level']
                pl['Level'] = lvl
                pl['HP'] = hp
                pl['MaxHPBonus'] = bonus
                pl['EXP'] = 0
                changed.append(f'{sp} L{old}->L{lvl} HP={hp}+{bonus}')
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)
    print(f'{asset:26s}', '; '.join(changed))

print('== renivelage terminé ==')
