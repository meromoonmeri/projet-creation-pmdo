#!/usr/bin/env python3
"""Compte les lignes de dialogue par chapitre (quota Prompt Maitre : 7000/chapitre des le ch5).
Une 'ligne' = un appel UI:WaitShowDialogue / StartConversation / WaitShowTimedDialogue."""
import re, glob, sys, collections

# Appels bruts au moteur, PLUS les helpers locaux qui les enveloppent
# (say/think/narrate/voice dans ChapterAftermath.lua et DazzlingArc.lua).
# Sans eux, un module ecrit proprement avec des helpers paraissait vide :
# DazzlingArc affichait 3 lignes au lieu de 77.
PAT = re.compile(
    r'WaitShowDialogue|StartConversation|WaitShowTimedDialogue'
    r'|^\s*(?:say|think|narrate|voice)\(', re.M)

# Modules a FICHES : la replique n'est pas un appel, c'est une valeur dans
# une table lue plus tard par un unique StartConversation. TownVoices,
# TownVoicesNight et TownVoicesLate totalisent 668 boites de dialogue et
# n'en affichaient que 3 — une par module. On compte donc aussi les
# champs de palier, qui sont bien des boites vues par le joueur.
FICHE_PAT = re.compile(
    r'^\s*(?:early|pre|during|post|quests|defendue|pillee)\s*=\s*"', re.M)
FICHE_FILES = {'TownVoices.lua', 'TownVoicesNight.lua', 'TownVoicesLate.lua'}

# Modules GLOBAUX rattaches a un chapitre precis. Sans cette table, leurs
# repliques tombaient dans « commun » et le chapitre paraissait plus pauvre
# qu'il ne l'est : DazzlingArc (ch6) pesait 77 lignes comptees nulle part.
GLOBAL_CH = {
    'DazzlingArc.lua': 6,
    'SideQuests.lua': 6,      # requetes de Metano (fiches declaratives)
    'TownVoices.lua': 6,      # 26 habitants du ch6
    'ChapterAftermath.lua': None,   # scenes ch8+ch9+ch10, ventilees a la main
    'TownVoicesNight.lua': None,    # reactions aux raids, tous chapitres 6+
    'TownVoicesLate.lua': None,     # ch7 a ch10, ventile par bloc FICHES[N]
    'TownVoicesArc.lua': None,      # ch8/9/10, ventile par table CH8/CH9/CH10
    'SideExpeditions.lua': None,    # ch8/9/10, ventile par champ ch = N
    'MeuteArc.lua': None,           # ch8/9/10, un acte par chapitre
}

# Modules couvrant PLUSIEURS chapitres : on lit le bloc de chacun pour
# attribuer les repliques au bon chapitre, au lieu de tout jeter dans
# « multi-chapitres ».
def split_by_chapter(path):
    t = open(path, encoding='utf-8', errors='replace').read()
    out = {}
    for m in re.finditer(r'FICHES\[(\d+)\] = \{(.*?)\n\}', t, re.S):
        out[int(m.group(1))] = len(FICHE_PAT.findall(m.group(2)))
    # TownVoicesArc : une table par chapitre, cinq etats par fiche.
    # Sans ce bloc, ses 190 boites tombaient dans « multi-chapitres ».
    # SideExpeditions : chaque entree porte son chapitre (ch = N) et ses
    # repliques sont des tuples {'PNJ','emo',"texte"}. Sans ce bloc, ses
    # 60 boites tombaient dans « multi-chapitres ».
    # MeuteArc : trois actes, un par chapitre (Act1=ch8, Act2=ch9, Act3=ch10).
    if 'MeuteArc.ACTS' in t:
        for n, ch in ((1, 8), (2, 9), (3, 10)):
            m = re.search(r'function MeuteArc\.Act%d\((.*?)\nend\n' % n, t, re.S)
            if m:
                out[ch] = out.get(ch, 0) + len(
                    re.findall(r'^\s*(?:say|narrate|think)\(', m.group(1), re.M))
        return out
    if 'SideExpeditions.LIST' in t:
        for bloc in re.findall(r"id = 'x\d+_\w+', ch = (\d+),(.*?)undertow", t, re.S):
            n = len(re.findall(r"\{'\w+',\s*'[\w-]+',", bloc[1]))
            out[int(bloc[0])] = out.get(int(bloc[0]), 0) + n
        return out
    for m in re.finditer(r'TownVoicesArc\.CH(\d+) = \{(.*?)\n\}\n', t, re.S):
        n = len(re.findall(r'^    (?:early|pre|during|post|quests)\s*=',
                           m.group(2), re.M))
        if n:
            out[int(m.group(1))] = out.get(int(m.group(1)), 0) + n
    return out

def count_file(path):
    t = open(path, encoding='utf-8', errors='replace').read()
    t = re.sub(r'--\[\[.*?\]\]', '', t, flags=re.S)
    t = re.sub(r'--[^\n]*', '', t)
    n = len(PAT.findall(t))
    if path.split('/')[-1] in FICHE_FILES:
        n += len(FICHE_PAT.findall(t))
    return n

per_ch = collections.Counter()
detail = collections.defaultdict(list)
for f in glob.glob('Data/Script/halcyon/**/*.lua', recursive=True):
    m = re.search(r'_ch_(\d+)\.lua$', f)
    n = count_file(f)
    if n == 0: continue
    base = f.split('/')[-1]
    forced = GLOBAL_CH.get(base)
    if base in GLOBAL_CH and forced is None:
        # TownVoicesArc ventile aussi par chapitre (tables CH8/CH9/CH10).
        parts = (split_by_chapter(f)
                 if base in ('TownVoicesLate.lua', 'TownVoicesArc.lua',
                             'SideExpeditions.lua', 'MeuteArc.lua') else {})
        if parts:
            for c, cn in parts.items():
                per_ch[c] += cn
                detail[c].append((cn, base))
            continue
        per_ch['multi-chapitres'] = per_ch.get('multi-chapitres', 0) + n
        continue
    if m or forced:
        ch = int(m.group(1)) if m else forced
        per_ch[ch] += n
        detail[ch].append((n, f.split('/')[-1]))
    else:
        per_ch['commun'] += n

ch = sys.argv[1] if len(sys.argv) > 1 else None
if ch:
    ch = int(ch)
    for n, f in sorted(detail[ch], reverse=True):
        print(f'{n:5d}  {f}')
    print(f'--- CHAPITRE {ch} : {per_ch[ch]} lignes scriptees (quota 7000 des ch5)')
else:
    for k in sorted([k for k in per_ch if isinstance(k, int)]):
        goal = ' / 7000' if k >= 5 else ''
        print(f'ch{k:<2} : {per_ch[k]:5d}{goal}')
    for k in per_ch:
        if isinstance(k, str) and k != 'commun':
            print(f'{k} : {per_ch[k]}')
    print(f'commun (init.lua, helpers...) : {per_ch["commun"]}')
