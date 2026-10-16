"""Lecteur indépendant des banques TLG1 ; pas une exécution de PMDO."""
from pathlib import Path
import hashlib
import json
import numpy as np
from PIL import Image
from source.entree_terres_volcaniques_v1.verify import load, decode_tile, reconstruct, reachable, require
from source.maps_suite_v1.pipeline import ROOT, module

HERE = Path(__file__).resolve().parent
OUT = ROOT/'renders'/HERE.name
STAGE = ROOT/'.cache'/HERE.name/HERE.name
NAMES = ['sol_complet','neige','ombres','berges','reliefs','lac_gele','profondeur','scintillements','flocons']


def verify(out=OUT, stage=STAGE):
    out,stage=Path(out),Path(stage)
    m=json.loads((out/'manifest.json').read_text())
    require(m['prefix']=='TLG1' and m['size_px']==[768,576] and m['grid_8px']==[96,72],'Dimensions/identite')
    require(not m['art_approved'] and not m['pmdo']['runtime_tested'] and not m['pmdo']['render_tested'],'Validation indue')
    require(hashlib.sha256((HERE/'config.json').read_bytes()).hexdigest()==m['config_sha256'],'Hash configuration')
    for item in m['raw_inputs']+[m['reference']]+m['extra_references']:
        require(hashlib.sha256((ROOT/item['file']).read_bytes()).hexdigest()==item['sha256'],'Hash source')
    require(hashlib.sha256((ROOT/m['pmdo']['template']).read_bytes()).hexdigest()==m['pmdo']['template_sha256'],'Hash gabarit')
    require([l['name'] for l in m['layers']]==NAMES,'Ordre calques')
    frames=[]
    for i,l in enumerate(m['layers']):
        require(l['phases']==(24 if i>=7 else 1) and l['ticks']==(5 if i>=7 else 60),'Cadence PNG')
        group=[load(out/l['file'].replace('NN',f'{t:02d}')) for t in range(l['phases'])]
        for a in group:
            require(a.shape==(576,768,4) and set(np.unique(a[...,3]))<={0,255},'Format/alpha PNG')
            require(not a[a[...,3]==0].any(),'RGB sous alpha nul')
            require(not ((a[...,0]>170)&(a[...,2]>170)&(a[...,1]<100)).any(),'Fuite magenta')
        frames.append(group)
    require((frames[0][0][...,3]==255).all(),'Support troue')
    masks=[f[0][...,3]>0 for f in frames[1:7]]
    require((np.stack(masks).sum(0)==1).all(),'Partition terrain')
    for name,mask in zip(NAMES[1:7],masks):
        require(np.array_equal(np.array(Image.open(out/f'masques/TLG1_{name}.png'))>0,mask),'Masque terrain divergent')
    lake=masks[4];walk=masks[0]|masks[1]|lake
    require(lake.sum()>100000,'Lac absent ou trop petit')
    blocked=(~walk).reshape(72,8,96,8).mean((1,3))>.25
    require(blocked[0].all() and blocked[:,0].all() and blocked[:,-1].all(),'Bords praticables')
    require(np.array_equal(np.array(Image.open(out/'masques/TLG1_praticable.png'))>0,walk),'Masque praticable')
    require(np.array_equal(np.array(Image.open(out/'masques/TLG1_collisions.png'))>0,blocked),'Masque collisions')
    require(not m['access']['warp'] and not m['access']['destination_linked'],'Warp inattendu')
    marks=m['access']['markers']
    require(set(marks)=={'entrance','donjon_seuil'} and marks['entrance'][1]>=552 and marks['donjon_seuil'][0]>620 and marks['donjon_seuil'][1]<150,'Acces sud/nord-est')
    require(reachable(blocked,marks['entrance'],marks['donjon_seuil']),'Acces16px coupe')
    ref=np.array(Image.open(ROOT/m['reference']['file']).convert('RGB'))
    rip_colors={tuple(c) for c in np.unique(ref.reshape(-1,3),axis=0)}
    for idx,kind in [(7,'glints'),(8,'snow')]:
        require(m[kind]['phases']==24 and m[kind]['ticks']==5,'Cadence effets')
        require(all(tuple(c) in rip_colors for c in m[kind]['colors']),'Palette effet hors rip')
        for t,a in enumerate(frames[idx]):
            use=a[...,3]>0
            require(0<use.sum()<160,'Effet vide/envahissant')
            require(all(tuple(c) in rip_colors for c in np.unique(a[use,:3],axis=0)),'Couleur effet hors rip')
            if idx==7:require(not use[~lake].any(),'Scintillement hors lac gele')
            require(not np.array_equal(a,frames[idx][(t+1)%24]),'Animation figee')
    doc=json.loads((stage/f'Data/Ground/{m["pmdo"]["asset"]}.rsground').read_text());g=doc['Object']
    require(doc['Version']=='0.8.12.0' and g['TexSize']==1 and g['AssetName']==m['pmdo']['asset'],'Format Ground')
    require(len(g['Layers'])==10 and g['Layers'][-1]['Layer']==4,'Top absent')
    require(all(not cell['Layers'] for col in g['Layers'][-1]['Tiles'] for cell in col),'Top non vide')
    require(not g['Background']['Layers'] and g['Music']=='','References heritees')
    entities=g['Entities'];require(len(entities)==1 and all(not entities[0][k] for k in ('MapChars','GroundObjects','Spawners')),'Entites heritees')
    require({x['EntName']:[x['Collider']['X'],x['Collider']['Y']] for x in entities[0]['Markers']}==marks and len(entities[0]['Markers'])==2,'Marqueurs divergents')
    require(all(x['Collider']['Width']==16 and x['Collider']['Height']==16 for x in entities[0]['Markers']),'Taille marqueurs')
    require(len(g['obstacles'])==96 and all(len(col)==72 for col in g['obstacles']),'Dimensions collisions')
    for x,col in enumerate(g['obstacles']):
        for y,cell in enumerate(col):
            require(cell['Tags']==int(blocked[y,x]) and cell['Bounds']=={'X':x*8,'Y':y*8,'Width':8,'Height':8},'Collision native divergente')
    banks={p.stem:decode_tile(p) for p in (stage/'Content/Tile').glob('*.tile')}
    require(len(banks)==9 and all(x.startswith('TLG1_') for x in banks),'Banques heritees')
    reader=module(ROOT/'source/pmdo_cote/INSTALLER.py','tlg1_index_reader');idx=reader.read_index(stage/'Content/Tile/index.idx')
    require(set(idx)==set(banks),'Index incomplet')
    for name,node in idx.items():
        with (stage/f'Content/Tile/{name}.tile').open('rb') as f:require(node==reader.read_node(f),'Index divergent')
    count=0
    for i,(l,group) in enumerate(zip(m['layers'],frames)):
        for col in g['Layers'][i]['Tiles']:
            for cell in col:
                for sub in cell['Layers']:require(sub['FrameLength']==l['ticks'],'Cadence native divergente')
        for t,a in enumerate(group):
            require(np.array_equal(reconstruct(g['Layers'][i],banks,t),a),f'Reconstruction differente {l["name"]}/{t}')
            count+=1
    im=Image.new('RGBA',(768,576))
    for group in frames:im.alpha_composite(Image.fromarray(group[0]))
    require(np.array_equal(im,load(out/'review/TLG1_scene_t000.png')),'Scene differente')
    require(m['scene_loop_ticks']==120 and all(v['distance']<35 for f in m['fidelity'].values() for v in f.values()),'Boucle/diagnostic')
    return {'passed':True,'native_reconstructions':count,'layers':9,'banks':9,'clearance_px':16,'runtime_tested':False,'render_tested':False}


if __name__=='__main__':
    print(json.dumps(verify(),indent=2))
