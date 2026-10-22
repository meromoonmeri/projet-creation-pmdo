#!/usr/bin/env python3
"""Materialize a complete rmvillage seasonal Ground from the validated base."""
from __future__ import annotations
import argparse,gzip,hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SEASONS=('spring','summer','autumn','winter')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main()->int:
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--season',choices=SEASONS,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--life',action='store_true');a=p.parse_args()
 guard=subprocess.run([sys.executable,str(ROOT/'tools/verify_rmvillage_summer_baseline.py')],cwd=ROOT.parent,capture_output=True,text=True)
 if guard.returncode:raise SystemExit(guard.stdout+guard.stderr)
 base=ROOT/'generated/rmvillage/summer';manifest=json.loads((base/'manifest.json').read_text());ground=json.loads((base/manifest['outputs']['ground']).read_text(encoding='utf-8-sig'))
 if a.season!='summer':
  seasonal=ROOT/'generated/rmvillage'/a.season;m=json.loads((seasonal/'manifest.json').read_text());bundle=seasonal/m['outputs']['season_layers']
  if sha(bundle)!=m['outputs']['season_layers_sha256']:raise ValueError('season layer hash mismatch')
  with gzip.open(bundle,'rt',encoding='utf-8') as stream:layers=json.load(stream)
  if layers['dimensions_px']!=[4992,4992] or layers['tex_size']!=8:raise ValueError('season layer geometry mismatch')
  ground['Object']['Layers']=layers['layers']
 ground['Object']['AssetName']=f'nnv_rmvillage_{a.season}';ground['Object']['Name']={'DefaultText':f'No Name Village — rmvillage ({a.season})','LocalTexts':{'fr':f'Village Sans Nom — {a.season}'}}
 ground['Object']['Comment']+=f' | Materialized canonical season: {a.season}.'
 if a.life:
  patch=json.loads((ROOT/'generated/rmvillage/life/entities_patch.json').read_text());assert patch['conversion_status']=='UNIMPLEMENTED' and patch['promotion_allowed'] is False
  existing={c['EntName'] for layer in ground['Object']['Entities'] for c in layer['MapChars']};assert not existing.intersection(c['EntName'] for c in patch['entities'])
  ground['Object']['Entities'][0]['MapChars'].extend(patch['entities']);ground['Object']['Comment']+=f" | Native Pokemon life patch: {len(patch['entities'])} MapChars."
 a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text('\ufeff'+json.dumps(ground,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
 check=json.loads(a.output.read_text(encoding='utf-8-sig'))['Object'];assert check['AssetName']==f'nnv_rmvillage_{a.season}' and len(check['obstacles'])==624 and len(check['Layers'][0]['Tiles'])==78
 print(json.dumps({'result':'RMVILLAGE_SEASON_MATERIALIZE_PASS','season':a.season,'output':str(a.output),'sha256':sha(a.output),'tex_size':check['TexSize'],'collision_grid':[len(check['obstacles']),len(check['obstacles'][0])],'life_patch':a.life,'mapchars':sum(len(layer['MapChars']) for layer in check['Entities'])}));return 0
if __name__=='__main__':raise SystemExit(main())
