#!/usr/bin/env python3
"""Audit PMDO item sprite bindings against the supplied PMD Sky source blobs."""
from pathlib import Path
import argparse,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--pret',default='/tmp/pmd-sky');ap.add_argument('--out',default=str(ROOT/'docs/canonical/sky/ITEM_SPRITE_AUDIT.json'));a=ap.parse_args();pret=Path(a.pret);sources=[pret/'files/BALANCE/item_s_p.bin'];errors=[]
 for p in sources:
  if not p.exists():errors.append(f'source absente: {p}')
 items=[]
 for p in sorted((ROOT/'Data/Item').glob('*.json')):
  o=json.load(open(p,encoding='utf-8-sig'))['Object'];sprite=o.get('Sprite','');icon=o.get('Icon',-1)
  if not sprite:errors.append(f'{p.stem}: Sprite vide')
  if not isinstance(icon,int):errors.append(f'{p.stem}: Icon invalide {icon}')
  items.append({'id':p.stem,'sprite':sprite,'icon':icon,'released':o.get('Released',False)})
 out={'schema':1,'authority':'pret/pmd-sky binary item tables; no PNG/screenshot source','source_blobs':[{'path':str(p.relative_to(pret)),'bytes':p.stat().st_size,'sha256':sha(p)} for p in sources if p.exists()],'counts':{'pmdo_items':len(items),'distinct_sprite_bindings':len({x['sprite'] for x in items}),'errors':len(errors)},'items':items,'errors':errors,'note':'A non-empty PMDO binding is necessary but runtime sprite identity still requires the corresponding RogueEssence animation asset to be present in the engine data package.'};dest=Path(a.out);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n');print(json.dumps(out['counts']));raise SystemExit(bool(errors))
if __name__=='__main__':main()
