#!/usr/bin/env bash
# Reproduce a real title-screen New Game and its normal New Era story handoff.
set -euo pipefail
IFS=$'\n\t'
ROOT=$(git rev-parse --show-toplevel);cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/new-game-full-regression-fixture"
EVENTS=/tmp/new_game_full_regression.jsonl
EVIDENCE="$ROOT/docs/pmdred_eu/narrative_migration/startup_regression/runtime"
python3 tools/verify_pmdred_eu_narrative_migration_guard.py
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/DumpAsset.tree-sha256 | cut -d' ' -f1)" = 42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
"$PYTHON" tools/build_new_game_full_regression_fixture.py --output "$FIX"
PMDO_ENV=(
 DOTNET_BUNDLE_EXTRACT_BASE_DIR="$DOTNET_EXTRACT" LD_LIBRARY_PATH="$BUNDLE"
 SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy
 SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so"
 PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 PMDO_HEADLESS_DISMISS_SPLASH=1
 FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 ANGLE_DEFAULT_PLATFORM=vulkan
 VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json"
)
env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
 -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
 -quest pmdred_eu_narrative_fixture -index zone >"$FIX/index.log" 2>&1
! grep -qE 'Could not deserialize|Error importing|Exception Depth' "$FIX/index.log"
env "${PMDO_ENV[@]}" PMDO_NEW_GAME_VALIDATOR=full_title_flow \
 "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
 --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
 --quest pmdred_eu_narrative_fixture --events "$EVENTS" \
 --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
 --status-json "$FIX/termination.json" --terminal-timeout 300 --reset-events
! grep -qE 'Exception Depth|Could not find value|RUNTIME_FAIL|Lua Trace' "$FIX/runtime.log"
! grep -qE 'PMDRED_EU|PERSONALITY_QUIZ|QUIZ_' "$FIX/runtime.log"
DIAGNOSTIC_LOG=$(find "$FIX/appdata/LOG" -type f -name '*.txt' -print -quit)
test -n "$DIAGNOSTIC_LOG"
if grep -q 'RegisterMonster(string) only registers form 0' "$DIAGNOSTIC_LOG"; then
  grep -n 'RegisterMonster(string) only registers form 0' "$DIAGNOSTIC_LOG"
  exit 1
fi
"$PYTHON" tools/validate_new_game_startup_regression.py --fixture "$FIX" --check-only
"$PYTHON" - "$FIX" "$EVIDENCE" <<'PY'
import json,sys
from pathlib import Path
from PIL import Image
fixture,evidence=map(Path,sys.argv[1:])
def load(path):return [json.loads(line) for line in path.read_text().splitlines()]
def semantic(rows):
 return [{k:v for k,v in row.items() if k not in {'frame','menu_identity','replay_count','replay_index'}} for row in rows]
assert semantic(load(fixture/'events.jsonl'))==semantic(load(evidence/'events.jsonl'))
actual=Image.open(next((fixture/'appdata/SCREENSHOT').glob('*.png'))).convert('RGB')
assert actual.size==(1512,1512)
assert len(actual.getcolors(maxcolors=actual.width*actual.height) or [])>100
print('NEW_GAME_STARTUP_SEMANTIC_AND_CAPTURE_REPRODUCTION_PASS')
PY
python3 tools/test_new_game_startup_regression.py
python3 tools/verify_pmdred_eu_narrative_migration_guard.py
echo NEW_GAME_STARTUP_REGRESSION_REPRODUCTION_PASS_NORMAL_NEW_ERA_FLOW
