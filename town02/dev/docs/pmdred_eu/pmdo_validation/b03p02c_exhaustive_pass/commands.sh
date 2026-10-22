#!/usr/bin/env bash
# Exact create-only recovery and reproduction recipe for the b03p02c milestone.
# Run from the repository root. Existing worktree assets are never removed or
# overwritten. PMDO's validator stream has a fixed /tmp path in engine 0.8.12.
set -euo pipefail

ROOT=$PWD
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
CANONICAL="$ROOT/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
PLAN="$ROOT/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$ROOT/.runtime-cache/pmdred-eu-ground"
FIX="$ROOT/.runtime-cache/pmdred-eu-b03p02c-reproduction-fixture"
COMPARE="$ROOT/.runtime-cache/pmdred-eu-b03p02c-reproduction-comparison"
POST_CANDIDATE="$ROOT/.runtime-cache/pmdred-eu-b03p02c-reproduction-promoted-candidate"
POST_FIX="$ROOT/.runtime-cache/pmdred-eu-b03p02c-reproduction-promoted-fixture"
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl

# Authenticated create-only restoration. Existing components are verified and a
# mismatching path aborts; the script never replaces it.
bash tools/restore_pmdred_eu_validation_runtime.sh

# Direct authority and exact-subject gates.
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/downloads/pmdred-eu.gba | cut -d' ' -f1)" = 0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd
test "$(sha256sum "$PLAN" | cut -d' ' -f1)" = dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
test "$(sha256sum "$CANONICAL/conversion_report.json" | cut -d' ' -f1)" = 91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc
test "$(sha256sum "$CANONICAL/grounds/b03p02c.rsground" | cut -d' ' -f1)" = a386e03bbbac02882c2a1fa109cb5b62cff896eddd68e3c3cc04c0e67e3c551a
test "$(sha256sum "$CANONICAL/tiles/b03p02c_Base.tile" | cut -d' ' -f1)" = ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142
"$PYTHON" - <<'PYID'
import json
from pathlib import Path
entry=next(x for x in json.loads(Path('docs/pmdred_eu/ground_manifest.json').read_text())['ground_conversion_table']['entries'] if x['stable_ground_id']=='b03p02c')
assert entry == {'canonical_debug_id': 27, 'conversion_type': 2, 'debug_string': '__ground_amd_conversion_00027', 'debug_string_address': '0x0827B77C', 'ground_place_id': 11, 'map_file_id': 28, 'map_id': 27, 'stable_ground_id': 'b03p02c', 'weather_id': -1}
header=Path('.runtime-cache/pmd-red-reference/include/constants/ground_map.h').read_text()
assert 'MAP_TEAM_BASE_SKITTY_BASIC' in header
print('B03P02C_IDENTITY_PASS map_id=27 map_file_id=28 symbol=MAP_TEAM_BASE_SKITTY_BASIC')
PYID

# Create an isolated fixture. Refuse to touch a prior reproduction directory.
test ! -e "$FIX" && test ! -e "$COMPARE"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$CANONICAL" \
  --plan "$PLAN" \
  --ids b03p02c \
  --output "$FIX"

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
  -quest pmdred_eu_fixture -index zone >"$FIX/index.log" 2>&1
test "$(sha256sum "$FIX/index.log" | cut -d' ' -f1)" = 3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8

# Preserve any pre-existing fixed-path stream before starting this independent
# run, then reset only that temporary stream (never a repository asset).
if [[ -e $EVENTS ]]; then
  cp "$EVENTS" "$FIX/preexisting-validator-events.jsonl"
  rm "$EVENTS"
fi
PMDO_RUN_PID=""
cleanup() {
  if [[ -n $PMDO_RUN_PID ]] && kill -0 -- "-$PMDO_RUN_PID" 2>/dev/null; then
    kill -TERM -- "-$PMDO_RUN_PID" 2>/dev/null || true
    sleep 1
    kill -KILL -- "-$PMDO_RUN_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT
trap 'exit 143' TERM INT
setsid env "${PMDO_ENV[@]}" PMDO_GROUND_VALIDATOR=pmdred_eu_native_fixture \
  timeout --signal=TERM --kill-after=5 1800 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture >"$FIX/runtime.log" 2>&1 &
PMDO_RUN_PID=$!
TERMINAL_SEEN=0
for ((second=0; second<1800; second++)); do
  if grep -q '"event":"end"' "$EVENTS" 2>/dev/null; then
    TERMINAL_SEEN=1
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
cp "$EVENTS" "$FIX/events.jsonl"
test "$(wc -l < "$FIX/events.jsonl")" -eq 28
test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name '*.png' | wc -l)" -eq 2

mkdir "$COMPARE"
"$PYTHON" tools/compare_pmdred_eu_pmdo_renders.py \
  --events "$FIX/events.jsonl" \
  --screenshots "$FIX/appdata/SCREENSHOT" \
  --reference-plan "$PLAN" \
  --source-dir "$SOURCE" \
  --conversion-report "$CANONICAL/conversion_report.json" \
  --output "$COMPARE" \
  --report "$COMPARE/report.json" \
  --workers 2 2>&1 | tee "$COMPARE/comparison.log"

# Machine-check the entire result, not only the selected durable PNGs.
"$PYTHON" - "$COMPARE/report.json" <<'PY'
import json, sys
from pathlib import Path
r=json.loads(Path(sys.argv[1]).read_text())
rt=r['runtime']; primary=[s for s in r['samples'] if s['phase']=='primary']
validations={(v['ground'],v['phase']):v for v in rt['validations']}
assert r['grounds']==['b03p02c'] and r['sample_count']==2 and len(primary)==1
assert r['exact_sample_count']==2 and r['fully_opaque_sample_count']==2
assert len({s['actual_rgba_sha256'] for s in primary})==1
assert r['all_exact'] and r['all_fully_opaque']
assert rt['all_runtime_safe'] and rt['runtime_sequence_consistent']
assert rt['native_lifecycle_order']['pass'] and rt['all_cleanups_pass']
assert rt['end_event_seen'] and rt['same_ground_reentry_count']==1
assert validations[('b03p02c','primary')]['movement_probe']=='PASS'
assert validations[('b03p02c','primary')]['blocked_probe']=='PASS'
assert validations[('b03p02c','reload')]['load']=='LOAD_PASS'
assert all(s['mismatched_pixels']==0 and s['maximum_channel_delta']==0 for s in r['samples'])
print('B03P02C_EXHAUSTIVE_PASS samples=2 unique_rgba=1')
PY

# Post-promotion readback and exact-engine indexing. These are create-only
# ignored fixtures; installed canonical bytes and historical reserve stay intact.
test "$(sha256sum Data/Ground/b03p02c.rsground | cut -d' ' -f1)" = a386e03bbbac02882c2a1fa109cb5b62cff896eddd68e3c3cc04c0e67e3c551a
test "$(sha256sum Content/Tile/b03p02c_Base.tile | cut -d' ' -f1)" = ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142
test ! -e "$POST_CANDIDATE" && test ! -e "$POST_FIX"
mkdir -p "$POST_CANDIDATE/grounds" "$POST_CANDIDATE/tiles"
cp Data/Ground/b03p02c.rsground "$POST_CANDIDATE/grounds/"
cp Content/Tile/b03p02c_Base.tile "$POST_CANDIDATE/tiles/"
cp "$CANONICAL/conversion_report.json" "$POST_CANDIDATE/"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining --candidate-root "$POST_CANDIDATE" --plan "$PLAN" \
  --ids b03p02c --output "$POST_FIX"
env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$POST_FIX/asset/" -appdata "$POST_FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone >"$POST_FIX/post_promotion_index.log" 2>&1
test "$(sha256sum "$POST_FIX/post_promotion_index.log" | cut -d' ' -f1)" = 3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8

# Add --montage-all to the comparator invocation when all 2 comparative PNGs,
# rather than the three durable representative captures, are desired.
