#!/usr/bin/env bash
# Exact create-only recovery and reproduction recipe for the s04 milestone.
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
FIX="$ROOT/.runtime-cache/pmdred-eu-s04-reproduction-fixture"
COMPARE="$ROOT/.runtime-cache/pmdred-eu-s04-reproduction-comparison"
POST_CANDIDATE="$ROOT/.runtime-cache/pmdred-eu-s04-reproduction-promoted-candidate"
POST_FIX="$ROOT/.runtime-cache/pmdred-eu-s04-reproduction-promoted-fixture"
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
test "$(sha256sum "$CANONICAL/grounds/s04.rsground" | cut -d' ' -f1)" = fe2706f208ae738a0d252e3199bf888d9ed86a52beed253902d651be2b3b633d
test "$(sha256sum "$CANONICAL/tiles/s04_Base.tile" | cut -d' ' -f1)" = a88590a282cfd116177d60e0dc828ea2e620e491a7838830c4fc708224b41bc4
"$PYTHON" - <<'PYID'
import json
from pathlib import Path
e=next(x for x in json.loads(Path('docs/pmdred_eu/ground_manifest.json').read_text())['ground_conversion_table']['entries'] if x['stable_ground_id']=='s04')
assert e == {'canonical_debug_id': 237, 'conversion_type': 4, 'debug_string': '__ground_amd_conversion_00237', 'debug_string_address': '0x08279E7C', 'ground_place_id': 37, 'map_file_id': 244, 'map_id': 235, 'stable_ground_id': 's04', 'weather_id': -1}
header=Path('.runtime-cache/pmd-red-reference/include/constants/ground_map.h').read_text(); assert 'MAP_COUNT' in header and 235 >= 229
print('S04_IDENTITY_PASS map_id=235 map_file_id=244 identity=ROM_EU_POST_ENUM_MAP_ID_235')
PYID

# Create an isolated fixture. Refuse to touch a prior reproduction directory.
test ! -e "$FIX" && test ! -e "$COMPARE"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$CANONICAL" \
  --plan "$PLAN" \
  --ids s04 \
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

# Preserve any pre-existing fixed-path stream before the independent run.
if [[ -e $EVENTS ]]; then
  cp "$EVENTS" "$FIX/preexisting-validator-events.jsonl"
fi
env "${PMDO_ENV[@]}" PMDO_GROUND_VALIDATOR=pmdred_eu_native_fixture \
  "$PYTHON" tools/run_pmdred_eu_pmdo_termination_gate.py \
  --pmdo "$BUNDLE/PMDO" --asset "$FIX/asset" --appdata "$FIX/appdata" \
  --quest pmdred_eu_fixture --runtime-log "$FIX/runtime.log" \
  --event-copy "$FIX/events.jsonl" --status-json "$FIX/termination.json" \
  --reset-events
test "$(wc -l < "$FIX/events.jsonl")" -eq 25
test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name '*.png' | wc -l)" -eq 59
"$PYTHON" - "$FIX/termination.json" <<'PYTERM'
import json,sys
t=json.load(open(sys.argv[1]));x=t['termination']
assert t['terminal_seen'] and t['graceful_exit_requested_by_fixture']
assert t['graceful_exit_observed'] and not t['requested_signal_sent']
assert not t['residual_processes_before_cleanup'] and not t['residual_processes_after_cleanup']
assert x['result']=='PASS' and x['kind']=='NORMAL_EXIT' and x['returncode']==0
assert x['normal_exit'] and not x['segmentation_fault'] and not x['forced_kill']
print('PMDO_NORMAL_UNLOAD_PASS returncode=0')
PYTERM

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
assert r['grounds']==['s04'] and r['sample_count']==2 and len(primary)==1
assert r['exact_sample_count']==2 and r['fully_opaque_sample_count']==2
assert len({s['actual_rgba_sha256'] for s in primary})==1
assert r['all_exact'] and r['all_fully_opaque']
assert rt['all_runtime_safe'] and rt['runtime_sequence_consistent']
assert rt['native_lifecycle_order']['pass'] and rt['all_cleanups_pass']
assert rt['end_event_seen'] and rt['same_ground_reentry_count']==1
assert validations[('s04','primary')]['movement_probe']=='PASS'
assert validations[('s04','primary')]['blocked_probe']=='PASS'
assert validations[('s04','reload')]['load']=='LOAD_PASS'
assert all(s['mismatched_pixels']==0 and s['maximum_channel_delta']==0 for s in r['samples'])
print('S04_EXHAUSTIVE_PASS samples=2 unique_rgba=1 termination=NORMAL_EXIT_0_NO_SIGNAL_NO_SIGSEGV_NO_ORPHANS')
PY

# Post-promotion readback and exact-engine indexing. These are create-only
# ignored fixtures; installed canonical bytes and historical reserve stay intact.
test "$(sha256sum Data/Ground/s04.rsground | cut -d' ' -f1)" = fe2706f208ae738a0d252e3199bf888d9ed86a52beed253902d651be2b3b633d
test "$(sha256sum Content/Tile/s04_Base.tile | cut -d' ' -f1)" = a88590a282cfd116177d60e0dc828ea2e620e491a7838830c4fc708224b41bc4
test ! -e "$POST_CANDIDATE" && test ! -e "$POST_FIX"
mkdir -p "$POST_CANDIDATE/grounds" "$POST_CANDIDATE/tiles"
cp Data/Ground/s04.rsground "$POST_CANDIDATE/grounds/"
cp Content/Tile/s04_Base.tile "$POST_CANDIDATE/tiles/"
cp "$CANONICAL/conversion_report.json" "$POST_CANDIDATE/"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining --candidate-root "$POST_CANDIDATE" --plan "$PLAN" \
  --ids s04 --output "$POST_FIX"
env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$POST_FIX/asset/" -appdata "$POST_FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone >"$POST_FIX/post_promotion_index.log" 2>&1
test "$(sha256sum "$POST_FIX/post_promotion_index.log" | cut -d' ' -f1)" = 3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8

# Add --montage-all to the comparator invocation when all 2 comparative PNGs,
# rather than the three durable representative captures, are desired.
