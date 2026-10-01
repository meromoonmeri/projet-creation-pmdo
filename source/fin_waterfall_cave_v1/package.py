"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/fin_waterfall_cave_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_waterfall_cave_v1'
S = R / '.cache/fin_waterfall_cave_v1/fin_waterfall_cave'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.fin_waterfall_cave_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    (O / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(O / 'FWC1_projet_pmdo_0812.zip',
           [(p, 'fin_waterfall_cave/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['eau', 'lueur_joyau', 'scintillements']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(R / 'Waterfall_Cave_gem_TDS.png', 'reference/Waterfall_Cave_gem_TDS.png')]
    items += [(O / 'FWC1_fin_waterfall_calques.ora', 'FWC1_fin_waterfall_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/FWC1_scene_t000.png', 'apercu/FWC1_scene_t000.png'),
              (O / 'review/FWC1_scene_animee.webp', 'apercu/FWC1_scene_animee.webp'),
              (O / 'review/FWC1_collisions_marqueurs.png', 'apercu/FWC1_collisions_marqueurs.png')]
    zipdir(O / 'FWC1_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    ph = {k: M[k] for k in ('eau', 'lueur_joyau', 'scintillements')}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            stack.append({'id': nm, 'ticks': ph[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(ph[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    poses = []
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(59,104,145)', 'poses': poses,
            'collisions': uri(O / 'review/FWC1_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_fin_waterfall_cave_v1.html').write_text(page)
    for p in [O / 'FWC1_projet_pmdo_0812.zip', O / 'FWC1_calques_png_8px.zip', R / 'apercu_fin_waterfall_cave_v1.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
