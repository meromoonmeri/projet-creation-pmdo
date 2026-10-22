#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""campaign_render_showcase.py — planche composite de renders des deux
campagnes (PMD Red EU + PMD Sky EU) pour le manifest final.

Sources : renders frame_000.png des campagnes (pixel-perfect ROM) +
renders des arènes boss .rsmap (render_rsmap_autotile, visualisation de
référence). Chaque vignette est étiquetée avec son ID canonique.
Sortie : dev/docs/canonical/renders/SHOWCASE_RED_SKY.png
"""
import os

from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMPS = os.path.join(ROOT, 'dev', 'CAMPAIGNS')
RENDERS = os.path.join(ROOT, 'dev', 'docs', 'canonical', 'renders')

TILE_W, TILE_H = 360, 300
LABEL_H = 22
COLS = 4

# (chemin, étiquette)
ITEMS = [
    # --- Sky : hub, guilde, plage, panorama scroll ---
    (os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'Renders', 't01p01a',
                  'frame_000.png'),
     'SKY t01p01a — Bourg-Trésor (hub)'),
    (os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'Renders', 'g01p01a',
                  'frame_000.png'),
     'SKY g01p01a — Guilde de Grodoudou (nameid 277)'),
    (os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'Renders', 'd01p11a',
                  'frame_000.png'),
     'SKY d01p11a — Plage (Beach, nameid 196)'),
    (os.path.join(RENDERS, 'sky_s13p05a_panorama.png'),
     'SKY s13p05a — panorama défilant (intro)'),
    # --- Sky : arènes boss (fixed.bin ROM) ---
    (os.path.join(RENDERS, 'sky_beach_cave_pit_arena.png'),
     'SKY arène — Team Skull (Beach Cave Pit)'),
    (os.path.join(RENDERS, 'sky_steam_cave_peak_arena.png'),
     'SKY arène — Groudon illusion (Steam Cave)'),
    (os.path.join(RENDERS, 'sky_brine_cave_pit_arena.png'),
     'SKY arène — Kabutops/Omastar (Brine Cave)'),
    (os.path.join(RENDERS, 'sky_temporal_pinnacle_dialga.png'),
     'SKY arène finale — DIALGA (Temporal Pinnacle)'),
    # --- Red : donjons/boss ---
    (os.path.join(CAMPS, 'PMD_RED_RESCUE_TEAM', 'Renders', 't01p01',
                  'frame_000.png'),
     'RED t01p01 — Place Pokémon (hub)'),
    (os.path.join(RENDERS, 'red_mt_steel_boss.png'),
     'RED arène — Skarmory (Mt Steel, fixedmap.inc)'),
    (os.path.join(RENDERS, 'red_magma_pit_groudon.png'),
     'RED arène — GROUDON L27 (Magma Cavern Pit 3F)'),
    (os.path.join(RENDERS, 'red_sky_summit_rayquaza.png'),
     'RED arène — RAYQUAZA L35 (Sky Tower Summit 9F)'),
]


def fit(im, w, h):
    im = im.convert('RGBA')
    r = min(w / im.width, h / im.height)
    if r < 1:
        im = im.resize((max(1, int(im.width * r)),
                        max(1, int(im.height * r))), Image.NEAREST)
    return im


def main():
    items = [(p, lbl) for p, lbl in ITEMS if p and os.path.exists(p)]
    rows = (len(items) + COLS - 1) // COLS
    W = COLS * (TILE_W + 8) + 8
    H = rows * (TILE_H + LABEL_H + 8) + 8 + 40
    img = Image.new('RGB', (W, H), (18, 18, 24))
    d = ImageDraw.Draw(img)
    try:
        font = ImageFont.truetype(
            '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 13)
        title_font = ImageFont.truetype(
            '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 20)
    except OSError:
        font = ImageFont.load_default()
        title_font = font
    d.text((12, 10), 'PMD RED EU + PMD SKY EU dans PMDO — renders canoniques'
           ' (ROM->PMDO)', fill=(240, 240, 240), font=title_font)
    for i, (p, lbl) in enumerate(items):
        cx = 8 + (i % COLS) * (TILE_W + 8)
        cy = 48 + (i // COLS) * (TILE_H + LABEL_H + 8)
        im = fit(Image.open(p), TILE_W, TILE_H)
        ox = cx + (TILE_W - im.width) // 2
        oy = cy + (TILE_H - im.height) // 2
        d.rectangle([cx - 1, cy - 1, cx + TILE_W, cy + TILE_H],
                    outline=(70, 70, 90))
        img.paste(im, (ox, oy), im)
        d.text((cx + 4, cy + TILE_H + 4), lbl, fill=(220, 220, 160),
               font=font)
    out = os.path.join(RENDERS, 'SHOWCASE_RED_SKY.png')
    img.save(out)
    print(out, img.size, f'{len(items)} vignettes')


if __name__ == '__main__':
    main()
