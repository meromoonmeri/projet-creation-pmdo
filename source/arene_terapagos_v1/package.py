"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/arene_terapagos_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, re, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/arene_terapagos_v1/ATP1'
S = R / '.cache/arene_terapagos_v1/arene_terapagos'
ANIM = ('reflets', 'embleme', 'runes', 'scintillements')


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.arene_terapagos_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    (O / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(O / 'ATP1_projet_pmdo_0812.zip',
           [(p, 'arene_terapagos/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIM:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(HERE / f'reference/{c}.png', f'reference/{c}.png') for c in ('D17P45A', 'D42P42A')]
    items += [(O / f'review/ATP1_{n}.png', f'apercu/ATP1_{n}.png') for n in ('pulsation_embleme', 'tons_spectre')]
    items += [(O / 'ATP1_arene_terapagos_calques.ora', 'ATP1_arene_terapagos_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/ATP1_scene_t000.png', 'apercu/ATP1_scene_t000.png'),
              (O / 'review/ATP1_scene_animee.webp', 'apercu/ATP1_scene_animee.webp'),
              (O / 'review/ATP1_collisions_marqueurs.png', 'apercu/ATP1_collisions_marqueurs.png')]
    zipdir(O / 'ATP1_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = re.sub(r'_fN+$', '', Path(p).stem.split('_', 2)[2]); mt = re.search(r'fN+', p)
        if mt:
            w = len(mt.group()) - 1
            stack.append({'id': nm, 'ticks': M[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace(mt.group(), f'f{t:0{w}d}')) for t in range(M[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(120,220,250)', 'poses': [],
            'collisions': uri(O / 'review/ATP1_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_arene_terapagos.html').write_text(page)
    for p in [O / 'ATP1_projet_pmdo_0812.zip', O / 'ATP1_calques_png_8px.zip', R / 'apercu_arene_terapagos.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
