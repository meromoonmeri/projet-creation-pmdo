#!/usr/bin/env python3
"""Détecte les Grounds Red actifs dont le framebuffer final reste incomplet."""
from pathlib import Path
from PIL import Image
import json,re,sys,tempfile
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'));import render_ground
rows=[];errors=[]
for p in sorted((ROOT/'Data/Ground').glob('*.rsground')):
 o=json.load(open(p,encoding='utf-8-sig'))['Object'];c=o.get('Comment','')
 if not re.search(r'\bD\d\dP\d\d\b',c,re.I):continue
 out=Path(tempfile.gettempdir())/(p.stem+'_audit.png')
 try:render_ground.render(p.stem,None,str(out));im=Image.open(out).convert('RGB');px=list(im.getdata());ratio=sum(1 for r,g,b in px if max(r,g,b)<30)/len(px);rows.append((ratio,p.stem))
 finally:out.unlink(missing_ok=True)
 # >50% noir est un signal bloquant pour les material-layers actifs.
 if ratio>.50:errors.append(f'{p.stem}: {ratio:.1%} pixels noirs/sombres')
for ratio,name in sorted(rows,reverse=True):print(f'{name:30s} sombre={ratio:6.1%}')
print(f'RESULTAT: {len(rows)} Grounds Red actifs, {len(errors)} rendus incomplets')
for e in errors:print('INCOMPLET:',e)
raise SystemExit(1 if errors else 0)
