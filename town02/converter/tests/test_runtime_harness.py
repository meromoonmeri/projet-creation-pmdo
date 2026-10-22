"""Tests for the PMDO runtime harness.

Synthetic Lua only; never runs a real PMDO binary in CI. We prove the
harness:
  * falls back to `luac -p` when no PMDO binary is available,
  * returns a FAIL RuntimeProbe (not a fabricated PASS) on broken Lua,
  * returns an honest SKIP-like RuntimeProbe when neither PMDO nor
    luac are present.
"""
from __future__ import annotations

import shutil
from pathlib import Path

import pytest

from converter.runtime.pmdo_headless import (
    locate_pmdo_binary,
    probe_lua_module,
)


VALID_LUA = """\
local m = {}
function m.Cutscene()
  return true
end
return m
"""

BROKEN_LUA = """\
local m = {}
function m.Cutscene()
  if then
end
return m
"""


def _write(tmp_path: Path, name: str, text: str) -> Path:
    p = tmp_path / name
    p.write_text(text, encoding="utf-8")
    return p


def test_locate_binary_prefers_env(monkeypatch, tmp_path: Path) -> None:
    fake = tmp_path / "PMDO"
    fake.write_text("#!/bin/sh\nexit 0\n", encoding="utf-8")
    fake.chmod(0o755)
    monkeypatch.setenv("PMDO_HEADLESS_BIN", str(fake))
    assert locate_pmdo_binary() == str(fake)


def test_probe_luac_parses_valid_lua(tmp_path: Path, monkeypatch) -> None:
    # Ensure we do NOT accidentally pick up a fake PMDO binary
    monkeypatch.delenv("PMDO_HEADLESS_BIN", raising=False)
    monkeypatch.delenv("PMDO_HEADLESS_SRC", raising=False)

    p = _write(tmp_path, "ok.lua", VALID_LUA)
    probe = probe_lua_module(p)
    if shutil.which("luac") is None:
        assert probe.ok is False
        assert "no PMDO binary" in probe.reason
    else:
        assert probe.ok is True, probe.reason
        assert probe.lua_module_probed == str(p)


def test_probe_luac_rejects_broken_lua(tmp_path: Path, monkeypatch) -> None:
    monkeypatch.delenv("PMDO_HEADLESS_BIN", raising=False)
    monkeypatch.delenv("PMDO_HEADLESS_SRC", raising=False)
    if shutil.which("luac") is None:
        pytest.skip("luac not installed; nothing to prove here")
    p = _write(tmp_path, "bad.lua", BROKEN_LUA)
    probe = probe_lua_module(p)
    assert probe.ok is False
    assert probe.exit_code not in (None, 0)
    assert "rejected" in probe.reason or "failed" in probe.reason


def test_probe_returns_honest_reason_when_nothing_available(
    tmp_path: Path, monkeypatch,
) -> None:
    monkeypatch.delenv("PMDO_HEADLESS_BIN", raising=False)
    monkeypatch.delenv("PMDO_HEADLESS_SRC", raising=False)
    # Force PATH without luac and without PMDO.
    monkeypatch.setenv("PATH", str(tmp_path))
    p = _write(tmp_path, "ok.lua", VALID_LUA)
    probe = probe_lua_module(p)
    assert probe.ok is False
    assert "no PMDO binary" in probe.reason
