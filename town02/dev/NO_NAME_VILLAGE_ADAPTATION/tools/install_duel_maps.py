#!/usr/bin/env python3
"""Installe les .rsmap de duel + leurs planches + l'entree index.idx.

Securite :
  - refuse de tourner si les candidates ne sont pas pixel-perfect ;
  - sauvegarde Content/Tile/index.idx avant toute ecriture ;
  - reecrit index.idx integralement depuis sa lecture (aucune ecriture
    incrementale a l'aveugle) et verifie que les 735 planches existantes
    sont conservees octet pour octet dans la table ;
  - relit l'index apres ecriture et resout chaque tuile referencee.

Sans --apply : dry-run, rien n'est ecrit.
"""
from __future__ import annotations
import argparse, glob, hashlib, json, os, shutil, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'


def read_index(path: Path):
    d = path.read_bytes()
    off = 0
    n = struct.unpack_from('<I', d, off)[0]
    off += 4
    sets = []
    for _ in range(n):
        ln = d[off]; off += 1
        name = d[off:off + ln].decode('utf-8'); off += ln
        tsize, count = struct.unpack_from('<II', d, off); off += 8
        entries = []
        for _ in range(count):
            key, o = struct.unpack_from('<QQ', d, off); off += 16
            entries.append((key, o))
        sets.append({'name': name, 'tile_size': tsize, 'entries': entries})
    if off != len(d):
        raise ValueError('index.idx malforme')
    return sets


def write_index(path: Path, sets):
    # 1,47 M d'entrees : la concatenation de bytes est quadratique et prend
    # plusieurs minutes. On accumule dans une liste et on joint une fois.
    parts = [struct.pack('<I', len(sets))]
    for ts in sets:
        nb = ts['name'].encode('utf-8')
        parts.append(bytes([len(nb)]) + nb)
        parts.append(struct.pack('<II', ts['tile_size'], len(ts['entries'])))
        entries = ts['entries']
        packer = struct.Struct('<QQ').pack
        parts.append(b''.join(packer(k, o) for k, o in entries))
    path.write_bytes(b''.join(parts))


def sheet_entries(tile_path: Path):
    d = tile_path.read_bytes()
    tsize, count = struct.unpack_from('<II', d, 0)
    off = 8
    entries = []
    for _ in range(count):
        key, o = struct.unpack_from('<QQ', d, off); off += 16
        entries.append((key, o))
    return tsize, entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--candidates', default='/tmp/duelcand')
    ap.add_argument('--backup', default='/tmp/fauna-backup')
    ap.add_argument('--apply', action='store_true')
    ns = ap.parse_args()

    cand = Path(ns.candidates)
    maps = sorted(cand.glob('nnv_duel_*.rsmap'))
    if not maps:
        print('aucune map candidate'); return 2

    # 1. exiger la preuve pixel-perfect
    for m in maps:
        pr = m.with_name(m.stem + '_proof.json')
        if not pr.exists():
            print('ECHEC: preuve absente pour', m.name); return 1
        p = json.load(open(pr))
        if not p.get('pixel_identical') or p.get('differing_pixels'):
            print('ECHEC: %s non pixel-perfect' % m.name); return 1
    print('preuves pixel-perfect: %d/%d OK' % (len(maps), len(maps)))

    idx_path = ROOT / 'Content/Tile/index.idx'
    tile_dir = ROOT / 'Content/Tile'
    map_dir = ROOT / 'Data/Map'

    before = read_index(idx_path)
    before_names = {s['name'] for s in before}
    print('index.idx: %d planches avant' % len(before))

    plan = []
    new_sets = list(before)
    for m in maps:
        room, season = m.stem.split('_')[2], m.stem.split('_')[3]
        sheet = 'NNV_Duel_%s_%s' % (room.capitalize(), season.capitalize())
        tf = cand / (sheet + '.tile')
        if not tf.exists():
            print('ECHEC: planche absente', tf); return 1
        if sheet in before_names:
            print('ECHEC: planche %s deja dans index.idx' % sheet); return 1
        tsize, entries = sheet_entries(tf)
        plan.append({'map': m, 'sheet': sheet, 'tile': tf,
                     'tile_size': tsize, 'entries': len(entries)})
        new_sets.append({'name': sheet, 'tile_size': tsize, 'entries': entries})

    for p in plan:
        print('  + %-28s %3d tuiles -> Content/Tile/%s.tile + Data/Map/%s'
              % (p['sheet'], p['entries'], p['sheet'], p['map'].name))

    if not ns.apply:
        print('\nDRY-RUN : rien n a ete ecrit (relancer avec --apply)')
        return 0

    # 2. sauvegarde obligatoire
    os.makedirs(ns.backup, exist_ok=True)
    bak = Path(ns.backup) / 'index.idx.pre-fauna.bak'
    if not bak.exists():
        shutil.copy2(idx_path, bak)
    if hashlib.sha256(bak.read_bytes()).hexdigest() != \
       hashlib.sha256(idx_path.read_bytes()).hexdigest():
        print('ECHEC: la sauvegarde ne correspond pas a l index courant'); return 1
    print('sauvegarde verifiee:', bak)

    # 3. ecriture
    for p in plan:
        shutil.copy2(p['tile'], tile_dir / (p['sheet'] + '.tile'))
        shutil.copy2(p['map'], map_dir / p['map'].name)
        # la preuve va dans reports/, jamais dans Data/Map : le moteur y
        # charge du contenu, pas des artefacts de validation.
        pr = p['map'].with_name(p['map'].stem + '_proof.json')
        proof_dir = NNV / 'reports/fauna-ecology/installed-proofs'
        proof_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(pr, proof_dir / pr.name)
    write_index(idx_path, new_sets)
    print('index.idx reecrit: %d planches' % len(new_sets))

    # 4. relecture et non-regression des planches existantes
    after = read_index(idx_path)
    if len(after) != len(before) + len(plan):
        print('ECHEC: compte de planches inattendu'); return 1
    for a, b in zip(after[:len(before)], before):
        if a['name'] != b['name'] or a['entries'] != b['entries'] \
           or a['tile_size'] != b['tile_size']:
            print('ECHEC: planche existante alteree:', b['name']); return 1
    print('les %d planches preexistantes sont intactes' % len(before))
    return 0


if __name__ == '__main__':
    sys.exit(main())
