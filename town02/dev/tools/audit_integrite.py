#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Audit d'integrite GLOBAL du mod — recherche d'erreurs reelles.

Ne verifie PAS la syntaxe (validate_all / lupa le font deja) mais les
incoherences qui passent la compilation et cassent le jeu a l'execution :

  1. PARAMETRES MORTS      un helper recoit un callback et ne l'appelle pas
                           (le bug de la Genese : camFn/spriteFn ignores)
  2. PERSONNAGES FANTOMES  MakeCharactersFromList sur une cle absente de
                           CharacterEssentials -> erreur Lua en pleine scene
  3. CLES .resx MANQUANTES  MapStrings['X'] sans entree EN ou FR
  4. CLES DUPLIQUEES       deux cles au texte identique dans le meme fichier
                           (le bug GENV_018/019 : phrase dite deux fois)
  5. INSTANCES INCONNUES   GROUND:Hide/Unhide sur un nom jamais cree
  6. SONS / MUSIQUES       references sans aucune autre occurrence (typo)
  7. SCENES MUETTES        cinematique de boss sans PlayBGM
  8. CLES .resx ORPHELINES texte ecrit mais jamais affiche

Usage : python3 tools/audit_integrite.py [racine]
"""
import os, re, sys, glob, json, collections

R = sys.argv[1] if len(sys.argv) > 1 else '.'
SC = os.path.join(R, 'Data/Script/halcyon')
pb = collections.defaultdict(list)


def nocom(s):
    s = re.sub(r'--\[\[.*?\]\]', '', s, flags=re.S)
    return re.sub(r'--[^\n]*', '', s)


def rel(p):
    return os.path.relpath(p, R)


# --- casting connu -----------------------------------------------------
ce = open(os.path.join(SC, 'CharacterEssentials.lua'), encoding='utf-8').read()
CAST = set(re.findall(r"^\s*(\w+)\s*=\s*\{", ce, re.M))
CAST |= set(re.findall(r"instance\s*=\s*'(\w+)'", ce))

# --- balayage ----------------------------------------------------------
luas = glob.glob(os.path.join(SC, '**', '*.lua'), recursive=True)
son_glob = collections.Counter()
for p in luas:
    c = nocom(open(p, encoding='utf-8', errors='replace').read())
    for s in re.findall(r'PlayBattleSE\([\'"]([^\'"]+)', c): son_glob[s] += 1
    for s in re.findall(r'PlayBGM\([\'"]([^\'"]+)', c): son_glob[s] += 1
    for s in re.findall(r'PlaySE\([\'"]([^\'"]+)', c): son_glob[s] += 1

for p in luas:
    raw = open(p, encoding='utf-8', errors='replace').read()
    c = nocom(raw)
    d = os.path.dirname(p)

    # 1. parametres de fonction jamais utilises dans le corps
    for m in re.finditer(r'function\s+[\w.:]*\s*\(([^)]*)\)', c):
        args = [a.strip() for a in m.group(1).split(',') if a.strip()]
        cb = [a for a in args if re.search(r'(Fn|Func|callback|cb)$', a)]
        if not cb:
            continue
        nxt = c.find('\nfunction ', m.end())
        body = c[m.end(): nxt if nxt > 0 else len(c)]
        for a in cb:
            if not re.search(re.escape(a) + r'\s*\(', body):
                pb['1. PARAMETRE MORT (callback jamais appele)'].append(
                    f'{rel(p)} :: parametre `{a}` recu mais jamais invoque')

    # 2. personnages inexistants
    for m in re.finditer(r"MakeCharactersFromList\(\s*\{(.{0,900}?)\}\s*\)", c, re.S):
        for nm in re.findall(r"\{\s*'(\w+)'", m.group(1)):
            if nm not in CAST:
                pb['2. PERSONNAGE FANTOME'].append(
                    f'{rel(p)} :: `{nm}` absent de CharacterEssentials')

    # 3/8. cles .resx
    used = set(re.findall(r"MapStrings\[['\"](\w+)['\"]\]", c))
    used |= set(re.findall(r"BossFX\.Voice\(['\"](\w+)['\"]", c))
    used |= set(re.findall(r"key=['\"](\w+)['\"]", c))
    if used:
        for lang in ('strings.resx', 'strings.fr.resx'):
            f = os.path.join(d, lang)
            if not os.path.exists(f):
                # Un module GLOBAL (SuaireArc, LegendArc...) utilise du texte
                # litteral et n'a pas de .resx : ce n'est pas une anomalie.
                continue
            have = set(re.findall(r'name="([^"]+)"',
                                  open(f, encoding='utf-8').read()))
            for k in sorted(used - have):
                pb['3. CLE .resx MANQUANTE'].append(f'{rel(f)} :: `{k}`')

ALLCODE = ''.join(nocom(open(x, encoding='utf-8', errors='replace').read())
                  for x in luas)

# 4/8. doublons + orphelines
for f in glob.glob(os.path.join(SC, '**', 'strings*.resx'), recursive=True):
    s = open(f, encoding='utf-8').read()
    ent = re.findall(r'name="([^"]+)"[^>]*>\s*<value>(.*?)</value>', s, re.S)
    txt = collections.defaultdict(list)
    for k, v in ent:
        v = v.strip()
        if len(v) > 12:
            txt[v].append(k)
    for v, ks in txt.items():
        if len(ks) < 2:
            continue
        # Doublon PROBLEMATIQUE seulement si les cles se suivent : le joueur
        # lit alors deux fois la meme phrase de suite (bug GENV_018/019).
        # Deux variantes eloignees sont un choix d'ecriture, pas une erreur.
        nums = sorted(int(n) for k in ks for n in re.findall(r'(\d+)$', k))
        if len(nums) > 1 and any(b - a == 1 for a, b in zip(nums, nums[1:])):
            pb['4. TEXTE DUPLIQUE CONSECUTIF'].append(
                f'{rel(f)} :: {", ".join(ks)} -> "{v[:58]}"')

    # Seules les deux langues MAINTENUES comptent (EN de reference, FR jouable).
    # Les .resx de/es/it/ja/ko/pt/zh viennent d'Halcyon et ne sont pas suivis.
    if not re.search(r'strings(\.fr)?\.resx$', f):
        continue
    d = os.path.dirname(f)
    code = ''.join(nocom(open(x, encoding='utf-8', errors='replace').read())
                   for x in glob.glob(os.path.join(d, '*.lua')))
    # Un ground peut etre pilote par un module global : on cherche aussi la
    # cle dans TOUT le code du mod avant de la declarer orpheline.
    for k, _ in ent:
        if k in ('resmimetype', 'version', 'reader', 'writer'):
            continue          # en-tetes techniques du format .resx
        if k not in code and k not in ALLCODE:
            pb['8. CLE .resx ORPHELINE (jamais affichee)'].append(f'{rel(f)} :: `{k}`')

# 5. instances Hide/Unhide inconnues
# Une entite peut venir de TROIS sources : creee par script, listee dans
# CharacterEssentials, ou POSEE SUR LA CARTE (.rsground). Sans lire les
# cartes, on signale a tort tous les objets de decor (Food_*, portes...).
def ents_carte(ground):
    f = os.path.join(R, 'Data/Ground', ground + '.rsground')
    if not os.path.exists(f):
        return set()
    try:
        o = json.load(open(f, encoding='utf-8-sig'))['Object']
    except Exception:
        return set()
    out = set()
    for lay in o.get('Entities', []):
        for k in ('GroundObjects', 'MapChars', 'Spawners', 'Markers'):
            for e in lay.get(k, []) or []:
                n = e.get('EntName')
                if n:
                    out.add(n)
    return out

for p in luas:
    c = nocom(open(p, encoding='utf-8', errors='replace').read())
    made = set(re.findall(r"\{\s*'(\w+)'\s*,", c)) | set(re.findall(r"'(\w+)'\s*,\s*\d+\s*,\s*\d+", c))
    carte = ents_carte(os.path.basename(os.path.dirname(p)))
    for nm in set(re.findall(r"GROUND:(?:Un)?[Hh]ide\(\s*'(\w+)'", c)):
        if nm in made or nm in CAST or nm in carte:
            continue
        if re.search(r'Event_|Trigger|Marker|Object|_Rock|Door', nm):
            continue
        pb['5. INSTANCE INCONNUE (Hide/Unhide)'].append(f'{rel(p)} :: `{nm}`')

# 6. sons references une seule fois (typo probable)
for s, n in son_glob.items():
    if n == 1 and not s.endswith('.ogg'):
        for p in luas:
            if re.search(r'[\'"]' + re.escape(s) + r'[\'"]',
                         nocom(open(p, encoding='utf-8', errors='replace').read())):
                pb['6. SON UNIQUE (typo possible)'].append(f'{rel(p)} :: `{s}`')
                break

# 7. cinematiques de boss sans musique
for p in luas:
    raw = open(p, encoding='utf-8', errors='replace').read()
    # BossMusic.Play est l'indirection PROPRE du projet vers PlayBGM
    # (BossMusic.lua:194). 53 arenes l'emploient sans jamais ecrire
    # PlayBGM en clair : les signaler serait un faux positif de masse et
    # pousserait a coder les pistes en dur, ce qu'on veut eviter.
    # On ne garde donc que les scenes qui n'ont NI l'un NI l'autre.
    txt = nocom(raw)
    if 'COMMON.BossTransition()' in raw \
       and 'PlayBGM' not in txt and 'BossMusic.Play' not in txt:
        pb['7. SCENE DE BOSS SANS MUSIQUE'].append(rel(p))

# --- rapport -----------------------------------------------------------
print('=' * 78)
print('AUDIT D INTEGRITE — recherche d erreurs reelles'.center(78))
print('=' * 78)
tot = 0
for cat in sorted(pb):
    v = pb[cat]
    tot += len(v)
    print(f'\n### {cat} : {len(v)}')
    for x in v[:24]:
        print('   ', x)
    if len(v) > 24:
        print(f'    ... et {len(v)-24} autres')
print('\n' + '=' * 78)
print(f'TOTAL : {tot} anomalie(s)' if tot else 'AUCUNE ANOMALIE')
print('=' * 78)
