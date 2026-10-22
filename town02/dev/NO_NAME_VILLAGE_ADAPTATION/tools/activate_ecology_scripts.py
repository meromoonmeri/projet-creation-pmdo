#!/usr/bin/env python3
"""Active les scripts écologiques : generated/fauna/ -> Data/Script/halcyon/.

Refuse d'installer si :
  - un script ne parse pas (luaparser) ;
  - une copie de NNVLife.lua peut encore définir source_birds/source_butterflies ;
  - build_rmvillage_life_patch.py peut encore les recréer ;
  - un fichier cible existe déjà avec un contenu différent et non sauvegardé.

NNVEcology doit rester l'unique propriétaire des individus injectés : chaque
entité écrite dans les Grounds porte nnv_owner = "NNVEcology".

Sans --apply : dry-run. Avec --apply : sauvegarde toute cible préexistante en
.pre-fauna.bak avant écrasement.
"""
from __future__ import annotations
import argparse, glob, hashlib, json, os, re, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
SRC = NNV / 'generated/fauna'
DST = ROOT / 'Data/Script/halcyon'
ECO = NNV / 'reports/fauna-ecology'

SCRIPTS = ['NNVEcology.lua', 'NNVDuel.lua']


def sha256(p: Path):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--backup', default='/tmp/fauna-backup/scripts')
    ns = ap.parse_args()

    problems = []

    # --- 1. syntaxe Lua reelle ---
    try:
        from luaparser import ast as lua_ast
    except ImportError:
        print('ECHEC: luaparser indisponible, impossible de valider la syntaxe')
        return 1
    for s in SCRIPTS:
        p = SRC / s
        if not p.exists():
            problems.append('source absente: %s' % s)
            continue
        try:
            lua_ast.parse(p.read_text(encoding='utf-8'))
        except Exception as e:
            problems.append('%s: syntaxe invalide (%s)' % (s, str(e)[:120]))

    # --- 2. aucun double pilotage possible ---
    for lf in glob.glob(str(ROOT / '**/NNVLife.lua'), recursive=True):
        if '/.git/' in lf:
            continue
        t = open(lf, encoding='utf-8').read()
        rel = os.path.relpath(lf, ROOT)
        if re.search(r'source_(birds|butterflies)\s*=', t):
            problems.append('%s definit encore source_birds/butterflies' % rel)
        for ent in ('NNV_SourceBird_', 'NNV_SourceButterfly_'):
            if ent in t:
                problems.append('%s reference encore %s' % (rel, ent))
    gen = NNV / 'tools/build_rmvillage_life_patch.py'
    if gen.exists():
        g = open(gen, encoding='utf-8').read().replace(' ', '')
        if 'EMIT_SOURCE_ANIMALS=False' not in g:
            problems.append('build_rmvillage_life_patch.py peut recreer les '
                            'animaux source -> double pilotage')

    # --- 3. cibles ---
    plan = []
    for s in SCRIPTS:
        src, dst = SRC / s, DST / s
        action = 'CREATE'
        if dst.exists():
            if sha256(dst) == sha256(src):
                action = 'UNCHANGED'
            else:
                action = 'OVERWRITE (sauvegarde prealable)'
        plan.append({'script': s, 'action': action,
                     'bytes': src.stat().st_size if src.exists() else 0,
                     'sha256': sha256(src) if src.exists() else None})

    for p in plan:
        print('%-16s %-32s %6d o' % (p['script'], p['action'], p['bytes']))

    if problems:
        print('\nINSTALLATION REFUSEE: %d probleme(s)' % len(problems))
        for x in problems:
            print('  -', x)
        return 1
    print('\ncontroles prealables: OK (syntaxe, double pilotage, generateur)')

    if not ns.apply:
        print('DRY-RUN : rien n a ete ecrit (relancer avec --apply)')
        return 0

    os.makedirs(ns.backup, exist_ok=True)
    report = {'schema': 'nnv-ecology-activation-v1', 'installed': []}
    for p in plan:
        src, dst = SRC / p['script'], DST / p['script']
        if dst.exists():
            bak = Path(ns.backup) / (p['script'] + '.pre-fauna.bak')
            if not bak.exists():
                shutil.copy2(dst, bak)
        shutil.copy2(src, dst)
        after = sha256(dst)
        if after != p['sha256']:
            print('ECHEC: copie divergente pour', p['script'])
            return 1
        report['installed'].append({'script': p['script'], 'sha256': after,
                                    'bytes': dst.stat().st_size})
        print('installe %s (sha %s)' % (p['script'], after[:12]))

    # --- 4. relecture post-installation ---
    for r in report['installed']:
        dst = DST / r['script']
        try:
            lua_ast.parse(dst.read_text(encoding='utf-8'))
        except Exception as e:
            print('ECHEC: %s installe mais illisible (%s)' % (r['script'], e))
            return 1
    print('relecture post-installation: syntaxe OK')

    (ECO / 'ecology-activation.json').write_text(
        json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())
