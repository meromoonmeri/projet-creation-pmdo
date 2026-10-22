#!/usr/bin/env bash
# Reproduce the PMDO 0.8.12 Zone index and spiritomb_room resolution fix.
set -euo pipefail
IFS=$'\n\t'

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/zone-deserialization-fixture"
EVENTS=/tmp/pmdo_0812_zone_deserialization.jsonl

python3 tools/verify_pmdred_eu_narrative_migration_guard.py
python3 tools/test_pmdo_0812_log_regressions.py

test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/DumpAsset.tree-sha256 | cut -d' ' -f1)" = 42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
test "$(wc -l < .runtime-cache/DumpAsset.tree-sha256)" -eq 11485

"$PYTHON" tools/build_zone_deserialization_fixture.py --output "$FIX"

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

env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 600 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_narrative_fixture -index zone >"$FIX/index.log" 2>&1
if grep -qE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace' "$FIX/index.log"; then
  grep -nE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace' "$FIX/index.log"
  exit 1
fi

env "${PMDO_ENV[@]}" PMDO_ZONE_DESERIALIZATION_PROBE=1 \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_narrative_fixture --events "$EVENTS" \
  --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
  --status-json "$FIX/termination.json" --terminal-timeout 120 --reset-events

grep -q '\[ZONE_DESERIALIZATION_PROBE\] PASS' "$FIX/runtime.log"
for zone in chasm_cave dark_hill dusk_forest sealed_ruin sealed_ruin_pit spiritomb_room; do
  grep -q "\[ZONE_DESERIALIZATION_PROBE\] resolved $zone" "$FIX/runtime.log"
done
if grep -qE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace|RegisterMonster\(string\)' "$FIX/runtime.log"; then
  grep -nE 'Could not deserialize|Error importing|Missing Data|Exception Depth|Lua Trace|RegisterMonster\(string\)' "$FIX/runtime.log"
  exit 1
fi
DIAGNOSTIC_LOG=$(find "$FIX/appdata/LOG" -type f -name '*.txt' -print -quit)
test -n "$DIAGNOSTIC_LOG"
if grep -qE 'Could not deserialize|Error importing|Missing Data: spiritomb_room|Exception Depth|DevTabTravelViewModel|RegisterMonster\(string\)' "$DIAGNOSTIC_LOG"; then
  grep -nE 'Could not deserialize|Error importing|Missing Data: spiritomb_room|Exception Depth|DevTabTravelViewModel|RegisterMonster\(string\)' "$DIAGNOSTIC_LOG"
  exit 1
fi

python3 tools/test_pmdo_0812_log_regressions.py
python3 tools/verify_pmdred_eu_narrative_migration_guard.py

echo PMDO_0812_ZONE_DESERIALIZATION_REPRODUCTION_PASS
