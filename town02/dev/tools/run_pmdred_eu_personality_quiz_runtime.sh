#!/usr/bin/env bash
# Reproduce the ROM extraction and real-PMDO personality-quiz core gate.
set -euo pipefail
IFS=$'\n\t'

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/pmdred-eu-personality-quiz-fixture"
REPRO="$ROOT/.runtime-cache/pmdred-eu-personality-quiz-extraction-repro"
EVENTS=/tmp/pmdred_eu_personality_quiz.jsonl
EVIDENCE="$ROOT/docs/pmdred_eu/narrative_migration/personality_quiz/runtime_core"

python3 tools/verify_pmdred_eu_narrative_migration_guard.py

test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/DumpAsset.tree-sha256 | cut -d' ' -f1)" = 42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
test "$(wc -l < .runtime-cache/DumpAsset.tree-sha256)" -eq 11485
test "$(sha256sum .runtime-cache/downloads/pmdred-eu.gba | cut -d' ' -f1)" = 0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd
test "$(git -C .runtime-cache/pmd-red-reference rev-parse HEAD)" = bf0092d0e34fd8e49b859a0b5f96f00740faa42d

rm -rf "$REPRO"
mkdir -p "$REPRO"
python3 tools/extract_pmdred_eu_personality_quiz.py \
  --json-output "$REPRO/personality_quiz_fr_eu.json" \
  --lua-output "$REPRO/pmdred_quiz_data.lua"
cmp "$REPRO/personality_quiz_fr_eu.json" docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json
cmp "$REPRO/pmdred_quiz_data.lua" Data/Script/halcyon/ground/personality_test/pmdred_quiz_data.lua
rm -rf "$REPRO"

"$PYTHON" tools/build_pmdred_eu_personality_quiz_fixture.py --output "$FIX"

PMDO_ENV=(
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$DOTNET_EXTRACT"
  LD_LIBRARY_PATH="$BUNDLE"
  SDL_VIDEODRIVER=offscreen
  SDL_AUDIODRIVER=dummy
  SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so"
  SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so"
  PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1
  PMDO_HEADLESS_DISMISS_SPLASH=1
  FNA3D_FORCE_DRIVER=OpenGL
  FNA3D_OPENGL_FORCE_ES3=1
  ANGLE_DEFAULT_PLATFORM=vulkan
  VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json"
)

env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_personality_quiz_fixture -index zone >"$FIX/index.log" 2>&1
! grep -qE 'Could not deserialize|Error importing|Exception Depth' "$FIX/index.log"

env "${PMDO_ENV[@]}" PMDO_NARRATIVE_VALIDATOR=pmdred_eu_personality_quiz_core \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_personality_quiz_fixture --events "$EVENTS" \
  --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
  --status-json "$FIX/termination.json" --terminal-timeout 120 --reset-events

! grep -qE 'Exception Depth|Could not find value|RUNTIME_FAIL|Lua Trace' "$FIX/runtime.log"
"$PYTHON" tools/validate_pmdred_eu_personality_quiz_runtime.py --fixture "$FIX" --check-only
"$PYTHON" - "$FIX" "$EVIDENCE" <<'PY'
import hashlib, json, sys
from pathlib import Path
fixture, evidence = map(Path, sys.argv[1:])
archived_events = [json.loads(line) for line in (evidence / 'events.jsonl').read_text().splitlines()]
actual_events = [json.loads(line) for line in (fixture / 'events.jsonl').read_text().splitlines()]
# Software-rendered PMDO may expose one extra global Update during WaitFrames;
# compare the complete semantic timeline while the validator separately proves
# contiguous sequence numbers, monotonic frames, and capture ordering.
def semantic(rows):
    return [{key: value for key, value in row.items() if key != 'frame'} for row in rows]
assert semantic(actual_events) == semantic(archived_events)
print('PERSONALITY_QUIZ_SEMANTIC_TIMELINE_REPRODUCTION_PASS')
expected = json.loads((evidence / 'validation.json').read_text())['parallax']['captures']
actual = sorted(
    (fixture / 'appdata/SCREENSHOT').glob('*.png'),
    key=lambda path: (path.stat().st_mtime_ns, path.name),
)
assert len(expected) == len(actual) == 2
assert all(
    row['sha256'] == hashlib.sha256(path.read_bytes()).hexdigest()
    for row, path in zip(expected, actual, strict=True)
)
print('PERSONALITY_QUIZ_CAPTURE_HASH_REPRODUCTION_PASS')
PY
python3 tools/verify_pmdred_eu_narrative_migration_guard.py

echo PMDRED_EU_PERSONALITY_QUIZ_CORE_REPRODUCTION_PASS_NOT_PRODUCTION_ROUTED
