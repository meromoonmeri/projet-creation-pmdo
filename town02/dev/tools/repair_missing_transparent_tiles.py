#!/usr/bin/env python3
"""Repair omitted transparent border keys in a PMDO .tile without fabricating art."""
import json,struct,zlib,binascii
from pathlib import Path
def png8():
 raw=b''.join(b'\x00'+b'\x00'*32 for _ in range(8))
 def ch(t,d):return struct.pack('>I',len(d))+t+d+struct.pack('>I',binascii.crc32(t+d)&0xffffffff)
 return b'\x89PNG\r\n\x1a\n'+ch(b'IHDR',struct.pack('>IIBBBBB',8,8,8,6,0,0,0))+ch(b'IDAT',zlib.compress(raw))+ch(b'IEND',b'')
def refs(path,sheet):
 o=json.load(open(path,encoding='utf-8-sig'))['Object'];r=set()
 def w(x):
  if isinstance(x,dict):
   if x.get('Sheet')==sheet:r.add((x['TexLoc']['X'],x['TexLoc']['Y']))
   for v in x.values():w(v)
  elif isinstance(x,list):
   for v in x:w(v)
 w(o['Layers']);return r
def read(path):
 b=path.read_bytes();size,n=struct.unpack_from('<II',b); rows=[]
 for i in range(n):
  key,off=struct.unpack_from('<QQ',b,8+i*16);ln=struct.unpack_from('<Q',b,off)[0];rows.append((key,b[off+8:off+8+ln]))
 return size,dict(rows)
def write(path,size,rows):
 items=sorted(rows.items());head=8+16*len(items);payloads={};pos=head
 for _,p in items:
  if p not in payloads:payloads[p]=pos;pos+=8+len(p)
 out=bytearray(struct.pack('<II',size,len(items)))
 for k,p in items:out+=struct.pack('<QQ',k,payloads[p])
 for p,off in sorted(payloads.items(),key=lambda x:x[1]):out+=struct.pack('<Q',len(p))+p
 path.write_bytes(out)
sheet='SinisterWoodsFinalCanonical_Base';tp=Path('Content/Tile/'+sheet+'.tile');size,rows=read(tp);wanted=refs(Path('Data/Ground/sinister_woods_clearing.rsground'),sheet);missing=[]
for x,y in wanted:
 k=x|(y<<32)
 if k not in rows:rows[k]=png8();missing.append((x,y))
write(tp,size,rows);print(f'added {len(missing)} transparent border keys')
