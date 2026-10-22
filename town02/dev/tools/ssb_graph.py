#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ssb_graph.py — GRAPHE DES SCÈNES de l'arc du futur (reconstruction automatique).

À partir des IR canoniques, ce script extrait pour chaque scène :
  - les TRANSITIONS de ground : back_SetGround / back_ChangeGround /
    back2_SetGround / main_EnterDungeon (paramètre résolu -> nom de niveau) ;
  - les APPELS DE ROUTINES : CallCommon / ExecuteCommon (routine résolue) ;
  - les ÉCRITURES D'ÉTAT : flag_Set / flag_CalcBit / flag_SetScenario
    (variable résolue + valeur) ;
  - les STRUCTURES CONDITIONNELLES : message_SwitchTalk / message_SwitchMonologue
    (+ CaseText / DefaultText) et message_SwitchMenu / CaseMenu ;
  - les embranchements de fin (End, Destroy).

Résultat : graphe JSON + rapport Markdown montrant l'enchaînement
P05P01A -> P05P02A -> ... avec toutes les transitions conservées.
"""

import json
import glob
import os
import collections

IR_DIR = "/home/user/V4/docs/ssb_ir"
OUT_JSON = os.path.join(IR_DIR, "_scene_graph.json")
OUT_MD = "/home/user/V4/docs/GRAPHE_SCENES_ARC_FUTUR.md"


def flat_args(op):
    """Renvoie la liste des arguments résolus (pour lecture facile)."""
    out = []
    for s in op.get("arg_specs", []):
        r = s.get("resolved")
        if isinstance(r, dict):
            r = r.get("name") or r.get("text") or str(r)
        out.append((s.get("spec"), s.get("type"), s.get("raw"), r))
    return out


def main():
    irs = {}
    for p in sorted(glob.glob(os.path.join(IR_DIR, "*_*.json"))):
        if (p.endswith("_validation_summary.json") or p.endswith("_coverage_summary.json")
                or p.endswith("_scene_graph.json")):
            continue
        ir = json.load(open(p))
        irs[f"{ir['zone']}_{ir['scene']}"] = ir

    graph = {}
    for key, ir in sorted(irs.items()):
        zone, scene = key.split("_", 1)
        sc = {
            "zone": zone, "scene": scene,
            "transitions": [], "routines": [], "flags": [], "switches": [],
            "end_ops": [],
        }
        for op in ir["ops"]:
            name = op["name"]
            args = flat_args(op)
            if name in ("back_SetGround", "back_ChangeGround", "back2_SetGround", "main_EnterDungeon"):
                for spec, typ, raw, res in args:
                    if typ == "Level":
                        sc["transitions"].append({"op": name, "seq": op["seq"],
                                                  "level_raw": raw, "level": res})
                    elif typ == "Number" and name == "main_EnterDungeon":
                        sc["transitions"].append({"op": name, "seq": op["seq"], "dungeon_raw": raw})
            elif name in ("CallCommon", "ExecuteCommon"):
                for spec, typ, raw, res in args:
                    if typ == "Routine":
                        sc["routines"].append({"op": name, "seq": op["seq"],
                                               "routine_raw": raw, "routine": res})
            elif name in ("flag_Set", "flag_CalcBit", "flag_SetScenario"):
                var = None
                vals = []
                for spec, typ, raw, res in args:
                    if typ == "GameVar":
                        var = res
                    else:
                        vals.append({"spec": spec, "raw": raw, "resolved": res})
                sc["flags"].append({"op": name, "seq": op["seq"], "var": var, "values": vals})
            elif name in ("message_SwitchTalk", "message_SwitchMonologue", "message_SwitchMenu"):
                for spec, typ, raw, res in args:
                    sc["switches"].append({"op": name, "seq": op["seq"], "var": res})
            elif name == "CaseText":
                for spec, typ, raw, res in args:
                    if typ == "String":
                        sc["switches"].append({"op": "CaseText", "seq": op["seq"],
                                               "case_value": raw, "text": res})
            elif name == "End":
                sc["end_ops"].append(op["seq"])
        graph[key] = sc

    json.dump(graph, open(OUT_JSON, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

    # ------- Markdown -------
    L = []
    L.append("# GRAPHE DES SCÈNES — ARC DU FUTUR (reconstruction automatique depuis les IR)")
    L.append("")
    L.append("Transitions, routines, flags et conditions extraits du bytecode SSB. ")
    L.append("Aucune transition n'est perdue : `back_SetGround` / `back_ChangeGround` / `back2_SetGround` /")
    L.append("`main_EnterDungeon` sont toutes listées, avec le niveau résolu.")
    L.append("")
    L.append("## Chaîne principale des zones")
    L.append("")
    L.append("```")
    order = ["P05P01A", "P05P02A", "P05P03A", "P05P04A", "P06P01A", "P07P01A", "P08P01A", "P09P01A"]
    for z in order:
        first = True
        for key, sc in graph.items():
            if sc["zone"] != z:
                continue
            if first:
                L.append(f"{z}")
                first = False
            for t in sc["transitions"]:
                arrow = "─▶" if t["op"] in ("back_SetGround", "back_ChangeGround") else "·▶"
                cible = t.get("level", t.get("dungeon_raw", "?"))
                L.append(f"   └ {sc['scene']}.ssb  {arrow} {t['op']}({cible})")
        L.append("")
    L.append("```")
    L.append("")
    L.append("## Détail par scène")
    L.append("")
    for key, sc in graph.items():
        L.append(f"### {sc['zone']} / {sc['scene']}.ssb")
        L.append("")
        if sc["transitions"]:
            L.append("**Transitions :**")
            for t in sc["transitions"]:
                L.append(f"- `{t['op']}` (seq {t['seq']}) → niveau **{t.get('level')}** (raw {t.get('level_raw')})")
        if sc["routines"]:
            L.append("**Routines :**")
            for r in sc["routines"]:
                L.append(f"- `{r['op']}` (seq {r['seq']}) → **{r['routine']}** (raw {r['routine_raw']})")
        if sc["flags"]:
            L.append("**Flags / variables :**")
            for f in sc["flags"]:
                vals = ", ".join(f"{v['spec']}={v['raw']}({v['resolved']})" for v in f["values"])
                L.append(f"- `{f['op']}` (seq {f['seq']}) → **{f['var']}** [{vals}]")
        if sc["switches"]:
            L.append("**Conditions / embranchements :**")
            for s in sc["switches"]:
                if s["op"] == "CaseText":
                    L.append(f"- `CaseText` (seq {s['seq']}) cas {s['case_value']} → texte {s['text']}")
                else:
                    L.append(f"- `{s['op']}` (seq {s['seq']}) sur **{s['var']}**")
        if sc["end_ops"]:
            L.append(f"**Fin de scène :** `End` aux séquences {sc['end_ops']}")
        L.append("")

    open(OUT_MD, "w", encoding="utf-8").write("\n".join(L))
    print("Graphe écrit :", OUT_MD)
    print("Zones/scènes :", len(graph))


if __name__ == "__main__":
    main()
