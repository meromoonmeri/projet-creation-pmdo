#!/usr/bin/env bash
# Exact recovery/validation recipe used for the exhaustive t01p00 milestone.
# Run from the repository root after restoring the ignored runtime/cache inputs.
set -euo pipefail

PYTHON=.runtime-cache/test-venv/bin/python
BUNDLE="$PWD/.runtime-cache/pmdo-headless-bundle"
FIX="$PWD/.runtime-cache/pmdred-eu-t01p00-full-fixture"
CANDIDATES="$PWD/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
PLAN="$PWD/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$PWD/.runtime-cache/pmdred-eu-ground"
DOTNET_EXTRACT="$PWD/.runtime-cache/dotnet-headless"
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
# The native fixture currently writes this fixed path; PMDO_GROUND_VALIDATOR_EVENTS
# does not relocate it.
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl
COMPARE="$PWD/.runtime-cache/pmdred-eu-t01p00-full-comparison"

# This is a non-destructive adapted extraction. The untouched original extraction
# remains under .runtime-cache/dotnet-custom/; only this separate copy contains
# the SDL built from exact commit 793a0681a92d156733fa3aaa174651dc7345cc5f
# plus tools/patches/pmdo-0.8.12-headless-sdl.patch.
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 9fc8bcf5838419a8e5cc2db7f51a2f1291ed1c54c942fa0348b71ac76e66d1cb
test "$(sha256sum "$PLAN" | cut -d' ' -f1)" = dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
test "$(sha256sum "$CANDIDATES/conversion_report.json" | cut -d' ' -f1)" = 91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc

"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$CANDIDATES" \
  --plan "$PLAN" \
  --ids t01p00 \
  --output "$FIX"

# Both PMDO directory arguments intentionally retain their trailing slash;
# exact PMDO 0.8.12 concatenates these paths internally. Forced ES3 avoids
# FNA3D's desktop-GL load while SDL loads the existing ANGLE EGL library by
# absolute path. ANGLE then renders through the pinned SwiftShader ICD.
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

env "${PMDO_ENV[@]}" \
  timeout 300s "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone 2>&1 | tee "$FIX/index.log"

rm -f "$EVENTS"
rm -rf "$FIX/appdata/SCREENSHOT"
mkdir -p "$FIX/appdata/SCREENSHOT"
# A dedicated session/process group makes post-terminal shutdown include timeout
# and all PMDO descendants rather than leaving an orphaned renderer.
setsid env "${PMDO_ENV[@]}" \
  PMDO_GROUND_VALIDATOR=pmdred_eu_native_fixture \
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
