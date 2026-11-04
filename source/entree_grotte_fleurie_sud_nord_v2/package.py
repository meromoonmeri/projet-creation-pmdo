"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/entree_grotte_fleurie_sud_nord_v2/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_grotte_fleurie_sud_nord_v2'
S = R / '.cache/entree_grotte_fleurie_sud_nord_v2/entree_grotte_fleurie_sud_nord_v2'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_grotte_fleurie_sud_nord_v2.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / 'EGF2_projet_pmdo_0812.zip',
           [(p, 'entree_grotte_fleurie_sud_nord_v2/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['fleurs', 'papillons']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses_papillons/' + p.name) for p in sorted((O / 'poses_papillons').glob('*.png'))]
    items += [(O / 'EGF2_entree_grotte_fleurie_longue_calques.ora', 'EGF2_entree_grotte_fleurie_longue_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (HERE / 'README_PACK.md', 'README.md'), (O / 'review/EGF2_scene_t000.png', 'apercu/EGF2_scene_t000.png'),
              (O / 'review/EGF2_scene_animee.webp', 'apercu/EGF2_scene_animee.webp'),
              (O / 'review/EGF2_collisions_marqueurs.png', 'apercu/EGF2_collisions_marqueurs.png')]
    zipdir(O / 'EGF2_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    counts = {'fleurs': M['flowers']['phases'], 'papillons': M['butterflies']['phases']}
    ticks = {'fleurs': M['flowers']['frame_length_ticks'], 'papillons': M['butterflies']['frame_length_ticks']}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        kind = p.split('/')[1] if p.startswith('animation/') else None
        if kind:
            fmt = (lambda t: p.replace('fXX', f'f{t:02d}')) if 'fXX' in p else (lambda t: p.replace('fX', f'f{t}'))
            stack.append({'id': Path(p).stem.replace('EGF2_', '').rsplit('_f', 1)[0], 'ticks': ticks[kind],
                          'frames': [uri(O / fmt(t)) for t in range(counts[kind])]})
        else:
            stack.append({'id': Path(p).stem.replace('EGF2_', ''), 'ticks': 60, 'frames': [uri(O / p)]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack,
            'surface': 'rgb(111,207,81)',
            'poses': [{'id': f'{c} {i}', 'uri': uri(O / f'poses_papillons/EGF2_papillon_{c}_{i}.png')} for c in ('jaune', 'bleu') for i in range(6)],
            'collisions': uri(O / 'review/EGF2_collisions_marqueurs.png'),
            'entry': M['access']['entry_px'], 'threshold': M['access']['threshold_px']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_entree_grotte_fleurie_sud_nord_v2.html').write_text(page)
    for p in [O / 'EGF2_projet_pmdo_0812.zip', O / 'EGF2_calques_png_8px.zip', R / 'apercu_entree_grotte_fleurie_sud_nord_v2.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
