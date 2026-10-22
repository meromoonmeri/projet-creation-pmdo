#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_build_playable_progression.py — Progression JOUABLE de PMD Explorers of
Sky EU : relie chaque état $SCENARIO_MAIN aux SCÈNES qui l'écrivent, aux
LEVELS/GROUNDS où elles se jouent, à leurs DIALOGUES (5 langues) et aux
scènes déclenchées ensuite (ExecuteActingSub).

Sources (décodées, aucune invention) :
  - Cinematics/rom_scripts/*.json.gz (3760 SSB ExplorerScript + strings)
  - Cinematics/LEVEL_MAP_LINKS.json  (level → MAP_BG → ground campagne)
  - Docs/PROGRESSION_GRAPH.json      (états écrits/lus déjà mesurés)
  - MANIFEST.json                    (noms humains des grounds)

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/PLAYABLE_PROGRESSION.json/.md
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict, defaultdict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
RS = os.path.join(CAMP, "Cinematics", "rom_scripts")
DOCS = os.path.join(CAMP, "Docs")

RE_WRITE = re.compile(r"\$SCENARIO_MAIN\s*=\s*scn\[(\d+),\s*(\d+)\]")
RE_SCENE = re.compile(r"supervision_ExecuteActingSub\(LEVEL_(\w+),\s*'(\w+)'")


def main():
    links = json.load(open(os.path.join(
        CAMP, "Cinematics", "LEVEL_MAP_LINKS.json")))["levels"]
    manifest = json.load(open(os.path.join(CAMP, "MANIFEST.json")))
    # map_bg id -> nom humain : les grounds de campagne sont renommés ;
    # leur source_comment cite le MAP_BG d'origine (autorité du port).
    gnames = {}
    for g in manifest["grounds"]:
        nm = g.get("human_name_en") or g["ground"]
        cmt = g.get("source_comment") or ""
        m = re.search(r"MAP_BG (\S+) ->", cmt)
        ids = {g["ground"].lower()}
        if m:
            ids.update(p.lower() for p in m.group(1).split("/"))
        for i in ids:
            gnames.setdefault(i, nm)
    graph = json.load(open(os.path.join(DOCS, "PROGRESSION_GRAPH.json")))

    # scan : par (zone, script) -> writes, next scene triggers, dialogue count
    writers = defaultdict(list)   # state -> [(zone, script)]
    script_meta = {}
    for f in sorted(glob.glob(os.path.join(RS, "*.json.gz"))):
        zone = os.path.basename(f).split(".")[0]
        z = json.load(gzip.open(f, "rt"))
        for name, s in z["scripts"].items():
            src = s.get("explorerscript") or ""
            if not src:
                continue
            ws = [(int(a), int(b)) for a, b in RE_WRITE.findall(src)]
            trig = [(lv, sc) for lv, sc in RE_SCENE.findall(src)]
            ndlg = sum(len(v) for v in (s.get("strings") or {}).values()
                       if v) // 5 if s.get("strings") else 0
            en_dlg = len((s.get("strings") or {}).get("english") or [])
            if ws or (zone, name) not in script_meta:
                script_meta[(zone, name)] = OrderedDict(
                    dialogues_en=en_dlg, triggers=trig[:12])
            for w in ws:
                writers[w].append((zone, name))

    steps = []
    for (mj, mi) in sorted(writers):
        scenes = sorted(set(writers[(mj, mi)]))
        entries = []
        for zone, name in scenes[:10]:
            lvl = links.get(zone, {})
            ground = lvl.get("map_bg")
            meta = script_meta.get((zone, name), {})
            entries.append(OrderedDict(
                level=zone, script=name,
                ground=ground,
                ground_name=gnames.get(ground),
                dialogues_en=meta.get("dialogues_en", 0),
                next_scenes=[f"{lv}/{sc}" for lv, sc in
                             meta.get("triggers", [])[:6]],
            ))
        steps.append(OrderedDict(
            state=f"{mj}.{mi}",
            written_by=entries,
            n_writers=len(scenes)))

    out = OrderedDict(
        schema="sky-playable-progression/1",
        authority="SSB décompilés ROM EU + LEVEL_MAP_LINKS (level→ground)",
        note="chaque état cite les scènes qui l'écrivent, leur level/"
             "ground, leurs dialogues (comptage EN) et les scènes "
             "déclenchées ensuite",
        totals=OrderedDict(
            states=len(steps),
            with_ground=sum(1 for s in steps
                            if any(e["ground"] for e in s["written_by"])),
            with_dialogues=sum(1 for s in steps
                               if any(e["dialogues_en"]
                                      for e in s["written_by"])),
            reachability="245 écrits / 223 lus / 1 seul lu-jamais-écrit "
                         "(0.0 init) — voir PROGRESSION_GRAPH.json",
        ),
        main_chain=steps)
    p = os.path.join(DOCS, "PLAYABLE_PROGRESSION.json")
    json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False,
              indent=1)

    md = ["# Progression jouable — PMD Explorers of Sky (EU)\n",
          "Chaîne $SCENARIO_MAIN reliée aux scènes, grounds et dialogues "
          "(décodage SSB ROM EU).\n",
          "| État | Scène(s) | Ground | Dialogues EN | Scènes suivantes |",
          "|---|---|---|---|---|"]
    for s in steps:
        e = s["written_by"][0] if s["written_by"] else {}
        more = f" (+{s['n_writers']-1})" if s["n_writers"] > 1 else ""
        md.append(f"| `{s['state']}` | {e.get('level')}/{e.get('script')}"
                  f"{more} | {e.get('ground_name') or e.get('ground') or '—'}"
                  f" | {e.get('dialogues_en', 0)} | "
                  f"{', '.join(e.get('next_scenes') or []) or '—'} |")
    open(os.path.join(DOCS, "PLAYABLE_PROGRESSION.md"), "w",
         encoding="utf-8").write("\n".join(md) + "\n")
    print("totals:", dict(out["totals"]))
    print(p)


if __name__ == "__main__":
    main()
