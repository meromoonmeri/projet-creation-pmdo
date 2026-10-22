#!/usr/bin/env python3
from pathlib import Path
import struct,json
R=Path(__file__).resolve().parents[1];p=R/'Content/Tile/index.idx';b=p.read_bytes();pos=0
def i():
 global pos;v=struct.unpack_from('<i',b,pos)[0];pos+=4;return v
def s():
 global pos;n=0;sh=0
 while True:
  q=b[pos];pos+=1;n|=(q&127)<<sh
  if q<128:break
  sh+=7
 v=b[pos:pos+n].decode();pos+=n;return v
count=i();nodes={}
for _ in range(count):
 n=s();ts=i();c=i();coords=set()
 for j in range(c):x=i();y=i();off=struct.unpack_from('<q',b,pos)[0];pos+=8;coords.add((x,y))
 nodes[n]=(ts,coords)
refs=set();bad=[]
for f in list((R/'Data/Ground').glob('*.rsground'))+list((R/'Data/Map').glob('*.rsmap')):
 try:o=json.loads(f.read_text(encoding='utf-8-sig'))['Object']
 except:continue
 for l in o.get('Layers',[]):
  for col in l.get('Tiles',[]):
   for cell in col:
    for q in cell.get('Layers',[]):
     for fr in q.get('Frames',[]):
      n=fr.get('Sheet');loc=fr.get('TexLoc',{}); 
      if n:refs.add(n)
      if n and (n not in nodes or (loc.get('X'),loc.get('Y')) not in nodes[n][1]):bad.append((str(f.relative_to(R)),n,loc))
from collections import Counter
print(json.dumps({'indexed_sheets':count,'referenced_sheets':len(refs),'invalid_references':len(bad),'invalid_sheets':Counter(x[1] for x in bad).most_common(),'examples':bad[:20]},indent=2));raise SystemExit(1 if bad else 0)
