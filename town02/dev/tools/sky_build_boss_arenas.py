#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_build_boss_arenas.py — Arènes de boss Sky depuis fixed.bin (ROM EU),
au format .rsmap + zone LoadGen/MappedRoomStep VALIDÉ en runtime par
spiritomb_arena (même schéma, aucun système nouveau).

Sources canoniques (aucune invention) :
  - BALANCE/fixed.bin        : géométrie exacte (murs/sol/eau, spawns
                               leader/partenaire, positions des boss)
  - arm9 ov29 entity tables  : entity_rule -> monster (md_idx, stats)
  - BALANCE/waza_p.bin       : moveset = 4 dernières capacités apprises
                               au niveau du boss (règle EoS)
  - BALANCE/monster.md       : stats de base, types
  - tables mappa (niveau du boss = niveau de spawn du donjon hôte)

Géométries et boss extraits dans /tmp/sky_fixed_floors.json et
/tmp/sky_boss_movesets.json par les sondes de session (régénérables).

Boss couverts (histoire ch.1-9) :
  d02 ff1 Beach Cave Pit    — Koffing L7 + Zubat L4 (Team Skull)
  d05 ff2 Mt Bristle Peak   — Drowzee L50
  d16 ff3 Steam Cave Peak   — Groudon L51 (illusion d'Uxie)
  d19 ff4 Amp Clearing      — Manectric L32 + 8 Electrike L22
  d23 ff5 Underground Lake  — Mesprit L52

Sorties : Data/Map/<zone>_arena.rsmap + Data/Zone/<zone>.json (1 étage
LoadGen) + entrées index.idx.
"""
import copy
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FIXED = json.load(open("/tmp/sky_fixed_floors.json"))
MOVES = json.load(open("/tmp/sky_boss_movesets.json"))

# (zone_id, dungeon, fixed_floor, arène, tileset base, musique, nom EN/FR,
#  boss=[(species, level, element1, element2, intrinsic)])
ARENAS = [
    ("beach_cave_pit", "d02", "1", "beach_cave",
     "In the Depths of the Pit.ogg", "Beach Cave Pit", "Basse Fosse Littorale",
     [("koffing", 7, "poison", "none", "levitate"),
      ("zubat", 4, "poison", "flying", "inner_focus")]),
    ("mt_bristle_peak", "d05", "2", "mt_bristle",
     "Boss Battle!.ogg", "Mt. Bristle Peak", "Pic du Mont Aiguillon",
     [("drowzee", 50, "psychic", "none", "insomnia")]),
    ("steam_cave_peak", "d16", "3", "steam_cave",
     "Boss Battle!.ogg", "Steam Cave Peak", "Sommet de la Grotte Vapeur",
     [("groudon", 51, "ground", "none", "drought")]),
    ("amp_clearing", "d19", "4", "amp_plains",
     "Boss Battle!.ogg", "Amp Clearing", "Clairière Élek",
     [("manectric", 32, "electric", "none", "static"),
      ("electrike", 22, "electric", "none", "static")]),
    ("underground_lake", "d23", "5", "quicksand_pit",
     "Boss Battle!.ogg", "Underground Lake", "Lac Souterrain",
     [("mesprit", 52, "psychic", "none", "levitate")]),
    ("crystal_lake", "d26", "6", "crystal_cave_2",
     "Boss Battle!.ogg", "Crystal Lake", "Lac Cristal",
     [("grovyle", 44, "grass", "none", "overgrow")]),
    ("brine_cave_pit", "d37", "8", "brine_cave",
     "Boss Battle!.ogg", "Brine Cave Pit", "Fosse de la Grotte Saumure",
     [("omastar", 41, "rock", "water", "shell_armor"),
      ("kabutops", 40, "rock", "water", "battle_armor")]),
    ("old_ruins", "d40", "9", "deep_sealed_ruin",
     "Battle Against Dusknoir.ogg", "Old Ruins", "Vieilles Ruines",
     [("sableye", 40, "dark", "ghost", "keen_eye"),
      ("dusknoir", 45, "ghost", "none", "pressure")]),
    ("temporal_pinnacle", "d43", "10", "temporal_spire",
     "Dialgas Fight to the Finish.ogg", "Temporal Pinnacle",
     "Cime Temporelle",
     [("dialga", 49, "steel", "dragon", "pressure")]),
]

MUSIC_FALLBACK_NOTE = (
    "musique canonique EoS ; si absente du roster (MUSIC_GAP_REPORT), le "
    "moteur reste silencieux — REQUIRES_MOD_ASSET, pas de substitution")


def load_template():
    p = os.path.join(REPO, "Data", "Map", "spiritomb_arena.rsmap")
    return json.load(open(p, encoding="utf-8-sig"))


def tile_wall(base):
    # format EXACT du spiritomb_arena.rsmap migré 0.8.12 (pas de $type)
    return {"Data": {"ID": "wall",
                     "TileTex": {"AutoTileset": f"{base}_wall",
                                 "Associates": [], "Layers": [],
                                 "NeighborCode": -1}, "StableTex": False},
            "Effect": {"TileLoc": {"X": 0, "Y": 0}, "ID": "",
                       "Revealed": False, "Owner": 0, "TileStates": []}}


def tile_floor(base):
    t = tile_wall(base)
    t["Data"]["ID"] = "floor"
    t["Data"]["TileTex"]["AutoTileset"] = f"{base}_floor"
    return t


def tile_water(base):
    t = tile_wall(base)
    t["Data"]["ID"] = "water"
    t["Data"]["TileTex"]["AutoTileset"] = f"{base}_secondary"
    t["Data"]["TileTex"]["Associates"] = [f"{base}_floor"]
    return t


def make_player(template_player, species, level, e1, e2, intrinsic,
                moves, x, y, base_stats):
    p = copy.deepcopy(template_player)
    p["Element1"], p["Element2"] = e1, e2
    p["serializationLoc"] = {"X": x, "Y": y}
    p["CurrentForm"] = {"Species": species, "Form": 0, "Skin": "normal",
                        "Gender": -1}
    p["BaseForm"] = dict(p["CurrentForm"])
    p["Level"] = level
    # HP indicatif : base_hp + croissance approchée n'est PAS recalculée
    # ici — le moteur PMDO recalcule les stats à partir du niveau et des
    # données d'espèce du mod (système natif). HP=0 => moteur calcule.
    p["HP"] = 0
    # formats EXACTS 0.8.12 (relus de spiritomb_arena.rsmap migré) :
    # Skills = Element{SkillNum,Charges,Enabled,Sealed} ; BaseSkills =
    # [{SkillNum,Charges}] ; Intrinsics = Element{ID}.
    p["Skills"] = [{"Element": {"SkillNum": m, "Charges": 10,
                                "Enabled": True, "Sealed": False},
                    "BackRef": i} for i, m in enumerate(moves)]
    p["BaseSkills"] = [{"SkillNum": m, "Charges": 10} for m in moves]
    p["Intrinsics"] = [{"Element": {"ID": intrinsic}, "BackRef": 0}]
    p["BaseIntrinsics"] = [intrinsic]
    p["Unrecruitable"] = True
    return p


def main():
    tpl_doc = load_template()
    tpl = tpl_doc["Object"]
    tpl_player = tpl["MapTeams"][0]["Players"][0]
    zone_tpl_doc = json.load(open(
        os.path.join(REPO, "Data", "Zone", "spiritomb_room.json"),
        encoding="utf-8-sig"))

    idx_map_p = os.path.join(REPO, "Data", "Map", "index.idx")
    idx_map = json.load(open(idx_map_p, encoding="utf-8-sig")) \
        if os.path.exists(idx_map_p) else None
    idx_zone_p = os.path.join(REPO, "Data", "Zone", "index.idx")
    idx_zone = json.load(open(idx_zone_p, encoding="utf-8-sig"))

    report = []
    for zone_id, dk, ffk, base, music, name_en, name_fr, bosses in ARENAS:
        ff = FIXED[ffk]
        W, H = ff["w"], ff["h"]
        rows = ff["rows"]
        ents = ff["entities"]
        move_info = {b["species"]: b for b in MOVES[dk]}

        # positions leader/partenaire (P/p) et boss (M)
        leader = partner = None
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if c == "P":
                    leader = (x, y)
                elif c == "p":
                    partner = (x, y)
        if leader is None:
            raise SystemExit(f"{zone_id}: pas de LEADER_SPAWN dans ff{ffk}")

        obj = copy.deepcopy(tpl)
        obj["Name"] = {"DefaultText": name_en,
                       "LocalTexts": {"fr": name_fr}}
        obj["Comment"] = (f"PMD Sky EU {dk} fixed floor {ffk} — géométrie "
                          f"exacte fixed.bin {W}x{H}, boss/positions arm9 "
                          f"ov29, movesets waza_p (4 dernières capacités "
                          f"au niveau). {MUSIC_FALLBACK_NOTE}")
        obj["AssetName"] = f"{zone_id}_arena"
        obj["Music"] = music

        tiles = []
        for x in range(W):
            col = []
            for y in range(H):
                c = rows[y][x]
                if c == "#":
                    col.append(tile_wall(base))
                elif c == "~":
                    col.append(tile_water(base))
                else:
                    col.append(tile_floor(base))
            tiles.append(col)
        obj["Tiles"] = tiles

        def layer_tile(sheet):
            return {"Layers": [], "AutoTileset": sheet, "Associates": [],
                    "NeighborCode": -1}
        # IMPORTANT : Layers[0].Tiles et DiscoveryArray sont indexés [x][y]
        # comme Tiles (vérifié sur spiritomb_arena 22x17 : les trois champs
        # ont les mêmes dimensions ; l'inversion [y][x] produit un NRE
        # BaseMapGenContext.get_Width au FinishGen).
        layers = []
        for x in range(W):
            col = []
            for y in range(H):
                c = rows[y][x]
                sheet = (f"{base}_wall" if c == "#" else
                         (f"{base}_secondary" if c == "~"
                          else f"{base}_floor"))
                col.append(layer_tile(sheet))
            layers.append(col)
        obj["Layers"] = [{"Name": "Base", "Layer": 0, "Visible": True,
                          "Tiles": layers}]
        obj["DiscoveryArray"] = [[False] * H for _ in range(W)]
        obj["TextureMap"] = {
            "floor": {"AutoTileset": f"{base}_floor", "Associates": [],
                      "Layers": [], "NeighborCode": -1},
            "wall": {"AutoTileset": f"{base}_wall", "Associates": [],
                     "Layers": [], "NeighborCode": -1},
            "unbreakable": {"AutoTileset": f"{base}_wall", "Associates": [],
                            "Layers": [], "NeighborCode": -1},
            "water": {"AutoTileset": f"{base}_secondary",
                      "Associates": [f"{base}_floor"], "Layers": [],
                      "NeighborCode": -1}}

        # boss = entités M du fixed floor, espèces via table de session
        players = []
        for e in ents:
            nm = e["name"].strip().lower()
            nm = re.sub(r"[.'’-]", "", nm)
            nm = re.sub(r"\s+", "_", nm)
            binfo = move_info.get(nm)
            if binfo is None:
                # espèce d'entité non prévue -> échec franc
                raise SystemExit(f"{zone_id}: entité {e['name']} sans "
                                 f"moveset extrait")
            spec = [b for b in bosses if b[0] == nm][0]
            players.append(make_player(
                tpl_player, nm, binfo["level"], spec[2], spec[3], spec[4],
                binfo["moves"], e["x"], e["y"], binfo["base"]))
        obj["MapTeams"] = [{
            "$type": "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
            "Players": players, "Guests": [], "inventory": [],
            "Name": name_en, "LeaderIndex": 0, "FoeConflict": False}]

        # positions de départ = spawns fixed floor exacts
        starts = [{"Loc": {"X": leader[0], "Y": leader[1]}, "Dir": 0}]
        if partner:
            starts.append({"Loc": {"X": partner[0], "Y": partner[1]},
                           "Dir": 0})
        obj["MapEffect"]["OnMapStarts"] = [{
            "Key": {"str": [-15]},
            "Value": {"$type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
                      "StartLocs": starts, "Positions": None}}]
        obj["EntryPoints"] = [dict(starts[0])]

        map_p = os.path.join(REPO, "Data", "Map", f"{zone_id}_arena.rsmap")
        json.dump({"Version": tpl_doc["Version"], "Object": obj},
                  open(map_p, "w", encoding="utf-8-sig"),
                  ensure_ascii=False, indent=1)

        # zone LoadGen (clone spiritomb_room)
        zdoc = copy.deepcopy(zone_tpl_doc)
        z = zdoc["Object"]
        z["Name"] = {"DefaultText": name_en, "LocalTexts": {"fr": name_fr}}
        z["Level"] = max(b[1] for b in bosses)
        z["Comment"] = (f"PMD Sky EU {dk} — étage fixe (fixed floor {ffk}) "
                        f"chargé par LoadGen+MappedRoomStep (schéma "
                        f"spiritomb_room validé). Table mappa dormante "
                        f"dans la ROM (boss posés par la salle fixe).")
        seg = z["Segments"][0]
        seg["Comment"] = name_en
        fl = seg["Floors"][0]
        for st in fl["GenSteps"]:
            if "MappedRoomStep" in st["Value"].get("$type", ""):
                st["Value"]["MapID"] = f"{zone_id}_arena"
        fl["Comment"] = (f"Salle fixe canonique ({zone_id}_arena.rsmap, "
                         f"{W}x{H}, fixed.bin ff{ffk})")
        zp = os.path.join(REPO, "Data", "Zone", f"{zone_id}.json")
        if os.path.exists(zp):
            raise SystemExit(f"{zp} existe déjà")
        json.dump(zdoc, open(zp, "w", encoding="utf-8-sig"),
                  ensure_ascii=False, indent=2)

        # index zone
        if zone_id not in idx_zone["Object"]:
            idx_zone["Object"][zone_id] = {
                "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
                "ExpPercent": z.get("ExpPercent", 100), "Level": z["Level"],
                "LevelCap": z.get("LevelCap", False), "KeepSkills": False,
                "TeamRestrict": False, "TeamSize": -1,
                "MoneyRestrict": False, "BagRestrict": -1,
                "KeepTreasure": False, "BagSize": -1, "Rescues": 2,
                "CountedFloors": 1, "Rogue": 0, "Grounds": [],
                "Maps": [[0]], "Name": z["Name"], "Released": True,
                "Comment": f"PMD Sky EU {dk} boss arena", "SortOrder": 0}
        # index map
        if idx_map and f"{zone_id}_arena" not in idx_map["Object"]:
            # cloner le résumé de spiritomb_arena
            sp = idx_map["Object"].get("spiritomb_arena")
            if sp:
                ent = copy.deepcopy(sp)
                ent["Name"] = obj["Name"]
                idx_map["Object"][f"{zone_id}_arena"] = ent
        report.append((zone_id, W, H, [p["CurrentForm"]["Species"]
                                       for p in players]))
        print(f"{zone_id}: {W}x{H}, boss {[p['CurrentForm']['Species'] for p in players]}")

    json.dump(idx_zone, open(idx_zone_p, "w", encoding="utf-8-sig"),
              ensure_ascii=False, indent=2)
    if idx_map:
        json.dump(idx_map, open(idx_map_p, "w", encoding="utf-8-sig"),
                  ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
