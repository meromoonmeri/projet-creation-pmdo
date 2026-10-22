#!/usr/bin/env python3
"""Synchronise config/fauna-context.json -> E.DENSITY dans NNVEcology.lua.

Le JSON est la source de vérité éditable ; le Lua est généré. Ajouter une
espèce ou ajuster une densité saisonnière ne demande donc pas de toucher au
moteur de vie.

Vérifie après écriture que le Lua parse toujours.
"""
from __future__ import annotations
import argparse, json, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
TARGETS = [ROOT / 'Data/Script/halcyon/NNVEcology.lua',
           NNV / 'generated/fauna/NNVEcology.lua']


def tbl(d):
    return '{' + ', '.join('%s=%s' % (k, v) for k, v in d.items()) + '}'


def build_block(ctx):
    sc = ctx['species_context']
    lines = []
    for sp in sorted(sc):
        c = sc[sp]
        parts = []
        for key in ('seasons', 'time', 'weather'):
            if c.get(key):
                parts.append('%s=%s' % (key, tbl(c[key])))
        if parts:
            lines.append('  %s = {%s},' % (sp, ', '.join(parts)))
    return ('-- Densités contextuelles, générées depuis config/fauna-context.json.\n'
            '-- Modifier le JSON puis relancer tools/sync_fauna_context.py.\n'
            'E.DENSITY = {\n' + '\n'.join(lines) + '\n}\n'), len(lines)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    ns = ap.parse_args()

    ctx = json.load(open(NNV / 'config/fauna-context.json'))
    block, n = build_block(ctx)

    spec = json.load(open(NNV / 'config/fauna-species.json'))['species']
    unknown = [s for s in ctx['species_context'] if s not in spec]
    if unknown:
        print('ECHEC: especes inconnues dans le contexte:', unknown)
        return 1
    missing = [s for s in spec if s not in ctx['species_context']]
    if missing:
        print('ATTENTION: especes sans contexte (densite 1.0 par defaut):', missing)

    # GARDE : une espece PROMUE ne doit jamais devenir invisible toute l'annee.
    # Un contexte tout a zero effacerait silencieusement des individus deja
    # certifies et injectes -> regression invisible en jeu.
    ev_path = NNV / 'reports/fauna-ecology/evidence-classification.json'
    held = set()
    if ev_path.exists():
        held = set(json.load(open(ev_path))['held_species'])
    dead = []
    for sp, c in ctx['species_context'].items():
        if sp in held or c.get('status', '').startswith('HELD'):
            continue
        seasons = c.get('seasons') or {}
        if seasons and max(seasons.values()) <= 0:
            dead.append('%s: densite saisonniere nulle toute l annee' % sp)
        times = c.get('time') or {}
        if times and max(times.values()) <= 0:
            dead.append('%s: densite horaire nulle a toute heure' % sp)
    if dead:
        print('ECHEC: des especes promues deviendraient invisibles:')
        for d in dead:
            print('  -', d)
        return 1

    pat = re.compile(r'E\.DENSITY = \{.*?\n\}\n', re.S)
    changed = 0
    for t in TARGETS:
        if not t.exists():
            continue
        s = t.read_text(encoding='utf-8')
        if not pat.search(s):
            print('ECHEC: bloc E.DENSITY introuvable dans', t)
            return 1
        new = pat.sub(block, s, count=1)
        if new == s:
            continue
        if ns.apply:
            t.write_text(new, encoding='utf-8')
            try:
                from luaparser import ast
                ast.parse(new)
            except ImportError:
                pass
            except Exception as e:
                print('ECHEC: %s ne parse plus (%s)' % (t.name, str(e)[:80]))
                return 1
        changed += 1
        print('%s %s' % ('mis a jour' if ns.apply else 'a mettre a jour', t))

    print('%d especes dans le bloc, %d fichier(s) %s'
          % (n, changed, 'ecrits' if ns.apply else 'a ecrire'))
    if not ns.apply:
        print('DRY-RUN (relancer avec --apply)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
