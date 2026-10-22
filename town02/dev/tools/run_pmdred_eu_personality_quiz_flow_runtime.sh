#!/usr/bin/env bash
# Reproduce the real-PMDO production personality-quiz flow gate.
set -euo pipefail
IFS=$'\n\t'

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/pmdred-eu-personality-quiz-flow-fixture"
EVENTS=/tmp/pmdred_eu_personality_quiz_flow.jsonl
EVIDENCE="$ROOT/docs/pmdred_eu/narrative_migration/personality_quiz/runtime_flow"

python3 tools/verify_pmdred_eu_narrative_migration_guard.py
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/DumpAsset.tree-sha256 | cut -d' ' -f1)" = 42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
test "$(wc -l < .runtime-cache/DumpAsset.tree-sha256)" -eq 11485

"$PYTHON" tools/build_pmdred_eu_personality_quiz_flow_fixture.py --output "$FIX"
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
env "${PMDO_ENV[@]}" PMDO_NARRATIVE_VALIDATOR=pmdred_eu_personality_quiz_flow \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_personality_quiz_fixture --events "$EVENTS" \
  --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
  --status-json "$FIX/termination.json" --terminal-timeout 180 --reset-events
! grep -qE 'Exception Depth|Could not find value|RUNTIME_FAIL|Lua Trace' "$FIX/runtime.log"
"$PYTHON" tools/validate_pmdred_eu_personality_quiz_flow_runtime.py --fixture "$FIX" --check-only
"$PYTHON" - "$FIX" "$EVIDENCE" <<'PY'
import hashlib, json, sys
from pathlib import Path
fixture, evidence = map(Path, sys.argv[1:])
archived = [json.loads(line) for line in (evidence / 'events.jsonl').read_text().splitlines()]
actual = [json.loads(line) for line in (fixture / 'events.jsonl').read_text().splitlines()]
def semantic(rows):
    return [{key: value for key, value in row.items() if key != 'frame'} for row in rows]
assert semantic(actual) == semantic(archived)
print('PERSONALITY_QUIZ_FLOW_SEMANTIC_TIMELINE_REPRODUCTION_PASS')
expected = json.loads((evidence / 'validation.json').read_text())['captures']['rows']
captures = sorted(
    (fixture / 'appdata/SCREENSHOT').glob('*.png'),
    key=lambda path: (path.stat().st_mtime_ns, path.name),
)
assert len(expected) == len(captures) == 2
assert all(
    row['sha256'] == hashlib.sha256(path.read_bytes()).hexdigest()
    for row, path in zip(expected, captures, strict=True)
)
print('PERSONALITY_QUIZ_FLOW_CAPTURE_HASH_REPRODUCTION_PASS')
PY
python3 tools/verify_pmdred_eu_narrative_migration_guard.py

echo PMDRED_EU_PERSONALITY_QUIZ_FLOW_REPRODUCTION_PASS_INTERACTIVE_INPUT_PARTIAL
