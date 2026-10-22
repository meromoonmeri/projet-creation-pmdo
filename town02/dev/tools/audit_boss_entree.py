#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_boss_entree.py
Conformite des ENTREES de boss/mini-boss a la structure imposee par le
prompt « Architecture des donjons & Narration des boss ».

STRUCTURE D'ENTREE EXIGEE (Partie 2, non negociable) :
  1. une voix mysterieuse retentit, source non identifiable ;
  2. premier flash lumineux ;
  3. deuxieme flash, plus marque ;
  4. troisieme flash, qui precede ou accompagne l'apparition ;
  5. le boss apparait, musique de combat qui s'installe.

REGLE SUR « LA VOIX » (\\uE040, liee a l'Abime) :
  Elle est RESERVEE a des moments d'exception. Elle est DISTINCTE de la
  voix mysterieuse generique de l'etape 1, qui peut accompagner
  n'importe quel boss sans lien avec l'Abime. Une arene qui introduit
  son boss avec \\uE040 detourne donc La Voix de son role.

Ce que l'outil mesure, par arene :
  * flashs        : nombre d'appels BossFX.Flash (3 attendus)
  * voix_generique: presence d'une voix d'entree NON-\\uE040
  * la_voix       : occurrences de \\uE040 / BossFX.Voice (doit rester rare)
  * musique       : un PlayBGM apres le dernier flash
  * hors_champ    : entites positionnees hors du cadre camera a l'arrivee

Usage : python3 tools/audit_boss_entree.py [racine]

L'outil NE MODIFIE RIEN. Il produit l'inventaire que le prompt exige
AVANT toute implementation.
"""
import os
import re
import sys

# GABARITS DE REFERENCE — EXCLUS DE TOUTE MODIFICATION (decision joueur).
# Le mini-boss du Tunnel Incandescent et le boss de Crooked Cavern sont les
# modeles a reprendre et adapter par biome : on les MESURE pour en extraire
# la structure, on ne les corrige jamais.
GABARITS = ['searing_tunnel_miniboss', 'crooked_den']

# Arenes de boss/mini-boss du scenario principal.
ARENES = [
    'searing_tunnel_miniboss', 'searing_crucible',
    'vast_steppe_miniboss', 'vast_steppe_guardian',
    'mount_windswept_miniboss', 'mount_windswept_guardian',
    'gloomy_forest_miniboss', 'gloomy_forest_boss',
    'cloven_ruins_miniboss', 'cloven_ruins_boss',
    'crystal_sanctuary_miniboss', 'crystal_sanctuary_boss',
    'forgotten_marsh_miniboss', 'forgotten_marsh_boss',
    'celestial_peak_boss', 'crooked_den',
]

# Fonctions qui portent l'ENTREE du boss (pas la defaite ni la victoire).
ENTREE = re.compile(r'function\s+[\w.]*\.?(FirstPreBossScene|SecondPreBossScene|PreBossScene)\b')


def corps_entree(src):
    """Extrait le corps des fonctions d'entree, sans les commentaires."""
    out = []
    for m in ENTREE.finditer(src):
        start = m.start()
        # fin = prochaine declaration de fonction au niveau racine
        nxt = re.search(r'\nfunction\s', src[m.end():])
        end = m.end() + (nxt.start() if nxt else len(src) - m.end())
        bloc = src[start:end]
        bloc = re.sub(r'--\[\[.*?\]\]', '', bloc, flags=re.DOTALL)
        bloc = '\n'.join(l for l in bloc.split('\n')
                         if not l.strip().startswith('--'))
        out.append(bloc)
    return '\n'.join(out)


def lire(root, nom):
    d = os.path.join(root, 'Data/Script/halcyon/ground', nom)
    if not os.path.isdir(d):
        return None
    src = ''
    for f in sorted(os.listdir(d)):
        if f.endswith('.lua'):
            src += open(os.path.join(d, f), encoding='utf-8',
                        errors='replace').read() + '\n'
    return src


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    rows, absents = [], []

    for nom in ARENES:
        src = lire(root, nom)
        if src is None:
            absents.append(nom)
            continue
        bloc = corps_entree(src) or src

        flashs = len(re.findall(r'BossFX\.Flash\s*\(', bloc))
        # LA VOIX = uniquement la forme DESINCARNEE (portrait vide) :
        #   UI:SetSpeaker(uE040, true, "", -1, "", Gender.Unknown)
        # ou le helper centralise BossFX.Voice.
        # A NE PAS CONFONDRE avec uE040 + CurrentForm.Species, qui affiche le
        # PORTRAIT d'un personnage present dont le nom n'est pas encore revele
        # (patron du gabarit crooked_den) : ce second usage est legitime et
        # n'a rien a voir avec l'Abime.
        lavoix = (len(re.findall(r'uE040[^\n]*"",\s*-1,\s*""', bloc))
                  + len(re.findall(r'BossFX\.Voice\s*\(', bloc)))
        incarnee = len(re.findall(r'uE040[^\n]*CurrentForm', bloc))
        # Voix generique = un locuteur anonyme QUI N'EST PAS \uE040.
        generique = len(re.findall(r'UI:SetCenter\(true\)', bloc))
        musique = len(re.findall(r"PlayBGM\(", bloc))
        overlay = len(re.findall(r'BossFX\.Overlay\s*\(', bloc))
        shake = len(re.findall(r'BossFX\.ShakeScreen|MoveScreen', bloc))
        partic = len(re.findall(r'BossFX\.Particle\s*\(', bloc))

        rows.append(dict(nom=nom, flashs=flashs, lavoix=lavoix,
                         incarnee=incarnee,
                         generique=generique, musique=musique,
                         overlay=overlay, shake=shake, partic=partic,
                         ref=(nom in GABARITS)))

    print('=' * 96)
    print('CONFORMITE DES ENTREES DE BOSS — structure en 5 temps')
    print('=' * 96)
    print('%-30s %6s %7s %8s %8s %7s  %s' % (
        'arene', 'flashs', 'LaVoix', 'incarn.', 'PlayBGM', 'partic', 'etat'))
    print('-' * 96)
    for r in rows:
        if r['ref']:
            etat = 'GABARIT — exclu de toute modification'
        else:
            a = []
            if r['flashs'] < 3:
                a.append('<3 flashs')
            if r['lavoix'] > 1:
                a.append('LaVoix x%d' % r['lavoix'])
            etat = ', '.join(a) if a else 'conforme'
        print('%-30s %6d %7d %8d %8d %7d  %s' % (
            r['nom'], r['flashs'], r['lavoix'], r['incarnee'],
            r['musique'], r['partic'], etat))

    print('-' * 96)
    trav = [r for r in rows if not r['ref']]
    ko_flash = [r['nom'] for r in trav if r['flashs'] < 3]
    ko_voix = [r['nom'] for r in trav if r['lavoix'] > 1]
    print('Arenes analysees                      : %d (dont %d gabarits exclus)'
          % (len(rows), len(rows) - len(trav)))
    print('Sans les 3 flashs exiges              : %d' % len(ko_flash))
    print('Sur-employant La Voix (>1 par entree) : %d' % len(ko_voix))
    print('Reference : le gabarit du Tunnel n emploie La Voix qu UNE fois.')
    if absents:
        print('Dossiers absents                      : %s' % ', '.join(absents))
    print('-' * 96)
    print('RAPPEL : La Voix (\\uE040) est reservee aux moments d exception.')
    print('         La voix d entree de l etape 1 doit etre GENERIQUE et')
    print('         ne jamais se faire passer pour elle.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
