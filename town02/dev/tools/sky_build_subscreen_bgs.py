#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_build_subscreen_bgs.py — matérialise les décors du 2e écran NDS
(back2_SetGround LEVEL_V*/S*) en nappes plein écran PMDO Content/BG/*.dir.

Source : renders pixel-perfect des MAP_BG (bma.to_pil, déjà commités dans
PMD_SKY_EXPLORERS/Renders/<id>/frame_000.png). L'écran NDS fait 256x192 ;
le viewport PMDO 320x240. Le décor est cadré comme sur la NDS :
  * si le render est plus grand que 256x192, on recadre sur la fenêtre
    caméra canonique (camera2_SetPositionMark si connue, sinon centre) ;
  * puis mise à l'échelle x1.25 (256→320) SANS déformation (même ratio
    4:3 que la NDS) — adaptation technique documentée, pas une recomposition.
Nom : Sub_<id> (ex. Sub_v01p03a) — préfixe pour éviter toute collision.

FAIL-CLOSED : décor sans render ROM = listé MISSING, jamais de substitut.
"""
import json
import os
import struct
import sys

from PIL import Image

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RENDERS = os.path.join(CAMP, 'Renders')
OUT_BG = os.path.join(REPO, 'Content', 'BG')
TL = os.path.join(CAMP, 'Docs', 'DUAL_SCREEN_TIMELINES.json')
REPORT = os.path.join(CAMP, 'Docs', 'SUBSCREEN_BG_REPORT.json')

NDS_W, NDS_H = 256, 192
OUT_W, OUT_H = 320, 240


def make_dir_file(png_img, out_path):
    import io
    buf = io.BytesIO()
    png_img.save(buf, 'PNG')
    b = buf.getvalue()
    with open(out_path, 'wb') as f:
        f.write(struct.pack('<Q', len(b)))
        f.write(b)
        f.write(struct.pack('<IIII', png_img.width, png_img.height, 0, 1))


def main():
    tl = json.load(open(TL))['scenes']
    needed = {}
    for key, e in tl.items():
        if e.get('kind') != 'DUAL_TIMELINE':
            continue
        for g in e.get('sub_grounds', []):
            needed.setdefault(g, []).append(key)
    print(f'décors sub requis (scènes DUAL_TIMELINE): {len(needed)}')
    report = {'schema': 'subscreen-bg/1',
              'method': ('render ROM pixel-perfect -> cadrage fenêtre NDS '
                         '256x192 (centre) -> x1.25 vers 320x240 (même '
                         'ratio 4:3, adaptation documentée) -> '
                         'Content/BG/Sub_<id>.dir'),
              'built': {}, 'missing': {}}
    for gid, scenes in sorted(needed.items()):
        src = os.path.join(RENDERS, gid, 'frame_000.png')
        if not os.path.exists(src):
            report['missing'][gid] = scenes
            print(f'MISSING {gid} ({len(scenes)} scènes)')
            continue
        im = Image.open(src).convert('RGBA')
        # cadrage fenêtre NDS centrée (les scènes déplaçant la caméra sub
        # gardent le décor complet via le champ full_size du rapport)
        if im.width >= NDS_W and im.height >= NDS_H:
            x0 = (im.width - NDS_W) // 2
            y0 = (im.height - NDS_H) // 2
            crop = im.crop((x0, y0, x0 + NDS_W, y0 + NDS_H))
        else:
            # décor plus petit que l'écran : centré sur fond noir (NDS
            # affiche du noir autour, mapty 9 sans wrap)
            crop = Image.new('RGBA', (NDS_W, NDS_H), (0, 0, 0, 255))
            crop.paste(im, ((NDS_W - im.width) // 2,
                            (NDS_H - im.height) // 2))
        out = crop.resize((OUT_W, OUT_H), Image.NEAREST)
        name = 'Sub_' + gid
        make_dir_file(out, os.path.join(OUT_BG, name + '.dir'))
        report['built'][gid] = {'bg': name, 'scenes': len(scenes),
                                'full_size': [im.width, im.height]}
    json.dump(report, open(REPORT, 'w'), ensure_ascii=False, indent=1)
    print(f"construits: {len(report['built'])}, "
          f"manquants: {len(report['missing'])}")
    print('écrit:', REPORT)
    return 0 if not report['missing'] else 1


if __name__ == '__main__':
    sys.exit(main())
