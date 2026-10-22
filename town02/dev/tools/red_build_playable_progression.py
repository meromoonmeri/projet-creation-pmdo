#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
red_build_playable_progression.py — Progression JOUABLE de PMD Red EU :
relie EVENT → FLAG → STATION/MAP → DIALOGUES → EVENT SUIVANT (§6 de la
mission : un graphe de flags n'est pas une progression jouable).

Sources (toutes déjà décodées, aucune invention) :
  - Cinematics/EVENT_SCRIPTS_INDEX.json + event_scripts/*.json.gz
    (chaîne EVENT_* ROM EU décodée octet par octet, 399 scripts) ;
  - Cinematics/DIALOGUES_INDEX.json (stations : 69 graphes EU exacts,
    3073 blocs 5 langues) ;
  - MANIFEST.json (grounds de campagne, id GBA ↔ nom humain) ;
  - pret include/constants/ground_map.h (enum GroundMapID, ordre = IDs
    numériques EXECUTE_STATION) + event_flag.h (annotations d'états).

Modèle par ÉTAPE de la chaîne principale (SCENARIO_MAIN croissant) :
  state → event(s) qui l'écrivent → gardes qui le lisent → stations/maps
  exécutées (EXECUTE_STATION/SUBSTATION, ids résolus en MAP_*) →
  dialogues de ces stations (comptage + fichier) → état suivant.

Analyse d'atteignabilité : chaque état écrit doit être lu par au moins un
JUMPIF_SCENE_*/CJUMP_SCENARIO en aval (sinon noté terminal/unread — pas
masqué).

Sortie : dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Docs/PLAYABLE_PROGRESSION.json
         + .md
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict, defaultdict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM")
CIN = os.path.join(CAMP, "Cinematics")
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference")
DOCS = os.path.join(CAMP, "Docs")


def load_map_enum():
    names = []
    p = os.path.join(PRET, "include", "constants", "ground_map.h")
    for line in open(p, encoding="utf-8", errors="replace"):
        m = re.match(r"\s*(MAP_\w+),", line)
        if m:
            names.append(m.group(1))
    return names


def load_state_annotations():
    ann = {}
    p = os.path.join(PRET, "include", "constants", "event_flag.h")
    in_main = False
    for line in open(p, encoding="utf-8", errors="replace"):
        s = line.strip()
        if s.startswith("// SCENARIO_MAIN:"):
            in_main = True
            continue
        if s.startswith("// SCENARIO_SUB") or s.startswith("// RESCUE_"):
            in_main = False
            continue
        if in_main:
            m = re.match(r"//\s*(\d+),\s*(\d+)\s*=\s*(.+)", s)
            if m and m.group(3).strip() != "???":
                ann[(int(m.group(1)), int(m.group(2)))] = m.group(3).strip()
    return ann


def load_map_to_asset():
    """map_id GBA -> stable_ground_id (asset campagne), depuis la table de
    conversion ROM déjà décodée (dev/docs/pmdred_eu/ground_manifest.json)."""
    p = os.path.join(REPO, "dev", "docs", "pmdred_eu",
                     "ground_manifest.json")
    m = json.load(open(p, encoding="utf-8"))
    out = {}
    for e in m["ground_conversion_table"]["entries"]:
        out[e["map_id"]] = e["stable_ground_id"]
    return out


def main():
    idx = json.load(open(os.path.join(CIN, "EVENT_SCRIPTS_INDEX.json")))
    dlg = json.load(open(os.path.join(CIN, "DIALOGUES_INDEX.json")))
    manifest = json.load(open(os.path.join(CAMP, "MANIFEST.json")))
    map_enum = load_map_enum()
    map_to_asset = load_map_to_asset()
    ann = load_state_annotations()

    ground_names = {g["ground"]: g.get("human_name_en") or g["ground"]
                    for g in manifest["grounds"]}

    # parcourir tous les scripts EVENT décodés : par script, collecter
    # SCENARIO ops + stations exécutées + appels
    ev_data = OrderedDict()
    for name, meta in idx["scripts"].items():
        f = os.path.join(CIN, meta.get("file", "")) if meta.get("file") \
            else None
        if not f or not os.path.exists(f):
            continue
        d = json.load(gzip.open(f, "rt"))
        stations, calls, jumps = [], [], []
        writes, guards = [], []
        # motif de dispatch : CJUMP_SCENARIO_0/1(var) suivi de COND
        # (0xCD JUDGE, 0xCC COND_EQUAL) → chaque COND lit main (0) ou
        # sub (1) de la variable scénario courante.
        pending_cjump = None  # (var, which) which: 0=main, 1=sub
        for c in d["commands"]:
            op = int(c["op"], 16)
            sem0 = c.get("semantic") or {}
            if sem0.get("kind") in ("CJUMP_SCENARIO_0",
                                    "CJUMP_SCENARIO_1"):
                pending_cjump = (sem0["var"],
                                 0 if sem0["kind"].endswith("_0") else 1)
            elif op in (0xCC, 0xCD, 0xCE):
                if pending_cjump:
                    var, which = pending_cjump
                    val = c["arg1"] if op in (0xCD, 0xCE) else c["arg_byte"]
                    if op == 0xCC:
                        val = c["arg1"]
                    guards.append(OrderedDict(
                        kind="DISPATCH_COND", var=var,
                        **({"main": val} if which == 0 else {"sub": val})))
            elif op not in (0xF4, 0xF6):  # LABEL/DEBUG n'interrompent pas
                pending_cjump = None
            if op in (0x1D, 0x1E):  # EXECUTE_STATION / EXECUTE_SUBSTATION
                mid = c["arg1"]
                mname = (map_enum[mid] if 0 <= mid < len(map_enum)
                         else (f"map_{mid}" if mid >= 0 else "CURRENT_MAP"))
                stations.append(OrderedDict(
                    kind=("EXECUTE_STATION" if op == 0x1D
                          else "EXECUTE_SUBSTATION"),
                    map_id=mid, map=mname,
                    asset=map_to_asset.get(mid),
                    group=c["arg_short"], sector=c["arg_byte"]))
            elif op == 0xE8:  # CALL_SCRIPT
                calls.append(c.get("semantic", {}).get("target")
                             or c["arg1"])
            sem = c.get("semantic")
            if sem:
                if sem["kind"] == "SCENARIO_CALC":
                    writes.append(sem)
                elif sem["kind"] == "JUMP_SCRIPT":
                    jumps.append(sem.get("target") or sem.get("target_id"))
                elif sem["kind"].startswith(("JUMPIF_SCENE",
                                             "CJUMP_SCENARIO",
                                             "JUMPIF_SCENARIOCHECK")):
                    guards.append(sem)
        ev_data[name] = OrderedDict(writes=writes, guards=guards,
                                    stations=stations, jumps=jumps,
                                    calls=calls)

    # index inverse : état -> écrivains / lecteurs
    writers = defaultdict(list)
    readers = defaultdict(list)
    readers_main_only = defaultdict(list)
    for name, d in ev_data.items():
        for w in d["writes"]:
            if w["var"] == "SCENARIO_MAIN":
                writers[(w["main"], w["sub"])].append(name)
        for g in d["guards"]:
            if g.get("var") != "SCENARIO_MAIN":
                continue
            if "main" in g and g.get("sub") is not None:
                readers[(g["main"], g["sub"])].append(name)
            elif "main" in g:
                readers_main_only[g["main"]].append(name)
            elif "sub" in g:
                # dispatch sub : lu pour TOUT état du major courant
                readers[("*sub*", g["sub"])].append(name)

    # dialogue par station GBA asset (t00p01 etc.) — mapping MAP_ -> asset
    # via l'ordre du manifest Red (les stations de campagne portent l'ID
    # gba) : approximation exacte impossible sans la table map->asset ;
    # on lie par les stations DIALOGUES_INDEX quand l'événement du même
    # nom (EVENT_<STATION>_Lxxx) existe.
    dlg_by_station = dlg["stations"]

    steps = []
    for (mj, mi) in sorted(writers):
        evs = sorted(set(writers[(mj, mi)]))
        stations = []
        dialogues = []
        seen_assets = set()
        for ev in evs:
            for st in ev_data[ev]["stations"]:
                stations.append(st)
                # dialogues de la station exécutée (asset résolu via la
                # table de conversion ROM map_id→stable_ground_id)
                asset = st.get("asset")
                # les variantes ...a/...b partagent le préfixe des
                # stations de dialogue (t01p02a etc.)
                for cand in ([asset] if asset else []):
                    for key in (cand, cand.rstrip("abc")):
                        if key in dlg_by_station and key not in seen_assets:
                            seen_assets.add(key)
                            s = dlg_by_station[key]
                            dialogues.append(OrderedDict(
                                station=key, status=s["status"],
                                text_blocks=s.get("text_blocks"),
                                file=s.get("file")))
                            break
        rd = sorted(set(readers.get((mj, mi), [])
                        + readers_main_only.get(mj, [])
                        + readers.get(("*sub*", mi), [])))
        steps.append(OrderedDict(
            state=f"{mj}.{mi}",
            annotation=ann.get((mj, mi)),
            written_by=evs,
            stations_executed=stations,
            dialogues=dialogues,
            read_by=rd or None,
            reachability="READ" if rd else "WRITTEN_NEVER_READ_EXACT"))

    out = OrderedDict(
        schema="red-playable-progression/1",
        authority="chaîne EVENT_* ROM EU décodée (ROM_DECODED) + stations "
                  "EU exactes + pret ground_map.h (enum) / event_flag.h "
                  "(annotations)",
        note="chaque étape cite ses événements, stations exécutées "
             "(EXECUTE_STATION résolus en MAP_*) et dialogues liés — "
             "aucune étape inventée",
        main_chain=steps,
        totals=OrderedDict(
            states=len(steps),
            with_stations=sum(1 for s in steps
                              if s["stations_executed"]),
            with_dialogues=sum(1 for s in steps if s["dialogues"]),
            read=sum(1 for s in steps if s["reachability"] == "READ"),
        ))
    os.makedirs(DOCS, exist_ok=True)
    p = os.path.join(DOCS, "PLAYABLE_PROGRESSION.json")
    json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False,
              indent=1)

    md = ["# Progression jouable — PMD Red Rescue Team (EU)\n",
          "Chaîne principale SCENARIO_MAIN, entièrement décodée de la ROM "
          "EU (events, stations, dialogues liés).\n",
          "| État | Annotation | Événements | Stations | Dialogues | Lu |",
          "|---|---|---|---|---|---|"]
    for s in steps:
        st = ", ".join(sorted({x["map"] for x in s["stations_executed"]})
                       ) or "—"
        dl = ", ".join(f"{d['station']}({d['text_blocks']})"
                       for d in s["dialogues"]) or "—"
        md.append(f"| `{s['state']}` | {s['annotation'] or '—'} | "
                  f"{', '.join(s['written_by'])} | {st} | {dl} | "
                  f"{'✓' if s['reachability'] == 'READ' else '∅'} |")
    open(os.path.join(DOCS, "PLAYABLE_PROGRESSION.md"), "w",
         encoding="utf-8").write("\n".join(md) + "\n")
    print("totals:", dict(out["totals"]))
    print(p)


if __name__ == "__main__":
    main()
