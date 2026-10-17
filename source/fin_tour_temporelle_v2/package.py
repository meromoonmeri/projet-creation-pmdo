"""Apercu HTML interactif et archive ZIP du mod PMDO 0.8.12 pour Fin Tour Temporelle V2 (FTT2).

.venv/bin/python source/fin_tour_temporelle_v2/package.py
"""
from pathlib import Path
import json, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = 'fin_tour_temporelle_v2'
OUT = R / 'renders' / LOT
STAGE = R / '.cache' / LOT / 'fin_tour_temporelle_v2'
ZIP = R / '.cache' / LOT / 'mod_fin_tour_temporelle_v2_pmdo_0812.zip'
ZIP_RENDER = OUT / 'FTT2_projet_pmdo_0812.zip'
HTML = R / 'apercu_fin_tour_temporelle_v2.html'


def build_zip():
    for zpath in (ZIP, ZIP_RENDER):
        with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED) as z:
            for p in sorted(STAGE.rglob('*')):
                if p.is_file():
                    z.write(p, f'fin_tour_temporelle_v2/{p.relative_to(STAGE).as_posix()}')
    with zipfile.ZipFile(ZIP) as z:
        names = set(z.namelist())
        for req in [
            'fin_tour_temporelle_v2/Mod.xml',
            'fin_tour_temporelle_v2/INSTALLER.py',
            'fin_tour_temporelle_v2/README.md',
            'fin_tour_temporelle_v2/Data/Ground/ftt2_fin_tour_temporelle_noire_or.rsground',
            'fin_tour_temporelle_v2/Content/Tile/index.idx',
        ]:
            assert req in names, req
        assert sum(n.endswith('.tile') for n in names) == 13


def build_html():
    m = json.loads((OUT / 'manifest.json').read_text())
    walk = np.array(Image.open(OUT / 'masques/FTT2_masque_praticable.png')) > 0
    blk = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > 0.25
    by, bx = np.nonzero(blk)
    banks = m['pmdo']['banks']
    tiles = m['pmdo']['tiles_per_bank']
    layers = []
    for i, entry in enumerate(m['layers']):
        rel = entry['file']
        n = entry['phases']
        tk = entry['ticks']
        stem = Path(rel).stem.replace('_fNN', '')
        srcs = (
            [f'renders/{LOT}/{rel.replace("_fNN.png", f"_f{t:02d}.png")}' for t in range(n)]
            if n > 1 else [f'renders/{LOT}/{rel}']
        )
        layers.append({
            'id': stem,
            'label': stem.replace('FTT2_', '').replace('_', ' '),
            'srcs': srcs,
            'ticks': tk,
            'tiles': tiles[banks[i]],
        })
    spec = {
        'layers': layers,
        'loop_ticks': m['scene_loop_ticks'],
        'fidelite': m['fidelite_rip']['mesures'],
        'seuil': m['fidelite_rip']['seuil'],
        'blocked': [[int(x), int(y)] for y, x in zip(by, bx)],
        'entry': m['access']['entry_px'],
        'boss': m['access']['boss_px'],
        'objectif': m['access']['objectif_px'],
    }
    tpl = (HERE / 'viewer_template.html').read_text()
    HTML.write_text(tpl.replace('__SPEC_JSON__', json.dumps(spec, separators=(',', ':'))))


if __name__ == '__main__':
    build_zip()
    build_html()
    print(f'OK {ZIP.name} ({ZIP.stat().st_size // 1024} Ko) + {HTML.name}')
