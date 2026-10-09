"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/bureau_pelipper_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, re, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/bureau_pelipper_v1'
S = R / '.cache/bureau_pelipper_v1/bureau_pelipper'
PFX = 'PPO1'
REVIEW = ['scene_t000.png', 'collisions_marqueurs.png', 'mobilier_tilesheet.png']


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.bureau_pelipper_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip',
           [(p, 'bureau_pelipper/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    items += [(O / f'{PFX}_bureau_pelipper_calques.ora', f'{PFX}_bureau_pelipper_calques.ora'),
              (O / 'manifest.json', 'manifest.json'), (O / 'README.md', 'README.md')]
    items += [(O / 'review' / f'{PFX}_{n}', f'apercu/{PFX}_{n}') for n in REVIEW]
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    stack = []
    for L in M['layers']:
        name = re.sub(rf'^{PFX}_\d\d_', '', Path(L['file']).stem)
        stack.append({'id': name, 'ticks': L['ticks'], 'frames': [uri(O / L['file'])]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(32,24,64)', 'poses': [],
            'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png'),
            'entry': M['access']['entry_px']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_bureau_pelipper_v1.html').write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', R / 'apercu_bureau_pelipper_v1.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
