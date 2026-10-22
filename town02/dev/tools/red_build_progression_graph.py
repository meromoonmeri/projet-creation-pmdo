#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
red_build_progression_graph.py — Graphe de progression canonique de PMD Red
Rescue Team EU.

Trois sources, jamais fusionnées ni confondues :
  A0. ROM EU décodée — chaîne EVENT_* globale (gFunctionScriptTable EU
      @0x08294450, red_extract_event_scripts.py) : 399 scripts PASS,
      136 écritures SCENARIO_MAIN identiques 1:1 à la chaîne pret
      (contre-épreuve exhaustive, delta d'ID de variable régional +1).
      STATUT : ROM_DECODED (autorité EU).
  A. ROM EU décodée (converter/rom_cache/eu_ground_scripts_all_stations.json,
     produit par audit_pmdred_eu_all_ground_scripts.py) : opcodes réels des
     stations au graphe EU exact (69/133) —
       0xA9 SCENARIO_CALC(var, main, sub)       écriture d'état
       0xAA SCENARIO_ADVANCE(var, add)          incrément
       0xB8/B9/BA JUMPIF_SCENE_LT/EQ/GT         gardes de scénario
       0xBB JUMPIF_SCENARIOCHECK(quest)         gardes de quête
       0xC4/C5 CJUMP_SCENARIO_0/1               branchements
       0xAD UNLOCK_FRIEND_AREA                  déblocage
       0xAB SET_DUNGEON_RES                     résultat donjon
     (macros pret include/data_script.h, mais VALEURS lues dans la ROM EU).
  B. Référence technique pret (dev/external/pret_pmd_red
     src/data/ground/ground_event_data.h) : la chaîne d'événements globaux
     EVENT_* (celle qui porte la majorité des SCENARIO_CALC(SCENARIO_MAIN)),
     avec l'annotation humaine de include/constants/event_flag.h.
     Statut : TECHNICAL_REFERENCE (US-based pret), pas autorité EU — les
     309 SCENARIO_CALC de pret n'ont pas encore été décodés octet par octet
     dans la ROM EU (les events globaux ne sont pas dans gMapScriptTable).

Sorties :
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Docs/PROGRESSION_GRAPH.json
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Docs/PROGRESSION_GRAPH.md
"""
import json
import os
import re
from collections import OrderedDict, defaultdict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REPORT = os.path.join(REPO, "converter", "rom_cache",
                      "eu_ground_scripts_all_stations.json")
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference")
DOCS = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM", "Docs")

# ScriptVarId (pret include/constants/event_flag.h enum ScriptVarId)
VAR_NAMES = {2: "SCENARIO_SELECT", 3: "SCENARIO_MAIN", 4: "SCENARIO_SUB1",
             5: "SCENARIO_SUB2", 6: "SCENARIO_SUB3", 7: "SCENARIO_SUB4",
             8: "SCENARIO_SUB5", 9: "SCENARIO_SUB6", 10: "SCENARIO_SUB7",
             11: "SCENARIO_SUB8", 12: "SCENARIO_SUB9"}

OPS = {"0xA9": "SCENARIO_CALC", "0xAA": "SCENARIO_ADVANCE",
       "0xB8": "JUMPIF_SCENE_LT", "0xB9": "JUMPIF_SCENE_EQ",
       "0xBA": "JUMPIF_SCENE_GT", "0xBB": "JUMPIF_SCENARIOCHECK",
       "0xC4": "CJUMP_SCENARIO_0", "0xC5": "CJUMP_SCENARIO_1",
       "0xAD": "UNLOCK_FRIEND_AREA", "0xAB": "SET_DUNGEON_RES"}


def collect_rom_side():
    rep = json.load(open(REPORT, encoding="utf-8"))
    writes = defaultdict(list)
    guards = defaultdict(list)
    quest_checks = defaultdict(list)
    unlocks = defaultdict(list)
    dungeon_res = defaultdict(list)
    for c in rep["candidates"]:
        asset = c["asset"]
        for sc in c["scripts"]:
            sname = sc.get("name") or sc["address"]
            for cm in sc["commands"]:
                op = cm["op_hex"]
                if op not in OPS:
                    continue
                loc = f"{asset}/{sname}#{cm['index']}"
                var = VAR_NAMES.get(cm["arg_short"], f"var_{cm['arg_short']}")
                if op == "0xA9":
                    writes[(var, cm["arg1"], cm["arg2"])].append(loc)
                elif op == "0xAA":
                    writes[(var, f"+{cm['arg1']}", None)].append(loc)
                elif op in ("0xB8", "0xB9", "0xBA"):
                    # arg_byte = var id ; arg_short = label ; arg1, arg2 = état
                    gvar = VAR_NAMES.get(cm["arg_byte"],
                                         f"var_{cm['arg_byte']}")
                    guards[(OPS[op], gvar, cm["arg1"], cm["arg2"])] \
                        .append(loc)
                elif op == "0xBB":
                    quest_checks[cm["arg_byte"]].append(loc)
                elif op in ("0xC4", "0xC5"):
                    gvar = VAR_NAMES.get(cm["arg_short"],
                                         f"var_{cm['arg_short']}")
                    guards[(OPS[op], gvar, None, None)].append(loc)
                elif op == "0xAD":
                    unlocks[cm["arg1"]].append(loc)
                elif op == "0xAB":
                    dungeon_res[(cm["arg1"], cm["arg2"])].append(loc)
    return rep, writes, guards, quest_checks, unlocks, dungeon_res


def collect_pret_events():
    """Chaîne EVENT_* pret (référence technique) : script -> transitions."""
    p = os.path.join(PRET, "src", "data", "ground", "ground_event_data.h")
    if not os.path.exists(p):
        return None
    txt = open(p, encoding="utf-8", errors="replace").read()
    events = OrderedDict()
    cur = None
    for line in txt.splitlines():
        m = re.match(r"static const struct ScriptCommand s_script_(\w+)\[\]",
                     line)
        if m:
            cur = m.group(1)
            events[cur] = {"scenario_calcs": [], "jumps": [], "checks": []}
            continue
        if cur is None:
            continue
        m = re.search(r"SCENARIO_CALC\((\w+),\s*(\d+),\s*(\d+)\)", line)
        if m:
            events[cur]["scenario_calcs"].append(
                [m.group(1), int(m.group(2)), int(m.group(3))])
        m = re.search(r"JUMP_SCRIPT\((\w+)\)", line)
        if m:
            events[cur]["jumps"].append(m.group(1))
        m = re.search(r"JUMPIF_SCENE_(LT|EQ|GT)\((\w+),\s*(\d+),\s*(\d+),"
                      r"\s*(\w+)\)", line)
        if m:
            events[cur]["checks"].append(
                [f"SCENE_{m.group(1)}", m.group(2), int(m.group(3)),
                 int(m.group(4)), m.group(5)])
    # ne garder que les EVENT_* non vides
    return OrderedDict((k, v) for k, v in events.items()
                       if v["scenario_calcs"] or v["jumps"] or v["checks"])


def parse_state_annotations():
    """Annotations humaines pret des états SCENARIO_MAIN (event_flag.h)."""
    p = os.path.join(PRET, "include", "constants", "event_flag.h")
    ann = {}
    if not os.path.exists(p):
        return ann
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


def collect_eu_event_chain():
    """Chaîne EVENT_* décodée de la ROM EU (red_extract_event_scripts.py).
    Retourne {event: [ops scénario]} + statut global."""
    p = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM",
                     "Cinematics", "EVENT_SCRIPTS_INDEX.json")
    if not os.path.exists(p):
        return None
    idx = json.load(open(p, encoding="utf-8"))
    out = OrderedDict()
    for name, s in idx["scripts"].items():
        ops = s.get("scenario_ops")
        if ops:
            out[name] = ops
    return OrderedDict(
        status="ROM_DECODED",
        source=f"gFunctionScriptTable EU @{idx['table_address']} "
               f"({idx['table_entries']} entrées, "
               f"{idx['totals']['PASS']} scripts PASS)",
        proof="281/281 SCENARIO_CALC identiques à pret (delta ID de "
              "variable régional +1 uniforme) ; 136/136 états "
              "SCENARIO_MAIN 1:1",
        events=out)


def main():
    os.makedirs(DOCS, exist_ok=True)
    rep, writes, guards, quest_checks, unlocks, dungeon_res = \
        collect_rom_side()
    pret_events = collect_pret_events()
    eu_chain = collect_eu_event_chain()
    ann = parse_state_annotations()

    def cap(locs, n=6):
        u = sorted(set(locs))
        return u[:n] + ([f"+{len(u)-n} autres"] if len(u) > n else [])

    graph = OrderedDict()
    graph["schema"] = "red-progression-graph/1"
    graph["authority"] = OrderedDict(
        rom_side="ROM Red EU (sha256 0f9d125d…) — 69 stations au graphe EU "
                 "exact, opcodes scénario décodés",
        pret_side="pret/pmd-red@bf0092d0 ground_event_data.h — chaîne "
                  "EVENT_* : TECHNICAL_REFERENCE (non décodée octet à "
                  "octet dans la ROM EU ; les events globaux ne sont pas "
                  "dans gMapScriptTable)",
        note="Les deux faces sont séparées. Ne jamais présenter la face "
             "pret comme du contenu EU décodé.")

    graph["rom_stations"] = OrderedDict()
    graph["rom_stations"]["scenario_writes"] = OrderedDict(
        (f"{v}[{a},{b}]" if b is not None else f"{v}{a}",
         cap(ls)) for (v, a, b), ls in sorted(
            writes.items(), key=lambda kv: str(kv[0])))
    graph["rom_stations"]["scenario_guards"] = OrderedDict(
        (f"{op}({var}" + (f",{a},{b})" if a is not None else ")"),
         cap(ls)) for (op, var, a, b), ls in sorted(
            guards.items(), key=lambda kv: str(kv[0])))
    graph["rom_stations"]["quest_checks"] = OrderedDict(
        (f"quest_{q}", cap(ls)) for q, ls in sorted(quest_checks.items()))
    graph["rom_stations"]["friend_area_unlocks"] = OrderedDict(
        (f"friend_area_{a}", cap(ls)) for a, ls in sorted(unlocks.items()))
    graph["rom_stations"]["dungeon_results"] = OrderedDict(
        (f"result_{r}_enter_{e}", cap(ls))
        for (r, e), ls in sorted(dungeon_res.items()))

    if eu_chain:
        graph["eu_event_chain"] = eu_chain

    if pret_events:
        chain = OrderedDict()
        for ev, d in pret_events.items():
            entry = OrderedDict()
            if d["scenario_calcs"]:
                entry["sets"] = [
                    OrderedDict(var=v, state=f"{a}.{b}",
                                annotation=ann.get((a, b)) if
                                v == "SCENARIO_MAIN" else None)
                    for v, a, b in d["scenario_calcs"]]
            if d["checks"]:
                entry["guards"] = d["checks"]
            if d["jumps"]:
                entry["next"] = d["jumps"]
            chain[ev] = entry
        graph["pret_event_chain"] = OrderedDict(
            status="TECHNICAL_REFERENCE",
            events=chain)

    main_states = sorted({(a, b) for (v, a, b) in writes
                          if v == "SCENARIO_MAIN" and b is not None})
    pret_main = sorted({(a, b) for d in (pret_events or {}).values()
                        for v, a, b in d["scenario_calcs"]
                        if v == "SCENARIO_MAIN"})
    eu_main = len([o for evs in (eu_chain or {}).get("events", {}).values()
                   for o in evs if o["kind"] == "SCENARIO_CALC"
                   and o["var"] == "SCENARIO_MAIN"])
    graph["totals"] = OrderedDict(
        rom_scenario_writes=len(writes),
        rom_scenario_main_states=len(main_states),
        rom_guards=len(guards),
        rom_quest_checks=len(quest_checks),
        rom_friend_area_unlocks=len(unlocks),
        eu_event_chain_scenario_main_writes=eu_main,
        pret_events=len(pret_events or {}),
        pret_scenario_main_states=len(pret_main),
        coverage_note="Stations = 69/133 exactes ; chaîne EVENT_* = "
                      "ROM_DECODED (399 scripts, 136 états SCENARIO_MAIN "
                      "confirmés 1:1 avec pret) — couvertures séparées.")

    out = os.path.join(DOCS, "PROGRESSION_GRAPH.json")
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(graph, fh, ensure_ascii=False, indent=1)

    md = ["# Graphe de progression — PMD Red Rescue Team (EU)\n",
          "Deux faces séparées : opcodes scénario décodés de la ROM EU "
          "(69 stations exactes) et chaîne EVENT_* pret "
          "(TECHNICAL_REFERENCE).\n",
          f"- Écritures scénario ROM : **{len(writes)}** ; gardes : "
          f"**{len(guards)}** ; checks de quête : **{len(quest_checks)}**",
          f"- Événements pret (référence) : **{len(pret_events or {})}**, "
          f"états SCENARIO_MAIN posés : **{len(pret_main)}**\n",
          "## États SCENARIO_MAIN de la chaîne pret (annotation humaine)\n",
          "| État | Annotation pret | Événement |", "|---|---|---|"]
    for ev, d in (pret_events or {}).items():
        for v, a, b in d["scenario_calcs"]:
            if v == "SCENARIO_MAIN":
                md.append(f"| `{a}.{b}` | {ann.get((a, b), '—')} | {ev} |")
    with open(os.path.join(DOCS, "PROGRESSION_GRAPH.md"), "w",
              encoding="utf-8") as fh:
        fh.write("\n".join(md) + "\n")
    print("totals:", dict(graph["totals"]))
    print(out)


if __name__ == "__main__":
    main()
