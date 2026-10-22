#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ADD-ON « Réseau des Anciens Chemins » v2 — les 12 DERNIERS donjons de
pret/pmd-red manquants (zones new_era_zone_44..55).

Ce fichier ÉTEND tools/gen_addon_pmdred_network.py : il en réutilise
directement les tables (SPECIES, AT, MUSIC), les helpers (load/save,
retarget_floor_ranges, scale_levels, build_zone) et les patrons Lua.
On n'y réinvente que ce qui est propre à cette vague :

  * la table Z2 des 12 donjons restants (ids d'origine pmd-red) ;
  * la gestion des RESTRICTIONS (Joyous Tower / Purity Forest : niveau 1,
    solo, sac vide, argent bloqué) — sur le patron exact de Wish Cave
    (new_era_zone_26), seule zone du dépôt qui les pose déjà ;
  * les spawns 100 % Unown pour la Relique des Glyphes.

RÈGLES DU PROJET RESPECTÉES ICI
-------------------------------
* Aucun légendaire en boss ni en spawn. Howling Forest (Suicune) et
  Mt. Faraway (Ho-Oh) sont recréés SANS leur boss d'origine : Suicune et
  Ho-Oh possèdent déjà leur donjon-Ancrage (antre_chuchotant ch25,
  tour_sacree ch18). Fin de donjon sobre : EndDungeonRun, pas d'arène.
* Reskin New Era systématique (lexique Sente / Signal / Balise / Terminal).
  Aucun nom ni élément de l'intrigue d'origine.
* Aucune zone existante (00..43) n'est touchée : on n'écrit que 44..55.

ÉTAGES — source et divergences
------------------------------
Valeurs fournies par la consigne, elles-mêmes tirées de
src/dungeon_info.c sDungeonFloorCount[]. La décompilation n'est pas
clonable depuis ce sandbox (pas d'accès réseau garanti) : les valeurs sont
donc reprises telles quelles et tracées dans docs/addon_reseau_anciens_chemins_v2.md.
Divergence relevée vs la table FLOORS du générateur v1 : aucune, les 12 ids
traités ici n'y figuraient pas (ils faisaient partie des SKIP ou étaient
au-delà de l'id 43).
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, io, os, re, copy, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_addon_pmdred_network import (          # noqa: E402
    SPECIES, AT, MUSIC, TEMPLATE_ZONE, TPL_SPECIES,
    load, save, retarget_floor_ranges, scale_levels,
    ZONE_LUA,
)

# ---------------------------------------------------------------------------
# Les 12 donjons restants.
# (zone_num, nom EN d'origine, nom FR New Era, thème, niveau, étages,
#  restrictions, post_game)   -- l'id d'origine pmd-red == zone_num ici
# ---------------------------------------------------------------------------
FREE = None
LV1_SOLO = dict(Level=1, LevelCap=True, KeepSkills=False, TeamRestrict=True,
                TeamSize=1, MoneyRestrict=True, BagRestrict=0)

Z2 = [
 (44, 'Rock Path',      'Sente des Éboulis',        'mountain',  8,  4, FREE,     False),
 (45, 'Snow Path',      'Sente des Névés',          'ice',      22,  4, FREE,     False),
 (46, 'Howling Forest', 'Futaie du Signal Perdu',   'forest',   30, 15, FREE,     False),
 (47, 'Mt. Faraway',    "Cime de l'Aurore Lointaine",'mountain', 44, 40, FREE,    False),
 (48, 'Waterfall Pond', 'Bassin de la Chute Claire','sea',      35, 19, FREE,     False),
 (49, 'Unown Relic',    'Relique des Glyphes',      'relic',    46, 99, FREE,     True),
 (50, 'Joyous Tower',   'Tour de la Joie Première', 'sky',      50, 99, LV1_SOLO, True),
 (51, 'Far-Off Sea',    'Mer du Lointain',          'sea',      48, 75, FREE,     True),
 (52, 'Purity Forest',  "Forêt de l'Épure",         'forest',   50, 99, LV1_SOLO, True),
 (53, 'Remains Island', 'Île des Vestiges',         'relic',    47, 99, FREE,     True),
 (54, 'Marvelous Sea',  'Mer des Merveilles',       'sea',      47, 99, FREE,     True),
 (55, 'Fantasy Strait', 'Détroit des Chimères',     'psychic',  47, 99, FREE,     True),
]

# Relique des Glyphes : 100 % Unown, formes variées (aucun légendaire).
UNOWN_FORMS = ['unown'] * 13

DEFAULTS = dict(Level=5, LevelCap=False, KeepSkills=False, TeamRestrict=False,
                TeamSize=-1, MoneyRestrict=False, BagRestrict=-1)


def build(zone_num, nen, nfr, theme, level, floors, restrict, post):
    """Construit Data/Zone/new_era_zone_XX.json. Même pipeline que le v1."""
    zid = 'new_era_zone_%02d' % zone_num
    d = load(TEMPLATE_ZONE)
    o = d['Object']
    o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
    o['Released'] = True
    o['Comment'] = (
        'New Era add-on v2 — faithful progression of original dungeon '
        '%s, %d floors from pret/pmd-red sDungeonFloorCount. '
        'PMDO generators, gen4-9 spawn tables (%s). No legendary boss or spawn.'
        % (nen, floors, theme))

    # --- segments : un seul segment procédural, retaillé au bon nb d'étages
    def segs(x):
        if isinstance(x, dict):
            for k, v in x.items():
                if k == 'Segments':
                    return v
                r = segs(v)
                if r is not None:
                    return r
        elif isinstance(x, list):
            for v in x:
                r = segs(v)
                if r is not None:
                    return r
    S = segs(o)
    del S[1:]
    base = S[0]
    old_max = base['Floors']['nodes'][0]['Range']['Max']
    retarget_floor_ranges(base, old_max, floors)

    # --- restrictions (patron Wish Cave / new_era_zone_26)
    fields = dict(DEFAULTS)
    if restrict:
        fields.update(restrict)
    else:
        fields['Level'] = level
    for k, v in fields.items():
        o[k] = v

    # --- texte : niveaux, espèces, autotiles, musique
    t = json.dumps(d, ensure_ascii=False, indent=2)
    # sur les donjons "niveau 1", la courbe interne reste celle du donjon :
    # c'est le LevelCap de la zone qui ramène l'équipe à 1.
    t = scale_levels(t, level / 15.0, level + 3)
    pool = UNOWN_FORMS if zone_num == 49 else SPECIES[theme]
    for i, sp in enumerate(TPL_SPECIES):
        t = t.replace('"%s"' % sp, '"%s"' % pool[i % len(pool)])
    t = t.replace('"lush_prairie_floor"', '"%s"' % AT[theme][0])
    t = t.replace('"lush_prairie_wall"', '"%s"' % AT[theme][1])
    t = t.replace('"lush_prairie_secondary"',
                  '"%s"' % AT[theme][0].replace('_floor', '_secondary'))
    t = t.replace('"treeshroud_forest_1_wall"', '"%s"' % AT[theme][1])
    t = re.sub(r'"Music":\s*"[^"]*"', '"Music": "%s"' % MUSIC[theme], t)

    d2 = json.loads(t)
    o2 = d2['Object']

    # aucun ground : ces 12 donjons n'ont ni entrée ni arène dédiée
    def set_gm(x):
        if isinstance(x, dict):
            for k in x:
                if k == 'GroundMaps':
                    x[k] = []
                    return True
                if set_gm(x[k]):
                    return True
        elif isinstance(x, list):
            for it in x:
                if set_gm(it):
                    return True
        return False
    set_gm(o2)

    save('Data/Zone/%s.json' % zid, d2)
    return zid, fields


def main():
    idx = load('Data/Zone/index.idx')
    made = []
    for (zn, nen, nfr, theme, level, floors, restrict, post) in Z2:
        zid, fields = build(zn, nen, nfr, theme, level, floors, restrict, post)

        # script de zone — patron EXACT des zones 00..43, sans relais
        os.makedirs('Data/Script/halcyon/zone/%s' % zid, exist_ok=True)
        open('Data/Script/halcyon/zone/%s/init.lua' % zid, 'w',
             encoding='utf-8').write(
            ZONE_LUA.format(zid=zid, nfr=nfr, idn=nen, n1=floors,
                            peak_txt='', relay_block=''))

        # entrée index.idx — résumé synchronisé
        idx['Object'][zid] = {
            '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
            'ExpPercent': 100,
            'Level': fields['Level'],
            'LevelCap': fields['LevelCap'],
            'KeepSkills': fields['KeepSkills'],
            'TeamRestrict': fields['TeamRestrict'],
            'TeamSize': fields['TeamSize'],
            'MoneyRestrict': fields['MoneyRestrict'],
            'BagRestrict': fields['BagRestrict'],
            'KeepTreasure': False, 'BagSize': -1, 'Rescues': 2,
            'CountedFloors': floors, 'Rogue': 0,
            'Grounds': [], 'Maps': [[0]],
            'Name': {'DefaultText': nen, 'LocalTexts': {'fr': nfr}},
            'Released': True, 'SortOrder': 0,
        }
        made.append((zid, nfr, floors, fields['Level'], post))
        print('%s  %-30s %3d ét.  L%-3s %s%s'
              % (zid, nfr, floors, fields['Level'],
                 'POST-GAME' if post else 'ch11+',
                 '  [niv.1 solo]' if restrict else ''))

    save('Data/Zone/index.idx', idx)
    json.dump(made, open('/tmp/wave_v2_zones.json', 'w'))
    print('\n%d zones générées' % len(made))


if __name__ == '__main__':
    main()
