#!/usr/bin/env python3
"""Minimal Python port of dotnet/runtime's WebcilConverter + WebcilWasmWrapper v0."""
from __future__ import annotations
import argparse, struct
from pathlib import Path

PREFIX = bytes([
0x00,0x61,0x73,0x6d,0x01,0x00,0x00,0x00,0x01,0x0a,0x02,0x60,0x01,0x7f,0x00,0x60,0x02,0x7f,0x7f,0x00,0x02,0x12,0x01,0x06,0x77,0x65,0x62,0x63,0x69,0x6c,0x06,0x6d,
0x65,0x6d,0x6f,0x72,0x79,0x02,0x00,0x01,0x03,0x03,0x02,0x00,0x01,0x06,0x0b,0x02,0x7f,0x00,0x41,0x00,0x0b,0x7f,0x00,0x41,0x00,0x0b,0x07,0x41,0x04,0x0d,0x77,0x65,
0x62,0x63,0x69,0x6c,0x56,0x65,0x72,0x73,0x69,0x6f,0x6e,0x03,0x00,0x0a,0x77,0x65,0x62,0x63,0x69,0x6c,0x53,0x69,0x7a,0x65,0x03,0x01,0x0d,0x67,0x65,0x74,0x57,0x65,
0x62,0x63,0x69,0x6c,0x53,0x69,0x7a,0x65,0x00,0x00,0x10,0x67,0x65,0x74,0x57,0x65,0x62,0x63,0x69,0x6c,0x50,0x61,0x79,0x6c,0x6f,0x61,0x64,0x00,0x01,0x0c,0x01,0x02,
0x0a,0x1b,0x02,0x0c,0x00,0x20,0x00,0x41,0x00,0x41,0x04,0xfc,0x08,0x00,0x00,0x0b,0x0c,0x00,0x20,0x00,0x41,0x00,0x20,0x01,0xfc,0x08,0x01,0x00,0x0b,
])
SUFFIX = bytes([
0x00,0x1b,0x04,0x6e,0x61,0x6d,0x65,0x02,0x14,0x02,0x00,0x01,0x00,0x07,0x64,0x65,0x73,0x74,0x50,0x74,0x72,0x01,0x02,0x00,0x01,0x64,0x01,0x01,0x6e,
])

def align(n: int, a: int) -> int:
    return (n+a-1)&~(a-1)

def uleb(n: int) -> bytes:
    out=bytearray()
    while True:
        b=n&0x7f; n >>= 7
        out.append(b | (0x80 if n else 0))
        if not n: return bytes(out)

def parse_pe(data: bytes):
    if data[:2] != b'MZ': raise ValueError('not PE')
    pe=struct.unpack_from('<I',data,0x3c)[0]
    if data[pe:pe+4] != b'PE\0\0': raise ValueError('bad PE signature')
    coff=pe+4
    machine,nsects,stamp,symptr,nsyms,opt_size,chars=struct.unpack_from('<HHIIIHH',data,coff)
    opt=coff+20
    magic=struct.unpack_from('<H',data,opt)[0]
    dd=opt+(96 if magic==0x10b else 112 if magic==0x20b else (_ for _ in ()).throw(ValueError(f'bad optional magic {magic:#x}')))
    debug_rva,debug_size=struct.unpack_from('<II',data,dd+6*8)
    cli_rva,cli_size=struct.unpack_from('<II',data,dd+14*8)
    sect_off=opt+opt_size
    sections=[]
    for i in range(nsects):
        o=sect_off+i*40
        name=data[o:o+8].rstrip(b'\0').decode('ascii','replace')
        vsize,vaddr,rawsize,rawptr=struct.unpack_from('<IIII',data,o+8)
        sections.append(dict(name=name,vsize=vsize,vaddr=vaddr,rawsize=rawsize,rawptr=rawptr))
    return nsects,cli_rva,cli_size,debug_rva,debug_size,sections

def convert_payload(data: bytes) -> bytes:
    nsects,cli_rva,cli_size,debug_rva,debug_size,sections=parse_pe(data)
    cur=align(28+16*nsects,16)
    wc=[]
    for s in sections:
        wc.append(dict(vsize=s['vsize'],vaddr=s['vaddr'],rawsize=s['rawsize'],rawptr=cur))
        cur=align(cur+s['rawsize'],16)
    out=bytearray(struct.pack('<4sHHHHIIII',b'WbIL',0,0,nsects,0,cli_rva,cli_size,debug_rva,debug_size))
    for s in wc:
        out += struct.pack('<IIII',s['vsize'],s['vaddr'],s['rawsize'],s['rawptr'])
    for old,new in zip(sections,wc):
        if len(out)<new['rawptr']: out += b'\0'*(new['rawptr']-len(out))
        chunk=data[old['rawptr']:old['rawptr']+old['rawsize']]
        if len(chunk)!=old['rawsize']: raise ValueError('truncated PE section')
        out += chunk
    def translate(oldptr):
        for old,new in zip(sections,wc):
            if old['rawptr'] <= oldptr < old['rawptr']+old['rawsize']:
                return new['rawptr'] + oldptr-old['rawptr']
        raise ValueError(f'debug data pointer {oldptr:#x} outside sections')
    def rva_pos(rva):
        for s in wc:
            if s['vaddr'] <= rva < s['vaddr']+s['vsize']:
                d=rva-s['vaddr']
                if d>=s['rawsize']: raise ValueError('RVA in virtual tail')
                return s['rawptr']+d
        raise ValueError(f'RVA {rva:#x} outside sections')
    if debug_rva and debug_size:
        p=rva_pos(debug_rva)
        if debug_size%28: raise ValueError('bad debug directory size')
        for o in range(p,p+debug_size,28):
            _,_,_,_,typ,size,_,ptr=struct.unpack_from('<IIHHIIII',out,o)
            if typ!=16 and ptr and size:
                struct.pack_into('<I',out,o+24,translate(ptr))
    return bytes(out)

def wrap(payload: bytes) -> bytes:
    n=len(payload); en=uleb(n)
    # Two segments; segment 0 is 1-byte kind + 1-byte size + >=4 bytes.
    section_base=1 + (1+1+4) + (1+len(en))
    put=uleb(section_base+n)
    payload_off=len(PREFIX)+1+len(put)+section_base
    pad=(-payload_off)%4
    section_size=section_base+pad+n
    sec=uleb(section_size)
    if len(sec)!=len(put): raise ValueError('section LEB boundary changed')
    body=bytearray([11])+sec+bytes([2,1,4+pad])+struct.pack('<I',n)+b'\0'*pad+bytes([1])+en+payload
    assert (len(PREFIX)+len(body)-len(payload))%4==0
    return PREFIX+body+SUFFIX

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('input'); ap.add_argument('output'); ap.add_argument('--payload-only',action='store_true'); ns=ap.parse_args()
    payload=convert_payload(Path(ns.input).read_bytes())
    Path(ns.output).write_bytes(payload if ns.payload_only else wrap(payload))
if __name__=='__main__': main()
