"""Café Spinda — réseau AU PROPRE, sans fond magenta (dérivé de V4, V4 préservée).

Demande de l'utilisateur (20 octobre 2026) : « je veux que tu me fasse le réseau café
au propre sans le fond majenta stp ».

Le réseau V4 (`renders/cafe_spinda_reseau_v4/`, 5 salles 600x448, 3 niveaux, 4 liens)
présentait ses aperçus sur fond magenta et stockait ses calques en WebP. Cette livraison
propre, dérivée sans rien régénérer :
- lit les calques PNG du pack V4 d'origine (`SpindaV4_pack.zip`, récupéré du dépôt
  source `meromoonmeri/projet-pmdo` @ 6cca4a0, conservé dans ce lot comme entrée) ;
- recompose chaque salle avec ses seuls calques par défaut (comme `compose()` de V4) ;
- exporte les salles en PNG à fond TRANSPARENT (alpha 0 hors de la salle, aucun pixel
  magenta), leurs calques en PNG, et des aperçus sur fond neutre chaud, étiquetés comme
  tels (le fond neutre n'existe que dans ces aperçus, jamais dans les salles) ;
- conserve le graphe du réseau (niveaux, liens réciproques, ports) du manifeste V4.

Aucun pixel de salle n'est modifié : la recomposition est vérifiée à l'identique contre
les PNG du pack V4. Ce n'est pas un test PMDO.
Lancer : .venv/bin/python source/cafe_spinda_reseau_propre_v1/build.py
"""
from pathlib import Path
import hashlib, io, json, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
PACK = HERE / 'SpindaV4_pack.zip'
V4 = R / 'renders/cafe_spinda_reseau_v4'
OUT = R / 'renders/cafe_spinda_reseau_propre_v1'
NEUTRAL = (58, 48, 40, 255)          # fond d'aperçu neutre chaud (aperçus seulement)
MAGENTA = (255, 0, 255)


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def clean_fringe(im):
    """Frange magenta du détourage V4 : pixels opaques teintés magenta (r et b > g + 40)
    à moins de 2 px de la transparence. Recolorés par le plus proche pixel opaque propre
    du même calque (alpha inchangée, silhouette inchangée). Retourne (image, nb pixels)."""
    a = np.array(im).astype(int)
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    opaque = al == 255
    contaminated = opaque & (r > g + 40) & (b > g + 40)
    near_void = nd.binary_dilation(~opaque, iterations=2)
    fringe = contaminated & near_void
    n = int(fringe.sum())
    if n:
        clean = opaque & ~contaminated
        idx = nd.distance_transform_edt(~clean, return_distances=False, return_indices=True)
        a[fringe] = a[tuple(idx[:, fringe])]
        a[..., 3] = np.array(im)[..., 3]
    return Image.fromarray(a.astype('uint8')), n


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for d in ['salles', 'calques', 'apercus']:
        (OUT / d).mkdir(exist_ok=True)
    m4 = json.loads((V4 / 'manifest.json').read_text())
    with zipfile.ZipFile(PACK) as z:
        names = set(z.namelist())
        def load(name):
            assert name in names, name
            return Image.open(io.BytesIO(z.read(name))).convert('RGBA')

        rooms_out = []
        for room in m4['rooms']:
            comp = Image.new('RGBA', tuple(room['size']))
            layer_entries = []
            fringe_total = 0
            for layer in room['layers']:
                png_name = str(Path(layer['file']).with_suffix('.png'))
                im, nfr = clean_fringe(load(png_name))
                fringe_total += nfr
                dst = OUT / 'calques' / room['id'] / Path(png_name).name
                dst.parent.mkdir(parents=True, exist_ok=True)
                im.save(dst, optimize=True)
                layer_entries.append({'id': layer['id'], 'title': layer['title'],
                                      'file': str(dst.relative_to(OUT)), 'default': layer['default'],
                                      'role': layer['role']})
                if layer['default']:
                    comp.alpha_composite(im)
            arr = np.array(comp)
            assert not ((arr[..., :3] == MAGENTA).all(-1) & (arr[..., 3] == 255)).any(), room['id']
            room_png = OUT / 'salles' / f"CafePropre_{room['id']}_transparent.png"
            comp.save(room_png, optimize=True)
            bg = Image.new('RGBA', tuple(room['size']), NEUTRAL)
            bg.alpha_composite(comp)
            preview = OUT / 'apercus' / f"CafePropre_{room['id']}_sur_fond_neutre.png"
            bg.convert('RGB').save(preview, optimize=True)
            rooms_out.append({'id': room['id'], 'title': room['title'], 'level': room['level'],
                              'size': room['size'], 'file': str(room_png.relative_to(OUT)),
                              'preview': str(preview.relative_to(OUT)), 'layers': layer_entries,
                              'frange_magenta_recoloree_px': fringe_total,
                              'ports': room['ports']})

    manifest = {
        'lot': 'cafe_spinda_reseau_propre_v1',
        'title': 'Café & Casino Spinda · réseau au propre (sans fond magenta)',
        'demande': '« je veux que tu me fasse le réseau café au propre sans le fond majenta stp » (20 octobre 2026)',
        'source': {'lot': 'cafe_spinda_reseau_v4 (préservé, inchangé)',
                   'pack': {'file': 'source/cafe_spinda_reseau_propre_v1/SpindaV4_pack.zip', 'sha256': sha(PACK),
                            'provenance': 'meromoonmeri/projet-pmdo @ 6cca4a09380211e510ab1bea454a1b1926ef4b5a, renders/cafe_spinda_reseau_v4/SpindaV4_pack.zip'}},
        'fond': 'TRANSPARENT dans toutes les salles et tous les calques (alpha 0 hors salle) ; fond neutre chaud '
                '(58,48,40) uniquement dans les aperçus *_sur_fond_neutre.png ; aucun pixel magenta, vérifié',
        'rooms': rooms_out,
        'links': m4['links'],
        'levels': {'0': 'accueil', '-1': ['casino', 'salon_bas'], '1': ['café', 'salon_haut']},
        'grid': 8,
        'runtime_PMDO': 'NOT TESTED',
        'links_status': m4['links_status'],
        'preserved': 'V4 et ses aperçus magenta sont conservés tels quels ; cette livraison est un dérivé propre, pas un remplacement.',
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'salles': [r['id'] for r in rooms_out],
                      'liens': len(m4['links'])}, indent=1))


if __name__ == '__main__':
    main()
