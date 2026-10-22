#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
scale_boss_levels.py
Applique un LEVEL SCALING coherent aux boss et mini-boss : chaque boss doit
dominer nettement le peuplement sauvage de SON donjon.

CONSTAT MESURE AVANT CORRECTION (peuplement lu dans Data/Zone/*.json,
niveaux de boss lus dans Data/Map/*.rsmap) :

  donjon            sauvages   mini-boss   boss     ecart mini / boss
  searing_tunnel      13-19        27       29         +8  / +10
  vast_steppe         12-16        25       27         +9  / +11
  mount_windswept     15-19        30       32        +11  / +13
  gloomy_forest       21-24        25       27         +1  / +3     <-- ANOMALIE

La Foret Lugubre (ch6) est l'exception : ses mini-boss sont a +1 du
peuplement, son boss a +3. Ailleurs l'ecart est de +8 a +13. Zarude, boss
de chapitre, se battait donc quasiment au niveau des Chenipan du decor.

BAREME RETENU (aligne sur ce que les donjons ch5 pratiquent deja) :
  mini-boss = plafond sauvage + 9
  boss      = plafond sauvage + 12
  escorte   = plafond sauvage + 4   (presente mais pas au niveau du chef)

Les HP suivent proportionnellement : on conserve le ratio HP/niveau deja
utilise par les arenes de reference (searing_tunnel_miniboss, gardiens ch5).

IMPORTANT — les deux GABARITS sont exclus de toute modification :
searing_tunnel (mini-boss de reference) et crooked_cavern (boss de
reference). Ils servent de modele, on ne les touche pas.

Usage :  python3 tools/scale_boss_levels.py [--apply]
Sans --apply : simulation seule, aucun fichier ecrit.
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
import json
import os
import re
import sys

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Gabarits intouchables (decision joueur).
GABARITS = {'searing_tunnel', 'crooked_cavern'}

# Ecarts au plafond sauvage.
ECART_MINIBOSS = 9
ECART_BOSS = 12
ECART_ESCORTE = 4

# Quel .rsmap appartient a quel donjon, et son role.
CIBLES = {
    'gloomy_forest': [
        ('gloomy_forest_miniboss', 'miniboss'),
        ('gloomy_forest_boss',     'boss'),
    ],
    'vast_steppe': [
        ('vast_steppe_miniboss',  'miniboss'),
        ('vast_steppe_guardian',  'boss'),
    ],
    'mount_windswept': [
        ('mount_windswept_miniboss',  'miniboss'),
        ('mount_windswept_guardian',  'boss'),
    ],
}

# Chefs de file : tout le reste d'un rsmap est considere comme escorte.
CHEFS = {
    'gloomy_forest_miniboss': {'shiftry'},
    'gloomy_forest_boss':     {'zarude'},
    'vast_steppe_miniboss':   {'stantler', 'mudbray'},
    'vast_steppe_guardian':   {'stantler'},
    'mount_windswept_miniboss': {'skarmory', 'gligar'},
    'mount_windswept_guardian': {'aerodactyl'},
}

SPAWN = re.compile(
    r'"Species":\s*"([a-z_0-9]+)"[^}]*\},\s*"Level":\s*\{"Min":\s*(\d+),\s*"Max":\s*(\d+)\}')


def plafond_sauvage(zone):
    """Niveau max du peuplement sauvage d'une zone (Kecleon exclu : c'est le
    marchand, il est au niveau 91 et fausserait tout)."""
    p = os.path.join(RACINE, 'Data/Zone/%s.json' % zone)
    if not os.path.exists(p):
        return None
    o = json.load(open(p, encoding='utf-8-sig')).get('Object')
    mx = 0
    for seg in (o.get('Segments') or []):
        for sp, a, b in SPAWN.findall(json.dumps(seg)):
            if sp == 'kecleon':
                continue
            mx = max(mx, int(b))
    return mx or None


def hp_pour(niveau, base_niv, base_hp):
    """HP proportionnel au niveau, cale sur une reference existante."""
    if not base_niv or not base_hp or base_hp <= 1:
        return None          # HP a 1 = valeur sentinelle du depot, on n'y touche pas
    return max(1, round(base_hp * niveau / base_niv))


def main():
    apply_ = '--apply' in sys.argv
    print('=' * 88)
    print('LEVEL SCALING DES BOSS — %s' % ('APPLICATION' if apply_ else 'SIMULATION (aucun fichier ecrit)'))
    print('=' * 88)
    print('%-28s %-13s %5s %5s %8s' % ('rsmap / espece', 'role', 'avant', 'apres', 'ecart'))
    print('-' * 88)

    total = 0
    for zone, cibles in CIBLES.items():
        if zone in GABARITS:
            print('%-28s GABARIT — exclu' % zone)
            continue
        plafond = plafond_sauvage(zone)
        if plafond is None:
            print('%-28s peuplement introuvable — ignore' % zone)
            continue
        print('\n-- %s (sauvages jusqu au niv %d)' % (zone, plafond))

        for asset, role in cibles:
            p = os.path.join(RACINE, 'Data/Map/%s.rsmap' % asset)
            if not os.path.exists(p):
                print('   %-25s ABSENT' % asset)
                continue
            d = json.load(open(p, encoding='utf-8-sig'))
            o = d['Object']
            chefs = CHEFS.get(asset, set())
            vise_chef = plafond + (ECART_BOSS if role == 'boss' else ECART_MINIBOSS)
            vise_esc = plafond + ECART_ESCORTE
            modifie = False

            for team in (o.get('MapTeams') or []):
                for pl in (team.get('Players') or []):
                    sp = pl['CurrentForm']['Species']
                    avant = pl.get('Level')
                    est_chef = sp in chefs
                    cible = vise_chef if est_chef else vise_esc
                    # REGLE DE NON-REGRESSION : le scaling ne DESCEND jamais un
                    # boss. Le Mont Venteux, par exemple, est deja a +11/+13 —
                    # au-dessus du bareme. L'abaisser a +9/+12 affaiblirait un
                    # combat deja equilibre et teste. On ne remonte que ce qui
                    # est sous le seuil.
                    if avant is not None and avant >= cible:
                        continue
                    nouv_hp = hp_pour(cible, avant, pl.get('HP'))
                    print('   %-25s %-13s %5s %5s %+8d'
                          % (sp, 'chef' if est_chef else 'escorte',
                             avant, cible, cible - plafond))
                    if apply_:
                        pl['Level'] = cible
                        if nouv_hp is not None:
                            pl['HP'] = nouv_hp
                    modifie = True
                    total += 1

            if modifie and apply_:
                with open(p, 'w', encoding='utf-8') as f:
                    json.dump(d, f, ensure_ascii=False, indent=2)

    print('-' * 88)
    print('%d entree(s) %s' % (total, 'modifiee(s)' if apply_ else 'a modifier'))
    if not apply_:
        print('Relancer avec --apply pour ecrire.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
