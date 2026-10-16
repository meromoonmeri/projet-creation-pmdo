"""Rejoue un build deja present, compare SHA256 fichiers et membres ORA sans timestamps.
Par defaut VJ21 seulement ; --all pour rejouer les quatre. Pas les ZIP/HTML de livraison.
"""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import sys
import zipfile
from source.maps_suite_v1.pipeline import ROOT

HERE=Path(__file__).resolve().parent
OUT=ROOT/'renders/suite_jaillissements_v2'


def snapshot(ident):
    c=json.loads((HERE/'maps'/ident/'config.json').read_text());d=OUT/ident
    paths=[d/n for n in ['calques','animation','review','masques','manifest.json',c['prefix']+'_calques.ora']]
    paths.append(ROOT/'.cache'/ident/c['namespace'])
    values={}
    for root in paths:
        for p in sorted(root.rglob('*')) if root.is_dir() else [root]:
            if not p.is_file() or '__pycache__' in p.parts or p.suffix=='.pyc':continue
            key=p.relative_to(ROOT).as_posix()
            if p.suffix=='.ora':
                with zipfile.ZipFile(p) as z:
                    for name in sorted(z.namelist()):values[key+'!'+name]=hashlib.sha256(z.read(name)).hexdigest()
            else:values[key]=hashlib.sha256(p.read_bytes()).hexdigest()
    return values


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--all',action='store_true');args=parser.parse_args()
    ids=[p.name for p in sorted((HERE/'maps').iterdir())] if args.all else ['vj21_chenal']
    report=[]
    for ident in ids:
        a=snapshot(ident);assert a
        subprocess.run([sys.executable,str(HERE/'build.py'),'--map',ident],cwd=ROOT,check=True,capture_output=True)
        b=snapshot(ident);diff=[p for p in sorted(a.keys()|b.keys()) if a.get(p)!=b.get(p)]
        report.append({'map':ident,'files_and_ora_members':len(a),'differences':diff})
        assert not diff,diff
    data={'tested_maps':report,'scope':'VJ21 seul par defaut, autres non rejoues sauf --all ; hors caches, ZIP, HTML et timestamps ORA'}
    (OUT/'reproducibilite.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(data,ensure_ascii=False,indent=2))

if __name__=='__main__':main()
