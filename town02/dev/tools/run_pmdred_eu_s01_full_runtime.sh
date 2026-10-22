#!/usr/bin/env bash
# Run the opt-in complete PMD Red EU s01 continuation in an ignored PMDO fixture.
set -euo pipefail
IFS=$'\n\t'
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/pmdred-eu-s01-full-fixture"
EVENTS=/tmp/pmdred_eu_s01_full.jsonl

"$PYTHON" tools/build_pmdred_eu_s01_full_fixture.py --output "$FIX"
rm -f "$FIX/index.log" "$FIX/runtime.log" "$FIX/events.jsonl" "$FIX/termination.json" "$EVENTS"

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

env "${PMDO_ENV[@]}" "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_narrative_fixture -index zone >"$FIX/index.log" 2>&1
if grep -qE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace' "$FIX/index.log"; then
  grep -nE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace' "$FIX/index.log"
  exit 1
fi

env "${PMDO_ENV[@]}" PMDO_S01_FULL_VALIDATOR=1 \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_narrative_fixture --events "$EVENTS" \
  --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
  --status-json "$FIX/termination.json" --terminal-timeout 900 \
  --graceful-exit-timeout 45 --reset-events

"$PYTHON" tools/validate_pmdred_eu_s01_full_runtime.py \
  --fixture "$FIX" \
  --output docs/pmdred_eu/narrative_migration/scenes/s01/full_runtime/validation.json

echo PMDRED_EU_S01_FULL_RUNTIME_PASS_DORMANT
