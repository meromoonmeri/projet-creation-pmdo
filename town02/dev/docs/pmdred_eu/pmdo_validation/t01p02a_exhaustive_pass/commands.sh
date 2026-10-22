#!/usr/bin/env bash
# Exact recovery/validation recipe for the t01p02a milestone.
# Run from the repository root after restoring ignored .runtime-cache inputs.
# The validator writes to /tmp/pmdred_eu_ground_validator.jsonl; its environment
# variable does not relocate that stream.
set -euo pipefail

PYTHON=.runtime-cache/test-venv/bin/python
ROOT=$PWD
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
FIX="$ROOT/.runtime-cache/pmdred-eu-t01p02a-full-fixture"
CANONICAL="$ROOT/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
PLAN="$ROOT/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$ROOT/.runtime-cache/pmdred-eu-ground"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl
COMPARE="$ROOT/.runtime-cache/pmdred-eu-t01p02a-full-comparison"

# Authority and exact-subject gates.
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 9fc8bcf5838419a8e5cc2db7f51a2f1291ed1c54c942fa0348b71ac76e66d1cb
test "$(sha256sum .runtime-cache/downloads/pmdred-eu.gba | cut -d' ' -f1)" = 0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd
test "$(sha256sum "$PLAN" | cut -d' ' -f1)" = dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
test "$(sha256sum "$CANONICAL/conversion_report.json" | cut -d' ' -f1)" = 91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc
test "$(sha256sum "$CANONICAL/grounds/t01p02a.rsground" | cut -d' ' -f1)" = a6fddda0dd6b7f87e10e8feca8c951cd682c51de5aecae03fd4013f4a9b0e742
test "$(sha256sum "$CANONICAL/tiles/t01p02a_Base.tile" | cut -d' ' -f1)" = 24b066df18a36171b8f29eaafadf52bc450aba2c4fb558fca40ddc69b35466f4

# Build an isolated fixture from the authenticated bare candidate. The builder
# injects only a deterministic entry marker into its copied Ground; the source
# candidate and its visual/collision/animation payload remain untouched.
rm -rf "$FIX"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$CANONICAL" \
  --plan "$PLAN" \
  --ids t01p02a \
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

rm -f "$EVENTS" "$FIX/events.jsonl"
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
    echo "TERMINAL_SEEN_AT_SECOND=$second"
    kill -TERM -- "-$PMDO_RUN_PID" 2>/dev/null || true
    break
  fi
  kill -0 "$PMDO_RUN_PID" 2>/dev/null || break
  if (( second > 0 && second % 30 == 0 )); then
    event_count=$(wc -l < "$EVENTS" 2>/dev/null || printf 0)
    screenshot_count=$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name '*.png' | wc -l)
    cpu=$(ps -o %cpu= -p "$PMDO_RUN_PID" 2>/dev/null | tr -d ' ' || true)
    echo "PROGRESS second=$second cpu=${cpu:-exited} events=$event_count screenshots=$screenshot_count"
  fi
  sleep 1
done
wait "$PMDO_RUN_PID" || true
cleanup
(( TERMINAL_SEEN == 1 ))
grep -q '"event":"end"' "$EVENTS"
cp "$EVENTS" "$FIX/events.jsonl"
test "$(wc -l < "$FIX/events.jsonl")" -eq 2473
test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name '*.png' | wc -l)" -eq 817

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

# Machine-check the complete comparator result rather than relying on log text.
"$PYTHON" - <<'PY'
import json
from pathlib import Path
r=json.loads(Path('.runtime-cache/pmdred-eu-t01p02a-full-comparison/report.json').read_text())
rt=r['runtime']
primary=[s for s in r['samples'] if s['phase'] == 'primary']
validations={(v['ground'],v['phase']):v for v in rt['validations']}
assert r['grounds'] == ['t01p02a']
assert r['sample_count'] == 817 and len(primary) == 816
assert r['exact_sample_count'] == 817
assert r['fully_opaque_sample_count'] == 817
assert len({s['actual_rgba_sha256'] for s in primary}) == 336
assert r['all_exact'] and r['all_fully_opaque']
assert rt['all_runtime_safe'] and rt['runtime_sequence_consistent']
assert rt['native_lifecycle_order']['pass'] and rt['all_cleanups_pass']
assert rt['end_event_seen'] and rt['same_ground_reentry_count'] == 1
assert validations[('t01p02a','primary')]['movement_probe'] == 'PASS'
assert validations[('t01p02a','primary')]['blocked_probe'] == 'PASS'
assert validations[('t01p02a','reload')]['load'] == 'LOAD_PASS'
assert all(sample['mismatched_pixels'] == 0 for sample in r['samples'])
assert all(sample['maximum_channel_delta'] == 0 for sample in r['samples'])
print('T01P02A_EXHAUSTIVE_PASS samples=817 unique_rgba=336')
PY

# Post-promotion integration: prove that the read-back destinations still equal
# the tested candidate, that the zone edit is one BOM-preserving insertion, and
# that exact PMDO can index a fresh fixture built from those promoted bytes.
test "$(sha256sum Data/Ground/t01p02a.rsground | cut -d' ' -f1)" = a6fddda0dd6b7f87e10e8feca8c951cd682c51de5aecae03fd4013f4a9b0e742
test "$(sha256sum Content/Tile/t01p02a_Base.tile | cut -d' ' -f1)" = 24b066df18a36171b8f29eaafadf52bc450aba2c4fb558fca40ddc69b35466f4
"$PYTHON" - <<'PY'
import json, subprocess
from pathlib import Path
p=Path('Data/Zone/master_zone.json')
assert p.read_bytes().startswith(b'\xef\xbb\xbf')
now=json.loads(p.read_text(encoding='utf-8-sig'))['Object']['GroundMaps']
old=json.loads(subprocess.check_output(['git','show','c0e56bb1de583d41b3657bb7cb8908d3b1ad1281:Data/Zone/master_zone.json']).decode('utf-8-sig'))['Object']['GroundMaps']
i=now.index('t01p02a')
assert len(now)==194 and now.count('t01p02a')==1 and now[i-1]=='t01p01'
assert now[:i]+now[i+1:]==old
assert now.count('sky_eos_t01p02a')==1
print('T01P02A_ZONE_INTEGRATION_PASS canonical_index=%d eos_index=%d'%(i,now.index('sky_eos_t01p02a')))
PY
POST_CANDIDATE="$ROOT/.runtime-cache/pmdred-eu-t01p02a-promoted-candidate"
POST_FIX="$ROOT/.runtime-cache/pmdred-eu-t01p02a-promoted-integration-fixture"
rm -rf "$POST_CANDIDATE" "$POST_FIX"
mkdir -p "$POST_CANDIDATE/grounds" "$POST_CANDIDATE/tiles"
cp Data/Ground/t01p02a.rsground "$POST_CANDIDATE/grounds/"
cp Content/Tile/t01p02a_Base.tile "$POST_CANDIDATE/tiles/"
cp "$CANONICAL/conversion_report.json" "$POST_CANDIDATE/"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$POST_CANDIDATE" \
  --plan "$PLAN" \
  --ids t01p02a \
  --output "$POST_FIX"
env "${PMDO_ENV[@]}" \
  timeout 300s "$BUNDLE/PMDO" \
  -asset "$POST_FIX/asset/" -appdata "$POST_FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone 2>&1 | tee "$POST_FIX/post-promotion-index.log"

# To materialize side-by-side PNGs for every sample on a reproduction run,
# repeat the comparator command with --montage-all into an ignored output tree.
