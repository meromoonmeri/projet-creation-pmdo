#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_cast_audit.py — preuve automatisée ROM_CAST vs PMDO_CAST.

Pour chaque scène COMPILED : les acteurs NPC nommés qui ont un RÔLE
NARRATIF dans le SSB ROM (parole via message_SetFace/message_Talk,
mouvement, apparition) doivent exister dans le module Lua compilé
(spawn_npc ou référence). Hero (PLAYER*) et Partner (ATTENDANT*)
doivent être utilisés si la ROM les emploie.

Les acteurs qui n'apparaissent QUE dans des routines d'idle triviales
(`def N for actor X { SetAnimation/hold/Wait* }`) n'ont AUCUN contenu
narratif : leur absence du Lua n'est pas une perte (la ROM ne fait que
poser leur animation d'attente) — comptés IDLE_ONLY.

Sortie : Docs/CAST_AUDIT.json + preuve jsonl.
"""
import glob
import gzip
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
SCENES = os.path.join(REPO, 'Data', 'Script', 'halcyon', 'skyscenes')

TRIVIAL_ROUTINE = re.compile(
    r"def\s+\d+\s+for\s+actor\s+ACTOR_([A-Z0-9_]+)\s*\{"
    r"(?:\s*(?:SetAnimation\([^)]*\);|hold;|Wait\(\d+\);|"
    r"WaitScreenFade(?:All)?\(\);|WaitLockLives\([^)]*\);|"
    r"WaitExecuteLives\([^)]*\);|WaitAnimation\(\);|"
    r"Turn2Direction\([^)]*\);|SetPositionInitial\([^)]*\);|"
    r"SetEffect\([^)]*\);|Lock\(\d+\);|Unlock\(\d+\);|"
    r"end;|@label_\d+;))*\s*\}", re.S)


def main():
    report = json.load(open(os.path.join(
        CAMP, 'Docs', 'SCENE_COMPILER_REPORT.json')))
    counts = Counter()
    details = OrderedDict()
    cache = {}
    for key, v in report['scenes'].items():
        if v.get('status') != 'COMPILED':
            continue
        zone, ssb = key.split('/')
        mod = f"{zone.lower()}__{ssb[:-4]}"
        lua_p = os.path.join(SCENES, mod + '.lua')
        if not os.path.exists(lua_p):
            counts['NO_LUA'] += 1
            continue
        lua = open(lua_p).read()
        if zone not in cache:
            cache[zone] = json.load(gzip.open(
                os.path.join(RS, zone + '.json.gz'), 'rt'))
        src = cache[zone]['scripts'][ssb].get('explorerscript', '')
        # acteurs à routine PUREMENT triviale (idle) : sans rôle narratif
        idle_only = set()
        body = src
        for m in TRIVIAL_ROUTINE.finditer(src):
            idle_only.add(m.group(1))
            body = body.replace(m.group(0), '')
        sc = re.sub(r'"""(?:.|\n)*?"""', '', body)
        sc = re.sub(r"'(?:[^'\\]|\\.)*'", "''", sc)
        rom_actors = set(re.findall(r'ACTOR_([A-Z0-9_]+)', sc))
        named = {a for a in rom_actors
                 if a.startswith('NPC_') and a not in idle_only
                 # rôles héros/partenaire de démo -> duo courant
                 # (résolution actor_expr du compilateur)
                 and a not in ('NPC_DEMO_HERO', 'NPC_DEMO_PARTNER',
                               'NPC_HERO_FIRST', 'NPC_PARTNER_FIRST',
                               'NPC_PARTNER', 'NPC_HERO')}
        missing = []
        NARRATIVE_OPS = {'message_Talk', 'message_Monologue',
                         'message_SetFace', 'message_SetFaceOnly',
                         'message_SetActor', 'MovePositionMark',
                         'Move2PositionMark', 'MovePositionOffset',
                         'SlidePositionMark', 'Slide2PositionMark',
                         'ExecuteCommon', 'SetEffect'}
        for a in named:
            # rôle réel de l'acteur dans le SSB : uniquement décoratif
            # (déclaration/SetAnimation idle) = pas de contenu narratif
            used = set(re.findall(r'(\w+)<actor ACTOR_' + a + '>', sc))
            used |= set(re.findall(r'(\w+)\([^)]*ACTOR_' + a, sc))
            if not (used & NARRATIVE_OPS):
                continue
            var = 'npc_' + re.sub(r'\W', '_', a.lower())
            if var in lua or a in lua:
                continue
            # orientation documentée vers cible sans placement = OK
            if f'vers ACTOR_{a}' in lua:
                continue
            # locuteur hors champ : identité préservée par SetSpeaker
            # espèce ROM (`-- locuteur <KEY>` émis par le compilateur)
            if f'locuteur {a}' in lua or f'message_SetActor(ACTOR_{a})' in lua:
                continue
            missing.append(a)
        rom_hero = any(a.startswith('PLAYER') for a in rom_actors)
        rom_partner = any(a.startswith('ATTENDANT') for a in rom_actors)
        st = 'PASS'
        if rom_hero and 'hero' not in lua:
            st = 'HERO_MISSING'
        elif rom_partner and 'partner' not in lua:
            st = 'PARTNER_MISSING'
        elif missing:
            st = 'CAST_MISSING'
        counts[st] += 1
        if st != 'PASS':
            details[key] = {'status': st, 'missing': sorted(missing),
                            'idle_only': sorted(idle_only & rom_actors)}
    out = {'schema': 'sky-cast-audit/1',
           'rule': ('acteur NPC à rôle narratif ROM (hors routines idle '
                    'triviales) doit être présent dans le Lua compilé ; '
                    'hero/partner obligatoires si la ROM les emploie'),
           'totals': dict(counts), 'failures': details}
    p = os.path.join(CAMP, 'Docs', 'CAST_AUDIT.json')
    json.dump(out, open(p, 'w'), indent=1, ensure_ascii=False)
    print(dict(counts))
    print(p)


if __name__ == '__main__':
    main()
