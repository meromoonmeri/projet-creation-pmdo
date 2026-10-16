"""Tests -> ZIP projet PMDO, ZIP calques, aperçu HTML autonome. Sorties non versionnées."""
from pathlib import Path
import base64
import json
import subprocess
import sys
import zipfile
import unittest

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders' / HERE.name
STAGE = ROOT / '.cache' / HERE.name / 'traversee_lac_glace_v1'


def uri(path):
    return 'data:image/png;base64,' + base64.b64encode(path.read_bytes()).decode()


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for source, relative in sorted(items, key=lambda item: item[1]):
            z.write(source, relative)
    with zipfile.ZipFile(path) as z:
        assert z.testzip() is None, path
        assert len(z.namelist()) == len(set(z.namelist())), 'Doublon dans le ZIP'


def main():
    suite=unittest.defaultTestLoader.loadTestsFromName('source.traversee_lac_glace_v1.test_build')
    result=unittest.TextTestRunner(stream=sys.stdout,verbosity=2).run(suite)
    tests={'passed':result.wasSuccessful(),'tests':result.testsRun,'failures':len(result.failures),'errors':len(result.errors)}
    (OUT/'tests.json').write_text(json.dumps(tests,indent=2)+'\n')
    if not result.wasSuccessful():raise SystemExit('Tests echoues, pas de livraison')
    report = subprocess.run([sys.executable, '-m', 'source.traversee_lac_glace_v1.verify'], cwd=ROOT, check=True, capture_output=True, text=True)
    (OUT / 'verification.json').write_text(report.stdout)
    m = json.loads((OUT / 'manifest.json').read_text())
    (OUT / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(OUT / 'TLG1_projet_pmdo_0812.zip', [(p, 'traversee_lac_glace_v1/' + p.relative_to(STAGE).as_posix())
                                            for p in STAGE.rglob('*') if p.is_file()
                                            and '__pycache__' not in p.parts and p.suffix != '.pyc'])
    items = [(p, p.relative_to(OUT).as_posix()) for d in ['calques', 'animation', 'masques', 'review']
             for p in (OUT / d).rglob('*') if p.is_file()]
    items += [(OUT / n, n) for n in ['README.md', 'manifest.json', 'verification.json', 'tests.json', 'TLG1_calques.ora']]
    items += [(p, 'reference/' + p.name) for p in (HERE / 'reference').iterdir() if p.is_file()]
    if (OUT / 'reproducibilite.json').exists():
        items.append((OUT / 'reproducibilite.json', 'reproducibilite.json'))
    items += [(HERE/'generation.json','generation.json')]
    zipdir(OUT / 'TLG1_calques_png_8px.zip', items)
    labels = ['Sol complet', 'Neige praticable', 'Ombres de neige', 'Berges', 'Reliefs rocheux', 'Lac gelé solide', 'Profondeur nord-est', 'Reflets animés', 'Flocons animés']
    layers = [{'label': label, 'frames': [uri(OUT / l['file'].replace('NN', f'{t:02d}')) for t in range(l['phases'])]}
              for label, l in zip(labels, m['layers'])]
    blocked = np.array(Image.open(OUT / 'masques/TLG1_collisions.png')) > 0
    y, x = np.nonzero(blocked)
    data = {'layers': layers, 'reference': uri(HERE / 'reference/D53P11B.png'),
            'fidelity': m['fidelity']['sortie'], 'blocked': np.stack([x, y], axis=1).tolist(),
            'markers': m['access']['markers']}
    template = (HERE / 'viewer_template.html').read_text()
    assert template.count('__DATA__') == 1
    (OUT / 'index.html').write_text(template.replace('__DATA__', json.dumps(data, ensure_ascii=False)))
    packages=[]
    for path in sorted(OUT.glob('*.zip')):
        with zipfile.ZipFile(path) as z:packages.append({'file':path.name,'bytes':path.stat().st_size,'members':len(z.namelist()),'crc_ok':z.testzip() is None})
    (OUT/'paquets.json').write_text(json.dumps(packages,indent=2)+'\n')
    for name in ['TLG1_projet_pmdo_0812.zip', 'TLG1_calques_png_8px.zip', 'index.html']:
        p = OUT / name
        print(p.relative_to(ROOT), f'{p.stat().st_size / 1e6:.2f} Mo')


if __name__ == '__main__':
    main()
