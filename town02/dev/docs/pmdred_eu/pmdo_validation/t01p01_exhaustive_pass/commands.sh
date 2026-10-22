#!/usr/bin/env bash
# Exact recovery/validation recipe used for the integrated t01p01 milestone.
# Run from the repository root after restoring the ignored runtime/cache inputs.
set -euo pipefail

PYTHON=.runtime-cache/test-venv/bin/python
BUNDLE="$PWD/.runtime-cache/pmdo-headless-bundle"
FIX="$PWD/.runtime-cache/pmdred-eu-t01p01-migrated-fixture"
CANONICAL="$PWD/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
INTEGRATED="$PWD/.runtime-cache/pmdred-eu-t01p01-migrated-candidate"
PLAN="$PWD/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$PWD/.runtime-cache/pmdred-eu-ground"
DOTNET_EXTRACT="$PWD/.runtime-cache/dotnet-headless"
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl
COMPARE="$PWD/.runtime-cache/pmdred-eu-t01p01-migrated-comparison"

# Reconstruct the exact tested integration: authenticated canonical visual,
# collision, and animation data plus only the three preserved project entities.
rm -rf "$INTEGRATED"
mkdir -p "$INTEGRATED/grounds" "$INTEGRATED/tiles"
cp "$CANONICAL/conversion_report.json" "$INTEGRATED/conversion_report.json"
cp "$CANONICAL/tiles/t01p01_Base.tile" "$INTEGRATED/tiles/t01p01_Base.tile"
"$PYTHON" - <<'PY'
import json
from pathlib import Path
canonical = Path('.runtime-cache/pmdred-eu-remaining-regenerated-v201/grounds/t01p01.rsground')
legacy = Path('RESERVE/pmdred_pre_promotion/t01p01/t01p01.rsground')
output = Path('.runtime-cache/pmdred-eu-t01p01-migrated-candidate/grounds/t01p01.rsground')
base = json.loads(canonical.read_text(encoding='utf-8-sig'))
old = json.loads(legacy.read_text(encoding='utf-8-sig'))
base_entities = base['Object']['Entities'][0]
old_entities = old['Object']['Entities'][0]
assert base_entities['Markers'] == [] and base_entities['Spawners'] == []
assert base_entities['MapChars'] == old_entities['MapChars'] == []
assert base_entities['GroundObjects'] == old_entities['GroundObjects'] == []
assert len(old_entities['Markers']) == 2 and len(old_entities['Spawners']) == 1
base_entities['Markers'] = old_entities['Markers']
base_entities['Spawners'] = old_entities['Spawners']
output.write_text(
    '\ufeff' + json.dumps(base, ensure_ascii=False, separators=(',', ':')),
    encoding='utf-8',
)
PY

test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 9fc8bcf5838419a8e5cc2db7f51a2f1291ed1c54c942fa0348b71ac76e66d1cb
test "$(sha256sum "$PLAN" | cut -d' ' -f1)" = dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
test "$(sha256sum "$CANONICAL/conversion_report.json" | cut -d' ' -f1)" = 91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc
test "$(sha256sum "$CANONICAL/grounds/t01p01.rsground" | cut -d' ' -f1)" = 8626f4b563697c5b4fc7dd387d3cfec7f1c337ea18c8b2cf75b2f6bd920f293c
test "$(sha256sum "$INTEGRATED/grounds/t01p01.rsground" | cut -d' ' -f1)" = f1677cd5e68eb0d78cd5073171b528cc9263ef8484825438105cb9fad92964d6
test "$(sha256sum "$INTEGRATED/tiles/t01p01_Base.tile" | cut -d' ' -f1)" = 355a21a503224e5807b2b3265e4487161f217d0478d745dc71974f735648c301

"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$INTEGRATED" \
  --canonical-baseline-root "$CANONICAL" \
  --entity-integrated-ids t01p01 \
  --plan "$PLAN" \
  --ids t01p01 \
  --output "$FIX"

# PMDO loads its extracted SDL by absolute path. Both ANGLE library paths are
# required: GL for libGLESv2 and EGL for libEGL. Trailing slashes are intentional.
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
PMDO_RUN_PID=""
cleanup() {
  if [[ -n "$PMDO_RUN_PID" ]] && kill -0 -- "-$PMDO_RUN_PID" 2>/dev/null; then
    kill -TERM -- "-$PMDO_RUN_PID" 2>/dev/null || true
    sleep 1
    kill -KILL -- "-$PMDO_RUN_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT
trap 'exit 143' TERM INT
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
cleanup
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
  --conversion-report "$CANONICAL/conversion_report.json" \
  --output "$COMPARE" \
  --report "$COMPARE/report.json" \
  --workers 2 2>&1 | tee "$COMPARE/comparison.log"
