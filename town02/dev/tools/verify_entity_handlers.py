#!/usr/bin/env python3
"""verify_entity_handlers — croise les handlers Lua et les entites reellement
presentes dans les .rsground.

ANGLE MORT QU'IL FERME
----------------------
Le commit ee06be8 (2026-08-02) a livre 98 lignes de Quizz de Kirlia avec son
handler `metano_town.Kirlia_Action`, alors qu'aucune entite `Kirlia` n'existait
dans metano_town.rsground ni dans aucune autre carte. Le code compilait, tous
les outils passaient au vert, et le contenu etait totalement injouable.
Aucun outil existant ne detectait ce cas.

Symetriquement, audit_bugs.py detecte deja le sens inverse (entite sans
handler = objet muet). Ici on detecte le sens manquant : handler sans entite.

CE QUE L'OUTIL VERIFIE
----------------------
  A. handler `<map>.<Nom>_Action` / `_Touch` / `_Think` / `_EntSpawned`
     sans entite `<Nom>` dans `<map>.rsground`, ET sans creation dynamique
     par CharacterEssentials.MakeCharactersFromList / MakeCharacterAtMarker.
  B. appel MakeCharactersFromList{'X'} ou X n'est pas declare dans la table
     `characters` de CharacterEssentials.lua (cas Goinfrex, 4e1d765).

Usage : python3 tools/verify_entity_handlers.py .
Sortie : code 1 si au moins une anomalie de categorie A ou B.
"""
import json
import os
import re
import sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
SCRIPT_DIR = os.path.join(ROOT, 'Data', 'Script')
CE_PATH = os.path.join(SCRIPT_DIR, 'halcyon', 'CharacterEssentials.lua')

EVENTS = ('Action', 'Touch', 'Think', 'EntSpawned')

# Entites fournies par le moteur ou par le patron de spawn, jamais dans le
# .rsground sous ce nom exact.
ENGINE_ENTS = {'PLAYER', 'Teammate1', 'Teammate2', 'Teammate3',
               'TEAMMATE_1', 'TEAMMATE_2', 'TEAMMATE_3'}


def strip_comments(src):
    src = re.sub(r'--\[(=*)\[.*?\]\1\]', '', src, flags=re.S)
    return '\n'.join(re.sub(r'--.*$', '', l) for l in src.split('\n'))


def ground_entities(name):
    p = os.path.join(GROUND_DIR, name + '.rsground')
    if not os.path.isfile(p):
        return None
    try:
        doc = json.load(open(p, encoding='utf-8-sig'))
    except Exception:
        return None
    out = set()

    def walk(x):
        if isinstance(x, dict):
            if 'EntName' in x:
                out.add(x['EntName'])
            if 'NPCName' in x:
                out.add(x['NPCName'])
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(doc.get('Object', doc))
    return out


def shared_spawn_names():
    """Noms de personnages instancies par les modules PARTAGES (hors dossier
    de carte) : TownNight.lua, MidpointTemplate.lua, npc_routines.lua,
    DazzlingArc.lua... Un handler de carte peut legitimement cibler une
    entite creee par l'un d'eux ; sans cette passe, l'outil hurle a tort."""
    names = set()
    hal = os.path.join(SCRIPT_DIR, 'halcyon')
    if not os.path.isdir(hal):
        return names
    for f in sorted(os.listdir(hal)):
        if not f.endswith('.lua'):
            continue
        src = strip_comments(open(os.path.join(hal, f), encoding='utf-8',
                                  errors='replace').read())
        names |= set(re.findall(r"\{\s*'([A-Za-z_]\w*)'\s*,", src))
        names |= set(re.findall(r'\{\s*"([A-Za-z_]\w*)"\s*,', src))
        names |= set(re.findall(r"MakeCharacterAtMarker\(\s*['\"]([\w]+)['\"]", src))
        names |= set(re.findall(r"SpawnerDoSpawn\(\s*['\"]([\w]+)['\"]", src))
        names |= set(re.findall(r'Ground(?:Object|Char)\((?:[^()]|\([^()]*\))*?["\']([A-Za-z_]\w*)["\']\s*\)', src, re.S))
    return names


def main():
    shared = shared_spawn_names()

    # 1. casting declare dans CharacterEssentials
    cast = set()
    if os.path.isfile(CE_PATH):
        ce = open(CE_PATH, encoding='utf-8').read()
        start = ce.find('local characters = {')
        if start >= 0:
            cast = set(re.findall(r'^\t\t(\w+) = \{', ce[start:], re.M))

    # 2. parcours des dossiers de ground scriptes
    missing_ent = []
    missing_cast = []
    checked = 0

    for ns in sorted(os.listdir(SCRIPT_DIR)):
        gdir = os.path.join(SCRIPT_DIR, ns, 'ground')
        if not os.path.isdir(gdir):
            continue
        for mapname in sorted(os.listdir(gdir)):
            mdir = os.path.join(gdir, mapname)
            if not os.path.isdir(mdir):
                continue
            ents = ground_entities(mapname)
            if ents is None:
                continue          # carte sans .rsground : hors perimetre
            checked += 1

            src = ''
            for f in sorted(os.listdir(mdir)):
                if f.endswith('.lua'):
                    src += strip_comments(
                        open(os.path.join(mdir, f), encoding='utf-8',
                             errors='replace').read()) + '\n'

            # Entites creees a la volee dans CE dossier.
            # Les listes passees a MakeCharactersFromList sont souvent
            # multi-lignes : { {'A', x, y, dir},\n {'B', ...} }. On collecte
            # donc TOUTES les entrees de forme {'Nom', ... } du fichier, pas
            # seulement la premiere de chaque appel — sinon on produit des
            # centaines de faux positifs sur les PNJ de campement.
            dynamic = set(re.findall(r"\{\s*'([A-Za-z_]\w*)'\s*,", src))
            dynamic |= set(re.findall(r'\{\s*"([A-Za-z_]\w*)"\s*,', src))
            # references sans coordonnees : { {'Nom'} } (perso hors carte)
            dynamic |= set(re.findall(r"\{\s*\{\s*'([A-Za-z_]\w*)'\s*\}", src))
            dynamic |= set(re.findall(r"MakeCharacterAtMarker\(\s*'([\w]+)'", src))
            dynamic |= set(re.findall(r'MakeCharacterAtMarker\(\s*"([\w]+)"', src))
            # spawners actives par script : GROUND:SpawnerDoSpawn('Nom')
            dynamic |= set(re.findall(r"SpawnerDoSpawn\(\s*'([\w]+)'", src))
            dynamic |= set(re.findall(r'SpawnerDoSpawn\(\s*"([\w]+)"', src))
            # objets/personnages construits directement par l'API moteur :
            # RogueEssence.Ground.GroundObject(..., "Nom") / GroundChar(..., "Nom")
            dynamic |= set(re.findall(r'Ground(?:Object|Char)\((?:[^()]|\([^()]*\))*?["\']([A-Za-z_]\w*)["\']\s*\)', src, re.S))

            # Categorie B : on ne controle QUE les noms passes a un appel
            # MakeCharacters* reel. `dynamic` ci-dessus est volontairement
            # large (il sert a innocenter les handlers) et ramasse aussi des
            # tables d'objets — l'utiliser ici produirait des faux positifs
            # du genre « xcl_element_fire_silk absent du casting ».
            for m in re.finditer(r'MakeCharactersFromList\(\s*(\{.*?\})\s*[,)]',
                                 src, re.S):
                blob = m.group(1)
                if len(blob) > 4000:
                    continue
                for name in re.findall(r"\{\s*['\"]([A-Za-z_]\w*)['\"]", blob):
                    if cast and name not in cast and name not in ENGINE_ENTS:
                        missing_cast.append((mapname, name))
            for m in re.finditer(r"MakeCharacterAtMarker\(\s*['\"]([\w]+)['\"]", src):
                name = m.group(1)
                if cast and name not in cast and name not in ENGINE_ENTS:
                    missing_cast.append((mapname, name))

            # Seuls les handlers definis sur la table de la carte elle-meme
            # (`<map>.Nom_Action`) sont appeles par le moteur. Les fonctions
            # portees par un sous-module de chapitre
            # (`<map>_ch_5.Ganlon_Action`) sont des fonctions INTERNES,
            # invoquees depuis un vrai handler (`Teammate2_Action`) : leur nom
            # ne correspond a aucune entite et les signaler est un faux positif.
            pat = (r'^function\s+%s\.(\w+)_(%s)\s*\('
                   % (re.escape(mapname), '|'.join(EVENTS)))
            seen_pairs = set()
            for ent, ev in re.findall(pat, src, re.M):
                if (ent, ev) in seen_pairs:
                    continue
                seen_pairs.add((ent, ev))
                if ent in ENGINE_ENTS or ent in ents or ent in dynamic \
                        or ent in shared:
                    continue
                # certains handlers ciblent une entite d'une AUTRE carte
                # (routage) : on ne signale que si le nom n'existe nulle part.
                missing_ent.append((mapname, ent, ev))

    print('=' * 78)
    print('verify_entity_handlers — handlers Lua sans entite reelle'.center(78))
    print('=' * 78)
    print('%d carte(s) scriptee(s) avec .rsground examinee(s)\n' % checked)

    if missing_ent:
        print('### A. HANDLER SANS ENTITE (contenu injouable) : %d' % len(missing_ent))
        for m, e, ev in missing_ent:
            print('    %-28s %s_%s  -> aucune entite « %s » dans %s.rsground'
                  % (m, e, ev, e, m))
        print()
    if missing_cast:
        print('### B. PERSONNAGE CREE MAIS NON DECLARE DANS CharacterEssentials : %d'
              % len(missing_cast))
        for m, n in missing_cast:
            print('    %-28s « %s » absent de la table characters' % (m, n))
        print()

    total = len(missing_ent) + len(missing_cast)
    if total == 0:
        print('RESULTAT : aucun handler orphelin, aucun personnage fantome.')
    else:
        print('=' * 78)
        print('TOTAL : %d anomalie(s)' % total)
    return 1 if total else 0


if __name__ == '__main__':
    sys.exit(main())
