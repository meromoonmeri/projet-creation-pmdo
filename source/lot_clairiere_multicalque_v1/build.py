"""Lot Clairière multicalque (LCM1) : 5 cartes 4:3 de 768 x 576 px, grille de 8 px, calques PNG transparents + ORA.

Demande : « fait 5 map par lot multicalque début chemin fin etc » (20 octobre 2026).
Sources : décors générés en référence à `large.S01P03A...png` (clairière tropicale, rip), stockés dans bruts/.
Méthode : rendu généré référencé. Les pixels générés NE SONT PAS des tuiles natives : la classification
par couleur sert à séparer les calques, puis chaque case de 8 px reçoit la classe majoritaire.

Calques (du bas vers le haut) : 00 sol (herbe), 01 chemin (galets), 02 eau (mer et ponton posé sur l'eau),
03 roches (falaise, tertre), 04 végétation (haies, palmiers), 05 fleurs, 06 grotte (bouche sombre).
Lancer : .venv/bin/python source/lot_clairiere_multicalque_v1/build.py
"""
from pathlib import Path
import io, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
OUT = R / 'renders/lot_clairiere_multicalque_v1'
W, H = 768, 576
CLASSES = ['sol', 'chemin', 'eau', 'roche', 'vegetation', 'fleurs', 'grotte']
MAPS = [
    ('LCM1-01', 'debut_ponton', 'm1_debut_ponton.png', 'Début : ponton sur la mer'),
    ('LCM1-02', 'chemin', 'm2_chemin.png', 'Chemin de galets'),
    ('LCM1-03', 'arene', 'm3_arene.png', 'Clairière, arène'),
    ('LCM1-04', 'passage', 'm4_passage.png', 'Passage étroit'),
    ('LCM1-05', 'fin_grotte', 'm5_fin_grotte.png', 'Fin : grotte du tertre'),
]


def fit(img):
    """Mise à l'échelle 4:3 : hauteur 576, recadrage centré à 768 (aucun rééchantillonnage pixel à pixel)."""
    w, h = img.size
    s = H / h
    img = img.resize((round(w * s), H), Image.BOX)
    x0 = (img.width - W) // 2
    return img.crop((x0, 0, x0 + W, H))


def classify(a):
    r, g, b = [a[..., i].astype(int) for i in range(3)]
    lum = (r + g + b) / 3
    mx, mn = np.maximum(np.maximum(r, g), b), np.minimum(np.minimum(r, g), b)
    cls = np.full(r.shape, 0, np.uint8)                          # défaut : sol / herbe
    green = (g > r + 12) & (g > b + 30)
    sat = (mx - mn) > 60
    cls[green & (lum < 150)] = CLASSES.index('vegetation')
    cls[sat & ~green & (b > 150) & (g < 150) & (r < 120)] = CLASSES.index('eau')
    # Galets (251, 225, 150) et bois du ponton (239, 187, 112) : beige clair, chroma <= 130.
    cls[(r > 200) & (g > 170) & (b > 100) & (r - b > 35) & (mx - mn <= 130)] = CLASSES.index('chemin')
    # Falaise et tertre (146, 115, 75) ; rocher sombre (101, 84, 54) reste sol-ombre faute de règle dédiée.
    cls[(r > 130) & (r - b > 60) & (g < r - 25) & (lum < 175) & ~green] = CLASSES.index('roche')
    cls[(lum < 60) & ~green] = CLASSES.index('grotte')
    # Fleurs : rouge, jaune, cyan, rose vifs (chroma >= 150, ou bleu dominant hors mer).
    flower = (~green) & (~((b > 150) & (g < 150) & (r < 120))) & (lum > 60) & (((mx - mn) >= 150) | ((b > r) & (b > g) & (b - r > 40)))
    cls[flower] = CLASSES.index('fleurs')
    cls[(g > 200) & (cls == CLASSES.index('vegetation')) & (lum > 120)] = 0   # herbe claire
    cls[(mn >= 170) & (b >= r)] = CLASSES.index('eau')                       # écume et crêtes blanches de la mer
    return cls


def snap(cls):
    """Chaque case de 8 x 8 prend la classe majoritaire (grille de tuiles de 8 px)."""
    gh, gw = H // 8, W // 8
    blocks = cls.reshape(gh, 8, gw, 8).transpose(0, 2, 1, 3).reshape(gh, gw, 64)
    counts = np.stack([(blocks == i).sum(-1) for i in range(len(CLASSES))], -1)
    return counts.argmax(-1), counts


def layers_from(cell, rgb):
    """Un calque par classe : pixels de la case majoritaire, couleurs du décor, alpha 255 ou 0."""
    out = {}
    full = np.kron(cell, np.ones((8, 8), np.uint8))
    for i, nm in enumerate(CLASSES):
        m = full == i
        a = np.zeros((H, W, 4), np.uint8)
        a[..., :3] = rgb
        a[..., 3] = np.where(m, 255, 0)
        out[nm] = a
    return out


def write_ora(path, layers, name):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name=name)
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    items = list(layers.items())
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        for i, (nm, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=nm, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def build():
    (OUT).mkdir(parents=True, exist_ok=True)
    manifest = {'lot': 'LCM1', 'format': '4:3, 768 x 576 px, 96 x 72 cases de 8 px', 'maps': []}
    for code, slug, src, title in MAPS:
        img = fit(Image.open(RAW / src).convert('RGB'))
        rgb = np.asarray(img)
        cls = classify(rgb)
        cell, counts = snap(cls)
        layers = layers_from(cell, rgb)
        d = OUT / f'{code}_{slug}'
        (d / 'calques').mkdir(parents=True, exist_ok=True)
        for i, nm in enumerate(CLASSES):
            Image.fromarray(layers[nm]).save(d / 'calques' / f'{code}_{i:02d}_{nm}.png')
        write_ora(d / f'{code}_{slug}.ora', {f'{i:02d} {nm}': layers[nm] for i, nm in enumerate(CLASSES)}, f'{code} {title}')
        Image.fromarray(rgb).save(d / f'{code}_recomposition_source.png')
        shares = {nm: round(float((cell == i).mean()), 3) for i, nm in enumerate(CLASSES)}
        manifest['maps'].append({'code': code, 'slug': slug, 'titre': title, 'source': f'bruts/{src}',
                                 'part_des_cases': shares, 'calques': CLASSES})
    (OUT / 'manifest.json').write_text(__import__('json').dumps(manifest, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    build()
