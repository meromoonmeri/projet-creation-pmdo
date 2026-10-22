#!/usr/bin/env python3
"""Audit bidirectionnel du corpus urbain EoS T00/T01/P01/G01.
Ne produit aucun RUNTIME_PASS : le rendu moteur doit être fourni séparément.
"""
from pathlib import Path
import json,re,hashlib
ROOT=Path(__file__).resolve().parents[1]
SRC=Path(__import__('os').environ.get('PMD_SKY_PORT','/home/user/skyport'))/'output'
FAMILIES=('t00p','t01p','p01p','g01p')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))['Object']
def metrics(o):
 cells=frames=animated=0;sheets=set()
 for l in o.get('Layers',[]):
  for col in l.get('Tiles',[]):
   for cell in col:
    for tl in cell.get('Layers',[]):
     fs=tl.get('Frames',[]);cells+=1;frames+=len(fs);animated+=len(fs)>1
     sheets|={f.get('Sheet','') for f in fs if f.get('Sheet')}
 return {'width':len(o['Layers'][0]['Tiles']),'height':len(o['Layers'][0]['Tiles'][0]),'cells':cells,'frames':frames,'animated_cells':animated,'sheets':sorted(sheets),'collision':hashlib.sha256(json.dumps(o.get('obstacles'),sort_keys=True).encode()).hexdigest()}
def main():
 srcs={p.stem.lower():p for p in (SRC/'Grounds').glob('*.rsground') if p.stem.lower().startswith(FAMILIES)}
 pmdo={p.stem:p for p in (ROOT/'Data/Ground').glob('*.rsground')}
 rows=[]
 for sid,p in sorted(srcs.items()):
  sm=metrics(load(p));hits=[]
  for name,q in pmdo.items():
   text=q.read_text(encoding='utf-8-sig').lower()
   if sid in text or any(s.lower() in text for s in sm['sheets']):hits.append(name)
  state='MISSING' if not hits else 'PARTIAL'
  comparisons=[]
  for h in hits:
   m=metrics(load(pmdo[h])); comparisons.append({'ground':h,'geometry':(m['width'],m['height'])==(sm['width'],sm['height']),'collision':m['collision']==sm['collision'],'frames':m['frames']==sm['frames'],'animated_cells':m['animated_cells']==sm['animated_cells'],'pmdo_metrics':m})
  if comparisons and any(all(c[k] for k in ('geometry','collision','frames','animated_cells')) for c in comparisons):state='STATIC_VERIFIED'
  rows.append({'source':sid,'family':sid[:3],'source_metrics':sm,'pmdo':comparisons,'static_status':state,'runtime_status':'NOT_TESTED'})
 reverse=[]
 for n,p in pmdo.items():
  t=p.read_text(encoding='utf-8-sig').lower()
  if any(x in t for x in FAMILIES) or n in ('bourg_comptoir','carrefour_assemblee','guilde_parvis','treasure_spinda_cafe'):
   ids=[s for s in srcs if s in t];reverse.append({'pmdo':n,'sources':ids,'status':'MAPPED' if ids else 'SOURCE_UNCLEAR'})
 summary={'canonical_grounds':len(rows),'static_verified':sum(r['static_status']=='STATIC_VERIFIED' for r in rows),'partial':sum(r['static_status']=='PARTIAL' for r in rows),'missing':sum(r['static_status']=='MISSING' for r in rows),'runtime_verified':0,'source_families':{f:sum(r['source'].startswith(f) for r in rows) for f in FAMILIES}}
 out={'scope':'Treasure Town urban dependency corpus: T00/T01/P01/G01','summary':summary,'source_to_pmdo':rows,'pmdo_to_source':reverse,'answer':'NO','rule':'STATIC_VERIFIED is not RUNTIME_VERIFIED.'}
 q=ROOT/'docs/audit_global/TREASURE_TOWN_SKY_EXHAUSTIVE.json';q.parent.mkdir(parents=True,exist_ok=True);q.write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n');print(json.dumps(summary,ensure_ascii=False));return 1 if summary['missing'] or summary['partial'] else 0
if __name__=='__main__':raise SystemExit(main())
