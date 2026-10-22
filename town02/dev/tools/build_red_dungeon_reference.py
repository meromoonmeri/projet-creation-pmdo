#!/usr/bin/env python3
"""Build the authoritative PMD Red floor-by-floor restoration matrix.

Generation source is pret/pmd-red only. New Era is read for gap analysis; it
never changes the canonical table. Output is deterministic JSON + Markdown.
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
from pathlib import Path
import argparse,json,re,hashlib

def norm(s): return re.sub(r'[^a-z0-9]','',s.lower().replace('dungeon',''))
def groups(rows):
 out=[];start=0
 for i in range(1,len(rows)+1):
  if i==len(rows) or rows[i]!=rows[start]:
   out.append({'floor_min':start+1,'floor_max':i,'tables':rows[start]});start=i
 return out

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--pret',required=True);ap.add_argument('--new-era',default=str(Path(__file__).resolve().parents[1]));a=ap.parse_args()
 pret=Path(a.pret);root=Path(a.new_era);ddir=pret/'data/dungeon';mechanics=json.load(open(ddir/'dungeon_data.json'));byname={norm(x['name']):x for x in mechanics}
 zones=[]
 for p in (root/'Data/Zone').glob('*.json'):
  try:o=json.load(open(p))['Object'];zones.append({'id':p.stem,'name':o.get('Name',{}).get('DefaultText',''),'grounds':o.get('GroundMaps',[]),'segments':len(o.get('Segments',[]))})
  except Exception:pass
 rows=[]
 for f in sorted(ddir.glob('*/floor_id.json')):
  data=json.load(open(f));key=norm(f.parent.name);mech=byname.get(key)
  candidates=sorted(z['id'] for z in zones if key in norm(z['id']+' '+z['name']) or norm(z['id']+' '+z['name']) in key)
  floor_rows=data.get('tables',[])
  source_files=[f.relative_to(pret).as_posix()]
  for n in ('pokemon_found.json','main_data.inc'):
   if (f.parent/n).exists():source_files.append((f.parent/n).relative_to(pret).as_posix())
  rows.append({'canonical_id':mech['name'] if mech else 'DUNGEON_'+re.sub(r'(?<!^)(?=[A-Z])','_',f.parent.name).upper(),'source_directory':f.parent.name,'floor_count':len(floor_rows),'floor_groups':groups(floor_rows),'mechanics':mech,'source_files':source_files,'new_era_candidates':candidates,'status':'present_candidate' if candidates else 'missing_zone'})
 out={'schema':1,'authority':'pret/pmd-red','policy':'canonical baseline plus separately identified New Era extensions','dungeons':rows,'counts':{'canonical_directories':len(rows),'floors':sum(x['floor_count'] for x in rows),'with_new_era_candidate':sum(x['status']=='present_candidate' for x in rows),'missing_zone':sum(x['status']=='missing_zone' for x in rows)}}
 raw=json.dumps(out,indent=2,ensure_ascii=False)+'\n';out['matrix_sha256_without_self']=hashlib.sha256(raw.encode()).hexdigest();dest=root/'docs/canonical/red';dest.mkdir(parents=True,exist_ok=True);(dest/'dungeon_floor_reference.json').write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n')
 lines=['# PMD Red — matrice canonique des donjons','',f"Source unique : `pret/pmd-red/data/dungeon`.  **{out['counts']['canonical_directories']} ensembles, {out['counts']['floors']} étages.**",'', '| Donjon source | Étages | Groupes de tables | Zone New Era candidate | État |','|---|---:|---:|---|---|']
 for x in rows:lines.append(f"| {x['source_directory']} | {x['floor_count']} | {len(x['floor_groups'])} | {', '.join(x['new_era_candidates']) or '—'} | {x['status']} |")
 lines += ['','## Contrat de restauration','','Chaque entrée JSON conserve pour chaque étage les index `MainData`, `Pokemon`, `Traps`, `Items`, `KecleonShop`, `MonsterRoomItems` et `BuriedItems`, ainsi que les restrictions globales du donjon. Les ajouts New Era doivent être placés dans des segments/extensions distincts et ne doivent pas écraser cette base.','', 'Les Grounds d’entrée, relais et boss seront associés dans la matrice de migration suivante; les 27 scènes dungeon-backed restent bloquées tant que les blobs ROM légaux ne sont pas disponibles.']
 (dest/'DUNGEON_RESTORATION_AUDIT.md').write_text('\n'.join(lines)+'\n')
 print(json.dumps(out['counts']))
if __name__=='__main__':main()
