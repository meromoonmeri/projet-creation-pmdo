#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ssb_to_ir.py — Couche INTERMEDIAIRE CANONIQUE pour l'arc du futur (PMD Sky → New Era).

PIPELINE CANONIQUE (4 couches, aucune fusion entre elles) :
  1. SSB original (pret/pmd-sky, ROM USA)          -> bytecode
  2. header US décodé + routines + opcodes + params -> IR canonique JSON
  3. couche d'adaptation New Era (cast/dialogues/BGM/grounds) -> JSON séparé
  4. convertisseur Lua PMDO (RogueEssence)          -> .lua jouable

Ce script produit la couche 2 : une représentation canonique JSON par scène,
avec résolution des paramètres IDENTIQUE à celle du désassembleur officiel
(ENUM_ARGUMENTS de skytemple/explorerscript), et une validation byte-exacte :
  - taille du fichier ;
  - nombre de routines ;
  - nombre d'opérations ;
  - nombre de constantes ;
  - nombre de strings ;
  - offset de fin du parsing (cursor) ;
  - confirmation cursor == file_size ;
  - aucun opcode inconnu ;
  - aucun paramètre non résolu (spec manquante ou id inconnu dans la table).

Aucune donnée Sky n'est modifiée ici : l'IR est la représentation canonique
PURE. Le cast New Era est appliqué PLUS TARD, en couche d'adaptation.

Sorties :
  V4/docs/ssb_ir/<ZONE>_<scene>.json        (IR canonique par scène)
  V4/docs/RAPPORT_VALIDATION_IR_SSB.md      (rapport global)
  V4/docs/ssb_ir/_validation_summary.json   (agrégat machine-readable)
"""

import json
import os
import sys
from collections import OrderedDict

from skytemple_files.common.ppmdu_config.xml_reader import Pmd2XmlReader
from skytemple_files.common.util import read_var_length_string as _sky_read_var_string
from skytemple_files.script.ssb.header import SsbHeaderUs
from skytemple_files.script.ssb.model import Ssb

# ---------------------------------------------------------------------------
# Manifest des 24 scènes de l'arc du futur (zones validées p05p01a..p09p01a)
# ---------------------------------------------------------------------------
MANIFEST = {
    "P05P01A": ["m17a0103", "m19a0102", "n08a2008"],
    "P05P02A": ["m17a0104", "m17a0201", "m17a0301"],
    "P05P03A": ["m17a0302", "m26a06d3"],
    "P05P04A": ["m17a0401", "m17a0403"],
    "P06P01A": ["m18a0401", "m26a0614"],
    "P07P01A": ["m18b1401", "m26a06e6"],
    "P08P01A": ["m19a0601", "m19d0612", "n08a2308", "n08a2408", "n08a2508", "n08a2608"],
    "P09P01A": ["m19b1001", "m19b1007", "m19b1009", "m19d1072"],
}

SCRIPT_BASE = "/tmp/pret-pmd-sky/files/language-specific/US/SCRIPT"
OUT_DIR = "/home/user/V4/docs/ssb_ir"
REPORT_MD = "/home/user/V4/docs/RAPPORT_VALIDATION_IR_SSB.md"
SUMMARY_JSON = os.path.join(OUT_DIR, "_validation_summary.json")


# ---------------------------------------------------------------------------
# Petits helpers (même logique que skytemple, reproduite pour la marche
# byte-exacte indépendante — le modèle sert de contre-vérification)
# ---------------------------------------------------------------------------
def u16(data: bytes, off: int) -> int:
    return data[off] | (data[off + 1] << 8)


def read_var_string(data: bytes, start: int) -> tuple[int, str]:
    """Lit une chaîne terminée par 0x00 (codec PMD2 officiel, registré par skytemple)."""
    return _sky_read_var_string(data, start)


def parse_ssb_number(v: int):
    """Reproduit parse_ssb_encoding de skytemple : signe + point fixe 1/256."""
    raw = v
    if raw & 0x4000:
        v = -0x4000 + (raw & 0x3FFF)
    if raw & 0x8000:
        whole = (abs(v) & 0x7FFF) >> 8
        if v < 0:
            if whole == 0:
                whole = -0.0
            else:
                whole *= -1
        frac = abs(v) & 0xFF
        frac_str = "" if frac == 0 else "." + str(round(frac / 256.0, 4)).split(".")[1]
        return f"{whole}{frac_str}"
    return v


# ---------------------------------------------------------------------------
# Extracteur IR canonique
# ---------------------------------------------------------------------------
def extract_ir(zone: str, scene: str, sd) -> dict:
    scriptdata = sd.script_data
    path = os.path.join(SCRIPT_BASE, zone, scene + ".ssb")
    data = open(path, "rb").read()
    file_size = len(data)

    header = SsbHeaderUs(data)
    begin = header.data_offset  # 12 pour US

    # --- entête de bloc : start_of_const_table + nb routines ---
    start_of_const_table = begin + (u16(data, begin + 0x00) * 2)
    number_of_routines = u16(data, begin + 0x02)
    cursor = begin + 4

    # --- table des routines (6 o par entrée) ---
    routines_raw = []
    for i in range(number_of_routines):
        r_off = u16(data, cursor) * 2
        r_type = u16(data, cursor + 2)
        r_linked = u16(data, cursor + 4)
        routines_raw.append({"index": i, "start_offset_bytes": r_off, "type": r_type, "linked": r_linked})
        cursor += 6

    # --- bytecode des routines ---
    start_of_constants = begin + header.constant_strings_start
    # bornes par routine
    bounds = []
    for i, r in enumerate(routines_raw):
        if i == number_of_routines - 1:
            end = start_of_const_table
        else:
            end = begin + routines_raw[i + 1]["start_offset_bytes"]
        bounds.append((begin + r["start_offset_bytes"], end))

    ops_by_routine = []
    for (rstart, rend), rinfo in zip(bounds, routines_raw):
        ops = []
        c = rstart
        seq = 0
        while c < rend:
            off = c
            op_id = u16(data, c)
            c += 2
            opcode = scriptdata.op_codes__by_id.get(op_id)
            if opcode is None:
                raise ValueError(f"OPCODE INCONNU id={op_id} a l'offset {off}")
            n_params = opcode.params
            if n_params == -1:
                n_params = u16(data, c)
                c += 2
            raw_params = []
            for _ in range(n_params):
                raw_params.append(u16(data, c))
                c += 2
            ops.append({"seq": seq, "off": off, "id": op_id, "name": opcode.name,
                        "raw": raw_params, "arg_specs": [], "resolved": []})
            seq += 1
        ops_by_routine.append(ops)
    # cursor après le bytecode == start_of_const_table (vérifié aussi par le modèle)
    cursor_after_ops = c

    # --- table des offsets de constantes ---
    const_offset_table = []
    for i in range(start_of_const_table, start_of_constants, 2):
        const_offset_table.append(start_of_const_table + u16(data, i) - (header.number_of_strings * 2))
    cursor = start_of_constants

    # --- constantes (chaînes) ---
    constants = []
    for co in const_offset_table:
        if cursor != co:
            raise ValueError(f"Desalignement constantes a {cursor} vs {co}")
        n, s = read_var_string(data, cursor)
        constants.append(s)
        cursor += n
    if cursor % 2 != 0:
        cursor += 1

    # --- strings EN ---
    lang_len = header.string_table_lengths["english"]
    cursor_before = cursor
    str_offsets = []
    for i in range(cursor, cursor + header.number_of_strings * 2, 2):
        str_offsets.append(start_of_const_table + u16(data, i))
    cursor += header.number_of_strings * 2
    strings = []
    for so in str_offsets:
        if cursor != so:
            raise ValueError(f"Desalignement strings a {cursor} vs {so}")
        n, s = read_var_string(data, cursor)
        strings.append(s)
        cursor += n
    if cursor % 2 != 0:
        cursor += 1
    end_cursor = cursor

    # --- résolution des arguments (sémantique officielle) ---
    n_const = len(constants)
    unresolved = []
    undocumented = []  # id numérique valide (dans la plage) mais absent de la table XML -> gap doc
    for r_idx, ops in enumerate(ops_by_routine):
        for op in ops:
            opcode = scriptdata.op_codes__by_id[op["id"]]
            specs = []
            raw = op["raw"]
            j = 0
            k = 0
            while j < len(raw):
                spec = None
                if opcode.repeating_argument_group is not None and opcode.repeating_argument_group.id <= j:
                    rep = opcode.repeating_argument_group
                    rj = (j - rep.id) % len(rep.arguments)
                    spec = rep.arguments[rj]
                elif j in opcode.arguments__by_id:
                    spec = opcode.arguments__by_id[j]
                if spec is None:
                    unresolved.append({"op": op["name"], "arg_idx": j, "reason": "spec_manquante",
                                       "value": raw[j], "routine": r_idx, "seq": op["seq"]})
                    j += 1
                    continue
                stype = spec.type
                sname = spec.name
                value = raw[j]
                resolved = None
                consumed = 1
                if stype == "uint":
                    resolved = value
                elif stype == "Number":
                    resolved = parse_ssb_number(value)
                elif stype in ENUM_TABLES:
                    table = getattr(scriptdata, ENUM_TABLES[stype])
                    if value in table:
                        resolved = table[value].name
                    elif table and 0 <= value <= max(table.keys()):
                        # id dans la plage valide mais absent de la table XML (gap de doc)
                        undocumented.append({"op": op["name"], "arg": sname, "type": stype,
                                             "value": value, "routine": r_idx, "seq": op["seq"]})
                        resolved = value
                    else:
                        unresolved.append({"op": op["name"], "arg": sname, "type": stype,
                                           "value": value, "routine": r_idx, "seq": op["seq"],
                                           "reason": "id_inconnu_table"})
                        resolved = value
                elif stype == "String" or stype == "ConstString":
                    if value < n_const:
                        resolved = {"kind": "const", "name": constants[value]}
                    else:
                        sidx = value - n_const
                        if 0 <= sidx < len(strings):
                            resolved = {"kind": "string", "index": sidx, "text": strings[sidx]}
                        else:
                            unresolved.append({"op": op["name"], "arg": sname, "type": stype,
                                               "value": value, "routine": r_idx, "seq": op["seq"],
                                               "reason": "index_string_hors_bornes"})
                            resolved = value
                elif stype == "PositionMark":
                    # 4 params consécutifs : x_offset, y_offset, x_rel, y_rel
                    xs = raw[j:j + 4]
                    while len(xs) < 4:
                        xs.append(0)
                    resolved = {"kind": "position_mark", "x_offset": xs[0], "y_offset": xs[1],
                                "x_relative": xs[2], "y_relative": xs[3]}
                    consumed = 4
                else:
                    unresolved.append({"op": op["name"], "arg": sname, "type": stype,
                                       "value": value, "routine": r_idx, "seq": op["seq"],
                                       "reason": "type_argument_inconnu"})
                    resolved = value
                specs.append({"i": j, "spec": sname, "type": stype, "raw": value, "resolved": resolved})
                j += consumed
                k += 1
            op["arg_specs"] = specs
            op["resolved"] = [s["resolved"] for s in specs]

    # --- contre-vérification avec le modèle skytemple ---
    model = Ssb(data, header, begin, scriptdata, string_codec=sd.string_encoding)
    model_ok = True
    try:
        model_n_ops = sum(len(r) for r in model.routine_ops)
        if model_n_ops != sum(len(o) for o in ops_by_routine):
            model_ok = False
        if list(model.constants) != constants:
            model_ok = False
        if list(model.strings["english"]) != strings:
            model_ok = False
        if len(model.routine_info) != number_of_routines:
            model_ok = False
    except Exception:
        model_ok = False

    routine_types = {0: "NORMAL", 1: "ACTOR", 2: "OBJECT", 3: "COMMON", 4: "PERFORMER"}
    routines_out = []
    for r in routines_raw:
        r_out = dict(r)
        r_out["type_name"] = routine_types.get(r["type"], f"UNKNOWN({r['type']})")
        r_out["op_count"] = len(ops_by_routine[r["index"]])
        routines_out.append(r_out)

    return {
        "schema": "newera.ssb_canonical_ir.v1",
        "zone": zone,
        "scene": scene,
        "source_rom": "Pokemon Mystery Dungeon - Explorers of Sky (USA)",
        "source_file": f"files/language-specific/US/SCRIPT/{zone}/{scene}.ssb",
        "file_size": file_size,
        "header": {
            "nb_constants": header.number_of_constants,
            "nb_strings": header.number_of_strings,
            "constant_strings_start": header.constant_strings_start,
            "const_table_length": header.const_table_length,
            "strings_en": header.string_table_lengths["english"],
            "unknown": header.unknown,
        },
        "data_offset": begin,
        "start_of_const_table": start_of_const_table,
        "start_of_constants": start_of_constants,
        "number_of_routines": number_of_routines,
        "routines": routines_out,
        "ops": [op for ops in ops_by_routine for op in ops],
        "constants": [{"index": i, "name": c} for i, c in enumerate(constants)],
        "strings": strings,
        "validation": {
            "end_cursor": end_cursor,
            "cursor_eq_file_size": end_cursor == file_size,
            "cursor_after_ops_eq_const_table": cursor_after_ops == start_of_const_table,
            "unknown_opcodes": [],
            "unresolved_params": unresolved,
            "undocumented_enums": undocumented,
            "n_routines": number_of_routines,
            "n_ops": sum(len(o) for o in ops_by_routine),
            "n_constants": len(constants),
            "n_strings": len(strings),
            "cross_check_model": model_ok,
        },
    }


ENUM_TABLES = {
    "Entity": "level_entities__by_id",
    "Object": "objects__by_id",
    "Routine": "common_routine_info__by_id",
    "Face": "face_names__by_id",
    "FaceMode": "face_position_modes__by_id",
    "GameVar": "game_variables__by_id",
    "Level": "level_list__by_id",
    "Menu": "menus__by_id",
    "ProcessSpecial": "process_specials__by_id",
    "Direction": "directions__by_ssb_id",
    "Bgm": "bgms__by_id",
    "Effect": "sprite_effects__by_id",
}


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    sd = Pmd2XmlReader.load_default()
    scriptdata = sd.script_data

    rows = []
    summary = {"scenes": [], "totals": {}}
    tot_ops = 0
    tot_const = 0
    tot_str = 0
    all_unresolved = []
    all_unknown = []
    all_undocumented = []

    for zone, scenes in MANIFEST.items():
        for scene in scenes:
            ir = extract_ir(zone, scene, sd)
            v = ir["validation"]
            out_path = os.path.join(OUT_DIR, f"{zone}_{scene}.json")
            with open(out_path, "w", encoding="utf-8") as f:
                json.dump(ir, f, ensure_ascii=False, indent=1)
            ok = (v["cursor_eq_file_size"] and v["cursor_after_ops_eq_const_table"]
                  and not v["unknown_opcodes"] and not v["unresolved_params"]
                  and v["cross_check_model"])
            rows.append({
                "zone": zone, "scene": scene,
                "file_size": ir["file_size"],
                "routines": v["n_routines"],
                "ops": v["n_ops"],
                "constants": v["n_constants"],
                "strings": v["n_strings"],
                "end_cursor": v["end_cursor"],
                "cursor_eq_file_size": v["cursor_eq_file_size"],
                "unknown_opcodes": len(v["unknown_opcodes"]),
                "unresolved": len(v["unresolved_params"]),
                "model_check": v["cross_check_model"],
                "OK": ok,
            })
            tot_ops += v["n_ops"]
            tot_const += v["n_constants"]
            tot_str += v["n_strings"]
            all_unresolved += v["unresolved_params"]
            all_unknown += v["unknown_opcodes"]
            for _u in v.get("undocumented_enums", []):
                _u = dict(_u)
                _u["_scene"] = f"{zone}/{scene}"
                all_undocumented.append(_u)
            print(f"{zone}/{scene}: {v['n_ops']:5d} ops, {v['n_constants']:3d} const, "
                  f"{v['n_strings']:3d} strings, end={v['end_cursor']}/{ir['file_size']} "
                  f"{'OK' if ok else '!!!'}")

    summary["scenes"] = rows
    summary["totals"] = {
        "n_scenes": len(rows),
        "n_ops": tot_ops,
        "n_constants": tot_const,
        "n_strings": tot_str,
        "n_unresolved": len(all_unresolved),
        "n_unknown_opcodes": len(all_unknown),
        "n_undocumented_enums": len(all_undocumented),
        "undocumented_enums": all_undocumented,
        "all_ok": all(r["OK"] for r in rows),
    }
    with open(SUMMARY_JSON, "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=1)

    # -------- rapport Markdown --------
    lines = []
    lines.append("# RAPPORT DE VALIDATION — IR CANONIQUE SSB — ARC DU FUTUR")
    lines.append("")
    lines.append(f"Date : 2026-08-09 — Pipeline : `SSB original → header US → routines → opcodes+params → IR canonique JSON`")
    lines.append("")
    lines.append("Aucune donnée Sky n'a été modifiée : l'IR est la représentation canonique **pure** du bytecode.")
    lines.append("Le cast New Era (couche d'adaptation) est appliqué **après**, séparément.")
    lines.append("")
    lines.append("## Récapitulatif")
    lines.append("")
    lines.append(f"- Scènes : **{len(rows)}**")
    lines.append(f"- Opérations totales : **{tot_ops}**")
    lines.append(f"- Constantes totales : **{tot_const}**")
    lines.append(f"- Strings totales : **{tot_str}**")
    lines.append(f"- Paramètres non résolus : **{len(all_unresolved)}**")
    lines.append(f"- Opcodes inconnus : **{len(all_unknown)}**")
    lines.append(f"- Énumérés non documentés (id valide, nom absent de la table XML) : **{len(all_undocumented)}**")
    lines.append(f"- Toutes scènes OK : **{'OUI' if all(r['OK'] for r in rows) else 'NON'}**")
    lines.append("")
    lines.append("## Par scène")
    lines.append("")
    lines.append("| Zone | Scène | Taille (o) | Routines | Ops | Const | Strings | End cursor | cursor==size | Opcodes inconnus | Params non résolus | Modèle | **OK** |")
    lines.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        lines.append(f"| {r['zone']} | {r['scene']} | {r['file_size']} | {r['routines']} | {r['ops']} | "
                     f"{r['constants']} | {r['strings']} | {r['end_cursor']} | "
                     f"{'✅' if r['cursor_eq_file_size'] else '❌'} | {r['unknown_opcodes']} | {r['unresolved']} | "
                     f"{'✅' if r['model_check'] else '❌'} | {'✅' if r['OK'] else '❌'} |")
    lines.append("")
    if all_unresolved:
        lines.append("## Détail des paramètres non résolus")
        lines.append("")
        lines.append("```")
        for u in all_unresolved[:40]:
            lines.append(str(u))
        lines.append("```")
        lines.append("")
    if all_undocumented:
        lines.append("## Énumérés non documentés (id numérique valide, nom absent de la table XML)")
        lines.append("")
        lines.append("Valeur conservée telle quelle dans l'IR ; le convertisseur Lua devra les mapper")
        lines.append("manuellement ou les signaler comme NON CONVERTIS.")
        lines.append("")
        lines.append("| Scène | Op | Arg | Type | Valeur | Routine | Seq |")
        lines.append("|---|---|---|---|---|---|---|")
        for u in all_undocumented:
            lines.append(f"| {u.get('_scene','')} | {u['op']} | {u['arg']} | {u['type']} | {u['value']} | {u['routine']} | {u['seq']} |")
        lines.append("")
    lines.append("## Méthode")
    lines.append("")
    lines.append("1. Header US (12 octets) : nb_constants, nb_strings, constant_strings_start, const_table_length, strings_EN, unknown.")
    lines.append("2. `start_of_const_table = data_offset + u16*2` ; `nb_routines = u16`.")
    lines.append("3. Table des routines : 6 octets/entrée (offset u16×2, type u16, linked u16).")
    lines.append("4. Bytecode : `u16 opcode` + paramètres `u16` ; `-1` = longueur variable (préfixe u16).")
    lines.append("5. Table d'offsets de constantes, constantes (chaînes), puis strings EN.")
    lines.append("6. Résolution des paramètres : même sémantique que le désassembleur officiel (`ENUM_ARGUMENTS` : Entity/Object/Routine/Face/FaceMode/GameVar/Level/Menu/ProcessSpecial/Direction/Bgm/Effect ; `Number` point-fixe 1/256 ; `String`/`ConstString` ; `PositionMark` = 4 params).")
    lines.append("7. Contre-vérification : modèle `Ssb` de skytemple-files (ops/constantes/strings/routines identiques).")
    lines.append("8. `cursor == file_size` : le parseur doit consommer exactement le fichier, sans octet restant.")
    lines.append("")
    lines.append("Fichiers IR : `docs/ssb_ir/<ZONE>_<scene>.json` (un par scène) + `docs/ssb_ir/_validation_summary.json`.")
    with open(REPORT_MD, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print("\nRapport :", REPORT_MD)


if __name__ == "__main__":
    main()
