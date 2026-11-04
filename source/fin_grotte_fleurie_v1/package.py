"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/fin_grotte_fleurie_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_grotte_fleurie_v1'
S = R / '.cache/fin_grotte_fleurie_v1/fin_grotte_fleurie'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.fin_grotte_fleurie_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / 'FGF1_projet_pmdo_0812.zip',
           [(p, 'fin_grotte_fleurie/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ['fleurs', 'lueur', 'petales']:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(O / 'FGF1_fin_grotte_fleurie_calques.ora', 'FGF1_fin_grotte_fleurie_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (HERE / 'README_PACK.md', 'README.md'), (O / 'review/FGF1_scene_t000.png', 'apercu/FGF1_scene_t000.png'),
              (O / 'review/FGF1_scene_animee.webp', 'apercu/FGF1_scene_animee.webp'),
              (O / 'review/FGF1_collisions_marqueurs.png', 'apercu/FGF1_collisions_marqueurs.png')]
    zipdir(O / 'FGF1_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    counts = {'fleurs': M['flowers']['phases'], 'lueur': M['glow']['phases'], 'petales': M['petals']['phases']}
    ticks = {'fleurs': M['flowers']['frame_length_ticks'], 'lueur': M['glow']['frame_length_ticks'],
             'petales': M['petals']['frame_length_ticks']}
    stack = []
    for p in M['layer_order_bottom_to_top']:
        kind = p.split('/')[1] if p.startswith('animation/') else None
        if kind:
            fmt = (lambda t: p.replace('fXX', f'f{t:02d}')) if 'fXX' in p else (lambda t: p.replace('fX', f'f{t}'))
            stack.append({'id': Path(p).stem.replace('FGF1_', '').rsplit('_f', 1)[0], 'ticks': ticks[kind],
                          'frames': [uri(O / fmt(t)) for t in range(counts[kind])]})
        else:
            stack.append({'id': Path(p).stem.replace('FGF1_', ''), 'ticks': 60, 'frames': [uri(O / p)]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack,
            'collisions': uri(O / 'review/FGF1_collisions_marqueurs.png'),
            'entry': M['access']['entry_px'], 'objectif': M['access']['objectif_px'], 'boss': M['access']['boss_px']}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    (R / 'apercu_fin_grotte_fleurie_v1.html').write_text(page)
    for p in [O / 'FGF1_projet_pmdo_0812.zip', O / 'FGF1_calques_png_8px.zip', R / 'apercu_fin_grotte_fleurie_v1.html']:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
