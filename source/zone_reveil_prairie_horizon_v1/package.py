"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/zone_reveil_prairie_horizon_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, io, json, subprocess, sys, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/zone_reveil_prairie_horizon_v1'
NS = 'zone_reveil_prairie_horizon'
S = R / '.cache/zone_reveil_prairie_horizon_v1' / NS
PFX = 'ZRV1'
AMB = {'jour': 'J', 'aube': 'A', 'nuit': 'N'}
STATIC = ['sol_complet', 'herbe', 'chemin', 'fleurs', 'rochers', 'buissons', 'panorama']
FRAMED = ['mer', 'ecume', 'bulles', 'scintillements']
PAGE = R / 'apercu_zone_reveil_prairie_horizon_v1.html'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_img(a):
    b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG', optimize=True)
    return 'data:image/png;base64,' + base64.b64encode(b.getvalue()).decode()


def uri(p):
    return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.zone_reveil_prairie_horizon_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip', [(p, f'{NS}/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, p.relative_to(O).as_posix()) for p in sorted((O / 'calques').rglob('*.png'))]
    items += [(p, p.relative_to(O).as_posix()) for p in sorted((O / 'animation').rglob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    items += [(O / f'{PFX}_zone_reveil_{a}_calques.ora', f'{PFX}_zone_reveil_{a}_calques.ora') for a in AMB]
    items += [(O / 'manifest.json', 'manifest.json'), (O / 'README.md', 'README.md')]
    items += [(p, 'apercu/' + p.name) for p in sorted((O / 'review').iterdir())]
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)
    data = {'size': M['size_px'], 'amb': {}, 'clouds': M['nuages'], 'reveil': M['access']['reveil_px'],
            'entry': M['access']['entry_px'], 'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png')}
    for a, k in AMB.items():
        L = {Path(x['file']).name.split('_', 2)[2].rsplit('_f', 1)[0].replace('.png', ''): x for x in M['ambiances'][a]['layers']}
        comp = Image.new('RGBA', tuple(M['size_px']))
        for nm in STATIC:
            comp.alpha_composite(Image.open(O / L[nm]['file']).convert('RGBA'))
        layers = []
        for nm in FRAMED:
            x = L[nm]
            layers.append({'id': nm, 'ticks': x['ticks'],
                           'frames': [uri(O / x['file'].replace('fNNN', f'f{t:03d}')) for t in range(x['phases'])]})
        strips = {n: uri(O / f'masques/{PFX}_{a}_nuages_bande_{n}.png') for n in M['nuages']['rangees']}
        data['amb'][a] = {'fond': uri_img(np.array(comp)), 'layers': layers, 'strips': strips}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    PAGE.write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', PAGE]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
