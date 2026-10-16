"""Fusion d'un projet a quatre Ground, tests puis deux ZIP et galerie relative."""
from pathlib import Path
import json
import shutil
import sys
import unittest
import xml.etree.ElementTree as ET
import zipfile
import numpy as np
from PIL import Image
from source.maps_suite_v1.pipeline import ROOT, module

HERE=Path(__file__).resolve().parent
OUT=ROOT/'renders/suite_jaillissements_v2'
STAGE=ROOT/'.cache/suite_jaillissements_v2/suite_jaillissements_v2'


def merge():
    shutil.rmtree(STAGE,ignore_errors=True);STAGE.mkdir(parents=True)
    ids=sorted(p.name for p in (HERE/'maps').iterdir())
    installer=None
    for ident in ids:
        c=json.loads((HERE/'maps'/ident/'config.json').read_text());src=ROOT/'.cache'/ident/c['namespace']
        for p in src.rglob('*'):
            if not p.is_file() or '__pycache__' in p.parts or p.suffix=='.pyc':continue
            rel=p.relative_to(src)
            if rel.as_posix() in ['Mod.xml','README.md','Content/Tile/index.idx']:continue
            dest=STAGE/rel;dest.parent.mkdir(parents=True,exist_ok=True)
            if dest.exists():assert dest.read_bytes()==p.read_bytes(),rel
            else:shutil.copyfile(p,dest)
        if installer is None:
            tree=ET.parse(src/'Mod.xml');tree.getroot().find('Name').text='Fournaises : quatre cartes et jets de magma — SVJ2'
            tree.getroot().find('Description').text='Quatre Ground generes references. Jets hors cadre. Aucun warp. Moteur non teste.'
            tree.write(STAGE/'Mod.xml',encoding='utf-8',xml_declaration=True)
            installer=module(src/'INSTALLER.py','svj2_merge_index')
    nodes={}
    for p in sorted((STAGE/'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:nodes[p.stem]=installer.read_node(f)
    assert len(nodes)==43
    (STAGE/'Content/Tile/index.idx').write_bytes(installer.encode_index(nodes))
    shutil.copyfile(HERE/'README.md',STAGE/'README.md')
    return ids


def archive(path,items):
    with zipfile.ZipFile(path,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for p,name in sorted(items,key=lambda a:a[1]):z.write(p,name)
    with zipfile.ZipFile(path) as z:
        assert z.testzip() is None and len(z.namelist())==len(set(z.namelist()))
        assert not any('__pycache__' in n or n.endswith('.pyc') for n in z.namelist())
    return {'file':path.name,'bytes':path.stat().st_size,'members':len(items),'crc_ok':True}


def main():
    ids=merge()
    from source.suite_jaillissements_v2 import test_build
    suite=unittest.defaultTestLoader.loadTestsFromModule(test_build)
    result=unittest.TextTestRunner(stream=sys.stdout,verbosity=2).run(suite)
    tests={'passed':result.wasSuccessful(),'tests':result.testsRun,'failures':len(result.failures),'errors':len(result.errors)}
    (OUT/'tests.json').write_text(json.dumps(tests,indent=2)+'\n')
    if not result.wasSuccessful():raise SystemExit('Tests echoues, pas de paquets livres')
    catalog=[];reports=[]
    for ident in ids:
        d=OUT/ident;m=json.loads((d/'manifest.json').read_text());pfx=m['prefix']
        report=json.loads((d/'verification.json').read_text());reports.append(report)
        shutil.copyfile(HERE/'maps'/ident/'README_PACK.md',d/'README.md')
        blocked=np.array(Image.open(d/f'masques/{pfx}_collisions.png'))>0;y,x=np.nonzero(blocked)
        catalog.append({'id':ident,'title':m['title'],'prefix':pfx,'kind':m['kind'],
                        'preview':f'{ident}/review/{pfx}_scene_t000.png',
                        'layers':m['layers'],'markers':m['access']['markers'],
                        'blocked':np.stack([x,y],axis=1).tolist(),'fidelity':m['fidelity']['sortie']})
    total={'passed':True,'maps':reports,'native_reconstructions':sum(r['native_reconstructions'] for r in reports),
           'banks':43,'tests':tests,'runtime_tested':False,'render_tested':False}
    (OUT/'verification.json').write_text(json.dumps(total,indent=2)+'\n')
    (OUT/'catalogue.json').write_text(json.dumps(catalog,ensure_ascii=False,separators=(',',':'))+'\n')
    shutil.copyfile(HERE/'viewer_template.html',OUT/'index.html')
    shutil.copyfile(HERE/'README.md',OUT/'README.md')
    project=archive(OUT/'SVJ2_projet_pmdo_0812.zip',[(p,'suite_jaillissements_v2/'+p.relative_to(STAGE).as_posix()) for p in STAGE.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.pyc'])
    files=[]
    for ident in ids:
        for p in (OUT/ident).rglob('*'):
            if p.is_file():files.append((p,p.relative_to(OUT).as_posix()))
    for name in ['README.md','verification.json','tests.json','reproducibilite.json']:
        p=OUT/name
        if p.exists():files.append((p,p.name))
    files.extend((p,'reference/'+p.name) for p in (HERE/'reference').iterdir() if p.is_file())
    files.append((HERE/'shared/colonne_magenta.png','sprite/colonne_magenta.png'))
    png=archive(OUT/'SVJ2_calques_png_8px.zip',files)
    (OUT/'paquets.json').write_text(json.dumps([project,png],indent=2)+'\n')
    print(json.dumps(total,indent=2));print(json.dumps([project,png],indent=2))

if __name__=='__main__':main()
