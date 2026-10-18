"""Tests -> ZIP PMDO + ZIP calques PNG -> aperçu interactif autonome.
Lancer après build.py : .venv/bin/python source/fin_tour_temporelle_v1/package.py
"""
from pathlib import Path
import base64
import json
import subprocess
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
LOT = 'fin_tour_temporelle_v1'
OUT = ROOT / 'renders' / LOT
STAGE = ROOT / '.cache' / LOT / 'fin_tour_temporelle'
PROJECT_ZIP = OUT / 'FTT1_projet_pmdo_0812.zip'
LAYERS_ZIP = OUT / 'FTT1_calques_png_8px.zip'
HTML = ROOT / f'apercu_{LOT}.html'
ANIM_DIRS = ('nebuleuse_rouge_noir', 'nuages_rouge_noir', 'circuits_temporels', 'cristal_temporel', 'poussieres_temporelles')
REVIEW = ('review/FTT1_scene_t000.png', 'review/FTT1_scene_animee.webp',
          'review/FTT1_collisions_marqueurs.png')


def uri(path):
    return 'data:image/png;base64,' + base64.b64encode(Path(path).read_bytes()).decode('ascii')


def make_project_zip():
    if not STAGE.is_dir():
        raise FileNotFoundError(f'Staging Ground absent : exécuter {HERE / "build.py"}')
    (STAGE / 'README.md').write_bytes((HERE / 'README_PACK.md').read_bytes())
    (STAGE / 'STATUS.md').write_bytes((HERE / 'STATUS.md').read_bytes())
    with zipfile.ZipFile(PROJECT_ZIP, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for path in sorted(STAGE.rglob('*')):
            if path.is_file():
                z.write(path, f'{LOT}/{path.relative_to(STAGE).as_posix()}')
    with zipfile.ZipFile(PROJECT_ZIP) as z:
        names = set(z.namelist())
        required = {
            f'{LOT}/Mod.xml', f'{LOT}/INSTALLER.py', f'{LOT}/README.md', f'{LOT}/STATUS.md',
            f'{LOT}/manifest.json', f'{LOT}/Data/Ground/ftt1_sommet_tour_temporelle.rsground',
            f'{LOT}/Content/Tile/index.idx',
        }
        missing = required - names
        assert not missing, f'fichiers absents du ZIP PMDO : {sorted(missing)}'
        assert len([n for n in names if n.endswith('.tile')]) == 9
        assert z.testzip() is None, 'archive projet PMDO corrompue'


def make_layers_zip():
    items = []
    for folder in ('calques', 'masques'):
        items.extend((p, p.relative_to(OUT).as_posix()) for p in sorted((OUT / folder).glob('*.png')))
    for sub in ANIM_DIRS:
        root = OUT / 'animation' / sub
        items.extend((p, p.relative_to(OUT).as_posix()) for p in sorted(root.glob('*.png')))
    for rel in REVIEW:
        items.append((OUT / rel, rel))
    items.extend([
        (OUT / 'FTT1_fin_tour_temporelle_calques.ora', 'FTT1_fin_tour_temporelle_calques.ora'),
        (OUT / 'manifest.json', 'manifest.json'),
        (HERE / 'README_PACK.md', 'README_PACK.md'),
        (HERE / 'STATUS.md', 'STATUS.md'),
    ])
    source_files = [
        HERE / 'bruts/decor_magenta.png', HERE / 'bruts/sol_complet.png',
        HERE / 'bruts/nebuleuse_rouge_noir.png',
        HERE / 'reference/D29P11A.png', HERE / 'reference/D30P34A.png',
        HERE / 'reference/ETT2_style_swatch.png', HERE / 'reference/ETT2_nuages_magenta.png',
    ]
    items.extend((p, 'source/' + p.relative_to(HERE).as_posix()) for p in source_files)
    for path, _ in items:
        if not path.is_file():
            raise FileNotFoundError(f'élément manquant du ZIP de calques : {path}')
    with zipfile.ZipFile(LAYERS_ZIP, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for path, arc in items:
            z.write(path, arc)
    with zipfile.ZipFile(LAYERS_ZIP) as z:
        names = set(z.namelist())
        assert len(names) == len(items), 'noms dupliqués dans le ZIP de calques'
        assert z.testzip() is None, 'archive des calques corrompue'
        assert 'source/bruts/decor_magenta.png' in names
        assert 'STATUS.md' in names
        assert 'FTT1_fin_tour_temporelle_calques.ora' in names


def make_html():
    manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
    layers = []
    for entry in manifest['layers']:
        rel = entry['file']
        if 'fNN' in rel:
            paths = [OUT / rel.replace('fNN', f'f{t:02d}') for t in range(entry['phases'])]
        else:
            paths = [OUT / rel]
        if any(not p.is_file() for p in paths):
            raise FileNotFoundError(f'phase de calque absente : {rel}')
        layers.append({
            'id': entry['name'], 'ticks': entry['ticks'],
            'frames': [uri(path) for path in paths],
        })
    data = {
        'size': manifest['size_px'], 'loop': manifest['animation']['scene_loop_ticks'],
        'stack': layers, 'collisions': uri(OUT / REVIEW[2]),
        'entry': manifest['access']['markers']['entrance'],
        'boss': manifest['access']['markers']['boss_dialga'],
    }
    template = (HERE / 'viewer_template.html').read_text(encoding='utf-8')
    HTML.write_text(template.replace('__DATA__', json.dumps(data, separators=(',', ':'))), encoding='utf-8')


def main():
    subprocess.run([
        sys.executable, '-m', 'unittest', 'source.fin_tour_temporelle_v1.test_build', '-v'
    ], cwd=ROOT, check=True)
    make_project_zip()
    make_layers_zip()
    make_html()
    for path in (PROJECT_ZIP, LAYERS_ZIP, HTML):
        print(f'{path.relative_to(ROOT)} — {path.stat().st_size / (1024 * 1024):.2f} MiB')


if __name__ == '__main__':
    main()
