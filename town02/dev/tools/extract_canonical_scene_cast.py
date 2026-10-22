#!/usr/bin/env python3
"""Casting canonique des scènes PMD Red EU : entités, espèces, positions.

Croise deux sources d'autorité, sans invention :

1. `converter/rom_cache/eu_ground_scripts_27.json` — extraction EU authentifiée
   (audit_pmdred_eu_all_ground_scripts.py) : pour chaque Ground, les entités
   typées de la ROM (GroundLivesData/GroundEffectData 8 premiers octets :
   kind, unk1, width, height, CompactPos x/y, flags).
2. La table `gGroundLivesTypeData` de la ROM EU (structure décrite dans
   pret/pmd-red src/ground_lives.c:99 : s16 type, s16 species, char* name,
   u8 x, u8 y ; 12 octets/entrée). Adresse EU localisée par scan structurel
   authentifié : 0x0027BEEC (147 entrées, comme l'US 0x11E63C/0x6E4).

Le résultat associe chaque `L` (live/acteur) de chaque scène à son espèce
canonique et sa position exacte en tuiles — la base factuelle pour brancher
les cinématiques sur les Grounds sans placer personne « au jugé ».

Types (ground_lives.c) :
  1 = joueur, 2 = partenaire/équipe, 3 = recrue dynamique (slot),
  5 = espèce fixe (species), autres = spéciaux.

Usage: python3 dev/tools/extract_canonical_scene_cast.py
Sortie: dev/docs/canonical/red/scene_cast/eu_scene_cast.json
"""
from __future__ import annotations

import hashlib
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ROM = ROOT / "converter" / "rom_input" / "pmdred-eu.gba"
EXTRACT = ROOT / "converter" / "rom_cache" / "eu_ground_scripts_27.json"
OUT = ROOT / "dev" / "docs" / "canonical" / "red" / "scene_cast" / "eu_scene_cast.json"

EXPECTED_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ROM_BASE = 0x08000000
LIVES_TYPE_TABLE = 0x0027BEEC          # gGroundLivesTypeData (EU), scan structurel
LIVES_TYPE_COUNT = 147                 # 0x6E4 / 12, identique US
MONSTER_H = ROOT / "dev" / "external" / "pret_pmd_red" / "include" / "constants" / "monster.h"


def monster_names() -> dict[int, str]:
    names: dict[int, str] = {}
    for line in MONSTER_H.read_text().splitlines():
        parts = line.split()
        if len(parts) == 3 and parts[0] == "#define" and parts[1].startswith("MONSTER_"):
            try:
                names[int(parts[2])] = parts[1][len("MONSTER_"):]
            except ValueError:
                pass
    return names


def lives_type_table(rom: bytes) -> list[dict]:
    table = []
    for k in range(LIVES_TYPE_COUNT):
        off = LIVES_TYPE_TABLE + k * 12
        typ, species = struct.unpack_from("<hh", rom, off)
        ptr, = struct.unpack_from("<I", rom, off + 4)
        w, h = rom[off + 8], rom[off + 9]
        name = ""
        if (ptr >> 24) == 8:
            raw = rom[ptr - ROM_BASE:ptr - ROM_BASE + 16].split(b"\0")[0]
            name = raw.decode("latin-1")
        table.append({"kind": k, "type": typ, "species": species,
                      "debug_name": name, "size_x": w, "size_y": h})
    return table


TYPE_ROLES = {
    1: "player",            # le héros (espèce du joueur au runtime)
    2: "partner_or_team",   # partenaire / membre d'équipe (slot)
    3: "recruit_slot",      # recrue dynamique (dépend de la sauvegarde)
    5: "fixed_species",     # PNJ à espèce fixe — casting canonique direct
}


def main() -> int:
    rom = ROM.read_bytes()
    digest = hashlib.sha256(rom).hexdigest()
    if digest != EXPECTED_ROM_SHA256:
        print(f"ROM inattendue: {digest}", file=sys.stderr)
        return 2
    mon = monster_names()
    table = lives_type_table(rom)
    extract = json.loads(EXTRACT.read_text(encoding="utf-8"))

    scenes = {}
    for cand in extract["candidates"]:
        asset = cand["asset"]
        cast = []
        for ent in cand["typed_graph"]["entities"]:
            cat, group, sector, index = ent["owner"]
            raw = bytes.fromhex(ent["raw_hex"])
            kind, unk1, w, h, x, y, xf, yf = raw
            row = {
                "owner": ent["owner"],
                "category": {"L": "live", "O": "object", "F": "effect", "T": "station"}.get(cat, cat),
                "kind": kind,
                "tile_x": x, "tile_y": y,
                "x_flags": xf, "y_flags": yf,
                "width": w, "height": h,
                "slot": unk1,
            }
            if cat == "L" and kind < len(table):
                t = table[kind]
                row["actor_type"] = TYPE_ROLES.get(t["type"], f"type_{t['type']}")
                if t["type"] == 5 and t["species"]:
                    row["species_id"] = t["species"]
                    row["species"] = mon.get(t["species"], f"#{t['species']}")
                elif t["type"] == 2 and t["species"]:
                    row["species_id"] = t["species"]
                    row["species"] = mon.get(t["species"], f"#{t['species']}")
                if t["debug_name"] and t["debug_name"] != "-":
                    row["debug_name"] = t["debug_name"]
            cast.append(row)
        scenes[asset] = {
            "regional_ground_id": cand.get("regional_ground_id"),
            "entities": cast,
        }

    OUT.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "schema": "new-era.pmdred-eu-scene-cast.v1",
        "authority": {
            "rom_sha256": EXPECTED_ROM_SHA256,
            "lives_type_table_offset": hex(LIVES_TYPE_TABLE),
            "lives_type_struct": "pret/pmd-red src/ground_lives.c:99 GroundLiveTypeData",
            "entities_source": "converter/rom_cache/eu_ground_scripts_27.json",
        },
        "type_roles": TYPE_ROLES,
        "lives_type_table": table,
        "scenes": scenes,
    }
    OUT.write_text(json.dumps(payload, indent=1, ensure_ascii=False) + "\n",
                   encoding="utf-8")
    n_fixed = sum(1 for s in scenes.values() for e in s["entities"]
                  if e.get("species"))
    print(f"{len(scenes)} scènes, {n_fixed} entités à espèce canonique fixe "
          f"-> {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
