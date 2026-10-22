import json,sys,os
sys.path.insert(0,'.runtime-cache/pyenv')
from PIL import Image
root='.runtime-cache/nnv-official-structured/inventory/'
tex_dir='.runtime-cache/nnv-official-textures/'
spr=json.load(open(root+'Sprites.json'))
tpi=json.load(open(root+'TexturePageItems.json'))
names={}
for i,s in enumerate(spr):
    if s.get('Name'): names[s['Name']]=s
def ref(x):
    return x['$resourceRef']['index'] if x else None
texfiles=sorted(f for f in os.listdir(tex_dir) if f.endswith('.png'))
texcache={}
def page(i):
    if i not in texcache: texcache[i]=Image.open(tex_dir+texfiles[i]).convert('RGBA')
    return texcache[i]
def frame(sprname, fi=0):
    s=names[sprname]
    t=s.get('Textures') or []
    if fi>=len(t): return None
    item=tpi[ref(t[fi].get('Texture'))]
    p=page(ref(item['TexturePage']))
    sub=p.crop((item['SourceX'],item['SourceY'],item['SourceX']+item['SourceWidth'],item['SourceY']+item['SourceHeight']))
    canvas=Image.new('RGBA',(item['BoundingWidth'],item['BoundingHeight']),(0,0,0,0))
    canvas.paste(sub,(item['TargetX'],item['TargetY']))
    return canvas
if __name__=='__main__':
    out=sys.argv[1]
    os.makedirs(out,exist_ok=True)
    occ=json.load(open('NO_NAME_VILLAGE_ADAPTATION/reports/fauna-fix/fauna-occurrences.json'))
    inv=json.load(__import__('gzip').open('NO_NAME_VILLAGE_ADAPTATION/reports/environment-inventory.json.gz'))
    by={o['name']:o for o in inv['object_contracts']}
    rows=[]
    for n in occ['per_object']:
        o=by.get(n) or {}
        sp=(o.get('sprite') or {}).get('name')
        if not sp or sp not in names: print('MISS',n,sp); continue
        im=frame(sp)
        if im is None: print('NOFRAME',n,sp); continue
        im.save(f'{out}/{n}__{sp}.png')
        rows.append((n,sp,im.size,occ['per_object'][n]))
    for r in rows: print(r)
