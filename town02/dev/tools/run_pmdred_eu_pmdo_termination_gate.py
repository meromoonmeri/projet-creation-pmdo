#!/usr/bin/env python3
"""Run PMDO until validator ``end`` and classify its real termination status.

This runner deliberately does not hide ``wait``/``Popen.wait`` results. PMDO is
launched directly as a new process-group leader (without a ``timeout`` parent),
so the recorded return code belongs to PMDO itself. The fixture requests PMDO's
own ``GameBase.LoadPhase.Unload`` after writing its terminal event. A qualifying
run must then exit normally with status 0. TERM remains a strict watchdog for a
stalled unload: its real status is retained, and SIGSEGV or any signal-assisted
shutdown fails official qualification.

The runner is transport/lifecycle plumbing only.  It does not build, convert,
compare, install, or promote any Ground.
"""
from __future__ import annotations

import argparse
import json
import os
import signal
import subprocess
import time
from pathlib import Path
from typing import Any


def classify_returncode(returncode: int, requested_signal: int, forced_kill: bool) -> dict[str, Any]:
    """Classify a direct ``Popen.wait`` result without normalizing it away."""
    exit_signal = -returncode if returncode < 0 else None
    if forced_kill:
        kind, result = "FORCED_KILL", "FAIL"
    elif returncode == 0:
        kind, result = "NORMAL_EXIT", "PASS"
    elif returncode == -signal.SIGSEGV:
        kind, result = "SIGSEGV", "FAIL"
    elif returncode == -requested_signal:
        kind, result = f"EXPECTED_{signal.Signals(requested_signal).name}_SIGNAL", "PASS"
    elif returncode == 128 + requested_signal:
        # Some managed apphosts consume the Unix signal and exit explicitly
        # with the conventional 128+signal status.  wait(2) reports WIFEXITED,
        # not WIFSIGNALED; retain that distinction instead of rewriting 143 as
        # "-SIGTERM".
        kind, result = f"EXPECTED_{signal.Signals(requested_signal).name}_EXIT_CODE", "PASS"
    elif returncode < 0:
        kind, result = f"UNEXPECTED_{signal.Signals(-returncode).name}", "FAIL"
    else:
        kind, result = "NONZERO_EXIT", "FAIL"
    return {
        "result": result,
        "kind": kind,
        "returncode": returncode,
        "wait_state": "SIGNALED" if returncode < 0 else "EXITED",
        "normal_exit": returncode == 0,
        "exit_code": returncode if returncode >= 0 else None,
        "exit_signal": exit_signal,
        "exit_signal_name": signal.Signals(exit_signal).name if exit_signal else None,
        "segmentation_fault": exit_signal == signal.SIGSEGV,
        "forced_kill": forced_kill,
    }


def official_gate_passes(
    *,
    terminal_seen: bool,
    graceful_exit_observed: bool,
    returncode: int,
    requested_signal_sent: bool,
    residual_before: list[int],
    residual_after: list[int],
) -> bool:
    """Require the engine's own successful unload; watchdog exits never pass."""
    return (
        terminal_seen
        and graceful_exit_observed
        and returncode == 0
        and not requested_signal_sent
        and not residual_before
        and not residual_after
    )


def process_group_members(pgid: int) -> list[int]:
    """Return live PIDs whose Linux process-group ID equals ``pgid``."""
    members: list[int] = []
    for stat_path in Path("/proc").glob("[0-9]*/stat"):
        try:
            text = stat_path.read_text()
            # comm is parenthesized and can contain spaces; fields after it start
            # with state, ppid, pgrp.
            tail = text[text.rfind(")") + 2 :].split()
            if len(tail) >= 3 and int(tail[2]) == pgid:
                members.append(int(stat_path.parent.name))
        except (FileNotFoundError, PermissionError, ValueError):
            continue
    return sorted(members)


def has_terminal_event(path: Path) -> bool:
    try:
        return any(json.loads(line).get("event") == "end" for line in path.read_text().splitlines())
    except (FileNotFoundError, json.JSONDecodeError):
        return False


def signal_state(pid: int) -> dict[str, Any]:
    """Capture Linux signal masks before shutdown for TERM/INT diagnosis."""
    status: dict[str, str] = {}
    for line in Path(f"/proc/{pid}/status").read_text().splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            status[key] = value.strip()
    masks = {key: int(status.get(key, "0"), 16) for key in ("SigBlk", "SigIgn", "SigCgt")}
    signals: dict[str, Any] = {}
    for sig in (signal.SIGINT, signal.SIGTERM):
        bit = 1 << (sig - 1)
        caught = bool(masks["SigCgt"] & bit)
        ignored = bool(masks["SigIgn"] & bit)
        blocked = bool(masks["SigBlk"] & bit)
        signals[signal.Signals(sig).name] = {
            "number": int(sig),
            "caught": caught,
            "ignored": ignored,
            "blocked": blocked,
            "disposition": "CAUGHT" if caught else "IGNORED" if ignored else "DEFAULT",
        }
    return {
        "thread_count": int(status.get("Threads", "0")),
        "raw_masks": {key: f"{value:016x}" for key, value in masks.items()},
        "signals": signals,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pmdo", type=Path, required=True)
    parser.add_argument("--asset", type=Path, required=True)
    parser.add_argument("--appdata", type=Path, required=True)
    parser.add_argument("--quest", required=True)
    parser.add_argument("--events", type=Path, default=Path("/tmp/pmdred_eu_ground_validator.jsonl"))
    parser.add_argument("--runtime-log", type=Path, required=True)
    parser.add_argument("--event-copy", type=Path, required=True)
    parser.add_argument("--status-json", type=Path, required=True)
    parser.add_argument("--terminal-timeout", type=float, default=1800.0)
    parser.add_argument("--graceful-exit-timeout", type=float, default=30.0)
    parser.add_argument("--shutdown-timeout", type=float, default=15.0)
    parser.add_argument("--post-end-delay", type=float, default=0.1)
    parser.add_argument("--shutdown-signal", choices=("TERM", "INT"), default="TERM")
    parser.add_argument("--reset-events", action="store_true")
    args = parser.parse_args()

    for output in (args.runtime_log, args.event_copy, args.status_json):
        if output.exists():
            raise SystemExit(f"refusing existing output: {output}")
        output.parent.mkdir(parents=True, exist_ok=True)
    if args.events.exists():
        if not args.reset_events:
            raise SystemExit(f"validator stream already exists: {args.events}")
        args.events.unlink()

    shutdown_signal = getattr(signal, f"SIG{args.shutdown_signal}")
    command = [
        str(args.pmdo.resolve()),
        "-asset", str(args.asset.resolve()) + "/",
        "-appdata", str(args.appdata.resolve()) + "/",
        "-quest", args.quest,
    ]
    started = time.monotonic()
    with args.runtime_log.open("wb") as runtime_log:
        process = subprocess.Popen(
            command,
            stdout=runtime_log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        pgid = process.pid
        terminal_seen = False
        terminal_seen_at: float | None = None
        deadline = started + args.terminal_timeout
        while time.monotonic() < deadline:
            if has_terminal_event(args.events):
                terminal_seen = True
                terminal_seen_at = time.monotonic()
                break
            if process.poll() is not None:
                break
            time.sleep(0.02)

        pre_signal_state = None
        requested_signal_sent = False
        forced_kill = False
        graceful_exit_observed = False

        # The fixture requests GameBase.LoadPhase.Unload after writing `end`.
        # A qualifying process must complete that native PMDO/FNA/SDL teardown
        # itself and return 0. TERM remains the strict bounded watchdog: if the
        # normal path stalls, its exact status is captured but the run fails.
        if terminal_seen:
            try:
                returncode = process.wait(timeout=args.graceful_exit_timeout)
                graceful_exit_observed = True
            except subprocess.TimeoutExpired:
                pre_signal_state = signal_state(process.pid)
                time.sleep(args.post_end_delay)
                os.kill(process.pid, shutdown_signal)
                requested_signal_sent = True
                try:
                    returncode = process.wait(timeout=args.shutdown_timeout)
                except subprocess.TimeoutExpired:
                    forced_kill = True
                    os.killpg(pgid, signal.SIGKILL)
                    returncode = process.wait()
        elif process.poll() is not None:
            returncode = process.wait()
        else:
            pre_signal_state = signal_state(process.pid)
            os.kill(process.pid, shutdown_signal)
            requested_signal_sent = True
            try:
                returncode = process.wait(timeout=args.shutdown_timeout)
            except subprocess.TimeoutExpired:
                forced_kill = True
                os.killpg(pgid, signal.SIGKILL)
                returncode = process.wait()

    # The leader has been reaped. Any remaining member is an orphan for this
    # bounded run and is removed only after being recorded as a gate failure.
    time.sleep(0.2)
    residual_members = process_group_members(pgid)
    if residual_members:
        try:
            os.killpg(pgid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        time.sleep(0.1)
    residual_after_cleanup = process_group_members(pgid)

    event_bytes = args.events.read_bytes() if args.events.is_file() else b""
    args.event_copy.write_bytes(event_bytes)
    event_lines = event_bytes.decode(errors="replace").splitlines()
    parsed_events: list[dict[str, Any]] = []
    parse_error: str | None = None
    try:
        parsed_events = [json.loads(line) for line in event_lines]
    except json.JSONDecodeError as exc:
        parse_error = str(exc)

    termination = classify_returncode(returncode, shutdown_signal, forced_kill)
    # Classification preserves every raw status, but official qualification is
    # stricter: terminal evidence + engine-requested normal exit 0 + no orphan.
    if not official_gate_passes(
        terminal_seen=terminal_seen,
        graceful_exit_observed=graceful_exit_observed,
        returncode=returncode,
        requested_signal_sent=requested_signal_sent,
        residual_before=residual_members,
        residual_after=residual_after_cleanup,
    ):
        termination["result"] = "FAIL"
    result = {
        "schema": "new-era.pmdred-eu-pmdo-termination-gate.v2",
        "command": command,
        "pmdo_pid": pgid,
        "requested_signal": int(shutdown_signal),
        "requested_signal_name": signal.Signals(shutdown_signal).name,
        "requested_signal_sent": requested_signal_sent,
        "pre_signal_process_state": pre_signal_state,
        "terminal_seen": terminal_seen,
        "graceful_exit_requested_by_fixture": True,
        "graceful_exit_observed": graceful_exit_observed,
        "graceful_exit_timeout_seconds": args.graceful_exit_timeout,
        "terminal_to_signal_seconds": args.post_end_delay if requested_signal_sent else None,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "event_count": len(event_lines),
        "event_parse_error": parse_error,
        "last_event": parsed_events[-1] if parsed_events else None,
        "residual_processes_before_cleanup": residual_members,
        "residual_processes_after_cleanup": residual_after_cleanup,
        "termination": termination,
    }
    args.status_json.write_text(json.dumps(result, indent=2) + "\n")
    print(
        "PMDO_TERMINATION_GATE_{} kind={} returncode={} signal={} terminal={} graceful={} watchdog={} residual={}".format(
            termination["result"], termination["kind"], returncode,
            termination["exit_signal_name"], terminal_seen, graceful_exit_observed,
            requested_signal_sent, len(residual_members)
        )
    )
    return 0 if termination["result"] == "PASS" else 3


if __name__ == "__main__":
    raise SystemExit(main())
