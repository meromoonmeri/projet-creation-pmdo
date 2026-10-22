#!/usr/bin/env python3
"""Resize PMDO DiscoveryArray to each fixed map's real Tiles dimensions."""
import json,glob
fixed=[]
for p in glob.glob('Data/Map/*.rsmap'):
 try:d=json.load(open(p,encoding='utf-8-sig'));o=d['Object'];w=len(o.get('Tiles',[]));h=len(o['Tiles'][0]) if w else 0;a=o.get('DiscoveryArray',[])
 except:continue
 if len(a)!=w or (w and any(len(c)!=h for c in a)):
  o['DiscoveryArray']=[[0 for _ in range(h)] for _ in range(w)]
  with open(p,'w') as f:json.dump(d,f,ensure_ascii=False,indent=2);f.write('\n')
  fixed.append({'map':o.get('AssetName',p),'width':w,'height':h})
print(f'repaired {len(fixed)} map discovery arrays')
