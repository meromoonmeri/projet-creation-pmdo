#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_fade_leaks.py — detecte les CHEMINS DE SECOURS qui laissent voir
l'ancienne carte pendant un changement de carte.

LE BUG QUE CET OUTIL EMPECHE DE REVENIR
=======================================
Signale trois fois par l'utilisateur : « il y a toujours l'apercu de la map
de searing crucible avant de passer a l'entrance de mount windswept ».

CE QUI N'EST **PAS** LE PROBLEME (verifie, premiere version de cet outil
rejetee pour cette raison — elle levait 184 faux positifs) :

  GAME:FadeOut est BLOQUANT. Sa liaison Lua est
      return coroutine.yield(GAME:_FadeOut(bwhite, duration))
  (Lua/ScriptGame.cs:1590). Le script attend donc la FIN du fondu avant de
  poursuivre. Quand la ligne suivante appelle EnterGroundMap, l'ecran est
  deja noir a 100 %. Un FadeOut(false, 60) suivi d'une transition est SAIN,
  et c'est le patron normal du depot. La duree n'est pas un critere.

LE VRAI CRITERE : LE FONDU A-T-IL SUREMENT EU LIEU ?
====================================================
Le fondu ne protege que s'il s'execute. Deux situations le rendent incertain :

  1. FONDU DANS UN pcall. Si le corps proteged echoue avant d'atteindre son
     FadeOut, l'ecran reste CLAIR. La branche d'erreur enchaine alors vers la
     transition. Comme
        - Draw dessine CurrentScene (GameManager.cs:1338) AVANT fadeScreen
          (l.1363),
        - et EnterGroundMap ne fait qu'ARMER SceneOutcome (ScriptGame.cs:106),
          consomme seulement au tour suivant (GameManager.cs:505-518),
     la carte SORTANTE reste affichee. Un FadeOut de rattrapage long est alors
     un degrade VISIBLE : FadeOut(20) depuis un ecran clair, ce sont 20 frames
     d'opacite 0.05, 0.10 ... 1.0 (FadeEffect.cs:30-43), soit un tiers de
     seconde ou la carte reste lisible.
     => sur un chemin de secours, le fondu doit etre une COUPE FRANCHE.

  2. FONDU POSE DANS UNE COROUTINE DETACHEE (TASK:BranchCoroutine) sans
     JoinCoroutines avant la transition : rien ne garantit qu'il soit termine.

REGLE APPLIQUEE
===============
Un FadeOut situe dans une branche de rattrapage d'erreur (pcall) et suivi
d'un changement de carte doit avoir une duree <= SEUIL frames.
Les fondus du chemin nominal ne sont pas concernes.

Sortie : 0 si aucune fuite, 1 sinon.
"""
import re
import sys
import glob
import os

# Une coupe franche : 1 frame suffit pour un noir plein (opacite 1.0 des la
# premiere frame dessinee). On tolere 2.
SEUIL = 2

# Distance max entre le FadeOut de rattrapage et la transition, comptee en
# INSTRUCTIONS et non en lignes brutes.
#
# Pourquoi : le premier calibrage comptait les lignes du fichier et ratait le
# cas reel du Creuset — 52 lignes separent le pcall de la transition, mais
# 45 d'entre elles sont du commentaire. Le test negatif (reintroduire
# FadeOut(20)) ne levait alors AUCUNE alerte : l'outil etait aveugle
# exactement la ou le bug avait ete signale.
FENETRE = 25

TRANSITION = re.compile(r'GAME:(EnterGroundMap|EnterZone|EnterDungeon)\s*\(')
FADEOUT = re.compile(r'GAME:FadeOut\s*\(\s*(?:false|true)\s*,\s*(\d+)\s*\)')
# Un FadeOut enveloppe individuellement dans un pcall, ou pose dans le corps
# d'une branche d'erreur.
PCALL_FADE = re.compile(r'pcall\s*\(\s*function\s*\(\s*\)\s*GAME:FadeOut')
BRANCHE_ERREUR = re.compile(r'if\s+not\s+ok\b|if\s+ok\s*==\s*false\b')


def audit(racine):
    fuites = []
    fichiers = sorted(glob.glob(
        os.path.join(racine, 'Data/Script/**/*.lua'), recursive=True))

    for chemin in fichiers:
        with open(chemin, encoding='utf-8') as fh:
            lignes = fh.readlines()

        # Reperer les FadeOut incertains : dans un pcall, ou dans une
        # branche `if not ok then`.
        incertains = {}
        dans_branche = -1
        for i, brute in enumerate(lignes):
            nu = brute.strip()
            if nu.startswith('--'):
                continue
            if BRANCHE_ERREUR.search(nu):
                dans_branche = i
            # Une branche d'erreur se referme sur un `end` de meme niveau ;
            # approximation volontairement courte pour rester sur.
            if dans_branche >= 0 and i - dans_branche > 12:
                dans_branche = -1

            m = FADEOUT.search(nu)
            if not m:
                continue
            duree = int(m.group(1))
            if PCALL_FADE.search(nu):
                incertains[i] = (duree, 'enveloppe dans un pcall')
            elif dans_branche >= 0:
                incertains[i] = (
                    duree, 'dans la branche d\'erreur ouverte ligne %d'
                    % (dans_branche + 1))

        if not incertains:
            continue

        # Index des lignes porteuses de code (ni vides, ni commentaires) :
        # la fenetre se mesure sur celles-ci.
        code_idx = [k for k, b in enumerate(lignes)
                    if b.strip() and not b.strip().startswith('--')]
        rang = {k: r for r, k in enumerate(code_idx)}

        for i, brute in enumerate(lignes):
            nu = brute.strip()
            if nu.startswith('--') or not TRANSITION.search(nu):
                continue
            borne = rang.get(i)
            if borne is None:
                continue
            debut = code_idx[max(0, borne - FENETRE)]
            for j in range(i - 1, debut - 1, -1):
                if j in incertains:
                    duree, motif = incertains[j]
                    if duree > SEUIL:
                        fuites.append((
                            chemin, i + 1, nu,
                            'FadeOut(%d) ligne %d, %s : si le fondu nominal '
                            'n\'a pas eu lieu, %d frames ou la carte sortante '
                            'reste dessinee (seuil %d)'
                            % (duree, j + 1, motif, duree, SEUIL)))
                    break

    return fuites


def main():
    racine = sys.argv[1] if len(sys.argv) > 1 else '.'
    fuites = audit(racine)

    if not fuites:
        print('audit_fade_leaks : aucune fuite de fondu detectee.')
        return 0

    print('audit_fade_leaks : %d fuite(s) de fondu' % len(fuites))
    print()
    for chemin, ligne, code, raison in fuites:
        rel = os.path.relpath(chemin, racine)
        print('  %s:%d' % (rel, ligne))
        print('      %s' % code)
        print('      -> %s' % raison)
        print()
    return 1


if __name__ == '__main__':
    sys.exit(main())
