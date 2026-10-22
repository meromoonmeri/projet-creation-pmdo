#!/usr/bin/env python3
from __future__ import annotations
import argparse,bz2,json,struct,zlib,binascii,hashlib,os,shutil
from pathlib import Path

def sx(v,bits): sign=1<<(bits-1);return (v^sign)-sign
def decode_qoi(data):
 if data[:4]!=b'fioq':raise ValueError('bad QOI')
 w,h,n=struct.unpack_from('<HHI',data,4);p=data[12:12+n];out=bytearray(w*h*4);idx=[(0,0,0,0)]*64;r=g=b=0;a=255;pos=run=o=0
 while o<len(out):
  if run:run-=1
  else:
   b1=p[pos];pos+=1
   if b1&0xc0==0:r,g,b,a=idx[b1]
   elif b1&0xe0==0x40:run=b1&31
   elif b1&0xe0==0x60:run=(((b1&31)<<8)|p[pos])+32;pos+=1
   elif b1&0xc0==0x80:r=(r+sx((b1>>4)&3,2))&255;g=(g+sx((b1>>2)&3,2))&255;b=(b+sx(b1&3,2))&255
   elif b1&0xe0==0xc0:
    m=(b1<<8)|p[pos];pos+=1;r=(r+sx((m>>8)&31,5))&255;g=(g+sx((m>>4)&15,4))&255;b=(b+sx(m&15,4))&255
   elif b1&0xf0==0xe0:
    m=(b1<<16)|(p[pos]<<8)|p[pos+1];pos+=2;r=(r+sx((m>>15)&31,5))&255;g=(g+sx((m>>10)&31,5))&255;b=(b+sx((m>>5)&31,5))&255;a=(a+sx(m&31,5))&255
   else:
    if b1&8:r=p[pos];pos+=1
    if b1&4:g=p[pos];pos+=1
    if b1&2:b=p[pos];pos+=1
    if b1&1:a=p[pos];pos+=1
   idx[(r^g^b^a)&63]=(r,g,b,a)
  out[o:o+4]=bytes((r,g,b,a));o+=4
 return w,h,bytes(out)
def ch(n,d):return struct.pack('>I',len(d))+n+d+struct.pack('>I',binascii.crc32(n+d)&0xffffffff)
def png(w,h,rgba):
 raw=b''.join(b'\0'+rgba[y*w*4:(y+1)*w*4] for y in range(h));return b'\x89PNG\r\n\x1a\n'+ch(b'IHDR',struct.pack('>IIBBBBB',w,h,8,6,0,0,0))+ch(b'IDAT',zlib.compress(raw,6))+ch(b'IEND',b'')
def safe(s):return ''.join(c if c.isalnum() or c in '._-' else '_' for c in (s or 'unnamed'))
def ref_index(x):return x['$resourceRef']['index'] if x else None
def main():
 ap=argparse.ArgumentParser();ap.add_argument('structured');ap.add_argument('output');ns=ap.parse_args();root=Path(ns.structured);out=Path(ns.output);tpi_dir=out/'page-items';spr_dir=out/'sprites';mask_dir=out/'collision-masks';[x.mkdir(parents=True,exist_ok=True) for x in [tpi_dir,spr_dir,mask_dir]]
 tex=json.loads((root/'inventory/EmbeddedTextures.json').read_text());tpis=json.loads((root/'inventory/TexturePageItems.json').read_text());sprites=json.loads((root/'inventory/Sprites.json').read_text())
 bypage={i:[] for i in range(len(tex))}
 for i,t in enumerate(tpis):bypage[ref_index(t['TexturePage'])].append((i,t))
 tpi_files={};
 for page,t in enumerate(tex):
  im=t['TextureData']['Image'];comp=(root/im['_data']['$binary']['path']).read_bytes();w,h,rgba=decode_qoi(bz2.decompress(comp));
  for i,x in bypage[page]:
   sx0,sy,sw,sh=x['SourceX'],x['SourceY'],x['SourceWidth'],x['SourceHeight'];tw,th=x['TargetWidth'],x['TargetHeight'];bw,bh=x['BoundingWidth'],x['BoundingHeight'];tx,ty=x['TargetX'],x['TargetY']
   if (sw,sh)!=(tw,th):raise ValueError(f'unverified scaling required TPI {i}')
   canvas=bytearray(bw*bh*4)
   for yy in range(sh):canvas[((ty+yy)*bw+tx)*4:((ty+yy)*bw+tx+sw)*4]=rgba[((sy+yy)*w+sx0)*4:((sy+yy)*w+sx0+sw)*4]
   f=tpi_dir/f'{i:05d}.png';f.write_bytes(png(bw,bh,canvas));tpi_files[i]=f
  print(f'page {page+1}/{len(tex)}: {len(bypage[page])} items')
 sprite_rows=[];frame_count=0;mask_count=0
 for si,s in enumerate(sprites):
  sd=spr_dir/f'{si:04d}_{safe(s.get("Name"))}';sd.mkdir(exist_ok=True);frames=[]
  for fi,e in enumerate(s.get('Textures') or []):
   ti=ref_index(e.get('Texture'));src=tpi_files[ti];dst=sd/f'{fi:04d}.png'
   try:os.link(src,dst)
   except OSError:shutil.copyfile(src,dst)
   frames.append({'frame':fi,'texturePageItem':ti,'file':str(dst.relative_to(out)).replace('\\','/')});frame_count+=1
  masks=[]
  for mi,m in enumerate(s.get('CollisionMasks') or []):
   binfo=m['Data']['$binary'];bits=(root/binfo['path']).read_bytes();mw,mh=m['Width'],m['Height'];rgba=bytearray(mw*mh*4);stride=(mw+7)//8
   for y in range(mh):
    for x in range(mw):
     on=bool(bits[y*stride+x//8]&(1<<(7-x%8)));v=255 if on else 0;o=(y*mw+x)*4;rgba[o:o+4]=bytes((v,v,v,255))
   mf=mask_dir/f'{si:04d}_{safe(s.get("Name"))}_{mi:03d}.png';mf.write_bytes(png(mw,mh,rgba));masks.append({'mask':mi,'raw':binfo['path'],'file':str(mf.relative_to(out)).replace('\\','/'),'width':mw,'height':mh});mask_count+=1
  sprite_rows.append({'index':si,'name':s.get('Name'),'width':s.get('Width'),'height':s.get('Height'),'originX':s.get('OriginX'),'originY':s.get('OriginY'),'playbackSpeed':s.get('GMS2PlaybackSpeed'),'playbackSpeedType':s.get('GMS2PlaybackSpeedType'),'frames':frames,'collisionMasks':masks})
 (out/'manifest.json').write_text(json.dumps({'schema':'no-name-village-frames-v1','sprites':len(sprites),'frames':frame_count,'texturePageItems':len(tpis),'collisionMasks':mask_count,'resources':sprite_rows},indent=2)+'\n')
 print(f'extracted {frame_count} frames and {mask_count} collision masks')
if __name__=='__main__':main()
