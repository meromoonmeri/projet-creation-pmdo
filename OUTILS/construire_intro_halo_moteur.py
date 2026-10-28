#!/usr/bin/env python3
"""Construit les assets moteur de l'intro « halo arc-en-ciel » (PMD Destiny).

À partir des pièces dessinées par OUTILS/generer_intro_halo_arcenciel.py
(dans apercus/intro_halo/, textures de Pokémon Relict recolorées) :

* ``quest_pmd_destiny/Content/BG/Halo_{Fond,Anneau,Shine}.dir`` — sprites BG
  du moteur. Format natif décodé (identique aux .tile) :
  ``[i64 png_len][PNG][i32 frame_w][i32 frame_h][i32 0][i32 frame_count]``.
* ``quest_pmd_destiny/Data/Ground/intro_halo.rsground`` — map d'intro
  (320×240), dérivée de ``personality_test.rsground`` (JSON utf-8-sig,
  sérialisation RogueEssence.Ground.GroundMap) : fond halo, musique
  « Welcome to the World of Pokémon!.ogg », sans spawner.

Chaîne de démarrage (voir Data/StartParams.xml) : zone personality_test,
ground 1 = intro_halo → titres voice-over → transition blanche « dans le
halo » → ground 0 = personality_test (fonds Dream_Back/Dream_Front).
Honnêteté : runtime_tested false.

Usage : .venv/bin/python OUTILS/construire_intro_halo_moteur.py
"""
from __future__ import annotations

import copy
import json
import struct
from pathlib import Path

import numpy as np
from PIL import Image

R = Path(__file__).resolve().parents[1]
SRC = R / 'apercus' / 'intro_halo'
BG = R / 'quest_pmd_destiny' / 'Content' / 'BG'
GROUND = R / 'quest_pmd_destiny' / 'Data' / 'Ground'


def ecrire_dir(png: Image.Image, sortie: Path) -> None:
    """Écrit un sprite .dir natif : [i64 png_len][PNG][(w, h, 0, 1)]."""
    import io
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

    # ---- sprites BG du moteur
    for nom_src, nom_out, taille in [
            ('halo_fond.png', 'Halo_Fond.dir', (320, 240)),
            ('halo_anneau.png', 'Halo_Anneau.dir', (240, 240)),
            ('halo_shine.png', 'Halo_Shine.dir', (160, 160))]:
        src = SRC / nom_src
        if not src.exists():
            print(f'  (!) pièce absente : {src} — lancer generer_intro_halo_arcenciel.py')
            return 1
        im = Image.open(src).convert('RGBA').resize(taille, Image.LANCZOS)
        ecrire_dir(im, BG / nom_out)

    # ---- map intro_halo dérivée de personality_test
    modele = GROUND / 'personality_test.rsground'
    if not modele.exists():
        print(f'  (!) modèle absent : {modele}')
        return 1
    d = json.loads(modele.read_text(encoding='utf-8-sig'))
    o = d['Object']

    o['AssetName'] = 'intro_halo'
    o['Name'] = {'DefaultText': 'Intro Halo Arc-en-ciel',
                 'LocalTexts': {'fr': 'Intro halo arc-en-ciel'}}
    o['Comment'] = ("Map d'intro de la quest : halo arc-en-ciel (BG Halo_Fond/"
                    "Halo_Anneau/Halo_Shine, textures Pokémon Relict recolorées) "
                    "qui pulse par fondus moteur, titres voice-over blancs, "
                    "puis transition blanche vers personality_test.")

    # fonds : 3 couches statiques (le pulse vient des fondus du moteur)
    couches = o['Background']['Layers']
    gabarit = copy.deepcopy(couches[0])
    def couche(index: str, x: int, y: int, alpha: int):
        c = copy.deepcopy(gabarit)
        bg = c['BG'] if 'BG' in c else c
        bg['MapLoc'] = {'X': x, 'Y': y}
        bg['BGAnim']['AnimIndex'] = index
        bg['BGAnim']['Alpha'] = alpha
        bg['BGAnim']['FrameTime'] = 8
        bg['BGMovement'] = {'X': 0, 'Y': 0}
        bg['Parallax'] = '0, 0'
        bg['RepeatX'] = False
        bg['RepeatY'] = False
        return c
    o['Background']['Layers'] = [
        couche('Halo_Fond', 0, 0, 255),
        couche('Halo_Anneau', 40, 0, 255),
        couche('Halo_Shine', 80, 40, 255),
    ]

    # entités : aucune (le marqueur d'entrée est conservé)
    for cou in o['Entities']:
        cou['MapChars'] = []
        cou['GroundObjects'] = []
        cou['Spawners'] = []

    # la musique reste « Welcome to the World of Pokémon!.ogg » (champ Music)
    out = GROUND / 'intro_halo.rsground'
    out.write_text(json.dumps(d, ensure_ascii=False, indent=1),
                   encoding='utf-8-sig')
    print(f'  intro_halo.rsground : {out.stat().st_size} o '
          f'(dérivé de personality_test.rsground)')
    print('Terminé.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
