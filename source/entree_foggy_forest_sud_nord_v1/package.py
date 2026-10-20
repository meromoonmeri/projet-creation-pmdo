"""Packaging et aperçu HTML autonome pour Entrée Foggy Forest — Sud -> Nord (EFF1)."""
from pathlib import Path
import base64, importlib.util, json, re, unittest, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


B = loadmod('eff1_build', HERE / 'build.py')
OUT, STAGE, PFX = B.OUT, B.STAGE, B.PFX


def uri(p: Path) -> str:
    return 'data:image/png;base64,' + base64.b64encode(p.read_bytes()).decode()


def zip_dir(src: Path, dst: Path):
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(src.rglob('*')):
            if p.is_file():
                z.write(p, p.relative_to(src.parent))


def zip_png_pack(dst: Path):
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as z:
        for sub in ('calques', 'animation', 'review'):
            for p in sorted((OUT / sub).rglob('*')):
                if p.is_file():
                    z.write(p, p.relative_to(OUT))
        for fn in ('manifest.json', 'README.md', 'EFF1_entree_foggy_forest_calques.ora'):
            p = OUT / fn
            if p.exists():
                z.write(p, fn)


def package():
    suite = unittest.defaultTestLoader.discover(str(HERE), pattern='test_*.py')
    res = unittest.TextTestRunner(verbosity=2).run(suite)
    if not res.wasSuccessful():
        raise SystemExit(1)

    z_pmdo = OUT / f'{PFX}_projet_pmdo_0812.zip'
    z_png = OUT / f'{PFX}_calques_png_8px.zip'
    zip_dir(STAGE, z_pmdo)
    zip_png_pack(z_png)

    m = json.loads((OUT / 'manifest.json').read_text())
    fixed = sorted((OUT / 'calques').glob('*.png'))
    a1_frames = [uri(p) for p in sorted((OUT / 'animation/feuilles_vent').glob('*.png'))]
    a2_frames = [uri(p) for p in sorted((OUT / 'animation/lucioles_brume').glob('*.png'))]

    stack = []
    for p in fixed:
        name = re.sub(rf'^{PFX}_\d\d_', '', p.stem)
        stack.append({'id': name, 'ticks': 60, 'frames': [uri(p)]})
    stack.append({'id': 'feuilles_vent', 'ticks': B.TICKS, 'frames': a1_frames})
    stack.append({'id': 'lucioles_brume', 'ticks': B.TICKS, 'frames': a2_frames})

    data = {
        'size': m['size_px'],
        'loop': m['animations']['scene_loop_ticks'],
        'stack': stack,
        'surface': 'rgb(52,82,42)',
        'collisions': uri(OUT / 'review' / f'{PFX}_collisions_marqueurs.png'),
        'entry': m['access']['entry_px'], 'threshold': m['access']['threshold_px'],
    }
    tpl = (HERE / 'viewer_template.html').read_text()
    html = tpl.replace('__DATA__', json.dumps(data, ensure_ascii=False))
    apercu = R / 'apercu_entree_foggy_forest_sud_nord_v1.html'
    apercu.write_text(html)
    print(z_pmdo.relative_to(R), f'{z_pmdo.stat().st_size / 1e6:.2f} Mo')
    print(z_png.relative_to(R), f'{z_png.stat().st_size / 1e6:.2f} Mo')
    print(apercu.relative_to(R), f'{apercu.stat().st_size / 1e6:.2f} Mo')


if __name__ == '__main__':
    package()
