#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""red_extract_eu_only_station.py — extraction EU-AUTORITAIRE des 3
stations REVIEW (t01p01, b01p01a, a05p02).

CAUSE des REVIEW : la comparaison structurelle avec pret (déclarations
US) échoue car la ROM EU contient des groupes/secteurs SUPPLÉMENTAIRES
(contenu régional). La ROM EU est l'autorité canonique : ce mode décode
le graphe EU COMPLET (decode_eu_graph, outillage existant réutilisé)
puis, pour CHAQUE owner du graphe (y compris les groupes EU absents de
pret), décode le tableau de commandes borné par le prochain nœud et les
blocs de texte 5 langues.

Garde-fous conservés (fail-closed) :
  - opcode terminal obligatoire par tableau ;
  - text blocks = 5 langues C-strings valides ;
  - count/pointer invariants du décodeur existant.
La demande d'alignement pret est REMPLACÉE par la provenance EU pure
(chaque commande garde son adresse ROM).
"""
import argparse
import importlib.util
import json
import gzip
import os
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location(
    "red_audit", os.path.join(HERE, "audit_pmdred_eu_all_ground_scripts.py"))
A = importlib.util.module_from_spec(spec)
sys.modules["red_audit"] = A
spec.loader.exec_module(A)

REPO = os.path.dirname(os.path.dirname(HERE))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM",
                    "Cinematics")

# stations REVIEW -> (regional_id, source_ground_id) : mêmes identifiants
# que l'audit (résolus par la découverte de candidats)
TARGETS = ["t01p01", "b01p01a", "a05p02"]


def decode_all_owners(reader, eu, asset):
    all_nodes = sorted(eu["node_addresses"])
    scripts = []
    text_blocks = {}
    for key, (name, root) in sorted(eu["owners"].items(), key=str):
        if name.startswith("FUNC_") or root == 0:
            continue
        upper = [a for a in all_nodes if a > root]
        upper_bound = min(upper) if upper else A.ROM_BASE + len(reader.data)
        max_records = max(1, min(4096, (upper_bound - root)
                                 // A.SCRIPT_COMMAND_SIZE))
        cmds = []
        terminal = None
        for i in range(max_records):
            core, pointer = A.decode_command(
                reader, root + i * A.SCRIPT_COMMAND_SIZE,
                f"{asset} {name} cmd {i}")
            labels = A.classify_command(core)
            text_ref = None
            if core.op in A.TEXT_OPCODES and pointer:
                if pointer not in text_blocks:
                    text_blocks[pointer] = A.decode_text_block(
                        reader, pointer, f"{asset} {name}[{i}] text")
                text_ref = A.address_hex(pointer)
            cmds.append({
                "index": i,
                "address": A.address_hex(root + i * A.SCRIPT_COMMAND_SIZE),
                "op": core.op, "op_hex": f"0x{core.op:02X}",
                "arg_byte": core.arg_byte, "arg_short": core.arg_short,
                "arg1": core.arg1, "arg2": core.arg2,
                "pointer": A.address_hex(pointer) if pointer else None,
                "text_block": text_ref, "categories": labels,
            })
            if "terminal" in labels:
                terminal = i
                break
        A.require(terminal is not None,
                  f"{asset} {name}: no terminal opcode within bound")
        scripts.append({
            "name": name, "owner_key": str(key),
            "address": A.address_hex(root),
            "command_count": len(cmds),
            "provenance": "EU_ROM_AUTHORITATIVE (pret alignment not "
                          "required: EU regional groups retained)",
            "commands": cmds,
        })
    return scripts, text_blocks


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("rom")
    ap.add_argument("--pret-root", required=True)
    ap.add_argument("--manifest", required=True)
    a = ap.parse_args()
    reader = A.RomReader(open(a.rom, "rb").read())

    candidates = A.discover_all_station_candidates(
        A.Path(a.pret_root), A.Path(a.manifest))
    by_asset = {c[0]: c for c in candidates}

    idx_p = os.path.join(CAMP, "DIALOGUES_INDEX.json")
    idx = json.load(open(idx_p))

    for asset in TARGETS:
        cand = by_asset.get(asset)
        if cand is None:
            print(asset, "CANDIDATE ABSENT")
            continue
        asset_name, regional_id = cand
        source_ref = A.compile_source_reference(
            asset_name, A.Path(a.pret_root), "gcc")
        eu = A.decode_eu_graph(reader, regional_id,
                               source_ref.source_ground_id)
        cmp_res = A.compare_structure(
            A.parse_source_structure(source_ref.structure_lines), eu)
        scripts, text_blocks = decode_all_owners(reader, eu, asset)
        n_dial = sum(1 for s in scripts for c in s["commands"]
                     if c["text_block"])
        out = {
            "schema": "pmdred-eu-station-eu-only/1",
            "asset": asset,
            "regional_ground_id": regional_id,
            "authority": "ROM EU 0f9d125d (pret = référence indicative; "
                         "divergence structurelle EU documentée)",
            "pret_structure_comparison": cmp_res,
            "eu_group_count": eu["group_count"],
            "scripts": scripts,
            "text_blocks": {A.address_hex(k): v
                            for k, v in sorted(text_blocks.items())},
        }
        out_p = os.path.join(CAMP, "dialogues", f"{asset}.json.gz")
        os.makedirs(os.path.dirname(out_p), exist_ok=True)
        with gzip.open(out_p, "wt", encoding="utf-8") as f:
            json.dump(out, f, ensure_ascii=False, indent=1)
        idx["stations"][asset] = {
            "file": f"dialogues/{asset}.json.gz",
            "status": "PASS_EU_AUTHORITATIVE",
            "text_blocks": len(text_blocks),
            "dialogue_ops": n_dial,
            "note": ("graphe EU complet décodé (groupes régionaux EU "
                     "inclus); alignement pret non exigé — ROM EU "
                     "autorité; mismatches pret documentés: "
                     + str(cmp_res["mismatch_count"])),
        }
        print(f"{asset}: {len(scripts)} scripts, {len(text_blocks)} "
              f"text blocks 5 langues, {n_dial} ops dialogue, "
              f"pret mismatches documentés: {cmp_res['mismatch_count']}")
    json.dump(idx, open(idx_p, "w"), indent=1, ensure_ascii=False)
    print("index mis à jour")


if __name__ == "__main__":
    main()
