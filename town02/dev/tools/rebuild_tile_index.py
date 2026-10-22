#!/usr/bin/env python3
"""Reproduit RogueEssence.Dev.ImportHelper.BuildTileIndex en Python."""
from pathlib import Path
import struct
ROOT=Path(__file__).resolve().parents[1];D=ROOT/'Content/Tile'
def seven(n):
 out=bytearray()
 while n>=0x80:out.append((n&0x7f)|0x80);n>>=7
 out.append(n);return out
files=sorted(p for p in D.glob('*.tile'))
out=bytearray(struct.pack('<i',len(files)))
for p in files:
 b=p.read_bytes();size,count=struct.unpack_from('<ii',b,0);name=p.stem.encode('utf-8');out+=seven(len(name))+name;out+=struct.pack('<ii',size,count)
 # .tile node format is TileSize, Count, then X:int Y:int Position:long.
 out+=b[8:8+count*16]
(D/'index.idx').write_bytes(out);print('indexed',len(files),'sheets','bytes',len(out))
