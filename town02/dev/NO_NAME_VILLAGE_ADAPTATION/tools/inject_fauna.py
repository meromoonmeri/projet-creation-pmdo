#!/usr/bin/env python3
"""Injecte la faune dans les Grounds reconvertis. Fail-closed, verifiable.

REGLES ABSOLUES (echec immediat si violees) :
  - seules les rooms PROVEN (rendu + collision) sont touchees ;
  - les especes HELD (Cradily, Sandshrew) ne sont jamais ecrites ;
  - une entite n'est ecrite que si sa cellule est praticable pour son profil :
    jamais arbre, rocher, mur, falaise, cellule bloquee ; aquatique dans l'eau ;
  - la position finale est reverifiee contre la grille de collision du Ground
    lui-meme (8 px), pas seulement contre l'atlas ;
  - seules les saisons dont la variante de Ground existe recoivent des entites.

Chaque entite porte ses ScriptVars (espece, profil, colonie, saison, heure)
pour que NNVEcology la prenne en charge : aucun sprite pose sans comportement.

Sans --apply : dry-run. Avec --apply : ecrit dans --reconv (hors depot),
sauvegarde chaque Ground en .pre-fauna.bak et consigne les sha256.
"""
from __future__ import annotations
import argparse, copy, gzip, hashlib, json, os, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

CELL = 64
COLL = 8
FORBIDDEN = {0, 5, 6, 7}          # blocked, tree, rock, cliff
T_WATER = 3
SEASONS = ('spring', 'summer', 'autumn', 'winter')

PROTOTYPE = {
    '<AI>k__BackingField': None,
    'AIEnabled': True,
    'CollisionDisabled': False,
    'Direction': 0,
    'EntEnabled': True,
    'EntOrder': 0,
    'InteractOrder': 0,
    'IsInteracting': False,
    'serializationDir': 0,
    'serializationHeight': 0,
    'triggerType': 1,
}


def char_data(species, nickname, level, script_vars):
    return {
        'ActionEvents': [], 'AtkBonus': 0,
        'BaseForm': {'Form': 0, 'Gender': 0, 'Skin': 'normal', 'Species': species},
        'BaseIntrinsics': ['none'],
        'BaseSkills': [{'CanForget': True, 'Charges': 0, 'SkillNum': ''} for _ in range(4)],
        'DefBonus': 0, 'DefeatAt': '',
        'DefeatLoc': {'EntryPoint': -1, 'ID': '', 'StructID': {'ID': -1, 'Segment': -1}},
        'Discriminator': 0, 'EXP': 0, 'FormIntrinsicSlot': -1,
        'IsFavorite': False, 'IsFounder': False, 'IsPartner': False,
        'Level': level, 'MAtkBonus': 0, 'MDefBonus': 0, 'MaxHPBonus': 0,
        'MetAt': '', 'MetLoc': {'EntryPoint': -1, 'ID': '', 'StructID': {'ID': -1, 'Segment': -1}},
        'NameLocked': False, 'Nickname': nickname, 'OriginalTeam': '',
        'OriginalUUID': '', 'Relearnables': {}, 'ScriptVars': script_vars,
        'SpeedBonus': 0, 'Unrecruitable': True,
    }


def collision_blocked(obstacles, px, py):
    """La cellule de collision de 8 px contenant (px,py) est-elle bloquee ?"""
    cx, cy = px // COLL, py // COLL
    if not (0 <= cx < len(obstacles) and 0 <= cy < len(obstacles[0])):
        return True
    return bool(obstacles[cx][cy].get('Tags', 0))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--backup', default='/tmp/fauna-backup/grounds')
    ns = ap.parse_args()

    ev = json.load(open(ECO / 'evidence-classification.json'))
    place = json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms']
    atlas = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
    spec = json.load(open(NNV / 'config/fauna-species.json'))
    species, profiles = spec['species'], spec['behaviour_profiles']

    proven = set(ev['rooms_by_evidence']['PROVEN'])
    held = set(ev['held_species'])

    report = {'schema': 'nnv-fauna-injection-v1',
              'mode': 'APPLY' if ns.apply else 'DRY-RUN',
              'held_species': sorted(held), 'rooms': {}, 'refusals': []}
    total = 0
    os.makedirs(ns.backup, exist_ok=True) if ns.apply else None

    for room in sorted(proven):
        rd = place.get(room)
        if not rd or not rd['colonies']:
            continue
        terr = atlas[room]['terrain']

        for season in SEASONS:
            gp = Path(ns.reconv) / room / 'Data/Ground' / f'nnv_{room}_{season}.rsground'
            if not gp.exists():
                continue

            ground = json.load(open(gp, encoding='utf-8-sig'))
            obj = ground['Object']
            obstacles = obj['obstacles']
            layers = obj.get('Entities') or []
            if not layers:
                report['refusals'].append('%s/%s: aucune couche d entites' % (room, season))
                continue
            mapchars = layers[0].setdefault('MapChars', [])

            existing = {c.get('EntName') for c in mapchars}
            added = 0
            for ci, col in enumerate(rd['colonies']):
                sname = col['species']
                if sname in held:
                    continue
                cs = col.get('seasons') or list(SEASONS)
                if season not in cs:
                    continue
                sp = species[sname]
                prof = profiles[sp['profile']]
                req = prof.get('requires')

                for mi, m in enumerate(col['members']):
                    x, y = m['cell']
                    t = terr[y][x]
                    # garde 1 : terrain
                    if req == 'water':
                        if t != T_WATER:
                            report['refusals'].append(
                                '%s/%s %s aquatique hors eau (%d,%d)' % (room, season, sname, x, y))
                            continue
                    elif t in FORBIDDEN:
                        report['refusals'].append(
                            '%s/%s %s sur terrain interdit %d (%d,%d)' % (room, season, sname, t, x, y))
                        continue
                    px, py = m['px']
                    # garde 2 : collision reelle du Ground (sauf volants/aquatiques)
                    if prof.get('grounded', True) and req != 'water':
                        if collision_blocked(obstacles, px, py):
                            report['refusals'].append(
                                '%s/%s %s sur collision (%d,%d)' % (room, season, sname, px, py))
                            continue
                    name = 'NNV_Wild_%s_%s_%d_%d' % (room, sname.capitalize(), ci, mi)
                    if name in existing:
                        continue
                    e = copy.deepcopy(PROTOTYPE)
                    e['EntName'] = name
                    e['Collider'] = {'X': px, 'Y': py, 'Width': 16, 'Height': 16}
                    e['serializationLoc'] = {'X': px, 'Y': py}
                    e['CollisionDisabled'] = not prof.get('grounded', True)
                    e['Data'] = char_data(sname, sname.capitalize(), sp['level'], {
                        'nnv_kind': 'wild',
                        'nnv_species': sname,
                        'nnv_profile': sp['profile'],
                        'nnv_colony': ci,
                        'nnv_member': mi,
                        'nnv_season': ','.join(cs),
                        'nnv_time': sp.get('time', 'any'),
                        'nnv_social': sp.get('social'),
                        'nnv_owner': 'NNVEcology',
                    })
                    mapchars.append(e)
                    existing.add(name)
                    added += 1

            if not added:
                continue
            total += added
            key = '%s/%s' % (room, season)
            report['rooms'][key] = {'entities_added': added,
                                    'file': str(gp),
                                    'sha256_before': None, 'sha256_after': None}

            if ns.apply:
                raw_before = gp.read_bytes()
                report['rooms'][key]['sha256_before'] = hashlib.sha256(raw_before).hexdigest()
                bak = Path(ns.backup) / ('%s_%s.rsground.pre-fauna.bak' % (room, season))
                if not bak.exists():
                    shutil.copy2(gp, bak)
                tmp = gp.with_suffix('.tmp')
                with open(tmp, 'w', encoding='utf-8-sig') as fh:
                    json.dump(ground, fh, ensure_ascii=False)
                os.replace(tmp, gp)
                report['rooms'][key]['sha256_after'] = hashlib.sha256(gp.read_bytes()).hexdigest()
            print('%-22s +%-4d entites%s' % (key, added, '' if ns.apply else '  (dry-run)'))

    report['totals'] = {'entities': total, 'rooms_touched': len(report['rooms']),
                        'refusals': len(report['refusals'])}
    out = ECO / ('injection-report.json' if ns.apply else 'injection-dryrun.json')
    open(out, 'w').write(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print('\ntotal entites : %d | fichiers : %d | refus : %d'
          % (total, len(report['rooms']), len(report['refusals'])))
    for r in report['refusals'][:10]:
        print('  refus:', r)
    print('ecrit', out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
