#!/usr/bin/env python3
"""Validation POST-CÂBLAGE, relue depuis les init.lua écrits.

Vérifie sur les fichiers réels :
  1. les 34 init.lua parsent (luaparser) ;
  2. exactement 1 Load() et 1 Update() par fichier (aucun double chargement) ;
  3. les requires sont présents et NNVEcology.lua/NNVDuel.lua existent ;
  4. l'asset passé à Load() correspond au Ground du dossier ;
  5. aucune fonction M.X d'origine perdue ni dupliquée (vs backup) ;
  6. tous les appels moteur d'origine préservés (comportement narratif intact) ;
  7. les appels faune sont sous pcall (un Ground ne peut pas casser) ;
  8. Load() est dans Enter, Update() dans Update -- jamais dans Init ;
  9. cohérence roster : les entités du Ground que Discover() va voir ;
 10. aucune espèce HELD, aucun profil végétatif, propriétaire unique ;
 11. aucun init.lua de room NO_PROOF câblé.
"""
from __future__ import annotations
import argparse, glob, json, os, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

failures, checks = [], 0


def check(c, m):
    global checks
    checks += 1
    if not c:
        failures.append(m)
    return c


def body_of(src, func):
    m = re.search(r'function\s+M\.%s\s*\([^)]*\)(.*?)\nend\b' % re.escape(func),
                  src, re.S)
    return m.group(1) if m else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--backup', default='/tmp/fauna-backup/initlua')
    ns = ap.parse_args()

    try:
        from luaparser import ast as lua_ast
    except ImportError:
        print('ECHEC: luaparser indisponible'); return 1

    ev = json.load(open(ECO / 'evidence-classification.json'))
    noproof = set(ev['rooms_by_evidence']['NO_PROOF'])
    held = set(ev['held_species'])
    spec = json.load(open(NNV / 'config/fauna-species.json'))
    profiles = spec['behaviour_profiles']
    wiring = json.load(open(ECO / 'ecology-wiring.json'))

    check((ROOT / 'Data/Script/halcyon/NNVEcology.lua').exists(),
          'NNVEcology.lua absent de Data/Script/halcyon')
    check((ROOT / 'Data/Script/halcyon/NNVDuel.lua').exists(),
          'NNVDuel.lua absent de Data/Script/halcyon')

    total = 0
    for w in wiring['wired']:
        room, season = w['key'].split('/')
        asset = w['asset']
        ip = Path(ns.reconv) / room / 'Data/Script/halcyon/ground' / asset / 'init.lua'
        if not check(ip.exists(), '%s: init.lua absent' % w['key']):
            continue
        src = ip.read_text(encoding='utf-8')

        check(room not in noproof, '%s: room NO_PROOF cablee' % w['key'])

        try:
            lua_ast.parse(src)
            check(True, '')
        except Exception as e:
            failures.append('%s: init.lua ne parse plus (%s)' % (w['key'], str(e)[:80]))
            continue

        # 2. un seul appel de chaque
        check(src.count('NNVEcology.Load(') == 1,
              '%s: %d appels Load (double chargement)'
              % (w['key'], src.count('NNVEcology.Load(')))
        check(src.count('NNVEcology.Update()') == 1,
              '%s: %d appels Update' % (w['key'], src.count('NNVEcology.Update()')))
        check(src.count('NNVEcology.Setup()') == 1,
              '%s: Setup absent ou duplique' % w['key'])

        # 3. requires
        check("require 'halcyon.NNVEcology'" in src,
              '%s: require NNVEcology manquant' % w['key'])
        check("require 'halcyon.NNVDuel'" in src,
              '%s: require NNVDuel manquant' % w['key'])

        # 4. bon asset
        m = re.search(r"NNVEcology\.Load\('([^']+)'\)", src)
        check(m is not None and m.group(1) == asset,
              '%s: Load appelle %s au lieu de %s'
              % (w['key'], m.group(1) if m else None, asset))

        # 7/8. placement dans le cycle de vie + pcall
        enter = body_of(src, 'Enter')
        update = body_of(src, 'Update')
        init = body_of(src, 'Init')
        check(enter is not None and 'NNVEcology.Load(' in enter,
              '%s: Load n est pas dans Enter' % w['key'])
        check(update is not None and 'NNVEcology.Update()' in update,
              '%s: Update n est pas dans M.Update' % w['key'])
        check(init is None or 'NNVEcology' not in init,
              '%s: appel faune dans Init (trop tot)' % w['key'])
        for frag in ('NNVEcology.Load(', 'NNVEcology.Update()'):
            idx = src.find(frag)
            check(idx > 0 and 'pcall' in src[max(0, idx - 200):idx],
                  '%s: %s hors pcall' % (w['key'], frag))

        # 5/6. non-regression vs backup
        bak = Path(w['backup'])
        if bak.exists():
            old = bak.read_text(encoding='utf-8')
            fb = re.findall(r'function\s+M\.(\w+)\s*\(', old)
            fa = re.findall(r'function\s+M\.(\w+)\s*\(', src)
            for f in fb:
                check(f in fa, '%s: fonction M.%s perdue' % (w['key'], f))
            for f in set(fa):
                check(fa.count(f) <= max(1, fb.count(f)),
                      '%s: fonction M.%s dupliquee' % (w['key'], f))
            for c in set(re.findall(r'\b([A-Z][\w]*(?::|\.)[\w]+)\s*\(', old)):
                check(c in src, '%s: appel %s perdu' % (w['key'], c))

        # 9/10. roster que Discover() verra
        gp = Path(ns.reconv) / room / 'Data/Ground' / ('%s.rsground' % asset)
        if check(gp.exists(), '%s: Ground absent' % w['key']):
            g = json.load(open(gp, encoding='utf-8-sig'))['Object']
            chars = (g.get('Entities') or [{}])[0].get('MapChars') or []
            wild = [c for c in chars
                    if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == 'wild']
            check(len(wild) == w['entities'],
                  '%s: %d entites, %d attendues' % (w['key'], len(wild), w['entities']))
            total += len(wild)
            colonies = {}
            for c in wild:
                sv = c['Data']['ScriptVars']
                check(sv.get('nnv_owner') == 'NNVEcology',
                      '%s: entite non possedee par NNVEcology' % w['key'])
                check(sv.get('nnv_species') not in held,
                      '%s: espece HELD presente' % w['key'])
                pr = sv.get('nnv_profile')
                check(pr in profiles, '%s: profil inconnu %s' % (w['key'], pr))
                if pr in profiles and pr != 'sessile':
                    p = profiles[pr]
                    check(p.get('speed', 0) > 0 and p.get('pause_ratio', 1) < 1.0,
                          '%s: profil vegetatif %s' % (w['key'], pr))
                colonies.setdefault(sv.get('nnv_colony'), []).append(sv)
            # Discover regroupe par nnv_colony : une colonie = une espece
            for ci, members in colonies.items():
                sp = {m.get('nnv_species') for m in members}
                check(len(sp) == 1,
                      '%s: colonie %s melange %s' % (w['key'], ci, sp))

    check(total == 1642, 'total %d entites au lieu de 1642' % total)
    check(len(wiring['wired']) == 34,
          '%d Grounds cables au lieu de 34' % len(wiring['wired']))

    # aucun init.lua de room NO_PROOF ne doit etre cable
    for room in sorted(noproof):
        for ip in glob.glob(str(Path(ns.reconv) / room /
                                'Data/Script/halcyon/ground/*/init.lua')):
            s = open(ip, encoding='utf-8').read()
            check('NNVEcology' not in s,
                  'room NO_PROOF %s cablee (%s)' % (room, os.path.basename(ip)))

    print('Grounds cables : %d' % len(wiring['wired']))
    print('entites couvertes : %d' % total)
    print('controles : %d' % checks)
    if failures:
        print('ECHECS : %d' % len(failures))
        for f in failures[:25]:
            print('  -', f)
        return 1
    print('TOUT EST VERIFIE')
    return 0


if __name__ == '__main__':
    sys.exit(main())
