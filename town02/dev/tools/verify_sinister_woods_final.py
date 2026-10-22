#!/usr/bin/env python3
from pathlib import Path
from PIL import Image,ImageChops
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'));import render_ground
out=ROOT/'docs/renders/_verify_d04p02.png';render_ground.render('sinister_woods_clearing',0,str(out));a=Image.open(ROOT/'docs/canonical/red/final_frames/d04p02.png').convert('RGBA');b=Image.open(out).convert('RGBA');# renderer composites transparent against black
bg=Image.new('RGBA',a.size,(0,0,0,255));bg.alpha_composite(a);diff=ImageChops.difference(bg,b);bad=sum(1 for p in diff.getdata() if p!=(0,0,0,0));out.unlink(missing_ok=True);print(f'D04P02: {bad} pixels différents sur {a.width*a.height}');raise SystemExit(1 if bad else 0)
