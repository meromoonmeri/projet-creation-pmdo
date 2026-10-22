#!/usr/bin/env python3
"""Maps finales : bordures organiques + decorations + rendu PNG."""
import json, struct, io, copy, random, math, os
from PIL import Image, ImageDraw
random.seed(42)

def decode_tile(path):
    with open(path, 'rb') as f: data = f.read()
    tc = struct.unpack_from('<I', data, 4)[0]
    idx, pos = {}, 8
    for _ in range(tc):
        k = struct.unpack_from('<Q', data, pos)[0]
        off = struct.unpack_from('<Q', data, pos+8)[0]
        idx[(k & 0xFFFFFFFF, k >> 32)] = off
        pos += 16
    tiles = {}
    for (x, y), off in idx.items():
        if off not in tiles:
            pl = struct.unpack_from('<Q', data, off)[0]
            tiles[(x, y)] = Image.open(io.BytesIO(data[off+8:off+8+pl]))
    return tiles

def extract(path):
    with open(path, encoding='utf-8-sig') as f: d = json.load(f)
    tiles = d['Object']['Layers'][0]['Tiles']
    obs = d['Object'].get('obstacles', [])
    h, w = len(tiles), len(tiles[0])
    fl, wl = {}, {}
    for y in range(h):
        for x in range(w):
            t = tiles[y][x]; sh = ''; tl = (0, 0)
            for ly in t.get('Layers', []):
                for fr in ly.get('Frames', []):
                    sh = fr.get('Sheet', '')
                    tld = fr.get('TexLoc', {})
                    tl = (tld.get('X', 0), tld.get('Y', 0))
            blk = y < len(obs) and x < len(obs[y]) and obs[y][x].get('Tags', 0) != 0
            (wl if blk else fl)[tl] = sh
    return fl, wl

def gen(out_path, fl, wl, tw, th, biome, name, music):
    # Use a simple template (any rsground works, we just need its structure)
    template = 'Data/Ground/vast_steppe_entrance.rsground'
    with open(template, encoding='utf-8-sig') as f: d = json.load(f)
    o = d['Object']
    o['Name'] = {'DefaultText': name, 'LocalTexts': {'fr': name}}
    o['AssetName'] = out_path.replace('Data/Ground/','').replace('.rsground','')
    o['Music'] = music
    
    fll = list(fl.items()); wll = list(wl.items())
    
    # Perlin-like noise
    noise = [[0.0]*tw for _ in range(th)]
    for y in range(th):
        for x in range(tw):
            noise[y][x] = (math.sin(x*0.6+1.7)*math.cos(y*0.5+2.3)*0.5 +
                          math.sin(x*0.3+y*0.4)*0.3 + math.cos(x*0.8-y*0.3)*0.2)
    
    def bdist(x, y):
        d = min(x, tw-1-x, y, th-1-y)
        return d + noise[y][x] * 2.5
    
    bthresh = 2.2 + (1.0 if biome == 'boss' else 0.0)
    
    for layer in o['Layers']:
        nt = []
        for y in range(th):
            row = []
            for x in range(tw):
                d = bdist(x, y)
                if d < bthresh:
                    i = (x*17+y*23) % len(wll)
                    tl, sh = wll[i]
                elif biome == 'boss' and d > 4 and abs(x-tw//2)<=2 and abs(y-th//2)<=2:
                    i = (x*31+y*19) % len(wll); tl, sh = wll[i]
                elif biome == 'boss' and d > 5 and random.random() < 0.06:
                    i = (x*41+y*29) % len(wll); tl, sh = wll[i]
                elif biome == 'midpoint' and d > 5 and random.random() < 0.03:
                    i = (x*53+y*37) % len(wll); tl, sh = wll[i]
                else:
                    i = (x*11+y*17) % len(fll); tl, sh = fll[i]
                row.append({
                    'AutoTileset':'','Associates':[],
                    'Layers':[{'Frames':[{'Sheet':sh,'TexLoc':{'X':tl[0],'Y':tl[1]}}],'FrameLength':60}],
                    'NeighborCode':-1
                })
            nt.append(row)
        layer['Tiles'] = nt
    
    o['obstacles'] = []
    for y in range(th):
        row = []
        for x in range(tw):
            d = bdist(x, y)
            blk = d < bthresh
            if biome == 'boss' and not blk:
                if abs(x-tw//2)<=2 and abs(y-th//2)<=2: blk = True
                elif random.random()<0.05 and d>5: blk = True
            elif biome == 'midpoint' and not blk:
                if random.random()<0.02 and d>5: blk = True
            row.append({'Bounds':{'X':x*8,'Y':y*8,'Width':8,'Height':8},'Tags':1 if blk else 0})
        o['obstacles'].append(row)
    
    decos = []
    for y in range(th):
        for x in range(tw):
            d = bdist(x, y)
            if d > bthresh + 1.5 and random.random() < 0.04:
                i = (x*71+y*43) % len(fll); tl, sh = fll[i]
                decos.append({
                    '$type':'RogueEssence.Ground.GroundAnim, RogueEssence',
                    'Anim':{'AnimIndex':'','FrameTime':1,'StartFrame':-1,'EndFrame':-1,'AnimDir':-1,'Alpha':200,'AnimFlip':0},
                    'Loc':{'X':x*8,'Y':y*8},'EntirePlacement':False
                })
    
    o['Decorations'] = [{'Name':'New Deco','Layer':0,'Visible':True,'Anims':{'$values':decos}}]
    
    cx, cy = tw*8//2, th*8//2
    def gobj(n,px,py,pw=32,ph=32):
        return {'EntName':n,'Position':{'X':px,'Y':py,'Width':pw,'Height':ph},'EntEnabled':True,'EntOrder':0,'InteractOrder':0,'triggerType':0}
    def mkr(n,px,py):
        return {'EntName':n,'Direction':4,'EntEnabled':True,'EntOrder':0,'InteractOrder':0,'triggerType':0,'Collider':{'X':px,'Y':py,'Width':16,'Height':16}}
    sp = {'Spawns':{'$type':'System.Collections.Generic.List`1[[RogueEssence.Ground.GroundSpawner+GroundSpawn, RogueEssence]], System.Private.CoreLib','$values':[]}}
    
    if biome == 'midpoint':
        o['Entities'] = [{'Name':'New EntLayer','Visible':True,'MapChars':[],'GroundObjects':[gobj('North_Exit',cx-16,8),gobj('South_Exit',cx-16,th*8-40),gobj('Kangaskhan_Rock',cx-16,cy-16)],'Spawners':[copy.deepcopy(sp) for _ in range(5)],'Markers':[mkr('Main_Entrance_Marker',cx-8,cy+24)]}]
    elif biome == 'entrance':
        o['Entities'] = [{'Name':'New EntLayer','Visible':True,'MapChars':[],'GroundObjects':[gobj('Dungeon_Entrance',cx-16,20),gobj('Kangaskhan_Rock',cx-16,th*8-40)],'Spawners':[copy.deepcopy(sp) for _ in range(5)],'Markers':[mkr('Main_Entrance_Marker',cx-8,th*8-48)]}]
    elif biome == 'boss':
        o['Entities'] = [{'Name':'New EntLayer','Visible':True,'MapChars':[],'GroundObjects':[],'Spawners':[copy.deepcopy(sp) for _ in range(5)],'Markers':[mkr('Main_Entrance_Marker',cx-8,th*8-48)]}]
    
    with open(out_path, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, indent=2, ensure_ascii=False)
    
    # Verif que le fichier est valide
    with open(out_path, encoding='utf-8-sig') as f:
        json.load(f)
    
    return len(decos)

def render2(rsground_path, output_png):
    with open(rsground_path, encoding='utf-8-sig') as f: d = json.load(f)
    tiles = d['Object']['Layers'][0]['Tiles']
    h, w = len(tiles), len(tiles[0])
    sh = ''
    for ly in tiles[h//2][w//2].get('Layers',[]):
        for fr in ly.get('Frames',[]): sh = fr.get('Sheet','')
    atlas = decode_tile(f'Content/Tile/{sh}.tile')
    img = Image.new('RGBA', (w*8, h*8), (0,0,0,0))
    for y in range(h):
        for x in range(w):
            tl = (0,0)
            for ly in tiles[y][x].get('Layers',[]):
                for fr in ly.get('Frames',[]):
                    tld = fr.get('TexLoc',{}); tl = (tld.get('X',0), tld.get('Y',0))
            ti = atlas.get(tl)
            if ti: img.paste(ti, (x*8, y*8))
    draw = ImageDraw.Draw(img)
    ents = d['Object'].get('Entities',[])
    if ents:
        for gobj in ents[0].get('GroundObjects', []):
            p = gobj.get('Position', {}); px, py = p.get('X',0), p.get('Y',0)
            nm = gobj.get('EntName','')
            if 'Exit' in nm: col = (255,255,0)
            elif 'Rock' in nm: col = (0,255,255)
            elif 'Entrance' in nm: col = (0,255,0)
            else: col = (255,0,0)
            draw.rectangle([px, py, px+32, py+32], outline=col, width=2)
        for m in ents[0].get('Markers', []):
            c = m.get('Collider', {}); mx, my = c.get('X',0), c.get('Y',0)
            draw.ellipse([mx, my, mx+16, my+16], outline=(255,0,255), width=2)
    img.save(output_png)
    return sh, w, h

# ============================================================
if __name__ == '__main__':
    print("=== MAPS FINALES ===\n")
    specs = [
        ('vast_steppe_midpoint', 'Data/Ground/vast_steppe_entrance.rsground', 'midpoint', 'Relais Grande Steppe', 'Sky Peak Prairie.ogg'),
        ('mount_windswept_midpoint', 'Data/Ground/mount_windswept_entrance.rsground', 'midpoint', 'Relais Mont Venteux', 'Mt. Travail.ogg'),
        ('cloven_ruins_entrance', 'Data/Ground/gloomy_forest_entrance.rsground', 'entrance', 'Entree Aegis Cave', 'In the Depths of the Pit.ogg'),
        ('cloven_ruins_midpoint', 'Data/Ground/gloomy_forest_boss.rsground', 'midpoint', 'Relais Aegis Cave', 'In the Depths of the Pit.ogg'),
        ('cloven_ruins_boss', 'Data/Ground/gloomy_forest_boss.rsground', 'boss', 'Coeur Aegis Cave', 'Boss Battle!.ogg'),
    ]
    
    for name, src, biome, title, music in specs:
        fl, wl = extract(src)
        nd = gen(f'Data/Ground/{name}.rsground', fl, wl, 40, 30, biome, title, music)
        sh, pw, ph = render2(f'Data/Ground/{name}.rsground', f'{name}.png')
        print(f"  {name}: {sh} {pw}x{ph}, {len(fl)}+{len(wl)} tiles, {nd} decos")
    
    print("\n✅ Done")
