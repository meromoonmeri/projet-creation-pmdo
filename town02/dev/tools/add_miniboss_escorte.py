#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
add_miniboss_escorte.py
Ajoute aux mini-boss l'escorte de PRE-EVOLUTIONS exigee par la regle :
« chaque mini-boss doit etre un Pokemon evolue, accompagne de ses
pre-evolutions ».

CONSTAT AVANT CORRECTION (lu dans Data/Map/*.rsmap) :
  searing_tunnel   Torkoal + Magmar + 8 Limagma   <-- GABARIT, conforme
  gloomy_forest    Shiftry + Murkrow              aucune escorte
  vast_steppe      Stantler + Mudbray             aucune escorte
  mount_windswept  Gligar + Skarmory              aucune escorte

Seul le gabarit respectait la regle — ce qui confirme sa valeur de modele.

PATRON REPRIS DU GABARIT (searing_crucible.rsmap, verifie) :
  - UNE MapTeam PAR POKEMON (le gabarit a 9 teams de 1 membre) ;
  - le chef au centre, l'escorte disposee autour en cercle ;
  - escorte a un niveau NETTEMENT inferieur au chef
    (gabarit : Magcargo 29 contre Slugma 20, soit -9) ;
  - escorte sans bonus de PV (MaxHPBonus 0) : ce sont des comparses,
    pas des seconds boss.

LIGNEES employees (canoniques ; le mod ne surcharge que 21 especes dans
Data/Monster, le reste vient du jeu de base via PathMod) :
  Shiftry  <- Nuzleaf <- Seedot
  Stantler <- (pas de pre-evo)  -> on escorte avec Deerling, meme registre
                                   de cervide, choix documente ci-dessous
  Skarmory <- (pas de pre-evo)  -> Gligar tient deja ce role dans le duo

Usage :  python3 tools/add_miniboss_escorte.py [--apply]
Sans --apply : simulation, aucun fichier ecrit.
"""
import copy
import json
import os
import sys

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Gabarits intouchables.
GABARITS = {'searing_tunnel_miniboss', 'searing_crucible', 'crooked_den'}

# asset -> (espece du chef, [(espece escorte, nombre)], ecart de niveau)
#
# Note sur Stantler et Skarmory : ces deux especes n'ont pas de
# pre-evolution. La regle ne peut donc pas s'appliquer telle quelle. Deux
# options se presentaient : changer le chef, ou escorter avec une espece du
# meme registre. On garde le chef (il est deja ecrit dans les dialogues et
# la narration) et on escorte avec l'espece la plus proche de sa ligne :
#   Stantler -> Deerling  (jeunes cervides du meme troupeau)
#   Skarmory -> Gligar est DEJA la pre-evolution de Gliscor et fait partie
#               du duo ; on ajoute donc des Gligar en escorte, ce qui rend
#               le duo coherent : Skarmory chef, Gligar en meute.
PLAN = {
    'gloomy_forest_miniboss': {
        'chef': 'shiftry',
        'escorte': [('nuzleaf', 2), ('seedot', 2)],
    },
    'vast_steppe_miniboss': {
        'chef': 'stantler',
        'escorte': [('deerling', 3)],
    },
    'mount_windswept_miniboss': {
        'chef': 'skarmory',
        'escorte': [('gligar', 3)],
    },
}

ECART_ESCORTE = 9        # comme le gabarit : Magcargo 29 / Slugma 20

# Positions d'escorte autour du chef, en cases (dx, dy).
ANNEAU = [(-2, 1), (2, 1), (-2, -1), (2, -1), (0, 2), (-3, 0), (3, 0)]


def gabarit_joueur(modele, espece, niveau, loc):
    """Fabrique un combattant d'escorte a partir d'un membre existant.

    On CLONE un joueur deja present dans le fichier plutot que de construire
    la structure a la main : elle compte 80 champs, et un champ manquant
    ferait echouer la deserialisation cote moteur.
    """
    p = copy.deepcopy(modele)
    for cle in ('CurrentForm', 'BaseForm', 'ProxySprite'):
        if cle in p and isinstance(p[cle], dict):
            p[cle] = dict(p[cle])
            p[cle]['Species'] = espece
            p[cle]['Form'] = 0
    p['Level'] = niveau
    p['serializationLoc'] = {'X': loc[0], 'Y': loc[1]}
    p['MaxHPBonus'] = 0          # comparse, pas second boss
    for b in ('AtkBonus', 'DefBonus', 'MAtkBonus', 'MDefBonus', 'SpeedBonus'):
        if b in p:
            p[b] = 0
    if p.get('HP', 0) > 1:
        p['HP'] = max(1, round(p['HP'] * 0.35))
    p['EXP'] = 0
    p['Nickname'] = ''
    p['IsFounder'] = False
    p['IsPartner'] = False
    return p


def main():
    apply_ = '--apply' in sys.argv
    print('=' * 84)
    print('ESCORTE DE PRE-EVOLUTIONS — %s'
          % ('APPLICATION' if apply_ else 'SIMULATION (aucun fichier ecrit)'))
    print('=' * 84)

    total = 0
    for asset, spec in PLAN.items():
        if asset in GABARITS:
            print('%-30s GABARIT — exclu' % asset)
            continue
        p = os.path.join(RACINE, 'Data/Map/%s.rsmap' % asset)
        if not os.path.exists(p):
            print('%-30s ABSENT' % asset)
            continue

        d = json.load(open(p, encoding='utf-8-sig'))
        o = d['Object']
        teams = o.get('MapTeams') or []

        # Retrouver le chef et sa position.
        chef = None
        for t in teams:
            for pl in (t.get('Players') or []):
                if pl['CurrentForm']['Species'] == spec['chef']:
                    chef = pl
                    break
        if chef is None:
            print('%-30s chef %s introuvable' % (asset, spec['chef']))
            continue

        deja = {pl['CurrentForm']['Species']
                for t in teams for pl in (t.get('Players') or [])}
        cx = chef['serializationLoc']['X']
        cy = chef['serializationLoc']['Y']
        niv_esc = max(1, chef['Level'] - ECART_ESCORTE)

        print('\n-- %s   chef %s niv %d'
              % (asset, spec['chef'], chef['Level']))

        i = 0
        ajoutes = 0
        for espece, nombre in spec['escorte']:
            if espece in deja:
                print('   %-10s deja present — ignore' % espece)
                continue
            for _ in range(nombre):
                dx, dy = ANNEAU[i % len(ANNEAU)]
                i += 1
                loc = (cx + dx, cy + dy)
                if apply_:
                    o.setdefault('MapTeams', []).append({
                        '$type': teams[0].get('$type'),
                        'Players': [gabarit_joueur(chef, espece, niv_esc, loc)],
                    })
                print('   + %-10s niv %-3d en (%d,%d)'
                      % (espece, niv_esc, loc[0], loc[1]))
                ajoutes += 1
                total += 1

        if ajoutes and apply_:
            with open(p, 'w', encoding='utf-8') as f:
                json.dump(d, f, ensure_ascii=False, indent=2)

    print('-' * 84)
    print('%d membre(s) d escorte %s'
          % (total, 'ajoute(s)' if apply_ else 'a ajouter'))
    if not apply_:
        print('Relancer avec --apply pour ecrire.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
