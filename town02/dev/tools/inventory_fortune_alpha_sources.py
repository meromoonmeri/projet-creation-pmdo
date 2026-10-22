#!/usr/bin/env python3
"""Diff a Sky-derived NDS filesystem against clean Sky without interpreting IDs."""
from ndspy.rom import NintendoDSRom
import hashlib,json,sys,os,gc
def fm(path):
 r=NintendoDSRom.fromFile(path);o={}
 def w(f,p=''):
  for i,n in enumerate(f.files):o[p+n]=(len(r.files[f.firstID+i]),hashlib.sha1(r.files[f.firstID+i]).hexdigest())
  for n,s in f.folders:w(s,p+n+'/')
 w(r.filenames);meta={'title':r.name.decode(errors='replace').rstrip('\0'),'code':r.idCode.decode(errors='replace')};return o,meta
base,_=fm(sys.argv[1]);src,meta=fm(sys.argv[2]);common=set(base)&set(src);changed=sorted(x for x in common if base[x]!=src[x]);added=sorted(set(src)-set(base));print(json.dumps({'source':sys.argv[2],'bytes':os.path.getsize(sys.argv[2]),**meta,'changed':changed,'added':added},indent=2))
