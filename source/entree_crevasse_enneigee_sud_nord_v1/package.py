"""Tests ECE1 -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/entree_crevasse_enneigee_sud_nord_v1/package.py   (après build.py)
"""
from pathlib import Path
import base64, json, re, subprocess, sys, zipfile

from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_crevasse_enneigee_sud_nord_v1'
S = R / '.cache/entree_crevasse_enneigee_sud_nord_v1/entree_crevasse_enneigee_sud_nord'
PFX = 'ECE1'
ANIMS = ['scintillements', 'flocons']
REVIEW = ['scene_t000.png', 'scene_animee.webp', 'collisions_marqueurs.png', 'planche_poses.png']
PAGE = R / 'apercu_entree_crevasse_enneigee_sud_nord_v1.html'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri(p, mime='image/png'):
    return f'data:{mime};base64,' + base64.b64encode(Path(p).read_bytes()).decode()


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_crevasse_enneigee_sud_nord_v1.test_build'], cwd=R, check=True)
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip',
           [(p, 'entree_crevasse_enneigee_sud_nord/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIMS:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses/' + p.name) for p in sorted((O / 'poses').glob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    items += [(O / f'{PFX}_entree_crevasse_enneigee_calques.ora', f'{PFX}_entree_crevasse_enneigee_calques.ora'),
              (O / 'manifest.json', 'manifest.json'), (O / 'README.md', 'README.md')]
    items += [(O / 'review' / f'{PFX}_{n}', f'apercu/{PFX}_{n}') for n in REVIEW]
    items += [(HERE / 'references' / n, 'reference_rom/' + n) for n in
              ('D79P11A.png', 'D79P11A_anim.webp', 'provenance.json', 'palette_anim.json')]
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)

    stack = []
    for L in M['layers']:
        name = re.sub(rf'^{PFX}_\d\d_', '', Path(L['file']).stem.replace('_fNN', ''))
        frames = [O / L['file']] if L['phases'] == 1 else [O / L['file'].replace('fNN', f'f{t:02d}') for t in range(L['phases'])]
        stack.append({'id': name, 'ticks': L['ticks'], 'frames': [uri(p) for p in frames]})
    poses = []
    for kind in M['poses']['fenetres']:
        p = O / f'poses/{PFX}_{kind}.png'
        with Image.open(p) as im:
            w, h = im.size
        poses.append({'id': kind, 'uri': uri(p), 'w': w, 'h': h})
    fid = M['fidelite_rip']
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'surface': 'rgb(63,71,119)', 'poses': poses,
            'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png'), 'entry': M['access']['entry_px'],
            'threshold': M['access']['threshold_px'], 'rip': uri(HERE / 'references/D79P11A.png'),
            'ncol': len(M['palette_rip']['couleurs']),
            'fid': {'brut': {k: v['distance'] for k, v in fid['brut'].items()},
                    'calques': {k: v['distance_rip'] for k, v in fid['calques_finaux'].items()}}}
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    PAGE.write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', PAGE]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
