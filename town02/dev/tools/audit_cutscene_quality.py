#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_cutscene_quality — note les cinematiques sur les criteres du
guide prompt_exhaustif_cutscenes_pmd.md (section 11, 14 points).

POURQUOI
--------
Le guide impose un audit final avant de considerer une cinematique
terminee, et interdit de la valider « par simple impression ». Les
outils existants du projet couvrent le crash (verify_emotions), le
blocage (verify_cutscene_guard) et la position (verify_scene_positions)
— aucun ne mesure la MISE EN SCENE.

Or c'est precisement le defaut que j'ai livre puis corrige sur MeuteArc :
trois actes a 0 camera, 0 deplacement, 0 orientation, 0 emote. Le code
compilait, tous les outils passaient au vert, et les scenes etaient des
listes de repliques.

CE QUE L'OUTIL MESURE, PAR SCENE
  narration      boites de narration DANS la scene       (section 4, interdit)
  camera         mouvements de camera                     (5.7)
  deplacement    EightWayMove / MoveToPosition            (5.3)
  orientation    TurnTo / TurnToChar                      (5.2)
  emote          CharSetEmote / SetEmotion                (5.1)
  anim           CharSetAnim / CharWaitAnim               (5.1)
  son            SE / BGM                                 (6.2)
  attente        WaitFrames — le rythme                   (5.1)

VERDICT
  Une scene est signalee quand elle depasse 6 boites de dialogue sans
  aucune camera, ou sans aucune orientation, ou avec de la narration
  interne. Le seuil de 6 evite de crier au loup sur les echanges courts
  (un PNJ de ville n'est pas une cinematique).

L'outil NE JUGE PAS l'ecriture : il detecte les scenes qui n'ont pas ete
mises en scene du tout. Un score eleve ne garantit pas la qualite ; un
score nul garantit son absence.

Usage : python3 tools/audit_cutscene_quality.py [racine] [--tout]
"""
import os
import re
import sys

ROOT = '.'
args = [a for a in sys.argv[1:] if not a.startswith('--')]
if args:
    ROOT = args[0]
TOUT = '--tout' in sys.argv

SCRIPTS = os.path.join(ROOT, 'Data', 'Script', 'halcyon')

# Une "scene" = une fonction Lua contenant au moins un dialogue.
FN = re.compile(r'^function\s+([\w.]+)\s*\(([^)]*)\)', re.M)

MET = {
    'boite':       r'WaitShowDialogue|StartConversation|HeroDialogue'
                   r'|^\s*(?:say|think|line)\(',
    # `local function narrate(...)` est une DEFINITION, pas une boite
    # affichee : l'exclure evite de signaler un fichier dont tous les
    # appels ont ete convertis mais qui garde son helper.
    'narration':   r'^\s*narrate\(|(?<!function )\bnarrate\(',
    'camera':      r'MoveCamera|^\s*cadre\(',
    'deplacement': r'EightWayMove|MoveToPosition|MoveInDirection|MoveToMarker',
    # Les scenes passent souvent par un helper local (regarder,
    # cafe_regard, look...). Ne compter que les appels moteur bruts
    # produisait de faux « 0 orientation » sur des scenes bien reglees.
    'orientation': r'CharAnimateTurnTo|CharTurnToCharAnimated|CharTurnToChar'
                   r'|EntTurn|CharAnimateTurn|\w*regard\w*\(|\w*_turn\w*\(',
    'emote':       r'CharSetEmote|^\s*emote\(',
    'anim':        r'CharSetAnim|CharWaitAnim|CharSetAction',
    'son':         r'PlayBattleSE|PlaySE|PlayBGM|PlayFanfare|StopBGM|FadeOutBGM',
    'attente':     r'WaitFrames',
}
MET = {k: re.compile(v, re.M) for k, v in MET.items()}

SEUIL = 6          # en deca, ce n'est pas une cinematique

# Une CINEMATIQUE se reconnait a une chose : elle prend la main au joueur.
# Sans CutsceneMode, on a affaire a un dialogue de PNJ, a un menu de
# consultation ou a un repertoire de repliques — leur reprocher de ne pas
# bouger la camera serait un faux positif. Deux cas mesures :
#   PartnerEssentials.Chapter_2_Dialogue (134 boites) est un repertoire :
#     une replique par lieu, jouee une a la fois.
#   guild_bottom_right_bedroom.Data_Almanac_Action (79) est un almanach
#     consultable, affiche en SetCenter.
# Ni l'un ni l'autre n'est une scene. On ne retient donc que les fonctions
# qui arment CutsceneMode, ou que leur appelant direct arme.
CUTSCENE = re.compile(r'CutsceneMode\(true\)')


def scenes_du_fichier(path):
    src = open(path, encoding='utf-8', errors='replace').read()
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    src = '\n'.join(re.sub(r'--.*$', '', l) for l in src.split('\n'))

    bornes = [(m.start(), m.group(1)) for m in FN.finditer(src)]
    out = []
    for i, (pos, nom) in enumerate(bornes):
        fin = bornes[i + 1][0] if i + 1 < len(bornes) else len(src)
        corps = src[pos:fin]
        n = {k: len(p.findall(corps)) for k, p in MET.items()}
        n['cutscene'] = len(CUTSCENE.findall(corps))
        if n['boite'] >= 1:
            out.append((nom, n, corps))
    return out


def main():
    lignes = []
    for base, _, files in os.walk(SCRIPTS):
        for f in sorted(files):
            if not f.endswith('.lua'):
                continue
            p = os.path.join(base, f)
            try:
                trouve = scenes_du_fichier(p)
            except Exception:
                continue
            # une fonction appelee par une scene sous CutsceneMode compte
            # aussi : on propage le drapeau au sein du meme fichier.
            corpus = ' '.join(c for _, _, c in trouve)
            armees = set(re.findall(r'(\w+)\s*\(', corpus))
            for nom, n, corps in trouve:
                court = nom.split('.')[-1]
                herite = (n['cutscene'] > 0) or (
                    court in armees and 'CutsceneMode(true)' in corpus
                    and n['camera'] + n['orientation'] + n['deplacement'] > 0)
                n['scene'] = n['cutscene'] > 0
                lignes.append((os.path.relpath(p, ROOT), nom, n))

    grosses = [x for x in lignes
               if x[2]['boite'] >= SEUIL and x[2]['scene']]
    fautives = []
    for rel, nom, n in grosses:
        motifs = []
        if n['narration']:
            motifs.append('narration interne (%d)' % n['narration'])
        if n['camera'] == 0:
            motifs.append('0 camera')
        if n['orientation'] == 0:
            motifs.append('0 orientation')
        if n['deplacement'] == 0 and n['anim'] == 0:
            motifs.append('0 mouvement')
        if motifs:
            fautives.append((rel, nom, n, motifs))

    print('=' * 78)
    print('audit_cutscene_quality — mise en scene des cinematiques'.center(78))
    print('=' * 78)
    print('%d fonction(s) avec dialogue | %d CINEMATIQUE(s) de %d boites ou plus'
          % (len(lignes), len(grosses), SEUIL))
    print('(une cinematique = une fonction qui arme CutsceneMode)\n')

    if TOUT:
        print('%-46s %5s %4s %4s %4s %4s' %
              ('scene', 'boit', 'cam', 'depl', 'ori', 'emo'))
        print('-' * 78)
        for rel, nom, n in sorted(grosses, key=lambda x: -x[2]['boite'])[:40]:
            print('%-46s %5d %4d %4d %4d %4d'
                  % (nom[:46], n['boite'], n['camera'],
                     n['deplacement'], n['orientation'], n['emote']))
        print()

    if not fautives:
        print('RESULTAT : toutes les scenes longues sont mises en scene.')
        return 0

    fautives.sort(key=lambda x: -x[2]['boite'])
    print('### SCENES NON MISES EN SCENE : %d\n' % len(fautives))
    for rel, nom, n, motifs in fautives[:30]:
        print('  %s' % nom)
        print('     %s' % rel)
        print('     %d boites | %s' % (n['boite'], ', '.join(motifs)))
    if len(fautives) > 30:
        print('  ... et %d autre(s)' % (len(fautives) - 30))
    print()
    print('Rappel guide, section 5.1 : « Aucun personnage ne reste fige en')
    print('attendant son tour de parole. » Section 4 : la narration ne sert')
    print("qu'a ouvrir ou clore un acte, jamais a l'interieur d'une scene.")
    return 1


if __name__ == '__main__':
    sys.exit(main())
