#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_cutscene_guard.py — detecte les cartes qui peuvent CRASHER pendant la
bascule de carte, faute d'avoir pose le mode cinematique assez tot.

LE CRASH QUE CET OUTIL EMPECHE DE REVENIR
=========================================
Signale en jeu, au moment du coucher au Mont Venteux :

    System.NullReferenceException: Object reference not set to an instance
       at RogueEssence.Ground.GroundScene.ProcessInput()+MoveNext()
       at RogueEssence.Coroutine.MoveNext()

Chaine exacte, lue dans RogueEssence :

  GroundScene.ProcessInput() — Ground/GroundScene.cs:162-165
      if (GameManager.Instance.SceneOutcome == null)
          yield return ... ZoneManager.Instance.CurrentGround.OnCheck();
                            ^^^^^^^^^^^^^^^^^^ nul pendant une bascule

  Pourquoi CurrentGround est nul :
      GSceneZone.ExitGround     — Ground/GSceneZone.cs:45-46
          SetPlayerChar(null) ; SetCurrentMap(SegLoc.Invalid)
      Zone.SetCurrentMap        — Dungeon/Zone.cs:145-148  -> exitMap()
      Zone.exitMap              — Dungeon/Zone.cs:140-142  -> CurrentGround = null

  Pourquoi la boucle tourne quand meme :
      GameManager.ScreenMainCoroutine — Scene/GameManager.cs:505-507
          while (SceneOutcome == null)
              yield return StartCoroutine(CurrentScene.ProcessInput());
      SceneOutcome est remis a null (l.516) AVANT que l'outcome ne soit
      execute. Pendant MoveToGround, on a donc simultanement
      SceneOutcome == null et CurrentGround == null.

  Le seul rempart :
      GroundScene.ProcessInput(InputManager) — Ground/GroundScene.cs:176
          if (DataManager.Instance.Save.CutsceneMode) yield break;
      Mais cette garde est dans la surcharge INTERNE. La ligne 165 fautive
      est dans la surcharge PUBLIQUE, en amont... et n'est atteinte que si
      la carte a rendu la main au joueur. Mode cinematique actif du debut a
      la fin de la sequence = la fenetre ne s'ouvre jamais.

REGLE APPLIQUEE
===============
Une carte dont le Enter/PlotScripting lance une cinematique doit avoir le
mode cinematique ACTIF des l'Init — pas seulement au debut de la scene.
Entre Init et Enter, la boucle principale peut tourner.

Patron atteste du depot : personality_test/init.lua:86 ouvre sa scene par
GAME:CutsceneMode(true).

CALIBRAGE — une premiere version de cet outil a ete REJETEE
============================================================
Elle signalait « Init n'active pas CutsceneMode » et levait 35 cartes, dont
personality_test et searing_crucible : deux cartes qui fonctionnent en jeu.
Un outil qui accuse le code sain ne sert a rien.

Ce n'est pas d'activer le mode dans l'Init qui protege. C'est de l'activer
AVANT toute instruction BLOQUANTE de la scene. searing_crucible pose
CutsceneMode(true) en tete de sa scene (searing_crucible_ch_5.lua:73), avant
le moindre WaitFrames ou dialogue : la boucle principale ne reprend jamais la
main entre-temps, la fenetre ne s'ouvre pas.

hero_dream, lui, executait AVANT son CutsceneMode(true) :
    if hero == nil then ... GAME:EnterGroundMap(...) ; return end
Un EnterGroundMap arme SceneOutcome et rend la main. La fenetre s'ouvrait.

SECOND CALIBRAGE — encore trop large
====================================
Retenir « toute instruction bloquante » levait 52 scenes. Or le comptage sur
l'ensemble du depot montre ce qui precede reellement un CutsceneMode(true) :

    GAME:MoveCamera        20      <- patron normal, ne crashe pas
    GAME:FadeOut           15      <- patron normal
    GAME:WaitFrames        10      <- patron normal
    GAME:FadeIn             6      <- patron normal
    GAME:EnterGroundMap     1      <- LE BUG, et lui seul

Les quatre premiers cadrent ou fondent AVANT d'armer le mode : la carte
courante reste valide pendant ce temps, CurrentGround n'est pas nul, rien ne
casse. C'est le style etabli du depot sur des dizaines de scenes jouees.

Seul EnterGroundMap est dangereux : il ARME SceneOutcome (ScriptGame.cs:106).
A partir de cet instant la bascule est engagee, ExitGround va poser
CurrentGround = null, et toute frame executee avant que le mode ne soit actif
tombe sur GroundScene.cs:165.

REGLE RETENUE : une seule, etroite, zero faux positif connu
===========================================================
Est signalee une fonction qui appelle GAME:EnterGroundMap AVANT son propre
GAME:CutsceneMode(true). Tout autre ordre est accepte.

Sortie : 0 si aucune carte a risque, 1 sinon.
"""
import os
import re
import sys
import glob

CUTSCENE_ON = re.compile(r'GAME:CutsceneMode\s*\(\s*true\s*\)')
CUTSCENE_OFF = re.compile(r'GAME:CutsceneMode\s*\(\s*false\s*\)')
ENTER_MAP = re.compile(r'GAME:EnterGroundMap\s*\(')


def lire(chemin):
    try:
        with open(chemin, encoding='utf-8') as fh:
            return fh.read()
    except OSError:
        return ''


def sans_commentaires(texte):
    return '\n'.join(l for l in texte.split('\n')
                     if not l.strip().startswith('--'))


def bloc_fonction(texte, nom):
    """Extrait le corps de `function <nom>(...)` jusqu'au `end` de colonne 0."""
    m = re.search(r'^function\s+' + re.escape(nom) + r'\s*\(', texte,
                  re.MULTILINE)
    if not m:
        return None
    debut = m.start()
    reste = texte[debut:]
    m2 = re.search(r'^end\s*$', reste, re.MULTILINE)
    return reste[:m2.end()] if m2 else reste


# La SEULE instruction qui engage la bascule de carte, et donc la seule qui
# ouvre la fenetre de crash. Cf. le second calibrage en tete de fichier :
# MoveCamera / FadeOut / WaitFrames / FadeIn avant CutsceneMode sont le patron
# normal du depot (51 occurrences jouees sans incident).
REND_LA_MAIN = re.compile(r'GAME:EnterGroundMap\s*\(')


def audit(racine):
    risques = []
    scripts = sorted(glob.glob(
        os.path.join(racine, 'Data/Script/*/ground/*/*.lua')))

    for script in scripts:
        texte = sans_commentaires(lire(script))
        if not CUTSCENE_ON.search(texte):
            continue

        # Chaque fonction du fichier est examinee separement.
        for m in re.finditer(r'^function\s+([\w.]+)\s*\(', texte,
                             re.MULTILINE):
            nom = m.group(1)
            reste = texte[m.start():]
            fin = re.search(r'^end\s*$', reste, re.MULTILINE)
            corps = reste[:fin.end()] if fin else reste

            on = CUTSCENE_ON.search(corps)
            if not on:
                continue  # cette fonction ne pose pas le mode : hors sujet

            avant = corps[:on.start()]
            fuite = REND_LA_MAIN.search(avant)
            if not fuite:
                continue  # le mode est pose avant tout appel bloquant : sain

            ligne = texte[:m.start()].count('\n') + 1
            decalage = avant[:fuite.start()].count('\n')
            risques.append((
                os.path.relpath(script, racine), ligne, nom,
                fuite.group(0).rstrip('('), ligne + decalage))

    return risques


def main():
    racine = sys.argv[1] if len(sys.argv) > 1 else '.'
    risques = audit(racine)

    print('verify_cutscene_guard : %d scene(s) qui rendent la main avant '
          'd armer le mode cinematique' % len(risques))
    print()
    if not risques:
        print('RESULTAT : AUCUNE SCENE A RISQUE')
        return 0

    for chemin, ligne, nom, appel, ligne_appel in risques:
        print('  %s:%d' % (chemin, ligne))
        print('      %s() appelle %s (ligne %d) AVANT son CutsceneMode(true).'
              % (nom, appel, ligne_appel))
        print('      La boucle principale peut alors executer une frame et')
        print('      dereferencer un CurrentGround nul (GroundScene.cs:165)')
        print('      pendant une bascule de carte.')
        print()
    print('RESULTAT : %d scene(s) a examiner' % len(risques))
    return 1


if __name__ == '__main__':
    sys.exit(main())
