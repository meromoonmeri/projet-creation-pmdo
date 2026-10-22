#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
red_build_gba_fixed_arenas.py — Arènes Groudon & Rayquaza de PMD Red EU
depuis fixedmap.inc GBA (RLE décodé octet par octet), au format .rsmap
mt_steel_boss VALIDÉ en runtime (même schéma, aucun système nouveau).

Sources canoniques :
  - data/dungeon/fixedmap.inc (pret bf0092d0, table gUnknown_84A03BC) :
    RLE: 0x0e <action> = littéral ; sinon nibble haut=action, bas=répét.+1
    (décodeur = sub_80511F0 du binaire, reproduit 1:1 ; contre-épreuve :
    table[1] Skarmory 9x17 = géométrie du mt_steel_boss.rsmap existant).
  - actions (PlaceFixedRoomTile) : 0/9/11/15=sol, 1/2/13/14=mur,
    4=spawn joueur, 5/6=secondaire, 8=escalier, >=16 = sFixedRoomEntities
    (22-27 = équipiers 1-6, 35=GROUDON, 36=RAYQUAZA, 60=sol entité vide,
    66=sol secondaire vide).
  - Niveaux BOSS canoniques : pokemon_found.json des donjons GBA
    (MagmaCavernPit 3F: Groudon L27 p5000 ; SkyTowerSummit 9F:
    Rayquaza L35 p10000).
  - Movesets : learnset_data.json pret — 4 dernières capacités au niveau
    (même règle que les arènes Sky).
  - HP : recalculé par le moteur (HP=0 → stats d'espèce PMDO natives au
    niveau) — PAS d'approximation manuelle.

Sorties : Data/Map/{magma_pit_groudon,sky_summit_rayquaza}.rsmap +
zones LoadGen correspondantes + index.
"""
import copy
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference")

ARENAS = [
    # (fixed_room_idx, map_id, zone_id, autotile base, musique, nom EN/FR,
    #  boss=(species, level, e1, e2, intrinsic, moves))
    (7, "magma_pit_groudon", "magma_pit_groudon", "magma_cavern_2",
     "Boss Battle.ogg", "Magma Cavern Pit - Groudon",
     "Fosse de la Caverne Magma — Groudon",
     ("groudon", 27, "ground", "none", "drought",
      ["mud_shot", "scary_face", "ancient_power", "slash"])),
    (8, "sky_summit_rayquaza", "sky_summit_rayquaza", "sky_tower",
     "Boss Battle.ogg", "Sky Tower Summit - Rayquaza",
     "Sommet de la Tour Céleste — Rayquaza",
     ("rayquaza", 35, "dragon", "flying", "air_lock",
      ["ancient_power", "dragon_claw", "dragon_dance", "crunch"])),
]


def decode_fixed_room(idx):
    txt = open(os.path.join(PRET, "data", "dungeon",
                            "fixedmap.inc")).read()
    ptrs = re.findall(r"^\.4byte (gUnknown_\w+)$",
                      txt.split("gUnknown_84A03BC:")[1], re.M)
    label = ptrs[idx]
    m = re.search(rf"\.global {label}\n{label}:\n((?:\.byte [^\n]+\n)+)",
                  txt)
    bs = []
    for line in m.group(1).splitlines():
        bs += [int(x, 16) for x in re.findall(r"0x([0-9a-fA-F]{2})",
                                              line)]
    w, h = bs[0], bs[1]
    data = bs[3:]
    out = []
    i = 0
    while len(out) < w * h and i < len(data):
        b = data[i]
        i += 1
        if b == 0x0E:
            out.append(data[i])
            i += 1
        else:
            out += [(b & 0xF0) >> 4] * ((b & 0x0F) + 1)
    return w, h, [out[r * w:(r + 1) * w] for r in range(h)]


def main():
    tpl_doc = json.load(open(os.path.join(
        REPO, "Data", "Map", "mt_steel_boss.rsmap"), encoding="utf-8-sig"))
    tpl = tpl_doc["Object"]
    tpl_player = tpl["MapTeams"][0]["Players"][0]

    zone_tpl = json.load(open(os.path.join(
        REPO, "Data", "Zone", "spiritomb_room.json"), encoding="utf-8-sig"))
    idx_zone_p = os.path.join(REPO, "Data", "Zone", "index.idx")
    idx_zone = json.load(open(idx_zone_p, encoding="utf-8-sig"))

    for fr_idx, map_id, zone_id, base, music, name_en, name_fr, boss \
            in ARENAS:
        W, H, grid = decode_fixed_room(fr_idx)
        species, level, e1, e2, intrinsic, moves = boss

        WALL = {1, 2, 3, 7, 10, 12, 13, 14}
        SEC = {5, 6}
        player = None
        boss_pos = None
        partners = {}
        for y in range(H):
            for x in range(W):
                a = grid[y][x]
                if a == 4:
                    player = (x, y)
                elif a in (35, 36):
                    boss_pos = (x, y)
                elif 22 <= a <= 27:
                    partners[a - 21] = (x, y)  # équipiers 1..6
        if player is None or boss_pos is None:
            raise SystemExit(f"{map_id}: spawn/boss introuvable")

        obj = copy.deepcopy(tpl)
        obj["Name"] = {"DefaultText": name_en,
                       "LocalTexts": {"fr": name_fr}}
        obj["AssetName"] = map_id
        obj["Music"] = music
        obj["Comment"] = (
            f"PMD Red EU fixed room {fr_idx} (fixedmap.inc RLE décodé "
            f"octet/octet, table gUnknown_84A03BC) — {W}x{H}, boss "
            f"{species} L{level} (niveau pokemon_found.json ROM), "
            f"moveset learnset pret (4 dernières capacités au niveau). "
            f"HP=0 → stats natives moteur (aucune approximation).")

        def tile(kind):
            tex = {"floor": f"{base}_floor", "wall": f"{base}_wall",
                   "water": f"{base}_secondary"}[kind]
            t = {"Data": {"ID": kind if kind != "water" else "water",
                          "TileTex": {"AutoTileset": tex,
                                      "Associates": [f"{base}_floor"]
                                      if kind == "water" else [],
                                      "Layers": [], "NeighborCode": -1},
                          "StableTex": False},
                 "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "",
                            "Revealed": False, "Owner": 0,
                            "TileStates": []}}
            return t

        tiles = []
        for x in range(W):
            col = []
            for y in range(H):
                a = grid[y][x]
                col.append(tile("wall" if a in WALL else
                                ("water" if a in SEC else "floor")))
            tiles.append(col)
        obj["Tiles"] = tiles
        layers = []
        for x in range(W):
            col = []
            for y in range(H):
                a = grid[y][x]
                sheet = (f"{base}_wall" if a in WALL else
                         (f"{base}_secondary" if a in SEC
                          else f"{base}_floor"))
                col.append({"Layers": [], "AutoTileset": sheet,
                            "Associates": [], "NeighborCode": -1})
            layers.append(col)
        obj["Layers"] = [{"Name": "Base", "Layer": 0, "Visible": True,
                          "Tiles": layers}]
        obj["DiscoveryArray"] = [[False] * H for _ in range(W)]
        obj["TextureMap"] = {
            "floor": {"AutoTileset": f"{base}_floor", "Associates": [],
                      "Layers": [], "NeighborCode": -1},
            "wall": {"AutoTileset": f"{base}_wall", "Associates": [],
                     "Layers": [], "NeighborCode": -1},
            "unbreakable": {"AutoTileset": f"{base}_wall",
                            "Associates": [], "Layers": [],
                            "NeighborCode": -1},
            "water": {"AutoTileset": f"{base}_secondary",
                      "Associates": [f"{base}_floor"], "Layers": [],
                      "NeighborCode": -1}}

        p = copy.deepcopy(tpl_player)
        p["Element1"], p["Element2"] = e1, e2
        p["serializationLoc"] = {"X": boss_pos[0], "Y": boss_pos[1]}
        p["CurrentForm"] = {"Species": species, "Form": 0,
                            "Skin": "normal", "Gender": -1}
        p["BaseForm"] = dict(p["CurrentForm"])
        p["Level"] = level
        p["HP"] = 0  # stats natives moteur au niveau — pas d'approximation
        p["Skills"] = [{"Element": {"SkillNum": m, "Charges": 10,
                                    "Enabled": True, "Sealed": False},
                        "BackRef": i} for i, m in enumerate(moves)]
        p["BaseSkills"] = [{"SkillNum": m, "Charges": 10,
                            "CanForget": False} for m in moves]
        p["Intrinsics"] = [{"Element": {"ID": intrinsic}, "BackRef": 0}]
        p["BaseIntrinsics"] = [intrinsic]
        p["Unrecruitable"] = True
        obj["MapTeams"] = [{
            "$type": "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
            "Players": [p], "Guests": [], "inventory": [],
            "Name": name_en, "LeaderIndex": 0, "FoeConflict": False}]

        starts = [{"Loc": {"X": player[0], "Y": player[1]}, "Dir": 0}]
        for k in sorted(partners):
            starts.append({"Loc": {"X": partners[k][0],
                                   "Y": partners[k][1]}, "Dir": 0})
        obj["MapEffect"]["OnMapStarts"] = [{
            "Key": {"str": [-15]},
            "Value": {"$type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
                      "StartLocs": starts[:4], "Positions": None}}]
        obj["EntryPoints"] = [dict(starts[0])]

        map_p = os.path.join(REPO, "Data", "Map", f"{map_id}.rsmap")
        json.dump({"Version": tpl_doc["Version"], "Object": obj},
                  open(map_p, "w", encoding="utf-8-sig"),
                  ensure_ascii=False, indent=1)

        zdoc = copy.deepcopy(zone_tpl)
        z = zdoc["Object"]
        z["Name"] = obj["Name"]
        z["Level"] = level
        z["Comment"] = obj["Comment"]
        seg = z["Segments"][0]
        seg["Comment"] = name_en
        fl = seg["Floors"][0]
        for st in fl["GenSteps"]:
            if "MappedRoomStep" in st["Value"].get("$type", ""):
                st["Value"]["MapID"] = map_id
        fl["Comment"] = f"Fixed room GBA {fr_idx} ({map_id}.rsmap {W}x{H})"
        zp = os.path.join(REPO, "Data", "Zone", f"{zone_id}.json")
        json.dump(zdoc, open(zp, "w", encoding="utf-8-sig"),
                  ensure_ascii=False, indent=2)
        if zone_id not in idx_zone["Object"]:
            idx_zone["Object"][zone_id] = {
                "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
                "ExpPercent": 100, "Level": level, "LevelCap": False,
                "KeepSkills": False, "TeamRestrict": False, "TeamSize": -1,
                "MoneyRestrict": False, "BagRestrict": -1,
                "KeepTreasure": False, "BagSize": -1, "Rescues": 2,
                "CountedFloors": 1, "Rogue": 0, "Grounds": [],
                "Maps": [[0]], "Name": z["Name"], "Released": True,
                "Comment": f"PMD Red EU fixed room {fr_idx}",
                "SortOrder": 0}
        print(f"{map_id}: {W}x{H} boss {species} L{level} moves {moves} "
              f"player@{player} partners@{sorted(partners.values())}")
    json.dump(idx_zone, open(idx_zone_p, "w", encoding="utf-8-sig"),
              ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
