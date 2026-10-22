"""Stage 5 — stage the mapped Lua for review before touching Data/.

Reads converter/rom_output/04_map/lua/*.lua produced by s04 and copies
each file into converter/rom_output/05_emit/staging/Data/Script/halcyon/
ground/_incoming/<scene>.lua, together with its provenance sidecar.

Guardrails (deliberately conservative for now):
  * Never writes under Data/, Content/, Strings/ directly. The staging
    tree mirrors the real layout so a future human-supervised step can
    diff and cherry-pick.
  * Refuses to stage a Lua file whose provenance is missing.
  * Refuses to stage a Lua file whose provenance rom_sha256 does not
    match the expected ROM hash.
  * Journals every write to _write.log for later rollback.
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path

from converter.stages.context import (
    Context,
    ROM_EXPECTED_HASH,
    StageResult,
    StageStatus,
)


STAGE = "s05_emit"
STAGING_REL = "staging/Data/Script/halcyon/ground/_incoming"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    staging = out / STAGING_REL
    staging.mkdir(parents=True, exist_ok=True)
    log_path = out / "_write.log"

    src_dir = ctx.rom_output_dir / "s04_map" / "lua"
    if not src_dir.is_dir():
        result.reason = "No s04 lua output; nothing to stage."
        return result

    lua_files = sorted(src_dir.glob("*.lua"))
    if not lua_files:
        result.reason = "s04 produced no .lua files."
        return result

    staged = 0
    refused = 0
    log_lines: list[str] = []
    refusals: list[dict] = []

    for lua in lua_files:
        prov_path = lua.with_suffix(".lua.provenance.json")
        if not prov_path.exists():
            refused += 1
            refusals.append({
                "file": lua.name,
                "reason": "missing provenance sidecar",
            })
            continue
        try:
            prov = json.loads(prov_path.read_text(encoding="utf-8"))
        except Exception as exc:  # noqa: BLE001
            refused += 1
            refusals.append({
                "file": lua.name,
                "reason": f"malformed provenance JSON: {exc!r}",
            })
            continue
        if prov.get("rom_sha256") != ROM_EXPECTED_HASH:
            refused += 1
            refusals.append({
                "file": lua.name,
                "reason": (
                    f"provenance rom_sha256={prov.get('rom_sha256', 'None')[:16]}"
                    f"... does not match expected"
                ),
            })
            continue

        dst = staging / lua.name
        dst_prov = staging / prov_path.name
        shutil.copyfile(lua, dst)
        shutil.copyfile(prov_path, dst_prov)
        staged += 1
        log_lines.append(
            f"STAGED {lua.name} -> {dst.relative_to(ctx.repo_root)} "
            f"(provenance status={prov.get('status')})"
        )

    log_path.write_text("\n".join(log_lines) + "\n", encoding="utf-8")

    ctx.write_json(out / "_summary.json", {
        "staged":   staged,
        "refused":  refused,
        "target_note": (
            "Staged files live under converter/rom_output/05_emit/staging/. "
            "They are NOT copied into the real Data/ tree in this stage. "
            "A future stage will merge them under human supervision."
        ),
        "refusals": refusals,
    })
    result.artefacts.append(str(out / "_summary.json"))
    result.metrics.update({"staged": staged, "refused": refused})

    if staged == 0:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            f"No Lua could be staged (refused: {refused}). "
            f"See _summary.json for refusal reasons."
        )
    else:
        result.status = StageStatus.PASS
        result.reason = (
            f"Staged {staged} Lua cutscenes under "
            f"converter/rom_output/05_emit/staging/. "
            f"Nothing has been written under Data/ yet — human review "
            f"required before merging."
        )
    return result
