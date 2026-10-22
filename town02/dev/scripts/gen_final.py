#!/usr/bin/env python3
"""Maps finales V4 : bordures organiques + decorations. Fichier autonome."""
import json as js
import struct, io, copy, random, math
from PIL import Image, ImageDraw
random.seed(42)

def load_atlas(path):
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

def extract_catalog(src_path):
    with open(src_path, encoding='utf-8-sig') as f: d = js.load(f)
    tiles = d['Object']['Layers'][0]['Tiles']
    obs = d['Object'].get('obstacles', [])
    h, w = len(tiles), len(tiles[0])
    floor_cat, wall_cat = {}, {}
    for y in range(h):
        for x in range(w):
            t = tiles[y][x]; sheet = ''; texloc = (0, 0)
            for ly in t.get('Layers', []):
                for fr in ly.get('Frames', []):
                    sheet = fr.get('Sheet', '')
                    tld = fr.get('TexLoc', {})
                    texloc = (tld.get('X', 0), tld.get('Y', 0))
            blocked = y < len(obs) and x < len(obs[y]) and obs[y][x].get('Tags', 0) != 0
            (wall_cat if blocked else floor_cat)[texloc] = sheet
    return floor_cat, wall_cat

def gen_map(template_path, output_path, floor_cat, wall_cat, tw, th, biome_type, map_name, music):
    with open(template_path, encoding='utf-8-sig') as f: data = js.load(f)
    obj = data['Object']
    obj['Name'] = {'DefaultText': map_name, 'LocalTexts': {'fr': map_name}}
    obj['AssetName'] = output_path.replace('Data/Ground/','').replace('.rsground','')
    obj['Music'] = music
    
    floor_list = list(floor_cat.items())
    wall_list = list(wall_cat.items())
    
    # Precompute noise grid
    noise_grid = [[0.0]*tw for _ in range(th)]
    for y in range(th):
        for x in range(tw):
            noise_grid[y][x] = (math.sin(x*0.6+1.7)*math.cos(y*0.5+2.3)*0.5 +
                               math.sin(x*0.3+y*0.4)*0.3 + math.cos(x*0.8-y*0.3)*0.2)
    
    def border_dist(x, y):
        d = min(x, tw-1-x, y, th-1-y)
        return d + noise_grid[y][x] * 2.5
    
    border_min = 2.2
    if biome_type == 'boss':
        border_min += 1.0
    
    # Build tiles for each layer
    for layer in obj['Layers']:
        new_tiles = []
        for y in range(th):
            row = []
            for x in range(tw):
                d = border_dist(x, y)
                
                if d < border_min:
                    idx = (x*17 + y*23) % len(wall_list)
                    texloc, sheet = wall_list[idx]
                elif biome_type == 'boss' and d > 4 and abs(x-tw//2)<=2 and abs(y-th//2)<=2:
                    idx = (x*31 + y*19) % len(wall_list)
                    texloc, sheet = wall_list[idx]
                elif biome_type == 'boss' and d > 5 and random.random() < 0.06:
                    idx = (x*41 + y*29) % len(wall_list)
                    texloc, sheet = wall_list[idx]
                elif biome_type == 'midpoint' and d > 5 and random.random() < 0.03:
                    idx = (x*53 + y*37) % len(wall_list)
                    texloc, sheet = wall_list[idx]
                else:
                    idx = (x*11 + y*17) % len(floor_list)
                    texloc, sheet = floor_list[idx]
                
                row.append({
                    'AutoTileset': '', 'Associates': [],
                    'Layers': [{'Frames': [{'Sheet': sheet,
                        'TexLoc': {'X': texloc[0], 'Y': texloc[1]}}],
                        'FrameLength': 60}],
                    'NeighborCode': -1
                })
            new_tiles.append(row)
        layer['Tiles'] = new_tiles
    
    # Obstacles
    obj['obstacles'] = []
    for y in range(th):
        row = []
        for x in range(tw):
            d = border_dist(x, y)
            blocked = d < border_min
            if biome_type == 'boss' and not blocked:
                if abs(x-tw//2)<=2 and abs(y-th//2)<=2:
                    blocked = True
                elif random.random() < 0.05 and d > 5:
                    blocked = True
            elif biome_type == 'midpoint' and not blocked:
                if random.random() < 0.02 and d > 5:
                    blocked = True
            row.append({
                'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8},
                'Tags': 1 if blocked else 0
            })
        obj['obstacles'].append(row)
    
    # Decorations
    deco_list = []
    for y in range(th):
        for x in range(tw):
            d = border_dist(x, y)
            if d > border_min + 1.5 and random.random() < 0.04:
                idx = (x*71 + y*43) % len(floor_list)
                texloc, sheet = floor_list[idx]
                deco_list.append({
                    '$type': 'RogueEssence.Ground.GroundAnim, RogueEssence',
                    'Anim': {'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1,
                             'EndFrame': -1, 'AnimDir': -1, 'Alpha': 200, 'AnimFlip': 0},
                    'Loc': {'X': x*8, 'Y': y*8},
                    'EntirePlacement': False
                })
    
    obj['Decorations'] = [{
        'Name': 'New Deco', 'Layer': 0, 'Visible': True,
        'Anims': {'$values': deco_list}
    }]
    
    # Entities
    cx, cy = tw*8//2, th*8//2
    
    def make_obj(nm, px, py, pw=32, ph=32):
        return {'EntName': nm,
                'Position': {'X': px, 'Y': py, 'Width': pw, 'Height': ph},
                'EntEnabled': True, 'EntOrder': 0, 'InteractOrder': 0, 'triggerType': 0}
    
    def make_marker(nm, px, py):
        return {'EntName': nm, 'Direction': 4, 'EntEnabled': True, 'EntOrder': 0,
                'InteractOrder': 0, 'triggerType': 0,
                'Collider': {'X': px, 'Y': py, 'Width': 16, 'Height': 16}}
    
    spawner_tpl = {
        'Spawns': {
            '$type': 'System.Collections.Generic.List`1[[RogueEssence.Ground.GroundSpawner+GroundSpawn, RogueEssence]], System.Private.CoreLib',
            '$values': []
        }
    }
    spawners = [copy.deepcopy(spawner_tpl) for _ in range(5)]
    
    if biome_type == 'midpoint':
        obj['Entities'] = [{
            'Name': 'New EntLayer', 'Visible': True, 'MapChars': [],
            'GroundObjects': [
                make_obj('North_Exit', cx-16, 8),
                make_obj('South_Exit', cx-16, th*8-40),
                make_obj('Kangaskhan_Rock', cx-16, cy-16)
            ],
            'Spawners': spawners,
            'Markers': [make_marker('Main_Entrance_Marker', cx-8, cy+24)]
        }]
    elif biome_type == 'entrance':
        obj['Entities'] = [{
            'Name': 'New EntLayer', 'Visible': True, 'MapChars': [],
            'GroundObjects': [
                make_obj('Dungeon_Entrance', cx-16, 20),
                make_obj('Kangaskhan_Rock', cx-16, th*8-40)
            ],
            'Spawners': spawners,
            'Markers': [make_marker('Main_Entrance_Marker', cx-8, th*8-48)]
        }]
    elif biome_type == 'boss':
        obj['Entities'] = [{
            'Name': 'New EntLayer', 'Visible': True, 'MapChars': [],
            'GroundObjects': [],
            'Spawners': spawners,
            'Markers': [make_marker('Main_Entrance_Marker', cx-8, th*8-48)]
        }]
    
    # Write
    json_text = js.dumps(data, indent=2, ensure_ascii=False)
    with open(output_path, 'w', encoding='utf-8-sig') as f:
        f.write(json_text)
    
    # Verify round-trip
    with open(output_path, encoding='utf-8-sig') as f:
        js.load(f)
    
    return len(deco_list)

def render_png(rsground_path, output_png):
    with open(rsground_path, encoding='utf-8-sig') as f:
        data = js.load(f)
    tiles = data['Object']['Layers'][0]['Tiles']
    h, w = len(tiles), len(tiles[0])
    
    # Find sheet from center tile
    sheet = ''
    mid_y, mid_x = h//2, w//2
    for ly in tiles[mid_y][mid_x].get('Layers', []):
        for fr in ly.get('Frames', []):
            sheet = fr.get('Sheet', '')
    
    atlas = load_atlas(f'Content/Tile/{sheet}.tile')
    img = Image.new('RGBA', (w*8, h*8), (0, 0, 0, 0))
    
    for y in range(h):
        for x in range(w):
            texloc = (0, 0)
            for ly in tiles[y][x].get('Layers', []):
                for fr in ly.get('Frames', []):
                    tld = fr.get('TexLoc', {})
                    texloc = (tld.get('X', 0), tld.get('Y', 0))
            tile_img = atlas.get(texloc)
            if tile_img:
                img.paste(tile_img, (x*8, y*8))
    
    # Draw entity overlays
    draw = ImageDraw.Draw(img)
    ents = data['Object'].get('Entities', [])
    if ents:
        for gobj in ents[0].get('GroundObjects', []):
            p = gobj.get('Position', {})
            px, py = p.get('X', 0), p.get('Y', 0)
            nm = gobj.get('EntName', '')
            if 'Exit' in nm: col = (255, 255, 0)
            elif 'Rock' in nm: col = (0, 255, 255)
            elif 'Entrance' in nm: col = (0, 255, 0)
            else: col = (255, 0, 0)
            draw.rectangle([px, py, px+32, py+32], outline=col, width=2)
        for m in ents[0].get('Markers', []):
            c = m.get('Collider', {})
            mx, my = c.get('X', 0), c.get('Y', 0)
            draw.ellipse([mx, my, mx+16, my+16], outline=(255, 0, 255), width=2)
    
    img.save(output_png)
    return sheet, w, h

# ============================================================
if __name__ == '__main__':
    print("=== MAPS FINALES AVEC BORDURES ORGANIQUES ===\n")
    
    configs = [
        ('vast_steppe_midpoint', 'Data/Ground/vast_steppe_entrance.rsground',
         'midpoint', 'Relais Grande Steppe', 'Sky Peak Prairie.ogg'),
        ('mount_windswept_midpoint', 'Data/Ground/mount_windswept_entrance.rsground',
         'midpoint', 'Relais Mont Venteux', 'Mt. Travail.ogg'),
        ('cloven_ruins_entrance', 'Data/Ground/gloomy_forest_entrance.rsground',
         'entrance', 'Entree Aegis Cave', 'In the Depths of the Pit.ogg'),
        ('cloven_ruins_midpoint', 'Data/Ground/gloomy_forest_boss.rsground',
         'midpoint', 'Relais Aegis Cave', 'In the Depths of the Pit.ogg'),
        ('cloven_ruins_boss', 'Data/Ground/gloomy_forest_boss.rsground',
         'boss', 'Coeur Aegis Cave', 'Boss Battle!.ogg'),
    ]
    
    for name, src, biome, title, music in configs:
        fcat, wcat = extract_catalog(src)
        nd = gen_map(src, f'Data/Ground/{name}.rsground', fcat, wcat, 40, 30, biome, title, music)
        sheet, pw, ph = render_png(f'Data/Ground/{name}.rsground', f'{name}.png')
        print(f"  {name}: {sheet} {pw}x{ph}px, {len(fcat)}+{len(wcat)} tiles, {nd} decos")
    
    print("\n✅ 5 PNGs generes.")
