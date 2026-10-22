#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_spiritomb_arena.py — Arène Spiritomb comme MAP DE DONJON native (.rsmap).

Le combat Spiritomb du NDS se déroule sur le FIXED FLOOR 7 du donjon 31
(arène 22x17, Spiritomb à (8,2)), pas sur le ground d21p41a (66x81, cinématiques).
Ce script construit Data/Map/spiritomb_arena.rsmap à partir de la géométrie
exacte du fixed floor 7 (fixed.bin), avec :
  - Tiles : murs/sol fidèles (fixed floor 7)
  - MapTeams[0] : SPIRITOMB (md 484, L51, unrecruitable)
  - BattlePositionEvent : déclenche le combat au OnMapStarts
  - TextureMap : auto-tilesets EoS (sealed_ruin_pit_*, même famille que d21p41a)
"""

import json
import os

OUT = "/tmp/v4work/Data/Map/spiritomb_arena.rsmap"

# Géométrie du fixed floor 7 (22x17) — lue depuis fixed.bin :
# '#' = mur, '.' = sol, 'M' = Spiritomb (entity 17 à (8,2)), '.' central = escalier
MAP = [
    "#####.......##########",
    "####.........#########",
    "###.....M.....########",
    "###...........########",
    "##.............#######",
    "##.............#######",
    "####.........#########",
    "####.........#########",
    "####.........#########",
    "####.........#########",
    "########.#############",
    "######################",
    "######################",
    "######################",
    "######################",
    "######################",
    "######################",
]
H = len(MAP)
W = len(MAP[0])
print(f"Arène : {W}x{H}")

# Position Spiritomb (fixed floor 7 : (8,2) en tuiles)
SPIRITOMB = (8, 2)
# Escalier (centre-bas de la salle)
STAIRS = (10, 10)

def tile(id_, autotile, nx=-1):
    return {"Data": {"ID": id_, "TileTex": {"AutoTileset": autotile, "Associates": [],
                                             "Layers": [], "NeighborCode": nx},
                     "StableTex": False},
            "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False,
                       "Owner": 0, "TileStates": []}}

def layer_tile(autotile):
    return {"AutoTileset": autotile, "Associates": [], "Layers": [], "NeighborCode": -1}

# Tiles : [x][y] (largeur x hauteur) comme boss_awd
tiles = []
for x in range(W):
    col = []
    for y in range(H):
        c = MAP[y][x]
        if c == '#':
            col.append(tile("wall", "sealed_ruin_pit_wall"))
        elif c == 'M':
            col.append(tile("floor", "sealed_ruin_pit_floor"))
        else:
            col.append(tile("floor", "sealed_ruin_pit_floor"))
    tiles.append(col)

# Layer (miroir des tiles, sans Data/Effect)
layers = []
for y in range(H):
    row = []
    for x in range(W):
        c = MAP[y][x]
        row.append(layer_tile("sealed_ruin_pit_wall" if c == '#' else "sealed_ruin_pit_floor"))
    layers.append(row)

# DiscoveryArray : tout révélé
discovery = [[0]*W for _ in range(H)]

# Spiritomb : MapTeams[0] (L51, unrecruitable)
spiritomb_team = {
    "$type": "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
    "Players": [{
        "Element1": "ghost", "Element2": "dark", "TurnWait": 0, "TurnUsed": False,
        "movementSpeed": 0, "dead": False,
        "serializationLoc": {"X": SPIRITOMB[0], "Y": SPIRITOMB[1]}, "serializationDir": 2,
        "ProxyName": "", "ProxySprite": {"Species": "", "Form": -1, "Skin": "", "Gender": -1},
        "CurrentForm": {"Species": "spiritomb", "Form": 0, "Skin": "normal", "Gender": -1},
        "ProxyAtk": -1, "ProxyDef": -1, "ProxyMAtk": -1, "ProxyMDef": -1, "ProxySpeed": -1,
        "Skills": [{"Element": {"SkillNum": "shadow_ball", "Charges": 10, "Enabled": True, "Sealed": False}, "BackRef": 0},
                   {"Element": {"SkillNum": "dark_pulse", "Charges": 10, "Enabled": True, "Sealed": False}, "BackRef": 1}],
        "Intrinsics": [{"Element": {"IntrinsicNum": "pressure", "Enabled": True, "Sealed": False}, "BackRef": 0}],
        "EquippedItem": None, "Absentee": False, "ChargeBoost": 0,
        "HP": 300, "HPRemainder": 0, "Fullness": 100, "FullnessRemainder": 0, "MaxFullness": 100,
        "StatusEffects": [], "MissChain": 0, "EXPMarked": False, "Tactic": "boss_wait_then_attack",
        "Mobility": 3, "CantWalk": False, "ItemDisabled": False, "IntrinsicDisabled": False,
        "CanRemoveStuck": True, "StopItemAtHit": False, "ForceAI": False, "MovesScrambled": False,
        "ChargeSaver": False, "WaitToAttack": False, "CantInteract": False,
        "EnemyOfFriend": True, "AttackFriend": False,
        "TileSight": 3, "CharSight": 5, "Unidentifiable": False, "Unlocatable": False,
        "SeeAllChars": False, "SeeItems": False, "SeeWallItems": False, "SeeTraps": False,
        "CharStates": [], "BackRef": 0, "Nickname": "",
        "OriginalUUID": "00000000-0000-0000-0000-000000000000",
        "OriginalTeam": 0, "BaseForm": {"Species": "spiritomb", "Form": 0, "Skin": "normal", "Gender": -1},
        "Level": 51, "EXP": 0, "MaxHPBonus": 0, "AtkBonus": 0, "DefBonus": 0,
        "MAtkBonus": 0, "MDefBonus": 0, "SpeedBonus": 0,
        "BaseSkills": ["shadow_ball", "dark_pulse"], "BaseIntrinsics": ["pressure"],
        "FormIntrinsicSlot": 0, "Relearnables": [], "Discriminator": 0,
        "MetAt": 0, "MetLoc": 0, "DefeatAt": 0, "DefeatLoc": 0,
        "IsFounder": False, "IsPartner": False, "NameLocked": False, "IsFavorite": False,
        "Unrecruitable": True, "ActionEvents": [], "ScriptVars": [],
    }],
    "Guests": [], "inventory": [], "Name": "Spiritomb", "LeaderIndex": 0, "FoeConflict": False,
}

obj = {
    "$type": "RogueEssence.Dungeon.Map, RogueEssence",
    "Name": {"DefaultText": "Spiritomb Room", "LocalTexts": {"fr": "Salle de Spiritomb"}},
    "Released": True, "Comment": "D31 fixed floor 7 (NDS) — Spiritomb L51, arène 22x17",
    "Begun": False, "ID": 0,
    "MapTeams": [spiritomb_team], "AllyTeams": [],
    "rand": {"seed": 0, "index": 0, "randInterval": 0},
    "AssetName": "spiritomb_arena",
    "ScriptEvents": {},
    "Music": "Sealed Ruin Pit.ogg",
    "TileSight": 0, "CharSight": 0, "Status": {},
    "MapEffect": {
        "UniversalStates": [],
        "BeforeTryActions": [],
        "BeforeActions": [],
        "OnMapStarts": [{"Key": {"str": [-15]}, "Value": {
            "$type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
            "StartLocs": [
                {"Loc": {"X": 8, "Y": 12}, "Dir": 4},
                {"Loc": {"X": 7, "Y": 13}, "Dir": 4},
                {"Loc": {"X": 9, "Y": 13}, "Dir": 4},
            ],
            "Positions": None}}],
    },
    "TeamSpawns": [], "MoneyAmount": {"Min": 0, "Max": 0}, "ItemSpawns": {},
    "BlankBG": {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1},
    "TextureMap": {
        "floor": {"AutoTileset": "sealed_ruin_pit_floor", "Associates": [], "Layers": [], "NeighborCode": -1},
        "wall": {"AutoTileset": "sealed_ruin_pit_wall", "Associates": [], "Layers": [], "NeighborCode": -1},
        "unbreakable": {"AutoTileset": "sealed_ruin_pit_wall", "Associates": [], "Layers": [], "NeighborCode": -1},
        "water": {"AutoTileset": "sealed_ruin_pit_secondary", "Associates": ["sealed_ruin_pit_floor"], "Layers": [], "NeighborCode": -1},
    },
    "Element": "none",
    "Background": {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                   "MapLoc": {"X": 0, "Y": 0},
                   "BGAnim": {"AnimIndex": "", "FrameTime": 1, "StartFrame": -1, "EndFrame": -1,
                              "AnimDir": -1, "Alpha": 255, "AnimFlip": 0},
                   "BGMovement": {"X": 0, "Y": 0}, "RepeatX": False, "RepeatY": False},
    "ViewCenter": None, "ViewOffset": {"X": 0, "Y": 0},
    "HideMinimap": False, "NoRescue": False, "NoSwitching": False,
    "MapTurns": 0, "CurrentTurnMap": {"X": 0, "Y": 0},
    "DiscoveryArray": discovery,
    "Layers": [{"Name": "Base", "Layer": 0, "Visible": True, "Tiles": layers}],
    "Decorations": [{"Name": "New DecLayer", "Visible": True, "MapChars": [], "GroundObjects": [], "Spawners": [], "Markers": []}],
    "Tiles": tiles,
    "EdgeView": 0,
    "EntryPoints": [{"Loc": {"X": 8, "Y": 12}, "Dir": 4}],
    "Items": [],
}

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", encoding="utf-8") as f:
    json.dump({"Version": "0.8.12.0", "Object": obj}, f, ensure_ascii=False, indent=1)
print("Écrit :", OUT)
print("Tiles:", W, "x", H, "| Spiritomb à", SPIRITOMB, "L51 | Escalier à", STAIRS)
