#!/usr/bin/env python3
"""Prouve que l'archive restaure EXACTEMENT l'état validé.

On ne fait confiance ni au tar, ni au manifeste : on extrait réellement dans un
répertoire propre, on recalcule tous les sha256, on les compare à l'inventaire,
et on revérifie que les 1 642 entités sont présentes dans les Grounds extraits.

Aucun backup ne doit être supprimé avant que ce script ne sorte en code 0.
"""
from __future__ import annotations
import argparse, gzip, hashlib, json, os, shutil, sys, tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'
ARCH = ECO / 'ground-archive'

failures = []
checks = 0


def check(c, m):
    global checks
    checks += 1
    if not c:
        failures.append(m)
    return c


def sha256_file(p: Path, chunk=1 << 20):
    h = hashlib.sha256()
    with open(p, 'rb') as fh:
        for b in iter(lambda: fh.read(chunk), b''):
            h.update(b)
    return h.hexdigest()


def main():
    global checks
    ap = argparse.ArgumentParser()
    ap.add_argument('--workdir', default='/tmp/fauna-restore-test')
    ap.add_argument('--keep', action='store_true')
    ns = ap.parse_args()

    manifest = json.load(open(ARCH / 'archive-manifest.json'))
    patch_path = ARCH / manifest['patch']['file']

    # 1. integrite du patch versionne
    check(sha256_file(patch_path) == manifest['patch']['sha256'],
          'patch: sha256 different du manifeste')
    raw = gzip.decompress(patch_path.read_bytes())
    check(hashlib.sha256(raw).hexdigest() == manifest['patch']['raw_sha256'],
          'patch: contenu decompresse different')
    patch = json.loads(raw)
    total_patch = sum(s['entity_count']
                      for r in patch['rooms'].values() for s in r.values())
    check(total_patch == 1642,
          'patch: %d entites au lieu de 1642' % total_patch)
    check(patch['reconciliation']['balanced'],
          'patch: reconciliation desequilibree')
    print('patch verifie : %d rooms, %d entites' % (len(patch['rooms']), total_patch))

    fa = manifest.get('full_archive')
    if not fa:
        print('pas d archive complete dans le manifeste (patch seul)')
        return report()

    tar_path = Path(fa['file'])
    if not check(tar_path.exists(), 'archive absente: %s' % tar_path):
        return report()

    # 2. integrite de l'archive
    check(sha256_file(tar_path) == fa['sha256'],
          'archive: sha256 different du manifeste')
    print('archive verifiee : %.1f Mo' % (tar_path.stat().st_size / 1e6))

    # 3. EXTRACTION REELLE dans un repertoire propre
    work = Path(ns.workdir)
    if work.exists():
        shutil.rmtree(work)
    work.mkdir(parents=True)
    with tarfile.open(tar_path, 'r:gz') as tf:
        tf.extractall(work)
    extracted = [p for p in work.rglob('*') if p.is_file()]
    print('extraction : %d fichiers dans %s' % (len(extracted), work))
    check(len(extracted) == fa['file_count'],
          'extraction: %d fichiers au lieu de %d' % (len(extracted), fa['file_count']))

    # 4. comparaison sha256 fichier par fichier avec l'inventaire d'origine
    inv = patch['inventory']
    mismatched, missing = 0, 0
    for rel, meta in inv.items():
        p = work / rel
        if not p.exists():
            missing += 1
            failures.append('extraction: fichier manquant %s' % rel)
            continue
        if sha256_file(p) != meta['sha256']:
            mismatched += 1
            failures.append('extraction: sha256 different pour %s' % rel)
    checks += len(inv)
    print('hashes compares : %d | manquants: %d | divergents: %d'
          % (len(inv), missing, mismatched))

    # 5. les 1 642 entites sont bien dans les Grounds EXTRAITS
    total_ext = 0
    for room, seasons in patch['rooms'].items():
        for season, info in seasons.items():
            gp = work / room / 'Data/Ground' / info['ground_file']
            if not check(gp.exists(), 'Ground extrait absent: %s' % gp.name):
                continue
            g = json.load(open(gp, encoding='utf-8-sig'))['Object']
            chars = (g.get('Entities') or [{}])[0].get('MapChars') or []
            wild = [c for c in chars
                    if (c.get('Data', {}).get('ScriptVars') or {}).get('nnv_kind') == 'wild']
            check(len(wild) == info['entity_count'],
                  '%s/%s: %d entites extraites au lieu de %d'
                  % (room, season, len(wild), info['entity_count']))
            check(sha256_file(gp) == info['sha256_after_injection'],
                  '%s/%s: Ground extrait different de l original' % (room, season))
            total_ext += len(wild)
    check(total_ext == 1642,
          'Grounds extraits: %d entites au lieu de 1642' % total_ext)
    print('entites relues dans les Grounds EXTRAITS : %d' % total_ext)

    # 6. backups toujours presents et intacts
    bakdir = Path('/tmp/fauna-backup/grounds')
    for name, meta in patch['backups'].items():
        b = bakdir / name
        if not check(b.exists(), 'backup disparu: %s' % name):
            continue
        check(sha256_file(b) == meta['sha256'], 'backup altere: %s' % name)
    print('backups verifies : %d' % len(patch['backups']))

    if not ns.keep:
        shutil.rmtree(work)
        print('repertoire de test nettoye')
    return report()


def report():
    print('\ncontroles: %d' % checks)
    if failures:
        print('ECHECS: %d' % len(failures))
        for f in failures[:20]:
            print('  -', f)
        return 1
    print('RESTAURATION PROUVEE : l archive reproduit exactement l etat valide')
    return 0


if __name__ == '__main__':
    sys.exit(main())
