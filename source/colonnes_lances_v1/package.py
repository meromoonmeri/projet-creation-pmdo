"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/colonnes_lances_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, re, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/colonnes_lances_v1/CLR1'
S = R / '.cache/colonnes_lances_v1/colonnes_lances'
ANIM = ('nuages', 'rochers', 'vitrail', 'eclats')


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.colonnes_lances_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    (O / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(O / 'CLR1_projet_pmdo_0812.zip',
           [(p, 'colonnes_lances/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIM:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(HERE / f'reference/{c}.png', f'reference/{c}.png') for c in ('D30P42A', 'D28P33A')]
    items += [(O / 'review/CLR1_zoom_autel.png', 'apercu/CLR1_zoom_autel.png')]
    items += [(O / 'CLR1_colonnes_lances_calques.ora', 'CLR1_colonnes_lances_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/CLR1_scene_t000.png', 'apercu/CLR1_scene_t000.png'),
              (O / 'review/CLR1_scene_animee.webp', 'apercu/CLR1_scene_animee.webp'),
              (O / 'review/CLR1_collisions_marqueurs.png', 'apercu/CLR1_collisions_marqueurs.png')]
    zipdir(O / 'CLR1_calques_png_8px.zip', items)

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
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(183,167,87)', 'poses': [],
            'collisions': uri(O / 'review/CLR1_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_colonnes_lances.html').write_text(page)
    for p in [O / 'CLR1_projet_pmdo_0812.zip', O / 'CLR1_calques_png_8px.zip', R / 'apercu_colonnes_lances.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
