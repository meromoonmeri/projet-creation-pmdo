#!/usr/bin/env python3
"""Audit FutureArc BGM assets and report canonical cutscene pacing.

The PMDO dialogue APIs are player-advanced, so a static audit cannot prove a
wall-clock runtime.  The pacing estimate below is intentionally labelled and
uses six seconds per dialogue box plus explicit WaitFrames at 60 FPS.  It is a
review aid, not an engine-runtime assertion.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARC = ROOT / "Data/Script/halcyon/future_arc"
SCENES = ARC / "scene"
MUSIC = ROOT / "Content/Music"
ROUTE = ARC / "FutureArc.lua"

PLAY_BGM = re.compile(r"PlayBGM\((['\"])((?:\\.|(?!\1).)*)\1")
ROUTE_SCENE = re.compile(r"scene\('[^']+',\s*'([^']+)'")
DIALOGUE = re.compile(r"UI:WaitShowDialogue\(")
WAIT = re.compile(r"GAME:WaitFrames\((\d+)\)")


def lua_literal(value: str) -> str:
    """Decode the simple escapes used by the generated BGM literals."""
    return value.replace(r"\'", "'").replace(r'\"', '"')


def main() -> int:
    errors: list[str] = []
    music_assets = {path.name for path in MUSIC.iterdir() if path.is_file()}
    bgm_calls = 0
    bgm_names: set[str] = set()

    for path in sorted(ARC.rglob("*.lua")):
        source = path.read_text(encoding="utf-8")
        for match in PLAY_BGM.finditer(source):
            bgm_calls += 1
            name = lua_literal(match.group(2))
            bgm_names.add(name)
            if name not in music_assets:
                errors.append(f"{path.relative_to(ROOT)}: missing BGM asset {name!r}")

    route_source = ROUTE.read_text(encoding="utf-8")
    route_modules = list(dict.fromkeys(ROUTE_SCENE.findall(route_source)))
    pacing: list[tuple[str, int, int, int, float]] = []
    for module in route_modules:
        path = SCENES / f"{module}.lua"
        if not path.is_file():
            errors.append(f"canonical route scene is missing: {path.relative_to(ROOT)}")
            continue
        source = path.read_text(encoding="utf-8")
        boxes = len(DIALOGUE.findall(source))
        waits = sum(int(value) for value in WAIT.findall(source))
        cues = len(PLAY_BGM.findall(source))
        estimate = boxes * 6 / 60 + waits / 3600
        pacing.append((module, boxes, waits, cues, estimate))
        # Thirty player-read boxes are the static proxy for a substantial
        # exchange.  Every such exchange must retain at least one OST cue.
        if boxes >= 30 and cues == 0:
            errors.append(f"major route exchange has no BGM cue: {module}")

    print(
        f"FutureArc OST: {bgm_calls} literal PlayBGM calls, "
        f"{len(bgm_names)} unique existing assets"
    )
    print(f"Canonical route cinematics: {len(pacing)}/{len(route_modules)} present")
    print("Major exchanges (>=30 dialogue boxes; estimate = 6 s/box + explicit waits):")
    major = [row for row in pacing if row[1] >= 30]
    for module, boxes, waits, cues, estimate in major:
        print(
            f"  {module}: {boxes} boxes, {waits} wait frames, "
            f"{cues} BGM cues, ~{estimate:.1f} min"
        )
    print(
        "NOTE: dialogue is player-advanced; exact duration and cue playback "
        "still require PMDO engine testing."
    )

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print(f"OK: {len(major)} major route exchanges retain valid OST cues")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
