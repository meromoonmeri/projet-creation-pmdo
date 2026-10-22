#!/usr/bin/env python3
"""Non-régression du rendu final visible de Sky Tower D13P03."""
from pathlib import Path
from PIL import Image,ImageChops
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
import render_ground
out=ROOT/'docs/renders/_verify_sky_tower_summit.png'
render_ground.render('tour_ciel_sommet',0,str(out))
src=Image.open(ROOT/'Sky_Tower_summit_RTRB.png').convert('RGBA')
ref=Image.new('RGBA',(552,600),src.getpixel((0,575)));ref.paste(src,(0,0))
for y in range(576):ref.putpixel((551,y),src.getpixel((550,y)))
for y in range(576,600):
 for x in range(552):ref.putpixel((x,y),ref.getpixel((x,575)))
got=Image.open(out).convert('RGBA');diff=ImageChops.difference(ref,got);bad=sum(1 for px in diff.getdata() if px!=(0,0,0,0));out.unlink(missing_ok=True)
print(f'Sky Tower Summit: {bad} pixels différents sur {552*600}')
raise SystemExit(1 if bad else 0)
