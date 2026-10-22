import struct
from PIL import Image
BASE='/tmp/pmd-red/data/map_bg'

def parse_bpl(p):
    d=open(p,'rb').read(); n=d[0]; pals=[]; off=4
    for _ in range(n):
        cols=[(0,0,0,0)]
        for c in range(15):
            cols.append((d[off],d[off+1],d[off+2],255)); off+=4
        pals.append(cols)
    return pals

def parse_bpc(p):
    d=open(p,'rb').read()
    cw,chh,nt=struct.unpack_from('<HHH',d,0)
    nc,=struct.unpack_from('<H',d,14)
    tiles=[bytes(32)]+[d[16+i*32:16+(i+1)*32] for i in range(nt-1)]
    off=16+(nt-1)*32
    n=cw*chh
    chunks=[[0]*n]
    for i in range(nc-1):
        chunks.append(list(struct.unpack_from(f'<{n}H',d,off))); off+=n*2
    return cw,chh,tiles,chunks

def decode_bma(p):
    d=open(p,'rb').read()
    Wt,Ht,tw,th,Wc,Hc=d[:6]
    nL,hD,hC=struct.unpack_from('<HhH',d,6)
    src=12; STRIDE=64
    layers=[]
    for li in range(nL):
        dst=[]
        for j in range(Hc):
            row=[]
            prev=dst[(j-1)*STRIDE:j*STRIDE] if j>0 else [0]*STRIDE
            k=0
            while k<Wc:
                cmd=d[src]; src+=1
                if cmd>=0xC0:
                    for l in range(cmd-0xC0+1):
                        v=d[src]|(d[src+1]<<8)|(d[src+2]<<16); src+=3
                        a,b=v&0xFFF,(v>>12)&0xFFF
                        if j>0: a^=prev[len(row)]; b^=prev[len(row)+1]
                        row+=[a,b]
                    k+=(cmd-0xBF)*2
                elif cmd>=0x80:
                    v=d[src]|(d[src+1]<<8)|(d[src+2]<<16); src+=3
                    for l in range(cmd-0x80+1):
                        a,b=v&0xFFF,(v>>12)&0xFFF
                        if j>0: a^=prev[len(row)]; b^=prev[len(row)+1]
                        row+=[a,b]
                    k+=(cmd-0x7F)*2
                else:
                    for l in range(cmd+1):
                        if j>0: row+=[prev[len(row)],prev[len(row)+1]]
                        else: row+=[0,0]
                    k+=(cmd+1)*2
            row=row[:STRIDE]+[0]*(STRIDE-len(row))
            dst+=row
        layers.append(dst)
    # collision layer(s) : NRL 1 bit/cell, decode simple (sub_80A5204 est en asm ;
    # skytemple-files le lit correctement, on l'utilise pour la collision)
    return Wt,Ht,Wc,Hc,nL,hC,layers

def get_collision(p):
    from skytemple_files.common.types.file_types import FileType
    bma=FileType.BMA.deserialize(open(p,'rb').read())
    return bma.collision, bma.map_width_camera, bma.map_height_camera

def render(name, out=None, transparent_bg=False):
    pals=parse_bpl(f'{BASE}/{name}.bpl')
    cw,chh,tiles,chunks=parse_bpc(f'{BASE}/{name}c.bpc')
    Wt,Ht,Wc,Hc,nL,hC,layers=decode_bma(f'{BASE}/{name}m.bma')
    bg=(0,0,0,0) if transparent_bg else (0,0,0,255)
    img=Image.new('RGBA',(Wt*8,Ht*8),bg)
    for lay in reversed(layers):
        for cy in range(Hc):
            for cx in range(Wc):
                cid=lay[cy*64+cx]
                if cid<=0 or cid>=len(chunks): continue
                for i,ent in enumerate(chunks[cid]):
                    ti=ent&0x3FF; hf=(ent>>10)&1; vf=(ent>>11)&1; pi=(ent>>12)&0xF
                    if ti==0 or ti>=len(tiles): continue
                    tx,ty=cx*3+i%3, cy*3+i//3
                    if tx*8+8>Wt*8 or ty*8+8>Ht*8: continue
                    td=tiles[ti]; pal=pals[pi%len(pals)]
                    for y in range(8):
                        for x in range(4):
                            b=td[y*4+x]
                            for k2,ci in enumerate((b&0xF,b>>4)):
                                if ci==0: continue
                                xx=x*2+k2; yy=y
                                if hf: xx=7-xx
                                if vf: yy=7-yy
                                img.putpixel((tx*8+xx,ty*8+yy),pal[ci])
    if out: img.save(out)
    return img,Wt,Ht
