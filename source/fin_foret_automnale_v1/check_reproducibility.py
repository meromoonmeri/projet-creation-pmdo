"""Reconstruire FFA1 deux fois et comparer les artefacts du build hors métadonnées ZIP.
Ne compare ni les archives de livraison, ni le viewer produit par package.py.
"""
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders' / HERE.name
STAGE = ROOT / '.cache' / HERE.name / 'fin_foret_automnale_v1'


def snapshot():
    values = {}
    generated = [OUT / d for d in ('calques', 'animation', 'masques', 'review')]
    generated += [OUT / 'manifest.json', OUT / 'FFA1_calques.ora', STAGE]
    for item in generated:
        paths = sorted(item.rglob('*')) if item.is_dir() else [item]
        for p in paths:
            if not p.is_file() or '__pycache__' in p.parts or p.suffix == '.pyc':
                continue
            key = p.relative_to(ROOT).as_posix()
            if p.suffix == '.ora':
                with zipfile.ZipFile(p) as z:
                    for name in sorted(z.namelist()):
                        values[key + '!' + name] = hashlib.sha256(z.read(name)).hexdigest()
            else:
                values[key] = hashlib.sha256(p.read_bytes()).hexdigest()
    return values


def main():
    snapshots = []
    for _ in range(2):
        subprocess.run([sys.executable, str(HERE / 'build.py')], cwd=ROOT,
                       check=True, capture_output=True, text=True)
        snapshots.append(snapshot())
    a, b = snapshots
    differences = [key for key in sorted(a.keys() | b.keys()) if a.get(key) != b.get(key)]
    report = {'compared_files_and_ora_members': len(a), 'differences': len(differences),
              'method': 'SHA256 artefacts du build et staging ; membres ORA hors horodatages ; caches Python exclus',
              'excluded': 'ZIP de livraison, viewer HTML et rapports produits hors build',
              'different_paths': differences}
    (OUT / 'reproducibilite.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))
    if not a or differences:
        raise SystemExit('Sorties absentes ou non reproductibles')


if __name__ == '__main__':
    main()
