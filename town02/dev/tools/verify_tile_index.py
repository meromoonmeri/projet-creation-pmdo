#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_tile_index.py — coherence planches <-> index.idx <-> cartes.

Controle EXHAUSTIF en un passage :
  1. tout `.tile` sur disque est declare dans Content/Tile/index.idx
     (memes tileSize, memes cles, memes offsets absolus) ;
  2. tout tileset declare dans index.idx a son `.tile` sur disque ;
  3. toute planche referencee par une carte `.rsmap` / `.rsground` existe
     sur disque ET dans index.idx, et ses blobs alloues sont des PNG.

Rappel des formats (cf docs/CONTEXTE_PROJET.md) :
  .tile    : uint32 tileSize, uint32 count,
             count x (uint64 key = x | (y<<32), uint64 offset_absolu),
             a chaque offset : int64 len + octets PNG (dedup par offset).
  index.idx: uint32 nbTilesets, puis par tileset :
             uint8 lenNom, nom UTF-8, uint32 tileSize, uint32 count,
             count x 16 octets (meme table que le .tile).

Sans entree d'index, le moteur ne trouve pas la planche et dessine le
damier mauve/noir de texture manquante (incident du 2026-08-04,
cf docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md).

Usage : python3 tools/verify_tile_index.py [--quiet]
Code de sortie : 0 si tout est coherent, 1 sinon.
"""
import glob
import json
import os
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')
IDX = os.path.join(TILEDIR, 'index.idx')


def read_index(path=IDX):
    with open(path, 'rb') as f:
        raw = f.read()
    n, = struct.unpack_from('<I', raw, 0)
    pos = 4
    out = {}
    for _ in range(n):
        ln, = struct.unpack_from('<B', raw, pos)
        pos += 1
        name = raw[pos:pos + ln].decode('utf-8')
        pos += ln
        tsize, cnt = struct.unpack_from('<II', raw, pos)
        pos += 8
        table = {}
        for i in range(cnt):
            k, off = struct.unpack_from('<QQ', raw, pos + i * 16)
            table[k] = off
        pos += cnt * 16
        if name in out:
            print(f'!! index.idx : nom en double {name!r}')
        out[name] = (tsize, table)
    if pos != len(raw):
        print(f'!! index.idx : {len(raw) - pos} octets non lus en fin de '
              f'fichier (index corrompu ?)')
    return out


def read_tile(path, check_blobs=False):
    with open(path, 'rb') as f:
        raw = f.read()
    tsize, cnt = struct.unpack_from('<II', raw, 0)
    table = {}
    problems = []
    for i in range(cnt):
        k, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        table[k] = off
    for k, off in table.items():
        if off < 8 + 16 * cnt or off + 8 > len(raw):
            problems.append(
                f'offset hors limites cle ({k & 0xFFFFFFFF},{k >> 32})')
            continue
        if check_blobs:
            ln, = struct.unpack_from('<q', raw, off)
            if ln <= 0 or off + 8 + ln > len(raw) \
                    or raw[off + 8:off + 12] != b'\x89PNG':
                problems.append(
                    f'blob non-PNG cle ({k & 0xFFFFFFFF},{k >> 32})')
    return tsize, table, problems


def referenced_sheets():
    """Ensemble des planches utilisees par toutes les cartes du depot."""
    out = {}
    for pattern in ('Data/Map/*.rsmap', 'Data/Ground/*.rsground'):
        for path in glob.glob(os.path.join(ROOT, pattern)):
            try:
                with open(path, encoding='utf-8-sig') as f:
                    obj = json.load(f)['Object']
            except Exception as e:
                print(f'!! carte illisible {os.path.basename(path)} : {e}')
                continue
            for L in obj.get('Layers', []):
                for col in L.get('Tiles', []):
                    for cell in col:
                        for tl in cell.get('Layers', []):
                            for fr in tl.get('Frames', []):
                                s = fr.get('Sheet')
                                if s:
                                    out.setdefault(s, set()).add(
                                        os.path.basename(path))
    return out


def main():
    quiet = '--quiet' in sys.argv
    errors = 0
    idx = read_index()
    ondisk = {os.path.basename(p)[:-5]
              for p in glob.glob(os.path.join(TILEDIR, '*.tile'))}
    print(f'{len(idx)} tilesets dans index.idx, {len(ondisk)} .tile '
          f'sur disque')

    # 1+2 : disque <-> index
    for name in sorted(ondisk):
        if name not in idx:
            print(f'!! {name} : .tile present, absent de index.idx '
                  f'(invisible en jeu)')
            errors += 1
            continue
        itsize, itable = idx[name]
        tsize, table, problems = read_tile(
            os.path.join(TILEDIR, name + '.tile'), check_blobs=True)
        if itsize != tsize:
            print(f'!! {name} : tileSize index={itsize} fichier={tsize}')
            errors += 1
        if set(itable) != set(table):
            print(f'!! {name} : cles index={len(itable)} '
                  f'fichier={len(table)}')
            errors += 1
        else:
            diff = sum(1 for k in itable if itable[k] != table[k])
            if diff:
                print(f'!! {name} : {diff} offsets different entre '
                      f'index et fichier')
                errors += 1
        for p in problems[:3]:
            print(f'!! {name} : {p}')
            errors += 1
    for name in sorted(set(idx) - ondisk):
        print(f'!! {name} : dans index.idx mais .tile absent')
        errors += 1

    # 3 : feuilles referencees par les cartes
    refs = referenced_sheets()
    if not quiet:
        print(f'{len(refs)} planches distinctes referencees par les '
              f'cartes')
    for name in sorted(refs):
        if name not in ondisk:
            print(f'!! {name} : reference par {sorted(refs[name])} '
                  f'mais .tile absent')
            errors += 1
        if name not in idx:
            print(f'!! {name} : reference par {sorted(refs[name])} '
                  f'mais absent de index.idx (DAMIER EN JEU)')
            errors += 1

    if errors == 0:
        print('TOUT EST COHERENT : planches, index.idx et cartes.')
    else:
        print(f'{errors} probleme(s).')
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main())
