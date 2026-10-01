"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/zone_zero_v1/eaz1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[2]
O = R / 'renders/zone_zero_v1/EAZ1'
S = R / '.cache/zone_zero_v1/entree_zone_zero'
ANIM = ('cristaux', 'portail', 'lucioles', 'scintillements')


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.zone_zero_v1.eaz1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    (O / 'README.md').write_text((HERE / 'README_PACK.md').read_text())
    zipdir(O / 'EAZ1_projet_pmdo_0812.zip',
           [(p, 'entree_zone_zero/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIM:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(HERE.parent / f'reference/{c}.png', f'reference/{c}.png') for c in ('D17P11A',)]
    items += [(O / 'EAZ1_entree_zone_zero_calques.ora', 'EAZ1_entree_zone_zero_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md'), (O / 'review/EAZ1_scene_t000.png', 'apercu/EAZ1_scene_t000.png'),
              (O / 'review/EAZ1_scene_animee.webp', 'apercu/EAZ1_scene_animee.webp'),
              (O / 'review/EAZ1_collisions_marqueurs.png', 'apercu/EAZ1_collisions_marqueurs.png')]
    zipdir(O / 'EAZ1_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            stack.append({'id': nm, 'ticks': M[nm]['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(M[nm]['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(24,52,66)', 'poses': [],
            'collisions': uri(O / 'review/EAZ1_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_entree_zone_zero.html').write_text(page)
    for p in [O / 'EAZ1_projet_pmdo_0812.zip', O / 'EAZ1_calques_png_8px.zip', R / 'apercu_entree_zone_zero.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
