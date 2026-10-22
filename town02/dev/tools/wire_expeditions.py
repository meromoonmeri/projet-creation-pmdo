#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Branche SideExpeditions : cote ville (demandeurs) et cote donjon (retour).

DEUX POINTS DE BRANCHEMENT
--------------------------
1. metano_town_ch_{8,9,10}.lua — une ligne en tete du handler du
   demandeur, exactement comme SideQuests et TownVoicesArc :
       if SideExpeditions.Talk('Nom', N) then return end
   Si l'expedition est terminee, Talk renvoie false et le dialogue
   d'origine s'execute : aucune replique perdue.

2. zone/<zone>/init.lua — dans ExitSegment, avant le renvoi en ville :
       SideExpeditions.OnDungeonCleared('<zone>', result)
   Place APRES ExitDungeonMissionCheck (pour ne pas perturber les
   sauvetages) et AVANT EndDungeonRun (qui quitte la zone).

Idempotent.
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
import io
import os
import re
import sys

TOWN = 'Data/Script/halcyon/ground/metano_town'
ZONES = 'Data/Script/halcyon/zone'

DEMANDEURS = {
    8:  ['Bisharp', 'Quagsire'],
    9:  ['Ledian', 'Roselia'],
    10: ['Manectric', 'Bagon'],
}

ZONES_EXP = ['carriere_cuivre', 'bassin_tari', 'marais_errants',
             'bois_ronces', 'col_foudre', 'falaises_envol']


def brancher_ville(ch, appliquer):
    p = os.path.join(TOWN, 'metano_town_ch_%d.lua' % ch)
    src = io.open(p, encoding='utf-8').read()
    if "require 'halcyon.SideExpeditions'" not in src:
        m = list(re.finditer(r"^require '[^']+'\n", src, re.M))
        src = src[:m[-1].end()] + "require 'halcyon.SideExpeditions'\n" + src[m[-1].end():]

    n = 0
    for nom in DEMANDEURS[ch]:
        pat = re.compile(r"(function metano_town_ch_%d\.%s_Action\([^)]*\)\n)"
                         % (ch, re.escape(nom)))
        m = pat.search(src)
        if not m:
            print('    ch%d %-12s : handler introuvable' % (ch, nom))
            continue
        garde = "  if SideExpeditions.Talk('%s', %d) then return end\n" % (nom, ch)
        if 'SideExpeditions.Talk' in src[m.end():m.end() + 80]:
            continue
        src = src[:m.end()] + garde + src[m.end():]
        n += 1

    if appliquer and n:
        io.open(p, 'w', encoding='utf-8').write(src)
    print('  ville ch%d : %d demandeur(s)' % (ch, n))
    return n


def brancher_zone(zone, appliquer):
    p = os.path.join(ZONES, zone, 'init.lua')
    if not os.path.isfile(p):
        print('  %-18s : script absent' % zone)
        return 0
    src = io.open(p, encoding='utf-8').read()
    if 'SideExpeditions.OnDungeonCleared' in src:
        return 0
    if "require 'halcyon.SideExpeditions'" not in src:
        m = list(re.finditer(r"^require '[^']+'\n", src, re.M))
        if not m:
            print('  %-18s : aucun require' % zone)
            return 0
        src = src[:m[-1].end()] + "require 'halcyon.SideExpeditions'\n" + src[m[-1].end():]

    # ancrage : juste avant le retour en ville de fin de ExitSegment
    ancre = ("  -- Donjon secondaire : dans tous les cas on rentre a "
             "Metano Town (carte 1).\n")
    if ancre not in src:
        print('  %-18s : ancrage de fin introuvable' % zone)
        return 0
    ajout = ("  -- Expedition de requete secondaire : si le joueur en avait\n"
             "  -- une en cours sur cette zone, la victoire la valide.\n"
             "  pcall(function() SideExpeditions.OnDungeonCleared('%s', result) end)\n\n"
             % zone)
    src = src.replace(ancre, ajout + ancre, 1)

    if appliquer:
        io.open(p, 'w', encoding='utf-8').write(src)
    print('  %-18s : retour branche' % zone)
    return 1


if __name__ == '__main__':
    ap = '--apply' in sys.argv
    tot = sum(brancher_ville(c, ap) for c in (8, 9, 10))
    tot += sum(brancher_zone(z, ap) for z in ZONES_EXP)
    print('TOTAL : %d branchement(s)%s' % (tot, '' if ap else '  (essai a blanc)'))
