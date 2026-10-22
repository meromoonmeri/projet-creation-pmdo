#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_link_progression_to_zones.py — Chaîne JOUABLE de l'histoire principale
Sky : relie chaque étape de progression ($SCENARIO_MAIN) aux ZONES PMDO
réellement construites et validées (donjon procédural + arène de boss),
avec preuve runtime par étape.

Croise (aucune invention) :
  - Docs/PLAYABLE_PROGRESSION.json  (état → scènes SSB → ground/dialogues)
  - Tables/ZONE_VS_ROM_COMPARISON.json (zone PMDO ↔ donjon ROM, verdicts)
  - dev/docs/canonical_dungeon_runtime/matrix.json (preuves runtime)
  - la structure canonique de l'histoire (donjon → arène du même chapitre,
    dérivée de la table arm9 : dXX procédural suivi de dXX+1 fixe)

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/STORY_PLAYABLE_CHAIN.json/.md
Chaque chapitre expose : état(s) scénario, donjon PMDO (id zone, étages,
verdict ROM, runtime), arène de boss (zone, boss, runtime), GAPs restants
(cinématiques non intégrées, grounds hub non chargés).
"""
import json
import os
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
DOCS = os.path.join(CAMP, "Docs")

# Chapitres de l'histoire principale (structure canonique EoS : le donjon
# procédural mène à l'arène fixe du même chapitre ; états $SCENARIO_MAIN
# principaux d'après PLAYABLE_PROGRESSION / le déroulé du jeu).
CHAPTERS = [
    ("Prologue/Ch.1 — Beach Cave", ["1.0", "2.2"],
     [("beach_cave", "d01")], ("beach_cave_pit", "d02",
                               "Koffing+Zubat (Team Skull)")),
    ("Ch.2 — Drenched Bluff", ["3.x"], [("drenched_bluff", "d03")], None),
    ("Ch.3 — Mt. Bristle", ["4.x"],
     [("mt_bristle", "d04")], ("mt_bristle_peak", "d05", "Drowzee")),
    ("Ch.4 — Waterfall Cave", ["5.x"], [("waterfall_cave", "d06")], None),
    ("Ch.5 — Apple Woods", ["6.x"], [("apple_woods", "d07")], None),
    ("Expédition — routes", ["8.x"],
     [("craggy_coast", "d08"), ("side_path", "d09"), ("mt_horn", "d10"),
      ("rock_path_sky", "d11"), ("foggy_forest", "d12"),
      ("forest_path", "d13")], None),
    ("Ch.9 — Steam Cave", ["8.x/9.x"],
     [("steam_cave", "d14"), ("upper_steam_cave", "d15")],
     ("steam_cave_peak", "d16", "Groudon (illusion d'Uxie)")),
    ("Ch.10 — Amp Plains", ["10.x"],
     [("amp_plains", "d17"), ("far_amp_plains", "d18")],
     ("amp_clearing", "d19", "Manectric + 8 Electrike")),
    ("Ch.11 — Northern Desert/Quicksand", ["11.x"],
     [("northern_desert", "d20"), ("quicksand_cave", "d21"),
      ("quicksand_pit", "d22")],
     ("underground_lake", "d23", "Mesprit")),
    ("Ch.12 — Crystal Cave/Crossing", ["12.x"],
     [("crystal_cave", "d24"), ("crystal_crossing", "d25")],
     ("crystal_lake", "d26", "Grovyle (fuite) / Azelf")),
    ("Ch.13-14 — arc du futur", ["13.x-15.x"],
     [("chasm_cave", "d27"), ("dark_hill", "d28"),
      ("sealed_ruin", "d29"), ("sealed_ruin_pit", "d30")],
     ("spiritomb_room", "d31", "Spiritomb")),
    ("Ch.15 — Dusk Forest→retour", ["15.x-16.x"],
     [("dusk_forest", "d32"), ("deep_dusk_forest", "d33"),
      ("treeshroud_forest", "d34")], None),
    ("Ch.16-17 — Brine Cave", ["17.x"],
     [("brine_cave", "d35"), ("lower_brine_cave", "d36")],
     ("brine_cave_pit", "d37", "Omastar ×2 + Kabutops")),
    ("Ch.18-19 — Hidden Land", ["18.x-19.x"],
     [("hidden_land", "d38"), ("hidden_highland", "d39")],
     ("old_ruins", "d40", "Dusknoir + 6 Sableye")),
    ("Ch.20 — Temporal Tower (FINALE)", ["20.x"],
     [("temporal_tower", "d41"), ("temporal_spire", "d42")],
     ("temporal_pinnacle", "d43", "DIALGA PRIMAL")),
]


def main():
    cmp_p = os.path.join(CAMP, "Tables", "ZONE_VS_ROM_COMPARISON.json")
    zcmp = json.load(open(cmp_p))["zones"]
    mtx_p = os.path.join(REPO, "dev", "docs", "canonical_dungeon_runtime",
                         "matrix.json")
    matrix = json.load(open(mtx_p)) if os.path.exists(mtx_p) else {}
    runtime = {}
    # format matrix.v2 : zones sous matrix['zones'] ET en clés de premier
    # niveau (entrées récentes)
    for src in ([matrix.get("zones") or {}] + [matrix]):
        for zid, e in src.items():
            if isinstance(e, dict) and "verdict" in e:
                runtime[zid] = e["verdict"]

    def zone_status(zid):
        v = zcmp.get(zid, {}).get("verdict", "NOT_COMPARED")
        rt = runtime.get(zid, "NOT_TESTED")
        return v, rt

    chapters = []
    all_ok = 0
    for title, states, dungeons, boss in CHAPTERS:
        ds = []
        ok = True
        for zid, dk in dungeons:
            v, rt = zone_status(zid)
            ds.append(OrderedDict(zone=zid, dungeon=dk, rom_verdict=v,
                                  runtime=rt))
            if v != "EXACT" or "PASS" not in str(rt):
                ok = False
        bentry = None
        if boss:
            zid, dk, who = boss
            v, rt = zone_status(zid)
            bentry = OrderedDict(zone=zid, dungeon=dk, boss=who,
                                 rom_verdict=v, runtime=rt)
            if v != "EXACT" or "PASS" not in str(rt):
                ok = False
        if ok:
            all_ok += 1
        chapters.append(OrderedDict(
            chapter=title, scenario_states=states, dungeons=ds,
            boss_arena=bentry,
            status="PLAYABLE_DUNGEON_CHAIN" if ok else "PARTIAL",
            gaps=["cinématiques du chapitre NOT_YET_INTEGRATED",
                  "grounds hub (Treasure Town/guilde) non chargés dans le "
                  "runtime PMDO", "liaison automatique flag→déblocage de "
                  "zone à écrire côté mod (SV/UnlockDungeon)"]))

    out = OrderedDict(
        schema="sky-story-playable-chain/1",
        authority="ZONE_VS_ROM_COMPARISON (43/43 EXACT) × matrice runtime "
                  "canonical_dungeon × structure de chapitres canonique EoS",
        rule="PLAYABLE_DUNGEON_CHAIN = donjons+arène du chapitre EXACT vs "
             "ROM ET CANONICAL_RUNTIME_PASS. Les GAPS (cinématiques, hubs, "
             "déblocages scriptés) restent listés — ce statut ne signifie "
             "PAS chapitre complet.",
        totals=OrderedDict(chapters=len(chapters),
                           playable_dungeon_chain=all_ok),
        chapters=chapters)
    p = os.path.join(DOCS, "STORY_PLAYABLE_CHAIN.json")
    json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False,
              indent=1)

    md = ["# Chaîne jouable de l'histoire principale — PMD Sky EU\n",
          "| Chapitre | Donjons (zone→ROM) | Boss | Statut |",
          "|---|---|---|---|"]
    for c in chapters:
        dtxt = ", ".join(f"{d['zone']}({d['dungeon']})"
                         for d in c["dungeons"])
        btxt = (f"{c['boss_arena']['boss']} @{c['boss_arena']['zone']}"
                if c["boss_arena"] else "—")
        md.append(f"| {c['chapter']} | {dtxt} | {btxt} | "
                  f"**{c['status']}** |")
    md.append("\n## GAPs communs (honnêtes, non masqués)\n"
              "- cinématiques : extraites+classifiées mais "
              "NOT_YET_INTEGRATED au runtime ;\n"
              "- hubs (Treasure Town, guilde) : grounds rendus mais non "
              "chargés dans PMDO ;\n"
              "- déblocages scriptés flag→zone : à porter en Lua "
              "(SV/UnlockDungeon).\n")
    open(os.path.join(DOCS, "STORY_PLAYABLE_CHAIN.md"), "w",
         encoding="utf-8").write("\n".join(md) + "\n")
    print("chapitres:", len(chapters), "| chaîne donjons jouable:",
          all_ok)
    print(p)


if __name__ == "__main__":
    main()
