"""Lecteur independant de la suite : pas le chargeur/restituteur PMDO."""
from pathlib import Path
import json
import hashlib
import numpy as np
from PIL import Image
from scipy import ndimage as nd
from source.maps_suite_v1.pipeline import ROOT, W, H, module
from source.entree_terres_volcaniques_v1.verify import load, decode_tile, reconstruct, reachable, require

HERE=Path(__file__).resolve().parent
OUT=ROOT/'renders/suite_jaillissements_v2'


def names_for(kind):
    return ['sol_complet','cendre','ombres','rebords','basalte']+(['profondeur'] if kind=='entrance' else [])+['lave','braises','colonnes','jaillissements','projections']


def verify(ident, out=None, stage=None):
    source=HERE/'maps'/ident
    c=json.loads((source/'config.json').read_text())
    out=Path(out) if out else OUT/ident
    stage=Path(stage) if stage else ROOT/'.cache'/ident/c['namespace']
    m=json.loads((out/'manifest.json').read_text())
    require(m['prefix']==c['prefix'] and m['size_px']==[768,576] and m['grid_8px']==[96,72],'Identite')
    require(m['config_sha256']==hashlib.sha256((source/'config.json').read_bytes()).hexdigest(),'Config')
    require(not m['art_approved'] and not m['pmdo']['runtime_tested'] and not m['pmdo']['render_tested'],'Validation indue')
    for p in m['raw_inputs']+[m['reference'],m['column_sprite']]:
        require(hashlib.sha256((ROOT/p['file']).read_bytes()).hexdigest()==p['sha256'],'Hash source')
    require(m['base_recipe_sha256']==hashlib.sha256((ROOT/'source/entree_terres_volcaniques_v1/build.py').read_bytes()).hexdigest(),'Recette source modifiee')
    require(m['column_prep_sha256']==hashlib.sha256((ROOT/'source/arene_groudon_magma_v3/colonnes_generees.py').read_bytes()).hexdigest(),'Preparation source modifiee')
    names=names_for(c['kind']);require([l['name'] for l in m['layers']]==names,'Calques')
    stack=[]
    for info in m['layers']:
        expected=24 if info['name'] in ('lave','braises','colonnes','jaillissements','projections') else 1
        require(info['phases']==expected and info['ticks']==(5 if expected==24 else 60),'Cadence')
        frames=[load(out/info['file'].replace('NN',f'{t:02d}')) for t in range(expected)]
        for a in frames:
            require(a.shape==(576,768,4),'Dimensions PNG')
            require(set(np.unique(a[...,3]))<={0,255} and not a[a[...,3]==0].any(),'Alpha/RGB')
            r,g,b=a[...,:3].astype(float).transpose(2,0,1)
            require(not ((r>70)&(b>70)&(r>1.45*g)&(b>1.45*g)).any(),'Magenta')
        stack.append(frames)
    require((stack[0][0][...,3]==255).all(),'Support incomplet')
    terrain=stack[1:names.index('lave')+1]
    masks=[x[0][...,3]>0 for x in terrain]
    require((np.stack(masks).sum(0)==1).all(),'Partition')
    walk=masks[0]|masks[1];lava=masks[-1]
    blocked=(~walk).reshape(72,8,96,8).mean((1,3))>.25
    require(not (walk&lava).any() and blocked[0].all() and blocked[:,0].all() and blocked[:,-1].all(),'Bords ou lave praticable')
    require(np.array_equal(blocked,np.array(Image.open(out/f'{"masques"}/{c["prefix"]}_collisions.png'))>0),'Collisions PNG')
    marks=m['access']['markers'];expected={'entrance','donjon_seuil'} if c['kind']=='entrance' else {'entrance','boss','objectif'}
    require(set(marks)==expected and marks['entrance'][1]>=552,'Marqueurs')
    for name,p in marks.items():require(reachable(blocked,marks['entrance'],p),'Acces16px')
    require(not m['access']['warp'] and not m['access']['destination_linked'],'Warp')
    body,crown,drops=stack[-3:]
    require(len(m['columns'])==4,'Nombre colonnes')
    for col in m['columns']:
        x,y=col['x'],col['y'];require(lava[y,x],'Bouche hors lave')
        for frame in body:
            # Il reste de la matiere sur chaque ligne jusqu'a la bouche, sommet hors cadre.
            band=frame[:y+1,max(0,x-45):min(W,x+46),3]>0
            require(band[0].sum()>=8 and band.any(1).all(),'Sommet visible ou corps interrompu')
    for frames,allowed in [(body,~walk),(crown,lava),(drops,~walk)]:
        require(all((a[...,3]>0).sum()>0 for a in frames),'Jet vide')
        require(all(not (a[...,3]>0)[~allowed].any() for a in frames),'Jet sur passage')
        require(all(not np.array_equal(frames[t],frames[(t+1)%24]) for t in range(24)),'Jet fige')
    lf=stack[names.index('lave')];rim=lava&~nd.binary_erosion(lava,iterations=3)
    for a in lf:
        require(np.array_equal(a[...,3]>0,lava) and np.array_equal(a[rim],lf[0][rim]),'Rive lave mobile')
    ground=json.loads((stage/f'Data/Ground/{c["asset"]}.rsground').read_text())
    g=ground['Object'];require(ground['Version']=='0.8.12.0' and g['TexSize']==1 and g['AssetName']==c['asset'],'Ground')
    require(len(g['Layers'])==len(names)+1 and g['Layers'][-1]['Layer']==4,'Top')
    require(all(not cell['Layers'] for col in g['Layers'][-1]['Tiles'] for cell in col),'Top non vide')
    require(g['Music']=='' and not g['Background']['Layers'],'References heritees')
    require(len(g['Entities'])==1 and all(not g['Entities'][0][k] for k in ['MapChars','GroundObjects','Spawners']),'Entites')
    gm={p['EntName']:[p['Collider']['X'],p['Collider']['Y']] for p in g['Entities'][0]['Markers']}
    require(gm==marks and len(g['Entities'][0]['Markers'])==len(marks),'Marqueurs Ground')
    for x,col in enumerate(g['obstacles']):
        for y,cell in enumerate(col):require(cell['Tags']==int(blocked[y,x]),'Collisions Ground')
    banks={p.stem:decode_tile(p) for p in (stage/'Content/Tile').glob('*.tile')}
    require(len(banks)==len(names) and all(n.startswith(c['prefix']+'_') for n in banks),'Banques')
    installer=module(ROOT/'source/pmdo_cote/INSTALLER.py','svj2_index_reader')
    idx=installer.read_index(stage/'Content/Tile/index.idx');require(set(idx)==set(banks),'Index')
    total=0
    for li,(info,frames) in enumerate(zip(m['layers'],stack)):
        for col in g['Layers'][li]['Tiles']:
            for cell in col:
                for sub in cell['Layers']:require(sub['FrameLength']==info['ticks'],'Cadence Ground')
        for t,a in enumerate(frames):
            require(np.array_equal(a,reconstruct(g['Layers'][li],banks,t)),'Reconstruction '+info['name'])
            total+=1
    scene=Image.new('RGBA',(W,H))
    for frames in stack:scene.alpha_composite(Image.fromarray(frames[0]))
    require(np.array_equal(np.array(scene),load(out/f'review/{c["prefix"]}_scene_t000.png')),'Scene')
    require(all(v['distance']<35 for stage in m['fidelity'].values() for v in stage.values()),'Couleurs')
    return {'passed':True,'map':ident,'native_reconstructions':total,'banks':len(banks),'columns':4,
            'top_never_visible':True,'runtime_tested':False,'render_tested':False}


if __name__=='__main__':
    for p in sorted((HERE/'maps').iterdir()):print(json.dumps(verify(p.name)))
