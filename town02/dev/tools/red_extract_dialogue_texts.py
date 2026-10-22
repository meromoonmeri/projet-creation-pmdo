#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
red_extract_dialogue_texts.py — Matérialise dans la campagne PMD_RED les
dialogues canoniques 5 langues extraits de la ROM Red EU.

Source : converter/rom_cache/eu_ground_scripts_all_stations.json, produit par
dev/tools/audit_pmdred_eu_all_ground_scripts.py (ROM EU sha256 0f9d125d…,
pret/pmd-red en référence technique). Ce fichier est git-ignoré (15 Mo) ;
le présent outil en dérive un artefact de campagne versionnable.

Fidélité :
  - AUCUN texte réécrit : raw_hex + text (vue Latin-1, markup ~XX préservé)
    copiés tels quels, par langue, avec les adresses ROM.
  - L'ordre des dialogues est celui des OPÉRATIONS de script (op text avec
    text_block) — pas un tri arbitraire. Les blocs jamais référencés par une
    op décodée restent listés dans `unreferenced_blocks` (rien n'est perdu).
  - Les stations sans graphe EU exact (technical_gaps) sont listées avec le
    statut REVIEW_REQUIRED, jamais inventées.

Sorties :
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Cinematics/dialogues/<asset>.json.gz
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Cinematics/DIALOGUES_INDEX.json
"""
import gzip
import json
import os
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REPORT = os.path.join(REPO, "converter", "rom_cache",
                      "eu_ground_scripts_all_stations.json")
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM",
                    "Cinematics")
OUT_DIR = os.path.join(CAMP, "dialogues")
INDEX = os.path.join(CAMP, "DIALOGUES_INDEX.json")


def main():
    rep = json.load(open(REPORT, encoding="utf-8"))
    os.makedirs(OUT_DIR, exist_ok=True)
    index = OrderedDict()
    index["schema"] = "red-dialogues-index/1"
    index["source_rom_sha256"] = rep["authority"]["rom_sha256"] \
        if isinstance(rep.get("authority"), dict) and \
        "rom_sha256" in rep.get("authority", {}) else \
        "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
    index["extractor"] = "audit_pmdred_eu_all_ground_scripts.py --all-stations"
    index["languages"] = ["en", "fr", "de", "es", "it"]
    index["stations"] = OrderedDict()

    total_blocks = 0
    for cand in sorted(rep["candidates"], key=lambda c: c["asset"]):
        asset = cand["asset"]
        blocks = {b["address"]: b for b in cand["text_blocks"]}
        referenced = []
        seen = set()
        for sc in cand["scripts"]:
            for cm in sc["commands"]:
                tb = cm.get("text_block")
                if tb and tb in blocks:
                    referenced.append(OrderedDict(
                        script=sc.get("name") or sc["address"],
                        command_index=cm["index"],
                        command_address=cm["address"],
                        op=cm["op_hex"],
                        block=blocks[tb],
                    ))
                    seen.add(tb)
        unreferenced = [blocks[a] for a in sorted(blocks) if a not in seen]
        out = OrderedDict()
        out["asset"] = asset
        out["header_address"] = cand["header_address"]
        out["validation"] = cand["validation"]
        out["dialogue_ops"] = referenced
        out["unreferenced_blocks"] = unreferenced
        path = os.path.join(OUT_DIR, f"{asset}.json.gz")
        with gzip.open(path, "wt", encoding="utf-8") as fh:
            json.dump(out, fh, ensure_ascii=False, indent=1)
        index["stations"][asset] = OrderedDict(
            file=f"dialogues/{asset}.json.gz",
            status="PASS",
            text_blocks=len(blocks),
            dialogue_ops=len(referenced),
            unreferenced_blocks=len(unreferenced),
        )
        total_blocks += len(blocks)

    # stations non décodées exactement : statut honnête, jamais PASS
    for gap in rep.get("technical_gaps", []):
        a = gap["asset"]
        if a not in index["stations"]:
            index["stations"][a] = OrderedDict(
                file=None, status="REVIEW_REQUIRED",
                error=gap["error"][:300])

    n_pass = sum(1 for s in index["stations"].values()
                 if s["status"] == "PASS")
    index["totals"] = OrderedDict(
        stations_total=len(index["stations"]),
        stations_pass=n_pass,
        stations_review_required=len(index["stations"]) - n_pass,
        text_blocks_total=total_blocks,
        coverage_note="Dialogues 5 langues disponibles pour les stations "
                      "PASS uniquement ; les REVIEW_REQUIRED attendent le "
                      "décodage exact du graphe EU (jamais fusionner).",
    )
    with open(INDEX, "w", encoding="utf-8") as fh:
        json.dump(index, fh, ensure_ascii=False, indent=1)
    print(f"stations PASS: {n_pass}, REVIEW_REQUIRED: "
          f"{len(index['stations']) - n_pass}, text_blocks: {total_blocks}")
    print("INDEX:", INDEX)


if __name__ == "__main__":
    main()
