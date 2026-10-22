#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Régénère les arènes de combat rognées depuis les grounds sources complets.
Détecte l'orientation des obstacles (les données peuvent être transposées) par
le test des markers walkable, puis reconstruit l'arène en plein écran. """
import json, os, copy

PAIRS = {
    "magma_cavern_pit": "Data/Ground/fosse_ardente.rsground",
    "mt_blaze_summit": "Data/Ground/d09p03.rsground",
    "frosty_forest_summit": "Data/Ground/d10p03.rsground",
    "tour_ciel_sommet": "Data/Ground/tour_ciel_sommet.rsground",
    "wish_cave_jirachi": "Data/Ground/sanctuaire_voeu.rsground",
    "mount_windswept_guardian": "Data/Ground/mount_windswept_guardian.rsground",
    "vast_steppe_guardian": "Data/Ground/vast_steppe_guardian.rsground",
    "gloomy_forest_boss": "Data/Ground/sinister_woods_clearing.rsground",
}

def ground_data(gpath):
    with open(gpath, encoding="utf-8-sig") as f:
        d = json.load(f)["Object"]
    lay = [L for L in d.get("Layers", []) if L.get("Tiles")]
    vis = lay[0]["Tiles"] if lay else []
    W = len(vis); H = len(vis[0]) if W else 0
    obs = d.get("obstacles", [])
    markers = {}
    for e in d.get("Entities", []):
        for m in e.get("Markers", []):
            c = m.get("Collider", {})
            markers[m.get("EntName")] = (c.get("X") // 8, c.get("Y") // 8)
    return W, H, obs, vis, d["Layers"], markers

def walk_yx(obs, x, y):
    OH = len(obs); OW = len(obs[0]) if OH else 0
    return 0 <= y < OH and 0 <= x < OW and obs[y][x].get("Tags", 1) == 0

def walk_xy(obs, x, y):
    OW2 = len(obs); OH2 = len(obs[0]) if OW2 else 0
    return 0 <= x < OW2 and 0 <= y < OH2 and obs[x][y].get("Tags", 1) == 0

def detect_orientation(obs, markers):
    """Retourne 'yx' ou 'xy' selon l'orientation correcte des obstacles."""
    pts = []
    for name in ("Main_Entrance_Marker", "Boss_Marker"):
        if name in markers: pts.append(markers[name])
    for name in markers:
        if name.startswith("Cutscene"): pts.append(markers[name])
    score_yx = sum(1 for p in pts if walk_yx(obs, *p))
    score_xy = sum(1 for p in pts if walk_xy(obs, *p))
    # coin (0,0) doit être bloqué dans la vraie orientation
    if obs:
        c_yx = walk_yx(obs, 0, 0); c_xy = walk_xy(obs, 0, 0)
        if c_yx: score_yx -= 2
        if c_xy: score_xy -= 2
    return 'xy' if score_xy > score_yx else 'yx'

def blocked(obs, orient, x, y):
    if orient == 'yx':
        OH = len(obs); OW = len(obs[0]) if OH else 0
        if 0 <= y < OH and 0 <= x < OW:
            return obs[y][x].get("Tags", 1) != 0
        return True
    else:
        OW2 = len(obs); OH2 = len(obs[0]) if OW2 else 0
        if 0 <= x < OW2 and 0 <= y < OH2:
            return obs[x][y].get("Tags", 1) != 0
        return True

def cell(blocked_, x, y):
    base = {
        "Data": {"ID": "unbreakable", "TileTex": {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}, "StableTex": False},
        "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False, "Owner": 0, "TileStates": []},
    }
    if not blocked_:
        base["Data"]["ID"] = "floor"
        base["Effect"]["TileLoc"] = {"X": x, "Y": y}
    return base

def regenerate(arena, gpath):
    print(f"== {arena} <- {gpath.split('/')[-1]}")
    W, H, obs, vis, glayers, markers = ground_data(gpath)
    orient = detect_orientation(obs, markers)
    print(f"    taille {W}x{H} = {W*8}x{H*8}px | orientation obstacles: {orient}")

    with open(f"Data/Map/{arena}.rsmap", encoding="utf-8-sig") as f:
        d = json.load(f)
    obj = d["Object"]

    tiles = []
    for x in range(W):
        col = []
        for y in range(H):
            col.append(cell(blocked(obs, orient, x, y), x, y))
        tiles.append(col)
    obj["Tiles"] = tiles
    obj["Layers"] = copy.deepcopy(glayers)

    entry = markers.get("Main_Entrance_Marker") or (W // 2, H - 2)
    ex, ey = entry
    eps = [{"Loc": {"X": ex, "Y": ey}, "Dir": 4}]
    if ex + 1 < W:
        eps.append({"Loc": {"X": ex + 1, "Y": ey}, "Dir": 4})
    obj["EntryPoints"] = eps

    boss = markers.get("Boss_Marker")
    bx, by = boss if boss else (W // 2, max(2, H // 3))
    for t in obj.get("MapTeams", []):
        for p in t.get("Players", []):
            p.setdefault("serializationLoc", {})["X"] = bx
            p.setdefault("serializationLoc", {})["Y"] = by

    def walk(x, y):
        return 0 <= x < W and 0 <= y < H and tiles[x][y]["Data"]["ID"] == "floor"

    issues = []
    if not walk(ex, ey): issues.append("entrée NON walkable")
    if not walk(bx, by): issues.append("boss NON walkable")
    print(f"    entrée=({ex},{ey}) boss=({bx},{by}) {' | '.join(issues) if issues else 'OK walkable'}")
    obj["Comment"] = (obj.get("Comment") or "") + f" | Régénéré depuis ground complet ({W}x{H} px), positions canoniques."

    with open(f"Data/Map/{arena}.rsmap", "w", encoding="utf-8") as f:
        json.dump(d, f, ensure_ascii=False, indent=1)

if __name__ == "__main__":
    for a, g in PAIRS.items():
        try:
            regenerate(a, g)
        except Exception as e:
            print(f"ERREUR {a}: {e}")
