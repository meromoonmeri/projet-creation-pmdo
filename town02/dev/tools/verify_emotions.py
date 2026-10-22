#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_emotions.py — un nom d'emotion invalide fait crasher le RENDU.

POURQUOI CET OUTIL
------------------
Crash reel remonte par le joueur (build 2026-08-03-H), repete ~60 fois par
seconde jusqu'a l'arret du jeu :

    System.ArgumentOutOfRangeException: Index was out of range.
       at RogueEssence.Menu.SpeakerPortrait.Draw(...)
       at RogueEssence.Menu.DialogueBox.Draw(...)
       at RogueEssence.GameManager.Draw(...)

CHAINE EXACTE, lue dans le code du moteur :

  1. `Lua/ScriptUI.cs:599` — SetSpeakerEmotion resout le nom ainsi :
         GraphicsManager.Emotions.FindIndex(e => e.Name.ToLower() == emo.ToLower())
     `FindIndex` rend **-1** quand le nom n'existe pas, et la valeur est
     ecrite TELLE QUELLE dans `m_curspeakerEmo.Emote`. Aucun controle.

  2. `Content/PortraitSheet.cs:313` — GetReferencedEmoteIndex commence par
         EmotionType emoteData = GraphicsManager.Emotions[type];
     avec type == -1 -> ArgumentOutOfRangeException.

  3. L'exception part de `Draw`, donc elle se rejoue a CHAQUE FRAME tant
     que la boite de dialogue est affichee. D'ou la boucle dans le log.

Le piege : les portraits sont NATIFS et fonctionnent parfaitement. Le
defaut n'a jamais ete un portrait manquant — c'est un nom d'emotion
invalide. Les fautifs etaient des noms d'EMOTES DE BULLE ("Sweating",
"Shock", "Question", "Shocked") employes la ou le moteur attend une
EMOTION DE PORTRAIT. Les deux vocabulaires se ressemblent, et rien dans
le moteur ne signale l'erreur avant le crash graphique.

CE QUE L'OUTIL VERIFIE
----------------------
Tout nom d'emotion litteral passe a :
    GeneralFunctions.SetEmotion(...)   (point d'entree unique du projet)
    UI:SetSpeakerEmotion(...)          (appel moteur direct — a proscrire)
    GeneralFunctions.HeroDialogue(chara, texte, EMOTION)
    GeneralFunctions.Speak(chara, EMOTION)
    StartConversation(chara, texte, EMOTION)
    les tables de voix : { emo = 'EMOTION', ... }

Il signale aussi tout `UI:SetSpeakerEmotion` restant hors de
GeneralFunctions : le projet doit passer par le validateur, qui rabat un
nom inconnu sur "Normal" au lieu de crasher.

LIMITE ASSUMEE
--------------
Les emotions passees par variable calculee ne sont pas resolues
statiquement. C'est precisement pour ces cas que le garde-fou runtime
(GeneralFunctions.SetEmotion) existe : la verification statique attrape
les litteraux, le garde-fou attrape le reste.

USAGE
    python3 tools/verify_emotions.py .
"""
import glob
import os
import re
import sys

# Emotions de portrait valides. Etablies par releve du depot : ce sont
# celles deja employees des centaines de fois sans le moindre incident
# (536 "Normal", 489 "Worried", 379 "Happy"...), plus les Special0-4 des
# scenes de legende. Doit rester en accord avec
# GeneralFunctions.EMOTIONS_PORTRAIT.
VALID = {
    'Normal', 'Happy', 'Pain', 'Angry', 'Worried', 'Sad', 'Crying',
    'Shouting', 'Teary-Eyed', 'Determined', 'Joyous', 'Inspired',
    'Surprised', 'Dizzy', 'Sigh', 'Stunned',
    'Special0', 'Special1', 'Special2', 'Special3', 'Special4',
}

# Noms d'EMOTES DE BULLE, souvent confondus avec les emotions de portrait.
# Les citer dans le rapport rend le diagnostic immediat.
EMOTES_BULLE = {
    'Sweating', 'Sweatdrop', 'Shock', 'Shocked', 'Question', 'Exclaim',
    'Notice', 'Glowing', 'Sleeping', 'Eating', 'Happy2',
}

MOTIFS = [
    ('SetEmotion',
     re.compile(r'(?:GeneralFunctions\.)?SetEmotion\(\s*["\']([^"\']+)["\']')),
    ('UI:SetSpeakerEmotion',
     re.compile(r'UI:SetSpeakerEmotion\(\s*["\']([^"\']+)["\']')),
    ('HeroDialogue',
     re.compile(r'HeroDialogue\((?:[^()]|\([^()]*\))*,\s*["\']([^"\']+)["\']\s*\)')),
    ('Speak',
     re.compile(r'(?:GeneralFunctions\.)?Speak\([^,()]+,\s*["\']([^"\']+)["\']\s*\)')),
    # StartConversation(chara, texte, EMOTION, ...) : l'emotion est le
    # 3e argument. Un motif non ancre capturait le TEXTE du dialogue des
    # que l'appel n'avait que deux arguments — 150 faux positifs.
    # On exige donc explicitement trois arguments, et on refuse les
    # chaines contenant une balise ou une ponctuation de dialogue.
    ('StartConversation',
     re.compile(r'StartConversation\(\s*[^,()]+,\s*(?:"(?:[^"\\]|\\.)*"'
                r"|'(?:[^'\\]|\\.)*')\s*,\s*[\"']([A-Za-z0-9_-]+)[\"']")),
    ('table emo=',
     re.compile(r'\bemo\s*=\s*["\']([^"\']+)["\']')),
]

RE_DIRECT = re.compile(r'UI:SetSpeakerEmotion\(')


def main():
    racine = sys.argv[1] if len(sys.argv) > 1 else '.'
    base = os.path.join(racine, 'Data', 'Script')

    invalides = []
    directs = []
    for path in sorted(glob.glob(os.path.join(base, '**', '*.lua'),
                                 recursive=True)):
        try:
            src = open(path, encoding='utf-8-sig').read()
        except Exception as e:                                  # noqa: BLE001
            print('  ! illisible %s : %s' % (path, e))
            continue
        lignes = src.split('\n')
        for i, ligne in enumerate(lignes, 1):
            for nom_appel, rx in MOTIFS:
                for m in rx.finditer(ligne):
                    emo = m.group(1)
                    if emo not in VALID:
                        invalides.append((path, i, nom_appel, emo))
            if RE_DIRECT.search(ligne) and 'GeneralFunctions.lua' not in path:
                directs.append((path, i))

    print('=' * 78)
    print('VERIFICATION DES EMOTIONS DE PORTRAIT')
    print('=' * 78)

    if invalides:
        print('\n### NOMS D EMOTION INVALIDES : %d' % len(invalides))
        print('    (chacun provoque SpeakerPortrait.Draw / Index out of range,')
        print('     en boucle a chaque frame tant que la boite est affichee)\n')
        for path, ligne, appel, emo in invalides:
            note = ''
            if emo in EMOTES_BULLE:
                note = '   <- EMOTE DE BULLE, pas une emotion de portrait'
            print('    %s:%d' % (path, ligne))
            print('        %s("%s")%s' % (appel, emo, note))
    else:
        print('\n    Aucun nom d emotion invalide.')

    if directs:
        print('\n### APPELS MOTEUR DIRECTS : %d' % len(directs))
        print('    UI:SetSpeakerEmotion contourne le garde-fou du projet.')
        print('    Utiliser GeneralFunctions.SetEmotion, qui rabat un nom')
        print('    inconnu sur "Normal" au lieu de crasher le rendu.\n')
        for path, ligne in directs:
            print('    %s:%d' % (path, ligne))
    else:
        print('    Aucun appel moteur direct hors du validateur.')

    total = len(invalides) + len(directs)
    print('\n' + '=' * 78)
    if total == 0:
        print('RESULTAT : AUCUN RISQUE DE CRASH DE PORTRAIT')
    else:
        print('TOTAL : %d point(s) a corriger' % total)
    print('=' * 78)
    return 0


if __name__ == '__main__':
    sys.exit(main())
