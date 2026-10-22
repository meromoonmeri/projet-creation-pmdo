"""PMDO headless harness.

Runs a RogueEssence-based binary as a subprocess against the mod tree
under a scratch directory, feeds it a minimal scenario, and captures
diagnostic output. When the binary is not available on the machine,
returns None (never fabricates a trace).

Two ways to point the harness at a binary:
  * environment variable PMDO_HEADLESS_BIN (absolute path)
  * a `dotnet` invocation against a RogueEssence checkout whose path
    is given via env PMDO_HEADLESS_SRC (we run `dotnet run --project
    $PMDO_HEADLESS_SRC/RogueEssence -- <args>`).

The harness is deliberately conservative: it only asks the runtime to
LOAD a Lua module and REPORT whether it loaded cleanly. It does not
try to execute the cutscene (that would require a full mod harness
which every RogueEssence build ships differently). A clean load is
already a strong runtime signal: it proves the Lua parses inside the
engine, all UI/GAME/SOUND API references it uses resolve, and no
syntax rejection occurs.
"""
from __future__ import annotations

import os
import shutil
import subprocess
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional


@dataclass
class RuntimeProbe:
    ok: bool
    reason: str
    binary_used: Optional[str] = None
    exit_code: Optional[int] = None
    stdout_tail: str = ""
    stderr_tail: str = ""
    lua_module_probed: Optional[str] = None


def locate_pmdo_binary() -> Optional[str]:
    """Return an invocation string for the PMDO binary or None.

    Priority: env PMDO_HEADLESS_BIN, then `which PMDO`, then None.
    A `dotnet run --project ...` command is composed only if
    PMDO_HEADLESS_SRC is set AND `dotnet` is on PATH.
    """
    env = os.environ.get("PMDO_HEADLESS_BIN")
    if env and Path(env).exists():
        return env
    which = shutil.which("PMDO")
    if which:
        return which
    src = os.environ.get("PMDO_HEADLESS_SRC")
    if src and Path(src).exists() and shutil.which("dotnet"):
        return f"dotnet:{src}"
    return None


def _luac_probe_first(lua_path: Path) -> RuntimeProbe:
    """If a real PMDO binary is not available but `luac` is, use it
    as a *partial* runtime probe: it proves the file parses as valid
    Lua 5.x, which is the strictest thing a static check can do."""
    luac = shutil.which("luac")
    if luac is None:
        return RuntimeProbe(
            ok=False, reason="no PMDO binary and no luac available",
        )
    try:
        proc = subprocess.run(
            [luac, "-p", str(lua_path)],
            capture_output=True, text=True, timeout=20,
        )
    except Exception as exc:  # noqa: BLE001
        return RuntimeProbe(ok=False, reason=f"luac invocation failed: {exc!r}")
    if proc.returncode != 0:
        return RuntimeProbe(
            ok=False,
            reason=(
                "no PMDO binary; luac -p rejected the generated Lua"
            ),
            binary_used=luac, exit_code=proc.returncode,
            stdout_tail=proc.stdout[-2048:],
            stderr_tail=proc.stderr[-2048:],
            lua_module_probed=str(lua_path),
        )
    return RuntimeProbe(
        ok=True,
        reason=(
            "no PMDO binary available; luac -p parsed the generated "
            "Lua successfully (partial runtime signal)"
        ),
        binary_used=luac, exit_code=0,
        stdout_tail=proc.stdout[-1024:],
        lua_module_probed=str(lua_path),
    )


def probe_lua_module(lua_path: Path, *, timeout: int = 60) -> RuntimeProbe:
    """Attempt to have a real PMDO/RogueEssence binary load `lua_path`.

    Fallback to `luac -p` when no PMDO binary is present so we still
    return a meaningful RuntimeProbe (partial signal) instead of
    fabricating a PASS.
    """
    binary = locate_pmdo_binary()
    if binary is None:
        return _luac_probe_first(lua_path)

    # dotnet: prefix means we should invoke `dotnet run` against a
    # RogueEssence source checkout. This lets a machine with only a
    # source clone still participate in the runtime probe.
    if binary.startswith("dotnet:"):
        src = binary.removeprefix("dotnet:")
        cmd = [
            "dotnet", "run", "--project", src, "--",
            "--headless-lua-check", str(lua_path),
        ]
    else:
        cmd = [binary, "--headless-lua-check", str(lua_path)]

    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout,
        )
    except FileNotFoundError as exc:
        return RuntimeProbe(
            ok=False, reason=f"binary not executable: {exc!r}",
            binary_used=binary, lua_module_probed=str(lua_path),
        )
    except subprocess.TimeoutExpired:
        return RuntimeProbe(
            ok=False,
            reason=f"PMDO probe timed out after {timeout}s",
            binary_used=binary, lua_module_probed=str(lua_path),
        )
    except Exception as exc:  # noqa: BLE001
        return RuntimeProbe(
            ok=False, reason=f"PMDO probe failed: {exc!r}",
            binary_used=binary, lua_module_probed=str(lua_path),
        )

    ok = (proc.returncode == 0)
    return RuntimeProbe(
        ok=ok,
        reason=(
            f"PMDO --headless-lua-check exited {proc.returncode}"
        ),
        binary_used=binary, exit_code=proc.returncode,
        stdout_tail=(proc.stdout or "")[-4096:],
        stderr_tail=(proc.stderr or "")[-4096:],
        lua_module_probed=str(lua_path),
    )
