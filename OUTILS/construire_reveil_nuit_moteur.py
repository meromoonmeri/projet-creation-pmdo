#!/usr/bin/env python3
"""Construit la map « le réveil de nuit » (cinématique post-quiz, PMD Destiny).

* ``quest_pmd_destiny/Content/BG/Reveil_Nuit.dir`` — fond nocturne procédural
  (ciel indigo étoilé, lune et son halo, collines sombres, herbe nocturne,
  lucioles) dessiné en numpy/PIL. Format natif :
  ``[i64 png_len][PNG][i32 w][i32 h][i32 0][i32 1]``.
* ``quest_pmd_destiny/Data/Ground/reveil_nuit.rsground`` — map de la
  cinématique (320×240), dérivée de ``personality_test.rsground`` : fond
  Reveil_Nuit, conservant le spawner Teammate1 (le partenaire) et les
  marqueurs. Scénario : Data/Script/destiny/ground/reveil_nuit/init.lua.
  Honnêteté : runtime_tested false.

Usage : .venv/bin/python OUTILS/construire_reveil_nuit_moteur.py
"""
from __future__ import annotations

import copy
import io
import json
import struct
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

R = Path(__file__).resolve().parents[1]
BG = R / 'quest_pmd_destiny' / 'Content' / 'BG'
GROUND = R / 'quest_pmd_destiny' / 'Data' / 'Ground'


def dessiner_reveil_nuit(w: int = 320, h: int = 240) -> Image.Image:
    """Clairière de nuit : ciel étoilé, lune, collines, herbe, lucioles."""
    rng = np.random.default_rng(20261028)
    img = np.zeros((h, w, 3), np.float32)

    # ciel : dégradé indigo → bleu-violet profond vers l'horizon
    yy = np.linspace(0, 1, h)[:, None]
    for c, (haut, bas) in enumerate([(14, 18), (16, 32), (48, 84)]):
        img[..., c] = haut + (bas - haut) * (yy ** 1.3)

    # étoiles
    n = rng.integers(120, 160)
    xs = rng.integers(0, w, n)
    ys = rng.integers(0, int(h * 0.72), n)
    lum = rng.uniform(0.35, 1.0, n)
    for x, y, l in zip(xs, ys, lum):
        img[y, x] = np.clip(img[y, x] + l * 210, 0, 255)
    for _ in range(8):  # grosses étoiles qui brillent
        x, y = int(rng.integers(0, w)), int(rng.integers(0, h * 0.5))
        img[max(0, y - 1):y + 2, max(0, x - 1):x + 2] = 232

    # lune (disque) + halo
    cx, cy, rayon = 242, 52, 17
    yy2, xx2 = np.mgrid[0:h, 0:w]
    dist = np.sqrt((xx2 - cx) ** 2 + (yy2 - cy) ** 2)
    halo = np.exp(-((dist / 52.0) ** 2)) * 0.42
    img += halo[..., None] * np.array([210, 215, 255])
    lune = dist <= rayon
    img[lune] = [235, 232, 210]
    # cratères discrets
    for _ in range(6):
        ang, r2 = rng.uniform(0, 6.28, 2)
        r2 = r2 * rayon * 0.5
        ccx, ccy = int(cx + np.cos(ang) * r2), int(cy + np.sin(ang) * r2)
        m = dist <= rayon
        dd = (xx2 - ccx) ** 2 + (yy2 - ccy) ** 2
        img[m & (dd < 20)] = [196, 192, 172]

    # collines : deux silhouettes douces
    for base, ampl, teinte in [(168, 10, (16, 22, 46)), (182, 7, (12, 16, 34))]:
        onde = base + ampl * np.sin(np.linspace(0, 3.1, w) * 1.4 + base)
        for x in range(w):
            img[int(onde[x]):, x] = teinte

    # herbe nocturne
    herbe = 200
    img[herbe:] = (10, 16, 28)
    bruit = rng.uniform(-3, 5, (h - herbe, w))
    img[herbe:, :, 1] += bruit * 0.8
    for _ in range(140):  # brins d'herbe
        x = int(rng.integers(0, w))
        y0 = int(rng.integers(herbe, h - 2))
        longueur = int(rng.integers(2, 7))
        img[y0:y0 + longueur, x] = (18, 30, 42)

    # lucioles
    for _ in range(9):
        x, y = int(rng.integers(8, w - 8)), int(rng.integers(herbe - 34, h - 8))
        img[y, x] = [255, 236, 150]

    out = Image.fromarray(np.clip(img, 0, 255).astype(np.uint8), 'RGB')
    # léger flou sur les halos seulement : conv simple du résultat
    return out.filter(ImageFilter.GaussianBlur(0.4))


def ecrire_dir(png: Image.Image, sortie: Path) -> None:
    buf = io.BytesIO()
    png.save(buf, 'PNG')
    data = buf.getvalue()
    w, h = png.size
    sortie.write_bytes(struct.pack('<q', len(data)) + data +
                       struct.pack('<4i', w, h, 0, 1))
    print(f'  {sortie.name} : {w}x{h}, 1 frame, {sortie.stat().st_size} o')


def main() -> int:
    BG.mkdir(parents=True, exist_ok=True)
    GROUND.mkdir(parents=True, exist_ok=True)

    ecrire_dir(dessiner_reveil_nuit(), BG / 'Reveil_Nuit.dir')

    modele = GROUND / 'personality_test.rsground'
    if not modele.exists():
        print(f'  (!) modèle absent : {modele}')
        return 1
    d = json.loads(modele.read_text(encoding='utf-8-sig'))
    o = d['Object']

    o['AssetName'] = 'reveil_nuit'
    o['Name'] = {'DefaultText': 'Réveil de nuit — Clairière sous la lune',
                 'LocalTexts': {'fr': 'Réveil de nuit — Clairière sous la lune'}}
    o['Comment'] = ("Cinématique « le réveil de nuit » : le héros se réveille "
                    "sans souvenirs dans une clairière nocturne ; le partenaire "
                    "le trouve et l'entraîne vers la ville. Scénario : "
                    "Data/Script/destiny/ground/reveil_nuit/init.lua.")

    couches = o['Background']['Layers']
    gabarit = copy.deepcopy(couches[0])
    bg = gabarit['BG'] if 'BG' in gabarit else gabarit
    bg['MapLoc'] = {'X': 0, 'Y': 0}
    bg['BGAnim']['AnimIndex'] = 'Reveil_Nuit'
    bg['BGAnim']['Alpha'] = 255
    bg['BGAnim']['FrameTime'] = 8
    bg['BGMovement'] = {'X': 0, 'Y': 0}
    bg['Parallax'] = '0, 0'
    bg['RepeatX'] = False
    bg['RepeatY'] = False
    o['Background']['Layers'] = [gabarit]

    out = GROUND / 'reveil_nuit.rsground'
    out.write_text(json.dumps(d, ensure_ascii=False, indent=1),
                   encoding='utf-8-sig')
    print(f'  reveil_nuit.rsground : {out.stat().st_size} o '
          f'(dérivé de personality_test.rsground)')
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
