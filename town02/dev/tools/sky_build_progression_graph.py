#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_build_progression_graph.py — Graphe de progression canonique de PMD
Explorers of Sky EU, dérivé des scripts SSB décompilés de la ROM
(Cinematics/rom_scripts/*.json.gz, produits par sky_extract_rom_scripts.py).

Aucune invention : chaque nœud/arête est étayé par une occurrence textuelle
dans un ExplorerScript décompilé (fichier + script cités).

Modèle (moteur SSB réel) :
  - $SCENARIO_MAIN = scn[major, minor]  → ÉCRITURE d'état scénario
  - scn($SCENARIO_MAIN) ==/>=/< [maj, min] → LECTURE/GARDE
  - $SCENARIO_MAIN_BIT_FLAG[n] = 0/1 et lectures → drapeaux annexes
  - $SCENARIO_SIDE / $SCENARIO_SUB1..8 / $SIDE##_* → épisodes spéciaux et
    sous-progressions (inventoriés séparément, jamais fusionnés)
  - supervision_ExecuteActingSub(LEVEL_X, 'SCENE', …) → déclenchement scène

Sorties :
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/PROGRESSION_GRAPH.json
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/PROGRESSION_GRAPH.md
Analyse d'atteignabilité : états écrits jamais lus, états lus jamais écrits
(candidats hardcodés au boot ou dans l'ARM9 — documentés, pas masqués).
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
RE_READ = re.compile(
    r"scn\(\$SCENARIO_MAIN\)\s*(==|!=|>=|<=|<|>)\s*\[(\d+),\s*(\d+)\]")
RE_READ_MAJ = re.compile(r"\$SCENARIO_MAIN\s*(==|!=|>=|<=|<|>)\s*(\d+)")
RE_BIT_W = re.compile(r"\$SCENARIO_MAIN_BIT_FLAG\[(\d+)\]\s*=(?!=)\s*(\d+)")
RE_BIT_R = re.compile(r"\$SCENARIO_MAIN_BIT_FLAG\[(\d+)\]\s*(?!=\s*\d)")
RE_SCENE = re.compile(
    r"supervision_ExecuteActingSub\(LEVEL_(\w+),\s*'(\w+)'")
RE_SIDE_W = re.compile(r"\$(SCENARIO_SIDE|SCENARIO_SUB\d|SIDE\d+_\w+)"
                       r"\s*=(?!=)\s*([^;\n]{1,30})")


def main():
    os.makedirs(DOCS, exist_ok=True)
    writes = defaultdict(list)      # (maj,min) -> [(zone, script)]
    reads = defaultdict(list)       # (op,maj,min) -> [(zone, script)]
    bit_writes = defaultdict(list)  # (bit,val) -> ...
    bit_reads = defaultdict(list)
    scene_calls = defaultdict(list)  # (level, scene) -> ...
    side_writes = defaultdict(list)

    files = sorted(glob.glob(os.path.join(RS, "*.json.gz")))
    assert files, "rom_scripts absent — lancer sky_extract_rom_scripts.py"
    for f in files:
        zone = os.path.basename(f).split(".")[0]
        z = json.load(gzip.open(f, "rt"))
        for name, s in z["scripts"].items():
            src = s.get("explorerscript") or s.get("ssbscript") or ""
            if not src:
                continue
            loc = (zone, name)
            for m in RE_WRITE.finditer(src):
                writes[(int(m.group(1)), int(m.group(2)))].append(loc)
            for m in RE_READ.finditer(src):
                reads[(m.group(1), int(m.group(2)),
                       int(m.group(3)))].append(loc)
            for m in RE_READ_MAJ.finditer(src):
                reads[(m.group(1), int(m.group(2)), None)].append(loc)
            for m in RE_BIT_W.finditer(src):
                bit_writes[(int(m.group(1)), int(m.group(2)))].append(loc)
            for m in RE_BIT_R.finditer(src):
                bit_reads[int(m.group(1))].append(loc)
            for m in RE_SCENE.finditer(src):
                scene_calls[(m.group(1), m.group(2))].append(loc)
            for m in RE_SIDE_W.finditer(src):
                side_writes[(m.group(1), m.group(2).strip())].append(loc)

    # atteignabilité : état lu jamais écrit / écrit jamais lu
    written_states = set(writes)
    read_states = {(mj, mi) for (_, mj, mi) in reads if mi is not None}
    read_only = sorted(read_states - written_states)
    write_only = sorted(written_states -
                        {(mj, mi) for (mj, mi) in read_states})

    def fmt_locs(locs, cap=6):
        u = sorted(set(locs))
        return [f"{z}/{n}" for z, n in u[:cap]] + \
            ([f"+{len(u)-cap} autres"] if len(u) > cap else [])

    graph = OrderedDict()
    graph["schema"] = "sky-progression-graph/1"
    graph["authority"] = ("ROM Sky EU SCRIPT/ décompilé (3760 SSB, "
                          "sky_extract_rom_scripts.py) — chaque entrée cite "
                          "zone/script d'origine")
    graph["scenario_main"] = OrderedDict()
    graph["scenario_main"]["states_written"] = OrderedDict(
        (f"{mj}.{mi}", OrderedDict(
            writers=fmt_locs(writes[(mj, mi)]),
            readers=fmt_locs([l for (op, rmj, rmi), ls in reads.items()
                              if rmi is not None and (rmj, rmi) == (mj, mi)
                              for l in ls]),
        )) for (mj, mi) in sorted(writes))
    graph["scenario_main"]["read_never_written_in_scripts"] = [
        OrderedDict(state=f"{mj}.{mi}",
                    note="écrit hors SSB (init sauvegarde/ARM9) ou "
                         "borne de comparaison — REVIEW noté, pas masqué",
                    readers=fmt_locs([l for (op, rmj, rmi), ls in
                                      reads.items()
                                      if (rmj, rmi) == (mj, mi)
                                      for l in ls]))
        for (mj, mi) in read_only]
    graph["scenario_main"]["written_never_read_exact"] = [
        OrderedDict(state=f"{mj}.{mi}",
                    note="lu seulement via >=/< (bornes) ou jamais — "
                         "normal pour états de passage",
                    writers=fmt_locs(writes[(mj, mi)]))
        for (mj, mi) in write_only]
    graph["bit_flags"] = OrderedDict(
        (str(bit), OrderedDict(
            set_to=sorted({v for (b, v) in bit_writes if b == bit}),
            writers=fmt_locs([l for (b, v), ls in bit_writes.items()
                              if b == bit for l in ls]),
            n_reads=len(set(bit_reads.get(bit, [])))))
        for bit in sorted({b for (b, _) in bit_writes} |
                          set(bit_reads)))
    graph["side_and_sub_writes"] = OrderedDict(
        (f"{var} = {val}", fmt_locs(ls))
        for (var, val), ls in sorted(side_writes.items()))
    graph["scene_triggers"] = OrderedDict(
        (f"{lvl}/{scene}", fmt_locs(ls))
        for (lvl, scene), ls in sorted(scene_calls.items()))
    graph["totals"] = OrderedDict(
        scenario_states_written=len(writes),
        scenario_states_read=len(read_states),
        read_never_written=len(read_only),
        written_never_read_exact=len(write_only),
        bit_flags=len(graph["bit_flags"]),
        scene_triggers=len(scene_calls),
        side_sub_writes=len(side_writes),
    )

    out_json = os.path.join(DOCS, "PROGRESSION_GRAPH.json")
    with open(out_json, "w", encoding="utf-8") as fh:
        json.dump(graph, fh, ensure_ascii=False, indent=1)

    md = ["# Graphe de progression — PMD Explorers of Sky (EU)\n",
          "Source : 3760 SSB décompilés de la ROM EU (aucune invention ; "
          "chaque état cite ses scripts).\n",
          f"- États `$SCENARIO_MAIN` écrits : "
          f"**{len(writes)}** ; lus : **{len(read_states)}**",
          f"- États lus mais jamais écrits par un SSB : "
          f"**{len(read_only)}** (init sauvegarde/ARM9 — documentés)",
          f"- Bit flags scénario : **{len(graph['bit_flags'])}**",
          f"- Déclencheurs de scène (`ExecuteActingSub`) : "
          f"**{len(scene_calls)}**\n",
          "## Chaîne principale (ordre des états écrits)\n",
          "| État | Écrit par | Lu par |", "|---|---|---|"]
    for (mj, mi) in sorted(writes):
        w = ", ".join(fmt_locs(writes[(mj, mi)], 2))
        r = ", ".join(fmt_locs(
            [l for (op, rmj, rmi), ls in reads.items()
             if (rmj, rmi) == (mj, mi) for l in ls], 2)) or "—"
        md.append(f"| `{mj}.{mi}` | {w} | {r} |")
    with open(os.path.join(DOCS, "PROGRESSION_GRAPH.md"), "w",
              encoding="utf-8") as fh:
        fh.write("\n".join(md) + "\n")
    print("totals:", dict(graph["totals"]))
    print(out_json)


if __name__ == "__main__":
    main()
