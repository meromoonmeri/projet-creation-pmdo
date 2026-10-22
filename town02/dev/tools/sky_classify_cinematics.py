#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_classify_cinematics.py — Classification d'intégrabilité PMDO de TOUTES
les scènes SSB de Sky EU (§7 : extraction ≠ intégration ≠ fidélité).

RÉUTILISE la table curatée opcode→idiome PMDO de dev/tools/ssb_coverage.py
(89 opcodes : OK/ADAPT/PARTIEL/NON, construite pour l'arc du futur et
validée) et l'étend par comptage des opcodes réellement présents dans les
3760 SSB décompilés.

Classification PAR SCÈNE (statuts stricts, jamais fusionnés) :
  NATIVELY_SUPPORTED       — 100% des ops de la scène sont OK
  TECHNICALLY_ADAPTABLE    — ops OK/ADAPT uniquement (couche d'adaptation
                             New Era requise : cast, BGM, anims, SE)
  PARTIAL_FIDELITY         — contient des ops PARTIEL (idiome approximatif,
                             signalé)
  REQUIRES_ENGINE_EXTENSION— contient des ops NON (aucun équivalent PMDO)
  UNKNOWN_OPCODES          — contient des ops hors table curatée (comptés,
                             listés — le travail de curation doit continuer)
Toutes les scènes restent NOT_YET_INTEGRATED au runtime : cette
classification mesure l'ADAPTABILITÉ, pas l'intégration.

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/CINEMATIC_INTEGRABILITY.json
         + .md
"""
import glob
import gzip
import importlib.util
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
RS = os.path.join(CAMP, "Cinematics", "rom_scripts")
DOCS = os.path.join(CAMP, "Docs")

# opcode = identifiant suivi de '(' dans l'ExplorerScript décompilé
RE_OP = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*\(")
KEYWORDS = {"if", "elseif", "while", "switch", "case", "sector", "scn",
            "not", "def", "for", "forever", "with", "debug", "return",
            "macro"}


def load_curated_table():
    spec = importlib.util.spec_from_file_location(
        "ssb_coverage", os.path.join(REPO, "dev", "tools",
                                     "ssb_coverage.py"))
    m = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(m)
    except FileNotFoundError:
        pass  # le main() du module échoue hors de son environnement — la
        # table M est déjà construite au moment de l'import
    return m.M


def main():
    M = load_curated_table()
    scene_class = Counter()
    unknown_ops = Counter()
    op_usage = Counter()
    scenes = OrderedDict()
    for f in sorted(glob.glob(os.path.join(RS, "*.json.gz"))):
        zone = os.path.basename(f).split(".")[0]
        z = json.load(gzip.open(f, "rt"))
        for name, s in z["scripts"].items():
            src = s.get("explorerscript")
            if not src:
                continue
            # retirer les littéraux de chaîne (les dialogues contiennent
            # des mots suivis de parenthèses -> faux opcodes)
            src_clean = re.sub(r'"""(?:.|\n)*?"""', '""', src)
            src_clean = re.sub(r"'(?:[^'\\]|\\.)*'", "''", src_clean)
            src_clean = re.sub(r'"(?:[^"\\]|\\.)*"', '""', src_clean)
            ops = Counter()
            for mo in RE_OP.finditer(src_clean):
                op = mo.group(1)
                if op in KEYWORDS or op.startswith("label_"):
                    continue
                ops[op] += 1
                op_usage[op] += 1
            statuses = set()
            unk = []
            for op in ops:
                info = M.get(op)
                if info is None:
                    unk.append(op)
                    unknown_ops[op] += 1
                else:
                    statuses.add(info["status"])
            if unk:
                cls = "UNKNOWN_OPCODES"
            elif "NON" in statuses:
                cls = "REQUIRES_ENGINE_EXTENSION"
            elif "PARTIEL" in statuses:
                cls = "PARTIAL_FIDELITY"
            elif "ADAPT" in statuses:
                cls = "TECHNICALLY_ADAPTABLE"
            else:
                cls = "NATIVELY_SUPPORTED"
            scene_class[cls] += 1
            scenes[f"{zone}/{name}"] = OrderedDict(
                classification=cls,
                runtime_status="NOT_YET_INTEGRATED",
                ops_total=sum(ops.values()),
                ops_distinct=len(ops),
                unknown_ops=sorted(unk) or None)

    out = OrderedDict(
        schema="sky-cinematic-integrability/1",
        authority="table curatée ssb_coverage.py (89 opcodes, idiomes "
                  "PMDO attestés) appliquée aux 3760 SSB décompilés",
        rule="ADAPTABILITÉ mesurée, PAS intégration : toutes les scènes "
             "restent NOT_YET_INTEGRATED au runtime",
        totals=OrderedDict(scenes=len(scenes), **dict(scene_class)),
        top_unknown_opcodes=OrderedDict(unknown_ops.most_common(60)),
        scenes=scenes)
    p = os.path.join(DOCS, "CINEMATIC_INTEGRABILITY.json")
    json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False,
              indent=1)

    md = ["# Intégrabilité cinématique PMDO — scènes SSB Sky EU\n",
          "Classification par la table curatée d'idiomes PMDO "
          "(ssb_coverage.py). **Aucune scène n'est intégrée au runtime** — "
          "ceci mesure l'adaptabilité technique.\n",
          "| Classe | Scènes |", "|---|---|"]
    for k, v in scene_class.most_common():
        md.append(f"| {k} | {v} |")
    md.append("\n## Opcodes hors table curatée (à curer ensuite)\n")
    md.append("| Opcode | Occurrences (scènes) |")
    md.append("|---|---|")
    for k, v in unknown_ops.most_common(40):
        md.append(f"| `{k}` | {v} |")
    open(os.path.join(DOCS, "CINEMATIC_INTEGRABILITY.md"), "w",
         encoding="utf-8").write("\n".join(md) + "\n")
    print("scenes:", len(scenes), dict(scene_class))
    print("unknown opcodes distincts:", len(unknown_ops))
    print(p)


if __name__ == "__main__":
    main()
