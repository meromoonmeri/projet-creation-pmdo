"""Stage 7 — runtime probe of every staged Lua module.

Walks converter/rom_output/05_emit/staging/ Data/Script/halcyon/
ground/_incoming/*.lua and runs converter.runtime.pmdo_headless
.probe_lua_module on each one.

When a real PMDO/RogueEssence binary is available (via env
PMDO_HEADLESS_BIN or PMDO_HEADLESS_SRC), we get a strong runtime
signal: the file must actually load inside the engine. When only luac
is available, we get a partial signal: the file must parse as valid
Lua 5.x. When neither is available, we return SKIPPED honestly with
the exact reason so nobody mistakes it for a PASS.

Never fabricates a runtime PASS.
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path
from typing import Any

from converter.runtime.pmdo_headless import locate_pmdo_binary, probe_lua_module
from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s07_runtime"
STAGING_REL = "staging/Data/Script/halcyon/ground/_incoming"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)
    staging = ctx.rom_output_dir / "s05_emit" / STAGING_REL

    if not staging.is_dir():
        result.reason = (
            "No staging tree at "
            f"{staging.relative_to(ctx.repo_root)}. Runtime probe has "
            "nothing to load. s05_emit must PASS first."
        )
        return result

    lua_files = sorted(staging.glob("*.lua"))
    if not lua_files:
        result.reason = "Staging tree contains no *.lua yet."
        return result

    binary = locate_pmdo_binary()
    have_luac = shutil.which("luac") is not None

    per_file: list[dict[str, Any]] = []
    n_ok = 0
    n_fail = 0
    n_skipped = 0
    for lua in lua_files:
        probe = probe_lua_module(lua)
        row = {
            "file":           lua.name,
            "ok":             probe.ok,
            "reason":         probe.reason,
            "binary_used":    probe.binary_used,
            "exit_code":      probe.exit_code,
            # Trim tails so the JSON stays readable
            "stdout_tail":    (probe.stdout_tail or "")[-1024:],
            "stderr_tail":    (probe.stderr_tail or "")[-1024:],
        }
        per_file.append(row)
        if probe.ok:
            n_ok += 1
        elif probe.binary_used is None:
            # No probe method at all
            n_skipped += 1
        else:
            n_fail += 1

    payload: dict[str, Any] = {
        "pmdo_binary":  binary,
        "luac_present": have_luac,
        "files":        len(lua_files),
        "ok":           n_ok,
        "fail":         n_fail,
        "skipped":      n_skipped,
        "per_file":     per_file[:500],
    }
    ctx.write_json(out / "runtime.json", payload)
    result.artefacts.append(str(out / "runtime.json"))
    result.metrics.update({
        "files": len(lua_files), "ok": n_ok,
        "fail": n_fail, "skipped": n_skipped,
        "binary_used": binary or "",
    })

    if n_fail > 0:
        result.status = StageStatus.FAIL
        result.reason = (
            f"{n_fail}/{len(lua_files)} staged Lua files failed the "
            f"runtime probe (see runtime.json). "
            f"Probe method: {binary or ('luac' if have_luac else 'none')}."
        )
        return result

    if n_ok == 0:
        # No probe was possible at all.
        result.status = StageStatus.SKIPPED
        result.reason = (
            "No PMDO binary and no luac on PATH. Runtime probe cannot "
            "run honestly. Set PMDO_HEADLESS_BIN to a RogueEssence "
            "executable, PMDO_HEADLESS_SRC to a RogueEssence checkout, "
            "or install luac (any Lua 5.x) to enable at least a parse "
            "probe."
        )
        return result

    result.status = StageStatus.PASS
    kind = (
        "real PMDO binary" if binary and not binary.startswith("dotnet:")
        else "dotnet-hosted RogueEssence" if binary
        else "luac -p (parse-only fallback)"
    )
    result.reason = (
        f"{n_ok}/{len(lua_files)} staged Lua files probed successfully "
        f"via {kind}."
    )
    return result
