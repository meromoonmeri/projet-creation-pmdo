#!/usr/bin/env bash
# Exact recovery/validation recipe used for the exhaustive a01p01 milestone.
# Run from the repository root after restoring the ignored runtime/cache inputs.
set -euo pipefail

PYTHON=.runtime-cache/test-venv/bin/python
BUNDLE="$PWD/.runtime-cache/pmdo-headless-bundle"
FIX="$PWD/.runtime-cache/pmdred-eu-a01p01-full-fixture"
CANDIDATES="$PWD/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
PLAN="$PWD/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$PWD/.runtime-cache/pmdred-eu-ground"
# The native fixture currently writes this fixed path; PMDO_GROUND_VALIDATOR_EVENTS
# does not relocate it.
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl
COMPARE="$PWD/.runtime-cache/pmdred-eu-a01p01-full-comparison"

"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$CANDIDATES" \
  --plan "$PLAN" \
  --ids a01p01 \
  --output "$FIX"

# Both PMDO directory arguments intentionally retain their trailing slash;
# exact PMDO 0.8.12 concatenates these paths internally.
env \
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$PWD/.runtime-cache/dotnet-custom" \
  LD_LIBRARY_PATH="$BUNDLE" \
  SDL_VIDEODRIVER=offscreen \
  SDL_AUDIODRIVER=dummy \
  PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 \
  PMDO_HEADLESS_DISMISS_SPLASH=1 \
  FNA3D_FORCE_DRIVER=OpenGL \
  ANGLE_DEFAULT_PLATFORM=vulkan \
  VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
  timeout 300s "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone 2>&1 | tee "$FIX/index.log"

rm -f "$EVENTS"
rm -rf "$FIX/appdata/SCREENSHOT"
mkdir -p "$FIX/appdata/SCREENSHOT"
# A dedicated session/process group makes post-terminal shutdown include timeout
# and all PMDO descendants rather than leaving an orphaned renderer.
setsid env \
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$PWD/.runtime-cache/dotnet-custom" \
  LD_LIBRARY_PATH="$BUNDLE" \
  SDL_VIDEODRIVER=offscreen \
  SDL_AUDIODRIVER=dummy \
  PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 \
  PMDO_HEADLESS_DISMISS_SPLASH=1 \
  PMDO_GROUND_VALIDATOR=pmdred_eu_native_fixture \
  FNA3D_FORCE_DRIVER=OpenGL \
  ANGLE_DEFAULT_PLATFORM=vulkan \
  VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
  timeout 7200s "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture >"$FIX/runtime.log" 2>&1 &
PMDO_RUN_PID=$!
TERMINAL_SEEN=0
for ((second=0; second<7200; second++)); do
  if grep -q '"event":"end"' "$EVENTS" 2>/dev/null; then
    TERMINAL_SEEN=1
    kill -TERM -- "-$PMDO_RUN_PID" 2>/dev/null || true
    break
  fi
  kill -0 "$PMDO_RUN_PID" 2>/dev/null || break
  sleep 1
done
wait "$PMDO_RUN_PID" || true
if kill -0 -- "-$PMDO_RUN_PID" 2>/dev/null; then
  kill -KILL -- "-$PMDO_RUN_PID" 2>/dev/null || true
fi
(( TERMINAL_SEEN == 1 ))
grep -q '"event":"end"' "$EVENTS"
cp "$EVENTS" "$FIX/events.jsonl"

rm -rf "$COMPARE"
mkdir -p "$COMPARE"
"$PYTHON" tools/compare_pmdred_eu_pmdo_renders.py \
  --events "$FIX/events.jsonl" \
  --screenshots "$FIX/appdata/SCREENSHOT" \
  --reference-plan "$PLAN" \
  --source-dir "$SOURCE" \
  --conversion-report "$CANDIDATES/conversion_report.json" \
  --output "$COMPARE" \
  --report "$COMPARE/report.json" \
  --workers 2 2>&1 | tee "$COMPARE/comparison.log"
