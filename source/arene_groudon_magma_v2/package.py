"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/arene_groudon_magma_v2/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/arene_groudon_magma_v2'
S = R / '.cache/arene_groudon_magma_v2/arene_groudon_magma_v2'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.arene_groudon_magma_v2.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / 'AGM2_projet_pmdo_0812.zip',
           [(p, 'arene_groudon_magma/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['magma', 'symbole_groudon', 'braises', 'colonnes']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(O / 'review/AGM2_pulsation_symbole.png', 'apercu/AGM2_pulsation_symbole.png')]
    items += [(O / 'AGM2_arene_groudon_magma_calques.ora', 'AGM2_arene_groudon_magma_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/AGM2_scene_t000.png', 'apercu/AGM2_scene_t000.png'),
              (O / 'review/AGM2_scene_animee.webp', 'apercu/AGM2_scene_animee.webp'),
              (O / 'review/AGM2_collisions_marqueurs.png', 'apercu/AGM2_collisions_marqueurs.png')]
    zipdir(O / 'AGM2_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    ph = {k: M[k] for k in ('magma', 'symbole_groudon', 'braises', 'colonnes')}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            stack.append({'id': nm, 'ticks': ph[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(ph[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    q = O / 'review/AGM2_pulsation_symbole.png'; w, h = Image.open(q).size
    poses = [{'id': 'pulsation du signe (6 phases sur 12)', 'uri': uri(q), 'w': 300, 'h': round(300 * h / w)}]
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(246,150,39)', 'poses': poses,
            'collisions': uri(O / 'review/AGM2_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_arene_groudon_magma_v2.html').write_text(page)
    for p in [O / 'AGM2_projet_pmdo_0812.zip', O / 'AGM2_calques_png_8px.zip', R / 'apercu_arene_groudon_magma_v2.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
