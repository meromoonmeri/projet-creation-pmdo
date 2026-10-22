#!/usr/bin/env python3
"""Construit Data/Zone/nnv_wild.json et son entrée dans Data/Zone/index.idx.

FORMAT DE Data/Zone/index.idx — audit (ne pas confondre avec Content/Tile)
---------------------------------------------------------------------------
Contrairement à Content/Tile/index.idx qui est BINAIRE, Data/Zone/index.idx est
du JSON UTF-8-BOM :

    { "Version": "0.8.9.0",
      "Object": { "$type": "System.Collections.Generic.Dictionary`2[...]",
                  "<zone_id>": { ZoneEntrySummary }, ... } }

ZoneEntrySummary est généré par le moteur dans ZoneData.GenerateEntrySummary()
(Data/ZoneData.cs l.132). Règles vérifiées dans le code :

  - CountedFloors = somme des FloorCount des segments dont IsRelevant == true.
    Un segment IsRelevant=false ne compte PAS. (l.135-139)
  - Grounds = la liste GroundMaps de la zone. (l.154)
  - Maps = un élément PAR SEGMENT, contenant les IDs d'étages ; null si
    FloorCount < 0. (l.155-163)

Donc pour une zone de duels sauvages entièrement composée de segments
IsRelevant=false : CountedFloors = 0, et Maps a un [0] par segment.

Invariant vérifié sur le dépôt : 57 zones indexées, 57 fichiers .json,
aucun orphelin dans un sens ni dans l'autre. On le préserve.

CHAQUE SEGMENT = UN LIEU
---------------------------------------------------------------------------
Un segment par .rsmap de duel, avec un LoadGen + MappedRoomStep pointant la
carte — exactement le patron de gloomy_forest segment 5 (duel Team Dazzling)
et de metano_raid_1/2/3, déjà éprouvés dans ce dépôt.

Sans --apply : dry-run.
"""
from __future__ import annotations
import argparse, glob, hashlib, io, json, os, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'
ZONE_DIR = ROOT / 'Data/Zone'
ZONE_ID = 'nnv_wild'


def sha256(p: Path):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def load_json_bom(p: Path):
    return json.load(io.open(p, encoding='utf-8-sig'))


def dump_json_bom(p: Path, data, indent=2):
    with io.open(p, 'w', encoding='utf-8-sig') as fh:
        json.dump(data, fh, ensure_ascii=False, indent=indent)
        fh.write('\n')


def build_zone(maps):
    """Une zone, un segment par carte de duel, tous IsRelevant=false."""
    segments = []
    for m in maps:
        segments.append({
            '$type': 'RogueEssence.LevelGen.LayeredSegment, RogueEssence',
            'Floors': [{
                '$type': 'RogueEssence.LevelGen.LoadGen, RogueEssence',
                'GenSteps': [{
                    'Key': {'str': [-1]},
                    'Value': {
                        '$type': 'RogueEssence.LevelGen.MappedRoomStep`1'
                                 '[[RogueEssence.LevelGen.MapLoadContext, '
                                 'RogueEssence]], RogueEssence',
                        'MapID': m['map_id'],
                    },
                }],
                'Comment': '',
            }],
            'ZoneSteps': [
                {'$type': 'PMDC.LevelGen.SaveVarsZoneStep, PMDC',
                 'Priority': {'str': [1, 1]}},
                {'$type': 'PMDC.LevelGen.FloorNameDropZoneStep, PMDC',
                 'DropPriority': {'str': [-15]},
                 'Name': {'DefaultText': 'Wild Clash',
                          'LocalTexts': {'fr': 'Affrontement sauvage'}},
                 'Priority': {'str': [-6]}},
            ],
            'IsRelevant': False,
            'Comment': 'Duel sauvage dans %s (%s) - fenetre pixel-perfect du '
                       'Ground, hors progression.' % (m['room'], m['season']),
        })

    return {'Version': '0.8.9.0', 'Object': {
        '$type': 'RogueEssence.Data.ZoneData, RogueEssence',
        'Name': {'DefaultText': 'Wild Encounters',
                 'LocalTexts': {'fr': 'Rencontres sauvages'}},
        'Released': True,
        'Comment': 'Zone hote des duels entre Pokemon sauvages des zones NNV. '
                   'Tous les segments sont IsRelevant=false : aucun ne compte '
                   'dans la progression, aucun drapeau d histoire.',
        'NoEXP': False, 'ExpPercent': 100, 'Level': -1, 'LevelCap': False,
        'KeepSkills': False, 'TeamRestrict': False, 'TeamSize': -1,
        'MoneyRestrict': False, 'BagRestrict': -1, 'KeepTreasure': False,
        'BagSize': -1, 'Persistent': False, 'Rescues': 0, 'Rogue': 0,
        'Segments': segments,
        'GroundMaps': [],
    }}


def build_summary(zone, maps):
    """Reproduit fidelement ZoneData.GenerateEntrySummary()."""
    o = zone['Object']
    counted = sum(len(s['Floors']) for s in o['Segments'] if s['IsRelevant'])
    return {
        '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
        'ExpPercent': o['ExpPercent'], 'Level': o['Level'],
        'LevelCap': o['LevelCap'], 'KeepSkills': o['KeepSkills'],
        'TeamRestrict': o['TeamRestrict'], 'TeamSize': o['TeamSize'],
        'MoneyRestrict': o['MoneyRestrict'], 'BagRestrict': o['BagRestrict'],
        'KeepTreasure': o['KeepTreasure'], 'BagSize': o['BagSize'],
        'Rescues': o['Rescues'],
        'CountedFloors': counted,          # 0 : tous les segments sont non pertinents
        'Rogue': o['Rogue'],
        'Grounds': list(o['GroundMaps']),
        'Maps': [[0] for _ in o['Segments']],
        'Name': o['Name'], 'Released': o['Released'],
        'Comment': o['Comment'], 'SortOrder': 0,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    ap.add_argument('--backup', default='/tmp/fauna-backup/zone')
    ns = ap.parse_args()

    # 1. cartes de duel reellement installees
    maps = []
    for p in sorted(glob.glob(str(ROOT / 'Data/Map/nnv_duel_*.rsmap'))):
        stem = Path(p).stem
        parts = stem.split('_')
        maps.append({'map_id': stem, 'room': parts[2], 'season': parts[3],
                     'file': p})
    if not maps:
        print('ECHEC: aucune carte de duel installee'); return 1
    print('cartes de duel installees: %d' % len(maps))

    # 2. exiger la preuve pixel-perfect pour chacune
    proofdir = ECO / 'installed-proofs'
    for m in maps:
        pr = proofdir / (m['map_id'] + '_proof.json')
        if not pr.exists():
            print('ECHEC: preuve absente pour', m['map_id']); return 1
        d = json.load(open(pr))
        if not d.get('pixel_identical') or d.get('differing_pixels'):
            print('ECHEC: %s non pixel-perfect' % m['map_id']); return 1
    print('preuves pixel-perfect: %d/%d' % (len(maps), len(maps)))

    zone = build_zone(maps)
    summary = build_summary(zone, maps)

    idx_path = ZONE_DIR / 'index.idx'
    idx = load_json_bom(idx_path)
    zones = [k for k in idx['Object'] if k != '$type']
    print('index: %d zones avant' % len(zones))
    if ZONE_ID in idx['Object']:
        print('ECHEC: %s deja indexee' % ZONE_ID); return 1

    # 3. invariant : autant de fichiers que d'entrees
    files = {f[:-5] for f in os.listdir(ZONE_DIR) if f.endswith('.json')}
    if set(zones) != files:
        print('ECHEC: index et fichiers desynchronises AVANT modification')
        print('  index sans fichier:', sorted(set(zones) - files))
        print('  fichier sans index:', sorted(files - set(zones)))
        return 1
    print('invariant verifie: %d fichiers == %d entrees' % (len(files), len(zones)))

    print('\nplan:')
    print('  CREATE Data/Zone/%s.json  (%d segments, tous IsRelevant=false)'
          % (ZONE_ID, len(zone['Object']['Segments'])))
    print('  MODIFY Data/Zone/index.idx  (+1 entree, CountedFloors=%d)'
          % summary['CountedFloors'])
    for m in maps:
        print('    segment %d -> %s' % (maps.index(m), m['map_id']))

    if not ns.apply:
        print('\nDRY-RUN : rien n a ete ecrit (relancer avec --apply)')
        return 0

    # 4. sauvegarde avant ecriture
    os.makedirs(ns.backup, exist_ok=True)
    bak = Path(ns.backup) / 'zone-index.idx.pre-duel.bak'
    if not bak.exists():
        shutil.copy2(idx_path, bak)
    if sha256(bak) != sha256(idx_path):
        print('ECHEC: sauvegarde non conforme'); return 1
    print('\nsauvegarde: %s (sha %s)' % (bak, sha256(bak)[:12]))

    zone_path = ZONE_DIR / ('%s.json' % ZONE_ID)
    dump_json_bom(zone_path, zone)
    idx['Object'][ZONE_ID] = summary
    dump_json_bom(idx_path, idx)

    # 5. relecture
    z2 = load_json_bom(zone_path)
    i2 = load_json_bom(idx_path)
    if ZONE_ID not in i2['Object']:
        print('ECHEC: entree absente apres ecriture'); return 1
    if len(z2['Object']['Segments']) != len(maps):
        print('ECHEC: segments incoherents'); return 1
    zones2 = {k for k in i2['Object'] if k != '$type'}
    files2 = {f[:-5] for f in os.listdir(ZONE_DIR) if f.endswith('.json')}
    if zones2 != files2:
        print('ECHEC: invariant rompu apres ecriture'); return 1
    # les 57 entrees preexistantes doivent etre inchangees
    for k in zones:
        if json.dumps(i2['Object'][k], sort_keys=True) != \
           json.dumps(idx['Object'][k], sort_keys=True):
            print('ECHEC: zone existante alteree:', k); return 1
    print('relecture OK: %d zones, invariant preserve, %d entrees intactes'
          % (len(zones2), len(zones)))

    report = {'schema': 'nnv-wild-zone-install-v1', 'zone': ZONE_ID,
              'segments': [{'index': i, 'map_id': m['map_id'],
                            'room': m['room'], 'season': m['season']}
                           for i, m in enumerate(maps)],
              'counted_floors': summary['CountedFloors'],
              'zone_sha256': sha256(zone_path),
              'index_sha256': sha256(idx_path),
              'index_backup': str(bak)}
    (ECO / 'wild-zone-install.json').write_text(
        json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print('rapport ecrit')
    return 0


if __name__ == '__main__':
    sys.exit(main())
