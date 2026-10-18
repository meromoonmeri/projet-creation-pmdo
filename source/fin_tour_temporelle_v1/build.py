"""Fin Tour Temporelle (FTT1) — zone de fin de donjon noire et or, format 4:3 (768 x 576 px, 96 x 72 cases).

Demande : « CONTINUE les prochaine map » (18 octobre 2026). Après le lot ETT2 (dernier lot de la série), la direction
a été demandée à l'utilisateur, qui a choisi la fin Tour Temporelle (zone de fin de donjon qui suit l'entrée ETT2).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ : decor.png est généré à partir du décor ETT2 exact
(source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png). Ce n'est pas une tuile native.
Calques produits (bas → haut) : sol, murs et rochers, circuits d'or animés (palette cyclique).
Marqueurs : entrance (sud), boss (centre de l'arène), objectif (pied de la porte au nord). Aucun warp, aucune sortie.
Lancer : .venv/bin/python source/fin_tour_temporelle_v1/build.py
"""
from pathlib import Path
import io, json, shutil, zipfile
import xml.etree.ElementTree as ET
from collections import deque

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
OUT = R / 'renders' / 'fin_tour_temporelle_v1'
PFX = 'FTT1'
W, H = 768, 576
GW, GH = W // 8, H // 8
LOOP = 40                                     # 4 phases x 10 ticks
TICKS = 10
MARK = {'entrance': (384, 544), 'boss': (384, 330), 'objectif': (384, 200)}   # (x, y) en px, coin supérieur de 16 × 16
PAS = 16

# Palette : or des circuits et des fissures (cycle : base, clair, vif, clair).
GOLD_GAIN = [1.00, 1.12, 1.25, 1.12]


def load_decor():
    im = Image.open(RAW / 'decor.png').convert('RGB').resize((W, H), Image.LANCZOS)
    return np.array(im).astype(np.uint8)


def classify(a):
    a16 = a.astype(int)
    r, g, b = a16[..., 0], a16[..., 1], a16[..., 2]
    lum = a16 @ np.array([.299, .587, .114])
    mag = (r > 200) & (g < 80) & (b > 200)                                  # fond à retirer
    gold = (r > 150) & (g > 90) & (b < 110) & (r - b > 90) & ~mag            # circuits et fissures d'or
    sol = (~mag) & (~gold) & (lum >= 45) & (lum <= 110) & (np.abs(r - b) < 25)
    murs = (~mag) & (~sol)                                                  # murs, rochers et or (dessous de l'or)
    return {'mag': mag, 'gold': gold, 'sol': sol, 'murs': murs}


def rgba(a, mask):
    out = np.zeros((H, W, 4), np.uint8)
    out[..., :3] = a
    out[..., 3] = np.where(mask, 255, 0)
    return out


def gold_frames(a, gold):
    """Quatre phases : même motif, or qui s'éclaircit puis revient."""
    frames = []
    for gain in GOLD_GAIN:
        f = np.zeros((H, W, 4), np.uint8)
        c = np.clip(a.astype(float) * gain, 0, 255).astype(np.uint8)
        f[..., :3] = c
        f[..., 3] = np.where(gold, 255, 0)
        frames.append(f)
    return frames


def walk_mask(sol):
    """Sol praticable : fermeture morphologique du sol (tons clairs et sombres de l'ardoise), trous remplis,
    puis composante connexe la plus grande. Les rochers et les murs restent bloqués."""
    s = nd.binary_closing(np.pad(sol, 6, mode='edge'), iterations=6)[6:-6, 6:-6]
    s = nd.binary_fill_holes(s)
    s = nd.binary_opening(s, iterations=2)
    lab, n = nd.label(s)
    sizes = nd.sum(s, lab, range(1, n + 1))
    return lab == (int(np.argmax(sizes)) + 1)


def walk_grid(walk):
    """Grille 8 px : cellule praticable si ≥ 50 % de sol praticable."""
    return walk.reshape(GH, 8, GW, 8).mean(axis=(1, 3)) >= 0.5


def bfs(grid, start, goal):
    prev = {start: None}
    q = deque([start])
    while q:
        cur = q.popleft()
        if cur == goal:
            break
        x, y = cur
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if 0 <= n[0] < GW and 0 <= n[1] < GH and grid[n[1], n[0]] and n not in prev:
                prev[n] = cur
                q.append(n)
    if goal not in prev:
        return None
    path, cur = [], goal
    while cur is not None:
        path.append(cur); cur = prev[cur]
    return path[::-1]


def cell_of(px):
    return (px[0] // 8, px[1] // 8)


def write_ora(path, layers):
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Tour Temporelle V1 (FTT1)')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0',
                          visibility='visible', **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def build():
    if OUT.exists():
        shutil.rmtree(OUT)
    (OUT / 'calques').mkdir(parents=True)
    (OUT / 'animation').mkdir()
    a = load_decor()
    m = classify(a)
    sol_full = rgba(a, np.ones((H, W), bool))
    layers = {
        'sol_complet': sol_full,
        'sol': rgba(a, m['sol']),
        'murs_rochers': rgba(a, m['murs']),
    }
    anims = {'circuits_or': gold_frames(a, m['gold'])}
    for name, arr in layers.items():
        Image.fromarray(arr).save(OUT / 'calques' / f'{PFX}_{name}.png')
    for name, frames in anims.items():
        for i, f in enumerate(frames):
            Image.fromarray(f).save(OUT / 'animation' / f'{PFX}_{name}_{i:02d}.png')
    walk = walk_mask(m['sol'])
    grid = walk_grid(walk)
    path = bfs(grid, cell_of(MARK['entrance']), cell_of(MARK['objectif']))
    ora_layers = dict(layers)
    for name, frames in anims.items():
        ora_layers[name] = frames[0]
    write_ora(OUT / f'{PFX}_fin_tour_temporelle.ora', ora_layers)
    manifest = {
        'prefixe': PFX, 'format': [W, H], 'cases': [GW, GH], 'boucle_ticks': LOOP,
        'calques': list(layers.keys()) + list(anims.keys()),
        'marqueurs': {k: list(v) for k, v in MARK.items()},
        'chemin_16_px': None if path is None else len(path),
        'cases_praticables': int(grid.sum()), 'cases_bloquees': int((~grid).sum()),
        'art_approved': False, 'runtime_tested': False,
        'references': {'decor': 'source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png (ETT2)'},
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2))
    return manifest


if __name__ == '__main__':
    print(json.dumps(build(), ensure_ascii=False, indent=2))
