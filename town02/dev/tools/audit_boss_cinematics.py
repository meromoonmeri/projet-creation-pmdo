#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Audit de QUALITE des cinematiques de boss.

Question posee : « est-ce que toutes les cinematiques de boss sont aussi
travaillees que celle du Tunnel Ardent (clan de lave / Limagma) ? »

On ne repond pas au ressenti. On mesure ce qui fait CONCRETEMENT la difference,
etabli par comparaison directe entre la scene du Tunnel (jugee reussie) et les
quatre autres du chapitre 5 (jugees plates) :

  1. BOITES DITES PAR LE BOSS  -- le critere numero un. Un boss muet est un
     obstacle ; un boss qui parle est un personnage. Le Tunnel : 12. Les
     quatre autres avant correction : 0.
  2. MOUVEMENTS DE CAMERA      -- remonter sur le boss qui parle, resserrer
     sur la phrase-pivot, redescendre en cadre commun.
  3. COROUTINES PARALLELES     -- des acteurs qui bougent ENSEMBLE (patron
     pmd-red intro.inc) au lieu de se succeder.
  4. VARIETE DES EFFETS        -- nombre de BossFX distincts. Un seul Flash
     repete = apparition generique.
  5. LA VOIX                   -- presence du speaker anonyme.
  6. APRES-BOSS                -- le boss vaincu dit-il quelque chose, ou
     s'evapore-t-il sans rien laisser ?

Le score /100 est une AIDE AU TRI, pas un jugement litteraire : il repere les
scenes pauvres, il ne certifie pas que les autres sont bonnes.

Usage :  python3 tools/audit_boss_cinematics.py [racine] [--csv]
"""
import os, re, sys, glob

RACINE = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith('-') else '.'
CSV = '--csv' in sys.argv

DIAG = re.compile(r'WaitShowDialogue|WaitShowTimedDialogue|StartConversation|HeroDialogue')

# Personnages qui ne sont JAMAIS le boss : heros, allies, narrateur, la Voix.
NON_BOSS = {'hero', 'partner', 'chara', 'activator', 'player',
            'teammate1', 'teammate2', 't2', 't3', 'leader', 'ally'}


def decommente(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)


def boites_du_boss(src):
    """Simule le locuteur courant et compte les boites attribuees a un
    personnage qui n'est ni le heros, ni le partenaire, ni la Voix."""
    n, cur = 0, None
    motif = re.compile(
        r'UI:SetSpeaker\(\s*([^),]*?)\s*[,)]|UI:ResetSpeaker|'
        r'HeroDialogue|WaitShowDialogue|WaitShowTimedDialogue')
    for m in motif.finditer(src):
        t = m.group(0)
        if t.startswith('UI:SetSpeaker'):
            arg = (m.group(1) or '').strip()
            # La Voix : SetSpeaker(STRINGS:Format("\uE040"), ...) -> pas un boss.
            if 'uE040' in arg or 'STRINGS' in arg or not arg:
                cur = None
            elif arg.lower() in NON_BOSS:
                cur = None
            elif re.match(r'^[A-Za-z_][\w]*$', arg):
                cur = arg
            else:
                cur = None
        elif t.startswith('UI:ResetSpeaker') or t.startswith('HeroDialogue'):
            cur = None
        elif cur:
            n += 1
    return n


def analyse(path):
    brut = open(path, encoding='utf-8', errors='replace').read()
    src = decommente(brut)
    fx = set(re.findall(r'BossFX\.(\w+)', src))
    d = {
        'dialogues': len(DIAG.findall(src)),
        'boss': boites_du_boss(src),
        'camera': len(re.findall(r'MoveCamera', src)),
        'coro': len(re.findall(r'BranchCoroutine', src)),
        'fx': len(fx),
        'fxnoms': fx,
        'voix': len(re.findall(r'uE040|BossFX\.Voice|VoiceVisions\.Speak', src)),
        'lignes': brut.count('\n') + 1,
    }
    # Apres-boss : le boss parle-t-il APRES la victoire ?
    m = re.search(r'(?:local )?function\s+\w*(?:DefeatedBoss|Victory|Aftermath)\w*\s*\(', src)
    d['apres'] = boites_du_boss(src[m.start():]) if m else 0
    return d


def score(d):
    """Ponderation : la parole du boss pese le plus lourd (40 pts)."""
    s = 0
    s += min(d['boss'], 10) * 4                    # 40 max
    s += min(d['camera'], 10) * 1.5                # 15
    s += min(d['coro'], 10) * 1.5                  # 15
    s += min(d['fx'], 5) * 3                       # 15
    s += 8 if d['voix'] else 0                     #  8
    s += 7 if d['apres'] else 0                    #  7
    return round(s)


def main():
    base = os.path.join(RACINE, 'Data/Script/halcyon/ground')
    scenes = []
    # Modules GLOBAUX d'apres-boss : ils portent la scene pour toute une
    # famille et sont appeles depuis zone/. Sans eux la mesure est fausse.
    globaux = {
        'VeilleurArc.lua': ('reseau', 'VeilleurArc (adieux des 10 Veilleurs)'),
        'ChapterAftermath.lua': ('histoire', 'ChapterAftermath (ch8-10)'),
        'DazzlingArc.lua': ('histoire', 'DazzlingArc (ch6)'),
        'LegendArc.lua': ('legendaire', 'LegendArc (adieux des 42 gardiens)'),
    }
    for fichier, (fam, label) in globaux.items():
        gp = os.path.join(RACINE, 'Data/Script/halcyon', fichier)
        if not os.path.exists(gp):
            continue
        d = analyse(gp)
        # Dans ces modules les repliques passent par des helpers say()/narrate().
        src = decommente(open(gp, encoding='utf-8').read())
        d['boss'] = len(re.findall(r'^\s*say\(', src, re.M))
        d['dialogues'] = len(re.findall(r'^\s*(?:say|narrate|think|voice)\(', src, re.M))
        # Fiches declaratives (VeilleurArc / LegendArc) : les repliques sont
        # des chaines dans une table, pas des appels. On les compte vraiment.
        fiches = len(re.findall(r"^\s+\w+ = \{ g='", src, re.M)) or \
                 len(re.findall(r"^\s+\['[\w]+'\] = \{", src, re.M))
        if fiches:
            boites = (len(re.findall(r'^\s+"', src, re.M))
                      + len(re.findall(r'^\s+(?:partner|last|close|hero|ask) = "', src, re.M))
                      + len(re.findall(r"(?:lines2?|last|close|ask)\s*=\s*[{\"]", src)))
            d['boss'] = boites
            d['dialogues'] = boites
            d['apres'] = boites
            d['camera'] = 5      # near/wide poses par Victory()
            d['fx'] = 2
        d['apres'] = d['boss']
        d['nom'], d['fam'] = label, fam
        d['score'] = score(d)
        scenes.append(d)

    for path in sorted(glob.glob(os.path.join(base, '*', '*.lua'))):
        brut = open(path, encoding='utf-8', errors='replace').read()
        # On ne retient que les fichiers qui lancent VRAIMENT un combat de
        # boss. BossTransition() est la signature fiable : c'est le double
        # flash + fondu qui precede l'arene. Les scenes de guilde, de ville
        # et de chambre citaient « DefeatedBoss » dans une CONDITION
        # (« si tu as battu X, alors... ») sans etre des combats : elles
        # polluaient le classement en tete de liste comme « boss muets ».
        if 'COMMON.BossTransition()' not in brut:
            continue
        src = decommente(brut)
        if len(DIAG.findall(src)) < 4:      # ecrans de service, pas des scenes
            continue
        d = analyse(path)
        d['nom'] = os.path.relpath(path, base).replace('/init.lua', '').replace('.lua', '')
        d['score'] = score(d)
        # Famille : les scenes generees en lot (Veilleurs du Reseau, arenes
        # de legendaires) partagent un gabarit et se jugent entre elles ;
        # les scenes d'histoire sont ecrites a la main, une par une.
        if 'Veilleur' in brut or 'SV.Reseau' in brut:
            d['fam'] = 'reseau'
        elif 'LegendZones' in brut:
            d['fam'] = 'legendaire'
        else:
            d['fam'] = 'histoire'
        scenes.append(d)

    scenes.sort(key=lambda x: x['score'])

    if CSV:
        print('scene;score;boss;dialogues;camera;coroutines;effets;voix;apres')
        for d in scenes:
            print(f"{d['nom']};{d['score']};{d['boss']};{d['dialogues']};"
                  f"{d['camera']};{d['coro']};{d['fx']};{d['voix']};{d['apres']}")
        return

    ref = next((d for d in scenes if 'searing_tunnel_miniboss' in d['nom']), None)

    print('=' * 96)
    print('AUDIT DES CINEMATIQUES DE BOSS'.center(96))
    print('=' * 96)
    if ref:
        print(f"REFERENCE (Tunnel Ardent, clan de lave) : score {ref['score']}/100 · "
              f"{ref['boss']} boites du boss · {ref['camera']} cameras · "
              f"{ref['coro']} coroutines · {ref['fx']} effets")
        print('-' * 96)
    print(f"{'scene':44s} {'fam':>11s} {'score':>5s} {'boss':>5s} {'dial':>5s} "
          f"{'cam':>4s} {'coro':>5s} {'fx':>3s} {'voix':>5s} {'apres':>6s}")
    print('-' * 96)
    for d in scenes:
        alerte = '  <-- BOSS MUET' if d['boss'] == 0 else ''
        print(f"{d['nom'][:44]:44s} {d['fam']:>11s} {d['score']:5d} {d['boss']:5d} {d['dialogues']:5d} "
              f"{d['camera']:4d} {d['coro']:5d} {d['fx']:3d} {d['voix']:5d} "
              f"{d['apres']:6d}{alerte}")

    muets = [d for d in scenes if d['boss'] == 0]
    faibles = [d for d in scenes if 0 < d['score'] < 40]
    print('-' * 96)
    print(f"{len(scenes)} cinematiques de boss analysees.")
    print(f"  BOSS MUETS (0 boite)      : {len(muets)}")
    print(f"  score < 40 (hors muets)   : {len(faibles)}")
    if ref:
        au_niveau = [d for d in scenes if d['score'] >= ref['score']]
        print(f"  au niveau de la reference : {len(au_niveau)}/{len(scenes)}")
    if muets:
        print('\nA TRAITER EN PRIORITE (le boss ne dit pas un mot) :')
        for d in muets:
            print(f"    [{d['fam']}] {d['nom']}")

    # Moyenne par famille : c'est la vraie reponse a « est-ce que TOUT est
    # au niveau du Tunnel ? ».
    print('\nMOYENNE PAR FAMILLE :')
    for fam in ('histoire', 'reseau', 'legendaire'):
        g = [d for d in scenes if d['fam'] == fam]
        if not g:
            continue
        moy = sum(d['score'] for d in g) / len(g)
        mb = sum(d['boss'] for d in g) / len(g)
        print(f"  {fam:11s} {len(g):3d} scenes · score moyen {moy:5.1f}/100 · "
              f"{mb:4.1f} boites de boss en moyenne")


if __name__ == '__main__':
    main()
