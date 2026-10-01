"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine.
.venv/bin/python source/zone_reveil_prairie_horizon_v2/package.py   (après build.py)
"""
from pathlib import Path
import base64, io, json, shutil, subprocess, sys, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/zone_reveil_prairie_horizon_v2'
NS = 'zone_reveil_prairie_horizon_v2'
S = R / '.cache/zone_reveil_prairie_horizon_v2' / NS
PFX = 'ZRV2'
AMB = {'jour': 'J', 'aube': 'A', 'crepuscule': 'C', 'nuit': 'N'}
PAGE = R / 'apercu_zone_reveil_prairie_horizon_v2.html'


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def uri_img(a):
    b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG', optimize=True)
    return 'data:image/png;base64,' + base64.b64encode(b.getvalue()).decode()


def uri(p):
    return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()


def main():
    subprocess.run([sys.executable, '-m', 'unittest', 'source.zone_reveil_prairie_horizon_v2.test_build'], cwd=R, check=True)
    shutil.copyfile(HERE / 'README_PACK.md', O / 'README.md')
    M = json.loads((O / 'manifest.json').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip', [(p, f'{NS}/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, p.relative_to(O).as_posix()) for p in sorted((O / 'calques').rglob('*.png'))]
    items += [(p, p.relative_to(O).as_posix()) for p in sorted((O / 'animation').rglob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    items += [(O / f'{PFX}_zone_reveil_{a}_calques.ora', f'{PFX}_zone_reveil_{a}_calques.ora') for a in AMB]
    items += [(O / 'manifest.json', 'manifest.json'), (O / 'README.md', 'README.md')]
    items += [(p, 'apercu/' + p.name) for p in sorted((O / 'review').iterdir())]
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)
    W, H = M['size_px']
    data = {'size': M['size_px'], 'amb': {}, 'nuages': M['nuages'], 'horizon': M['horizon_y'],
            'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png')}
    strip = uri(O / f'masques/{PFX}_jour_nuages_bande.png')
    for a in AMB:
        segs, acc = [], None
        for x in M['ambiances'][a]['layers']:
            if x['nom'] == 'nuages':                       # la bande défile en JS ; la montagne (dessinée après) la masque
                if acc is not None:
                    segs.append({'type': 'fixe', 'img': uri_img(np.array(acc))}); acc = None
                cols = np.array(Image.open(O / x['file'].replace('fNNN', 'f000')).convert('RGBA'))
                h = M['nuages']['hauteur_px']; band = cols[M['horizon_y'] - h:M['horizon_y']]
                # bande de l'ambiance (période = largeur de l'écran) : phase 0, les pixels masqués par la montagne sont
                # repris de la phase de mi-parcours (bande décalée d'une demi-période)
                N = M['nuages']; ph = N['phases'] // 2; sh = ph * N['pas_px']
                c2 = np.array(Image.open(O / x['file'].replace('fNNN', f'f{ph:03d}')).convert('RGBA'))[M['horizon_y'] - h:M['horizon_y']]
                full = band[:, :N['periode_px']].copy()
                part = np.roll(c2[:, :N['periode_px']], -sh, axis=1); m = (full[..., 3] == 0) & (part[..., 3] > 0); full[m] = part[m]
                assert (full[-1, :, 3] > 0).all()
                segs.append({'type': 'nuages', 'img': uri_img(full)})
                continue
            if x['phases'] == 1:
                im = Image.open(O / x['file']).convert('RGBA')
                if acc is None:
                    acc = Image.new('RGBA', (W, H))
                acc.alpha_composite(im)
            else:
                if acc is not None:
                    segs.append({'type': 'fixe', 'img': uri_img(np.array(acc))}); acc = None
                segs.append({'type': 'anim', 'nom': x['nom'], 'ticks': x['ticks'],
                             'frames': [uri(O / x['file'].replace('fNNN', f'f{t:03d}')) for t in range(x['phases'])]})
        if acc is not None:
            segs.append({'type': 'fixe', 'img': uri_img(np.array(acc))})
        data['amb'][a] = segs
    page = (HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    PAGE.write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', PAGE]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main()
