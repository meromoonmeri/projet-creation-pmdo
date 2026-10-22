#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""add_duel_spectateurs.py — peuple metano_town_duel.rsmap.

DEUX POPULATIONS, DEUX FACTIONS
-------------------------------
1. MapTeams  -> Faction.Foe   : la Team Dazzling. Combat reel.
2. AllyTeams -> Faction.Friend: les habitants spectateurs.

POURQUOI LES SPECTATEURS SONT INOFFENSIFS *PAR LE MOTEUR*
---------------------------------------------------------
Map.ReconnectMapReference() (Maps/Map.cs:1082-1088) force, a chaque
chargement de la carte :
      AllyTeams[ii].MapFaction = Faction.Friend

et DSceneAction.GetMatchup() (DSceneAction.cs:691-707) tranche :

      Faction attackerFaction = ...GetCharFaction(attacker);
      Faction targetFaction   = ...GetCharFaction(target);
      if (attackerFaction == targetFaction) return Alignment.Friend;
      if (attackerFaction == Faction.Friend || targetFaction == Faction.Friend)
      {
          bool foeTruce = true;
          if (attackerFaction == Faction.Foe || targetFaction == Faction.Foe)
          {
              foeTruce &= !attacker.MemberTeam.FoeConflict;
              foeTruce &= !target.MemberTeam.FoeConflict;
          }
          if (foeTruce) return Alignment.Friend;
      }

Consequence, sans une ligne de script :
  * joueur -> spectateur  : Alignment.Friend  (Faction.Friend implique)
  * Dazzling -> spectateur: Alignment.Friend  (foeTruce, FoeConflict=false)
  * spectateur -> qui que ce soit : idem.
C'est le mecanisme exact des PNJ neutres des donjons PMDO.

Verrous supplementaires poses ici (ceinture ET bretelles) :
  * FoeConflict = false sur toutes les equipes -> la treve tient.
  * EnemyOfFriend = false, AttackFriend = false sur chaque spectateur :
    ce sont precisement les deux drapeaux qui, dans GetMatchup, peuvent
    forcer Alignment.Foe (lignes 683-687). A false, aucune bascule.
  * Tactic = wait_here -> le plan WaitPlan seul : ils ne poursuivent
    personne, n'attaquent pas, ne bougent pas de leur place.
  * CantInteract = true  -> DSceneMap refuse toute interaction.
  * Unrecruitable = true -> pas de recrutement accidentel.
  * Aucune attaque connue (Skills vide) : meme force a agir, rien a lancer.

Le combat reste 3 contre 2 : les spectateurs n'ajoutent aucune force.
"""
import copy
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAP = os.path.join(ROOT, 'Data', 'Map', 'metano_town_duel.rsmap')

# --- LES SPECTATEURS -------------------------------------------------
# Fenetre de la carte = tuiles x30..48, y30..42 du ground.
# Cercle autour de l'aire de duel, sur des cases marchables verifiees,
# a distance de la ligne de combat (aucun blocage de trajectoire).
# (x, y, direction, espece, surnom)
#   Direction : 0 Down, 1 DownLeft, 2 Left, 3 UpLeft,
#               4 Up, 5 UpRight, 6 Right, 7 DownRight
SPECTATEURS = [
    # Composition du schema fourni par l'utilisateur, transposee en CASES
    # (le combat se joue sur une grille de 24 px, pas au pixel).
    # ARC symetrique en ARRIERE-PLAN : 4 a gauche, 4 a droite, tous a
    # hauteur du leader ou au nord de lui, aucun sur la colonne centrale
    # x = 7 (l'axe du defile et de la ligne de vue).
    # Verifie : case marchable, boite 20x20 libre cote ville, hors
    # riviere, >= 32 px de tout collider de commerce (deux demi-largeurs
    # de sprite : aucun chevauchement possible), >= 1 case de tout autre
    # personnage.
    # (x, y, direction, espece, surnom)   0 Down, 2 Left, 4 Up, 6 Right
    ( 4,  8, 0, 'mawile',    'Mawile'),      # aile gauche, face au centre
    ( 2,  8, 6, 'quagsire',  'Quagsire'),
    ( 1,  8, 6, 'nidorina',  'Nidorina'),
    ( 5,  9, 6, 'azumarill', 'Azumarill'),
    ( 9,  9, 2, 'floatzel',  'Floatzel'),    # aile droite
    (10,  9, 2, 'marill',    'Marill'),
    (11,  9, 2, 'venipede',  'Venipede'),
    (12,  8, 2, 'electrike', 'Electrike'),
]


def main(apply=False):
    with open(MAP, encoding='utf-8-sig') as f:
        doc = json.load(f)
    obj = doc['Object']

    # gabarit : on clone une combattante existante (81 champs) plutot
    # que de fabriquer une fiche a la main.
    proto = copy.deepcopy(obj['MapTeams'][0]['Players'][0])
    team_proto = copy.deepcopy(obj['MapTeams'][0])

    # NB : FoeConflict n'est PAS serialise dans les .rsmap du depot
    # (absent des cles d'equipe). Sa valeur par defaut cote moteur est
    # false, ce qui EST la treve recherchee (GetMatchup : foeTruce reste
    # vrai). On ne l'ecrit donc pas : ajouter une cle absente du format
    # d'origine ferait diverger la serialisation sans rien gagner.

    ally = []
    for (x, y, d, species, nick) in SPECTATEURS:
        c = copy.deepcopy(proto)
        c['Nickname'] = nick
        c['CurrentForm'] = {'Species': species, 'Form': 0,
                            'Skin': 'normal', 'Gender': -1}
        c['BaseForm'] = {'Species': species, 'Form': 0,
                         'Skin': 'normal', 'Gender': -1}
        c['ProxySprite'] = {'Species': '', 'Form': -1,
                            'Skin': '', 'Gender': -1}
        c['ProxyName'] = ''
        c['serializationLoc'] = {'X': x, 'Y': y}
        c['serializationDir'] = d
        c['Level'] = 5
        c['HP'] = 30
        c['MaxHPBonus'] = 0
        c['Element1'] = 'normal'
        c['Element2'] = 'none'
        # --- desarmement complet ---
        c['Skills'] = []            # aucune attaque a lancer
        c['Intrinsics'] = []
        c['EquippedItem'] = {'ID': '', 'Cursed': False,
                             'HiddenValue': '', 'Amount': 0, 'Price': 0}
        c['EnemyOfFriend'] = False  # cf. GetMatchup l.683
        c['AttackFriend'] = False   # cf. GetMatchup l.685
        c['CantInteract'] = True
        c['Unrecruitable'] = True
        c['CantWalk'] = True        # ils ne quittent pas leur place
        c['WaitToAttack'] = True
        # Tactic recopiee a l'identique de terrakion_fight.rsmap
        # (seule occurrence attestee de wait_only dans le depot) :
        # WaitPlan seul = il reste sur place, ne poursuit pas, n'attaque pas.
        c['Tactic'] = {
            'Name': {'DefaultText': 'Wait Only', 'LocalTexts': {}},
            'Released': False, 'Comment': '', 'ID': 'wait_only',
            'Assignable': False,
            'Plans': [{
                '$type': 'PMDC.Dungeon.WaitPlan, PMDC',
                'IQ': 400, 'RestrictedMobilityTypes': 0,
                'RestrictMobilityPassable': False,
                'AttackRange': 0, 'StatusRange': 0, 'SelfStatusRange': 0,
                'AbandonRangeOnHit': True,
            }],
        }
        ally.append(c)

    # une equipe par spectateur : aucun chef, aucun suivi de groupe
    obj['AllyTeams'] = []
    for c in ally:
        t = copy.deepcopy(team_proto)
        t['Players'] = [c]
        obj['AllyTeams'].append(t)

    print(f'{len(ally)} spectateurs (AllyTeams -> Faction.Friend)')
    for (x, y, d, s, n) in SPECTATEURS:
        print(f'   {n:11s} {s:11s} ({x:2d},{y:2d})')

    if apply:
        with open(MAP, 'w', encoding='utf-8') as f:
            json.dump(doc, f, ensure_ascii=False, indent=2)
        print('ecrit', MAP)
    else:
        print('(essai a blanc ; --apply pour ecrire)')


if __name__ == '__main__':
    main('--apply' in sys.argv)
