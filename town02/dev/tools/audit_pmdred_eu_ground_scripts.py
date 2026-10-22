#!/usr/bin/env python3
"""Extract and validate canonical EU Ground scripts for the 27 PMD Red candidates.

The European ROM is the content authority.  pret/pmd-red is used only as a
technical declaration/reference source: a temporary host helper compiles every
complete station header and exposes its typed graph and command-array bounds.
The ROM graph is then followed from the regional gMapScriptTable, independently
recording every group, sector, link, entity, ScriptRef, command and five-language
text block.

This deliberately does not search for US bytes or trust US addresses.  European
Ground IDs, 24-byte ScriptCommands, 12-byte ScriptRefs and localized command
expansions are handled explicitly.  Array endings are selected by bounded
alignment against the complete pret declaration, rather than by stopping at the
first terminal opcode (valid scripts can contain more than one terminal path).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import subprocess
import sys
import tempfile
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Sequence

TOOL_VERSION = "1.1.0"
REPORT_SCHEMA = "new-era.pmdred-eu-ground-scripts.v1"
EXPECTED_ROM_SIZE = 33_554_432
EXPECTED_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ROM_BASE = 0x08000000
MAP_SCRIPT_TABLE_OFFSET = 0x0027BAC4
MAP_SCRIPT_TABLE_ADDRESS = ROM_BASE + MAP_SCRIPT_TABLE_OFFSET
SCRIPT_COMMAND_SIZE = 24
SCRIPT_REF_SIZE = 12
GROUND_HEADER_SIZE = 12
GROUP_SIZE = 8
SECTOR_SIZE = 40
LIVES_OBJECT_SIZE = 24
EFFECT_EVENT_SIZE = 12
LINK_SIZE = 8
DEBUG_OPCODE = 0xF6
TEXT_OPCODES = set(range(0x32, 0x3A)) | set(range(0xD0, 0xD6)) | {0xD9}
# Control-transfer endings plus the engine's four explicit terminal opcodes.
# JUMP_LABEL/JUMP_SCRIPT/JUMP_STATION end the current linear command path.
TERMINAL_OPCODES = {0xE7, 0xE9, 0xEB, 0xEE, 0xEF, 0xF0, 0xF1}
LANGUAGES = ("en", "de", "fr", "it", "es")

CANDIDATES: tuple[tuple[str, int], ...] = (
    ("d01p02", 184), ("d02p02", 186), ("d03p02", 188),
    ("d04p02", 190), ("d05p02", 192), ("d06p02", 194),
    ("d06p03", 195), ("d09p02", 201), ("d09p03", 202),
    ("d10p02", 204), ("d10p03", 205), ("d11p02", 207),
    ("d11p03", 208), ("d12p02", 210), ("d12p04", 211),
    ("d13p02", 213), ("d13p03", 214), ("d14p01", 215),
    ("d15p01", 216), ("d16p01", 217), ("d17p01", 218),
    ("d18p01", 219), ("d19p01", 220), ("d20p01", 221),
    ("d21p01", 222), ("d23p01", 224), ("d25p01", 227),
)

COMMAND_ARRAY_RE = re.compile(r"static const struct ScriptCommand\s+(\w+)\[\]")
HEADER_SYMBOL_RE = re.compile(r"const GroundScriptHeader\s+(gGroundScript_gs(\d+))")
LINK_SYMBOL_RE = re.compile(r"static const struct GroundLink\s+(s_gs\d+_links)\[\]")


class AuditError(RuntimeError):
    """A deterministic authority/reference validation failure."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AuditError(message)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def address_hex(value: int) -> str:
    return f"0x{value:08X}"


def signed16(value: int) -> int:
    return value - 0x10000 if value & 0x8000 else value


class RomReader:
    def __init__(self, data: bytes):
        self.data = data

    def offset(self, address: int, context: str) -> int:
        offset = address - ROM_BASE
        require(0 <= offset < len(self.data), f"{context}: invalid ROM address {address_hex(address)}")
        return offset

    def bytes(self, address: int, size: int, context: str) -> bytes:
        offset = self.offset(address, context)
        require(offset + size <= len(self.data), f"{context}: truncated {size}-byte read")
        return self.data[offset:offset + size]

    def unpack(self, fmt: str, address: int, context: str) -> tuple[Any, ...]:
        size = struct.calcsize(fmt)
        return struct.unpack(fmt, self.bytes(address, size, context))

    def u32(self, address: int, context: str) -> int:
        return self.unpack("<I", address, context)[0]

    def c_string(self, address: int, context: str, max_size: int = 4096) -> bytes:
        offset = self.offset(address, context)
        end = self.data.find(b"\0", offset, min(offset + max_size, len(self.data)))
        require(end >= 0, f"{context}: unterminated string")
        return self.data[offset:end]


@dataclass(frozen=True)
class CommandCore:
    op: int
    arg_byte: int
    arg_short: int
    arg1: int
    arg2: int

    @classmethod
    def from_fields(cls, values: Iterable[int]) -> "CommandCore":
        op, arg_byte, arg_short, arg1, arg2 = values
        return cls(int(op), int(arg_byte), int(arg_short), int(arg1), int(arg2))

    def as_list(self) -> list[int]:
        return [self.op, self.arg_byte, self.arg_short, self.arg1, self.arg2]


@dataclass
class SourceReference:
    asset: str
    source_ground_id: int
    header_symbol: str
    command_names: list[str]
    commands: dict[str, list[CommandCore]]
    structure_lines: list[list[str]]


def _c_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def build_reference_helper(header: Path, pret_root: Path) -> tuple[Path, str, int, list[str]]:
    source = header.read_text(encoding="utf-8")
    command_names = COMMAND_ARRAY_RE.findall(source)
    header_match = HEADER_SYMBOL_RE.search(source)
    link_match = LINK_SYMBOL_RE.search(source)
    require(header_match is not None, f"{header}: missing GroundScriptHeader")
    require(link_match is not None, f"{header}: missing GroundLink array")
    require(command_names, f"{header}: no ScriptCommand arrays")
    header_symbol, source_ground_id_text = header_match.groups()
    link_symbol = link_match.group(1)

    comparisons = "\n".join(
        f'    if (ptr == {name}) return "{_c_escape(name)}";' for name in command_names
    )
    command_dumps = "\n".join(
        f'    dump_commands("{_c_escape(name)}", {name}, sizeof({name}) / sizeof({name}[0]));'
        for name in command_names
    )
    helper = f'''\
#include <stdio.h>
#include <stdint.h>
#define _(x) ((const u8 *)(x))
#define FAKE_FILENAME ((const u8 *)"FAKE_FILENAME")
#include "global.h"
#include "data_script.h"
#include "{_c_escape(str(header.resolve()))}"

static const char *command_name(const ScriptCommand *ptr) {{
{comparisons}
    return ptr == NULL ? "-" : "?";
}}

static void hex8(const void *ptr) {{
    const unsigned char *bytes = ptr;
    for (int i = 0; i < 8; ++i) printf("%02X", bytes[i]);
}}

static void dump_commands(const char *name, const ScriptCommand *commands, size_t count) {{
    for (size_t i = 0; i < count; ++i) {{
        const ScriptCommand *c = &commands[i];
        printf("C\\t%s\\t%zu\\t%u\\t%u\\t%d\\t%d\\t%d\\n",
               name, i, c->op, c->argByte, c->argShort, c->arg1, c->arg2);
    }}
}}

int main(void) {{
    const GroundScriptHeader *header = &{header_symbol};
    const size_t link_count = sizeof({link_symbol}) / sizeof({link_symbol}[0]);
    printf("H\\t%u\\t%zu\\n", header->nGroups, link_count);
    for (uint32_t g = 0; g < header->nGroups; ++g) {{
        const struct GroundScriptGroup *group = &header->groups[g];
        printf("G\\t%u\\t%u\\n", g, group->nSectors);
        for (uint32_t s = 0; s < group->nSectors; ++s) {{
            const struct GroundScriptSector *sector = &group->sectors[s];
            printf("S\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\n",
                   g, s, sector->nLives, sector->nObjects, sector->nEffects,
                   sector->nEvents, sector->hasStation);
            for (uint32_t i = 0; i < sector->nLives; ++i) {{
                printf("E\\tL\\t%u\\t%u\\t%u\\t", g, s, i); hex8(&sector->lives[i]); putchar('\\n');
                for (int slot = 0; slot < 4; ++slot)
                    if (sector->lives[i].scripts[slot])
                        printf("P\\tL\\t%u\\t%u\\t%u\\t%d\\t%s\\n", g, s, i, slot,
                               command_name(sector->lives[i].scripts[slot]));
            }}
            for (uint32_t i = 0; i < sector->nObjects; ++i) {{
                printf("E\\tO\\t%u\\t%u\\t%u\\t", g, s, i); hex8(&sector->objects[i]); putchar('\\n');
                for (int slot = 0; slot < 4; ++slot)
                    if (sector->objects[i].scripts[slot])
                        printf("P\\tO\\t%u\\t%u\\t%u\\t%d\\t%s\\n", g, s, i, slot,
                               command_name(sector->objects[i].scripts[slot]));
            }}
            for (uint32_t i = 0; i < sector->nEffects; ++i) {{
                printf("E\\tF\\t%u\\t%u\\t%u\\t", g, s, i); hex8(&sector->effects[i]); putchar('\\n');
                if (sector->effects[i].script)
                    printf("P\\tF\\t%u\\t%u\\t%u\\t0\\t%s\\n", g, s, i,
                           command_name(sector->effects[i].script));
            }}
            for (uint32_t i = 0; i < sector->nEvents; ++i) {{
                const ScriptRef *ref = sector->events[i].script;
                printf("E\\tV\\t%u\\t%u\\t%u\\t", g, s, i); hex8(&sector->events[i]); putchar('\\n');
                if (ref)
                    printf("R\\tV\\t%u\\t%u\\t%u\\t%d\\t%d\\t%s\\n", g, s, i,
                           ref->id, ref->type, command_name(ref->script));
            }}
            if (sector->hasStation) {{
                const ScriptRef *ref = *sector->station;
                printf("R\\tT\\t%u\\t%u\\t0\\t%d\\t%d\\t%s\\n", g, s,
                       ref->id, ref->type, command_name(ref->script));
            }}
        }}
    }}
    for (size_t i = 0; i < link_count; ++i) {{
        printf("K\\t%zu\\t", i); hex8(&header->links[i]); putchar('\\n');
    }}
{command_dumps}
    return 0;
}}
'''
    return Path(source), helper, int(source_ground_id_text), command_names


def compile_source_reference(asset: str, pret_root: Path, compiler: str) -> SourceReference:
    header = pret_root / "src" / "data" / "ground" / f"ground_data_{asset}_station.h"
    require(header.is_file(), f"missing pret station header: {header}")
    _, helper, source_ground_id, command_names = build_reference_helper(header, pret_root)
    with tempfile.TemporaryDirectory(prefix="pmdred-script-audit-") as temp_name:
        temp = Path(temp_name)
        c_path = temp / "reference.c"
        executable = temp / "reference"
        c_path.write_text(helper, encoding="utf-8", newline="\n")
        compile_result = subprocess.run(
            [compiler, "-std=c11", "-O0", "-I", str(pret_root / "include"), str(c_path), "-o", str(executable)],
            capture_output=True, text=True, check=False,
        )
        require(
            compile_result.returncode == 0,
            f"{asset}: reference helper compilation failed:\n{compile_result.stderr}",
        )
        run_result = subprocess.run([str(executable)], capture_output=True, text=True, check=False)
        require(
            run_result.returncode == 0,
            f"{asset}: reference helper failed ({run_result.returncode}):\n{run_result.stderr}",
        )

    commands: dict[str, list[CommandCore]] = {name: [] for name in command_names}
    structure_lines: list[list[str]] = []
    for raw_line in run_result.stdout.splitlines():
        fields = raw_line.split("\t")
        require(fields and fields[0] in {"H", "G", "S", "E", "P", "R", "K", "C"},
                f"{asset}: malformed helper output {raw_line!r}")
        if fields[0] == "C":
            require(len(fields) == 8 and fields[1] in commands, f"{asset}: malformed command output")
            commands[fields[1]].append(CommandCore.from_fields(map(int, fields[3:8])))
        else:
            structure_lines.append(fields)
    require(all(commands.values()), f"{asset}: helper omitted command arrays")
    return SourceReference(asset, source_ground_id, f"gGroundScript_gs{source_ground_id}",
                           command_names, commands, structure_lines)


def parse_source_structure(lines: list[list[str]]) -> dict[str, Any]:
    result: dict[str, Any] = {"groups": [], "links": [], "owners": {}, "refs": {}, "entities": {}}
    group_map: dict[int, dict[str, Any]] = {}
    for fields in lines:
        kind = fields[0]
        if kind == "H":
            result["group_count"] = int(fields[1])
            result["link_count"] = int(fields[2])
        elif kind == "G":
            g, sectors = map(int, fields[1:3])
            group_map[g] = {"index": g, "sector_count": sectors, "sectors": {}}
        elif kind == "S":
            g, s, lives, objects, effects, events, station = map(int, fields[1:8])
            group_map[g]["sectors"][s] = {
                "index": s, "lives": lives, "objects": objects, "effects": effects,
                "events": events, "has_station": station,
            }
        elif kind == "E":
            category, g, s, i, data = fields[1], *map(int, fields[2:5]), fields[5]
            result["entities"][(category, g, s, i)] = data
        elif kind == "P":
            category, g, s, i, slot, name = fields[1], *map(int, fields[2:6]), fields[6]
            result["owners"][(category, g, s, i, slot)] = name
        elif kind == "R":
            category, g, s, i = fields[1], *map(int, fields[2:5])
            result["refs"][(category, g, s, i)] = {
                "id": int(fields[5]), "type": int(fields[6]), "command": fields[7],
            }
            result["owners"][(category, g, s, i, 0)] = fields[7]
        elif kind == "K":
            result["links"].append(fields[2])
    result["groups"] = [group_map[index] for index in sorted(group_map)]
    for group in result["groups"]:
        group["sectors"] = [group["sectors"][index] for index in sorted(group["sectors"])]
    require(result.get("group_count") == len(result["groups"]), "source helper group count mismatch")
    require(result.get("link_count") == len(result["links"]), "source helper link count mismatch")
    return result


def command_name_for_owner(source_ground_id: int, group: int, sector: int, category: str,
                           index: int, slot: int = 0) -> str:
    stem = f"s_gs{source_ground_id}_g{group}_s{sector}_"
    if category == "L":
        return f"{stem}lives{index}_dlg{slot}"
    if category == "O":
        return f"{stem}obj{index}_dlg{slot}"
    if category == "F":
        return f"{stem}eff{index}_script"
    if category == "V":
        return f"{stem}evt{index}_sref_script"
    if category == "T":
        return f"{stem}station_sref_script"
    raise AuditError(f"unknown owner category {category}")


def decode_eu_graph(reader: RomReader, regional_id: int, source_ground_id: int) -> dict[str, Any]:
    table_entry = MAP_SCRIPT_TABLE_ADDRESS + regional_id * 4
    header_address = reader.u32(table_entry, f"regional map {regional_id} table entry")
    group_count, groups_address, links_address = reader.unpack(
        "<III", header_address, f"regional map {regional_id} header"
    )
    require(0 < group_count < 64, f"regional map {regional_id}: implausible group count {group_count}")
    result: dict[str, Any] = {
        "regional_ground_id": regional_id,
        "table_entry_address": address_hex(table_entry),
        "header_address": address_hex(header_address),
        "groups_address": address_hex(groups_address),
        "links_address": address_hex(links_address),
        "group_count": group_count,
        "groups": [],
        "owners": {},
        "refs": {},
        "entities": {},
        "node_addresses": {header_address, groups_address, links_address},
    }

    for g in range(group_count):
        sector_count, sectors_address = reader.unpack(
            "<II", groups_address + g * GROUP_SIZE, f"map {regional_id} group {g}"
        )
        require(0 < sector_count < 64, f"map {regional_id} group {g}: implausible sector count")
        result["node_addresses"].add(sectors_address)
        group = {
            "index": g, "sector_count": sector_count,
            "sectors_address": address_hex(sectors_address), "sectors": [],
        }
        for s in range(sector_count):
            sector_address = sectors_address + s * SECTOR_SIZE
            values = reader.unpack("<10I", sector_address, f"map {regional_id} group {g} sector {s}")
            lives, lives_ptr, objects, objects_ptr, effects, effects_ptr, events, events_ptr, has_station, station_ptr = values
            for count, pointer, label in (
                (lives, lives_ptr, "lives"), (objects, objects_ptr, "objects"),
                (effects, effects_ptr, "effects"), (events, events_ptr, "events"),
            ):
                require(count < 1024, f"map {regional_id} {label}: implausible count {count}")
                require((count == 0) == (pointer == 0),
                        f"map {regional_id} g{g}s{s} {label}: count/pointer disagreement")
                if pointer:
                    result["node_addresses"].add(pointer)
            require(has_station in (0, 1), f"map {regional_id} g{g}s{s}: invalid hasStation")
            require((has_station == 0) == (station_ptr == 0),
                    f"map {regional_id} g{g}s{s}: station count/pointer disagreement")
            sector = {
                "index": s, "address": address_hex(sector_address), "lives": lives,
                "objects": objects, "effects": effects, "events": events,
                "has_station": has_station,
            }

            for category, count, pointer in (
                ("L", lives, lives_ptr), ("O", objects, objects_ptr),
                ("F", effects, effects_ptr), ("V", events, events_ptr),
            ):
                for i in range(count):
                    stride = LIVES_OBJECT_SIZE if category in ("L", "O") else EFFECT_EVENT_SIZE
                    entity_address = pointer + i * stride
                    metadata = reader.bytes(entity_address, 8, f"map {regional_id} {category}{i} metadata")
                    result["entities"][(category, g, s, i)] = metadata.hex().upper()
                    if category in ("L", "O"):
                        for slot, command_address in enumerate(reader.unpack(
                            "<4I", entity_address + 8, f"map {regional_id} {category}{i} scripts"
                        )):
                            if command_address:
                                name = command_name_for_owner(source_ground_id, g, s, category, i, slot)
                                result["owners"][(category, g, s, i, slot)] = (name, command_address)
                                result["node_addresses"].add(command_address)
                    elif category == "F":
                        command_address = reader.u32(entity_address + 8, f"map {regional_id} effect script")
                        if command_address:
                            name = command_name_for_owner(source_ground_id, g, s, category, i)
                            result["owners"][(category, g, s, i, 0)] = (name, command_address)
                            result["node_addresses"].add(command_address)
                    else:
                        ref_address = reader.u32(entity_address + 8, f"map {regional_id} event ScriptRef")
                        if ref_address:
                            result["node_addresses"].add(ref_address)
                            ref_id, ref_type, _name_ptr, command_address = reader.unpack(
                                "<hhII", ref_address, f"map {regional_id} event ScriptRef"
                            )
                            name = command_name_for_owner(source_ground_id, g, s, category, i)
                            result["refs"][(category, g, s, i)] = {
                                "id": ref_id, "type": ref_type, "command": name,
                                "address": address_hex(ref_address),
                            }
                            result["owners"][(category, g, s, i, 0)] = (name, command_address)
                            result["node_addresses"].add(command_address)

            if has_station:
                result["node_addresses"].add(station_ptr)
                ref_address = reader.u32(station_ptr, f"map {regional_id} station pointer")
                result["node_addresses"].add(ref_address)
                ref_id, ref_type, _name_ptr, command_address = reader.unpack(
                    "<hhII", ref_address, f"map {regional_id} station ScriptRef"
                )
                name = command_name_for_owner(source_ground_id, g, s, "T", 0)
                result["refs"][("T", g, s, 0)] = {
                    "id": ref_id, "type": ref_type, "command": name,
                    "address": address_hex(ref_address),
                }
                result["owners"][("T", g, s, 0, 0)] = (name, command_address)
                result["node_addresses"].add(command_address)
            group["sectors"].append(sector)
        result["groups"].append(group)
    return result


def compare_structure(source: dict[str, Any], eu: dict[str, Any]) -> dict[str, Any]:
    errors: list[str] = []
    if source["group_count"] != eu["group_count"]:
        errors.append("group count")
    for g, source_group in enumerate(source["groups"]):
        if g >= len(eu["groups"]):
            break
        eu_group = eu["groups"][g]
        if source_group["sector_count"] != eu_group["sector_count"]:
            errors.append(f"g{g} sector count")
        for s, source_sector in enumerate(source_group["sectors"]):
            if s >= len(eu_group["sectors"]):
                break
            eu_sector = eu_group["sectors"][s]
            for key in ("lives", "objects", "effects", "events", "has_station"):
                if source_sector[key] != eu_sector[key]:
                    errors.append(f"g{g}s{s} {key}")
    if source["entities"] != eu["entities"]:
        missing = sorted(set(source["entities"]) ^ set(eu["entities"]), key=str)
        changed = sorted(
            key for key in set(source["entities"]) & set(eu["entities"])
            if source["entities"][key] != eu["entities"][key]
        )
        errors.extend(f"entity key {key}" for key in missing)
        errors.extend(f"entity metadata {key}" for key in changed)
    eu_owner_names = {key: value[0] for key, value in eu["owners"].items()}
    if source["owners"] != eu_owner_names:
        missing = sorted(set(source["owners"]) ^ set(eu_owner_names), key=str)
        changed = sorted(
            key for key in set(source["owners"]) & set(eu_owner_names)
            if source["owners"][key] != eu_owner_names[key]
        )
        errors.extend(f"owner key {key}" for key in missing)
        errors.extend(f"owner command {key}" for key in changed)
    comparable_eu_refs = {
        key: {"id": value["id"], "type": value["type"], "command": value["command"]}
        for key, value in eu["refs"].items()
    }
    if source["refs"] != comparable_eu_refs:
        errors.append("ScriptRef declarations")
    return {
        "status": "pass" if not errors else "fail",
        "mismatch_count": len(errors),
        "mismatches": errors,
    }


def normalized_source_core(core: CommandCore) -> CommandCore:
    # EU inserts five region-specific Ground IDs ahead of late story/dungeon
    # maps.  LOAD_MAP (op 0x08) carries the regional map ID in arg1.
    if core.op == 0x08 and core.arg1 >= 164:
        return CommandCore(core.op, core.arg_byte, core.arg_short, core.arg1 + 5, core.arg2)
    return core


def lcs_matches(source: list[CommandCore], eu: list[CommandCore]) -> list[tuple[int, int]]:
    rows, cols = len(source), len(eu)
    scores = [[0] * (cols + 1) for _ in range(rows + 1)]
    for i in range(rows - 1, -1, -1):
        for j in range(cols - 1, -1, -1):
            if normalized_source_core(source[i]) == eu[j]:
                scores[i][j] = scores[i + 1][j + 1] + 1
            else:
                scores[i][j] = max(scores[i + 1][j], scores[i][j + 1])
    matches: list[tuple[int, int]] = []
    i = j = 0
    while i < rows and j < cols:
        if normalized_source_core(source[i]) == eu[j]:
            matches.append((i, j)); i += 1; j += 1
        elif scores[i + 1][j] >= scores[i][j + 1]:
            i += 1
        else:
            j += 1
    return matches


def decode_command(reader: RomReader, address: int, context: str) -> tuple[CommandCore, int]:
    op, arg_byte, arg_short, arg1, arg2, pointer = reader.unpack("<BBhiiI", address, context)
    return CommandCore(op, arg_byte, arg_short, arg1, arg2), pointer


def select_command_extent(reader: RomReader, root: int, source_commands: list[CommandCore],
                          upper_bound: int, context: str) -> tuple[list[tuple[CommandCore, int]], list[tuple[int, int]]]:
    source = [command for command in source_commands if command.op != DEBUG_OPCODE]
    require(source, f"{context}: empty source command declaration")
    max_records = min(len(source) + 160, max(0, (upper_bound - root) // SCRIPT_COMMAND_SIZE))
    require(max_records >= len(source) // 2, f"{context}: command bound is too short")
    scanned = [decode_command(reader, root + i * SCRIPT_COMMAND_SIZE, f"{context} command {i}")
               for i in range(max_records)]
    final = normalized_source_core(source[-1])
    candidate_lengths = [i + 1 for i, (core, _pointer) in enumerate(scanned) if core == final]
    require(candidate_lengths, f"{context}: no bounded declaration-ending command found")

    best: tuple[int, int, int, list[tuple[int, int]]] | None = None
    for length in candidate_lengths:
        eu_cores = [core for core, _pointer in scanned[:length]]
        matches = lcs_matches(source, eu_cores)
        # Maximize semantic matches, then minimize unexplained records/distance.
        rank = (len(matches), -(length - len(matches)), -abs(length - len(source)))
        if best is None or rank > best[:3]:
            best = (*rank, matches)
            selected_length = length
    assert best is not None
    return scanned[:selected_length], best[3]


def decode_text_block(reader: RomReader, pointer: int, context: str) -> dict[str, Any]:
    strings: dict[str, Any] = {}
    cursor = pointer
    for language in LANGUAGES:
        raw = reader.c_string(cursor, f"{context} {language}")
        strings[language] = {
            "text": raw.decode("latin-1"),
            "raw_hex": raw.hex(),
            "address": address_hex(cursor),
        }
        cursor += len(raw) + 1
    return {
        "address": address_hex(pointer),
        "encoding": "PMD Red western single-byte text (Latin-1 evidence view; ~XX markup preserved)",
        "languages": strings,
        "end_address": address_hex(cursor),
    }


def classify_command(core: CommandCore) -> list[str]:
    labels: list[str] = []
    if core.op == 0x08:
        labels.append("map_transition")
    if 0x42 <= core.op <= 0x4B:
        labels.append("music_or_fanfare")
    if core.op in TEXT_OPCODES:
        labels.append("text")
    if core.op in TERMINAL_OPCODES:
        labels.append("terminal")
    # Animation/movement/camera opcodes occupy several families.  The report
    # keeps exact opcodes; this label is intentionally broad, never a rewrite.
    if core.op in set(range(0x50, 0x8E)) | set(range(0xA0, 0xB0)):
        labels.append("movement_animation_or_camera")
    return labels


def audit_candidate(reader: RomReader, source_ref: SourceReference, regional_id: int) -> dict[str, Any]:
    source_structure = parse_source_structure(source_ref.structure_lines)
    eu = decode_eu_graph(reader, regional_id, source_ref.source_ground_id)
    structure_comparison = compare_structure(source_structure, eu)
    require(structure_comparison["status"] == "pass",
            f"{source_ref.asset}: EU/source typed graph mismatch: {structure_comparison['mismatches']}")

    owner_by_name: dict[str, int] = {}
    for name, address in eu["owners"].values():
        require(name not in owner_by_name, f"{source_ref.asset}: command array {name} has duplicate owners")
        owner_by_name[name] = address
    declared_names = set(source_ref.command_names)
    owned_names = set(owner_by_name)
    unowned_declarations = sorted(declared_names - owned_names)
    undeclared_roots = sorted(owned_names - declared_names)
    require(not unowned_declarations and not undeclared_roots,
            f"{source_ref.asset}: EU command roots differ from complete pret declarations; "
            f"unowned={unowned_declarations}, undeclared={undeclared_roots}")

    all_nodes = sorted(eu["node_addresses"])
    scripts: list[dict[str, Any]] = []
    total_source = total_eu = total_matches = 0
    text_blocks: dict[int, dict[str, Any]] = {}
    opcode_counts: Counter[int] = Counter()
    category_counts: Counter[str] = Counter()
    minimum_coverage = 1.0

    for name in source_ref.command_names:
        root = owner_by_name[name]
        upper_candidates = [address for address in all_nodes if address > root]
        upper_bound = min(upper_candidates) if upper_candidates else ROM_BASE + len(reader.data)
        selected, matches = select_command_extent(
            reader, root, source_ref.commands[name], upper_bound,
            f"{source_ref.asset} {name}",
        )
        source_without_debug = [c for c in source_ref.commands[name] if c.op != DEBUG_OPCODE]
        coverage = len(matches) / len(source_without_debug)
        minimum_coverage = min(minimum_coverage, coverage)
        total_source += len(source_without_debug)
        total_eu += len(selected)
        total_matches += len(matches)
        match_by_eu = {eu_index: source_index for source_index, eu_index in matches}
        commands: list[dict[str, Any]] = []
        terminal_indices: list[int] = []
        for index, (core, pointer) in enumerate(selected):
            labels = classify_command(core)
            opcode_counts[core.op] += 1
            category_counts.update(labels)
            if "terminal" in labels:
                terminal_indices.append(index)
            text_ref = None
            if core.op in TEXT_OPCODES:
                require(pointer != 0, f"{source_ref.asset} {name}[{index}]: text opcode has null pointer")
                if pointer not in text_blocks:
                    text_blocks[pointer] = decode_text_block(
                        reader, pointer, f"{source_ref.asset} {name}[{index}] text"
                    )
                text_ref = address_hex(pointer)
            elif pointer:
                # Non-text pointers are retained as evidence but not interpreted.
                text_ref = None
            commands.append({
                "index": index,
                "address": address_hex(root + index * SCRIPT_COMMAND_SIZE),
                "op": core.op,
                "op_hex": f"0x{core.op:02X}",
                "arg_byte": core.arg_byte,
                "arg_short": core.arg_short,
                "arg1": core.arg1,
                "arg2": core.arg2,
                "pointer": address_hex(pointer) if pointer else None,
                "text_block": text_ref,
                "categories": labels,
                "pret_source_index": match_by_eu.get(index),
            })
        require(terminal_indices, f"{source_ref.asset} {name}: no terminal opcode in selected array")
        scripts.append({
            "name": name,
            "address": address_hex(root),
            "byte_length": len(selected) * SCRIPT_COMMAND_SIZE,
            "command_count": len(selected),
            "terminal_indices": terminal_indices,
            "pret_reference": {
                "declared_command_count": len(source_ref.commands[name]),
                "debug_commands_excluded": len(source_ref.commands[name]) - len(source_without_debug),
                "semantic_command_count": len(source_without_debug),
                "lcs_match_count": len(matches),
                "semantic_coverage": coverage,
                "eu_unmatched_command_count": len(selected) - len(matches),
                "note": "EU-only localized/variant commands are authoritative and intentionally retained",
            },
            "commands": commands,
        })

    # A very short EU array can replace one US text command with an entire
    # MSG_VAR/VARIANT family, so per-array coverage below 1 is legitimate.
    require(minimum_coverage >= 0.40,
            f"{source_ref.asset}: implausibly low EU/pret semantic alignment {minimum_coverage:.3f}")

    links = []
    links_address = int(eu["links_address"], 16)
    for index in range(source_structure["link_count"]):
        raw = reader.bytes(links_address + index * LINK_SIZE, LINK_SIZE,
                           f"{source_ref.asset} link {index}")
        links.append({"index": index, "address": address_hex(links_address + index * LINK_SIZE),
                      "raw_hex": raw.hex().upper()})
    require([link["raw_hex"] for link in links] == source_structure["links"],
            f"{source_ref.asset}: link geometry differs from typed pret declaration")

    serializable_groups = eu["groups"]
    serializable_refs = [
        {"owner": list(key), **value}
        for key, value in sorted(eu["refs"].items(), key=lambda item: str(item[0]))
    ]
    serializable_entities = [
        {"owner": list(key), "raw_hex": value}
        for key, value in sorted(eu["entities"].items(), key=lambda item: str(item[0]))
    ]
    return {
        "asset": source_ref.asset,
        "regional_ground_id": regional_id,
        "pret_source_ground_id": source_ref.source_ground_id,
        "regional_id_delta": regional_id - source_ref.source_ground_id,
        "map_script_table_entry": eu["table_entry_address"],
        "header_address": eu["header_address"],
        "typed_graph": {
            "group_count": eu["group_count"],
            "groups": serializable_groups,
            "script_refs": serializable_refs,
            "entities": serializable_entities,
            "links": links,
        },
        "pret_typed_graph_comparison": structure_comparison,
        "scripts": scripts,
        "text_blocks": [text_blocks[pointer] for pointer in sorted(text_blocks)],
        "summary": {
            "source_declaration_count": len(source_ref.command_names),
            "owned_command_root_count": len(owner_by_name),
            "unowned_source_declaration_count": len(unowned_declarations),
            "undeclared_eu_command_root_count": len(undeclared_roots),
            "command_array_count": len(scripts),
            "eu_command_count": total_eu,
            "pret_semantic_command_count": total_source,
            "pret_lcs_match_count": total_matches,
            "minimum_script_semantic_coverage": minimum_coverage,
            "text_block_count": len(text_blocks),
            "french_text_count": len(text_blocks),
            "opcode_counts": {f"0x{op:02X}": count for op, count in sorted(opcode_counts.items())},
            "category_counts": dict(sorted(category_counts.items())),
        },
        "validation": {"status": "pass"},
    }


def audit(rom: bytes, pret_root: Path, compiler: str, source_name: str) -> dict[str, Any]:
    require(len(rom) == EXPECTED_ROM_SIZE,
            f"ROM size mismatch: expected {EXPECTED_ROM_SIZE}, got {len(rom)}")
    digest = sha256(rom)
    require(digest == EXPECTED_ROM_SHA256,
            f"ROM SHA-256 mismatch: expected {EXPECTED_ROM_SHA256}, got {digest}")
    require((pret_root / "include" / "data_script.h").is_file(),
            f"not a pret/pmd-red checkout: {pret_root}")
    pret_commit_result = subprocess.run(
        ["git", "-C", str(pret_root), "rev-parse", "HEAD"], capture_output=True, text=True, check=False
    )
    pret_commit = pret_commit_result.stdout.strip() if pret_commit_result.returncode == 0 else None

    reader = RomReader(rom)
    candidates: list[dict[str, Any]] = []
    for asset, regional_id in CANDIDATES:
        source_ref = compile_source_reference(asset, pret_root, compiler)
        candidates.append(audit_candidate(reader, source_ref, regional_id))

    totals = Counter()
    for candidate in candidates:
        summary = candidate["summary"]
        for key in (
            "source_declaration_count", "owned_command_root_count",
            "unowned_source_declaration_count", "undeclared_eu_command_root_count",
            "command_array_count", "eu_command_count", "pret_semantic_command_count",
            "pret_lcs_match_count", "text_block_count", "french_text_count",
        ):
            totals[key] += summary[key]
    minimum_coverage = min(c["summary"]["minimum_script_semantic_coverage"] for c in candidates)
    return {
        "schema": REPORT_SCHEMA,
        "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
        "authority": {
            "game": "Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "source_filename": source_name,
            "rom_size": len(rom),
            "rom_sha256": digest,
            "regional_language_order": list(LANGUAGES),
        },
        "technical_reference": {
            "repository": "https://github.com/pret/pmd-red",
            "commit": pret_commit,
            "role": "typed declarations and semantic alignment only; never regional content authority",
            "host_compiler": compiler,
        },
        "eu_layout": {
            "gMapScriptTable_address": address_hex(MAP_SCRIPT_TABLE_ADDRESS),
            "gMapScriptTable_offset": address_hex(MAP_SCRIPT_TABLE_OFFSET),
            "ground_header_size": GROUND_HEADER_SIZE,
            "group_size": GROUP_SIZE,
            "sector_size": SECTOR_SIZE,
            "link_size": LINK_SIZE,
            "lives_object_size": LIVES_OBJECT_SIZE,
            "effect_event_size": EFFECT_EVENT_SIZE,
            "script_ref_size": SCRIPT_REF_SIZE,
            "script_command_size": SCRIPT_COMMAND_SIZE,
            "text_language_order": list(LANGUAGES),
        },
        "candidate_count": len(candidates),
        "candidates": candidates,
        "totals": {
            **dict(totals),
            "minimum_script_semantic_coverage": minimum_coverage,
        },
        "validation": {
            "status": "pass",
            "candidate_count": len(candidates),
            "typed_graph_mismatch_count": 0,
            "unmapped_command_root_count": 0,
            "unowned_source_declaration_count": totals["unowned_source_declaration_count"],
            "undeclared_eu_command_root_count": totals["undeclared_eu_command_root_count"],
            "missing_terminal_array_count": 0,
            "missing_text_language_count": 0,
        },
    }


def summarize(report: dict[str, Any]) -> str:
    totals = report["totals"]
    return "\n".join((
        f"PASS: {report['candidate_count']} exact EU Ground script graphs",
        f"Command arrays/records: {totals['command_array_count']}/{totals['eu_command_count']}",
        f"Five-language/French text blocks: {totals['text_block_count']}/{totals['french_text_count']}",
        f"pret semantic alignment: {totals['pret_lcs_match_count']}/{totals['pret_semantic_command_count']} "
        f"(minimum script coverage {totals['minimum_script_semantic_coverage']:.3f})",
        f"ROM: {report['authority']['rom_sha256']}",
    ))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path, help="exact European PMD Red ROM")
    parser.add_argument("--pret-root", type=Path, required=True, help="pret/pmd-red checkout")
    parser.add_argument("--compiler", default="gcc", help="host C compiler (default: gcc)")
    parser.add_argument("--report", type=Path, help="write complete JSON evidence")
    parser.add_argument("--compact", action="store_true", help="write compact JSON")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        rom = args.rom.read_bytes()
        report = audit(rom, args.pret_root, args.compiler, args.rom.name)
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            with args.report.open("w", encoding="utf-8", newline="\n") as stream:
                json.dump(report, stream, ensure_ascii=False, sort_keys=True,
                          indent=None if args.compact else 2,
                          separators=(",", ":") if args.compact else None)
                stream.write("\n")
        print(summarize(report))
        if args.report:
            print(f"Report: {args.report}")
        return 0
    except (AuditError, OSError, subprocess.SubprocessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
