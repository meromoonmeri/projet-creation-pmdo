#!/usr/bin/env python3
"""Extract the canonical PMD Red EU French personality quiz.

The EU ROM is the authority for every displayed French byte.  The pinned
pret/pmd-red source is used only to identify the records and recover the
question graph, answer values, and personality effects.  The script refuses
unknown inputs and generates both a reviewable provenance JSON document and
the Lua data consumed by New Era's existing ``personality_test`` Ground.
"""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
ENGLISH_RECORD_START = 0x080E394C
FRENCH_RECORD_START = 0x0810E43A
MAX_ASKED_QUESTIONS = 8
SELECTABLE_QUESTION_COUNT = 55
BRAVE_2B_TRIGGER = 99
PERSONALITIES = (
    "hardy", "docile", "brave", "jolly", "impish", "naive", "timid",
    "hasty", "sassy", "calm", "relaxed", "lonely", "quirky",
)
FRENCH_PERSONALITY_LABELS = {
    "hardy": "hardi",
    "docile": "docile",
    "brave": "brave",
    "jolly": "jovial",
    "impish": "malin",
    "naive": "naïf",
    "timid": "timide",
    "hasty": "pressé",
    "sassy": "malpoli",
    "calm": "calme",
    "relaxed": "relax",
    "lonely": "solo",
    "quirky": "bizarre",
}
DESCRIPTION_MACROS = tuple(f"DESC_{name.upper()}" for name in PERSONALITIES)
EU_ONLY_MACROS = (
    "EU_STARTER_CONFIRM",
    "EU_CONFIRM_YES",
    "EU_CONFIRM_RESTART",
)
POST_GENDER_MACROS = (
    "STARTER_REVEAL",
    "PARTNER_PROMPT",
    "PARTNER_NICK_PROMPT",
    "END_TEXT",
)
ROM_DISPLAY_REPLACEMENTS = (
    ("~27", "'"),
    ("~2c", ","),
    ("\x93", "“"),
    ("\x94", "”"),
)


@dataclass(frozen=True)
class RomRecord:
    address: int
    prefix: int
    raw: bytes

    @property
    def encoded_text(self) -> str:
        return self.raw.decode("cp1252")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def parse_locale_macros(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    matches = list(re.finditer(r"^#define\s+(\w+)\b", text, re.MULTILINE))
    result: dict[str, str] = {}
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        block = text[match.start():end]
        literals = re.findall(r'"(?:\\.|[^"\\])*"', block)
        if literals:
            result[match.group(1)] = "".join(ast.literal_eval(value) for value in literals)
    return result


def parse_effects(header: str, object_name: str) -> list[dict[str, int]]:
    match = re.search(
        r"(?:ALIGNED\(4\) )?static const PersonalityEffects "
        + re.escape(object_name)
        + r"Points\[\]\s*=\s*\{(.*?)\};",
        header,
        re.DOTALL,
    )
    require(match is not None, f"missing effects for {object_name}")
    rows = re.findall(r"\{([^{}]*)\}", match.group(1))
    return [
        {
            personality.lower(): int(points)
            for personality, points in re.findall(
                r"\[(\w+)\]\s*=\s*(-?\d+)", row
            )
        }
        for row in rows
    ]


def question_id(object_name: str) -> str:
    match = re.fullmatch(r"([A-Z][a-z]+)Quest(\d+)([AB]?)", object_name)
    require(match is not None, f"unsupported question object name {object_name}")
    suffix = match.group(3).lower()
    return f"{match.group(1).lower()}_{match.group(2)}{suffix}"


def parse_questions(header_path: Path) -> tuple[list[dict[str, Any]], list[str], list[str]]:
    header = header_path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"static const MenuItem (?P<object>\w+)Answers\[\]\s*=\s*\{"
        r"(?P<answers>.*?)\};\s*"
        r"static const PersonalityQuestion (?P=object)\s*=\s*\{\s*"
        r"(?P<question_macro>\w+)",
        re.DOTALL,
    )
    definitions: list[dict[str, Any]] = []
    record_macro_order: list[str] = []
    for match in pattern.finditer(header):
        answers = [
            {"macro": macro, "value": int(value)}
            for macro, value in re.findall(
                r"\{\s*(\w+)\s*,\s*(-?\d+)\s*\}", match.group("answers")
            )
            if macro != "NULL"
        ]
        effects = parse_effects(header, match.group("object"))
        require(
            len(answers) == len(effects),
            f"answer/effect count differs for {match.group('object')}",
        )
        for answer, answer_effects in zip(answers, effects, strict=True):
            answer["effects"] = answer_effects
        definition = {
            "id": question_id(match.group("object")),
            "pret_object": match.group("object"),
            "question_macro": match.group("question_macro"),
            "answers": answers,
        }
        definitions.append(definition)
        record_macro_order.extend(answer["macro"] for answer in answers)
        record_macro_order.append(definition["question_macro"])

    require(len(definitions) == 56, f"expected 56 question definitions, got {len(definitions)}")
    by_object = {row["pret_object"]: row for row in definitions}
    require(len(by_object) == len(definitions), "duplicate pret question objects")

    pointer_match = re.search(
        r"gPersonalityQuestionPointerTable\[.*?\]\s*=\s*\{(.*?)\};",
        header,
        re.DOTALL,
    )
    require(pointer_match is not None, "missing canonical question pointer table")
    pointer_objects = re.findall(r"&(\w+)", pointer_match.group(1))
    require(len(pointer_objects) == 56, "canonical pointer table must contain 55 questions plus BraveQuest2B")
    require(set(pointer_objects) == set(by_object), "question definitions and pointer table differ")

    nature_match = re.search(
        r"gNatureQuestionTable\[.*?\]\s*=\s*\{(.*?)\};",
        header,
        re.DOTALL,
    )
    require(nature_match is not None, "missing canonical nature/category table")
    nature_body = re.sub(r"//.*", "", nature_match.group(1))
    nature_order = [token.lower() for token in re.findall(r"\b[A-Z][A-Z_]+\b", nature_body)]
    require(len(nature_order) == 56, "canonical nature table must contain 56 entries")

    for index, (object_name, category) in enumerate(zip(pointer_objects, nature_order, strict=True)):
        row = by_object[object_name]
        row["pointer_index"] = index
        row["category"] = category
        row["selectable"] = index < SELECTABLE_QUESTION_COUNT
    require(pointer_objects[-1] == "BraveQuest2B", "BraveQuest2B must remain branch-only at pointer index 55")
    require(not by_object["BraveQuest2B"]["selectable"], "BraveQuest2B was made directly selectable")
    require(
        all(answer["value"] != BRAVE_2B_TRIGGER for row in definitions for answer in row["answers"] if row["pret_object"] != "BraveQuest2A")
        and any(answer["value"] == BRAVE_2B_TRIGGER for answer in by_object["BraveQuest2A"]["answers"]),
        "BraveQuest2B trigger graph differs from pret",
    )
    return definitions, record_macro_order, pointer_objects


def read_records(rom: bytes, gba_address: int, count: int) -> list[RomRecord]:
    offset = gba_address - 0x08000000
    records: list[RomRecord] = []
    for _ in range(count):
        require(offset + 2 <= len(rom), "ROM record prefix is truncated")
        prefix = int.from_bytes(rom[offset:offset + 2], "little")
        end = rom.find(b"\x00", offset + 2)
        require(end >= 0, "ROM record is not NUL terminated")
        records.append(RomRecord(0x08000000 + offset, prefix, rom[offset + 2:end]))
        offset = end + 1
        if offset % 2:
            offset += 1
    return records


def normalize_for_alignment(text: str) -> str:
    replacements = (
        ("{WAIT_PRESS}", "#W"),
        ("{EXTRA_MSG}", "#P"),
        ("{CENTER_ALIGN}", "#+"),
        ("{POKEMON_0}", "$m0"),
        ("~27", "'"),
        ("~2c", ","),
        ("~93", '"'),
        ("~94", '"'),
        ("\x93", '"'),
        ("\x94", '"'),
        ("“", '"'),
        ("”", '"'),
    )
    for source, destination in replacements:
        text = text.replace(source, destination)
    return "".join(text.split()).lower()


def display_text(encoded_text: str) -> str:
    text = encoded_text
    for source, destination in ROM_DISPLAY_REPLACEMENTS:
        text = text.replace(source, destination)
    return text.replace("#+", "")


def split_segments(encoded_text: str) -> list[dict[str, str | None]]:
    """Keep Red's explicit waits/pages while yielding PMDO-ready Unicode."""
    segments: list[dict[str, str | None]] = []
    cursor = 0
    for match in re.finditer(r"#([WP])", encoded_text):
        chunk = display_text(encoded_text[cursor:match.start()])
        if chunk:
            segments.append({
                "text": chunk,
                "after": "wait_press" if match.group(1) == "W" else "extra_message",
            })
        cursor = match.end()
        if cursor < len(encoded_text) and encoded_text[cursor] == "\n":
            cursor += 1
    tail = display_text(encoded_text[cursor:])
    if tail or not segments:
        segments.append({"text": tail, "after": None})
    elif segments:
        segments[-1]["after"] = None
    return segments


def record_payload(macro: str, record: RomRecord) -> dict[str, Any]:
    encoded = record.encoded_text
    return {
        "macro": macro,
        "rom_record_address": f"0x{record.address:08X}",
        "rom_text_address": f"0x{record.address + 2:08X}",
        "rom_prefix": record.prefix,
        "raw_hex": record.raw.hex(),
        "rom_encoded_text": encoded,
        "display_text": display_text(encoded).replace("#W", "").replace("#P", ""),
        "segments": split_segments(encoded),
    }


def lua_quote(value: str) -> str:
    escaped = (
        value.replace("\\", "\\\\")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
        .replace('"', '\\"')
    )
    return f'"{escaped}"'


def lua_value(value: Any, indent: int = 0) -> str:
    prefix = "  " * indent
    child = "  " * (indent + 1)
    if value is None:
        return "nil"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, str):
        return lua_quote(value)
    if isinstance(value, list):
        if not value:
            return "{}"
        return "{\n" + "".join(
            f"{child}{lua_value(item, indent + 1)},\n" for item in value
        ) + f"{prefix}}}"
    if isinstance(value, dict):
        if not value:
            return "{}"
        rows = []
        for key, item in value.items():
            if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", str(key)):
                lua_key = str(key)
            else:
                lua_key = f"[{lua_quote(str(key))}]"
            rows.append(f"{child}{lua_key} = {lua_value(item, indent + 1)},\n")
        return "{\n" + "".join(rows) + f"{prefix}}}"
    raise TypeError(f"cannot serialize {type(value)} to Lua")


def runtime_text(payload: dict[str, Any]) -> dict[str, Any]:
    return {
        "rom_encoded_text": payload["rom_encoded_text"],
        "segments": payload["segments"],
    }


def build(
    rom_path: Path,
    pret_root: Path,
    json_output: Path,
    lua_output: Path,
) -> dict[str, Any]:
    require(rom_path.is_file(), f"EU ROM missing: {rom_path}")
    require(sha256_file(rom_path) == ROM_SHA256, "EU ROM SHA-256 differs from the locked authority")
    commit = subprocess.run(
        ["git", "-C", str(pret_root), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    require(commit == PRET_COMMIT, f"pret/pmd-red commit differs: {commit}")

    data_header = pret_root / "src/data/personality_test1.h"
    locale_header = pret_root / "src/data/locale/personality_test1_usa.h"
    definitions, question_macro_order, pointer_objects = parse_questions(data_header)
    locale_macros = parse_locale_macros(locale_header)
    layout: list[str] = [
        *question_macro_order,
        "GENDER_Q", "GENDER_A0", "GENDER_A1",
        *EU_ONLY_MACROS,
        *POST_GENDER_MACROS,
        *DESCRIPTION_MACROS,
    ]
    require(len(question_macro_order) == 196, "question record inventory differs from the EU binary layout")
    require(len(layout) == 219, "EU personality text record inventory must contain 219 records")

    rom = rom_path.read_bytes()
    english_records = read_records(rom, ENGLISH_RECORD_START, len(layout))
    french_records = read_records(rom, FRENCH_RECORD_START, len(layout))
    for index, macro in enumerate(layout):
        if macro in EU_ONLY_MACROS:
            continue
        require(macro in locale_macros, f"missing USA locale macro {macro}")
        require(
            normalize_for_alignment(locale_macros[macro])
            == normalize_for_alignment(english_records[index].encoded_text),
            f"English EU ROM alignment failed at record {index} ({macro})",
        )

    french_by_macro = {
        macro: record_payload(macro, record)
        for macro, record in zip(layout, french_records, strict=True)
    }
    by_object = {row["pret_object"]: row for row in definitions}
    ordered_definitions = [by_object[name] for name in pointer_objects]
    questions: list[dict[str, Any]] = []
    for definition in ordered_definitions:
        answers = []
        for answer in definition["answers"]:
            answers.append({
                "value": answer["value"],
                "effects": answer["effects"],
                "text": french_by_macro[answer["macro"]],
            })
        questions.append({
            "id": definition["id"],
            "pret_object": definition["pret_object"],
            "pointer_index": definition["pointer_index"],
            "category": definition["category"],
            "selectable": definition["selectable"],
            "classification": "PMD_RED_EU_CANON",
            "question": french_by_macro[definition["question_macro"]],
            "answers": answers,
        })

    document = {
        "schema": "new-era.pmdred-eu-personality-quiz-authority.v1",
        "classification": "PMD_RED_EU_CANON",
        "authority": {
            "rom": str(rom_path.relative_to(ROOT)) if rom_path.is_relative_to(ROOT) else str(rom_path),
            "rom_sha256": ROM_SHA256,
            "rom_language": "French (Europe)",
            "french_record_start": f"0x{FRENCH_RECORD_START:08X}",
            "english_alignment_record_start": f"0x{ENGLISH_RECORD_START:08X}",
            "record_count": len(layout),
            "pret_repository": "https://github.com/pret/pmd-red.git",
            "pret_commit": PRET_COMMIT,
            "pret_role": "structure, ordering, branch graph, answer values, and effects only",
            "text_role": "all French text and control markers are decoded directly from the locked EU ROM",
        },
        "rules": {
            "personality_order": list(PERSONALITIES),
            "french_personality_labels": FRENCH_PERSONALITY_LABELS,
            "selectable_question_count": SELECTABLE_QUESTION_COUNT,
            "branch_question_count": 1,
            "asked_question_count": MAX_ASKED_QUESTIONS,
            "category_without_replacement": True,
            "brave_2b_trigger": BRAVE_2B_TRIGGER,
            "tie_resolution": "random start personality, then strict-greater cyclic scan exactly as RevealPersonality",
        },
        "gender": {
            "question": french_by_macro["GENDER_Q"],
            "answers": [french_by_macro["GENDER_A0"], french_by_macro["GENDER_A1"]],
        },
        "eu_confirmation": {
            "question": french_by_macro["EU_STARTER_CONFIRM"],
            "confirm": french_by_macro["EU_CONFIRM_YES"],
            "restart": french_by_macro["EU_CONFIRM_RESTART"],
        },
        "presentation_text": {
            macro.lower(): french_by_macro[macro] for macro in POST_GENDER_MACROS
        },
        "descriptions": {
            personality: french_by_macro[macro]
            for personality, macro in zip(PERSONALITIES, DESCRIPTION_MACROS, strict=True)
        },
        "questions": questions,
    }

    runtime_questions: dict[str, Any] = {}
    for row in questions:
        runtime_questions[row["id"]] = {
            "category": row["category"],
            "selectable": row["selectable"],
            "text": runtime_text(row["question"]),
            "answers": [
                {
                    "value": answer["value"],
                    "effects": answer["effects"],
                    "text": runtime_text(answer["text"]),
                }
                for answer in row["answers"]
            ],
        }
    runtime = {
        "classification": "PMD_RED_EU_CANON",
        "rom_sha256": ROM_SHA256,
        "pret_commit": PRET_COMMIT,
        "personalities": list(PERSONALITIES),
        "personality_labels": FRENCH_PERSONALITY_LABELS,
        "asked_question_count": MAX_ASKED_QUESTIONS,
        "selectable": [row["id"] for row in questions if row["selectable"]],
        "branch_question": "brave_2b",
        "branch_trigger": BRAVE_2B_TRIGGER,
        "questions": runtime_questions,
        "gender": {
            "question": runtime_text(document["gender"]["question"]),
            "answers": [runtime_text(value) for value in document["gender"]["answers"]],
        },
        "eu_confirmation": {
            key: runtime_text(value) for key, value in document["eu_confirmation"].items()
        },
        "presentation_text": {
            key: runtime_text(value) for key, value in document["presentation_text"].items()
        },
        "descriptions": {
            key: runtime_text(value) for key, value in document["descriptions"].items()
        },
    }
    require(len(runtime["selectable"]) == SELECTABLE_QUESTION_COUNT, "runtime selectable inventory differs")
    require(runtime["selectable"][-1] == "misc_3", "selectable pointer order does not end with MiscQuest3")

    json_output.parent.mkdir(parents=True, exist_ok=True)
    json_output.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    lua_output.parent.mkdir(parents=True, exist_ok=True)
    lua_output.write_text(
        "-- Generated by tools/extract_pmdred_eu_personality_quiz.py.\n"
        "-- French glyphs and control markers come from the locked PMD Red EU ROM.\n"
        "-- PMD_RED_EU_CANON: do not hand-edit or translate this table.\n"
        "return " + lua_value(runtime) + "\n",
        encoding="utf-8",
    )
    return document


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--rom", type=Path,
        default=ROOT / ".runtime-cache/downloads/pmdred-eu.gba",
    )
    parser.add_argument(
        "--pret-root", type=Path,
        default=ROOT / ".runtime-cache/pmd-red-reference",
    )
    parser.add_argument(
        "--json-output", type=Path,
        default=ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json",
    )
    parser.add_argument(
        "--lua-output", type=Path,
        default=ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_data.lua",
    )
    args = parser.parse_args()
    document = build(
        args.rom.resolve(), args.pret_root.resolve(),
        args.json_output.resolve(), args.lua_output.resolve(),
    )
    print(json.dumps({
        "result": "PASS",
        "records": document["authority"]["record_count"],
        "selectable_questions": document["rules"]["selectable_question_count"],
        "branch_questions": document["rules"]["branch_question_count"],
        "rom_sha256": document["authority"]["rom_sha256"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
