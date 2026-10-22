#!/usr/bin/env python3
"""Câble NNVEcology dans les init.lua des Grounds injectés.

OÙ L'APPEL DOIT ÊTRE FAIT — analyse du cycle de vie
---------------------------------------------------------------------------
Le moteur appelle, dans l'ordre : Init(map) une fois, Enter(map) à chaque
entrée, puis Update(map) à chaque frame.

  - Init  : trop tôt. Les entités de la carte ne sont pas garanties prêtes,
            et NNVLife a déjà appris que muter le moteur ici est dangereux.
  - Enter : bon endroit pour DÉCLARER le roster (les MapChars sont chargés
            avec la carte), mais pas pour lancer des coroutines.
  - Update: où la vie tourne réellement.

NNVEcology est conçu pour ça : Load() ne fait que lire les entités et remplir
le roster ; Setup() remet les compteurs à zéro sans effet de bord ; toute
mutation moteur est différée au premier Update (initialize_after_entry).

On câble donc :
    Enter  -> NNVEcology.Load(<asset>) puis NNVEcology.Setup()
    Update -> NNVEcology.Update()
    Exit   -> rien (le roster est reconstruit à la prochaine entrée)

ANTI-DOUBLE-CHARGEMENT
---------------------------------------------------------------------------
Load() écrase entièrement E.roster et E.colonies, et remet tick/cursor/ready
à zéro : deux appels successifs ne peuvent pas empiler deux rosters. Le script
refuse malgré tout d'insérer un appel si le fichier en contient déjà un.

SÉCURITÉ
---------------------------------------------------------------------------
  - un Ground sans faune : Discover() renvoie une liste vide, Update() sort
    immédiatement -> aucune erreur ;
  - tous les appels sont enveloppés dans pcall : une erreur de la faune ne
    peut pas casser un Ground ni une cinématique ;
  - le corps existant de Enter/Update est PRÉSERVÉ intégralement : on insère,
    on ne remplace pas ;
  - le fichier est reparsé après modification (luaparser).

Sans --apply : dry-run.
"""
from __future__ import annotations
import argparse, gzip, hashlib, json, os, re, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

MARK = '-- [NNVEcology]'
REQUIRE = "require 'halcyon.NNVEcology'"
REQUIRE_DUEL = "require 'halcyon.NNVDuel'"


def sha256(p: Path):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def insert_after_signature(src: str, func: str, payload: str):
    """Insère payload dans 'function M.<func>(...)', quel que soit son style.

    Deux formes existent dans les init.lua générés :
      (a) multiligne : 'function M.Enter(map)\\n  ...\\nend'
      (b) une ligne  : 'function M.Update(map) end'
    La forme (b) n'a pas de saut de ligne après la signature : un regex qui en
    exige un échoue silencieusement et pousse à créer une SECONDE fonction du
    même nom -- en Lua la dernière écrase la première, donc le corps d'origine
    serait perdu. On traite les deux cas explicitement.
    """
    # (b) corps vide sur une seule ligne
    one = re.compile(r'function\s+M\.%s\s*\(([^)]*)\)\s+end\b' % re.escape(func))
    m = one.search(src)
    if m:
        body = 'function M.%s(%s)\n%send' % (func, m.group(1), payload)
        return src[:m.start()] + body + src[m.end():]
    # (a) corps multiligne
    multi = re.compile(r'(function\s+M\.%s\s*\([^)]*\)\s*\n)' % re.escape(func))
    m = multi.search(src)
    if m:
        return src[:m.end()] + payload + src[m.end():]
    return None


def make_empty_function(func: str, payload: str):
    return 'function M.%s(map)\n%send\n' % (func, payload)


def wire(src: str, asset: str):
    """Retourne (nouveau_source, notes) ou (None, raison)."""
    notes = []
    if MARK in src:
        return None, 'deja cable'

    out = src
    # 1. requires, après le dernier require existant
    reqs = list(re.finditer(r"^require\s+'[^']+'\s*$", out, re.M))
    block = "%s\n%s\n" % (REQUIRE, REQUIRE_DUEL)
    if reqs:
        pos = reqs[-1].end() + 1
        out = out[:pos] + block + out[pos:]
    else:
        out = block + out
    notes.append('requires ajoutes')

    # 2. Enter : charge le roster (les MapChars sont prets)
    enter_payload = (
        '  %s charge la faune de ce Ground ; roster vide si aucune entite.\n'
        '  pcall(function()\n'
        '    NNVEcology.Load(%r)\n'
        '    NNVEcology.Setup()\n'
        '  end)\n' % (MARK, asset))
    new = insert_after_signature(out, 'Enter', enter_payload)
    if new is None:
        out += '\n' + make_empty_function('Enter', enter_payload)
        notes.append('Enter cree')
    else:
        out = new
        notes.append('Enter complete')

    # 3. Update : fait vivre le monde
    update_payload = (
        '  %s fait vivre la faune : deplacements, rencontres, duels.\n'
        '  pcall(function() NNVEcology.Update() end)\n' % MARK)
    new = insert_after_signature(out, 'Update', update_payload)
    if new is None:
        out += '\n' + make_empty_function('Update', update_payload)
        notes.append('Update cree')
    else:
        out = new
        notes.append('Update complete')

    return out, notes


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--backup', default='/tmp/fauna-backup/initlua')
    ap.add_argument('--apply', action='store_true')
    ns = ap.parse_args()

    try:
        from luaparser import ast as lua_ast
    except ImportError:
        print('ECHEC: luaparser indisponible'); return 1

    ev = json.load(open(ECO / 'evidence-classification.json'))
    proven = set(ev['rooms_by_evidence']['PROVEN'])
    noproof = set(ev['rooms_by_evidence']['NO_PROOF'])
    held = set(ev['held_species'])
    inj = json.load(open(ECO / 'injection-report.json'))

    spec = json.load(open(NNV / 'config/fauna-species.json'))
    profiles = spec['behaviour_profiles']

    plan, problems = [], []
    total_entities = 0

    for key, info in sorted(inj['rooms'].items()):
        room, season = key.split('/')
        if room in noproof:
            problems.append('%s: room NO_PROOF dans le rapport d injection' % key)
            continue
        if room not in proven:
            problems.append('%s: room sans preuve' % key)
            continue

        asset = 'nnv_%s_%s' % (room, season)
        ip = Path(ns.reconv) / room / 'Data/Script/halcyon/ground' / asset / 'init.lua'
        gp = Path(info['file'])

        if not ip.exists():
            problems.append('%s: init.lua absent (%s)' % (key, ip))
            continue
        if not gp.exists():
            problems.append('%s: Ground absent' % key)
            continue

        src = ip.read_text(encoding='utf-8')

        # --- gardes de contenu -------------------------------------------
        if MARK in src:
            problems.append('%s: deja cable (double chargement)' % key)
            continue
        # le Ground doit vraiment contenir les entites annoncees
        g = json.load(open(gp, encoding='utf-8-sig'))['Object']
        chars = (g.get('Entities') or [{}])[0].get('MapChars') or []
        wild = [c for c in chars
                if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == 'wild']
        if len(wild) != info['entities_added']:
            problems.append('%s: %d entites dans le Ground, %d attendues'
                            % (key, len(wild), info['entities_added']))
            continue
        # aucune espece HELD, aucun profil vegetatif, proprietaire unique
        for c in wild:
            sv = c['Data']['ScriptVars']
            sp, pr = sv.get('nnv_species'), sv.get('nnv_profile')
            if sp in held:
                problems.append('%s: espece HELD %s presente' % (key, sp))
            if pr not in profiles:
                problems.append('%s: profil inconnu %s' % (key, pr))
            elif pr != 'sessile':
                p = profiles[pr]
                if not (p.get('speed', 0) > 0 and p.get('pause_ratio', 1) < 1.0):
                    problems.append('%s: profil vegetatif %s' % (key, pr))
            if sv.get('nnv_owner') != 'NNVEcology':
                problems.append('%s: entite sans proprietaire NNVEcology' % key)

        new, notes = wire(src, asset)
        if new is None:
            problems.append('%s: %s' % (key, notes))
            continue
        try:
            lua_ast.parse(new)
        except Exception as e:
            problems.append('%s: resultat non parsable (%s)' % (key, str(e)[:90]))
            continue

        # Le comportement existant doit etre preserve. On ne compare pas les
        # lignes brutes : reecrire 'function M.Update(map) end' en une forme
        # multiligne est legitime. On verifie ce qui compte vraiment :
        #   - toute fonction M.X d'origine existe encore, une seule fois ;
        #   - tous les appels moteur d'origine sont encore presents.
        funcs_before = re.findall(r'function\s+M\.(\w+)\s*\(', src)
        funcs_after = re.findall(r'function\s+M\.(\w+)\s*\(', new)
        lost = [f for f in funcs_before if f not in funcs_after]
        if lost:
            problems.append('%s: fonctions perdues: %s' % (key, lost))
            continue
        dupes = [f for f in set(funcs_after)
                 if funcs_after.count(f) > funcs_before.count(f)]
        if dupes:
            problems.append('%s: fonctions dupliquees: %s' % (key, dupes))
            continue
        calls = re.findall(r'\b([A-Z][\w]*(?::|\.)[\w]+)\s*\(', src)
        missing_calls = [c for c in set(calls) if c not in new]
        if missing_calls:
            problems.append('%s: appels perdus: %s' % (key, missing_calls[:3]))
            continue

        total_entities += len(wild)
        plan.append({'key': key, 'init': str(ip), 'asset': asset,
                     'entities': len(wild), 'notes': notes,
                     'new_source': new, 'sha_before': sha256(ip)})

    print('=== plan de cablage ===')
    for p in plan[:8]:
        print('  %-20s %-26s %4d entites  [%s]'
              % (p['key'], p['asset'], p['entities'], ', '.join(p['notes'])))
    if len(plan) > 8:
        print('  ... %d autres' % (len(plan) - 8))
    print('\nfichiers a cabler : %d' % len(plan))
    print('entites couvertes : %d' % total_entities)
    print('rooms NO_PROOF touchees : 0 (exclues par construction)')
    print('especes HELD : %s (jamais cablees)' % ', '.join(sorted(held)))

    if problems:
        print('\nCABLAGE REFUSE : %d probleme(s)' % len(problems))
        for x in problems[:20]:
            print('  -', x)
        return 1

    if total_entities != 1642:
        print('\nECHEC: %d entites couvertes au lieu de 1642' % total_entities)
        return 1
    print('coherence NNVEcology <-> entites injectees : 1642/1642 OK')

    if not ns.apply:
        print('\nDRY-RUN : rien n a ete ecrit (relancer avec --apply)')
        return 0

    os.makedirs(ns.backup, exist_ok=True)
    report = {'schema': 'nnv-ecology-wiring-v1', 'wired': []}
    for p in plan:
        ip = Path(p['init'])
        bak = Path(ns.backup) / ('%s.init.lua.pre-wire.bak' % p['asset'])
        if not bak.exists():
            shutil.copy2(ip, bak)
        ip.write_text(p['new_source'], encoding='utf-8')
        # relecture reelle
        after = ip.read_text(encoding='utf-8')
        lua_ast.parse(after)
        n_load = after.count('NNVEcology.Load(')
        n_upd = after.count('NNVEcology.Update()')
        if n_load != 1 or n_upd != 1:
            print('ECHEC: %s a %d Load et %d Update' % (p['key'], n_load, n_upd))
            return 1
        report['wired'].append({'key': p['key'], 'asset': p['asset'],
                                'entities': p['entities'],
                                'sha_before': p['sha_before'],
                                'sha_after': sha256(ip),
                                'backup': str(bak)})
        print('cable %-20s (%d entites)' % (p['key'], p['entities']))

    report['totals'] = {'files': len(report['wired']),
                        'entities': total_entities}
    (ECO / 'ecology-wiring.json').write_text(
        json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print('\n%d/%d Grounds cables, %d entites' % (len(report['wired']),
                                                  len(plan), total_entities))
    return 0


if __name__ == '__main__':
    sys.exit(main())
