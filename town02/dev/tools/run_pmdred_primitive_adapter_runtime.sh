#!/usr/bin/env bash
# Build and execute the dormant primitive adapters in exact headless PMDO 0.8.12.
set -euo pipefail
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
FIX=${1:-$ROOT/.runtime-cache/pmdred-primitive-adapter-runtime}
BUNDLE=$ROOT/.runtime-cache/pmdo-headless-bundle
PYTHON=$ROOT/.runtime-cache/test-venv/bin/python
EVENTS=/tmp/pmdred_primitive_adapter_validator.jsonl
[[ ! -e $FIX ]] || { echo "ERROR: create-only fixture exists: $FIX" >&2; exit 2; }

"$PYTHON" tools/build_pmdred_primitive_adapter_runtime_fixture.py \
  --candidate-root .runtime-cache/pmdred-eu-remaining-regenerated-v201 \
  --plan .runtime-cache/pmdred-eu-reference-plan-v2.json \
  --output "$FIX"

runtime_env=(
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$ROOT/.runtime-cache/dotnet-headless"
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

env "${runtime_env[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone >"$FIX/index.log" 2>&1

rm -f "$EVENTS"
setsid env "${runtime_env[@]}" \
  PMDO_PRIMITIVE_ADAPTER_VALIDATOR=pmdred_eu_exact_0812 \
  timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture >"$FIX/runtime.log" 2>&1 &
PID=$!
TERMINAL_SEEN=0
for ((second=0; second<300; second++)); do
  if grep -q '"event":"end"' "$EVENTS" 2>/dev/null; then
    TERMINAL_SEEN=1
    kill -TERM -- "-$PID" 2>/dev/null || true
    break
  fi
  kill -0 "$PID" 2>/dev/null || break
  sleep 1
done
wait "$PID" || true
if kill -0 -- "-$PID" 2>/dev/null; then
  kill -KILL -- "-$PID" 2>/dev/null || true
fi
(( TERMINAL_SEEN == 1 ))
cp "$EVENTS" "$FIX/events.jsonl"

"$PYTHON" tools/validate_pmdred_primitive_adapter_runtime.py \
  --events "$FIX/events.jsonl" \
  --index-log "$FIX/index.log" \
  --runtime-log "$FIX/runtime.log" \
  --fixture-manifest "$FIX/primitive_adapter_fixture_manifest.json" \
  --module Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua \
  --pmdo "$BUNDLE/PMDO" \
  --output "$FIX/validation.json"

echo "PMD_RED_PRIMITIVE_ADAPTER_RUNTIME_PASS $FIX"
