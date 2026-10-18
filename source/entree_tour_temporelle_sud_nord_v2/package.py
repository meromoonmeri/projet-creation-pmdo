"""Vérifie le build, puis fabrique les ZIP PMDO/calques et l'aperçu interactif.

.venv/bin/python source/entree_tour_temporelle_sud_nord_v2/package.py
"""
from pathlib import Path
import json
import subprocess
import sys
import zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = 'entree_tour_temporelle_sud_nord_v2'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / LOT
ZIP = R / '.cache' / LOT / f'mod_{LOT}_pmdo_0812.zip'
ZIP_RENDER = OUT / 'ETT2_projet_pmdo_0812.zip'
ZIP_LAYERS = OUT / 'ETT2_calques_png_8px.zip'
HTML = R / f'apercu_{LOT}.html'
ANIMATION_PNG_COUNT = 48 + 24 + 24 + 16 + 24 + 24
STATIC_PNG_COUNT = 8
REVIEW_FILES = (
    'review/ETT2_scene_t000.png',
    'review/ETT2_scene_animee.webp',
    'review/ETT2_collisions_marqueurs.png',
    'review/ETT2_zoom_portail_breches.png',
)


def build_project_zip():
    if not STAGE.is_dir():
        raise FileNotFoundError(f"Staging Ground absent : exécuter d'abord {HERE / 'build.py'}")
    # Le README peut évoluer sans devoir reconstruire tous les tilesets et animations.
    (STAGE / 'README.md').write_bytes((HERE / 'README_PACK.md').read_bytes())

    for zpath in (ZIP, ZIP_RENDER):
        zpath.parent.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
            for p in sorted(STAGE.rglob('*')):
                if p.is_file():
                    z.write(p, f'{LOT}/{p.relative_to(STAGE).as_posix()}')

    required = {
        f'{LOT}/Mod.xml',
        f'{LOT}/INSTALLER.py',
        f'{LOT}/README.md',
        f'{LOT}/Data/Ground/ett2_entree_tour_temporelle_noire_or.rsground',
        f'{LOT}/Content/Tile/index.idx',
    }
    with zipfile.ZipFile(ZIP) as z:
        names = set(z.namelist())
        missing = required - names
        assert not missing, f'fichiers manquants dans le ZIP PMDO : {sorted(missing)}'
        assert sum(n.endswith('.tile') for n in names) == 14
        assert z.testzip() is None, 'archive du projet PMDO corrompue'


def build_layers_zip():
    items = []
    for folder in ('calques', 'animation', 'masques'):
        root = OUT / folder
        if not root.is_dir():
            raise FileNotFoundError(f"Sorties {folder}/ absentes : exécuter d'abord build.py")
        items.extend((p, p.relative_to(OUT).as_posix()) for p in sorted(root.rglob('*.png')))

    items.extend((OUT / name, name) for name in REVIEW_FILES)
    items.extend((
        (OUT / 'ETT2_entree_tour_temporelle_v2_calques.ora', 'ETT2_entree_tour_temporelle_v2_calques.ora'),
        (OUT / 'manifest.json', 'manifest.json'),
        (HERE / 'README_PACK.md', 'README_PACK.md'),
    ))
    for p, _ in items:
        if not p.is_file():
            raise FileNotFoundError(f'élément du pack de calques absent : {p}')

    ZIP_LAYERS.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(ZIP_LAYERS, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arcname in items:
            z.write(src, arcname)

    layer_pngs = list((OUT / 'calques').glob('*.png'))
    animation_pngs = list((OUT / 'animation').rglob('*.png'))
    assert len(layer_pngs) == STATIC_PNG_COUNT
    assert len(animation_pngs) == ANIMATION_PNG_COUNT
    with zipfile.ZipFile(ZIP_LAYERS) as z:
        names = set(z.namelist())
        assert len(names) == len(items), 'noms dupliqués dans le ZIP de calques'
        assert len([n for n in names if n.startswith('calques/') and n.endswith('.png')]) == STATIC_PNG_COUNT
        assert len([n for n in names if n.startswith('animation/') and n.endswith('.png')]) == ANIMATION_PNG_COUNT
        assert 'ETT2_entree_tour_temporelle_v2_calques.ora' in names
        assert 'manifest.json' in names and 'README_PACK.md' in names
        assert z.testzip() is None, 'archive de calques corrompue'


def build_html():
    m = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
    walk_path = OUT / 'masques/ETT2_masque_praticable.png'
    with Image.open(walk_path) as im:
        walk = np.array(im) > 0
    blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > 0.25
    by, bx = np.nonzero(blocked)
    banks = m['pmdo']['banks']
    tiles = m['pmdo']['tiles_per_bank']
    layers = []
    for i, entry in enumerate(m['layers']):
        rel = entry['file']
        phase_count = entry['phases']
        ticks = entry['ticks']
        stem = Path(rel).stem.replace('_fNN', '')
        sources = (
            [f'renders/{LOT}/{rel.replace("_fNN.png", f"_f{t:02d}.png")}' for t in range(phase_count)]
            if phase_count > 1 else [f'renders/{LOT}/{rel}']
        )
        for source in sources:
            if not (R / source).is_file():
                raise FileNotFoundError(f'aperçu incomplet, image de calque absente : {source}')
        layers.append({
            'id': stem,
            'label': stem.replace('ETT2_', '').replace('_', ' '),
            'srcs': sources,
            'ticks': ticks,
            'tiles': tiles[banks[i]],
        })

    spec = {
        'layers': layers,
        'loop_ticks': m['scene_loop_ticks'],
        'palette': m['controle_palette']['mesures'],
        'palette_threshold': m['controle_palette']['seuil'],
        'blocked': [[int(x), int(y)] for y, x in zip(by, bx)],
        'entry': m['access']['entry_px'],
        'threshold': m['access']['threshold_px'],
    }
    template = (HERE / 'viewer_template.html').read_text(encoding='utf-8')
    HTML.write_text(template.replace('__SPEC_JSON__', json.dumps(spec, separators=(',', ':'))), encoding='utf-8')


def main():
    subprocess.run(
        [sys.executable, '-m', 'unittest', 'source.entree_tour_temporelle_sud_nord_v2.test_build', '-v'],
        cwd=R,
        check=True,
    )
    build_project_zip()
    build_layers_zip()
    build_html()
    for path in (ZIP_RENDER, ZIP_LAYERS, HTML):
        print(f'{path.relative_to(R)} — {path.stat().st_size / 1024:.0f} Ko')


if __name__ == '__main__':
    main()
