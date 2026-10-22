#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_spawner_enabled.py — detecte les spawners d'equipiers desactives.

LE BUG QUE CET OUTIL EMPECHE DE REVENIR
=======================================
La carte hero_dream avait son spawner TEAMMATE_1 a EntEnabled=False. Le
symptome en jeu : « le moment du reve est toujours un crash black screen ».

Chaine, verifiee dans RogueEssence :

  GroundSpawner.Spawn — Ground/Maps/GroundSpawner.cs:78-81
      if (!EntEnabled)
          return null;
  Le personnage n'est donc JAMAIS cree.

  ScriptGround.SpawnerDoSpawn — Lua/ScriptGround.cs:243-258
      renvoie null sans propager d'erreur (exception attrapee et loguee).

  COMMON.RespawnAllies (common.lua) tolere le nil...
  ...mais PartnerEssentials.InitializePartnerSpawn ne teste que la TAILLE
  de l'equipe :
      if GAME:GetPlayerPartyCount() < 2 then return end
  L'equipe contient bien 2 membres, la garde est franchie, puis :
      partner.Direction        <-- index d'un nil

  Le moteur enveloppe le callback dans un xpcall (LuaEngine.cs:895) : pas
  de fenetre de plantage, mais la coroutine est avortee sur place. La scene
  s'arrete, l'ecran reste noir, aucune sortie. Un « crash black screen ».

REGLE APPLIQUEE
===============
Tout spawner dont le nom commence par TEAMMATE_ (ou Teammate) doit etre
EntEnabled=True sur une carte dont un script appelle RespawnAllies ou
InitializePartnerSpawn.

Pour masquer un personnage dans une scene, on ne desactive PAS son
spawner : on le fait apparaitre puis on appelle GROUND:Hide(chara.EntName).
Reference : personality_test.rsground, la carte modele du jeu, a bien son
Teammate1 a True.

Sortie : 0 si aucun spawner fautif, 1 sinon.
"""
import glob
import json
import os
import re
import sys


def charge(chemin):
    try:
        with open(chemin, encoding='utf-8-sig') as fh:
            return json.load(fh)
    except (OSError, ValueError):
        return None


def scripts_de_la_carte(racine, nom):
    """Les scripts Lua rattaches a une carte, tous namespaces confondus."""
    motif = os.path.join(racine, 'Data/Script/*/ground', nom, '*.lua')
    return glob.glob(motif)


def audit(racine):
    fautifs = []
    for chemin in sorted(glob.glob(os.path.join(racine,
                                                'Data/Ground/*.rsground'))):
        nom = os.path.basename(chemin)[:-len('.rsground')]
        d = charge(chemin)
        if d is None:
            continue
        o = d.get('Object', d)
        couches = o.get('Entities') or []
        if not couches:
            continue

        # La carte a-t-elle un script qui reclame le partenaire ?
        besoin = False
        for s in scripts_de_la_carte(racine, nom):
            try:
                t = open(s, encoding='utf-8').read()
            except OSError:
                continue
            if re.search(r'RespawnAllies|InitializePartnerSpawn', t):
                besoin = True
                break
        if not besoin:
            continue

        for couche in couches:
            for sp in couche.get('Spawners') or []:
                brut = sp.get('NPCName') or ''
                if not re.match(r'(?i)teammate', brut.replace('_', '')):
                    continue
                if sp.get('EntEnabled') is False:
                    fautifs.append((nom, brut))
    return fautifs


def main():
    racine = sys.argv[1] if len(sys.argv) > 1 else '.'
    fautifs = audit(racine)

    print('verify_spawner_enabled : %d spawner(s) d equipier desactive(s)'
          % len(fautifs))
    print()
    if not fautifs:
        print('RESULTAT : TOUS LES SPAWNERS D EQUIPIER SONT ACTIFS')
        return 0

    for carte, nom in fautifs:
        print('  Data/Ground/%s.rsground' % carte)
        print('      spawner %s a EntEnabled=False, alors qu un script de la'
              % nom)
        print('      carte appelle RespawnAllies / InitializePartnerSpawn.')
        print('      Spawn() renverra null (GroundSpawner.cs:80) et la scene')
        print('      sera avortee sur un ecran noir.')
        print()
    print('RESULTAT : %d spawner(s) a reactiver' % len(fautifs))
    return 1


if __name__ == '__main__':
    sys.exit(main())
