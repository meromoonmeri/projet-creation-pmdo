#!/usr/bin/env python3
from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[1];gp=ROOT/'Data/Ground/mount_windswept_guardian.rsground';sp=ROOT/'Data/Script/halcyon/ground/mount_windswept_guardian/mount_windswept_guardian_ch_5.lua';init=ROOT/'Data/Script/halcyon/ground/mount_windswept_guardian/init.lua';o=json.load(open(gp,encoding='utf-8-sig'))['Object'];ob=o['obstacles'];W,H=len(ob)*8,len(ob[0])*8;errors=[]
# Positions actively used for team/boss composition; evaluate 16x16 footprints.
points=[(176,248,'hero'),(152,248,'partner'),(200,248,'teammate2'),(224,248,'teammate3'),(176,192,'hero-arrival'),(152,192,'partner-arrival'),(200,192,'teammate2-arrival'),(224,192,'teammate3-arrival'),(176,136,'tornadus')]
for x,y,n in points:
 if not(0<=x<=W-16 and 0<=y<=H-16):errors.append(f'{n}: hors carte {(x,y)}')
 elif any(ob[xx][yy]['Tags']==1 for xx in range(x//8,(x+15)//8+1) for yy in range(y//8,(y+15)//8+1)):errors.append(f'{n}: collision {(x,y)}')
s=sp.read_text();i=init.read_text()
for token in ('GAME:FadeIn(40)','GAME:MoveCamera(176, 196','TeleportTo(t3, 224, 248'):
 if token not in s:errors.append(f'script token absent: {token}')
for token in ('local ok, err = pcall','GAME:CutsceneMode(false)','GAME:FadeIn(20)'):
 if token not in i:errors.append(f'sortie garantie absente: {token}')
print('AUDIT SPATIAL ARENE TORNADUS')
print(f'{W}x{H}px; {len(points)} positions; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
