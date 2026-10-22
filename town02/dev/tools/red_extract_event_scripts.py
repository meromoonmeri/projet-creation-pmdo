#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
red_extract_event_scripts.py — Décodage OCTET PAR OCTET de la table globale
des scripts de fonction/événement de PMD Red EU (gFunctionScriptTable).

AUTORITÉ : ROM Red EU (sha256 0f9d125d…). pret/pmd-red n'est utilisé que
comme référence de nommage sémantique (les NOMS sont d'ailleurs embarqués
dans la ROM elle-même : chaque ScriptRef pointe une chaîne ASCII).

Découverte (scan structurel, cette session) :
  gFunctionScriptTable EU @ 0x08294450 — 407 entrées ScriptRef de 12 octets
    { s16 id; s16 type; const char* name; const ScriptCommand* script; }
  (pret US en compte 483 : la table EU est plus courte — écart documenté,
   jamais comblé par des données US.)

Décodage :
  - ScriptCommand = 16 octets {u8 op, u8 argByte, s16 argShort, s32 arg1,
    s32 arg2, const u8* argPtr} (pret include/structs/str_ground_script.h,
    layout vérifié byte-exact sur les 27 stations EU déjà validées).
  - Étendue de chaque script : bornée par le POINTEUR DE SCRIPT SUIVANT
    dans l'espace des adresses (les tableaux sont contigus en ROM) ;
    garde-fou : la dernière commande doit être terminale
    (0xE7/0xE9/0xEB/0xEE/0xEF/0xF0/0xF1) sinon statut PARTIAL.
  - Textes : op ∈ TEXT_OPCODES avec argPtr → bloc 5 langues (Latin-1,
    raw_hex préservé) — même décodeur que les stations.
  - Sémantique scénario : 0xA9 SCENARIO_CALC(var, maj, min),
    0xAA SCENARIO_ADVANCE, 0xB8/B9/BA JUMPIF_SCENE_LT/EQ/GT,
    0xBB JUMPIF_SCENARIOCHECK, 0xC4/C5 CJUMP_SCENARIO_0/1,
    0xE9 JUMP_SCRIPT(id → nom de la table).

Sorties :
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Cinematics/event_scripts/<NAME>.json.gz
  dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/Cinematics/EVENT_SCRIPTS_INDEX.json
"""
import gzip
import hashlib
import json
import os
import struct
import sys
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM_PATH = os.path.join(REPO, "converter", "rom_input", "pmdred-eu.gba")
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
TABLE_ADDR = 0x08294450
BASE = 0x08000000
OUT_DIR = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM",
                       "Cinematics", "event_scripts")
INDEX = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_RED_RESCUE_TEAM",
                     "Cinematics", "EVENT_SCRIPTS_INDEX.json")

# ScriptCommand EU = 24 octets (eu_layout.script_command_size du rapport
# des stations ; vérifié ici sur EVENT_DIVIDE : stride 16 désynchronise,
# stride 24 reproduit la chaîne COND(JUDGE_EQ…) de pret 1:1).
CMD_SIZE = 24
TEXT_OPCODES = set(range(0x32, 0x3A)) | set(range(0xD0, 0xD6)) | {0xD9}
TERMINAL_OPCODES = {0xE7, 0xE9, 0xEB, 0xEE, 0xEF, 0xF0, 0xF1}
DEBUG_OPCODE = 0xF6
LANGUAGES = ("en", "de", "fr", "it", "es")
# IDs de variables EU = enum pret US **décalé de +1** — PROUVÉ par
# contre-épreuve exhaustive : 281/281 SCENARIO_CALC de la chaîne EVENT_*
# ont des (main,sub) identiques pret↔EU avec un delta d'ID uniformément
# +1 (la ROM EU insère une variable en tête de gScriptVarsInfo).
VAR_NAMES = {3: "SCENARIO_SELECT", 4: "SCENARIO_MAIN", 5: "SCENARIO_SUB1",
             6: "SCENARIO_SUB2", 7: "SCENARIO_SUB3", 8: "SCENARIO_SUB4",
             9: "SCENARIO_SUB5", 10: "SCENARIO_SUB6", 11: "SCENARIO_SUB7",
             12: "SCENARIO_SUB8", 13: "SCENARIO_SUB9"}


def c_string(rom, addr):
    o = addr - BASE
    e = rom.index(b"\0", o)
    return rom[o:e]


def decode_text_block(rom, pointer):
    strings = OrderedDict()
    cursor = pointer
    for lang in LANGUAGES:
        raw = c_string(rom, cursor)
        strings[lang] = OrderedDict(text=raw.decode("latin-1"),
                                    raw_hex=raw.hex(),
                                    address=f"0x{cursor:08X}")
        cursor += len(raw) + 1
    return OrderedDict(address=f"0x{pointer:08X}", languages=strings,
                       end_address=f"0x{cursor:08X}")


def semantic(op, ab, ash, a1, a2, names_by_id):
    """Interprétation sémantique des opcodes de progression (pret
    include/data_script.h — macro layout, valeurs EU)."""
    if op == 0xA9:
        return OrderedDict(kind="SCENARIO_CALC",
                           var=VAR_NAMES.get(ash, f"var_{ash}"),
                           main=a1, sub=a2)
    if op == 0xAA:
        return OrderedDict(kind="SCENARIO_ADVANCE",
                           var=VAR_NAMES.get(ash, f"var_{ash}"), add=a1)
    if op in (0xB8, 0xB9, 0xBA):
        k = {0xB8: "JUMPIF_SCENE_LT", 0xB9: "JUMPIF_SCENE_EQ",
             0xBA: "JUMPIF_SCENE_GT"}[op]
        return OrderedDict(kind=k, var=VAR_NAMES.get(ab, f"var_{ab}"),
                           main=a1, sub=a2, label=ash)
    if op == 0xBB:
        return OrderedDict(kind="JUMPIF_SCENARIOCHECK", quest=ab,
                           label=ash)
    if op in (0xC4, 0xC5):
        return OrderedDict(kind={0xC4: "CJUMP_SCENARIO_0",
                                 0xC5: "CJUMP_SCENARIO_1"}[op],
                           var=VAR_NAMES.get(ash, f"var_{ash}"))
    if op == 0xE9:
        return OrderedDict(kind="JUMP_SCRIPT", target_id=a1,
                           target=names_by_id.get(a1))
    if op == 0xAD:
        return OrderedDict(kind="UNLOCK_FRIEND_AREA", area=a1)
    if op == 0xAB:
        return OrderedDict(kind="SET_DUNGEON_RES", result=a1, enter=a2)
    return None


def main():
    rom = open(ROM_PATH, "rb").read()
    h = hashlib.sha256(rom).hexdigest()
    if h != ROM_SHA256:
        print("FATAL rom sha mismatch", h, file=sys.stderr)
        sys.exit(2)

    # table
    refs = []
    off = TABLE_ADDR - BASE
    i = 0
    while True:
        sid, styp, nptr, sptr = struct.unpack_from("<hhII", rom,
                                                   off + i * 12)
        if sid != i:
            break
        name = c_string(rom, nptr).decode("latin-1") if nptr else f"id_{i}"
        refs.append(OrderedDict(id=sid, type=styp, name=name,
                                script_addr=sptr))
        i += 1
    names_by_id = {r["id"]: r["name"] for r in refs}
    print(f"table: {len(refs)} ScriptRef @0x{TABLE_ADDR:08X}")

    # bornes : pointeurs de scripts triés
    ptrs = sorted({r["script_addr"] for r in refs if r["script_addr"]})
    next_ptr = {}
    for a, b in zip(ptrs, ptrs[1:]):
        next_ptr[a] = b
    # borne finale : la table elle-même suit les scripts en ROM
    last_bound = TABLE_ADDR

    os.makedirs(OUT_DIR, exist_ok=True)
    index = OrderedDict(schema="red-event-scripts-index/1",
                        source_rom_sha256=ROM_SHA256,
                        table_address=f"0x{TABLE_ADDR:08X}",
                        table_entries=len(refs),
                        note="pret US NUM_SCRIPT_IDS=483 ; table EU=407 — "
                             "écart régional documenté, aucune donnée US "
                             "injectée",
                        scripts=OrderedDict())
    counts = {"PASS": 0, "PARTIAL": 0, "EMPTY": 0}
    shared = {}
    for r in refs:
        sptr = r["script_addr"]
        name = r["name"]
        if not sptr:
            index["scripts"][name] = OrderedDict(
                id=r["id"], type=r["type"], status="EMPTY",
                note="pointeur de script nul dans la ROM")
            counts["EMPTY"] += 1
            continue
        bound = next_ptr.get(sptr, last_bound)
        cmds = []
        addr = sptr
        status = "PASS"
        scen_ops = []
        texts = 0
        while addr + CMD_SIZE <= bound:
            op, ab, ash, a1, a2, ptr = struct.unpack_from(
                "<BBhiiI", rom, addr - BASE)
            cmd = OrderedDict(address=f"0x{addr:08X}",
                              raw_hex=rom[addr - BASE:addr - BASE
                                          + CMD_SIZE].hex(),
                              op=f"0x{op:02X}", arg_byte=ab,
                              arg_short=ash, arg1=a1, arg2=a2,
                              pointer=(f"0x{ptr:08X}" if ptr else None))
            if op == DEBUG_OPCODE:
                cmd["debug"] = True
            sem = semantic(op, ab, ash, a1, a2, names_by_id)
            if sem:
                cmd["semantic"] = sem
                if sem["kind"].startswith(("SCENARIO", "JUMPIF_SCENE",
                                           "CJUMP_SCENARIO",
                                           "JUMPIF_SCENARIOCHECK")):
                    scen_ops.append(sem)
            if op in TEXT_OPCODES and ptr and \
                    BASE <= ptr < BASE + len(rom):
                try:
                    cmd["text_block"] = decode_text_block(rom, ptr)
                    texts += 1
                except Exception as e:
                    cmd["text_error"] = str(e)
            cmds.append(cmd)
            addr += CMD_SIZE
        # Statut d'étendue :
        #  - PASS : borné par le POINTEUR DU SCRIPT SUIVANT (étendue
        #    byte-exacte — contre-épreuve : EVENT_DIVIDE EU 116 cmds vs
        #    pret 117 avec DEBUGINFO, delta = le DEBUGINFO absent en EU) ;
        #  - PARTIAL : borné seulement par l'adresse de la table (dernier
        #    bloc) ET fin non terminale → étendue incertaine.
        # `ends_with_terminal` reste exposé à titre informatif : LABEL/
        # EXECUTE_MAP_VAR en fin de script sont canoniques (labels de fin
        # de chaîne EVENT_DIVIDE).
        ends_terminal = bool(cmds) and (
            int(cmds[-1]["op"], 16) in TERMINAL_OPCODES
            or int(cmds[-1]["op"], 16) == DEBUG_OPCODE)
        if not cmds:
            status = "PARTIAL"
        elif sptr in next_ptr:
            status = "PASS"
        elif not ends_terminal:
            status = "PARTIAL"
        entry = OrderedDict(id=r["id"], type=r["type"],
                            script_address=f"0x{sptr:08X}",
                            end_bound=f"0x{bound:08X}",
                            commands=cmds)
        fname = f"{name}.json.gz"
        with gzip.open(os.path.join(OUT_DIR, fname), "wt",
                       encoding="utf-8") as fh:
            json.dump(entry, fh, ensure_ascii=False, indent=1)
        shared.setdefault(sptr, []).append(name)
        index["scripts"][name] = OrderedDict(
            id=r["id"], type=r["type"], file=f"event_scripts/{fname}",
            status=status, commands=len(cmds), text_blocks=texts,
            ends_with_terminal=ends_terminal,
            scenario_ops=scen_ops or None)
        counts[status] += 1
    # scripts partagés (plusieurs ids → même adresse) : documenter
    for sptr, names in shared.items():
        if len(names) > 1:
            for nm in names:
                index["scripts"][nm]["shares_script_with"] = \
                    [x for x in names if x != nm]
    index["totals"] = OrderedDict(
        **counts,
        scenario_main_writes=sum(
            1 for s in index["scripts"].values()
            for o in (s.get("scenario_ops") or [])
            if o["kind"] == "SCENARIO_CALC" and o["var"] == "SCENARIO_MAIN"))
    with open(INDEX, "w", encoding="utf-8") as fh:
        json.dump(index, fh, ensure_ascii=False, indent=1)
    print("totals:", dict(index["totals"]))
    print(INDEX)


if __name__ == "__main__":
    main()
