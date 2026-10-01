"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/fin_givre_aurore_v2/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_givre_aurore_v2'
S = R / '.cache/fin_givre_aurore_v2/fin_givre_aurore'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.fin_givre_aurore_v2.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    (O / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(O / 'FGG2_projet_pmdo_0812.zip',
           [(p, 'fin_givre_aurore/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['eau_glacee', 'reflets', 'etoiles', 'aurore', 'flocons']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses_flocons/' + p.name) for p in sorted((O / 'poses_flocons').glob('*.png'))]
    items += [(q, 'reference/' + q.name) for q in sorted((HERE / 'reference').glob('*.png'))]
    items += [(O / 'review/FGG2_aurore_12phases_x2.webp', 'apercu/FGG2_aurore_12phases_x2.webp')]
    items += [(O / 'FGG2_fin_givre_aurore_calques.ora', 'FGG2_fin_givre_aurore_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/FGG2_scene_t000.png', 'apercu/FGG2_scene_t000.png'),
              (O / 'review/FGG2_scene_animee.webp', 'apercu/FGG2_scene_animee.webp'),
              (O / 'review/FGG2_collisions_marqueurs.png', 'apercu/FGG2_collisions_marqueurs.png')]
    zipdir(O / 'FGG2_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    ph = {k: M[k] for k in ('eau_glacee', 'reflets', 'etoiles', 'aurore', 'flocons')}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            stack.append({'id': nm, 'ticks': ph[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(ph[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    poses = []
    for q in sorted((O / 'poses_flocons').glob('*.png')):
        w, h = Image.open(q).size
        poses.append({'id': q.stem.split('_', 1)[1], 'uri': uri(q), 'w': w * 4, 'h': h * 4})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(0,0,63)', 'poses': poses,
            'collisions': uri(O / 'review/FGG2_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_fin_givre_aurore_v2.html').write_text(page)
    for p in [O / 'FGG2_projet_pmdo_0812.zip', O / 'FGG2_calques_png_8px.zip', R / 'apercu_fin_givre_aurore_v2.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
