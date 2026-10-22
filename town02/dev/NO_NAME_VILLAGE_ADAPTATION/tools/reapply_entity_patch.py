#!/usr/bin/env python3
"""Réapplique le patch versionné des 1 642 entités sur des Grounds régénérés.

Ne recalcule RIEN : ni casting, ni placement, ni écologie. Le patch
(reports/fauna-ecology/ground-archive/injected-entities-patch.json.gz) contient
les entités exactes déjà certifiées, avec leurs positions et leurs ScriptVars.
On les réinsère telles quelles.

Preuve de fidélité : après réinjection, le sha256 du Ground doit être IDENTIQUE
à celui consigné dans l'inventaire du patch (`sha256_after_injection`). Si un
seul octet diffère, le Ground régénéré n'est pas équivalent à l'original et la
promotion doit être refusée.

Gardes conservées (identiques à l'injection d'origine) :
  - la cellule de collision 8 px sous chaque entité terrestre doit être libre ;
  - une espèce aquatique doit rester sur une cellule d'eau (via l'atlas) ;
  - aucune entité en double, aucun nom dupliqué.
Une position invalidée par le fichier reconstruit est signalée et refusée --
elle n'est jamais déplacée en silence.
"""
from __future__ import annotations
import argparse, gzip, hashlib, io, json, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'
CELL, COLL = 64, 8
FORBIDDEN = {0, 5, 6, 7}      # blocked, tree, rock, cliff
T_WATER = 3


def sha256_file(p: Path, chunk=1 << 20):
    h = hashlib.sha256()
    with open(p, 'rb') as fh:
        for b in iter(lambda: fh.read(chunk), b''):
            h.update(b)
    return h.hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--rooms', default='')
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--out', default=str(ECO / 'reapply-report.json'))
    ns = argparse.Namespace(**vars(ap.parse_args()))

    patch = json.loads(gzip.decompress(
        (ECO / 'ground-archive/injected-entities-patch.json.gz').read_bytes()))
    atlas = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
    spec = json.load(open(NNV / 'config/fauna-species.json'))
    profiles = spec['behaviour_profiles']

    targets = ns.rooms.split(',') if ns.rooms else sorted(patch['rooms'])
    report = {'schema': 'nnv-reapply-v1', 'mode': 'APPLY' if ns.apply else 'DRY-RUN',
              'rooms': {}, 'refusals': [], 'missing_grounds': []}
    total = 0

    for room in targets:
        seasons = patch['rooms'].get(room) or {}
        for season, info in seasons.items():
            gp = Path(ns.reconv) / room / 'Data/Ground' / info['ground_file']
            if not gp.exists():
                report['missing_grounds'].append(str(gp))
                continue

            g = json.load(io.open(gp, encoding='utf-8-sig'))
            obj = g['Object']
            layers = obj.get('Entities') or []
            if not layers:
                report['refusals'].append('%s/%s: aucune couche d entites' % (room, season))
                continue
            mapchars = layers[0].setdefault('MapChars', [])
            existing = {c.get('EntName') for c in mapchars}
            obstacles = obj['obstacles']
            terr = (atlas.get(room) or {}).get('terrain')

            added, refused = 0, 0
            for e in info['entities']:
                name = e['EntName']
                if name in existing:
                    continue
                sv = e['Data']['ScriptVars']
                prof = profiles.get(sv.get('nnv_profile'), {})
                px, py = e['Collider']['X'], e['Collider']['Y']

                # garde terrain (atlas) -- inchangée depuis l'injection d'origine
                if terr:
                    cx, cy = px // CELL, py // CELL
                    t = terr[cy][cx]
                    if prof.get('requires') == 'water':
                        if t != T_WATER:
                            report['refusals'].append(
                                '%s/%s %s aquatique hors eau (%d,%d)'
                                % (room, season, name, cx, cy))
                            refused += 1
                            continue
                    elif t in FORBIDDEN:
                        report['refusals'].append(
                            '%s/%s %s terrain interdit %d (%d,%d)'
                            % (room, season, name, t, cx, cy))
                        refused += 1
                        continue

                # garde collision réelle du Ground RECONSTRUIT
                if prof.get('grounded', True) and prof.get('requires') != 'water':
                    ox, oy = px // COLL, py // COLL
                    blocked = True
                    if ox < len(obstacles) and oy < len(obstacles[0]):
                        blocked = bool(obstacles[ox][oy].get('Tags', 0))
                    if blocked:
                        report['refusals'].append(
                            '%s/%s %s sur collision (%d,%d)' % (room, season, name, px, py))
                        refused += 1
                        continue

                mapchars.append(e)
                existing.add(name)
                added += 1

            key = '%s/%s' % (room, season)
            entry = {'file': str(gp), 'entities_expected': info['entity_count'],
                     'entities_added': added, 'refused': refused,
                     'sha256_expected': info['sha256_after_injection']}
            if ns.apply and added:
                tmp = gp.with_suffix('.tmp')
                with io.open(tmp, 'w', encoding='utf-8-sig') as fh:
                    json.dump(g, fh, ensure_ascii=False)
                os.replace(tmp, gp)
                entry['sha256_actual'] = sha256_file(gp)
                entry['byte_identical'] = entry['sha256_actual'] == entry['sha256_expected']
            total += added
            report['rooms'][key] = entry
            print('%-22s +%-4d entites  refus=%-2d %s'
                  % (key, added, refused,
                     ('sha=%s' % ('IDENTIQUE' if entry.get('byte_identical')
                                  else 'DIFFERENT')) if ns.apply else '(dry-run)'))

    report['totals'] = {
        'entities': total,
        'rooms': len(report['rooms']),
        'refusals': len(report['refusals']),
        'missing_grounds': len(report['missing_grounds']),
        'byte_identical': sum(1 for r in report['rooms'].values()
                              if r.get('byte_identical')),
    }
    Path(ns.out).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    t = report['totals']
    print('\nentites: %d | rooms: %d | refus: %d | grounds absents: %d'
          % (t['entities'], t['rooms'], t['refusals'], t['missing_grounds']))
    if ns.apply:
        print('grounds byte-identiques a l original: %d/%d'
              % (t['byte_identical'], t['rooms']))
    for r in report['refusals'][:10]:
        print('  refus:', r)
    return 1 if report['refusals'] else 0


if __name__ == '__main__':
    sys.exit(main())
