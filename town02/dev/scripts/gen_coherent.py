#!/usr/bin/env python3
"""
Nouveau générateur de maps avec cohérence spatiale.
Prélève des régions contiguës de l'atlas source au lieu de mélanger aléatoirement.
"""
import json, copy, random

random.seed(42)

def load(path):
    with open(path, encoding='utf-8-sig') as f:
        return json.load(f)

def extract_regions(rsground_path, region_w, region_h):
    """Extrait des régions contiguës de la map source pour différents types de terrain."""
    d = load(rsground_path)
    tiles = d['Object']['Layers'][0]['Tiles']
    obs = d['Object'].get('obstacles', [])
    src_h, src_w = len(tiles), len(tiles[0])
    
    # Find the best contiguous regions for:
    # 1. Floor/open area (center of map, low blocked%)
    # 2. Wall/border (edge of map, high blocked%)
    # 3. Mixed (transition zone)
    
    regions = {}
    
    # Floor region: find the largest block of walkable area near center
    best_floor_x, best_floor_y = src_w//2 - region_w//2, src_h//2 - region_h//2
    # Clamp
    best_floor_x = max(0, min(src_w - region_w, best_floor_x))
    best_floor_y = max(0, min(src_h - region_h, best_floor_y))
    
    floor_tiles = []
    for y in range(best_floor_y, best_floor_y + region_h):
        row = []
        for x in range(best_floor_x, best_floor_x + region_w):
            row.append(copy.deepcopy(tiles[y][x]))
        floor_tiles.append(row)
    regions['floor'] = floor_tiles
    
    # Wall region: find the best border section
    # Try each edge, pick the one with most blocked tiles
    candidates = [
        ('top', 0, src_w//2 - region_w//2),
        ('left', src_h//2 - region_h//2, 0),
        ('right', src_h//2 - region_h//2, src_w - region_w),
        ('bottom', src_h - region_h, src_w//2 - region_w//2),
    ]
    best_wall = None
    best_blocked = -1
    for edge, wy, wx in candidates:
        wy = max(0, min(src_h - region_h, wy))
        wx = max(0, min(src_w - region_w, wx))
        blocked = 0
        for y in range(wy, wy + region_h):
            for x in range(wx, wx + region_w):
                if y < len(obs) and x < len(obs[y]) and obs[y][x].get('Tags', 0) != 0:
                    blocked += 1
        if blocked > best_blocked:
            best_blocked = blocked
            best_wall = (wy, wx)
    
    wall_tiles = []
    wy, wx = best_wall
    for y in range(wy, wy + region_h):
        row = []
        for x in range(wx, wx + region_w):
            row.append(copy.deepcopy(tiles[y][x]))
        wall_tiles.append(row)
    regions['wall'] = wall_tiles
    
    return regions

def build_map_from_regions(regions, template_path, output_path, map_w, map_h, biome, name, music):
    """Construit une map en utilisant des tuiles de régions contiguës."""
    d = load(template_path)
    o = d['Object']
    o['Name'] = {'DefaultText': name, 'LocalTexts': {'fr': name}}
    o['AssetName'] = output_path.replace('Data/Ground/','').replace('.rsground','')
    o['Music'] = music
    
    floor = regions['floor']
    wall = regions['wall']
    reg_h, reg_w = len(floor), len(floor[0])
    
    # Generate layers
    for layer in o['Layers']:
        new_tiles = []
        for y in range(map_h):
            row = []
            for x in range(map_w):
                margin = 3
                is_border = (x < margin or x >= map_w - margin or y < margin or y >= map_h - margin)
                
                if is_border:
                    # Use wall tiles, mapping position smoothly
                    wy = y % reg_h
                    wx = x % reg_w
                    row.append(copy.deepcopy(wall[wy][wx]))
                else:
                    # Use floor tiles with spatial continuity
                    fy = (y - margin) % (reg_h - 2*margin) + margin
                    fx = (x - margin) % (reg_w - 2*margin) + margin
                    # Clamp to region bounds
                    fy = min(fy, reg_h - 1)
                    fx = min(fx, reg_w - 1)
                    row.append(copy.deepcopy(floor[fy][fx]))
            new_tiles.append(row)
        layer['Tiles'] = new_tiles
    
    # Obstacles
    o['obstacles'] = []
    for y in range(map_h):
        row = []
        for x in range(map_w):
            margin = 3
            is_border = (x < margin or x >= map_w - margin or y < margin or y >= map_h - margin)
            is_blocked = is_border
            if biome == 'boss' and not is_border:
                is_blocked = (x == map_w//2 and map_h//2 - 3 <= y <= map_h//2 + 3) or \
                             (y == map_h//2 and map_w//2 - 3 <= x <= map_w//2 + 3)
            row.append({
                'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8},
                'Tags': 1 if is_blocked else 0
            })
        o['obstacles'].append(row)
    
    # Entities
    cx, cy = map_w * 8 // 2, map_h * 8 // 2
    def gobj(n, px, py, pw=32, ph=32):
        return {'EntName': n, 'Position': {'X': px, 'Y': py, 'Width': pw, 'Height': ph},
                'EntEnabled': True, 'EntOrder': 0, 'InteractOrder': 0, 'triggerType': 0}
    def marker(n, px, py):
        return {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'EntOrder': 0,
                'InteractOrder': 0, 'triggerType': 0,
                'Collider': {'X': px, 'Y': py, 'Width': 16, 'Height': 16}}
    
    spawner = {'Spawns': {'$type': 'System.Collections.Generic.List`1[[RogueEssence.Ground.GroundSpawner+GroundSpawn, RogueEssence]], System.Private.CoreLib', '$values': []}}
    
    if biome == 'midpoint':
        o['Entities'] = [{'Name': 'New EntLayer', 'Visible': True, 'MapChars': [], 'GroundObjects': [
            gobj('North_Exit', cx-16, 8, 32, 32),
            gobj('South_Exit', cx-16, map_h*8-40, 32, 32),
            gobj('Kangaskhan_Rock', cx-16, cy-16, 32, 32)],
            'Spawners': [copy.deepcopy(spawner) for _ in range(5)],
            'Markers': [marker('Main_Entrance_Marker', cx-8, cy+24)]}]
    elif biome == 'entrance':
        o['Entities'] = [{'Name': 'New EntLayer', 'Visible': True, 'MapChars': [], 'GroundObjects': [
            gobj('Dungeon_Entrance', cx-16, 20, 32, 32),
            gobj('Kangaskhan_Rock', cx-16, map_h*8-40, 32, 32)],
            'Spawners': [copy.deepcopy(spawner) for _ in range(5)],
            'Markers': [marker('Main_Entrance_Marker', cx-8, map_h*8-48)]}]
    elif biome == 'boss':
        o['Entities'] = [{'Name': 'New EntLayer', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
            'Spawners': [copy.deepcopy(spawner) for _ in range(5)],
            'Markers': [marker('Main_Entrance_Marker', cx-8, map_h*8-48)]}]
    
    with open(output_path, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, indent=2, ensure_ascii=False)

# ============================================================
print("=== GENERATION DE MAPS AVEC COHERENCE SPATIALE ===\n")

# 1. VAST STEPPE MIDPOINT
regions = extract_regions('Data/Ground/vast_steppe_entrance.rsground', 40, 30)
build_map_from_regions(regions, 'Data/Ground/vast_steppe_entrance.rsground',
    'Data/Ground/vast_steppe_midpoint.rsground', 40, 30, 'midpoint',
    'Relais de la Grande Steppe', 'Sky Peak Prairie.ogg')
print("OK vast_steppe_midpoint")

# 2. MOUNT WINDSWEPT MIDPOINT
regions = extract_regions('Data/Ground/mount_windswept_entrance.rsground', 40, 30)
build_map_from_regions(regions, 'Data/Ground/mount_windswept_entrance.rsground',
    'Data/Ground/mount_windswept_midpoint.rsground', 40, 30, 'midpoint',
    'Relais du Mont Venteux', 'Mt. Travail.ogg')
print("OK mount_windswept_midpoint")

# 3. CLOVEN RUINS ENTRANCE
regions = extract_regions('Data/Ground/gloomy_forest_entrance.rsground', 40, 30)
build_map_from_regions(regions, 'Data/Ground/gloomy_forest_entrance.rsground',
    'Data/Ground/cloven_ruins_entrance.rsground', 40, 30, 'entrance',
    'Entrée des Aegis Cave', 'In the Depths of the Pit.ogg')
print("OK cloven_ruins_entrance")

# 4. CLOVEN RUINS MIDPOINT
regions = extract_regions('Data/Ground/gloomy_forest_boss.rsground', 40, 30)
build_map_from_regions(regions, 'Data/Ground/gloomy_forest_boss.rsground',
    'Data/Ground/cloven_ruins_midpoint.rsground', 40, 30, 'midpoint',
    'Relais des Aegis Cave', 'In the Depths of the Pit.ogg')
print("OK cloven_ruins_midpoint")

# 5. CLOVEN RUINS BOSS
build_map_from_regions(regions, 'Data/Ground/gloomy_forest_boss.rsground',
    'Data/Ground/cloven_ruins_boss.rsground', 40, 30, 'boss',
    'Cœur des Aegis Cave', 'Boss Battle!.ogg')
print("OK cloven_ruins_boss")

print("\n5 maps generees avec coherence spatiale.")
