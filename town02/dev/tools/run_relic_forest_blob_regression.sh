#!/usr/bin/env bash
# Reproduce the PMDO 0.8.12 Relic Forest LoadBlobStep dependency fix.
set -euo pipefail
IFS=$'\n\t'

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
FIX="$ROOT/.runtime-cache/relic-forest-blob-fixture"
EVENTS=/tmp/relic_forest_blob_probe.jsonl

python3 tools/verify_pmdred_eu_narrative_migration_guard.py
python3 tools/test_relic_forest_blob_dependencies.py

test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/DumpAsset.tree-sha256 | cut -d' ' -f1)" = 42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
test "$(wc -l < .runtime-cache/DumpAsset.tree-sha256)" -eq 11485

"$PYTHON" tools/build_relic_forest_blob_fixture.py --output "$FIX"

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

env "${PMDO_ENV[@]}" PMDO_RELIC_FOREST_BLOB_PROBE=1 \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_narrative_fixture --events "$EVENTS" \
  --runtime-log "$FIX/runtime.log" --event-copy "$FIX/events.jsonl" \
  --status-json "$FIX/termination.json" --terminal-timeout 120 --reset-events

for map_id in \
  relic_forest_blob_broken_pillar relic_forest_blob_fallen_left \
  relic_forest_blob_fallen_right relic_forest_blob_pillar \
  relic_forest_blob_rubble relic_forest_blob_ruins; do
  grep -q "\[RELIC_FOREST_BLOB_PROBE\] resolved $map_id" "$FIX/runtime.log"
done
grep -q '\[RELIC_FOREST_BLOB_PROBE\] floor generated' "$FIX/runtime.log"
grep -q '\[RELIC_FOREST_BLOB_PROBE\] PASS' "$FIX/runtime.log"
grep -q 'TeamAttachee=NON (transition avant DungeonMapInit, normale)' "$FIX/runtime.log"

DIAGNOSTIC_LOG=$(find "$FIX/appdata/LOG" -type f -name '*.txt' -print -quit)
test -n "$DIAGNOSTIC_LOG"
if grep -qE 'Missing Data|FileNotFoundException|Exception Depth|Lua Trace|RUNTIME_FAIL|ÔÇö' "$FIX/runtime.log" "$DIAGNOSTIC_LOG"; then
  grep -nE 'Missing Data|FileNotFoundException|Exception Depth|Lua Trace|RUNTIME_FAIL|ÔÇö' "$FIX/runtime.log" "$DIAGNOSTIC_LOG"
  exit 1
fi

python3 tools/test_relic_forest_blob_dependencies.py
python3 tools/verify_pmdred_eu_narrative_migration_guard.py

echo RELIC_FOREST_BLOB_REGRESSION_REPRODUCTION_PASS
