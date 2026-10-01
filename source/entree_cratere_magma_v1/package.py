"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/entree_cratere_magma_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_cratere_magma_v1'
S = R / '.cache/entree_cratere_magma_v1/entree_cratere_magma'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_cratere_magma_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / 'ECM1_projet_pmdo_0812.zip',
           [(p, 'entree_cratere_magma/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['magma', 'cascades', 'braises', 'colonnes']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses_colonne/' + p.name) for p in sorted((O / 'poses_colonne').glob('*.png'))]
    items += [(O / 'review/ECM1_planche_colonne_x2.png', 'apercu/ECM1_planche_colonne_x2.png')]
    items += [(O / 'ECM1_entree_cratere_magma_calques.ora', 'ECM1_entree_cratere_magma_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/ECM1_scene_t000.png', 'apercu/ECM1_scene_t000.png'),
              (O / 'review/ECM1_scene_animee.webp', 'apercu/ECM1_scene_animee.webp'),
              (O / 'review/ECM1_collisions_marqueurs.png', 'apercu/ECM1_collisions_marqueurs.png')]
    zipdir(O / 'ECM1_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    ph = {k: M[k] for k in ('magma', 'cascades', 'braises', 'colonnes')}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            stack.append({'id': nm, 'ticks': ph[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(ph[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    poses = []
    for q in sorted((O / 'poses_colonne').glob('*.png'))[::4]:
        w, h = Image.open(q).size
        poses.append({'id': q.stem.split('_', 1)[1], 'uri': uri(q), 'w': w * 2, 'h': h * 2})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(246,150,39)', 'poses': poses,
            'collisions': uri(O / 'review/ECM1_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_entree_cratere_magma_v1.html').write_text(page)
    for p in [O / 'ECM1_projet_pmdo_0812.zip', O / 'ECM1_calques_png_8px.zip', R / 'apercu_entree_cratere_magma_v1.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
