"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/zone_pommiers_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, re, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = 'zone_pommiers_v1'
O = R / 'renders' / LOT
S = R / '.cache' / LOT / 'zone_pommiers'
PFX = 'ZPO1'
ANIMS = ['pommes', 'pollen']
REVIEW = ['scene_t000.png', 'scene_animee.webp', 'collisions_marqueurs.png', 'planche_poses.png']


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, str(HERE / 'verify.py')], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip',
           [(p, 'zone_pommiers/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIMS:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses/' + p.name) for p in sorted((O / 'poses').glob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    items += [(O / f'{PFX}_zone_pommiers_calques.ora', f'{PFX}_zone_pommiers_calques.ora'),
              (O / 'manifest.json', 'manifest.json'), (O / 'README.md', 'README.md')]
    items += [(O / 'review' / f'{PFX}_{n}', f'apercu/{PFX}_{n}') for n in REVIEW]
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    stack = []
    for L in M['layers']:
        if L['name'].endswith('_top'):
            continue
        name = re.sub(rf'^{PFX}_\\d\\d_', '', Path(L['file']).stem.replace('_fNN', ''))
        frames = [O / L['file']] if L['phases'] == 1 else [O / L['file'].replace('fNN', f'f{t:02d}') for t in range(L['phases'])]
        stack.append({'id': name, 'ticks': L['ticks'], 'frames': [uri(p) for p in frames]})
    poses = []
    for p in sorted((O / 'poses').glob('*.png')):
        w, h = Image.open(p).size
        poses.append({'id': p.stem.replace(PFX + '_', ''), 'uri': uri(p), 'w': w, 'h': h})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(54,140,31)', 'poses': poses,
            'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png'),
            'entry': M['access']['entry_px'], 'boss': M['access']['boss_px'], 'objectif': M['access']['objective_px']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_zone_pommiers_v1.html').write_text(page)
    (O / 'review' / 'index.html').write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', R / 'apercu_zone_pommiers_v1.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
