from __future__ import annotations

TILE_SIZE = 32
ANIMATION_HALF_PERIOD_MS = 250
ANIMATION_PERIOD_MS = 500

TILE_TYPES = {
    0: "Walkable", 1: "Blocked", 2: "Warp", 3: "Item", 4: "NPCAvoid",
    5: "Key", 6: "KeyOpen", 7: "Heal", 8: "Kill", 9: "Shop",
    10: "MobileBlock", 11: "Arena", 12: "Sound", 13: "SpriteChange",
    14: "Sign", 15: "Door", 16: "Notice", 17: "Chest", 18: "LinkShop",
    19: "Scripted", 20: "NpcSpawn", 21: "House", 22: "Bank", 23: "Guild",
    24: "SpriteBlock", 25: "LevelBlock", 26: "Assembly", 27: "Evolution",
    28: "Story", 29: "MissionBoard", 30: "RDungeonGoal", 31: "ScriptedSign",
    32: "SpeciesChange", 33: "Hallway", 34: "HouseRoomWarp",
    35: "HouseOwnerBlock", 36: "Ambiguous", 37: "Slippery", 38: "Slow",
    39: "DropShop",
}
WEATHER = {
    0: "Ambiguous", 1: "None", 2: "Raining", 3: "Snowing", 4: "Thunder",
    5: "Hail", 6: "DiamondDust", 7: "Cloudy", 8: "Fog", 9: "Sunny",
    10: "Sandstorm", 11: "Snowstorm", 12: "Ashfall",
}
MAP_MORAL = {0: "None", 1: "Safe", 2: "NoPenalty", 3: "House"}
DIRECTIONS = {0: "Up", 1: "Down", 2: "Left", 3: "Right", 4: "UpRight", 5: "DownLeft", 6: "UpLeft", 7: "DownRight"}
NPC_BEHAVIOR = {0: "AttackOnSight", 1: "AttackWhenAttacked", 2: "Friendly", 3: "Shopkeeper", 4: "Guard", 5: "Scripted", 6: "FullyScriptedAI", 7: "FleeOnSight"}

# Storage order follows map_tiles and the V9 serializer exactly.
TILE_FIELDS = (
    "ground", "ground_anim", "mask", "mask_anim", "mask2", "mask2_anim",
    "fringe", "fringe_anim", "fringe2", "fringe2_anim", "type", "data1",
    "data2", "data3", "string1", "string2", "string3", "light",
    "ground_tileset", "ground_anim_tileset", "mask_tileset", "mask_anim_tileset",
    "mask2_tileset", "mask2_anim_tileset", "fringe_tileset",
    "fringe_anim_tileset", "fringe2_tileset", "fringe2_anim_tileset",
)

LAYER_PAIRS = (
    ("ground", "ground_tileset", "ground_anim", "ground_anim_tileset"),
    ("mask", "mask_tileset", "mask_anim", "mask_anim_tileset"),
    ("mask2", "mask2_tileset", "mask2_anim", "mask2_anim_tileset"),
    ("fringe", "fringe_tileset", "fringe_anim", "fringe_anim_tileset"),
    ("fringe2", "fringe2_tileset", "fringe2_anim", "fringe2_anim_tileset"),
)

CERTIFICATION_STATES = (
    "DISCOVERED", "EXTRACTED", "RENDERED", "SOURCE_CERTIFIED", "PARTIAL",
    "BLOCKED", "UNKNOWN", "UNVERIFIED",
)
