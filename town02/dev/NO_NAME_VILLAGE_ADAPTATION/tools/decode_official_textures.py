#!/usr/bin/env python3
from __future__ import annotations
import argparse,bz2,json,struct,zlib,binascii,hashlib
from pathlib import Path

def sx(v,bits):
    sign=1<<(bits-1); return (v^sign)-sign

def decode_qoi(data:bytes):
    if data[:4]!=b'fioq': raise ValueError(f'bad QOI magic {data[:4]!r}')
    w,h,n=struct.unpack_from('<HHI',data,4); pix=data[12:12+n]
    if len(pix)!=n: raise ValueError('truncated QOI data')
    out=bytearray(w*h*4); index=[(0,0,0,0)]*64
    r=g=b=0;a=255;pos=0;run=0;o=0
    while o<len(out):
        if run>0: run-=1
        else:
            if pos>=len(pix): raise ValueError(f'QOI pixel stream ended at pixel {o//4}/{w*h}')
            b1=pix[pos];pos+=1
            if (b1&0xc0)==0x00:
                r,g,b,a=index[b1]
            elif (b1&0xe0)==0x40:
                run=b1&0x1f
            elif (b1&0xe0)==0x60:
                if pos>=len(pix): raise ValueError('truncated RUN16')
                run=(((b1&0x1f)<<8)|pix[pos])+32;pos+=1
            elif (b1&0xc0)==0x80:
                r=(r+sx((b1>>4)&3,2))&255;g=(g+sx((b1>>2)&3,2))&255;b=(b+sx(b1&3,2))&255
            elif (b1&0xe0)==0xc0:
                if pos>=len(pix): raise ValueError('truncated DIFF16')
                m=(b1<<8)|pix[pos];pos+=1
                r=(r+sx((m>>8)&31,5))&255;g=(g+sx((m>>4)&15,4))&255;b=(b+sx(m&15,4))&255
            elif (b1&0xf0)==0xe0:
                if pos+2>len(pix): raise ValueError('truncated DIFF24')
                m=(b1<<16)|(pix[pos]<<8)|pix[pos+1];pos+=2
                r=(r+sx((m>>15)&31,5))&255;g=(g+sx((m>>10)&31,5))&255;b=(b+sx((m>>5)&31,5))&255;a=(a+sx(m&31,5))&255
            elif (b1&0xf0)==0xf0:
                if b1&8:r=pix[pos];pos+=1
                if b1&4:g=pix[pos];pos+=1
                if b1&2:b=pix[pos];pos+=1
                if b1&1:a=pix[pos];pos+=1
            index[(r^g^b^a)&63]=(r,g,b,a)
        out[o:o+4]=bytes((r,g,b,a));o+=4
    return w,h,bytes(out),pos,n

def chunk(name,data):
    return struct.pack('>I',len(data))+name+data+struct.pack('>I',binascii.crc32(name+data)&0xffffffff)
def png(w,h,rgba):
    raw=b''.join(b'\0'+rgba[y*w*4:(y+1)*w*4] for y in range(h))
    return b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',w,h,8,6,0,0,0))+chunk(b'IDAT',zlib.compress(raw,9))+chunk(b'IEND',b'')
def safe(s):return ''.join(c if c.isalnum() or c in '._-' else '_' for c in (s or 'unnamed'))
def main():
 ap=argparse.ArgumentParser();ap.add_argument('structured');ap.add_argument('output');ns=ap.parse_args();root=Path(ns.structured);out=Path(ns.output);out.mkdir(parents=True,exist_ok=True)
 textures=json.loads((root/'inventory/EmbeddedTextures.json').read_text()); rows=[]
 for i,t in enumerate(textures):
  im=t['TextureData']['Image']; ref=im['_data']['$binary']; comp=(root/ref['path']).read_bytes(); q=bz2.decompress(comp);w,h,rgba,used,n=decode_qoi(q)
  if w!=t['TextureWidth'] or h!=t['TextureHeight'] or w!=im['Width'] or h!=im['Height']:raise ValueError(f'dimension mismatch texture {i}')
  data=png(w,h,rgba);name=f'{i:04d}_{safe(t.get("Name"))}.png';(out/name).write_bytes(data)
  rows.append({'index':i,'name':t.get('Name'),'width':w,'height':h,'compressed_path':ref['path'],'compressed_sha256':ref['sha256'],'compressed_length':len(comp),'qoi_length':len(q),'qoi_payload_declared':n,'qoi_payload_consumed':used,'png':name,'png_length':len(data),'png_sha256':hashlib.sha256(data).hexdigest()})
 (out/'manifest.json').write_text(json.dumps({'schema':'no-name-village-decoded-textures-v1','count':len(rows),'textures':rows},indent=2)+'\n')
 print(f'decoded {len(rows)} texture pages')
if __name__=='__main__':main()
