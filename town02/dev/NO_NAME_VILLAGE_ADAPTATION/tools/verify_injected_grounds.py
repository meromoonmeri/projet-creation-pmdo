#!/usr/bin/env python3
"""Validations POST-INJECTION, relues depuis les Grounds ecrits.

Ne fait confiance a aucun rapport : rouvre chaque .rsground injecte et verifie
sur le fichier reel :

  1. le Ground charge et reste structurellement valide (JSON, obstacles,
     Layers, Entities) ;
  2. AUCUNE regression de collision : la grille est identique au backup ;
  3. AUCUNE regression de rendu : les Layers de tuiles sont inchangees ;
  4. chaque entite injectee est sur une cellule praticable pour son profil ;
  5. aucune espece exclue / legendaire / doublon Metano-Guilde ;
  6. aucune espece HELD ;
  7. aucune room NO_PROOF touchee ;
  8. aucun individu sans ScriptVars de comportement (anti-vegetatif) ;
  9. aucune entite dupliquee, aucune collision de nom ;
 10. proprietaire unique : nnv_owner == NNVEcology.
"""
from __future__ import annotations
import argparse, glob, gzip, json, os, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'
CELL, COLL = 64, 8
FORBIDDEN = {0, 5, 6, 7}
T_WATER = 3

failures = []
checks = 0


def check(cond, msg):
    global checks
    checks += 1
    if not cond:
        failures.append(msg)
    return cond


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--backup', default='/tmp/fauna-backup/grounds')
    ns = ap.parse_args()

    ev = json.load(open(ECO / 'evidence-classification.json'))
    atlas = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
    spec = json.load(open(NNV / 'config/fauna-species.json'))
    species, profiles = spec['species'], spec['behaviour_profiles']
    rep = json.load(open(ECO / 'injection-report.json'))

    proven = set(ev['rooms_by_evidence']['PROVEN'])
    noproof = set(ev['rooms_by_evidence']['NO_PROOF'])
    held = set(ev['held_species'])

    # exclusions recalculees depuis le depot
    excl = set()
    for pat in ['Data/Ground/metano*.rsground', 'Data/Ground/guild*.rsground',
                'Data/Ground/sky_wigglytuff*.rsground']:
        for f in glob.glob(str(ROOT / pat)):
            excl |= set(re.findall(r'"Species":\s*"([a-z0-9_]+)"',
                                   open(f, encoding='utf-8-sig', errors='replace').read()))
    excl.discard('')

    total_entities = 0
    for key, info in sorted(rep['rooms'].items()):
        room, season = key.split('/')
        check(room in proven, 'room %s injectee sans preuve' % room)
        check(room not in noproof, 'room NO_PROOF %s injectee' % room)

        gp = Path(info['file'])
        if not check(gp.exists(), '%s: fichier absent' % key):
            continue
        try:
            ground = json.load(open(gp, encoding='utf-8-sig'))
        except Exception as e:
            failures.append('%s: Ground illisible (%s)' % (key, e))
            continue
        obj = ground.get('Object')
        if not check(isinstance(obj, dict), '%s: Object manquant' % key):
            continue
        obstacles = obj.get('obstacles')
        check(isinstance(obstacles, list) and len(obstacles) == 624,
              '%s: grille de collision cassee' % key)
        check(bool(obj.get('Layers')), '%s: aucune couche de rendu' % key)

        # --- non-regression collision + rendu, contre le backup ---
        bak = Path(ns.backup) / ('%s_%s.rsground.pre-fauna.bak' % (room, season))
        if bak.exists():
            before = json.load(open(bak, encoding='utf-8-sig'))['Object']
            check(before['obstacles'] == obstacles,
                  '%s: REGRESSION DE COLLISION' % key)
            check(before['Layers'] == obj['Layers'],
                  '%s: REGRESSION DE RENDU (couches modifiees)' % key)
            check(before.get('TexSize') == obj.get('TexSize'),
                  '%s: TexSize modifie' % key)

        terr = atlas[room]['terrain']
        chars = (obj.get('Entities') or [{}])[0].get('MapChars') or []
        wild = [c for c in chars
                if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == 'wild']
        check(len(wild) == info['entities_added'],
              '%s: %d entites attendues, %d trouvees'
              % (key, info['entities_added'], len(wild)))
        total_entities += len(wild)

        names, cells = set(), set()
        for c in wild:
            sv = c['Data']['ScriptVars']
            sname = sv.get('nnv_species')
            nm = c.get('EntName')
            check(nm not in names, '%s: nom duplique %s' % (key, nm))
            names.add(nm)

            check(sname in species, '%s: espece inconnue %s' % (key, sname))
            check(sname not in held, '%s: espece HELD %s injectee' % (key, sname))
            check(sname not in excl,
                  '%s: %s est un doublon Metano/Guilde' % (key, sname))

            prof_name = sv.get('nnv_profile')
            check(prof_name in profiles, '%s: profil inconnu %s' % (key, prof_name))
            check(sv.get('nnv_owner') == 'NNVEcology',
                  '%s: %s sans proprietaire NNVEcology' % (key, nm))
            # anti-vegetatif : un profil actif doit avoir de quoi bouger
            p = profiles.get(prof_name, {})
            if prof_name != 'sessile':
                check(p.get('speed', 0) > 0 and p.get('pause_ratio', 1) < 1.0,
                      '%s: %s a un profil vegetatif' % (key, nm))

            px, py = c['Collider']['X'], c['Collider']['Y']
            cx, cy = px // CELL, py // CELL
            check((cx, cy) not in cells, '%s: deux entites en (%d,%d)' % (key, cx, cy))
            cells.add((cx, cy))
            t = terr[cy][cx]
            req = p.get('requires')
            if req == 'water':
                check(t == T_WATER,
                      '%s: %s aquatique sur terrain %d' % (key, nm, t))
            else:
                check(t not in FORBIDDEN,
                      '%s: %s sur terrain interdit %d (arbre/mur/rocher)' % (key, nm, t))
                if p.get('grounded', True):
                    ox, oy = px // COLL, py // COLL
                    blocked = bool(obstacles[ox][oy].get('Tags', 0)) \
                        if ox < len(obstacles) and oy < len(obstacles[0]) else True
                    check(not blocked, '%s: %s sur une collision' % (key, nm))

    # aucune room NO_PROOF ne doit avoir de faune
    for room in sorted(noproof):
        for gp in glob.glob(str(Path(ns.reconv) / room / 'Data/Ground/*.rsground')):
            g = json.load(open(gp, encoding='utf-8-sig'))['Object']
            chars = (g.get('Entities') or [{}])[0].get('MapChars') or []
            n = sum(1 for c in chars
                    if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == 'wild')
            check(n == 0, 'room NO_PROOF %s contient %d entites' % (room, n))

    print('entites verifiees dans les Grounds : %d' % total_entities)
    print('controles : %d' % checks)
    if failures:
        print('ECHECS : %d' % len(failures))
        for f in failures[:30]:
            print('  -', f)
        return 1
    print('TOUT EST VERIFIE')
    return 0


if __name__ == '__main__':
    sys.exit(main())
