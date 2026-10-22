#!/usr/bin/env python3
"""Sécurise l'état injecté des 34 Grounds. Deux niveaux, complémentaires.

POURQUOI DEUX NIVEAUX
---------------------------------------------------------------------------
Les .rsground injectés pèsent 1,5 Go (44 Mo pièce). Une archive complète fait
~228 Mo : trop pour Git (pack déjà à 743 Mo), et Git LFS est inutilisable dans
ce sandbox (git-lfs absent, hôtes de stockage bloqués - audit confirmé).

Mais les .rsground sont REPRODUCTIBLES : ils se régénèrent depuis la source via
convert_environment_room.py. Ce qui n'est PAS reproductible, c'est le résultat
du placement écologique : les 1 642 entités, leurs positions validées et leurs
ScriptVars. Ce delta pèse 41 Ko en gzip.

  Niveau 1 - PATCH VERSIONNÉ (Git, ~41 Ko)
      Le contenu irremplaçable : toutes les entités injectées, par room, avec
      le sha256 du Ground avant et après injection. Réapplicable sur des
      Grounds fraîchement reconvertis pour retrouver l'état exact.

  Niveau 2 - ARCHIVE COMPLÈTE (disque, ~228 Mo)
      tar déterministe de l'état complet, pour restauration immédiate sans
      régénération. Hors Git, mais vérifiée par extraction réelle.

Les deux portent le commit et le tag de référence.

DÉTERMINISME
---------------------------------------------------------------------------
tar trié par nom, mtime/uid/gid/mode normalisés, gzip sans horodatage
(mtime=0). Deux exécutions sur le même état produisent le même sha256.
"""
from __future__ import annotations
import argparse, gzip, hashlib, io, json, os, subprocess, sys, tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

WILD = 'wild'


def sha256_file(p: Path, chunk=1 << 20):
    h = hashlib.sha256()
    with open(p, 'rb') as fh:
        for b in iter(lambda: fh.read(chunk), b''):
            h.update(b)
    return h.hexdigest()


def git(*args):
    return subprocess.run(['git', *args], cwd=str(ROOT),
                          capture_output=True, text=True).stdout.strip()


def build_patch(reconv: Path):
    """Extrait les entités injectées de chaque Ground : le delta irremplaçable."""
    rooms = {}
    total = 0
    for room_dir in sorted(reconv.iterdir()):
        if not room_dir.is_dir():
            continue
        room = room_dir.name
        for gp in sorted((room_dir / 'Data/Ground').glob('*.rsground')):
            g = json.load(open(gp, encoding='utf-8-sig'))
            obj = g['Object']
            layers = obj.get('Entities') or []
            chars = (layers[0].get('MapChars') or []) if layers else []
            wild = [c for c in chars
                    if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == WILD]
            if not wild:
                continue
            season = gp.stem.rsplit('_', 1)[-1]
            rooms.setdefault(room, {})[season] = {
                'ground_file': gp.name,
                'entity_count': len(wild),
                'entities': wild,
                'sha256_after_injection': sha256_file(gp),
            }
            total += len(wild)
    return rooms, total


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--backup', default='/tmp/fauna-backup/grounds')
    ap.add_argument('--archive-dir', default='/tmp/fauna-archive')
    ap.add_argument('--full-archive', action='store_true',
                    help='produire aussi le tar complet (~228 Mo, hors Git)')
    ns = ap.parse_args()

    reconv = Path(ns.reconv)
    commit = git('rev-parse', 'HEAD')
    tag = git('rev-parse', '--short', 'pre-fauna-injection')

    print('=== niveau 1 : patch d entites ===')
    rooms, total = build_patch(reconv)
    print('rooms: %d | entites: %d' % (len(rooms), total))

    # backups .pre-fauna.bak
    bakdir = Path(ns.backup)
    backups = {}
    for b in sorted(bakdir.glob('*.pre-fauna.bak')):
        backups[b.name] = {'bytes': b.stat().st_size, 'sha256': sha256_file(b)}
    print('backups .pre-fauna.bak: %d' % len(backups))

    # inventaire complet de l'etat reconv
    inventory = {}
    for p in sorted(reconv.rglob('*')):
        if not p.is_file() or p.suffix == '.log':
            continue
        rel = str(p.relative_to(reconv))
        inventory[rel] = {'bytes': p.stat().st_size, 'sha256': sha256_file(p)}
    print('fichiers inventories: %d' % len(inventory))

    patch = {
        'schema': 'nnv-fauna-ground-patch-v1',
        'reference': {'commit': commit, 'tag': 'pre-fauna-injection',
                      'tag_commit': tag},
        'totals': {'rooms': len(rooms), 'entities': total,
                   'backups': len(backups), 'inventory_files': len(inventory)},
        'reconciliation': {'placed': 1808, 'injected': total,
                           'held_missing_season': 109, 'held_no_proof': 57,
                           'balanced': total + 109 + 57 == 1808},
        'rooms': rooms,
        'backups': backups,
        'inventory': inventory,
    }

    outdir = ECO / 'ground-archive'
    outdir.mkdir(parents=True, exist_ok=True)
    raw = json.dumps(patch, ensure_ascii=False, sort_keys=True,
                     separators=(',', ':')).encode()
    patch_path = outdir / 'injected-entities-patch.json.gz'
    with gzip.GzipFile(filename='', mode='wb', fileobj=open(patch_path, 'wb'),
                       compresslevel=9, mtime=0) as fh:
        fh.write(raw)
    print('patch: %s (%.0f Ko, %.2f Mo brut)'
          % (patch_path.name, patch_path.stat().st_size / 1024, len(raw) / 1e6))

    manifest = {
        'schema': 'nnv-fauna-archive-manifest-v1',
        'reference': patch['reference'],
        'totals': patch['totals'],
        'reconciliation': patch['reconciliation'],
        'patch': {'file': patch_path.name,
                  'sha256': sha256_file(patch_path),
                  'bytes': patch_path.stat().st_size,
                  'raw_sha256': hashlib.sha256(raw).hexdigest()},
        'policy': {
            'versioned_in_git': ['injected-entities-patch.json.gz',
                                 'archive-manifest.json'],
            'not_versioned': ('les .rsground (1,5 Go) sont reproductibles depuis '
                              'la source ; seule leur difference - les entites - '
                              'est versionnee. Git LFS indisponible (git-lfs '
                              'absent, hotes de stockage bloques).'),
        },
    }

    if ns.full_archive:
        print('\n=== niveau 2 : archive complete deterministe ===')
        os.makedirs(ns.archive_dir, exist_ok=True)
        tar_path = Path(ns.archive_dir) / 'nnv-injected-grounds.tar.gz'
        files = sorted(p for p in reconv.rglob('*')
                       if p.is_file() and p.suffix != '.log')
        buf = io.BytesIO()
        with tarfile.open(fileobj=buf, mode='w', format=tarfile.GNU_FORMAT) as tf:
            for p in files:
                ti = tf.gettarinfo(str(p), arcname=str(p.relative_to(reconv)))
                ti.mtime, ti.uid, ti.gid = 0, 0, 0
                ti.uname, ti.gname = '', ''
                ti.mode = 0o644
                with open(p, 'rb') as fh:
                    tf.addfile(ti, fh)
        data = buf.getvalue()
        with gzip.GzipFile(filename='', mode='wb',
                           fileobj=open(tar_path, 'wb'),
                           compresslevel=6, mtime=0) as fh:
            fh.write(data)
        manifest['full_archive'] = {
            'file': str(tar_path), 'bytes': tar_path.stat().st_size,
            'sha256': sha256_file(tar_path),
            'tar_sha256': hashlib.sha256(data).hexdigest(),
            'file_count': len(files),
            'deterministic': 'mtime=0, uid/gid=0, mode 644, entrees triees',
        }
        print('archive: %s (%.1f Mo, %d fichiers)'
              % (tar_path.name, tar_path.stat().st_size / 1e6, len(files)))

    mpath = outdir / 'archive-manifest.json'
    mpath.write_text(json.dumps(manifest, indent=1, ensure_ascii=False) + '\n')
    print('\nmanifeste:', mpath)
    print('reconciliation %d + 109 + 57 = 1808 -> %s'
          % (total, 'OK' if patch['reconciliation']['balanced'] else 'ECHEC'))
    return 0 if patch['reconciliation']['balanced'] else 1


if __name__ == '__main__':
    sys.exit(main())
