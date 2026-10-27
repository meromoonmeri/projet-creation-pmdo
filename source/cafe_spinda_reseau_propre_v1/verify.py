"""Vérifications de la livraison propre du réseau café (pixels, pas de moteur).
.venv/bin/python source/cafe_spinda_reseau_propre_v1/verify.py
"""
from pathlib import Path
import io, json, zipfile

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/cafe_spinda_reseau_propre_v1'
MAGENTA = (255, 0, 255)


def load(p):
    return Image.open(p).convert('RGBA')


def main():
    m = json.loads((OUT / 'manifest.json').read_text())
    checks = []
    with zipfile.ZipFile(HERE / 'SpindaV4_pack.zip') as z:
        for room in m['rooms']:
            arr = np.array(load(OUT / room['file']))
            w, h = room['size']
            assert arr.shape == (h, w, 4) and w % 8 == 0 and h % 8 == 0
            opaque = arr[..., 3] == 255
            assert opaque.any() and (~opaque).any(), room['id']          # silhouette + extérieur
            magenta = (arr[..., :3] == MAGENTA).all(-1) & opaque
            assert not magenta.any(), f"magenta dans {room['id']}"
            ai = arr.astype(int)
            fringe = opaque & (ai[..., 0] > ai[..., 1] + 40) & (ai[..., 2] > ai[..., 1] + 40)
            fringe &= nd.binary_dilation(~opaque, iterations=2)
            assert not fringe.any(), f"frange magenta dans {room['id']}: {int(fringe.sum())}"
            assert set(np.unique(arr[..., 3])) <= {0, 255}
            # Recomposition exacte depuis les calques exportés == PNG du pack V4 composés.
            ref = Image.new('RGBA', (w, h))
            comp = Image.new('RGBA', (w, h))
            m4 = {r['id']: r for r in json.loads((R / 'renders/cafe_spinda_reseau_v4/manifest.json').read_text())['rooms']}
            for layer in m4[room['id']]['layers']:
                if layer['default']:
                    name = str(Path(layer['file']).with_suffix('.png'))
                    ref.alpha_composite(Image.open(io.BytesIO(z.read(name))).convert('RGBA'))
            for layer in room['layers']:
                if layer['default']:
                    comp.alpha_composite(load(OUT / layer['file']))
            assert np.array_equal(arr, np.array(comp)), room['id']       # salle == ses calques exportés
            refa = np.array(ref).astype(int)                             # écart vs pack : frange magenta seule
            diff = (np.array(comp).astype(int) != refa).any(-1)
            contaminated = (refa[..., 3] == 255) & (refa[..., 0] > refa[..., 1] + 40) & (refa[..., 2] > refa[..., 1] + 40)
            contaminated &= nd.binary_dilation(refa[..., 3] != 255, iterations=2)
            assert not (diff & ~contaminated).any(), room['id']
            checks.append(f"{room['id']}: transparent, sans magenta, ecart vs pack limite a la frange ({int(diff.sum())} px)")
        for room in m['rooms']:  # aucun calque exporté ne contient de magenta opaque
            for layer in room['layers']:
                a = np.array(load(OUT / layer['file']))
                assert not ((a[..., :3] == MAGENTA).all(-1) & (a[..., 3] == 255)).any(), layer['file']
    assert len(m['links']) == 4
    ids = {r['id'] for r in m['rooms']}
    assert ids == {'accueil', 'casino', 'salon_bas', 'cafe', 'salon_haut'}
    report = {'pass': True, 'checks': checks, 'magenta': 'aucun pixel magenta opaque (salles ni calques)',
              'runtime_PMDO': 'NOT TESTED'}
    (OUT / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=1))


if __name__ == '__main__':
    main()
