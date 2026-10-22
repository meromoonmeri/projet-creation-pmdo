#!/usr/bin/env python3
"""Génère les .rsground d'entrée pour les 3 nouvelles zones (Ch8-10).
Format PMDO/RogueEssence — JSON avec BOM UTF-8, TexSize:1 (8px).
Tuiles minimales : une salle de 20x15 avec le tileset du biome."""

import json, os

GROUND_DIR = "Data/Ground"

ZONES = [
    {
        "asset": "crystal_sanctuary_entrance",
        "name_fr": "Entrée du Sanctuaire de Cristal",
        "name_en": "Crystal Sanctuary Entrance",
        "tileset_main": "First_Core_Location_Base",
        "tileset_obj": "First_Core_Location_Objects",
        "tileset_shadow": "First_Core_Location_Shadows",
        "music": "Anima Core.ogg",
        "comment": "Chapter 8 — Crystal Sanctuary entrance. Crystal cave with glyphs.",
        "tiles_w": 24, "tiles_h": 18
    },
    {
        "asset": "forgotten_marsh_entrance",
        "name_fr": "Entrée du Marais de l'Oubli",
        "name_en": "Forgotten Marsh Entrance", 
        "tileset_main": "Altere_Pond_Base",
        "tileset_obj": "Altere_Pond_Objects",
        "tileset_shadow": "Altere_Pond_Shadows",
        "music": "Deep Dark Crater.ogg",
        "comment": "Chapter 9 — Forgotten Marsh entrance. Swamp with dead trees.",
        "tiles_w": 24, "tiles_h": 18
    },
    {
        "asset": "celestial_peak_entrance",
        "name_fr": "Entrée du Pic Céleste",
        "name_en": "Celestial Peak Entrance",
        "tileset_main": "Mount_Windswept_Base",
        "tileset_obj": "Mount_Windswept_Objects",
        "tileset_shadow": "Mount_Windswept_Shadows",
        "music": "Sky Peak Cave.ogg",
        "comment": "Chapter 10 — Celestial Peak entrance. Mountain base with open sky.",
        "tiles_w": 24, "tiles_h": 18
    }
]

def make_tile(sheet, x=0, y=0):
    return {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}], "FrameLength": 60}],
        "NeighborCode": -1
    }

def make_obstacle(x, y, w, h, tags=0):
    return {
        "$type": "RogueElements.TileBlock, RogueElements",
        "Color": "#FF000000",
        "Rectangle": {"X": x, "Y": y, "Width": w, "Height": h},
        "Tags": tags
    }

def generate_ground(zone):
    w, h = zone["tiles_w"], zone["tiles_h"]
    
    # Grille de tuiles — salle simple
    tile_row = [make_tile(zone["tileset_main"]) for _ in range(w)]
    
    # Quelques tuiles d'objets (décorations ponctuelles) pour casser la monotonie
    for col in range(2, w-2, 5):
        tile_row_col = tile_row.copy()
        tile_row_col[col] = make_tile(zone["tileset_obj"])
        tile_row_col[col+1] = make_tile(zone["tileset_obj"])
    
    # Layer rows
    rows = [tile_row.copy() for _ in range(h)]
    # Ajouter quelques objets décoratifs
    for row_idx in [3, h-4]:
        for col in range(3, w-3, 6):
            rows[row_idx][col] = make_tile(zone["tileset_obj"])
    
    # Obstacles : bordures de la salle (murs)
    obstacles = [
        # Mur nord
        make_obstacle(0, 0, w, 1, 1),
        # Mur sud
        make_obstacle(0, h-1, w, 1, 1),
        # Mur ouest
        make_obstacle(0, 0, 1, h, 1),
        # Mur est
        make_obstacle(w-1, 0, 1, h, 1)
    ]
    
    ground = {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": 1,
            "Name": {
                "DefaultText": zone["name_en"],
                "LocalTexts": {"fr": zone["name_fr"]}
            },
            "Released": False,
            "Comment": zone["comment"],
            "AssetName": zone["asset"],
            "Music": zone["music"],
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "obstacles": obstacles,
            "rand": {
                "$type": "RogueEssence.Ground.AutoTile.RandImg, RogueEssence",
                "MinBoundary": {"X": 0, "Y": 0},
                "MinBorderBoundary": {"X": 0, "Y": 0}
            },
            "Status": {},
            "Background": {
                "$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                "MapLoc": {"X": 0, "Y": 0},
                "BGAnim": {
                    "AnimIndex": "",
                    "FrameTime": 1,
                    "StartFrame": -1,
                    "EndFrame": -1,
                    "AnimDir": -1,
                    "Alpha": 255,
                    "AnimFlip": False
                }
            },
            "BlankBG": {
                "AutoTileset": "",
                "Associates": [],
                "Layers": [],
                "NeighborCode": -1
            },
            "Layers": [
                {
                    "Name": "Layer 1",
                    "Layer": 0,
                    "Visible": True,
                    "Tiles": rows
                }
            ],
            "Decorations": [
                {
                    "Name": "New Deco",
                    "Layer": 0,
                    "Visible": True,
                    "Anims": {
                        "$type": "System.Collections.Generic.List`1[[RogueEssence.Ground.GroundAnim, RogueEssence]], System.Private.CoreLib",
                        "$values": []
                    }
                }
            ],
            "Entities": [
                {
                    "Name": "New EntLayer",
                    "Visible": True,
                    "MapChars": [],
                    "GroundObjects": [
                        {
                            "EntName": "Dungeon_Entrance",
                            "Position": {"X": (w//2-1)*32, "Y": (h-3)*32, "Width": 64, "Height": 32},
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0
                        },
                        {
                            "EntName": "Kangaskhan_Rock",
                            "Position": {"X": (w//2-1)*32, "Y": -2*32, "Width": 64, "Height": 32},
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0
                        }
                    ],
                    "Spawners": [{"Spawns": {"$type": "System.Collections.Generic.List`1[[RogueEssence.Ground.GroundSpawner+GroundSpawn, RogueEssence]], System.Private.CoreLib", "$values": []}} for _ in range(5)],
                    "Markers": [
                        {
                            "EntName": "Main_Entrance_Marker",
                            "Direction": 4,
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0,
                            "Collider": {"X": (w//2 - 1)*32, "Y": (h-5)*32, "Width": 64, "Height": 64}
                        }
                    ]
                }
            ]
        }
    }
    return ground

# Générer
for zone in ZONES:
    path = os.path.join(GROUND_DIR, f"{zone['asset']}.rsground")
    ground = generate_ground(zone)
    with open(path, 'w', encoding='utf-8-sig') as f:
        json.dump(ground, f, ensure_ascii=False, indent=2)
    size = os.path.getsize(path)
    print(f"✓ {path} ({size:,} octets)")

print(f"\n{len(ZONES)} ground maps generees.")
