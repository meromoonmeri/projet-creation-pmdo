#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Branche TownVoicesArc sur les handlers de PNJ des ch8/9/10.

CONTRAT
-------
On insere UNE ligne en tete de chaque handler concerne :

    if TownVoicesArc.Talk('Nom', N) then return end

C'est exactement le patron deja employe au ch6 avec TownVoices
(metano_town_ch_6.lua:778 et suivants). Si le module n'a pas de fiche
pour ce PNJ, Talk renvoie false et le dialogue d'origine s'execute :
aucune replique existante n'est perdue.

Idempotent : ne fait rien si la ligne est deja presente.
"""
import io
import os
import re
import sys

BASE = 'Data/Script/halcyon/ground/metano_town'

# PNJ traites par TownVoicesArc, par chapitre. Doit rester aligne sur
# les tables CH8 / CH9 / CH10 du module.
FICHES = {
    8:  ['Gulpin', 'Ludicolo', 'Spinda', 'Spheal', 'Doduo', 'Metapod',
         'Silcoon', 'Venipede', 'Nidoran_Male'],
    9:  ['Gulpin', 'Ludicolo', 'Roselia', 'Jigglypuff', 'Marill', 'Spheal',
         'Bagon', 'Doduo', 'Metapod', 'Silcoon', 'Mareep', 'Nidoran_Male'],
    10: ['Gulpin', 'Bellossom', 'Vileplume', 'Gloom', 'Oddish', 'Furret',
         'Linoone', 'Sentret', 'Wooper_Girl', 'Wooper_Boy', 'Manectric',
         'Nidoran_Male', 'Mareep', 'Spheal', 'Doduo', 'Metapod', 'Silcoon'],
}


def traiter(ch, appliquer):
    p = os.path.join(BASE, 'metano_town_ch_%d.lua' % ch)
    if not os.path.isfile(p):
        print('  ch%d : fichier absent' % ch)
        return 0
    src = io.open(p, encoding='utf-8').read()

    # require en tete, apres le dernier require existant
    if "require 'halcyon.TownVoicesArc'" not in src:
        m = list(re.finditer(r"^require '[^']+'\n", src, re.M))
        if not m:
            print('  ch%d : aucun require, insertion en tete impossible' % ch)
            return 0
        pos = m[-1].end()
        src = src[:pos] + "require 'halcyon.TownVoicesArc'\n" + src[pos:]

    poses = 0
    for nom in FICHES[ch]:
        # signature exacte du handler
        pat = re.compile(
            r"(function metano_town_ch_%d\.%s_Action\([^)]*\)\n)" % (ch, re.escape(nom)))
        m = pat.search(src)
        if not m:
            print('    ch%d %-14s : handler introuvable' % (ch, nom))
            continue
        garde = "  if TownVoicesArc.Talk('%s', %d) then return end\n" % (nom, ch)
        apres = src[m.end():m.end() + len(garde) + 40]
        if 'TownVoicesArc.Talk' in apres:
            continue                      # deja branche
        src = src[:m.end()] + garde + src[m.end():]
        poses += 1

    if appliquer and poses:
        with io.open(p, 'w', encoding='utf-8') as f:
            f.write(src)
    print('  ch%d : %d handler(s) branche(s)%s'
          % (ch, poses, '' if appliquer else '  (essai a blanc)'))
    return poses


if __name__ == '__main__':
    appliquer = '--apply' in sys.argv
    total = sum(traiter(ch, appliquer) for ch in (8, 9, 10))
    print('TOTAL : %d branchement(s)' % total)
