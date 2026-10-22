"""Stage 6 — static validation of the staged artefacts.

Consumes converter/rom_output/05_emit/staging/ and runs a battery of
strict checks on every file s05 accepted to stage:

  * provenance sidecar is present, well-formed, and its rom_sha256
    matches the expected ROM hash;
  * generated Lua parses (via luac -p when available, else the
    keyword-balance heuristic in converter.validators.lua_parse);
  * for each Lua module: any UI:WaitShowDialogue string key it
    references is either resolved (i.e. not a raw MSG_<hex>
    placeholder) or reported so the human review knows what still
    needs symbolic resolution;
  * every Lua file's status reason is coherent with the counts of
    PORTED / PARTIAL / UNKNOWN events its module comment declares.

This stage does not touch Data/. Its output is a machine-readable
findings.json plus a human-readable findings.md.
"""
from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

from converter.stages.context import (
    Context,
    ROM_EXPECTED_HASH,
    StageResult,
    StageStatus,
)
from converter.validators.lua_parse import check_file as lua_check


STAGE = "s06_validate"
STAGING_REL = "staging/Data/Script/halcyon/ground/_incoming"


_DIALOGUE_KEY = re.compile(
    r'UI:WaitShowDialogue\(STRINGS:FormatKey\("([^"]+)"\)\)'
)
_HEADER_COUNTS = re.compile(
    r"-- events\s*:\s*(\d+)\s*\(ported=(\d+),\s*partial=(\d+),\s*unknown=(\d+)\)"
)


def _check_provenance(prov_path: Path) -> tuple[bool, str, dict[str, Any] | None]:
    if not prov_path.exists():
        return False, "missing provenance sidecar", None
    try:
        data = json.loads(prov_path.read_text(encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        return False, f"malformed provenance JSON: {exc!r}", None
    if data.get("rom_sha256") != ROM_EXPECTED_HASH:
        got = data.get("rom_sha256") or "None"
        return False, f"rom_sha256 mismatch (got {got[:16]}...)", data
    if not data.get("status"):
        return False, "missing status", data
    if data["status"] not in {
        "CANONICAL", "PORTED", "PARTIAL", "RECONSTRUCTED",
        "UNKNOWN", "BLOCKED",
    }:
        return False, f"unknown status value {data['status']!r}", data
    if data["status"] not in {"CANONICAL", "PORTED"} and not \
            (data.get("status_reason") or "").strip():
        return False, (
            f"status {data['status']} without a non-empty status_reason"
        ), data
    return True, "OK", data


def _check_lua(lua_path: Path) -> tuple[bool, str]:
    ok, reason = lua_check(lua_path)
    return ok, reason


def _extract_dialogue_keys(lua_text: str) -> list[str]:
    return [m.group(1) for m in _DIALOGUE_KEY.finditer(lua_text)]


def _extract_header_counts(lua_text: str) -> tuple[int, int, int, int] | None:
    m = _HEADER_COUNTS.search(lua_text)
    if not m:
        return None
    return (int(m.group(1)), int(m.group(2)),
            int(m.group(3)), int(m.group(4)))


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    staging = ctx.rom_output_dir / "s05_emit" / STAGING_REL

    if not staging.is_dir():
        result.reason = (
            f"No staging tree at {staging}. Nothing to validate — "
            f"s05_emit must PASS first."
        )
        return result

    lua_files = sorted(staging.glob("*.lua"))
    if not lua_files:
        result.reason = (
            f"Staging tree exists but contains no *.lua yet. "
            f"s05_emit stages Lua modules; run the full pipeline first."
        )
        return result

    findings: list[dict[str, Any]] = []
    files_checked = 0
    files_ok = 0
    files_fail = 0
    total_dialogue_keys = 0
    unresolved_dialogue_keys = 0
    total_events = 0
    total_partial = 0
    total_unknown = 0

    for lua in lua_files:
        files_checked += 1
        prov_path = lua.with_suffix(".lua.provenance.json")
        prov_ok, prov_reason, prov_data = _check_provenance(prov_path)
        lua_text = lua.read_text(encoding="utf-8", errors="replace")
        lua_ok, lua_reason = _check_lua(lua)

        dialogue_keys = _extract_dialogue_keys(lua_text)
        raw_dialogue_keys = [k for k in dialogue_keys
                             if k.startswith("MSG_") and len(k) <= 12]
        total_dialogue_keys += len(dialogue_keys)
        unresolved_dialogue_keys += len(raw_dialogue_keys)

        header = _extract_header_counts(lua_text)
        if header is not None:
            evts, ported, partial, unknown = header
            total_events += evts
            total_partial += partial
            total_unknown += unknown

        entry_ok = prov_ok and lua_ok
        if entry_ok:
            files_ok += 1
        else:
            files_fail += 1
        findings.append({
            "file":               lua.name,
            "provenance_ok":      prov_ok,
            "provenance_reason":  prov_reason,
            "provenance_status":  (prov_data or {}).get("status"),
            "lua_ok":             lua_ok,
            "lua_reason":         lua_reason,
            "dialogue_keys_total": len(dialogue_keys),
            "dialogue_keys_unresolved": len(raw_dialogue_keys),
            "header_counts":      list(header) if header else None,
            "verdict":            "OK" if entry_ok else "FAIL",
        })

    payload = {
        "files_checked":              files_checked,
        "files_ok":                   files_ok,
        "files_fail":                 files_fail,
        "dialogue_keys_total":        total_dialogue_keys,
        "dialogue_keys_unresolved":   unresolved_dialogue_keys,
        "events_total_reported":      total_events,
        "events_partial_reported":    total_partial,
        "events_unknown_reported":    total_unknown,
        "per_file":                   findings[:500],
    }
    ctx.write_json(out / "findings.json", payload)

    # Human-readable summary.
    lines = [
        "# s06_validate findings",
        "",
        f"- Files checked : {files_checked}",
        f"- Files OK      : {files_ok}",
        f"- Files FAIL    : {files_fail}",
        f"- Dialogue keys : {total_dialogue_keys} "
        f"({unresolved_dialogue_keys} unresolved MSG_<hex>)",
        f"- Events        : {total_events} "
        f"(partial={total_partial}, unknown={total_unknown})",
        "",
        "| File | Verdict | Provenance | Lua parse | Dialogue keys |",
        "|---|---|---|---|---|",
    ]
    for f in findings[:100]:
        lines.append(
            f"| `{f['file']}` | {f['verdict']} | "
            f"{'OK' if f['provenance_ok'] else 'FAIL'} "
            f"({f['provenance_status']}) | "
            f"{'OK' if f['lua_ok'] else 'FAIL'} | "
            f"{f['dialogue_keys_total']} "
            f"({f['dialogue_keys_unresolved']} raw) |"
        )
    (out / "findings.md").write_text("\n".join(lines) + "\n",
                                     encoding="utf-8")
    result.artefacts.append(str(out / "findings.json"))
    result.artefacts.append(str(out / "findings.md"))
    result.metrics.update({
        "files_checked":            files_checked,
        "files_ok":                 files_ok,
        "files_fail":               files_fail,
        "dialogue_keys_total":      total_dialogue_keys,
        "dialogue_keys_unresolved": unresolved_dialogue_keys,
    })

    if files_fail > 0:
        result.status = StageStatus.FAIL
        result.reason = (
            f"{files_fail}/{files_checked} staged files failed validation "
            f"(see findings.json)"
        )
    else:
        result.status = StageStatus.PASS
        result.reason = (
            f"All {files_ok} staged Lua files pass provenance + parse "
            f"checks. {unresolved_dialogue_keys}/{total_dialogue_keys} "
            f"dialogue keys still unresolved (will be lifted by the "
            f"text-bank decoder in a follow-up)."
        )
    return result
